100075a8 <fndsa_vect_mul_fft_fp64_exact>:
100075a8:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
100075ac:	2310      	movs	r3, #16
100075ae:	ed2d 8b10 	vpush	{d8-d15}
100075b2:	3801      	subs	r0, #1
100075b4:	4083      	lsls	r3, r0
100075b6:	f1a3 0e10 	sub.w	lr, r3, #16
100075ba:	ea4f 1e1e 	mov.w	lr, lr, lsr #4
100075be:	b0bb      	sub	sp, #236	@ 0xec
100075c0:	eb01 0b03 	add.w	fp, r1, r3
100075c4:	f10e 0e01 	add.w	lr, lr, #1
100075c8:	18d3      	adds	r3, r2, r3
100075ca:	e9cd 3b1f 	strd	r3, fp, [sp, #124]	@ 0x7c
100075ce:	2700      	movs	r7, #0
100075d0:	ed9f fb09 	vldr	d15, [pc, #36]	@ 100075f8 <fndsa_vect_mul_fft_fp64_exact+0x50>
100075d4:	ed9f cb0a 	vldr	d12, [pc, #40]	@ 10007600 <fndsa_vect_mul_fft_fp64_exact+0x58>
100075d8:	eeb7 bb00 	vmov.f64	d11, #112	@ 0x3f800000  1.0
100075dc:	f04e e001 	dls	lr, lr
100075e0:	4693      	mov	fp, r2
100075e2:	f10d 0aa8 	add.w	sl, sp, #168	@ 0xa8
100075e6:	f10d 09b8 	add.w	r9, sp, #184	@ 0xb8
100075ea:	f10d 08c8 	add.w	r8, sp, #200	@ 0xc8
100075ee:	9121      	str	r1, [sp, #132]	@ 0x84
100075f0:	e00a      	b.n	10007608 <fndsa_vect_mul_fft_fp64_exact+0x60>
100075f2:	bf00      	nop
100075f4:	f3af 8000 	nop.w
100075f8:	00000000 	.word	0x00000000
100075fc:	3df00000 	.word	0x3df00000
10007600:	00000000 	.word	0x00000000
10007604:	41f00000 	.word	0x41f00000
10007608:	9b21      	ldr	r3, [sp, #132]	@ 0x84
1000760a:	eb0b 0c07 	add.w	ip, fp, r7
1000760e:	19dd      	adds	r5, r3, r7
10007610:	9b20      	ldr	r3, [sp, #128]	@ 0x80
10007612:	19dc      	adds	r4, r3, r7
10007614:	9b1f      	ldr	r3, [sp, #124]	@ 0x7c
10007616:	19de      	adds	r6, r3, r7
10007618:	e895 000f 	ldmia.w	r5, {r0, r1, r2, r3}
1000761c:	e88a 000f 	stmia.w	sl, {r0, r1, r2, r3}
10007620:	e894 000f 	ldmia.w	r4, {r0, r1, r2, r3}
10007624:	e889 000f 	stmia.w	r9, {r0, r1, r2, r3}
10007628:	e89c 000f 	ldmia.w	ip, {r0, r1, r2, r3}
1000762c:	e888 000f 	stmia.w	r8, {r0, r1, r2, r3}
10007630:	e896 000f 	ldmia.w	r6, {r0, r1, r2, r3}
10007634:	ae36      	add	r6, sp, #216	@ 0xd8
10007636:	e886 000f 	stmia.w	r6, {r0, r1, r2, r3}
1000763a:	ed9d eb2a 	vldr	d14, [sp, #168]	@ 0xa8
1000763e:	ed9d 7b34 	vldr	d7, [sp, #208]	@ 0xd0
10007642:	ed9d 8b32 	vldr	d8, [sp, #200]	@ 0xc8
10007646:	ee27 9b0f 	vmul.f64	d9, d7, d15
1000764a:	eefc 7bce 	vcvt.u32.f64	s15, d14
1000764e:	ed9d 1b2e 	vldr	d1, [sp, #184]	@ 0xb8
10007652:	ee17 0a90 	vmov	r0, s15
10007656:	eefc 7bc8 	vcvt.u32.f64	s15, d8
1000765a:	ed9d ab36 	vldr	d10, [sp, #216]	@ 0xd8
1000765e:	ee17 2a90 	vmov	r2, s15
10007662:	eefc 7bc1 	vcvt.u32.f64	s15, d1
10007666:	ee17 1a90 	vmov	r1, s15
1000766a:	eefc 7bca 	vcvt.u32.f64	s15, d10
1000766e:	ee17 3a90 	vmov	r3, s15
10007672:	ed9d 7b2c 	vldr	d7, [sp, #176]	@ 0xb0
10007676:	0fc0      	lsrs	r0, r0, #31
10007678:	ee27 4b09 	vmul.f64	d4, d7, d9
1000767c:	ee07 0a90 	vmov	s15, r0
10007680:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10007684:	0fc9      	lsrs	r1, r1, #31
10007686:	ed8d 7b12 	vstr	d7, [sp, #72]	@ 0x48
1000768a:	ee07 1a90 	vmov	s15, r1
1000768e:	0fd2      	lsrs	r2, r2, #31
10007690:	eeb8 3be7 	vcvt.f64.s32	d3, s15
10007694:	ee07 2a90 	vmov	s15, r2
10007698:	0fdb      	lsrs	r3, r3, #31
1000769a:	eeb8 2be7 	vcvt.f64.s32	d2, s15
1000769e:	ee07 3a90 	vmov	s15, r3
100076a2:	ee2e 9b09 	vmul.f64	d9, d14, d9
100076a6:	eeb8 0be7 	vcvt.f64.s32	d0, s15
100076aa:	ed8d 3b16 	vstr	d3, [sp, #88]	@ 0x58
100076ae:	ed9d 7b34 	vldr	d7, [sp, #208]	@ 0xd0
100076b2:	ed9d 3b38 	vldr	d3, [sp, #224]	@ 0xe0
100076b6:	ed8d 0b18 	vstr	d0, [sp, #96]	@ 0x60
100076ba:	eebc 9bc9 	vcvt.u32.f64	s18, d9
100076be:	ee37 0b03 	vadd.f64	d0, d7, d3
100076c2:	ed9d 7b2c 	vldr	d7, [sp, #176]	@ 0xb0
100076c6:	ed9d 3b30 	vldr	d3, [sp, #192]	@ 0xc0
100076ca:	ee28 6b0f 	vmul.f64	d6, d8, d15
100076ce:	ee37 db03 	vadd.f64	d13, d7, d3
100076d2:	eeb8 9b49 	vcvt.f64.u32	d9, s18
100076d6:	ed9d 3b2c 	vldr	d3, [sp, #176]	@ 0xb0
100076da:	ed8d 9b08 	vstr	d9, [sp, #32]
100076de:	ee23 3b06 	vmul.f64	d3, d3, d6
100076e2:	ee20 9b0f 	vmul.f64	d9, d0, d15
100076e6:	eefc 3bc3 	vcvt.u32.f64	s7, d3
100076ea:	eebc 3bc9 	vcvt.u32.f64	s6, d9
100076ee:	ed9d 7b38 	vldr	d7, [sp, #224]	@ 0xe0
100076f2:	ee2e 6b06 	vmul.f64	d6, d14, d6
100076f6:	eeb8 9b63 	vcvt.f64.u32	d9, s7
100076fa:	ed8d 2b14 	vstr	d2, [sp, #80]	@ 0x50
100076fe:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10007702:	ee38 2b0a 	vadd.f64	d2, d8, d10
10007706:	ee27 5b0f 	vmul.f64	d5, d7, d15
1000770a:	ee32 2b03 	vadd.f64	d2, d2, d3
1000770e:	ee03 0b4c 	vmls.f64	d0, d3, d12
10007712:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007716:	ed9d 3b30 	vldr	d3, [sp, #192]	@ 0xc0
1000771a:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000771e:	ee23 3b05 	vmul.f64	d3, d3, d5
10007722:	ee25 5b01 	vmul.f64	d5, d5, d1
10007726:	ee26 6b4c 	vnmul.f64	d6, d6, d12
1000772a:	eeae 6b08 	vfma.f64	d6, d14, d8
1000772e:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10007732:	ee36 6b0c 	vadd.f64	d6, d6, d12
10007736:	ee2a 7b0f 	vmul.f64	d7, d10, d15
1000773a:	ed8d 9b00 	vstr	d9, [sp]
1000773e:	ed8d 6b0e 	vstr	d6, [sp, #56]	@ 0x38
10007742:	eeb0 9b40 	vmov.f64	d9, d0
10007746:	ee2d 6b0f 	vmul.f64	d6, d13, d15
1000774a:	ed9d 0b30 	vldr	d0, [sp, #192]	@ 0xc0
1000774e:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10007752:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007756:	ed8d 5b0c 	vstr	d5, [sp, #48]	@ 0x30
1000775a:	ee20 5b07 	vmul.f64	d5, d0, d7
1000775e:	ee27 7b01 	vmul.f64	d7, d7, d1
10007762:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10007766:	ee3e 0b01 	vadd.f64	d0, d14, d1
1000776a:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000776e:	ee30 0b06 	vadd.f64	d0, d0, d6
10007772:	ee06 db4c 	vmls.f64	d13, d6, d12
10007776:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000777a:	ee22 6b0f 	vmul.f64	d6, d2, d15
1000777e:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10007782:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007786:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000778a:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000778e:	ee27 7b4c 	vnmul.f64	d7, d7, d12
10007792:	eea1 7b0a 	vfma.f64	d7, d1, d10
10007796:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000779a:	ee37 7b0c 	vadd.f64	d7, d7, d12
1000779e:	ed8d db02 	vstr	d13, [sp, #8]
100077a2:	ed8d 5b0a 	vstr	d5, [sp, #40]	@ 0x28
100077a6:	ed9d db2c 	vldr	d13, [sp, #176]	@ 0xb0
100077aa:	ed9d 5b34 	vldr	d5, [sp, #208]	@ 0xd0
100077ae:	ed8d 7b10 	vstr	d7, [sp, #64]	@ 0x40
100077b2:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100077b6:	ee24 7b4c 	vnmul.f64	d7, d4, d12
100077ba:	eead 7b05 	vfma.f64	d7, d13, d5
100077be:	ee37 7b0c 	vadd.f64	d7, d7, d12
100077c2:	ee06 2b4c 	vmls.f64	d2, d6, d12
100077c6:	ee27 7b0f 	vmul.f64	d7, d7, d15
100077ca:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100077ce:	eefc 7bc2 	vcvt.u32.f64	s15, d2
100077d2:	ee17 3a90 	vmov	r3, s15
100077d6:	0fdb      	lsrs	r3, r3, #31
100077d8:	ee07 3a90 	vmov	s15, r3
100077dc:	eeb8 5b47 	vcvt.f64.u32	d5, s14
100077e0:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100077e4:	ee35 5b04 	vadd.f64	d5, d5, d4
100077e8:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100077ec:	eeb8 4be7 	vcvt.f64.s32	d4, s15
100077f0:	ed8d 2b04 	vstr	d2, [sp, #16]
100077f4:	ee23 7b4c 	vnmul.f64	d7, d3, d12
100077f8:	ed9d 2b30 	vldr	d2, [sp, #192]	@ 0xc0
100077fc:	ed8d 4b1c 	vstr	d4, [sp, #112]	@ 0x70
10007800:	ed9d 4b38 	vldr	d4, [sp, #224]	@ 0xe0
10007804:	eea2 7b04 	vfma.f64	d7, d2, d4
10007808:	ee20 4b0f 	vmul.f64	d4, d0, d15
1000780c:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10007810:	ee37 6b0c 	vadd.f64	d6, d7, d12
10007814:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10007818:	eeb0 7b40 	vmov.f64	d7, d0
1000781c:	ee04 7b4c 	vmls.f64	d7, d4, d12
10007820:	ed9d db00 	vldr	d13, [sp]
10007824:	ed8d 7b00 	vstr	d7, [sp]
10007828:	eefc 7bc7 	vcvt.u32.f64	s15, d7
1000782c:	ee26 6b0f 	vmul.f64	d6, d6, d15
10007830:	ee17 3a90 	vmov	r3, s15
10007834:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007838:	0fdb      	lsrs	r3, r3, #31
1000783a:	ee07 3a90 	vmov	s15, r3
1000783e:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10007842:	ed8d 9b06 	vstr	d9, [sp, #24]
10007846:	ee29 2b0f 	vmul.f64	d2, d9, d15
1000784a:	ed9d 4b2c 	vldr	d4, [sp, #176]	@ 0xb0
1000784e:	ed9d 0b08 	vldr	d0, [sp, #32]
10007852:	ee36 6b03 	vadd.f64	d6, d6, d3
10007856:	ee2d 9b4c 	vnmul.f64	d9, d13, d12
1000785a:	eea4 9b08 	vfma.f64	d9, d4, d8
1000785e:	ed9d 3b0a 	vldr	d3, [sp, #40]	@ 0x28
10007862:	eeb8 8be7 	vcvt.f64.s32	d8, s15
10007866:	ed9d 4b30 	vldr	d4, [sp, #192]	@ 0xc0
1000786a:	ed8d 8b1a 	vstr	d8, [sp, #104]	@ 0x68
1000786e:	ee20 7b4c 	vnmul.f64	d7, d0, d12
10007872:	ee23 8b4c 	vnmul.f64	d8, d3, d12
10007876:	eea4 8b0a 	vfma.f64	d8, d4, d10
1000787a:	ed9d 4b04 	vldr	d4, [sp, #16]
1000787e:	ed9d ab34 	vldr	d10, [sp, #208]	@ 0xd0
10007882:	eeae 7b0a 	vfma.f64	d7, d14, d10
10007886:	ed9d eb0c 	vldr	d14, [sp, #48]	@ 0x30
1000788a:	ee24 3b0f 	vmul.f64	d3, d4, d15
1000788e:	ed9d ab38 	vldr	d10, [sp, #224]	@ 0xe0
10007892:	ee2e 4b4c 	vnmul.f64	d4, d14, d12
10007896:	eea1 4b0a 	vfma.f64	d4, d1, d10
1000789a:	ed9d ab00 	vldr	d10, [sp]
1000789e:	ed9d 1b02 	vldr	d1, [sp, #8]
100078a2:	ee21 0b02 	vmul.f64	d0, d1, d2
100078a6:	ee2a 2b02 	vmul.f64	d2, d10, d2
100078aa:	ee39 9b0c 	vadd.f64	d9, d9, d12
100078ae:	ee38 8b0c 	vadd.f64	d8, d8, d12
100078b2:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100078b6:	ee29 1b0f 	vmul.f64	d1, d9, d15
100078ba:	eeb8 eb42 	vcvt.f64.u32	d14, s4
100078be:	ee28 2b0f 	vmul.f64	d2, d8, d15
100078c2:	eebc 1bc1 	vcvt.u32.f64	s2, d1
100078c6:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100078ca:	eeb8 1b41 	vcvt.f64.u32	d1, s2
100078ce:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100078d2:	ee01 9b4c 	vmls.f64	d9, d1, d12
100078d6:	ee02 8b4c 	vmls.f64	d8, d2, d12
100078da:	ee35 5b4b 	vsub.f64	d5, d5, d11
100078de:	ee36 6b4b 	vsub.f64	d6, d6, d11
100078e2:	ee35 5b09 	vadd.f64	d5, d5, d9
100078e6:	ee36 6b08 	vadd.f64	d6, d6, d8
100078ea:	ed9d 9b0a 	vldr	d9, [sp, #40]	@ 0x28
100078ee:	ee37 7b0c 	vadd.f64	d7, d7, d12
100078f2:	ed9d 8b02 	vldr	d8, [sp, #8]
100078f6:	ee39 2b02 	vadd.f64	d2, d9, d2
100078fa:	ee28 8b03 	vmul.f64	d8, d8, d3
100078fe:	ee27 9b0f 	vmul.f64	d9, d7, d15
10007902:	eefc 8bc8 	vcvt.u32.f64	s17, d8
10007906:	eebc 8bc9 	vcvt.u32.f64	s16, d9
1000790a:	ee2a 3b03 	vmul.f64	d3, d10, d3
1000790e:	eeb8 9b68 	vcvt.f64.u32	d9, s17
10007912:	ee3d 1b01 	vadd.f64	d1, d13, d1
10007916:	eeb8 8b48 	vcvt.f64.u32	d8, s16
1000791a:	ed9d db08 	vldr	d13, [sp, #32]
1000791e:	ee08 7b4c 	vmls.f64	d7, d8, d12
10007922:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10007926:	ee3d 8b08 	vadd.f64	d8, d13, d8
1000792a:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000792e:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10007932:	ee34 4b0c 	vadd.f64	d4, d4, d12
10007936:	ee31 1b4b 	vsub.f64	d1, d1, d11
1000793a:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000793e:	ee38 8b4b 	vsub.f64	d8, d8, d11
10007942:	ee35 7b07 	vadd.f64	d7, d5, d7
10007946:	ee31 8b08 	vadd.f64	d8, d1, d8
1000794a:	ed9d 5b04 	vldr	d5, [sp, #16]
1000794e:	ed9d 1b06 	vldr	d1, [sp, #24]
10007952:	ed9d db02 	vldr	d13, [sp, #8]
10007956:	ee23 3b4c 	vnmul.f64	d3, d3, d12
1000795a:	eeaa 3b05 	vfma.f64	d3, d10, d5
1000795e:	ee20 5b4c 	vnmul.f64	d5, d0, d12
10007962:	eead 5b01 	vfma.f64	d5, d13, d1
10007966:	ee33 ab0c 	vadd.f64	d10, d3, d12
1000796a:	ee35 5b0c 	vadd.f64	d5, d5, d12
1000796e:	ee24 3b0f 	vmul.f64	d3, d4, d15
10007972:	ee25 5b0f 	vmul.f64	d5, d5, d15
10007976:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000797a:	ed9d db0c 	vldr	d13, [sp, #48]	@ 0x30
1000797e:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10007982:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10007986:	ee03 4b4c 	vmls.f64	d4, d3, d12
1000798a:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000798e:	ee3d 3b03 	vadd.f64	d3, d13, d3
10007992:	ee36 4b04 	vadd.f64	d4, d6, d4
10007996:	ee33 3b4b 	vsub.f64	d3, d3, d11
1000799a:	ed9d 6b04 	vldr	d6, [sp, #16]
1000799e:	ee35 5b00 	vadd.f64	d5, d5, d0
100079a2:	ee29 1b4c 	vnmul.f64	d1, d9, d12
100079a6:	ed9d 0b02 	vldr	d0, [sp, #8]
100079aa:	eea0 1b06 	vfma.f64	d1, d0, d6
100079ae:	ee32 2b4b 	vsub.f64	d2, d2, d11
100079b2:	ed9d 6b0e 	vldr	d6, [sp, #56]	@ 0x38
100079b6:	ed9d db10 	vldr	d13, [sp, #64]	@ 0x40
100079ba:	ee32 2b03 	vadd.f64	d2, d2, d3
100079be:	ee26 3b0f 	vmul.f64	d3, d6, d15
100079c2:	ee2d 0b0f 	vmul.f64	d0, d13, d15
100079c6:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100079ca:	eebc 0bc0 	vcvt.u32.f64	s0, d0
100079ce:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100079d2:	eeb8 0b40 	vcvt.f64.u32	d0, s0
100079d6:	ee03 6b4c 	vmls.f64	d6, d3, d12
100079da:	eeb0 3b4d 	vmov.f64	d3, d13
100079de:	ee31 1b0c 	vadd.f64	d1, d1, d12
100079e2:	ee00 3b4c 	vmls.f64	d3, d0, d12
100079e6:	ee36 6b08 	vadd.f64	d6, d6, d8
100079ea:	ed9d 0b00 	vldr	d0, [sp]
100079ee:	ed9d 8b06 	vldr	d8, [sp, #24]
100079f2:	ee33 3b02 	vadd.f64	d3, d3, d2
100079f6:	ee2e 2b4c 	vnmul.f64	d2, d14, d12
100079fa:	eea0 2b08 	vfma.f64	d2, d0, d8
100079fe:	ee21 0b0f 	vmul.f64	d0, d1, d15
10007a02:	ee27 8b0f 	vmul.f64	d8, d7, d15
10007a06:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10007a0a:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10007a0e:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10007a12:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10007a16:	ee35 5b4b 	vsub.f64	d5, d5, d11
10007a1a:	ee00 1b4c 	vmls.f64	d1, d0, d12
10007a1e:	ee36 6b08 	vadd.f64	d6, d6, d8
10007a22:	ee39 0b00 	vadd.f64	d0, d9, d0
10007a26:	ed9f 9b72 	vldr	d9, [pc, #456]	@ 10007bf0 <fndsa_vect_mul_fft_fp64_exact+0x648>
10007a2a:	ee35 1b01 	vadd.f64	d1, d5, d1
10007a2e:	ed9d db34 	vldr	d13, [sp, #208]	@ 0xd0
10007a32:	ed9d 5b12 	vldr	d5, [sp, #72]	@ 0x48
10007a36:	ee36 6b09 	vadd.f64	d6, d6, d9
10007a3a:	ee05 6b4d 	vmls.f64	d6, d5, d13
10007a3e:	ed9d db14 	vldr	d13, [sp, #80]	@ 0x50
10007a42:	ed9d 5b2c 	vldr	d5, [sp, #176]	@ 0xb0
10007a46:	ee0d 6b45 	vmls.f64	d6, d13, d5
10007a4a:	ee24 5b0f 	vmul.f64	d5, d4, d15
10007a4e:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10007a52:	ee32 2b0c 	vadd.f64	d2, d2, d12
10007a56:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10007a5a:	ee08 7b4c 	vmls.f64	d7, d8, d12
10007a5e:	ee33 3b05 	vadd.f64	d3, d3, d5
10007a62:	ee22 8b0f 	vmul.f64	d8, d2, d15
10007a66:	ee05 4b4c 	vmls.f64	d4, d5, d12
10007a6a:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10007a6e:	ed9d 5b16 	vldr	d5, [sp, #88]	@ 0x58
10007a72:	ee33 3b09 	vadd.f64	d3, d3, d9
10007a76:	ed9d db38 	vldr	d13, [sp, #224]	@ 0xe0
10007a7a:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10007a7e:	ee05 3b4d 	vmls.f64	d3, d5, d13
10007a82:	ed9d 5b18 	vldr	d5, [sp, #96]	@ 0x60
10007a86:	ed9d db30 	vldr	d13, [sp, #192]	@ 0xc0
10007a8a:	ee08 2b4c 	vmls.f64	d2, d8, d12
10007a8e:	ee05 3b4d 	vmls.f64	d3, d5, d13
10007a92:	ee2a 5b0f 	vmul.f64	d5, d10, d15
10007a96:	ee3e eb08 	vadd.f64	d14, d14, d8
10007a9a:	ee31 2b02 	vadd.f64	d2, d1, d2
10007a9e:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10007aa2:	ee22 1b0f 	vmul.f64	d1, d2, d15
10007aa6:	ee30 0b4b 	vsub.f64	d0, d0, d11
10007aaa:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10007aae:	ee3e eb4b 	vsub.f64	d14, d14, d11
10007ab2:	ee05 ab4c 	vmls.f64	d10, d5, d12
10007ab6:	ee30 eb0e 	vadd.f64	d14, d0, d14
10007aba:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10007abe:	ee3a ab0e 	vadd.f64	d10, d10, d14
10007ac2:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10007ac6:	ee3a ab01 	vadd.f64	d10, d10, d1
10007aca:	ed9d 5b1a 	vldr	d5, [sp, #104]	@ 0x68
10007ace:	ee3a ab09 	vadd.f64	d10, d10, d9
10007ad2:	ed9d 8b06 	vldr	d8, [sp, #24]
10007ad6:	ee05 ab48 	vmls.f64	d10, d5, d8
10007ada:	ee37 5b04 	vadd.f64	d5, d7, d4
10007ade:	ee37 7b0c 	vadd.f64	d7, d7, d12
10007ae2:	ee01 2b4c 	vmls.f64	d2, d1, d12
10007ae6:	ee37 7b44 	vsub.f64	d7, d7, d4
10007aea:	ed9d 1b1c 	vldr	d1, [sp, #112]	@ 0x70
10007aee:	ed9d 0b02 	vldr	d0, [sp, #8]
10007af2:	ee01 ab40 	vmls.f64	d10, d1, d0
10007af6:	ee27 1b0f 	vmul.f64	d1, d7, d15
10007afa:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10007afe:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10007b02:	ee01 7b4c 	vmls.f64	d7, d1, d12
10007b06:	ed8d 7b24 	vstr	d7, [sp, #144]	@ 0x90
10007b0a:	ee26 7b0f 	vmul.f64	d7, d6, d15
10007b0e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007b12:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007b16:	ee07 6b4c 	vmls.f64	d6, d7, d12
10007b1a:	ee23 7b0f 	vmul.f64	d7, d3, d15
10007b1e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007b22:	ee25 0b0f 	vmul.f64	d0, d5, d15
10007b26:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007b2a:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10007b2e:	ee07 3b4c 	vmls.f64	d3, d7, d12
10007b32:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10007b36:	ee36 7b0c 	vadd.f64	d7, d6, d12
10007b3a:	ee36 6b03 	vadd.f64	d6, d6, d3
10007b3e:	ee2a 4b0f 	vmul.f64	d4, d10, d15
10007b42:	ee36 6b00 	vadd.f64	d6, d6, d0
10007b46:	ee37 3b43 	vsub.f64	d3, d7, d3
10007b4a:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10007b4e:	ee26 7b0f 	vmul.f64	d7, d6, d15
10007b52:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10007b56:	ee32 2b0c 	vadd.f64	d2, d2, d12
10007b5a:	ee00 5b4c 	vmls.f64	d5, d0, d12
10007b5e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007b62:	ee04 ab4c 	vmls.f64	d10, d4, d12
10007b66:	ee32 5b45 	vsub.f64	d5, d2, d5
10007b6a:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007b6e:	ee25 4b0f 	vmul.f64	d4, d5, d15
10007b72:	ee07 6b4c 	vmls.f64	d6, d7, d12
10007b76:	ee3a ab0c 	vadd.f64	d10, d10, d12
10007b7a:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10007b7e:	ee3a 7b46 	vsub.f64	d7, d10, d6
10007b82:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10007b86:	ee33 3b4b 	vsub.f64	d3, d3, d11
10007b8a:	ee37 7b4b 	vsub.f64	d7, d7, d11
10007b8e:	ee04 5b4c 	vmls.f64	d5, d4, d12
10007b92:	ee33 3b01 	vadd.f64	d3, d3, d1
10007b96:	ee37 7b04 	vadd.f64	d7, d7, d4
10007b9a:	ed8d 5b28 	vstr	d5, [sp, #160]	@ 0xa0
10007b9e:	ee27 6b0f 	vmul.f64	d6, d7, d15
10007ba2:	ee23 5b0f 	vmul.f64	d5, d3, d15
10007ba6:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007baa:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10007bae:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10007bb2:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10007bb6:	ee06 7b4c 	vmls.f64	d7, d6, d12
10007bba:	ee05 3b4c 	vmls.f64	d3, d5, d12
10007bbe:	ed8d 7b26 	vstr	d7, [sp, #152]	@ 0x98
10007bc2:	ed8d 3b22 	vstr	d3, [sp, #136]	@ 0x88
10007bc6:	ab22      	add	r3, sp, #136	@ 0x88
10007bc8:	cb0f      	ldmia	r3, {r0, r1, r2, r3}
10007bca:	e885 000f 	stmia.w	r5, {r0, r1, r2, r3}
10007bce:	ab26      	add	r3, sp, #152	@ 0x98
10007bd0:	cb0f      	ldmia	r3, {r0, r1, r2, r3}
10007bd2:	3710      	adds	r7, #16
10007bd4:	e884 000f 	stmia.w	r4, {r0, r1, r2, r3}
10007bd8:	f1be 0e01 	subs.w	lr, lr, #1
10007bdc:	f47f ad14 	bne.w	10007608 <fndsa_vect_mul_fft_fp64_exact+0x60>
10007be0:	b03b      	add	sp, #236	@ 0xec
10007be2:	ecbd 8b10 	vpop	{d8-d15}
10007be6:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10007bea:	bf00      	nop
10007bec:	f3af 8000 	nop.w
10007bf0:	00000000 	.word	0x00000000
10007bf4:	42000000 	.word	0x42000000

