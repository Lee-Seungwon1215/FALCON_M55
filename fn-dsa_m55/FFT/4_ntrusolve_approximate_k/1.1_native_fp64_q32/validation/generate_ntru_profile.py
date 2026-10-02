#!/usr/bin/env python3
"""Instrument local NTRU call sites, not arithmetic, with disjoint intervals.

The enclosing solve_NTRU timer includes every rejection/return. Candidate
orthogonal-norm FFT is outside this function and is never included.
"""
import hashlib
import json
import re
import sys
from pathlib import Path

source, output = map(Path, sys.argv[1:3])
mode = sys.argv[3]
assert mode in ('detail', 'control')
original = (source/'kgen_ntru.c').read_text()
assert '/* NPRO_INSERT */' not in original
generated = original
regions = []

def insertion(code):
    return '/* NPRO_INSERT */' + code + '/* NPRO_END */'

def function(name):
    start = generated.index('\n'+name+'(')
    end = generated.index('\n#if FNDSA_AVX2', start)
    return start, end, generated[start:end]

def wrap(part, fragment, op, indent):
    assert part.count(fragment) == 1, (op, fragment)
    timer = 'np_time_' + str(len(regions))
    regions.append(op)
    before = insertion(indent + 'uint32_t '+timer+' = np_start();\n')
    after = insertion('\n'+indent+'np_end('+op+', '+timer+');')
    return part.replace(fragment, before+fragment+after)

if mode == 'detail':
    a, b, part = function('solve_NTRU_intermediate')
    specs = [
        ('\tpoly_big_to_fp64(logn, rt3, ftb, rlen, scdiff);', 'NP_INPUT4', '\t'),
        ('\tvect_FFT_fp64(logn, rt3);', 'NP_FFT4', '\t'),
        ('\tvect_inv_mul2e_fft_fp64(logn, rt3, scale_t);', 'NP_INV4', '\t'),
        ('\t\tpoly_big_to_fp64(logn, rt1,\n\t\t\tFt + tlen * n, FGlen - tlen, scale_x + toff);', 'NP_INPUT4', '\t\t'),
        ('\t\tvect_FFT_fp64(logn, rt1);', 'NP_FFT4', '\t\t'),
        ('\t\tvect_mul_fft_fp64(logn, rt1, rt3);', 'NP_MUL4', '\t\t'),
        ('\t\tvect_iFFT_fp64(logn, rt1);', 'NP_IFFT4', '\t\t'),
        ('\t\tfor (size_t i = 0; i < n; i ++) {\n\t\t\tk[i] = fp64_round_i32_checked(rt1[i], &round_ok);\n\t\t}\n\t\tround_ok &= fp64_k_update_ok(logn, k);', 'NP_ROUND4', '\t\t'),
    ]
    for fragment, op, indent in specs: part = wrap(part, fragment, op, indent)
    generated = generated[:a] + part + generated[b:]
    a, b, part = function('solve_NTRU_depth0')
    specs = [
        ('\tfor (size_t i = 0; i < n; i ++) {\n\t\tuint64_t x = (uint64_t)*(int32_t *)&t3[i] << (32 - DOWNSCALE);\n\t\trt4[i] = fxr_of_scaled32(x);\n\t}', 'NP_INPUT5', '\t'),
        ('\tvect_FFT(logn, rt4);', 'NP_FFT5', '\t'),
        ('\tfor (size_t i = 0; i < n; i ++) {\n\t\tuint64_t x = (uint64_t)*(int32_t *)&t2[i] << (32 - DOWNSCALE);\n\t\trt3[i] = fxr_of_scaled32(x);\n\t}', 'NP_INPUT5', '\t'),
        ('\tvect_FFT(logn, rt3);', 'NP_FFT5', '\t'),
        ('\tvect_div_selfadj_fft(logn, rt3, rt5);', 'NP_DIV5', '\t'),
        ('\tvect_iFFT(logn, rt3);', 'NP_IFFT5', '\t'),
        ('\tfor (size_t i = 0; i < n; i ++) {\n\t\tt2[i] = mp_set(fxr_round(rt3[i]), p);\n\t}', 'NP_ROUND5', '\t'),
    ]
    for fragment, op, indent in specs: part = wrap(part, fragment, op, indent)
    generated = generated[:a] + part + generated[b:]

a, b, part = function('solve_NTRU')
part = part.replace('{\n', '{\n'+insertion('\tnp_enter();\n'), 1)
returns = re.findall(r'return ([01]);', part)
assert returns.count('0') == 5 and returns.count('1') == 1, returns
part = re.sub(r'return ([01]);', lambda m: insertion('np_leave('+m[1]+');\n\t')+m[0], part)
generated = insertion('#include "ntru_profile.h"\n') + generated[:a] + part + generated[b:]
recovered = re.sub(r'/\* NPRO_INSERT \*/.*?/\* NPRO_END \*/', '', generated, flags=re.S)
assert recovered == original, 'Instrumentation changed original bytes'
output.mkdir(parents=True, exist_ok=True)
(output/'kgen_ntru.c').write_text(generated)
(output/'ntru_profile_mode.h').write_text('#define NP_MODE "'+mode+'"\n')
sha = lambda s: hashlib.sha256(s.encode()).hexdigest()
(output/'profile_manifest.json').write_text(json.dumps(dict(
    source=str(source.resolve()), mode=mode,
    original_sha256=sha(original), generated_sha256=sha(generated),
    exact_original_recovered_after_removing_hooks=True,
    disjoint_regions=regions, top_level_returns=len(returns),
    denominator='all solve_NTRU attempts including failed candidates',
    excluded='candidate generation, orthogonal-norm check, key encoding, public-key calculation',
), indent=2)+'\n')
