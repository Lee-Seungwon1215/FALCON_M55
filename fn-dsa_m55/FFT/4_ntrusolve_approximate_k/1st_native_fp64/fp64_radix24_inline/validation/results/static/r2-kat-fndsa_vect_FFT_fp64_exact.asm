
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/r2-kat/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10005520 <fndsa_vect_FFT_fp64_exact>:
10005520:	2801      	cmp	r0, #1
10005522:	f240 8263 	bls.w	100059ec <fndsa_vect_FFT_fp64_exact+0x4cc>
10005526:	2201      	movs	r2, #1
10005528:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
1000552c:	ed2d 8b10 	vpush	{d8-d15}
10005530:	2310      	movs	r3, #16
10005532:	460e      	mov	r6, r1
10005534:	ed9f cb6c 	vldr	d12, [pc, #432]	@ 100056e8 <fndsa_vect_FFT_fp64_exact+0x1c8>
10005538:	ed9f bb6d 	vldr	d11, [pc, #436]	@ 100056f0 <fndsa_vect_FFT_fp64_exact+0x1d0>
1000553c:	4614      	mov	r4, r2
1000553e:	b0d7      	sub	sp, #348	@ 0x15c
10005540:	9113      	str	r1, [sp, #76]	@ 0x4c
10005542:	1e41      	subs	r1, r0, #1
10005544:	408b      	lsls	r3, r1
10005546:	18f7      	adds	r7, r6, r3
10005548:	e9cd 7016 	strd	r7, r0, [sp, #88]	@ 0x58
1000554c:	fa02 fe01 	lsl.w	lr, r2, r1
10005550:	2701      	movs	r7, #1
10005552:	2310      	movs	r3, #16
10005554:	2200      	movs	r2, #0
10005556:	9d13      	ldr	r5, [sp, #76]	@ 0x4c
10005558:	4670      	mov	r0, lr
1000555a:	fa2e fe07 	lsr.w	lr, lr, r7
1000555e:	ea4f 1c0e 	mov.w	ip, lr, lsl #4
10005562:	eb05 1b0e 	add.w	fp, r5, lr, lsl #4
10005566:	f10c 0508 	add.w	r5, ip, #8
1000556a:	9514      	str	r5, [sp, #80]	@ 0x50
1000556c:	40a7      	lsls	r7, r4
1000556e:	4d6c      	ldr	r5, [pc, #432]	@ (10005720 <fndsa_vect_FFT_fp64_exact+0x200>)
10005570:	40a3      	lsls	r3, r4
10005572:	eb07 0757 	add.w	r7, r7, r7, lsr #1
10005576:	442b      	add	r3, r5
10005578:	eb05 1507 	add.w	r5, r5, r7, lsl #4
1000557c:	e9cd e511 	strd	lr, r5, [sp, #68]	@ 0x44
10005580:	9916      	ldr	r1, [sp, #88]	@ 0x58
10005582:	f10d 0aa0 	add.w	sl, sp, #160	@ 0xa0
10005586:	9415      	str	r4, [sp, #84]	@ 0x54
10005588:	edd3 7a00 	vldr	s15, [r3]
1000558c:	eeb8 9b67 	vcvt.f64.u32	d9, s15
10005590:	edd3 7a02 	vldr	s15, [r3, #8]
10005594:	eeb8 4b67 	vcvt.f64.u32	d4, s15
10005598:	edd3 7a01 	vldr	s15, [r3, #4]
1000559c:	eeb8 8b67 	vcvt.f64.u32	d8, s15
100055a0:	edd3 7a03 	vldr	s15, [r3, #12]
100055a4:	685c      	ldr	r4, [r3, #4]
100055a6:	ed9f ab54 	vldr	d10, [pc, #336]	@ 100056f8 <fndsa_vect_FFT_fp64_exact+0x1d8>
100055aa:	0fe4      	lsrs	r4, r4, #31
100055ac:	ee06 4a10 	vmov	s12, r4
100055b0:	ee17 4a90 	vmov	r4, s15
100055b4:	0fe4      	lsrs	r4, r4, #31
100055b6:	ee29 3b0a 	vmul.f64	d3, d9, d10
100055ba:	ee07 4a10 	vmov	s14, r4
100055be:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
100055c2:	eeb8 0b67 	vcvt.f64.u32	d0, s15
100055c6:	ed8d 6b40 	vstr	d6, [sp, #256]	@ 0x100
100055ca:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100055ce:	ee39 6b04 	vadd.f64	d6, d9, d4
100055d2:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100055d6:	ed9f db4a 	vldr	d13, [pc, #296]	@ 10005700 <fndsa_vect_FFT_fp64_exact+0x1e0>
100055da:	ed9f eb4b 	vldr	d14, [pc, #300]	@ 10005708 <fndsa_vect_FFT_fp64_exact+0x1e8>
100055de:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100055e2:	ed8d 7b4a 	vstr	d7, [sp, #296]	@ 0x128
100055e6:	ee26 7b0c 	vmul.f64	d7, d6, d12
100055ea:	ee20 2b0d 	vmul.f64	d2, d0, d13
100055ee:	ee24 5b0a 	vmul.f64	d5, d4, d10
100055f2:	ed8d 9b3e 	vstr	d9, [sp, #248]	@ 0xf8
100055f6:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100055fa:	ee03 9b4e 	vmls.f64	d9, d3, d14
100055fe:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005602:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10005606:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000560a:	ed8d 9b38 	vstr	d9, [sp, #224]	@ 0xe0
1000560e:	ee38 9b00 	vadd.f64	d9, d8, d0
10005612:	ee07 6b4b 	vmls.f64	d6, d7, d11
10005616:	eeb8 2b42 	vcvt.f64.u32	d2, s4
1000561a:	ee39 7b07 	vadd.f64	d7, d9, d7
1000561e:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10005622:	ed9f 9b3b 	vldr	d9, [pc, #236]	@ 10005710 <fndsa_vect_FFT_fp64_exact+0x1f0>
10005626:	ed9f fb3c 	vldr	d15, [pc, #240]	@ 10005718 <fndsa_vect_FFT_fp64_exact+0x1f8>
1000562a:	ee02 0b49 	vmls.f64	d0, d2, d9
1000562e:	ed8d 4b48 	vstr	d4, [sp, #288]	@ 0x120
10005632:	ee05 4b4e 	vmls.f64	d4, d5, d14
10005636:	ee00 5b0f 	vmla.f64	d5, d0, d15
1000563a:	ed8d 4b42 	vstr	d4, [sp, #264]	@ 0x108
1000563e:	ee27 4b0c 	vmul.f64	d4, d7, d12
10005642:	ed8d 5b44 	vstr	d5, [sp, #272]	@ 0x110
10005646:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000564a:	ee26 5b0a 	vmul.f64	d5, d6, d10
1000564e:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10005652:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10005656:	ee04 7b4b 	vmls.f64	d7, d4, d11
1000565a:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000565e:	ee27 4b0d 	vmul.f64	d4, d7, d13
10005662:	ee28 1b0d 	vmul.f64	d1, d8, d13
10005666:	ed8d 6b52 	vstr	d6, [sp, #328]	@ 0x148
1000566a:	ee05 6b4e 	vmls.f64	d6, d5, d14
1000566e:	ed8d 2b46 	vstr	d2, [sp, #280]	@ 0x118
10005672:	eefc 2bc7 	vcvt.u32.f64	s5, d7
10005676:	ed8d 6b4c 	vstr	d6, [sp, #304]	@ 0x130
1000567a:	eebc 1bc1 	vcvt.u32.f64	s2, d1
1000567e:	eebc 6bc4 	vcvt.u32.f64	s12, d4
10005682:	ee12 5a90 	vmov	r5, s5
10005686:	eeb8 1b41 	vcvt.f64.u32	d1, s2
1000568a:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000568e:	0fed      	lsrs	r5, r5, #31
10005690:	ee01 8b49 	vmls.f64	d8, d1, d9
10005694:	ee04 5a10 	vmov	s8, r5
10005698:	ee06 7b49 	vmls.f64	d7, d6, d9
1000569c:	ee08 3b0f 	vmla.f64	d3, d8, d15
100056a0:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
100056a4:	ee07 5b0f 	vmla.f64	d5, d7, d15
100056a8:	9c11      	ldr	r4, [sp, #68]	@ 0x44
100056aa:	ed8d 1b3c 	vstr	d1, [sp, #240]	@ 0xf0
100056ae:	4414      	add	r4, r2
100056b0:	42a2      	cmp	r2, r4
100056b2:	ed8d 3b3a 	vstr	d3, [sp, #232]	@ 0xe8
100056b6:	ed8d 4b54 	vstr	d4, [sp, #336]	@ 0x150
100056ba:	ed8d 6b50 	vstr	d6, [sp, #320]	@ 0x140
100056be:	ed8d 5b4e 	vstr	d5, [sp, #312]	@ 0x138
100056c2:	f080 817c 	bcs.w	100059be <fndsa_vect_FFT_fp64_exact+0x49e>
100056c6:	9e14      	ldr	r6, [sp, #80]	@ 0x50
100056c8:	eeb7 db00 	vmov.f64	d13, #112	@ 0x3f800000  1.0
100056cc:	eb06 0801 	add.w	r8, r6, r1
100056d0:	460d      	mov	r5, r1
100056d2:	461e      	mov	r6, r3
100056d4:	9c13      	ldr	r4, [sp, #76]	@ 0x4c
100056d6:	e9cd 200e 	strd	r2, r0, [sp, #56]	@ 0x38
100056da:	eb04 1402 	add.w	r4, r4, r2, lsl #4
100056de:	f10b 0908 	add.w	r9, fp, #8
100056e2:	af2c      	add	r7, sp, #176	@ 0xb0
100056e4:	9110      	str	r1, [sp, #64]	@ 0x40
100056e6:	e01d      	b.n	10005724 <fndsa_vect_FFT_fp64_exact+0x204>
100056e8:	00000000 	.word	0x00000000
100056ec:	3df00000 	.word	0x3df00000
100056f0:	00000000 	.word	0x00000000
100056f4:	41f00000 	.word	0x41f00000
100056f8:	00000000 	.word	0x00000000
100056fc:	3e700000 	.word	0x3e700000
10005700:	00000000 	.word	0x00000000
10005704:	3ef00000 	.word	0x3ef00000
10005708:	00000000 	.word	0x00000000
1000570c:	41700000 	.word	0x41700000
10005710:	00000000 	.word	0x00000000
10005714:	40f00000 	.word	0x40f00000
10005718:	00000000 	.word	0x00000000
1000571c:	40700000 	.word	0x40700000
10005720:	300039a0 	.word	0x300039a0
10005724:	ed95 3b00 	vldr	d3, [r5]
10005728:	f1a9 0308 	sub.w	r3, r9, #8
1000572c:	cb0f      	ldmia	r3, {r0, r1, r2, r3}
1000572e:	e88a 000f 	stmia.w	sl, {r0, r1, r2, r3}
10005732:	ed9d eb28 	vldr	d14, [sp, #160]	@ 0xa0
10005736:	ed9d fb2a 	vldr	d15, [sp, #168]	@ 0xa8
1000573a:	ed94 4b02 	vldr	d4, [r4, #8]
1000573e:	ed94 8b00 	vldr	d8, [r4]
10005742:	ed8d 3b00 	vstr	d3, [sp]
10005746:	ed95 3b02 	vldr	d3, [r5, #8]
1000574a:	f1a8 0c08 	sub.w	ip, r8, #8
1000574e:	e89c 000f 	ldmia.w	ip, {r0, r1, r2, r3}
10005752:	e887 000f 	stmia.w	r7, {r0, r1, r2, r3}
10005756:	eeb0 0b4e 	vmov.f64	d0, d14
1000575a:	eeb0 1b4f 	vmov.f64	d1, d15
1000575e:	a838      	add	r0, sp, #224	@ 0xe0
10005760:	ed9d 9b2c 	vldr	d9, [sp, #176]	@ 0xb0
10005764:	ed8d 4b0c 	vstr	d4, [sp, #48]	@ 0x30
10005768:	ed8d 3b0a 	vstr	d3, [sp, #40]	@ 0x28
1000576c:	ed9d ab2e 	vldr	d10, [sp, #184]	@ 0xb8
10005770:	ed8d 8b02 	vstr	d8, [sp, #8]
10005774:	ed8d eb30 	vstr	d14, [sp, #192]	@ 0xc0
10005778:	ed8d fb32 	vstr	d15, [sp, #200]	@ 0xc8
1000577c:	f7ff fa58 	bl	10004c30 <fp64e_mul24_prepared>
10005780:	a842      	add	r0, sp, #264	@ 0x108
10005782:	eeb0 8b41 	vmov.f64	d8, d1
10005786:	ed8d 0b18 	vstr	d0, [sp, #96]	@ 0x60
1000578a:	ed8d 0b08 	vstr	d0, [sp, #32]
1000578e:	ed8d 1b1a 	vstr	d1, [sp, #104]	@ 0x68
10005792:	eeb0 0b49 	vmov.f64	d0, d9
10005796:	eeb0 1b4a 	vmov.f64	d1, d10
1000579a:	ed8d 9b34 	vstr	d9, [sp, #208]	@ 0xd0
1000579e:	ed8d ab36 	vstr	d10, [sp, #216]	@ 0xd8
100057a2:	f7ff fa45 	bl	10004c30 <fp64e_mul24_prepared>
100057a6:	eeb0 6b41 	vmov.f64	d6, d1
100057aa:	ee3f 1b0a 	vadd.f64	d1, d15, d10
100057ae:	ee21 2b0c 	vmul.f64	d2, d1, d12
100057b2:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100057b6:	eeb0 7b40 	vmov.f64	d7, d0
100057ba:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100057be:	ee3e 0b09 	vadd.f64	d0, d14, d9
100057c2:	ee30 0b02 	vadd.f64	d0, d0, d2
100057c6:	ee02 1b4b 	vmls.f64	d1, d2, d11
100057ca:	ee20 2b0c 	vmul.f64	d2, d0, d12
100057ce:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100057d2:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100057d6:	ee02 0b4b 	vmls.f64	d0, d2, d11
100057da:	a84c      	add	r0, sp, #304	@ 0x130
100057dc:	ed8d 7b1c 	vstr	d7, [sp, #112]	@ 0x70
100057e0:	ed8d 7b06 	vstr	d7, [sp, #24]
100057e4:	ed8d 6b1e 	vstr	d6, [sp, #120]	@ 0x78
100057e8:	ed8d 6b04 	vstr	d6, [sp, #16]
100057ec:	ed8d 1b26 	vstr	d1, [sp, #152]	@ 0x98
100057f0:	ed8d 0b24 	vstr	d0, [sp, #144]	@ 0x90
100057f4:	f7ff fa1c 	bl	10004c30 <fp64e_mul24_prepared>
100057f8:	ed9d 6b04 	vldr	d6, [sp, #16]
100057fc:	ee38 2b06 	vadd.f64	d2, d8, d6
10005800:	ee22 9b0c 	vmul.f64	d9, d2, d12
10005804:	ed9d 7b06 	vldr	d7, [sp, #24]
10005808:	ed9d 5b08 	vldr	d5, [sp, #32]
1000580c:	ee38 8b0b 	vadd.f64	d8, d8, d11
10005810:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10005814:	ee38 8b46 	vsub.f64	d8, d8, d6
10005818:	eeb8 9b49 	vcvt.f64.u32	d9, s18
1000581c:	ee35 6b07 	vadd.f64	d6, d5, d7
10005820:	ed8d 1b22 	vstr	d1, [sp, #136]	@ 0x88
10005824:	ee36 6b09 	vadd.f64	d6, d6, d9
10005828:	ee31 1b0b 	vadd.f64	d1, d1, d11
1000582c:	ee09 2b4b 	vmls.f64	d2, d9, d11
10005830:	ee35 5b0b 	vadd.f64	d5, d5, d11
10005834:	ee31 2b42 	vsub.f64	d2, d1, d2
10005838:	ee35 5b47 	vsub.f64	d5, d5, d7
1000583c:	ee26 1b0c 	vmul.f64	d1, d6, d12
10005840:	ee28 7b0c 	vmul.f64	d7, d8, d12
10005844:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10005848:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000584c:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10005850:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005854:	ee35 5b4d 	vsub.f64	d5, d5, d13
10005858:	ee07 8b4b 	vmls.f64	d8, d7, d11
1000585c:	ee35 5b07 	vadd.f64	d5, d5, d7
10005860:	ed8d 0b20 	vstr	d0, [sp, #128]	@ 0x80
10005864:	ee22 7b0c 	vmul.f64	d7, d2, d12
10005868:	ee30 0b0b 	vadd.f64	d0, d0, d11
1000586c:	ee01 6b4b 	vmls.f64	d6, d1, d11
10005870:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005874:	ee25 1b0c 	vmul.f64	d1, d5, d12
10005878:	ee30 6b46 	vsub.f64	d6, d0, d6
1000587c:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005880:	ee36 6b4d 	vsub.f64	d6, d6, d13
10005884:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10005888:	ee36 6b07 	vadd.f64	d6, d6, d7
1000588c:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10005890:	ee01 5b4b 	vmls.f64	d5, d1, d11
10005894:	ee26 1b0c 	vmul.f64	d1, d6, d12
10005898:	ed9d 4b0c 	vldr	d4, [sp, #48]	@ 0x30
1000589c:	eebc 1bc1 	vcvt.u32.f64	s2, d1
100058a0:	ed9d 3b0a 	vldr	d3, [sp, #40]	@ 0x28
100058a4:	ee07 2b4b 	vmls.f64	d2, d7, d11
100058a8:	ee34 0b0b 	vadd.f64	d0, d4, d11
100058ac:	ee34 7b08 	vadd.f64	d7, d4, d8
100058b0:	eeb8 1b41 	vcvt.f64.u32	d1, s2
100058b4:	ee30 4b48 	vsub.f64	d4, d0, d8
100058b8:	ee01 6b4b 	vmls.f64	d6, d1, d11
100058bc:	ee33 0b0b 	vadd.f64	d0, d3, d11
100058c0:	ee33 1b02 	vadd.f64	d1, d3, d2
100058c4:	ee27 3b0c 	vmul.f64	d3, d7, d12
100058c8:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100058cc:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100058d0:	ed9d 8b02 	vldr	d8, [sp, #8]
100058d4:	ee03 7b4b 	vmls.f64	d7, d3, d11
100058d8:	ee24 9b0c 	vmul.f64	d9, d4, d12
100058dc:	ed84 7b02 	vstr	d7, [r4, #8]
100058e0:	ee38 7b0b 	vadd.f64	d7, d8, d11
100058e4:	eebc 9bc9 	vcvt.u32.f64	s18, d9
100058e8:	ee38 8b05 	vadd.f64	d8, d8, d5
100058ec:	ee37 7b45 	vsub.f64	d7, d7, d5
100058f0:	ee30 2b42 	vsub.f64	d2, d0, d2
100058f4:	ee38 8b03 	vadd.f64	d8, d8, d3
100058f8:	eeb8 9b49 	vcvt.f64.u32	d9, s18
100058fc:	ed9d 3b00 	vldr	d3, [sp]
10005900:	ee37 7b4d 	vsub.f64	d7, d7, d13
10005904:	ee21 0b0c 	vmul.f64	d0, d1, d12
10005908:	ee37 7b09 	vadd.f64	d7, d7, d9
1000590c:	ee09 4b4b 	vmls.f64	d4, d9, d11
10005910:	ee33 5b0b 	vadd.f64	d5, d3, d11
10005914:	ee22 9b0c 	vmul.f64	d9, d2, d12
10005918:	ee35 5b46 	vsub.f64	d5, d5, d6
1000591c:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10005920:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10005924:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10005928:	ee33 3b06 	vadd.f64	d3, d3, d6
1000592c:	ee35 5b4d 	vsub.f64	d5, d5, d13
10005930:	eeb8 6b49 	vcvt.f64.u32	d6, s18
10005934:	ee33 3b00 	vadd.f64	d3, d3, d0
10005938:	ee06 2b4b 	vmls.f64	d2, d6, d11
1000593c:	ee35 6b06 	vadd.f64	d6, d5, d6
10005940:	ee00 1b4b 	vmls.f64	d1, d0, d11
10005944:	ee23 5b0c 	vmul.f64	d5, d3, d12
10005948:	ee26 0b0c 	vmul.f64	d0, d6, d12
1000594c:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10005950:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10005954:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10005958:	eeb8 0b40 	vcvt.f64.u32	d0, s0
1000595c:	ee05 3b4b 	vmls.f64	d3, d5, d11
10005960:	ee00 6b4b 	vmls.f64	d6, d0, d11
10005964:	ee27 5b0c 	vmul.f64	d5, d7, d12
10005968:	ee28 0b0c 	vmul.f64	d0, d8, d12
1000596c:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10005970:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10005974:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10005978:	eeb8 0b40 	vcvt.f64.u32	d0, s0
1000597c:	464b      	mov	r3, r9
1000597e:	ee05 7b4b 	vmls.f64	d7, d5, d11
10005982:	ee00 8b4b 	vmls.f64	d8, d0, d11
10005986:	3510      	adds	r5, #16
10005988:	ed84 8b00 	vstr	d8, [r4]
1000598c:	ed05 3b04 	vstr	d3, [r5, #-16]
10005990:	ed05 1b02 	vstr	d1, [r5, #-8]
10005994:	ed09 7b02 	vstr	d7, [r9, #-8]
10005998:	ed83 4b00 	vstr	d4, [r3]
1000599c:	4643      	mov	r3, r8
1000599e:	3410      	adds	r4, #16
100059a0:	45a3      	cmp	fp, r4
100059a2:	ed08 6b02 	vstr	d6, [r8, #-8]
100059a6:	f109 0910 	add.w	r9, r9, #16
100059aa:	ed83 2b00 	vstr	d2, [r3]
100059ae:	f108 0810 	add.w	r8, r8, #16
100059b2:	f47f aeb7 	bne.w	10005724 <fndsa_vect_FFT_fp64_exact+0x204>
100059b6:	e9dd 200e 	ldrd	r2, r0, [sp, #56]	@ 0x38
100059ba:	4633      	mov	r3, r6
100059bc:	9910      	ldr	r1, [sp, #64]	@ 0x40
100059be:	9c12      	ldr	r4, [sp, #72]	@ 0x48
100059c0:	3310      	adds	r3, #16
100059c2:	429c      	cmp	r4, r3
100059c4:	4402      	add	r2, r0
100059c6:	eb01 1100 	add.w	r1, r1, r0, lsl #4
100059ca:	eb0b 1b00 	add.w	fp, fp, r0, lsl #4
100059ce:	f47f addb 	bne.w	10005588 <fndsa_vect_FFT_fp64_exact+0x68>
100059d2:	9c15      	ldr	r4, [sp, #84]	@ 0x54
100059d4:	9b17      	ldr	r3, [sp, #92]	@ 0x5c
100059d6:	3401      	adds	r4, #1
100059d8:	42a3      	cmp	r3, r4
100059da:	f8dd e044 	ldr.w	lr, [sp, #68]	@ 0x44
100059de:	f47f adb7 	bne.w	10005550 <fndsa_vect_FFT_fp64_exact+0x30>
100059e2:	b057      	add	sp, #348	@ 0x15c
100059e4:	ecbd 8b10 	vpop	{d8-d15}
100059e8:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
100059ec:	4770      	bx	lr
