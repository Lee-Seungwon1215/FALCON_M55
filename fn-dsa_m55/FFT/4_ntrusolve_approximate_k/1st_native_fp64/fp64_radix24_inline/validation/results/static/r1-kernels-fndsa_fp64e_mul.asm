
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/r1-kernels/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10000718 <fndsa_fp64e_mul>:
10000718:	eefc 7bc0 	vcvt.u32.f64	s15, d0
1000071c:	ee17 2a90 	vmov	r2, s15
10000720:	eefc 7bc2 	vcvt.u32.f64	s15, d2
10000724:	0fd2      	lsrs	r2, r2, #31
10000726:	ee17 3a90 	vmov	r3, s15
1000072a:	ee07 2a90 	vmov	s15, r2
1000072e:	ed2d 8b10 	vpush	{d8-d15}
10000732:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10000736:	b094      	sub	sp, #80	@ 0x50
10000738:	0fdb      	lsrs	r3, r3, #31
1000073a:	ed8d 7b00 	vstr	d7, [sp]
1000073e:	ee07 3a90 	vmov	s15, r3
10000742:	eeb0 bb43 	vmov.f64	d11, d3
10000746:	eeb8 4be7 	vcvt.f64.s32	d4, s15
1000074a:	ed9f 3b53 	vldr	d3, [pc, #332]	@ 10000898 <fndsa_fp64e_mul+0x180>
1000074e:	ed9f 6b54 	vldr	d6, [pc, #336]	@ 100008a0 <fndsa_fp64e_mul+0x188>
10000752:	ed8d 4b02 	vstr	d4, [sp, #8]
10000756:	ee22 4b03 	vmul.f64	d4, d2, d3
1000075a:	ee20 5b03 	vmul.f64	d5, d0, d3
1000075e:	ee21 9b06 	vmul.f64	d9, d1, d6
10000762:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10000766:	eeb0 cb41 	vmov.f64	d12, d1
1000076a:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000076e:	ed9f 1b4e 	vldr	d1, [pc, #312]	@ 100008a8 <fndsa_fp64e_mul+0x190>
10000772:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10000776:	eebc 9bc9 	vcvt.u32.f64	s18, d9
1000077a:	ee2b 7b06 	vmul.f64	d7, d11, d6
1000077e:	ee04 2b41 	vmls.f64	d2, d4, d1
10000782:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10000786:	eeb8 9b49 	vcvt.f64.u32	d9, s18
1000078a:	ee05 0b41 	vmls.f64	d0, d5, d1
1000078e:	ed9f eb48 	vldr	d14, [pc, #288]	@ 100008b0 <fndsa_fp64e_mul+0x198>
10000792:	eeb0 8b42 	vmov.f64	d8, d2
10000796:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000079a:	eeb0 2b49 	vmov.f64	d2, d9
1000079e:	ed9f 3b46 	vldr	d3, [pc, #280]	@ 100008b8 <fndsa_fp64e_mul+0x1a0>
100007a2:	ee00 2b0e 	vmla.f64	d2, d0, d14
100007a6:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100007aa:	eeb0 0b4c 	vmov.f64	d0, d12
100007ae:	ee09 0b43 	vmls.f64	d0, d9, d3
100007b2:	eeb0 9b47 	vmov.f64	d9, d7
100007b6:	ee08 9b0e 	vmla.f64	d9, d8, d14
100007ba:	eeb0 8b4b 	vmov.f64	d8, d11
100007be:	ee07 8b43 	vmls.f64	d8, d7, d3
100007c2:	ee20 7b08 	vmul.f64	d7, d0, d8
100007c6:	ee20 ab09 	vmul.f64	d10, d0, d9
100007ca:	ee20 fb04 	vmul.f64	d15, d0, d4
100007ce:	ee22 db04 	vmul.f64	d13, d2, d4
100007d2:	ee02 ab08 	vmla.f64	d10, d2, d8
100007d6:	ee02 fb09 	vmla.f64	d15, d2, d9
100007da:	ee05 db09 	vmla.f64	d13, d5, d9
100007de:	ee05 fb08 	vmla.f64	d15, d5, d8
100007e2:	ee27 7b06 	vmul.f64	d7, d7, d6
100007e6:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100007ea:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100007ee:	ee37 7b0a 	vadd.f64	d7, d7, d10
100007f2:	ee27 4b06 	vmul.f64	d4, d7, d6
100007f6:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100007fa:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100007fe:	ed9f 5b30 	vldr	d5, [pc, #192]	@ 100008c0 <fndsa_fp64e_mul+0x1a8>
10000802:	ee3f 2b04 	vadd.f64	d2, d15, d4
10000806:	ee04 7b43 	vmls.f64	d7, d4, d3
1000080a:	ee27 7b05 	vmul.f64	d7, d7, d5
1000080e:	ee22 5b06 	vmul.f64	d5, d2, d6
10000812:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10000816:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000081a:	ee3d 4b05 	vadd.f64	d4, d13, d5
1000081e:	ee05 2b43 	vmls.f64	d2, d5, d3
10000822:	ed9f 5b1d 	vldr	d5, [pc, #116]	@ 10000898 <fndsa_fp64e_mul+0x180>
10000826:	ee24 6b06 	vmul.f64	d6, d4, d6
1000082a:	ee22 db05 	vmul.f64	d13, d2, d5
1000082e:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10000832:	eebc dbcd 	vcvt.u32.f64	s26, d13
10000836:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000083a:	eeb8 db4d 	vcvt.f64.u32	d13, s26
1000083e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10000842:	ee06 4b43 	vmls.f64	d4, d6, d3
10000846:	ee0d 2b41 	vmls.f64	d2, d13, d1
1000084a:	eeb0 0b4d 	vmov.f64	d0, d13
1000084e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10000852:	ee04 0b0e 	vmla.f64	d0, d4, d14
10000856:	ee02 7b01 	vmla.f64	d7, d2, d1
1000085a:	ed9f 8b1b 	vldr	d8, [pc, #108]	@ 100008c8 <fndsa_fp64e_mul+0x1b0>
1000085e:	eeb0 1b47 	vmov.f64	d1, d7
10000862:	ed9d 7b00 	vldr	d7, [sp]
10000866:	ee30 0b08 	vadd.f64	d0, d0, d8
1000086a:	ed9d 4b02 	vldr	d4, [sp, #8]
1000086e:	ee07 0b4b 	vmls.f64	d0, d7, d11
10000872:	ed9f 9b17 	vldr	d9, [pc, #92]	@ 100008d0 <fndsa_fp64e_mul+0x1b8>
10000876:	ee04 0b4c 	vmls.f64	d0, d4, d12
1000087a:	ee20 9b09 	vmul.f64	d9, d0, d9
1000087e:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10000882:	ed9f 7b15 	vldr	d7, [pc, #84]	@ 100008d8 <fndsa_fp64e_mul+0x1c0>
10000886:	eeb8 9b49 	vcvt.f64.u32	d9, s18
1000088a:	ee09 0b47 	vmls.f64	d0, d9, d7
1000088e:	b014      	add	sp, #80	@ 0x50
10000890:	ecbd 8b10 	vpop	{d8-d15}
10000894:	4770      	bx	lr
10000896:	bf00      	nop
10000898:	00000000 	.word	0x00000000
1000089c:	3ef00000 	.word	0x3ef00000
100008a0:	00000000 	.word	0x00000000
100008a4:	3e700000 	.word	0x3e700000
100008a8:	00000000 	.word	0x00000000
100008ac:	40f00000 	.word	0x40f00000
100008b0:	00000000 	.word	0x00000000
100008b4:	40700000 	.word	0x40700000
100008b8:	00000000 	.word	0x00000000
100008bc:	41700000 	.word	0x41700000
100008c0:	00000000 	.word	0x00000000
100008c4:	3f700000 	.word	0x3f700000
100008c8:	00000000 	.word	0x00000000
100008cc:	42000000 	.word	0x42000000
100008d0:	00000000 	.word	0x00000000
100008d4:	3df00000 	.word	0x3df00000
100008d8:	00000000 	.word	0x00000000
100008dc:	41f00000 	.word	0x41f00000
