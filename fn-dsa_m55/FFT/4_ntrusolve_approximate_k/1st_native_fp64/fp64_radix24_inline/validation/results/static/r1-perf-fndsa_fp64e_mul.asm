
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/r1-perf/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

100064d0 <fndsa_fp64e_mul>:
100064d0:	eefc 7bc0 	vcvt.u32.f64	s15, d0
100064d4:	ee17 2a90 	vmov	r2, s15
100064d8:	eefc 7bc2 	vcvt.u32.f64	s15, d2
100064dc:	0fd2      	lsrs	r2, r2, #31
100064de:	ee17 3a90 	vmov	r3, s15
100064e2:	ee07 2a90 	vmov	s15, r2
100064e6:	ed2d 8b10 	vpush	{d8-d15}
100064ea:	eeb8 7be7 	vcvt.f64.s32	d7, s15
100064ee:	b094      	sub	sp, #80	@ 0x50
100064f0:	0fdb      	lsrs	r3, r3, #31
100064f2:	ed8d 7b00 	vstr	d7, [sp]
100064f6:	ee07 3a90 	vmov	s15, r3
100064fa:	eeb0 bb43 	vmov.f64	d11, d3
100064fe:	eeb8 4be7 	vcvt.f64.s32	d4, s15
10006502:	ed9f 3b53 	vldr	d3, [pc, #332]	@ 10006650 <fndsa_fp64e_mul+0x180>
10006506:	ed9f 6b54 	vldr	d6, [pc, #336]	@ 10006658 <fndsa_fp64e_mul+0x188>
1000650a:	ed8d 4b02 	vstr	d4, [sp, #8]
1000650e:	ee22 4b03 	vmul.f64	d4, d2, d3
10006512:	ee20 5b03 	vmul.f64	d5, d0, d3
10006516:	ee21 9b06 	vmul.f64	d9, d1, d6
1000651a:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000651e:	eeb0 cb41 	vmov.f64	d12, d1
10006522:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10006526:	ed9f 1b4e 	vldr	d1, [pc, #312]	@ 10006660 <fndsa_fp64e_mul+0x190>
1000652a:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000652e:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10006532:	ee2b 7b06 	vmul.f64	d7, d11, d6
10006536:	ee04 2b41 	vmls.f64	d2, d4, d1
1000653a:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000653e:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10006542:	ee05 0b41 	vmls.f64	d0, d5, d1
10006546:	ed9f eb48 	vldr	d14, [pc, #288]	@ 10006668 <fndsa_fp64e_mul+0x198>
1000654a:	eeb0 8b42 	vmov.f64	d8, d2
1000654e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006552:	eeb0 2b49 	vmov.f64	d2, d9
10006556:	ed9f 3b46 	vldr	d3, [pc, #280]	@ 10006670 <fndsa_fp64e_mul+0x1a0>
1000655a:	ee00 2b0e 	vmla.f64	d2, d0, d14
1000655e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006562:	eeb0 0b4c 	vmov.f64	d0, d12
10006566:	ee09 0b43 	vmls.f64	d0, d9, d3
1000656a:	eeb0 9b47 	vmov.f64	d9, d7
1000656e:	ee08 9b0e 	vmla.f64	d9, d8, d14
10006572:	eeb0 8b4b 	vmov.f64	d8, d11
10006576:	ee07 8b43 	vmls.f64	d8, d7, d3
1000657a:	ee20 7b08 	vmul.f64	d7, d0, d8
1000657e:	ee20 ab09 	vmul.f64	d10, d0, d9
10006582:	ee20 fb04 	vmul.f64	d15, d0, d4
10006586:	ee22 db04 	vmul.f64	d13, d2, d4
1000658a:	ee02 ab08 	vmla.f64	d10, d2, d8
1000658e:	ee02 fb09 	vmla.f64	d15, d2, d9
10006592:	ee05 db09 	vmla.f64	d13, d5, d9
10006596:	ee05 fb08 	vmla.f64	d15, d5, d8
1000659a:	ee27 7b06 	vmul.f64	d7, d7, d6
1000659e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100065a2:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100065a6:	ee37 7b0a 	vadd.f64	d7, d7, d10
100065aa:	ee27 4b06 	vmul.f64	d4, d7, d6
100065ae:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100065b2:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100065b6:	ed9f 5b30 	vldr	d5, [pc, #192]	@ 10006678 <fndsa_fp64e_mul+0x1a8>
100065ba:	ee3f 2b04 	vadd.f64	d2, d15, d4
100065be:	ee04 7b43 	vmls.f64	d7, d4, d3
100065c2:	ee27 7b05 	vmul.f64	d7, d7, d5
100065c6:	ee22 5b06 	vmul.f64	d5, d2, d6
100065ca:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100065ce:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100065d2:	ee3d 4b05 	vadd.f64	d4, d13, d5
100065d6:	ee05 2b43 	vmls.f64	d2, d5, d3
100065da:	ed9f 5b1d 	vldr	d5, [pc, #116]	@ 10006650 <fndsa_fp64e_mul+0x180>
100065de:	ee24 6b06 	vmul.f64	d6, d4, d6
100065e2:	ee22 db05 	vmul.f64	d13, d2, d5
100065e6:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100065ea:	eebc dbcd 	vcvt.u32.f64	s26, d13
100065ee:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100065f2:	eeb8 db4d 	vcvt.f64.u32	d13, s26
100065f6:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100065fa:	ee06 4b43 	vmls.f64	d4, d6, d3
100065fe:	ee0d 2b41 	vmls.f64	d2, d13, d1
10006602:	eeb0 0b4d 	vmov.f64	d0, d13
10006606:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000660a:	ee04 0b0e 	vmla.f64	d0, d4, d14
1000660e:	ee02 7b01 	vmla.f64	d7, d2, d1
10006612:	ed9f 8b1b 	vldr	d8, [pc, #108]	@ 10006680 <fndsa_fp64e_mul+0x1b0>
10006616:	eeb0 1b47 	vmov.f64	d1, d7
1000661a:	ed9d 7b00 	vldr	d7, [sp]
1000661e:	ee30 0b08 	vadd.f64	d0, d0, d8
10006622:	ed9d 4b02 	vldr	d4, [sp, #8]
10006626:	ee07 0b4b 	vmls.f64	d0, d7, d11
1000662a:	ed9f 9b17 	vldr	d9, [pc, #92]	@ 10006688 <fndsa_fp64e_mul+0x1b8>
1000662e:	ee04 0b4c 	vmls.f64	d0, d4, d12
10006632:	ee20 9b09 	vmul.f64	d9, d0, d9
10006636:	eebc 9bc9 	vcvt.u32.f64	s18, d9
1000663a:	ed9f 7b15 	vldr	d7, [pc, #84]	@ 10006690 <fndsa_fp64e_mul+0x1c0>
1000663e:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10006642:	ee09 0b47 	vmls.f64	d0, d9, d7
10006646:	b014      	add	sp, #80	@ 0x50
10006648:	ecbd 8b10 	vpop	{d8-d15}
1000664c:	4770      	bx	lr
1000664e:	bf00      	nop
10006650:	00000000 	.word	0x00000000
10006654:	3ef00000 	.word	0x3ef00000
10006658:	00000000 	.word	0x00000000
1000665c:	3e700000 	.word	0x3e700000
10006660:	00000000 	.word	0x00000000
10006664:	40f00000 	.word	0x40f00000
10006668:	00000000 	.word	0x00000000
1000666c:	40700000 	.word	0x40700000
10006670:	00000000 	.word	0x00000000
10006674:	41700000 	.word	0x41700000
10006678:	00000000 	.word	0x00000000
1000667c:	3f700000 	.word	0x3f700000
10006680:	00000000 	.word	0x00000000
10006684:	42000000 	.word	0x42000000
10006688:	00000000 	.word	0x00000000
1000668c:	3df00000 	.word	0x3df00000
10006690:	00000000 	.word	0x00000000
10006694:	41f00000 	.word	0x41f00000
