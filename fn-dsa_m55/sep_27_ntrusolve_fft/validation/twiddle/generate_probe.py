#!/usr/bin/env python3
"""Add the existing isolated kernel test to a disposable profile benchmark.

This does not modify any generated cryptographic compilation unit.
"""
import sys
from pathlib import Path
out = Path(sys.argv[1])
here = Path(__file__).resolve().parent
p = out / 'integration_bench.c'
text = p.read_text()
needle = '    selftest_sha256();'
assert text.count(needle) == 1
text = text.replace(needle, '    if (trial_profile_probe(0, NULL)) return 41;\n' + needle)
needle = '#include "kgen_inner.h"'
assert text.count(needle) == 1
text = text.replace(needle, needle + '\nextern int trial_profile_probe(int, char **);')
p.write_text(text)
test = (here / 'integration_board.c').read_text()
assert test.count('int mlk_test_main(') == 1
(out / 'profile_probe.c').write_text(test.replace('int mlk_test_main(', 'int trial_profile_probe('))
