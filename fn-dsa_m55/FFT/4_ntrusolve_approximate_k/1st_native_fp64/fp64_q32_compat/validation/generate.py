#!/usr/bin/env python3
"""Disposable timing hooks, not backend selection. Crypto lives in its own folder."""
from pathlib import Path
import hashlib
import json
import sys

source, output, mode = Path(sys.argv[1]), Path(sys.argv[2]), sys.argv[3]
output.mkdir(parents=True, exist_ok=True)
path = source / 'kgen_ntru.c'
original = path.read_text()
text = original
if mode == 'profile':
    start = text.index('solve_NTRU_intermediate(')
    end = text.index('\n#if FNDSA_AVX2', start)
    part = text[start:end]
    fp = 'poly_big_to_fp64(' in part
    convert = 'poly_big_to_fp64' if fp else 'poly_big_to_fixed'
    inv = 'vect_inv_mul2e_fft_fp64' if fp else 'vect_inv_mul2e_fft'
    for old, new in [
        ('\t'+convert+'(logn, rt3,', '\tapprox_begin(0, logn);\n\t'+convert+'(logn, rt3,'),
        ('\t'+inv+'(logn, rt3, scale_t);', '\t'+inv+'(logn, rt3, scale_t);\n\tapprox_end(0, logn);'),
        ('\t\t'+convert+'(logn, rt1,', '\t\tapprox_begin(1, logn);\n\t\t'+convert+'(logn, rt1,'),
        ('\n\t\t/* f is scaled by scale_fg', '\n\t\tapprox_end(1, logn);\n\n\t\t/* f is scaled by scale_fg')]:
        assert part.count(old) == 1, old
        part = part.replace(old, new)
    text = text[:start] + part + text[end:]
    # Close timing on the new, explicit invalid-conversion rejection path.
    text = text.replace('if (!round_ok) {\n\t\t\treturn SOLVE_ERR_REDUCE;',
                        'if (!round_ok) {\n\t\t\tapprox_end(1, logn);\n\t\t\treturn SOLVE_ERR_REDUCE;')
    text = '#include "measure.h"\n' + text
assert mode in ('perf', 'profile')
(output / path.name).write_text(text)
(output / 'manifest.json').write_text(json.dumps(dict(source=str(source.resolve()),mode=mode,original_sha256=hashlib.sha256(original.encode()).hexdigest(),generated_sha256=hashlib.sha256(text.encode()).hexdigest()),indent=2)+'\n')
# Extract only the original KAT material needed on the board. Including the
# entire upstream test TU retains unrelated merged strings in scarce DTCM.
# Expected values and SHA-256 code are copied verbatim, never recomputed.
test = (source / 'test_fndsa.c').read_text()
parts = [test[test.index('size_t\nhextobin('):test.index('static void\ninner_test_SHAKE256(')]]
for degree in (256, 512, 1024):
    start = test.index(f'static const char *const KAT_KG{degree}[]')
    stop = test.index('\n};', start) + 3
    part = test[start:stop]
    assert part.count('"') == 200
    parts.append(part)
start = test.index('static void\nselftest_sha256(')
stop = test.index('\n#if FNDSA_ASM_CORTEXM4', start)
parts.append(test[start:stop])
(output / 'upstream_kat.h').write_text('/* Verbatim excerpts of local test_fndsa.c. */\n'+'\n'.join(parts))
