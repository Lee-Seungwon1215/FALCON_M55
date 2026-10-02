"""Instrument only a generated copy; dead GPRs R2/R3, no flags/Q/SP changes.

77 identical-size timestamp taps. Production source is never rewritten.
Calibration records adjacent taps to measure interval read/store overhead.
"""
import hashlib
import json
from pathlib import Path
import subprocess
import sys

HERE=Path(__file__).resolve().parent
PARENT=HERE.parent
PRODUCTION=PARENT.parent/'sha3_cm55.s'
out=Path(sys.argv[1]); variant=sys.argv[2]
assert variant in ('plain','trace')
subprocess.run([sys.executable,str(PARENT/'generate.py'),str(out),'mve','24'],check=True)
asm=PRODUCTION.read_text()
original=asm
assert '.macro K_SPLIT4' in original, 'Requires full-MVE family'
tap=r'''
@ R2/R3 are dead at every chosen boundary. All six instructions preserve APSR.
@ Global addresses, indices and control flow are public constants/counters.
.macro PHASE_TAP slot, indexed=0
    movw r2,#0x1004
    movt r2,#0xe000
    ldr.w r3,[r2]
    movw r2,#:lower16:(phase_ticks+4*(\slot))
    movt r2,#:upper16:(phase_ticks+4*(\slot))
    .if \indexed
        str.w r3,[r2,r11,lsl #2]
    .else
        str.w r3,[r2]
    .endif
.endm
'''
if variant=='trace':
    asm=asm.replace('.global fndsa_sha3_process_block',tap+'\n.global fndsa_sha3_process_block',1)
    changes={
        'fndsa_sha3_process_block:\n':'fndsa_sha3_process_block:\n    PHASE_TAP 0\n',
        '    K_INITIAL_PARITY 0\n':'    PHASE_TAP 1\n    K_INITIAL_PARITY 0\n',
        '.Lkeccak_mve_round:\n':'.Lkeccak_mve_round:\n    PHASE_TAP 8,1\n',
        '    K_CHI_PLANE 0\n':'    PHASE_TAP 40,1\n    K_CHI_PLANE 0\n',
        '    @ Iota is also MVE:':'    PHASE_TAP 72,1\n    @ Iota is also MVE:',
        '    bne.w .Lkeccak_mve_round\n':'    bne.w .Lkeccak_mve_round\n    PHASE_TAP 2\n',
        '    K_OUTPUT_ROW 0\n':'    PHASE_TAP 3\n    K_OUTPUT_ROW 0\n',
        '    ldr r2,[sp,#K_OLDSP]':'    PHASE_TAP 4\n    ldr r2,[sp,#K_OLDSP]',
    }
    for a,b in changes.items():
        assert asm.count(a)==1,(a,asm.count(a))
        asm=asm.replace(a,b)
else:
    asm+=tap
asm+='\n'+(PARENT/'adapters.s').read_text()
asm+=r'''
@ Calibration of fixed/indexed store forms, with no crypto work in between.
.balign 32
.global phase_calibrate
.type phase_calibrate,%function
.thumb_func
phase_calibrate:
    push.w {r11,lr}
    mov.w r11,#1
    PHASE_TAP 104
    PHASE_TAP 105
    PHASE_TAP 106,1
    PHASE_TAP 107,1
    PHASE_TAP 109
    PHASE_TAP 110
    pop.w {r11,pc}
.size phase_calibrate,.-phase_calibrate
'''
(out/'sha3_benchmark.s').write_text(asm)
bench=(out/'benchmark.c').read_text()
# Keep all original oracle/SHAKE/ABI/timing tests. The extra measurements run
# after them, outside the kernel timers, and retain the same production entry.
support=(HERE/'measure.inc').read_text()
bench=bench.replace('int mlk_test_main(',support+'\nint mlk_test_main(',1)
bench=bench.replace('    timing_classes();','    timing_classes();\n    phase_measure();',1)
bench=bench.replace('"PROFILE_VARIANT"','"'+variant+'"')
bench=bench.replace('PROFILE_TAPS',str(77 if variant=='trace' else 0))
(out/'benchmark.c').write_text(bench)
spec=json.loads((out/'sources.json').read_text())
spec['variant']=variant
spec['production_sha256']=hashlib.sha256(original.encode()).hexdigest()
spec['taps_per_call']=77 if variant=='trace' else 0
spec['harness_sha256']={str(p):hashlib.sha256(p.read_bytes()).hexdigest()
                       for p in (HERE/'generate.py',HERE/'measure.inc',
                                 PARENT/'benchmark.c',PARENT/'adapters.s')}
spec['generated_sha256']={p.name:hashlib.sha256(p.read_bytes()).hexdigest()
                         for p in out.iterdir() if p.name!='sources.json'}
(out/'sources.json').write_text(json.dumps(spec,indent=2)+'\n')
