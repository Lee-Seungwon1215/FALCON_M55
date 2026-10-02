#!/usr/bin/env python3
"""Check the actual addresses, not just identical linker option strings."""
import hashlib
import json
from pathlib import Path
import subprocess
import sys
sys.dont_write_bytecode=True
import run

ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def symbols(elf):
    text=subprocess.check_output([str(run.TOOL/'arm-none-eabi-nm'),'-n','-S',str(elf)],text=True)
    allsym={};sized=[]
    for line in text.splitlines():
        t=line.split()
        if len(t)==3:
            addr,kind,name=t;allsym[name]=int(addr,16)
        elif len(t)==4:
            addr,size,kind,name=t;allsym[name]=int(addr,16)
            sized.append((name,kind,int(addr,16),int(size,16)))
    return allsym,sized

spec=run.verify_sources()
mode=sys.argv[1] if len(sys.argv)>1 else 'sign'
assert mode in ('sign','keyverify')
builds={v:ROOT/'build'/(v+'_'+mode) for v in run.VARIANTS}
elfs={v:p/'zephyr/zephyr.elf' for v,p in builds.items()}
for name in ('zephyr/.config','fndsa_dtcm_linker.ld'):
    assert len({sha(p/name) for p in builds.values()})==1,name
ss={v:symbols(p) for v,p in elfs.items()}
fixed=('__compare_q_start','__compare_mp_start','__compare_fft_start','__compare_ldl_start',
    '__compare_poly_start','__compare_common_text','__compare_ntt_rodata_start','__compare_gm_start',
    '__compare_common_rodata','__text_region_end','__bss_start','_image_ram_end','sk','pk','sig','tmp','samples','z_main_stack')
addresses={}
for name in fixed:
    vals={v:ss[v][0][name] for v in run.VARIANTS}
    assert len(set(vals.values()))==1,(name,vals)
    addresses[name]=hex(next(iter(vals.values())))
functions={v:sorted(t for t in ss[v][1] if t[1] in ('T','t') and t[2]>=ss[v][0]['__compare_common_text']) for v in run.VARIANTS}
data={v:sorted(t for t in ss[v][1] if t[1] in ('R','r','D','d','B','b')
    and ss[v][0]['__compare_common_rodata']<=t[2]<0x30040000) for v in run.VARIANTS}
for v in run.VARIANTS:
    assert functions[v]==functions['ref'],('common function address/size mismatch',v,
        list(set(functions[v])-set(functions['ref']))[:12])
    assert data[v]==data['ref'],('common data address/size mismatch',v,list(set(data[v])-set(data['ref']))[:12])
    gm='fndsa_sign_gm' if v in ('fft_only','ntt_fft') else 'GM'
    assert ss[v][0][gm]==ss[v][0]['__compare_gm_start'],(v,gm)
# When only one factor changes, the other factor's function addresses agree.
for a,b,prefix in (('ref','ntt_only','fndsa_fpoly_'),('fft_only','ntt_fft','fndsa_fpoly_'),
                   ('ref','fft_only','fndsa_mqpoly_'),('ntt_only','ntt_fft','fndsa_mqpoly_')):
    for name in ss[a][0]:
        if name.startswith(prefix):assert ss[a][0][name]==ss[b][0][name],(a,b,name)
used={v:{k:ss[v][0]['__compare_'+k+'_end']-ss[v][0]['__compare_'+k+'_start']
    for k in ('q','mp','fft','ldl','poly','ntt_rodata','gm')} for v in run.VARIANTS}
out=dict(valid=True,elf_sha256={v:sha(p) for v,p in elfs.items()},fixed_addresses=addresses,
    common_functions_fixed=len(functions['ref']),common_data_symbols_fixed=len(data['ref']),slot_usage=used,
    limitations='Unchanged code/data addresses fixed; changed object internal offsets may differ; no formal CT claim.')
name='layout_audit.json' if mode=='sign' else 'layout_audit_keyverify.json'
(ROOT/name).write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps(out,indent=2))
