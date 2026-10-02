
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/r2-kernels/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

100004f8 <fndsa_vect_iFFT_fp64_exact.constprop.0>:
100004f8:	1e42      	subs	r2, r0, #1
100004fa:	f000 8340 	beq.w	10000b7e <fndsa_vect_iFFT_fp64_exact.constprop.0+0x686>
100004fe:	2301      	movs	r3, #1
10000500:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10000504:	461f      	mov	r7, r3
10000506:	ed2d 8b10 	vpush	{d8-d15}
1000050a:	2110      	movs	r1, #16
1000050c:	ed9f abf0 	vldr	d10, [pc, #960]	@ 100008d0 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x3d8>
10000510:	ed9f ebf1 	vldr	d14, [pc, #964]	@ 100008d8 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x3e0>
10000514:	ed9f fbf2 	vldr	d15, [pc, #968]	@ 100008e0 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x3e8>
10000518:	46bb      	mov	fp, r7
1000051a:	b0c3      	sub	sp, #268	@ 0x10c
1000051c:	fa03 f402 	lsl.w	r4, r3, r2
10000520:	fa01 f302 	lsl.w	r3, r1, r2
10000524:	9309      	str	r3, [sp, #36]	@ 0x24
10000526:	940b      	str	r4, [sp, #44]	@ 0x2c
10000528:	f04f 0901 	mov.w	r9, #1
1000052c:	2710      	movs	r7, #16
1000052e:	46da      	mov	sl, fp
10000530:	fa0b fb09 	lsl.w	fp, fp, r9
10000534:	ea4f 130b 	mov.w	r3, fp, lsl #4
10000538:	9307      	str	r3, [sp, #28]
1000053a:	4bf7      	ldr	r3, [pc, #988]	@ (10000918 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x420>)
1000053c:	4097      	lsls	r7, r2
1000053e:	441f      	add	r7, r3
10000540:	463e      	mov	r6, r7
10000542:	2700      	movs	r7, #0
10000544:	fa09 f902 	lsl.w	r9, r9, r2
10000548:	eb09 0959 	add.w	r9, r9, r9, lsr #1
1000054c:	eb03 1909 	add.w	r9, r3, r9, lsl #4
10000550:	9b0b      	ldr	r3, [sp, #44]	@ 0x2c
10000552:	49f2      	ldr	r1, [pc, #968]	@ (1000091c <fndsa_vect_iFFT_fp64_exact.constprop.0+0x424>)
10000554:	eba3 030a 	sub.w	r3, r3, sl
10000558:	eb01 180a 	add.w	r8, r1, sl, lsl #4
1000055c:	9308      	str	r3, [sp, #32]
1000055e:	920a      	str	r2, [sp, #40]	@ 0x28
10000560:	edd6 7a02 	vldr	s15, [r6, #8]
10000564:	6873      	ldr	r3, [r6, #4]
10000566:	eeb8 5b67 	vcvt.f64.u32	d5, s15
1000056a:	0fdb      	lsrs	r3, r3, #31
1000056c:	ee03 3a10 	vmov	s6, r3
10000570:	ee3a 5b45 	vsub.f64	d5, d10, d5
10000574:	eeb8 3bc3 	vcvt.f64.s32	d3, s6
10000578:	edd6 7a03 	vldr	s15, [r6, #12]
1000057c:	ed8d 3b2c 	vstr	d3, [sp, #176]	@ 0xb0
10000580:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10000584:	ee25 3b0e 	vmul.f64	d3, d5, d14
10000588:	eeb7 bb00 	vmov.f64	d11, #112	@ 0x3f800000  1.0
1000058c:	edd6 6a00 	vldr	s13, [r6]
10000590:	edd6 4a01 	vldr	s9, [r6, #4]
10000594:	ee3a 7b47 	vsub.f64	d7, d10, d7
10000598:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000059c:	eeb8 6b66 	vcvt.f64.u32	d6, s13
100005a0:	eeb8 4b64 	vcvt.f64.u32	d4, s9
100005a4:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100005a8:	ed9f 0bcf 	vldr	d0, [pc, #828]	@ 100008e8 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x3f0>
100005ac:	ed9f 8bd0 	vldr	d8, [pc, #832]	@ 100008f0 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x3f8>
100005b0:	ee37 7b4b 	vsub.f64	d7, d7, d11
100005b4:	ee03 5b4a 	vmls.f64	d5, d3, d10
100005b8:	ee37 7b03 	vadd.f64	d7, d7, d3
100005bc:	ee24 2b00 	vmul.f64	d2, d4, d0
100005c0:	ee26 3b08 	vmul.f64	d3, d6, d8
100005c4:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100005c8:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100005cc:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100005d0:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100005d4:	ed9f 9bc8 	vldr	d9, [pc, #800]	@ 100008f8 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x400>
100005d8:	eeb0 1b44 	vmov.f64	d1, d4
100005dc:	ed9f cbc8 	vldr	d12, [pc, #800]	@ 10000900 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x408>
100005e0:	ee02 1b49 	vmls.f64	d1, d2, d9
100005e4:	ed8d 2b28 	vstr	d2, [sp, #160]	@ 0xa0
100005e8:	eeb0 2b43 	vmov.f64	d2, d3
100005ec:	ee01 2b0c 	vmla.f64	d2, d1, d12
100005f0:	ed9f dbc5 	vldr	d13, [pc, #788]	@ 10000908 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x410>
100005f4:	ed8d 2b26 	vstr	d2, [sp, #152]	@ 0x98
100005f8:	eeb0 2b46 	vmov.f64	d2, d6
100005fc:	ee03 2b4d 	vmls.f64	d2, d3, d13
10000600:	ee27 3b0e 	vmul.f64	d3, d7, d14
10000604:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10000608:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000060c:	ee03 7b4a 	vmls.f64	d7, d3, d10
10000610:	eebc 3bc7 	vcvt.u32.f64	s6, d7
10000614:	ee13 2a10 	vmov	r2, s6
10000618:	0fd2      	lsrs	r2, r2, #31
1000061a:	ee03 2a10 	vmov	s6, r2
1000061e:	ed8d 6b2a 	vstr	d6, [sp, #168]	@ 0xa8
10000622:	eeb8 3bc3 	vcvt.f64.s32	d3, s6
10000626:	ee36 6b05 	vadd.f64	d6, d6, d5
1000062a:	ed8d 3b36 	vstr	d3, [sp, #216]	@ 0xd8
1000062e:	ee26 3b0e 	vmul.f64	d3, d6, d14
10000632:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10000636:	ee34 4b07 	vadd.f64	d4, d4, d7
1000063a:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000063e:	ee34 4b03 	vadd.f64	d4, d4, d3
10000642:	ee03 6b4a 	vmls.f64	d6, d3, d10
10000646:	ed8d 2b24 	vstr	d2, [sp, #144]	@ 0x90
1000064a:	ee26 3b08 	vmul.f64	d3, d6, d8
1000064e:	ee24 2b0e 	vmul.f64	d2, d4, d14
10000652:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10000656:	eebc 2bc2 	vcvt.u32.f64	s4, d2
1000065a:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000065e:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10000662:	ed8d 6b3e 	vstr	d6, [sp, #248]	@ 0xf8
10000666:	ee02 4b4a 	vmls.f64	d4, d2, d10
1000066a:	ee03 6b4d 	vmls.f64	d6, d3, d13
1000066e:	ed8d 6b38 	vstr	d6, [sp, #224]	@ 0xe0
10000672:	eebc 6bc4 	vcvt.u32.f64	s12, d4
10000676:	ee16 2a10 	vmov	r2, s12
1000067a:	0fd2      	lsrs	r2, r2, #31
1000067c:	ee06 2a10 	vmov	s12, r2
10000680:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10000684:	ed8d 6b40 	vstr	d6, [sp, #256]	@ 0x100
10000688:	ee27 6b00 	vmul.f64	d6, d7, d0
1000068c:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10000690:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10000694:	ee06 7b49 	vmls.f64	d7, d6, d9
10000698:	ed8d 6b32 	vstr	d6, [sp, #200]	@ 0xc8
1000069c:	ee24 6b00 	vmul.f64	d6, d4, d0
100006a0:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100006a4:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100006a8:	ee06 4b49 	vmls.f64	d4, d6, d9
100006ac:	ed8d 6b3c 	vstr	d6, [sp, #240]	@ 0xf0
100006b0:	ee25 6b08 	vmul.f64	d6, d5, d8
100006b4:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100006b8:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100006bc:	ed8d 5b34 	vstr	d5, [sp, #208]	@ 0xd0
100006c0:	ee04 3b0c 	vmla.f64	d3, d4, d12
100006c4:	ee06 5b4d 	vmls.f64	d5, d6, d13
100006c8:	ee07 6b0c 	vmla.f64	d6, d7, d12
100006cc:	eb0a 0307 	add.w	r3, sl, r7
100006d0:	429f      	cmp	r7, r3
100006d2:	ed8d 3b3a 	vstr	d3, [sp, #232]	@ 0xe8
100006d6:	ed8d 5b2e 	vstr	d5, [sp, #184]	@ 0xb8
100006da:	ed8d 6b30 	vstr	d6, [sp, #192]	@ 0xc0
100006de:	f080 823e 	bcs.w	10000b5e <fndsa_vect_iFFT_fp64_exact.constprop.0+0x666>
100006e2:	4645      	mov	r5, r8
100006e4:	4b8d      	ldr	r3, [pc, #564]	@ (1000091c <fndsa_vect_iFFT_fp64_exact.constprop.0+0x424>)
100006e6:	9606      	str	r6, [sp, #24]
100006e8:	eb03 1207 	add.w	r2, r3, r7, lsl #4
100006ec:	9b08      	ldr	r3, [sp, #32]
100006ee:	eb08 1403 	add.w	r4, r8, r3, lsl #4
100006f2:	9b09      	ldr	r3, [sp, #36]	@ 0x24
100006f4:	eb03 0108 	add.w	r1, r3, r8
100006f8:	ed92 3b02 	vldr	d3, [r2, #8]
100006fc:	ed95 4b02 	vldr	d4, [r5, #8]
10000700:	ed91 6b02 	vldr	d6, [r1, #8]
10000704:	ed94 7b02 	vldr	d7, [r4, #8]
10000708:	ee33 1b0a 	vadd.f64	d1, d3, d10
1000070c:	ed92 5b00 	vldr	d5, [r2]
10000710:	ee31 1b44 	vsub.f64	d1, d1, d4
10000714:	ee37 2b0a 	vadd.f64	d2, d7, d10
10000718:	ee36 7b07 	vadd.f64	d7, d6, d7
1000071c:	ed95 0b00 	vldr	d0, [r5]
10000720:	ee33 3b04 	vadd.f64	d3, d3, d4
10000724:	ee32 2b46 	vsub.f64	d2, d2, d6
10000728:	ee21 4b0e 	vmul.f64	d4, d1, d14
1000072c:	ee27 8b0e 	vmul.f64	d8, d7, d14
10000730:	ee35 6b0a 	vadd.f64	d6, d5, d10
10000734:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10000738:	ee36 6b40 	vsub.f64	d6, d6, d0
1000073c:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10000740:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10000744:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10000748:	ee36 6b4b 	vsub.f64	d6, d6, d11
1000074c:	ed94 db00 	vldr	d13, [r4]
10000750:	ee36 6b04 	vadd.f64	d6, d6, d4
10000754:	ee08 7b4a 	vmls.f64	d7, d8, d10
10000758:	ee04 1b4a 	vmls.f64	d1, d4, d10
1000075c:	ee23 4b0e 	vmul.f64	d4, d3, d14
10000760:	ed91 cb00 	vldr	d12, [r1]
10000764:	ee37 9b0b 	vadd.f64	d9, d7, d11
10000768:	ee30 5b05 	vadd.f64	d5, d0, d5
1000076c:	ee3d 7b0a 	vadd.f64	d7, d13, d10
10000770:	ee22 0b0e 	vmul.f64	d0, d2, d14
10000774:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10000778:	ee37 7b4c 	vsub.f64	d7, d7, d12
1000077c:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10000780:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10000784:	ee35 5b04 	vadd.f64	d5, d5, d4
10000788:	eeb8 0b40 	vcvt.f64.u32	d0, s0
1000078c:	ee04 3b4a 	vmls.f64	d3, d4, d10
10000790:	ee37 7b4b 	vsub.f64	d7, d7, d11
10000794:	ee3d 4b0c 	vadd.f64	d4, d13, d12
10000798:	ee37 7b00 	vadd.f64	d7, d7, d0
1000079c:	ee34 4b08 	vadd.f64	d4, d4, d8
100007a0:	ee00 2b4a 	vmls.f64	d2, d0, d10
100007a4:	ee26 8b0e 	vmul.f64	d8, d6, d14
100007a8:	ee25 0b0e 	vmul.f64	d0, d5, d14
100007ac:	eebc 8bc8 	vcvt.u32.f64	s16, d8
100007b0:	eebc 0bc0 	vcvt.u32.f64	s0, d0
100007b4:	eeb8 8b48 	vcvt.f64.u32	d8, s16
100007b8:	eeb8 0b40 	vcvt.f64.u32	d0, s0
100007bc:	ee08 6b4a 	vmls.f64	d6, d8, d10
100007c0:	ee00 5b4a 	vmls.f64	d5, d0, d10
100007c4:	ee24 8b0e 	vmul.f64	d8, d4, d14
100007c8:	ee27 0b0e 	vmul.f64	d0, d7, d14
100007cc:	eebc 8bc8 	vcvt.u32.f64	s16, d8
100007d0:	eebc 0bc0 	vcvt.u32.f64	s0, d0
100007d4:	ee31 1b0b 	vadd.f64	d1, d1, d11
100007d8:	ee33 3b0b 	vadd.f64	d3, d3, d11
100007dc:	eeb8 8b48 	vcvt.f64.u32	d8, s16
100007e0:	eeb8 0b40 	vcvt.f64.u32	d0, s0
100007e4:	ee08 4b4a 	vmls.f64	d4, d8, d10
100007e8:	ee00 7b4a 	vmls.f64	d7, d0, d10
100007ec:	ee21 8b0e 	vmul.f64	d8, d1, d14
100007f0:	ee23 0b0e 	vmul.f64	d0, d3, d14
100007f4:	ed9f cb46 	vldr	d12, [pc, #280]	@ 10000910 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x418>
100007f8:	eebc 8bc8 	vcvt.u32.f64	s16, d8
100007fc:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10000800:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10000804:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10000808:	ee36 6b0c 	vadd.f64	d6, d6, d12
1000080c:	ee08 1b4a 	vmls.f64	d1, d8, d10
10000810:	ee36 6b08 	vadd.f64	d6, d6, d8
10000814:	ee00 3b4a 	vmls.f64	d3, d0, d10
10000818:	eeb6 8b00 	vmov.f64	d8, #96	@ 0x3f000000  0.5
1000081c:	ee23 3b08 	vmul.f64	d3, d3, d8
10000820:	ee32 2b0b 	vadd.f64	d2, d2, d11
10000824:	ee35 5b0c 	vadd.f64	d5, d5, d12
10000828:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000082c:	ee21 1b08 	vmul.f64	d1, d1, d8
10000830:	ee35 5b00 	vadd.f64	d5, d5, d0
10000834:	eeb8 0b43 	vcvt.f64.u32	d0, s6
10000838:	ee22 3b0e 	vmul.f64	d3, d2, d14
1000083c:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10000840:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10000844:	eeb8 db41 	vcvt.f64.u32	d13, s2
10000848:	ee29 1b0e 	vmul.f64	d1, d9, d14
1000084c:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10000850:	ee37 7b0c 	vadd.f64	d7, d7, d12
10000854:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10000858:	ee37 7b03 	vadd.f64	d7, d7, d3
1000085c:	ee03 2b4a 	vmls.f64	d2, d3, d10
10000860:	ee26 3b0e 	vmul.f64	d3, d6, d14
10000864:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10000868:	ee34 4b0c 	vadd.f64	d4, d4, d12
1000086c:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10000870:	ee34 4b01 	vadd.f64	d4, d4, d1
10000874:	ee01 9b4a 	vmls.f64	d9, d1, d10
10000878:	ee25 1b0e 	vmul.f64	d1, d5, d14
1000087c:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10000880:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10000884:	ee03 6b4a 	vmls.f64	d6, d3, d10
10000888:	eeb8 1b41 	vcvt.f64.u32	d1, s2
1000088c:	eefc 6bc6 	vcvt.u32.f64	s13, d6
10000890:	ee01 5b4a 	vmls.f64	d5, d1, d10
10000894:	ee16 ca90 	vmov	ip, s13
10000898:	eefc 6bc5 	vcvt.u32.f64	s13, d5
1000089c:	ea4f 76dc 	mov.w	r6, ip, lsr #31
100008a0:	ee05 6a10 	vmov	s10, r6
100008a4:	ea4f 065c 	mov.w	r6, ip, lsr #1
100008a8:	f00c 0c01 	and.w	ip, ip, #1
100008ac:	ee16 3a90 	vmov	r3, s13
100008b0:	ee03 6a10 	vmov	s6, r6
100008b4:	ee06 ca90 	vmov	s13, ip
100008b8:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
100008bc:	eeb8 6be6 	vcvt.f64.s32	d6, s13
100008c0:	eeb8 3bc3 	vcvt.f64.s32	d3, s6
100008c4:	ea4f 0e53 	mov.w	lr, r3, lsr #1
100008c8:	0fde      	lsrs	r6, r3, #31
100008ca:	ee05 3b0f 	vmla.f64	d3, d5, d15
100008ce:	e027      	b.n	10000920 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x428>
100008d0:	00000000 	.word	0x00000000
100008d4:	41f00000 	.word	0x41f00000
100008d8:	00000000 	.word	0x00000000
100008dc:	3df00000 	.word	0x3df00000
100008e0:	00000000 	.word	0x00000000
100008e4:	41e00000 	.word	0x41e00000
100008e8:	00000000 	.word	0x00000000
100008ec:	3ef00000 	.word	0x3ef00000
100008f0:	00000000 	.word	0x00000000
100008f4:	3e700000 	.word	0x3e700000
100008f8:	00000000 	.word	0x00000000
100008fc:	40f00000 	.word	0x40f00000
10000900:	00000000 	.word	0x00000000
10000904:	40700000 	.word	0x40700000
10000908:	00000000 	.word	0x00000000
1000090c:	41700000 	.word	0x41700000
	...
10000918:	300009a0 	.word	0x300009a0
1000091c:	3001b0e0 	.word	0x3001b0e0
10000920:	ee06 db0f 	vmla.f64	d13, d6, d15
10000924:	ee05 6a10 	vmov	s10, r6
10000928:	ee06 ea90 	vmov	s13, lr
1000092c:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
10000930:	eeb8 6be6 	vcvt.f64.s32	d6, s13
10000934:	ee05 6b0f 	vmla.f64	d6, d5, d15
10000938:	ee24 5b0e 	vmul.f64	d5, d4, d14
1000093c:	f003 0301 	and.w	r3, r3, #1
10000940:	ed82 6b00 	vstr	d6, [r2]
10000944:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10000948:	ee06 3a90 	vmov	s13, r3
1000094c:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10000950:	eeb8 6be6 	vcvt.f64.s32	d6, s13
10000954:	ee05 4b4a 	vmls.f64	d4, d5, d10
10000958:	ee06 0b0f 	vmla.f64	d0, d6, d15
1000095c:	ee27 6b0e 	vmul.f64	d6, d7, d14
10000960:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10000964:	eefc 6bc4 	vcvt.u32.f64	s13, d4
10000968:	ee16 3a90 	vmov	r3, s13
1000096c:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10000970:	ee06 7b4a 	vmls.f64	d7, d6, d10
10000974:	0fde      	lsrs	r6, r3, #31
10000976:	ee05 6a10 	vmov	s10, r6
1000097a:	085e      	lsrs	r6, r3, #1
1000097c:	ee06 6a10 	vmov	s12, r6
10000980:	ee29 9b08 	vmul.f64	d9, d9, d8
10000984:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10000988:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
1000098c:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10000990:	f003 0301 	and.w	r3, r3, #1
10000994:	ee17 ca90 	vmov	ip, s15
10000998:	eebc 9bc9 	vcvt.u32.f64	s18, d9
1000099c:	ee07 3a90 	vmov	s15, r3
100009a0:	ee05 6b0f 	vmla.f64	d6, d5, d15
100009a4:	ee22 2b08 	vmul.f64	d2, d2, d8
100009a8:	eeb8 7be7 	vcvt.f64.s32	d7, s15
100009ac:	eeb8 9b49 	vcvt.f64.u32	d9, s18
100009b0:	ea4f 73dc 	mov.w	r3, ip, lsr #31
100009b4:	ed82 0b02 	vstr	d0, [r2, #8]
100009b8:	ed84 6b00 	vstr	d6, [r4]
100009bc:	ee06 3a10 	vmov	s12, r3
100009c0:	ea4f 035c 	mov.w	r3, ip, lsr #1
100009c4:	ee08 3a10 	vmov	s16, r3
100009c8:	f00c 0301 	and.w	r3, ip, #1
100009cc:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100009d0:	ee07 9b0f 	vmla.f64	d9, d7, d15
100009d4:	ee07 3a10 	vmov	s14, r3
100009d8:	eeb8 cb42 	vcvt.f64.u32	d12, s4
100009dc:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100009e0:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
100009e4:	eeb8 8bc8 	vcvt.f64.s32	d8, s16
100009e8:	ee07 cb0f 	vmla.f64	d12, d7, d15
100009ec:	ee06 8b0f 	vmla.f64	d8, d6, d15
100009f0:	eeb0 0b43 	vmov.f64	d0, d3
100009f4:	eeb0 1b4d 	vmov.f64	d1, d13
100009f8:	ed84 9b02 	vstr	d9, [r4, #8]
100009fc:	a824      	add	r0, sp, #144	@ 0x90
100009fe:	ed8d 3b1c 	vstr	d3, [sp, #112]	@ 0x70
10000a02:	ed8d 3b00 	vstr	d3, [sp]
10000a06:	ed8d db1e 	vstr	d13, [sp, #120]	@ 0x78
10000a0a:	ed8d cb22 	vstr	d12, [sp, #136]	@ 0x88
10000a0e:	ed8d 8b20 	vstr	d8, [sp, #128]	@ 0x80
10000a12:	f7ff fca9 	bl	10000368 <fp64e_mul24_prepared>
10000a16:	a82e      	add	r0, sp, #184	@ 0xb8
10000a18:	eeb0 9b40 	vmov.f64	d9, d0
10000a1c:	ed8d 0b0c 	vstr	d0, [sp, #48]	@ 0x30
10000a20:	ed8d 1b0e 	vstr	d1, [sp, #56]	@ 0x38
10000a24:	eeb0 0b48 	vmov.f64	d0, d8
10000a28:	ed8d 1b04 	vstr	d1, [sp, #16]
10000a2c:	eeb0 1b4c 	vmov.f64	d1, d12
10000a30:	f7ff fc9a 	bl	10000368 <fp64e_mul24_prepared>
10000a34:	eeb0 5b41 	vmov.f64	d5, d1
10000a38:	ee3c 1b0d 	vadd.f64	d1, d12, d13
10000a3c:	ee21 4b0e 	vmul.f64	d4, d1, d14
10000a40:	ed9d 3b00 	vldr	d3, [sp]
10000a44:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10000a48:	eeb0 6b40 	vmov.f64	d6, d0
10000a4c:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10000a50:	ee38 0b03 	vadd.f64	d0, d8, d3
10000a54:	ee30 0b04 	vadd.f64	d0, d0, d4
10000a58:	ee04 1b4a 	vmls.f64	d1, d4, d10
10000a5c:	ee20 4b0e 	vmul.f64	d4, d0, d14
10000a60:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10000a64:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10000a68:	ee04 0b4a 	vmls.f64	d0, d4, d10
10000a6c:	a838      	add	r0, sp, #224	@ 0xe0
10000a6e:	ed8d 6b10 	vstr	d6, [sp, #64]	@ 0x40
10000a72:	ed8d 6b02 	vstr	d6, [sp, #8]
10000a76:	ed8d 5b12 	vstr	d5, [sp, #72]	@ 0x48
10000a7a:	ed8d 5b00 	vstr	d5, [sp]
10000a7e:	ed8d 1b1a 	vstr	d1, [sp, #104]	@ 0x68
10000a82:	ed8d 0b18 	vstr	d0, [sp, #96]	@ 0x60
10000a86:	f7ff fc6f 	bl	10000368 <fp64e_mul24_prepared>
10000a8a:	ed9d 5b00 	vldr	d5, [sp]
10000a8e:	ed9d 7b04 	vldr	d7, [sp, #16]
10000a92:	ee37 4b05 	vadd.f64	d4, d7, d5
10000a96:	ee37 7b0a 	vadd.f64	d7, d7, d10
10000a9a:	ed9d 6b02 	vldr	d6, [sp, #8]
10000a9e:	ee37 7b45 	vsub.f64	d7, d7, d5
10000aa2:	ee24 5b0e 	vmul.f64	d5, d4, d14
10000aa6:	eefc 3bc5 	vcvt.u32.f64	s7, d5
10000aaa:	ee39 5b06 	vadd.f64	d5, d9, d6
10000aae:	ee39 9b0a 	vadd.f64	d9, d9, d10
10000ab2:	ee39 9b46 	vsub.f64	d9, d9, d6
10000ab6:	eeb8 6b63 	vcvt.f64.u32	d6, s7
10000aba:	ee35 5b06 	vadd.f64	d5, d5, d6
10000abe:	ee06 4b4a 	vmls.f64	d4, d6, d10
10000ac2:	ee27 6b0e 	vmul.f64	d6, d7, d14
10000ac6:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10000aca:	ee39 9b4b 	vsub.f64	d9, d9, d11
10000ace:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10000ad2:	ee39 9b06 	vadd.f64	d9, d9, d6
10000ad6:	ee06 7b4a 	vmls.f64	d7, d6, d10
10000ada:	ee25 3b0e 	vmul.f64	d3, d5, d14
10000ade:	ed85 7b02 	vstr	d7, [r5, #8]
10000ae2:	ee29 7b0e 	vmul.f64	d7, d9, d14
10000ae6:	ed8d 1b16 	vstr	d1, [sp, #88]	@ 0x58
10000aea:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10000aee:	ee31 1b0a 	vadd.f64	d1, d1, d10
10000af2:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10000af6:	ee31 4b44 	vsub.f64	d4, d1, d4
10000afa:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10000afe:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10000b02:	ee07 9b4a 	vmls.f64	d9, d7, d10
10000b06:	ed8d 0b14 	vstr	d0, [sp, #80]	@ 0x50
10000b0a:	ee24 7b0e 	vmul.f64	d7, d4, d14
10000b0e:	ee30 0b0a 	vadd.f64	d0, d0, d10
10000b12:	ee03 5b4a 	vmls.f64	d5, d3, d10
10000b16:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10000b1a:	ee30 0b45 	vsub.f64	d0, d0, d5
10000b1e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10000b22:	ee30 0b4b 	vsub.f64	d0, d0, d11
10000b26:	ee30 0b07 	vadd.f64	d0, d0, d7
10000b2a:	ee07 4b4a 	vmls.f64	d4, d7, d10
10000b2e:	ee20 7b0e 	vmul.f64	d7, d0, d14
10000b32:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10000b36:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10000b3a:	ee07 0b4a 	vmls.f64	d0, d7, d10
10000b3e:	3210      	adds	r2, #16
10000b40:	3110      	adds	r1, #16
10000b42:	4590      	cmp	r8, r2
10000b44:	f105 0510 	add.w	r5, r5, #16
10000b48:	ed05 9b04 	vstr	d9, [r5, #-16]
10000b4c:	f104 0410 	add.w	r4, r4, #16
10000b50:	ed01 4b02 	vstr	d4, [r1, #-8]
10000b54:	ed01 0b04 	vstr	d0, [r1, #-16]
10000b58:	f47f adce 	bne.w	100006f8 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x200>
10000b5c:	9e06      	ldr	r6, [sp, #24]
10000b5e:	9b07      	ldr	r3, [sp, #28]
10000b60:	3610      	adds	r6, #16
10000b62:	45b1      	cmp	r9, r6
10000b64:	445f      	add	r7, fp
10000b66:	4498      	add	r8, r3
10000b68:	f47f acfa 	bne.w	10000560 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x68>
10000b6c:	9a0a      	ldr	r2, [sp, #40]	@ 0x28
10000b6e:	3a01      	subs	r2, #1
10000b70:	f47f acda 	bne.w	10000528 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x30>
10000b74:	b043      	add	sp, #268	@ 0x10c
10000b76:	ecbd 8b10 	vpop	{d8-d15}
10000b7a:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10000b7e:	4770      	bx	lr
