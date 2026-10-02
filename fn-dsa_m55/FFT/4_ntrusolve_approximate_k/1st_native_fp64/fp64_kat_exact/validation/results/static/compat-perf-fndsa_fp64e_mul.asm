
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_kat_exact/validation/build/compat-perf/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

100064d0 <fndsa_fp64e_mul>:
100064d0:	eefc 7bc2 	vcvt.u32.f64	s15, d2
100064d4:	ee17 3a90 	vmov	r3, s15
100064d8:	eefc 7bc0 	vcvt.u32.f64	s15, d0
100064dc:	ee17 2a90 	vmov	r2, s15
100064e0:	ed9f 6b5b 	vldr	d6, [pc, #364]	@ 10006650 <fndsa_fp64e_mul+0x180>
100064e4:	0fd2      	lsrs	r2, r2, #31
100064e6:	ed2d 8b10 	vpush	{d8-d15}
100064ea:	ee07 2a90 	vmov	s15, r2
100064ee:	eeb0 eb41 	vmov.f64	d14, d1
100064f2:	eeb0 db43 	vmov.f64	d13, d3
100064f6:	ee21 1b06 	vmul.f64	d1, d1, d6
100064fa:	ee23 3b06 	vmul.f64	d3, d3, d6
100064fe:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10006502:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10006506:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000650a:	b094      	sub	sp, #80	@ 0x50
1000650c:	0fdb      	lsrs	r3, r3, #31
1000650e:	ed9f 5b52 	vldr	d5, [pc, #328]	@ 10006658 <fndsa_fp64e_mul+0x188>
10006512:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10006516:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000651a:	ed8d 7b00 	vstr	d7, [sp]
1000651e:	eeb0 ab4e 	vmov.f64	d10, d14
10006522:	ee07 3a90 	vmov	s15, r3
10006526:	eeb0 9b4d 	vmov.f64	d9, d13
1000652a:	ee01 ab45 	vmls.f64	d10, d1, d5
1000652e:	ee03 9b45 	vmls.f64	d9, d3, d5
10006532:	eeb8 4be7 	vcvt.f64.s32	d4, s15
10006536:	ed9f 7b4a 	vldr	d7, [pc, #296]	@ 10006660 <fndsa_fp64e_mul+0x190>
1000653a:	ee0a 7b09 	vmla.f64	d7, d10, d9
1000653e:	ee27 7b06 	vmul.f64	d7, d7, d6
10006542:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006546:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000654a:	ee22 8b06 	vmul.f64	d8, d2, d6
1000654e:	ee0a 7b03 	vmla.f64	d7, d10, d3
10006552:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10006556:	ee01 7b09 	vmla.f64	d7, d1, d9
1000655a:	eeb8 bb48 	vcvt.f64.u32	d11, s16
1000655e:	ee27 7b06 	vmul.f64	d7, d7, d6
10006562:	ed8d 4b02 	vstr	d4, [sp, #8]
10006566:	ee0b 2b45 	vmls.f64	d2, d11, d5
1000656a:	ee20 4b06 	vmul.f64	d4, d0, d6
1000656e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006572:	eeb0 cb42 	vmov.f64	d12, d2
10006576:	eefc 4bc4 	vcvt.u32.f64	s9, d4
1000657a:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000657e:	eeb8 2b64 	vcvt.f64.u32	d2, s9
10006582:	ee0a 7b0c 	vmla.f64	d7, d10, d12
10006586:	ee02 0b45 	vmls.f64	d0, d2, d5
1000658a:	ee01 7b03 	vmla.f64	d7, d1, d3
1000658e:	ee00 7b09 	vmla.f64	d7, d0, d9
10006592:	ee27 8b06 	vmul.f64	d8, d7, d6
10006596:	eebc 8bc8 	vcvt.u32.f64	s16, d8
1000659a:	eeb8 8b48 	vcvt.f64.u32	d8, s16
1000659e:	eeb0 4b48 	vmov.f64	d4, d8
100065a2:	ee0a 4b0b 	vmla.f64	d4, d10, d11
100065a6:	ee01 4b0c 	vmla.f64	d4, d1, d12
100065aa:	ee00 4b03 	vmla.f64	d4, d0, d3
100065ae:	ee02 4b09 	vmla.f64	d4, d2, d9
100065b2:	ee08 7b45 	vmls.f64	d7, d8, d5
100065b6:	ee24 8b06 	vmul.f64	d8, d4, d6
100065ba:	eebc 8bc8 	vcvt.u32.f64	s16, d8
100065be:	eeb8 8b48 	vcvt.f64.u32	d8, s16
100065c2:	eeb0 ab47 	vmov.f64	d10, d7
100065c6:	eeb0 7b48 	vmov.f64	d7, d8
100065ca:	ee01 7b0b 	vmla.f64	d7, d1, d11
100065ce:	ee00 7b0c 	vmla.f64	d7, d0, d12
100065d2:	ee02 7b03 	vmla.f64	d7, d2, d3
100065d6:	ee27 3b06 	vmul.f64	d3, d7, d6
100065da:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100065de:	ee08 4b45 	vmls.f64	d4, d8, d5
100065e2:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100065e6:	eeb0 1b4a 	vmov.f64	d1, d10
100065ea:	ee04 1b05 	vmla.f64	d1, d4, d5
100065ee:	eeb0 4b43 	vmov.f64	d4, d3
100065f2:	ee00 4b0b 	vmla.f64	d4, d0, d11
100065f6:	ee02 4b0c 	vmla.f64	d4, d2, d12
100065fa:	ee24 6b06 	vmul.f64	d6, d4, d6
100065fe:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006602:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006606:	ee03 7b45 	vmls.f64	d7, d3, d5
1000660a:	ee06 4b45 	vmls.f64	d4, d6, d5
1000660e:	ed9f fb16 	vldr	d15, [pc, #88]	@ 10006668 <fndsa_fp64e_mul+0x198>
10006612:	ee04 7b05 	vmla.f64	d7, d4, d5
10006616:	ee37 0b0f 	vadd.f64	d0, d7, d15
1000661a:	ed9d 7b00 	vldr	d7, [sp]
1000661e:	ed9d 4b02 	vldr	d4, [sp, #8]
10006622:	ee07 0b4d 	vmls.f64	d0, d7, d13
10006626:	ed9f 7b12 	vldr	d7, [pc, #72]	@ 10006670 <fndsa_fp64e_mul+0x1a0>
1000662a:	ee04 0b4e 	vmls.f64	d0, d4, d14
1000662e:	ee20 7b07 	vmul.f64	d7, d0, d7
10006632:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006636:	ed9f 6b10 	vldr	d6, [pc, #64]	@ 10006678 <fndsa_fp64e_mul+0x1a8>
1000663a:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000663e:	ee07 0b46 	vmls.f64	d0, d7, d6
10006642:	b014      	add	sp, #80	@ 0x50
10006644:	ecbd 8b10 	vpop	{d8-d15}
10006648:	4770      	bx	lr
1000664a:	bf00      	nop
1000664c:	f3af 8000 	nop.w
10006650:	00000000 	.word	0x00000000
10006654:	3ef00000 	.word	0x3ef00000
10006658:	00000000 	.word	0x00000000
1000665c:	40f00000 	.word	0x40f00000
	...
1000666c:	42000000 	.word	0x42000000
10006670:	00000000 	.word	0x00000000
10006674:	3df00000 	.word	0x3df00000
10006678:	00000000 	.word	0x00000000
1000667c:	41f00000 	.word	0x41f00000
