
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_kat_exact_inlineasm/validation/build/kat/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

100083d4 <fndsa_fp64e_mul>:
100083d4:	ed2d 8b0e 	vpush	{d8-d14}
100083d8:	4b64      	ldr	r3, [pc, #400]	@ (1000856c <fndsa_fp64e_mul+0x198>)
100083da:	b090      	sub	sp, #64	@ 0x40
100083dc:	ed8d 0b08 	vstr	d0, [sp, #32]
100083e0:	ed8d 1b0a 	vstr	d1, [sp, #40]	@ 0x28
100083e4:	ed8d 2b04 	vstr	d2, [sp, #16]
100083e8:	ed8d 3b06 	vstr	d3, [sp, #24]
100083ec:	eebc 4bc0 	vcvt.u32.f64	s8, d0
100083f0:	ee14 2a10 	vmov	r2, s8
100083f4:	0fd2      	lsrs	r2, r2, #31
100083f6:	ee04 2a10 	vmov	s8, r2
100083fa:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100083fe:	ee24 eb03 	vmul.f64	d14, d4, d3
10008402:	eebc 4bc2 	vcvt.u32.f64	s8, d2
10008406:	ee14 2a10 	vmov	r2, s8
1000840a:	0fd2      	lsrs	r2, r2, #31
1000840c:	ee04 2a10 	vmov	s8, r2
10008410:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10008414:	ee04 eb01 	vmla.f64	d14, d4, d1
10008418:	eeb0 8b40 	vmov.f64	d8, d0
1000841c:	eeb0 9b41 	vmov.f64	d9, d1
10008420:	eeb0 ab42 	vmov.f64	d10, d2
10008424:	eeb0 bb43 	vmov.f64	d11, d3
10008428:	ed93 cb00 	vldr	d12, [r3]
1000842c:	ed93 db02 	vldr	d13, [r3, #8]
10008430:	ee29 1b0d 	vmul.f64	d1, d9, d13
10008434:	ee28 3b0d 	vmul.f64	d3, d8, d13
10008438:	ee2b 5b0d 	vmul.f64	d5, d11, d13
1000843c:	ee2a 7b0d 	vmul.f64	d7, d10, d13
10008440:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10008444:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10008448:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000844c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10008450:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10008454:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10008458:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000845c:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10008460:	eeb0 0b49 	vmov.f64	d0, d9
10008464:	eeb0 2b48 	vmov.f64	d2, d8
10008468:	eeb0 4b4b 	vmov.f64	d4, d11
1000846c:	eeb0 6b4a 	vmov.f64	d6, d10
10008470:	ee01 0b4c 	vmls.f64	d0, d1, d12
10008474:	ee03 2b4c 	vmls.f64	d2, d3, d12
10008478:	ee05 4b4c 	vmls.f64	d4, d5, d12
1000847c:	ee07 6b4c 	vmls.f64	d6, d7, d12
10008480:	ee20 8b04 	vmul.f64	d8, d0, d4
10008484:	ee28 9b0d 	vmul.f64	d9, d8, d13
10008488:	eebc 9bc9 	vcvt.u32.f64	s18, d9
1000848c:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10008490:	eeb0 8b49 	vmov.f64	d8, d9
10008494:	ee00 8b05 	vmla.f64	d8, d0, d5
10008498:	ee01 8b04 	vmla.f64	d8, d1, d4
1000849c:	ee28 9b0d 	vmul.f64	d9, d8, d13
100084a0:	eebc 9bc9 	vcvt.u32.f64	s18, d9
100084a4:	eeb8 9b49 	vcvt.f64.u32	d9, s18
100084a8:	eeb0 8b49 	vmov.f64	d8, d9
100084ac:	ee00 8b06 	vmla.f64	d8, d0, d6
100084b0:	ee01 8b05 	vmla.f64	d8, d1, d5
100084b4:	ee02 8b04 	vmla.f64	d8, d2, d4
100084b8:	ee28 9b0d 	vmul.f64	d9, d8, d13
100084bc:	eebc 9bc9 	vcvt.u32.f64	s18, d9
100084c0:	eeb8 9b49 	vcvt.f64.u32	d9, s18
100084c4:	ee09 8b4c 	vmls.f64	d8, d9, d12
100084c8:	eeb0 ab48 	vmov.f64	d10, d8
100084cc:	eeb0 8b49 	vmov.f64	d8, d9
100084d0:	ee00 8b07 	vmla.f64	d8, d0, d7
100084d4:	ee01 8b06 	vmla.f64	d8, d1, d6
100084d8:	ee02 8b05 	vmla.f64	d8, d2, d5
100084dc:	ee03 8b04 	vmla.f64	d8, d3, d4
100084e0:	ee28 9b0d 	vmul.f64	d9, d8, d13
100084e4:	eebc 9bc9 	vcvt.u32.f64	s18, d9
100084e8:	eeb8 9b49 	vcvt.f64.u32	d9, s18
100084ec:	ee09 8b4c 	vmls.f64	d8, d9, d12
100084f0:	ee08 ab0c 	vmla.f64	d10, d8, d12
100084f4:	eeb0 8b49 	vmov.f64	d8, d9
100084f8:	ee01 8b07 	vmla.f64	d8, d1, d7
100084fc:	ee02 8b06 	vmla.f64	d8, d2, d6
10008500:	ee03 8b05 	vmla.f64	d8, d3, d5
10008504:	ee28 9b0d 	vmul.f64	d9, d8, d13
10008508:	eebc 9bc9 	vcvt.u32.f64	s18, d9
1000850c:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10008510:	ee09 8b4c 	vmls.f64	d8, d9, d12
10008514:	eeb0 bb48 	vmov.f64	d11, d8
10008518:	eeb0 8b49 	vmov.f64	d8, d9
1000851c:	ee02 8b07 	vmla.f64	d8, d2, d7
10008520:	ee03 8b06 	vmla.f64	d8, d3, d6
10008524:	ee28 9b0d 	vmul.f64	d9, d8, d13
10008528:	eebc 9bc9 	vcvt.u32.f64	s18, d9
1000852c:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10008530:	ee09 8b4c 	vmls.f64	d8, d9, d12
10008534:	ee08 bb0c 	vmla.f64	d11, d8, d12
10008538:	ed93 cb04 	vldr	d12, [r3, #16]
1000853c:	ee3b bb0c 	vadd.f64	d11, d11, d12
10008540:	ee3b bb4e 	vsub.f64	d11, d11, d14
10008544:	ed93 cb06 	vldr	d12, [r3, #24]
10008548:	ed93 db08 	vldr	d13, [r3, #32]
1000854c:	ee2b 9b0d 	vmul.f64	d9, d11, d13
10008550:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10008554:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10008558:	ee09 bb4c 	vmls.f64	d11, d9, d12
1000855c:	eeb0 0b4b 	vmov.f64	d0, d11
10008560:	eeb0 1b4a 	vmov.f64	d1, d10
10008564:	b010      	add	sp, #64	@ 0x40
10008566:	ecbd 8b0e 	vpop	{d8-d14}
1000856a:	4770      	bx	lr
1000856c:	30009698 	.word	0x30009698
