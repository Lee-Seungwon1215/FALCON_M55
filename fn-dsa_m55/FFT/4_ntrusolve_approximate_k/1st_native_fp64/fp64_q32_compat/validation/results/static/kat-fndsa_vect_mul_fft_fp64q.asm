
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_q32_compat/validation/build/kat/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10005908 <fndsa_vect_mul_fft_fp64q>:
10005908:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
1000590c:	ed2d 8b06 	vpush	{d8-d10}
10005910:	2400      	movs	r4, #0
10005912:	2308      	movs	r3, #8
10005914:	2501      	movs	r5, #1
10005916:	f1a1 0608 	sub.w	r6, r1, #8
1000591a:	ed9f 9b85 	vldr	d9, [pc, #532]	@ 10005b30 <fndsa_vect_mul_fft_fp64q+0x228>
1000591e:	ed9f 8b86 	vldr	d8, [pc, #536]	@ 10005b38 <fndsa_vect_mul_fft_fp64q+0x230>
10005922:	46b2      	mov	sl, r6
10005924:	b0a5      	sub	sp, #148	@ 0x94
10005926:	9408      	str	r4, [sp, #32]
10005928:	1e44      	subs	r4, r0, #1
1000592a:	3a08      	subs	r2, #8
1000592c:	40a3      	lsls	r3, r4
1000592e:	fa05 f104 	lsl.w	r1, r5, r4
10005932:	eb03 0906 	add.w	r9, r3, r6
10005936:	4413      	add	r3, r2
10005938:	9209      	str	r2, [sp, #36]	@ 0x24
1000593a:	910d      	str	r1, [sp, #52]	@ 0x34
1000593c:	930a      	str	r3, [sp, #40]	@ 0x28
1000593e:	e9fa 0102 	ldrd	r0, r1, [sl, #8]!
10005942:	460f      	mov	r7, r1
10005944:	e9f9 2302 	ldrd	r2, r3, [r9, #8]!
10005948:	e9cd 0114 	strd	r0, r1, [sp, #80]	@ 0x50
1000594c:	9909      	ldr	r1, [sp, #36]	@ 0x24
1000594e:	4680      	mov	r8, r0
10005950:	4614      	mov	r4, r2
10005952:	4618      	mov	r0, r3
10005954:	e9cd 2316 	strd	r2, r3, [sp, #88]	@ 0x58
10005958:	e9f1 2302 	ldrd	r2, r3, [r1, #8]!
1000595c:	4616      	mov	r6, r2
1000595e:	ee07 8a90 	vmov	s15, r8
10005962:	ee06 6a90 	vmov	s13, r6
10005966:	461d      	mov	r5, r3
10005968:	eeb8 5b67 	vcvt.f64.u32	d5, s15
1000596c:	eeb8 4b66 	vcvt.f64.u32	d4, s13
10005970:	ee06 5a90 	vmov	s13, r5
10005974:	ee25 0b04 	vmul.f64	d0, d5, d4
10005978:	ee07 7a90 	vmov	s15, r7
1000597c:	ee20 3b09 	vmul.f64	d3, d0, d9
10005980:	eeb8 6b66 	vcvt.f64.u32	d6, s13
10005984:	eebc abc3 	vcvt.u32.f64	s20, d3
10005988:	ee26 6b05 	vmul.f64	d6, d6, d5
1000598c:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10005990:	eeb8 1b4a 	vcvt.f64.u32	d1, s20
10005994:	ee27 7b04 	vmul.f64	d7, d7, d4
10005998:	ee26 4b09 	vmul.f64	d4, d6, d9
1000599c:	9109      	str	r1, [sp, #36]	@ 0x24
1000599e:	990a      	ldr	r1, [sp, #40]	@ 0x28
100059a0:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100059a4:	ee21 1b08 	vmul.f64	d1, d1, d8
100059a8:	941e      	str	r4, [sp, #120]	@ 0x78
100059aa:	e9cd 2318 	strd	r2, r3, [sp, #96]	@ 0x60
100059ae:	9203      	str	r2, [sp, #12]
100059b0:	9404      	str	r4, [sp, #16]
100059b2:	e9f1 2302 	ldrd	r2, r3, [r1, #8]!
100059b6:	4694      	mov	ip, r2
100059b8:	461c      	mov	r4, r3
100059ba:	eeb8 2b44 	vcvt.f64.u32	d2, s8
100059be:	f8cd c088 	str.w	ip, [sp, #136]	@ 0x88
100059c2:	9423      	str	r4, [sp, #140]	@ 0x8c
100059c4:	f8cd c018 	str.w	ip, [sp, #24]
100059c8:	9407      	str	r4, [sp, #28]
100059ca:	ee10 ca10 	vmov	ip, s0
100059ce:	ee11 4a10 	vmov	r4, s2
100059d2:	ee27 5b09 	vmul.f64	d5, d7, d9
100059d6:	e9cd 231a 	strd	r2, r3, [sp, #104]	@ 0x68
100059da:	fb06 f208 	mul.w	r2, r6, r8
100059de:	fb06 fe07 	mul.w	lr, r6, r7
100059e2:	ee22 2b08 	vmul.f64	d2, d2, d8
100059e6:	920b      	str	r2, [sp, #44]	@ 0x2c
100059e8:	910a      	str	r1, [sp, #40]	@ 0x28
100059ea:	ea06 72e7 	and.w	r2, r6, r7, asr #31
100059ee:	ea84 010c 	eor.w	r1, r4, ip
100059f2:	ee11 6a90 	vmov	r6, s3
100059f6:	ee10 4a90 	vmov	r4, s1
100059fa:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100059fe:	ee16 ca10 	vmov	ip, s12
10005a02:	4066      	eors	r6, r4
10005a04:	ee12 4a10 	vmov	r4, s4
10005a08:	eeb8 3b45 	vcvt.f64.u32	d3, s10
10005a0c:	430e      	orrs	r6, r1
10005a0e:	ea84 010c 	eor.w	r1, r4, ip
10005a12:	ee12 4a90 	vmov	r4, s5
10005a16:	ee16 ca90 	vmov	ip, s13
10005a1a:	ee23 3b08 	vmul.f64	d3, d3, d8
10005a1e:	ea84 0c0c 	eor.w	ip, r4, ip
10005a22:	ea4c 0c01 	orr.w	ip, ip, r1
10005a26:	4271      	negs	r1, r6
10005a28:	ee13 4a10 	vmov	r4, s6
10005a2c:	4331      	orrs	r1, r6
10005a2e:	ee17 6a10 	vmov	r6, s14
10005a32:	0fc9      	lsrs	r1, r1, #31
10005a34:	9113      	str	r1, [sp, #76]	@ 0x4c
10005a36:	4066      	eors	r6, r4
10005a38:	ee13 1a90 	vmov	r1, s7
10005a3c:	ee17 4a90 	vmov	r4, s15
10005a40:	4061      	eors	r1, r4
10005a42:	ee1a 4a10 	vmov	r4, s20
10005a46:	4331      	orrs	r1, r6
10005a48:	f1cc 0600 	rsb	r6, ip, #0
10005a4c:	ea46 060c 	orr.w	r6, r6, ip
10005a50:	f1c1 0c00 	rsb	ip, r1, #0
10005a54:	0ff6      	lsrs	r6, r6, #31
10005a56:	ea4c 0c01 	orr.w	ip, ip, r1
10005a5a:	9913      	ldr	r1, [sp, #76]	@ 0x4c
10005a5c:	9612      	str	r6, [sp, #72]	@ 0x48
10005a5e:	9e0b      	ldr	r6, [sp, #44]	@ 0x2c
10005a60:	f081 0101 	eor.w	r1, r1, #1
10005a64:	ea01 71d6 	and.w	r1, r1, r6, lsr #31
10005a68:	1a61      	subs	r1, r4, r1
10005a6a:	ee14 4a10 	vmov	r4, s8
10005a6e:	fb05 fb08 	mul.w	fp, r5, r8
10005a72:	9e12      	ldr	r6, [sp, #72]	@ 0x48
10005a74:	ea4f 7cdc 	mov.w	ip, ip, lsr #31
10005a78:	f086 0601 	eor.w	r6, r6, #1
10005a7c:	ea06 76db 	and.w	r6, r6, fp, lsr #31
10005a80:	f8cd c044 	str.w	ip, [sp, #68]	@ 0x44
10005a84:	eba4 0c06 	sub.w	ip, r4, r6
10005a88:	ee15 4a10 	vmov	r4, s10
10005a8c:	fb05 f307 	mul.w	r3, r5, r7
10005a90:	1a9b      	subs	r3, r3, r2
10005a92:	ea08 72e5 	and.w	r2, r8, r5, asr #31
10005a96:	1a9b      	subs	r3, r3, r2
10005a98:	901f      	str	r0, [sp, #124]	@ 0x7c
10005a9a:	930c      	str	r3, [sp, #48]	@ 0x30
10005a9c:	9005      	str	r0, [sp, #20]
10005a9e:	e9dd 2322 	ldrd	r2, r3, [sp, #136]	@ 0x88
10005aa2:	e9cd 2300 	strd	r2, r3, [sp]
10005aa6:	e9dd 231e 	ldrd	r2, r3, [sp, #120]	@ 0x78
10005aaa:	9e0c      	ldr	r6, [sp, #48]	@ 0x30
10005aac:	eb11 010b 	adds.w	r1, r1, fp
10005ab0:	eb4c 0c06 	adc.w	ip, ip, r6
10005ab4:	eb11 060e 	adds.w	r6, r1, lr
10005ab8:	9911      	ldr	r1, [sp, #68]	@ 0x44
10005aba:	a80e      	add	r0, sp, #56	@ 0x38
10005abc:	f081 0101 	eor.w	r1, r1, #1
10005ac0:	ea01 71de 	and.w	r1, r1, lr, lsr #31
10005ac4:	eba4 0b01 	sub.w	fp, r4, r1
10005ac8:	eb4b 0b0c 	adc.w	fp, fp, ip
10005acc:	f7ff f8b0 	bl	10004c30 <fp64q_mul>
10005ad0:	9904      	ldr	r1, [sp, #16]
10005ad2:	9b05      	ldr	r3, [sp, #20]
10005ad4:	eb11 0208 	adds.w	r2, r1, r8
10005ad8:	9c03      	ldr	r4, [sp, #12]
10005ada:	9906      	ldr	r1, [sp, #24]
10005adc:	eb47 0303 	adc.w	r3, r7, r3
10005ae0:	1864      	adds	r4, r4, r1
10005ae2:	9907      	ldr	r1, [sp, #28]
10005ae4:	eb45 0501 	adc.w	r5, r5, r1
10005ae8:	e9cd 4500 	strd	r4, r5, [sp]
10005aec:	e9dd 450e 	ldrd	r4, r5, [sp, #56]	@ 0x38
10005af0:	f7ff f89e 	bl	10004c30 <fp64q_mul>
10005af4:	e9dd 320e 	ldrd	r3, r2, [sp, #56]	@ 0x38
10005af8:	1b1b      	subs	r3, r3, r4
10005afa:	eb62 0205 	sbc.w	r2, r2, r5
10005afe:	1b9b      	subs	r3, r3, r6
10005b00:	eb62 020b 	sbc.w	r2, r2, fp
10005b04:	1b34      	subs	r4, r6, r4
10005b06:	9908      	ldr	r1, [sp, #32]
10005b08:	eb6b 0505 	sbc.w	r5, fp, r5
10005b0c:	e9ca 4500 	strd	r4, r5, [sl]
10005b10:	e9c9 3200 	strd	r3, r2, [r9]
10005b14:	9b0d      	ldr	r3, [sp, #52]	@ 0x34
10005b16:	3101      	adds	r1, #1
10005b18:	428b      	cmp	r3, r1
10005b1a:	9108      	str	r1, [sp, #32]
10005b1c:	f47f af0f 	bne.w	1000593e <fndsa_vect_mul_fft_fp64q+0x36>
10005b20:	b025      	add	sp, #148	@ 0x94
10005b22:	ecbd 8b06 	vpop	{d8-d10}
10005b26:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10005b2a:	bf00      	nop
10005b2c:	f3af 8000 	nop.w
10005b30:	00000000 	.word	0x00000000
10005b34:	3df00000 	.word	0x3df00000
10005b38:	00000000 	.word	0x00000000
10005b3c:	41f00000 	.word	0x41f00000
