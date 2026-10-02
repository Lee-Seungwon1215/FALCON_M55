#!/usr/bin/env python3
"""Generate disposable signing probes, leaving the final implementation intact."""
import hashlib
import importlib.util
import json
from pathlib import Path
import re
import sys

HERE = Path(__file__).resolve().parent
WORKSPACE = HERE.parents[2]
SOURCE = WORKSPACE / 'Final_code/Before_slothy'
STAGE = WORKSPACE / 'fn-dsa_m55/stage_profile_compare'
out = Path(sys.argv[1]).resolve()
mode = sys.argv[2]
assert mode in ('sign_profile', 'sign_control', 'sign_detail')
out.mkdir(parents=True, exist_ok=True)
spec = importlib.util.spec_from_file_location('stage_instrument', STAGE / 'instrument.py')
stage = importlib.util.module_from_spec(spec)
spec.loader.exec_module(stage)

def once(text, old, new):
    return stage.replace_once(text, old, new, old[:60])

def add_scope(text, function, category):
    pattern = r'\n' + function + r'\([^;{}]*\)\n\{'
    text, count = re.subn(pattern,
        lambda m: m[0] + '\n\tFNDSA_SCOPE(' + category + ');', text)
    assert count == 1, (function, count)
    return text

manifest = {'mode': mode, 'source': str(SOURCE), 'original_sha256': {}, 'generated_sha256': {}}
assembly_path = SOURCE / 'sign_fft_cm55.s'
assert assembly_path.is_file(), 'Expected the adopted native FP64 ASM pair'
manifest['original_sha256'][str(assembly_path)] = hashlib.sha256(assembly_path.read_bytes()).hexdigest()
instrumented = mode in ('sign_profile', 'sign_detail')
for name in ('sign', 'sign_core', 'sign_sampler', 'sign_fpoly'):
    path = SOURCE / (name + '.c')
    original = path.read_text()
    content = original
    if mode in ('sign_profile', 'sign_detail'):
        if name in stage.INSTRUMENT:
            content = stage.INSTRUMENT[name](content)
        if name == 'sign_fpoly':
            for function, category in (
                ('fpoly_gram_fft', 'CAT_SG_GRAM'), ('fpoly_apply_basis', 'CAT_SG_TARGET')):
                content = add_scope(content, function, category)
            if mode == 'sign_detail':
                for function, category in (
                    ('fpoly_LDL_fft', 'CAT_SG_LDL'),
                    ('fpoly_split_fft', 'CAT_SG_SPLIT'),
                    ('fpoly_split_selfadj_fft', 'CAT_SG_SPLIT_SELFADJ'),
                    ('fpoly_merge_fft', 'CAT_SG_MERGE'),
                    ('fpoly_mul_fft', 'CAT_SG_MUL'),
                    ('fpoly_add', 'CAT_SG_ADD'), ('fpoly_sub', 'CAT_SG_SUB')):
                    content = add_scope(content, function, category)
        if mode == 'sign_detail' and name == 'sign_sampler':
            content = add_scope(content, 'ffsamp_fft_deepest', 'CAT_SG_DEEPEST')
        # The two transform definitions now live in unchanged production ASM.
        # Redirect only calls in disposable C copies to timed probes, which
        # call that real ASM. No symbol interposition or renamed production ASM.
        for function in ('fpoly_FFT', 'fpoly_iFFT'):
            assert not re.search(r'\n' + function + r'\([^;{}]*\)\n\{', content)
            content = re.sub(r'\b' + function + r'\b', 'profile_' + function, content)
        content = '#include "fft_probes.h"\n' + content
    content = '#include "profile.h"\n#line 1 "' + str(path) + '"\n' + content
    (out / path.name).write_text(content)
    manifest['original_sha256'][str(path)] = hashlib.sha256(original.encode()).hexdigest()
    manifest['generated_sha256'][path.name] = hashlib.sha256(content.encode()).hexdigest()

if instrumented:
    probes_header = '''#ifndef SIGN_FFT_PROBES_H
#define SIGN_FFT_PROBES_H
#include "sign_inner.h"
void profile_fpoly_FFT(unsigned logn, fpr *f);
void profile_fpoly_iFFT(unsigned logn, fpr *f);
#endif
'''
    probes = '''/* Test-only call scopes. Production ASM is not modified. */
#include "profile.h"
#include "fft_probes.h"
__attribute__((noinline)) void profile_fpoly_FFT(unsigned logn, fpr *f)
{
    FNDSA_SCOPE(CAT_SG_FFT);
    fpoly_FFT(logn, f);
}
__attribute__((noinline)) void profile_fpoly_iFFT(unsigned logn, fpr *f)
{
    FNDSA_SCOPE(CAT_SG_IFFT);
    fpoly_iFFT(logn, f);
}
'''
    for filename, text in (('fft_probes.h', probes_header), ('fft_probes.c', probes)):
        (out / filename).write_text(text)
        manifest['generated_sha256'][filename] = hashlib.sha256(text.encode()).hexdigest()

header = (STAGE / 'profile.h').read_text()
header = once(header, '\tCAT_COUNT\n',
    '\tCAT_SG_FFT, CAT_SG_IFFT, CAT_SG_GRAM, CAT_SG_TARGET,\n\tCAT_COUNT\n')
profile = (STAGE / 'profile.c').read_text()
profile = once(profile, '\t"vr_poly", "vr_norm"\n',
    '\t"vr_poly", "vr_norm",\n\t"sg_fft", "sg_ifft", "sg_gram", "sg_target"\n')
if mode == 'sign_detail':
    header = once(header, '\tCAT_COUNT\n',
        '\tCAT_SG_LDL, CAT_SG_SPLIT, CAT_SG_SPLIT_SELFADJ, CAT_SG_MERGE,\n'
        '\tCAT_SG_MUL, CAT_SG_ADD, CAT_SG_SUB, CAT_SG_DEEPEST,\n\tCAT_COUNT\n')
    profile = once(profile, '\t"sg_fft", "sg_ifft", "sg_gram", "sg_target"\n',
        '\t"sg_fft", "sg_ifft", "sg_gram", "sg_target",\n'
        '\t"sg_ldl", "sg_split", "sg_split_selfadj", "sg_merge",\n'
        '\t"sg_mul", "sg_add", "sg_sub", "sg_deepest"\n')
# Keep the old workload/seed sequence and key preparation unchanged. Only
# signing is timed here; keygen and verification remain correctness checks.
benchmark_path = WORKSPACE / 'fn-dsa_m55/ntt_profile_compare/benchmark.c'
benchmark = benchmark_path.read_text()
for operation in ('KEYGEN', 'VERIFY'):
    pattern = r'        profile_begin\(di, OP_' + operation + r'\);\n(.*?)        profile_end\(\);\n'
    benchmark, count = re.subn(pattern, r'\1', benchmark, flags=re.S)
    assert count == 1, operation
benchmark = once(benchmark, '#define PROFILE_CANDIDATE "unknown"',
    '#define PROFILE_CANDIDATE "Final_Before_slothy_' + mode + '"')
for name, content in (('profile.h', header), ('profile.c', profile), ('benchmark.c', benchmark)):
    (out / name).write_text(content)
    manifest['generated_sha256'][name] = hashlib.sha256(content.encode()).hexdigest()
for path in (STAGE / 'instrument.py', STAGE / 'profile.h', STAGE / 'profile.c', benchmark_path, Path(__file__)):
    manifest['original_sha256'][str(path)] = hashlib.sha256(path.read_bytes()).hexdigest()
(out / 'sign_profile_manifest.json').write_text(json.dumps(manifest, indent=2) + '\n')
