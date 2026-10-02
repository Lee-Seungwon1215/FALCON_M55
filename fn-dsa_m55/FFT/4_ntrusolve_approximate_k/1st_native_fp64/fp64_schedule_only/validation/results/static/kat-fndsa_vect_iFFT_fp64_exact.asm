10006740 <fndsa_vect_iFFT_fp64_exact>:
10006740:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10006744:	ed2d 8b10 	vpush	{d8-d15}
10006748:	1e45      	subs	r5, r0, #1
1000674a:	b0af      	sub	sp, #188	@ 0xbc
1000674c:	f000 825e 	beq.w	10006c0c <fndsa_vect_iFFT_fp64_exact+0x4cc>
10006750:	2310      	movs	r3, #16
10006752:	f04f 0e01 	mov.w	lr, #1
10006756:	ed9f ebf8 	vldr	d14, [pc, #992]	@ 10006b38 <fndsa_vect_iFFT_fp64_exact+0x3f8>
1000675a:	ed9f fbf9 	vldr	d15, [pc, #996]	@ 10006b40 <fndsa_vect_iFFT_fp64_exact+0x400>
1000675e:	ed9f 9bfa 	vldr	d9, [pc, #1000]	@ 10006b48 <fndsa_vect_iFFT_fp64_exact+0x408>
10006762:	fa03 fc05 	lsl.w	ip, r3, r5
10006766:	4672      	mov	r2, lr
10006768:	2301      	movs	r3, #1
1000676a:	f04f 0810 	mov.w	r8, #16
1000676e:	e9cd 2505 	strd	r2, r5, [sp, #20]
10006772:	eb01 1702 	add.w	r7, r1, r2, lsl #4
10006776:	eeb7 db00 	vmov.f64	d13, #112	@ 0x3f800000  1.0
1000677a:	460a      	mov	r2, r1
1000677c:	f04f 0b00 	mov.w	fp, #0
10006780:	46e1      	mov	r9, ip
10006782:	48f5      	ldr	r0, [pc, #980]	@ (10006b58 <fndsa_vect_iFFT_fp64_exact+0x418>)
10006784:	40ab      	lsls	r3, r5
10006786:	eb03 0353 	add.w	r3, r3, r3, lsr #1
1000678a:	fa08 f805 	lsl.w	r8, r8, r5
1000678e:	eb00 1303 	add.w	r3, r0, r3, lsl #4
10006792:	eb08 0a00 	add.w	sl, r8, r0
10006796:	9304      	str	r3, [sp, #16]
10006798:	ea4f 0e4e 	mov.w	lr, lr, lsl #1
1000679c:	f8cd e00c 	str.w	lr, [sp, #12]
100067a0:	ea4f 180e 	mov.w	r8, lr, lsl #4
100067a4:	9107      	str	r1, [sp, #28]
100067a6:	edda 7a02 	vldr	s15, [sl, #8]
100067aa:	f8da 3004 	ldr.w	r3, [sl, #4]
100067ae:	eeb8 4b67 	vcvt.f64.u32	d4, s15
100067b2:	0fdb      	lsrs	r3, r3, #31
100067b4:	ee03 3a10 	vmov	s6, r3
100067b8:	ee3e 4b44 	vsub.f64	d4, d14, d4
100067bc:	edda 7a03 	vldr	s15, [sl, #12]
100067c0:	eeb8 3bc3 	vcvt.f64.s32	d3, s6
100067c4:	eeb8 7b67 	vcvt.f64.u32	d7, s15
100067c8:	ed8d 3b18 	vstr	d3, [sp, #96]	@ 0x60
100067cc:	ee24 3b0f 	vmul.f64	d3, d4, d15
100067d0:	edda 6a00 	vldr	s13, [sl]
100067d4:	ee3e 7b47 	vsub.f64	d7, d14, d7
100067d8:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100067dc:	eeb8 5b66 	vcvt.f64.u32	d5, s13
100067e0:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100067e4:	ee37 7b4d 	vsub.f64	d7, d7, d13
100067e8:	ee37 7b03 	vadd.f64	d7, d7, d3
100067ec:	ee03 4b4e 	vmls.f64	d4, d3, d14
100067f0:	edda 6a01 	vldr	s13, [sl, #4]
100067f4:	ed8d 5b12 	vstr	d5, [sp, #72]	@ 0x48
100067f8:	eeb8 6b66 	vcvt.f64.u32	d6, s13
100067fc:	ee27 3b0f 	vmul.f64	d3, d7, d15
10006800:	ee26 2b0f 	vmul.f64	d2, d6, d15
10006804:	ee25 1b0f 	vmul.f64	d1, d5, d15
10006808:	ed8d 2b14 	vstr	d2, [sp, #80]	@ 0x50
1000680c:	ed8d 4b1c 	vstr	d4, [sp, #112]	@ 0x70
10006810:	ed8d 6b10 	vstr	d6, [sp, #64]	@ 0x40
10006814:	9b05      	ldr	r3, [sp, #20]
10006816:	eb03 010b 	add.w	r1, r3, fp
1000681a:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000681e:	ee34 5b05 	vadd.f64	d5, d4, d5
10006822:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10006826:	ee24 2b0f 	vmul.f64	d2, d4, d15
1000682a:	ee03 7b4e 	vmls.f64	d7, d3, d14
1000682e:	ee25 4b0f 	vmul.f64	d4, d5, d15
10006832:	ed8d 7b1a 	vstr	d7, [sp, #104]	@ 0x68
10006836:	eefc 3bc7 	vcvt.u32.f64	s7, d7
1000683a:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000683e:	ee13 3a90 	vmov	r3, s7
10006842:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10006846:	ee37 6b06 	vadd.f64	d6, d7, d6
1000684a:	ee27 3b0f 	vmul.f64	d3, d7, d15
1000684e:	ee36 7b04 	vadd.f64	d7, d6, d4
10006852:	ee27 6b0f 	vmul.f64	d6, d7, d15
10006856:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000685a:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000685e:	ee06 7b4e 	vmls.f64	d7, d6, d14
10006862:	eefc 6bc7 	vcvt.u32.f64	s13, d7
10006866:	0fdb      	lsrs	r3, r3, #31
10006868:	ee04 5b4e 	vmls.f64	d5, d4, d14
1000686c:	ee04 3a10 	vmov	s8, r3
10006870:	ee16 3a90 	vmov	r3, s13
10006874:	0fdb      	lsrs	r3, r3, #31
10006876:	ee27 6b0f 	vmul.f64	d6, d7, d15
1000687a:	ed8d 7b24 	vstr	d7, [sp, #144]	@ 0x90
1000687e:	ed8d 2b20 	vstr	d2, [sp, #128]	@ 0x80
10006882:	ee07 3a10 	vmov	s14, r3
10006886:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
1000688a:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
1000688e:	ee25 2b0f 	vmul.f64	d2, d5, d15
10006892:	458b      	cmp	fp, r1
10006894:	ed8d 1b16 	vstr	d1, [sp, #88]	@ 0x58
10006898:	ed8d 3b1e 	vstr	d3, [sp, #120]	@ 0x78
1000689c:	ed8d 5b26 	vstr	d5, [sp, #152]	@ 0x98
100068a0:	ed8d 4b22 	vstr	d4, [sp, #136]	@ 0x88
100068a4:	ed8d 2b2a 	vstr	d2, [sp, #168]	@ 0xa8
100068a8:	ed8d 6b28 	vstr	d6, [sp, #160]	@ 0xa0
100068ac:	ed8d 7b2c 	vstr	d7, [sp, #176]	@ 0xb0
100068b0:	f080 819a 	bcs.w	10006be8 <fndsa_vect_iFFT_fp64_exact+0x4a8>
100068b4:	463e      	mov	r6, r7
100068b6:	4611      	mov	r1, r2
100068b8:	eb09 0502 	add.w	r5, r9, r2
100068bc:	eb09 0407 	add.w	r4, r9, r7
100068c0:	9202      	str	r2, [sp, #8]
100068c2:	ed91 ab02 	vldr	d10, [r1, #8]
100068c6:	ee3a 0b0e 	vadd.f64	d0, d10, d14
100068ca:	ed96 7b02 	vldr	d7, [r6, #8]
100068ce:	ed91 cb00 	vldr	d12, [r1]
100068d2:	ed96 3b00 	vldr	d3, [r6]
100068d6:	ed95 bb02 	vldr	d11, [r5, #8]
100068da:	ed94 5b02 	vldr	d5, [r4, #8]
100068de:	ee3a ab07 	vadd.f64	d10, d10, d7
100068e2:	ee30 7b47 	vsub.f64	d7, d0, d7
100068e6:	ee3c 1b0e 	vadd.f64	d1, d12, d14
100068ea:	ee27 2b0f 	vmul.f64	d2, d7, d15
100068ee:	ee33 cb0c 	vadd.f64	d12, d3, d12
100068f2:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100068f6:	ee31 3b43 	vsub.f64	d3, d1, d3
100068fa:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100068fe:	ee33 3b4d 	vsub.f64	d3, d3, d13
10006902:	ee02 7b4e 	vmls.f64	d7, d2, d14
10006906:	ee33 3b02 	vadd.f64	d3, d3, d2
1000690a:	ee37 7b0d 	vadd.f64	d7, d7, d13
1000690e:	ee23 1b0f 	vmul.f64	d1, d3, d15
10006912:	ee27 2b0f 	vmul.f64	d2, d7, d15
10006916:	eebc 1bc1 	vcvt.u32.f64	s2, d1
1000691a:	eefc 0bc2 	vcvt.u32.f64	s1, d2
1000691e:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10006922:	ee01 3b4e 	vmls.f64	d3, d1, d14
10006926:	ed9f 4b8a 	vldr	d4, [pc, #552]	@ 10006b50 <fndsa_vect_iFFT_fp64_exact+0x410>
1000692a:	ed94 8b00 	vldr	d8, [r4]
1000692e:	ed95 6b00 	vldr	d6, [r5]
10006932:	ee3b 2b0e 	vadd.f64	d2, d11, d14
10006936:	ee35 bb0b 	vadd.f64	d11, d5, d11
1000693a:	ee32 2b45 	vsub.f64	d2, d2, d5
1000693e:	eeb8 5b60 	vcvt.f64.u32	d5, s1
10006942:	ee33 3b04 	vadd.f64	d3, d3, d4
10006946:	ee33 3b05 	vadd.f64	d3, d3, d5
1000694a:	ee36 4b0e 	vadd.f64	d4, d6, d14
1000694e:	ee23 0b0f 	vmul.f64	d0, d3, d15
10006952:	ee36 6b08 	vadd.f64	d6, d6, d8
10006956:	ee05 7b4e 	vmls.f64	d7, d5, d14
1000695a:	ee22 5b0f 	vmul.f64	d5, d2, d15
1000695e:	ed8d 6b00 	vstr	d6, [sp]
10006962:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10006966:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000696a:	eeb6 6b00 	vmov.f64	d6, #96	@ 0x3f000000  0.5
1000696e:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10006972:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10006976:	ee05 2b4e 	vmls.f64	d2, d5, d14
1000697a:	ee27 7b06 	vmul.f64	d7, d7, d6
1000697e:	ee34 6b48 	vsub.f64	d6, d4, d8
10006982:	ee00 3b4e 	vmls.f64	d3, d0, d14
10006986:	ee36 6b4d 	vsub.f64	d6, d6, d13
1000698a:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000698e:	ee36 6b05 	vadd.f64	d6, d6, d5
10006992:	eefc 5bc3 	vcvt.u32.f64	s11, d3
10006996:	eeb8 1b47 	vcvt.f64.u32	d1, s14
1000699a:	ee15 3a90 	vmov	r3, s11
1000699e:	ee32 2b0d 	vadd.f64	d2, d2, d13
100069a2:	ee22 7b0f 	vmul.f64	d7, d2, d15
100069a6:	0fda      	lsrs	r2, r3, #31
100069a8:	eefc 3bc7 	vcvt.u32.f64	s7, d7
100069ac:	ee07 2a10 	vmov	s14, r2
100069b0:	085a      	lsrs	r2, r3, #1
100069b2:	ee00 2a10 	vmov	s0, r2
100069b6:	ee26 4b0f 	vmul.f64	d4, d6, d15
100069ba:	f003 0301 	and.w	r3, r3, #1
100069be:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100069c2:	eeb8 0bc0 	vcvt.f64.s32	d0, s0
100069c6:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100069ca:	ee07 0b09 	vmla.f64	d0, d7, d9
100069ce:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100069d2:	ee07 3a90 	vmov	s15, r3
100069d6:	ee04 6b4e 	vmls.f64	d6, d4, d14
100069da:	eeb8 7be7 	vcvt.f64.s32	d7, s15
100069de:	eeb8 4b63 	vcvt.f64.u32	d4, s7
100069e2:	ee07 1b09 	vmla.f64	d1, d7, d9
100069e6:	ed9f 7b5a 	vldr	d7, [pc, #360]	@ 10006b50 <fndsa_vect_iFFT_fp64_exact+0x410>
100069ea:	ee36 6b07 	vadd.f64	d6, d6, d7
100069ee:	ee2a 5b0f 	vmul.f64	d5, d10, d15
100069f2:	ee36 7b04 	vadd.f64	d7, d6, d4
100069f6:	ee04 2b4e 	vmls.f64	d2, d4, d14
100069fa:	ee27 4b0f 	vmul.f64	d4, d7, d15
100069fe:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10006a02:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10006a06:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10006a0a:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10006a0e:	eeb6 6b00 	vmov.f64	d6, #96	@ 0x3f000000  0.5
10006a12:	ee04 7b4e 	vmls.f64	d7, d4, d14
10006a16:	ee22 2b06 	vmul.f64	d2, d2, d6
10006a1a:	ee3c 6b05 	vadd.f64	d6, d12, d5
10006a1e:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10006a22:	ee26 8b0f 	vmul.f64	d8, d6, d15
10006a26:	ee05 ab4e 	vmls.f64	d10, d5, d14
10006a2a:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10006a2e:	eeb8 3b42 	vcvt.f64.u32	d3, s4
10006a32:	ee3a 5b0d 	vadd.f64	d5, d10, d13
10006a36:	eebc 2bc8 	vcvt.u32.f64	s4, d8
10006a3a:	ee17 3a90 	vmov	r3, s15
10006a3e:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10006a42:	ee25 4b0f 	vmul.f64	d4, d5, d15
10006a46:	0fda      	lsrs	r2, r3, #31
10006a48:	ee08 2a10 	vmov	s16, r2
10006a4c:	085a      	lsrs	r2, r3, #1
10006a4e:	ee02 6b4e 	vmls.f64	d6, d2, d14
10006a52:	ed9f 7b3f 	vldr	d7, [pc, #252]	@ 10006b50 <fndsa_vect_iFFT_fp64_exact+0x410>
10006a56:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10006a5a:	ee36 6b07 	vadd.f64	d6, d6, d7
10006a5e:	ee02 2a10 	vmov	s4, r2
10006a62:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10006a66:	eeb8 8bc8 	vcvt.f64.s32	d8, s16
10006a6a:	eeb8 2bc2 	vcvt.f64.s32	d2, s4
10006a6e:	eeb6 ab00 	vmov.f64	d10, #96	@ 0x3f000000  0.5
10006a72:	ee08 2b09 	vmla.f64	d2, d8, d9
10006a76:	ee2b 8b0f 	vmul.f64	d8, d11, d15
10006a7a:	ee36 6b04 	vadd.f64	d6, d6, d4
10006a7e:	ee04 5b4e 	vmls.f64	d5, d4, d14
10006a82:	ee25 5b0a 	vmul.f64	d5, d5, d10
10006a86:	f003 0301 	and.w	r3, r3, #1
10006a8a:	ee07 3a90 	vmov	s15, r3
10006a8e:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10006a92:	ee26 4b0f 	vmul.f64	d4, d6, d15
10006a96:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10006a9a:	eebc abc5 	vcvt.u32.f64	s20, d5
10006a9e:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10006aa2:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10006aa6:	ee07 3b09 	vmla.f64	d3, d7, d9
10006aaa:	ed9d 5b00 	vldr	d5, [sp]
10006aae:	ee35 7b08 	vadd.f64	d7, d5, d8
10006ab2:	eeb0 5b4b 	vmov.f64	d5, d11
10006ab6:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10006aba:	ee08 5b4e 	vmls.f64	d5, d8, d14
10006abe:	ee27 cb0f 	vmul.f64	d12, d7, d15
10006ac2:	ee04 6b4e 	vmls.f64	d6, d4, d14
10006ac6:	ee35 5b0d 	vadd.f64	d5, d5, d13
10006aca:	eebc cbcc 	vcvt.u32.f64	s24, d12
10006ace:	eefc 6bc6 	vcvt.u32.f64	s13, d6
10006ad2:	ee25 4b0f 	vmul.f64	d4, d5, d15
10006ad6:	eeb8 cb4c 	vcvt.f64.u32	d12, s24
10006ada:	ee16 3a90 	vmov	r3, s13
10006ade:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10006ae2:	ed9f 6b1b 	vldr	d6, [pc, #108]	@ 10006b50 <fndsa_vect_iFFT_fp64_exact+0x410>
10006ae6:	ee0c 7b4e 	vmls.f64	d7, d12, d14
10006aea:	0fda      	lsrs	r2, r3, #31
10006aec:	eeb8 bb4a 	vcvt.f64.u32	d11, s20
10006af0:	ee0a 2a10 	vmov	s20, r2
10006af4:	085a      	lsrs	r2, r3, #1
10006af6:	ee37 7b06 	vadd.f64	d7, d7, d6
10006afa:	f003 0301 	and.w	r3, r3, #1
10006afe:	ee06 3a90 	vmov	s13, r3
10006b02:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10006b06:	eeb8 6be6 	vcvt.f64.s32	d6, s13
10006b0a:	ee37 7b04 	vadd.f64	d7, d7, d4
10006b0e:	ee06 bb09 	vmla.f64	d11, d6, d9
10006b12:	ee27 6b0f 	vmul.f64	d6, d7, d15
10006b16:	ee08 2a10 	vmov	s16, r2
10006b1a:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006b1e:	eeb8 abca 	vcvt.f64.s32	d10, s20
10006b22:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006b26:	eeb8 8bc8 	vcvt.f64.s32	d8, s16
10006b2a:	ee06 7b4e 	vmls.f64	d7, d6, d14
10006b2e:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10006b32:	ee04 5b4e 	vmls.f64	d5, d4, d14
10006b36:	e011      	b.n	10006b5c <fndsa_vect_iFFT_fp64_exact+0x41c>
10006b38:	00000000 	.word	0x00000000
10006b3c:	41f00000 	.word	0x41f00000
10006b40:	00000000 	.word	0x00000000
10006b44:	3df00000 	.word	0x3df00000
10006b48:	00000000 	.word	0x00000000
10006b4c:	41e00000 	.word	0x41e00000
	...
10006b58:	300039a0 	.word	0x300039a0
10006b5c:	ee0a 8b09 	vmla.f64	d8, d10, d9
10006b60:	eeb6 ab00 	vmov.f64	d10, #96	@ 0x3f000000  0.5
10006b64:	ee17 3a90 	vmov	r3, s15
10006b68:	ee25 5b0a 	vmul.f64	d5, d5, d10
10006b6c:	0fda      	lsrs	r2, r3, #31
10006b6e:	ee04 2a10 	vmov	s8, r2
10006b72:	085a      	lsrs	r2, r3, #1
10006b74:	f003 0301 	and.w	r3, r3, #1
10006b78:	ee06 2a10 	vmov	s12, r2
10006b7c:	ee07 3a90 	vmov	s15, r3
10006b80:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10006b84:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
10006b88:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10006b8c:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10006b90:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10006b94:	ee07 5b09 	vmla.f64	d5, d7, d9
10006b98:	ed81 8b00 	vstr	d8, [r1]
10006b9c:	ed81 bb02 	vstr	d11, [r1, #8]
10006ba0:	ee04 6b09 	vmla.f64	d6, d4, d9
10006ba4:	a810      	add	r0, sp, #64	@ 0x40
10006ba6:	ed85 6b00 	vstr	d6, [r5]
10006baa:	ed85 5b02 	vstr	d5, [r5, #8]
10006bae:	f7ff f9d3 	bl	10005f58 <fp64e_cmul_prepared>
10006bb2:	3110      	adds	r1, #16
10006bb4:	428f      	cmp	r7, r1
10006bb6:	ed86 0b00 	vstr	d0, [r6]
10006bba:	f105 0510 	add.w	r5, r5, #16
10006bbe:	ed86 1b02 	vstr	d1, [r6, #8]
10006bc2:	f106 0610 	add.w	r6, r6, #16
10006bc6:	ed8d 0b08 	vstr	d0, [sp, #32]
10006bca:	ed84 2b00 	vstr	d2, [r4]
10006bce:	ed84 3b02 	vstr	d3, [r4, #8]
10006bd2:	f104 0410 	add.w	r4, r4, #16
10006bd6:	ed8d 1b0a 	vstr	d1, [sp, #40]	@ 0x28
10006bda:	ed8d 2b0c 	vstr	d2, [sp, #48]	@ 0x30
10006bde:	ed8d 3b0e 	vstr	d3, [sp, #56]	@ 0x38
10006be2:	f47f ae6e 	bne.w	100068c2 <fndsa_vect_iFFT_fp64_exact+0x182>
10006be6:	9a02      	ldr	r2, [sp, #8]
10006be8:	9b03      	ldr	r3, [sp, #12]
10006bea:	f10a 0a10 	add.w	sl, sl, #16
10006bee:	449b      	add	fp, r3
10006bf0:	9b04      	ldr	r3, [sp, #16]
10006bf2:	4442      	add	r2, r8
10006bf4:	4553      	cmp	r3, sl
10006bf6:	4447      	add	r7, r8
10006bf8:	f47f add5 	bne.w	100067a6 <fndsa_vect_iFFT_fp64_exact+0x66>
10006bfc:	9d06      	ldr	r5, [sp, #24]
10006bfe:	46cc      	mov	ip, r9
10006c00:	3d01      	subs	r5, #1
10006c02:	f8dd e00c 	ldr.w	lr, [sp, #12]
10006c06:	9907      	ldr	r1, [sp, #28]
10006c08:	f47f adad 	bne.w	10006766 <fndsa_vect_iFFT_fp64_exact+0x26>
10006c0c:	b02f      	add	sp, #188	@ 0xbc
10006c0e:	ecbd 8b10 	vpop	{d8-d15}
10006c12:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10006c16:	bf00      	nop

