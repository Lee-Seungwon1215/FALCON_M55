10005500 <fndsa_vect_inv_mul2e_fft_fp64_exact>:
10005500:	b5f0      	push	{r4, r5, r6, r7, lr}
10005502:	2701      	movs	r7, #1
10005504:	fa07 f202 	lsl.w	r2, r7, r2
10005508:	ee07 2a90 	vmov	s15, r2
1000550c:	ed2d 8b10 	vpush	{d8-d15}
10005510:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10005514:	2410      	movs	r4, #16
10005516:	b08f      	sub	sp, #60	@ 0x3c
10005518:	2600      	movs	r6, #0
1000551a:	ed9f 9bf3 	vldr	d9, [pc, #972]	@ 100058e8 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x3e8>
1000551e:	ed9f ebf4 	vldr	d14, [pc, #976]	@ 100058f0 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x3f0>
10005522:	ed9f bbf5 	vldr	d11, [pc, #980]	@ 100058f8 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x3f8>
10005526:	ed9f dbf6 	vldr	d13, [pc, #984]	@ 10005900 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x400>
1000552a:	ed9f cbf7 	vldr	d12, [pc, #988]	@ 10005908 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x408>
1000552e:	460d      	mov	r5, r1
10005530:	ed8d 7b02 	vstr	d7, [sp, #8]
10005534:	3801      	subs	r0, #1
10005536:	4084      	lsls	r4, r0
10005538:	4087      	lsls	r7, r0
1000553a:	440c      	add	r4, r1
1000553c:	ed95 0b00 	vldr	d0, [r5]
10005540:	ed94 fb02 	vldr	d15, [r4, #8]
10005544:	ed9f 6bf2 	vldr	d6, [pc, #968]	@ 10005910 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x410>
10005548:	ee39 fb4f 	vsub.f64	d15, d9, d15
1000554c:	ee20 4b06 	vmul.f64	d4, d0, d6
10005550:	eefc 6bc0 	vcvt.u32.f64	s13, d0
10005554:	ed94 3b00 	vldr	d3, [r4]
10005558:	ee16 3a90 	vmov	r3, s13
1000555c:	ee2f 6b0e 	vmul.f64	d6, d15, d14
10005560:	eeb7 1b00 	vmov.f64	d1, #112	@ 0x3f800000  1.0
10005564:	ee39 3b43 	vsub.f64	d3, d9, d3
10005568:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000556c:	0fdb      	lsrs	r3, r3, #31
1000556e:	ed95 7b02 	vldr	d7, [r5, #8]
10005572:	ee33 3b41 	vsub.f64	d3, d3, d1
10005576:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000557a:	ee01 3a10 	vmov	s2, r3
1000557e:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10005582:	ee33 ab06 	vadd.f64	d10, d3, d6
10005586:	ee27 5b0b 	vmul.f64	d5, d7, d11
1000558a:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000558e:	eeb8 1bc1 	vcvt.f64.s32	d1, s2
10005592:	eeb0 3b40 	vmov.f64	d3, d0
10005596:	ee21 2b07 	vmul.f64	d2, d1, d7
1000559a:	ee04 3b4c 	vmls.f64	d3, d4, d12
1000559e:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100055a2:	ed8d 2b08 	vstr	d2, [sp, #32]
100055a6:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100055aa:	eeb0 2b43 	vmov.f64	d2, d3
100055ae:	eeb0 3b47 	vmov.f64	d3, d7
100055b2:	ee05 3b4d 	vmls.f64	d3, d5, d13
100055b6:	ee06 fb49 	vmls.f64	d15, d6, d9
100055ba:	eeb0 6b43 	vmov.f64	d6, d3
100055be:	ed9f 3bd6 	vldr	d3, [pc, #856]	@ 10005918 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x418>
100055c2:	ee02 5b03 	vmla.f64	d5, d2, d3
100055c6:	ed9d 2b02 	vldr	d2, [sp, #8]
100055ca:	ee27 2b02 	vmul.f64	d2, d7, d2
100055ce:	ee2a 7b0e 	vmul.f64	d7, d10, d14
100055d2:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100055d6:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100055da:	ee2f 1b0b 	vmul.f64	d1, d15, d11
100055de:	ee07 ab49 	vmls.f64	d10, d7, d9
100055e2:	eebc 1bc1 	vcvt.u32.f64	s2, d1
100055e6:	ed8d ab00 	vstr	d10, [sp]
100055ea:	eeb8 8b41 	vcvt.f64.u32	d8, s2
100055ee:	ee26 7b06 	vmul.f64	d7, d6, d6
100055f2:	ee26 1b05 	vmul.f64	d1, d6, d5
100055f6:	ee26 3b04 	vmul.f64	d3, d6, d4
100055fa:	ee25 ab04 	vmul.f64	d10, d5, d4
100055fe:	eea5 1b06 	vfma.f64	d1, d5, d6
10005602:	eea5 3b05 	vfma.f64	d3, d5, d5
10005606:	eea4 ab05 	vfma.f64	d10, d4, d5
1000560a:	eea4 3b06 	vfma.f64	d3, d4, d6
1000560e:	ed9d 5b00 	vldr	d5, [sp]
10005612:	eebc 6bc5 	vcvt.u32.f64	s12, d5
10005616:	ee16 3a10 	vmov	r3, s12
1000561a:	0fdb      	lsrs	r3, r3, #31
1000561c:	ee06 3a10 	vmov	s12, r3
10005620:	ee27 7b0b 	vmul.f64	d7, d7, d11
10005624:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10005628:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000562c:	ee26 4b0f 	vmul.f64	d4, d6, d15
10005630:	ed9f 6bb7 	vldr	d6, [pc, #732]	@ 10005910 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x410>
10005634:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005638:	ee25 6b06 	vmul.f64	d6, d5, d6
1000563c:	eeb0 5b4f 	vmov.f64	d5, d15
10005640:	ee37 7b01 	vadd.f64	d7, d7, d1
10005644:	ee08 5b4d 	vmls.f64	d5, d8, d13
10005648:	ed8d 5b04 	vstr	d5, [sp, #16]
1000564c:	ee27 5b0b 	vmul.f64	d5, d7, d11
10005650:	ee22 1b0e 	vmul.f64	d1, d2, d14
10005654:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10005658:	eebc 1bc1 	vcvt.u32.f64	s2, d1
1000565c:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10005660:	ed8d 4b06 	vstr	d4, [sp, #24]
10005664:	ee33 3b05 	vadd.f64	d3, d3, d5
10005668:	ed9f 4bad 	vldr	d4, [pc, #692]	@ 10005920 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x420>
1000566c:	ee05 7b4d 	vmls.f64	d7, d5, d13
10005670:	eeb8 5b41 	vcvt.f64.u32	d5, s2
10005674:	ed8d ab0c 	vstr	d10, [sp, #48]	@ 0x30
10005678:	ee27 1b04 	vmul.f64	d1, d7, d4
1000567c:	ee05 2b49 	vmls.f64	d2, d5, d9
10005680:	ed9d 7b02 	vldr	d7, [sp, #8]
10005684:	eeb0 ab45 	vmov.f64	d10, d5
10005688:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000568c:	ee00 ab07 	vmla.f64	d10, d0, d7
10005690:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005694:	eefc 7bc2 	vcvt.u32.f64	s15, d2
10005698:	ed9d 2b00 	vldr	d2, [sp]
1000569c:	ed9f 0b9e 	vldr	d0, [pc, #632]	@ 10005918 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x418>
100056a0:	ee06 2b4c 	vmls.f64	d2, d6, d12
100056a4:	eebc 7bc1 	vcvt.u32.f64	s14, d1
100056a8:	ee02 8b00 	vmla.f64	d8, d2, d0
100056ac:	ed8d ab0a 	vstr	d10, [sp, #40]	@ 0x28
100056b0:	eeb0 5b48 	vmov.f64	d5, d8
100056b4:	ed9d ab04 	vldr	d10, [sp, #16]
100056b8:	ee17 0a90 	vmov	r0, s15
100056bc:	eeb8 8b47 	vcvt.f64.u32	d8, s14
100056c0:	ee2a 7b0a 	vmul.f64	d7, d10, d10
100056c4:	ee2a 1b05 	vmul.f64	d1, d10, d5
100056c8:	ee2a 2b06 	vmul.f64	d2, d10, d6
100056cc:	ee25 0b06 	vmul.f64	d0, d5, d6
100056d0:	eea5 1b0a 	vfma.f64	d1, d5, d10
100056d4:	eea5 2b05 	vfma.f64	d2, d5, d5
100056d8:	eea6 0b05 	vfma.f64	d0, d6, d5
100056dc:	eea6 2b0a 	vfma.f64	d2, d6, d10
100056e0:	ee27 7b0b 	vmul.f64	d7, d7, d11
100056e4:	ee23 5b0b 	vmul.f64	d5, d3, d11
100056e8:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100056ec:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100056f0:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100056f4:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100056f8:	ee37 7b01 	vadd.f64	d7, d7, d1
100056fc:	ed9d 1b0c 	vldr	d1, [sp, #48]	@ 0x30
10005700:	ee31 6b05 	vadd.f64	d6, d1, d5
10005704:	eeb0 1b43 	vmov.f64	d1, d3
10005708:	ee05 1b4d 	vmls.f64	d1, d5, d13
1000570c:	ee27 5b0b 	vmul.f64	d5, d7, d11
10005710:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10005714:	ee26 3b0b 	vmul.f64	d3, d6, d11
10005718:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000571c:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10005720:	ee05 7b4d 	vmls.f64	d7, d5, d13
10005724:	ee32 2b05 	vadd.f64	d2, d2, d5
10005728:	ee27 7b04 	vmul.f64	d7, d7, d4
1000572c:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10005730:	ed9f 4b77 	vldr	d4, [pc, #476]	@ 10005910 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x410>
10005734:	ee03 6b4d 	vmls.f64	d6, d3, d13
10005738:	ee22 5b0b 	vmul.f64	d5, d2, d11
1000573c:	ee21 3b04 	vmul.f64	d3, d1, d4
10005740:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10005744:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10005748:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000574c:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10005750:	ee05 2b4d 	vmls.f64	d2, d5, d13
10005754:	ee03 1b4c 	vmls.f64	d1, d3, d12
10005758:	eeb0 ab44 	vmov.f64	d10, d4
1000575c:	ee30 4b05 	vadd.f64	d4, d0, d5
10005760:	ed9f 0b6d 	vldr	d0, [pc, #436]	@ 10005918 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x418>
10005764:	eeb0 5b43 	vmov.f64	d5, d3
10005768:	ee01 8b0c 	vmla.f64	d8, d1, d12
1000576c:	ee06 5b00 	vmla.f64	d5, d6, d0
10005770:	ed9f 1b6d 	vldr	d1, [pc, #436]	@ 10005928 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x428>
10005774:	ed9d 6b08 	vldr	d6, [sp, #32]
10005778:	ee35 5b01 	vadd.f64	d5, d5, d1
1000577c:	ee35 5b46 	vsub.f64	d5, d5, d6
10005780:	ee22 3b0a 	vmul.f64	d3, d2, d10
10005784:	ee35 5b46 	vsub.f64	d5, d5, d6
10005788:	ee24 6b0b 	vmul.f64	d6, d4, d11
1000578c:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10005790:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10005794:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10005798:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000579c:	ee06 4b4d 	vmls.f64	d4, d6, d13
100057a0:	eeb0 6b43 	vmov.f64	d6, d3
100057a4:	ee04 6b00 	vmla.f64	d6, d4, d0
100057a8:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100057ac:	ed9d 4b06 	vldr	d4, [sp, #24]
100057b0:	ee36 6b01 	vadd.f64	d6, d6, d1
100057b4:	ee03 2b4c 	vmls.f64	d2, d3, d12
100057b8:	ee36 6b44 	vsub.f64	d6, d6, d4
100057bc:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100057c0:	ee36 6b44 	vsub.f64	d6, d6, d4
100057c4:	ee02 7b0c 	vmla.f64	d7, d2, d12
100057c8:	ee26 1b0e 	vmul.f64	d1, d6, d14
100057cc:	ee25 2b0e 	vmul.f64	d2, d5, d14
100057d0:	ee37 7b08 	vadd.f64	d7, d7, d8
100057d4:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100057d8:	ee27 4b0e 	vmul.f64	d4, d7, d14
100057dc:	eebc 1bc1 	vcvt.u32.f64	s2, d1
100057e0:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100057e4:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100057e8:	eeb8 1b41 	vcvt.f64.u32	d1, s2
100057ec:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100057f0:	ee02 5b49 	vmls.f64	d5, d2, d9
100057f4:	ee01 6b49 	vmls.f64	d6, d1, d9
100057f8:	ee04 7b49 	vmls.f64	d7, d4, d9
100057fc:	ee36 6b05 	vadd.f64	d6, d6, d5
10005800:	ed9d 0b0a 	vldr	d0, [sp, #40]	@ 0x28
10005804:	ee36 6b04 	vadd.f64	d6, d6, d4
10005808:	eefc 7bc7 	vcvt.u32.f64	s15, d7
1000580c:	ee20 3b0e 	vmul.f64	d3, d0, d14
10005810:	ee17 2a90 	vmov	r2, s15
10005814:	edcd 7a06 	vstr	s15, [sp, #24]
10005818:	ee26 7b0e 	vmul.f64	d7, d6, d14
1000581c:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10005820:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005824:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10005828:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000582c:	eeb0 5b40 	vmov.f64	d5, d0
10005830:	ee07 6b49 	vmls.f64	d6, d7, d9
10005834:	ee03 5b49 	vmls.f64	d5, d3, d9
10005838:	eefc 7bc6 	vcvt.u32.f64	s15, d6
1000583c:	eefc 5bc5 	vcvt.u32.f64	s11, d5
10005840:	ee17 3a90 	vmov	r3, s15
10005844:	ee15 1a90 	vmov	r1, s11
10005848:	edcd 7a04 	vstr	s15, [sp, #16]
1000584c:	f7ff fc80 	bl	10005150 <fxr_div_fp64_exact>
10005850:	ed9d 3b02 	vldr	d3, [sp, #8]
10005854:	ee2f 5b03 	vmul.f64	d5, d15, d3
10005858:	ee25 7b0e 	vmul.f64	d7, d5, d14
1000585c:	ee04 0a10 	vmov	s8, r0
10005860:	ee06 1a10 	vmov	s12, r1
10005864:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005868:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000586c:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005870:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005874:	ed85 4b02 	vstr	d4, [r5, #8]
10005878:	ed85 6b00 	vstr	d6, [r5]
1000587c:	ed9d 4b00 	vldr	d4, [sp]
10005880:	eeb0 6b47 	vmov.f64	d6, d7
10005884:	ee04 6b03 	vmla.f64	d6, d4, d3
10005888:	ee07 5b49 	vmls.f64	d5, d7, d9
1000588c:	ee26 7b0e 	vmul.f64	d7, d6, d14
10005890:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005894:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005898:	ee07 6b49 	vmls.f64	d6, d7, d9
1000589c:	eefc 5bc5 	vcvt.u32.f64	s11, d5
100058a0:	eefc 7bc6 	vcvt.u32.f64	s15, d6
100058a4:	ee15 0a90 	vmov	r0, s11
100058a8:	ee17 1a90 	vmov	r1, s15
100058ac:	9a06      	ldr	r2, [sp, #24]
100058ae:	9b04      	ldr	r3, [sp, #16]
100058b0:	f7ff fc4e 	bl	10005150 <fxr_div_fp64_exact>
100058b4:	ee06 0a10 	vmov	s12, r0
100058b8:	ee07 1a10 	vmov	s14, r1
100058bc:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100058c0:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100058c4:	3601      	adds	r6, #1
100058c6:	42b7      	cmp	r7, r6
100058c8:	f104 0410 	add.w	r4, r4, #16
100058cc:	f105 0510 	add.w	r5, r5, #16
100058d0:	ed04 6b02 	vstr	d6, [r4, #-8]
100058d4:	ed04 7b04 	vstr	d7, [r4, #-16]
100058d8:	f47f ae30 	bne.w	1000553c <fndsa_vect_inv_mul2e_fft_fp64_exact+0x3c>
100058dc:	b00f      	add	sp, #60	@ 0x3c
100058de:	ecbd 8b10 	vpop	{d8-d15}
100058e2:	bdf0      	pop	{r4, r5, r6, r7, pc}
100058e4:	f3af 8000 	nop.w
100058e8:	00000000 	.word	0x00000000
100058ec:	41f00000 	.word	0x41f00000
100058f0:	00000000 	.word	0x00000000
100058f4:	3df00000 	.word	0x3df00000
100058f8:	00000000 	.word	0x00000000
100058fc:	3e700000 	.word	0x3e700000
10005900:	00000000 	.word	0x00000000
10005904:	41700000 	.word	0x41700000
10005908:	00000000 	.word	0x00000000
1000590c:	40f00000 	.word	0x40f00000
10005910:	00000000 	.word	0x00000000
10005914:	3ef00000 	.word	0x3ef00000
10005918:	00000000 	.word	0x00000000
1000591c:	40700000 	.word	0x40700000
10005920:	00000000 	.word	0x00000000
10005924:	3f700000 	.word	0x3f700000
10005928:	00000000 	.word	0x00000000
1000592c:	42000000 	.word	0x42000000

