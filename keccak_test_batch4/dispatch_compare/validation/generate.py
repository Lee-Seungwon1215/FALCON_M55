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
candidate=sys.argv[3]
assert candidate in ('A_four_only','B_three_plus','C_two_plus')
PROD=HERE.parent/candidate
out=Path(sys.argv[1]).resolve()
mode=sys.argv[2]
assert mode in ('control','profile')
production=out/'production';reference=out/'reference'
production.mkdir(parents=True,exist_ok=True);reference.mkdir(parents=True,exist_ok=True)
manifest={'mode':mode,'candidate':candidate,'original':{},'generated':{}}
for p in PROD.iterdir():
    if p.suffix in ('.c','.h','.s'):
        (production/p.name).write_bytes(p.read_bytes())
        manifest['original'][str(p)]=hashlib.sha256(p.read_bytes()).hexdigest()
# The comparison library has its own control/sampler TUs and private headers.
# Only byte-identical arithmetic/Keccak implementations are shared in this
# measurement ELF. Production folders remain independently buildable.
renamed='''keygen keygen_batch4_temp_size keygen_seeded keygen_seeded_batch4_temp
keygen_seeded_temp keygen_temp sample_f sample_f_prefetched sample_f_x4
sign sign_batch4_temp_size sign_seeded sign_seeded_batch4_temp sign_seeded_temp sign_temp
sign_weak sign_weak_seeded sign_weak_seeded_temp sign_weak_temp
sign_core sign_core_batch4 sign_core_prefetched ffsamp_fft ffsamp_fft_deepest
sampler_next ffsamp_fft_inner gaussian0_helper sampler_extract shake_batch4_prepare
sign_batch4_clear batch4_clear shake4_absorb shake4_block shake4_export_lane
shake4_hash_to_point shake4_permute_mask shake4_stream_init shake4_stream_read
shake4_stream_reset_lane verify verify_batch4_temp verify_batch4_temp_size verify_temp
verify_weak verify_weak_temp'''.split()
symbols={'fndsa_'+s for s in renamed}
separate={'kgen.c','kgen_gauss.c','sign.c','sign_core.c','sign_sampler.c',
          'sign_sampler_cm4.s','shake_batch4.c','shake_independent4.c','vrfy.c'}
for p in (HERE.parent/'ref_prefix').iterdir():
    if p.suffix not in ('.c','.h','.s'):continue
    manifest['original'][str(p)]=hashlib.sha256(p.read_bytes()).hexdigest()
    if p.suffix in ('.c','.s') and p.name not in separate:
        assert p.read_bytes()==(PROD/p.name).read_bytes(),('shared source differs',p)
    source=re.sub(r'\bfndsa_[A-Za-z0-9_]+\b',
        lambda m:'prefix_'+m[0] if m[0] in symbols else m[0],p.read_text())
    (reference/p.name).write_text(source)

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
 ('shake_independent4.c','fndsa_shake4_scalar_lane','fndsa_shake4_scalar_lane',15),
]
if mode=='profile':
    p=production/'shake_independent4.c'
    source=p.read_text()
    source=source.replace('#include "fndsa_batch4.h"',
        '#include "fndsa_batch4.h"\n#include "profile.h"')
    source=source.replace('void fndsa_shake4_permute_mask(fndsa_shake4_state *s, unsigned mask)\n{',
        'void fndsa_shake4_permute_mask(fndsa_shake4_state *s, unsigned mask)\n{\n    profile_mask(mask);')
    p.write_text(source)
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
# Only rename the measurement copy's filename for precise linker placement.
(production/'dispatch_candidate.c').write_bytes((production/'shake_independent4.c').read_bytes())
for p in out.rglob('*'):
    if p.is_file() and p.suffix in ('.c','.h','.s'):
        manifest['generated'][str(p.relative_to(out))]=hashlib.sha256(p.read_bytes()).hexdigest()
(out/'sources.json').write_text(json.dumps(manifest,indent=2)+'\n')
print('Generated',mode,'measurement copies in',out)
