@ Copyright 2025 NXP
@ SPDX-License-Identifier: MIT

.syntax	unified
.cpu	cortex-m4
.file	"triple_float.s"
.text

	.global	tw_sum_asm
	.thumb
	.thumb_func
	.type	tw_sum_asm, %function
tw_sum_asm:
        vabs.f32        s15, s0
        vabs.f32        s14, s3
        vcmpe.f32       s15, s14
        vmrs    APSR_nzcv, FPSCR
        sub     sp, sp, #64
        vmov.f32        s10, s3
        vmov.f32        s9, s1
        vmov.f32        s7, s2
        ble     .L37
        vabs.f32        s15, s1
        vcmpe.f32       s14, s15
        vmrs    APSR_nzcv, FPSCR
        vmov.f32        s6, s0
        bpl     .L38
        vabs.f32        s15, s2
        vcmpe.f32       s14, s15
        vmrs    APSR_nzcv, FPSCR
        bmi     .L22
        vabs.f32        s14, s4
        vcmpe.f32       s15, s14
        vmrs    APSR_nzcv, FPSCR
        it      le
        vmovle.f32      s7, s4
        it      le
        vmovle.f32      s4, s2
.L9:
        vadd.f32        s15, s5, s4
        vadd.f32        s13, s15, s7
        vsub.f32        s14, s15, s5
        vadd.f32        s12, s13, s10
        vsub.f32        s2, s13, s15
        vadd.f32        s11, s9, s12
        vsub.f32        s1, s15, s14
        vadd.f32        s8, s6, s11
        vsub.f32        s4, s4, s14
        vsub.f32        s14, s13, s2
        vsub.f32        s3, s12, s13
        vsub.f32        s14, s15, s14
        vsub.f32        s15, s8, s11
        vsub.f32        s0, s11, s12
        vsub.f32        s6, s6, s15
        vsub.f32        s15, s8, s15
        vsub.f32        s5, s5, s1
        vsub.f32        s15, s11, s15
        vsub.f32        s1, s12, s3
        vadd.f32        s15, s15, s6
        vsub.f32        s11, s11, s0
        vadd.f32        s6, s8, s15
        vsub.f32        s7, s7, s2
        vsub.f32        s8, s6, s8
        vsub.f32        s13, s13, s1
        vsub.f32        s15, s15, s8
        vsub.f32        s10, s10, s3
        vsub.f32        s12, s12, s11
        vsub.f32        s9, s9, s0
        vcmp.f32        s15, #0
        vmrs    APSR_nzcv, FPSCR
        vadd.f32        s5, s5, s4
        vadd.f32        s14, s14, s7
        vadd.f32        s13, s13, s10
        vadd.f32        s12, s12, s9
        bne     .L29
        vmov.f32        s15, s6
        vldr.32 s6, [sp, #40]
        movs    r1, #2
        movs    r2, #1
        movs    r3, #0
.L17:
        vadd.f32        s11, s15, s12
        vstr.32 s6, [sp, #40]
        vsub.f32        s15, s11, s15
        vsub.f32        s12, s12, s15
        vcmp.f32        s12, #0
        vmrs    APSR_nzcv, FPSCR
        beq     .L18
        add     r3, sp, r3, lsl #2
        vstr.32 s11, [r3, #40]
        mov     r3, r2
        vmov.f32        s11, s12
        mov     r2, r1
.L18:
        vadd.f32        s15, s11, s13
        vsub.f32        s11, s15, s11
        vsub.f32        s13, s13, s11
        vcmp.f32        s13, #0
        vmrs    APSR_nzcv, FPSCR
        beq     .L19
        add     r3, sp, r3, lsl #2
        vstr.32 s15, [r3, #40]
        mov     r3, r2
        vmov.f32        s15, s13
        adds    r2, r2, #1
.L19:
        vadd.f32        s13, s15, s14
        vsub.f32        s15, s13, s15
        vsub.f32        s15, s14, s15
        vcmp.f32        s15, #0
        vmrs    APSR_nzcv, FPSCR
        beq     .L20
        vadd.f32        s14, s15, s5
        add     r1, sp, r3, lsl #2
        vsub.f32        s15, s14, s15
        add     r2, sp, r2, lsl #2
        vsub.f32        s5, s5, s15
        vstr.32 s13, [r1, #40]
        vstr.32 s14, [r2, #40]
        vstr.32 s5, [r1, #48]
        vldr.32 s2, [sp, #48]
.L21:
		# vmov.f32 s15, s2
        vldr.32 s1, [sp, #44]
        vldr.32 s0, [sp, #40]
        add     sp, sp, #64
        bx      lr
.L37:
        vabs.f32        s14, s4
        vcmpe.f32       s15, s14
        vmrs    APSR_nzcv, FPSCR
        ble     .L40
        vabs.f32        s15, s1
        vcmpe.f32       s14, s15
        vmrs    APSR_nzcv, FPSCR
        bpl     .L41
        vabs.f32        s15, s2
        vcmpe.f32       s14, s15
        vmrs    APSR_nzcv, FPSCR
        bmi     .L25
        vmov.f32        s7, s4
        vmov.f32        s6, s3
        vmov.f32        s4, s2
        vmov.f32        s10, s1
        vmov.f32        s9, s0
        b       .L9
.L40:
        vabs.f32        s14, s5
        vcmpe.f32       s15, s14
        vmrs    APSR_nzcv, FPSCR
        ble     .L42
        vabs.f32        s9, s1
        vcmpe.f32       s14, s9
        vmrs    APSR_nzcv, FPSCR
        bmi     .L28
        vmov.f32        s7, s5
        vmov.f32        s9, s4
        vmov.f32        s6, s3
        vmov.f32        s5, s2
        vmov.f32        s4, s1
        vmov.f32        s10, s0
        b       .L9
.L38:
        vabs.f32        s14, s4
        vcmpe.f32       s15, s14
        vmrs    APSR_nzcv, FPSCR
        ble     .L39
        vabs.f32        s15, s2
        vcmpe.f32       s14, s15
        vmrs    APSR_nzcv, FPSCR
        bmi     .L23
        vmov.f32        s7, s4
        vmov.f32        s9, s3
        vmov.f32        s4, s2
        vmov.f32        s10, s1
        b       .L9
.L22:
        vmov.f32        s10, s2
        vmov.f32        s7, s3
        b       .L9
.L41:
        vabs.f32        s14, s5
        vcmpe.f32       s15, s14
        vmrs    APSR_nzcv, FPSCR
        bgt     .L26
        vmov.f32        s7, s5
        vmov.f32        s10, s4
        vmov.f32        s6, s3
        vmov.f32        s5, s2
        vmov.f32        s4, s1
        vmov.f32        s9, s0
        b       .L9
.L42:
        vmov.f32        s9, s4
        vmov.f32        s10, s5
        vmov.f32        s6, s3
        vmov.f32        s4, s1
        vmov.f32        s5, s2
        vmov.f32        s7, s0
        b       .L9
.L39:
        vabs.f32        s14, s5
        vcmpe.f32       s15, s14
        vmrs    APSR_nzcv, FPSCR
        bgt     .L24
        vmov.f32        s7, s5
        vmov.f32        s10, s4
        vmov.f32        s9, s3
        vmov.f32        s5, s2
        vmov.f32        s4, s1
        b       .L9
.L29:
        movs    r1, #3
        movs    r2, #2
        movs    r3, #1
        b       .L17
.L20:
        vadd.f32        s15, s13, s5
        add     r1, sp, r3, lsl #2
        vsub.f32        s13, s15, s13
        add     r2, sp, r2, lsl #2
        vsub.f32        s5, s5, s13
        vstr.32 s15, [r1, #40]
        vstr.32 s5, [r2, #40]
        vldr.32 s2, [sp, #48]
        cmp     r3, #0
        bne     .L21
        vldr.32 s2, .L45
        vldr.32 s1, [sp, #44]
        vldr.32 s0, [sp, #40]
        add     sp, sp, #64
        bx      lr
.L23:
        vmov.f32        s9, s3
        vmov.f32        s10, s1
        b       .L9
.L26:
        vmov.f32        s10, s4
        vmov.f32        s6, s3
        vmov.f32        s4, s2
        vmov.f32        s7, s1
        vmov.f32        s9, s0
        b       .L9
.L25:
        vmov.f32        s6, s3
        vmov.f32        s10, s1
        vmov.f32        s9, s0
        b       .L9
.L28:
        vmov.f32        s9, s4
        vmov.f32        s6, s3
        vmov.f32        s4, s2
        vmov.f32        s10, s0
        vmov.f32        s7, s1
        b       .L9
.L24:
        vmov.f32        s10, s4
        vmov.f32        s9, s3
        vmov.f32        s4, s2
        vmov.f32        s7, s1
        b       .L9
.L45:
        .word   0


	.align	2
	.global tw_prod_acc_asm	
	.thumb
	.thumb_func
	.type	tw_prod_acc_asm, %function
tw_prod_acc_asm:
	vmul.f32        s12, s3, s1
	vmul.f32        s15, s4, s0
	vmul.f32        s8, s3, s0
	vadd.f32        s11, s12, s15
	vmov.f32        s13, s8
	vfnms.f32		s13, s0, s3
	vsub.f32        s9, s11, s12
	vadd.f32        s14, s11, s13
	vsub.f32        s6, s11, s9
	vsub.f32        s10, s14, s11
	vsub.f32        s9, s15, s9
	vsub.f32        s7, s14, s10
	vsub.f32        s10, s13, s10
	vsub.f32        s11, s11, s7
	vsub.f32        s13, s12, s6
	vfnms.f32		s15, s0, s4
	vfnms.f32		s12, s1, s3
	vfma.f32		s15, s2, s3
	vfma.f32		s12, s0, s5
	vadd.f32        s11, s11, s10
	vadd.f32        s15, s15, s12
	vadd.f32        s13, s13, s9
	vfma.f32		s13, s1, s4
	vadd.f32        s12, s15, s13
	vadd.f32        s9, s12, s11
	vsub.f32        s7, s12, s15
	vadd.f32        s10, s9, s14
	vsub.f32        s6, s12, s7
	vsub.f32        s13, s13, s7
	vadd.f32        s0, s10, s8
	vsub.f32        s1, s10, s14
	vsub.f32        s8, s0, s8
	vsub.f32        s1, s9, s1
	vsub.f32        s10, s10, s8
	vsub.f32        s2, s15, s6
	vadd.f32        s14, s1, s10
	vsub.f32        s9, s9, s11
	vsub.f32        s10, s14, s10
	vsub.f32        s1, s1, s10
	vadd.f32        s15, s2, s13
	vcmp.f32        s1, #0
	vmrs    APSR_nzcv, FPSCR
	vsub.f32        s12, s12, s9
	beq     .L5
	vadd.f32        s2, s12, s1
	vsub.f32        s1, s2, s1
	vsub.f32        s12, s12, s1
	vcmp.f32        s12, #0
	vmrs    APSR_nzcv, FPSCR
	beq     .L10
	bx      lr
.align 2
.L5:
	vadd.f32        s1, s12, s14
	vsub.f32        s14, s1, s14
	vsub.f32        s12, s12, s14
	vcmp.f32        s12, #0
	vmrs    APSR_nzcv, FPSCR
	beq     .L7
	vadd.f32        s2, s15, s12
	bx      lr
.align 2
.L7:
	vadd.f32        s14, s15, s1
	vsub.f32        s1, s14, s1
	vsub.f32        s15, s15, s1
	bx      lr
.align 2
.L10:
	vadd.f32        s15, s15, s2
	bx      lr

.align	2
.global tw_prod_fast_asm
.thumb
.thumb_func
.type	tw_prod_fast_asm, %function
tw_prod_fast_asm:
        vmul.f32        s13, s3, s1
        vmul.f32        s15, s4, s0
        vmul.f32        s9, s3, s0
        vadd.f32        s14, s13, s15
        vmov.f32        s12, s9
        vfnms.f32	s12, s0, s3
        vsub.f32        s8, s14, s13
        vadd.f32        s11, s14, s12
	vsub.f32        s6, s14, s8
        vsub.f32        s10, s11, s14
	vsub.f32        s8, s15, s8
        vsub.f32        s7, s11, s10
        vsub.f32        s10, s12, s10
        vsub.f32        s12, s13, s6
        vfnms.f32	s15, s0, s4
        vadd.f32        s12, s12, s8
        vfnms.f32	s13, s1, s3
        vsub.f32        s14, s14, s7
        vfma.f32	s13, s0, s5
        vfma.f32	s15, s2, s3
	vadd.f32        s14, s14, s10
        vadd.f32        s15, s15, s13
	vmov.f32        s6, s12
        vfma.f32	s6, s1, s4
        vadd.f32        s15, s15, s6
        vadd.f32        s5, s15, s14
        vadd.f32        s12, s5, s11
        vsub.f32        s14, s5, s14
        vadd.f32        s0, s12, s9
        vsub.f32        s11, s12, s11
        vsub.f32        s9, s0, s9
        vsub.f32        s5, s5, s11
        vsub.f32        s12, s12, s9
        vsub.f32        s15, s15, s14
        vadd.f32        s1, s5, s12
        vsub.f32        s12, s1, s12
        vsub.f32        s5, s5, s12
        vcmp.f32        s5, #0
        vmrs    APSR_nzcv, FPSCR
        beq     .L55
        vadd.f32        s2, s5, s15
        bx      lr
.align 2
.L55:
        vadd.f32        s1, s1, s15
        vsub.f32        s5, s1, s1
        vsub.f32        s2, s15, s5
        bx      lr


.align	2
.global tw_reci_fast_asm
.thumb
.thumb_func
.type	tw_reci_fast_asm, %function
tw_reci_fast_asm:
        vldr.32 s7, =1065353217
        vldr.32 s11, =1065353214
        vdiv.f32        s13, s7, s0
        vldr.32 s15, =-1082130431
        vfma.f32 s15, s13, s0
        vmul.f32        s12, s13, s11
        vneg.f32        s10, s13
        vmov.f32        s14, s12
        vneg.f32        s15, s15
        vfnms.f32 s14, s13, s11
        vfma.f32 s15, s10, s1
        vfma.f32 s14, s13, s15
        vadd.f32        s3, s14, s12
        vsub.f32        s12, s3, s12
        vmul.f32        s15, s1, s3
        vsub.f32        s14, s14, s12
        vmul.f32        s6, s3, s0
        vmul.f32        s11, s14, s0
        vmov.f32        s8, s6
        vadd.f32        s12, s15, s11
        vfnms.f32 s8, s3, s0
        vsub.f32        s7, s12, s11
        vadd.f32        s9, s8, s12
        vsub.f32        s10, s12, s7
        vsub.f32        s5, s9, s12
        vsub.f32        s10, s11, s10
        vsub.f32        s7, s15, s7
        vsub.f32        s4, s9, s5
        vadd.f32        s10, s10, s7
        vfnms.f32 s15, s3, s1
        vfnms.f32 s11, s14, s0
	vsub.f32        s8, s8, s5
        vfma.f32 s11, s3, s2
	vsub.f32        s12, s12, s4
        vadd.f32        s15, s15, s11
        vmov.f32        s11, s10
        vfma.f32 s11, s14, s1
        vadd.f32        s15, s15, s11
        vadd.f32        s12, s12, s8
        vneg.f32        s15, s15
        vsub.f32        s11, s15, s12
        vsub.f32        s10, s11, s9
        vadd.f32        s12, s12, s11
        vsub.f32        s8, s10, s6
        vadd.f32        s9, s9, s10
        vadd.f32        s8, s8, s6
        vsub.f32        s11, s11, s9
        vsub.f32        s10, s10, s8
        vsub.f32        s15, s15, s12
        vadd.f32        s9, s11, s10
        vsub.f32        s10, s9, s10
        vsub.f32        s11, s11, s10
        vcmp.f32        s11, #0
        vmrs    APSR_nzcv, FPSCR
        beq     .L5_RECI
        vadd.f32        s15, s15, s11
.align 2
.L6_RECI:
        vmul.f32        s2, s3, s9
        vadd.f32        s11, s2, s14
        vmov.f32        s12, s2
        vsub.f32        s10, s11, s14
        vfnms.f32	s12, s3, s9
        vsub.f32        s2, s2, s10
        vfma.f32	s12, s14, s9
        vmov.f32        s14, s12
        vfma.f32	s14, s3, s15
        vadd.f32        s15, s2, s14
        vadd.f32        s2, s11, s15
        vadd.f32        s0, s2, s3
        vsub.f32        s11, s2, s11
        vsub.f32        s3, s0, s3
        vsub.f32        s15, s15, s11
        vsub.f32        s2, s2, s3
        vadd.f32        s1, s15, s2
        vsub.f32        s2, s1, s2
        vsub.f32        s2, s15, s2
        bx      lr
.align 2
.L5_RECI:
        vadd.f32        s12, s15, s9
        vsub.f32        s11, s12, s9
        vmov.f32        s9, s12
        vsub.f32        s15, s15, s11
        b       .L6_RECI



.align	2
.global tw_sqrt_fast_asm
.thumb
.thumb_func
.type	tw_sqrt_fast_asm, %function
tw_sqrt_fast_asm:
	vsqrt.f32       s15, s0
	vldr.32 s14, =1065353218
	vdiv.f32        s13, s14, s15
	vmov.f32        s6, #5.0e-1
	vmul.f32        s8, s13, s0
	vmul.f32        s9, s13, s6
	vmov.f32        s10, #1.5e+0
	vmul.f32        s15, s9, s8
	vmov.f32        s12, s8
	vsub.f32        s10, s10, s15
	vfnms.f32 s12, s13, s0
	vmul.f32        s11, s13, s10
	vfma.f32 s12, s13, s1
	vfnms.f32 s15, s9, s8
	vmov.f32        s14, s11
	vfma.f32 s15, s9, s12
	vfnms.f32 s14, s13, s10
	vneg.f32        s15, s15
	vfma.f32 s14, s13, s15
	vadd.f32        s10, s14, s11
	vsub.f32        s11, s10, s11
	vmul.f32        s15, s1, s10
	vsub.f32        s14, s14, s11
	vmul.f32        s5, s10, s0
	vmul.f32        s12, s14, s0
	vmov.f32        s8, s5
	vadd.f32        s13, s15, s12
	vfnms.f32 s8, s10, s0
	vsub.f32        s4, s13, s12
	vadd.f32        s9, s8, s13
	vsub.f32        s11, s13, s4
	vsub.f32        s3, s9, s13
	vsub.f32        s7, s15, s4
	vsub.f32        s11, s12, s11
	vsub.f32        s4, s9, s3
	vadd.f32        s11, s11, s7
	vfnms.f32 s15, s10, s1
	vsub.f32        s13, s13, s4
	vsub.f32        s8, s8, s3
	vfnms.f32 s12, s14, s0
	vfma.f32 s12, s10, s2
	vadd.f32        s15, s15, s12
	vadd.f32        s12, s13, s8
	vmov.f32        s13, s11
	vfma.f32 s13, s14, s1
	vmul.f32        s7, s10, s6
	vadd.f32        s15, s15, s13
	vmul.f32        s13, s14, s6
	vadd.f32        s11, s12, s15
	vadd.f32        s10, s9, s11
	vsub.f32        s14, s11, s12
	vadd.f32        s12, s5, s10
	vsub.f32        s9, s10, s9
	vsub.f32        s5, s12, s5
	vsub.f32        s11, s11, s9
	vsub.f32        s10, s10, s5
	vsub.f32        s15, s15, s14
	vadd.f32        s8, s11, s10
	vsub.f32        s10, s8, s10
	vsub.f32        s11, s11, s10
	vcmp.f32        s11, #0
	vmrs    APSR_nzcv, FPSCR
	beq     .L8_SQRT
	vadd.f32        s14, s15, s11
.align 2
.L9_SQRT:
	vmul.f32        s10, s13, s12
	vmul.f32        s15, s7, s8
	vmul.f32        s3, s7, s12
	vadd.f32        s11, s15, s10
	vmov.f32        s5, s3
	vsub.f32        s4, s11, s10
	vfnms.f32 s5, s7, s12
	vsub.f32        s9, s11, s4
	vadd.f32        s6, s5, s11
	vsub.f32        s9, s10, s9
	vsub.f32        s2, s6, s11
	vsub.f32        s4, s15, s4
	vsub.f32        s1, s6, s2
	vadd.f32        s9, s9, s4
	vfnms.f32 s10, s13, s12
	vfnms.f32 s15, s7, s8
	vfma.f32 s10, s7, s14
	vadd.f32        s15, s15, s10
	vsub.f32        s11, s11, s1
	vsub.f32        s5, s5, s2
	vfma.f32 s9, s13, s8
	vadd.f32        s15, s15, s9
	vadd.f32        s11, s11, s5
	vneg.f32        s15, s15
	vsub.f32        s13, s15, s11
	vsub.f32        s10, s13, s6
	vadd.f32        s11, s11, s13
	vsub.f32        s9, s10, s3
	vadd.f32        s6, s6, s10
	vadd.f32        s9, s9, s3
	vsub.f32        s13, s13, s6
	vsub.f32        s10, s10, s9
	vsub.f32        s15, s15, s11
	vadd.f32        s9, s13, s10
	vsub.f32        s10, s9, s10
	vsub.f32        s13, s13, s10
	vcmp.f32        s13, #0
	vmrs    APSR_nzcv, FPSCR
	beq     .L10_SQRT
	vadd.f32        s15, s15, s13
	.align 2
.L11_SQRT:
	vmul.f32        s13, s9, s12
	vadd.f32        s10, s13, s8
	vmov.f32        s11, s13
	vsub.f32        s7, s10, s8
	vfnms.f32 s11, s12, s9
	vsub.f32        s13, s13, s7
	vfma.f32 s11, s8, s9
	vfma.f32 s11, s12, s15
	vadd.f32        s13, s13, s11
	vadd.f32        s9, s13, s14
	vadd.f32        s2, s10, s9
	vadd.f32        s0, s2, s12
	vsub.f32        s10, s2, s10
	vsub.f32        s12, s0, s12
	vsub.f32        s9, s9, s10
	vsub.f32        s2, s2, s12
	vadd.f32        s1, s9, s2
	vsub.f32        s2, s1, s2
	vsub.f32        s2, s9, s2
	bx lr
.align 2
.L8_SQRT:
	vadd.f32        s14, s15, s8
	vsub.f32        s11, s14, s8
	vmov.f32        s8, s14
	vsub.f32        s14, s15, s11
	b       .L9_SQRT
.L10_SQRT:
	vadd.f32        s13, s15, s9
	vsub.f32        s11, s13, s9
	vmov.f32        s9, s13
	vsub.f32        s15, s15, s11
	b       .L11_SQRT
