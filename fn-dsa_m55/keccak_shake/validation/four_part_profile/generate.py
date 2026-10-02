"""Independent, exclusive phase timers in generated copies, never production.

Four separate trace binaries per implementation: IO, representation conversion,
round arithmetic (excluding column parity), and column parity. Shared loads in
the reference's fused permutation/parity belong to round work; fused EOR/ROR
instructions belong to parity. This is a stated attribution, not an assertion
that overlapping pipeline costs are uniquely separable.
"""
import hashlib
import json
from pathlib import Path
import re
import subprocess
import sys

HERE = Path(__file__).resolve().parent
PARENT = HERE.parent
out = Path(sys.argv[1])
variant = sys.argv[2]
impl, mode = variant.split('-')
category = {'plain': 0, 'io': 1, 'bits': 2, 'round': 3, 'xor': 4, 'core': 5}[mode]
subprocess.run([sys.executable, str(PARENT/'generate.py'), str(out), impl, '24'], check=True)
source = PARENT.parent/('sha3_cm4.s' if impl == 'ref' else 'sha3_cm55.s')
original = source.read_text()
asm = original

def once(a, b):
    global asm
    assert asm.count(a) == 1, (a, asm.count(a))
    asm = asm.replace(a, b)

def boundary(c, enter=True):
    return '    PART_' + ('ENTER ' if enter else 'LEAVE ') + str(c) + '\n'

def nested(block, parent, child):
    return boundary(parent, False)+boundary(child)+block+boundary(child, False)+boundary(parent)

if mode != 'plain':
    if impl == 'ref':
        assert not re.search(r'\br9\b', original)
        once('\tmov.n\tr14, r1\n', '\tmov.n\tr14, r1\n'+boundary(1))
        # Only actual helper calls, not the private helpers themselves. Preserve LR.
        asm = re.sub(r'(?m)^\tbl\tbit_(?:split|merge)_[1-5]\n',
                     lambda m: nested(m[0], 1, 2), asm)
        once('\t@ Here begins the preamble', boundary(1,False)+boundary(5)+boundary(4)+'\t@ Here begins the preamble')
        once('\t@ We will perform 24 rounds.', boundary(4,False)+'\t@ We will perform 24 rounds.')
        once('fndsa_sha3_process_block__loop_step2:\n',
             'fndsa_sha3_process_block__loop_step2:\n'+boundary(3))
        # These rotations prepare the accumulator copies, not the stored state.
        start = asm.index('.macro\tA_LD_ST ')
        stop = asm.index('\n.endm', start)
        block = asm[start:stop]
        block = re.sub(r'(?m)^\tROR_WORD[^\n]*\n', lambda m:nested(m[0],3,4),block+'\n').rstrip('\n')
        asm = asm[:start]+block+asm[stop:]
        start = asm.index('.macro\tA_LD_XOR_ST ')
        stop = asm.index('\n.endm',start)
        block = asm[start:stop]
        block = re.sub(r'(?m)^\tXOR_ROR_WORD[^\n]*\n',lambda m:nested(m[0],3,4),block+'\n').rstrip('\n')
        asm = asm[:start]+block+asm[stop:]
        once('\tror\tr2, r2, #10\n\tror\tr3, r3, #10\n',
             nested('\tror\tr2, r2, #10\n\tror\tr3, r3, #10\n',3,4))
        once('\tb.w\tfndsa_sha3_process_block__loop_step2\n',
             boundary(3,False)+'\tb.w\tfndsa_sha3_process_block__loop_step2\n')
        once('fndsa_sha3_process_block__final:\n',
             'fndsa_sha3_process_block__final:\n'+boundary(3,False)+boundary(5,False)+boundary(1))
        once('\tadd\tsp, #88\n', boundary(1,False)+'    PART_TAP 3\n\tadd\tsp, #88\n')
    else:
        once('    K_INPUT_ROW 0\n', boundary(1)+'    K_INPUT_ROW 0\n')
        for call in ('    K_MERGE4\n','    K_SPLIT4\n'):
            once(call,nested(call,1,2))
        once('    K_INITIAL_PARITY 0\n',boundary(1,False)+boundary(5)+boundary(4)+'    K_INITIAL_PARITY 0\n')
        once('    K_INITIAL_PARITY 160\n','    K_INITIAL_PARITY 160\n'+boundary(4,False))
        once('.Lkeccak_mve_round:\n','.Lkeccak_mve_round:\n'+boundary(3))
        # Contiguous runs only. Probes must never split VPST and its instruction.
        start=asm.index('.macro K_CHI_PLANE ')
        stop=asm.index('\n.endm',start)
        lines=asm[start:stop].splitlines(keepends=True)
        result=[]; run=[]
        def flush():
            if run:
                result.append(nested(''.join(run),3,4)); run.clear()
        for line in lines:
            if re.match(r'\s*(veor q[67],q[67],|vstrw\.32 q[67],\[r6)',line):
                run.append(line if line.endswith('\n') else line+'\n')
            else:
                flush(); result.append(line)
        flush()
        asm=asm[:start]+''.join(result).rstrip('\n')+asm[stop:]
        once('    bne.w .Lkeccak_mve_round\n',boundary(3,False)+'    bne.w .Lkeccak_mve_round\n')
        once('    K_OUTPUT_ROW 0\n',boundary(5,False)+boundary(1)+'    K_OUTPUT_ROW 0\n')
        once('    ldr r2,[sp,#K_OLDSP]\n',boundary(1,False)+'    PART_TAP 3\n    ldr r2,[sp,#K_OLDSP]\n')
    asm = asm.replace('fndsa_sha3_process_block','profile_body')
    # Removing the measurement markers must recover all original operations.
    stripped=re.sub(r'(?m)^\s*PART_(?:ENTER|LEAVE|TAP) [0-9]+\n','',asm)
    stripped=stripped.replace('profile_body','fndsa_sha3_process_block')
    assert re.sub(r'\s+','',stripped)==re.sub(r'\s+','',original)

# Single saved scratch GPR, no APSR, GE, VPR, Q register or LR modification.
# R9 is unused by the production body, and is saved by the entry wrapper.
probes = r'''
.macro PART_TAP event
    push {r0}
    movw r0,#0x1004
    movt r0,#0xe000
    ldr.w r0,[r0]
    str.w r0,[r9],#4
    movw r0,#\event
    str.w r0,[r9],#4
    pop {r0}
.endm
.macro PART_ENTER cat
    .if PROFILE_CATEGORY == \cat
        PART_TAP 1
    .endif
.endm
.macro PART_LEAVE cat
    .if PROFILE_CATEGORY == \cat
        PART_TAP 2
    .endif
.endm
'''
# Put definitions after the architecture directives but before all crypto macros.
at=asm.index('.macro')
asm=asm[:at]+f'.equ PROFILE_CATEGORY,{category}\n'+probes+asm[at:]
adapters=(PARENT/'adapters.s').read_text()
start=adapters.index('.macro PROCESS_BENCH')
stop=adapters.index('.endm',start)
block=adapters[start:stop]
block=block.replace('    push {r4-r8,lr}', '    push.w {r4-r10,lr}')
block=block.replace('    mov r4,r0', '''    mov r8,sp
    mrs r9,psplim
    mov.w r2,#0
    msr psplim,r2
    movw r2,#:lower16:part_stack_top
    movt r2,#:upper16:part_stack_top
    mov sp,r2
    mov r4,r0''')
block=block.replace('    pop {r4-r8,pc}',
    '    mov sp,r8\n    msr psplim,r9\n    pop.w {r4-r10,pc}')
asm+='\n'+adapters[:start]+block+adapters[stop:]
# Keep both test inputs and the timed stack at the SAME low-DTCM addresses.
# All ordinary state guards remain active. The arena is linked before C BSS.
asm+=r'''
.section .bss,"aw",%nobits
.balign 4096
.global state
.type state,%object
state:
    .space 264
.size state,.-state
    .space 8192-264
.global part_stack_top
part_stack_top:
'''
if mode != 'plain':
    asm+=r'''
.section .text.profile_entry,"ax",%progbits
.balign 32
.global fndsa_sha3_process_block
.type fndsa_sha3_process_block,%function
.thumb_func
fndsa_sha3_process_block:
    push.w {r9,lr}
    movw r9,#:lower16:part_ticks
    movt r9,#:upper16:part_ticks
    bl profile_body
    pop.w {r9,pc}
.size fndsa_sha3_process_block,.-fndsa_sha3_process_block
'''
asm+=r'''
.section .text.profile_calibration,"ax",%progbits
.balign 32
.global part_calibrate
.type part_calibrate,%function
.thumb_func
part_calibrate:
    push.w {r4,r8,r9,lr}
    mov r8,sp
    mrs r4,psplim
    movw r0,#:lower16:(state+512)
    movt r0,#:upper16:(state+512)
    msr psplim,r0
    movw r0,#:lower16:part_stack_top
    movt r0,#:upper16:part_stack_top
    mov sp,r0
    movw r9,#:lower16:part_ticks
    movt r9,#:upper16:part_ticks
    .rept 64
    PART_TAP 1
    PART_TAP 2
    .endr
    PART_TAP 3
    mov sp,r8
    msr psplim,r4
    pop.w {r4,r8,r9,pc}
.size part_calibrate,.-part_calibrate
'''
(out/'sha3_benchmark.s').write_text(asm)
bench=(out/'benchmark.c').read_text()
bench=bench.replace('static struct { uint64_t pre[4], a[25], post[4]; } state',
                    'extern struct { uint64_t pre[4], a[25], post[4]; } state')
bench=bench.replace('int mlk_test_main(', (HERE/'measure.inc').read_text()+'\nint mlk_test_main(',1)
bench=bench.replace('    timing_classes();','    timing_classes();\n    if (part_measure()) return 10;',1)
bench=bench.replace('"PROFILE_VARIANT"',json.dumps(variant)).replace('PROFILE_CATEGORY',str(category))
(out/'benchmark.c').write_text(bench)
spec=json.loads((out/'sources.json').read_text())
spec.update(variant=variant,category=category,production_sha256=hashlib.sha256(original.encode()).hexdigest())
spec['harness_sha256']={str(p):hashlib.sha256(p.read_bytes()).hexdigest()
    for p in list(HERE.iterdir())+[PARENT/'benchmark.c',PARENT/'adapters.s',PARENT/'generate.py'] if p.is_file()}
spec['generated_sha256']={p.name:hashlib.sha256(p.read_bytes()).hexdigest()
    for p in out.iterdir() if p.name!='sources.json'}
(out/'sources.json').write_text(json.dumps(spec,indent=2)+'\n')
