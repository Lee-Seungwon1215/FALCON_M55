	.syntax unified
	.thumb

/* Test-only fused, exact Q32 butterflies. r0={xr,xi,yr,yi}, r1=count,
 * r2=public fxc twiddle, r3=inverse (0 or 1). Count>=4 is divisible by 4.
 * Twiddles are the ORIGINAL GM_TAB roots for logn<=10 (conjugated inverse).
 * No secret coefficient range is assumed. The public case table covers all
 * 511 used roots in each direction; unsupported public constants trap.
 * This keeps the original THREE separately truncated complex products and
 * original per-layer rounded half, including signed 64-bit wraparound.
 * Private scratch is 64 bytes; total callee frame is 176 bytes.
 */
	.macro F_ADD dl,dh,al,ah,bl,bh
	vadd.i32 \dl,\al,\bl
	vcmp.u32 hi,\bl,\dl
	vadd.i32 \dh,\ah,\bh
	vpst
	vaddt.i32 \dh,\dh,r12
	.endm
	.macro F_SUB dl,dh,al,ah,bl,bh
	vcmp.u32 hi,\bl,\al
	vsub.i32 \dl,\al,\bl
	vsub.i32 \dh,\ah,\bh
	vpst
	vsubt.i32 \dh,\dh,r12
	.endm
	.macro F_HALF lo,hi,tmp
	vadd.i32 \lo,\lo,r12
	vcmp.i32 eq,\lo,r3
	vpst
	vaddt.i32 \hi,\hi,r12
	vshl.i32 \tmp,\hi,#31
	vshr.u32 \lo,\lo,#1
	vorr \lo,\lo,\tmp
	vshr.s32 \hi,\hi,#1
	.endm
	.macro F_PREP xp,yp
	vld20.32 {q0,q1},[\xp]
	vld21.32 {q0,q1},[\xp]
	vld20.32 {q2,q3},[\yp]
	vld21.32 {q2,q3},[\yp]
	F_ADD q4,q5,q0,q1,q2,q3
	F_SUB q6,q7,q0,q1,q2,q3
	F_HALF q4,q5,q0
	F_HALF q6,q7,q0
	vst20.32 {q4,q5},[\xp]
	vst21.32 {q4,q5},[\xp]
	vst20.32 {q6,q7},[\yp]
	vst21.32 {q6,q7},[\yp]
	.endm
	.macro F_MUL high,negative,root
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
	F_ADD q3,q4,q3,q4,q0,q1
	.elseif \high == -1
	F_SUB q3,q4,q3,q4,q0,q1
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
	.macro F_MIX xp,yp,lo,hi
	vld20.32 {q0,q1},[\xp]
	vld21.32 {q0,q1},[\xp]
	F_ADD q2,q3,q0,q1,\lo,\hi
	F_SUB q0,q1,q0,q1,\lo,\hi
	vst20.32 {q2,q3},[\xp]
	vst21.32 {q2,q3},[\xp]
	vst20.32 {q0,q1},[\yp]
	vst21.32 {q0,q1},[\yp]
	.endm
	.macro F_CASE name,inverse,rh,rn,ih,in,sh,sn
\name:
1:
	.if \inverse
	F_PREP r4,r6
	F_PREP r5,r7
	.endif
	/* Save wrap(re+im), then compute z0. */
	vld20.32 {q0,q1},[r6]
	vld21.32 {q0,q1},[r6]
	vld20.32 {q2,q3},[r7]
	vld21.32 {q2,q3},[r7]
	F_ADD q4,q5,q0,q1,q2,q3
	vstrw.32 q4,[sp,#0]
	vstrw.32 q5,[sp,#16]
	F_MUL \rh,\rn,r8
	vstrw.32 q3,[sp,#32]
	vstrw.32 q4,[sp,#48]
	/* z1; keep z0-z1 live, and spill only z0+z1. */
	vld20.32 {q0,q1},[r7]
	vld21.32 {q0,q1},[r7]
	F_MUL \ih,\in,r9
	vldrw.32 q6,[sp,#32]
	vldrw.32 q7,[sp,#48]
	F_ADD q0,q1,q6,q7,q3,q4
	F_SUB q6,q7,q6,q7,q3,q4
	vstrw.32 q0,[sp,#32]
	vstrw.32 q1,[sp,#48]
	/* z2 - (z0+z1), preserving the real product in q6/q7. */
	vldrw.32 q0,[sp,#0]
	vldrw.32 q1,[sp,#16]
	F_MUL \sh,\sn,r10
	vldrw.32 q0,[sp,#32]
	vldrw.32 q1,[sp,#48]
	F_SUB q3,q4,q3,q4,q0,q1
	vmov q5,q4
	vmov q4,q3
	.if \inverse
	vst20.32 {q6,q7},[r6]
	vst21.32 {q6,q7},[r6]
	vst20.32 {q4,q5},[r7]
	vst21.32 {q4,q5},[r7]
	.else
	F_MIX r4,r6,q6,q7
	F_MIX r5,r7,q4,q5
	.endif
	add r4,#32
	add r5,#32
	add r6,#32
	add r7,#32
	subs r11,#4
	bne 1b
	b .Lfused_return
	.endm

	.section .text.trial_fused_butterfly,"ax",%progbits
	.balign 4
	.global trial_fused_butterfly
	.type trial_fused_butterfly,%function
	.thumb_func
trial_fused_butterfly:
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

	F_CASE .Lfused_0_18,0,-1,0,0,0,-1,0
	F_CASE .Lfused_0_26,0,-1,0,0,0,-1,1
	F_CASE .Lfused_0_30,0,-1,0,0,1,-1,1
	F_CASE .Lfused_0_38,0,-1,0,0,1,0,0
	F_CASE .Lfused_0_39,0,-1,1,0,1,0,0
	F_CASE .Lfused_0_47,0,-1,1,0,1,0,1
	F_CASE .Lfused_0_49,0,0,1,0,0,1,0
	F_CASE .Lfused_0_52,0,0,0,0,1,1,0
	F_CASE .Lfused_0_53,0,0,1,0,1,1,0
	F_CASE .Lfused_1_10,1,-1,0,-1,0,-2,1
	F_CASE .Lfused_1_11,1,-1,1,-1,0,-2,1
	F_CASE .Lfused_1_14,1,-1,0,-1,1,-2,1
	F_CASE .Lfused_1_16,1,0,0,-1,0,-1,0
	F_CASE .Lfused_1_24,1,0,0,-1,0,-1,1
	F_CASE .Lfused_1_25,1,0,1,-1,0,-1,1
	F_CASE .Lfused_1_33,1,0,1,-1,0,0,0
	F_CASE .Lfused_1_37,1,0,1,-1,1,0,0
	F_CASE .Lfused_1_45,1,0,1,-1,1,0,1

.Lfused_return:
	add sp,#76
	vpop {d8-d15}
	pop {r4-r11,pc}
.Lfused_bad_root:
	udf #0
	.size trial_fused_butterfly,.-trial_fused_butterfly

	.section .rodata.trial_fused_cases,"a",%progbits
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
