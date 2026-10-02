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

/* Exact original big-integer -> Q32 boundary, not floating arithmetic.
 * r0=fxr output, r1=limb-plane input, r2={n,len>0,sch,scl}.
 * n is a power of two. All len limbs are scanned in public order; secret
 * scale only affects masks/shifts. VCTP limits the load for n=1;
 * the short store writes only those valid Q32 words. Full blocks use VST2
 * to interleave little-endian low/high words without a temporary array.
 * r4=len r5=stride r6=sch r7=scl r8..r10=selected limb indices r11=j.
 * r2=current block input, r3=remaining coefficients. Saves 88 ABI bytes.
 * For public n=2, use two coefficients x two adjacent limbs per vector.
 * Merge the limb lanes, then rejoin the same sign/shift/store sequence.
 * For n>=4, compare limb indices in vector predicates; full loads are
 * unpredicated so no secret predicate can suppress any input read. */
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
	cmp r3, #2
	beq .Lfixed_input_pair
.Lfixed_input_block:
	mov r1, r2
	mov.w r11, #0
	vmov.i32 q0, #0
	vmov.i32 q1, #0
	vmov.i32 q2, #0
	vmov.i32 q3, #0
	cmp r3, #1
	beq .Lfixed_input_single
.Lfixed_input_full_limb:
	vldrw.u32 q3, [r1]
	add r1, r1, r5
	/* len<2^24: j already equals its original masked index. */
	vdup.32 q5, r11
	vpt.i32 eq, q5, r8
	vorrt q0, q0, q3
	vpt.i32 eq, q5, r9
	vorrt q1, q1, q3
	vpt.i32 eq, q5, r10
	vorrt q2, q2, q3
	add r11, r11, #1
	cmp r11, r4
	bne .Lfixed_input_full_limb
	b .Lfixed_input_sign
.Lfixed_input_single:
	vctp.32 r3
.Lfixed_input_limb:
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
	bne .Lfixed_input_limb
.Lfixed_input_sign:
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
	blo .Lfixed_input_short
	vst20.32 {q0, q1}, [r0]
	vst21.32 {q0, q1}, [r0]
	add r0, r0, #32
	add r2, r2, #16
	subs r3, r3, #4
	bne .Lfixed_input_block
	b .Lfixed_input_done
.Lfixed_input_short:
	vmov r4, r5, d0
	vmov r6, r7, d2
	str r4, [r0, #0]
	str r6, [r0, #4]
	cmp r3, #1
	beq .Lfixed_input_done
	str r5, [r0, #8]
	str r7, [r0, #12]
.Lfixed_input_done:
	vpop {d8-d13}
	add sp, sp, #4
	pop {r4-r11, pc}

/* All limbs are scanned. For len<2^24, q5's {j,j,j+1,j+1}
 * equality predicates implement the original 24-bit selection masks.
 * Public odd len reads only the last two actual coefficient words. */
.Lfixed_input_pair:
	vmov.i32 q0, #0
	vmov.i32 q1, #0
	vmov.i32 q2, #0
	vmov.i32 q5, #0
	movs r12, #1
	vmov d11, r12, r12
	movs r12, #2
	lsrs r11, r4, #1
	beq .Lfixed_input_pair_odd
.Lfixed_input_pair_limb:
	vldrw.u32 q3, [r1], #16
	vpt.i32 eq, q5, r8
	vorrt q0, q0, q3
	vpt.i32 eq, q5, r9
	vorrt q1, q1, q3
	vpt.i32 eq, q5, r10
	vorrt q2, q2, q3
	vadd.i32 q5, q5, r12
	subs r11, r11, #1
	bne .Lfixed_input_pair_limb
.Lfixed_input_pair_odd:
	tst r4, #1
	beq .Lfixed_input_pair_combine
	vmov.i32 q3, #0
	vldr d6, [r1]
	add r1, r1, #8
	vpt.i32 eq, q5, r8
	vorrt q0, q0, q3
	vpt.i32 eq, q5, r9
	vorrt q1, q1, q3
	vpt.i32 eq, q5, r10
	vorrt q2, q2, q3
.Lfixed_input_pair_combine:
	vmov r8, r9, d0
	vmov r10, r11, d1
	orr r8, r8, r10
	orr r9, r9, r11
	vmov d0, r8, r9
	vmov r8, r9, d2
	vmov r10, r11, d3
	orr r8, r8, r10
	orr r9, r9, r11
	vmov d2, r8, r9
	vmov r8, r9, d4
	vmov r10, r11, d5
	orr r8, r8, r10
	orr r9, r9, r11
	vmov d4, r8, r9
	vldr d6, [r1, #-8]
	b .Lfixed_input_sign
	.size fndsa_fixed_input_mve, .-fndsa_fixed_input_mve

/* Four independent original inner_fxr_div recurrences on interleaved fxr
 * arrays: r0 = in/out numerator[4], r1 = denominator[4]. No conversion to
 * double or DS and no change to the public/global scalar division helper.
 * VLD2/VST2 split/rejoin low/high words without temporary boundary arrays.
 * q0/q1 remainder low/high; q2/q3 divisor low/high; q4/q5 quotient.
 * q6/q7 scratch; stack holds the input-bit stream and XOR sign bits.
 * Both input arrays are fully loaded before any output store (alias safe).
 * Borrow/carry is independent per lane, never chained between coefficients.
 */
	.macro FXQ_ABS lo, hi
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

	.macro FXQ_SUB_TEST
	vsub.i32 q6, q0, q2
	vsub.i32 q7, q1, q3
	vcmp.u32 hi, q2, q0
	vpst
	vsubt.i32 q7, q7, r4
	/* Original b=1-((num-y)>>63), including wrapped edge behavior. */
	vcmp.s32 ge, q7, r5
	.endm

	.macro FXQ_STEP quotient
	FXQ_SUB_TEST
	vpsel q0, q6, q0
	vpsel q1, q7, q1
	vshl.i32 \quotient, \quotient, #1
	vpst
	vaddt.i32 \quotient, \quotient, r4
	vshr.u32 q6, q0, #31
	vshl.i32 q1, q1, #1
	vorr q1, q1, q6
	vshl.i32 q0, q0, #1
	.endm

	.section .text.fndsa_fxr_div4,"ax",%progbits
	.balign 4
	.global fndsa_fxr_div4
	.type fndsa_fxr_div4,%function
	.thumb_func
fndsa_fxr_div4:
	push {r4-r6, lr}
	vpush {d8-d15}
	sub sp, sp, #32
	movs r4, #1
	movs r5, #0
	vld20.32 {q0, q1}, [r0]
	vld21.32 {q0, q1}, [r0]
	vld20.32 {q2, q3}, [r1]
	vld21.32 {q2, q3}, [r1]
	veor q6, q1, q3
	vshr.u32 q6, q6, #31
	vstrw.u32 q6, [sp, #16]
	FXQ_ABS q0, q1
	FXQ_ABS q2, q3
	vshl.i32 q6, q0, #1
	vstrw.u32 q6, [sp, #0]
	vshr.u32 q6, q0, #31
	vshl.i32 q7, q1, #1
	vorr q0, q6, q7
	vshr.u32 q1, q1, #31
	vmov.i32 q4, #0
	vmov.i32 q5, #0
	movs r6, #31
.Lfxq_input:
	FXQ_STEP q5
	vldrw.u32 q6, [sp, #0]
	vshr.u32 q7, q6, #31
	vorr q0, q0, q7
	vshl.i32 q6, q6, #1
	vstrw.u32 q6, [sp, #0]
	subs r6, r6, #1
	bne .Lfxq_input
	FXQ_STEP q5
	movs r6, #32
.Lfxq_zero:
	FXQ_STEP q4
	subs r6, r6, #1
	bne .Lfxq_zero
	/* Original final rounding with independent low-to-high carries. */
	FXQ_SUB_TEST
	vmov.i32 q6, #0
	vpst
	vaddt.i32 q6, q6, r4
	vadd.i32 q4, q4, q6
	vcmp.u32 hi, q6, q4
	vpst
	vaddt.i32 q5, q5, r4
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
	vst20.32 {q4, q5}, [r0]
	vst21.32 {q4, q5}, [r0]
	add sp, sp, #32
	vpop {d8-d15}
	pop {r4-r6, pc}
	.size fndsa_fxr_div4, .-fndsa_fxr_div4

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
	.syntax unified
	.thumb
	.text

	.syntax unified
	.thumb

/* NTRU-local fused, exact Q32 butterflies. r0={xr,xi,yr,yi}, r1=count,
 * r2=public fxc twiddle, r3=inverse (0 or 1). Count>=4 is divisible by 4.
 * Twiddles are the ORIGINAL GM_TAB roots for logn<=10 (conjugated inverse).
 * No secret coefficient range is assumed. The public case table covers all
 * 511 used roots in each direction; unsupported public constants trap.
 * This keeps the original THREE separately truncated complex products and
 * original per-layer rounded half, including signed 64-bit wraparound.
 * Private scratch is 64 bytes; total callee frame is 176 bytes.
 */
	.macro NBF_ADD dl,dh,al,ah,bl,bh
	vadd.i32 \dl,\al,\bl
	vcmp.u32 hi,\bl,\dl
	vadd.i32 \dh,\ah,\bh
	vpst
	vaddt.i32 \dh,\dh,r12
	.endm
	.macro NBF_SUB dl,dh,al,ah,bl,bh
	vcmp.u32 hi,\bl,\al
	vsub.i32 \dl,\al,\bl
	vsub.i32 \dh,\ah,\bh
	vpst
	vsubt.i32 \dh,\dh,r12
	.endm
	.macro NBF_HALF lo,hi,tmp
	vadd.i32 \lo,\lo,r12
	vcmp.i32 eq,\lo,r3
	vpst
	vaddt.i32 \hi,\hi,r12
	vshl.i32 \tmp,\hi,#31
	vshr.u32 \lo,\lo,#1
	vorr \lo,\lo,\tmp
	vshr.s32 \hi,\hi,#1
	.endm
	.macro NBF_PREP xp,yp
	vld20.32 {q0,q1},[\xp]
	vld21.32 {q0,q1},[\xp]
	vld20.32 {q2,q3},[\yp]
	vld21.32 {q2,q3},[\yp]
	NBF_ADD q4,q5,q0,q1,q2,q3
	NBF_SUB q6,q7,q0,q1,q2,q3
	NBF_HALF q4,q5,q0
	NBF_HALF q6,q7,q0
	vst20.32 {q4,q5},[\xp]
	vst21.32 {q4,q5},[\xp]
	vst20.32 {q6,q7},[\yp]
	vst21.32 {q6,q7},[\yp]
	.endm
	.macro NBF_MUL high,negative,root
	/* q0/q1=input; q3/q4=output; q2/q5 scratch; q6/q7 PRESERVED. */
	vdup.32 q2,\root
	vmulh.u32 q3,q0,q2
	vmulh.s32 q4,q1,q2
	.if \negative
	vadd.i32 q4,q4,q1
	.endif
	vmul.i32 q5,q1,q2
	vadd.i32 q3,q3,q5
	vcmp.u32 hi,q5,q3
	vpst
	vaddt.i32 q4,q4,r12
	.if \high == 1
	NBF_ADD q3,q4,q3,q4,q0,q1
	.elseif \high == -1
	NBF_SUB q3,q4,q3,q4,q0,q1
	.elseif \high == -2
	/* Subtract 2*x without clobbering the live q6/q7 real product. */
	vshr.u32 q5,q0,#31
	vsub.i32 q4,q4,q5
	vsub.i32 q4,q4,q1
	vsub.i32 q4,q4,q1
	vshl.i32 q5,q0,#1
	vcmp.u32 hi,q5,q3
	vsub.i32 q3,q3,q5
	vpst
	vsubt.i32 q4,q4,r12
	.endif
	.endm
	.macro NBF_MIX xp,yp,lo,hi
	vld20.32 {q0,q1},[\xp]
	vld21.32 {q0,q1},[\xp]
	NBF_ADD q2,q3,q0,q1,\lo,\hi
	NBF_SUB q0,q1,q0,q1,\lo,\hi
	vst20.32 {q2,q3},[\xp]
	vst21.32 {q2,q3},[\xp]
	vst20.32 {q0,q1},[\yp]
	vst21.32 {q0,q1},[\yp]
	.endm
	.macro NBF_CASE name,inverse,rh,rn,ih,in,sh,sn
\name:
1:
	.if \inverse
	NBF_PREP r4,r6
	NBF_PREP r5,r7
	.endif
	/* Save wrap(re+im), then compute z0. */
	vld20.32 {q0,q1},[r6]
	vld21.32 {q0,q1},[r6]
	vld20.32 {q2,q3},[r7]
	vld21.32 {q2,q3},[r7]
	NBF_ADD q4,q5,q0,q1,q2,q3
	vstrw.32 q4,[sp,#0]
	vstrw.32 q5,[sp,#16]
	NBF_MUL \rh,\rn,r8
	vstrw.32 q3,[sp,#32]
	vstrw.32 q4,[sp,#48]
	/* z1; keep z0-z1 live, and spill only z0+z1. */
	vld20.32 {q0,q1},[r7]
	vld21.32 {q0,q1},[r7]
	NBF_MUL \ih,\in,r9
	vldrw.32 q6,[sp,#32]
	vldrw.32 q7,[sp,#48]
	NBF_ADD q0,q1,q6,q7,q3,q4
	NBF_SUB q6,q7,q6,q7,q3,q4
	vstrw.32 q0,[sp,#32]
	vstrw.32 q1,[sp,#48]
	/* z2 - (z0+z1), preserving the real product in q6/q7. */
	vldrw.32 q0,[sp,#0]
	vldrw.32 q1,[sp,#16]
	NBF_MUL \sh,\sn,r10
	vldrw.32 q0,[sp,#32]
	vldrw.32 q1,[sp,#48]
	NBF_SUB q3,q4,q3,q4,q0,q1
	vmov q5,q4
	vmov q4,q3
	.if \inverse
	vst20.32 {q6,q7},[r6]
	vst21.32 {q6,q7},[r6]
	vst20.32 {q4,q5},[r7]
	vst21.32 {q4,q5},[r7]
	.else
	NBF_MIX r4,r6,q6,q7
	NBF_MIX r5,r7,q4,q5
	.endif
	add r4,#32
	add r5,#32
	add r6,#32
	add r7,#32
	subs r11,#4
	bne 1b
	b .Lfused_return
	.endm

	.section .text.fndsa_ntru_q32_butterfly,"ax",%progbits
	.balign 4
	.global fndsa_ntru_q32_butterfly
	.type fndsa_ntru_q32_butterfly,%function
	.thumb_func
fndsa_ntru_q32_butterfly:
	push {r4-r11,lr}
	vpush {d8-d15}
	sub sp,#76
	str r3,[sp,#64]
	ldmia r0,{r4-r7}
	mov r11,r1
	ldr r8,[r2,#0]
	ldr r0,[r2,#4]
	ldr r9,[r2,#8]
	ldr r1,[r2,#12]
	adds r10,r8,r9
	adc r2,r0,r1
	/* Six public case bits: real sign/fraction, imag fraction, sum class.
	 * Original root re.high is -1/0, im.high is 0/-1 by direction. */
	and r0,r0,#1
	lsl r0,#1
	orr r0,r0,r8,lsr #31
	lsr r1,r9,#31
	orr r0,r0,r1,lsl #2
	add r2,#2
	lsl r2,#1
	orr r2,r2,r10,lsr #31
	orr r0,r0,r2,lsl #3
	ldr r1,[sp,#64]
	add r0,r0,r1,lsl #6
	ldr r2,=.Lfused_cases
	ldr r0,[r2,r0,lsl #2]
	movs r12,#1
	movs r3,#0
	bx r0
	.ltorg

	NBF_CASE .Lfused_0_18,0,-1,0,0,0,-1,0
	NBF_CASE .Lfused_0_26,0,-1,0,0,0,-1,1
	NBF_CASE .Lfused_0_30,0,-1,0,0,1,-1,1
	NBF_CASE .Lfused_0_38,0,-1,0,0,1,0,0
	NBF_CASE .Lfused_0_39,0,-1,1,0,1,0,0
	NBF_CASE .Lfused_0_47,0,-1,1,0,1,0,1
	NBF_CASE .Lfused_0_49,0,0,1,0,0,1,0
	NBF_CASE .Lfused_0_52,0,0,0,0,1,1,0
	NBF_CASE .Lfused_0_53,0,0,1,0,1,1,0
	NBF_CASE .Lfused_1_10,1,-1,0,-1,0,-2,1
	NBF_CASE .Lfused_1_11,1,-1,1,-1,0,-2,1
	NBF_CASE .Lfused_1_14,1,-1,0,-1,1,-2,1
	NBF_CASE .Lfused_1_16,1,0,0,-1,0,-1,0
	NBF_CASE .Lfused_1_24,1,0,0,-1,0,-1,1
	NBF_CASE .Lfused_1_25,1,0,1,-1,0,-1,1
	NBF_CASE .Lfused_1_33,1,0,1,-1,0,0,0
	NBF_CASE .Lfused_1_37,1,0,1,-1,1,0,0
	NBF_CASE .Lfused_1_45,1,0,1,-1,1,0,1

.Lfused_return:
	add sp,#76
	vpop {d8-d15}
	pop {r4-r11,pc}
.Lfused_bad_root:
	udf #0
	.size fndsa_ntru_q32_butterfly,.-fndsa_ntru_q32_butterfly

/* A13: pack the ht=1/2 stages across different roots. All addresses and
 * loop counts are public. Each lane is one complete original butterfly;
 * no real/imaginary or inter-lane carry is shared. A14 scratch is 160 bytes.
 * Unlike the long-span specialization, roots differ between lanes here. */
	.macro NQT_MUL
	/* q0/q1=x low/high, q2/q3=y low/high -> q4/q5, q6 scratch.
	 * Bits 32..95 of the unsigned product, then signed corrections. */
	vmul.u32 q5,q1,q3
	vmulh.u32 q4,q0,q2
	vmulh.u32 q6,q1,q2
	vadd.i32 q5,q5,q6
	vmul.u32 q6,q1,q2
	vadd.i32 q4,q4,q6
	vcmp.u32 hi,q6,q4
	vpst
	vaddt.i32 q5,q5,r12
	vmulh.u32 q6,q0,q3
	vadd.i32 q5,q5,q6
	vmul.u32 q6,q0,q3
	vadd.i32 q4,q4,q6
	vcmp.u32 hi,q6,q4
	vpst
	vaddt.i32 q5,q5,r12
	vshr.s32 q6,q1,#31
	vand q6,q6,q2
	vsub.i32 q5,q5,q6
	vshr.s32 q6,q3,#31
	vand q6,q6,q0
	vsub.i32 q5,q5,q6
	.endm
	.macro NQT_LOAD lo,hi,base,offset=q7
	add r0,\base,#4
	vldrw.u32 \lo,[\base,\offset]
	vldrw.u32 \hi,[r0,\offset]
	.endm
	/* A14: root component high word is exactly 0 or -1. Compute
	 * floor(signed(x)*unsigned(root.low)/2^32), then subtract x when
	 * root.high=-1. No range restriction on x; preserve q6/q7. Inputs
	 * q0/q1=x, q2/q3=root; output q4/q5, q2/q3 consumed. */
	.macro NQT_MUL_COMPONENT
	vmulh.s32 q5,q1,q2
	vshr.s32 q4,q2,#31
	vand q4,q4,q1
	vadd.i32 q5,q5,q4
	vmulh.u32 q4,q0,q2
	vmul.i32 q2,q1,q2
	vadd.i32 q4,q4,q2
	vcmp.u32 hi,q2,q4
	vpst
	vaddt.i32 q5,q5,r12
	vand q2,q0,q3
	vand q3,q1,q3
	NBF_SUB q4,q5,q4,q5,q2,q3
	.endm
	.macro NQT_STORE lo,hi,base,offset=q7
	add r0,\base,#4
	vstrw.32 \lo,[\base,\offset]
	vstrw.32 \hi,[r0,\offset]
	.endm
	.macro NQT_PREP xp,yp,slot,inverse,ht
	.if \inverse
	.if \ht == 1
	/* Eight adjacent coefficients deinterleave as x.low/high,y.low/high. */
	vld40.32 {q0,q1,q2,q3},[\xp]
	vld41.32 {q0,q1,q2,q3},[\xp]
	vld42.32 {q0,q1,q2,q3},[\xp]
	vld43.32 {q0,q1,q2,q3},[\xp]
	.else
	NQT_LOAD q0,q1,\xp
	NQT_LOAD q2,q3,\yp
	.endif
	NBF_ADD q4,q5,q0,q1,q2,q3
	NBF_SUB q0,q1,q0,q1,q2,q3
	NBF_HALF q4,q5,q6
	NBF_HALF q0,q1,q6
	/* NQT_STORE does not clobber q0/q1 difference. */
	NQT_STORE q4,q5,\xp
	.else
	NQT_LOAD q0,q1,\yp
	.endif
	vstrw.32 q0,[sp,#\slot]
	vstrw.32 q1,[sp,#(\slot+16)]
	.endm
	.macro NQT_ROOT part,slot,negate
	add r0,r8,#\part
	add r1,r0,#4
	vldrw.u32 q0,[r0,q7]
	vldrw.u32 q1,[r1,q7]
	.if \negate
	vmov.i32 q2,#0
	vmov.i32 q3,#0
	NBF_SUB q0,q1,q2,q3,q0,q1
	.endif
	vstrw.32 q0,[sp,#\slot]
	vstrw.32 q1,[sp,#(\slot+16)]
	.endm
	.macro NQT_SUM a,b,d
	vldrw.u32 q0,[sp,#\a]
	vldrw.u32 q1,[sp,#(\a+16)]
	vldrw.u32 q2,[sp,#\b]
	vldrw.u32 q3,[sp,#(\b+16)]
	NBF_ADD q4,q5,q0,q1,q2,q3
	vstrw.32 q4,[sp,#\d]
	vstrw.32 q5,[sp,#(\d+16)]
	.endm
	.macro NQT_COMPONENT_PRODUCT a,b
	vldrw.u32 q0,[sp,#\a]
	vldrw.u32 q1,[sp,#(\a+16)]
	vldrw.u32 q2,[sp,#\b]
	vldrw.u32 q3,[sp,#(\b+16)]
	NQT_MUL_COMPONENT
	.endm
	.macro NQT_LOOP inverse,ht
1:
	vldrw.u32 q7,[r10]
	NQT_PREP r4,r6,0,\inverse,\ht
	NQT_PREP r5,r7,32,\inverse,\ht
	.if \ht == 1
	/* A16: four adjacent fxc roots, four 32-bit fields each.
	 * q0/q1=real low/high; q2/q3=imaginary low/high. */
	vld40.32 {q0,q1,q2,q3},[r8]
	vld41.32 {q0,q1,q2,q3},[r8]
	vld42.32 {q0,q1,q2,q3},[r8]
	vld43.32 {q0,q1,q2,q3},[r8]
	.if \inverse
	vmov.i32 q4,#0
	vmov.i32 q5,#0
	NBF_SUB q2,q3,q4,q5,q2,q3
	.endif
	vstrw.32 q0,[sp,#64]
	vstrw.32 q1,[sp,#80]
	vstrw.32 q2,[sp,#96]
	vstrw.32 q3,[sp,#112]
	.else
	vldrw.u32 q7,[r10,#16]
	NQT_ROOT 0,64,0
	NQT_ROOT 8,96,\inverse
	.endif
	NQT_SUM 0,32,128
	/* z2 first; summed roots need the general Q32 product. Reuse the
	 * y-sum slot for z2, then keep z0 live through the component product. */
	vldrw.u32 q0,[sp,#64]
	vldrw.u32 q1,[sp,#80]
	vldrw.u32 q2,[sp,#96]
	vldrw.u32 q3,[sp,#112]
	NBF_ADD q4,q5,q0,q1,q2,q3
	vmov q2,q4
	vmov q3,q5
	vldrw.u32 q0,[sp,#128]
	vldrw.u32 q1,[sp,#144]
	NQT_MUL
	vstrw.32 q4,[sp,#128]
	vstrw.32 q5,[sp,#144]
	NQT_COMPONENT_PRODUCT 0,64
	vmov q6,q4
	vmov q7,q5
	NQT_COMPONENT_PRODUCT 32,96
	/* Preserve original z2-(z0+z1), not a four-product substitute. */
	NBF_ADD q0,q1,q6,q7,q4,q5
	NBF_SUB q6,q7,q6,q7,q4,q5
	vldrw.u32 q2,[sp,#128]
	vldrw.u32 q3,[sp,#144]
	NBF_SUB q4,q5,q2,q3,q0,q1
	/* A15: consume real q6/q7 and imaginary q4/q5 directly. The
	 * public gather map moves to a dead vector; no result spill/reload.
	 * Input x and output x/y addresses remain exactly the same. */
	.if \inverse
	vldrw.u32 q2,[r10]
	NQT_STORE q6,q7,r6,q2
	NQT_STORE q4,q5,r7,q2
	.else
	/* q3's offset dies after this load, before q3 receives result.high.
	 * q7's real.high dies after the subtraction, before map reload. */
	vldrw.u32 q3,[r10]
	NQT_LOAD q0,q1,r4,q3
	.if \ht == 1
	/* Full contiguous pair layout: q0/q1=sum, q2/q3=difference.
	 * Compute independent difference first so x may be overwritten by sum. */
	NBF_SUB q2,q3,q0,q1,q6,q7
	NBF_ADD q0,q1,q0,q1,q6,q7
	vst40.32 {q0,q1,q2,q3},[r4]
	vst41.32 {q0,q1,q2,q3},[r4]
	vst42.32 {q0,q1,q2,q3},[r4]
	vst43.32 {q0,q1,q2,q3},[r4]
	vldrw.u32 q7,[r10]
	.else
	NBF_ADD q2,q3,q0,q1,q6,q7
	NBF_SUB q0,q1,q0,q1,q6,q7
	vldrw.u32 q7,[r10]
	NQT_STORE q2,q3,r4
	NQT_STORE q0,q1,r6
	.endif
	NQT_LOAD q0,q1,r5
	.if \ht == 1
	NBF_SUB q2,q3,q0,q1,q4,q5
	NBF_ADD q0,q1,q0,q1,q4,q5
	vst40.32 {q0,q1,q2,q3},[r5]
	vst41.32 {q0,q1,q2,q3},[r5]
	vst42.32 {q0,q1,q2,q3},[r5]
	vst43.32 {q0,q1,q2,q3},[r5]
	.else
	NBF_ADD q2,q3,q0,q1,q4,q5
	NBF_SUB q0,q1,q0,q1,q4,q5
	NQT_STORE q2,q3,r5
	NQT_STORE q0,q1,r7
	.endif
	.endif
	add r4,#64
	add r5,#64
	add r6,#64
	add r7,#64
	add r8,r9
	subs r11,#4
	bne 1b
	b .Lnqt_return
	.endm

	.section .text.fndsa_ntru_q32_tail,"ax",%progbits
	.balign 4
	.global fndsa_ntru_q32_tail
	.type fndsa_ntru_q32_tail,%function
	.thumb_func
fndsa_ntru_q32_tail:
	/* r0=real base, r1=hn>=8, r2=first root, r3=ht | (inverse<<2).
	 * ht is 1 or 2; hn is power-of-two. No partial vector block. */
	push {r4-r11,lr}
	vpush {d8-d15}
	sub sp,#164
	mov r4,r0
	add r5,r4,r1,lsl #3
	lsr r11,r1,#1
	mov r8,r2
	and r0,r3,#3
	add r6,r4,r0,lsl #3
	add r7,r5,r0,lsl #3
	ldr r10,=.Lnqt_offsets
	movs r9,#64
	cmp r0,#2
	bne .Lnqt_ready
	add r10,#32
	movs r9,#32
.Lnqt_ready:
	movs r12,#1
	tst r3,#4
	mov.w r3,#0
	bne .Lnqt_inverse
	cmp r9,#64
	bne .Lnqt_forward_ht2
	NQT_LOOP 0,1
.Lnqt_forward_ht2:
	NQT_LOOP 0,2
.Lnqt_inverse:
	cmp r9,#64
	bne .Lnqt_inverse_ht2
	NQT_LOOP 1,1
.Lnqt_inverse_ht2:
	NQT_LOOP 1,2
.Lnqt_return:
	add sp,#164
	vpop {d8-d15}
	pop {r4-r11,pc}
	.ltorg
	.size fndsa_ntru_q32_tail,.-fndsa_ntru_q32_tail

/* Test-visible instance of the production component macro. Four fxr
 * values in r0, four roots in r1. Root high words must be 0/-1. Inputs
 * are loaded before the in-place output. Not used by whole keygen. */
	.section .text.fndsa_ntru_q32_rootmul4,"ax",%progbits
	.balign 4
	.global fndsa_ntru_q32_rootmul4
	.type fndsa_ntru_q32_rootmul4,%function
	.thumb_func
fndsa_ntru_q32_rootmul4:
	vpush {d8-d11}
	vld20.32 {q0,q1},[r0]
	vld21.32 {q0,q1},[r0]
	vld20.32 {q2,q3},[r1]
	vld21.32 {q2,q3},[r1]
	movs r12,#1
	NQT_MUL_COMPONENT
	vst20.32 {q4,q5},[r0]
	vst21.32 {q4,q5},[r0]
	vpop {d8-d11}
	bx lr
	.size fndsa_ntru_q32_rootmul4,.-fndsa_ntru_q32_rootmul4

	.section .rodata.fndsa_ntru_tail_offsets,"a",%progbits
	.balign 16
.Lnqt_offsets:
	.word 0,16,32,48       /* ht=1: x indices 0,2,4,6; y=x+1 */
	.word 0,16,32,48       /* four roots */
	.word 0,8,32,40        /* ht=2: x indices 0,1,4,5; y=x+2 */
	.word 0,0,16,16        /* two roots, each duplicated */

	.section .rodata.fndsa_ntru_butterfly_cases,"a",%progbits
	.balign 4
.Lfused_cases:
	.word .Lfused_bad_root+1, .Lfused_bad_root+1, .Lfused_bad_root+1, .Lfused_bad_root+1
	.word .Lfused_bad_root+1, .Lfused_bad_root+1, .Lfused_bad_root+1, .Lfused_bad_root+1
	.word .Lfused_bad_root+1, .Lfused_bad_root+1, .Lfused_bad_root+1, .Lfused_bad_root+1
	.word .Lfused_bad_root+1, .Lfused_bad_root+1, .Lfused_bad_root+1, .Lfused_bad_root+1
	.word .Lfused_bad_root+1, .Lfused_bad_root+1, .Lfused_0_18+1, .Lfused_bad_root+1
	.word .Lfused_bad_root+1, .Lfused_bad_root+1, .Lfused_bad_root+1, .Lfused_bad_root+1
	.word .Lfused_bad_root+1, .Lfused_bad_root+1, .Lfused_0_26+1, .Lfused_bad_root+1
	.word .Lfused_bad_root+1, .Lfused_bad_root+1, .Lfused_0_30+1, .Lfused_bad_root+1
	.word .Lfused_bad_root+1, .Lfused_bad_root+1, .Lfused_bad_root+1, .Lfused_bad_root+1
	.word .Lfused_bad_root+1, .Lfused_bad_root+1, .Lfused_0_38+1, .Lfused_0_39+1
	.word .Lfused_bad_root+1, .Lfused_bad_root+1, .Lfused_bad_root+1, .Lfused_bad_root+1
	.word .Lfused_bad_root+1, .Lfused_bad_root+1, .Lfused_bad_root+1, .Lfused_0_47+1
	.word .Lfused_bad_root+1, .Lfused_0_49+1, .Lfused_bad_root+1, .Lfused_bad_root+1
	.word .Lfused_0_52+1, .Lfused_0_53+1, .Lfused_bad_root+1, .Lfused_bad_root+1
	.word .Lfused_bad_root+1, .Lfused_bad_root+1, .Lfused_bad_root+1, .Lfused_bad_root+1
	.word .Lfused_bad_root+1, .Lfused_bad_root+1, .Lfused_bad_root+1, .Lfused_bad_root+1
	.word .Lfused_bad_root+1, .Lfused_bad_root+1, .Lfused_bad_root+1, .Lfused_bad_root+1
	.word .Lfused_bad_root+1, .Lfused_bad_root+1, .Lfused_bad_root+1, .Lfused_bad_root+1
	.word .Lfused_bad_root+1, .Lfused_bad_root+1, .Lfused_1_10+1, .Lfused_1_11+1
	.word .Lfused_bad_root+1, .Lfused_bad_root+1, .Lfused_1_14+1, .Lfused_bad_root+1
	.word .Lfused_1_16+1, .Lfused_bad_root+1, .Lfused_bad_root+1, .Lfused_bad_root+1
	.word .Lfused_bad_root+1, .Lfused_bad_root+1, .Lfused_bad_root+1, .Lfused_bad_root+1
	.word .Lfused_1_24+1, .Lfused_1_25+1, .Lfused_bad_root+1, .Lfused_bad_root+1
	.word .Lfused_bad_root+1, .Lfused_bad_root+1, .Lfused_bad_root+1, .Lfused_bad_root+1
	.word .Lfused_bad_root+1, .Lfused_1_33+1, .Lfused_bad_root+1, .Lfused_bad_root+1
	.word .Lfused_bad_root+1, .Lfused_1_37+1, .Lfused_bad_root+1, .Lfused_bad_root+1
	.word .Lfused_bad_root+1, .Lfused_bad_root+1, .Lfused_bad_root+1, .Lfused_bad_root+1
	.word .Lfused_bad_root+1, .Lfused_1_45+1, .Lfused_bad_root+1, .Lfused_bad_root+1
	.word .Lfused_bad_root+1, .Lfused_bad_root+1, .Lfused_bad_root+1, .Lfused_bad_root+1
	.word .Lfused_bad_root+1, .Lfused_bad_root+1, .Lfused_bad_root+1, .Lfused_bad_root+1
	.word .Lfused_bad_root+1, .Lfused_bad_root+1, .Lfused_bad_root+1, .Lfused_bad_root+1
	.word .Lfused_bad_root+1, .Lfused_bad_root+1, .Lfused_bad_root+1, .Lfused_bad_root+1
	.section .note.GNU-stack,"",%progbits
