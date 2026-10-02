"""Summarize matched-input, current-source runs; positive % means slower."""
from pathlib import Path
import hashlib,json,re
ROOT=Path(__file__).resolve().parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def latest(label):
    for path in sorted((ROOT/'results'/label).glob('*/run.json'),reverse=True):
        r=json.loads(path.read_text())
        if not r['valid']:continue
        if not label.startswith('ref-') and any(r['source'][n]!=sha(ROOT.parent/n) for n in ('kgen_fxp.c','kgen_inner.h','kgen_ntru.c')):continue
        assert r['raw_sha256']==sha(path.parent/'raw.log')
        return r
    raise ValueError('No valid current run: '+label)
d={l:latest(l) for l in ('ref-perf','compat-perf','ref-profile','compat-profile','kat','kernels')}
dig=lambda r:{(v['degree'],v['index']):v['digest'] for v in r['keys']}
base=dig(d['ref-perf']);assert len(base)==200
for label in ('compat-perf','ref-profile','compat-profile'):assert dig(d[label])==base,label
performance=[]
def row(kind,degree,b,c):
    performance.append(dict(kind=kind,degree=degree,baseline_mean=b/100,compat_mean=c/100,
        slowdown=c/b,cycle_increase_percent=100*(c/b-1)))
for n in (512,1024):
    b=next(v for v in d['ref-perf']['totals'] if v['degree']==n)
    c=next(v for v in d['compat-perf']['totals'] if v['degree']==n)
    row('whole_keygen',n,b['cycles'],c['cycles'])
    totals=[0,0]
    for kind in (0,1):
        br=[v for v in d['ref-profile']['approx'] if v['degree']==n and v['kind']==kind]
        cr=[v for v in d['compat-profile']['approx'] if v['degree']==n and v['kind']==kind]
        assert [(v['logn'],v['calls']) for v in br]==[(v['logn'],v['calls']) for v in cr]
        bc=sum(v['cycles'] for v in br);cc=sum(v['cycles'] for v in cr)
        totals[0]+=bc;totals[1]+=cc;row(('prepare','repeat')[kind],n,bc,cc)
    row('approximate_k_total',n,*totals)
kat=Path(d['kat']['run_dir'],'raw.log').read_text()
kr=re.findall(r'^BOARD_KAT degree=(\d+) index=(\d+) match=1 equation=PASS$',kat,re.M)
assert {(int(n),int(i)) for n,i in kr}=={(n,i) for n in (256,512,1024) for i in range(100)}
raw=Path(d['kernels']['run_dir'],'raw.log').read_text()
assert 'MUL_DIFFERENTIAL count=100000 mismatches=0' in raw
ct=[dict(zip(('op','case','repeats','min','max'),map(int,m))) for m in re.findall(r'^CT op=(\d+) case=(\d+) repeats=(\d+) min=(\d+) max=(\d+)$',raw,re.M)]
assert len(ct)==68
timing=[]
for op in (0,1):
    entries=[v for v in ct if v['op']==op]
    minima=sorted({v['min'] for v in entries})
    assert len(minima)==1
    assert max(v['max']-v['min'] for v in entries)<=1
    timing.append(dict(op=op,input_classes=34,batch_repeats=256,min_cycles=minima[0],max_batch_jitter=max(v['max']-v['min'] for v in entries)))
kernels=[dict(zip(('case','logn','old_prepare','new_prepare','old_repeat','new_repeat'),map(int,m))) for m in re.findall(r'^KERNEL case=(\d+) logn=(\d+) old_prepare=(\d+) new_prepare=(\d+) old_repeat=(\d+) new_repeat=(\d+) mismatches=0$',raw,re.M)]
assert len(kernels)==19
host=json.loads((ROOT/'build/host/summary.json').read_text())
assert all(host['source'][n]==sha(ROOT.parent/n) for n in host['changed'])
for r in json.loads((ROOT/'results/static/summary.json').read_text()):assert r['elf_sha256']==d[r['label']]['elf_sha256']
trace=json.loads((ROOT.parents[1]/'validation/compatibility_repair/manifest.json').read_text())
for category,source in [('baseline',ROOT.parents[2]/'ref'),('native',ROOT.parents[1])]:
    assert all(sha(source/n)==h for n,h in trace[category].items()),category+' source changed'
hybrid=ROOT.parents[1]/'hybrid_fixed_div'
previous=json.loads((hybrid/'validation/build/host/summary.json').read_text())
assert all(sha(hybrid/n)==h for n,h in previous['source'].items()),'previous hybrid source changed'
summary=dict(decision='REJECT for performance; exact-output experimental hybrid, not pure double FFT',
 performance=performance,timing=timing,kernels=kernels,board_kat='300/300',matching_key_signature_digests=200,
 source={n:sha(ROOT.parent/n) for n in host['changed']},runs={l:r['run_dir'] for l,r in d.items()},
 preserved='baseline, original native FP64, previous hybrid_fixed_div root C/H/S hashes verified')
(ROOT/'results/summary.json').write_text(json.dumps(summary,indent=2)+'\n')
print(json.dumps({k:v for k,v in summary.items() if k!='kernels'},indent=2))
