#!/usr/bin/env python3
"""Host correctness only: no host timings are reported as M55 performance."""
import ctypes as C
from decimal import Decimal as D, localcontext, ROUND_FLOOR
import hashlib
import json
import math
from pathlib import Path
import random
import re
import subprocess

ROOT = Path(__file__).resolve().parent
SOURCE = ROOT.parent
BASE = SOURCE.parent / 'ref'
BUILD = ROOT / 'build/host'
NAMES = 'codec mq sha3 sysrng util kgen kgen_fxp kgen_gauss kgen_mp31 kgen_ntru kgen_poly kgen_zint31 sign sign_core sign_fpoly sign_fpr sign_sampler vrfy'.split()
FLAGS = ['-O3', '-ffp-contract=off', '-fno-fast-math', '-fno-strict-aliasing', '-DFNDSA_AVX2=0']


def build():
    BUILD.mkdir(parents=True, exist_ok=True)
    for label, source in [('ref', BASE), ('fp64', SOURCE)]:
        sources = [str(source / (n + '.c')) for n in NAMES]
        command = ['clang', *FLAGS, '-I' + str(source), *sources]
        subprocess.run([*command, str(ROOT / 'kat_audit.c'), '-lm', '-o', str(BUILD / ('kat-' + label))], check=True)
        with (BUILD / ('kat-' + label + '.log')).open('w') as out:
            r = subprocess.run([str(BUILD / ('kat-' + label))], stdout=out, stderr=subprocess.STDOUT)
        print(label, 'KAT audit exit', r.returncode, flush=True)
        log = (BUILD / ('kat-' + label + '.log')).read_text()
        known_kat_failure = r.returncode == 1 and 'KEY_KAT_SUMMARY' in log and 'KAT-hash: wrong value' in log
        if r.returncode not in (0, 2) and not known_kat_failure:
            raise RuntimeError('structural KAT/signature failure: ' + label)
        if label == 'fp64':
            subprocess.run([*command, str(ROOT / 'wrappers.c'), '-dynamiclib', '-lm', '-o', str(BUILD / 'libfp64.dylib')], check=True)


class FXR(C.Structure):
    _fields_ = [('v', C.c_uint64)]


def signed(x):
    return x - (1 << 64) if x >> 63 else x


def roots():
    text = (SOURCE / 'kgen_fxp.c').read_text()
    values = re.findall(r'FXC\(\s*(\d+)ull,\s*(\d+)ull\)', text)
    assert len(values) == 1024
    return [(D(signed(int(a))) / (1 << 32), D(signed(int(b))) / (1 << 32)) for a, b in values]


def mul(x, y):
    a = x[0] * y[0]
    b = x[1] * y[1]
    c = (x[0] + x[1]) * (y[0] + y[1])
    return a - b, c - (a + b)


def fft(a, gm, inverse=False):
    n = len(a); hn = n // 2; logn = n.bit_length() - 1
    if not inverse:
        t = hn
        for lm in range(1, logn):
            m = 1 << lm; ht = t // 2
            for i in range(m // 2):
                for j in range(i * t, i * t + ht):
                    x = a[j], a[j + hn]
                    y = mul(gm[m+i], (a[j+ht], a[j+ht+hn]))
                    a[j], a[j+hn] = x[0]+y[0], x[1]+y[1]
                    a[j+ht], a[j+ht+hn] = x[0]-y[0], x[1]-y[1]
            t = ht
    else:
        ht = 1
        for lm in range(logn-1, 0, -1):
            m = 1 << lm; t = 2 * ht
            for i in range(m // 2):
                s = gm[m+i][0], -gm[m+i][1]
                for j in range(i*t, i*t+ht):
                    x = a[j], a[j+hn]; y = a[j+ht], a[j+ht+hn]
                    a[j], a[j+hn] = (x[0]+y[0])/2, (x[1]+y[1])/2
                    a[j+ht], a[j+ht+hn] = mul(s, ((x[0]-y[0])/2, (x[1]-y[1])/2))
            ht = t


def lowlevel():
    lib = C.CDLL(str(BUILD / 'libfp64.dylib'))
    dp = C.POINTER(C.c_double); xp = C.POINTER(FXR)
    for name in ['FFT', 'iFFT']:
        getattr(lib, 'fndsa_vect_'+name+'_fp64').argtypes = [C.c_uint, dp]
        getattr(lib, 'fndsa_vect_'+name).argtypes = [C.c_uint, xp]
    lib.fndsa_poly_big_to_fp64.argtypes = [C.c_uint, dp, C.POINTER(C.c_uint32), C.c_size_t, C.c_uint32]
    lib.fndsa_poly_big_to_fixed.argtypes = [C.c_uint, xp, C.POINTER(C.c_uint32), C.c_size_t, C.c_uint32]
    lib.fndsa_vect_inv_mul2e_fft_fp64.argtypes = [C.c_uint, dp, C.c_uint]
    lib.fndsa_vect_inv_mul2e_fft.argtypes = [C.c_uint, xp, C.c_uint]
    lib.fndsa_vect_mul_fft_fp64.argtypes = [C.c_uint, dp, dp]
    lib.fndsa_vect_mul_fft.argtypes = [C.c_uint, xp, xp]
    lib.validation_round.argtypes = [C.c_double]; lib.validation_round.restype = C.c_int32
    lib.validation_checked_round.argtypes=[C.c_double,C.POINTER(C.c_uint32)]
    lib.validation_checked_round.restype=C.c_int32
    lib.validation_update_ok.argtypes=[C.c_uint,C.POINTER(C.c_int32)]
    lib.validation_update_ok.restype=C.c_uint32
    update_cases=0
    for logn in range(1,11):
        n=1<<logn
        limit=2147483647>>logn
        for value in [-2147483648,-limit-1,-limit,0,limit,limit+1,2147483647]:
            values=(C.c_int32*n)(*[value]*n)
            assert lib.validation_update_ok(logn,values)==int(logn>3 or -limit<=value<=limit)
            update_cases+=1
    for x in [math.inf,-math.inf,math.nan,2147483647.5,2147483648.0,-2147483649.0,1e300,-1e300]:
        valid=C.c_uint32(1)
        assert lib.validation_checked_round(x,C.byref(valid))==0 and valid.value==0
    rng = random.Random(20260918)
    count_round = 0
    for t in [-2147483648, -100000, -3, -2, -1, 0, 1, 2, 3, 100000, 2147483646]:
        for v in [float(t), t+0.5, math.nextafter(t+0.5, -math.inf), math.nextafter(t+0.5, math.inf)]:
            want = int((D(v) + D('0.5')).to_integral_value(rounding=ROUND_FLOOR))
            assert lib.validation_round(v) == want, ('round', v, want)
            count_round += 1
    for _ in range(10000):
        v = rng.uniform(-2147483648, 2147483647)
        assert lib.validation_round(v) == int((D(v)+D('0.5')).to_integral_value(rounding=ROUND_FLOOR))
        count_round += 1
    conversions = 0
    for logn in range(1, 11):
        n = 1 << logn
        for length in [0, 1, 2, 3, 7]:
            for sc in [0, 1, 30, 31, 32, 61, 62, 63, 95, 130, 230]:
                src = (C.c_uint32 * max(1, n*length))(*[rng.getrandbits(31) for _ in range(max(1,n*length))])
                a = (C.c_double*n)(); b = (FXR*n)()
                lib.fndsa_poly_big_to_fp64(logn, a, src, length, sc)
                lib.fndsa_poly_big_to_fixed(logn, b, src, length, sc)
                for x, y in zip(a,b):
                    assert x == float(D(signed(y.v)) / (1 << 32)), ('conversion',logn,length,sc)
                conversions += n
    errors = []
    gm = roots()
    for logn in range(1, 11):
        n = 1 << logn
        for case in range(4):
            values = [rng.randint(-2000,2000)/(1 << case) for _ in range(n)]
            a = (C.c_double*n)(*values)
            b = (FXR*n)(*[FXR(int(x*(1 << 32)) & ((1 << 64)-1)) for x in values])
            oracle = list(map(D, values))
            fft(oracle, gm)
            lib.fndsa_vect_FFT_fp64(logn,a); lib.fndsa_vect_FFT(logn,b)
            ef = max(abs(D(x)-y) for x,y in zip(a,oracle))
            eq = max(abs(D(signed(x.v))/(1 << 32)-y) for x,y in zip(b,oracle))
            assert ef < D('1e-8'), ('FFT',logn,ef)
            fft(oracle, gm, True)
            lib.fndsa_vect_iFFT_fp64(logn,a); lib.fndsa_vect_iFFT(logn,b)
            ei = max(abs(D(x)-y) for x,y in zip(a,oracle))
            assert ei < D('1e-9'), ('iFFT',logn,ei)
            errors.append(dict(logn=logn,case=case,fft_fp64=str(ef),fft_fixed=str(eq),ifft_fp64=str(ei)))
    return dict(oracle='Python Decimal 80 decimal digits; same quantized roots and operation graph, not a mathematical error proof', round_cases=count_round, invalid_round_cases=8, update_range_cases=update_cases, conversion_coefficients=conversions, fft_cases=errors)


if __name__ == '__main__':
    build()
    with localcontext() as ctx:
        ctx.prec = 80
        result = lowlevel()
    result['kat'] = {}
    for label in ['ref','fp64']:
        text = (BUILD / ('kat-'+label+'.log')).read_text()
        rows = re.findall(r'KEY_KAT degree=(\d+) seed=(\w+) match=(\d)',text)
        result['kat'][label] = dict(count=len(rows), mismatches=[dict(degree=int(d),seed=s) for d,s,m in rows if m=='0'], signature_kat='FAIL' if 'KAT-hash: wrong value' in text else 'PASS')
        assert 'KEY_KAT_SUMMARY' in text
    (BUILD / 'summary.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({k:v for k,v in result.items() if k!='fft_cases'},indent=2))
