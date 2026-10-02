
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_q32_compat/validation/build/compat-perf/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10006278 <fndsa_vect_FFT_fp64q>:
10006278:	2801      	cmp	r0, #1
1000627a:	f240 82d8 	bls.w	1000682e <fndsa_vect_FFT_fp64q+0x5b6>
1000627e:	2301      	movs	r3, #1
10006280:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10006284:	1e42      	subs	r2, r0, #1
10006286:	ed2d 8b10 	vpush	{d8-d15}
1000628a:	fa03 f502 	lsl.w	r5, r3, r2
1000628e:	ed9f fb3a 	vldr	d15, [pc, #232]	@ 10006378 <fndsa_vect_FFT_fp64q+0x100>
10006292:	ed9f eb3b 	vldr	d14, [pc, #236]	@ 10006380 <fndsa_vect_FFT_fp64q+0x108>
10006296:	469b      	mov	fp, r3
10006298:	46a9      	mov	r9, r5
1000629a:	b0b9      	sub	sp, #228	@ 0xe4
1000629c:	3908      	subs	r1, #8
1000629e:	9123      	str	r1, [sp, #140]	@ 0x8c
100062a0:	9524      	str	r5, [sp, #144]	@ 0x90
100062a2:	9025      	str	r0, [sp, #148]	@ 0x94
100062a4:	2301      	movs	r3, #1
100062a6:	2210      	movs	r2, #16
100062a8:	46c8      	mov	r8, r9
100062aa:	2700      	movs	r7, #0
100062ac:	4936      	ldr	r1, [pc, #216]	@ (10006388 <fndsa_vect_FFT_fp64q+0x110>)
100062ae:	fa03 f30b 	lsl.w	r3, r3, fp
100062b2:	eb03 0353 	add.w	r3, r3, r3, lsr #1
100062b6:	eb01 1303 	add.w	r3, r1, r3, lsl #4
100062ba:	931f      	str	r3, [sp, #124]	@ 0x7c
100062bc:	9b24      	ldr	r3, [sp, #144]	@ 0x90
100062be:	ea4f 0959 	mov.w	r9, r9, lsr #1
100062c2:	eba3 0309 	sub.w	r3, r3, r9
100062c6:	3301      	adds	r3, #1
100062c8:	9321      	str	r3, [sp, #132]	@ 0x84
100062ca:	9b23      	ldr	r3, [sp, #140]	@ 0x8c
100062cc:	fa02 f20b 	lsl.w	r2, r2, fp
100062d0:	ea4f 0ac9 	mov.w	sl, r9, lsl #3
100062d4:	188d      	adds	r5, r1, r2
100062d6:	eb03 0cc9 	add.w	ip, r3, r9, lsl #3
100062da:	f8cd 9078 	str.w	r9, [sp, #120]	@ 0x78
100062de:	f8cd b088 	str.w	fp, [sp, #136]	@ 0x88
100062e2:	f8cd a010 	str.w	sl, [sp, #16]
100062e6:	f8cd 8080 	str.w	r8, [sp, #128]	@ 0x80
100062ea:	9b1e      	ldr	r3, [sp, #120]	@ 0x78
100062ec:	ac30      	add	r4, sp, #192	@ 0xc0
100062ee:	eb03 0e07 	add.w	lr, r3, r7
100062f2:	45be      	cmp	lr, r7
100062f4:	e895 000f 	ldmia.w	r5, {r0, r1, r2, r3}
100062f8:	e884 000f 	stmia.w	r4, {r0, r1, r2, r3}
100062fc:	f240 827f 	bls.w	100067fe <fndsa_vect_FFT_fp64q+0x586>
10006300:	9a30      	ldr	r2, [sp, #192]	@ 0xc0
10006302:	9932      	ldr	r1, [sp, #200]	@ 0xc8
10006304:	ee07 2a90 	vmov	s15, r2
10006308:	eeb8 ab67 	vcvt.f64.u32	d10, s15
1000630c:	ee07 1a90 	vmov	s15, r1
10006310:	9c31      	ldr	r4, [sp, #196]	@ 0xc4
10006312:	eeb8 bb67 	vcvt.f64.u32	d11, s15
10006316:	ee07 4a90 	vmov	s15, r4
1000631a:	9833      	ldr	r0, [sp, #204]	@ 0xcc
1000631c:	eeb8 9b67 	vcvt.f64.u32	d9, s15
10006320:	ee07 0a90 	vmov	s15, r0
10006324:	9215      	str	r2, [sp, #84]	@ 0x54
10006326:	1852      	adds	r2, r2, r1
10006328:	eeb8 8b67 	vcvt.f64.u32	d8, s15
1000632c:	ee07 2a90 	vmov	s15, r2
10006330:	9219      	str	r2, [sp, #100]	@ 0x64
10006332:	eb40 0204 	adc.w	r2, r0, r4
10006336:	eeb8 db67 	vcvt.f64.u32	d13, s15
1000633a:	ee07 2a90 	vmov	s15, r2
1000633e:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10006342:	9b04      	ldr	r3, [sp, #16]
10006344:	ed8d 7b12 	vstr	d7, [sp, #72]	@ 0x48
10006348:	f1a3 0e08 	sub.w	lr, r3, #8
1000634c:	ea4f 0ede 	mov.w	lr, lr, lsr #3
10006350:	f10e 0e01 	add.w	lr, lr, #1
10006354:	f04e e001 	dls	lr, lr
10006358:	ebac 0b03 	sub.w	fp, ip, r3
1000635c:	e9cd 7c1b 	strd	r7, ip, [sp, #108]	@ 0x6c
10006360:	9b21      	ldr	r3, [sp, #132]	@ 0x84
10006362:	9117      	str	r1, [sp, #92]	@ 0x5c
10006364:	9416      	str	r4, [sp, #88]	@ 0x58
10006366:	9018      	str	r0, [sp, #96]	@ 0x60
10006368:	921a      	str	r2, [sp, #104]	@ 0x68
1000636a:	951d      	str	r5, [sp, #116]	@ 0x74
1000636c:	eb0c 0ac3 	add.w	sl, ip, r3, lsl #3
10006370:	e00c      	b.n	1000638c <fndsa_vect_FFT_fp64q+0x114>
10006372:	bf00      	nop
10006374:	f3af 8000 	nop.w
10006378:	00000000 	.word	0x00000000
1000637c:	3df00000 	.word	0x3df00000
10006380:	00000000 	.word	0x00000000
10006384:	41f00000 	.word	0x41f00000
10006388:	300039a0 	.word	0x300039a0
1000638c:	f85b 3f08 	ldr.w	r3, [fp, #8]!
10006390:	9a04      	ldr	r2, [sp, #16]
10006392:	930b      	str	r3, [sp, #44]	@ 0x2c
10006394:	eb0b 0002 	add.w	r0, fp, r2
10006398:	6803      	ldr	r3, [r0, #0]
1000639a:	6847      	ldr	r7, [r0, #4]
1000639c:	4699      	mov	r9, r3
1000639e:	ee07 9a90 	vmov	s15, r9
100063a2:	eeb8 4b67 	vcvt.f64.u32	d4, s15
100063a6:	ee07 7a90 	vmov	s15, r7
100063aa:	eb0a 0102 	add.w	r1, sl, r2
100063ae:	9334      	str	r3, [sp, #208]	@ 0xd0
100063b0:	680b      	ldr	r3, [r1, #0]
100063b2:	eeb8 0b67 	vcvt.f64.u32	d0, s15
100063b6:	ee07 3a90 	vmov	s15, r3
100063ba:	684e      	ldr	r6, [r1, #4]
100063bc:	ee2a 1b04 	vmul.f64	d1, d10, d4
100063c0:	eeb8 5b67 	vcvt.f64.u32	d5, s15
100063c4:	ee07 6a90 	vmov	s15, r6
100063c8:	eeb8 3b67 	vcvt.f64.u32	d3, s15
100063cc:	ee21 7b0f 	vmul.f64	d7, d1, d15
100063d0:	eefc 2bc7 	vcvt.u32.f64	s5, d7
100063d4:	ee2b cb05 	vmul.f64	d12, d11, d5
100063d8:	ee28 7b05 	vmul.f64	d7, d8, d5
100063dc:	eeb8 5b62 	vcvt.f64.u32	d5, s5
100063e0:	ee20 0b0a 	vmul.f64	d0, d0, d10
100063e4:	ee29 6b04 	vmul.f64	d6, d9, d4
100063e8:	ed8d 7b0c 	vstr	d7, [sp, #48]	@ 0x30
100063ec:	ee25 7b0e 	vmul.f64	d7, d5, d14
100063f0:	ee20 4b0f 	vmul.f64	d4, d0, d15
100063f4:	eeb0 5b47 	vmov.f64	d5, d7
100063f8:	ed8d 6b02 	vstr	d6, [sp, #8]
100063fc:	ee2c 7b0f 	vmul.f64	d7, d12, d15
10006400:	ee26 6b0f 	vmul.f64	d6, d6, d15
10006404:	4698      	mov	r8, r3
10006406:	eefc 6bc6 	vcvt.u32.f64	s13, d6
1000640a:	eebc 6bc4 	vcvt.u32.f64	s12, d4
1000640e:	eefc 4bc7 	vcvt.u32.f64	s9, d7
10006412:	9c16      	ldr	r4, [sp, #88]	@ 0x58
10006414:	9007      	str	r0, [sp, #28]
10006416:	fb09 f004 	mul.w	r0, r9, r4
1000641a:	9601      	str	r6, [sp, #4]
1000641c:	9106      	str	r1, [sp, #24]
1000641e:	9008      	str	r0, [sp, #32]
10006420:	9901      	ldr	r1, [sp, #4]
10006422:	9817      	ldr	r0, [sp, #92]	@ 0x5c
10006424:	9637      	str	r6, [sp, #220]	@ 0xdc
10006426:	fb01 f100 	mul.w	r1, r1, r0
1000642a:	fb08 f500 	mul.w	r5, r8, r0
1000642e:	fb07 f604 	mul.w	r6, r7, r4
10006432:	910f      	str	r1, [sp, #60]	@ 0x3c
10006434:	9918      	ldr	r1, [sp, #96]	@ 0x60
10006436:	9510      	str	r5, [sp, #64]	@ 0x40
10006438:	fb08 f501 	mul.w	r5, r8, r1
1000643c:	ea09 74e4 	and.w	r4, r9, r4, asr #31
10006440:	1b34      	subs	r4, r6, r4
10006442:	9e01      	ldr	r6, [sp, #4]
10006444:	950e      	str	r5, [sp, #56]	@ 0x38
10006446:	fb06 f501 	mul.w	r5, r6, r1
1000644a:	9336      	str	r3, [sp, #216]	@ 0xd8
1000644c:	9b15      	ldr	r3, [sp, #84]	@ 0x54
1000644e:	9511      	str	r5, [sp, #68]	@ 0x44
10006450:	ea03 75e7 	and.w	r5, r3, r7, asr #31
10006454:	fb07 f203 	mul.w	r2, r7, r3
10006458:	fb09 fc03 	mul.w	ip, r9, r3
1000645c:	1b63      	subs	r3, r4, r5
1000645e:	ea08 75e1 	and.w	r5, r8, r1, asr #31
10006462:	ea00 74e6 	and.w	r4, r0, r6, asr #31
10006466:	192c      	adds	r4, r5, r4
10006468:	f8da 0000 	ldr.w	r0, [sl]
1000646c:	9405      	str	r4, [sp, #20]
1000646e:	f8db 4004 	ldr.w	r4, [fp, #4]
10006472:	9735      	str	r7, [sp, #212]	@ 0xd4
10006474:	9414      	str	r4, [sp, #80]	@ 0x50
10006476:	9009      	str	r0, [sp, #36]	@ 0x24
10006478:	f8da 5004 	ldr.w	r5, [sl, #4]
1000647c:	ee11 0a10 	vmov	r0, s2
10006480:	ee15 1a10 	vmov	r1, s10
10006484:	950a      	str	r5, [sp, #40]	@ 0x28
10006486:	ee15 5a90 	vmov	r5, s11
1000648a:	eeb8 5b64 	vcvt.f64.u32	d5, s9
1000648e:	ea81 0400 	eor.w	r4, r1, r0
10006492:	ee25 7b0e 	vmul.f64	d7, d5, d14
10006496:	ee11 0a90 	vmov	r0, s3
1000649a:	eeb0 5b47 	vmov.f64	d5, d7
1000649e:	4045      	eors	r5, r0
100064a0:	ee12 0a90 	vmov	r0, s5
100064a4:	4325      	orrs	r5, r4
100064a6:	426c      	negs	r4, r5
100064a8:	432c      	orrs	r4, r5
100064aa:	0fe4      	lsrs	r4, r4, #31
100064ac:	9429      	str	r4, [sp, #164]	@ 0xa4
100064ae:	9c29      	ldr	r4, [sp, #164]	@ 0xa4
100064b0:	ee15 1a10 	vmov	r1, s10
100064b4:	f084 0401 	eor.w	r4, r4, #1
100064b8:	ea04 74dc 	and.w	r4, r4, ip, lsr #31
100064bc:	1b04      	subs	r4, r0, r4
100064be:	ee1c 0a10 	vmov	r0, s24
100064c2:	ee23 3b0b 	vmul.f64	d3, d3, d11
100064c6:	eb14 0c02 	adds.w	ip, r4, r2
100064ca:	ea81 0400 	eor.w	r4, r1, r0
100064ce:	ee1c 0a90 	vmov	r0, s25
100064d2:	ed9d cb0c 	vldr	d12, [sp, #48]	@ 0x30
100064d6:	ee23 7b0f 	vmul.f64	d7, d3, d15
100064da:	ee15 5a90 	vmov	r5, s11
100064de:	ee2c 5b0f 	vmul.f64	d5, d12, d15
100064e2:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100064e6:	eefc 7bc5 	vcvt.u32.f64	s15, d5
100064ea:	eeb8 5b67 	vcvt.f64.u32	d5, s15
100064ee:	ee25 2b0e 	vmul.f64	d2, d5, d14
100064f2:	ee1c 1a10 	vmov	r1, s24
100064f6:	ea85 0500 	eor.w	r5, r5, r0
100064fa:	ee12 0a10 	vmov	r0, s4
100064fe:	eeb8 5b46 	vcvt.f64.u32	d5, s12
10006502:	ea45 0504 	orr.w	r5, r5, r4
10006506:	f1c5 0400 	rsb	r4, r5, #0
1000650a:	ea80 0001 	eor.w	r0, r0, r1
1000650e:	ea44 0405 	orr.w	r4, r4, r5
10006512:	ee12 1a90 	vmov	r1, s5
10006516:	ee1c 5a90 	vmov	r5, s25
1000651a:	ee25 1b0e 	vmul.f64	d1, d5, d14
1000651e:	ea81 0105 	eor.w	r1, r1, r5
10006522:	ea41 0100 	orr.w	r1, r1, r0
10006526:	f1c1 0000 	rsb	r0, r1, #0
1000652a:	ee11 6a10 	vmov	r6, s2
1000652e:	ea40 0001 	orr.w	r0, r0, r1
10006532:	ee10 1a10 	vmov	r1, s0
10006536:	ee11 5a90 	vmov	r5, s3
1000653a:	ea86 0101 	eor.w	r1, r6, r1
1000653e:	ee10 6a90 	vmov	r6, s1
10006542:	eeb8 5b66 	vcvt.f64.u32	d5, s13
10006546:	ea85 0506 	eor.w	r5, r5, r6
1000654a:	ee16 6a10 	vmov	r6, s12
1000654e:	ed9d 1b02 	vldr	d1, [sp, #8]
10006552:	ee25 2b0e 	vmul.f64	d2, d5, d14
10006556:	ea45 0501 	orr.w	r5, r5, r1
1000655a:	f1c5 0100 	rsb	r1, r5, #0
1000655e:	ea41 0105 	orr.w	r1, r1, r5
10006562:	ea4f 71d1 	mov.w	r1, r1, lsr #31
10006566:	9128      	str	r1, [sp, #160]	@ 0xa0
10006568:	9d28      	ldr	r5, [sp, #160]	@ 0xa0
1000656a:	eeb8 5b47 	vcvt.f64.u32	d5, s14
1000656e:	f085 0501 	eor.w	r5, r5, #1
10006572:	ea05 75d2 	and.w	r5, r5, r2, lsr #31
10006576:	eba6 0505 	sub.w	r5, r6, r5
1000657a:	eb45 0503 	adc.w	r5, r5, r3
1000657e:	9b08      	ldr	r3, [sp, #32]
10006580:	ee11 6a10 	vmov	r6, s2
10006584:	eb1c 0c03 	adds.w	ip, ip, r3
10006588:	ee12 3a10 	vmov	r3, s4
1000658c:	ea83 0206 	eor.w	r2, r3, r6
10006590:	ee11 6a90 	vmov	r6, s3
10006594:	ee12 3a90 	vmov	r3, s5
10006598:	ea83 0306 	eor.w	r3, r3, r6
1000659c:	ee16 6a90 	vmov	r6, s13
100065a0:	ea42 0203 	orr.w	r2, r2, r3
100065a4:	f1c2 0300 	rsb	r3, r2, #0
100065a8:	ea43 0302 	orr.w	r3, r3, r2
100065ac:	ea4f 73d3 	mov.w	r3, r3, lsr #31
100065b0:	9327      	str	r3, [sp, #156]	@ 0x9c
100065b2:	9927      	ldr	r1, [sp, #156]	@ 0x9c
100065b4:	9b08      	ldr	r3, [sp, #32]
100065b6:	f081 0101 	eor.w	r1, r1, #1
100065ba:	ea01 71d3 	and.w	r1, r1, r3, lsr #31
100065be:	ee25 5b0e 	vmul.f64	d5, d5, d14
100065c2:	eba6 0101 	sub.w	r1, r6, r1
100065c6:	ee14 6a90 	vmov	r6, s9
100065ca:	ea4f 74d4 	mov.w	r4, r4, lsr #31
100065ce:	942c      	str	r4, [sp, #176]	@ 0xb0
100065d0:	9b2c      	ldr	r3, [sp, #176]	@ 0xb0
100065d2:	9a10      	ldr	r2, [sp, #64]	@ 0x40
100065d4:	9c05      	ldr	r4, [sp, #20]
100065d6:	eb41 0105 	adc.w	r1, r1, r5
100065da:	f083 0301 	eor.w	r3, r3, #1
100065de:	ea03 73d2 	and.w	r3, r3, r2, lsr #31
100065e2:	190a      	adds	r2, r1, r4
100065e4:	1af3      	subs	r3, r6, r3
100065e6:	9208      	str	r2, [sp, #32]
100065e8:	ee15 6a10 	vmov	r6, s10
100065ec:	ee13 2a10 	vmov	r2, s6
100065f0:	ee15 4a90 	vmov	r4, s11
100065f4:	4072      	eors	r2, r6
100065f6:	ee13 6a90 	vmov	r6, s7
100065fa:	4074      	eors	r4, r6
100065fc:	ee17 6a10 	vmov	r6, s14
10006600:	4314      	orrs	r4, r2
10006602:	4262      	negs	r2, r4
10006604:	4322      	orrs	r2, r4
10006606:	0fd2      	lsrs	r2, r2, #31
10006608:	922b      	str	r2, [sp, #172]	@ 0xac
1000660a:	9a2b      	ldr	r2, [sp, #172]	@ 0xac
1000660c:	9d0f      	ldr	r5, [sp, #60]	@ 0x3c
1000660e:	f082 0201 	eor.w	r2, r2, #1
10006612:	ea02 72d5 	and.w	r2, r2, r5, lsr #31
10006616:	1ab2      	subs	r2, r6, r2
10006618:	ee17 6a90 	vmov	r6, s15
1000661c:	0fc0      	lsrs	r0, r0, #31
1000661e:	195b      	adds	r3, r3, r5
10006620:	902a      	str	r0, [sp, #168]	@ 0xa8
10006622:	9d11      	ldr	r5, [sp, #68]	@ 0x44
10006624:	9c2a      	ldr	r4, [sp, #168]	@ 0xa8
10006626:	eb45 0202 	adc.w	r2, r5, r2
1000662a:	9d0e      	ldr	r5, [sp, #56]	@ 0x38
1000662c:	f084 0401 	eor.w	r4, r4, #1
10006630:	ea04 74d5 	and.w	r4, r4, r5, lsr #31
10006634:	195b      	adds	r3, r3, r5
10006636:	eba6 0404 	sub.w	r4, r6, r4
1000663a:	eb44 0502 	adc.w	r5, r4, r2
1000663e:	eb13 000c 	adds.w	r0, r3, ip
10006642:	eb45 0101 	adc.w	r1, r5, r1
10006646:	9502      	str	r5, [sp, #8]
10006648:	eb18 0509 	adds.w	r5, r8, r9
1000664c:	ee07 5a90 	vmov	s15, r5
10006650:	eeb8 5b67 	vcvt.f64.u32	d5, s15
10006654:	9e01      	ldr	r6, [sp, #4]
10006656:	ee2d 3b05 	vmul.f64	d3, d13, d5
1000665a:	eb47 0206 	adc.w	r2, r7, r6
1000665e:	ee07 2a90 	vmov	s15, r2
10006662:	ee23 2b0f 	vmul.f64	d2, d3, d15
10006666:	eeb8 4b67 	vcvt.f64.u32	d4, s15
1000666a:	eebc 2bc2 	vcvt.u32.f64	s4, d2
1000666e:	ee24 4b0d 	vmul.f64	d4, d4, d13
10006672:	9f19      	ldr	r7, [sp, #100]	@ 0x64
10006674:	ee24 6b0f 	vmul.f64	d6, d4, d15
10006678:	fb05 f607 	mul.w	r6, r5, r7
1000667c:	960c      	str	r6, [sp, #48]	@ 0x30
1000667e:	9e1a      	ldr	r6, [sp, #104]	@ 0x68
10006680:	eeb8 0b42 	vcvt.f64.u32	d0, s4
10006684:	fb05 f406 	mul.w	r4, r5, r6
10006688:	fb02 f906 	mul.w	r9, r2, r6
1000668c:	ea05 75e6 	and.w	r5, r5, r6, asr #31
10006690:	9e05      	ldr	r6, [sp, #20]
10006692:	fb02 f807 	mul.w	r8, r2, r7
10006696:	ea07 72e2 	and.w	r2, r7, r2, asr #31
1000669a:	4415      	add	r5, r2
1000669c:	1b8e      	subs	r6, r1, r6
1000669e:	9501      	str	r5, [sp, #4]
100066a0:	960e      	str	r6, [sp, #56]	@ 0x38
100066a2:	ed9d 7b12 	vldr	d7, [sp, #72]	@ 0x48
100066a6:	eefc 2bc6 	vcvt.u32.f64	s5, d6
100066aa:	ee20 1b0e 	vmul.f64	d1, d0, d14
100066ae:	ee27 5b05 	vmul.f64	d5, d7, d5
100066b2:	ec57 6b11 	vmov	r6, r7, d1
100066b6:	ee13 5a10 	vmov	r5, s6
100066ba:	eeb8 6b62 	vcvt.f64.u32	d6, s5
100066be:	ee25 cb0f 	vmul.f64	d12, d5, d15
100066c2:	ea86 0205 	eor.w	r2, r6, r5
100066c6:	ee26 6b0e 	vmul.f64	d6, d6, d14
100066ca:	ee13 5a90 	vmov	r5, s7
100066ce:	eebc cbcc 	vcvt.u32.f64	s24, d12
100066d2:	ee14 6a10 	vmov	r6, s8
100066d6:	406f      	eors	r7, r5
100066d8:	ee16 5a10 	vmov	r5, s12
100066dc:	eeb8 7b4c 	vcvt.f64.u32	d7, s24
100066e0:	4317      	orrs	r7, r2
100066e2:	ea85 0206 	eor.w	r2, r5, r6
100066e6:	ee14 5a90 	vmov	r5, s9
100066ea:	ee16 6a90 	vmov	r6, s13
100066ee:	ee27 7b0e 	vmul.f64	d7, d7, d14
100066f2:	406e      	eors	r6, r5
100066f4:	4316      	orrs	r6, r2
100066f6:	427a      	negs	r2, r7
100066f8:	433a      	orrs	r2, r7
100066fa:	0fd2      	lsrs	r2, r2, #31
100066fc:	922f      	str	r2, [sp, #188]	@ 0xbc
100066fe:	ee17 5a10 	vmov	r5, s14
10006702:	ee15 2a10 	vmov	r2, s10
10006706:	ea85 0702 	eor.w	r7, r5, r2
1000670a:	ee15 5a90 	vmov	r5, s11
1000670e:	ee17 2a90 	vmov	r2, s15
10006712:	406a      	eors	r2, r5
10006714:	ee12 5a10 	vmov	r5, s4
10006718:	433a      	orrs	r2, r7
1000671a:	4277      	negs	r7, r6
1000671c:	4337      	orrs	r7, r6
1000671e:	4256      	negs	r6, r2
10006720:	0fff      	lsrs	r7, r7, #31
10006722:	4316      	orrs	r6, r2
10006724:	9a2f      	ldr	r2, [sp, #188]	@ 0xbc
10006726:	972e      	str	r7, [sp, #184]	@ 0xb8
10006728:	9f0c      	ldr	r7, [sp, #48]	@ 0x30
1000672a:	f082 0201 	eor.w	r2, r2, #1
1000672e:	ea02 72d7 	and.w	r2, r2, r7, lsr #31
10006732:	1aaa      	subs	r2, r5, r2
10006734:	ee12 5a90 	vmov	r5, s5
10006738:	9f2e      	ldr	r7, [sp, #184]	@ 0xb8
1000673a:	0ff6      	lsrs	r6, r6, #31
1000673c:	f087 0701 	eor.w	r7, r7, #1
10006740:	ea07 77d8 	and.w	r7, r7, r8, lsr #31
10006744:	1bef      	subs	r7, r5, r7
10006746:	ee1c 5a10 	vmov	r5, s24
1000674a:	962d      	str	r6, [sp, #180]	@ 0xb4
1000674c:	9e2d      	ldr	r6, [sp, #180]	@ 0xb4
1000674e:	eb12 0208 	adds.w	r2, r2, r8
10006752:	f086 0601 	eor.w	r6, r6, #1
10006756:	ea06 76d4 	and.w	r6, r6, r4, lsr #31
1000675a:	eb49 0707 	adc.w	r7, r9, r7
1000675e:	1bae      	subs	r6, r5, r6
10006760:	1912      	adds	r2, r2, r4
10006762:	eb46 0607 	adc.w	r6, r6, r7
10006766:	9c08      	ldr	r4, [sp, #32]
10006768:	9d02      	ldr	r5, [sp, #8]
1000676a:	f11c 0c00 	adds.w	ip, ip, #0
1000676e:	ebbc 0703 	subs.w	r7, ip, r3
10006772:	eb64 0805 	sbc.w	r8, r4, r5
10006776:	9c0b      	ldr	r4, [sp, #44]	@ 0x2c
10006778:	9d14      	ldr	r5, [sp, #80]	@ 0x50
1000677a:	193f      	adds	r7, r7, r4
1000677c:	f8cb 7000 	str.w	r7, [fp]
10006780:	9c05      	ldr	r4, [sp, #20]
10006782:	eb45 0708 	adc.w	r7, r5, r8
10006786:	f8cb 7004 	str.w	r7, [fp, #4]
1000678a:	4247      	negs	r7, r0
1000678c:	eb64 0101 	sbc.w	r1, r4, r1
10006790:	9c01      	ldr	r4, [sp, #4]
10006792:	19d7      	adds	r7, r2, r7
10006794:	eba6 0804 	sub.w	r8, r6, r4
10006798:	9c09      	ldr	r4, [sp, #36]	@ 0x24
1000679a:	eb48 0801 	adc.w	r8, r8, r1
1000679e:	193f      	adds	r7, r7, r4
100067a0:	f8ca 7000 	str.w	r7, [sl]
100067a4:	9f0a      	ldr	r7, [sp, #40]	@ 0x28
100067a6:	9c08      	ldr	r4, [sp, #32]
100067a8:	eb47 0108 	adc.w	r1, r7, r8
100067ac:	9f02      	ldr	r7, [sp, #8]
100067ae:	ebb3 030c 	subs.w	r3, r3, ip
100067b2:	eb67 0404 	sbc.w	r4, r7, r4
100067b6:	9f0b      	ldr	r7, [sp, #44]	@ 0x2c
100067b8:	f8ca 1004 	str.w	r1, [sl, #4]
100067bc:	19db      	adds	r3, r3, r7
100067be:	9f0e      	ldr	r7, [sp, #56]	@ 0x38
100067c0:	eb45 0404 	adc.w	r4, r5, r4
100067c4:	9d01      	ldr	r5, [sp, #4]
100067c6:	1a80      	subs	r0, r0, r2
100067c8:	eb67 0206 	sbc.w	r2, r7, r6
100067cc:	4415      	add	r5, r2
100067ce:	9a04      	ldr	r2, [sp, #16]
100067d0:	3000      	adds	r0, #0
100067d2:	f84b 3002 	str.w	r3, [fp, r2]
100067d6:	9b07      	ldr	r3, [sp, #28]
100067d8:	9f0a      	ldr	r7, [sp, #40]	@ 0x28
100067da:	605c      	str	r4, [r3, #4]
100067dc:	9c09      	ldr	r4, [sp, #36]	@ 0x24
100067de:	1900      	adds	r0, r0, r4
100067e0:	f84a 0002 	str.w	r0, [sl, r2]
100067e4:	9906      	ldr	r1, [sp, #24]
100067e6:	eb47 0505 	adc.w	r5, r7, r5
100067ea:	604d      	str	r5, [r1, #4]
100067ec:	f10a 0a08 	add.w	sl, sl, #8
100067f0:	f1be 0e01 	subs.w	lr, lr, #1
100067f4:	f47f adca 	bne.w	1000638c <fndsa_vect_FFT_fp64q+0x114>
100067f8:	e9dd 7c1b 	ldrd	r7, ip, [sp, #108]	@ 0x6c
100067fc:	9d1d      	ldr	r5, [sp, #116]	@ 0x74
100067fe:	9b20      	ldr	r3, [sp, #128]	@ 0x80
10006800:	3510      	adds	r5, #16
10006802:	441f      	add	r7, r3
10006804:	eb0c 0cc3 	add.w	ip, ip, r3, lsl #3
10006808:	9b1f      	ldr	r3, [sp, #124]	@ 0x7c
1000680a:	42ab      	cmp	r3, r5
1000680c:	f47f ad6d 	bne.w	100062ea <fndsa_vect_FFT_fp64q+0x72>
10006810:	f8dd b088 	ldr.w	fp, [sp, #136]	@ 0x88
10006814:	9b25      	ldr	r3, [sp, #148]	@ 0x94
10006816:	f10b 0b01 	add.w	fp, fp, #1
1000681a:	455b      	cmp	r3, fp
1000681c:	f8dd 9078 	ldr.w	r9, [sp, #120]	@ 0x78
10006820:	f47f ad40 	bne.w	100062a4 <fndsa_vect_FFT_fp64q+0x2c>
10006824:	b039      	add	sp, #228	@ 0xe4
10006826:	ecbd 8b10 	vpop	{d8-d15}
1000682a:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
1000682e:	4770      	bx	lr
