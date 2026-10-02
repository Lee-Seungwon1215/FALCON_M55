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

	.global control_tw32_two_sum4
	.type control_tw32_two_sum4, %function
	.thumb_func
control_tw32_two_sum4:
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
	.size control_tw32_two_sum4, .-control_tw32_two_sum4

	.global control_tw32_two_prod4
	.type control_tw32_two_prod4, %function
	.thumb_func
control_tw32_two_prod4:
	vldrw.u32 q0, [r0]
	vldrw.u32 q1, [r1]
	vmul.f32 q2, q0, q1       /* rounded product */
	vneg.f32 q3, q2
	vfma.f32 q3, q0, q1       /* exact residual: a*b - product */
	vstrw.u32 q2, [r2]
	vstrw.u32 q3, [r3]
	bx lr
	.size control_tw32_two_prod4, .-control_tw32_two_prod4

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

	.global control_tw32_add4_full
	.type control_tw32_add4_full, %function
	.thumb_func
control_tw32_add4_full:
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
	.size control_tw32_add4_full, .-control_tw32_add4_full

	.global control_tw32_sub4_full
	.type control_tw32_sub4_full, %function
	.thumb_func
control_tw32_sub4_full:
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
	.size control_tw32_sub4_full, .-control_tw32_sub4_full

	/*
	 * Compute both normalized a+b and a-b.  The arithmetic order of each
	 * result is identical to control_tw32_add4_full/control_tw32_sub4_full, but the public
	 * butterfly needs only one call boundary and one stack frame.
	 */
	.global control_tw32_addsub4_full
	.type control_tw32_addsub4_full, %function
	.thumb_func
control_tw32_addsub4_full:
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
	.size control_tw32_addsub4_full, .-control_tw32_addsub4_full

	.global control_tw32_mul4_full
	.type control_tw32_mul4_full, %function
	.thumb_func
control_tw32_mul4_full:
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
	.size control_tw32_mul4_full, .-control_tw32_mul4_full

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
	.global control_tw32_cmul4_full
	.type control_tw32_cmul4_full, %function
	.thumb_func
control_tw32_cmul4_full:
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
	.size control_tw32_cmul4_full, .-control_tw32_cmul4_full

	/* The coefficient planes are 512 floats apart in control_tw32_fft. */
	.equ TW32_PLANE_BYTES, 2048

	.macro LOAD_SOA3 ptr, outoff, tmp
	vldrw.u32 q0, [\ptr]
	vstrw.u32 q0, [sp, #\outoff]
	add.w \tmp, \ptr, #TW32_PLANE_BYTES
	vldrw.u32 q0, [\tmp]
	vstrw.u32 q0, [sp, #(\outoff + 16)]
	add.w \tmp, \tmp, #TW32_PLANE_BYTES
	vldrw.u32 q0, [\tmp]
	vstrw.u32 q0, [sp, #(\outoff + 32)]
	.endm

	.macro STORE_SOA3 ptr, inoff, tmp
	vldrw.u32 q0, [sp, #\inoff]
	vstrw.u32 q0, [\ptr]
	add.w \tmp, \ptr, #TW32_PLANE_BYTES
	vldrw.u32 q0, [sp, #(\inoff + 16)]
	vstrw.u32 q0, [\tmp]
	add.w \tmp, \tmp, #TW32_PLANE_BYTES
	vldrw.u32 q0, [sp, #(\inoff + 32)]
	vstrw.u32 q0, [\tmp]
	.endm

	.macro COPY_TRIPLE dstoff, srcoff
	vldrw.u32 q0, [sp, #\srcoff]
	vstrw.u32 q0, [sp, #\dstoff]
	vldrw.u32 q0, [sp, #(\srcoff + 16)]
	vstrw.u32 q0, [sp, #(\dstoff + 16)]
	vldrw.u32 q0, [sp, #(\srcoff + 32)]
	vstrw.u32 q0, [sp, #(\dstoff + 32)]
	.endm

	.macro HALF_TRIPLE off, half
	vldrw.u32 q0, [sp, #\off]
	vmul.f32 q0, q0, \half
	vstrw.u32 q0, [sp, #\off]
	vldrw.u32 q0, [sp, #(\off + 16)]
	vmul.f32 q0, q0, \half
	vstrw.u32 q0, [sp, #(\off + 16)]
	vldrw.u32 q0, [sp, #(\off + 32)]
	vmul.f32 q0, q0, \half
	vstrw.u32 q0, [sp, #(\off + 32)]
	.endm

	/*
	 * Four forward butterflies, end to end.  r0..r3 point at the first
	 * component plane of x.re/x.im/y.re/y.im; sr/si are compact triples.
	 * Products occupy 0..191, product scratch 192..287, inputs 288..479.
	 */
	.global control_tw32_bfly_fwd4
	.type control_tw32_bfly_fwd4, %function
	.thumb_func
control_tw32_bfly_fwd4:
	stmdb sp!, {r4-r8, lr}
	ldr r4, [sp, #24]
	ldr r5, [sp, #28]
	sub sp, sp, #480
	LOAD_SOA3 r0, 288, r12
	LOAD_SOA3 r1, 336, r12
	LOAD_SOA3 r2, 384, r12
	LOAD_SOA3 r3, 432, r12
	add.w r6, sp, #384
	add.w r7, sp, #432
	MUL_C sp, 0,   r6, r4
	MUL_C sp, 48,  r7, r5
	MUL_C sp, 96,  r6, r5
	MUL_C sp, 144, r7, r4
	SUM_C sp, 0,  sp, 0,  sp, 48, 1
	SUM_C sp, 48, sp, 96, sp, 144, 0
	SUM_C sp, 96,  sp, 288, sp, 0, 0
	SUM_C sp, 144, sp, 288, sp, 0, 1
	SUM_C sp, 288, sp, 336, sp, 48, 0
	SUM_C sp, 336, sp, 336, sp, 48, 1
	STORE_SOA3 r0, 96, r12
	STORE_SOA3 r2, 144, r12
	STORE_SOA3 r1, 288, r12
	STORE_SOA3 r3, 336, r12
	add sp, sp, #480
	ldmia sp!, {r4-r8, pc}
	.size control_tw32_bfly_fwd4, .-control_tw32_bfly_fwd4

	/* Four inverse butterflies; the transform applies one final scale. */
	.global control_tw32_bfly_inv4
	.type control_tw32_bfly_inv4, %function
	.thumb_func
control_tw32_bfly_inv4:
	stmdb sp!, {r4-r8, lr}
	ldr r4, [sp, #24]
	ldr r5, [sp, #28]
	sub sp, sp, #480
	LOAD_SOA3 r0, 288, r12
	LOAD_SOA3 r1, 336, r12
	LOAD_SOA3 r2, 384, r12
	LOAD_SOA3 r3, 432, r12
	SUM_C sp, 0,   sp, 288, sp, 384, 0
	SUM_C sp, 48,  sp, 288, sp, 384, 1
	SUM_C sp, 96,  sp, 336, sp, 432, 0
	SUM_C sp, 144, sp, 336, sp, 432, 1
	movw r12, #0
	movt r12, #0x3f00
	vdup.32 q3, r12
	HALF_TRIPLE 0, q3
	HALF_TRIPLE 48, q3
	HALF_TRIPLE 96, q3
	HALF_TRIPLE 144, q3
	STORE_SOA3 r0, 0, r12
	STORE_SOA3 r1, 96, r12
	COPY_TRIPLE 288, 48
	COPY_TRIPLE 336, 144
	add.w r6, sp, #288
	add.w r7, sp, #336
	MUL_C sp, 0,   r6, r4
	MUL_C sp, 48,  r7, r5
	MUL_C sp, 96,  r6, r5
	MUL_C sp, 144, r7, r4
	SUM_C sp, 0,  sp, 0,  sp, 48, 1
	SUM_C sp, 48, sp, 96, sp, 144, 0
	STORE_SOA3 r2, 0, r12
	STORE_SOA3 r3, 48, r12
	add sp, sp, #480
	ldmia sp!, {r4-r8, pc}
	.size control_tw32_bfly_inv4, .-control_tw32_bfly_inv4

/*
 * Double-single (2 x FP32) kernels.
 *
 * A real value is represented as hi + lo.  DS_SUM/DS_DIFF first recover the
 * exact residual of the leading-component addition, fold in both low
 * components, then perform a fast renormalization.  DS_MUL uses an FP32 FMA
 * for the exact leading-product residual and accumulates all cross terms.
 * Four independent coefficients occupy the four MVE lanes.
 */
	.macro DS_SUM outbase, outoff, abase, aoff, bbase, boff
	vldrw.u32 q0, [\abase, #(\aoff + 0)]
	vldrw.u32 q1, [\bbase, #(\boff + 0)]
	vadd.f32 q2, q0, q1
	vsub.f32 q3, q2, q1
	vsub.f32 q0, q0, q3
	vsub.f32 q3, q2, q3
	vsub.f32 q1, q1, q3
	vadd.f32 q0, q0, q1
	vldrw.u32 q1, [\abase, #(\aoff + 16)]
	vadd.f32 q0, q0, q1
	vldrw.u32 q1, [\bbase, #(\boff + 16)]
	vadd.f32 q0, q0, q1
	vadd.f32 q1, q2, q0
	vsub.f32 q3, q1, q2
	vsub.f32 q0, q0, q3
	vstrw.u32 q1, [\outbase, #(\outoff + 0)]
	vstrw.u32 q0, [\outbase, #(\outoff + 16)]
	.endm

	.macro DS_DIFF outbase, outoff, abase, aoff, bbase, boff
	vldrw.u32 q0, [\abase, #(\aoff + 0)]
	vldrw.u32 q1, [\bbase, #(\boff + 0)]
	vneg.f32 q1, q1
	vadd.f32 q2, q0, q1
	vsub.f32 q3, q2, q1
	vsub.f32 q0, q0, q3
	vsub.f32 q3, q2, q3
	vsub.f32 q1, q1, q3
	vadd.f32 q0, q0, q1
	vldrw.u32 q1, [\abase, #(\aoff + 16)]
	vadd.f32 q0, q0, q1
	vldrw.u32 q1, [\bbase, #(\boff + 16)]
	vsub.f32 q0, q0, q1
	vadd.f32 q1, q2, q0
	vsub.f32 q3, q1, q2
	vsub.f32 q0, q0, q3
	vstrw.u32 q1, [\outbase, #(\outoff + 0)]
	vstrw.u32 q0, [\outbase, #(\outoff + 16)]
	.endm

	.macro DS_MUL outbase, outoff, abase, aoff, bbase, boff
	vldrw.u32 q0, [\abase, #(\aoff + 0)]
	vldrw.u32 q1, [\bbase, #(\boff + 0)]
	vmul.f32 q2, q0, q1
	vneg.f32 q3, q2
	vfma.f32 q3, q0, q1
	vldrw.u32 q1, [\bbase, #(\boff + 16)]
	vfma.f32 q3, q0, q1
	vldrw.u32 q0, [\abase, #(\aoff + 16)]
	vldrw.u32 q1, [\bbase, #(\boff + 0)]
	vfma.f32 q3, q0, q1
	vadd.f32 q0, q2, q3
	vsub.f32 q1, q0, q2
	vsub.f32 q3, q3, q1
	vstrw.u32 q0, [\outbase, #(\outoff + 0)]
	vstrw.u32 q3, [\outbase, #(\outoff + 16)]
	.endm

	/* DS product with the second operand pinned in two MVE registers. */
	.macro DS_MUL_Q outbase, outoff, abase, aoff, bhi, blo
	vldrw.u32 q0, [\abase, #(\aoff + 0)]
	vmul.f32 q2, q0, \bhi
	vneg.f32 q3, q2
	vfma.f32 q3, q0, \bhi
	vfma.f32 q3, q0, \blo
	vldrw.u32 q0, [\abase, #(\aoff + 16)]
	vfma.f32 q3, q0, \bhi
	vadd.f32 q0, q2, q3
	vsub.f32 q1, q0, q2
	vsub.f32 q3, q3, q1
	vstrw.u32 q0, [\outbase, #(\outoff + 0)]
	vstrw.u32 q3, [\outbase, #(\outoff + 16)]
	.endm

	.macro LOAD_SOA2_D ptr, outoff, tmp, stride
	vldrw.u32 q0, [\ptr]
	vstrw.u32 q0, [sp, #\outoff]
	add.w \tmp, \ptr, \stride
	vldrw.u32 q0, [\tmp]
	vstrw.u32 q0, [sp, #(\outoff + 16)]
	.endm

	.macro STORE_SOA2_D ptr, inoff, tmp, stride
	vldrw.u32 q0, [sp, #\inoff]
	vstrw.u32 q0, [\ptr]
	add.w \tmp, \ptr, \stride
	vldrw.u32 q0, [sp, #(\inoff + 16)]
	vstrw.u32 q0, [\tmp]
	.endm

	/* Four complete forward butterflies on double-single coefficients. */
	.global control_ds32_bfly_fwd4
	.type control_ds32_bfly_fwd4, %function
	.thumb_func
control_ds32_bfly_fwd4:
	stmdb sp!, {r4-r8, lr}
	ldr r4, [sp, #24]
	ldr r5, [sp, #28]
	ldr r8, [sp, #32]
	sub sp, sp, #320
	LOAD_SOA2_D r0, 192, r12, r8
	LOAD_SOA2_D r1, 224, r12, r8
	LOAD_SOA2_D r2, 256, r12, r8
	LOAD_SOA2_D r3, 288, r12, r8
	add.w r6, sp, #256
	add.w r7, sp, #288
	DS_MUL sp, 0,  r6, 0, r4, 0
	DS_MUL sp, 32, r7, 0, r5, 0
	DS_MUL sp, 64, r6, 0, r5, 0
	DS_MUL sp, 96, r7, 0, r4, 0
	DS_DIFF sp, 128, sp, 0,  sp, 32
	DS_SUM  sp, 160, sp, 64, sp, 96
	DS_SUM  sp, 0,  sp, 192, sp, 128
	DS_DIFF sp, 32, sp, 192, sp, 128
	DS_SUM  sp, 64, sp, 224, sp, 160
	DS_DIFF sp, 96, sp, 224, sp, 160
	STORE_SOA2_D r0, 0,  r12, r8
	STORE_SOA2_D r2, 32, r12, r8
	STORE_SOA2_D r1, 64, r12, r8
	STORE_SOA2_D r3, 96, r12, r8
	add sp, sp, #320
	ldmia sp!, {r4-r8, pc}
	.size control_ds32_bfly_fwd4, .-control_ds32_bfly_fwd4

	/* Four complete inverse butterflies; scaling is deferred to the end. */
	.global control_ds32_bfly_inv4
	.type control_ds32_bfly_inv4, %function
	.thumb_func
control_ds32_bfly_inv4:
	stmdb sp!, {r4-r8, lr}
	ldr r4, [sp, #24]
	ldr r5, [sp, #28]
	ldr r8, [sp, #32]
	sub sp, sp, #320
	LOAD_SOA2_D r0, 192, r12, r8
	LOAD_SOA2_D r1, 224, r12, r8
	LOAD_SOA2_D r2, 256, r12, r8
	LOAD_SOA2_D r3, 288, r12, r8
	DS_SUM  sp, 0,  sp, 192, sp, 256
	DS_DIFF sp, 32, sp, 192, sp, 256
	DS_SUM  sp, 64, sp, 224, sp, 288
	DS_DIFF sp, 96, sp, 224, sp, 288
	STORE_SOA2_D r0, 0,  r12, r8
	STORE_SOA2_D r1, 64, r12, r8
	DS_MUL sp, 128, sp, 32, r4, 0
	DS_MUL sp, 160, sp, 96, r5, 0
	DS_MUL sp, 192, sp, 32, r5, 0
	DS_MUL sp, 224, sp, 96, r4, 0
	DS_DIFF sp, 256, sp, 128, sp, 160
	DS_SUM  sp, 288, sp, 192, sp, 224
	STORE_SOA2_D r2, 256, r12, r8
	STORE_SOA2_D r3, 288, r12, r8
	add sp, sp, #320
	ldmia sp!, {r4-r8, pc}
	.size control_ds32_bfly_inv4, .-control_ds32_bfly_inv4

	/*
	 * Direct-address DS add/sub. Each argument is a bracket-free address,
	 * e.g. r0 or "sp, #32". Arithmetic order is exactly DS_SUM/DS_DIFF;
	 * only the memory interface changes. q0..q3 are scratch, q4..q7 survive.
	 * All input loads precede both stores, so an output may alias an input.
	 */
	.macro DS_ADDSUB_MEM oh, ol, ah, al, bh, bl, subtract=0
	vldrw.u32 q0, [\ah]
	vldrw.u32 q1, [\bh]
	.if \subtract
	vneg.f32 q1, q1
	.endif
	vadd.f32 q2, q0, q1
	vsub.f32 q3, q2, q1
	vsub.f32 q0, q0, q3
	vsub.f32 q3, q2, q3
	vsub.f32 q1, q1, q3
	vadd.f32 q0, q0, q1
	vldrw.u32 q1, [\al]
	vadd.f32 q0, q0, q1
	vldrw.u32 q1, [\bl]
	.if \subtract
	vsub.f32 q0, q0, q1
	.else
	vadd.f32 q0, q0, q1
	.endif
	vadd.f32 q1, q2, q0
	vsub.f32 q3, q1, q2
	vsub.f32 q0, q0, q3
	vstrw.u32 q1, [\oh]
	vstrw.u32 q0, [\ol]
	.endm

	/*
	 * Register-result product: (q0,q3) = a * twiddle. q6/q7 survive so
	 * the previous product can stay there while this one is evaluated.
	 * Reloading just one twiddle pair frees two registers for that product.
	 */
	.macro DS_MUL_REG ah, al, tw
	vldrw.u32 q4, [\tw, #0]
	vldrw.u32 q5, [\tw, #16]
	vldrw.u32 q0, [\ah]
	vmul.f32 q2, q0, q4
	vneg.f32 q3, q2
	vfma.f32 q3, q0, q4
	vfma.f32 q3, q0, q5
	vldrw.u32 q0, [\al]
	vfma.f32 q3, q0, q4
	vadd.f32 q0, q2, q3
	vsub.f32 q1, q0, q2
	vsub.f32 q3, q3, q1
	.endm

	/*
	 * Combine P0=(q6,q7), P1=(q0,q3), producing (q0,q3).
	 * Preserve the original TwoSum/FMA normalization order, including the
	 * order of low-component accumulation. No FastTwoSum substitution.
	 */
	.macro DS_COMBINE_PRODUCTS subtract=0
	.if \subtract
	vneg.f32 q0, q0
	.endif
	vadd.f32 q1, q6, q0
	vsub.f32 q2, q1, q0
	vsub.f32 q6, q6, q2
	vsub.f32 q2, q1, q2
	vsub.f32 q0, q0, q2
	vadd.f32 q6, q6, q0
	vadd.f32 q6, q6, q7
	.if \subtract
	vsub.f32 q6, q6, q3
	.else
	vadd.f32 q6, q6, q3
	.endif
	vadd.f32 q0, q1, q6
	vsub.f32 q2, q0, q1
	vsub.f32 q3, q6, q2
	.endm

	/* Direct coefficient +/- t; t=(q6,q7) survives for the other output. */
	.macro DS_ADDSUB_T_Q oh, ol, ah, al, subtract=0
	vldrw.u32 q0, [\ah]
	.if \subtract
	vneg.f32 q1, q6
	.else
	vmov q1, q6
	.endif
	vadd.f32 q2, q0, q1
	vsub.f32 q3, q2, q1
	vsub.f32 q0, q0, q3
	vsub.f32 q3, q2, q3
	vsub.f32 q1, q1, q3
	vadd.f32 q0, q0, q1
	vldrw.u32 q1, [\al]
	vadd.f32 q0, q0, q1
	.if \subtract
	vsub.f32 q0, q0, q7
	.else
	vadd.f32 q0, q0, q7
	.endif
	vadd.f32 q1, q2, q0
	vsub.f32 q3, q1, q2
	vsub.f32 q0, q0, q3
	vstrw.u32 q1, [\oh]
	vstrw.u32 q0, [\ol]
	.endm

	/*
	 * Span ABI: r0..r3 = coefficient high-plane pointers; stack arguments
	 * = real twiddle, imaginary twiddle, plane stride, block count.
	 * blocks >= 1; four coefficient regions must not overlap.
	 * r4..r7 = low planes, r8/r10 = twiddles, r9 = public block count.
	 * q0..q3 = arithmetic, q4/q5 = current twiddle, q6/q7 = saved product.
	 *
	 * Forward: 24 coefficient + 8 twiddle + 4 scratch vector accesses.
	 * Inverse: 24 coefficient + 8 twiddle + 12 scratch vector accesses.
	 * Twiddle pointers may themselves address caller stack memory. Counts
	 * above distinguish it from this function's private scratch frame.
	 */
	.global control_ds32_bfly_fwd4_span
	.type control_ds32_bfly_fwd4_span, %function
	.thumb_func
control_ds32_bfly_fwd4_span:
	stmdb sp!, {r4-r10, lr}
	ldr r8, [sp, #32]
	ldr r10, [sp, #36]
	ldr r12, [sp, #40]
	ldr r9, [sp, #44]
	vpush {d8-d15}
	sub sp, sp, #32
	add.w r4, r0, r12
	add.w r5, r1, r12
	add.w r6, r2, r12
	add.w r7, r3, r12
1:
	/* Real component; preserve it while imaginary products consume y. */
	DS_MUL_REG r2, r6, r8
	vmov q6, q0
	vmov q7, q3
	DS_MUL_REG r3, r7, r10
	DS_COMBINE_PRODUCTS 1
	vstrw.u32 q0, [sp, #0]
	vstrw.u32 q3, [sp, #16]
	/* Imaginary component, retained in registers through both outputs. */
	DS_MUL_REG r2, r6, r10
	vmov q6, q0
	vmov q7, q3
	DS_MUL_REG r3, r7, r8
	DS_COMBINE_PRODUCTS
	vmov q6, q0
	vmov q7, q3
	DS_ADDSUB_T_Q r3, r7, r1, r5, 1
	DS_ADDSUB_T_Q r1, r5, r1, r5
	/* Every old y is now dead. Write the two real outputs. */
	vldrw.u32 q6, [sp, #0]
	vldrw.u32 q7, [sp, #16]
	DS_ADDSUB_T_Q r2, r6, r0, r4, 1
	DS_ADDSUB_T_Q r0, r4, r0, r4
	add.w r0, r0, #16
	add.w r1, r1, #16
	add.w r2, r2, #16
	add.w r3, r3, #16
	add.w r4, r4, #16
	add.w r5, r5, #16
	add.w r6, r6, #16
	add.w r7, r7, #16
	subs r9, r9, #1
	bne 1b
	add sp, sp, #32
	vpop {d8-d15}
	ldmia sp!, {r4-r10, pc}
	.size control_ds32_bfly_fwd4_span, .-control_ds32_bfly_fwd4_span

	.global control_ds32_bfly_inv4_span
	.type control_ds32_bfly_inv4_span, %function
	.thumb_func
control_ds32_bfly_inv4_span:
	stmdb sp!, {r4-r10, lr}
	ldr r8, [sp, #32]
	ldr r10, [sp, #36]
	ldr r12, [sp, #40]
	ldr r9, [sp, #44]
	vpush {d8-d15}
	sub sp, sp, #64
	add.w r4, r0, r12
	add.w r5, r1, r12
	add.w r6, r2, r12
	add.w r7, r3, r12
1:
	/* Differences remain live across both complex-product components. */
	DS_ADDSUB_MEM "sp, #0", "sp, #16", r0, r4, r2, r6, 1
	DS_ADDSUB_MEM r0, r4, r0, r4, r2, r6
	DS_ADDSUB_MEM "sp, #32", "sp, #48", r1, r5, r3, r7, 1
	DS_ADDSUB_MEM r1, r5, r1, r5, r3, r7
	DS_MUL_REG "sp, #0", "sp, #16", r8
	vmov q6, q0
	vmov q7, q3
	DS_MUL_REG "sp, #32", "sp, #48", r10
	DS_COMBINE_PRODUCTS 1
	vstrw.u32 q0, [r2]
	vstrw.u32 q3, [r6]
	DS_MUL_REG "sp, #0", "sp, #16", r10
	vmov q6, q0
	vmov q7, q3
	DS_MUL_REG "sp, #32", "sp, #48", r8
	DS_COMBINE_PRODUCTS
	vstrw.u32 q0, [r3]
	vstrw.u32 q3, [r7]
	add.w r0, r0, #16
	add.w r1, r1, #16
	add.w r2, r2, #16
	add.w r3, r3, #16
	add.w r4, r4, #16
	add.w r5, r5, #16
	add.w r6, r6, #16
	add.w r7, r7, #16
	subs r9, r9, #1
	bne 1b
	add sp, sp, #64
	vpop {d8-d15}
	ldmia sp!, {r4-r10, pc}
	.size control_ds32_bfly_inv4_span, .-control_ds32_bfly_inv4_span


/* Stage 10: packed cross-group tails, unchanged DS arithmetic order. */
	.macro DS_MUL_GATHER ah, al, tw, inverse=0, scratch=0
	vldrw.u32 q1, [lr]
	vldrw.u32 q4, [\tw, q1]
	vldrw.u32 q1, [lr, #16]
	vldrw.u32 q5, [\tw, q1]
	.if \inverse
	vneg.f32 q4, q4
	vneg.f32 q5, q5
	.endif
	.if \scratch
	vldrw.u32 q0, [\ah]
	.else
	vldrw.u32 q1, [r11]
	vldrw.u32 q0, [\ah, q1]
	.endif
	vmul.f32 q2, q0, q4
	vneg.f32 q3, q2
	vfma.f32 q3, q0, q4
	vfma.f32 q3, q0, q5
	.if \scratch
	vldrw.u32 q0, [\al]
	.else
	vldrw.u32 q0, [\al, q1]
	.endif
	vfma.f32 q3, q0, q4
	vadd.f32 q0, q2, q3
	vsub.f32 q1, q0, q2
	vsub.f32 q3, q3, q1
	.endm

	.macro DS_ADDSUB_T_GATHER oh, ol, ah, al, subtract=0
	vldrw.u32 q4, [r11]
	vldrw.u32 q0, [\ah, q4]
	.if \subtract
	vneg.f32 q1, q6
	.else
	vmov q1, q6
	.endif
	vadd.f32 q2, q0, q1
	vsub.f32 q3, q2, q1
	vsub.f32 q0, q0, q3
	vsub.f32 q3, q2, q3
	vsub.f32 q1, q1, q3
	vadd.f32 q0, q0, q1
	vldrw.u32 q1, [\al, q4]
	vadd.f32 q0, q0, q1
	.if \subtract
	vsub.f32 q0, q0, q7
	.else
	vadd.f32 q0, q0, q7
	.endif
	vadd.f32 q1, q2, q0
	vsub.f32 q3, q1, q2
	vsub.f32 q0, q0, q3
	vstrw.32 q1, [\oh, q4]
	vstrw.32 q0, [\ol, q4]
	.endm

	.macro DS_ADDSUB_GATHER oh, ol, ah, al, bh, bl, subtract=0, scratch=0
	vldrw.u32 q4, [r11]
	vldrw.u32 q0, [\ah, q4]
	vldrw.u32 q1, [\bh, q4]
	.if \subtract
	vneg.f32 q1, q1
	.endif
	vadd.f32 q2, q0, q1
	vsub.f32 q3, q2, q1
	vsub.f32 q0, q0, q3
	vsub.f32 q3, q2, q3
	vsub.f32 q1, q1, q3
	vadd.f32 q0, q0, q1
	vldrw.u32 q1, [\al, q4]
	vadd.f32 q0, q0, q1
	vldrw.u32 q1, [\bl, q4]
	.if \subtract
	vsub.f32 q0, q0, q1
	.else
	vadd.f32 q0, q0, q1
	.endif
	vadd.f32 q1, q2, q0
	vsub.f32 q3, q1, q2
	vsub.f32 q0, q0, q3
	.if \scratch
	vstrw.u32 q1, [\oh]
	vstrw.u32 q0, [\ol]
	.else
	vstrw.32 q1, [\oh, q4]
	vstrw.32 q0, [\ol, q4]
	.endif
	.endm

	/*
	 * Small-layer ABI: re, im, raw real/imag twiddle table pointers,
	 * then plane stride, blocks=n/16, ht=1 or 2. Four butterflies in
	 * different groups share one invocation/iteration. Coefficient
	 * offsets and root offsets depend only on public ht.
	 * r0..r7 = high/low x/y planes; r8/r10 = current roots;
	 * r9=blocks, r11=coefficient offsets, lr=root offsets, r12=root step.
	 * Saves 104 ABI bytes (including alignment) + 32/64 scratch bytes.
	 */
	.macro DS_GATHER_PROLOGUE scratch
	stmdb sp!, {r4-r11, lr}
	sub sp, sp, #4
	mov r8, r2
	mov r10, r3
	ldr r12, [sp, #48]        /* ht */
	ldr r11, =.Lds_tail_ht1
	cmp r12, #2
	it eq
	addeq r11, r11, #48
	add.w lr, r11, #16
	lsl r12, r12, #2
	add.w r2, r0, r12
	add.w r3, r1, r12
	ldr r12, [sp, #40]        /* plane stride */
	add.w r4, r0, r12
	add.w r5, r1, r12
	add.w r6, r2, r12
	add.w r7, r3, r12
	ldr r9, [sp, #44]         /* public block count */
	ldr r12, [sp, #48]
	cmp r12, #2
	ite eq
	moveq r12, #24
	movne r12, #48
	vpush {d8-d15}
	sub sp, sp, #\scratch
	.endm

	.macro DS_GATHER_ADVANCE
	add.w r0, r0, #32
	add.w r1, r1, #32
	add.w r2, r2, #32
	add.w r3, r3, #32
	add.w r4, r4, #32
	add.w r5, r5, #32
	add.w r6, r6, #32
	add.w r7, r7, #32
	add r8, r8, r12
	add r10, r10, r12
	subs r9, r9, #1
	.endm

	.macro DS_GATHER_EPILOGUE scratch
	add sp, sp, #\scratch
	vpop {d8-d15}
	add sp, sp, #4
	ldmia sp!, {r4-r11, pc}
	.endm

	.global control_ds32_tail_fwd4
	.type control_ds32_tail_fwd4, %function
	.thumb_func
control_ds32_tail_fwd4:
	DS_GATHER_PROLOGUE 32
1:
	DS_MUL_GATHER r2, r6, r8
	vmov q6, q0
	vmov q7, q3
	DS_MUL_GATHER r3, r7, r10
	DS_COMBINE_PRODUCTS 1
	vstrw.u32 q0, [sp, #0]
	vstrw.u32 q3, [sp, #16]
	DS_MUL_GATHER r2, r6, r10
	vmov q6, q0
	vmov q7, q3
	DS_MUL_GATHER r3, r7, r8
	DS_COMBINE_PRODUCTS
	vmov q6, q0
	vmov q7, q3
	DS_ADDSUB_T_GATHER r3, r7, r1, r5, 1
	DS_ADDSUB_T_GATHER r1, r5, r1, r5
	vldrw.u32 q6, [sp, #0]
	vldrw.u32 q7, [sp, #16]
	DS_ADDSUB_T_GATHER r2, r6, r0, r4, 1
	DS_ADDSUB_T_GATHER r0, r4, r0, r4
	DS_GATHER_ADVANCE
	bne 1b
	DS_GATHER_EPILOGUE 32
	.size control_ds32_tail_fwd4, .-control_ds32_tail_fwd4

	.global control_ds32_tail_inv4
	.type control_ds32_tail_inv4, %function
	.thumb_func
control_ds32_tail_inv4:
	DS_GATHER_PROLOGUE 64
1:
	DS_ADDSUB_GATHER "sp, #0", "sp, #16", r0, r4, r2, r6, 1, 1
	DS_ADDSUB_GATHER r0, r4, r0, r4, r2, r6
	DS_ADDSUB_GATHER "sp, #32", "sp, #48", r1, r5, r3, r7, 1, 1
	DS_ADDSUB_GATHER r1, r5, r1, r5, r3, r7
	DS_MUL_GATHER "sp, #0", "sp, #16", r8, 0, 1
	vmov q6, q0
	vmov q7, q3
	DS_MUL_GATHER "sp, #32", "sp, #48", r10, 1, 1
	DS_COMBINE_PRODUCTS 1
	vldrw.u32 q4, [r11]
	vstrw.32 q0, [r2, q4]
	vstrw.32 q3, [r6, q4]
	DS_MUL_GATHER "sp, #0", "sp, #16", r10, 1, 1
	vmov q6, q0
	vmov q7, q3
	DS_MUL_GATHER "sp, #32", "sp, #48", r8, 0, 1
	DS_COMBINE_PRODUCTS
	vldrw.u32 q4, [r11]
	vstrw.32 q0, [r3, q4]
	vstrw.32 q3, [r7, q4]
	DS_GATHER_ADVANCE
	bne 1b
	DS_GATHER_EPILOGUE 64
	.size control_ds32_tail_inv4, .-control_ds32_tail_inv4
	.ltorg

	.section .rodata.ds_tail_offsets,"a",%progbits
	.balign 16
.Lds_tail_ht1:
	.word 0, 8, 16, 24       /* x: 0,2,4,6; y: 1,3,5,7 */
	.word 0, 12, 24, 36      /* four distinct tw_fpr high components */
	.word 4, 16, 28, 40      /* four low components */
.Lds_tail_ht2:
	.word 0, 4, 16, 20       /* x: 0,1,4,5; y: 2,3,6,7 */
	.word 0, 0, 12, 12       /* two roots, each duplicated */
	.word 4, 4, 16, 16
	.text
	.section .note.GNU-stack,"",%progbits
