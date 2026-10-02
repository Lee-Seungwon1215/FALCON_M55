
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_kat_exact_inlineasm/validation/build/kernels/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10000c68 <fndsa_vect_iFFT_fp64_exact.constprop.0>:
10000c68:	1e41      	subs	r1, r0, #1
10000c6a:	f000 82d4 	beq.w	10001216 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x5ae>
10000c6e:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10000c72:	2210      	movs	r2, #16
10000c74:	ed2d 8b10 	vpush	{d8-d15}
10000c78:	f04f 0a01 	mov.w	sl, #1
10000c7c:	ed9f 9bf4 	vldr	d9, [pc, #976]	@ 10001050 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x3e8>
10000c80:	ed9f dbf5 	vldr	d13, [pc, #980]	@ 10001058 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x3f0>
10000c84:	ed9f ebf6 	vldr	d14, [pc, #984]	@ 10001060 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x3f8>
10000c88:	4bf9      	ldr	r3, [pc, #996]	@ (10001070 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x408>)
10000c8a:	408a      	lsls	r2, r1
10000c8c:	b0b7      	sub	sp, #220	@ 0xdc
10000c8e:	eb02 0c03 	add.w	ip, r2, r3
10000c92:	2301      	movs	r3, #1
10000c94:	f04f 0b00 	mov.w	fp, #0
10000c98:	f04f 0910 	mov.w	r9, #16
10000c9c:	46d0      	mov	r8, sl
10000c9e:	fa0a fa03 	lsl.w	sl, sl, r3
10000ca2:	4650      	mov	r0, sl
10000ca4:	eeb7 fb00 	vmov.f64	d15, #112	@ 0x3f800000  1.0
10000ca8:	46da      	mov	sl, fp
10000caa:	408b      	lsls	r3, r1
10000cac:	085b      	lsrs	r3, r3, #1
10000cae:	9310      	str	r3, [sp, #64]	@ 0x40
10000cb0:	4bf0      	ldr	r3, [pc, #960]	@ (10001074 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x40c>)
10000cb2:	fa09 f901 	lsl.w	r9, r9, r1
10000cb6:	4499      	add	r9, r3
10000cb8:	9111      	str	r1, [sp, #68]	@ 0x44
10000cba:	45c3      	cmp	fp, r8
10000cbc:	f080 8297 	bcs.w	100011ee <fndsa_vect_iFFT_fp64_exact.constprop.0+0x586>
10000cc0:	edd9 7a02 	vldr	s15, [r9, #8]
10000cc4:	edd9 6a00 	vldr	s13, [r9]
10000cc8:	eeb8 5b67 	vcvt.f64.u32	d5, s15
10000ccc:	eeb8 4b66 	vcvt.f64.u32	d4, s13
10000cd0:	ee39 5b45 	vsub.f64	d5, d9, d5
10000cd4:	edd9 6a01 	vldr	s13, [r9, #4]
10000cd8:	edd9 7a03 	vldr	s15, [r9, #12]
10000cdc:	eeb8 3b66 	vcvt.f64.u32	d3, s13
10000ce0:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10000ce4:	ee25 6b0d 	vmul.f64	d6, d5, d13
10000ce8:	ee39 7b47 	vsub.f64	d7, d9, d7
10000cec:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10000cf0:	ee37 7b4f 	vsub.f64	d7, d7, d15
10000cf4:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10000cf8:	ee37 7b06 	vadd.f64	d7, d7, d6
10000cfc:	ee06 5b49 	vmls.f64	d5, d6, d9
10000d00:	ee27 6b0d 	vmul.f64	d6, d7, d13
10000d04:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10000d08:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10000d0c:	ee06 7b49 	vmls.f64	d7, d6, d9
10000d10:	ed8d 5b08 	vstr	d5, [sp, #32]
10000d14:	ed8d 7b06 	vstr	d7, [sp, #24]
10000d18:	ee34 5b05 	vadd.f64	d5, d4, d5
10000d1c:	ee33 7b07 	vadd.f64	d7, d3, d7
10000d20:	900f      	str	r0, [sp, #60]	@ 0x3c
10000d22:	ed8d 4b04 	vstr	d4, [sp, #16]
10000d26:	ed8d 3b02 	vstr	d3, [sp, #8]
10000d2a:	ed8d 5b0a 	vstr	d5, [sp, #40]	@ 0x28
10000d2e:	ed8d 7b0c 	vstr	d7, [sp, #48]	@ 0x30
10000d32:	4658      	mov	r0, fp
10000d34:	4667      	mov	r7, ip
10000d36:	4bce      	ldr	r3, [pc, #824]	@ (10001070 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x408>)
10000d38:	eb0c 150b 	add.w	r5, ip, fp, lsl #4
10000d3c:	eb03 160b 	add.w	r6, r3, fp, lsl #4
10000d40:	eb03 1408 	add.w	r4, r3, r8, lsl #4
10000d44:	eb0c 1108 	add.w	r1, ip, r8, lsl #4
10000d48:	ed96 4b02 	vldr	d4, [r6, #8]
10000d4c:	ed94 2b02 	vldr	d2, [r4, #8]
10000d50:	ee34 3b09 	vadd.f64	d3, d4, d9
10000d54:	ee33 3b42 	vsub.f64	d3, d3, d2
10000d58:	ee23 8b0d 	vmul.f64	d8, d3, d13
10000d5c:	ed9d 7b06 	vldr	d7, [sp, #24]
10000d60:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10000d64:	ed95 5b02 	vldr	d5, [r5, #8]
10000d68:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10000d6c:	ed8d 7b2a 	vstr	d7, [sp, #168]	@ 0xa8
10000d70:	ed9d 7b08 	vldr	d7, [sp, #32]
10000d74:	ed96 6b00 	vldr	d6, [r6]
10000d78:	ee34 4b02 	vadd.f64	d4, d4, d2
10000d7c:	ee08 3b49 	vmls.f64	d3, d8, d9
10000d80:	ed8d 7b2c 	vstr	d7, [sp, #176]	@ 0xb0
10000d84:	ee35 2b09 	vadd.f64	d2, d5, d9
10000d88:	ed91 7b02 	vldr	d7, [r1, #8]
10000d8c:	ed94 ab00 	vldr	d10, [r4]
10000d90:	ee37 5b05 	vadd.f64	d5, d7, d5
10000d94:	ee32 2b47 	vsub.f64	d2, d2, d7
10000d98:	ee33 cb0f 	vadd.f64	d12, d3, d15
10000d9c:	ee36 7b09 	vadd.f64	d7, d6, d9
10000da0:	ee24 3b0d 	vmul.f64	d3, d4, d13
10000da4:	ee36 6b0a 	vadd.f64	d6, d6, d10
10000da8:	ee37 7b4a 	vsub.f64	d7, d7, d10
10000dac:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10000db0:	ee25 ab0d 	vmul.f64	d10, d5, d13
10000db4:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10000db8:	ee37 7b4f 	vsub.f64	d7, d7, d15
10000dbc:	eebc abca 	vcvt.u32.f64	s20, d10
10000dc0:	ee37 7b08 	vadd.f64	d7, d7, d8
10000dc4:	ee36 6b03 	vadd.f64	d6, d6, d3
10000dc8:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10000dcc:	ee22 8b0d 	vmul.f64	d8, d2, d13
10000dd0:	ee03 4b49 	vmls.f64	d4, d3, d9
10000dd4:	ed95 3b00 	vldr	d3, [r5]
10000dd8:	ed91 bb00 	vldr	d11, [r1]
10000ddc:	ee0a 5b49 	vmls.f64	d5, d10, d9
10000de0:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10000de4:	ee33 3b09 	vadd.f64	d3, d3, d9
10000de8:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10000dec:	ee35 5b0f 	vadd.f64	d5, d5, d15
10000df0:	ee33 3b4b 	vsub.f64	d3, d3, d11
10000df4:	ed8d 5b00 	vstr	d5, [sp]
10000df8:	ee08 2b49 	vmls.f64	d2, d8, d9
10000dfc:	ed95 5b00 	vldr	d5, [r5]
10000e00:	ee33 3b4f 	vsub.f64	d3, d3, d15
10000e04:	ee35 5b0b 	vadd.f64	d5, d5, d11
10000e08:	ee33 3b08 	vadd.f64	d3, d3, d8
10000e0c:	ee32 bb0f 	vadd.f64	d11, d2, d15
10000e10:	ee27 8b0d 	vmul.f64	d8, d7, d13
10000e14:	ee26 2b0d 	vmul.f64	d2, d6, d13
10000e18:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10000e1c:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10000e20:	ee35 5b0a 	vadd.f64	d5, d5, d10
10000e24:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10000e28:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10000e2c:	ee08 7b49 	vmls.f64	d7, d8, d9
10000e30:	ee02 6b49 	vmls.f64	d6, d2, d9
10000e34:	ee25 8b0d 	vmul.f64	d8, d5, d13
10000e38:	ee23 2b0d 	vmul.f64	d2, d3, d13
10000e3c:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10000e40:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10000e44:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10000e48:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10000e4c:	ed9f ab86 	vldr	d10, [pc, #536]	@ 10001068 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x400>
10000e50:	ee34 4b0f 	vadd.f64	d4, d4, d15
10000e54:	ee08 5b49 	vmls.f64	d5, d8, d9
10000e58:	ee02 3b49 	vmls.f64	d3, d2, d9
10000e5c:	ee37 7b0a 	vadd.f64	d7, d7, d10
10000e60:	ee33 3b0a 	vadd.f64	d3, d3, d10
10000e64:	ee24 2b0d 	vmul.f64	d2, d4, d13
10000e68:	ee36 6b0a 	vadd.f64	d6, d6, d10
10000e6c:	ee35 5b0a 	vadd.f64	d5, d5, d10
10000e70:	ee2c ab0d 	vmul.f64	d10, d12, d13
10000e74:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10000e78:	eebc abca 	vcvt.u32.f64	s20, d10
10000e7c:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10000e80:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10000e84:	ee36 6b02 	vadd.f64	d6, d6, d2
10000e88:	ee37 7b0a 	vadd.f64	d7, d7, d10
10000e8c:	ee0a cb49 	vmls.f64	d12, d10, d9
10000e90:	ee02 4b49 	vmls.f64	d4, d2, d9
10000e94:	eeb6 ab00 	vmov.f64	d10, #96	@ 0x3f000000  0.5
10000e98:	ed9d 2b00 	vldr	d2, [sp]
10000e9c:	ee24 4b0a 	vmul.f64	d4, d4, d10
10000ea0:	ee22 2b0d 	vmul.f64	d2, d2, d13
10000ea4:	ee2c 8b0a 	vmul.f64	d8, d12, d10
10000ea8:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10000eac:	ee2b ab0d 	vmul.f64	d10, d11, d13
10000eb0:	eefc 4bc2 	vcvt.u32.f64	s9, d2
10000eb4:	eeb8 cb44 	vcvt.f64.u32	d12, s8
10000eb8:	ed9d 2b00 	vldr	d2, [sp]
10000ebc:	eeb8 4b64 	vcvt.f64.u32	d4, s9
10000ec0:	eebc abca 	vcvt.u32.f64	s20, d10
10000ec4:	ee35 5b04 	vadd.f64	d5, d5, d4
10000ec8:	ee04 2b49 	vmls.f64	d2, d4, d9
10000ecc:	eeb8 4b4a 	vcvt.f64.u32	d4, s20
10000ed0:	eeb6 ab00 	vmov.f64	d10, #96	@ 0x3f000000  0.5
10000ed4:	ee04 bb49 	vmls.f64	d11, d4, d9
10000ed8:	ee22 2b0a 	vmul.f64	d2, d2, d10
10000edc:	ee33 ab04 	vadd.f64	d10, d3, d4
10000ee0:	eeb6 4b00 	vmov.f64	d4, #96	@ 0x3f000000  0.5
10000ee4:	ee2b bb04 	vmul.f64	d11, d11, d4
10000ee8:	eebc bbcb 	vcvt.u32.f64	s22, d11
10000eec:	ee27 4b0d 	vmul.f64	d4, d7, d13
10000ef0:	eeb8 3b4b 	vcvt.f64.u32	d3, s22
10000ef4:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10000ef8:	ed8d 3b00 	vstr	d3, [sp]
10000efc:	ee26 3b0d 	vmul.f64	d3, d6, d13
10000f00:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10000f04:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10000f08:	ee04 7b49 	vmls.f64	d7, d4, d9
10000f0c:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10000f10:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10000f14:	ee03 6b49 	vmls.f64	d6, d3, d9
10000f18:	ee17 ca90 	vmov	ip, s15
10000f1c:	eefc 7bc6 	vcvt.u32.f64	s15, d6
10000f20:	ea4f 72dc 	mov.w	r2, ip, lsr #31
10000f24:	ee06 2a10 	vmov	s12, r2
10000f28:	ea4f 025c 	mov.w	r2, ip, lsr #1
10000f2c:	f00c 0c01 	and.w	ip, ip, #1
10000f30:	ee17 3a90 	vmov	r3, s15
10000f34:	ee0b 2a10 	vmov	s22, r2
10000f38:	ee07 ca90 	vmov	s15, ip
10000f3c:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10000f40:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10000f44:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10000f48:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10000f4c:	eeb8 bbcb 	vcvt.f64.s32	d11, s22
10000f50:	ea4f 0e53 	mov.w	lr, r3, lsr #1
10000f54:	0fda      	lsrs	r2, r3, #31
10000f56:	ee06 bb0e 	vmla.f64	d11, d6, d14
10000f5a:	ee07 8b0e 	vmla.f64	d8, d7, d14
10000f5e:	ee06 2a10 	vmov	s12, r2
10000f62:	ee07 ea90 	vmov	s15, lr
10000f66:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10000f6a:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10000f6e:	ee06 7b0e 	vmla.f64	d7, d6, d14
10000f72:	f003 0301 	and.w	r3, r3, #1
10000f76:	ed86 7b00 	vstr	d7, [r6]
10000f7a:	ee07 3a90 	vmov	s15, r3
10000f7e:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10000f82:	ee07 cb0e 	vmla.f64	d12, d7, d14
10000f86:	ee25 7b0d 	vmul.f64	d7, d5, d13
10000f8a:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10000f8e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10000f92:	ee2a 6b0d 	vmul.f64	d6, d10, d13
10000f96:	ee07 5b49 	vmls.f64	d5, d7, d9
10000f9a:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10000f9e:	eefc 7bc5 	vcvt.u32.f64	s15, d5
10000fa2:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10000fa6:	ee17 ca90 	vmov	ip, s15
10000faa:	ee06 ab49 	vmls.f64	d10, d6, d9
10000fae:	ea4f 72dc 	mov.w	r2, ip, lsr #31
10000fb2:	ee06 2a10 	vmov	s12, r2
10000fb6:	ea4f 025c 	mov.w	r2, ip, lsr #1
10000fba:	eefc 7bca 	vcvt.u32.f64	s15, d10
10000fbe:	ee07 2a10 	vmov	s14, r2
10000fc2:	ee17 3a90 	vmov	r3, s15
10000fc6:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10000fca:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10000fce:	ee06 7b0e 	vmla.f64	d7, d6, d14
10000fd2:	f00c 0c01 	and.w	ip, ip, #1
10000fd6:	ed86 cb02 	vstr	d12, [r6, #8]
10000fda:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10000fde:	ed85 7b00 	vstr	d7, [r5]
10000fe2:	ee07 ca90 	vmov	s15, ip
10000fe6:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10000fea:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10000fee:	0fda      	lsrs	r2, r3, #31
10000ff0:	ee06 2a10 	vmov	s12, r2
10000ff4:	085a      	lsrs	r2, r3, #1
10000ff6:	f003 0301 	and.w	r3, r3, #1
10000ffa:	ee07 2b0e 	vmla.f64	d2, d7, d14
10000ffe:	ee0a 2a10 	vmov	s20, r2
10001002:	ee07 3a90 	vmov	s15, r3
10001006:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
1000100a:	eeb8 7be7 	vcvt.f64.s32	d7, s15
1000100e:	ed9d cb00 	vldr	d12, [sp]
10001012:	eeb8 abca 	vcvt.f64.s32	d10, s20
10001016:	ee07 cb0e 	vmla.f64	d12, d7, d14
1000101a:	ee06 ab0e 	vmla.f64	d10, d6, d14
1000101e:	ed9d 0b02 	vldr	d0, [sp, #8]
10001022:	ed9d 1b04 	vldr	d1, [sp, #16]
10001026:	ed85 2b02 	vstr	d2, [r5, #8]
1000102a:	eeb0 3b48 	vmov.f64	d3, d8
1000102e:	eeb0 2b4b 	vmov.f64	d2, d11
10001032:	ed8d 0b26 	vstr	d0, [sp, #152]	@ 0x98
10001036:	ed8d 1b28 	vstr	d1, [sp, #160]	@ 0xa0
1000103a:	ed8d ab32 	vstr	d10, [sp, #200]	@ 0xc8
1000103e:	ed8d bb2e 	vstr	d11, [sp, #184]	@ 0xb8
10001042:	ed8d 8b30 	vstr	d8, [sp, #192]	@ 0xc0
10001046:	ed8d cb34 	vstr	d12, [sp, #208]	@ 0xd0
1000104a:	e015      	b.n	10001078 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x410>
1000104c:	f3af 8000 	nop.w
10001050:	00000000 	.word	0x00000000
10001054:	41f00000 	.word	0x41f00000
10001058:	00000000 	.word	0x00000000
1000105c:	3df00000 	.word	0x3df00000
10001060:	00000000 	.word	0x00000000
10001064:	41e00000 	.word	0x41e00000
	...
10001070:	3001b0a0 	.word	0x3001b0a0
10001074:	300009a0 	.word	0x300009a0
10001078:	f004 fdf6 	bl	10005c68 <fndsa_fp64e_mul>
1000107c:	ed9d 2b32 	vldr	d2, [sp, #200]	@ 0xc8
10001080:	ed8d 0b12 	vstr	d0, [sp, #72]	@ 0x48
10001084:	ed8d 1b14 	vstr	d1, [sp, #80]	@ 0x50
10001088:	ed9d 0b2a 	vldr	d0, [sp, #168]	@ 0xa8
1000108c:	ed9d 1b2c 	vldr	d1, [sp, #176]	@ 0xb0
10001090:	ed9d 3b34 	vldr	d3, [sp, #208]	@ 0xd0
10001094:	f004 fde8 	bl	10005c68 <fndsa_fp64e_mul>
10001098:	ed9d 6b0a 	vldr	d6, [sp, #40]	@ 0x28
1000109c:	ee26 7b0d 	vmul.f64	d7, d6, d13
100010a0:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100010a4:	ed9d 5b0c 	vldr	d5, [sp, #48]	@ 0x30
100010a8:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100010ac:	ee3c 3b08 	vadd.f64	d3, d12, d8
100010b0:	ee07 6b49 	vmls.f64	d6, d7, d9
100010b4:	ed8d 0b16 	vstr	d0, [sp, #88]	@ 0x58
100010b8:	ee35 0b07 	vadd.f64	d0, d5, d7
100010bc:	ee23 7b0d 	vmul.f64	d7, d3, d13
100010c0:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100010c4:	ee3a ab0b 	vadd.f64	d10, d10, d11
100010c8:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100010cc:	ee3a 2b07 	vadd.f64	d2, d10, d7
100010d0:	ee07 3b49 	vmls.f64	d3, d7, d9
100010d4:	ed8d 1b18 	vstr	d1, [sp, #96]	@ 0x60
100010d8:	ee22 7b0d 	vmul.f64	d7, d2, d13
100010dc:	eeb0 1b46 	vmov.f64	d1, d6
100010e0:	ed8d 6b24 	vstr	d6, [sp, #144]	@ 0x90
100010e4:	ee20 6b0d 	vmul.f64	d6, d0, d13
100010e8:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100010ec:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100010f0:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100010f4:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100010f8:	ee07 2b49 	vmls.f64	d2, d7, d9
100010fc:	ee06 0b49 	vmls.f64	d0, d6, d9
10001100:	ed8d 3b20 	vstr	d3, [sp, #128]	@ 0x80
10001104:	ed8d 0b22 	vstr	d0, [sp, #136]	@ 0x88
10001108:	ed8d 2b1e 	vstr	d2, [sp, #120]	@ 0x78
1000110c:	f004 fdac 	bl	10005c68 <fndsa_fp64e_mul>
10001110:	ed9d 4b18 	vldr	d4, [sp, #96]	@ 0x60
10001114:	ed9d 5b14 	vldr	d5, [sp, #80]	@ 0x50
10001118:	ee35 6b04 	vadd.f64	d6, d5, d4
1000111c:	ee26 3b0d 	vmul.f64	d3, d6, d13
10001120:	ed9d 2b16 	vldr	d2, [sp, #88]	@ 0x58
10001124:	ed9d 7b12 	vldr	d7, [sp, #72]	@ 0x48
10001128:	ee35 5b09 	vadd.f64	d5, d5, d9
1000112c:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10001130:	ee35 5b44 	vsub.f64	d5, d5, d4
10001134:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10001138:	ee37 4b02 	vadd.f64	d4, d7, d2
1000113c:	ee03 6b49 	vmls.f64	d6, d3, d9
10001140:	ee34 4b03 	vadd.f64	d4, d4, d3
10001144:	ee37 7b09 	vadd.f64	d7, d7, d9
10001148:	ee25 3b0d 	vmul.f64	d3, d5, d13
1000114c:	ee37 7b42 	vsub.f64	d7, d7, d2
10001150:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10001154:	ee24 2b0d 	vmul.f64	d2, d4, d13
10001158:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000115c:	ed8d 1b1c 	vstr	d1, [sp, #112]	@ 0x70
10001160:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10001164:	ee31 1b09 	vadd.f64	d1, d1, d9
10001168:	ee03 5b49 	vmls.f64	d5, d3, d9
1000116c:	ee31 6b46 	vsub.f64	d6, d1, d6
10001170:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10001174:	ed84 5b02 	vstr	d5, [r4, #8]
10001178:	ed8d 0b1a 	vstr	d0, [sp, #104]	@ 0x68
1000117c:	ee26 5b0d 	vmul.f64	d5, d6, d13
10001180:	ee30 0b09 	vadd.f64	d0, d0, d9
10001184:	ee02 4b49 	vmls.f64	d4, d2, d9
10001188:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000118c:	ee30 0b44 	vsub.f64	d0, d0, d4
10001190:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10001194:	ee30 0b4f 	vsub.f64	d0, d0, d15
10001198:	ee30 0b05 	vadd.f64	d0, d0, d5
1000119c:	ee05 6b49 	vmls.f64	d6, d5, d9
100011a0:	ee20 5b0d 	vmul.f64	d5, d0, d13
100011a4:	ee37 7b4f 	vsub.f64	d7, d7, d15
100011a8:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100011ac:	ee37 7b03 	vadd.f64	d7, d7, d3
100011b0:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100011b4:	ee05 0b49 	vmls.f64	d0, d5, d9
100011b8:	ee27 5b0d 	vmul.f64	d5, d7, d13
100011bc:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100011c0:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100011c4:	ee05 7b49 	vmls.f64	d7, d5, d9
100011c8:	3001      	adds	r0, #1
100011ca:	3110      	adds	r1, #16
100011cc:	4540      	cmp	r0, r8
100011ce:	f104 0410 	add.w	r4, r4, #16
100011d2:	ed04 7b04 	vstr	d7, [r4, #-16]
100011d6:	f106 0610 	add.w	r6, r6, #16
100011da:	ed01 0b04 	vstr	d0, [r1, #-16]
100011de:	ed01 6b02 	vstr	d6, [r1, #-8]
100011e2:	f105 0510 	add.w	r5, r5, #16
100011e6:	f47f adaf 	bne.w	10000d48 <fndsa_vect_iFFT_fp64_exact.constprop.0+0xe0>
100011ea:	46bc      	mov	ip, r7
100011ec:	980f      	ldr	r0, [sp, #60]	@ 0x3c
100011ee:	9b10      	ldr	r3, [sp, #64]	@ 0x40
100011f0:	f10a 0a01 	add.w	sl, sl, #1
100011f4:	459a      	cmp	sl, r3
100011f6:	4483      	add	fp, r0
100011f8:	4480      	add	r8, r0
100011fa:	f109 0910 	add.w	r9, r9, #16
100011fe:	f47f ad5c 	bne.w	10000cba <fndsa_vect_iFFT_fp64_exact.constprop.0+0x52>
10001202:	9911      	ldr	r1, [sp, #68]	@ 0x44
10001204:	4682      	mov	sl, r0
10001206:	3901      	subs	r1, #1
10001208:	f47f ad43 	bne.w	10000c92 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x2a>
1000120c:	b037      	add	sp, #220	@ 0xdc
1000120e:	ecbd 8b10 	vpop	{d8-d15}
10001212:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10001216:	4770      	bx	lr
