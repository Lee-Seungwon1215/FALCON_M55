"""Independent integer oracle and legacy bit loop; sanitizers run in host.py."""
from pathlib import Path
import ctypes as C
import hashlib
import json
import random
import subprocess
ROOT=Path(__file__).resolve().parent
SRC=ROOT.parent
OUT=ROOT/'build/division'
OUT.mkdir(parents=True,exist_ok=True)
(OUT/'wrapper.c').write_text('#include "'+str(SRC/'kgen_fxp.c')+'"\nuint64_t candidate(uint64_t x,uint64_t y) { return fxr_div_fp64_exact(x,y); }\n')
subprocess.run(['clang','-O3','-DFNDSA_AVX2=0','-ffp-contract=off','-fno-fast-math','-fno-strict-aliasing','-dynamiclib',str(OUT/'wrapper.c'),'-o',str(OUT/'divider.dylib')],check=True)
lib=C.CDLL(str(OUT/'divider.dylib'))
for name in ('candidate','fndsa_inner_fxr_div'):
    getattr(lib,name).argtypes=[C.c_uint64,C.c_uint64]
    getattr(lib,name).restype=C.c_uint64
MASK=(1<<64)-1
rng=random.Random(20260918)
cases=[]
edges=sorted({0,1,2,3,(1<<63)-1,1<<63,*[x for k in range(1,63) for x in ((1<<k)-1,1<<k,(1<<k)+1)]})
for a in edges:
    for b in edges:
        if not b or a < (b<<32): cases.append((a,b))
for _ in range(200000):
    b=rng.randrange(1,1<<rng.randrange(1,64))
    a=rng.randrange(min(1<<63,b<<32))
    cases.append((a,b))
# Quotient digit boundaries, ties, and near-ties.
for _ in range(10000):
    b=rng.randrange(1,1<<63)
    q=rng.choice((0,1,2,(1<<32)-2,(1<<32)-1))
    a=(b*q)>>32
    for t in (-1,0,1):
        if 0<=a+t<=1<<63: cases.append((a+t,b))
count=0
for a,b in cases:
    for sa,sb in ((0,0),(1,0),(0,1),(1,1)):
        x=(-a if sa else a)&MASK; y=(-b if sb else b)&MASK
        got=lib.candidate(x,y); old=lib.fndsa_inner_fxr_div(x,y)
        # INT64_MIN always encodes a negative input, regardless of sa/sb.
        sign=(x>>63)^(y>>63)
        if b:
            q,r=divmod(a<<32,b)
            q += 2*r >= b
            want=(-q if sign else q)&MASK
            assert got==want,('oracle',hex(x),hex(y),hex(got),hex(want))
        assert got==old,('legacy',hex(x),hex(y),hex(got),hex(old))
        count+=1
summary=dict(pairs=count,zero_denominator_magnitudes=len(edges),result='PASS',
    source_sha256=hashlib.sha256((SRC/'kgen_fxp.c').read_bytes()).hexdigest(),
    oracle='Python unbounded integers with magnitude rounding; legacy C bit-loop; all four signs',
    domain='|x|,|y|<=2^63; y=0 legacy semantics or |x|<|y|*2^32')
(OUT/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
print(json.dumps(summary,indent=2))
