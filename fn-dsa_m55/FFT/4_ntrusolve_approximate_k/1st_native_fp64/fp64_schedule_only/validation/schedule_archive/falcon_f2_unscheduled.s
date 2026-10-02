/* Offline GCC 15.2.1 extraction; exact two-layer FP64 FFT. */
.syntax unified
.arch armv8.1-m.main
.fpu fpv5-d16
.thumb
	.section	.text.fp64e_cmul_prepared,"ax",%progbits
	.align	1
	.p2align 2,,3
	.syntax unified
	.thumb
	.thumb_func
	.type	fp64e_cmul_prepared, %function
fp64e_cmul_prepared:
	vcvt.u32.f64	s13, d0
	vmov	r2, s13	@ int
	vcvt.u32.f64	s13, d2
	lsrs	r2, r2, #31
	vmov	r3, s13	@ int
	vmov	s13, r2	@ int
	vpush.64	{d8, d9, d10, d11, d12, d13, d14, d15}
	vcvt.f64.s32	d6, s13
	sub	sp, sp, #208
	lsrs	r3, r3, #31
	vstr.64	d6, [sp, #80]
	vmov	s13, r3	@ int
	vmov.f64	d15, d3
.LBI636:
	vmov.f64	d13, d1
	vldr.64	d3, [r0, #24]
.LBI638:
	vcvt.f64.s32	d5, s13
	vadd.f64	d14, d1, d15
	vmul.f64	d9, d13, d3
	vstr.64	d5, [sp, #96]
	vmul.f64	d3, d0, d3
	vldr.64	d5, .L4
	vcvt.u32.f64	s6, d3
	vmul.f64	d8, d14, d5
	vldr.64	d1, [r0, #64]
	vcvt.u32.f64	s7, d8
	vcvt.f64.u32	d8, s6
	vstr.64	d8, [sp, #40]
	vmul.f64	d8, d15, d1
	vmul.f64	d1, d2, d1
	vcvt.u32.f64	s2, d1
	vldr.64	d6, [r0, #56]
	vcvt.f64.u32	d10, s2
	vldr.64	d4, [r0, #16]
	vstr.64	d10, [sp, #32]
	vmul.f64	d10, d15, d6
	vmul.f64	d1, d13, d4
	vcvt.u32.f64	s20, d10
	vcvt.u32.f64	s18, d9
	vldr.64	d7, .L4+8
	vcvt.f64.u32	d12, s20
	vcvt.f64.u32	d9, s18
	vcvt.f64.u32	d3, s7
	vadd.f64	d10, d0, d2
	vcvt.u32.f64	s2, d1
	vmls.f64	d14, d3, d7
	vcvt.f64.u32	d11, s2
	vadd.f64	d10, d10, d3
	vnmul.f64	d1, d9, d7
	vldr.64	d3, [r0, #8]
	.syntax unified
	vfma.f64 d1, d13, d3
	.thumb
	.syntax unified
	vadd.f64	d1, d1, d7
	vmul.f64	d1, d1, d5
	vcvt.u32.f64	s16, d8
	vcvt.u32.f64	s2, d1
	vcvt.f64.u32	d8, s16
	vcvt.f64.u32	d1, s2
	vstr.64	d13, [sp, #16]
	vnmul.f64	d3, d8, d7
	vadd.f64	d13, d1, d9
	vmul.f64	d1, d10, d5
	vldr.64	d9, [r0, #48]
	.syntax unified
	vfma.f64 d3, d15, d9
	.thumb
	.syntax unified
	vadd.f64	d3, d3, d7
	vcvt.u32.f64	s2, d1
	vmul.f64	d3, d3, d5
	vcvt.f64.u32	d1, s2
	vcvt.u32.f64	s6, d3
	vmls.f64	d10, d1, d7
	vcvt.f64.u32	d3, s6
	vstr.64	d14, [sp]
	vadd.f64	d14, d3, d8
	vcvt.u32.f64	s7, d10
	vmul.f64	d4, d0, d4
	vmov	r3, s7	@ int
	vmul.f64	d6, d2, d6
	vcvt.u32.f64	s8, d4
	lsrs	r3, r3, #31
	vmov	s7, r3	@ int
	vcvt.u32.f64	s12, d6
	vcvt.f64.u32	d4, s8
	vldr.64	d8, [r0]
	vstr.64	d10, [sp, #8]
	vnmul.f64	d1, d11, d7
	vldr.64	d10, [sp, #16]
	.syntax unified
	vfma.f64 d1, d10, d8
	.thumb
	.syntax unified
	vnmul.f64	d4, d4, d7
	.syntax unified
	vfma.f64 d4, d0, d8
	.thumb
	.syntax unified
	vcvt.f64.s32	d3, s7
	vadd.f64	d4, d4, d7
	vldr.64	d8, [sp, #40]
	vcvt.f64.u32	d6, s12
	vldr.64	d10, [r0, #8]
	vstr.64	d3, [sp, #104]
	vstr.64	d4, [sp, #64]
	vnmul.f64	d3, d12, d7
	vldr.64	d4, [r0, #40]
	.syntax unified
	vfma.f64 d3, d15, d4
	.thumb
	.syntax unified
	vnmul.f64	d6, d6, d7
.LBI663:
	.syntax unified
	vfma.f64 d6, d2, d4
	.thumb
	.syntax unified
	vnmul.f64	d8, d8, d7
	.syntax unified
	vfma.f64 d8, d0, d10
	.thumb
	.syntax unified
	vadd.f64	d4, d3, d7
	vldr.64	d10, [sp, #32]
	vadd.f64	d3, d6, d7
	vldr.64	d9, [r0, #104]
	vldr.64	d0, [r0, #48]
	vldr.64	d6, [sp, #8]
	vstr.64	d3, [sp, #56]
	vnmul.f64	d3, d10, d7
	.syntax unified
	vfma.f64 d3, d2, d0
	.thumb
	.syntax unified
	vldr.64	d2, [sp]
	vmul.f64	d10, d9, d2
	vmul.f64	d9, d9, d6
	vadd.f64	d1, d1, d7
	vcvt.u32.f64	s18, d9
	vmul.f64	d0, d1, d5
	vcvt.f64.u32	d9, s18
	vcvt.u32.f64	s0, d0
	vstr.64	d9, [sp, #48]
	vmul.f64	d9, d4, d5
	vcvt.f64.u32	d0, s0
.LBI651:
	vcvt.u32.f64	s18, d9
	vmls.f64	d1, d0, d7
	vcvt.f64.u32	d9, s18
	vadd.f64	d0, d11, d0
	vmov.f64	d11, d4
	vmls.f64	d11, d9, d7
	vadd.f64	d8, d8, d7
	vstr.64	d1, [sp, #72]
	vstr.64	d11, [sp, #88]
	vldr.64	d11, [r0, #96]
	vmul.f64	d4, d11, d2
	vmul.f64	d2, d8, d5
	vcvt.u32.f64	s4, d2
	vldr.64	d1, [sp, #40]
	vcvt.f64.u32	d2, s4
.LBI689:
	vcvt.u32.f64	s8, d4
	vmls.f64	d8, d2, d7
	vadd.f64	d2, d1, d2
	vmov.f64	d1, #1.0e+0
	vadd.f64	d3, d3, d7
	vmul.f64	d6, d11, d6
	vadd.f64	d9, d12, d9
	vcvt.f64.u32	d11, s8
	vldr.64	d12, [sp, #72]
	vsub.f64	d4, d13, d1
	vstr.64	d11, [sp, #24]
	vadd.f64	d4, d4, d12
	vmul.f64	d11, d3, d5
	vadd.f64	d12, d4, d8
	vcvt.u32.f64	s22, d11
	vsub.f64	d8, d14, d1
	vldr.64	d4, [sp, #88]
	vcvt.u32.f64	s20, d10
	vadd.f64	d8, d8, d4
	vcvt.f64.u32	d4, s22
	vcvt.f64.u32	d10, s20
	vmls.f64	d3, d4, d7
	vldr.64	d11, [sp]
	vsub.f64	d2, d2, d1
	vadd.f64	d8, d8, d3
	vldr.64	d13, [r0, #88]
	vnmul.f64	d3, d10, d7
	.syntax unified
	vfma.f64 d3, d11, d13
	.thumb
	.syntax unified
	vsub.f64	d0, d0, d1
	vadd.f64	d3, d3, d7
	vadd.f64	d0, d0, d2
	vmul.f64	d3, d3, d5
	vldr.64	d2, [sp, #32]
	vcvt.u32.f64	s12, d6
	vadd.f64	d4, d2, d4
	vcvt.u32.f64	s6, d3
	vsub.f64	d4, d4, d1
	vsub.f64	d9, d9, d1
	vldr.64	d2, [sp, #24]
	vcvt.f64.u32	d6, s12
	vcvt.f64.u32	d3, s6
	vadd.f64	d9, d9, d4
	vnmul.f64	d6, d6, d7
	vldr.64	d4, [r0, #80]
	vnmul.f64	d2, d2, d7
	.syntax unified
	vfma.f64 d2, d11, d4
	.thumb
	.syntax unified
	vadd.f64	d3, d3, d10
	vldr.64	d10, [sp, #8]
	.syntax unified
	vfma.f64 d6, d10, d4
	.thumb
	.syntax unified
	vldr.64	d4, [sp, #64]
	vmul.f64	d10, d4, d5
	vldr.64	d13, [sp, #56]
	vcvt.u32.f64	s20, d10
	vmul.f64	d11, d13, d5
	vcvt.f64.u32	d10, s20
	vcvt.u32.f64	s22, d11
	vmls.f64	d4, d10, d7
	vcvt.f64.u32	d11, s22
	vadd.f64	d4, d4, d0
	vmov.f64	d0, d13
	vadd.f64	d2, d2, d7
	vmls.f64	d0, d11, d7
	vldr.64	d14, [sp, #48]
	vldr.64	d11, [r0, #88]
	vldr.64	d10, [sp, #8]
	vadd.f64	d0, d0, d9
	vnmul.f64	d9, d14, d7
	.syntax unified
	vfma.f64 d9, d10, d11
	.thumb
	.syntax unified
	vmul.f64	d10, d2, d5
	vcvt.u32.f64	s23, d10
	vmul.f64	d10, d12, d5
	vcvt.u32.f64	s22, d10
	vcvt.f64.u32	d10, s23
	vsub.f64	d3, d3, d1
	vmls.f64	d2, d10, d7
	vadd.f64	d3, d3, d2
	vcvt.f64.u32	d2, s22
	vmov.f64	d11, d12
	vadd.f64	d9, d9, d7
	vmls.f64	d11, d2, d7
	vadd.f64	d4, d4, d2
	vmul.f64	d2, d8, d5
	vmul.f64	d12, d9, d5
	vcvt.u32.f64	s4, d2
	vcvt.u32.f64	s24, d12
	vcvt.f64.u32	d2, s4
	vldr.64	d13, [sp, #24]
	vmls.f64	d8, d2, d7
	vadd.f64	d0, d0, d2
	vcvt.f64.u32	d2, s24
	vadd.f64	d10, d13, d10
	vmls.f64	d9, d2, d7
	vadd.f64	d2, d14, d2
	vadd.f64	d3, d3, d9
	vsub.f64	d2, d2, d1
	vldr.64	d9, .L4+16
	vsub.f64	d10, d10, d1
	vldr.64	d12, [r0, #8]
	vadd.f64	d10, d10, d2
	vadd.f64	d4, d4, d9
	vldr.64	d2, [sp, #80]
	vadd.f64	d6, d6, d7
	vmls.f64	d4, d2, d12
	vadd.f64	d0, d0, d9
	vldr.64	d2, [sp, #96]
	vldr.64	d12, [r0, #48]
	vmls.f64	d0, d2, d12
	vmul.f64	d12, d6, d5
	vcvt.u32.f64	s24, d12
	vldr.64	d2, [r0, #32]
	vldr.64	d13, [sp, #16]
	vcvt.f64.u32	d12, s24
	vmls.f64	d4, d13, d2
.LBI732:
	vmls.f64	d6, d12, d7
	vldr.64	d2, [r0, #72]
	vadd.f64	d6, d6, d10
	vmls.f64	d0, d15, d2
	vmul.f64	d10, d4, d5
	vmul.f64	d2, d3, d5
	vcvt.u32.f64	s20, d10
	vcvt.u32.f64	s4, d2
	vcvt.f64.u32	d10, s20
	vcvt.f64.u32	d2, s4
	vmls.f64	d4, d10, d7
	vadd.f64	d6, d6, d2
	vmul.f64	d10, d0, d5
	vmls.f64	d3, d2, d7
	vadd.f64	d6, d6, d9
.LBI804:
.LBI806:
.LBI836:
.LBI818:
.LBI861:
.LBI910:
	vldr.64	d2, [sp, #104]
	vldr.64	d9, [r0, #88]
	vcvt.u32.f64	s20, d10
	vmls.f64	d6, d2, d9
	vcvt.f64.u32	d10, s20
	vadd.f64	d2, d8, d11
	vmls.f64	d0, d10, d7
	vmul.f64	d10, d2, d5
	vadd.f64	d9, d11, d7
	b	.L5
.L6:
	.align	3
.L4:
	.word	0
	.word	1039138816
	.word	0
	.word	1106247680
	.word	0
	.word	1107296256
.L5:
.LBI995:
.LBI997:
.LBI1055:
.LBI1072:
.LBI1089:
.LBI1057:
.LBI1105:
	vcvt.u32.f64	s20, d10
	vsub.f64	d9, d9, d8
	vcvt.f64.u32	d10, s20
	vldr.64	d8, [r0, #112]
	vldr.64	d11, [sp]
	vmls.f64	d2, d10, d7
	vmls.f64	d6, d11, d8
.LBI1157:
.LBI1384:
	vadd.f64	d3, d3, d7
	vadd.f64	d8, d0, d4
	vsub.f64	d3, d3, d2
	vadd.f64	d8, d8, d10
	vmul.f64	d2, d6, d5
	vadd.f64	d4, d4, d7
	vcvt.u32.f64	s4, d2
	vsub.f64	d0, d4, d0
	vmul.f64	d4, d8, d5
	vcvt.f64.u32	d2, s4
	vcvt.u32.f64	s8, d4
	vmls.f64	d6, d2, d7
	vcvt.f64.u32	d4, s8
	vadd.f64	d2, d6, d7
	vmls.f64	d8, d4, d7
	vmul.f64	d6, d9, d5
	vmul.f64	d4, d3, d5
	vsub.f64	d2, d2, d8
	vcvt.u32.f64	s12, d6
	vcvt.u32.f64	s8, d4
	vcvt.f64.u32	d6, s12
	vcvt.f64.u32	d4, s8
	vsub.f64	d0, d0, d1
	vsub.f64	d2, d2, d1
	vadd.f64	d0, d0, d6
.LBI1386:
.LBI1359:
.LBI1361:
.LBI1415:
	vadd.f64	d2, d2, d4
.LBI1417:
	vmov.f64	d1, d9
	vmls.f64	d1, d6, d7
	vmul.f64	d6, d0, d5
	vmul.f64	d5, d2, d5
	vcvt.u32.f64	s12, d6
	vcvt.u32.f64	s10, d5
	vcvt.f64.u32	d6, s12
	vcvt.f64.u32	d5, s10
	vmls.f64	d0, d6, d7
	vmls.f64	d3, d4, d7
	vmls.f64	d2, d5, d7
	add	sp, sp, #208
	vldm	sp!, {d8-d15}
	bx	lr
	.size	fp64e_cmul_prepared, .-fp64e_cmul_prepared
	.section	.text.fndsa_vect_FFT_fp64_exact,"ax",%progbits
	.align	1
	.p2align 2,,3
	.global	fndsa_vect_FFT_fp64_exact
	.syntax unified
	.thumb
	.thumb_func
	.type	fndsa_vect_FFT_fp64_exact, %function
fndsa_vect_FFT_fp64_exact:
	cmp	r0, #1
	bls	.L38
	push	{r4, r5, r6, r7, r8, r9, r10, fp, lr}
	mov	r7, r1
	movs	r1, #1
	vpush.64	{d8, d9, d10, d11, d12, d13, d14, d15}
	movs	r2, #16
	vldr.64	d9, .L41
	vldr.64	d8, .L41+8
	vmov.f64	d14, #1.0e+0
	mov	r4, r1
	subs	r3, r0, #1
	sub	sp, sp, #196
	str	r0, [sp, #36]
	lsls	r2, r2, r3
	lsl	r0, r1, r3
.L33:
	mov	r10, #16
	movs	r3, #1
	ldr	r6, .L41+16
	lsl	r10, r10, r4
	mov	r8, r0
	lsrs	r0, r0, #1
	add	r9, r7, r0, lsl #4
	str	r0, [sp, #20]
	str	r7, [sp, #32]
	add	r0, r10, r6
	mov	fp, r2
	mov	r10, r7
	movs	r7, #0
	lsl	r5, r3, r4
	add	r5, r5, r5, lsr #1
	add	r5, r6, r5, lsl #4
	strd	r5, r4, [sp, #24]
.L32:
.LBI2801:
	vldr.32	s15, [r0]	@ int
	vcvt.f64.u32	d1, s15
.LBI2803:
.LBI2807:
.LBI2583:
	vldr.32	s15, [r0, #8]	@ int
	vcvt.f64.u32	d4, s15
	vldr.32	s15, [r0, #4]	@ int
	vcvt.f64.u32	d2, s15
.LBI2596:
	vldr.32	s15, [r0, #12]	@ int
	ldr	r3, [r0, #4]
	vcvt.f64.u32	d3, s15
.LBI2605:
.LBI2585:
	lsrs	r3, r3, #31
	vmov	s12, r3	@ int
	vmov	r3, s15	@ int
	lsrs	r3, r3, #31
	vmov	s14, r3	@ int
	vadd.f64	d5, d1, d4
	vcvt.f64.s32	d7, s14
	vstr.64	d7, [sp, #144]
	vmul.f64	d7, d5, d9
	vcvt.u32.f64	s14, d7
	vadd.f64	d12, d2, d3
	vcvt.f64.u32	d7, s14
	vadd.f64	d12, d12, d7
.LBI2587:
	vmls.f64	d5, d7, d8
	vmul.f64	d7, d12, d9
	vcvt.u32.f64	s14, d7
	vcvt.f64.u32	d7, s14
	vmls.f64	d12, d7, d8
	vcvt.u32.f64	s14, d12
	ldr	r3, [sp, #20]
	vcvt.f64.s32	d6, s12
	adds	r1, r3, r7
	vmov	r3, s14	@ int
	lsrs	r3, r3, #31
	vstr.64	d6, [sp, #104]
	vmov	s14, r3	@ int
	vmul.f64	d6, d5, d9
.LBI2616:
	vmul.f64	d0, d1, d9
	vstr.64	d1, [sp, #80]
	vmul.f64	d10, d2, d9
	vmul.f64	d1, d4, d9
	vmul.f64	d11, d3, d9
	vstr.64	d6, [sp, #176]
	vcvt.f64.s32	d7, s14
	vmul.f64	d6, d12, d9
	cmp	r7, r1
	vstr.64	d2, [sp, #72]
	vstr.64	d3, [sp, #112]
	vstr.64	d4, [sp, #120]
	vstr.64	d0, [sp, #96]
	vstr.64	d1, [sp, #136]
	vstr.64	d10, [sp, #88]
	vstr.64	d11, [sp, #128]
	vstr.64	d5, [sp, #160]
	vstr.64	d12, [sp, #152]
	vstr.64	d6, [sp, #168]
	vstr.64	d7, [sp, #184]
	bcs	.L30
	mov	r5, r9
	mov	r4, r10
	add	r1, fp, r10
	add	r6, fp, r9
	str	r0, [sp, #16]
.L31:
	vldr.64	d0, [r5]
	vldr.64	d2, [r6]
	vldr.64	d3, [r6, #8]
	vldr.64	d1, [r5, #8]
	add	r0, sp, #72
	bl	fp64e_cmul_prepared
	vldr.64	d13, [r4, #8]
	vldr.64	d10, [r1]
	vldr.64	d12, [r1, #8]
	vldr.64	d11, [r4]
	vadd.f64	d7, d13, d1
	vadd.f64	d6, d12, d3
	vadd.f64	d5, d13, d8
	vadd.f64	d13, d10, d2
	vadd.f64	d10, d10, d8
	vadd.f64	d15, d11, d0
	vsub.f64	d10, d10, d2
	vmul.f64	d4, d6, d9
	vadd.f64	d12, d12, d8
	vadd.f64	d11, d11, d8
	vstr.64	d1, [sp, #48]
	vsub.f64	d1, d5, d1
	vmul.f64	d5, d7, d9
	vsub.f64	d11, d11, d0
	vstr.64	d0, [sp, #40]
	vstr.64	d2, [sp, #56]
	vcvt.u32.f64	s0, d4
	vsub.f64	d2, d12, d3
	vstr.64	d3, [sp, #64]
.LBI2668:
	vsub.f64	d3, d10, d14
	vcvt.u32.f64	s20, d5
	vmul.f64	d12, d2, d9
	vcvt.f64.u32	d10, s20
	vcvt.f64.u32	d0, s0
	vstr.64	d3, [sp, #8]
	vmul.f64	d3, d1, d9
	vsub.f64	d5, d11, d14
	vmls.f64	d7, d10, d8
	vmls.f64	d6, d0, d8
	vcvt.u32.f64	s8, d12
	vcvt.u32.f64	s6, d3
	vstr.64	d5, [sp]
	vadd.f64	d11, d13, d0
	vcvt.f64.u32	d3, s6
	vcvt.f64.u32	d4, s8
	vmov.f64	d12, d7
	vmov.f64	d13, d6
	vldr.64	d7, [sp]
	vldr.64	d6, [sp, #8]
	vadd.f64	d5, d15, d10
.LBI2670:
	vadd.f64	d7, d7, d3
	vadd.f64	d6, d6, d4
	vmul.f64	d0, d5, d9
	vmul.f64	d10, d11, d9
	vmls.f64	d1, d3, d8
	vmls.f64	d2, d4, d8
	vmul.f64	d3, d7, d9
	vmul.f64	d4, d6, d9
	vcvt.u32.f64	s0, d0
	vcvt.u32.f64	s20, d10
	vcvt.u32.f64	s6, d3
	vcvt.u32.f64	s8, d4
	vcvt.f64.u32	d0, s0
	vcvt.f64.u32	d10, s20
	vcvt.f64.u32	d3, s6
	vcvt.f64.u32	d4, s8
	vmls.f64	d5, d0, d8
	vmls.f64	d11, d10, d8
	vmls.f64	d7, d3, d8
	vmls.f64	d6, d4, d8
	adds	r4, r4, #16
	adds	r1, r1, #16
	adds	r5, r5, #16
	adds	r6, r6, #16
	cmp	r9, r4
	vstr.64	d12, [r4, #-8]
.LBI2692:
.LBI2694:
	vstr.64	d5, [r4, #-16]
	vstr.64	d11, [r1, #-16]
	vstr.64	d13, [r1, #-8]
.LBI2641:
.LBI2643:
	vstr.64	d1, [r5, #-8]
.LBI2718:
.LBI2720:
	vstr.64	d7, [r5, #-16]
	vstr.64	d6, [r6, #-16]
	vstr.64	d2, [r6, #-8]
	bne	.L31
	ldr	r0, [sp, #16]
.L30:
	ldr	r3, [sp, #24]
	adds	r0, r0, #16
	cmp	r3, r0
	add	r7, r7, r8
	add	r10, r10, r8, lsl #4
	add	r9, r9, r8, lsl #4
	bne	.L32
	ldr	r4, [sp, #28]
	ldr	r3, [sp, #36]
	adds	r4, r4, #1
	cmp	r3, r4
	mov	r2, fp
	ldr	r0, [sp, #20]
	ldr	r7, [sp, #32]
	bne	.L33
	add	sp, sp, #196
	vldm	sp!, {d8-d15}
	pop	{r4, r5, r6, r7, r8, r9, r10, fp, pc}
.L38:
	bx	lr
.L42:
	.align	3
.L41:
	.word	0
	.word	1039138816
	.word	0
	.word	1106247680
	.word	fndsa_kgen_GM_TAB
	.size	fndsa_vect_FFT_fp64_exact, .-fndsa_vect_FFT_fp64_exact
	.section	.text.fndsa_vect_iFFT_fp64_exact,"ax",%progbits
	.align	1
	.p2align 2,,3
	.global	fndsa_vect_iFFT_fp64_exact
	.syntax unified
	.thumb
	.thumb_func
	.type	fndsa_vect_iFFT_fp64_exact, %function
fndsa_vect_iFFT_fp64_exact:
	push	{r4, r5, r6, r7, r8, r9, r10, fp, lr}
	vpush.64	{d8, d9, d10, d11, d12, d13, d14, d15}
	subs	r5, r0, #1
	sub	sp, sp, #188
	beq	.L43
	movs	r3, #16
	mov	lr, #1
	vldr.64	d14, .L56
	vldr.64	d15, .L56+8
	vldr.64	d9, .L56+16
	lsl	ip, r3, r5
.L48:
	mov	r2, lr
	movs	r3, #1
	mov	r8, #16
	strd	r2, r5, [sp, #20]
	add	r7, r1, r2, lsl #4
	vmov.f64	d13, #1.0e+0
	mov	r2, r1
	mov	fp, #0
	mov	r9, ip
	ldr	r0, .L56+32
	lsls	r3, r3, r5
	add	r3, r3, r3, lsr #1
	lsl	lr, lr, #1
	lsl	r8, r8, r5
	add	r3, r0, r3, lsl #4
	add	r10, r8, r0
	str	r3, [sp, #16]
	str	lr, [sp, #12]
	lsl	r8, lr, #4
	str	r1, [sp, #28]
.L47:
.LBI3340:
	vldr.32	s15, [r10, #8]	@ int
	ldr	r3, [r10, #4]
	vcvt.f64.u32	d4, s15
.LBI3349:
	lsrs	r3, r3, #31
	vmov	s6, r3	@ int
	vsub.f64	d4, d14, d4
	vcvt.f64.s32	d3, s6
	vldr.32	s15, [r10, #12]	@ int
	vstr.64	d3, [sp, #96]
	vcvt.f64.u32	d7, s15
	vmul.f64	d3, d4, d15
	vsub.f64	d7, d14, d7
	vcvt.u32.f64	s6, d3
	vldr.32	s13, [r10]	@ int
	vcvt.f64.u32	d3, s6
	vsub.f64	d7, d7, d13
	vcvt.f64.u32	d5, s13
.LBI3342:
.LBI2916:
.LBI2917:
	vadd.f64	d7, d7, d3
.LBI2919:
	vldr.32	s13, [r10, #4]	@ int
	vmls.f64	d4, d3, d14
	vcvt.f64.u32	d6, s13
	vmul.f64	d3, d7, d15
	vmul.f64	d2, d6, d15
	vmul.f64	d1, d5, d15
	vstr.64	d5, [sp, #72]
	vcvt.u32.f64	s6, d3
	vadd.f64	d5, d4, d5
	vcvt.f64.u32	d3, s6
	vstr.64	d2, [sp, #80]
	vstr.64	d4, [sp, #112]
	vmul.f64	d2, d4, d15
	vmul.f64	d4, d5, d15
	vmls.f64	d7, d3, d14
	vcvt.u32.f64	s8, d4
	vcvt.u32.f64	s7, d7
	vcvt.f64.u32	d4, s8
	vstr.64	d6, [sp, #64]
	vadd.f64	d6, d7, d6
	ldr	r3, [sp, #20]
	vstr.64	d7, [sp, #104]
	add	r1, r3, fp
	vmov	r3, s7	@ int
	vmul.f64	d3, d7, d15
	vadd.f64	d7, d6, d4
	vmul.f64	d6, d7, d15
	vcvt.u32.f64	s12, d6
	vcvt.f64.u32	d6, s12
	vmls.f64	d7, d6, d14
	vcvt.u32.f64	s13, d7
	lsrs	r3, r3, #31
	vmls.f64	d5, d4, d14
	vmov	s8, r3	@ int
	vmov	r3, s13	@ int
	lsrs	r3, r3, #31
	vmul.f64	d6, d7, d15
	vstr.64	d7, [sp, #144]
	vmov	s14, r3	@ int
	vstr.64	d2, [sp, #128]
	vcvt.f64.s32	d4, s8
	vmul.f64	d2, d5, d15
	vcvt.f64.s32	d7, s14
	cmp	fp, r1
	vstr.64	d1, [sp, #88]
.LBI3369:
.LBI3371:
.LBI3395:
.LBI3382:
.LBI3384:
	vstr.64	d3, [sp, #120]
.LBI3411:
	vstr.64	d5, [sp, #152]
	vstr.64	d4, [sp, #136]
	vstr.64	d2, [sp, #168]
	vstr.64	d6, [sp, #160]
	vstr.64	d7, [sp, #176]
	bcs	.L45
	mov	r6, r7
	mov	r1, r2
	add	r5, r9, r2
	add	r4, r9, r7
	str	r2, [sp, #8]
.L46:
	vldr.64	d10, [r1, #8]
	vldr.64	d7, [r6, #8]
	vadd.f64	d0, d10, d14
	vldr.64	d12, [r1]
	vadd.f64	d10, d10, d7
	vsub.f64	d7, d0, d7
	vldr.64	d3, [r6]
	vadd.f64	d1, d12, d14
	vmul.f64	d2, d7, d15
	vadd.f64	d12, d3, d12
	vcvt.u32.f64	s4, d2
	vsub.f64	d3, d1, d3
	vcvt.f64.u32	d2, s4
	vsub.f64	d3, d3, d13
	vadd.f64	d3, d3, d2
	vmls.f64	d7, d2, d14
	vmul.f64	d1, d3, d15
	vadd.f64	d7, d7, d13
	vcvt.u32.f64	s2, d1
	vldr.64	d11, [r5, #8]
	vmul.f64	d2, d7, d15
	vcvt.f64.u32	d1, s2
	vldr.64	d5, [r4, #8]
	vcvt.u32.f64	s1, d2
	vmls.f64	d3, d1, d14
	vadd.f64	d2, d11, d14
	vldr.64	d4, .L56+24
	vadd.f64	d11, d5, d11
	vsub.f64	d2, d2, d5
	vadd.f64	d3, d3, d4
	vcvt.f64.u32	d5, s1
	vldr.64	d8, [r4]
	vldr.64	d6, [r5]
.LBI3007:
.LBI3009:
.LBI3053:
.LBI3055:
	vadd.f64	d3, d3, d5
	vadd.f64	d4, d6, d14
	vmul.f64	d0, d3, d15
	vadd.f64	d6, d6, d8
	vmls.f64	d7, d5, d14
.LBI3057:
	vmul.f64	d5, d2, d15
	vstr.64	d6, [sp]
	vcvt.u32.f64	s0, d0
	vmov.f64	d6, #5.0e-1
	vcvt.u32.f64	s10, d5
	vmul.f64	d7, d7, d6
	vcvt.f64.u32	d0, s0
	vsub.f64	d6, d4, d8
	vcvt.f64.u32	d5, s10
	vmls.f64	d3, d0, d14
	vsub.f64	d6, d6, d13
	vmls.f64	d2, d5, d14
	vadd.f64	d6, d6, d5
	vcvt.u32.f64	s11, d3
	vcvt.u32.f64	s14, d7
	vadd.f64	d2, d2, d13
	vmov	r3, s11	@ int
	vcvt.f64.u32	d1, s14
.LBI3109:
.LBI3111:
.LBI3174:
.LBI3176:
	vmul.f64	d7, d2, d15
	lsrs	r2, r3, #31
	vcvt.u32.f64	s7, d7
	vmov	s14, r2	@ int
	lsrs	r2, r3, #1
	vmov	s0, r2	@ int
	vmul.f64	d4, d6, d15
	vcvt.f64.s32	d7, s14
	vcvt.f64.s32	d0, s0
	and	r3, r3, #1
	vmla.f64	d0, d7, d9
	vcvt.u32.f64	s8, d4
	vmov	s15, r3	@ int
	vcvt.f64.u32	d4, s8
	vcvt.f64.s32	d7, s15
	vmls.f64	d6, d4, d14
	vmla.f64	d1, d7, d9
	vldr.64	d7, .L56+24
	vcvt.f64.u32	d4, s7
	vadd.f64	d6, d6, d7
	vadd.f64	d7, d6, d4
	vmul.f64	d5, d10, d15
	vmls.f64	d2, d4, d14
.LBI3178:
	vmul.f64	d4, d7, d15
	vcvt.u32.f64	s10, d5
	vcvt.u32.f64	s8, d4
	vcvt.f64.u32	d5, s10
	vmov.f64	d6, #5.0e-1
	vcvt.f64.u32	d4, s8
	vmul.f64	d2, d2, d6
	vadd.f64	d6, d12, d5
	vmls.f64	d7, d4, d14
	vmul.f64	d8, d6, d15
	vcvt.u32.f64	s4, d2
	vmls.f64	d10, d5, d14
	vcvt.u32.f64	s15, d7
	vadd.f64	d5, d10, d13
	vcvt.f64.u32	d3, s4
	vcvt.u32.f64	s4, d8
	vmov	r3, s15	@ int
	vcvt.f64.u32	d2, s4
	vmul.f64	d4, d5, d15
.LBI3026:
.LBI3028:
.LBI2951:
.LBI2953:
	lsrs	r2, r3, #31
	vmov	s16, r2	@ int
	lsrs	r2, r3, #1
	vmls.f64	d6, d2, d14
	vcvt.u32.f64	s8, d4
	vmov	s4, r2	@ int
	vldr.64	d7, .L56+24
	vcvt.f64.u32	d4, s8
	vcvt.f64.s32	d8, s16
	vcvt.f64.s32	d2, s4
	vadd.f64	d6, d6, d7
	vmla.f64	d2, d8, d9
	vmov.f64	d10, #5.0e-1
	vmul.f64	d8, d11, d15
	vmls.f64	d5, d4, d14
	vadd.f64	d6, d6, d4
.LBI2955:
	and	r3, r3, #1
	vmul.f64	d5, d5, d10
	vmov	s15, r3	@ int
	vcvt.u32.f64	s16, d8
	vmul.f64	d4, d6, d15
	vcvt.f64.u32	d8, s16
	vcvt.u32.f64	s20, d5
	vcvt.f64.s32	d7, s15
	vldr.64	d5, [sp]
	vcvt.u32.f64	s8, d4
	vmla.f64	d3, d7, d9
	vadd.f64	d7, d5, d8
	vmov.f64	d5, d11
	vcvt.f64.u32	d4, s8
	vmls.f64	d5, d8, d14
	vmul.f64	d12, d7, d15
	vmls.f64	d6, d4, d14
	vadd.f64	d5, d5, d13
	vcvt.u32.f64	s24, d12
	vcvt.u32.f64	s13, d6
	vmul.f64	d4, d5, d15
	vcvt.f64.u32	d12, s24
	vmov	r3, s13	@ int
	vcvt.u32.f64	s8, d4
	vldr.64	d6, .L56+24
	vmls.f64	d7, d12, d14
	lsrs	r2, r3, #31
	vcvt.f64.u32	d11, s20
	vmov	s20, r2	@ int
	lsrs	r2, r3, #1
	and	r3, r3, #1
	vcvt.f64.u32	d4, s8
	vadd.f64	d7, d7, d6
	vmov	s13, r3	@ int
	vadd.f64	d7, d7, d4
	vcvt.f64.s32	d6, s13
	vmla.f64	d11, d6, d9
	vmul.f64	d6, d7, d15
	vcvt.u32.f64	s12, d6
	vcvt.f64.u32	d6, s12
	vmov	s16, r2	@ int
	vmls.f64	d7, d6, d14
	vcvt.f64.s32	d10, s20
	vcvt.f64.s32	d8, s16
	vcvt.u32.f64	s15, d7
	vmls.f64	d5, d4, d14
	b	.L57
.L58:
	.align	3
.L56:
	.word	0
	.word	1106247680
	.word	0
	.word	1039138816
	.word	0
	.word	1105199104
	.word	0
	.word	0
	.word	fndsa_kgen_GM_TAB
.L57:
	vmla.f64	d8, d10, d9
	vmov.f64	d10, #5.0e-1
	vmov	r3, s15	@ int
	vmul.f64	d5, d5, d10
	lsrs	r2, r3, #31
	vmov	s8, r2	@ int
	lsrs	r2, r3, #1
	and	r3, r3, #1
	vmov	s12, r2	@ int
	vmov	s15, r3	@ int
	vcvt.u32.f64	s10, d5
	vcvt.f64.s32	d4, s8
	vcvt.f64.s32	d7, s15
	vcvt.f64.u32	d5, s10
	vcvt.f64.s32	d6, s12
	vmla.f64	d5, d7, d9
	vmla.f64	d6, d4, d9
	vstr.64	d8, [r1]
	vstr.64	d11, [r1, #8]
.LBI3133:
.LBI3135:
.LBI3281:
.LBI3283:
.LBI3285:
	add	r0, sp, #64
	vstr.64	d6, [r5]
	vstr.64	d5, [r5, #8]
	bl	fp64e_cmul_prepared
	adds	r1, r1, #16
	cmp	r7, r1
	vstr.64	d0, [r6]
	vstr.64	d1, [r6, #8]
	vstr.64	d0, [sp, #32]
	vstr.64	d2, [r4]
	vstr.64	d3, [r4, #8]
	vstr.64	d1, [sp, #40]
	vstr.64	d2, [sp, #48]
	vstr.64	d3, [sp, #56]
	add	r5, r5, #16
	add	r6, r6, #16
	add	r4, r4, #16
	bne	.L46
	ldr	r2, [sp, #8]
.L45:
	ldr	r3, [sp, #12]
	add	r10, r10, #16
	add	fp, fp, r3
	ldr	r3, [sp, #16]
	add	r2, r2, r8
	cmp	r3, r10
	add	r7, r7, r8
	bne	.L47
	ldr	r5, [sp, #24]
	mov	ip, r9
	subs	r5, r5, #1
	ldr	lr, [sp, #12]
	ldr	r1, [sp, #28]
	bne	.L48
.L43:
	add	sp, sp, #188
	vldm	sp!, {d8-d15}
	pop	{r4, r5, r6, r7, r8, r9, r10, fp, pc}
	.size	fndsa_vect_iFFT_fp64_exact, .-fndsa_vect_iFFT_fp64_exact
.section .note.GNU-stack,"",%progbits
