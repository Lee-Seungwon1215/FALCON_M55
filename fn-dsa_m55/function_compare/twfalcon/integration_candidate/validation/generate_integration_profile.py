#!/usr/bin/env python3
"""Insert call-site timers into disposable copies; prove byte recovery.

No arithmetic changes, no symbol interposition, no patch to either source tree.
Parents are inclusive. Leaf intervals are disjoint within each parent.
"""
import hashlib
import json
import re
import sys
from pathlib import Path

source, output = map(Path, sys.argv[1:3])
integer_detail = len(sys.argv) > 3 and sys.argv[3] == 'integer'
here = Path(__file__).resolve().parent
output.mkdir(parents=True, exist_ok=True)
manifest = dict(source=str(source.resolve()), files={}, regions=[], integer_detail=integer_detail)
serial = 0

def ins(s):
    return '/* IPRO_INSERT */'+s+'/* IPRO_END */'

def region(part, fragment, op, logn='logn'):
    global serial
    assert part.count(fragment) == 1, (op, fragment, part.count(fragment))
    tag = 'ip_t'+str(serial)
    serial += 1
    manifest['regions'].append(dict(op=op, logn=logn, code=fragment))
    return part.replace(fragment, ins('\nuint64_t '+tag+' = ip_now();\n')+fragment
        +ins('\nip_end('+op+', '+logn+', '+tag+');\n'))

def expression(part, fragment, op, logn='logn'):
    global serial
    assert part.count(fragment) == 1, (op, fragment)
    tag = 'ip_e'+str(serial)
    serial += 1
    manifest['regions'].append(dict(op=op, logn=logn, code=fragment))
    return part.replace(fragment, ins('({ uint64_t '+tag+' = ip_now(); int '+tag+'_r = ')
        +fragment+ins('; ip_end('+op+', '+logn+', '+tag+'); ip_result('+op+', '+logn+', '
        +tag+'_r); '+tag+'_r; })'))

def change_function(text, name, transform):
    a = text.index('\n'+name+'(')
    b = text.index('\n#if FNDSA_AVX2', a)
    return text[:a]+transform(text[a:b])+text[b:]

def call_regions(part, mapping):
    # Full statement beginning at a call, including any multiline arguments.
    for m in reversed(list(re.finditer(r'(?m)^\t+(\w+)\([^;]*?;', part))):
        name = m[1]
        if name in mapping:
            part = region(part, m[0], mapping[name])
    return part

def intermediate(part):
    mapping = {
        'poly_big_to_fixed':'IP_I_INPUT', 'poly_big_to_fp64':'IP_I_INPUT',
        'vect_FFT':'IP_I_FFT', 'vect_FFT_fp64':'IP_I_FFT',
        'vect_iFFT':'IP_I_IFFT', 'vect_iFFT_fp64':'IP_I_IFFT',
        'vect_inv_mul2e_fft':'IP_I_RECIP', 'vect_inv_mul2e_fft_fp64':'IP_I_RECIP',
        'vect_mul_fft':'IP_I_MUL', 'vect_mul_fft_fp64':'IP_I_MUL',
        'poly_sub_kf_scaled_depth1':'IP_I_UPDATE', 'poly_sub_scaled_ntt':'IP_I_UPDATE',
        'poly_sub_scaled':'IP_I_UPDATE'}
    if integer_detail:
        mapping['zint_rebuild_CRT'] = 'IP_CRT_I'
    part = call_regions(part, mapping)
    if 'fp64_round_i32_checked' in part:
        fragment = ('\t\tfor (size_t i = 0; i < n; i ++) {\n'
            '\t\t\tk[i] = fp64_round_i32_checked(rt1[i], &round_ok);\n'
            '\t\t}\n\t\tround_ok &= fp64_k_update_ok(logn, k);')
    else:
        fragment = ('\t\tfor (size_t i = 0; i < n; i ++) {\n'
            '\t\t\tk[i] = fxr_round(rt1[i]);\n\t\t}')
    return region(part, fragment, 'IP_I_ROUND')

def depth0(part):
    part = call_regions(part, {'vect_FFT':'IP_D_FFT', 'vect_FFT_fp64':'IP_D_FFT',
        'vect_iFFT':'IP_D_IFFT', 'vect_iFFT_fp64':'IP_D_IFFT',
        'vect_div_selfadj_fft':'IP_D_DIV', 'vect_div_selfadj_fft_fp64':'IP_D_DIV'})
    for dst,src in (('rt4','t3'),('rt3','t2')):
        if 'double *rt4' in part:
            fragment = f'\tfor (size_t i = 0; i < n; i ++) {{\n\t\t{dst}[i] = (double)*(int32_t *)&{src}[i] * 0x1p-10;\n\t}}'
        else:
            fragment = f'\tfor (size_t i = 0; i < n; i ++) {{\n\t\tuint64_t x = (uint64_t)*(int32_t *)&{src}[i] << (32 - DOWNSCALE);\n\t\t{dst}[i] = fxr_of_scaled32(x);\n\t}}'
        part = region(part, fragment, 'IP_D_INPUT')
    if 'fp64_round_i32_checked' in part:
        fragment = ('\tfor (size_t i = 0; i < n; i ++) {\n'
            '\t\tint32_t k = fp64_round_i32_checked(rt3[i], &round_ok);\n'
            '\t\tt2[i] = mp_set(k, p);\n\t}')
    else:
        fragment = '\tfor (size_t i = 0; i < n; i ++) {\n\t\tt2[i] = mp_set(fxr_round(rt3[i]), p);\n\t}'
    return region(part, fragment, 'IP_D_ROUND')

def ortho(part):
    mapping = {}
    for name, op in (('set','INPUT'), ('FFT','FFT'), ('invnorm_fft','INV'),
        ('adj_fft','ADJ'), ('mul_realconst','REAL'), ('mul_selfadj_fft','SELFADJ'), ('iFFT','IFFT')):
        for suffix in ('','_fp64'): mapping['vect_'+name+suffix] = 'IP_O_'+op
    part = call_regions(part, mapping)
    if 'double sn =' in part:
        fragment = '\tdouble sn = vect_sqnorm_fp64(logn, rt1, rt2);'
    else:
        fragment = ('\tfor (size_t i = 0; i < n; i ++) {\n'
            '\t\tsn = fxr_add(sn, fxr_add(fxr_sqr(rt1[i]), fxr_sqr(rt2[i])));\n\t}')
    return region(part, fragment, 'IP_O_NORM')

def solve(part):
    for name,op,args,l in (
        ('solve_NTRU_deepest','IP_DEEPEST','logn, f, g, tmp','logn'),
        ('solve_NTRU_intermediate','IP_INTERMEDIATE','logn, f, g, depth, tmp','logn - depth'),
        ('solve_NTRU_depth0','IP_DEPTH0','logn, f, g, tmp','logn')):
        part = expression(part, name+'('+args+')', op, l)
    return part

def deepest(part):
    part = region(part, '\tmake_fg_deepest(logn_top, f, g, tmp, FG_SAVE_OFFSET);', 'IP_FG_DEEP', 'logn_top')
    part = region(part, '\tzint_rebuild_CRT(fp, len, 1, 2, 0, t1);', 'IP_CRT_DEEP', 'logn_top')
    return expression(part, 'zint_bezout(Gp, Fp, fp, gp, len, t1)', 'IP_BEZ_DEEP', 'logn_top')

def keygen(part):
    part = call_regions(part, {'sample_f':'IP_SAMPLE'})
    for name,op,args in (('mqpoly_is_invertible','IP_INVERT','logn, f, tmp'),
        ('check_ortho_norm','IP_ORTHO','logn, f, g, tmp'),
        ('solve_NTRU','IP_NTRU','logn, f, g, tmp')):
        part = expression(part, name+'('+args+')', op)
    a = part.index('\t\tsize_t j = 1;')
    b = a + re.search(r'(?m)^\t\tbreak;', part[a:]).start()
    return region(part, part[a:b], 'IP_FINISH')

def save(name, original, generated):
    generated = ins('#include "integration_profile.h"\n')+generated
    recovered = re.sub(r'/\* IPRO_INSERT \*/.*?/\* IPRO_END \*/', '', generated, flags=re.S)
    assert recovered == original, name
    (output/name).write_text(generated)
    sha = lambda s: hashlib.sha256(s.encode()).hexdigest()
    manifest['files'][name] = dict(original_sha256=sha(original), generated_sha256=sha(generated),
        exact_original_recovered=True)

original = (source/'kgen.c').read_text()
save('kgen.c', original, change_function(original, 'keygen_inner', keygen))
original = (source/'kgen_ntru.c').read_text()
generated = original
for name,fn in (('solve_NTRU_intermediate',intermediate), ('solve_NTRU_depth0',depth0),
    ('solve_NTRU',solve), ('check_ortho_norm',ortho)):
    generated = change_function(generated, name, fn)
if integer_detail:
    generated = change_function(generated, 'solve_NTRU_deepest', deepest)
    generated = change_function(generated, 'make_fg_step', lambda p:
        region(p, '\tzint_rebuild_CRT(fs, slen, n, 2, 1, t1);', 'IP_CRT_FG'))
save('kgen_ntru.c', original, generated)
original = (here/'board_keygen_perf.c').read_text()
generated = original.replace('    selftest_sha256();', '    selftest_sha256();'+ins('\n    ip_calibrate();'))
generated = generated.replace('        uint64_t total = 0;', ins('        ip_reset();\n')+'        uint64_t total = 0;')
fragment = '            (unsigned long long)samples[0], (unsigned long long)samples[99]);'
assert generated.count(fragment) == 1
generated = generated.replace(fragment, fragment+ins('\n        if (ip_report(logn, total)) return 30;'))
save('integration_bench.c', original, generated)
(output/'integration_manifest.json').write_text(json.dumps(manifest, indent=2)+'\n')
print('Reversible timing hooks:', len(manifest['regions']), 'call sites')
