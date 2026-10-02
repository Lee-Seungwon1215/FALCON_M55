.syntax unified
.thumb
.arch armv8.1-m.main
.arch_extension mve
.fpu fpv5-d16

/* Test-only n>=4, n%4==0, len>0 selector; params={n,len,sch,scl}.
 * len<2^24 is the original contract. Vector j equality implements the
 * original three limb masks. Loads are UNPREDICATED and every limb is read,
 * so a coefficient/scale predicate can never suppress the next load.
 */
.section .text.trial_fixed_input_predicate,"ax",%progbits
.balign 4
.global trial_fixed_input_predicate
.type trial_fixed_input_predicate,%function
.thumb_func
trial_fixed_input_predicate:
    push {r4-r11,lr}
    sub sp,sp,#4
    vpush {d8-d13}
    ldr r3,[r2,#0]
    ldr r4,[r2,#4]
    ldr r6,[r2,#8]
    ldr r7,[r2,#12]
    lsl r5,r3,#2
    mov r2,r1
    sub r8,r6,#1
    ubfx r8,r8,#0,#24
    ubfx r9,r6,#0,#24
    add r10,r6,#1
    ubfx r10,r10,#0,#24
.Lpredicate_block:
    mov r1,r2
    mov.w r11,#0
    vmov.i32 q0,#0
    vmov.i32 q1,#0
    vmov.i32 q2,#0
.Lpredicate_limb:
    vldrw.u32 q3,[r1]
    add r1,r1,r5
    vdup.32 q5,r11
    vpt.i32 eq,q5,r8
    vorrt q0,q0,q3
    vpt.i32 eq,q5,r9
    vorrt q1,q1,q3
    vpt.i32 eq,q5,r10
    vorrt q2,q2,q3
    add r11,r11,#1
    cmp r11,r4
    bne .Lpredicate_limb
    vshr.u32 q5,q3,#30
    vneg.s32 q5,q5
    vshr.u32 q5,q5,#1
    sub r1,r4,r6
    asr r12,r1,#31
    vdup.32 q4,r12
    vand q4,q4,q5
    vorr q0,q0,q4
    sub r1,r1,#1
    asr r12,r1,#31
    vdup.32 q4,r12
    vand q4,q4,q5
    vorr q1,q1,q4
    sub r1,r1,#1
    asr r12,r1,#31
    vdup.32 q4,r12
    vand q4,q4,q5
    vorr q2,q2,q4
    vshr.u32 q4,q2,#30
    vshl.i32 q4,q4,#31
    vorr q2,q2,q4
    rsb r12,r7,#1
    vdup.32 q6,r12
    vshl.u32 q4,q0,q6
    rsb r12,r7,#32
    vdup.32 q6,r12
    vshl.u32 q5,q1,q6
    vorr q4,q4,q5
    rsb r12,r7,#0
    vdup.32 q6,r12
    vshl.u32 q0,q1,q6
    rsb r12,r7,#31
    vdup.32 q6,r12
    vshl.u32 q1,q2,q6
    vorr q1,q0,q1
    vmov q0,q4
    vst20.32 {q0,q1},[r0]
    vst21.32 {q0,q1},[r0]
    add r0,r0,#32
    add r2,r2,#16
    subs r3,r3,#4
    bne .Lpredicate_block
    vpop {d8-d13}
    add sp,sp,#4
    pop {r4-r11,pc}
.size trial_fixed_input_predicate,.-trial_fixed_input_predicate
