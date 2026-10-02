#!/usr/bin/env python3
"""Generate measurement-only copies and ABI-preserving function probes.

No production source is changed; both modes copy exactly the same arithmetic.
Short inline byte readers are deliberately NOT outlined or individually timed.
"""
import hashlib
import json
from pathlib import Path
import re
import sys

HERE=Path(__file__).resolve().parent
PROD=HERE.parent
ROOT=PROD.parent
out=Path(sys.argv[1]).resolve()
mode=sys.argv[2]
assert mode in ('control','profile')
production=out/'production';reference=out/'reference'
production.mkdir(parents=True,exist_ok=True);reference.mkdir(parents=True,exist_ok=True)
manifest={'mode':mode,'original':{},'generated':{}}
for p in PROD.iterdir():
    if p.suffix in ('.c','.h','.s'):
        (production/p.name).write_bytes(p.read_bytes())
        manifest['original'][str(p)]=hashlib.sha256(p.read_bytes()).hexdigest()
before=ROOT/'Final_code/Before_slothy'
for p in (PROD/'validation/reference').iterdir():
    if p.suffix not in ('.c','.h','.s'):continue
    source=p.read_text()
    assert re.sub(r'\breference_(fndsa_[A-Za-z0-9_]+)',r'\1',source)==(before/p.name).read_text(),p
    (reference/p.name).write_text(source)
    manifest['original'][str(p)]=hashlib.sha256(p.read_bytes()).hexdigest()
source=(before/'kgen.c').read_text()
source=re.sub(r'\bfndsa_(keygen\w*)\b',r'baseline_\1',source)
(reference/'kgen.c').write_text(source)
manifest['original'][str(before/'kgen.c')]=hashlib.sha256((before/'kgen.c').read_bytes()).hexdigest()
for p in before.iterdir():
    if p.suffix in ('.c','.h','.s'):
        manifest['original'][str(p)]=hashlib.sha256(p.read_bytes()).hexdigest()

probes=r'''.syntax unified
.arch armv8.1-m.main
.arch_extension mve
.thumb
.text
/* All selected functions take <=4 register arguments and return void.
 * Preserve live GPRs, APSR NZCVQ/GE and 8-byte stack alignment. The bookkeeping
 * is compiled -mgeneral-regs-only. It cannot modify FPU/MVE/VPR state. */
.macro PROBE action, id
    push.w {r0-r12, lr}
    mrs r0, APSR
    push {r0, r1}
    movs r0, #\id
    bl profile_\action
    pop {r0, r1}
    msr APSR_nzcvqg, r0
    pop.w {r0-r12, lr}
.endm
.macro WRAPPER name, body, id
    .section .text.\name, "ax", %progbits
    .balign 4
    .global \name
    .type \name, %function
    .thumb_func
\name:
    push {lr}
    sub sp, #4
    PROBE enter, \id
    bl \body
    PROBE leave, \id
    ldr lr, [sp, #4]
    add sp, #8
    bx lr
    .size \name, .-\name
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
items=[
 ('sha3_cm4.s','fndsa_sha3_process_block','fndsa_sha3_process_block',1),
 ('sha3.c','shake_init','fndsa_shake_init',2),
 ('sha3.c','shake_inject','fndsa_shake_inject',3),
 ('sha3.c','shake_flip','fndsa_shake_flip',4),
 ('sha3.c','shake_extract','fndsa_shake_extract',5),
 ('sha3_cm4.s','fndsa_sha3_inject_chunk','fndsa_sha3_inject_chunk',6),
 ('sha3x4_cm55.s','fndsa_keccakx4_permute','fndsa_keccakx4_permute',7),
 ('sha3x4_cm55.s','fndsa_keccakx4_squeeze_separate','fndsa_keccakx4_squeeze_separate',8),
 ('shake_batch4.c','fndsa_shake_batch4_prepare','fndsa_shake_batch4_prepare',9),
 ('shake_independent4.c','fndsa_shake4_absorb','fndsa_shake4_absorb',10),
 ('shake_independent4.c','fndsa_shake4_export_lane','fndsa_shake4_export_lane',11),
 ('shake_independent4.c','fndsa_shake4_block','fndsa_shake4_block',12),
 ('shake_batch4.c','fndsa_sampler_extract','fndsa_sampler_extract',13),
 ('shake_independent4.c','fndsa_batch4_clear','fndsa_batch4_clear',14),
]
if mode=='profile':
    for filename,name,export,cat in items:
        p=production/filename;source=p.read_text();raw='profile_raw_'+export
        if p.suffix=='.c':
            # Rename only a definition, never a declaration or call.
            source,count=re.subn(r'(?m)^(void\s+)?'+name+r'\(',lambda m:(m[1] or '')+raw+'(',source)
            assert count==1,(name,count)
        else:
            source,count=re.subn(r'(?m)^'+name+r':',raw+':',source)
            assert count==1,(name,count)
            source=re.sub(r'(?m)^(\s*\.(?:global|type)\s+)'+name+r'\b',r'\g<1>'+raw,source)
            source=re.sub(r'(?m)^(\s*\.size\s+)'+name+r',\s*\.\s*-\s*'+name+r'\b',
                r'\g<1>'+raw+',.-'+raw,source)
        p.write_text(source)
        probes+=f'WRAPPER {export}, {raw}, {cat}\n'
(out/'probes.s').write_text(probes)
for p in out.rglob('*'):
    if p.is_file() and p.suffix in ('.c','.h','.s'):
        manifest['generated'][str(p.relative_to(out))]=hashlib.sha256(p.read_bytes()).hexdigest()
(out/'sources.json').write_text(json.dumps(manifest,indent=2)+'\n')
print('Generated',mode,'measurement copies in',out)
