#!/usr/bin/env python3
"""Verify measured provenance, equality and stage-by-stage performance."""
from collections import defaultdict
from pathlib import Path
import hashlib,json,re,subprocess,sys
from provenance import snapshot
ROOT=Path(__file__).resolve().parent
OUT=ROOT/'results'
PARENT=ROOT.parent.parent
LABELS=('r1-kernels','r1-kat','r1-perf','r2-kernels','r2-kat','r2-perf',
        'kernels','kat','asm-perf','asm-profile','ref-perf','c-perf','old-perf')
GROUPS=('ref','c','old','r1','r2','asm')
DIRECTORIES=dict(ref=ROOT.parents[2]/'ref',c=PARENT/'fp64_kat_exact',
    old=PARENT/'fp64_kat_exact_inlineasm',r1=PARENT/'fp64_radix24',
    r2=PARENT/'fp64_radix24_twiddle',asm=ROOT.parent)
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
runs,logs={},{}
missing=[]
for label in LABELS:
    candidates=sorted((OUT/label).glob('*/run.json'))
    if not candidates:missing.append(label);continue
    p=candidates[-1];r=json.loads(p.read_text())
    assert r['valid'] and not r['errors'],(label,r['errors'])
    group=label.split('-')[0] if '-' in label else 'asm'
    source=DIRECTORIES[group]
    assert r['build_manifest']==snapshot(ROOT/'build'/label,source),label
    assert sha(p.parent/'raw.log')==r['raw_sha256'],label
    runs[label]=r
    logs[label]=re.sub(r'Info : [^\n]*\n','',(p.parent/'raw.log').read_text())
if missing:
    if '--partial' in sys.argv:
        print(json.dumps(dict(complete=list(runs),pending=missing),indent=2));sys.exit(0)
    raise AssertionError(missing)

def records(prefix,text):
    return [{k:int(v) if v.isdigit() else v for k,v in re.findall(r'(\w+)=([^ ]+)',line)}
            for line in text.splitlines() if line.startswith(prefix+' ')]
def digest_rows(label):
    return {(r['degree'],r['index']):r['digest'] for r in runs[label]['keys']}
expected=digest_rows('ref-perf')
assert len(expected)==200
for label in tuple(g+'-perf' for g in GROUPS)+('asm-profile',):
    assert digest_rows(label)==expected,label
    assert 'FP64_DONE result=0 signature_and_tamper=PASS' in logs[label]

performance=[]
for degree in (512,1024):
    row=dict(degree=degree)
    for group in GROUPS:
        t=next(t for t in runs[group+'-perf']['totals'] if t['degree']==degree)
        assert t['runs']==100
        samples=[x['cycles'] for x in runs[group+'-perf']['keys'] if x['degree']==degree]
        assert len(samples)==100 and sum(samples)==t['cycles'] and max(samples)<2**32
        row[group]=dict(t,mean=t['cycles']/100)
    for group,previous in (('r1','old'),('r2','r1'),('asm','r2')):
        row[group]['cycle_reduction_vs_previous_percent']=(1-row[group]['mean']/row[previous]['mean'])*100
    row['final_reduction_vs_C_percent']=(1-row['asm']['mean']/row['c']['mean'])*100
    row['final_reduction_vs_old_asm_percent']=(1-row['asm']['mean']/row['old']['mean'])*100
    row['final_time_vs_fixed_ratio']=row['asm']['mean']/row['ref']['mean']
    performance.append(row)

def timing(rows,fields):
    grouped=defaultdict(list)
    for r in rows:grouped[tuple(r[f] for f in fields)].append(r)
    result=[]
    for k,rs in sorted(grouped.items()):
        assert len(rs)==20 and {r['case'] for r in rs}==set(range(20))
        result.append(dict(zip(fields,k),input_classes=20,
            distinct_input_minima=sorted({r['min'] for r in rs}),
            maximum_within_class_span=max(r['max']-r['min'] for r in rs)))
    return result

stages=[]
for stage,prefix in (('r1','r1-'),('r2','r2-'),('asm','')):
    klabel=prefix+'kernels';katlabel=prefix+'kat'
    kr=logs[klabel]
    d=records('BOARD_DIFF',kr)
    assert len(d)==1 and d[0]==dict(random_pairs=1000000,edge_pairs=36864,checksum='c665dcb55f68554d',result=0)
    assert records('FFT_DIFF',kr)==[dict(coefficient_positions=81840,backends=3,result=0)]
    kernels=records('KERNEL',kr)
    assert len(kernels)==19 and all(k['bitexact']=='PASS' for k in kernels)
    kat=re.findall(r'^BOARD_KAT degree=(\d+) index=(\d+) match=1 equation=PASS$',logs[katlabel],re.M)
    assert len(kat)==300 and {(int(d),int(i)) for d,i in kat}=={(d,i) for d in (256,512,1024) for i in range(100)}
    mul=timing(records('MUL',kr),('backend',))
    op=timing(records('CT_OP',kr),('op',))
    fft=timing(records('CT_FFT',kr),('backend','logn','inverse'))
    assert len(mul)==3 and len(op)==4 and len(fft)==60
    stages.append(dict(stage=stage,kernels=kernels,differential=d[0],kat=300,
        FFT_coefficient_positions=81840,mul=mul,CT_ops=op,CT_FFT=fft,
        observed_input_minima_equal=all(len(x['distinct_input_minima'])==1 for x in mul+op+fft)))

profile=[]
for degree in (512,1024):
    for kind in (0,1):
        rows=[r for r in runs['asm-profile']['approx'] if r['degree']==degree and r['kind']==kind]
        profile.append(dict(degree=degree,kind=kind,calls=sum(r['calls'] for r in rows),
            cycles_per_key=sum(r['cycles'] for r in rows)/100))

memory={}
for label in tuple(g+'-perf' for g in GROUPS)+('r1-kat','r2-kat','kat','asm-profile'):
    water=records('STACK_WATERMARK',logs[label])
    assert len(water)==1 and water[0]['untouched_low']>0
    memory[label]=water[0]
    if label.endswith('-perf'):
        log=(OUT/'build_logs'/('fp64-radix24-'+label+'-build.log')).read_text()
        for region in ('FLASH','RAM'):
            match=re.search(r'^\s*'+region+r':\s*(\d+) B',log,re.M);assert match
            memory[label][region+'_region_bytes']=int(match[1])

crypto=lambda p:{x.name:sha(x) for x in p.iterdir() if x.suffix in ('.c','.h','.s')}
oldhost=json.loads((DIRECTORIES['c']/'validation/build/host/summary.json').read_text())
assert crypto(DIRECTORIES['c'])==oldhost['source']
for p,h in oldhost['preserved'].items():assert crypto(Path(p))==h,p
oldrun=json.loads(sorted((DIRECTORIES['old']/'validation/results/asm-perf').glob('*/run.json'))[-1].read_text())
assert crypto(DIRECTORIES['old'])==oldrun['source']
changed={}
for group in ('r1','r2','asm'):
    files=crypto(DIRECTORIES[group]);base=crypto(DIRECTORIES['old'])
    assert files.keys()==base.keys()
    changed[group]=sorted(k for k in files if files[k]!=base[k])
    assert changed[group]==['kgen_fxp.c']
    before=(DIRECTORIES['old']/'kgen_fxp.c').read_text()
    after=(DIRECTORIES[group]/'kgen_fxp.c').read_text()
    marker='\n/* see kgen_inner.h */\nvoid\nvect_FFT('
    assert before[before.index(marker):]==after[after.index(marker):]

static=json.loads((OUT/'static/summary.json').read_text())
assert len(static)==10
for row in static:assert row['elf_sha256']==runs[row['label']]['elf_sha256']
model=json.loads((OUT/'model.json').read_text())
assert model['result']=='PASS' and model['model_sha256']==sha(ROOT/'model.py')
tool=ROOT.parents[4]/'measurement_mlkem_native/env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin/arm-none-eabi-objdump'
machine=[]
for group in ('c','old','r1','r2','asm'):
    label=group+'-perf';elf=ROOT/'build'/label/'zephyr/zephyr.elf'
    rows=[]
    for name in ('fndsa_fp64e_mul','fp64e_mul24_prepared','fp64e_cmul','fp64e_cmul_prepared','fndsa_vect_FFT_fp64_exact','fndsa_vect_iFFT_fp64_exact'):
        asm=subprocess.check_output([str(tool),'-d','--disassemble='+name,str(elf)],text=True)
        present='<'+name+'>:' in asm
        (OUT/'static'/(label+'-'+name+'.asm')).write_text(asm)
        ins=[]
        for line in asm.splitlines():
            m=re.match(r'^\s*[0-9a-f]+:\s+(?:[0-9a-f]{4}\s+)+\s*([a-z][a-z0-9.]*)\s*(.*)',line)
            if m:ins.append(m.groups())
        rows.append(dict(name=name,present=present,instructions=len(ins),
            vcvt=sum(op.startswith('vcvt') for op,_ in ins),
            FP64_ops=sum('.f64' in op for op,_ in ins),
            calls=[operand for op,operand in ins if op in ('bl','blx','bl.w','blx.w')]))
    su=[]
    for p in (ROOT/'build'/label).rglob('*.su'):
        for line in p.read_text().splitlines():
            if any(x in line for x in ('fp64e_mul','fndsa_vect_FFT_fp64_exact','fndsa_vect_iFFT_fp64_exact','solve_NTRU_intermediate')):su.append(line)
    machine.append(dict(group=group,functions=rows,stack_usage=su))
summary=dict(performance=performance,stages=stages,final_profile=profile,memory=memory,
    machine=machine,model=model,changed_crypto_files=changed,
    original_sources_preserved=True,key_signature_digest_matches=200,
    runs={label:dict(run_dir=r['run_dir'],elf_sha256=r['elf_sha256'],raw_sha256=r['raw_sha256']) for label,r in runs.items()},
    caveats=['One 100-seed batch per full-perf group; no confidence interval.',
        'Same memory policy, not identical function addresses.',
        'Primitive wrapper timings include conversion, loop, call and sink.',
        'Observed constant-time tests are not a complete proof or power/EM analysis.',
        'No host sanitizer coverage is claimed for Arm inline assembly.',
        'R1 also changes allocation/scheduling versus old ASM; no isolated causal attribution to product count.'])
(OUT/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
print(json.dumps({k:summary[k] for k in ('performance','final_profile','memory','original_sources_preserved')},indent=2))
