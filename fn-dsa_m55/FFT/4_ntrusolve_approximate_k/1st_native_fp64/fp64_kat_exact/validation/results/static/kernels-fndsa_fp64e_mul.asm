
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_kat_exact/validation/build/kernels/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10000718 <fndsa_fp64e_mul>:
10000718:	eefc 7bc2 	vcvt.u32.f64	s15, d2
1000071c:	ee17 3a90 	vmov	r3, s15
10000720:	eefc 7bc0 	vcvt.u32.f64	s15, d0
10000724:	ee17 2a90 	vmov	r2, s15
10000728:	ed9f 6b5b 	vldr	d6, [pc, #364]	@ 10000898 <fndsa_fp64e_mul+0x180>
1000072c:	0fd2      	lsrs	r2, r2, #31
1000072e:	ed2d 8b10 	vpush	{d8-d15}
10000732:	ee07 2a90 	vmov	s15, r2
10000736:	eeb0 eb41 	vmov.f64	d14, d1
1000073a:	eeb0 db43 	vmov.f64	d13, d3
1000073e:	ee21 1b06 	vmul.f64	d1, d1, d6
10000742:	ee23 3b06 	vmul.f64	d3, d3, d6
10000746:	eeb8 7be7 	vcvt.f64.s32	d7, s15
1000074a:	eebc 1bc1 	vcvt.u32.f64	s2, d1
1000074e:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10000752:	b094      	sub	sp, #80	@ 0x50
10000754:	0fdb      	lsrs	r3, r3, #31
10000756:	ed9f 5b52 	vldr	d5, [pc, #328]	@ 100008a0 <fndsa_fp64e_mul+0x188>
1000075a:	eeb8 1b41 	vcvt.f64.u32	d1, s2
1000075e:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10000762:	ed8d 7b00 	vstr	d7, [sp]
10000766:	eeb0 ab4e 	vmov.f64	d10, d14
1000076a:	ee07 3a90 	vmov	s15, r3
1000076e:	eeb0 9b4d 	vmov.f64	d9, d13
10000772:	ee01 ab45 	vmls.f64	d10, d1, d5
10000776:	ee03 9b45 	vmls.f64	d9, d3, d5
1000077a:	eeb8 4be7 	vcvt.f64.s32	d4, s15
1000077e:	ed9f 7b4a 	vldr	d7, [pc, #296]	@ 100008a8 <fndsa_fp64e_mul+0x190>
10000782:	ee0a 7b09 	vmla.f64	d7, d10, d9
10000786:	ee27 7b06 	vmul.f64	d7, d7, d6
1000078a:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000078e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10000792:	ee22 8b06 	vmul.f64	d8, d2, d6
10000796:	ee0a 7b03 	vmla.f64	d7, d10, d3
1000079a:	eebc 8bc8 	vcvt.u32.f64	s16, d8
1000079e:	ee01 7b09 	vmla.f64	d7, d1, d9
100007a2:	eeb8 bb48 	vcvt.f64.u32	d11, s16
100007a6:	ee27 7b06 	vmul.f64	d7, d7, d6
100007aa:	ed8d 4b02 	vstr	d4, [sp, #8]
100007ae:	ee0b 2b45 	vmls.f64	d2, d11, d5
100007b2:	ee20 4b06 	vmul.f64	d4, d0, d6
100007b6:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100007ba:	eeb0 cb42 	vmov.f64	d12, d2
100007be:	eefc 4bc4 	vcvt.u32.f64	s9, d4
100007c2:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100007c6:	eeb8 2b64 	vcvt.f64.u32	d2, s9
100007ca:	ee0a 7b0c 	vmla.f64	d7, d10, d12
100007ce:	ee02 0b45 	vmls.f64	d0, d2, d5
100007d2:	ee01 7b03 	vmla.f64	d7, d1, d3
100007d6:	ee00 7b09 	vmla.f64	d7, d0, d9
100007da:	ee27 8b06 	vmul.f64	d8, d7, d6
100007de:	eebc 8bc8 	vcvt.u32.f64	s16, d8
100007e2:	eeb8 8b48 	vcvt.f64.u32	d8, s16
100007e6:	eeb0 4b48 	vmov.f64	d4, d8
100007ea:	ee0a 4b0b 	vmla.f64	d4, d10, d11
100007ee:	ee01 4b0c 	vmla.f64	d4, d1, d12
100007f2:	ee00 4b03 	vmla.f64	d4, d0, d3
100007f6:	ee02 4b09 	vmla.f64	d4, d2, d9
100007fa:	ee08 7b45 	vmls.f64	d7, d8, d5
100007fe:	ee24 8b06 	vmul.f64	d8, d4, d6
10000802:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10000806:	eeb8 8b48 	vcvt.f64.u32	d8, s16
1000080a:	eeb0 ab47 	vmov.f64	d10, d7
1000080e:	eeb0 7b48 	vmov.f64	d7, d8
10000812:	ee01 7b0b 	vmla.f64	d7, d1, d11
10000816:	ee00 7b0c 	vmla.f64	d7, d0, d12
1000081a:	ee02 7b03 	vmla.f64	d7, d2, d3
1000081e:	ee27 3b06 	vmul.f64	d3, d7, d6
10000822:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10000826:	ee08 4b45 	vmls.f64	d4, d8, d5
1000082a:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000082e:	eeb0 1b4a 	vmov.f64	d1, d10
10000832:	ee04 1b05 	vmla.f64	d1, d4, d5
10000836:	eeb0 4b43 	vmov.f64	d4, d3
1000083a:	ee00 4b0b 	vmla.f64	d4, d0, d11
1000083e:	ee02 4b0c 	vmla.f64	d4, d2, d12
10000842:	ee24 6b06 	vmul.f64	d6, d4, d6
10000846:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000084a:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000084e:	ee03 7b45 	vmls.f64	d7, d3, d5
10000852:	ee06 4b45 	vmls.f64	d4, d6, d5
10000856:	ed9f fb16 	vldr	d15, [pc, #88]	@ 100008b0 <fndsa_fp64e_mul+0x198>
1000085a:	ee04 7b05 	vmla.f64	d7, d4, d5
1000085e:	ee37 0b0f 	vadd.f64	d0, d7, d15
10000862:	ed9d 7b00 	vldr	d7, [sp]
10000866:	ed9d 4b02 	vldr	d4, [sp, #8]
1000086a:	ee07 0b4d 	vmls.f64	d0, d7, d13
1000086e:	ed9f 7b12 	vldr	d7, [pc, #72]	@ 100008b8 <fndsa_fp64e_mul+0x1a0>
10000872:	ee04 0b4e 	vmls.f64	d0, d4, d14
10000876:	ee20 7b07 	vmul.f64	d7, d0, d7
1000087a:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000087e:	ed9f 6b10 	vldr	d6, [pc, #64]	@ 100008c0 <fndsa_fp64e_mul+0x1a8>
10000882:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10000886:	ee07 0b46 	vmls.f64	d0, d7, d6
1000088a:	b014      	add	sp, #80	@ 0x50
1000088c:	ecbd 8b10 	vpop	{d8-d15}
10000890:	4770      	bx	lr
10000892:	bf00      	nop
10000894:	f3af 8000 	nop.w
10000898:	00000000 	.word	0x00000000
1000089c:	3ef00000 	.word	0x3ef00000
100008a0:	00000000 	.word	0x00000000
100008a4:	40f00000 	.word	0x40f00000
	...
100008b4:	42000000 	.word	0x42000000
100008b8:	00000000 	.word	0x00000000
100008bc:	3df00000 	.word	0x3df00000
100008c0:	00000000 	.word	0x00000000
100008c4:	41f00000 	.word	0x41f00000
