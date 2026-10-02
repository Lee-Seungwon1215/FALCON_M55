#!/usr/bin/env python3
"""Fail-closed aggregation of board, host and source-provenance checks."""
import hashlib,json,re,subprocess
from pathlib import Path
ROOT=Path(__file__).resolve().parent;SRC=ROOT.parent;BASE=ROOT.parents[2]/'ref'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def latest(label):
    rows=[]
    for p in sorted((ROOT/'results'/label).glob('*/run.json')):
        d=json.loads(p.read_text())
        if d['valid']:
            assert sha(p.with_name('raw.log'))==d['raw_sha256']
            d['raw']=p.with_name('raw.log').read_text();rows.append(d)
    assert rows,label
    return rows[-1]
labels='ref-perf compat-perf ref-profile compat-profile kernels kat'.split()
r={x:latest(x) for x in labels}
for label,run in r.items():
    for name,want in run['build_manifest'].items():
        assert sha(Path(name))==want,(label,name,'build artifact changed')
key=lambda d:[(x['degree'],x['index'],x['digest']) for x in d['keys']]
for label in ('ref-perf','compat-perf','ref-profile','compat-profile'):
    assert {(d,i) for d,i,h in key(r[label])}=={(d,i) for d in (512,1024) for i in range(100)}
assert key(r['ref-perf'])==key(r['compat-perf'])==key(r['ref-profile'])==key(r['compat-profile'])
host=json.loads((ROOT/'build/host/summary.json').read_text())
assert host['source']=={p.name:sha(p) for p in SRC.glob('*.[chs]')}
for source,want in host['preserved'].items():assert want=={p.name:sha(p) for p in Path(source).glob('*.[chs]')}
for name,label in [('ref','ref-perf'),('exact','compat-perf')]:
    text=(ROOT/'build/host'/f'{name}-benchmark.log').read_text()
    vals=[(int(d),int(i),h) for d,i,h in re.findall(r'^KEY degree=(\d+) index=(\d+) cycles=0 digest=([a-f0-9]+)$',text,re.M)]
    assert vals==key(r[label]),'host-board digest'
perf=[]
for d in (512,1024):
    t={label:next(x for x in r[label]['totals'] if x['degree']==d) for label in ('ref-perf','compat-perf')}
    a=t['ref-perf']['cycles']/100;b=t['compat-perf']['cycles']/100
    perf.append(dict(degree=d,ref_mean=a,exact_mean=b,time_ratio=b/a,cycle_increase_pct=100*(b/a-1),
        ref_median=t['ref-perf']['median'],exact_median=t['compat-perf']['median'],max_sample=t['compat-perf']['max']))
profile=[]
assert len(r['ref-profile']['approx'])==len(r['compat-profile']['approx'])
for a,b in zip(r['ref-profile']['approx'],r['compat-profile']['approx']):
    assert {k:v for k,v in a.items() if k!='cycles'}=={k:v for k,v in b.items() if k!='cycles'}
    profile.append(dict(**{k:v for k,v in a.items() if k!='cycles'},ref_cycles=a['cycles'],exact_cycles=b['cycles'],time_ratio=b['cycles']/a['cycles']))
groups=[]
for d in (512,1024):
    for k in range(2):
        rows=[x for x in profile if x['degree']==d and x['kind']==k]
        a=sum(x['ref_cycles'] for x in rows);b=sum(x['exact_cycles'] for x in rows)
        groups.append(dict(degree=d,kind=k,calls=sum(x['calls'] for x in rows),ref_mean_per_key=a/100,exact_mean_per_key=b/100,time_ratio=b/a))
kernels=[]
for row in re.findall(r'^KERNEL case=(\d+) logn=(\d+) fixed_prepare=(\d+) exact_prepare=(\d+) fixed_reduce=(\d+) exact_reduce=(\d+) bitexact=PASS$',r['kernels']['raw'],re.M):
    c,l,qp,ep,qr,er=map(int,row)
    kernels.append(dict(case=c,logn=l,fixed_prepare=qp/100,exact_prepare=ep/100,fixed_reduce=qr/100,exact_reduce=er/100,prepare_ratio=ep/qp,reduce_ratio=er/qr))
assert len(kernels)==19
katrows=re.findall(r'^BOARD_KAT degree=(\d+) index=(\d+) match=1 equation=PASS$',r['kat']['raw'],re.M)
assert {(int(d),int(i)) for d,i in katrows}=={(d,i) for d in (256,512,1024) for i in range(100)}
ct=[]
for op in range(4):
    rows=[tuple(map(int,x)) for x in re.findall(r'CT_OP op='+str(op)+r' case=(\d+) repeats=256 min=(\d+) max=(\d+)',r['kernels']['raw'])]
    assert len(rows)==20
    ct.append(dict(kind='scalar',op=op,class_minima=sorted(set(a for c,a,b in rows)),max_trial_spread=max(b-a for c,a,b in rows)))
for l in range(1,11):
    for inv in range(2):
        rows=[tuple(map(int,x)) for x in re.findall(r'CT_FFT logn='+str(l)+r' inverse='+str(inv)+r' case=(\d+) min=(\d+) max=(\d+)',r['kernels']['raw'])]
        assert len(rows)==20
        ct.append(dict(kind='transform',logn=l,inverse=inv,class_minima=sorted(set(a for c,a,b in rows)),max_trial_spread=max(b-a for c,a,b in rows)))
assert all(len(x['class_minima'])==1 for x in ct),'Observed class minima differ'
static=json.loads((ROOT/'results/static/summary.json').read_text())
for row in static:assert row['elf_sha256']==r[row['label']]['elf_sha256']
asan=json.loads((ROOT/'build/asan/summary.json').read_text())
stack={}
for label in labels:
    if label=='kernels':continue
    rows=re.findall(r'^STACK_WATERMARK reserved=(\d+) untouched_low=(\d+) observed_used=(\d+)$',r[label]['raw'],re.M)
    assert len(rows)==1,label
    reserve,free,used=map(int,rows[0]);assert free>=512 and reserve==65536
    stack[label]=dict(reserved=reserve,untouched=free,observed_used=used)
changed=sorted(p.name for p in SRC.glob('*.[chs]') if p.read_bytes()!=(BASE/p.name).read_bytes())
assert changed==['kgen_fxp.c','kgen_inner.h','kgen_ntru.c','kgen_poly.c']
summary=dict(performance=perf,profile=profile,profile_grouped=groups,kernels=kernels,constant_time_observations=ct,
    board_kat='300/300',host_board_matching_key_signatures=200,stack=stack,changed_crypto=changed,
    asan=asan,static_elf_hashes_matched=True,build_artifact_hashes_matched=True,
    runs={k:v['run_dir'] for k,v in r.items()},source=host['source'],warning='FP64 hardware executing exact Q32.32 semantics, not conventional unquantized single-double FFT; finite CT tests are not a proof.')
(ROOT/'results/summary.json').write_text(json.dumps(summary,indent=2)+'\n')
print(json.dumps({k:v for k,v in summary.items() if k in ('performance','profile_grouped','stack','constant_time_observations')},indent=2))
