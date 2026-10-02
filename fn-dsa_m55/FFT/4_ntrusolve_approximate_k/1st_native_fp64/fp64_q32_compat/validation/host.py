"""Exact multiplication, transform differential, original KAT and signature tests."""
import ctypes as C
import hashlib
import json
from pathlib import Path
import random
import subprocess
ROOT=Path(__file__).resolve().parent
SRC=ROOT.parent
BASE=ROOT.parents[2]/'ref'
OUT=ROOT/'build/host'
OUT.mkdir(parents=True,exist_ok=True)
NAMES='codec mq sha3 sysrng util kgen kgen_fxp kgen_gauss kgen_mp31 kgen_ntru kgen_poly kgen_zint31 sign sign_core sign_fpoly sign_fpr sign_sampler vrfy'.split()
FLAGS=['-O3','-ffp-contract=off','-fno-fast-math','-fno-strict-aliasing','-DFNDSA_AVX2=0','-DFNDSA_UNALIGNED_64=0','-DFNDSA_UNALIGNED_16=0']
(OUT/'wrapper.c').write_text('#include "'+str(SRC/'kgen_fxp.c')+'"\nuint64_t probe_mul(uint64_t x,uint64_t y){return fp64q_mul((fxr){x},(fxr){y}).v;}\nuint32_t probe_hi(uint32_t x,uint32_t y){return fp64q_mul_hi32(x,y);}\n')
subprocess.run(['clang',*FLAGS,'-dynamiclib',str(OUT/'wrapper.c'),'-o',str(OUT/'compat.dylib')],check=True)
lib=C.CDLL(str(OUT/'compat.dylib'))
lib.probe_mul.argtypes=[C.c_uint64,C.c_uint64];lib.probe_mul.restype=C.c_uint64
lib.probe_hi.argtypes=[C.c_uint32,C.c_uint32];lib.probe_hi.restype=C.c_uint32
MASK=(1<<64)-1;B=1<<32
signed=lambda x:x-(1<<64) if x>>63 else x
rng=random.Random(20260919)
edge32=sorted({0,1,2,3,B-1,*[x for k in range(1,32) for x in ((1<<k)-1,1<<k,(1<<k)+1)]})
hi_count=0
def check_hi(a,b):
    global hi_count
    assert lib.probe_hi(a,b)==a*b>>32,(hex(a),hex(b))
    hi_count+=1
for a in edge32:
    for b in edge32:check_hi(a,b)
for _ in range(200000):check_hi(rng.getrandbits(32),rng.getrandbits(32))
# Deliberately force true low words near 0 and near 2^32, where binary64
# rounding can carry across the high-word boundary.
for _ in range(10000):
    a=rng.getrandbits(32)|1;inv=pow(a,-1,B)
    for lo in (0,1,2,511,1023,1024,1025,B-1,B-2,B-511,B-1023,B-1024,B-1025):
        check_hi(a,(inv*lo)&(B-1))
edge64=sorted({0,1,2,3,MASK,*[x for k in range(1,64) for x in ((1<<k)-1,1<<k,(1<<k)+1)]})
mul_count=0
def check_mul(a,b):
    global mul_count
    assert lib.probe_mul(a,b)==((signed(a)*signed(b))>>32)&MASK,(hex(a),hex(b))
    mul_count+=1
for a in edge64:
    for b in edge64:check_mul(a,b)
for _ in range(1000000):check_mul(rng.getrandbits(64),rng.getrandbits(64))
for suffix in ('','_fp64q'):
    for name in ('FFT','iFFT'):
        getattr(lib,'fndsa_vect_'+name+suffix).argtypes=[C.c_uint,C.POINTER(C.c_uint64)]
    getattr(lib,'fndsa_vect_mul_fft'+suffix).argtypes=[C.c_uint,C.POINTER(C.c_uint64),C.POINTER(C.c_uint64)]
transform_coeffs=0
for l in range(1,11):
    n=1<<l
    for case in range(40):
        values=[rng.getrandbits(64) for _ in range(n)]
        others=[rng.getrandbits(64) for _ in range(n)]
        if case<len(edge64):values[0]=edge64[case]
        a=(C.c_uint64*n)(*values);b=(C.c_uint64*n)(*values);c=(C.c_uint64*n)(*others)
        for name,args in [('FFT',[]),('mul_fft',[c]),('iFFT',[])]:
            getattr(lib,'fndsa_vect_'+name)(l,a,*args)
            getattr(lib,'fndsa_vect_'+name+'_fp64q')(l,b,*args)
            assert bytes(a)==bytes(b),(l,case,name)
            transform_coeffs+=n
targeted=[]
for degree,seed in ((512,'test58'),(1024,'test65')):
    rec=json.loads((SRC.parent/'validation/compatibility_repair/build'/f'{degree}-{seed}.json').read_text())
    n=1<<rec['logn']
    a=(C.c_uint64*n)(*[int(v,16) for v in rec['raw_F']])
    b=(C.c_uint64*n)(*[int(v,16) for v in rec['raw_inverse']])
    lib.fndsa_vect_FFT_fp64q(rec['logn'],a)
    lib.fndsa_vect_mul_fft_fp64q(rec['logn'],a,b)
    lib.fndsa_vect_iFFT_fp64q(rec['logn'],a)
    assert list(a)==[int(v,16) for v in rec['raw_fixed_x']],(degree,seed)
    targeted.append(dict(degree=degree,seed=seed,round=rec['round'],raw_output='bit-exact'))
print('Arithmetic PASS',hi_count,mul_count,transform_coeffs,flush=True)
logs={}
for label,source in [('ref',BASE),('compat',SRC)]:
    objects=[];objdir=OUT/label;objdir.mkdir(exist_ok=True)
    for name in NAMES:
        obj=objdir/(name+'.o');objects.append(str(obj))
        san=['-fsanitize=undefined,float-cast-overflow','-fno-sanitize-recover=all'] if name=='kgen_fxp' else []
        subprocess.run(['clang',*FLAGS,*san,'-I'+str(source),'-c',str(source/(name+'.c')),'-o',str(obj)],check=True)
    for test in ('kat_audit','benchmark'):
        exe=OUT/(label+'-'+test)
        subprocess.run(['clang',*FLAGS,'-DBENCH_HOST','-I'+str(source),'-I'+str(ROOT),*objects,str(ROOT/(test+'.c')),'-fsanitize=undefined,float-cast-overflow','-lm','-o',str(exe)],check=True)
        log=OUT/(label+'-'+test+'.log')
        with log.open('w') as out:subprocess.run([str(exe)],stdout=out,stderr=subprocess.STDOUT,check=True)
        logs[label+'-'+test]=log.read_text();print(label,test,'PASS',flush=True)
assert logs['ref-kat_audit']==logs['compat-kat_audit']
assert logs['ref-benchmark']==logs['compat-benchmark']
changed=sorted(p.name for p in SRC.glob('*.[chs]') if p.read_bytes()!=(BASE/p.name).read_bytes())
assert changed==['kgen_fxp.c','kgen_inner.h','kgen_ntru.c']
summary=dict(hi32_pairs=hi_count,q32_pairs=mul_count,transform_coefficients=transform_coeffs,targeted_replays=targeted,
 keygen_kat='300/300',signature_kat='PASS',equation_range_verify_tamper='PASS',matching_key_signature_digests=200,
 changed=changed,sanitizer='kgen_fxp.c TU only: UBSan + float-cast-overflow during KAT and full key/sign/verify',
 source={p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in SRC.glob('*.[chs]')})
(OUT/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
print(json.dumps({k:v for k,v in summary.items() if k!='source'},indent=2))
