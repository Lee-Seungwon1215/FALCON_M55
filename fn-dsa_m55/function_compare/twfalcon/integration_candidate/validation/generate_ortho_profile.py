#!/usr/bin/env python3
"""Instrument only check_ortho_norm; stripping hooks recovers exact source."""
import hashlib
import json
import re
import sys
from pathlib import Path

source, output = map(Path, sys.argv[1:3])
mode = sys.argv[3]
assert mode in ('detail', 'control')
original = (source/'kgen_ntru.c').read_text()
assert '/* OPRO_INSERT */' not in original
start = original.index('\ncheck_ortho_norm(')
end = original.index('\n#if FNDSA_AVX2', start)
part = original[start:end]
regions = []

def insert(code):
    return '/* OPRO_INSERT */'+code+'/* OPRO_END */'

def wrap(fragment, op):
    global part
    assert part.count(fragment) == 1, (op, fragment)
    timer = 'op_time_'+str(len(regions))
    regions.append(op)
    before = insert('\tuint32_t '+timer+' = op_start();\n')
    after = insert('\n\top_end('+op+', '+timer+');')
    part = part.replace(fragment, before+fragment+after)

if mode == 'detail':
    for fragment, op in [
        ('\tvect_set(logn, rt1, f);', 'OP_INPUT'),
        ('\tvect_set(logn, rt2, g);', 'OP_INPUT'),
        ('\tvect_FFT(logn, rt1);', 'OP_FFT'),
        ('\tvect_FFT(logn, rt2);', 'OP_FFT'),
        ('\tvect_invnorm_fft(logn, rt3, rt1, rt2, 0);', 'OP_INVNORM'),
        ('\tvect_adj_fft(logn, rt1);', 'OP_ADJ'),
        ('\tvect_adj_fft(logn, rt2);', 'OP_ADJ'),
        ('\tvect_mul_realconst(logn, rt1, fxr_of(12289));', 'OP_REALCONST'),
        ('\tvect_mul_realconst(logn, rt2, fxr_of(12289));', 'OP_REALCONST'),
        ('\tvect_mul_selfadj_fft(logn, rt1, rt3);', 'OP_SELFADJ'),
        ('\tvect_mul_selfadj_fft(logn, rt2, rt3);', 'OP_SELFADJ'),
        ('\tvect_iFFT(logn, rt1);', 'OP_IFFT'),
        ('\tvect_iFFT(logn, rt2);', 'OP_IFFT'),
        ('\tfxr sn = fxr_zero;\n\tfor (size_t i = 0; i < n; i ++) {\n'
         '\t\tsn = fxr_add(sn, fxr_add(fxr_sqr(rt1[i]), fxr_sqr(rt2[i])));\n\t}', 'OP_NORM'),
    ]:
        wrap(fragment, op)
part = part.replace('{\n', '{\n'+insert('\top_enter();\n'), 1)
assert part.count('\treturn ') == 1
part = part.replace('\treturn ', insert('\top_leave();\n')+'\treturn ')
generated = insert('#include "ortho_profile.h"\n')+original[:start]+part+original[end:]
assert re.sub(r'/\* OPRO_INSERT \*/.*?/\* OPRO_END \*/', '', generated, flags=re.S) == original
output.mkdir(parents=True, exist_ok=True)
(output/'kgen_ntru.c').write_text(generated)
(output/'ortho_profile_mode.h').write_text('#define OP_MODE "'+mode+'"\n')
sha = lambda s: hashlib.sha256(s.encode()).hexdigest()
(output/'profile_manifest.json').write_text(json.dumps(dict(
    source=str(source.resolve()), mode=mode,
    original_sha256=sha(original), generated_sha256=sha(generated),
    exact_original_recovered_after_removing_hooks=True,
    disjoint_regions=regions,
    denominator=['entire seeded keygen including all retries',
                 'all check_ortho_norm entries through pre-return, including rejections'],
    note='NTRU is not internally instrumented. Key validation/printing is outside keygen timing.',
), indent=2)+'\n')
