/* Test-only mechanical copies of the production A9 multiplier.
 * Source SHA256: b1279509b394319f5635fd857832e4a7250b504ef8499ad436f8fb09b8c5e134
 * Rebuild with this generator if the production instructions change. */
	.syntax unified
	.thumb
	.macro NTRU_TWIDDLE_LOOP name, high, low_negative
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

	.section .text.trial_twiddle_at_0,"ax",%progbits
	.balign 32
	.space 0, 0
	.global trial_twiddle_at_0
	.type trial_twiddle_at_0,%function
	.thumb_func
trial_twiddle_at_0:
	vpush {d8-d13}
	ldr r12, [r3, #4]
	ldr r3, [r3]
	vdup.32 q2, r3
	cmp r3, #0
	blt .Lpos0_negative_low
	cmp r12, #0
	beq .Lpos0_p0
	bgt .Lpos0_p1
	cmn r12, #1
	beq .Lpos0_pm1
	b .Lpos0_pm2
.Lpos0_negative_low:
	cmp r12, #0
	beq .Lpos0_n0
	bgt .Lpos0_n1
	cmn r12, #1
	beq .Lpos0_nm1
	b .Lpos0_nm2
	NTRU_TWIDDLE_LOOP .Lpos0_p0, 0, 0
	NTRU_TWIDDLE_LOOP .Lpos0_p1, 1, 0
	NTRU_TWIDDLE_LOOP .Lpos0_pm1, -1, 0
	NTRU_TWIDDLE_LOOP .Lpos0_pm2, -2, 0
	NTRU_TWIDDLE_LOOP .Lpos0_n0, 0, 1
	NTRU_TWIDDLE_LOOP .Lpos0_n1, 1, 1
	NTRU_TWIDDLE_LOOP .Lpos0_nm1, -1, 1
	NTRU_TWIDDLE_LOOP .Lpos0_nm2, -2, 1
	.size trial_twiddle_at_0, .-trial_twiddle_at_0
	.section .text.trial_twiddle_at_4,"ax",%progbits
	.balign 32
	.space 4, 0
	.global trial_twiddle_at_4
	.type trial_twiddle_at_4,%function
	.thumb_func
trial_twiddle_at_4:
	vpush {d8-d13}
	ldr r12, [r3, #4]
	ldr r3, [r3]
	vdup.32 q2, r3
	cmp r3, #0
	blt .Lpos4_negative_low
	cmp r12, #0
	beq .Lpos4_p0
	bgt .Lpos4_p1
	cmn r12, #1
	beq .Lpos4_pm1
	b .Lpos4_pm2
.Lpos4_negative_low:
	cmp r12, #0
	beq .Lpos4_n0
	bgt .Lpos4_n1
	cmn r12, #1
	beq .Lpos4_nm1
	b .Lpos4_nm2
	NTRU_TWIDDLE_LOOP .Lpos4_p0, 0, 0
	NTRU_TWIDDLE_LOOP .Lpos4_p1, 1, 0
	NTRU_TWIDDLE_LOOP .Lpos4_pm1, -1, 0
	NTRU_TWIDDLE_LOOP .Lpos4_pm2, -2, 0
	NTRU_TWIDDLE_LOOP .Lpos4_n0, 0, 1
	NTRU_TWIDDLE_LOOP .Lpos4_n1, 1, 1
	NTRU_TWIDDLE_LOOP .Lpos4_nm1, -1, 1
	NTRU_TWIDDLE_LOOP .Lpos4_nm2, -2, 1
	.size trial_twiddle_at_4, .-trial_twiddle_at_4
	.section .text.trial_twiddle_at_8,"ax",%progbits
	.balign 32
	.space 8, 0
	.global trial_twiddle_at_8
	.type trial_twiddle_at_8,%function
	.thumb_func
trial_twiddle_at_8:
	vpush {d8-d13}
	ldr r12, [r3, #4]
	ldr r3, [r3]
	vdup.32 q2, r3
	cmp r3, #0
	blt .Lpos8_negative_low
	cmp r12, #0
	beq .Lpos8_p0
	bgt .Lpos8_p1
	cmn r12, #1
	beq .Lpos8_pm1
	b .Lpos8_pm2
.Lpos8_negative_low:
	cmp r12, #0
	beq .Lpos8_n0
	bgt .Lpos8_n1
	cmn r12, #1
	beq .Lpos8_nm1
	b .Lpos8_nm2
	NTRU_TWIDDLE_LOOP .Lpos8_p0, 0, 0
	NTRU_TWIDDLE_LOOP .Lpos8_p1, 1, 0
	NTRU_TWIDDLE_LOOP .Lpos8_pm1, -1, 0
	NTRU_TWIDDLE_LOOP .Lpos8_pm2, -2, 0
	NTRU_TWIDDLE_LOOP .Lpos8_n0, 0, 1
	NTRU_TWIDDLE_LOOP .Lpos8_n1, 1, 1
	NTRU_TWIDDLE_LOOP .Lpos8_nm1, -1, 1
	NTRU_TWIDDLE_LOOP .Lpos8_nm2, -2, 1
	.size trial_twiddle_at_8, .-trial_twiddle_at_8
	.section .text.trial_twiddle_at_12,"ax",%progbits
	.balign 32
	.space 12, 0
	.global trial_twiddle_at_12
	.type trial_twiddle_at_12,%function
	.thumb_func
trial_twiddle_at_12:
	vpush {d8-d13}
	ldr r12, [r3, #4]
	ldr r3, [r3]
	vdup.32 q2, r3
	cmp r3, #0
	blt .Lpos12_negative_low
	cmp r12, #0
	beq .Lpos12_p0
	bgt .Lpos12_p1
	cmn r12, #1
	beq .Lpos12_pm1
	b .Lpos12_pm2
.Lpos12_negative_low:
	cmp r12, #0
	beq .Lpos12_n0
	bgt .Lpos12_n1
	cmn r12, #1
	beq .Lpos12_nm1
	b .Lpos12_nm2
	NTRU_TWIDDLE_LOOP .Lpos12_p0, 0, 0
	NTRU_TWIDDLE_LOOP .Lpos12_p1, 1, 0
	NTRU_TWIDDLE_LOOP .Lpos12_pm1, -1, 0
	NTRU_TWIDDLE_LOOP .Lpos12_pm2, -2, 0
	NTRU_TWIDDLE_LOOP .Lpos12_n0, 0, 1
	NTRU_TWIDDLE_LOOP .Lpos12_n1, 1, 1
	NTRU_TWIDDLE_LOOP .Lpos12_nm1, -1, 1
	NTRU_TWIDDLE_LOOP .Lpos12_nm2, -2, 1
	.size trial_twiddle_at_12, .-trial_twiddle_at_12
	.section .text.trial_twiddle_at_16,"ax",%progbits
	.balign 32
	.space 16, 0
	.global trial_twiddle_at_16
	.type trial_twiddle_at_16,%function
	.thumb_func
trial_twiddle_at_16:
	vpush {d8-d13}
	ldr r12, [r3, #4]
	ldr r3, [r3]
	vdup.32 q2, r3
	cmp r3, #0
	blt .Lpos16_negative_low
	cmp r12, #0
	beq .Lpos16_p0
	bgt .Lpos16_p1
	cmn r12, #1
	beq .Lpos16_pm1
	b .Lpos16_pm2
.Lpos16_negative_low:
	cmp r12, #0
	beq .Lpos16_n0
	bgt .Lpos16_n1
	cmn r12, #1
	beq .Lpos16_nm1
	b .Lpos16_nm2
	NTRU_TWIDDLE_LOOP .Lpos16_p0, 0, 0
	NTRU_TWIDDLE_LOOP .Lpos16_p1, 1, 0
	NTRU_TWIDDLE_LOOP .Lpos16_pm1, -1, 0
	NTRU_TWIDDLE_LOOP .Lpos16_pm2, -2, 0
	NTRU_TWIDDLE_LOOP .Lpos16_n0, 0, 1
	NTRU_TWIDDLE_LOOP .Lpos16_n1, 1, 1
	NTRU_TWIDDLE_LOOP .Lpos16_nm1, -1, 1
	NTRU_TWIDDLE_LOOP .Lpos16_nm2, -2, 1
	.size trial_twiddle_at_16, .-trial_twiddle_at_16
	.section .text.trial_twiddle_at_20,"ax",%progbits
	.balign 32
	.space 20, 0
	.global trial_twiddle_at_20
	.type trial_twiddle_at_20,%function
	.thumb_func
trial_twiddle_at_20:
	vpush {d8-d13}
	ldr r12, [r3, #4]
	ldr r3, [r3]
	vdup.32 q2, r3
	cmp r3, #0
	blt .Lpos20_negative_low
	cmp r12, #0
	beq .Lpos20_p0
	bgt .Lpos20_p1
	cmn r12, #1
	beq .Lpos20_pm1
	b .Lpos20_pm2
.Lpos20_negative_low:
	cmp r12, #0
	beq .Lpos20_n0
	bgt .Lpos20_n1
	cmn r12, #1
	beq .Lpos20_nm1
	b .Lpos20_nm2
	NTRU_TWIDDLE_LOOP .Lpos20_p0, 0, 0
	NTRU_TWIDDLE_LOOP .Lpos20_p1, 1, 0
	NTRU_TWIDDLE_LOOP .Lpos20_pm1, -1, 0
	NTRU_TWIDDLE_LOOP .Lpos20_pm2, -2, 0
	NTRU_TWIDDLE_LOOP .Lpos20_n0, 0, 1
	NTRU_TWIDDLE_LOOP .Lpos20_n1, 1, 1
	NTRU_TWIDDLE_LOOP .Lpos20_nm1, -1, 1
	NTRU_TWIDDLE_LOOP .Lpos20_nm2, -2, 1
	.size trial_twiddle_at_20, .-trial_twiddle_at_20
	.section .text.trial_twiddle_at_24,"ax",%progbits
	.balign 32
	.space 24, 0
	.global trial_twiddle_at_24
	.type trial_twiddle_at_24,%function
	.thumb_func
trial_twiddle_at_24:
	vpush {d8-d13}
	ldr r12, [r3, #4]
	ldr r3, [r3]
	vdup.32 q2, r3
	cmp r3, #0
	blt .Lpos24_negative_low
	cmp r12, #0
	beq .Lpos24_p0
	bgt .Lpos24_p1
	cmn r12, #1
	beq .Lpos24_pm1
	b .Lpos24_pm2
.Lpos24_negative_low:
	cmp r12, #0
	beq .Lpos24_n0
	bgt .Lpos24_n1
	cmn r12, #1
	beq .Lpos24_nm1
	b .Lpos24_nm2
	NTRU_TWIDDLE_LOOP .Lpos24_p0, 0, 0
	NTRU_TWIDDLE_LOOP .Lpos24_p1, 1, 0
	NTRU_TWIDDLE_LOOP .Lpos24_pm1, -1, 0
	NTRU_TWIDDLE_LOOP .Lpos24_pm2, -2, 0
	NTRU_TWIDDLE_LOOP .Lpos24_n0, 0, 1
	NTRU_TWIDDLE_LOOP .Lpos24_n1, 1, 1
	NTRU_TWIDDLE_LOOP .Lpos24_nm1, -1, 1
	NTRU_TWIDDLE_LOOP .Lpos24_nm2, -2, 1
	.size trial_twiddle_at_24, .-trial_twiddle_at_24
	.section .text.trial_twiddle_at_28,"ax",%progbits
	.balign 32
	.space 28, 0
	.global trial_twiddle_at_28
	.type trial_twiddle_at_28,%function
	.thumb_func
trial_twiddle_at_28:
	vpush {d8-d13}
	ldr r12, [r3, #4]
	ldr r3, [r3]
	vdup.32 q2, r3
	cmp r3, #0
	blt .Lpos28_negative_low
	cmp r12, #0
	beq .Lpos28_p0
	bgt .Lpos28_p1
	cmn r12, #1
	beq .Lpos28_pm1
	b .Lpos28_pm2
.Lpos28_negative_low:
	cmp r12, #0
	beq .Lpos28_n0
	bgt .Lpos28_n1
	cmn r12, #1
	beq .Lpos28_nm1
	b .Lpos28_nm2
	NTRU_TWIDDLE_LOOP .Lpos28_p0, 0, 0
	NTRU_TWIDDLE_LOOP .Lpos28_p1, 1, 0
	NTRU_TWIDDLE_LOOP .Lpos28_pm1, -1, 0
	NTRU_TWIDDLE_LOOP .Lpos28_pm2, -2, 0
	NTRU_TWIDDLE_LOOP .Lpos28_n0, 0, 1
	NTRU_TWIDDLE_LOOP .Lpos28_n1, 1, 1
	NTRU_TWIDDLE_LOOP .Lpos28_nm1, -1, 1
	NTRU_TWIDDLE_LOOP .Lpos28_nm2, -2, 1
	.size trial_twiddle_at_28, .-trial_twiddle_at_28
