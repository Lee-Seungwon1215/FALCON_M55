#!/usr/bin/env python3
"""Validate final logs and produce machine-readable paired measurements."""
import hashlib,json,re,statistics,subprocess
from pathlib import Path
from elftools.elf.elffile import ELFFile
ROOT=Path(__file__).resolve().parent.parent
M55=ROOT.parents[1]
OUT=ROOT/'validation/results'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def read(kind):
    dirs=sorted((OUT/kind).glob('*/manifest.json'))
    assert dirs,kind
    p=dirs[-1];m=json.loads(p.read_text());assert m['valid_measurement'],m['errors']
    assert sha(p.parent/'raw.log')==m['raw_sha256']
    for file,h in m['source_sha256'].items():
        if Path(file).parent==Path(m['crypto_root']):assert sha(Path(file))==h,file
    assert sha(Path(m['elf']))==m['elf_sha256']
    raw=re.sub(r'Info : [^\n]*\n','',(p.parent/'raw.log').read_text())
    return m,raw,str(p.parent.relative_to(ROOT))
def memory_and_symbols(m):
    with Path(m['elf']).open('rb') as f:
        e=ELFFile(f);sections=[s for s in e.iter_sections() if s['sh_flags']&2 and s['sh_size']]
        mem={n:max(s['sh_addr']+s['sh_size'] for s in sections if b<=s['sh_addr']<b+262144)-b
            for n,b in [('ITCM',0x10000000),('DTCM',0x30000000)]}
        sy=e.get_section_by_name('.symtab')
        integers={s.name:(s['st_value']&~1,s['st_size']) for s in sy.iter_symbols()
            if s['st_size'] and s.name.startswith(('fndsa_zint','zint_'))}
        for n in ('fndsa_keygen_seeded_temp',):
            v=sy.get_symbol_by_name(n)
            if v:assert 0x10000000<=v[0]['st_value']<0x10040000
        for n in ('sk','pk','tmp','samples','z_main_stack'):
            v=sy.get_symbol_by_name(n)
            if v:assert all(0x30000000<=s['st_value']<0x30040000 for s in v)
        return mem,integers
mk,rk,pk=read('kernels')
rows={}
for line in rk.splitlines():
    if line.startswith('HYBRID_KERNEL '):
        x={k:int(v) for k,v in re.findall(r'(\w+)=(\d+)',line)}
        rows[(x['logn'],x['op'],x['backend'])]=x
assert len(rows)==74,len(rows)
kernel=[]
for (lg,op,be),x in rows.items():
    if be==0:continue
    base=rows[(lg,op,0)]['total']/100;c=x['total']/100
    kernel.append(dict(n=1<<lg,op=op,backend=be,baseline=base,current=c,
        speedup=base/c,time_reduction_percent=100*(1-c/base),differing_coefficients=x['diff'],max_lsb=x['max_lsb']))
timing={}
for line in rk.splitlines():
    if line.startswith('HYBRID_TIMING '):
        x={k:int(v) for k,v in re.findall(r'(\w+)=(\d+)',line)}
        timing.setdefault((x['logn'],x['op']),[]).append(x)
ct=[]
for (lg,op),x in timing.items():
    assert len(x)==8 and {r['class'] for r in x}==set(range(8))
    ct.append(dict(n=1<<lg,op=op,sample_range=max(r['max'] for r in x)-min(r['min'] for r in x),
        mean_range=(max(r['total'] for r in x)-min(r['total'] for r in x))/100))
summary=dict(kernel=kernel, timing=ct, runs={'kernels':pk}, whole_keygen={},memory={})
for kind in ('kat','sigkat'):
    m,r,p=read(kind);summary['runs'][kind]=p;summary['memory'][kind]=memory_and_symbols(m)[0]
    assert m['source_sha256'][str(ROOT/'kgen_fxp.c')]==mk['source_sha256'][str(ROOT/'kgen_fxp.c')]
    assert m['source_sha256'][str(ROOT/'kgen_fft_mve.c')]==mk['source_sha256'][str(ROOT/'kgen_fft_mve.c')]
for prefix in ('keygen','keylayout'):
    parsed={};meta={};locations={};symbols={};configs=[];harness=[]
    for label in ('ref','ntt','current'):
        kind=prefix+'_'+label;m,r,p=read(kind);summary['runs'][kind]=p
        rr=re.findall(r'^KEYGEN_PERF degree=(\d+) index=(\d+) cycles=(\d+) match=1 equation=PASS keyhash=([0-9a-f]{64})$',r,re.M)
        assert len(rr)==200
        parsed[label]={(int(d),int(i)):(int(c),h) for d,i,c,h in rr}
        assert set(parsed[label])=={(d,i) for d in (512,1024) for i in range(100)}
        meta[label]=m
        summary['memory'][kind],symbols[label]=memory_and_symbols(m)
        build=Path(m['elf']).parent.parent
        configs.append(sha(build/'zephyr/.config'));harness.append(m['source_sha256'][str(ROOT/'validation/board_keygen_perf.c')])
    assert len(set(configs))==len(set(harness))==1
    if prefix=='keylayout':assert symbols['ref']==symbols['ntt']==symbols['current']
    for k in parsed['ref']:assert len({parsed[n][k][1] for n in parsed})==1
    summary['whole_keygen'][prefix]=[]
    for d in (512,1024):
        means={lab:statistics.mean(v[0] for (degree,i),v in vals.items() if degree==d) for lab,vals in parsed.items()}
        row=dict(n=d,mean_cycles=means,encoded_key_pairs_equal=100)
        for b in ('ref','ntt'):
            row[b+'_speedup']=means[b]/means['current']
            row[b+'_reduction_percent']=100*(1-means['current']/means[b])
        summary['whole_keygen'][prefix].append(row)
    summary[prefix+'_integer_symbols']=symbols
# Source-scope audit: no NTT, solver, surrounding arithmetic or signing edits.
scope={}
for p in (M55/'ntt_opt').glob('*.[chs]'):
    q=ROOT/p.name
    if q.exists():scope[p.name]=sha(p)==sha(q)
assert {n for n,eq in scope.items() if not eq}=={'kgen_fxp.c','kgen_inner.h'}
assert sha(M55/'ntt_opt/kgen_fxp.c')==sha(M55/'M55_ref/kgen_fxp.c')
summary['source_unchanged_vs_ntt_opt']=scope
oracle=(ROOT/'validation/ref_fxp.c').read_text()
oracle=re.sub(r'^/\* Test-only[^\n]*\*/\n','',oracle)
oracle=re.sub(r'\bref_([a-zA-Z0-9_]+)',r'\1',oracle)
assert oracle==(M55/'ntt_opt/kgen_fxp.c').read_text()
summary['fixed_oracle_exact_recovery']=True
hostexe=ROOT/'validation/build/test_host_invnorm'
subprocess.run(['clang','-O3','-ffp-contract=off','-fno-fast-math','-fno-strict-aliasing',
    '-DFNDSA_NEON=0','-DFNDSA_AVX2=0','-DFNDSA_SSE2=0','-I'+str(ROOT),
    str(ROOT/'kgen_fxp.c'),str(ROOT/'validation/ref_fxp.c'),
    str(ROOT/'validation/test_host_invnorm.c'),'-o',str(hostexe)],check=True)
host=subprocess.check_output([str(hostexe)],text=True)
assert 'HOST_INVNORM count=1023000 differing=0 max_lsb=0' in host
summary['host_invnorm']=host.strip()
tool=M55/'measurement_mlkem_native/env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin/arm-none-eabi-objdump'
dis=subprocess.check_output([str(tool),'-d','--disassemble=fndsa_vect_invnorm_fp64_q32',str(ROOT/'validation/build/kat/zephyr/zephyr.elf')],text=True)
summary['invnorm_machine_code']={'hardware_vdiv_f64':'vdiv.f64' in dis,
    'libgcc_float_helpers':'__aeabi_' in dis,
    'conditional_branches':re.findall(r'^.*\s(?:beq|bne|bhi|blo|bls|bge|blt|bgt|ble)(?:\.[nw])?\s.*$',dis,re.M)}
(OUT/'final_summary.json').write_text(json.dumps(summary,indent=2)+'\n')
print(json.dumps({k:summary[k] for k in ('whole_keygen','memory','invnorm_machine_code')},indent=2))
