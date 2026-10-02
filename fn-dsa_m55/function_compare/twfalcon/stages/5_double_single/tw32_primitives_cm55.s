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

	/* The coefficient planes are 512 floats apart in tw32_fft. */
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
	.global tw32_bfly_fwd4
	.type tw32_bfly_fwd4, %function
	.thumb_func
tw32_bfly_fwd4:
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
	.size tw32_bfly_fwd4, .-tw32_bfly_fwd4

	/* Four inverse butterflies with the per-layer factor 1/2 preserved. */
	.global tw32_bfly_inv4
	.type tw32_bfly_inv4, %function
	.thumb_func
tw32_bfly_inv4:
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
	.size tw32_bfly_inv4, .-tw32_bfly_inv4

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
	vldrw.u32 q1, [\bbase, #(\boff + 16)]
	vfma.f32 q3, q0, q1
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

	.macro HALF_DS off, half
	vldrw.u32 q0, [sp, #\off]
	vmul.f32 q0, q0, \half
	vstrw.u32 q0, [sp, #\off]
	vldrw.u32 q0, [sp, #(\off + 16)]
	vmul.f32 q0, q0, \half
	vstrw.u32 q0, [sp, #(\off + 16)]
	.endm

	/* Four complete forward butterflies on double-single coefficients. */
	.global ds32_bfly_fwd4
	.type ds32_bfly_fwd4, %function
	.thumb_func
ds32_bfly_fwd4:
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
	.size ds32_bfly_fwd4, .-ds32_bfly_fwd4

	/* Four complete inverse butterflies, including the per-layer factor 1/2. */
	.global ds32_bfly_inv4
	.type ds32_bfly_inv4, %function
	.thumb_func
ds32_bfly_inv4:
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
	movw r12, #0
	movt r12, #0x3f00
	vdup.32 q3, r12
	HALF_DS 0, q3
	HALF_DS 32, q3
	HALF_DS 64, q3
	HALF_DS 96, q3
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
	.size ds32_bfly_inv4, .-ds32_bfly_inv4

	.section .note.GNU-stack,"",%progbits
