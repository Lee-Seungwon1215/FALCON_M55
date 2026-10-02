
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/r2-perf/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

100062b0 <fxr_div_fp64_exact>:
100062b0:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
100062b4:	4607      	mov	r7, r0
100062b6:	f04f 0c00 	mov.w	ip, #0
100062ba:	ea4f 79d1 	mov.w	r9, r1, lsr #31
100062be:	ea4f 78d3 	mov.w	r8, r3, lsr #31
100062c2:	ea82 74e3 	eor.w	r4, r2, r3, asr #31
100062c6:	ea83 75e3 	eor.w	r5, r3, r3, asr #31
100062ca:	ea89 0308 	eor.w	r3, r9, r8
100062ce:	b0a7      	sub	sp, #156	@ 0x9c
100062d0:	425a      	negs	r2, r3
100062d2:	ea87 77e1 	eor.w	r7, r7, r1, asr #31
100062d6:	ea81 76e1 	eor.w	r6, r1, r1, asr #31
100062da:	9212      	str	r2, [sp, #72]	@ 0x48
100062dc:	9213      	str	r2, [sp, #76]	@ 0x4c
100062de:	eb17 0209 	adds.w	r2, r7, r9
100062e2:	930b      	str	r3, [sp, #44]	@ 0x2c
100062e4:	f146 0300 	adc.w	r3, r6, #0
100062e8:	eb14 0408 	adds.w	r4, r4, r8
100062ec:	f145 0500 	adc.w	r5, r5, #0
100062f0:	ea45 0604 	orr.w	r6, r5, r4
100062f4:	462f      	mov	r7, r5
100062f6:	ee07 5a90 	vmov	s15, r5
100062fa:	4275      	negs	r5, r6
100062fc:	4335      	orrs	r5, r6
100062fe:	0fed      	lsrs	r5, r5, #31
10006300:	9517      	str	r5, [sp, #92]	@ 0x5c
10006302:	9d17      	ldr	r5, [sp, #92]	@ 0x5c
10006304:	ed9f 6bce 	vldr	d6, [pc, #824]	@ 10006640 <fxr_div_fp64_exact+0x390>
10006308:	f085 0501 	eor.w	r5, r5, #1
1000630c:	f115 3aff 	adds.w	sl, r5, #4294967295	@ 0xffffffff
10006310:	f14c 38ff 	adc.w	r8, ip, #4294967295	@ 0xffffffff
10006314:	ea08 0803 	and.w	r8, r8, r3
10006318:	ea0a 0602 	and.w	r6, sl, r2
1000631c:	ee02 6a90 	vmov	s5, r6
10006320:	ee05 8a90 	vmov	s11, r8
10006324:	eeb8 4b67 	vcvt.f64.u32	d4, s15
10006328:	eeb8 5b65 	vcvt.f64.u32	d5, s11
1000632c:	eeb8 7b62 	vcvt.f64.u32	d7, s5
10006330:	ea44 0a05 	orr.w	sl, r4, r5
10006334:	ee05 7b06 	vmla.f64	d7, d5, d6
10006338:	ee05 aa90 	vmov	s11, sl
1000633c:	eeb8 5b65 	vcvt.f64.u32	d5, s11
10006340:	ee04 5b06 	vmla.f64	d5, d4, d6
10006344:	950a      	str	r5, [sp, #40]	@ 0x28
10006346:	2400      	movs	r4, #0
10006348:	2500      	movs	r5, #0
1000634a:	ee86 4b05 	vdiv.f64	d4, d6, d5
1000634e:	17de      	asrs	r6, r3, #31
10006350:	46bb      	mov	fp, r7
10006352:	9611      	str	r6, [sp, #68]	@ 0x44
10006354:	9709      	str	r7, [sp, #36]	@ 0x24
10006356:	4626      	mov	r6, r4
10006358:	462f      	mov	r7, r5
1000635a:	ed9f 3bbb 	vldr	d3, [pc, #748]	@ 10006648 <fxr_div_fp64_exact+0x398>
1000635e:	ee27 7b04 	vmul.f64	d7, d7, d4
10006362:	e9cd 6700 	strd	r6, r7, [sp]
10006366:	e9cd 6704 	strd	r6, r7, [sp, #16]
1000636a:	e9cd 6706 	strd	r6, r7, [sp, #24]
1000636e:	4616      	mov	r6, r2
10006370:	461f      	mov	r7, r3
10006372:	ee27 7b03 	vmul.f64	d7, d7, d3
10006376:	ea52 73df 	lsrl	r2, r3, #31
1000637a:	ea56 779f 	lsrl	r6, r7, #30
1000637e:	ed8d 7b02 	vstr	d7, [sp, #8]
10006382:	43d7      	mvns	r7, r2
10006384:	43f6      	mvns	r6, r6
10006386:	f8df e2d0 	ldr.w	lr, [pc, #720]	@ 10006658 <fxr_div_fp64_exact+0x3a8>
1000638a:	f00a 0101 	and.w	r1, sl, #1
1000638e:	48b0      	ldr	r0, [pc, #704]	@ (10006650 <fxr_div_fp64_exact+0x3a0>)
10006390:	910f      	str	r1, [sp, #60]	@ 0x3c
10006392:	49b0      	ldr	r1, [pc, #704]	@ (10006654 <fxr_div_fp64_exact+0x3a4>)
10006394:	970e      	str	r7, [sp, #56]	@ 0x38
10006396:	e9dd 9702 	ldrd	r9, r7, [sp, #8]
1000639a:	ebbe 0209 	subs.w	r2, lr, r9
1000639e:	eb61 0207 	sbc.w	r2, r1, r7
100063a2:	f006 0301 	and.w	r3, r6, #1
100063a6:	ea47 0600 	orr.w	r6, r7, r0
100063aa:	4032      	ands	r2, r6
100063ac:	ea07 0600 	and.w	r6, r7, r0
100063b0:	4332      	orrs	r2, r6
100063b2:	0fd2      	lsrs	r2, r2, #31
100063b4:	9216      	str	r2, [sp, #88]	@ 0x58
100063b6:	9a16      	ldr	r2, [sp, #88]	@ 0x58
100063b8:	9310      	str	r3, [sp, #64]	@ 0x40
100063ba:	4254      	negs	r4, r2
100063bc:	eb6c 050c 	sbc.w	r5, ip, ip
100063c0:	e9cd 4524 	strd	r4, r5, [sp, #144]	@ 0x90
100063c4:	e9dd 2324 	ldrd	r2, r3, [sp, #144]	@ 0x90
100063c8:	ea89 050e 	eor.w	r5, r9, lr
100063cc:	ea87 0401 	eor.w	r4, r7, r1
100063d0:	4015      	ands	r5, r2
100063d2:	401c      	ands	r4, r3
100063d4:	ea85 0209 	eor.w	r2, r5, r9
100063d8:	407c      	eors	r4, r7
100063da:	9200      	str	r2, [sp, #0]
100063dc:	9401      	str	r4, [sp, #4]
100063de:	ed9d 7b00 	vldr	d7, [sp]
100063e2:	4654      	mov	r4, sl
100063e4:	eefc 7bc7 	vcvt.u32.f64	s15, d7
100063e8:	465d      	mov	r5, fp
100063ea:	ee17 6a90 	vmov	r6, s15
100063ee:	ea54 055f 	lsrl	r4, r5, #1
100063f2:	2200      	movs	r2, #0
100063f4:	2300      	movs	r3, #0
100063f6:	ee12 9a90 	vmov	r9, s5
100063fa:	e9cd 450c 	strd	r4, r5, [sp, #48]	@ 0x30
100063fe:	e9cd 2302 	strd	r2, r3, [sp, #8]
10006402:	fba6 420a 	umull	r4, r2, r6, sl
10006406:	ebb9 0304 	subs.w	r3, r9, r4
1000640a:	46e1      	mov	r9, ip
1000640c:	fbeb 2906 	umlal	r2, r9, fp, r6
10006410:	eb68 0602 	sbc.w	r6, r8, r2
10006414:	ea62 0408 	orn	r4, r2, r8
10006418:	4034      	ands	r4, r6
1000641a:	ea22 0208 	bic.w	r2, r2, r8
1000641e:	4314      	orrs	r4, r2
10006420:	0fe4      	lsrs	r4, r4, #31
10006422:	941c      	str	r4, [sp, #112]	@ 0x70
10006424:	9a1c      	ldr	r2, [sp, #112]	@ 0x70
10006426:	edcd 7a00 	vstr	s15, [sp]
1000642a:	eb09 0802 	add.w	r8, r9, r2
1000642e:	f1c8 0700 	rsb	r7, r8, #0
10006432:	ea0a 74e7 	and.w	r4, sl, r7, asr #31
10006436:	191b      	adds	r3, r3, r4
10006438:	ea0b 74e7 	and.w	r4, fp, r7, asr #31
1000643c:	4621      	mov	r1, r4
1000643e:	eb46 0504 	adc.w	r5, r6, r4
10006442:	ebb3 040a 	subs.w	r4, r3, sl
10006446:	ea66 0405 	orn	r4, r6, r5
1000644a:	ea04 0401 	and.w	r4, r4, r1
1000644e:	ea26 0605 	bic.w	r6, r6, r5
10006452:	ea44 0406 	orr.w	r4, r4, r6
10006456:	ee17 6a90 	vmov	r6, s15
1000645a:	ea4f 74d4 	mov.w	r4, r4, lsr #31
1000645e:	941d      	str	r4, [sp, #116]	@ 0x74
10006460:	9c1d      	ldr	r4, [sp, #116]	@ 0x74
10006462:	497c      	ldr	r1, [pc, #496]	@ (10006654 <fxr_div_fp64_exact+0x3a4>)
10006464:	eba2 0204 	sub.w	r2, r2, r4
10006468:	444a      	add	r2, r9
1000646a:	eba4 0408 	sub.w	r4, r4, r8
1000646e:	ea42 0204 	orr.w	r2, r2, r4
10006472:	ea4f 72d2 	mov.w	r2, r2, lsr #31
10006476:	921e      	str	r2, [sp, #120]	@ 0x78
10006478:	ea6b 0405 	orn	r4, fp, r5
1000647c:	eb65 020b 	sbc.w	r2, r5, fp
10006480:	4022      	ands	r2, r4
10006482:	ea2b 0405 	bic.w	r4, fp, r5
10006486:	4322      	orrs	r2, r4
10006488:	0fd2      	lsrs	r2, r2, #31
1000648a:	9c1e      	ldr	r4, [sp, #120]	@ 0x78
1000648c:	921f      	str	r2, [sp, #124]	@ 0x7c
1000648e:	9a1f      	ldr	r2, [sp, #124]	@ 0x7c
10006490:	f082 0201 	eor.w	r2, r2, #1
10006494:	4322      	orrs	r2, r4
10006496:	18b4      	adds	r4, r6, r2
10006498:	4252      	negs	r2, r2
1000649a:	eba4 78d7 	sub.w	r8, r4, r7, lsr #31
1000649e:	ea02 020a 	and.w	r2, r2, sl
100064a2:	eb6c 040c 	sbc.w	r4, ip, ip
100064a6:	ea04 040b 	and.w	r4, r4, fp
100064aa:	1a9b      	subs	r3, r3, r2
100064ac:	eb65 0404 	sbc.w	r4, r5, r4
100064b0:	ee07 4a90 	vmov	s15, r4
100064b4:	eeb8 5b67 	vcvt.f64.u32	d5, s15
100064b8:	ee07 3a90 	vmov	s15, r3
100064bc:	eeb8 7b67 	vcvt.f64.u32	d7, s15
100064c0:	ee05 7b06 	vmla.f64	d7, d5, d6
100064c4:	ee27 7b04 	vmul.f64	d7, d7, d4
100064c8:	ed8d 7b00 	vstr	d7, [sp]
100064cc:	e9dd 5200 	ldrd	r5, r2, [sp]
100064d0:	ebbe 0605 	subs.w	r6, lr, r5
100064d4:	eb61 0702 	sbc.w	r7, r1, r2
100064d8:	ea82 0601 	eor.w	r6, r2, r1
100064dc:	ea42 0100 	orr.w	r1, r2, r0
100064e0:	4039      	ands	r1, r7
100064e2:	4010      	ands	r0, r2
100064e4:	4301      	orrs	r1, r0
100064e6:	0fc9      	lsrs	r1, r1, #31
100064e8:	9115      	str	r1, [sp, #84]	@ 0x54
100064ea:	9915      	ldr	r1, [sp, #84]	@ 0x54
100064ec:	ea85 0e0e 	eor.w	lr, r5, lr
100064f0:	4249      	negs	r1, r1
100064f2:	9104      	str	r1, [sp, #16]
100064f4:	eb6c 010c 	sbc.w	r1, ip, ip
100064f8:	9105      	str	r1, [sp, #20]
100064fa:	e9dd 0104 	ldrd	r0, r1, [sp, #16]
100064fe:	e9cd 0122 	strd	r0, r1, [sp, #136]	@ 0x88
10006502:	e9dd 0122 	ldrd	r0, r1, [sp, #136]	@ 0x88
10006506:	ea0e 0e00 	and.w	lr, lr, r0
1000650a:	4031      	ands	r1, r6
1000650c:	404a      	eors	r2, r1
1000650e:	ea8e 0605 	eor.w	r6, lr, r5
10006512:	9606      	str	r6, [sp, #24]
10006514:	9207      	str	r2, [sp, #28]
10006516:	ed9d 7b06 	vldr	d7, [sp, #24]
1000651a:	eefc 7bc7 	vcvt.u32.f64	s15, d7
1000651e:	ee17 9a90 	vmov	r9, s15
10006522:	46e6      	mov	lr, ip
10006524:	fba9 210a 	umull	r2, r1, r9, sl
10006528:	fbeb 1e09 	umlal	r1, lr, fp, r9
1000652c:	4677      	mov	r7, lr
1000652e:	ebbc 0202 	subs.w	r2, ip, r2
10006532:	eb63 0601 	sbc.w	r6, r3, r1
10006536:	ea61 0003 	orn	r0, r1, r3
1000653a:	4030      	ands	r0, r6
1000653c:	ea21 0103 	bic.w	r1, r1, r3
10006540:	4308      	orrs	r0, r1
10006542:	0fc0      	lsrs	r0, r0, #31
10006544:	9018      	str	r0, [sp, #96]	@ 0x60
10006546:	9b18      	ldr	r3, [sp, #96]	@ 0x60
10006548:	1ae5      	subs	r5, r4, r3
1000654a:	1bed      	subs	r5, r5, r7
1000654c:	ea0a 71e5 	and.w	r1, sl, r5, asr #31
10006550:	ea0b 7ee5 	and.w	lr, fp, r5, asr #31
10006554:	1852      	adds	r2, r2, r1
10006556:	eb46 000e 	adc.w	r0, r6, lr
1000655a:	ebb2 010a 	subs.w	r1, r2, sl
1000655e:	ea66 0100 	orn	r1, r6, r0
10006562:	ea01 010e 	and.w	r1, r1, lr
10006566:	ea26 0600 	bic.w	r6, r6, r0
1000656a:	ea41 0106 	orr.w	r1, r1, r6
1000656e:	ea4f 71d1 	mov.w	r1, r1, lsr #31
10006572:	9119      	str	r1, [sp, #100]	@ 0x64
10006574:	9919      	ldr	r1, [sp, #100]	@ 0x64
10006576:	eba3 0301 	sub.w	r3, r3, r1
1000657a:	eba3 0304 	sub.w	r3, r3, r4
1000657e:	4429      	add	r1, r5
10006580:	443b      	add	r3, r7
10006582:	ea43 0301 	orr.w	r3, r3, r1
10006586:	ea4f 73d3 	mov.w	r3, r3, lsr #31
1000658a:	931a      	str	r3, [sp, #104]	@ 0x68
1000658c:	ea6b 0100 	orn	r1, fp, r0
10006590:	eb60 030b 	sbc.w	r3, r0, fp
10006594:	400b      	ands	r3, r1
10006596:	ea2b 0100 	bic.w	r1, fp, r0
1000659a:	430b      	orrs	r3, r1
1000659c:	0fdb      	lsrs	r3, r3, #31
1000659e:	991a      	ldr	r1, [sp, #104]	@ 0x68
100065a0:	931b      	str	r3, [sp, #108]	@ 0x6c
100065a2:	9b1b      	ldr	r3, [sp, #108]	@ 0x6c
100065a4:	f083 0301 	eor.w	r3, r3, #1
100065a8:	430b      	orrs	r3, r1
100065aa:	4499      	add	r9, r3
100065ac:	425b      	negs	r3, r3
100065ae:	eb6c 010c 	sbc.w	r1, ip, ip
100065b2:	ea03 030a 	and.w	r3, r3, sl
100065b6:	1ad3      	subs	r3, r2, r3
100065b8:	ea01 010b 	and.w	r1, r1, fp
100065bc:	eb60 0101 	sbc.w	r1, r0, r1
100065c0:	980f      	ldr	r0, [sp, #60]	@ 0x3c
100065c2:	e9dd ab0c 	ldrd	sl, fp, [sp, #48]	@ 0x30
100065c6:	eb1a 0000 	adds.w	r0, sl, r0
100065ca:	f14b 0200 	adc.w	r2, fp, #0
100065ce:	1a18      	subs	r0, r3, r0
100065d0:	eb61 0302 	sbc.w	r3, r1, r2
100065d4:	ea62 0001 	orn	r0, r2, r1
100065d8:	4003      	ands	r3, r0
100065da:	ea22 0201 	bic.w	r2, r2, r1
100065de:	4313      	orrs	r3, r2
100065e0:	0fdb      	lsrs	r3, r3, #31
100065e2:	9314      	str	r3, [sp, #80]	@ 0x50
100065e4:	9b14      	ldr	r3, [sp, #80]	@ 0x50
100065e6:	eba9 79d5 	sub.w	r9, r9, r5, lsr #31
100065ea:	f083 0301 	eor.w	r3, r3, #1
100065ee:	9d0a      	ldr	r5, [sp, #40]	@ 0x28
100065f0:	eb13 0309 	adds.w	r3, r3, r9
100065f4:	f148 0200 	adc.w	r2, r8, #0
100065f8:	4269      	negs	r1, r5
100065fa:	9102      	str	r1, [sp, #8]
100065fc:	eb6c 010c 	sbc.w	r1, ip, ip
10006600:	9103      	str	r1, [sp, #12]
10006602:	9f0e      	ldr	r7, [sp, #56]	@ 0x38
10006604:	9810      	ldr	r0, [sp, #64]	@ 0x40
10006606:	9e11      	ldr	r6, [sp, #68]	@ 0x44
10006608:	19c0      	adds	r0, r0, r7
1000660a:	9c12      	ldr	r4, [sp, #72]	@ 0x48
1000660c:	9d13      	ldr	r5, [sp, #76]	@ 0x4c
1000660e:	f166 0100 	sbc.w	r1, r6, #0
10006612:	4058      	eors	r0, r3
10006614:	e9dd 8902 	ldrd	r8, r9, [sp, #8]
10006618:	e9cd 8920 	strd	r8, r9, [sp, #128]	@ 0x80
1000661c:	e9dd 6720 	ldrd	r6, r7, [sp, #128]	@ 0x80
10006620:	405c      	eors	r4, r3
10006622:	4051      	eors	r1, r2
10006624:	ea85 0302 	eor.w	r3, r5, r2
10006628:	4030      	ands	r0, r6
1000662a:	9a0b      	ldr	r2, [sp, #44]	@ 0x2c
1000662c:	4039      	ands	r1, r7
1000662e:	4060      	eors	r0, r4
10006630:	1880      	adds	r0, r0, r2
10006632:	ea81 0103 	eor.w	r1, r1, r3
10006636:	f141 0100 	adc.w	r1, r1, #0
1000663a:	b027      	add	sp, #156	@ 0x9c
1000663c:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10006640:	00000000 	.word	0x00000000
10006644:	41f00000 	.word	0x41f00000
10006648:	00000000 	.word	0x00000000
1000664c:	3df00000 	.word	0x3df00000
10006650:	be100000 	.word	0xbe100000
10006654:	41efffff 	.word	0x41efffff
10006658:	ffe00000 	.word	0xffe00000
