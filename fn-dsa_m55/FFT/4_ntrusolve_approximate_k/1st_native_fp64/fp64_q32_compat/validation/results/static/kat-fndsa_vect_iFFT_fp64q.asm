
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_q32_compat/validation/build/kat/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10005340 <fndsa_vect_iFFT_fp64q>:
10005340:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10005344:	ed2d 8b10 	vpush	{d8-d15}
10005348:	1e44      	subs	r4, r0, #1
1000534a:	b0bd      	sub	sp, #244	@ 0xf4
1000534c:	f000 82d4 	beq.w	100058f8 <fndsa_vect_iFFT_fp64q+0x5b8>
10005350:	2301      	movs	r3, #1
10005352:	ed9f 6b3b 	vldr	d6, [pc, #236]	@ 10005440 <fndsa_vect_iFFT_fp64q+0x100>
10005356:	ed9f 7b3c 	vldr	d7, [pc, #240]	@ 10005448 <fndsa_vect_iFFT_fp64q+0x108>
1000535a:	4625      	mov	r5, r4
1000535c:	f1a1 0808 	sub.w	r8, r1, #8
10005360:	fa03 f904 	lsl.w	r9, r3, r4
10005364:	9321      	str	r3, [sp, #132]	@ 0x84
10005366:	f8cd 90a0 	str.w	r9, [sp, #160]	@ 0xa0
1000536a:	f8cd 80a4 	str.w	r8, [sp, #164]	@ 0xa4
1000536e:	9b21      	ldr	r3, [sp, #132]	@ 0x84
10005370:	4937      	ldr	r1, [pc, #220]	@ (10005450 <fndsa_vect_iFFT_fp64q+0x110>)
10005372:	4618      	mov	r0, r3
10005374:	005a      	lsls	r2, r3, #1
10005376:	2301      	movs	r3, #1
10005378:	40ab      	lsls	r3, r5
1000537a:	eb03 0353 	add.w	r3, r3, r3, lsr #1
1000537e:	eb01 1303 	add.w	r3, r1, r3, lsl #4
10005382:	9322      	str	r3, [sp, #136]	@ 0x88
10005384:	2310      	movs	r3, #16
10005386:	f04f 0c00 	mov.w	ip, #0
1000538a:	40ab      	lsls	r3, r5
1000538c:	18cf      	adds	r7, r1, r3
1000538e:	00d3      	lsls	r3, r2, #3
10005390:	9323      	str	r3, [sp, #140]	@ 0x8c
10005392:	9b28      	ldr	r3, [sp, #160]	@ 0xa0
10005394:	ea4f 0ac0 	mov.w	sl, r0, lsl #3
10005398:	1a1b      	subs	r3, r3, r0
1000539a:	3301      	adds	r3, #1
1000539c:	9325      	str	r3, [sp, #148]	@ 0x94
1000539e:	9b29      	ldr	r3, [sp, #164]	@ 0xa4
100053a0:	9221      	str	r2, [sp, #132]	@ 0x84
100053a2:	eb03 0bc0 	add.w	fp, r3, r0, lsl #3
100053a6:	9527      	str	r5, [sp, #156]	@ 0x9c
100053a8:	9024      	str	r0, [sp, #144]	@ 0x90
100053aa:	f8cd a098 	str.w	sl, [sp, #152]	@ 0x98
100053ae:	9b24      	ldr	r3, [sp, #144]	@ 0x90
100053b0:	ac38      	add	r4, sp, #224	@ 0xe0
100053b2:	eb0c 0603 	add.w	r6, ip, r3
100053b6:	e897 000f 	ldmia.w	r7, {r0, r1, r2, r3}
100053ba:	e884 000f 	stmia.w	r4, {r0, r1, r2, r3}
100053be:	45b4      	cmp	ip, r6
100053c0:	e9dd 0138 	ldrd	r0, r1, [sp, #224]	@ 0xe0
100053c4:	e9cd 0134 	strd	r0, r1, [sp, #208]	@ 0xd0
100053c8:	f080 8289 	bcs.w	100058de <fndsa_vect_iFFT_fp64q+0x59e>
100053cc:	9c34      	ldr	r4, [sp, #208]	@ 0xd0
100053ce:	4251      	negs	r1, r2
100053d0:	ee05 4a90 	vmov	s11, r4
100053d4:	eeb8 0b65 	vcvt.f64.u32	d0, s11
100053d8:	ee05 1a90 	vmov	s11, r1
100053dc:	9d35      	ldr	r5, [sp, #212]	@ 0xd4
100053de:	eeb8 1b65 	vcvt.f64.u32	d1, s11
100053e2:	ee05 5a90 	vmov	s11, r5
100053e6:	eb63 0043 	sbc.w	r0, r3, r3, lsl #1
100053ea:	eeb8 8b65 	vcvt.f64.u32	d8, s11
100053ee:	ee05 0a90 	vmov	s11, r0
100053f2:	1aa2      	subs	r2, r4, r2
100053f4:	eeb8 cb65 	vcvt.f64.u32	d12, s11
100053f8:	ee05 2a90 	vmov	s11, r2
100053fc:	eb65 0303 	sbc.w	r3, r5, r3
10005400:	eeb8 2b65 	vcvt.f64.u32	d2, s11
10005404:	ee05 3a90 	vmov	s11, r3
10005408:	9118      	str	r1, [sp, #96]	@ 0x60
1000540a:	9926      	ldr	r1, [sp, #152]	@ 0x98
1000540c:	eeb8 db65 	vcvt.f64.u32	d13, s11
10005410:	f1a1 0e08 	sub.w	lr, r1, #8
10005414:	ea4f 0ede 	mov.w	lr, lr, lsr #3
10005418:	f10e 0e01 	add.w	lr, lr, #1
1000541c:	f04e e001 	dls	lr, lr
10005420:	931d      	str	r3, [sp, #116]	@ 0x74
10005422:	e9cd cb1e 	strd	ip, fp, [sp, #120]	@ 0x78
10005426:	9b25      	ldr	r3, [sp, #148]	@ 0x94
10005428:	941a      	str	r4, [sp, #104]	@ 0x68
1000542a:	951b      	str	r5, [sp, #108]	@ 0x6c
1000542c:	901c      	str	r0, [sp, #112]	@ 0x70
1000542e:	9219      	str	r2, [sp, #100]	@ 0x64
10005430:	eb0b 08c3 	add.w	r8, fp, r3, lsl #3
10005434:	9720      	str	r7, [sp, #128]	@ 0x80
10005436:	9108      	str	r1, [sp, #32]
10005438:	ebab 0a01 	sub.w	sl, fp, r1
1000543c:	e00a      	b.n	10005454 <fndsa_vect_iFFT_fp64q+0x114>
1000543e:	bf00      	nop
10005440:	00000000 	.word	0x00000000
10005444:	3df00000 	.word	0x3df00000
10005448:	00000000 	.word	0x00000000
1000544c:	41f00000 	.word	0x41f00000
10005450:	300039a0 	.word	0x300039a0
10005454:	f8da 3008 	ldr.w	r3, [sl, #8]
10005458:	9d08      	ldr	r5, [sp, #32]
1000545a:	1c59      	adds	r1, r3, #1
1000545c:	f8da 200c 	ldr.w	r2, [sl, #12]
10005460:	f8d8 3000 	ldr.w	r3, [r8]
10005464:	f10a 0a08 	add.w	sl, sl, #8
10005468:	f85a 4005 	ldr.w	r4, [sl, r5]
1000546c:	f142 0200 	adc.w	r2, r2, #0
10005470:	1c58      	adds	r0, r3, #1
10005472:	f8d8 3004 	ldr.w	r3, [r8, #4]
10005476:	9215      	str	r2, [sp, #84]	@ 0x54
10005478:	f143 0300 	adc.w	r3, r3, #0
1000547c:	1b0c      	subs	r4, r1, r4
1000547e:	9406      	str	r4, [sp, #24]
10005480:	eb0a 0405 	add.w	r4, sl, r5
10005484:	6866      	ldr	r6, [r4, #4]
10005486:	9114      	str	r1, [sp, #80]	@ 0x50
10005488:	eb62 0206 	sbc.w	r2, r2, r6
1000548c:	9207      	str	r2, [sp, #28]
1000548e:	f858 2005 	ldr.w	r2, [r8, r5]
10005492:	9016      	str	r0, [sp, #88]	@ 0x58
10005494:	1a82      	subs	r2, r0, r2
10005496:	9204      	str	r2, [sp, #16]
10005498:	eb08 0205 	add.w	r2, r8, r5
1000549c:	6851      	ldr	r1, [r2, #4]
1000549e:	9317      	str	r3, [sp, #92]	@ 0x5c
100054a0:	eb63 0001 	sbc.w	r0, r3, r1
100054a4:	9b1a      	ldr	r3, [sp, #104]	@ 0x68
100054a6:	940e      	str	r4, [sp, #56]	@ 0x38
100054a8:	9209      	str	r2, [sp, #36]	@ 0x24
100054aa:	e9dd 4506 	ldrd	r4, r5, [sp, #24]
100054ae:	ea03 72e5 	and.w	r2, r3, r5, asr #31
100054b2:	ea54 056f 	asrl	r4, r5, #1
100054b6:	ee05 4a90 	vmov	s11, r4
100054ba:	eeb8 fb65 	vcvt.f64.u32	d15, s11
100054be:	ee05 5a90 	vmov	s11, r5
100054c2:	ee20 ab0f 	vmul.f64	d10, d0, d15
100054c6:	eeb8 eb65 	vcvt.f64.u32	d14, s11
100054ca:	ee2a bb06 	vmul.f64	d11, d10, d6
100054ce:	ee2e eb00 	vmul.f64	d14, d14, d0
100054d2:	462f      	mov	r7, r5
100054d4:	ee2e 4b06 	vmul.f64	d4, d14, d6
100054d8:	eebc bbcb 	vcvt.u32.f64	s22, d11
100054dc:	9005      	str	r0, [sp, #20]
100054de:	9610      	str	r6, [sp, #64]	@ 0x40
100054e0:	4626      	mov	r6, r4
100054e2:	9805      	ldr	r0, [sp, #20]
100054e4:	910f      	str	r1, [sp, #60]	@ 0x3c
100054e6:	9918      	ldr	r1, [sp, #96]	@ 0x60
100054e8:	eefc 9bc4 	vcvt.u32.f64	s19, d4
100054ec:	ea01 70e0 	and.w	r0, r1, r0, asr #31
100054f0:	fb03 f104 	mul.w	r1, r3, r4
100054f4:	9c1b      	ldr	r4, [sp, #108]	@ 0x6c
100054f6:	eeb8 3b4b 	vcvt.f64.u32	d3, s22
100054fa:	9013      	str	r0, [sp, #76]	@ 0x4c
100054fc:	fb03 f007 	mul.w	r0, r3, r7
10005500:	4623      	mov	r3, r4
10005502:	ee28 fb0f 	vmul.f64	d15, d8, d15
10005506:	e9cd 6702 	strd	r6, r7, [sp, #8]
1000550a:	fb04 f506 	mul.w	r5, r4, r6
1000550e:	9e03      	ldr	r6, [sp, #12]
10005510:	ee23 3b07 	vmul.f64	d3, d3, d7
10005514:	fb04 f406 	mul.w	r4, r4, r6
10005518:	9e02      	ldr	r6, [sp, #8]
1000551a:	eeb8 4b69 	vcvt.f64.u32	d4, s19
1000551e:	ea06 73e3 	and.w	r3, r6, r3, asr #31
10005522:	e9dd 6704 	ldrd	r6, r7, [sp, #16]
10005526:	ea56 076f 	asrl	r6, r7, #1
1000552a:	ee2f 5b06 	vmul.f64	d5, d15, d6
1000552e:	ee24 4b07 	vmul.f64	d4, d4, d7
10005532:	ee1a ca10 	vmov	ip, s20
10005536:	e9cd 6700 	strd	r6, r7, [sp]
1000553a:	ee13 7a10 	vmov	r7, s6
1000553e:	eebc 9bc5 	vcvt.u32.f64	s18, d5
10005542:	4413      	add	r3, r2
10005544:	ee1a 6a90 	vmov	r6, s21
10005548:	1ae4      	subs	r4, r4, r3
1000554a:	ee13 3a90 	vmov	r3, s7
1000554e:	ea87 020c 	eor.w	r2, r7, ip
10005552:	ee1e 9a10 	vmov	r9, s28
10005556:	ee14 ca10 	vmov	ip, s8
1000555a:	eeb8 5b49 	vcvt.f64.u32	d5, s18
1000555e:	4073      	eors	r3, r6
10005560:	4313      	orrs	r3, r2
10005562:	e9dd 6700 	ldrd	r6, r7, [sp]
10005566:	ea8c 0209 	eor.w	r2, ip, r9
1000556a:	ee14 7a90 	vmov	r7, s9
1000556e:	ee1e ca90 	vmov	ip, s29
10005572:	ee25 5b07 	vmul.f64	d5, d5, d7
10005576:	ee03 6a90 	vmov	s7, r6
1000557a:	ea87 0c0c 	eor.w	ip, r7, ip
1000557e:	ea4c 0c02 	orr.w	ip, ip, r2
10005582:	425a      	negs	r2, r3
10005584:	431a      	orrs	r2, r3
10005586:	0fd2      	lsrs	r2, r2, #31
10005588:	922d      	str	r2, [sp, #180]	@ 0xb4
1000558a:	ee15 7a10 	vmov	r7, s10
1000558e:	ee1f 9a10 	vmov	r9, s30
10005592:	ee1f 2a90 	vmov	r2, s31
10005596:	ee15 6a90 	vmov	r6, s11
1000559a:	eeb8 3b63 	vcvt.f64.u32	d3, s7
1000559e:	ea87 0309 	eor.w	r3, r7, r9
100055a2:	4056      	eors	r6, r2
100055a4:	431e      	orrs	r6, r3
100055a6:	f1cc 0300 	rsb	r3, ip, #0
100055aa:	ea43 030c 	orr.w	r3, r3, ip
100055ae:	0fdb      	lsrs	r3, r3, #31
100055b0:	4272      	negs	r2, r6
100055b2:	ee23 eb01 	vmul.f64	d14, d3, d1
100055b6:	ed9d aa01 	vldr	s20, [sp, #4]
100055ba:	4332      	orrs	r2, r6
100055bc:	9e2d      	ldr	r6, [sp, #180]	@ 0xb4
100055be:	932c      	str	r3, [sp, #176]	@ 0xb0
100055c0:	ee1b 3a10 	vmov	r3, s22
100055c4:	f086 0601 	eor.w	r6, r6, #1
100055c8:	ea06 76d1 	and.w	r6, r6, r1, lsr #31
100055cc:	ee2c 5b03 	vmul.f64	d5, d12, d3
100055d0:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
100055d4:	ee2e 3b06 	vmul.f64	d3, d14, d6
100055d8:	1b9b      	subs	r3, r3, r6
100055da:	ee19 6a90 	vmov	r6, s19
100055de:	992c      	ldr	r1, [sp, #176]	@ 0xb0
100055e0:	ee2a fb01 	vmul.f64	d15, d10, d1
100055e4:	f081 0101 	eor.w	r1, r1, #1
100055e8:	ea01 71d0 	and.w	r1, r1, r0, lsr #31
100055ec:	1a71      	subs	r1, r6, r1
100055ee:	ee19 6a10 	vmov	r6, s18
100055f2:	eebc 9bc3 	vcvt.u32.f64	s18, d3
100055f6:	ee2f ab06 	vmul.f64	d10, d15, d6
100055fa:	eeb8 4b49 	vcvt.f64.u32	d4, s18
100055fe:	eebc abca 	vcvt.u32.f64	s20, d10
10005602:	ee24 4b07 	vmul.f64	d4, d4, d7
10005606:	ee1e ba10 	vmov	fp, s28
1000560a:	ee14 7a10 	vmov	r7, s8
1000560e:	eeb8 3b4a 	vcvt.f64.u32	d3, s20
10005612:	eeb0 bb45 	vmov.f64	d11, d5
10005616:	ee25 5b06 	vmul.f64	d5, d5, d6
1000561a:	0fd2      	lsrs	r2, r2, #31
1000561c:	922b      	str	r2, [sp, #172]	@ 0xac
1000561e:	9a2b      	ldr	r2, [sp, #172]	@ 0xac
10005620:	195b      	adds	r3, r3, r5
10005622:	f082 0201 	eor.w	r2, r2, #1
10005626:	ea02 72d5 	and.w	r2, r2, r5, lsr #31
1000562a:	eba6 0202 	sub.w	r2, r6, r2
1000562e:	eb42 0204 	adc.w	r2, r2, r4
10005632:	181b      	adds	r3, r3, r0
10005634:	9c00      	ldr	r4, [sp, #0]
10005636:	981c      	ldr	r0, [sp, #112]	@ 0x70
10005638:	eb41 0102 	adc.w	r1, r1, r2
1000563c:	9a18      	ldr	r2, [sp, #96]	@ 0x60
1000563e:	fb00 f904 	mul.w	r9, r0, r4
10005642:	fb02 f604 	mul.w	r6, r2, r4
10005646:	9c01      	ldr	r4, [sp, #4]
10005648:	9d01      	ldr	r5, [sp, #4]
1000564a:	fb02 f404 	mul.w	r4, r2, r4
1000564e:	9a00      	ldr	r2, [sp, #0]
10005650:	fb00 f505 	mul.w	r5, r0, r5
10005654:	ea02 72e0 	and.w	r2, r2, r0, asr #31
10005658:	9813      	ldr	r0, [sp, #76]	@ 0x4c
1000565a:	ee23 3b07 	vmul.f64	d3, d3, d7
1000565e:	eb00 0c01 	add.w	ip, r0, r1
10005662:	4494      	add	ip, r2
10005664:	9212      	str	r2, [sp, #72]	@ 0x48
10005666:	ea87 020b 	eor.w	r2, r7, fp
1000566a:	ee14 7a90 	vmov	r7, s9
1000566e:	ee1e ba90 	vmov	fp, s29
10005672:	eefc 9bc5 	vcvt.u32.f64	s19, d5
10005676:	ee1f 0a10 	vmov	r0, s30
1000567a:	ea87 0b0b 	eor.w	fp, r7, fp
1000567e:	ee13 7a10 	vmov	r7, s6
10005682:	eeb8 5b69 	vcvt.f64.u32	d5, s19
10005686:	ea4b 0b02 	orr.w	fp, fp, r2
1000568a:	4078      	eors	r0, r7
1000568c:	ee13 2a90 	vmov	r2, s7
10005690:	ee1f 7a90 	vmov	r7, s31
10005694:	ee25 5b07 	vmul.f64	d5, d5, d7
10005698:	407a      	eors	r2, r7
1000569a:	4302      	orrs	r2, r0
1000569c:	f1cb 0000 	rsb	r0, fp, #0
100056a0:	ee1b 7a10 	vmov	r7, s22
100056a4:	ea40 000b 	orr.w	r0, r0, fp
100056a8:	ee15 ba10 	vmov	fp, s10
100056ac:	0fc0      	lsrs	r0, r0, #31
100056ae:	9030      	str	r0, [sp, #192]	@ 0xc0
100056b0:	ea8b 0007 	eor.w	r0, fp, r7
100056b4:	ee1b 7a90 	vmov	r7, s23
100056b8:	ee15 ba90 	vmov	fp, s11
100056bc:	ea8b 0b07 	eor.w	fp, fp, r7
100056c0:	ee19 7a10 	vmov	r7, s18
100056c4:	ea4b 0b00 	orr.w	fp, fp, r0
100056c8:	4250      	negs	r0, r2
100056ca:	4302      	orrs	r2, r0
100056cc:	f1cb 0000 	rsb	r0, fp, #0
100056d0:	ea40 000b 	orr.w	r0, r0, fp
100056d4:	f8dd b0c0 	ldr.w	fp, [sp, #192]	@ 0xc0
100056d8:	0fd2      	lsrs	r2, r2, #31
100056da:	f08b 0b01 	eor.w	fp, fp, #1
100056de:	ea0b 7bd6 	and.w	fp, fp, r6, lsr #31
100056e2:	922f      	str	r2, [sp, #188]	@ 0xbc
100056e4:	eba7 020b 	sub.w	r2, r7, fp
100056e8:	ee1a 7a10 	vmov	r7, s20
100056ec:	9e2f      	ldr	r6, [sp, #188]	@ 0xbc
100056ee:	0fc0      	lsrs	r0, r0, #31
100056f0:	f086 0601 	eor.w	r6, r6, #1
100056f4:	ea06 76d4 	and.w	r6, r6, r4, lsr #31
100056f8:	1bbe      	subs	r6, r7, r6
100056fa:	ee19 7a90 	vmov	r7, s19
100056fe:	902e      	str	r0, [sp, #184]	@ 0xb8
10005700:	982e      	ldr	r0, [sp, #184]	@ 0xb8
10005702:	eb12 0209 	adds.w	r2, r2, r9
10005706:	f080 0001 	eor.w	r0, r0, #1
1000570a:	ea00 70d9 	and.w	r0, r0, r9, lsr #31
1000570e:	eba7 0000 	sub.w	r0, r7, r0
10005712:	eb45 0000 	adc.w	r0, r5, r0
10005716:	1912      	adds	r2, r2, r4
10005718:	eb46 0700 	adc.w	r7, r6, r0
1000571c:	9c02      	ldr	r4, [sp, #8]
1000571e:	9711      	str	r7, [sp, #68]	@ 0x44
10005720:	9f00      	ldr	r7, [sp, #0]
10005722:	9d08      	ldr	r5, [sp, #32]
10005724:	1938      	adds	r0, r7, r4
10005726:	ee05 0a90 	vmov	s11, r0
1000572a:	9f03      	ldr	r7, [sp, #12]
1000572c:	9c01      	ldr	r4, [sp, #4]
1000572e:	eeb8 fb65 	vcvt.f64.u32	d15, s11
10005732:	eb47 0404 	adc.w	r4, r7, r4
10005736:	ee05 4a90 	vmov	s11, r4
1000573a:	ee22 bb0f 	vmul.f64	d11, d2, d15
1000573e:	eeb8 eb65 	vcvt.f64.u32	d14, s11
10005742:	ee2b 3b06 	vmul.f64	d3, d11, d6
10005746:	ee2e eb02 	vmul.f64	d14, d14, d2
1000574a:	eefc 9bc3 	vcvt.u32.f64	s19, d3
1000574e:	ee2e 4b06 	vmul.f64	d4, d14, d6
10005752:	eebc 9bc4 	vcvt.u32.f64	s18, d4
10005756:	eeb8 4b69 	vcvt.f64.u32	d4, s19
1000575a:	f85a 7005 	ldr.w	r7, [sl, r5]
1000575e:	9d14      	ldr	r5, [sp, #80]	@ 0x50
10005760:	9e10      	ldr	r6, [sp, #64]	@ 0x40
10005762:	197f      	adds	r7, r7, r5
10005764:	970a      	str	r7, [sp, #40]	@ 0x28
10005766:	9d15      	ldr	r5, [sp, #84]	@ 0x54
10005768:	ee24 4b07 	vmul.f64	d4, d4, d7
1000576c:	eb46 0705 	adc.w	r7, r6, r5
10005770:	9d08      	ldr	r5, [sp, #32]
10005772:	970b      	str	r7, [sp, #44]	@ 0x2c
10005774:	f858 7005 	ldr.w	r7, [r8, r5]
10005778:	9d16      	ldr	r5, [sp, #88]	@ 0x58
1000577a:	9e0f      	ldr	r6, [sp, #60]	@ 0x3c
1000577c:	197f      	adds	r7, r7, r5
1000577e:	9d17      	ldr	r5, [sp, #92]	@ 0x5c
10005780:	970c      	str	r7, [sp, #48]	@ 0x30
10005782:	eb46 0605 	adc.w	r6, r6, r5
10005786:	9f11      	ldr	r7, [sp, #68]	@ 0x44
10005788:	9d13      	ldr	r5, [sp, #76]	@ 0x4c
1000578a:	960d      	str	r6, [sp, #52]	@ 0x34
1000578c:	1a9e      	subs	r6, r3, r2
1000578e:	9600      	str	r6, [sp, #0]
10005790:	eb6c 0707 	sbc.w	r7, ip, r7
10005794:	9e12      	ldr	r6, [sp, #72]	@ 0x48
10005796:	425b      	negs	r3, r3
10005798:	eb65 0101 	sbc.w	r1, r5, r1
1000579c:	1875      	adds	r5, r6, r1
1000579e:	9e1d      	ldr	r6, [sp, #116]	@ 0x74
100057a0:	9919      	ldr	r1, [sp, #100]	@ 0x64
100057a2:	ee2d fb0f 	vmul.f64	d15, d13, d15
100057a6:	fb00 f901 	mul.w	r9, r0, r1
100057aa:	ea00 71e6 	and.w	r1, r0, r6, asr #31
100057ae:	1a69      	subs	r1, r5, r1
100057b0:	fb04 1106 	mla	r1, r4, r6, r1
100057b4:	9d19      	ldr	r5, [sp, #100]	@ 0x64
100057b6:	fb06 f000 	mul.w	r0, r6, r0
100057ba:	fb04 fc05 	mul.w	ip, r4, r5
100057be:	ea05 74e4 	and.w	r4, r5, r4, asr #31
100057c2:	1b09      	subs	r1, r1, r4
100057c4:	e9dd 450a 	ldrd	r4, r5, [sp, #40]	@ 0x28
100057c8:	ea54 056f 	asrl	r4, r5, #1
100057cc:	ee1b 6a10 	vmov	r6, s22
100057d0:	e9ca 4500 	strd	r4, r5, [sl]
100057d4:	eeb8 3b49 	vcvt.f64.u32	d3, s18
100057d8:	ee14 5a10 	vmov	r5, s8
100057dc:	ee2f ab06 	vmul.f64	d10, d15, d6
100057e0:	ea85 0406 	eor.w	r4, r5, r6
100057e4:	ee23 3b07 	vmul.f64	d3, d3, d7
100057e8:	ee14 5a90 	vmov	r5, s9
100057ec:	ee1b 6a90 	vmov	r6, s23
100057f0:	eebc abca 	vcvt.u32.f64	s20, d10
100057f4:	ea85 0b06 	eor.w	fp, r5, r6
100057f8:	ee13 5a10 	vmov	r5, s6
100057fc:	ee1e 6a10 	vmov	r6, s28
10005800:	eeb8 5b4a 	vcvt.f64.u32	d5, s20
10005804:	ea4b 0b04 	orr.w	fp, fp, r4
10005808:	ea85 0406 	eor.w	r4, r5, r6
1000580c:	ee1e 6a90 	vmov	r6, s29
10005810:	ee13 5a90 	vmov	r5, s7
10005814:	ee25 5b07 	vmul.f64	d5, d5, d7
10005818:	4075      	eors	r5, r6
1000581a:	4325      	orrs	r5, r4
1000581c:	f1cb 0400 	rsb	r4, fp, #0
10005820:	ee15 6a10 	vmov	r6, s10
10005824:	ea44 040b 	orr.w	r4, r4, fp
10005828:	ee1f ba10 	vmov	fp, s30
1000582c:	0fe4      	lsrs	r4, r4, #31
1000582e:	9433      	str	r4, [sp, #204]	@ 0xcc
10005830:	ea86 040b 	eor.w	r4, r6, fp
10005834:	ee15 6a90 	vmov	r6, s11
10005838:	ee1f ba90 	vmov	fp, s31
1000583c:	ea86 0b0b 	eor.w	fp, r6, fp
10005840:	ea4b 0b04 	orr.w	fp, fp, r4
10005844:	426c      	negs	r4, r5
10005846:	4325      	orrs	r5, r4
10005848:	0fed      	lsrs	r5, r5, #31
1000584a:	f1cb 0400 	rsb	r4, fp, #0
1000584e:	ea44 040b 	orr.w	r4, r4, fp
10005852:	f8dd b0cc 	ldr.w	fp, [sp, #204]	@ 0xcc
10005856:	9532      	str	r5, [sp, #200]	@ 0xc8
10005858:	ee19 5a90 	vmov	r5, s19
1000585c:	ee19 6a10 	vmov	r6, s18
10005860:	f08b 0b01 	eor.w	fp, fp, #1
10005864:	ea0b 7bd9 	and.w	fp, fp, r9, lsr #31
10005868:	eba5 0b0b 	sub.w	fp, r5, fp
1000586c:	9d32      	ldr	r5, [sp, #200]	@ 0xc8
1000586e:	0fe4      	lsrs	r4, r4, #31
10005870:	f085 0501 	eor.w	r5, r5, #1
10005874:	9431      	str	r4, [sp, #196]	@ 0xc4
10005876:	ea05 75dc 	and.w	r5, r5, ip, lsr #31
1000587a:	1b74      	subs	r4, r6, r5
1000587c:	9d31      	ldr	r5, [sp, #196]	@ 0xc4
1000587e:	eb13 030b 	adds.w	r3, r3, fp
10005882:	f085 0501 	eor.w	r5, r5, #1
10005886:	f141 0100 	adc.w	r1, r1, #0
1000588a:	ea05 75d0 	and.w	r5, r5, r0, lsr #31
1000588e:	181b      	adds	r3, r3, r0
10005890:	ee1a 0a10 	vmov	r0, s20
10005894:	eba0 0505 	sub.w	r5, r0, r5
10005898:	eb45 0501 	adc.w	r5, r5, r1
1000589c:	eb13 030c 	adds.w	r3, r3, ip
100058a0:	eb44 0405 	adc.w	r4, r4, r5
100058a4:	1a99      	subs	r1, r3, r2
100058a6:	9b11      	ldr	r3, [sp, #68]	@ 0x44
100058a8:	9e00      	ldr	r6, [sp, #0]
100058aa:	eb64 0403 	sbc.w	r4, r4, r3
100058ae:	e9dd 230c 	ldrd	r2, r3, [sp, #48]	@ 0x30
100058b2:	ea52 036f 	asrl	r2, r3, #1
100058b6:	e9c8 2300 	strd	r2, r3, [r8]
100058ba:	9a08      	ldr	r2, [sp, #32]
100058bc:	9b0e      	ldr	r3, [sp, #56]	@ 0x38
100058be:	f84a 6002 	str.w	r6, [sl, r2]
100058c2:	605f      	str	r7, [r3, #4]
100058c4:	f848 1002 	str.w	r1, [r8, r2]
100058c8:	9a09      	ldr	r2, [sp, #36]	@ 0x24
100058ca:	f108 0808 	add.w	r8, r8, #8
100058ce:	6054      	str	r4, [r2, #4]
100058d0:	f1be 0e01 	subs.w	lr, lr, #1
100058d4:	f47f adbe 	bne.w	10005454 <fndsa_vect_iFFT_fp64q+0x114>
100058d8:	e9dd cb1e 	ldrd	ip, fp, [sp, #120]	@ 0x78
100058dc:	9f20      	ldr	r7, [sp, #128]	@ 0x80
100058de:	9b21      	ldr	r3, [sp, #132]	@ 0x84
100058e0:	3710      	adds	r7, #16
100058e2:	449c      	add	ip, r3
100058e4:	9b23      	ldr	r3, [sp, #140]	@ 0x8c
100058e6:	449b      	add	fp, r3
100058e8:	9b22      	ldr	r3, [sp, #136]	@ 0x88
100058ea:	42bb      	cmp	r3, r7
100058ec:	f47f ad5f 	bne.w	100053ae <fndsa_vect_iFFT_fp64q+0x6e>
100058f0:	9d27      	ldr	r5, [sp, #156]	@ 0x9c
100058f2:	3d01      	subs	r5, #1
100058f4:	f47f ad3b 	bne.w	1000536e <fndsa_vect_iFFT_fp64q+0x2e>
100058f8:	b03d      	add	sp, #244	@ 0xf4
100058fa:	ecbd 8b10 	vpop	{d8-d15}
100058fe:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
