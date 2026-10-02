100053f8 <fndsa_vect_mul_fft_fp64_exact>:
100053f8:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
100053fc:	2310      	movs	r3, #16
100053fe:	ed2d 8b10 	vpush	{d8-d15}
10005402:	3801      	subs	r0, #1
10005404:	4083      	lsls	r3, r0
10005406:	f1a3 0e10 	sub.w	lr, r3, #16
1000540a:	ea4f 1e1e 	mov.w	lr, lr, lsr #4
1000540e:	b0bb      	sub	sp, #236	@ 0xec
10005410:	eb01 0b03 	add.w	fp, r1, r3
10005414:	f10e 0e01 	add.w	lr, lr, #1
10005418:	18d3      	adds	r3, r2, r3
1000541a:	e9cd 3b1f 	strd	r3, fp, [sp, #124]	@ 0x7c
1000541e:	2700      	movs	r7, #0
10005420:	ed9f fb09 	vldr	d15, [pc, #36]	@ 10005448 <fndsa_vect_mul_fft_fp64_exact+0x50>
10005424:	ed9f cb0a 	vldr	d12, [pc, #40]	@ 10005450 <fndsa_vect_mul_fft_fp64_exact+0x58>
10005428:	eeb7 bb00 	vmov.f64	d11, #112	@ 0x3f800000  1.0
1000542c:	f04e e001 	dls	lr, lr
10005430:	4693      	mov	fp, r2
10005432:	f10d 0aa8 	add.w	sl, sp, #168	@ 0xa8
10005436:	f10d 09b8 	add.w	r9, sp, #184	@ 0xb8
1000543a:	f10d 08c8 	add.w	r8, sp, #200	@ 0xc8
1000543e:	9121      	str	r1, [sp, #132]	@ 0x84
10005440:	e00a      	b.n	10005458 <fndsa_vect_mul_fft_fp64_exact+0x60>
10005442:	bf00      	nop
10005444:	f3af 8000 	nop.w
10005448:	00000000 	.word	0x00000000
1000544c:	3df00000 	.word	0x3df00000
10005450:	00000000 	.word	0x00000000
10005454:	41f00000 	.word	0x41f00000
10005458:	9b21      	ldr	r3, [sp, #132]	@ 0x84
1000545a:	eb0b 0c07 	add.w	ip, fp, r7
1000545e:	19dd      	adds	r5, r3, r7
10005460:	9b20      	ldr	r3, [sp, #128]	@ 0x80
10005462:	19dc      	adds	r4, r3, r7
10005464:	9b1f      	ldr	r3, [sp, #124]	@ 0x7c
10005466:	19de      	adds	r6, r3, r7
10005468:	e895 000f 	ldmia.w	r5, {r0, r1, r2, r3}
1000546c:	e88a 000f 	stmia.w	sl, {r0, r1, r2, r3}
10005470:	e894 000f 	ldmia.w	r4, {r0, r1, r2, r3}
10005474:	e889 000f 	stmia.w	r9, {r0, r1, r2, r3}
10005478:	e89c 000f 	ldmia.w	ip, {r0, r1, r2, r3}
1000547c:	e888 000f 	stmia.w	r8, {r0, r1, r2, r3}
10005480:	e896 000f 	ldmia.w	r6, {r0, r1, r2, r3}
10005484:	ae36      	add	r6, sp, #216	@ 0xd8
10005486:	e886 000f 	stmia.w	r6, {r0, r1, r2, r3}
1000548a:	ed9d eb2a 	vldr	d14, [sp, #168]	@ 0xa8
1000548e:	ed9d 7b34 	vldr	d7, [sp, #208]	@ 0xd0
10005492:	ed9d 8b32 	vldr	d8, [sp, #200]	@ 0xc8
10005496:	ee27 9b0f 	vmul.f64	d9, d7, d15
1000549a:	eefc 7bce 	vcvt.u32.f64	s15, d14
1000549e:	ed9d 1b2e 	vldr	d1, [sp, #184]	@ 0xb8
100054a2:	ee17 0a90 	vmov	r0, s15
100054a6:	eefc 7bc8 	vcvt.u32.f64	s15, d8
100054aa:	ed9d ab36 	vldr	d10, [sp, #216]	@ 0xd8
100054ae:	ee17 2a90 	vmov	r2, s15
100054b2:	eefc 7bc1 	vcvt.u32.f64	s15, d1
100054b6:	ee17 1a90 	vmov	r1, s15
100054ba:	eefc 7bca 	vcvt.u32.f64	s15, d10
100054be:	ee17 3a90 	vmov	r3, s15
100054c2:	ed9d 7b2c 	vldr	d7, [sp, #176]	@ 0xb0
100054c6:	0fc0      	lsrs	r0, r0, #31
100054c8:	ee27 4b09 	vmul.f64	d4, d7, d9
100054cc:	ee07 0a90 	vmov	s15, r0
100054d0:	eeb8 7be7 	vcvt.f64.s32	d7, s15
100054d4:	0fc9      	lsrs	r1, r1, #31
100054d6:	ed8d 7b12 	vstr	d7, [sp, #72]	@ 0x48
100054da:	ee07 1a90 	vmov	s15, r1
100054de:	0fd2      	lsrs	r2, r2, #31
100054e0:	eeb8 3be7 	vcvt.f64.s32	d3, s15
100054e4:	ee07 2a90 	vmov	s15, r2
100054e8:	0fdb      	lsrs	r3, r3, #31
100054ea:	eeb8 2be7 	vcvt.f64.s32	d2, s15
100054ee:	ee07 3a90 	vmov	s15, r3
100054f2:	ee2e 9b09 	vmul.f64	d9, d14, d9
100054f6:	eeb8 0be7 	vcvt.f64.s32	d0, s15
100054fa:	ed8d 3b16 	vstr	d3, [sp, #88]	@ 0x58
100054fe:	ed9d 7b34 	vldr	d7, [sp, #208]	@ 0xd0
10005502:	ed9d 3b38 	vldr	d3, [sp, #224]	@ 0xe0
10005506:	ed8d 0b18 	vstr	d0, [sp, #96]	@ 0x60
1000550a:	eebc 9bc9 	vcvt.u32.f64	s18, d9
1000550e:	ee37 0b03 	vadd.f64	d0, d7, d3
10005512:	ed9d 7b2c 	vldr	d7, [sp, #176]	@ 0xb0
10005516:	ed9d 3b30 	vldr	d3, [sp, #192]	@ 0xc0
1000551a:	ee28 6b0f 	vmul.f64	d6, d8, d15
1000551e:	ee37 db03 	vadd.f64	d13, d7, d3
10005522:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10005526:	ed9d 3b2c 	vldr	d3, [sp, #176]	@ 0xb0
1000552a:	ed8d 9b08 	vstr	d9, [sp, #32]
1000552e:	ee23 3b06 	vmul.f64	d3, d3, d6
10005532:	ee20 9b0f 	vmul.f64	d9, d0, d15
10005536:	eefc 3bc3 	vcvt.u32.f64	s7, d3
1000553a:	eebc 3bc9 	vcvt.u32.f64	s6, d9
1000553e:	ed9d 7b38 	vldr	d7, [sp, #224]	@ 0xe0
10005542:	ee2e 6b06 	vmul.f64	d6, d14, d6
10005546:	eeb8 9b63 	vcvt.f64.u32	d9, s7
1000554a:	ed8d 2b14 	vstr	d2, [sp, #80]	@ 0x50
1000554e:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10005552:	ee38 2b0a 	vadd.f64	d2, d8, d10
10005556:	ee27 5b0f 	vmul.f64	d5, d7, d15
1000555a:	ee32 2b03 	vadd.f64	d2, d2, d3
1000555e:	ee03 0b4c 	vmls.f64	d0, d3, d12
10005562:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10005566:	ed9d 3b30 	vldr	d3, [sp, #192]	@ 0xc0
1000556a:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000556e:	ee23 3b05 	vmul.f64	d3, d3, d5
10005572:	ee25 5b01 	vmul.f64	d5, d5, d1
10005576:	ee26 6b4c 	vnmul.f64	d6, d6, d12
1000557a:	eeae 6b08 	vfma.f64	d6, d14, d8
1000557e:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10005582:	ee36 6b0c 	vadd.f64	d6, d6, d12
10005586:	ee2a 7b0f 	vmul.f64	d7, d10, d15
1000558a:	ed8d 9b00 	vstr	d9, [sp]
1000558e:	ed8d 6b0e 	vstr	d6, [sp, #56]	@ 0x38
10005592:	eeb0 9b40 	vmov.f64	d9, d0
10005596:	ee2d 6b0f 	vmul.f64	d6, d13, d15
1000559a:	ed9d 0b30 	vldr	d0, [sp, #192]	@ 0xc0
1000559e:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100055a2:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100055a6:	ed8d 5b0c 	vstr	d5, [sp, #48]	@ 0x30
100055aa:	ee20 5b07 	vmul.f64	d5, d0, d7
100055ae:	ee27 7b01 	vmul.f64	d7, d7, d1
100055b2:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100055b6:	ee3e 0b01 	vadd.f64	d0, d14, d1
100055ba:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100055be:	ee30 0b06 	vadd.f64	d0, d0, d6
100055c2:	ee06 db4c 	vmls.f64	d13, d6, d12
100055c6:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100055ca:	ee22 6b0f 	vmul.f64	d6, d2, d15
100055ce:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100055d2:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100055d6:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100055da:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100055de:	ee27 7b4c 	vnmul.f64	d7, d7, d12
100055e2:	eea1 7b0a 	vfma.f64	d7, d1, d10
100055e6:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100055ea:	ee37 7b0c 	vadd.f64	d7, d7, d12
100055ee:	ed8d db02 	vstr	d13, [sp, #8]
100055f2:	ed8d 5b0a 	vstr	d5, [sp, #40]	@ 0x28
100055f6:	ed9d db2c 	vldr	d13, [sp, #176]	@ 0xb0
100055fa:	ed9d 5b34 	vldr	d5, [sp, #208]	@ 0xd0
100055fe:	ed8d 7b10 	vstr	d7, [sp, #64]	@ 0x40
10005602:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005606:	ee24 7b4c 	vnmul.f64	d7, d4, d12
1000560a:	eead 7b05 	vfma.f64	d7, d13, d5
1000560e:	ee37 7b0c 	vadd.f64	d7, d7, d12
10005612:	ee06 2b4c 	vmls.f64	d2, d6, d12
10005616:	ee27 7b0f 	vmul.f64	d7, d7, d15
1000561a:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000561e:	eefc 7bc2 	vcvt.u32.f64	s15, d2
10005622:	ee17 3a90 	vmov	r3, s15
10005626:	0fdb      	lsrs	r3, r3, #31
10005628:	ee07 3a90 	vmov	s15, r3
1000562c:	eeb8 5b47 	vcvt.f64.u32	d5, s14
10005630:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10005634:	ee35 5b04 	vadd.f64	d5, d5, d4
10005638:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000563c:	eeb8 4be7 	vcvt.f64.s32	d4, s15
10005640:	ed8d 2b04 	vstr	d2, [sp, #16]
10005644:	ee23 7b4c 	vnmul.f64	d7, d3, d12
10005648:	ed9d 2b30 	vldr	d2, [sp, #192]	@ 0xc0
1000564c:	ed8d 4b1c 	vstr	d4, [sp, #112]	@ 0x70
10005650:	ed9d 4b38 	vldr	d4, [sp, #224]	@ 0xe0
10005654:	eea2 7b04 	vfma.f64	d7, d2, d4
10005658:	ee20 4b0f 	vmul.f64	d4, d0, d15
1000565c:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10005660:	ee37 6b0c 	vadd.f64	d6, d7, d12
10005664:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10005668:	eeb0 7b40 	vmov.f64	d7, d0
1000566c:	ee04 7b4c 	vmls.f64	d7, d4, d12
10005670:	ed9d db00 	vldr	d13, [sp]
10005674:	ed8d 7b00 	vstr	d7, [sp]
10005678:	eefc 7bc7 	vcvt.u32.f64	s15, d7
1000567c:	ee26 6b0f 	vmul.f64	d6, d6, d15
10005680:	ee17 3a90 	vmov	r3, s15
10005684:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10005688:	0fdb      	lsrs	r3, r3, #31
1000568a:	ee07 3a90 	vmov	s15, r3
1000568e:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005692:	ed8d 9b06 	vstr	d9, [sp, #24]
10005696:	ee29 2b0f 	vmul.f64	d2, d9, d15
1000569a:	ed9d 4b2c 	vldr	d4, [sp, #176]	@ 0xb0
1000569e:	ed9d 0b08 	vldr	d0, [sp, #32]
100056a2:	ee36 6b03 	vadd.f64	d6, d6, d3
100056a6:	ee2d 9b4c 	vnmul.f64	d9, d13, d12
100056aa:	eea4 9b08 	vfma.f64	d9, d4, d8
100056ae:	ed9d 3b0a 	vldr	d3, [sp, #40]	@ 0x28
100056b2:	eeb8 8be7 	vcvt.f64.s32	d8, s15
100056b6:	ed9d 4b30 	vldr	d4, [sp, #192]	@ 0xc0
100056ba:	ed8d 8b1a 	vstr	d8, [sp, #104]	@ 0x68
100056be:	ee20 7b4c 	vnmul.f64	d7, d0, d12
100056c2:	ee23 8b4c 	vnmul.f64	d8, d3, d12
100056c6:	eea4 8b0a 	vfma.f64	d8, d4, d10
100056ca:	ed9d 4b04 	vldr	d4, [sp, #16]
100056ce:	ed9d ab34 	vldr	d10, [sp, #208]	@ 0xd0
100056d2:	eeae 7b0a 	vfma.f64	d7, d14, d10
100056d6:	ed9d eb0c 	vldr	d14, [sp, #48]	@ 0x30
100056da:	ee24 3b0f 	vmul.f64	d3, d4, d15
100056de:	ed9d ab38 	vldr	d10, [sp, #224]	@ 0xe0
100056e2:	ee2e 4b4c 	vnmul.f64	d4, d14, d12
100056e6:	eea1 4b0a 	vfma.f64	d4, d1, d10
100056ea:	ed9d ab00 	vldr	d10, [sp]
100056ee:	ed9d 1b02 	vldr	d1, [sp, #8]
100056f2:	ee21 0b02 	vmul.f64	d0, d1, d2
100056f6:	ee2a 2b02 	vmul.f64	d2, d10, d2
100056fa:	ee39 9b0c 	vadd.f64	d9, d9, d12
100056fe:	ee38 8b0c 	vadd.f64	d8, d8, d12
10005702:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10005706:	ee29 1b0f 	vmul.f64	d1, d9, d15
1000570a:	eeb8 eb42 	vcvt.f64.u32	d14, s4
1000570e:	ee28 2b0f 	vmul.f64	d2, d8, d15
10005712:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10005716:	eebc 2bc2 	vcvt.u32.f64	s4, d2
1000571a:	eeb8 1b41 	vcvt.f64.u32	d1, s2
1000571e:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10005722:	ee01 9b4c 	vmls.f64	d9, d1, d12
10005726:	ee02 8b4c 	vmls.f64	d8, d2, d12
1000572a:	ee35 5b4b 	vsub.f64	d5, d5, d11
1000572e:	ee36 6b4b 	vsub.f64	d6, d6, d11
10005732:	ee35 5b09 	vadd.f64	d5, d5, d9
10005736:	ee36 6b08 	vadd.f64	d6, d6, d8
1000573a:	ed9d 9b0a 	vldr	d9, [sp, #40]	@ 0x28
1000573e:	ee37 7b0c 	vadd.f64	d7, d7, d12
10005742:	ed9d 8b02 	vldr	d8, [sp, #8]
10005746:	ee39 2b02 	vadd.f64	d2, d9, d2
1000574a:	ee28 8b03 	vmul.f64	d8, d8, d3
1000574e:	ee27 9b0f 	vmul.f64	d9, d7, d15
10005752:	eefc 8bc8 	vcvt.u32.f64	s17, d8
10005756:	eebc 8bc9 	vcvt.u32.f64	s16, d9
1000575a:	ee2a 3b03 	vmul.f64	d3, d10, d3
1000575e:	eeb8 9b68 	vcvt.f64.u32	d9, s17
10005762:	ee3d 1b01 	vadd.f64	d1, d13, d1
10005766:	eeb8 8b48 	vcvt.f64.u32	d8, s16
1000576a:	ed9d db08 	vldr	d13, [sp, #32]
1000576e:	ee08 7b4c 	vmls.f64	d7, d8, d12
10005772:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10005776:	ee3d 8b08 	vadd.f64	d8, d13, d8
1000577a:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000577e:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10005782:	ee34 4b0c 	vadd.f64	d4, d4, d12
10005786:	ee31 1b4b 	vsub.f64	d1, d1, d11
1000578a:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000578e:	ee38 8b4b 	vsub.f64	d8, d8, d11
10005792:	ee35 7b07 	vadd.f64	d7, d5, d7
10005796:	ee31 8b08 	vadd.f64	d8, d1, d8
1000579a:	ed9d 5b04 	vldr	d5, [sp, #16]
1000579e:	ed9d 1b06 	vldr	d1, [sp, #24]
100057a2:	ed9d db02 	vldr	d13, [sp, #8]
100057a6:	ee23 3b4c 	vnmul.f64	d3, d3, d12
100057aa:	eeaa 3b05 	vfma.f64	d3, d10, d5
100057ae:	ee20 5b4c 	vnmul.f64	d5, d0, d12
100057b2:	eead 5b01 	vfma.f64	d5, d13, d1
100057b6:	ee33 ab0c 	vadd.f64	d10, d3, d12
100057ba:	ee35 5b0c 	vadd.f64	d5, d5, d12
100057be:	ee24 3b0f 	vmul.f64	d3, d4, d15
100057c2:	ee25 5b0f 	vmul.f64	d5, d5, d15
100057c6:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100057ca:	ed9d db0c 	vldr	d13, [sp, #48]	@ 0x30
100057ce:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100057d2:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100057d6:	ee03 4b4c 	vmls.f64	d4, d3, d12
100057da:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100057de:	ee3d 3b03 	vadd.f64	d3, d13, d3
100057e2:	ee36 4b04 	vadd.f64	d4, d6, d4
100057e6:	ee33 3b4b 	vsub.f64	d3, d3, d11
100057ea:	ed9d 6b04 	vldr	d6, [sp, #16]
100057ee:	ee35 5b00 	vadd.f64	d5, d5, d0
100057f2:	ee29 1b4c 	vnmul.f64	d1, d9, d12
100057f6:	ed9d 0b02 	vldr	d0, [sp, #8]
100057fa:	eea0 1b06 	vfma.f64	d1, d0, d6
100057fe:	ee32 2b4b 	vsub.f64	d2, d2, d11
10005802:	ed9d 6b0e 	vldr	d6, [sp, #56]	@ 0x38
10005806:	ed9d db10 	vldr	d13, [sp, #64]	@ 0x40
1000580a:	ee32 2b03 	vadd.f64	d2, d2, d3
1000580e:	ee26 3b0f 	vmul.f64	d3, d6, d15
10005812:	ee2d 0b0f 	vmul.f64	d0, d13, d15
10005816:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000581a:	eebc 0bc0 	vcvt.u32.f64	s0, d0
1000581e:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10005822:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10005826:	ee03 6b4c 	vmls.f64	d6, d3, d12
1000582a:	eeb0 3b4d 	vmov.f64	d3, d13
1000582e:	ee31 1b0c 	vadd.f64	d1, d1, d12
10005832:	ee00 3b4c 	vmls.f64	d3, d0, d12
10005836:	ee36 6b08 	vadd.f64	d6, d6, d8
1000583a:	ed9d 0b00 	vldr	d0, [sp]
1000583e:	ed9d 8b06 	vldr	d8, [sp, #24]
10005842:	ee33 3b02 	vadd.f64	d3, d3, d2
10005846:	ee2e 2b4c 	vnmul.f64	d2, d14, d12
1000584a:	eea0 2b08 	vfma.f64	d2, d0, d8
1000584e:	ee21 0b0f 	vmul.f64	d0, d1, d15
10005852:	ee27 8b0f 	vmul.f64	d8, d7, d15
10005856:	eebc 0bc0 	vcvt.u32.f64	s0, d0
1000585a:	eebc 8bc8 	vcvt.u32.f64	s16, d8
1000585e:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10005862:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10005866:	ee35 5b4b 	vsub.f64	d5, d5, d11
1000586a:	ee00 1b4c 	vmls.f64	d1, d0, d12
1000586e:	ee36 6b08 	vadd.f64	d6, d6, d8
10005872:	ee39 0b00 	vadd.f64	d0, d9, d0
10005876:	ed9f 9b72 	vldr	d9, [pc, #456]	@ 10005a40 <fndsa_vect_mul_fft_fp64_exact+0x648>
1000587a:	ee35 1b01 	vadd.f64	d1, d5, d1
1000587e:	ed9d db34 	vldr	d13, [sp, #208]	@ 0xd0
10005882:	ed9d 5b12 	vldr	d5, [sp, #72]	@ 0x48
10005886:	ee36 6b09 	vadd.f64	d6, d6, d9
1000588a:	ee05 6b4d 	vmls.f64	d6, d5, d13
1000588e:	ed9d db14 	vldr	d13, [sp, #80]	@ 0x50
10005892:	ed9d 5b2c 	vldr	d5, [sp, #176]	@ 0xb0
10005896:	ee0d 6b45 	vmls.f64	d6, d13, d5
1000589a:	ee24 5b0f 	vmul.f64	d5, d4, d15
1000589e:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100058a2:	ee32 2b0c 	vadd.f64	d2, d2, d12
100058a6:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100058aa:	ee08 7b4c 	vmls.f64	d7, d8, d12
100058ae:	ee33 3b05 	vadd.f64	d3, d3, d5
100058b2:	ee22 8b0f 	vmul.f64	d8, d2, d15
100058b6:	ee05 4b4c 	vmls.f64	d4, d5, d12
100058ba:	eebc 8bc8 	vcvt.u32.f64	s16, d8
100058be:	ed9d 5b16 	vldr	d5, [sp, #88]	@ 0x58
100058c2:	ee33 3b09 	vadd.f64	d3, d3, d9
100058c6:	ed9d db38 	vldr	d13, [sp, #224]	@ 0xe0
100058ca:	eeb8 8b48 	vcvt.f64.u32	d8, s16
100058ce:	ee05 3b4d 	vmls.f64	d3, d5, d13
100058d2:	ed9d 5b18 	vldr	d5, [sp, #96]	@ 0x60
100058d6:	ed9d db30 	vldr	d13, [sp, #192]	@ 0xc0
100058da:	ee08 2b4c 	vmls.f64	d2, d8, d12
100058de:	ee05 3b4d 	vmls.f64	d3, d5, d13
100058e2:	ee2a 5b0f 	vmul.f64	d5, d10, d15
100058e6:	ee3e eb08 	vadd.f64	d14, d14, d8
100058ea:	ee31 2b02 	vadd.f64	d2, d1, d2
100058ee:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100058f2:	ee22 1b0f 	vmul.f64	d1, d2, d15
100058f6:	ee30 0b4b 	vsub.f64	d0, d0, d11
100058fa:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100058fe:	ee3e eb4b 	vsub.f64	d14, d14, d11
10005902:	ee05 ab4c 	vmls.f64	d10, d5, d12
10005906:	ee30 eb0e 	vadd.f64	d14, d0, d14
1000590a:	eebc 1bc1 	vcvt.u32.f64	s2, d1
1000590e:	ee3a ab0e 	vadd.f64	d10, d10, d14
10005912:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10005916:	ee3a ab01 	vadd.f64	d10, d10, d1
1000591a:	ed9d 5b1a 	vldr	d5, [sp, #104]	@ 0x68
1000591e:	ee3a ab09 	vadd.f64	d10, d10, d9
10005922:	ed9d 8b06 	vldr	d8, [sp, #24]
10005926:	ee05 ab48 	vmls.f64	d10, d5, d8
1000592a:	ee37 5b04 	vadd.f64	d5, d7, d4
1000592e:	ee37 7b0c 	vadd.f64	d7, d7, d12
10005932:	ee01 2b4c 	vmls.f64	d2, d1, d12
10005936:	ee37 7b44 	vsub.f64	d7, d7, d4
1000593a:	ed9d 1b1c 	vldr	d1, [sp, #112]	@ 0x70
1000593e:	ed9d 0b02 	vldr	d0, [sp, #8]
10005942:	ee01 ab40 	vmls.f64	d10, d1, d0
10005946:	ee27 1b0f 	vmul.f64	d1, d7, d15
1000594a:	eebc 1bc1 	vcvt.u32.f64	s2, d1
1000594e:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10005952:	ee01 7b4c 	vmls.f64	d7, d1, d12
10005956:	ed8d 7b24 	vstr	d7, [sp, #144]	@ 0x90
1000595a:	ee26 7b0f 	vmul.f64	d7, d6, d15
1000595e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005962:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005966:	ee07 6b4c 	vmls.f64	d6, d7, d12
1000596a:	ee23 7b0f 	vmul.f64	d7, d3, d15
1000596e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005972:	ee25 0b0f 	vmul.f64	d0, d5, d15
10005976:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000597a:	eebc 0bc0 	vcvt.u32.f64	s0, d0
1000597e:	ee07 3b4c 	vmls.f64	d3, d7, d12
10005982:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10005986:	ee36 7b0c 	vadd.f64	d7, d6, d12
1000598a:	ee36 6b03 	vadd.f64	d6, d6, d3
1000598e:	ee2a 4b0f 	vmul.f64	d4, d10, d15
10005992:	ee36 6b00 	vadd.f64	d6, d6, d0
10005996:	ee37 3b43 	vsub.f64	d3, d7, d3
1000599a:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000599e:	ee26 7b0f 	vmul.f64	d7, d6, d15
100059a2:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100059a6:	ee32 2b0c 	vadd.f64	d2, d2, d12
100059aa:	ee00 5b4c 	vmls.f64	d5, d0, d12
100059ae:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100059b2:	ee04 ab4c 	vmls.f64	d10, d4, d12
100059b6:	ee32 5b45 	vsub.f64	d5, d2, d5
100059ba:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100059be:	ee25 4b0f 	vmul.f64	d4, d5, d15
100059c2:	ee07 6b4c 	vmls.f64	d6, d7, d12
100059c6:	ee3a ab0c 	vadd.f64	d10, d10, d12
100059ca:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100059ce:	ee3a 7b46 	vsub.f64	d7, d10, d6
100059d2:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100059d6:	ee33 3b4b 	vsub.f64	d3, d3, d11
100059da:	ee37 7b4b 	vsub.f64	d7, d7, d11
100059de:	ee04 5b4c 	vmls.f64	d5, d4, d12
100059e2:	ee33 3b01 	vadd.f64	d3, d3, d1
100059e6:	ee37 7b04 	vadd.f64	d7, d7, d4
100059ea:	ed8d 5b28 	vstr	d5, [sp, #160]	@ 0xa0
100059ee:	ee27 6b0f 	vmul.f64	d6, d7, d15
100059f2:	ee23 5b0f 	vmul.f64	d5, d3, d15
100059f6:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100059fa:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100059fe:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005a02:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10005a06:	ee06 7b4c 	vmls.f64	d7, d6, d12
10005a0a:	ee05 3b4c 	vmls.f64	d3, d5, d12
10005a0e:	ed8d 7b26 	vstr	d7, [sp, #152]	@ 0x98
10005a12:	ed8d 3b22 	vstr	d3, [sp, #136]	@ 0x88
10005a16:	ab22      	add	r3, sp, #136	@ 0x88
10005a18:	cb0f      	ldmia	r3, {r0, r1, r2, r3}
10005a1a:	e885 000f 	stmia.w	r5, {r0, r1, r2, r3}
10005a1e:	ab26      	add	r3, sp, #152	@ 0x98
10005a20:	cb0f      	ldmia	r3, {r0, r1, r2, r3}
10005a22:	3710      	adds	r7, #16
10005a24:	e884 000f 	stmia.w	r4, {r0, r1, r2, r3}
10005a28:	f1be 0e01 	subs.w	lr, lr, #1
10005a2c:	f47f ad14 	bne.w	10005458 <fndsa_vect_mul_fft_fp64_exact+0x60>
10005a30:	b03b      	add	sp, #236	@ 0xec
10005a32:	ecbd 8b10 	vpop	{d8-d15}
10005a36:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10005a3a:	bf00      	nop
10005a3c:	f3af 8000 	nop.w
10005a40:	00000000 	.word	0x00000000
10005a44:	42000000 	.word	0x42000000

