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
.LBI823:
	vmov.f64	d13, d1
	vldr.64	d3, [r0, #24]
.LBI825:
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
.LBI850:
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
.LBI838:
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
.LBI876:
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
.LBI919:
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
.LBI991:
.LBI993:
.LBI1023:
.LBI1005:
.LBI1048:
.LBI1097:
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
.LBI1182:
.LBI1184:
.LBI1242:
.LBI1259:
.LBI1276:
.LBI1244:
.LBI1292:
	vcvt.u32.f64	s20, d10
	vsub.f64	d9, d9, d8
	vcvt.f64.u32	d10, s20
	vldr.64	d8, [r0, #112]
	vldr.64	d11, [sp]
	vmls.f64	d2, d10, d7
	vmls.f64	d6, d11, d8
.LBI1344:
.LBI1571:
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
.LBI1573:
.LBI1546:
.LBI1548:
.LBI1602:
	vadd.f64	d2, d2, d4
.LBI1604:
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
	push	{r4, r5, r6, r7, r8, r9, r10, fp, lr}
	movs	r3, #1
	vpush.64	{d8, d9, d10, d11, d12, d13, d14, d15}
	add	r10, r0, #-1
	cmp	r0, #2
	mov	r4, r0
	mov	r6, r1
	sub	sp, sp, #380
	lsl	r8, r3, r10
	bhi	.L29
	it	eq
	moveq	lr, r0
	bne	.L28
.L30:
	movs	r0, #16
	str	r4, [sp, #92]
	vldr.64	d9, .L44
	vldr.64	d8, .L44+8
	movs	r4, #1
	mov	ip, r8
	str	r8, [sp, #88]
	ldr	r8, .L44+16
	add	r7, sp, #96
	lsl	fp, r0, r10
	str	r10, [sp, #80]
	str	lr, [sp, #72]
.L36:
	movs	r3, #1
	mov	r10, #16
	mov	r2, ip
	lsls	r3, r3, r4
	add	r3, r3, r3, lsr #1
	add	r3, r8, r3, lsl #4
	lsr	ip, ip, #1
	lsl	r10, r10, r4
	str	r3, [sp, #40]
	add	r9, r6, ip, lsl #4
	mov	r3, r6
	add	r0, r10, r8
	str	r6, [sp, #64]
	mov	r10, fp
	vmov.f64	d14, #1.0e+0
	mov	fp, #0
	mov	r6, r2
	str	ip, [sp, #32]
	str	r4, [sp, #48]
	str	r8, [sp, #56]
.L35:
.LBI3109:
	vldr.32	s15, [r0]	@ int
	vcvt.f64.u32	d1, s15
.LBI3111:
.LBI3115:
.LBI2891:
	vldr.32	s15, [r0, #8]	@ int
	vcvt.f64.u32	d4, s15
	vldr.32	s15, [r0, #4]	@ int
	vcvt.f64.u32	d2, s15
.LBI2904:
	vldr.32	s15, [r0, #12]	@ int
	ldr	r2, [r0, #4]
	vcvt.f64.u32	d3, s15
.LBI2913:
.LBI2893:
	lsrs	r2, r2, #31
	vmov	s12, r2	@ int
	vmov	r2, s15	@ int
	lsrs	r2, r2, #31
	vmov	s14, r2	@ int
	vadd.f64	d5, d1, d4
	vcvt.f64.s32	d7, s14
	vstr.64	d7, [sp, #328]
	vmul.f64	d7, d5, d9
	vcvt.u32.f64	s14, d7
	vadd.f64	d12, d2, d3
	vcvt.f64.u32	d7, s14
	vadd.f64	d12, d12, d7
.LBI2895:
	vmls.f64	d5, d7, d8
	vmul.f64	d7, d12, d9
	vcvt.u32.f64	s14, d7
	vcvt.f64.u32	d7, s14
	vmls.f64	d12, d7, d8
	vcvt.u32.f64	s14, d12
	ldr	r2, [sp, #32]
	vcvt.f64.s32	d6, s12
	add	r1, r2, fp
	vmov	r2, s14	@ int
	lsrs	r2, r2, #31
	vstr.64	d6, [sp, #288]
	vmov	s14, r2	@ int
	vmul.f64	d6, d5, d9
.LBI2924:
	vmul.f64	d0, d1, d9
	vstr.64	d1, [sp, #264]
	vmul.f64	d10, d2, d9
	vmul.f64	d1, d4, d9
	vmul.f64	d11, d3, d9
	vstr.64	d6, [sp, #360]
	vcvt.f64.s32	d7, s14
	vmul.f64	d6, d12, d9
	cmp	fp, r1
	vstr.64	d2, [sp, #256]
	vstr.64	d3, [sp, #296]
	vstr.64	d4, [sp, #304]
	vstr.64	d0, [sp, #280]
	vstr.64	d1, [sp, #320]
	vstr.64	d10, [sp, #272]
	vstr.64	d11, [sp, #312]
	vstr.64	d5, [sp, #344]
	vstr.64	d12, [sp, #336]
	vstr.64	d6, [sp, #352]
	vstr.64	d7, [sp, #368]
	bcs	.L33
	mov	r1, r9
	mov	r4, r3
	mov	r8, r0
	str	r6, [sp, #16]
	add	r5, r10, r9
	str	r3, [sp, #24]
	add	r6, r10, r3
.L34:
	vldr.64	d0, [r1]
	vldr.64	d2, [r5]
	vldr.64	d3, [r5, #8]
	vldr.64	d1, [r1, #8]
	add	r0, sp, #256
	bl	fp64e_cmul_prepared
	vldr.64	d13, [r4, #8]
	vldr.64	d10, [r6]
	vldr.64	d12, [r6, #8]
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
	vstr.64	d1, [r7, #8]
	vsub.f64	d1, d5, d1
	vmul.f64	d5, d7, d9
	vsub.f64	d11, d11, d0
	vstr.64	d0, [r7]
	vstr.64	d2, [r7, #16]
	vcvt.u32.f64	s0, d4
	vsub.f64	d2, d12, d3
	vstr.64	d3, [r7, #24]
.LBI2976:
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
	vcvt.u32.f64	s24, d12
	vcvt.u32.f64	s6, d3
	vstr.64	d5, [sp]
	vcvt.f64.u32	d4, s24
	vadd.f64	d11, d13, d0
	vcvt.f64.u32	d3, s6
	vmov.f64	d12, d7
	vmov.f64	d13, d6
	vldr.64	d7, [sp]
	vldr.64	d6, [sp, #8]
	vadd.f64	d5, d15, d10
.LBI2978:
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
	adds	r6, r6, #16
	adds	r1, r1, #16
	adds	r5, r5, #16
	cmp	r9, r4
	vstr.64	d12, [r4, #-8]
.LBI3000:
.LBI3002:
	vstr.64	d5, [r4, #-16]
	vstr.64	d11, [r6, #-16]
	vstr.64	d13, [r6, #-8]
.LBI2949:
.LBI2951:
	vstr.64	d1, [r1, #-8]
.LBI3026:
.LBI3028:
	vstr.64	d7, [r1, #-16]
	vstr.64	d6, [r5, #-16]
	vstr.64	d2, [r5, #-8]
	bne	.L34
	mov	r0, r8
	ldr	r6, [sp, #16]
	ldr	r3, [sp, #24]
.L33:
	ldr	r2, [sp, #40]
	adds	r0, r0, #16
	cmp	r2, r0
	add	fp, fp, r6
	add	r3, r3, r6, lsl #4
	add	r9, r9, r6, lsl #4
	bne	.L35
	ldr	r4, [sp, #48]
	ldr	r3, [sp, #72]
	adds	r4, r4, #1
	cmp	r4, r3
	mov	fp, r10
	ldr	ip, [sp, #32]
	ldr	r8, [sp, #56]
	ldr	r6, [sp, #64]
	bcc	.L36
	mov	r5, r8
	ldrd	r8, r4, [sp, #88]
	cmp	r4, #2
	ldr	r10, [sp, #80]
	beq	.L28
.L37:
	mov	r1, r6
	movs	r4, #16
	vldr.64	d14, .L44
	vldr.64	d15, .L44+8
	add	r3, r8, #-1
	lsl	r4, r4, r10
	lsr	r6, r8, #1
	lsrs	r3, r3, #2
	add	r7, r1, #64
	add	r6, r5, r6, lsl #4
	add	r7, r7, r3, lsl #6
	add	r5, r5, r4
	add	r4, r4, r1
	b	.L45
.L46:
	.align	3
.L44:
	.word	0
	.word	1039138816
	.word	0
	.word	1106247680
	.word	fndsa_kgen_GM_TAB
.L45:
.L32:
	vldr.64	d7, [r1, #8]
	vldr.64	d3, [r1, #24]
	vstr.64	d7, [sp, #8]
	vldr.32	s15, [r6]	@ int
	vldr.64	d2, [r4, #16]
	vldr.64	d5, [r1, #16]
	vldr.64	d4, [r1]
	vstr.64	d3, [sp]
	vcvt.f64.u32	d3, s15
	vldr.32	s15, [r6, #8]	@ int
	ldr	r3, [r6, #4]
	vstr.64	d2, [sp, #24]
	lsrs	r3, r3, #31
	vmov	s4, r3	@ int
	ldr	r3, [r6, #12]
	vldr.64	d6, [r4, #8]
	lsrs	r3, r3, #31
	vstr.64	d5, [sp, #40]
	vstr.64	d4, [sp, #48]
	vmov	s10, r3	@ int
	vcvt.f64.u32	d4, s15
	vldr.32	s15, [r6, #4]	@ int
	vstr.64	d6, [sp, #72]
	vcvt.f64.s32	d5, s10
	vcvt.f64.u32	d6, s15
	vldr.32	s15, [r6, #12]	@ int
	vldr.64	d11, [r4]
	vldr.64	d1, [r4, #24]
	vldr.64	d0, [r4, #48]
	vcvt.f64.u32	d7, s15
	vcvt.f64.s32	d2, s4
	vstr.64	d3, [sp, #264]
	vstr.64	d4, [sp, #304]
	vstr.64	d5, [sp, #328]
	vadd.f64	d5, d3, d4
	vmul.f64	d3, d3, d14
	vmul.f64	d4, d4, d14
	vldr.64	d12, [r1, #48]
	vldr.64	d13, [r1, #56]
	vstr.64	d11, [sp, #32]
	vstr.64	d1, [sp, #16]
	vstr.64	d0, [sp, #64]
	vstr.64	d2, [sp, #288]
	vstr.64	d6, [sp, #256]
	vstr.64	d7, [sp, #296]
	vstr.64	d3, [sp, #280]
	vstr.64	d4, [sp, #320]
	vmul.f64	d4, d5, d14
	vcvt.u32.f64	s7, d4
	vadd.f64	d4, d6, d7
	vmul.f64	d7, d7, d14
	vstr.64	d7, [sp, #312]
	vcvt.f64.u32	d7, s7
	vadd.f64	d4, d4, d7
	vmls.f64	d5, d7, d15
	vmul.f64	d7, d4, d14
	vcvt.u32.f64	s14, d7
	vcvt.f64.u32	d7, s14
	vmls.f64	d4, d7, d15
	vcvt.u32.f64	s14, d4
	vmov	r3, s14	@ int
	lsrs	r3, r3, #31
	vmov	s14, r3	@ int
	vldr.64	d8, [r4, #56]
	vcvt.f64.s32	d7, s14
	vmul.f64	d6, d6, d14
	vstr.64	d5, [sp, #344]
	vstr.64	d4, [sp, #336]
	vmul.f64	d5, d5, d14
	vmul.f64	d4, d4, d14
	vldr.64	d0, [r1, #32]
	vldr.64	d1, [r1, #40]
	vldr.64	d2, [r4, #32]
	vldr.64	d3, [r4, #40]
	add	r0, sp, #256
	vstr.64	d4, [sp, #352]
	vstr.64	d7, [sp, #368]
	vstr.64	d6, [sp, #272]
.LBI3219:
.LBI3221:
.LBI3228:
.LBI3150:
.LBI3164:
.LBI3173:
.LBI3152:
.LBI3154:
.LBI3194:
	vstr.64	d5, [sp, #360]
	vstr.64	d8, [sp, #56]
	bl	fp64e_cmul_prepared
	vmov.f64	d9, d0
	vmov.f64	d8, d2
	vmov.f64	d11, d1
	vmov.f64	d10, d3
	vldr.64	d2, [sp, #64]
	vmov.f64	d0, d12
	vmov.f64	d1, d13
	vldr.64	d3, [sp, #56]
	vstr.64	d9, [sp, #128]
	vstr.64	d11, [sp, #136]
	vstr.64	d8, [sp, #144]
	vstr.64	d10, [sp, #152]
	bl	fp64e_cmul_prepared
	vldr.32	s15, [r5]	@ int
	vcvt.f64.u32	d5, s15
	vldr.32	s15, [r5, #8]	@ int
	vcvt.f64.u32	d6, s15
	vldr.32	s15, [r5, #4]	@ int
	ldr	r3, [r5, #4]
	vcvt.f64.u32	d12, s15
	lsrs	r3, r3, #31
	vmov	s8, r3	@ int
	ldr	r3, [r5, #12]
	vldr.32	s15, [r5, #12]	@ int
	lsrs	r3, r3, #31
	vmov	s14, r3	@ int
	vcvt.f64.u32	d13, s15
	vcvt.f64.s32	d7, s14
	vcvt.f64.s32	d4, s8
	vstr.64	d6, [sp, #304]
	vstr.64	d7, [sp, #328]
	vadd.f64	d7, d5, d6
	vmul.f64	d6, d6, d14
	vstr.64	d4, [sp, #288]
	vstr.64	d5, [sp, #264]
	vldr.64	d4, [sp, #8]
	vmul.f64	d5, d5, d14
	vstr.64	d6, [sp, #320]
	vmul.f64	d6, d7, d14
	vstr.64	d5, [sp, #280]
	vcvt.u32.f64	s12, d6
	vadd.f64	d5, d4, d15
	vadd.f64	d4, d4, d11
	vstr.64	d4, [sp, #64]
	vcvt.f64.u32	d4, s12
	vmls.f64	d7, d4, d15
	vldr.64	d6, [sp, #72]
	vstr.64	d7, [sp, #344]
	vmul.f64	d7, d7, d14
	vstr.64	d7, [sp, #360]
	vadd.f64	d7, d6, d15
	vadd.f64	d6, d10, d6
	vstr.64	d0, [sp, #160]
	vstr.64	d1, [sp, #168]
	vstr.64	d2, [sp, #176]
	vstr.64	d3, [sp, #184]
.LBI3384:
	vstr.64	d12, [sp, #256]
	vstr.64	d13, [sp, #296]
	vstr.64	d6, [sp, #56]
	vldr.64	d6, [sp]
	vsub.f64	d10, d7, d10
	vadd.f64	d7, d6, d15
	vadd.f64	d6, d6, d1
	vsub.f64	d7, d7, d1
	vldr.64	d1, [sp, #16]
	vsub.f64	d11, d5, d11
	vadd.f64	d5, d1, d15
	vstr.64	d7, [sp, #8]
	vadd.f64	d7, d1, d3
	vsub.f64	d3, d5, d3
	vadd.f64	d5, d12, d13
	vadd.f64	d1, d5, d4
	vmul.f64	d5, d6, d14
	vmul.f64	d12, d12, d14
	vcvt.u32.f64	s9, d5
	vmul.f64	d5, d7, d14
	vstr.64	d12, [sp, #272]
	vmul.f64	d13, d13, d14
	vcvt.f64.u32	d12, s9
	vcvt.u32.f64	s11, d5
	vldr.64	d4, [sp, #56]
	vstr.64	d1, [sp, #80]
	vstr.64	d13, [sp, #312]
	vmov.f64	d1, d6
	vcvt.f64.u32	d13, s11
	vmul.f64	d6, d4, d14
	vldr.64	d5, [sp, #64]
	vstr.64	d3, [sp]
	vcvt.u32.f64	s12, d6
	vmov.f64	d3, d7
	vmul.f64	d7, d5, d14
	vcvt.f64.u32	d6, s12
	vcvt.u32.f64	s14, d7
	vmls.f64	d4, d6, d15
	vcvt.f64.u32	d7, s14
	vstr.64	d6, [sp, #16]
	vmls.f64	d5, d7, d15
	vmul.f64	d6, d11, d14
	vstr.64	d4, [sp, #56]
	vldr.64	d4, [sp, #48]
	vstr.64	d5, [sp, #72]
	vcvt.u32.f64	s12, d6
	vadd.f64	d5, d4, d15
	vadd.f64	d4, d4, d9
	vcvt.f64.u32	d6, s12
	vadd.f64	d4, d4, d7
.LBI3386:
	vsub.f64	d5, d5, d9
	vmov.f64	d7, #1.0e+0
	vmov.f64	d9, d11
	vsub.f64	d5, d5, d7
	vldr.64	d11, [sp, #32]
	vmls.f64	d9, d6, d15
	vmul.f64	d7, d10, d14
	vstr.64	d9, [sp, #48]
	vcvt.u32.f64	s14, d7
	vadd.f64	d9, d5, d6
	vadd.f64	d6, d11, d15
	vadd.f64	d5, d11, d8
	vcvt.f64.u32	d7, s14
	vmov.f64	d11, #1.0e+0
	vsub.f64	d6, d6, d8
	vmls.f64	d10, d7, d15
	vsub.f64	d6, d6, d11
	vldr.64	d8, [sp, #16]
	vstr.64	d10, [sp, #32]
	vadd.f64	d10, d6, d7
	vldr.64	d6, [sp, #8]
	vadd.f64	d8, d5, d8
	vmul.f64	d5, d6, d14
	vldr.64	d6, [sp, #40]
	vcvt.u32.f64	s10, d5
	vadd.f64	d7, d6, d15
	vadd.f64	d6, d6, d0
	vsub.f64	d7, d7, d0
	vcvt.f64.u32	d5, s10
	vadd.f64	d0, d6, d12
	vldr.64	d6, [sp, #8]
	vmls.f64	d6, d5, d15
	vmls.f64	d1, d12, d15
	vsub.f64	d7, d7, d11
	vmov.f64	d12, d11
	vstr.64	d6, [sp, #8]
	vldr.64	d11, [sp]
	vldr.64	d6, [sp, #24]
	vadd.f64	d5, d7, d5
	vmul.f64	d11, d11, d14
	vadd.f64	d7, d6, d15
	vcvt.u32.f64	s22, d11
	vadd.f64	d6, d6, d2
	vsub.f64	d7, d7, d2
	vmls.f64	d3, d13, d15
	vadd.f64	d2, d6, d13
	vsub.f64	d7, d7, d12
	vldr.64	d13, [sp]
	vcvt.f64.u32	d11, s22
	vmls.f64	d13, d11, d15
	vadd.f64	d11, d7, d11
	vldr.64	d7, [sp, #80]
	vmul.f64	d6, d7, d14
	vcvt.u32.f64	s12, d6
	vcvt.f64.u32	d6, s12
	vmls.f64	d7, d6, d15
	vcvt.u32.f64	s13, d7
	vmov	r3, s13	@ int
	vstr.64	d7, [sp, #336]
	vmul.f64	d7, d7, d14
	lsrs	r3, r3, #31
	vstr.64	d7, [sp, #352]
	vmov	s14, r3	@ int
	vcvt.f64.s32	d7, s14
	vstr.64	d7, [sp, #368]
	vmul.f64	d7, d4, d14
	vmul.f64	d6, d2, d14
	vcvt.u32.f64	s14, d7
	vcvt.u32.f64	s12, d6
	vcvt.f64.u32	d7, s14
	vcvt.f64.u32	d6, s12
	vmls.f64	d4, d7, d15
	vmul.f64	d7, d9, d14
	vmls.f64	d2, d6, d15
	vcvt.u32.f64	s14, d7
	vmul.f64	d6, d8, d14
	vcvt.f64.u32	d7, s14
	vcvt.u32.f64	s12, d6
	vmls.f64	d9, d7, d15
	vcvt.f64.u32	d6, s12
	vmul.f64	d7, d5, d14
	vmls.f64	d8, d6, d15
	vcvt.u32.f64	s14, d7
	vmul.f64	d6, d10, d14
	vstr.64	d8, [sp, #40]
	vcvt.f64.u32	d7, s14
	vmov.f64	d8, d5
	vmul.f64	d12, d0, d14
	vmls.f64	d8, d7, d15
	vcvt.u32.f64	s12, d6
	vmul.f64	d7, d11, d14
	vcvt.u32.f64	s24, d12
	vcvt.f64.u32	d6, s12
	vcvt.u32.f64	s14, d7
	vcvt.f64.u32	d12, s24
.LBI3440:
.LBI3442:
.LBI3501:
.LBI3503:
.LBI3549:
.LBI3551:
.LBI3350:
.LBI3352:
.LBI3413:
.LBI3415:
	vmls.f64	d10, d6, d15
	vcvt.f64.u32	d7, s14
	vmls.f64	d0, d12, d15
	vmls.f64	d11, d7, d15
	vstr.64	d4, [sp, #64]
	vstr.64	d13, [sp]
	vstr.64	d9, [sp, #24]
	vstr.64	d10, [sp, #16]
.LBI3473:
.LBI3475:
.LBI3521:
.LBI3523:
.LBI3262:
.LBI3264:
.LBI3269:
.LBI3284:
.LBI3285:
.LBI3294:
.LBI3306:
.LBI3308:
.LBI3325:
	bl	fp64e_cmul_prepared
	vldr.32	s15, [r5, #16]	@ int
	ldr	r3, [r5, #20]
	vmov.f64	d13, d2
	lsrs	r3, r3, #31
	vmov.f64	d2, d11
	vmov	s22, r3	@ int
	ldr	r3, [r5, #28]
	vmov.f64	d12, d0
	lsrs	r3, r3, #31
	vmov.f64	d0, d8
	vmov	s10, r3	@ int
	vcvt.f64.u32	d8, s15
	vldr.32	s15, [r5, #24]	@ int
	vcvt.f64.s32	d5, s10
	vcvt.f64.u32	d4, s15
	vstr.64	d8, [sp, #264]
	vldr.32	s15, [r5, #20]	@ int
	vstr.64	d5, [sp, #328]
	vadd.f64	d5, d8, d4
	vmul.f64	d8, d8, d14
	vcvt.f64.u32	d6, s15
	vstr.64	d8, [sp, #280]
	vldr.32	s15, [r5, #28]	@ int
	vmul.f64	d8, d5, d14
	vcvt.f64.u32	d7, s15
	vstr.64	d4, [sp, #304]
	vcvt.u32.f64	s16, d8
	vmul.f64	d4, d4, d14
	vcvt.f64.u32	d8, s16
	vstr.64	d4, [sp, #320]
	vadd.f64	d4, d6, d7
	vstr.64	d7, [sp, #296]
	vadd.f64	d4, d4, d8
	vmul.f64	d7, d7, d14
	vstr.64	d7, [sp, #312]
	vmul.f64	d7, d4, d14
	vcvt.u32.f64	s14, d7
	vcvt.f64.u32	d7, s14
	vmls.f64	d4, d7, d15
	vcvt.u32.f64	s14, d4
	vmov	r3, s14	@ int
	lsrs	r3, r3, #31
	vmls.f64	d5, d8, d15
	vmov	s14, r3	@ int
	vmov.f64	d10, d1
	vmov.f64	d9, d3
	vcvt.f64.s32	d7, s14
	vcvt.f64.s32	d11, s22
	vstr.64	d6, [sp, #256]
	vstr.64	d5, [sp, #344]
	vmul.f64	d6, d6, d14
	vmul.f64	d5, d5, d14
	vstr.64	d4, [sp, #336]
	vmul.f64	d4, d4, d14
	vldr.64	d1, [sp, #8]
	vldr.64	d3, [sp]
	vstr.64	d12, [sp, #192]
	vstr.64	d10, [sp, #200]
	vstr.64	d13, [sp, #208]
	vstr.64	d9, [sp, #216]
.LBI3672:
.LBI3674:
.LBI3681:
.LBI3701:
.LBI3702:
.LBI3713:
.LBI3726:
.LBI3728:
.LBI3749:
	vstr.64	d11, [sp, #288]
	vstr.64	d6, [sp, #272]
	vstr.64	d5, [sp, #360]
	vstr.64	d4, [sp, #352]
	vstr.64	d7, [sp, #368]
	bl	fp64e_cmul_prepared
	vldr.64	d5, [sp, #72]
	vldr.64	d7, [sp, #56]
	vadd.f64	d6, d5, d10
	vadd.f64	d4, d5, d15
	vldr.64	d5, [sp, #48]
	vadd.f64	d8, d7, d15
	vadd.f64	d11, d5, d15
	vadd.f64	d7, d7, d9
	vsub.f64	d8, d8, d9
	vsub.f64	d11, d11, d1
	vadd.f64	d9, d5, d1
	vstr.64	d1, [sp, #232]
	vldr.64	d1, [sp, #32]
	vadd.f64	d5, d1, d15
	vsub.f64	d5, d5, d3
	vsub.f64	d4, d4, d10
	vstr.64	d5, [sp]
	vadd.f64	d10, d1, d3
	vmul.f64	d5, d6, d14
	vstr.64	d3, [sp, #248]
.LBI3838:
	vmul.f64	d3, d7, d14
	vcvt.u32.f64	s10, d5
	vcvt.u32.f64	s6, d3
	vcvt.f64.u32	d5, s10
	vcvt.f64.u32	d1, s6
	vmls.f64	d6, d5, d15
	vmls.f64	d7, d1, d15
	vldr.64	d3, [sp, #64]
	vstr.64	d7, [sp, #8]
	vstr.64	d6, [r1, #8]
	vmul.f64	d7, d4, d14
	vadd.f64	d6, d3, d15
	vcvt.u32.f64	s14, d7
	vadd.f64	d3, d3, d12
	vsub.f64	d6, d6, d12
	vmov.f64	d12, #1.0e+0
	vcvt.f64.u32	d7, s14
	vsub.f64	d6, d6, d12
	vmov.f64	d12, d4
	vmls.f64	d12, d7, d15
	vldr.64	d4, [sp, #40]
	vstr.64	d12, [sp, #32]
	vadd.f64	d12, d6, d7
	vmul.f64	d7, d8, d14
	vadd.f64	d3, d3, d5
.LBI3840:
.LBI3886:
	vadd.f64	d6, d4, d15
	vadd.f64	d5, d4, d13
	vcvt.u32.f64	s14, d7
	vadd.f64	d1, d5, d1
.LBI3888:
	vcvt.f64.u32	d7, s14
	vsub.f64	d6, d6, d13
	vmov.f64	d5, #1.0e+0
	vmls.f64	d8, d7, d15
	vsub.f64	d6, d6, d5
	vmov.f64	d13, d8
	vmul.f64	d5, d11, d14
	vadd.f64	d8, d6, d7
	vmul.f64	d7, d9, d14
	vldr.64	d4, [sp, #24]
	vcvt.u32.f64	s11, d5
	vcvt.u32.f64	s14, d7
	vstr.32	s11, [sp, #40]	@ int
	vcvt.f64.u32	d7, s14
	vadd.f64	d5, d4, d15
	vadd.f64	d4, d4, d0
	vmls.f64	d9, d7, d15
	vstr.64	d0, [sp, #224]
	vsub.f64	d5, d5, d0
	vadd.f64	d0, d4, d7
	vldr.32	s15, [sp, #40]	@ int
	vmov.f64	d4, #1.0e+0
	vcvt.f64.u32	d7, s15
	vsub.f64	d5, d5, d4
	vmls.f64	d11, d7, d15
	vadd.f64	d5, d5, d7
	vldr.64	d7, [sp]
	vmul.f64	d6, d10, d14
	vmul.f64	d7, d7, d14
	vldr.64	d4, [sp, #16]
	vcvt.u32.f64	s15, d7
	vcvt.u32.f64	s12, d6
	vstr.32	s15, [sp, #24]	@ int
	vcvt.f64.u32	d6, s12
	vadd.f64	d7, d4, d15
	vadd.f64	d4, d4, d2
	vmls.f64	d10, d6, d15
	vadd.f64	d4, d4, d6
	vstr.64	d2, [sp, #240]
	vsub.f64	d7, d7, d2
	vldr.32	s13, [sp, #24]	@ int
	vmov.f64	d2, #1.0e+0
	vcvt.f64.u32	d6, s13
	vsub.f64	d7, d7, d2
	vldr.64	d2, [sp]
	vmls.f64	d2, d6, d15
	vstr.64	d2, [sp]
	vmul.f64	d2, d3, d14
	vcvt.u32.f64	s4, d2
	vadd.f64	d7, d7, d6
	vcvt.f64.u32	d2, s4
	vmul.f64	d6, d1, d14
	vmls.f64	d3, d2, d15
	vcvt.u32.f64	s12, d6
	vstr.64	d3, [r1]
	vcvt.f64.u32	d6, s12
	vldr.64	d3, [sp, #8]
	vmls.f64	d1, d6, d15
	vstr.64	d3, [r4, #8]
.LBI3793:
.LBI3795:
	vldr.64	d6, [sp, #32]
	vmul.f64	d3, d12, d14
	vstr.64	d1, [r4]
	vcvt.u32.f64	s6, d3
	vstr.64	d6, [r1, #24]
.LBI3816:
.LBI3818:
	vmul.f64	d6, d8, d14
	vcvt.f64.u32	d3, s6
	vcvt.u32.f64	s13, d6
	vmls.f64	d12, d3, d15
	vcvt.f64.u32	d3, s13
	vmul.f64	d6, d0, d14
	vcvt.u32.f64	s12, d6
	vcvt.f64.u32	d6, s12
	vmul.f64	d1, d4, d14
	vmls.f64	d8, d3, d15
	vmls.f64	d0, d6, d15
	vmul.f64	d3, d5, d14
	vmul.f64	d6, d7, d14
	vcvt.u32.f64	s6, d3
	vcvt.u32.f64	s2, d1
	vcvt.u32.f64	s12, d6
	vcvt.f64.u32	d1, s2
	vcvt.f64.u32	d3, s6
	vcvt.f64.u32	d6, s12
	vmls.f64	d4, d1, d15
	vmls.f64	d5, d3, d15
	vldr.64	d2, [sp]
	vmls.f64	d7, d6, d15
	adds	r1, r1, #64
	cmp	r7, r1
	add	r4, r4, #64
	vstr.64	d12, [r1, #-48]
	add	r6, r6, #16
	vstr.64	d13, [r4, #-40]
.LBI3912:
.LBI3914:
	vstr.64	d8, [r4, #-48]
	add	r5, r5, #32
	vstr.64	d9, [r1, #-24]
.LBI3954:
.LBI3956:
	vstr.64	d0, [r1, #-32]
	vstr.64	d10, [r4, #-24]
.LBI3859:
.LBI3861:
	vstr.64	d4, [r4, #-32]
	vstr.64	d5, [r1, #-16]
	vstr.64	d11, [r1, #-8]
.LBI3928:
.LBI3930:
	vstr.64	d2, [r4, #-8]
	vstr.64	d7, [r4, #-16]
	bne	.L32
.L28:
	add	sp, sp, #380
	vldm	sp!, {d8-d15}
	pop	{r4, r5, r6, r7, r8, r9, r10, fp, pc}
.L29:
	cmp	r0, #3
	sub	lr, r0, #2
	bne	.L30
	ldr	r5, .L47
	b	.L37
.L48:
	.align	2
.L47:
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
	cmp	r0, #2
	mov	r5, r1
	sub	sp, sp, #404
	add	r10, r0, #-1
	bls	.L57
	movs	r3, #1
	movs	r4, #16
	mov	fp, r0
	vldr.64	d15, .L66
	vldr.64	d14, .L66+8
	lsl	r3, r3, r10
	ldr	r6, .L66+24
	subs	r2, r3, #1
	lsl	r4, r4, r10
	add	r8, r1, #64
	lsrs	r3, r3, #1
	lsrs	r2, r2, #2
	add	r7, r6, r3, lsl #4
	add	r8, r8, r2, lsl #6
	add	r6, r6, r4
	add	r4, r4, r1
.L51:
	vldr.32	s15, [r6, #8]	@ int
	vcvt.f64.u32	d13, s15
	vldr.32	s15, [r6, #12]	@ int
	ldr	r3, [r6, #4]
	vcvt.f64.u32	d2, s15
	lsrs	r3, r3, #31
	vmov	s16, r3	@ int
	vldr.64	d9, [r1, #40]
	vldr.32	s15, [r6]	@ int
	vcvt.f64.s32	d8, s16
	vmov.f64	d0, #1.0e+0
	vsub.f64	d2, d14, d2
	vldr.64	d4, [r1, #8]
	vldr.64	d11, [r1, #56]
	vldr.64	d10, [r4, #40]
	vcvt.f64.u32	d6, s15
	vsub.f64	d2, d2, d0
	vldr.32	s15, [r6, #4]	@ int
	vstr.64	d8, [sp, #312]
	vadd.f64	d8, d9, d14
	vldr.64	d3, [r1, #24]
	vldr.64	d5, [r4, #8]
	vldr.64	d12, [r4, #56]
	vcvt.f64.u32	d7, s15
	vadd.f64	d9, d9, d11
	vadd.f64	d0, d10, d14
	vsub.f64	d11, d8, d11
	vstr.64	d2, [sp, #72]
	vldr.64	d8, [r1]
	vadd.f64	d2, d4, d14
	vldr.64	d1, [r4, #24]
	vadd.f64	d4, d3, d4
	vsub.f64	d2, d2, d3
	vadd.f64	d10, d10, d12
	vstr.64	d7, [sp]
	vsub.f64	d12, d0, d12
	vstr.64	d7, [sp, #280]
	vadd.f64	d3, d5, d14
	vldr.64	d7, [r1]
	vadd.f64	d0, d8, d14
	vldr.64	d8, [r1, #16]
	vadd.f64	d5, d5, d1
	vsub.f64	d3, d3, d1
	vadd.f64	d8, d8, d7
	vmul.f64	d1, d2, d15
	vstr.64	d8, [sp, #8]
	vcvt.u32.f64	s2, d1
	vldr.64	d8, [r1, #16]
	vcvt.f64.u32	d1, s2
	vmov.f64	d7, #1.0e+0
	vsub.f64	d0, d0, d8
	vmls.f64	d2, d1, d14
	vsub.f64	d0, d0, d7
	vldr.64	d8, [r4]
	vadd.f64	d0, d0, d1
	vadd.f64	d1, d2, d7
	vmul.f64	d2, d3, d15
	vldr.64	d7, [r4, #16]
	vstr.64	d1, [sp, #48]
	vcvt.u32.f64	s4, d2
	vadd.f64	d1, d8, d14
	vcvt.f64.u32	d2, s4
	vadd.f64	d8, d8, d7
	vsub.f64	d1, d1, d7
	vmov.f64	d7, #1.0e+0
	vmls.f64	d3, d2, d14
	vsub.f64	d1, d1, d7
	vadd.f64	d1, d1, d2
	vadd.f64	d2, d3, d7
	vmul.f64	d3, d4, d15
	vcvt.u32.f64	s6, d3
	vstr.64	d2, [sp, #40]
	vcvt.f64.u32	d3, s6
	vmul.f64	d2, d5, d15
	vstr.64	d8, [sp, #16]
	vmls.f64	d4, d3, d14
	vldr.64	d8, [sp, #8]
	vcvt.u32.f64	s4, d2
	vadd.f64	d8, d8, d3
	vcvt.f64.u32	d2, s4
	vmov.f64	d3, d7
	vadd.f64	d7, d4, d7
	vldr.64	d4, [sp, #16]
	vmls.f64	d5, d2, d14
	vadd.f64	d4, d4, d2
	vadd.f64	d5, d5, d3
	vstr.64	d4, [sp, #8]
	vmul.f64	d4, d9, d15
	vstr.64	d6, [sp, #288]
	vstr.64	d7, [sp, #64]
	vcvt.u32.f64	s8, d4
	vstr.64	d5, [sp, #56]
	vmul.f64	d5, d10, d15
	vcvt.f64.u32	d4, s8
	vcvt.u32.f64	s10, d5
	vmls.f64	d9, d4, d14
	vcvt.f64.u32	d5, s10
	vadd.f64	d7, d9, d3
	vmls.f64	d10, d5, d14
	vstr.64	d7, [sp, #32]
	vadd.f64	d2, d10, d3
	vldr.64	d7, [r1, #48]
	vldr.64	d10, [r1, #32]
	vldr.64	d3, [r1, #32]
	vmul.f64	d9, d11, d15
	vstr.64	d2, [sp, #24]
	vcvt.u32.f64	s18, d9
	vadd.f64	d2, d10, d7
	vadd.f64	d3, d3, d14
	vadd.f64	d2, d2, d4
	vsub.f64	d3, d3, d7
	vmov.f64	d4, #1.0e+0
	vcvt.f64.u32	d9, s18
	vsub.f64	d3, d3, d4
	vmls.f64	d11, d9, d14
	vadd.f64	d9, d3, d9
	vadd.f64	d3, d11, d4
	vstr.64	d3, [sp, #16]
	vldr.64	d3, [r4, #32]
	vmov.f64	d7, d4
	vldr.64	d11, [r4, #48]
	vmul.f64	d10, d12, d15
	vadd.f64	d4, d3, d14
	vsub.f64	d13, d14, d13
	vadd.f64	d3, d3, d11
	vsub.f64	d4, d4, d11
	vcvt.u32.f64	s20, d10
	vsub.f64	d4, d4, d7
	vadd.f64	d3, d3, d5
	vcvt.f64.u32	d10, s20
	vmul.f64	d5, d13, d15
	vmls.f64	d12, d10, d14
	vcvt.u32.f64	s10, d5
	vadd.f64	d10, d4, d10
	vmul.f64	d4, d0, d15
	vadd.f64	d12, d12, d7
	vcvt.f64.u32	d5, s10
	vcvt.u32.f64	s15, d4
	vldr.64	d11, [sp, #72]
	vmls.f64	d13, d5, d14
	vadd.f64	d11, d11, d5
	vcvt.f64.u32	d5, s15
	vldr.64	d7, .L66+16
	vmls.f64	d0, d5, d14
	vmul.f64	d5, d1, d15
	vadd.f64	d0, d0, d7
	vcvt.u32.f64	s10, d5
	vstr.64	d0, [sp, #72]
	vmul.f64	d0, d8, d15
	vcvt.f64.u32	d5, s10
	vcvt.u32.f64	s0, d0
	vmls.f64	d1, d5, d14
	vcvt.f64.u32	d0, s0
	vmls.f64	d8, d0, d14
	vadd.f64	d0, d1, d7
	vldr.64	d1, [sp, #8]
	vmul.f64	d5, d1, d15
	vmov.f64	d4, d13
	vstr.64	d13, [sp, #328]
	vcvt.u32.f64	s10, d5
	vmul.f64	d13, d2, d15
	vcvt.f64.u32	d5, s10
	vcvt.u32.f64	s26, d13
	vmls.f64	d1, d5, d14
	vcvt.f64.u32	d5, s26
	vadd.f64	d13, d1, d7
	vmls.f64	d2, d5, d14
	vstr.64	d13, [sp, #8]
	vmul.f64	d5, d3, d15
	vadd.f64	d13, d2, d7
	vmul.f64	d2, d9, d15
	vcvt.u32.f64	s10, d5
	vcvt.u32.f64	s4, d2
	vcvt.f64.u32	d5, s10
	vcvt.f64.u32	d2, s4
	vmls.f64	d3, d5, d14
	vmls.f64	d9, d2, d14
	vmul.f64	d5, d10, d15
	vstr.64	d13, [sp, #80]
	vadd.f64	d13, d3, d7
	vadd.f64	d3, d9, d7
	vcvt.u32.f64	s10, d5
	vstr.64	d3, [sp, #88]
	vmul.f64	d3, d11, d15
	vcvt.f64.u32	d5, s10
	vcvt.u32.f64	s5, d3
	vmls.f64	d10, d5, d14
	vcvt.f64.u32	d5, s5
	vmls.f64	d11, d5, d14
	vcvt.u32.f64	s10, d11
	vadd.f64	d3, d10, d7
	vmov	r3, s10	@ int
	vldr.64	d1, [sp, #48]
	vstr.64	d3, [sp, #96]
	vadd.f64	d3, d4, d6
	vmul.f64	d6, d6, d15
	lsrs	r3, r3, #31
	vmov	s10, r3	@ int
	vstr.64	d6, [sp, #304]
	vmul.f64	d6, d1, d15
	vldr.64	d10, [sp, #40]
	vcvt.f64.s32	d5, s10
	vcvt.u32.f64	s12, d6
	vmul.f64	d4, d4, d15
	vcvt.f64.u32	d6, s12
	vstr.64	d5, [sp, #352]
	vmul.f64	d5, d10, d15
	vmov.f64	d9, #5.0e-1
	vstr.64	d4, [sp, #344]
	vmls.f64	d1, d6, d14
	vcvt.u32.f64	s9, d5
	vldr.64	d2, [sp, #72]
	vmul.f64	d5, d1, d9
	vadd.f64	d2, d2, d6
	vcvt.f64.u32	d6, s9
	vcvt.u32.f64	s10, d5
	vmls.f64	d10, d6, d14
	vadd.f64	d1, d0, d6
	vmul.f64	d4, d10, d9
	vmov.f64	d0, d9
	vcvt.f64.u32	d6, s10
	vldr.64	d9, [sp, #64]
	vstr.64	d6, [sp, #48]
	vmul.f64	d6, d9, d15
	vldr.64	d10, [sp, #56]
	vcvt.u32.f64	s8, d4
	vcvt.u32.f64	s12, d6
	vcvt.f64.u32	d4, s8
	vmul.f64	d5, d10, d15
	vcvt.f64.u32	d6, s12
	vstr.64	d4, [sp, #64]
	vmls.f64	d9, d6, d14
	vcvt.u32.f64	s9, d5
	vadd.f64	d8, d8, d7
	vmul.f64	d5, d9, d0
	vadd.f64	d8, d8, d6
	vcvt.f64.u32	d6, s9
	vcvt.u32.f64	s10, d5
	vmls.f64	d10, d6, d14
	vldr.64	d7, [sp, #32]
	b	.L67
.L68:
	.align	3
.L66:
	.word	0
	.word	1039138816
	.word	0
	.word	1106247680
	.word	0
	.word	0
	.word	fndsa_kgen_GM_TAB
.L67:
	vmul.f64	d4, d10, d0
	vldr.64	d9, [sp, #8]
	vcvt.f64.u32	d10, s10
	vadd.f64	d9, d9, d6
	vstr.64	d10, [sp, #40]
	vmul.f64	d6, d7, d15
	vldr.64	d10, [sp, #24]
	vcvt.u32.f64	s8, d4
	vmul.f64	d5, d10, d15
	vcvt.f64.u32	d4, s8
	vcvt.u32.f64	s12, d6
	vstr.64	d4, [sp, #32]
	vcvt.f64.u32	d6, s12
	vcvt.u32.f64	s9, d5
	vstr.64	d11, [sp, #320]
	vldr.64	d5, [sp, #80]
	vmls.f64	d7, d6, d14
	vadd.f64	d5, d5, d6
	vcvt.f64.u32	d6, s9
	vmov.f64	d4, d10
	vstr.64	d5, [sp, #24]
	vmls.f64	d4, d6, d14
	vmul.f64	d5, d7, d0
	vldr.64	d10, [sp, #16]
	vmul.f64	d4, d4, d0
	vcvt.u32.f64	s10, d5
	vmov.f64	d7, d0
	vadd.f64	d13, d13, d6
	vcvt.f64.u32	d0, s10
	vmul.f64	d6, d10, d15
	vcvt.u32.f64	s8, d4
	vstr.64	d0, [sp, #56]
	vmul.f64	d5, d12, d15
	vcvt.f64.u32	d0, s8
	vcvt.u32.f64	s12, d6
	vstr.64	d0, [sp, #16]
	vcvt.f64.u32	d6, s12
	vcvt.u32.f64	s1, d5
	vldr.64	d5, [sp, #88]
	vadd.f64	d4, d5, d6
	vmov.f64	d5, d10
	vmls.f64	d5, d6, d14
	vcvt.f64.u32	d6, s1
	vmov.f64	d0, d7
	vmls.f64	d12, d6, d14
	vmul.f64	d5, d5, d7
	vmul.f64	d12, d12, d0
	vldr.64	d7, [sp, #96]
	vcvt.u32.f64	s10, d5
	vadd.f64	d7, d7, d6
	vcvt.u32.f64	s11, d12
	vstr.64	d7, [sp, #8]
	vcvt.f64.u32	d12, s10
	vldr.64	d7, [sp]
	vcvt.f64.u32	d5, s11
	vstr.64	d5, [sp, #96]
	vadd.f64	d5, d11, d7
	vmul.f64	d7, d7, d15
	vmul.f64	d6, d3, d15
	vstr.64	d7, [sp, #296]
	vmul.f64	d7, d2, d15
	vcvt.u32.f64	s12, d6
	vcvt.u32.f64	s14, d7
	vcvt.f64.u32	d6, s12
	vcvt.f64.u32	d7, s14
	vmls.f64	d3, d6, d14
	vadd.f64	d5, d5, d6
	vmul.f64	d6, d1, d15
	vmls.f64	d2, d7, d14
	vcvt.u32.f64	s12, d6
	vcvt.u32.f64	s15, d2
	vcvt.f64.u32	d6, s12
	vmov	r2, s15	@ int
	vmls.f64	d1, d6, d14
	lsrs	r3, r2, #31
	vcvt.u32.f64	s15, d1
	vmov	s14, r3	@ int
	lsrs	r3, r2, #1
	vmul.f64	d11, d11, d15
	vmov	s0, r3	@ int
	vmov	ip, s15	@ int
	vstr.64	d11, [sp, #336]
	vcvt.f64.s32	d7, s14
	vmul.f64	d11, d3, d15
	vstr.64	d3, [sp, #368]
	vcvt.f64.s32	d0, s0
	vldr.64	d3, .L69
	lsr	r3, ip, #31
	vmla.f64	d0, d7, d3
	and	r2, r2, #1
	vmov	s14, r3	@ int
	lsr	r3, ip, #1
	vmov	s15, r2	@ int
	vmov	s4, r3	@ int
	vcvt.f64.s32	d6, s15
	vcvt.f64.s32	d2, s4
	vcvt.f64.s32	d7, s14
	and	r3, ip, #1
	vmla.f64	d2, d7, d3
	vldr.64	d1, [sp, #48]
	vmov	s15, r3	@ int
	vmla.f64	d1, d6, d3
	vcvt.f64.s32	d7, s15
	vmov.f64	d6, d3
	vldr.64	d3, [sp, #64]
	vmla.f64	d3, d7, d6
	vmul.f64	d7, d8, d15
	vcvt.u32.f64	s14, d7
	vcvt.f64.u32	d7, s14
	vmov.f64	d10, d6
	vmul.f64	d6, d9, d15
	vmls.f64	d8, d7, d14
	vcvt.u32.f64	s12, d6
	vcvt.u32.f64	s15, d8
	vcvt.f64.u32	d6, s12
	vmov	r2, s15	@ int
	vmls.f64	d9, d6, d14
	lsrs	r3, r2, #31
	vmov	s14, r3	@ int
	lsrs	r3, r2, #1
	vcvt.u32.f64	s15, d9
	vmov	s12, r3	@ int
	vmov	ip, s15	@ int
	vcvt.f64.s32	d6, s12
	vcvt.f64.s32	d7, s14
	vmla.f64	d6, d7, d10
	lsr	r3, ip, #31
	vstr.64	d6, [sp, #80]
	and	r2, r2, #1
	vmov	s12, r3	@ int
	lsr	r3, ip, #1
	vmov	s15, r2	@ int
	vmov	s14, r3	@ int
	vmov.f64	d9, d10
	vcvt.f64.s32	d8, s15
	vcvt.f64.s32	d6, s12
	vcvt.f64.s32	d7, s14
	vmla.f64	d7, d6, d9
	and	r3, ip, #1
	vldr.64	d10, [sp, #40]
	vstr.64	d7, [sp, #64]
	vmov	s15, r3	@ int
	vmla.f64	d10, d8, d9
	vcvt.f64.s32	d7, s15
	vmov.f64	d8, d9
	vldr.64	d9, [sp, #32]
	vmla.f64	d9, d7, d8
	vstr.64	d9, [sp, #72]
	vldr.64	d9, [sp, #24]
	vmul.f64	d7, d9, d15
	vcvt.u32.f64	s14, d7
	vcvt.f64.u32	d7, s14
	vmul.f64	d6, d13, d15
	vmls.f64	d9, d7, d14
	vcvt.u32.f64	s12, d6
	vcvt.u32.f64	s15, d9
	vcvt.f64.u32	d6, s12
	vmov	r2, s15	@ int
	vmls.f64	d13, d6, d14
	lsrs	r3, r2, #31
	vmov	s12, r3	@ int
	lsrs	r3, r2, #1
	vcvt.u32.f64	s15, d13
	vmov	s14, r3	@ int
	vmov	ip, s15	@ int
	vcvt.f64.s32	d7, s14
	vcvt.f64.s32	d6, s12
	vstr.64	d10, [sp, #88]
	and	r2, r2, #1
	vmov.f64	d10, d7
	vmov	s15, r2	@ int
	lsr	r3, ip, #31
	vmla.f64	d10, d6, d8
	vmov	s12, r3	@ int
	lsr	r3, ip, #1
	vmov.f64	d9, d8
	vldr.64	d13, [sp, #56]
	vcvt.f64.s32	d8, s15
	vmov	s14, r3	@ int
	vmla.f64	d13, d8, d9
	vcvt.f64.s32	d7, s14
	and	r3, ip, #1
	vstr.64	d13, [sp, #56]
	vmov.f64	d13, d7
	vmov	s15, r3	@ int
	vstr.64	d10, [sp, #48]
	vcvt.f64.s32	d7, s15
	vldr.64	d10, [sp, #16]
	vcvt.f64.s32	d6, s12
	vmla.f64	d10, d7, d9
	vmul.f64	d7, d4, d15
	vmla.f64	d13, d6, d9
	vcvt.u32.f64	s14, d7
	vstr.64	d13, [sp, #40]
	vcvt.f64.u32	d7, s14
	vldr.64	d13, [sp, #8]
	vmls.f64	d4, d7, d14
	vmul.f64	d6, d13, d15
	vcvt.u32.f64	s15, d4
	vcvt.u32.f64	s12, d6
	vmov	r2, s15	@ int
	vcvt.f64.u32	d7, s12
	vmls.f64	d13, d7, d14
	lsrs	r3, r2, #31
	vcvt.u32.f64	s15, d13
	vmov	s12, r3	@ int
	lsrs	r3, r2, #1
	vmov	s16, r3	@ int
	vmov	ip, s15	@ int
	vcvt.f64.s32	d6, s12
	vcvt.f64.s32	d8, s16
	lsr	r3, ip, #31
	vmla.f64	d8, d6, d9
	and	r2, r2, #1
	vmov	s12, r3	@ int
	lsr	r3, ip, #1
	vmov	s15, r2	@ int
	vmov	s14, r3	@ int
	vcvt.f64.s32	d4, s15
	vcvt.f64.s32	d7, s14
	and	r3, ip, #1
	vmla.f64	d12, d4, d9
	vmov.f64	d4, d7
	vmov	s15, r3	@ int
	vstr.64	d12, [sp, #16]
	vcvt.f64.s32	d7, s15
	vldr.64	d12, [sp, #96]
	vmla.f64	d12, d7, d9
	vmul.f64	d7, d5, d15
	vcvt.u32.f64	s14, d7
	vcvt.f64.u32	d7, s14
	vmls.f64	d5, d7, d14
	vcvt.u32.f64	s14, d5
	vmov	r3, s14	@ int
	vcvt.f64.s32	d6, s12
	lsrs	r3, r3, #31
	vmla.f64	d4, d6, d9
	vmov	s14, r3	@ int
	vstr.64	d4, [sp]
	vcvt.f64.s32	d7, s14
	vstr.64	d10, [sp, #32]
	vstr.64	d12, [sp, #8]
	vstr.64	d5, [sp, #360]
	vmul.f64	d5, d5, d15
	add	r0, sp, #280
.LBI4365:
.LBI4367:
.LBI4883:
.LBI4885:
.LBI4887:
.LBI4702:
.LBI4704:
.LBI4940:
.LBI4942:
.LBI4944:
.LBI4626:
.LBI4628:
.LBI4733:
.LBI4735:
.LBI4737:
.LBI4677:
.LBI4679:
.LBI4814:
.LBI4816:
.LBI4818:
.LBI4576:
.LBI4578:
.LBI5021:
.LBI5023:
.LBI5025:
.LBI4650:
.LBI4652:
.LBI5084:
.LBI5086:
.LBI5088:
.LBI4553:
.LBI4555:
.LBI5160:
.LBI5162:
.LBI5164:
.LBI4600:
.LBI4602:
.LBI5241:
.LBI5243:
.LBI5245:
.LBI4388:
.LBI4395:
.LBI4390:
.LBI4514:
.LBI4515:
.LBI4517:
.LBI4412:
.LBI4414:
.LBI4425:
.LBI4435:
.LBI4437:
.LBI4462:
	vstr.64	d7, [sp, #392]
	vstr.64	d5, [sp, #376]
	vstr.64	d11, [sp, #384]
	bl	fp64e_cmul_prepared
	vldr.32	s15, [r6, #24]	@ int
	ldr	r3, [r6, #20]
	vcvt.f64.u32	d5, s15
	lsrs	r3, r3, #31
	vldr.32	s15, [r6, #28]	@ int
	vmov	s8, r3	@ int
	vcvt.f64.u32	d6, s15
	vcvt.f64.s32	d4, s8
	vsub.f64	d5, d14, d5
	vstr.64	d4, [sp, #312]
	vsub.f64	d6, d14, d6
	vmov.f64	d4, #1.0e+0
	vldr.32	s15, [r6, #16]	@ int
	vsub.f64	d6, d6, d4
	vmul.f64	d4, d5, d15
	vmov.f64	d12, d0
	vcvt.u32.f64	s8, d4
	vmov.f64	d0, d8
	vcvt.f64.u32	d8, s15
	vldr.32	s15, [r6, #20]	@ int
	vcvt.f64.u32	d4, s8
	vcvt.f64.u32	d7, s15
	vadd.f64	d6, d6, d4
	vmul.f64	d11, d7, d15
	vstr.64	d11, [sp, #296]
	vmul.f64	d11, d6, d15
	vcvt.u32.f64	s22, d11
	vmls.f64	d5, d4, d14
	vcvt.f64.u32	d11, s22
	vadd.f64	d4, d5, d8
	vmls.f64	d6, d11, d14
	vstr.64	d5, [sp, #328]
	vmul.f64	d5, d5, d15
	vstr.64	d5, [sp, #344]
	vcvt.u32.f64	s11, d6
	vmov	r3, s11	@ int
	vstr.64	d7, [sp, #280]
	vstr.64	d6, [sp, #320]
	vadd.f64	d7, d6, d7
	vmul.f64	d6, d6, d15
	lsrs	r3, r3, #31
	vstr.64	d6, [sp, #336]
	vmov	s12, r3	@ int
	vcvt.f64.s32	d6, s12
	vstr.64	d6, [sp, #352]
	vmul.f64	d6, d4, d15
	vcvt.u32.f64	s12, d6
	vcvt.f64.u32	d6, s12
	vadd.f64	d7, d7, d6
	vmls.f64	d4, d6, d14
	vmul.f64	d6, d7, d15
	vcvt.u32.f64	s12, d6
	vcvt.f64.u32	d6, s12
	vmls.f64	d7, d6, d14
	vcvt.u32.f64	s13, d7
	vmov	r3, s13	@ int
	vstr.64	d7, [sp, #360]
	vmul.f64	d7, d7, d15
	lsrs	r3, r3, #31
	vstr.64	d7, [sp, #376]
	vmov	s14, r3	@ int
	vmov.f64	d9, d3
	vmov.f64	d10, d1
	vmov.f64	d13, d2
	vcvt.f64.s32	d7, s14
	vstr.64	d8, [sp, #288]
	vstr.64	d4, [sp, #368]
	vmul.f64	d8, d8, d15
	vmul.f64	d4, d4, d15
	vldr.64	d2, [sp]
	vldr.64	d1, [sp, #16]
	vldr.64	d3, [sp, #8]
	vstr.64	d7, [sp, #392]
	vstr.64	d12, [sp, #184]
	vstr.64	d10, [sp, #192]
	vstr.64	d13, [sp, #200]
	vstr.64	d9, [sp, #208]
.LBI5582:
.LBI5593:
.LBI5584:
.LBI5668:
.LBI5669:
.LBI5671:
	vstr.64	d8, [sp, #304]
.LBI5609:
.LBI5610:
.LBI5633:
.LBI5624:
.LBI5626:
.LBI5644:
	vstr.64	d4, [sp, #384]
	bl	fp64e_cmul_prepared
	vldr.32	s15, [r7, #8]	@ int
	vldr.32	s11, [r7]	@ int
	ldr	r3, [r7, #4]
	vcvt.f64.u32	d4, s11
	lsrs	r3, r3, #31
	vldr.32	s11, [r7, #4]	@ int
	vcvt.f64.u32	d6, s15
	vmov	s10, r3	@ int
	vldr.32	s15, [r7, #12]	@ int
	vcvt.f64.u32	d8, s11
	vcvt.f64.u32	d7, s15
	vcvt.f64.s32	d5, s10
	vsub.f64	d11, d14, d6
	vstr.64	d5, [sp, #312]
	vsub.f64	d7, d14, d7
	b	.L70
.L71:
	.align	3
.L69:
	.word	0
	.word	1105199104
	.word	0
	.word	0
.L70:
	vmov.f64	d5, #1.0e+0
	vstr.64	d11, [sp, #24]
	vsub.f64	d11, d7, d5
	vldr.64	d6, [sp, #88]
	vstr.64	d11, [sp, #104]
	vldr.64	d11, [sp, #56]
	vadd.f64	d7, d6, d14
	vadd.f64	d6, d11, d6
	vldr.64	d5, [sp, #32]
	vstr.64	d6, [sp, #56]
	vldr.64	d6, [sp, #72]
	vsub.f64	d7, d7, d11
	vadd.f64	d11, d6, d14
	vadd.f64	d6, d5, d6
	vstr.64	d6, [sp, #16]
	vadd.f64	d6, d10, d14
	vstr.64	d1, [sp, #224]
	vadd.f64	d10, d10, d1
	vsub.f64	d1, d6, d1
	vadd.f64	d6, d9, d14
	vstr.64	d0, [sp, #216]
	vstr.64	d2, [sp, #232]
	vstr.64	d3, [sp, #240]
.LBI5876:
	vstr.64	d8, [sp]
	vstr.64	d8, [sp, #280]
	vstr.64	d4, [sp, #288]
	vstr.64	d1, [sp, #32]
	vstr.64	d7, [sp, #8]
	vadd.f64	d1, d9, d3
	vsub.f64	d9, d6, d3
	vldr.64	d3, [sp, #80]
	vldr.64	d8, [sp, #48]
	vsub.f64	d11, d11, d5
	vmul.f64	d6, d7, d15
	vadd.f64	d5, d3, d14
	vmov.f64	d7, #1.0e+0
	vsub.f64	d5, d5, d8
	vcvt.u32.f64	s12, d6
	vadd.f64	d3, d8, d3
	vcvt.f64.u32	d6, s12
	vmov.f64	d8, d7
	vsub.f64	d5, d5, d7
	vldr.64	d7, [sp, #8]
	vmls.f64	d7, d6, d14
	vadd.f64	d5, d5, d6
	vadd.f64	d7, d7, d8
	vstr.64	d5, [sp, #48]
	vstr.64	d7, [sp, #80]
	vldr.64	d5, [sp, #64]
	vmul.f64	d7, d11, d15
	vldr.64	d8, [sp, #40]
	vadd.f64	d6, d5, d14
	vcvt.u32.f64	s14, d7
	vadd.f64	d5, d8, d5
	vsub.f64	d6, d6, d8
	vcvt.f64.u32	d7, s14
	vmov.f64	d8, #1.0e+0
	vmls.f64	d11, d7, d14
	vsub.f64	d6, d6, d8
	vadd.f64	d11, d11, d8
	vadd.f64	d7, d6, d7
	vldr.64	d8, [sp, #56]
	vstr.64	d7, [sp, #40]
	vmul.f64	d7, d8, d15
	vldr.64	d6, [sp, #16]
	vcvt.u32.f64	s14, d7
	vmul.f64	d6, d6, d15
	vcvt.f64.u32	d7, s14
	vstr.64	d11, [sp, #72]
	vcvt.u32.f64	s12, d6
	vadd.f64	d11, d3, d7
.LBI5878:
.LBI6202:
.LBI6204:
	vmov.f64	d3, d8
	vmls.f64	d3, d7, d14
	vcvt.f64.u32	d7, s12
	vldr.64	d6, [sp, #16]
	vmov.f64	d8, #1.0e+0
	vmls.f64	d6, d7, d14
	vadd.f64	d3, d3, d8
	vadd.f64	d6, d6, d8
	vstr.64	d3, [sp, #96]
	vstr.64	d6, [sp, #88]
	vadd.f64	d3, d5, d7
	vmul.f64	d6, d1, d15
	vmul.f64	d7, d10, d15
	vcvt.u32.f64	s12, d6
	vcvt.u32.f64	s14, d7
	vstr.64	d3, [sp, #56]
	vcvt.f64.u32	d7, s14
	vcvt.f64.u32	d3, s12
	vmls.f64	d10, d7, d14
	vmls.f64	d1, d3, d14
	vadd.f64	d10, d10, d8
	vadd.f64	d6, d1, d8
	vldr.64	d8, [sp, #32]
	vstr.64	d6, [sp, #64]
	vmul.f64	d6, d8, d15
	vadd.f64	d5, d12, d14
	vcvt.u32.f64	s12, d6
	vadd.f64	d12, d12, d0
	vcvt.f64.u32	d6, s12
	vadd.f64	d1, d12, d7
	vsub.f64	d5, d5, d0
	vmov.f64	d7, #1.0e+0
	vmov.f64	d12, d8
	vsub.f64	d5, d5, d7
	vmls.f64	d12, d6, d14
	vadd.f64	d0, d5, d6
	vadd.f64	d12, d12, d7
	vmov.f64	d5, d7
	vmul.f64	d7, d9, d15
	vcvt.u32.f64	s14, d7
	vadd.f64	d6, d13, d14
	vcvt.f64.u32	d7, s14
	vadd.f64	d13, d2, d13
	vmls.f64	d9, d7, d14
	vsub.f64	d6, d6, d2
	vldr.64	d8, [sp, #24]
	vsub.f64	d6, d6, d5
	vadd.f64	d3, d13, d3
	vadd.f64	d13, d9, d5
	vadd.f64	d2, d6, d7
	vstr.64	d13, [sp, #16]
	vmul.f64	d7, d8, d15
	vldr.64	d13, [sp, #48]
	vcvt.u32.f64	s14, d7
	vmul.f64	d6, d13, d15
	vcvt.f64.u32	d7, s14
	vcvt.u32.f64	s11, d6
	vldr.64	d6, [sp, #104]
	vadd.f64	d9, d6, d7
	vmov.f64	d6, d8
	vmls.f64	d6, d7, d14
	vcvt.f64.u32	d7, s11
	vmov.f64	d5, d13
	vldr.64	d8, .L69+8
	vstr.64	d12, [sp, #8]
	vmls.f64	d5, d7, d14
	vldr.64	d12, [sp, #40]
	vadd.f64	d5, d5, d8
	vmul.f64	d7, d12, d15
	vstr.64	d5, [sp, #32]
	vcvt.u32.f64	s14, d7
	vmul.f64	d5, d11, d15
	vcvt.f64.u32	d7, s14
	vcvt.u32.f64	s10, d5
	vmls.f64	d12, d7, d14
	vcvt.f64.u32	d7, s10
	vldr.64	d13, [sp, #56]
	vmls.f64	d11, d7, d14
	vadd.f64	d7, d12, d8
	vmov.f64	d12, d7
	vmul.f64	d7, d13, d15
	vmul.f64	d5, d1, d15
	vcvt.u32.f64	s14, d7
	vcvt.u32.f64	s10, d5
	vcvt.f64.u32	d7, s14
	vmls.f64	d13, d7, d14
	vcvt.f64.u32	d7, s10
	vmls.f64	d1, d7, d14
	vadd.f64	d7, d13, d8
	vstr.64	d7, [sp, #24]
	vmul.f64	d7, d3, d15
	vadd.f64	d1, d1, d8
	vmul.f64	d5, d0, d15
	vcvt.u32.f64	s14, d7
	vstr.64	d1, [sp, #48]
	vcvt.f64.u32	d7, s14
	vcvt.u32.f64	s3, d5
	vmls.f64	d3, d7, d14
	vcvt.f64.u32	d7, s3
	vmls.f64	d0, d7, d14
	vmul.f64	d7, d2, d15
	vadd.f64	d3, d3, d8
	vmul.f64	d5, d9, d15
	vcvt.u32.f64	s14, d7
	vstr.64	d3, [sp, #104]
	vcvt.f64.u32	d7, s14
	vcvt.u32.f64	s7, d5
	vmls.f64	d2, d7, d14
	vcvt.f64.u32	d7, s7
	vmls.f64	d9, d7, d14
	vcvt.u32.f64	s14, d9
	vmov	r3, s14	@ int
	lsrs	r3, r3, #31
	vmov	s14, r3	@ int
	vadd.f64	d3, d6, d4
	vadd.f64	d2, d2, d8
	vcvt.f64.s32	d7, s14
	vmul.f64	d4, d4, d15
	vstr.64	d6, [sp, #328]
	vstr.64	d2, [sp, #112]
	vstr.64	d9, [sp, #320]
	vstr.64	d7, [sp, #352]
	vstr.64	d4, [sp, #304]
	vldr.64	d2, [sp, #80]
	vldr.64	d1, [sp, #72]
	vmul.f64	d7, d2, d15
	vmul.f64	d6, d6, d15
	vcvt.u32.f64	s14, d7
	vstr.64	d6, [sp, #344]
	vmul.f64	d6, d1, d15
	vcvt.f64.u32	d7, s14
	vcvt.u32.f64	s11, d6
	vldr.64	d4, [sp, #32]
	vmov.f64	d6, d2
	vadd.f64	d4, d4, d7
	vmls.f64	d6, d7, d14
	vcvt.f64.u32	d7, s11
	vmov.f64	d5, d1
	vadd.f64	d0, d0, d8
	vadd.f64	d11, d11, d8
	vmls.f64	d5, d7, d14
	vmov.f64	d8, #5.0e-1
	vadd.f64	d2, d12, d7
	vmul.f64	d6, d6, d8
	vldr.64	d12, [sp, #96]
	vmul.f64	d5, d5, d8
	vldr.64	d13, [sp, #88]
	vmul.f64	d7, d12, d15
	vcvt.u32.f64	s12, d6
	vcvt.u32.f64	s10, d5
	vcvt.f64.u32	d1, s12
	vcvt.f64.u32	d5, s10
	vmul.f64	d6, d13, d15
	vcvt.u32.f64	s14, d7
	vstr.64	d5, [sp, #96]
	vcvt.f64.u32	d7, s14
	vcvt.u32.f64	s11, d6
	vmov.f64	d6, d12
	vadd.f64	d11, d11, d7
.LBI6206:
	vmls.f64	d6, d7, d14
	vcvt.f64.u32	d7, s11
	vldr.64	d5, [sp, #24]
	vmul.f64	d6, d6, d8
	vadd.f64	d5, d5, d7
	vcvt.u32.f64	s12, d6
	vstr.64	d5, [sp, #32]
	vmov.f64	d5, d13
	vmls.f64	d5, d7, d14
	vcvt.f64.u32	d7, s12
	vldr.64	d12, [sp, #64]
	vstr.64	d7, [sp, #40]
	vmul.f64	d7, d10, d15
	vmul.f64	d5, d5, d8
	vmul.f64	d6, d12, d15
	vcvt.u32.f64	s14, d7
	vcvt.u32.f64	s10, d5
	vcvt.f64.u32	d7, s14
	vcvt.u32.f64	s11, d6
	vldr.64	d6, [sp, #48]
	vmls.f64	d10, d7, d14
	vadd.f64	d6, d6, d7
	vstr.64	d6, [sp, #24]
	vmul.f64	d6, d10, d8
	vcvt.f64.u32	d7, s11
	vcvt.f64.u32	d13, s10
	vcvt.u32.f64	s12, d6
	vmov.f64	d5, d12
	vcvt.f64.u32	d12, s12
	vmls.f64	d5, d7, d14
	vldr.64	d10, [sp, #104]
	vmul.f64	d5, d5, d8
	vstr.64	d12, [sp, #72]
	vldr.64	d12, [sp, #8]
	vadd.f64	d10, d10, d7
	vstr.64	d13, [sp, #56]
	vmul.f64	d7, d12, d15
	vldr.64	d13, [sp, #16]
	vcvt.u32.f64	s10, d5
	vmul.f64	d6, d13, d15
	vcvt.f64.u32	d12, s10
	vcvt.u32.f64	s14, d7
	vstr.64	d12, [sp, #80]
	vcvt.f64.u32	d7, s14
	vcvt.u32.f64	s12, d6
	vldr.64	d12, [sp, #8]
	vadd.f64	d5, d0, d7
	vmls.f64	d12, d7, d14
	vcvt.f64.u32	d7, s12
	vldr.64	d0, [sp, #112]
	vmls.f64	d13, d7, d14
	vmul.f64	d6, d12, d8
	vmul.f64	d13, d13, d8
	vadd.f64	d12, d0, d7
	vmul.f64	d7, d3, d15
	vcvt.u32.f64	s12, d6
	vldr.64	d8, [sp]
	vcvt.u32.f64	s13, d13
	vcvt.u32.f64	s14, d7
	vcvt.f64.u32	d0, s13
	vcvt.f64.u32	d7, s14
	vcvt.f64.u32	d13, s12
	vadd.f64	d6, d9, d8
	vmul.f64	d8, d8, d15
	vmls.f64	d3, d7, d14
	vstr.64	d8, [sp, #296]
	vadd.f64	d8, d6, d7
	vmul.f64	d7, d4, d15
	vcvt.u32.f64	s14, d7
	vcvt.f64.u32	d7, s14
	vmul.f64	d6, d2, d15
	vmls.f64	d4, d7, d14
	vcvt.u32.f64	s12, d6
	vcvt.u32.f64	s15, d4
	vcvt.f64.u32	d6, s12
	vmov	r2, s15	@ int
	vmls.f64	d2, d6, d14
	lsrs	r3, r2, #31
	vcvt.u32.f64	s15, d2
	vmov	s14, r3	@ int
	lsrs	r3, r2, #1
	vstr.64	d0, [sp, #88]
	vmul.f64	d9, d9, d15
	vmov	s0, r3	@ int
	vmov	ip, s15	@ int
	vstr.64	d9, [sp, #336]
	vcvt.f64.s32	d7, s14
	vldr.64	d9, .L72
	vcvt.f64.s32	d0, s0
	lsr	r3, ip, #31
	vmla.f64	d0, d7, d9
	and	r2, r2, #1
	vmov	s14, r3	@ int
	lsr	r3, ip, #1
	vmov	s15, r2	@ int
	vmov	s4, r3	@ int
	vcvt.f64.s32	d6, s15
	vcvt.f64.s32	d2, s4
	vcvt.f64.s32	d7, s14
	and	r3, ip, #1
	vmla.f64	d2, d7, d9
	vstr.64	d3, [sp, #368]
	vmov	s15, r3	@ int
	vmul.f64	d3, d3, d15
	vcvt.f64.s32	d7, s15
	vstr.64	d3, [sp, #384]
	vldr.64	d3, [sp, #96]
	vmla.f64	d3, d7, d9
	vmul.f64	d7, d11, d15
	vcvt.u32.f64	s14, d7
	vldr.64	d4, [sp, #32]
	vcvt.f64.u32	d7, s14
	vmla.f64	d1, d6, d9
	vmls.f64	d11, d7, d14
	vmul.f64	d6, d4, d15
	vcvt.u32.f64	s15, d11
	vcvt.u32.f64	s12, d6
	vmov	r2, s15	@ int
	vcvt.f64.u32	d7, s12
	vmov.f64	d6, d4
	vmls.f64	d6, d7, d14
	lsrs	r3, r2, #31
	vcvt.u32.f64	s15, d6
	vmov	s12, r3	@ int
	lsrs	r3, r2, #1
	vmov	s8, r3	@ int
	vcvt.f64.s32	d6, s12
	vcvt.f64.s32	d4, s8
	and	r2, r2, #1
	vmov	lr, s15	@ int
	vmla.f64	d4, d6, d9
	vmov	s15, r2	@ int
	vstr.64	d4, [sp, #96]	@ int
	vcvt.f64.s32	d7, s15
	vldr.64	d4, [sp, #40]
	lsr	r3, lr, #31
	lsr	ip, lr, #1
.LBI5905:
.LBI5907:
.LBI6268:
.LBI6270:
.LBI6272:
	vmla.f64	d4, d7, d9
	vmov	s12, r3	@ int
	vmov	s15, ip	@ int
	vcvt.f64.s32	d6, s12
	vcvt.f64.s32	d7, s15
	vmla.f64	d7, d6, d9
	and	r3, lr, #1
	vstr.64	d4, [sp, #64]
	vstr.64	d7, [sp, #48]
.LBI5848:
.LBI5850:
.LBI6059:
.LBI6061:
.LBI6063:
.LBI5933:
.LBI5935:
.LBI6126:
.LBI6128:
.LBI6130:
.LBI5983:
.LBI5985:
.LBI6346:
.LBI6348:
.LBI6350:
	vmov	s15, r3	@ int
	vldr.64	d6, [sp, #24]
	vldr.64	d11, [sp, #56]
	vcvt.f64.s32	d7, s15
	vmla.f64	d11, d7, d9
	vmul.f64	d7, d6, d15
	vcvt.u32.f64	s14, d7
	vcvt.f64.u32	d7, s14
	vmov.f64	d4, d9
	vmul.f64	d9, d10, d15
	vmls.f64	d6, d7, d14
	vcvt.u32.f64	s18, d9
	vcvt.u32.f64	s15, d6
	vcvt.f64.u32	d9, s18
	vmov	r2, s15	@ int
	vmls.f64	d10, d9, d14
	lsrs	r3, r2, #31
	vmov	s12, r3	@ int
	lsrs	r3, r2, #1
	vcvt.u32.f64	s15, d10
	vmov	s14, r3	@ int
	vmov	lr, s15	@ int
	vcvt.f64.s32	d7, s14
	and	r2, r2, #1
	vmov.f64	d10, d7
	vmov	s15, r2	@ int
	vcvt.f64.s32	d6, s12
	vcvt.f64.s32	d7, s15
	vldr.64	d9, [sp, #72]
	lsr	r3, lr, #31
	lsr	ip, lr, #1
.LBI6029:
.LBI6031:
.LBI6399:
.LBI6401:
.LBI6403:
.LBI5963:
.LBI5965:
.LBI6473:
.LBI6475:
.LBI6477:
	vmla.f64	d10, d6, d4
	vmla.f64	d9, d7, d4
	vmov	s12, r3	@ int
	vmov	s15, ip	@ int
	vcvt.f64.s32	d6, s12
	vcvt.f64.s32	d7, s15
	vmla.f64	d7, d6, d4
	and	r3, lr, #1
	vstr.64	d7, [sp, #16]
	vmov	s15, r3	@ int
	vldr.64	d6, [sp, #80]
	vcvt.f64.s32	d7, s15
	vmla.f64	d6, d7, d4
	vmul.f64	d7, d5, d15
	vcvt.u32.f64	s14, d7
	vcvt.f64.u32	d7, s14
	vstr.64	d6, [sp, #24]
	vmul.f64	d6, d12, d15
	vmls.f64	d5, d7, d14
	vcvt.u32.f64	s12, d6
	vcvt.u32.f64	s15, d5
	vcvt.f64.u32	d6, s12
	vmov	r3, s15	@ int
	vmls.f64	d12, d6, d14
	lsrs	r2, r3, #31
	vmov	s14, r2	@ int
	lsrs	r2, r3, #1
	vstr.64	d10, [sp, #32]
	vcvt.u32.f64	s15, d12
	vmov	s20, r2	@ int
	vmov	lr, s15	@ int
	vcvt.f64.s32	d10, s20
	vcvt.f64.s32	d7, s14
	and	r3, r3, #1
	vmla.f64	d10, d7, d4
	vmov	s15, r3	@ int
	lsr	r2, lr, #1
	vstr.64	d9, [sp, #40]
	lsr	ip, lr, #31
	vmov	s18, r2	@ int
.LBI6004:
.LBI6006:
.LBI6530:
.LBI6532:
.LBI6534:
	and	r2, lr, #1
	vmov	s14, r2	@ int
	vcvt.f64.s32	d6, s15
	vmov	s15, ip	@ int
	vmla.f64	d13, d6, d4
	vldr.64	d5, [sp, #88]
	vcvt.f64.s32	d6, s15
	vcvt.f64.s32	d7, s14
	vmla.f64	d5, d7, d4
	vmul.f64	d7, d8, d15
	vcvt.u32.f64	s14, d7
	vcvt.f64.u32	d7, s14
	vmls.f64	d8, d7, d14
	vcvt.u32.f64	s14, d8
	vmov	r3, s14	@ int
	lsrs	r3, r3, #31
	vmov	s14, r3	@ int
	vstr.64	d8, [sp, #360]
	vcvt.f64.s32	d7, s14
	vmul.f64	d8, d8, d15
	vcvt.f64.s32	d9, s18
	vstr.64	d5, [sp]
	vmla.f64	d9, d6, d4
.LBI5720:
.LBI5728:
.LBI5722:
.LBI5813:
.LBI5814:
.LBI5816:
.LBI5746:
.LBI5747:
.LBI5760:
.LBI5767:
.LBI5769:
.LBI5795:
	vstr.64	d7, [sp, #392]
	vstr.64	d11, [sp, #56]
	vstr.64	d13, [sp, #8]
	vstr.64	d8, [sp, #376]
	bl	fp64e_cmul_prepared
	vmov.f64	d11, d0
	vmov.f64	d13, d1
	vmov.f64	d12, d2
	vmov.f64	d8, d3
	vmov.f64	d0, d10
	vmov.f64	d2, d9
	vldr.64	d3, [sp]
	vldr.64	d1, [sp, #8]
	vstr.64	d11, [sp, #120]
	vstr.64	d13, [sp, #128]
	vstr.64	d12, [sp, #136]
	vstr.64	d8, [sp, #144]
	bl	fp64e_cmul_prepared
	vldr.64	d4, [sp, #96]	@ int
	vldr.64	d7, [sp, #56]
	vstr.64	d4, [r1]
	vldr.64	d4, [sp, #64]
	vldr.64	d5, [sp, #48]
	vldr.64	d10, [sp, #32]
	vldr.64	d9, [sp, #40]
	vstr.64	d4, [r1, #8]
	vldr.64	d6, [sp, #24]
	vstr.64	d7, [r4, #8]
	vldr.64	d7, [sp, #16]
	vstr.64	d5, [r4]
	adds	r1, r1, #64
	vstr.64	d10, [r1, #-48]
	vstr.64	d9, [r1, #-40]
	cmp	r8, r1
	vstr.64	d7, [r4, #16]
	vstr.64	d6, [r4, #24]
	vstr.64	d0, [sp, #152]
	vstr.64	d11, [r1, #-32]
	vstr.64	d13, [r1, #-24]
	add	r4, r4, #64
	vstr.64	d12, [r4, #-32]
	vstr.64	d8, [r4, #-24]
	add	r6, r6, #32
	vstr.64	d0, [r1, #-16]
	vstr.64	d1, [r1, #-8]
	add	r7, r7, #16
	vstr.64	d1, [sp, #160]
	vstr.64	d2, [r4, #-16]
	vstr.64	d3, [r4, #-8]
	vstr.64	d2, [sp, #168]
	vstr.64	d3, [sp, #176]
	bne	.L51
	mov	lr, #4
	sub	r1, fp, #3
.L50:
	cmp	r1, #0
	beq	.L49
	movs	r3, #16
	vldr.64	d14, .L72+8
	vldr.64	d15, .L72+16
	vldr.64	d9, .L72
	ldr	r6, .L72+24
	lsl	ip, r3, r10
.L56:
	mov	r2, lr
	movs	r3, #1
	mov	r8, #16
	add	r7, r5, r2, lsl #4
	str	r2, [sp, #32]
	vmov.f64	d13, #1.0e+0
	mov	r2, r5
	mov	fp, #0
	mov	r9, ip
	lsls	r3, r3, r1
	add	r3, r3, r3, lsr #1
	lsl	lr, lr, #1
	lsl	r8, r8, r1
	add	r3, r6, r3, lsl #4
	add	r10, r8, r6
	str	r3, [sp, #24]
	str	r1, [sp, #40]
	str	lr, [sp, #16]
	lsl	r8, lr, #4
	str	r6, [sp, #48]
	str	r5, [sp, #56]
	b	.L73
.L74:
	.align	3
.L72:
	.word	0
	.word	1105199104
	.word	0
	.word	1106247680
	.word	0
	.word	1039138816
	.word	fndsa_kgen_GM_TAB
.L73:
.L55:
.LBI7273:
	vldr.32	s15, [r10, #8]	@ int
	ldr	r3, [r10, #4]
	vcvt.f64.u32	d4, s15
.LBI7282:
	lsrs	r3, r3, #31
	vmov	s6, r3	@ int
	vsub.f64	d4, d14, d4
	vcvt.f64.s32	d3, s6
	vldr.32	s15, [r10, #12]	@ int
	vstr.64	d3, [sp, #312]
	vcvt.f64.u32	d7, s15
	vmul.f64	d3, d4, d15
	vsub.f64	d7, d14, d7
	vcvt.u32.f64	s6, d3
	vldr.32	s13, [r10]	@ int
	vcvt.f64.u32	d3, s6
	vsub.f64	d7, d7, d13
	vcvt.f64.u32	d5, s13
.LBI7275:
.LBI6849:
.LBI6850:
	vadd.f64	d7, d7, d3
.LBI6852:
	vldr.32	s13, [r10, #4]	@ int
	vmls.f64	d4, d3, d14
	vcvt.f64.u32	d6, s13
	vmul.f64	d3, d7, d15
	vmul.f64	d2, d6, d15
	vmul.f64	d1, d5, d15
	vstr.64	d5, [sp, #288]
	vcvt.u32.f64	s6, d3
	vadd.f64	d5, d4, d5
	vcvt.f64.u32	d3, s6
	vstr.64	d2, [sp, #296]
	vstr.64	d4, [sp, #328]
	vmul.f64	d2, d4, d15
	vmul.f64	d4, d5, d15
	vmls.f64	d7, d3, d14
	vcvt.u32.f64	s8, d4
	vcvt.u32.f64	s7, d7
	vcvt.f64.u32	d4, s8
	vstr.64	d6, [sp, #280]
	vadd.f64	d6, d7, d6
	vmov	r1, s7	@ int
	vstr.64	d7, [sp, #320]
	vmul.f64	d3, d7, d15
	vadd.f64	d7, d6, d4
	vmul.f64	d6, d7, d15
	vcvt.u32.f64	s12, d6
	vcvt.f64.u32	d6, s12
	vmls.f64	d7, d6, d14
	vcvt.u32.f64	s13, d7
	lsrs	r1, r1, #31
	vmls.f64	d5, d4, d14
	vmov	s8, r1	@ int
	vmov	r1, s13	@ int
	lsrs	r1, r1, #31
	vmul.f64	d6, d7, d15
	vstr.64	d7, [sp, #360]
	vmov	s14, r1	@ int
	vstr.64	d2, [sp, #344]
	vcvt.f64.s32	d4, s8
	vmul.f64	d2, d5, d15
	vcvt.f64.s32	d7, s14
	ldr	r3, [sp, #32]
	vstr.64	d1, [sp, #304]
.LBI7302:
.LBI7304:
.LBI7328:
.LBI7315:
.LBI7317:
	add	r3, fp, r3
	cmp	fp, r3
	vstr.64	d3, [sp, #336]
.LBI7346:
	vstr.64	d5, [sp, #368]
	vstr.64	d4, [sp, #352]
	vstr.64	d2, [sp, #384]
	vstr.64	d6, [sp, #376]
	vstr.64	d7, [sp, #392]
	bcs	.L53
	mov	r6, r7
	mov	r1, r2
	add	r5, r9, r2
	add	r4, r9, r7
	str	r2, [sp, #8]
.L54:
	vldr.64	d10, [r1, #8]
	vldr.64	d7, [r6, #8]
	vadd.f64	d0, d10, d14
	vldr.64	d12, [r1]
	vadd.f64	d10, d7, d10
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
	vldr.64	d4, .L75
	vadd.f64	d11, d11, d5
	vsub.f64	d2, d2, d5
	vadd.f64	d3, d3, d4
	vcvt.f64.u32	d5, s1
	vldr.64	d8, [r4]
	vldr.64	d6, [r5]
.LBI6940:
.LBI6942:
.LBI6986:
.LBI6988:
	vadd.f64	d3, d3, d5
	vadd.f64	d4, d6, d14
	vmul.f64	d0, d3, d15
	vadd.f64	d6, d6, d8
	vmls.f64	d7, d5, d14
.LBI6990:
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
.LBI7042:
.LBI7044:
.LBI7107:
.LBI7109:
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
	vldr.64	d7, .L75
	vcvt.f64.u32	d4, s7
	vadd.f64	d6, d6, d7
	vadd.f64	d7, d6, d4
	vmul.f64	d5, d10, d15
	vmls.f64	d2, d4, d14
.LBI7111:
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
.LBI6959:
.LBI6961:
.LBI6884:
.LBI6886:
	lsrs	r2, r3, #31
	vmov	s16, r2	@ int
	lsrs	r2, r3, #1
	vmls.f64	d6, d2, d14
	vcvt.u32.f64	s8, d4
	vmov	s4, r2	@ int
	vldr.64	d7, .L75
	vcvt.f64.u32	d4, s8
	vcvt.f64.s32	d8, s16
	vcvt.f64.s32	d2, s4
	vadd.f64	d6, d6, d7
	vmla.f64	d2, d8, d9
	vmov.f64	d10, #5.0e-1
	vmul.f64	d8, d11, d15
	vmls.f64	d5, d4, d14
	vadd.f64	d6, d6, d4
.LBI6888:
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
	vldr.64	d6, .L75
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
.LBI7066:
.LBI7068:
.LBI7214:
.LBI7216:
.LBI7218:
	add	r0, sp, #280
	vstr.64	d6, [r5]
	vstr.64	d5, [r5, #8]
	bl	fp64e_cmul_prepared
	adds	r1, r1, #16
	cmp	r7, r1
	vstr.64	d0, [r6]
	vstr.64	d1, [r6, #8]
	vstr.64	d0, [sp, #248]
	vstr.64	d2, [r4]
	vstr.64	d3, [r4, #8]
	vstr.64	d1, [sp, #256]
	vstr.64	d2, [sp, #264]
	vstr.64	d3, [sp, #272]
	add	r5, r5, #16
	add	r6, r6, #16
	add	r4, r4, #16
	bne	.L54
	ldr	r2, [sp, #8]
.L53:
	ldr	r3, [sp, #16]
	add	r10, r10, #16
	add	fp, fp, r3
	ldr	r3, [sp, #24]
	add	r2, r2, r8
	cmp	r3, r10
	add	r7, r7, r8
	bne	.L55
	ldr	r1, [sp, #40]
	mov	ip, r9
	subs	r1, r1, #1
	ldr	lr, [sp, #16]
	ldr	r6, [sp, #48]
	ldr	r5, [sp, #56]
	bne	.L56
.L49:
	add	sp, sp, #404
	vldm	sp!, {d8-d15}
	pop	{r4, r5, r6, r7, r8, r9, r10, fp, pc}
.L57:
	mov	r1, r10
	mov	lr, #1
	b	.L50
.L76:
	.align	3
.L75:
	.word	0
	.word	0
	.size	fndsa_vect_iFFT_fp64_exact, .-fndsa_vect_iFFT_fp64_exact
.section .note.GNU-stack,"",%progbits
