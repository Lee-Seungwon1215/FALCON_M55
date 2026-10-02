#!/usr/bin/env python3
"""Exact model and range audit for original Plantard with l = 32.

This is deliberately independent from the candidate implementations.  It
parses the 308 FN-DSA RNS primes from the preserved M1-improve source, builds
the same Montgomery root tables, and compares original Plantard multiplication
and complete transforms with the baseline Montgomery arithmetic.
"""

import json
from pathlib import Path
import re


ROOT = Path(__file__).resolve().parent
SOURCE = ROOT / "M1_improve/kgen_mp31.c"
R = 1 << 32
R2 = 1 << 64
MASK32 = R - 1
MASK64 = R2 - 1


def parse_primes():
    text = SOURCE.read_text().split("const small_prime PRIMES[]", 1)[1]
    rows = [tuple(map(int, row)) for row in re.findall(
        r"\{\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,"
        r"\s*(\d+)\s*,\s*(\d+)\s*\}", text)]
    rows = [row for row in rows if row[0]]
    assert len(rows) == 308
    return rows


def bit_reverse_10(x):
    y = 0
    for _ in range(10):
        y = (y << 1) | (x & 1)
        x >>= 1
    return y


def montgomery(a, b, p, p0i):
    z = a * b
    w = ((z & MASK32) * p0i) & MASK32
    d = ((z + w * p) >> 32) - p
    return d + (p if d < 0 else 0)


def add_mod(a, b, p):
    d = a + b - p
    return d + (p if d < 0 else 0)


def sub_mod(a, b, p):
    d = a - b
    return d + (p if d < 0 else 0)


def half_mod(a, p):
    return (a + (p if a & 1 else 0)) >> 1


def plantard_context(p, p0i, table_r2):
    # p0i = -p^-1 mod 2^32.  One Newton step lifts p^-1 to 64 bits.
    pinv = (-p0i) & MASK32
    pinv = (pinv * (2 - p * pinv)) & MASK64
    assert (p * pinv) & MASK64 == 1
    assert table_r2 == R2 % p
    return pinv, (-table_r2) % p


def plantard_prepare(root_mont, p, p0i, pinv, neg_r2):
    # root_mont = w*R.  Montgomery(root_mont,-R^2) = -w*R^2.
    b = montgomery(root_mont, neg_r2, p, p0i)
    bp = (b * pinv) & MASK64
    return bp, b


def plantard_mul(a, bp, p):
    # Algorithm 9: floor(((high32(a*bp mod 2^64)+1)*p)/2^32).
    z = (a * bp) & MASK64
    h = z >> 32
    raw = ((h + 1) * p) >> 32
    assert 0 <= raw <= p
    # The paper permits p as the second representation of zero.  FN-DSA's
    # coefficient contract is canonical [0,p), so map that one value to zero.
    return raw - (p if raw == p else 0), raw


def plantard_mul_mve_lanes(a, bp, p):
    # Exact lane decomposition planned for MVE:
    # high32(low64(a*bp)) = mulh(a,bp_lo)+mul(a,bp_hi) mod 2^32.
    blo = bp & MASK32
    bhi = bp >> 32
    h = (((a * blo) >> 32) + ((a * bhi) & MASK32)) & MASK32
    hp1 = (h + 1) & MASK32
    out = (hp1 * p) >> 32
    # If h was 2^32-1, unsigned hp1 wrapped; mathematical raw is p, whose
    # canonical representation is zero, so the wrapped lane already is exact.
    return out


def make_roots(logn, g, ig, p, p0i):
    n = 1 << logn
    for _ in range(logn, 10):
        g = montgomery(g, g, p, p0i)
        ig = montgomery(ig, ig, p, p0i)
    shift = 10 - logn
    gm = [0] * n
    igm = [0] * n
    x1 = R % p
    x2 = (R >> 1) % p
    for i in range(n):
        j = bit_reverse_10(i << shift)
        gm[j] = x1
        igm[j] = x2
        x1 = montgomery(x1, g, p, p0i)
        x2 = montgomery(x2, ig, p, p0i)
    return gm, igm


def ntt(a, gm, p, multiply):
    n = len(a)
    t = n
    m = 1
    while m < n:
        ht = t >> 1
        for i in range(m):
            s = gm[i + m]
            j0 = i * t
            for j in range(ht):
                k0 = j0 + j
                k1 = k0 + ht
                x0 = a[k0]
                x1 = multiply(a[k1], s)
                a[k0] = add_mod(x0, x1, p)
                a[k1] = sub_mod(x0, x1, p)
        t = ht
        m <<= 1


def intt(a, igm, p, multiply):
    n = len(a)
    t = 1
    m = n >> 1
    while m:
        for i in range(m):
            s = igm[i + m]
            j0 = i * (t << 1)
            for j in range(t):
                k0 = j0 + j
                k1 = k0 + t
                x0 = a[k0]
                x1 = a[k1]
                a[k0] = half_mod(add_mod(x0, x1, p), p)
                a[k1] = multiply(sub_mod(x0, x1, p), s)
        t <<= 1
        m >>= 1


def main():
    rows = parse_primes()
    rng = 0x504C414E
    reduction_cases = 0
    transform_coefficients = 0
    duplicate_zero_outputs = 0
    smallest_p = min(row[0] for row in rows)
    largest_p = max(row[0] for row in rows)

    for prime_index, (p, p0i, table_r2, g, ig, _crt) in enumerate(rows):
        # q < 2^32/phi, checked without floating point.  For x=q/R,
        # x < 1/phi iff x^2+x<1.
        assert p * p + p * R < R2
        assert p < (1 << 31) and p & 1
        assert (p * p0i + 1) & MASK32 == 0
        pinv, neg_r2 = plantard_context(p, p0i, table_r2)
        rinv = pow(R, -1, p)

        gm10, igm10 = make_roots(10, g, ig, p, p0i)
        for roots in (gm10, igm10):
            for root_mont in roots:
                assert 0 < root_mont < p
                bp, b = plantard_prepare(
                    root_mont, p, p0i, pinv, neg_r2)
                w = root_mont * rinv % p
                assert b == (-w * R2) % p
                assert bp == b * pow(p, -1, R2) % R2
                values = [
                    0, 1, 2, p >> 1, (p >> 1) + 1,
                    p - 3, p - 2, p - 1, p,
                ]
                for _ in range(8):
                    rng = (rng * 1664525 + 1013904223) & MASK32
                    values.append(rng % p)
                for a in values:
                    actual, raw = plantard_mul(a, bp, p)
                    expected = (a * w) % p
                    assert actual == expected, (
                        "reduction", prime_index, p, a, root_mont,
                        actual, expected)
                    assert plantard_mul_mve_lanes(a, bp, p) == expected
                    duplicate_zero_outputs += raw == p
                    reduction_cases += 1

        for logn in range(4, 11):
            n = 1 << logn
            gm, igm = make_roots(logn, g, ig, p, p0i)
            source = []
            for j in range(n):
                if j < 8:
                    source.append((0, 1, 2, p >> 1,
                                   (p >> 1) + 1, p - 3, p - 2, p - 1)[j])
                else:
                    rng = (rng * 1664525 + 1013904223) & MASK32
                    source.append(rng % p)

            ref = source.copy()
            got = source.copy()
            ntt(ref, gm, p,
                lambda a, s: montgomery(a, s, p, p0i))
            cache = {}

            def pmul(a, s):
                bp = cache.get(s)
                if bp is None:
                    bp = plantard_prepare(s, p, p0i, pinv, neg_r2)[0]
                    cache[s] = bp
                return plantard_mul(a, bp, p)[0]

            ntt(got, gm, p, pmul)
            assert got == ref, ("NTT", prime_index, p, logn)
            transform_coefficients += n

            ref_inv = ref.copy()
            got_inv = got.copy()
            intt(ref_inv, igm, p,
                 lambda a, s: montgomery(a, s, p, p0i))
            cache.clear()
            intt(got_inv, igm, p, pmul)
            assert got_inv == ref_inv == source, (
                "iNTT", prime_index, p, logn)
            transform_coefficients += n

    print(json.dumps({
        "algorithm": "original Plantard",
        "word_bits": 32,
        "primes": len(rows),
        "smallest_prime": smallest_p,
        "largest_prime": largest_p,
        "modulus_condition": "p*p + p*2^32 < 2^64",
        "roots_per_direction": 1024,
        "directions": 2,
        "reduction_cases": reduction_cases,
        "duplicate_zero_raw_p": duplicate_zero_outputs,
        "transform_pairs": len(rows) * 7,
        "logn": "4..10",
        "transform_coefficients_compared": transform_coefficients,
        "mismatches": 0,
        "arm_execution": False,
    }, indent=2))


if __name__ == "__main__":
    main()
