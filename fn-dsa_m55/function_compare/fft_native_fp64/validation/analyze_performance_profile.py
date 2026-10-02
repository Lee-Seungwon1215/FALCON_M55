#!/usr/bin/env python3
"""Collect current-source kernel timing and real-keygen phase proportions.

The profile denominator is the sum of disjoint measured approximate-k
regions, NOT whole keygen or whole NTRU solve. Timing hooks are not used
for the independent same-ELF kernel speed measurements.
"""
import argparse
import hashlib
import json
import re
import subprocess
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
parser = argparse.ArgumentParser()
for name in ('perf', 'repeat-perf', 'reference-profile', 'trial-profile'):
    parser.add_argument('--' + name, type=Path, required=True)
args = parser.parse_args()
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
evidence, raw = {}, {}
for label, directory in vars(args).items():
    r = json.loads((directory / 'run.json').read_text())
    assert r['valid_measurement'], (label, r['errors'])
    assert sha(directory / 'raw.log') == r['raw_sha256']
    assert all(sha(Path(p)) == h for p, h in r['source'].items()), label
    elf = ROOT / 'build' / (r['backend'] + '-' + r['kind']) / 'zephyr/zephyr.elf'
    assert sha(elf) == r['elf_sha256'], label
    evidence[label] = dict(path=str(directory.resolve()), run=r)
    raw[label] = (directory / 'raw.log').read_text()
assert evidence['perf']['run']['elf_sha256'] == evidence['repeat_perf']['run']['elf_sha256']

def records(text, tag):
    result = []
    for line in text.splitlines():
        if line.startswith(tag + ' '):
            row = dict(x.split('=', 1) for x in line.split()[1:])
            result.append({k: int(v) if v.isdigit() else v for k, v in row.items()})
    return result

kernel = records(raw['perf'], 'KPERF')
repeat_kernel = records(raw['repeat_perf'], 'KPERF')
assert len(kernel) == len(repeat_kernel) == 266
for label in ('perf', 'repeat_perf'):
    rows = records(raw[label], 'PERF_K')
    assert len(rows) == 19 and all(r['differences'] == r['fixed_fixture_errors'] == 0 for r in rows)
    assert all(r['count'] == 100 for r in records(raw[label], 'KPERF'))

ops = ('FFT', 'iFFT', 'pointwise', 'inverse', 'prepare', 'repeat', 'pipeline')
speed = []
for logn in range(1, 10):
    for op in ops:
        means = {}
        for backend in ('fixed', 'q32_trial'):
            rows = [r for r in kernel if r['logn'] == logn and r['op'] == op
                    and r['backend'] == backend and r['case'] != 18]
            assert len(rows) == 2
            means[backend] = sum(r['sum'] / r['count'] for r in rows) / 2
        ratio = means['q32_trial'] / means['fixed']
        speed.append(dict(n=1 << logn, op=op, fixed_cycles=means['fixed'],
                          trial_cycles=means['q32_trial'], trial_over_fixed=ratio,
                          cycle_increase_percent=100*(ratio-1)))

groups = {
    'input_conversion': ('input_f', 'input_F'),
    'FFT': ('FFT_f', 'FFT_F'),
    'inverse': ('inverse',),
    'pointwise': ('pointwise',),
    'iFFT': ('iFFT',),
    'round_and_guard': ('round', 'guard'),
}
profiles = {}
key_digests = {}
for label in ('reference_profile', 'trial_profile'):
    rows = records(raw[label], 'APRO')
    assert len(rows) == 153
    keys = records(raw[label], 'APRO_KEY')
    assert len(keys) == 200 and all(r['match'] == 1 and r['equation'] == 'PASS' for r in keys)
    key_digests[label] = {(r['degree'], r['index']): r['actual'] for r in keys}
    empty = records(raw[label], 'APRO_EMPTY')
    assert len(empty) == 1 and empty[0]['calls'] == 1000
    empty_mean = empty[0]['cycles'] / empty[0]['calls']
    degrees = {}
    for degree, logn_top in ((512, 9), (1024, 10)):
        selected = [r for r in rows if r['degree'] == degree]
        by_step = {}
        for logn in range(1, logn_top):
            counts = {r['op']: r['calls'] for r in selected if r['logn'] == logn}
            assert len(counts) == 9
            assert counts['input_f'] == counts['FFT_f'] == counts['inverse'] > 0
            assert counts['input_F'] == counts['FFT_F'] == counts['pointwise'] == counts['iFFT'] == counts['round'] > 0
            assert counts['guard'] == (counts['round'] if label == 'trial_profile' else 0)
        for op in {r['op'] for r in rows}:
            matching = [r for r in selected if r['op'] == op]
            by_step[op] = dict(calls=sum(r['calls'] for r in matching),
                               cycles=sum(r['cycles'] for r in matching))
        total = sum(r['cycles'] for r in selected)
        calls = sum(r['calls'] for r in selected)
        grouped = {}
        for name, members in groups.items():
            cycles = sum(by_step[op]['cycles'] for op in members)
            grouped[name] = dict(cycles=cycles, mean_cycles_per_key=cycles/100,
                                 share_percent=100*cycles/total)
        assert abs(sum(r['share_percent'] for r in grouped.values()) - 100) < 1e-10
        degrees[degree] = dict(runs=100, summed_region_cycles=total,
                               mean_region_cycles_per_key=total/100,
                               empty_hook_estimate_percent=100*calls*empty_mean/total,
                               groups=grouped, individual_steps=by_step)
    profiles[label] = dict(degrees=degrees, raw=rows, empty_interval_mean=empty_mean)
assert key_digests['reference_profile'] == key_digests['trial_profile']
kat_raw = (ROOT/'results/q32_trial-kat/20260923T095214Z/raw.log').read_text()
kat = {(int(d), int(i)): h for d, i, h in re.findall(
    r'BOARD_KAT degree=(\d+) index=(\d+) match=1 equation=PASS actual=(\w+)', kat_raw)}
assert all(kat[k] == h for k, h in key_digests['trial_profile'].items())

out = ROOT/'results/performance-profile-analysis'/datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ')
out.mkdir(parents=True, exist_ok=False)
tool = ROOT.parents[1]/'measurement_mlkem_native/env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin'
elf = ROOT/'build/q32_trial-perfct/zephyr/zephyr.elf'
symbols = subprocess.check_output([str(tool/'arm-none-eabi-nm'), str(elf)], text=True)
(out/'symbols.txt').write_text(symbols)
for name in ('probe_floor', 'fndsa_vect_FFT_fp64', 'fndsa_vect_iFFT_fp64'):
    asm = subprocess.check_output([str(tool/'arm-none-eabi-objdump'), '-d', '--disassemble='+name, str(elf)], text=True)
    (out/(name+'.s.txt')).write_text(asm)
ct = records(raw['perf'], 'CT_FFT')
assert len(ct) == 72
result = dict(
    source_guard_header_sha256=sha(ROOT/'q32_trial/kgen_inner.h'),
    kernel_performance=speed, profiles=profiles, evidence=evidence,
    same_elf_kernel_repeat_exact=kernel == repeat_kernel,
    profile_key_kat='200/200 each; reference/trial/pre-profile actual digests identical',
    frozen_kernel_outputs='19/19 final k and original fixtures match, both runs',
    profile_denominator='sum of instrumented disjoint approximate-k regions inside solve_NTRU_intermediate, 100 actual keygens, all reached attempts/depths',
    exclusions='not whole keygen/NTRU; excludes integer update, RNS/CRT, other solve stages, scaling/control outside regions, timer bookkeeping between regions',
    profile_caveat='raw region times include measurement overhead; separate ELFs/addresses, no forced address matching; kernel comparison is same ELF and data buffers',
    ct_fft_rows=ct, software_double_helpers=[s for s in symbols.splitlines() if '__aeabi_d' in s],
    constant_time_status='known operand-dependent timing remains; not a security certification',
    counterexample=records(raw['perf'], 'COUNTEREXAMPLE_BOARD'))
(out/'summary.json').write_text(json.dumps(result, indent=2)+'\n')

lines = ['## 커널 재측정', '', '| 구간 | FFT 256 fixed cycles | FP64 cycles | FP64/fixed | FFT 512 fixed cycles | FP64 cycles | FP64/fixed |',
         '|---|---:|---:|---:|---:|---:|---:|']
for op in ops:
    row = [op]
    for n in (256, 512):
        r = next(r for r in speed if r['n'] == n and r['op'] == op)
        row += [f"{r['fixed_cycles']:,.0f}", f"{r['trial_cycles']:,.0f}", f"{r['trial_over_fixed']:.4f}"]
    lines.append('| ' + ' | '.join(row) + ' |')
lines += ['', '## 실제 키생성의 근사 k 구간 비중', '',
          '| 연산 | 512 fixed | 512 FP64 | 1024 fixed | 1024 FP64 |', '|---|---:|---:|---:|---:|']
for name in groups:
    row = [name]
    for degree in (512, 1024):
        for backend in ('reference_profile', 'trial_profile'):
            r = profiles[backend]['degrees'][degree]['groups'][name]
            row.append(f"{r['share_percent']:.2f}%")
    lines.append('| ' + ' | '.join(row) + ' |')
lines += ['| 합계 | 100% | 100% | 100% | 100% |', '', '## 구간 누적 / 100 keys', '']
for degree in (512, 1024):
    fixed = profiles['reference_profile']['degrees'][degree]
    trial = profiles['trial_profile']['degrees'][degree]
    lines.append(f"- {degree}: fixed={fixed['mean_region_cycles_per_key']:,.0f}, FP64={trial['mean_region_cycles_per_key']:,.0f} cycles/key; ratio={trial['summed_region_cycles']/fixed['summed_region_cycles']:.4f}")
    lines.append(f"  empty-hook estimate: fixed={fixed['empty_hook_estimate_percent']:.4f}%, FP64={trial['empty_hook_estimate_percent']:.4f}%")
(out/'tables.md').write_text('\n'.join(lines)+'\n')
print('PERFORMANCE_PROFILE_REPORT', out)
print('\n'.join(lines))
