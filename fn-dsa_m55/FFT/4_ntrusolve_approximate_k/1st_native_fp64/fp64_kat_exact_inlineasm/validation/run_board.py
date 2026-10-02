#!/usr/bin/env python3
"""Run only the explicitly selected N657 probe; retain raw output and provenance."""
import datetime
import fcntl
import hashlib
import json
import os
from pathlib import Path
import re
import shlex
import subprocess
import sys
from provenance import snapshot

ROOT = Path(__file__).resolve().parent
lock_file=(ROOT/'build/board.lock').open('a')
fcntl.flock(lock_file, fcntl.LOCK_EX | fcntl.LOCK_NB)
M55 = ROOT.parents[4]
COMMON = M55 / 'measurement_mlkem_native'
label = sys.argv[1]
assert label in ('ref-perf','c-perf','asm-perf','ref-profile','c-profile','asm-profile','kernels','kat')
build = ROOT / 'build' / label
source = ROOT.parents[2]/'ref' if label.startswith('ref-') else (ROOT.parent.parent/'fp64_kat_exact' if label.startswith('c-') else ROOT.parent)
elf = build / 'zephyr/zephyr.elf'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
build_manifest = json.loads((build/'build_manifest.json').read_text())
assert build_manifest == snapshot(build, source), 'Source or build changed; rebuild before running'
manifest = json.loads((build/'generated/manifest.json').read_text())
assert manifest['original_sha256'] == sha(source/'kgen_ntru.c')
assert manifest['generated_sha256'] == sha(build/'generated/kgen_ntru.c')
commands = json.loads((build/'compile_commands.json').read_text())
crypto_rows = [r for r in commands if Path(r['file']).parent == source or Path(r['file']) == build/'generated/kgen_ntru.c']
assert len(crypto_rows) == (23 if label=='kernels' else 24), len(crypto_rows)
for row in crypto_rows:
    args = shlex.split(row['command'])
    assert [a for a in args if a.startswith('-mfpu=')][-1] == '-mfpu=fpv5-d16'
    assert all(a in args for a in ('-DFNDSA_MVE_MP31=1','-DFNDSA_ASM_CORTEXM4=1','-DFNDSA_ASM_CORTEXM55=1','-ffp-contract=off','-fno-fast-math'))
tool = COMMON/'env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin'
stamp = datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ')
out = ROOT/'results'/label/stamp
out.mkdir(parents=True)
env = os.environ.copy()
env.update(FNDSA_LOADER_MODE='upstream', MLKEM_NATIVE_PINNED_ROOT=str(COMMON/'env/mlkem-native-637d076aa113d8faaec2277ed4a46b657acaf35f'),
    OPENOCD=str(COMMON/'env/openocd-4e9b167/bin/openocd'),OPENOCD_SERIAL='003C00223335510735383531',
    OPENOCD_SPEED='8000',OPENOCD_TRANSPORT='swd',OPENOCD_SCRIPTS=str(COMMON/'env/openocd-4e9b167/share/openocd/scripts'),
    OPENOCD_INTERFACE='interface/stlink.cfg',OPENOCD_TARGET='target/stm32n6x.cfg',GDB_PORT='3359',GDB_RUN_TIMEOUT='1800',
    SWO_TRACECLK='100000000',SWO_PIN_FREQ='1000000',SWO_FORMATTER='0',GDB=str(tool/'arm-none-eabi-gdb'),
    NM=str(tool/'arm-none-eabi-nm'),READELF=str(tool/'arm-none-eabi-readelf'),PYTHONDONTWRITEBYTECODE='1')
cmd = [sys.executable,str(M55/'ntt_final_compare/exec_board.py'),'--verbose',str(elf)]
print('Running',label,'raw output:',out/'raw.log',flush=True)
with (out/'raw.log').open('w') as log:
    result = subprocess.run(cmd,env=env,stdout=log,stderr=subprocess.STDOUT)
raw = (out/'raw.log').read_text()
assert build_manifest == snapshot(build, source), 'Source changed during the board run'
clean = re.sub(r'Info : [^\n]*\n','',raw)
errors = []
if result.returncode: errors.append('runner exit '+str(result.returncode))
done = 'KERNEL_DONE result=0' if label=='kernels' else ('BOARD_KAT_DONE result=0 count=300' if label=='kat' else 'FP64_DONE result=0 signature_and_tamper=PASS')
if clean.count(done)!=1: errors.append('completion failed')
keys = re.findall(r'^KEY degree=(\d+) index=(\d+) cycles=(\d+) digest=([a-f0-9]{64})$',clean,re.M)
if label not in ('kernels','kat') and {(int(d),int(i)) for d,i,_,_ in keys} != {(d,i) for d in (512,1024) for i in range(100)}: errors.append('incomplete key samples')
for name in ('CFSR','HFSR','AFSR'):
    if re.findall(r'^'+name+r'=(0x[0-9a-f]+)$',clean,re.M)!=['0x0']: errors.append(name+' not clean')
for phase in ('START','END'):
    if 'TCM_CONTROL_'+phase+'=0x99' not in clean: errors.append('TCM control '+phase)
    m=re.search('TCM_MSCR_'+phase+r'=(0x[0-9a-f]+)',clean)
    if not m or int(m[1],16)&0x12 != 2: errors.append('ECC '+phase)
totals=re.findall(r'^TOTAL degree=(\d+) runs=(\d+) cycles=(\d+) median=(\d+) min=(\d+) max=(\d+)$',clean,re.M)
approx=re.findall(r'^APPROX degree=(\d+) kind=(\d+) logn=(\d+) calls=(\d+) cycles=(\d+)$',clean,re.M)
data=dict(label=label,valid=not errors,errors=errors,returncode=result.returncode,elf_sha256=sha(elf),
    harness={p.name:sha(p) for p in sorted(ROOT.iterdir()) if p.suffix in ('.c','.h','.py','.sh','.txt')},
    generated=manifest, build_manifest=build_manifest,
    source={p.name:sha(p) for p in sorted(source.iterdir()) if p.suffix in ('.c','.h','.s')},
    keys=[dict(degree=int(d),index=int(i),cycles=int(c),digest=h) for d,i,c,h in keys],
    totals=[dict(zip(('degree','runs','cycles','median','min','max'),map(int,t))) for t in totals],
    approx=[dict(zip(('degree','kind','logn','calls','cycles'),map(int,t))) for t in approx],
    artifacts={p:sha(build/p) for p in ('compile_commands.json','zephyr/.config','fndsa_dtcm_linker.ld')},
    raw_sha256=sha(out/'raw.log'),run_dir=str(out),command=cmd)
(out/'run.json').write_text(json.dumps(data,indent=2)+'\n')
print(json.dumps({k:data[k] for k in ('label','valid','errors','totals','run_dir')},indent=2))
raise SystemExit(bool(errors))
