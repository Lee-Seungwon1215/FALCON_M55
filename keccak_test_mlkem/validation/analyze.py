"""Only accept successful fixed-layout runs whose crypto sources still match.
 * Reports medians; kernel sample = batch average, signing sample = one call.
"""
import hashlib
import json
from pathlib import Path
import re
import statistics as st

HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[1]
def stats(xs):
    assert xs
    return dict(n=len(xs),median=st.median(xs),mean=st.mean(xs),min=min(xs),max=max(xs))
def digest(p):return hashlib.sha256(p.read_bytes()).hexdigest()
summary={}
for name in ('ref','serial','mlkem','vecfalcon','hybrid'):
    crypto=ROOT/('Final_code/Before_slothy' if name=='ref' else 'keccak_test_'+('vecfalcon' if name=='serial' else name))
    valid=[]
    for p in sorted((HERE/'results'/name).glob('*/manifest.json')):
        m=json.loads(p.read_text());out=p.parent
        if not m.get('valid'):continue
        lm=(out/'benchmark.map').read_text()
        if '__x4_common_text' not in lm:continue
        sources=json.loads((out/'sources.json').read_text())
        if any(sources.get(str(f))!=digest(f) for f in crypto.iterdir() if f.suffix in ('.c','.h','.s')):continue
        valid.append(out)
    assert valid,('no current successful fixed-layout run',name)
    out=valid[-1];raw=(out/'raw.log').read_text()
    item=dict(run=str(out.relative_to(ROOT)),repeated_matching_runs=[str(p.relative_to(ROOT)) for p in valid])
    for column in ('permutation4','refill544'):
        if name=='ref' and column=='refill544':
            item[column]=None
            continue
        item[column]=stats([int(v)/int(b) for b,v in re.findall(r'KERNEL sample=\d+ batch=(\d+).*?'+column+r'=(\d+)',raw)])
        assert item[column]['n']==50
    item['prng32768']=stats([int(v) for v in re.findall(r'PRNG sample=\d+ bytes=32768 cycles=(\d+)',raw)])
    for degree in (512,1024):
        item['sign'+str(degree)]=stats([int(v) for v in re.findall(r'SIGN n='+str(degree)+r' sample=\d+ cycles=(\d+)',raw)])
        assert item['sign'+str(degree)]['n']==32
    item['digests']={tag+'_'+degree:value for tag,degree,value in re.findall(r'DIGEST (key|signature) n=(\d+) value=([0-9a-f]{64})',raw)}
    summary[name]=item
for name in ('mlkem','vecfalcon','hybrid'):
    assert summary[name]['digests']==summary['serial']['digests']
    for metric in ('permutation4','prng32768','sign512','sign1024'):
        value=summary[name][metric]['median'];base=summary['ref'][metric]['median'];serial=summary['serial'][metric]['median']
        summary[name][metric].update(speedup_vs_original=base/value,cycle_reduction_vs_original_pct=100*(1-value/base),speedup_vs_serial_x4=serial/value)
    for degree in (512,1024):
        assert summary[name]['digests']['key_'+str(degree)]==summary['ref']['digests']['key_'+str(degree)]
        assert summary[name]['digests']['signature_'+str(degree)]!=summary['ref']['digests']['signature_'+str(degree)]
(HERE/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
for name,item in summary.items():
    print(name,[(k,round(item[k]['median'],3) if item[k] else None) for k in ('permutation4','refill544','prng32768','sign512','sign1024')])
