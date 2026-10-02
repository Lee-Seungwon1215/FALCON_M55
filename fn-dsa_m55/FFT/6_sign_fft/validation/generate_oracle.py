#!/usr/bin/env python3
"""Test-only original FFT pair; never linked into the production library."""
import hashlib
import json
from pathlib import Path
import sys
import tarfile

here = Path(__file__).resolve().parent
workspace = here.parents[3]
# Before_slothy now contains the adopted FFT ASM. Freeze the pre-FFT oracle
# at the preserved source snapshot instead of reading that mutable baseline.
source = workspace / 'Final_code/validation/snapshots/original/Before_slothy/sign_fpoly.c'
original = source.read_text()
marker = '/* see sign_inner.h */\nTARGET_SSE2 TARGET_NEON\nvoid\nfpoly_set_small('
assert original.count(marker) == 1
oracle = original.split(marker)[0]
for name in ('FFT', 'iFFT'):
    assert oracle.count('\nfpoly_' + name + '(') == 1
    oracle = oracle.replace('\nfpoly_' + name + '(', '\noracle_' + name + '(')
out = Path(sys.argv[1])
out.mkdir(parents=True, exist_ok=True)
(out / 'oracle.c').write_text(oracle)
archive = here / 'native_c_baseline.tar.gz'
with tarfile.open(archive) as tf:
    native = tf.extractfile('sign_fpoly.c').read().decode().split(marker)[0]
# The immutable pre-ASM source shares the candidate's unchanged bit table.
# This is a test-only comparator, never part of the production library.
start = native.index('static const fpr GM[] = {')
end = native.index('\n};', start) + 3
native = native[:start] + 'extern const fpr fndsa_sign_gm[];' + native[end:]
native = native.replace('GM[', 'fndsa_sign_gm[').replace(')GM', ')fndsa_sign_gm')
for name in ('FFT', 'iFFT'):
    native = native.replace('\nfpoly_' + name + '(', '\nnative_c_' + name + '(')
(out / 'native_c.c').write_text(native)
native_sign = native.replace('\nnative_c_FFT(', '\nfpoly_FFT(').replace('\nnative_c_iFFT(', '\nfpoly_iFFT(')
(out / 'native_c_sign.c').write_text(native_sign)
(out / 'oracle_manifest.json').write_text(json.dumps({
    'source': str(source), 'source_sha256': hashlib.sha256(source.read_bytes()).hexdigest(),
    'oracle_sha256': hashlib.sha256(oracle.encode()).hexdigest(),
    'native_archive': str(archive),
    'native_archive_sha256': hashlib.sha256(archive.read_bytes()).hexdigest(),
    'native_sha256': hashlib.sha256(native.encode()).hexdigest(),
    'native_sign_sha256': hashlib.sha256(native_sign.encode()).hexdigest()
}, indent=2) + '\n')
