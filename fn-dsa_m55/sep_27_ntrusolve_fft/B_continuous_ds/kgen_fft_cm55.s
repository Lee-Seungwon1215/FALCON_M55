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

	/* Four complete inverse butterflies; scaling is deferred to the end. */
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
	.global ds32_bfly_fwd4_span
	.type ds32_bfly_fwd4_span, %function
	.thumb_func
ds32_bfly_fwd4_span:
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
	.size ds32_bfly_fwd4_span, .-ds32_bfly_fwd4_span

	.global ds32_bfly_inv4_span
	.type ds32_bfly_inv4_span, %function
	.thumb_func
ds32_bfly_inv4_span:
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
	.size ds32_bfly_inv4_span, .-ds32_bfly_inv4_span


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

	.global ds32_tail_fwd4
	.type ds32_tail_fwd4, %function
	.thumb_func
ds32_tail_fwd4:
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
	.size ds32_tail_fwd4, .-ds32_tail_fwd4

	.global ds32_tail_inv4
	.type ds32_tail_inv4, %function
	.thumb_func
ds32_tail_inv4:
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
	.size ds32_tail_inv4, .-ds32_tail_inv4
	.ltorg

/* Select the original scaled Q32 words for four adjacent coefficients.
 * r0=f, r1=params {len>0, byte stride, sch, scl}, r2=high[4], r3=low[4].
 * len/stride are public. scl is in 1..31; sch may wrap to UINT32_MAX.
 * Every limb is read in order regardless of secret scale or coefficients.
 * Only the public limb loop branches. No extra polynomial workspace.
 * Callee saves 88 ABI/alignment bytes; q0/q1/q2 hold w0/w1/w2. */
	/* r0 advances through limbs; r4..r7=len/stride/sch/scl,
	 * r8..r10=masked window indices. Scratch r1/r11/r12,q0..q6;
	 * r2/r3/lr survive. Result q0=raw high, q4=raw low. */
	.macro DSS_SELECT_CORE
	mov.w r11, #0
	vmov.i32 q0, #0
	vmov.i32 q1, #0
	vmov.i32 q2, #0
.Ldss_limb\@:
	vldrw.u32 q3, [r0]
	add r0, r0, r5
	/* len<2^24: equality is the exact original scalar-mask rule.
	 * These predicates update arithmetic only; every load is unconditional.
	 * q5 is scratch here and is overwritten for sign extension below. */
	vdup.32 q5, r11
	vpt.i32 eq, q5, r8
	vorrt q0, q0, q3
	vpt.i32 eq, q5, r9
	vorrt q1, q1, q3
	vpt.i32 eq, q5, r10
	vorrt q2, q2, q3
	add r11, r11, #1
	cmp r11, r4
	bne .Ldss_limb\@
	/* q3 is the last limb already read, including all four signs. */
	vshr.u32 q5, q3, #30
	vneg.s32 q5, q5
	vshr.u32 q5, q5, #1
	sub r1, r4, r6
	asr r12, r1, #31
	vdup.32 q4, r12
	vand q4, q4, q5
	vorr q0, q0, q4
	sub r1, r1, #1
	asr r12, r1, #31
	vdup.32 q4, r12
	vand q4, q4, q5
	vorr q1, q1, q4
	sub r1, r1, #1
	asr r12, r1, #31
	vdup.32 q4, r12
	vand q4, q4, q5
	vorr q2, q2, q4
	vshr.u32 q4, q2, #30
	vshl.i32 q4, q4, #31
	vorr q2, q2, q4
	/* low=(w0>>(scl-1)) | (w1<<(32-scl)). */
	rsb r12, r7, #1
	vdup.32 q6, r12
	vshl.u32 q4, q0, q6
	rsb r12, r7, #32
	vdup.32 q6, r12
	vshl.u32 q5, q1, q6
	vorr q4, q4, q5
	/* high=(w1>>scl) | (w2<<(31-scl)). */
	rsb r12, r7, #0
	vdup.32 q6, r12
	vshl.u32 q0, q1, q6
	rsb r12, r7, #31
	vdup.32 q6, r12
	vshl.u32 q1, q2, q6
	vorr q0, q0, q1
	.endm

	.section .text.fndsa_ds_select4,"ax",%progbits
	.balign 4
	.global fndsa_ds_select4
	.type fndsa_ds_select4,%function
	.thumb_func
fndsa_ds_select4:
	push {r4-r11, lr}
	sub sp, sp, #4
	vpush {d8-d13}
	ldm r1, {r4-r7}
	sub r8, r6, #1
	ubfx r8, r8, #0, #24
	ubfx r9, r6, #0, #24
	add r10, r6, #1
	ubfx r10, r10, #0, #24
	DSS_SELECT_CORE
	vstrw.u32 q0, [r2]
	vstrw.u32 q4, [r3]
	vpop {d8-d13}
	add sp, sp, #4
	pop {r4-r11, pc}
	.size fndsa_ds_select4, .-fndsa_ds_select4

/* Exact lane-wise translation of the scalar input expansion. The signed
 * upper 16 bits shifted back into place have only 16 significant bits, so
 * converting that word directly equals (float)(xh>>16)*65536 exactly.
 * Encoder-only FastTwoSum steps preserve the original sum/error outputs
 * under the ordered-or-zero-left bounds in research/encoder_fastsum_design.md.
 * Residual additions and explicit +0 keep their original ordering.
 * r0=xh[4], r1=xl[4], r2=out_hi[4], r3=out_lo[4]. No tail over-read. */
	.macro DSE_TWO_SUM h, l, s, v, t
	vadd.f32 \s, \h, \l
	vsub.f32 \v, \s, \h
	vsub.f32 \t, \s, \v
	vsub.f32 \h, \h, \t
	vsub.f32 \l, \l, \v
	vadd.f32 \l, \h, \l
	vmov \h, \s
	.endm

	/* Only proven ordered/zero-left sites, RN-even: encoder pairs and
	 * decoder's final nonnegative-fraction normalization. Not general sums. */
	.macro DSE_FAST_TWO_SUM h, l, s, v
	vadd.f32 \s, \h, \l
	vsub.f32 \v, \s, \h
	vsub.f32 \l, \l, \v
	vmov \h, \s
	.endm

	/* q0/q1 raw high/low -> q0/q1 FP32 high/low. */
	.macro DSE_ENCODE_CORE
	movw r12, #65535
	vdup.32 q6, r12
	vand q2, q0, q6
	vbic q0, q0, q6
	vcvt.f32.s32 q0, q0
	vcvt.f32.u32 q2, q2
	DSE_FAST_TWO_SUM q0, q2, q3, q4

	vshr.u32 q3, q1, #16
	vcvt.f32.u32 q3, q3
	movw r12, #0
	movt r12, #0x3780
	vdup.32 q4, r12
	vmul.f32 q3, q3, q4
	DSE_FAST_TWO_SUM q0, q3, q4, q5
	vadd.f32 q3, q3, q2
	vmov.i32 q4, #0
	vadd.f32 q3, q3, q4
	DSE_FAST_TWO_SUM q0, q3, q4, q5
	vmov q2, q3

	movw r12, #65535
	vdup.32 q6, r12
	vand q1, q1, q6
	vcvt.f32.u32 q1, q1
	movw r12, #0
	movt r12, #0x2f80
	vdup.32 q4, r12
	vmul.f32 q1, q1, q4
	DSE_FAST_TWO_SUM q0, q1, q3, q4
	vadd.f32 q1, q1, q2
	vmov.i32 q3, #0
	vadd.f32 q1, q1, q3
	DSE_FAST_TWO_SUM q0, q1, q3, q4
	.endm

	.section .text.fndsa_ds_encode4,"ax",%progbits
	.balign 4
	.global fndsa_ds_encode4
	.type fndsa_ds_encode4,%function
	.thumb_func
fndsa_ds_encode4:
	vpush {d8-d13}
	vldrw.u32 q0, [r0]
	vldrw.u32 q1, [r1]
	DSE_ENCODE_CORE
	vstrw.u32 q0, [r2]
	vstrw.u32 q1, [r3]
	vpop {d8-d13}
	bx lr
	.size fndsa_ds_encode4, .-fndsa_ds_encode4

/* Full input boundary for public n>=8 and len>0.
 * r0=DS re[0],r1=integer limbs,r2={len,4*n,sch,scl}.
 * Select and encode four coefficients without a word tile or helper call.
 * r2/r3 become high/low output pointers; lr holds the next source block.
 * One saved-register area plus 8 local bytes, no size-dependent scratch.
 * Public remaining count switches from real to imaginary planes halfway.
 */
	.section .text.fndsa_ds_from_big_span,"ax",%progbits
	.balign 4
	.global fndsa_ds_from_big_span
	.type fndsa_ds_from_big_span,%function
	.thumb_func
fndsa_ds_from_big_span:
	push {r4-r11, lr}
	sub sp, sp, #4
	vpush {d8-d13}
	sub sp, sp, #8
	mov lr, r1
	ldm r2, {r4-r7}
	mov r2, r0
	add r3, r0, #2048
	lsr r12, r5, #2
	str r12, [sp, #0]
	sub r8, r6, #1
	ubfx r8, r8, #0, #24
	ubfx r9, r6, #0, #24
	add r10, r6, #1
	ubfx r10, r10, #0, #24
.Lds_input_block:
	mov r0, lr
	DSS_SELECT_CORE
	vmov q1, q4
	DSE_ENCODE_CORE
	vstrw.u32 q0, [r2]
	vstrw.u32 q1, [r3]
	add r2, r2, #16
	add r3, r3, #16
	add lr, lr, #16
	ldr r0, [sp, #0]
	subs r0, r0, #4
	beq .Lds_input_done
	str r0, [sp, #0]
	lsr r12, r5, #3
	cmp r0, r12
	bne .Lds_input_block
	/* Advance by the unused part of each real plane to im[0]/im[1]. */
	add r2, r2, #4096
	add r3, r3, #4096
	sub r2, r2, r5, lsr #1
	sub r3, r3, r5, lsr #1
	b .Lds_input_block
.Lds_input_done:
	add sp, sp, #8
	vpop {d8-d13}
	add sp, sp, #4
	pop {r4-r11, pc}
	.size fndsa_ds_from_big_span, .-fndsa_ds_from_big_span

/* Range check both expansion components and mask invalid lanes to zero.
 * q7 accumulates validity; q0/q1 contain the expansion. All selections use
 * a vector predicate, never an input-dependent branch or scalar IT block. */
	.macro DSR_RANGE
	vmov.i32 q6, #0
	vmvn.i32 q5, #0
	movw r12, #0
	movt r12, #0x4f00
	vdup.32 q3, r12
	vabs.f32 q2, q0
	vcmp.u32 hi, q3, q2
	vpsel q4, q5, q6
	vabs.f32 q2, q1
	vcmp.u32 hi, q3, q2
	vpsel q2, q5, q6
	vand q4, q4, q2
	vand q7, q7, q4
	vand q0, q0, q4
	vand q1, q1, q4
	.endm

	.macro DSR_ADD_CONSTANT upper
	movw r12, #0
	movt r12, #\upper
	vdup.32 q2, r12
	DSE_TWO_SUM q0, q2, q3, q4, q5
	vadd.f32 q2, q2, q1
	vmov.i32 q6, #0
	vadd.f32 q2, q2, q6
	DSE_TWO_SUM q0, q2, q3, q4, q5
	vmov q1, q2
	.endm

/* Four exact translations of the retained scalar to_k boundary. Includes
 * both finite/range checks, low-component tie correction, and signed 64-bit
 * overflow checking; even invalid lanes retain the scalar output bits.
 * r0=hi[4], r1=lo[4], r2=output[4]. Return 1 iff every lane is valid.
 * The 64-byte scratch is bounded and private, not a polynomial Q32 array. */
	.section .text.fndsa_ds_round4,"ax",%progbits
	.balign 4
	.global fndsa_ds_round4
	.type fndsa_ds_round4,%function
	.thumb_func
fndsa_ds_round4:
	vpush {d8-d15}
	sub sp, sp, #64
	vldrw.u32 q0, [r0]
	vldrw.u32 q1, [r1]
	vmvn.i32 q7, #0
	DSR_RANGE
	DSR_ADD_CONSTANT 0x3f00
	DSR_ADD_CONSTANT 0x2f00
	DSR_RANGE

	vrintm.f32 q2, q0
	vcvt.s32.f32 q3, q2
	vstrw.u32 q3, [sp, #0]
	vneg.f32 q2, q2
	DSE_TWO_SUM q0, q2, q3, q4, q5
	vstrw.u32 q0, [sp, #32]
	vstrw.u32 q2, [sp, #48]
	vrintm.f32 q2, q1
	vcvt.s32.f32 q3, q2
	vstrw.u32 q3, [sp, #16]
	vneg.f32 q2, q2
	DSE_TWO_SUM q1, q2, q3, q4, q5
	vldrw.u32 q0, [sp, #32]
	vldrw.u32 q3, [sp, #48]
	DSE_TWO_SUM q0, q1, q4, q5, q6
	vadd.f32 q1, q1, q3
	vadd.f32 q1, q1, q2
	DSE_TWO_SUM q0, q1, q2, q3, q4

	vrintm.f32 q2, q0
	vcvt.s32.f32 q3, q2
	vmvn.i32 q5, #0
	vmov.i32 q6, #0
	vcmp.f32 eq, q0, q2
	vpsel q4, q5, q6
	vcmp.f32 lt, q1, q6
	vpsel q5, q5, q6
	vand q4, q4, q5
	vshr.u32 q4, q4, #31
	vsub.i32 q3, q3, q4

	/* Add three signed words as a true 64-bit sum. Sequential signed
	 * overflow flags alone would wrongly reject cancelling overflows. */
	vldrw.u32 q0, [sp, #0]
	vldrw.u32 q1, [sp, #16]
	vshr.s32 q4, q0, #31
	vshr.s32 q5, q1, #31
	vadd.i32 q4, q4, q5
	vadd.i32 q2, q0, q1
	vmvn.i32 q1, #0
	vcmp.u32 hi, q0, q2
	vpsel q5, q1, q6
	vshr.u32 q5, q5, #31
	vadd.i32 q4, q4, q5
	vshr.s32 q5, q3, #31
	vadd.i32 q4, q4, q5
	vadd.i32 q0, q2, q3
	vcmp.u32 hi, q2, q0
	vpsel q5, q1, q6
	vshr.u32 q5, q5, #31
	vadd.i32 q4, q4, q5
	vshr.s32 q5, q0, #31
	vcmp.i32 eq, q4, q5
	vpsel q2, q1, q6
	vand q7, q7, q2
	vstrw.u32 q0, [r2]
	vmov r0, r1, d14
	vmov r3, r12, d15
	and r0, r0, r1
	and r0, r0, r3
	and r0, r0, r12
	lsr r0, r0, #31
	add sp, sp, #64
	vpop {d8-d15}
	bx lr
	.size fndsa_ds_round4, .-fndsa_ds_round4

/* Integral finite binary32 q0 -> modulo-2^64 words q2:high, q1:low.
 * VSHL uses a signed per-lane count, combining the old scalar left/right
 * shifts. All counts outside [-31,31] zero a 32-bit lane. For the finite
 * binary32 exponent range, count truncation cannot create a nonzero result
 * from one of the out-of-range cases. The sign is applied as a true 64-bit
 * two's-complement operation, including carry from a zero low word. */
	.macro DSD_INTEGRAL_WORDS
	vshr.s32 q5, q0, #31
	/* Extract bits 23..30 without broadcasting an 8-bit mask. */
	vshl.i32 q3, q0, #1
	vshr.u32 q3, q3, #24
	movs r12, #150
	vsub.i32 q3, q3, r12
	vshl.i32 q4, q0, #9
	vshr.u32 q4, q4, #9
	vmov.i32 q6, #0x00800000
	vorr q4, q4, q6
	vshl.u32 q1, q4, q3
	movs r12, #32
	vsub.i32 q3, q3, r12
	vshl.u32 q2, q4, q3
	veor q1, q1, q5
	veor q2, q2, q5
	vsub.i32 q1, q1, q5
	vmov.i32 q7, #0
	vcmp.i32 eq, q1, q7
	vpsel q6, q5, q7
	vshr.u32 q6, q6, #31
	vadd.i32 q2, q2, q6
	.endm

/* Exact finite binary32 *2^32 without feeding a subnormal operand to a
 * vector FP instruction. Normal inputs only need an exponent-field add;
 * subnormal mantissas are exact uint23 integers, so convert them and multiply
 * by normal 2^-117. Vector masks select the result with the original sign.
 * This preserves scalar gradual-underflow semantics in the supported range.
 * Input/output q0, scratch q2-q6; q1 remains live. */
	.macro DSD_SCALE32
	vshr.u32 q3, q0, #31
	vshl.i32 q3, q3, #31
	vshl.i32 q2, q0, #9
	vshr.u32 q2, q2, #9
	vcvt.f32.u32 q2, q2
	/* Identical IEEE bit patterns, encoded directly as vector constants. */
	vmov.i32 q4, #0x05000000
	vmul.f32 q2, q2, q4
	vorr q2, q2, q3
	vmov.i32 q4, #0x10000000
	vadd.i32 q4, q0, q4
	vshl.i32 q5, q0, #1
	vshr.u32 q5, q5, #24
	vmov.i32 q6, #0
	vcmp.i32 eq, q5, q6
	vpsel q0, q2, q4
	.endm

/* Four qd_raw_floor translations. r0/r1: FP32 high/low components;
 * r2/r3: uint32 high/low output words. Inputs must remain finite after
 * multiplication by 2^32, as they do for the bounded NTRU Q32 workspace.
 * Preserve the low residual at integer ties; no float-to-int64 helper,
 * operand-dependent branch or full-polynomial conversion. Scratch:64 bytes. */
	/* q0/q1 FP32 high/low -> q2 high, q0 low raw words.
	 * Uses all Q registers, r12 and exactly sp[0..63]. */
	.macro DSD_DECODE_CORE
	DSD_SCALE32
	vmov q7, q0
	vmov q0, q1
	DSD_SCALE32
	vmov q1, q0
	vmov q0, q7
	vrintm.f32 q2, q0
	vstrw.u32 q2, [sp, #0]
	vneg.f32 q2, q2
	/* Fast2Sum(-floor(x),x): floor has >= exponent, or is zero.
	 * Preserve both fractional sum and residual (including tiny negatives).
	 * A zero residual's sign may change; subsequent raw floor is unchanged. */
	vadd.f32 q3, q2, q0
	vsub.f32 q4, q3, q2
	vsub.f32 q2, q0, q4
	vmov q0, q3
	vstrw.u32 q0, [sp, #32]
	vstrw.u32 q2, [sp, #48]
	vrintm.f32 q2, q1
	vstrw.u32 q2, [sp, #16]
	vneg.f32 q2, q2
	vadd.f32 q3, q2, q1
	vsub.f32 q4, q3, q2
	vsub.f32 q2, q1, q4
	vmov q1, q3
	vldrw.u32 q0, [sp, #32]
	vldrw.u32 q3, [sp, #48]
	DSE_TWO_SUM q0, q1, q4, q5, q6
	vadd.f32 q1, q1, q3
	vadd.f32 q1, q1, q2
	/* Both fractions are nonnegative: no large cancellation in q0,
	 * and |q1|<3u*q0, unless both are zero. Keep both residual additions. */
	DSE_FAST_TWO_SUM q0, q1, q2, q3
	vrintm.f32 q2, q0
	vcvt.s32.f32 q3, q2
	vmvn.i32 q5, #0
	vmov.i32 q6, #0
	vcmp.f32 eq, q0, q2
	vpsel q4, q5, q6
	vcmp.f32 lt, q1, q6
	vpsel q5, q5, q6
	vand q4, q4, q5
	vshr.u32 q4, q4, #31
	vsub.i32 q3, q3, q4
	vstrw.u32 q3, [sp, #32]

	vldrw.u32 q0, [sp, #0]
	DSD_INTEGRAL_WORDS
	vstrw.u32 q1, [sp, #0]
	vstrw.u32 q2, [sp, #48]
	vldrw.u32 q0, [sp, #16]
	DSD_INTEGRAL_WORDS
	vldrw.u32 q0, [sp, #0]
	vldrw.u32 q3, [sp, #48]
	vadd.i32 q4, q0, q1
	vadd.i32 q2, q2, q3
	/* Lane-local unsigned carries: add 1 under the same comparison. */
	movs r12, #1
	vcmp.u32 hi, q0, q4
	vpst
	vaddt.i32 q2, q2, r12
	vldrw.u32 q3, [sp, #32]
	vshr.s32 q5, q3, #31
	vadd.i32 q2, q2, q5
	vadd.i32 q0, q4, q3
	vcmp.u32 hi, q4, q0
	vpst
	vaddt.i32 q2, q2, r12
	.endm

	.section .text.fndsa_ds_decode4,"ax",%progbits
	.balign 4
	.global fndsa_ds_decode4
	.type fndsa_ds_decode4,%function
	.thumb_func
fndsa_ds_decode4:
	vpush {d8-d15}
	sub sp, sp, #64
	vldrw.u32 q0, [r0]
	vldrw.u32 q1, [r1]
	DSD_DECODE_CORE
	vstrw.u32 q2, [r2]
	vstrw.u32 q0, [r3]
	add sp, sp, #64
	vpop {d8-d15}
	bx lr
	.size fndsa_ds_decode4, .-fndsa_ds_decode4

/* Four independent copies of inner_fxr_div's exact bit recurrence.
 * This is integer Q32 arithmetic inside the continuous-DS boundary, not
 * an approximate floating quotient. r0/r1 are in/out high/low words;
 * r2/r3 point to denominator high/low words (four words each).
 * All inputs are loaded before output, so numerator/denominator aliasing
 * is supported. No cross-lane carry instruction: each borrow is explicit.
 * q0/q1 remainder low/high, q2/q3 divisor low/high, q4/q5 quotient,
 * q6/q7 scratch. Stack: 16-byte input-bit stream +16-byte sign bits.
 * Exactly 31 input-bit iterations +33 zero-bit iterations +rounding.
 */
	.macro DSQ_ABS lo, hi
	vshr.s32 q6, \hi, #31
	veor \lo, \lo, q6
	veor \hi, \hi, q6
	vsub.i32 \lo, \lo, q6
	vmov.i32 q7, #0
	vcmp.i32 eq, \lo, r5
	vpst
	vsubt.i32 q7, q7, q6
	vadd.i32 \hi, \hi, q7
	.endm

	.macro DSQ_SUB_TEST
	vsub.i32 q6, q0, q2
	vsub.i32 q7, q1, q3
	vcmp.u32 hi, q2, q0
	vpst
	vsubt.i32 q7, q7, r4
	/* Match b=1-((num-y)>>63), even on the original edge inputs. */
	vcmp.s32 ge, q7, r5
	.endm

	.macro DSQ_STEP quotient
	DSQ_SUB_TEST
	vpsel q0, q6, q0
	vpsel q1, q7, q1
	/* Assemble high and low 32-bit quotient halves separately. */
	vshl.i32 \quotient, \quotient, #1
	vpst
	vaddt.i32 \quotient, \quotient, r4
	/* num <- num<<1; optional next input bit follows in the caller. */
	vshr.u32 q6, q0, #31
	vshl.i32 q1, q1, #1
	vorr q1, q1, q6
	vshl.i32 q0, q0, #1
	.endm

	.section .text.fndsa_ds_div4,"ax",%progbits
	.balign 4
	.global fndsa_ds_div4
	.type fndsa_ds_div4,%function
	.thumb_func
fndsa_ds_div4:
	push {r4-r6, lr}
	vpush {d8-d15}
	sub sp, sp, #32
	movs r4, #1
	movs r5, #0
	vldrw.u32 q1, [r0]
	vldrw.u32 q0, [r1]
	vldrw.u32 q3, [r2]
	vldrw.u32 q2, [r3]
	veor q6, q1, q3
	vshr.u32 q6, q6, #31
	vstrw.u32 q6, [sp, #16]
	DSQ_ABS q0, q1
	DSQ_ABS q2, q3
	vshl.i32 q6, q0, #1
	vstrw.u32 q6, [sp, #0]
	vshr.u32 q6, q0, #31
	vshl.i32 q7, q1, #1
	vorr q0, q6, q7
	vshr.u32 q1, q1, #31
	vmov.i32 q4, #0
	vmov.i32 q5, #0
	movs r6, #31
.Ldsq_input:
	DSQ_STEP q5
	vldrw.u32 q6, [sp, #0]
	vshr.u32 q7, q6, #31
	vorr q0, q0, q7
	vshl.i32 q6, q6, #1
	vstrw.u32 q6, [sp, #0]
	subs r6, r6, #1
	bne .Ldsq_input
	/* Bit 32 completes the high quotient; remaining 32 bits fill low. */
	DSQ_STEP q5
	movs r6, #32
.Ldsq_zero:
	DSQ_STEP q4
	subs r6, r6, #1
	bne .Ldsq_zero
	/* q += b, with a lane-wise carry into the high word. */
	DSQ_SUB_TEST
	vmov.i32 q6, #0
	vpst
	vaddt.i32 q6, q6, r4
	vadd.i32 q4, q4, q6
	vcmp.u32 hi, q6, q4
	vpst
	vaddt.i32 q5, q5, r4
	/* Reapply the original XOR sign, including wrapped zero/edge cases. */
	vldrw.u32 q6, [sp, #16]
	vneg.s32 q6, q6
	veor q4, q4, q6
	veor q5, q5, q6
	vsub.i32 q4, q4, q6
	vmov.i32 q7, #0
	vcmp.i32 eq, q4, r5
	vpst
	vsubt.i32 q7, q7, q6
	vadd.i32 q5, q5, q7
	vstrw.u32 q5, [r0]
	vstrw.u32 q4, [r1]
	add sp, sp, #32
	vpop {d8-d15}
	pop {r4-r6, pc}
	.size fndsa_ds_div4, .-fndsa_ds_div4

/* Four exact signed Q32 products, modulo the original 64-bit result.
 * Input q0=xL,q1=xH,q2=yL,q3=yH. Output q4=zL,q5=zH; q6 scratch,
 * r12=1. Compute bits 32..95 of the unsigned 128-bit product and subtract
 * the two signed corrections in zH. Each middle-word addition propagates
 * its own lane carry. VMULH is non-saturating; no rounded high product.
 */
	.macro DSP_Q32_MUL
	vmul.u32 q5, q1, q3
	vmulh.u32 q4, q0, q2
	vmulh.u32 q6, q1, q2
	vadd.i32 q5, q5, q6
	vmul.u32 q6, q1, q2
	vadd.i32 q4, q4, q6
	vcmp.u32 hi, q6, q4
	vpst
	vaddt.i32 q5, q5, r12
	vmulh.u32 q6, q0, q3
	vadd.i32 q5, q5, q6
	vmul.u32 q6, q0, q3
	vadd.i32 q4, q4, q6
	vcmp.u32 hi, q6, q4
	vpst
	vaddt.i32 q5, q5, r12
	vshr.s32 q6, q1, #31
	vand q6, q6, q2
	vsub.i32 q5, q5, q6
	vshr.s32 q6, q3, #31
	vand q6, q6, q0
	vsub.i32 q5, q5, q6
	.endm

/* Validation-visible primitive using exactly the production macro.
 * r0 -> {xh[4],xl[4],yh[4],yl[4]}, r1 -> {zh[4],zl[4]}.
 * All inputs loaded before output; unused in the whole-keygen link. */
	.section .text.fndsa_q32_mul4,"ax",%progbits
	.balign 4
	.global fndsa_q32_mul4
	.type fndsa_q32_mul4,%function
	.thumb_func
fndsa_q32_mul4:
	vpush {d8-d13}
	vldrw.u32 q1, [r0, #0]
	vldrw.u32 q0, [r0, #16]
	vldrw.u32 q3, [r0, #32]
	vldrw.u32 q2, [r0, #48]
	movs r12, #1
	DSP_Q32_MUL
	vstrw.u32 q5, [r1, #0]
	vstrw.u32 q4, [r1, #16]
	vpop {d8-d13}
	bx lr
	.size fndsa_q32_mul4, .-fndsa_q32_mul4

	.macro DSP_DECODE base, part, slot
	add.w r0, \base, #\part
	add.w r1, r0, #2048
	vldrw.u32 q0, [r0]
	vldrw.u32 q1, [r1]
	DSD_DECODE_CORE
	vstrw.u32 q2, [sp, #\slot]
	vstrw.u32 q0, [sp, #(\slot+16)]
	.endm

/* r0=d.re[0], r1=b.re[0], r2=public complex coefficient count (>=4,
 * divisible by 4). Component offsets are the fixed fndsa_ds_poly layout.
 * One frame, one public loop and no external calls; all four inputs precede
 * stores, including d==b. sp[0..63] decoder workspace, [64..191] decoded
 * inputs, [192..223] z2, [224..255] z0. Reuse input slots for output words.
 * Original fxc_mul rule: z0=ar*br,z1=ai*bi,z2=(ar+ai)*(br+bi),
 * real=z0-z1, imag=z2-(z0+z1), with Q32 truncation after each product.
 */
	.macro DSP_PRODUCT_ENCODE
	movs r12, #1
	/* The two wrapping 64-bit sums for z2. */
	vldrw.u32 q0, [sp, #80]
	vldrw.u32 q1, [sp, #64]
	vldrw.u32 q2, [sp, #112]
	vldrw.u32 q3, [sp, #96]
	vadd.i32 q0, q0, q2
	vadd.i32 q1, q1, q3
	vcmp.u32 hi, q2, q0
	vpst
	vaddt.i32 q1, q1, r12
	vldrw.u32 q2, [sp, #144]
	vldrw.u32 q3, [sp, #128]
	vldrw.u32 q4, [sp, #176]
	vldrw.u32 q5, [sp, #160]
	vadd.i32 q2, q2, q4
	vadd.i32 q3, q3, q5
	vcmp.u32 hi, q4, q2
	vpst
	vaddt.i32 q3, q3, r12
	DSP_Q32_MUL
	vstrw.u32 q5, [sp, #192]
	vstrw.u32 q4, [sp, #208]
	/* z0 then z1. */
	vldrw.u32 q0, [sp, #80]
	vldrw.u32 q1, [sp, #64]
	vldrw.u32 q2, [sp, #144]
	vldrw.u32 q3, [sp, #128]
	DSP_Q32_MUL
	vstrw.u32 q5, [sp, #224]
	vstrw.u32 q4, [sp, #240]
	vldrw.u32 q0, [sp, #112]
	vldrw.u32 q1, [sp, #96]
	vldrw.u32 q2, [sp, #176]
	vldrw.u32 q3, [sp, #160]
	DSP_Q32_MUL
	vldrw.u32 q0, [sp, #240]
	vldrw.u32 q1, [sp, #224]
	vsub.i32 q2, q0, q4
	vsub.i32 q3, q1, q5
	vcmp.u32 hi, q4, q0
	vpst
	vsubt.i32 q3, q3, r12
	vstrw.u32 q3, [sp, #64]
	vstrw.u32 q2, [sp, #80]
	vadd.i32 q0, q0, q4
	vadd.i32 q1, q1, q5
	vcmp.u32 hi, q4, q0
	vpst
	vaddt.i32 q1, q1, r12
	vldrw.u32 q4, [sp, #208]
	vldrw.u32 q5, [sp, #192]
	vsub.i32 q2, q4, q0
	vsub.i32 q3, q5, q1
	vcmp.u32 hi, q0, q4
	vpst
	vsubt.i32 q3, q3, r12
	vstrw.u32 q3, [sp, #96]
	vstrw.u32 q2, [sp, #112]
	/* Exactly the same FP expansion normalization as the public encoder. */
	vldrw.u32 q0, [sp, #64]
	vldrw.u32 q1, [sp, #80]
	DSE_ENCODE_CORE
	add.w r0, r4, #2048
	vstrw.u32 q0, [r4]
	vstrw.u32 q1, [r0]
	vldrw.u32 q0, [sp, #96]
	vldrw.u32 q1, [sp, #112]
	DSE_ENCODE_CORE
	add.w r0, r4, #4096
	add.w r1, r4, #6144
	vstrw.u32 q0, [r0]
	vstrw.u32 q1, [r1]
	.endm

	.section .text.fndsa_ds_mul_span,"ax",%progbits
	.balign 4
	.global fndsa_ds_mul_span
	.type fndsa_ds_mul_span,%function
	.thumb_func
fndsa_ds_mul_span:
	push {r4-r6, lr}
	vpush {d8-d15}
	sub sp, sp, #256
	mov r4, r0
	mov r5, r1
	mov r6, r2
.Ldsp_block:
	DSP_DECODE r4, 0, 64
	DSP_DECODE r4, 4096, 96
	DSP_DECODE r5, 0, 128
	DSP_DECODE r5, 4096, 160
	DSP_PRODUCT_ENCODE
	add r4, r4, #16
	add r5, r5, #16
	subs r6, r6, #4
	bne .Ldsp_block
	add sp, sp, #256
	vpop {d8-d15}
	pop {r4-r6, pc}
	.size fndsa_ds_mul_span, .-fndsa_ds_mul_span

/* Decode an immutable multiplier ONCE, after DS encoding. r0=cache,
 * r1=b.re[0], r2=public complex count >=4 and divisible by four.
 * Exactly 16 bytes per complex coefficient, in four-lane raw-word tiles.
 * The 64-byte workspace belongs to DSD_DECODE_CORE only. */
	.section .text.fndsa_ds_prepare_mul_span,"ax",%progbits
	.balign 4
	.global fndsa_ds_prepare_mul_span
	.type fndsa_ds_prepare_mul_span,%function
	.thumb_func
fndsa_ds_prepare_mul_span:
	push {r4-r6, lr}
	vpush {d8-d15}
	sub sp, sp, #64
	mov r4, r0
	mov r5, r1
	mov r6, r2
.Ldsp_prepare:
	add.w r1, r5, #2048
	vldrw.u32 q0, [r5]
	vldrw.u32 q1, [r1]
	DSD_DECODE_CORE
	vstrw.u32 q2, [r4, #0]
	vstrw.u32 q0, [r4, #16]
	add.w r0, r5, #4096
	add.w r1, r5, #6144
	vldrw.u32 q0, [r0]
	vldrw.u32 q1, [r1]
	DSD_DECODE_CORE
	vstrw.u32 q2, [r4, #32]
	vstrw.u32 q0, [r4, #48]
	add r4, r4, #64
	add r5, r5, #16
	subs r6, r6, #4
	bne .Ldsp_prepare
	add sp, sp, #64
	vpop {d8-d15}
	pop {r4-r6, pc}
	.size fndsa_ds_prepare_mul_span, .-fndsa_ds_prepare_mul_span

/* Same product/encoding as mul_span, but immutable b is already decoded.
 * Cache and d must be disjoint. Only public-count branches and sequential
 * loads; the cached operand is never modified. */
	.section .text.fndsa_ds_mul_cached_span,"ax",%progbits
	.balign 4
	.global fndsa_ds_mul_cached_span
	.type fndsa_ds_mul_cached_span,%function
	.thumb_func
fndsa_ds_mul_cached_span:
	push {r4-r6, lr}
	vpush {d8-d15}
	sub sp, sp, #256
	mov r4, r0
	mov r5, r1
	mov r6, r2
.Ldsp_cached:
	DSP_DECODE r4, 0, 64
	DSP_DECODE r4, 4096, 96
	vldrw.u32 q0, [r5, #0]
	vldrw.u32 q1, [r5, #16]
	vldrw.u32 q2, [r5, #32]
	vldrw.u32 q3, [r5, #48]
	vstrw.u32 q0, [sp, #128]
	vstrw.u32 q1, [sp, #144]
	vstrw.u32 q2, [sp, #160]
	vstrw.u32 q3, [sp, #176]
	DSP_PRODUCT_ENCODE
	add r4, r4, #16
	add r5, r5, #64
	subs r6, r6, #4
	bne .Ldsp_cached
	add sp, sp, #256
	vpop {d8-d15}
	pop {r4-r6, pc}
	.size fndsa_ds_mul_cached_span, .-fndsa_ds_mul_cached_span

/* B12: exact integer-to-Q32 input for the retained small FFT path.
 * Same original limb/window/sign semantics as poly_big_to_fixed; no FP
 * conversion and no secret-selected load. r0=fxr output, r1=limb planes,
 * r2={public n,public len>0,secret sch,secret scl}. Four coefficient lanes;
 * VCTP limits n=1/2 loads and scalar short stores avoid writing extra words.
 * Full blocks interleave low/high words with VST2, without a boundary tile.
 * r4=len,r5=stride,r6=sch,r7=scl,r8..r10=window indices,r11=public j.
 * Independently resident in B: no dependency on A's function or object.
 */
	.section .text.fndsa_fixed_input_mve,"ax",%progbits
	.balign 4
	.global fndsa_fixed_input_mve
	.type fndsa_fixed_input_mve,%function
	.thumb_func
fndsa_fixed_input_mve:
	push {r4-r11, lr}
	sub sp, sp, #4
	vpush {d8-d13}
	ldr r3, [r2, #0]
	ldr r4, [r2, #4]
	ldr r6, [r2, #8]
	ldr r7, [r2, #12]
	lsl r5, r3, #2
	mov r2, r1
	sub r8, r6, #1
	ubfx r8, r8, #0, #24
	ubfx r9, r6, #0, #24
	add r10, r6, #1
	ubfx r10, r10, #0, #24
.Lb_fixed_block:
	mov r1, r2
	mov.w r11, #0
	vmov.i32 q0, #0
	vmov.i32 q1, #0
	vmov.i32 q2, #0
	vmov.i32 q3, #0
	vctp.32 r3
.Lb_fixed_limb:
	vpst
	vldrwt.u32 q3, [r1]
	add r1, r1, r5
	ubfx lr, r11, #0, #24
	eor r12, lr, r8
	sub r12, r12, #1
	asr r12, r12, #31
	vdup.32 q4, r12
	vand q4, q3, q4
	vorr q0, q0, q4
	eor r12, lr, r9
	sub r12, r12, #1
	asr r12, r12, #31
	vdup.32 q4, r12
	vand q4, q3, q4
	vorr q1, q1, q4
	eor r12, lr, r10
	sub r12, r12, #1
	asr r12, r12, #31
	vdup.32 q4, r12
	vand q4, q3, q4
	vorr q2, q2, q4
	add r11, r11, #1
	cmp r11, r4
	bne .Lb_fixed_limb
	vshr.u32 q5, q3, #30
	vneg.s32 q5, q5
	vshr.u32 q5, q5, #1
	sub r1, r4, r6
	asr r12, r1, #31
	vdup.32 q4, r12
	vand q4, q4, q5
	vorr q0, q0, q4
	sub r1, r1, #1
	asr r12, r1, #31
	vdup.32 q4, r12
	vand q4, q4, q5
	vorr q1, q1, q4
	sub r1, r1, #1
	asr r12, r1, #31
	vdup.32 q4, r12
	vand q4, q4, q5
	vorr q2, q2, q4
	vshr.u32 q4, q2, #30
	vshl.i32 q4, q4, #31
	vorr q2, q2, q4
	rsb r12, r7, #1
	vdup.32 q6, r12
	vshl.u32 q4, q0, q6
	rsb r12, r7, #32
	vdup.32 q6, r12
	vshl.u32 q5, q1, q6
	vorr q4, q4, q5
	rsb r12, r7, #0
	vdup.32 q6, r12
	vshl.u32 q0, q1, q6
	rsb r12, r7, #31
	vdup.32 q6, r12
	vshl.u32 q1, q2, q6
	vorr q1, q0, q1
	vmov q0, q4
	cmp r3, #4
	blo .Lb_fixed_short
	vst20.32 {q0, q1}, [r0]
	vst21.32 {q0, q1}, [r0]
	add r0, r0, #32
	add r2, r2, #16
	subs r3, r3, #4
	bne .Lb_fixed_block
	b .Lb_fixed_done
.Lb_fixed_short:
	vmov r4, r5, d0
	vmov r6, r7, d2
	str r4, [r0, #0]
	str r6, [r0, #4]
	cmp r3, #1
	beq .Lb_fixed_done
	str r5, [r0, #8]
	str r7, [r0, #12]
.Lb_fixed_done:
	vpop {d8-d13}
	add sp, sp, #4
	pop {r4-r11, pc}
	.size fndsa_fixed_input_mve, .-fndsa_fixed_input_mve

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
