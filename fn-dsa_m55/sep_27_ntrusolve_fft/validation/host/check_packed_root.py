#!/usr/bin/env python3
"""Actual-table bounds and word-level model of A14's packed root product."""
from pathlib import Path
import hashlib
import random
import re

root = Path(__file__).resolve().parents[2]
src = root / 'A_tw_bridge/kgen_fxp.c'
text = src.read_text().split('static const fxc GM_TAB[1024] = {', 1)[1].split('\n};', 1)[0]
table = [tuple(map(int, pair)) for pair in re.findall(r'FXC\(\s*(\d+)ull,\s*(\d+)ull\)', text)]
fixture = list(map(int, re.findall(r'UINT64_C\((\d+)\)', (root / 'validation/twiddle/table.h').read_text())))
assert len(table) == 1024 and [v for pair in table for v in pair] == fixture
mask32, mask64 = (1 << 32) - 1, (1 << 64) - 1
signed32 = lambda x: x - (1 << 32) if x >> 31 else x
signed64 = lambda x: x - (1 << 64) if x >> 63 else x
edges = [0, 1, mask64, 1 << 63, (1 << 63) - 1, 1 << 32,
         mask32, 1 << 31, (1 << 31) - 1, 0x5555555555555555,
         0xaaaaaaaaaaaaaaaa, 0xffffffff00000000]
def model(x, y):
    xl, xh, yl, yh = x & mask32, x >> 32, y & mask32, y >> 32
    assert yh in (0, mask32)
    hi = ((signed32(xh) * signed32(yl)) >> 32) & mask32
    hi = (hi + (xh if yl >> 31 else 0)) & mask32
    lo = (xl * yl) >> 32
    cross = (xh * yl) & mask32
    lo = (lo + cross) & mask32
    hi = (hi + int(cross > lo)) & mask32
    sublo, subhi = xl & yh, xh & yh
    hi = (hi - subhi - int(sublo > lo)) & mask32
    lo = (lo - sublo) & mask32
    return (hi << 32) | lo
count = 0
used = 0
for lm in range(1, 10):
    for index in range(1 << lm, (1 << lm) + (1 << (lm - 1))):
        used += 1
        for inverse in (0, 1):
            reword, imword = table[index]
            if inverse: imword = (-imword) & mask64
            for y in (reword, imword):
                for x in edges:
                    assert model(x, y) == ((signed64(x) * signed64(y)) >> 32) & mask64
                    count += 1
rng = random.Random(0xA140032)
for _ in range(1000000):
    x = rng.getrandbits(64)
    y = rng.getrandbits(32) | ((mask32 if rng.getrandbits(1) else 0) << 32)
    assert model(x, y) == ((signed64(x) * signed64(y)) >> 32) & mask64
    count += 1
print('GM_SHA256', hashlib.sha256(src.read_bytes()).hexdigest())
print(f'ROOT_BOUND_DONE roots={used} directions=2 components=2 high_words=0,-1 fixture_match=1')
print(f'ROOT_MODEL_DONE cases={count} failures=0')
