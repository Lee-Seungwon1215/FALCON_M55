"""Summarize paired whole-operation four-job timings; never mix older x4 PRNG data."""
from pathlib import Path
import json
import re
import statistics

HERE=Path(__file__).resolve().parent
runs=[]
for p in sorted((HERE/'results/keygen_verify_batch4').glob('*')):
    manifest=p/'manifest.json'
    if manifest.exists() and json.loads(manifest.read_text()).get('valid'):
        runs.append(p)
if not runs:raise SystemExit('No valid run')
run=runs[-1]
raw=re.sub(r'Info : [^\n]*\n','',(run/'raw.log').read_text())
samples=[]
for m in re.finditer(r'^BATCH op=(\w+) n=(\d+) group=(\d+) rep=(\d+) blocks=(\d+) single=(\d+) batch=(\d+)(?: calls=(\d+))?$',raw,re.M):
    op,n,group,rep,blocks,single,batch,calls=m.groups()
    samples.append(dict(op=op,n=int(n),group=int(group),rep=int(rep),blocks=int(blocks),
        single=int(single)/int(calls or 1),batch=int(batch)/int(calls or 1)))
assert len(samples)==36,len(samples)
rows=[]
for op,n,blocks in sorted({(s['op'],s['n'],s['blocks']) for s in samples}):
    medians=[]
    for group in (0,1):
        entries=[s for s in samples if (s['op'],s['n'],s['blocks'],s['group'])==(op,n,blocks,group)]
        assert len(entries)==3
        medians.append({k:statistics.median(s[k] for s in entries) for k in ('single','batch')})
    base=statistics.mean(g['single'] for g in medians)
    opt=statistics.mean(g['batch'] for g in medians)
    rows.append(dict(op=op,n=n,blocks=blocks,single=base,batch=opt,speedup=base/opt,
        cycle_reduction_percent=100*(base-opt)/base))
checks=[l for l in raw.splitlines() if l.startswith(('CHECK ','BENCH_DONE','BENCH_HW'))]
result=dict(run=str(run.relative_to(HERE)),aggregation='mean of two input-batch medians, three repeats each',
    unit='four independent jobs, including all preparation',rows=rows,checks=checks)
(HERE/'summary.json').write_text(json.dumps(result,indent=2)+'\n')
for r in rows:
    print(f"{r['op']} {r['n']} blocks={r['blocks']}: {r['single']:,.3f} -> {r['batch']:,.3f} cycles; {r['speedup']:.5f}x; reduction={r['cycle_reduction_percent']:+.3f}%")
for c in checks:print(c)
