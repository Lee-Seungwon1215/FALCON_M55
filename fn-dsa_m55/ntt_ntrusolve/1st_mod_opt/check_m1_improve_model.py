#!/usr/bin/env python3
"""Exact model for M1-improve signed-difference rounding Montgomery."""

import json
from pathlib import Path
import re


ROOT = Path(__file__).resolve().parent
R = 1 << 32
H = 1 << 31


def signed32(x):
    return ((x + H) & (R - 1)) - H


def rounding_montgomery(a, root, p, p0i):
    """Model VMUL, VQRDMULH, VQRDMULH, VHADD and final +p."""
    twist = signed32(root * p0i)
    low = signed32(a * twist)
    high = (2 * a * root + H) >> 32
    correction = (2 * low * p + H) >> 32
    assert -H <= high < H
    assert -H <= correction < H
    value = (high + correction) >> 1
    assert -p < value < p
    actual = value + p if value < 0 else value
    assert 0 <= actual < p
    return actual, high + correction


def main():
    source = ROOT / "M1_improve/kgen_mp31.c"
    text = source.read_text().split("const small_prime PRIMES[]", 1)[1]
    rows = [tuple(map(int, row)) for row in re.findall(
        r"\{\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\}",
        text)]
    rows = [row for row in rows if row[0]]
    assert len(rows) == 308

    canonical_cases = 0
    signed_cases = 0
    ties = 0
    wide = 0
    rng = 0x12345678
    for p, p0i, _r2, g, ig, _crt in rows:
        assert p < H and (p * p0i + 1) % R == 0
        invr = pow(R, -1, p)
        gn = g * invr % p
        ign = ig * invr % p
        forward = R % p
        inverse = H % p
        canonical_edges = (
            0, 1, 2, p - 1, p - 2, p >> 1, (p >> 1) + 1,
            (H >> 1) - 1, H >> 1, (H >> 1) + 1,
        )
        signed_edges = (
            -(p - 1), -(p - 2), -((p >> 1) + 1), -(p >> 1),
            -2, -1, 0, 1, 2, p >> 1, (p >> 1) + 1, p - 2, p - 1,
        )
        for _ in range(1024):
            for root in (forward, inverse):
                rng = (rng * 1664525 + 1013904223) & (R - 1)
                canonical_inputs = (*canonical_edges, rng % p)
                for a in canonical_inputs:
                    actual, rounded_sum = rounding_montgomery(
                        a, root, p, p0i)
                    expected = (a * root * invr) % p
                    assert actual == expected, (p, a, root, actual, expected)
                    ties += rounded_sum & 1
                    wide += not (-H <= rounded_sum < H)
                    canonical_cases += 1

                # These values exercise the exact range produced by a-b with
                # canonical GS inputs.  The random case is also formed as an
                # actual difference instead of sampling an unrelated residue.
                x = rng % p
                rng = (rng * 1664525 + 1013904223) & (R - 1)
                y = rng % p
                for a in (*signed_edges, x - y):
                    actual, rounded_sum = rounding_montgomery(
                        a, root, p, p0i)
                    expected = ((a % p) * root * invr) % p
                    assert actual == expected, (p, a, root, actual, expected)
                    ties += rounded_sum & 1
                    wide += not (-H <= rounded_sum < H)
                    signed_cases += 1

            forward = forward * gn % p
            inverse = inverse * ign % p

    print(json.dumps({
        "primes": len(rows),
        "roots_per_direction": 1024,
        "canonical_cases": canonical_cases,
        "signed_difference_cases": signed_cases,
        "total_cases": canonical_cases + signed_cases,
        "mismatches": 0,
        "rounding_ties": ties,
        "sums_outside_signed32": wide,
        "arm_execution": False,
    }, indent=2))


if __name__ == "__main__":
    main()
