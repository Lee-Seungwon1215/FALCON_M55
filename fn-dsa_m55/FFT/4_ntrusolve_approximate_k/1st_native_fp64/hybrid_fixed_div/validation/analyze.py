"""Check identities/provenance and summarize only the final source's board runs."""
from pathlib import Path
import hashlib
import json
import re

ROOT = Path(__file__).resolve().parent
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
current = sha(ROOT.parent/'kgen_fxp.c')

def latest(label):
    paths = sorted((ROOT/'results'/label).glob('*/run.json'), reverse=True)
    for path in paths:
        data = json.loads(path.read_text())
        if not data['valid'] or 'build_manifest' not in data:
            continue
        if not label.startswith('ref-') and data['source']['kgen_fxp.c'] != current:
            continue
        assert data['raw_sha256'] == sha(path.parent/'raw.log')
        return data
    raise ValueError('No validated final-source run: '+label)

data = {label: latest(label) for label in ('ref-perf','hybrid-perf','ref-profile','hybrid-profile','kernels','kat')}
digests = lambda d: {(r['degree'],r['index']):r['digest'] for r in d['keys']}
base_digests = digests(data['ref-perf'])
assert len(base_digests) == 200
for label in ('hybrid-perf','ref-profile','hybrid-profile'):
    assert digests(data[label]) == base_digests, label

replicates = {}
for label in ('ref-perf','hybrid-perf'):
    runs = []
    for path in sorted((ROOT/'results'/label).glob('*/run.json')):
        run = json.loads(path.read_text())
        if not run['valid'] or run['elf_sha256'] != data[label]['elf_sha256']:
            continue
        assert run['raw_sha256']==sha(path.parent/'raw.log')
        assert digests(run)==base_digests
        runs.append(dict(path=str(path), totals=run['totals']))
    replicates[label]=runs

rows = []
for degree in (512,1024):
    b = next(r for r in data['ref-perf']['totals'] if r['degree']==degree)
    h = next(r for r in data['hybrid-perf']['totals'] if r['degree']==degree)
    rows.append(dict(kind='whole_keygen', degree=degree, baseline_mean=b['cycles']/100,
                     hybrid_mean=h['cycles']/100, cycle_reduction_percent=100*(1-h['cycles']/b['cycles']),
                     speedup=b['cycles']/h['cycles'], baseline_median=b['median'], hybrid_median=h['median']))
    for kind in (0,1):
        br = [r for r in data['ref-profile']['approx'] if r['degree']==degree and r['kind']==kind]
        hr = [r for r in data['hybrid-profile']['approx'] if r['degree']==degree and r['kind']==kind]
        assert [(r['logn'],r['calls']) for r in br]==[(r['logn'],r['calls']) for r in hr]
        bc, hc = sum(r['cycles'] for r in br), sum(r['cycles'] for r in hr)
        rows.append(dict(kind=('prepare','repeat')[kind], degree=degree,
                         baseline_mean=bc/100, hybrid_mean=hc/100,
                         cycle_reduction_percent=100*(1-hc/bc), speedup=bc/hc,
                         calls=sum(r['calls'] for r in br)))

raw = Path(data['kernels']['run_dir'],'raw.log').read_text()
assert 'DIV_DIFFERENTIAL count=100000 mismatches=0' in raw
ct = [dict(zip(('op','case','repeats','min','max'),map(int,m))) for m in re.findall(
    r'^CT op=(\d+) case=(\d+) repeats=(\d+) min=(\d+) max=(\d+)$',raw,re.M)]
assert len(ct)==48
ct_summary=[]
for op in (0,1):
    entries = [r for r in ct if r['op']==op]
    minima = sorted({r['min'] for r in entries})
    assert len(minima)==1, (op, minima)
    assert max(r['max']-r['min'] for r in entries)<=1
    ct_summary.append(dict(op=op, input_classes=len(entries), repeats=256, min_batch_cycles=minima[0],
                           max_batch_jitter=max(r['max']-r['min'] for r in entries),
                           limitation='Finite input classes, not a whole-algorithm constant-time proof'))
kernel = [dict(zip(('case','logn','old_prepare','new_prepare','old_repeat','new_repeat'), map(int,m))) for m in re.findall(
    r'^KERNEL case=(\d+) logn=(\d+) old_prepare=(\d+) new_prepare=(\d+) old_repeat=(\d+) new_repeat=(\d+) mismatches=0$',raw,re.M)]
assert len(kernel)==19
kat_raw=Path(data['kat']['run_dir'],'raw.log').read_text()
kat=re.findall(r'^BOARD_KAT degree=(\d+) index=(\d+) match=1 equation=PASS$',kat_raw,re.M)
assert {(int(d),int(i)) for d,i in kat}=={(d,i) for d in (256,512,1024) for i in range(100)}
host=json.loads((ROOT/'build/host/summary.json').read_text())
division=json.loads((ROOT/'build/division/summary.json').read_text())
assert host['source']['kgen_fxp.c']==division['source_sha256']==current
audit=json.loads((ROOT/'results/static/summary.json').read_text())
for row in audit:
    assert row['elf_sha256']==data[row['label']]['elf_sha256']
summary=dict(source_sha256=current, performance=rows, timing=ct_summary, kernel_cases=kernel,
             board_kat='300/300', matching_key_signature_digests=200, division=division,
             run_dirs={k:v['run_dir'] for k,v in data.items()}, replicates=replicates)
(ROOT/'results/summary.json').write_text(json.dumps(summary,indent=2)+'\n')
print(json.dumps({k:v for k,v in summary.items() if k!='kernel_cases'},indent=2))
