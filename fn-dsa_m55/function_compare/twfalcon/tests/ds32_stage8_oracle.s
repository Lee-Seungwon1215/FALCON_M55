/* Test-only stage-8 oracle: direct-array 52-access spans. */
	.syntax unified
	.thumb
	.arch armv8.1-m.main
	.arch_extension mve.fp
	.fpu fpv5-d16
	.text
	.align 2
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

	/* DS_MUL_Q with independent hi/lo source addresses (SoA or scratch). */
	.macro DS_MUL_MEM_Q outoff, ah, al, bhi, blo
	vldrw.u32 q0, [\ah]
	vmul.f32 q2, q0, \bhi
	vneg.f32 q3, q2
	vfma.f32 q3, q0, \bhi
	vfma.f32 q3, q0, \blo
	vldrw.u32 q0, [\al]
	vfma.f32 q3, q0, \bhi
	vadd.f32 q0, q2, q3
	vsub.f32 q1, q0, q2
	vsub.f32 q3, q3, q1
	vstrw.u32 q0, [sp, #\outoff]
	vstrw.u32 q3, [sp, #(\outoff + 16)]
	.endm

	/*
	 * Span variants: original SoA coefficients are read/written directly.
	 * q4..q7 retain the complex twiddle; r4..r7 track coefficient low planes.
	 * Only 128 bytes of temporary products/differences are needed. Per block:
	 * 24 coefficient + 28 scratch vector accesses, formerly 16 + 68.
	 * blocks >= 1, and the four coefficient regions must not overlap.
	 */
	.global ds32_stage8_fwd4_span
	.type ds32_stage8_fwd4_span, %function
	.thumb_func
ds32_stage8_fwd4_span:
	stmdb sp!, {r4-r10, lr}
	ldr r4, [sp, #32]
	ldr r5, [sp, #36]
	ldr r8, [sp, #40]
	ldr r9, [sp, #44]
	vpush {d8-d15}
	sub sp, sp, #128
	vldrw.u32 q4, [r4, #0]
	vldrw.u32 q5, [r4, #16]
	vldrw.u32 q6, [r5, #0]
	vldrw.u32 q7, [r5, #16]
	add.w r4, r0, r8
	add.w r5, r1, r8
	add.w r6, r2, r8
	add.w r7, r3, r8
1:
	/* Complete every use of y before either output overwrites it. */
	DS_MUL_MEM_Q 0,  r2, r6, q4, q5
	DS_MUL_MEM_Q 32, r3, r7, q6, q7
	DS_MUL_MEM_Q 64, r2, r6, q6, q7
	DS_MUL_MEM_Q 96, r3, r7, q4, q5
	DS_ADDSUB_MEM "sp, #0", "sp, #16", "sp, #0", "sp, #16", "sp, #32", "sp, #48", 1
	DS_ADDSUB_MEM "sp, #64", "sp, #80", "sp, #64", "sp, #80", "sp, #96", "sp, #112"
	/* Difference first: x must remain live until its sum is computed. */
	DS_ADDSUB_MEM r2, r6, r0, r4, "sp, #0", "sp, #16", 1
	DS_ADDSUB_MEM r0, r4, r0, r4, "sp, #0", "sp, #16"
	DS_ADDSUB_MEM r3, r7, r1, r5, "sp, #64", "sp, #80", 1
	DS_ADDSUB_MEM r1, r5, r1, r5, "sp, #64", "sp, #80"
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
	add sp, sp, #128
	vpop {d8-d15}
	ldmia sp!, {r4-r10, pc}
	.size ds32_stage8_fwd4_span, .-ds32_stage8_fwd4_span

	.global ds32_stage8_inv4_span
	.type ds32_stage8_inv4_span, %function
	.thumb_func
ds32_stage8_inv4_span:
	stmdb sp!, {r4-r10, lr}
	ldr r4, [sp, #32]
	ldr r5, [sp, #36]
	ldr r8, [sp, #40]
	ldr r9, [sp, #44]
	vpush {d8-d15}
	sub sp, sp, #128
	vldrw.u32 q4, [r4, #0]
	vldrw.u32 q5, [r4, #16]
	vldrw.u32 q6, [r5, #0]
	vldrw.u32 q7, [r5, #16]
	add.w r4, r0, r8
	add.w r5, r1, r8
	add.w r6, r2, r8
	add.w r7, r3, r8
1:
	/* Preserve each difference before writing the sum over x. */
	DS_ADDSUB_MEM "sp, #0", "sp, #16", r0, r4, r2, r6, 1
	DS_ADDSUB_MEM r0, r4, r0, r4, r2, r6
	DS_ADDSUB_MEM "sp, #32", "sp, #48", r1, r5, r3, r7, 1
	DS_ADDSUB_MEM r1, r5, r1, r5, r3, r7
	/* Finish one component, then reuse its two product slots. */
	DS_MUL_MEM_Q 64, "sp, #0", "sp, #16", q4, q5
	DS_MUL_MEM_Q 96, "sp, #32", "sp, #48", q6, q7
	DS_ADDSUB_MEM r2, r6, "sp, #64", "sp, #80", "sp, #96", "sp, #112", 1
	DS_MUL_MEM_Q 64, "sp, #0", "sp, #16", q6, q7
	DS_MUL_MEM_Q 96, "sp, #32", "sp, #48", q4, q5
	DS_ADDSUB_MEM r3, r7, "sp, #64", "sp, #80", "sp, #96", "sp, #112"
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
	add sp, sp, #128
	vpop {d8-d15}
	ldmia sp!, {r4-r10, pc}
	.size ds32_stage8_inv4_span, .-ds32_stage8_inv4_span

	.section .note.GNU-stack,"",%progbits
