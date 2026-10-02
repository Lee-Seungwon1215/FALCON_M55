@ Copyright 2025 NXP
@ SPDX-License-Identifier: MIT

.syntax	unified
.cpu	cortex-m4
.file	"triple_float_extra.s"
.text

.align	2
.global tw_div_fast_asm
.thumb
.thumb_func
.type	tw_div_fast_asm, %function
tw_div_fast_asm:
        vldr.32 s15, =1065353217
        vldr.32 s11, =1065353214        
        vdiv.f32        s12, s15, s3
        vfnms.f32 s15, s12, s3
        vneg.f32        s15, s15
        vmul.f32        s14, s12, s11
        vfms.f32 s15, s12, s4
        vmov.f32        s13, s14
        vfnms.f32 s13, s12, s11
        vfma.f32 s13, s12, s15
        vadd.f32        s8, s13, s14
        vmov r2, s2
        vsub.f32        s14, s8, s14
        vmul.f32        s15, s4, s8
        vsub.f32        s13, s13, s14
        vmul.f32        s6, s8, s3
        vmul.f32        s12, s13, s3
        vmov.f32        s9, s6
        vadd.f32        s14, s15, s12
        vfnms.f32 s9, s8, s3
        vsub.f32        s7, s14, s12
        vadd.f32        s10, s9, s14
        vsub.f32        s11, s14, s7
        vsub.f32        s2, s10, s14
        vsub.f32        s7, s15, s7
        vsub.f32        s11, s12, s11
        vmov r1, s1
        vsub.f32        s1, s10, s2
        vadd.f32        s11, s11, s7
        vfnms.f32 s15, s8, s4
        vfnms.f32 s12, s13, s3
        vfma.f32 s12, s8, s5
        vadd.f32        s15, s15, s12
        vsub.f32        s9, s9, s2
        vsub.f32        s14, s14, s1
        vmov.f32        s12, s11
        vfma.f32 s12, s13, s4
        vadd.f32        s15, s15, s12
        vadd.f32        s14, s14, s9
        vneg.f32        s15, s15
        vsub.f32        s12, s15, s14
        vsub.f32        s11, s12, s10
        vadd.f32        s14, s14, s12
        vsub.f32        s9, s11, s6
        vadd.f32        s10, s10, s11
        vadd.f32        s9, s9, s6
        vsub.f32        s12, s12, s10
        vsub.f32        s11, s11, s9
        vsub.f32        s15, s15, s14
        vadd.f32        s7, s12, s11
        vsub.f32        s11, s7, s11
        vsub.f32        s12, s12, s11
        vcmp.f32        s12, #0
        vmrs    APSR_nzcv, FPSCR
        beq     .L5
        vadd.f32        s14, s15, s12
.align 2
.L6:
        vmov s3, r1 @ s2 to s3
        vmul.f32        s9, s13, s0 @ s3 to s0
        vmul.f32        s15, s8, s3 @ s2 to s3
        vmul.f32        s4, s8, s0 @ s3 to s0
        vadd.f32        s12, s15, s9
        vmov.f32        s5, s4
        vfnms.f32 s5, s8, s0 @ s3 to s0
        vadd.f32        s6, s5, s12
        vsub.f32        s10, s12, s9
        vsub.f32        s1, s6, s12
        vsub.f32        s2, s15, s10 @ s0 to s2
        vsub.f32        s11, s12, s10
        vsub.f32        s10, s6, s1
        vsub.f32        s11, s9, s11
        vsub.f32        s12, s12, s10
        vfnms.f32 s9, s13, s0 @s3 to s0
        vmov s10, r2
        vfnms.f32 s15, s8, s3 @ s2 to s3
        vfma.f32 s9, s8, s10
        vsub.f32        s5, s5, s1
        vadd.f32        s15, s15, s9
        vadd.f32        s12, s12, s5
        vadd.f32        s11, s11, s2 @ s0 to s2
        vfma.f32 s11, s13, s3 @ s2 to s3
        vadd.f32        s15, s15, s11
        vadd.f32        s13, s12, s15
        vadd.f32        s10, s6, s13
        vsub.f32        s12, s13, s12
        vadd.f32        s11, s4, s10
        vsub.f32        s6, s10, s6
        vsub.f32        s4, s11, s4
        vsub.f32        s13, s13, s6
        vsub.f32        s10, s10, s4
        vsub.f32        s15, s15, s12
        vadd.f32        s9, s13, s10
        vsub.f32        s10, s9, s10
        vsub.f32        s13, s13, s10
        vcmp.f32        s13, #0
        vmrs    APSR_nzcv, FPSCR
        beq     .L7
        vadd.f32        s15, s15, s13
.align 2
.L8:
        vmul.f32        s13, s7, s11
        vadd.f32        s10, s13, s9
        vmov.f32        s12, s13
        vsub.f32        s8, s10, s9
        vfnms.f32 s12, s11, s7
        vsub.f32        s13, s13, s8
        vfma.f32 s12, s9, s7
        vfma.f32 s12, s11, s14
        vadd.f32        s13, s13, s12
        vadd.f32        s13, s13, s15
        vadd.f32        s2, s10, s13
        vadd.f32        s0, s2, s11
        vsub.f32        s10, s2, s10
        vsub.f32        s11, s0, s11
        vsub.f32        s13, s13, s10
        vsub.f32        s2, s2, s11
        vadd.f32        s1, s13, s2
        vsub.f32        s2, s1, s2
        vsub.f32        s2, s13, s2
        vmov.f32 s15, s2
        vmov.f32 s14, s1
        vmov.f32 s13, s0
        bx      lr
.align 2
.L5:
        vadd.f32        s14, s15, s7
        vsub.f32        s12, s14, s7
        vmov.f32        s7, s14
        vsub.f32        s14, s15, s12
        b       .L6
.align 2
.L7:
        vadd.f32        s13, s15, s9
        vsub.f32        s12, s13, s9
        vmov.f32        s9, s13
        vsub.f32        s15, s15, s12
        b       .L8
