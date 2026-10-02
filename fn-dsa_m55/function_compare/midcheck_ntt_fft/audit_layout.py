#!/usr/bin/env python3
import hashlib,json,subprocess
from pathlib import Path
HERE=Path(__file__).resolve().parent
TOOL=HERE.parents[1]/'measurement_mlkem_native/env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin/arm-none-eabi-nm'
ss={};elfs={}
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
for v in ('ref','ntt','full'):
 p=HERE/'build'/f'{v}_perf/zephyr/zephyr.elf';elfs[v]=sha(p);s={};sized=[]
 for line in subprocess.check_output([str(TOOL),'-n','-S',str(p)],text=True).splitlines():
  t=line.split()
  if len(t)==3:s[t[2]]=int(t[0],16)
  elif len(t)==4:s[t[3]]=int(t[0],16);sized.append((t[3],t[2],int(t[0],16),int(t[1],16)))
 ss[v]=(s,sized)
fixed={}
for name in ('__mid_ntt_start','__mid_kg_start','__mid_sg_start','__mid_common_text',
 '__mid_common_rodata','__bss_start','_image_ram_end','sk','pk','sig','tmp','samples','sign_samples','z_main_stack'):
 vals={v:ss[v][0][name] for v in ss};assert len(set(vals.values()))==1,(name,vals)
 fixed[name]=hex(next(iter(vals.values())))
common={};data={}
for v,(s,rows) in ss.items():
 common[v]=sorted(t for t in rows if t[1] in ('T','t') and t[2]>=s['__mid_common_text'])
 data[v]=sorted(t for t in rows if t[1] in ('R','r','D','d','B','b') and s['__mid_common_rodata']<=t[2]<0x30040000)
 assert common[v]==common['ref'],('common code',v,list(set(common[v])-set(common['ref']))[:8])
 assert data[v]==data['ref'],('common data',v,list(set(data[v])-set(data['ref']))[:8])
for name in ('zephyr/.config','fndsa_dtcm_linker.ld'):
 assert len({sha(HERE/'build'/f'{v}_perf'/name) for v in ss})==1,name
result=dict(valid=True,elf_sha256=elfs,fixed_addresses=fixed,common_functions=len(common['ref']),common_data=len(data['ref']),
 slots={v:{n:s[0]['__mid_'+n+'_end']-s[0]['__mid_'+n+'_start'] for n in ('ntt','kg','sg','nr','kr','gm')} for v,s in ss.items()},
 limitation='Unchanged objects/functions/data fixed; changed-object internal offsets may differ. Profile image uses unpadded layout and is not the performance comparator.')
(HERE/'layout_audit.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))
