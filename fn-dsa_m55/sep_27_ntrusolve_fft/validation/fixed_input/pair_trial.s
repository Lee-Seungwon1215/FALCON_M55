.syntax unified
.thumb
.arch armv8.1-m.main
.arch_extension mve
.fpu fpv5-d16

/* Test-only exact n=2 limb selector. Same params as the incumbent helper:
 * {n=2,len>0,sch,scl}. All len limbs are read in public order.
 * q5 = {j,j,j+1,j+1}: use all four lanes for two limbs of two coefficients.
 * The last odd limb uses exactly two word loads, never input overread.
 * Coefficient/scale-dependent choices use vector predicates, never branches.
 * len<2^24 is the original public contract, so indices need no wrap here.
 */
.section .text.trial_fixed_input_pair2,"ax",%progbits
.balign 4
.global trial_fixed_input_pair2
.type trial_fixed_input_pair2,%function
.thumb_func
trial_fixed_input_pair2:
    push {r4-r11,lr}
    sub sp,sp,#4
    vpush {d8-d13}
    ldr r4,[r2,#4]
    ldr r6,[r2,#8]
    ldr r7,[r2,#12]
    sub r8,r6,#1
    ubfx r8,r8,#0,#24
    ubfx r9,r6,#0,#24
    add r10,r6,#1
    ubfx r10,r10,#0,#24
    vmov.i32 q0,#0
    vmov.i32 q1,#0
    vmov.i32 q2,#0
    vmov.i32 q5,#0
    movs r12,#1
    vmov d11,r12,r12
    movs r12,#2
    lsrs r11,r4,#1
    beq .Lpair_odd
.Lpair_scan:
    vldrw.u32 q3,[r1],#16
    vpt.i32 eq,q5,r8
    vorrt q0,q0,q3
    vpt.i32 eq,q5,r9
    vorrt q1,q1,q3
    vpt.i32 eq,q5,r10
    vorrt q2,q2,q3
    vadd.i32 q5,q5,r12
    subs r11,r11,#1
    bne .Lpair_scan
.Lpair_odd:
    tst r4,#1
    beq .Lpair_combine
    vmov.i32 q3,#0
    vldr d6,[r1]
    add r1,r1,#8
    vpt.i32 eq,q5,r8
    vorrt q0,q0,q3
    vpt.i32 eq,q5,r9
    vorrt q1,q1,q3
    vpt.i32 eq,q5,r10
    vorrt q2,q2,q3
.Lpair_combine:
    /* Merge even/odd limb positions without mixing the two coefficients. */
    vmov r8,r9,d0
    vmov r10,r11,d1
    orr r8,r8,r10
    orr r9,r9,r11
    vmov d0,r8,r9
    vmov r8,r9,d2
    vmov r10,r11,d3
    orr r8,r8,r10
    orr r9,r9,r11
    vmov d2,r8,r9
    vmov r8,r9,d4
    vmov r10,r11,d5
    orr r8,r8,r10
    orr r9,r9,r11
    vmov d4,r8,r9
    /* Last true limb supplies the original sign-extension word. */
    vldr d6,[r1,#-8]
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
    vmov r4,r5,d8
    vmov r6,r7,d2
    str r4,[r0,#0]
    str r6,[r0,#4]
    str r5,[r0,#8]
    str r7,[r0,#12]
    vpop {d8-d13}
    add sp,sp,#4
    pop {r4-r11,pc}
.size trial_fixed_input_pair2,.-trial_fixed_input_pair2
