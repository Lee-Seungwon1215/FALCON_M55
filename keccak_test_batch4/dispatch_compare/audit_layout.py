#!/usr/bin/env python3
"""Check crypto function addresses; report residual harness/SDK shifts."""
from pathlib import Path
import json
import re
import subprocess

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
tool=ROOT/'fn-dsa_m55/measurement_mlkem_native/env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin/arm-none-eabi-objdump'
names=('A_four_only','B_three_plus','C_two_plus')
results={}
for op in ('keygen','sign'):
    # Profile ELFs establish call counts, not cross-candidate performance.
    # Their added wrapper positions are deliberately outside this assertion.
    for mode in ('control',):
        rows=[]
        for name in names:
            elf=HERE/'validation/build'/f'{name}_{op}_{mode}_pinned/zephyr/zephyr.elf'
            raw=subprocess.check_output([str(tool),'-t',str(elf)],text=True)
            start=int(re.search(r'^([0-9a-f]+).*\b__dispatch_slot_start$',raw,re.M)[1],16)
            end=int(re.search(r'^([0-9a-f]+).*\b__dispatch_slot_end$',raw,re.M)[1],16)
            functions={n:(int(a,16),int(size,16)) for a,size,n in re.findall(
                r'^([0-9a-f]+)\s+g\s+F\s+\S+\s+([0-9a-f]+)\s+(\S+)$',raw,re.M)
                if not start<=int(a,16)<end}
            constants={n:(int(a,16),int(size,16)) for a,size,n in re.findall(
                r'^([0-9a-f]+)\s+[lg]\s+O\s+rodata\s+([0-9a-f]+)\s+(\S+)$',raw,re.M)
                if n in ('GM_TAB','fndsa_PRIMES','fndsa_fpr_gm_tab','fndsa_fpr_inv_sigma','fndsa_fpr_sigma_min')}
            rows.append(dict(candidate=name,slot=(start,end),functions=functions,constants=constants))
        for row in rows[1:]:
            assert rows[0]['slot']==row['slot']
            assert rows[0]['constants']==row['constants'],('constant address mismatch',op,mode)
            diff={n:(rows[0]['functions'].get(n),row['functions'].get(n)) for n in
                set(rows[0]['functions'])|set(row['functions']) if rows[0]['functions'].get(n)!=row['functions'].get(n)}
            crypto_diff={n:v for n,v in diff.items() if n.startswith(('fndsa_','prefix_fndsa_'))}
            assert not crypto_diff,(op,mode,row['candidate'],crypto_diff)
            row['noncrypto_layout_differences']=diff
        results[op+'_'+mode]=rows
        print(op,mode,'PASS: crypto functions and selected constants at identical addresses;',
            'remaining noncrypto differences=',[len(r.get('noncrypto_layout_differences',{})) for r in rows])
(HERE/'layout_audit.json').write_text(json.dumps(results,indent=2)+'\n')
