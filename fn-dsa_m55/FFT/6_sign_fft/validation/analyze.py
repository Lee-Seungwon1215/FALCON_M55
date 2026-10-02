#!/usr/bin/env python3
"""Check provenance and summarize current-source successful board runs.

Failed and superseded runs remain in results/ and are explicitly listed.
No measurements are synthesized from the earlier instrumented profile.
"""
import hashlib
import json
from pathlib import Path
import re
import struct
import subprocess
import tarfile

HERE = Path(__file__).resolve().parent
WORKSPACE = HERE.parents[3]
SOURCE = HERE.parent
BASE = WORKSPACE / 'Final_code/Before_slothy'
TOOL = WORKSPACE / 'fn-dsa_m55/measurement_mlkem_native/env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin'

def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def rows(text, prefix):
    return [dict(re.findall(r'(\w+)=([^ ]+)', line))
            for line in text.splitlines() if line.startswith(prefix + ' ')]

sources = sorted(p for p in SOURCE.iterdir() if p.suffix in ('.c', '.h', '.s'))
changed = [p.name for p in sources if not (BASE/p.name).exists() or sha(p) != sha(BASE/p.name)]
assert changed == ['sign_fft_cm55.s', 'sign_fpoly.c'], changed
with tarfile.open(HERE/'native_c_baseline.tar.gz') as tf:
    frozen = tf.extractfile('sign_fpoly.c').read().decode()
    a = frozen.index('/* M55 signing FFT only:')
    b = frozen.index('/* If rev()')
    c = frozen.index('/* see sign_inner.h */\nTARGET_SSE2 TARGET_NEON\nvoid\nfpoly_FFT(')
    d = frozen.index('/* see sign_inner.h */\nTARGET_SSE2 TARGET_NEON\nvoid\nfpoly_set_small(')
    expected = frozen[:a] + frozen[b:c] + '/* fpoly_FFT() and fpoly_iFFT() are implemented in sign_fft_cm55.s. */\n\n' + frozen[d:]
    expected = re.sub(r'\bGM\b', 'fndsa_sign_gm', expected).replace(
        'static const fpr fndsa_sign_gm[]',
        'const fpr fndsa_sign_gm[] __attribute__((aligned(8)))')
    assert (SOURCE/'sign_fpoly.c').read_text() == expected, 'unintended non-FFT/table change'
    for q in sources:
        if q.name not in ('sign_fpoly.c','sign_fft_cm55.s'):
            assert tf.extractfile(q.name).read() == q.read_bytes(), q.name
    expected_make = tf.extractfile('Makefile').read().decode().replace(
        ' mq_cm55.s kgen_mp31_cm55.s kgen_fft_cm55.s\n',
        ' mq_cm55.s kgen_mp31_cm55.s kgen_fft_cm55.s sign_fft_cm55.s\n')
    assert (SOURCE/'Makefile').read_text() == expected_make
selected = {}
excluded = []
for p in sorted((HERE/'results').glob('*/*/manifest.json')):
    m = json.loads(p.read_text()); run = p.parent
    assert sha(run/'raw.log') == m['raw_sha256']
    assert sha(run/'benchmark.elf') == m['elf_sha256']
    root = SOURCE if m['variant'] == 'candidate' else BASE
    root_sources = [q for q in root.iterdir() if q.suffix in ('.c','.h','.s')]
    current = all(m['source_sha256'].get(str(q)) == sha(q) for q in root_sources)
    before_asm = m['variant'] == 'baseline' and run.name < '20260928T081848Z'
    if not m['valid_measurement'] or not current or before_asm:
        excluded.append({'run': str(run.relative_to(HERE)), 'errors': m['errors'], 'current_source': current})
        continue
    key = m['variant'] + '_' + m['mode']
    selected.setdefault(key, []).append(run)

for key in ('candidate_kernel', 'candidate_sigkat', 'candidate_kat', 'candidate_extra',
            'candidate_api', 'candidate_sign', 'candidate_sign_native', 'baseline_sign'):
    assert key in selected, ('missing successful final-source test', key)

kernel_run = selected['candidate_kernel'][-1]
assert 'FFT_ABI calls=20 failures=0' in (kernel_run/'raw.log').read_text()
text = (kernel_run/'raw.log').read_text()
perf = rows(text, 'FFT_PERF')
kernel = []
for degree in (512, 1024):
    for inv in (0, 1):
        pair = {r['implementation']:r for r in perf if int(r['degree']) == degree and int(r['inverse']) == inv}
        orig = int(pair['original']['median_hi']); native = int(pair['asm']['median_hi']); c_native = int(pair['native_c']['median_hi'])
        kernel.append(dict(degree=degree, function='fpoly_iFFT' if inv else 'fpoly_FFT',
            baseline_cycles=orig, native_c_cycles=c_native, asm_cycles=native, speedup=orig/native,
            native_c_speedup=c_native/native, native_c_cycle_reduction_percent=100*(1-native/c_native),
            cycle_reduction_percent=100*(1-native/orig)))
ct = []
for degree in (512, 1024):
    for inv in (0, 1):
        rr = [r for r in rows(text, 'FFT_CT') if int(r['degree']) == degree and int(r['inverse']) == inv]
        assert len(rr) == 8
        ct.append(dict(degree=degree, inverse=inv, classes=8, calls_per_class=100,
            min_cycles=min(int(r['min']) for r in rr), max_cycles=max(int(r['max']) for r in rr),
            class_means=[int(r['total'])/100 for r in rr]))
error = rows(text, 'FFT_ROUNDTRIP')[0]['max_abs_error_bits']
roundtrip_error = struct.unpack('>d', bytes.fromhex(error))[0]

sign = []
for degree in (512, 1024):
    means = {}; totals = {}; fingerprints = set()
    for variant in ('baseline', 'native_c', 'candidate'):
        runs = selected['candidate_sign_native' if variant=='native_c' else variant+'_sign']; means[variant] = []; totals[variant] = 0
        for run in runs:
            t = (run/'raw.log').read_text()
            r, = [r for r in rows(t, 'SIGN_SUMMARY') if int(r['degree']) == degree]
            assert int(r['calls']) == 100
            rr = [r for r in rows(t, 'SIGN_SAMPLE') if int(r['degree']) == degree]
            assert len(rr) == 100 and sum(int(s['cycles']) for s in rr) == int(r['total'])
            means[variant].append(int(r['total'])/100);totals[variant] += int(r['total'])
            fingerprints.add(r['fingerprint'])
    assert fingerprints == ({'9895079d'} if degree == 512 else {'a020dd02'})
    original = totals['baseline']/(100*len(means['baseline']))
    native = totals['candidate']/(100*len(means['candidate']))
    c_native = totals['native_c']/(100*len(means['native_c']))
    sign.append(dict(degree=degree, baseline_mean=original, native_c_mean=c_native, asm_mean=native,
        native_c_speedup=c_native/native, native_c_cycle_reduction_percent=100*(1-native/c_native),
        speedup=original/native, cycle_reduction_percent=100*(1-native/original),
        per_run_means=means))

disasm = (kernel_run/'disassembly.txt').read_text()
static = {}
for name in ('fndsa_fpoly_FFT','fndsa_fpoly_iFFT'):
    m = re.search(r'^([0-9a-f]+) <'+name+r'>:\n(.*?)(?=\n[0-9a-f]+ <|\Z)', disasm, re.M|re.S)
    assert m, name
    body = m[2]
    assert 'vmul.f64' in body and 'vadd.f64' in body and 'vsub.f64' in body
    assert not re.search(r'\b(?:vfma|vfms|vfnma|vfnms)\.', body)
    assert not re.search(r'\tbl(?:x|\.w)?\s', body), ('unexpected helper call',name)
    assert not re.search(r'\b(?:vcvt|vdiv|vsqrt|vcmp)', body)
    (HERE/(name+'.dis')).write_text(m[0])
    static[name] = dict(address=m[1], calls=0, fused_fma=0, numeric_conversions=0,
        vldr=len(re.findall(r'\tvldr\s',body)), vstr=len(re.findall(r'\tvstr\s',body)),
        branch_lines=[line.strip() for line in body.splitlines()
            if re.search(r'^[ \t]*[0-9a-f]+:\s+(?:[0-9a-f]{4}\s+){1,2}'
                         r'(?:b(?:eq|ne|cs|cc|mi|pl|vs|vc|hi|ls|ge|lt|gt|le|x)?|le|dls)'
                         r'(?:\.\w+)?\s', line)])

report = dict(changed_production_sources=changed, total_production_sources=len(sources),
    frozen_native_archive_sha256=sha(HERE/'native_c_baseline.tar.gz'),
    unchanged_other_functions_and_table_bits=True,
    selected_runs={k:[str(r.relative_to(HERE)) for r in v] for k,v in selected.items()},
    excluded_runs=excluded, kernel=kernel, sign=sign, ct_screen=ct,
    roundtrip_integer_input_max_abs_error=roundtrip_error, static_audit=static,
    source_sha256={p.name:sha(p) for p in sources})
(HERE/'summary.json').write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps({k:v for k,v in report.items() if k!='source_sha256'},indent=2))
