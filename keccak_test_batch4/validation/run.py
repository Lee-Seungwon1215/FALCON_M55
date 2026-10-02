"""Pinned N657 runner. Acquires existing board locks, retains ELF/source/log evidence."""
import fcntl
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tarfile
from datetime import datetime, timezone

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
COMMON=ROOT/'fn-dsa_m55/measurement_mlkem_native'
candidate='batch4'
build=HERE/'build'/candidate
elf=build/'zephyr/zephyr.elf'
commands=json.loads((build/'compile_commands.json').read_text())
for c in commands:
    assert Path(c['file']).stat().st_mtime<=elf.stat().st_mtime, ('stale ELF',c['file'])
locks=[]
for p in (COMMON/'n657-board.lock',ROOT/'fn-dsa_m55/function_compare/fft_native_fp64/build/board.lock'):
    f=p.open('a');fcntl.flock(f,fcntl.LOCK_EX|fcntl.LOCK_NB);locks.append(f)
out=HERE/'results'/candidate/datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ')
out.mkdir(parents=True,exist_ok=False)
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
hashes={str(p):sha(p) for p in {Path(c['file']) for c in commands}}
hashes[str(HERE/'build/fixtures/keys.h')]=sha(HERE/'build/fixtures/keys.h')
crypto=ROOT/'keccak_test_batch4'
for p in crypto.iterdir():
    if p.suffix in ('.c','.h','.s'):hashes[str(p)]=sha(p)
for p,name in ((elf,'benchmark.elf'),(build/'zephyr/zephyr.map','benchmark.map'),(build/'compile_commands.json','compile_commands.json')):shutil.copy2(p,out/name)
(out/'sources.json').write_text(json.dumps(hashes,indent=2)+'\n')
shutil.copy2(HERE/'build/fixtures/keys.h',out/'keys.h')
with tarfile.open(out/'sources.tar.gz','w:gz') as ar:
    for p in crypto.iterdir():
        if p.suffix in ('.c','.h','.s'):ar.add(p,arcname='production/'+p.name)
    for p in HERE.iterdir():
        if p.is_file():ar.add(p,arcname='harness/'+p.name)
    ar.add(HERE/'reference',arcname='harness/reference')
tool=COMMON/'env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin'
for arg,name in (('-d','disassembly.txt'),('-h','sections.txt'),('-t','symbols.txt')):
    with (out/name).open('w') as f:subprocess.run([str(tool/'arm-none-eabi-objdump'),arg,str(elf)],stdout=f,check=True)
symbols={}
for line in subprocess.check_output([str(tool/'arm-none-eabi-nm'),'-S',str(elf)],text=True).splitlines():
    cols=line.split()
    if len(cols)==4:symbols[cols[3]]={'address':int(cols[0],16),'size':int(cols[1],16),'kind':cols[2]}
(out/'symbols.json').write_text(json.dumps(symbols,indent=2)+'\n')
linkmap=(out/'benchmark.map').read_text()
env=os.environ.copy();env.update(FNDSA_LOADER_MODE='upstream',
 MLKEM_NATIVE_PINNED_ROOT=str(COMMON/'env/mlkem-native-637d076aa113d8faaec2277ed4a46b657acaf35f'),
 OPENOCD=str(COMMON/'env/openocd-4e9b167/bin/openocd'),OPENOCD_SERIAL='003C00223335510735383531',OPENOCD_SPEED='8000',
 OPENOCD_TRANSPORT='swd',OPENOCD_INTERFACE='interface/stlink.cfg',OPENOCD_TARGET='target/stm32n6x.cfg',
 OPENOCD_SCRIPTS=str(COMMON/'env/openocd-4e9b167/share/openocd/scripts'),GDB_PORT='3359',GDB_RUN_TIMEOUT='900',
 SWO_TRACECLK='100000000',SWO_PIN_FREQ='1000000',SWO_FORMATTER='0',GDB=str(tool/'arm-none-eabi-gdb'),
 NM=str(tool/'arm-none-eabi-nm'),READELF=str(tool/'arm-none-eabi-readelf'),PYTHONDONTWRITEBYTECODE='1')
print('BOARD_START',out,flush=True)
with (out/'raw.log').open('w') as log:
    r=subprocess.run([sys.executable,str(ROOT/'fn-dsa_m55/ntt_final_compare/exec_board.py'),'--verbose',str(elf)],env=env,stdout=log,stderr=subprocess.STDOUT)
raw=(out/'raw.log').read_text();clean=re.sub(r'Info : [^\n]*\n','',raw)
errors=[]
if r.returncode:errors.append('runner exit '+str(r.returncode))
for name in ('CFSR','HFSR','AFSR'):
    if re.findall(r'^'+name+r'=(0x[0-9a-f]+)$',clean,re.M)!=['0x0']:errors.append(name)
for phase in ('START','END'):
    if f'TCM_CONTROL_{phase}=0x99' not in clean:errors.append('TCM '+phase)
    m=re.search('TCM_MSCR_'+phase+r'=(0x[0-9a-f]+)',clean)
    if not m or int(m[1],16)&0x12!=2:errors.append('ECC '+phase)
for marker in ('BENCH_DONE result=0','CHECK streams=PASS','CHECK signatures=PASS','CHECK api=PASS','CHECK new_verify_batch4=PASS verified=1020 rejected=255'):
    if clean.count(marker)!=1:errors.append(marker)
if len(re.findall(r'^BATCH ',clean,re.M))!=240:errors.append('batch sample count')
for path,digest in hashes.items():
    if sha(Path(path))!=digest:errors.append('source changed '+path)
(out/'manifest.json').write_text(json.dumps(dict(candidate=candidate,valid=not errors,errors=errors,elf_sha256=sha(out/'benchmark.elf'),raw_sha256=sha(out/'raw.log')),indent=2)+'\n')
for line in clean.splitlines():
    if re.match(r'(BENCH_|CHECK |FAIL |DIGEST |CFSR=|HFSR=|AFSR=)',line):print(line)
print('BOARD_END',out,'errors=',errors,flush=True)
sys.exit(bool(errors))
