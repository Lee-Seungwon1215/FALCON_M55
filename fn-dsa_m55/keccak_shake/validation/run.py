"""Run the read-only baseline on only the pinned N657, with board locks."""
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
ROOT=HERE.parents[2]
M55=ROOT/'fn-dsa_m55'
COMMON=M55/'measurement_mlkem_native'
variant=sys.argv[1]
assert variant in ('ref','mve')
mode=sys.argv[2] if len(sys.argv)>2 else 'kernel'
suffix=variant if mode=='kernel' else variant+'_'+mode
build=HERE/'build'/suffix
elf=build/'zephyr/zephyr.elf'
spec=json.loads((build/'generated/sources.json').read_text())
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
for name,digest in spec['original_sha256'].items():
    assert sha(Path(name))==digest, ('production changed',name)
for name,digest in spec['generated_sha256'].items():
    assert sha(build/'generated'/name)==digest
audit=json.loads((build/'audit.json').read_text())
assert audit['helpers_byte_identical']
assert audit['source_sha256']==spec['original_sha256'][str(HERE.parent/('sha3_cm4.s' if variant=='ref' else 'sha3_cm55.s'))]
commands=json.loads((build/'compile_commands.json').read_text())
for c in commands:
    assert Path(c['file']).stat().st_mtime<=elf.stat().st_mtime, ('stale ELF',c['file'])
locks=[]
for path in (COMMON/'n657-board.lock',M55/'function_compare/fft_native_fp64/build/board.lock'):
    f=path.open('a')
    fcntl.flock(f,fcntl.LOCK_EX|fcntl.LOCK_NB)
    locks.append(f)
out=HERE/'results'/suffix/datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ')
out.mkdir(parents=True,exist_ok=False)
for src,name in ((elf,'benchmark.elf'),(build/'zephyr/zephyr.map','benchmark.map'),
    (build/'compile_commands.json','compile_commands.json'),(build/'audit.json','audit.json'),
    (build/'generated/sources.json','sources.json')):
    shutil.copy2(src,out/name)
with tarfile.open(out/'sources.tar.gz','w:gz') as archive:
    for p in HERE.iterdir():
        if p.is_file(): archive.add(p,arcname='harness/'+p.name)
    for p in (build/'generated').iterdir():
        if p.is_file(): archive.add(p,arcname='generated/'+p.name)
    for p in HERE.parent.iterdir():
        if p.suffix in ('.c','.h','.s'): archive.add(p,arcname='production/'+p.name)
    if mode!='kernel':
        fixtures=M55/'sep_27_ntrusolve_fft/validation'
        for p in (fixtures/'generated').iterdir():
            if p.is_file(): archive.add(p,arcname='fixtures/generated/'+p.name)
        for c in commands:
            p=Path(c['file'])
            if fixtures in p.parents: archive.add(p,arcname='fixtures/'+str(p.relative_to(fixtures)))
tool=COMMON/'env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin'
for option,name in (('-d','disassembly.txt'),('-h','sections.txt'),('-t','symbols.txt')):
    with (out/name).open('w') as f:
        subprocess.run([str(tool/'arm-none-eabi-objdump'),option,str(elf)],stdout=f,check=True)
env=os.environ.copy()
env.update(FNDSA_LOADER_MODE='upstream',
    MLKEM_NATIVE_PINNED_ROOT=str(COMMON/'env/mlkem-native-637d076aa113d8faaec2277ed4a46b657acaf35f'),
    OPENOCD=str(COMMON/'env/openocd-4e9b167/bin/openocd'),
    OPENOCD_SERIAL='003C00223335510735383531',OPENOCD_SPEED='8000',
    OPENOCD_TRANSPORT='swd',OPENOCD_INTERFACE='interface/stlink.cfg',
    OPENOCD_TARGET='target/stm32n6x.cfg',
    OPENOCD_SCRIPTS=str(COMMON/'env/openocd-4e9b167/share/openocd/scripts'),
    GDB_PORT='3359',GDB_RUN_TIMEOUT='900',SWO_TRACECLK='100000000',
    SWO_PIN_FREQ='1000000',SWO_FORMATTER='0',GDB=str(tool/'arm-none-eabi-gdb'),
    NM=str(tool/'arm-none-eabi-nm'),READELF=str(tool/'arm-none-eabi-readelf'),
    PYTHONDONTWRITEBYTECODE='1')
print('BOARD_START',out,flush=True)
with (out/'raw.log').open('w') as log:
    run=subprocess.run([sys.executable,str(M55/'ntt_final_compare/exec_board.py'),'--verbose',str(elf)],
        env=env,stdout=log,stderr=subprocess.STDOUT)
raw=(out/'raw.log').read_text()
clean=re.sub(r'Info : [^\n]*\n','',raw)
errors=[]
if run.returncode: errors.append(f'runner exit {run.returncode}')
for reg in ('CFSR','HFSR','AFSR'):
    if re.findall(r'^'+reg+r'=(0x[0-9a-f]+)$',clean,re.M)!=['0x0']: errors.append(reg)
for phase in ('START','END'):
    if f'TCM_CONTROL_{phase}=0x99' not in clean: errors.append('TCM '+phase)
    m=re.search('TCM_MSCR_'+phase+r'=(0x[0-9a-f]+)',clean)
    if not m or int(m[1],16)&0x12!=2: errors.append('ECC '+phase)
markers=('CHECK helpers=PASS cases=5120 split_merge_roundtrip=PASS',
    'CHECK permutation=PASS cases=1024 canonical_oracle=PASS',
    'CHECK shake256=PASS vectors=7 output_bytes=256 oracle=python_hashlib',
    'BENCH_DONE correctness=PASS guards=PASS result=0')
if mode=='kat': markers=('BOARD_KAT_DONE result=0 count=300 mismatches=0',)
if mode=='sigkat': markers=('BOARD_SIGNKAT_DONE count=90 mismatches=0',)
if mode=='api':
    markers=()
    if not re.search(r'SEC_API_DONE valid=64 rejected=\d+ failures=0 guards=0',clean): errors.append('API audit')
for marker in markers:
    if clean.count(marker)!=1: errors.append(marker)
if mode=='kernel' and len(re.findall(r'^BENCH_SAMPLE ',clean,re.M))!=100: errors.append('sample count')
if mode=='kernel' and spec.get('diagnostic_rounds',24)==24:
    if 'CHECK ABI=PASS cases=16 GPR=R4_R11 FP=D8_D15' not in clean: errors.append('ABI')
    if len(re.findall(r'^TIMING_CLASS class=[01] n=1000 ',clean,re.M))!=2: errors.append('timing classes')
for name,digest in spec['original_sha256'].items():
    if sha(Path(name))!=digest: errors.append('production changed: '+name)
manifest=dict(variant=variant,mode=mode,valid_measurement=not errors,errors=errors,elf_sha256=sha(out/'benchmark.elf'),
    raw_sha256=sha(out/'raw.log'),board_serial=env['OPENOCD_SERIAL'],original_source_unchanged=True)
(out/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
for line in clean.splitlines():
    if re.search(r'(BENCH_(BEGIN|HW|DONE|FAIL)|CHECK |FAIL |CFSR=|HFSR=|AFSR=|BOARD_\w+_DONE|SEC_API_DONE)',line): print(line)
print('BOARD_END',out,'errors=',errors,flush=True)
sys.exit(bool(errors))
