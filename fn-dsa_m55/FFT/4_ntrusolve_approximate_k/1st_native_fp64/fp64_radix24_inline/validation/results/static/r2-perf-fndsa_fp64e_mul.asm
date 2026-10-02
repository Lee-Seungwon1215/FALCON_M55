
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/r2-perf/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10006660 <fndsa_fp64e_mul>:
10006660:	eefc 7bc0 	vcvt.u32.f64	s15, d0
10006664:	ee17 2a90 	vmov	r2, s15
10006668:	eefc 7bc2 	vcvt.u32.f64	s15, d2
1000666c:	0fd2      	lsrs	r2, r2, #31
1000666e:	ee17 3a90 	vmov	r3, s15
10006672:	ee07 2a90 	vmov	s15, r2
10006676:	ed2d 8b10 	vpush	{d8-d15}
1000667a:	eeb8 7be7 	vcvt.f64.s32	d7, s15
1000667e:	b094      	sub	sp, #80	@ 0x50
10006680:	0fdb      	lsrs	r3, r3, #31
10006682:	ed8d 7b00 	vstr	d7, [sp]
10006686:	ee07 3a90 	vmov	s15, r3
1000668a:	eeb0 bb43 	vmov.f64	d11, d3
1000668e:	eeb8 4be7 	vcvt.f64.s32	d4, s15
10006692:	ed9f 3b53 	vldr	d3, [pc, #332]	@ 100067e0 <fndsa_fp64e_mul+0x180>
10006696:	ed9f 6b54 	vldr	d6, [pc, #336]	@ 100067e8 <fndsa_fp64e_mul+0x188>
1000669a:	ed8d 4b02 	vstr	d4, [sp, #8]
1000669e:	ee22 4b03 	vmul.f64	d4, d2, d3
100066a2:	ee20 5b03 	vmul.f64	d5, d0, d3
100066a6:	ee21 9b06 	vmul.f64	d9, d1, d6
100066aa:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100066ae:	eeb0 cb41 	vmov.f64	d12, d1
100066b2:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100066b6:	ed9f 1b4e 	vldr	d1, [pc, #312]	@ 100067f0 <fndsa_fp64e_mul+0x190>
100066ba:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100066be:	eebc 9bc9 	vcvt.u32.f64	s18, d9
100066c2:	ee2b 7b06 	vmul.f64	d7, d11, d6
100066c6:	ee04 2b41 	vmls.f64	d2, d4, d1
100066ca:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100066ce:	eeb8 9b49 	vcvt.f64.u32	d9, s18
100066d2:	ee05 0b41 	vmls.f64	d0, d5, d1
100066d6:	ed9f eb48 	vldr	d14, [pc, #288]	@ 100067f8 <fndsa_fp64e_mul+0x198>
100066da:	eeb0 8b42 	vmov.f64	d8, d2
100066de:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100066e2:	eeb0 2b49 	vmov.f64	d2, d9
100066e6:	ed9f 3b46 	vldr	d3, [pc, #280]	@ 10006800 <fndsa_fp64e_mul+0x1a0>
100066ea:	ee00 2b0e 	vmla.f64	d2, d0, d14
100066ee:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100066f2:	eeb0 0b4c 	vmov.f64	d0, d12
100066f6:	ee09 0b43 	vmls.f64	d0, d9, d3
100066fa:	eeb0 9b47 	vmov.f64	d9, d7
100066fe:	ee08 9b0e 	vmla.f64	d9, d8, d14
10006702:	eeb0 8b4b 	vmov.f64	d8, d11
10006706:	ee07 8b43 	vmls.f64	d8, d7, d3
1000670a:	ee20 7b08 	vmul.f64	d7, d0, d8
1000670e:	ee20 ab09 	vmul.f64	d10, d0, d9
10006712:	ee20 fb04 	vmul.f64	d15, d0, d4
10006716:	ee22 db04 	vmul.f64	d13, d2, d4
1000671a:	ee02 ab08 	vmla.f64	d10, d2, d8
1000671e:	ee02 fb09 	vmla.f64	d15, d2, d9
10006722:	ee05 db09 	vmla.f64	d13, d5, d9
10006726:	ee05 fb08 	vmla.f64	d15, d5, d8
1000672a:	ee27 7b06 	vmul.f64	d7, d7, d6
1000672e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006732:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006736:	ee37 7b0a 	vadd.f64	d7, d7, d10
1000673a:	ee27 4b06 	vmul.f64	d4, d7, d6
1000673e:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10006742:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10006746:	ed9f 5b30 	vldr	d5, [pc, #192]	@ 10006808 <fndsa_fp64e_mul+0x1a8>
1000674a:	ee3f 2b04 	vadd.f64	d2, d15, d4
1000674e:	ee04 7b43 	vmls.f64	d7, d4, d3
10006752:	ee27 7b05 	vmul.f64	d7, d7, d5
10006756:	ee22 5b06 	vmul.f64	d5, d2, d6
1000675a:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000675e:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10006762:	ee3d 4b05 	vadd.f64	d4, d13, d5
10006766:	ee05 2b43 	vmls.f64	d2, d5, d3
1000676a:	ed9f 5b1d 	vldr	d5, [pc, #116]	@ 100067e0 <fndsa_fp64e_mul+0x180>
1000676e:	ee24 6b06 	vmul.f64	d6, d4, d6
10006772:	ee22 db05 	vmul.f64	d13, d2, d5
10006776:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000677a:	eebc dbcd 	vcvt.u32.f64	s26, d13
1000677e:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006782:	eeb8 db4d 	vcvt.f64.u32	d13, s26
10006786:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000678a:	ee06 4b43 	vmls.f64	d4, d6, d3
1000678e:	ee0d 2b41 	vmls.f64	d2, d13, d1
10006792:	eeb0 0b4d 	vmov.f64	d0, d13
10006796:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000679a:	ee04 0b0e 	vmla.f64	d0, d4, d14
1000679e:	ee02 7b01 	vmla.f64	d7, d2, d1
100067a2:	ed9f 8b1b 	vldr	d8, [pc, #108]	@ 10006810 <fndsa_fp64e_mul+0x1b0>
100067a6:	eeb0 1b47 	vmov.f64	d1, d7
100067aa:	ed9d 7b00 	vldr	d7, [sp]
100067ae:	ee30 0b08 	vadd.f64	d0, d0, d8
100067b2:	ed9d 4b02 	vldr	d4, [sp, #8]
100067b6:	ee07 0b4b 	vmls.f64	d0, d7, d11
100067ba:	ed9f 9b17 	vldr	d9, [pc, #92]	@ 10006818 <fndsa_fp64e_mul+0x1b8>
100067be:	ee04 0b4c 	vmls.f64	d0, d4, d12
100067c2:	ee20 9b09 	vmul.f64	d9, d0, d9
100067c6:	eebc 9bc9 	vcvt.u32.f64	s18, d9
100067ca:	ed9f 7b15 	vldr	d7, [pc, #84]	@ 10006820 <fndsa_fp64e_mul+0x1c0>
100067ce:	eeb8 9b49 	vcvt.f64.u32	d9, s18
100067d2:	ee09 0b47 	vmls.f64	d0, d9, d7
100067d6:	b014      	add	sp, #80	@ 0x50
100067d8:	ecbd 8b10 	vpop	{d8-d15}
100067dc:	4770      	bx	lr
100067de:	bf00      	nop
100067e0:	00000000 	.word	0x00000000
100067e4:	3ef00000 	.word	0x3ef00000
100067e8:	00000000 	.word	0x00000000
100067ec:	3e700000 	.word	0x3e700000
100067f0:	00000000 	.word	0x00000000
100067f4:	40f00000 	.word	0x40f00000
100067f8:	00000000 	.word	0x00000000
100067fc:	40700000 	.word	0x40700000
10006800:	00000000 	.word	0x00000000
10006804:	41700000 	.word	0x41700000
10006808:	00000000 	.word	0x00000000
1000680c:	3f700000 	.word	0x3f700000
10006810:	00000000 	.word	0x00000000
10006814:	42000000 	.word	0x42000000
10006818:	00000000 	.word	0x00000000
1000681c:	3df00000 	.word	0x3df00000
10006820:	00000000 	.word	0x00000000
10006824:	41f00000 	.word	0x41f00000
