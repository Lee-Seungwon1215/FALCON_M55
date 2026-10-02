100054f0 <fndsa_vect_inv_mul2e_fft_fp64_exact>:
100054f0:	b5f0      	push	{r4, r5, r6, r7, lr}
100054f2:	2701      	movs	r7, #1
100054f4:	fa07 f202 	lsl.w	r2, r7, r2
100054f8:	ee07 2a90 	vmov	s15, r2
100054fc:	2410      	movs	r4, #16
100054fe:	ed2d 8b10 	vpush	{d8-d15}
10005502:	2600      	movs	r6, #0
10005504:	ed9f fbf8 	vldr	d15, [pc, #992]	@ 100058e8 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x3f8>
10005508:	ed9f ebf9 	vldr	d14, [pc, #996]	@ 100058f0 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x400>
1000550c:	460d      	mov	r5, r1
1000550e:	eeb8 bb67 	vcvt.f64.u32	d11, s15
10005512:	3801      	subs	r0, #1
10005514:	4084      	lsls	r4, r0
10005516:	b091      	sub	sp, #68	@ 0x44
10005518:	4087      	lsls	r7, r0
1000551a:	440c      	add	r4, r1
1000551c:	ed94 9b02 	vldr	d9, [r4, #8]
10005520:	ed95 3b00 	vldr	d3, [r5]
10005524:	ed95 6b02 	vldr	d6, [r5, #8]
10005528:	ee3f 9b49 	vsub.f64	d9, d15, d9
1000552c:	eebc abc3 	vcvt.u32.f64	s20, d3
10005530:	ed94 5b00 	vldr	d5, [r4]
10005534:	ee26 1b0e 	vmul.f64	d1, d6, d14
10005538:	ee29 2b0e 	vmul.f64	d2, d9, d14
1000553c:	ee1a 3a10 	vmov	r3, s20
10005540:	eeb7 4b00 	vmov.f64	d4, #112	@ 0x3f800000  1.0
10005544:	ed95 0b00 	vldr	d0, [r5]
10005548:	ee26 3b01 	vmul.f64	d3, d6, d1
1000554c:	ee3f 5b45 	vsub.f64	d5, d15, d5
10005550:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10005554:	0fdb      	lsrs	r3, r3, #31
10005556:	ed95 7b00 	vldr	d7, [r5]
1000555a:	ee35 5b44 	vsub.f64	d5, d5, d4
1000555e:	ee20 1b01 	vmul.f64	d1, d0, d1
10005562:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10005566:	ee0a 3a10 	vmov	s20, r3
1000556a:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000556e:	ee35 cb02 	vadd.f64	d12, d5, d2
10005572:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10005576:	ee27 7b0e 	vmul.f64	d7, d7, d14
1000557a:	eebc 1bc1 	vcvt.u32.f64	s2, d1
1000557e:	eeb8 abca 	vcvt.f64.s32	d10, s20
10005582:	ee02 9b4f 	vmls.f64	d9, d2, d15
10005586:	ee26 8b07 	vmul.f64	d8, d6, d7
1000558a:	ee23 2b4f 	vnmul.f64	d2, d3, d15
1000558e:	eea6 2b06 	vfma.f64	d2, d6, d6
10005592:	ee20 7b07 	vmul.f64	d7, d0, d7
10005596:	ee32 2b0f 	vadd.f64	d2, d2, d15
1000559a:	ee2a 0b06 	vmul.f64	d0, d10, d6
1000559e:	eeb8 ab41 	vcvt.f64.u32	d10, s2
100055a2:	ee2c 1b0e 	vmul.f64	d1, d12, d14
100055a6:	ee22 2b0e 	vmul.f64	d2, d2, d14
100055aa:	eebc 1bc1 	vcvt.u32.f64	s2, d1
100055ae:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100055b2:	eeb8 1b41 	vcvt.f64.u32	d1, s2
100055b6:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100055ba:	ee01 cb4f 	vmls.f64	d12, d1, d15
100055be:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100055c2:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100055c6:	ee32 2b03 	vadd.f64	d2, d2, d3
100055ca:	eebc 3bcc 	vcvt.u32.f64	s6, d12
100055ce:	ed95 5b00 	vldr	d5, [r5]
100055d2:	ee27 7b4f 	vnmul.f64	d7, d7, d15
100055d6:	eea5 7b05 	vfma.f64	d7, d5, d5
100055da:	ee37 7b0f 	vadd.f64	d7, d7, d15
100055de:	ee13 3a10 	vmov	r3, s6
100055e2:	ee27 5b0e 	vmul.f64	d5, d7, d14
100055e6:	0fdb      	lsrs	r3, r3, #31
100055e8:	ee03 3a10 	vmov	s6, r3
100055ec:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100055f0:	ee32 2b44 	vsub.f64	d2, d2, d4
100055f4:	eeb8 3bc3 	vcvt.f64.s32	d3, s6
100055f8:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100055fc:	ed8d 2b0c 	vstr	d2, [sp, #48]	@ 0x30
10005600:	ee05 7b4f 	vmls.f64	d7, d5, d15
10005604:	ee29 2b0e 	vmul.f64	d2, d9, d14
10005608:	ee23 5b09 	vmul.f64	d5, d3, d9
1000560c:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10005610:	ed8d 5b06 	vstr	d5, [sp, #24]
10005614:	ee2c 3b0e 	vmul.f64	d3, d12, d14
10005618:	ee22 5b09 	vmul.f64	d5, d2, d9
1000561c:	ee22 2b0c 	vmul.f64	d2, d2, d12
10005620:	ed8d 0b08 	vstr	d0, [sp, #32]
10005624:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10005628:	ee23 0b09 	vmul.f64	d0, d3, d9
1000562c:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10005630:	ee23 3b0c 	vmul.f64	d3, d3, d12
10005634:	ed95 1b00 	vldr	d1, [r5]
10005638:	ed8d 7b0e 	vstr	d7, [sp, #56]	@ 0x38
1000563c:	eeb8 db42 	vcvt.f64.u32	d13, s4
10005640:	ee28 7b4f 	vnmul.f64	d7, d8, d15
10005644:	eea6 7b01 	vfma.f64	d7, d6, d1
10005648:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000564c:	ee2a 2b4f 	vnmul.f64	d2, d10, d15
10005650:	eea1 2b06 	vfma.f64	d2, d1, d6
10005654:	ee26 6b0b 	vmul.f64	d6, d6, d11
10005658:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000565c:	ed8d 6b0a 	vstr	d6, [sp, #40]	@ 0x28
10005660:	eeb8 6b43 	vcvt.f64.u32	d6, s6
10005664:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10005668:	eebc 0bc0 	vcvt.u32.f64	s0, d0
1000566c:	ee26 6b4f 	vnmul.f64	d6, d6, d15
10005670:	eeac 6b0c 	vfma.f64	d6, d12, d12
10005674:	ee36 3b0f 	vadd.f64	d3, d6, d15
10005678:	eeb8 0b40 	vcvt.f64.u32	d0, s0
1000567c:	ed8d 3b04 	vstr	d3, [sp, #16]
10005680:	ee25 3b4f 	vnmul.f64	d3, d5, d15
10005684:	eea9 3b09 	vfma.f64	d3, d9, d9
10005688:	ee33 3b0f 	vadd.f64	d3, d3, d15
1000568c:	ee20 1b4f 	vnmul.f64	d1, d0, d15
10005690:	eea9 1b0c 	vfma.f64	d1, d9, d12
10005694:	ee23 3b0e 	vmul.f64	d3, d3, d14
10005698:	ee31 1b0f 	vadd.f64	d1, d1, d15
1000569c:	ed8d 8b00 	vstr	d8, [sp]
100056a0:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100056a4:	ee21 8b0e 	vmul.f64	d8, d1, d14
100056a8:	ee37 7b0f 	vadd.f64	d7, d7, d15
100056ac:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100056b0:	eebc 8bc8 	vcvt.u32.f64	s16, d8
100056b4:	ee27 6b0e 	vmul.f64	d6, d7, d14
100056b8:	ee33 3b05 	vadd.f64	d3, d3, d5
100056bc:	eeb8 8b48 	vcvt.f64.u32	d8, s16
100056c0:	ee33 3b44 	vsub.f64	d3, d3, d4
100056c4:	ee32 2b0f 	vadd.f64	d2, d2, d15
100056c8:	ee08 1b4f 	vmls.f64	d1, d8, d15
100056cc:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100056d0:	ed8d ab02 	vstr	d10, [sp, #8]
100056d4:	ee33 1b01 	vadd.f64	d1, d3, d1
100056d8:	ed9d ab00 	vldr	d10, [sp]
100056dc:	ee22 3b0e 	vmul.f64	d3, d2, d14
100056e0:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100056e4:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100056e8:	ee06 7b4f 	vmls.f64	d7, d6, d15
100056ec:	ee3a 6b06 	vadd.f64	d6, d10, d6
100056f0:	ed9d ab0c 	vldr	d10, [sp, #48]	@ 0x30
100056f4:	ee2d 5b4f 	vnmul.f64	d5, d13, d15
100056f8:	eeac 5b09 	vfma.f64	d5, d12, d9
100056fc:	ee3a 7b07 	vadd.f64	d7, d10, d7
10005700:	ee35 5b0f 	vadd.f64	d5, d5, d15
10005704:	ed9d ab02 	vldr	d10, [sp, #8]
10005708:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000570c:	ee30 8b08 	vadd.f64	d8, d0, d8
10005710:	ee03 2b4f 	vmls.f64	d2, d3, d15
10005714:	ee25 0b0e 	vmul.f64	d0, d5, d14
10005718:	ee3a 3b03 	vadd.f64	d3, d10, d3
1000571c:	ee36 6b44 	vsub.f64	d6, d6, d4
10005720:	ee33 3b44 	vsub.f64	d3, d3, d4
10005724:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10005728:	ee36 6b03 	vadd.f64	d6, d6, d3
1000572c:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10005730:	ed9d 3b0e 	vldr	d3, [sp, #56]	@ 0x38
10005734:	ee3d db00 	vadd.f64	d13, d13, d0
10005738:	ee33 6b06 	vadd.f64	d6, d3, d6
1000573c:	ed9d 3b04 	vldr	d3, [sp, #16]
10005740:	ee38 8b44 	vsub.f64	d8, d8, d4
10005744:	ee37 2b02 	vadd.f64	d2, d7, d2
10005748:	ee3d db44 	vsub.f64	d13, d13, d4
1000574c:	ee23 4b0e 	vmul.f64	d4, d3, d14
10005750:	ee22 7b0e 	vmul.f64	d7, d2, d14
10005754:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10005758:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000575c:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10005760:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005764:	ee04 3b4f 	vmls.f64	d3, d4, d15
10005768:	ee00 5b4f 	vmls.f64	d5, d0, d15
1000576c:	ee38 db0d 	vadd.f64	d13, d8, d13
10005770:	ee31 5b05 	vadd.f64	d5, d1, d5
10005774:	ee33 ab0d 	vadd.f64	d10, d3, d13
10005778:	ee36 6b07 	vadd.f64	d6, d6, d7
1000577c:	ed9f 3b5e 	vldr	d3, [pc, #376]	@ 100058f8 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x408>
10005780:	ee07 2b4f 	vmls.f64	d2, d7, d15
10005784:	ee25 4b0e 	vmul.f64	d4, d5, d14
10005788:	ed9d 7b08 	vldr	d7, [sp, #32]
1000578c:	ee36 6b03 	vadd.f64	d6, d6, d3
10005790:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10005794:	ee36 6b47 	vsub.f64	d6, d6, d7
10005798:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000579c:	ee36 6b47 	vsub.f64	d6, d6, d7
100057a0:	ed9d 0b0a 	vldr	d0, [sp, #40]	@ 0x28
100057a4:	ee3a ab04 	vadd.f64	d10, d10, d4
100057a8:	ee20 7b0e 	vmul.f64	d7, d0, d14
100057ac:	ee04 5b4f 	vmls.f64	d5, d4, d15
100057b0:	ee26 4b0e 	vmul.f64	d4, d6, d14
100057b4:	ee35 5b02 	vadd.f64	d5, d5, d2
100057b8:	ee3a ab03 	vadd.f64	d10, d10, d3
100057bc:	eebc 2bc7 	vcvt.u32.f64	s4, d7
100057c0:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100057c4:	ed9d 7b06 	vldr	d7, [sp, #24]
100057c8:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100057cc:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100057d0:	ee3a ab47 	vsub.f64	d10, d10, d7
100057d4:	ee04 6b4f 	vmls.f64	d6, d4, d15
100057d8:	ed95 8b00 	vldr	d8, [r5]
100057dc:	ee3a 7b47 	vsub.f64	d7, d10, d7
100057e0:	eeb0 4b42 	vmov.f64	d4, d2
100057e4:	ee27 1b0e 	vmul.f64	d1, d7, d14
100057e8:	ee08 4b0b 	vmla.f64	d4, d8, d11
100057ec:	ee02 0b4f 	vmls.f64	d0, d2, d15
100057f0:	eebc 1bc1 	vcvt.u32.f64	s2, d1
100057f4:	ee24 2b0e 	vmul.f64	d2, d4, d14
100057f8:	eefc 1bc0 	vcvt.u32.f64	s3, d0
100057fc:	ee25 3b0e 	vmul.f64	d3, d5, d14
10005800:	ee11 0a90 	vmov	r0, s3
10005804:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10005808:	eeb8 1b41 	vcvt.f64.u32	d1, s2
1000580c:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10005810:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10005814:	ee01 7b4f 	vmls.f64	d7, d1, d15
10005818:	ee02 4b4f 	vmls.f64	d4, d2, d15
1000581c:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10005820:	ee37 7b06 	vadd.f64	d7, d7, d6
10005824:	eefc 6bc4 	vcvt.u32.f64	s13, d4
10005828:	ee37 7b03 	vadd.f64	d7, d7, d3
1000582c:	ee16 1a90 	vmov	r1, s13
10005830:	ee27 6b0e 	vmul.f64	d6, d7, d14
10005834:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10005838:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000583c:	ee03 5b4f 	vmls.f64	d5, d3, d15
10005840:	ee06 7b4f 	vmls.f64	d7, d6, d15
10005844:	eefc 5bc5 	vcvt.u32.f64	s11, d5
10005848:	eefc 7bc7 	vcvt.u32.f64	s15, d7
1000584c:	ee15 2a90 	vmov	r2, s11
10005850:	ee17 3a90 	vmov	r3, s15
10005854:	edcd 5a02 	vstr	s11, [sp, #8]
10005858:	edcd 7a00 	vstr	s15, [sp]
1000585c:	f7ff fc70 	bl	10005140 <fxr_div_fp64_exact>
10005860:	ee29 5b0b 	vmul.f64	d5, d9, d11
10005864:	ee25 7b0e 	vmul.f64	d7, d5, d14
10005868:	ee06 1a10 	vmov	s12, r1
1000586c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005870:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005874:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005878:	ed85 6b00 	vstr	d6, [r5]
1000587c:	eeb0 6b47 	vmov.f64	d6, d7
10005880:	ee0c 6b0b 	vmla.f64	d6, d12, d11
10005884:	ee07 5b4f 	vmls.f64	d5, d7, d15
10005888:	ee26 7b0e 	vmul.f64	d7, d6, d14
1000588c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005890:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005894:	ee04 0a10 	vmov	s8, r0
10005898:	ee07 6b4f 	vmls.f64	d6, d7, d15
1000589c:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100058a0:	eefc 7bc6 	vcvt.u32.f64	s15, d6
100058a4:	eefc 5bc5 	vcvt.u32.f64	s11, d5
100058a8:	ed85 4b02 	vstr	d4, [r5, #8]
100058ac:	ee17 1a90 	vmov	r1, s15
100058b0:	ee15 0a90 	vmov	r0, s11
100058b4:	9a02      	ldr	r2, [sp, #8]
100058b6:	9b00      	ldr	r3, [sp, #0]
100058b8:	f7ff fc42 	bl	10005140 <fxr_div_fp64_exact>
100058bc:	ee06 0a10 	vmov	s12, r0
100058c0:	ee07 1a10 	vmov	s14, r1
100058c4:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100058c8:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100058cc:	3601      	adds	r6, #1
100058ce:	42b7      	cmp	r7, r6
100058d0:	f104 0410 	add.w	r4, r4, #16
100058d4:	f105 0510 	add.w	r5, r5, #16
100058d8:	ed04 6b02 	vstr	d6, [r4, #-8]
100058dc:	ed04 7b04 	vstr	d7, [r4, #-16]
100058e0:	f47f ae1c 	bne.w	1000551c <fndsa_vect_inv_mul2e_fft_fp64_exact+0x2c>
100058e4:	e00c      	b.n	10005900 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x410>
100058e6:	bf00      	nop
100058e8:	00000000 	.word	0x00000000
100058ec:	41f00000 	.word	0x41f00000
100058f0:	00000000 	.word	0x00000000
100058f4:	3df00000 	.word	0x3df00000
100058f8:	00000000 	.word	0x00000000
100058fc:	42000000 	.word	0x42000000
10005900:	b011      	add	sp, #68	@ 0x44
10005902:	ecbd 8b10 	vpop	{d8-d15}
10005906:	bdf0      	pop	{r4, r5, r6, r7, pc}

