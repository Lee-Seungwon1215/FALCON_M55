	.syntax unified
	.thumb
	.text

/* Test-only exact Q32 multiply by a PUBLIC FFT twiddle or twiddle sum.
 * r0 = input uint64 words, r1 = output, r2 = n (multiple of four),
 * r3 = pointer to signed 64-bit Q32 constant. Its signed high word is
 * -2,-1,0,1. This domain includes individual FFT roots and the sum used
 * in the ORIGINAL three-product complex formula. No coefficient bounds
 * are assumed; result wraps exactly as fxr_mul does.
 * Dispatch depends ONLY on the public constant, not on input coefficients.
 */
	.macro TWIDDLE_LOOP name, high, low_negative
\name:
	movs r12, #1
1:
	vld20.32 {q0,q1}, [r0]
	vld21.32 {q0,q1}, [r0]
	/* floor(xL*tL / 2^32) + xH*tL, with xH signed, tL unsigned. */
	vmulh.u32 q3, q0, q2
	vmulh.s32 q4, q1, q2
	.if \low_negative
	vadd.i32 q4, q4, q1
	.endif
	vmul.i32 q5, q1, q2
	vadd.i32 q3, q3, q5
	vcmp.u32 hi, q5, q3
	vpst
	vaddt.i32 q4, q4, r12
	/* Add x*tH modulo 2^64, where tH is a public small integer. */
	.if \high == 1
	vadd.i32 q3, q3, q0
	vcmp.u32 hi, q0, q3
	vadd.i32 q4, q4, q1
	vpst
	vaddt.i32 q4, q4, r12
	.elseif \high == -1
	vcmp.u32 hi, q0, q3
	vsub.i32 q3, q3, q0
	vsub.i32 q4, q4, q1
	vpst
	vsubt.i32 q4, q4, r12
	.elseif \high == -2
	vshr.u32 q5, q0, #31
	vshl.i32 q6, q1, #1
	vorr q6, q6, q5
	vshl.i32 q5, q0, #1
	vcmp.u32 hi, q5, q3
	vsub.i32 q3, q3, q5
	vsub.i32 q4, q4, q6
	vpst
	vsubt.i32 q4, q4, r12
	.endif
	vst20.32 {q3,q4}, [r1]
	vst21.32 {q3,q4}, [r1]
	adds r0, #32
	adds r1, #32
	subs r2, #4
	bne 1b
	vpop {d8-d13}
	bx lr
	.endm
	.section .text.trial_mve_q32_twiddle,"ax",%progbits
	.balign 4
	.global trial_mve_q32_twiddle
	.type trial_mve_q32_twiddle,%function
	.thumb_func
trial_mve_q32_twiddle:
	vpush {d8-d13}
	ldr r12, [r3, #4]
	ldr r3, [r3]
	vdup.32 q2, r3
	cmp r3, #0
	blt .Lnegative_low
	cmp r12, #0
	beq .Lp0
	bgt .Lp1
	cmn r12, #1
	beq .Lpm1
	b .Lpm2
.Lnegative_low:
	cmp r12, #0
	beq .Ln0
	bgt .Ln1
	cmn r12, #1
	beq .Lnm1
	b .Lnm2
	TWIDDLE_LOOP .Lp0, 0, 0
	TWIDDLE_LOOP .Lp1, 1, 0
	TWIDDLE_LOOP .Lpm1, -1, 0
	TWIDDLE_LOOP .Lpm2, -2, 0
	TWIDDLE_LOOP .Ln0, 0, 1
	TWIDDLE_LOOP .Ln1, 1, 1
	TWIDDLE_LOOP .Lnm1, -1, 1
	TWIDDLE_LOOP .Lnm2, -2, 1
	.size trial_mve_q32_twiddle, .-trial_mve_q32_twiddle

/* The following helpers vectorize the EXACT surrounding Q32 additions,
 * original three-product combination and stagewise rounded half.
 * Each span length is positive and divisible by four. */
	.macro TWA_ADD dl, dh, al, ah, bl, bh
	vadd.i32 \dl, \al, \bl
	vcmp.u32 hi, \bl, \dl
	vadd.i32 \dh, \ah, \bh
	vpst
	vaddt.i32 \dh, \dh, r12
	.endm
	.macro TWA_SUB dl, dh, al, ah, bl, bh
	vcmp.u32 hi, \bl, \al
	vsub.i32 \dl, \al, \bl
	vsub.i32 \dh, \ah, \bh
	vpst
	vsubt.i32 \dh, \dh, r12
	.endm
	.macro TWA_HALF lo, hi, tmp
	vadd.i32 \lo, \lo, r12
	vcmp.i32 eq, \lo, r3
	vpst
	vaddt.i32 \hi, \hi, r12
	vshl.i32 \tmp, \hi, #31
	vshr.u32 \lo, \lo, #1
	vorr \lo, \lo, \tmp
	vshr.s32 \hi, \hi, #1
	.endm

/* r0=a, r1=b, r2=out, r3=count; all interleaved raw Q32 words. */
	.section .text.trial_q32_add_span,"ax",%progbits
	.balign 4
	.global trial_q32_add_span
	.type trial_q32_add_span,%function
	.thumb_func
trial_q32_add_span:
	vpush {d8-d11}
	movs r12, #1
1:
	vld20.32 {q0,q1}, [r0]
	vld21.32 {q0,q1}, [r0]
	vld20.32 {q2,q3}, [r1]
	vld21.32 {q2,q3}, [r1]
	TWA_ADD q4,q5,q0,q1,q2,q3
	vst20.32 {q4,q5}, [r2]
	vst21.32 {q4,q5}, [r2]
	adds r0, #32
	adds r1, #32
	adds r2, #32
	subs r3, #4
	bne 1b
	vpop {d8-d11}
	bx lr
	.size trial_q32_add_span, .-trial_q32_add_span

/* r0={xr,xi,yr,yi,z2,z0,z1}, r1=count. */
	.macro TWA_PRODUCT_COMBINE
	vld20.32 {q0,q1}, [r9]
	vld21.32 {q0,q1}, [r9]
	vld20.32 {q2,q3}, [r10]
	vld21.32 {q2,q3}, [r10]
	TWA_SUB q4,q5,q0,q1,q2,q3
	TWA_ADD q6,q7,q0,q1,q2,q3
	vld20.32 {q0,q1}, [r8]
	vld21.32 {q0,q1}, [r8]
	TWA_SUB q6,q7,q0,q1,q6,q7
	.endm
	.macro TWA_PAIR_MIX xp, yp, re, im
	vld20.32 {q0,q1}, [\xp]
	vld21.32 {q0,q1}, [\xp]
	TWA_ADD q2,q3,q0,q1,\re,\im
	TWA_SUB q0,q1,q0,q1,\re,\im
	vst20.32 {q2,q3}, [\xp]
	vst21.32 {q2,q3}, [\xp]
	vst20.32 {q0,q1}, [\yp]
	vst21.32 {q0,q1}, [\yp]
	.endm
	.section .text.trial_q32_finish_forward,"ax",%progbits
	.balign 4
	.global trial_q32_finish_forward
	.type trial_q32_finish_forward,%function
	.thumb_func
trial_q32_finish_forward:
	push {r4-r10,lr}
	vpush {d8-d15}
	ldmia r0, {r4-r10}
	movs r12, #1
1:
	TWA_PRODUCT_COMBINE
	TWA_PAIR_MIX r4,r6,q4,q5
	TWA_PAIR_MIX r5,r7,q6,q7
	add r4, #32
	add r5, #32
	add r6, #32
	add r7, #32
	add r8, #32
	add r9, #32
	add r10, #32
	subs r1, #4
	bne 1b
	vpop {d8-d15}
	pop {r4-r10,pc}
	.size trial_q32_finish_forward, .-trial_q32_finish_forward

	.section .text.trial_q32_finish_inverse,"ax",%progbits
	.balign 4
	.global trial_q32_finish_inverse
	.type trial_q32_finish_inverse,%function
	.thumb_func
trial_q32_finish_inverse:
	push {r4-r10,lr}
	vpush {d8-d15}
	ldmia r0, {r4-r10}
	movs r12, #1
1:
	TWA_PRODUCT_COMBINE
	vst20.32 {q4,q5}, [r6]
	vst21.32 {q4,q5}, [r6]
	vst20.32 {q6,q7}, [r7]
	vst21.32 {q6,q7}, [r7]
	add r6, #32
	add r7, #32
	add r8, #32
	add r9, #32
	add r10, #32
	subs r1, #4
	bne 1b
	vpop {d8-d15}
	pop {r4-r10,pc}
	.size trial_q32_finish_inverse, .-trial_q32_finish_inverse

	.macro TWA_PREP_PAIR xp,yp
	vld20.32 {q0,q1}, [\xp]
	vld21.32 {q0,q1}, [\xp]
	vld20.32 {q2,q3}, [\yp]
	vld21.32 {q2,q3}, [\yp]
	TWA_ADD q4,q5,q0,q1,q2,q3
	TWA_SUB q6,q7,q0,q1,q2,q3
	TWA_HALF q4,q5,q0
	TWA_HALF q6,q7,q0
	vst20.32 {q4,q5}, [\xp]
	vst21.32 {q4,q5}, [\xp]
	vst20.32 {q6,q7}, [\yp]
	vst21.32 {q6,q7}, [\yp]
	.endm
/* r0={xr,xi,yr,yi,...},r1=count. r3 holds scalar zero throughout. */
	.section .text.trial_q32_prepare_inverse,"ax",%progbits
	.balign 4
	.global trial_q32_prepare_inverse
	.type trial_q32_prepare_inverse,%function
	.thumb_func
trial_q32_prepare_inverse:
	push {r4-r7}
	vpush {d8-d15}
	ldmia r0, {r4-r7}
	movs r12, #1
	movs r3, #0
1:
	TWA_PREP_PAIR r4,r6
	TWA_PREP_PAIR r5,r7
	add r4, #32
	add r5, #32
	add r6, #32
	add r7, #32
	subs r1, #4
	bne 1b
	vpop {d8-d15}
	pop {r4-r7}
	bx lr
	.size trial_q32_prepare_inverse, .-trial_q32_prepare_inverse
