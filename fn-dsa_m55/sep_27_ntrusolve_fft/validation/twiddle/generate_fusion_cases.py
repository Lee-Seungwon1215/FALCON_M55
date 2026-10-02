#!/usr/bin/env python3
"""Print an apply_patch patch for the PUBLIC root-class dispatch table.

Run once during source authoring, not as a production build step.
"""
from pathlib import Path
import re
here = Path(__file__).resolve().parent
table = [tuple(map(int, v)) for v in re.findall(
    r'\{ UINT64_C\((\d+)\), UINT64_C\((\d+)\) \}', (here / 'table.h').read_text())]
assert len(table) == 1024
def cls(x):
    high = x >> 32
    if high >= 1 << 31: high -= 1 << 32
    return high, (x >> 31) & 1
cases, words = [], []
for inverse in (0, 1):
    groups = {}
    for lm in range(1, 10):
        m = 1 << lm
        for re_, im in table[m:m + m // 2]:
            if inverse: im = -im % (1 << 64)
            rh, rn = cls(re_); ih, inn = cls(im); sh, sn = cls((re_ + im) % (1 << 64))
            assert rh in (-1, 0) and ih == -inverse and sh in (-2, -1, 0, 1)
            key = ((rh & 1) << 1 | rn) | inn << 2 | (((sh + 2) << 1 | sn) << 3)
            value = (rh, rn, ih, inn, sh, sn)
            assert key not in groups or groups[key] == value
            groups[key] = value
    assert len(groups) == 9
    for key, value in sorted(groups.items()):
        cases.append('\tF_CASE .Lfused_%d_%d,%d,%s' % (inverse, key, inverse, ','.join(map(str, value))))
    labels = [f'.Lfused_{inverse}_{i}+1' if i in groups else '.Lfused_bad_root+1' for i in range(64)]
    words.extend('\t.word ' + ', '.join(labels[i:i+4]) for i in range(0, 64, 4))
p = here / 'fused_trial.s'
text = p.read_text()
assert text.count('/* GENERATED_CASES */') == text.count('/* GENERATED_TABLE */') == 1
print('*** Begin Patch\n*** Update File: ' + str(p))
for tag, lines in [('CASES', cases), ('TABLE', words)]:
    print('@@\n-/* GENERATED_' + tag + ' */')
    for line in lines: print('+' + line)
print('*** End Patch')
