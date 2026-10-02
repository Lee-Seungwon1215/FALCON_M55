10001430 <fndsa_vect_FFT_fp64_exact.constprop.0>:
10001430:	2801      	cmp	r0, #1
10001432:	f240 818c 	bls.w	1000174e <fndsa_vect_FFT_fp64_exact.constprop.0+0x31e>
10001436:	2101      	movs	r1, #1
10001438:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
1000143c:	1e43      	subs	r3, r0, #1
1000143e:	ed2d 8b10 	vpush	{d8-d15}
10001442:	f04f 0b10 	mov.w	fp, #16
10001446:	fa01 f603 	lsl.w	r6, r1, r3
1000144a:	ed9f fbc1 	vldr	d15, [pc, #772]	@ 10001750 <fndsa_vect_FFT_fp64_exact.constprop.0+0x320>
1000144e:	ed9f ebc2 	vldr	d14, [pc, #776]	@ 10001758 <fndsa_vect_FFT_fp64_exact.constprop.0+0x328>
10001452:	ed9f dbc3 	vldr	d13, [pc, #780]	@ 10001760 <fndsa_vect_FFT_fp64_exact.constprop.0+0x330>
10001456:	460c      	mov	r4, r1
10001458:	4635      	mov	r5, r6
1000145a:	b0ad      	sub	sp, #180	@ 0xb4
1000145c:	fa0b f303 	lsl.w	r3, fp, r3
10001460:	9302      	str	r3, [sp, #8]
10001462:	9604      	str	r6, [sp, #16]
10001464:	9005      	str	r0, [sp, #20]
10001466:	f04f 0a01 	mov.w	sl, #1
1000146a:	2310      	movs	r3, #16
1000146c:	462f      	mov	r7, r5
1000146e:	40a3      	lsls	r3, r4
10001470:	fa25 f50a 	lsr.w	r5, r5, sl
10001474:	9403      	str	r4, [sp, #12]
10001476:	fa0a fa04 	lsl.w	sl, sl, r4
1000147a:	eeb7 cb00 	vmov.f64	d12, #112	@ 0x3f800000  1.0
1000147e:	2400      	movs	r4, #0
10001480:	4ac1      	ldr	r2, [pc, #772]	@ (10001788 <fndsa_vect_FFT_fp64_exact.constprop.0+0x358>)
10001482:	eb0a 0a5a 	add.w	sl, sl, sl, lsr #1
10001486:	eb02 1905 	add.w	r9, r2, r5, lsl #4
1000148a:	9a04      	ldr	r2, [sp, #16]
1000148c:	1b52      	subs	r2, r2, r5
1000148e:	9201      	str	r2, [sp, #4]
10001490:	4abe      	ldr	r2, [pc, #760]	@ (1000178c <fndsa_vect_FFT_fp64_exact.constprop.0+0x35c>)
10001492:	eb02 0b03 	add.w	fp, r2, r3
10001496:	eb02 130a 	add.w	r3, r2, sl, lsl #4
1000149a:	9300      	str	r3, [sp, #0]
1000149c:	eddb 7a00 	vldr	s15, [fp]
100014a0:	eeb8 1b67 	vcvt.f64.u32	d1, s15
100014a4:	eddb 7a02 	vldr	s15, [fp, #8]
100014a8:	eeb8 3b67 	vcvt.f64.u32	d3, s15
100014ac:	eddb 7a01 	vldr	s15, [fp, #4]
100014b0:	eeb8 6b67 	vcvt.f64.u32	d6, s15
100014b4:	eddb 7a03 	vldr	s15, [fp, #12]
100014b8:	f8db 3004 	ldr.w	r3, [fp, #4]
100014bc:	ee21 4b0f 	vmul.f64	d4, d1, d15
100014c0:	0fdb      	lsrs	r3, r3, #31
100014c2:	ee05 3a10 	vmov	s10, r3
100014c6:	ee17 3a90 	vmov	r3, s15
100014ca:	0fdb      	lsrs	r3, r3, #31
100014cc:	ed9f 9ba6 	vldr	d9, [pc, #664]	@ 10001768 <fndsa_vect_FFT_fp64_exact.constprop.0+0x338>
100014d0:	ee07 3a10 	vmov	s14, r3
100014d4:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100014d8:	eeb8 2b67 	vcvt.f64.u32	d2, s15
100014dc:	ee26 0b09 	vmul.f64	d0, d6, d9
100014e0:	ed9f aba3 	vldr	d10, [pc, #652]	@ 10001770 <fndsa_vect_FFT_fp64_exact.constprop.0+0x340>
100014e4:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100014e8:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100014ec:	ed8d 7b20 	vstr	d7, [sp, #128]	@ 0x80
100014f0:	ed8d 1b14 	vstr	d1, [sp, #80]	@ 0x50
100014f4:	ee31 7b03 	vadd.f64	d7, d1, d3
100014f8:	eebc 0bc0 	vcvt.u32.f64	s0, d0
100014fc:	ee04 1b4a 	vmls.f64	d1, d4, d10
10001500:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10001504:	ed9f bb9c 	vldr	d11, [pc, #624]	@ 10001778 <fndsa_vect_FFT_fp64_exact.constprop.0+0x348>
10001508:	ed8d 1b0e 	vstr	d1, [sp, #56]	@ 0x38
1000150c:	eeb0 1b46 	vmov.f64	d1, d6
10001510:	ed8d 0b12 	vstr	d0, [sp, #72]	@ 0x48
10001514:	ee00 1b4b 	vmls.f64	d1, d0, d11
10001518:	ed9f 0b99 	vldr	d0, [pc, #612]	@ 10001780 <fndsa_vect_FFT_fp64_exact.constprop.0+0x350>
1000151c:	ee22 8b09 	vmul.f64	d8, d2, d9
10001520:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
10001524:	ee01 4b00 	vmla.f64	d4, d1, d0
10001528:	ed8d 5b16 	vstr	d5, [sp, #88]	@ 0x58
1000152c:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10001530:	ee23 5b0f 	vmul.f64	d5, d3, d15
10001534:	ed8d 4b10 	vstr	d4, [sp, #64]	@ 0x40
10001538:	ee27 4b0e 	vmul.f64	d4, d7, d14
1000153c:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10001540:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10001544:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10001548:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000154c:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10001550:	ee36 6b02 	vadd.f64	d6, d6, d2
10001554:	ee08 2b4b 	vmls.f64	d2, d8, d11
10001558:	ee36 6b04 	vadd.f64	d6, d6, d4
1000155c:	ed8d 3b1e 	vstr	d3, [sp, #120]	@ 0x78
10001560:	ee05 3b4a 	vmls.f64	d3, d5, d10
10001564:	ee02 5b00 	vmla.f64	d5, d2, d0
10001568:	ed8d 5b1a 	vstr	d5, [sp, #104]	@ 0x68
1000156c:	ee26 5b0e 	vmul.f64	d5, d6, d14
10001570:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10001574:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10001578:	ee05 6b4d 	vmls.f64	d6, d5, d13
1000157c:	ee04 7b4d 	vmls.f64	d7, d4, d13
10001580:	ee26 5b09 	vmul.f64	d5, d6, d9
10001584:	eebc 4bc6 	vcvt.u32.f64	s8, d6
10001588:	ed8d 3b18 	vstr	d3, [sp, #96]	@ 0x60
1000158c:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10001590:	eeb0 3b47 	vmov.f64	d3, d7
10001594:	ee27 7b0f 	vmul.f64	d7, d7, d15
10001598:	ee14 2a10 	vmov	r2, s8
1000159c:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100015a0:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100015a4:	0fd2      	lsrs	r2, r2, #31
100015a6:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100015aa:	ee04 2a10 	vmov	s8, r2
100015ae:	ee05 6b4b 	vmls.f64	d6, d5, d11
100015b2:	ed8d 3b28 	vstr	d3, [sp, #160]	@ 0xa0
100015b6:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
100015ba:	ee07 3b4a 	vmls.f64	d3, d7, d10
100015be:	ee06 7b00 	vmla.f64	d7, d6, d0
100015c2:	192b      	adds	r3, r5, r4
100015c4:	429c      	cmp	r4, r3
100015c6:	ed8d 8b1c 	vstr	d8, [sp, #112]	@ 0x70
100015ca:	ed8d 3b22 	vstr	d3, [sp, #136]	@ 0x88
100015ce:	ed8d 4b2a 	vstr	d4, [sp, #168]	@ 0xa8
100015d2:	ed8d 5b26 	vstr	d5, [sp, #152]	@ 0x98
100015d6:	ed8d 7b24 	vstr	d7, [sp, #144]	@ 0x90
100015da:	f080 80a4 	bcs.w	10001726 <fndsa_vect_FFT_fp64_exact.constprop.0+0x2f6>
100015de:	46c8      	mov	r8, r9
100015e0:	4b69      	ldr	r3, [pc, #420]	@ (10001788 <fndsa_vect_FFT_fp64_exact.constprop.0+0x358>)
100015e2:	eb03 1604 	add.w	r6, r3, r4, lsl #4
100015e6:	9b01      	ldr	r3, [sp, #4]
100015e8:	eb09 1103 	add.w	r1, r9, r3, lsl #4
100015ec:	9b02      	ldr	r3, [sp, #8]
100015ee:	eb03 0a09 	add.w	sl, r3, r9
100015f2:	ed98 0b00 	vldr	d0, [r8]
100015f6:	ed98 1b02 	vldr	d1, [r8, #8]
100015fa:	ed9a 2b00 	vldr	d2, [sl]
100015fe:	ed9a 3b02 	vldr	d3, [sl, #8]
10001602:	a80e      	add	r0, sp, #56	@ 0x38
10001604:	f7ff f9d0 	bl	100009a8 <fp64e_cmul_prepared>
10001608:	ed96 9b02 	vldr	d9, [r6, #8]
1000160c:	ee39 7b0d 	vadd.f64	d7, d9, d13
10001610:	ee39 9b01 	vadd.f64	d9, d9, d1
10001614:	ed91 ab02 	vldr	d10, [r1, #8]
10001618:	ee29 5b0e 	vmul.f64	d5, d9, d14
1000161c:	ed96 8b00 	vldr	d8, [r6]
10001620:	ee3a 6b0d 	vadd.f64	d6, d10, d13
10001624:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10001628:	ee3a ab03 	vadd.f64	d10, d10, d3
1000162c:	ee36 6b43 	vsub.f64	d6, d6, d3
10001630:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10001634:	ed8d 3b0c 	vstr	d3, [sp, #48]	@ 0x30
10001638:	ee38 3b0d 	vadd.f64	d3, d8, d13
1000163c:	ee38 8b00 	vadd.f64	d8, d8, d0
10001640:	ed91 bb00 	vldr	d11, [r1]
10001644:	ee2a 4b0e 	vmul.f64	d4, d10, d14
10001648:	ee05 9b4d 	vmls.f64	d9, d5, d13
1000164c:	ee38 8b05 	vadd.f64	d8, d8, d5
10001650:	ee26 5b0e 	vmul.f64	d5, d6, d14
10001654:	ee33 3b40 	vsub.f64	d3, d3, d0
10001658:	ed8d 0b06 	vstr	d0, [sp, #24]
1000165c:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10001660:	eefc 0bc5 	vcvt.u32.f64	s1, d5
10001664:	ee3b 5b0d 	vadd.f64	d5, d11, d13
10001668:	ed86 9b02 	vstr	d9, [r6, #8]
1000166c:	ee37 7b41 	vsub.f64	d7, d7, d1
10001670:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10001674:	eeb0 9b4a 	vmov.f64	d9, d10
10001678:	ee35 5b42 	vsub.f64	d5, d5, d2
1000167c:	ed8d 1b08 	vstr	d1, [sp, #32]
10001680:	ee3b 1b02 	vadd.f64	d1, d11, d2
10001684:	ee27 ab0e 	vmul.f64	d10, d7, d14
10001688:	ee31 1b04 	vadd.f64	d1, d1, d4
1000168c:	ee04 9b4d 	vmls.f64	d9, d4, d13
10001690:	ee35 5b4c 	vsub.f64	d5, d5, d12
10001694:	eeb8 4b60 	vcvt.f64.u32	d4, s1
10001698:	eebc abca 	vcvt.u32.f64	s20, d10
1000169c:	ee35 5b04 	vadd.f64	d5, d5, d4
100016a0:	ee04 6b4d 	vmls.f64	d6, d4, d13
100016a4:	ee21 4b0e 	vmul.f64	d4, d1, d14
100016a8:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
100016ac:	ee33 3b4c 	vsub.f64	d3, d3, d12
100016b0:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100016b4:	ee33 3b0a 	vadd.f64	d3, d3, d10
100016b8:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100016bc:	ee04 1b4d 	vmls.f64	d1, d4, d13
100016c0:	ee23 4b0e 	vmul.f64	d4, d3, d14
100016c4:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100016c8:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100016cc:	ed8d 2b0a 	vstr	d2, [sp, #40]	@ 0x28
100016d0:	ee04 3b4d 	vmls.f64	d3, d4, d13
100016d4:	ee25 2b0e 	vmul.f64	d2, d5, d14
100016d8:	ee28 4b0e 	vmul.f64	d4, d8, d14
100016dc:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100016e0:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100016e4:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100016e8:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100016ec:	ee0a 7b4d 	vmls.f64	d7, d10, d13
100016f0:	ee02 5b4d 	vmls.f64	d5, d2, d13
100016f4:	ee04 8b4d 	vmls.f64	d8, d4, d13
100016f8:	3610      	adds	r6, #16
100016fa:	3110      	adds	r1, #16
100016fc:	f108 0810 	add.w	r8, r8, #16
10001700:	f10a 0a10 	add.w	sl, sl, #16
10001704:	45b1      	cmp	r9, r6
10001706:	ed06 8b04 	vstr	d8, [r6, #-16]
1000170a:	ed01 1b04 	vstr	d1, [r1, #-16]
1000170e:	ed01 9b02 	vstr	d9, [r1, #-8]
10001712:	ed08 3b04 	vstr	d3, [r8, #-16]
10001716:	ed08 7b02 	vstr	d7, [r8, #-8]
1000171a:	ed0a 5b04 	vstr	d5, [sl, #-16]
1000171e:	ed0a 6b02 	vstr	d6, [sl, #-8]
10001722:	f47f af66 	bne.w	100015f2 <fndsa_vect_FFT_fp64_exact.constprop.0+0x1c2>
10001726:	9b00      	ldr	r3, [sp, #0]
10001728:	f10b 0b10 	add.w	fp, fp, #16
1000172c:	455b      	cmp	r3, fp
1000172e:	443c      	add	r4, r7
10001730:	eb09 1907 	add.w	r9, r9, r7, lsl #4
10001734:	f47f aeb2 	bne.w	1000149c <fndsa_vect_FFT_fp64_exact.constprop.0+0x6c>
10001738:	9c03      	ldr	r4, [sp, #12]
1000173a:	9b05      	ldr	r3, [sp, #20]
1000173c:	3401      	adds	r4, #1
1000173e:	42a3      	cmp	r3, r4
10001740:	f47f ae91 	bne.w	10001466 <fndsa_vect_FFT_fp64_exact.constprop.0+0x36>
10001744:	b02d      	add	sp, #180	@ 0xb4
10001746:	ecbd 8b10 	vpop	{d8-d15}
1000174a:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
1000174e:	4770      	bx	lr
10001750:	00000000 	.word	0x00000000
10001754:	3e700000 	.word	0x3e700000
10001758:	00000000 	.word	0x00000000
1000175c:	3df00000 	.word	0x3df00000
10001760:	00000000 	.word	0x00000000
10001764:	41f00000 	.word	0x41f00000
10001768:	00000000 	.word	0x00000000
1000176c:	3ef00000 	.word	0x3ef00000
10001770:	00000000 	.word	0x00000000
10001774:	41700000 	.word	0x41700000
10001778:	00000000 	.word	0x00000000
1000177c:	40f00000 	.word	0x40f00000
10001780:	00000000 	.word	0x00000000
10001784:	40700000 	.word	0x40700000
10001788:	3001b0e0 	.word	0x3001b0e0
1000178c:	300009a0 	.word	0x300009a0

