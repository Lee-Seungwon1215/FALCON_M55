"""Compare only current-source, valid board runs; retain provenance checks."""
from pathlib import Path
from collections import defaultdict
import hashlib,importlib.util,json,re,subprocess,sys
ROOT=Path(__file__).resolve().parent
PARENT=ROOT.parent.parent
STAGES={'F1':'fp64_vfma','F2':'fp64_two_prod','F3a':'fp64_loop_merge','F3u':'fp64_loop_unscheduled','F3b':'fp64_loop_schedule','F3c':'fp64_schedule_only'}
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def records(prefix,text):
    return [{k:int(v) if v.isdigit() else v for k,v in re.findall(r'(\w+)=([^ ]+)',line)}
        for line in text.splitlines() if line.startswith(prefix+' ')]
def load(folder,label,source=None):
    v=PARENT/folder/'validation';build=v/'build'/label
    module=importlib.util.spec_from_file_location('prov',v/'provenance.py')
    prov=importlib.util.module_from_spec(module);module.loader.exec_module(prov)
    source=source or v.parent
    paths=sorted((v/'results'/label).glob('*/run.json'))
    if not paths:return None
    r=json.loads(paths[-1].read_text())
    assert r['valid'] and not r['errors'],(folder,label,r['errors'])
    assert r['build_manifest']==prov.snapshot(build,source),(folder,label,'stale source/build')
    raw=paths[-1].parent/'raw.log';assert sha(raw)==r['raw_sha256']
    text=re.sub(r'Info : [^\n]*\n','',raw.read_text())
    return r,text
def timings(rows,fields):
    groups=defaultdict(list)
    for r in rows:groups[tuple(r[x] for x in fields)].append(r)
    out=[]
    for key,rs in sorted(groups.items()):
        assert len(rs)==20 and {r['case'] for r in rs}==set(range(20))
        out.append(dict(zip(fields,key),classes=20,minima=sorted({r['min'] for r in rs}),max_trial_span=max(r['max']-r['min'] for r in rs)))
    return out
report={'performance':{},'validation':{},'pending':[],'memory':{},'sources':{}}
digests={}
items=[('fixed','fp64_vfma','ref-perf',PARENT.parent/'ref'),('R3','fp64_vfma','r3-perf',PARENT/'fp64_radix24_inline')]
items += [(name,folder,'asm-perf',None) for name,folder in STAGES.items()]
for name,folder,label,source in items:
    found=load(folder,label,source)
    if not found:report['pending'].append(name+' perf');continue
    r,text=found
    digests[name]={(x['degree'],x['index']):x['digest'] for x in r['keys']}
    assert len(digests[name])==200
    perf={}
    for degree in (512,1024):
        samples=[x['cycles'] for x in r['keys'] if x['degree']==degree]
        total=next(x for x in r['totals'] if x['degree']==degree)
        assert len(samples)==100 and sum(samples)==total['cycles'] and max(samples)<2**32
        perf[degree]=dict(total,mean=total['cycles']/100)
    report['performance'][name]=perf
    assert 'FP64_DONE result=0 signature_and_tamper=PASS' in text
    water=records('STACK_WATERMARK',text);assert len(water)==1 and water[0]['untouched_low']>0
    report['memory'][name]=water[0]
    nm=ROOT.parents[4]/'measurement_mlkem_native/env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin/arm-none-eabi-nm'
    elf=PARENT/folder/'validation/build'/label/'zephyr/zephyr.elf'
    symbols=subprocess.check_output([str(nm),'-S',str(elf)],text=True)
    simple={}
    functions={}
    for line in symbols.splitlines():
        v=line.split()
        if len(v)==3:simple[v[-1]]=int(v[0],16)
        if len(v)==4 and v[-1] in ('fp64e_cmul_prepared','fndsa_vect_FFT_fp64_exact','fndsa_vect_iFFT_fp64_exact'):
            functions[v[-1]]=dict(address=v[0],bytes=int(v[1],16))
    report['memory'][name].update(itcm_code_bytes=simple['__rom_region_size'],dtcm_reserved_bytes=simple['_image_ram_size'],FFT_functions=functions)
    assert simple['__rom_region_size']<128*1024 and simple['_image_ram_size']<256*1024
    report['sources'][name]=dict(run_dir=r['run_dir'],elf_sha256=r['elf_sha256'],source=r['source'])
if digests:
    expected=next(iter(digests.values()))
    assert all(x==expected for x in digests.values()),'key/signature digest mismatch'
for name,folder in STAGES.items():
    if name=='F3u':continue
    k=load(folder,'kernels');kat=load(folder,'kat')
    if not k or not kat:report['pending'].append(name+' validation');continue
    r,text=k
    dif=records('BOARD_DIFF',text)
    assert dif==[dict(random_pairs=1000000,edge_pairs=36864,checksum='c665dcb55f68554d',result=0)]
    assert records('FFT_DIFF',text)==[dict(coefficient_positions=81840,backends=3,result=0)]
    kernels=records('KERNEL',text)
    assert len(kernels)==19 and all(x['bitexact']=='PASS' for x in kernels)
    katrows=re.findall(r'^BOARD_KAT degree=(\d+) index=(\d+) match=1 equation=PASS$',kat[1],re.M)
    assert len(katrows)==300 and {(int(d),int(i)) for d,i in katrows}=={(d,i) for d in (256,512,1024) for i in range(100)}
    ct=timings(records('CT_OP',text),('op',))
    mul=timings(records('MUL',text),('backend',))
    fft=timings(records('CT_FFT',text),('backend','logn','inverse'))
    assert len(ct)==4 and len(mul)==3 and len(fft)==60
    report['validation'][name]=dict(KAT=300,differential=dif[0],kernels=kernels,CT_ops=ct,CT_mul=mul,CT_FFT=fft,
        all_observed_minima_equal=all(len(x['minima'])==1 for x in ct+mul+fft),kernel_run=r['run_dir'],kat_run=kat[0]['run_dir'])
    assert report['validation'][name]['all_observed_minima_equal'],(name,'observed input-dependent minimum')
    v=PARENT/folder/'validation'
    audits=json.loads((v/'results/static/audit.json').read_text())
    for label in ('kernels','kat','asm-perf'):
        audit=next(x for x in audits if x['label']==label)
        assert audit['elf_sha256']==sha(v/'build'/label/'zephyr/zephyr.elf'),(name,label,'stale static audit')
    report['validation'][name]['static_audit']=str(v/'results/static/audit.json')
for name,perf in report['performance'].items():
    for degree,row in perf.items():
        if 'R3' in report['performance']:row['cycle_reduction_vs_R3_percent']=(1-row['mean']/report['performance']['R3'][degree]['mean'])*100
        if 'fixed' in report['performance']:row['time_vs_fixed_ratio']=row['mean']/report['performance']['fixed'][degree]['mean']
if 'F3u' in report['performance'] and 'F3b' in report['performance']:
    assert report['memory']['F3u']['FFT_functions']==report['memory']['F3b']['FFT_functions'],'paired Slothy code placement mismatch'
    report['isolated_merged_Slothy']={d:dict(cycle_reduction_percent=(1-report['performance']['F3b'][d]['mean']/report['performance']['F3u'][d]['mean'])*100) for d in (512,1024)}
if 'R3' in report['memory'] and 'F1' in report['memory']:
    assert report['memory']['R3']['FFT_functions']==report['memory']['F1']['FFT_functions'],'F1/R3 FFT placement mismatch'
report['repeatability']={}
for name in ('F2','F3c'):
    folder=STAGES[name]
    latest=load(folder,'asm-perf')
    if not latest:continue
    batches=[]
    for path in sorted((PARENT/folder/'validation/results/asm-perf').glob('*/run.json')):
        run=json.loads(path.read_text())
        assert run['valid'] and not run['errors'],(name,path,'invalid repeat')
        assert run['build_manifest']==latest[0]['build_manifest'],(name,path,'different repeated binary')
        assert sha(path.parent/'raw.log')==run['raw_sha256']
        assert {(x['degree'],x['index']):x['digest'] for x in run['keys']}==expected
        batches.append(dict(run_dir=run['run_dir'],means={d:sum(x['cycles'] for x in run['keys'] if x['degree']==d)/100 for d in (512,1024)}))
    report['repeatability'][name]=batches
profile=load('fp64_two_prod','asm-profile')
if profile:
    r,text=profile
    assert {(x['degree'],x['index']):x['digest'] for x in r['keys']}==expected
    report['F2_profile']=[dict(degree=d,kind=k,calls=sum(x['calls'] for x in r['approx'] if x['degree']==d and x['kind']==k),cycles_per_key=sum(x['cycles'] for x in r['approx'] if x['degree']==d and x['kind']==k)/100) for d in (512,1024) for k in (0,1)]
out=ROOT/'results/stage_comparison.json'
out.parent.mkdir(exist_ok=True)
out.write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps({k:v for k,v in report.items() if k not in ('sources','validation')},indent=2))
if report['pending'] and '--partial' not in sys.argv:raise SystemExit('Pending measurements')
