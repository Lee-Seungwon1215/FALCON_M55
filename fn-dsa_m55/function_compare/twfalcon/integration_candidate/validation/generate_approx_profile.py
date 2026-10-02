#!/usr/bin/env python3
"""Generate a timing-only NTRU translation unit; leave actual sources untouched.

No replacement arithmetic, input changes, or nested timed intervals.
Every insertion is checked against a unique original source fragment.
"""
import hashlib
import json
import sys
from pathlib import Path

source, output = map(Path, sys.argv[1:])
original = (source / 'kgen_ntru.c').read_text()
start = original.index('\nsolve_NTRU_intermediate(')
end = original.index('\n#if FNDSA_AVX2', start)
part = original[start:end]
fp64 = 'poly_big_to_fp64(' in part
convert = 'poly_big_to_fp64' if fp64 else 'poly_big_to_fixed'
suffix = '_fp64' if fp64 else ''
replacements = []

def wrap(fragment, op, indent):
    global part
    assert part.count(fragment) == 1, (op, fragment)
    timer = 'ap_time_' + op.lower()
    replacement = (indent + 'uint32_t ' + timer + ' = ap_start();\n' + fragment
                   + '\n' + indent + 'ap_end(' + op + ', logn, ' + timer + ');')
    part = part.replace(fragment, replacement)
    replacements.append((replacement, fragment))

wrap('\t' + convert + '(logn, rt3, ftb, rlen, scdiff);', 'AP_INPUT_F', '\t')
wrap('\tvect_FFT' + suffix + '(logn, rt3);', 'AP_FFT_F', '\t')
wrap('\tvect_inv_mul2e_fft' + suffix + '(logn, rt3, scale_t);', 'AP_INVERSE', '\t')
wrap('\t\t' + convert + '(logn, rt1,\n\t\t\tFt + tlen * n, FGlen - tlen, scale_x + toff);',
     'AP_INPUT_BIG_F', '\t\t')
wrap('\t\tvect_FFT' + suffix + '(logn, rt1);', 'AP_FFT_BIG_F', '\t\t')
wrap('\t\tvect_mul_fft' + suffix + '(logn, rt1, rt3);', 'AP_POINTWISE', '\t\t')
wrap('\t\tvect_iFFT' + suffix + '(logn, rt1);', 'AP_IFFT', '\t\t')
round_body = ('\t\tfor (size_t i = 0; i < n; i ++) {\n\t\t\tk[i] = '
              + ('fp64_round_i32_checked(rt1[i], &round_ok)' if fp64 else 'fxr_round(rt1[i])')
              + ';\n\t\t}')
wrap(round_body, 'AP_ROUND', '\t\t')
if fp64:
    wrap('\t\tround_ok &= fp64_k_update_ok(logn, k);', 'AP_GUARD', '\t\t')

# Removing only the inserted timing statements must recover the byte-for-byte
# original function. No numerical/guard/rejection logic may have changed.
recovered = part
for new, old in reversed(replacements):
    recovered = recovered.replace(new, old)
assert recovered == original[start:end]
generated = '#include "approx_profile.h"\n' + original[:start] + part + original[end:]
output.mkdir(parents=True, exist_ok=True)
(output / 'kgen_ntru.c').write_text(generated)
sha = lambda s: hashlib.sha256(s.encode()).hexdigest()
(output / 'profile_manifest.json').write_text(json.dumps(dict(
    source=str(source.resolve()), original_sha256=sha(original),
    generated_sha256=sha(generated), timing_regions=len(replacements),
    exact_original_recovered_after_removing_hooks=True,
    scope='only scalar solve_NTRU_intermediate approximate-k phases; all reached attempts'), indent=2) + '\n')
