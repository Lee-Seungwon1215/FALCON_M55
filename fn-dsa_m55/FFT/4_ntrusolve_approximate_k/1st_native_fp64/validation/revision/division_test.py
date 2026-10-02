#!/usr/bin/env python3
import ctypes as C,json,math,random,struct
from pathlib import Path
ROOT=Path(__file__).resolve().parent
lib=C.CDLL(str(ROOT.parent/'build/host/libfp64.dylib'))
fn=lib.validation_div_normal;fn.argtypes=[C.c_double,C.c_double];fn.restype=C.c_double
bits=lambda x:struct.unpack('<Q',struct.pack('<d',x))[0]
value=lambda x:struct.unpack('<d',struct.pack('<Q',x))[0]
rng=random.Random(20260918);normal=0;rejected=0
for _ in range(200000):
    a=value((rng.getrandbits(1)<<63)|(rng.randint(1,2046)<<52)|rng.getrandbits(52))
    b=value((rng.getrandbits(1)<<63)|(rng.randint(1,2046)<<52)|rng.getrandbits(52))
    expected=a/b;actual=fn(a,b)
    e=(bits(expected)>>52)&2047
    if 0<e<2047:
        assert bits(actual)==bits(expected),(a,b,actual,expected)
        normal+=1
    else:
        assert math.isnan(actual),(a,b,actual)
        rejected+=1
special=0
for a in [0.0,-0.0]:
    for b in [1.0,-1.0,0.5,-0.5,1e100,-1e-100]:
        assert bits(fn(a,b))==bits(a/b);special+=1
for a,b in [(1,0),(0,0),(math.inf,1),(1,math.inf),(math.nan,1),(1,math.nan),(5e-324,1),(1,5e-324)]:
    assert math.isnan(fn(a,b));special+=1
out=dict(normal_exact=normal,unsupported_result_rejected=rejected,special_cases=special)
(ROOT/'division_host.json').write_text(json.dumps(out,indent=2)+'\n')
print(out)
