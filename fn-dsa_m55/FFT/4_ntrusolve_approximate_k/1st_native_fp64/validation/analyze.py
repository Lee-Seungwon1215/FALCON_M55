#!/usr/bin/env python3
"""Verify final source/run provenance and generate comparison data, not a PASS stamp."""
import hashlib
import json
from pathlib import Path
import re
import subprocess

ROOT=Path(__file__).resolve().parent
SOURCE=ROOT.parent
BASE=SOURCE.parent/'ref'
M55=ROOT.parents[3]
TOOLS=M55/'measurement_mlkem_native/env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def source_hashes(p):
    return {f.name:sha(f) for f in sorted(p.iterdir()) if f.suffix in ('.c','.h','.s')}
def read(p):return json.loads(p.read_text())
def clean(s):return re.sub(r'Info : [^\n]*\n','',s)
def digests(log):
    return {(int(d),int(i)):h for d,i,h in re.findall(r'^KEY degree=(\d+) index=(\d+) cycles=\d+ digest=([a-f0-9]{64})$',clean(log),re.M)}
def last(label):
    expected=source_hashes(BASE if label.startswith('ref') else SOURCE)
    for path in sorted((ROOT/'results'/label).glob('*/run.json'),reverse=True):
        d=read(path)
        if d['valid'] and d['source']==expected:
            assert sha(path.parent/'raw.log')==d['raw_sha256']
            assert sha(ROOT/'build'/label/'zephyr/zephyr.elf')==d['elf_sha256']
            d['raw']=clean((path.parent/'raw.log').read_text())
            return d
    raise RuntimeError('No valid current-source measurement: '+label)

runs={name:last(name) for name in ['ref-perf','fp64-perf','ref-profile','fp64-profile','kernels']}
expected_keys={(d,i) for d in [512,1024] for i in range(100)}
for label in ['ref','fp64']:
    host=(ROOT/'build/host'/('bench-'+label+'.log')).read_text()
    assert 'FP64_DONE result=0 signature_and_tamper=PASS' in host
    h=digests(host)
    assert h.keys()==expected_keys
    for mode in ['perf','profile']:
        assert h==digests(runs[label+'-'+mode]['raw']),label+' host/board mismatch'
    p=runs[label+'-profile']['approx']
    assert {(r['degree'],r['kind'],r['logn']) for r in p}=={(d,k,l) for d,lastlog in [(512,8),(1024,9)] for k in [0,1] for l in range(1,lastlog+1)}

baseline=source_hashes(BASE);candidate=source_hashes(SOURCE)
assert baseline.keys()==candidate.keys()
changed=[f for f in baseline if baseline[f]!=candidate[f]]
assert changed==['kgen_fxp.c','kgen_inner.h','kgen_ntru.c','kgen_poly.c'],changed
assert baseline==source_hashes(M55/'ntt_opt'),'Original NTT baseline changed'

overall=[]
for a,b in zip(runs['ref-perf']['totals'],runs['fp64-perf']['totals']):
    assert a['degree']==b['degree'] and a['runs']==b['runs']==100
    overall.append(dict(degree=a['degree'],fixed_mean=a['cycles']/100,fp64_mean=b['cycles']/100,
        fixed_median=a['median'],fp64_median=b['median'],mean_cycle_reduction_pct=(1-b['cycles']/a['cycles'])*100,
        mean_speedup=a['cycles']/b['cycles'],median_cycle_reduction_pct=(1-b['median']/a['median'])*100))
profiles=[]
for degree in [512,1024]:
    for label in ['ref','fp64']:
        run=runs[label+'-profile']; total=next(t['cycles'] for t in run['totals'] if t['degree']==degree)
        for kind in [0,1]:
            entries=[r for r in run['approx'] if r['degree']==degree and r['kind']==kind]
            cycles=sum(r['cycles'] for r in entries)
            profiles.append(dict(degree=degree,label=label,kind=kind,cycles=cycles,calls=sum(r['calls'] for r in entries),share_pct=100*cycles/total))

pat=r'^KERNEL case=(\d+) logn=(\d+) fixed_prepare=(\d+) fp64_prepare=(\d+) fixed_reduce=(\d+) fp64_reduce=(\d+) k_differences=(\d+)$'
kernel=[dict(zip(['case','logn','fixed_prepare','fp64_prepare','fixed_reduce','fp64_reduce','k_differences'],map(int,t))) for t in re.findall(pat,runs['kernels']['raw'],re.M)]
assert len(kernel)==19
kernel_summary=[]
for logn in range(1,10):
    rows=[r for r in kernel if r['logn']==logn and r['case']<18]
    assert len(rows)==2
    row=dict(logn=logn)
    for k in ['fixed_prepare','fp64_prepare','fixed_reduce','fp64_reduce']:
        row[k]=sum(r[k] for r in rows)/200
    row['prepare_speedup']=row['fixed_prepare']/row['fp64_prepare']
    row['reduce_slowdown']=row['fp64_reduce']/row['fixed_reduce']
    kernel_summary.append(row)
ct=[dict(zip(['op','case','repeats','min','max'],map(int,t))) for t in re.findall(r'^CT_PROBE op=(\d+) case=(\d+) repeats=(\d+) min=(\d+) max=(\d+)$',runs['kernels']['raw'],re.M)]
assert len(ct)==68
memory={};native={}
for label in ['ref-perf','fp64-perf','kernels']:
    build=ROOT/'build'/label;elf=build/'zephyr/zephyr.elf'
    nm=subprocess.check_output([str(TOOLS/'arm-none-eabi-nm'),'-n',str(elf)],text=True)
    symbols={name:int(addr,16) for addr,name in re.findall(r'^([0-9a-f]+) \w (\S+)$',nm,re.M)}
    dis=subprocess.check_output([str(TOOLS/'arm-none-eabi-objdump'),'-d',str(elf)],text=True)
    (build/'disassembly.txt').write_text(dis)
    (build/'symbols.txt').write_text(nm)
    memory[label]=dict(itcm_end=symbols['__fndsa_itcm_end'],itcm_bytes=symbols['__fndsa_itcm_end']-0x10000000,
        dtcm_end=symbols['_image_ram_end'],dtcm_bytes=symbols['_image_ram_end']-0x30000000)
    native[label]=dict(soft_double_helpers=[s for s in symbols if re.match(r'__aeabi_(?:d|i2d|ui2d|l2d|ul2d)',s)],
        f64_instruction_count=len(re.findall(r'\b[v][a-z]+\.f64\b',dis)),vdiv_f64_count=len(re.findall(r'\bvdiv\.f64\b',dis)),
        fused_fma_count=len(re.findall(r'\bvf(?:n?ma|n?ms)\.f64\b',dis)))
assert not native['fp64-perf']['soft_double_helpers']
assert native['fp64-perf']['vdiv_f64_count']>=2
assert native['fp64-perf']['fused_fma_count']==0
audit=(ROOT/'build/host/bench-fp64.log').read_text()
data=dict(status='EXPERIMENT_ONLY_NOT_ADOPTED',changed_crypto_files=changed,
    board_host_digests='200/200 per backend, perf and profile',
    runs={k:{x:d[x] for x in ['run_dir','elf_sha256','raw_sha256']} for k,d in runs.items()},
    overall=overall,profiles=profiles,kernel_summary=kernel_summary,kernel_cases=kernel,ct_probe=ct,
    memory=memory,native=native,host=read(ROOT/'build/host/summary.json'),
    frozen_oracle=read(ROOT/'build/host/frozen-oracle.json'),diagnosis=read(ROOT/'build/trace/diagnosis.json'),
    range_audit=re.findall(r'^(?:ROUND_REJECTED|DIV_ZERO|UPDATE_REJECTED|ROUND_RANGE).*$',audit,re.M))
(ROOT/'results/summary.json').write_text(json.dumps(data,indent=2)+'\n')
for key in ['overall','profiles','kernel_summary','memory','native','range_audit']:
    print(key,json.dumps(data[key],indent=2))
