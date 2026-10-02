#!/usr/bin/env python3
"""RAM-only, pinned N657 profiling run; preserve all evidence and source hashes."""
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
operation=sys.argv[1]
mode=sys.argv[2]
assert operation in ('keygen','sign')
assert mode in ('control','profile')
build=HERE/'build'/(operation+'_'+mode)
elf=build/'zephyr/zephyr.elf'
commands=json.loads((build/'compile_commands.json').read_text())
for c in commands:
    assert Path(c['file']).stat().st_mtime<=elf.stat().st_mtime,('stale ELF',c['file'])
for p in HERE.iterdir():
    if p.suffix in ('.c','.h','.inc'):
        assert p.stat().st_mtime<=elf.stat().st_mtime,('stale harness',p)
generation=json.loads((build/'generated/sources.json').read_text())
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
for path,digest in generation['original'].items():
    assert sha(Path(path))==digest,('source changed since build',path)
locks=[]
for p in (COMMON/'n657-board.lock',ROOT/'fn-dsa_m55/function_compare/fft_native_fp64/build/board.lock'):
    handle=p.open('a');fcntl.flock(handle,fcntl.LOCK_EX|fcntl.LOCK_NB);locks.append(handle)
out=HERE/'results'/(operation+'_'+mode)/datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ')
out.mkdir(parents=True,exist_ok=False)
hashes={str(Path(c['file'])):sha(Path(c['file'])) for c in commands}
hashes.update(generation['original'])
if operation=='sign':
    keys=HERE.parent/'validation/build/fixtures/keys.h'
    hashes[str(keys)]=sha(keys)
for p in HERE.iterdir():
    if p.is_file():hashes[str(p)]=sha(p)
for p in (build/'generated').rglob('*'):
    if p.is_file():hashes[str(p)]=sha(p)
for p,name in ((elf,'benchmark.elf'),(build/'zephyr/zephyr.map','benchmark.map'),
    (build/'compile_commands.json','compile_commands.json'),(build/'zephyr/.config','zephyr.config'),
    (build/'fndsa_dtcm_linker.ld','linker.ld'),(build/'generated/sources.json','generation.json')):
    shutil.copy2(p,out/name)
(out/'sources.json').write_text(json.dumps(hashes,indent=2)+'\n')
with tarfile.open(out/'sources.tar.gz','w:gz') as ar:
    ar.add(build/'generated',arcname='generated')
    for p in HERE.iterdir():
        if p.is_file():ar.add(p,arcname='harness/'+p.name)
    if operation=='sign':ar.add(keys,arcname='fixtures/keys.h')
tool=COMMON/'env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin'
for arg,name in (('-d','disassembly.txt'),('-h','sections.txt'),('-t','symbols.txt')):
    with (out/name).open('w') as f:
        subprocess.run([str(tool/'arm-none-eabi-objdump'),arg,str(elf)],stdout=f,check=True)
# The wrapper probes must not corrupt vector/FPU state through bookkeeping.
obj=build/'CMakeFiles/app.dir/profile.c.obj'
dis=subprocess.check_output([str(tool/'arm-none-eabi-objdump'),'-d',str(obj)],text=True)
assert not re.search(r'\t[vV][a-z][a-z0-9.]*\s',dis),'FP/MVE in profile bookkeeping'
(out/'profile_disassembly.txt').write_text(dis)
env=os.environ.copy();env.update(FNDSA_LOADER_MODE='upstream',
 MLKEM_NATIVE_PINNED_ROOT=str(COMMON/'env/mlkem-native-637d076aa113d8faaec2277ed4a46b657acaf35f'),
 OPENOCD=str(COMMON/'env/openocd-4e9b167/bin/openocd'),OPENOCD_SERIAL='003C00223335510735383531',
 OPENOCD_SPEED='8000',OPENOCD_TRANSPORT='swd',OPENOCD_INTERFACE='interface/stlink.cfg',
 OPENOCD_TARGET='target/stm32n6x.cfg',OPENOCD_SCRIPTS=str(COMMON/'env/openocd-4e9b167/share/openocd/scripts'),
 GDB_PORT='3359',GDB_RUN_TIMEOUT='900',SWO_TRACECLK='100000000',SWO_PIN_FREQ='1000000',
 SWO_FORMATTER='0',GDB=str(tool/'arm-none-eabi-gdb'),NM=str(tool/'arm-none-eabi-nm'),
 READELF=str(tool/'arm-none-eabi-readelf'),PYTHONDONTWRITEBYTECODE='1')
print('BOARD_START',out,flush=True)
with (out/'raw.log').open('w') as log:
    result=subprocess.run([sys.executable,str(ROOT/'fn-dsa_m55/ntt_final_compare/exec_board.py'),
        '--verbose',str(elf)],env=env,stdout=log,stderr=subprocess.STDOUT)
raw=(out/'raw.log').read_text();clean=re.sub(r'Info : [^\n]*\n','',raw)
errors=[]
if result.returncode:errors.append('runner exit '+str(result.returncode))
for name in ('CFSR','HFSR','AFSR'):
    if re.findall(r'^'+name+r'=(0x[0-9a-f]+)$',clean,re.M)!=['0x0']:errors.append(name)
for phase in ('START','END'):
    if 'TCM_CONTROL_'+phase+'=0x99' not in clean:errors.append('TCM '+phase)
    match=re.search('TCM_MSCR_'+phase+r'=(0x[0-9a-f]+)',clean)
    if not match or int(match[1],16)&0x12!=2:errors.append('ECC '+phase)
counts='keys=88 signatures=0 tamper=0' if operation=='keygen' else 'keys=0 signatures=208 tamper=208'
done=re.search(r'BENCH_DONE result=0 '+counts+r' fingerprint=([0-9a-f]+) profile_error=0',clean)
if not done:errors.append('completion/check counts')
if len(re.findall(r'^PAIR ',clean,re.M))!=(20 if operation=='keygen' else 50):errors.append('pair count')
if len(re.findall(r'^TOTAL ',clean,re.M))!=4:errors.append('total count')
if 'EDGE_STREAM checks=10112 ' not in clean:errors.append('stream boundary checks')
if operation=='keygen' and 'EDGE_KEY mixed_degrees=PASS' not in clean:errors.append('key edge cases')
if operation=='sign':
    if 'EDGE_SIGN byte_exact=16 batch_verified=16' not in clean:errors.append('sign edge cases')
    if len(re.findall(r'^VERIFY_PAIR ',clean,re.M))!=50:errors.append('verify pair count')
if re.search(r'(^FAIL |profile_error=[1-9])',clean,re.M):errors.append('profile or comparison failure')
for path,digest in hashes.items():
    if sha(Path(path))!=digest:errors.append('source changed '+path)
manifest=dict(mode=mode,operation=operation,valid=not errors,errors=errors,
    fingerprint=done[1] if done else None,elf_sha256=sha(out/'benchmark.elf'),raw_sha256=sha(out/'raw.log'))
(out/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
for line in clean.splitlines():
    if re.match(r'(BENCH_|CHECK |FAIL |CALIBRATION |TOTAL |CFSR=|HFSR=|AFSR=)',line):print(line)
print('BOARD_END',out,'errors=',errors,flush=True)
sys.exit(bool(errors))
