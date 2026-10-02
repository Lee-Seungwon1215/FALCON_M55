#!/usr/bin/env python3
"""Summarize complete on-board runs; fail closed on missing or changed data."""
import hashlib
import json
from pathlib import Path
import re
import subprocess
ROOT=Path(__file__).resolve().parent
def latest(label):
    runs=[]
    for p in sorted((ROOT/'results'/label).glob('*/run.json')):
        data=json.loads(p.read_text())
        if data['valid']:
            raw=p.with_name('raw.log').read_bytes()
            assert hashlib.sha256(raw).hexdigest()==data['raw_sha256']
            data['raw']=raw.decode();runs.append(data)
    assert runs,label
    return runs[-1]
def decrease(a,b):return 100*(a-b)/a
def main():
    labels='fixed-perf old-perf new-perf old-profile new-profile old-kat new-kat kernels'.split()
    runs={k:latest(k) for k in labels}
    key=lambda r:[(k['degree'],k['index'],k['digest']) for k in r['keys']]
    assert key(runs['old-perf'])==key(runs['new-perf'])==key(runs['old-profile'])==key(runs['new-profile'])
    totals=[]
    for d in (512,1024):
        t={k:next(x for x in runs[k]['totals'] if x['degree']==d)['cycles']/100 for k in ('fixed-perf','old-perf','new-perf')}
        totals.append(dict(degree=d,**t,old_to_new_cycle_decrease_pct=decrease(t['old-perf'],t['new-perf']),
            fixed_to_new_apparent_decrease_pct=decrease(t['fixed-perf'],t['new-perf'])))
    profile=[]
    for a,b in zip(runs['old-profile']['approx'],runs['new-profile']['approx']):
        assert {k:v for k,v in a.items() if k!='cycles'}=={k:v for k,v in b.items() if k!='cycles'}
        profile.append(dict(**{k:v for k,v in a.items() if k!='cycles'},old=a['cycles'],new=b['cycles'],decrease_pct=decrease(a['cycles'],b['cycles'])))
    kernels=[]
    for row in re.findall(r'^KERNEL case=(\d+) logn=(\d+) fixed_reduce=(\d+) old_reduce=(\d+) new_reduce=(\d+) old_ifft=(\d+) new_ifft=(\d+) bitexact=PASS$',runs['kernels']['raw'],re.M):
        c,l,q,o,n,oi,ni=map(int,row)
        kernels.append(dict(case=c,logn=l,fixed_reduce=q/100,old_reduce=o/100,new_reduce=n/100,old_ifft=oi/100,new_ifft=ni/100,
                            reduce_decrease_pct=decrease(o,n),ifft_decrease_pct=decrease(oi,ni),new_vs_fixed_reduce_ratio=n/q))
    assert len(kernels)==19
    kat={}
    for label in ('old-kat','new-kat'):
        rows=re.findall(r'^BOARD_KAT degree=(\d+) index=(\d+) match=(\d) equation=PASS actual=([a-f0-9]+)$',runs[label]['raw'],re.M)
        assert len(rows)==300,(label,len(rows))
        kat[label]=dict(count=len(rows),mismatches=[(int(d),int(i)) for d,i,m,h in rows if m=='0'],actual=[(d,i,h) for d,i,m,h in rows])
    assert kat['old-kat']['actual']==kat['new-kat']['actual']
    host=json.loads((ROOT/'build/host/summary.json').read_text())
    for label in kat:
        assert [(int(d),'test'+i,h) for d,i,h in kat[label]['actual']]==[tuple(x) for x in host[label.split('-')[0]]['actual']]
    ct={}
    for l in range(1,11):
        rows=[(int(a),int(b)) for a,b in re.findall(r'^CT_IFFT logn='+str(l)+r' case=\d+ min=(\d+) max=(\d+)$',runs['kernels']['raw'],re.M)]
        assert len(rows)==20
        ct[l]=dict(min=min(a for a,b in rows),max=max(b for a,b in rows))
    data=dict(totals=totals,profile=profile,kernels=kernels,kat=kat,initial_ct=ct,
              run_dirs={k:v['run_dir'] for k,v in runs.items()},warning='Fixed vs native outputs differ. Only OLD vs NEW has identical keys/signatures and profile call counts.')
    (ROOT/'results/summary.json').write_text(json.dumps(data,indent=2)+'\n')
    print(json.dumps(dict(totals=totals,kernels=kernels,kat={k:len(v['mismatches']) for k,v in kat.items()}),indent=2))
    # Preserve disassembly for a bounded manual secret-branch/address audit.
    tool=ROOT.parents[4]/'measurement_mlkem_native/env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin/arm-none-eabi-objdump'
    for label in ('old-perf','new-perf'):
        elf=ROOT/'build'/label/'zephyr/zephyr.elf'
        text=subprocess.check_output([str(tool),'-d','--disassemble=fndsa_vect_iFFT_fp64',str(elf)],text=True)
        (ROOT/'results'/(label+'-ifft.asm')).write_text(text)
        assert '<fndsa_vect_iFFT_fp64>:' in text
        assert not any(x in text for x in ('vfma.','vfms.','__aeabi_d','vcmp.'))
    return data
if __name__=='__main__':main()
