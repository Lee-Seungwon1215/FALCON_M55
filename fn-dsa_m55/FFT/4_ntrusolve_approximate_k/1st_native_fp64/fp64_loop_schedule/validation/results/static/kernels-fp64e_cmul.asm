10002a08 <fp64e_cmul>:
10002a08:	ed2d 8b10 	vpush	{d8-d15}
10002a0c:	eeb0 ab46 	vmov.f64	d10, d6
10002a10:	eefc 6bc4 	vcvt.u32.f64	s13, d4
10002a14:	ee16 2a90 	vmov	r2, s13
10002a18:	eefc 6bca 	vcvt.u32.f64	s13, d10
10002a1c:	ee16 3a90 	vmov	r3, s13
10002a20:	eefc 6bc0 	vcvt.u32.f64	s13, d0
10002a24:	ee16 0a90 	vmov	r0, s13
10002a28:	eefc 6bc2 	vcvt.u32.f64	s13, d2
10002a2c:	0fc0      	lsrs	r0, r0, #31
10002a2e:	ee16 1a90 	vmov	r1, s13
10002a32:	ee06 0a90 	vmov	s13, r0
10002a36:	0fc9      	lsrs	r1, r1, #31
10002a38:	eeb0 eb42 	vmov.f64	d14, d2
10002a3c:	eeb8 2be6 	vcvt.f64.s32	d2, s13
10002a40:	ee06 1a90 	vmov	s13, r1
10002a44:	eeb8 6be6 	vcvt.f64.s32	d6, s13
10002a48:	b0c8      	sub	sp, #288	@ 0x120
10002a4a:	0fd2      	lsrs	r2, r2, #31
10002a4c:	ed8d 6b20 	vstr	d6, [sp, #128]	@ 0x80
10002a50:	ee06 2a90 	vmov	s13, r2
10002a54:	0fdb      	lsrs	r3, r3, #31
10002a56:	eeb0 cb44 	vmov.f64	d12, d4
10002a5a:	eeb0 8b47 	vmov.f64	d8, d7
10002a5e:	eeb8 4be6 	vcvt.f64.s32	d4, s13
10002a62:	ee06 3a90 	vmov	s13, r3
10002a66:	ed9f 7bfe 	vldr	d7, [pc, #1016]	@ 10002e60 <fp64e_cmul+0x458>
10002a6a:	eeb0 db40 	vmov.f64	d13, d0
10002a6e:	ee35 9b08 	vadd.f64	d9, d5, d8
10002a72:	eeb8 0be6 	vcvt.f64.s32	d0, s13
10002a76:	eeb0 6b48 	vmov.f64	d6, d8
10002a7a:	ee31 8b03 	vadd.f64	d8, d1, d3
10002a7e:	ed8d 1b00 	vstr	d1, [sp]
10002a82:	ee3d bb0e 	vadd.f64	d11, d13, d14
10002a86:	ee28 1b07 	vmul.f64	d1, d8, d7
10002a8a:	ed8d 2b1a 	vstr	d2, [sp, #104]	@ 0x68
10002a8e:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10002a92:	eeb0 2b4b 	vmov.f64	d2, d11
10002a96:	ee29 bb07 	vmul.f64	d11, d9, d7
10002a9a:	ed9f fbf3 	vldr	d15, [pc, #972]	@ 10002e68 <fp64e_cmul+0x460>
10002a9e:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10002aa2:	eebc bbcb 	vcvt.u32.f64	s22, d11
10002aa6:	ee01 8b4f 	vmls.f64	d8, d1, d15
10002aaa:	ed8d 0b22 	vstr	d0, [sp, #136]	@ 0x88
10002aae:	eeb8 bb4b 	vcvt.f64.u32	d11, s22
10002ab2:	ee3c 0b0a 	vadd.f64	d0, d12, d10
10002ab6:	ed8d 3b02 	vstr	d3, [sp, #8]
10002aba:	ee0b 9b4f 	vmls.f64	d9, d11, d15
10002abe:	ee25 3b07 	vmul.f64	d3, d5, d7
10002ac2:	ed8d 4b1c 	vstr	d4, [sp, #112]	@ 0x70
10002ac6:	ee30 0b0b 	vadd.f64	d0, d0, d11
10002aca:	ee26 4b07 	vmul.f64	d4, d6, d7
10002ace:	ed9d bb00 	vldr	d11, [sp]
10002ad2:	ed8d 8b16 	vstr	d8, [sp, #88]	@ 0x58
10002ad6:	ed9d 8b02 	vldr	d8, [sp, #8]
10002ada:	ed8d 9b04 	vstr	d9, [sp, #16]
10002ade:	ee24 8b08 	vmul.f64	d8, d4, d8
10002ae2:	ee32 9b01 	vadd.f64	d9, d2, d1
10002ae6:	ee24 4b0e 	vmul.f64	d4, d4, d14
10002aea:	ee2b 1b03 	vmul.f64	d1, d11, d3
10002aee:	ee2d 3b03 	vmul.f64	d3, d13, d3
10002af2:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10002af6:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10002afa:	ed8d 5b06 	vstr	d5, [sp, #24]
10002afe:	ed8d 6b08 	vstr	d6, [sp, #32]
10002b02:	ee2c 5b07 	vmul.f64	d5, d12, d7
10002b06:	ee2a 6b07 	vmul.f64	d6, d10, d7
10002b0a:	eeb8 2b44 	vcvt.f64.u32	d2, s8
10002b0e:	eefc 3bc8 	vcvt.u32.f64	s7, d8
10002b12:	ed9d 4b02 	vldr	d4, [sp, #8]
10002b16:	eeb8 8b43 	vcvt.f64.u32	d8, s6
10002b1a:	ee26 4b04 	vmul.f64	d4, d6, d4
10002b1e:	ed8d 8b10 	vstr	d8, [sp, #64]	@ 0x40
10002b22:	ee2b 8b05 	vmul.f64	d8, d11, d5
10002b26:	ee2d 5b05 	vmul.f64	d5, d13, d5
10002b2a:	ee26 6b0e 	vmul.f64	d6, d6, d14
10002b2e:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10002b32:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10002b36:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10002b3a:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10002b3e:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10002b42:	ed8d 4b0c 	vstr	d4, [sp, #48]	@ 0x30
10002b46:	ee25 5b4f 	vnmul.f64	d5, d5, d15
10002b4a:	eead 5b0c 	vfma.f64	d5, d13, d12
10002b4e:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10002b52:	ee35 4b0f 	vadd.f64	d4, d5, d15
10002b56:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10002b5a:	ee20 5b07 	vmul.f64	d5, d0, d7
10002b5e:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10002b62:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10002b66:	ee26 6b4f 	vnmul.f64	d6, d6, d15
10002b6a:	eeae 6b0a 	vfma.f64	d6, d14, d10
10002b6e:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10002b72:	ee36 6b0f 	vadd.f64	d6, d6, d15
10002b76:	eeb8 bb48 	vcvt.f64.u32	d11, s16
10002b7a:	ed8d 4b14 	vstr	d4, [sp, #80]	@ 0x50
10002b7e:	ed9d 8b06 	vldr	d8, [sp, #24]
10002b82:	ed9d 4b00 	vldr	d4, [sp]
10002b86:	ed8d 6b12 	vstr	d6, [sp, #72]	@ 0x48
10002b8a:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10002b8e:	ee21 6b4f 	vnmul.f64	d6, d1, d15
10002b92:	eea4 6b08 	vfma.f64	d6, d4, d8
10002b96:	ee36 6b0f 	vadd.f64	d6, d6, d15
10002b9a:	ee05 0b4f 	vmls.f64	d0, d5, d15
10002b9e:	ee26 6b07 	vmul.f64	d6, d6, d7
10002ba2:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10002ba6:	eefc 6bc0 	vcvt.u32.f64	s13, d0
10002baa:	ee16 3a90 	vmov	r3, s13
10002bae:	0fdb      	lsrs	r3, r3, #31
10002bb0:	ee05 3a90 	vmov	s11, r3
10002bb4:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10002bb8:	ed8d 0b0a 	vstr	d0, [sp, #40]	@ 0x28
10002bbc:	ee36 6b01 	vadd.f64	d6, d6, d1
10002bc0:	eeb7 0b00 	vmov.f64	d0, #112	@ 0x3f800000  1.0
10002bc4:	eeb8 1be5 	vcvt.f64.s32	d1, s11
10002bc8:	eeb8 3b63 	vcvt.f64.u32	d3, s7
10002bcc:	ed8d 1b26 	vstr	d1, [sp, #152]	@ 0x98
10002bd0:	ee36 1b40 	vsub.f64	d1, d6, d0
10002bd4:	ed9d 8b02 	vldr	d8, [sp, #8]
10002bd8:	ee29 5b07 	vmul.f64	d5, d9, d7
10002bdc:	ed8d 1b18 	vstr	d1, [sp, #96]	@ 0x60
10002be0:	ee23 6b4f 	vnmul.f64	d6, d3, d15
10002be4:	ed9d 1b08 	vldr	d1, [sp, #32]
10002be8:	eea8 6b01 	vfma.f64	d6, d8, d1
10002bec:	ee36 6b0f 	vadd.f64	d6, d6, d15
10002bf0:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10002bf4:	ee26 6b07 	vmul.f64	d6, d6, d7
10002bf8:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10002bfc:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10002c00:	ee05 9b4f 	vmls.f64	d9, d5, d15
10002c04:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10002c08:	eeb0 5b49 	vmov.f64	d5, d9
10002c0c:	ee36 6b03 	vadd.f64	d6, d6, d3
10002c10:	ee36 3b40 	vsub.f64	d3, d6, d0
10002c14:	eefc 6bc5 	vcvt.u32.f64	s13, d5
10002c18:	ee16 3a90 	vmov	r3, s13
10002c1c:	0fdb      	lsrs	r3, r3, #31
10002c1e:	ee06 3a90 	vmov	s13, r3
10002c22:	ed8d 3b1e 	vstr	d3, [sp, #120]	@ 0x78
10002c26:	ee2b 1b4f 	vnmul.f64	d1, d11, d15
10002c2a:	eea4 1b0c 	vfma.f64	d1, d4, d12
10002c2e:	ed9d 3b0c 	vldr	d3, [sp, #48]	@ 0x30
10002c32:	eeb0 cb45 	vmov.f64	d12, d5
10002c36:	eeb8 5be6 	vcvt.f64.s32	d5, s13
10002c3a:	ed9d 9b04 	vldr	d9, [sp, #16]
10002c3e:	ed9d 6b0a 	vldr	d6, [sp, #40]	@ 0x28
10002c42:	ed8d 5b24 	vstr	d5, [sp, #144]	@ 0x90
10002c46:	ee23 3b4f 	vnmul.f64	d3, d3, d15
10002c4a:	eea8 3b0a 	vfma.f64	d3, d8, d10
10002c4e:	ed9d ab10 	vldr	d10, [sp, #64]	@ 0x40
10002c52:	ee26 4b07 	vmul.f64	d4, d6, d7
10002c56:	ee29 0b07 	vmul.f64	d0, d9, d7
10002c5a:	ee2a 6b4f 	vnmul.f64	d6, d10, d15
10002c5e:	ed9d 5b06 	vldr	d5, [sp, #24]
10002c62:	eead 6b05 	vfma.f64	d6, d13, d5
10002c66:	ee22 5b4f 	vnmul.f64	d5, d2, d15
10002c6a:	ed9d db08 	vldr	d13, [sp, #32]
10002c6e:	eeae 5b0d 	vfma.f64	d5, d14, d13
10002c72:	ed9d eb16 	vldr	d14, [sp, #88]	@ 0x58
10002c76:	ee20 9b0e 	vmul.f64	d9, d0, d14
10002c7a:	ee20 0b0c 	vmul.f64	d0, d0, d12
10002c7e:	ee31 1b0f 	vadd.f64	d1, d1, d15
10002c82:	ee33 3b0f 	vadd.f64	d3, d3, d15
10002c86:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10002c8a:	ee21 8b07 	vmul.f64	d8, d1, d7
10002c8e:	eeb8 db40 	vcvt.f64.u32	d13, s0
10002c92:	ee23 0b07 	vmul.f64	d0, d3, d7
10002c96:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10002c9a:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10002c9e:	ed9d ab0c 	vldr	d10, [sp, #48]	@ 0x30
10002ca2:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10002ca6:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10002caa:	ee36 6b0f 	vadd.f64	d6, d6, d15
10002cae:	ee08 1b4f 	vmls.f64	d1, d8, d15
10002cb2:	ee00 3b4f 	vmls.f64	d3, d0, d15
10002cb6:	ee3b 8b08 	vadd.f64	d8, d11, d8
10002cba:	ee3a 0b00 	vadd.f64	d0, d10, d0
10002cbe:	ed9d bb18 	vldr	d11, [sp, #96]	@ 0x60
10002cc2:	ed9d ab1e 	vldr	d10, [sp, #120]	@ 0x78
10002cc6:	ee3b 1b01 	vadd.f64	d1, d11, d1
10002cca:	ee3a 3b03 	vadd.f64	d3, d10, d3
10002cce:	ee26 bb07 	vmul.f64	d11, d6, d7
10002cd2:	ee24 ab0e 	vmul.f64	d10, d4, d14
10002cd6:	ed8d 2b0e 	vstr	d2, [sp, #56]	@ 0x38
10002cda:	eefc abca 	vcvt.u32.f64	s21, d10
10002cde:	eeb7 2b00 	vmov.f64	d2, #112	@ 0x3f800000  1.0
10002ce2:	eebc abcb 	vcvt.u32.f64	s20, d11
10002ce6:	ee38 8b42 	vsub.f64	d8, d8, d2
10002cea:	eeb8 bb6a 	vcvt.f64.u32	d11, s21
10002cee:	ed8d 3b16 	vstr	d3, [sp, #88]	@ 0x58
10002cf2:	ee30 0b42 	vsub.f64	d0, d0, d2
10002cf6:	eeb0 3b42 	vmov.f64	d3, d2
10002cfa:	ee24 4b0c 	vmul.f64	d4, d4, d12
10002cfe:	ed9d 2b10 	vldr	d2, [sp, #64]	@ 0x40
10002d02:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10002d06:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10002d0a:	ee0a 6b4f 	vmls.f64	d6, d10, d15
10002d0e:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10002d12:	ee32 ab0a 	vadd.f64	d10, d2, d10
10002d16:	ee35 5b0f 	vadd.f64	d5, d5, d15
10002d1a:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10002d1e:	ee3a ab43 	vsub.f64	d10, d10, d3
10002d22:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10002d26:	ed9d 3b0a 	vldr	d3, [sp, #40]	@ 0x28
10002d2a:	ee31 6b06 	vadd.f64	d6, d1, d6
10002d2e:	ee38 ab0a 	vadd.f64	d10, d8, d10
10002d32:	ee25 1b07 	vmul.f64	d1, d5, d7
10002d36:	ed8d cb0c 	vstr	d12, [sp, #48]	@ 0x30
10002d3a:	ed9d 8b04 	vldr	d8, [sp, #16]
10002d3e:	ee24 4b4f 	vnmul.f64	d4, d4, d15
10002d42:	eeac 4b03 	vfma.f64	d4, d12, d3
10002d46:	ee34 cb0f 	vadd.f64	d12, d4, d15
10002d4a:	ee29 4b4f 	vnmul.f64	d4, d9, d15
10002d4e:	eeae 4b08 	vfma.f64	d4, d14, d8
10002d52:	ee34 4b0f 	vadd.f64	d4, d4, d15
10002d56:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10002d5a:	ee24 4b07 	vmul.f64	d4, d4, d7
10002d5e:	ed9d 2b0e 	vldr	d2, [sp, #56]	@ 0x38
10002d62:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10002d66:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10002d6a:	ee01 5b4f 	vmls.f64	d5, d1, d15
10002d6e:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10002d72:	ee32 1b01 	vadd.f64	d1, d2, d1
10002d76:	eeb7 2b00 	vmov.f64	d2, #112	@ 0x3f800000  1.0
10002d7a:	ee34 9b09 	vadd.f64	d9, d4, d9
10002d7e:	ee31 1b42 	vsub.f64	d1, d1, d2
10002d82:	ed9d 4b14 	vldr	d4, [sp, #80]	@ 0x50
10002d86:	ed9d 8b16 	vldr	d8, [sp, #88]	@ 0x58
10002d8a:	ee30 1b01 	vadd.f64	d1, d0, d1
10002d8e:	ee39 9b42 	vsub.f64	d9, d9, d2
10002d92:	ee24 0b07 	vmul.f64	d0, d4, d7
10002d96:	ed9d 2b12 	vldr	d2, [sp, #72]	@ 0x48
10002d9a:	ee38 5b05 	vadd.f64	d5, d8, d5
10002d9e:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10002da2:	ee2b 8b4f 	vnmul.f64	d8, d11, d15
10002da6:	eeae 8b03 	vfma.f64	d8, d14, d3
10002daa:	ee22 3b07 	vmul.f64	d3, d2, d7
10002dae:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10002db2:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10002db6:	ee00 4b4f 	vmls.f64	d4, d0, d15
10002dba:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10002dbe:	eeb0 0b42 	vmov.f64	d0, d2
10002dc2:	ee38 8b0f 	vadd.f64	d8, d8, d15
10002dc6:	ee03 0b4f 	vmls.f64	d0, d3, d15
10002dca:	ee34 4b0a 	vadd.f64	d4, d4, d10
10002dce:	ee2d 3b4f 	vnmul.f64	d3, d13, d15
10002dd2:	ed9d ab04 	vldr	d10, [sp, #16]
10002dd6:	ee30 0b01 	vadd.f64	d0, d0, d1
10002dda:	ed9d 1b0c 	vldr	d1, [sp, #48]	@ 0x30
10002dde:	eea1 3b0a 	vfma.f64	d3, d1, d10
10002de2:	ee28 1b07 	vmul.f64	d1, d8, d7
10002de6:	ee26 ab07 	vmul.f64	d10, d6, d7
10002dea:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10002dee:	eebc abca 	vcvt.u32.f64	s20, d10
10002df2:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10002df6:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10002dfa:	ee01 8b4f 	vmls.f64	d8, d1, d15
10002dfe:	eeb7 2b00 	vmov.f64	d2, #112	@ 0x3f800000  1.0
10002e02:	ee39 8b08 	vadd.f64	d8, d9, d8
10002e06:	ee3b 1b01 	vadd.f64	d1, d11, d1
10002e0a:	ee34 4b0a 	vadd.f64	d4, d4, d10
10002e0e:	ed9f 9b18 	vldr	d9, [pc, #96]	@ 10002e70 <fp64e_cmul+0x468>
10002e12:	ee31 1b42 	vsub.f64	d1, d1, d2
10002e16:	ed9d bb06 	vldr	d11, [sp, #24]
10002e1a:	ed9d 2b1a 	vldr	d2, [sp, #104]	@ 0x68
10002e1e:	ee34 4b09 	vadd.f64	d4, d4, d9
10002e22:	ed9d 9b00 	vldr	d9, [sp]
10002e26:	ee02 4b4b 	vmls.f64	d4, d2, d11
10002e2a:	ed9d 2b1c 	vldr	d2, [sp, #112]	@ 0x70
10002e2e:	ee33 3b0f 	vadd.f64	d3, d3, d15
10002e32:	ee02 4b49 	vmls.f64	d4, d2, d9
10002e36:	ee25 9b07 	vmul.f64	d9, d5, d7
10002e3a:	ee0a 6b4f 	vmls.f64	d6, d10, d15
10002e3e:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10002e42:	ee23 ab07 	vmul.f64	d10, d3, d7
10002e46:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10002e4a:	eebc abca 	vcvt.u32.f64	s20, d10
10002e4e:	ee09 5b4f 	vmls.f64	d5, d9, d15
10002e52:	ee30 0b09 	vadd.f64	d0, d0, d9
10002e56:	eeb8 9b4a 	vcvt.f64.u32	d9, s20
10002e5a:	e00d      	b.n	10002e78 <fp64e_cmul+0x470>
10002e5c:	f3af 8000 	nop.w
10002e60:	00000000 	.word	0x00000000
10002e64:	3df00000 	.word	0x3df00000
10002e68:	00000000 	.word	0x00000000
10002e6c:	41f00000 	.word	0x41f00000
10002e70:	00000000 	.word	0x00000000
10002e74:	42000000 	.word	0x42000000
10002e78:	ee09 3b4f 	vmls.f64	d3, d9, d15
10002e7c:	ee3d 9b09 	vadd.f64	d9, d13, d9
10002e80:	eeb7 db00 	vmov.f64	d13, #112	@ 0x3f800000  1.0
10002e84:	ee39 9b4d 	vsub.f64	d9, d9, d13
10002e88:	ee31 9b09 	vadd.f64	d9, d1, d9
10002e8c:	ee2c 1b07 	vmul.f64	d1, d12, d7
10002e90:	ee38 3b03 	vadd.f64	d3, d8, d3
10002e94:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10002e98:	ee23 8b07 	vmul.f64	d8, d3, d7
10002e9c:	ed1f bb0c 	vldr	d11, [pc, #-48]	@ 10002e70 <fp64e_cmul+0x468>
10002ea0:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10002ea4:	ed9d 2b20 	vldr	d2, [sp, #128]	@ 0x80
10002ea8:	ee01 cb4f 	vmls.f64	d12, d1, d15
10002eac:	ee30 0b0b 	vadd.f64	d0, d0, d11
10002eb0:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10002eb4:	ed9d bb08 	vldr	d11, [sp, #32]
10002eb8:	ed9d ab02 	vldr	d10, [sp, #8]
10002ebc:	ee02 0b4b 	vmls.f64	d0, d2, d11
10002ec0:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10002ec4:	ed9d 2b22 	vldr	d2, [sp, #136]	@ 0x88
10002ec8:	ee3c cb09 	vadd.f64	d12, d12, d9
10002ecc:	ee02 0b4a 	vmls.f64	d0, d2, d10
10002ed0:	ee08 3b4f 	vmls.f64	d3, d8, d15
10002ed4:	ee3c cb08 	vadd.f64	d12, d12, d8
10002ed8:	ee24 8b07 	vmul.f64	d8, d4, d7
10002edc:	ee20 1b07 	vmul.f64	d1, d0, d7
10002ee0:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10002ee4:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10002ee8:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10002eec:	ed1f bb20 	vldr	d11, [pc, #-128]	@ 10002e70 <fp64e_cmul+0x468>
10002ef0:	ee08 4b4f 	vmls.f64	d4, d8, d15
10002ef4:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10002ef8:	ee35 8b06 	vadd.f64	d8, d5, d6
10002efc:	ee36 6b0f 	vadd.f64	d6, d6, d15
10002f00:	ee01 0b4f 	vmls.f64	d0, d1, d15
10002f04:	ee3c cb0b 	vadd.f64	d12, d12, d11
10002f08:	ee36 1b45 	vsub.f64	d1, d6, d5
10002f0c:	ed9d 9b24 	vldr	d9, [sp, #144]	@ 0x90
10002f10:	ee28 5b07 	vmul.f64	d5, d8, d7
10002f14:	ed9d ab04 	vldr	d10, [sp, #16]
10002f18:	ed9d 2b26 	vldr	d2, [sp, #152]	@ 0x98
10002f1c:	ee09 cb4a 	vmls.f64	d12, d9, d10
10002f20:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10002f24:	ee02 cb4e 	vmls.f64	d12, d2, d14
10002f28:	ee30 6b04 	vadd.f64	d6, d0, d4
10002f2c:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10002f30:	ee34 4b0f 	vadd.f64	d4, d4, d15
10002f34:	ee36 6b05 	vadd.f64	d6, d6, d5
10002f38:	ee34 0b40 	vsub.f64	d0, d4, d0
10002f3c:	ee2c 4b07 	vmul.f64	d4, d12, d7
10002f40:	ee05 8b4f 	vmls.f64	d8, d5, d15
10002f44:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10002f48:	ee26 5b07 	vmul.f64	d5, d6, d7
10002f4c:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10002f50:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10002f54:	ee04 cb4f 	vmls.f64	d12, d4, d15
10002f58:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10002f5c:	ee3c cb0f 	vadd.f64	d12, d12, d15
10002f60:	ee05 6b4f 	vmls.f64	d6, d5, d15
10002f64:	ee3c cb46 	vsub.f64	d12, d12, d6
10002f68:	ee21 6b07 	vmul.f64	d6, d1, d7
10002f6c:	ee33 3b0f 	vadd.f64	d3, d3, d15
10002f70:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10002f74:	ee33 3b48 	vsub.f64	d3, d3, d8
10002f78:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10002f7c:	ee30 0b4d 	vsub.f64	d0, d0, d13
10002f80:	ee06 1b4f 	vmls.f64	d1, d6, d15
10002f84:	ee30 0b06 	vadd.f64	d0, d0, d6
10002f88:	ee23 6b07 	vmul.f64	d6, d3, d7
10002f8c:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10002f90:	ee3c 2b4d 	vsub.f64	d2, d12, d13
10002f94:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10002f98:	ee32 2b06 	vadd.f64	d2, d2, d6
10002f9c:	ee06 3b4f 	vmls.f64	d3, d6, d15
10002fa0:	ee20 6b07 	vmul.f64	d6, d0, d7
10002fa4:	ee22 7b07 	vmul.f64	d7, d2, d7
10002fa8:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10002fac:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10002fb0:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10002fb4:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10002fb8:	ee06 0b4f 	vmls.f64	d0, d6, d15
10002fbc:	ee07 2b4f 	vmls.f64	d2, d7, d15
10002fc0:	b048      	add	sp, #288	@ 0x120
10002fc2:	ecbd 8b10 	vpop	{d8-d15}
10002fc6:	4770      	bx	lr

