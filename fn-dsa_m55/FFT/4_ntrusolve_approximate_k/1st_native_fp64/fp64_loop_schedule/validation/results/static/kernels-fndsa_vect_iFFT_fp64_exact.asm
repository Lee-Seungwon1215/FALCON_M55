100013a8 <fndsa_vect_iFFT_fp64_exact>:
100013a8:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
100013ac:	ed2d 8b10 	vpush	{d8-d15}
100013b0:	2802      	cmp	r0, #2
100013b2:	460d      	mov	r5, r1
100013b4:	b0e5      	sub	sp, #404	@ 0x194
100013b6:	f100 3aff 	add.w	sl, r0, #4294967295	@ 0xffffffff
100013ba:	f241 831c 	bls.w	100029f6 <fndsa_vect_iFFT_fp64_exact+0x164e>
100013be:	2301      	movs	r3, #1
100013c0:	2410      	movs	r4, #16
100013c2:	4683      	mov	fp, r0
100013c4:	ed9f fbf8 	vldr	d15, [pc, #992]	@ 100017a8 <fndsa_vect_iFFT_fp64_exact+0x400>
100013c8:	ed9f ebf9 	vldr	d14, [pc, #996]	@ 100017b0 <fndsa_vect_iFFT_fp64_exact+0x408>
100013cc:	fa03 f30a 	lsl.w	r3, r3, sl
100013d0:	4efb      	ldr	r6, [pc, #1004]	@ (100017c0 <fndsa_vect_iFFT_fp64_exact+0x418>)
100013d2:	1e5a      	subs	r2, r3, #1
100013d4:	fa04 f40a 	lsl.w	r4, r4, sl
100013d8:	f101 0840 	add.w	r8, r1, #64	@ 0x40
100013dc:	085b      	lsrs	r3, r3, #1
100013de:	0892      	lsrs	r2, r2, #2
100013e0:	eb06 1703 	add.w	r7, r6, r3, lsl #4
100013e4:	eb08 1882 	add.w	r8, r8, r2, lsl #6
100013e8:	4426      	add	r6, r4
100013ea:	440c      	add	r4, r1
100013ec:	edd6 7a02 	vldr	s15, [r6, #8]
100013f0:	eeb8 db67 	vcvt.f64.u32	d13, s15
100013f4:	edd6 7a03 	vldr	s15, [r6, #12]
100013f8:	6873      	ldr	r3, [r6, #4]
100013fa:	eeb8 2b67 	vcvt.f64.u32	d2, s15
100013fe:	0fdb      	lsrs	r3, r3, #31
10001400:	ee08 3a10 	vmov	s16, r3
10001404:	eeb7 0b00 	vmov.f64	d0, #112	@ 0x3f800000  1.0
10001408:	eeb8 8bc8 	vcvt.f64.s32	d8, s16
1000140c:	ee3e 2b42 	vsub.f64	d2, d14, d2
10001410:	ed91 9b0a 	vldr	d9, [r1, #40]	@ 0x28
10001414:	edd6 7a00 	vldr	s15, [r6]
10001418:	ed91 4b02 	vldr	d4, [r1, #8]
1000141c:	ed91 bb0e 	vldr	d11, [r1, #56]	@ 0x38
10001420:	ed94 ab0a 	vldr	d10, [r4, #40]	@ 0x28
10001424:	eeb8 6b67 	vcvt.f64.u32	d6, s15
10001428:	ee32 2b40 	vsub.f64	d2, d2, d0
1000142c:	edd6 7a01 	vldr	s15, [r6, #4]
10001430:	ed8d 8b4e 	vstr	d8, [sp, #312]	@ 0x138
10001434:	ed91 3b06 	vldr	d3, [r1, #24]
10001438:	ed94 5b02 	vldr	d5, [r4, #8]
1000143c:	ed94 cb0e 	vldr	d12, [r4, #56]	@ 0x38
10001440:	ee39 8b0e 	vadd.f64	d8, d9, d14
10001444:	ed8d 2b12 	vstr	d2, [sp, #72]	@ 0x48
10001448:	ee39 9b0b 	vadd.f64	d9, d9, d11
1000144c:	ee38 bb4b 	vsub.f64	d11, d8, d11
10001450:	ed91 8b00 	vldr	d8, [r1]
10001454:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10001458:	ee34 2b0e 	vadd.f64	d2, d4, d14
1000145c:	ee3a 0b0e 	vadd.f64	d0, d10, d14
10001460:	ee33 4b04 	vadd.f64	d4, d3, d4
10001464:	ed94 1b06 	vldr	d1, [r4, #24]
10001468:	ed8d 7b00 	vstr	d7, [sp]
1000146c:	ed8d 7b46 	vstr	d7, [sp, #280]	@ 0x118
10001470:	ed91 7b00 	vldr	d7, [r1]
10001474:	ee32 2b43 	vsub.f64	d2, d2, d3
10001478:	ee3a ab0c 	vadd.f64	d10, d10, d12
1000147c:	ee30 cb4c 	vsub.f64	d12, d0, d12
10001480:	ee35 3b0e 	vadd.f64	d3, d5, d14
10001484:	ee38 0b0e 	vadd.f64	d0, d8, d14
10001488:	ed91 8b04 	vldr	d8, [r1, #16]
1000148c:	ee35 5b01 	vadd.f64	d5, d5, d1
10001490:	ee33 3b41 	vsub.f64	d3, d3, d1
10001494:	ee38 8b07 	vadd.f64	d8, d8, d7
10001498:	ee22 1b0f 	vmul.f64	d1, d2, d15
1000149c:	ed8d 8b02 	vstr	d8, [sp, #8]
100014a0:	ed91 8b04 	vldr	d8, [r1, #16]
100014a4:	eeb7 7b00 	vmov.f64	d7, #112	@ 0x3f800000  1.0
100014a8:	eebc 1bc1 	vcvt.u32.f64	s2, d1
100014ac:	ee30 0b48 	vsub.f64	d0, d0, d8
100014b0:	ed94 8b00 	vldr	d8, [r4]
100014b4:	eeb8 1b41 	vcvt.f64.u32	d1, s2
100014b8:	ee30 0b47 	vsub.f64	d0, d0, d7
100014bc:	ee01 2b4e 	vmls.f64	d2, d1, d14
100014c0:	ee30 0b01 	vadd.f64	d0, d0, d1
100014c4:	ee32 1b07 	vadd.f64	d1, d2, d7
100014c8:	ed94 7b04 	vldr	d7, [r4, #16]
100014cc:	ee23 2b0f 	vmul.f64	d2, d3, d15
100014d0:	ed8d 1b0c 	vstr	d1, [sp, #48]	@ 0x30
100014d4:	ee38 1b0e 	vadd.f64	d1, d8, d14
100014d8:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100014dc:	ee38 8b07 	vadd.f64	d8, d8, d7
100014e0:	ee31 1b47 	vsub.f64	d1, d1, d7
100014e4:	eeb7 7b00 	vmov.f64	d7, #112	@ 0x3f800000  1.0
100014e8:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100014ec:	ee31 1b47 	vsub.f64	d1, d1, d7
100014f0:	ee02 3b4e 	vmls.f64	d3, d2, d14
100014f4:	ee31 1b02 	vadd.f64	d1, d1, d2
100014f8:	ee33 2b07 	vadd.f64	d2, d3, d7
100014fc:	ee24 3b0f 	vmul.f64	d3, d4, d15
10001500:	ed8d 2b0a 	vstr	d2, [sp, #40]	@ 0x28
10001504:	ed8d 8b04 	vstr	d8, [sp, #16]
10001508:	ed9d 8b02 	vldr	d8, [sp, #8]
1000150c:	ee25 2b0f 	vmul.f64	d2, d5, d15
10001510:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10001514:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10001518:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000151c:	ee03 4b4e 	vmls.f64	d4, d3, d14
10001520:	ee38 8b03 	vadd.f64	d8, d8, d3
10001524:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10001528:	eeb0 3b47 	vmov.f64	d3, d7
1000152c:	ee34 7b07 	vadd.f64	d7, d4, d7
10001530:	ed9d 4b04 	vldr	d4, [sp, #16]
10001534:	ee02 5b4e 	vmls.f64	d5, d2, d14
10001538:	ee34 4b02 	vadd.f64	d4, d4, d2
1000153c:	ee35 5b03 	vadd.f64	d5, d5, d3
10001540:	ed8d 4b02 	vstr	d4, [sp, #8]
10001544:	ed8d 6b48 	vstr	d6, [sp, #288]	@ 0x120
10001548:	ed8d 7b10 	vstr	d7, [sp, #64]	@ 0x40
1000154c:	ee29 4b0f 	vmul.f64	d4, d9, d15
10001550:	ed8d 5b0e 	vstr	d5, [sp, #56]	@ 0x38
10001554:	ee2a 5b0f 	vmul.f64	d5, d10, d15
10001558:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000155c:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10001560:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10001564:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10001568:	ee04 9b4e 	vmls.f64	d9, d4, d14
1000156c:	ee39 7b03 	vadd.f64	d7, d9, d3
10001570:	ee05 ab4e 	vmls.f64	d10, d5, d14
10001574:	ed8d 7b08 	vstr	d7, [sp, #32]
10001578:	ed91 7b0c 	vldr	d7, [r1, #48]	@ 0x30
1000157c:	ee3a 2b03 	vadd.f64	d2, d10, d3
10001580:	ee2b 9b0f 	vmul.f64	d9, d11, d15
10001584:	ed91 ab08 	vldr	d10, [r1, #32]
10001588:	ed91 3b08 	vldr	d3, [r1, #32]
1000158c:	ed8d 2b06 	vstr	d2, [sp, #24]
10001590:	ee3a 2b07 	vadd.f64	d2, d10, d7
10001594:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10001598:	ee33 3b0e 	vadd.f64	d3, d3, d14
1000159c:	ee32 2b04 	vadd.f64	d2, d2, d4
100015a0:	ee33 3b47 	vsub.f64	d3, d3, d7
100015a4:	eeb7 4b00 	vmov.f64	d4, #112	@ 0x3f800000  1.0
100015a8:	eeb8 9b49 	vcvt.f64.u32	d9, s18
100015ac:	ee33 3b44 	vsub.f64	d3, d3, d4
100015b0:	ee09 bb4e 	vmls.f64	d11, d9, d14
100015b4:	ee33 9b09 	vadd.f64	d9, d3, d9
100015b8:	ee3b 3b04 	vadd.f64	d3, d11, d4
100015bc:	eeb0 7b44 	vmov.f64	d7, d4
100015c0:	ee3e db4d 	vsub.f64	d13, d14, d13
100015c4:	ed8d 3b04 	vstr	d3, [sp, #16]
100015c8:	ed94 3b08 	vldr	d3, [r4, #32]
100015cc:	ed94 bb0c 	vldr	d11, [r4, #48]	@ 0x30
100015d0:	ee33 4b0e 	vadd.f64	d4, d3, d14
100015d4:	ee33 3b0b 	vadd.f64	d3, d3, d11
100015d8:	ee34 4b4b 	vsub.f64	d4, d4, d11
100015dc:	ee2c ab0f 	vmul.f64	d10, d12, d15
100015e0:	eebc abca 	vcvt.u32.f64	s20, d10
100015e4:	ee34 4b47 	vsub.f64	d4, d4, d7
100015e8:	ed9d bb12 	vldr	d11, [sp, #72]	@ 0x48
100015ec:	ee33 3b05 	vadd.f64	d3, d3, d5
100015f0:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
100015f4:	ee2d 5b0f 	vmul.f64	d5, d13, d15
100015f8:	ee0a cb4e 	vmls.f64	d12, d10, d14
100015fc:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10001600:	ee34 ab0a 	vadd.f64	d10, d4, d10
10001604:	ee20 4b0f 	vmul.f64	d4, d0, d15
10001608:	ee3c cb07 	vadd.f64	d12, d12, d7
1000160c:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10001610:	eefc 7bc4 	vcvt.u32.f64	s15, d4
10001614:	ee05 db4e 	vmls.f64	d13, d5, d14
10001618:	ee3b bb05 	vadd.f64	d11, d11, d5
1000161c:	eeb8 5b67 	vcvt.f64.u32	d5, s15
10001620:	ed9f 7b65 	vldr	d7, [pc, #404]	@ 100017b8 <fndsa_vect_iFFT_fp64_exact+0x410>
10001624:	ee05 0b4e 	vmls.f64	d0, d5, d14
10001628:	ee21 5b0f 	vmul.f64	d5, d1, d15
1000162c:	ee30 0b07 	vadd.f64	d0, d0, d7
10001630:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10001634:	ed8d 0b12 	vstr	d0, [sp, #72]	@ 0x48
10001638:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000163c:	ee28 0b0f 	vmul.f64	d0, d8, d15
10001640:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10001644:	ee05 1b4e 	vmls.f64	d1, d5, d14
10001648:	eeb8 0b40 	vcvt.f64.u32	d0, s0
1000164c:	eeb0 4b4d 	vmov.f64	d4, d13
10001650:	ee00 8b4e 	vmls.f64	d8, d0, d14
10001654:	ee31 0b07 	vadd.f64	d0, d1, d7
10001658:	ed9d 1b02 	vldr	d1, [sp, #8]
1000165c:	ed8d db52 	vstr	d13, [sp, #328]	@ 0x148
10001660:	ee21 5b0f 	vmul.f64	d5, d1, d15
10001664:	ee22 db0f 	vmul.f64	d13, d2, d15
10001668:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000166c:	eebc dbcd 	vcvt.u32.f64	s26, d13
10001670:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10001674:	ee05 1b4e 	vmls.f64	d1, d5, d14
10001678:	eeb8 5b4d 	vcvt.f64.u32	d5, s26
1000167c:	ee31 db07 	vadd.f64	d13, d1, d7
10001680:	ee05 2b4e 	vmls.f64	d2, d5, d14
10001684:	ed8d db02 	vstr	d13, [sp, #8]
10001688:	ee23 5b0f 	vmul.f64	d5, d3, d15
1000168c:	ee32 db07 	vadd.f64	d13, d2, d7
10001690:	ee29 2b0f 	vmul.f64	d2, d9, d15
10001694:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10001698:	eebc 2bc2 	vcvt.u32.f64	s4, d2
1000169c:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100016a0:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100016a4:	ee05 3b4e 	vmls.f64	d3, d5, d14
100016a8:	ed8d db14 	vstr	d13, [sp, #80]	@ 0x50
100016ac:	ee02 9b4e 	vmls.f64	d9, d2, d14
100016b0:	ee2a 5b0f 	vmul.f64	d5, d10, d15
100016b4:	ee33 db07 	vadd.f64	d13, d3, d7
100016b8:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100016bc:	ee2b 3b0f 	vmul.f64	d3, d11, d15
100016c0:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100016c4:	eefc 2bc3 	vcvt.u32.f64	s5, d3
100016c8:	ee39 3b07 	vadd.f64	d3, d9, d7
100016cc:	ee05 ab4e 	vmls.f64	d10, d5, d14
100016d0:	ed8d 3b16 	vstr	d3, [sp, #88]	@ 0x58
100016d4:	ed9d 1b0c 	vldr	d1, [sp, #48]	@ 0x30
100016d8:	eeb8 5b62 	vcvt.f64.u32	d5, s5
100016dc:	ee3a 3b07 	vadd.f64	d3, d10, d7
100016e0:	ee05 bb4e 	vmls.f64	d11, d5, d14
100016e4:	ed8d 3b18 	vstr	d3, [sp, #96]	@ 0x60
100016e8:	ee34 3b06 	vadd.f64	d3, d4, d6
100016ec:	eebc 5bcb 	vcvt.u32.f64	s10, d11
100016f0:	ee15 3a10 	vmov	r3, s10
100016f4:	ee26 6b0f 	vmul.f64	d6, d6, d15
100016f8:	0fdb      	lsrs	r3, r3, #31
100016fa:	ee05 3a10 	vmov	s10, r3
100016fe:	ee24 4b0f 	vmul.f64	d4, d4, d15
10001702:	ed8d 6b4c 	vstr	d6, [sp, #304]	@ 0x130
10001706:	ed9d ab0a 	vldr	d10, [sp, #40]	@ 0x28
1000170a:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
1000170e:	ee21 6b0f 	vmul.f64	d6, d1, d15
10001712:	ed8d 5b58 	vstr	d5, [sp, #352]	@ 0x160
10001716:	ed8d 4b56 	vstr	d4, [sp, #344]	@ 0x158
1000171a:	ed9d 2b12 	vldr	d2, [sp, #72]	@ 0x48
1000171e:	ee2a 5b0f 	vmul.f64	d5, d10, d15
10001722:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10001726:	eefc 4bc5 	vcvt.u32.f64	s9, d5
1000172a:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000172e:	eeb6 9b00 	vmov.f64	d9, #96	@ 0x3f000000  0.5
10001732:	ee32 2b06 	vadd.f64	d2, d2, d6
10001736:	ee06 1b4e 	vmls.f64	d1, d6, d14
1000173a:	eeb8 6b64 	vcvt.f64.u32	d6, s9
1000173e:	ee21 5b09 	vmul.f64	d5, d1, d9
10001742:	ee06 ab4e 	vmls.f64	d10, d6, d14
10001746:	ee30 1b06 	vadd.f64	d1, d0, d6
1000174a:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000174e:	eeb0 0b49 	vmov.f64	d0, d9
10001752:	eeb8 6b45 	vcvt.f64.u32	d6, s10
10001756:	ee2a 4b09 	vmul.f64	d4, d10, d9
1000175a:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000175e:	ee38 8b07 	vadd.f64	d8, d8, d7
10001762:	ed9d 9b10 	vldr	d9, [sp, #64]	@ 0x40
10001766:	ed8d 6b0c 	vstr	d6, [sp, #48]	@ 0x30
1000176a:	ed9d ab0e 	vldr	d10, [sp, #56]	@ 0x38
1000176e:	ee29 6b0f 	vmul.f64	d6, d9, d15
10001772:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10001776:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000177a:	ee2a 5b0f 	vmul.f64	d5, d10, d15
1000177e:	ed8d 4b10 	vstr	d4, [sp, #64]	@ 0x40
10001782:	ed9d 7b08 	vldr	d7, [sp, #32]
10001786:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000178a:	eefc 4bc5 	vcvt.u32.f64	s9, d5
1000178e:	ee06 9b4e 	vmls.f64	d9, d6, d14
10001792:	ee38 8b06 	vadd.f64	d8, d8, d6
10001796:	ee29 5b00 	vmul.f64	d5, d9, d0
1000179a:	eeb8 6b64 	vcvt.f64.u32	d6, s9
1000179e:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100017a2:	ee06 ab4e 	vmls.f64	d10, d6, d14
100017a6:	e00d      	b.n	100017c4 <fndsa_vect_iFFT_fp64_exact+0x41c>
100017a8:	00000000 	.word	0x00000000
100017ac:	3df00000 	.word	0x3df00000
100017b0:	00000000 	.word	0x00000000
100017b4:	41f00000 	.word	0x41f00000
	...
100017c0:	300009a0 	.word	0x300009a0
100017c4:	ee2a 4b00 	vmul.f64	d4, d10, d0
100017c8:	ed9d 9b02 	vldr	d9, [sp, #8]
100017cc:	eeb8 ab45 	vcvt.f64.u32	d10, s10
100017d0:	ee39 9b06 	vadd.f64	d9, d9, d6
100017d4:	ed8d ab0a 	vstr	d10, [sp, #40]	@ 0x28
100017d8:	ed9d ab06 	vldr	d10, [sp, #24]
100017dc:	ee27 6b0f 	vmul.f64	d6, d7, d15
100017e0:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100017e4:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100017e8:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100017ec:	ee2a 5b0f 	vmul.f64	d5, d10, d15
100017f0:	ed8d 4b08 	vstr	d4, [sp, #32]
100017f4:	ed8d bb50 	vstr	d11, [sp, #320]	@ 0x140
100017f8:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100017fc:	eefc 4bc5 	vcvt.u32.f64	s9, d5
10001800:	ee06 7b4e 	vmls.f64	d7, d6, d14
10001804:	ed9d 5b14 	vldr	d5, [sp, #80]	@ 0x50
10001808:	ee35 5b06 	vadd.f64	d5, d5, d6
1000180c:	eeb8 6b64 	vcvt.f64.u32	d6, s9
10001810:	eeb0 4b4a 	vmov.f64	d4, d10
10001814:	ed8d 5b06 	vstr	d5, [sp, #24]
10001818:	ee27 5b00 	vmul.f64	d5, d7, d0
1000181c:	ed9d ab04 	vldr	d10, [sp, #16]
10001820:	ee06 4b4e 	vmls.f64	d4, d6, d14
10001824:	ee24 4b00 	vmul.f64	d4, d4, d0
10001828:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000182c:	eeb0 7b40 	vmov.f64	d7, d0
10001830:	ee3d db06 	vadd.f64	d13, d13, d6
10001834:	eeb8 0b45 	vcvt.f64.u32	d0, s10
10001838:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000183c:	ee2c 5b0f 	vmul.f64	d5, d12, d15
10001840:	ed8d 0b0e 	vstr	d0, [sp, #56]	@ 0x38
10001844:	eeb8 0b44 	vcvt.f64.u32	d0, s8
10001848:	ee2a 6b0f 	vmul.f64	d6, d10, d15
1000184c:	ed8d 0b04 	vstr	d0, [sp, #16]
10001850:	eefc 0bc5 	vcvt.u32.f64	s1, d5
10001854:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10001858:	ed9d 5b16 	vldr	d5, [sp, #88]	@ 0x58
1000185c:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10001860:	ee35 4b06 	vadd.f64	d4, d5, d6
10001864:	eeb0 5b4a 	vmov.f64	d5, d10
10001868:	ee06 5b4e 	vmls.f64	d5, d6, d14
1000186c:	eeb8 6b60 	vcvt.f64.u32	d6, s1
10001870:	eeb0 0b47 	vmov.f64	d0, d7
10001874:	ee06 cb4e 	vmls.f64	d12, d6, d14
10001878:	ee25 5b07 	vmul.f64	d5, d5, d7
1000187c:	ed9d 7b18 	vldr	d7, [sp, #96]	@ 0x60
10001880:	ee2c cb00 	vmul.f64	d12, d12, d0
10001884:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10001888:	ee37 7b06 	vadd.f64	d7, d7, d6
1000188c:	eefc 5bcc 	vcvt.u32.f64	s11, d12
10001890:	eeb8 cb45 	vcvt.f64.u32	d12, s10
10001894:	eeb8 5b65 	vcvt.f64.u32	d5, s11
10001898:	ee23 6b0f 	vmul.f64	d6, d3, d15
1000189c:	ed8d 7b02 	vstr	d7, [sp, #8]
100018a0:	ed9d 7b00 	vldr	d7, [sp]
100018a4:	ed8d 5b18 	vstr	d5, [sp, #96]	@ 0x60
100018a8:	ee3b 5b07 	vadd.f64	d5, d11, d7
100018ac:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100018b0:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100018b4:	ee27 7b0f 	vmul.f64	d7, d7, d15
100018b8:	ee06 3b4e 	vmls.f64	d3, d6, d14
100018bc:	ed8d 7b4a 	vstr	d7, [sp, #296]	@ 0x128
100018c0:	ee22 7b0f 	vmul.f64	d7, d2, d15
100018c4:	ee35 5b06 	vadd.f64	d5, d5, d6
100018c8:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100018cc:	ee21 6b0f 	vmul.f64	d6, d1, d15
100018d0:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100018d4:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100018d8:	ee07 2b4e 	vmls.f64	d2, d7, d14
100018dc:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100018e0:	eefc 7bc2 	vcvt.u32.f64	s15, d2
100018e4:	ee17 2a90 	vmov	r2, s15
100018e8:	ee06 1b4e 	vmls.f64	d1, d6, d14
100018ec:	0fd3      	lsrs	r3, r2, #31
100018ee:	eefc 7bc1 	vcvt.u32.f64	s15, d1
100018f2:	ee07 3a10 	vmov	s14, r3
100018f6:	0853      	lsrs	r3, r2, #1
100018f8:	ee2b bb0f 	vmul.f64	d11, d11, d15
100018fc:	f002 0201 	and.w	r2, r2, #1
10001900:	ee00 3a10 	vmov	s0, r3
10001904:	ee17 ca90 	vmov	ip, s15
10001908:	ed8d bb54 	vstr	d11, [sp, #336]	@ 0x150
1000190c:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10001910:	ee23 bb0f 	vmul.f64	d11, d3, d15
10001914:	ed8d 3b5c 	vstr	d3, [sp, #368]	@ 0x170
10001918:	ea4f 035c 	mov.w	r3, ip, lsr #1
1000191c:	ed9f 3bfa 	vldr	d3, [pc, #1000]	@ 10001d08 <fndsa_vect_iFFT_fp64_exact+0x960>
10001920:	ed9d 1b0c 	vldr	d1, [sp, #48]	@ 0x30
10001924:	eeb8 0bc0 	vcvt.f64.s32	d0, s0
10001928:	ee02 3a10 	vmov	s4, r3
1000192c:	ee07 0b03 	vmla.f64	d0, d7, d3
10001930:	ea4f 73dc 	mov.w	r3, ip, lsr #31
10001934:	ee07 3a10 	vmov	s14, r3
10001938:	ee07 2a90 	vmov	s15, r2
1000193c:	eeb8 2bc2 	vcvt.f64.s32	d2, s4
10001940:	eeb8 6be7 	vcvt.f64.s32	d6, s15
10001944:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10001948:	f00c 0301 	and.w	r3, ip, #1
1000194c:	ee07 2b03 	vmla.f64	d2, d7, d3
10001950:	ee07 3a90 	vmov	s15, r3
10001954:	ee06 1b03 	vmla.f64	d1, d6, d3
10001958:	eeb8 7be7 	vcvt.f64.s32	d7, s15
1000195c:	eeb0 6b43 	vmov.f64	d6, d3
10001960:	ed9d 3b10 	vldr	d3, [sp, #64]	@ 0x40
10001964:	ee07 3b06 	vmla.f64	d3, d7, d6
10001968:	ee28 7b0f 	vmul.f64	d7, d8, d15
1000196c:	eeb0 ab46 	vmov.f64	d10, d6
10001970:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10001974:	ee29 6b0f 	vmul.f64	d6, d9, d15
10001978:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000197c:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10001980:	ee07 8b4e 	vmls.f64	d8, d7, d14
10001984:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10001988:	eefc 7bc8 	vcvt.u32.f64	s15, d8
1000198c:	ee17 2a90 	vmov	r2, s15
10001990:	ee06 9b4e 	vmls.f64	d9, d6, d14
10001994:	0fd3      	lsrs	r3, r2, #31
10001996:	ee07 3a10 	vmov	s14, r3
1000199a:	0853      	lsrs	r3, r2, #1
1000199c:	eefc 7bc9 	vcvt.u32.f64	s15, d9
100019a0:	ee06 3a10 	vmov	s12, r3
100019a4:	ee17 ca90 	vmov	ip, s15
100019a8:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
100019ac:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100019b0:	eeb0 9b4a 	vmov.f64	d9, d10
100019b4:	ee07 6b0a 	vmla.f64	d6, d7, d10
100019b8:	f002 0201 	and.w	r2, r2, #1
100019bc:	ea4f 73dc 	mov.w	r3, ip, lsr #31
100019c0:	ee07 2a90 	vmov	s15, r2
100019c4:	ed8d 6b14 	vstr	d6, [sp, #80]	@ 0x50
100019c8:	ee06 3a10 	vmov	s12, r3
100019cc:	eeb8 8be7 	vcvt.f64.s32	d8, s15
100019d0:	ea4f 035c 	mov.w	r3, ip, lsr #1
100019d4:	ee07 3a10 	vmov	s14, r3
100019d8:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
100019dc:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100019e0:	f00c 0301 	and.w	r3, ip, #1
100019e4:	ee06 7b09 	vmla.f64	d7, d6, d9
100019e8:	ed9d ab0a 	vldr	d10, [sp, #40]	@ 0x28
100019ec:	ed8d 7b10 	vstr	d7, [sp, #64]	@ 0x40
100019f0:	ee07 3a90 	vmov	s15, r3
100019f4:	eeb8 7be7 	vcvt.f64.s32	d7, s15
100019f8:	ee08 ab09 	vmla.f64	d10, d8, d9
100019fc:	eeb0 8b49 	vmov.f64	d8, d9
10001a00:	ed9d 9b08 	vldr	d9, [sp, #32]
10001a04:	ee07 9b08 	vmla.f64	d9, d7, d8
10001a08:	ee2d 6b0f 	vmul.f64	d6, d13, d15
10001a0c:	ed8d 9b12 	vstr	d9, [sp, #72]	@ 0x48
10001a10:	ed9d 9b06 	vldr	d9, [sp, #24]
10001a14:	ee29 7b0f 	vmul.f64	d7, d9, d15
10001a18:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10001a1c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10001a20:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10001a24:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10001a28:	ee07 9b4e 	vmls.f64	d9, d7, d14
10001a2c:	eefc 7bc9 	vcvt.u32.f64	s15, d9
10001a30:	ee17 2a90 	vmov	r2, s15
10001a34:	ee06 db4e 	vmls.f64	d13, d6, d14
10001a38:	0fd3      	lsrs	r3, r2, #31
10001a3a:	ee06 3a10 	vmov	s12, r3
10001a3e:	0853      	lsrs	r3, r2, #1
10001a40:	ee07 3a10 	vmov	s14, r3
10001a44:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10001a48:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10001a4c:	ed8d ab16 	vstr	d10, [sp, #88]	@ 0x58
10001a50:	eeb0 ab47 	vmov.f64	d10, d7
10001a54:	eefc 7bcd 	vcvt.u32.f64	s15, d13
10001a58:	eeb0 9b48 	vmov.f64	d9, d8
10001a5c:	ee17 ca90 	vmov	ip, s15
10001a60:	ee06 ab08 	vmla.f64	d10, d6, d8
10001a64:	f002 0201 	and.w	r2, r2, #1
10001a68:	ea4f 73dc 	mov.w	r3, ip, lsr #31
10001a6c:	ed9d db0e 	vldr	d13, [sp, #56]	@ 0x38
10001a70:	ee07 2a90 	vmov	s15, r2
10001a74:	ee06 3a10 	vmov	s12, r3
10001a78:	ea4f 035c 	mov.w	r3, ip, lsr #1
10001a7c:	eeb8 8be7 	vcvt.f64.s32	d8, s15
10001a80:	ee07 3a10 	vmov	s14, r3
10001a84:	ee08 db09 	vmla.f64	d13, d8, d9
10001a88:	f00c 0301 	and.w	r3, ip, #1
10001a8c:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10001a90:	ed8d db0e 	vstr	d13, [sp, #56]	@ 0x38
10001a94:	eeb0 db47 	vmov.f64	d13, d7
10001a98:	ee07 3a90 	vmov	s15, r3
10001a9c:	ed8d ab0c 	vstr	d10, [sp, #48]	@ 0x30
10001aa0:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10001aa4:	ed9d ab04 	vldr	d10, [sp, #16]
10001aa8:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10001aac:	ee07 ab09 	vmla.f64	d10, d7, d9
10001ab0:	ee24 7b0f 	vmul.f64	d7, d4, d15
10001ab4:	ee06 db09 	vmla.f64	d13, d6, d9
10001ab8:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10001abc:	ed8d db0a 	vstr	d13, [sp, #40]	@ 0x28
10001ac0:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10001ac4:	ed9d db02 	vldr	d13, [sp, #8]
10001ac8:	ee07 4b4e 	vmls.f64	d4, d7, d14
10001acc:	ee2d 6b0f 	vmul.f64	d6, d13, d15
10001ad0:	eefc 7bc4 	vcvt.u32.f64	s15, d4
10001ad4:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10001ad8:	ee17 2a90 	vmov	r2, s15
10001adc:	eeb8 7b46 	vcvt.f64.u32	d7, s12
10001ae0:	ee07 db4e 	vmls.f64	d13, d7, d14
10001ae4:	0fd3      	lsrs	r3, r2, #31
10001ae6:	eefc 7bcd 	vcvt.u32.f64	s15, d13
10001aea:	ee06 3a10 	vmov	s12, r3
10001aee:	0853      	lsrs	r3, r2, #1
10001af0:	ee08 3a10 	vmov	s16, r3
10001af4:	ee17 ca90 	vmov	ip, s15
10001af8:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10001afc:	eeb8 8bc8 	vcvt.f64.s32	d8, s16
10001b00:	ea4f 035c 	mov.w	r3, ip, lsr #1
10001b04:	ee07 3a10 	vmov	s14, r3
10001b08:	ee06 8b09 	vmla.f64	d8, d6, d9
10001b0c:	ea4f 73dc 	mov.w	r3, ip, lsr #31
10001b10:	f002 0201 	and.w	r2, r2, #1
10001b14:	ee07 2a90 	vmov	s15, r2
10001b18:	ee06 3a10 	vmov	s12, r3
10001b1c:	eeb8 4be7 	vcvt.f64.s32	d4, s15
10001b20:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10001b24:	ee04 cb09 	vmla.f64	d12, d4, d9
10001b28:	f00c 0301 	and.w	r3, ip, #1
10001b2c:	eeb0 4b47 	vmov.f64	d4, d7
10001b30:	ed8d cb04 	vstr	d12, [sp, #16]
10001b34:	ee07 3a90 	vmov	s15, r3
10001b38:	ed9d cb18 	vldr	d12, [sp, #96]	@ 0x60
10001b3c:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10001b40:	ee07 cb09 	vmla.f64	d12, d7, d9
10001b44:	ee25 7b0f 	vmul.f64	d7, d5, d15
10001b48:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10001b4c:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10001b50:	ee07 5b4e 	vmls.f64	d5, d7, d14
10001b54:	eebc 7bc5 	vcvt.u32.f64	s14, d5
10001b58:	ee17 3a10 	vmov	r3, s14
10001b5c:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10001b60:	0fdb      	lsrs	r3, r3, #31
10001b62:	ee06 4b09 	vmla.f64	d4, d6, d9
10001b66:	a846      	add	r0, sp, #280	@ 0x118
10001b68:	ee07 3a10 	vmov	s14, r3
10001b6c:	ed8d 4b00 	vstr	d4, [sp]
10001b70:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10001b74:	ed8d ab08 	vstr	d10, [sp, #32]
10001b78:	ed8d cb02 	vstr	d12, [sp, #8]
10001b7c:	ed8d 5b5a 	vstr	d5, [sp, #360]	@ 0x168
10001b80:	ee25 5b0f 	vmul.f64	d5, d5, d15
10001b84:	ed8d 7b62 	vstr	d7, [sp, #392]	@ 0x188
10001b88:	ed8d 5b5e 	vstr	d5, [sp, #376]	@ 0x178
10001b8c:	ed8d bb60 	vstr	d11, [sp, #384]	@ 0x180
10001b90:	f7fe fbea 	bl	10000368 <fp64e_cmul_prepared>
10001b94:	edd6 7a06 	vldr	s15, [r6, #24]
10001b98:	6973      	ldr	r3, [r6, #20]
10001b9a:	eeb8 5b67 	vcvt.f64.u32	d5, s15
10001b9e:	0fdb      	lsrs	r3, r3, #31
10001ba0:	ee04 3a10 	vmov	s8, r3
10001ba4:	ee3e 5b45 	vsub.f64	d5, d14, d5
10001ba8:	edd6 7a07 	vldr	s15, [r6, #28]
10001bac:	eeb8 6b67 	vcvt.f64.u32	d6, s15
10001bb0:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
10001bb4:	ee3e 6b46 	vsub.f64	d6, d14, d6
10001bb8:	ed8d 4b4e 	vstr	d4, [sp, #312]	@ 0x138
10001bbc:	eeb7 4b00 	vmov.f64	d4, #112	@ 0x3f800000  1.0
10001bc0:	eeb0 cb40 	vmov.f64	d12, d0
10001bc4:	ee36 6b44 	vsub.f64	d6, d6, d4
10001bc8:	edd6 7a04 	vldr	s15, [r6, #16]
10001bcc:	ee25 4b0f 	vmul.f64	d4, d5, d15
10001bd0:	eeb0 0b48 	vmov.f64	d0, d8
10001bd4:	eeb8 8b67 	vcvt.f64.u32	d8, s15
10001bd8:	edd6 7a05 	vldr	s15, [r6, #20]
10001bdc:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10001be0:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10001be4:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10001be8:	ee27 bb0f 	vmul.f64	d11, d7, d15
10001bec:	ee36 6b04 	vadd.f64	d6, d6, d4
10001bf0:	ed8d bb4a 	vstr	d11, [sp, #296]	@ 0x128
10001bf4:	ee26 bb0f 	vmul.f64	d11, d6, d15
10001bf8:	eebc bbcb 	vcvt.u32.f64	s22, d11
10001bfc:	ee04 5b4e 	vmls.f64	d5, d4, d14
10001c00:	eeb8 bb4b 	vcvt.f64.u32	d11, s22
10001c04:	ee35 4b08 	vadd.f64	d4, d5, d8
10001c08:	ed8d 5b52 	vstr	d5, [sp, #328]	@ 0x148
10001c0c:	ee25 5b0f 	vmul.f64	d5, d5, d15
10001c10:	ee0b 6b4e 	vmls.f64	d6, d11, d14
10001c14:	ed8d 5b56 	vstr	d5, [sp, #344]	@ 0x158
10001c18:	ed8d 7b46 	vstr	d7, [sp, #280]	@ 0x118
10001c1c:	eefc 5bc6 	vcvt.u32.f64	s11, d6
10001c20:	ee36 7b07 	vadd.f64	d7, d6, d7
10001c24:	ed8d 6b50 	vstr	d6, [sp, #320]	@ 0x140
10001c28:	ee15 3a90 	vmov	r3, s11
10001c2c:	ee26 6b0f 	vmul.f64	d6, d6, d15
10001c30:	0fdb      	lsrs	r3, r3, #31
10001c32:	ed8d 6b54 	vstr	d6, [sp, #336]	@ 0x150
10001c36:	ee06 3a10 	vmov	s12, r3
10001c3a:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10001c3e:	ed8d 6b58 	vstr	d6, [sp, #352]	@ 0x160
10001c42:	ee24 6b0f 	vmul.f64	d6, d4, d15
10001c46:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10001c4a:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10001c4e:	ee37 7b06 	vadd.f64	d7, d7, d6
10001c52:	ee06 4b4e 	vmls.f64	d4, d6, d14
10001c56:	ee27 6b0f 	vmul.f64	d6, d7, d15
10001c5a:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10001c5e:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10001c62:	ee06 7b4e 	vmls.f64	d7, d6, d14
10001c66:	eefc 6bc7 	vcvt.u32.f64	s13, d7
10001c6a:	ed8d 7b5a 	vstr	d7, [sp, #360]	@ 0x168
10001c6e:	ee16 3a90 	vmov	r3, s13
10001c72:	ee27 7b0f 	vmul.f64	d7, d7, d15
10001c76:	0fdb      	lsrs	r3, r3, #31
10001c78:	ed8d 7b5e 	vstr	d7, [sp, #376]	@ 0x178
10001c7c:	ee07 3a10 	vmov	s14, r3
10001c80:	eeb0 9b43 	vmov.f64	d9, d3
10001c84:	eeb0 ab41 	vmov.f64	d10, d1
10001c88:	eeb0 db42 	vmov.f64	d13, d2
10001c8c:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10001c90:	ed8d 8b48 	vstr	d8, [sp, #288]	@ 0x120
10001c94:	ee28 8b0f 	vmul.f64	d8, d8, d15
10001c98:	ed8d 4b5c 	vstr	d4, [sp, #368]	@ 0x170
10001c9c:	ed9d 2b00 	vldr	d2, [sp]
10001ca0:	ed9d 1b04 	vldr	d1, [sp, #16]
10001ca4:	ed9d 3b02 	vldr	d3, [sp, #8]
10001ca8:	ed8d 7b62 	vstr	d7, [sp, #392]	@ 0x188
10001cac:	ed8d cb2e 	vstr	d12, [sp, #184]	@ 0xb8
10001cb0:	ed8d ab30 	vstr	d10, [sp, #192]	@ 0xc0
10001cb4:	ed8d db32 	vstr	d13, [sp, #200]	@ 0xc8
10001cb8:	ed8d 9b34 	vstr	d9, [sp, #208]	@ 0xd0
10001cbc:	ee24 4b0f 	vmul.f64	d4, d4, d15
10001cc0:	ed8d 8b4c 	vstr	d8, [sp, #304]	@ 0x130
10001cc4:	ed8d 4b60 	vstr	d4, [sp, #384]	@ 0x180
10001cc8:	f7fe fb4e 	bl	10000368 <fp64e_cmul_prepared>
10001ccc:	edd7 7a02 	vldr	s15, [r7, #8]
10001cd0:	edd7 5a00 	vldr	s11, [r7]
10001cd4:	687b      	ldr	r3, [r7, #4]
10001cd6:	eeb8 4b65 	vcvt.f64.u32	d4, s11
10001cda:	0fdb      	lsrs	r3, r3, #31
10001cdc:	eeb8 6b67 	vcvt.f64.u32	d6, s15
10001ce0:	ee05 3a10 	vmov	s10, r3
10001ce4:	ee3e bb46 	vsub.f64	d11, d14, d6
10001ce8:	edd7 5a01 	vldr	s11, [r7, #4]
10001cec:	edd7 7a03 	vldr	s15, [r7, #12]
10001cf0:	eeb8 8b65 	vcvt.f64.u32	d8, s11
10001cf4:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10001cf8:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
10001cfc:	ee3e 7b47 	vsub.f64	d7, d14, d7
10001d00:	ed8d 5b4e 	vstr	d5, [sp, #312]	@ 0x138
10001d04:	e008      	b.n	10001d18 <fndsa_vect_iFFT_fp64_exact+0x970>
10001d06:	bf00      	nop
10001d08:	00000000 	.word	0x00000000
10001d0c:	41e00000 	.word	0x41e00000
	...
10001d18:	eeb7 5b00 	vmov.f64	d5, #112	@ 0x3f800000  1.0
10001d1c:	ed8d bb06 	vstr	d11, [sp, #24]
10001d20:	ee37 bb45 	vsub.f64	d11, d7, d5
10001d24:	ed9d 6b16 	vldr	d6, [sp, #88]	@ 0x58
10001d28:	ee36 7b0e 	vadd.f64	d7, d6, d14
10001d2c:	ed8d bb1a 	vstr	d11, [sp, #104]	@ 0x68
10001d30:	ed9d bb0e 	vldr	d11, [sp, #56]	@ 0x38
10001d34:	ed9d 5b08 	vldr	d5, [sp, #32]
10001d38:	ee3b 6b06 	vadd.f64	d6, d11, d6
10001d3c:	ee37 7b4b 	vsub.f64	d7, d7, d11
10001d40:	ed8d 6b0e 	vstr	d6, [sp, #56]	@ 0x38
10001d44:	ed9d 6b12 	vldr	d6, [sp, #72]	@ 0x48
10001d48:	ee36 bb0e 	vadd.f64	d11, d6, d14
10001d4c:	ee35 6b06 	vadd.f64	d6, d5, d6
10001d50:	ed8d 6b04 	vstr	d6, [sp, #16]
10001d54:	ee3a 6b0e 	vadd.f64	d6, d10, d14
10001d58:	ed8d 1b38 	vstr	d1, [sp, #224]	@ 0xe0
10001d5c:	ed8d 0b36 	vstr	d0, [sp, #216]	@ 0xd8
10001d60:	ed8d 2b3a 	vstr	d2, [sp, #232]	@ 0xe8
10001d64:	ed8d 3b3c 	vstr	d3, [sp, #240]	@ 0xf0
10001d68:	ee3a ab01 	vadd.f64	d10, d10, d1
10001d6c:	ee36 1b41 	vsub.f64	d1, d6, d1
10001d70:	ee39 6b0e 	vadd.f64	d6, d9, d14
10001d74:	ee3b bb45 	vsub.f64	d11, d11, d5
10001d78:	ed8d 8b00 	vstr	d8, [sp]
10001d7c:	ed8d 8b46 	vstr	d8, [sp, #280]	@ 0x118
10001d80:	ed8d 4b48 	vstr	d4, [sp, #288]	@ 0x120
10001d84:	ed8d 1b08 	vstr	d1, [sp, #32]
10001d88:	ed8d 7b02 	vstr	d7, [sp, #8]
10001d8c:	ee39 1b03 	vadd.f64	d1, d9, d3
10001d90:	ee36 9b43 	vsub.f64	d9, d6, d3
10001d94:	ed9d 3b14 	vldr	d3, [sp, #80]	@ 0x50
10001d98:	ed9d 8b0c 	vldr	d8, [sp, #48]	@ 0x30
10001d9c:	ee27 6b0f 	vmul.f64	d6, d7, d15
10001da0:	ee33 5b0e 	vadd.f64	d5, d3, d14
10001da4:	ee38 3b03 	vadd.f64	d3, d8, d3
10001da8:	ee35 5b48 	vsub.f64	d5, d5, d8
10001dac:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10001db0:	eeb7 7b00 	vmov.f64	d7, #112	@ 0x3f800000  1.0
10001db4:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10001db8:	eeb0 8b47 	vmov.f64	d8, d7
10001dbc:	ee35 5b47 	vsub.f64	d5, d5, d7
10001dc0:	ed9d 7b02 	vldr	d7, [sp, #8]
10001dc4:	ee06 7b4e 	vmls.f64	d7, d6, d14
10001dc8:	ee35 5b06 	vadd.f64	d5, d5, d6
10001dcc:	ee37 7b08 	vadd.f64	d7, d7, d8
10001dd0:	ed8d 5b0c 	vstr	d5, [sp, #48]	@ 0x30
10001dd4:	ed8d 7b14 	vstr	d7, [sp, #80]	@ 0x50
10001dd8:	ee2b 7b0f 	vmul.f64	d7, d11, d15
10001ddc:	ed9d 5b10 	vldr	d5, [sp, #64]	@ 0x40
10001de0:	ed9d 8b0a 	vldr	d8, [sp, #40]	@ 0x28
10001de4:	ee35 6b0e 	vadd.f64	d6, d5, d14
10001de8:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10001dec:	ee38 5b05 	vadd.f64	d5, d8, d5
10001df0:	ee36 6b48 	vsub.f64	d6, d6, d8
10001df4:	eeb7 8b00 	vmov.f64	d8, #112	@ 0x3f800000  1.0
10001df8:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10001dfc:	ee36 6b48 	vsub.f64	d6, d6, d8
10001e00:	ee07 bb4e 	vmls.f64	d11, d7, d14
10001e04:	ee36 7b07 	vadd.f64	d7, d6, d7
10001e08:	ee3b bb08 	vadd.f64	d11, d11, d8
10001e0c:	ed9d 8b0e 	vldr	d8, [sp, #56]	@ 0x38
10001e10:	ed8d 7b0a 	vstr	d7, [sp, #40]	@ 0x28
10001e14:	ed9d 6b04 	vldr	d6, [sp, #16]
10001e18:	ee28 7b0f 	vmul.f64	d7, d8, d15
10001e1c:	ed8d bb12 	vstr	d11, [sp, #72]	@ 0x48
10001e20:	ee26 6b0f 	vmul.f64	d6, d6, d15
10001e24:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10001e28:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10001e2c:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10001e30:	ee33 bb07 	vadd.f64	d11, d3, d7
10001e34:	eeb0 3b48 	vmov.f64	d3, d8
10001e38:	eeb7 8b00 	vmov.f64	d8, #112	@ 0x3f800000  1.0
10001e3c:	ee07 3b4e 	vmls.f64	d3, d7, d14
10001e40:	eeb8 7b46 	vcvt.f64.u32	d7, s12
10001e44:	ee33 3b08 	vadd.f64	d3, d3, d8
10001e48:	ed9d 6b04 	vldr	d6, [sp, #16]
10001e4c:	ee07 6b4e 	vmls.f64	d6, d7, d14
10001e50:	ed8d 3b18 	vstr	d3, [sp, #96]	@ 0x60
10001e54:	ee35 3b07 	vadd.f64	d3, d5, d7
10001e58:	ee36 6b08 	vadd.f64	d6, d6, d8
10001e5c:	ee2a 7b0f 	vmul.f64	d7, d10, d15
10001e60:	ed8d 6b16 	vstr	d6, [sp, #88]	@ 0x58
10001e64:	ed8d 3b0e 	vstr	d3, [sp, #56]	@ 0x38
10001e68:	ee21 6b0f 	vmul.f64	d6, d1, d15
10001e6c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10001e70:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10001e74:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10001e78:	eeb8 3b46 	vcvt.f64.u32	d3, s12
10001e7c:	ee07 ab4e 	vmls.f64	d10, d7, d14
10001e80:	ee03 1b4e 	vmls.f64	d1, d3, d14
10001e84:	ee31 6b08 	vadd.f64	d6, d1, d8
10001e88:	ee3a ab08 	vadd.f64	d10, d10, d8
10001e8c:	ed9d 8b08 	vldr	d8, [sp, #32]
10001e90:	ed8d 6b10 	vstr	d6, [sp, #64]	@ 0x40
10001e94:	ee28 6b0f 	vmul.f64	d6, d8, d15
10001e98:	ee3c 5b0e 	vadd.f64	d5, d12, d14
10001e9c:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10001ea0:	ee3c cb00 	vadd.f64	d12, d12, d0
10001ea4:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10001ea8:	ee35 5b40 	vsub.f64	d5, d5, d0
10001eac:	ee3c 1b07 	vadd.f64	d1, d12, d7
10001eb0:	eeb7 7b00 	vmov.f64	d7, #112	@ 0x3f800000  1.0
10001eb4:	eeb0 cb48 	vmov.f64	d12, d8
10001eb8:	ee35 5b47 	vsub.f64	d5, d5, d7
10001ebc:	ed9d 8b06 	vldr	d8, [sp, #24]
10001ec0:	ee06 cb4e 	vmls.f64	d12, d6, d14
10001ec4:	ee35 0b06 	vadd.f64	d0, d5, d6
10001ec8:	ee3c cb07 	vadd.f64	d12, d12, d7
10001ecc:	eeb0 5b47 	vmov.f64	d5, d7
10001ed0:	ee29 7b0f 	vmul.f64	d7, d9, d15
10001ed4:	ee3d 6b0e 	vadd.f64	d6, d13, d14
10001ed8:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10001edc:	ee32 db0d 	vadd.f64	d13, d2, d13
10001ee0:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10001ee4:	ee36 6b42 	vsub.f64	d6, d6, d2
10001ee8:	ee3d 3b03 	vadd.f64	d3, d13, d3
10001eec:	ee36 6b45 	vsub.f64	d6, d6, d5
10001ef0:	ee07 9b4e 	vmls.f64	d9, d7, d14
10001ef4:	ee39 db05 	vadd.f64	d13, d9, d5
10001ef8:	ee36 2b07 	vadd.f64	d2, d6, d7
10001efc:	ed8d db04 	vstr	d13, [sp, #16]
10001f00:	ed9d db0c 	vldr	d13, [sp, #48]	@ 0x30
10001f04:	ee28 7b0f 	vmul.f64	d7, d8, d15
10001f08:	ee2d 6b0f 	vmul.f64	d6, d13, d15
10001f0c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10001f10:	eefc 5bc6 	vcvt.u32.f64	s11, d6
10001f14:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10001f18:	ed9d 6b1a 	vldr	d6, [sp, #104]	@ 0x68
10001f1c:	ee36 9b07 	vadd.f64	d9, d6, d7
10001f20:	eeb0 6b48 	vmov.f64	d6, d8
10001f24:	ed1f 8b86 	vldr	d8, [pc, #-536]	@ 10001d10 <fndsa_vect_iFFT_fp64_exact+0x968>
10001f28:	ee07 6b4e 	vmls.f64	d6, d7, d14
10001f2c:	ed8d cb02 	vstr	d12, [sp, #8]
10001f30:	ed9d cb0a 	vldr	d12, [sp, #40]	@ 0x28
10001f34:	eeb8 7b65 	vcvt.f64.u32	d7, s11
10001f38:	eeb0 5b4d 	vmov.f64	d5, d13
10001f3c:	ee07 5b4e 	vmls.f64	d5, d7, d14
10001f40:	ee2c 7b0f 	vmul.f64	d7, d12, d15
10001f44:	ee35 5b08 	vadd.f64	d5, d5, d8
10001f48:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10001f4c:	ed8d 5b08 	vstr	d5, [sp, #32]
10001f50:	ee2b 5b0f 	vmul.f64	d5, d11, d15
10001f54:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10001f58:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10001f5c:	ee07 cb4e 	vmls.f64	d12, d7, d14
10001f60:	ed9d db0e 	vldr	d13, [sp, #56]	@ 0x38
10001f64:	eeb8 7b45 	vcvt.f64.u32	d7, s10
10001f68:	ee21 5b0f 	vmul.f64	d5, d1, d15
10001f6c:	ee07 bb4e 	vmls.f64	d11, d7, d14
10001f70:	ee3c 7b08 	vadd.f64	d7, d12, d8
10001f74:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10001f78:	eeb0 cb47 	vmov.f64	d12, d7
10001f7c:	ee2d 7b0f 	vmul.f64	d7, d13, d15
10001f80:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10001f84:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10001f88:	ee07 db4e 	vmls.f64	d13, d7, d14
10001f8c:	eeb8 7b45 	vcvt.f64.u32	d7, s10
10001f90:	ee07 1b4e 	vmls.f64	d1, d7, d14
10001f94:	ee3d 7b08 	vadd.f64	d7, d13, d8
10001f98:	ee31 1b08 	vadd.f64	d1, d1, d8
10001f9c:	ed8d 7b06 	vstr	d7, [sp, #24]
10001fa0:	ee23 7b0f 	vmul.f64	d7, d3, d15
10001fa4:	ed8d 1b0c 	vstr	d1, [sp, #48]	@ 0x30
10001fa8:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10001fac:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10001fb0:	ee20 5b0f 	vmul.f64	d5, d0, d15
10001fb4:	ee07 3b4e 	vmls.f64	d3, d7, d14
10001fb8:	ee22 7b0f 	vmul.f64	d7, d2, d15
10001fbc:	eefc 1bc5 	vcvt.u32.f64	s3, d5
10001fc0:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10001fc4:	ee29 5b0f 	vmul.f64	d5, d9, d15
10001fc8:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10001fcc:	ee33 3b08 	vadd.f64	d3, d3, d8
10001fd0:	ee07 2b4e 	vmls.f64	d2, d7, d14
10001fd4:	ed8d 3b1a 	vstr	d3, [sp, #104]	@ 0x68
10001fd8:	eeb8 7b61 	vcvt.f64.u32	d7, s3
10001fdc:	eefc 3bc5 	vcvt.u32.f64	s7, d5
10001fe0:	ee07 0b4e 	vmls.f64	d0, d7, d14
10001fe4:	eeb8 7b63 	vcvt.f64.u32	d7, s7
10001fe8:	ee07 9b4e 	vmls.f64	d9, d7, d14
10001fec:	eebc 7bc9 	vcvt.u32.f64	s14, d9
10001ff0:	ee17 3a10 	vmov	r3, s14
10001ff4:	0fdb      	lsrs	r3, r3, #31
10001ff6:	ee07 3a10 	vmov	s14, r3
10001ffa:	ee36 3b04 	vadd.f64	d3, d6, d4
10001ffe:	ed8d 6b52 	vstr	d6, [sp, #328]	@ 0x148
10002002:	ee32 2b08 	vadd.f64	d2, d2, d8
10002006:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
1000200a:	ee24 4b0f 	vmul.f64	d4, d4, d15
1000200e:	ed8d 2b1c 	vstr	d2, [sp, #112]	@ 0x70
10002012:	ed8d 9b50 	vstr	d9, [sp, #320]	@ 0x140
10002016:	ed8d 7b58 	vstr	d7, [sp, #352]	@ 0x160
1000201a:	ee26 6b0f 	vmul.f64	d6, d6, d15
1000201e:	ed8d 4b4c 	vstr	d4, [sp, #304]	@ 0x130
10002022:	ed9d 2b14 	vldr	d2, [sp, #80]	@ 0x50
10002026:	ed9d 1b12 	vldr	d1, [sp, #72]	@ 0x48
1000202a:	ee22 7b0f 	vmul.f64	d7, d2, d15
1000202e:	ed8d 6b56 	vstr	d6, [sp, #344]	@ 0x158
10002032:	ed9d 4b08 	vldr	d4, [sp, #32]
10002036:	ee21 6b0f 	vmul.f64	d6, d1, d15
1000203a:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000203e:	eefc 5bc6 	vcvt.u32.f64	s11, d6
10002042:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10002046:	eeb0 6b42 	vmov.f64	d6, d2
1000204a:	ee34 4b07 	vadd.f64	d4, d4, d7
1000204e:	ee07 6b4e 	vmls.f64	d6, d7, d14
10002052:	eeb8 7b65 	vcvt.f64.u32	d7, s11
10002056:	eeb0 5b41 	vmov.f64	d5, d1
1000205a:	ee30 0b08 	vadd.f64	d0, d0, d8
1000205e:	ee3b bb08 	vadd.f64	d11, d11, d8
10002062:	ee07 5b4e 	vmls.f64	d5, d7, d14
10002066:	eeb6 8b00 	vmov.f64	d8, #96	@ 0x3f000000  0.5
1000206a:	ee3c 2b07 	vadd.f64	d2, d12, d7
1000206e:	ed9d cb18 	vldr	d12, [sp, #96]	@ 0x60
10002072:	ed9d db16 	vldr	d13, [sp, #88]	@ 0x58
10002076:	ee26 6b08 	vmul.f64	d6, d6, d8
1000207a:	ee25 5b08 	vmul.f64	d5, d5, d8
1000207e:	ee2c 7b0f 	vmul.f64	d7, d12, d15
10002082:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10002086:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000208a:	eeb8 1b46 	vcvt.f64.u32	d1, s12
1000208e:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10002092:	ee2d 6b0f 	vmul.f64	d6, d13, d15
10002096:	ed8d 5b18 	vstr	d5, [sp, #96]	@ 0x60
1000209a:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000209e:	eefc 5bc6 	vcvt.u32.f64	s11, d6
100020a2:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100020a6:	eeb0 6b4c 	vmov.f64	d6, d12
100020aa:	ee3b bb07 	vadd.f64	d11, d11, d7
100020ae:	ee07 6b4e 	vmls.f64	d6, d7, d14
100020b2:	eeb8 7b65 	vcvt.f64.u32	d7, s11
100020b6:	ee26 6b08 	vmul.f64	d6, d6, d8
100020ba:	ed9d 5b06 	vldr	d5, [sp, #24]
100020be:	ee35 5b07 	vadd.f64	d5, d5, d7
100020c2:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100020c6:	ed8d 5b08 	vstr	d5, [sp, #32]
100020ca:	eeb0 5b4d 	vmov.f64	d5, d13
100020ce:	ed9d cb10 	vldr	d12, [sp, #64]	@ 0x40
100020d2:	ee07 5b4e 	vmls.f64	d5, d7, d14
100020d6:	eeb8 7b46 	vcvt.f64.u32	d7, s12
100020da:	ee25 5b08 	vmul.f64	d5, d5, d8
100020de:	ed8d 7b0a 	vstr	d7, [sp, #40]	@ 0x28
100020e2:	ee2a 7b0f 	vmul.f64	d7, d10, d15
100020e6:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100020ea:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100020ee:	ee2c 6b0f 	vmul.f64	d6, d12, d15
100020f2:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100020f6:	eefc 5bc6 	vcvt.u32.f64	s11, d6
100020fa:	ee07 ab4e 	vmls.f64	d10, d7, d14
100020fe:	ed9d 6b0c 	vldr	d6, [sp, #48]	@ 0x30
10002102:	ee36 6b07 	vadd.f64	d6, d6, d7
10002106:	ed8d 6b06 	vstr	d6, [sp, #24]
1000210a:	ee2a 6b08 	vmul.f64	d6, d10, d8
1000210e:	eeb8 7b65 	vcvt.f64.u32	d7, s11
10002112:	eeb8 db45 	vcvt.f64.u32	d13, s10
10002116:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000211a:	eeb0 5b4c 	vmov.f64	d5, d12
1000211e:	eeb8 cb46 	vcvt.f64.u32	d12, s12
10002122:	ee07 5b4e 	vmls.f64	d5, d7, d14
10002126:	ed9d ab1a 	vldr	d10, [sp, #104]	@ 0x68
1000212a:	ed8d cb12 	vstr	d12, [sp, #72]	@ 0x48
1000212e:	ed9d cb02 	vldr	d12, [sp, #8]
10002132:	ed8d db0e 	vstr	d13, [sp, #56]	@ 0x38
10002136:	ed9d db04 	vldr	d13, [sp, #16]
1000213a:	ee3a ab07 	vadd.f64	d10, d10, d7
1000213e:	ee25 5b08 	vmul.f64	d5, d5, d8
10002142:	ee2c 7b0f 	vmul.f64	d7, d12, d15
10002146:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000214a:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000214e:	eeb8 cb45 	vcvt.f64.u32	d12, s10
10002152:	ee2d 6b0f 	vmul.f64	d6, d13, d15
10002156:	ed8d cb14 	vstr	d12, [sp, #80]	@ 0x50
1000215a:	ed9d cb02 	vldr	d12, [sp, #8]
1000215e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10002162:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10002166:	ee30 5b07 	vadd.f64	d5, d0, d7
1000216a:	ee07 cb4e 	vmls.f64	d12, d7, d14
1000216e:	eeb8 7b46 	vcvt.f64.u32	d7, s12
10002172:	ee2c 6b08 	vmul.f64	d6, d12, d8
10002176:	ed9d 0b1c 	vldr	d0, [sp, #112]	@ 0x70
1000217a:	ee07 db4e 	vmls.f64	d13, d7, d14
1000217e:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10002182:	ee2d db08 	vmul.f64	d13, d13, d8
10002186:	ed9d 8b00 	vldr	d8, [sp]
1000218a:	ee30 cb07 	vadd.f64	d12, d0, d7
1000218e:	ee23 7b0f 	vmul.f64	d7, d3, d15
10002192:	eefc 6bcd 	vcvt.u32.f64	s13, d13
10002196:	eeb8 db46 	vcvt.f64.u32	d13, s12
1000219a:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000219e:	eeb8 0b66 	vcvt.f64.u32	d0, s13
100021a2:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100021a6:	ee39 6b08 	vadd.f64	d6, d9, d8
100021aa:	ee28 8b0f 	vmul.f64	d8, d8, d15
100021ae:	ee07 3b4e 	vmls.f64	d3, d7, d14
100021b2:	ed8d 8b4a 	vstr	d8, [sp, #296]	@ 0x128
100021b6:	ee36 8b07 	vadd.f64	d8, d6, d7
100021ba:	ee24 7b0f 	vmul.f64	d7, d4, d15
100021be:	ee22 6b0f 	vmul.f64	d6, d2, d15
100021c2:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100021c6:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100021ca:	ee07 4b4e 	vmls.f64	d4, d7, d14
100021ce:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100021d2:	eefc 7bc4 	vcvt.u32.f64	s15, d4
100021d6:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100021da:	ee17 2a90 	vmov	r2, s15
100021de:	ee06 2b4e 	vmls.f64	d2, d6, d14
100021e2:	0fd3      	lsrs	r3, r2, #31
100021e4:	eefc 7bc2 	vcvt.u32.f64	s15, d2
100021e8:	ee07 3a10 	vmov	s14, r3
100021ec:	0853      	lsrs	r3, r2, #1
100021ee:	ed8d 0b16 	vstr	d0, [sp, #88]	@ 0x58
100021f2:	ee00 3a10 	vmov	s0, r3
100021f6:	ee17 ca90 	vmov	ip, s15
100021fa:	eeb8 0bc0 	vcvt.f64.s32	d0, s0
100021fe:	ee29 9b0f 	vmul.f64	d9, d9, d15
10002202:	f002 0201 	and.w	r2, r2, #1
10002206:	ea4f 035c 	mov.w	r3, ip, lsr #1
1000220a:	ee07 2a90 	vmov	s15, r2
1000220e:	ed8d 9b54 	vstr	d9, [sp, #336]	@ 0x150
10002212:	eeb8 6be7 	vcvt.f64.s32	d6, s15
10002216:	ed9f 9bde 	vldr	d9, [pc, #888]	@ 10002590 <fndsa_vect_iFFT_fp64_exact+0x11e8>
1000221a:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
1000221e:	ee02 3a10 	vmov	s4, r3
10002222:	ee07 0b09 	vmla.f64	d0, d7, d9
10002226:	ea4f 73dc 	mov.w	r3, ip, lsr #31
1000222a:	ed8d 3b5c 	vstr	d3, [sp, #368]	@ 0x170
1000222e:	ee07 3a10 	vmov	s14, r3
10002232:	eeb8 2bc2 	vcvt.f64.s32	d2, s4
10002236:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
1000223a:	f00c 0301 	and.w	r3, ip, #1
1000223e:	ee07 2b09 	vmla.f64	d2, d7, d9
10002242:	ee07 3a90 	vmov	s15, r3
10002246:	eeb8 7be7 	vcvt.f64.s32	d7, s15
1000224a:	ee23 3b0f 	vmul.f64	d3, d3, d15
1000224e:	ee06 1b09 	vmla.f64	d1, d6, d9
10002252:	ed8d 3b60 	vstr	d3, [sp, #384]	@ 0x180
10002256:	ed9d 3b18 	vldr	d3, [sp, #96]	@ 0x60
1000225a:	ed9d 4b08 	vldr	d4, [sp, #32]
1000225e:	ee07 3b09 	vmla.f64	d3, d7, d9
10002262:	ee2b 7b0f 	vmul.f64	d7, d11, d15
10002266:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000226a:	ee24 6b0f 	vmul.f64	d6, d4, d15
1000226e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10002272:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10002276:	ee07 bb4e 	vmls.f64	d11, d7, d14
1000227a:	eefc 7bcb 	vcvt.u32.f64	s15, d11
1000227e:	ee17 2a90 	vmov	r2, s15
10002282:	eeb8 7b46 	vcvt.f64.u32	d7, s12
10002286:	eeb0 6b44 	vmov.f64	d6, d4
1000228a:	ee07 6b4e 	vmls.f64	d6, d7, d14
1000228e:	0fd3      	lsrs	r3, r2, #31
10002290:	eefc 7bc6 	vcvt.u32.f64	s15, d6
10002294:	ee06 3a10 	vmov	s12, r3
10002298:	0853      	lsrs	r3, r2, #1
1000229a:	ee04 3a10 	vmov	s8, r3
1000229e:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
100022a2:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
100022a6:	ee17 ea90 	vmov	lr, s15
100022aa:	ee06 4b09 	vmla.f64	d4, d6, d9
100022ae:	f002 0201 	and.w	r2, r2, #1
100022b2:	ea4f 73de 	mov.w	r3, lr, lsr #31
100022b6:	ea4f 0c5e 	mov.w	ip, lr, lsr #1
100022ba:	ee07 2a90 	vmov	s15, r2
100022be:	ed8d 4b18 	vstr	d4, [sp, #96]	@ 0x60
100022c2:	eeb8 7be7 	vcvt.f64.s32	d7, s15
100022c6:	ed9d 4b0a 	vldr	d4, [sp, #40]	@ 0x28
100022ca:	ee07 4b09 	vmla.f64	d4, d7, d9
100022ce:	ee06 3a10 	vmov	s12, r3
100022d2:	ee07 ca90 	vmov	s15, ip
100022d6:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
100022da:	eeb8 7be7 	vcvt.f64.s32	d7, s15
100022de:	f00e 0301 	and.w	r3, lr, #1
100022e2:	ee06 7b09 	vmla.f64	d7, d6, d9
100022e6:	ed8d 4b10 	vstr	d4, [sp, #64]	@ 0x40
100022ea:	ed8d 7b0c 	vstr	d7, [sp, #48]	@ 0x30
100022ee:	ee07 3a90 	vmov	s15, r3
100022f2:	ed9d 6b06 	vldr	d6, [sp, #24]
100022f6:	eeb8 7be7 	vcvt.f64.s32	d7, s15
100022fa:	ed9d bb0e 	vldr	d11, [sp, #56]	@ 0x38
100022fe:	eeb0 4b49 	vmov.f64	d4, d9
10002302:	ee07 bb09 	vmla.f64	d11, d7, d9
10002306:	ee26 7b0f 	vmul.f64	d7, d6, d15
1000230a:	ee2a 9b0f 	vmul.f64	d9, d10, d15
1000230e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10002312:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10002316:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000231a:	eeb8 9b49 	vcvt.f64.u32	d9, s18
1000231e:	ee07 6b4e 	vmls.f64	d6, d7, d14
10002322:	eefc 7bc6 	vcvt.u32.f64	s15, d6
10002326:	ee17 2a90 	vmov	r2, s15
1000232a:	ee09 ab4e 	vmls.f64	d10, d9, d14
1000232e:	0fd3      	lsrs	r3, r2, #31
10002330:	ee06 3a10 	vmov	s12, r3
10002334:	0853      	lsrs	r3, r2, #1
10002336:	eefc 7bca 	vcvt.u32.f64	s15, d10
1000233a:	ee07 3a10 	vmov	s14, r3
1000233e:	ee17 ea90 	vmov	lr, s15
10002342:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10002346:	f002 0201 	and.w	r2, r2, #1
1000234a:	eeb0 ab47 	vmov.f64	d10, d7
1000234e:	ee07 2a90 	vmov	s15, r2
10002352:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10002356:	eeb8 7be7 	vcvt.f64.s32	d7, s15
1000235a:	ed9d 9b12 	vldr	d9, [sp, #72]	@ 0x48
1000235e:	ea4f 73de 	mov.w	r3, lr, lsr #31
10002362:	ea4f 0c5e 	mov.w	ip, lr, lsr #1
10002366:	ee06 ab04 	vmla.f64	d10, d6, d4
1000236a:	ee07 9b04 	vmla.f64	d9, d7, d4
1000236e:	ee06 3a10 	vmov	s12, r3
10002372:	ee07 ca90 	vmov	s15, ip
10002376:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
1000237a:	eeb8 7be7 	vcvt.f64.s32	d7, s15
1000237e:	f00e 0301 	and.w	r3, lr, #1
10002382:	ee06 7b04 	vmla.f64	d7, d6, d4
10002386:	ed8d 7b04 	vstr	d7, [sp, #16]
1000238a:	ee07 3a90 	vmov	s15, r3
1000238e:	ed9d 6b14 	vldr	d6, [sp, #80]	@ 0x50
10002392:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10002396:	ee07 6b04 	vmla.f64	d6, d7, d4
1000239a:	ee25 7b0f 	vmul.f64	d7, d5, d15
1000239e:	ed8d 6b06 	vstr	d6, [sp, #24]
100023a2:	ee2c 6b0f 	vmul.f64	d6, d12, d15
100023a6:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100023aa:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100023ae:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100023b2:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100023b6:	ee07 5b4e 	vmls.f64	d5, d7, d14
100023ba:	eefc 7bc5 	vcvt.u32.f64	s15, d5
100023be:	ee17 3a90 	vmov	r3, s15
100023c2:	ee06 cb4e 	vmls.f64	d12, d6, d14
100023c6:	0fda      	lsrs	r2, r3, #31
100023c8:	ee07 2a10 	vmov	s14, r2
100023cc:	085a      	lsrs	r2, r3, #1
100023ce:	ed8d ab08 	vstr	d10, [sp, #32]
100023d2:	eefc 7bcc 	vcvt.u32.f64	s15, d12
100023d6:	ee0a 2a10 	vmov	s20, r2
100023da:	ee17 ea90 	vmov	lr, s15
100023de:	eeb8 abca 	vcvt.f64.s32	d10, s20
100023e2:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100023e6:	f003 0301 	and.w	r3, r3, #1
100023ea:	ee07 ab04 	vmla.f64	d10, d7, d4
100023ee:	ea4f 025e 	mov.w	r2, lr, lsr #1
100023f2:	ed8d 9b0a 	vstr	d9, [sp, #40]	@ 0x28
100023f6:	ea4f 7cde 	mov.w	ip, lr, lsr #31
100023fa:	ee07 3a90 	vmov	s15, r3
100023fe:	ee09 2a10 	vmov	s18, r2
10002402:	f00e 0201 	and.w	r2, lr, #1
10002406:	ee07 2a10 	vmov	s14, r2
1000240a:	eeb8 6be7 	vcvt.f64.s32	d6, s15
1000240e:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10002412:	ee06 db04 	vmla.f64	d13, d6, d4
10002416:	ed9d 5b16 	vldr	d5, [sp, #88]	@ 0x58
1000241a:	ee07 5b04 	vmla.f64	d5, d7, d4
1000241e:	ee28 7b0f 	vmul.f64	d7, d8, d15
10002422:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10002426:	ee07 ca90 	vmov	s15, ip
1000242a:	eeb8 6be7 	vcvt.f64.s32	d6, s15
1000242e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10002432:	ee07 8b4e 	vmls.f64	d8, d7, d14
10002436:	eebc 7bc8 	vcvt.u32.f64	s14, d8
1000243a:	ee17 3a10 	vmov	r3, s14
1000243e:	0fdb      	lsrs	r3, r3, #31
10002440:	ee07 3a10 	vmov	s14, r3
10002444:	ed8d 8b5a 	vstr	d8, [sp, #360]	@ 0x168
10002448:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
1000244c:	eeb8 9bc9 	vcvt.f64.s32	d9, s18
10002450:	ee28 8b0f 	vmul.f64	d8, d8, d15
10002454:	ed8d 5b00 	vstr	d5, [sp]
10002458:	ee06 9b04 	vmla.f64	d9, d6, d4
1000245c:	ed8d 7b62 	vstr	d7, [sp, #392]	@ 0x188
10002460:	ed8d bb0e 	vstr	d11, [sp, #56]	@ 0x38
10002464:	ed8d db02 	vstr	d13, [sp, #8]
10002468:	ed8d 8b5e 	vstr	d8, [sp, #376]	@ 0x178
1000246c:	f7fd ff7c 	bl	10000368 <fp64e_cmul_prepared>
10002470:	eeb0 bb40 	vmov.f64	d11, d0
10002474:	eeb0 8b43 	vmov.f64	d8, d3
10002478:	ed9d 3b00 	vldr	d3, [sp]
1000247c:	eeb0 db41 	vmov.f64	d13, d1
10002480:	ed9d 1b02 	vldr	d1, [sp, #8]
10002484:	eeb0 cb42 	vmov.f64	d12, d2
10002488:	ed8d bb1e 	vstr	d11, [sp, #120]	@ 0x78
1000248c:	eeb0 0b4a 	vmov.f64	d0, d10
10002490:	ed8d db20 	vstr	d13, [sp, #128]	@ 0x80
10002494:	eeb0 2b49 	vmov.f64	d2, d9
10002498:	ed8d cb22 	vstr	d12, [sp, #136]	@ 0x88
1000249c:	ed8d 8b24 	vstr	d8, [sp, #144]	@ 0x90
100024a0:	f7fd ff62 	bl	10000368 <fp64e_cmul_prepared>
100024a4:	ed9d 4b18 	vldr	d4, [sp, #96]	@ 0x60
100024a8:	ed9d 7b0e 	vldr	d7, [sp, #56]	@ 0x38
100024ac:	ed81 4b00 	vstr	d4, [r1]
100024b0:	ed9d 4b10 	vldr	d4, [sp, #64]	@ 0x40
100024b4:	ed9d 5b0c 	vldr	d5, [sp, #48]	@ 0x30
100024b8:	ed9d ab08 	vldr	d10, [sp, #32]
100024bc:	ed9d 9b0a 	vldr	d9, [sp, #40]	@ 0x28
100024c0:	ed81 4b02 	vstr	d4, [r1, #8]
100024c4:	ed9d 6b06 	vldr	d6, [sp, #24]
100024c8:	ed84 7b02 	vstr	d7, [r4, #8]
100024cc:	ed9d 7b04 	vldr	d7, [sp, #16]
100024d0:	ed84 5b00 	vstr	d5, [r4]
100024d4:	3140      	adds	r1, #64	@ 0x40
100024d6:	ed01 ab0c 	vstr	d10, [r1, #-48]	@ 0xffffffd0
100024da:	ed01 9b0a 	vstr	d9, [r1, #-40]	@ 0xffffffd8
100024de:	4588      	cmp	r8, r1
100024e0:	ed84 7b04 	vstr	d7, [r4, #16]
100024e4:	f106 0620 	add.w	r6, r6, #32
100024e8:	ed84 6b06 	vstr	d6, [r4, #24]
100024ec:	f104 0440 	add.w	r4, r4, #64	@ 0x40
100024f0:	ed8d 0b26 	vstr	d0, [sp, #152]	@ 0x98
100024f4:	f107 0710 	add.w	r7, r7, #16
100024f8:	ed01 bb08 	vstr	d11, [r1, #-32]	@ 0xffffffe0
100024fc:	ed01 db06 	vstr	d13, [r1, #-24]	@ 0xffffffe8
10002500:	ed04 cb08 	vstr	d12, [r4, #-32]	@ 0xffffffe0
10002504:	ed04 8b06 	vstr	d8, [r4, #-24]	@ 0xffffffe8
10002508:	ed01 0b04 	vstr	d0, [r1, #-16]
1000250c:	ed01 1b02 	vstr	d1, [r1, #-8]
10002510:	ed8d 1b28 	vstr	d1, [sp, #160]	@ 0xa0
10002514:	ed04 2b04 	vstr	d2, [r4, #-16]
10002518:	ed04 3b02 	vstr	d3, [r4, #-8]
1000251c:	ed8d 2b2a 	vstr	d2, [sp, #168]	@ 0xa8
10002520:	ed8d 3b2c 	vstr	d3, [sp, #176]	@ 0xb0
10002524:	f47e af62 	bne.w	100013ec <fndsa_vect_iFFT_fp64_exact+0x44>
10002528:	f04f 0e04 	mov.w	lr, #4
1000252c:	f1ab 0103 	sub.w	r1, fp, #3
10002530:	2900      	cmp	r1, #0
10002532:	f000 825b 	beq.w	100029ec <fndsa_vect_iFFT_fp64_exact+0x1644>
10002536:	2310      	movs	r3, #16
10002538:	ed9f eb17 	vldr	d14, [pc, #92]	@ 10002598 <fndsa_vect_iFFT_fp64_exact+0x11f0>
1000253c:	ed9f fb18 	vldr	d15, [pc, #96]	@ 100025a0 <fndsa_vect_iFFT_fp64_exact+0x11f8>
10002540:	ed9f 9b13 	vldr	d9, [pc, #76]	@ 10002590 <fndsa_vect_iFFT_fp64_exact+0x11e8>
10002544:	4e18      	ldr	r6, [pc, #96]	@ (100025a8 <fndsa_vect_iFFT_fp64_exact+0x1200>)
10002546:	fa03 fc0a 	lsl.w	ip, r3, sl
1000254a:	4672      	mov	r2, lr
1000254c:	2301      	movs	r3, #1
1000254e:	f04f 0810 	mov.w	r8, #16
10002552:	eb05 1702 	add.w	r7, r5, r2, lsl #4
10002556:	9208      	str	r2, [sp, #32]
10002558:	eeb7 db00 	vmov.f64	d13, #112	@ 0x3f800000  1.0
1000255c:	462a      	mov	r2, r5
1000255e:	f04f 0b00 	mov.w	fp, #0
10002562:	46e1      	mov	r9, ip
10002564:	408b      	lsls	r3, r1
10002566:	eb03 0353 	add.w	r3, r3, r3, lsr #1
1000256a:	eb06 1303 	add.w	r3, r6, r3, lsl #4
1000256e:	9306      	str	r3, [sp, #24]
10002570:	ea4f 0e4e 	mov.w	lr, lr, lsl #1
10002574:	910a      	str	r1, [sp, #40]	@ 0x28
10002576:	fa08 f801 	lsl.w	r8, r8, r1
1000257a:	f8cd e010 	str.w	lr, [sp, #16]
1000257e:	eb08 0a06 	add.w	sl, r8, r6
10002582:	960c      	str	r6, [sp, #48]	@ 0x30
10002584:	ea4f 180e 	mov.w	r8, lr, lsl #4
10002588:	950e      	str	r5, [sp, #56]	@ 0x38
1000258a:	e00f      	b.n	100025ac <fndsa_vect_iFFT_fp64_exact+0x1204>
1000258c:	f3af 8000 	nop.w
10002590:	00000000 	.word	0x00000000
10002594:	41e00000 	.word	0x41e00000
10002598:	00000000 	.word	0x00000000
1000259c:	41f00000 	.word	0x41f00000
100025a0:	00000000 	.word	0x00000000
100025a4:	3df00000 	.word	0x3df00000
100025a8:	300009a0 	.word	0x300009a0
100025ac:	edda 7a02 	vldr	s15, [sl, #8]
100025b0:	f8da 3004 	ldr.w	r3, [sl, #4]
100025b4:	eeb8 4b67 	vcvt.f64.u32	d4, s15
100025b8:	0fdb      	lsrs	r3, r3, #31
100025ba:	ee03 3a10 	vmov	s6, r3
100025be:	ee3e 4b44 	vsub.f64	d4, d14, d4
100025c2:	edda 7a03 	vldr	s15, [sl, #12]
100025c6:	eeb8 3bc3 	vcvt.f64.s32	d3, s6
100025ca:	eeb8 7b67 	vcvt.f64.u32	d7, s15
100025ce:	ed8d 3b4e 	vstr	d3, [sp, #312]	@ 0x138
100025d2:	ee24 3b0f 	vmul.f64	d3, d4, d15
100025d6:	edda 6a00 	vldr	s13, [sl]
100025da:	ee3e 7b47 	vsub.f64	d7, d14, d7
100025de:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100025e2:	eeb8 5b66 	vcvt.f64.u32	d5, s13
100025e6:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100025ea:	ee37 7b4d 	vsub.f64	d7, d7, d13
100025ee:	ee37 7b03 	vadd.f64	d7, d7, d3
100025f2:	ee03 4b4e 	vmls.f64	d4, d3, d14
100025f6:	edda 6a01 	vldr	s13, [sl, #4]
100025fa:	ed8d 5b48 	vstr	d5, [sp, #288]	@ 0x120
100025fe:	eeb8 6b66 	vcvt.f64.u32	d6, s13
10002602:	ee27 3b0f 	vmul.f64	d3, d7, d15
10002606:	ee26 2b0f 	vmul.f64	d2, d6, d15
1000260a:	ee25 1b0f 	vmul.f64	d1, d5, d15
1000260e:	ed8d 2b4a 	vstr	d2, [sp, #296]	@ 0x128
10002612:	ed8d 4b52 	vstr	d4, [sp, #328]	@ 0x148
10002616:	ed8d 6b46 	vstr	d6, [sp, #280]	@ 0x118
1000261a:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000261e:	ee34 5b05 	vadd.f64	d5, d4, d5
10002622:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10002626:	ee24 2b0f 	vmul.f64	d2, d4, d15
1000262a:	ee25 4b0f 	vmul.f64	d4, d5, d15
1000262e:	ee03 7b4e 	vmls.f64	d7, d3, d14
10002632:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10002636:	eefc 3bc7 	vcvt.u32.f64	s7, d7
1000263a:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000263e:	ee37 6b06 	vadd.f64	d6, d7, d6
10002642:	ed8d 7b50 	vstr	d7, [sp, #320]	@ 0x140
10002646:	ee13 1a90 	vmov	r1, s7
1000264a:	ee27 3b0f 	vmul.f64	d3, d7, d15
1000264e:	ee36 7b04 	vadd.f64	d7, d6, d4
10002652:	ee27 6b0f 	vmul.f64	d6, d7, d15
10002656:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000265a:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000265e:	ee06 7b4e 	vmls.f64	d7, d6, d14
10002662:	eefc 6bc7 	vcvt.u32.f64	s13, d7
10002666:	0fc9      	lsrs	r1, r1, #31
10002668:	ee04 5b4e 	vmls.f64	d5, d4, d14
1000266c:	ee04 1a10 	vmov	s8, r1
10002670:	ee16 1a90 	vmov	r1, s13
10002674:	0fc9      	lsrs	r1, r1, #31
10002676:	ee27 6b0f 	vmul.f64	d6, d7, d15
1000267a:	ed8d 7b5a 	vstr	d7, [sp, #360]	@ 0x168
1000267e:	ed8d 2b56 	vstr	d2, [sp, #344]	@ 0x158
10002682:	9b08      	ldr	r3, [sp, #32]
10002684:	ed8d 1b4c 	vstr	d1, [sp, #304]	@ 0x130
10002688:	ee07 1a10 	vmov	s14, r1
1000268c:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
10002690:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10002694:	ee25 2b0f 	vmul.f64	d2, d5, d15
10002698:	445b      	add	r3, fp
1000269a:	459b      	cmp	fp, r3
1000269c:	ed8d 3b54 	vstr	d3, [sp, #336]	@ 0x150
100026a0:	ed8d 5b5c 	vstr	d5, [sp, #368]	@ 0x170
100026a4:	ed8d 4b58 	vstr	d4, [sp, #352]	@ 0x160
100026a8:	ed8d 2b60 	vstr	d2, [sp, #384]	@ 0x180
100026ac:	ed8d 6b5e 	vstr	d6, [sp, #376]	@ 0x178
100026b0:	ed8d 7b62 	vstr	d7, [sp, #392]	@ 0x188
100026b4:	f080 8187 	bcs.w	100029c6 <fndsa_vect_iFFT_fp64_exact+0x161e>
100026b8:	463e      	mov	r6, r7
100026ba:	4611      	mov	r1, r2
100026bc:	eb09 0502 	add.w	r5, r9, r2
100026c0:	eb09 0407 	add.w	r4, r9, r7
100026c4:	9202      	str	r2, [sp, #8]
100026c6:	ed91 ab02 	vldr	d10, [r1, #8]
100026ca:	ee3a 0b0e 	vadd.f64	d0, d10, d14
100026ce:	ed96 7b02 	vldr	d7, [r6, #8]
100026d2:	ed91 cb00 	vldr	d12, [r1]
100026d6:	ed96 3b00 	vldr	d3, [r6]
100026da:	ed95 bb02 	vldr	d11, [r5, #8]
100026de:	ed94 5b02 	vldr	d5, [r4, #8]
100026e2:	ee37 ab0a 	vadd.f64	d10, d7, d10
100026e6:	ee30 7b47 	vsub.f64	d7, d0, d7
100026ea:	ee3c 1b0e 	vadd.f64	d1, d12, d14
100026ee:	ee27 2b0f 	vmul.f64	d2, d7, d15
100026f2:	ee33 cb0c 	vadd.f64	d12, d3, d12
100026f6:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100026fa:	ee31 3b43 	vsub.f64	d3, d1, d3
100026fe:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10002702:	ee33 3b4d 	vsub.f64	d3, d3, d13
10002706:	ee02 7b4e 	vmls.f64	d7, d2, d14
1000270a:	ee33 3b02 	vadd.f64	d3, d3, d2
1000270e:	ee37 7b0d 	vadd.f64	d7, d7, d13
10002712:	ee23 1b0f 	vmul.f64	d1, d3, d15
10002716:	ee27 2b0f 	vmul.f64	d2, d7, d15
1000271a:	eebc 1bc1 	vcvt.u32.f64	s2, d1
1000271e:	eefc 0bc2 	vcvt.u32.f64	s1, d2
10002722:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10002726:	ee01 3b4e 	vmls.f64	d3, d1, d14
1000272a:	ed9f 4bb5 	vldr	d4, [pc, #724]	@ 10002a00 <fndsa_vect_iFFT_fp64_exact+0x1658>
1000272e:	ed94 8b00 	vldr	d8, [r4]
10002732:	ed95 6b00 	vldr	d6, [r5]
10002736:	ee3b 2b0e 	vadd.f64	d2, d11, d14
1000273a:	ee3b bb05 	vadd.f64	d11, d11, d5
1000273e:	ee32 2b45 	vsub.f64	d2, d2, d5
10002742:	eeb8 5b60 	vcvt.f64.u32	d5, s1
10002746:	ee33 3b04 	vadd.f64	d3, d3, d4
1000274a:	ee33 3b05 	vadd.f64	d3, d3, d5
1000274e:	ee36 4b0e 	vadd.f64	d4, d6, d14
10002752:	ee23 0b0f 	vmul.f64	d0, d3, d15
10002756:	ee36 6b08 	vadd.f64	d6, d6, d8
1000275a:	ee05 7b4e 	vmls.f64	d7, d5, d14
1000275e:	ee22 5b0f 	vmul.f64	d5, d2, d15
10002762:	ed8d 6b00 	vstr	d6, [sp]
10002766:	eebc 0bc0 	vcvt.u32.f64	s0, d0
1000276a:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000276e:	eeb6 6b00 	vmov.f64	d6, #96	@ 0x3f000000  0.5
10002772:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10002776:	eeb8 0b40 	vcvt.f64.u32	d0, s0
1000277a:	ee05 2b4e 	vmls.f64	d2, d5, d14
1000277e:	ee27 7b06 	vmul.f64	d7, d7, d6
10002782:	ee34 6b48 	vsub.f64	d6, d4, d8
10002786:	ee00 3b4e 	vmls.f64	d3, d0, d14
1000278a:	ee36 6b4d 	vsub.f64	d6, d6, d13
1000278e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10002792:	ee36 6b05 	vadd.f64	d6, d6, d5
10002796:	eefc 5bc3 	vcvt.u32.f64	s11, d3
1000279a:	eeb8 1b47 	vcvt.f64.u32	d1, s14
1000279e:	ee15 3a90 	vmov	r3, s11
100027a2:	ee32 2b0d 	vadd.f64	d2, d2, d13
100027a6:	ee22 7b0f 	vmul.f64	d7, d2, d15
100027aa:	0fda      	lsrs	r2, r3, #31
100027ac:	eefc 3bc7 	vcvt.u32.f64	s7, d7
100027b0:	ee07 2a10 	vmov	s14, r2
100027b4:	085a      	lsrs	r2, r3, #1
100027b6:	ee00 2a10 	vmov	s0, r2
100027ba:	ee26 4b0f 	vmul.f64	d4, d6, d15
100027be:	f003 0301 	and.w	r3, r3, #1
100027c2:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100027c6:	eeb8 0bc0 	vcvt.f64.s32	d0, s0
100027ca:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100027ce:	ee07 0b09 	vmla.f64	d0, d7, d9
100027d2:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100027d6:	ee07 3a90 	vmov	s15, r3
100027da:	ee04 6b4e 	vmls.f64	d6, d4, d14
100027de:	eeb8 7be7 	vcvt.f64.s32	d7, s15
100027e2:	eeb8 4b63 	vcvt.f64.u32	d4, s7
100027e6:	ee07 1b09 	vmla.f64	d1, d7, d9
100027ea:	ed9f 7b85 	vldr	d7, [pc, #532]	@ 10002a00 <fndsa_vect_iFFT_fp64_exact+0x1658>
100027ee:	ee36 6b07 	vadd.f64	d6, d6, d7
100027f2:	ee2a 5b0f 	vmul.f64	d5, d10, d15
100027f6:	ee36 7b04 	vadd.f64	d7, d6, d4
100027fa:	ee04 2b4e 	vmls.f64	d2, d4, d14
100027fe:	ee27 4b0f 	vmul.f64	d4, d7, d15
10002802:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10002806:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000280a:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000280e:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10002812:	eeb6 6b00 	vmov.f64	d6, #96	@ 0x3f000000  0.5
10002816:	ee04 7b4e 	vmls.f64	d7, d4, d14
1000281a:	ee22 2b06 	vmul.f64	d2, d2, d6
1000281e:	ee3c 6b05 	vadd.f64	d6, d12, d5
10002822:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10002826:	ee26 8b0f 	vmul.f64	d8, d6, d15
1000282a:	ee05 ab4e 	vmls.f64	d10, d5, d14
1000282e:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10002832:	eeb8 3b42 	vcvt.f64.u32	d3, s4
10002836:	ee3a 5b0d 	vadd.f64	d5, d10, d13
1000283a:	eebc 2bc8 	vcvt.u32.f64	s4, d8
1000283e:	ee17 3a90 	vmov	r3, s15
10002842:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10002846:	ee25 4b0f 	vmul.f64	d4, d5, d15
1000284a:	0fda      	lsrs	r2, r3, #31
1000284c:	ee08 2a10 	vmov	s16, r2
10002850:	085a      	lsrs	r2, r3, #1
10002852:	ee02 6b4e 	vmls.f64	d6, d2, d14
10002856:	ed9f 7b6a 	vldr	d7, [pc, #424]	@ 10002a00 <fndsa_vect_iFFT_fp64_exact+0x1658>
1000285a:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000285e:	ee36 6b07 	vadd.f64	d6, d6, d7
10002862:	ee02 2a10 	vmov	s4, r2
10002866:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000286a:	eeb8 8bc8 	vcvt.f64.s32	d8, s16
1000286e:	eeb8 2bc2 	vcvt.f64.s32	d2, s4
10002872:	eeb6 ab00 	vmov.f64	d10, #96	@ 0x3f000000  0.5
10002876:	ee08 2b09 	vmla.f64	d2, d8, d9
1000287a:	ee2b 8b0f 	vmul.f64	d8, d11, d15
1000287e:	ee36 6b04 	vadd.f64	d6, d6, d4
10002882:	ee04 5b4e 	vmls.f64	d5, d4, d14
10002886:	ee25 5b0a 	vmul.f64	d5, d5, d10
1000288a:	f003 0301 	and.w	r3, r3, #1
1000288e:	ee07 3a90 	vmov	s15, r3
10002892:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10002896:	ee26 4b0f 	vmul.f64	d4, d6, d15
1000289a:	eeb8 8b48 	vcvt.f64.u32	d8, s16
1000289e:	eebc abc5 	vcvt.u32.f64	s20, d5
100028a2:	eeb8 7be7 	vcvt.f64.s32	d7, s15
100028a6:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100028aa:	ee07 3b09 	vmla.f64	d3, d7, d9
100028ae:	ed9d 5b00 	vldr	d5, [sp]
100028b2:	ee35 7b08 	vadd.f64	d7, d5, d8
100028b6:	eeb0 5b4b 	vmov.f64	d5, d11
100028ba:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100028be:	ee08 5b4e 	vmls.f64	d5, d8, d14
100028c2:	ee27 cb0f 	vmul.f64	d12, d7, d15
100028c6:	ee04 6b4e 	vmls.f64	d6, d4, d14
100028ca:	ee35 5b0d 	vadd.f64	d5, d5, d13
100028ce:	eebc cbcc 	vcvt.u32.f64	s24, d12
100028d2:	eefc 6bc6 	vcvt.u32.f64	s13, d6
100028d6:	ee25 4b0f 	vmul.f64	d4, d5, d15
100028da:	eeb8 cb4c 	vcvt.f64.u32	d12, s24
100028de:	ee16 3a90 	vmov	r3, s13
100028e2:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100028e6:	ed9f 6b46 	vldr	d6, [pc, #280]	@ 10002a00 <fndsa_vect_iFFT_fp64_exact+0x1658>
100028ea:	ee0c 7b4e 	vmls.f64	d7, d12, d14
100028ee:	0fda      	lsrs	r2, r3, #31
100028f0:	eeb8 bb4a 	vcvt.f64.u32	d11, s20
100028f4:	ee0a 2a10 	vmov	s20, r2
100028f8:	085a      	lsrs	r2, r3, #1
100028fa:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100028fe:	ee37 7b06 	vadd.f64	d7, d7, d6
10002902:	f003 0301 	and.w	r3, r3, #1
10002906:	ee06 3a90 	vmov	s13, r3
1000290a:	ee37 7b04 	vadd.f64	d7, d7, d4
1000290e:	eeb8 6be6 	vcvt.f64.s32	d6, s13
10002912:	ee08 2a10 	vmov	s16, r2
10002916:	ee06 bb09 	vmla.f64	d11, d6, d9
1000291a:	ee27 6b0f 	vmul.f64	d6, d7, d15
1000291e:	eeb8 abca 	vcvt.f64.s32	d10, s20
10002922:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10002926:	eeb8 8bc8 	vcvt.f64.s32	d8, s16
1000292a:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000292e:	ee04 5b4e 	vmls.f64	d5, d4, d14
10002932:	ee06 7b4e 	vmls.f64	d7, d6, d14
10002936:	ee0a 8b09 	vmla.f64	d8, d10, d9
1000293a:	eefc 7bc7 	vcvt.u32.f64	s15, d7
1000293e:	eeb6 ab00 	vmov.f64	d10, #96	@ 0x3f000000  0.5
10002942:	ee17 3a90 	vmov	r3, s15
10002946:	ee25 5b0a 	vmul.f64	d5, d5, d10
1000294a:	0fda      	lsrs	r2, r3, #31
1000294c:	ee04 2a10 	vmov	s8, r2
10002950:	085a      	lsrs	r2, r3, #1
10002952:	f003 0301 	and.w	r3, r3, #1
10002956:	ee06 2a10 	vmov	s12, r2
1000295a:	ee07 3a90 	vmov	s15, r3
1000295e:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10002962:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
10002966:	eeb8 7be7 	vcvt.f64.s32	d7, s15
1000296a:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000296e:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10002972:	ee07 5b09 	vmla.f64	d5, d7, d9
10002976:	ed81 8b00 	vstr	d8, [r1]
1000297a:	ed81 bb02 	vstr	d11, [r1, #8]
1000297e:	ee04 6b09 	vmla.f64	d6, d4, d9
10002982:	a846      	add	r0, sp, #280	@ 0x118
10002984:	ed85 6b00 	vstr	d6, [r5]
10002988:	ed85 5b02 	vstr	d5, [r5, #8]
1000298c:	f7fd fcec 	bl	10000368 <fp64e_cmul_prepared>
10002990:	3110      	adds	r1, #16
10002992:	428f      	cmp	r7, r1
10002994:	ed86 0b00 	vstr	d0, [r6]
10002998:	f105 0510 	add.w	r5, r5, #16
1000299c:	ed86 1b02 	vstr	d1, [r6, #8]
100029a0:	f106 0610 	add.w	r6, r6, #16
100029a4:	ed8d 0b3e 	vstr	d0, [sp, #248]	@ 0xf8
100029a8:	ed84 2b00 	vstr	d2, [r4]
100029ac:	ed84 3b02 	vstr	d3, [r4, #8]
100029b0:	f104 0410 	add.w	r4, r4, #16
100029b4:	ed8d 1b40 	vstr	d1, [sp, #256]	@ 0x100
100029b8:	ed8d 2b42 	vstr	d2, [sp, #264]	@ 0x108
100029bc:	ed8d 3b44 	vstr	d3, [sp, #272]	@ 0x110
100029c0:	f47f ae81 	bne.w	100026c6 <fndsa_vect_iFFT_fp64_exact+0x131e>
100029c4:	9a02      	ldr	r2, [sp, #8]
100029c6:	9b04      	ldr	r3, [sp, #16]
100029c8:	f10a 0a10 	add.w	sl, sl, #16
100029cc:	449b      	add	fp, r3
100029ce:	9b06      	ldr	r3, [sp, #24]
100029d0:	4442      	add	r2, r8
100029d2:	4553      	cmp	r3, sl
100029d4:	4447      	add	r7, r8
100029d6:	f47f ade9 	bne.w	100025ac <fndsa_vect_iFFT_fp64_exact+0x1204>
100029da:	990a      	ldr	r1, [sp, #40]	@ 0x28
100029dc:	46cc      	mov	ip, r9
100029de:	3901      	subs	r1, #1
100029e0:	f8dd e010 	ldr.w	lr, [sp, #16]
100029e4:	9e0c      	ldr	r6, [sp, #48]	@ 0x30
100029e6:	9d0e      	ldr	r5, [sp, #56]	@ 0x38
100029e8:	f47f adaf 	bne.w	1000254a <fndsa_vect_iFFT_fp64_exact+0x11a2>
100029ec:	b065      	add	sp, #404	@ 0x194
100029ee:	ecbd 8b10 	vpop	{d8-d15}
100029f2:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
100029f6:	4651      	mov	r1, sl
100029f8:	f04f 0e01 	mov.w	lr, #1
100029fc:	e598      	b.n	10002530 <fndsa_vect_iFFT_fp64_exact+0x1188>
100029fe:	bf00      	nop
	...

