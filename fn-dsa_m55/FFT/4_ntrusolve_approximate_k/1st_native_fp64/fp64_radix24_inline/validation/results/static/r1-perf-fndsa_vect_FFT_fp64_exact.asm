
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/r1-perf/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10006880 <fndsa_vect_FFT_fp64_exact>:
10006880:	2801      	cmp	r0, #1
10006882:	f240 8202 	bls.w	10006c8a <fndsa_vect_FFT_fp64_exact+0x40a>
10006886:	2201      	movs	r2, #1
10006888:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
1000688c:	ed2d 8b10 	vpush	{d8-d15}
10006890:	2310      	movs	r3, #16
10006892:	460e      	mov	r6, r1
10006894:	ed9f dbec 	vldr	d13, [pc, #944]	@ 10006c48 <fndsa_vect_FFT_fp64_exact+0x3c8>
10006898:	ed9f cbed 	vldr	d12, [pc, #948]	@ 10006c50 <fndsa_vect_FFT_fp64_exact+0x3d0>
1000689c:	4614      	mov	r4, r2
1000689e:	b0d1      	sub	sp, #324	@ 0x144
100068a0:	911f      	str	r1, [sp, #124]	@ 0x7c
100068a2:	1e41      	subs	r1, r0, #1
100068a4:	408b      	lsls	r3, r1
100068a6:	18f7      	adds	r7, r6, r3
100068a8:	e9cd 7022 	strd	r7, r0, [sp, #136]	@ 0x88
100068ac:	f10d 08e0 	add.w	r8, sp, #224	@ 0xe0
100068b0:	f10d 0af0 	add.w	sl, sp, #240	@ 0xf0
100068b4:	fa02 fe01 	lsl.w	lr, r2, r1
100068b8:	2501      	movs	r5, #1
100068ba:	2310      	movs	r3, #16
100068bc:	eeb7 bb00 	vmov.f64	d11, #112	@ 0x3f800000  1.0
100068c0:	2200      	movs	r2, #0
100068c2:	fa05 f704 	lsl.w	r7, r5, r4
100068c6:	4de4      	ldr	r5, [pc, #912]	@ (10006c58 <fndsa_vect_FFT_fp64_exact+0x3d8>)
100068c8:	eb07 0757 	add.w	r7, r7, r7, lsr #1
100068cc:	4670      	mov	r0, lr
100068ce:	ea4f 0e5e 	mov.w	lr, lr, lsr #1
100068d2:	eb05 1607 	add.w	r6, r5, r7, lsl #4
100068d6:	ea4f 170e 	mov.w	r7, lr, lsl #4
100068da:	961e      	str	r6, [sp, #120]	@ 0x78
100068dc:	f107 0608 	add.w	r6, r7, #8
100068e0:	9620      	str	r6, [sp, #128]	@ 0x80
100068e2:	9e1f      	ldr	r6, [sp, #124]	@ 0x7c
100068e4:	40a3      	lsls	r3, r4
100068e6:	9922      	ldr	r1, [sp, #136]	@ 0x88
100068e8:	eb06 1b0e 	add.w	fp, r6, lr, lsl #4
100068ec:	442b      	add	r3, r5
100068ee:	f8cd e074 	str.w	lr, [sp, #116]	@ 0x74
100068f2:	9421      	str	r4, [sp, #132]	@ 0x84
100068f4:	9c1d      	ldr	r4, [sp, #116]	@ 0x74
100068f6:	4414      	add	r4, r2
100068f8:	42a2      	cmp	r2, r4
100068fa:	f080 81af 	bcs.w	10006c5c <fndsa_vect_FFT_fp64_exact+0x3dc>
100068fe:	edd3 5a01 	vldr	s11, [r3, #4]
10006902:	edd3 7a00 	vldr	s15, [r3]
10006906:	edd3 6a02 	vldr	s13, [r3, #8]
1000690a:	eeb8 7b67 	vcvt.f64.u32	d7, s15
1000690e:	eeb8 6b66 	vcvt.f64.u32	d6, s13
10006912:	eeb8 4b65 	vcvt.f64.u32	d4, s11
10006916:	edd3 5a03 	vldr	s11, [r3, #12]
1000691a:	eeb8 3b65 	vcvt.f64.u32	d3, s11
1000691e:	ee37 5b06 	vadd.f64	d5, d7, d6
10006922:	ed8d 7b10 	vstr	d7, [sp, #64]	@ 0x40
10006926:	ee25 7b0d 	vmul.f64	d7, d5, d13
1000692a:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000692e:	ed8d 6b14 	vstr	d6, [sp, #80]	@ 0x50
10006932:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006936:	ee34 6b03 	vadd.f64	d6, d4, d3
1000693a:	ee36 6b07 	vadd.f64	d6, d6, d7
1000693e:	ee07 5b4c 	vmls.f64	d5, d7, d12
10006942:	ee26 7b0d 	vmul.f64	d7, d6, d13
10006946:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000694a:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000694e:	ee07 6b4c 	vmls.f64	d6, d7, d12
10006952:	9e20      	ldr	r6, [sp, #128]	@ 0x80
10006954:	ed8d 4b0e 	vstr	d4, [sp, #56]	@ 0x38
10006958:	1877      	adds	r7, r6, r1
1000695a:	ed8d 3b12 	vstr	d3, [sp, #72]	@ 0x48
1000695e:	460d      	mov	r5, r1
10006960:	ed8d 5b18 	vstr	d5, [sp, #96]	@ 0x60
10006964:	ed8d 6b16 	vstr	d6, [sp, #88]	@ 0x58
10006968:	460e      	mov	r6, r1
1000696a:	9c1f      	ldr	r4, [sp, #124]	@ 0x7c
1000696c:	e9cd 201a 	strd	r2, r0, [sp, #104]	@ 0x68
10006970:	eb04 1402 	add.w	r4, r4, r2, lsl #4
10006974:	f10b 0908 	add.w	r9, fp, #8
10006978:	931c      	str	r3, [sp, #112]	@ 0x70
1000697a:	ed94 8b00 	vldr	d8, [r4]
1000697e:	f1a9 0308 	sub.w	r3, r9, #8
10006982:	cb0f      	ldmia	r3, {r0, r1, r2, r3}
10006984:	e888 000f 	stmia.w	r8, {r0, r1, r2, r3}
10006988:	ed95 2b02 	vldr	d2, [r5, #8]
1000698c:	ed9d eb3a 	vldr	d14, [sp, #232]	@ 0xe8
10006990:	ed8d 8b06 	vstr	d8, [sp, #24]
10006994:	ed9d 8b38 	vldr	d8, [sp, #224]	@ 0xe0
10006998:	ed94 7b02 	vldr	d7, [r4, #8]
1000699c:	ed95 5b00 	vldr	d5, [r5]
100069a0:	ed9d 1b10 	vldr	d1, [sp, #64]	@ 0x40
100069a4:	ed9d 0b0e 	vldr	d0, [sp, #56]	@ 0x38
100069a8:	f1a7 0c08 	sub.w	ip, r7, #8
100069ac:	e89c 000f 	ldmia.w	ip, {r0, r1, r2, r3}
100069b0:	e88a 000f 	stmia.w	sl, {r0, r1, r2, r3}
100069b4:	ed8d 2b04 	vstr	d2, [sp, #16]
100069b8:	eeb0 3b4e 	vmov.f64	d3, d14
100069bc:	eeb0 2b48 	vmov.f64	d2, d8
100069c0:	ed8d 7b00 	vstr	d7, [sp]
100069c4:	ed8d 5b02 	vstr	d5, [sp, #8]
100069c8:	ed8d 0b40 	vstr	d0, [sp, #256]	@ 0x100
100069cc:	ed8d 1b42 	vstr	d1, [sp, #264]	@ 0x108
100069d0:	ed8d 8b48 	vstr	d8, [sp, #288]	@ 0x120
100069d4:	ed8d eb4a 	vstr	d14, [sp, #296]	@ 0x128
100069d8:	ed9d 9b3c 	vldr	d9, [sp, #240]	@ 0xf0
100069dc:	f7ff fd78 	bl	100064d0 <fndsa_fp64e_mul>
100069e0:	ed9d ab3e 	vldr	d10, [sp, #248]	@ 0xf8
100069e4:	ed9d 6b14 	vldr	d6, [sp, #80]	@ 0x50
100069e8:	eeb0 5b40 	vmov.f64	d5, d0
100069ec:	ed9d 0b12 	vldr	d0, [sp, #72]	@ 0x48
100069f0:	eeb0 2b49 	vmov.f64	d2, d9
100069f4:	ed8d 1b26 	vstr	d1, [sp, #152]	@ 0x98
100069f8:	ed8d 1b0a 	vstr	d1, [sp, #40]	@ 0x28
100069fc:	eeb0 3b4a 	vmov.f64	d3, d10
10006a00:	eeb0 1b46 	vmov.f64	d1, d6
10006a04:	ed8d 5b24 	vstr	d5, [sp, #144]	@ 0x90
10006a08:	ed8d 5b0c 	vstr	d5, [sp, #48]	@ 0x30
10006a0c:	ed8d 0b44 	vstr	d0, [sp, #272]	@ 0x110
10006a10:	ed8d 6b46 	vstr	d6, [sp, #280]	@ 0x118
10006a14:	ed8d 9b4c 	vstr	d9, [sp, #304]	@ 0x130
10006a18:	ed8d ab4e 	vstr	d10, [sp, #312]	@ 0x138
10006a1c:	f7ff fd58 	bl	100064d0 <fndsa_fp64e_mul>
10006a20:	ee3e 3b0a 	vadd.f64	d3, d14, d10
10006a24:	ee23 4b0d 	vmul.f64	d4, d3, d13
10006a28:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10006a2c:	ee38 2b09 	vadd.f64	d2, d8, d9
10006a30:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10006a34:	ee32 2b04 	vadd.f64	d2, d2, d4
10006a38:	ee04 3b4c 	vmls.f64	d3, d4, d12
10006a3c:	ee22 4b0d 	vmul.f64	d4, d2, d13
10006a40:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10006a44:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10006a48:	ed9d 6b18 	vldr	d6, [sp, #96]	@ 0x60
10006a4c:	ee04 2b4c 	vmls.f64	d2, d4, d12
10006a50:	eeb0 fb40 	vmov.f64	d15, d0
10006a54:	ed8d 0b28 	vstr	d0, [sp, #160]	@ 0xa0
10006a58:	ed9d 0b16 	vldr	d0, [sp, #88]	@ 0x58
10006a5c:	ed8d 1b2a 	vstr	d1, [sp, #168]	@ 0xa8
10006a60:	ed8d 1b08 	vstr	d1, [sp, #32]
10006a64:	eeb0 1b46 	vmov.f64	d1, d6
10006a68:	ed8d 0b34 	vstr	d0, [sp, #208]	@ 0xd0
10006a6c:	ed8d 6b36 	vstr	d6, [sp, #216]	@ 0xd8
10006a70:	ed8d 3b32 	vstr	d3, [sp, #200]	@ 0xc8
10006a74:	ed8d 2b30 	vstr	d2, [sp, #192]	@ 0xc0
10006a78:	f7ff fd2a 	bl	100064d0 <fndsa_fp64e_mul>
10006a7c:	ed9d 7b08 	vldr	d7, [sp, #32]
10006a80:	ed9d 6b0a 	vldr	d6, [sp, #40]	@ 0x28
10006a84:	ee36 4b07 	vadd.f64	d4, d6, d7
10006a88:	ee24 3b0d 	vmul.f64	d3, d4, d13
10006a8c:	ed9d 5b0c 	vldr	d5, [sp, #48]	@ 0x30
10006a90:	ee36 6b0c 	vadd.f64	d6, d6, d12
10006a94:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006a98:	ee36 6b47 	vsub.f64	d6, d6, d7
10006a9c:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10006aa0:	ee35 7b0f 	vadd.f64	d7, d5, d15
10006aa4:	ee37 7b03 	vadd.f64	d7, d7, d3
10006aa8:	ee27 2b0d 	vmul.f64	d2, d7, d13
10006aac:	ee03 4b4c 	vmls.f64	d4, d3, d12
10006ab0:	ee35 5b0c 	vadd.f64	d5, d5, d12
10006ab4:	ee26 3b0d 	vmul.f64	d3, d6, d13
10006ab8:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10006abc:	ed8d 1b2e 	vstr	d1, [sp, #184]	@ 0xb8
10006ac0:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10006ac4:	ee31 1b0c 	vadd.f64	d1, d1, d12
10006ac8:	ee35 5b4f 	vsub.f64	d5, d5, d15
10006acc:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006ad0:	ee31 4b44 	vsub.f64	d4, d1, d4
10006ad4:	ee02 7b4c 	vmls.f64	d7, d2, d12
10006ad8:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10006adc:	ed8d 0b2c 	vstr	d0, [sp, #176]	@ 0xb0
10006ae0:	ee35 5b4b 	vsub.f64	d5, d5, d11
10006ae4:	ee30 0b0c 	vadd.f64	d0, d0, d12
10006ae8:	ee35 5b03 	vadd.f64	d5, d5, d3
10006aec:	ee30 0b47 	vsub.f64	d0, d0, d7
10006af0:	ee24 7b0d 	vmul.f64	d7, d4, d13
10006af4:	ee03 6b4c 	vmls.f64	d6, d3, d12
10006af8:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006afc:	ee25 3b0d 	vmul.f64	d3, d5, d13
10006b00:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006b04:	ee30 0b4b 	vsub.f64	d0, d0, d11
10006b08:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006b0c:	ee30 0b07 	vadd.f64	d0, d0, d7
10006b10:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10006b14:	ee07 4b4c 	vmls.f64	d4, d7, d12
10006b18:	ee03 5b4c 	vmls.f64	d5, d3, d12
10006b1c:	ed9d 7b00 	vldr	d7, [sp]
10006b20:	ee20 3b0d 	vmul.f64	d3, d0, d13
10006b24:	ee37 2b0c 	vadd.f64	d2, d7, d12
10006b28:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006b2c:	ee37 7b06 	vadd.f64	d7, d7, d6
10006b30:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10006b34:	ee32 6b46 	vsub.f64	d6, d2, d6
10006b38:	ed9d 2b04 	vldr	d2, [sp, #16]
10006b3c:	ee03 0b4c 	vmls.f64	d0, d3, d12
10006b40:	ee32 3b0c 	vadd.f64	d3, d2, d12
10006b44:	ee34 2b02 	vadd.f64	d2, d4, d2
10006b48:	ee33 4b44 	vsub.f64	d4, d3, d4
10006b4c:	ee27 3b0d 	vmul.f64	d3, d7, d13
10006b50:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006b54:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10006b58:	ed9d 8b06 	vldr	d8, [sp, #24]
10006b5c:	ee03 7b4c 	vmls.f64	d7, d3, d12
10006b60:	ed84 7b02 	vstr	d7, [r4, #8]
10006b64:	ee38 7b0c 	vadd.f64	d7, d8, d12
10006b68:	ee22 1b0d 	vmul.f64	d1, d2, d13
10006b6c:	ee26 9b0d 	vmul.f64	d9, d6, d13
10006b70:	ee35 8b08 	vadd.f64	d8, d5, d8
10006b74:	ee37 7b45 	vsub.f64	d7, d7, d5
10006b78:	ed9d 5b02 	vldr	d5, [sp, #8]
10006b7c:	ee38 8b03 	vadd.f64	d8, d8, d3
10006b80:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10006b84:	ee35 3b0c 	vadd.f64	d3, d5, d12
10006b88:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10006b8c:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10006b90:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10006b94:	ee35 5b00 	vadd.f64	d5, d5, d0
10006b98:	ee33 3b40 	vsub.f64	d3, d3, d0
10006b9c:	ee37 7b4b 	vsub.f64	d7, d7, d11
10006ba0:	ee28 0b0d 	vmul.f64	d0, d8, d13
10006ba4:	ee37 7b09 	vadd.f64	d7, d7, d9
10006ba8:	ee09 6b4c 	vmls.f64	d6, d9, d12
10006bac:	ee35 5b01 	vadd.f64	d5, d5, d1
10006bb0:	ee24 9b0d 	vmul.f64	d9, d4, d13
10006bb4:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10006bb8:	ee01 2b4c 	vmls.f64	d2, d1, d12
10006bbc:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10006bc0:	ee25 1b0d 	vmul.f64	d1, d5, d13
10006bc4:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10006bc8:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10006bcc:	ee33 3b4b 	vsub.f64	d3, d3, d11
10006bd0:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10006bd4:	ee00 8b4c 	vmls.f64	d8, d0, d12
10006bd8:	3510      	adds	r5, #16
10006bda:	ed84 8b00 	vstr	d8, [r4]
10006bde:	ee33 3b09 	vadd.f64	d3, d3, d9
10006be2:	ed05 2b02 	vstr	d2, [r5, #-8]
10006be6:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10006bea:	ee27 2b0d 	vmul.f64	d2, d7, d13
10006bee:	ee01 5b4c 	vmls.f64	d5, d1, d12
10006bf2:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10006bf6:	ee23 1b0d 	vmul.f64	d1, d3, d13
10006bfa:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10006bfe:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10006c02:	464b      	mov	r3, r9
10006c04:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10006c08:	ee02 7b4c 	vmls.f64	d7, d2, d12
10006c0c:	ed05 5b04 	vstr	d5, [r5, #-16]
10006c10:	ee09 4b4c 	vmls.f64	d4, d9, d12
10006c14:	ed09 7b02 	vstr	d7, [r9, #-8]
10006c18:	ee01 3b4c 	vmls.f64	d3, d1, d12
10006c1c:	ed83 6b00 	vstr	d6, [r3]
10006c20:	463b      	mov	r3, r7
10006c22:	3410      	adds	r4, #16
10006c24:	45a3      	cmp	fp, r4
10006c26:	ed07 3b02 	vstr	d3, [r7, #-8]
10006c2a:	f109 0910 	add.w	r9, r9, #16
10006c2e:	ed83 4b00 	vstr	d4, [r3]
10006c32:	f107 0710 	add.w	r7, r7, #16
10006c36:	f47f aea0 	bne.w	1000697a <fndsa_vect_FFT_fp64_exact+0xfa>
10006c3a:	e9dd 201a 	ldrd	r2, r0, [sp, #104]	@ 0x68
10006c3e:	4631      	mov	r1, r6
10006c40:	9b1c      	ldr	r3, [sp, #112]	@ 0x70
10006c42:	e00b      	b.n	10006c5c <fndsa_vect_FFT_fp64_exact+0x3dc>
10006c44:	f3af 8000 	nop.w
10006c48:	00000000 	.word	0x00000000
10006c4c:	3df00000 	.word	0x3df00000
10006c50:	00000000 	.word	0x00000000
10006c54:	41f00000 	.word	0x41f00000
10006c58:	300039a0 	.word	0x300039a0
10006c5c:	9c1e      	ldr	r4, [sp, #120]	@ 0x78
10006c5e:	3310      	adds	r3, #16
10006c60:	429c      	cmp	r4, r3
10006c62:	4402      	add	r2, r0
10006c64:	eb01 1100 	add.w	r1, r1, r0, lsl #4
10006c68:	eb0b 1b00 	add.w	fp, fp, r0, lsl #4
10006c6c:	f47f ae42 	bne.w	100068f4 <fndsa_vect_FFT_fp64_exact+0x74>
10006c70:	9c21      	ldr	r4, [sp, #132]	@ 0x84
10006c72:	9b23      	ldr	r3, [sp, #140]	@ 0x8c
10006c74:	3401      	adds	r4, #1
10006c76:	42a3      	cmp	r3, r4
10006c78:	f8dd e074 	ldr.w	lr, [sp, #116]	@ 0x74
10006c7c:	f47f ae1c 	bne.w	100068b8 <fndsa_vect_FFT_fp64_exact+0x38>
10006c80:	b051      	add	sp, #324	@ 0x144
10006c82:	ecbd 8b10 	vpop	{d8-d15}
10006c86:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10006c8a:	4770      	bx	lr
