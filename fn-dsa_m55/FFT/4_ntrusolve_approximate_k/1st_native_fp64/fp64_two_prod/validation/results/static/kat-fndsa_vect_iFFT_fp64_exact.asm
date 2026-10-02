10005be0 <fndsa_vect_iFFT_fp64_exact>:
10005be0:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10005be4:	ed2d 8b10 	vpush	{d8-d15}
10005be8:	1e45      	subs	r5, r0, #1
10005bea:	b0af      	sub	sp, #188	@ 0xbc
10005bec:	f000 825e 	beq.w	100060ac <fndsa_vect_iFFT_fp64_exact+0x4cc>
10005bf0:	2310      	movs	r3, #16
10005bf2:	f04f 0e01 	mov.w	lr, #1
10005bf6:	ed9f ebf8 	vldr	d14, [pc, #992]	@ 10005fd8 <fndsa_vect_iFFT_fp64_exact+0x3f8>
10005bfa:	ed9f fbf9 	vldr	d15, [pc, #996]	@ 10005fe0 <fndsa_vect_iFFT_fp64_exact+0x400>
10005bfe:	ed9f 9bfa 	vldr	d9, [pc, #1000]	@ 10005fe8 <fndsa_vect_iFFT_fp64_exact+0x408>
10005c02:	fa03 fc05 	lsl.w	ip, r3, r5
10005c06:	4672      	mov	r2, lr
10005c08:	2301      	movs	r3, #1
10005c0a:	f04f 0810 	mov.w	r8, #16
10005c0e:	e9cd 2505 	strd	r2, r5, [sp, #20]
10005c12:	eb01 1702 	add.w	r7, r1, r2, lsl #4
10005c16:	eeb7 db00 	vmov.f64	d13, #112	@ 0x3f800000  1.0
10005c1a:	460a      	mov	r2, r1
10005c1c:	f04f 0b00 	mov.w	fp, #0
10005c20:	46e1      	mov	r9, ip
10005c22:	48f5      	ldr	r0, [pc, #980]	@ (10005ff8 <fndsa_vect_iFFT_fp64_exact+0x418>)
10005c24:	40ab      	lsls	r3, r5
10005c26:	eb03 0353 	add.w	r3, r3, r3, lsr #1
10005c2a:	ea4f 0e4e 	mov.w	lr, lr, lsl #1
10005c2e:	fa08 f805 	lsl.w	r8, r8, r5
10005c32:	eb00 1303 	add.w	r3, r0, r3, lsl #4
10005c36:	eb08 0a00 	add.w	sl, r8, r0
10005c3a:	9304      	str	r3, [sp, #16]
10005c3c:	f8cd e00c 	str.w	lr, [sp, #12]
10005c40:	ea4f 180e 	mov.w	r8, lr, lsl #4
10005c44:	9107      	str	r1, [sp, #28]
10005c46:	edda 7a02 	vldr	s15, [sl, #8]
10005c4a:	f8da 3004 	ldr.w	r3, [sl, #4]
10005c4e:	eeb8 4b67 	vcvt.f64.u32	d4, s15
10005c52:	0fdb      	lsrs	r3, r3, #31
10005c54:	ee03 3a10 	vmov	s6, r3
10005c58:	ee3e 4b44 	vsub.f64	d4, d14, d4
10005c5c:	eeb8 3bc3 	vcvt.f64.s32	d3, s6
10005c60:	edda 7a03 	vldr	s15, [sl, #12]
10005c64:	ed8d 3b18 	vstr	d3, [sp, #96]	@ 0x60
10005c68:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10005c6c:	ee24 3b0f 	vmul.f64	d3, d4, d15
10005c70:	ee3e 7b47 	vsub.f64	d7, d14, d7
10005c74:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10005c78:	edda 6a00 	vldr	s13, [sl]
10005c7c:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10005c80:	ee37 7b4d 	vsub.f64	d7, d7, d13
10005c84:	eeb8 5b66 	vcvt.f64.u32	d5, s13
10005c88:	ee37 7b03 	vadd.f64	d7, d7, d3
10005c8c:	edda 6a01 	vldr	s13, [sl, #4]
10005c90:	ee03 4b4e 	vmls.f64	d4, d3, d14
10005c94:	eeb8 6b66 	vcvt.f64.u32	d6, s13
10005c98:	ee27 3b0f 	vmul.f64	d3, d7, d15
10005c9c:	ee26 2b0f 	vmul.f64	d2, d6, d15
10005ca0:	ee25 1b0f 	vmul.f64	d1, d5, d15
10005ca4:	ed8d 5b12 	vstr	d5, [sp, #72]	@ 0x48
10005ca8:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10005cac:	ee34 5b05 	vadd.f64	d5, d4, d5
10005cb0:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10005cb4:	ed8d 2b14 	vstr	d2, [sp, #80]	@ 0x50
10005cb8:	ed8d 4b1c 	vstr	d4, [sp, #112]	@ 0x70
10005cbc:	ee24 2b0f 	vmul.f64	d2, d4, d15
10005cc0:	ee25 4b0f 	vmul.f64	d4, d5, d15
10005cc4:	ee03 7b4e 	vmls.f64	d7, d3, d14
10005cc8:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10005ccc:	eefc 3bc7 	vcvt.u32.f64	s7, d7
10005cd0:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10005cd4:	ed8d 6b10 	vstr	d6, [sp, #64]	@ 0x40
10005cd8:	ee37 6b06 	vadd.f64	d6, d7, d6
10005cdc:	9b05      	ldr	r3, [sp, #20]
10005cde:	ed8d 7b1a 	vstr	d7, [sp, #104]	@ 0x68
10005ce2:	eb03 010b 	add.w	r1, r3, fp
10005ce6:	ee13 3a90 	vmov	r3, s7
10005cea:	ee27 3b0f 	vmul.f64	d3, d7, d15
10005cee:	ee36 7b04 	vadd.f64	d7, d6, d4
10005cf2:	ee27 6b0f 	vmul.f64	d6, d7, d15
10005cf6:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10005cfa:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005cfe:	ee06 7b4e 	vmls.f64	d7, d6, d14
10005d02:	eefc 6bc7 	vcvt.u32.f64	s13, d7
10005d06:	0fdb      	lsrs	r3, r3, #31
10005d08:	ee04 5b4e 	vmls.f64	d5, d4, d14
10005d0c:	ee04 3a10 	vmov	s8, r3
10005d10:	ee16 3a90 	vmov	r3, s13
10005d14:	0fdb      	lsrs	r3, r3, #31
10005d16:	ee27 6b0f 	vmul.f64	d6, d7, d15
10005d1a:	ed8d 7b24 	vstr	d7, [sp, #144]	@ 0x90
10005d1e:	ee07 3a10 	vmov	s14, r3
10005d22:	ed8d 2b20 	vstr	d2, [sp, #128]	@ 0x80
10005d26:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
10005d2a:	ee25 2b0f 	vmul.f64	d2, d5, d15
10005d2e:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10005d32:	458b      	cmp	fp, r1
10005d34:	ed8d 1b16 	vstr	d1, [sp, #88]	@ 0x58
10005d38:	ed8d 3b1e 	vstr	d3, [sp, #120]	@ 0x78
10005d3c:	ed8d 5b26 	vstr	d5, [sp, #152]	@ 0x98
10005d40:	ed8d 4b22 	vstr	d4, [sp, #136]	@ 0x88
10005d44:	ed8d 2b2a 	vstr	d2, [sp, #168]	@ 0xa8
10005d48:	ed8d 6b28 	vstr	d6, [sp, #160]	@ 0xa0
10005d4c:	ed8d 7b2c 	vstr	d7, [sp, #176]	@ 0xb0
10005d50:	f080 819a 	bcs.w	10006088 <fndsa_vect_iFFT_fp64_exact+0x4a8>
10005d54:	463e      	mov	r6, r7
10005d56:	4611      	mov	r1, r2
10005d58:	eb09 0502 	add.w	r5, r9, r2
10005d5c:	eb09 0407 	add.w	r4, r9, r7
10005d60:	9202      	str	r2, [sp, #8]
10005d62:	ed91 ab02 	vldr	d10, [r1, #8]
10005d66:	ed96 7b02 	vldr	d7, [r6, #8]
10005d6a:	ee3a 0b0e 	vadd.f64	d0, d10, d14
10005d6e:	ed91 cb00 	vldr	d12, [r1]
10005d72:	ee3a ab07 	vadd.f64	d10, d10, d7
10005d76:	ee30 7b47 	vsub.f64	d7, d0, d7
10005d7a:	ed96 3b00 	vldr	d3, [r6]
10005d7e:	ee3c 1b0e 	vadd.f64	d1, d12, d14
10005d82:	ee27 2b0f 	vmul.f64	d2, d7, d15
10005d86:	ee33 cb0c 	vadd.f64	d12, d3, d12
10005d8a:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10005d8e:	ee31 3b43 	vsub.f64	d3, d1, d3
10005d92:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10005d96:	ee33 3b4d 	vsub.f64	d3, d3, d13
10005d9a:	ee33 3b02 	vadd.f64	d3, d3, d2
10005d9e:	ee02 7b4e 	vmls.f64	d7, d2, d14
10005da2:	ee23 1b0f 	vmul.f64	d1, d3, d15
10005da6:	ee37 7b0d 	vadd.f64	d7, d7, d13
10005daa:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10005dae:	ed95 bb02 	vldr	d11, [r5, #8]
10005db2:	ee27 2b0f 	vmul.f64	d2, d7, d15
10005db6:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10005dba:	ed94 5b02 	vldr	d5, [r4, #8]
10005dbe:	eefc 0bc2 	vcvt.u32.f64	s1, d2
10005dc2:	ee01 3b4e 	vmls.f64	d3, d1, d14
10005dc6:	ee3b 2b0e 	vadd.f64	d2, d11, d14
10005dca:	ed9f 4b89 	vldr	d4, [pc, #548]	@ 10005ff0 <fndsa_vect_iFFT_fp64_exact+0x410>
10005dce:	ee35 bb0b 	vadd.f64	d11, d5, d11
10005dd2:	ee32 2b45 	vsub.f64	d2, d2, d5
10005dd6:	ee33 3b04 	vadd.f64	d3, d3, d4
10005dda:	eeb8 5b60 	vcvt.f64.u32	d5, s1
10005dde:	ed94 8b00 	vldr	d8, [r4]
10005de2:	ed95 6b00 	vldr	d6, [r5]
10005de6:	ee33 3b05 	vadd.f64	d3, d3, d5
10005dea:	ee36 4b0e 	vadd.f64	d4, d6, d14
10005dee:	ee23 0b0f 	vmul.f64	d0, d3, d15
10005df2:	ee36 6b08 	vadd.f64	d6, d6, d8
10005df6:	ee05 7b4e 	vmls.f64	d7, d5, d14
10005dfa:	ee22 5b0f 	vmul.f64	d5, d2, d15
10005dfe:	ed8d 6b00 	vstr	d6, [sp]
10005e02:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10005e06:	eeb6 6b00 	vmov.f64	d6, #96	@ 0x3f000000  0.5
10005e0a:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10005e0e:	ee27 7b06 	vmul.f64	d7, d7, d6
10005e12:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10005e16:	ee34 6b48 	vsub.f64	d6, d4, d8
10005e1a:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10005e1e:	ee00 3b4e 	vmls.f64	d3, d0, d14
10005e22:	ee36 6b4d 	vsub.f64	d6, d6, d13
10005e26:	ee05 2b4e 	vmls.f64	d2, d5, d14
10005e2a:	ee36 6b05 	vadd.f64	d6, d6, d5
10005e2e:	eefc 5bc3 	vcvt.u32.f64	s11, d3
10005e32:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005e36:	ee32 2b0d 	vadd.f64	d2, d2, d13
10005e3a:	ee15 3a90 	vmov	r3, s11
10005e3e:	eeb8 1b47 	vcvt.f64.u32	d1, s14
10005e42:	ee22 7b0f 	vmul.f64	d7, d2, d15
10005e46:	0fda      	lsrs	r2, r3, #31
10005e48:	eefc 3bc7 	vcvt.u32.f64	s7, d7
10005e4c:	ee07 2a10 	vmov	s14, r2
10005e50:	085a      	lsrs	r2, r3, #1
10005e52:	ee00 2a10 	vmov	s0, r2
10005e56:	ee26 4b0f 	vmul.f64	d4, d6, d15
10005e5a:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10005e5e:	eeb8 0bc0 	vcvt.f64.s32	d0, s0
10005e62:	f003 0301 	and.w	r3, r3, #1
10005e66:	ee07 0b09 	vmla.f64	d0, d7, d9
10005e6a:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10005e6e:	ee07 3a90 	vmov	s15, r3
10005e72:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10005e76:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10005e7a:	ee04 6b4e 	vmls.f64	d6, d4, d14
10005e7e:	ee07 1b09 	vmla.f64	d1, d7, d9
10005e82:	ed9f 7b5b 	vldr	d7, [pc, #364]	@ 10005ff0 <fndsa_vect_iFFT_fp64_exact+0x410>
10005e86:	eeb8 4b63 	vcvt.f64.u32	d4, s7
10005e8a:	ee36 6b07 	vadd.f64	d6, d6, d7
10005e8e:	ee36 7b04 	vadd.f64	d7, d6, d4
10005e92:	ee2a 5b0f 	vmul.f64	d5, d10, d15
10005e96:	ee04 2b4e 	vmls.f64	d2, d4, d14
10005e9a:	ee27 4b0f 	vmul.f64	d4, d7, d15
10005e9e:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10005ea2:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10005ea6:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10005eaa:	eeb6 6b00 	vmov.f64	d6, #96	@ 0x3f000000  0.5
10005eae:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10005eb2:	ee22 2b06 	vmul.f64	d2, d2, d6
10005eb6:	ee3c 6b05 	vadd.f64	d6, d12, d5
10005eba:	ee04 7b4e 	vmls.f64	d7, d4, d14
10005ebe:	ee26 8b0f 	vmul.f64	d8, d6, d15
10005ec2:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10005ec6:	ee05 ab4e 	vmls.f64	d10, d5, d14
10005eca:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10005ece:	ee3a 5b0d 	vadd.f64	d5, d10, d13
10005ed2:	eeb8 3b42 	vcvt.f64.u32	d3, s4
10005ed6:	eebc 2bc8 	vcvt.u32.f64	s4, d8
10005eda:	ee17 3a90 	vmov	r3, s15
10005ede:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10005ee2:	ee25 4b0f 	vmul.f64	d4, d5, d15
10005ee6:	0fda      	lsrs	r2, r3, #31
10005ee8:	ee08 2a10 	vmov	s16, r2
10005eec:	085a      	lsrs	r2, r3, #1
10005eee:	ee02 6b4e 	vmls.f64	d6, d2, d14
10005ef2:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10005ef6:	ee02 2a10 	vmov	s4, r2
10005efa:	ed9f 7b3d 	vldr	d7, [pc, #244]	@ 10005ff0 <fndsa_vect_iFFT_fp64_exact+0x410>
10005efe:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10005f02:	eeb8 8bc8 	vcvt.f64.s32	d8, s16
10005f06:	eeb8 2bc2 	vcvt.f64.s32	d2, s4
10005f0a:	ee36 6b07 	vadd.f64	d6, d6, d7
10005f0e:	ee08 2b09 	vmla.f64	d2, d8, d9
10005f12:	eeb6 ab00 	vmov.f64	d10, #96	@ 0x3f000000  0.5
10005f16:	ee2b 8b0f 	vmul.f64	d8, d11, d15
10005f1a:	ee04 5b4e 	vmls.f64	d5, d4, d14
10005f1e:	ee36 6b04 	vadd.f64	d6, d6, d4
10005f22:	f003 0301 	and.w	r3, r3, #1
10005f26:	ee25 5b0a 	vmul.f64	d5, d5, d10
10005f2a:	ee07 3a90 	vmov	s15, r3
10005f2e:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10005f32:	ee26 4b0f 	vmul.f64	d4, d6, d15
10005f36:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10005f3a:	eebc abc5 	vcvt.u32.f64	s20, d5
10005f3e:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10005f42:	ed9d 5b00 	vldr	d5, [sp]
10005f46:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10005f4a:	ee07 3b09 	vmla.f64	d3, d7, d9
10005f4e:	ee35 7b08 	vadd.f64	d7, d5, d8
10005f52:	eeb0 5b4b 	vmov.f64	d5, d11
10005f56:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10005f5a:	ee08 5b4e 	vmls.f64	d5, d8, d14
10005f5e:	ee27 cb0f 	vmul.f64	d12, d7, d15
10005f62:	ee04 6b4e 	vmls.f64	d6, d4, d14
10005f66:	ee35 5b0d 	vadd.f64	d5, d5, d13
10005f6a:	eebc cbcc 	vcvt.u32.f64	s24, d12
10005f6e:	eefc 6bc6 	vcvt.u32.f64	s13, d6
10005f72:	ee25 4b0f 	vmul.f64	d4, d5, d15
10005f76:	eeb8 cb4c 	vcvt.f64.u32	d12, s24
10005f7a:	ee16 3a90 	vmov	r3, s13
10005f7e:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10005f82:	ed9f 6b1b 	vldr	d6, [pc, #108]	@ 10005ff0 <fndsa_vect_iFFT_fp64_exact+0x410>
10005f86:	ee0c 7b4e 	vmls.f64	d7, d12, d14
10005f8a:	0fda      	lsrs	r2, r3, #31
10005f8c:	eeb8 bb4a 	vcvt.f64.u32	d11, s20
10005f90:	ee0a 2a10 	vmov	s20, r2
10005f94:	085a      	lsrs	r2, r3, #1
10005f96:	f003 0301 	and.w	r3, r3, #1
10005f9a:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10005f9e:	ee37 7b06 	vadd.f64	d7, d7, d6
10005fa2:	ee06 3a90 	vmov	s13, r3
10005fa6:	ee37 7b04 	vadd.f64	d7, d7, d4
10005faa:	eeb8 6be6 	vcvt.f64.s32	d6, s13
10005fae:	ee06 bb09 	vmla.f64	d11, d6, d9
10005fb2:	ee27 6b0f 	vmul.f64	d6, d7, d15
10005fb6:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10005fba:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005fbe:	ee08 2a10 	vmov	s16, r2
10005fc2:	ee06 7b4e 	vmls.f64	d7, d6, d14
10005fc6:	eeb8 abca 	vcvt.f64.s32	d10, s20
10005fca:	eeb8 8bc8 	vcvt.f64.s32	d8, s16
10005fce:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10005fd2:	ee04 5b4e 	vmls.f64	d5, d4, d14
10005fd6:	e011      	b.n	10005ffc <fndsa_vect_iFFT_fp64_exact+0x41c>
10005fd8:	00000000 	.word	0x00000000
10005fdc:	41f00000 	.word	0x41f00000
10005fe0:	00000000 	.word	0x00000000
10005fe4:	3df00000 	.word	0x3df00000
10005fe8:	00000000 	.word	0x00000000
10005fec:	41e00000 	.word	0x41e00000
	...
10005ff8:	300039a0 	.word	0x300039a0
10005ffc:	ee0a 8b09 	vmla.f64	d8, d10, d9
10006000:	eeb6 ab00 	vmov.f64	d10, #96	@ 0x3f000000  0.5
10006004:	ee17 3a90 	vmov	r3, s15
10006008:	ee25 5b0a 	vmul.f64	d5, d5, d10
1000600c:	0fda      	lsrs	r2, r3, #31
1000600e:	ee04 2a10 	vmov	s8, r2
10006012:	085a      	lsrs	r2, r3, #1
10006014:	f003 0301 	and.w	r3, r3, #1
10006018:	ee06 2a10 	vmov	s12, r2
1000601c:	ee07 3a90 	vmov	s15, r3
10006020:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10006024:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
10006028:	eeb8 7be7 	vcvt.f64.s32	d7, s15
1000602c:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10006030:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10006034:	ee07 5b09 	vmla.f64	d5, d7, d9
10006038:	ee04 6b09 	vmla.f64	d6, d4, d9
1000603c:	ed81 8b00 	vstr	d8, [r1]
10006040:	ed81 bb02 	vstr	d11, [r1, #8]
10006044:	a810      	add	r0, sp, #64	@ 0x40
10006046:	ed85 6b00 	vstr	d6, [r5]
1000604a:	ed85 5b02 	vstr	d5, [r5, #8]
1000604e:	f7fe fdef 	bl	10004c30 <fp64e_cmul_prepared>
10006052:	3110      	adds	r1, #16
10006054:	428f      	cmp	r7, r1
10006056:	ed86 0b00 	vstr	d0, [r6]
1000605a:	ed86 1b02 	vstr	d1, [r6, #8]
1000605e:	ed8d 0b08 	vstr	d0, [sp, #32]
10006062:	ed84 2b00 	vstr	d2, [r4]
10006066:	ed84 3b02 	vstr	d3, [r4, #8]
1000606a:	ed8d 1b0a 	vstr	d1, [sp, #40]	@ 0x28
1000606e:	ed8d 2b0c 	vstr	d2, [sp, #48]	@ 0x30
10006072:	ed8d 3b0e 	vstr	d3, [sp, #56]	@ 0x38
10006076:	f105 0510 	add.w	r5, r5, #16
1000607a:	f106 0610 	add.w	r6, r6, #16
1000607e:	f104 0410 	add.w	r4, r4, #16
10006082:	f47f ae6e 	bne.w	10005d62 <fndsa_vect_iFFT_fp64_exact+0x182>
10006086:	9a02      	ldr	r2, [sp, #8]
10006088:	9b03      	ldr	r3, [sp, #12]
1000608a:	f10a 0a10 	add.w	sl, sl, #16
1000608e:	449b      	add	fp, r3
10006090:	9b04      	ldr	r3, [sp, #16]
10006092:	4442      	add	r2, r8
10006094:	4553      	cmp	r3, sl
10006096:	4447      	add	r7, r8
10006098:	f47f add5 	bne.w	10005c46 <fndsa_vect_iFFT_fp64_exact+0x66>
1000609c:	9d06      	ldr	r5, [sp, #24]
1000609e:	46cc      	mov	ip, r9
100060a0:	3d01      	subs	r5, #1
100060a2:	f8dd e00c 	ldr.w	lr, [sp, #12]
100060a6:	9907      	ldr	r1, [sp, #28]
100060a8:	f47f adad 	bne.w	10005c06 <fndsa_vect_iFFT_fp64_exact+0x26>
100060ac:	b02f      	add	sp, #188	@ 0xbc
100060ae:	ecbd 8b10 	vpop	{d8-d15}
100060b2:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
100060b6:	bf00      	nop

