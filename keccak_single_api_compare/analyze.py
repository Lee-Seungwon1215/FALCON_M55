"""Compare matching input indices; aggregate median-of-repeats per input."""
import hashlib
import json
from pathlib import Path
import re
import statistics

HERE=Path(__file__).resolve().parent
data={};runs={}
for name in ('ref','batch4','single_mve'):
    paths=[p.parent for p in (HERE/'results'/name).glob('*/manifest.json')
           if json.loads(p.read_text())['valid']]
    run=sorted(paths)[-1];runs[name]=str(run)
    for p,h in json.loads((run/'sources.json').read_text()).items():
        if Path(p).parent==HERE:continue  # Analysis/docs may be added afterwards.
        assert hashlib.sha256(Path(p).read_bytes()).hexdigest()==h,('source changed',p)
    raw=re.sub(r'Info : [^\n]*\n','',(run/'raw.log').read_text())
    rows=[]
    for n,i,r,k,s,v,b in re.findall(r'^SINGLE n=(\d+) input=(\d+) repeat=(\d+) keygen=(\d+) sign=(\d+) verify_total=(\d+) verify_calls=(\d+)$',raw,re.M):
        rows.append(dict(n=int(n),input=int(i),repeat=int(r),keygen=int(k),sign=int(s),verify=int(v)/int(b)))
    assert len(rows)==48,(name,len(rows))
    assert len({(x['n'],x['input'],x['repeat']) for x in rows})==48
    data[name]=rows
summary=[]
for n in (512,1024):
    for op in ('keygen','sign','verify'):
        medians={}
        for name in data:
            medians[name]=[statistics.median(x[op] for x in data[name] if x['n']==n and x['input']==i) for i in range(8)]
        ref=statistics.mean(medians['ref'])
        row=dict(n=n,operation=op,ref_cycles=ref)
        for name in ('batch4','single_mve'):
            cur=statistics.mean(medians[name])
            ratios=[a/b for a,b in zip(medians['ref'],medians[name])]
            row[name]=dict(cycles=cur,speedup=ref/cur,reduction_percent=(1-cur/ref)*100,
                per_input_speedup_min=min(ratios),per_input_speedup_max=max(ratios))
        summary.append(row)
out=dict(runs=runs,aggregation='mean of 8 per-input medians; 3 timed repeats/input',rows=summary)
(HERE/'summary.json').write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps(out,indent=2))
