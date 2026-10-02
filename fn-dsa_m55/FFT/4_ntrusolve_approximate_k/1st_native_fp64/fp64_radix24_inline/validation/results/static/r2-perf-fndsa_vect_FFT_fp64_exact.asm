
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/r2-perf/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10006a10 <fndsa_vect_FFT_fp64_exact>:
10006a10:	2801      	cmp	r0, #1
10006a12:	f240 8263 	bls.w	10006edc <fndsa_vect_FFT_fp64_exact+0x4cc>
10006a16:	2201      	movs	r2, #1
10006a18:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10006a1c:	ed2d 8b10 	vpush	{d8-d15}
10006a20:	2310      	movs	r3, #16
10006a22:	460e      	mov	r6, r1
10006a24:	ed9f cb6c 	vldr	d12, [pc, #432]	@ 10006bd8 <fndsa_vect_FFT_fp64_exact+0x1c8>
10006a28:	ed9f bb6d 	vldr	d11, [pc, #436]	@ 10006be0 <fndsa_vect_FFT_fp64_exact+0x1d0>
10006a2c:	4614      	mov	r4, r2
10006a2e:	b0d7      	sub	sp, #348	@ 0x15c
10006a30:	9113      	str	r1, [sp, #76]	@ 0x4c
10006a32:	1e41      	subs	r1, r0, #1
10006a34:	408b      	lsls	r3, r1
10006a36:	18f7      	adds	r7, r6, r3
10006a38:	e9cd 7016 	strd	r7, r0, [sp, #88]	@ 0x58
10006a3c:	fa02 fe01 	lsl.w	lr, r2, r1
10006a40:	2701      	movs	r7, #1
10006a42:	2310      	movs	r3, #16
10006a44:	2200      	movs	r2, #0
10006a46:	9d13      	ldr	r5, [sp, #76]	@ 0x4c
10006a48:	4670      	mov	r0, lr
10006a4a:	fa2e fe07 	lsr.w	lr, lr, r7
10006a4e:	ea4f 1c0e 	mov.w	ip, lr, lsl #4
10006a52:	eb05 1b0e 	add.w	fp, r5, lr, lsl #4
10006a56:	f10c 0508 	add.w	r5, ip, #8
10006a5a:	9514      	str	r5, [sp, #80]	@ 0x50
10006a5c:	40a7      	lsls	r7, r4
10006a5e:	4d6c      	ldr	r5, [pc, #432]	@ (10006c10 <fndsa_vect_FFT_fp64_exact+0x200>)
10006a60:	40a3      	lsls	r3, r4
10006a62:	eb07 0757 	add.w	r7, r7, r7, lsr #1
10006a66:	442b      	add	r3, r5
10006a68:	eb05 1507 	add.w	r5, r5, r7, lsl #4
10006a6c:	e9cd e511 	strd	lr, r5, [sp, #68]	@ 0x44
10006a70:	9916      	ldr	r1, [sp, #88]	@ 0x58
10006a72:	f10d 0aa0 	add.w	sl, sp, #160	@ 0xa0
10006a76:	9415      	str	r4, [sp, #84]	@ 0x54
10006a78:	edd3 7a00 	vldr	s15, [r3]
10006a7c:	eeb8 9b67 	vcvt.f64.u32	d9, s15
10006a80:	edd3 7a02 	vldr	s15, [r3, #8]
10006a84:	eeb8 4b67 	vcvt.f64.u32	d4, s15
10006a88:	edd3 7a01 	vldr	s15, [r3, #4]
10006a8c:	eeb8 8b67 	vcvt.f64.u32	d8, s15
10006a90:	edd3 7a03 	vldr	s15, [r3, #12]
10006a94:	685c      	ldr	r4, [r3, #4]
10006a96:	ed9f ab54 	vldr	d10, [pc, #336]	@ 10006be8 <fndsa_vect_FFT_fp64_exact+0x1d8>
10006a9a:	0fe4      	lsrs	r4, r4, #31
10006a9c:	ee06 4a10 	vmov	s12, r4
10006aa0:	ee17 4a90 	vmov	r4, s15
10006aa4:	0fe4      	lsrs	r4, r4, #31
10006aa6:	ee29 3b0a 	vmul.f64	d3, d9, d10
10006aaa:	ee07 4a10 	vmov	s14, r4
10006aae:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10006ab2:	eeb8 0b67 	vcvt.f64.u32	d0, s15
10006ab6:	ed8d 6b40 	vstr	d6, [sp, #256]	@ 0x100
10006aba:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10006abe:	ee39 6b04 	vadd.f64	d6, d9, d4
10006ac2:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006ac6:	ed9f db4a 	vldr	d13, [pc, #296]	@ 10006bf0 <fndsa_vect_FFT_fp64_exact+0x1e0>
10006aca:	ed9f eb4b 	vldr	d14, [pc, #300]	@ 10006bf8 <fndsa_vect_FFT_fp64_exact+0x1e8>
10006ace:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10006ad2:	ed8d 7b4a 	vstr	d7, [sp, #296]	@ 0x128
10006ad6:	ee26 7b0c 	vmul.f64	d7, d6, d12
10006ada:	ee20 2b0d 	vmul.f64	d2, d0, d13
10006ade:	ee24 5b0a 	vmul.f64	d5, d4, d10
10006ae2:	ed8d 9b3e 	vstr	d9, [sp, #248]	@ 0xf8
10006ae6:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006aea:	ee03 9b4e 	vmls.f64	d9, d3, d14
10006aee:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006af2:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10006af6:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10006afa:	ed8d 9b38 	vstr	d9, [sp, #224]	@ 0xe0
10006afe:	ee38 9b00 	vadd.f64	d9, d8, d0
10006b02:	ee07 6b4b 	vmls.f64	d6, d7, d11
10006b06:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10006b0a:	ee39 7b07 	vadd.f64	d7, d9, d7
10006b0e:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10006b12:	ed9f 9b3b 	vldr	d9, [pc, #236]	@ 10006c00 <fndsa_vect_FFT_fp64_exact+0x1f0>
10006b16:	ed9f fb3c 	vldr	d15, [pc, #240]	@ 10006c08 <fndsa_vect_FFT_fp64_exact+0x1f8>
10006b1a:	ee02 0b49 	vmls.f64	d0, d2, d9
10006b1e:	ed8d 4b48 	vstr	d4, [sp, #288]	@ 0x120
10006b22:	ee05 4b4e 	vmls.f64	d4, d5, d14
10006b26:	ee00 5b0f 	vmla.f64	d5, d0, d15
10006b2a:	ed8d 4b42 	vstr	d4, [sp, #264]	@ 0x108
10006b2e:	ee27 4b0c 	vmul.f64	d4, d7, d12
10006b32:	ed8d 5b44 	vstr	d5, [sp, #272]	@ 0x110
10006b36:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10006b3a:	ee26 5b0a 	vmul.f64	d5, d6, d10
10006b3e:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10006b42:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10006b46:	ee04 7b4b 	vmls.f64	d7, d4, d11
10006b4a:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10006b4e:	ee27 4b0d 	vmul.f64	d4, d7, d13
10006b52:	ee28 1b0d 	vmul.f64	d1, d8, d13
10006b56:	ed8d 6b52 	vstr	d6, [sp, #328]	@ 0x148
10006b5a:	ee05 6b4e 	vmls.f64	d6, d5, d14
10006b5e:	ed8d 2b46 	vstr	d2, [sp, #280]	@ 0x118
10006b62:	eefc 2bc7 	vcvt.u32.f64	s5, d7
10006b66:	ed8d 6b4c 	vstr	d6, [sp, #304]	@ 0x130
10006b6a:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10006b6e:	eebc 6bc4 	vcvt.u32.f64	s12, d4
10006b72:	ee12 5a90 	vmov	r5, s5
10006b76:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10006b7a:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006b7e:	0fed      	lsrs	r5, r5, #31
10006b80:	ee01 8b49 	vmls.f64	d8, d1, d9
10006b84:	ee04 5a10 	vmov	s8, r5
10006b88:	ee06 7b49 	vmls.f64	d7, d6, d9
10006b8c:	ee08 3b0f 	vmla.f64	d3, d8, d15
10006b90:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
10006b94:	ee07 5b0f 	vmla.f64	d5, d7, d15
10006b98:	9c11      	ldr	r4, [sp, #68]	@ 0x44
10006b9a:	ed8d 1b3c 	vstr	d1, [sp, #240]	@ 0xf0
10006b9e:	4414      	add	r4, r2
10006ba0:	42a2      	cmp	r2, r4
10006ba2:	ed8d 3b3a 	vstr	d3, [sp, #232]	@ 0xe8
10006ba6:	ed8d 4b54 	vstr	d4, [sp, #336]	@ 0x150
10006baa:	ed8d 6b50 	vstr	d6, [sp, #320]	@ 0x140
10006bae:	ed8d 5b4e 	vstr	d5, [sp, #312]	@ 0x138
10006bb2:	f080 817c 	bcs.w	10006eae <fndsa_vect_FFT_fp64_exact+0x49e>
10006bb6:	9e14      	ldr	r6, [sp, #80]	@ 0x50
10006bb8:	eeb7 db00 	vmov.f64	d13, #112	@ 0x3f800000  1.0
10006bbc:	eb06 0801 	add.w	r8, r6, r1
10006bc0:	460d      	mov	r5, r1
10006bc2:	461e      	mov	r6, r3
10006bc4:	9c13      	ldr	r4, [sp, #76]	@ 0x4c
10006bc6:	e9cd 200e 	strd	r2, r0, [sp, #56]	@ 0x38
10006bca:	eb04 1402 	add.w	r4, r4, r2, lsl #4
10006bce:	f10b 0908 	add.w	r9, fp, #8
10006bd2:	af2c      	add	r7, sp, #176	@ 0xb0
10006bd4:	9110      	str	r1, [sp, #64]	@ 0x40
10006bd6:	e01d      	b.n	10006c14 <fndsa_vect_FFT_fp64_exact+0x204>
10006bd8:	00000000 	.word	0x00000000
10006bdc:	3df00000 	.word	0x3df00000
10006be0:	00000000 	.word	0x00000000
10006be4:	41f00000 	.word	0x41f00000
10006be8:	00000000 	.word	0x00000000
10006bec:	3e700000 	.word	0x3e700000
10006bf0:	00000000 	.word	0x00000000
10006bf4:	3ef00000 	.word	0x3ef00000
10006bf8:	00000000 	.word	0x00000000
10006bfc:	41700000 	.word	0x41700000
10006c00:	00000000 	.word	0x00000000
10006c04:	40f00000 	.word	0x40f00000
10006c08:	00000000 	.word	0x00000000
10006c0c:	40700000 	.word	0x40700000
10006c10:	300039a0 	.word	0x300039a0
10006c14:	ed95 3b00 	vldr	d3, [r5]
10006c18:	f1a9 0308 	sub.w	r3, r9, #8
10006c1c:	cb0f      	ldmia	r3, {r0, r1, r2, r3}
10006c1e:	e88a 000f 	stmia.w	sl, {r0, r1, r2, r3}
10006c22:	ed9d eb28 	vldr	d14, [sp, #160]	@ 0xa0
10006c26:	ed9d fb2a 	vldr	d15, [sp, #168]	@ 0xa8
10006c2a:	ed94 4b02 	vldr	d4, [r4, #8]
10006c2e:	ed94 8b00 	vldr	d8, [r4]
10006c32:	ed8d 3b00 	vstr	d3, [sp]
10006c36:	ed95 3b02 	vldr	d3, [r5, #8]
10006c3a:	f1a8 0c08 	sub.w	ip, r8, #8
10006c3e:	e89c 000f 	ldmia.w	ip, {r0, r1, r2, r3}
10006c42:	e887 000f 	stmia.w	r7, {r0, r1, r2, r3}
10006c46:	eeb0 0b4e 	vmov.f64	d0, d14
10006c4a:	eeb0 1b4f 	vmov.f64	d1, d15
10006c4e:	a838      	add	r0, sp, #224	@ 0xe0
10006c50:	ed9d 9b2c 	vldr	d9, [sp, #176]	@ 0xb0
10006c54:	ed8d 4b0c 	vstr	d4, [sp, #48]	@ 0x30
10006c58:	ed8d 3b0a 	vstr	d3, [sp, #40]	@ 0x28
10006c5c:	ed9d ab2e 	vldr	d10, [sp, #184]	@ 0xb8
10006c60:	ed8d 8b02 	vstr	d8, [sp, #8]
10006c64:	ed8d eb30 	vstr	d14, [sp, #192]	@ 0xc0
10006c68:	ed8d fb32 	vstr	d15, [sp, #200]	@ 0xc8
10006c6c:	f7ff fa58 	bl	10006120 <fp64e_mul24_prepared>
10006c70:	a842      	add	r0, sp, #264	@ 0x108
10006c72:	eeb0 8b41 	vmov.f64	d8, d1
10006c76:	ed8d 0b18 	vstr	d0, [sp, #96]	@ 0x60
10006c7a:	ed8d 0b08 	vstr	d0, [sp, #32]
10006c7e:	ed8d 1b1a 	vstr	d1, [sp, #104]	@ 0x68
10006c82:	eeb0 0b49 	vmov.f64	d0, d9
10006c86:	eeb0 1b4a 	vmov.f64	d1, d10
10006c8a:	ed8d 9b34 	vstr	d9, [sp, #208]	@ 0xd0
10006c8e:	ed8d ab36 	vstr	d10, [sp, #216]	@ 0xd8
10006c92:	f7ff fa45 	bl	10006120 <fp64e_mul24_prepared>
10006c96:	eeb0 6b41 	vmov.f64	d6, d1
10006c9a:	ee3f 1b0a 	vadd.f64	d1, d15, d10
10006c9e:	ee21 2b0c 	vmul.f64	d2, d1, d12
10006ca2:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10006ca6:	eeb0 7b40 	vmov.f64	d7, d0
10006caa:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10006cae:	ee3e 0b09 	vadd.f64	d0, d14, d9
10006cb2:	ee30 0b02 	vadd.f64	d0, d0, d2
10006cb6:	ee02 1b4b 	vmls.f64	d1, d2, d11
10006cba:	ee20 2b0c 	vmul.f64	d2, d0, d12
10006cbe:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10006cc2:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10006cc6:	ee02 0b4b 	vmls.f64	d0, d2, d11
10006cca:	a84c      	add	r0, sp, #304	@ 0x130
10006ccc:	ed8d 7b1c 	vstr	d7, [sp, #112]	@ 0x70
10006cd0:	ed8d 7b06 	vstr	d7, [sp, #24]
10006cd4:	ed8d 6b1e 	vstr	d6, [sp, #120]	@ 0x78
10006cd8:	ed8d 6b04 	vstr	d6, [sp, #16]
10006cdc:	ed8d 1b26 	vstr	d1, [sp, #152]	@ 0x98
10006ce0:	ed8d 0b24 	vstr	d0, [sp, #144]	@ 0x90
10006ce4:	f7ff fa1c 	bl	10006120 <fp64e_mul24_prepared>
10006ce8:	ed9d 6b04 	vldr	d6, [sp, #16]
10006cec:	ee38 2b06 	vadd.f64	d2, d8, d6
10006cf0:	ee22 9b0c 	vmul.f64	d9, d2, d12
10006cf4:	ed9d 7b06 	vldr	d7, [sp, #24]
10006cf8:	ed9d 5b08 	vldr	d5, [sp, #32]
10006cfc:	ee38 8b0b 	vadd.f64	d8, d8, d11
10006d00:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10006d04:	ee38 8b46 	vsub.f64	d8, d8, d6
10006d08:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10006d0c:	ee35 6b07 	vadd.f64	d6, d5, d7
10006d10:	ed8d 1b22 	vstr	d1, [sp, #136]	@ 0x88
10006d14:	ee36 6b09 	vadd.f64	d6, d6, d9
10006d18:	ee31 1b0b 	vadd.f64	d1, d1, d11
10006d1c:	ee09 2b4b 	vmls.f64	d2, d9, d11
10006d20:	ee35 5b0b 	vadd.f64	d5, d5, d11
10006d24:	ee31 2b42 	vsub.f64	d2, d1, d2
10006d28:	ee35 5b47 	vsub.f64	d5, d5, d7
10006d2c:	ee26 1b0c 	vmul.f64	d1, d6, d12
10006d30:	ee28 7b0c 	vmul.f64	d7, d8, d12
10006d34:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10006d38:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006d3c:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10006d40:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006d44:	ee35 5b4d 	vsub.f64	d5, d5, d13
10006d48:	ee07 8b4b 	vmls.f64	d8, d7, d11
10006d4c:	ee35 5b07 	vadd.f64	d5, d5, d7
10006d50:	ed8d 0b20 	vstr	d0, [sp, #128]	@ 0x80
10006d54:	ee22 7b0c 	vmul.f64	d7, d2, d12
10006d58:	ee30 0b0b 	vadd.f64	d0, d0, d11
10006d5c:	ee01 6b4b 	vmls.f64	d6, d1, d11
10006d60:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006d64:	ee25 1b0c 	vmul.f64	d1, d5, d12
10006d68:	ee30 6b46 	vsub.f64	d6, d0, d6
10006d6c:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006d70:	ee36 6b4d 	vsub.f64	d6, d6, d13
10006d74:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10006d78:	ee36 6b07 	vadd.f64	d6, d6, d7
10006d7c:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10006d80:	ee01 5b4b 	vmls.f64	d5, d1, d11
10006d84:	ee26 1b0c 	vmul.f64	d1, d6, d12
10006d88:	ed9d 4b0c 	vldr	d4, [sp, #48]	@ 0x30
10006d8c:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10006d90:	ed9d 3b0a 	vldr	d3, [sp, #40]	@ 0x28
10006d94:	ee07 2b4b 	vmls.f64	d2, d7, d11
10006d98:	ee34 0b0b 	vadd.f64	d0, d4, d11
10006d9c:	ee34 7b08 	vadd.f64	d7, d4, d8
10006da0:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10006da4:	ee30 4b48 	vsub.f64	d4, d0, d8
10006da8:	ee01 6b4b 	vmls.f64	d6, d1, d11
10006dac:	ee33 0b0b 	vadd.f64	d0, d3, d11
10006db0:	ee33 1b02 	vadd.f64	d1, d3, d2
10006db4:	ee27 3b0c 	vmul.f64	d3, d7, d12
10006db8:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006dbc:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10006dc0:	ed9d 8b02 	vldr	d8, [sp, #8]
10006dc4:	ee03 7b4b 	vmls.f64	d7, d3, d11
10006dc8:	ee24 9b0c 	vmul.f64	d9, d4, d12
10006dcc:	ed84 7b02 	vstr	d7, [r4, #8]
10006dd0:	ee38 7b0b 	vadd.f64	d7, d8, d11
10006dd4:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10006dd8:	ee38 8b05 	vadd.f64	d8, d8, d5
10006ddc:	ee37 7b45 	vsub.f64	d7, d7, d5
10006de0:	ee30 2b42 	vsub.f64	d2, d0, d2
10006de4:	ee38 8b03 	vadd.f64	d8, d8, d3
10006de8:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10006dec:	ed9d 3b00 	vldr	d3, [sp]
10006df0:	ee37 7b4d 	vsub.f64	d7, d7, d13
10006df4:	ee21 0b0c 	vmul.f64	d0, d1, d12
10006df8:	ee37 7b09 	vadd.f64	d7, d7, d9
10006dfc:	ee09 4b4b 	vmls.f64	d4, d9, d11
10006e00:	ee33 5b0b 	vadd.f64	d5, d3, d11
10006e04:	ee22 9b0c 	vmul.f64	d9, d2, d12
10006e08:	ee35 5b46 	vsub.f64	d5, d5, d6
10006e0c:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10006e10:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10006e14:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10006e18:	ee33 3b06 	vadd.f64	d3, d3, d6
10006e1c:	ee35 5b4d 	vsub.f64	d5, d5, d13
10006e20:	eeb8 6b49 	vcvt.f64.u32	d6, s18
10006e24:	ee33 3b00 	vadd.f64	d3, d3, d0
10006e28:	ee06 2b4b 	vmls.f64	d2, d6, d11
10006e2c:	ee35 6b06 	vadd.f64	d6, d5, d6
10006e30:	ee00 1b4b 	vmls.f64	d1, d0, d11
10006e34:	ee23 5b0c 	vmul.f64	d5, d3, d12
10006e38:	ee26 0b0c 	vmul.f64	d0, d6, d12
10006e3c:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10006e40:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10006e44:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10006e48:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10006e4c:	ee05 3b4b 	vmls.f64	d3, d5, d11
10006e50:	ee00 6b4b 	vmls.f64	d6, d0, d11
10006e54:	ee27 5b0c 	vmul.f64	d5, d7, d12
10006e58:	ee28 0b0c 	vmul.f64	d0, d8, d12
10006e5c:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10006e60:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10006e64:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10006e68:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10006e6c:	464b      	mov	r3, r9
10006e6e:	ee05 7b4b 	vmls.f64	d7, d5, d11
10006e72:	ee00 8b4b 	vmls.f64	d8, d0, d11
10006e76:	3510      	adds	r5, #16
10006e78:	ed84 8b00 	vstr	d8, [r4]
10006e7c:	ed05 3b04 	vstr	d3, [r5, #-16]
10006e80:	ed05 1b02 	vstr	d1, [r5, #-8]
10006e84:	ed09 7b02 	vstr	d7, [r9, #-8]
10006e88:	ed83 4b00 	vstr	d4, [r3]
10006e8c:	4643      	mov	r3, r8
10006e8e:	3410      	adds	r4, #16
10006e90:	45a3      	cmp	fp, r4
10006e92:	ed08 6b02 	vstr	d6, [r8, #-8]
10006e96:	f109 0910 	add.w	r9, r9, #16
10006e9a:	ed83 2b00 	vstr	d2, [r3]
10006e9e:	f108 0810 	add.w	r8, r8, #16
10006ea2:	f47f aeb7 	bne.w	10006c14 <fndsa_vect_FFT_fp64_exact+0x204>
10006ea6:	e9dd 200e 	ldrd	r2, r0, [sp, #56]	@ 0x38
10006eaa:	4633      	mov	r3, r6
10006eac:	9910      	ldr	r1, [sp, #64]	@ 0x40
10006eae:	9c12      	ldr	r4, [sp, #72]	@ 0x48
10006eb0:	3310      	adds	r3, #16
10006eb2:	429c      	cmp	r4, r3
10006eb4:	4402      	add	r2, r0
10006eb6:	eb01 1100 	add.w	r1, r1, r0, lsl #4
10006eba:	eb0b 1b00 	add.w	fp, fp, r0, lsl #4
10006ebe:	f47f addb 	bne.w	10006a78 <fndsa_vect_FFT_fp64_exact+0x68>
10006ec2:	9c15      	ldr	r4, [sp, #84]	@ 0x54
10006ec4:	9b17      	ldr	r3, [sp, #92]	@ 0x5c
10006ec6:	3401      	adds	r4, #1
10006ec8:	42a3      	cmp	r3, r4
10006eca:	f8dd e044 	ldr.w	lr, [sp, #68]	@ 0x44
10006ece:	f47f adb7 	bne.w	10006a40 <fndsa_vect_FFT_fp64_exact+0x30>
10006ed2:	b057      	add	sp, #348	@ 0x15c
10006ed4:	ecbd 8b10 	vpop	{d8-d15}
10006ed8:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10006edc:	4770      	bx	lr
