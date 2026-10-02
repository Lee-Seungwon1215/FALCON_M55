/* Standalone diagnostic only. No FN-DSA, Zephyr, flash, clock or ECC changes.
 * Runs from reserved AXISRAM; initializes owned TCM and compares identical
 * scalar LDR/BX bytes executing in each 64 KiB ITCM window. */
.syntax unified
.arch armv8.1-m.main
.thumb
.section .text
.balign 128
.global probe_vectors
probe_vectors:
    .word 0x340bf000
    .word probe_init
    .rept 14
    .word probe_fault
    .endr
.global probe_init
.thumb_func
probe_init:
    cpsid i
    ldr r0, =probe_vectors
    ldr r1, =0xe000ed08
    str r0, [r1]
    dsb
    isb
    movs r2, #0
    movs r3, #0
    ldr r0, =0x10000000
    ldr r1, =0x10040000
1:  strd r2, r3, [r0], #8
    cmp r0, r1
    blo 1b
    ldr r0, =0x30000000
    ldr r1, =0x30040000
2:  strd r2, r3, [r0], #8
    cmp r0, r1
    blo 2b
    ldr r4, =0x10001000
    ldr r5, =0x10041000
    adr r0, probe_body
    bic r0, r0, #1 /* Thumb function symbol used here as a data address. */
    ldrd r2, r3, [r0]
3:  strd r2, r3, [r4]
    ldrd r6, r7, [r0, #8]
    strd r6, r7, [r4, #8]
    add.w r4, r4, #0x10000
    cmp r4, r5
    blo 3b
    ldr r2, =0x13579bdf
    ldr r3, =0x2468ace0
    ldr r4, =0x10000800
    ldr r5, =0x10040800
4:  mov r2, r4
    strd r2, r3, [r4]
    add.w r4, r4, #0x10000
    cmp r4, r5
    blo 4b
    ldr r4, =0x30000800
    ldr r5, =0x30040800
5:  mov r2, r4
    strd r2, r3, [r4]
    add.w r4, r4, #0x10000
    cmp r4, r5
    blo 5b
    ldr r4, =0x34080800
    mov r2, r4
    strd r2, r3, [r4]
    dsb
    isb
.global probe_ready
.thumb_func
probe_ready:
    bkpt #0
    b probe_ready

/* Inputs set by GDB while halted: r4=callee|1,r1=source,r5=iterations. */
.global probe_call
.thumb_func
probe_call:
    mov r6, r1
6:  blx r4
    cmp r0, r6
    bne probe_mismatch
    subs r5, #1
    bne 6b
    b probe_done
.global probe_memcpy_call
.thumb_func
probe_memcpy_call:
    blx r4
.global probe_done
.thumb_func
probe_done:
    bkpt #0
    b probe_done
.global probe_mismatch
.thumb_func
probe_mismatch:
    bkpt #0
    b probe_mismatch
.global probe_fault
.thumb_func
probe_fault:
    bkpt #0
    b probe_fault
.balign 8
.global probe_body
.thumb_func
probe_body:
    ldr r0, [r1]
#ifdef PROBE_BRANCH
    bx r7
#else
    bx lr
#endif
    nop
    nop
.global probe_return
.thumb_func
probe_return:
    bx lr
    nop
    nop
    nop
.ltorg
