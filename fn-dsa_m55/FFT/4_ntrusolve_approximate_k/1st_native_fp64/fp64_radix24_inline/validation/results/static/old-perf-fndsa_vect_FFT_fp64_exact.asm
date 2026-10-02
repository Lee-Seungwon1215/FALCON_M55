
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/old-perf/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

100066b8 <fndsa_vect_FFT_fp64_exact>:
100066b8:	2801      	cmp	r0, #1
100066ba:	f240 81fb 	bls.w	10006ab4 <fndsa_vect_FFT_fp64_exact+0x3fc>
100066be:	2201      	movs	r2, #1
100066c0:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
100066c4:	ed2d 8b10 	vpush	{d8-d15}
100066c8:	2310      	movs	r3, #16
100066ca:	460f      	mov	r7, r1
100066cc:	ed9f bbf4 	vldr	d11, [pc, #976]	@ 10006aa0 <fndsa_vect_FFT_fp64_exact+0x3e8>
100066d0:	ed9f fbf5 	vldr	d15, [pc, #980]	@ 10006aa8 <fndsa_vect_FFT_fp64_exact+0x3f0>
100066d4:	4615      	mov	r5, r2
100066d6:	b0c9      	sub	sp, #292	@ 0x124
100066d8:	9117      	str	r1, [sp, #92]	@ 0x5c
100066da:	1e41      	subs	r1, r0, #1
100066dc:	408b      	lsls	r3, r1
100066de:	fa02 f401 	lsl.w	r4, r2, r1
100066e2:	eb07 0e03 	add.w	lr, r7, r3
100066e6:	901b      	str	r0, [sp, #108]	@ 0x6c
100066e8:	f04f 0c01 	mov.w	ip, #1
100066ec:	2110      	movs	r1, #16
100066ee:	4626      	mov	r6, r4
100066f0:	2000      	movs	r0, #0
100066f2:	fa24 f40c 	lsr.w	r4, r4, ip
100066f6:	9b17      	ldr	r3, [sp, #92]	@ 0x5c
100066f8:	fa0c fc05 	lsl.w	ip, ip, r5
100066fc:	ea4f 025c 	mov.w	r2, ip, lsr #1
10006700:	eb03 1304 	add.w	r3, r3, r4, lsl #4
10006704:	9216      	str	r2, [sp, #88]	@ 0x58
10006706:	4aea      	ldr	r2, [pc, #936]	@ (10006ab0 <fndsa_vect_FFT_fp64_exact+0x3f8>)
10006708:	3308      	adds	r3, #8
1000670a:	40a9      	lsls	r1, r5
1000670c:	9318      	str	r3, [sp, #96]	@ 0x60
1000670e:	4411      	add	r1, r2
10006710:	4603      	mov	r3, r0
10006712:	4632      	mov	r2, r6
10006714:	46a2      	mov	sl, r4
10006716:	e9cd 4519 	strd	r4, r5, [sp, #100]	@ 0x64
1000671a:	4553      	cmp	r3, sl
1000671c:	f080 81a8 	bcs.w	10006a70 <fndsa_vect_FFT_fp64_exact+0x3b8>
10006720:	edd1 7a01 	vldr	s15, [r1, #4]
10006724:	edd1 5a03 	vldr	s11, [r1, #12]
10006728:	eeb8 7b67 	vcvt.f64.u32	d7, s15
1000672c:	eeb8 5b65 	vcvt.f64.u32	d5, s11
10006730:	edd1 6a00 	vldr	s13, [r1]
10006734:	edd1 4a02 	vldr	s9, [r1, #8]
10006738:	eeb8 6b66 	vcvt.f64.u32	d6, s13
1000673c:	eeb8 4b64 	vcvt.f64.u32	d4, s9
10006740:	ed8d 7b06 	vstr	d7, [sp, #24]
10006744:	ee37 7b05 	vadd.f64	d7, d7, d5
10006748:	ed8d 7b0e 	vstr	d7, [sp, #56]	@ 0x38
1000674c:	ee36 7b04 	vadd.f64	d7, d6, d4
10006750:	ed8d 6b08 	vstr	d6, [sp, #32]
10006754:	ed8d 5b0a 	vstr	d5, [sp, #40]	@ 0x28
10006758:	ed8d 4b0c 	vstr	d4, [sp, #48]	@ 0x30
1000675c:	eeb7 db00 	vmov.f64	d13, #112	@ 0x3f800000  1.0
10006760:	4698      	mov	r8, r3
10006762:	ed8d 7b10 	vstr	d7, [sp, #64]	@ 0x40
10006766:	460f      	mov	r7, r1
10006768:	9c17      	ldr	r4, [sp, #92]	@ 0x5c
1000676a:	9e18      	ldr	r6, [sp, #96]	@ 0x60
1000676c:	e9cd 0312 	strd	r0, r3, [sp, #72]	@ 0x48
10006770:	e9cd e214 	strd	lr, r2, [sp, #80]	@ 0x50
10006774:	f10e 0908 	add.w	r9, lr, #8
10006778:	eb04 1503 	add.w	r5, r4, r3, lsl #4
1000677c:	eb09 190a 	add.w	r9, r9, sl, lsl #4
10006780:	eb0e 1403 	add.w	r4, lr, r3, lsl #4
10006784:	eb06 1603 	add.w	r6, r6, r3, lsl #4
10006788:	f10d 0bc0 	add.w	fp, sp, #192	@ 0xc0
1000678c:	ed94 7b00 	vldr	d7, [r4]
10006790:	f1a6 0308 	sub.w	r3, r6, #8
10006794:	cb0f      	ldmia	r3, {r0, r1, r2, r3}
10006796:	e88b 000f 	stmia.w	fp, {r0, r1, r2, r3}
1000679a:	ed95 1b00 	vldr	d1, [r5]
1000679e:	ed9d 6b08 	vldr	d6, [sp, #32]
100067a2:	ed9d eb30 	vldr	d14, [sp, #192]	@ 0xc0
100067a6:	ed8d 7b00 	vstr	d7, [sp]
100067aa:	ed9d 7b32 	vldr	d7, [sp, #200]	@ 0xc8
100067ae:	ed9d 0b06 	vldr	d0, [sp, #24]
100067b2:	f1a9 0c08 	sub.w	ip, r9, #8
100067b6:	e89c 000f 	ldmia.w	ip, {r0, r1, r2, r3}
100067ba:	f10d 0cd0 	add.w	ip, sp, #208	@ 0xd0
100067be:	e88c 000f 	stmia.w	ip, {r0, r1, r2, r3}
100067c2:	eeb0 3b47 	vmov.f64	d3, d7
100067c6:	ed8d 1b02 	vstr	d1, [sp, #8]
100067ca:	eeb0 2b4e 	vmov.f64	d2, d14
100067ce:	eeb0 1b46 	vmov.f64	d1, d6
100067d2:	ed95 cb02 	vldr	d12, [r5, #8]
100067d6:	ed94 8b02 	vldr	d8, [r4, #8]
100067da:	ed9d 9b34 	vldr	d9, [sp, #208]	@ 0xd0
100067de:	ed8d 7b42 	vstr	d7, [sp, #264]	@ 0x108
100067e2:	ed8d 7b04 	vstr	d7, [sp, #16]
100067e6:	ed8d 0b38 	vstr	d0, [sp, #224]	@ 0xe0
100067ea:	ed8d 6b3a 	vstr	d6, [sp, #232]	@ 0xe8
100067ee:	ed8d eb40 	vstr	d14, [sp, #256]	@ 0x100
100067f2:	ed9d ab36 	vldr	d10, [sp, #216]	@ 0xd8
100067f6:	f003 fd91 	bl	1000a31c <fndsa_fp64e_mul>
100067fa:	ed9d 6b0c 	vldr	d6, [sp, #48]	@ 0x30
100067fe:	ed8d 0b1c 	vstr	d0, [sp, #112]	@ 0x70
10006802:	ed9d 0b0a 	vldr	d0, [sp, #40]	@ 0x28
10006806:	eeb0 2b49 	vmov.f64	d2, d9
1000680a:	ed8d 1b1e 	vstr	d1, [sp, #120]	@ 0x78
1000680e:	eeb0 3b4a 	vmov.f64	d3, d10
10006812:	eeb0 1b46 	vmov.f64	d1, d6
10006816:	ed8d 0b3c 	vstr	d0, [sp, #240]	@ 0xf0
1000681a:	ed8d 6b3e 	vstr	d6, [sp, #248]	@ 0xf8
1000681e:	ed8d 9b44 	vstr	d9, [sp, #272]	@ 0x110
10006822:	ed8d ab46 	vstr	d10, [sp, #280]	@ 0x118
10006826:	f003 fd79 	bl	1000a31c <fndsa_fp64e_mul>
1000682a:	ed9d 7b04 	vldr	d7, [sp, #16]
1000682e:	ed9d 5b10 	vldr	d5, [sp, #64]	@ 0x40
10006832:	ee37 3b0a 	vadd.f64	d3, d7, d10
10006836:	ee25 7b0b 	vmul.f64	d7, d5, d11
1000683a:	ee23 6b0b 	vmul.f64	d6, d3, d11
1000683e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006842:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006846:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000684a:	ed9d 4b0e 	vldr	d4, [sp, #56]	@ 0x38
1000684e:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006852:	ee3e 2b09 	vadd.f64	d2, d14, d9
10006856:	ed8d 0b20 	vstr	d0, [sp, #128]	@ 0x80
1000685a:	ee32 2b06 	vadd.f64	d2, d2, d6
1000685e:	ee34 0b07 	vadd.f64	d0, d4, d7
10006862:	ee07 5b4f 	vmls.f64	d5, d7, d15
10006866:	ee06 3b4f 	vmls.f64	d3, d6, d15
1000686a:	ee20 7b0b 	vmul.f64	d7, d0, d11
1000686e:	ee22 6b0b 	vmul.f64	d6, d2, d11
10006872:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006876:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000687a:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000687e:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006882:	ee07 0b4f 	vmls.f64	d0, d7, d15
10006886:	ee06 2b4f 	vmls.f64	d2, d6, d15
1000688a:	ed8d 1b22 	vstr	d1, [sp, #136]	@ 0x88
1000688e:	eeb0 1b45 	vmov.f64	d1, d5
10006892:	ed8d 5b2e 	vstr	d5, [sp, #184]	@ 0xb8
10006896:	ed8d 3b2a 	vstr	d3, [sp, #168]	@ 0xa8
1000689a:	ed8d 0b2c 	vstr	d0, [sp, #176]	@ 0xb0
1000689e:	ed8d 2b28 	vstr	d2, [sp, #160]	@ 0xa0
100068a2:	f003 fd3b 	bl	1000a31c <fndsa_fp64e_mul>
100068a6:	ed9d 4b22 	vldr	d4, [sp, #136]	@ 0x88
100068aa:	ed9d 5b1e 	vldr	d5, [sp, #120]	@ 0x78
100068ae:	ee35 6b04 	vadd.f64	d6, d5, d4
100068b2:	ee26 3b0b 	vmul.f64	d3, d6, d11
100068b6:	ed9d 2b20 	vldr	d2, [sp, #128]	@ 0x80
100068ba:	ed9d 7b1c 	vldr	d7, [sp, #112]	@ 0x70
100068be:	ee35 5b0f 	vadd.f64	d5, d5, d15
100068c2:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100068c6:	ee35 5b44 	vsub.f64	d5, d5, d4
100068ca:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100068ce:	ee37 4b02 	vadd.f64	d4, d7, d2
100068d2:	ee37 7b0f 	vadd.f64	d7, d7, d15
100068d6:	ee34 4b03 	vadd.f64	d4, d4, d3
100068da:	ee37 7b42 	vsub.f64	d7, d7, d2
100068de:	ee24 2b0b 	vmul.f64	d2, d4, d11
100068e2:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100068e6:	ee03 6b4f 	vmls.f64	d6, d3, d15
100068ea:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100068ee:	ed8d 1b26 	vstr	d1, [sp, #152]	@ 0x98
100068f2:	ee31 1b0f 	vadd.f64	d1, d1, d15
100068f6:	ee25 3b0b 	vmul.f64	d3, d5, d11
100068fa:	ee31 6b46 	vsub.f64	d6, d1, d6
100068fe:	ee02 4b4f 	vmls.f64	d4, d2, d15
10006902:	ed8d 0b24 	vstr	d0, [sp, #144]	@ 0x90
10006906:	ee30 0b0f 	vadd.f64	d0, d0, d15
1000690a:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000690e:	ee30 0b44 	vsub.f64	d0, d0, d4
10006912:	ee26 4b0b 	vmul.f64	d4, d6, d11
10006916:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000691a:	ee37 7b4d 	vsub.f64	d7, d7, d13
1000691e:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10006922:	ee37 7b03 	vadd.f64	d7, d7, d3
10006926:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000692a:	ee30 0b4d 	vsub.f64	d0, d0, d13
1000692e:	ee03 5b4f 	vmls.f64	d5, d3, d15
10006932:	ee30 0b04 	vadd.f64	d0, d0, d4
10006936:	ee27 3b0b 	vmul.f64	d3, d7, d11
1000693a:	ee04 6b4f 	vmls.f64	d6, d4, d15
1000693e:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006942:	ee20 4b0b 	vmul.f64	d4, d0, d11
10006946:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000694a:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000694e:	ee03 7b4f 	vmls.f64	d7, d3, d15
10006952:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10006956:	ee3c 3b0f 	vadd.f64	d3, d12, d15
1000695a:	ee3c cb05 	vadd.f64	d12, d12, d5
1000695e:	ee04 0b4f 	vmls.f64	d0, d4, d15
10006962:	ee33 5b45 	vsub.f64	d5, d3, d5
10006966:	ee38 4b0f 	vadd.f64	d4, d8, d15
1000696a:	ee2c 3b0b 	vmul.f64	d3, d12, d11
1000696e:	ed9d 1b02 	vldr	d1, [sp, #8]
10006972:	ee36 8b08 	vadd.f64	d8, d6, d8
10006976:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000697a:	ee34 6b46 	vsub.f64	d6, d4, d6
1000697e:	ee31 4b0f 	vadd.f64	d4, d1, d15
10006982:	ee28 2b0b 	vmul.f64	d2, d8, d11
10006986:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000698a:	ee25 9b0b 	vmul.f64	d9, d5, d11
1000698e:	ee37 1b01 	vadd.f64	d1, d7, d1
10006992:	ee34 4b47 	vsub.f64	d4, d4, d7
10006996:	ed9d 7b00 	vldr	d7, [sp]
1000699a:	ee31 1b03 	vadd.f64	d1, d1, d3
1000699e:	ee03 cb4f 	vmls.f64	d12, d3, d15
100069a2:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100069a6:	ee37 3b0f 	vadd.f64	d3, d7, d15
100069aa:	eebc 9bc9 	vcvt.u32.f64	s18, d9
100069ae:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100069b2:	eeb8 9b49 	vcvt.f64.u32	d9, s18
100069b6:	ee37 7b00 	vadd.f64	d7, d7, d0
100069ba:	ee33 3b40 	vsub.f64	d3, d3, d0
100069be:	ee34 4b4d 	vsub.f64	d4, d4, d13
100069c2:	ee21 0b0b 	vmul.f64	d0, d1, d11
100069c6:	ee34 4b09 	vadd.f64	d4, d4, d9
100069ca:	ee09 5b4f 	vmls.f64	d5, d9, d15
100069ce:	ee37 7b02 	vadd.f64	d7, d7, d2
100069d2:	ee26 9b0b 	vmul.f64	d9, d6, d11
100069d6:	eebc 0bc0 	vcvt.u32.f64	s0, d0
100069da:	ee02 8b4f 	vmls.f64	d8, d2, d15
100069de:	eebc 9bc9 	vcvt.u32.f64	s18, d9
100069e2:	ee27 2b0b 	vmul.f64	d2, d7, d11
100069e6:	eeb8 0b40 	vcvt.f64.u32	d0, s0
100069ea:	eeb8 9b49 	vcvt.f64.u32	d9, s18
100069ee:	ee00 1b4f 	vmls.f64	d1, d0, d15
100069f2:	ee33 3b4d 	vsub.f64	d3, d3, d13
100069f6:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100069fa:	ed85 1b00 	vstr	d1, [r5]
100069fe:	ee33 3b09 	vadd.f64	d3, d3, d9
10006a02:	ee24 1b0b 	vmul.f64	d1, d4, d11
10006a06:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10006a0a:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10006a0e:	ee02 7b4f 	vmls.f64	d7, d2, d15
10006a12:	ee23 2b0b 	vmul.f64	d2, d3, d11
10006a16:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10006a1a:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10006a1e:	4633      	mov	r3, r6
10006a20:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10006a24:	ee01 4b4f 	vmls.f64	d4, d1, d15
10006a28:	3410      	adds	r4, #16
10006a2a:	ed85 cb02 	vstr	d12, [r5, #8]
10006a2e:	ee09 6b4f 	vmls.f64	d6, d9, d15
10006a32:	ed04 8b02 	vstr	d8, [r4, #-8]
10006a36:	ed04 7b04 	vstr	d7, [r4, #-16]
10006a3a:	ee02 3b4f 	vmls.f64	d3, d2, d15
10006a3e:	ed06 4b02 	vstr	d4, [r6, #-8]
10006a42:	ed83 5b00 	vstr	d5, [r3]
10006a46:	464b      	mov	r3, r9
10006a48:	f108 0801 	add.w	r8, r8, #1
10006a4c:	45d0      	cmp	r8, sl
10006a4e:	ed09 3b02 	vstr	d3, [r9, #-8]
10006a52:	f105 0510 	add.w	r5, r5, #16
10006a56:	ed83 6b00 	vstr	d6, [r3]
10006a5a:	f106 0610 	add.w	r6, r6, #16
10006a5e:	f109 0910 	add.w	r9, r9, #16
10006a62:	f47f ae93 	bne.w	1000678c <fndsa_vect_FFT_fp64_exact+0xd4>
10006a66:	e9dd 0312 	ldrd	r0, r3, [sp, #72]	@ 0x48
10006a6a:	e9dd e214 	ldrd	lr, r2, [sp, #80]	@ 0x50
10006a6e:	4639      	mov	r1, r7
10006a70:	9c16      	ldr	r4, [sp, #88]	@ 0x58
10006a72:	3001      	adds	r0, #1
10006a74:	42a0      	cmp	r0, r4
10006a76:	4413      	add	r3, r2
10006a78:	4492      	add	sl, r2
10006a7a:	f101 0110 	add.w	r1, r1, #16
10006a7e:	f47f ae4c 	bne.w	1000671a <fndsa_vect_FFT_fp64_exact+0x62>
10006a82:	e9dd 4519 	ldrd	r4, r5, [sp, #100]	@ 0x64
10006a86:	9b1b      	ldr	r3, [sp, #108]	@ 0x6c
10006a88:	3501      	adds	r5, #1
10006a8a:	42ab      	cmp	r3, r5
10006a8c:	f47f ae2c 	bne.w	100066e8 <fndsa_vect_FFT_fp64_exact+0x30>
10006a90:	b049      	add	sp, #292	@ 0x124
10006a92:	ecbd 8b10 	vpop	{d8-d15}
10006a96:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10006a9a:	bf00      	nop
10006a9c:	f3af 8000 	nop.w
10006aa0:	00000000 	.word	0x00000000
10006aa4:	3df00000 	.word	0x3df00000
10006aa8:	00000000 	.word	0x00000000
10006aac:	41f00000 	.word	0x41f00000
10006ab0:	300039a0 	.word	0x300039a0
10006ab4:	4770      	bx	lr
