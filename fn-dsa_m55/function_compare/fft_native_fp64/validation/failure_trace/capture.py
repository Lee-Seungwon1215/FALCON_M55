#!/usr/bin/env python3
"""Instrument generated copies only; compare complete native execution traces."""
from datetime import datetime,timezone
from fractions import Fraction as F
import hashlib,json,struct,subprocess
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
HERE=Path(__file__).resolve().parent
OUT=ROOT/'results/failure-trace'/datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ')
OUT.mkdir(parents=True,exist_ok=False)
FLAGS=['-O3','-ffp-contract=off','-fno-fast-math','-fno-strict-aliasing','-DFNDSA_AVX2=0']
NAMES='codec mq sha3 sysrng util kgen kgen_fxp kgen_gauss kgen_mp31 kgen_ntru kgen_poly kgen_zint31 sign sign_core sign_fpoly sign_fpr sign_sampler vrfy'.split()
cases=json.loads((ROOT/'results/followup-host/20260923T060455Z/summary.json').read_text())['mismatches']
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
manifest={}
def replace(s,a,b):
    assert s.count(a)==1,(a,s.count(a))
    return s.replace(a,b)
proto='''#include "kgen_inner.h"
extern void tr_attempt(unsigned,const int8_t*,const int8_t*);
extern void tr_enter(unsigned,unsigned);
extern void tr_iteration(unsigned,unsigned,unsigned);
extern void tr_stage(const char*,unsigned,unsigned,const void*);
extern void tr_convert(const char*,unsigned,unsigned,const void*,const uint32_t*,size_t,uint32_t,unsigned);
extern void tr_k(unsigned,unsigned,const int32_t*,unsigned);
extern void tr_status(unsigned,int);
'''
for backend in ('reference','q32_trial'):
    source=ROOT/backend;text=(source/'kgen_ntru.c').read_text()
    start=text.index('solve_NTRU_intermediate(');end=text.index('\n#if FNDSA_AVX2',start)
    part=text[start:end];sfx='_fp64' if backend=='q32_trial' else '';convert='fp64' if sfx else 'fixed'
    part=replace(part,'\tunsigned logn = logn_top - depth;','\tunsigned logn = logn_top - depth;\n\ttr_enter(logn,depth);')
    old=f'\tpoly_big_to_{convert}(logn, rt3, ftb, rlen, scdiff);'
    part=replace(part,old,old+'\n\ttr_convert("input_f",logn,depth,rt3,ftb,rlen,scdiff,scale_t);')
    old=f'\t\tpoly_big_to_{convert}(logn, rt1,\n\t\t\tFt + tlen * n, FGlen - tlen, scale_x + toff);'
    part=replace(part,old,'\t\ttr_iteration(logn,depth,scale_FG);\n'+old+'\n\t\ttr_convert("input_F",logn,depth,rt1,Ft+tlen*n,FGlen-tlen,scale_x+toff,scale_t);')
    for a,b,c in [('vect_FFT','logn, rt3','FFT_f'),('vect_inv_mul2e_fft','logn, rt3, scale_t','inverse'),
                  ('vect_FFT','logn, rt1','FFT_F'),('vect_mul_fft','logn, rt1, rt3','pointwise'),('vect_iFFT','logn, rt1','iFFT')]:
        old=a+sfx+'('+b+');';var='rt3' if c in ('FFT_f','inverse') else 'rt1'
        part=replace(part,old,old+f'\n\ttr_stage("{c}",logn,depth,{var});')
    if sfx:
        old='\t\tround_ok &= fp64_k_update_ok(logn, k);'
        part=replace(part,old,old+'\n\t\ttr_k(logn,depth,k,round_ok);')
    else:
        old='\t\t\tk[i] = fxr_round(rt1[i]);\n\t\t}'
        part=replace(part,old,old+'\n\t\ttr_k(logn,depth,k,1);')
    text=text[:start]+part+text[end:]
    start=text.index('\nsolve_NTRU(unsigned logn,');end=text.index('\n#if FNDSA_AVX2',start)
    part=text[start:end]
    old='\tsize_t n = (size_t)1 << logn;'
    part=replace(part,old,'\ttr_attempt(logn,f,g);\n'+old)
    for old,new in [
      ('int err = solve_NTRU_deepest(logn, f, g, tmp);','tr_status(logn,err);'),
      ('err = solve_NTRU_intermediate(logn, f, g, depth, tmp);','tr_status(depth,err);'),
      ('err = solve_NTRU_depth0(logn, f, g, tmp);','tr_status(0,err);')]:
        part=replace(part,old,old+'\n\t'+new)
    text=proto+text[:start]+part+text[end:]
    generated=OUT/(backend+'-instrumented.c');generated.write_text(text)
    cmd=['clang',*FLAGS,'-I'+str(source),'-I'+str(ROOT/'validation/generated'),
         *[str(source/(n+'.c')) for n in NAMES if n!='kgen_ntru'],str(generated),str(HERE/'capture.c'),'-lm','-o',str(OUT/backend)]
    subprocess.run(cmd,check=True)
    manifest[backend]=dict(command=cmd,source={str(p):sha(p) for p in source.glob('*.[chs]')},generated_sha256=sha(generated))
    for c in cases:
        key=f"{c['degree']}-{c['index']}";path=OUT/(key+'-'+backend+'.jsonl')
        with path.open('w') as f:subprocess.run([str(OUT/backend),str(c['degree'].bit_length()-1),'fp64-audit-20260923-'+str(c['index'])],stdout=f,check=True)
        rows=[json.loads(l) for l in path.read_text().splitlines()]
        assert rows[-1]['digest']==c['reference' if backend=='reference' else 'candidate'],('instrumentation altered result',key)
        print('CAPTURE',backend,key,'events',len(rows),'digest matched',flush=True)
(OUT/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
def value(h,backend):
    x=int(h,16)
    if backend=='reference':return F(x-(1<<64) if x>>63 else x,1<<32)
    return F(struct.unpack('>d',x.to_bytes(8,'big'))[0])
def ident(r):return tuple(r.get(k) for k in ('type','stage','attempt','logn','depth','iteration'))
summaries=[]
for c in cases:
    key=f"{c['degree']}-{c['index']}"
    streams=[[json.loads(l) for l in (OUT/(key+'-'+b+'.jsonl')).read_text().splitlines()] for b in ('reference','q32_trial')]
    first_value=None;first_k=None;f_input=None;F_input=None;prior_equal=0
    for x,y in zip(*streams):
        assert ident(x)==ident(y),('execution differed before k',key,ident(x),ident(y))
        if x['type']=='attempt':assert x==y
        elif x['type']=='status':assert x==y,('status before k',key,x,y)
        elif x['type']=='convert':
            assert x['limbs']==y['limbs'] and x['fixed_bits']==y['fixed_bits']
            if x['stage']=='input_f':f_input=(x,y)
            else:F_input=(x,y)
        if x['type'] in ('stage','convert'):
            diff=[i for i,(u,v) in enumerate(zip(x['bits'],y['bits'])) if value(u,'reference')!=value(v,'q32_trial')]
            if diff and first_value is None:first_value=dict(context={k:v for k,v in x.items() if k not in ('bits','limbs','fixed_bits')},indices=diff,fixed=x['bits'][diff[0]],trial=y['bits'][diff[0]])
        if x['type']=='k':
            if x['k']!=y['k'] or x['valid']!=y['valid']:
                first_k=dict(reference=x,candidate=y);break
            prior_equal+=1
    assert first_k and f_input and F_input,key
    frozen=dict(case=c,first_numeric_difference=first_value,first_k_difference=first_k,
                prior_equal_k_vectors=prior_equal,f_input=f_input,F_input=F_input)
    (OUT/(key+'-first.json')).write_text(json.dumps(frozen,indent=2)+'\n')
    row=dict(case=key,first_numeric_difference=first_value,first_k_difference=first_k,prior_equal_k_vectors=prior_equal)
    summaries.append(row);print('FIRST',json.dumps(row),flush=True)
assert all(sha(Path(p))==h for b in manifest.values() for p,h in b['source'].items())
(OUT/'summary.json').write_text(json.dumps(summaries,indent=2)+'\n')
print('TRACE_OUTPUT',OUT,flush=True)
