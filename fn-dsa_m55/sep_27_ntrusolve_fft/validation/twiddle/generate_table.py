#!/usr/bin/env python3
"""Test-only table fixture copied mechanically from the frozen baseline."""
import hashlib
import re
from pathlib import Path

here = Path(__file__).resolve().parent
source = here.parent.parent / 'baseline_ntt/kgen_fxp.c'
text = source.read_text()
table = text[text.index('static const fxc GM_TAB'):]
table = table[:table.index('};')]
pairs = re.findall(r'FXC\(\s*(\d+)ull,\s*(\d+)ull\)', table)
assert len(pairs) == 1024
lines = ['/* Test fixture, not linked as a production FFT implementation.',
         ' * source SHA256: ' + hashlib.sha256(source.read_bytes()).hexdigest(),
         ' */', 'static const uint64_t original_twiddles[1024][2] = {']
lines += ['    { UINT64_C(%s), UINT64_C(%s) },' % p for p in pairs]
lines += ['};', '']
(here / 'table.h').write_text('\n'.join(lines))
print('TWIDDLE_TABLE pairs=1024')
