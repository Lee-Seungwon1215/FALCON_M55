#!/usr/bin/env python3
"""Independent IEEE-floor boundary test of the project's actual helper."""
import ctypes as C
import hashlib,json,math,random,struct,subprocess
from pathlib import Path
ROOT=Path(__file__).resolve().parent.parent
OUT=ROOT/'build/floor-probe';OUT.mkdir(exist_ok=True)
subprocess.run(['clang','-O3','-DFNDSA_AVX2=0','-ffp-contract=off','-fno-fast-math',
               '-I'+str(ROOT/'q32_trial'),'-dynamiclib',str(ROOT/'validation/floor_probe.c'),
               '-o',str(OUT/'probe.dylib')],check=True)
lib=C.CDLL(str(OUT/'probe.dylib'));lib.audit_floor.argtypes=[C.c_double];lib.audit_floor.restype=C.c_double
rng=random.Random(20260923)
values=[struct.unpack('d',struct.pack('Q',rng.getrandbits(64)))[0] for _ in range(100000)]
for p in range(-1074,1024):
    x=math.ldexp(1.0,p)
    for y in (x,-x):values += [y,math.nextafter(y,-math.inf),math.nextafter(y,math.inf)]
values += [0.0,-0.0,math.inf,-math.inf,math.nan]
for x in values:
    got=lib.audit_floor(x)
    if math.isnan(x): assert math.isnan(got)
    else:
        want=x if not math.isfinite(x) or x==0 else float(math.floor(x))
        if want==0:want=math.copysign(0.0,x)
        assert struct.pack('d',got)==struct.pack('d',want),(x,got,want)
data=dict(cases=len(values),mismatches=0,
          header_sha256=hashlib.sha256((ROOT/'q32_trial/kgen_inner.h').read_bytes()).hexdigest())
lib.audit_divzero.argtypes=[C.c_double];lib.audit_divzero.restype=C.c_double
zero_values=[rng.randrange(-(1<<63),(1<<63)) for _ in range(100000)]
zero_values += [v+d for v in (0,1<<30,1<<31,1<<32,1<<62) for d in (-2,-1,0,1,2)]
for raw in zero_values:
    x=float(raw)*2**-32
    represented=int(x*2**32)
    want=-((abs(represented)+(1<<30))>>31)
    if represented<0:want=-want
    assert lib.audit_divzero(x)==want*2**-32,(raw,x,want,lib.audit_divzero(x))
data['zero_divisor_cases']=len(zero_values);data['zero_divisor_mismatches']=0
(OUT/'summary.json').write_text(json.dumps(data,indent=2)+'\n');print(data)
