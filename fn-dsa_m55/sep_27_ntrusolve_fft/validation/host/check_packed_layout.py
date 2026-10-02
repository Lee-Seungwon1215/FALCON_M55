#!/usr/bin/env python3
"""Finite public-address/lane model; not an ARM instruction emulator."""
import re
from pathlib import Path

root = Path(__file__).resolve().parents[2]
assembly = (root / 'A_tw_bridge/kgen_fft_cm55.s').read_text()
table = assembly.split('.Lnqt_offsets:', 1)[1].split('.section', 1)[0]
maps = [[int(x.strip(), 0) for x in line.split(',')]
        for line in re.findall(r'^\s*\.word\s+([^/\n]+)', table, re.M)]
assert maps == [[0, 16, 32, 48], [0, 16, 32, 48],
                [0, 8, 32, 40], [0, 0, 16, 16]], maps

coefficient_blocks = root_blocks = 0
for logn in range(4, 11):
    hn = 1 << (logn - 1)
    words = 4 * hn
    for block in range(hn // 8):
        for component in range(2):
            base = 2 * component * hn + 16 * block
            # Complete VLD4.32 into x.low/high, y.low/high.
            columns = [[base + 4 * lane + field for lane in range(4)]
                       for field in range(4)]
            old = [[base + byte // 4 + field for byte in maps[0]]
                   for field in range(4)]
            assert columns == old
            assert all(0 <= word < words for col in columns for word in col)
            # Distinct output tags detect field/lane/real-imag confusion.
            pairs = {(field, lane): (component, block, field, lane)
                     for field in range(4) for lane in range(4)}
            interleaved = {base + 4 * lane + field: pairs[field, lane]
                           for lane in range(4) for field in range(4)}
            scattered = {old[field][lane]: pairs[field, lane]
                         for field in range(4) for lane in range(4)}
            assert interleaved == scattered and len(interleaved) == 16
            assert set(interleaved) == set(range(base, base + 16))
            coefficient_blocks += 1
        # ht=1 starts at root m=hn; each block consumes four fxc roots.
        root_base = 4 * hn + 16 * block
        loaded = [[root_base + 4 * lane + field for lane in range(4)]
                  for field in range(4)]
        gathered = [[root_base + byte // 4 + field for byte in maps[1]]
                    for field in range(4)]
        assert loaded == gathered
        assert max(max(col) for col in loaded) < 4 * (hn + hn // 2)
        root_blocks += 1

print('LAYOUT_MODEL_DONE logn=4..10 coefficient_blocks=%d root_blocks=%d '
      'actual_maps=1 failures=0' % (coefficient_blocks, root_blocks))
