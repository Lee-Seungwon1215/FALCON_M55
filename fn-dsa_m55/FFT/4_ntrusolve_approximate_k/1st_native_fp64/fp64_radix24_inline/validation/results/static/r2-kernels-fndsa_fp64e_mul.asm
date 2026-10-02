
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/r2-kernels/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10001408 <fndsa_fp64e_mul>:
10001408:	eefc 7bc0 	vcvt.u32.f64	s15, d0
1000140c:	ee17 2a90 	vmov	r2, s15
10001410:	eefc 7bc2 	vcvt.u32.f64	s15, d2
10001414:	0fd2      	lsrs	r2, r2, #31
10001416:	ee17 3a90 	vmov	r3, s15
1000141a:	ee07 2a90 	vmov	s15, r2
1000141e:	ed2d 8b10 	vpush	{d8-d15}
10001422:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10001426:	b094      	sub	sp, #80	@ 0x50
10001428:	0fdb      	lsrs	r3, r3, #31
1000142a:	ed8d 7b00 	vstr	d7, [sp]
1000142e:	ee07 3a90 	vmov	s15, r3
10001432:	eeb0 bb43 	vmov.f64	d11, d3
10001436:	eeb8 4be7 	vcvt.f64.s32	d4, s15
1000143a:	ed9f 3b53 	vldr	d3, [pc, #332]	@ 10001588 <fndsa_fp64e_mul+0x180>
1000143e:	ed9f 6b54 	vldr	d6, [pc, #336]	@ 10001590 <fndsa_fp64e_mul+0x188>
10001442:	ed8d 4b02 	vstr	d4, [sp, #8]
10001446:	ee22 4b03 	vmul.f64	d4, d2, d3
1000144a:	ee20 5b03 	vmul.f64	d5, d0, d3
1000144e:	ee21 9b06 	vmul.f64	d9, d1, d6
10001452:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10001456:	eeb0 cb41 	vmov.f64	d12, d1
1000145a:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000145e:	ed9f 1b4e 	vldr	d1, [pc, #312]	@ 10001598 <fndsa_fp64e_mul+0x190>
10001462:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10001466:	eebc 9bc9 	vcvt.u32.f64	s18, d9
1000146a:	ee2b 7b06 	vmul.f64	d7, d11, d6
1000146e:	ee04 2b41 	vmls.f64	d2, d4, d1
10001472:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10001476:	eeb8 9b49 	vcvt.f64.u32	d9, s18
1000147a:	ee05 0b41 	vmls.f64	d0, d5, d1
1000147e:	ed9f eb48 	vldr	d14, [pc, #288]	@ 100015a0 <fndsa_fp64e_mul+0x198>
10001482:	eeb0 8b42 	vmov.f64	d8, d2
10001486:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000148a:	eeb0 2b49 	vmov.f64	d2, d9
1000148e:	ed9f 3b46 	vldr	d3, [pc, #280]	@ 100015a8 <fndsa_fp64e_mul+0x1a0>
10001492:	ee00 2b0e 	vmla.f64	d2, d0, d14
10001496:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000149a:	eeb0 0b4c 	vmov.f64	d0, d12
1000149e:	ee09 0b43 	vmls.f64	d0, d9, d3
100014a2:	eeb0 9b47 	vmov.f64	d9, d7
100014a6:	ee08 9b0e 	vmla.f64	d9, d8, d14
100014aa:	eeb0 8b4b 	vmov.f64	d8, d11
100014ae:	ee07 8b43 	vmls.f64	d8, d7, d3
100014b2:	ee20 7b08 	vmul.f64	d7, d0, d8
100014b6:	ee20 ab09 	vmul.f64	d10, d0, d9
100014ba:	ee20 fb04 	vmul.f64	d15, d0, d4
100014be:	ee22 db04 	vmul.f64	d13, d2, d4
100014c2:	ee02 ab08 	vmla.f64	d10, d2, d8
100014c6:	ee02 fb09 	vmla.f64	d15, d2, d9
100014ca:	ee05 db09 	vmla.f64	d13, d5, d9
100014ce:	ee05 fb08 	vmla.f64	d15, d5, d8
100014d2:	ee27 7b06 	vmul.f64	d7, d7, d6
100014d6:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100014da:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100014de:	ee37 7b0a 	vadd.f64	d7, d7, d10
100014e2:	ee27 4b06 	vmul.f64	d4, d7, d6
100014e6:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100014ea:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100014ee:	ed9f 5b30 	vldr	d5, [pc, #192]	@ 100015b0 <fndsa_fp64e_mul+0x1a8>
100014f2:	ee3f 2b04 	vadd.f64	d2, d15, d4
100014f6:	ee04 7b43 	vmls.f64	d7, d4, d3
100014fa:	ee27 7b05 	vmul.f64	d7, d7, d5
100014fe:	ee22 5b06 	vmul.f64	d5, d2, d6
10001502:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10001506:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000150a:	ee3d 4b05 	vadd.f64	d4, d13, d5
1000150e:	ee05 2b43 	vmls.f64	d2, d5, d3
10001512:	ed9f 5b1d 	vldr	d5, [pc, #116]	@ 10001588 <fndsa_fp64e_mul+0x180>
10001516:	ee24 6b06 	vmul.f64	d6, d4, d6
1000151a:	ee22 db05 	vmul.f64	d13, d2, d5
1000151e:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10001522:	eebc dbcd 	vcvt.u32.f64	s26, d13
10001526:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000152a:	eeb8 db4d 	vcvt.f64.u32	d13, s26
1000152e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10001532:	ee06 4b43 	vmls.f64	d4, d6, d3
10001536:	ee0d 2b41 	vmls.f64	d2, d13, d1
1000153a:	eeb0 0b4d 	vmov.f64	d0, d13
1000153e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10001542:	ee04 0b0e 	vmla.f64	d0, d4, d14
10001546:	ee02 7b01 	vmla.f64	d7, d2, d1
1000154a:	ed9f 8b1b 	vldr	d8, [pc, #108]	@ 100015b8 <fndsa_fp64e_mul+0x1b0>
1000154e:	eeb0 1b47 	vmov.f64	d1, d7
10001552:	ed9d 7b00 	vldr	d7, [sp]
10001556:	ee30 0b08 	vadd.f64	d0, d0, d8
1000155a:	ed9d 4b02 	vldr	d4, [sp, #8]
1000155e:	ee07 0b4b 	vmls.f64	d0, d7, d11
10001562:	ed9f 9b17 	vldr	d9, [pc, #92]	@ 100015c0 <fndsa_fp64e_mul+0x1b8>
10001566:	ee04 0b4c 	vmls.f64	d0, d4, d12
1000156a:	ee20 9b09 	vmul.f64	d9, d0, d9
1000156e:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10001572:	ed9f 7b15 	vldr	d7, [pc, #84]	@ 100015c8 <fndsa_fp64e_mul+0x1c0>
10001576:	eeb8 9b49 	vcvt.f64.u32	d9, s18
1000157a:	ee09 0b47 	vmls.f64	d0, d9, d7
1000157e:	b014      	add	sp, #80	@ 0x50
10001580:	ecbd 8b10 	vpop	{d8-d15}
10001584:	4770      	bx	lr
10001586:	bf00      	nop
10001588:	00000000 	.word	0x00000000
1000158c:	3ef00000 	.word	0x3ef00000
10001590:	00000000 	.word	0x00000000
10001594:	3e700000 	.word	0x3e700000
10001598:	00000000 	.word	0x00000000
1000159c:	40f00000 	.word	0x40f00000
100015a0:	00000000 	.word	0x00000000
100015a4:	40700000 	.word	0x40700000
100015a8:	00000000 	.word	0x00000000
100015ac:	41700000 	.word	0x41700000
100015b0:	00000000 	.word	0x00000000
100015b4:	3f700000 	.word	0x3f700000
100015b8:	00000000 	.word	0x00000000
100015bc:	42000000 	.word	0x42000000
100015c0:	00000000 	.word	0x00000000
100015c4:	3df00000 	.word	0x3df00000
100015c8:	00000000 	.word	0x00000000
100015cc:	41f00000 	.word	0x41f00000
