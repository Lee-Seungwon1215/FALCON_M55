10005908 <fndsa_vect_FFT_fp64_exact>:
10005908:	2801      	cmp	r0, #1
1000590a:	f240 815a 	bls.w	10005bc2 <fndsa_vect_FFT_fp64_exact+0x2ba>
1000590e:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10005912:	460f      	mov	r7, r1
10005914:	2101      	movs	r1, #1
10005916:	ed2d 8b10 	vpush	{d8-d15}
1000591a:	2210      	movs	r2, #16
1000591c:	ed9f 9baa 	vldr	d9, [pc, #680]	@ 10005bc8 <fndsa_vect_FFT_fp64_exact+0x2c0>
10005920:	ed9f 8bab 	vldr	d8, [pc, #684]	@ 10005bd0 <fndsa_vect_FFT_fp64_exact+0x2c8>
10005924:	eeb7 eb00 	vmov.f64	d14, #112	@ 0x3f800000  1.0
10005928:	460c      	mov	r4, r1
1000592a:	1e43      	subs	r3, r0, #1
1000592c:	b0b1      	sub	sp, #196	@ 0xc4
1000592e:	9009      	str	r0, [sp, #36]	@ 0x24
10005930:	409a      	lsls	r2, r3
10005932:	fa01 f003 	lsl.w	r0, r1, r3
10005936:	f04f 0a10 	mov.w	sl, #16
1000593a:	2301      	movs	r3, #1
1000593c:	4ea6      	ldr	r6, [pc, #664]	@ (10005bd8 <fndsa_vect_FFT_fp64_exact+0x2d0>)
1000593e:	fa0a fa04 	lsl.w	sl, sl, r4
10005942:	4680      	mov	r8, r0
10005944:	0840      	lsrs	r0, r0, #1
10005946:	eb07 1900 	add.w	r9, r7, r0, lsl #4
1000594a:	9005      	str	r0, [sp, #20]
1000594c:	9708      	str	r7, [sp, #32]
1000594e:	eb0a 0006 	add.w	r0, sl, r6
10005952:	4693      	mov	fp, r2
10005954:	46ba      	mov	sl, r7
10005956:	2700      	movs	r7, #0
10005958:	fa03 f504 	lsl.w	r5, r3, r4
1000595c:	eb05 0555 	add.w	r5, r5, r5, lsr #1
10005960:	eb06 1505 	add.w	r5, r6, r5, lsl #4
10005964:	e9cd 5406 	strd	r5, r4, [sp, #24]
10005968:	edd0 7a00 	vldr	s15, [r0]
1000596c:	eeb8 1b67 	vcvt.f64.u32	d1, s15
10005970:	edd0 7a02 	vldr	s15, [r0, #8]
10005974:	eeb8 4b67 	vcvt.f64.u32	d4, s15
10005978:	edd0 7a01 	vldr	s15, [r0, #4]
1000597c:	eeb8 2b67 	vcvt.f64.u32	d2, s15
10005980:	edd0 7a03 	vldr	s15, [r0, #12]
10005984:	6843      	ldr	r3, [r0, #4]
10005986:	eeb8 3b67 	vcvt.f64.u32	d3, s15
1000598a:	0fdb      	lsrs	r3, r3, #31
1000598c:	ee06 3a10 	vmov	s12, r3
10005990:	ee17 3a90 	vmov	r3, s15
10005994:	0fdb      	lsrs	r3, r3, #31
10005996:	ee07 3a10 	vmov	s14, r3
1000599a:	ee31 5b04 	vadd.f64	d5, d1, d4
1000599e:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100059a2:	ed8d 7b24 	vstr	d7, [sp, #144]	@ 0x90
100059a6:	ee25 7b09 	vmul.f64	d7, d5, d9
100059aa:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100059ae:	ee32 cb03 	vadd.f64	d12, d2, d3
100059b2:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100059b6:	ee3c cb07 	vadd.f64	d12, d12, d7
100059ba:	ee07 5b48 	vmls.f64	d5, d7, d8
100059be:	ee2c 7b09 	vmul.f64	d7, d12, d9
100059c2:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100059c6:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100059ca:	ee07 cb48 	vmls.f64	d12, d7, d8
100059ce:	eebc 7bcc 	vcvt.u32.f64	s14, d12
100059d2:	9b05      	ldr	r3, [sp, #20]
100059d4:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
100059d8:	19d9      	adds	r1, r3, r7
100059da:	ee17 3a10 	vmov	r3, s14
100059de:	0fdb      	lsrs	r3, r3, #31
100059e0:	ed8d 6b1a 	vstr	d6, [sp, #104]	@ 0x68
100059e4:	ee07 3a10 	vmov	s14, r3
100059e8:	ee25 6b09 	vmul.f64	d6, d5, d9
100059ec:	ee21 0b09 	vmul.f64	d0, d1, d9
100059f0:	ed8d 1b14 	vstr	d1, [sp, #80]	@ 0x50
100059f4:	ee22 ab09 	vmul.f64	d10, d2, d9
100059f8:	ee24 1b09 	vmul.f64	d1, d4, d9
100059fc:	ee23 bb09 	vmul.f64	d11, d3, d9
10005a00:	ed8d 6b2c 	vstr	d6, [sp, #176]	@ 0xb0
10005a04:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10005a08:	ee2c 6b09 	vmul.f64	d6, d12, d9
10005a0c:	428f      	cmp	r7, r1
10005a0e:	ed8d 2b12 	vstr	d2, [sp, #72]	@ 0x48
10005a12:	ed8d 3b1c 	vstr	d3, [sp, #112]	@ 0x70
10005a16:	ed8d 4b1e 	vstr	d4, [sp, #120]	@ 0x78
10005a1a:	ed8d 0b18 	vstr	d0, [sp, #96]	@ 0x60
10005a1e:	ed8d 1b22 	vstr	d1, [sp, #136]	@ 0x88
10005a22:	ed8d ab16 	vstr	d10, [sp, #88]	@ 0x58
10005a26:	ed8d bb20 	vstr	d11, [sp, #128]	@ 0x80
10005a2a:	ed8d 5b28 	vstr	d5, [sp, #160]	@ 0xa0
10005a2e:	ed8d cb26 	vstr	d12, [sp, #152]	@ 0x98
10005a32:	ed8d 6b2a 	vstr	d6, [sp, #168]	@ 0xa8
10005a36:	ed8d 7b2e 	vstr	d7, [sp, #184]	@ 0xb8
10005a3a:	f080 80aa 	bcs.w	10005b92 <fndsa_vect_FFT_fp64_exact+0x28a>
10005a3e:	464d      	mov	r5, r9
10005a40:	4654      	mov	r4, sl
10005a42:	eb0b 010a 	add.w	r1, fp, sl
10005a46:	eb0b 0609 	add.w	r6, fp, r9
10005a4a:	9004      	str	r0, [sp, #16]
10005a4c:	ed95 0b00 	vldr	d0, [r5]
10005a50:	ed96 2b00 	vldr	d2, [r6]
10005a54:	ed96 3b02 	vldr	d3, [r6, #8]
10005a58:	ed95 1b02 	vldr	d1, [r5, #8]
10005a5c:	a812      	add	r0, sp, #72	@ 0x48
10005a5e:	f7ff f8e7 	bl	10004c30 <fp64e_cmul_prepared>
10005a62:	ed94 db02 	vldr	d13, [r4, #8]
10005a66:	ed91 ab00 	vldr	d10, [r1]
10005a6a:	ed91 cb02 	vldr	d12, [r1, #8]
10005a6e:	ed94 bb00 	vldr	d11, [r4]
10005a72:	ee3d 7b01 	vadd.f64	d7, d13, d1
10005a76:	ee3c 6b03 	vadd.f64	d6, d12, d3
10005a7a:	ee3d 5b08 	vadd.f64	d5, d13, d8
10005a7e:	ee3a db02 	vadd.f64	d13, d10, d2
10005a82:	ee3a ab08 	vadd.f64	d10, d10, d8
10005a86:	ee3b fb00 	vadd.f64	d15, d11, d0
10005a8a:	ee3a ab42 	vsub.f64	d10, d10, d2
10005a8e:	ee26 4b09 	vmul.f64	d4, d6, d9
10005a92:	ee3c cb08 	vadd.f64	d12, d12, d8
10005a96:	ee3b bb08 	vadd.f64	d11, d11, d8
10005a9a:	ed8d 1b0c 	vstr	d1, [sp, #48]	@ 0x30
10005a9e:	ee35 1b41 	vsub.f64	d1, d5, d1
10005aa2:	ee27 5b09 	vmul.f64	d5, d7, d9
10005aa6:	ee3b bb40 	vsub.f64	d11, d11, d0
10005aaa:	ed8d 0b0a 	vstr	d0, [sp, #40]	@ 0x28
10005aae:	ed8d 2b0e 	vstr	d2, [sp, #56]	@ 0x38
10005ab2:	eebc 0bc4 	vcvt.u32.f64	s0, d4
10005ab6:	ee3c 2b43 	vsub.f64	d2, d12, d3
10005aba:	ed8d 3b10 	vstr	d3, [sp, #64]	@ 0x40
10005abe:	ee3a 3b4e 	vsub.f64	d3, d10, d14
10005ac2:	eebc abc5 	vcvt.u32.f64	s20, d5
10005ac6:	ee22 cb09 	vmul.f64	d12, d2, d9
10005aca:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10005ace:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10005ad2:	ed8d 3b02 	vstr	d3, [sp, #8]
10005ad6:	ee21 3b09 	vmul.f64	d3, d1, d9
10005ada:	ee3b 5b4e 	vsub.f64	d5, d11, d14
10005ade:	ee0a 7b48 	vmls.f64	d7, d10, d8
10005ae2:	ee00 6b48 	vmls.f64	d6, d0, d8
10005ae6:	eebc 4bcc 	vcvt.u32.f64	s8, d12
10005aea:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10005aee:	ed8d 5b00 	vstr	d5, [sp]
10005af2:	ee3d bb00 	vadd.f64	d11, d13, d0
10005af6:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10005afa:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10005afe:	eeb0 cb47 	vmov.f64	d12, d7
10005b02:	eeb0 db46 	vmov.f64	d13, d6
10005b06:	ed9d 7b00 	vldr	d7, [sp]
10005b0a:	ed9d 6b02 	vldr	d6, [sp, #8]
10005b0e:	ee3f 5b0a 	vadd.f64	d5, d15, d10
10005b12:	ee37 7b03 	vadd.f64	d7, d7, d3
10005b16:	ee36 6b04 	vadd.f64	d6, d6, d4
10005b1a:	ee25 0b09 	vmul.f64	d0, d5, d9
10005b1e:	ee2b ab09 	vmul.f64	d10, d11, d9
10005b22:	ee03 1b48 	vmls.f64	d1, d3, d8
10005b26:	ee04 2b48 	vmls.f64	d2, d4, d8
10005b2a:	ee27 3b09 	vmul.f64	d3, d7, d9
10005b2e:	ee26 4b09 	vmul.f64	d4, d6, d9
10005b32:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10005b36:	eebc abca 	vcvt.u32.f64	s20, d10
10005b3a:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10005b3e:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10005b42:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10005b46:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10005b4a:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10005b4e:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10005b52:	ee00 5b48 	vmls.f64	d5, d0, d8
10005b56:	ee0a bb48 	vmls.f64	d11, d10, d8
10005b5a:	ee03 7b48 	vmls.f64	d7, d3, d8
10005b5e:	ee04 6b48 	vmls.f64	d6, d4, d8
10005b62:	3410      	adds	r4, #16
10005b64:	3110      	adds	r1, #16
10005b66:	3510      	adds	r5, #16
10005b68:	3610      	adds	r6, #16
10005b6a:	45a1      	cmp	r9, r4
10005b6c:	ed04 cb02 	vstr	d12, [r4, #-8]
10005b70:	ed04 5b04 	vstr	d5, [r4, #-16]
10005b74:	ed01 bb04 	vstr	d11, [r1, #-16]
10005b78:	ed01 db02 	vstr	d13, [r1, #-8]
10005b7c:	ed05 1b02 	vstr	d1, [r5, #-8]
10005b80:	ed05 7b04 	vstr	d7, [r5, #-16]
10005b84:	ed06 6b04 	vstr	d6, [r6, #-16]
10005b88:	ed06 2b02 	vstr	d2, [r6, #-8]
10005b8c:	f47f af5e 	bne.w	10005a4c <fndsa_vect_FFT_fp64_exact+0x144>
10005b90:	9804      	ldr	r0, [sp, #16]
10005b92:	9b06      	ldr	r3, [sp, #24]
10005b94:	3010      	adds	r0, #16
10005b96:	4283      	cmp	r3, r0
10005b98:	4447      	add	r7, r8
10005b9a:	eb0a 1a08 	add.w	sl, sl, r8, lsl #4
10005b9e:	eb09 1908 	add.w	r9, r9, r8, lsl #4
10005ba2:	f47f aee1 	bne.w	10005968 <fndsa_vect_FFT_fp64_exact+0x60>
10005ba6:	9c07      	ldr	r4, [sp, #28]
10005ba8:	9b09      	ldr	r3, [sp, #36]	@ 0x24
10005baa:	3401      	adds	r4, #1
10005bac:	42a3      	cmp	r3, r4
10005bae:	465a      	mov	r2, fp
10005bb0:	9805      	ldr	r0, [sp, #20]
10005bb2:	9f08      	ldr	r7, [sp, #32]
10005bb4:	f47f aebf 	bne.w	10005936 <fndsa_vect_FFT_fp64_exact+0x2e>
10005bb8:	b031      	add	sp, #196	@ 0xc4
10005bba:	ecbd 8b10 	vpop	{d8-d15}
10005bbe:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10005bc2:	4770      	bx	lr
10005bc4:	f3af 8000 	nop.w
10005bc8:	00000000 	.word	0x00000000
10005bcc:	3df00000 	.word	0x3df00000
10005bd0:	00000000 	.word	0x00000000
10005bd4:	41f00000 	.word	0x41f00000
10005bd8:	300039a0 	.word	0x300039a0
10005bdc:	00000000 	.word	0x00000000

