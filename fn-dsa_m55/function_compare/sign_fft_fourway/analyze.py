#!/usr/bin/env python3
"""Validate archived board evidence and calculate the four-way comparison."""
import hashlib
import json
from pathlib import Path
import re
import statistics
import sys
sys.dont_write_bytecode = True
import run

HERE = Path(__file__).resolve().parent
DEGREES = (512, 1024)
EXPECTED_FP = {512: '9895079d', 1024: 'a020dd02'}
SUMMARY = re.compile(r'^SIGN_SUMMARY degree=(\d+) calls=(\d+) total=(\d+) '
    r'median_lo=(\d+) median_hi=(\d+) min=(\d+) max=(\d+) fingerprint=([0-9a-f]+)$', re.M)
SAMPLE = re.compile(r'^SIGN_SAMPLE degree=(\d+) index=(\d+) cycles=(\d+)$', re.M)

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

run.verify_sources()
layout = json.loads((HERE/'layout_audit.json').read_text())
assert layout['valid']
records = []
for path in sorted((HERE/'results').glob('*/*/manifest.json')):
    m = json.loads(path.read_text())
    if m['mode'] == 'keyverify':
        continue  # Separate timing experiment, analyzed by analyze_keyverify.py.
    if not m['valid_measurement']:
        raise AssertionError(('invalid run; inspect and explicitly exclude', str(path), m['errors']))
    folder = path.parent
    assert sha(folder/'raw.log') == m['raw_sha256']
    assert sha(folder/'benchmark.elf') == m['elf_sha256']
    archived = json.loads((folder/'source_manifest.json').read_text())
    assert archived == json.loads((HERE/'source_manifest.json').read_text())
    # Confirm captured inputs still describe exactly the local implementation.
    variant = m['variant']
    for name, digest in archived['variants'][variant]['sha256'].items():
        assert m['source_sha256'][str(HERE/'variants'/variant/name)] == digest
    raw = re.sub(r'Info : [^\n]*\n', '', (folder/'raw.log').read_text())
    record = dict(variant=variant, mode=m['mode'], path=str(folder.relative_to(HERE)))
    if m['mode'] == 'sign':
        assert m['elf_sha256'] == layout['elf_sha256'][variant]
        assert raw.count('SIGN_DONE verify=PASS tamper=PASS fingerprints=PASS') == 1
        rows = [(int(n), int(i), int(c)) for n, i, c in SAMPLE.findall(raw)]
        sums = SUMMARY.findall(raw)
        assert len(rows) == 200 and len(sums) == 2
        record['degrees'] = {}
        for n, count, total, lo, hi, minimum, maximum, fp in sums:
            n, count, total, lo, hi, minimum, maximum = map(int, (n, count, total, lo, hi, minimum, maximum))
            indexed = [(i, c) for degree, i, c in rows if degree == n]
            assert [i for i, _ in indexed] == list(range(100)) and count == 100
            samples = [c for _, c in indexed]
            ordered = sorted(samples)
            assert sum(samples) == total and ordered[49:51] == [lo, hi]
            assert (ordered[0], ordered[-1], fp) == (minimum, maximum, EXPECTED_FP[n])
            record['degrees'][n] = dict(mean_cycles=total/count, samples=samples,
                median_cycles=(lo+hi)/2, min_cycles=minimum, max_cycles=maximum, fingerprint=fp)
    elif m['mode'] == 'sigkat':
        assert raw.count('BOARD_SIGNKAT_DONE count=90 mismatches=0') == 1
        assert len(re.findall(r'^BOARD_SIGNKAT .*match=1 verify=PASS tamper=PASS', raw, re.M)) == 90
        record['tests_passed'] = 90
    elif m['mode'] == 'kat':
        assert raw.count('BOARD_KAT_DONE result=0 count=300 mismatches=0') == 1
        assert len(re.findall(r'^BOARD_KAT .*match=1 equation=PASS', raw, re.M)) == 300
        record['tests_passed'] = 300
    else:
        raise AssertionError(m['mode'])
    records.append(record)

timing = {}
for variant in run.VARIANTS:
    trials = [r for r in records if r['variant'] == variant and r['mode'] == 'sign']
    assert len(trials) == 2, (variant, 'expected two signing runs', len(trials))
    assert len([r for r in records if r['variant'] == variant and r['mode'] == 'sigkat']) == 1
    timing[variant] = {}
    for n in DEGREES:
        samples = [c for r in trials for c in r['degrees'][n]['samples']]
        means = [r['degrees'][n]['mean_cycles'] for r in trials]
        mean = statistics.mean(samples)
        timing[variant][n] = dict(mean_cycles=mean, median_cycles=statistics.median(samples),
            min_cycles=min(samples), max_cycles=max(samples), samples=len(samples),
            run_means=means, run_mean_spread_percent=100*(max(means)-min(means))/mean)
for variant in ('ref', 'ntt_only'):
    assert len([r for r in records if r['variant'] == variant and r['mode'] == 'kat']) == 1
for variant in run.VARIANTS:
    for n in DEGREES:
        baseline = timing['ref'][n]['mean_cycles']
        value = timing[variant][n]['mean_cycles']
        timing[variant][n].update(speedup_vs_ref=baseline/value, cycles_reduction_percent=100*(1-value/baseline))

effects = {}
for n in DEGREES:
    ref, ntt, fft, both = (timing[v][n]['mean_cycles'] for v in run.VARIANTS)
    effects[n] = dict(
        ntt_alone_saved_cycles=ref-ntt,
        fft_alone_saved_cycles=ref-fft,
        ntt_on_fft_saved_cycles=fft-both,
        ntt_on_fft_cycles_reduction_percent=100*(1-both/fft),
        ntt_on_fft_speedup=fft/both,
        fft_on_ntt_cycles_reduction_percent=100*(1-both/ntt),
        fft_on_ntt_speedup=ntt/both,
        interaction_cycles=both-ntt-fft+ref,
        interaction_percent_of_ref=100*(both-ntt-fft+ref)/ref)

out = dict(timing=timing, effects=effects, runs=records,
    total_signing_samples=sum(timing[v][n]['samples'] for v in run.VARIANTS for n in DEGREES),
    layout=layout,
    limitations='Two repeated 100-seed runs per degree, one timed signing key per degree; not all-key equivalence or constant-time proof. Keygen preparation is outside the signing timer.')
(HERE/'summary.json').write_text(json.dumps(out, indent=2)+'\n')
print(json.dumps(dict(timing=timing, effects=effects), indent=2))
