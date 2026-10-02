#!/usr/bin/env python3
"""Separate controlled-input timing diagnostic; the same single N657 probe."""
import datetime
import fcntl
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys
ROOT=Path(__file__).resolve().parent
lock=(ROOT.parent/'build/board.lock').open('a')
fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB)
M55=ROOT.parents[5];COMMON=M55/'measurement_mlkem_native'
tool=COMMON/'env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin'
elf=ROOT/'build/zephyr/zephyr.elf'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
files=list(ROOT.parent.parent.glob('*.[chs]'))+list(ROOT.glob('*.[ch]'))
files+=list((ROOT/'build/generated').glob('*'))+[elf,ROOT/'build/compile_commands.json',ROOT/'build/zephyr/.config']
snapshot=lambda:{str(p):sha(p) for p in files}
before=snapshot()
out=ROOT/'results'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');out.mkdir(parents=True)
env=os.environ.copy()
env.update(FNDSA_LOADER_MODE='upstream',MLKEM_NATIVE_PINNED_ROOT=str(COMMON/'env/mlkem-native-637d076aa113d8faaec2277ed4a46b657acaf35f'),
    OPENOCD=str(COMMON/'env/openocd-4e9b167/bin/openocd'),OPENOCD_SERIAL='003C00223335510735383531',
    OPENOCD_SPEED='8000',OPENOCD_TRANSPORT='swd',OPENOCD_SCRIPTS=str(COMMON/'env/openocd-4e9b167/share/openocd/scripts'),
    OPENOCD_INTERFACE='interface/stlink.cfg',OPENOCD_TARGET='target/stm32n6x.cfg',GDB_PORT='3359',GDB_RUN_TIMEOUT='1800',
    SWO_TRACECLK='100000000',SWO_PIN_FREQ='1000000',SWO_FORMATTER='0',GDB=str(tool/'arm-none-eabi-gdb'),
    NM=str(tool/'arm-none-eabi-nm'),READELF=str(tool/'arm-none-eabi-readelf'),PYTHONDONTWRITEBYTECODE='1')
cmd=[sys.executable,str(M55/'ntt_final_compare/exec_board.py'),'--verbose',str(elf)]
print('Running CT control:',out,flush=True)
with (out/'raw.log').open('w') as log:r=subprocess.run(cmd,env=env,stdout=log,stderr=subprocess.STDOUT)
text=(out/'raw.log').read_text()
assert r.returncode==0 and 'CT_CONTROL_DONE result=0' in text
assert snapshot()==before
for name in ('CFSR','HFSR','AFSR'):assert re.findall(r'^'+name+r'=(0x[0-9a-f]+)$',text,re.M)==['0x0']
for phase in ('START','END'):
    assert 'TCM_CONTROL_'+phase+'=0x99' in text
    m=re.search('TCM_MSCR_'+phase+r'=(0x[0-9a-f]+)',text);assert m and int(m[1],16)&0x12==2
rows=[dict(zip(('logn','case','backend','min','max'),map(int,x))) for x in re.findall(r'^CT_CONTROL logn=(\d+) case=(\d+) backend=(\d+) min=(\d+) max=(\d+)$',text,re.M)]
assert len(rows)==400
summary=[]
for l in range(1,11):
    for b in range(2):
        group=[x for x in rows if x['logn']==l and x['backend']==b]
        summary.append(dict(logn=l,backend=b,min=min(x['min'] for x in group),max=max(x['max'] for x in group)))
data=dict(valid=True,rows=rows,summary=summary,source_and_build=before,raw_sha256=sha(out/'raw.log'),run_dir=str(out))
(out/'run.json').write_text(json.dumps(data,indent=2)+'\n')
print(json.dumps(summary,indent=2))
