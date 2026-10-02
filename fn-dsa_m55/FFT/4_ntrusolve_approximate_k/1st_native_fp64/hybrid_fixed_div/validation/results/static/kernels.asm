
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/hybrid_fixed_div/validation/build/kernels/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

100003a8 <fxr_div_fp64_exact>:
100003a8:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
100003ac:	4607      	mov	r7, r0
100003ae:	f04f 0c00 	mov.w	ip, #0
100003b2:	ea4f 79d1 	mov.w	r9, r1, lsr #31
100003b6:	ea4f 78d3 	mov.w	r8, r3, lsr #31
100003ba:	ea82 74e3 	eor.w	r4, r2, r3, asr #31
100003be:	ea83 75e3 	eor.w	r5, r3, r3, asr #31
100003c2:	ea89 0308 	eor.w	r3, r9, r8
100003c6:	b0a7      	sub	sp, #156	@ 0x9c
100003c8:	425a      	negs	r2, r3
100003ca:	ea87 77e1 	eor.w	r7, r7, r1, asr #31
100003ce:	ea81 76e1 	eor.w	r6, r1, r1, asr #31
100003d2:	9212      	str	r2, [sp, #72]	@ 0x48
100003d4:	9213      	str	r2, [sp, #76]	@ 0x4c
100003d6:	eb17 0209 	adds.w	r2, r7, r9
100003da:	930b      	str	r3, [sp, #44]	@ 0x2c
100003dc:	f146 0300 	adc.w	r3, r6, #0
100003e0:	eb14 0408 	adds.w	r4, r4, r8
100003e4:	f145 0500 	adc.w	r5, r5, #0
100003e8:	ea45 0604 	orr.w	r6, r5, r4
100003ec:	462f      	mov	r7, r5
100003ee:	ee07 5a90 	vmov	s15, r5
100003f2:	4275      	negs	r5, r6
100003f4:	4335      	orrs	r5, r6
100003f6:	0fed      	lsrs	r5, r5, #31
100003f8:	9517      	str	r5, [sp, #92]	@ 0x5c
100003fa:	9d17      	ldr	r5, [sp, #92]	@ 0x5c
100003fc:	ed9f 6bce 	vldr	d6, [pc, #824]	@ 10000738 <fxr_div_fp64_exact+0x390>
10000400:	f085 0501 	eor.w	r5, r5, #1
10000404:	f115 3aff 	adds.w	sl, r5, #4294967295	@ 0xffffffff
10000408:	f14c 38ff 	adc.w	r8, ip, #4294967295	@ 0xffffffff
1000040c:	ea08 0803 	and.w	r8, r8, r3
10000410:	ea0a 0602 	and.w	r6, sl, r2
10000414:	ee02 6a90 	vmov	s5, r6
10000418:	ee05 8a90 	vmov	s11, r8
1000041c:	eeb8 4b67 	vcvt.f64.u32	d4, s15
10000420:	eeb8 5b65 	vcvt.f64.u32	d5, s11
10000424:	eeb8 7b62 	vcvt.f64.u32	d7, s5
10000428:	ea44 0a05 	orr.w	sl, r4, r5
1000042c:	ee05 7b06 	vmla.f64	d7, d5, d6
10000430:	ee05 aa90 	vmov	s11, sl
10000434:	eeb8 5b65 	vcvt.f64.u32	d5, s11
10000438:	ee04 5b06 	vmla.f64	d5, d4, d6
1000043c:	950a      	str	r5, [sp, #40]	@ 0x28
1000043e:	2400      	movs	r4, #0
10000440:	2500      	movs	r5, #0
10000442:	ee86 4b05 	vdiv.f64	d4, d6, d5
10000446:	17de      	asrs	r6, r3, #31
10000448:	46bb      	mov	fp, r7
1000044a:	9611      	str	r6, [sp, #68]	@ 0x44
1000044c:	9709      	str	r7, [sp, #36]	@ 0x24
1000044e:	4626      	mov	r6, r4
10000450:	462f      	mov	r7, r5
10000452:	ed9f 3bbb 	vldr	d3, [pc, #748]	@ 10000740 <fxr_div_fp64_exact+0x398>
10000456:	ee27 7b04 	vmul.f64	d7, d7, d4
1000045a:	e9cd 6700 	strd	r6, r7, [sp]
1000045e:	e9cd 6704 	strd	r6, r7, [sp, #16]
10000462:	e9cd 6706 	strd	r6, r7, [sp, #24]
10000466:	4616      	mov	r6, r2
10000468:	461f      	mov	r7, r3
1000046a:	ee27 7b03 	vmul.f64	d7, d7, d3
1000046e:	ea52 73df 	lsrl	r2, r3, #31
10000472:	ea56 779f 	lsrl	r6, r7, #30
10000476:	ed8d 7b02 	vstr	d7, [sp, #8]
1000047a:	43d7      	mvns	r7, r2
1000047c:	43f6      	mvns	r6, r6
1000047e:	f8df e2d0 	ldr.w	lr, [pc, #720]	@ 10000750 <fxr_div_fp64_exact+0x3a8>
10000482:	f00a 0101 	and.w	r1, sl, #1
10000486:	48b0      	ldr	r0, [pc, #704]	@ (10000748 <fxr_div_fp64_exact+0x3a0>)
10000488:	910f      	str	r1, [sp, #60]	@ 0x3c
1000048a:	49b0      	ldr	r1, [pc, #704]	@ (1000074c <fxr_div_fp64_exact+0x3a4>)
1000048c:	970e      	str	r7, [sp, #56]	@ 0x38
1000048e:	e9dd 9702 	ldrd	r9, r7, [sp, #8]
10000492:	ebbe 0209 	subs.w	r2, lr, r9
10000496:	eb61 0207 	sbc.w	r2, r1, r7
1000049a:	f006 0301 	and.w	r3, r6, #1
1000049e:	ea47 0600 	orr.w	r6, r7, r0
100004a2:	4032      	ands	r2, r6
100004a4:	ea07 0600 	and.w	r6, r7, r0
100004a8:	4332      	orrs	r2, r6
100004aa:	0fd2      	lsrs	r2, r2, #31
100004ac:	9216      	str	r2, [sp, #88]	@ 0x58
100004ae:	9a16      	ldr	r2, [sp, #88]	@ 0x58
100004b0:	9310      	str	r3, [sp, #64]	@ 0x40
100004b2:	4254      	negs	r4, r2
100004b4:	eb6c 050c 	sbc.w	r5, ip, ip
100004b8:	e9cd 4524 	strd	r4, r5, [sp, #144]	@ 0x90
100004bc:	e9dd 2324 	ldrd	r2, r3, [sp, #144]	@ 0x90
100004c0:	ea89 050e 	eor.w	r5, r9, lr
100004c4:	ea87 0401 	eor.w	r4, r7, r1
100004c8:	4015      	ands	r5, r2
100004ca:	401c      	ands	r4, r3
100004cc:	ea85 0209 	eor.w	r2, r5, r9
100004d0:	407c      	eors	r4, r7
100004d2:	9200      	str	r2, [sp, #0]
100004d4:	9401      	str	r4, [sp, #4]
100004d6:	ed9d 7b00 	vldr	d7, [sp]
100004da:	4654      	mov	r4, sl
100004dc:	eefc 7bc7 	vcvt.u32.f64	s15, d7
100004e0:	465d      	mov	r5, fp
100004e2:	ee17 6a90 	vmov	r6, s15
100004e6:	ea54 055f 	lsrl	r4, r5, #1
100004ea:	2200      	movs	r2, #0
100004ec:	2300      	movs	r3, #0
100004ee:	ee12 9a90 	vmov	r9, s5
100004f2:	e9cd 450c 	strd	r4, r5, [sp, #48]	@ 0x30
100004f6:	e9cd 2302 	strd	r2, r3, [sp, #8]
100004fa:	fba6 420a 	umull	r4, r2, r6, sl
100004fe:	ebb9 0304 	subs.w	r3, r9, r4
10000502:	46e1      	mov	r9, ip
10000504:	fbeb 2906 	umlal	r2, r9, fp, r6
10000508:	eb68 0602 	sbc.w	r6, r8, r2
1000050c:	ea62 0408 	orn	r4, r2, r8
10000510:	4034      	ands	r4, r6
10000512:	ea22 0208 	bic.w	r2, r2, r8
10000516:	4314      	orrs	r4, r2
10000518:	0fe4      	lsrs	r4, r4, #31
1000051a:	941c      	str	r4, [sp, #112]	@ 0x70
1000051c:	9a1c      	ldr	r2, [sp, #112]	@ 0x70
1000051e:	edcd 7a00 	vstr	s15, [sp]
10000522:	eb09 0802 	add.w	r8, r9, r2
10000526:	f1c8 0700 	rsb	r7, r8, #0
1000052a:	ea0a 74e7 	and.w	r4, sl, r7, asr #31
1000052e:	191b      	adds	r3, r3, r4
10000530:	ea0b 74e7 	and.w	r4, fp, r7, asr #31
10000534:	4621      	mov	r1, r4
10000536:	eb46 0504 	adc.w	r5, r6, r4
1000053a:	ebb3 040a 	subs.w	r4, r3, sl
1000053e:	ea66 0405 	orn	r4, r6, r5
10000542:	ea04 0401 	and.w	r4, r4, r1
10000546:	ea26 0605 	bic.w	r6, r6, r5
1000054a:	ea44 0406 	orr.w	r4, r4, r6
1000054e:	ee17 6a90 	vmov	r6, s15
10000552:	ea4f 74d4 	mov.w	r4, r4, lsr #31
10000556:	941d      	str	r4, [sp, #116]	@ 0x74
10000558:	9c1d      	ldr	r4, [sp, #116]	@ 0x74
1000055a:	497c      	ldr	r1, [pc, #496]	@ (1000074c <fxr_div_fp64_exact+0x3a4>)
1000055c:	eba2 0204 	sub.w	r2, r2, r4
10000560:	444a      	add	r2, r9
10000562:	eba4 0408 	sub.w	r4, r4, r8
10000566:	ea42 0204 	orr.w	r2, r2, r4
1000056a:	ea4f 72d2 	mov.w	r2, r2, lsr #31
1000056e:	921e      	str	r2, [sp, #120]	@ 0x78
10000570:	ea6b 0405 	orn	r4, fp, r5
10000574:	eb65 020b 	sbc.w	r2, r5, fp
10000578:	4022      	ands	r2, r4
1000057a:	ea2b 0405 	bic.w	r4, fp, r5
1000057e:	4322      	orrs	r2, r4
10000580:	0fd2      	lsrs	r2, r2, #31
10000582:	9c1e      	ldr	r4, [sp, #120]	@ 0x78
10000584:	921f      	str	r2, [sp, #124]	@ 0x7c
10000586:	9a1f      	ldr	r2, [sp, #124]	@ 0x7c
10000588:	f082 0201 	eor.w	r2, r2, #1
1000058c:	4322      	orrs	r2, r4
1000058e:	18b4      	adds	r4, r6, r2
10000590:	4252      	negs	r2, r2
10000592:	eba4 78d7 	sub.w	r8, r4, r7, lsr #31
10000596:	ea02 020a 	and.w	r2, r2, sl
1000059a:	eb6c 040c 	sbc.w	r4, ip, ip
1000059e:	ea04 040b 	and.w	r4, r4, fp
100005a2:	1a9b      	subs	r3, r3, r2
100005a4:	eb65 0404 	sbc.w	r4, r5, r4
100005a8:	ee07 4a90 	vmov	s15, r4
100005ac:	eeb8 5b67 	vcvt.f64.u32	d5, s15
100005b0:	ee07 3a90 	vmov	s15, r3
100005b4:	eeb8 7b67 	vcvt.f64.u32	d7, s15
100005b8:	ee05 7b06 	vmla.f64	d7, d5, d6
100005bc:	ee27 7b04 	vmul.f64	d7, d7, d4
100005c0:	ed8d 7b00 	vstr	d7, [sp]
100005c4:	e9dd 5200 	ldrd	r5, r2, [sp]
100005c8:	ebbe 0605 	subs.w	r6, lr, r5
100005cc:	eb61 0702 	sbc.w	r7, r1, r2
100005d0:	ea82 0601 	eor.w	r6, r2, r1
100005d4:	ea42 0100 	orr.w	r1, r2, r0
100005d8:	4039      	ands	r1, r7
100005da:	4010      	ands	r0, r2
100005dc:	4301      	orrs	r1, r0
100005de:	0fc9      	lsrs	r1, r1, #31
100005e0:	9115      	str	r1, [sp, #84]	@ 0x54
100005e2:	9915      	ldr	r1, [sp, #84]	@ 0x54
100005e4:	ea85 0e0e 	eor.w	lr, r5, lr
100005e8:	4249      	negs	r1, r1
100005ea:	9104      	str	r1, [sp, #16]
100005ec:	eb6c 010c 	sbc.w	r1, ip, ip
100005f0:	9105      	str	r1, [sp, #20]
100005f2:	e9dd 0104 	ldrd	r0, r1, [sp, #16]
100005f6:	e9cd 0122 	strd	r0, r1, [sp, #136]	@ 0x88
100005fa:	e9dd 0122 	ldrd	r0, r1, [sp, #136]	@ 0x88
100005fe:	ea0e 0e00 	and.w	lr, lr, r0
10000602:	4031      	ands	r1, r6
10000604:	404a      	eors	r2, r1
10000606:	ea8e 0605 	eor.w	r6, lr, r5
1000060a:	9606      	str	r6, [sp, #24]
1000060c:	9207      	str	r2, [sp, #28]
1000060e:	ed9d 7b06 	vldr	d7, [sp, #24]
10000612:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10000616:	ee17 9a90 	vmov	r9, s15
1000061a:	46e6      	mov	lr, ip
1000061c:	fba9 210a 	umull	r2, r1, r9, sl
10000620:	fbeb 1e09 	umlal	r1, lr, fp, r9
10000624:	4677      	mov	r7, lr
10000626:	ebbc 0202 	subs.w	r2, ip, r2
1000062a:	eb63 0601 	sbc.w	r6, r3, r1
1000062e:	ea61 0003 	orn	r0, r1, r3
10000632:	4030      	ands	r0, r6
10000634:	ea21 0103 	bic.w	r1, r1, r3
10000638:	4308      	orrs	r0, r1
1000063a:	0fc0      	lsrs	r0, r0, #31
1000063c:	9018      	str	r0, [sp, #96]	@ 0x60
1000063e:	9b18      	ldr	r3, [sp, #96]	@ 0x60
10000640:	1ae5      	subs	r5, r4, r3
10000642:	1bed      	subs	r5, r5, r7
10000644:	ea0a 71e5 	and.w	r1, sl, r5, asr #31
10000648:	ea0b 7ee5 	and.w	lr, fp, r5, asr #31
1000064c:	1852      	adds	r2, r2, r1
1000064e:	eb46 000e 	adc.w	r0, r6, lr
10000652:	ebb2 010a 	subs.w	r1, r2, sl
10000656:	ea66 0100 	orn	r1, r6, r0
1000065a:	ea01 010e 	and.w	r1, r1, lr
1000065e:	ea26 0600 	bic.w	r6, r6, r0
10000662:	ea41 0106 	orr.w	r1, r1, r6
10000666:	ea4f 71d1 	mov.w	r1, r1, lsr #31
1000066a:	9119      	str	r1, [sp, #100]	@ 0x64
1000066c:	9919      	ldr	r1, [sp, #100]	@ 0x64
1000066e:	eba3 0301 	sub.w	r3, r3, r1
10000672:	eba3 0304 	sub.w	r3, r3, r4
10000676:	4429      	add	r1, r5
10000678:	443b      	add	r3, r7
1000067a:	ea43 0301 	orr.w	r3, r3, r1
1000067e:	ea4f 73d3 	mov.w	r3, r3, lsr #31
10000682:	931a      	str	r3, [sp, #104]	@ 0x68
10000684:	ea6b 0100 	orn	r1, fp, r0
10000688:	eb60 030b 	sbc.w	r3, r0, fp
1000068c:	400b      	ands	r3, r1
1000068e:	ea2b 0100 	bic.w	r1, fp, r0
10000692:	430b      	orrs	r3, r1
10000694:	0fdb      	lsrs	r3, r3, #31
10000696:	991a      	ldr	r1, [sp, #104]	@ 0x68
10000698:	931b      	str	r3, [sp, #108]	@ 0x6c
1000069a:	9b1b      	ldr	r3, [sp, #108]	@ 0x6c
1000069c:	f083 0301 	eor.w	r3, r3, #1
100006a0:	430b      	orrs	r3, r1
100006a2:	4499      	add	r9, r3
100006a4:	425b      	negs	r3, r3
100006a6:	eb6c 010c 	sbc.w	r1, ip, ip
100006aa:	ea03 030a 	and.w	r3, r3, sl
100006ae:	1ad3      	subs	r3, r2, r3
100006b0:	ea01 010b 	and.w	r1, r1, fp
100006b4:	eb60 0101 	sbc.w	r1, r0, r1
100006b8:	980f      	ldr	r0, [sp, #60]	@ 0x3c
100006ba:	e9dd ab0c 	ldrd	sl, fp, [sp, #48]	@ 0x30
100006be:	eb1a 0000 	adds.w	r0, sl, r0
100006c2:	f14b 0200 	adc.w	r2, fp, #0
100006c6:	1a18      	subs	r0, r3, r0
100006c8:	eb61 0302 	sbc.w	r3, r1, r2
100006cc:	ea62 0001 	orn	r0, r2, r1
100006d0:	4003      	ands	r3, r0
100006d2:	ea22 0201 	bic.w	r2, r2, r1
100006d6:	4313      	orrs	r3, r2
100006d8:	0fdb      	lsrs	r3, r3, #31
100006da:	9314      	str	r3, [sp, #80]	@ 0x50
100006dc:	9b14      	ldr	r3, [sp, #80]	@ 0x50
100006de:	eba9 79d5 	sub.w	r9, r9, r5, lsr #31
100006e2:	f083 0301 	eor.w	r3, r3, #1
100006e6:	9d0a      	ldr	r5, [sp, #40]	@ 0x28
100006e8:	eb13 0309 	adds.w	r3, r3, r9
100006ec:	f148 0200 	adc.w	r2, r8, #0
100006f0:	4269      	negs	r1, r5
100006f2:	9102      	str	r1, [sp, #8]
100006f4:	eb6c 010c 	sbc.w	r1, ip, ip
100006f8:	9103      	str	r1, [sp, #12]
100006fa:	9f0e      	ldr	r7, [sp, #56]	@ 0x38
100006fc:	9810      	ldr	r0, [sp, #64]	@ 0x40
100006fe:	9e11      	ldr	r6, [sp, #68]	@ 0x44
10000700:	19c0      	adds	r0, r0, r7
10000702:	9c12      	ldr	r4, [sp, #72]	@ 0x48
10000704:	9d13      	ldr	r5, [sp, #76]	@ 0x4c
10000706:	f166 0100 	sbc.w	r1, r6, #0
1000070a:	4058      	eors	r0, r3
1000070c:	e9dd 8902 	ldrd	r8, r9, [sp, #8]
10000710:	e9cd 8920 	strd	r8, r9, [sp, #128]	@ 0x80
10000714:	e9dd 6720 	ldrd	r6, r7, [sp, #128]	@ 0x80
10000718:	405c      	eors	r4, r3
1000071a:	4051      	eors	r1, r2
1000071c:	ea85 0302 	eor.w	r3, r5, r2
10000720:	4030      	ands	r0, r6
10000722:	9a0b      	ldr	r2, [sp, #44]	@ 0x2c
10000724:	4039      	ands	r1, r7
10000726:	4060      	eors	r0, r4
10000728:	1880      	adds	r0, r0, r2
1000072a:	ea81 0103 	eor.w	r1, r1, r3
1000072e:	f141 0100 	adc.w	r1, r1, #0
10000732:	b027      	add	sp, #156	@ 0x9c
10000734:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10000738:	00000000 	.word	0x00000000
1000073c:	41f00000 	.word	0x41f00000
10000740:	00000000 	.word	0x00000000
10000744:	3df00000 	.word	0x3df00000
10000748:	be100000 	.word	0xbe100000
1000074c:	41efffff 	.word	0x41efffff
10000750:	ffe00000 	.word	0xffe00000
