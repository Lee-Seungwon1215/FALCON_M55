#!/usr/bin/env python3
"""Replay actual compiled primitives; freeze the earliest numerical mismatch.
This is separate from the guard rejection that changes the five keys.
"""
import ctypes as C,json,struct,sys
from fractions import Fraction as F
from pathlib import Path
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[1];OUT=Path(sys.argv[1]).resolve()
MASK=(1<<64)-1;B=1<<32
signed=lambda x:x-(1<<64) if x>>63 else x
bits=lambda x:struct.unpack('>Q',struct.pack('>d',x))[0]
decode=lambda x:struct.unpack('>d',int(x,16).to_bytes(8,'big'))[0]
class FXR(C.Structure):_fields_=[('v',C.c_uint64)]
lib=C.CDLL(str(OUT/'probes.dylib'))
for name in ('mul','add','div'):
    fn=getattr(lib,'diag_fixed_'+name);fn.argtypes=[C.c_uint64,C.c_uint64];fn.restype=C.c_uint64
    fn=getattr(lib,'diag_trial_'+name);fn.argtypes=[C.c_double,C.c_double];fn.restype=C.c_double
lib.diag_fixed_sqr.argtypes=[C.c_uint64];lib.diag_fixed_sqr.restype=C.c_uint64
lib.diag_normal_div.argtypes=[C.c_double,C.c_double];lib.diag_normal_div.restype=C.c_double
lib.diag_fixed_scale.argtypes=[C.c_uint64,C.c_uint];lib.diag_fixed_scale.restype=C.c_uint64
lib.diag_trial_scale.argtypes=[C.c_double,C.c_uint];lib.diag_trial_scale.restype=C.c_double
lib.fndsa_vect_inv_mul2e_fft.argtypes=[C.c_uint,C.POINTER(FXR),C.c_uint]
lib.fndsa_vect_inv_mul2e_fft_fp64.argtypes=[C.c_uint,C.POINTER(C.c_double),C.c_uint]
summary=[]
for r in json.loads((OUT/'summary.json').read_text()):
    key=r['case'];ctx=r['first_numeric_difference']['context'];l=ctx['logn'];n=1<<l
    streams=[[json.loads(s) for s in (OUT/(key+'-'+b+'.jsonl')).read_text().splitlines()] for b in ('reference','q32_trial')]
    def pick(stream,stage):
        return next(x for x in stream if x.get('stage')==stage and x.get('attempt')==ctx['attempt'] and x.get('depth')==ctx['depth'] and x.get('iteration')==0)
    qrow=pick(streams[0],'FFT_f');drow=pick(streams[1],'FFT_f');e=pick(streams[0],'input_f')['e']
    qi=[int(v,16) for v in qrow['bits']];di=[decode(v) for v in drow['bits']]
    q=(FXR*n)(*[FXR(x) for x in qi]);d=(C.c_double*n)(*di)
    lib.fndsa_vect_inv_mul2e_fft(l,q,e);lib.fndsa_vect_inv_mul2e_fft_fp64(l,d,e)
    assert [f'{x.v:016x}' for x in q]==pick(streams[0],'inverse')['bits']
    assert [f'{bits(x):016x}' for x in d]==pick(streams[1],'inverse')['bits']
    events=[]
    def op(name,label,x,y=None,dx=None,dy=None):
        if name=='sqr':z=lib.diag_fixed_sqr(x);dz=lib.diag_trial_mul(dx,dx);y=x;dy=dx
        elif name=='scale':z=lib.diag_fixed_scale(x,e);dz=lib.diag_trial_scale(dx,e)
        else:z=getattr(lib,'diag_fixed_'+name)(x,y);dz=getattr(lib,'diag_trial_'+name)(dx,dy)
        exact=F(signed(z),B);got=F(dz)
        row=dict(operation=name,label=label,e=e,x=f'{x:016x}',y=None if y is None else f'{y:016x}',
            dx=f'{bits(dx):016x}',dy=None if dy is None else f'{bits(dy):016x}',fixed=f'{z:016x}',trial=f'{bits(dz):016x}',
            operands_same_exact=(F(signed(x),B)==F(dx) and (y is None or F(signed(y),B)==F(dy))),
            error_raw_units=str((got-exact)*B),different=got!=exact,
            fixed_result_representable=F(float(exact))==exact,trial_is_nearest_fixed=float(exact)==dz)
        if name=='div' and y:
            exact_ratio=F(signed(x),signed(y));normal=lib.diag_normal_div(dx,dy)
            numerator=abs(signed(x))*B;den=abs(signed(y));quo,rem=divmod(numerator,den)
            rounded=(quo+(2*rem>=den))*(-1 if (signed(x)<0)!=(signed(y)<0) else 1)
            row.update(exact_ratio=str(exact_ratio),normal_div_bits=f'{bits(normal):016x}',
                       normal_div_is_correctly_rounded=normal==float(F(dx)/F(dy)),
                       exact_integer_rounded_raw=f'{rounded&MASK:016x}',
                       fixed_agrees_exact_rational=z==(rounded&MASK),
                       division_rounding_remainder=str(rem),division_denominator=str(den))
            assert row['fixed_agrees_exact_rational']
        events.append(row);return z,dz
    for j in range(n//2):
        re,im=qi[j],(-qi[j+n//2])&MASK;dre,dim=di[j],-di[j+n//2]
        s0,t0=op('sqr',f'pair{j}.re_squared',re,dx=dre)
        s1,t1=op('sqr',f'pair{j}.im_squared',im,dx=dim)
        z,dz=op('add',f'pair{j}.norm',s0,s1,t0,t1)
        nr,ndr=op('scale',f'pair{j}.scaled_re',re,dx=dre)
        rr,dr=op('div',f'pair{j}.real_div',nr,z,ndr,dz)
        ni,ndi=op('scale',f'pair{j}.scaled_im',im,dx=dim)
        ri,dri=op('div',f'pair{j}.imag_div',ni,z,ndi,dz)
        assert rr==q[j].v and ri==q[j+n//2].v and bits(dr)==bits(d[j]) and bits(dri)==bits(d[j+n//2])
    first=next(x for x in events if x['different'])
    row=dict(case=key,context=ctx,e=e,first_primitive=first,events=events)
    (OUT/(key+'-numerical.json')).write_text(json.dumps(row,indent=2)+'\n')
    summary.append(dict(case=key,context=ctx,first_primitive=first))
    print('NUMERICAL_FIRST',key,json.dumps(first),flush=True)
(OUT/'numerical-summary.json').write_text(json.dumps(summary,indent=2)+'\n')
# Independent, small board fixtures: real pipeline-to-k, rejection condition,
# and exact operands of the first numerical primitive.
parts=['/* Frozen PUBLIC failing seeds; generated by failure_trace/numerical.py. */',
       'struct failure_case { const char *name; unsigned logn,e;const uint64_t *f,*F;const int32_t *k; };']
for j,r in enumerate(json.loads((OUT/'summary.json').read_text())):
    f=json.loads((OUT/(r['case']+'-first.json')).read_text())
    for name,data in [('f',f['f_input'][0]['fixed_bits']),('F',f['F_input'][0]['fixed_bits'])]:
        parts.append(f'static const uint64_t fail_{j}_{name}[]={{'+','.join('UINT64_C(0x'+v+')' for v in data)+'};')
    parts.append(f'static const int32_t fail_{j}_k[]={{'+','.join(map(str,f['first_k_difference']['reference']['k']))+'};')
parts.append('static const struct failure_case failure_cases[]={')
for j,r in enumerate(json.loads((OUT/'summary.json').read_text())):
    f=json.loads((OUT/(r['case']+'-first.json')).read_text());q=f['first_k_difference']['reference']
    parts.append('{"%s",%d,%d,fail_%d_f,fail_%d_F,fail_%d_k},'%(r['case'],q['logn'],f['f_input'][0]['e'],j,j,j))
parts+=['};','struct primitive_case { const char *name;unsigned op,e;uint64_t x,y,dx,dy; };',
        'static const struct primitive_case primitive_cases[]={']
for r in summary:
    t=r['first_primitive'];op={'sqr':0,'add':1,'scale':2,'div':3}[t['operation']]
    parts.append('{"%s",%d,%d,%s},'%(r['case'],op,t['e'],','.join('UINT64_C(0x'+(t[k] or '0')+')' for k in ('x','y','dx','dy'))))
parts.append('};')
(ROOT/'validation/generated/failure_cases.h').write_text('\n'.join(parts)+'\n')
