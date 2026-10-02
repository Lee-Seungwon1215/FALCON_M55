10000b50 <fndsa_vect_iFFT_fp64_exact>:
10000b50:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10000b54:	ed2d 8b10 	vpush	{d8-d15}
10000b58:	1e45      	subs	r5, r0, #1
10000b5a:	b0af      	sub	sp, #188	@ 0xbc
10000b5c:	f000 825e 	beq.w	1000101c <fndsa_vect_iFFT_fp64_exact+0x4cc>
10000b60:	2310      	movs	r3, #16
10000b62:	f04f 0e01 	mov.w	lr, #1
10000b66:	ed9f ebf8 	vldr	d14, [pc, #992]	@ 10000f48 <fndsa_vect_iFFT_fp64_exact+0x3f8>
10000b6a:	ed9f fbf9 	vldr	d15, [pc, #996]	@ 10000f50 <fndsa_vect_iFFT_fp64_exact+0x400>
10000b6e:	ed9f 9bfa 	vldr	d9, [pc, #1000]	@ 10000f58 <fndsa_vect_iFFT_fp64_exact+0x408>
10000b72:	fa03 fc05 	lsl.w	ip, r3, r5
10000b76:	4672      	mov	r2, lr
10000b78:	2301      	movs	r3, #1
10000b7a:	f04f 0810 	mov.w	r8, #16
10000b7e:	e9cd 2505 	strd	r2, r5, [sp, #20]
10000b82:	eb01 1702 	add.w	r7, r1, r2, lsl #4
10000b86:	eeb7 db00 	vmov.f64	d13, #112	@ 0x3f800000  1.0
10000b8a:	460a      	mov	r2, r1
10000b8c:	f04f 0b00 	mov.w	fp, #0
10000b90:	46e1      	mov	r9, ip
10000b92:	48f5      	ldr	r0, [pc, #980]	@ (10000f68 <fndsa_vect_iFFT_fp64_exact+0x418>)
10000b94:	40ab      	lsls	r3, r5
10000b96:	eb03 0353 	add.w	r3, r3, r3, lsr #1
10000b9a:	fa08 f805 	lsl.w	r8, r8, r5
10000b9e:	eb00 1303 	add.w	r3, r0, r3, lsl #4
10000ba2:	eb08 0a00 	add.w	sl, r8, r0
10000ba6:	9304      	str	r3, [sp, #16]
10000ba8:	ea4f 0e4e 	mov.w	lr, lr, lsl #1
10000bac:	f8cd e00c 	str.w	lr, [sp, #12]
10000bb0:	ea4f 180e 	mov.w	r8, lr, lsl #4
10000bb4:	9107      	str	r1, [sp, #28]
10000bb6:	edda 7a02 	vldr	s15, [sl, #8]
10000bba:	f8da 3004 	ldr.w	r3, [sl, #4]
10000bbe:	eeb8 4b67 	vcvt.f64.u32	d4, s15
10000bc2:	0fdb      	lsrs	r3, r3, #31
10000bc4:	ee03 3a10 	vmov	s6, r3
10000bc8:	ee3e 4b44 	vsub.f64	d4, d14, d4
10000bcc:	edda 7a03 	vldr	s15, [sl, #12]
10000bd0:	eeb8 3bc3 	vcvt.f64.s32	d3, s6
10000bd4:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10000bd8:	ed8d 3b18 	vstr	d3, [sp, #96]	@ 0x60
10000bdc:	ee24 3b0f 	vmul.f64	d3, d4, d15
10000be0:	edda 6a00 	vldr	s13, [sl]
10000be4:	ee3e 7b47 	vsub.f64	d7, d14, d7
10000be8:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10000bec:	eeb8 5b66 	vcvt.f64.u32	d5, s13
10000bf0:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10000bf4:	ee37 7b4d 	vsub.f64	d7, d7, d13
10000bf8:	ee37 7b03 	vadd.f64	d7, d7, d3
10000bfc:	ee03 4b4e 	vmls.f64	d4, d3, d14
10000c00:	edda 6a01 	vldr	s13, [sl, #4]
10000c04:	ed8d 5b12 	vstr	d5, [sp, #72]	@ 0x48
10000c08:	eeb8 6b66 	vcvt.f64.u32	d6, s13
10000c0c:	ee27 3b0f 	vmul.f64	d3, d7, d15
10000c10:	ee26 2b0f 	vmul.f64	d2, d6, d15
10000c14:	ee25 1b0f 	vmul.f64	d1, d5, d15
10000c18:	ed8d 2b14 	vstr	d2, [sp, #80]	@ 0x50
10000c1c:	ed8d 4b1c 	vstr	d4, [sp, #112]	@ 0x70
10000c20:	ed8d 6b10 	vstr	d6, [sp, #64]	@ 0x40
10000c24:	9b05      	ldr	r3, [sp, #20]
10000c26:	eb03 010b 	add.w	r1, r3, fp
10000c2a:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10000c2e:	ee34 5b05 	vadd.f64	d5, d4, d5
10000c32:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10000c36:	ee24 2b0f 	vmul.f64	d2, d4, d15
10000c3a:	ee03 7b4e 	vmls.f64	d7, d3, d14
10000c3e:	ee25 4b0f 	vmul.f64	d4, d5, d15
10000c42:	ed8d 7b1a 	vstr	d7, [sp, #104]	@ 0x68
10000c46:	eefc 3bc7 	vcvt.u32.f64	s7, d7
10000c4a:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10000c4e:	ee13 3a90 	vmov	r3, s7
10000c52:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10000c56:	ee37 6b06 	vadd.f64	d6, d7, d6
10000c5a:	ee27 3b0f 	vmul.f64	d3, d7, d15
10000c5e:	ee36 7b04 	vadd.f64	d7, d6, d4
10000c62:	ee27 6b0f 	vmul.f64	d6, d7, d15
10000c66:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10000c6a:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10000c6e:	ee06 7b4e 	vmls.f64	d7, d6, d14
10000c72:	eefc 6bc7 	vcvt.u32.f64	s13, d7
10000c76:	0fdb      	lsrs	r3, r3, #31
10000c78:	ee04 5b4e 	vmls.f64	d5, d4, d14
10000c7c:	ee04 3a10 	vmov	s8, r3
10000c80:	ee16 3a90 	vmov	r3, s13
10000c84:	0fdb      	lsrs	r3, r3, #31
10000c86:	ee27 6b0f 	vmul.f64	d6, d7, d15
10000c8a:	ed8d 7b24 	vstr	d7, [sp, #144]	@ 0x90
10000c8e:	ed8d 2b20 	vstr	d2, [sp, #128]	@ 0x80
10000c92:	ee07 3a10 	vmov	s14, r3
10000c96:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
10000c9a:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10000c9e:	ee25 2b0f 	vmul.f64	d2, d5, d15
10000ca2:	458b      	cmp	fp, r1
10000ca4:	ed8d 1b16 	vstr	d1, [sp, #88]	@ 0x58
10000ca8:	ed8d 3b1e 	vstr	d3, [sp, #120]	@ 0x78
10000cac:	ed8d 5b26 	vstr	d5, [sp, #152]	@ 0x98
10000cb0:	ed8d 4b22 	vstr	d4, [sp, #136]	@ 0x88
10000cb4:	ed8d 2b2a 	vstr	d2, [sp, #168]	@ 0xa8
10000cb8:	ed8d 6b28 	vstr	d6, [sp, #160]	@ 0xa0
10000cbc:	ed8d 7b2c 	vstr	d7, [sp, #176]	@ 0xb0
10000cc0:	f080 819a 	bcs.w	10000ff8 <fndsa_vect_iFFT_fp64_exact+0x4a8>
10000cc4:	463e      	mov	r6, r7
10000cc6:	4611      	mov	r1, r2
10000cc8:	eb09 0502 	add.w	r5, r9, r2
10000ccc:	eb09 0407 	add.w	r4, r9, r7
10000cd0:	9202      	str	r2, [sp, #8]
10000cd2:	ed91 ab02 	vldr	d10, [r1, #8]
10000cd6:	ee3a 0b0e 	vadd.f64	d0, d10, d14
10000cda:	ed96 7b02 	vldr	d7, [r6, #8]
10000cde:	ed91 cb00 	vldr	d12, [r1]
10000ce2:	ed96 3b00 	vldr	d3, [r6]
10000ce6:	ed95 bb02 	vldr	d11, [r5, #8]
10000cea:	ed94 5b02 	vldr	d5, [r4, #8]
10000cee:	ee3a ab07 	vadd.f64	d10, d10, d7
10000cf2:	ee30 7b47 	vsub.f64	d7, d0, d7
10000cf6:	ee3c 1b0e 	vadd.f64	d1, d12, d14
10000cfa:	ee27 2b0f 	vmul.f64	d2, d7, d15
10000cfe:	ee33 cb0c 	vadd.f64	d12, d3, d12
10000d02:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10000d06:	ee31 3b43 	vsub.f64	d3, d1, d3
10000d0a:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10000d0e:	ee33 3b4d 	vsub.f64	d3, d3, d13
10000d12:	ee02 7b4e 	vmls.f64	d7, d2, d14
10000d16:	ee33 3b02 	vadd.f64	d3, d3, d2
10000d1a:	ee37 7b0d 	vadd.f64	d7, d7, d13
10000d1e:	ee23 1b0f 	vmul.f64	d1, d3, d15
10000d22:	ee27 2b0f 	vmul.f64	d2, d7, d15
10000d26:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10000d2a:	eefc 0bc2 	vcvt.u32.f64	s1, d2
10000d2e:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10000d32:	ee01 3b4e 	vmls.f64	d3, d1, d14
10000d36:	ed9f 4b8a 	vldr	d4, [pc, #552]	@ 10000f60 <fndsa_vect_iFFT_fp64_exact+0x410>
10000d3a:	ed94 8b00 	vldr	d8, [r4]
10000d3e:	ed95 6b00 	vldr	d6, [r5]
10000d42:	ee3b 2b0e 	vadd.f64	d2, d11, d14
10000d46:	ee35 bb0b 	vadd.f64	d11, d5, d11
10000d4a:	ee32 2b45 	vsub.f64	d2, d2, d5
10000d4e:	eeb8 5b60 	vcvt.f64.u32	d5, s1
10000d52:	ee33 3b04 	vadd.f64	d3, d3, d4
10000d56:	ee33 3b05 	vadd.f64	d3, d3, d5
10000d5a:	ee36 4b0e 	vadd.f64	d4, d6, d14
10000d5e:	ee23 0b0f 	vmul.f64	d0, d3, d15
10000d62:	ee36 6b08 	vadd.f64	d6, d6, d8
10000d66:	ee05 7b4e 	vmls.f64	d7, d5, d14
10000d6a:	ee22 5b0f 	vmul.f64	d5, d2, d15
10000d6e:	ed8d 6b00 	vstr	d6, [sp]
10000d72:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10000d76:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10000d7a:	eeb6 6b00 	vmov.f64	d6, #96	@ 0x3f000000  0.5
10000d7e:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10000d82:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10000d86:	ee05 2b4e 	vmls.f64	d2, d5, d14
10000d8a:	ee27 7b06 	vmul.f64	d7, d7, d6
10000d8e:	ee34 6b48 	vsub.f64	d6, d4, d8
10000d92:	ee00 3b4e 	vmls.f64	d3, d0, d14
10000d96:	ee36 6b4d 	vsub.f64	d6, d6, d13
10000d9a:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10000d9e:	ee36 6b05 	vadd.f64	d6, d6, d5
10000da2:	eefc 5bc3 	vcvt.u32.f64	s11, d3
10000da6:	eeb8 1b47 	vcvt.f64.u32	d1, s14
10000daa:	ee15 3a90 	vmov	r3, s11
10000dae:	ee32 2b0d 	vadd.f64	d2, d2, d13
10000db2:	ee22 7b0f 	vmul.f64	d7, d2, d15
10000db6:	0fda      	lsrs	r2, r3, #31
10000db8:	eefc 3bc7 	vcvt.u32.f64	s7, d7
10000dbc:	ee07 2a10 	vmov	s14, r2
10000dc0:	085a      	lsrs	r2, r3, #1
10000dc2:	ee00 2a10 	vmov	s0, r2
10000dc6:	ee26 4b0f 	vmul.f64	d4, d6, d15
10000dca:	f003 0301 	and.w	r3, r3, #1
10000dce:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10000dd2:	eeb8 0bc0 	vcvt.f64.s32	d0, s0
10000dd6:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10000dda:	ee07 0b09 	vmla.f64	d0, d7, d9
10000dde:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10000de2:	ee07 3a90 	vmov	s15, r3
10000de6:	ee04 6b4e 	vmls.f64	d6, d4, d14
10000dea:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10000dee:	eeb8 4b63 	vcvt.f64.u32	d4, s7
10000df2:	ee07 1b09 	vmla.f64	d1, d7, d9
10000df6:	ed9f 7b5a 	vldr	d7, [pc, #360]	@ 10000f60 <fndsa_vect_iFFT_fp64_exact+0x410>
10000dfa:	ee36 6b07 	vadd.f64	d6, d6, d7
10000dfe:	ee2a 5b0f 	vmul.f64	d5, d10, d15
10000e02:	ee36 7b04 	vadd.f64	d7, d6, d4
10000e06:	ee04 2b4e 	vmls.f64	d2, d4, d14
10000e0a:	ee27 4b0f 	vmul.f64	d4, d7, d15
10000e0e:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10000e12:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10000e16:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10000e1a:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10000e1e:	eeb6 6b00 	vmov.f64	d6, #96	@ 0x3f000000  0.5
10000e22:	ee04 7b4e 	vmls.f64	d7, d4, d14
10000e26:	ee22 2b06 	vmul.f64	d2, d2, d6
10000e2a:	ee3c 6b05 	vadd.f64	d6, d12, d5
10000e2e:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10000e32:	ee26 8b0f 	vmul.f64	d8, d6, d15
10000e36:	ee05 ab4e 	vmls.f64	d10, d5, d14
10000e3a:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10000e3e:	eeb8 3b42 	vcvt.f64.u32	d3, s4
10000e42:	ee3a 5b0d 	vadd.f64	d5, d10, d13
10000e46:	eebc 2bc8 	vcvt.u32.f64	s4, d8
10000e4a:	ee17 3a90 	vmov	r3, s15
10000e4e:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10000e52:	ee25 4b0f 	vmul.f64	d4, d5, d15
10000e56:	0fda      	lsrs	r2, r3, #31
10000e58:	ee08 2a10 	vmov	s16, r2
10000e5c:	085a      	lsrs	r2, r3, #1
10000e5e:	ee02 6b4e 	vmls.f64	d6, d2, d14
10000e62:	ed9f 7b3f 	vldr	d7, [pc, #252]	@ 10000f60 <fndsa_vect_iFFT_fp64_exact+0x410>
10000e66:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10000e6a:	ee36 6b07 	vadd.f64	d6, d6, d7
10000e6e:	ee02 2a10 	vmov	s4, r2
10000e72:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10000e76:	eeb8 8bc8 	vcvt.f64.s32	d8, s16
10000e7a:	eeb8 2bc2 	vcvt.f64.s32	d2, s4
10000e7e:	eeb6 ab00 	vmov.f64	d10, #96	@ 0x3f000000  0.5
10000e82:	ee08 2b09 	vmla.f64	d2, d8, d9
10000e86:	ee2b 8b0f 	vmul.f64	d8, d11, d15
10000e8a:	ee36 6b04 	vadd.f64	d6, d6, d4
10000e8e:	ee04 5b4e 	vmls.f64	d5, d4, d14
10000e92:	ee25 5b0a 	vmul.f64	d5, d5, d10
10000e96:	f003 0301 	and.w	r3, r3, #1
10000e9a:	ee07 3a90 	vmov	s15, r3
10000e9e:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10000ea2:	ee26 4b0f 	vmul.f64	d4, d6, d15
10000ea6:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10000eaa:	eebc abc5 	vcvt.u32.f64	s20, d5
10000eae:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10000eb2:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10000eb6:	ee07 3b09 	vmla.f64	d3, d7, d9
10000eba:	ed9d 5b00 	vldr	d5, [sp]
10000ebe:	ee35 7b08 	vadd.f64	d7, d5, d8
10000ec2:	eeb0 5b4b 	vmov.f64	d5, d11
10000ec6:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10000eca:	ee08 5b4e 	vmls.f64	d5, d8, d14
10000ece:	ee27 cb0f 	vmul.f64	d12, d7, d15
10000ed2:	ee04 6b4e 	vmls.f64	d6, d4, d14
10000ed6:	ee35 5b0d 	vadd.f64	d5, d5, d13
10000eda:	eebc cbcc 	vcvt.u32.f64	s24, d12
10000ede:	eefc 6bc6 	vcvt.u32.f64	s13, d6
10000ee2:	ee25 4b0f 	vmul.f64	d4, d5, d15
10000ee6:	eeb8 cb4c 	vcvt.f64.u32	d12, s24
10000eea:	ee16 3a90 	vmov	r3, s13
10000eee:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10000ef2:	ed9f 6b1b 	vldr	d6, [pc, #108]	@ 10000f60 <fndsa_vect_iFFT_fp64_exact+0x410>
10000ef6:	ee0c 7b4e 	vmls.f64	d7, d12, d14
10000efa:	0fda      	lsrs	r2, r3, #31
10000efc:	eeb8 bb4a 	vcvt.f64.u32	d11, s20
10000f00:	ee0a 2a10 	vmov	s20, r2
10000f04:	085a      	lsrs	r2, r3, #1
10000f06:	ee37 7b06 	vadd.f64	d7, d7, d6
10000f0a:	f003 0301 	and.w	r3, r3, #1
10000f0e:	ee06 3a90 	vmov	s13, r3
10000f12:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10000f16:	eeb8 6be6 	vcvt.f64.s32	d6, s13
10000f1a:	ee37 7b04 	vadd.f64	d7, d7, d4
10000f1e:	ee06 bb09 	vmla.f64	d11, d6, d9
10000f22:	ee27 6b0f 	vmul.f64	d6, d7, d15
10000f26:	ee08 2a10 	vmov	s16, r2
10000f2a:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10000f2e:	eeb8 abca 	vcvt.f64.s32	d10, s20
10000f32:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10000f36:	eeb8 8bc8 	vcvt.f64.s32	d8, s16
10000f3a:	ee06 7b4e 	vmls.f64	d7, d6, d14
10000f3e:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10000f42:	ee04 5b4e 	vmls.f64	d5, d4, d14
10000f46:	e011      	b.n	10000f6c <fndsa_vect_iFFT_fp64_exact+0x41c>
10000f48:	00000000 	.word	0x00000000
10000f4c:	41f00000 	.word	0x41f00000
10000f50:	00000000 	.word	0x00000000
10000f54:	3df00000 	.word	0x3df00000
10000f58:	00000000 	.word	0x00000000
10000f5c:	41e00000 	.word	0x41e00000
	...
10000f68:	300009a0 	.word	0x300009a0
10000f6c:	ee0a 8b09 	vmla.f64	d8, d10, d9
10000f70:	eeb6 ab00 	vmov.f64	d10, #96	@ 0x3f000000  0.5
10000f74:	ee17 3a90 	vmov	r3, s15
10000f78:	ee25 5b0a 	vmul.f64	d5, d5, d10
10000f7c:	0fda      	lsrs	r2, r3, #31
10000f7e:	ee04 2a10 	vmov	s8, r2
10000f82:	085a      	lsrs	r2, r3, #1
10000f84:	f003 0301 	and.w	r3, r3, #1
10000f88:	ee06 2a10 	vmov	s12, r2
10000f8c:	ee07 3a90 	vmov	s15, r3
10000f90:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10000f94:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
10000f98:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10000f9c:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10000fa0:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10000fa4:	ee07 5b09 	vmla.f64	d5, d7, d9
10000fa8:	ed81 8b00 	vstr	d8, [r1]
10000fac:	ed81 bb02 	vstr	d11, [r1, #8]
10000fb0:	ee04 6b09 	vmla.f64	d6, d4, d9
10000fb4:	a810      	add	r0, sp, #64	@ 0x40
10000fb6:	ed85 6b00 	vstr	d6, [r5]
10000fba:	ed85 5b02 	vstr	d5, [r5, #8]
10000fbe:	f7ff f9d3 	bl	10000368 <fp64e_cmul_prepared>
10000fc2:	3110      	adds	r1, #16
10000fc4:	428f      	cmp	r7, r1
10000fc6:	ed86 0b00 	vstr	d0, [r6]
10000fca:	f105 0510 	add.w	r5, r5, #16
10000fce:	ed86 1b02 	vstr	d1, [r6, #8]
10000fd2:	f106 0610 	add.w	r6, r6, #16
10000fd6:	ed8d 0b08 	vstr	d0, [sp, #32]
10000fda:	ed84 2b00 	vstr	d2, [r4]
10000fde:	ed84 3b02 	vstr	d3, [r4, #8]
10000fe2:	f104 0410 	add.w	r4, r4, #16
10000fe6:	ed8d 1b0a 	vstr	d1, [sp, #40]	@ 0x28
10000fea:	ed8d 2b0c 	vstr	d2, [sp, #48]	@ 0x30
10000fee:	ed8d 3b0e 	vstr	d3, [sp, #56]	@ 0x38
10000ff2:	f47f ae6e 	bne.w	10000cd2 <fndsa_vect_iFFT_fp64_exact+0x182>
10000ff6:	9a02      	ldr	r2, [sp, #8]
10000ff8:	9b03      	ldr	r3, [sp, #12]
10000ffa:	f10a 0a10 	add.w	sl, sl, #16
10000ffe:	449b      	add	fp, r3
10001000:	9b04      	ldr	r3, [sp, #16]
10001002:	4442      	add	r2, r8
10001004:	4553      	cmp	r3, sl
10001006:	4447      	add	r7, r8
10001008:	f47f add5 	bne.w	10000bb6 <fndsa_vect_iFFT_fp64_exact+0x66>
1000100c:	9d06      	ldr	r5, [sp, #24]
1000100e:	46cc      	mov	ip, r9
10001010:	3d01      	subs	r5, #1
10001012:	f8dd e00c 	ldr.w	lr, [sp, #12]
10001016:	9907      	ldr	r1, [sp, #28]
10001018:	f47f adad 	bne.w	10000b76 <fndsa_vect_iFFT_fp64_exact+0x26>
1000101c:	b02f      	add	sp, #188	@ 0xbc
1000101e:	ecbd 8b10 	vpop	{d8-d15}
10001022:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10001026:	bf00      	nop

