#!/usr/bin/env python3
"""Read-only crypto-source audit; new host diagnostic artifacts only.

Reuses the project's host tests and previously generated shadow instrumentation,
after checking the latter against today's baseline NTRU source. No board timing
or complete KAT/security certification is implied by this diagnostic.
"""
import ctypes as C
from datetime import datetime, timezone
from decimal import Decimal as D, localcontext, ROUND_FLOOR
from fractions import Fraction
import hashlib
import importlib.util
import json
import math
from pathlib import Path
import random
import struct
import subprocess
import sys

ROOT = Path(__file__).resolve().parent
VALID = ROOT.parent
sys.path.insert(0, str(VALID))
import host

B = 1 << 32
MASK = (1 << 64) - 1
signed = host.signed
OUT = ROOT / 'results' / datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ')
OUT.mkdir(parents=True, exist_ok=False)


def save(name, value):
    (OUT / name).write_text(json.dumps(value, indent=2) + '\n')


def checked_shadow_source():
    text = (host.BASE / 'kgen_ntru.c').read_text()
    start = text.index('solve_NTRU_intermediate(')
    end = text.index('\n#if FNDSA_AVX2', start)
    part = text[start:end]
    for old, new in [
        ('\tvect_FFT(logn, rt3);', '\tshadow_f(logn,rt3,scale_t);\n\tvect_FFT(logn, rt3);'),
        ('\t\tvect_FFT(logn, rt1);', '\t\tshadow_F(logn,rt1);\n\t\tvect_FFT(logn, rt1);'),
        ('\t\t/* k <- round(rt1)', '\t\tshadow_round(logn,depth,rt1);\n\t\t/* k <- round(rt1)')]:
        assert part.count(old) == 1
        part = part.replace(old, new)
    expected = ('#include "kgen_inner.h"\nextern void shadow_f(unsigned,const fxr*,unsigned);\n'
                'extern void shadow_F(unsigned,const fxr*);\n'
                'extern void shadow_round(unsigned,unsigned,const fxr*);\n'
                + text[:start] + part + text[end:])
    path = VALID / 'compatibility_repair/build/shadow_ntru.c'
    assert path.read_text() == expected, 'Stored instrumentation is stale'
    return path


def build():
    sources = [str(host.SOURCE / (n + '.c')) for n in host.NAMES]
    common = ['clang', *host.FLAGS, '-I' + str(host.SOURCE)]
    subprocess.run([*common, *sources, str(VALID / 'wrappers.c'), str(ROOT / 'wrappers.c'),
                    '-dynamiclib', '-lm', '-o', str(OUT / 'libfp64.dylib')], check=True)
    shadow_ntru = checked_shadow_source()
    sources = [s for s in sources if not s.endswith('/kgen_ntru.c')]
    shadow = VALID / 'compatibility_repair/build/shadow.c'
    for fixed_inverse in (0, 1):
        subprocess.run([*common, '-DSHADOW_FIXED_INVERSE=' + str(fixed_inverse),
                        *sources, str(shadow_ntru), str(shadow), '-lm', '-o',
                        str(OUT / ('shadow' + str(fixed_inverse)))], check=True)


def boundary_tests(lib):
    # Test the ACTUAL poly_big_to_fp64 implementation, including negative raw
    # words and boundaries across 32-bit words, not a copy of its expression.
    rng = random.Random(20260923)
    words = [0, 1, 2, 0x7fffffff, 0x80000000, 0xfffffffe, 0xffffffff]
    raw_values = [(hi << 32) | lo for hi in words for lo in words]
    raw_values += [rng.getrandbits(64) for _ in range(10001)]
    losses = 0
    for raw in raw_values:
        v = signed(raw)
        big = v & ((1 << 93) - 1)
        # logn=1, two identical coefficients, three signed base-2^31 limbs.
        src = (C.c_uint32 * 6)(*[((big >> (31*j)) & 0x7fffffff)
                                  for j in range(3) for _ in range(2)])
        fp = (C.c_double * 2)()
        fx = (host.FXR * 2)()
        lib.fndsa_poly_big_to_fp64(1, fp, src, 3, 32)
        lib.fndsa_poly_big_to_fixed(1, fx, src, 3, 32)
        want = float(Fraction(v, B))
        assert fx[0].v == fx[1].v == raw
        assert fp[0] == fp[1] == want
        losses += int(Fraction.from_float(fp[0]) != Fraction(v, B))
    lib.validation_div_normal.argtypes = [C.c_double, C.c_double]
    lib.validation_div_normal.restype = C.c_double
    division_cases = []
    for _ in range(10000):
        x = math.ldexp(rng.uniform(1, 2), rng.randint(-400, 400))
        y = math.ldexp(rng.uniform(1, 2), rng.randint(-400, 400))
        division_cases.append((rng.choice((-x, x)), rng.choice((-y, y))))
    division_cases += [(x, y) for x in (0.0, -0.0) for y in (1.0, -1.0, 2.0, -2.0)]
    for x, y in division_cases:
        assert struct.pack('d', lib.validation_div_normal(x, y)) == struct.pack('d', x / y)
    ptr = C.POINTER(C.c_double)
    lib.audit_complex_mul.argtypes = [ptr, ptr, ptr]
    for re, im in [(1.75, 2.5), (-1.75, 2.5), (B - 1, B - 2)]:
        x = (C.c_double * 2)(re, im)
        for yr, yi, want in [(1.0, 0.0, (re, im)), (0.0, 1.0, (-im, re))]:
            y = (C.c_double * 2)(yr, yi); z = (C.c_double * 2)()
            lib.audit_complex_mul(x, y, z)
            assert tuple(z) == want
    return dict(raw_word_conversion_values=len(raw_values),
                conversion_mismatches=0, correctly_rounded_but_not_exact=losses,
                normalized_division_cases=len(division_cases), division_mismatches=0,
                complex_identity_and_i_cases=6)


def shadow_cases():
    cases = json.loads((VALID / 'build/host/summary.json').read_text())['kat']['fp64']['mismatches']
    summary = []
    for case in cases:
        row = json.loads(subprocess.check_output([str(OUT / 'shadow0'),
                         str(case['degree'].bit_length()-1), case['seed']], text=True))
        assert row['differences'] > 0
        row.update(case)
        with localcontext() as ctx:
            ctx.prec = 80
            f = [D(signed(int(v, 16))) / B for v in row['raw_f']]
            a = [D(signed(int(v, 16))) / B for v in row['raw_F']]
            # Audit whether the shadow's input conversion lost ANY bits.
            input_losses = sum(D(float.fromhex(v)) != exact
                               for key, exacts in [('f', f), ('F', a)]
                               for v, exact in zip(row[key], exacts))
            gm = host.roots(); host.fft(f, gm); hn = len(f) // 2
            for i in range(hn):
                re, im = f[i], -f[i+hn]; z = re*re + im*im
                f[i] = re * (D(2)**row['e']) / z
                f[i+hn] = im * (D(2)**row['e']) / z
            host.fft(a, gm)
            for i in range(hn):
                a[i], a[i+hn] = host.mul((a[i], a[i+hn]), (f[i], f[i+hn]))
            host.fft(a, gm, True)
            rnd = lambda x: int((x+D('0.5')).to_integral_value(rounding=ROUND_FLOOR))
            oracle = [rnd(x) for x in a]
            native = [rnd(D(float.fromhex(v))) for v in row['fp64_x']]
            row['oracle_k'] = oracle
            row['input_conversion_losses'] = input_losses
            row['fp64_oracle_k_differences'] = sum(x != y for x, y in zip(oracle, native))
            row['oracle_max_error'] = str(max(abs(x-D(float.fromhex(y))) for x, y in zip(a, row['fp64_x'])))
        save(f"{case['degree']}-{case['seed']}.json", row)
        compact = {k: row[k] for k in ('degree','seed','round','logn','depth','differences',
                    'fixed_inverse_residual','input_conversion_losses','fp64_oracle_k_differences')}
        summary.append(compact)
        print(compact, flush=True)
    return summary


def detailed_test43(lib):
    row = json.loads((OUT / '512-test43.json').read_text())
    lib.audit_fixed_sqr.argtypes = [C.c_uint64]; lib.audit_fixed_sqr.restype = C.c_uint64
    lib.audit_fixed_mul.argtypes = [C.c_uint64, C.c_uint64]
    lib.audit_fixed_mul.restype = C.c_uint64
    f = [signed(int(v, 16)) for v in row['raw_f']]
    q = (host.FXR * len(f))(*[host.FXR(v & MASK) for v in f])
    lib.fndsa_vect_FFT(row['logn'], q)
    hn = len(f)//2
    j = min(range(hn), key=lambda i: float.fromhex(row['fixed_z'][i]))
    re, im = signed(q[j].v), signed(q[j+hn].v)
    squares = []
    for raw in (re, im):
        quotient, remainder = divmod(raw*raw, B)
        got = lib.audit_fixed_sqr(raw & MASK)
        assert got == quotient & MASK
        squares.append(dict(raw_operand=raw, full_product=str(raw*raw),
                            raw_quotient=quotient, discarded_remainder=remainder,
                            compiled_fixed_result=got))
    # The very first forward FFT primitive, same input, has a discarded
    # fractional remainder. Verify full multiplication before truncation.
    root = 3037000500
    operand = f[1]  # logn=2: ht=1, first butterfly y.re
    quotient, remainder = divmod(root*operand, B)
    assert lib.audit_fixed_mul(root, operand & MASK) == quotient & MASK
    shared_products = []
    for label, operand2 in [('ac', f[1]), ('bd', f[1+hn])]:
        qr, rr = divmod(root*operand2, B)
        assert lib.audit_fixed_mul(root, operand2 & MASK) == qr & MASK
        native = (root/B) * (operand2/B)
        shared_products.append(dict(operation=label, twiddle_raw=root,
                                    operand_raw=operand2, fixed_raw=qr,
                                    discarded_remainder=rr, fixed_value=qr/B,
                                    native_value=native,
                                    equal_binary64_value=native == qr/B,
                                    difference_in_raw_units=str(Fraction(native)*B-qr)))
    return dict(complex_index=j, squares=squares,
                fixed_denominator_raw=sum(s['raw_quotient'] for s in squares),
                exact_sum_of_squares_of_fixed_fft= str(Fraction(re*re+im*im, B*B)),
                fixed_denominator=float.fromhex(row['fixed_z'][j]),
                native_denominator=float.fromhex(row['fp64_z'][j]),
                first_fft_mul=dict(twiddle_raw=root, operand_raw=operand,
                                   full_product=str(root*operand), result_raw=quotient,
                                   discarded_remainder=remainder,
                                   discarded_value=str(Fraction(remainder, B*B))),
                first_butterfly_shared_products=shared_products,
                fixed_x=[float.fromhex(x) for x in row['fixed_x']],
                native_x=[float.fromhex(x) for x in row['fp64_x']],
                oracle_k=row['oracle_k'])


def later_residuals(lib):
    # Reuse the existing exact integer model for two later divergences even
    # after replacing the inverse-preparation output with the fixed result.
    spec = importlib.util.spec_from_file_location('compat_trace', VALID/'compatibility_repair/trace.py')
    model = importlib.util.module_from_spec(spec); spec.loader.exec_module(model)
    with localcontext() as ctx:
        ctx.prec = 80
        gm = [(int(a*B), int(b*B)) for a, b in host.roots()]
    summaries = []
    for degree, seed in [(512, 'test58'), (1024, 'test65')]:
        row = json.loads(subprocess.check_output([str(OUT/'shadow1'),str(degree.bit_length()-1),seed],text=True))
        n = 1 << row['logn']; a = [signed(int(x,16)) for x in row['raw_F']]
        b = [signed(int(x,16)) for x in row['raw_inverse']]
        m = model.Model(); stages = m.pipeline(a, b, gm)
        ca = (host.FXR*n)(*[host.FXR(x&MASK) for x in a])
        cb = (host.FXR*n)(*[host.FXR(x&MASK) for x in b])
        for stage, func in [('FFT', lambda: lib.fndsa_vect_FFT(row['logn'],ca)),
                            ('pointwise', lambda: lib.fndsa_vect_mul_fft(row['logn'],ca,cb)),
                            ('iFFT', lambda: lib.fndsa_vect_iFFT(row['logn'],ca))]:
            func(); assert [signed(x.v) for x in ca] == stages[stage]
        assert [x&MASK for x in stages['iFFT']] == [int(x,16) for x in row['raw_fixed_x']]
        wraps = [e for e in m.events if e['wrap']]
        row.update(degree=degree,seed=seed,wrap_count=len(wraps),
                   first_wrap=wraps[0] if wraps else None, exact_integer_model_vs_C='PASS')
        save(f'residual-{degree}-{seed}.json', row)
        summaries.append({k:row[k] for k in ('degree','seed','round','depth','logn',
                          'differences','wrap_count','first_wrap','exact_integer_model_vs_C')})
    return summaries


def main():
    sources = list(host.SOURCE.glob('*.[chs]')) + [host.BASE/'kgen_ntru.c']
    hashes = {str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in sources}
    build(); host.BUILD = OUT
    with localcontext() as ctx:
        ctx.prec = 80
        low = host.lowlevel()
    lib = C.CDLL(str(OUT/'libfp64.dylib'))
    # ctypes prototypes were configured on host.lowlevel's own CDLL instance.
    xp = C.POINTER(host.FXR); dp = C.POINTER(C.c_double)
    for name in ('FFT','iFFT'):
        getattr(lib, 'fndsa_vect_'+name).argtypes = [C.c_uint,xp]
    lib.fndsa_vect_mul_fft.argtypes = [C.c_uint,xp,xp]
    lib.fndsa_poly_big_to_fp64.argtypes = [C.c_uint,dp,C.POINTER(C.c_uint32),C.c_size_t,C.c_uint32]
    lib.fndsa_poly_big_to_fixed.argtypes = [C.c_uint,xp,C.POINTER(C.c_uint32),C.c_size_t,C.c_uint32]
    boundary = boundary_tests(lib)
    print('boundary checks',boundary,flush=True)
    cases = shadow_cases()
    detail = detailed_test43(lib)
    residual = later_residuals(lib)
    assert all(hashlib.sha256(Path(p).read_bytes()).hexdigest() == h for p,h in hashes.items())
    result = dict(scope='Fresh host diagnostic, not a new board run or full KAT300 run',
                  crypto_sources_unchanged=True, source_sha256=hashes,
                  lowlevel=low, boundary=boundary, first_k_divergences=cases,
                  detailed_test43=detail, later_fixed_inverse_residuals=residual)
    save('summary.json', result)
    print('PASS', OUT, flush=True)


if __name__ == '__main__':
    main()
