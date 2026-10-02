100064d0 <fndsa_vect_inv_mul2e_fft_fp64_exact>:
100064d0:	b5f0      	push	{r4, r5, r6, r7, lr}
100064d2:	2701      	movs	r7, #1
100064d4:	fa07 f202 	lsl.w	r2, r7, r2
100064d8:	ee07 2a90 	vmov	s15, r2
100064dc:	2410      	movs	r4, #16
100064de:	ed2d 8b10 	vpush	{d8-d15}
100064e2:	2600      	movs	r6, #0
100064e4:	ed9f fbf8 	vldr	d15, [pc, #992]	@ 100068c8 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x3f8>
100064e8:	ed9f ebf9 	vldr	d14, [pc, #996]	@ 100068d0 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x400>
100064ec:	460d      	mov	r5, r1
100064ee:	eeb8 bb67 	vcvt.f64.u32	d11, s15
100064f2:	3801      	subs	r0, #1
100064f4:	4084      	lsls	r4, r0
100064f6:	b091      	sub	sp, #68	@ 0x44
100064f8:	4087      	lsls	r7, r0
100064fa:	440c      	add	r4, r1
100064fc:	ed94 9b02 	vldr	d9, [r4, #8]
10006500:	ed95 3b00 	vldr	d3, [r5]
10006504:	ed95 6b02 	vldr	d6, [r5, #8]
10006508:	ee3f 9b49 	vsub.f64	d9, d15, d9
1000650c:	eebc abc3 	vcvt.u32.f64	s20, d3
10006510:	ed94 5b00 	vldr	d5, [r4]
10006514:	ee26 1b0e 	vmul.f64	d1, d6, d14
10006518:	ee29 2b0e 	vmul.f64	d2, d9, d14
1000651c:	ee1a 3a10 	vmov	r3, s20
10006520:	eeb7 4b00 	vmov.f64	d4, #112	@ 0x3f800000  1.0
10006524:	ed95 0b00 	vldr	d0, [r5]
10006528:	ee26 3b01 	vmul.f64	d3, d6, d1
1000652c:	ee3f 5b45 	vsub.f64	d5, d15, d5
10006530:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10006534:	0fdb      	lsrs	r3, r3, #31
10006536:	ed95 7b00 	vldr	d7, [r5]
1000653a:	ee35 5b44 	vsub.f64	d5, d5, d4
1000653e:	ee20 1b01 	vmul.f64	d1, d0, d1
10006542:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10006546:	ee0a 3a10 	vmov	s20, r3
1000654a:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000654e:	ee35 cb02 	vadd.f64	d12, d5, d2
10006552:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10006556:	ee27 7b0e 	vmul.f64	d7, d7, d14
1000655a:	eebc 1bc1 	vcvt.u32.f64	s2, d1
1000655e:	eeb8 abca 	vcvt.f64.s32	d10, s20
10006562:	ee02 9b4f 	vmls.f64	d9, d2, d15
10006566:	ee26 8b07 	vmul.f64	d8, d6, d7
1000656a:	ee23 2b4f 	vnmul.f64	d2, d3, d15
1000656e:	eea6 2b06 	vfma.f64	d2, d6, d6
10006572:	ee20 7b07 	vmul.f64	d7, d0, d7
10006576:	ee32 2b0f 	vadd.f64	d2, d2, d15
1000657a:	ee2a 0b06 	vmul.f64	d0, d10, d6
1000657e:	eeb8 ab41 	vcvt.f64.u32	d10, s2
10006582:	ee2c 1b0e 	vmul.f64	d1, d12, d14
10006586:	ee22 2b0e 	vmul.f64	d2, d2, d14
1000658a:	eebc 1bc1 	vcvt.u32.f64	s2, d1
1000658e:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10006592:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10006596:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000659a:	ee01 cb4f 	vmls.f64	d12, d1, d15
1000659e:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100065a2:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100065a6:	ee32 2b03 	vadd.f64	d2, d2, d3
100065aa:	eebc 3bcc 	vcvt.u32.f64	s6, d12
100065ae:	ed95 5b00 	vldr	d5, [r5]
100065b2:	ee27 7b4f 	vnmul.f64	d7, d7, d15
100065b6:	eea5 7b05 	vfma.f64	d7, d5, d5
100065ba:	ee37 7b0f 	vadd.f64	d7, d7, d15
100065be:	ee13 3a10 	vmov	r3, s6
100065c2:	ee27 5b0e 	vmul.f64	d5, d7, d14
100065c6:	0fdb      	lsrs	r3, r3, #31
100065c8:	ee03 3a10 	vmov	s6, r3
100065cc:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100065d0:	ee32 2b44 	vsub.f64	d2, d2, d4
100065d4:	eeb8 3bc3 	vcvt.f64.s32	d3, s6
100065d8:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100065dc:	ed8d 2b0c 	vstr	d2, [sp, #48]	@ 0x30
100065e0:	ee05 7b4f 	vmls.f64	d7, d5, d15
100065e4:	ee29 2b0e 	vmul.f64	d2, d9, d14
100065e8:	ee23 5b09 	vmul.f64	d5, d3, d9
100065ec:	eebc 8bc8 	vcvt.u32.f64	s16, d8
100065f0:	ed8d 5b06 	vstr	d5, [sp, #24]
100065f4:	ee2c 3b0e 	vmul.f64	d3, d12, d14
100065f8:	ee22 5b09 	vmul.f64	d5, d2, d9
100065fc:	ee22 2b0c 	vmul.f64	d2, d2, d12
10006600:	ed8d 0b08 	vstr	d0, [sp, #32]
10006604:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10006608:	ee23 0b09 	vmul.f64	d0, d3, d9
1000660c:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10006610:	ee23 3b0c 	vmul.f64	d3, d3, d12
10006614:	ed95 1b00 	vldr	d1, [r5]
10006618:	ed8d 7b0e 	vstr	d7, [sp, #56]	@ 0x38
1000661c:	eeb8 db42 	vcvt.f64.u32	d13, s4
10006620:	ee28 7b4f 	vnmul.f64	d7, d8, d15
10006624:	eea6 7b01 	vfma.f64	d7, d6, d1
10006628:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000662c:	ee2a 2b4f 	vnmul.f64	d2, d10, d15
10006630:	eea1 2b06 	vfma.f64	d2, d1, d6
10006634:	ee26 6b0b 	vmul.f64	d6, d6, d11
10006638:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000663c:	ed8d 6b0a 	vstr	d6, [sp, #40]	@ 0x28
10006640:	eeb8 6b43 	vcvt.f64.u32	d6, s6
10006644:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10006648:	eebc 0bc0 	vcvt.u32.f64	s0, d0
1000664c:	ee26 6b4f 	vnmul.f64	d6, d6, d15
10006650:	eeac 6b0c 	vfma.f64	d6, d12, d12
10006654:	ee36 3b0f 	vadd.f64	d3, d6, d15
10006658:	eeb8 0b40 	vcvt.f64.u32	d0, s0
1000665c:	ed8d 3b04 	vstr	d3, [sp, #16]
10006660:	ee25 3b4f 	vnmul.f64	d3, d5, d15
10006664:	eea9 3b09 	vfma.f64	d3, d9, d9
10006668:	ee33 3b0f 	vadd.f64	d3, d3, d15
1000666c:	ee20 1b4f 	vnmul.f64	d1, d0, d15
10006670:	eea9 1b0c 	vfma.f64	d1, d9, d12
10006674:	ee23 3b0e 	vmul.f64	d3, d3, d14
10006678:	ee31 1b0f 	vadd.f64	d1, d1, d15
1000667c:	ed8d 8b00 	vstr	d8, [sp]
10006680:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006684:	ee21 8b0e 	vmul.f64	d8, d1, d14
10006688:	ee37 7b0f 	vadd.f64	d7, d7, d15
1000668c:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10006690:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10006694:	ee27 6b0e 	vmul.f64	d6, d7, d14
10006698:	ee33 3b05 	vadd.f64	d3, d3, d5
1000669c:	eeb8 8b48 	vcvt.f64.u32	d8, s16
100066a0:	ee33 3b44 	vsub.f64	d3, d3, d4
100066a4:	ee32 2b0f 	vadd.f64	d2, d2, d15
100066a8:	ee08 1b4f 	vmls.f64	d1, d8, d15
100066ac:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100066b0:	ed8d ab02 	vstr	d10, [sp, #8]
100066b4:	ee33 1b01 	vadd.f64	d1, d3, d1
100066b8:	ed9d ab00 	vldr	d10, [sp]
100066bc:	ee22 3b0e 	vmul.f64	d3, d2, d14
100066c0:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100066c4:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100066c8:	ee06 7b4f 	vmls.f64	d7, d6, d15
100066cc:	ee3a 6b06 	vadd.f64	d6, d10, d6
100066d0:	ed9d ab0c 	vldr	d10, [sp, #48]	@ 0x30
100066d4:	ee2d 5b4f 	vnmul.f64	d5, d13, d15
100066d8:	eeac 5b09 	vfma.f64	d5, d12, d9
100066dc:	ee3a 7b07 	vadd.f64	d7, d10, d7
100066e0:	ee35 5b0f 	vadd.f64	d5, d5, d15
100066e4:	ed9d ab02 	vldr	d10, [sp, #8]
100066e8:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100066ec:	ee30 8b08 	vadd.f64	d8, d0, d8
100066f0:	ee03 2b4f 	vmls.f64	d2, d3, d15
100066f4:	ee25 0b0e 	vmul.f64	d0, d5, d14
100066f8:	ee3a 3b03 	vadd.f64	d3, d10, d3
100066fc:	ee36 6b44 	vsub.f64	d6, d6, d4
10006700:	ee33 3b44 	vsub.f64	d3, d3, d4
10006704:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10006708:	ee36 6b03 	vadd.f64	d6, d6, d3
1000670c:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10006710:	ed9d 3b0e 	vldr	d3, [sp, #56]	@ 0x38
10006714:	ee3d db00 	vadd.f64	d13, d13, d0
10006718:	ee33 6b06 	vadd.f64	d6, d3, d6
1000671c:	ed9d 3b04 	vldr	d3, [sp, #16]
10006720:	ee38 8b44 	vsub.f64	d8, d8, d4
10006724:	ee37 2b02 	vadd.f64	d2, d7, d2
10006728:	ee3d db44 	vsub.f64	d13, d13, d4
1000672c:	ee23 4b0e 	vmul.f64	d4, d3, d14
10006730:	ee22 7b0e 	vmul.f64	d7, d2, d14
10006734:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10006738:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000673c:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10006740:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006744:	ee04 3b4f 	vmls.f64	d3, d4, d15
10006748:	ee00 5b4f 	vmls.f64	d5, d0, d15
1000674c:	ee38 db0d 	vadd.f64	d13, d8, d13
10006750:	ee31 5b05 	vadd.f64	d5, d1, d5
10006754:	ee33 ab0d 	vadd.f64	d10, d3, d13
10006758:	ee36 6b07 	vadd.f64	d6, d6, d7
1000675c:	ed9f 3b5e 	vldr	d3, [pc, #376]	@ 100068d8 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x408>
10006760:	ee07 2b4f 	vmls.f64	d2, d7, d15
10006764:	ee25 4b0e 	vmul.f64	d4, d5, d14
10006768:	ed9d 7b08 	vldr	d7, [sp, #32]
1000676c:	ee36 6b03 	vadd.f64	d6, d6, d3
10006770:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10006774:	ee36 6b47 	vsub.f64	d6, d6, d7
10006778:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000677c:	ee36 6b47 	vsub.f64	d6, d6, d7
10006780:	ed9d 0b0a 	vldr	d0, [sp, #40]	@ 0x28
10006784:	ee3a ab04 	vadd.f64	d10, d10, d4
10006788:	ee20 7b0e 	vmul.f64	d7, d0, d14
1000678c:	ee04 5b4f 	vmls.f64	d5, d4, d15
10006790:	ee26 4b0e 	vmul.f64	d4, d6, d14
10006794:	ee35 5b02 	vadd.f64	d5, d5, d2
10006798:	ee3a ab03 	vadd.f64	d10, d10, d3
1000679c:	eebc 2bc7 	vcvt.u32.f64	s4, d7
100067a0:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100067a4:	ed9d 7b06 	vldr	d7, [sp, #24]
100067a8:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100067ac:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100067b0:	ee3a ab47 	vsub.f64	d10, d10, d7
100067b4:	ee04 6b4f 	vmls.f64	d6, d4, d15
100067b8:	ed95 8b00 	vldr	d8, [r5]
100067bc:	ee3a 7b47 	vsub.f64	d7, d10, d7
100067c0:	eeb0 4b42 	vmov.f64	d4, d2
100067c4:	ee27 1b0e 	vmul.f64	d1, d7, d14
100067c8:	ee08 4b0b 	vmla.f64	d4, d8, d11
100067cc:	ee02 0b4f 	vmls.f64	d0, d2, d15
100067d0:	eebc 1bc1 	vcvt.u32.f64	s2, d1
100067d4:	ee24 2b0e 	vmul.f64	d2, d4, d14
100067d8:	eefc 1bc0 	vcvt.u32.f64	s3, d0
100067dc:	ee25 3b0e 	vmul.f64	d3, d5, d14
100067e0:	ee11 0a90 	vmov	r0, s3
100067e4:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100067e8:	eeb8 1b41 	vcvt.f64.u32	d1, s2
100067ec:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100067f0:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100067f4:	ee01 7b4f 	vmls.f64	d7, d1, d15
100067f8:	ee02 4b4f 	vmls.f64	d4, d2, d15
100067fc:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10006800:	ee37 7b06 	vadd.f64	d7, d7, d6
10006804:	eefc 6bc4 	vcvt.u32.f64	s13, d4
10006808:	ee37 7b03 	vadd.f64	d7, d7, d3
1000680c:	ee16 1a90 	vmov	r1, s13
10006810:	ee27 6b0e 	vmul.f64	d6, d7, d14
10006814:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006818:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000681c:	ee03 5b4f 	vmls.f64	d5, d3, d15
10006820:	ee06 7b4f 	vmls.f64	d7, d6, d15
10006824:	eefc 5bc5 	vcvt.u32.f64	s11, d5
10006828:	eefc 7bc7 	vcvt.u32.f64	s15, d7
1000682c:	ee15 2a90 	vmov	r2, s11
10006830:	ee17 3a90 	vmov	r3, s15
10006834:	edcd 5a02 	vstr	s11, [sp, #8]
10006838:	edcd 7a00 	vstr	s15, [sp]
1000683c:	f7ff fc70 	bl	10006120 <fxr_div_fp64_exact>
10006840:	ee29 5b0b 	vmul.f64	d5, d9, d11
10006844:	ee25 7b0e 	vmul.f64	d7, d5, d14
10006848:	ee06 1a10 	vmov	s12, r1
1000684c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006850:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006854:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006858:	ed85 6b00 	vstr	d6, [r5]
1000685c:	eeb0 6b47 	vmov.f64	d6, d7
10006860:	ee0c 6b0b 	vmla.f64	d6, d12, d11
10006864:	ee07 5b4f 	vmls.f64	d5, d7, d15
10006868:	ee26 7b0e 	vmul.f64	d7, d6, d14
1000686c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006870:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006874:	ee04 0a10 	vmov	s8, r0
10006878:	ee07 6b4f 	vmls.f64	d6, d7, d15
1000687c:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10006880:	eefc 7bc6 	vcvt.u32.f64	s15, d6
10006884:	eefc 5bc5 	vcvt.u32.f64	s11, d5
10006888:	ed85 4b02 	vstr	d4, [r5, #8]
1000688c:	ee17 1a90 	vmov	r1, s15
10006890:	ee15 0a90 	vmov	r0, s11
10006894:	9a02      	ldr	r2, [sp, #8]
10006896:	9b00      	ldr	r3, [sp, #0]
10006898:	f7ff fc42 	bl	10006120 <fxr_div_fp64_exact>
1000689c:	ee06 0a10 	vmov	s12, r0
100068a0:	ee07 1a10 	vmov	s14, r1
100068a4:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100068a8:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100068ac:	3601      	adds	r6, #1
100068ae:	42b7      	cmp	r7, r6
100068b0:	f104 0410 	add.w	r4, r4, #16
100068b4:	f105 0510 	add.w	r5, r5, #16
100068b8:	ed04 6b02 	vstr	d6, [r4, #-8]
100068bc:	ed04 7b04 	vstr	d7, [r4, #-16]
100068c0:	f47f ae1c 	bne.w	100064fc <fndsa_vect_inv_mul2e_fft_fp64_exact+0x2c>
100068c4:	e00c      	b.n	100068e0 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x410>
100068c6:	bf00      	nop
100068c8:	00000000 	.word	0x00000000
100068cc:	41f00000 	.word	0x41f00000
100068d0:	00000000 	.word	0x00000000
100068d4:	3df00000 	.word	0x3df00000
100068d8:	00000000 	.word	0x00000000
100068dc:	42000000 	.word	0x42000000
100068e0:	b011      	add	sp, #68	@ 0x44
100068e2:	ecbd 8b10 	vpop	{d8-d15}
100068e6:	bdf0      	pop	{r4, r5, r6, r7, pc}

