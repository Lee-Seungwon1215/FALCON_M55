
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_q32_compat/validation/build/kernels/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

100004e0 <fp64q_mul>:
100004e0:	b570      	push	{r4, r5, r6, lr}
100004e2:	ed2d 8b02 	vpush	{d8}
100004e6:	b084      	sub	sp, #16
100004e8:	e9dd 410a 	ldrd	r4, r1, [sp, #40]	@ 0x28
100004ec:	ee06 2a90 	vmov	s13, r2
100004f0:	ee07 4a90 	vmov	s15, r4
100004f4:	461d      	mov	r5, r3
100004f6:	eeb8 3b67 	vcvt.f64.u32	d3, s15
100004fa:	eeb8 6b66 	vcvt.f64.u32	d6, s13
100004fe:	ee07 1a90 	vmov	s15, r1
10000502:	ee05 5a90 	vmov	s11, r5
10000506:	ee26 0b03 	vmul.f64	d0, d6, d3
1000050a:	eeb8 1b67 	vcvt.f64.u32	d1, s15
1000050e:	ed9f 7b46 	vldr	d7, [pc, #280]	@ 10000628 <fp64q_mul+0x148>
10000512:	eeb8 5b65 	vcvt.f64.u32	d5, s11
10000516:	ee21 1b06 	vmul.f64	d1, d1, d6
1000051a:	ee20 6b07 	vmul.f64	d6, d0, d7
1000051e:	ee25 5b03 	vmul.f64	d5, d5, d3
10000522:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10000526:	ee21 3b07 	vmul.f64	d3, d1, d7
1000052a:	ee25 7b07 	vmul.f64	d7, d5, d7
1000052e:	ed9f 4b40 	vldr	d4, [pc, #256]	@ 10000630 <fp64q_mul+0x150>
10000532:	eeb8 2b46 	vcvt.f64.u32	d2, s12
10000536:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000053a:	eefc 7bc3 	vcvt.u32.f64	s15, d3
1000053e:	ee22 2b04 	vmul.f64	d2, d2, d4
10000542:	eeb8 3b67 	vcvt.f64.u32	d3, s15
10000546:	fb01 fe02 	mul.w	lr, r1, r2
1000054a:	fb04 f302 	mul.w	r3, r4, r2
1000054e:	ea02 72e1 	and.w	r2, r2, r1, asr #31
10000552:	fb05 f101 	mul.w	r1, r5, r1
10000556:	fb04 fc05 	mul.w	ip, r4, r5
1000055a:	ea04 74e5 	and.w	r4, r4, r5, asr #31
1000055e:	1b09      	subs	r1, r1, r4
10000560:	ee10 6a90 	vmov	r6, s1
10000564:	ec55 4b12 	vmov	r4, r5, d2
10000568:	1a89      	subs	r1, r1, r2
1000056a:	ee10 2a10 	vmov	r2, s0
1000056e:	ee23 3b04 	vmul.f64	d3, d3, d4
10000572:	4062      	eors	r2, r4
10000574:	ea86 0405 	eor.w	r4, r6, r5
10000578:	4322      	orrs	r2, r4
1000057a:	ee11 5a10 	vmov	r5, s2
1000057e:	ee13 4a10 	vmov	r4, s6
10000582:	ee11 6a90 	vmov	r6, s3
10000586:	406c      	eors	r4, r5
10000588:	ee13 5a90 	vmov	r5, s7
1000058c:	eeb8 8b47 	vcvt.f64.u32	d8, s14
10000590:	4075      	eors	r5, r6
10000592:	4325      	orrs	r5, r4
10000594:	4254      	negs	r4, r2
10000596:	4322      	orrs	r2, r4
10000598:	0fd2      	lsrs	r2, r2, #31
1000059a:	9203      	str	r2, [sp, #12]
1000059c:	9a03      	ldr	r2, [sp, #12]
1000059e:	426c      	negs	r4, r5
100005a0:	f082 0201 	eor.w	r2, r2, #1
100005a4:	ea02 73d3 	and.w	r3, r2, r3, lsr #31
100005a8:	ee16 2a10 	vmov	r2, s12
100005ac:	432c      	orrs	r4, r5
100005ae:	0fe4      	lsrs	r4, r4, #31
100005b0:	9402      	str	r4, [sp, #8]
100005b2:	ee17 4a90 	vmov	r4, s15
100005b6:	ee28 4b04 	vmul.f64	d4, d8, d4
100005ba:	1ad2      	subs	r2, r2, r3
100005bc:	9b02      	ldr	r3, [sp, #8]
100005be:	eb12 020e 	adds.w	r2, r2, lr
100005c2:	f083 0301 	eor.w	r3, r3, #1
100005c6:	ea03 73de 	and.w	r3, r3, lr, lsr #31
100005ca:	eba4 0303 	sub.w	r3, r4, r3
100005ce:	eb43 0101 	adc.w	r1, r3, r1
100005d2:	eb12 020c 	adds.w	r2, r2, ip
100005d6:	ee14 3a10 	vmov	r3, s8
100005da:	6002      	str	r2, [r0, #0]
100005dc:	ee15 2a10 	vmov	r2, s10
100005e0:	ee15 4a90 	vmov	r4, s11
100005e4:	ea83 0302 	eor.w	r3, r3, r2
100005e8:	ee14 2a90 	vmov	r2, s9
100005ec:	ea82 0204 	eor.w	r2, r2, r4
100005f0:	ea42 0203 	orr.w	r2, r2, r3
100005f4:	f1c2 0300 	rsb	r3, r2, #0
100005f8:	ea43 0302 	orr.w	r3, r3, r2
100005fc:	ee17 2a10 	vmov	r2, s14
10000600:	ea4f 73d3 	mov.w	r3, r3, lsr #31
10000604:	9301      	str	r3, [sp, #4]
10000606:	9b01      	ldr	r3, [sp, #4]
10000608:	f083 0301 	eor.w	r3, r3, #1
1000060c:	ea03 73dc 	and.w	r3, r3, ip, lsr #31
10000610:	eba2 0303 	sub.w	r3, r2, r3
10000614:	eb43 0301 	adc.w	r3, r3, r1
10000618:	6043      	str	r3, [r0, #4]
1000061a:	b004      	add	sp, #16
1000061c:	ecbd 8b02 	vpop	{d8}
10000620:	bd70      	pop	{r4, r5, r6, pc}
10000622:	bf00      	nop
10000624:	f3af 8000 	nop.w
10000628:	00000000 	.word	0x00000000
1000062c:	3df00000 	.word	0x3df00000
10000630:	00000000 	.word	0x00000000
10000634:	41f00000 	.word	0x41f00000
