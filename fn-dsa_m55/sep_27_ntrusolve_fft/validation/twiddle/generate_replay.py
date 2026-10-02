#!/usr/bin/env python3
"""Disposable NTRU call-site diagnostic. Never changes production sources."""
import hashlib
import json
import sys
from pathlib import Path
source, out = map(Path, sys.argv[1:])
here = Path(__file__).resolve().parent
out.mkdir(parents=True, exist_ok=True)
original = (source / 'kgen_ntru.c').read_text()
pairs = [('vect_FFT_ntru(logn, rt3);', 'trial_replay(logn, rt3, 0);'),
         ('vect_FFT_ntru(logn, rt1);', 'trial_replay(logn, rt1, 0);'),
         ('vect_iFFT_ntru(logn, rt1);', 'trial_replay(logn, rt1, 1);')]
generated = original
for old, new in pairs:
    assert generated.count(old) == 1
    generated = generated.replace(old, new)
header = '\nvoid trial_replay(unsigned, fxr *, unsigned);\n'
needle = '#include "kgen_inner.h"'
assert generated.count(needle) == 1
generated = generated.replace(needle, needle + header)
recovered = generated.replace(header, '')
for old, new in pairs:
    recovered = recovered.replace(new, old)
assert recovered == original
(out / 'kgen_ntru.c').write_text(generated)
original_bench = (here.parent / 'board_keygen_perf.c').read_text()
declaration = '\nextern int trial_replay_report(void);\n'
bench = original_bench.replace('#include "kgen_inner.h"', '#include "kgen_inner.h"' + declaration)
assert bench.count('    return mismatches != 0;') == 1
bench = bench.replace('    return mismatches != 0;',
    '    return (mismatches != 0) | trial_replay_report();')
(out / 'replay_bench.c').write_text(bench)
(out / 'replay_manifest.json').write_text(json.dumps(dict(
    original_sha256=hashlib.sha256(original.encode()).hexdigest(),
    original_recovered=True, substitutions=pairs,
    purpose='Capture first 16 actual NTRU FFT calls per logn/direction; no performance claim for whole diagnostic'), indent=2)+'\n')
