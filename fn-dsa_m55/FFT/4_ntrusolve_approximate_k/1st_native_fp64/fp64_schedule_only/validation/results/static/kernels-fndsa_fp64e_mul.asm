10001b10 <fndsa_fp64e_mul>:
10001b10:	ed9f 5b51 	vldr	d5, [pc, #324]	@ 10001c58 <fndsa_fp64e_mul+0x148>
10001b14:	ed2d 8b10 	vpush	{d8-d15}
10001b18:	ee23 7b05 	vmul.f64	d7, d3, d5
10001b1c:	eeb0 9b43 	vmov.f64	d9, d3
10001b20:	eefc 3bc0 	vcvt.u32.f64	s7, d0
10001b24:	ee13 2a90 	vmov	r2, s7
10001b28:	eefc 3bc2 	vcvt.u32.f64	s7, d2
10001b2c:	0fd2      	lsrs	r2, r2, #31
10001b2e:	ee13 3a90 	vmov	r3, s7
10001b32:	ee03 2a90 	vmov	s7, r2
10001b36:	0fdb      	lsrs	r3, r3, #31
10001b38:	ee22 6b05 	vmul.f64	d6, d2, d5
10001b3c:	eeb8 ebe3 	vcvt.f64.s32	d14, s7
10001b40:	ee03 3a90 	vmov	s7, r3
10001b44:	eeb0 8b41 	vmov.f64	d8, d1
10001b48:	eeb8 fbe3 	vcvt.f64.s32	d15, s7
10001b4c:	ee27 3b01 	vmul.f64	d3, d7, d1
10001b50:	ee26 1b01 	vmul.f64	d1, d6, d1
10001b54:	ee20 6b06 	vmul.f64	d6, d0, d6
10001b58:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10001b5c:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10001b60:	ed9f 4b3f 	vldr	d4, [pc, #252]	@ 10001c60 <fndsa_fp64e_mul+0x150>
10001b64:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10001b68:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10001b6c:	ee26 6b44 	vnmul.f64	d6, d6, d4
10001b70:	eea0 6b02 	vfma.f64	d6, d0, d2
10001b74:	ee36 bb04 	vadd.f64	d11, d6, d4
10001b78:	ee23 6b44 	vnmul.f64	d6, d3, d4
10001b7c:	eea8 6b09 	vfma.f64	d6, d8, d9
10001b80:	ee36 6b04 	vadd.f64	d6, d6, d4
10001b84:	ee20 7b07 	vmul.f64	d7, d0, d7
10001b88:	ee26 6b05 	vmul.f64	d6, d6, d5
10001b8c:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10001b90:	eebc cbc6 	vcvt.u32.f64	s24, d6
10001b94:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10001b98:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10001b9c:	ee21 6b44 	vnmul.f64	d6, d1, d4
10001ba0:	eea8 6b02 	vfma.f64	d6, d8, d2
10001ba4:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10001ba8:	ee36 2b04 	vadd.f64	d2, d6, d4
10001bac:	eeb8 6b4c 	vcvt.f64.u32	d6, s24
10001bb0:	eeb7 ab00 	vmov.f64	d10, #112	@ 0x3f800000  1.0
10001bb4:	ee36 6b03 	vadd.f64	d6, d6, d3
10001bb8:	ee27 3b44 	vnmul.f64	d3, d7, d4
10001bbc:	eea0 3b09 	vfma.f64	d3, d0, d9
10001bc0:	ee33 3b04 	vadd.f64	d3, d3, d4
10001bc4:	ee36 cb4a 	vsub.f64	d12, d6, d10
10001bc8:	ee23 0b05 	vmul.f64	d0, d3, d5
10001bcc:	ee22 6b05 	vmul.f64	d6, d2, d5
10001bd0:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10001bd4:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10001bd8:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10001bdc:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10001be0:	ee37 7b00 	vadd.f64	d7, d7, d0
10001be4:	ee06 2b44 	vmls.f64	d2, d6, d4
10001be8:	ee31 6b06 	vadd.f64	d6, d1, d6
10001bec:	ee37 7b4a 	vsub.f64	d7, d7, d10
10001bf0:	ee36 6b4a 	vsub.f64	d6, d6, d10
10001bf4:	ee00 3b44 	vmls.f64	d3, d0, d4
10001bf8:	ee36 7b07 	vadd.f64	d7, d6, d7
10001bfc:	ee3c 1b02 	vadd.f64	d1, d12, d2
10001c00:	ee2b 6b05 	vmul.f64	d6, d11, d5
10001c04:	ee31 1b03 	vadd.f64	d1, d1, d3
10001c08:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10001c0c:	ee21 3b05 	vmul.f64	d3, d1, d5
10001c10:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10001c14:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10001c18:	ee06 bb44 	vmls.f64	d11, d6, d4
10001c1c:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10001c20:	ee3b 0b07 	vadd.f64	d0, d11, d7
10001c24:	ed9f db10 	vldr	d13, [pc, #64]	@ 10001c68 <fndsa_fp64e_mul+0x158>
10001c28:	ee30 0b03 	vadd.f64	d0, d0, d3
10001c2c:	ee30 0b0d 	vadd.f64	d0, d0, d13
10001c30:	ee0e 0b49 	vmls.f64	d0, d14, d9
10001c34:	ee0f 0b48 	vmls.f64	d0, d15, d8
10001c38:	ee20 5b05 	vmul.f64	d5, d0, d5
10001c3c:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10001c40:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10001c44:	ee03 1b44 	vmls.f64	d1, d3, d4
10001c48:	ee05 0b44 	vmls.f64	d0, d5, d4
10001c4c:	b090      	sub	sp, #64	@ 0x40
10001c4e:	b010      	add	sp, #64	@ 0x40
10001c50:	ecbd 8b10 	vpop	{d8-d15}
10001c54:	4770      	bx	lr
10001c56:	bf00      	nop
10001c58:	00000000 	.word	0x00000000
10001c5c:	3df00000 	.word	0x3df00000
10001c60:	00000000 	.word	0x00000000
10001c64:	41f00000 	.word	0x41f00000
10001c68:	00000000 	.word	0x00000000
10001c6c:	42000000 	.word	0x42000000

