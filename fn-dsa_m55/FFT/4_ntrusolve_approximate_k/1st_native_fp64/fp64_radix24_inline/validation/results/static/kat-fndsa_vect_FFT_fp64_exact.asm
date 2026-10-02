
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/kat/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10005930 <fndsa_vect_FFT_fp64_exact>:
10005930:	2801      	cmp	r0, #1
10005932:	f240 8187 	bls.w	10005c44 <fndsa_vect_FFT_fp64_exact+0x314>
10005936:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
1000593a:	460f      	mov	r7, r1
1000593c:	2101      	movs	r1, #1
1000593e:	ed2d 8b10 	vpush	{d8-d15}
10005942:	2210      	movs	r2, #16
10005944:	ed9f fbc0 	vldr	d15, [pc, #768]	@ 10005c48 <fndsa_vect_FFT_fp64_exact+0x318>
10005948:	ed9f ebc1 	vldr	d14, [pc, #772]	@ 10005c50 <fndsa_vect_FFT_fp64_exact+0x320>
1000594c:	ed9f dbc2 	vldr	d13, [pc, #776]	@ 10005c58 <fndsa_vect_FFT_fp64_exact+0x328>
10005950:	460c      	mov	r4, r1
10005952:	1e43      	subs	r3, r0, #1
10005954:	b0ad      	sub	sp, #180	@ 0xb4
10005956:	9005      	str	r0, [sp, #20]
10005958:	409a      	lsls	r2, r3
1000595a:	fa01 f003 	lsl.w	r0, r1, r3
1000595e:	2501      	movs	r5, #1
10005960:	f04f 0a10 	mov.w	sl, #16
10005964:	4ec6      	ldr	r6, [pc, #792]	@ (10005c80 <fndsa_vect_FFT_fp64_exact+0x350>)
10005966:	fa0a fa04 	lsl.w	sl, sl, r4
1000596a:	4680      	mov	r8, r0
1000596c:	40e8      	lsrs	r0, r5
1000596e:	eb07 1900 	add.w	r9, r7, r0, lsl #4
10005972:	9001      	str	r0, [sp, #4]
10005974:	9704      	str	r7, [sp, #16]
10005976:	eb0a 0006 	add.w	r0, sl, r6
1000597a:	eeb7 cb00 	vmov.f64	d12, #112	@ 0x3f800000  1.0
1000597e:	46ba      	mov	sl, r7
10005980:	4693      	mov	fp, r2
10005982:	2700      	movs	r7, #0
10005984:	40a5      	lsls	r5, r4
10005986:	eb05 0555 	add.w	r5, r5, r5, lsr #1
1000598a:	eb06 1505 	add.w	r5, r6, r5, lsl #4
1000598e:	e9cd 5402 	strd	r5, r4, [sp, #8]
10005992:	edd0 7a00 	vldr	s15, [r0]
10005996:	eeb8 1b67 	vcvt.f64.u32	d1, s15
1000599a:	edd0 7a02 	vldr	s15, [r0, #8]
1000599e:	eeb8 3b67 	vcvt.f64.u32	d3, s15
100059a2:	edd0 7a01 	vldr	s15, [r0, #4]
100059a6:	eeb8 6b67 	vcvt.f64.u32	d6, s15
100059aa:	edd0 7a03 	vldr	s15, [r0, #12]
100059ae:	6843      	ldr	r3, [r0, #4]
100059b0:	ee21 4b0f 	vmul.f64	d4, d1, d15
100059b4:	0fdb      	lsrs	r3, r3, #31
100059b6:	ee05 3a10 	vmov	s10, r3
100059ba:	ee17 3a90 	vmov	r3, s15
100059be:	0fdb      	lsrs	r3, r3, #31
100059c0:	ed9f 9ba7 	vldr	d9, [pc, #668]	@ 10005c60 <fndsa_vect_FFT_fp64_exact+0x330>
100059c4:	ee07 3a10 	vmov	s14, r3
100059c8:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100059cc:	eeb8 2b67 	vcvt.f64.u32	d2, s15
100059d0:	ee26 0b09 	vmul.f64	d0, d6, d9
100059d4:	ed9f aba4 	vldr	d10, [pc, #656]	@ 10005c68 <fndsa_vect_FFT_fp64_exact+0x338>
100059d8:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100059dc:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100059e0:	ed8d 7b20 	vstr	d7, [sp, #128]	@ 0x80
100059e4:	ed8d 1b14 	vstr	d1, [sp, #80]	@ 0x50
100059e8:	ee31 7b03 	vadd.f64	d7, d1, d3
100059ec:	eebc 0bc0 	vcvt.u32.f64	s0, d0
100059f0:	ee04 1b4a 	vmls.f64	d1, d4, d10
100059f4:	eeb8 0b40 	vcvt.f64.u32	d0, s0
100059f8:	ed9f bb9d 	vldr	d11, [pc, #628]	@ 10005c70 <fndsa_vect_FFT_fp64_exact+0x340>
100059fc:	ed8d 1b0e 	vstr	d1, [sp, #56]	@ 0x38
10005a00:	eeb0 1b46 	vmov.f64	d1, d6
10005a04:	ed8d 0b12 	vstr	d0, [sp, #72]	@ 0x48
10005a08:	ee00 1b4b 	vmls.f64	d1, d0, d11
10005a0c:	ed9f 0b9a 	vldr	d0, [pc, #616]	@ 10005c78 <fndsa_vect_FFT_fp64_exact+0x348>
10005a10:	ee22 8b09 	vmul.f64	d8, d2, d9
10005a14:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
10005a18:	ee01 4b00 	vmla.f64	d4, d1, d0
10005a1c:	ed8d 5b16 	vstr	d5, [sp, #88]	@ 0x58
10005a20:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10005a24:	ee23 5b0f 	vmul.f64	d5, d3, d15
10005a28:	ed8d 4b10 	vstr	d4, [sp, #64]	@ 0x40
10005a2c:	ee27 4b0e 	vmul.f64	d4, d7, d14
10005a30:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10005a34:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10005a38:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10005a3c:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10005a40:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10005a44:	ee36 6b02 	vadd.f64	d6, d6, d2
10005a48:	ee08 2b4b 	vmls.f64	d2, d8, d11
10005a4c:	ee36 6b04 	vadd.f64	d6, d6, d4
10005a50:	ed8d 3b1e 	vstr	d3, [sp, #120]	@ 0x78
10005a54:	ee05 3b4a 	vmls.f64	d3, d5, d10
10005a58:	ee02 5b00 	vmla.f64	d5, d2, d0
10005a5c:	ed8d 5b1a 	vstr	d5, [sp, #104]	@ 0x68
10005a60:	ee26 5b0e 	vmul.f64	d5, d6, d14
10005a64:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10005a68:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10005a6c:	ee05 6b4d 	vmls.f64	d6, d5, d13
10005a70:	ee04 7b4d 	vmls.f64	d7, d4, d13
10005a74:	ee26 5b09 	vmul.f64	d5, d6, d9
10005a78:	eebc 4bc6 	vcvt.u32.f64	s8, d6
10005a7c:	ed8d 3b18 	vstr	d3, [sp, #96]	@ 0x60
10005a80:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10005a84:	eeb0 3b47 	vmov.f64	d3, d7
10005a88:	ee27 7b0f 	vmul.f64	d7, d7, d15
10005a8c:	9b01      	ldr	r3, [sp, #4]
10005a8e:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10005a92:	19d9      	adds	r1, r3, r7
10005a94:	ee14 3a10 	vmov	r3, s8
10005a98:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005a9c:	0fdb      	lsrs	r3, r3, #31
10005a9e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005aa2:	ee04 3a10 	vmov	s8, r3
10005aa6:	ee05 6b4b 	vmls.f64	d6, d5, d11
10005aaa:	ed8d 3b28 	vstr	d3, [sp, #160]	@ 0xa0
10005aae:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
10005ab2:	ee07 3b4a 	vmls.f64	d3, d7, d10
10005ab6:	ee06 7b00 	vmla.f64	d7, d6, d0
10005aba:	428f      	cmp	r7, r1
10005abc:	ed8d 8b1c 	vstr	d8, [sp, #112]	@ 0x70
10005ac0:	ed8d 3b22 	vstr	d3, [sp, #136]	@ 0x88
10005ac4:	ed8d 4b2a 	vstr	d4, [sp, #168]	@ 0xa8
10005ac8:	ed8d 5b26 	vstr	d5, [sp, #152]	@ 0x98
10005acc:	ed8d 7b24 	vstr	d7, [sp, #144]	@ 0x90
10005ad0:	f080 80a0 	bcs.w	10005c14 <fndsa_vect_FFT_fp64_exact+0x2e4>
10005ad4:	4649      	mov	r1, r9
10005ad6:	4654      	mov	r4, sl
10005ad8:	eb0b 050a 	add.w	r5, fp, sl
10005adc:	eb0b 0609 	add.w	r6, fp, r9
10005ae0:	9000      	str	r0, [sp, #0]
10005ae2:	ed91 0b00 	vldr	d0, [r1]
10005ae6:	ed91 1b02 	vldr	d1, [r1, #8]
10005aea:	ed96 2b00 	vldr	d2, [r6]
10005aee:	ed96 3b02 	vldr	d3, [r6, #8]
10005af2:	a80e      	add	r0, sp, #56	@ 0x38
10005af4:	f7ff f89c 	bl	10004c30 <fp64e_cmul_prepared>
10005af8:	ed94 9b02 	vldr	d9, [r4, #8]
10005afc:	ee39 7b0d 	vadd.f64	d7, d9, d13
10005b00:	ee39 9b01 	vadd.f64	d9, d9, d1
10005b04:	ed95 ab02 	vldr	d10, [r5, #8]
10005b08:	ee29 5b0e 	vmul.f64	d5, d9, d14
10005b0c:	ed94 8b00 	vldr	d8, [r4]
10005b10:	ee3a 6b0d 	vadd.f64	d6, d10, d13
10005b14:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10005b18:	ee3a ab03 	vadd.f64	d10, d10, d3
10005b1c:	ee36 6b43 	vsub.f64	d6, d6, d3
10005b20:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10005b24:	ed8d 3b0c 	vstr	d3, [sp, #48]	@ 0x30
10005b28:	ee38 3b0d 	vadd.f64	d3, d8, d13
10005b2c:	ee38 8b00 	vadd.f64	d8, d8, d0
10005b30:	ed95 bb00 	vldr	d11, [r5]
10005b34:	ee2a 4b0e 	vmul.f64	d4, d10, d14
10005b38:	ee05 9b4d 	vmls.f64	d9, d5, d13
10005b3c:	ee38 8b05 	vadd.f64	d8, d8, d5
10005b40:	ee26 5b0e 	vmul.f64	d5, d6, d14
10005b44:	ee33 3b40 	vsub.f64	d3, d3, d0
10005b48:	ed8d 0b06 	vstr	d0, [sp, #24]
10005b4c:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10005b50:	eefc 0bc5 	vcvt.u32.f64	s1, d5
10005b54:	ee3b 5b0d 	vadd.f64	d5, d11, d13
10005b58:	ed84 9b02 	vstr	d9, [r4, #8]
10005b5c:	ee37 7b41 	vsub.f64	d7, d7, d1
10005b60:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10005b64:	eeb0 9b4a 	vmov.f64	d9, d10
10005b68:	ee35 5b42 	vsub.f64	d5, d5, d2
10005b6c:	ed8d 1b08 	vstr	d1, [sp, #32]
10005b70:	ee3b 1b02 	vadd.f64	d1, d11, d2
10005b74:	ee27 ab0e 	vmul.f64	d10, d7, d14
10005b78:	ee31 1b04 	vadd.f64	d1, d1, d4
10005b7c:	ee04 9b4d 	vmls.f64	d9, d4, d13
10005b80:	ee35 5b4c 	vsub.f64	d5, d5, d12
10005b84:	eeb8 4b60 	vcvt.f64.u32	d4, s1
10005b88:	eebc abca 	vcvt.u32.f64	s20, d10
10005b8c:	ee35 5b04 	vadd.f64	d5, d5, d4
10005b90:	ee04 6b4d 	vmls.f64	d6, d4, d13
10005b94:	ee21 4b0e 	vmul.f64	d4, d1, d14
10005b98:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10005b9c:	ee33 3b4c 	vsub.f64	d3, d3, d12
10005ba0:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10005ba4:	ee33 3b0a 	vadd.f64	d3, d3, d10
10005ba8:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10005bac:	ee04 1b4d 	vmls.f64	d1, d4, d13
10005bb0:	ee23 4b0e 	vmul.f64	d4, d3, d14
10005bb4:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10005bb8:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10005bbc:	ed8d 2b0a 	vstr	d2, [sp, #40]	@ 0x28
10005bc0:	ee04 3b4d 	vmls.f64	d3, d4, d13
10005bc4:	ee25 2b0e 	vmul.f64	d2, d5, d14
10005bc8:	ee28 4b0e 	vmul.f64	d4, d8, d14
10005bcc:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10005bd0:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10005bd4:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10005bd8:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10005bdc:	ee0a 7b4d 	vmls.f64	d7, d10, d13
10005be0:	ee02 5b4d 	vmls.f64	d5, d2, d13
10005be4:	ee04 8b4d 	vmls.f64	d8, d4, d13
10005be8:	3410      	adds	r4, #16
10005bea:	3510      	adds	r5, #16
10005bec:	3110      	adds	r1, #16
10005bee:	3610      	adds	r6, #16
10005bf0:	45a1      	cmp	r9, r4
10005bf2:	ed04 8b04 	vstr	d8, [r4, #-16]
10005bf6:	ed05 1b04 	vstr	d1, [r5, #-16]
10005bfa:	ed05 9b02 	vstr	d9, [r5, #-8]
10005bfe:	ed01 3b04 	vstr	d3, [r1, #-16]
10005c02:	ed01 7b02 	vstr	d7, [r1, #-8]
10005c06:	ed06 5b04 	vstr	d5, [r6, #-16]
10005c0a:	ed06 6b02 	vstr	d6, [r6, #-8]
10005c0e:	f47f af68 	bne.w	10005ae2 <fndsa_vect_FFT_fp64_exact+0x1b2>
10005c12:	9800      	ldr	r0, [sp, #0]
10005c14:	9b02      	ldr	r3, [sp, #8]
10005c16:	3010      	adds	r0, #16
10005c18:	4283      	cmp	r3, r0
10005c1a:	4447      	add	r7, r8
10005c1c:	eb0a 1a08 	add.w	sl, sl, r8, lsl #4
10005c20:	eb09 1908 	add.w	r9, r9, r8, lsl #4
10005c24:	f47f aeb5 	bne.w	10005992 <fndsa_vect_FFT_fp64_exact+0x62>
10005c28:	9c03      	ldr	r4, [sp, #12]
10005c2a:	9b05      	ldr	r3, [sp, #20]
10005c2c:	3401      	adds	r4, #1
10005c2e:	42a3      	cmp	r3, r4
10005c30:	465a      	mov	r2, fp
10005c32:	9801      	ldr	r0, [sp, #4]
10005c34:	9f04      	ldr	r7, [sp, #16]
10005c36:	f47f ae92 	bne.w	1000595e <fndsa_vect_FFT_fp64_exact+0x2e>
10005c3a:	b02d      	add	sp, #180	@ 0xb4
10005c3c:	ecbd 8b10 	vpop	{d8-d15}
10005c40:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10005c44:	4770      	bx	lr
10005c46:	bf00      	nop
10005c48:	00000000 	.word	0x00000000
10005c4c:	3e700000 	.word	0x3e700000
10005c50:	00000000 	.word	0x00000000
10005c54:	3df00000 	.word	0x3df00000
10005c58:	00000000 	.word	0x00000000
10005c5c:	41f00000 	.word	0x41f00000
10005c60:	00000000 	.word	0x00000000
10005c64:	3ef00000 	.word	0x3ef00000
10005c68:	00000000 	.word	0x00000000
10005c6c:	41700000 	.word	0x41700000
10005c70:	00000000 	.word	0x00000000
10005c74:	40f00000 	.word	0x40f00000
10005c78:	00000000 	.word	0x00000000
10005c7c:	40700000 	.word	0x40700000
10005c80:	300039a0 	.word	0x300039a0
