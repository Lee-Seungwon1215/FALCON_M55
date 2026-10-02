10008bc8 <fndsa_vect_iFFT_fp64_exact>:
10008bc8:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10008bcc:	ed2d 8b10 	vpush	{d8-d15}
10008bd0:	2802      	cmp	r0, #2
10008bd2:	460d      	mov	r5, r1
10008bd4:	b0e5      	sub	sp, #404	@ 0x194
10008bd6:	f100 3aff 	add.w	sl, r0, #4294967295	@ 0xffffffff
10008bda:	f241 831c 	bls.w	1000a216 <fndsa_vect_iFFT_fp64_exact+0x164e>
10008bde:	2301      	movs	r3, #1
10008be0:	2410      	movs	r4, #16
10008be2:	4683      	mov	fp, r0
10008be4:	ed9f fbf8 	vldr	d15, [pc, #992]	@ 10008fc8 <fndsa_vect_iFFT_fp64_exact+0x400>
10008be8:	ed9f ebf9 	vldr	d14, [pc, #996]	@ 10008fd0 <fndsa_vect_iFFT_fp64_exact+0x408>
10008bec:	fa03 f30a 	lsl.w	r3, r3, sl
10008bf0:	4efb      	ldr	r6, [pc, #1004]	@ (10008fe0 <fndsa_vect_iFFT_fp64_exact+0x418>)
10008bf2:	1e5a      	subs	r2, r3, #1
10008bf4:	fa04 f40a 	lsl.w	r4, r4, sl
10008bf8:	f101 0840 	add.w	r8, r1, #64	@ 0x40
10008bfc:	085b      	lsrs	r3, r3, #1
10008bfe:	0892      	lsrs	r2, r2, #2
10008c00:	eb06 1703 	add.w	r7, r6, r3, lsl #4
10008c04:	eb08 1882 	add.w	r8, r8, r2, lsl #6
10008c08:	4426      	add	r6, r4
10008c0a:	440c      	add	r4, r1
10008c0c:	edd6 7a02 	vldr	s15, [r6, #8]
10008c10:	eeb8 db67 	vcvt.f64.u32	d13, s15
10008c14:	edd6 7a03 	vldr	s15, [r6, #12]
10008c18:	6873      	ldr	r3, [r6, #4]
10008c1a:	eeb8 2b67 	vcvt.f64.u32	d2, s15
10008c1e:	0fdb      	lsrs	r3, r3, #31
10008c20:	ee08 3a10 	vmov	s16, r3
10008c24:	eeb7 0b00 	vmov.f64	d0, #112	@ 0x3f800000  1.0
10008c28:	eeb8 8bc8 	vcvt.f64.s32	d8, s16
10008c2c:	ee3e 2b42 	vsub.f64	d2, d14, d2
10008c30:	ed91 9b0a 	vldr	d9, [r1, #40]	@ 0x28
10008c34:	edd6 7a00 	vldr	s15, [r6]
10008c38:	ed91 4b02 	vldr	d4, [r1, #8]
10008c3c:	ed91 bb0e 	vldr	d11, [r1, #56]	@ 0x38
10008c40:	ed94 ab0a 	vldr	d10, [r4, #40]	@ 0x28
10008c44:	eeb8 6b67 	vcvt.f64.u32	d6, s15
10008c48:	ee32 2b40 	vsub.f64	d2, d2, d0
10008c4c:	edd6 7a01 	vldr	s15, [r6, #4]
10008c50:	ed8d 8b4e 	vstr	d8, [sp, #312]	@ 0x138
10008c54:	ed91 3b06 	vldr	d3, [r1, #24]
10008c58:	ed94 5b02 	vldr	d5, [r4, #8]
10008c5c:	ed94 cb0e 	vldr	d12, [r4, #56]	@ 0x38
10008c60:	ee39 8b0e 	vadd.f64	d8, d9, d14
10008c64:	ed8d 2b12 	vstr	d2, [sp, #72]	@ 0x48
10008c68:	ee39 9b0b 	vadd.f64	d9, d9, d11
10008c6c:	ee38 bb4b 	vsub.f64	d11, d8, d11
10008c70:	ed91 8b00 	vldr	d8, [r1]
10008c74:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10008c78:	ee34 2b0e 	vadd.f64	d2, d4, d14
10008c7c:	ee3a 0b0e 	vadd.f64	d0, d10, d14
10008c80:	ee33 4b04 	vadd.f64	d4, d3, d4
10008c84:	ed94 1b06 	vldr	d1, [r4, #24]
10008c88:	ed8d 7b00 	vstr	d7, [sp]
10008c8c:	ed8d 7b46 	vstr	d7, [sp, #280]	@ 0x118
10008c90:	ed91 7b00 	vldr	d7, [r1]
10008c94:	ee32 2b43 	vsub.f64	d2, d2, d3
10008c98:	ee3a ab0c 	vadd.f64	d10, d10, d12
10008c9c:	ee30 cb4c 	vsub.f64	d12, d0, d12
10008ca0:	ee35 3b0e 	vadd.f64	d3, d5, d14
10008ca4:	ee38 0b0e 	vadd.f64	d0, d8, d14
10008ca8:	ed91 8b04 	vldr	d8, [r1, #16]
10008cac:	ee35 5b01 	vadd.f64	d5, d5, d1
10008cb0:	ee33 3b41 	vsub.f64	d3, d3, d1
10008cb4:	ee38 8b07 	vadd.f64	d8, d8, d7
10008cb8:	ee22 1b0f 	vmul.f64	d1, d2, d15
10008cbc:	ed8d 8b02 	vstr	d8, [sp, #8]
10008cc0:	ed91 8b04 	vldr	d8, [r1, #16]
10008cc4:	eeb7 7b00 	vmov.f64	d7, #112	@ 0x3f800000  1.0
10008cc8:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10008ccc:	ee30 0b48 	vsub.f64	d0, d0, d8
10008cd0:	ed94 8b00 	vldr	d8, [r4]
10008cd4:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10008cd8:	ee30 0b47 	vsub.f64	d0, d0, d7
10008cdc:	ee01 2b4e 	vmls.f64	d2, d1, d14
10008ce0:	ee30 0b01 	vadd.f64	d0, d0, d1
10008ce4:	ee32 1b07 	vadd.f64	d1, d2, d7
10008ce8:	ed94 7b04 	vldr	d7, [r4, #16]
10008cec:	ee23 2b0f 	vmul.f64	d2, d3, d15
10008cf0:	ed8d 1b0c 	vstr	d1, [sp, #48]	@ 0x30
10008cf4:	ee38 1b0e 	vadd.f64	d1, d8, d14
10008cf8:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10008cfc:	ee38 8b07 	vadd.f64	d8, d8, d7
10008d00:	ee31 1b47 	vsub.f64	d1, d1, d7
10008d04:	eeb7 7b00 	vmov.f64	d7, #112	@ 0x3f800000  1.0
10008d08:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10008d0c:	ee31 1b47 	vsub.f64	d1, d1, d7
10008d10:	ee02 3b4e 	vmls.f64	d3, d2, d14
10008d14:	ee31 1b02 	vadd.f64	d1, d1, d2
10008d18:	ee33 2b07 	vadd.f64	d2, d3, d7
10008d1c:	ee24 3b0f 	vmul.f64	d3, d4, d15
10008d20:	ed8d 2b0a 	vstr	d2, [sp, #40]	@ 0x28
10008d24:	ed8d 8b04 	vstr	d8, [sp, #16]
10008d28:	ed9d 8b02 	vldr	d8, [sp, #8]
10008d2c:	ee25 2b0f 	vmul.f64	d2, d5, d15
10008d30:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10008d34:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10008d38:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10008d3c:	ee03 4b4e 	vmls.f64	d4, d3, d14
10008d40:	ee38 8b03 	vadd.f64	d8, d8, d3
10008d44:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10008d48:	eeb0 3b47 	vmov.f64	d3, d7
10008d4c:	ee34 7b07 	vadd.f64	d7, d4, d7
10008d50:	ed9d 4b04 	vldr	d4, [sp, #16]
10008d54:	ee02 5b4e 	vmls.f64	d5, d2, d14
10008d58:	ee34 4b02 	vadd.f64	d4, d4, d2
10008d5c:	ee35 5b03 	vadd.f64	d5, d5, d3
10008d60:	ed8d 4b02 	vstr	d4, [sp, #8]
10008d64:	ed8d 6b48 	vstr	d6, [sp, #288]	@ 0x120
10008d68:	ed8d 7b10 	vstr	d7, [sp, #64]	@ 0x40
10008d6c:	ee29 4b0f 	vmul.f64	d4, d9, d15
10008d70:	ed8d 5b0e 	vstr	d5, [sp, #56]	@ 0x38
10008d74:	ee2a 5b0f 	vmul.f64	d5, d10, d15
10008d78:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10008d7c:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10008d80:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10008d84:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10008d88:	ee04 9b4e 	vmls.f64	d9, d4, d14
10008d8c:	ee39 7b03 	vadd.f64	d7, d9, d3
10008d90:	ee05 ab4e 	vmls.f64	d10, d5, d14
10008d94:	ed8d 7b08 	vstr	d7, [sp, #32]
10008d98:	ed91 7b0c 	vldr	d7, [r1, #48]	@ 0x30
10008d9c:	ee3a 2b03 	vadd.f64	d2, d10, d3
10008da0:	ee2b 9b0f 	vmul.f64	d9, d11, d15
10008da4:	ed91 ab08 	vldr	d10, [r1, #32]
10008da8:	ed91 3b08 	vldr	d3, [r1, #32]
10008dac:	ed8d 2b06 	vstr	d2, [sp, #24]
10008db0:	ee3a 2b07 	vadd.f64	d2, d10, d7
10008db4:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10008db8:	ee33 3b0e 	vadd.f64	d3, d3, d14
10008dbc:	ee32 2b04 	vadd.f64	d2, d2, d4
10008dc0:	ee33 3b47 	vsub.f64	d3, d3, d7
10008dc4:	eeb7 4b00 	vmov.f64	d4, #112	@ 0x3f800000  1.0
10008dc8:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10008dcc:	ee33 3b44 	vsub.f64	d3, d3, d4
10008dd0:	ee09 bb4e 	vmls.f64	d11, d9, d14
10008dd4:	ee33 9b09 	vadd.f64	d9, d3, d9
10008dd8:	ee3b 3b04 	vadd.f64	d3, d11, d4
10008ddc:	eeb0 7b44 	vmov.f64	d7, d4
10008de0:	ee3e db4d 	vsub.f64	d13, d14, d13
10008de4:	ed8d 3b04 	vstr	d3, [sp, #16]
10008de8:	ed94 3b08 	vldr	d3, [r4, #32]
10008dec:	ed94 bb0c 	vldr	d11, [r4, #48]	@ 0x30
10008df0:	ee33 4b0e 	vadd.f64	d4, d3, d14
10008df4:	ee33 3b0b 	vadd.f64	d3, d3, d11
10008df8:	ee34 4b4b 	vsub.f64	d4, d4, d11
10008dfc:	ee2c ab0f 	vmul.f64	d10, d12, d15
10008e00:	eebc abca 	vcvt.u32.f64	s20, d10
10008e04:	ee34 4b47 	vsub.f64	d4, d4, d7
10008e08:	ed9d bb12 	vldr	d11, [sp, #72]	@ 0x48
10008e0c:	ee33 3b05 	vadd.f64	d3, d3, d5
10008e10:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10008e14:	ee2d 5b0f 	vmul.f64	d5, d13, d15
10008e18:	ee0a cb4e 	vmls.f64	d12, d10, d14
10008e1c:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10008e20:	ee34 ab0a 	vadd.f64	d10, d4, d10
10008e24:	ee20 4b0f 	vmul.f64	d4, d0, d15
10008e28:	ee3c cb07 	vadd.f64	d12, d12, d7
10008e2c:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10008e30:	eefc 7bc4 	vcvt.u32.f64	s15, d4
10008e34:	ee05 db4e 	vmls.f64	d13, d5, d14
10008e38:	ee3b bb05 	vadd.f64	d11, d11, d5
10008e3c:	eeb8 5b67 	vcvt.f64.u32	d5, s15
10008e40:	ed9f 7b65 	vldr	d7, [pc, #404]	@ 10008fd8 <fndsa_vect_iFFT_fp64_exact+0x410>
10008e44:	ee05 0b4e 	vmls.f64	d0, d5, d14
10008e48:	ee21 5b0f 	vmul.f64	d5, d1, d15
10008e4c:	ee30 0b07 	vadd.f64	d0, d0, d7
10008e50:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10008e54:	ed8d 0b12 	vstr	d0, [sp, #72]	@ 0x48
10008e58:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10008e5c:	ee28 0b0f 	vmul.f64	d0, d8, d15
10008e60:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10008e64:	ee05 1b4e 	vmls.f64	d1, d5, d14
10008e68:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10008e6c:	eeb0 4b4d 	vmov.f64	d4, d13
10008e70:	ee00 8b4e 	vmls.f64	d8, d0, d14
10008e74:	ee31 0b07 	vadd.f64	d0, d1, d7
10008e78:	ed9d 1b02 	vldr	d1, [sp, #8]
10008e7c:	ed8d db52 	vstr	d13, [sp, #328]	@ 0x148
10008e80:	ee21 5b0f 	vmul.f64	d5, d1, d15
10008e84:	ee22 db0f 	vmul.f64	d13, d2, d15
10008e88:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10008e8c:	eebc dbcd 	vcvt.u32.f64	s26, d13
10008e90:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10008e94:	ee05 1b4e 	vmls.f64	d1, d5, d14
10008e98:	eeb8 5b4d 	vcvt.f64.u32	d5, s26
10008e9c:	ee31 db07 	vadd.f64	d13, d1, d7
10008ea0:	ee05 2b4e 	vmls.f64	d2, d5, d14
10008ea4:	ed8d db02 	vstr	d13, [sp, #8]
10008ea8:	ee23 5b0f 	vmul.f64	d5, d3, d15
10008eac:	ee32 db07 	vadd.f64	d13, d2, d7
10008eb0:	ee29 2b0f 	vmul.f64	d2, d9, d15
10008eb4:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10008eb8:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10008ebc:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10008ec0:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10008ec4:	ee05 3b4e 	vmls.f64	d3, d5, d14
10008ec8:	ed8d db14 	vstr	d13, [sp, #80]	@ 0x50
10008ecc:	ee02 9b4e 	vmls.f64	d9, d2, d14
10008ed0:	ee2a 5b0f 	vmul.f64	d5, d10, d15
10008ed4:	ee33 db07 	vadd.f64	d13, d3, d7
10008ed8:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10008edc:	ee2b 3b0f 	vmul.f64	d3, d11, d15
10008ee0:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10008ee4:	eefc 2bc3 	vcvt.u32.f64	s5, d3
10008ee8:	ee39 3b07 	vadd.f64	d3, d9, d7
10008eec:	ee05 ab4e 	vmls.f64	d10, d5, d14
10008ef0:	ed8d 3b16 	vstr	d3, [sp, #88]	@ 0x58
10008ef4:	ed9d 1b0c 	vldr	d1, [sp, #48]	@ 0x30
10008ef8:	eeb8 5b62 	vcvt.f64.u32	d5, s5
10008efc:	ee3a 3b07 	vadd.f64	d3, d10, d7
10008f00:	ee05 bb4e 	vmls.f64	d11, d5, d14
10008f04:	ed8d 3b18 	vstr	d3, [sp, #96]	@ 0x60
10008f08:	ee34 3b06 	vadd.f64	d3, d4, d6
10008f0c:	eebc 5bcb 	vcvt.u32.f64	s10, d11
10008f10:	ee15 3a10 	vmov	r3, s10
10008f14:	ee26 6b0f 	vmul.f64	d6, d6, d15
10008f18:	0fdb      	lsrs	r3, r3, #31
10008f1a:	ee05 3a10 	vmov	s10, r3
10008f1e:	ee24 4b0f 	vmul.f64	d4, d4, d15
10008f22:	ed8d 6b4c 	vstr	d6, [sp, #304]	@ 0x130
10008f26:	ed9d ab0a 	vldr	d10, [sp, #40]	@ 0x28
10008f2a:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
10008f2e:	ee21 6b0f 	vmul.f64	d6, d1, d15
10008f32:	ed8d 5b58 	vstr	d5, [sp, #352]	@ 0x160
10008f36:	ed8d 4b56 	vstr	d4, [sp, #344]	@ 0x158
10008f3a:	ed9d 2b12 	vldr	d2, [sp, #72]	@ 0x48
10008f3e:	ee2a 5b0f 	vmul.f64	d5, d10, d15
10008f42:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10008f46:	eefc 4bc5 	vcvt.u32.f64	s9, d5
10008f4a:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10008f4e:	eeb6 9b00 	vmov.f64	d9, #96	@ 0x3f000000  0.5
10008f52:	ee32 2b06 	vadd.f64	d2, d2, d6
10008f56:	ee06 1b4e 	vmls.f64	d1, d6, d14
10008f5a:	eeb8 6b64 	vcvt.f64.u32	d6, s9
10008f5e:	ee21 5b09 	vmul.f64	d5, d1, d9
10008f62:	ee06 ab4e 	vmls.f64	d10, d6, d14
10008f66:	ee30 1b06 	vadd.f64	d1, d0, d6
10008f6a:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10008f6e:	eeb0 0b49 	vmov.f64	d0, d9
10008f72:	eeb8 6b45 	vcvt.f64.u32	d6, s10
10008f76:	ee2a 4b09 	vmul.f64	d4, d10, d9
10008f7a:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10008f7e:	ee38 8b07 	vadd.f64	d8, d8, d7
10008f82:	ed9d 9b10 	vldr	d9, [sp, #64]	@ 0x40
10008f86:	ed8d 6b0c 	vstr	d6, [sp, #48]	@ 0x30
10008f8a:	ed9d ab0e 	vldr	d10, [sp, #56]	@ 0x38
10008f8e:	ee29 6b0f 	vmul.f64	d6, d9, d15
10008f92:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10008f96:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10008f9a:	ee2a 5b0f 	vmul.f64	d5, d10, d15
10008f9e:	ed8d 4b10 	vstr	d4, [sp, #64]	@ 0x40
10008fa2:	ed9d 7b08 	vldr	d7, [sp, #32]
10008fa6:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10008faa:	eefc 4bc5 	vcvt.u32.f64	s9, d5
10008fae:	ee06 9b4e 	vmls.f64	d9, d6, d14
10008fb2:	ee38 8b06 	vadd.f64	d8, d8, d6
10008fb6:	ee29 5b00 	vmul.f64	d5, d9, d0
10008fba:	eeb8 6b64 	vcvt.f64.u32	d6, s9
10008fbe:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10008fc2:	ee06 ab4e 	vmls.f64	d10, d6, d14
10008fc6:	e00d      	b.n	10008fe4 <fndsa_vect_iFFT_fp64_exact+0x41c>
10008fc8:	00000000 	.word	0x00000000
10008fcc:	3df00000 	.word	0x3df00000
10008fd0:	00000000 	.word	0x00000000
10008fd4:	41f00000 	.word	0x41f00000
	...
10008fe0:	300039a0 	.word	0x300039a0
10008fe4:	ee2a 4b00 	vmul.f64	d4, d10, d0
10008fe8:	ed9d 9b02 	vldr	d9, [sp, #8]
10008fec:	eeb8 ab45 	vcvt.f64.u32	d10, s10
10008ff0:	ee39 9b06 	vadd.f64	d9, d9, d6
10008ff4:	ed8d ab0a 	vstr	d10, [sp, #40]	@ 0x28
10008ff8:	ed9d ab06 	vldr	d10, [sp, #24]
10008ffc:	ee27 6b0f 	vmul.f64	d6, d7, d15
10009000:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10009004:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10009008:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000900c:	ee2a 5b0f 	vmul.f64	d5, d10, d15
10009010:	ed8d 4b08 	vstr	d4, [sp, #32]
10009014:	ed8d bb50 	vstr	d11, [sp, #320]	@ 0x140
10009018:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000901c:	eefc 4bc5 	vcvt.u32.f64	s9, d5
10009020:	ee06 7b4e 	vmls.f64	d7, d6, d14
10009024:	ed9d 5b14 	vldr	d5, [sp, #80]	@ 0x50
10009028:	ee35 5b06 	vadd.f64	d5, d5, d6
1000902c:	eeb8 6b64 	vcvt.f64.u32	d6, s9
10009030:	eeb0 4b4a 	vmov.f64	d4, d10
10009034:	ed8d 5b06 	vstr	d5, [sp, #24]
10009038:	ee27 5b00 	vmul.f64	d5, d7, d0
1000903c:	ed9d ab04 	vldr	d10, [sp, #16]
10009040:	ee06 4b4e 	vmls.f64	d4, d6, d14
10009044:	ee24 4b00 	vmul.f64	d4, d4, d0
10009048:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000904c:	eeb0 7b40 	vmov.f64	d7, d0
10009050:	ee3d db06 	vadd.f64	d13, d13, d6
10009054:	eeb8 0b45 	vcvt.f64.u32	d0, s10
10009058:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000905c:	ee2c 5b0f 	vmul.f64	d5, d12, d15
10009060:	ed8d 0b0e 	vstr	d0, [sp, #56]	@ 0x38
10009064:	eeb8 0b44 	vcvt.f64.u32	d0, s8
10009068:	ee2a 6b0f 	vmul.f64	d6, d10, d15
1000906c:	ed8d 0b04 	vstr	d0, [sp, #16]
10009070:	eefc 0bc5 	vcvt.u32.f64	s1, d5
10009074:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10009078:	ed9d 5b16 	vldr	d5, [sp, #88]	@ 0x58
1000907c:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10009080:	ee35 4b06 	vadd.f64	d4, d5, d6
10009084:	eeb0 5b4a 	vmov.f64	d5, d10
10009088:	ee06 5b4e 	vmls.f64	d5, d6, d14
1000908c:	eeb8 6b60 	vcvt.f64.u32	d6, s1
10009090:	eeb0 0b47 	vmov.f64	d0, d7
10009094:	ee06 cb4e 	vmls.f64	d12, d6, d14
10009098:	ee25 5b07 	vmul.f64	d5, d5, d7
1000909c:	ed9d 7b18 	vldr	d7, [sp, #96]	@ 0x60
100090a0:	ee2c cb00 	vmul.f64	d12, d12, d0
100090a4:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100090a8:	ee37 7b06 	vadd.f64	d7, d7, d6
100090ac:	eefc 5bcc 	vcvt.u32.f64	s11, d12
100090b0:	eeb8 cb45 	vcvt.f64.u32	d12, s10
100090b4:	eeb8 5b65 	vcvt.f64.u32	d5, s11
100090b8:	ee23 6b0f 	vmul.f64	d6, d3, d15
100090bc:	ed8d 7b02 	vstr	d7, [sp, #8]
100090c0:	ed9d 7b00 	vldr	d7, [sp]
100090c4:	ed8d 5b18 	vstr	d5, [sp, #96]	@ 0x60
100090c8:	ee3b 5b07 	vadd.f64	d5, d11, d7
100090cc:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100090d0:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100090d4:	ee27 7b0f 	vmul.f64	d7, d7, d15
100090d8:	ee06 3b4e 	vmls.f64	d3, d6, d14
100090dc:	ed8d 7b4a 	vstr	d7, [sp, #296]	@ 0x128
100090e0:	ee22 7b0f 	vmul.f64	d7, d2, d15
100090e4:	ee35 5b06 	vadd.f64	d5, d5, d6
100090e8:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100090ec:	ee21 6b0f 	vmul.f64	d6, d1, d15
100090f0:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100090f4:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100090f8:	ee07 2b4e 	vmls.f64	d2, d7, d14
100090fc:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10009100:	eefc 7bc2 	vcvt.u32.f64	s15, d2
10009104:	ee17 2a90 	vmov	r2, s15
10009108:	ee06 1b4e 	vmls.f64	d1, d6, d14
1000910c:	0fd3      	lsrs	r3, r2, #31
1000910e:	eefc 7bc1 	vcvt.u32.f64	s15, d1
10009112:	ee07 3a10 	vmov	s14, r3
10009116:	0853      	lsrs	r3, r2, #1
10009118:	ee2b bb0f 	vmul.f64	d11, d11, d15
1000911c:	f002 0201 	and.w	r2, r2, #1
10009120:	ee00 3a10 	vmov	s0, r3
10009124:	ee17 ca90 	vmov	ip, s15
10009128:	ed8d bb54 	vstr	d11, [sp, #336]	@ 0x150
1000912c:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10009130:	ee23 bb0f 	vmul.f64	d11, d3, d15
10009134:	ed8d 3b5c 	vstr	d3, [sp, #368]	@ 0x170
10009138:	ea4f 035c 	mov.w	r3, ip, lsr #1
1000913c:	ed9f 3bfa 	vldr	d3, [pc, #1000]	@ 10009528 <fndsa_vect_iFFT_fp64_exact+0x960>
10009140:	ed9d 1b0c 	vldr	d1, [sp, #48]	@ 0x30
10009144:	eeb8 0bc0 	vcvt.f64.s32	d0, s0
10009148:	ee02 3a10 	vmov	s4, r3
1000914c:	ee07 0b03 	vmla.f64	d0, d7, d3
10009150:	ea4f 73dc 	mov.w	r3, ip, lsr #31
10009154:	ee07 3a10 	vmov	s14, r3
10009158:	ee07 2a90 	vmov	s15, r2
1000915c:	eeb8 2bc2 	vcvt.f64.s32	d2, s4
10009160:	eeb8 6be7 	vcvt.f64.s32	d6, s15
10009164:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10009168:	f00c 0301 	and.w	r3, ip, #1
1000916c:	ee07 2b03 	vmla.f64	d2, d7, d3
10009170:	ee07 3a90 	vmov	s15, r3
10009174:	ee06 1b03 	vmla.f64	d1, d6, d3
10009178:	eeb8 7be7 	vcvt.f64.s32	d7, s15
1000917c:	eeb0 6b43 	vmov.f64	d6, d3
10009180:	ed9d 3b10 	vldr	d3, [sp, #64]	@ 0x40
10009184:	ee07 3b06 	vmla.f64	d3, d7, d6
10009188:	ee28 7b0f 	vmul.f64	d7, d8, d15
1000918c:	eeb0 ab46 	vmov.f64	d10, d6
10009190:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10009194:	ee29 6b0f 	vmul.f64	d6, d9, d15
10009198:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000919c:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100091a0:	ee07 8b4e 	vmls.f64	d8, d7, d14
100091a4:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100091a8:	eefc 7bc8 	vcvt.u32.f64	s15, d8
100091ac:	ee17 2a90 	vmov	r2, s15
100091b0:	ee06 9b4e 	vmls.f64	d9, d6, d14
100091b4:	0fd3      	lsrs	r3, r2, #31
100091b6:	ee07 3a10 	vmov	s14, r3
100091ba:	0853      	lsrs	r3, r2, #1
100091bc:	eefc 7bc9 	vcvt.u32.f64	s15, d9
100091c0:	ee06 3a10 	vmov	s12, r3
100091c4:	ee17 ca90 	vmov	ip, s15
100091c8:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
100091cc:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100091d0:	eeb0 9b4a 	vmov.f64	d9, d10
100091d4:	ee07 6b0a 	vmla.f64	d6, d7, d10
100091d8:	f002 0201 	and.w	r2, r2, #1
100091dc:	ea4f 73dc 	mov.w	r3, ip, lsr #31
100091e0:	ee07 2a90 	vmov	s15, r2
100091e4:	ed8d 6b14 	vstr	d6, [sp, #80]	@ 0x50
100091e8:	ee06 3a10 	vmov	s12, r3
100091ec:	eeb8 8be7 	vcvt.f64.s32	d8, s15
100091f0:	ea4f 035c 	mov.w	r3, ip, lsr #1
100091f4:	ee07 3a10 	vmov	s14, r3
100091f8:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
100091fc:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10009200:	f00c 0301 	and.w	r3, ip, #1
10009204:	ee06 7b09 	vmla.f64	d7, d6, d9
10009208:	ed9d ab0a 	vldr	d10, [sp, #40]	@ 0x28
1000920c:	ed8d 7b10 	vstr	d7, [sp, #64]	@ 0x40
10009210:	ee07 3a90 	vmov	s15, r3
10009214:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10009218:	ee08 ab09 	vmla.f64	d10, d8, d9
1000921c:	eeb0 8b49 	vmov.f64	d8, d9
10009220:	ed9d 9b08 	vldr	d9, [sp, #32]
10009224:	ee07 9b08 	vmla.f64	d9, d7, d8
10009228:	ee2d 6b0f 	vmul.f64	d6, d13, d15
1000922c:	ed8d 9b12 	vstr	d9, [sp, #72]	@ 0x48
10009230:	ed9d 9b06 	vldr	d9, [sp, #24]
10009234:	ee29 7b0f 	vmul.f64	d7, d9, d15
10009238:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000923c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10009240:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10009244:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10009248:	ee07 9b4e 	vmls.f64	d9, d7, d14
1000924c:	eefc 7bc9 	vcvt.u32.f64	s15, d9
10009250:	ee17 2a90 	vmov	r2, s15
10009254:	ee06 db4e 	vmls.f64	d13, d6, d14
10009258:	0fd3      	lsrs	r3, r2, #31
1000925a:	ee06 3a10 	vmov	s12, r3
1000925e:	0853      	lsrs	r3, r2, #1
10009260:	ee07 3a10 	vmov	s14, r3
10009264:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10009268:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
1000926c:	ed8d ab16 	vstr	d10, [sp, #88]	@ 0x58
10009270:	eeb0 ab47 	vmov.f64	d10, d7
10009274:	eefc 7bcd 	vcvt.u32.f64	s15, d13
10009278:	eeb0 9b48 	vmov.f64	d9, d8
1000927c:	ee17 ca90 	vmov	ip, s15
10009280:	ee06 ab08 	vmla.f64	d10, d6, d8
10009284:	f002 0201 	and.w	r2, r2, #1
10009288:	ea4f 73dc 	mov.w	r3, ip, lsr #31
1000928c:	ed9d db0e 	vldr	d13, [sp, #56]	@ 0x38
10009290:	ee07 2a90 	vmov	s15, r2
10009294:	ee06 3a10 	vmov	s12, r3
10009298:	ea4f 035c 	mov.w	r3, ip, lsr #1
1000929c:	eeb8 8be7 	vcvt.f64.s32	d8, s15
100092a0:	ee07 3a10 	vmov	s14, r3
100092a4:	ee08 db09 	vmla.f64	d13, d8, d9
100092a8:	f00c 0301 	and.w	r3, ip, #1
100092ac:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100092b0:	ed8d db0e 	vstr	d13, [sp, #56]	@ 0x38
100092b4:	eeb0 db47 	vmov.f64	d13, d7
100092b8:	ee07 3a90 	vmov	s15, r3
100092bc:	ed8d ab0c 	vstr	d10, [sp, #48]	@ 0x30
100092c0:	eeb8 7be7 	vcvt.f64.s32	d7, s15
100092c4:	ed9d ab04 	vldr	d10, [sp, #16]
100092c8:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
100092cc:	ee07 ab09 	vmla.f64	d10, d7, d9
100092d0:	ee24 7b0f 	vmul.f64	d7, d4, d15
100092d4:	ee06 db09 	vmla.f64	d13, d6, d9
100092d8:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100092dc:	ed8d db0a 	vstr	d13, [sp, #40]	@ 0x28
100092e0:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100092e4:	ed9d db02 	vldr	d13, [sp, #8]
100092e8:	ee07 4b4e 	vmls.f64	d4, d7, d14
100092ec:	ee2d 6b0f 	vmul.f64	d6, d13, d15
100092f0:	eefc 7bc4 	vcvt.u32.f64	s15, d4
100092f4:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100092f8:	ee17 2a90 	vmov	r2, s15
100092fc:	eeb8 7b46 	vcvt.f64.u32	d7, s12
10009300:	ee07 db4e 	vmls.f64	d13, d7, d14
10009304:	0fd3      	lsrs	r3, r2, #31
10009306:	eefc 7bcd 	vcvt.u32.f64	s15, d13
1000930a:	ee06 3a10 	vmov	s12, r3
1000930e:	0853      	lsrs	r3, r2, #1
10009310:	ee08 3a10 	vmov	s16, r3
10009314:	ee17 ca90 	vmov	ip, s15
10009318:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
1000931c:	eeb8 8bc8 	vcvt.f64.s32	d8, s16
10009320:	ea4f 035c 	mov.w	r3, ip, lsr #1
10009324:	ee07 3a10 	vmov	s14, r3
10009328:	ee06 8b09 	vmla.f64	d8, d6, d9
1000932c:	ea4f 73dc 	mov.w	r3, ip, lsr #31
10009330:	f002 0201 	and.w	r2, r2, #1
10009334:	ee07 2a90 	vmov	s15, r2
10009338:	ee06 3a10 	vmov	s12, r3
1000933c:	eeb8 4be7 	vcvt.f64.s32	d4, s15
10009340:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10009344:	ee04 cb09 	vmla.f64	d12, d4, d9
10009348:	f00c 0301 	and.w	r3, ip, #1
1000934c:	eeb0 4b47 	vmov.f64	d4, d7
10009350:	ed8d cb04 	vstr	d12, [sp, #16]
10009354:	ee07 3a90 	vmov	s15, r3
10009358:	ed9d cb18 	vldr	d12, [sp, #96]	@ 0x60
1000935c:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10009360:	ee07 cb09 	vmla.f64	d12, d7, d9
10009364:	ee25 7b0f 	vmul.f64	d7, d5, d15
10009368:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000936c:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10009370:	ee07 5b4e 	vmls.f64	d5, d7, d14
10009374:	eebc 7bc5 	vcvt.u32.f64	s14, d5
10009378:	ee17 3a10 	vmov	r3, s14
1000937c:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10009380:	0fdb      	lsrs	r3, r3, #31
10009382:	ee06 4b09 	vmla.f64	d4, d6, d9
10009386:	a846      	add	r0, sp, #280	@ 0x118
10009388:	ee07 3a10 	vmov	s14, r3
1000938c:	ed8d 4b00 	vstr	d4, [sp]
10009390:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10009394:	ed8d ab08 	vstr	d10, [sp, #32]
10009398:	ed8d cb02 	vstr	d12, [sp, #8]
1000939c:	ed8d 5b5a 	vstr	d5, [sp, #360]	@ 0x168
100093a0:	ee25 5b0f 	vmul.f64	d5, d5, d15
100093a4:	ed8d 7b62 	vstr	d7, [sp, #392]	@ 0x188
100093a8:	ed8d 5b5e 	vstr	d5, [sp, #376]	@ 0x178
100093ac:	ed8d bb60 	vstr	d11, [sp, #384]	@ 0x180
100093b0:	f7fe fbea 	bl	10007b88 <fp64e_cmul_prepared>
100093b4:	edd6 7a06 	vldr	s15, [r6, #24]
100093b8:	6973      	ldr	r3, [r6, #20]
100093ba:	eeb8 5b67 	vcvt.f64.u32	d5, s15
100093be:	0fdb      	lsrs	r3, r3, #31
100093c0:	ee04 3a10 	vmov	s8, r3
100093c4:	ee3e 5b45 	vsub.f64	d5, d14, d5
100093c8:	edd6 7a07 	vldr	s15, [r6, #28]
100093cc:	eeb8 6b67 	vcvt.f64.u32	d6, s15
100093d0:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
100093d4:	ee3e 6b46 	vsub.f64	d6, d14, d6
100093d8:	ed8d 4b4e 	vstr	d4, [sp, #312]	@ 0x138
100093dc:	eeb7 4b00 	vmov.f64	d4, #112	@ 0x3f800000  1.0
100093e0:	eeb0 cb40 	vmov.f64	d12, d0
100093e4:	ee36 6b44 	vsub.f64	d6, d6, d4
100093e8:	edd6 7a04 	vldr	s15, [r6, #16]
100093ec:	ee25 4b0f 	vmul.f64	d4, d5, d15
100093f0:	eeb0 0b48 	vmov.f64	d0, d8
100093f4:	eeb8 8b67 	vcvt.f64.u32	d8, s15
100093f8:	edd6 7a05 	vldr	s15, [r6, #20]
100093fc:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10009400:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10009404:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10009408:	ee27 bb0f 	vmul.f64	d11, d7, d15
1000940c:	ee36 6b04 	vadd.f64	d6, d6, d4
10009410:	ed8d bb4a 	vstr	d11, [sp, #296]	@ 0x128
10009414:	ee26 bb0f 	vmul.f64	d11, d6, d15
10009418:	eebc bbcb 	vcvt.u32.f64	s22, d11
1000941c:	ee04 5b4e 	vmls.f64	d5, d4, d14
10009420:	eeb8 bb4b 	vcvt.f64.u32	d11, s22
10009424:	ee35 4b08 	vadd.f64	d4, d5, d8
10009428:	ed8d 5b52 	vstr	d5, [sp, #328]	@ 0x148
1000942c:	ee25 5b0f 	vmul.f64	d5, d5, d15
10009430:	ee0b 6b4e 	vmls.f64	d6, d11, d14
10009434:	ed8d 5b56 	vstr	d5, [sp, #344]	@ 0x158
10009438:	ed8d 7b46 	vstr	d7, [sp, #280]	@ 0x118
1000943c:	eefc 5bc6 	vcvt.u32.f64	s11, d6
10009440:	ee36 7b07 	vadd.f64	d7, d6, d7
10009444:	ed8d 6b50 	vstr	d6, [sp, #320]	@ 0x140
10009448:	ee15 3a90 	vmov	r3, s11
1000944c:	ee26 6b0f 	vmul.f64	d6, d6, d15
10009450:	0fdb      	lsrs	r3, r3, #31
10009452:	ed8d 6b54 	vstr	d6, [sp, #336]	@ 0x150
10009456:	ee06 3a10 	vmov	s12, r3
1000945a:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
1000945e:	ed8d 6b58 	vstr	d6, [sp, #352]	@ 0x160
10009462:	ee24 6b0f 	vmul.f64	d6, d4, d15
10009466:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000946a:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000946e:	ee37 7b06 	vadd.f64	d7, d7, d6
10009472:	ee06 4b4e 	vmls.f64	d4, d6, d14
10009476:	ee27 6b0f 	vmul.f64	d6, d7, d15
1000947a:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000947e:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10009482:	ee06 7b4e 	vmls.f64	d7, d6, d14
10009486:	eefc 6bc7 	vcvt.u32.f64	s13, d7
1000948a:	ed8d 7b5a 	vstr	d7, [sp, #360]	@ 0x168
1000948e:	ee16 3a90 	vmov	r3, s13
10009492:	ee27 7b0f 	vmul.f64	d7, d7, d15
10009496:	0fdb      	lsrs	r3, r3, #31
10009498:	ed8d 7b5e 	vstr	d7, [sp, #376]	@ 0x178
1000949c:	ee07 3a10 	vmov	s14, r3
100094a0:	eeb0 9b43 	vmov.f64	d9, d3
100094a4:	eeb0 ab41 	vmov.f64	d10, d1
100094a8:	eeb0 db42 	vmov.f64	d13, d2
100094ac:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100094b0:	ed8d 8b48 	vstr	d8, [sp, #288]	@ 0x120
100094b4:	ee28 8b0f 	vmul.f64	d8, d8, d15
100094b8:	ed8d 4b5c 	vstr	d4, [sp, #368]	@ 0x170
100094bc:	ed9d 2b00 	vldr	d2, [sp]
100094c0:	ed9d 1b04 	vldr	d1, [sp, #16]
100094c4:	ed9d 3b02 	vldr	d3, [sp, #8]
100094c8:	ed8d 7b62 	vstr	d7, [sp, #392]	@ 0x188
100094cc:	ed8d cb2e 	vstr	d12, [sp, #184]	@ 0xb8
100094d0:	ed8d ab30 	vstr	d10, [sp, #192]	@ 0xc0
100094d4:	ed8d db32 	vstr	d13, [sp, #200]	@ 0xc8
100094d8:	ed8d 9b34 	vstr	d9, [sp, #208]	@ 0xd0
100094dc:	ee24 4b0f 	vmul.f64	d4, d4, d15
100094e0:	ed8d 8b4c 	vstr	d8, [sp, #304]	@ 0x130
100094e4:	ed8d 4b60 	vstr	d4, [sp, #384]	@ 0x180
100094e8:	f7fe fb4e 	bl	10007b88 <fp64e_cmul_prepared>
100094ec:	edd7 7a02 	vldr	s15, [r7, #8]
100094f0:	edd7 5a00 	vldr	s11, [r7]
100094f4:	687b      	ldr	r3, [r7, #4]
100094f6:	eeb8 4b65 	vcvt.f64.u32	d4, s11
100094fa:	0fdb      	lsrs	r3, r3, #31
100094fc:	eeb8 6b67 	vcvt.f64.u32	d6, s15
10009500:	ee05 3a10 	vmov	s10, r3
10009504:	ee3e bb46 	vsub.f64	d11, d14, d6
10009508:	edd7 5a01 	vldr	s11, [r7, #4]
1000950c:	edd7 7a03 	vldr	s15, [r7, #12]
10009510:	eeb8 8b65 	vcvt.f64.u32	d8, s11
10009514:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10009518:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
1000951c:	ee3e 7b47 	vsub.f64	d7, d14, d7
10009520:	ed8d 5b4e 	vstr	d5, [sp, #312]	@ 0x138
10009524:	e008      	b.n	10009538 <fndsa_vect_iFFT_fp64_exact+0x970>
10009526:	bf00      	nop
10009528:	00000000 	.word	0x00000000
1000952c:	41e00000 	.word	0x41e00000
	...
10009538:	eeb7 5b00 	vmov.f64	d5, #112	@ 0x3f800000  1.0
1000953c:	ed8d bb06 	vstr	d11, [sp, #24]
10009540:	ee37 bb45 	vsub.f64	d11, d7, d5
10009544:	ed9d 6b16 	vldr	d6, [sp, #88]	@ 0x58
10009548:	ee36 7b0e 	vadd.f64	d7, d6, d14
1000954c:	ed8d bb1a 	vstr	d11, [sp, #104]	@ 0x68
10009550:	ed9d bb0e 	vldr	d11, [sp, #56]	@ 0x38
10009554:	ed9d 5b08 	vldr	d5, [sp, #32]
10009558:	ee3b 6b06 	vadd.f64	d6, d11, d6
1000955c:	ee37 7b4b 	vsub.f64	d7, d7, d11
10009560:	ed8d 6b0e 	vstr	d6, [sp, #56]	@ 0x38
10009564:	ed9d 6b12 	vldr	d6, [sp, #72]	@ 0x48
10009568:	ee36 bb0e 	vadd.f64	d11, d6, d14
1000956c:	ee35 6b06 	vadd.f64	d6, d5, d6
10009570:	ed8d 6b04 	vstr	d6, [sp, #16]
10009574:	ee3a 6b0e 	vadd.f64	d6, d10, d14
10009578:	ed8d 1b38 	vstr	d1, [sp, #224]	@ 0xe0
1000957c:	ed8d 0b36 	vstr	d0, [sp, #216]	@ 0xd8
10009580:	ed8d 2b3a 	vstr	d2, [sp, #232]	@ 0xe8
10009584:	ed8d 3b3c 	vstr	d3, [sp, #240]	@ 0xf0
10009588:	ee3a ab01 	vadd.f64	d10, d10, d1
1000958c:	ee36 1b41 	vsub.f64	d1, d6, d1
10009590:	ee39 6b0e 	vadd.f64	d6, d9, d14
10009594:	ee3b bb45 	vsub.f64	d11, d11, d5
10009598:	ed8d 8b00 	vstr	d8, [sp]
1000959c:	ed8d 8b46 	vstr	d8, [sp, #280]	@ 0x118
100095a0:	ed8d 4b48 	vstr	d4, [sp, #288]	@ 0x120
100095a4:	ed8d 1b08 	vstr	d1, [sp, #32]
100095a8:	ed8d 7b02 	vstr	d7, [sp, #8]
100095ac:	ee39 1b03 	vadd.f64	d1, d9, d3
100095b0:	ee36 9b43 	vsub.f64	d9, d6, d3
100095b4:	ed9d 3b14 	vldr	d3, [sp, #80]	@ 0x50
100095b8:	ed9d 8b0c 	vldr	d8, [sp, #48]	@ 0x30
100095bc:	ee27 6b0f 	vmul.f64	d6, d7, d15
100095c0:	ee33 5b0e 	vadd.f64	d5, d3, d14
100095c4:	ee38 3b03 	vadd.f64	d3, d8, d3
100095c8:	ee35 5b48 	vsub.f64	d5, d5, d8
100095cc:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100095d0:	eeb7 7b00 	vmov.f64	d7, #112	@ 0x3f800000  1.0
100095d4:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100095d8:	eeb0 8b47 	vmov.f64	d8, d7
100095dc:	ee35 5b47 	vsub.f64	d5, d5, d7
100095e0:	ed9d 7b02 	vldr	d7, [sp, #8]
100095e4:	ee06 7b4e 	vmls.f64	d7, d6, d14
100095e8:	ee35 5b06 	vadd.f64	d5, d5, d6
100095ec:	ee37 7b08 	vadd.f64	d7, d7, d8
100095f0:	ed8d 5b0c 	vstr	d5, [sp, #48]	@ 0x30
100095f4:	ed8d 7b14 	vstr	d7, [sp, #80]	@ 0x50
100095f8:	ee2b 7b0f 	vmul.f64	d7, d11, d15
100095fc:	ed9d 5b10 	vldr	d5, [sp, #64]	@ 0x40
10009600:	ed9d 8b0a 	vldr	d8, [sp, #40]	@ 0x28
10009604:	ee35 6b0e 	vadd.f64	d6, d5, d14
10009608:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000960c:	ee38 5b05 	vadd.f64	d5, d8, d5
10009610:	ee36 6b48 	vsub.f64	d6, d6, d8
10009614:	eeb7 8b00 	vmov.f64	d8, #112	@ 0x3f800000  1.0
10009618:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000961c:	ee36 6b48 	vsub.f64	d6, d6, d8
10009620:	ee07 bb4e 	vmls.f64	d11, d7, d14
10009624:	ee36 7b07 	vadd.f64	d7, d6, d7
10009628:	ee3b bb08 	vadd.f64	d11, d11, d8
1000962c:	ed9d 8b0e 	vldr	d8, [sp, #56]	@ 0x38
10009630:	ed8d 7b0a 	vstr	d7, [sp, #40]	@ 0x28
10009634:	ed9d 6b04 	vldr	d6, [sp, #16]
10009638:	ee28 7b0f 	vmul.f64	d7, d8, d15
1000963c:	ed8d bb12 	vstr	d11, [sp, #72]	@ 0x48
10009640:	ee26 6b0f 	vmul.f64	d6, d6, d15
10009644:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10009648:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000964c:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10009650:	ee33 bb07 	vadd.f64	d11, d3, d7
10009654:	eeb0 3b48 	vmov.f64	d3, d8
10009658:	eeb7 8b00 	vmov.f64	d8, #112	@ 0x3f800000  1.0
1000965c:	ee07 3b4e 	vmls.f64	d3, d7, d14
10009660:	eeb8 7b46 	vcvt.f64.u32	d7, s12
10009664:	ee33 3b08 	vadd.f64	d3, d3, d8
10009668:	ed9d 6b04 	vldr	d6, [sp, #16]
1000966c:	ee07 6b4e 	vmls.f64	d6, d7, d14
10009670:	ed8d 3b18 	vstr	d3, [sp, #96]	@ 0x60
10009674:	ee35 3b07 	vadd.f64	d3, d5, d7
10009678:	ee36 6b08 	vadd.f64	d6, d6, d8
1000967c:	ee2a 7b0f 	vmul.f64	d7, d10, d15
10009680:	ed8d 6b16 	vstr	d6, [sp, #88]	@ 0x58
10009684:	ed8d 3b0e 	vstr	d3, [sp, #56]	@ 0x38
10009688:	ee21 6b0f 	vmul.f64	d6, d1, d15
1000968c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10009690:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10009694:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10009698:	eeb8 3b46 	vcvt.f64.u32	d3, s12
1000969c:	ee07 ab4e 	vmls.f64	d10, d7, d14
100096a0:	ee03 1b4e 	vmls.f64	d1, d3, d14
100096a4:	ee31 6b08 	vadd.f64	d6, d1, d8
100096a8:	ee3a ab08 	vadd.f64	d10, d10, d8
100096ac:	ed9d 8b08 	vldr	d8, [sp, #32]
100096b0:	ed8d 6b10 	vstr	d6, [sp, #64]	@ 0x40
100096b4:	ee28 6b0f 	vmul.f64	d6, d8, d15
100096b8:	ee3c 5b0e 	vadd.f64	d5, d12, d14
100096bc:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100096c0:	ee3c cb00 	vadd.f64	d12, d12, d0
100096c4:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100096c8:	ee35 5b40 	vsub.f64	d5, d5, d0
100096cc:	ee3c 1b07 	vadd.f64	d1, d12, d7
100096d0:	eeb7 7b00 	vmov.f64	d7, #112	@ 0x3f800000  1.0
100096d4:	eeb0 cb48 	vmov.f64	d12, d8
100096d8:	ee35 5b47 	vsub.f64	d5, d5, d7
100096dc:	ed9d 8b06 	vldr	d8, [sp, #24]
100096e0:	ee06 cb4e 	vmls.f64	d12, d6, d14
100096e4:	ee35 0b06 	vadd.f64	d0, d5, d6
100096e8:	ee3c cb07 	vadd.f64	d12, d12, d7
100096ec:	eeb0 5b47 	vmov.f64	d5, d7
100096f0:	ee29 7b0f 	vmul.f64	d7, d9, d15
100096f4:	ee3d 6b0e 	vadd.f64	d6, d13, d14
100096f8:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100096fc:	ee32 db0d 	vadd.f64	d13, d2, d13
10009700:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10009704:	ee36 6b42 	vsub.f64	d6, d6, d2
10009708:	ee3d 3b03 	vadd.f64	d3, d13, d3
1000970c:	ee36 6b45 	vsub.f64	d6, d6, d5
10009710:	ee07 9b4e 	vmls.f64	d9, d7, d14
10009714:	ee39 db05 	vadd.f64	d13, d9, d5
10009718:	ee36 2b07 	vadd.f64	d2, d6, d7
1000971c:	ed8d db04 	vstr	d13, [sp, #16]
10009720:	ed9d db0c 	vldr	d13, [sp, #48]	@ 0x30
10009724:	ee28 7b0f 	vmul.f64	d7, d8, d15
10009728:	ee2d 6b0f 	vmul.f64	d6, d13, d15
1000972c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10009730:	eefc 5bc6 	vcvt.u32.f64	s11, d6
10009734:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10009738:	ed9d 6b1a 	vldr	d6, [sp, #104]	@ 0x68
1000973c:	ee36 9b07 	vadd.f64	d9, d6, d7
10009740:	eeb0 6b48 	vmov.f64	d6, d8
10009744:	ed1f 8b86 	vldr	d8, [pc, #-536]	@ 10009530 <fndsa_vect_iFFT_fp64_exact+0x968>
10009748:	ee07 6b4e 	vmls.f64	d6, d7, d14
1000974c:	ed8d cb02 	vstr	d12, [sp, #8]
10009750:	ed9d cb0a 	vldr	d12, [sp, #40]	@ 0x28
10009754:	eeb8 7b65 	vcvt.f64.u32	d7, s11
10009758:	eeb0 5b4d 	vmov.f64	d5, d13
1000975c:	ee07 5b4e 	vmls.f64	d5, d7, d14
10009760:	ee2c 7b0f 	vmul.f64	d7, d12, d15
10009764:	ee35 5b08 	vadd.f64	d5, d5, d8
10009768:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000976c:	ed8d 5b08 	vstr	d5, [sp, #32]
10009770:	ee2b 5b0f 	vmul.f64	d5, d11, d15
10009774:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10009778:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000977c:	ee07 cb4e 	vmls.f64	d12, d7, d14
10009780:	ed9d db0e 	vldr	d13, [sp, #56]	@ 0x38
10009784:	eeb8 7b45 	vcvt.f64.u32	d7, s10
10009788:	ee21 5b0f 	vmul.f64	d5, d1, d15
1000978c:	ee07 bb4e 	vmls.f64	d11, d7, d14
10009790:	ee3c 7b08 	vadd.f64	d7, d12, d8
10009794:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10009798:	eeb0 cb47 	vmov.f64	d12, d7
1000979c:	ee2d 7b0f 	vmul.f64	d7, d13, d15
100097a0:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100097a4:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100097a8:	ee07 db4e 	vmls.f64	d13, d7, d14
100097ac:	eeb8 7b45 	vcvt.f64.u32	d7, s10
100097b0:	ee07 1b4e 	vmls.f64	d1, d7, d14
100097b4:	ee3d 7b08 	vadd.f64	d7, d13, d8
100097b8:	ee31 1b08 	vadd.f64	d1, d1, d8
100097bc:	ed8d 7b06 	vstr	d7, [sp, #24]
100097c0:	ee23 7b0f 	vmul.f64	d7, d3, d15
100097c4:	ed8d 1b0c 	vstr	d1, [sp, #48]	@ 0x30
100097c8:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100097cc:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100097d0:	ee20 5b0f 	vmul.f64	d5, d0, d15
100097d4:	ee07 3b4e 	vmls.f64	d3, d7, d14
100097d8:	ee22 7b0f 	vmul.f64	d7, d2, d15
100097dc:	eefc 1bc5 	vcvt.u32.f64	s3, d5
100097e0:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100097e4:	ee29 5b0f 	vmul.f64	d5, d9, d15
100097e8:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100097ec:	ee33 3b08 	vadd.f64	d3, d3, d8
100097f0:	ee07 2b4e 	vmls.f64	d2, d7, d14
100097f4:	ed8d 3b1a 	vstr	d3, [sp, #104]	@ 0x68
100097f8:	eeb8 7b61 	vcvt.f64.u32	d7, s3
100097fc:	eefc 3bc5 	vcvt.u32.f64	s7, d5
10009800:	ee07 0b4e 	vmls.f64	d0, d7, d14
10009804:	eeb8 7b63 	vcvt.f64.u32	d7, s7
10009808:	ee07 9b4e 	vmls.f64	d9, d7, d14
1000980c:	eebc 7bc9 	vcvt.u32.f64	s14, d9
10009810:	ee17 3a10 	vmov	r3, s14
10009814:	0fdb      	lsrs	r3, r3, #31
10009816:	ee07 3a10 	vmov	s14, r3
1000981a:	ee36 3b04 	vadd.f64	d3, d6, d4
1000981e:	ed8d 6b52 	vstr	d6, [sp, #328]	@ 0x148
10009822:	ee32 2b08 	vadd.f64	d2, d2, d8
10009826:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
1000982a:	ee24 4b0f 	vmul.f64	d4, d4, d15
1000982e:	ed8d 2b1c 	vstr	d2, [sp, #112]	@ 0x70
10009832:	ed8d 9b50 	vstr	d9, [sp, #320]	@ 0x140
10009836:	ed8d 7b58 	vstr	d7, [sp, #352]	@ 0x160
1000983a:	ee26 6b0f 	vmul.f64	d6, d6, d15
1000983e:	ed8d 4b4c 	vstr	d4, [sp, #304]	@ 0x130
10009842:	ed9d 2b14 	vldr	d2, [sp, #80]	@ 0x50
10009846:	ed9d 1b12 	vldr	d1, [sp, #72]	@ 0x48
1000984a:	ee22 7b0f 	vmul.f64	d7, d2, d15
1000984e:	ed8d 6b56 	vstr	d6, [sp, #344]	@ 0x158
10009852:	ed9d 4b08 	vldr	d4, [sp, #32]
10009856:	ee21 6b0f 	vmul.f64	d6, d1, d15
1000985a:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000985e:	eefc 5bc6 	vcvt.u32.f64	s11, d6
10009862:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10009866:	eeb0 6b42 	vmov.f64	d6, d2
1000986a:	ee34 4b07 	vadd.f64	d4, d4, d7
1000986e:	ee07 6b4e 	vmls.f64	d6, d7, d14
10009872:	eeb8 7b65 	vcvt.f64.u32	d7, s11
10009876:	eeb0 5b41 	vmov.f64	d5, d1
1000987a:	ee30 0b08 	vadd.f64	d0, d0, d8
1000987e:	ee3b bb08 	vadd.f64	d11, d11, d8
10009882:	ee07 5b4e 	vmls.f64	d5, d7, d14
10009886:	eeb6 8b00 	vmov.f64	d8, #96	@ 0x3f000000  0.5
1000988a:	ee3c 2b07 	vadd.f64	d2, d12, d7
1000988e:	ed9d cb18 	vldr	d12, [sp, #96]	@ 0x60
10009892:	ed9d db16 	vldr	d13, [sp, #88]	@ 0x58
10009896:	ee26 6b08 	vmul.f64	d6, d6, d8
1000989a:	ee25 5b08 	vmul.f64	d5, d5, d8
1000989e:	ee2c 7b0f 	vmul.f64	d7, d12, d15
100098a2:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100098a6:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100098aa:	eeb8 1b46 	vcvt.f64.u32	d1, s12
100098ae:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100098b2:	ee2d 6b0f 	vmul.f64	d6, d13, d15
100098b6:	ed8d 5b18 	vstr	d5, [sp, #96]	@ 0x60
100098ba:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100098be:	eefc 5bc6 	vcvt.u32.f64	s11, d6
100098c2:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100098c6:	eeb0 6b4c 	vmov.f64	d6, d12
100098ca:	ee3b bb07 	vadd.f64	d11, d11, d7
100098ce:	ee07 6b4e 	vmls.f64	d6, d7, d14
100098d2:	eeb8 7b65 	vcvt.f64.u32	d7, s11
100098d6:	ee26 6b08 	vmul.f64	d6, d6, d8
100098da:	ed9d 5b06 	vldr	d5, [sp, #24]
100098de:	ee35 5b07 	vadd.f64	d5, d5, d7
100098e2:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100098e6:	ed8d 5b08 	vstr	d5, [sp, #32]
100098ea:	eeb0 5b4d 	vmov.f64	d5, d13
100098ee:	ed9d cb10 	vldr	d12, [sp, #64]	@ 0x40
100098f2:	ee07 5b4e 	vmls.f64	d5, d7, d14
100098f6:	eeb8 7b46 	vcvt.f64.u32	d7, s12
100098fa:	ee25 5b08 	vmul.f64	d5, d5, d8
100098fe:	ed8d 7b0a 	vstr	d7, [sp, #40]	@ 0x28
10009902:	ee2a 7b0f 	vmul.f64	d7, d10, d15
10009906:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000990a:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000990e:	ee2c 6b0f 	vmul.f64	d6, d12, d15
10009912:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10009916:	eefc 5bc6 	vcvt.u32.f64	s11, d6
1000991a:	ee07 ab4e 	vmls.f64	d10, d7, d14
1000991e:	ed9d 6b0c 	vldr	d6, [sp, #48]	@ 0x30
10009922:	ee36 6b07 	vadd.f64	d6, d6, d7
10009926:	ed8d 6b06 	vstr	d6, [sp, #24]
1000992a:	ee2a 6b08 	vmul.f64	d6, d10, d8
1000992e:	eeb8 7b65 	vcvt.f64.u32	d7, s11
10009932:	eeb8 db45 	vcvt.f64.u32	d13, s10
10009936:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000993a:	eeb0 5b4c 	vmov.f64	d5, d12
1000993e:	eeb8 cb46 	vcvt.f64.u32	d12, s12
10009942:	ee07 5b4e 	vmls.f64	d5, d7, d14
10009946:	ed9d ab1a 	vldr	d10, [sp, #104]	@ 0x68
1000994a:	ed8d cb12 	vstr	d12, [sp, #72]	@ 0x48
1000994e:	ed9d cb02 	vldr	d12, [sp, #8]
10009952:	ed8d db0e 	vstr	d13, [sp, #56]	@ 0x38
10009956:	ed9d db04 	vldr	d13, [sp, #16]
1000995a:	ee3a ab07 	vadd.f64	d10, d10, d7
1000995e:	ee25 5b08 	vmul.f64	d5, d5, d8
10009962:	ee2c 7b0f 	vmul.f64	d7, d12, d15
10009966:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000996a:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000996e:	eeb8 cb45 	vcvt.f64.u32	d12, s10
10009972:	ee2d 6b0f 	vmul.f64	d6, d13, d15
10009976:	ed8d cb14 	vstr	d12, [sp, #80]	@ 0x50
1000997a:	ed9d cb02 	vldr	d12, [sp, #8]
1000997e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10009982:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10009986:	ee30 5b07 	vadd.f64	d5, d0, d7
1000998a:	ee07 cb4e 	vmls.f64	d12, d7, d14
1000998e:	eeb8 7b46 	vcvt.f64.u32	d7, s12
10009992:	ee2c 6b08 	vmul.f64	d6, d12, d8
10009996:	ed9d 0b1c 	vldr	d0, [sp, #112]	@ 0x70
1000999a:	ee07 db4e 	vmls.f64	d13, d7, d14
1000999e:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100099a2:	ee2d db08 	vmul.f64	d13, d13, d8
100099a6:	ed9d 8b00 	vldr	d8, [sp]
100099aa:	ee30 cb07 	vadd.f64	d12, d0, d7
100099ae:	ee23 7b0f 	vmul.f64	d7, d3, d15
100099b2:	eefc 6bcd 	vcvt.u32.f64	s13, d13
100099b6:	eeb8 db46 	vcvt.f64.u32	d13, s12
100099ba:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100099be:	eeb8 0b66 	vcvt.f64.u32	d0, s13
100099c2:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100099c6:	ee39 6b08 	vadd.f64	d6, d9, d8
100099ca:	ee28 8b0f 	vmul.f64	d8, d8, d15
100099ce:	ee07 3b4e 	vmls.f64	d3, d7, d14
100099d2:	ed8d 8b4a 	vstr	d8, [sp, #296]	@ 0x128
100099d6:	ee36 8b07 	vadd.f64	d8, d6, d7
100099da:	ee24 7b0f 	vmul.f64	d7, d4, d15
100099de:	ee22 6b0f 	vmul.f64	d6, d2, d15
100099e2:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100099e6:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100099ea:	ee07 4b4e 	vmls.f64	d4, d7, d14
100099ee:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100099f2:	eefc 7bc4 	vcvt.u32.f64	s15, d4
100099f6:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100099fa:	ee17 2a90 	vmov	r2, s15
100099fe:	ee06 2b4e 	vmls.f64	d2, d6, d14
10009a02:	0fd3      	lsrs	r3, r2, #31
10009a04:	eefc 7bc2 	vcvt.u32.f64	s15, d2
10009a08:	ee07 3a10 	vmov	s14, r3
10009a0c:	0853      	lsrs	r3, r2, #1
10009a0e:	ed8d 0b16 	vstr	d0, [sp, #88]	@ 0x58
10009a12:	ee00 3a10 	vmov	s0, r3
10009a16:	ee17 ca90 	vmov	ip, s15
10009a1a:	eeb8 0bc0 	vcvt.f64.s32	d0, s0
10009a1e:	ee29 9b0f 	vmul.f64	d9, d9, d15
10009a22:	f002 0201 	and.w	r2, r2, #1
10009a26:	ea4f 035c 	mov.w	r3, ip, lsr #1
10009a2a:	ee07 2a90 	vmov	s15, r2
10009a2e:	ed8d 9b54 	vstr	d9, [sp, #336]	@ 0x150
10009a32:	eeb8 6be7 	vcvt.f64.s32	d6, s15
10009a36:	ed9f 9bde 	vldr	d9, [pc, #888]	@ 10009db0 <fndsa_vect_iFFT_fp64_exact+0x11e8>
10009a3a:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10009a3e:	ee02 3a10 	vmov	s4, r3
10009a42:	ee07 0b09 	vmla.f64	d0, d7, d9
10009a46:	ea4f 73dc 	mov.w	r3, ip, lsr #31
10009a4a:	ed8d 3b5c 	vstr	d3, [sp, #368]	@ 0x170
10009a4e:	ee07 3a10 	vmov	s14, r3
10009a52:	eeb8 2bc2 	vcvt.f64.s32	d2, s4
10009a56:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10009a5a:	f00c 0301 	and.w	r3, ip, #1
10009a5e:	ee07 2b09 	vmla.f64	d2, d7, d9
10009a62:	ee07 3a90 	vmov	s15, r3
10009a66:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10009a6a:	ee23 3b0f 	vmul.f64	d3, d3, d15
10009a6e:	ee06 1b09 	vmla.f64	d1, d6, d9
10009a72:	ed8d 3b60 	vstr	d3, [sp, #384]	@ 0x180
10009a76:	ed9d 3b18 	vldr	d3, [sp, #96]	@ 0x60
10009a7a:	ed9d 4b08 	vldr	d4, [sp, #32]
10009a7e:	ee07 3b09 	vmla.f64	d3, d7, d9
10009a82:	ee2b 7b0f 	vmul.f64	d7, d11, d15
10009a86:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10009a8a:	ee24 6b0f 	vmul.f64	d6, d4, d15
10009a8e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10009a92:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10009a96:	ee07 bb4e 	vmls.f64	d11, d7, d14
10009a9a:	eefc 7bcb 	vcvt.u32.f64	s15, d11
10009a9e:	ee17 2a90 	vmov	r2, s15
10009aa2:	eeb8 7b46 	vcvt.f64.u32	d7, s12
10009aa6:	eeb0 6b44 	vmov.f64	d6, d4
10009aaa:	ee07 6b4e 	vmls.f64	d6, d7, d14
10009aae:	0fd3      	lsrs	r3, r2, #31
10009ab0:	eefc 7bc6 	vcvt.u32.f64	s15, d6
10009ab4:	ee06 3a10 	vmov	s12, r3
10009ab8:	0853      	lsrs	r3, r2, #1
10009aba:	ee04 3a10 	vmov	s8, r3
10009abe:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10009ac2:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
10009ac6:	ee17 ea90 	vmov	lr, s15
10009aca:	ee06 4b09 	vmla.f64	d4, d6, d9
10009ace:	f002 0201 	and.w	r2, r2, #1
10009ad2:	ea4f 73de 	mov.w	r3, lr, lsr #31
10009ad6:	ea4f 0c5e 	mov.w	ip, lr, lsr #1
10009ada:	ee07 2a90 	vmov	s15, r2
10009ade:	ed8d 4b18 	vstr	d4, [sp, #96]	@ 0x60
10009ae2:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10009ae6:	ed9d 4b0a 	vldr	d4, [sp, #40]	@ 0x28
10009aea:	ee07 4b09 	vmla.f64	d4, d7, d9
10009aee:	ee06 3a10 	vmov	s12, r3
10009af2:	ee07 ca90 	vmov	s15, ip
10009af6:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10009afa:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10009afe:	f00e 0301 	and.w	r3, lr, #1
10009b02:	ee06 7b09 	vmla.f64	d7, d6, d9
10009b06:	ed8d 4b10 	vstr	d4, [sp, #64]	@ 0x40
10009b0a:	ed8d 7b0c 	vstr	d7, [sp, #48]	@ 0x30
10009b0e:	ee07 3a90 	vmov	s15, r3
10009b12:	ed9d 6b06 	vldr	d6, [sp, #24]
10009b16:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10009b1a:	ed9d bb0e 	vldr	d11, [sp, #56]	@ 0x38
10009b1e:	eeb0 4b49 	vmov.f64	d4, d9
10009b22:	ee07 bb09 	vmla.f64	d11, d7, d9
10009b26:	ee26 7b0f 	vmul.f64	d7, d6, d15
10009b2a:	ee2a 9b0f 	vmul.f64	d9, d10, d15
10009b2e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10009b32:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10009b36:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10009b3a:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10009b3e:	ee07 6b4e 	vmls.f64	d6, d7, d14
10009b42:	eefc 7bc6 	vcvt.u32.f64	s15, d6
10009b46:	ee17 2a90 	vmov	r2, s15
10009b4a:	ee09 ab4e 	vmls.f64	d10, d9, d14
10009b4e:	0fd3      	lsrs	r3, r2, #31
10009b50:	ee06 3a10 	vmov	s12, r3
10009b54:	0853      	lsrs	r3, r2, #1
10009b56:	eefc 7bca 	vcvt.u32.f64	s15, d10
10009b5a:	ee07 3a10 	vmov	s14, r3
10009b5e:	ee17 ea90 	vmov	lr, s15
10009b62:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10009b66:	f002 0201 	and.w	r2, r2, #1
10009b6a:	eeb0 ab47 	vmov.f64	d10, d7
10009b6e:	ee07 2a90 	vmov	s15, r2
10009b72:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10009b76:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10009b7a:	ed9d 9b12 	vldr	d9, [sp, #72]	@ 0x48
10009b7e:	ea4f 73de 	mov.w	r3, lr, lsr #31
10009b82:	ea4f 0c5e 	mov.w	ip, lr, lsr #1
10009b86:	ee06 ab04 	vmla.f64	d10, d6, d4
10009b8a:	ee07 9b04 	vmla.f64	d9, d7, d4
10009b8e:	ee06 3a10 	vmov	s12, r3
10009b92:	ee07 ca90 	vmov	s15, ip
10009b96:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10009b9a:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10009b9e:	f00e 0301 	and.w	r3, lr, #1
10009ba2:	ee06 7b04 	vmla.f64	d7, d6, d4
10009ba6:	ed8d 7b04 	vstr	d7, [sp, #16]
10009baa:	ee07 3a90 	vmov	s15, r3
10009bae:	ed9d 6b14 	vldr	d6, [sp, #80]	@ 0x50
10009bb2:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10009bb6:	ee07 6b04 	vmla.f64	d6, d7, d4
10009bba:	ee25 7b0f 	vmul.f64	d7, d5, d15
10009bbe:	ed8d 6b06 	vstr	d6, [sp, #24]
10009bc2:	ee2c 6b0f 	vmul.f64	d6, d12, d15
10009bc6:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10009bca:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10009bce:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10009bd2:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10009bd6:	ee07 5b4e 	vmls.f64	d5, d7, d14
10009bda:	eefc 7bc5 	vcvt.u32.f64	s15, d5
10009bde:	ee17 3a90 	vmov	r3, s15
10009be2:	ee06 cb4e 	vmls.f64	d12, d6, d14
10009be6:	0fda      	lsrs	r2, r3, #31
10009be8:	ee07 2a10 	vmov	s14, r2
10009bec:	085a      	lsrs	r2, r3, #1
10009bee:	ed8d ab08 	vstr	d10, [sp, #32]
10009bf2:	eefc 7bcc 	vcvt.u32.f64	s15, d12
10009bf6:	ee0a 2a10 	vmov	s20, r2
10009bfa:	ee17 ea90 	vmov	lr, s15
10009bfe:	eeb8 abca 	vcvt.f64.s32	d10, s20
10009c02:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10009c06:	f003 0301 	and.w	r3, r3, #1
10009c0a:	ee07 ab04 	vmla.f64	d10, d7, d4
10009c0e:	ea4f 025e 	mov.w	r2, lr, lsr #1
10009c12:	ed8d 9b0a 	vstr	d9, [sp, #40]	@ 0x28
10009c16:	ea4f 7cde 	mov.w	ip, lr, lsr #31
10009c1a:	ee07 3a90 	vmov	s15, r3
10009c1e:	ee09 2a10 	vmov	s18, r2
10009c22:	f00e 0201 	and.w	r2, lr, #1
10009c26:	ee07 2a10 	vmov	s14, r2
10009c2a:	eeb8 6be7 	vcvt.f64.s32	d6, s15
10009c2e:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10009c32:	ee06 db04 	vmla.f64	d13, d6, d4
10009c36:	ed9d 5b16 	vldr	d5, [sp, #88]	@ 0x58
10009c3a:	ee07 5b04 	vmla.f64	d5, d7, d4
10009c3e:	ee28 7b0f 	vmul.f64	d7, d8, d15
10009c42:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10009c46:	ee07 ca90 	vmov	s15, ip
10009c4a:	eeb8 6be7 	vcvt.f64.s32	d6, s15
10009c4e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10009c52:	ee07 8b4e 	vmls.f64	d8, d7, d14
10009c56:	eebc 7bc8 	vcvt.u32.f64	s14, d8
10009c5a:	ee17 3a10 	vmov	r3, s14
10009c5e:	0fdb      	lsrs	r3, r3, #31
10009c60:	ee07 3a10 	vmov	s14, r3
10009c64:	ed8d 8b5a 	vstr	d8, [sp, #360]	@ 0x168
10009c68:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10009c6c:	eeb8 9bc9 	vcvt.f64.s32	d9, s18
10009c70:	ee28 8b0f 	vmul.f64	d8, d8, d15
10009c74:	ed8d 5b00 	vstr	d5, [sp]
10009c78:	ee06 9b04 	vmla.f64	d9, d6, d4
10009c7c:	ed8d 7b62 	vstr	d7, [sp, #392]	@ 0x188
10009c80:	ed8d bb0e 	vstr	d11, [sp, #56]	@ 0x38
10009c84:	ed8d db02 	vstr	d13, [sp, #8]
10009c88:	ed8d 8b5e 	vstr	d8, [sp, #376]	@ 0x178
10009c8c:	f7fd ff7c 	bl	10007b88 <fp64e_cmul_prepared>
10009c90:	eeb0 bb40 	vmov.f64	d11, d0
10009c94:	eeb0 8b43 	vmov.f64	d8, d3
10009c98:	ed9d 3b00 	vldr	d3, [sp]
10009c9c:	eeb0 db41 	vmov.f64	d13, d1
10009ca0:	ed9d 1b02 	vldr	d1, [sp, #8]
10009ca4:	eeb0 cb42 	vmov.f64	d12, d2
10009ca8:	ed8d bb1e 	vstr	d11, [sp, #120]	@ 0x78
10009cac:	eeb0 0b4a 	vmov.f64	d0, d10
10009cb0:	ed8d db20 	vstr	d13, [sp, #128]	@ 0x80
10009cb4:	eeb0 2b49 	vmov.f64	d2, d9
10009cb8:	ed8d cb22 	vstr	d12, [sp, #136]	@ 0x88
10009cbc:	ed8d 8b24 	vstr	d8, [sp, #144]	@ 0x90
10009cc0:	f7fd ff62 	bl	10007b88 <fp64e_cmul_prepared>
10009cc4:	ed9d 4b18 	vldr	d4, [sp, #96]	@ 0x60
10009cc8:	ed9d 7b0e 	vldr	d7, [sp, #56]	@ 0x38
10009ccc:	ed81 4b00 	vstr	d4, [r1]
10009cd0:	ed9d 4b10 	vldr	d4, [sp, #64]	@ 0x40
10009cd4:	ed9d 5b0c 	vldr	d5, [sp, #48]	@ 0x30
10009cd8:	ed9d ab08 	vldr	d10, [sp, #32]
10009cdc:	ed9d 9b0a 	vldr	d9, [sp, #40]	@ 0x28
10009ce0:	ed81 4b02 	vstr	d4, [r1, #8]
10009ce4:	ed9d 6b06 	vldr	d6, [sp, #24]
10009ce8:	ed84 7b02 	vstr	d7, [r4, #8]
10009cec:	ed9d 7b04 	vldr	d7, [sp, #16]
10009cf0:	ed84 5b00 	vstr	d5, [r4]
10009cf4:	3140      	adds	r1, #64	@ 0x40
10009cf6:	ed01 ab0c 	vstr	d10, [r1, #-48]	@ 0xffffffd0
10009cfa:	ed01 9b0a 	vstr	d9, [r1, #-40]	@ 0xffffffd8
10009cfe:	4588      	cmp	r8, r1
10009d00:	ed84 7b04 	vstr	d7, [r4, #16]
10009d04:	f106 0620 	add.w	r6, r6, #32
10009d08:	ed84 6b06 	vstr	d6, [r4, #24]
10009d0c:	f104 0440 	add.w	r4, r4, #64	@ 0x40
10009d10:	ed8d 0b26 	vstr	d0, [sp, #152]	@ 0x98
10009d14:	f107 0710 	add.w	r7, r7, #16
10009d18:	ed01 bb08 	vstr	d11, [r1, #-32]	@ 0xffffffe0
10009d1c:	ed01 db06 	vstr	d13, [r1, #-24]	@ 0xffffffe8
10009d20:	ed04 cb08 	vstr	d12, [r4, #-32]	@ 0xffffffe0
10009d24:	ed04 8b06 	vstr	d8, [r4, #-24]	@ 0xffffffe8
10009d28:	ed01 0b04 	vstr	d0, [r1, #-16]
10009d2c:	ed01 1b02 	vstr	d1, [r1, #-8]
10009d30:	ed8d 1b28 	vstr	d1, [sp, #160]	@ 0xa0
10009d34:	ed04 2b04 	vstr	d2, [r4, #-16]
10009d38:	ed04 3b02 	vstr	d3, [r4, #-8]
10009d3c:	ed8d 2b2a 	vstr	d2, [sp, #168]	@ 0xa8
10009d40:	ed8d 3b2c 	vstr	d3, [sp, #176]	@ 0xb0
10009d44:	f47e af62 	bne.w	10008c0c <fndsa_vect_iFFT_fp64_exact+0x44>
10009d48:	f04f 0e04 	mov.w	lr, #4
10009d4c:	f1ab 0103 	sub.w	r1, fp, #3
10009d50:	2900      	cmp	r1, #0
10009d52:	f000 825b 	beq.w	1000a20c <fndsa_vect_iFFT_fp64_exact+0x1644>
10009d56:	2310      	movs	r3, #16
10009d58:	ed9f eb17 	vldr	d14, [pc, #92]	@ 10009db8 <fndsa_vect_iFFT_fp64_exact+0x11f0>
10009d5c:	ed9f fb18 	vldr	d15, [pc, #96]	@ 10009dc0 <fndsa_vect_iFFT_fp64_exact+0x11f8>
10009d60:	ed9f 9b13 	vldr	d9, [pc, #76]	@ 10009db0 <fndsa_vect_iFFT_fp64_exact+0x11e8>
10009d64:	4e18      	ldr	r6, [pc, #96]	@ (10009dc8 <fndsa_vect_iFFT_fp64_exact+0x1200>)
10009d66:	fa03 fc0a 	lsl.w	ip, r3, sl
10009d6a:	4672      	mov	r2, lr
10009d6c:	2301      	movs	r3, #1
10009d6e:	f04f 0810 	mov.w	r8, #16
10009d72:	eb05 1702 	add.w	r7, r5, r2, lsl #4
10009d76:	9208      	str	r2, [sp, #32]
10009d78:	eeb7 db00 	vmov.f64	d13, #112	@ 0x3f800000  1.0
10009d7c:	462a      	mov	r2, r5
10009d7e:	f04f 0b00 	mov.w	fp, #0
10009d82:	46e1      	mov	r9, ip
10009d84:	408b      	lsls	r3, r1
10009d86:	eb03 0353 	add.w	r3, r3, r3, lsr #1
10009d8a:	eb06 1303 	add.w	r3, r6, r3, lsl #4
10009d8e:	9306      	str	r3, [sp, #24]
10009d90:	ea4f 0e4e 	mov.w	lr, lr, lsl #1
10009d94:	910a      	str	r1, [sp, #40]	@ 0x28
10009d96:	fa08 f801 	lsl.w	r8, r8, r1
10009d9a:	f8cd e010 	str.w	lr, [sp, #16]
10009d9e:	eb08 0a06 	add.w	sl, r8, r6
10009da2:	960c      	str	r6, [sp, #48]	@ 0x30
10009da4:	ea4f 180e 	mov.w	r8, lr, lsl #4
10009da8:	950e      	str	r5, [sp, #56]	@ 0x38
10009daa:	e00f      	b.n	10009dcc <fndsa_vect_iFFT_fp64_exact+0x1204>
10009dac:	f3af 8000 	nop.w
10009db0:	00000000 	.word	0x00000000
10009db4:	41e00000 	.word	0x41e00000
10009db8:	00000000 	.word	0x00000000
10009dbc:	41f00000 	.word	0x41f00000
10009dc0:	00000000 	.word	0x00000000
10009dc4:	3df00000 	.word	0x3df00000
10009dc8:	300039a0 	.word	0x300039a0
10009dcc:	edda 7a02 	vldr	s15, [sl, #8]
10009dd0:	f8da 3004 	ldr.w	r3, [sl, #4]
10009dd4:	eeb8 4b67 	vcvt.f64.u32	d4, s15
10009dd8:	0fdb      	lsrs	r3, r3, #31
10009dda:	ee03 3a10 	vmov	s6, r3
10009dde:	ee3e 4b44 	vsub.f64	d4, d14, d4
10009de2:	edda 7a03 	vldr	s15, [sl, #12]
10009de6:	eeb8 3bc3 	vcvt.f64.s32	d3, s6
10009dea:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10009dee:	ed8d 3b4e 	vstr	d3, [sp, #312]	@ 0x138
10009df2:	ee24 3b0f 	vmul.f64	d3, d4, d15
10009df6:	edda 6a00 	vldr	s13, [sl]
10009dfa:	ee3e 7b47 	vsub.f64	d7, d14, d7
10009dfe:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10009e02:	eeb8 5b66 	vcvt.f64.u32	d5, s13
10009e06:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10009e0a:	ee37 7b4d 	vsub.f64	d7, d7, d13
10009e0e:	ee37 7b03 	vadd.f64	d7, d7, d3
10009e12:	ee03 4b4e 	vmls.f64	d4, d3, d14
10009e16:	edda 6a01 	vldr	s13, [sl, #4]
10009e1a:	ed8d 5b48 	vstr	d5, [sp, #288]	@ 0x120
10009e1e:	eeb8 6b66 	vcvt.f64.u32	d6, s13
10009e22:	ee27 3b0f 	vmul.f64	d3, d7, d15
10009e26:	ee26 2b0f 	vmul.f64	d2, d6, d15
10009e2a:	ee25 1b0f 	vmul.f64	d1, d5, d15
10009e2e:	ed8d 2b4a 	vstr	d2, [sp, #296]	@ 0x128
10009e32:	ed8d 4b52 	vstr	d4, [sp, #328]	@ 0x148
10009e36:	ed8d 6b46 	vstr	d6, [sp, #280]	@ 0x118
10009e3a:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10009e3e:	ee34 5b05 	vadd.f64	d5, d4, d5
10009e42:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10009e46:	ee24 2b0f 	vmul.f64	d2, d4, d15
10009e4a:	ee25 4b0f 	vmul.f64	d4, d5, d15
10009e4e:	ee03 7b4e 	vmls.f64	d7, d3, d14
10009e52:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10009e56:	eefc 3bc7 	vcvt.u32.f64	s7, d7
10009e5a:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10009e5e:	ee37 6b06 	vadd.f64	d6, d7, d6
10009e62:	ed8d 7b50 	vstr	d7, [sp, #320]	@ 0x140
10009e66:	ee13 1a90 	vmov	r1, s7
10009e6a:	ee27 3b0f 	vmul.f64	d3, d7, d15
10009e6e:	ee36 7b04 	vadd.f64	d7, d6, d4
10009e72:	ee27 6b0f 	vmul.f64	d6, d7, d15
10009e76:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10009e7a:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10009e7e:	ee06 7b4e 	vmls.f64	d7, d6, d14
10009e82:	eefc 6bc7 	vcvt.u32.f64	s13, d7
10009e86:	0fc9      	lsrs	r1, r1, #31
10009e88:	ee04 5b4e 	vmls.f64	d5, d4, d14
10009e8c:	ee04 1a10 	vmov	s8, r1
10009e90:	ee16 1a90 	vmov	r1, s13
10009e94:	0fc9      	lsrs	r1, r1, #31
10009e96:	ee27 6b0f 	vmul.f64	d6, d7, d15
10009e9a:	ed8d 7b5a 	vstr	d7, [sp, #360]	@ 0x168
10009e9e:	ed8d 2b56 	vstr	d2, [sp, #344]	@ 0x158
10009ea2:	9b08      	ldr	r3, [sp, #32]
10009ea4:	ed8d 1b4c 	vstr	d1, [sp, #304]	@ 0x130
10009ea8:	ee07 1a10 	vmov	s14, r1
10009eac:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
10009eb0:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10009eb4:	ee25 2b0f 	vmul.f64	d2, d5, d15
10009eb8:	445b      	add	r3, fp
10009eba:	459b      	cmp	fp, r3
10009ebc:	ed8d 3b54 	vstr	d3, [sp, #336]	@ 0x150
10009ec0:	ed8d 5b5c 	vstr	d5, [sp, #368]	@ 0x170
10009ec4:	ed8d 4b58 	vstr	d4, [sp, #352]	@ 0x160
10009ec8:	ed8d 2b60 	vstr	d2, [sp, #384]	@ 0x180
10009ecc:	ed8d 6b5e 	vstr	d6, [sp, #376]	@ 0x178
10009ed0:	ed8d 7b62 	vstr	d7, [sp, #392]	@ 0x188
10009ed4:	f080 8187 	bcs.w	1000a1e6 <fndsa_vect_iFFT_fp64_exact+0x161e>
10009ed8:	463e      	mov	r6, r7
10009eda:	4611      	mov	r1, r2
10009edc:	eb09 0502 	add.w	r5, r9, r2
10009ee0:	eb09 0407 	add.w	r4, r9, r7
10009ee4:	9202      	str	r2, [sp, #8]
10009ee6:	ed91 ab02 	vldr	d10, [r1, #8]
10009eea:	ee3a 0b0e 	vadd.f64	d0, d10, d14
10009eee:	ed96 7b02 	vldr	d7, [r6, #8]
10009ef2:	ed91 cb00 	vldr	d12, [r1]
10009ef6:	ed96 3b00 	vldr	d3, [r6]
10009efa:	ed95 bb02 	vldr	d11, [r5, #8]
10009efe:	ed94 5b02 	vldr	d5, [r4, #8]
10009f02:	ee37 ab0a 	vadd.f64	d10, d7, d10
10009f06:	ee30 7b47 	vsub.f64	d7, d0, d7
10009f0a:	ee3c 1b0e 	vadd.f64	d1, d12, d14
10009f0e:	ee27 2b0f 	vmul.f64	d2, d7, d15
10009f12:	ee33 cb0c 	vadd.f64	d12, d3, d12
10009f16:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10009f1a:	ee31 3b43 	vsub.f64	d3, d1, d3
10009f1e:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10009f22:	ee33 3b4d 	vsub.f64	d3, d3, d13
10009f26:	ee02 7b4e 	vmls.f64	d7, d2, d14
10009f2a:	ee33 3b02 	vadd.f64	d3, d3, d2
10009f2e:	ee37 7b0d 	vadd.f64	d7, d7, d13
10009f32:	ee23 1b0f 	vmul.f64	d1, d3, d15
10009f36:	ee27 2b0f 	vmul.f64	d2, d7, d15
10009f3a:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10009f3e:	eefc 0bc2 	vcvt.u32.f64	s1, d2
10009f42:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10009f46:	ee01 3b4e 	vmls.f64	d3, d1, d14
10009f4a:	ed9f 4bb5 	vldr	d4, [pc, #724]	@ 1000a220 <fndsa_vect_iFFT_fp64_exact+0x1658>
10009f4e:	ed94 8b00 	vldr	d8, [r4]
10009f52:	ed95 6b00 	vldr	d6, [r5]
10009f56:	ee3b 2b0e 	vadd.f64	d2, d11, d14
10009f5a:	ee3b bb05 	vadd.f64	d11, d11, d5
10009f5e:	ee32 2b45 	vsub.f64	d2, d2, d5
10009f62:	eeb8 5b60 	vcvt.f64.u32	d5, s1
10009f66:	ee33 3b04 	vadd.f64	d3, d3, d4
10009f6a:	ee33 3b05 	vadd.f64	d3, d3, d5
10009f6e:	ee36 4b0e 	vadd.f64	d4, d6, d14
10009f72:	ee23 0b0f 	vmul.f64	d0, d3, d15
10009f76:	ee36 6b08 	vadd.f64	d6, d6, d8
10009f7a:	ee05 7b4e 	vmls.f64	d7, d5, d14
10009f7e:	ee22 5b0f 	vmul.f64	d5, d2, d15
10009f82:	ed8d 6b00 	vstr	d6, [sp]
10009f86:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10009f8a:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10009f8e:	eeb6 6b00 	vmov.f64	d6, #96	@ 0x3f000000  0.5
10009f92:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10009f96:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10009f9a:	ee05 2b4e 	vmls.f64	d2, d5, d14
10009f9e:	ee27 7b06 	vmul.f64	d7, d7, d6
10009fa2:	ee34 6b48 	vsub.f64	d6, d4, d8
10009fa6:	ee00 3b4e 	vmls.f64	d3, d0, d14
10009faa:	ee36 6b4d 	vsub.f64	d6, d6, d13
10009fae:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10009fb2:	ee36 6b05 	vadd.f64	d6, d6, d5
10009fb6:	eefc 5bc3 	vcvt.u32.f64	s11, d3
10009fba:	eeb8 1b47 	vcvt.f64.u32	d1, s14
10009fbe:	ee15 3a90 	vmov	r3, s11
10009fc2:	ee32 2b0d 	vadd.f64	d2, d2, d13
10009fc6:	ee22 7b0f 	vmul.f64	d7, d2, d15
10009fca:	0fda      	lsrs	r2, r3, #31
10009fcc:	eefc 3bc7 	vcvt.u32.f64	s7, d7
10009fd0:	ee07 2a10 	vmov	s14, r2
10009fd4:	085a      	lsrs	r2, r3, #1
10009fd6:	ee00 2a10 	vmov	s0, r2
10009fda:	ee26 4b0f 	vmul.f64	d4, d6, d15
10009fde:	f003 0301 	and.w	r3, r3, #1
10009fe2:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10009fe6:	eeb8 0bc0 	vcvt.f64.s32	d0, s0
10009fea:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10009fee:	ee07 0b09 	vmla.f64	d0, d7, d9
10009ff2:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10009ff6:	ee07 3a90 	vmov	s15, r3
10009ffa:	ee04 6b4e 	vmls.f64	d6, d4, d14
10009ffe:	eeb8 7be7 	vcvt.f64.s32	d7, s15
1000a002:	eeb8 4b63 	vcvt.f64.u32	d4, s7
1000a006:	ee07 1b09 	vmla.f64	d1, d7, d9
1000a00a:	ed9f 7b85 	vldr	d7, [pc, #532]	@ 1000a220 <fndsa_vect_iFFT_fp64_exact+0x1658>
1000a00e:	ee36 6b07 	vadd.f64	d6, d6, d7
1000a012:	ee2a 5b0f 	vmul.f64	d5, d10, d15
1000a016:	ee36 7b04 	vadd.f64	d7, d6, d4
1000a01a:	ee04 2b4e 	vmls.f64	d2, d4, d14
1000a01e:	ee27 4b0f 	vmul.f64	d4, d7, d15
1000a022:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000a026:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000a02a:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000a02e:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000a032:	eeb6 6b00 	vmov.f64	d6, #96	@ 0x3f000000  0.5
1000a036:	ee04 7b4e 	vmls.f64	d7, d4, d14
1000a03a:	ee22 2b06 	vmul.f64	d2, d2, d6
1000a03e:	ee3c 6b05 	vadd.f64	d6, d12, d5
1000a042:	eebc 2bc2 	vcvt.u32.f64	s4, d2
1000a046:	ee26 8b0f 	vmul.f64	d8, d6, d15
1000a04a:	ee05 ab4e 	vmls.f64	d10, d5, d14
1000a04e:	eefc 7bc7 	vcvt.u32.f64	s15, d7
1000a052:	eeb8 3b42 	vcvt.f64.u32	d3, s4
1000a056:	ee3a 5b0d 	vadd.f64	d5, d10, d13
1000a05a:	eebc 2bc8 	vcvt.u32.f64	s4, d8
1000a05e:	ee17 3a90 	vmov	r3, s15
1000a062:	eeb8 2b42 	vcvt.f64.u32	d2, s4
1000a066:	ee25 4b0f 	vmul.f64	d4, d5, d15
1000a06a:	0fda      	lsrs	r2, r3, #31
1000a06c:	ee08 2a10 	vmov	s16, r2
1000a070:	085a      	lsrs	r2, r3, #1
1000a072:	ee02 6b4e 	vmls.f64	d6, d2, d14
1000a076:	ed9f 7b6a 	vldr	d7, [pc, #424]	@ 1000a220 <fndsa_vect_iFFT_fp64_exact+0x1658>
1000a07a:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000a07e:	ee36 6b07 	vadd.f64	d6, d6, d7
1000a082:	ee02 2a10 	vmov	s4, r2
1000a086:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000a08a:	eeb8 8bc8 	vcvt.f64.s32	d8, s16
1000a08e:	eeb8 2bc2 	vcvt.f64.s32	d2, s4
1000a092:	eeb6 ab00 	vmov.f64	d10, #96	@ 0x3f000000  0.5
1000a096:	ee08 2b09 	vmla.f64	d2, d8, d9
1000a09a:	ee2b 8b0f 	vmul.f64	d8, d11, d15
1000a09e:	ee36 6b04 	vadd.f64	d6, d6, d4
1000a0a2:	ee04 5b4e 	vmls.f64	d5, d4, d14
1000a0a6:	ee25 5b0a 	vmul.f64	d5, d5, d10
1000a0aa:	f003 0301 	and.w	r3, r3, #1
1000a0ae:	ee07 3a90 	vmov	s15, r3
1000a0b2:	eebc 8bc8 	vcvt.u32.f64	s16, d8
1000a0b6:	ee26 4b0f 	vmul.f64	d4, d6, d15
1000a0ba:	eeb8 8b48 	vcvt.f64.u32	d8, s16
1000a0be:	eebc abc5 	vcvt.u32.f64	s20, d5
1000a0c2:	eeb8 7be7 	vcvt.f64.s32	d7, s15
1000a0c6:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000a0ca:	ee07 3b09 	vmla.f64	d3, d7, d9
1000a0ce:	ed9d 5b00 	vldr	d5, [sp]
1000a0d2:	ee35 7b08 	vadd.f64	d7, d5, d8
1000a0d6:	eeb0 5b4b 	vmov.f64	d5, d11
1000a0da:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000a0de:	ee08 5b4e 	vmls.f64	d5, d8, d14
1000a0e2:	ee27 cb0f 	vmul.f64	d12, d7, d15
1000a0e6:	ee04 6b4e 	vmls.f64	d6, d4, d14
1000a0ea:	ee35 5b0d 	vadd.f64	d5, d5, d13
1000a0ee:	eebc cbcc 	vcvt.u32.f64	s24, d12
1000a0f2:	eefc 6bc6 	vcvt.u32.f64	s13, d6
1000a0f6:	ee25 4b0f 	vmul.f64	d4, d5, d15
1000a0fa:	eeb8 cb4c 	vcvt.f64.u32	d12, s24
1000a0fe:	ee16 3a90 	vmov	r3, s13
1000a102:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000a106:	ed9f 6b46 	vldr	d6, [pc, #280]	@ 1000a220 <fndsa_vect_iFFT_fp64_exact+0x1658>
1000a10a:	ee0c 7b4e 	vmls.f64	d7, d12, d14
1000a10e:	0fda      	lsrs	r2, r3, #31
1000a110:	eeb8 bb4a 	vcvt.f64.u32	d11, s20
1000a114:	ee0a 2a10 	vmov	s20, r2
1000a118:	085a      	lsrs	r2, r3, #1
1000a11a:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000a11e:	ee37 7b06 	vadd.f64	d7, d7, d6
1000a122:	f003 0301 	and.w	r3, r3, #1
1000a126:	ee06 3a90 	vmov	s13, r3
1000a12a:	ee37 7b04 	vadd.f64	d7, d7, d4
1000a12e:	eeb8 6be6 	vcvt.f64.s32	d6, s13
1000a132:	ee08 2a10 	vmov	s16, r2
1000a136:	ee06 bb09 	vmla.f64	d11, d6, d9
1000a13a:	ee27 6b0f 	vmul.f64	d6, d7, d15
1000a13e:	eeb8 abca 	vcvt.f64.s32	d10, s20
1000a142:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000a146:	eeb8 8bc8 	vcvt.f64.s32	d8, s16
1000a14a:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000a14e:	ee04 5b4e 	vmls.f64	d5, d4, d14
1000a152:	ee06 7b4e 	vmls.f64	d7, d6, d14
1000a156:	ee0a 8b09 	vmla.f64	d8, d10, d9
1000a15a:	eefc 7bc7 	vcvt.u32.f64	s15, d7
1000a15e:	eeb6 ab00 	vmov.f64	d10, #96	@ 0x3f000000  0.5
1000a162:	ee17 3a90 	vmov	r3, s15
1000a166:	ee25 5b0a 	vmul.f64	d5, d5, d10
1000a16a:	0fda      	lsrs	r2, r3, #31
1000a16c:	ee04 2a10 	vmov	s8, r2
1000a170:	085a      	lsrs	r2, r3, #1
1000a172:	f003 0301 	and.w	r3, r3, #1
1000a176:	ee06 2a10 	vmov	s12, r2
1000a17a:	ee07 3a90 	vmov	s15, r3
1000a17e:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000a182:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
1000a186:	eeb8 7be7 	vcvt.f64.s32	d7, s15
1000a18a:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000a18e:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
1000a192:	ee07 5b09 	vmla.f64	d5, d7, d9
1000a196:	ed81 8b00 	vstr	d8, [r1]
1000a19a:	ed81 bb02 	vstr	d11, [r1, #8]
1000a19e:	ee04 6b09 	vmla.f64	d6, d4, d9
1000a1a2:	a846      	add	r0, sp, #280	@ 0x118
1000a1a4:	ed85 6b00 	vstr	d6, [r5]
1000a1a8:	ed85 5b02 	vstr	d5, [r5, #8]
1000a1ac:	f7fd fcec 	bl	10007b88 <fp64e_cmul_prepared>
1000a1b0:	3110      	adds	r1, #16
1000a1b2:	428f      	cmp	r7, r1
1000a1b4:	ed86 0b00 	vstr	d0, [r6]
1000a1b8:	f105 0510 	add.w	r5, r5, #16
1000a1bc:	ed86 1b02 	vstr	d1, [r6, #8]
1000a1c0:	f106 0610 	add.w	r6, r6, #16
1000a1c4:	ed8d 0b3e 	vstr	d0, [sp, #248]	@ 0xf8
1000a1c8:	ed84 2b00 	vstr	d2, [r4]
1000a1cc:	ed84 3b02 	vstr	d3, [r4, #8]
1000a1d0:	f104 0410 	add.w	r4, r4, #16
1000a1d4:	ed8d 1b40 	vstr	d1, [sp, #256]	@ 0x100
1000a1d8:	ed8d 2b42 	vstr	d2, [sp, #264]	@ 0x108
1000a1dc:	ed8d 3b44 	vstr	d3, [sp, #272]	@ 0x110
1000a1e0:	f47f ae81 	bne.w	10009ee6 <fndsa_vect_iFFT_fp64_exact+0x131e>
1000a1e4:	9a02      	ldr	r2, [sp, #8]
1000a1e6:	9b04      	ldr	r3, [sp, #16]
1000a1e8:	f10a 0a10 	add.w	sl, sl, #16
1000a1ec:	449b      	add	fp, r3
1000a1ee:	9b06      	ldr	r3, [sp, #24]
1000a1f0:	4442      	add	r2, r8
1000a1f2:	4553      	cmp	r3, sl
1000a1f4:	4447      	add	r7, r8
1000a1f6:	f47f ade9 	bne.w	10009dcc <fndsa_vect_iFFT_fp64_exact+0x1204>
1000a1fa:	990a      	ldr	r1, [sp, #40]	@ 0x28
1000a1fc:	46cc      	mov	ip, r9
1000a1fe:	3901      	subs	r1, #1
1000a200:	f8dd e010 	ldr.w	lr, [sp, #16]
1000a204:	9e0c      	ldr	r6, [sp, #48]	@ 0x30
1000a206:	9d0e      	ldr	r5, [sp, #56]	@ 0x38
1000a208:	f47f adaf 	bne.w	10009d6a <fndsa_vect_iFFT_fp64_exact+0x11a2>
1000a20c:	b065      	add	sp, #404	@ 0x194
1000a20e:	ecbd 8b10 	vpop	{d8-d15}
1000a212:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
1000a216:	4651      	mov	r1, sl
1000a218:	f04f 0e01 	mov.w	lr, #1
1000a21c:	e598      	b.n	10009d50 <fndsa_vect_iFFT_fp64_exact+0x1188>
1000a21e:	bf00      	nop
	...

