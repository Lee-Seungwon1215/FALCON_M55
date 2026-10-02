#!/usr/bin/env python3
"""Serial-locked M55 test runner with source, toolchain and ELF provenance."""
import fcntl
import hashlib
import json
import os
from pathlib import Path
import re
import shlex
import shutil
import subprocess
import sys
import tarfile
from datetime import datetime, timezone

HERE = Path(__file__).resolve().parent
WORKSPACE = HERE.parents[3]
M55 = WORKSPACE / 'fn-dsa_m55'
COMMON = M55 / 'measurement_mlkem_native'
mode = sys.argv[1]
variant = sys.argv[2] if len(sys.argv) > 2 else 'candidate'
assert mode in ('poly', 'sign_detail', 'sign_control', 'ldl', 'kernel', 'sign', 'sign_native', 'sigkat', 'kat', 'extra', 'api')
assert variant in ('baseline', 'candidate', 'original')
is_sign_profile = mode in ('sign_detail', 'sign_control')
if is_sign_profile:
    assert variant == 'candidate'
CRYPTO = HERE.parent if variant == 'candidate' else WORKSPACE / 'Final_code/Before_slothy'
if variant == 'original':
    assert mode == 'sign'
    CRYPTO = M55 / 'M55_ref'
build = HERE / 'build' / (variant + '_' + mode)
elf = build / 'zephyr/zephyr.elf'
commands = json.loads((build / 'compile_commands.json').read_text())
names = {p.name for p in CRYPTO.iterdir() if p.suffix in ('.c', '.s')}
own = []
for row in commands:
    path = Path(row['file']).resolve()
    if path.name not in names:
        continue
    allowed = {CRYPTO}
    if is_sign_profile and path.name in ('sign.c', 'sign_core.c', 'sign_sampler.c', 'sign_fpoly.c', 'sign_sampler_cm4.s'):
        allowed.add(build / 'sign_generated')
    assert path.parent in allowed, ('foreign implementation', path)
    flags = shlex.split(row['command'])
    assert '-mcpu=cortex-m55' in flags
    assert [x for x in flags if x.startswith('-mfpu=')][-1] == '-mfpu=fpv5-d16'
    assert [x for x in flags if re.fullmatch(r'-O[0-3sgz]', x)][-1] == '-O3'
    assert '-ffp-contract=off' in flags and '-fno-fast-math' in flags
    fndsa_flags = {x for x in flags if x.startswith('-DFNDSA_')}
    assert fndsa_flags == ({'-DFNDSA_ASM_CORTEXM4=1', '-DFNDSA_ASM_CORTEXM55=1'} if variant == 'original' else set())
    own.append(row)
expected_objects = 27 if mode == 'sign_native' else 28
if variant == 'candidate': expected_objects += 2
if variant == 'original': expected_objects = 23
assert len(own) == expected_objects, len(own)

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

files = [p for p in CRYPTO.iterdir() if p.suffix in ('.c', '.h', '.s')]
files.append(CRYPTO / 'Makefile')
if is_sign_profile:
    spec = json.loads((build / 'sign_generated/sign_profile_manifest.json').read_text())
    assert Path(spec['source']) == CRYPTO
    for name, expected_sha in spec['generated_sha256'].items():
        assert sha(build / 'sign_generated' / name) == expected_sha, name
    for name, expected_sha in spec['original_sha256'].items():
        assert sha(Path(name)) == expected_sha, name
    files += [Path(name) for name in spec['original_sha256']]
    files += list((build / 'sign_generated').iterdir())
files += [p for p in HERE.iterdir() if p.is_file() and p.suffix in ('.py', '.sh', '.c', '.txt')]
files += [Path(r['file']).resolve() for r in commands if Path(r['file']).is_file()]
deps = subprocess.check_output([str(COMMON / 'env/build-venv/bin/ninja'), '-C', str(build), '-t', 'deps'], text=True)
for line in deps.splitlines():
    if line.startswith('    '):
        p = Path(line.strip())
        if not p.is_absolute(): p = build / p
        if p.is_file() and p.suffix in ('.c', '.h', '.s'): files.append(p.resolve())
files = sorted(set(files))
for p in files:
    if p.suffix in ('.c', '.h', '.s'):
        assert p.stat().st_mtime <= elf.stat().st_mtime, ('stale ELF', p)
if mode in ('kernel', 'sign_native'):
    spec = json.loads((build / 'oracle_manifest.json').read_text())
    assert sha(Path(spec['source'])) == spec['source_sha256']
    assert sha(build / 'oracle.c') == spec['oracle_sha256']
    assert sha(build / 'native_c.c') == spec['native_sha256']
    assert sha(build / 'native_c_sign.c') == spec['native_sign_sha256']
    assert sha(Path(spec['native_archive'])) == spec['native_archive_sha256']
    files.append(Path(spec['native_archive']))
    files.append(Path(spec['source']))
before = {str(p): sha(p) for p in files}
locks = []
for p in (COMMON / 'n657-board.lock', M55 / 'function_compare/fft_native_fp64/build/board.lock'):
    f = p.open('a'); fcntl.flock(f, fcntl.LOCK_EX | fcntl.LOCK_NB); locks.append(f)
out = HERE / 'results' / (variant + '_' + mode) / datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ')
out.mkdir(parents=True, exist_ok=False)
shutil.copy2(elf, out / 'benchmark.elf')
shutil.copy2(build / 'compile_commands.json', out / 'compile_commands.json')
with tarfile.open(out / 'production_sources.tar.gz', 'w:gz') as archive:
    for p in sorted(CRYPTO.iterdir()):
        if p.suffix in ('.c', '.h', '.s') or p.name == 'Makefile':
            archive.add(p, arcname=p.name)
if is_sign_profile:
    with tarfile.open(out / 'profile_sources.tar.gz', 'w:gz') as archive:
        for p in sorted((build / 'sign_generated').iterdir()):
            if p.is_file(): archive.add(p, arcname=p.name)
tool = COMMON / 'env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin'
with (out / 'disassembly.txt').open('w') as fp:
    subprocess.run([str(tool / 'arm-none-eabi-objdump'), '-d', str(elf)], stdout=fp, check=True)
env = os.environ.copy()
env.update(FNDSA_LOADER_MODE='upstream',
    MLKEM_NATIVE_PINNED_ROOT=str(COMMON / 'env/mlkem-native-637d076aa113d8faaec2277ed4a46b657acaf35f'),
    OPENOCD=str(COMMON / 'env/openocd-4e9b167/bin/openocd'),
    OPENOCD_SERIAL='003C00223335510735383531', OPENOCD_SPEED='8000',
    OPENOCD_TRANSPORT='swd', OPENOCD_INTERFACE='interface/stlink.cfg',
    OPENOCD_TARGET='target/stm32n6x.cfg',
    OPENOCD_SCRIPTS=str(COMMON / 'env/openocd-4e9b167/share/openocd/scripts'),
    GDB_PORT='3359', GDB_RUN_TIMEOUT='900', SWO_TRACECLK='100000000',
    SWO_PIN_FREQ='1000000', SWO_FORMATTER='0',
    GDB=str(tool / 'arm-none-eabi-gdb'), NM=str(tool / 'arm-none-eabi-nm'),
    READELF=str(tool / 'arm-none-eabi-readelf'), PYTHONDONTWRITEBYTECODE='1')
print('BOARD_START', out, flush=True)
with (out / 'raw.log').open('w') as log:
    run = subprocess.run([sys.executable, str(HERE / 'exec_board.py'), '--verbose', str(elf)],
        env=env, stdout=log, stderr=subprocess.STDOUT)
raw = (out / 'raw.log').read_text()
clean = re.sub(r'Info : [^\n]*\n', '', raw)
errors = []
if run.returncode: errors.append(f'runner exit {run.returncode}')
if 'MIS-MATCHED' in clean or 'WARNING: One or more sections of the target image does not match' in clean:
    errors.append('ELF load verification')
for reg in ('CFSR', 'HFSR', 'AFSR'):
    if re.findall(r'^' + reg + r'=(0x[0-9a-f]+)$', clean, re.M) != ['0x0']: errors.append(reg)
for phase in ('START', 'END'):
    if f'TCM_CONTROL_{phase}=0x99' not in clean: errors.append('TCM ' + phase)
    m = re.search('TCM_MSCR_' + phase + r'=(0x[0-9a-f]+)', clean)
    if not m or int(m[1], 16) & 0x12 != 2: errors.append('ECC ' + phase)
expected = {
    'poly': ('POLY_DONE comparisons=5120 failures=0 guards=0', r'^POLY_PERF ', 60),
    'sign_detail': ('PROFILE_DONE correctness=PASS tamper_rejection=PASS', r'^PROFILE_FINGERPRINT degree=', 2),
    'sign_control': ('PROFILE_DONE correctness=PASS tamper_rejection=PASS', r'^PROFILE_FINGERPRINT degree=', 2),
    'ldl': ('LDL_DONE comparisons=1280 failures=0 guards=0', r'^LDL_PERF ', 30),
    'kernel': ('FFT_DONE comparisons=3840 failures=0 guards=0', r'^FFT_PERF ', 12),
    'sign': ('SIGN_DONE verify=PASS tamper=PASS fingerprints=PASS', r'^SIGN_SAMPLE ', 200),
    'sign_native': ('SIGN_DONE verify=PASS tamper=PASS fingerprints=PASS', r'^SIGN_SAMPLE ', 200),
    'kat': ('BOARD_KAT_DONE result=0 count=300 mismatches=0', r'^BOARD_KAT .*match=1 equation=PASS', 300),
    'extra': ('BOARD_KAT_DONE result=0 count=300 mismatches=0', r'^BOARD_KAT .*match=1 equation=PASS', 300),
    'sigkat': ('BOARD_SIGNKAT_DONE count=90 mismatches=0', r'^BOARD_SIGNKAT .*match=1 verify=PASS tamper=PASS', 90),
    'api': ('SEC_API_DONE valid=64 rejected=3902 failures=0 guards=0', r'^SEC_API degree=', 64),
}
marker, pattern, count = expected[mode]
if clean.count(marker) != 1: errors.append('completion')
if len(re.findall(pattern, clean, re.M)) != count: errors.append('row count')
if mode == 'kernel' and 'FFT_ABI calls=20 failures=0' not in clean: errors.append('ABI check')
if mode == 'ldl' and 'LDL_ABI calls=10 failures=0' not in clean: errors.append('LDL ABI check')
if mode == 'poly' and 'POLY_ABI calls=20 failures=0' not in clean: errors.append('poly ABI check')
if is_sign_profile:
    if 'PROFILE_STATUS error=0 result=0' not in clean: errors.append('profile status')
    for degree, fp in ((512, '9895079d'), (1024, 'a020dd02')):
        if f'PROFILE_FINGERPRINT degree={degree} fnv1a={fp}' not in clean:
            errors.append('profile fingerprint ' + str(degree))
        total = re.search(r'^PROFILE_TOTAL degree=' + str(degree) +
            r' operation=sign calls=100 total=(\d+) ', clean, re.M)
        cats = re.findall(r'^PROFILE_CATEGORY degree=' + str(degree) +
            r' operation=sign category=(\w+) cycles=(\d+) entries=(\d+)$', clean, re.M)
        if not total or len(cats) != (32 if mode == 'sign_detail' else 24) or sum(int(c[1]) for c in cats) != int(total[1]):
            errors.append('profile sum ' + str(degree))
if before != {str(p): sha(p) for p in files}: errors.append('sources changed during run')
manifest = dict(mode=mode, variant=variant, crypto_root=str(CRYPTO), source_sha256=before,
    elf_sha256=sha(out / 'benchmark.elf'), raw_sha256=sha(out / 'raw.log'),
    compile_commands=own, errors=errors, valid_measurement=not errors)
(out / 'manifest.json').write_text(json.dumps(manifest, indent=2) + '\n')
for line in clean.splitlines():
    if re.search(r'(DONE|SUMMARY|POLY_|FFT_|LDL_|RECIP_|PROFILE_TOTAL|PROFILE_STATUS|PROFILE_FINGERPRINT|HFSR=|CFSR=)', line): print(line)
print('BOARD_END', out, 'errors=', errors, flush=True)
sys.exit(bool(errors))
