10005c88 <fndsa_vect_iFFT_fp64_exact>:
10005c88:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10005c8c:	ed2d 8b10 	vpush	{d8-d15}
10005c90:	1e44      	subs	r4, r0, #1
10005c92:	b0ad      	sub	sp, #180	@ 0xb4
10005c94:	f000 82a5 	beq.w	100061e2 <fndsa_vect_iFFT_fp64_exact+0x55a>
10005c98:	2310      	movs	r3, #16
10005c9a:	460d      	mov	r5, r1
10005c9c:	f04f 0e01 	mov.w	lr, #1
10005ca0:	ed9f db79 	vldr	d13, [pc, #484]	@ 10005e88 <fndsa_vect_iFFT_fp64_exact+0x200>
10005ca4:	ed9f cb7a 	vldr	d12, [pc, #488]	@ 10005e90 <fndsa_vect_iFFT_fp64_exact+0x208>
10005ca8:	ed9f fb7b 	vldr	d15, [pc, #492]	@ 10005e98 <fndsa_vect_iFFT_fp64_exact+0x210>
10005cac:	ed9f eb7c 	vldr	d14, [pc, #496]	@ 10005ea0 <fndsa_vect_iFFT_fp64_exact+0x218>
10005cb0:	fa03 f204 	lsl.w	r2, r3, r4
10005cb4:	f04f 0910 	mov.w	r9, #16
10005cb8:	4670      	mov	r0, lr
10005cba:	2301      	movs	r3, #1
10005cbc:	4984      	ldr	r1, [pc, #528]	@ (10005ed0 <fndsa_vect_iFFT_fp64_exact+0x248>)
10005cbe:	fa09 f904 	lsl.w	r9, r9, r4
10005cc2:	e9cd 0403 	strd	r0, r4, [sp, #12]
10005cc6:	eb05 1800 	add.w	r8, r5, r0, lsl #4
10005cca:	eb09 0a01 	add.w	sl, r9, r1
10005cce:	4628      	mov	r0, r5
10005cd0:	f04f 0b00 	mov.w	fp, #0
10005cd4:	4691      	mov	r9, r2
10005cd6:	fa0e fe03 	lsl.w	lr, lr, r3
10005cda:	40a3      	lsls	r3, r4
10005cdc:	eb03 0353 	add.w	r3, r3, r3, lsr #1
10005ce0:	eb01 1303 	add.w	r3, r1, r3, lsl #4
10005ce4:	e9cd e301 	strd	lr, r3, [sp, #4]
10005ce8:	ea4f 170e 	mov.w	r7, lr, lsl #4
10005cec:	9505      	str	r5, [sp, #20]
10005cee:	edda 7a02 	vldr	s15, [sl, #8]
10005cf2:	f8da 3004 	ldr.w	r3, [sl, #4]
10005cf6:	eeb8 5b67 	vcvt.f64.u32	d5, s15
10005cfa:	0fdb      	lsrs	r3, r3, #31
10005cfc:	ee03 3a10 	vmov	s6, r3
10005d00:	ee3d 5b45 	vsub.f64	d5, d13, d5
10005d04:	eeb8 3bc3 	vcvt.f64.s32	d3, s6
10005d08:	edda 7a03 	vldr	s15, [sl, #12]
10005d0c:	ed8d 3b16 	vstr	d3, [sp, #88]	@ 0x58
10005d10:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10005d14:	ee25 3b0c 	vmul.f64	d3, d5, d12
10005d18:	eeb7 bb00 	vmov.f64	d11, #112	@ 0x3f800000  1.0
10005d1c:	edda 6a00 	vldr	s13, [sl]
10005d20:	edda 4a01 	vldr	s9, [sl, #4]
10005d24:	ee3d 7b47 	vsub.f64	d7, d13, d7
10005d28:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10005d2c:	eeb8 6b66 	vcvt.f64.u32	d6, s13
10005d30:	eeb8 4b64 	vcvt.f64.u32	d4, s9
10005d34:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10005d38:	ed9f 0b5b 	vldr	d0, [pc, #364]	@ 10005ea8 <fndsa_vect_iFFT_fp64_exact+0x220>
10005d3c:	ed9f 8b5c 	vldr	d8, [pc, #368]	@ 10005eb0 <fndsa_vect_iFFT_fp64_exact+0x228>
10005d40:	ee37 7b4b 	vsub.f64	d7, d7, d11
10005d44:	ee03 5b4d 	vmls.f64	d5, d3, d13
10005d48:	ee37 7b03 	vadd.f64	d7, d7, d3
10005d4c:	ee24 2b00 	vmul.f64	d2, d4, d0
10005d50:	ee26 3b08 	vmul.f64	d3, d6, d8
10005d54:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10005d58:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10005d5c:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10005d60:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10005d64:	ed9f 9b54 	vldr	d9, [pc, #336]	@ 10005eb8 <fndsa_vect_iFFT_fp64_exact+0x230>
10005d68:	eeb0 1b44 	vmov.f64	d1, d4
10005d6c:	ed9f ab54 	vldr	d10, [pc, #336]	@ 10005ec0 <fndsa_vect_iFFT_fp64_exact+0x238>
10005d70:	ee02 1b49 	vmls.f64	d1, d2, d9
10005d74:	ed8d 2b12 	vstr	d2, [sp, #72]	@ 0x48
10005d78:	eeb0 2b43 	vmov.f64	d2, d3
10005d7c:	ee01 2b0a 	vmla.f64	d2, d1, d10
10005d80:	ed9f 1b51 	vldr	d1, [pc, #324]	@ 10005ec8 <fndsa_vect_iFFT_fp64_exact+0x240>
10005d84:	ed8d 2b10 	vstr	d2, [sp, #64]	@ 0x40
10005d88:	eeb0 2b46 	vmov.f64	d2, d6
10005d8c:	ee03 2b41 	vmls.f64	d2, d3, d1
10005d90:	ee27 3b0c 	vmul.f64	d3, d7, d12
10005d94:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10005d98:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10005d9c:	ee03 7b4d 	vmls.f64	d7, d3, d13
10005da0:	eebc 3bc7 	vcvt.u32.f64	s6, d7
10005da4:	ee13 2a10 	vmov	r2, s6
10005da8:	0fd2      	lsrs	r2, r2, #31
10005daa:	ee03 2a10 	vmov	s6, r2
10005dae:	ed8d 6b14 	vstr	d6, [sp, #80]	@ 0x50
10005db2:	eeb8 3bc3 	vcvt.f64.s32	d3, s6
10005db6:	ee35 6b06 	vadd.f64	d6, d5, d6
10005dba:	ed8d 3b20 	vstr	d3, [sp, #128]	@ 0x80
10005dbe:	ee26 3b0c 	vmul.f64	d3, d6, d12
10005dc2:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10005dc6:	ee37 4b04 	vadd.f64	d4, d7, d4
10005dca:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10005dce:	ee34 4b03 	vadd.f64	d4, d4, d3
10005dd2:	ee03 6b4d 	vmls.f64	d6, d3, d13
10005dd6:	ed8d 2b0e 	vstr	d2, [sp, #56]	@ 0x38
10005dda:	ee24 2b0c 	vmul.f64	d2, d4, d12
10005dde:	ee26 3b08 	vmul.f64	d3, d6, d8
10005de2:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10005de6:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10005dea:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10005dee:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10005df2:	ee02 4b4d 	vmls.f64	d4, d2, d13
10005df6:	ed9f 2b34 	vldr	d2, [pc, #208]	@ 10005ec8 <fndsa_vect_iFFT_fp64_exact+0x240>
10005dfa:	ed8d 6b28 	vstr	d6, [sp, #160]	@ 0xa0
10005dfe:	ee03 6b42 	vmls.f64	d6, d3, d2
10005e02:	ed8d 6b22 	vstr	d6, [sp, #136]	@ 0x88
10005e06:	eebc 6bc4 	vcvt.u32.f64	s12, d4
10005e0a:	ee16 2a10 	vmov	r2, s12
10005e0e:	0fd2      	lsrs	r2, r2, #31
10005e10:	ee06 2a10 	vmov	s12, r2
10005e14:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10005e18:	ed8d 6b2a 	vstr	d6, [sp, #168]	@ 0xa8
10005e1c:	ee27 6b00 	vmul.f64	d6, d7, d0
10005e20:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10005e24:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005e28:	ee06 7b49 	vmls.f64	d7, d6, d9
10005e2c:	ed8d 6b1c 	vstr	d6, [sp, #112]	@ 0x70
10005e30:	ee24 6b00 	vmul.f64	d6, d4, d0
10005e34:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10005e38:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005e3c:	ee06 4b49 	vmls.f64	d4, d6, d9
10005e40:	ed8d 6b26 	vstr	d6, [sp, #152]	@ 0x98
10005e44:	ee25 6b08 	vmul.f64	d6, d5, d8
10005e48:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10005e4c:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005e50:	ed8d 5b1e 	vstr	d5, [sp, #120]	@ 0x78
10005e54:	ee04 3b0a 	vmla.f64	d3, d4, d10
10005e58:	ee06 5b42 	vmls.f64	d5, d6, d2
10005e5c:	ee07 6b0a 	vmla.f64	d6, d7, d10
10005e60:	9b03      	ldr	r3, [sp, #12]
10005e62:	ed8d 3b24 	vstr	d3, [sp, #144]	@ 0x90
10005e66:	445b      	add	r3, fp
10005e68:	459b      	cmp	fp, r3
10005e6a:	ed8d 5b18 	vstr	d5, [sp, #96]	@ 0x60
10005e6e:	ed8d 6b1a 	vstr	d6, [sp, #104]	@ 0x68
10005e72:	f080 81a4 	bcs.w	100061be <fndsa_vect_iFFT_fp64_exact+0x536>
10005e76:	4601      	mov	r1, r0
10005e78:	4646      	mov	r6, r8
10005e7a:	eb09 0508 	add.w	r5, r9, r8
10005e7e:	9000      	str	r0, [sp, #0]
10005e80:	eb09 0400 	add.w	r4, r9, r0
10005e84:	e026      	b.n	10005ed4 <fndsa_vect_iFFT_fp64_exact+0x24c>
10005e86:	bf00      	nop
10005e88:	00000000 	.word	0x00000000
10005e8c:	41f00000 	.word	0x41f00000
10005e90:	00000000 	.word	0x00000000
10005e94:	3df00000 	.word	0x3df00000
	...
10005ea4:	41e00000 	.word	0x41e00000
10005ea8:	00000000 	.word	0x00000000
10005eac:	3ef00000 	.word	0x3ef00000
10005eb0:	00000000 	.word	0x00000000
10005eb4:	3e700000 	.word	0x3e700000
10005eb8:	00000000 	.word	0x00000000
10005ebc:	40f00000 	.word	0x40f00000
10005ec0:	00000000 	.word	0x00000000
10005ec4:	40700000 	.word	0x40700000
10005ec8:	00000000 	.word	0x00000000
10005ecc:	41700000 	.word	0x41700000
10005ed0:	300039a0 	.word	0x300039a0
10005ed4:	ed91 3b02 	vldr	d3, [r1, #8]
10005ed8:	ed96 6b02 	vldr	d6, [r6, #8]
10005edc:	ed95 5b02 	vldr	d5, [r5, #8]
10005ee0:	ed94 2b02 	vldr	d2, [r4, #8]
10005ee4:	ee33 7b0d 	vadd.f64	d7, d3, d13
10005ee8:	ee33 3b06 	vadd.f64	d3, d3, d6
10005eec:	ee37 7b46 	vsub.f64	d7, d7, d6
10005ef0:	ee35 6b02 	vadd.f64	d6, d5, d2
10005ef4:	ee26 0b0c 	vmul.f64	d0, d6, d12
10005ef8:	ee32 2b0d 	vadd.f64	d2, d2, d13
10005efc:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10005f00:	ee32 2b45 	vsub.f64	d2, d2, d5
10005f04:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10005f08:	ee27 5b0c 	vmul.f64	d5, d7, d12
10005f0c:	ed91 4b00 	vldr	d4, [r1]
10005f10:	ee23 1b0c 	vmul.f64	d1, d3, d12
10005f14:	ee00 6b4d 	vmls.f64	d6, d0, d13
10005f18:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10005f1c:	ed96 9b00 	vldr	d9, [r6]
10005f20:	ee36 8b0b 	vadd.f64	d8, d6, d11
10005f24:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10005f28:	ee34 6b0d 	vadd.f64	d6, d4, d13
10005f2c:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10005f30:	ee05 7b4d 	vmls.f64	d7, d5, d13
10005f34:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10005f38:	ee39 4b04 	vadd.f64	d4, d9, d4
10005f3c:	ee36 6b49 	vsub.f64	d6, d6, d9
10005f40:	ee34 4b01 	vadd.f64	d4, d4, d1
10005f44:	ee37 9b0b 	vadd.f64	d9, d7, d11
10005f48:	ee01 3b4d 	vmls.f64	d3, d1, d13
10005f4c:	ed94 7b00 	vldr	d7, [r4]
10005f50:	ee22 1b0c 	vmul.f64	d1, d2, d12
10005f54:	ee36 6b4b 	vsub.f64	d6, d6, d11
10005f58:	ed95 ab00 	vldr	d10, [r5]
10005f5c:	ee36 6b05 	vadd.f64	d6, d6, d5
10005f60:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10005f64:	ed94 5b00 	vldr	d5, [r4]
10005f68:	ee37 7b0d 	vadd.f64	d7, d7, d13
10005f6c:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10005f70:	ee35 5b0a 	vadd.f64	d5, d5, d10
10005f74:	ee37 7b4a 	vsub.f64	d7, d7, d10
10005f78:	ee35 5b00 	vadd.f64	d5, d5, d0
10005f7c:	ee01 2b4d 	vmls.f64	d2, d1, d13
10005f80:	ee37 7b4b 	vsub.f64	d7, d7, d11
10005f84:	ee32 0b0b 	vadd.f64	d0, d2, d11
10005f88:	ee37 7b01 	vadd.f64	d7, d7, d1
10005f8c:	ee25 2b0c 	vmul.f64	d2, d5, d12
10005f90:	ee24 1b0c 	vmul.f64	d1, d4, d12
10005f94:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10005f98:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10005f9c:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10005fa0:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10005fa4:	ee02 5b4d 	vmls.f64	d5, d2, d13
10005fa8:	ee01 4b4d 	vmls.f64	d4, d1, d13
10005fac:	ee27 2b0c 	vmul.f64	d2, d7, d12
10005fb0:	ee26 1b0c 	vmul.f64	d1, d6, d12
10005fb4:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10005fb8:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10005fbc:	ee33 3b0b 	vadd.f64	d3, d3, d11
10005fc0:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10005fc4:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10005fc8:	ee01 6b4d 	vmls.f64	d6, d1, d13
10005fcc:	ee02 7b4d 	vmls.f64	d7, d2, d13
10005fd0:	ee28 1b0c 	vmul.f64	d1, d8, d12
10005fd4:	ee23 2b0c 	vmul.f64	d2, d3, d12
10005fd8:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10005fdc:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10005fe0:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10005fe4:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10005fe8:	ee34 4b0f 	vadd.f64	d4, d4, d15
10005fec:	ee01 8b4d 	vmls.f64	d8, d1, d13
10005ff0:	ee34 4b02 	vadd.f64	d4, d4, d2
10005ff4:	ee02 3b4d 	vmls.f64	d3, d2, d13
10005ff8:	ee35 5b0f 	vadd.f64	d5, d5, d15
10005ffc:	eeb6 2b00 	vmov.f64	d2, #96	@ 0x3f000000  0.5
10006000:	ee35 5b01 	vadd.f64	d5, d5, d1
10006004:	ee23 3b02 	vmul.f64	d3, d3, d2
10006008:	eeb0 1b42 	vmov.f64	d1, d2
1000600c:	ee28 2b02 	vmul.f64	d2, d8, d2
10006010:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006014:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10006018:	eeb8 8b43 	vcvt.f64.u32	d8, s6
1000601c:	eeb8 ab42 	vcvt.f64.u32	d10, s4
10006020:	ee29 3b0c 	vmul.f64	d3, d9, d12
10006024:	ee20 2b0c 	vmul.f64	d2, d0, d12
10006028:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000602c:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10006030:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10006034:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10006038:	ee36 6b0f 	vadd.f64	d6, d6, d15
1000603c:	ee37 7b0f 	vadd.f64	d7, d7, d15
10006040:	ee36 6b03 	vadd.f64	d6, d6, d3
10006044:	ee03 9b4d 	vmls.f64	d9, d3, d13
10006048:	ee02 0b4d 	vmls.f64	d0, d2, d13
1000604c:	eeb0 3b41 	vmov.f64	d3, d1
10006050:	ee37 7b02 	vadd.f64	d7, d7, d2
10006054:	ee24 2b0c 	vmul.f64	d2, d4, d12
10006058:	ee20 0b03 	vmul.f64	d0, d0, d3
1000605c:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10006060:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10006064:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10006068:	eeb8 3b40 	vcvt.f64.u32	d3, s0
1000606c:	ee25 0b0c 	vmul.f64	d0, d5, d12
10006070:	ee02 4b4d 	vmls.f64	d4, d2, d13
10006074:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10006078:	eefc 4bc4 	vcvt.u32.f64	s9, d4
1000607c:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10006080:	ee14 ca90 	vmov	ip, s9
10006084:	ee00 5b4d 	vmls.f64	d5, d0, d13
10006088:	ea4f 72dc 	mov.w	r2, ip, lsr #31
1000608c:	ee04 2a10 	vmov	s8, r2
10006090:	ea4f 025c 	mov.w	r2, ip, lsr #1
10006094:	eefc 5bc5 	vcvt.u32.f64	s11, d5
10006098:	ee05 2a10 	vmov	s10, r2
1000609c:	ee15 3a90 	vmov	r3, s11
100060a0:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
100060a4:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
100060a8:	ee04 5b0e 	vmla.f64	d5, d4, d14
100060ac:	f00c 0e01 	and.w	lr, ip, #1
100060b0:	ed81 5b00 	vstr	d5, [r1]
100060b4:	ee05 ea90 	vmov	s11, lr
100060b8:	eeb8 5be5 	vcvt.f64.s32	d5, s11
100060bc:	0fda      	lsrs	r2, r3, #31
100060be:	ea4f 0c53 	mov.w	ip, r3, lsr #1
100060c2:	ee05 8b0e 	vmla.f64	d8, d5, d14
100060c6:	ee04 2a10 	vmov	s8, r2
100060ca:	ee05 ca90 	vmov	s11, ip
100060ce:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
100060d2:	eeb8 5be5 	vcvt.f64.s32	d5, s11
100060d6:	ee04 5b0e 	vmla.f64	d5, d4, d14
100060da:	f003 0301 	and.w	r3, r3, #1
100060de:	ed81 8b02 	vstr	d8, [r1, #8]
100060e2:	ed84 5b00 	vstr	d5, [r4]
100060e6:	ee05 3a90 	vmov	s11, r3
100060ea:	eeb8 5be5 	vcvt.f64.s32	d5, s11
100060ee:	ee05 ab0e 	vmla.f64	d10, d5, d14
100060f2:	ee26 5b0c 	vmul.f64	d5, d6, d12
100060f6:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100060fa:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100060fe:	ee05 6b4d 	vmls.f64	d6, d5, d13
10006102:	ee27 5b0c 	vmul.f64	d5, d7, d12
10006106:	eefc 6bc6 	vcvt.u32.f64	s13, d6
1000610a:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000610e:	ee16 3a90 	vmov	r3, s13
10006112:	eeb8 6b45 	vcvt.f64.u32	d6, s10
10006116:	ee06 7b4d 	vmls.f64	d7, d6, d13
1000611a:	eefc 7bc7 	vcvt.u32.f64	s15, d7
1000611e:	0fda      	lsrs	r2, r3, #31
10006120:	ee05 2a10 	vmov	s10, r2
10006124:	085a      	lsrs	r2, r3, #1
10006126:	f003 0301 	and.w	r3, r3, #1
1000612a:	ee06 3a90 	vmov	s13, r3
1000612e:	ee17 3a90 	vmov	r3, s15
10006132:	ee00 2a10 	vmov	s0, r2
10006136:	0fda      	lsrs	r2, r3, #31
10006138:	ee07 2a10 	vmov	s14, r2
1000613c:	085a      	lsrs	r2, r3, #1
1000613e:	ee02 2a10 	vmov	s4, r2
10006142:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10006146:	ee29 1b01 	vmul.f64	d1, d9, d1
1000614a:	eeb8 2bc2 	vcvt.f64.s32	d2, s4
1000614e:	f003 0301 	and.w	r3, r3, #1
10006152:	ee07 2b0e 	vmla.f64	d2, d7, d14
10006156:	eebc 1bc1 	vcvt.u32.f64	s2, d1
1000615a:	ee07 3a90 	vmov	s15, r3
1000615e:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
10006162:	eeb8 6be6 	vcvt.f64.s32	d6, s13
10006166:	eeb8 7be7 	vcvt.f64.s32	d7, s15
1000616a:	eeb8 1b41 	vcvt.f64.u32	d1, s2
1000616e:	eeb8 0bc0 	vcvt.f64.s32	d0, s0
10006172:	ee06 1b0e 	vmla.f64	d1, d6, d14
10006176:	ee05 0b0e 	vmla.f64	d0, d5, d14
1000617a:	ee07 3b0e 	vmla.f64	d3, d7, d14
1000617e:	ed84 ab02 	vstr	d10, [r4, #8]
10006182:	a80e      	add	r0, sp, #56	@ 0x38
10006184:	f7fe fd54 	bl	10004c30 <fp64e_cmul_prepared>
10006188:	3110      	adds	r1, #16
1000618a:	4588      	cmp	r8, r1
1000618c:	ed86 0b00 	vstr	d0, [r6]
10006190:	ed86 1b02 	vstr	d1, [r6, #8]
10006194:	ed8d 0b06 	vstr	d0, [sp, #24]
10006198:	ed85 2b00 	vstr	d2, [r5]
1000619c:	ed85 3b02 	vstr	d3, [r5, #8]
100061a0:	ed8d 1b08 	vstr	d1, [sp, #32]
100061a4:	ed8d 2b0a 	vstr	d2, [sp, #40]	@ 0x28
100061a8:	ed8d 3b0c 	vstr	d3, [sp, #48]	@ 0x30
100061ac:	f104 0410 	add.w	r4, r4, #16
100061b0:	f106 0610 	add.w	r6, r6, #16
100061b4:	f105 0510 	add.w	r5, r5, #16
100061b8:	f47f ae8c 	bne.w	10005ed4 <fndsa_vect_iFFT_fp64_exact+0x24c>
100061bc:	9800      	ldr	r0, [sp, #0]
100061be:	9b01      	ldr	r3, [sp, #4]
100061c0:	f10a 0a10 	add.w	sl, sl, #16
100061c4:	449b      	add	fp, r3
100061c6:	9b02      	ldr	r3, [sp, #8]
100061c8:	4438      	add	r0, r7
100061ca:	4553      	cmp	r3, sl
100061cc:	44b8      	add	r8, r7
100061ce:	f47f ad8e 	bne.w	10005cee <fndsa_vect_iFFT_fp64_exact+0x66>
100061d2:	9c04      	ldr	r4, [sp, #16]
100061d4:	464a      	mov	r2, r9
100061d6:	3c01      	subs	r4, #1
100061d8:	f8dd e004 	ldr.w	lr, [sp, #4]
100061dc:	9d05      	ldr	r5, [sp, #20]
100061de:	f47f ad69 	bne.w	10005cb4 <fndsa_vect_iFFT_fp64_exact+0x2c>
100061e2:	b02d      	add	sp, #180	@ 0xb4
100061e4:	ecbd 8b10 	vpop	{d8-d15}
100061e8:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
100061ec:	0000      	movs	r0, r0
	...

