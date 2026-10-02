10000878 <fndsa_vect_FFT_fp64_exact>:
10000878:	2801      	cmp	r0, #1
1000087a:	f240 815a 	bls.w	10000b32 <fndsa_vect_FFT_fp64_exact+0x2ba>
1000087e:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10000882:	460f      	mov	r7, r1
10000884:	2101      	movs	r1, #1
10000886:	ed2d 8b10 	vpush	{d8-d15}
1000088a:	2210      	movs	r2, #16
1000088c:	ed9f 9baa 	vldr	d9, [pc, #680]	@ 10000b38 <fndsa_vect_FFT_fp64_exact+0x2c0>
10000890:	ed9f 8bab 	vldr	d8, [pc, #684]	@ 10000b40 <fndsa_vect_FFT_fp64_exact+0x2c8>
10000894:	eeb7 eb00 	vmov.f64	d14, #112	@ 0x3f800000  1.0
10000898:	460c      	mov	r4, r1
1000089a:	1e43      	subs	r3, r0, #1
1000089c:	b0b1      	sub	sp, #196	@ 0xc4
1000089e:	9009      	str	r0, [sp, #36]	@ 0x24
100008a0:	409a      	lsls	r2, r3
100008a2:	fa01 f003 	lsl.w	r0, r1, r3
100008a6:	f04f 0a10 	mov.w	sl, #16
100008aa:	2301      	movs	r3, #1
100008ac:	4ea6      	ldr	r6, [pc, #664]	@ (10000b48 <fndsa_vect_FFT_fp64_exact+0x2d0>)
100008ae:	fa0a fa04 	lsl.w	sl, sl, r4
100008b2:	4680      	mov	r8, r0
100008b4:	0840      	lsrs	r0, r0, #1
100008b6:	eb07 1900 	add.w	r9, r7, r0, lsl #4
100008ba:	9005      	str	r0, [sp, #20]
100008bc:	eb0a 0006 	add.w	r0, sl, r6
100008c0:	9708      	str	r7, [sp, #32]
100008c2:	4693      	mov	fp, r2
100008c4:	46ba      	mov	sl, r7
100008c6:	2700      	movs	r7, #0
100008c8:	fa03 f504 	lsl.w	r5, r3, r4
100008cc:	eb05 0555 	add.w	r5, r5, r5, lsr #1
100008d0:	eb06 1505 	add.w	r5, r6, r5, lsl #4
100008d4:	e9cd 5406 	strd	r5, r4, [sp, #24]
100008d8:	edd0 7a00 	vldr	s15, [r0]
100008dc:	eeb8 1b67 	vcvt.f64.u32	d1, s15
100008e0:	edd0 7a02 	vldr	s15, [r0, #8]
100008e4:	eeb8 4b67 	vcvt.f64.u32	d4, s15
100008e8:	edd0 7a01 	vldr	s15, [r0, #4]
100008ec:	eeb8 2b67 	vcvt.f64.u32	d2, s15
100008f0:	edd0 7a03 	vldr	s15, [r0, #12]
100008f4:	6843      	ldr	r3, [r0, #4]
100008f6:	eeb8 3b67 	vcvt.f64.u32	d3, s15
100008fa:	0fdb      	lsrs	r3, r3, #31
100008fc:	ee06 3a10 	vmov	s12, r3
10000900:	ee17 3a90 	vmov	r3, s15
10000904:	0fdb      	lsrs	r3, r3, #31
10000906:	ee07 3a10 	vmov	s14, r3
1000090a:	ee31 5b04 	vadd.f64	d5, d1, d4
1000090e:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10000912:	ee32 cb03 	vadd.f64	d12, d2, d3
10000916:	ed8d 7b24 	vstr	d7, [sp, #144]	@ 0x90
1000091a:	ee25 7b09 	vmul.f64	d7, d5, d9
1000091e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10000922:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10000926:	ee3c cb07 	vadd.f64	d12, d12, d7
1000092a:	ee07 5b48 	vmls.f64	d5, d7, d8
1000092e:	9b05      	ldr	r3, [sp, #20]
10000930:	ee2c 7b09 	vmul.f64	d7, d12, d9
10000934:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10000938:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000093c:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10000940:	ee07 cb48 	vmls.f64	d12, d7, d8
10000944:	eebc 7bcc 	vcvt.u32.f64	s14, d12
10000948:	19d9      	adds	r1, r3, r7
1000094a:	ee17 3a10 	vmov	r3, s14
1000094e:	0fdb      	lsrs	r3, r3, #31
10000950:	ed8d 6b1a 	vstr	d6, [sp, #104]	@ 0x68
10000954:	ee07 3a10 	vmov	s14, r3
10000958:	ee25 6b09 	vmul.f64	d6, d5, d9
1000095c:	ee21 0b09 	vmul.f64	d0, d1, d9
10000960:	ed8d 1b14 	vstr	d1, [sp, #80]	@ 0x50
10000964:	ed8d 6b2c 	vstr	d6, [sp, #176]	@ 0xb0
10000968:	ee22 ab09 	vmul.f64	d10, d2, d9
1000096c:	ee24 1b09 	vmul.f64	d1, d4, d9
10000970:	ee23 bb09 	vmul.f64	d11, d3, d9
10000974:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10000978:	ee2c 6b09 	vmul.f64	d6, d12, d9
1000097c:	428f      	cmp	r7, r1
1000097e:	ed8d 2b12 	vstr	d2, [sp, #72]	@ 0x48
10000982:	ed8d 3b1c 	vstr	d3, [sp, #112]	@ 0x70
10000986:	ed8d 4b1e 	vstr	d4, [sp, #120]	@ 0x78
1000098a:	ed8d 0b18 	vstr	d0, [sp, #96]	@ 0x60
1000098e:	ed8d 1b22 	vstr	d1, [sp, #136]	@ 0x88
10000992:	ed8d ab16 	vstr	d10, [sp, #88]	@ 0x58
10000996:	ed8d bb20 	vstr	d11, [sp, #128]	@ 0x80
1000099a:	ed8d 5b28 	vstr	d5, [sp, #160]	@ 0xa0
1000099e:	ed8d cb26 	vstr	d12, [sp, #152]	@ 0x98
100009a2:	ed8d 6b2a 	vstr	d6, [sp, #168]	@ 0xa8
100009a6:	ed8d 7b2e 	vstr	d7, [sp, #184]	@ 0xb8
100009aa:	f080 80aa 	bcs.w	10000b02 <fndsa_vect_FFT_fp64_exact+0x28a>
100009ae:	464d      	mov	r5, r9
100009b0:	4654      	mov	r4, sl
100009b2:	eb0b 010a 	add.w	r1, fp, sl
100009b6:	eb0b 0609 	add.w	r6, fp, r9
100009ba:	9004      	str	r0, [sp, #16]
100009bc:	ed95 0b00 	vldr	d0, [r5]
100009c0:	ed96 2b00 	vldr	d2, [r6]
100009c4:	ed96 3b02 	vldr	d3, [r6, #8]
100009c8:	ed95 1b02 	vldr	d1, [r5, #8]
100009cc:	a812      	add	r0, sp, #72	@ 0x48
100009ce:	f7ff fccb 	bl	10000368 <fp64e_cmul_prepared>
100009d2:	ed94 db02 	vldr	d13, [r4, #8]
100009d6:	ee3d 7b01 	vadd.f64	d7, d13, d1
100009da:	ed91 ab00 	vldr	d10, [r1]
100009de:	ed91 cb02 	vldr	d12, [r1, #8]
100009e2:	ed94 bb00 	vldr	d11, [r4]
100009e6:	ed8d 1b0c 	vstr	d1, [sp, #48]	@ 0x30
100009ea:	ee3c 6b03 	vadd.f64	d6, d12, d3
100009ee:	ed8d 0b0a 	vstr	d0, [sp, #40]	@ 0x28
100009f2:	ed8d 2b0e 	vstr	d2, [sp, #56]	@ 0x38
100009f6:	ed8d 3b10 	vstr	d3, [sp, #64]	@ 0x40
100009fa:	ee3d 5b08 	vadd.f64	d5, d13, d8
100009fe:	ee3a db02 	vadd.f64	d13, d10, d2
10000a02:	ee3a ab08 	vadd.f64	d10, d10, d8
10000a06:	ee3b fb00 	vadd.f64	d15, d11, d0
10000a0a:	ee3a ab42 	vsub.f64	d10, d10, d2
10000a0e:	ee26 4b09 	vmul.f64	d4, d6, d9
10000a12:	ee3c cb08 	vadd.f64	d12, d12, d8
10000a16:	ee3b bb08 	vadd.f64	d11, d11, d8
10000a1a:	ee35 1b41 	vsub.f64	d1, d5, d1
10000a1e:	ee3b bb40 	vsub.f64	d11, d11, d0
10000a22:	eebc 0bc4 	vcvt.u32.f64	s0, d4
10000a26:	ee3c 2b43 	vsub.f64	d2, d12, d3
10000a2a:	ee27 5b09 	vmul.f64	d5, d7, d9
10000a2e:	ee3a 3b4e 	vsub.f64	d3, d10, d14
10000a32:	eebc abc5 	vcvt.u32.f64	s20, d5
10000a36:	ee22 cb09 	vmul.f64	d12, d2, d9
10000a3a:	ed8d 3b02 	vstr	d3, [sp, #8]
10000a3e:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10000a42:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10000a46:	ee21 3b09 	vmul.f64	d3, d1, d9
10000a4a:	ee3b 5b4e 	vsub.f64	d5, d11, d14
10000a4e:	ee0a 7b48 	vmls.f64	d7, d10, d8
10000a52:	ed8d 5b00 	vstr	d5, [sp]
10000a56:	ee00 6b48 	vmls.f64	d6, d0, d8
10000a5a:	eebc 4bcc 	vcvt.u32.f64	s8, d12
10000a5e:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10000a62:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10000a66:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10000a6a:	eeb0 cb47 	vmov.f64	d12, d7
10000a6e:	ee3d bb00 	vadd.f64	d11, d13, d0
10000a72:	ed9d 7b00 	vldr	d7, [sp]
10000a76:	eeb0 db46 	vmov.f64	d13, d6
10000a7a:	ed9d 6b02 	vldr	d6, [sp, #8]
10000a7e:	ee3f 5b0a 	vadd.f64	d5, d15, d10
10000a82:	ee37 7b03 	vadd.f64	d7, d7, d3
10000a86:	ee36 6b04 	vadd.f64	d6, d6, d4
10000a8a:	ee25 0b09 	vmul.f64	d0, d5, d9
10000a8e:	ee2b ab09 	vmul.f64	d10, d11, d9
10000a92:	ee03 1b48 	vmls.f64	d1, d3, d8
10000a96:	ee04 2b48 	vmls.f64	d2, d4, d8
10000a9a:	ee27 3b09 	vmul.f64	d3, d7, d9
10000a9e:	ee26 4b09 	vmul.f64	d4, d6, d9
10000aa2:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10000aa6:	eebc abca 	vcvt.u32.f64	s20, d10
10000aaa:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10000aae:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10000ab2:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10000ab6:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10000aba:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10000abe:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10000ac2:	ee00 5b48 	vmls.f64	d5, d0, d8
10000ac6:	ee0a bb48 	vmls.f64	d11, d10, d8
10000aca:	ee03 7b48 	vmls.f64	d7, d3, d8
10000ace:	ee04 6b48 	vmls.f64	d6, d4, d8
10000ad2:	3410      	adds	r4, #16
10000ad4:	3110      	adds	r1, #16
10000ad6:	3510      	adds	r5, #16
10000ad8:	3610      	adds	r6, #16
10000ada:	45a1      	cmp	r9, r4
10000adc:	ed04 cb02 	vstr	d12, [r4, #-8]
10000ae0:	ed04 5b04 	vstr	d5, [r4, #-16]
10000ae4:	ed01 bb04 	vstr	d11, [r1, #-16]
10000ae8:	ed01 db02 	vstr	d13, [r1, #-8]
10000aec:	ed05 1b02 	vstr	d1, [r5, #-8]
10000af0:	ed05 7b04 	vstr	d7, [r5, #-16]
10000af4:	ed06 6b04 	vstr	d6, [r6, #-16]
10000af8:	ed06 2b02 	vstr	d2, [r6, #-8]
10000afc:	f47f af5e 	bne.w	100009bc <fndsa_vect_FFT_fp64_exact+0x144>
10000b00:	9804      	ldr	r0, [sp, #16]
10000b02:	9b06      	ldr	r3, [sp, #24]
10000b04:	3010      	adds	r0, #16
10000b06:	4283      	cmp	r3, r0
10000b08:	4447      	add	r7, r8
10000b0a:	eb0a 1a08 	add.w	sl, sl, r8, lsl #4
10000b0e:	eb09 1908 	add.w	r9, r9, r8, lsl #4
10000b12:	f47f aee1 	bne.w	100008d8 <fndsa_vect_FFT_fp64_exact+0x60>
10000b16:	9c07      	ldr	r4, [sp, #28]
10000b18:	9b09      	ldr	r3, [sp, #36]	@ 0x24
10000b1a:	3401      	adds	r4, #1
10000b1c:	42a3      	cmp	r3, r4
10000b1e:	465a      	mov	r2, fp
10000b20:	9805      	ldr	r0, [sp, #20]
10000b22:	9f08      	ldr	r7, [sp, #32]
10000b24:	f47f aebf 	bne.w	100008a6 <fndsa_vect_FFT_fp64_exact+0x2e>
10000b28:	b031      	add	sp, #196	@ 0xc4
10000b2a:	ecbd 8b10 	vpop	{d8-d15}
10000b2e:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10000b32:	4770      	bx	lr
10000b34:	f3af 8000 	nop.w
10000b38:	00000000 	.word	0x00000000
10000b3c:	3df00000 	.word	0x3df00000
10000b40:	00000000 	.word	0x00000000
10000b44:	41f00000 	.word	0x41f00000
10000b48:	300009a0 	.word	0x300009a0
10000b4c:	00000000 	.word	0x00000000

