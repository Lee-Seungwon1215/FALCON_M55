
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/r2-kat/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10005338 <fndsa_vect_inv_mul2e_fft_fp64_exact>:
10005338:	b5f0      	push	{r4, r5, r6, r7, lr}
1000533a:	2701      	movs	r7, #1
1000533c:	fa07 f202 	lsl.w	r2, r7, r2
10005340:	ee07 2a90 	vmov	s15, r2
10005344:	2410      	movs	r4, #16
10005346:	ed2d 8b10 	vpush	{d8-d15}
1000534a:	2600      	movs	r6, #0
1000534c:	ed9f ab70 	vldr	d10, [pc, #448]	@ 10005510 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x1d8>
10005350:	ed9f db71 	vldr	d13, [pc, #452]	@ 10005518 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x1e0>
10005354:	460d      	mov	r5, r1
10005356:	eeb8 cb67 	vcvt.f64.u32	d12, s15
1000535a:	3801      	subs	r0, #1
1000535c:	4084      	lsls	r4, r0
1000535e:	b095      	sub	sp, #84	@ 0x54
10005360:	4087      	lsls	r7, r0
10005362:	440c      	add	r4, r1
10005364:	ed94 8b02 	vldr	d8, [r4, #8]
10005368:	ee3a 8b48 	vsub.f64	d8, d10, d8
1000536c:	ed94 9b00 	vldr	d9, [r4]
10005370:	ee28 7b0d 	vmul.f64	d7, d8, d13
10005374:	eeb7 6b00 	vmov.f64	d6, #112	@ 0x3f800000  1.0
10005378:	ee3a 9b49 	vsub.f64	d9, d10, d9
1000537c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005380:	ee39 9b46 	vsub.f64	d9, d9, d6
10005384:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005388:	ee39 9b07 	vadd.f64	d9, d9, d7
1000538c:	ee07 8b4a 	vmls.f64	d8, d7, d10
10005390:	ee29 7b0d 	vmul.f64	d7, d9, d13
10005394:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005398:	ed95 eb00 	vldr	d14, [r5]
1000539c:	ed95 bb02 	vldr	d11, [r5, #8]
100053a0:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100053a4:	eeb0 1b4b 	vmov.f64	d1, d11
100053a8:	eeb0 3b4b 	vmov.f64	d3, d11
100053ac:	eeb0 0b4e 	vmov.f64	d0, d14
100053b0:	eeb0 2b4e 	vmov.f64	d2, d14
100053b4:	ee07 9b4a 	vmls.f64	d9, d7, d10
100053b8:	ed8d bb06 	vstr	d11, [sp, #24]
100053bc:	ed8d eb04 	vstr	d14, [sp, #16]
100053c0:	f7ff fed6 	bl	10005170 <fndsa_fp64e_mul>
100053c4:	ee2b bb0c 	vmul.f64	d11, d11, d12
100053c8:	eeb0 7b41 	vmov.f64	d7, d1
100053cc:	eeb0 fb40 	vmov.f64	d15, d0
100053d0:	eeb0 1b48 	vmov.f64	d1, d8
100053d4:	eeb0 2b49 	vmov.f64	d2, d9
100053d8:	eeb0 3b48 	vmov.f64	d3, d8
100053dc:	eeb0 0b49 	vmov.f64	d0, d9
100053e0:	ed8d fb0c 	vstr	d15, [sp, #48]	@ 0x30
100053e4:	ed8d 7b0e 	vstr	d7, [sp, #56]	@ 0x38
100053e8:	ed8d 7b00 	vstr	d7, [sp]
100053ec:	ed8d 8b0a 	vstr	d8, [sp, #40]	@ 0x28
100053f0:	ed8d 9b08 	vstr	d9, [sp, #32]
100053f4:	f7ff febc 	bl	10005170 <fndsa_fp64e_mul>
100053f8:	ed9d 7b00 	vldr	d7, [sp]
100053fc:	ee2b 5b0d 	vmul.f64	d5, d11, d13
10005400:	ee37 7b01 	vadd.f64	d7, d7, d1
10005404:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10005408:	ee27 6b0d 	vmul.f64	d6, d7, d13
1000540c:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10005410:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10005414:	eeb0 4b45 	vmov.f64	d4, d5
10005418:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000541c:	ee0e 4b0c 	vmla.f64	d4, d14, d12
10005420:	ee05 bb4a 	vmls.f64	d11, d5, d10
10005424:	ee3f fb00 	vadd.f64	d15, d15, d0
10005428:	ee06 7b4a 	vmls.f64	d7, d6, d10
1000542c:	ee3f 5b06 	vadd.f64	d5, d15, d6
10005430:	ee24 3b0d 	vmul.f64	d3, d4, d13
10005434:	eefc 6bcb 	vcvt.u32.f64	s13, d11
10005438:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000543c:	ee16 0a90 	vmov	r0, s13
10005440:	ee25 6b0d 	vmul.f64	d6, d5, d13
10005444:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10005448:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000544c:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10005450:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005454:	ee03 4b4a 	vmls.f64	d4, d3, d10
10005458:	ee06 5b4a 	vmls.f64	d5, d6, d10
1000545c:	ee17 2a90 	vmov	r2, s15
10005460:	edcd 7a03 	vstr	s15, [sp, #12]
10005464:	eefc 7bc4 	vcvt.u32.f64	s15, d4
10005468:	ee17 1a90 	vmov	r1, s15
1000546c:	eefc 7bc5 	vcvt.u32.f64	s15, d5
10005470:	ee17 3a90 	vmov	r3, s15
10005474:	edcd 7a00 	vstr	s15, [sp]
10005478:	ed8d 0b10 	vstr	d0, [sp, #64]	@ 0x40
1000547c:	ed8d 1b12 	vstr	d1, [sp, #72]	@ 0x48
10005480:	f7ff fc9e 	bl	10004dc0 <fxr_div_fp64_exact>
10005484:	ee2c 8b08 	vmul.f64	d8, d12, d8
10005488:	ee28 7b0d 	vmul.f64	d7, d8, d13
1000548c:	ee06 1a10 	vmov	s12, r1
10005490:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005494:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005498:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000549c:	ed85 6b00 	vstr	d6, [r5]
100054a0:	eeb0 6b47 	vmov.f64	d6, d7
100054a4:	ee0c 6b09 	vmla.f64	d6, d12, d9
100054a8:	ee07 8b4a 	vmls.f64	d8, d7, d10
100054ac:	ee26 7b0d 	vmul.f64	d7, d6, d13
100054b0:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100054b4:	ee05 0a10 	vmov	s10, r0
100054b8:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100054bc:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100054c0:	ee07 6b4a 	vmls.f64	d6, d7, d10
100054c4:	ed85 5b02 	vstr	d5, [r5, #8]
100054c8:	eefc 7bc6 	vcvt.u32.f64	s15, d6
100054cc:	eefc 5bc8 	vcvt.u32.f64	s11, d8
100054d0:	ee17 1a90 	vmov	r1, s15
100054d4:	ee15 0a90 	vmov	r0, s11
100054d8:	9a03      	ldr	r2, [sp, #12]
100054da:	9b00      	ldr	r3, [sp, #0]
100054dc:	f7ff fc70 	bl	10004dc0 <fxr_div_fp64_exact>
100054e0:	ee06 0a10 	vmov	s12, r0
100054e4:	ee07 1a10 	vmov	s14, r1
100054e8:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100054ec:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100054f0:	3601      	adds	r6, #1
100054f2:	42b7      	cmp	r7, r6
100054f4:	f104 0410 	add.w	r4, r4, #16
100054f8:	f105 0510 	add.w	r5, r5, #16
100054fc:	ed04 6b02 	vstr	d6, [r4, #-8]
10005500:	ed04 7b04 	vstr	d7, [r4, #-16]
10005504:	f47f af2e 	bne.w	10005364 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x2c>
10005508:	b015      	add	sp, #84	@ 0x54
1000550a:	ecbd 8b10 	vpop	{d8-d15}
1000550e:	bdf0      	pop	{r4, r5, r6, r7, pc}
10005510:	00000000 	.word	0x00000000
10005514:	41f00000 	.word	0x41f00000
10005518:	00000000 	.word	0x00000000
1000551c:	3df00000 	.word	0x3df00000
