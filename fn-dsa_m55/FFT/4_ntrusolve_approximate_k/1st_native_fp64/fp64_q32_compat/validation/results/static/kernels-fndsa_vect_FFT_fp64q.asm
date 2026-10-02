
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_q32_compat/validation/build/kernels/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10000638 <fndsa_vect_FFT_fp64q>:
10000638:	2801      	cmp	r0, #1
1000063a:	f240 82d8 	bls.w	10000bee <fndsa_vect_FFT_fp64q+0x5b6>
1000063e:	2301      	movs	r3, #1
10000640:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10000644:	1e42      	subs	r2, r0, #1
10000646:	ed2d 8b10 	vpush	{d8-d15}
1000064a:	fa03 f502 	lsl.w	r5, r3, r2
1000064e:	ed9f fb3a 	vldr	d15, [pc, #232]	@ 10000738 <fndsa_vect_FFT_fp64q+0x100>
10000652:	ed9f eb3b 	vldr	d14, [pc, #236]	@ 10000740 <fndsa_vect_FFT_fp64q+0x108>
10000656:	469b      	mov	fp, r3
10000658:	46a9      	mov	r9, r5
1000065a:	b0b9      	sub	sp, #228	@ 0xe4
1000065c:	3908      	subs	r1, #8
1000065e:	9123      	str	r1, [sp, #140]	@ 0x8c
10000660:	9524      	str	r5, [sp, #144]	@ 0x90
10000662:	9025      	str	r0, [sp, #148]	@ 0x94
10000664:	2301      	movs	r3, #1
10000666:	2210      	movs	r2, #16
10000668:	46c8      	mov	r8, r9
1000066a:	2700      	movs	r7, #0
1000066c:	4936      	ldr	r1, [pc, #216]	@ (10000748 <fndsa_vect_FFT_fp64q+0x110>)
1000066e:	fa03 f30b 	lsl.w	r3, r3, fp
10000672:	eb03 0353 	add.w	r3, r3, r3, lsr #1
10000676:	eb01 1303 	add.w	r3, r1, r3, lsl #4
1000067a:	931f      	str	r3, [sp, #124]	@ 0x7c
1000067c:	9b24      	ldr	r3, [sp, #144]	@ 0x90
1000067e:	ea4f 0959 	mov.w	r9, r9, lsr #1
10000682:	eba3 0309 	sub.w	r3, r3, r9
10000686:	3301      	adds	r3, #1
10000688:	9321      	str	r3, [sp, #132]	@ 0x84
1000068a:	9b23      	ldr	r3, [sp, #140]	@ 0x8c
1000068c:	fa02 f20b 	lsl.w	r2, r2, fp
10000690:	ea4f 0ac9 	mov.w	sl, r9, lsl #3
10000694:	188d      	adds	r5, r1, r2
10000696:	eb03 0cc9 	add.w	ip, r3, r9, lsl #3
1000069a:	f8cd 9078 	str.w	r9, [sp, #120]	@ 0x78
1000069e:	f8cd b088 	str.w	fp, [sp, #136]	@ 0x88
100006a2:	f8cd a010 	str.w	sl, [sp, #16]
100006a6:	f8cd 8080 	str.w	r8, [sp, #128]	@ 0x80
100006aa:	9b1e      	ldr	r3, [sp, #120]	@ 0x78
100006ac:	ac30      	add	r4, sp, #192	@ 0xc0
100006ae:	eb03 0e07 	add.w	lr, r3, r7
100006b2:	45be      	cmp	lr, r7
100006b4:	e895 000f 	ldmia.w	r5, {r0, r1, r2, r3}
100006b8:	e884 000f 	stmia.w	r4, {r0, r1, r2, r3}
100006bc:	f240 827f 	bls.w	10000bbe <fndsa_vect_FFT_fp64q+0x586>
100006c0:	9a30      	ldr	r2, [sp, #192]	@ 0xc0
100006c2:	9932      	ldr	r1, [sp, #200]	@ 0xc8
100006c4:	ee07 2a90 	vmov	s15, r2
100006c8:	eeb8 ab67 	vcvt.f64.u32	d10, s15
100006cc:	ee07 1a90 	vmov	s15, r1
100006d0:	9c31      	ldr	r4, [sp, #196]	@ 0xc4
100006d2:	eeb8 bb67 	vcvt.f64.u32	d11, s15
100006d6:	ee07 4a90 	vmov	s15, r4
100006da:	9833      	ldr	r0, [sp, #204]	@ 0xcc
100006dc:	eeb8 9b67 	vcvt.f64.u32	d9, s15
100006e0:	ee07 0a90 	vmov	s15, r0
100006e4:	9215      	str	r2, [sp, #84]	@ 0x54
100006e6:	1852      	adds	r2, r2, r1
100006e8:	eeb8 8b67 	vcvt.f64.u32	d8, s15
100006ec:	ee07 2a90 	vmov	s15, r2
100006f0:	9219      	str	r2, [sp, #100]	@ 0x64
100006f2:	eb40 0204 	adc.w	r2, r0, r4
100006f6:	eeb8 db67 	vcvt.f64.u32	d13, s15
100006fa:	ee07 2a90 	vmov	s15, r2
100006fe:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10000702:	9b04      	ldr	r3, [sp, #16]
10000704:	ed8d 7b12 	vstr	d7, [sp, #72]	@ 0x48
10000708:	f1a3 0e08 	sub.w	lr, r3, #8
1000070c:	ea4f 0ede 	mov.w	lr, lr, lsr #3
10000710:	f10e 0e01 	add.w	lr, lr, #1
10000714:	f04e e001 	dls	lr, lr
10000718:	ebac 0b03 	sub.w	fp, ip, r3
1000071c:	e9cd 7c1b 	strd	r7, ip, [sp, #108]	@ 0x6c
10000720:	9b21      	ldr	r3, [sp, #132]	@ 0x84
10000722:	9117      	str	r1, [sp, #92]	@ 0x5c
10000724:	9416      	str	r4, [sp, #88]	@ 0x58
10000726:	9018      	str	r0, [sp, #96]	@ 0x60
10000728:	921a      	str	r2, [sp, #104]	@ 0x68
1000072a:	951d      	str	r5, [sp, #116]	@ 0x74
1000072c:	eb0c 0ac3 	add.w	sl, ip, r3, lsl #3
10000730:	e00c      	b.n	1000074c <fndsa_vect_FFT_fp64q+0x114>
10000732:	bf00      	nop
10000734:	f3af 8000 	nop.w
10000738:	00000000 	.word	0x00000000
1000073c:	3df00000 	.word	0x3df00000
10000740:	00000000 	.word	0x00000000
10000744:	41f00000 	.word	0x41f00000
10000748:	300009a0 	.word	0x300009a0
1000074c:	f85b 3f08 	ldr.w	r3, [fp, #8]!
10000750:	9a04      	ldr	r2, [sp, #16]
10000752:	930b      	str	r3, [sp, #44]	@ 0x2c
10000754:	eb0b 0002 	add.w	r0, fp, r2
10000758:	6803      	ldr	r3, [r0, #0]
1000075a:	6847      	ldr	r7, [r0, #4]
1000075c:	4699      	mov	r9, r3
1000075e:	ee07 9a90 	vmov	s15, r9
10000762:	eeb8 4b67 	vcvt.f64.u32	d4, s15
10000766:	ee07 7a90 	vmov	s15, r7
1000076a:	eb0a 0102 	add.w	r1, sl, r2
1000076e:	9334      	str	r3, [sp, #208]	@ 0xd0
10000770:	680b      	ldr	r3, [r1, #0]
10000772:	eeb8 0b67 	vcvt.f64.u32	d0, s15
10000776:	ee07 3a90 	vmov	s15, r3
1000077a:	684e      	ldr	r6, [r1, #4]
1000077c:	ee2a 1b04 	vmul.f64	d1, d10, d4
10000780:	eeb8 5b67 	vcvt.f64.u32	d5, s15
10000784:	ee07 6a90 	vmov	s15, r6
10000788:	eeb8 3b67 	vcvt.f64.u32	d3, s15
1000078c:	ee21 7b0f 	vmul.f64	d7, d1, d15
10000790:	eefc 2bc7 	vcvt.u32.f64	s5, d7
10000794:	ee2b cb05 	vmul.f64	d12, d11, d5
10000798:	ee28 7b05 	vmul.f64	d7, d8, d5
1000079c:	eeb8 5b62 	vcvt.f64.u32	d5, s5
100007a0:	ee20 0b0a 	vmul.f64	d0, d0, d10
100007a4:	ee29 6b04 	vmul.f64	d6, d9, d4
100007a8:	ed8d 7b0c 	vstr	d7, [sp, #48]	@ 0x30
100007ac:	ee25 7b0e 	vmul.f64	d7, d5, d14
100007b0:	ee20 4b0f 	vmul.f64	d4, d0, d15
100007b4:	eeb0 5b47 	vmov.f64	d5, d7
100007b8:	ed8d 6b02 	vstr	d6, [sp, #8]
100007bc:	ee2c 7b0f 	vmul.f64	d7, d12, d15
100007c0:	ee26 6b0f 	vmul.f64	d6, d6, d15
100007c4:	4698      	mov	r8, r3
100007c6:	eefc 6bc6 	vcvt.u32.f64	s13, d6
100007ca:	eebc 6bc4 	vcvt.u32.f64	s12, d4
100007ce:	eefc 4bc7 	vcvt.u32.f64	s9, d7
100007d2:	9c16      	ldr	r4, [sp, #88]	@ 0x58
100007d4:	9007      	str	r0, [sp, #28]
100007d6:	fb09 f004 	mul.w	r0, r9, r4
100007da:	9601      	str	r6, [sp, #4]
100007dc:	9106      	str	r1, [sp, #24]
100007de:	9008      	str	r0, [sp, #32]
100007e0:	9901      	ldr	r1, [sp, #4]
100007e2:	9817      	ldr	r0, [sp, #92]	@ 0x5c
100007e4:	9637      	str	r6, [sp, #220]	@ 0xdc
100007e6:	fb01 f100 	mul.w	r1, r1, r0
100007ea:	fb08 f500 	mul.w	r5, r8, r0
100007ee:	fb07 f604 	mul.w	r6, r7, r4
100007f2:	910f      	str	r1, [sp, #60]	@ 0x3c
100007f4:	9918      	ldr	r1, [sp, #96]	@ 0x60
100007f6:	9510      	str	r5, [sp, #64]	@ 0x40
100007f8:	fb08 f501 	mul.w	r5, r8, r1
100007fc:	ea09 74e4 	and.w	r4, r9, r4, asr #31
10000800:	1b34      	subs	r4, r6, r4
10000802:	9e01      	ldr	r6, [sp, #4]
10000804:	950e      	str	r5, [sp, #56]	@ 0x38
10000806:	fb06 f501 	mul.w	r5, r6, r1
1000080a:	9336      	str	r3, [sp, #216]	@ 0xd8
1000080c:	9b15      	ldr	r3, [sp, #84]	@ 0x54
1000080e:	9511      	str	r5, [sp, #68]	@ 0x44
10000810:	ea03 75e7 	and.w	r5, r3, r7, asr #31
10000814:	fb07 f203 	mul.w	r2, r7, r3
10000818:	fb09 fc03 	mul.w	ip, r9, r3
1000081c:	1b63      	subs	r3, r4, r5
1000081e:	ea08 75e1 	and.w	r5, r8, r1, asr #31
10000822:	ea00 74e6 	and.w	r4, r0, r6, asr #31
10000826:	192c      	adds	r4, r5, r4
10000828:	f8da 0000 	ldr.w	r0, [sl]
1000082c:	9405      	str	r4, [sp, #20]
1000082e:	f8db 4004 	ldr.w	r4, [fp, #4]
10000832:	9735      	str	r7, [sp, #212]	@ 0xd4
10000834:	9414      	str	r4, [sp, #80]	@ 0x50
10000836:	9009      	str	r0, [sp, #36]	@ 0x24
10000838:	f8da 5004 	ldr.w	r5, [sl, #4]
1000083c:	ee11 0a10 	vmov	r0, s2
10000840:	ee15 1a10 	vmov	r1, s10
10000844:	950a      	str	r5, [sp, #40]	@ 0x28
10000846:	ee15 5a90 	vmov	r5, s11
1000084a:	eeb8 5b64 	vcvt.f64.u32	d5, s9
1000084e:	ea81 0400 	eor.w	r4, r1, r0
10000852:	ee25 7b0e 	vmul.f64	d7, d5, d14
10000856:	ee11 0a90 	vmov	r0, s3
1000085a:	eeb0 5b47 	vmov.f64	d5, d7
1000085e:	4045      	eors	r5, r0
10000860:	ee12 0a90 	vmov	r0, s5
10000864:	4325      	orrs	r5, r4
10000866:	426c      	negs	r4, r5
10000868:	432c      	orrs	r4, r5
1000086a:	0fe4      	lsrs	r4, r4, #31
1000086c:	9429      	str	r4, [sp, #164]	@ 0xa4
1000086e:	9c29      	ldr	r4, [sp, #164]	@ 0xa4
10000870:	ee15 1a10 	vmov	r1, s10
10000874:	f084 0401 	eor.w	r4, r4, #1
10000878:	ea04 74dc 	and.w	r4, r4, ip, lsr #31
1000087c:	1b04      	subs	r4, r0, r4
1000087e:	ee1c 0a10 	vmov	r0, s24
10000882:	ee23 3b0b 	vmul.f64	d3, d3, d11
10000886:	eb14 0c02 	adds.w	ip, r4, r2
1000088a:	ea81 0400 	eor.w	r4, r1, r0
1000088e:	ee1c 0a90 	vmov	r0, s25
10000892:	ed9d cb0c 	vldr	d12, [sp, #48]	@ 0x30
10000896:	ee23 7b0f 	vmul.f64	d7, d3, d15
1000089a:	ee15 5a90 	vmov	r5, s11
1000089e:	ee2c 5b0f 	vmul.f64	d5, d12, d15
100008a2:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100008a6:	eefc 7bc5 	vcvt.u32.f64	s15, d5
100008aa:	eeb8 5b67 	vcvt.f64.u32	d5, s15
100008ae:	ee25 2b0e 	vmul.f64	d2, d5, d14
100008b2:	ee1c 1a10 	vmov	r1, s24
100008b6:	ea85 0500 	eor.w	r5, r5, r0
100008ba:	ee12 0a10 	vmov	r0, s4
100008be:	eeb8 5b46 	vcvt.f64.u32	d5, s12
100008c2:	ea45 0504 	orr.w	r5, r5, r4
100008c6:	f1c5 0400 	rsb	r4, r5, #0
100008ca:	ea80 0001 	eor.w	r0, r0, r1
100008ce:	ea44 0405 	orr.w	r4, r4, r5
100008d2:	ee12 1a90 	vmov	r1, s5
100008d6:	ee1c 5a90 	vmov	r5, s25
100008da:	ee25 1b0e 	vmul.f64	d1, d5, d14
100008de:	ea81 0105 	eor.w	r1, r1, r5
100008e2:	ea41 0100 	orr.w	r1, r1, r0
100008e6:	f1c1 0000 	rsb	r0, r1, #0
100008ea:	ee11 6a10 	vmov	r6, s2
100008ee:	ea40 0001 	orr.w	r0, r0, r1
100008f2:	ee10 1a10 	vmov	r1, s0
100008f6:	ee11 5a90 	vmov	r5, s3
100008fa:	ea86 0101 	eor.w	r1, r6, r1
100008fe:	ee10 6a90 	vmov	r6, s1
10000902:	eeb8 5b66 	vcvt.f64.u32	d5, s13
10000906:	ea85 0506 	eor.w	r5, r5, r6
1000090a:	ee16 6a10 	vmov	r6, s12
1000090e:	ed9d 1b02 	vldr	d1, [sp, #8]
10000912:	ee25 2b0e 	vmul.f64	d2, d5, d14
10000916:	ea45 0501 	orr.w	r5, r5, r1
1000091a:	f1c5 0100 	rsb	r1, r5, #0
1000091e:	ea41 0105 	orr.w	r1, r1, r5
10000922:	ea4f 71d1 	mov.w	r1, r1, lsr #31
10000926:	9128      	str	r1, [sp, #160]	@ 0xa0
10000928:	9d28      	ldr	r5, [sp, #160]	@ 0xa0
1000092a:	eeb8 5b47 	vcvt.f64.u32	d5, s14
1000092e:	f085 0501 	eor.w	r5, r5, #1
10000932:	ea05 75d2 	and.w	r5, r5, r2, lsr #31
10000936:	eba6 0505 	sub.w	r5, r6, r5
1000093a:	eb45 0503 	adc.w	r5, r5, r3
1000093e:	9b08      	ldr	r3, [sp, #32]
10000940:	ee11 6a10 	vmov	r6, s2
10000944:	eb1c 0c03 	adds.w	ip, ip, r3
10000948:	ee12 3a10 	vmov	r3, s4
1000094c:	ea83 0206 	eor.w	r2, r3, r6
10000950:	ee11 6a90 	vmov	r6, s3
10000954:	ee12 3a90 	vmov	r3, s5
10000958:	ea83 0306 	eor.w	r3, r3, r6
1000095c:	ee16 6a90 	vmov	r6, s13
10000960:	ea42 0203 	orr.w	r2, r2, r3
10000964:	f1c2 0300 	rsb	r3, r2, #0
10000968:	ea43 0302 	orr.w	r3, r3, r2
1000096c:	ea4f 73d3 	mov.w	r3, r3, lsr #31
10000970:	9327      	str	r3, [sp, #156]	@ 0x9c
10000972:	9927      	ldr	r1, [sp, #156]	@ 0x9c
10000974:	9b08      	ldr	r3, [sp, #32]
10000976:	f081 0101 	eor.w	r1, r1, #1
1000097a:	ea01 71d3 	and.w	r1, r1, r3, lsr #31
1000097e:	ee25 5b0e 	vmul.f64	d5, d5, d14
10000982:	eba6 0101 	sub.w	r1, r6, r1
10000986:	ee14 6a90 	vmov	r6, s9
1000098a:	ea4f 74d4 	mov.w	r4, r4, lsr #31
1000098e:	942c      	str	r4, [sp, #176]	@ 0xb0
10000990:	9b2c      	ldr	r3, [sp, #176]	@ 0xb0
10000992:	9a10      	ldr	r2, [sp, #64]	@ 0x40
10000994:	9c05      	ldr	r4, [sp, #20]
10000996:	eb41 0105 	adc.w	r1, r1, r5
1000099a:	f083 0301 	eor.w	r3, r3, #1
1000099e:	ea03 73d2 	and.w	r3, r3, r2, lsr #31
100009a2:	190a      	adds	r2, r1, r4
100009a4:	1af3      	subs	r3, r6, r3
100009a6:	9208      	str	r2, [sp, #32]
100009a8:	ee15 6a10 	vmov	r6, s10
100009ac:	ee13 2a10 	vmov	r2, s6
100009b0:	ee15 4a90 	vmov	r4, s11
100009b4:	4072      	eors	r2, r6
100009b6:	ee13 6a90 	vmov	r6, s7
100009ba:	4074      	eors	r4, r6
100009bc:	ee17 6a10 	vmov	r6, s14
100009c0:	4314      	orrs	r4, r2
100009c2:	4262      	negs	r2, r4
100009c4:	4322      	orrs	r2, r4
100009c6:	0fd2      	lsrs	r2, r2, #31
100009c8:	922b      	str	r2, [sp, #172]	@ 0xac
100009ca:	9a2b      	ldr	r2, [sp, #172]	@ 0xac
100009cc:	9d0f      	ldr	r5, [sp, #60]	@ 0x3c
100009ce:	f082 0201 	eor.w	r2, r2, #1
100009d2:	ea02 72d5 	and.w	r2, r2, r5, lsr #31
100009d6:	1ab2      	subs	r2, r6, r2
100009d8:	ee17 6a90 	vmov	r6, s15
100009dc:	0fc0      	lsrs	r0, r0, #31
100009de:	195b      	adds	r3, r3, r5
100009e0:	902a      	str	r0, [sp, #168]	@ 0xa8
100009e2:	9d11      	ldr	r5, [sp, #68]	@ 0x44
100009e4:	9c2a      	ldr	r4, [sp, #168]	@ 0xa8
100009e6:	eb45 0202 	adc.w	r2, r5, r2
100009ea:	9d0e      	ldr	r5, [sp, #56]	@ 0x38
100009ec:	f084 0401 	eor.w	r4, r4, #1
100009f0:	ea04 74d5 	and.w	r4, r4, r5, lsr #31
100009f4:	195b      	adds	r3, r3, r5
100009f6:	eba6 0404 	sub.w	r4, r6, r4
100009fa:	eb44 0502 	adc.w	r5, r4, r2
100009fe:	eb13 000c 	adds.w	r0, r3, ip
10000a02:	eb45 0101 	adc.w	r1, r5, r1
10000a06:	9502      	str	r5, [sp, #8]
10000a08:	eb18 0509 	adds.w	r5, r8, r9
10000a0c:	ee07 5a90 	vmov	s15, r5
10000a10:	eeb8 5b67 	vcvt.f64.u32	d5, s15
10000a14:	9e01      	ldr	r6, [sp, #4]
10000a16:	ee2d 3b05 	vmul.f64	d3, d13, d5
10000a1a:	eb47 0206 	adc.w	r2, r7, r6
10000a1e:	ee07 2a90 	vmov	s15, r2
10000a22:	ee23 2b0f 	vmul.f64	d2, d3, d15
10000a26:	eeb8 4b67 	vcvt.f64.u32	d4, s15
10000a2a:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10000a2e:	ee24 4b0d 	vmul.f64	d4, d4, d13
10000a32:	9f19      	ldr	r7, [sp, #100]	@ 0x64
10000a34:	ee24 6b0f 	vmul.f64	d6, d4, d15
10000a38:	fb05 f607 	mul.w	r6, r5, r7
10000a3c:	960c      	str	r6, [sp, #48]	@ 0x30
10000a3e:	9e1a      	ldr	r6, [sp, #104]	@ 0x68
10000a40:	eeb8 0b42 	vcvt.f64.u32	d0, s4
10000a44:	fb05 f406 	mul.w	r4, r5, r6
10000a48:	fb02 f906 	mul.w	r9, r2, r6
10000a4c:	ea05 75e6 	and.w	r5, r5, r6, asr #31
10000a50:	9e05      	ldr	r6, [sp, #20]
10000a52:	fb02 f807 	mul.w	r8, r2, r7
10000a56:	ea07 72e2 	and.w	r2, r7, r2, asr #31
10000a5a:	4415      	add	r5, r2
10000a5c:	1b8e      	subs	r6, r1, r6
10000a5e:	9501      	str	r5, [sp, #4]
10000a60:	960e      	str	r6, [sp, #56]	@ 0x38
10000a62:	ed9d 7b12 	vldr	d7, [sp, #72]	@ 0x48
10000a66:	eefc 2bc6 	vcvt.u32.f64	s5, d6
10000a6a:	ee20 1b0e 	vmul.f64	d1, d0, d14
10000a6e:	ee27 5b05 	vmul.f64	d5, d7, d5
10000a72:	ec57 6b11 	vmov	r6, r7, d1
10000a76:	ee13 5a10 	vmov	r5, s6
10000a7a:	eeb8 6b62 	vcvt.f64.u32	d6, s5
10000a7e:	ee25 cb0f 	vmul.f64	d12, d5, d15
10000a82:	ea86 0205 	eor.w	r2, r6, r5
10000a86:	ee26 6b0e 	vmul.f64	d6, d6, d14
10000a8a:	ee13 5a90 	vmov	r5, s7
10000a8e:	eebc cbcc 	vcvt.u32.f64	s24, d12
10000a92:	ee14 6a10 	vmov	r6, s8
10000a96:	406f      	eors	r7, r5
10000a98:	ee16 5a10 	vmov	r5, s12
10000a9c:	eeb8 7b4c 	vcvt.f64.u32	d7, s24
10000aa0:	4317      	orrs	r7, r2
10000aa2:	ea85 0206 	eor.w	r2, r5, r6
10000aa6:	ee14 5a90 	vmov	r5, s9
10000aaa:	ee16 6a90 	vmov	r6, s13
10000aae:	ee27 7b0e 	vmul.f64	d7, d7, d14
10000ab2:	406e      	eors	r6, r5
10000ab4:	4316      	orrs	r6, r2
10000ab6:	427a      	negs	r2, r7
10000ab8:	433a      	orrs	r2, r7
10000aba:	0fd2      	lsrs	r2, r2, #31
10000abc:	922f      	str	r2, [sp, #188]	@ 0xbc
10000abe:	ee17 5a10 	vmov	r5, s14
10000ac2:	ee15 2a10 	vmov	r2, s10
10000ac6:	ea85 0702 	eor.w	r7, r5, r2
10000aca:	ee15 5a90 	vmov	r5, s11
10000ace:	ee17 2a90 	vmov	r2, s15
10000ad2:	406a      	eors	r2, r5
10000ad4:	ee12 5a10 	vmov	r5, s4
10000ad8:	433a      	orrs	r2, r7
10000ada:	4277      	negs	r7, r6
10000adc:	4337      	orrs	r7, r6
10000ade:	4256      	negs	r6, r2
10000ae0:	0fff      	lsrs	r7, r7, #31
10000ae2:	4316      	orrs	r6, r2
10000ae4:	9a2f      	ldr	r2, [sp, #188]	@ 0xbc
10000ae6:	972e      	str	r7, [sp, #184]	@ 0xb8
10000ae8:	9f0c      	ldr	r7, [sp, #48]	@ 0x30
10000aea:	f082 0201 	eor.w	r2, r2, #1
10000aee:	ea02 72d7 	and.w	r2, r2, r7, lsr #31
10000af2:	1aaa      	subs	r2, r5, r2
10000af4:	ee12 5a90 	vmov	r5, s5
10000af8:	9f2e      	ldr	r7, [sp, #184]	@ 0xb8
10000afa:	0ff6      	lsrs	r6, r6, #31
10000afc:	f087 0701 	eor.w	r7, r7, #1
10000b00:	ea07 77d8 	and.w	r7, r7, r8, lsr #31
10000b04:	1bef      	subs	r7, r5, r7
10000b06:	ee1c 5a10 	vmov	r5, s24
10000b0a:	962d      	str	r6, [sp, #180]	@ 0xb4
10000b0c:	9e2d      	ldr	r6, [sp, #180]	@ 0xb4
10000b0e:	eb12 0208 	adds.w	r2, r2, r8
10000b12:	f086 0601 	eor.w	r6, r6, #1
10000b16:	ea06 76d4 	and.w	r6, r6, r4, lsr #31
10000b1a:	eb49 0707 	adc.w	r7, r9, r7
10000b1e:	1bae      	subs	r6, r5, r6
10000b20:	1912      	adds	r2, r2, r4
10000b22:	eb46 0607 	adc.w	r6, r6, r7
10000b26:	9c08      	ldr	r4, [sp, #32]
10000b28:	9d02      	ldr	r5, [sp, #8]
10000b2a:	f11c 0c00 	adds.w	ip, ip, #0
10000b2e:	ebbc 0703 	subs.w	r7, ip, r3
10000b32:	eb64 0805 	sbc.w	r8, r4, r5
10000b36:	9c0b      	ldr	r4, [sp, #44]	@ 0x2c
10000b38:	9d14      	ldr	r5, [sp, #80]	@ 0x50
10000b3a:	193f      	adds	r7, r7, r4
10000b3c:	f8cb 7000 	str.w	r7, [fp]
10000b40:	9c05      	ldr	r4, [sp, #20]
10000b42:	eb45 0708 	adc.w	r7, r5, r8
10000b46:	f8cb 7004 	str.w	r7, [fp, #4]
10000b4a:	4247      	negs	r7, r0
10000b4c:	eb64 0101 	sbc.w	r1, r4, r1
10000b50:	9c01      	ldr	r4, [sp, #4]
10000b52:	19d7      	adds	r7, r2, r7
10000b54:	eba6 0804 	sub.w	r8, r6, r4
10000b58:	9c09      	ldr	r4, [sp, #36]	@ 0x24
10000b5a:	eb48 0801 	adc.w	r8, r8, r1
10000b5e:	193f      	adds	r7, r7, r4
10000b60:	f8ca 7000 	str.w	r7, [sl]
10000b64:	9f0a      	ldr	r7, [sp, #40]	@ 0x28
10000b66:	9c08      	ldr	r4, [sp, #32]
10000b68:	eb47 0108 	adc.w	r1, r7, r8
10000b6c:	9f02      	ldr	r7, [sp, #8]
10000b6e:	ebb3 030c 	subs.w	r3, r3, ip
10000b72:	eb67 0404 	sbc.w	r4, r7, r4
10000b76:	9f0b      	ldr	r7, [sp, #44]	@ 0x2c
10000b78:	f8ca 1004 	str.w	r1, [sl, #4]
10000b7c:	19db      	adds	r3, r3, r7
10000b7e:	9f0e      	ldr	r7, [sp, #56]	@ 0x38
10000b80:	eb45 0404 	adc.w	r4, r5, r4
10000b84:	9d01      	ldr	r5, [sp, #4]
10000b86:	1a80      	subs	r0, r0, r2
10000b88:	eb67 0206 	sbc.w	r2, r7, r6
10000b8c:	4415      	add	r5, r2
10000b8e:	9a04      	ldr	r2, [sp, #16]
10000b90:	3000      	adds	r0, #0
10000b92:	f84b 3002 	str.w	r3, [fp, r2]
10000b96:	9b07      	ldr	r3, [sp, #28]
10000b98:	9f0a      	ldr	r7, [sp, #40]	@ 0x28
10000b9a:	605c      	str	r4, [r3, #4]
10000b9c:	9c09      	ldr	r4, [sp, #36]	@ 0x24
10000b9e:	1900      	adds	r0, r0, r4
10000ba0:	f84a 0002 	str.w	r0, [sl, r2]
10000ba4:	9906      	ldr	r1, [sp, #24]
10000ba6:	eb47 0505 	adc.w	r5, r7, r5
10000baa:	604d      	str	r5, [r1, #4]
10000bac:	f10a 0a08 	add.w	sl, sl, #8
10000bb0:	f1be 0e01 	subs.w	lr, lr, #1
10000bb4:	f47f adca 	bne.w	1000074c <fndsa_vect_FFT_fp64q+0x114>
10000bb8:	e9dd 7c1b 	ldrd	r7, ip, [sp, #108]	@ 0x6c
10000bbc:	9d1d      	ldr	r5, [sp, #116]	@ 0x74
10000bbe:	9b20      	ldr	r3, [sp, #128]	@ 0x80
10000bc0:	3510      	adds	r5, #16
10000bc2:	441f      	add	r7, r3
10000bc4:	eb0c 0cc3 	add.w	ip, ip, r3, lsl #3
10000bc8:	9b1f      	ldr	r3, [sp, #124]	@ 0x7c
10000bca:	42ab      	cmp	r3, r5
10000bcc:	f47f ad6d 	bne.w	100006aa <fndsa_vect_FFT_fp64q+0x72>
10000bd0:	f8dd b088 	ldr.w	fp, [sp, #136]	@ 0x88
10000bd4:	9b25      	ldr	r3, [sp, #148]	@ 0x94
10000bd6:	f10b 0b01 	add.w	fp, fp, #1
10000bda:	455b      	cmp	r3, fp
10000bdc:	f8dd 9078 	ldr.w	r9, [sp, #120]	@ 0x78
10000be0:	f47f ad40 	bne.w	10000664 <fndsa_vect_FFT_fp64q+0x2c>
10000be4:	b039      	add	sp, #228	@ 0xe4
10000be6:	ecbd 8b10 	vpop	{d8-d15}
10000bea:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10000bee:	4770      	bx	lr
