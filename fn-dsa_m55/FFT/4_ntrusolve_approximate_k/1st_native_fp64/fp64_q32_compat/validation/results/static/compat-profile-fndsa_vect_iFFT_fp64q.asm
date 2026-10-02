
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_q32_compat/validation/build/compat-profile/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10006830 <fndsa_vect_iFFT_fp64q>:
10006830:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10006834:	ed2d 8b10 	vpush	{d8-d15}
10006838:	1e44      	subs	r4, r0, #1
1000683a:	b0bd      	sub	sp, #244	@ 0xf4
1000683c:	f000 82d4 	beq.w	10006de8 <fndsa_vect_iFFT_fp64q+0x5b8>
10006840:	2301      	movs	r3, #1
10006842:	ed9f 6b3b 	vldr	d6, [pc, #236]	@ 10006930 <fndsa_vect_iFFT_fp64q+0x100>
10006846:	ed9f 7b3c 	vldr	d7, [pc, #240]	@ 10006938 <fndsa_vect_iFFT_fp64q+0x108>
1000684a:	4625      	mov	r5, r4
1000684c:	f1a1 0808 	sub.w	r8, r1, #8
10006850:	fa03 f904 	lsl.w	r9, r3, r4
10006854:	9321      	str	r3, [sp, #132]	@ 0x84
10006856:	f8cd 90a0 	str.w	r9, [sp, #160]	@ 0xa0
1000685a:	f8cd 80a4 	str.w	r8, [sp, #164]	@ 0xa4
1000685e:	9b21      	ldr	r3, [sp, #132]	@ 0x84
10006860:	4937      	ldr	r1, [pc, #220]	@ (10006940 <fndsa_vect_iFFT_fp64q+0x110>)
10006862:	4618      	mov	r0, r3
10006864:	005a      	lsls	r2, r3, #1
10006866:	2301      	movs	r3, #1
10006868:	40ab      	lsls	r3, r5
1000686a:	eb03 0353 	add.w	r3, r3, r3, lsr #1
1000686e:	eb01 1303 	add.w	r3, r1, r3, lsl #4
10006872:	9322      	str	r3, [sp, #136]	@ 0x88
10006874:	2310      	movs	r3, #16
10006876:	f04f 0c00 	mov.w	ip, #0
1000687a:	40ab      	lsls	r3, r5
1000687c:	18cf      	adds	r7, r1, r3
1000687e:	00d3      	lsls	r3, r2, #3
10006880:	9323      	str	r3, [sp, #140]	@ 0x8c
10006882:	9b28      	ldr	r3, [sp, #160]	@ 0xa0
10006884:	ea4f 0ac0 	mov.w	sl, r0, lsl #3
10006888:	1a1b      	subs	r3, r3, r0
1000688a:	3301      	adds	r3, #1
1000688c:	9325      	str	r3, [sp, #148]	@ 0x94
1000688e:	9b29      	ldr	r3, [sp, #164]	@ 0xa4
10006890:	9221      	str	r2, [sp, #132]	@ 0x84
10006892:	eb03 0bc0 	add.w	fp, r3, r0, lsl #3
10006896:	9527      	str	r5, [sp, #156]	@ 0x9c
10006898:	9024      	str	r0, [sp, #144]	@ 0x90
1000689a:	f8cd a098 	str.w	sl, [sp, #152]	@ 0x98
1000689e:	9b24      	ldr	r3, [sp, #144]	@ 0x90
100068a0:	ac38      	add	r4, sp, #224	@ 0xe0
100068a2:	eb0c 0603 	add.w	r6, ip, r3
100068a6:	e897 000f 	ldmia.w	r7, {r0, r1, r2, r3}
100068aa:	e884 000f 	stmia.w	r4, {r0, r1, r2, r3}
100068ae:	45b4      	cmp	ip, r6
100068b0:	e9dd 0138 	ldrd	r0, r1, [sp, #224]	@ 0xe0
100068b4:	e9cd 0134 	strd	r0, r1, [sp, #208]	@ 0xd0
100068b8:	f080 8289 	bcs.w	10006dce <fndsa_vect_iFFT_fp64q+0x59e>
100068bc:	9c34      	ldr	r4, [sp, #208]	@ 0xd0
100068be:	4251      	negs	r1, r2
100068c0:	ee05 4a90 	vmov	s11, r4
100068c4:	eeb8 0b65 	vcvt.f64.u32	d0, s11
100068c8:	ee05 1a90 	vmov	s11, r1
100068cc:	9d35      	ldr	r5, [sp, #212]	@ 0xd4
100068ce:	eeb8 1b65 	vcvt.f64.u32	d1, s11
100068d2:	ee05 5a90 	vmov	s11, r5
100068d6:	eb63 0043 	sbc.w	r0, r3, r3, lsl #1
100068da:	eeb8 8b65 	vcvt.f64.u32	d8, s11
100068de:	ee05 0a90 	vmov	s11, r0
100068e2:	1aa2      	subs	r2, r4, r2
100068e4:	eeb8 cb65 	vcvt.f64.u32	d12, s11
100068e8:	ee05 2a90 	vmov	s11, r2
100068ec:	eb65 0303 	sbc.w	r3, r5, r3
100068f0:	eeb8 2b65 	vcvt.f64.u32	d2, s11
100068f4:	ee05 3a90 	vmov	s11, r3
100068f8:	9118      	str	r1, [sp, #96]	@ 0x60
100068fa:	9926      	ldr	r1, [sp, #152]	@ 0x98
100068fc:	eeb8 db65 	vcvt.f64.u32	d13, s11
10006900:	f1a1 0e08 	sub.w	lr, r1, #8
10006904:	ea4f 0ede 	mov.w	lr, lr, lsr #3
10006908:	f10e 0e01 	add.w	lr, lr, #1
1000690c:	f04e e001 	dls	lr, lr
10006910:	931d      	str	r3, [sp, #116]	@ 0x74
10006912:	e9cd cb1e 	strd	ip, fp, [sp, #120]	@ 0x78
10006916:	9b25      	ldr	r3, [sp, #148]	@ 0x94
10006918:	941a      	str	r4, [sp, #104]	@ 0x68
1000691a:	951b      	str	r5, [sp, #108]	@ 0x6c
1000691c:	901c      	str	r0, [sp, #112]	@ 0x70
1000691e:	9219      	str	r2, [sp, #100]	@ 0x64
10006920:	eb0b 08c3 	add.w	r8, fp, r3, lsl #3
10006924:	9720      	str	r7, [sp, #128]	@ 0x80
10006926:	9108      	str	r1, [sp, #32]
10006928:	ebab 0a01 	sub.w	sl, fp, r1
1000692c:	e00a      	b.n	10006944 <fndsa_vect_iFFT_fp64q+0x114>
1000692e:	bf00      	nop
10006930:	00000000 	.word	0x00000000
10006934:	3df00000 	.word	0x3df00000
10006938:	00000000 	.word	0x00000000
1000693c:	41f00000 	.word	0x41f00000
10006940:	300039a0 	.word	0x300039a0
10006944:	f8da 3008 	ldr.w	r3, [sl, #8]
10006948:	9d08      	ldr	r5, [sp, #32]
1000694a:	1c59      	adds	r1, r3, #1
1000694c:	f8da 200c 	ldr.w	r2, [sl, #12]
10006950:	f8d8 3000 	ldr.w	r3, [r8]
10006954:	f10a 0a08 	add.w	sl, sl, #8
10006958:	f85a 4005 	ldr.w	r4, [sl, r5]
1000695c:	f142 0200 	adc.w	r2, r2, #0
10006960:	1c58      	adds	r0, r3, #1
10006962:	f8d8 3004 	ldr.w	r3, [r8, #4]
10006966:	9215      	str	r2, [sp, #84]	@ 0x54
10006968:	f143 0300 	adc.w	r3, r3, #0
1000696c:	1b0c      	subs	r4, r1, r4
1000696e:	9406      	str	r4, [sp, #24]
10006970:	eb0a 0405 	add.w	r4, sl, r5
10006974:	6866      	ldr	r6, [r4, #4]
10006976:	9114      	str	r1, [sp, #80]	@ 0x50
10006978:	eb62 0206 	sbc.w	r2, r2, r6
1000697c:	9207      	str	r2, [sp, #28]
1000697e:	f858 2005 	ldr.w	r2, [r8, r5]
10006982:	9016      	str	r0, [sp, #88]	@ 0x58
10006984:	1a82      	subs	r2, r0, r2
10006986:	9204      	str	r2, [sp, #16]
10006988:	eb08 0205 	add.w	r2, r8, r5
1000698c:	6851      	ldr	r1, [r2, #4]
1000698e:	9317      	str	r3, [sp, #92]	@ 0x5c
10006990:	eb63 0001 	sbc.w	r0, r3, r1
10006994:	9b1a      	ldr	r3, [sp, #104]	@ 0x68
10006996:	940e      	str	r4, [sp, #56]	@ 0x38
10006998:	9209      	str	r2, [sp, #36]	@ 0x24
1000699a:	e9dd 4506 	ldrd	r4, r5, [sp, #24]
1000699e:	ea03 72e5 	and.w	r2, r3, r5, asr #31
100069a2:	ea54 056f 	asrl	r4, r5, #1
100069a6:	ee05 4a90 	vmov	s11, r4
100069aa:	eeb8 fb65 	vcvt.f64.u32	d15, s11
100069ae:	ee05 5a90 	vmov	s11, r5
100069b2:	ee20 ab0f 	vmul.f64	d10, d0, d15
100069b6:	eeb8 eb65 	vcvt.f64.u32	d14, s11
100069ba:	ee2a bb06 	vmul.f64	d11, d10, d6
100069be:	ee2e eb00 	vmul.f64	d14, d14, d0
100069c2:	462f      	mov	r7, r5
100069c4:	ee2e 4b06 	vmul.f64	d4, d14, d6
100069c8:	eebc bbcb 	vcvt.u32.f64	s22, d11
100069cc:	9005      	str	r0, [sp, #20]
100069ce:	9610      	str	r6, [sp, #64]	@ 0x40
100069d0:	4626      	mov	r6, r4
100069d2:	9805      	ldr	r0, [sp, #20]
100069d4:	910f      	str	r1, [sp, #60]	@ 0x3c
100069d6:	9918      	ldr	r1, [sp, #96]	@ 0x60
100069d8:	eefc 9bc4 	vcvt.u32.f64	s19, d4
100069dc:	ea01 70e0 	and.w	r0, r1, r0, asr #31
100069e0:	fb03 f104 	mul.w	r1, r3, r4
100069e4:	9c1b      	ldr	r4, [sp, #108]	@ 0x6c
100069e6:	eeb8 3b4b 	vcvt.f64.u32	d3, s22
100069ea:	9013      	str	r0, [sp, #76]	@ 0x4c
100069ec:	fb03 f007 	mul.w	r0, r3, r7
100069f0:	4623      	mov	r3, r4
100069f2:	ee28 fb0f 	vmul.f64	d15, d8, d15
100069f6:	e9cd 6702 	strd	r6, r7, [sp, #8]
100069fa:	fb04 f506 	mul.w	r5, r4, r6
100069fe:	9e03      	ldr	r6, [sp, #12]
10006a00:	ee23 3b07 	vmul.f64	d3, d3, d7
10006a04:	fb04 f406 	mul.w	r4, r4, r6
10006a08:	9e02      	ldr	r6, [sp, #8]
10006a0a:	eeb8 4b69 	vcvt.f64.u32	d4, s19
10006a0e:	ea06 73e3 	and.w	r3, r6, r3, asr #31
10006a12:	e9dd 6704 	ldrd	r6, r7, [sp, #16]
10006a16:	ea56 076f 	asrl	r6, r7, #1
10006a1a:	ee2f 5b06 	vmul.f64	d5, d15, d6
10006a1e:	ee24 4b07 	vmul.f64	d4, d4, d7
10006a22:	ee1a ca10 	vmov	ip, s20
10006a26:	e9cd 6700 	strd	r6, r7, [sp]
10006a2a:	ee13 7a10 	vmov	r7, s6
10006a2e:	eebc 9bc5 	vcvt.u32.f64	s18, d5
10006a32:	4413      	add	r3, r2
10006a34:	ee1a 6a90 	vmov	r6, s21
10006a38:	1ae4      	subs	r4, r4, r3
10006a3a:	ee13 3a90 	vmov	r3, s7
10006a3e:	ea87 020c 	eor.w	r2, r7, ip
10006a42:	ee1e 9a10 	vmov	r9, s28
10006a46:	ee14 ca10 	vmov	ip, s8
10006a4a:	eeb8 5b49 	vcvt.f64.u32	d5, s18
10006a4e:	4073      	eors	r3, r6
10006a50:	4313      	orrs	r3, r2
10006a52:	e9dd 6700 	ldrd	r6, r7, [sp]
10006a56:	ea8c 0209 	eor.w	r2, ip, r9
10006a5a:	ee14 7a90 	vmov	r7, s9
10006a5e:	ee1e ca90 	vmov	ip, s29
10006a62:	ee25 5b07 	vmul.f64	d5, d5, d7
10006a66:	ee03 6a90 	vmov	s7, r6
10006a6a:	ea87 0c0c 	eor.w	ip, r7, ip
10006a6e:	ea4c 0c02 	orr.w	ip, ip, r2
10006a72:	425a      	negs	r2, r3
10006a74:	431a      	orrs	r2, r3
10006a76:	0fd2      	lsrs	r2, r2, #31
10006a78:	922d      	str	r2, [sp, #180]	@ 0xb4
10006a7a:	ee15 7a10 	vmov	r7, s10
10006a7e:	ee1f 9a10 	vmov	r9, s30
10006a82:	ee1f 2a90 	vmov	r2, s31
10006a86:	ee15 6a90 	vmov	r6, s11
10006a8a:	eeb8 3b63 	vcvt.f64.u32	d3, s7
10006a8e:	ea87 0309 	eor.w	r3, r7, r9
10006a92:	4056      	eors	r6, r2
10006a94:	431e      	orrs	r6, r3
10006a96:	f1cc 0300 	rsb	r3, ip, #0
10006a9a:	ea43 030c 	orr.w	r3, r3, ip
10006a9e:	0fdb      	lsrs	r3, r3, #31
10006aa0:	4272      	negs	r2, r6
10006aa2:	ee23 eb01 	vmul.f64	d14, d3, d1
10006aa6:	ed9d aa01 	vldr	s20, [sp, #4]
10006aaa:	4332      	orrs	r2, r6
10006aac:	9e2d      	ldr	r6, [sp, #180]	@ 0xb4
10006aae:	932c      	str	r3, [sp, #176]	@ 0xb0
10006ab0:	ee1b 3a10 	vmov	r3, s22
10006ab4:	f086 0601 	eor.w	r6, r6, #1
10006ab8:	ea06 76d1 	and.w	r6, r6, r1, lsr #31
10006abc:	ee2c 5b03 	vmul.f64	d5, d12, d3
10006ac0:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10006ac4:	ee2e 3b06 	vmul.f64	d3, d14, d6
10006ac8:	1b9b      	subs	r3, r3, r6
10006aca:	ee19 6a90 	vmov	r6, s19
10006ace:	992c      	ldr	r1, [sp, #176]	@ 0xb0
10006ad0:	ee2a fb01 	vmul.f64	d15, d10, d1
10006ad4:	f081 0101 	eor.w	r1, r1, #1
10006ad8:	ea01 71d0 	and.w	r1, r1, r0, lsr #31
10006adc:	1a71      	subs	r1, r6, r1
10006ade:	ee19 6a10 	vmov	r6, s18
10006ae2:	eebc 9bc3 	vcvt.u32.f64	s18, d3
10006ae6:	ee2f ab06 	vmul.f64	d10, d15, d6
10006aea:	eeb8 4b49 	vcvt.f64.u32	d4, s18
10006aee:	eebc abca 	vcvt.u32.f64	s20, d10
10006af2:	ee24 4b07 	vmul.f64	d4, d4, d7
10006af6:	ee1e ba10 	vmov	fp, s28
10006afa:	ee14 7a10 	vmov	r7, s8
10006afe:	eeb8 3b4a 	vcvt.f64.u32	d3, s20
10006b02:	eeb0 bb45 	vmov.f64	d11, d5
10006b06:	ee25 5b06 	vmul.f64	d5, d5, d6
10006b0a:	0fd2      	lsrs	r2, r2, #31
10006b0c:	922b      	str	r2, [sp, #172]	@ 0xac
10006b0e:	9a2b      	ldr	r2, [sp, #172]	@ 0xac
10006b10:	195b      	adds	r3, r3, r5
10006b12:	f082 0201 	eor.w	r2, r2, #1
10006b16:	ea02 72d5 	and.w	r2, r2, r5, lsr #31
10006b1a:	eba6 0202 	sub.w	r2, r6, r2
10006b1e:	eb42 0204 	adc.w	r2, r2, r4
10006b22:	181b      	adds	r3, r3, r0
10006b24:	9c00      	ldr	r4, [sp, #0]
10006b26:	981c      	ldr	r0, [sp, #112]	@ 0x70
10006b28:	eb41 0102 	adc.w	r1, r1, r2
10006b2c:	9a18      	ldr	r2, [sp, #96]	@ 0x60
10006b2e:	fb00 f904 	mul.w	r9, r0, r4
10006b32:	fb02 f604 	mul.w	r6, r2, r4
10006b36:	9c01      	ldr	r4, [sp, #4]
10006b38:	9d01      	ldr	r5, [sp, #4]
10006b3a:	fb02 f404 	mul.w	r4, r2, r4
10006b3e:	9a00      	ldr	r2, [sp, #0]
10006b40:	fb00 f505 	mul.w	r5, r0, r5
10006b44:	ea02 72e0 	and.w	r2, r2, r0, asr #31
10006b48:	9813      	ldr	r0, [sp, #76]	@ 0x4c
10006b4a:	ee23 3b07 	vmul.f64	d3, d3, d7
10006b4e:	eb00 0c01 	add.w	ip, r0, r1
10006b52:	4494      	add	ip, r2
10006b54:	9212      	str	r2, [sp, #72]	@ 0x48
10006b56:	ea87 020b 	eor.w	r2, r7, fp
10006b5a:	ee14 7a90 	vmov	r7, s9
10006b5e:	ee1e ba90 	vmov	fp, s29
10006b62:	eefc 9bc5 	vcvt.u32.f64	s19, d5
10006b66:	ee1f 0a10 	vmov	r0, s30
10006b6a:	ea87 0b0b 	eor.w	fp, r7, fp
10006b6e:	ee13 7a10 	vmov	r7, s6
10006b72:	eeb8 5b69 	vcvt.f64.u32	d5, s19
10006b76:	ea4b 0b02 	orr.w	fp, fp, r2
10006b7a:	4078      	eors	r0, r7
10006b7c:	ee13 2a90 	vmov	r2, s7
10006b80:	ee1f 7a90 	vmov	r7, s31
10006b84:	ee25 5b07 	vmul.f64	d5, d5, d7
10006b88:	407a      	eors	r2, r7
10006b8a:	4302      	orrs	r2, r0
10006b8c:	f1cb 0000 	rsb	r0, fp, #0
10006b90:	ee1b 7a10 	vmov	r7, s22
10006b94:	ea40 000b 	orr.w	r0, r0, fp
10006b98:	ee15 ba10 	vmov	fp, s10
10006b9c:	0fc0      	lsrs	r0, r0, #31
10006b9e:	9030      	str	r0, [sp, #192]	@ 0xc0
10006ba0:	ea8b 0007 	eor.w	r0, fp, r7
10006ba4:	ee1b 7a90 	vmov	r7, s23
10006ba8:	ee15 ba90 	vmov	fp, s11
10006bac:	ea8b 0b07 	eor.w	fp, fp, r7
10006bb0:	ee19 7a10 	vmov	r7, s18
10006bb4:	ea4b 0b00 	orr.w	fp, fp, r0
10006bb8:	4250      	negs	r0, r2
10006bba:	4302      	orrs	r2, r0
10006bbc:	f1cb 0000 	rsb	r0, fp, #0
10006bc0:	ea40 000b 	orr.w	r0, r0, fp
10006bc4:	f8dd b0c0 	ldr.w	fp, [sp, #192]	@ 0xc0
10006bc8:	0fd2      	lsrs	r2, r2, #31
10006bca:	f08b 0b01 	eor.w	fp, fp, #1
10006bce:	ea0b 7bd6 	and.w	fp, fp, r6, lsr #31
10006bd2:	922f      	str	r2, [sp, #188]	@ 0xbc
10006bd4:	eba7 020b 	sub.w	r2, r7, fp
10006bd8:	ee1a 7a10 	vmov	r7, s20
10006bdc:	9e2f      	ldr	r6, [sp, #188]	@ 0xbc
10006bde:	0fc0      	lsrs	r0, r0, #31
10006be0:	f086 0601 	eor.w	r6, r6, #1
10006be4:	ea06 76d4 	and.w	r6, r6, r4, lsr #31
10006be8:	1bbe      	subs	r6, r7, r6
10006bea:	ee19 7a90 	vmov	r7, s19
10006bee:	902e      	str	r0, [sp, #184]	@ 0xb8
10006bf0:	982e      	ldr	r0, [sp, #184]	@ 0xb8
10006bf2:	eb12 0209 	adds.w	r2, r2, r9
10006bf6:	f080 0001 	eor.w	r0, r0, #1
10006bfa:	ea00 70d9 	and.w	r0, r0, r9, lsr #31
10006bfe:	eba7 0000 	sub.w	r0, r7, r0
10006c02:	eb45 0000 	adc.w	r0, r5, r0
10006c06:	1912      	adds	r2, r2, r4
10006c08:	eb46 0700 	adc.w	r7, r6, r0
10006c0c:	9c02      	ldr	r4, [sp, #8]
10006c0e:	9711      	str	r7, [sp, #68]	@ 0x44
10006c10:	9f00      	ldr	r7, [sp, #0]
10006c12:	9d08      	ldr	r5, [sp, #32]
10006c14:	1938      	adds	r0, r7, r4
10006c16:	ee05 0a90 	vmov	s11, r0
10006c1a:	9f03      	ldr	r7, [sp, #12]
10006c1c:	9c01      	ldr	r4, [sp, #4]
10006c1e:	eeb8 fb65 	vcvt.f64.u32	d15, s11
10006c22:	eb47 0404 	adc.w	r4, r7, r4
10006c26:	ee05 4a90 	vmov	s11, r4
10006c2a:	ee22 bb0f 	vmul.f64	d11, d2, d15
10006c2e:	eeb8 eb65 	vcvt.f64.u32	d14, s11
10006c32:	ee2b 3b06 	vmul.f64	d3, d11, d6
10006c36:	ee2e eb02 	vmul.f64	d14, d14, d2
10006c3a:	eefc 9bc3 	vcvt.u32.f64	s19, d3
10006c3e:	ee2e 4b06 	vmul.f64	d4, d14, d6
10006c42:	eebc 9bc4 	vcvt.u32.f64	s18, d4
10006c46:	eeb8 4b69 	vcvt.f64.u32	d4, s19
10006c4a:	f85a 7005 	ldr.w	r7, [sl, r5]
10006c4e:	9d14      	ldr	r5, [sp, #80]	@ 0x50
10006c50:	9e10      	ldr	r6, [sp, #64]	@ 0x40
10006c52:	197f      	adds	r7, r7, r5
10006c54:	970a      	str	r7, [sp, #40]	@ 0x28
10006c56:	9d15      	ldr	r5, [sp, #84]	@ 0x54
10006c58:	ee24 4b07 	vmul.f64	d4, d4, d7
10006c5c:	eb46 0705 	adc.w	r7, r6, r5
10006c60:	9d08      	ldr	r5, [sp, #32]
10006c62:	970b      	str	r7, [sp, #44]	@ 0x2c
10006c64:	f858 7005 	ldr.w	r7, [r8, r5]
10006c68:	9d16      	ldr	r5, [sp, #88]	@ 0x58
10006c6a:	9e0f      	ldr	r6, [sp, #60]	@ 0x3c
10006c6c:	197f      	adds	r7, r7, r5
10006c6e:	9d17      	ldr	r5, [sp, #92]	@ 0x5c
10006c70:	970c      	str	r7, [sp, #48]	@ 0x30
10006c72:	eb46 0605 	adc.w	r6, r6, r5
10006c76:	9f11      	ldr	r7, [sp, #68]	@ 0x44
10006c78:	9d13      	ldr	r5, [sp, #76]	@ 0x4c
10006c7a:	960d      	str	r6, [sp, #52]	@ 0x34
10006c7c:	1a9e      	subs	r6, r3, r2
10006c7e:	9600      	str	r6, [sp, #0]
10006c80:	eb6c 0707 	sbc.w	r7, ip, r7
10006c84:	9e12      	ldr	r6, [sp, #72]	@ 0x48
10006c86:	425b      	negs	r3, r3
10006c88:	eb65 0101 	sbc.w	r1, r5, r1
10006c8c:	1875      	adds	r5, r6, r1
10006c8e:	9e1d      	ldr	r6, [sp, #116]	@ 0x74
10006c90:	9919      	ldr	r1, [sp, #100]	@ 0x64
10006c92:	ee2d fb0f 	vmul.f64	d15, d13, d15
10006c96:	fb00 f901 	mul.w	r9, r0, r1
10006c9a:	ea00 71e6 	and.w	r1, r0, r6, asr #31
10006c9e:	1a69      	subs	r1, r5, r1
10006ca0:	fb04 1106 	mla	r1, r4, r6, r1
10006ca4:	9d19      	ldr	r5, [sp, #100]	@ 0x64
10006ca6:	fb06 f000 	mul.w	r0, r6, r0
10006caa:	fb04 fc05 	mul.w	ip, r4, r5
10006cae:	ea05 74e4 	and.w	r4, r5, r4, asr #31
10006cb2:	1b09      	subs	r1, r1, r4
10006cb4:	e9dd 450a 	ldrd	r4, r5, [sp, #40]	@ 0x28
10006cb8:	ea54 056f 	asrl	r4, r5, #1
10006cbc:	ee1b 6a10 	vmov	r6, s22
10006cc0:	e9ca 4500 	strd	r4, r5, [sl]
10006cc4:	eeb8 3b49 	vcvt.f64.u32	d3, s18
10006cc8:	ee14 5a10 	vmov	r5, s8
10006ccc:	ee2f ab06 	vmul.f64	d10, d15, d6
10006cd0:	ea85 0406 	eor.w	r4, r5, r6
10006cd4:	ee23 3b07 	vmul.f64	d3, d3, d7
10006cd8:	ee14 5a90 	vmov	r5, s9
10006cdc:	ee1b 6a90 	vmov	r6, s23
10006ce0:	eebc abca 	vcvt.u32.f64	s20, d10
10006ce4:	ea85 0b06 	eor.w	fp, r5, r6
10006ce8:	ee13 5a10 	vmov	r5, s6
10006cec:	ee1e 6a10 	vmov	r6, s28
10006cf0:	eeb8 5b4a 	vcvt.f64.u32	d5, s20
10006cf4:	ea4b 0b04 	orr.w	fp, fp, r4
10006cf8:	ea85 0406 	eor.w	r4, r5, r6
10006cfc:	ee1e 6a90 	vmov	r6, s29
10006d00:	ee13 5a90 	vmov	r5, s7
10006d04:	ee25 5b07 	vmul.f64	d5, d5, d7
10006d08:	4075      	eors	r5, r6
10006d0a:	4325      	orrs	r5, r4
10006d0c:	f1cb 0400 	rsb	r4, fp, #0
10006d10:	ee15 6a10 	vmov	r6, s10
10006d14:	ea44 040b 	orr.w	r4, r4, fp
10006d18:	ee1f ba10 	vmov	fp, s30
10006d1c:	0fe4      	lsrs	r4, r4, #31
10006d1e:	9433      	str	r4, [sp, #204]	@ 0xcc
10006d20:	ea86 040b 	eor.w	r4, r6, fp
10006d24:	ee15 6a90 	vmov	r6, s11
10006d28:	ee1f ba90 	vmov	fp, s31
10006d2c:	ea86 0b0b 	eor.w	fp, r6, fp
10006d30:	ea4b 0b04 	orr.w	fp, fp, r4
10006d34:	426c      	negs	r4, r5
10006d36:	4325      	orrs	r5, r4
10006d38:	0fed      	lsrs	r5, r5, #31
10006d3a:	f1cb 0400 	rsb	r4, fp, #0
10006d3e:	ea44 040b 	orr.w	r4, r4, fp
10006d42:	f8dd b0cc 	ldr.w	fp, [sp, #204]	@ 0xcc
10006d46:	9532      	str	r5, [sp, #200]	@ 0xc8
10006d48:	ee19 5a90 	vmov	r5, s19
10006d4c:	ee19 6a10 	vmov	r6, s18
10006d50:	f08b 0b01 	eor.w	fp, fp, #1
10006d54:	ea0b 7bd9 	and.w	fp, fp, r9, lsr #31
10006d58:	eba5 0b0b 	sub.w	fp, r5, fp
10006d5c:	9d32      	ldr	r5, [sp, #200]	@ 0xc8
10006d5e:	0fe4      	lsrs	r4, r4, #31
10006d60:	f085 0501 	eor.w	r5, r5, #1
10006d64:	9431      	str	r4, [sp, #196]	@ 0xc4
10006d66:	ea05 75dc 	and.w	r5, r5, ip, lsr #31
10006d6a:	1b74      	subs	r4, r6, r5
10006d6c:	9d31      	ldr	r5, [sp, #196]	@ 0xc4
10006d6e:	eb13 030b 	adds.w	r3, r3, fp
10006d72:	f085 0501 	eor.w	r5, r5, #1
10006d76:	f141 0100 	adc.w	r1, r1, #0
10006d7a:	ea05 75d0 	and.w	r5, r5, r0, lsr #31
10006d7e:	181b      	adds	r3, r3, r0
10006d80:	ee1a 0a10 	vmov	r0, s20
10006d84:	eba0 0505 	sub.w	r5, r0, r5
10006d88:	eb45 0501 	adc.w	r5, r5, r1
10006d8c:	eb13 030c 	adds.w	r3, r3, ip
10006d90:	eb44 0405 	adc.w	r4, r4, r5
10006d94:	1a99      	subs	r1, r3, r2
10006d96:	9b11      	ldr	r3, [sp, #68]	@ 0x44
10006d98:	9e00      	ldr	r6, [sp, #0]
10006d9a:	eb64 0403 	sbc.w	r4, r4, r3
10006d9e:	e9dd 230c 	ldrd	r2, r3, [sp, #48]	@ 0x30
10006da2:	ea52 036f 	asrl	r2, r3, #1
10006da6:	e9c8 2300 	strd	r2, r3, [r8]
10006daa:	9a08      	ldr	r2, [sp, #32]
10006dac:	9b0e      	ldr	r3, [sp, #56]	@ 0x38
10006dae:	f84a 6002 	str.w	r6, [sl, r2]
10006db2:	605f      	str	r7, [r3, #4]
10006db4:	f848 1002 	str.w	r1, [r8, r2]
10006db8:	9a09      	ldr	r2, [sp, #36]	@ 0x24
10006dba:	f108 0808 	add.w	r8, r8, #8
10006dbe:	6054      	str	r4, [r2, #4]
10006dc0:	f1be 0e01 	subs.w	lr, lr, #1
10006dc4:	f47f adbe 	bne.w	10006944 <fndsa_vect_iFFT_fp64q+0x114>
10006dc8:	e9dd cb1e 	ldrd	ip, fp, [sp, #120]	@ 0x78
10006dcc:	9f20      	ldr	r7, [sp, #128]	@ 0x80
10006dce:	9b21      	ldr	r3, [sp, #132]	@ 0x84
10006dd0:	3710      	adds	r7, #16
10006dd2:	449c      	add	ip, r3
10006dd4:	9b23      	ldr	r3, [sp, #140]	@ 0x8c
10006dd6:	449b      	add	fp, r3
10006dd8:	9b22      	ldr	r3, [sp, #136]	@ 0x88
10006dda:	42bb      	cmp	r3, r7
10006ddc:	f47f ad5f 	bne.w	1000689e <fndsa_vect_iFFT_fp64q+0x6e>
10006de0:	9d27      	ldr	r5, [sp, #156]	@ 0x9c
10006de2:	3d01      	subs	r5, #1
10006de4:	f47f ad3b 	bne.w	1000685e <fndsa_vect_iFFT_fp64q+0x2e>
10006de8:	b03d      	add	sp, #244	@ 0xf4
10006dea:	ecbd 8b10 	vpop	{d8-d15}
10006dee:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
