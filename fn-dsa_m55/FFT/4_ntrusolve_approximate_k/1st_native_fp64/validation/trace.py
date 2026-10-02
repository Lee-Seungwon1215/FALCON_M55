#!/usr/bin/env python3
"""Reproduce the first upstream KAT divergence and high-precision round check."""
import json
from pathlib import Path
import re
import subprocess
from decimal import Decimal as D,localcontext,ROUND_FLOOR
import host

ROOT=Path(__file__).resolve().parent
BUILD=ROOT/'build/trace'
BUILD.mkdir(parents=True,exist_ok=True)
def patch(text,old,new):
    assert text.count(old)==1,old
    return text.replace(old,new)
for label,source in [('ref',host.BASE),('fp64',host.SOURCE)]:
    original=(source/'kgen_ntru.c').read_text()
    start=original.index('solve_NTRU_intermediate(')
    end=original.index('\n#if FNDSA_AVX2',start)
    part=original[start:end]
    suffix='_fp64' if label=='fp64' else ''
    part=patch(part,'\tvect_FFT'+suffix+'(logn, rt3);','\ttrace_f(logn,rt3,scale_t);\n\tvect_FFT'+suffix+'(logn, rt3);')
    part=patch(part,'\t\tvect_FFT'+suffix+'(logn, rt1);','\t\ttrace_F(logn,rt1);\n\t\tvect_FFT'+suffix+'(logn, rt1);')
    part=patch(part,'\t\t/* k <- round(rt1)','\t\ttrace_round(logn,depth,scale_FG,rt1);\n\t\t/* k <- round(rt1)')
    text=original[:start]+part+original[end:]
    start=text.index('\nsolve_NTRU(unsigned logn,')
    end=text.index('\n#if FNDSA_AVX2',start)
    part=text[start:end]
    part=patch(part,'\tsize_t n = (size_t)1 << logn;','\ttrace_attempt(logn,f,g);\n\tsize_t n = (size_t)1 << logn;')
    for old,new in [
        ('int err = solve_NTRU_deepest(logn, f, g, tmp);','int err = solve_NTRU_deepest(logn, f, g, tmp);\n\ttrace_status(logn,err);'),
        ('err = solve_NTRU_intermediate(logn, f, g, depth, tmp);','err = solve_NTRU_intermediate(logn, f, g, depth, tmp);\n\t\ttrace_status(depth,err);'),
        ('err = solve_NTRU_depth0(logn, f, g, tmp);','err = solve_NTRU_depth0(logn, f, g, tmp);\n\ttrace_status(0,err);')]:
        part=patch(part,old,new)
    text=text[:start]+part+text[end:]
    text='''#include <stdint.h>
extern void trace_f(unsigned,const void*,unsigned);
extern void trace_F(unsigned,const void*);
extern void trace_round(unsigned,unsigned,unsigned,const void*);
extern void trace_attempt(unsigned,const int8_t*,const int8_t*);
extern void trace_status(unsigned,int);
'''+text
    path=BUILD/(label+'.c');path.write_text(text)
    sources=[str(source/(n+'.c')) for n in host.NAMES if n!='kgen_ntru']
    subprocess.run(['clang',*host.FLAGS,'-I'+str(source),'-DTRACE_FP64='+str(int(label=='fp64')),
        *sources,str(path),str(ROOT/'trace.c'),'-lm','-o',str(BUILD/label)],check=True)
    with (BUILD/(label+'.jsonl')).open('w') as out:
        subprocess.run([str(BUILD/label),'9','test43'],stdout=out,check=True)
    if label=='ref':
        with (BUILD/'ref1024.jsonl').open('w') as out:
            subprocess.run([str(BUILD/label),'10','test0'],stdout=out,check=True)

def load(label):
    return [json.loads(l) for l in (BUILD/(label+'.jsonl')).read_text().splitlines()]
a,b=load('ref'),load('fp64')
events={label:[x for x in seq if x['type']!='round'] for label,seq in [('ref',a),('fp64',b)]}
with localcontext() as ctx:
    ctx.prec=80
    gm=host.roots()
    first=None
    for x,y in zip(a,b):
        if x['type']!=y['type']: break
        if x['type']!='round': continue
        ka=[int((D(float.fromhex(v))+D('0.5')).to_integral_value(rounding=ROUND_FLOOR)) for v in x['x']]
        kb=[int((D(float.fromhex(v))+D('0.5')).to_integral_value(rounding=ROUND_FLOOR)) for v in y['x']]
        if ka==kb: continue
        # The FIRST different rounded k must start from equal f and F inputs.
        assert x['f']==y['f'] and x['F']==y['F']
        f=[D(float.fromhex(v)) for v in x['f']]
        F=[D(float.fromhex(v)) for v in x['F']]
        host.fft(f,gm);hn=len(f)//2
        for i in range(hn):
            re,im=f[i],-f[i+hn];z=re*re+im*im
            f[i]=re*(D(2)**x['e'])/z;f[i+hn]=im*(D(2)**x['e'])/z
        host.fft(F,gm)
        for i in range(hn):F[i],F[i+hn]=host.mul((F[i],F[i+hn]),(f[i],f[i+hn]))
        host.fft(F,gm,True)
        mismatch=[]
        for i,(u,v) in enumerate(zip(ka,kb)):
            if u!=v:
                mismatch.append(dict(index=i,fixed_x=float.fromhex(x['x'][i]),fp64_x=float.fromhex(y['x'][i]),
                    oracle=str(F[i]),fixed_k=u,fp64_k=v,oracle_k=int((F[i]+D('0.5')).to_integral_value(rounding=ROUND_FLOOR))))
        first=dict(round_id=x['id'],logn=x['logn'],depth=x['depth'],scale=x['scale'],differences=mismatch)
        break
data=dict(seed='test43',degree=512,events=events,first_different_k=first)
(BUILD/'diagnosis.json').write_text(json.dumps(data,indent=2)+'\n')
print(json.dumps(data,indent=2))
