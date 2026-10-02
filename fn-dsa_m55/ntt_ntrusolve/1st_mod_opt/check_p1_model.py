#!/usr/bin/env python3
"""Exact model of P1's corrected l=64, alpha=1 Plantard path."""

import json
from pathlib import Path
import random
import re


ROOT = Path(__file__).resolve().parent
SOURCE = ROOT / "P1_original_plantard/kgen_mp31.c"
R32 = 1 << 32
R64 = 1 << 64
R128 = 1 << 128
MASK64 = R64 - 1


def signed(x, modulus):
    x %= modulus
    return x - modulus if x >= modulus // 2 else x


def bit_reverse_10(x):
    return int(f"{x:010b}"[::-1], 2)


def mul64x32(x, y):
    z0 = (x & 0xFFFFFFFF) * y
    z1 = ((x >> 32) & 0xFFFFFFFF) * y
    lo = (z0 + ((z1 << 32) & MASK64)) & MASK64
    hi = (z1 >> 32) + (lo < z0)
    return lo, hi


def mul64lo(x, y):
    z0 = (x & 0xFFFFFFFF) * (y & 0xFFFFFFFF)
    z1 = (((x >> 32) & 0xFFFFFFFF) * (y & 0xFFFFFFFF)
          + (x & 0xFFFFFFFF) * ((y >> 32) & 0xFFFFFFFF)) & 0xFFFFFFFF
    return (z0 + (z1 << 32)) & MASK64


def mmul(a, b, p, p0i):
    z = a * b
    w = (z & 0xFFFFFFFF) * p0i & 0xFFFFFFFF
    d = ((z + w * p) >> 32) - p
    return d + (p if d < 0 else 0)


def init_context(p, p0i):
    x = (-p0i) & 0xFFFFFFFF
    pxlo, _ = mul64x32(x, p)
    x = mul64lo(x, (2 - pxlo) & MASK64)
    pxlo, pxhi = mul64x32(x, p)
    assert pxlo == 1
    inv_hi = (-mul64lo(x, pxhi)) & MASK64
    pinv = x | (inv_hi << 64)
    assert p * pinv % R128 == 1

    r2 = R32 % p
    for _ in range(32):
        r2 = (r2 + r2) % p
    r96 = mmul(r2, r2, p, p0i)
    r128 = mmul(r96, r2, p, p0i)
    assert r128 == R128 % p
    return pinv, p - r128


def prepare(root_mont, p, p0i, pinv, neg_r128):
    b = mmul(root_mont, neg_r128, p, p0i)
    qlo, qhi = pinv & MASK64, pinv >> 64
    lo, carry = mul64x32(qlo, b)
    hi_part, _ = mul64x32(qhi, b)
    hi = (carry + hi_part) & MASK64
    bp = lo | (hi << 64)
    assert bp == b * pinv % R128
    return bp


def plant64_limb(a, bp, p):
    blo, bhi = bp & MASK64, bp >> 64
    _, carry = mul64x32(blo, a)
    hi_part, _ = mul64x32(bhi, a)
    zh = (carry + hi_part) & MASK64
    t = (zh + 2) & MASK64
    tneg = (zh >> 63) & (t >> 63)
    _, high = mul64x32(t, p)
    r = (high - (p if tneg else 0)) & 0xFFFFFFFF
    if r >> 31:
        r = (r + p) & 0xFFFFFFFF
    return r


def plant64_math(a, bp, p):
    z = signed(a * bp, R128)
    return (((z >> 64) + 2) * p >> 64) % p


def main():
    text = SOURCE.read_text().split("const small_prime PRIMES[]", 1)[1]
    rows = [tuple(map(int, row)) for row in re.findall(
        r"\{\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,"
        r"\s*(\d+)\s*,\s*(\d+)\s*\}", text)]
    rows = [row for row in rows if row[0]]
    assert len(rows) == 308

    cases = 0
    rng = random.Random(0x506C616E74617264)
    for p, p0i, _r2, g, ig, _crt in rows:
        assert p < (1 << 62)  # corrected l=64, alpha=1 bound
        pinv, neg_r128 = init_context(p, p0i)
        rinv = pow(R32, -1, p)
        for step, start in ((g * rinv % p, R32 % p),
                            (ig * rinv % p, (R32 // 2) % p)):
            roots = [0] * 1024
            root = start
            for i in range(1024):
                roots[bit_reverse_10(i)] = root
                root = root * step % p
            for root_mont in roots:
                bp = prepare(root_mont, p, p0i, pinv, neg_r128)
                w = root_mont * rinv % p
                values = (0, 1, 2, p >> 1, (p >> 1) + 1,
                          p - 3, p - 2, p - 1,
                          *(rng.randrange(p) for _ in range(8)))
                for a in values:
                    actual = plant64_limb(a, bp, p)
                    mathematical = plant64_math(a, bp, p)
                    expected = a * w % p
                    assert actual == mathematical == expected, (
                        p, a, root_mont, actual, mathematical, expected)
                    cases += 1

    print(json.dumps({
        "primes": len(rows),
        "roots_per_direction": 1024,
        "directions": 2,
        "cases": cases,
        "mismatches": 0,
        "word_bits": 64,
        "alpha": 1,
        "arm_execution": False,
    }, indent=2))


if __name__ == "__main__":
    main()
