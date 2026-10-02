/*
 * Cortex-M55/MVE NTT over the variable 31-bit primes used by the FN-DSA
 * NTRU solver.
 *
 * L3 depth-first layer merging on top of M1-improve.
 * - four 32-bit lanes, scalar-GPR roots for the three-layer interior;
 * - two coefficient vector stores/reloads per radix-8 tile, in the
 *   original array (no coefficient scratch buffer);
 * - canonical residues after every butterfly and the original GS half;
 * - unchanged two-layer boundary and C fallback for logn < 4.
 * Source-local layer plans below are in execution order, low nibble first.
 * This file contains the complete implementation; no external kernels.
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
 * Existing gm/igm values, including inverse half-scaled roots, are intact.
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

/* Gentleman-Sande butterfly with stage-wise halving.
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
	MP31_HALF	\a, \b
	MP31_MONT	\tmp, \root, \work
	vmov		\b, \tmp
	.endm


/* Uniform roots in GPRs free q4/q5 for retained coefficients.
 * r0=root, r6=low32(root*p0i), r3=p. Same exact M1 arithmetic/ranges.
 * Scalar register pressure is bounded by loading the seven roots in use
 * order, rather than keeping all fourteen root/twist words live.
 */
	.macro MP31_SMONT data, work
	vmul.u32	\work, \data, r6
	vqrdmulh.s32	\data, \data, r0
	vqrdmulh.s32	\work, \work, r3
	vhadd.s32	\data, \data, \work
	vpt.s32	LT, \data, zr
	vaddt.i32	\data, \data, r3
	.endm

	.macro MP31_SGS a, b, diff, work
	vsub.i32	\diff, \a, \b
	MP31_ADD	\a, \a, \b
	MP31_HALF	\a, \b
	MP31_SMONT	\diff, \work
	vmov		\b, \diff
	.endm

/* Root index k=r11: parent k, children 2k/2k+1, leaves 4k..4k+3. */
	.macro MP31_L3_ROOT shift, off=0
	add		r12, r2, r11, lsl #\shift
	ldr		r0, [r12, #\off]
	mul		r6, r0, r4
	.endm

/* Address stream i of a tile; r9=tile lane pointer, r7=byte stride.
 * Every address depends only on public transform size/group/lane.
 */
	.macro MP31_AT i
	.if \i == 0
	mov		r12, r9
	.elseif \i == 1
	add		r12, r9, r7
	.elseif \i == 2
	add		r12, r9, r7, lsl #1
	.elseif \i == 3
	add		r12, r9, r7, lsl #1
	add		r12, r12, r7
	.elseif \i == 4
	add		r12, r9, r7, lsl #2
	.elseif \i == 5
	add		r12, r9, r7, lsl #2
	add		r12, r12, r7
	.elseif \i == 6
	add		r12, r9, r7, lsl #2
	add		r12, r12, r7, lsl #1
	.elseif \i == 7
	add		r12, r9, r7, lsl #3
	sub		r12, r12, r7
	.endif
	.endm

	.macro MP31_LOAD q, i
	MP31_AT	\i
	vldrw.u32	\q, [r12]
	.endm

	.macro MP31_STORE q, i
	MP31_AT	\i
	vstrw.u32	\q, [r12]
	.endm

/* Explicit plans for logn 4..10. Last CT two / first GS two are
 * the unchanged VLD4/VST4 boundary. No new lazy reduction or scaling.
 */
	.macro MP31_PLAN_F
	movw		r12, #0x22		/* logn4: 2+2 */
	cmp		r0, #4
	beq		.Lplan_f_done\@
	movw		r12, #0x23		/* logn5: 3+2 */
	cmp		r0, #5
	beq		.Lplan_f_done\@
	movw		r12, #0x222		/* logn6: 2+2+2 */
	cmp		r0, #6
	beq		.Lplan_f_done\@
	movw		r12, #0x232		/* logn7: 2+3+2 */
	cmp		r0, #7
	beq		.Lplan_f_done\@
	movw		r12, #0x233		/* logn8: 3+3+2 */
	cmp		r0, #8
	beq		.Lplan_f_done\@
	movw		r12, #0x2322		/* logn9: 2+2+3+2 */
	cmp		r0, #9
	beq		.Lplan_f_done\@
	movw		r12, #0x2332		/* logn10: 2+3+3+2 */
.Lplan_f_done\@:
	.endm

	.macro MP31_PLAN_I
	movw		r12, #0x22		/* logn4: 2+2 */
	cmp		r0, #4
	beq		.Lplan_i_done\@
	movw		r12, #0x32		/* logn5: 2+3 */
	cmp		r0, #5
	beq		.Lplan_i_done\@
	movw		r12, #0x222		/* logn6: 2+2+2 */
	cmp		r0, #6
	beq		.Lplan_i_done\@
	movw		r12, #0x232		/* logn7: 2+3+2 */
	cmp		r0, #7
	beq		.Lplan_i_done\@
	movw		r12, #0x332		/* logn8: 2+3+3 */
	cmp		r0, #8
	beq		.Lplan_i_done\@
	movw		r12, #0x2232		/* logn9: 2+3+2+2 */
	cmp		r0, #9
	beq		.Lplan_i_done\@
	movw		r12, #0x2332		/* logn10: 2+3+3+2 */
.Lplan_i_done\@:
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
	sub		sp, sp, #16
	str		r0, [sp, #0]		/* public logn */
	/* 5th AAPCS argument: 40-byte core save + 64-byte MVE save
	 * + 16-byte local frame = 120 bytes above the current SP. */
	ldr		r4, [sp, #120]		/* caller's p0i */

	MP31_PLAN_F
	str		r12, [sp, #8]
	movs		r5, #1
	lsl		r5, r5, r0
	movs		r0, #0
	str		r0, [sp, #4]		/* lm=0 */

	/* Merged two-layer CT passes.  qt*4 bytes equals t elements. */
.Lntt_two_check:
	ldr		r6, [sp, #4]
	ldr		r0, [sp, #0]
	adds		r7, r6, #3
	cmp		r7, r0
	bge		.Lntt_last_two
	ldr		r12, [sp, #8]
	and		r0, r12, #15
	lsr		r12, r12, #4
	str		r12, [sp, #8]
	cmp		r0, #3
	beq.w		.Lntt_three

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
	MP31_ROOT	q4
	MP31_MONT	q2, q4, q6
	MP31_CT	q0, q2, q7
	MP31_MONT	q3, q4, q6
	MP31_CT	q1, q3, q7
	add		r0, r8, r8
	sub		r0, r0, r2		/* &gm[2*(i+m)] */
	ldr		r6, [r0]
	vdup.32		q4, r6			/* s0 */
	MP31_ROOT	q4
	MP31_MONT	q1, q4, q6
	MP31_CT	q0, q1, q7
	ldr		r6, [r0, #4]
	vdup.32		q4, r6			/* s1 */
	MP31_ROOT	q4
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


	/* Three CT layers. q0..q3 hold the four sums, q6/q7 retain
	 * differences 4/5. Only differences 6/7 go back to the array.
	 * q4 is the streamed operand; q5 is the only CT/Montgomery scratch.
	 * 8 initial loads + 2 intermediate stores/loads + 8 final stores.
	 */
.Lntt_three:
	lsr		r7, r5, #1		/* 4*(t/8) byte stride */
	movs		r8, #1
	lsl		r8, r8, r6		/* m */
	mov		r11, r8			/* k=m+i */
	mov		r9, r1
.Lntt_three_group:
	add		lr, r9, r7
.Lntt_three_inner:
	MP31_LOAD	q0, 0
	MP31_LOAD	q1, 1
	MP31_LOAD	q2, 2
	MP31_LOAD	q3, 3
	MP31_L3_ROOT	2
	MP31_LOAD	q6, 4
	MP31_SMONT	q6, q5
	MP31_CT	q0, q6, q5
	MP31_LOAD	q7, 5
	MP31_SMONT	q7, q5
	MP31_CT	q1, q7, q5
	MP31_LOAD	q4, 6
	MP31_SMONT	q4, q5
	MP31_CT	q2, q4, q5
	MP31_STORE	q4, 6
	MP31_LOAD	q4, 7
	MP31_SMONT	q4, q5
	MP31_CT	q3, q4, q5
	MP31_STORE	q4, 7

	MP31_L3_ROOT	3
	MP31_SMONT	q2, q5
	MP31_CT	q0, q2, q5
	MP31_SMONT	q3, q5
	MP31_CT	q1, q3, q5
	MP31_L3_ROOT	4
	MP31_SMONT	q1, q5
	MP31_CT	q0, q1, q5
	MP31_L3_ROOT	4, 4
	MP31_SMONT	q3, q5
	MP31_CT	q2, q3, q5
	MP31_STORE	q0, 0
	MP31_STORE	q1, 1
	MP31_STORE	q2, 2
	MP31_STORE	q3, 3

	vmov		q0, q6
	vmov		q1, q7
	MP31_LOAD	q2, 6
	MP31_LOAD	q3, 7
	MP31_L3_ROOT	3, 4
	MP31_SMONT	q2, q5
	MP31_CT	q0, q2, q5
	MP31_SMONT	q3, q5
	MP31_CT	q1, q3, q5
	MP31_L3_ROOT	4, 8
	MP31_SMONT	q1, q5
	MP31_CT	q0, q1, q5
	MP31_L3_ROOT	4, 12
	MP31_SMONT	q3, q5
	MP31_CT	q2, q3, q5
	MP31_STORE	q0, 4
	MP31_STORE	q1, 5
	MP31_STORE	q2, 6
	MP31_STORE	q3, 7

	add		r9, r9, #16
	cmp		r9, lr
	bne.w		.Lntt_three_inner
	/* r9 reached stream 1. Advance seven more streams. */
	add		r9, r9, r7, lsl #3
	sub		r9, r9, r7
	add		r11, r11, #1
	subs		r8, r8, #1
	bne.w		.Lntt_three_group
	lsr		r5, r5, #3
	ldr		r6, [sp, #4]
	add		r6, r6, #3
	str		r6, [sp, #4]
	b.w		.Lntt_two_check

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
	MP31_ROOT	q4
	MP31_MONT	q2, q4, q6
	MP31_CT	q0, q2, q7
	MP31_MONT	q3, q4, q6
	MP31_CT	q1, q3, q7
	adr		r0, .Lmp31_stride8
	vldrw.u32	q7, [r0]
	vldrw.u32	q4, [r9, q7]		/* s0 */
	MP31_ROOT	q4
	MP31_MONT	q1, q4, q6
	MP31_CT	q0, q1, q7
	adr		r0, .Lmp31_stride8
	vldrw.u32	q7, [r0]
	add		r11, r9, #4
	vldrw.u32	q4, [r11, q7]		/* s1 */
	MP31_ROOT	q4
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

	add		sp, sp, #16
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
	sub		sp, sp, #16
	str		r0, [sp, #0]
	ldr		r4, [sp, #120]		/* caller's p0i */
	MP31_PLAN_I
	lsr		r12, r12, #4		/* first boundary GS2 below */
	str		r12, [sp, #8]
	add		r5, r3, #1
	lsr		r5, r5, #1		/* (p+1)/2 */

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
	MP31_ROOT	q4
	MP31_GS	q0, q1, q4, q7, q6
	adr		r0, .Lmp31_stride8
	vldrw.u32	q7, [r0]
	add		r11, r9, #4
	vldrw.u32	q4, [r11, q7]		/* s1 */
	MP31_ROOT	q4
	MP31_GS	q2, q3, q4, q7, q6
	vldrw.u32	q4, [r8], #16		/* s */
	MP31_ROOT	q4
	MP31_GS	q0, q2, q4, q7, q6
	MP31_GS	q1, q3, q4, q7, q6
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
	cmp		r0, r7
	bge.w		.Lintt_done
	ldr		r12, [sp, #8]
	and		r8, r12, #15
	lsr		r12, r12, #4
	str		r12, [sp, #8]
	cmp		r8, #3
	beq.w		.Lintt_three

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
	MP31_ROOT	q4
	MP31_GS	q0, q1, q4, q7, q6
	add		r0, r8, r8
	sub		r0, r0, r2
	ldr		r0, [r0, #4]
	vdup.32		q4, r0			/* s1 */
	MP31_ROOT	q4
	MP31_GS	q2, q3, q4, q7, q6
	ldr		r0, [r8]
	vdup.32		q4, r0			/* s */
	MP31_ROOT	q4
	MP31_GS	q0, q2, q4, q7, q6
	MP31_GS	q1, q3, q4, q7, q6

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


	/* Three GS layers. The first half leaves streams 0/1 in q0/q1;
	 * only streams 2/3 are stored temporarily. Process streams 4..7
	 * in q2..q5, then join and store each pair as soon as it is final.
	 * q6/q7 are scratch until the final pairs release registers.
	 */
.Lintt_three:
	mov		r12, r6			/* original t in bytes */
	mov		r6, r7			/* logn */
	sub		r6, r6, r0		/* remaining */
	sub		r6, r6, #3
	movs		r8, #1
	lsl		r8, r8, r6
	mov		r11, r8
	mov		r7, r12			/* stream stride */
	mov		r9, r1
.Lintt_three_group:
	add		lr, r9, r7
.Lintt_three_inner:
	MP31_LOAD	q0, 0
	MP31_LOAD	q1, 1
	MP31_LOAD	q2, 2
	MP31_LOAD	q3, 3
	MP31_L3_ROOT	4
	MP31_SGS	q0, q1, q6, q7
	MP31_L3_ROOT	4, 4
	MP31_SGS	q2, q3, q6, q7
	MP31_L3_ROOT	3
	MP31_SGS	q0, q2, q6, q7
	MP31_SGS	q1, q3, q6, q7
	MP31_STORE	q2, 2
	MP31_STORE	q3, 3

	MP31_LOAD	q2, 4
	MP31_LOAD	q3, 5
	MP31_LOAD	q4, 6
	MP31_LOAD	q5, 7
	MP31_L3_ROOT	4, 8
	MP31_SGS	q2, q3, q6, q7
	MP31_L3_ROOT	4, 12
	MP31_SGS	q4, q5, q6, q7
	MP31_L3_ROOT	3, 4
	MP31_SGS	q2, q4, q6, q7
	MP31_SGS	q3, q5, q6, q7

	MP31_L3_ROOT	2
	MP31_SGS	q0, q2, q6, q7
	MP31_STORE	q0, 0
	MP31_STORE	q2, 4
	MP31_SGS	q1, q3, q6, q7
	MP31_STORE	q1, 1
	MP31_STORE	q3, 5
	MP31_LOAD	q0, 2
	MP31_LOAD	q1, 3
	MP31_SGS	q0, q4, q6, q7
	MP31_STORE	q0, 2
	MP31_STORE	q4, 6
	MP31_SGS	q1, q5, q6, q7
	MP31_STORE	q1, 3
	MP31_STORE	q5, 7

	add		r9, r9, #16
	cmp		r9, lr
	bne.w		.Lintt_three_inner
	add		r9, r9, r7, lsl #3
	sub		r9, r9, r7
	add		r11, r11, #1
	subs		r8, r8, #1
	bne.w		.Lintt_three_group
	lsl		r6, r7, #3
	ldr		r0, [sp, #4]
	add		r0, r0, #3
	str		r0, [sp, #4]
	b.w		.Lintt_two_check

.Lintt_done:
	add		sp, sp, #16
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

	.section .note.GNU-stack,"",%progbits
