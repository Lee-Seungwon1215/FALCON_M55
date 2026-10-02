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
BENCHES = dict(kat='board_kat.c', sigkat='board_signkat.c', api_perf='board_api_perf.c',
               guard_repro='board_repro.c', kernels='board_kernels.c',
               perfct='perfct.c', keyprofile='keyprofile.c',
               ntruprofile='ntruprofile.c', ntrucontrol='ntruprofile.c',
               orthoprofile='orthoprofile.c', orthocontrol='orthoprofile.c',
               bridgeprofile='bridgeprofile.c', twiddlebench='twiddlebench.c',
               keygen_ref='board_keygen_perf.c', keygen_current='board_keygen_perf.c',
               ipro_ref='board_keygen_perf.c', ipro_current='board_keygen_perf.c',
               zpro_ref='board_keygen_perf.c', zpro_current='board_keygen_perf.c',
               zlayout_ref='board_keygen_perf.c', zlayout_current='board_keygen_perf.c',
               keylayout_ref='board_keygen_perf.c', keylayout_current='board_keygen_perf.c')
IPRO_KINDS = ('ipro_ref', 'ipro_current', 'zpro_ref', 'zpro_current', 'zlayout_ref', 'zlayout_current')
ORTHO_KINDS = ('orthoprofile', 'orthocontrol')
PROFILE_KINDS = ('keyprofile', 'ntruprofile', 'ntrucontrol') + ORTHO_KINDS
kind, = sys.argv[1:]
assert kind in BENCHES
is_baseline = kind in ('keygen_ref', 'ipro_ref', 'zpro_ref', 'zlayout_ref', 'keylayout_ref')
crypto_root = M55/'M55_ref' if is_baseline else ROOT
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
files = list(crypto_root.glob('*.[chs]')) + list((ROOT/'validation/generated').glob('*.h'))
files += [ROOT/'validation'/name for name in (BENCHES[kind], 'CMakeLists.txt', 'build.sh')]
if kind in IPRO_KINDS:
    files += [ROOT/'validation'/n for n in ('integration_profile.c', 'integration_profile.h', 'generate_integration_profile.py')]
    files += [build/'generated'/n for n in ('kgen.c', 'kgen_ntru.c', 'integration_bench.c', 'integration_manifest.json')]
    manifest = json.loads((build/'generated/integration_manifest.json').read_text())
    for name, row in manifest['files'].items():
        original = ROOT/'validation/board_keygen_perf.c' if name == 'integration_bench.c' else crypto_root/name
        assert row['original_sha256'] == sha(original) and row['exact_original_recovered']
        assert row['generated_sha256'] == sha(build/'generated'/name)
if kind.startswith(('zlayout_', 'keylayout_')):
    files += [ROOT/'validation/pin_integer_layout.py', build/'fndsa_dtcm_linker.ld']
if kind == 'twiddlebench':
    files += [ROOT/'validation'/n for n in ('twiddle_baseline.h', 'old10_tw32_fft_mve.c', 'old10_tw32_bridge.c')]
if kind == 'bridgeprofile':
    files += [ROOT/'validation'/n for n in ('bridge_profile.h', 'generate_bridge_profile.py')]
    files += [build/'generated'/(prefix+'_'+name+'.c')
              for prefix in ('bc', 'bp') for name in ('tw32_bridge', 'tw32_fft_mve')]
    files.append(build/'generated/bridge_profile_manifest.json')
    m = json.loads(files[-1].read_text())
    assert m['recover_original']
    assert all(sha(ROOT/n) == h for n, h in m['originals'].items())
    assert all(sha(build/'generated'/n) == row['sha256'] for n, row in m['generated'].items())
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
crypto_rows = [r for r in commands if Path(r['file']).parent == crypto_root]
if kind in IPRO_KINDS:
    crypto_rows += [r for r in commands if Path(r['file']) in
                   (build/'generated/kgen.c', build/'generated/kgen_ntru.c')]
if kind in PROFILE_KINDS:
    crypto_rows += [r for r in commands if Path(r['file']) == build/'generated/kgen_ntru.c']
assert len(crypto_rows) == (23 if is_baseline else 30), len(crypto_rows)
for row in crypto_rows:
    assert (Path(row['file']).parent == crypto_root or
            kind in IPRO_KINDS and Path(row['file']).parent == build/'generated'), row['file']
for row in crypto_rows:
    flags = shlex.split(row['command'])
    assert [f for f in flags if f.startswith('-mfpu=')][-1] == '-mfpu=fpv5-d16'
    assert [f for f in flags if re.fullmatch(r'-O[0-3sgz]', f)][-1] == '-O3'
    assert all(f in flags for f in ('-mcpu=cortex-m55', '-ffp-contract=off', '-fno-fast-math',
                                   '-DFNDSA_ASM_CORTEXM4=1', '-DFNDSA_ASM_CORTEXM55=1'))
    assert ('-DFNDSA_MVE_MP31=1' in flags) == (not is_baseline)
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
if run.returncode and kind != 'kernels':
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
if kind in ('keygen_ref', 'keygen_current', 'keylayout_ref', 'keylayout_current') + IPRO_KINDS:
    rows = re.findall(r'^KEYGEN_PERF degree=(\d+) index=(\d+) cycles=(\d+) match=1 equation=PASS keyhash=([0-9a-f]{64})$', clean, re.M)
    expected = {(d, i) for d in (512, 1024) for i in range(100)}
    if len(rows) != 200 or {(int(d), int(i)) for d, i, c, h in rows} != expected:
        errors.append('whole-keygen performance/KAT rows')
    if any(int(c) <= 0 for d, i, c, h in rows):
        errors.append('keygen duration')
    if clean.count('KEYGEN_DONE count=200 mismatches=0') != 1:
        errors.append('whole-keygen completion')
    if len(re.findall(r'^KEYGEN_SUMMARY ', clean, re.M)) != 2:
        errors.append('whole-keygen summaries')
    if not re.search(r'^KEYGEN_HW cpu=800000000 cycle_hz=800000000 .*irq_mask=0 calls=100 warmups=3$', clean, re.M):
        errors.append('keygen clock/interrupt state')
    checks['whole_keygen_kat_equation_cases'] = len(rows)
    if kind in IPRO_KINDS:
        totals = re.findall(r'^IPRO_TOTAL degree=(\d+) cycles=(\d+) top=(\d+) ortho_leaves=(\d+) ntru_leaves=(\d+) errors=0$', clean, re.M)
        if len(totals) != 2 or {int(r[0]) for r in totals} != {512, 1024}:
            errors.append('integration profile accounting')
        if any(int(top) > int(total) for d,total,top,o,n in totals):
            errors.append('integration top-level overflow')
        checks['profile_byte_recovery'] = True
        checks['profile_regions'] = len(re.findall(r'^IPRO degree=', clean, re.M))
elif kind == 'twiddlebench':
    if clean.count('TWROOT_CHECK roots=2048 components=6144 mismatches=0') != 1:
        errors.append('precomputed roots differ')
    rows = re.findall(r'^TWROOT_OUTPUT logn=(\d+) cases=400 mismatches=0$', clean, re.M)
    if len(rows) != 9 or {int(r) for r in rows} != set(range(2, 11)):
        errors.append('transform byte equivalence')
    batches = re.findall(r'^TWROOT_BATCH degree=(\d+) inverse=(\d+) batch=(\d+) cases=330 mismatches=0$', clean, re.M)
    expected = {(d, inv, batch) for d in (512, 1024) for inv in (0, 1) for batch in range(5)}
    if len(batches) != 20 or {tuple(map(int, r)) for r in batches} != expected:
        errors.append('performance batch byte equivalence')
    if len(re.findall(r'^TWROOT_PERF ', clean, re.M)) != 80:
        errors.append('twiddle performance rows')
    if len(re.findall(r'^TWROOT_TIMING ', clean, re.M)) != 32:
        errors.append('twiddle timing classes')
    if clean.count('TWROOT_DONE batches=5 mismatches=0') != 1:
        errors.append('twiddle completion')
    checks['root_float_components'] = 6144
    checks['transform_equivalence_cases'] = len(rows)*400
    checks['benchmark_equivalence_cases'] = len(batches)*330
elif kind == 'bridgeprofile':
    rows = re.findall(r'^BPRO_CHECK degree=(\d+) inverse=(\d+) batch=(\d+) cases=440 mismatches=0$', clean, re.M)
    expected = {(d, inv, batch) for d in (512, 1024) for inv in (0, 1) for batch in range(5)}
    if len(rows) != 20 or {tuple(map(int, r)) for r in rows} != expected:
        errors.append('bridge profile output equivalence/accounting')
    if len(re.findall(r'^BPRO_TOTAL ', clean, re.M)) != 100:
        errors.append('bridge whole-function totals')
    if len(re.findall(r'^BPRO_REGION ', clean, re.M)) != 80:
        errors.append('bridge region totals')
    if clean.count('BPRO_DONE batches=5 mismatches=0') != 1:
        errors.append('bridge profile completion')
    checks['byte_identical_outputs'] = len(rows)*440
    checks['source_hook_reversibility'] = json.loads(
        (build/'generated/bridge_profile_manifest.json').read_text())['recover_original']
elif kind == 'kat':
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
elif kind == 'api_perf':
    rows = re.findall(r'^API_PERF degree=(\d+) batch=(\d+) total=(\d+) per_call=(\d+)$', clean, re.M)
    summaries = re.findall(r'^API_PERF_SUMMARY degree=(\d+) upper_median=(\d+) min=(\d+) max=(\d+) calls=100$', clean, re.M)
    expected = {(d, b) for d in (512, 1024) for b in range(10)}
    if len(rows) != 20 or {(int(d), int(b)) for d, b, t, p in rows} != expected:
        errors.append('API performance rows')
    if len(summaries) != 2 or {int(r[0]) for r in summaries} != {512, 1024}:
        errors.append('API performance summaries')
    if clean.count('API_PERF_DONE result=0') != 1:
        errors.append('API performance completion')
    checks['api_keygen_performance'] = [dict(degree=int(d), upper_median=int(m),
        minimum=int(lo), maximum=int(hi)) for d, m, lo, hi in summaries]
elif kind == 'guard_repro':
    expected = {(r['degree'], r['index']): r['digest'] for r in
                json.loads((ROOT/'validation/guard_reference.json').read_text())}
    rows = re.findall(r'^REPRO degree=(\d+) index=(\d+) digest=(\w+) verify=PASS tamper=PASS$', clean, re.M)
    got = {(int(d), int(i)): h for d, i, h in rows}
    if len(rows) != 5 or got != expected or clean.count('REPRO_DONE count=5') != 1:
        errors.append('original-reference regression/verify/tamper')
    checks['regression_matches_original_reference'] = got == expected
elif kind == 'kernels':
    perf = re.findall(r'^KERNEL_PERF op=(\w+) logn=(\d+) backend=([\w-]+) '
                      r'count=(\d+) min=(\d+) max=(\d+) sum=(\d+)$', clean, re.M)
    acc = re.findall(r'^KERNEL_ERROR op=(\w+) coefficients=(\d+) mismatches=(\d+) '
                     r'max_abs_q32_lsb=(\d+)$', clean, re.M)
    done = re.search(r'^KERNEL_DONE result=(\d+) mismatches=(\d+) sink=([0-9a-f]+)$', clean, re.M)
    if len(perf) != 18:
        errors.append('kernel performance rows')
    if len(acc) != 5:
        errors.append('kernel accuracy rows')
    if not done:
        errors.append('kernel completion')
    checks['kernel_performance_rows'] = len(perf)
    checks['kernel_accuracy'] = [dict(op=op, coefficients=int(n),
        mismatches=int(mm), max_abs_q32_lsb=int(mx)) for op, n, mm, mx in acc]
    if done:
        checks['kernel_total_mismatches'] = int(done.group(2))
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
            source_root=str(crypto_root), source=before, checks=checks,
            elf_sha256=sha(elf), compile_commands_sha256=sha(build/'compile_commands.json'),
            raw_sha256=sha(out/'raw.log'), local_crypto_translation_units=len(crypto_rows), command=command)
(out/'run.json').write_text(json.dumps(data, indent=2)+'\n')
print(json.dumps({k: data[k] for k in ('valid_measurement','errors','checks')}, indent=2), flush=True)
raise SystemExit(bool(errors))
