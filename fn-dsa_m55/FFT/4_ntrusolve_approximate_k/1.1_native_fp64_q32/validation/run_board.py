#!/usr/bin/env python3
"""Run local candidate only; audit hashes, compiler inputs, KAT and N657 state."""
import fcntl
import hashlib
import json
import os
import re
import shlex
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
M55 = ROOT.parents[2]
COMMON = M55/'measurement_mlkem_native'
BENCHES = dict(kat='board_kat.c', sigkat='board_signkat.c',
               guard_repro='board_repro.c', perfct='perfct.c', keyprofile='keyprofile.c',
               ntruprofile='ntruprofile.c', ntrucontrol='ntruprofile.c',
               orthoprofile='orthoprofile.c', orthocontrol='orthoprofile.c')
ORTHO_KINDS = ('orthoprofile', 'orthocontrol')
PROFILE_KINDS = ('keyprofile', 'ntruprofile', 'ntrucontrol') + ORTHO_KINDS
kind, = sys.argv[1:]
assert kind in BENCHES
locks = []
for path in (COMMON/'n657-board.lock', M55/'function_compare/fft_native_fp64/build/board.lock'):
    # Coordinate also with the original experiment; this is a device lock,
    # never a dependency on another candidate's cryptographic source.
    f = path.open('a')
    fcntl.flock(f, fcntl.LOCK_EX | fcntl.LOCK_NB)
    locks.append(f)
build = ROOT/'validation/build'/kind
elf = build/'zephyr/zephyr.elf'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
files = list(ROOT.glob('*.[chs]')) + list((ROOT/'validation/generated').glob('*.h'))
files += [ROOT/'validation'/name for name in (BENCHES[kind], 'CMakeLists.txt', 'build.sh')]
if kind == 'guard_repro':
    files.append(ROOT/'validation/guard_reference.json')
if kind in PROFILE_KINDS:
    support = (('approx_profile.c', 'approx_profile.h', 'generate_approx_profile.py')
               if kind == 'keyprofile' else
               ('ortho_profile.c', 'ortho_profile.h', 'generate_ortho_profile.py')
               if kind in ORTHO_KINDS else
               ('ntru_profile.c', 'ntru_profile.h', 'generate_ntru_profile.py'))
    files += [ROOT/'validation'/name for name in support]
    files += [build/'generated'/name for name in ('kgen_ntru.c', 'profile_manifest.json')]
    m = json.loads((build/'generated/profile_manifest.json').read_text())
    assert m['original_sha256'] == sha(ROOT/'kgen_ntru.c')
    assert m['generated_sha256'] == sha(build/'generated/kgen_ntru.c')
    assert m['exact_original_recovered_after_removing_hooks']
    if kind != 'keyprofile':
        files.append(build/'generated'/('ortho_profile_mode.h' if kind in ORTHO_KINDS else 'ntru_profile_mode.h'))
        assert m['mode'] == ('detail' if kind in ('ntruprofile', 'orthoprofile') else 'control')
assert all(p.stat().st_mtime <= elf.stat().st_mtime for p in files), 'Rebuild stale ELF'
before = {str(p): sha(p) for p in files}
commands = json.loads((build/'compile_commands.json').read_text())
crypto_rows = [r for r in commands if Path(r['file']).parent == ROOT]
if kind in PROFILE_KINDS:
    crypto_rows += [r for r in commands if Path(r['file']) == build/'generated/kgen_ntru.c']
assert len(crypto_rows) == 24, len(crypto_rows)
for row in commands:
    assert '/function_compare/' not in row['file'], row['file']
for row in crypto_rows:
    flags = shlex.split(row['command'])
    assert [f for f in flags if f.startswith('-mfpu=')][-1] == '-mfpu=fpv5-d16'
    assert [f for f in flags if re.fullmatch(r'-O[0-3sgz]', f)][-1] == '-O3'
    assert all(f in flags for f in ('-mcpu=cortex-m55', '-ffp-contract=off', '-fno-fast-math',
                                   '-DFNDSA_ASM_CORTEXM4=1', '-DFNDSA_MVE_MP31=1'))
tool = COMMON/'env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin'
out = ROOT/'validation/results'/kind/datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ')
out.mkdir(parents=True, exist_ok=False)
env = os.environ.copy()
env.update(FNDSA_LOADER_MODE='upstream',
    MLKEM_NATIVE_PINNED_ROOT=str(COMMON/'env/mlkem-native-637d076aa113d8faaec2277ed4a46b657acaf35f'),
    OPENOCD=str(COMMON/'env/openocd-4e9b167/bin/openocd'), OPENOCD_SERIAL='003C00223335510735383531',
    OPENOCD_SPEED='8000', OPENOCD_TRANSPORT='swd',
    OPENOCD_SCRIPTS=str(COMMON/'env/openocd-4e9b167/share/openocd/scripts'),
    OPENOCD_INTERFACE='interface/stlink.cfg', OPENOCD_TARGET='target/stm32n6x.cfg',
    GDB_PORT='3359', GDB_RUN_TIMEOUT='1800', SWO_TRACECLK='100000000',
    SWO_PIN_FREQ='1000000', SWO_FORMATTER='0', GDB=str(tool/'arm-none-eabi-gdb'),
    NM=str(tool/'arm-none-eabi-nm'), READELF=str(tool/'arm-none-eabi-readelf'), PYTHONDONTWRITEBYTECODE='1')
command = [sys.executable, str(M55/'ntt_final_compare/exec_board.py'), '--verbose', str(elf)]
print('BOARD_START', out, flush=True)
with (out/'raw.log').open('w') as f:
    run = subprocess.run(command, env=env, stdout=f, stderr=subprocess.STDOUT)
raw = (out/'raw.log').read_text()
clean = re.sub(r'Info : [^\n]*\n', '', raw)
errors = []
if run.returncode:
    errors.append('runner exit '+str(run.returncode))
for register in ('CFSR', 'HFSR', 'AFSR'):
    if re.findall(r'^'+register+r'=(0x[0-9a-f]+)$', clean, re.M) != ['0x0']:
        errors.append(register)
for phase in ('START', 'END'):
    if 'TCM_CONTROL_'+phase+'=0x99' not in clean:
        errors.append('TCM '+phase)
    m = re.search('TCM_MSCR_'+phase+r'=(0x[0-9a-f]+)', clean)
    if not m or int(m[1], 16) & 0x12 != 2:
        errors.append('ECC '+phase)
checks = {}
if kind == 'kat':
    rows = re.findall(r'^BOARD_KAT degree=(\d+) index=(\d+) match=1 equation=PASS actual=(\w+)$', clean, re.M)
    expected = {(d, i) for d in (256, 512, 1024) for i in range(100)}
    if len(rows) != 300 or {(int(d), int(i)) for d, i, h in rows} != expected:
        errors.append('keygen KAT rows')
    if clean.count('BOARD_KAT_DONE result=0 count=300 mismatches=0') != 1:
        errors.append('keygen KAT completion')
    checks['keygen_kat'] = dict(count=len(rows), mismatches=clean.count('match=0'))
elif kind == 'sigkat':
    rows = re.findall(r'^BOARD_SIGNKAT degree=(\d+) index=(\d+) match=1 verify=PASS tamper=PASS$', clean, re.M)
    expected = {(1 << l, i) for l in range(2, 11) for i in range(10)}
    if len(rows) != 90 or {(int(d), int(i)) for d, i in rows} != expected:
        errors.append('signature KAT/verify/tamper rows')
    if clean.count('BOARD_SIGNKAT_DONE count=90 mismatches=0') != 1:
        errors.append('signature KAT completion')
    checks['signature_kat_verify_tamper'] = len(rows)
elif kind == 'guard_repro':
    expected = {(r['degree'], r['index']): r['digest'] for r in
                json.loads((ROOT/'validation/guard_reference.json').read_text())}
    rows = re.findall(r'^REPRO degree=(\d+) index=(\d+) digest=(\w+) verify=PASS tamper=PASS$', clean, re.M)
    got = {(int(d), int(i)): h for d, i, h in rows}
    if len(rows) != 5 or got != expected or clean.count('REPRO_DONE count=5') != 1:
        errors.append('original-reference regression/verify/tamper')
    checks['regression_matches_original_reference'] = got == expected
elif kind == 'perfct':
    if clean.count('PERFCT_DONE cases=19') != 1:
        errors.append('kernel completion')
    if len(re.findall(r'^KPERF ', clean, re.M)) != 266:
        errors.append('kernel timing rows')
    if len(re.findall(r'^PERF_K case=\d+ logn=\d+ differences=0 fixed_fixture_errors=0$', clean, re.M)) != 19:
        errors.append('frozen kernel k/fixture mismatch')
    if 'COUNTEREXAMPLE_BOARD fixed=00000000ffffffff trial=3ff0000000000000 fixed_k=0 trial_k=1' not in clean:
        errors.append('known arithmetic counterexample changed')
    checks['known_arithmetic_counterexample'] = 'still present (expected negative result)'
elif kind == 'keyprofile':
    if clean.count('APRO_DONE count=200 mismatches=0') != 1:
        errors.append('profile completion')
    rows = re.findall(r'^APRO_KEY degree=(\d+) index=(\d+) match=1 equation=PASS actual=(\w+)$', clean, re.M)
    if len(rows) != 200 or {(int(d), int(i)) for d, i, h in rows} != {(d, i) for d in (512, 1024) for i in range(100)}:
        errors.append('profile KAT rows')
    if len(re.findall(r'^APRO degree=', clean, re.M)) != 153:
        errors.append('profile counters')
    checks['profile_key_kat'] = len(rows)
elif kind in ('ntruprofile', 'ntrucontrol'):
    if clean.count('NPRO_DONE count=200 mismatches=0') != 1:
        errors.append('NTRU profile completion')
    rows = re.findall(r'^NPRO_KEY degree=(\d+) index=(\d+) match=1 equation=PASS actual=(\w+)$', clean, re.M)
    if len(rows) != 200 or {(int(d), int(i)) for d, i, h in rows} != {(d, i) for d in (512, 1024) for i in range(100)}:
        errors.append('NTRU profile KAT rows')
    mode = 'detail' if kind == 'ntruprofile' else 'control'
    totals = re.findall(r'^NPRO_TOTAL degree=(\d+) mode='+mode+r' keys=100 attempts=(\d+) accepted=100 failed=(\d+) cycles=(\d+) max_call=(\d+) errors=0$', clean, re.M)
    expected_ops = {'FFT_fp64', 'inv_mul2e_fft_fp64', 'mul_fft_fp64', 'iFFT_fp64',
                    'FFT_fixed', 'div_selfadj_fft_fixed', 'iFFT_fixed',
                    'input_intermediate', 'round_guard_intermediate', 'input_depth0',
                    'round_rns_depth0', 'other'}
    counters = re.findall(r'^NPRO degree=(\d+) op=(\w+) calls=(\d+) cycles=(\d+)$', clean, re.M)
    if len(totals) != 2 or {int(t[0]) for t in totals} != {512, 1024}:
        errors.append('NTRU totals')
    if len(counters) != 24 or {(int(d), op) for d, op, n, c in counters} != {(d, op) for d in (512, 1024) for op in expected_ops}:
        errors.append('NTRU counters')
    for degree, attempts, failed, total, maximum in totals:
        selected = [(op, int(n), int(c)) for d, op, n, c in counters if d == degree]
        if int(attempts) != 100+int(failed) or sum(c for op, n, c in selected) != int(total):
            errors.append('NTRU accounting '+degree)
        if not 0 < int(maximum) < 2000000000:
            errors.append('NTRU duration outside expected sub-wrap range '+degree)
        if mode == 'detail' and any(n == 0 for op, n, c in selected if op != 'other'):
            errors.append('missing NTRU operation '+degree)
        if mode == 'control' and any(n or c for op, n, c in selected if op != 'other'):
            errors.append('control contains inner timers '+degree)
    checks['profile_key_kat'] = len(rows)
    checks['disjoint_accounting'] = 'PASS' if not errors else 'FAIL'
elif kind in ORTHO_KINDS:
    if clean.count('OPRO_DONE count=200 mismatches=0') != 1:
        errors.append('orthogonal-norm profile completion')
    rows = re.findall(r'^OPRO_KEY degree=(\d+) index=(\d+) match=1 equation=PASS actual=(\w+)$', clean, re.M)
    if len(rows) != 200 or {(int(d), int(i)) for d, i, h in rows} != {(d, i) for d in (512, 1024) for i in range(100)}:
        errors.append('orthogonal-norm profile KAT rows')
    mode = 'detail' if kind == 'orthoprofile' else 'control'
    totals = re.findall(r'^OPRO_TOTAL degree=(\d+) mode='+mode+r' keys=100 attempts=(\d+) key_cycles=(\d+) ortho_cycles=(\d+) max_key=(\d+) max_ortho=(\d+) errors=0$', clean, re.M)
    expected_ops = {'vect_set', 'vect_FFT', 'vect_invnorm_fft', 'vect_adj_fft',
                    'vect_mul_realconst', 'vect_mul_selfadj_fft', 'vect_iFFT',
                    'norm_sum', 'ortho_other', 'key_other'}
    counters = re.findall(r'^OPRO degree=(\d+) op=(\w+) calls=(\d+) cycles=(\d+)$', clean, re.M)
    if len(totals) != 2 or {int(t[0]) for t in totals} != {512, 1024}:
        errors.append('orthogonal-norm totals')
    if len(counters) != 20 or {(int(d), op) for d, op, n, c in counters} != {(d, op) for d in (512, 1024) for op in expected_ops}:
        errors.append('orthogonal-norm counters')
    for degree, attempts, key_total, ortho_total, max_key, max_ortho in totals:
        selected = {op: (int(n), int(c)) for d, op, n, c in counters if d == degree}
        if (sum(c for n, c in selected.values()) != int(key_total)
                or sum(c for op, (n, c) in selected.items() if op != 'key_other') != int(ortho_total)
                or int(attempts) < 100):
            errors.append('orthogonal-norm accounting '+degree)
        if not (0 < int(max_key) < 2000000000 and 0 < int(max_ortho) < 2000000000):
            errors.append('orthogonal-norm/key duration outside expected sub-wrap range '+degree)
        for op, (n, c) in selected.items():
            if op in ('key_other', 'ortho_other'):
                if n != 0: errors.append('invalid remainder calls '+degree)
                continue
            expected_n = int(attempts) * (1 if op in ('vect_invnorm_fft', 'norm_sum') else 2)
            if mode == 'detail' and (n != expected_n or c == 0):
                errors.append('orthogonal-norm operation count '+degree+' '+op)
            if mode == 'control' and (n or c):
                errors.append('orthogonal-norm control contains inner timers '+degree)
    checks['profile_key_kat'] = len(rows)
    checks['two_denominator_accounting'] = 'PASS' if not errors else 'FAIL'
if any(sha(Path(p)) != h for p, h in before.items()):
    errors.append('sources changed during run')
data = dict(valid_measurement=not errors, errors=errors, kind=kind,
            source_root=str(ROOT), source=before, checks=checks,
            elf_sha256=sha(elf), compile_commands_sha256=sha(build/'compile_commands.json'),
            raw_sha256=sha(out/'raw.log'), local_crypto_translation_units=len(crypto_rows), command=command)
(out/'run.json').write_text(json.dumps(data, indent=2)+'\n')
print(json.dumps({k: data[k] for k in ('valid_measurement','errors','checks')}, indent=2), flush=True)
raise SystemExit(bool(errors))
