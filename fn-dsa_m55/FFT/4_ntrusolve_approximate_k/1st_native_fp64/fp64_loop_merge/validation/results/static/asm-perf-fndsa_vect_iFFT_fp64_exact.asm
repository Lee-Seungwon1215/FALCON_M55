10007928 <fndsa_vect_iFFT_fp64_exact>:
10007928:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
1000792c:	ed2d 8b10 	vpush	{d8-d15}
10007930:	2802      	cmp	r0, #2
10007932:	460d      	mov	r5, r1
10007934:	b0e5      	sub	sp, #404	@ 0x194
10007936:	f100 3aff 	add.w	sl, r0, #4294967295	@ 0xffffffff
1000793a:	f241 831c 	bls.w	10008f76 <fndsa_vect_iFFT_fp64_exact+0x164e>
1000793e:	2301      	movs	r3, #1
10007940:	2410      	movs	r4, #16
10007942:	4683      	mov	fp, r0
10007944:	ed9f fbf8 	vldr	d15, [pc, #992]	@ 10007d28 <fndsa_vect_iFFT_fp64_exact+0x400>
10007948:	ed9f ebf9 	vldr	d14, [pc, #996]	@ 10007d30 <fndsa_vect_iFFT_fp64_exact+0x408>
1000794c:	fa03 f30a 	lsl.w	r3, r3, sl
10007950:	4efb      	ldr	r6, [pc, #1004]	@ (10007d40 <fndsa_vect_iFFT_fp64_exact+0x418>)
10007952:	1e5a      	subs	r2, r3, #1
10007954:	fa04 f40a 	lsl.w	r4, r4, sl
10007958:	f101 0840 	add.w	r8, r1, #64	@ 0x40
1000795c:	085b      	lsrs	r3, r3, #1
1000795e:	0892      	lsrs	r2, r2, #2
10007960:	eb06 1703 	add.w	r7, r6, r3, lsl #4
10007964:	eb08 1882 	add.w	r8, r8, r2, lsl #6
10007968:	4426      	add	r6, r4
1000796a:	440c      	add	r4, r1
1000796c:	edd6 7a02 	vldr	s15, [r6, #8]
10007970:	eeb8 db67 	vcvt.f64.u32	d13, s15
10007974:	edd6 7a03 	vldr	s15, [r6, #12]
10007978:	6873      	ldr	r3, [r6, #4]
1000797a:	eeb8 2b67 	vcvt.f64.u32	d2, s15
1000797e:	0fdb      	lsrs	r3, r3, #31
10007980:	ee08 3a10 	vmov	s16, r3
10007984:	ed91 9b0a 	vldr	d9, [r1, #40]	@ 0x28
10007988:	edd6 7a00 	vldr	s15, [r6]
1000798c:	eeb8 8bc8 	vcvt.f64.s32	d8, s16
10007990:	eeb7 0b00 	vmov.f64	d0, #112	@ 0x3f800000  1.0
10007994:	ee3e 2b42 	vsub.f64	d2, d14, d2
10007998:	ed91 4b02 	vldr	d4, [r1, #8]
1000799c:	ed91 bb0e 	vldr	d11, [r1, #56]	@ 0x38
100079a0:	ed94 ab0a 	vldr	d10, [r4, #40]	@ 0x28
100079a4:	eeb8 6b67 	vcvt.f64.u32	d6, s15
100079a8:	ee32 2b40 	vsub.f64	d2, d2, d0
100079ac:	edd6 7a01 	vldr	s15, [r6, #4]
100079b0:	ed8d 8b4e 	vstr	d8, [sp, #312]	@ 0x138
100079b4:	ee39 8b0e 	vadd.f64	d8, d9, d14
100079b8:	ed91 3b06 	vldr	d3, [r1, #24]
100079bc:	ed94 5b02 	vldr	d5, [r4, #8]
100079c0:	ed94 cb0e 	vldr	d12, [r4, #56]	@ 0x38
100079c4:	eeb8 7b67 	vcvt.f64.u32	d7, s15
100079c8:	ee39 9b0b 	vadd.f64	d9, d9, d11
100079cc:	ee3a 0b0e 	vadd.f64	d0, d10, d14
100079d0:	ee38 bb4b 	vsub.f64	d11, d8, d11
100079d4:	ed8d 2b12 	vstr	d2, [sp, #72]	@ 0x48
100079d8:	ed91 8b00 	vldr	d8, [r1]
100079dc:	ee34 2b0e 	vadd.f64	d2, d4, d14
100079e0:	ed94 1b06 	vldr	d1, [r4, #24]
100079e4:	ee33 4b04 	vadd.f64	d4, d3, d4
100079e8:	ee32 2b43 	vsub.f64	d2, d2, d3
100079ec:	ee3a ab0c 	vadd.f64	d10, d10, d12
100079f0:	ed8d 7b00 	vstr	d7, [sp]
100079f4:	ee30 cb4c 	vsub.f64	d12, d0, d12
100079f8:	ed8d 7b46 	vstr	d7, [sp, #280]	@ 0x118
100079fc:	ee35 3b0e 	vadd.f64	d3, d5, d14
10007a00:	ed91 7b00 	vldr	d7, [r1]
10007a04:	ee38 0b0e 	vadd.f64	d0, d8, d14
10007a08:	ed91 8b04 	vldr	d8, [r1, #16]
10007a0c:	ee35 5b01 	vadd.f64	d5, d5, d1
10007a10:	ee33 3b41 	vsub.f64	d3, d3, d1
10007a14:	ee38 8b07 	vadd.f64	d8, d8, d7
10007a18:	ee22 1b0f 	vmul.f64	d1, d2, d15
10007a1c:	ed8d 8b02 	vstr	d8, [sp, #8]
10007a20:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10007a24:	ed91 8b04 	vldr	d8, [r1, #16]
10007a28:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10007a2c:	eeb7 7b00 	vmov.f64	d7, #112	@ 0x3f800000  1.0
10007a30:	ee30 0b48 	vsub.f64	d0, d0, d8
10007a34:	ee01 2b4e 	vmls.f64	d2, d1, d14
10007a38:	ee30 0b47 	vsub.f64	d0, d0, d7
10007a3c:	ed94 8b00 	vldr	d8, [r4]
10007a40:	ee30 0b01 	vadd.f64	d0, d0, d1
10007a44:	ee32 1b07 	vadd.f64	d1, d2, d7
10007a48:	ee23 2b0f 	vmul.f64	d2, d3, d15
10007a4c:	ed94 7b04 	vldr	d7, [r4, #16]
10007a50:	ed8d 1b0c 	vstr	d1, [sp, #48]	@ 0x30
10007a54:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10007a58:	ee38 1b0e 	vadd.f64	d1, d8, d14
10007a5c:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10007a60:	ee38 8b07 	vadd.f64	d8, d8, d7
10007a64:	ee31 1b47 	vsub.f64	d1, d1, d7
10007a68:	eeb7 7b00 	vmov.f64	d7, #112	@ 0x3f800000  1.0
10007a6c:	ee02 3b4e 	vmls.f64	d3, d2, d14
10007a70:	ee31 1b47 	vsub.f64	d1, d1, d7
10007a74:	ee31 1b02 	vadd.f64	d1, d1, d2
10007a78:	ee33 2b07 	vadd.f64	d2, d3, d7
10007a7c:	ee24 3b0f 	vmul.f64	d3, d4, d15
10007a80:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10007a84:	ed8d 2b0a 	vstr	d2, [sp, #40]	@ 0x28
10007a88:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10007a8c:	ee25 2b0f 	vmul.f64	d2, d5, d15
10007a90:	ed8d 8b04 	vstr	d8, [sp, #16]
10007a94:	ee03 4b4e 	vmls.f64	d4, d3, d14
10007a98:	ed9d 8b02 	vldr	d8, [sp, #8]
10007a9c:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10007aa0:	ee38 8b03 	vadd.f64	d8, d8, d3
10007aa4:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10007aa8:	eeb0 3b47 	vmov.f64	d3, d7
10007aac:	ee34 7b07 	vadd.f64	d7, d4, d7
10007ab0:	ed9d 4b04 	vldr	d4, [sp, #16]
10007ab4:	ee02 5b4e 	vmls.f64	d5, d2, d14
10007ab8:	ee34 4b02 	vadd.f64	d4, d4, d2
10007abc:	ee35 5b03 	vadd.f64	d5, d5, d3
10007ac0:	ed8d 4b02 	vstr	d4, [sp, #8]
10007ac4:	ee29 4b0f 	vmul.f64	d4, d9, d15
10007ac8:	ed8d 6b48 	vstr	d6, [sp, #288]	@ 0x120
10007acc:	ed8d 7b10 	vstr	d7, [sp, #64]	@ 0x40
10007ad0:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10007ad4:	ed8d 5b0e 	vstr	d5, [sp, #56]	@ 0x38
10007ad8:	ee2a 5b0f 	vmul.f64	d5, d10, d15
10007adc:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10007ae0:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10007ae4:	ee04 9b4e 	vmls.f64	d9, d4, d14
10007ae8:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10007aec:	ee39 7b03 	vadd.f64	d7, d9, d3
10007af0:	ee05 ab4e 	vmls.f64	d10, d5, d14
10007af4:	ed8d 7b08 	vstr	d7, [sp, #32]
10007af8:	ee3a 2b03 	vadd.f64	d2, d10, d3
10007afc:	ed91 7b0c 	vldr	d7, [r1, #48]	@ 0x30
10007b00:	ed91 ab08 	vldr	d10, [r1, #32]
10007b04:	ed91 3b08 	vldr	d3, [r1, #32]
10007b08:	ee2b 9b0f 	vmul.f64	d9, d11, d15
10007b0c:	ed8d 2b06 	vstr	d2, [sp, #24]
10007b10:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10007b14:	ee3a 2b07 	vadd.f64	d2, d10, d7
10007b18:	ee33 3b0e 	vadd.f64	d3, d3, d14
10007b1c:	ee32 2b04 	vadd.f64	d2, d2, d4
10007b20:	ee33 3b47 	vsub.f64	d3, d3, d7
10007b24:	eeb7 4b00 	vmov.f64	d4, #112	@ 0x3f800000  1.0
10007b28:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10007b2c:	ee33 3b44 	vsub.f64	d3, d3, d4
10007b30:	ee09 bb4e 	vmls.f64	d11, d9, d14
10007b34:	ee33 9b09 	vadd.f64	d9, d3, d9
10007b38:	ee3b 3b04 	vadd.f64	d3, d11, d4
10007b3c:	ed8d 3b04 	vstr	d3, [sp, #16]
10007b40:	ed94 3b08 	vldr	d3, [r4, #32]
10007b44:	eeb0 7b44 	vmov.f64	d7, d4
10007b48:	ed94 bb0c 	vldr	d11, [r4, #48]	@ 0x30
10007b4c:	ee2c ab0f 	vmul.f64	d10, d12, d15
10007b50:	ee33 4b0e 	vadd.f64	d4, d3, d14
10007b54:	ee3e db4d 	vsub.f64	d13, d14, d13
10007b58:	ee33 3b0b 	vadd.f64	d3, d3, d11
10007b5c:	ee34 4b4b 	vsub.f64	d4, d4, d11
10007b60:	eebc abca 	vcvt.u32.f64	s20, d10
10007b64:	ee34 4b47 	vsub.f64	d4, d4, d7
10007b68:	ee33 3b05 	vadd.f64	d3, d3, d5
10007b6c:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10007b70:	ee2d 5b0f 	vmul.f64	d5, d13, d15
10007b74:	ee0a cb4e 	vmls.f64	d12, d10, d14
10007b78:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10007b7c:	ee34 ab0a 	vadd.f64	d10, d4, d10
10007b80:	ee20 4b0f 	vmul.f64	d4, d0, d15
10007b84:	ee3c cb07 	vadd.f64	d12, d12, d7
10007b88:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10007b8c:	eefc 7bc4 	vcvt.u32.f64	s15, d4
10007b90:	ed9d bb12 	vldr	d11, [sp, #72]	@ 0x48
10007b94:	ee05 db4e 	vmls.f64	d13, d5, d14
10007b98:	ee3b bb05 	vadd.f64	d11, d11, d5
10007b9c:	eeb8 5b67 	vcvt.f64.u32	d5, s15
10007ba0:	ed9f 7b65 	vldr	d7, [pc, #404]	@ 10007d38 <fndsa_vect_iFFT_fp64_exact+0x410>
10007ba4:	ee05 0b4e 	vmls.f64	d0, d5, d14
10007ba8:	ee21 5b0f 	vmul.f64	d5, d1, d15
10007bac:	ee30 0b07 	vadd.f64	d0, d0, d7
10007bb0:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10007bb4:	ed8d 0b12 	vstr	d0, [sp, #72]	@ 0x48
10007bb8:	ee28 0b0f 	vmul.f64	d0, d8, d15
10007bbc:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10007bc0:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10007bc4:	ee05 1b4e 	vmls.f64	d1, d5, d14
10007bc8:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10007bcc:	ee00 8b4e 	vmls.f64	d8, d0, d14
10007bd0:	ee31 0b07 	vadd.f64	d0, d1, d7
10007bd4:	ed9d 1b02 	vldr	d1, [sp, #8]
10007bd8:	ee21 5b0f 	vmul.f64	d5, d1, d15
10007bdc:	eeb0 4b4d 	vmov.f64	d4, d13
10007be0:	ed8d db52 	vstr	d13, [sp, #328]	@ 0x148
10007be4:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10007be8:	ee22 db0f 	vmul.f64	d13, d2, d15
10007bec:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10007bf0:	eebc dbcd 	vcvt.u32.f64	s26, d13
10007bf4:	ee05 1b4e 	vmls.f64	d1, d5, d14
10007bf8:	eeb8 5b4d 	vcvt.f64.u32	d5, s26
10007bfc:	ee31 db07 	vadd.f64	d13, d1, d7
10007c00:	ee05 2b4e 	vmls.f64	d2, d5, d14
10007c04:	ed8d db02 	vstr	d13, [sp, #8]
10007c08:	ee23 5b0f 	vmul.f64	d5, d3, d15
10007c0c:	ee32 db07 	vadd.f64	d13, d2, d7
10007c10:	ee29 2b0f 	vmul.f64	d2, d9, d15
10007c14:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10007c18:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10007c1c:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10007c20:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10007c24:	ee05 3b4e 	vmls.f64	d3, d5, d14
10007c28:	ee02 9b4e 	vmls.f64	d9, d2, d14
10007c2c:	ee2a 5b0f 	vmul.f64	d5, d10, d15
10007c30:	ed8d db14 	vstr	d13, [sp, #80]	@ 0x50
10007c34:	ee33 db07 	vadd.f64	d13, d3, d7
10007c38:	ee39 3b07 	vadd.f64	d3, d9, d7
10007c3c:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10007c40:	ed8d 3b16 	vstr	d3, [sp, #88]	@ 0x58
10007c44:	ee2b 3b0f 	vmul.f64	d3, d11, d15
10007c48:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10007c4c:	eefc 2bc3 	vcvt.u32.f64	s5, d3
10007c50:	ee05 ab4e 	vmls.f64	d10, d5, d14
10007c54:	eeb8 5b62 	vcvt.f64.u32	d5, s5
10007c58:	ee05 bb4e 	vmls.f64	d11, d5, d14
10007c5c:	eebc 5bcb 	vcvt.u32.f64	s10, d11
10007c60:	ee3a 3b07 	vadd.f64	d3, d10, d7
10007c64:	ee15 3a10 	vmov	r3, s10
10007c68:	ed9d 1b0c 	vldr	d1, [sp, #48]	@ 0x30
10007c6c:	ed8d 3b18 	vstr	d3, [sp, #96]	@ 0x60
10007c70:	ee34 3b06 	vadd.f64	d3, d4, d6
10007c74:	ee26 6b0f 	vmul.f64	d6, d6, d15
10007c78:	0fdb      	lsrs	r3, r3, #31
10007c7a:	ee05 3a10 	vmov	s10, r3
10007c7e:	ed8d 6b4c 	vstr	d6, [sp, #304]	@ 0x130
10007c82:	ee21 6b0f 	vmul.f64	d6, d1, d15
10007c86:	ed9d ab0a 	vldr	d10, [sp, #40]	@ 0x28
10007c8a:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
10007c8e:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007c92:	ee24 4b0f 	vmul.f64	d4, d4, d15
10007c96:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10007c9a:	ed8d 5b58 	vstr	d5, [sp, #352]	@ 0x160
10007c9e:	ee2a 5b0f 	vmul.f64	d5, d10, d15
10007ca2:	eeb6 9b00 	vmov.f64	d9, #96	@ 0x3f000000  0.5
10007ca6:	ed8d 4b56 	vstr	d4, [sp, #344]	@ 0x158
10007caa:	ee06 1b4e 	vmls.f64	d1, d6, d14
10007cae:	eefc 4bc5 	vcvt.u32.f64	s9, d5
10007cb2:	ed9d 2b12 	vldr	d2, [sp, #72]	@ 0x48
10007cb6:	ee21 5b09 	vmul.f64	d5, d1, d9
10007cba:	ee32 2b06 	vadd.f64	d2, d2, d6
10007cbe:	eeb8 6b64 	vcvt.f64.u32	d6, s9
10007cc2:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10007cc6:	ee06 ab4e 	vmls.f64	d10, d6, d14
10007cca:	ee30 1b06 	vadd.f64	d1, d0, d6
10007cce:	ee2a 4b09 	vmul.f64	d4, d10, d9
10007cd2:	eeb0 0b49 	vmov.f64	d0, d9
10007cd6:	eeb8 6b45 	vcvt.f64.u32	d6, s10
10007cda:	ed9d 9b10 	vldr	d9, [sp, #64]	@ 0x40
10007cde:	ed8d 6b0c 	vstr	d6, [sp, #48]	@ 0x30
10007ce2:	ee29 6b0f 	vmul.f64	d6, d9, d15
10007ce6:	ed9d ab0e 	vldr	d10, [sp, #56]	@ 0x38
10007cea:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10007cee:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007cf2:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10007cf6:	ee2a 5b0f 	vmul.f64	d5, d10, d15
10007cfa:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10007cfe:	ed8d 4b10 	vstr	d4, [sp, #64]	@ 0x40
10007d02:	ee06 9b4e 	vmls.f64	d9, d6, d14
10007d06:	eefc 4bc5 	vcvt.u32.f64	s9, d5
10007d0a:	ee38 8b07 	vadd.f64	d8, d8, d7
10007d0e:	ee29 5b00 	vmul.f64	d5, d9, d0
10007d12:	ee38 8b06 	vadd.f64	d8, d8, d6
10007d16:	eeb8 6b64 	vcvt.f64.u32	d6, s9
10007d1a:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10007d1e:	ee06 ab4e 	vmls.f64	d10, d6, d14
10007d22:	ed9d 7b08 	vldr	d7, [sp, #32]
10007d26:	e00d      	b.n	10007d44 <fndsa_vect_iFFT_fp64_exact+0x41c>
10007d28:	00000000 	.word	0x00000000
10007d2c:	3df00000 	.word	0x3df00000
10007d30:	00000000 	.word	0x00000000
10007d34:	41f00000 	.word	0x41f00000
	...
10007d40:	300039a0 	.word	0x300039a0
10007d44:	ee2a 4b00 	vmul.f64	d4, d10, d0
10007d48:	ed9d 9b02 	vldr	d9, [sp, #8]
10007d4c:	eeb8 ab45 	vcvt.f64.u32	d10, s10
10007d50:	ee39 9b06 	vadd.f64	d9, d9, d6
10007d54:	ed8d ab0a 	vstr	d10, [sp, #40]	@ 0x28
10007d58:	ee27 6b0f 	vmul.f64	d6, d7, d15
10007d5c:	ed9d ab06 	vldr	d10, [sp, #24]
10007d60:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10007d64:	ee2a 5b0f 	vmul.f64	d5, d10, d15
10007d68:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10007d6c:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007d70:	ed8d 4b08 	vstr	d4, [sp, #32]
10007d74:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10007d78:	eefc 4bc5 	vcvt.u32.f64	s9, d5
10007d7c:	ed8d bb50 	vstr	d11, [sp, #320]	@ 0x140
10007d80:	ed9d 5b14 	vldr	d5, [sp, #80]	@ 0x50
10007d84:	ee06 7b4e 	vmls.f64	d7, d6, d14
10007d88:	ee35 5b06 	vadd.f64	d5, d5, d6
10007d8c:	eeb8 6b64 	vcvt.f64.u32	d6, s9
10007d90:	eeb0 4b4a 	vmov.f64	d4, d10
10007d94:	ed8d 5b06 	vstr	d5, [sp, #24]
10007d98:	ee06 4b4e 	vmls.f64	d4, d6, d14
10007d9c:	ee27 5b00 	vmul.f64	d5, d7, d0
10007da0:	ed9d ab04 	vldr	d10, [sp, #16]
10007da4:	ee24 4b00 	vmul.f64	d4, d4, d0
10007da8:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10007dac:	eeb0 7b40 	vmov.f64	d7, d0
10007db0:	ee3d db06 	vadd.f64	d13, d13, d6
10007db4:	eeb8 0b45 	vcvt.f64.u32	d0, s10
10007db8:	ee2a 6b0f 	vmul.f64	d6, d10, d15
10007dbc:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10007dc0:	ed8d 0b0e 	vstr	d0, [sp, #56]	@ 0x38
10007dc4:	ee2c 5b0f 	vmul.f64	d5, d12, d15
10007dc8:	eeb8 0b44 	vcvt.f64.u32	d0, s8
10007dcc:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007dd0:	ed8d 0b04 	vstr	d0, [sp, #16]
10007dd4:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10007dd8:	eefc 0bc5 	vcvt.u32.f64	s1, d5
10007ddc:	ed9d 5b16 	vldr	d5, [sp, #88]	@ 0x58
10007de0:	ee35 4b06 	vadd.f64	d4, d5, d6
10007de4:	eeb0 5b4a 	vmov.f64	d5, d10
10007de8:	ee06 5b4e 	vmls.f64	d5, d6, d14
10007dec:	eeb8 6b60 	vcvt.f64.u32	d6, s1
10007df0:	eeb0 0b47 	vmov.f64	d0, d7
10007df4:	ee06 cb4e 	vmls.f64	d12, d6, d14
10007df8:	ee25 5b07 	vmul.f64	d5, d5, d7
10007dfc:	ee2c cb00 	vmul.f64	d12, d12, d0
10007e00:	ed9d 7b18 	vldr	d7, [sp, #96]	@ 0x60
10007e04:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10007e08:	ee37 7b06 	vadd.f64	d7, d7, d6
10007e0c:	eefc 5bcc 	vcvt.u32.f64	s11, d12
10007e10:	ed8d 7b02 	vstr	d7, [sp, #8]
10007e14:	eeb8 cb45 	vcvt.f64.u32	d12, s10
10007e18:	ed9d 7b00 	vldr	d7, [sp]
10007e1c:	eeb8 5b65 	vcvt.f64.u32	d5, s11
10007e20:	ed8d 5b18 	vstr	d5, [sp, #96]	@ 0x60
10007e24:	ee3b 5b07 	vadd.f64	d5, d11, d7
10007e28:	ee27 7b0f 	vmul.f64	d7, d7, d15
10007e2c:	ee23 6b0f 	vmul.f64	d6, d3, d15
10007e30:	ed8d 7b4a 	vstr	d7, [sp, #296]	@ 0x128
10007e34:	ee22 7b0f 	vmul.f64	d7, d2, d15
10007e38:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007e3c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007e40:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10007e44:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007e48:	ee06 3b4e 	vmls.f64	d3, d6, d14
10007e4c:	ee35 5b06 	vadd.f64	d5, d5, d6
10007e50:	ee21 6b0f 	vmul.f64	d6, d1, d15
10007e54:	ee07 2b4e 	vmls.f64	d2, d7, d14
10007e58:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007e5c:	eefc 7bc2 	vcvt.u32.f64	s15, d2
10007e60:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10007e64:	ee17 2a90 	vmov	r2, s15
10007e68:	ee06 1b4e 	vmls.f64	d1, d6, d14
10007e6c:	0fd3      	lsrs	r3, r2, #31
10007e6e:	eefc 7bc1 	vcvt.u32.f64	s15, d1
10007e72:	ee07 3a10 	vmov	s14, r3
10007e76:	0853      	lsrs	r3, r2, #1
10007e78:	ee2b bb0f 	vmul.f64	d11, d11, d15
10007e7c:	ee00 3a10 	vmov	s0, r3
10007e80:	ee17 ca90 	vmov	ip, s15
10007e84:	ed8d bb54 	vstr	d11, [sp, #336]	@ 0x150
10007e88:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10007e8c:	ee23 bb0f 	vmul.f64	d11, d3, d15
10007e90:	ed8d 3b5c 	vstr	d3, [sp, #368]	@ 0x170
10007e94:	eeb8 0bc0 	vcvt.f64.s32	d0, s0
10007e98:	ed9f 3bfb 	vldr	d3, [pc, #1004]	@ 10008288 <fndsa_vect_iFFT_fp64_exact+0x960>
10007e9c:	ea4f 73dc 	mov.w	r3, ip, lsr #31
10007ea0:	ee07 0b03 	vmla.f64	d0, d7, d3
10007ea4:	f002 0201 	and.w	r2, r2, #1
10007ea8:	ee07 3a10 	vmov	s14, r3
10007eac:	ea4f 035c 	mov.w	r3, ip, lsr #1
10007eb0:	ee07 2a90 	vmov	s15, r2
10007eb4:	ee02 3a10 	vmov	s4, r3
10007eb8:	eeb8 6be7 	vcvt.f64.s32	d6, s15
10007ebc:	eeb8 2bc2 	vcvt.f64.s32	d2, s4
10007ec0:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10007ec4:	f00c 0301 	and.w	r3, ip, #1
10007ec8:	ee07 2b03 	vmla.f64	d2, d7, d3
10007ecc:	ed9d 1b0c 	vldr	d1, [sp, #48]	@ 0x30
10007ed0:	ee07 3a90 	vmov	s15, r3
10007ed4:	ee06 1b03 	vmla.f64	d1, d6, d3
10007ed8:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10007edc:	eeb0 6b43 	vmov.f64	d6, d3
10007ee0:	ed9d 3b10 	vldr	d3, [sp, #64]	@ 0x40
10007ee4:	ee07 3b06 	vmla.f64	d3, d7, d6
10007ee8:	ee28 7b0f 	vmul.f64	d7, d8, d15
10007eec:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007ef0:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007ef4:	eeb0 ab46 	vmov.f64	d10, d6
10007ef8:	ee29 6b0f 	vmul.f64	d6, d9, d15
10007efc:	ee07 8b4e 	vmls.f64	d8, d7, d14
10007f00:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007f04:	eefc 7bc8 	vcvt.u32.f64	s15, d8
10007f08:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10007f0c:	ee17 2a90 	vmov	r2, s15
10007f10:	ee06 9b4e 	vmls.f64	d9, d6, d14
10007f14:	0fd3      	lsrs	r3, r2, #31
10007f16:	ee07 3a10 	vmov	s14, r3
10007f1a:	0853      	lsrs	r3, r2, #1
10007f1c:	eefc 7bc9 	vcvt.u32.f64	s15, d9
10007f20:	ee06 3a10 	vmov	s12, r3
10007f24:	ee17 ca90 	vmov	ip, s15
10007f28:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10007f2c:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10007f30:	ee07 6b0a 	vmla.f64	d6, d7, d10
10007f34:	ea4f 73dc 	mov.w	r3, ip, lsr #31
10007f38:	ed8d 6b14 	vstr	d6, [sp, #80]	@ 0x50
10007f3c:	f002 0201 	and.w	r2, r2, #1
10007f40:	ee06 3a10 	vmov	s12, r3
10007f44:	ea4f 035c 	mov.w	r3, ip, lsr #1
10007f48:	ee07 2a90 	vmov	s15, r2
10007f4c:	ee07 3a10 	vmov	s14, r3
10007f50:	eeb0 9b4a 	vmov.f64	d9, d10
10007f54:	eeb8 8be7 	vcvt.f64.s32	d8, s15
10007f58:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10007f5c:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10007f60:	ee06 7b09 	vmla.f64	d7, d6, d9
10007f64:	f00c 0301 	and.w	r3, ip, #1
10007f68:	ed9d ab0a 	vldr	d10, [sp, #40]	@ 0x28
10007f6c:	ed8d 7b10 	vstr	d7, [sp, #64]	@ 0x40
10007f70:	ee07 3a90 	vmov	s15, r3
10007f74:	ee08 ab09 	vmla.f64	d10, d8, d9
10007f78:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10007f7c:	eeb0 8b49 	vmov.f64	d8, d9
10007f80:	ed9d 9b08 	vldr	d9, [sp, #32]
10007f84:	ee07 9b08 	vmla.f64	d9, d7, d8
10007f88:	ed8d 9b12 	vstr	d9, [sp, #72]	@ 0x48
10007f8c:	ed9d 9b06 	vldr	d9, [sp, #24]
10007f90:	ee29 7b0f 	vmul.f64	d7, d9, d15
10007f94:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007f98:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007f9c:	ee2d 6b0f 	vmul.f64	d6, d13, d15
10007fa0:	ee07 9b4e 	vmls.f64	d9, d7, d14
10007fa4:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007fa8:	eefc 7bc9 	vcvt.u32.f64	s15, d9
10007fac:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10007fb0:	ee17 2a90 	vmov	r2, s15
10007fb4:	ee06 db4e 	vmls.f64	d13, d6, d14
10007fb8:	0fd3      	lsrs	r3, r2, #31
10007fba:	ee06 3a10 	vmov	s12, r3
10007fbe:	0853      	lsrs	r3, r2, #1
10007fc0:	eefc 7bcd 	vcvt.u32.f64	s15, d13
10007fc4:	ee07 3a10 	vmov	s14, r3
10007fc8:	ee17 ca90 	vmov	ip, s15
10007fcc:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10007fd0:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10007fd4:	ed8d ab16 	vstr	d10, [sp, #88]	@ 0x58
10007fd8:	f002 0201 	and.w	r2, r2, #1
10007fdc:	eeb0 ab47 	vmov.f64	d10, d7
10007fe0:	ee07 2a90 	vmov	s15, r2
10007fe4:	ea4f 73dc 	mov.w	r3, ip, lsr #31
10007fe8:	ee06 ab08 	vmla.f64	d10, d6, d8
10007fec:	ee06 3a10 	vmov	s12, r3
10007ff0:	ea4f 035c 	mov.w	r3, ip, lsr #1
10007ff4:	eeb0 9b48 	vmov.f64	d9, d8
10007ff8:	ed9d db0e 	vldr	d13, [sp, #56]	@ 0x38
10007ffc:	eeb8 8be7 	vcvt.f64.s32	d8, s15
10008000:	ee07 3a10 	vmov	s14, r3
10008004:	ee08 db09 	vmla.f64	d13, d8, d9
10008008:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
1000800c:	f00c 0301 	and.w	r3, ip, #1
10008010:	ed8d db0e 	vstr	d13, [sp, #56]	@ 0x38
10008014:	eeb0 db47 	vmov.f64	d13, d7
10008018:	ee07 3a90 	vmov	s15, r3
1000801c:	ed8d ab0c 	vstr	d10, [sp, #48]	@ 0x30
10008020:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10008024:	ed9d ab04 	vldr	d10, [sp, #16]
10008028:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
1000802c:	ee07 ab09 	vmla.f64	d10, d7, d9
10008030:	ee24 7b0f 	vmul.f64	d7, d4, d15
10008034:	ee06 db09 	vmla.f64	d13, d6, d9
10008038:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000803c:	ed8d db0a 	vstr	d13, [sp, #40]	@ 0x28
10008040:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10008044:	ed9d db02 	vldr	d13, [sp, #8]
10008048:	ee07 4b4e 	vmls.f64	d4, d7, d14
1000804c:	ee2d 6b0f 	vmul.f64	d6, d13, d15
10008050:	eefc 7bc4 	vcvt.u32.f64	s15, d4
10008054:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10008058:	ee17 2a90 	vmov	r2, s15
1000805c:	eeb8 7b46 	vcvt.f64.u32	d7, s12
10008060:	ee07 db4e 	vmls.f64	d13, d7, d14
10008064:	0fd3      	lsrs	r3, r2, #31
10008066:	eefc 7bcd 	vcvt.u32.f64	s15, d13
1000806a:	ee06 3a10 	vmov	s12, r3
1000806e:	0853      	lsrs	r3, r2, #1
10008070:	ee08 3a10 	vmov	s16, r3
10008074:	ee17 ca90 	vmov	ip, s15
10008078:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
1000807c:	eeb8 8bc8 	vcvt.f64.s32	d8, s16
10008080:	ea4f 73dc 	mov.w	r3, ip, lsr #31
10008084:	ee06 8b09 	vmla.f64	d8, d6, d9
10008088:	f002 0201 	and.w	r2, r2, #1
1000808c:	ee06 3a10 	vmov	s12, r3
10008090:	ea4f 035c 	mov.w	r3, ip, lsr #1
10008094:	ee07 2a90 	vmov	s15, r2
10008098:	ee07 3a10 	vmov	s14, r3
1000809c:	eeb8 4be7 	vcvt.f64.s32	d4, s15
100080a0:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100080a4:	f00c 0301 	and.w	r3, ip, #1
100080a8:	ee04 cb09 	vmla.f64	d12, d4, d9
100080ac:	eeb0 4b47 	vmov.f64	d4, d7
100080b0:	ee07 3a90 	vmov	s15, r3
100080b4:	ed8d cb04 	vstr	d12, [sp, #16]
100080b8:	eeb8 7be7 	vcvt.f64.s32	d7, s15
100080bc:	ed9d cb18 	vldr	d12, [sp, #96]	@ 0x60
100080c0:	ee07 cb09 	vmla.f64	d12, d7, d9
100080c4:	ee25 7b0f 	vmul.f64	d7, d5, d15
100080c8:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100080cc:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100080d0:	ee07 5b4e 	vmls.f64	d5, d7, d14
100080d4:	eebc 7bc5 	vcvt.u32.f64	s14, d5
100080d8:	ee17 3a10 	vmov	r3, s14
100080dc:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
100080e0:	0fdb      	lsrs	r3, r3, #31
100080e2:	ee06 4b09 	vmla.f64	d4, d6, d9
100080e6:	ee07 3a10 	vmov	s14, r3
100080ea:	ed8d 4b00 	vstr	d4, [sp]
100080ee:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100080f2:	ed8d ab08 	vstr	d10, [sp, #32]
100080f6:	ed8d cb02 	vstr	d12, [sp, #8]
100080fa:	ed8d 5b5a 	vstr	d5, [sp, #360]	@ 0x168
100080fe:	ee25 5b0f 	vmul.f64	d5, d5, d15
10008102:	a846      	add	r0, sp, #280	@ 0x118
10008104:	ed8d 7b62 	vstr	d7, [sp, #392]	@ 0x188
10008108:	ed8d 5b5e 	vstr	d5, [sp, #376]	@ 0x178
1000810c:	ed8d bb60 	vstr	d11, [sp, #384]	@ 0x180
10008110:	f7fe f806 	bl	10006120 <fp64e_cmul_prepared>
10008114:	edd6 7a06 	vldr	s15, [r6, #24]
10008118:	6973      	ldr	r3, [r6, #20]
1000811a:	eeb8 5b67 	vcvt.f64.u32	d5, s15
1000811e:	0fdb      	lsrs	r3, r3, #31
10008120:	edd6 7a07 	vldr	s15, [r6, #28]
10008124:	ee04 3a10 	vmov	s8, r3
10008128:	eeb8 6b67 	vcvt.f64.u32	d6, s15
1000812c:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
10008130:	ee3e 5b45 	vsub.f64	d5, d14, d5
10008134:	ed8d 4b4e 	vstr	d4, [sp, #312]	@ 0x138
10008138:	ee3e 6b46 	vsub.f64	d6, d14, d6
1000813c:	eeb7 4b00 	vmov.f64	d4, #112	@ 0x3f800000  1.0
10008140:	edd6 7a04 	vldr	s15, [r6, #16]
10008144:	ee36 6b44 	vsub.f64	d6, d6, d4
10008148:	ee25 4b0f 	vmul.f64	d4, d5, d15
1000814c:	eeb0 cb40 	vmov.f64	d12, d0
10008150:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10008154:	eeb0 0b48 	vmov.f64	d0, d8
10008158:	eeb8 8b67 	vcvt.f64.u32	d8, s15
1000815c:	edd6 7a05 	vldr	s15, [r6, #20]
10008160:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10008164:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10008168:	ee36 6b04 	vadd.f64	d6, d6, d4
1000816c:	ee27 bb0f 	vmul.f64	d11, d7, d15
10008170:	ed8d bb4a 	vstr	d11, [sp, #296]	@ 0x128
10008174:	ee26 bb0f 	vmul.f64	d11, d6, d15
10008178:	eebc bbcb 	vcvt.u32.f64	s22, d11
1000817c:	ee04 5b4e 	vmls.f64	d5, d4, d14
10008180:	eeb8 bb4b 	vcvt.f64.u32	d11, s22
10008184:	ee35 4b08 	vadd.f64	d4, d5, d8
10008188:	ee0b 6b4e 	vmls.f64	d6, d11, d14
1000818c:	ed8d 5b52 	vstr	d5, [sp, #328]	@ 0x148
10008190:	ee25 5b0f 	vmul.f64	d5, d5, d15
10008194:	ed8d 5b56 	vstr	d5, [sp, #344]	@ 0x158
10008198:	eefc 5bc6 	vcvt.u32.f64	s11, d6
1000819c:	ee15 3a90 	vmov	r3, s11
100081a0:	ed8d 7b46 	vstr	d7, [sp, #280]	@ 0x118
100081a4:	ed8d 6b50 	vstr	d6, [sp, #320]	@ 0x140
100081a8:	ee36 7b07 	vadd.f64	d7, d6, d7
100081ac:	ee26 6b0f 	vmul.f64	d6, d6, d15
100081b0:	0fdb      	lsrs	r3, r3, #31
100081b2:	ed8d 6b54 	vstr	d6, [sp, #336]	@ 0x150
100081b6:	ee06 3a10 	vmov	s12, r3
100081ba:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
100081be:	ed8d 6b58 	vstr	d6, [sp, #352]	@ 0x160
100081c2:	ee24 6b0f 	vmul.f64	d6, d4, d15
100081c6:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100081ca:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100081ce:	ee37 7b06 	vadd.f64	d7, d7, d6
100081d2:	ee06 4b4e 	vmls.f64	d4, d6, d14
100081d6:	ee27 6b0f 	vmul.f64	d6, d7, d15
100081da:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100081de:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100081e2:	ee06 7b4e 	vmls.f64	d7, d6, d14
100081e6:	eefc 6bc7 	vcvt.u32.f64	s13, d7
100081ea:	ee16 3a90 	vmov	r3, s13
100081ee:	ed8d 7b5a 	vstr	d7, [sp, #360]	@ 0x168
100081f2:	ee27 7b0f 	vmul.f64	d7, d7, d15
100081f6:	0fdb      	lsrs	r3, r3, #31
100081f8:	ed8d 7b5e 	vstr	d7, [sp, #376]	@ 0x178
100081fc:	ee07 3a10 	vmov	s14, r3
10008200:	eeb0 9b43 	vmov.f64	d9, d3
10008204:	eeb0 ab41 	vmov.f64	d10, d1
10008208:	eeb0 db42 	vmov.f64	d13, d2
1000820c:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10008210:	ed8d 8b48 	vstr	d8, [sp, #288]	@ 0x120
10008214:	ed8d 4b5c 	vstr	d4, [sp, #368]	@ 0x170
10008218:	ee28 8b0f 	vmul.f64	d8, d8, d15
1000821c:	ee24 4b0f 	vmul.f64	d4, d4, d15
10008220:	ed9d 2b00 	vldr	d2, [sp]
10008224:	ed9d 1b04 	vldr	d1, [sp, #16]
10008228:	ed9d 3b02 	vldr	d3, [sp, #8]
1000822c:	ed8d 7b62 	vstr	d7, [sp, #392]	@ 0x188
10008230:	ed8d cb2e 	vstr	d12, [sp, #184]	@ 0xb8
10008234:	ed8d ab30 	vstr	d10, [sp, #192]	@ 0xc0
10008238:	ed8d db32 	vstr	d13, [sp, #200]	@ 0xc8
1000823c:	ed8d 9b34 	vstr	d9, [sp, #208]	@ 0xd0
10008240:	ed8d 8b4c 	vstr	d8, [sp, #304]	@ 0x130
10008244:	ed8d 4b60 	vstr	d4, [sp, #384]	@ 0x180
10008248:	f7fd ff6a 	bl	10006120 <fp64e_cmul_prepared>
1000824c:	edd7 7a02 	vldr	s15, [r7, #8]
10008250:	edd7 5a00 	vldr	s11, [r7]
10008254:	687b      	ldr	r3, [r7, #4]
10008256:	eeb8 4b65 	vcvt.f64.u32	d4, s11
1000825a:	0fdb      	lsrs	r3, r3, #31
1000825c:	edd7 5a01 	vldr	s11, [r7, #4]
10008260:	eeb8 6b67 	vcvt.f64.u32	d6, s15
10008264:	ee05 3a10 	vmov	s10, r3
10008268:	edd7 7a03 	vldr	s15, [r7, #12]
1000826c:	eeb8 8b65 	vcvt.f64.u32	d8, s11
10008270:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10008274:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
10008278:	ee3e bb46 	vsub.f64	d11, d14, d6
1000827c:	ed8d 5b4e 	vstr	d5, [sp, #312]	@ 0x138
10008280:	ee3e 7b47 	vsub.f64	d7, d14, d7
10008284:	e008      	b.n	10008298 <fndsa_vect_iFFT_fp64_exact+0x970>
10008286:	bf00      	nop
10008288:	00000000 	.word	0x00000000
1000828c:	41e00000 	.word	0x41e00000
	...
10008298:	eeb7 5b00 	vmov.f64	d5, #112	@ 0x3f800000  1.0
1000829c:	ed8d bb06 	vstr	d11, [sp, #24]
100082a0:	ee37 bb45 	vsub.f64	d11, d7, d5
100082a4:	ed9d 6b16 	vldr	d6, [sp, #88]	@ 0x58
100082a8:	ed8d bb1a 	vstr	d11, [sp, #104]	@ 0x68
100082ac:	ed9d bb0e 	vldr	d11, [sp, #56]	@ 0x38
100082b0:	ee36 7b0e 	vadd.f64	d7, d6, d14
100082b4:	ee3b 6b06 	vadd.f64	d6, d11, d6
100082b8:	ed9d 5b08 	vldr	d5, [sp, #32]
100082bc:	ed8d 6b0e 	vstr	d6, [sp, #56]	@ 0x38
100082c0:	ed9d 6b12 	vldr	d6, [sp, #72]	@ 0x48
100082c4:	ee37 7b4b 	vsub.f64	d7, d7, d11
100082c8:	ee36 bb0e 	vadd.f64	d11, d6, d14
100082cc:	ee35 6b06 	vadd.f64	d6, d5, d6
100082d0:	ed8d 6b04 	vstr	d6, [sp, #16]
100082d4:	ee3a 6b0e 	vadd.f64	d6, d10, d14
100082d8:	ed8d 1b38 	vstr	d1, [sp, #224]	@ 0xe0
100082dc:	ee3a ab01 	vadd.f64	d10, d10, d1
100082e0:	ee36 1b41 	vsub.f64	d1, d6, d1
100082e4:	ee39 6b0e 	vadd.f64	d6, d9, d14
100082e8:	ed8d 0b36 	vstr	d0, [sp, #216]	@ 0xd8
100082ec:	ed8d 2b3a 	vstr	d2, [sp, #232]	@ 0xe8
100082f0:	ed8d 3b3c 	vstr	d3, [sp, #240]	@ 0xf0
100082f4:	ed8d 8b00 	vstr	d8, [sp]
100082f8:	ed8d 8b46 	vstr	d8, [sp, #280]	@ 0x118
100082fc:	ed8d 4b48 	vstr	d4, [sp, #288]	@ 0x120
10008300:	ed8d 1b08 	vstr	d1, [sp, #32]
10008304:	ed8d 7b02 	vstr	d7, [sp, #8]
10008308:	ee39 1b03 	vadd.f64	d1, d9, d3
1000830c:	ee36 9b43 	vsub.f64	d9, d6, d3
10008310:	ed9d 3b14 	vldr	d3, [sp, #80]	@ 0x50
10008314:	ed9d 8b0c 	vldr	d8, [sp, #48]	@ 0x30
10008318:	ee3b bb45 	vsub.f64	d11, d11, d5
1000831c:	ee27 6b0f 	vmul.f64	d6, d7, d15
10008320:	ee33 5b0e 	vadd.f64	d5, d3, d14
10008324:	eeb7 7b00 	vmov.f64	d7, #112	@ 0x3f800000  1.0
10008328:	ee35 5b48 	vsub.f64	d5, d5, d8
1000832c:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10008330:	ee38 3b03 	vadd.f64	d3, d8, d3
10008334:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10008338:	eeb0 8b47 	vmov.f64	d8, d7
1000833c:	ee35 5b47 	vsub.f64	d5, d5, d7
10008340:	ed9d 7b02 	vldr	d7, [sp, #8]
10008344:	ee06 7b4e 	vmls.f64	d7, d6, d14
10008348:	ee35 5b06 	vadd.f64	d5, d5, d6
1000834c:	ee37 7b08 	vadd.f64	d7, d7, d8
10008350:	ed8d 5b0c 	vstr	d5, [sp, #48]	@ 0x30
10008354:	ed8d 7b14 	vstr	d7, [sp, #80]	@ 0x50
10008358:	ed9d 5b10 	vldr	d5, [sp, #64]	@ 0x40
1000835c:	ee2b 7b0f 	vmul.f64	d7, d11, d15
10008360:	ed9d 8b0a 	vldr	d8, [sp, #40]	@ 0x28
10008364:	ee35 6b0e 	vadd.f64	d6, d5, d14
10008368:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000836c:	ee38 5b05 	vadd.f64	d5, d8, d5
10008370:	ee36 6b48 	vsub.f64	d6, d6, d8
10008374:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10008378:	eeb7 8b00 	vmov.f64	d8, #112	@ 0x3f800000  1.0
1000837c:	ee07 bb4e 	vmls.f64	d11, d7, d14
10008380:	ee36 6b48 	vsub.f64	d6, d6, d8
10008384:	ee3b bb08 	vadd.f64	d11, d11, d8
10008388:	ee36 7b07 	vadd.f64	d7, d6, d7
1000838c:	ed9d 8b0e 	vldr	d8, [sp, #56]	@ 0x38
10008390:	ed8d 7b0a 	vstr	d7, [sp, #40]	@ 0x28
10008394:	ee28 7b0f 	vmul.f64	d7, d8, d15
10008398:	ed9d 6b04 	vldr	d6, [sp, #16]
1000839c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100083a0:	ee26 6b0f 	vmul.f64	d6, d6, d15
100083a4:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100083a8:	ed8d bb12 	vstr	d11, [sp, #72]	@ 0x48
100083ac:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100083b0:	ee33 bb07 	vadd.f64	d11, d3, d7
100083b4:	eeb0 3b48 	vmov.f64	d3, d8
100083b8:	ee07 3b4e 	vmls.f64	d3, d7, d14
100083bc:	eeb8 7b46 	vcvt.f64.u32	d7, s12
100083c0:	ed9d 6b04 	vldr	d6, [sp, #16]
100083c4:	eeb7 8b00 	vmov.f64	d8, #112	@ 0x3f800000  1.0
100083c8:	ee07 6b4e 	vmls.f64	d6, d7, d14
100083cc:	ee33 3b08 	vadd.f64	d3, d3, d8
100083d0:	ee36 6b08 	vadd.f64	d6, d6, d8
100083d4:	ed8d 3b18 	vstr	d3, [sp, #96]	@ 0x60
100083d8:	ed8d 6b16 	vstr	d6, [sp, #88]	@ 0x58
100083dc:	ee35 3b07 	vadd.f64	d3, d5, d7
100083e0:	ee21 6b0f 	vmul.f64	d6, d1, d15
100083e4:	ee2a 7b0f 	vmul.f64	d7, d10, d15
100083e8:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100083ec:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100083f0:	ed8d 3b0e 	vstr	d3, [sp, #56]	@ 0x38
100083f4:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100083f8:	eeb8 3b46 	vcvt.f64.u32	d3, s12
100083fc:	ee07 ab4e 	vmls.f64	d10, d7, d14
10008400:	ee03 1b4e 	vmls.f64	d1, d3, d14
10008404:	ee3a ab08 	vadd.f64	d10, d10, d8
10008408:	ee31 6b08 	vadd.f64	d6, d1, d8
1000840c:	ed9d 8b08 	vldr	d8, [sp, #32]
10008410:	ed8d 6b10 	vstr	d6, [sp, #64]	@ 0x40
10008414:	ee28 6b0f 	vmul.f64	d6, d8, d15
10008418:	ee3c 5b0e 	vadd.f64	d5, d12, d14
1000841c:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10008420:	ee3c cb00 	vadd.f64	d12, d12, d0
10008424:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10008428:	ee3c 1b07 	vadd.f64	d1, d12, d7
1000842c:	ee35 5b40 	vsub.f64	d5, d5, d0
10008430:	eeb7 7b00 	vmov.f64	d7, #112	@ 0x3f800000  1.0
10008434:	eeb0 cb48 	vmov.f64	d12, d8
10008438:	ee35 5b47 	vsub.f64	d5, d5, d7
1000843c:	ee06 cb4e 	vmls.f64	d12, d6, d14
10008440:	ee35 0b06 	vadd.f64	d0, d5, d6
10008444:	ee3c cb07 	vadd.f64	d12, d12, d7
10008448:	eeb0 5b47 	vmov.f64	d5, d7
1000844c:	ee29 7b0f 	vmul.f64	d7, d9, d15
10008450:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10008454:	ee3d 6b0e 	vadd.f64	d6, d13, d14
10008458:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000845c:	ee32 db0d 	vadd.f64	d13, d2, d13
10008460:	ee07 9b4e 	vmls.f64	d9, d7, d14
10008464:	ee36 6b42 	vsub.f64	d6, d6, d2
10008468:	ed9d 8b06 	vldr	d8, [sp, #24]
1000846c:	ee36 6b45 	vsub.f64	d6, d6, d5
10008470:	ee3d 3b03 	vadd.f64	d3, d13, d3
10008474:	ee39 db05 	vadd.f64	d13, d9, d5
10008478:	ee36 2b07 	vadd.f64	d2, d6, d7
1000847c:	ed8d db04 	vstr	d13, [sp, #16]
10008480:	ee28 7b0f 	vmul.f64	d7, d8, d15
10008484:	ed9d db0c 	vldr	d13, [sp, #48]	@ 0x30
10008488:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000848c:	ee2d 6b0f 	vmul.f64	d6, d13, d15
10008490:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10008494:	eefc 5bc6 	vcvt.u32.f64	s11, d6
10008498:	ed9d 6b1a 	vldr	d6, [sp, #104]	@ 0x68
1000849c:	ee36 9b07 	vadd.f64	d9, d6, d7
100084a0:	eeb0 6b48 	vmov.f64	d6, d8
100084a4:	ee07 6b4e 	vmls.f64	d6, d7, d14
100084a8:	eeb8 7b65 	vcvt.f64.u32	d7, s11
100084ac:	eeb0 5b4d 	vmov.f64	d5, d13
100084b0:	ed1f 8b89 	vldr	d8, [pc, #-548]	@ 10008290 <fndsa_vect_iFFT_fp64_exact+0x968>
100084b4:	ed8d cb02 	vstr	d12, [sp, #8]
100084b8:	ee07 5b4e 	vmls.f64	d5, d7, d14
100084bc:	ed9d cb0a 	vldr	d12, [sp, #40]	@ 0x28
100084c0:	ee35 5b08 	vadd.f64	d5, d5, d8
100084c4:	ee2c 7b0f 	vmul.f64	d7, d12, d15
100084c8:	ed8d 5b08 	vstr	d5, [sp, #32]
100084cc:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100084d0:	ee2b 5b0f 	vmul.f64	d5, d11, d15
100084d4:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100084d8:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100084dc:	ee07 cb4e 	vmls.f64	d12, d7, d14
100084e0:	eeb8 7b45 	vcvt.f64.u32	d7, s10
100084e4:	ed9d db0e 	vldr	d13, [sp, #56]	@ 0x38
100084e8:	ee07 bb4e 	vmls.f64	d11, d7, d14
100084ec:	ee3c 7b08 	vadd.f64	d7, d12, d8
100084f0:	eeb0 cb47 	vmov.f64	d12, d7
100084f4:	ee2d 7b0f 	vmul.f64	d7, d13, d15
100084f8:	ee21 5b0f 	vmul.f64	d5, d1, d15
100084fc:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10008500:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10008504:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10008508:	ee07 db4e 	vmls.f64	d13, d7, d14
1000850c:	eeb8 7b45 	vcvt.f64.u32	d7, s10
10008510:	ee07 1b4e 	vmls.f64	d1, d7, d14
10008514:	ee3d 7b08 	vadd.f64	d7, d13, d8
10008518:	ed8d 7b06 	vstr	d7, [sp, #24]
1000851c:	ee23 7b0f 	vmul.f64	d7, d3, d15
10008520:	ee31 1b08 	vadd.f64	d1, d1, d8
10008524:	ee20 5b0f 	vmul.f64	d5, d0, d15
10008528:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000852c:	ed8d 1b0c 	vstr	d1, [sp, #48]	@ 0x30
10008530:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10008534:	eefc 1bc5 	vcvt.u32.f64	s3, d5
10008538:	ee07 3b4e 	vmls.f64	d3, d7, d14
1000853c:	eeb8 7b61 	vcvt.f64.u32	d7, s3
10008540:	ee07 0b4e 	vmls.f64	d0, d7, d14
10008544:	ee22 7b0f 	vmul.f64	d7, d2, d15
10008548:	ee33 3b08 	vadd.f64	d3, d3, d8
1000854c:	ee29 5b0f 	vmul.f64	d5, d9, d15
10008550:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10008554:	ed8d 3b1a 	vstr	d3, [sp, #104]	@ 0x68
10008558:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000855c:	eefc 3bc5 	vcvt.u32.f64	s7, d5
10008560:	ee07 2b4e 	vmls.f64	d2, d7, d14
10008564:	eeb8 7b63 	vcvt.f64.u32	d7, s7
10008568:	ee07 9b4e 	vmls.f64	d9, d7, d14
1000856c:	eebc 7bc9 	vcvt.u32.f64	s14, d9
10008570:	ee17 3a10 	vmov	r3, s14
10008574:	0fdb      	lsrs	r3, r3, #31
10008576:	ee07 3a10 	vmov	s14, r3
1000857a:	ee36 3b04 	vadd.f64	d3, d6, d4
1000857e:	ee32 2b08 	vadd.f64	d2, d2, d8
10008582:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10008586:	ee24 4b0f 	vmul.f64	d4, d4, d15
1000858a:	ed8d 6b52 	vstr	d6, [sp, #328]	@ 0x148
1000858e:	ed8d 2b1c 	vstr	d2, [sp, #112]	@ 0x70
10008592:	ed8d 9b50 	vstr	d9, [sp, #320]	@ 0x140
10008596:	ed8d 7b58 	vstr	d7, [sp, #352]	@ 0x160
1000859a:	ed8d 4b4c 	vstr	d4, [sp, #304]	@ 0x130
1000859e:	ed9d 2b14 	vldr	d2, [sp, #80]	@ 0x50
100085a2:	ed9d 1b12 	vldr	d1, [sp, #72]	@ 0x48
100085a6:	ee22 7b0f 	vmul.f64	d7, d2, d15
100085aa:	ee26 6b0f 	vmul.f64	d6, d6, d15
100085ae:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100085b2:	ed8d 6b56 	vstr	d6, [sp, #344]	@ 0x158
100085b6:	ee21 6b0f 	vmul.f64	d6, d1, d15
100085ba:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100085be:	eefc 5bc6 	vcvt.u32.f64	s11, d6
100085c2:	ed9d 4b08 	vldr	d4, [sp, #32]
100085c6:	eeb0 6b42 	vmov.f64	d6, d2
100085ca:	ee34 4b07 	vadd.f64	d4, d4, d7
100085ce:	ee07 6b4e 	vmls.f64	d6, d7, d14
100085d2:	eeb8 7b65 	vcvt.f64.u32	d7, s11
100085d6:	eeb0 5b41 	vmov.f64	d5, d1
100085da:	ee30 0b08 	vadd.f64	d0, d0, d8
100085de:	ee3b bb08 	vadd.f64	d11, d11, d8
100085e2:	ee07 5b4e 	vmls.f64	d5, d7, d14
100085e6:	eeb6 8b00 	vmov.f64	d8, #96	@ 0x3f000000  0.5
100085ea:	ee3c 2b07 	vadd.f64	d2, d12, d7
100085ee:	ee26 6b08 	vmul.f64	d6, d6, d8
100085f2:	ed9d cb18 	vldr	d12, [sp, #96]	@ 0x60
100085f6:	ee25 5b08 	vmul.f64	d5, d5, d8
100085fa:	ed9d db16 	vldr	d13, [sp, #88]	@ 0x58
100085fe:	ee2c 7b0f 	vmul.f64	d7, d12, d15
10008602:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10008606:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000860a:	eeb8 1b46 	vcvt.f64.u32	d1, s12
1000860e:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10008612:	ee2d 6b0f 	vmul.f64	d6, d13, d15
10008616:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000861a:	ed8d 5b18 	vstr	d5, [sp, #96]	@ 0x60
1000861e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10008622:	eefc 5bc6 	vcvt.u32.f64	s11, d6
10008626:	eeb0 6b4c 	vmov.f64	d6, d12
1000862a:	ee3b bb07 	vadd.f64	d11, d11, d7
1000862e:	ee07 6b4e 	vmls.f64	d6, d7, d14
10008632:	eeb8 7b65 	vcvt.f64.u32	d7, s11
10008636:	ed9d 5b06 	vldr	d5, [sp, #24]
1000863a:	ee26 6b08 	vmul.f64	d6, d6, d8
1000863e:	ee35 5b07 	vadd.f64	d5, d5, d7
10008642:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10008646:	ed8d 5b08 	vstr	d5, [sp, #32]
1000864a:	eeb0 5b4d 	vmov.f64	d5, d13
1000864e:	ee07 5b4e 	vmls.f64	d5, d7, d14
10008652:	eeb8 7b46 	vcvt.f64.u32	d7, s12
10008656:	ed9d cb10 	vldr	d12, [sp, #64]	@ 0x40
1000865a:	ed8d 7b0a 	vstr	d7, [sp, #40]	@ 0x28
1000865e:	ee2a 7b0f 	vmul.f64	d7, d10, d15
10008662:	ee25 5b08 	vmul.f64	d5, d5, d8
10008666:	ee2c 6b0f 	vmul.f64	d6, d12, d15
1000866a:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000866e:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10008672:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10008676:	eefc 5bc6 	vcvt.u32.f64	s11, d6
1000867a:	ed9d 6b0c 	vldr	d6, [sp, #48]	@ 0x30
1000867e:	ee07 ab4e 	vmls.f64	d10, d7, d14
10008682:	ee36 6b07 	vadd.f64	d6, d6, d7
10008686:	ed8d 6b06 	vstr	d6, [sp, #24]
1000868a:	ee2a 6b08 	vmul.f64	d6, d10, d8
1000868e:	eeb8 7b65 	vcvt.f64.u32	d7, s11
10008692:	eeb8 db45 	vcvt.f64.u32	d13, s10
10008696:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000869a:	eeb0 5b4c 	vmov.f64	d5, d12
1000869e:	eeb8 cb46 	vcvt.f64.u32	d12, s12
100086a2:	ee07 5b4e 	vmls.f64	d5, d7, d14
100086a6:	ed9d ab1a 	vldr	d10, [sp, #104]	@ 0x68
100086aa:	ee25 5b08 	vmul.f64	d5, d5, d8
100086ae:	ed8d cb12 	vstr	d12, [sp, #72]	@ 0x48
100086b2:	ed9d cb02 	vldr	d12, [sp, #8]
100086b6:	ee3a ab07 	vadd.f64	d10, d10, d7
100086ba:	ed8d db0e 	vstr	d13, [sp, #56]	@ 0x38
100086be:	ee2c 7b0f 	vmul.f64	d7, d12, d15
100086c2:	ed9d db04 	vldr	d13, [sp, #16]
100086c6:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100086ca:	ee2d 6b0f 	vmul.f64	d6, d13, d15
100086ce:	eeb8 cb45 	vcvt.f64.u32	d12, s10
100086d2:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100086d6:	ed8d cb14 	vstr	d12, [sp, #80]	@ 0x50
100086da:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100086de:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100086e2:	ed9d cb02 	vldr	d12, [sp, #8]
100086e6:	ee30 5b07 	vadd.f64	d5, d0, d7
100086ea:	ee07 cb4e 	vmls.f64	d12, d7, d14
100086ee:	eeb8 7b46 	vcvt.f64.u32	d7, s12
100086f2:	ed9d 0b1c 	vldr	d0, [sp, #112]	@ 0x70
100086f6:	ee07 db4e 	vmls.f64	d13, d7, d14
100086fa:	ee2c 6b08 	vmul.f64	d6, d12, d8
100086fe:	ee2d db08 	vmul.f64	d13, d13, d8
10008702:	ee30 cb07 	vadd.f64	d12, d0, d7
10008706:	ee23 7b0f 	vmul.f64	d7, d3, d15
1000870a:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000870e:	ed9d 8b00 	vldr	d8, [sp]
10008712:	eefc 6bcd 	vcvt.u32.f64	s13, d13
10008716:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000871a:	eeb8 0b66 	vcvt.f64.u32	d0, s13
1000871e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10008722:	eeb8 db46 	vcvt.f64.u32	d13, s12
10008726:	ee39 6b08 	vadd.f64	d6, d9, d8
1000872a:	ee28 8b0f 	vmul.f64	d8, d8, d15
1000872e:	ee07 3b4e 	vmls.f64	d3, d7, d14
10008732:	ed8d 8b4a 	vstr	d8, [sp, #296]	@ 0x128
10008736:	ee36 8b07 	vadd.f64	d8, d6, d7
1000873a:	ee24 7b0f 	vmul.f64	d7, d4, d15
1000873e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10008742:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10008746:	ee22 6b0f 	vmul.f64	d6, d2, d15
1000874a:	ee07 4b4e 	vmls.f64	d4, d7, d14
1000874e:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10008752:	eefc 7bc4 	vcvt.u32.f64	s15, d4
10008756:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000875a:	ee17 2a90 	vmov	r2, s15
1000875e:	ee06 2b4e 	vmls.f64	d2, d6, d14
10008762:	0fd3      	lsrs	r3, r2, #31
10008764:	eefc 7bc2 	vcvt.u32.f64	s15, d2
10008768:	ee07 3a10 	vmov	s14, r3
1000876c:	0853      	lsrs	r3, r2, #1
1000876e:	ed8d 0b16 	vstr	d0, [sp, #88]	@ 0x58
10008772:	ee29 9b0f 	vmul.f64	d9, d9, d15
10008776:	ee00 3a10 	vmov	s0, r3
1000877a:	ee17 ca90 	vmov	ip, s15
1000877e:	ed8d 9b54 	vstr	d9, [sp, #336]	@ 0x150
10008782:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10008786:	ed9f 9be2 	vldr	d9, [pc, #904]	@ 10008b10 <fndsa_vect_iFFT_fp64_exact+0x11e8>
1000878a:	eeb8 0bc0 	vcvt.f64.s32	d0, s0
1000878e:	ea4f 73dc 	mov.w	r3, ip, lsr #31
10008792:	ee07 0b09 	vmla.f64	d0, d7, d9
10008796:	f002 0201 	and.w	r2, r2, #1
1000879a:	ee07 3a10 	vmov	s14, r3
1000879e:	ea4f 035c 	mov.w	r3, ip, lsr #1
100087a2:	ee07 2a90 	vmov	s15, r2
100087a6:	ee02 3a10 	vmov	s4, r3
100087aa:	eeb8 6be7 	vcvt.f64.s32	d6, s15
100087ae:	eeb8 2bc2 	vcvt.f64.s32	d2, s4
100087b2:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100087b6:	f00c 0301 	and.w	r3, ip, #1
100087ba:	ee07 2b09 	vmla.f64	d2, d7, d9
100087be:	ed8d 3b5c 	vstr	d3, [sp, #368]	@ 0x170
100087c2:	ee07 3a90 	vmov	s15, r3
100087c6:	ee23 3b0f 	vmul.f64	d3, d3, d15
100087ca:	eeb8 7be7 	vcvt.f64.s32	d7, s15
100087ce:	ed8d 3b60 	vstr	d3, [sp, #384]	@ 0x180
100087d2:	ed9d 3b18 	vldr	d3, [sp, #96]	@ 0x60
100087d6:	ee07 3b09 	vmla.f64	d3, d7, d9
100087da:	ee2b 7b0f 	vmul.f64	d7, d11, d15
100087de:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100087e2:	ed9d 4b08 	vldr	d4, [sp, #32]
100087e6:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100087ea:	ee06 1b09 	vmla.f64	d1, d6, d9
100087ee:	ee07 bb4e 	vmls.f64	d11, d7, d14
100087f2:	ee24 6b0f 	vmul.f64	d6, d4, d15
100087f6:	eefc 7bcb 	vcvt.u32.f64	s15, d11
100087fa:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100087fe:	ee17 2a90 	vmov	r2, s15
10008802:	eeb8 7b46 	vcvt.f64.u32	d7, s12
10008806:	eeb0 6b44 	vmov.f64	d6, d4
1000880a:	ee07 6b4e 	vmls.f64	d6, d7, d14
1000880e:	0fd3      	lsrs	r3, r2, #31
10008810:	eefc 7bc6 	vcvt.u32.f64	s15, d6
10008814:	ee06 3a10 	vmov	s12, r3
10008818:	0853      	lsrs	r3, r2, #1
1000881a:	ee04 3a10 	vmov	s8, r3
1000881e:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10008822:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
10008826:	f002 0201 	and.w	r2, r2, #1
1000882a:	ee17 ea90 	vmov	lr, s15
1000882e:	ee06 4b09 	vmla.f64	d4, d6, d9
10008832:	ee07 2a90 	vmov	s15, r2
10008836:	ed8d 4b18 	vstr	d4, [sp, #96]	@ 0x60
1000883a:	eeb8 7be7 	vcvt.f64.s32	d7, s15
1000883e:	ed9d 4b0a 	vldr	d4, [sp, #40]	@ 0x28
10008842:	ea4f 73de 	mov.w	r3, lr, lsr #31
10008846:	ea4f 0c5e 	mov.w	ip, lr, lsr #1
1000884a:	ee07 4b09 	vmla.f64	d4, d7, d9
1000884e:	ee06 3a10 	vmov	s12, r3
10008852:	ee07 ca90 	vmov	s15, ip
10008856:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
1000885a:	eeb8 7be7 	vcvt.f64.s32	d7, s15
1000885e:	ee06 7b09 	vmla.f64	d7, d6, d9
10008862:	f00e 0301 	and.w	r3, lr, #1
10008866:	ed8d 4b10 	vstr	d4, [sp, #64]	@ 0x40
1000886a:	ed8d 7b0c 	vstr	d7, [sp, #48]	@ 0x30
1000886e:	ee07 3a90 	vmov	s15, r3
10008872:	ed9d 6b06 	vldr	d6, [sp, #24]
10008876:	ed9d bb0e 	vldr	d11, [sp, #56]	@ 0x38
1000887a:	eeb8 7be7 	vcvt.f64.s32	d7, s15
1000887e:	ee07 bb09 	vmla.f64	d11, d7, d9
10008882:	ee26 7b0f 	vmul.f64	d7, d6, d15
10008886:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000888a:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000888e:	eeb0 4b49 	vmov.f64	d4, d9
10008892:	ee2a 9b0f 	vmul.f64	d9, d10, d15
10008896:	ee07 6b4e 	vmls.f64	d6, d7, d14
1000889a:	eebc 9bc9 	vcvt.u32.f64	s18, d9
1000889e:	eefc 7bc6 	vcvt.u32.f64	s15, d6
100088a2:	eeb8 9b49 	vcvt.f64.u32	d9, s18
100088a6:	ee17 2a90 	vmov	r2, s15
100088aa:	ee09 ab4e 	vmls.f64	d10, d9, d14
100088ae:	0fd3      	lsrs	r3, r2, #31
100088b0:	ee06 3a10 	vmov	s12, r3
100088b4:	0853      	lsrs	r3, r2, #1
100088b6:	eefc 7bca 	vcvt.u32.f64	s15, d10
100088ba:	ee07 3a10 	vmov	s14, r3
100088be:	ee17 ea90 	vmov	lr, s15
100088c2:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100088c6:	f002 0201 	and.w	r2, r2, #1
100088ca:	eeb0 ab47 	vmov.f64	d10, d7
100088ce:	ee07 2a90 	vmov	s15, r2
100088d2:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
100088d6:	eeb8 7be7 	vcvt.f64.s32	d7, s15
100088da:	ed9d 9b12 	vldr	d9, [sp, #72]	@ 0x48
100088de:	ea4f 73de 	mov.w	r3, lr, lsr #31
100088e2:	ea4f 0c5e 	mov.w	ip, lr, lsr #1
100088e6:	ee06 ab04 	vmla.f64	d10, d6, d4
100088ea:	ee07 9b04 	vmla.f64	d9, d7, d4
100088ee:	ee06 3a10 	vmov	s12, r3
100088f2:	ee07 ca90 	vmov	s15, ip
100088f6:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
100088fa:	eeb8 7be7 	vcvt.f64.s32	d7, s15
100088fe:	ee06 7b04 	vmla.f64	d7, d6, d4
10008902:	f00e 0301 	and.w	r3, lr, #1
10008906:	ed8d 7b04 	vstr	d7, [sp, #16]
1000890a:	ee07 3a90 	vmov	s15, r3
1000890e:	ed9d 6b14 	vldr	d6, [sp, #80]	@ 0x50
10008912:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10008916:	ee07 6b04 	vmla.f64	d6, d7, d4
1000891a:	ee25 7b0f 	vmul.f64	d7, d5, d15
1000891e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10008922:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10008926:	ed8d 6b06 	vstr	d6, [sp, #24]
1000892a:	ee2c 6b0f 	vmul.f64	d6, d12, d15
1000892e:	ee07 5b4e 	vmls.f64	d5, d7, d14
10008932:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10008936:	eefc 7bc5 	vcvt.u32.f64	s15, d5
1000893a:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000893e:	ee17 3a90 	vmov	r3, s15
10008942:	ee06 cb4e 	vmls.f64	d12, d6, d14
10008946:	0fda      	lsrs	r2, r3, #31
10008948:	ee07 2a10 	vmov	s14, r2
1000894c:	085a      	lsrs	r2, r3, #1
1000894e:	ed8d ab08 	vstr	d10, [sp, #32]
10008952:	eefc 7bcc 	vcvt.u32.f64	s15, d12
10008956:	ee0a 2a10 	vmov	s20, r2
1000895a:	ee17 ea90 	vmov	lr, s15
1000895e:	eeb8 abca 	vcvt.f64.s32	d10, s20
10008962:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10008966:	f003 0301 	and.w	r3, r3, #1
1000896a:	ee07 ab04 	vmla.f64	d10, d7, d4
1000896e:	ee07 3a90 	vmov	s15, r3
10008972:	ea4f 025e 	mov.w	r2, lr, lsr #1
10008976:	ed8d 9b0a 	vstr	d9, [sp, #40]	@ 0x28
1000897a:	ea4f 7cde 	mov.w	ip, lr, lsr #31
1000897e:	ee09 2a10 	vmov	s18, r2
10008982:	f00e 0201 	and.w	r2, lr, #1
10008986:	ee07 2a10 	vmov	s14, r2
1000898a:	eeb8 6be7 	vcvt.f64.s32	d6, s15
1000898e:	ee07 ca90 	vmov	s15, ip
10008992:	ee06 db04 	vmla.f64	d13, d6, d4
10008996:	ed9d 5b16 	vldr	d5, [sp, #88]	@ 0x58
1000899a:	eeb8 6be7 	vcvt.f64.s32	d6, s15
1000899e:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100089a2:	ee07 5b04 	vmla.f64	d5, d7, d4
100089a6:	ee28 7b0f 	vmul.f64	d7, d8, d15
100089aa:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100089ae:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100089b2:	ee07 8b4e 	vmls.f64	d8, d7, d14
100089b6:	eebc 7bc8 	vcvt.u32.f64	s14, d8
100089ba:	ee17 3a10 	vmov	r3, s14
100089be:	0fdb      	lsrs	r3, r3, #31
100089c0:	ee07 3a10 	vmov	s14, r3
100089c4:	ed8d 8b5a 	vstr	d8, [sp, #360]	@ 0x168
100089c8:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100089cc:	ee28 8b0f 	vmul.f64	d8, d8, d15
100089d0:	eeb8 9bc9 	vcvt.f64.s32	d9, s18
100089d4:	ed8d 5b00 	vstr	d5, [sp]
100089d8:	ee06 9b04 	vmla.f64	d9, d6, d4
100089dc:	ed8d 7b62 	vstr	d7, [sp, #392]	@ 0x188
100089e0:	ed8d bb0e 	vstr	d11, [sp, #56]	@ 0x38
100089e4:	ed8d db02 	vstr	d13, [sp, #8]
100089e8:	ed8d 8b5e 	vstr	d8, [sp, #376]	@ 0x178
100089ec:	f7fd fb98 	bl	10006120 <fp64e_cmul_prepared>
100089f0:	eeb0 bb40 	vmov.f64	d11, d0
100089f4:	eeb0 db41 	vmov.f64	d13, d1
100089f8:	eeb0 cb42 	vmov.f64	d12, d2
100089fc:	eeb0 8b43 	vmov.f64	d8, d3
10008a00:	eeb0 0b4a 	vmov.f64	d0, d10
10008a04:	eeb0 2b49 	vmov.f64	d2, d9
10008a08:	ed9d 3b00 	vldr	d3, [sp]
10008a0c:	ed9d 1b02 	vldr	d1, [sp, #8]
10008a10:	ed8d bb1e 	vstr	d11, [sp, #120]	@ 0x78
10008a14:	ed8d db20 	vstr	d13, [sp, #128]	@ 0x80
10008a18:	ed8d cb22 	vstr	d12, [sp, #136]	@ 0x88
10008a1c:	ed8d 8b24 	vstr	d8, [sp, #144]	@ 0x90
10008a20:	f7fd fb7e 	bl	10006120 <fp64e_cmul_prepared>
10008a24:	ed9d 4b18 	vldr	d4, [sp, #96]	@ 0x60
10008a28:	ed9d 7b0e 	vldr	d7, [sp, #56]	@ 0x38
10008a2c:	ed81 4b00 	vstr	d4, [r1]
10008a30:	ed9d 4b10 	vldr	d4, [sp, #64]	@ 0x40
10008a34:	ed9d 5b0c 	vldr	d5, [sp, #48]	@ 0x30
10008a38:	ed9d ab08 	vldr	d10, [sp, #32]
10008a3c:	ed9d 9b0a 	vldr	d9, [sp, #40]	@ 0x28
10008a40:	ed81 4b02 	vstr	d4, [r1, #8]
10008a44:	ed9d 6b06 	vldr	d6, [sp, #24]
10008a48:	ed84 7b02 	vstr	d7, [r4, #8]
10008a4c:	ed9d 7b04 	vldr	d7, [sp, #16]
10008a50:	ed84 5b00 	vstr	d5, [r4]
10008a54:	3140      	adds	r1, #64	@ 0x40
10008a56:	ed01 ab0c 	vstr	d10, [r1, #-48]	@ 0xffffffd0
10008a5a:	ed01 9b0a 	vstr	d9, [r1, #-40]	@ 0xffffffd8
10008a5e:	4588      	cmp	r8, r1
10008a60:	ed84 7b04 	vstr	d7, [r4, #16]
10008a64:	ed84 6b06 	vstr	d6, [r4, #24]
10008a68:	ed8d 0b26 	vstr	d0, [sp, #152]	@ 0x98
10008a6c:	ed01 bb08 	vstr	d11, [r1, #-32]	@ 0xffffffe0
10008a70:	ed01 db06 	vstr	d13, [r1, #-24]	@ 0xffffffe8
10008a74:	f104 0440 	add.w	r4, r4, #64	@ 0x40
10008a78:	ed04 cb08 	vstr	d12, [r4, #-32]	@ 0xffffffe0
10008a7c:	ed04 8b06 	vstr	d8, [r4, #-24]	@ 0xffffffe8
10008a80:	f106 0620 	add.w	r6, r6, #32
10008a84:	ed01 0b04 	vstr	d0, [r1, #-16]
10008a88:	ed01 1b02 	vstr	d1, [r1, #-8]
10008a8c:	f107 0710 	add.w	r7, r7, #16
10008a90:	ed8d 1b28 	vstr	d1, [sp, #160]	@ 0xa0
10008a94:	ed04 2b04 	vstr	d2, [r4, #-16]
10008a98:	ed04 3b02 	vstr	d3, [r4, #-8]
10008a9c:	ed8d 2b2a 	vstr	d2, [sp, #168]	@ 0xa8
10008aa0:	ed8d 3b2c 	vstr	d3, [sp, #176]	@ 0xb0
10008aa4:	f47e af62 	bne.w	1000796c <fndsa_vect_iFFT_fp64_exact+0x44>
10008aa8:	f04f 0e04 	mov.w	lr, #4
10008aac:	f1ab 0103 	sub.w	r1, fp, #3
10008ab0:	2900      	cmp	r1, #0
10008ab2:	f000 825b 	beq.w	10008f6c <fndsa_vect_iFFT_fp64_exact+0x1644>
10008ab6:	2310      	movs	r3, #16
10008ab8:	ed9f eb17 	vldr	d14, [pc, #92]	@ 10008b18 <fndsa_vect_iFFT_fp64_exact+0x11f0>
10008abc:	ed9f fb18 	vldr	d15, [pc, #96]	@ 10008b20 <fndsa_vect_iFFT_fp64_exact+0x11f8>
10008ac0:	ed9f 9b13 	vldr	d9, [pc, #76]	@ 10008b10 <fndsa_vect_iFFT_fp64_exact+0x11e8>
10008ac4:	4e18      	ldr	r6, [pc, #96]	@ (10008b28 <fndsa_vect_iFFT_fp64_exact+0x1200>)
10008ac6:	fa03 fc0a 	lsl.w	ip, r3, sl
10008aca:	4672      	mov	r2, lr
10008acc:	2301      	movs	r3, #1
10008ace:	f04f 0810 	mov.w	r8, #16
10008ad2:	eb05 1702 	add.w	r7, r5, r2, lsl #4
10008ad6:	9208      	str	r2, [sp, #32]
10008ad8:	eeb7 db00 	vmov.f64	d13, #112	@ 0x3f800000  1.0
10008adc:	462a      	mov	r2, r5
10008ade:	f04f 0b00 	mov.w	fp, #0
10008ae2:	46e1      	mov	r9, ip
10008ae4:	408b      	lsls	r3, r1
10008ae6:	eb03 0353 	add.w	r3, r3, r3, lsr #1
10008aea:	ea4f 0e4e 	mov.w	lr, lr, lsl #1
10008aee:	fa08 f801 	lsl.w	r8, r8, r1
10008af2:	eb06 1303 	add.w	r3, r6, r3, lsl #4
10008af6:	eb08 0a06 	add.w	sl, r8, r6
10008afa:	9306      	str	r3, [sp, #24]
10008afc:	910a      	str	r1, [sp, #40]	@ 0x28
10008afe:	f8cd e010 	str.w	lr, [sp, #16]
10008b02:	ea4f 180e 	mov.w	r8, lr, lsl #4
10008b06:	960c      	str	r6, [sp, #48]	@ 0x30
10008b08:	950e      	str	r5, [sp, #56]	@ 0x38
10008b0a:	e00f      	b.n	10008b2c <fndsa_vect_iFFT_fp64_exact+0x1204>
10008b0c:	f3af 8000 	nop.w
10008b10:	00000000 	.word	0x00000000
10008b14:	41e00000 	.word	0x41e00000
10008b18:	00000000 	.word	0x00000000
10008b1c:	41f00000 	.word	0x41f00000
10008b20:	00000000 	.word	0x00000000
10008b24:	3df00000 	.word	0x3df00000
10008b28:	300039a0 	.word	0x300039a0
10008b2c:	edda 7a02 	vldr	s15, [sl, #8]
10008b30:	f8da 3004 	ldr.w	r3, [sl, #4]
10008b34:	eeb8 4b67 	vcvt.f64.u32	d4, s15
10008b38:	0fdb      	lsrs	r3, r3, #31
10008b3a:	ee03 3a10 	vmov	s6, r3
10008b3e:	ee3e 4b44 	vsub.f64	d4, d14, d4
10008b42:	eeb8 3bc3 	vcvt.f64.s32	d3, s6
10008b46:	edda 7a03 	vldr	s15, [sl, #12]
10008b4a:	ed8d 3b4e 	vstr	d3, [sp, #312]	@ 0x138
10008b4e:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10008b52:	ee24 3b0f 	vmul.f64	d3, d4, d15
10008b56:	ee3e 7b47 	vsub.f64	d7, d14, d7
10008b5a:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10008b5e:	edda 6a00 	vldr	s13, [sl]
10008b62:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10008b66:	ee37 7b4d 	vsub.f64	d7, d7, d13
10008b6a:	eeb8 5b66 	vcvt.f64.u32	d5, s13
10008b6e:	ee37 7b03 	vadd.f64	d7, d7, d3
10008b72:	edda 6a01 	vldr	s13, [sl, #4]
10008b76:	ee03 4b4e 	vmls.f64	d4, d3, d14
10008b7a:	eeb8 6b66 	vcvt.f64.u32	d6, s13
10008b7e:	ee27 3b0f 	vmul.f64	d3, d7, d15
10008b82:	ee26 2b0f 	vmul.f64	d2, d6, d15
10008b86:	ee25 1b0f 	vmul.f64	d1, d5, d15
10008b8a:	ed8d 5b48 	vstr	d5, [sp, #288]	@ 0x120
10008b8e:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10008b92:	ee34 5b05 	vadd.f64	d5, d4, d5
10008b96:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10008b9a:	ed8d 2b4a 	vstr	d2, [sp, #296]	@ 0x128
10008b9e:	ed8d 4b52 	vstr	d4, [sp, #328]	@ 0x148
10008ba2:	ee24 2b0f 	vmul.f64	d2, d4, d15
10008ba6:	ee25 4b0f 	vmul.f64	d4, d5, d15
10008baa:	ee03 7b4e 	vmls.f64	d7, d3, d14
10008bae:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10008bb2:	eefc 3bc7 	vcvt.u32.f64	s7, d7
10008bb6:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10008bba:	ed8d 6b46 	vstr	d6, [sp, #280]	@ 0x118
10008bbe:	ee37 6b06 	vadd.f64	d6, d7, d6
10008bc2:	ee13 1a90 	vmov	r1, s7
10008bc6:	ed8d 7b50 	vstr	d7, [sp, #320]	@ 0x140
10008bca:	ee27 3b0f 	vmul.f64	d3, d7, d15
10008bce:	ee36 7b04 	vadd.f64	d7, d6, d4
10008bd2:	ee27 6b0f 	vmul.f64	d6, d7, d15
10008bd6:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10008bda:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10008bde:	ee06 7b4e 	vmls.f64	d7, d6, d14
10008be2:	eefc 6bc7 	vcvt.u32.f64	s13, d7
10008be6:	0fc9      	lsrs	r1, r1, #31
10008be8:	ee04 5b4e 	vmls.f64	d5, d4, d14
10008bec:	ee04 1a10 	vmov	s8, r1
10008bf0:	ee16 1a90 	vmov	r1, s13
10008bf4:	0fc9      	lsrs	r1, r1, #31
10008bf6:	ee27 6b0f 	vmul.f64	d6, d7, d15
10008bfa:	ed8d 7b5a 	vstr	d7, [sp, #360]	@ 0x168
10008bfe:	ee07 1a10 	vmov	s14, r1
10008c02:	ed8d 2b56 	vstr	d2, [sp, #344]	@ 0x158
10008c06:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
10008c0a:	ee25 2b0f 	vmul.f64	d2, d5, d15
10008c0e:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10008c12:	9b08      	ldr	r3, [sp, #32]
10008c14:	ed8d 1b4c 	vstr	d1, [sp, #304]	@ 0x130
10008c18:	445b      	add	r3, fp
10008c1a:	459b      	cmp	fp, r3
10008c1c:	ed8d 3b54 	vstr	d3, [sp, #336]	@ 0x150
10008c20:	ed8d 5b5c 	vstr	d5, [sp, #368]	@ 0x170
10008c24:	ed8d 4b58 	vstr	d4, [sp, #352]	@ 0x160
10008c28:	ed8d 2b60 	vstr	d2, [sp, #384]	@ 0x180
10008c2c:	ed8d 6b5e 	vstr	d6, [sp, #376]	@ 0x178
10008c30:	ed8d 7b62 	vstr	d7, [sp, #392]	@ 0x188
10008c34:	f080 8187 	bcs.w	10008f46 <fndsa_vect_iFFT_fp64_exact+0x161e>
10008c38:	463e      	mov	r6, r7
10008c3a:	4611      	mov	r1, r2
10008c3c:	eb09 0502 	add.w	r5, r9, r2
10008c40:	eb09 0407 	add.w	r4, r9, r7
10008c44:	9202      	str	r2, [sp, #8]
10008c46:	ed91 ab02 	vldr	d10, [r1, #8]
10008c4a:	ed96 7b02 	vldr	d7, [r6, #8]
10008c4e:	ee3a 0b0e 	vadd.f64	d0, d10, d14
10008c52:	ed91 cb00 	vldr	d12, [r1]
10008c56:	ee37 ab0a 	vadd.f64	d10, d7, d10
10008c5a:	ee30 7b47 	vsub.f64	d7, d0, d7
10008c5e:	ed96 3b00 	vldr	d3, [r6]
10008c62:	ee3c 1b0e 	vadd.f64	d1, d12, d14
10008c66:	ee27 2b0f 	vmul.f64	d2, d7, d15
10008c6a:	ee33 cb0c 	vadd.f64	d12, d3, d12
10008c6e:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10008c72:	ee31 3b43 	vsub.f64	d3, d1, d3
10008c76:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10008c7a:	ee33 3b4d 	vsub.f64	d3, d3, d13
10008c7e:	ee33 3b02 	vadd.f64	d3, d3, d2
10008c82:	ee02 7b4e 	vmls.f64	d7, d2, d14
10008c86:	ee23 1b0f 	vmul.f64	d1, d3, d15
10008c8a:	ee37 7b0d 	vadd.f64	d7, d7, d13
10008c8e:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10008c92:	ed95 bb02 	vldr	d11, [r5, #8]
10008c96:	ee27 2b0f 	vmul.f64	d2, d7, d15
10008c9a:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10008c9e:	ed94 5b02 	vldr	d5, [r4, #8]
10008ca2:	eefc 0bc2 	vcvt.u32.f64	s1, d2
10008ca6:	ee01 3b4e 	vmls.f64	d3, d1, d14
10008caa:	ee3b 2b0e 	vadd.f64	d2, d11, d14
10008cae:	ed9f 4bb4 	vldr	d4, [pc, #720]	@ 10008f80 <fndsa_vect_iFFT_fp64_exact+0x1658>
10008cb2:	ee3b bb05 	vadd.f64	d11, d11, d5
10008cb6:	ee32 2b45 	vsub.f64	d2, d2, d5
10008cba:	ee33 3b04 	vadd.f64	d3, d3, d4
10008cbe:	eeb8 5b60 	vcvt.f64.u32	d5, s1
10008cc2:	ed94 8b00 	vldr	d8, [r4]
10008cc6:	ed95 6b00 	vldr	d6, [r5]
10008cca:	ee33 3b05 	vadd.f64	d3, d3, d5
10008cce:	ee36 4b0e 	vadd.f64	d4, d6, d14
10008cd2:	ee23 0b0f 	vmul.f64	d0, d3, d15
10008cd6:	ee36 6b08 	vadd.f64	d6, d6, d8
10008cda:	ee05 7b4e 	vmls.f64	d7, d5, d14
10008cde:	ee22 5b0f 	vmul.f64	d5, d2, d15
10008ce2:	ed8d 6b00 	vstr	d6, [sp]
10008ce6:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10008cea:	eeb6 6b00 	vmov.f64	d6, #96	@ 0x3f000000  0.5
10008cee:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10008cf2:	ee27 7b06 	vmul.f64	d7, d7, d6
10008cf6:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10008cfa:	ee34 6b48 	vsub.f64	d6, d4, d8
10008cfe:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10008d02:	ee00 3b4e 	vmls.f64	d3, d0, d14
10008d06:	ee36 6b4d 	vsub.f64	d6, d6, d13
10008d0a:	ee05 2b4e 	vmls.f64	d2, d5, d14
10008d0e:	ee36 6b05 	vadd.f64	d6, d6, d5
10008d12:	eefc 5bc3 	vcvt.u32.f64	s11, d3
10008d16:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10008d1a:	ee32 2b0d 	vadd.f64	d2, d2, d13
10008d1e:	ee15 3a90 	vmov	r3, s11
10008d22:	eeb8 1b47 	vcvt.f64.u32	d1, s14
10008d26:	ee22 7b0f 	vmul.f64	d7, d2, d15
10008d2a:	0fda      	lsrs	r2, r3, #31
10008d2c:	eefc 3bc7 	vcvt.u32.f64	s7, d7
10008d30:	ee07 2a10 	vmov	s14, r2
10008d34:	085a      	lsrs	r2, r3, #1
10008d36:	ee00 2a10 	vmov	s0, r2
10008d3a:	ee26 4b0f 	vmul.f64	d4, d6, d15
10008d3e:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10008d42:	eeb8 0bc0 	vcvt.f64.s32	d0, s0
10008d46:	f003 0301 	and.w	r3, r3, #1
10008d4a:	ee07 0b09 	vmla.f64	d0, d7, d9
10008d4e:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10008d52:	ee07 3a90 	vmov	s15, r3
10008d56:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10008d5a:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10008d5e:	ee04 6b4e 	vmls.f64	d6, d4, d14
10008d62:	ee07 1b09 	vmla.f64	d1, d7, d9
10008d66:	ed9f 7b86 	vldr	d7, [pc, #536]	@ 10008f80 <fndsa_vect_iFFT_fp64_exact+0x1658>
10008d6a:	eeb8 4b63 	vcvt.f64.u32	d4, s7
10008d6e:	ee36 6b07 	vadd.f64	d6, d6, d7
10008d72:	ee36 7b04 	vadd.f64	d7, d6, d4
10008d76:	ee2a 5b0f 	vmul.f64	d5, d10, d15
10008d7a:	ee04 2b4e 	vmls.f64	d2, d4, d14
10008d7e:	ee27 4b0f 	vmul.f64	d4, d7, d15
10008d82:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10008d86:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10008d8a:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10008d8e:	eeb6 6b00 	vmov.f64	d6, #96	@ 0x3f000000  0.5
10008d92:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10008d96:	ee22 2b06 	vmul.f64	d2, d2, d6
10008d9a:	ee3c 6b05 	vadd.f64	d6, d12, d5
10008d9e:	ee04 7b4e 	vmls.f64	d7, d4, d14
10008da2:	ee26 8b0f 	vmul.f64	d8, d6, d15
10008da6:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10008daa:	ee05 ab4e 	vmls.f64	d10, d5, d14
10008dae:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10008db2:	ee3a 5b0d 	vadd.f64	d5, d10, d13
10008db6:	eeb8 3b42 	vcvt.f64.u32	d3, s4
10008dba:	eebc 2bc8 	vcvt.u32.f64	s4, d8
10008dbe:	ee17 3a90 	vmov	r3, s15
10008dc2:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10008dc6:	ee25 4b0f 	vmul.f64	d4, d5, d15
10008dca:	0fda      	lsrs	r2, r3, #31
10008dcc:	ee08 2a10 	vmov	s16, r2
10008dd0:	085a      	lsrs	r2, r3, #1
10008dd2:	ee02 6b4e 	vmls.f64	d6, d2, d14
10008dd6:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10008dda:	ee02 2a10 	vmov	s4, r2
10008dde:	ed9f 7b68 	vldr	d7, [pc, #416]	@ 10008f80 <fndsa_vect_iFFT_fp64_exact+0x1658>
10008de2:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10008de6:	eeb8 8bc8 	vcvt.f64.s32	d8, s16
10008dea:	eeb8 2bc2 	vcvt.f64.s32	d2, s4
10008dee:	ee36 6b07 	vadd.f64	d6, d6, d7
10008df2:	ee08 2b09 	vmla.f64	d2, d8, d9
10008df6:	eeb6 ab00 	vmov.f64	d10, #96	@ 0x3f000000  0.5
10008dfa:	ee2b 8b0f 	vmul.f64	d8, d11, d15
10008dfe:	ee04 5b4e 	vmls.f64	d5, d4, d14
10008e02:	ee36 6b04 	vadd.f64	d6, d6, d4
10008e06:	f003 0301 	and.w	r3, r3, #1
10008e0a:	ee25 5b0a 	vmul.f64	d5, d5, d10
10008e0e:	ee07 3a90 	vmov	s15, r3
10008e12:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10008e16:	ee26 4b0f 	vmul.f64	d4, d6, d15
10008e1a:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10008e1e:	eebc abc5 	vcvt.u32.f64	s20, d5
10008e22:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10008e26:	ed9d 5b00 	vldr	d5, [sp]
10008e2a:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10008e2e:	ee07 3b09 	vmla.f64	d3, d7, d9
10008e32:	ee35 7b08 	vadd.f64	d7, d5, d8
10008e36:	eeb0 5b4b 	vmov.f64	d5, d11
10008e3a:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10008e3e:	ee08 5b4e 	vmls.f64	d5, d8, d14
10008e42:	ee27 cb0f 	vmul.f64	d12, d7, d15
10008e46:	ee04 6b4e 	vmls.f64	d6, d4, d14
10008e4a:	ee35 5b0d 	vadd.f64	d5, d5, d13
10008e4e:	eebc cbcc 	vcvt.u32.f64	s24, d12
10008e52:	eefc 6bc6 	vcvt.u32.f64	s13, d6
10008e56:	ee25 4b0f 	vmul.f64	d4, d5, d15
10008e5a:	eeb8 cb4c 	vcvt.f64.u32	d12, s24
10008e5e:	ee16 3a90 	vmov	r3, s13
10008e62:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10008e66:	ed9f 6b46 	vldr	d6, [pc, #280]	@ 10008f80 <fndsa_vect_iFFT_fp64_exact+0x1658>
10008e6a:	ee0c 7b4e 	vmls.f64	d7, d12, d14
10008e6e:	0fda      	lsrs	r2, r3, #31
10008e70:	eeb8 bb4a 	vcvt.f64.u32	d11, s20
10008e74:	ee0a 2a10 	vmov	s20, r2
10008e78:	085a      	lsrs	r2, r3, #1
10008e7a:	f003 0301 	and.w	r3, r3, #1
10008e7e:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10008e82:	ee37 7b06 	vadd.f64	d7, d7, d6
10008e86:	ee06 3a90 	vmov	s13, r3
10008e8a:	ee37 7b04 	vadd.f64	d7, d7, d4
10008e8e:	eeb8 6be6 	vcvt.f64.s32	d6, s13
10008e92:	ee06 bb09 	vmla.f64	d11, d6, d9
10008e96:	ee27 6b0f 	vmul.f64	d6, d7, d15
10008e9a:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10008e9e:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10008ea2:	ee08 2a10 	vmov	s16, r2
10008ea6:	ee06 7b4e 	vmls.f64	d7, d6, d14
10008eaa:	eeb8 abca 	vcvt.f64.s32	d10, s20
10008eae:	eeb8 8bc8 	vcvt.f64.s32	d8, s16
10008eb2:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10008eb6:	ee04 5b4e 	vmls.f64	d5, d4, d14
10008eba:	ee0a 8b09 	vmla.f64	d8, d10, d9
10008ebe:	eeb6 ab00 	vmov.f64	d10, #96	@ 0x3f000000  0.5
10008ec2:	ee17 3a90 	vmov	r3, s15
10008ec6:	ee25 5b0a 	vmul.f64	d5, d5, d10
10008eca:	0fda      	lsrs	r2, r3, #31
10008ecc:	ee04 2a10 	vmov	s8, r2
10008ed0:	085a      	lsrs	r2, r3, #1
10008ed2:	f003 0301 	and.w	r3, r3, #1
10008ed6:	ee06 2a10 	vmov	s12, r2
10008eda:	ee07 3a90 	vmov	s15, r3
10008ede:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10008ee2:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
10008ee6:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10008eea:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10008eee:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10008ef2:	ee07 5b09 	vmla.f64	d5, d7, d9
10008ef6:	ee04 6b09 	vmla.f64	d6, d4, d9
10008efa:	ed81 8b00 	vstr	d8, [r1]
10008efe:	ed81 bb02 	vstr	d11, [r1, #8]
10008f02:	a846      	add	r0, sp, #280	@ 0x118
10008f04:	ed85 6b00 	vstr	d6, [r5]
10008f08:	ed85 5b02 	vstr	d5, [r5, #8]
10008f0c:	f7fd f908 	bl	10006120 <fp64e_cmul_prepared>
10008f10:	3110      	adds	r1, #16
10008f12:	428f      	cmp	r7, r1
10008f14:	ed86 0b00 	vstr	d0, [r6]
10008f18:	ed86 1b02 	vstr	d1, [r6, #8]
10008f1c:	ed8d 0b3e 	vstr	d0, [sp, #248]	@ 0xf8
10008f20:	ed84 2b00 	vstr	d2, [r4]
10008f24:	ed84 3b02 	vstr	d3, [r4, #8]
10008f28:	ed8d 1b40 	vstr	d1, [sp, #256]	@ 0x100
10008f2c:	ed8d 2b42 	vstr	d2, [sp, #264]	@ 0x108
10008f30:	ed8d 3b44 	vstr	d3, [sp, #272]	@ 0x110
10008f34:	f105 0510 	add.w	r5, r5, #16
10008f38:	f106 0610 	add.w	r6, r6, #16
10008f3c:	f104 0410 	add.w	r4, r4, #16
10008f40:	f47f ae81 	bne.w	10008c46 <fndsa_vect_iFFT_fp64_exact+0x131e>
10008f44:	9a02      	ldr	r2, [sp, #8]
10008f46:	9b04      	ldr	r3, [sp, #16]
10008f48:	f10a 0a10 	add.w	sl, sl, #16
10008f4c:	449b      	add	fp, r3
10008f4e:	9b06      	ldr	r3, [sp, #24]
10008f50:	4442      	add	r2, r8
10008f52:	4553      	cmp	r3, sl
10008f54:	4447      	add	r7, r8
10008f56:	f47f ade9 	bne.w	10008b2c <fndsa_vect_iFFT_fp64_exact+0x1204>
10008f5a:	990a      	ldr	r1, [sp, #40]	@ 0x28
10008f5c:	46cc      	mov	ip, r9
10008f5e:	3901      	subs	r1, #1
10008f60:	f8dd e010 	ldr.w	lr, [sp, #16]
10008f64:	9e0c      	ldr	r6, [sp, #48]	@ 0x30
10008f66:	9d0e      	ldr	r5, [sp, #56]	@ 0x38
10008f68:	f47f adaf 	bne.w	10008aca <fndsa_vect_iFFT_fp64_exact+0x11a2>
10008f6c:	b065      	add	sp, #404	@ 0x194
10008f6e:	ecbd 8b10 	vpop	{d8-d15}
10008f72:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10008f76:	4651      	mov	r1, sl
10008f78:	f04f 0e01 	mov.w	lr, #1
10008f7c:	e598      	b.n	10008ab0 <fndsa_vect_iFFT_fp64_exact+0x1188>
10008f7e:	bf00      	nop
	...

