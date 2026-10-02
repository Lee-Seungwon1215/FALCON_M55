#!/usr/bin/env python3
"""Check the new keygen/verification records without replacing signing data."""
import hashlib
import json
from pathlib import Path
import re
import statistics
import sys
sys.dont_write_bytecode = True
import run

HERE = Path(__file__).resolve().parent
OPS = ('keygen', 'verify')
DEGREES = (512, 1024)
SAMPLE = re.compile(r'^KV_SAMPLE op=(keygen|verify) degree=(\d+) index=(\d+) cycles=(\d+)$', re.M)
SUMMARY = re.compile(r'^KV_SUMMARY op=(keygen|verify) degree=(\d+) calls=100 total=(\d+) '
    r'median_lo=(\d+) median_hi=(\d+) min=(\d+) max=(\d+)$', re.M)
DIGEST = re.compile(r'^KV_DIGEST op=(keygen|verify) degree=(\d+) sha3=([a-f0-9]{64})$', re.M)

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

spec = run.verify_sources()
layout = json.loads((HERE/'layout_audit_keyverify.json').read_text())
assert layout['valid']
records = []
for path in sorted((HERE/'results').glob('*_keyverify/*/manifest.json')):
    manifest = json.loads(path.read_text())
    assert manifest['valid_measurement'], (str(path), manifest['errors'])
    assert manifest['mode'] == 'keyverify'
    folder = path.parent
    variant = manifest['variant']
    assert sha(folder/'raw.log') == manifest['raw_sha256']
    assert sha(folder/'benchmark.elf') == manifest['elf_sha256'] == layout['elf_sha256'][variant]
    assert json.loads((folder/'source_manifest.json').read_text()) == spec
    for name, digest in spec['variants'][variant]['sha256'].items():
        assert manifest['source_sha256'][str(HERE/'variants'/variant/name)] == digest
    raw = re.sub(r'Info : [^\n]*\n', '', (folder/'raw.log').read_text())
    assert raw.count('KEYVERIFY_DONE keypairs=PASS verify=PASS tamper=PASS timer=PASS') == 1
    assert 'kg_irq=ON verify_irq=OFF' in raw
    timer = re.findall(r'^KV_TIMER_CHECK result=PASS systick64=(\d+) dwt32=(\d+) error=(-?\d+)$', raw, re.M)
    assert len(timer) == 1
    c64, c32, error = map(int, timer[0])
    assert c64-c32 == error and abs(error) <= 5000 and 79000000 <= c64 <= 81000000
    matches = re.findall(r'^Section .*: matched\.$', raw, re.M)
    assert len(matches) >= 10, 'incomplete load check'
    rows = SAMPLE.findall(raw)
    sums = SUMMARY.findall(raw)
    digests = {(op, int(n)): digest for op, n, digest in DIGEST.findall(raw)}
    assert len(rows) == 400 and len(sums) == 4 and len(digests) == 4
    record = dict(variant=variant, path=str(folder.relative_to(HERE)),
        timer_error_cycles=error, loaded_sections_matched=len(matches), operations={op: {} for op in OPS})
    for op, n, total, lo, hi, minimum, maximum in sums:
        n, total, lo, hi, minimum, maximum = map(int, (n, total, lo, hi, minimum, maximum))
        assert op in OPS and n in DEGREES
        indexed = [(int(i), int(c)) for o, degree, i, c in rows if o == op and int(degree) == n]
        assert [i for i, _ in indexed] == list(range(100))
        samples = [c for _, c in indexed]
        ordered = sorted(samples)
        assert sum(samples) == total and ordered[49:51] == [lo, hi]
        assert (ordered[0], ordered[-1]) == (minimum, maximum)
        assert n not in record['operations'][op]
        record['operations'][op][n] = dict(samples=samples, mean_cycles=total/100,
            median_cycles=(lo+hi)/2, min_cycles=minimum, max_cycles=maximum,
            digest=digests[(op,n)])
    records.append(record)

assert len(records) == 8, ('Expected two runs per variant', len(records))
timing = {op: {} for op in OPS}
digests = {op: {} for op in OPS}
for op in OPS:
    for n in DEGREES:
        values = {r['operations'][op][n]['digest'] for r in records}
        assert len(values) == 1, ('different key/signature inputs or outputs', op, n, values)
        digests[op][n] = next(iter(values))
    for variant in run.VARIANTS:
        trials = [r for r in records if r['variant'] == variant]
        assert len(trials) == 2
        timing[op][variant] = {}
        for n in DEGREES:
            samples = [c for r in trials for c in r['operations'][op][n]['samples']]
            means = [r['operations'][op][n]['mean_cycles'] for r in trials]
            mean = statistics.mean(samples)
            timing[op][variant][n] = dict(mean_cycles=mean,
                median_cycles=statistics.median(samples), min_cycles=min(samples), max_cycles=max(samples),
                samples=len(samples), run_means=means,
                run_mean_spread_percent=100*(max(means)-min(means))/mean)
    for variant in run.VARIANTS:
        for n in DEGREES:
            baseline = timing[op]['ref'][n]['mean_cycles']
            value = timing[op][variant][n]['mean_cycles']
            timing[op][variant][n].update(speedup_vs_ref=baseline/value,
                cycles_reduction_percent=100*(1-value/baseline))

effects = {op: {} for op in OPS}
for op in OPS:
    for n in DEGREES:
        ref, ntt, fft, both = (timing[op][v][n]['mean_cycles'] for v in run.VARIANTS)
        effects[op][n] = dict(ntt_alone_saved_cycles=ref-ntt,
            signing_fft_alone_saved_cycles=ref-fft,
            signing_fft_on_ntt_saved_cycles=ntt-both,
            signing_fft_on_ntt_cycles_reduction_percent=100*(1-both/ntt),
            interaction_cycles=both-ntt-fft+ref)

out = dict(timing=timing, effects=effects, digests=digests, runs=records, layout=layout,
    total_timed_calls=len(records)*400,
    limitations='Same four source trees as signing. Signing FFT only, no keygen FFT A17. Keygen: 100 distinct deterministic seeds, 64-bit timer and IRQ ON. Verify: 100 signatures for one fixed key, DWT and IRQ OFF. Each workload repeated twice. No all-input or full constant-time proof.')
(HERE/'summary_keyverify.json').write_text(json.dumps(out, indent=2)+'\n')
print(json.dumps(dict(timing=timing, effects=effects, digests=digests), indent=2))
