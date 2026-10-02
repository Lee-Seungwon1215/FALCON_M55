#!/usr/bin/env python3
"""Measurement-only copies; do not change production bodies or their callers."""
import hashlib
import json
from pathlib import Path
import re
import sys

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
SOURCE = ROOT / 'Final_code/Before_slothy'
out = Path(sys.argv[1]).resolve()
mode = sys.argv[2]
assert mode in ('control', 'coarse', 'detail')
out.mkdir(parents=True, exist_ok=True)
c_names = ['shake_init', 'shake_inject', 'shake_flip', 'shake_extract',
           'sha3_init', 'sha3_update', 'sha3_close']
asm_names = ['fndsa_sha3_process_block', 'fndsa_sha3_inject_chunk']
helpers = [f'bit_{kind}_{n}' for kind in ('split', 'merge') for n in range(1, 6)]
names = c_names + asm_names + helpers
manifest = {'mode': mode, 'source': str(SOURCE), 'categories': ['other'] + names,
            'original_sha256': {}, 'generated_sha256': {}}
for p in SOURCE.iterdir():
    if p.suffix in ('.c', '.h', '.s'):
        manifest['original_sha256'][str(p)] = hashlib.sha256(p.read_bytes()).hexdigest()

probes = '''.syntax unified
.cpu cortex-m4
.thumb
.text
/* Save all live GPRs, NZCVQ and GE. 64 bytes preserve 8-byte SP alignment.
 * Neither this code nor profile_enter/profile_leave uses an FP register.
 * bit_split/merge have private ABIs and require the GE flags to survive. */
.macro PROBE action, id
    push.w {r0-r12, lr}
    mrs r0, APSR
    push {r0, r1}
    movs r0, #\\id
    bl profile_\\action
    pop {r0, r1}
    msr APSR_nzcvqg, r0
    pop.w {r0-r12, lr}
.endm
.macro WRAPPER name, body, id
    .section .text.\\name, "ax", %progbits
    .balign 4
    .global \\name
    .type \\name, %function
    .thumb_func
\\name:
    push {lr}
    sub sp, #4
    PROBE enter, \\id
    bl \\body
    PROBE leave, \\id
    ldr lr, [sp, #4]
    add sp, #8
    bx lr
    .size \\name, .-\\name
.endm
.section .text.profile_raw_empty, "ax", %progbits
.global profile_raw_empty
.type profile_raw_empty, %function
.thumb_func
profile_raw_empty:
    bx lr
.size profile_raw_empty, .-profile_raw_empty
WRAPPER profile_empty, profile_raw_empty, 1
'''

if mode != 'control':
    content = (SOURCE / 'sha3.c').read_text()
    for idx, name in enumerate(c_names, 1):
        content, count = re.subn(r'\n' + name + r'\(', '\nprofile_raw_' + name + '(', content)
        assert count == 1, (name, count)
        probes += f'WRAPPER fndsa_{name}, profile_raw_{name}, {idx}\n'
    (out / 'sha3.c').write_text(content)
    content = (SOURCE / 'sha3_cm4.s').read_text()
    for name in asm_names + (helpers if mode == 'detail' else []):
        # Rename the definition, not its BL callers. Helper fall-through must
        # stay within the original bodies: split_5 is ONE call, not five.
        raw = 'profile_raw_' + name
        content, count = re.subn(r'^' + name + r':', raw + ':', content, flags=re.M)
        assert count == 1, (name, count)
        content = re.sub(r'(?m)^(\s*\.(?:global|type)\s+)' + name + r'\b', r'\g<1>' + raw, content)
        content = re.sub(r'(?m)^(\s*\.size\s+)' + name + r',\s*\.\-' + name + r'\b',
                         r'\g<1>' + raw + ',.-' + raw, content)
        # The private helper entries are now addressed from another section.
        content = content.replace(raw + ':', f'.global {raw}\n.thumb_func\n{raw}:')
        probes += f'WRAPPER {name}, {raw}, {names.index(name) + 1}\n'
    (out / 'sha3_cm4.s').write_text(content)
(out / 'probes.s').write_text(probes)
benchmark = (ROOT / 'fn-dsa_m55/ntt_profile_compare/benchmark.c').read_text()
benchmark = benchmark.replace('#define PROFILE_CANDIDATE "unknown"',
                              f'#define PROFILE_CANDIDATE "sha3_{mode}"')
assert benchmark.count('    profile_clock_init();') == 1
benchmark = benchmark.replace('    profile_clock_init();',
                              '    profile_clock_init();\n    profile_calibrate();\n    profile_reset();')
(out / 'benchmark.c').write_text(benchmark)
for p in out.iterdir():
    if p.suffix in ('.c', '.s'):
        manifest['generated_sha256'][p.name] = hashlib.sha256(p.read_bytes()).hexdigest()
(out / 'sources.json').write_text(json.dumps(manifest, indent=2) + '\n')
