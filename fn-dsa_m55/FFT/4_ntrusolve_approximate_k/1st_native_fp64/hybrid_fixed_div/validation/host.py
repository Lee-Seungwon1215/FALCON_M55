"""Host KAT, full signature checks, targeted UBSan and exact inverse comparison."""
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
logs={}
for label,source in [('ref',BASE),('hybrid',SRC)]:
    objects=[]
    objdir=OUT/label;objdir.mkdir(exist_ok=True)
    for name in NAMES:
        obj=objdir/(name+'.o');objects.append(str(obj))
        san=['-fsanitize=undefined,float-cast-overflow','-fno-sanitize-recover=all'] if name=='kgen_fxp' else []
        subprocess.run(['clang',*FLAGS,*san,'-I'+str(source),'-c',str(source/(name+'.c')),'-o',str(obj)],check=True)
    for test in ('kat_audit','benchmark'):
        exe=OUT/(label+'-'+test)
        subprocess.run(['clang',*FLAGS,'-DBENCH_HOST','-I'+str(source),'-I'+str(ROOT),*objects,str(ROOT/(test+'.c')),'-fsanitize=undefined,float-cast-overflow','-lm','-o',str(exe)],check=True)
        log=OUT/(label+'-'+test+'.log')
        with log.open('w') as out: subprocess.run([str(exe)],stdout=out,stderr=subprocess.STDOUT,check=True)
        logs[label+'-'+test]=log.read_text()
        print(label,test,'PASS',flush=True)
    subprocess.run(['clang',*FLAGS,'-dynamiclib',str(source/'kgen_fxp.c'),'-o',str(OUT/(label+'.dylib'))],check=True)
assert logs['ref-benchmark']==logs['hybrid-benchmark']
assert logs['ref-kat_audit']==logs['hybrid-kat_audit']
libs=[C.CDLL(str(OUT/(label+'.dylib'))) for label in ('ref','hybrid')]
for lib in libs:
    lib.fndsa_vect_FFT.argtypes=[C.c_uint,C.POINTER(C.c_uint64)]
    lib.fndsa_vect_inv_mul2e_fft.argtypes=[C.c_uint,C.POINTER(C.c_uint64),C.c_uint]
rng=random.Random(55564);coeffs=0
for logn in range(1,11):
    n=1<<logn
    for case in range(100):
        # Includes zero polynomials, sparse polynomials and tiny Q32 values.
        values=[rng.randint(-10000,10000)*(1<<rng.randrange(0,21)) & ((1<<64)-1) for _ in range(n)]
        if case<3: values=[0]*n; values[0]=case
        arrays=[(C.c_uint64*n)(*values) for _ in libs]
        e=rng.randrange(0,15)
        for lib,a in zip(libs,arrays):
            lib.fndsa_vect_FFT(logn,a)
            lib.fndsa_vect_inv_mul2e_fft(logn,a,e)
        assert bytes(arrays[0])==bytes(arrays[1]),(logn,case)
        coeffs+=n
changed=[p.name for p in SRC.iterdir() if p.suffix in ('.c','.h','.s') and p.read_bytes()!=(BASE/p.name).read_bytes()]
assert changed==['kgen_fxp.c'],changed
summary=dict(keygen_kat='300/300',signature_kat='PASS',key_relation_range='PASS',normal_verify_tamper='PASS',
    baseline_digests_identical=200,inverse_exact_coefficients=coeffs,changed_crypto_files=changed,
    sanitizer='UBSan + float-cast-overflow on kgen_fxp.c only, linked into KAT and 200 key/sign/verify runs; not whole-program coverage',
    source={p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in SRC.iterdir() if p.suffix in ('.c','.h','.s')})
(OUT/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
print(json.dumps({k:v for k,v in summary.items() if k!='source'},indent=2))
