#!/usr/bin/env python3
"""Read-only per-kernel ISA summary and common timing-harness audit.

This is a structural inspection, not a constant-time or ABI proof.
"""
import json
from pathlib import Path
import re
import subprocess
import sys
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT))
from audit import check, BIN, KERNELS

def main():
    result={}
    for layout in ('ab','ba'):
        m=check(layout); elf=ROOT/'build'/layout/'zephyr/zephyr.elf'
        objdump=str(BIN/'arm-none-eabi-objdump')
        rows={}
        for name in KERNELS:
            sym=m['symbols'][name]
            dis=subprocess.check_output([objdump,'-d',f'--start-address={sym["address"]}',
                 f'--stop-address={sym["address"]+sym["size"]}',str(elf)],text=True)
            instructions=[]
            for line in dis.splitlines():
                match=re.match(r'^\s*[0-9a-f]+:\s+(?:[0-9a-f]{4,8}\s+)+\s*([a-z][a-z0-9.]+)\s*(.*)',line)
                if match: instructions.append((match[1],match[2]))
            rows[name]={**sym,'rounded_vector_multiply':sum(op.startswith('vqrdmulh') for op,_ in instructions),
                        'scalar_umull':sum(op=='umull' for op,_ in instructions),
                        'scalar_umlal':sum(op=='umlal' for op,_ in instructions),
                        'call_sites':[op+' '+args for op,args in instructions if op in ('bl','blx')]}
        assert rows['orig_mp_NTT']['scalar_umull']>0
        assert rows['orig_mp_iNTT']['scalar_umull']>0
        assert rows['orig_mp_NTT']['rounded_vector_multiply']==0
        assert rows['orig_mp_iNTT']['rounded_vector_multiply']==0
        for name in KERNELS:
            if name.startswith('opt_'): assert rows[name]['rounded_vector_multiply']>0,name
        # Exactly one machine-code harness per signature; both candidates call it.
        harness=[n for n in m['symbols'] if n.startswith(('time_mq','time_mp'))]
        assert len(harness)==2,harness
        for name in harness:
            dis=subprocess.check_output([objdump,'-d','--disassemble='+name,str(elf)],text=True)
            assert re.search(r'\bblx\s+r\d+',dis), 'kernel call must remain indirect and measured'
            assert 'dsb' in dis and 'isb' in dis
        result[layout]={'kernels':rows,'shared_harnesses':harness,'status':'PASS'}
    (ROOT/'results/kernel_inspection.json').write_text(json.dumps(result,indent=2)+'\n')
    print('PASS per-kernel ISA and shared call harness audit')

if __name__=='__main__':main()
