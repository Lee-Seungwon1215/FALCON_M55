
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/r1-kernels/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10000368 <fxr_div_fp64_exact>:
10000368:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
1000036c:	4607      	mov	r7, r0
1000036e:	f04f 0c00 	mov.w	ip, #0
10000372:	ea4f 79d1 	mov.w	r9, r1, lsr #31
10000376:	ea4f 78d3 	mov.w	r8, r3, lsr #31
1000037a:	ea82 74e3 	eor.w	r4, r2, r3, asr #31
1000037e:	ea83 75e3 	eor.w	r5, r3, r3, asr #31
10000382:	ea89 0308 	eor.w	r3, r9, r8
10000386:	b0a7      	sub	sp, #156	@ 0x9c
10000388:	425a      	negs	r2, r3
1000038a:	ea87 77e1 	eor.w	r7, r7, r1, asr #31
1000038e:	ea81 76e1 	eor.w	r6, r1, r1, asr #31
10000392:	9212      	str	r2, [sp, #72]	@ 0x48
10000394:	9213      	str	r2, [sp, #76]	@ 0x4c
10000396:	eb17 0209 	adds.w	r2, r7, r9
1000039a:	930b      	str	r3, [sp, #44]	@ 0x2c
1000039c:	f146 0300 	adc.w	r3, r6, #0
100003a0:	eb14 0408 	adds.w	r4, r4, r8
100003a4:	f145 0500 	adc.w	r5, r5, #0
100003a8:	ea45 0604 	orr.w	r6, r5, r4
100003ac:	462f      	mov	r7, r5
100003ae:	ee07 5a90 	vmov	s15, r5
100003b2:	4275      	negs	r5, r6
100003b4:	4335      	orrs	r5, r6
100003b6:	0fed      	lsrs	r5, r5, #31
100003b8:	9517      	str	r5, [sp, #92]	@ 0x5c
100003ba:	9d17      	ldr	r5, [sp, #92]	@ 0x5c
100003bc:	ed9f 6bce 	vldr	d6, [pc, #824]	@ 100006f8 <fxr_div_fp64_exact+0x390>
100003c0:	f085 0501 	eor.w	r5, r5, #1
100003c4:	f115 3aff 	adds.w	sl, r5, #4294967295	@ 0xffffffff
100003c8:	f14c 38ff 	adc.w	r8, ip, #4294967295	@ 0xffffffff
100003cc:	ea08 0803 	and.w	r8, r8, r3
100003d0:	ea0a 0602 	and.w	r6, sl, r2
100003d4:	ee02 6a90 	vmov	s5, r6
100003d8:	ee05 8a90 	vmov	s11, r8
100003dc:	eeb8 4b67 	vcvt.f64.u32	d4, s15
100003e0:	eeb8 5b65 	vcvt.f64.u32	d5, s11
100003e4:	eeb8 7b62 	vcvt.f64.u32	d7, s5
100003e8:	ea44 0a05 	orr.w	sl, r4, r5
100003ec:	ee05 7b06 	vmla.f64	d7, d5, d6
100003f0:	ee05 aa90 	vmov	s11, sl
100003f4:	eeb8 5b65 	vcvt.f64.u32	d5, s11
100003f8:	ee04 5b06 	vmla.f64	d5, d4, d6
100003fc:	950a      	str	r5, [sp, #40]	@ 0x28
100003fe:	2400      	movs	r4, #0
10000400:	2500      	movs	r5, #0
10000402:	ee86 4b05 	vdiv.f64	d4, d6, d5
10000406:	17de      	asrs	r6, r3, #31
10000408:	46bb      	mov	fp, r7
1000040a:	9611      	str	r6, [sp, #68]	@ 0x44
1000040c:	9709      	str	r7, [sp, #36]	@ 0x24
1000040e:	4626      	mov	r6, r4
10000410:	462f      	mov	r7, r5
10000412:	ed9f 3bbb 	vldr	d3, [pc, #748]	@ 10000700 <fxr_div_fp64_exact+0x398>
10000416:	ee27 7b04 	vmul.f64	d7, d7, d4
1000041a:	e9cd 6700 	strd	r6, r7, [sp]
1000041e:	e9cd 6704 	strd	r6, r7, [sp, #16]
10000422:	e9cd 6706 	strd	r6, r7, [sp, #24]
10000426:	4616      	mov	r6, r2
10000428:	461f      	mov	r7, r3
1000042a:	ee27 7b03 	vmul.f64	d7, d7, d3
1000042e:	ea52 73df 	lsrl	r2, r3, #31
10000432:	ea56 779f 	lsrl	r6, r7, #30
10000436:	ed8d 7b02 	vstr	d7, [sp, #8]
1000043a:	43d7      	mvns	r7, r2
1000043c:	43f6      	mvns	r6, r6
1000043e:	f8df e2d0 	ldr.w	lr, [pc, #720]	@ 10000710 <fxr_div_fp64_exact+0x3a8>
10000442:	f00a 0101 	and.w	r1, sl, #1
10000446:	48b0      	ldr	r0, [pc, #704]	@ (10000708 <fxr_div_fp64_exact+0x3a0>)
10000448:	910f      	str	r1, [sp, #60]	@ 0x3c
1000044a:	49b0      	ldr	r1, [pc, #704]	@ (1000070c <fxr_div_fp64_exact+0x3a4>)
1000044c:	970e      	str	r7, [sp, #56]	@ 0x38
1000044e:	e9dd 9702 	ldrd	r9, r7, [sp, #8]
10000452:	ebbe 0209 	subs.w	r2, lr, r9
10000456:	eb61 0207 	sbc.w	r2, r1, r7
1000045a:	f006 0301 	and.w	r3, r6, #1
1000045e:	ea47 0600 	orr.w	r6, r7, r0
10000462:	4032      	ands	r2, r6
10000464:	ea07 0600 	and.w	r6, r7, r0
10000468:	4332      	orrs	r2, r6
1000046a:	0fd2      	lsrs	r2, r2, #31
1000046c:	9216      	str	r2, [sp, #88]	@ 0x58
1000046e:	9a16      	ldr	r2, [sp, #88]	@ 0x58
10000470:	9310      	str	r3, [sp, #64]	@ 0x40
10000472:	4254      	negs	r4, r2
10000474:	eb6c 050c 	sbc.w	r5, ip, ip
10000478:	e9cd 4524 	strd	r4, r5, [sp, #144]	@ 0x90
1000047c:	e9dd 2324 	ldrd	r2, r3, [sp, #144]	@ 0x90
10000480:	ea89 050e 	eor.w	r5, r9, lr
10000484:	ea87 0401 	eor.w	r4, r7, r1
10000488:	4015      	ands	r5, r2
1000048a:	401c      	ands	r4, r3
1000048c:	ea85 0209 	eor.w	r2, r5, r9
10000490:	407c      	eors	r4, r7
10000492:	9200      	str	r2, [sp, #0]
10000494:	9401      	str	r4, [sp, #4]
10000496:	ed9d 7b00 	vldr	d7, [sp]
1000049a:	4654      	mov	r4, sl
1000049c:	eefc 7bc7 	vcvt.u32.f64	s15, d7
100004a0:	465d      	mov	r5, fp
100004a2:	ee17 6a90 	vmov	r6, s15
100004a6:	ea54 055f 	lsrl	r4, r5, #1
100004aa:	2200      	movs	r2, #0
100004ac:	2300      	movs	r3, #0
100004ae:	ee12 9a90 	vmov	r9, s5
100004b2:	e9cd 450c 	strd	r4, r5, [sp, #48]	@ 0x30
100004b6:	e9cd 2302 	strd	r2, r3, [sp, #8]
100004ba:	fba6 420a 	umull	r4, r2, r6, sl
100004be:	ebb9 0304 	subs.w	r3, r9, r4
100004c2:	46e1      	mov	r9, ip
100004c4:	fbeb 2906 	umlal	r2, r9, fp, r6
100004c8:	eb68 0602 	sbc.w	r6, r8, r2
100004cc:	ea62 0408 	orn	r4, r2, r8
100004d0:	4034      	ands	r4, r6
100004d2:	ea22 0208 	bic.w	r2, r2, r8
100004d6:	4314      	orrs	r4, r2
100004d8:	0fe4      	lsrs	r4, r4, #31
100004da:	941c      	str	r4, [sp, #112]	@ 0x70
100004dc:	9a1c      	ldr	r2, [sp, #112]	@ 0x70
100004de:	edcd 7a00 	vstr	s15, [sp]
100004e2:	eb09 0802 	add.w	r8, r9, r2
100004e6:	f1c8 0700 	rsb	r7, r8, #0
100004ea:	ea0a 74e7 	and.w	r4, sl, r7, asr #31
100004ee:	191b      	adds	r3, r3, r4
100004f0:	ea0b 74e7 	and.w	r4, fp, r7, asr #31
100004f4:	4621      	mov	r1, r4
100004f6:	eb46 0504 	adc.w	r5, r6, r4
100004fa:	ebb3 040a 	subs.w	r4, r3, sl
100004fe:	ea66 0405 	orn	r4, r6, r5
10000502:	ea04 0401 	and.w	r4, r4, r1
10000506:	ea26 0605 	bic.w	r6, r6, r5
1000050a:	ea44 0406 	orr.w	r4, r4, r6
1000050e:	ee17 6a90 	vmov	r6, s15
10000512:	ea4f 74d4 	mov.w	r4, r4, lsr #31
10000516:	941d      	str	r4, [sp, #116]	@ 0x74
10000518:	9c1d      	ldr	r4, [sp, #116]	@ 0x74
1000051a:	497c      	ldr	r1, [pc, #496]	@ (1000070c <fxr_div_fp64_exact+0x3a4>)
1000051c:	eba2 0204 	sub.w	r2, r2, r4
10000520:	444a      	add	r2, r9
10000522:	eba4 0408 	sub.w	r4, r4, r8
10000526:	ea42 0204 	orr.w	r2, r2, r4
1000052a:	ea4f 72d2 	mov.w	r2, r2, lsr #31
1000052e:	921e      	str	r2, [sp, #120]	@ 0x78
10000530:	ea6b 0405 	orn	r4, fp, r5
10000534:	eb65 020b 	sbc.w	r2, r5, fp
10000538:	4022      	ands	r2, r4
1000053a:	ea2b 0405 	bic.w	r4, fp, r5
1000053e:	4322      	orrs	r2, r4
10000540:	0fd2      	lsrs	r2, r2, #31
10000542:	9c1e      	ldr	r4, [sp, #120]	@ 0x78
10000544:	921f      	str	r2, [sp, #124]	@ 0x7c
10000546:	9a1f      	ldr	r2, [sp, #124]	@ 0x7c
10000548:	f082 0201 	eor.w	r2, r2, #1
1000054c:	4322      	orrs	r2, r4
1000054e:	18b4      	adds	r4, r6, r2
10000550:	4252      	negs	r2, r2
10000552:	eba4 78d7 	sub.w	r8, r4, r7, lsr #31
10000556:	ea02 020a 	and.w	r2, r2, sl
1000055a:	eb6c 040c 	sbc.w	r4, ip, ip
1000055e:	ea04 040b 	and.w	r4, r4, fp
10000562:	1a9b      	subs	r3, r3, r2
10000564:	eb65 0404 	sbc.w	r4, r5, r4
10000568:	ee07 4a90 	vmov	s15, r4
1000056c:	eeb8 5b67 	vcvt.f64.u32	d5, s15
10000570:	ee07 3a90 	vmov	s15, r3
10000574:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10000578:	ee05 7b06 	vmla.f64	d7, d5, d6
1000057c:	ee27 7b04 	vmul.f64	d7, d7, d4
10000580:	ed8d 7b00 	vstr	d7, [sp]
10000584:	e9dd 5200 	ldrd	r5, r2, [sp]
10000588:	ebbe 0605 	subs.w	r6, lr, r5
1000058c:	eb61 0702 	sbc.w	r7, r1, r2
10000590:	ea82 0601 	eor.w	r6, r2, r1
10000594:	ea42 0100 	orr.w	r1, r2, r0
10000598:	4039      	ands	r1, r7
1000059a:	4010      	ands	r0, r2
1000059c:	4301      	orrs	r1, r0
1000059e:	0fc9      	lsrs	r1, r1, #31
100005a0:	9115      	str	r1, [sp, #84]	@ 0x54
100005a2:	9915      	ldr	r1, [sp, #84]	@ 0x54
100005a4:	ea85 0e0e 	eor.w	lr, r5, lr
100005a8:	4249      	negs	r1, r1
100005aa:	9104      	str	r1, [sp, #16]
100005ac:	eb6c 010c 	sbc.w	r1, ip, ip
100005b0:	9105      	str	r1, [sp, #20]
100005b2:	e9dd 0104 	ldrd	r0, r1, [sp, #16]
100005b6:	e9cd 0122 	strd	r0, r1, [sp, #136]	@ 0x88
100005ba:	e9dd 0122 	ldrd	r0, r1, [sp, #136]	@ 0x88
100005be:	ea0e 0e00 	and.w	lr, lr, r0
100005c2:	4031      	ands	r1, r6
100005c4:	404a      	eors	r2, r1
100005c6:	ea8e 0605 	eor.w	r6, lr, r5
100005ca:	9606      	str	r6, [sp, #24]
100005cc:	9207      	str	r2, [sp, #28]
100005ce:	ed9d 7b06 	vldr	d7, [sp, #24]
100005d2:	eefc 7bc7 	vcvt.u32.f64	s15, d7
100005d6:	ee17 9a90 	vmov	r9, s15
100005da:	46e6      	mov	lr, ip
100005dc:	fba9 210a 	umull	r2, r1, r9, sl
100005e0:	fbeb 1e09 	umlal	r1, lr, fp, r9
100005e4:	4677      	mov	r7, lr
100005e6:	ebbc 0202 	subs.w	r2, ip, r2
100005ea:	eb63 0601 	sbc.w	r6, r3, r1
100005ee:	ea61 0003 	orn	r0, r1, r3
100005f2:	4030      	ands	r0, r6
100005f4:	ea21 0103 	bic.w	r1, r1, r3
100005f8:	4308      	orrs	r0, r1
100005fa:	0fc0      	lsrs	r0, r0, #31
100005fc:	9018      	str	r0, [sp, #96]	@ 0x60
100005fe:	9b18      	ldr	r3, [sp, #96]	@ 0x60
10000600:	1ae5      	subs	r5, r4, r3
10000602:	1bed      	subs	r5, r5, r7
10000604:	ea0a 71e5 	and.w	r1, sl, r5, asr #31
10000608:	ea0b 7ee5 	and.w	lr, fp, r5, asr #31
1000060c:	1852      	adds	r2, r2, r1
1000060e:	eb46 000e 	adc.w	r0, r6, lr
10000612:	ebb2 010a 	subs.w	r1, r2, sl
10000616:	ea66 0100 	orn	r1, r6, r0
1000061a:	ea01 010e 	and.w	r1, r1, lr
1000061e:	ea26 0600 	bic.w	r6, r6, r0
10000622:	ea41 0106 	orr.w	r1, r1, r6
10000626:	ea4f 71d1 	mov.w	r1, r1, lsr #31
1000062a:	9119      	str	r1, [sp, #100]	@ 0x64
1000062c:	9919      	ldr	r1, [sp, #100]	@ 0x64
1000062e:	eba3 0301 	sub.w	r3, r3, r1
10000632:	eba3 0304 	sub.w	r3, r3, r4
10000636:	4429      	add	r1, r5
10000638:	443b      	add	r3, r7
1000063a:	ea43 0301 	orr.w	r3, r3, r1
1000063e:	ea4f 73d3 	mov.w	r3, r3, lsr #31
10000642:	931a      	str	r3, [sp, #104]	@ 0x68
10000644:	ea6b 0100 	orn	r1, fp, r0
10000648:	eb60 030b 	sbc.w	r3, r0, fp
1000064c:	400b      	ands	r3, r1
1000064e:	ea2b 0100 	bic.w	r1, fp, r0
10000652:	430b      	orrs	r3, r1
10000654:	0fdb      	lsrs	r3, r3, #31
10000656:	991a      	ldr	r1, [sp, #104]	@ 0x68
10000658:	931b      	str	r3, [sp, #108]	@ 0x6c
1000065a:	9b1b      	ldr	r3, [sp, #108]	@ 0x6c
1000065c:	f083 0301 	eor.w	r3, r3, #1
10000660:	430b      	orrs	r3, r1
10000662:	4499      	add	r9, r3
10000664:	425b      	negs	r3, r3
10000666:	eb6c 010c 	sbc.w	r1, ip, ip
1000066a:	ea03 030a 	and.w	r3, r3, sl
1000066e:	1ad3      	subs	r3, r2, r3
10000670:	ea01 010b 	and.w	r1, r1, fp
10000674:	eb60 0101 	sbc.w	r1, r0, r1
10000678:	980f      	ldr	r0, [sp, #60]	@ 0x3c
1000067a:	e9dd ab0c 	ldrd	sl, fp, [sp, #48]	@ 0x30
1000067e:	eb1a 0000 	adds.w	r0, sl, r0
10000682:	f14b 0200 	adc.w	r2, fp, #0
10000686:	1a18      	subs	r0, r3, r0
10000688:	eb61 0302 	sbc.w	r3, r1, r2
1000068c:	ea62 0001 	orn	r0, r2, r1
10000690:	4003      	ands	r3, r0
10000692:	ea22 0201 	bic.w	r2, r2, r1
10000696:	4313      	orrs	r3, r2
10000698:	0fdb      	lsrs	r3, r3, #31
1000069a:	9314      	str	r3, [sp, #80]	@ 0x50
1000069c:	9b14      	ldr	r3, [sp, #80]	@ 0x50
1000069e:	eba9 79d5 	sub.w	r9, r9, r5, lsr #31
100006a2:	f083 0301 	eor.w	r3, r3, #1
100006a6:	9d0a      	ldr	r5, [sp, #40]	@ 0x28
100006a8:	eb13 0309 	adds.w	r3, r3, r9
100006ac:	f148 0200 	adc.w	r2, r8, #0
100006b0:	4269      	negs	r1, r5
100006b2:	9102      	str	r1, [sp, #8]
100006b4:	eb6c 010c 	sbc.w	r1, ip, ip
100006b8:	9103      	str	r1, [sp, #12]
100006ba:	9f0e      	ldr	r7, [sp, #56]	@ 0x38
100006bc:	9810      	ldr	r0, [sp, #64]	@ 0x40
100006be:	9e11      	ldr	r6, [sp, #68]	@ 0x44
100006c0:	19c0      	adds	r0, r0, r7
100006c2:	9c12      	ldr	r4, [sp, #72]	@ 0x48
100006c4:	9d13      	ldr	r5, [sp, #76]	@ 0x4c
100006c6:	f166 0100 	sbc.w	r1, r6, #0
100006ca:	4058      	eors	r0, r3
100006cc:	e9dd 8902 	ldrd	r8, r9, [sp, #8]
100006d0:	e9cd 8920 	strd	r8, r9, [sp, #128]	@ 0x80
100006d4:	e9dd 6720 	ldrd	r6, r7, [sp, #128]	@ 0x80
100006d8:	405c      	eors	r4, r3
100006da:	4051      	eors	r1, r2
100006dc:	ea85 0302 	eor.w	r3, r5, r2
100006e0:	4030      	ands	r0, r6
100006e2:	9a0b      	ldr	r2, [sp, #44]	@ 0x2c
100006e4:	4039      	ands	r1, r7
100006e6:	4060      	eors	r0, r4
100006e8:	1880      	adds	r0, r0, r2
100006ea:	ea81 0103 	eor.w	r1, r1, r3
100006ee:	f141 0100 	adc.w	r1, r1, #0
100006f2:	b027      	add	sp, #156	@ 0x9c
100006f4:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
100006f8:	00000000 	.word	0x00000000
100006fc:	41f00000 	.word	0x41f00000
10000700:	00000000 	.word	0x00000000
10000704:	3df00000 	.word	0x3df00000
10000708:	be100000 	.word	0xbe100000
1000070c:	41efffff 	.word	0x41efffff
10000710:	ffe00000 	.word	0xffe00000
