
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_kat_exact_inlineasm/validation/build/kat/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

100055c8 <fndsa_vect_iFFT_fp64_exact>:
100055c8:	3801      	subs	r0, #1
100055ca:	f000 82d3 	beq.w	10005b74 <fndsa_vect_iFFT_fp64_exact+0x5ac>
100055ce:	2210      	movs	r2, #16
100055d0:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
100055d4:	4082      	lsls	r2, r0
100055d6:	ed2d 8b10 	vpush	{d8-d15}
100055da:	188f      	adds	r7, r1, r2
100055dc:	468c      	mov	ip, r1
100055de:	ed9f 9bf8 	vldr	d9, [pc, #992]	@ 100059c0 <fndsa_vect_iFFT_fp64_exact+0x3f8>
100055e2:	ed9f dbf9 	vldr	d13, [pc, #996]	@ 100059c8 <fndsa_vect_iFFT_fp64_exact+0x400>
100055e6:	ed9f ebfa 	vldr	d14, [pc, #1000]	@ 100059d0 <fndsa_vect_iFFT_fp64_exact+0x408>
100055ea:	2101      	movs	r1, #1
100055ec:	463b      	mov	r3, r7
100055ee:	b0b7      	sub	sp, #220	@ 0xdc
100055f0:	2201      	movs	r2, #1
100055f2:	2700      	movs	r7, #0
100055f4:	f04f 0a10 	mov.w	sl, #16
100055f8:	4689      	mov	r9, r1
100055fa:	4091      	lsls	r1, r2
100055fc:	fa0a fa00 	lsl.w	sl, sl, r0
10005600:	4082      	lsls	r2, r0
10005602:	9011      	str	r0, [sp, #68]	@ 0x44
10005604:	eeb7 fb00 	vmov.f64	d15, #112	@ 0x3f800000  1.0
10005608:	4608      	mov	r0, r1
1000560a:	46bb      	mov	fp, r7
1000560c:	4639      	mov	r1, r7
1000560e:	0852      	lsrs	r2, r2, #1
10005610:	9210      	str	r2, [sp, #64]	@ 0x40
10005612:	4af3      	ldr	r2, [pc, #972]	@ (100059e0 <fndsa_vect_iFFT_fp64_exact+0x418>)
10005614:	4492      	add	sl, r2
10005616:	45cb      	cmp	fp, r9
10005618:	f080 8299 	bcs.w	10005b4e <fndsa_vect_iFFT_fp64_exact+0x586>
1000561c:	edda 7a02 	vldr	s15, [sl, #8]
10005620:	edda 6a00 	vldr	s13, [sl]
10005624:	eeb8 5b67 	vcvt.f64.u32	d5, s15
10005628:	eeb8 4b66 	vcvt.f64.u32	d4, s13
1000562c:	ee39 5b45 	vsub.f64	d5, d9, d5
10005630:	edda 6a01 	vldr	s13, [sl, #4]
10005634:	edda 7a03 	vldr	s15, [sl, #12]
10005638:	eeb8 3b66 	vcvt.f64.u32	d3, s13
1000563c:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10005640:	ee25 6b0d 	vmul.f64	d6, d5, d13
10005644:	ee39 7b47 	vsub.f64	d7, d9, d7
10005648:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000564c:	ee37 7b4f 	vsub.f64	d7, d7, d15
10005650:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005654:	ee37 7b06 	vadd.f64	d7, d7, d6
10005658:	ee06 5b49 	vmls.f64	d5, d6, d9
1000565c:	ee27 6b0d 	vmul.f64	d6, d7, d13
10005660:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10005664:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005668:	ee06 7b49 	vmls.f64	d7, d6, d9
1000566c:	ed8d 5b04 	vstr	d5, [sp, #16]
10005670:	ed8d 7b02 	vstr	d7, [sp, #8]
10005674:	ee35 5b04 	vadd.f64	d5, d5, d4
10005678:	ee37 7b03 	vadd.f64	d7, d7, d3
1000567c:	e9cd 010e 	strd	r0, r1, [sp, #56]	@ 0x38
10005680:	ed8d 4b08 	vstr	d4, [sp, #32]
10005684:	ed8d 3b06 	vstr	d3, [sp, #24]
10005688:	ed8d 5b0c 	vstr	d5, [sp, #48]	@ 0x30
1000568c:	ed8d 7b0a 	vstr	d7, [sp, #40]	@ 0x28
10005690:	4659      	mov	r1, fp
10005692:	461f      	mov	r7, r3
10005694:	46e0      	mov	r8, ip
10005696:	eb03 160b 	add.w	r6, r3, fp, lsl #4
1000569a:	eb0c 1509 	add.w	r5, ip, r9, lsl #4
1000569e:	eb03 1409 	add.w	r4, r3, r9, lsl #4
100056a2:	eb0c 100b 	add.w	r0, ip, fp, lsl #4
100056a6:	ed90 4b02 	vldr	d4, [r0, #8]
100056aa:	ed95 2b02 	vldr	d2, [r5, #8]
100056ae:	ee34 3b09 	vadd.f64	d3, d4, d9
100056b2:	ee33 3b42 	vsub.f64	d3, d3, d2
100056b6:	ee23 8b0d 	vmul.f64	d8, d3, d13
100056ba:	ed9d 7b02 	vldr	d7, [sp, #8]
100056be:	eebc 8bc8 	vcvt.u32.f64	s16, d8
100056c2:	ed96 5b02 	vldr	d5, [r6, #8]
100056c6:	eeb8 8b48 	vcvt.f64.u32	d8, s16
100056ca:	ed8d 7b2a 	vstr	d7, [sp, #168]	@ 0xa8
100056ce:	ed9d 7b04 	vldr	d7, [sp, #16]
100056d2:	ed90 6b00 	vldr	d6, [r0]
100056d6:	ee34 4b02 	vadd.f64	d4, d4, d2
100056da:	ee08 3b49 	vmls.f64	d3, d8, d9
100056de:	ed8d 7b2c 	vstr	d7, [sp, #176]	@ 0xb0
100056e2:	ee35 2b09 	vadd.f64	d2, d5, d9
100056e6:	ed94 7b02 	vldr	d7, [r4, #8]
100056ea:	ed95 ab00 	vldr	d10, [r5]
100056ee:	ee37 5b05 	vadd.f64	d5, d7, d5
100056f2:	ee32 2b47 	vsub.f64	d2, d2, d7
100056f6:	ee33 cb0f 	vadd.f64	d12, d3, d15
100056fa:	ee36 7b09 	vadd.f64	d7, d6, d9
100056fe:	ee24 3b0d 	vmul.f64	d3, d4, d13
10005702:	ee36 6b0a 	vadd.f64	d6, d6, d10
10005706:	ee37 7b4a 	vsub.f64	d7, d7, d10
1000570a:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000570e:	ee25 ab0d 	vmul.f64	d10, d5, d13
10005712:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10005716:	ee37 7b4f 	vsub.f64	d7, d7, d15
1000571a:	eebc abca 	vcvt.u32.f64	s20, d10
1000571e:	ee37 7b08 	vadd.f64	d7, d7, d8
10005722:	ee36 6b03 	vadd.f64	d6, d6, d3
10005726:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
1000572a:	ee22 8b0d 	vmul.f64	d8, d2, d13
1000572e:	ee03 4b49 	vmls.f64	d4, d3, d9
10005732:	ed96 3b00 	vldr	d3, [r6]
10005736:	ed94 bb00 	vldr	d11, [r4]
1000573a:	ee0a 5b49 	vmls.f64	d5, d10, d9
1000573e:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10005742:	ee33 3b09 	vadd.f64	d3, d3, d9
10005746:	eeb8 8b48 	vcvt.f64.u32	d8, s16
1000574a:	ee35 5b0f 	vadd.f64	d5, d5, d15
1000574e:	ee33 3b4b 	vsub.f64	d3, d3, d11
10005752:	ed8d 5b00 	vstr	d5, [sp]
10005756:	ee08 2b49 	vmls.f64	d2, d8, d9
1000575a:	ed96 5b00 	vldr	d5, [r6]
1000575e:	ee33 3b4f 	vsub.f64	d3, d3, d15
10005762:	ee35 5b0b 	vadd.f64	d5, d5, d11
10005766:	ee33 3b08 	vadd.f64	d3, d3, d8
1000576a:	ee32 bb0f 	vadd.f64	d11, d2, d15
1000576e:	ee27 8b0d 	vmul.f64	d8, d7, d13
10005772:	ee26 2b0d 	vmul.f64	d2, d6, d13
10005776:	eebc 8bc8 	vcvt.u32.f64	s16, d8
1000577a:	eebc 2bc2 	vcvt.u32.f64	s4, d2
1000577e:	ee35 5b0a 	vadd.f64	d5, d5, d10
10005782:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10005786:	eeb8 2b42 	vcvt.f64.u32	d2, s4
1000578a:	ee08 7b49 	vmls.f64	d7, d8, d9
1000578e:	ee02 6b49 	vmls.f64	d6, d2, d9
10005792:	ee25 8b0d 	vmul.f64	d8, d5, d13
10005796:	ee23 2b0d 	vmul.f64	d2, d3, d13
1000579a:	eebc 8bc8 	vcvt.u32.f64	s16, d8
1000579e:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100057a2:	eeb8 8b48 	vcvt.f64.u32	d8, s16
100057a6:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100057aa:	ed9f ab8b 	vldr	d10, [pc, #556]	@ 100059d8 <fndsa_vect_iFFT_fp64_exact+0x410>
100057ae:	ee34 4b0f 	vadd.f64	d4, d4, d15
100057b2:	ee08 5b49 	vmls.f64	d5, d8, d9
100057b6:	ee02 3b49 	vmls.f64	d3, d2, d9
100057ba:	ee37 7b0a 	vadd.f64	d7, d7, d10
100057be:	ee33 3b0a 	vadd.f64	d3, d3, d10
100057c2:	ee24 2b0d 	vmul.f64	d2, d4, d13
100057c6:	ee36 6b0a 	vadd.f64	d6, d6, d10
100057ca:	ee35 5b0a 	vadd.f64	d5, d5, d10
100057ce:	ee2c ab0d 	vmul.f64	d10, d12, d13
100057d2:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100057d6:	eebc abca 	vcvt.u32.f64	s20, d10
100057da:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100057de:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
100057e2:	ee36 6b02 	vadd.f64	d6, d6, d2
100057e6:	ee37 7b0a 	vadd.f64	d7, d7, d10
100057ea:	ee0a cb49 	vmls.f64	d12, d10, d9
100057ee:	ee02 4b49 	vmls.f64	d4, d2, d9
100057f2:	eeb6 ab00 	vmov.f64	d10, #96	@ 0x3f000000  0.5
100057f6:	ed9d 2b00 	vldr	d2, [sp]
100057fa:	ee24 4b0a 	vmul.f64	d4, d4, d10
100057fe:	ee22 2b0d 	vmul.f64	d2, d2, d13
10005802:	ee2c 8b0a 	vmul.f64	d8, d12, d10
10005806:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000580a:	ee2b ab0d 	vmul.f64	d10, d11, d13
1000580e:	eefc 4bc2 	vcvt.u32.f64	s9, d2
10005812:	eeb8 cb44 	vcvt.f64.u32	d12, s8
10005816:	ed9d 2b00 	vldr	d2, [sp]
1000581a:	eeb8 4b64 	vcvt.f64.u32	d4, s9
1000581e:	eebc abca 	vcvt.u32.f64	s20, d10
10005822:	ee35 5b04 	vadd.f64	d5, d5, d4
10005826:	ee04 2b49 	vmls.f64	d2, d4, d9
1000582a:	eeb8 4b4a 	vcvt.f64.u32	d4, s20
1000582e:	eeb6 ab00 	vmov.f64	d10, #96	@ 0x3f000000  0.5
10005832:	ee04 bb49 	vmls.f64	d11, d4, d9
10005836:	ee22 2b0a 	vmul.f64	d2, d2, d10
1000583a:	ee33 ab04 	vadd.f64	d10, d3, d4
1000583e:	eeb6 4b00 	vmov.f64	d4, #96	@ 0x3f000000  0.5
10005842:	ee2b bb04 	vmul.f64	d11, d11, d4
10005846:	ee27 4b0d 	vmul.f64	d4, d7, d13
1000584a:	eebc bbcb 	vcvt.u32.f64	s22, d11
1000584e:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10005852:	eeb8 3b4b 	vcvt.f64.u32	d3, s22
10005856:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000585a:	ed8d 3b00 	vstr	d3, [sp]
1000585e:	ee26 3b0d 	vmul.f64	d3, d6, d13
10005862:	ee04 7b49 	vmls.f64	d7, d4, d9
10005866:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000586a:	eefc 7bc7 	vcvt.u32.f64	s15, d7
1000586e:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10005872:	ee17 ea90 	vmov	lr, s15
10005876:	ee03 6b49 	vmls.f64	d6, d3, d9
1000587a:	ea4f 73de 	mov.w	r3, lr, lsr #31
1000587e:	eefc 7bc6 	vcvt.u32.f64	s15, d6
10005882:	ee06 3a10 	vmov	s12, r3
10005886:	ea4f 035e 	mov.w	r3, lr, lsr #1
1000588a:	ee0b 3a10 	vmov	s22, r3
1000588e:	ee17 ca90 	vmov	ip, s15
10005892:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10005896:	f00e 0e01 	and.w	lr, lr, #1
1000589a:	eeb8 bbcb 	vcvt.f64.s32	d11, s22
1000589e:	ee07 ea90 	vmov	s15, lr
100058a2:	eebc 8bc8 	vcvt.u32.f64	s16, d8
100058a6:	ea4f 73dc 	mov.w	r3, ip, lsr #31
100058aa:	ee06 bb0e 	vmla.f64	d11, d6, d14
100058ae:	ee06 3a10 	vmov	s12, r3
100058b2:	ea4f 035c 	mov.w	r3, ip, lsr #1
100058b6:	ee04 3a90 	vmov	s9, r3
100058ba:	eeb8 7be7 	vcvt.f64.s32	d7, s15
100058be:	eeb8 8b48 	vcvt.f64.u32	d8, s16
100058c2:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
100058c6:	ee07 8b0e 	vmla.f64	d8, d7, d14
100058ca:	eeb8 7be4 	vcvt.f64.s32	d7, s9
100058ce:	ee06 7b0e 	vmla.f64	d7, d6, d14
100058d2:	f00c 0c01 	and.w	ip, ip, #1
100058d6:	ed80 7b00 	vstr	d7, [r0]
100058da:	ee07 ca90 	vmov	s15, ip
100058de:	eeb8 7be7 	vcvt.f64.s32	d7, s15
100058e2:	ee07 cb0e 	vmla.f64	d12, d7, d14
100058e6:	ee25 7b0d 	vmul.f64	d7, d5, d13
100058ea:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100058ee:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100058f2:	ee2a 6b0d 	vmul.f64	d6, d10, d13
100058f6:	ee07 5b49 	vmls.f64	d5, d7, d9
100058fa:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100058fe:	eefc 7bc5 	vcvt.u32.f64	s15, d5
10005902:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005906:	ee17 ea90 	vmov	lr, s15
1000590a:	ee06 ab49 	vmls.f64	d10, d6, d9
1000590e:	ea4f 73de 	mov.w	r3, lr, lsr #31
10005912:	ee06 3a10 	vmov	s12, r3
10005916:	ea4f 035e 	mov.w	r3, lr, lsr #1
1000591a:	eefc 7bca 	vcvt.u32.f64	s15, d10
1000591e:	ee07 3a10 	vmov	s14, r3
10005922:	ee17 ca90 	vmov	ip, s15
10005926:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
1000592a:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
1000592e:	ee06 7b0e 	vmla.f64	d7, d6, d14
10005932:	f00e 0e01 	and.w	lr, lr, #1
10005936:	ed80 cb02 	vstr	d12, [r0, #8]
1000593a:	eebc 2bc2 	vcvt.u32.f64	s4, d2
1000593e:	ed86 7b00 	vstr	d7, [r6]
10005942:	ee07 ea90 	vmov	s15, lr
10005946:	eeb8 2b42 	vcvt.f64.u32	d2, s4
1000594a:	eeb8 7be7 	vcvt.f64.s32	d7, s15
1000594e:	ea4f 73dc 	mov.w	r3, ip, lsr #31
10005952:	ee06 3a10 	vmov	s12, r3
10005956:	ea4f 035c 	mov.w	r3, ip, lsr #1
1000595a:	f00c 0c01 	and.w	ip, ip, #1
1000595e:	ee07 2b0e 	vmla.f64	d2, d7, d14
10005962:	ee0a 3a10 	vmov	s20, r3
10005966:	ee07 ca90 	vmov	s15, ip
1000596a:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
1000596e:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10005972:	ed9d cb00 	vldr	d12, [sp]
10005976:	eeb8 abca 	vcvt.f64.s32	d10, s20
1000597a:	ee07 cb0e 	vmla.f64	d12, d7, d14
1000597e:	ee06 ab0e 	vmla.f64	d10, d6, d14
10005982:	ed9d 0b06 	vldr	d0, [sp, #24]
10005986:	ed9d 1b08 	vldr	d1, [sp, #32]
1000598a:	ed86 2b02 	vstr	d2, [r6, #8]
1000598e:	eeb0 3b48 	vmov.f64	d3, d8
10005992:	eeb0 2b4b 	vmov.f64	d2, d11
10005996:	ed8d 0b26 	vstr	d0, [sp, #152]	@ 0x98
1000599a:	ed8d 1b28 	vstr	d1, [sp, #160]	@ 0xa0
1000599e:	ed8d ab32 	vstr	d10, [sp, #200]	@ 0xc8
100059a2:	ed8d bb2e 	vstr	d11, [sp, #184]	@ 0xb8
100059a6:	ed8d 8b30 	vstr	d8, [sp, #192]	@ 0xc0
100059aa:	ed8d cb34 	vstr	d12, [sp, #208]	@ 0xd0
100059ae:	f002 fd11 	bl	100083d4 <fndsa_fp64e_mul>
100059b2:	ed9d 2b32 	vldr	d2, [sp, #200]	@ 0xc8
100059b6:	ed8d 0b12 	vstr	d0, [sp, #72]	@ 0x48
100059ba:	ed8d 1b14 	vstr	d1, [sp, #80]	@ 0x50
100059be:	e011      	b.n	100059e4 <fndsa_vect_iFFT_fp64_exact+0x41c>
100059c0:	00000000 	.word	0x00000000
100059c4:	41f00000 	.word	0x41f00000
100059c8:	00000000 	.word	0x00000000
100059cc:	3df00000 	.word	0x3df00000
100059d0:	00000000 	.word	0x00000000
100059d4:	41e00000 	.word	0x41e00000
	...
100059e0:	300039a0 	.word	0x300039a0
100059e4:	ed9d 0b2a 	vldr	d0, [sp, #168]	@ 0xa8
100059e8:	ed9d 1b2c 	vldr	d1, [sp, #176]	@ 0xb0
100059ec:	ed9d 3b34 	vldr	d3, [sp, #208]	@ 0xd0
100059f0:	f002 fcf0 	bl	100083d4 <fndsa_fp64e_mul>
100059f4:	ed9d 6b0c 	vldr	d6, [sp, #48]	@ 0x30
100059f8:	ee26 7b0d 	vmul.f64	d7, d6, d13
100059fc:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005a00:	ed9d 5b0a 	vldr	d5, [sp, #40]	@ 0x28
10005a04:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005a08:	ee3c 3b08 	vadd.f64	d3, d12, d8
10005a0c:	ee07 6b49 	vmls.f64	d6, d7, d9
10005a10:	ed8d 0b16 	vstr	d0, [sp, #88]	@ 0x58
10005a14:	ee35 0b07 	vadd.f64	d0, d5, d7
10005a18:	ee23 7b0d 	vmul.f64	d7, d3, d13
10005a1c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005a20:	ee3a ab0b 	vadd.f64	d10, d10, d11
10005a24:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005a28:	ee3a 2b07 	vadd.f64	d2, d10, d7
10005a2c:	ee07 3b49 	vmls.f64	d3, d7, d9
10005a30:	ed8d 1b18 	vstr	d1, [sp, #96]	@ 0x60
10005a34:	ee22 7b0d 	vmul.f64	d7, d2, d13
10005a38:	eeb0 1b46 	vmov.f64	d1, d6
10005a3c:	ed8d 6b24 	vstr	d6, [sp, #144]	@ 0x90
10005a40:	ee20 6b0d 	vmul.f64	d6, d0, d13
10005a44:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005a48:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10005a4c:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005a50:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005a54:	ee07 2b49 	vmls.f64	d2, d7, d9
10005a58:	ee06 0b49 	vmls.f64	d0, d6, d9
10005a5c:	ed8d 3b20 	vstr	d3, [sp, #128]	@ 0x80
10005a60:	ed8d 0b22 	vstr	d0, [sp, #136]	@ 0x88
10005a64:	ed8d 2b1e 	vstr	d2, [sp, #120]	@ 0x78
10005a68:	f002 fcb4 	bl	100083d4 <fndsa_fp64e_mul>
10005a6c:	ed9d 4b18 	vldr	d4, [sp, #96]	@ 0x60
10005a70:	ed9d 5b14 	vldr	d5, [sp, #80]	@ 0x50
10005a74:	ee35 6b04 	vadd.f64	d6, d5, d4
10005a78:	ee26 3b0d 	vmul.f64	d3, d6, d13
10005a7c:	ed9d 2b16 	vldr	d2, [sp, #88]	@ 0x58
10005a80:	ed9d 7b12 	vldr	d7, [sp, #72]	@ 0x48
10005a84:	ee35 5b09 	vadd.f64	d5, d5, d9
10005a88:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10005a8c:	ee35 5b44 	vsub.f64	d5, d5, d4
10005a90:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10005a94:	ee37 4b02 	vadd.f64	d4, d7, d2
10005a98:	ee03 6b49 	vmls.f64	d6, d3, d9
10005a9c:	ee34 4b03 	vadd.f64	d4, d4, d3
10005aa0:	ee37 7b09 	vadd.f64	d7, d7, d9
10005aa4:	ee25 3b0d 	vmul.f64	d3, d5, d13
10005aa8:	ee37 7b42 	vsub.f64	d7, d7, d2
10005aac:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10005ab0:	ee24 2b0d 	vmul.f64	d2, d4, d13
10005ab4:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10005ab8:	ed8d 1b1c 	vstr	d1, [sp, #112]	@ 0x70
10005abc:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10005ac0:	ee31 1b09 	vadd.f64	d1, d1, d9
10005ac4:	ee03 5b49 	vmls.f64	d5, d3, d9
10005ac8:	ee31 6b46 	vsub.f64	d6, d1, d6
10005acc:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10005ad0:	ed85 5b02 	vstr	d5, [r5, #8]
10005ad4:	ed8d 0b1a 	vstr	d0, [sp, #104]	@ 0x68
10005ad8:	ee26 5b0d 	vmul.f64	d5, d6, d13
10005adc:	ee30 0b09 	vadd.f64	d0, d0, d9
10005ae0:	ee02 4b49 	vmls.f64	d4, d2, d9
10005ae4:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10005ae8:	ee30 0b44 	vsub.f64	d0, d0, d4
10005aec:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10005af0:	ee30 0b4f 	vsub.f64	d0, d0, d15
10005af4:	ee30 0b05 	vadd.f64	d0, d0, d5
10005af8:	ee05 6b49 	vmls.f64	d6, d5, d9
10005afc:	ee20 5b0d 	vmul.f64	d5, d0, d13
10005b00:	ee37 7b4f 	vsub.f64	d7, d7, d15
10005b04:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10005b08:	ee37 7b03 	vadd.f64	d7, d7, d3
10005b0c:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10005b10:	ee05 0b49 	vmls.f64	d0, d5, d9
10005b14:	ee27 5b0d 	vmul.f64	d5, d7, d13
10005b18:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10005b1c:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10005b20:	ee05 7b49 	vmls.f64	d7, d5, d9
10005b24:	3101      	adds	r1, #1
10005b26:	3410      	adds	r4, #16
10005b28:	4549      	cmp	r1, r9
10005b2a:	f105 0510 	add.w	r5, r5, #16
10005b2e:	ed05 7b04 	vstr	d7, [r5, #-16]
10005b32:	f100 0010 	add.w	r0, r0, #16
10005b36:	ed04 0b04 	vstr	d0, [r4, #-16]
10005b3a:	ed04 6b02 	vstr	d6, [r4, #-8]
10005b3e:	f106 0610 	add.w	r6, r6, #16
10005b42:	f47f adb0 	bne.w	100056a6 <fndsa_vect_iFFT_fp64_exact+0xde>
10005b46:	e9dd 010e 	ldrd	r0, r1, [sp, #56]	@ 0x38
10005b4a:	463b      	mov	r3, r7
10005b4c:	46c4      	mov	ip, r8
10005b4e:	9a10      	ldr	r2, [sp, #64]	@ 0x40
10005b50:	3101      	adds	r1, #1
10005b52:	4291      	cmp	r1, r2
10005b54:	4483      	add	fp, r0
10005b56:	4481      	add	r9, r0
10005b58:	f10a 0a10 	add.w	sl, sl, #16
10005b5c:	f47f ad5b 	bne.w	10005616 <fndsa_vect_iFFT_fp64_exact+0x4e>
10005b60:	4601      	mov	r1, r0
10005b62:	9811      	ldr	r0, [sp, #68]	@ 0x44
10005b64:	3801      	subs	r0, #1
10005b66:	f47f ad43 	bne.w	100055f0 <fndsa_vect_iFFT_fp64_exact+0x28>
10005b6a:	b037      	add	sp, #220	@ 0xdc
10005b6c:	ecbd 8b10 	vpop	{d8-d15}
10005b70:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10005b74:	4770      	bx	lr
