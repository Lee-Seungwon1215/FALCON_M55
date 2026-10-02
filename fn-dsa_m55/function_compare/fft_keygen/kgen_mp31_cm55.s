/*
 * Cortex-M55/MVE NTT over the variable 31-bit primes used by the FN-DSA
 * NTRU solver.
 *
 * D1 array-boundary experiment (built on adopted H1 / L2 / M1-improve):
 *   - exact, rounding Montgomery multiplication (four 32-bit lanes);
 *   - direct signed GS differences, without a redundant pre-normalization;
 *   - the same two-layer CT/GS decomposition as kgen_mp31.c;
 *   - unscaled inverse layers, with 1/n fused into the last GS layer;
 *   - full inverse roots w*R prepared outside the timed transform;
 *   - K2 root preparation pipelined across independent butterfly work;
 *   - K4-A staggered coefficient loads and early stores in forward CT2;
 *   - K4-B staggered coefficient loads and early stores in inverse GS2;
 *   - forward: transpose on the penultimate CT2 store, not the final load;
 *   - inverse: transpose on the second GS2 load, not the first store;
 *   - ordinary external ordering, including forward logn=4/6;
 *   - C fallback for logn < 4.
 *
 * This intentionally does not include Plantard, three-layer merging,
 * or Slothy scheduling. Existing gm/full-igm arrays are never modified.
 * The directory name is historical: H1 already used final VLD4 loads.
 * See Fast and Clean, Section 8.2.2, Listing 10, pp. 32-34. The inverse
 * boundary is the corresponding local transpose, not a non-canonical API.
 *
 * Based on rounding Montgomery (Neon NTT, Algorithm 8), with a halving
 * add to preserve the full 31-bit modulus range and the original R=2^32
 * scale. Do NOT replace the last two operations with saturating VQRDMLAH.
 *
 * For -p < a < p, 0 <= b < p < 2^31 and p0i = -p^-1 mod R:
 *   twist = low32(b * p0i)                 (prepared once per root load)
 *   l = signed32(low32(a * twist))
 *   h = floor(2*a*b/R + 1/2)               (VQRDMULH)
 *   c = floor(2*l*p/R + 1/2)               (VQRDMULH)
 *   z = floor((h+c)/2)                     (VHADD, NOT wrapping VADD)
 *
 * a*b+l*p = k*R exactly. Hence h+c is 2*k, or 2*k+1 at a rounding tie;
 * the arithmetic halving yields k in both cases (also for negative k).
 * The individual h and c fit signed 32 bits, although their sum need not.
 * VHADD retains the extra sum bit. Also -p/2 <= k < p, so one predicated
 * addition of p normalizes to [0,p). In the wider signed-input case,
 * -p < k < p; canonical inputs retain the tighter -p/2 <= k < p bound.
 * No odd-root assumption is needed.
 * Forward gm values are unchanged. The inverse table contains w*R instead
 * of the traditional w*R/2.
 */

	.syntax unified
	.arch armv8.1-m.main
	.arch_extension mve
	.fpu fpv5-d16
	.text

/* Prepare q5 = low32(root*p0i), leaving the original root intact.
 * r4 = p0i. No table, extra buffer, or coefficient-dependent address.
 */
	.macro MP31_ROOT root
	vmul.u32	q5, \root, r4
	.endm

/* data <- data*root/R mod p, in [0,p).
 * The input may be either canonical (0 <= data < p) or a signed modular
 * difference (-p < data < p).  The low-word VMUL is representation agnostic,
 * while both rounded-high operations intentionally interpret it as signed.
 * r3 = p, q5 = low32(root*p0i). hi is clobbered; root and q5 are intact.
 * Four core instructions plus two normalization instructions. Root
 * preparation is a separate instruction, amortized when a root is reused.
 */
	.macro MP31_MONT data, root, hi
	vmul.u32	\hi, \data, q5
	vqrdmulh.s32	\data, \data, \root
	vqrdmulh.s32	\hi, \hi, r3
	vhadd.s32	\data, \data, \hi
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

/* The inverse table already contains w*R. */
	.macro MP31_IROOT root
	MP31_ROOT	\root
	.endm

/* Cooley-Tukey butterfly. b is already multiplied by its root. */
	.macro MP31_CT a, b, tmp
	MP31_ADD	\tmp, \a, \b
	MP31_SUB	\b, \a, \b
	vmov		\a, \tmp
	.endm

/* Gentleman-Sande butterfly WITHOUT stage-wise halving.
 *
 * Since a and b are canonical, their direct signed difference is strictly
 * between -p and p and therefore fits int32_t for every supported p < 2^31.
 * Montgomery multiplication is congruence preserving, so normalizing that
 * difference before the multiplication would be redundant.  Keeping it
 * signed removes the VPT/VADDT pair previously emitted by MP31_SUB; the
 * Montgomery result itself is still normalized once before leaving GS.
 */
	.macro MP31_GS a, b, root, tmp, work
	vsub.i32	\tmp, \a, \b
	MP31_ADD	\a, \a, \b
	MP31_MONT	\tmp, \root, \work
	vmov		\b, \tmp
	.endm

/* Prepare the LAST difference root w*R/n once per transform.
 * r5=R/n=2^(32-logn), already canonical for all supported 31-bit primes.
 * Mont(igm[1],r5) directly gives w*R/n.
 * q0/q4/q5/q6 are scratch here, before loading the final coefficient tile.
 * VMOV transfers bits to a GPR; it performs no floating-point arithmetic.
 */
	.macro MP31_FINAL_ROOT dst
	vdup.32		q4, r5
	MP31_ROOT	q4
	ldr		r0, [r2, #4]
	vdup.32		q0, r0
	MP31_MONT	q0, q4, q6
	vmov		\dst, s0
	.endm

/* CT2 arithmetic and memory order are unchanged. Root preparation for the
 * next butterfly overlaps independent add/sub work from the previous one.
 * r8 = first root, r2 = gm; r0/r6 scratch. Four data vectors q0..q3.
 */
	.macro MP31_CT2_TILE
	ldr		r0, [r8]
	vdup.32		q4, r0
	MP31_ROOT	q4
	MP31_MONT	q2, q4, q6
	MP31_CT	q0, q2, q7
	MP31_MONT	q3, q4, q6
	add		r0, r8, r8
	sub		r0, r0, r2
	ldr		r6, [r0]
	vdup.32		q4, r6
	MP31_ROOT	q4
	MP31_CT	q1, q3, q7
	MP31_MONT	q1, q4, q6
	ldr		r6, [r0, #4]
	vdup.32		q4, r6
	MP31_ROOT	q4
	MP31_CT	q0, q1, q7
	MP31_MONT	q3, q4, q6
	MP31_CT	q2, q3, q7
	.endm

/* K4-A forward-only coefficient-memory schedule for ordinary CT2 tiles.
 * Four consecutive coefficient loads are split around independent root and
 * Montgomery work. Once q0/q1 reach their final values, their stores are
 * issued inside the last q3 Montgomery dependency chain. q2/q3 are stored
 * after the final butterfly. This keeps the same arithmetic, addresses and
 * memory access count as MP31_CT2_TILE, uses no spill, and leaves all inverse
 * paths unchanged. p0..p3 are post-incremented by one vector.
 */
	.macro MP31_CT2_TILE_K4A p0, p1, p2, p3
	vldrw.u32	q0, [\p0]
	vldrw.u32	q2, [\p2]
	ldr		r0, [r8]
	vdup.32		q4, r0
	MP31_ROOT	q4
	vldrw.u32	q1, [\p1]
	vmul.u32	q6, q2, q5
	vldrw.u32	q3, [\p3]
	vqrdmulh.s32	q2, q2, q4
	vqrdmulh.s32	q6, q6, r3
	vhadd.s32	q2, q2, q6
	vpt.s32		LT, q2, zr
	vaddt.i32	q2, q2, r3
	MP31_CT	q0, q2, q7
	MP31_MONT	q3, q4, q6
	add		r0, r8, r8
	sub		r0, r0, r2
	ldr		r6, [r0]
	vdup.32		q4, r6
	MP31_ROOT	q4
	MP31_CT	q1, q3, q7
	MP31_MONT	q1, q4, q6
	ldr		r6, [r0, #4]
	vdup.32		q4, r6
	MP31_ROOT	q4
	MP31_CT	q0, q1, q7

	/* q0/q1 are final and can overlap the q3 reduction. */
	vmul.u32	q6, q3, q5
	vstrw.u32	q0, [\p0], #16
	vqrdmulh.s32	q3, q3, q4
	vstrw.u32	q1, [\p1], #16
	vqrdmulh.s32	q6, q6, r3
	vhadd.s32	q3, q3, q6
	vpt.s32		LT, q3, zr
	vaddt.i32	q3, q3, r3
	MP31_CT	q2, q3, q7
	vstrw.u32	q2, [\p2], #16
	vstrw.u32	q3, [\p3], #16
	.endm

/* GS2 arithmetic and memory order are unchanged. Root preparation for the
 * next butterfly overlaps the previous result move.
 * r8 = first root, r2 = igm, r0 scratch.
 */
	.macro MP31_GS2_TILE
	add		r0, r8, r8
	sub		r0, r0, r2
	ldr		r0, [r0]
	vdup.32		q4, r0
	MP31_IROOT	q4
	vsub.i32	q7, q0, q1
	MP31_ADD	q0, q0, q1
	MP31_MONT	q7, q4, q6
	add		r0, r8, r8
	sub		r0, r0, r2
	ldr		r0, [r0, #4]
	vdup.32		q4, r0
	MP31_IROOT	q4
	vmov		q1, q7
	vsub.i32	q7, q2, q3
	MP31_ADD	q2, q2, q3
	MP31_MONT	q7, q4, q6
	ldr		r0, [r8]
	vdup.32		q4, r0
	MP31_IROOT	q4
	vmov		q3, q7
	MP31_GS	q0, q2, q4, q7, q6
	MP31_GS	q1, q3, q4, q7, q6
	.endm

/* K4-B inverse-only coefficient-memory schedule for ordinary GS2 tiles.
 * q0/q1 are loaded first because the first GS butterfly consumes them;
 * q2/q3 loads are issued around independent root preparation and q0/q1
 * arithmetic. Once q0/q2 reach their final values, their stores overlap the
 * last q1/q3 Montgomery dependency chain. The arithmetic, addresses, memory
 * access count and inverse-root order are identical to MP31_GS2_TILE.
 * p0..p3 are post-incremented by one vector. Forward paths are untouched.
 */
	.macro MP31_GS2_TILE_K4B p0, p1, p2, p3
	vldrw.u32	q0, [\p0]
	vldrw.u32	q1, [\p1]
	add		r0, r8, r8
	sub		r0, r0, r2
	ldr		r0, [r0]
	vdup.32		q4, r0
	MP31_IROOT	q4
	vldrw.u32	q2, [\p2]
	vsub.i32	q7, q0, q1
	vldrw.u32	q3, [\p3]
	MP31_ADD	q0, q0, q1
	MP31_MONT	q7, q4, q6
	add		r0, r8, r8
	sub		r0, r0, r2
	ldr		r0, [r0, #4]
	vdup.32		q4, r0
	MP31_IROOT	q4
	vmov		q1, q7
	vsub.i32	q7, q2, q3
	MP31_ADD	q2, q2, q3
	MP31_MONT	q7, q4, q6
	ldr		r0, [r8]
	vdup.32		q4, r0
	MP31_IROOT	q4
	vmov		q3, q7
	MP31_GS	q0, q2, q4, q7, q6

	/* q0/q2 are final and can overlap the q1/q3 reduction. */
	vsub.i32	q7, q1, q3
	MP31_ADD	q1, q1, q3
	vmul.u32	q6, q7, q5
	vstrw.u32	q0, [\p0], #16
	vqrdmulh.s32	q7, q7, q4
	vstrw.u32	q2, [\p2], #16
	vqrdmulh.s32	q6, q6, r3
	vhadd.s32	q7, q7, q6
	vpt.s32	LT, q7, zr
	vaddt.i32	q7, q7, r3
	vmov		q3, q7
	vstrw.u32	q1, [\p1], #16
	vstrw.u32	q3, [\p3], #16
	.endm

/* Exactly one 16-word tile per group at t=16. Transpose on the store:
 * memory[4*j+i] = q_i[j]. The final CT2 can then use four plain loads.
 * No new array or spill, and the final VST4 restores the external order.
 */
	.macro MP31_CT2_TRANSPOSE_STORE
	vldrw.u32	q0, [r9]
	vldrw.u32	q1, [r9, #16]
	vldrw.u32	q2, [r9, #32]
	vldrw.u32	q3, [r9, #48]
	MP31_CT2_TILE
	vst40.32	{q0,q1,q2,q3}, [r9]
	vst41.32	{q0,q1,q2,q3}, [r9]
	vst42.32	{q0,q1,q2,q3}, [r9]
	vst43.32	{q0,q1,q2,q3}, [r9]
	add		r9, r9, #64
	add		r8, r8, #4
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
	/* Public size guard: small dispatcher handles logn<=6; logn>=7
	 * keeps the original straight-through path and instruction addresses. */
	cmp		r0, #6
	bls.w		fndsa_mp_NTT_small
.Lntt_regular:

	push.w		{r4-r11, r12, lr}
	vpush		{d8-d15}
	sub		sp, sp, #8
	str		r0, [sp, #0]		/* public logn */
	/* 5th AAPCS argument: 40-byte core save + 64-byte MVE save
	 * + 8-byte local frame = 112 bytes above the current SP. */
	ldr		r4, [sp, #112]		/* caller's p0i */

	/* n = 2^logn.  An odd logn starts with one single CT layer. */
	movs		r5, #1
	lsl		r5, r5, r0
	tst		r0, #1
	beq		.Lntt_even_start
	lsr		r5, r5, #1		/* t = n/2 (elements) */
	ldr		r0, [r2, #4]
	vdup.32		q4, r0
	MP31_ROOT	q4
	mov		r9, r1
	add		r10, r1, r5, lsl #2
	mov		r11, r5
.Lntt_odd_loop:
	vldrw.u32	q0, [r9]
	vldrw.u32	q1, [r10]
	MP31_MONT	q1, q4, q6
	MP31_CT	q0, q1, q7
	vstrw.u32	q0, [r9], #16
	vstrw.u32	q1, [r10], #16
	subs		r11, r11, #4
	bne		.Lntt_odd_loop
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
	cmp		r5, #16
	beq.w		.Lntt_penultimate

.Lntt_two_group:
	add		r10, r9, r5
	mov		lr, r10			/* end of k0 stream */
	add		r11, r10, r5
	add		r12, r11, r5
.Lntt_two_inner:
	MP31_CT2_TILE_K4A r9, r10, r11, r12
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

.Lntt_penultimate:
	MP31_CT2_TRANSPOSE_STORE
	subs		r7, r7, #1
	bne		.Lntt_penultimate
	/* The next pass is final CT2; no layer counter update is needed. */

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
	vldrw.u32	q0, [r10]
	vldrw.u32	q1, [r10, #16]
	vldrw.u32	q2, [r10, #32]
	vldrw.u32	q3, [r10, #48]
	vldrw.u32	q4, [r8], #16
	MP31_ROOT	q4
	MP31_MONT	q2, q4, q6
	MP31_CT	q0, q2, q7
	MP31_MONT	q3, q4, q6
	adr		r0, .Lmp31_stride8
	vldrw.u32	q7, [r0]
	vldrw.u32	q4, [r9, q7]		/* s0 */
	MP31_ROOT	q4
	MP31_CT	q1, q3, q7
	MP31_MONT	q1, q4, q6
	adr		r0, .Lmp31_stride8
	vldrw.u32	q7, [r0]
	add		r11, r9, #4
	vldrw.u32	q4, [r11, q7]		/* s1 */
	MP31_ROOT	q4
	MP31_CT	q0, q1, q7
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

	add		sp, sp, #8
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
	sub		sp, sp, #8
	str		r0, [sp, #0]
	ldr		r4, [sp, #112]		/* caller's p0i */
	movs		r5, #1
	rsb		r7, r0, #32
	lsl		r5, r5, r7		/* R/n: Montgomery representation of 1/n */

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
	MP31_IROOT	q4
	vsub.i32	q7, q0, q1
	MP31_ADD	q0, q0, q1
	MP31_MONT	q7, q4, q6
	adr		r0, .Lmp31_stride8
	vldrw.u32	q6, [r0]
	add		r11, r9, #4
	vldrw.u32	q4, [r11, q6]		/* s1 */
	MP31_IROOT	q4
	vmov		q1, q7
	vsub.i32	q7, q2, q3
	MP31_ADD	q2, q2, q3
	MP31_MONT	q7, q4, q6
	vldrw.u32	q4, [r8], #16		/* s */
	MP31_IROOT	q4
	vmov		q3, q7
	MP31_GS	q0, q2, q4, q7, q6
	MP31_GS	q1, q3, q4, q7, q6
	add		r9, r9, #32

	/* Retain the transposed tile until the next GS2 load. */
	vstrw.u32	q0, [r10]
	vstrw.u32	q1, [r10, #16]
	vstrw.u32	q2, [r10, #32]
	vstrw.u32	q3, [r10, #48]
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
	adds		r8, r0, #2
	cmp		r8, r7
	beq		.Lintt_final_two
	bgt		.Lintt_final_one

	subs		r7, r7, #2
	subs		r7, r7, r0
	movs		r8, #1
	lsl		r7, r8, r7		/* qm = 2^(logn-2-lm) */
	add		r8, r2, r7, lsl #2	/* &igm[qm] */
	mov		r9, r1			/* j0 base */
	cmp		r6, #16
	beq.w		.Lintt_second

.Lintt_two_group:
	add		r10, r9, r6
	mov		lr, r10
	add		r11, r10, r6
	add		r12, r11, r6
.Lintt_two_inner:
	MP31_GS2_TILE_K4B r9, r10, r11, r12
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

	/* Only the GS2 immediately after the first pass consumes transposed
	 * tiles. Ordinary ordering is restored by these four plain stores.
	 * logn=4 reaches the final-two kernel instead, handled separately.
	 */
.Lintt_second:
	vld40.32	{q0,q1,q2,q3}, [r9]
	vld41.32	{q0,q1,q2,q3}, [r9]
	vld42.32	{q0,q1,q2,q3}, [r9]
	vld43.32	{q0,q1,q2,q3}, [r9]
	MP31_GS2_TILE
	vstrw.u32	q0, [r9]
	vstrw.u32	q1, [r9, #16]
	vstrw.u32	q2, [r9, #32]
	vstrw.u32	q3, [r9, #48]
	add		r8, r8, #4
	add		r9, r9, #64
	subs		r7, r7, #1
	bne		.Lintt_second
	movs		r6, #64
	movs		r0, #4
	str		r0, [sp, #4]
	b		.Lintt_two_check

	/* Even logn: finish the final TWO layers without an extra array pass.
	 * The first layer uses ordinary (restored) roots igm[2] and igm[3].
	 * In the last layer q2/q3 use the pre-scaled root, and q0/q1 are
	 * multiplied by R/n before the four outputs are stored once.
	 * There is exactly one group; r7 can hold the final root for the loop.
	 */
.Lintt_final_two:
	MP31_FINAL_ROOT r7
	mov		r9, r1
	add		r10, r9, r6
	mov		lr, r10
	add		r11, r10, r6
	add		r12, r11, r6
	/* logn=4: exactly one tile, still in the first pass's local order. */
	cmp		r6, #16
	bne		.Lintt_final_two_loop
	vld40.32	{q0,q1,q2,q3}, [r9]
	vld41.32	{q0,q1,q2,q3}, [r9]
	vld42.32	{q0,q1,q2,q3}, [r9]
	vld43.32	{q0,q1,q2,q3}, [r9]
	b		.Lintt_final_two_body
.Lintt_final_two_loop:
	vldrw.u32	q0, [r9]
	vldrw.u32	q1, [r10]
	vldrw.u32	q2, [r11]
	vldrw.u32	q3, [r12]
.Lintt_final_two_body:
	ldr		r0, [r2, #8]
	vdup.32		q4, r0
	MP31_IROOT	q4
	vsub.i32	q7, q0, q1
	MP31_ADD	q0, q0, q1
	MP31_MONT	q7, q4, q6
	ldr		r0, [r2, #12]
	vdup.32		q4, r0
	MP31_IROOT	q4
	vmov		q1, q7
	vsub.i32	q7, q2, q3
	MP31_ADD	q2, q2, q3
	MP31_MONT	q7, q4, q6
	vdup.32		q4, r7
	MP31_ROOT	q4
	vmov		q3, q7
	MP31_GS	q0, q2, q4, q7, q6
	vsub.i32	q7, q1, q3
	MP31_ADD	q1, q1, q3
	MP31_MONT	q7, q4, q6
	vdup.32		q4, r5
	MP31_ROOT	q4
	vmov		q3, q7
	MP31_MONT	q0, q4, q6
	MP31_MONT	q1, q4, q6
	vstrw.u32	q0, [r9], #16
	vstrw.u32	q1, [r10], #16
	vstrw.u32	q2, [r11], #16
	vstrw.u32	q3, [r12], #16
	cmp		r9, lr
	bne		.Lintt_final_two_loop
	b		.Lintt_done

	/* Odd logn: the same final scaling, fused into the last SINGLE layer.
	 * r8 retains the scaled difference root, r5 retains the sum scale.
	 */
.Lintt_final_one:
	MP31_FINAL_ROOT r8
	ldr		r0, [sp, #0]
	subs		r0, r0, #1
	movs		r7, #1
	lsl		r7, r7, r0		/* hn = n/2 */
	mov		r9, r1
	add		r10, r1, r7, lsl #2
.Lintt_odd_loop:
	vldrw.u32	q0, [r9]
	vldrw.u32	q1, [r10]
	vdup.32		q4, r8
	MP31_ROOT	q4
	vsub.i32	q7, q0, q1
	MP31_ADD	q0, q0, q1
	MP31_MONT	q7, q4, q6
	vdup.32		q4, r5
	MP31_ROOT	q4
	vmov		q1, q7
	MP31_MONT	q0, q4, q6
	vstrw.u32	q0, [r9], #16
	vstrw.u32	q1, [r10], #16
	subs		r7, r7, #4
	bne		.Lintt_odd_loop

.Lintt_done:
	add		sp, sp, #8
	vpop		{d8-d15}
	pop.w		{r4-r11, r12, pc}
	.size fndsa_mp_iNTT, .-fndsa_mp_iNTT

	.align 4
.Lmp31_stride8:
	.word 0, 8, 16, 24

/* Test-only entry point for the EXACT same macro. The separate section is
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
	push		{r4, lr}
	vpush		{d8-d11}
	mov		r4, r3
	mov		r3, r2
	vldrw.u32	q0, [r0]
	vldrw.u32	q4, [r1]
	MP31_ROOT	q4
	MP31_MONT	q0, q4, q1
	vstrw.u32	q0, [r0]
	vpop		{d8-d11}
	pop		{r4, pc}
	.size fndsa_mp31_monty4_probe, .-fndsa_mp31_monty4_probe

/*
 * Small even NTT: logn=4 uses 2+2, logn=6 uses 2+2+2.
 * This is control specialization, not instruction scheduling: the CT2
 * butterfly arithmetic retains its order. The penultimate store now
 * transposes the tile, so the final load is plain VLD rather than VLD4.
 * The public entry guard also sends logn<4 here for the unchanged C fallback.
 * logn=5 rejoins the regular path before any register save or coefficient load.
 * All dispatch/group/address decisions depend on public size and counters.
 */
	/* Keep the small path in the same input text section as the NTT kernels. */
	.text
	.p2align 2
	.thumb
	.thumb_func
	.type fndsa_mp_NTT_small, %function
fndsa_mp_NTT_small:
	cmp		r0, #4
	blo.w		fndsa_mp_NTT_c
	tst		r0, #1
	bne.w		.Lntt_regular

	/* No local frame: 40 core + 64 vector bytes; p0i is at SP+104.
	 * The final group count is recovered from the public root pointer.
	 * SP remains eight-byte aligned. */
	push.w		{r4-r11, r12, lr}
	vpush		{d8-d15}
	ldr		r4, [sp, #104]
	movs		r5, #1
	lsl		r5, r5, r0
	movs		r7, #1
	add		r8, r2, #4
	mov		r9, r1
	cmp		r5, #16
	beq.w		.Lsmall_penultimate

.Lsmall_two_group:
	add		r10, r9, r5
	mov		lr, r10			/* end of k0 stream */
	add		r11, r10, r5
	add		r12, r11, r5
	/* Keep the original general-CT2 instruction alignment. */
	.p2align 2
.Lsmall_two_inner:
	MP31_CT2_TILE_K4A r9, r10, r11, r12
	cmp		r9, lr
	bne		.Lsmall_two_inner
	add		r8, r8, #4
	mov		r9, r12			/* next j0 = old j0 + t */
	subs		r7, r7, #1
	bne		.Lsmall_two_group

	/* Only logn=6 uses the general pass; its next pass has four tiles.
	 * logn=4 went directly to the single-tile penultimate pass. */
	movs		r7, #4
	add		r8, r2, #16
	mov		r9, r1

.Lsmall_penultimate:
	MP31_CT2_TRANSPOSE_STORE
	subs		r7, r7, #1
	bne		.Lsmall_penultimate

.Lsmall_last_two:
	/* The finished general pass advanced r8 to gm+8 (logn4) or
	 * gm+32 (logn6). Thus (r8-gm)/2 is the final group count 4 or 16. */
	sub		r7, r8, r2
	lsrs		r7, r7, #1		/* m = n/4 */
	add		r8, r2, r7, lsl #2	/* s roots */
	add		r9, r2, r7, lsl #3	/* interleaved s0/s1 roots */
	mov		r10, r1
.Lsmall_last_loop:
	vldrw.u32	q0, [r10]
	vldrw.u32	q1, [r10, #16]
	vldrw.u32	q2, [r10, #32]
	vldrw.u32	q3, [r10, #48]
	vldrw.u32	q4, [r8], #16
	MP31_ROOT	q4
	MP31_MONT	q2, q4, q6
	MP31_CT	q0, q2, q7
	MP31_MONT	q3, q4, q6
	adr.w		r0, .Lsmall_stride8
	vldrw.u32	q7, [r0]
	vldrw.u32	q4, [r9, q7]		/* s0 */
	MP31_ROOT	q4
	MP31_CT	q1, q3, q7
	MP31_MONT	q1, q4, q6
	adr.w		r0, .Lsmall_stride8
	vldrw.u32	q7, [r0]
	add		r11, r9, #4
	vldrw.u32	q4, [r11, q7]		/* s1 */
	MP31_ROOT	q4
	MP31_CT	q0, q1, q7
	MP31_MONT	q3, q4, q6
	MP31_CT	q2, q3, q7
	add		r9, r9, #32

	vst40.32	{q0,q1,q2,q3}, [r10]
	vst41.32	{q0,q1,q2,q3}, [r10]
	vst42.32	{q0,q1,q2,q3}, [r10]
	vst43.32	{q0,q1,q2,q3}, [r10]
	add		r10, r10, #64
	subs		r7, r7, #4
	bne		.Lsmall_last_loop

	vpop		{d8-d15}
	pop.w		{r4-r11, r12, pc}
	.size fndsa_mp_NTT_small, .-fndsa_mp_NTT_small
	.p2align 2
.Lsmall_stride8:
	.word 0, 8, 16, 24

	.section .note.GNU-stack,"",%progbits
