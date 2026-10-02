"""Summarize a completed, archived same-image paired batch measurement."""
import hashlib
import json
from pathlib import Path
import re
import statistics
import sys

HERE = Path(__file__).resolve().parent
if len(sys.argv) > 1:
    run = Path(sys.argv[1]).resolve()
else:
    completed = [p.parent for p in (HERE/'results/batch4').glob('*/manifest.json')
                 if json.loads(p.read_text())['valid']]
    run = sorted(completed)[-1]
manifest = json.loads((run/'manifest.json').read_text())
assert manifest['valid'], manifest
raw = (run/'raw.log').read_text()
raw = re.sub(r'Info : [^\n]*\n', '', raw)
groups = {}
for n,b,s,r,c in re.findall(r'^BATCH n=(\d+) blocks=(\d+) sample=(\d+) original4=(\d+) batch4=(\d+) exact=4/4$',raw,re.M):
    groups.setdefault((int(n),int(b)),[]).append((int(s),int(r),int(c)))
rows=[]
for (n,b),values in sorted(groups.items()):
    assert len({v[0] for v in values}) == len(values)
    r=statistics.median(v[1] for v in values)
    c=statistics.median(v[2] for v in values)
    paired=[v[1]/v[2] for v in values]
    rows.append(dict(n=n,blocks=b,samples=len(values),original4_cycles=r,batch4_cycles=c,
        original_equiv_one=r/4,batch_equiv_one=c/4,
        throughput_speedup=r/c,cycle_reduction_percent=(1-c/r)*100,
        paired_median=statistics.median(paired),paired_min=min(paired),paired_max=max(paired)))
current = all(Path(p).exists() and hashlib.sha256(Path(p).read_bytes()).hexdigest()==h
              for p,h in json.loads((run/'sources.json').read_text()).items())
out=dict(run=str(run),valid=True,current_sources_match=current,rows=rows,
         checks=re.findall(r'^(?:CHECK |BENCH_DONE ).*$',raw,re.M))
(run/'summary.json').write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps(out,indent=2))
