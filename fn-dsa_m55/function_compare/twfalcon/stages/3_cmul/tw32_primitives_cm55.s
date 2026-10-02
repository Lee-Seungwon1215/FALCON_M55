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
	.macro RENORM_TO out
	TWO_SUM_MEM sp, 32, sp, 64, sp, 32, sp, 80
	TWO_SUM_MEM sp, 0,  sp, 32, sp, 0,  sp, 48
	TWO_SUM_MEM sp, 48, sp, 80, sp, 32, sp, 64
	TWO_SUM_MEM sp, 0,  sp, 32, \out, 0,  sp, 16
	TWO_SUM_MEM sp, 16, sp, 64, \out, 16, \out, 32
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
	RENORM_TO r0
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
	RENORM_TO r0
	add sp, sp, #96
	bx lr
	.size tw32_sub4_full, .-tw32_sub4_full

	/*
	 * Compute both normalized a+b and a-b.  The arithmetic order of each
	 * result is identical to tw32_add4_full/tw32_sub4_full, but the public
	 * butterfly needs only one call boundary and one stack frame.
	 */
	.global tw32_addsub4_full
	.type tw32_addsub4_full, %function
	.thumb_func
tw32_addsub4_full:
	sub sp, sp, #96
	TWO_SUM_MEM r2, 0,  r3, 0,  sp, 0,  sp, 16
	TWO_SUM_MEM r2, 16, r3, 16, sp, 32, sp, 48
	TWO_SUM_MEM r2, 32, r3, 32, sp, 64, sp, 80
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
	RENORM_TO r0
	TWO_SUM_NEG_MEM r2, 0,  r3, 0,  sp, 0,  sp, 16
	TWO_SUM_NEG_MEM r2, 16, r3, 16, sp, 32, sp, 48
	TWO_SUM_NEG_MEM r2, 32, r3, 32, sp, 64, sp, 80
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
	RENORM_TO r1
	add sp, sp, #96
	bx lr
	.size tw32_addsub4_full, .-tw32_addsub4_full

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
	RENORM_TO r0
	add sp, sp, #96
	bx lr
	.size tw32_mul4_full, .-tw32_mul4_full

	/* Renormalize the triple at scratch offsets 192/224/256. */
	.macro RENORM_C outbase, outoff
	TWO_SUM_MEM sp, 224, sp, 256, sp, 224, sp, 272
	TWO_SUM_MEM sp, 192, sp, 224, sp, 192, sp, 240
	TWO_SUM_MEM sp, 240, sp, 272, sp, 224, sp, 256
	TWO_SUM_MEM sp, 192, sp, 224, \outbase, \outoff, sp, 208
	TWO_SUM_MEM sp, 208, sp, 256, \outbase, (\outoff + 16), \outbase, (\outoff + 32)
	.endm

	/* One complete four-lane triple product, using 192..287 as scratch. */
	.macro MUL_C outbase, outoff, abase, bbase
	TWO_PROD_MEM \abase, 0,  \bbase, 0,  sp, 192, sp, 208
	TWO_PROD_MEM \abase, 0,  \bbase, 16, sp, 224, sp, 240
	TWO_PROD_MEM \abase, 16, \bbase, 0,  sp, 256, sp, 272
	vldrw.u32 q0, [sp, #208]
	vldrw.u32 q1, [sp, #224]
	vadd.f32 q0, q0, q1
	vldrw.u32 q1, [sp, #256]
	vadd.f32 q0, q0, q1
	vstrw.u32 q0, [sp, #224]
	vldrw.u32 q0, [sp, #240]
	vldrw.u32 q1, [sp, #272]
	vadd.f32 q0, q0, q1
	vldrw.u32 q1, [\abase, #16]
	vldrw.u32 q2, [\bbase, #16]
	vmul.f32 q1, q1, q2
	vadd.f32 q0, q0, q1
	vldrw.u32 q1, [\abase, #0]
	vldrw.u32 q2, [\bbase, #32]
	vmul.f32 q1, q1, q2
	vadd.f32 q0, q0, q1
	vldrw.u32 q1, [\abase, #32]
	vldrw.u32 q2, [\bbase, #0]
	vmul.f32 q1, q1, q2
	vadd.f32 q0, q0, q1
	vstrw.u32 q0, [sp, #256]
	RENORM_C \outbase, \outoff
	.endm

	/* Normalize either a+b or a-b into the requested destination. */
	.macro SUM_C outbase, outoff, abase, aoff, bbase, boff, neg
	.if \neg
	TWO_SUM_NEG_MEM \abase, (\aoff + 0), \bbase, (\boff + 0), sp, 192, sp, 208
	TWO_SUM_NEG_MEM \abase, (\aoff + 16), \bbase, (\boff + 16), sp, 224, sp, 240
	TWO_SUM_NEG_MEM \abase, (\aoff + 32), \bbase, (\boff + 32), sp, 256, sp, 272
	.else
	TWO_SUM_MEM \abase, (\aoff + 0), \bbase, (\boff + 0), sp, 192, sp, 208
	TWO_SUM_MEM \abase, (\aoff + 16), \bbase, (\boff + 16), sp, 224, sp, 240
	TWO_SUM_MEM \abase, (\aoff + 32), \bbase, (\boff + 32), sp, 256, sp, 272
	.endif
	vldrw.u32 q0, [sp, #224]
	vldrw.u32 q1, [sp, #208]
	vadd.f32 q0, q0, q1
	vstrw.u32 q0, [sp, #224]
	vldrw.u32 q0, [sp, #256]
	vldrw.u32 q1, [sp, #240]
	vadd.f32 q0, q0, q1
	vldrw.u32 q1, [sp, #272]
	vadd.f32 q0, q0, q1
	vstrw.u32 q0, [sp, #256]
	RENORM_C \outbase, \outoff
	.endm

	/*
	 * Complete complex multiplication.  The four real products and final
	 * add/sub retain the exact standalone arithmetic order, while all
	 * intermediate triples share one frame and no C-visible temporaries.
	 */
	.global tw32_cmul4_full
	.type tw32_cmul4_full, %function
	.thumb_func
tw32_cmul4_full:
	push {r4, r5, r6, lr}
	ldr r4, [sp, #16]
	ldr r5, [sp, #20]
	sub sp, sp, #288
	MUL_C sp, 0,   r2, r4
	MUL_C sp, 48,  r3, r5
	MUL_C sp, 96,  r2, r5
	MUL_C sp, 144, r3, r4
	SUM_C r0, 0, sp, 0,  sp, 48, 1
	SUM_C r1, 0, sp, 96, sp, 144, 0
	add sp, sp, #288
	pop {r4, r5, r6, pc}
	.size tw32_cmul4_full, .-tw32_cmul4_full

	.section .note.GNU-stack,"",%progbits
