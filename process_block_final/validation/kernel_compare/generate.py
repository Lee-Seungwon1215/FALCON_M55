"""Time iota/control and an optional last-row-plus-iota scope.
plain is byte-identical production ASM. aligned is a measurement-only control.
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
category = {'plain':0, 'aligned':0, 'iota':1, 'tail':2, 'core':5}[mode]
subprocess.run([sys.executable, str(PARENT / 'generate.py'), str(out), impl, '24'], check=True)
source = PARENT.parent / ('sha3_cm4.s' if impl == 'ref' else 'sha3_cm55.s')
original = source.read_text()
asm = original

def once(a, b):
    global asm
    assert asm.count(a) == 1, (a, asm.count(a))
    asm = asm.replace(a, b)

def boundary(c, enter=True):
    return '    PART_' + ('ENTER ' if enter else 'LEAVE ') + str(c) + '\n'

if mode not in ('plain', 'aligned'):
    once('\t@ Here begins the preamble', boundary(5)+'\t@ Here begins the preamble')
    once('\t@ 2, 8, 14, 15, 21', boundary(2)+'\t@ 2, 8, 14, 15, 21')
    once('\t@ XOR next round constant into A[0]', boundary(1)+'\t@ XOR next round constant into A[0]')
    once('\t@ Permute the state words for next round.', boundary(1,False)+boundary(2,False)+'\t@ Permute the state words for next round.')
    once('fndsa_sha3_process_block__final:\n', 'fndsa_sha3_process_block__final:\n'+boundary(1,False)+boundary(2,False)+boundary(5,False))
    epilogue = re.search(r'\tadd\tsp, #[0-9]+\n', asm)
    once(epilogue[0], '    PART_TAP 3\n'+epilogue[0])
    asm=asm.replace('fndsa_sha3_process_block','profile_body')
    stripped=re.sub(r'(?m)^\s*PART_(?:ENTER|LEAVE|TAP) [0-9]+\n','',asm).replace('profile_body','fndsa_sha3_process_block')
    assert re.sub(r'\s+','',stripped)==re.sub(r'\s+','',original)

if mode == 'aligned':
    # Same function entry and preamble address; production has no padding.
    # IO-only used this same +0x800 control. Do not pin a too-distant RC table.
    once('\t@ Here begins the preamble',
         '    b.w .Lmeasurement_core\n'
         '    .org fndsa_sha3_process_block+0x800\n'
         '.Lmeasurement_core:\n\t@ Here begins the preamble')

probes = r'''
.macro PART_TAP event
    push {r0,r1,r2}
    movw r1,#:lower16:part_cursor
    movt r1,#:upper16:part_cursor
    ldr r2,[r1]
    movw r0,#0x1004
    movt r0,#0xe000
    ldr.w r0,[r0]
    str r0,[r2],#4
    movw r0,#\event
    str r0,[r2],#4
    str r2,[r1]
    pop {r0,r1,r2}
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

at = asm.index('.macro')
asm = asm[:at] + f'.equ PROFILE_CATEGORY,{category}\n' + probes + asm[at:]
adapters = (PARENT / 'adapters.s').read_text()
start = adapters.index('.macro PROCESS_BENCH')
stop = adapters.index('.endm', start)
block = adapters[start:stop].replace('    push {r4-r8,lr}', '    push.w {r4-r10,lr}')
block = block.replace('    mov r4,r0', '''    mov r8,sp
    mrs r9,psplim
    mov.w r2,#0
    msr psplim,r2
    movw r2,#:lower16:part_stack_top
    movt r2,#:upper16:part_stack_top
    mov sp,r2
    mov r4,r0''')
block = block.replace('    pop {r4-r8,pc}', '    mov sp,r8\n    msr psplim,r9\n    pop.w {r4-r10,pc}')
asm += '\n' + adapters[:start] + block + adapters[stop:]
asm += r'''
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
.global part_cursor
part_cursor:
    .space 4
'''
if mode not in ('plain', 'aligned'):
    asm += r'''
.section .text.profile_entry,"ax",%progbits
.balign 32
.global fndsa_sha3_process_block
.type fndsa_sha3_process_block,%function
.thumb_func
fndsa_sha3_process_block:
    push.w {r4,lr}
    movw r4,#:lower16:part_cursor
    movt r4,#:upper16:part_cursor
    movw r12,#:lower16:part_ticks
    movt r12,#:upper16:part_ticks
    str r12,[r4]
    bl profile_body
    pop.w {r4,pc}
.size fndsa_sha3_process_block,.-fndsa_sha3_process_block
'''
asm += r'''
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
    movw r1,#:lower16:part_cursor
    movt r1,#:upper16:part_cursor
    movw r2,#:lower16:part_ticks
    movt r2,#:upper16:part_ticks
    str r2,[r1]
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
(out / 'sha3_benchmark.s').write_text(asm)
bench = (out / 'benchmark.c').read_text().replace('static struct { uint64_t pre[4], a[25], post[4]; } state', 'extern struct { uint64_t pre[4], a[25], post[4]; } state')
bench = bench.replace('int mlk_test_main(', (HERE / 'measure.inc').read_text()+'\nint mlk_test_main(', 1)
bench = bench.replace('    timing_classes();', '    timing_classes();\n    if (part_measure()) return 10;', 1)
bench = bench.replace('"PROFILE_VARIANT"', json.dumps(variant)).replace('PROFILE_CATEGORY', str(category))
(out / 'benchmark.c').write_text(bench)
spec = json.loads((out / 'sources.json').read_text())
spec.update(variant=variant, category=category, production_sha256=hashlib.sha256(original.encode()).hexdigest())
spec['harness_sha256'] = {str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in list(HERE.iterdir())+[PARENT/'benchmark.c', PARENT/'adapters.s', PARENT/'generate.py', PARENT/'scope_check.py'] if p.is_file() and (p.suffix in ('.py', '.sh', '.inc', '.conf') or p.name == 'CMakeLists.txt')}
spec['generated_sha256'] = {p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in out.iterdir() if p.name!='sources.json'}
(out / 'sources.json').write_text(json.dumps(spec, indent=2)+'\n')
