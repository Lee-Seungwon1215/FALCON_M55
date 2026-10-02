#!/usr/bin/env python3
"""Exact arithmetic (independent Python integers), full upstream KAT and signs."""
import ctypes as C
import hashlib,json,random,re,subprocess
from pathlib import Path
ROOT=Path(__file__).resolve().parent;SRC=ROOT.parent;BASE=ROOT.parents[2]/'ref'
OUT=ROOT/'build/host';OUT.mkdir(parents=True,exist_ok=True)
NAMES='codec mq sha3 sysrng util kgen kgen_fxp kgen_gauss kgen_mp31 kgen_ntru kgen_poly kgen_zint31 sign sign_core sign_fpoly sign_fpr sign_sampler vrfy'.split()
FLAGS=['-O3','-ffp-contract=off','-fno-fast-math','-fno-strict-aliasing','-DFNDSA_AVX2=0','-DFNDSA_UNALIGNED_64=0','-DFNDSA_UNALIGNED_16=0']
SAN=['-fsanitize=undefined,float-cast-overflow','-fno-sanitize-recover=all']
def run(cmd):subprocess.run(list(map(str,cmd)),check=True)
def snapshot(p):return {f.name:hashlib.sha256(f.read_bytes()).hexdigest() for f in sorted(p.glob('*.[chs]'))}
preserved={str(p):snapshot(p) for p in (BASE,SRC.parent,SRC.parent/'fp64_final_scaling',SRC.parent/'hybrid_fixed_div',SRC.parent/'fp64_q32_compat')}
run(['clang',*FLAGS,'-dynamiclib','-I'+str(SRC),ROOT/'wrappers.c',*[SRC/(n+'.c') for n in NAMES if n!='kgen_fxp'],'-o',OUT/'exact.dylib'])
lib=C.CDLL(str(OUT/'exact.dylib'))
u64p=C.POINTER(C.c_uint64)
lib.probe_op.argtypes=[C.c_uint,C.c_uint64,C.c_uint64,C.c_uint];lib.probe_op.restype=C.c_uint64
lib.probe_transform.argtypes=[C.c_uint,C.c_uint,u64p,u64p,C.c_uint]
for name in ('FFT','iFFT'):getattr(lib,'fndsa_vect_'+name).argtypes=[C.c_uint,u64p]
lib.fndsa_vect_mul_fft.argtypes=[C.c_uint,u64p,u64p]
lib.fndsa_vect_inv_mul2e_fft.argtypes=[C.c_uint,u64p,C.c_uint]
class Pair(C.Structure):_fields_=[('hi',C.c_double),('lo',C.c_double)]
lib.fndsa_poly_big_to_fixed.argtypes=[C.c_uint,u64p,C.POINTER(C.c_uint32),C.c_size_t,C.c_uint32]
lib.fndsa_poly_big_to_fp64_exact.argtypes=[C.c_uint,C.POINTER(Pair),C.POINTER(C.c_uint32),C.c_size_t,C.c_uint32]
MASK=(1<<64)-1;B=1<<32
signed=lambda x:x-(1<<64) if x>>63 else x
rng=random.Random(20260920)
edge=sorted({0,1,2,3,MASK,*[x for k in range(1,64) for x in ((1<<k)-1,1<<k,(1<<k)+1)]})
count=0
def check(a,b):
    global count
    e=count%15
    want=[(a+b)&MASK,(a-b)&MASK,((signed(a)*signed(b))>>32)&MASK,(-a)&MASK,
          (signed((a+1)&MASK)>>1)&MASK,((a+(1<<31))&MASK)>>32,(a<<e)&MASK]
    for op,w in enumerate(want):assert lib.probe_op(op,a,b,e)==w,(op,hex(a),hex(b),e,w)
    count+=1
for a in edge:
    for b in edge:check(a,b)
for _ in range(1000000):check(rng.getrandbits(64),rng.getrandbits(64))
print('Primitive PASS',count,'pairs,',count*7,'operations',flush=True)
transform=0;inv=0
for l in range(1,11):
    n=1<<l
    for case in range(40):
        values=[rng.getrandbits(64) for _ in range(n)];others=[rng.getrandbits(64) for _ in range(n)]
        if case==0:values=[0]*n
        if case==1:values=[MASK]*n
        a=(C.c_uint64*n)(*values);b=(C.c_uint64*n)(*values);c=(C.c_uint64*n)(*others)
        for op,name in enumerate(('FFT','mul_fft','iFFT')):
            getattr(lib,'fndsa_vect_'+name)(l,a,*([c] if op==1 else []))
            lib.probe_transform(l,op,b,c,0)
            assert bytes(a)==bytes(b),(l,case,name)
            transform+=n
    for case in range(10):
        vals=[(rng.randint(-32,32)<<16)&MASK for _ in range(n)] if case else [0]*n
        a=(C.c_uint64*n)(*vals);lib.fndsa_vect_FFT(l,a)
        b=(C.c_uint64*n)(*a);e=15-l
        lib.fndsa_vect_inv_mul2e_fft(l,a,e);lib.probe_transform(l,3,b,b,e)
        assert bytes(a)==bytes(b),('inv',l,case)
        inv+=n
targeted=[]
for degree,seed in ((512,'test58'),(1024,'test65')):
    rec=json.loads((SRC.parent/'validation/compatibility_repair/build'/f'{degree}-{seed}.json').read_text())
    n=1<<rec['logn'];a=(C.c_uint64*n)(*[int(v,16) for v in rec['raw_F']]);b=(C.c_uint64*n)(*[int(v,16) for v in rec['raw_inverse']])
    for op in range(3):lib.probe_transform(rec['logn'],op,a,b,0)
    assert list(a)==[int(v,16) for v in rec['raw_fixed_x']]
    targeted.append(dict(degree=degree,seed=seed,round=rec['round'],raw_output='bit-exact'))
conv=0
for l in range(1,11):
    n=1<<l
    for length in (0,1,2,3,7):
        for sc in (0,1,30,31,32,61,62,63,95,130,230):
            src=(C.c_uint32*max(1,n*length))(*[rng.getrandbits(31) for _ in range(max(1,n*length))])
            a=(C.c_uint64*n)();b=(Pair*n)()
            lib.fndsa_poly_big_to_fixed(l,a,src,length,sc);lib.fndsa_poly_big_to_fp64_exact(l,b,src,length,sc)
            assert list(a)==[(int(x.hi)<<32)|int(x.lo) for x in b]
            conv+=n
print('Transforms/replay/conversion PASS',transform,inv,conv,flush=True)
logs={}
for label,source in [('ref',BASE),('exact',SRC)]:
    objects=[];objdir=OUT/label;objdir.mkdir(exist_ok=True)
    for name in NAMES:
        obj=objdir/(name+'.o');objects.append(obj)
        extra=SAN if name in ('kgen_fxp','kgen_poly','kgen_ntru') else []
        run(['clang',*FLAGS,*extra,'-I'+str(source),'-c',source/(name+'.c'),'-o',obj])
    for test in ('kat_audit','benchmark','extra_seeds'):
        exe=OUT/(label+'-'+test)
        run(['clang',*FLAGS,'-DBENCH_HOST','-I'+str(source),'-I'+str(ROOT),*objects,ROOT/(test+'.c'),*SAN,'-lm','-o',exe])
        path=OUT/(label+'-'+test+'.log')
        with path.open('w') as out:subprocess.run([str(exe)],stdout=out,stderr=subprocess.STDOUT,check=True)
        logs[label+'-'+test]=path.read_text();print(label,test,'PASS',flush=True)
for test in ('kat_audit','benchmark','extra_seeds'):assert logs['ref-'+test]==logs['exact-'+test],test
for p,want in preserved.items():assert snapshot(Path(p))==want
changed=sorted(p.name for p in SRC.glob('*.[chs]') if p.read_bytes()!=(BASE/p.name).read_bytes())
assert changed==['kgen_fxp.c','kgen_inner.h','kgen_ntru.c','kgen_poly.c']
summary=dict(primitive_pairs=count,primitive_operations=count*7,transform_coefficients=transform,inverse_coefficients=inv,conversion_coefficients=conv,
    targeted_replays=targeted,keygen_kat='300/300',scheme_kat='PASS',key_sign_verify_tamper='PASS',
    upstream_seed_key_signature_digests=200,extra_seed_key_signature_digests=200,changed=changed,
    sanitizer='kgen_fxp/kgen_poly/kgen_ntru TUs: UBSan + float-cast-overflow, no recovery; not full ASM validation',
    source=snapshot(SRC),preserved=preserved)
(OUT/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
print('HOST_ALL_DONE',flush=True)
