
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_q32_compat/validation/build/compat-perf/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10006df8 <fndsa_vect_mul_fft_fp64q>:
10006df8:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10006dfc:	ed2d 8b06 	vpush	{d8-d10}
10006e00:	2400      	movs	r4, #0
10006e02:	2308      	movs	r3, #8
10006e04:	2501      	movs	r5, #1
10006e06:	f1a1 0608 	sub.w	r6, r1, #8
10006e0a:	ed9f 9b85 	vldr	d9, [pc, #532]	@ 10007020 <fndsa_vect_mul_fft_fp64q+0x228>
10006e0e:	ed9f 8b86 	vldr	d8, [pc, #536]	@ 10007028 <fndsa_vect_mul_fft_fp64q+0x230>
10006e12:	46b2      	mov	sl, r6
10006e14:	b0a5      	sub	sp, #148	@ 0x94
10006e16:	9408      	str	r4, [sp, #32]
10006e18:	1e44      	subs	r4, r0, #1
10006e1a:	3a08      	subs	r2, #8
10006e1c:	40a3      	lsls	r3, r4
10006e1e:	fa05 f104 	lsl.w	r1, r5, r4
10006e22:	eb03 0906 	add.w	r9, r3, r6
10006e26:	4413      	add	r3, r2
10006e28:	9209      	str	r2, [sp, #36]	@ 0x24
10006e2a:	910d      	str	r1, [sp, #52]	@ 0x34
10006e2c:	930a      	str	r3, [sp, #40]	@ 0x28
10006e2e:	e9fa 0102 	ldrd	r0, r1, [sl, #8]!
10006e32:	460f      	mov	r7, r1
10006e34:	e9f9 2302 	ldrd	r2, r3, [r9, #8]!
10006e38:	e9cd 0114 	strd	r0, r1, [sp, #80]	@ 0x50
10006e3c:	9909      	ldr	r1, [sp, #36]	@ 0x24
10006e3e:	4680      	mov	r8, r0
10006e40:	4614      	mov	r4, r2
10006e42:	4618      	mov	r0, r3
10006e44:	e9cd 2316 	strd	r2, r3, [sp, #88]	@ 0x58
10006e48:	e9f1 2302 	ldrd	r2, r3, [r1, #8]!
10006e4c:	4616      	mov	r6, r2
10006e4e:	ee07 8a90 	vmov	s15, r8
10006e52:	ee06 6a90 	vmov	s13, r6
10006e56:	461d      	mov	r5, r3
10006e58:	eeb8 5b67 	vcvt.f64.u32	d5, s15
10006e5c:	eeb8 4b66 	vcvt.f64.u32	d4, s13
10006e60:	ee06 5a90 	vmov	s13, r5
10006e64:	ee25 0b04 	vmul.f64	d0, d5, d4
10006e68:	ee07 7a90 	vmov	s15, r7
10006e6c:	ee20 3b09 	vmul.f64	d3, d0, d9
10006e70:	eeb8 6b66 	vcvt.f64.u32	d6, s13
10006e74:	eebc abc3 	vcvt.u32.f64	s20, d3
10006e78:	ee26 6b05 	vmul.f64	d6, d6, d5
10006e7c:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10006e80:	eeb8 1b4a 	vcvt.f64.u32	d1, s20
10006e84:	ee27 7b04 	vmul.f64	d7, d7, d4
10006e88:	ee26 4b09 	vmul.f64	d4, d6, d9
10006e8c:	9109      	str	r1, [sp, #36]	@ 0x24
10006e8e:	990a      	ldr	r1, [sp, #40]	@ 0x28
10006e90:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10006e94:	ee21 1b08 	vmul.f64	d1, d1, d8
10006e98:	941e      	str	r4, [sp, #120]	@ 0x78
10006e9a:	e9cd 2318 	strd	r2, r3, [sp, #96]	@ 0x60
10006e9e:	9203      	str	r2, [sp, #12]
10006ea0:	9404      	str	r4, [sp, #16]
10006ea2:	e9f1 2302 	ldrd	r2, r3, [r1, #8]!
10006ea6:	4694      	mov	ip, r2
10006ea8:	461c      	mov	r4, r3
10006eaa:	eeb8 2b44 	vcvt.f64.u32	d2, s8
10006eae:	f8cd c088 	str.w	ip, [sp, #136]	@ 0x88
10006eb2:	9423      	str	r4, [sp, #140]	@ 0x8c
10006eb4:	f8cd c018 	str.w	ip, [sp, #24]
10006eb8:	9407      	str	r4, [sp, #28]
10006eba:	ee10 ca10 	vmov	ip, s0
10006ebe:	ee11 4a10 	vmov	r4, s2
10006ec2:	ee27 5b09 	vmul.f64	d5, d7, d9
10006ec6:	e9cd 231a 	strd	r2, r3, [sp, #104]	@ 0x68
10006eca:	fb06 f208 	mul.w	r2, r6, r8
10006ece:	fb06 fe07 	mul.w	lr, r6, r7
10006ed2:	ee22 2b08 	vmul.f64	d2, d2, d8
10006ed6:	920b      	str	r2, [sp, #44]	@ 0x2c
10006ed8:	910a      	str	r1, [sp, #40]	@ 0x28
10006eda:	ea06 72e7 	and.w	r2, r6, r7, asr #31
10006ede:	ea84 010c 	eor.w	r1, r4, ip
10006ee2:	ee11 6a90 	vmov	r6, s3
10006ee6:	ee10 4a90 	vmov	r4, s1
10006eea:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10006eee:	ee16 ca10 	vmov	ip, s12
10006ef2:	4066      	eors	r6, r4
10006ef4:	ee12 4a10 	vmov	r4, s4
10006ef8:	eeb8 3b45 	vcvt.f64.u32	d3, s10
10006efc:	430e      	orrs	r6, r1
10006efe:	ea84 010c 	eor.w	r1, r4, ip
10006f02:	ee12 4a90 	vmov	r4, s5
10006f06:	ee16 ca90 	vmov	ip, s13
10006f0a:	ee23 3b08 	vmul.f64	d3, d3, d8
10006f0e:	ea84 0c0c 	eor.w	ip, r4, ip
10006f12:	ea4c 0c01 	orr.w	ip, ip, r1
10006f16:	4271      	negs	r1, r6
10006f18:	ee13 4a10 	vmov	r4, s6
10006f1c:	4331      	orrs	r1, r6
10006f1e:	ee17 6a10 	vmov	r6, s14
10006f22:	0fc9      	lsrs	r1, r1, #31
10006f24:	9113      	str	r1, [sp, #76]	@ 0x4c
10006f26:	4066      	eors	r6, r4
10006f28:	ee13 1a90 	vmov	r1, s7
10006f2c:	ee17 4a90 	vmov	r4, s15
10006f30:	4061      	eors	r1, r4
10006f32:	ee1a 4a10 	vmov	r4, s20
10006f36:	4331      	orrs	r1, r6
10006f38:	f1cc 0600 	rsb	r6, ip, #0
10006f3c:	ea46 060c 	orr.w	r6, r6, ip
10006f40:	f1c1 0c00 	rsb	ip, r1, #0
10006f44:	0ff6      	lsrs	r6, r6, #31
10006f46:	ea4c 0c01 	orr.w	ip, ip, r1
10006f4a:	9913      	ldr	r1, [sp, #76]	@ 0x4c
10006f4c:	9612      	str	r6, [sp, #72]	@ 0x48
10006f4e:	9e0b      	ldr	r6, [sp, #44]	@ 0x2c
10006f50:	f081 0101 	eor.w	r1, r1, #1
10006f54:	ea01 71d6 	and.w	r1, r1, r6, lsr #31
10006f58:	1a61      	subs	r1, r4, r1
10006f5a:	ee14 4a10 	vmov	r4, s8
10006f5e:	fb05 fb08 	mul.w	fp, r5, r8
10006f62:	9e12      	ldr	r6, [sp, #72]	@ 0x48
10006f64:	ea4f 7cdc 	mov.w	ip, ip, lsr #31
10006f68:	f086 0601 	eor.w	r6, r6, #1
10006f6c:	ea06 76db 	and.w	r6, r6, fp, lsr #31
10006f70:	f8cd c044 	str.w	ip, [sp, #68]	@ 0x44
10006f74:	eba4 0c06 	sub.w	ip, r4, r6
10006f78:	ee15 4a10 	vmov	r4, s10
10006f7c:	fb05 f307 	mul.w	r3, r5, r7
10006f80:	1a9b      	subs	r3, r3, r2
10006f82:	ea08 72e5 	and.w	r2, r8, r5, asr #31
10006f86:	1a9b      	subs	r3, r3, r2
10006f88:	901f      	str	r0, [sp, #124]	@ 0x7c
10006f8a:	930c      	str	r3, [sp, #48]	@ 0x30
10006f8c:	9005      	str	r0, [sp, #20]
10006f8e:	e9dd 2322 	ldrd	r2, r3, [sp, #136]	@ 0x88
10006f92:	e9cd 2300 	strd	r2, r3, [sp]
10006f96:	e9dd 231e 	ldrd	r2, r3, [sp, #120]	@ 0x78
10006f9a:	9e0c      	ldr	r6, [sp, #48]	@ 0x30
10006f9c:	eb11 010b 	adds.w	r1, r1, fp
10006fa0:	eb4c 0c06 	adc.w	ip, ip, r6
10006fa4:	eb11 060e 	adds.w	r6, r1, lr
10006fa8:	9911      	ldr	r1, [sp, #68]	@ 0x44
10006faa:	a80e      	add	r0, sp, #56	@ 0x38
10006fac:	f081 0101 	eor.w	r1, r1, #1
10006fb0:	ea01 71de 	and.w	r1, r1, lr, lsr #31
10006fb4:	eba4 0b01 	sub.w	fp, r4, r1
10006fb8:	eb4b 0b0c 	adc.w	fp, fp, ip
10006fbc:	f7ff f8b0 	bl	10006120 <fp64q_mul>
10006fc0:	9904      	ldr	r1, [sp, #16]
10006fc2:	9b05      	ldr	r3, [sp, #20]
10006fc4:	eb11 0208 	adds.w	r2, r1, r8
10006fc8:	9c03      	ldr	r4, [sp, #12]
10006fca:	9906      	ldr	r1, [sp, #24]
10006fcc:	eb47 0303 	adc.w	r3, r7, r3
10006fd0:	1864      	adds	r4, r4, r1
10006fd2:	9907      	ldr	r1, [sp, #28]
10006fd4:	eb45 0501 	adc.w	r5, r5, r1
10006fd8:	e9cd 4500 	strd	r4, r5, [sp]
10006fdc:	e9dd 450e 	ldrd	r4, r5, [sp, #56]	@ 0x38
10006fe0:	f7ff f89e 	bl	10006120 <fp64q_mul>
10006fe4:	e9dd 320e 	ldrd	r3, r2, [sp, #56]	@ 0x38
10006fe8:	1b1b      	subs	r3, r3, r4
10006fea:	eb62 0205 	sbc.w	r2, r2, r5
10006fee:	1b9b      	subs	r3, r3, r6
10006ff0:	eb62 020b 	sbc.w	r2, r2, fp
10006ff4:	1b34      	subs	r4, r6, r4
10006ff6:	9908      	ldr	r1, [sp, #32]
10006ff8:	eb6b 0505 	sbc.w	r5, fp, r5
10006ffc:	e9ca 4500 	strd	r4, r5, [sl]
10007000:	e9c9 3200 	strd	r3, r2, [r9]
10007004:	9b0d      	ldr	r3, [sp, #52]	@ 0x34
10007006:	3101      	adds	r1, #1
10007008:	428b      	cmp	r3, r1
1000700a:	9108      	str	r1, [sp, #32]
1000700c:	f47f af0f 	bne.w	10006e2e <fndsa_vect_mul_fft_fp64q+0x36>
10007010:	b025      	add	sp, #148	@ 0x94
10007012:	ecbd 8b06 	vpop	{d8-d10}
10007016:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
1000701a:	bf00      	nop
1000701c:	f3af 8000 	nop.w
10007020:	00000000 	.word	0x00000000
10007024:	3df00000 	.word	0x3df00000
10007028:	00000000 	.word	0x00000000
1000702c:	41f00000 	.word	0x41f00000
