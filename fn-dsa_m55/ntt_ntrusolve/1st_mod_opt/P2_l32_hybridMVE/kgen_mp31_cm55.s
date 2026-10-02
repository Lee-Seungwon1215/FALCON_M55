/*
 * Cortex-M55/MVE hybrid NTT over the variable 31-bit primes used by the
 * FN-DSA NTRU solver.
 *
 * All supported p satisfy p < 2^32/phi.  Existing gm/igm values remain in
 * Montgomery-R32 form because other NTRU-solver code reads those tables.
 * For root_mont = w*R, each public root group is converted on the fly to
 * the 64-bit original-Plantard constant
 *
 *   b  = Montgomery(root_mont, -R^2 mod p) = -w*R^2 mod p
 *   bp = b*p^-1 mod R^2, R = 2^32.
 *
 * Four 32-bit lanes then compute Algorithm 9 exactly:
 *
 *   h = high32(low64(a*bp))
 *     = VMULH.U32(a,bp_lo) + VMUL.I32(a,bp_hi)  (mod R)
 *   r = high32((h+1)*p).
 *
 * When h=R-1, h+1 wraps to zero and r=0.  The mathematical Algorithm 9
 * output is p in that case; both represent zero, and the wrapped value is
 * already FN-DSA's canonical [0,p) representation.  Original Plantard is
 * unsigned, so GS differences are canonicalized before multiplication.
 *
 * Final measured layer policy:
 *   - odd-logn forward single first layer: original Plantard l=32;
 *   - odd-logn inverse single final layer: original Plantard l=32;
 *   - all merged two-layer and lane-varying boundary layers: M1 rounding
 *     Montgomery;
 *   - even-logn transforms: M1 only, with Plantard context setup skipped.
 * This restricts Plantard to the maximum-reuse case (one root for n/2
 * coefficients); the broader early/middle hypothesis was measured first
 * and rejected.  The two-layer CT/GS decomposition, stage-wise inverse
 * halving, gm/igm layout and logn<4 C fallback are unchanged.  No
 * three-layer merge, new lazy range, final scaling integration, FP64,
 * Slothy or large root table is included.
 */

	.syntax unified
	.arch armv8.1-m.main
	.arch_extension mve
	.fpu fpv5-d16
	.text

/* Local frame shared by both transforms:
 *   [sp,#0]  public logn
 *   [sp,#4]  public layer counter
 *   [sp,#8]  p^-1 mod R, low limb
 *   [sp,#12] p^-1 mod R^2, high limb
 *   [sp,#16] -R^2 mod p
 *   [sp,#20] p0i = -p^-1 mod R
 */

/* Build the per-prime Plantard context once. r3=p; clobbers r0,r6,r7. */
	.macro MP31_PLANT_CONTEXT
	ldr		r0, [sp, #20]
	rsb		r6, r0, #0		/* pinv_lo = -p0i */
	str		r6, [sp, #8]
	umull		r0, r7, r3, r6	/* p*pinv_lo = 1 + k*R */
	mul		r7, r7, r6
	rsb		r7, r7, #0		/* pinv_hi = -k*pinv_lo */
	str		r7, [sp, #12]
	lsl		r0, r3, #1
	rsb		r0, r0, #0		/* R mod p = R-2p */
	mov		r7, #32
.Lplant_r2_loop\@:
	add		r0, r0, r0
	sub		r0, r0, r3
	and		r6, r3, r0, asr #31
	add		r0, r0, r6
	subs		r7, r7, #1
	bne		.Lplant_r2_loop\@
	rsb		r0, r0, r3		/* -R^2 mod p */
	str		r0, [sp, #16]
	mov		r4, #1			/* scalar +1 for Algorithm 9 */
	.endm

/* Convert q4 from root_mont to bp_lo:q4, bp_hi:q5.  The Montgomery
 * operation here is only root-domain preparation, not the NTT coefficient
 * multiplication under test.  It uses the exact M1 rounding sequence.
 * r3=p; frame as above; q6,q7 and r0 are clobbered.
 */
	.macro MP31_PLANT_ROOT
	ldr		r0, [sp, #16]
	vdup.32	q7, r0			/* -R^2 mod p */
	ldr		r0, [sp, #20]
	vmul.u32	q5, q7, r0		/* low32((-R^2)*p0i) */
	vmul.u32	q6, q4, q5
	vqrdmulh.s32	q4, q4, q7
	vqrdmulh.s32	q6, q6, r3
	vhadd.s32	q4, q4, q6
	vpt.s32	LT, q4, zr
	vaddt.i32	q4, q4, r3		/* q4 = b in [0,p) */
	ldr		r0, [sp, #8]
	vmul.i32	q5, q4, r0		/* bp_lo */
	vdup.32	q6, r0
	vmulh.u32	q6, q4, q6
	ldr		r0, [sp, #12]
	vmul.i32	q7, q4, r0
	vadd.i32	q6, q6, q7		/* bp_hi */
	vmov		q4, q5
	vmov		q5, q6
	vdup.32	q6, r3			/* keep p vector-resident */
	.endm

/* data <- original_Plantard_l32(data,bp), canonical in [0,p).
 * q4=bp_lo, q5=bp_hi, q6=p, r4=1; tmp is clobbered.
 */
	.macro MP31_PLANT data, tmp
	vmul.i32	\tmp, \data, q5
	vmulh.u32	\data, \data, q4
	vadd.i32	\data, \data, \tmp
	vadd.i32	\data, \data, r4
	vmulh.u32	\data, \data, q6
	.endm

/* M1-improve rounding Montgomery path used at the lane-varying boundary
 * layers.  The shared root is still in Montgomery-R32 form. */
	.macro MP31_MONT_ROOT root
	vmul.u32	q5, \root, r4
	.endm

	.macro MP31_MONT data, root, tmp
	vmul.u32	\tmp, \data, q5
	vqrdmulh.s32	\data, \data, \root
	vqrdmulh.s32	\tmp, \tmp, r3
	vhadd.s32	\data, \data, \tmp
	vpt.s32	LT, \data, zr
	vaddt.i32	\data, \data, r3
	.endm

/* Modular add/sub with inputs and output in [0,p). */
	.macro MP31_ADD dst, a, b
	vadd.i32	\dst, \a, \b
	vsub.i32	\dst, \dst, r3
	vpt.s32	LT, \dst, zr
	vaddt.i32	\dst, \dst, r3
	.endm

	.macro MP31_SUB dst, a, b
	vsub.i32	\dst, \a, \b
	vpt.s32	LT, \dst, zr
	vaddt.i32	\dst, \dst, r3
	.endm

/* data <- data/2 mod p. r5 = (p+1)/2; tmp is clobbered. */
	.macro MP31_HALF data, tmp
	vmov		\tmp, \data
	vshl.u32	\tmp, \tmp, #31
	vshr.u32	\tmp, \tmp, #31
	vshr.u32	\data, \data, #1
	vmla.i32	\data, \tmp, r5
	.endm

/* Cooley-Tukey butterfly. b is already multiplied by its root. */
	.macro MP31_CT a, b, tmp
	MP31_ADD	\tmp, \a, \b
	MP31_SUB	\b, \a, \b
	vmov		\a, \tmp
	.endm

/* Gentleman-Sande butterfly with stage-wise halving.  Original Plantard
 * takes unsigned canonical inputs, so the difference is reduced to [0,p)
 * before multiplication.
 */
	.macro MP31_GS a, b, tmp
	MP31_SUB	\tmp, \a, \b
	MP31_ADD	\a, \a, \b
	MP31_HALF	\a, \b
	MP31_PLANT	\tmp, \b
	vmov		\b, \tmp
	.endm

/* The M1 path accepts the exact signed GS difference, avoiding the
 * canonicalization that original Plantard requires. */
	.macro MP31_MONT_GS a, b, root, tmp, work
	vsub.i32	\tmp, \a, \b
	MP31_ADD	\a, \a, \b
	MP31_HALF	\a, \b
	MP31_MONT	\tmp, \root, \work
	vmov		\b, \tmp
	.endm

/*
 * void fndsa_mp_NTT(unsigned logn, uint32_t *a, const uint32_t *gm,
 *                   uint32_t p, uint32_t p0i)
 *
 * q0..q3: four coefficient streams
 * q4:     current root
 * q5:     current root * p0i (low 32 bits)
 * q6,q7:  multiply and butterfly scratch
 */
	.align 2
	.global fndsa_mp_NTT
	.thumb
	.thumb_func
	.type fndsa_mp_NTT, %function
fndsa_mp_NTT:
	cmp		r0, #4
	blo.w		fndsa_mp_NTT_c

	push.w		{r4-r11, r12, lr}
	vpush		{d8-d15}
	sub		sp, sp, #24
	str		r0, [sp, #0]		/* public logn */
	/* 5th AAPCS argument: 40-byte core save + 64-byte MVE save
	 * + 24-byte local frame = 128 bytes above the current SP. */
	ldr		r0, [sp, #128]		/* caller's p0i */
	str		r0, [sp, #20]
	ldr		r0, [sp, #0]
	tst		r0, #1
	beq		.Lntt_no_plant_context
	MP31_PLANT_CONTEXT
	ldr		r0, [sp, #0]
	b		.Lntt_context_ready
.Lntt_no_plant_context:
	ldr		r4, [sp, #20]
.Lntt_context_ready:

	/* n = 2^logn.  An odd logn starts with one single CT layer. */
	movs		r5, #1
	lsl		r5, r5, r0
	tst		r0, #1
	beq		.Lntt_even_start
	lsr		r5, r5, #1		/* t = n/2 (elements) */
	ldr		r0, [r2, #4]
	vdup.32		q4, r0
	MP31_PLANT_ROOT
	mov		r9, r1
	add		r10, r1, r5, lsl #2
	mov		r11, r5
.Lntt_odd_loop:
	vldrw.u32	q0, [r9]
	vldrw.u32	q1, [r10]
	MP31_PLANT	q1, q7
	MP31_CT	q0, q1, q7
	vstrw.u32	q0, [r9], #16
	vstrw.u32	q1, [r10], #16
	subs		r11, r11, #4
	bne		.Lntt_odd_loop
	ldr		r4, [sp, #20]		/* remaining layers use M1 */
	movs		r0, #1
	str		r0, [sp, #4]		/* lm = 1 */
	b		.Lntt_two_check

.Lntt_even_start:
	movs		r0, #0
	str		r0, [sp, #4]		/* lm = 0; t = n */

	/* Merged two-layer CT passes.  qt*4 bytes equals t elements. */
.Lntt_two_check:
	ldr		r6, [sp, #4]
	ldr		r0, [sp, #0]
	adds		r7, r6, #3
	cmp		r7, r0
	bge		.Lntt_last_two

	movs		r7, #1
	lsl		r7, r7, r6		/* outer groups m = 2^lm */
	add		r8, r2, r7, lsl #2	/* &gm[m] */
	mov		r9, r1			/* j0 base */

.Lntt_two_group:
	add		r10, r9, r5
	mov		lr, r10			/* end of k0 stream */
	add		r11, r10, r5
	add		r12, r11, r5
.Lntt_two_inner:
	vldrw.u32	q0, [r9]
	vldrw.u32	q1, [r10]
	vldrw.u32	q2, [r11]
	vldrw.u32	q3, [r12]

	ldr		r0, [r8]
	vdup.32		q4, r0			/* s */
	MP31_MONT_ROOT q4
	MP31_MONT	q2, q4, q6
	MP31_CT	q0, q2, q7
	MP31_MONT	q3, q4, q6
	MP31_CT	q1, q3, q7
	add		r0, r8, r8
	sub		r0, r0, r2		/* &gm[2*(i+m)] */
	ldr		r6, [r0]
	vdup.32		q4, r6			/* s0 */
	MP31_MONT_ROOT q4
	MP31_MONT	q1, q4, q6
	MP31_CT	q0, q1, q7
	ldr		r6, [r0, #4]
	vdup.32		q4, r6			/* s1 */
	MP31_MONT_ROOT q4
	MP31_MONT	q3, q4, q6
	MP31_CT	q2, q3, q7

	vstrw.u32	q0, [r9], #16
	vstrw.u32	q1, [r10], #16
	vstrw.u32	q2, [r11], #16
	vstrw.u32	q3, [r12], #16
	cmp		r9, lr
	bne		.Lntt_two_inner
	add		r8, r8, #4
	mov		r9, r12			/* next j0 = old j0 + t */
	subs		r7, r7, #1
	bne		.Lntt_two_group

	lsr		r5, r5, #2		/* t = qt */
	ldr		r6, [sp, #4]
	adds		r6, r6, #2
	str		r6, [sp, #4]
	b		.Lntt_two_check

	/* Final two layers: four adjacent radix-4 groups form four lanes. */
.Lntt_last_two:
	ldr		r0, [sp, #0]
	subs		r0, r0, #2
	movs		r7, #1
	lsl		r7, r7, r0		/* m = n/4 */
	add		r8, r2, r7, lsl #2	/* s roots */
	add		r9, r2, r7, lsl #3	/* interleaved s0/s1 roots */
	mov		r10, r1
.Lntt_last_loop:
	vld40.32	{q0,q1,q2,q3}, [r10]
	vld41.32	{q0,q1,q2,q3}, [r10]
	vld42.32	{q0,q1,q2,q3}, [r10]
	vld43.32	{q0,q1,q2,q3}, [r10]
	vldrw.u32	q4, [r8], #16
	MP31_MONT_ROOT q4
	MP31_MONT	q2, q4, q6
	MP31_CT	q0, q2, q7
	MP31_MONT	q3, q4, q6
	MP31_CT	q1, q3, q7
	adr		r0, .Lmp31_stride8
	vldrw.u32	q7, [r0]
	vldrw.u32	q4, [r9, q7]		/* s0 */
	MP31_MONT_ROOT q4
	MP31_MONT	q1, q4, q6
	MP31_CT	q0, q1, q7
	adr		r0, .Lmp31_stride8
	vldrw.u32	q7, [r0]
	add		r11, r9, #4
	vldrw.u32	q4, [r11, q7]		/* s1 */
	MP31_MONT_ROOT q4
	MP31_MONT	q3, q4, q6
	MP31_CT	q2, q3, q7
	add		r9, r9, #32

	vst40.32	{q0,q1,q2,q3}, [r10]
	vst41.32	{q0,q1,q2,q3}, [r10]
	vst42.32	{q0,q1,q2,q3}, [r10]
	vst43.32	{q0,q1,q2,q3}, [r10]
	add		r10, r10, #64
	subs		r7, r7, #4
	bne		.Lntt_last_loop

	add		sp, sp, #24
	vpop		{d8-d15}
	pop.w		{r4-r11, r12, pc}
	.size fndsa_mp_NTT, .-fndsa_mp_NTT

/*
 * void fndsa_mp_iNTT(unsigned logn, uint32_t *a, const uint32_t *igm,
 *                    uint32_t p, uint32_t p0i)
 */
	.align 2
	.global fndsa_mp_iNTT
	.thumb
	.thumb_func
	.type fndsa_mp_iNTT, %function
fndsa_mp_iNTT:
	cmp		r0, #4
	blo.w		fndsa_mp_iNTT_c

	push.w		{r4-r11, r12, lr}
	vpush		{d8-d15}
	sub		sp, sp, #24
	str		r0, [sp, #0]
	ldr		r0, [sp, #128]		/* caller's p0i */
	str		r0, [sp, #20]
	ldr		r0, [sp, #0]
	tst		r0, #1
	beq		.Lintt_no_plant_context
	MP31_PLANT_CONTEXT
.Lintt_no_plant_context:
	ldr		r4, [sp, #20]		/* M1 through the merged layers */
	add		r5, r3, #1
	lsr		r5, r5, #1		/* (p+1)/2 */
	ldr		r0, [sp, #0]

	/* First two GS layers, vectorized across four radix-4 groups. */
	subs		r0, r0, #2
	movs		r7, #1
	lsl		r7, r7, r0		/* qn = n/4 */
	add		r8, r2, r7, lsl #2	/* s roots */
	add		r9, r2, r7, lsl #3	/* interleaved s0/s1 */
	mov		r10, r1
	mov		r6, r7
.Lintt_first_loop:
	vld40.32	{q0,q1,q2,q3}, [r10]
	vld41.32	{q0,q1,q2,q3}, [r10]
	vld42.32	{q0,q1,q2,q3}, [r10]
	vld43.32	{q0,q1,q2,q3}, [r10]
	adr		r0, .Lmp31_stride8
	vldrw.u32	q7, [r0]
	vldrw.u32	q4, [r9, q7]		/* s0 */
	MP31_MONT_ROOT q4
	MP31_MONT_GS q0, q1, q4, q7, q6
	adr		r0, .Lmp31_stride8
	vldrw.u32	q7, [r0]
	add		r11, r9, #4
	vldrw.u32	q4, [r11, q7]		/* s1 */
	MP31_MONT_ROOT q4
	MP31_MONT_GS q2, q3, q4, q7, q6
	vldrw.u32	q4, [r8], #16		/* s */
	MP31_MONT_ROOT q4
	MP31_MONT_GS q0, q2, q4, q7, q6
	MP31_MONT_GS q1, q3, q4, q7, q6
	add		r9, r9, #32

	vst40.32	{q0,q1,q2,q3}, [r10]
	vst41.32	{q0,q1,q2,q3}, [r10]
	vst42.32	{q0,q1,q2,q3}, [r10]
	vst43.32	{q0,q1,q2,q3}, [r10]
	add		r10, r10, #64
	subs		r6, r6, #4
	bne		.Lintt_first_loop

	movs		r6, #16		/* current t, in bytes */
	movs		r0, #2
	str		r0, [sp, #4]		/* lm = 2 */

	/* Remaining merged two-layer GS passes. */
.Lintt_two_check:
	ldr		r0, [sp, #4]
	ldr		r7, [sp, #0]
	adds		r8, r0, #1
	cmp		r8, r7
	bge		.Lintt_odd_check

	subs		r7, r7, #2
	subs		r7, r7, r0
	movs		r8, #1
	lsl		r7, r8, r7		/* qm = 2^(logn-2-lm) */
	add		r8, r2, r7, lsl #2	/* &igm[qm] */
	mov		r9, r1			/* j0 base */

.Lintt_two_group:
	add		r10, r9, r6
	mov		lr, r10
	add		r11, r10, r6
	add		r12, r11, r6
.Lintt_two_inner:
	vldrw.u32	q0, [r9]
	vldrw.u32	q1, [r10]
	vldrw.u32	q2, [r11]
	vldrw.u32	q3, [r12]

	add		r0, r8, r8
	sub		r0, r0, r2
	ldr		r0, [r0]
	vdup.32		q4, r0			/* s0 */
	MP31_MONT_ROOT q4
	MP31_MONT_GS q0, q1, q4, q7, q6
	add		r0, r8, r8
	sub		r0, r0, r2
	ldr		r0, [r0, #4]
	vdup.32		q4, r0			/* s1 */
	MP31_MONT_ROOT q4
	MP31_MONT_GS q2, q3, q4, q7, q6
	ldr		r0, [r8]
	vdup.32		q4, r0			/* s */
	MP31_MONT_ROOT q4
	MP31_MONT_GS q0, q2, q4, q7, q6
	MP31_MONT_GS q1, q3, q4, q7, q6

	vstrw.u32	q0, [r9], #16
	vstrw.u32	q1, [r10], #16
	vstrw.u32	q2, [r11], #16
	vstrw.u32	q3, [r12], #16
	cmp		r9, lr
	bne		.Lintt_two_inner
	add		r8, r8, #4
	mov		r9, r12
	subs		r7, r7, #1
	bne		.Lintt_two_group

	lsl		r6, r6, #2		/* t = 4*t */
	ldr		r0, [sp, #4]
	adds		r0, r0, #2
	str		r0, [sp, #4]
	b		.Lintt_two_check

	/* An odd logn has one final GS layer. */
.Lintt_odd_check:
	ldr		r0, [sp, #0]
	tst		r0, #1
	beq		.Lintt_done
	subs		r0, r0, #1
	movs		r7, #1
	lsl		r7, r7, r0		/* hn = n/2 */
	mov		r4, #1			/* original Plantard +1 */
	ldr		r0, [r2, #4]
	vdup.32		q4, r0
	MP31_PLANT_ROOT
	mov		r9, r1
	add		r10, r1, r7, lsl #2
.Lintt_odd_loop:
	vldrw.u32	q0, [r9]
	vldrw.u32	q1, [r10]
	MP31_GS	q0, q1, q7
	vstrw.u32	q0, [r9], #16
	vstrw.u32	q1, [r10], #16
	subs		r7, r7, #4
	bne		.Lintt_odd_loop

.Lintt_done:
	add		sp, sp, #24
	vpop		{d8-d15}
	pop.w		{r4-r11, r12, pc}
	.size fndsa_mp_iNTT, .-fndsa_mp_iNTT

	.align 4
.Lmp31_stride8:
	.word 0, 8, 16, 24

/* Test-only entry point for the exact Plantard coefficient macro.  The
 * historical symbol name is kept because the audit harness probes this
 * optional interface.  The separate section is
 * garbage-collected from performance firmware (no caller there).
 * void fndsa_mp31_monty4_probe(uint32_t a[4], const uint32_t b[4],
 *                             uint32_t p, uint32_t p0i);
 */
	.section .text.fndsa_mp31_monty4_probe,"ax",%progbits
	.align 2
	.global fndsa_mp31_monty4_probe
	.thumb_func
	.type fndsa_mp31_monty4_probe, %function
fndsa_mp31_monty4_probe:
	push		{r4-r8, lr}
	vpush		{d8-d15}
	sub		sp, sp, #24
	mov		r5, r0
	str		r3, [sp, #20]
	mov		r3, r2
	MP31_PLANT_CONTEXT
	vldrw.u32	q4, [r1]
	MP31_PLANT_ROOT
	vldrw.u32	q0, [r5]
	/* The generic audit also supplies the signed GS range used by M1.
	 * Mirror the production Plantard GS contract by canonicalizing it. */
	vpt.s32		LT, q0, zr
	vaddt.i32	q0, q0, r3
	MP31_PLANT	q0, q7
	vstrw.u32	q0, [r5]
	add		sp, sp, #24
	vpop		{d8-d15}
	pop		{r4-r8, pc}
	.size fndsa_mp31_monty4_probe, .-fndsa_mp31_monty4_probe

	.section .note.GNU-stack,"",%progbits
