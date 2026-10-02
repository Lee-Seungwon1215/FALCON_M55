10006468 <fndsa_vect_FFT_fp64_exact>:
10006468:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
1000646c:	2301      	movs	r3, #1
1000646e:	ed2d 8b10 	vpush	{d8-d15}
10006472:	f100 3aff 	add.w	sl, r0, #4294967295	@ 0xffffffff
10006476:	2802      	cmp	r0, #2
10006478:	4604      	mov	r4, r0
1000647a:	460e      	mov	r6, r1
1000647c:	b0df      	sub	sp, #380	@ 0x17c
1000647e:	fa03 f80a 	lsl.w	r8, r3, sl
10006482:	f200 857e 	bhi.w	10006f82 <fndsa_vect_FFT_fp64_exact+0xb1a>
10006486:	bf08      	it	eq
10006488:	4686      	moveq	lr, r0
1000648a:	f040 8575 	bne.w	10006f78 <fndsa_vect_FFT_fp64_exact+0xb10>
1000648e:	2010      	movs	r0, #16
10006490:	9417      	str	r4, [sp, #92]	@ 0x5c
10006492:	ed9f 9bbf 	vldr	d9, [pc, #764]	@ 10006790 <fndsa_vect_FFT_fp64_exact+0x328>
10006496:	ed9f 8bc0 	vldr	d8, [pc, #768]	@ 10006798 <fndsa_vect_FFT_fp64_exact+0x330>
1000649a:	2401      	movs	r4, #1
1000649c:	f8cd 8058 	str.w	r8, [sp, #88]	@ 0x58
100064a0:	46c4      	mov	ip, r8
100064a2:	f8df 82fc 	ldr.w	r8, [pc, #764]	@ 100067a0 <fndsa_vect_FFT_fp64_exact+0x338>
100064a6:	af18      	add	r7, sp, #96	@ 0x60
100064a8:	f8cd a050 	str.w	sl, [sp, #80]	@ 0x50
100064ac:	fa00 fb0a 	lsl.w	fp, r0, sl
100064b0:	f8cd e048 	str.w	lr, [sp, #72]	@ 0x48
100064b4:	2301      	movs	r3, #1
100064b6:	f04f 0a10 	mov.w	sl, #16
100064ba:	4662      	mov	r2, ip
100064bc:	40a3      	lsls	r3, r4
100064be:	eb03 0353 	add.w	r3, r3, r3, lsr #1
100064c2:	eb08 1303 	add.w	r3, r8, r3, lsl #4
100064c6:	ea4f 0c5c 	mov.w	ip, ip, lsr #1
100064ca:	fa0a fa04 	lsl.w	sl, sl, r4
100064ce:	930a      	str	r3, [sp, #40]	@ 0x28
100064d0:	eb06 190c 	add.w	r9, r6, ip, lsl #4
100064d4:	4633      	mov	r3, r6
100064d6:	eb0a 0008 	add.w	r0, sl, r8
100064da:	9610      	str	r6, [sp, #64]	@ 0x40
100064dc:	46da      	mov	sl, fp
100064de:	f04f 0b00 	mov.w	fp, #0
100064e2:	f8cd c020 	str.w	ip, [sp, #32]
100064e6:	4616      	mov	r6, r2
100064e8:	940c      	str	r4, [sp, #48]	@ 0x30
100064ea:	eeb7 eb00 	vmov.f64	d14, #112	@ 0x3f800000  1.0
100064ee:	f8cd 8038 	str.w	r8, [sp, #56]	@ 0x38
100064f2:	edd0 7a00 	vldr	s15, [r0]
100064f6:	eeb8 1b67 	vcvt.f64.u32	d1, s15
100064fa:	edd0 7a02 	vldr	s15, [r0, #8]
100064fe:	eeb8 4b67 	vcvt.f64.u32	d4, s15
10006502:	edd0 7a01 	vldr	s15, [r0, #4]
10006506:	eeb8 2b67 	vcvt.f64.u32	d2, s15
1000650a:	edd0 7a03 	vldr	s15, [r0, #12]
1000650e:	6842      	ldr	r2, [r0, #4]
10006510:	eeb8 3b67 	vcvt.f64.u32	d3, s15
10006514:	0fd2      	lsrs	r2, r2, #31
10006516:	ee06 2a10 	vmov	s12, r2
1000651a:	ee17 2a90 	vmov	r2, s15
1000651e:	0fd2      	lsrs	r2, r2, #31
10006520:	ee07 2a10 	vmov	s14, r2
10006524:	ee31 5b04 	vadd.f64	d5, d1, d4
10006528:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
1000652c:	ee32 cb03 	vadd.f64	d12, d2, d3
10006530:	ed8d 7b52 	vstr	d7, [sp, #328]	@ 0x148
10006534:	ee25 7b09 	vmul.f64	d7, d5, d9
10006538:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000653c:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006540:	ee3c cb07 	vadd.f64	d12, d12, d7
10006544:	ee07 5b48 	vmls.f64	d5, d7, d8
10006548:	9a08      	ldr	r2, [sp, #32]
1000654a:	eb02 010b 	add.w	r1, r2, fp
1000654e:	ee2c 7b09 	vmul.f64	d7, d12, d9
10006552:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10006556:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000655a:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000655e:	ee07 cb48 	vmls.f64	d12, d7, d8
10006562:	eebc 7bcc 	vcvt.u32.f64	s14, d12
10006566:	ee17 2a10 	vmov	r2, s14
1000656a:	0fd2      	lsrs	r2, r2, #31
1000656c:	ed8d 6b48 	vstr	d6, [sp, #288]	@ 0x120
10006570:	ee07 2a10 	vmov	s14, r2
10006574:	ee25 6b09 	vmul.f64	d6, d5, d9
10006578:	ee21 0b09 	vmul.f64	d0, d1, d9
1000657c:	ed8d 1b42 	vstr	d1, [sp, #264]	@ 0x108
10006580:	ed8d 6b5a 	vstr	d6, [sp, #360]	@ 0x168
10006584:	ee22 ab09 	vmul.f64	d10, d2, d9
10006588:	ee24 1b09 	vmul.f64	d1, d4, d9
1000658c:	ee23 bb09 	vmul.f64	d11, d3, d9
10006590:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10006594:	ee2c 6b09 	vmul.f64	d6, d12, d9
10006598:	458b      	cmp	fp, r1
1000659a:	ed8d 2b40 	vstr	d2, [sp, #256]	@ 0x100
1000659e:	ed8d 3b4a 	vstr	d3, [sp, #296]	@ 0x128
100065a2:	ed8d 4b4c 	vstr	d4, [sp, #304]	@ 0x130
100065a6:	ed8d 0b46 	vstr	d0, [sp, #280]	@ 0x118
100065aa:	ed8d 1b50 	vstr	d1, [sp, #320]	@ 0x140
100065ae:	ed8d ab44 	vstr	d10, [sp, #272]	@ 0x110
100065b2:	ed8d bb4e 	vstr	d11, [sp, #312]	@ 0x138
100065b6:	ed8d 5b56 	vstr	d5, [sp, #344]	@ 0x158
100065ba:	ed8d cb54 	vstr	d12, [sp, #336]	@ 0x150
100065be:	ed8d 6b58 	vstr	d6, [sp, #352]	@ 0x160
100065c2:	ed8d 7b5c 	vstr	d7, [sp, #368]	@ 0x170
100065c6:	f080 80ae 	bcs.w	10006726 <fndsa_vect_FFT_fp64_exact+0x2be>
100065ca:	4649      	mov	r1, r9
100065cc:	461c      	mov	r4, r3
100065ce:	4680      	mov	r8, r0
100065d0:	9604      	str	r6, [sp, #16]
100065d2:	eb0a 0509 	add.w	r5, sl, r9
100065d6:	9306      	str	r3, [sp, #24]
100065d8:	eb0a 0603 	add.w	r6, sl, r3
100065dc:	ed91 0b00 	vldr	d0, [r1]
100065e0:	ed95 2b00 	vldr	d2, [r5]
100065e4:	ed95 3b02 	vldr	d3, [r5, #8]
100065e8:	ed91 1b02 	vldr	d1, [r1, #8]
100065ec:	a840      	add	r0, sp, #256	@ 0x100
100065ee:	f7ff fcb3 	bl	10005f58 <fp64e_cmul_prepared>
100065f2:	ed94 db02 	vldr	d13, [r4, #8]
100065f6:	ee3d 7b01 	vadd.f64	d7, d13, d1
100065fa:	ed96 ab00 	vldr	d10, [r6]
100065fe:	ed96 cb02 	vldr	d12, [r6, #8]
10006602:	ed94 bb00 	vldr	d11, [r4]
10006606:	ed87 1b02 	vstr	d1, [r7, #8]
1000660a:	ed87 0b00 	vstr	d0, [r7]
1000660e:	ed87 2b04 	vstr	d2, [r7, #16]
10006612:	ed87 3b06 	vstr	d3, [r7, #24]
10006616:	ee3c 6b03 	vadd.f64	d6, d12, d3
1000661a:	ee3d 5b08 	vadd.f64	d5, d13, d8
1000661e:	ee3a db02 	vadd.f64	d13, d10, d2
10006622:	ee3a ab08 	vadd.f64	d10, d10, d8
10006626:	ee3b fb00 	vadd.f64	d15, d11, d0
1000662a:	ee3a ab42 	vsub.f64	d10, d10, d2
1000662e:	ee26 4b09 	vmul.f64	d4, d6, d9
10006632:	ee3c cb08 	vadd.f64	d12, d12, d8
10006636:	ee3b bb08 	vadd.f64	d11, d11, d8
1000663a:	ee35 1b41 	vsub.f64	d1, d5, d1
1000663e:	ee3b bb40 	vsub.f64	d11, d11, d0
10006642:	eebc 0bc4 	vcvt.u32.f64	s0, d4
10006646:	ee3c 2b43 	vsub.f64	d2, d12, d3
1000664a:	ee27 5b09 	vmul.f64	d5, d7, d9
1000664e:	ee3a 3b4e 	vsub.f64	d3, d10, d14
10006652:	eebc abc5 	vcvt.u32.f64	s20, d5
10006656:	ee22 cb09 	vmul.f64	d12, d2, d9
1000665a:	ed8d 3b02 	vstr	d3, [sp, #8]
1000665e:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10006662:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10006666:	ee21 3b09 	vmul.f64	d3, d1, d9
1000666a:	ee3b 5b4e 	vsub.f64	d5, d11, d14
1000666e:	ee0a 7b48 	vmls.f64	d7, d10, d8
10006672:	ed8d 5b00 	vstr	d5, [sp]
10006676:	ee00 6b48 	vmls.f64	d6, d0, d8
1000667a:	eebc cbcc 	vcvt.u32.f64	s24, d12
1000667e:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006682:	eeb8 4b4c 	vcvt.f64.u32	d4, s24
10006686:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000668a:	eeb0 cb47 	vmov.f64	d12, d7
1000668e:	ee3d bb00 	vadd.f64	d11, d13, d0
10006692:	ed9d 7b00 	vldr	d7, [sp]
10006696:	eeb0 db46 	vmov.f64	d13, d6
1000669a:	ed9d 6b02 	vldr	d6, [sp, #8]
1000669e:	ee3f 5b0a 	vadd.f64	d5, d15, d10
100066a2:	ee37 7b03 	vadd.f64	d7, d7, d3
100066a6:	ee36 6b04 	vadd.f64	d6, d6, d4
100066aa:	ee25 0b09 	vmul.f64	d0, d5, d9
100066ae:	ee2b ab09 	vmul.f64	d10, d11, d9
100066b2:	ee03 1b48 	vmls.f64	d1, d3, d8
100066b6:	ee04 2b48 	vmls.f64	d2, d4, d8
100066ba:	ee27 3b09 	vmul.f64	d3, d7, d9
100066be:	ee26 4b09 	vmul.f64	d4, d6, d9
100066c2:	eebc 0bc0 	vcvt.u32.f64	s0, d0
100066c6:	eebc abca 	vcvt.u32.f64	s20, d10
100066ca:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100066ce:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100066d2:	eeb8 0b40 	vcvt.f64.u32	d0, s0
100066d6:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
100066da:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100066de:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100066e2:	ee00 5b48 	vmls.f64	d5, d0, d8
100066e6:	ee0a bb48 	vmls.f64	d11, d10, d8
100066ea:	ee03 7b48 	vmls.f64	d7, d3, d8
100066ee:	ee04 6b48 	vmls.f64	d6, d4, d8
100066f2:	3410      	adds	r4, #16
100066f4:	3610      	adds	r6, #16
100066f6:	3110      	adds	r1, #16
100066f8:	3510      	adds	r5, #16
100066fa:	45a1      	cmp	r9, r4
100066fc:	ed04 cb02 	vstr	d12, [r4, #-8]
10006700:	ed04 5b04 	vstr	d5, [r4, #-16]
10006704:	ed06 bb04 	vstr	d11, [r6, #-16]
10006708:	ed06 db02 	vstr	d13, [r6, #-8]
1000670c:	ed01 1b02 	vstr	d1, [r1, #-8]
10006710:	ed01 7b04 	vstr	d7, [r1, #-16]
10006714:	ed05 6b04 	vstr	d6, [r5, #-16]
10006718:	ed05 2b02 	vstr	d2, [r5, #-8]
1000671c:	f47f af5e 	bne.w	100065dc <fndsa_vect_FFT_fp64_exact+0x174>
10006720:	4640      	mov	r0, r8
10006722:	9e04      	ldr	r6, [sp, #16]
10006724:	9b06      	ldr	r3, [sp, #24]
10006726:	9a0a      	ldr	r2, [sp, #40]	@ 0x28
10006728:	3010      	adds	r0, #16
1000672a:	4282      	cmp	r2, r0
1000672c:	44b3      	add	fp, r6
1000672e:	eb03 1306 	add.w	r3, r3, r6, lsl #4
10006732:	eb09 1906 	add.w	r9, r9, r6, lsl #4
10006736:	f47f aedc 	bne.w	100064f2 <fndsa_vect_FFT_fp64_exact+0x8a>
1000673a:	9c0c      	ldr	r4, [sp, #48]	@ 0x30
1000673c:	9b12      	ldr	r3, [sp, #72]	@ 0x48
1000673e:	3401      	adds	r4, #1
10006740:	429c      	cmp	r4, r3
10006742:	46d3      	mov	fp, sl
10006744:	f8dd c020 	ldr.w	ip, [sp, #32]
10006748:	f8dd 8038 	ldr.w	r8, [sp, #56]	@ 0x38
1000674c:	9e10      	ldr	r6, [sp, #64]	@ 0x40
1000674e:	f4ff aeb1 	bcc.w	100064b4 <fndsa_vect_FFT_fp64_exact+0x4c>
10006752:	4645      	mov	r5, r8
10006754:	e9dd 8416 	ldrd	r8, r4, [sp, #88]	@ 0x58
10006758:	2c02      	cmp	r4, #2
1000675a:	f8dd a050 	ldr.w	sl, [sp, #80]	@ 0x50
1000675e:	f000 840b 	beq.w	10006f78 <fndsa_vect_FFT_fp64_exact+0xb10>
10006762:	4631      	mov	r1, r6
10006764:	2410      	movs	r4, #16
10006766:	ed9f eb0a 	vldr	d14, [pc, #40]	@ 10006790 <fndsa_vect_FFT_fp64_exact+0x328>
1000676a:	ed9f fb0b 	vldr	d15, [pc, #44]	@ 10006798 <fndsa_vect_FFT_fp64_exact+0x330>
1000676e:	f108 33ff 	add.w	r3, r8, #4294967295	@ 0xffffffff
10006772:	fa04 f40a 	lsl.w	r4, r4, sl
10006776:	ea4f 0658 	mov.w	r6, r8, lsr #1
1000677a:	089b      	lsrs	r3, r3, #2
1000677c:	f101 0740 	add.w	r7, r1, #64	@ 0x40
10006780:	eb05 1606 	add.w	r6, r5, r6, lsl #4
10006784:	eb07 1783 	add.w	r7, r7, r3, lsl #6
10006788:	4425      	add	r5, r4
1000678a:	440c      	add	r4, r1
1000678c:	e00a      	b.n	100067a4 <fndsa_vect_FFT_fp64_exact+0x33c>
1000678e:	bf00      	nop
10006790:	00000000 	.word	0x00000000
10006794:	3df00000 	.word	0x3df00000
10006798:	00000000 	.word	0x00000000
1000679c:	41f00000 	.word	0x41f00000
100067a0:	300039a0 	.word	0x300039a0
100067a4:	ed91 7b02 	vldr	d7, [r1, #8]
100067a8:	ed91 3b06 	vldr	d3, [r1, #24]
100067ac:	ed8d 7b02 	vstr	d7, [sp, #8]
100067b0:	edd6 7a00 	vldr	s15, [r6]
100067b4:	ed94 2b04 	vldr	d2, [r4, #16]
100067b8:	ed91 5b04 	vldr	d5, [r1, #16]
100067bc:	ed91 4b00 	vldr	d4, [r1]
100067c0:	ed8d 3b00 	vstr	d3, [sp]
100067c4:	eeb8 3b67 	vcvt.f64.u32	d3, s15
100067c8:	edd6 7a02 	vldr	s15, [r6, #8]
100067cc:	6873      	ldr	r3, [r6, #4]
100067ce:	ed8d 2b06 	vstr	d2, [sp, #24]
100067d2:	0fdb      	lsrs	r3, r3, #31
100067d4:	ee02 3a10 	vmov	s4, r3
100067d8:	68f3      	ldr	r3, [r6, #12]
100067da:	ed94 6b02 	vldr	d6, [r4, #8]
100067de:	0fdb      	lsrs	r3, r3, #31
100067e0:	ed8d 5b0a 	vstr	d5, [sp, #40]	@ 0x28
100067e4:	ee05 3a10 	vmov	s10, r3
100067e8:	ed8d 4b0c 	vstr	d4, [sp, #48]	@ 0x30
100067ec:	eeb8 4b67 	vcvt.f64.u32	d4, s15
100067f0:	edd6 7a01 	vldr	s15, [r6, #4]
100067f4:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
100067f8:	ed8d 6b12 	vstr	d6, [sp, #72]	@ 0x48
100067fc:	eeb8 6b67 	vcvt.f64.u32	d6, s15
10006800:	edd6 7a03 	vldr	s15, [r6, #12]
10006804:	ed94 bb00 	vldr	d11, [r4]
10006808:	eeb8 7b67 	vcvt.f64.u32	d7, s15
1000680c:	ed94 1b06 	vldr	d1, [r4, #24]
10006810:	eeb8 2bc2 	vcvt.f64.s32	d2, s4
10006814:	ed94 0b0c 	vldr	d0, [r4, #48]	@ 0x30
10006818:	ed8d 3b42 	vstr	d3, [sp, #264]	@ 0x108
1000681c:	ed8d 4b4c 	vstr	d4, [sp, #304]	@ 0x130
10006820:	ed8d 5b52 	vstr	d5, [sp, #328]	@ 0x148
10006824:	ee33 5b04 	vadd.f64	d5, d3, d4
10006828:	ed91 cb0c 	vldr	d12, [r1, #48]	@ 0x30
1000682c:	ed91 db0e 	vldr	d13, [r1, #56]	@ 0x38
10006830:	ed8d bb08 	vstr	d11, [sp, #32]
10006834:	ed8d 1b04 	vstr	d1, [sp, #16]
10006838:	ee23 3b0e 	vmul.f64	d3, d3, d14
1000683c:	ee24 4b0e 	vmul.f64	d4, d4, d14
10006840:	ed8d 0b10 	vstr	d0, [sp, #64]	@ 0x40
10006844:	ed8d 2b48 	vstr	d2, [sp, #288]	@ 0x120
10006848:	ed8d 6b40 	vstr	d6, [sp, #256]	@ 0x100
1000684c:	ed8d 7b4a 	vstr	d7, [sp, #296]	@ 0x128
10006850:	ed8d 3b46 	vstr	d3, [sp, #280]	@ 0x118
10006854:	ed8d 4b50 	vstr	d4, [sp, #320]	@ 0x140
10006858:	ee25 4b0e 	vmul.f64	d4, d5, d14
1000685c:	eefc 3bc4 	vcvt.u32.f64	s7, d4
10006860:	ee36 4b07 	vadd.f64	d4, d6, d7
10006864:	ee27 7b0e 	vmul.f64	d7, d7, d14
10006868:	ed8d 7b4e 	vstr	d7, [sp, #312]	@ 0x138
1000686c:	eeb8 7b63 	vcvt.f64.u32	d7, s7
10006870:	ee34 4b07 	vadd.f64	d4, d4, d7
10006874:	ee07 5b4f 	vmls.f64	d5, d7, d15
10006878:	ee24 7b0e 	vmul.f64	d7, d4, d14
1000687c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006880:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006884:	ee07 4b4f 	vmls.f64	d4, d7, d15
10006888:	eebc 7bc4 	vcvt.u32.f64	s14, d4
1000688c:	ee17 3a10 	vmov	r3, s14
10006890:	0fdb      	lsrs	r3, r3, #31
10006892:	ed94 8b0e 	vldr	d8, [r4, #56]	@ 0x38
10006896:	ee07 3a10 	vmov	s14, r3
1000689a:	ed8d 5b56 	vstr	d5, [sp, #344]	@ 0x158
1000689e:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100068a2:	ed8d 4b54 	vstr	d4, [sp, #336]	@ 0x150
100068a6:	ee24 4b0e 	vmul.f64	d4, d4, d14
100068aa:	ed91 0b08 	vldr	d0, [r1, #32]
100068ae:	ed91 1b0a 	vldr	d1, [r1, #40]	@ 0x28
100068b2:	ed94 2b08 	vldr	d2, [r4, #32]
100068b6:	a840      	add	r0, sp, #256	@ 0x100
100068b8:	ed94 3b0a 	vldr	d3, [r4, #40]	@ 0x28
100068bc:	ee26 6b0e 	vmul.f64	d6, d6, d14
100068c0:	ed8d 4b58 	vstr	d4, [sp, #352]	@ 0x160
100068c4:	ed8d 7b5c 	vstr	d7, [sp, #368]	@ 0x170
100068c8:	ee25 5b0e 	vmul.f64	d5, d5, d14
100068cc:	ed8d 6b44 	vstr	d6, [sp, #272]	@ 0x110
100068d0:	ed8d 5b5a 	vstr	d5, [sp, #360]	@ 0x168
100068d4:	ed8d 8b0e 	vstr	d8, [sp, #56]	@ 0x38
100068d8:	f7ff fb3e 	bl	10005f58 <fp64e_cmul_prepared>
100068dc:	eeb0 9b40 	vmov.f64	d9, d0
100068e0:	eeb0 8b42 	vmov.f64	d8, d2
100068e4:	ed9d 2b10 	vldr	d2, [sp, #64]	@ 0x40
100068e8:	eeb0 ab43 	vmov.f64	d10, d3
100068ec:	ed9d 3b0e 	vldr	d3, [sp, #56]	@ 0x38
100068f0:	eeb0 bb41 	vmov.f64	d11, d1
100068f4:	ed8d 9b20 	vstr	d9, [sp, #128]	@ 0x80
100068f8:	eeb0 1b4d 	vmov.f64	d1, d13
100068fc:	ed8d bb22 	vstr	d11, [sp, #136]	@ 0x88
10006900:	eeb0 0b4c 	vmov.f64	d0, d12
10006904:	ed8d 8b24 	vstr	d8, [sp, #144]	@ 0x90
10006908:	ed8d ab26 	vstr	d10, [sp, #152]	@ 0x98
1000690c:	f7ff fb24 	bl	10005f58 <fp64e_cmul_prepared>
10006910:	edd5 7a00 	vldr	s15, [r5]
10006914:	eeb8 5b67 	vcvt.f64.u32	d5, s15
10006918:	edd5 7a02 	vldr	s15, [r5, #8]
1000691c:	eeb8 6b67 	vcvt.f64.u32	d6, s15
10006920:	edd5 7a01 	vldr	s15, [r5, #4]
10006924:	686b      	ldr	r3, [r5, #4]
10006926:	eeb8 cb67 	vcvt.f64.u32	d12, s15
1000692a:	0fdb      	lsrs	r3, r3, #31
1000692c:	ee04 3a10 	vmov	s8, r3
10006930:	68eb      	ldr	r3, [r5, #12]
10006932:	edd5 7a03 	vldr	s15, [r5, #12]
10006936:	0fdb      	lsrs	r3, r3, #31
10006938:	ee07 3a10 	vmov	s14, r3
1000693c:	eeb8 db67 	vcvt.f64.u32	d13, s15
10006940:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10006944:	ed8d 6b4c 	vstr	d6, [sp, #304]	@ 0x130
10006948:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
1000694c:	ed8d 7b52 	vstr	d7, [sp, #328]	@ 0x148
10006950:	ee35 7b06 	vadd.f64	d7, d5, d6
10006954:	ed8d 4b48 	vstr	d4, [sp, #288]	@ 0x120
10006958:	ed8d 5b42 	vstr	d5, [sp, #264]	@ 0x108
1000695c:	ed9d 4b02 	vldr	d4, [sp, #8]
10006960:	ee26 6b0e 	vmul.f64	d6, d6, d14
10006964:	ee25 5b0e 	vmul.f64	d5, d5, d14
10006968:	ed8d 6b50 	vstr	d6, [sp, #320]	@ 0x140
1000696c:	ee27 6b0e 	vmul.f64	d6, d7, d14
10006970:	ed8d 5b46 	vstr	d5, [sp, #280]	@ 0x118
10006974:	ee34 5b0f 	vadd.f64	d5, d4, d15
10006978:	ee34 4b0b 	vadd.f64	d4, d4, d11
1000697c:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006980:	ed8d 4b10 	vstr	d4, [sp, #64]	@ 0x40
10006984:	eeb8 4b46 	vcvt.f64.u32	d4, s12
10006988:	ed9d 6b12 	vldr	d6, [sp, #72]	@ 0x48
1000698c:	ee04 7b4f 	vmls.f64	d7, d4, d15
10006990:	ed8d 7b56 	vstr	d7, [sp, #344]	@ 0x158
10006994:	ee27 7b0e 	vmul.f64	d7, d7, d14
10006998:	ed8d 7b5a 	vstr	d7, [sp, #360]	@ 0x168
1000699c:	ee36 7b0f 	vadd.f64	d7, d6, d15
100069a0:	ed8d 0b28 	vstr	d0, [sp, #160]	@ 0xa0
100069a4:	ed8d 1b2a 	vstr	d1, [sp, #168]	@ 0xa8
100069a8:	ed8d 2b2c 	vstr	d2, [sp, #176]	@ 0xb0
100069ac:	ed8d 3b2e 	vstr	d3, [sp, #184]	@ 0xb8
100069b0:	ee3a 6b06 	vadd.f64	d6, d10, d6
100069b4:	ee37 ab4a 	vsub.f64	d10, d7, d10
100069b8:	ed8d cb40 	vstr	d12, [sp, #256]	@ 0x100
100069bc:	ed8d db4a 	vstr	d13, [sp, #296]	@ 0x128
100069c0:	ed8d 6b0e 	vstr	d6, [sp, #56]	@ 0x38
100069c4:	ed9d 6b00 	vldr	d6, [sp]
100069c8:	ee36 7b0f 	vadd.f64	d7, d6, d15
100069cc:	ee36 6b01 	vadd.f64	d6, d6, d1
100069d0:	ee37 7b41 	vsub.f64	d7, d7, d1
100069d4:	ed9d 1b04 	vldr	d1, [sp, #16]
100069d8:	ee35 bb4b 	vsub.f64	d11, d5, d11
100069dc:	ed8d 7b02 	vstr	d7, [sp, #8]
100069e0:	ee31 5b0f 	vadd.f64	d5, d1, d15
100069e4:	ee31 7b03 	vadd.f64	d7, d1, d3
100069e8:	ee35 3b43 	vsub.f64	d3, d5, d3
100069ec:	ee3c 5b0d 	vadd.f64	d5, d12, d13
100069f0:	ee2c cb0e 	vmul.f64	d12, d12, d14
100069f4:	ee35 1b04 	vadd.f64	d1, d5, d4
100069f8:	ed8d cb44 	vstr	d12, [sp, #272]	@ 0x110
100069fc:	ee26 5b0e 	vmul.f64	d5, d6, d14
10006a00:	eefc 4bc5 	vcvt.u32.f64	s9, d5
10006a04:	ee27 5b0e 	vmul.f64	d5, d7, d14
10006a08:	eeb8 cb64 	vcvt.f64.u32	d12, s9
10006a0c:	eefc 5bc5 	vcvt.u32.f64	s11, d5
10006a10:	ee2d db0e 	vmul.f64	d13, d13, d14
10006a14:	ed9d 4b0e 	vldr	d4, [sp, #56]	@ 0x38
10006a18:	ed8d 1b14 	vstr	d1, [sp, #80]	@ 0x50
10006a1c:	eeb0 1b46 	vmov.f64	d1, d6
10006a20:	ed8d db4e 	vstr	d13, [sp, #312]	@ 0x138
10006a24:	eeb8 db65 	vcvt.f64.u32	d13, s11
10006a28:	ee24 6b0e 	vmul.f64	d6, d4, d14
10006a2c:	ed9d 5b10 	vldr	d5, [sp, #64]	@ 0x40
10006a30:	ed8d 3b00 	vstr	d3, [sp]
10006a34:	eeb0 3b47 	vmov.f64	d3, d7
10006a38:	ee25 7b0e 	vmul.f64	d7, d5, d14
10006a3c:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006a40:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006a44:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006a48:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006a4c:	ee06 4b4f 	vmls.f64	d4, d6, d15
10006a50:	ed8d 6b04 	vstr	d6, [sp, #16]
10006a54:	ee07 5b4f 	vmls.f64	d5, d7, d15
10006a58:	ed8d 4b0e 	vstr	d4, [sp, #56]	@ 0x38
10006a5c:	ed9d 4b0c 	vldr	d4, [sp, #48]	@ 0x30
10006a60:	ee2b 6b0e 	vmul.f64	d6, d11, d14
10006a64:	ed8d 5b12 	vstr	d5, [sp, #72]	@ 0x48
10006a68:	ee34 5b0f 	vadd.f64	d5, d4, d15
10006a6c:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006a70:	ee34 4b09 	vadd.f64	d4, d4, d9
10006a74:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006a78:	ee34 4b07 	vadd.f64	d4, d4, d7
10006a7c:	ee35 5b49 	vsub.f64	d5, d5, d9
10006a80:	eeb7 7b00 	vmov.f64	d7, #112	@ 0x3f800000  1.0
10006a84:	eeb0 9b4b 	vmov.f64	d9, d11
10006a88:	ee35 5b47 	vsub.f64	d5, d5, d7
10006a8c:	ed9d bb08 	vldr	d11, [sp, #32]
10006a90:	ee06 9b4f 	vmls.f64	d9, d6, d15
10006a94:	ee2a 7b0e 	vmul.f64	d7, d10, d14
10006a98:	ed8d 9b0c 	vstr	d9, [sp, #48]	@ 0x30
10006a9c:	ee35 9b06 	vadd.f64	d9, d5, d6
10006aa0:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006aa4:	ee3b 6b0f 	vadd.f64	d6, d11, d15
10006aa8:	ee3b 5b08 	vadd.f64	d5, d11, d8
10006aac:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006ab0:	eeb7 bb00 	vmov.f64	d11, #112	@ 0x3f800000  1.0
10006ab4:	ee36 6b48 	vsub.f64	d6, d6, d8
10006ab8:	ed9d 8b04 	vldr	d8, [sp, #16]
10006abc:	ee07 ab4f 	vmls.f64	d10, d7, d15
10006ac0:	ee36 6b4b 	vsub.f64	d6, d6, d11
10006ac4:	ed8d ab08 	vstr	d10, [sp, #32]
10006ac8:	ee35 8b08 	vadd.f64	d8, d5, d8
10006acc:	ee36 ab07 	vadd.f64	d10, d6, d7
10006ad0:	ed9d 6b02 	vldr	d6, [sp, #8]
10006ad4:	ee26 5b0e 	vmul.f64	d5, d6, d14
10006ad8:	ed9d 6b0a 	vldr	d6, [sp, #40]	@ 0x28
10006adc:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10006ae0:	ee36 7b0f 	vadd.f64	d7, d6, d15
10006ae4:	ee36 6b00 	vadd.f64	d6, d6, d0
10006ae8:	ee37 7b40 	vsub.f64	d7, d7, d0
10006aec:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10006af0:	ee36 0b0c 	vadd.f64	d0, d6, d12
10006af4:	ed9d 6b02 	vldr	d6, [sp, #8]
10006af8:	ee05 6b4f 	vmls.f64	d6, d5, d15
10006afc:	ee0c 1b4f 	vmls.f64	d1, d12, d15
10006b00:	ed8d 6b02 	vstr	d6, [sp, #8]
10006b04:	ee37 7b4b 	vsub.f64	d7, d7, d11
10006b08:	eeb0 cb4b 	vmov.f64	d12, d11
10006b0c:	ee37 5b05 	vadd.f64	d5, d7, d5
10006b10:	ed9d bb00 	vldr	d11, [sp]
10006b14:	ed9d 6b06 	vldr	d6, [sp, #24]
10006b18:	ee2b bb0e 	vmul.f64	d11, d11, d14
10006b1c:	ee36 7b0f 	vadd.f64	d7, d6, d15
10006b20:	eebc bbcb 	vcvt.u32.f64	s22, d11
10006b24:	ee36 6b02 	vadd.f64	d6, d6, d2
10006b28:	ee37 7b42 	vsub.f64	d7, d7, d2
10006b2c:	ee36 2b0d 	vadd.f64	d2, d6, d13
10006b30:	ee37 7b4c 	vsub.f64	d7, d7, d12
10006b34:	ee0d 3b4f 	vmls.f64	d3, d13, d15
10006b38:	ed9d db00 	vldr	d13, [sp]
10006b3c:	eeb8 bb4b 	vcvt.f64.u32	d11, s22
10006b40:	ee0b db4f 	vmls.f64	d13, d11, d15
10006b44:	ee37 bb0b 	vadd.f64	d11, d7, d11
10006b48:	ed9d 7b14 	vldr	d7, [sp, #80]	@ 0x50
10006b4c:	ee27 6b0e 	vmul.f64	d6, d7, d14
10006b50:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006b54:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006b58:	ee06 7b4f 	vmls.f64	d7, d6, d15
10006b5c:	eefc 6bc7 	vcvt.u32.f64	s13, d7
10006b60:	ed8d 7b54 	vstr	d7, [sp, #336]	@ 0x150
10006b64:	ee16 3a90 	vmov	r3, s13
10006b68:	ee27 7b0e 	vmul.f64	d7, d7, d14
10006b6c:	0fdb      	lsrs	r3, r3, #31
10006b6e:	ed8d 7b58 	vstr	d7, [sp, #352]	@ 0x160
10006b72:	ee07 3a10 	vmov	s14, r3
10006b76:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10006b7a:	ee28 6b0e 	vmul.f64	d6, d8, d14
10006b7e:	ed8d 7b5c 	vstr	d7, [sp, #368]	@ 0x170
10006b82:	ee24 7b0e 	vmul.f64	d7, d4, d14
10006b86:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006b8a:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006b8e:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006b92:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006b96:	ee06 8b4f 	vmls.f64	d8, d6, d15
10006b9a:	ee07 4b4f 	vmls.f64	d4, d7, d15
10006b9e:	ed8d 8b0a 	vstr	d8, [sp, #40]	@ 0x28
10006ba2:	ee29 7b0e 	vmul.f64	d7, d9, d14
10006ba6:	ee22 6b0e 	vmul.f64	d6, d2, d14
10006baa:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006bae:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006bb2:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006bb6:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006bba:	ee07 9b4f 	vmls.f64	d9, d7, d15
10006bbe:	ee25 7b0e 	vmul.f64	d7, d5, d14
10006bc2:	ee06 2b4f 	vmls.f64	d2, d6, d15
10006bc6:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006bca:	ee2a 6b0e 	vmul.f64	d6, d10, d14
10006bce:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006bd2:	eeb0 8b45 	vmov.f64	d8, d5
10006bd6:	ee20 cb0e 	vmul.f64	d12, d0, d14
10006bda:	ee07 8b4f 	vmls.f64	d8, d7, d15
10006bde:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006be2:	ee2b 7b0e 	vmul.f64	d7, d11, d14
10006be6:	eebc cbcc 	vcvt.u32.f64	s24, d12
10006bea:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006bee:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006bf2:	eeb8 cb4c 	vcvt.f64.u32	d12, s24
10006bf6:	ee06 ab4f 	vmls.f64	d10, d6, d15
10006bfa:	ed8d 4b10 	vstr	d4, [sp, #64]	@ 0x40
10006bfe:	ed8d db00 	vstr	d13, [sp]
10006c02:	ed8d 9b06 	vstr	d9, [sp, #24]
10006c06:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006c0a:	ee0c 0b4f 	vmls.f64	d0, d12, d15
10006c0e:	ed8d ab04 	vstr	d10, [sp, #16]
10006c12:	ee07 bb4f 	vmls.f64	d11, d7, d15
10006c16:	f7ff f99f 	bl	10005f58 <fp64e_cmul_prepared>
10006c1a:	edd5 7a04 	vldr	s15, [r5, #16]
10006c1e:	696b      	ldr	r3, [r5, #20]
10006c20:	eeb0 db42 	vmov.f64	d13, d2
10006c24:	0fdb      	lsrs	r3, r3, #31
10006c26:	eeb0 2b4b 	vmov.f64	d2, d11
10006c2a:	ee0b 3a10 	vmov	s22, r3
10006c2e:	69eb      	ldr	r3, [r5, #28]
10006c30:	eeb0 cb40 	vmov.f64	d12, d0
10006c34:	0fdb      	lsrs	r3, r3, #31
10006c36:	eeb0 0b48 	vmov.f64	d0, d8
10006c3a:	ee05 3a10 	vmov	s10, r3
10006c3e:	eeb8 8b67 	vcvt.f64.u32	d8, s15
10006c42:	edd5 7a06 	vldr	s15, [r5, #24]
10006c46:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
10006c4a:	ed8d 8b42 	vstr	d8, [sp, #264]	@ 0x108
10006c4e:	eeb8 4b67 	vcvt.f64.u32	d4, s15
10006c52:	edd5 7a05 	vldr	s15, [r5, #20]
10006c56:	ed8d 5b52 	vstr	d5, [sp, #328]	@ 0x148
10006c5a:	ee38 5b04 	vadd.f64	d5, d8, d4
10006c5e:	ee28 8b0e 	vmul.f64	d8, d8, d14
10006c62:	eeb8 6b67 	vcvt.f64.u32	d6, s15
10006c66:	ed8d 8b46 	vstr	d8, [sp, #280]	@ 0x118
10006c6a:	ee25 8b0e 	vmul.f64	d8, d5, d14
10006c6e:	edd5 7a07 	vldr	s15, [r5, #28]
10006c72:	ed8d 4b4c 	vstr	d4, [sp, #304]	@ 0x130
10006c76:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10006c7a:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10006c7e:	ee24 4b0e 	vmul.f64	d4, d4, d14
10006c82:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10006c86:	ed8d 4b50 	vstr	d4, [sp, #320]	@ 0x140
10006c8a:	ee36 4b07 	vadd.f64	d4, d6, d7
10006c8e:	ed8d 7b4a 	vstr	d7, [sp, #296]	@ 0x128
10006c92:	ee34 4b08 	vadd.f64	d4, d4, d8
10006c96:	ee27 7b0e 	vmul.f64	d7, d7, d14
10006c9a:	ed8d 7b4e 	vstr	d7, [sp, #312]	@ 0x138
10006c9e:	ee24 7b0e 	vmul.f64	d7, d4, d14
10006ca2:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006ca6:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006caa:	ee07 4b4f 	vmls.f64	d4, d7, d15
10006cae:	eebc 7bc4 	vcvt.u32.f64	s14, d4
10006cb2:	ee17 3a10 	vmov	r3, s14
10006cb6:	0fdb      	lsrs	r3, r3, #31
10006cb8:	ee08 5b4f 	vmls.f64	d5, d8, d15
10006cbc:	ed8d 6b40 	vstr	d6, [sp, #256]	@ 0x100
10006cc0:	ee07 3a10 	vmov	s14, r3
10006cc4:	eeb0 ab41 	vmov.f64	d10, d1
10006cc8:	eeb0 9b43 	vmov.f64	d9, d3
10006ccc:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10006cd0:	eeb8 bbcb 	vcvt.f64.s32	d11, s22
10006cd4:	ee26 6b0e 	vmul.f64	d6, d6, d14
10006cd8:	ed8d 5b56 	vstr	d5, [sp, #344]	@ 0x158
10006cdc:	ed8d 4b54 	vstr	d4, [sp, #336]	@ 0x150
10006ce0:	ed9d 1b02 	vldr	d1, [sp, #8]
10006ce4:	ed9d 3b00 	vldr	d3, [sp]
10006ce8:	ed8d cb30 	vstr	d12, [sp, #192]	@ 0xc0
10006cec:	ed8d ab32 	vstr	d10, [sp, #200]	@ 0xc8
10006cf0:	ed8d db34 	vstr	d13, [sp, #208]	@ 0xd0
10006cf4:	ed8d 9b36 	vstr	d9, [sp, #216]	@ 0xd8
10006cf8:	ee25 5b0e 	vmul.f64	d5, d5, d14
10006cfc:	ee24 4b0e 	vmul.f64	d4, d4, d14
10006d00:	ed8d bb48 	vstr	d11, [sp, #288]	@ 0x120
10006d04:	ed8d 6b44 	vstr	d6, [sp, #272]	@ 0x110
10006d08:	ed8d 5b5a 	vstr	d5, [sp, #360]	@ 0x168
10006d0c:	ed8d 4b58 	vstr	d4, [sp, #352]	@ 0x160
10006d10:	ed8d 7b5c 	vstr	d7, [sp, #368]	@ 0x170
10006d14:	f7ff f920 	bl	10005f58 <fp64e_cmul_prepared>
10006d18:	ed9d 5b12 	vldr	d5, [sp, #72]	@ 0x48
10006d1c:	ee35 6b0a 	vadd.f64	d6, d5, d10
10006d20:	ed9d 7b0e 	vldr	d7, [sp, #56]	@ 0x38
10006d24:	ee35 4b0f 	vadd.f64	d4, d5, d15
10006d28:	ed9d 5b0c 	vldr	d5, [sp, #48]	@ 0x30
10006d2c:	ed8d 1b3a 	vstr	d1, [sp, #232]	@ 0xe8
10006d30:	ee37 8b0f 	vadd.f64	d8, d7, d15
10006d34:	ee35 bb0f 	vadd.f64	d11, d5, d15
10006d38:	ee37 7b09 	vadd.f64	d7, d7, d9
10006d3c:	ee38 8b49 	vsub.f64	d8, d8, d9
10006d40:	ee3b bb41 	vsub.f64	d11, d11, d1
10006d44:	ee35 9b01 	vadd.f64	d9, d5, d1
10006d48:	ed9d 1b08 	vldr	d1, [sp, #32]
10006d4c:	ee31 5b0f 	vadd.f64	d5, d1, d15
10006d50:	ee34 4b4a 	vsub.f64	d4, d4, d10
10006d54:	ee35 5b43 	vsub.f64	d5, d5, d3
10006d58:	ee31 ab03 	vadd.f64	d10, d1, d3
10006d5c:	ed8d 5b00 	vstr	d5, [sp]
10006d60:	ed8d 3b3e 	vstr	d3, [sp, #248]	@ 0xf8
10006d64:	ee26 5b0e 	vmul.f64	d5, d6, d14
10006d68:	ee27 3b0e 	vmul.f64	d3, d7, d14
10006d6c:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10006d70:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006d74:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10006d78:	eeb8 1b43 	vcvt.f64.u32	d1, s6
10006d7c:	ed9d 3b10 	vldr	d3, [sp, #64]	@ 0x40
10006d80:	ee01 7b4f 	vmls.f64	d7, d1, d15
10006d84:	ee05 6b4f 	vmls.f64	d6, d5, d15
10006d88:	ed8d 7b02 	vstr	d7, [sp, #8]
10006d8c:	ee24 7b0e 	vmul.f64	d7, d4, d14
10006d90:	ed81 6b02 	vstr	d6, [r1, #8]
10006d94:	ee33 6b0f 	vadd.f64	d6, d3, d15
10006d98:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006d9c:	ee33 3b0c 	vadd.f64	d3, d3, d12
10006da0:	ee36 6b4c 	vsub.f64	d6, d6, d12
10006da4:	eeb7 cb00 	vmov.f64	d12, #112	@ 0x3f800000  1.0
10006da8:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006dac:	ee36 6b4c 	vsub.f64	d6, d6, d12
10006db0:	eeb0 cb44 	vmov.f64	d12, d4
10006db4:	ed9d 4b0a 	vldr	d4, [sp, #40]	@ 0x28
10006db8:	ee07 cb4f 	vmls.f64	d12, d7, d15
10006dbc:	ed8d cb08 	vstr	d12, [sp, #32]
10006dc0:	ee36 cb07 	vadd.f64	d12, d6, d7
10006dc4:	ee28 7b0e 	vmul.f64	d7, d8, d14
10006dc8:	ee33 3b05 	vadd.f64	d3, d3, d5
10006dcc:	ee34 6b0f 	vadd.f64	d6, d4, d15
10006dd0:	ee34 5b0d 	vadd.f64	d5, d4, d13
10006dd4:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006dd8:	ee35 1b01 	vadd.f64	d1, d5, d1
10006ddc:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006de0:	ee36 6b4d 	vsub.f64	d6, d6, d13
10006de4:	ed9d 4b06 	vldr	d4, [sp, #24]
10006de8:	eeb7 5b00 	vmov.f64	d5, #112	@ 0x3f800000  1.0
10006dec:	ee07 8b4f 	vmls.f64	d8, d7, d15
10006df0:	ee36 6b45 	vsub.f64	d6, d6, d5
10006df4:	eeb0 db48 	vmov.f64	d13, d8
10006df8:	ee2b 5b0e 	vmul.f64	d5, d11, d14
10006dfc:	ee36 8b07 	vadd.f64	d8, d6, d7
10006e00:	eefc 5bc5 	vcvt.u32.f64	s11, d5
10006e04:	ee29 7b0e 	vmul.f64	d7, d9, d14
10006e08:	edcd 5a0a 	vstr	s11, [sp, #40]	@ 0x28
10006e0c:	ed8d 0b38 	vstr	d0, [sp, #224]	@ 0xe0
10006e10:	ee34 5b0f 	vadd.f64	d5, d4, d15
10006e14:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006e18:	ee34 4b00 	vadd.f64	d4, d4, d0
10006e1c:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006e20:	ee35 5b40 	vsub.f64	d5, d5, d0
10006e24:	ee07 9b4f 	vmls.f64	d9, d7, d15
10006e28:	ee34 0b07 	vadd.f64	d0, d4, d7
10006e2c:	eddd 7a0a 	vldr	s15, [sp, #40]	@ 0x28
10006e30:	eeb7 4b00 	vmov.f64	d4, #112	@ 0x3f800000  1.0
10006e34:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10006e38:	ee35 5b44 	vsub.f64	d5, d5, d4
10006e3c:	ee07 bb4f 	vmls.f64	d11, d7, d15
10006e40:	ee2a 6b0e 	vmul.f64	d6, d10, d14
10006e44:	ee35 5b07 	vadd.f64	d5, d5, d7
10006e48:	ed9d 7b00 	vldr	d7, [sp]
10006e4c:	ed9d 4b04 	vldr	d4, [sp, #16]
10006e50:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006e54:	ee27 7b0e 	vmul.f64	d7, d7, d14
10006e58:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006e5c:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10006e60:	ee06 ab4f 	vmls.f64	d10, d6, d15
10006e64:	edcd 7a06 	vstr	s15, [sp, #24]
10006e68:	ed8d 2b3c 	vstr	d2, [sp, #240]	@ 0xf0
10006e6c:	ee34 7b0f 	vadd.f64	d7, d4, d15
10006e70:	ee34 4b02 	vadd.f64	d4, d4, d2
10006e74:	ee37 7b42 	vsub.f64	d7, d7, d2
10006e78:	ee34 4b06 	vadd.f64	d4, d4, d6
10006e7c:	eddd 6a06 	vldr	s13, [sp, #24]
10006e80:	eeb7 2b00 	vmov.f64	d2, #112	@ 0x3f800000  1.0
10006e84:	eeb8 6b66 	vcvt.f64.u32	d6, s13
10006e88:	ee37 7b42 	vsub.f64	d7, d7, d2
10006e8c:	ed9d 2b00 	vldr	d2, [sp]
10006e90:	ee06 2b4f 	vmls.f64	d2, d6, d15
10006e94:	ed8d 2b00 	vstr	d2, [sp]
10006e98:	ee23 2b0e 	vmul.f64	d2, d3, d14
10006e9c:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10006ea0:	ee37 7b06 	vadd.f64	d7, d7, d6
10006ea4:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10006ea8:	ee21 6b0e 	vmul.f64	d6, d1, d14
10006eac:	ee02 3b4f 	vmls.f64	d3, d2, d15
10006eb0:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006eb4:	ed81 3b00 	vstr	d3, [r1]
10006eb8:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006ebc:	ed9d 3b02 	vldr	d3, [sp, #8]
10006ec0:	ee06 1b4f 	vmls.f64	d1, d6, d15
10006ec4:	ed84 3b02 	vstr	d3, [r4, #8]
10006ec8:	ed9d 6b08 	vldr	d6, [sp, #32]
10006ecc:	ee2c 3b0e 	vmul.f64	d3, d12, d14
10006ed0:	ed84 1b00 	vstr	d1, [r4]
10006ed4:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006ed8:	ed81 6b06 	vstr	d6, [r1, #24]
10006edc:	ee28 6b0e 	vmul.f64	d6, d8, d14
10006ee0:	ed9d 2b00 	vldr	d2, [sp]
10006ee4:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10006ee8:	eefc 6bc6 	vcvt.u32.f64	s13, d6
10006eec:	ee03 cb4f 	vmls.f64	d12, d3, d15
10006ef0:	eeb8 3b66 	vcvt.f64.u32	d3, s13
10006ef4:	ee20 6b0e 	vmul.f64	d6, d0, d14
10006ef8:	ee24 1b0e 	vmul.f64	d1, d4, d14
10006efc:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006f00:	ee03 8b4f 	vmls.f64	d8, d3, d15
10006f04:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006f08:	ee25 3b0e 	vmul.f64	d3, d5, d14
10006f0c:	ee06 0b4f 	vmls.f64	d0, d6, d15
10006f10:	ee27 6b0e 	vmul.f64	d6, d7, d14
10006f14:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006f18:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10006f1c:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006f20:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10006f24:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10006f28:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006f2c:	ee01 4b4f 	vmls.f64	d4, d1, d15
10006f30:	ee03 5b4f 	vmls.f64	d5, d3, d15
10006f34:	ee06 7b4f 	vmls.f64	d7, d6, d15
10006f38:	3140      	adds	r1, #64	@ 0x40
10006f3a:	428f      	cmp	r7, r1
10006f3c:	f104 0440 	add.w	r4, r4, #64	@ 0x40
10006f40:	ed01 cb0c 	vstr	d12, [r1, #-48]	@ 0xffffffd0
10006f44:	f106 0610 	add.w	r6, r6, #16
10006f48:	ed04 db0a 	vstr	d13, [r4, #-40]	@ 0xffffffd8
10006f4c:	ed04 8b0c 	vstr	d8, [r4, #-48]	@ 0xffffffd0
10006f50:	f105 0520 	add.w	r5, r5, #32
10006f54:	ed01 9b06 	vstr	d9, [r1, #-24]	@ 0xffffffe8
10006f58:	ed01 0b08 	vstr	d0, [r1, #-32]	@ 0xffffffe0
10006f5c:	ed04 ab06 	vstr	d10, [r4, #-24]	@ 0xffffffe8
10006f60:	ed04 4b08 	vstr	d4, [r4, #-32]	@ 0xffffffe0
10006f64:	ed01 5b04 	vstr	d5, [r1, #-16]
10006f68:	ed01 bb02 	vstr	d11, [r1, #-8]
10006f6c:	ed04 2b02 	vstr	d2, [r4, #-8]
10006f70:	ed04 7b04 	vstr	d7, [r4, #-16]
10006f74:	f47f ac16 	bne.w	100067a4 <fndsa_vect_FFT_fp64_exact+0x33c>
10006f78:	b05f      	add	sp, #380	@ 0x17c
10006f7a:	ecbd 8b10 	vpop	{d8-d15}
10006f7e:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10006f82:	2803      	cmp	r0, #3
10006f84:	f1a0 0e02 	sub.w	lr, r0, #2
10006f88:	f47f aa81 	bne.w	1000648e <fndsa_vect_FFT_fp64_exact+0x26>
10006f8c:	4d01      	ldr	r5, [pc, #4]	@ (10006f94 <fndsa_vect_FFT_fp64_exact+0xb2c>)
10006f8e:	f7ff bbe8 	b.w	10006762 <fndsa_vect_FFT_fp64_exact+0x2fa>
10006f92:	bf00      	nop
10006f94:	300039a0 	.word	0x300039a0

