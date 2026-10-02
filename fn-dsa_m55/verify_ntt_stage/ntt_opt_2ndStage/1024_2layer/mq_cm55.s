	.syntax	unified
	.file	"mq_cm55.s"
	.text

	.equ	Q, 12289
	.equ	Q1I, 4143984639
	.equ	Q1ILO, (Q1I & 0xFFFF)
	.equ	Q1IHI, (Q1I >> 16)
	.equ	R, 10952
	.equ	R2, 5664
	.equ	B_INF, 840

@ MVE helpers used by the logn=10 two-layer kernels below.  They keep
@ the q=12289 Montgomery representation and the relaxed [0,Q] range of
@ the original Cortex-M4 implementation.  MQ_MUL_X8 preserves the
@ twiddle vector and uses two temporary vectors.
	.macro	MQ_MUL_X8 dst, tw, tmp0, tmp1
	vmov.i32	\tmp0, #0
	vcmp.i16	eq, \dst, \tmp0
	vmulh.u16	\tmp0, \dst, \tw
	vmul.i16	\dst, \dst, \tw
	vdup.16	\tmp1, r14
	vmulh.u16	\tmp1, \dst, \tmp1
	movw	r12, #Q1IHI
	vmul.i16	\dst, \dst, r12
	vmul.i16	\tmp0, \tmp0, r14
	vadd.i16	\dst, \dst, \tmp0
	vadd.i16	\dst, \dst, \tmp1
	vdup.16	\tmp1, r10
	vmulh.u16	\dst, \dst, \tmp1
	movs	r12, #1
	vadd.i16	\dst, \dst, r12
	vpst
	vsubt.i16	\dst, \dst, r12
	.endm

@ Cooley--Tukey butterfly.  The right operand has already been
@ Montgomery-multiplied by its layer twiddle.
	.macro	MQ_CT_X8 left, right, tmp
	vadd.i16	\tmp, \left, \right
	vsub.i16	\tmp, \tmp, r10
	vcmp.s16	lt, \tmp, zr
	vpst
	vaddt.i16	\tmp, \tmp, r10
	vsub.i16	\right, \left, \right
	vcmp.s16	lt, \right, zr
	vpst
	vaddt.i16	\right, \right, r10
	vmov	\left, \tmp
	.endm

@ Gentleman--Sande butterfly.  The twiddle is supplied in a scalar GPR;
@ the macro leaves half(left+right) in left and
@ Montgomery((left-right)*twiddle) in right.
	.macro	MQ_GS_X8 left, right, twreg, tmp0, tmp1, tmp2
	vadd.i16	\tmp0, \left, \right
	vsub.i16	\tmp0, \tmp0, r10
	vcmp.s16	lt, \tmp0, zr
	vpst
	vaddt.i16	\tmp0, \tmp0, r10
	vsub.i16	\right, \left, \right
	vcmp.s16	lt, \right, zr
	vpst
	vaddt.i16	\right, \right, r10
	vmov.i16	\tmp1, #1
	vand	\tmp1, \tmp0, \tmp1
	vcmp.i16	ne, \tmp1, zr
	vpst
	vaddt.i16	\tmp0, \tmp0, r10
	vshr.u16	\left, \tmp0, #1
	vdup.16	\tmp2, \twreg
	MQ_MUL_X8	\right, \tmp2, \tmp0, \tmp1
	.endm

@ =======================================================================
@ void fndsa_mqpoly_small_to_int(unsigned logn, const int8_t *f, uint16_t *d)
@ =======================================================================

	.align	2
	.global	fndsa_mqpoly_small_to_int
	.thumb
	.thumb_func
	.type	fndsa_mqpoly_small_to_int, %function
fndsa_mqpoly_small_to_int:
	@ This implementation actually normalizes to [1,q] (strict internal
	@ representation).
	push	{ r4, r5, r6, r7 }
	@ Set r3 to n = 2^logn
	movs	r3, #1
	lsls	r3, r0
	@ Set both halves of r0 to Q
	movw	r0, #Q
	movt	r0, #Q
	@ Set both halves of r7 to 1
	mov	r7, #0x00010001
fndsa_mqpoly_small_to_int__L1:
	@ Get next four source bytes.
	ldr	r5, [r1], #4
	@ Expand bytes to 16-bit each; for each byte whose value is negative
	@ or zero, we need to add Q.
	sxtb16	r4, r5
	sadd16	r6, r4, r0
	ssub16	r12, r4, r7
	sel	r4, r4, r6
	sxtb16	r5, r5, ror #8
	sadd16	r6, r5, r0
	ssub16	r12, r5, r7
	sel	r5, r5, r6
	@ We need to interleave the values to get them in the right order.
	pkhtb	r6, r5, r4, asr #16
	pkhbt	r5, r4, r5, lsl #16
	@ We can use strd because the caller ensured that the output is
	@ aligned.
	strd	r5, r6, [r2], #8
	subs	r3, #4
	bne	fndsa_mqpoly_small_to_int__L1

	pop	{ r4, r5, r6, r7 }
	bx	lr
	.size	fndsa_mqpoly_small_to_int,.-fndsa_mqpoly_small_to_int

@ =======================================================================
@ void fndsa_mqpoly_signed_to_int(unsigned logn, uint16_t *d)
@ =======================================================================

	.align	2
	.global	fndsa_mqpoly_signed_to_int
	.thumb
	.thumb_func
	.type	fndsa_mqpoly_signed_to_int, %function
fndsa_mqpoly_signed_to_int:
	@ This implementation actually normalizes to [1,q] (strict internal
	@ representation).
	push	{ r4, r5, r6 }
	movs	r3, #1
	lsls	r3, r0
	@ Set both halves of r0 to Q
	movw	r0, #Q
	movt	r0, #Q
	@ Set both halves of r2 to 1
	mov	r2, #0x00010001
fndsa_mqpoly_signed_to_int__L1:
	@ We can use ldrd because the caller ensured that the input is
	@ aligned.
	ldrd	r4, r5, [r1]
	@ For each word half, we want to add q if the value is negative or 0.
	sadd16	r6, r4, r0
	ssub16	r12, r4, r2
	sel	r4, r4, r6
	sadd16	r6, r5, r0
	ssub16	r12, r5, r2
	sel	r5, r5, r6
	strd	r4, r5, [r1], #8
	subs	r3, #4
	bne	fndsa_mqpoly_signed_to_int__L1

	pop	{ r4, r5, r6 }
	bx	lr
	.size	fndsa_mqpoly_signed_to_int,.-fndsa_mqpoly_signed_to_int

@ =======================================================================
@ void fndsa_mqpoly_int_to_ext(unsigned logn, uint16_t *d)
@ =======================================================================

	.align	2
	.global	fndsa_mqpoly_int_to_ext
	.thumb
	.thumb_func
	.type	fndsa_mqpoly_int_to_ext, %function
fndsa_mqpoly_int_to_ext:
	push.w	{ r4, r5, r6 }
	movs	r3, #1
	lsls	r3, r0
	@ Set both halves of r0 to Q
	movw	r0, #Q
	movt	r0, #Q
	@ Set both halves of r2 to 0xFFFF
	mov	r2, #0xFFFFFFFF
	@ Set r6 to zero
	movw	r6, #0
fndsa_mqpoly_int_to_ext__L1:
	@ We can use ldrd because the caller ensured that the input is
	@ aligned.
	ldrd	r4, r5, [r1]
	@ Each word half equal to q must be set to 0; others are untouched.
	ssub16	r12, r4, r0
	sel	r4, r6, r4
	ssub16	r12, r5, r0
	sel	r5, r6, r5
	strd	r4, r5, [r1], #8
	subs	r3, #4
	bne	fndsa_mqpoly_int_to_ext__L1

	pop	{ r4, r5, r6 }
	bx	lr
	.size	fndsa_mqpoly_int_to_ext,.-fndsa_mqpoly_int_to_ext

@ =======================================================================
@ void fndsa_mqpoly_mul_ntt(unsigned logn, uint16_t *a, const uint16_t *b)
@ =======================================================================

	.align	2
	.global	fndsa_mqpoly_mul_ntt
	.thumb
	.thumb_func
	.type	fndsa_mqpoly_mul_ntt, %function
fndsa_mqpoly_mul_ntt:
	push.w	{ r4, r5, r6, r7, r8, r10, lr }
	movs	r3, #1
	lsls	r3, r0

	@ r10 <- q
	movw	r10, #Q
	@ r14 <- -1/q mod 2^32
	movw	r14, #(Q1I & 0xFFFF)
	movt	r14, #(Q1I >> 16)
	@ r0 <- 2^64 mod q
	movw	r0, #R2

	@ r12 is a temporary

fndsa_mqpoly_mul_ntt__L1:
	@ A sequence of four ldr is faster than two ldrd or two ldm.
	ldr	r5, [r1]
	ldr	r6, [r1, #4]
	ldr.w	r7, [r2], #4
	ldr.w	r8, [r2], #4

	@ First pair of words (r5 and r7)
	@ Products over integers.
	smulbb	r4, r5, r7
	smultt	r5, r5, r7
	@ Montgomery reduction.
	mul	r12, r4, r14
	umaal	r14, r4, r12, r10
	mul	r12, r5, r14
	umaal	r14, r5, r12, r10
	@ Conversion Montgomery -> normal
	muls	r4, r0
	muls	r5, r0
	mul	r12, r4, r14
	umaal	r14, r4, r12, r10
	mul	r12, r5, r14
	umaal	r14, r5, r12, r10
	@ Repack the two output values and write word
	pkhbt	r7, r4, r5, lsl #16
	str.w	r7, [r1], #4

	@ Second pair of words (r6 and r8)
	@ Products over integers.
	smulbb	r4, r6, r8
	smultt	r5, r6, r8
	@ Montgomery reduction.
	mul	r12, r4, r14
	umaal	r14, r4, r12, r10
	mul	r12, r5, r14
	umaal	r14, r5, r12, r10
	@ Conversion Montgomery -> normal
	muls	r4, r0
	muls	r5, r0
	mul	r12, r4, r14
	umaal	r14, r4, r12, r10
	mul	r12, r5, r14
	umaal	r14, r5, r12, r10
	@ Repack the two output values and write word
	pkhbt	r8, r4, r5, lsl #16
	str.w	r8, [r1], #4

	@ Store the four output values.
	subs	r3, #4
	bne	fndsa_mqpoly_mul_ntt__L1

	pop	{ r4, r5, r6, r7, r8, r10, pc }
	.size	fndsa_mqpoly_mul_ntt,.-fndsa_mqpoly_mul_ntt

@ =======================================================================
@ void fndsa_mqpoly_sub(unsigned logn, uint16_t *a, const uint16_t *b)
@ =======================================================================

	.align	2
	.global	fndsa_mqpoly_sub
	.thumb
	.thumb_func
	.type	fndsa_mqpoly_sub, %function
fndsa_mqpoly_sub:
	push.w	{ r4, r5, r6, r7, lr }
	movs	r3, #1
	lsls	r3, r0

	@ r0 <- 0
	movw	r0, #0
	@ r14 <- q (both halves)
	movw	r14, #Q
	movt	r14, #Q

fndsa_mqpoly_sub__L1:
	@ Four ldr are faster than two ldrd or two ldm.
	ldr	r4, [r1]
	ldr	r5, [r1, #4]
	ldr.w	r6, [r2], #4
	ldr.w	r7, [r2], #4

	@ We do the subtraction over the integers, then add q back if
	@ the result is negative.
	ssub16	r4, r4, r6
	sel	r12, r0, r14
	sadd16	r4, r4, r12
	str.w	r4, [r1], #4
	ssub16	r5, r5, r7
	sel	r12, r0, r14
	sadd16	r5, r5, r12
	str.w	r5, [r1], #4

	subs	r3, #4
	bne	fndsa_mqpoly_sub__L1

	pop	{ r4, r5, r6, r7, pc }
	.size	fndsa_mqpoly_sub,.-fndsa_mqpoly_sub

@ =======================================================================
@ void fndsa_mqpoly_add(unsigned logn, uint16_t *a, const uint16_t *b)
@ =======================================================================

	.align	2
	.global	fndsa_mqpoly_add
	.thumb
	.thumb_func
	.type	fndsa_mqpoly_add, %function
fndsa_mqpoly_add:
	push.w	{ r4, r5, r6, r7, lr }
	movs	r3, #1
	lsls	r3, r0

	@ r14 <- q (both halves)
	movw	r14, #Q
	movt	r14, #Q

fndsa_mqpoly_add__L1:
	@ Four ldr are faster than two ldrd or two ldm.
	ldr	r4, [r1]
	ldr	r5, [r1, #4]
	ldr.w	r6, [r2], #4
	ldr.w	r7, [r2], #4

	@ We do the addition over the integers, then subtract q, but
	@ discard the subtraction if the result is negative.
	sadd16	r4, r4, r6
	ssub16	r12, r4, r14
	sel	r4, r12, r4
	str.w	r4, [r1], #4
	sadd16	r5, r5, r7
	ssub16	r12, r5, r14
	sel	r5, r12, r5
	str.w	r5, [r1], #4

	subs	r3, #4
	bne	fndsa_mqpoly_add__L1

	pop	{ r4, r5, r6, r7, pc }
	.size	fndsa_mqpoly_add,.-fndsa_mqpoly_add

@ =======================================================================
@ uint32_t fndsa_mqpoly_sqnorm_signed(unsigned logn, const uint16_t *a)
@ =======================================================================

	.align	2
	.global	fndsa_mqpoly_sqnorm_signed
	.thumb
	.thumb_func
	.type	fndsa_mqpoly_sqnorm_signed, %function
fndsa_mqpoly_sqnorm_signed:
	movs	r3, #1
	lsls	r3, r0

	movw	r0, #0
fndsa_mqpoly_sqnorm_signed__L1:
	@ We can use ldrd because the caller ensured that the input is
	@ aligned.
	ldrd	r2, r12, [r1], #8
	smlad	r0, r2, r2, r0
	smlad	r0, r12, r12, r0
	@ The whole operation cannot overflow in unsigned convention,
	@ since signed values are at most 2047 (in absolute value) and
	@ there are at most 1024 of them, hence a maximum squared norm
	@ of 1024*2047*2047 = 4290774016, which fits on 32 bits.
	subs	r3, #4
	bne	fndsa_mqpoly_sqnorm_signed__L1

	bx	lr
	.size	fndsa_mqpoly_sqnorm_signed,.-fndsa_mqpoly_sqnorm_signed

@ =======================================================================
@ uint32_t fndsa_mqpoly_sqnorm_binf_int(unsigned logn, const uint16_t *a)
@ =======================================================================

	.align	2
	.global	fndsa_mqpoly_sqnorm_binf_int
	.thumb
	.thumb_func
	.type	fndsa_mqpoly_sqnorm_binf_int, %function
fndsa_mqpoly_sqnorm_binf_int:
	push.w	{ r4, r5, r6, r7, lr }
	movs	r3, #1
	lsls	r3, r0

	@ r5 <- q (in both halves)
	movw	r5, #Q
	movt	r5, #Q
	@ r6 <- ceil(q/2) (in both halves)
	movw	r6, #((Q + 1) >> 1)
	movt	r6, #((Q + 1) >> 1)
	@ r12 <- B_INF (in both halves)
	movw	r14, #B_INF
	movt	r14, #B_INF

	movw	r0, #0
	@ We clear the Q flag, which we will use to detect overflows.
	msr	APSR_nzcvq, r0
fndsa_mqpoly_sqnorm_binf_int__L1:
	@ We can use ldrd because the caller ensured that the input is
	@ aligned.
	ldrd	r2, r4, [r1], #8

	@ Normalize values to [-q/2,+q/2]
	ssub16	r7, r2, r5
	ssub16	r12, r2, r6
	sel	r2, r7, r2
	ssub16	r7, r4, r5
	ssub16	r12, r4, r6
	sel	r4, r7, r4
	@ If any addition overflows (signed interpretation), then the Q
	@ flag will be set.
	smlad	r0, r2, r2, r0
	smlad	r0, r4, r4, r0
	@ Also check the L-infinity norm. For each signed value z (half of
	@ r2 or r4), B_INF - z and B_INF + z must be non-negative. usat16
	@ will set the Q flag whenever a signed value saturates (i.e. is
	@ negative).
	ssub16	r7, r14, r2
	sadd16	r2, r14, r2
	usat16	r7, #15, r7
	usat16	r2, #15, r2
	ssub16	r7, r14, r4
	sadd16	r4, r14, r4
	usat16	r7, #15, r7
	usat16	r4, #15, r4

	subs	r3, #4
	bne	fndsa_mqpoly_sqnorm_binf_int__L1

	@ If the Q flag is set, saturate the returned value to 0xFFFFFFFF
	mrs	r1, APSR
	sbfx	r1, r1, #27, #1
	orrs	r0, r1

	pop	{ r4, r5, r6, r7, pc }
	.size	fndsa_mqpoly_sqnorm_binf_int,.-fndsa_mqpoly_sqnorm_binf_int

@ =======================================================================
@ uint32_t fndsa_mqpoly_sqnorm_int_to_signed(unsigned logn, uint16_t *a)
@ =======================================================================

	.align	2
	.global	fndsa_mqpoly_sqnorm_int_to_signed
	.thumb
	.thumb_func
	.type	fndsa_mqpoly_sqnorm_int_to_signed, %function
fndsa_mqpoly_sqnorm_int_to_signed:
	push.w	{ r4, r5, r6, r7 }
	movs	r3, #1
	lsls	r3, r0

	@ r5 <- q (in both halves)
	movw	r5, #Q
	movt	r5, #Q
	@ r6 <- ceil(q/2) (in both halves)
	movw	r6, #((Q + 1) >> 1)
	movt	r6, #((Q + 1) >> 1)

	movw	r0, #0
	@ We clear the Q flag, which we will use to detect overflows.
	msr	APSR_nzcvq, r0
fndsa_mqpoly_sqnorm_int_to_signed__L1:
	@ We can use ldrd because the caller ensured that the input is
	@ aligned.
	ldrd	r2, r4, [r1]

	@ Normalize values to [-q/2,+q/2]
	ssub16	r7, r2, r5
	ssub16	r12, r2, r6
	sel	r2, r7, r2
	str	r2, [r1], #4
	ssub16	r7, r4, r5
	ssub16	r12, r4, r6
	sel	r4, r7, r4
	str	r4, [r1], #4

	@ If any addition overflows (signed interpretation), then the Q
	@ flag will be set.
	smlad	r0, r2, r2, r0
	smlad	r0, r4, r4, r0
	subs	r3, #4
	bne	fndsa_mqpoly_sqnorm_int_to_signed__L1

	@ If the Q flag is set, saturate the returned value to 0xFFFFFFFF
	mrs	r1, APSR
	sbfx	r1, r1, #27, #1
	orrs	r0, r1

	pop	{ r4, r5, r6, r7 }
	bx	lr
	.size	fndsa_mqpoly_sqnorm_int_to_signed,.-fndsa_mqpoly_sqnorm_int_to_signed

@ =======================================================================
@ void fndsa_mqpoly_int_to_ntt(unsigned logn, uint16_t *d)
@ =======================================================================

	.align	2
	.global	fndsa_mqpoly_int_to_ntt
	.thumb
	.thumb_func
	.type	fndsa_mqpoly_int_to_ntt, %function
fndsa_mqpoly_int_to_ntt:
	push.w	{ r4, r5, r6, r7, r8, r10, r11, lr }
	vpush	{ d8-d15 }      @ q4-q7 (s16-s31) are callee-saved

	@ ASSUMPTION: logn >= 2

	@ State:
	@   r0    0
	@   r1    &d[j1]
	@   r2    t = ht*2
	@   r3    middle loop counter
	@   r6    s
	@   r7    innermost loop counter
	@   r8    &mq_GM[i + m]
	@   r10   q
	@   r11   q:q
	@   r12   scratch
	@   r14   -1/q mod 2^32
	@
	@   s2    d
	@   s3    m

	vmov	s2, r1         @ original &d[0]
	movs	r2, #1
	lsls	r2, r0         @ r2 <- t = ht*2 (initially equal to n)
	movw	r0, #1         @ m <- 1
	vmov	s3, r0

	@ Constants.
	@ r0 <- 0
	movw	r0, #0
	@ r10 <- q
	movw	r10, #Q
	@ r11 <- q (both halves)
	orr	r11, r10, r10, lsl #16
	@ r14 <- -1/q mod 2^32
	movw	r14, #(Q1I & 0xFFFF)
	movt	r14, #(Q1I >> 16)

	@ r8 <- &mq_GM[1]
	adr	r8, fndsa_mqpoly_int_to_ntt__gmaddr_plus1
	ldr	r8, [r8]

	@ This candidate changes only FN-DSA-1024.  Fuse the eight general
	@ layers in pairs; the existing L4/L5 kernel still handles layers 8
	@ and 9.  All other public degrees retain the stage-1 path below.
	cmp	r2, #1024
	beq	fndsa_mqpoly_int_to_ntt__F2_setup

	@ If n = 4, then skip directly to the specialized code for the
	@ last two iterations.
	cmp	r2, #4
	beq	fndsa_mqpoly_int_to_ntt__L4

fndsa_mqpoly_int_to_ntt__L1:
	@ Middle loop has m iterations.
	vmov	r3, s3
	lsl	r6, r3, #1     @ prepare m for next iteration
	vmov	s3, r6
fndsa_mqpoly_int_to_ntt__L2:
	ldrh	r6, [r8], #2   @ s <- mq_GM[i + m]
	lsr	r7, r2, #1     @ r7 <- ht

	@ Process eight butterflies per iteration whenever ht >= 8.  q0 is
	@ deliberately left untouched: s2 and s3 hold persistent scalar state.
	@ q4 is preserved in the function prologue/epilogue as required by AAPCS.
	cmp	r7, #8
	blo	fndsa_mqpoly_int_to_ntt__L3
fndsa_mqpoly_int_to_ntt__L3_mve:
	@ q1 <- x1[0..7], q2 <- x2[0..7], q3 <- s replicated.
	@ r4 points to the second half of this butterfly group.
	add.w	r4, r1, r2
	vldrh.u16	q1, [r1]
	vldrh.u16	q2, [r4]
	vmov.i32	q3, #0
	vcmp.i16	eq, q2, q3       @ remember lanes whose input is exactly 0
	vdup.16	q3, r6

	@ Eight parallel Montgomery products mmul(x2, s).  This is the same
	@ 16-bit decomposition as mq_mred_x8() in the portable SIMD code:
	@   lo = low16(x2*s), hi = high16(x2*s)
	@   z  = high16(lo*Q1ILO) + low16(lo*Q1IHI)
	@        + low16(hi*Q1ILO)              (mod 2^16)
	@   x2 = high16(z*Q) + 1
	@ For non-zero x2 this equals the Cortex-M4 UMAAL result.  For x2=0,
	@ the decomposition yields 1 while UMAAL yields 0, so the remembered
	@ input-zero predicate cancels that +1 on those lanes only.
	vmulh.u16	q4, q2, q3       @ hi
	vmul.i16	q2, q2, q3       @ lo
	vdup.16	q3, r14            @ Q1ILO (low half of Q1I)
	vmulh.u16	q3, q2, q3       @ high16(lo*Q1ILO)
	movw	r12, #Q1IHI
	vmul.i16	q2, q2, r12      @ low16(lo*Q1IHI)
	vmul.i16	q4, q4, r14      @ low16(hi*Q1ILO)
	vadd.i16	q2, q2, q4
	vadd.i16	q2, q2, q3
	vdup.16	q3, r10            @ Q
	vmulh.u16	q2, q2, q3
	movs	r12, #1
	vadd.i16	q2, q2, r12
	vpst
	vsubt.i16	q2, q2, r12

	@ Butterfly outputs, normalized to the Cortex-M4-compatible relaxed
	@ internal range [0,Q].
	@ Predication depends on lane values but executes no secret branch and
	@ does not alter the memory access pattern.
	vadd.i16	q4, q1, q2
	vsub.i16	q4, q4, q3
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q3
	vstrh.16	q4, [r1]

	vsub.i16	q4, q1, q2
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q3
	vstrh.16	q4, [r4]

	add.w	r1, r1, #16
	subs	r7, #8
	bne	fndsa_mqpoly_int_to_ntt__L3_mve
	b	fndsa_mqpoly_int_to_ntt__L3_done

fndsa_mqpoly_int_to_ntt__L3:
	@ Each inner loop iteration processes two pairs (x1,x2) and (y1,y2).
	ldr.w	r4, [r1, r2]   @ r4 <- x2:y2

	@ r5 <- mmul(y2, s)
	smultb	r5, r4, r6
	mul	r12, r5, r14
	umaal	r14, r5, r12, r10
	@ r4 <- mmul(x2, s)
	smulbb	r4, r4, r6
	mul	r12, r4, r14
	umaal	r14, r4, r12, r10
	@ r5 <- x2:y2
	pkhbt	r5, r4, r5, lsl #16

	@ r4 <- x1:y1
	ldr.w	r4, [r1]       @ r4 <- x1:y1

	@ d[j1] <- x1+x2 : y1+y2
	@ d[j2] <- x1-x2 : y1-y2
	sadd16	r12, r4, r5
	ssub16	r5, r4, r5
	sel	r4, r0, r11
	sadd16	r5, r5, r4
	str.w	r5, [r1, r2]
	ssub16	r4, r12, r11
	sel	r4, r4, r12
	str.w	r4, [r1], #4

	@ loop ht/2 times
	subs	r7, #2
	bne	fndsa_mqpoly_int_to_ntt__L3

fndsa_mqpoly_int_to_ntt__L3_done:

	@ ---------------------------

	@ j0 <- j0 + t
	@ j0 is implicit in r1, which has been increased for ht elements,
	@ hence we add ht here (ht*2, since elements are 2-byte values)
	add.w	r1, r1, r2
	@ We loop m times
	subs	r3, #1
	bne	fndsa_mqpoly_int_to_ntt__L2

	@ r1 now contains &d[n], we must reset it to &d[0] for the next
	@ iteration.
	vmov	r1, s2

	@ replace t with ht
	@ Loop until t reaches 2
	lsr	r2, r2, #1
	cmp	r2, #4
	bne	fndsa_mqpoly_int_to_ntt__L1
	@ Non-1024 degrees stay on the original final two-layer kernel.
	b	fndsa_mqpoly_int_to_ntt__L4

fndsa_mqpoly_int_to_ntt__F2_setup:
	@ Pair state starts at m=1,t=1024.  s3 holds m because r6 is used
	@ for the second child twiddle inside each radix-4 group.
	movs	r6, #1
	vmov	s3, r6

fndsa_mqpoly_int_to_ntt__F2_outer:
	vmov	r1, s2
	vmov	r6, s3
	mov	r3, r6
	@ r8=&GM[m], r7=&GM[2*m].
	add.w	r7, r8, r6, lsl #1
	@ Four equally sized input/output streams are t/4 coefficients
	@ apart, i.e. t/2 bytes apart.
	lsr.w	r4, r2, #1

fndsa_mqpoly_int_to_ntt__F2_middle:
	@ Parent twiddle and the two child twiddles for this radix-4 group.
	ldrh	r5, [r8], #2
	ldr.w	r12, [r7], #4
	uxth	r11, r12
	lsr.w	r6, r12, #16

	@ The fourth pair has four coefficients per stream.  Use 64-bit
	@ loads/stores for its live lanes, avoiding an out-of-bounds 128-bit
	@ access at the end of d.  All earlier pairs use all eight MVE lanes.
	cmp	r2, #16
	beq	fndsa_mqpoly_int_to_ntt__F2_half
	lsr.w	r0, r2, #5

fndsa_mqpoly_int_to_ntt__F2_vector:
	vldrh.u16	q1, [r1]
	add.w	r12, r1, r4
	vldrh.u16	q2, [r12]
	add.w	r12, r12, r4
	vldrh.u16	q3, [r12]
	add.w	r12, r12, r4
	vldrh.u16	q4, [r12]
	b	fndsa_mqpoly_int_to_ntt__F2_butterflies

fndsa_mqpoly_int_to_ntt__F2_half:
	vldr	d2, [r1]
	add.w	r12, r1, r4
	vldr	d4, [r12]
	add.w	r12, r12, r4
	vldr	d6, [r12]
	add.w	r12, r12, r4
	vldr	d8, [r12]

fndsa_mqpoly_int_to_ntt__F2_butterflies:
	@ First CT layer, shared parent twiddle.
	vdup.16	q7, r5
	MQ_MUL_X8	q3, q7, q5, q6
	MQ_MUL_X8	q4, q7, q5, q6
	MQ_CT_X8	q1, q3, q5
	MQ_CT_X8	q2, q4, q5

	@ Second CT layer.  The upper and lower radix-2 children have
	@ consecutive GM entries.
	vdup.16	q7, r11
	MQ_MUL_X8	q2, q7, q5, q6
	vdup.16	q7, r6
	MQ_MUL_X8	q4, q7, q5, q6
	MQ_CT_X8	q1, q2, q5
	MQ_CT_X8	q3, q4, q5

	cmp	r2, #16
	beq	fndsa_mqpoly_int_to_ntt__F2_half_store
	vstrh.16	q1, [r1]
	add.w	r12, r1, r4
	vstrh.16	q2, [r12]
	add.w	r12, r12, r4
	vstrh.16	q3, [r12]
	add.w	r12, r12, r4
	vstrh.16	q4, [r12]
	add.w	r1, r1, #16
	subs	r0, #1
	bne	fndsa_mqpoly_int_to_ntt__F2_vector
	@ r1 is at the end of the first stream; skip the other three.
	add.w	r1, r1, r4, lsl #1
	add.w	r1, r1, r4
	b	fndsa_mqpoly_int_to_ntt__F2_middle_done

fndsa_mqpoly_int_to_ntt__F2_half_store:
	vstr	d2, [r1]
	add.w	r12, r1, r4
	vstr	d4, [r12]
	add.w	r12, r12, r4
	vstr	d6, [r12]
	add.w	r12, r12, r4
	vstr	d8, [r12]
	add.w	r1, r1, r4, lsl #2

fndsa_mqpoly_int_to_ntt__F2_middle_done:
	subs	r3, #1
	bne	fndsa_mqpoly_int_to_ntt__F2_middle

	@ The next pair starts four levels farther in the GM tree.  r7 has
	@ advanced exactly to &GM[4*m].
	mov	r8, r7
	vmov	r6, s3
	lsl.w	r6, r6, #2
	vmov	s3, r6
	lsr.w	r2, r2, #2
	cmp	r2, #4
	bne	fndsa_mqpoly_int_to_ntt__F2_outer
	vmov	r1, s2
	b	fndsa_mqpoly_int_to_ntt__L4

fndsa_mqpoly_int_to_ntt__L4:
	@ Last two outer iterations use specialized code.
	@   m = n/4
	@   t = 4
	@ We do n/4 inner iterations, each processing four consecutive values.

	@ Loop counter (m = n/4).
	vmov	r3, s3

	@ We need two pointers to read s values; we use r8 and r7.
	@ At this point, r8 is correct (&mq_GM[m]) and we set r7 to
	@ &mq_GM[2*m] by adding 2*m (in bytes) to r8.
	add	r7, r8, r3, lsl #1

	@ r2 is free, since we know it contains 4.

	@ For m >= 8, fuse the last two layers for eight four-coefficient
	@ groups.  VLD4 deinterleaves
	@   x1 y1 x2 y2 | x1 y1 x2 y2 | ...
	@ directly into four 8x16-bit vectors; VST4 restores that exact layout.
	cmp	r3, #8
	blo	fndsa_mqpoly_int_to_ntt__L5

fndsa_mqpoly_int_to_ntt__L5_mve:
	@ q1=x1[0..7], q2=y1[0..7], q3=x2[0..7], q4=y2[0..7].
	vld40.16	{ q1, q2, q3, q4 }, [r1]
	vld41.16	{ q1, q2, q3, q4 }, [r1]
	vld42.16	{ q1, q2, q3, q4 }, [r1]
	vld43.16	{ q1, q2, q3, q4 }, [r1]
	vldrh.u16	q7, [r8]          @ one first-layer twiddle per group
	add.w	r8, r8, #16

	@ q3 <- mmul(q3,q7), preserving q7 for q4.
	vmov.i32	q5, #0
	vcmp.i16	eq, q3, q5
	vmulh.u16	q5, q3, q7
	vmul.i16	q3, q3, q7
	vdup.16	q6, r14
	vmulh.u16	q6, q3, q6
	movw	r12, #Q1IHI
	vmul.i16	q3, q3, r12
	vmul.i16	q5, q5, r14
	vadd.i16	q3, q3, q5
	vadd.i16	q3, q3, q6
	vdup.16	q6, r10
	vmulh.u16	q3, q3, q6
	movs	r12, #1
	vadd.i16	q3, q3, r12
	vpst
	vsubt.i16	q3, q3, r12

	@ q4 <- mmul(q4,q7).
	vmov.i32	q5, #0
	vcmp.i16	eq, q4, q5
	vmulh.u16	q5, q4, q7
	vmul.i16	q4, q4, q7
	vdup.16	q6, r14
	vmulh.u16	q6, q4, q6
	movw	r12, #Q1IHI
	vmul.i16	q4, q4, r12
	vmul.i16	q5, q5, r14
	vadd.i16	q4, q4, q5
	vadd.i16	q4, q4, q6
	vdup.16	q6, r10
	vmulh.u16	q4, q4, q6
	movs	r12, #1
	vadd.i16	q4, q4, r12
	vpst
	vsubt.i16	q4, q4, r12

	@ First of the fused layers.  q1/q3 become the x sum/difference;
	@ q2/q4 become the y sum/difference.
	vdup.16	q6, r10
	vadd.i16	q5, q1, q3
	vsub.i16	q5, q5, q6
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q6
	vsub.i16	q3, q1, q3
	vcmp.s16	lt, q3, zr
	vpst
	vaddt.i16	q3, q3, q6
	vmov	q1, q5

	vadd.i16	q5, q2, q4
	vsub.i16	q5, q5, q6
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q6
	vsub.i16	q4, q2, q4
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q6
	vmov	q2, q5

	@ The final-layer twiddles are stored sx0,sy0,sx1,sy1,... .
	vld20.16	{ q5, q6 }, [r7]
	vld21.16	{ q5, q6 }, [r7]
	add.w	r7, r7, #32

	@ q2 <- mmul(q2,q5); q5 is dead after the initial vector product.
	vmov.i32	q7, #0
	vcmp.i16	eq, q2, q7
	vmulh.u16	q7, q2, q5
	vmul.i16	q2, q2, q5
	vdup.16	q5, r14
	vmulh.u16	q5, q2, q5
	movw	r12, #Q1IHI
	vmul.i16	q2, q2, r12
	vmul.i16	q7, q7, r14
	vadd.i16	q2, q2, q7
	vadd.i16	q2, q2, q5
	vdup.16	q5, r10
	vmulh.u16	q2, q2, q5
	movs	r12, #1
	vadd.i16	q2, q2, r12
	vpst
	vsubt.i16	q2, q2, r12

	@ q4 <- mmul(q4,q6); q6 is dead after the initial vector product.
	vmov.i32	q7, #0
	vcmp.i16	eq, q4, q7
	vmulh.u16	q7, q4, q6
	vmul.i16	q4, q4, q6
	vdup.16	q6, r14
	vmulh.u16	q6, q4, q6
	movw	r12, #Q1IHI
	vmul.i16	q4, q4, r12
	vmul.i16	q7, q7, r14
	vadd.i16	q4, q4, q7
	vadd.i16	q4, q4, q6
	vdup.16	q6, r10
	vmulh.u16	q4, q4, q6
	movs	r12, #1
	vadd.i16	q4, q4, r12
	vpst
	vsubt.i16	q4, q4, r12

	@ Second fused layer.
	vdup.16	q6, r10
	vadd.i16	q5, q1, q2
	vsub.i16	q5, q5, q6
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q6
	vsub.i16	q2, q1, q2
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, q6
	vmov	q1, q5

	vadd.i16	q5, q3, q4
	vsub.i16	q5, q5, q6
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q6
	vsub.i16	q4, q3, q4
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q6
	vmov	q3, q5

	@ q1,q2,q3,q4 are now x1,x2,y1,y2 for the structure store.
	vst40.16	{ q1, q2, q3, q4 }, [r1]
	vst41.16	{ q1, q2, q3, q4 }, [r1]
	vst42.16	{ q1, q2, q3, q4 }, [r1]
	vst43.16	{ q1, q2, q3, q4 }, [r1]
	add.w	r1, r1, #64

	subs	r3, #8
	bne	fndsa_mqpoly_int_to_ntt__L5_mve
	b	fndsa_mqpoly_int_to_ntt__Lend

fndsa_mqpoly_int_to_ntt__L5:
	@ Next-to-last outer iteration: the four values are, in RAM order:
	@   x1 y1 x2 y2
	@ We load x2:y2 (into r5) and s (into r6)
	ldr.w	r5, [r1, #4]
	ldrh	r6, [r8], #2

	@ r4 <- mmul(x2, s)
	smulbb	r4, r5, r6
	mul	r12, r4, r14
	umaal	r14, r4, r12, r10
	@ r5 <- mmul(y2, s)
	smultb	r5, r5, r6
	mul	r12, r5, r14
	umaal	r14, r5, r12, r10
	@ r5 <- mmul(x2, s) : mmul(y2, s)
	pkhbt	r5, r4, r5, lsl #16

	@ Load x1:y1 (into r4)
	ldr.w	r4, [r1]

	@ r4 <- (x1+mmul(x2,s)):(y1+mmul(y2,s))
	@ r5 <- (x1-mmul(x2,s)):(y1-mmul(y2,s))
	sadd16	r12, r4, r5
	ssub16	r5, r4, r5
	sel	r4, r0, r11
	sadd16	r5, r5, r4
	ssub16	r4, r12, r11
	sel	r4, r4, r12

	@ Last iteration: the four values are, in RAM order: x1 x2 y1 y2
	@ The values have not been really written to RAM, though; they
	@ are in r4 (x1:x2) and r5 (y1:y2).
	@ Get the two relevant s values into r6.
	ldr	r6, [r7], #4

	@ r2 <- x1:y1
	pkhbt	r2, r4, r5, lsl #16
	@ r5 <- mmul(x2,s):mmul(y2,s)
	smultb	r4, r4, r6
	mul	r12, r4, r14
	umaal	r14, r4, r12, r10
	smultt	r5, r5, r6
	mul	r12, r5, r14
	umaal	r14, r5, r12, r10
	pkhbt	r5, r4, r5, lsl #16
	@ r4 <- (x1+mmul(x2,s):(y1+mmul(y2,s))
	sadd16	r4, r2, r5
	ssub16	r12, r4, r11
	sel	r4, r12, r4
	@ r5 <- (x1-mmul(x2,s):(y1-mmul(y2,s))
	ssub16	r5, r2, r5
	sel	r12, r0, r11
	sadd16	r5, r5, r12

	@ We write the four final values in x1 x2 y1 y2 order.
	pkhbt	r12, r4, r5, lsl #16
	str.w	r12, [r1], #4
	pkhtb	r12, r5, r4, asr #16
	str.w	r12, [r1], #4

	subs	r3, #1
	bne	fndsa_mqpoly_int_to_ntt__L5

fndsa_mqpoly_int_to_ntt__Lend:
	vpop	{ d8-d15 }
	pop	{ r4, r5, r6, r7, r8, r10, r11, pc }
	.align	2
fndsa_mqpoly_int_to_ntt__gmaddr_plus1:
	.word	fndsa_mq_GM + 2
	.size	fndsa_mqpoly_int_to_ntt,.-fndsa_mqpoly_int_to_ntt

@ =======================================================================
@ void fndsa_mqpoly_ntt_to_int(unsigned logn, uint16_t *d)
@ =======================================================================

	.align	2
	.global	fndsa_mqpoly_ntt_to_int
	.thumb
	.thumb_func
	.type	fndsa_mqpoly_ntt_to_int, %function
fndsa_mqpoly_ntt_to_int:
	push.w	{ r4, r5, r6, r7, r8, r10, r11, lr }
	vpush	{ d8-d15 }      @ q4-q7 (s16-s31) are callee-saved

	@ ASSUMPTION: logn >= 2

	@ State:
	@   r0    scratch
	@   r1    &d[j1]
	@   r2    dt = 2*t
	@   r3    middle loop counter
	@   r4    x1
	@   r5    x2
	@   r6    s
	@   r7    innermost loop counter
	@   r8    &mq_GM[i + hm]
	@   r10   q
	@   r11   q:q
	@   r12   scratch
	@   r14   -1/q mod 2^32
	@
	@   s2    d
	@   s3    m

	@ We save the original d in s2.
	vmov	s2, r1
	@ m = n initially; we save m/2 to s3, and set r8 to &mq_iGM[m/2]
	adr	r8, fndsa_mqpoly_ntt_to_int__igmaddr
	ldr	r8, [r8]
	movs	r3, #1
	subs	r0, #1
	lsl	r0, r3, r0     @ r0 <- n/2 = 2^(logn-1)
	add.w	r8, r8, r0     @ r8 <- &mq_iGM[n/4]
	lsr	r3, r0, #1
	vmov	s3, r3         @ s3 <- n/4

	@ r0 <- 0
	movw	r0, #0
	@ r10 <- q
	movw	r10, #Q
	@ r11 <- q:q
	orr	r11, r10, r10, lsl #16
	@ r14 <- -1/q mod 2^32
	movw	r14, #(Q1I & 0xFFFF)
	movt	r14, #(Q1I >> 16)

	@ r8 is the pointer into mq_GM[] for the second outer iteration.
	@ r7 is the pointer into mq_GM[] for the first outer iteration.
	add	r7, r8, r3, lsl #1

	@ r3 is the loop counter. r10, r11 and r14 are constants used for
	@ modular reduction. r2, r4, r5 and r12 are scratch.

	@ First two iterations are specialized.
	@ For n >= 32, process eight four-coefficient groups in parallel while
	@ preserving the existing two-layer fusion.  Smaller public sizes keep
	@ the scalar Cortex-M4 path below.
	cmp	r3, #8
	blo	fndsa_mqpoly_ntt_to_int__L0

fndsa_mqpoly_ntt_to_int__L0_mve:
	@ Input layout for each group is x1,x2,y1,y2.  VLD4 deinterleaves
	@ eight groups directly into q1,q2,q3,q4.
	vld40.16	{ q1, q2, q3, q4 }, [r1]
	vld41.16	{ q1, q2, q3, q4 }, [r1]
	vld42.16	{ q1, q2, q3, q4 }, [r1]
	vld43.16	{ q1, q2, q3, q4 }, [r1]

	@ First-layer twiddles are interleaved s1,s2 for each group.
	vld20.16	{ q5, q6 }, [r7]
	vld21.16	{ q5, q6 }, [r7]
	add.w	r7, r7, #32

	@ First inverse butterfly: q1 <- half(q1+q2), q2 <- q1-q2.
	vadd.i16	q7, q1, q2
	vsub.i16	q7, q7, r10
	vcmp.s16	lt, q7, zr
	vpst
	vaddt.i16	q7, q7, r10
	vsub.i16	q2, q1, q2
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, r10
	vmov.i16	q1, #1
	vand	q1, q7, q1
	vcmp.i16	ne, q1, zr
	vpst
	vaddt.i16	q7, q7, r10
	vshr.u16	q1, q7, #1

	@ q2 <- mmul(q2,q5); q5 is dead after the initial vector product.
	vmov.i32	q7, #0
	vcmp.i16	eq, q2, q7
	vmulh.u16	q7, q2, q5
	vmul.i16	q2, q2, q5
	vdup.16	q5, r14
	vmulh.u16	q5, q2, q5
	movw	r12, #Q1IHI
	vmul.i16	q2, q2, r12
	vmul.i16	q7, q7, r14
	vadd.i16	q2, q2, q7
	vadd.i16	q2, q2, q5
	vdup.16	q5, r10
	vmulh.u16	q2, q2, q5
	movs	r12, #1
	vadd.i16	q2, q2, r12
	vpst
	vsubt.i16	q2, q2, r12

	@ Second inverse butterfly: q3 <- half(q3+q4), q4 <- q3-q4.
	vadd.i16	q5, q3, q4
	vsub.i16	q5, q5, r10
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, r10
	vsub.i16	q4, q3, q4
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	vmov.i16	q3, #1
	vand	q3, q5, q3
	vcmp.i16	ne, q3, zr
	vpst
	vaddt.i16	q5, q5, r10
	vshr.u16	q3, q5, #1

	@ q4 <- mmul(q4,q6); q6 is dead after the initial vector product.
	vmov.i32	q7, #0
	vcmp.i16	eq, q4, q7
	vmulh.u16	q7, q4, q6
	vmul.i16	q4, q4, q6
	vdup.16	q6, r14
	vmulh.u16	q6, q4, q6
	movw	r12, #Q1IHI
	vmul.i16	q4, q4, r12
	vmul.i16	q7, q7, r14
	vadd.i16	q4, q4, q7
	vadd.i16	q4, q4, q6
	vdup.16	q6, r10
	vmulh.u16	q4, q4, q6
	movs	r12, #1
	vadd.i16	q4, q4, r12
	vpst
	vsubt.i16	q4, q4, r12

	@ Second fused layer.  q1/q3 and q2/q4 are its two butterflies.
	@ Both use the same per-group twiddle loaded contiguously from r8.
	vldrh.u16	q7, [r8]
	add.w	r8, r8, #16

	vadd.i16	q5, q1, q3
	vsub.i16	q5, q5, r10
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, r10
	vsub.i16	q3, q1, q3
	vcmp.s16	lt, q3, zr
	vpst
	vaddt.i16	q3, q3, r10
	vmov.i16	q6, #1
	vand	q6, q5, q6
	vcmp.i16	ne, q6, zr
	vpst
	vaddt.i16	q5, q5, r10
	vshr.u16	q1, q5, #1

	vadd.i16	q5, q2, q4
	vsub.i16	q5, q5, r10
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, r10
	vsub.i16	q4, q2, q4
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	vmov.i16	q6, #1
	vand	q6, q5, q6
	vcmp.i16	ne, q6, zr
	vpst
	vaddt.i16	q5, q5, r10
	vshr.u16	q2, q5, #1

	@ q3 <- mmul(q3,q7), preserving q7 for q4.
	vmov.i32	q5, #0
	vcmp.i16	eq, q3, q5
	vmulh.u16	q5, q3, q7
	vmul.i16	q3, q3, q7
	vdup.16	q6, r14
	vmulh.u16	q6, q3, q6
	movw	r12, #Q1IHI
	vmul.i16	q3, q3, r12
	vmul.i16	q5, q5, r14
	vadd.i16	q3, q3, q5
	vadd.i16	q3, q3, q6
	vdup.16	q6, r10
	vmulh.u16	q3, q3, q6
	movs	r12, #1
	vadd.i16	q3, q3, r12
	vpst
	vsubt.i16	q3, q3, r12

	@ q4 <- mmul(q4,q7).
	vmov.i32	q5, #0
	vcmp.i16	eq, q4, q5
	vmulh.u16	q5, q4, q7
	vmul.i16	q4, q4, q7
	vdup.16	q6, r14
	vmulh.u16	q6, q4, q6
	movw	r12, #Q1IHI
	vmul.i16	q4, q4, r12
	vmul.i16	q5, q5, r14
	vadd.i16	q4, q4, q5
	vadd.i16	q4, q4, q6
	vdup.16	q6, r10
	vmulh.u16	q4, q4, q6
	movs	r12, #1
	vadd.i16	q4, q4, r12
	vpst
	vsubt.i16	q4, q4, r12

	@ Output layout is z0,z1,z2,z3 for each of the eight groups.
	vst40.16	{ q1, q2, q3, q4 }, [r1]
	vst41.16	{ q1, q2, q3, q4 }, [r1]
	vst42.16	{ q1, q2, q3, q4 }, [r1]
	vst43.16	{ q1, q2, q3, q4 }, [r1]
	add.w	r1, r1, #64

	subs	r3, #8
	bne	fndsa_mqpoly_ntt_to_int__L0_mve
	b	fndsa_mqpoly_ntt_to_int__L0_done

fndsa_mqpoly_ntt_to_int__L0:
	@ First iteration: values are in x1 x2 y1 y2 order.
	ldr	r2, [r1]        @ r2 <- x1:x2
	ldr	r5, [r1, #4]    @ r5 <- y1:y2
	ldr.w	r6, [r7], #4    @ r6 <- s1:s2

	@ r4 <- x1:y1
	pkhbt	r4, r2, r5, lsl #16
	@ r5 <- x2:y2
	pkhtb	r5, r5, r2, asr #16
	@ r2 <- (x1+x2)/2:(y1+y2)/2
	sadd16	r2, r4, r5
	ssub16	r12, r2, r11
	sel	r2, r12, r2
	and	r12, r2, #0x00010001
	umlal	r2, r12, r12, r10
	lsr.w	r2, r2, #1
	@ r5 <- (x1-x2):(y1-y2)
	ssub16	r5, r4, r5
	sel	r12, r0, r11
	sadd16	r5, r5, r12
	@ r4 <- mmul(x1-x2,s)
	smulbb	r4, r5, r6
	mul	r12, r4, r14
	umaal	r14, r4, r12, r10
	@ r5 <- mmul(y1-y2,s)
	smultt	r5, r5, r6
	mul	r12, r5, r14
	umaal	r14, r5, r12, r10

	@ Second iteration. Normally we get x1 y1 x2 y2 from RAM; here,
	@ we have x1:x2 in r2, y1 in r4 and y2 in r5.
	@ Reorganize the values:
	pkhbt	r4, r2, r4, lsl #16   @ r4 <- x1:y1
	lsl.w	r5, r5, #16
	orr	r5, r5, r2, lsr #16   @ r5 <- x2:y2
	@ Read s for the second iteration.
	ldrh	r6, [r8], #2

	@ r2 <- (x1+x2)/2:(y1+y2)/2
	sadd16	r2, r4, r5
	ssub16	r12, r2, r11
	sel	r2, r12, r2
	and	r12, r2, #0x00010001
	umlal	r2, r12, r12, r10
	lsr.w	r2, r2, #1
	@ r5 <- (x1-x2):(y1-y2)
	ssub16	r5, r4, r5
	sel	r12, r0, r11
	sadd16	r5, r5, r12
	@ r4 <- mmul(x1-x2,s)
	smulbb	r4, r5, r6
	mul	r12, r4, r14
	umaal	r14, r4, r12, r10
	@ r5 <- mmul(y1-y2,s)
	smultb	r5, r5, r6
	mul	r12, r5, r14
	umaal	r14, r5, r12, r10

	@ Repack values, to write them in x1 y1 x2 y2 order.
	str.w	r2, [r1], #4
	pkhbt	r4, r4, r5, lsl #16
	str.w	r4, [r1], #4

	@ Loop n/4 times.
	subs	r3, #1
	bne	fndsa_mqpoly_ntt_to_int__L0

fndsa_mqpoly_ntt_to_int__L0_done:

	@ Prepare for remaining iterations.
	@ r2 <- -2*t = -8
	movs	r2, #8
	rsbs	r2, #0
	@ r3 <- m (for next iteration)
	vmov	r3, s3

	@ If logn=2 then m=1 and we are finished.
	cmp	r3, #1
	beq	fndsa_mqpoly_ntt_to_int__Lend

	@ Only FN-DSA-1024 has m=n/4=256 here.  Its remaining eight inverse
	@ layers use the dedicated four-pair GS path below.  Other public
	@ degrees retain the stage-1 loop byte-for-byte.
	cmp	r3, #256
	beq	fndsa_mqpoly_ntt_to_int__I2_setup
	b	fndsa_mqpoly_ntt_to_int__L1

fndsa_mqpoly_ntt_to_int__I2_setup:
	@ The already existing L0 kernel consumed inverse layers 0 and 1.
	@ Start the first remaining pair with m=256 and t=4 coefficients.
	movs	r2, #4

fndsa_mqpoly_ntt_to_int__I2_outer:
	vmov	r1, s2
	vmov	r3, s3
	@ For a pair beginning at m, the first inverse layer consumes
	@ iGM[m/2..m-1], while the second consumes iGM[m/4..m/2-1].
	adr	r8, fndsa_mqpoly_ntt_to_int__igmaddr
	ldr	r8, [r8]
	add.w	r7, r8, r3
	add.w	r8, r8, r3, lsr #1
	lsr.w	r3, r3, #2
	@ Byte distance between each of the four streams.
	lsl.w	r4, r2, #1

fndsa_mqpoly_ntt_to_int__I2_middle:
	@ Two first-layer inverse twiddles, followed by their parent.
	ldr.w	r12, [r7], #4
	uxth	r5, r12
	lsr.w	r6, r12, #16
	ldrh	r11, [r8], #2

	@ As in the forward kernel, t=4 uses only the low half of each q
	@ register so that no 128-bit load crosses the end of the array.
	cmp	r2, #4
	beq	fndsa_mqpoly_ntt_to_int__I2_half
	lsr.w	r0, r2, #3

fndsa_mqpoly_ntt_to_int__I2_vector:
	vldrh.u16	q1, [r1]
	add.w	r12, r1, r4
	vldrh.u16	q2, [r12]
	add.w	r12, r12, r4
	vldrh.u16	q3, [r12]
	add.w	r12, r12, r4
	vldrh.u16	q4, [r12]
	b	fndsa_mqpoly_ntt_to_int__I2_butterflies

fndsa_mqpoly_ntt_to_int__I2_half:
	vldr	d2, [r1]
	add.w	r12, r1, r4
	vldr	d4, [r12]
	add.w	r12, r12, r4
	vldr	d6, [r12]
	add.w	r12, r12, r4
	vldr	d8, [r12]

fndsa_mqpoly_ntt_to_int__I2_butterflies:
	@ Undo the two child butterflies, then their common parent.
	MQ_GS_X8	q1, q2, r5, q5, q6, q7
	MQ_GS_X8	q3, q4, r6, q5, q6, q7
	MQ_GS_X8	q1, q3, r11, q5, q6, q7
	MQ_GS_X8	q2, q4, r11, q5, q6, q7

	cmp	r2, #4
	beq	fndsa_mqpoly_ntt_to_int__I2_half_store
	vstrh.16	q1, [r1]
	add.w	r12, r1, r4
	vstrh.16	q2, [r12]
	add.w	r12, r12, r4
	vstrh.16	q3, [r12]
	add.w	r12, r12, r4
	vstrh.16	q4, [r12]
	add.w	r1, r1, #16
	subs	r0, #1
	bne	fndsa_mqpoly_ntt_to_int__I2_vector
	add.w	r1, r1, r4, lsl #1
	add.w	r1, r1, r4
	b	fndsa_mqpoly_ntt_to_int__I2_middle_done

fndsa_mqpoly_ntt_to_int__I2_half_store:
	vstr	d2, [r1]
	add.w	r12, r1, r4
	vstr	d4, [r12]
	add.w	r12, r12, r4
	vstr	d6, [r12]
	add.w	r12, r12, r4
	vstr	d8, [r12]
	add.w	r1, r1, r4, lsl #2

fndsa_mqpoly_ntt_to_int__I2_middle_done:
	subs	r3, #1
	bne	fndsa_mqpoly_ntt_to_int__I2_middle

	@ Move four levels toward the NTT root and grow t by four.
	vmov	r3, s3
	lsr.w	r3, r3, #2
	vmov	s3, r3
	lsl.w	r2, r2, #2
	cmp	r3, #1
	bne	fndsa_mqpoly_ntt_to_int__I2_outer
	b	fndsa_mqpoly_ntt_to_int__Lend

fndsa_mqpoly_ntt_to_int__L1:
	@ Rewind r1 to start of array.
	vmov	r1, s2

	@ m is in r3. r8 was left at &mq_iGM[2*m]; we need to adjust it
	@ to &mq_iGM[m/2], by subtracting 3*m (each element is two bytes).
	sub	r8, r8, r3, lsl #1
	sub.w	r8, r8, r3

	@ Middle loop has m/2 iterations (r3 is used as counter).
fndsa_mqpoly_ntt_to_int__L2:
	ldrh	r6, [r8], #2   @ s <- mq_iGM[i + m/2]

	asrs	r7, r2, #1     @ r7 <- -t
	@ We use r1 to point to the second pair (x2:y2); r2 is negative.
	@ The inner loop will inherently adjust r1 to point to the start
	@ of the next chunk for the next middle loop iteration.
	subs	r1, r1, r2

	@ Process eight inverse butterflies per iteration whenever t >= 8.
	@ r7 is the negative coefficient count (-t), hence -4 uses the scalar
	@ pairwise path below and -8,-16,... use this vector path.
	cmp	r7, #-8
	bgt	fndsa_mqpoly_ntt_to_int__L3

fndsa_mqpoly_ntt_to_int__L3_mve:
	@ q1 <- first half, q2 <- second half.
	add.w	r4, r1, r2
	vldrh.u16	q1, [r4]
	vldrh.u16	q2, [r1]
	vdup.16	q3, r10

	@ First output is mq_half(mq_add(q1,q2)).
	vadd.i16	q4, q1, q2
	vsub.i16	q4, q4, q3
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q3
	vmov.i16	q3, #1
	vand	q3, q4, q3
	vcmp.i16	ne, q3, zr
	vdup.16	q3, r10
	vpst
	vaddt.i16	q4, q4, q3
	vshr.u16	q4, q4, #1
	vstrh.16	q4, [r4]

	@ q4 <- mq_sub(q1,q2), then q4 <- mmul(q4,s).
	vsub.i16	q4, q1, q2
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q3
	vmov.i32	q1, #0
	vcmp.i16	eq, q4, q1
	vdup.16	q3, r6
	vmulh.u16	q1, q4, q3
	vmul.i16	q4, q4, q3
	vdup.16	q2, r14
	vmulh.u16	q2, q4, q2
	movw	r12, #Q1IHI
	vmul.i16	q4, q4, r12
	vmul.i16	q1, q1, r14
	vadd.i16	q4, q4, q1
	vadd.i16	q4, q4, q2
	vdup.16	q2, r10
	vmulh.u16	q4, q4, q2
	movs	r12, #1
	vadd.i16	q4, q4, r12
	vpst
	vsubt.i16	q4, q4, r12
	vstrh.16	q4, [r1]

	add.w	r1, r1, #16
	adds	r7, #8
	bne	fndsa_mqpoly_ntt_to_int__L3_mve
	b	fndsa_mqpoly_ntt_to_int__L3_done

fndsa_mqpoly_ntt_to_int__L3:
	@ Each inner loop iteration processes two pairs (x1,x2) and (y1,y2).
	ldr	r4, [r1, r2]   @ r4 <- x1:y1
	ldr	r5, [r1]       @ r5 <- x2:y2

	@ r4 <- (x1+x2):(y1+y2)
	@ r5 <- (x1-x2):(y1-x2)
	sadd16	r12, r4, r5
	ssub16	r5, r4, r5
	sel	r4, r0, r11
	sadd16	r5, r5, r4
	ssub16	r4, r12, r11
	sel	r4, r4, r12
	@ r4 <- (x1+x2)/2:(y1+y2)/2
	and	r12, r4, #0x00010001
	umlal	r4, r12, r12, r10
	lsr.w	r4, r4, #1
	@ Write first output word
	str.w	r4, [r1, r2]

	@ r5 <- mmul(x1-x2,s):mmul(y1-y2,s)
	smulbb	r4, r5, r6
	mul	r12, r4, r14
	umaal	r14, r4, r12, r10
	smultb	r5, r5, r6
	mul	r12, r5, r14
	umaal	r14, r5, r12, r10
	pkhbt	r5, r4, r5, lsl #16
	@ Write second output word
	str.w	r5, [r1], #4

	@ We should do t iterations, but since we process a pair of elements
	@ each time, we only do t/2 iterations. Take care that the r7 counter
	@ is negative.
	adds	r7, #2
	bne	fndsa_mqpoly_ntt_to_int__L3

fndsa_mqpoly_ntt_to_int__L3_done:

	@ We loop m/2 times
	subs	r3, #2
	bne	fndsa_mqpoly_ntt_to_int__L2

	@ Replace -t with -dt = 2*(-t)
	lsl.w	r2, r2, #1

	@ Replace m with m/2. We are finished when m becomes 1.
	vmov	r3, s3
	lsr.w	r3, r3, #1
	vmov	s3, r3
	cmp	r3, #1
	bne	fndsa_mqpoly_ntt_to_int__L1

fndsa_mqpoly_ntt_to_int__Lend:
	vpop	{ d8-d15 }
	pop	{ r4, r5, r6, r7, r8, r10, r11, pc }
	.align	2
fndsa_mqpoly_ntt_to_int__igmaddr:
	.word	fndsa_mq_iGM
	.size	fndsa_mqpoly_ntt_to_int,.-fndsa_mqpoly_ntt_to_int
