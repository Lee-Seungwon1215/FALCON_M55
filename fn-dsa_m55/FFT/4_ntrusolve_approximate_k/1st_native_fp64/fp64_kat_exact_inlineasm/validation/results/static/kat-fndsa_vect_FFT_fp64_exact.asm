
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_kat_exact_inlineasm/validation/build/kat/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

100051c8 <fndsa_vect_FFT_fp64_exact>:
100051c8:	2801      	cmp	r0, #1
100051ca:	f240 81fb 	bls.w	100055c4 <fndsa_vect_FFT_fp64_exact+0x3fc>
100051ce:	2201      	movs	r2, #1
100051d0:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
100051d4:	ed2d 8b10 	vpush	{d8-d15}
100051d8:	2310      	movs	r3, #16
100051da:	460f      	mov	r7, r1
100051dc:	ed9f bbf4 	vldr	d11, [pc, #976]	@ 100055b0 <fndsa_vect_FFT_fp64_exact+0x3e8>
100051e0:	ed9f fbf5 	vldr	d15, [pc, #980]	@ 100055b8 <fndsa_vect_FFT_fp64_exact+0x3f0>
100051e4:	4615      	mov	r5, r2
100051e6:	b0c9      	sub	sp, #292	@ 0x124
100051e8:	9117      	str	r1, [sp, #92]	@ 0x5c
100051ea:	1e41      	subs	r1, r0, #1
100051ec:	408b      	lsls	r3, r1
100051ee:	fa02 f401 	lsl.w	r4, r2, r1
100051f2:	eb07 0e03 	add.w	lr, r7, r3
100051f6:	901b      	str	r0, [sp, #108]	@ 0x6c
100051f8:	f04f 0c01 	mov.w	ip, #1
100051fc:	2110      	movs	r1, #16
100051fe:	4626      	mov	r6, r4
10005200:	2000      	movs	r0, #0
10005202:	fa24 f40c 	lsr.w	r4, r4, ip
10005206:	9b17      	ldr	r3, [sp, #92]	@ 0x5c
10005208:	fa0c fc05 	lsl.w	ip, ip, r5
1000520c:	ea4f 025c 	mov.w	r2, ip, lsr #1
10005210:	eb03 1304 	add.w	r3, r3, r4, lsl #4
10005214:	9216      	str	r2, [sp, #88]	@ 0x58
10005216:	4aea      	ldr	r2, [pc, #936]	@ (100055c0 <fndsa_vect_FFT_fp64_exact+0x3f8>)
10005218:	3308      	adds	r3, #8
1000521a:	40a9      	lsls	r1, r5
1000521c:	9318      	str	r3, [sp, #96]	@ 0x60
1000521e:	4411      	add	r1, r2
10005220:	4603      	mov	r3, r0
10005222:	4632      	mov	r2, r6
10005224:	46a2      	mov	sl, r4
10005226:	e9cd 4519 	strd	r4, r5, [sp, #100]	@ 0x64
1000522a:	4553      	cmp	r3, sl
1000522c:	f080 81a8 	bcs.w	10005580 <fndsa_vect_FFT_fp64_exact+0x3b8>
10005230:	edd1 7a01 	vldr	s15, [r1, #4]
10005234:	edd1 5a03 	vldr	s11, [r1, #12]
10005238:	eeb8 7b67 	vcvt.f64.u32	d7, s15
1000523c:	eeb8 5b65 	vcvt.f64.u32	d5, s11
10005240:	edd1 6a00 	vldr	s13, [r1]
10005244:	edd1 4a02 	vldr	s9, [r1, #8]
10005248:	eeb8 6b66 	vcvt.f64.u32	d6, s13
1000524c:	eeb8 4b64 	vcvt.f64.u32	d4, s9
10005250:	ed8d 7b06 	vstr	d7, [sp, #24]
10005254:	ee37 7b05 	vadd.f64	d7, d7, d5
10005258:	ed8d 7b0e 	vstr	d7, [sp, #56]	@ 0x38
1000525c:	ee36 7b04 	vadd.f64	d7, d6, d4
10005260:	ed8d 6b08 	vstr	d6, [sp, #32]
10005264:	ed8d 5b0a 	vstr	d5, [sp, #40]	@ 0x28
10005268:	ed8d 4b0c 	vstr	d4, [sp, #48]	@ 0x30
1000526c:	eeb7 db00 	vmov.f64	d13, #112	@ 0x3f800000  1.0
10005270:	4698      	mov	r8, r3
10005272:	ed8d 7b10 	vstr	d7, [sp, #64]	@ 0x40
10005276:	460f      	mov	r7, r1
10005278:	9c17      	ldr	r4, [sp, #92]	@ 0x5c
1000527a:	9e18      	ldr	r6, [sp, #96]	@ 0x60
1000527c:	e9cd 0312 	strd	r0, r3, [sp, #72]	@ 0x48
10005280:	e9cd e214 	strd	lr, r2, [sp, #80]	@ 0x50
10005284:	f10e 0908 	add.w	r9, lr, #8
10005288:	eb04 1503 	add.w	r5, r4, r3, lsl #4
1000528c:	eb09 190a 	add.w	r9, r9, sl, lsl #4
10005290:	eb0e 1403 	add.w	r4, lr, r3, lsl #4
10005294:	eb06 1603 	add.w	r6, r6, r3, lsl #4
10005298:	f10d 0bc0 	add.w	fp, sp, #192	@ 0xc0
1000529c:	ed94 7b00 	vldr	d7, [r4]
100052a0:	f1a6 0308 	sub.w	r3, r6, #8
100052a4:	cb0f      	ldmia	r3, {r0, r1, r2, r3}
100052a6:	e88b 000f 	stmia.w	fp, {r0, r1, r2, r3}
100052aa:	ed95 1b00 	vldr	d1, [r5]
100052ae:	ed9d 6b08 	vldr	d6, [sp, #32]
100052b2:	ed9d eb30 	vldr	d14, [sp, #192]	@ 0xc0
100052b6:	ed8d 7b00 	vstr	d7, [sp]
100052ba:	ed9d 7b32 	vldr	d7, [sp, #200]	@ 0xc8
100052be:	ed9d 0b06 	vldr	d0, [sp, #24]
100052c2:	f1a9 0c08 	sub.w	ip, r9, #8
100052c6:	e89c 000f 	ldmia.w	ip, {r0, r1, r2, r3}
100052ca:	f10d 0cd0 	add.w	ip, sp, #208	@ 0xd0
100052ce:	e88c 000f 	stmia.w	ip, {r0, r1, r2, r3}
100052d2:	eeb0 3b47 	vmov.f64	d3, d7
100052d6:	ed8d 1b02 	vstr	d1, [sp, #8]
100052da:	eeb0 2b4e 	vmov.f64	d2, d14
100052de:	eeb0 1b46 	vmov.f64	d1, d6
100052e2:	ed95 cb02 	vldr	d12, [r5, #8]
100052e6:	ed94 8b02 	vldr	d8, [r4, #8]
100052ea:	ed9d 9b34 	vldr	d9, [sp, #208]	@ 0xd0
100052ee:	ed8d 7b42 	vstr	d7, [sp, #264]	@ 0x108
100052f2:	ed8d 7b04 	vstr	d7, [sp, #16]
100052f6:	ed8d 0b38 	vstr	d0, [sp, #224]	@ 0xe0
100052fa:	ed8d 6b3a 	vstr	d6, [sp, #232]	@ 0xe8
100052fe:	ed8d eb40 	vstr	d14, [sp, #256]	@ 0x100
10005302:	ed9d ab36 	vldr	d10, [sp, #216]	@ 0xd8
10005306:	f003 f865 	bl	100083d4 <fndsa_fp64e_mul>
1000530a:	ed9d 6b0c 	vldr	d6, [sp, #48]	@ 0x30
1000530e:	ed8d 0b1c 	vstr	d0, [sp, #112]	@ 0x70
10005312:	ed9d 0b0a 	vldr	d0, [sp, #40]	@ 0x28
10005316:	eeb0 2b49 	vmov.f64	d2, d9
1000531a:	ed8d 1b1e 	vstr	d1, [sp, #120]	@ 0x78
1000531e:	eeb0 3b4a 	vmov.f64	d3, d10
10005322:	eeb0 1b46 	vmov.f64	d1, d6
10005326:	ed8d 0b3c 	vstr	d0, [sp, #240]	@ 0xf0
1000532a:	ed8d 6b3e 	vstr	d6, [sp, #248]	@ 0xf8
1000532e:	ed8d 9b44 	vstr	d9, [sp, #272]	@ 0x110
10005332:	ed8d ab46 	vstr	d10, [sp, #280]	@ 0x118
10005336:	f003 f84d 	bl	100083d4 <fndsa_fp64e_mul>
1000533a:	ed9d 7b04 	vldr	d7, [sp, #16]
1000533e:	ed9d 5b10 	vldr	d5, [sp, #64]	@ 0x40
10005342:	ee37 3b0a 	vadd.f64	d3, d7, d10
10005346:	ee25 7b0b 	vmul.f64	d7, d5, d11
1000534a:	ee23 6b0b 	vmul.f64	d6, d3, d11
1000534e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005352:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10005356:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000535a:	ed9d 4b0e 	vldr	d4, [sp, #56]	@ 0x38
1000535e:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005362:	ee3e 2b09 	vadd.f64	d2, d14, d9
10005366:	ed8d 0b20 	vstr	d0, [sp, #128]	@ 0x80
1000536a:	ee32 2b06 	vadd.f64	d2, d2, d6
1000536e:	ee34 0b07 	vadd.f64	d0, d4, d7
10005372:	ee07 5b4f 	vmls.f64	d5, d7, d15
10005376:	ee06 3b4f 	vmls.f64	d3, d6, d15
1000537a:	ee20 7b0b 	vmul.f64	d7, d0, d11
1000537e:	ee22 6b0b 	vmul.f64	d6, d2, d11
10005382:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005386:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000538a:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000538e:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005392:	ee07 0b4f 	vmls.f64	d0, d7, d15
10005396:	ee06 2b4f 	vmls.f64	d2, d6, d15
1000539a:	ed8d 1b22 	vstr	d1, [sp, #136]	@ 0x88
1000539e:	eeb0 1b45 	vmov.f64	d1, d5
100053a2:	ed8d 5b2e 	vstr	d5, [sp, #184]	@ 0xb8
100053a6:	ed8d 3b2a 	vstr	d3, [sp, #168]	@ 0xa8
100053aa:	ed8d 0b2c 	vstr	d0, [sp, #176]	@ 0xb0
100053ae:	ed8d 2b28 	vstr	d2, [sp, #160]	@ 0xa0
100053b2:	f003 f80f 	bl	100083d4 <fndsa_fp64e_mul>
100053b6:	ed9d 4b22 	vldr	d4, [sp, #136]	@ 0x88
100053ba:	ed9d 5b1e 	vldr	d5, [sp, #120]	@ 0x78
100053be:	ee35 6b04 	vadd.f64	d6, d5, d4
100053c2:	ee26 3b0b 	vmul.f64	d3, d6, d11
100053c6:	ed9d 2b20 	vldr	d2, [sp, #128]	@ 0x80
100053ca:	ed9d 7b1c 	vldr	d7, [sp, #112]	@ 0x70
100053ce:	ee35 5b0f 	vadd.f64	d5, d5, d15
100053d2:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100053d6:	ee35 5b44 	vsub.f64	d5, d5, d4
100053da:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100053de:	ee37 4b02 	vadd.f64	d4, d7, d2
100053e2:	ee37 7b0f 	vadd.f64	d7, d7, d15
100053e6:	ee34 4b03 	vadd.f64	d4, d4, d3
100053ea:	ee37 7b42 	vsub.f64	d7, d7, d2
100053ee:	ee24 2b0b 	vmul.f64	d2, d4, d11
100053f2:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100053f6:	ee03 6b4f 	vmls.f64	d6, d3, d15
100053fa:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100053fe:	ed8d 1b26 	vstr	d1, [sp, #152]	@ 0x98
10005402:	ee31 1b0f 	vadd.f64	d1, d1, d15
10005406:	ee25 3b0b 	vmul.f64	d3, d5, d11
1000540a:	ee31 6b46 	vsub.f64	d6, d1, d6
1000540e:	ee02 4b4f 	vmls.f64	d4, d2, d15
10005412:	ed8d 0b24 	vstr	d0, [sp, #144]	@ 0x90
10005416:	ee30 0b0f 	vadd.f64	d0, d0, d15
1000541a:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000541e:	ee30 0b44 	vsub.f64	d0, d0, d4
10005422:	ee26 4b0b 	vmul.f64	d4, d6, d11
10005426:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000542a:	ee37 7b4d 	vsub.f64	d7, d7, d13
1000542e:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10005432:	ee37 7b03 	vadd.f64	d7, d7, d3
10005436:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000543a:	ee30 0b4d 	vsub.f64	d0, d0, d13
1000543e:	ee03 5b4f 	vmls.f64	d5, d3, d15
10005442:	ee30 0b04 	vadd.f64	d0, d0, d4
10005446:	ee27 3b0b 	vmul.f64	d3, d7, d11
1000544a:	ee04 6b4f 	vmls.f64	d6, d4, d15
1000544e:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10005452:	ee20 4b0b 	vmul.f64	d4, d0, d11
10005456:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000545a:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000545e:	ee03 7b4f 	vmls.f64	d7, d3, d15
10005462:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10005466:	ee3c 3b0f 	vadd.f64	d3, d12, d15
1000546a:	ee3c cb05 	vadd.f64	d12, d12, d5
1000546e:	ee04 0b4f 	vmls.f64	d0, d4, d15
10005472:	ee33 5b45 	vsub.f64	d5, d3, d5
10005476:	ee38 4b0f 	vadd.f64	d4, d8, d15
1000547a:	ee2c 3b0b 	vmul.f64	d3, d12, d11
1000547e:	ed9d 1b02 	vldr	d1, [sp, #8]
10005482:	ee36 8b08 	vadd.f64	d8, d6, d8
10005486:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000548a:	ee34 6b46 	vsub.f64	d6, d4, d6
1000548e:	ee31 4b0f 	vadd.f64	d4, d1, d15
10005492:	ee28 2b0b 	vmul.f64	d2, d8, d11
10005496:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000549a:	ee25 9b0b 	vmul.f64	d9, d5, d11
1000549e:	ee37 1b01 	vadd.f64	d1, d7, d1
100054a2:	ee34 4b47 	vsub.f64	d4, d4, d7
100054a6:	ed9d 7b00 	vldr	d7, [sp]
100054aa:	ee31 1b03 	vadd.f64	d1, d1, d3
100054ae:	ee03 cb4f 	vmls.f64	d12, d3, d15
100054b2:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100054b6:	ee37 3b0f 	vadd.f64	d3, d7, d15
100054ba:	eebc 9bc9 	vcvt.u32.f64	s18, d9
100054be:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100054c2:	eeb8 9b49 	vcvt.f64.u32	d9, s18
100054c6:	ee37 7b00 	vadd.f64	d7, d7, d0
100054ca:	ee33 3b40 	vsub.f64	d3, d3, d0
100054ce:	ee34 4b4d 	vsub.f64	d4, d4, d13
100054d2:	ee21 0b0b 	vmul.f64	d0, d1, d11
100054d6:	ee34 4b09 	vadd.f64	d4, d4, d9
100054da:	ee09 5b4f 	vmls.f64	d5, d9, d15
100054de:	ee37 7b02 	vadd.f64	d7, d7, d2
100054e2:	ee26 9b0b 	vmul.f64	d9, d6, d11
100054e6:	eebc 0bc0 	vcvt.u32.f64	s0, d0
100054ea:	ee02 8b4f 	vmls.f64	d8, d2, d15
100054ee:	eebc 9bc9 	vcvt.u32.f64	s18, d9
100054f2:	ee27 2b0b 	vmul.f64	d2, d7, d11
100054f6:	eeb8 0b40 	vcvt.f64.u32	d0, s0
100054fa:	eeb8 9b49 	vcvt.f64.u32	d9, s18
100054fe:	ee00 1b4f 	vmls.f64	d1, d0, d15
10005502:	ee33 3b4d 	vsub.f64	d3, d3, d13
10005506:	eebc 2bc2 	vcvt.u32.f64	s4, d2
1000550a:	ed85 1b00 	vstr	d1, [r5]
1000550e:	ee33 3b09 	vadd.f64	d3, d3, d9
10005512:	ee24 1b0b 	vmul.f64	d1, d4, d11
10005516:	eeb8 2b42 	vcvt.f64.u32	d2, s4
1000551a:	eebc 1bc1 	vcvt.u32.f64	s2, d1
1000551e:	ee02 7b4f 	vmls.f64	d7, d2, d15
10005522:	ee23 2b0b 	vmul.f64	d2, d3, d11
10005526:	eeb8 1b41 	vcvt.f64.u32	d1, s2
1000552a:	eebc 2bc2 	vcvt.u32.f64	s4, d2
1000552e:	4633      	mov	r3, r6
10005530:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10005534:	ee01 4b4f 	vmls.f64	d4, d1, d15
10005538:	3410      	adds	r4, #16
1000553a:	ed85 cb02 	vstr	d12, [r5, #8]
1000553e:	ee09 6b4f 	vmls.f64	d6, d9, d15
10005542:	ed04 8b02 	vstr	d8, [r4, #-8]
10005546:	ed04 7b04 	vstr	d7, [r4, #-16]
1000554a:	ee02 3b4f 	vmls.f64	d3, d2, d15
1000554e:	ed06 4b02 	vstr	d4, [r6, #-8]
10005552:	ed83 5b00 	vstr	d5, [r3]
10005556:	464b      	mov	r3, r9
10005558:	f108 0801 	add.w	r8, r8, #1
1000555c:	45d0      	cmp	r8, sl
1000555e:	ed09 3b02 	vstr	d3, [r9, #-8]
10005562:	f105 0510 	add.w	r5, r5, #16
10005566:	ed83 6b00 	vstr	d6, [r3]
1000556a:	f106 0610 	add.w	r6, r6, #16
1000556e:	f109 0910 	add.w	r9, r9, #16
10005572:	f47f ae93 	bne.w	1000529c <fndsa_vect_FFT_fp64_exact+0xd4>
10005576:	e9dd 0312 	ldrd	r0, r3, [sp, #72]	@ 0x48
1000557a:	e9dd e214 	ldrd	lr, r2, [sp, #80]	@ 0x50
1000557e:	4639      	mov	r1, r7
10005580:	9c16      	ldr	r4, [sp, #88]	@ 0x58
10005582:	3001      	adds	r0, #1
10005584:	42a0      	cmp	r0, r4
10005586:	4413      	add	r3, r2
10005588:	4492      	add	sl, r2
1000558a:	f101 0110 	add.w	r1, r1, #16
1000558e:	f47f ae4c 	bne.w	1000522a <fndsa_vect_FFT_fp64_exact+0x62>
10005592:	e9dd 4519 	ldrd	r4, r5, [sp, #100]	@ 0x64
10005596:	9b1b      	ldr	r3, [sp, #108]	@ 0x6c
10005598:	3501      	adds	r5, #1
1000559a:	42ab      	cmp	r3, r5
1000559c:	f47f ae2c 	bne.w	100051f8 <fndsa_vect_FFT_fp64_exact+0x30>
100055a0:	b049      	add	sp, #292	@ 0x124
100055a2:	ecbd 8b10 	vpop	{d8-d15}
100055a6:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
100055aa:	bf00      	nop
100055ac:	f3af 8000 	nop.w
100055b0:	00000000 	.word	0x00000000
100055b4:	3df00000 	.word	0x3df00000
100055b8:	00000000 	.word	0x00000000
100055bc:	41f00000 	.word	0x41f00000
100055c0:	300039a0 	.word	0x300039a0
100055c4:	4770      	bx	lr
