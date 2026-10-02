10006438 <fndsa_vect_iFFT_fp64_exact>:
10006438:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
1000643c:	ed2d 8b10 	vpush	{d8-d15}
10006440:	2802      	cmp	r0, #2
10006442:	460d      	mov	r5, r1
10006444:	b0e5      	sub	sp, #404	@ 0x194
10006446:	f100 3aff 	add.w	sl, r0, #4294967295	@ 0xffffffff
1000644a:	f241 831c 	bls.w	10007a86 <fndsa_vect_iFFT_fp64_exact+0x164e>
1000644e:	2301      	movs	r3, #1
10006450:	2410      	movs	r4, #16
10006452:	4683      	mov	fp, r0
10006454:	ed9f fbf8 	vldr	d15, [pc, #992]	@ 10006838 <fndsa_vect_iFFT_fp64_exact+0x400>
10006458:	ed9f ebf9 	vldr	d14, [pc, #996]	@ 10006840 <fndsa_vect_iFFT_fp64_exact+0x408>
1000645c:	fa03 f30a 	lsl.w	r3, r3, sl
10006460:	4efb      	ldr	r6, [pc, #1004]	@ (10006850 <fndsa_vect_iFFT_fp64_exact+0x418>)
10006462:	1e5a      	subs	r2, r3, #1
10006464:	fa04 f40a 	lsl.w	r4, r4, sl
10006468:	f101 0840 	add.w	r8, r1, #64	@ 0x40
1000646c:	085b      	lsrs	r3, r3, #1
1000646e:	0892      	lsrs	r2, r2, #2
10006470:	eb06 1703 	add.w	r7, r6, r3, lsl #4
10006474:	eb08 1882 	add.w	r8, r8, r2, lsl #6
10006478:	4426      	add	r6, r4
1000647a:	440c      	add	r4, r1
1000647c:	edd6 7a02 	vldr	s15, [r6, #8]
10006480:	eeb8 db67 	vcvt.f64.u32	d13, s15
10006484:	edd6 7a03 	vldr	s15, [r6, #12]
10006488:	6873      	ldr	r3, [r6, #4]
1000648a:	eeb8 2b67 	vcvt.f64.u32	d2, s15
1000648e:	0fdb      	lsrs	r3, r3, #31
10006490:	ee08 3a10 	vmov	s16, r3
10006494:	ed91 9b0a 	vldr	d9, [r1, #40]	@ 0x28
10006498:	edd6 7a00 	vldr	s15, [r6]
1000649c:	eeb8 8bc8 	vcvt.f64.s32	d8, s16
100064a0:	eeb7 0b00 	vmov.f64	d0, #112	@ 0x3f800000  1.0
100064a4:	ee3e 2b42 	vsub.f64	d2, d14, d2
100064a8:	ed91 4b02 	vldr	d4, [r1, #8]
100064ac:	ed91 bb0e 	vldr	d11, [r1, #56]	@ 0x38
100064b0:	ed94 ab0a 	vldr	d10, [r4, #40]	@ 0x28
100064b4:	eeb8 6b67 	vcvt.f64.u32	d6, s15
100064b8:	ee32 2b40 	vsub.f64	d2, d2, d0
100064bc:	edd6 7a01 	vldr	s15, [r6, #4]
100064c0:	ed8d 8b4e 	vstr	d8, [sp, #312]	@ 0x138
100064c4:	ee39 8b0e 	vadd.f64	d8, d9, d14
100064c8:	ed91 3b06 	vldr	d3, [r1, #24]
100064cc:	ed94 5b02 	vldr	d5, [r4, #8]
100064d0:	ed94 cb0e 	vldr	d12, [r4, #56]	@ 0x38
100064d4:	eeb8 7b67 	vcvt.f64.u32	d7, s15
100064d8:	ee39 9b0b 	vadd.f64	d9, d9, d11
100064dc:	ee3a 0b0e 	vadd.f64	d0, d10, d14
100064e0:	ee38 bb4b 	vsub.f64	d11, d8, d11
100064e4:	ed8d 2b12 	vstr	d2, [sp, #72]	@ 0x48
100064e8:	ed91 8b00 	vldr	d8, [r1]
100064ec:	ee34 2b0e 	vadd.f64	d2, d4, d14
100064f0:	ed94 1b06 	vldr	d1, [r4, #24]
100064f4:	ee33 4b04 	vadd.f64	d4, d3, d4
100064f8:	ee32 2b43 	vsub.f64	d2, d2, d3
100064fc:	ee3a ab0c 	vadd.f64	d10, d10, d12
10006500:	ed8d 7b00 	vstr	d7, [sp]
10006504:	ee30 cb4c 	vsub.f64	d12, d0, d12
10006508:	ed8d 7b46 	vstr	d7, [sp, #280]	@ 0x118
1000650c:	ee35 3b0e 	vadd.f64	d3, d5, d14
10006510:	ed91 7b00 	vldr	d7, [r1]
10006514:	ee38 0b0e 	vadd.f64	d0, d8, d14
10006518:	ed91 8b04 	vldr	d8, [r1, #16]
1000651c:	ee35 5b01 	vadd.f64	d5, d5, d1
10006520:	ee33 3b41 	vsub.f64	d3, d3, d1
10006524:	ee38 8b07 	vadd.f64	d8, d8, d7
10006528:	ee22 1b0f 	vmul.f64	d1, d2, d15
1000652c:	ed8d 8b02 	vstr	d8, [sp, #8]
10006530:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10006534:	ed91 8b04 	vldr	d8, [r1, #16]
10006538:	eeb8 1b41 	vcvt.f64.u32	d1, s2
1000653c:	eeb7 7b00 	vmov.f64	d7, #112	@ 0x3f800000  1.0
10006540:	ee30 0b48 	vsub.f64	d0, d0, d8
10006544:	ee01 2b4e 	vmls.f64	d2, d1, d14
10006548:	ee30 0b47 	vsub.f64	d0, d0, d7
1000654c:	ed94 8b00 	vldr	d8, [r4]
10006550:	ee30 0b01 	vadd.f64	d0, d0, d1
10006554:	ee32 1b07 	vadd.f64	d1, d2, d7
10006558:	ee23 2b0f 	vmul.f64	d2, d3, d15
1000655c:	ed94 7b04 	vldr	d7, [r4, #16]
10006560:	ed8d 1b0c 	vstr	d1, [sp, #48]	@ 0x30
10006564:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10006568:	ee38 1b0e 	vadd.f64	d1, d8, d14
1000656c:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10006570:	ee38 8b07 	vadd.f64	d8, d8, d7
10006574:	ee31 1b47 	vsub.f64	d1, d1, d7
10006578:	eeb7 7b00 	vmov.f64	d7, #112	@ 0x3f800000  1.0
1000657c:	ee02 3b4e 	vmls.f64	d3, d2, d14
10006580:	ee31 1b47 	vsub.f64	d1, d1, d7
10006584:	ee31 1b02 	vadd.f64	d1, d1, d2
10006588:	ee33 2b07 	vadd.f64	d2, d3, d7
1000658c:	ee24 3b0f 	vmul.f64	d3, d4, d15
10006590:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006594:	ed8d 2b0a 	vstr	d2, [sp, #40]	@ 0x28
10006598:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000659c:	ee25 2b0f 	vmul.f64	d2, d5, d15
100065a0:	ed8d 8b04 	vstr	d8, [sp, #16]
100065a4:	ee03 4b4e 	vmls.f64	d4, d3, d14
100065a8:	ed9d 8b02 	vldr	d8, [sp, #8]
100065ac:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100065b0:	ee38 8b03 	vadd.f64	d8, d8, d3
100065b4:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100065b8:	eeb0 3b47 	vmov.f64	d3, d7
100065bc:	ee34 7b07 	vadd.f64	d7, d4, d7
100065c0:	ed9d 4b04 	vldr	d4, [sp, #16]
100065c4:	ee02 5b4e 	vmls.f64	d5, d2, d14
100065c8:	ee34 4b02 	vadd.f64	d4, d4, d2
100065cc:	ee35 5b03 	vadd.f64	d5, d5, d3
100065d0:	ed8d 4b02 	vstr	d4, [sp, #8]
100065d4:	ee29 4b0f 	vmul.f64	d4, d9, d15
100065d8:	ed8d 6b48 	vstr	d6, [sp, #288]	@ 0x120
100065dc:	ed8d 7b10 	vstr	d7, [sp, #64]	@ 0x40
100065e0:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100065e4:	ed8d 5b0e 	vstr	d5, [sp, #56]	@ 0x38
100065e8:	ee2a 5b0f 	vmul.f64	d5, d10, d15
100065ec:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100065f0:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100065f4:	ee04 9b4e 	vmls.f64	d9, d4, d14
100065f8:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100065fc:	ee39 7b03 	vadd.f64	d7, d9, d3
10006600:	ee05 ab4e 	vmls.f64	d10, d5, d14
10006604:	ed8d 7b08 	vstr	d7, [sp, #32]
10006608:	ee3a 2b03 	vadd.f64	d2, d10, d3
1000660c:	ed91 7b0c 	vldr	d7, [r1, #48]	@ 0x30
10006610:	ed91 ab08 	vldr	d10, [r1, #32]
10006614:	ed91 3b08 	vldr	d3, [r1, #32]
10006618:	ee2b 9b0f 	vmul.f64	d9, d11, d15
1000661c:	ed8d 2b06 	vstr	d2, [sp, #24]
10006620:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10006624:	ee3a 2b07 	vadd.f64	d2, d10, d7
10006628:	ee33 3b0e 	vadd.f64	d3, d3, d14
1000662c:	ee32 2b04 	vadd.f64	d2, d2, d4
10006630:	ee33 3b47 	vsub.f64	d3, d3, d7
10006634:	eeb7 4b00 	vmov.f64	d4, #112	@ 0x3f800000  1.0
10006638:	eeb8 9b49 	vcvt.f64.u32	d9, s18
1000663c:	ee33 3b44 	vsub.f64	d3, d3, d4
10006640:	ee09 bb4e 	vmls.f64	d11, d9, d14
10006644:	ee33 9b09 	vadd.f64	d9, d3, d9
10006648:	ee3b 3b04 	vadd.f64	d3, d11, d4
1000664c:	ed8d 3b04 	vstr	d3, [sp, #16]
10006650:	ed94 3b08 	vldr	d3, [r4, #32]
10006654:	eeb0 7b44 	vmov.f64	d7, d4
10006658:	ed94 bb0c 	vldr	d11, [r4, #48]	@ 0x30
1000665c:	ee2c ab0f 	vmul.f64	d10, d12, d15
10006660:	ee33 4b0e 	vadd.f64	d4, d3, d14
10006664:	ee3e db4d 	vsub.f64	d13, d14, d13
10006668:	ee33 3b0b 	vadd.f64	d3, d3, d11
1000666c:	ee34 4b4b 	vsub.f64	d4, d4, d11
10006670:	eebc abca 	vcvt.u32.f64	s20, d10
10006674:	ee34 4b47 	vsub.f64	d4, d4, d7
10006678:	ee33 3b05 	vadd.f64	d3, d3, d5
1000667c:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10006680:	ee2d 5b0f 	vmul.f64	d5, d13, d15
10006684:	ee0a cb4e 	vmls.f64	d12, d10, d14
10006688:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000668c:	ee34 ab0a 	vadd.f64	d10, d4, d10
10006690:	ee20 4b0f 	vmul.f64	d4, d0, d15
10006694:	ee3c cb07 	vadd.f64	d12, d12, d7
10006698:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000669c:	eefc 7bc4 	vcvt.u32.f64	s15, d4
100066a0:	ed9d bb12 	vldr	d11, [sp, #72]	@ 0x48
100066a4:	ee05 db4e 	vmls.f64	d13, d5, d14
100066a8:	ee3b bb05 	vadd.f64	d11, d11, d5
100066ac:	eeb8 5b67 	vcvt.f64.u32	d5, s15
100066b0:	ed9f 7b65 	vldr	d7, [pc, #404]	@ 10006848 <fndsa_vect_iFFT_fp64_exact+0x410>
100066b4:	ee05 0b4e 	vmls.f64	d0, d5, d14
100066b8:	ee21 5b0f 	vmul.f64	d5, d1, d15
100066bc:	ee30 0b07 	vadd.f64	d0, d0, d7
100066c0:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100066c4:	ed8d 0b12 	vstr	d0, [sp, #72]	@ 0x48
100066c8:	ee28 0b0f 	vmul.f64	d0, d8, d15
100066cc:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100066d0:	eebc 0bc0 	vcvt.u32.f64	s0, d0
100066d4:	ee05 1b4e 	vmls.f64	d1, d5, d14
100066d8:	eeb8 0b40 	vcvt.f64.u32	d0, s0
100066dc:	ee00 8b4e 	vmls.f64	d8, d0, d14
100066e0:	ee31 0b07 	vadd.f64	d0, d1, d7
100066e4:	ed9d 1b02 	vldr	d1, [sp, #8]
100066e8:	ee21 5b0f 	vmul.f64	d5, d1, d15
100066ec:	eeb0 4b4d 	vmov.f64	d4, d13
100066f0:	ed8d db52 	vstr	d13, [sp, #328]	@ 0x148
100066f4:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100066f8:	ee22 db0f 	vmul.f64	d13, d2, d15
100066fc:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10006700:	eebc dbcd 	vcvt.u32.f64	s26, d13
10006704:	ee05 1b4e 	vmls.f64	d1, d5, d14
10006708:	eeb8 5b4d 	vcvt.f64.u32	d5, s26
1000670c:	ee31 db07 	vadd.f64	d13, d1, d7
10006710:	ee05 2b4e 	vmls.f64	d2, d5, d14
10006714:	ed8d db02 	vstr	d13, [sp, #8]
10006718:	ee23 5b0f 	vmul.f64	d5, d3, d15
1000671c:	ee32 db07 	vadd.f64	d13, d2, d7
10006720:	ee29 2b0f 	vmul.f64	d2, d9, d15
10006724:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10006728:	eebc 2bc2 	vcvt.u32.f64	s4, d2
1000672c:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10006730:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10006734:	ee05 3b4e 	vmls.f64	d3, d5, d14
10006738:	ee02 9b4e 	vmls.f64	d9, d2, d14
1000673c:	ee2a 5b0f 	vmul.f64	d5, d10, d15
10006740:	ed8d db14 	vstr	d13, [sp, #80]	@ 0x50
10006744:	ee33 db07 	vadd.f64	d13, d3, d7
10006748:	ee39 3b07 	vadd.f64	d3, d9, d7
1000674c:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10006750:	ed8d 3b16 	vstr	d3, [sp, #88]	@ 0x58
10006754:	ee2b 3b0f 	vmul.f64	d3, d11, d15
10006758:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000675c:	eefc 2bc3 	vcvt.u32.f64	s5, d3
10006760:	ee05 ab4e 	vmls.f64	d10, d5, d14
10006764:	eeb8 5b62 	vcvt.f64.u32	d5, s5
10006768:	ee05 bb4e 	vmls.f64	d11, d5, d14
1000676c:	eebc 5bcb 	vcvt.u32.f64	s10, d11
10006770:	ee3a 3b07 	vadd.f64	d3, d10, d7
10006774:	ee15 3a10 	vmov	r3, s10
10006778:	ed9d 1b0c 	vldr	d1, [sp, #48]	@ 0x30
1000677c:	ed8d 3b18 	vstr	d3, [sp, #96]	@ 0x60
10006780:	ee34 3b06 	vadd.f64	d3, d4, d6
10006784:	ee26 6b0f 	vmul.f64	d6, d6, d15
10006788:	0fdb      	lsrs	r3, r3, #31
1000678a:	ee05 3a10 	vmov	s10, r3
1000678e:	ed8d 6b4c 	vstr	d6, [sp, #304]	@ 0x130
10006792:	ee21 6b0f 	vmul.f64	d6, d1, d15
10006796:	ed9d ab0a 	vldr	d10, [sp, #40]	@ 0x28
1000679a:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
1000679e:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100067a2:	ee24 4b0f 	vmul.f64	d4, d4, d15
100067a6:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100067aa:	ed8d 5b58 	vstr	d5, [sp, #352]	@ 0x160
100067ae:	ee2a 5b0f 	vmul.f64	d5, d10, d15
100067b2:	eeb6 9b00 	vmov.f64	d9, #96	@ 0x3f000000  0.5
100067b6:	ed8d 4b56 	vstr	d4, [sp, #344]	@ 0x158
100067ba:	ee06 1b4e 	vmls.f64	d1, d6, d14
100067be:	eefc 4bc5 	vcvt.u32.f64	s9, d5
100067c2:	ed9d 2b12 	vldr	d2, [sp, #72]	@ 0x48
100067c6:	ee21 5b09 	vmul.f64	d5, d1, d9
100067ca:	ee32 2b06 	vadd.f64	d2, d2, d6
100067ce:	eeb8 6b64 	vcvt.f64.u32	d6, s9
100067d2:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100067d6:	ee06 ab4e 	vmls.f64	d10, d6, d14
100067da:	ee30 1b06 	vadd.f64	d1, d0, d6
100067de:	ee2a 4b09 	vmul.f64	d4, d10, d9
100067e2:	eeb0 0b49 	vmov.f64	d0, d9
100067e6:	eeb8 6b45 	vcvt.f64.u32	d6, s10
100067ea:	ed9d 9b10 	vldr	d9, [sp, #64]	@ 0x40
100067ee:	ed8d 6b0c 	vstr	d6, [sp, #48]	@ 0x30
100067f2:	ee29 6b0f 	vmul.f64	d6, d9, d15
100067f6:	ed9d ab0e 	vldr	d10, [sp, #56]	@ 0x38
100067fa:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100067fe:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006802:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10006806:	ee2a 5b0f 	vmul.f64	d5, d10, d15
1000680a:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000680e:	ed8d 4b10 	vstr	d4, [sp, #64]	@ 0x40
10006812:	ee06 9b4e 	vmls.f64	d9, d6, d14
10006816:	eefc 4bc5 	vcvt.u32.f64	s9, d5
1000681a:	ee38 8b07 	vadd.f64	d8, d8, d7
1000681e:	ee29 5b00 	vmul.f64	d5, d9, d0
10006822:	ee38 8b06 	vadd.f64	d8, d8, d6
10006826:	eeb8 6b64 	vcvt.f64.u32	d6, s9
1000682a:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000682e:	ee06 ab4e 	vmls.f64	d10, d6, d14
10006832:	ed9d 7b08 	vldr	d7, [sp, #32]
10006836:	e00d      	b.n	10006854 <fndsa_vect_iFFT_fp64_exact+0x41c>
10006838:	00000000 	.word	0x00000000
1000683c:	3df00000 	.word	0x3df00000
10006840:	00000000 	.word	0x00000000
10006844:	41f00000 	.word	0x41f00000
	...
10006850:	300039a0 	.word	0x300039a0
10006854:	ee2a 4b00 	vmul.f64	d4, d10, d0
10006858:	ed9d 9b02 	vldr	d9, [sp, #8]
1000685c:	eeb8 ab45 	vcvt.f64.u32	d10, s10
10006860:	ee39 9b06 	vadd.f64	d9, d9, d6
10006864:	ed8d ab0a 	vstr	d10, [sp, #40]	@ 0x28
10006868:	ee27 6b0f 	vmul.f64	d6, d7, d15
1000686c:	ed9d ab06 	vldr	d10, [sp, #24]
10006870:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10006874:	ee2a 5b0f 	vmul.f64	d5, d10, d15
10006878:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000687c:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006880:	ed8d 4b08 	vstr	d4, [sp, #32]
10006884:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006888:	eefc 4bc5 	vcvt.u32.f64	s9, d5
1000688c:	ed8d bb50 	vstr	d11, [sp, #320]	@ 0x140
10006890:	ed9d 5b14 	vldr	d5, [sp, #80]	@ 0x50
10006894:	ee06 7b4e 	vmls.f64	d7, d6, d14
10006898:	ee35 5b06 	vadd.f64	d5, d5, d6
1000689c:	eeb8 6b64 	vcvt.f64.u32	d6, s9
100068a0:	eeb0 4b4a 	vmov.f64	d4, d10
100068a4:	ed8d 5b06 	vstr	d5, [sp, #24]
100068a8:	ee06 4b4e 	vmls.f64	d4, d6, d14
100068ac:	ee27 5b00 	vmul.f64	d5, d7, d0
100068b0:	ed9d ab04 	vldr	d10, [sp, #16]
100068b4:	ee24 4b00 	vmul.f64	d4, d4, d0
100068b8:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100068bc:	eeb0 7b40 	vmov.f64	d7, d0
100068c0:	ee3d db06 	vadd.f64	d13, d13, d6
100068c4:	eeb8 0b45 	vcvt.f64.u32	d0, s10
100068c8:	ee2a 6b0f 	vmul.f64	d6, d10, d15
100068cc:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100068d0:	ed8d 0b0e 	vstr	d0, [sp, #56]	@ 0x38
100068d4:	ee2c 5b0f 	vmul.f64	d5, d12, d15
100068d8:	eeb8 0b44 	vcvt.f64.u32	d0, s8
100068dc:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100068e0:	ed8d 0b04 	vstr	d0, [sp, #16]
100068e4:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100068e8:	eefc 0bc5 	vcvt.u32.f64	s1, d5
100068ec:	ed9d 5b16 	vldr	d5, [sp, #88]	@ 0x58
100068f0:	ee35 4b06 	vadd.f64	d4, d5, d6
100068f4:	eeb0 5b4a 	vmov.f64	d5, d10
100068f8:	ee06 5b4e 	vmls.f64	d5, d6, d14
100068fc:	eeb8 6b60 	vcvt.f64.u32	d6, s1
10006900:	eeb0 0b47 	vmov.f64	d0, d7
10006904:	ee06 cb4e 	vmls.f64	d12, d6, d14
10006908:	ee25 5b07 	vmul.f64	d5, d5, d7
1000690c:	ee2c cb00 	vmul.f64	d12, d12, d0
10006910:	ed9d 7b18 	vldr	d7, [sp, #96]	@ 0x60
10006914:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10006918:	ee37 7b06 	vadd.f64	d7, d7, d6
1000691c:	eefc 5bcc 	vcvt.u32.f64	s11, d12
10006920:	ed8d 7b02 	vstr	d7, [sp, #8]
10006924:	eeb8 cb45 	vcvt.f64.u32	d12, s10
10006928:	ed9d 7b00 	vldr	d7, [sp]
1000692c:	eeb8 5b65 	vcvt.f64.u32	d5, s11
10006930:	ed8d 5b18 	vstr	d5, [sp, #96]	@ 0x60
10006934:	ee3b 5b07 	vadd.f64	d5, d11, d7
10006938:	ee27 7b0f 	vmul.f64	d7, d7, d15
1000693c:	ee23 6b0f 	vmul.f64	d6, d3, d15
10006940:	ed8d 7b4a 	vstr	d7, [sp, #296]	@ 0x128
10006944:	ee22 7b0f 	vmul.f64	d7, d2, d15
10006948:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000694c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006950:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006954:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006958:	ee06 3b4e 	vmls.f64	d3, d6, d14
1000695c:	ee35 5b06 	vadd.f64	d5, d5, d6
10006960:	ee21 6b0f 	vmul.f64	d6, d1, d15
10006964:	ee07 2b4e 	vmls.f64	d2, d7, d14
10006968:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000696c:	eefc 7bc2 	vcvt.u32.f64	s15, d2
10006970:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006974:	ee17 2a90 	vmov	r2, s15
10006978:	ee06 1b4e 	vmls.f64	d1, d6, d14
1000697c:	0fd3      	lsrs	r3, r2, #31
1000697e:	eefc 7bc1 	vcvt.u32.f64	s15, d1
10006982:	ee07 3a10 	vmov	s14, r3
10006986:	0853      	lsrs	r3, r2, #1
10006988:	ee2b bb0f 	vmul.f64	d11, d11, d15
1000698c:	ee00 3a10 	vmov	s0, r3
10006990:	ee17 ca90 	vmov	ip, s15
10006994:	ed8d bb54 	vstr	d11, [sp, #336]	@ 0x150
10006998:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
1000699c:	ee23 bb0f 	vmul.f64	d11, d3, d15
100069a0:	ed8d 3b5c 	vstr	d3, [sp, #368]	@ 0x170
100069a4:	eeb8 0bc0 	vcvt.f64.s32	d0, s0
100069a8:	ed9f 3bfb 	vldr	d3, [pc, #1004]	@ 10006d98 <fndsa_vect_iFFT_fp64_exact+0x960>
100069ac:	ea4f 73dc 	mov.w	r3, ip, lsr #31
100069b0:	ee07 0b03 	vmla.f64	d0, d7, d3
100069b4:	f002 0201 	and.w	r2, r2, #1
100069b8:	ee07 3a10 	vmov	s14, r3
100069bc:	ea4f 035c 	mov.w	r3, ip, lsr #1
100069c0:	ee07 2a90 	vmov	s15, r2
100069c4:	ee02 3a10 	vmov	s4, r3
100069c8:	eeb8 6be7 	vcvt.f64.s32	d6, s15
100069cc:	eeb8 2bc2 	vcvt.f64.s32	d2, s4
100069d0:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100069d4:	f00c 0301 	and.w	r3, ip, #1
100069d8:	ee07 2b03 	vmla.f64	d2, d7, d3
100069dc:	ed9d 1b0c 	vldr	d1, [sp, #48]	@ 0x30
100069e0:	ee07 3a90 	vmov	s15, r3
100069e4:	ee06 1b03 	vmla.f64	d1, d6, d3
100069e8:	eeb8 7be7 	vcvt.f64.s32	d7, s15
100069ec:	eeb0 6b43 	vmov.f64	d6, d3
100069f0:	ed9d 3b10 	vldr	d3, [sp, #64]	@ 0x40
100069f4:	ee07 3b06 	vmla.f64	d3, d7, d6
100069f8:	ee28 7b0f 	vmul.f64	d7, d8, d15
100069fc:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006a00:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006a04:	eeb0 ab46 	vmov.f64	d10, d6
10006a08:	ee29 6b0f 	vmul.f64	d6, d9, d15
10006a0c:	ee07 8b4e 	vmls.f64	d8, d7, d14
10006a10:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006a14:	eefc 7bc8 	vcvt.u32.f64	s15, d8
10006a18:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006a1c:	ee17 2a90 	vmov	r2, s15
10006a20:	ee06 9b4e 	vmls.f64	d9, d6, d14
10006a24:	0fd3      	lsrs	r3, r2, #31
10006a26:	ee07 3a10 	vmov	s14, r3
10006a2a:	0853      	lsrs	r3, r2, #1
10006a2c:	eefc 7bc9 	vcvt.u32.f64	s15, d9
10006a30:	ee06 3a10 	vmov	s12, r3
10006a34:	ee17 ca90 	vmov	ip, s15
10006a38:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10006a3c:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10006a40:	ee07 6b0a 	vmla.f64	d6, d7, d10
10006a44:	ea4f 73dc 	mov.w	r3, ip, lsr #31
10006a48:	ed8d 6b14 	vstr	d6, [sp, #80]	@ 0x50
10006a4c:	f002 0201 	and.w	r2, r2, #1
10006a50:	ee06 3a10 	vmov	s12, r3
10006a54:	ea4f 035c 	mov.w	r3, ip, lsr #1
10006a58:	ee07 2a90 	vmov	s15, r2
10006a5c:	ee07 3a10 	vmov	s14, r3
10006a60:	eeb0 9b4a 	vmov.f64	d9, d10
10006a64:	eeb8 8be7 	vcvt.f64.s32	d8, s15
10006a68:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10006a6c:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10006a70:	ee06 7b09 	vmla.f64	d7, d6, d9
10006a74:	f00c 0301 	and.w	r3, ip, #1
10006a78:	ed9d ab0a 	vldr	d10, [sp, #40]	@ 0x28
10006a7c:	ed8d 7b10 	vstr	d7, [sp, #64]	@ 0x40
10006a80:	ee07 3a90 	vmov	s15, r3
10006a84:	ee08 ab09 	vmla.f64	d10, d8, d9
10006a88:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10006a8c:	eeb0 8b49 	vmov.f64	d8, d9
10006a90:	ed9d 9b08 	vldr	d9, [sp, #32]
10006a94:	ee07 9b08 	vmla.f64	d9, d7, d8
10006a98:	ed8d 9b12 	vstr	d9, [sp, #72]	@ 0x48
10006a9c:	ed9d 9b06 	vldr	d9, [sp, #24]
10006aa0:	ee29 7b0f 	vmul.f64	d7, d9, d15
10006aa4:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006aa8:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006aac:	ee2d 6b0f 	vmul.f64	d6, d13, d15
10006ab0:	ee07 9b4e 	vmls.f64	d9, d7, d14
10006ab4:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006ab8:	eefc 7bc9 	vcvt.u32.f64	s15, d9
10006abc:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006ac0:	ee17 2a90 	vmov	r2, s15
10006ac4:	ee06 db4e 	vmls.f64	d13, d6, d14
10006ac8:	0fd3      	lsrs	r3, r2, #31
10006aca:	ee06 3a10 	vmov	s12, r3
10006ace:	0853      	lsrs	r3, r2, #1
10006ad0:	eefc 7bcd 	vcvt.u32.f64	s15, d13
10006ad4:	ee07 3a10 	vmov	s14, r3
10006ad8:	ee17 ca90 	vmov	ip, s15
10006adc:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10006ae0:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10006ae4:	ed8d ab16 	vstr	d10, [sp, #88]	@ 0x58
10006ae8:	f002 0201 	and.w	r2, r2, #1
10006aec:	eeb0 ab47 	vmov.f64	d10, d7
10006af0:	ee07 2a90 	vmov	s15, r2
10006af4:	ea4f 73dc 	mov.w	r3, ip, lsr #31
10006af8:	ee06 ab08 	vmla.f64	d10, d6, d8
10006afc:	ee06 3a10 	vmov	s12, r3
10006b00:	ea4f 035c 	mov.w	r3, ip, lsr #1
10006b04:	eeb0 9b48 	vmov.f64	d9, d8
10006b08:	ed9d db0e 	vldr	d13, [sp, #56]	@ 0x38
10006b0c:	eeb8 8be7 	vcvt.f64.s32	d8, s15
10006b10:	ee07 3a10 	vmov	s14, r3
10006b14:	ee08 db09 	vmla.f64	d13, d8, d9
10006b18:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10006b1c:	f00c 0301 	and.w	r3, ip, #1
10006b20:	ed8d db0e 	vstr	d13, [sp, #56]	@ 0x38
10006b24:	eeb0 db47 	vmov.f64	d13, d7
10006b28:	ee07 3a90 	vmov	s15, r3
10006b2c:	ed8d ab0c 	vstr	d10, [sp, #48]	@ 0x30
10006b30:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10006b34:	ed9d ab04 	vldr	d10, [sp, #16]
10006b38:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10006b3c:	ee07 ab09 	vmla.f64	d10, d7, d9
10006b40:	ee24 7b0f 	vmul.f64	d7, d4, d15
10006b44:	ee06 db09 	vmla.f64	d13, d6, d9
10006b48:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006b4c:	ed8d db0a 	vstr	d13, [sp, #40]	@ 0x28
10006b50:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006b54:	ed9d db02 	vldr	d13, [sp, #8]
10006b58:	ee07 4b4e 	vmls.f64	d4, d7, d14
10006b5c:	ee2d 6b0f 	vmul.f64	d6, d13, d15
10006b60:	eefc 7bc4 	vcvt.u32.f64	s15, d4
10006b64:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006b68:	ee17 2a90 	vmov	r2, s15
10006b6c:	eeb8 7b46 	vcvt.f64.u32	d7, s12
10006b70:	ee07 db4e 	vmls.f64	d13, d7, d14
10006b74:	0fd3      	lsrs	r3, r2, #31
10006b76:	eefc 7bcd 	vcvt.u32.f64	s15, d13
10006b7a:	ee06 3a10 	vmov	s12, r3
10006b7e:	0853      	lsrs	r3, r2, #1
10006b80:	ee08 3a10 	vmov	s16, r3
10006b84:	ee17 ca90 	vmov	ip, s15
10006b88:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10006b8c:	eeb8 8bc8 	vcvt.f64.s32	d8, s16
10006b90:	ea4f 73dc 	mov.w	r3, ip, lsr #31
10006b94:	ee06 8b09 	vmla.f64	d8, d6, d9
10006b98:	f002 0201 	and.w	r2, r2, #1
10006b9c:	ee06 3a10 	vmov	s12, r3
10006ba0:	ea4f 035c 	mov.w	r3, ip, lsr #1
10006ba4:	ee07 2a90 	vmov	s15, r2
10006ba8:	ee07 3a10 	vmov	s14, r3
10006bac:	eeb8 4be7 	vcvt.f64.s32	d4, s15
10006bb0:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10006bb4:	f00c 0301 	and.w	r3, ip, #1
10006bb8:	ee04 cb09 	vmla.f64	d12, d4, d9
10006bbc:	eeb0 4b47 	vmov.f64	d4, d7
10006bc0:	ee07 3a90 	vmov	s15, r3
10006bc4:	ed8d cb04 	vstr	d12, [sp, #16]
10006bc8:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10006bcc:	ed9d cb18 	vldr	d12, [sp, #96]	@ 0x60
10006bd0:	ee07 cb09 	vmla.f64	d12, d7, d9
10006bd4:	ee25 7b0f 	vmul.f64	d7, d5, d15
10006bd8:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006bdc:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006be0:	ee07 5b4e 	vmls.f64	d5, d7, d14
10006be4:	eebc 7bc5 	vcvt.u32.f64	s14, d5
10006be8:	ee17 3a10 	vmov	r3, s14
10006bec:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10006bf0:	0fdb      	lsrs	r3, r3, #31
10006bf2:	ee06 4b09 	vmla.f64	d4, d6, d9
10006bf6:	ee07 3a10 	vmov	s14, r3
10006bfa:	ed8d 4b00 	vstr	d4, [sp]
10006bfe:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10006c02:	ed8d ab08 	vstr	d10, [sp, #32]
10006c06:	ed8d cb02 	vstr	d12, [sp, #8]
10006c0a:	ed8d 5b5a 	vstr	d5, [sp, #360]	@ 0x168
10006c0e:	ee25 5b0f 	vmul.f64	d5, d5, d15
10006c12:	a846      	add	r0, sp, #280	@ 0x118
10006c14:	ed8d 7b62 	vstr	d7, [sp, #392]	@ 0x188
10006c18:	ed8d 5b5e 	vstr	d5, [sp, #376]	@ 0x178
10006c1c:	ed8d bb60 	vstr	d11, [sp, #384]	@ 0x180
10006c20:	f7fe f806 	bl	10004c30 <fp64e_cmul_prepared>
10006c24:	edd6 7a06 	vldr	s15, [r6, #24]
10006c28:	6973      	ldr	r3, [r6, #20]
10006c2a:	eeb8 5b67 	vcvt.f64.u32	d5, s15
10006c2e:	0fdb      	lsrs	r3, r3, #31
10006c30:	edd6 7a07 	vldr	s15, [r6, #28]
10006c34:	ee04 3a10 	vmov	s8, r3
10006c38:	eeb8 6b67 	vcvt.f64.u32	d6, s15
10006c3c:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
10006c40:	ee3e 5b45 	vsub.f64	d5, d14, d5
10006c44:	ed8d 4b4e 	vstr	d4, [sp, #312]	@ 0x138
10006c48:	ee3e 6b46 	vsub.f64	d6, d14, d6
10006c4c:	eeb7 4b00 	vmov.f64	d4, #112	@ 0x3f800000  1.0
10006c50:	edd6 7a04 	vldr	s15, [r6, #16]
10006c54:	ee36 6b44 	vsub.f64	d6, d6, d4
10006c58:	ee25 4b0f 	vmul.f64	d4, d5, d15
10006c5c:	eeb0 cb40 	vmov.f64	d12, d0
10006c60:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10006c64:	eeb0 0b48 	vmov.f64	d0, d8
10006c68:	eeb8 8b67 	vcvt.f64.u32	d8, s15
10006c6c:	edd6 7a05 	vldr	s15, [r6, #20]
10006c70:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10006c74:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10006c78:	ee36 6b04 	vadd.f64	d6, d6, d4
10006c7c:	ee27 bb0f 	vmul.f64	d11, d7, d15
10006c80:	ed8d bb4a 	vstr	d11, [sp, #296]	@ 0x128
10006c84:	ee26 bb0f 	vmul.f64	d11, d6, d15
10006c88:	eebc bbcb 	vcvt.u32.f64	s22, d11
10006c8c:	ee04 5b4e 	vmls.f64	d5, d4, d14
10006c90:	eeb8 bb4b 	vcvt.f64.u32	d11, s22
10006c94:	ee35 4b08 	vadd.f64	d4, d5, d8
10006c98:	ee0b 6b4e 	vmls.f64	d6, d11, d14
10006c9c:	ed8d 5b52 	vstr	d5, [sp, #328]	@ 0x148
10006ca0:	ee25 5b0f 	vmul.f64	d5, d5, d15
10006ca4:	ed8d 5b56 	vstr	d5, [sp, #344]	@ 0x158
10006ca8:	eefc 5bc6 	vcvt.u32.f64	s11, d6
10006cac:	ee15 3a90 	vmov	r3, s11
10006cb0:	ed8d 7b46 	vstr	d7, [sp, #280]	@ 0x118
10006cb4:	ed8d 6b50 	vstr	d6, [sp, #320]	@ 0x140
10006cb8:	ee36 7b07 	vadd.f64	d7, d6, d7
10006cbc:	ee26 6b0f 	vmul.f64	d6, d6, d15
10006cc0:	0fdb      	lsrs	r3, r3, #31
10006cc2:	ed8d 6b54 	vstr	d6, [sp, #336]	@ 0x150
10006cc6:	ee06 3a10 	vmov	s12, r3
10006cca:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10006cce:	ed8d 6b58 	vstr	d6, [sp, #352]	@ 0x160
10006cd2:	ee24 6b0f 	vmul.f64	d6, d4, d15
10006cd6:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006cda:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006cde:	ee37 7b06 	vadd.f64	d7, d7, d6
10006ce2:	ee06 4b4e 	vmls.f64	d4, d6, d14
10006ce6:	ee27 6b0f 	vmul.f64	d6, d7, d15
10006cea:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006cee:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006cf2:	ee06 7b4e 	vmls.f64	d7, d6, d14
10006cf6:	eefc 6bc7 	vcvt.u32.f64	s13, d7
10006cfa:	ee16 3a90 	vmov	r3, s13
10006cfe:	ed8d 7b5a 	vstr	d7, [sp, #360]	@ 0x168
10006d02:	ee27 7b0f 	vmul.f64	d7, d7, d15
10006d06:	0fdb      	lsrs	r3, r3, #31
10006d08:	ed8d 7b5e 	vstr	d7, [sp, #376]	@ 0x178
10006d0c:	ee07 3a10 	vmov	s14, r3
10006d10:	eeb0 9b43 	vmov.f64	d9, d3
10006d14:	eeb0 ab41 	vmov.f64	d10, d1
10006d18:	eeb0 db42 	vmov.f64	d13, d2
10006d1c:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10006d20:	ed8d 8b48 	vstr	d8, [sp, #288]	@ 0x120
10006d24:	ed8d 4b5c 	vstr	d4, [sp, #368]	@ 0x170
10006d28:	ee28 8b0f 	vmul.f64	d8, d8, d15
10006d2c:	ee24 4b0f 	vmul.f64	d4, d4, d15
10006d30:	ed9d 2b00 	vldr	d2, [sp]
10006d34:	ed9d 1b04 	vldr	d1, [sp, #16]
10006d38:	ed9d 3b02 	vldr	d3, [sp, #8]
10006d3c:	ed8d 7b62 	vstr	d7, [sp, #392]	@ 0x188
10006d40:	ed8d cb2e 	vstr	d12, [sp, #184]	@ 0xb8
10006d44:	ed8d ab30 	vstr	d10, [sp, #192]	@ 0xc0
10006d48:	ed8d db32 	vstr	d13, [sp, #200]	@ 0xc8
10006d4c:	ed8d 9b34 	vstr	d9, [sp, #208]	@ 0xd0
10006d50:	ed8d 8b4c 	vstr	d8, [sp, #304]	@ 0x130
10006d54:	ed8d 4b60 	vstr	d4, [sp, #384]	@ 0x180
10006d58:	f7fd ff6a 	bl	10004c30 <fp64e_cmul_prepared>
10006d5c:	edd7 7a02 	vldr	s15, [r7, #8]
10006d60:	edd7 5a00 	vldr	s11, [r7]
10006d64:	687b      	ldr	r3, [r7, #4]
10006d66:	eeb8 4b65 	vcvt.f64.u32	d4, s11
10006d6a:	0fdb      	lsrs	r3, r3, #31
10006d6c:	edd7 5a01 	vldr	s11, [r7, #4]
10006d70:	eeb8 6b67 	vcvt.f64.u32	d6, s15
10006d74:	ee05 3a10 	vmov	s10, r3
10006d78:	edd7 7a03 	vldr	s15, [r7, #12]
10006d7c:	eeb8 8b65 	vcvt.f64.u32	d8, s11
10006d80:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10006d84:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
10006d88:	ee3e bb46 	vsub.f64	d11, d14, d6
10006d8c:	ed8d 5b4e 	vstr	d5, [sp, #312]	@ 0x138
10006d90:	ee3e 7b47 	vsub.f64	d7, d14, d7
10006d94:	e008      	b.n	10006da8 <fndsa_vect_iFFT_fp64_exact+0x970>
10006d96:	bf00      	nop
10006d98:	00000000 	.word	0x00000000
10006d9c:	41e00000 	.word	0x41e00000
	...
10006da8:	eeb7 5b00 	vmov.f64	d5, #112	@ 0x3f800000  1.0
10006dac:	ed8d bb06 	vstr	d11, [sp, #24]
10006db0:	ee37 bb45 	vsub.f64	d11, d7, d5
10006db4:	ed9d 6b16 	vldr	d6, [sp, #88]	@ 0x58
10006db8:	ed8d bb1a 	vstr	d11, [sp, #104]	@ 0x68
10006dbc:	ed9d bb0e 	vldr	d11, [sp, #56]	@ 0x38
10006dc0:	ee36 7b0e 	vadd.f64	d7, d6, d14
10006dc4:	ee3b 6b06 	vadd.f64	d6, d11, d6
10006dc8:	ed9d 5b08 	vldr	d5, [sp, #32]
10006dcc:	ed8d 6b0e 	vstr	d6, [sp, #56]	@ 0x38
10006dd0:	ed9d 6b12 	vldr	d6, [sp, #72]	@ 0x48
10006dd4:	ee37 7b4b 	vsub.f64	d7, d7, d11
10006dd8:	ee36 bb0e 	vadd.f64	d11, d6, d14
10006ddc:	ee35 6b06 	vadd.f64	d6, d5, d6
10006de0:	ed8d 6b04 	vstr	d6, [sp, #16]
10006de4:	ee3a 6b0e 	vadd.f64	d6, d10, d14
10006de8:	ed8d 1b38 	vstr	d1, [sp, #224]	@ 0xe0
10006dec:	ee3a ab01 	vadd.f64	d10, d10, d1
10006df0:	ee36 1b41 	vsub.f64	d1, d6, d1
10006df4:	ee39 6b0e 	vadd.f64	d6, d9, d14
10006df8:	ed8d 0b36 	vstr	d0, [sp, #216]	@ 0xd8
10006dfc:	ed8d 2b3a 	vstr	d2, [sp, #232]	@ 0xe8
10006e00:	ed8d 3b3c 	vstr	d3, [sp, #240]	@ 0xf0
10006e04:	ed8d 8b00 	vstr	d8, [sp]
10006e08:	ed8d 8b46 	vstr	d8, [sp, #280]	@ 0x118
10006e0c:	ed8d 4b48 	vstr	d4, [sp, #288]	@ 0x120
10006e10:	ed8d 1b08 	vstr	d1, [sp, #32]
10006e14:	ed8d 7b02 	vstr	d7, [sp, #8]
10006e18:	ee39 1b03 	vadd.f64	d1, d9, d3
10006e1c:	ee36 9b43 	vsub.f64	d9, d6, d3
10006e20:	ed9d 3b14 	vldr	d3, [sp, #80]	@ 0x50
10006e24:	ed9d 8b0c 	vldr	d8, [sp, #48]	@ 0x30
10006e28:	ee3b bb45 	vsub.f64	d11, d11, d5
10006e2c:	ee27 6b0f 	vmul.f64	d6, d7, d15
10006e30:	ee33 5b0e 	vadd.f64	d5, d3, d14
10006e34:	eeb7 7b00 	vmov.f64	d7, #112	@ 0x3f800000  1.0
10006e38:	ee35 5b48 	vsub.f64	d5, d5, d8
10006e3c:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006e40:	ee38 3b03 	vadd.f64	d3, d8, d3
10006e44:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006e48:	eeb0 8b47 	vmov.f64	d8, d7
10006e4c:	ee35 5b47 	vsub.f64	d5, d5, d7
10006e50:	ed9d 7b02 	vldr	d7, [sp, #8]
10006e54:	ee06 7b4e 	vmls.f64	d7, d6, d14
10006e58:	ee35 5b06 	vadd.f64	d5, d5, d6
10006e5c:	ee37 7b08 	vadd.f64	d7, d7, d8
10006e60:	ed8d 5b0c 	vstr	d5, [sp, #48]	@ 0x30
10006e64:	ed8d 7b14 	vstr	d7, [sp, #80]	@ 0x50
10006e68:	ed9d 5b10 	vldr	d5, [sp, #64]	@ 0x40
10006e6c:	ee2b 7b0f 	vmul.f64	d7, d11, d15
10006e70:	ed9d 8b0a 	vldr	d8, [sp, #40]	@ 0x28
10006e74:	ee35 6b0e 	vadd.f64	d6, d5, d14
10006e78:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006e7c:	ee38 5b05 	vadd.f64	d5, d8, d5
10006e80:	ee36 6b48 	vsub.f64	d6, d6, d8
10006e84:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006e88:	eeb7 8b00 	vmov.f64	d8, #112	@ 0x3f800000  1.0
10006e8c:	ee07 bb4e 	vmls.f64	d11, d7, d14
10006e90:	ee36 6b48 	vsub.f64	d6, d6, d8
10006e94:	ee3b bb08 	vadd.f64	d11, d11, d8
10006e98:	ee36 7b07 	vadd.f64	d7, d6, d7
10006e9c:	ed9d 8b0e 	vldr	d8, [sp, #56]	@ 0x38
10006ea0:	ed8d 7b0a 	vstr	d7, [sp, #40]	@ 0x28
10006ea4:	ee28 7b0f 	vmul.f64	d7, d8, d15
10006ea8:	ed9d 6b04 	vldr	d6, [sp, #16]
10006eac:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006eb0:	ee26 6b0f 	vmul.f64	d6, d6, d15
10006eb4:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006eb8:	ed8d bb12 	vstr	d11, [sp, #72]	@ 0x48
10006ebc:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006ec0:	ee33 bb07 	vadd.f64	d11, d3, d7
10006ec4:	eeb0 3b48 	vmov.f64	d3, d8
10006ec8:	ee07 3b4e 	vmls.f64	d3, d7, d14
10006ecc:	eeb8 7b46 	vcvt.f64.u32	d7, s12
10006ed0:	ed9d 6b04 	vldr	d6, [sp, #16]
10006ed4:	eeb7 8b00 	vmov.f64	d8, #112	@ 0x3f800000  1.0
10006ed8:	ee07 6b4e 	vmls.f64	d6, d7, d14
10006edc:	ee33 3b08 	vadd.f64	d3, d3, d8
10006ee0:	ee36 6b08 	vadd.f64	d6, d6, d8
10006ee4:	ed8d 3b18 	vstr	d3, [sp, #96]	@ 0x60
10006ee8:	ed8d 6b16 	vstr	d6, [sp, #88]	@ 0x58
10006eec:	ee35 3b07 	vadd.f64	d3, d5, d7
10006ef0:	ee21 6b0f 	vmul.f64	d6, d1, d15
10006ef4:	ee2a 7b0f 	vmul.f64	d7, d10, d15
10006ef8:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006efc:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006f00:	ed8d 3b0e 	vstr	d3, [sp, #56]	@ 0x38
10006f04:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006f08:	eeb8 3b46 	vcvt.f64.u32	d3, s12
10006f0c:	ee07 ab4e 	vmls.f64	d10, d7, d14
10006f10:	ee03 1b4e 	vmls.f64	d1, d3, d14
10006f14:	ee3a ab08 	vadd.f64	d10, d10, d8
10006f18:	ee31 6b08 	vadd.f64	d6, d1, d8
10006f1c:	ed9d 8b08 	vldr	d8, [sp, #32]
10006f20:	ed8d 6b10 	vstr	d6, [sp, #64]	@ 0x40
10006f24:	ee28 6b0f 	vmul.f64	d6, d8, d15
10006f28:	ee3c 5b0e 	vadd.f64	d5, d12, d14
10006f2c:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006f30:	ee3c cb00 	vadd.f64	d12, d12, d0
10006f34:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006f38:	ee3c 1b07 	vadd.f64	d1, d12, d7
10006f3c:	ee35 5b40 	vsub.f64	d5, d5, d0
10006f40:	eeb7 7b00 	vmov.f64	d7, #112	@ 0x3f800000  1.0
10006f44:	eeb0 cb48 	vmov.f64	d12, d8
10006f48:	ee35 5b47 	vsub.f64	d5, d5, d7
10006f4c:	ee06 cb4e 	vmls.f64	d12, d6, d14
10006f50:	ee35 0b06 	vadd.f64	d0, d5, d6
10006f54:	ee3c cb07 	vadd.f64	d12, d12, d7
10006f58:	eeb0 5b47 	vmov.f64	d5, d7
10006f5c:	ee29 7b0f 	vmul.f64	d7, d9, d15
10006f60:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006f64:	ee3d 6b0e 	vadd.f64	d6, d13, d14
10006f68:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006f6c:	ee32 db0d 	vadd.f64	d13, d2, d13
10006f70:	ee07 9b4e 	vmls.f64	d9, d7, d14
10006f74:	ee36 6b42 	vsub.f64	d6, d6, d2
10006f78:	ed9d 8b06 	vldr	d8, [sp, #24]
10006f7c:	ee36 6b45 	vsub.f64	d6, d6, d5
10006f80:	ee3d 3b03 	vadd.f64	d3, d13, d3
10006f84:	ee39 db05 	vadd.f64	d13, d9, d5
10006f88:	ee36 2b07 	vadd.f64	d2, d6, d7
10006f8c:	ed8d db04 	vstr	d13, [sp, #16]
10006f90:	ee28 7b0f 	vmul.f64	d7, d8, d15
10006f94:	ed9d db0c 	vldr	d13, [sp, #48]	@ 0x30
10006f98:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006f9c:	ee2d 6b0f 	vmul.f64	d6, d13, d15
10006fa0:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006fa4:	eefc 5bc6 	vcvt.u32.f64	s11, d6
10006fa8:	ed9d 6b1a 	vldr	d6, [sp, #104]	@ 0x68
10006fac:	ee36 9b07 	vadd.f64	d9, d6, d7
10006fb0:	eeb0 6b48 	vmov.f64	d6, d8
10006fb4:	ee07 6b4e 	vmls.f64	d6, d7, d14
10006fb8:	eeb8 7b65 	vcvt.f64.u32	d7, s11
10006fbc:	eeb0 5b4d 	vmov.f64	d5, d13
10006fc0:	ed1f 8b89 	vldr	d8, [pc, #-548]	@ 10006da0 <fndsa_vect_iFFT_fp64_exact+0x968>
10006fc4:	ed8d cb02 	vstr	d12, [sp, #8]
10006fc8:	ee07 5b4e 	vmls.f64	d5, d7, d14
10006fcc:	ed9d cb0a 	vldr	d12, [sp, #40]	@ 0x28
10006fd0:	ee35 5b08 	vadd.f64	d5, d5, d8
10006fd4:	ee2c 7b0f 	vmul.f64	d7, d12, d15
10006fd8:	ed8d 5b08 	vstr	d5, [sp, #32]
10006fdc:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006fe0:	ee2b 5b0f 	vmul.f64	d5, d11, d15
10006fe4:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006fe8:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10006fec:	ee07 cb4e 	vmls.f64	d12, d7, d14
10006ff0:	eeb8 7b45 	vcvt.f64.u32	d7, s10
10006ff4:	ed9d db0e 	vldr	d13, [sp, #56]	@ 0x38
10006ff8:	ee07 bb4e 	vmls.f64	d11, d7, d14
10006ffc:	ee3c 7b08 	vadd.f64	d7, d12, d8
10007000:	eeb0 cb47 	vmov.f64	d12, d7
10007004:	ee2d 7b0f 	vmul.f64	d7, d13, d15
10007008:	ee21 5b0f 	vmul.f64	d5, d1, d15
1000700c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007010:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10007014:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007018:	ee07 db4e 	vmls.f64	d13, d7, d14
1000701c:	eeb8 7b45 	vcvt.f64.u32	d7, s10
10007020:	ee07 1b4e 	vmls.f64	d1, d7, d14
10007024:	ee3d 7b08 	vadd.f64	d7, d13, d8
10007028:	ed8d 7b06 	vstr	d7, [sp, #24]
1000702c:	ee23 7b0f 	vmul.f64	d7, d3, d15
10007030:	ee31 1b08 	vadd.f64	d1, d1, d8
10007034:	ee20 5b0f 	vmul.f64	d5, d0, d15
10007038:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000703c:	ed8d 1b0c 	vstr	d1, [sp, #48]	@ 0x30
10007040:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007044:	eefc 1bc5 	vcvt.u32.f64	s3, d5
10007048:	ee07 3b4e 	vmls.f64	d3, d7, d14
1000704c:	eeb8 7b61 	vcvt.f64.u32	d7, s3
10007050:	ee07 0b4e 	vmls.f64	d0, d7, d14
10007054:	ee22 7b0f 	vmul.f64	d7, d2, d15
10007058:	ee33 3b08 	vadd.f64	d3, d3, d8
1000705c:	ee29 5b0f 	vmul.f64	d5, d9, d15
10007060:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007064:	ed8d 3b1a 	vstr	d3, [sp, #104]	@ 0x68
10007068:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000706c:	eefc 3bc5 	vcvt.u32.f64	s7, d5
10007070:	ee07 2b4e 	vmls.f64	d2, d7, d14
10007074:	eeb8 7b63 	vcvt.f64.u32	d7, s7
10007078:	ee07 9b4e 	vmls.f64	d9, d7, d14
1000707c:	eebc 7bc9 	vcvt.u32.f64	s14, d9
10007080:	ee17 3a10 	vmov	r3, s14
10007084:	0fdb      	lsrs	r3, r3, #31
10007086:	ee07 3a10 	vmov	s14, r3
1000708a:	ee36 3b04 	vadd.f64	d3, d6, d4
1000708e:	ee32 2b08 	vadd.f64	d2, d2, d8
10007092:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10007096:	ee24 4b0f 	vmul.f64	d4, d4, d15
1000709a:	ed8d 6b52 	vstr	d6, [sp, #328]	@ 0x148
1000709e:	ed8d 2b1c 	vstr	d2, [sp, #112]	@ 0x70
100070a2:	ed8d 9b50 	vstr	d9, [sp, #320]	@ 0x140
100070a6:	ed8d 7b58 	vstr	d7, [sp, #352]	@ 0x160
100070aa:	ed8d 4b4c 	vstr	d4, [sp, #304]	@ 0x130
100070ae:	ed9d 2b14 	vldr	d2, [sp, #80]	@ 0x50
100070b2:	ed9d 1b12 	vldr	d1, [sp, #72]	@ 0x48
100070b6:	ee22 7b0f 	vmul.f64	d7, d2, d15
100070ba:	ee26 6b0f 	vmul.f64	d6, d6, d15
100070be:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100070c2:	ed8d 6b56 	vstr	d6, [sp, #344]	@ 0x158
100070c6:	ee21 6b0f 	vmul.f64	d6, d1, d15
100070ca:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100070ce:	eefc 5bc6 	vcvt.u32.f64	s11, d6
100070d2:	ed9d 4b08 	vldr	d4, [sp, #32]
100070d6:	eeb0 6b42 	vmov.f64	d6, d2
100070da:	ee34 4b07 	vadd.f64	d4, d4, d7
100070de:	ee07 6b4e 	vmls.f64	d6, d7, d14
100070e2:	eeb8 7b65 	vcvt.f64.u32	d7, s11
100070e6:	eeb0 5b41 	vmov.f64	d5, d1
100070ea:	ee30 0b08 	vadd.f64	d0, d0, d8
100070ee:	ee3b bb08 	vadd.f64	d11, d11, d8
100070f2:	ee07 5b4e 	vmls.f64	d5, d7, d14
100070f6:	eeb6 8b00 	vmov.f64	d8, #96	@ 0x3f000000  0.5
100070fa:	ee3c 2b07 	vadd.f64	d2, d12, d7
100070fe:	ee26 6b08 	vmul.f64	d6, d6, d8
10007102:	ed9d cb18 	vldr	d12, [sp, #96]	@ 0x60
10007106:	ee25 5b08 	vmul.f64	d5, d5, d8
1000710a:	ed9d db16 	vldr	d13, [sp, #88]	@ 0x58
1000710e:	ee2c 7b0f 	vmul.f64	d7, d12, d15
10007112:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007116:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000711a:	eeb8 1b46 	vcvt.f64.u32	d1, s12
1000711e:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10007122:	ee2d 6b0f 	vmul.f64	d6, d13, d15
10007126:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000712a:	ed8d 5b18 	vstr	d5, [sp, #96]	@ 0x60
1000712e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007132:	eefc 5bc6 	vcvt.u32.f64	s11, d6
10007136:	eeb0 6b4c 	vmov.f64	d6, d12
1000713a:	ee3b bb07 	vadd.f64	d11, d11, d7
1000713e:	ee07 6b4e 	vmls.f64	d6, d7, d14
10007142:	eeb8 7b65 	vcvt.f64.u32	d7, s11
10007146:	ed9d 5b06 	vldr	d5, [sp, #24]
1000714a:	ee26 6b08 	vmul.f64	d6, d6, d8
1000714e:	ee35 5b07 	vadd.f64	d5, d5, d7
10007152:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007156:	ed8d 5b08 	vstr	d5, [sp, #32]
1000715a:	eeb0 5b4d 	vmov.f64	d5, d13
1000715e:	ee07 5b4e 	vmls.f64	d5, d7, d14
10007162:	eeb8 7b46 	vcvt.f64.u32	d7, s12
10007166:	ed9d cb10 	vldr	d12, [sp, #64]	@ 0x40
1000716a:	ed8d 7b0a 	vstr	d7, [sp, #40]	@ 0x28
1000716e:	ee2a 7b0f 	vmul.f64	d7, d10, d15
10007172:	ee25 5b08 	vmul.f64	d5, d5, d8
10007176:	ee2c 6b0f 	vmul.f64	d6, d12, d15
1000717a:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000717e:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10007182:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007186:	eefc 5bc6 	vcvt.u32.f64	s11, d6
1000718a:	ed9d 6b0c 	vldr	d6, [sp, #48]	@ 0x30
1000718e:	ee07 ab4e 	vmls.f64	d10, d7, d14
10007192:	ee36 6b07 	vadd.f64	d6, d6, d7
10007196:	ed8d 6b06 	vstr	d6, [sp, #24]
1000719a:	ee2a 6b08 	vmul.f64	d6, d10, d8
1000719e:	eeb8 7b65 	vcvt.f64.u32	d7, s11
100071a2:	eeb8 db45 	vcvt.f64.u32	d13, s10
100071a6:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100071aa:	eeb0 5b4c 	vmov.f64	d5, d12
100071ae:	eeb8 cb46 	vcvt.f64.u32	d12, s12
100071b2:	ee07 5b4e 	vmls.f64	d5, d7, d14
100071b6:	ed9d ab1a 	vldr	d10, [sp, #104]	@ 0x68
100071ba:	ee25 5b08 	vmul.f64	d5, d5, d8
100071be:	ed8d cb12 	vstr	d12, [sp, #72]	@ 0x48
100071c2:	ed9d cb02 	vldr	d12, [sp, #8]
100071c6:	ee3a ab07 	vadd.f64	d10, d10, d7
100071ca:	ed8d db0e 	vstr	d13, [sp, #56]	@ 0x38
100071ce:	ee2c 7b0f 	vmul.f64	d7, d12, d15
100071d2:	ed9d db04 	vldr	d13, [sp, #16]
100071d6:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100071da:	ee2d 6b0f 	vmul.f64	d6, d13, d15
100071de:	eeb8 cb45 	vcvt.f64.u32	d12, s10
100071e2:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100071e6:	ed8d cb14 	vstr	d12, [sp, #80]	@ 0x50
100071ea:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100071ee:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100071f2:	ed9d cb02 	vldr	d12, [sp, #8]
100071f6:	ee30 5b07 	vadd.f64	d5, d0, d7
100071fa:	ee07 cb4e 	vmls.f64	d12, d7, d14
100071fe:	eeb8 7b46 	vcvt.f64.u32	d7, s12
10007202:	ed9d 0b1c 	vldr	d0, [sp, #112]	@ 0x70
10007206:	ee07 db4e 	vmls.f64	d13, d7, d14
1000720a:	ee2c 6b08 	vmul.f64	d6, d12, d8
1000720e:	ee2d db08 	vmul.f64	d13, d13, d8
10007212:	ee30 cb07 	vadd.f64	d12, d0, d7
10007216:	ee23 7b0f 	vmul.f64	d7, d3, d15
1000721a:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000721e:	ed9d 8b00 	vldr	d8, [sp]
10007222:	eefc 6bcd 	vcvt.u32.f64	s13, d13
10007226:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000722a:	eeb8 0b66 	vcvt.f64.u32	d0, s13
1000722e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007232:	eeb8 db46 	vcvt.f64.u32	d13, s12
10007236:	ee39 6b08 	vadd.f64	d6, d9, d8
1000723a:	ee28 8b0f 	vmul.f64	d8, d8, d15
1000723e:	ee07 3b4e 	vmls.f64	d3, d7, d14
10007242:	ed8d 8b4a 	vstr	d8, [sp, #296]	@ 0x128
10007246:	ee36 8b07 	vadd.f64	d8, d6, d7
1000724a:	ee24 7b0f 	vmul.f64	d7, d4, d15
1000724e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007252:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007256:	ee22 6b0f 	vmul.f64	d6, d2, d15
1000725a:	ee07 4b4e 	vmls.f64	d4, d7, d14
1000725e:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007262:	eefc 7bc4 	vcvt.u32.f64	s15, d4
10007266:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000726a:	ee17 2a90 	vmov	r2, s15
1000726e:	ee06 2b4e 	vmls.f64	d2, d6, d14
10007272:	0fd3      	lsrs	r3, r2, #31
10007274:	eefc 7bc2 	vcvt.u32.f64	s15, d2
10007278:	ee07 3a10 	vmov	s14, r3
1000727c:	0853      	lsrs	r3, r2, #1
1000727e:	ed8d 0b16 	vstr	d0, [sp, #88]	@ 0x58
10007282:	ee29 9b0f 	vmul.f64	d9, d9, d15
10007286:	ee00 3a10 	vmov	s0, r3
1000728a:	ee17 ca90 	vmov	ip, s15
1000728e:	ed8d 9b54 	vstr	d9, [sp, #336]	@ 0x150
10007292:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10007296:	ed9f 9be2 	vldr	d9, [pc, #904]	@ 10007620 <fndsa_vect_iFFT_fp64_exact+0x11e8>
1000729a:	eeb8 0bc0 	vcvt.f64.s32	d0, s0
1000729e:	ea4f 73dc 	mov.w	r3, ip, lsr #31
100072a2:	ee07 0b09 	vmla.f64	d0, d7, d9
100072a6:	f002 0201 	and.w	r2, r2, #1
100072aa:	ee07 3a10 	vmov	s14, r3
100072ae:	ea4f 035c 	mov.w	r3, ip, lsr #1
100072b2:	ee07 2a90 	vmov	s15, r2
100072b6:	ee02 3a10 	vmov	s4, r3
100072ba:	eeb8 6be7 	vcvt.f64.s32	d6, s15
100072be:	eeb8 2bc2 	vcvt.f64.s32	d2, s4
100072c2:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100072c6:	f00c 0301 	and.w	r3, ip, #1
100072ca:	ee07 2b09 	vmla.f64	d2, d7, d9
100072ce:	ed8d 3b5c 	vstr	d3, [sp, #368]	@ 0x170
100072d2:	ee07 3a90 	vmov	s15, r3
100072d6:	ee23 3b0f 	vmul.f64	d3, d3, d15
100072da:	eeb8 7be7 	vcvt.f64.s32	d7, s15
100072de:	ed8d 3b60 	vstr	d3, [sp, #384]	@ 0x180
100072e2:	ed9d 3b18 	vldr	d3, [sp, #96]	@ 0x60
100072e6:	ee07 3b09 	vmla.f64	d3, d7, d9
100072ea:	ee2b 7b0f 	vmul.f64	d7, d11, d15
100072ee:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100072f2:	ed9d 4b08 	vldr	d4, [sp, #32]
100072f6:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100072fa:	ee06 1b09 	vmla.f64	d1, d6, d9
100072fe:	ee07 bb4e 	vmls.f64	d11, d7, d14
10007302:	ee24 6b0f 	vmul.f64	d6, d4, d15
10007306:	eefc 7bcb 	vcvt.u32.f64	s15, d11
1000730a:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000730e:	ee17 2a90 	vmov	r2, s15
10007312:	eeb8 7b46 	vcvt.f64.u32	d7, s12
10007316:	eeb0 6b44 	vmov.f64	d6, d4
1000731a:	ee07 6b4e 	vmls.f64	d6, d7, d14
1000731e:	0fd3      	lsrs	r3, r2, #31
10007320:	eefc 7bc6 	vcvt.u32.f64	s15, d6
10007324:	ee06 3a10 	vmov	s12, r3
10007328:	0853      	lsrs	r3, r2, #1
1000732a:	ee04 3a10 	vmov	s8, r3
1000732e:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10007332:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
10007336:	f002 0201 	and.w	r2, r2, #1
1000733a:	ee17 ea90 	vmov	lr, s15
1000733e:	ee06 4b09 	vmla.f64	d4, d6, d9
10007342:	ee07 2a90 	vmov	s15, r2
10007346:	ed8d 4b18 	vstr	d4, [sp, #96]	@ 0x60
1000734a:	eeb8 7be7 	vcvt.f64.s32	d7, s15
1000734e:	ed9d 4b0a 	vldr	d4, [sp, #40]	@ 0x28
10007352:	ea4f 73de 	mov.w	r3, lr, lsr #31
10007356:	ea4f 0c5e 	mov.w	ip, lr, lsr #1
1000735a:	ee07 4b09 	vmla.f64	d4, d7, d9
1000735e:	ee06 3a10 	vmov	s12, r3
10007362:	ee07 ca90 	vmov	s15, ip
10007366:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
1000736a:	eeb8 7be7 	vcvt.f64.s32	d7, s15
1000736e:	ee06 7b09 	vmla.f64	d7, d6, d9
10007372:	f00e 0301 	and.w	r3, lr, #1
10007376:	ed8d 4b10 	vstr	d4, [sp, #64]	@ 0x40
1000737a:	ed8d 7b0c 	vstr	d7, [sp, #48]	@ 0x30
1000737e:	ee07 3a90 	vmov	s15, r3
10007382:	ed9d 6b06 	vldr	d6, [sp, #24]
10007386:	ed9d bb0e 	vldr	d11, [sp, #56]	@ 0x38
1000738a:	eeb8 7be7 	vcvt.f64.s32	d7, s15
1000738e:	ee07 bb09 	vmla.f64	d11, d7, d9
10007392:	ee26 7b0f 	vmul.f64	d7, d6, d15
10007396:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000739a:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000739e:	eeb0 4b49 	vmov.f64	d4, d9
100073a2:	ee2a 9b0f 	vmul.f64	d9, d10, d15
100073a6:	ee07 6b4e 	vmls.f64	d6, d7, d14
100073aa:	eebc 9bc9 	vcvt.u32.f64	s18, d9
100073ae:	eefc 7bc6 	vcvt.u32.f64	s15, d6
100073b2:	eeb8 9b49 	vcvt.f64.u32	d9, s18
100073b6:	ee17 2a90 	vmov	r2, s15
100073ba:	ee09 ab4e 	vmls.f64	d10, d9, d14
100073be:	0fd3      	lsrs	r3, r2, #31
100073c0:	ee06 3a10 	vmov	s12, r3
100073c4:	0853      	lsrs	r3, r2, #1
100073c6:	eefc 7bca 	vcvt.u32.f64	s15, d10
100073ca:	ee07 3a10 	vmov	s14, r3
100073ce:	ee17 ea90 	vmov	lr, s15
100073d2:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100073d6:	f002 0201 	and.w	r2, r2, #1
100073da:	eeb0 ab47 	vmov.f64	d10, d7
100073de:	ee07 2a90 	vmov	s15, r2
100073e2:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
100073e6:	eeb8 7be7 	vcvt.f64.s32	d7, s15
100073ea:	ed9d 9b12 	vldr	d9, [sp, #72]	@ 0x48
100073ee:	ea4f 73de 	mov.w	r3, lr, lsr #31
100073f2:	ea4f 0c5e 	mov.w	ip, lr, lsr #1
100073f6:	ee06 ab04 	vmla.f64	d10, d6, d4
100073fa:	ee07 9b04 	vmla.f64	d9, d7, d4
100073fe:	ee06 3a10 	vmov	s12, r3
10007402:	ee07 ca90 	vmov	s15, ip
10007406:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
1000740a:	eeb8 7be7 	vcvt.f64.s32	d7, s15
1000740e:	ee06 7b04 	vmla.f64	d7, d6, d4
10007412:	f00e 0301 	and.w	r3, lr, #1
10007416:	ed8d 7b04 	vstr	d7, [sp, #16]
1000741a:	ee07 3a90 	vmov	s15, r3
1000741e:	ed9d 6b14 	vldr	d6, [sp, #80]	@ 0x50
10007422:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10007426:	ee07 6b04 	vmla.f64	d6, d7, d4
1000742a:	ee25 7b0f 	vmul.f64	d7, d5, d15
1000742e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007432:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007436:	ed8d 6b06 	vstr	d6, [sp, #24]
1000743a:	ee2c 6b0f 	vmul.f64	d6, d12, d15
1000743e:	ee07 5b4e 	vmls.f64	d5, d7, d14
10007442:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007446:	eefc 7bc5 	vcvt.u32.f64	s15, d5
1000744a:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000744e:	ee17 3a90 	vmov	r3, s15
10007452:	ee06 cb4e 	vmls.f64	d12, d6, d14
10007456:	0fda      	lsrs	r2, r3, #31
10007458:	ee07 2a10 	vmov	s14, r2
1000745c:	085a      	lsrs	r2, r3, #1
1000745e:	ed8d ab08 	vstr	d10, [sp, #32]
10007462:	eefc 7bcc 	vcvt.u32.f64	s15, d12
10007466:	ee0a 2a10 	vmov	s20, r2
1000746a:	ee17 ea90 	vmov	lr, s15
1000746e:	eeb8 abca 	vcvt.f64.s32	d10, s20
10007472:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10007476:	f003 0301 	and.w	r3, r3, #1
1000747a:	ee07 ab04 	vmla.f64	d10, d7, d4
1000747e:	ee07 3a90 	vmov	s15, r3
10007482:	ea4f 025e 	mov.w	r2, lr, lsr #1
10007486:	ed8d 9b0a 	vstr	d9, [sp, #40]	@ 0x28
1000748a:	ea4f 7cde 	mov.w	ip, lr, lsr #31
1000748e:	ee09 2a10 	vmov	s18, r2
10007492:	f00e 0201 	and.w	r2, lr, #1
10007496:	ee07 2a10 	vmov	s14, r2
1000749a:	eeb8 6be7 	vcvt.f64.s32	d6, s15
1000749e:	ee07 ca90 	vmov	s15, ip
100074a2:	ee06 db04 	vmla.f64	d13, d6, d4
100074a6:	ed9d 5b16 	vldr	d5, [sp, #88]	@ 0x58
100074aa:	eeb8 6be7 	vcvt.f64.s32	d6, s15
100074ae:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100074b2:	ee07 5b04 	vmla.f64	d5, d7, d4
100074b6:	ee28 7b0f 	vmul.f64	d7, d8, d15
100074ba:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100074be:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100074c2:	ee07 8b4e 	vmls.f64	d8, d7, d14
100074c6:	eebc 7bc8 	vcvt.u32.f64	s14, d8
100074ca:	ee17 3a10 	vmov	r3, s14
100074ce:	0fdb      	lsrs	r3, r3, #31
100074d0:	ee07 3a10 	vmov	s14, r3
100074d4:	ed8d 8b5a 	vstr	d8, [sp, #360]	@ 0x168
100074d8:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100074dc:	ee28 8b0f 	vmul.f64	d8, d8, d15
100074e0:	eeb8 9bc9 	vcvt.f64.s32	d9, s18
100074e4:	ed8d 5b00 	vstr	d5, [sp]
100074e8:	ee06 9b04 	vmla.f64	d9, d6, d4
100074ec:	ed8d 7b62 	vstr	d7, [sp, #392]	@ 0x188
100074f0:	ed8d bb0e 	vstr	d11, [sp, #56]	@ 0x38
100074f4:	ed8d db02 	vstr	d13, [sp, #8]
100074f8:	ed8d 8b5e 	vstr	d8, [sp, #376]	@ 0x178
100074fc:	f7fd fb98 	bl	10004c30 <fp64e_cmul_prepared>
10007500:	eeb0 bb40 	vmov.f64	d11, d0
10007504:	eeb0 db41 	vmov.f64	d13, d1
10007508:	eeb0 cb42 	vmov.f64	d12, d2
1000750c:	eeb0 8b43 	vmov.f64	d8, d3
10007510:	eeb0 0b4a 	vmov.f64	d0, d10
10007514:	eeb0 2b49 	vmov.f64	d2, d9
10007518:	ed9d 3b00 	vldr	d3, [sp]
1000751c:	ed9d 1b02 	vldr	d1, [sp, #8]
10007520:	ed8d bb1e 	vstr	d11, [sp, #120]	@ 0x78
10007524:	ed8d db20 	vstr	d13, [sp, #128]	@ 0x80
10007528:	ed8d cb22 	vstr	d12, [sp, #136]	@ 0x88
1000752c:	ed8d 8b24 	vstr	d8, [sp, #144]	@ 0x90
10007530:	f7fd fb7e 	bl	10004c30 <fp64e_cmul_prepared>
10007534:	ed9d 4b18 	vldr	d4, [sp, #96]	@ 0x60
10007538:	ed9d 7b0e 	vldr	d7, [sp, #56]	@ 0x38
1000753c:	ed81 4b00 	vstr	d4, [r1]
10007540:	ed9d 4b10 	vldr	d4, [sp, #64]	@ 0x40
10007544:	ed9d 5b0c 	vldr	d5, [sp, #48]	@ 0x30
10007548:	ed9d ab08 	vldr	d10, [sp, #32]
1000754c:	ed9d 9b0a 	vldr	d9, [sp, #40]	@ 0x28
10007550:	ed81 4b02 	vstr	d4, [r1, #8]
10007554:	ed9d 6b06 	vldr	d6, [sp, #24]
10007558:	ed84 7b02 	vstr	d7, [r4, #8]
1000755c:	ed9d 7b04 	vldr	d7, [sp, #16]
10007560:	ed84 5b00 	vstr	d5, [r4]
10007564:	3140      	adds	r1, #64	@ 0x40
10007566:	ed01 ab0c 	vstr	d10, [r1, #-48]	@ 0xffffffd0
1000756a:	ed01 9b0a 	vstr	d9, [r1, #-40]	@ 0xffffffd8
1000756e:	4588      	cmp	r8, r1
10007570:	ed84 7b04 	vstr	d7, [r4, #16]
10007574:	ed84 6b06 	vstr	d6, [r4, #24]
10007578:	ed8d 0b26 	vstr	d0, [sp, #152]	@ 0x98
1000757c:	ed01 bb08 	vstr	d11, [r1, #-32]	@ 0xffffffe0
10007580:	ed01 db06 	vstr	d13, [r1, #-24]	@ 0xffffffe8
10007584:	f104 0440 	add.w	r4, r4, #64	@ 0x40
10007588:	ed04 cb08 	vstr	d12, [r4, #-32]	@ 0xffffffe0
1000758c:	ed04 8b06 	vstr	d8, [r4, #-24]	@ 0xffffffe8
10007590:	f106 0620 	add.w	r6, r6, #32
10007594:	ed01 0b04 	vstr	d0, [r1, #-16]
10007598:	ed01 1b02 	vstr	d1, [r1, #-8]
1000759c:	f107 0710 	add.w	r7, r7, #16
100075a0:	ed8d 1b28 	vstr	d1, [sp, #160]	@ 0xa0
100075a4:	ed04 2b04 	vstr	d2, [r4, #-16]
100075a8:	ed04 3b02 	vstr	d3, [r4, #-8]
100075ac:	ed8d 2b2a 	vstr	d2, [sp, #168]	@ 0xa8
100075b0:	ed8d 3b2c 	vstr	d3, [sp, #176]	@ 0xb0
100075b4:	f47e af62 	bne.w	1000647c <fndsa_vect_iFFT_fp64_exact+0x44>
100075b8:	f04f 0e04 	mov.w	lr, #4
100075bc:	f1ab 0103 	sub.w	r1, fp, #3
100075c0:	2900      	cmp	r1, #0
100075c2:	f000 825b 	beq.w	10007a7c <fndsa_vect_iFFT_fp64_exact+0x1644>
100075c6:	2310      	movs	r3, #16
100075c8:	ed9f eb17 	vldr	d14, [pc, #92]	@ 10007628 <fndsa_vect_iFFT_fp64_exact+0x11f0>
100075cc:	ed9f fb18 	vldr	d15, [pc, #96]	@ 10007630 <fndsa_vect_iFFT_fp64_exact+0x11f8>
100075d0:	ed9f 9b13 	vldr	d9, [pc, #76]	@ 10007620 <fndsa_vect_iFFT_fp64_exact+0x11e8>
100075d4:	4e18      	ldr	r6, [pc, #96]	@ (10007638 <fndsa_vect_iFFT_fp64_exact+0x1200>)
100075d6:	fa03 fc0a 	lsl.w	ip, r3, sl
100075da:	4672      	mov	r2, lr
100075dc:	2301      	movs	r3, #1
100075de:	f04f 0810 	mov.w	r8, #16
100075e2:	eb05 1702 	add.w	r7, r5, r2, lsl #4
100075e6:	9208      	str	r2, [sp, #32]
100075e8:	eeb7 db00 	vmov.f64	d13, #112	@ 0x3f800000  1.0
100075ec:	462a      	mov	r2, r5
100075ee:	f04f 0b00 	mov.w	fp, #0
100075f2:	46e1      	mov	r9, ip
100075f4:	408b      	lsls	r3, r1
100075f6:	eb03 0353 	add.w	r3, r3, r3, lsr #1
100075fa:	ea4f 0e4e 	mov.w	lr, lr, lsl #1
100075fe:	fa08 f801 	lsl.w	r8, r8, r1
10007602:	eb06 1303 	add.w	r3, r6, r3, lsl #4
10007606:	eb08 0a06 	add.w	sl, r8, r6
1000760a:	9306      	str	r3, [sp, #24]
1000760c:	910a      	str	r1, [sp, #40]	@ 0x28
1000760e:	f8cd e010 	str.w	lr, [sp, #16]
10007612:	ea4f 180e 	mov.w	r8, lr, lsl #4
10007616:	960c      	str	r6, [sp, #48]	@ 0x30
10007618:	950e      	str	r5, [sp, #56]	@ 0x38
1000761a:	e00f      	b.n	1000763c <fndsa_vect_iFFT_fp64_exact+0x1204>
1000761c:	f3af 8000 	nop.w
10007620:	00000000 	.word	0x00000000
10007624:	41e00000 	.word	0x41e00000
10007628:	00000000 	.word	0x00000000
1000762c:	41f00000 	.word	0x41f00000
10007630:	00000000 	.word	0x00000000
10007634:	3df00000 	.word	0x3df00000
10007638:	300039a0 	.word	0x300039a0
1000763c:	edda 7a02 	vldr	s15, [sl, #8]
10007640:	f8da 3004 	ldr.w	r3, [sl, #4]
10007644:	eeb8 4b67 	vcvt.f64.u32	d4, s15
10007648:	0fdb      	lsrs	r3, r3, #31
1000764a:	ee03 3a10 	vmov	s6, r3
1000764e:	ee3e 4b44 	vsub.f64	d4, d14, d4
10007652:	eeb8 3bc3 	vcvt.f64.s32	d3, s6
10007656:	edda 7a03 	vldr	s15, [sl, #12]
1000765a:	ed8d 3b4e 	vstr	d3, [sp, #312]	@ 0x138
1000765e:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10007662:	ee24 3b0f 	vmul.f64	d3, d4, d15
10007666:	ee3e 7b47 	vsub.f64	d7, d14, d7
1000766a:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000766e:	edda 6a00 	vldr	s13, [sl]
10007672:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10007676:	ee37 7b4d 	vsub.f64	d7, d7, d13
1000767a:	eeb8 5b66 	vcvt.f64.u32	d5, s13
1000767e:	ee37 7b03 	vadd.f64	d7, d7, d3
10007682:	edda 6a01 	vldr	s13, [sl, #4]
10007686:	ee03 4b4e 	vmls.f64	d4, d3, d14
1000768a:	eeb8 6b66 	vcvt.f64.u32	d6, s13
1000768e:	ee27 3b0f 	vmul.f64	d3, d7, d15
10007692:	ee26 2b0f 	vmul.f64	d2, d6, d15
10007696:	ee25 1b0f 	vmul.f64	d1, d5, d15
1000769a:	ed8d 5b48 	vstr	d5, [sp, #288]	@ 0x120
1000769e:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100076a2:	ee34 5b05 	vadd.f64	d5, d4, d5
100076a6:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100076aa:	ed8d 2b4a 	vstr	d2, [sp, #296]	@ 0x128
100076ae:	ed8d 4b52 	vstr	d4, [sp, #328]	@ 0x148
100076b2:	ee24 2b0f 	vmul.f64	d2, d4, d15
100076b6:	ee25 4b0f 	vmul.f64	d4, d5, d15
100076ba:	ee03 7b4e 	vmls.f64	d7, d3, d14
100076be:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100076c2:	eefc 3bc7 	vcvt.u32.f64	s7, d7
100076c6:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100076ca:	ed8d 6b46 	vstr	d6, [sp, #280]	@ 0x118
100076ce:	ee37 6b06 	vadd.f64	d6, d7, d6
100076d2:	ee13 1a90 	vmov	r1, s7
100076d6:	ed8d 7b50 	vstr	d7, [sp, #320]	@ 0x140
100076da:	ee27 3b0f 	vmul.f64	d3, d7, d15
100076de:	ee36 7b04 	vadd.f64	d7, d6, d4
100076e2:	ee27 6b0f 	vmul.f64	d6, d7, d15
100076e6:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100076ea:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100076ee:	ee06 7b4e 	vmls.f64	d7, d6, d14
100076f2:	eefc 6bc7 	vcvt.u32.f64	s13, d7
100076f6:	0fc9      	lsrs	r1, r1, #31
100076f8:	ee04 5b4e 	vmls.f64	d5, d4, d14
100076fc:	ee04 1a10 	vmov	s8, r1
10007700:	ee16 1a90 	vmov	r1, s13
10007704:	0fc9      	lsrs	r1, r1, #31
10007706:	ee27 6b0f 	vmul.f64	d6, d7, d15
1000770a:	ed8d 7b5a 	vstr	d7, [sp, #360]	@ 0x168
1000770e:	ee07 1a10 	vmov	s14, r1
10007712:	ed8d 2b56 	vstr	d2, [sp, #344]	@ 0x158
10007716:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
1000771a:	ee25 2b0f 	vmul.f64	d2, d5, d15
1000771e:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10007722:	9b08      	ldr	r3, [sp, #32]
10007724:	ed8d 1b4c 	vstr	d1, [sp, #304]	@ 0x130
10007728:	445b      	add	r3, fp
1000772a:	459b      	cmp	fp, r3
1000772c:	ed8d 3b54 	vstr	d3, [sp, #336]	@ 0x150
10007730:	ed8d 5b5c 	vstr	d5, [sp, #368]	@ 0x170
10007734:	ed8d 4b58 	vstr	d4, [sp, #352]	@ 0x160
10007738:	ed8d 2b60 	vstr	d2, [sp, #384]	@ 0x180
1000773c:	ed8d 6b5e 	vstr	d6, [sp, #376]	@ 0x178
10007740:	ed8d 7b62 	vstr	d7, [sp, #392]	@ 0x188
10007744:	f080 8187 	bcs.w	10007a56 <fndsa_vect_iFFT_fp64_exact+0x161e>
10007748:	463e      	mov	r6, r7
1000774a:	4611      	mov	r1, r2
1000774c:	eb09 0502 	add.w	r5, r9, r2
10007750:	eb09 0407 	add.w	r4, r9, r7
10007754:	9202      	str	r2, [sp, #8]
10007756:	ed91 ab02 	vldr	d10, [r1, #8]
1000775a:	ed96 7b02 	vldr	d7, [r6, #8]
1000775e:	ee3a 0b0e 	vadd.f64	d0, d10, d14
10007762:	ed91 cb00 	vldr	d12, [r1]
10007766:	ee37 ab0a 	vadd.f64	d10, d7, d10
1000776a:	ee30 7b47 	vsub.f64	d7, d0, d7
1000776e:	ed96 3b00 	vldr	d3, [r6]
10007772:	ee3c 1b0e 	vadd.f64	d1, d12, d14
10007776:	ee27 2b0f 	vmul.f64	d2, d7, d15
1000777a:	ee33 cb0c 	vadd.f64	d12, d3, d12
1000777e:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10007782:	ee31 3b43 	vsub.f64	d3, d1, d3
10007786:	eeb8 2b42 	vcvt.f64.u32	d2, s4
1000778a:	ee33 3b4d 	vsub.f64	d3, d3, d13
1000778e:	ee33 3b02 	vadd.f64	d3, d3, d2
10007792:	ee02 7b4e 	vmls.f64	d7, d2, d14
10007796:	ee23 1b0f 	vmul.f64	d1, d3, d15
1000779a:	ee37 7b0d 	vadd.f64	d7, d7, d13
1000779e:	eebc 1bc1 	vcvt.u32.f64	s2, d1
100077a2:	ed95 bb02 	vldr	d11, [r5, #8]
100077a6:	ee27 2b0f 	vmul.f64	d2, d7, d15
100077aa:	eeb8 1b41 	vcvt.f64.u32	d1, s2
100077ae:	ed94 5b02 	vldr	d5, [r4, #8]
100077b2:	eefc 0bc2 	vcvt.u32.f64	s1, d2
100077b6:	ee01 3b4e 	vmls.f64	d3, d1, d14
100077ba:	ee3b 2b0e 	vadd.f64	d2, d11, d14
100077be:	ed9f 4bb4 	vldr	d4, [pc, #720]	@ 10007a90 <fndsa_vect_iFFT_fp64_exact+0x1658>
100077c2:	ee3b bb05 	vadd.f64	d11, d11, d5
100077c6:	ee32 2b45 	vsub.f64	d2, d2, d5
100077ca:	ee33 3b04 	vadd.f64	d3, d3, d4
100077ce:	eeb8 5b60 	vcvt.f64.u32	d5, s1
100077d2:	ed94 8b00 	vldr	d8, [r4]
100077d6:	ed95 6b00 	vldr	d6, [r5]
100077da:	ee33 3b05 	vadd.f64	d3, d3, d5
100077de:	ee36 4b0e 	vadd.f64	d4, d6, d14
100077e2:	ee23 0b0f 	vmul.f64	d0, d3, d15
100077e6:	ee36 6b08 	vadd.f64	d6, d6, d8
100077ea:	ee05 7b4e 	vmls.f64	d7, d5, d14
100077ee:	ee22 5b0f 	vmul.f64	d5, d2, d15
100077f2:	ed8d 6b00 	vstr	d6, [sp]
100077f6:	eebc 0bc0 	vcvt.u32.f64	s0, d0
100077fa:	eeb6 6b00 	vmov.f64	d6, #96	@ 0x3f000000  0.5
100077fe:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10007802:	ee27 7b06 	vmul.f64	d7, d7, d6
10007806:	eeb8 0b40 	vcvt.f64.u32	d0, s0
1000780a:	ee34 6b48 	vsub.f64	d6, d4, d8
1000780e:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10007812:	ee00 3b4e 	vmls.f64	d3, d0, d14
10007816:	ee36 6b4d 	vsub.f64	d6, d6, d13
1000781a:	ee05 2b4e 	vmls.f64	d2, d5, d14
1000781e:	ee36 6b05 	vadd.f64	d6, d6, d5
10007822:	eefc 5bc3 	vcvt.u32.f64	s11, d3
10007826:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000782a:	ee32 2b0d 	vadd.f64	d2, d2, d13
1000782e:	ee15 3a90 	vmov	r3, s11
10007832:	eeb8 1b47 	vcvt.f64.u32	d1, s14
10007836:	ee22 7b0f 	vmul.f64	d7, d2, d15
1000783a:	0fda      	lsrs	r2, r3, #31
1000783c:	eefc 3bc7 	vcvt.u32.f64	s7, d7
10007840:	ee07 2a10 	vmov	s14, r2
10007844:	085a      	lsrs	r2, r3, #1
10007846:	ee00 2a10 	vmov	s0, r2
1000784a:	ee26 4b0f 	vmul.f64	d4, d6, d15
1000784e:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10007852:	eeb8 0bc0 	vcvt.f64.s32	d0, s0
10007856:	f003 0301 	and.w	r3, r3, #1
1000785a:	ee07 0b09 	vmla.f64	d0, d7, d9
1000785e:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10007862:	ee07 3a90 	vmov	s15, r3
10007866:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000786a:	eeb8 7be7 	vcvt.f64.s32	d7, s15
1000786e:	ee04 6b4e 	vmls.f64	d6, d4, d14
10007872:	ee07 1b09 	vmla.f64	d1, d7, d9
10007876:	ed9f 7b86 	vldr	d7, [pc, #536]	@ 10007a90 <fndsa_vect_iFFT_fp64_exact+0x1658>
1000787a:	eeb8 4b63 	vcvt.f64.u32	d4, s7
1000787e:	ee36 6b07 	vadd.f64	d6, d6, d7
10007882:	ee36 7b04 	vadd.f64	d7, d6, d4
10007886:	ee2a 5b0f 	vmul.f64	d5, d10, d15
1000788a:	ee04 2b4e 	vmls.f64	d2, d4, d14
1000788e:	ee27 4b0f 	vmul.f64	d4, d7, d15
10007892:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10007896:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000789a:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000789e:	eeb6 6b00 	vmov.f64	d6, #96	@ 0x3f000000  0.5
100078a2:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100078a6:	ee22 2b06 	vmul.f64	d2, d2, d6
100078aa:	ee3c 6b05 	vadd.f64	d6, d12, d5
100078ae:	ee04 7b4e 	vmls.f64	d7, d4, d14
100078b2:	ee26 8b0f 	vmul.f64	d8, d6, d15
100078b6:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100078ba:	ee05 ab4e 	vmls.f64	d10, d5, d14
100078be:	eefc 7bc7 	vcvt.u32.f64	s15, d7
100078c2:	ee3a 5b0d 	vadd.f64	d5, d10, d13
100078c6:	eeb8 3b42 	vcvt.f64.u32	d3, s4
100078ca:	eebc 2bc8 	vcvt.u32.f64	s4, d8
100078ce:	ee17 3a90 	vmov	r3, s15
100078d2:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100078d6:	ee25 4b0f 	vmul.f64	d4, d5, d15
100078da:	0fda      	lsrs	r2, r3, #31
100078dc:	ee08 2a10 	vmov	s16, r2
100078e0:	085a      	lsrs	r2, r3, #1
100078e2:	ee02 6b4e 	vmls.f64	d6, d2, d14
100078e6:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100078ea:	ee02 2a10 	vmov	s4, r2
100078ee:	ed9f 7b68 	vldr	d7, [pc, #416]	@ 10007a90 <fndsa_vect_iFFT_fp64_exact+0x1658>
100078f2:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100078f6:	eeb8 8bc8 	vcvt.f64.s32	d8, s16
100078fa:	eeb8 2bc2 	vcvt.f64.s32	d2, s4
100078fe:	ee36 6b07 	vadd.f64	d6, d6, d7
10007902:	ee08 2b09 	vmla.f64	d2, d8, d9
10007906:	eeb6 ab00 	vmov.f64	d10, #96	@ 0x3f000000  0.5
1000790a:	ee2b 8b0f 	vmul.f64	d8, d11, d15
1000790e:	ee04 5b4e 	vmls.f64	d5, d4, d14
10007912:	ee36 6b04 	vadd.f64	d6, d6, d4
10007916:	f003 0301 	and.w	r3, r3, #1
1000791a:	ee25 5b0a 	vmul.f64	d5, d5, d10
1000791e:	ee07 3a90 	vmov	s15, r3
10007922:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10007926:	ee26 4b0f 	vmul.f64	d4, d6, d15
1000792a:	eeb8 8b48 	vcvt.f64.u32	d8, s16
1000792e:	eebc abc5 	vcvt.u32.f64	s20, d5
10007932:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10007936:	ed9d 5b00 	vldr	d5, [sp]
1000793a:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000793e:	ee07 3b09 	vmla.f64	d3, d7, d9
10007942:	ee35 7b08 	vadd.f64	d7, d5, d8
10007946:	eeb0 5b4b 	vmov.f64	d5, d11
1000794a:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000794e:	ee08 5b4e 	vmls.f64	d5, d8, d14
10007952:	ee27 cb0f 	vmul.f64	d12, d7, d15
10007956:	ee04 6b4e 	vmls.f64	d6, d4, d14
1000795a:	ee35 5b0d 	vadd.f64	d5, d5, d13
1000795e:	eebc cbcc 	vcvt.u32.f64	s24, d12
10007962:	eefc 6bc6 	vcvt.u32.f64	s13, d6
10007966:	ee25 4b0f 	vmul.f64	d4, d5, d15
1000796a:	eeb8 cb4c 	vcvt.f64.u32	d12, s24
1000796e:	ee16 3a90 	vmov	r3, s13
10007972:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10007976:	ed9f 6b46 	vldr	d6, [pc, #280]	@ 10007a90 <fndsa_vect_iFFT_fp64_exact+0x1658>
1000797a:	ee0c 7b4e 	vmls.f64	d7, d12, d14
1000797e:	0fda      	lsrs	r2, r3, #31
10007980:	eeb8 bb4a 	vcvt.f64.u32	d11, s20
10007984:	ee0a 2a10 	vmov	s20, r2
10007988:	085a      	lsrs	r2, r3, #1
1000798a:	f003 0301 	and.w	r3, r3, #1
1000798e:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10007992:	ee37 7b06 	vadd.f64	d7, d7, d6
10007996:	ee06 3a90 	vmov	s13, r3
1000799a:	ee37 7b04 	vadd.f64	d7, d7, d4
1000799e:	eeb8 6be6 	vcvt.f64.s32	d6, s13
100079a2:	ee06 bb09 	vmla.f64	d11, d6, d9
100079a6:	ee27 6b0f 	vmul.f64	d6, d7, d15
100079aa:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100079ae:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100079b2:	ee08 2a10 	vmov	s16, r2
100079b6:	ee06 7b4e 	vmls.f64	d7, d6, d14
100079ba:	eeb8 abca 	vcvt.f64.s32	d10, s20
100079be:	eeb8 8bc8 	vcvt.f64.s32	d8, s16
100079c2:	eefc 7bc7 	vcvt.u32.f64	s15, d7
100079c6:	ee04 5b4e 	vmls.f64	d5, d4, d14
100079ca:	ee0a 8b09 	vmla.f64	d8, d10, d9
100079ce:	eeb6 ab00 	vmov.f64	d10, #96	@ 0x3f000000  0.5
100079d2:	ee17 3a90 	vmov	r3, s15
100079d6:	ee25 5b0a 	vmul.f64	d5, d5, d10
100079da:	0fda      	lsrs	r2, r3, #31
100079dc:	ee04 2a10 	vmov	s8, r2
100079e0:	085a      	lsrs	r2, r3, #1
100079e2:	f003 0301 	and.w	r3, r3, #1
100079e6:	ee06 2a10 	vmov	s12, r2
100079ea:	ee07 3a90 	vmov	s15, r3
100079ee:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100079f2:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
100079f6:	eeb8 7be7 	vcvt.f64.s32	d7, s15
100079fa:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100079fe:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10007a02:	ee07 5b09 	vmla.f64	d5, d7, d9
10007a06:	ee04 6b09 	vmla.f64	d6, d4, d9
10007a0a:	ed81 8b00 	vstr	d8, [r1]
10007a0e:	ed81 bb02 	vstr	d11, [r1, #8]
10007a12:	a846      	add	r0, sp, #280	@ 0x118
10007a14:	ed85 6b00 	vstr	d6, [r5]
10007a18:	ed85 5b02 	vstr	d5, [r5, #8]
10007a1c:	f7fd f908 	bl	10004c30 <fp64e_cmul_prepared>
10007a20:	3110      	adds	r1, #16
10007a22:	428f      	cmp	r7, r1
10007a24:	ed86 0b00 	vstr	d0, [r6]
10007a28:	ed86 1b02 	vstr	d1, [r6, #8]
10007a2c:	ed8d 0b3e 	vstr	d0, [sp, #248]	@ 0xf8
10007a30:	ed84 2b00 	vstr	d2, [r4]
10007a34:	ed84 3b02 	vstr	d3, [r4, #8]
10007a38:	ed8d 1b40 	vstr	d1, [sp, #256]	@ 0x100
10007a3c:	ed8d 2b42 	vstr	d2, [sp, #264]	@ 0x108
10007a40:	ed8d 3b44 	vstr	d3, [sp, #272]	@ 0x110
10007a44:	f105 0510 	add.w	r5, r5, #16
10007a48:	f106 0610 	add.w	r6, r6, #16
10007a4c:	f104 0410 	add.w	r4, r4, #16
10007a50:	f47f ae81 	bne.w	10007756 <fndsa_vect_iFFT_fp64_exact+0x131e>
10007a54:	9a02      	ldr	r2, [sp, #8]
10007a56:	9b04      	ldr	r3, [sp, #16]
10007a58:	f10a 0a10 	add.w	sl, sl, #16
10007a5c:	449b      	add	fp, r3
10007a5e:	9b06      	ldr	r3, [sp, #24]
10007a60:	4442      	add	r2, r8
10007a62:	4553      	cmp	r3, sl
10007a64:	4447      	add	r7, r8
10007a66:	f47f ade9 	bne.w	1000763c <fndsa_vect_iFFT_fp64_exact+0x1204>
10007a6a:	990a      	ldr	r1, [sp, #40]	@ 0x28
10007a6c:	46cc      	mov	ip, r9
10007a6e:	3901      	subs	r1, #1
10007a70:	f8dd e010 	ldr.w	lr, [sp, #16]
10007a74:	9e0c      	ldr	r6, [sp, #48]	@ 0x30
10007a76:	9d0e      	ldr	r5, [sp, #56]	@ 0x38
10007a78:	f47f adaf 	bne.w	100075da <fndsa_vect_iFFT_fp64_exact+0x11a2>
10007a7c:	b065      	add	sp, #404	@ 0x194
10007a7e:	ecbd 8b10 	vpop	{d8-d15}
10007a82:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10007a86:	4651      	mov	r1, sl
10007a88:	f04f 0e01 	mov.w	lr, #1
10007a8c:	e598      	b.n	100075c0 <fndsa_vect_iFFT_fp64_exact+0x1188>
10007a8e:	bf00      	nop
	...

