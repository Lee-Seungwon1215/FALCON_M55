"""Summarize accepted same-board runs; keep intrusive estimates separate."""
import hashlib
import json
from pathlib import Path
import re
import statistics

HERE = Path(__file__).resolve().parent
source_hash = hashlib.sha256((HERE.parent.parent / 'sha3_cm55.s').read_bytes()).hexdigest()
names = tuple(x+'-'+m for m in ('plain','aligned','iota','tail','core') for x in ('ref','mve'))
summary = {'candidate_sha256': source_hash, 'runs': {}, 'comparisons': {}}

def stats(x):
    return dict(mean=statistics.mean(x), median=statistics.median(x),
                min=min(x), max=max(x), stdev=statistics.stdev(x))

for name in names:
    accepted = []
    for path in sorted((HERE / 'results' / name).glob('*')):
        if not (path / 'manifest.json').exists():
            continue
        manifest = json.loads((path / 'manifest.json').read_text())
        if manifest['valid_measurement'] and (name.startswith('ref') or manifest['production_sha256'] == source_hash):
            accepted.append((path, manifest))
    if not accepted:
        continue
    path, manifest = accepted[-1]
    audit = json.loads((path / 'audit.json').read_text())
    raw = re.sub(r'Info : [^\n]*\n', '', (path / 'raw.log').read_text())
    rows = [dict((k, int(v)) for k, v in re.findall(r'(\w+)=(\d+)', line))
            for line in raw.splitlines() if line.startswith('PART_SAMPLE ')]
    assert len(rows) == 100 and [r['i'] for r in rows] == list(range(100))
    d = dict(path=str(path.relative_to(HERE)), manifest=manifest, audit=audit,
             total_cycles=stats([r['total'] / 64 for r in rows]))
    if name.split('-')[1] not in ('plain', 'aligned'):
        assert all(r['cal_min'] == r['cal_max'] and r['cal_min'] > 0 for r in rows)
        d['interval_count'] = sorted({r['n'] for r in rows})
        d['interval_cycles'] = stats([r['raw'] - r['n'] * r['calibration'] / 64 for r in rows])
        d['calibration_cycles'] = rows[0]['cal_min']
    classes = [dict((k, int(v)) for k, v in re.findall(r'(\w+)=(\d+)', line))
               for line in raw.splitlines() if line.startswith('TIMING_CLASS ')]
    d['timing_classes'] = classes
    summary['runs'][name] = d

for mode in ('plain','aligned','iota','tail','core'):
    if not all(x + '-' + mode in summary['runs'] for x in ('ref', 'mve')):
        continue
    key = 'total_cycles' if mode in ('plain', 'aligned') else 'interval_cycles'
    a, b = (summary['runs'][x + '-' + mode][key]['median'] for x in ('ref', 'mve'))
    summary['comparisons'][mode] = dict(reference=a, candidate=b, speedup=a/b,
                                     cycle_reduction_percent=100*(1-b/a))
(HERE / 'summary.json').write_text(json.dumps(summary, indent=2) + '\n')
print(json.dumps(summary['comparisons'], indent=2))
