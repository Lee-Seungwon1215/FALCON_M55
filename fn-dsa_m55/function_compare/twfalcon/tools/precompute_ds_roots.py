#!/usr/bin/env python3
"""Offline generation of exact current Q32->DS constants. Not a build step.

--patch emits an apply_patch patch for the checked-in table C file.
--check verifies that file and all original root conversions bit for bit.
"""
import argparse
import hashlib
import re
import struct
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT/'integration_candidate/tw32_gm_q32.c'
DST = ROOT/'integration_candidate/tw32_gm_ds32.c'
def f32(x):
    return struct.unpack('<f', struct.pack('<f', x))[0]
def roots():
    vals = list(map(int, re.findall(r'UINT64_C\((\d+)\)', SRC.read_text())))
    assert len(vals) == 2048
    result = []
    for x in vals:
        signed = x if x < 1 << 63 else x-(1 << 64)
        d = float(signed)*2.0**-32
        h = f32(d)
        lo = f32(d-float(h))
        tail = f32(d-float(h)-float(lo))
        assert h+lo == d and tail == 0.0
        result.append((h, lo, tail))
    return result
def content():
    vals = roots()
    lines = ['/* Offline-generated from tw32_gm_q32.c by tools/precompute_ds_roots.py.',
        ' * Current conversion bits, not freshly computed trigonometric values.',
        ' * Third float is zero ABI padding for the unchanged 12-byte root stride.',
        ' * Binary size: 2 x 1024 x 12 = 24576 bytes. No runtime initialization. */',
        '#include "tw32_gm_ds32.h"', '']
    for part, name in enumerate(('re', 'im')):
        lines.append('const tw_fpr tw_gm_ds32_'+name+'[1024] __attribute__((aligned(16))) = {')
        for triple in vals[part::2]:
            lines.append('    {{ '+', '.join(v.hex()+'f' for v in triple)+' }},')
        lines += ['};', '']
    return '\n'.join(lines)
if __name__ == '__main__':
    p = argparse.ArgumentParser()
    p.add_argument('--patch', action='store_true')
    p.add_argument('--check', action='store_true')
    args = p.parse_args()
    text = content()
    if args.patch:
        print('*** Begin Patch\n*** Add File: '+str(DST)+'\n'+
            '\n'.join('+'+line for line in text.splitlines())+'\n*** End Patch')
    if args.check:
        assert DST.read_text() == text
        print('PASS: 2048 roots, 6144 float components; double reconstruction exact; third component zero')
        print('table_sha256='+hashlib.sha256(DST.read_bytes()).hexdigest())
