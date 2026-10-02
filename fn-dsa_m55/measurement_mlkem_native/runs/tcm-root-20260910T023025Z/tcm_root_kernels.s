/* Diagnostic only: all runtime code/data below are CPU-written to TCM.
 * Main control/vectors/stack reside in reserved AXISRAM. No FN-DSA calls. */
.syntax unified
.thumb
.section .text
.balign 4
.global root_prepare
.thumb_func
root_prepare:
    /* r4=code destination, r6=kernel source, r7=kernel length,
     * r8=data address. GDB only supplies register arguments. */
    mov r0, r4
1:  ldrb r1, [r6], #1
    strb r1, [r0], #1
    subs r7, #1
    bne 1b
    mov r0, r8
    movs r2, #64
    ldr r3, =0x5a5aa5a5
2:  eor r1, r0, r3
    str r1, [r0], #4
    subs r2, #1
    bne 2b
    dsb
    isb
.global root_ready
.thumb_func
root_ready:
    bkpt #0
    b root_ready
.global root_call
.thumb_func
root_call:
    /* r4=kernel, r1=data, r2=byte count, r0=copy destination if needed */
    blx r4
    b probe_done
.ltorg

.macro BEGIN name
.balign 4
.global \name
.thumb_func
\name:
.endm
.macro END name
.global \name\()_end
\name\()_end:
.endm

BEGIN root_ldm_copy
    push {r4-r7}
    mov r3, r0
1:  ldmia r1!, {r4-r7}
    stmia r3!, {r4-r7}
    subs r2, #16
    bne 1b
    pop {r4-r7}
    bx lr
END root_ldm_copy

BEGIN root_ldm_sum
    push {r4-r6}
    movs r0, #0
1:  ldmia r1!, {r3-r6}
    add r0, r3
    add r0, r4
    add r0, r5
    add r0, r6
    subs r2, #16
    bne 1b
    pop {r4-r6}
    bx lr
END root_ldm_sum

BEGIN root_ldr_sum
    movs r0, #0
1:  ldr r3, [r1], #4
    add r0, r3
    subs r2, #4
    bne 1b
    bx lr
END root_ldr_sum

BEGIN root_ldrd_sum
    push {r4}
    movs r0, #0
1:  ldrd r3, r4, [r1], #8
    add r0, r3
    add r0, r4
    subs r2, #8
    bne 1b
    pop {r4}
    bx lr
END root_ldrd_sum

BEGIN root_ldr_barrier_sum
    movs r0, #0
1:  ldr r3, [r1], #4
    dsb
    isb
    add r0, r3
    subs r2, #4
    bne 1b
    bx lr
END root_ldr_barrier_sum
.section .note.GNU-stack,"",%progbits
