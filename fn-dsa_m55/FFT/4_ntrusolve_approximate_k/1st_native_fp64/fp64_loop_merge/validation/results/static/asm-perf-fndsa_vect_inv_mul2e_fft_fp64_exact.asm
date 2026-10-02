100069e0 <fndsa_vect_inv_mul2e_fft_fp64_exact>:
100069e0:	b5f0      	push	{r4, r5, r6, r7, lr}
100069e2:	2701      	movs	r7, #1
100069e4:	fa07 f202 	lsl.w	r2, r7, r2
100069e8:	ee07 2a90 	vmov	s15, r2
100069ec:	2410      	movs	r4, #16
100069ee:	ed2d 8b10 	vpush	{d8-d15}
100069f2:	2600      	movs	r6, #0
100069f4:	ed9f fbf8 	vldr	d15, [pc, #992]	@ 10006dd8 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x3f8>
100069f8:	ed9f ebf9 	vldr	d14, [pc, #996]	@ 10006de0 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x400>
100069fc:	460d      	mov	r5, r1
100069fe:	eeb8 bb67 	vcvt.f64.u32	d11, s15
10006a02:	3801      	subs	r0, #1
10006a04:	4084      	lsls	r4, r0
10006a06:	b091      	sub	sp, #68	@ 0x44
10006a08:	4087      	lsls	r7, r0
10006a0a:	440c      	add	r4, r1
10006a0c:	ed94 9b02 	vldr	d9, [r4, #8]
10006a10:	ed95 3b00 	vldr	d3, [r5]
10006a14:	ed95 6b02 	vldr	d6, [r5, #8]
10006a18:	ee3f 9b49 	vsub.f64	d9, d15, d9
10006a1c:	eebc abc3 	vcvt.u32.f64	s20, d3
10006a20:	ed94 5b00 	vldr	d5, [r4]
10006a24:	ee26 1b0e 	vmul.f64	d1, d6, d14
10006a28:	ee29 2b0e 	vmul.f64	d2, d9, d14
10006a2c:	ee1a 3a10 	vmov	r3, s20
10006a30:	eeb7 4b00 	vmov.f64	d4, #112	@ 0x3f800000  1.0
10006a34:	ed95 0b00 	vldr	d0, [r5]
10006a38:	ee26 3b01 	vmul.f64	d3, d6, d1
10006a3c:	ee3f 5b45 	vsub.f64	d5, d15, d5
10006a40:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10006a44:	0fdb      	lsrs	r3, r3, #31
10006a46:	ed95 7b00 	vldr	d7, [r5]
10006a4a:	ee35 5b44 	vsub.f64	d5, d5, d4
10006a4e:	ee20 1b01 	vmul.f64	d1, d0, d1
10006a52:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10006a56:	ee0a 3a10 	vmov	s20, r3
10006a5a:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006a5e:	ee35 cb02 	vadd.f64	d12, d5, d2
10006a62:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10006a66:	ee27 7b0e 	vmul.f64	d7, d7, d14
10006a6a:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10006a6e:	eeb8 abca 	vcvt.f64.s32	d10, s20
10006a72:	ee02 9b4f 	vmls.f64	d9, d2, d15
10006a76:	ee26 8b07 	vmul.f64	d8, d6, d7
10006a7a:	ee23 2b4f 	vnmul.f64	d2, d3, d15
10006a7e:	eea6 2b06 	vfma.f64	d2, d6, d6
10006a82:	ee20 7b07 	vmul.f64	d7, d0, d7
10006a86:	ee32 2b0f 	vadd.f64	d2, d2, d15
10006a8a:	ee2a 0b06 	vmul.f64	d0, d10, d6
10006a8e:	eeb8 ab41 	vcvt.f64.u32	d10, s2
10006a92:	ee2c 1b0e 	vmul.f64	d1, d12, d14
10006a96:	ee22 2b0e 	vmul.f64	d2, d2, d14
10006a9a:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10006a9e:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10006aa2:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10006aa6:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006aaa:	ee01 cb4f 	vmls.f64	d12, d1, d15
10006aae:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10006ab2:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006ab6:	ee32 2b03 	vadd.f64	d2, d2, d3
10006aba:	eebc 3bcc 	vcvt.u32.f64	s6, d12
10006abe:	ed95 5b00 	vldr	d5, [r5]
10006ac2:	ee27 7b4f 	vnmul.f64	d7, d7, d15
10006ac6:	eea5 7b05 	vfma.f64	d7, d5, d5
10006aca:	ee37 7b0f 	vadd.f64	d7, d7, d15
10006ace:	ee13 3a10 	vmov	r3, s6
10006ad2:	ee27 5b0e 	vmul.f64	d5, d7, d14
10006ad6:	0fdb      	lsrs	r3, r3, #31
10006ad8:	ee03 3a10 	vmov	s6, r3
10006adc:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10006ae0:	ee32 2b44 	vsub.f64	d2, d2, d4
10006ae4:	eeb8 3bc3 	vcvt.f64.s32	d3, s6
10006ae8:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10006aec:	ed8d 2b0c 	vstr	d2, [sp, #48]	@ 0x30
10006af0:	ee05 7b4f 	vmls.f64	d7, d5, d15
10006af4:	ee29 2b0e 	vmul.f64	d2, d9, d14
10006af8:	ee23 5b09 	vmul.f64	d5, d3, d9
10006afc:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10006b00:	ed8d 5b06 	vstr	d5, [sp, #24]
10006b04:	ee2c 3b0e 	vmul.f64	d3, d12, d14
10006b08:	ee22 5b09 	vmul.f64	d5, d2, d9
10006b0c:	ee22 2b0c 	vmul.f64	d2, d2, d12
10006b10:	ed8d 0b08 	vstr	d0, [sp, #32]
10006b14:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10006b18:	ee23 0b09 	vmul.f64	d0, d3, d9
10006b1c:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10006b20:	ee23 3b0c 	vmul.f64	d3, d3, d12
10006b24:	ed95 1b00 	vldr	d1, [r5]
10006b28:	ed8d 7b0e 	vstr	d7, [sp, #56]	@ 0x38
10006b2c:	eeb8 db42 	vcvt.f64.u32	d13, s4
10006b30:	ee28 7b4f 	vnmul.f64	d7, d8, d15
10006b34:	eea6 7b01 	vfma.f64	d7, d6, d1
10006b38:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006b3c:	ee2a 2b4f 	vnmul.f64	d2, d10, d15
10006b40:	eea1 2b06 	vfma.f64	d2, d1, d6
10006b44:	ee26 6b0b 	vmul.f64	d6, d6, d11
10006b48:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10006b4c:	ed8d 6b0a 	vstr	d6, [sp, #40]	@ 0x28
10006b50:	eeb8 6b43 	vcvt.f64.u32	d6, s6
10006b54:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10006b58:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10006b5c:	ee26 6b4f 	vnmul.f64	d6, d6, d15
10006b60:	eeac 6b0c 	vfma.f64	d6, d12, d12
10006b64:	ee36 3b0f 	vadd.f64	d3, d6, d15
10006b68:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10006b6c:	ed8d 3b04 	vstr	d3, [sp, #16]
10006b70:	ee25 3b4f 	vnmul.f64	d3, d5, d15
10006b74:	eea9 3b09 	vfma.f64	d3, d9, d9
10006b78:	ee33 3b0f 	vadd.f64	d3, d3, d15
10006b7c:	ee20 1b4f 	vnmul.f64	d1, d0, d15
10006b80:	eea9 1b0c 	vfma.f64	d1, d9, d12
10006b84:	ee23 3b0e 	vmul.f64	d3, d3, d14
10006b88:	ee31 1b0f 	vadd.f64	d1, d1, d15
10006b8c:	ed8d 8b00 	vstr	d8, [sp]
10006b90:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006b94:	ee21 8b0e 	vmul.f64	d8, d1, d14
10006b98:	ee37 7b0f 	vadd.f64	d7, d7, d15
10006b9c:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10006ba0:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10006ba4:	ee27 6b0e 	vmul.f64	d6, d7, d14
10006ba8:	ee33 3b05 	vadd.f64	d3, d3, d5
10006bac:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10006bb0:	ee33 3b44 	vsub.f64	d3, d3, d4
10006bb4:	ee32 2b0f 	vadd.f64	d2, d2, d15
10006bb8:	ee08 1b4f 	vmls.f64	d1, d8, d15
10006bbc:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006bc0:	ed8d ab02 	vstr	d10, [sp, #8]
10006bc4:	ee33 1b01 	vadd.f64	d1, d3, d1
10006bc8:	ed9d ab00 	vldr	d10, [sp]
10006bcc:	ee22 3b0e 	vmul.f64	d3, d2, d14
10006bd0:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006bd4:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006bd8:	ee06 7b4f 	vmls.f64	d7, d6, d15
10006bdc:	ee3a 6b06 	vadd.f64	d6, d10, d6
10006be0:	ed9d ab0c 	vldr	d10, [sp, #48]	@ 0x30
10006be4:	ee2d 5b4f 	vnmul.f64	d5, d13, d15
10006be8:	eeac 5b09 	vfma.f64	d5, d12, d9
10006bec:	ee3a 7b07 	vadd.f64	d7, d10, d7
10006bf0:	ee35 5b0f 	vadd.f64	d5, d5, d15
10006bf4:	ed9d ab02 	vldr	d10, [sp, #8]
10006bf8:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10006bfc:	ee30 8b08 	vadd.f64	d8, d0, d8
10006c00:	ee03 2b4f 	vmls.f64	d2, d3, d15
10006c04:	ee25 0b0e 	vmul.f64	d0, d5, d14
10006c08:	ee3a 3b03 	vadd.f64	d3, d10, d3
10006c0c:	ee36 6b44 	vsub.f64	d6, d6, d4
10006c10:	ee33 3b44 	vsub.f64	d3, d3, d4
10006c14:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10006c18:	ee36 6b03 	vadd.f64	d6, d6, d3
10006c1c:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10006c20:	ed9d 3b0e 	vldr	d3, [sp, #56]	@ 0x38
10006c24:	ee3d db00 	vadd.f64	d13, d13, d0
10006c28:	ee33 6b06 	vadd.f64	d6, d3, d6
10006c2c:	ed9d 3b04 	vldr	d3, [sp, #16]
10006c30:	ee38 8b44 	vsub.f64	d8, d8, d4
10006c34:	ee37 2b02 	vadd.f64	d2, d7, d2
10006c38:	ee3d db44 	vsub.f64	d13, d13, d4
10006c3c:	ee23 4b0e 	vmul.f64	d4, d3, d14
10006c40:	ee22 7b0e 	vmul.f64	d7, d2, d14
10006c44:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10006c48:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006c4c:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10006c50:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006c54:	ee04 3b4f 	vmls.f64	d3, d4, d15
10006c58:	ee00 5b4f 	vmls.f64	d5, d0, d15
10006c5c:	ee38 db0d 	vadd.f64	d13, d8, d13
10006c60:	ee31 5b05 	vadd.f64	d5, d1, d5
10006c64:	ee33 ab0d 	vadd.f64	d10, d3, d13
10006c68:	ee36 6b07 	vadd.f64	d6, d6, d7
10006c6c:	ed9f 3b5e 	vldr	d3, [pc, #376]	@ 10006de8 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x408>
10006c70:	ee07 2b4f 	vmls.f64	d2, d7, d15
10006c74:	ee25 4b0e 	vmul.f64	d4, d5, d14
10006c78:	ed9d 7b08 	vldr	d7, [sp, #32]
10006c7c:	ee36 6b03 	vadd.f64	d6, d6, d3
10006c80:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10006c84:	ee36 6b47 	vsub.f64	d6, d6, d7
10006c88:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10006c8c:	ee36 6b47 	vsub.f64	d6, d6, d7
10006c90:	ed9d 0b0a 	vldr	d0, [sp, #40]	@ 0x28
10006c94:	ee3a ab04 	vadd.f64	d10, d10, d4
10006c98:	ee20 7b0e 	vmul.f64	d7, d0, d14
10006c9c:	ee04 5b4f 	vmls.f64	d5, d4, d15
10006ca0:	ee26 4b0e 	vmul.f64	d4, d6, d14
10006ca4:	ee35 5b02 	vadd.f64	d5, d5, d2
10006ca8:	ee3a ab03 	vadd.f64	d10, d10, d3
10006cac:	eebc 2bc7 	vcvt.u32.f64	s4, d7
10006cb0:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10006cb4:	ed9d 7b06 	vldr	d7, [sp, #24]
10006cb8:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10006cbc:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10006cc0:	ee3a ab47 	vsub.f64	d10, d10, d7
10006cc4:	ee04 6b4f 	vmls.f64	d6, d4, d15
10006cc8:	ed95 8b00 	vldr	d8, [r5]
10006ccc:	ee3a 7b47 	vsub.f64	d7, d10, d7
10006cd0:	eeb0 4b42 	vmov.f64	d4, d2
10006cd4:	ee27 1b0e 	vmul.f64	d1, d7, d14
10006cd8:	ee08 4b0b 	vmla.f64	d4, d8, d11
10006cdc:	ee02 0b4f 	vmls.f64	d0, d2, d15
10006ce0:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10006ce4:	ee24 2b0e 	vmul.f64	d2, d4, d14
10006ce8:	eefc 1bc0 	vcvt.u32.f64	s3, d0
10006cec:	ee25 3b0e 	vmul.f64	d3, d5, d14
10006cf0:	ee11 0a90 	vmov	r0, s3
10006cf4:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10006cf8:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10006cfc:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10006d00:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006d04:	ee01 7b4f 	vmls.f64	d7, d1, d15
10006d08:	ee02 4b4f 	vmls.f64	d4, d2, d15
10006d0c:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10006d10:	ee37 7b06 	vadd.f64	d7, d7, d6
10006d14:	eefc 6bc4 	vcvt.u32.f64	s13, d4
10006d18:	ee37 7b03 	vadd.f64	d7, d7, d3
10006d1c:	ee16 1a90 	vmov	r1, s13
10006d20:	ee27 6b0e 	vmul.f64	d6, d7, d14
10006d24:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006d28:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006d2c:	ee03 5b4f 	vmls.f64	d5, d3, d15
10006d30:	ee06 7b4f 	vmls.f64	d7, d6, d15
10006d34:	eefc 5bc5 	vcvt.u32.f64	s11, d5
10006d38:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10006d3c:	ee15 2a90 	vmov	r2, s11
10006d40:	ee17 3a90 	vmov	r3, s15
10006d44:	edcd 5a02 	vstr	s11, [sp, #8]
10006d48:	edcd 7a00 	vstr	s15, [sp]
10006d4c:	f7ff fc70 	bl	10006630 <fxr_div_fp64_exact>
10006d50:	ee29 5b0b 	vmul.f64	d5, d9, d11
10006d54:	ee25 7b0e 	vmul.f64	d7, d5, d14
10006d58:	ee06 1a10 	vmov	s12, r1
10006d5c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006d60:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006d64:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006d68:	ed85 6b00 	vstr	d6, [r5]
10006d6c:	eeb0 6b47 	vmov.f64	d6, d7
10006d70:	ee0c 6b0b 	vmla.f64	d6, d12, d11
10006d74:	ee07 5b4f 	vmls.f64	d5, d7, d15
10006d78:	ee26 7b0e 	vmul.f64	d7, d6, d14
10006d7c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006d80:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006d84:	ee04 0a10 	vmov	s8, r0
10006d88:	ee07 6b4f 	vmls.f64	d6, d7, d15
10006d8c:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10006d90:	eefc 7bc6 	vcvt.u32.f64	s15, d6
10006d94:	eefc 5bc5 	vcvt.u32.f64	s11, d5
10006d98:	ed85 4b02 	vstr	d4, [r5, #8]
10006d9c:	ee17 1a90 	vmov	r1, s15
10006da0:	ee15 0a90 	vmov	r0, s11
10006da4:	9a02      	ldr	r2, [sp, #8]
10006da6:	9b00      	ldr	r3, [sp, #0]
10006da8:	f7ff fc42 	bl	10006630 <fxr_div_fp64_exact>
10006dac:	ee06 0a10 	vmov	s12, r0
10006db0:	ee07 1a10 	vmov	s14, r1
10006db4:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006db8:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006dbc:	3601      	adds	r6, #1
10006dbe:	42b7      	cmp	r7, r6
10006dc0:	f104 0410 	add.w	r4, r4, #16
10006dc4:	f105 0510 	add.w	r5, r5, #16
10006dc8:	ed04 6b02 	vstr	d6, [r4, #-8]
10006dcc:	ed04 7b04 	vstr	d7, [r4, #-16]
10006dd0:	f47f ae1c 	bne.w	10006a0c <fndsa_vect_inv_mul2e_fft_fp64_exact+0x2c>
10006dd4:	e00c      	b.n	10006df0 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x410>
10006dd6:	bf00      	nop
10006dd8:	00000000 	.word	0x00000000
10006ddc:	41f00000 	.word	0x41f00000
10006de0:	00000000 	.word	0x00000000
10006de4:	3df00000 	.word	0x3df00000
10006de8:	00000000 	.word	0x00000000
10006dec:	42000000 	.word	0x42000000
10006df0:	b011      	add	sp, #68	@ 0x44
10006df2:	ecbd 8b10 	vpop	{d8-d15}
10006df6:	bdf0      	pop	{r4, r5, r6, r7, pc}

