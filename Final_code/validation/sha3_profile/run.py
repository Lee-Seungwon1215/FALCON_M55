#!/usr/bin/env python3
"""Run only the pinned N657, under the existing shared board locks."""
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

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
M55 = ROOT / 'fn-dsa_m55'
COMMON = M55 / 'measurement_mlkem_native'
SOURCE = ROOT / 'Final_code/Before_slothy'
mode, = sys.argv[1:]
assert mode in ('control', 'detail', 'coarse')
build = HERE / 'build' / mode
elf = build / 'zephyr/zephyr.elf'
spec = json.loads((build / 'generated/sources.json').read_text())
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
for name, digest in spec['original_sha256'].items():
    assert sha(Path(name)) == digest, ('production changed since configure', name)
for name, digest in spec['generated_sha256'].items():
    assert sha(build / 'generated' / name) == digest
commands = json.loads((build / 'compile_commands.json').read_text())
crypto_commands = [r for r in commands if Path(r['file']).parent == SOURCE or
                  (Path(r['file']).parent == build / 'generated' and
                   Path(r['file']).name in ('sha3.c', 'sha3_cm4.s'))]
assert len(crypto_commands) == 30, len(crypto_commands)
assert all('-mcpu=cortex-m55' in r['command'] and '-O3' in r['command'] and
           '-DFNDSA_' not in r['command'] for r in crypto_commands)
for r in commands:
    p = Path(r['file'])
    assert p.stat().st_mtime <= elf.stat().st_mtime, ('stale build', p)
locks = []
for path in (COMMON / 'n657-board.lock', M55 / 'function_compare/fft_native_fp64/build/board.lock'):
    f = path.open('a')
    fcntl.flock(f, fcntl.LOCK_EX | fcntl.LOCK_NB)
    locks.append(f)
out = HERE / 'results' / mode / datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ')
out.mkdir(parents=True, exist_ok=False)
for src, name in ((elf, 'benchmark.elf'), (build / 'compile_commands.json', 'compile_commands.json'),
                  (build / 'generated/sources.json', 'sources.json')):
    shutil.copy2(src, out / name)
with tarfile.open(out / 'sources.tar.gz', 'w:gz') as archive:
    for p in SOURCE.iterdir():
        if p.suffix in ('.c', '.h', '.s'): archive.add(p, arcname='production/' + p.name)
    for p in (build / 'generated').iterdir():
        if p.is_file(): archive.add(p, arcname='generated/' + p.name)
    for p in HERE.iterdir():
        if p.is_file(): archive.add(p, arcname='harness/' + p.name)
tool = COMMON / 'env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin'
with (out / 'disassembly.txt').open('w') as f:
    subprocess.run([str(tool / 'arm-none-eabi-objdump'), '-d', str(elf)], stdout=f, check=True)
env = os.environ.copy()
env.update(FNDSA_LOADER_MODE='upstream',
    MLKEM_NATIVE_PINNED_ROOT=str(COMMON / 'env/mlkem-native-637d076aa113d8faaec2277ed4a46b657acaf35f'),
    OPENOCD=str(COMMON / 'env/openocd-4e9b167/bin/openocd'),
    OPENOCD_SERIAL='003C00223335510735383531', OPENOCD_SPEED='8000',
    OPENOCD_TRANSPORT='swd', OPENOCD_INTERFACE='interface/stlink.cfg',
    OPENOCD_TARGET='target/stm32n6x.cfg',
    OPENOCD_SCRIPTS=str(COMMON / 'env/openocd-4e9b167/share/openocd/scripts'),
    GDB_PORT='3359', GDB_RUN_TIMEOUT='900', SWO_TRACECLK='100000000',
    SWO_PIN_FREQ='1000000', SWO_FORMATTER='0', GDB=str(tool / 'arm-none-eabi-gdb'),
    NM=str(tool / 'arm-none-eabi-nm'), READELF=str(tool / 'arm-none-eabi-readelf'),
    PYTHONDONTWRITEBYTECODE='1')
print('BOARD_START', out, flush=True)
with (out / 'raw.log').open('w') as log:
    run = subprocess.run([sys.executable, str(M55 / 'ntt_final_compare/exec_board.py'),
                          '--verbose', str(elf)], env=env, stdout=log, stderr=subprocess.STDOUT)
raw = (out / 'raw.log').read_text()
clean = re.sub(r'Info : [^\n]*\n', '', raw)
errors = []
if run.returncode: errors.append(f'runner exit {run.returncode}')
for reg in ('CFSR', 'HFSR', 'AFSR'):
    if re.findall(r'^' + reg + r'=(0x[0-9a-f]+)$', clean, re.M) != ['0x0']: errors.append(reg)
for phase in ('START', 'END'):
    if f'TCM_CONTROL_{phase}=0x99' not in clean: errors.append('TCM ' + phase)
    m = re.search('TCM_MSCR_' + phase + r'=(0x[0-9a-f]+)', clean)
    if not m or int(m[1], 16) & 0x12 != 2: errors.append('ECC ' + phase)
if clean.count('PROFILE_DONE correctness=PASS tamper_rejection=PASS') != 1: errors.append('completion')
if 'PROFILE_STATUS error=0 result=0' not in clean: errors.append('profile status')
fingerprints = re.findall(r'^PROFILE_FINGERPRINT degree=(\d+) fnv1a=(\w+)$', clean, re.M)
if len(fingerprints) != 2: errors.append('fingerprints')
for d in (512, 1024):
    for op, runs in (('keygen', 10), ('sign', 100), ('verify', 100)):
        total = re.search(rf'^PROFILE_TOTAL degree={d} operation={op} calls={runs} total=(\d+) ', clean, re.M)
        cats = re.findall(rf'^PROFILE_CATEGORY degree={d} operation={op} category=(\w+) cycles=(\d+) entries=(\d+) inclusive=(\d+) children=(\d+)$', clean, re.M)
        if not total or len(cats) != 20 or sum(int(c[1]) for c in cats) != int(total[1]):
            errors.append(f'profile sum {d} {op}')
for name, digest in spec['original_sha256'].items():
    if sha(Path(name)) != digest: errors.append('production changed: ' + name)
manifest = dict(mode=mode, valid_measurement=not errors, errors=errors,
    fingerprints=dict(fingerprints), elf_sha256=sha(out / 'benchmark.elf'),
    raw_sha256=sha(out / 'raw.log'), crypto_root=str(SOURCE))
(out / 'manifest.json').write_text(json.dumps(manifest, indent=2) + '\n')
for line in clean.splitlines():
    if re.search(r'(PROFILE_(TOTAL|DONE|STATUS|HW|FINGERPRINT)|PROBE_CALIBRATION|CFSR=|HFSR=)', line): print(line)
print('BOARD_END', out, 'errors=', errors, flush=True)
sys.exit(bool(errors))
