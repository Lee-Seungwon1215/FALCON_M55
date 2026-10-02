"""Summarize every archived candidate by its source hash, not a folder label."""
import hashlib
import json
from pathlib import Path
import re
import statistics

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()

sources = {'original': ROOT / 'sha3_cm4.s', 'selected': ROOT / 'sha3_cm55.s'}
sources.update({p.stem: p for p in (HERE.parent / 'candidates').glob('*.s')})
report = {'sources': {}, 'failed_runs': []}
for name, source in sources.items():
    digest = sha(source)
    runs = {}
    for directory in sorted((HERE / 'results').glob('*/*')):
        if not (directory / 'manifest.json').exists():
            continue
        m = json.loads((directory / 'manifest.json').read_text())
        if m['production_sha256'] != digest:
            continue
        if not m['valid_measurement']:
            continue
        mode = m['variant'].split('-')[1]
        raw = re.sub(r'Info : [^\n]*\n', '', (directory / 'raw.log').read_text())
        rows = [dict((k, int(v)) for k, v in re.findall(r'(\w+)=(\d+)', line))
                for line in raw.splitlines() if line.startswith('PART_SAMPLE ')]
        assert len(rows) == 100
        values = [r['total'] / 64 for r in rows] if mode in ('plain', 'aligned') else [
            r['raw'] - r['n'] * r['calibration'] / 64 for r in rows]
        audit = json.loads((directory / 'audit.json').read_text())
        runs[mode] = dict(path=str(directory.relative_to(HERE)),
                          cycles=statistics.median(values), min=min(values), max=max(values),
                          text_bytes=audit['production_text_bytes'],
                          elf_sha256=m['elf_sha256'])
    report['sources'][name] = dict(path=str(source.relative_to(ROOT)), sha256=digest, runs=runs)

for directory in sorted((HERE / 'results').glob('*/*')):
    if (directory / 'manifest.json').exists():
        m = json.loads((directory / 'manifest.json').read_text())
        if not m['valid_measurement']:
            report['failed_runs'].append(dict(path=str(directory.relative_to(HERE)), manifest=m))

baseline = report['sources']['original']['runs']
for entry in report['sources'].values():
    for mode, run in entry['runs'].items():
        if mode in baseline:
            a, b = baseline[mode]['cycles'], run['cycles']
            run.update(speedup=a/b, cycle_reduction_percent=100*(1-b/a))

(HERE / 'experiments.json').write_text(json.dumps(report, indent=2) + '\n')
for name, entry in report['sources'].items():
    print(name, {k: (v['cycles'], round(v.get('speedup', 0), 6)) for k, v in entry['runs'].items()})
