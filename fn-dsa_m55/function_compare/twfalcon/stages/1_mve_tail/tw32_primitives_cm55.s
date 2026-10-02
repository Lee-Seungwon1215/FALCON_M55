/*
 * Four-lane error-free FP32 building blocks for Cortex-M55/MVE.
 *
 * These kernels intentionally expose the exact two_sum/two_prod operations.
 * The outer FFT controls normalization and is kept separate so that each
 * transition can be checked against the scalar TWFalcon oracle.
 */
	.syntax unified
	.thumb
	.arch armv8.1-m.main
	.arch_extension mve.fp
	.fpu fpv5-d16
	.text
	.align 2

	.global tw32_two_sum4
	.type tw32_two_sum4, %function
	.thumb_func
tw32_two_sum4:
	vldrw.u32 q0, [r0]
	vldrw.u32 q1, [r1]
	vadd.f32 q2, q0, q1       /* s = a + b */
	vsub.f32 q3, q2, q1       /* aa = s - b */
	vsub.f32 q0, q0, q3       /* da = a - aa */
	vsub.f32 q3, q2, q3       /* bb = s - aa */
	vsub.f32 q1, q1, q3       /* db = b - bb */
	vadd.f32 q0, q0, q1       /* e = da + db */
	vstrw.u32 q2, [r2]
	vstrw.u32 q0, [r3]
	bx lr
	.size tw32_two_sum4, .-tw32_two_sum4

	.global tw32_two_prod4
	.type tw32_two_prod4, %function
	.thumb_func
tw32_two_prod4:
	vldrw.u32 q0, [r0]
	vldrw.u32 q1, [r1]
	vmul.f32 q2, q0, q1       /* rounded product */
	vneg.f32 q3, q2
	vfma.f32 q3, q0, q1       /* exact residual: a*b - product */
	vstrw.u32 q2, [r2]
	vstrw.u32 q3, [r3]
	bx lr
	.size tw32_two_prod4, .-tw32_two_prod4

/*
 * Complete four-lane triple-float operations.  Keeping each operation in one
 * leaf routine removes the repeated BL/BX and pointer setup of the diagnostic
 * two_sum/two_prod primitives.  Only q0-q3 are used, so the AAPCS callee-saved
 * MVE registers q4-q7 are never clobbered.
 *
 * Memory layout for every operand is c[0][4], c[1][4], c[2][4].
 */
	.macro TWO_SUM_MEM abase, aoff, bbase, boff, sbase, soff, ebase, eoff
	vldrw.u32 q0, [\abase, #\aoff]
	vldrw.u32 q1, [\bbase, #\boff]
	vadd.f32 q2, q0, q1
	vsub.f32 q3, q2, q1
	vsub.f32 q0, q0, q3
	vsub.f32 q3, q2, q3
	vsub.f32 q1, q1, q3
	vadd.f32 q0, q0, q1
	vstrw.u32 q2, [\sbase, #\soff]
	vstrw.u32 q0, [\ebase, #\eoff]
	.endm

	.macro TWO_SUM_NEG_MEM abase, aoff, bbase, boff, sbase, soff, ebase, eoff
	vldrw.u32 q0, [\abase, #\aoff]
	vldrw.u32 q1, [\bbase, #\boff]
	vneg.f32 q1, q1
	vadd.f32 q2, q0, q1
	vsub.f32 q3, q2, q1
	vsub.f32 q0, q0, q3
	vsub.f32 q3, q2, q3
	vsub.f32 q1, q1, q3
	vadd.f32 q0, q0, q1
	vstrw.u32 q2, [\sbase, #\soff]
	vstrw.u32 q0, [\ebase, #\eoff]
	.endm

	.macro TWO_PROD_MEM abase, aoff, bbase, boff, pbase, poff, ebase, eoff
	vldrw.u32 q0, [\abase, #\aoff]
	vldrw.u32 q1, [\bbase, #\boff]
	vmul.f32 q2, q0, q1
	vneg.f32 q3, q2
	vfma.f32 q3, q0, q1
	vstrw.u32 q2, [\pbase, #\poff]
	vstrw.u32 q3, [\ebase, #\eoff]
	.endm

	/* Common fixed-shape renormalization.  x0/x1/x2 are at 0/32/64. */
	.macro RENORM_TO_D
	TWO_SUM_MEM sp, 32, sp, 64, sp, 32, sp, 80
	TWO_SUM_MEM sp, 0,  sp, 32, sp, 0,  sp, 48
	TWO_SUM_MEM sp, 48, sp, 80, sp, 32, sp, 64
	TWO_SUM_MEM sp, 0,  sp, 32, r0, 0,  sp, 16
	TWO_SUM_MEM sp, 16, sp, 64, r0, 16, r0, 32
	.endm

	.global tw32_add4_full
	.type tw32_add4_full, %function
	.thumb_func
tw32_add4_full:
	sub sp, sp, #96
	TWO_SUM_MEM r1, 0,  r2, 0,  sp, 0,  sp, 16
	TWO_SUM_MEM r1, 16, r2, 16, sp, 32, sp, 48
	TWO_SUM_MEM r1, 32, r2, 32, sp, 64, sp, 80
	vldrw.u32 q0, [sp, #32]
	vldrw.u32 q1, [sp, #16]
	vadd.f32 q0, q0, q1
	vstrw.u32 q0, [sp, #32]
	vldrw.u32 q0, [sp, #64]
	vldrw.u32 q1, [sp, #48]
	vadd.f32 q0, q0, q1
	vldrw.u32 q1, [sp, #80]
	vadd.f32 q0, q0, q1
	vstrw.u32 q0, [sp, #64]
	RENORM_TO_D
	add sp, sp, #96
	bx lr
	.size tw32_add4_full, .-tw32_add4_full

	.global tw32_sub4_full
	.type tw32_sub4_full, %function
	.thumb_func
tw32_sub4_full:
	sub sp, sp, #96
	TWO_SUM_NEG_MEM r1, 0,  r2, 0,  sp, 0,  sp, 16
	TWO_SUM_NEG_MEM r1, 16, r2, 16, sp, 32, sp, 48
	TWO_SUM_NEG_MEM r1, 32, r2, 32, sp, 64, sp, 80
	vldrw.u32 q0, [sp, #32]
	vldrw.u32 q1, [sp, #16]
	vadd.f32 q0, q0, q1
	vstrw.u32 q0, [sp, #32]
	vldrw.u32 q0, [sp, #64]
	vldrw.u32 q1, [sp, #48]
	vadd.f32 q0, q0, q1
	vldrw.u32 q1, [sp, #80]
	vadd.f32 q0, q0, q1
	vstrw.u32 q0, [sp, #64]
	RENORM_TO_D
	add sp, sp, #96
	bx lr
	.size tw32_sub4_full, .-tw32_sub4_full

	.global tw32_mul4_full
	.type tw32_mul4_full, %function
	.thumb_func
tw32_mul4_full:
	sub sp, sp, #96
	TWO_PROD_MEM r1, 0,  r2, 0,  sp, 0,  sp, 16
	TWO_PROD_MEM r1, 0,  r2, 16, sp, 32, sp, 48
	TWO_PROD_MEM r1, 16, r2, 0,  sp, 64, sp, 80
	/* x1 = (e00 + p01) + p10. */
	vldrw.u32 q0, [sp, #16]
	vldrw.u32 q1, [sp, #32]
	vadd.f32 q0, q0, q1
	vldrw.u32 q1, [sp, #64]
	vadd.f32 q0, q0, q1
	vstrw.u32 q0, [sp, #32]
	/* x2 = (((e01 + e10) + a1*b1) + a0*b2) + a2*b0. */
	vldrw.u32 q0, [sp, #48]
	vldrw.u32 q1, [sp, #80]
	vadd.f32 q0, q0, q1
	vldrw.u32 q1, [r1, #16]
	vldrw.u32 q2, [r2, #16]
	vmul.f32 q1, q1, q2
	vadd.f32 q0, q0, q1
	vldrw.u32 q1, [r1, #0]
	vldrw.u32 q2, [r2, #32]
	vmul.f32 q1, q1, q2
	vadd.f32 q0, q0, q1
	vldrw.u32 q1, [r1, #32]
	vldrw.u32 q2, [r2, #0]
	vmul.f32 q1, q1, q2
	vadd.f32 q0, q0, q1
	vstrw.u32 q0, [sp, #64]
	RENORM_TO_D
	add sp, sp, #96
	bx lr
	.size tw32_mul4_full, .-tw32_mul4_full

	.section .note.GNU-stack,"",%progbits
