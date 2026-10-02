
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_kat_exact/validation/build/kat/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10005378 <fndsa_vect_FFT_fp64_exact>:
10005378:	2801      	cmp	r0, #1
1000537a:	f240 8202 	bls.w	10005782 <fndsa_vect_FFT_fp64_exact+0x40a>
1000537e:	2201      	movs	r2, #1
10005380:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10005384:	ed2d 8b10 	vpush	{d8-d15}
10005388:	2310      	movs	r3, #16
1000538a:	460e      	mov	r6, r1
1000538c:	ed9f dbec 	vldr	d13, [pc, #944]	@ 10005740 <fndsa_vect_FFT_fp64_exact+0x3c8>
10005390:	ed9f cbed 	vldr	d12, [pc, #948]	@ 10005748 <fndsa_vect_FFT_fp64_exact+0x3d0>
10005394:	4614      	mov	r4, r2
10005396:	b0d1      	sub	sp, #324	@ 0x144
10005398:	911f      	str	r1, [sp, #124]	@ 0x7c
1000539a:	1e41      	subs	r1, r0, #1
1000539c:	408b      	lsls	r3, r1
1000539e:	18f7      	adds	r7, r6, r3
100053a0:	e9cd 7022 	strd	r7, r0, [sp, #136]	@ 0x88
100053a4:	f10d 08e0 	add.w	r8, sp, #224	@ 0xe0
100053a8:	f10d 0af0 	add.w	sl, sp, #240	@ 0xf0
100053ac:	fa02 fe01 	lsl.w	lr, r2, r1
100053b0:	2501      	movs	r5, #1
100053b2:	2310      	movs	r3, #16
100053b4:	eeb7 bb00 	vmov.f64	d11, #112	@ 0x3f800000  1.0
100053b8:	2200      	movs	r2, #0
100053ba:	fa05 f704 	lsl.w	r7, r5, r4
100053be:	4de4      	ldr	r5, [pc, #912]	@ (10005750 <fndsa_vect_FFT_fp64_exact+0x3d8>)
100053c0:	eb07 0757 	add.w	r7, r7, r7, lsr #1
100053c4:	4670      	mov	r0, lr
100053c6:	ea4f 0e5e 	mov.w	lr, lr, lsr #1
100053ca:	eb05 1607 	add.w	r6, r5, r7, lsl #4
100053ce:	ea4f 170e 	mov.w	r7, lr, lsl #4
100053d2:	961e      	str	r6, [sp, #120]	@ 0x78
100053d4:	f107 0608 	add.w	r6, r7, #8
100053d8:	9620      	str	r6, [sp, #128]	@ 0x80
100053da:	9e1f      	ldr	r6, [sp, #124]	@ 0x7c
100053dc:	40a3      	lsls	r3, r4
100053de:	9922      	ldr	r1, [sp, #136]	@ 0x88
100053e0:	eb06 1b0e 	add.w	fp, r6, lr, lsl #4
100053e4:	442b      	add	r3, r5
100053e6:	f8cd e074 	str.w	lr, [sp, #116]	@ 0x74
100053ea:	9421      	str	r4, [sp, #132]	@ 0x84
100053ec:	9c1d      	ldr	r4, [sp, #116]	@ 0x74
100053ee:	4414      	add	r4, r2
100053f0:	42a2      	cmp	r2, r4
100053f2:	f080 81af 	bcs.w	10005754 <fndsa_vect_FFT_fp64_exact+0x3dc>
100053f6:	edd3 5a01 	vldr	s11, [r3, #4]
100053fa:	edd3 7a00 	vldr	s15, [r3]
100053fe:	edd3 6a02 	vldr	s13, [r3, #8]
10005402:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10005406:	eeb8 6b66 	vcvt.f64.u32	d6, s13
1000540a:	eeb8 4b65 	vcvt.f64.u32	d4, s11
1000540e:	edd3 5a03 	vldr	s11, [r3, #12]
10005412:	eeb8 3b65 	vcvt.f64.u32	d3, s11
10005416:	ee37 5b06 	vadd.f64	d5, d7, d6
1000541a:	ed8d 7b10 	vstr	d7, [sp, #64]	@ 0x40
1000541e:	ee25 7b0d 	vmul.f64	d7, d5, d13
10005422:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005426:	ed8d 6b14 	vstr	d6, [sp, #80]	@ 0x50
1000542a:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000542e:	ee34 6b03 	vadd.f64	d6, d4, d3
10005432:	ee36 6b07 	vadd.f64	d6, d6, d7
10005436:	ee07 5b4c 	vmls.f64	d5, d7, d12
1000543a:	ee26 7b0d 	vmul.f64	d7, d6, d13
1000543e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005442:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005446:	ee07 6b4c 	vmls.f64	d6, d7, d12
1000544a:	9e20      	ldr	r6, [sp, #128]	@ 0x80
1000544c:	ed8d 4b0e 	vstr	d4, [sp, #56]	@ 0x38
10005450:	1877      	adds	r7, r6, r1
10005452:	ed8d 3b12 	vstr	d3, [sp, #72]	@ 0x48
10005456:	460d      	mov	r5, r1
10005458:	ed8d 5b18 	vstr	d5, [sp, #96]	@ 0x60
1000545c:	ed8d 6b16 	vstr	d6, [sp, #88]	@ 0x58
10005460:	460e      	mov	r6, r1
10005462:	9c1f      	ldr	r4, [sp, #124]	@ 0x7c
10005464:	e9cd 201a 	strd	r2, r0, [sp, #104]	@ 0x68
10005468:	eb04 1402 	add.w	r4, r4, r2, lsl #4
1000546c:	f10b 0908 	add.w	r9, fp, #8
10005470:	931c      	str	r3, [sp, #112]	@ 0x70
10005472:	ed94 8b00 	vldr	d8, [r4]
10005476:	f1a9 0308 	sub.w	r3, r9, #8
1000547a:	cb0f      	ldmia	r3, {r0, r1, r2, r3}
1000547c:	e888 000f 	stmia.w	r8, {r0, r1, r2, r3}
10005480:	ed95 2b02 	vldr	d2, [r5, #8]
10005484:	ed9d eb3a 	vldr	d14, [sp, #232]	@ 0xe8
10005488:	ed8d 8b06 	vstr	d8, [sp, #24]
1000548c:	ed9d 8b38 	vldr	d8, [sp, #224]	@ 0xe0
10005490:	ed94 7b02 	vldr	d7, [r4, #8]
10005494:	ed95 5b00 	vldr	d5, [r5]
10005498:	ed9d 1b10 	vldr	d1, [sp, #64]	@ 0x40
1000549c:	ed9d 0b0e 	vldr	d0, [sp, #56]	@ 0x38
100054a0:	f1a7 0c08 	sub.w	ip, r7, #8
100054a4:	e89c 000f 	ldmia.w	ip, {r0, r1, r2, r3}
100054a8:	e88a 000f 	stmia.w	sl, {r0, r1, r2, r3}
100054ac:	ed8d 2b04 	vstr	d2, [sp, #16]
100054b0:	eeb0 3b4e 	vmov.f64	d3, d14
100054b4:	eeb0 2b48 	vmov.f64	d2, d8
100054b8:	ed8d 7b00 	vstr	d7, [sp]
100054bc:	ed8d 5b02 	vstr	d5, [sp, #8]
100054c0:	ed8d 0b40 	vstr	d0, [sp, #256]	@ 0x100
100054c4:	ed8d 1b42 	vstr	d1, [sp, #264]	@ 0x108
100054c8:	ed8d 8b48 	vstr	d8, [sp, #288]	@ 0x120
100054cc:	ed8d eb4a 	vstr	d14, [sp, #296]	@ 0x128
100054d0:	ed9d 9b3c 	vldr	d9, [sp, #240]	@ 0xf0
100054d4:	f7ff fd84 	bl	10004fe0 <fndsa_fp64e_mul>
100054d8:	ed9d ab3e 	vldr	d10, [sp, #248]	@ 0xf8
100054dc:	ed9d 6b14 	vldr	d6, [sp, #80]	@ 0x50
100054e0:	eeb0 5b40 	vmov.f64	d5, d0
100054e4:	ed9d 0b12 	vldr	d0, [sp, #72]	@ 0x48
100054e8:	eeb0 2b49 	vmov.f64	d2, d9
100054ec:	ed8d 1b26 	vstr	d1, [sp, #152]	@ 0x98
100054f0:	ed8d 1b0a 	vstr	d1, [sp, #40]	@ 0x28
100054f4:	eeb0 3b4a 	vmov.f64	d3, d10
100054f8:	eeb0 1b46 	vmov.f64	d1, d6
100054fc:	ed8d 5b24 	vstr	d5, [sp, #144]	@ 0x90
10005500:	ed8d 5b0c 	vstr	d5, [sp, #48]	@ 0x30
10005504:	ed8d 0b44 	vstr	d0, [sp, #272]	@ 0x110
10005508:	ed8d 6b46 	vstr	d6, [sp, #280]	@ 0x118
1000550c:	ed8d 9b4c 	vstr	d9, [sp, #304]	@ 0x130
10005510:	ed8d ab4e 	vstr	d10, [sp, #312]	@ 0x138
10005514:	f7ff fd64 	bl	10004fe0 <fndsa_fp64e_mul>
10005518:	ee3e 3b0a 	vadd.f64	d3, d14, d10
1000551c:	ee23 4b0d 	vmul.f64	d4, d3, d13
10005520:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10005524:	ee38 2b09 	vadd.f64	d2, d8, d9
10005528:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000552c:	ee32 2b04 	vadd.f64	d2, d2, d4
10005530:	ee04 3b4c 	vmls.f64	d3, d4, d12
10005534:	ee22 4b0d 	vmul.f64	d4, d2, d13
10005538:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000553c:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10005540:	ed9d 6b18 	vldr	d6, [sp, #96]	@ 0x60
10005544:	ee04 2b4c 	vmls.f64	d2, d4, d12
10005548:	eeb0 fb40 	vmov.f64	d15, d0
1000554c:	ed8d 0b28 	vstr	d0, [sp, #160]	@ 0xa0
10005550:	ed9d 0b16 	vldr	d0, [sp, #88]	@ 0x58
10005554:	ed8d 1b2a 	vstr	d1, [sp, #168]	@ 0xa8
10005558:	ed8d 1b08 	vstr	d1, [sp, #32]
1000555c:	eeb0 1b46 	vmov.f64	d1, d6
10005560:	ed8d 0b34 	vstr	d0, [sp, #208]	@ 0xd0
10005564:	ed8d 6b36 	vstr	d6, [sp, #216]	@ 0xd8
10005568:	ed8d 3b32 	vstr	d3, [sp, #200]	@ 0xc8
1000556c:	ed8d 2b30 	vstr	d2, [sp, #192]	@ 0xc0
10005570:	f7ff fd36 	bl	10004fe0 <fndsa_fp64e_mul>
10005574:	ed9d 7b08 	vldr	d7, [sp, #32]
10005578:	ed9d 6b0a 	vldr	d6, [sp, #40]	@ 0x28
1000557c:	ee36 4b07 	vadd.f64	d4, d6, d7
10005580:	ee24 3b0d 	vmul.f64	d3, d4, d13
10005584:	ed9d 5b0c 	vldr	d5, [sp, #48]	@ 0x30
10005588:	ee36 6b0c 	vadd.f64	d6, d6, d12
1000558c:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10005590:	ee36 6b47 	vsub.f64	d6, d6, d7
10005594:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10005598:	ee35 7b0f 	vadd.f64	d7, d5, d15
1000559c:	ee37 7b03 	vadd.f64	d7, d7, d3
100055a0:	ee27 2b0d 	vmul.f64	d2, d7, d13
100055a4:	ee03 4b4c 	vmls.f64	d4, d3, d12
100055a8:	ee35 5b0c 	vadd.f64	d5, d5, d12
100055ac:	ee26 3b0d 	vmul.f64	d3, d6, d13
100055b0:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100055b4:	ed8d 1b2e 	vstr	d1, [sp, #184]	@ 0xb8
100055b8:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100055bc:	ee31 1b0c 	vadd.f64	d1, d1, d12
100055c0:	ee35 5b4f 	vsub.f64	d5, d5, d15
100055c4:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100055c8:	ee31 4b44 	vsub.f64	d4, d1, d4
100055cc:	ee02 7b4c 	vmls.f64	d7, d2, d12
100055d0:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100055d4:	ed8d 0b2c 	vstr	d0, [sp, #176]	@ 0xb0
100055d8:	ee35 5b4b 	vsub.f64	d5, d5, d11
100055dc:	ee30 0b0c 	vadd.f64	d0, d0, d12
100055e0:	ee35 5b03 	vadd.f64	d5, d5, d3
100055e4:	ee30 0b47 	vsub.f64	d0, d0, d7
100055e8:	ee24 7b0d 	vmul.f64	d7, d4, d13
100055ec:	ee03 6b4c 	vmls.f64	d6, d3, d12
100055f0:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100055f4:	ee25 3b0d 	vmul.f64	d3, d5, d13
100055f8:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100055fc:	ee30 0b4b 	vsub.f64	d0, d0, d11
10005600:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10005604:	ee30 0b07 	vadd.f64	d0, d0, d7
10005608:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000560c:	ee07 4b4c 	vmls.f64	d4, d7, d12
10005610:	ee03 5b4c 	vmls.f64	d5, d3, d12
10005614:	ed9d 7b00 	vldr	d7, [sp]
10005618:	ee20 3b0d 	vmul.f64	d3, d0, d13
1000561c:	ee37 2b0c 	vadd.f64	d2, d7, d12
10005620:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10005624:	ee37 7b06 	vadd.f64	d7, d7, d6
10005628:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000562c:	ee32 6b46 	vsub.f64	d6, d2, d6
10005630:	ed9d 2b04 	vldr	d2, [sp, #16]
10005634:	ee03 0b4c 	vmls.f64	d0, d3, d12
10005638:	ee32 3b0c 	vadd.f64	d3, d2, d12
1000563c:	ee34 2b02 	vadd.f64	d2, d4, d2
10005640:	ee33 4b44 	vsub.f64	d4, d3, d4
10005644:	ee27 3b0d 	vmul.f64	d3, d7, d13
10005648:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000564c:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10005650:	ed9d 8b06 	vldr	d8, [sp, #24]
10005654:	ee03 7b4c 	vmls.f64	d7, d3, d12
10005658:	ed84 7b02 	vstr	d7, [r4, #8]
1000565c:	ee38 7b0c 	vadd.f64	d7, d8, d12
10005660:	ee22 1b0d 	vmul.f64	d1, d2, d13
10005664:	ee26 9b0d 	vmul.f64	d9, d6, d13
10005668:	ee35 8b08 	vadd.f64	d8, d5, d8
1000566c:	ee37 7b45 	vsub.f64	d7, d7, d5
10005670:	ed9d 5b02 	vldr	d5, [sp, #8]
10005674:	ee38 8b03 	vadd.f64	d8, d8, d3
10005678:	eebc 1bc1 	vcvt.u32.f64	s2, d1
1000567c:	ee35 3b0c 	vadd.f64	d3, d5, d12
10005680:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10005684:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10005688:	eeb8 9b49 	vcvt.f64.u32	d9, s18
1000568c:	ee35 5b00 	vadd.f64	d5, d5, d0
10005690:	ee33 3b40 	vsub.f64	d3, d3, d0
10005694:	ee37 7b4b 	vsub.f64	d7, d7, d11
10005698:	ee28 0b0d 	vmul.f64	d0, d8, d13
1000569c:	ee37 7b09 	vadd.f64	d7, d7, d9
100056a0:	ee09 6b4c 	vmls.f64	d6, d9, d12
100056a4:	ee35 5b01 	vadd.f64	d5, d5, d1
100056a8:	ee24 9b0d 	vmul.f64	d9, d4, d13
100056ac:	eebc 0bc0 	vcvt.u32.f64	s0, d0
100056b0:	ee01 2b4c 	vmls.f64	d2, d1, d12
100056b4:	eebc 9bc9 	vcvt.u32.f64	s18, d9
100056b8:	ee25 1b0d 	vmul.f64	d1, d5, d13
100056bc:	eeb8 0b40 	vcvt.f64.u32	d0, s0
100056c0:	eeb8 9b49 	vcvt.f64.u32	d9, s18
100056c4:	ee33 3b4b 	vsub.f64	d3, d3, d11
100056c8:	eebc 1bc1 	vcvt.u32.f64	s2, d1
100056cc:	ee00 8b4c 	vmls.f64	d8, d0, d12
100056d0:	3510      	adds	r5, #16
100056d2:	ed84 8b00 	vstr	d8, [r4]
100056d6:	ee33 3b09 	vadd.f64	d3, d3, d9
100056da:	ed05 2b02 	vstr	d2, [r5, #-8]
100056de:	eeb8 1b41 	vcvt.f64.u32	d1, s2
100056e2:	ee27 2b0d 	vmul.f64	d2, d7, d13
100056e6:	ee01 5b4c 	vmls.f64	d5, d1, d12
100056ea:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100056ee:	ee23 1b0d 	vmul.f64	d1, d3, d13
100056f2:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100056f6:	eebc 1bc1 	vcvt.u32.f64	s2, d1
100056fa:	464b      	mov	r3, r9
100056fc:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10005700:	ee02 7b4c 	vmls.f64	d7, d2, d12
10005704:	ed05 5b04 	vstr	d5, [r5, #-16]
10005708:	ee09 4b4c 	vmls.f64	d4, d9, d12
1000570c:	ed09 7b02 	vstr	d7, [r9, #-8]
10005710:	ee01 3b4c 	vmls.f64	d3, d1, d12
10005714:	ed83 6b00 	vstr	d6, [r3]
10005718:	463b      	mov	r3, r7
1000571a:	3410      	adds	r4, #16
1000571c:	45a3      	cmp	fp, r4
1000571e:	ed07 3b02 	vstr	d3, [r7, #-8]
10005722:	f109 0910 	add.w	r9, r9, #16
10005726:	ed83 4b00 	vstr	d4, [r3]
1000572a:	f107 0710 	add.w	r7, r7, #16
1000572e:	f47f aea0 	bne.w	10005472 <fndsa_vect_FFT_fp64_exact+0xfa>
10005732:	e9dd 201a 	ldrd	r2, r0, [sp, #104]	@ 0x68
10005736:	4631      	mov	r1, r6
10005738:	9b1c      	ldr	r3, [sp, #112]	@ 0x70
1000573a:	e00b      	b.n	10005754 <fndsa_vect_FFT_fp64_exact+0x3dc>
1000573c:	f3af 8000 	nop.w
10005740:	00000000 	.word	0x00000000
10005744:	3df00000 	.word	0x3df00000
10005748:	00000000 	.word	0x00000000
1000574c:	41f00000 	.word	0x41f00000
10005750:	300039a0 	.word	0x300039a0
10005754:	9c1e      	ldr	r4, [sp, #120]	@ 0x78
10005756:	3310      	adds	r3, #16
10005758:	429c      	cmp	r4, r3
1000575a:	4402      	add	r2, r0
1000575c:	eb01 1100 	add.w	r1, r1, r0, lsl #4
10005760:	eb0b 1b00 	add.w	fp, fp, r0, lsl #4
10005764:	f47f ae42 	bne.w	100053ec <fndsa_vect_FFT_fp64_exact+0x74>
10005768:	9c21      	ldr	r4, [sp, #132]	@ 0x84
1000576a:	9b23      	ldr	r3, [sp, #140]	@ 0x8c
1000576c:	3401      	adds	r4, #1
1000576e:	42a3      	cmp	r3, r4
10005770:	f8dd e074 	ldr.w	lr, [sp, #116]	@ 0x74
10005774:	f47f ae1c 	bne.w	100053b0 <fndsa_vect_FFT_fp64_exact+0x38>
10005778:	b051      	add	sp, #324	@ 0x144
1000577a:	ecbd 8b10 	vpop	{d8-d15}
1000577e:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10005782:	4770      	bx	lr
