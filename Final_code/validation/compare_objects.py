#!/usr/bin/env python3
"""Compare allocated object sections against the pre-cleanup snapshot.

This checks compiler output, not formal algorithmic equivalence. mq_cm55.s
intentionally changes (removed dispatch/probe); its behavior is board-tested.
"""
from pathlib import Path
import hashlib
import json
import re
import subprocess
import tempfile

HERE = Path(__file__).resolve().parent
WORKSPACE = HERE.parent.parent
TOOL = WORKSPACE / 'fn-dsa_m55/measurement_mlkem_native/env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin'
OLD = HERE / 'snapshots/original/Before_slothy'
NEW = HERE.parent / 'Before_slothy'
OUT = HERE / 'build/object_audit'
OUT.mkdir(parents=True, exist_ok=True)
arch = ['-mcpu=cortex-m55', '-mthumb', '-mfpu=fpv5-d16', '-mfloat-abi=hard']
cflags = ['-O3', '-ffp-contract=off', '-fno-fast-math', '-fno-strict-aliasing',
          '-ffunction-sections', '-fdata-sections']
old_flags = ['-DFNDSA_ASM_CORTEXM4=1', '-DFNDSA_ASM_CORTEXM55=1', '-DFNDSA_MVE_MP31=1']
sources = ['codec', 'mq', 'sha3', 'sysrng', 'util', 'kgen', 'kgen_fxp', 'kgen_gauss',
           'kgen_mp31', 'kgen_ntru', 'kgen_poly', 'kgen_zint31', 'kgen_fft_mve',
           'kgen_fft_bridge', 'sign', 'sign_core', 'sign_fpoly', 'sign_fpr', 'sign_sampler', 'vrfy']
sources = [n + '.c' for n in sources] + [n + '.s' for n in
    ('codec_cm4', 'sha3_cm4', 'sign_fpr_cm4', 'sign_sampler_cm4',
     'mq_cm55', 'kgen_mp31_cm55', 'kgen_fft_cm55')]

def sections(obj):
    listing = subprocess.check_output([str(TOOL / 'arm-none-eabi-objdump'), '-h', str(obj)], text=True)
    lines = listing.splitlines()
    result = {}
    for i, line in enumerate(lines[:-1]):
        match = re.match(r'\s*\d+\s+(\S+)\s+([0-9a-f]+)\s', line)
        if not match or 'ALLOC' not in lines[i+1] or 'CONTENTS' not in lines[i+1]: continue
        name, size = match[1], int(match[2], 16)
        with tempfile.TemporaryDirectory() as temp:
            dump = Path(temp) / 'section.bin'
            subprocess.run([str(TOOL / 'arm-none-eabi-objcopy'),
                '--dump-section', f'{name}={dump}', str(obj), str(Path(temp) / 'copy.o')], check=True)
            result[name] = dict(size=size, sha256=hashlib.sha256(dump.read_bytes()).hexdigest())
    return result

results = {}
for source in sources:
    old_obj = OUT / (source + '.old.o')
    new_obj = NEW / 'build' / (Path(source).stem + '.o')
    subprocess.run([str(TOOL / 'arm-none-eabi-gcc'), *arch,
        *(cflags + old_flags if source.endswith('.c') else []),
        '-c', str(OLD / source), '-o', str(old_obj)], check=True)
    old, new = sections(old_obj), sections(new_obj)
    changed = [name for name in sorted(old.keys() | new.keys()) if old.get(name) != new.get(name)]
    results[source] = dict(identical=not changed, changed_sections=changed, old=old, new=new)
    print(source, 'IDENTICAL' if not changed else 'CHANGED ' + ','.join(changed))
unexpected = [name for name, row in results.items() if not row['identical'] and name != 'mq_cm55.s']
(OUT / 'report.json').write_text(json.dumps(dict(objects=results, unexpected=unexpected), indent=2) + '\n')
assert not unexpected, unexpected
