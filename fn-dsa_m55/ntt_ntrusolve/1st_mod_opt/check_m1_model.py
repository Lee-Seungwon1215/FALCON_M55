#!/usr/bin/env python3
"""Exact-integer model, independent modular inverse oracle; not ARM execution."""
import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parent
R, H = 1 << 32, 1 << 31


def signed32(x):
    return ((x + H) & (R - 1)) - H


def main():
    source = ROOT / "M1_rounding_montgomery/kgen_mp31.c"
    text = source.read_text().split("const small_prime PRIMES[]", 1)[1]
    rows = [tuple(map(int, row)) for row in re.findall(
        r"\{\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\}", text)]
    rows = [row for row in rows if row[0]]
    assert len(rows) == 308
    cases = ties = wide = 0
    rng = 0x12345678
    for p, p0i, _r2, g, ig, _crt in rows:
        assert (p * p0i + 1) % R == 0
        invr = pow(R, -1, p)
        gn, ign = g * invr % p, ig * invr % p
        edges = [0, 1, 2, p - 1, p - 2, p >> 1, (p >> 1) + 1,
                 (H >> 1) - 1, H >> 1, (H >> 1) + 1]
        forward, inverse = R % p, H % p
        for _ in range(1024):
            for root in (forward, inverse):
                twist = signed32(root * p0i)
                rng = (rng * 1664525 + 1013904223) & (R - 1)
                for a in (*edges, rng % p):
                    low = signed32(a * twist)
                    hi = (2 * a * root + H) >> 32
                    correction = (2 * low * p + H) >> 32
                    assert -H <= hi < H and -H <= correction < H
                    value = (hi + correction) >> 1
                    assert -p < value < p
                    actual = value + p if value < 0 else value
                    assert actual == a * root * invr % p, (p, a, root)
                    ties += (hi + correction) & 1
                    wide += not (-H <= hi + correction < H)
                    cases += 1
            forward = forward * gn % p
            inverse = inverse * ign % p
    print(json.dumps(dict(primes=len(rows), cases=cases, mismatches=0,
                         rounding_ties=ties, sums_outside_signed32=wide,
                         arm_execution=False), indent=2))


if __name__ == "__main__":
    main()
