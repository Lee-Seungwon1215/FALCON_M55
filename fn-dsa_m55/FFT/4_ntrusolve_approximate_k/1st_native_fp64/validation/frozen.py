#!/usr/bin/env python3
"""Frozen real inputs + independent 80-decimal-digit and host C checks."""
import ctypes as C
from decimal import Decimal as D,localcontext,ROUND_FLOOR
import json
from pathlib import Path
import host

ROOT=Path(__file__).resolve().parent
lib=C.CDLL(str(host.BUILD/'libfp64.dylib'))
xp=C.POINTER(host.FXR);dp=C.POINTER(C.c_double)
for suffix,ptr in [('',xp),('_fp64',dp)]:
    for name in ['FFT','iFFT']:getattr(lib,'fndsa_vect_'+name+suffix).argtypes=[C.c_uint,ptr]
    getattr(lib,'fndsa_vect_mul_fft'+suffix).argtypes=[C.c_uint,ptr,ptr]
    getattr(lib,'fndsa_vect_inv_mul2e_fft'+suffix).argtypes=[C.c_uint,ptr,C.c_uint]
lib.validation_fixed_round.argtypes=[C.c_uint,xp,C.POINTER(C.c_int32)]
lib.validation_round.argtypes=[C.c_double];lib.validation_round.restype=C.c_int32
selected=[];available={l:[] for l in range(1,10)};seen=set()
for file in ['ref.jsonl','ref1024.jsonl']:
    for row in map(json.loads,(ROOT/'build/trace'/file).read_text().splitlines()):
        if row['type']!='round':continue
        l=row['logn']
        signature=(l,row['e'],tuple(row['f_bits']),tuple(row['F_bits']))
        peak=max(abs(float.fromhex(x)) for x in row['x'])
        # Distinct, real reduction states with nonzero k, not duplicate early
        # iterations whose outputs all round to zero. Keep ordinary k sizes.
        if signature in seen or not 0.5<=peak<=1024:continue
        seen.add(signature);available[l].append((peak,row))
for l in range(1,10):
    assert len(available[l])>=2,l
    selected.append(available[l][0][1])
    selected.append(max(available[l][1:],key=lambda item:item[0])[1])
# Include the first KAT-divergence input as an explicit stress case.
diag=json.loads((ROOT/'build/trace/diagnosis.json').read_text())
rid=diag['first_different_k']['round_id']
selected.append(next(r for r in map(json.loads,(ROOT/'build/trace/ref.jsonl').read_text().splitlines()) if r['type']=='round' and r['id']==rid))
rows=[];parts=['/* Generated from public NTRU test seeds; see frozen.py. */',
    'struct kernel_case { unsigned logn,e; const uint64_t *f,*F; const int32_t *k_fixed,*k_fp64; };']
with localcontext() as ctx:
    ctx.prec=80;gm=host.roots()
    for number,row in enumerate(selected):
        l=row['logn'];n=1<<l;e=row['e'];hn=n//2
        fr=[int(x,16) for x in row['f_bits']];Fr=[int(x,16) for x in row['F_bits']]
        f=[float(D(host.signed(x))/(1<<32)) for x in fr];F=[float(D(host.signed(x))/(1<<32)) for x in Fr]
        aq=(host.FXR*n)(*[host.FXR(x) for x in fr]);bq=(host.FXR*n)(*[host.FXR(x) for x in Fr]);kq=(C.c_int32*n)()
        ad=(C.c_double*n)(*f);bd=(C.c_double*n)(*F)
        for suffix,a,b in [('',aq,bq),('_fp64',ad,bd)]:
            getattr(lib,'fndsa_vect_FFT'+suffix)(l,a)
            getattr(lib,'fndsa_vect_inv_mul2e_fft'+suffix)(l,a,e)
            getattr(lib,'fndsa_vect_FFT'+suffix)(l,b)
            getattr(lib,'fndsa_vect_mul_fft'+suffix)(l,b,a)
            getattr(lib,'fndsa_vect_iFFT'+suffix)(l,b)
        lib.validation_fixed_round(l,bq,kq);kd=[lib.validation_round(x) for x in bd]
        # High precision uses the same binary64 inputs and quantized roots.
        fa=list(map(D,f));Fa=list(map(D,F));host.fft(fa,gm)
        for i in range(hn):
            re,im=fa[i],-fa[i+hn];z=re*re+im*im
            fa[i]=re*(D(2)**e)/z;fa[i+hn]=im*(D(2)**e)/z
        host.fft(Fa,gm)
        for i in range(hn):Fa[i],Fa[i+hn]=host.mul((Fa[i],Fa[i+hn]),(fa[i],fa[i+hn]))
        host.fft(Fa,gm,True)
        oracle_k=[int((x+D('0.5')).to_integral_value(rounding=ROUND_FLOOR)) for x in Fa]
        assert kd==oracle_k,('oracle k',number)
        errors=[abs(D(x)-y) for x,y in zip(bd,Fa)]
        for name,values,typ in [('f',fr,'uint64_t'),('F',Fr,'uint64_t'),('kq',list(kq),'int32_t'),('kd',kd,'int32_t')]:
            vals=','.join(('UINT64_C(0x%016x)'%v) if typ=='uint64_t' else str(v) for v in values)
            parts.append(f'static const {typ} case_{number}_{name}[]={{'+vals+'};')
        rows.append(dict(case=number,logn=l,e=e,trace_round=row['id'],max_abs_k=max(abs(v) for v in kd),max_abs_error=str(max(errors)),k_oracle_match=True,
            fixed_fp64_k_differences=sum(x!=y for x,y in zip(kq,kd))))
parts.append('static const struct kernel_case cases[]={')
for i,r in enumerate(selected):parts.append('{%d,%d,case_%d_f,case_%d_F,case_%d_kq,case_%d_kd},'%(r['logn'],r['e'],i,i,i,i))
parts.append('};')
(ROOT/'kernel_cases.h').write_text('\n'.join(parts)+'\n')
(ROOT/'build/host/frozen-oracle.json').write_text(json.dumps(rows,indent=2)+'\n')
print('Frozen real-input cases:',len(rows),'all FP64 k match 80-digit oracle')
