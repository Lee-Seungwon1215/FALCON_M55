#!/usr/bin/env python3
"""Correctness only. Host timings are never reported as board performance."""
import ctypes as C
from decimal import Decimal as D, localcontext
import hashlib
import importlib.util
import json
import math
from pathlib import Path
import random
import re
import subprocess

ROOT=Path(__file__).resolve().parent
NEW=ROOT.parent
OLD=NEW.parent
FIXED=OLD.parent/'ref'
BUILD=ROOT/'build/host'
NAMES='codec mq sha3 sysrng util kgen kgen_fxp kgen_gauss kgen_mp31 kgen_ntru kgen_poly kgen_zint31 sign sign_core sign_fpoly sign_fpr sign_sampler vrfy'.split()
FLAGS=['-O3','-ffp-contract=off','-fno-fast-math','-fno-strict-aliasing','-DFNDSA_AVX2=0','-DFNDSA_UNALIGNED_16=0','-DFNDSA_UNALIGNED_64=0']
SAN=['-fsanitize=undefined,float-cast-overflow','-fno-sanitize-recover=all']
def run(cmd):
    subprocess.run(list(map(str,cmd)),check=True)
def execute(exe,path):
    with path.open('w') as out:
        r=subprocess.run([str(exe)],stdout=out,stderr=subprocess.STDOUT)
    return r.returncode,path.read_text()
def snapshot(source):
    return {p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in sorted(source.glob('*.[chs]'))}

def build():
    BUILD.mkdir(parents=True,exist_ok=True)
    run(['python3','-B',ROOT/'generate.py',NEW,BUILD/'generated','perf'])
    before={str(p):snapshot(p) for p in (OLD,FIXED)}
    summary={}
    for label,source in [('old',OLD),('new',NEW)]:
        objects=[]
        for name in NAMES:
            src=ROOT/'host_fxp.c' if label=='new' and name=='kgen_fxp' else source/(name+'.c')
            obj=BUILD/(label+'-'+name+'.o')
            extra=SAN if name in ('kgen_fxp','kgen_poly','kgen_ntru') else []
            run(['clang',*FLAGS,*extra,'-I'+str(source),'-I'+str(BUILD/'generated'),'-c',src,'-o',obj])
            objects.append(obj)
        for test in ('kat','signatures'):
            exe=BUILD/(label+'-'+test)
            src=ROOT/('kat_audit.c' if test=='kat' else 'benchmark.c')
            run(['clang',*FLAGS,*SAN,'-DBENCH_HOST','-I'+str(source),*objects,src,'-lm','-o',exe])
            code,text=execute(exe,BUILD/(label+'-'+test+'.log'))
            if test=='kat':
                assert 'KEY_KAT_SUMMARY count=300' in text, text[-2000:]
                assert code in (0,2) or (code==1 and 'KAT-hash: wrong value' in text), text[-2000:]
                rows=re.findall(r'KEY_KAT degree=(\d+) seed=(\w+) match=(\d) actual=([a-f0-9]+)',text)
                summary[label]=dict(kat_count=len(rows),mismatches=[(int(d),s) for d,s,m,h in rows if m=='0'],
                    actual=[(int(d),s,h) for d,s,m,h in rows],
                    full_scheme_kat='FAIL' if 'KAT-hash: wrong value' in text else 'PASS')
            else:
                assert code==0 and 'signature_and_tamper=PASS' in text,text[-2000:]
                summary[label]['signatures']=re.findall(r'KEY degree=(\d+) index=(\d+) cycles=0 digest=([a-f0-9]+)',text)
                assert len(summary[label]['signatures'])==200
            print(label,test,'completed',flush=True)
    assert summary['old']['actual']==summary['new']['actual']
    assert summary['old']['signatures']==summary['new']['signatures']
    assert before=={str(p):snapshot(p) for p in (OLD,FIXED)}
    # Unsanitized shared object for Python numerical oracles; the real-keygen
    # executable above already checks the changed units with UBSan.
    run(['clang',*FLAGS,'-I'+str(NEW),'-I'+str(BUILD/'generated'),
         *[ROOT/'host_fxp.c' if n=='kgen_fxp' else NEW/(n+'.c') for n in NAMES],
         ROOT/'wrappers.c','-dynamiclib','-lm','-o',BUILD/'libfp64.dylib'])
    summary['source_unchanged']=before
    summary['new_source']=snapshot(NEW)
    return summary

def numerical():
    # Reuse the independently established conversion/rounding/Decimal oracle;
    # it only reads crypto files here, never invokes its old build routine.
    spec=importlib.util.spec_from_file_location('previous_host',OLD/'validation/host.py')
    h=importlib.util.module_from_spec(spec);spec.loader.exec_module(h)
    h.SOURCE=NEW;h.BUILD=BUILD
    with localcontext() as ctx:
        ctx.prec=80
        result=h.lowlevel()
        lib=C.CDLL(str(BUILD/'libfp64.dylib'))
        ptr=C.POINTER(C.c_double)
        lib.baseline_iFFT.argtypes=[C.c_uint,ptr]
        lib.candidate_iFFT.argtypes=[C.c_uint,ptr]
        gm=h.roots();rng=random.Random(20260918)
        count=0;coefficients=0;errors=[]
        for l in range(1,11):
            n=1<<l
            for t in range(200):
                exp=rng.randint(-500,500)
                values=[math.ldexp(rng.randint(-2**24,2**24),exp-24) for _ in range(n)]
                if t==0:values=[0.0]*n
                if t==1:values=[-0.0]*n
                if t==2:values=[(-1.0)**i for i in range(n)]
                if t==3:values=[1.0]+[0.0]*(n-1)
                a=(C.c_double*n)(*values);b=(C.c_double*n)(*values)
                lib.baseline_iFFT(l,a);lib.candidate_iFFT(l,b)
                assert bytes(a)==bytes(b),(l,t)
                assert all(math.isfinite(x) for x in b)
                count+=1;coefficients+=n
                if t<8:
                    oracle=list(map(D,values));h.fft(oracle,gm,True)
                    e=max(abs(D(x)-y) for x,y in zip(b,oracle))
                    scale=max(D(1),max(map(abs,oracle)))
                    assert e/scale<D('1e-13'),(l,t,e/scale)
                    errors.append(dict(logn=l,case=t,max_abs=str(e),relative_to_max_or_1=str(e/scale)))
        result.update(ifft_bitexact_vectors=count,ifft_bitexact_coefficients=coefficients,
                      ifft_decimal80=errors,domain='finite normal-range inputs, common exponent -500..500, plus zero/cancellation/sparse')
    return result

if __name__=='__main__':
    summary=build();summary['numerical']=numerical()
    (BUILD/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
    print(json.dumps({k:{a:b for a,b in v.items() if a not in ('actual','signatures')} for k,v in summary.items() if k in ('old','new')},indent=2))
    print('HOST_ALL_DONE',flush=True)
