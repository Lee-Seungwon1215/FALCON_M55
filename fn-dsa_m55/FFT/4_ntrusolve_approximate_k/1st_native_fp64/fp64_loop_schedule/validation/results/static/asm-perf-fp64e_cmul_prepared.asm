10007b88 <fp64e_cmul_prepared>:
10007b88:	eefc 6bc0 	vcvt.u32.f64	s13, d0
10007b8c:	ee16 2a90 	vmov	r2, s13
10007b90:	eefc 6bc2 	vcvt.u32.f64	s13, d2
10007b94:	0fd2      	lsrs	r2, r2, #31
10007b96:	ee16 3a90 	vmov	r3, s13
10007b9a:	ee06 2a90 	vmov	s13, r2
10007b9e:	ed2d 8b10 	vpush	{d8-d15}
10007ba2:	eeb8 6be6 	vcvt.f64.s32	d6, s13
10007ba6:	b0b4      	sub	sp, #208	@ 0xd0
10007ba8:	0fdb      	lsrs	r3, r3, #31
10007baa:	ed8d 6b14 	vstr	d6, [sp, #80]	@ 0x50
10007bae:	ee06 3a90 	vmov	s13, r3
10007bb2:	eeb0 fb43 	vmov.f64	d15, d3
10007bb6:	eeb0 db41 	vmov.f64	d13, d1
10007bba:	ed90 3b06 	vldr	d3, [r0, #24]
10007bbe:	eeb8 5be6 	vcvt.f64.s32	d5, s13
10007bc2:	ee31 eb0f 	vadd.f64	d14, d1, d15
10007bc6:	ed8d 5b18 	vstr	d5, [sp, #96]	@ 0x60
10007bca:	ed9f 5bff 	vldr	d5, [pc, #1020]	@ 10007fc8 <fp64e_cmul_prepared+0x440>
10007bce:	ed90 1b10 	vldr	d1, [r0, #64]	@ 0x40
10007bd2:	ee2d 9b03 	vmul.f64	d9, d13, d3
10007bd6:	ee20 3b03 	vmul.f64	d3, d0, d3
10007bda:	ee2e 8b05 	vmul.f64	d8, d14, d5
10007bde:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10007be2:	eefc 3bc8 	vcvt.u32.f64	s7, d8
10007be6:	eeb8 8b43 	vcvt.f64.u32	d8, s6
10007bea:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10007bee:	ed8d 8b0a 	vstr	d8, [sp, #40]	@ 0x28
10007bf2:	ee2f 8b01 	vmul.f64	d8, d15, d1
10007bf6:	ed90 6b0e 	vldr	d6, [r0, #56]	@ 0x38
10007bfa:	ed90 4b04 	vldr	d4, [r0, #16]
10007bfe:	ee22 1b01 	vmul.f64	d1, d2, d1
10007c02:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10007c06:	eeb8 ab41 	vcvt.f64.u32	d10, s2
10007c0a:	ed8d ab08 	vstr	d10, [sp, #32]
10007c0e:	ee2f ab06 	vmul.f64	d10, d15, d6
10007c12:	ed9f 7bef 	vldr	d7, [pc, #956]	@ 10007fd0 <fp64e_cmul_prepared+0x448>
10007c16:	eebc abca 	vcvt.u32.f64	s20, d10
10007c1a:	ee2d 1b04 	vmul.f64	d1, d13, d4
10007c1e:	eeb8 cb4a 	vcvt.f64.u32	d12, s20
10007c22:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10007c26:	eeb8 3b63 	vcvt.f64.u32	d3, s7
10007c2a:	ee30 ab02 	vadd.f64	d10, d0, d2
10007c2e:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10007c32:	ee3a ab03 	vadd.f64	d10, d10, d3
10007c36:	eeb8 bb41 	vcvt.f64.u32	d11, s2
10007c3a:	ee03 eb47 	vmls.f64	d14, d3, d7
10007c3e:	ee29 1b47 	vnmul.f64	d1, d9, d7
10007c42:	ed90 3b02 	vldr	d3, [r0, #8]
10007c46:	eead 1b03 	vfma.f64	d1, d13, d3
10007c4a:	ee31 1b07 	vadd.f64	d1, d1, d7
10007c4e:	ed8d db04 	vstr	d13, [sp, #16]
10007c52:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10007c56:	ee21 1b05 	vmul.f64	d1, d1, d5
10007c5a:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10007c5e:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10007c62:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10007c66:	ee28 3b47 	vnmul.f64	d3, d8, d7
10007c6a:	ee31 db09 	vadd.f64	d13, d1, d9
10007c6e:	ee2a 1b05 	vmul.f64	d1, d10, d5
10007c72:	ed90 9b0c 	vldr	d9, [r0, #48]	@ 0x30
10007c76:	eeaf 3b09 	vfma.f64	d3, d15, d9
10007c7a:	ee33 3b07 	vadd.f64	d3, d3, d7
10007c7e:	ed8d eb00 	vstr	d14, [sp]
10007c82:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10007c86:	ee23 3b05 	vmul.f64	d3, d3, d5
10007c8a:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10007c8e:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10007c92:	ee01 ab47 	vmls.f64	d10, d1, d7
10007c96:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10007c9a:	ee20 4b04 	vmul.f64	d4, d0, d4
10007c9e:	ee33 eb08 	vadd.f64	d14, d3, d8
10007ca2:	eefc 3bca 	vcvt.u32.f64	s7, d10
10007ca6:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10007caa:	ee13 3a90 	vmov	r3, s7
10007cae:	ee22 6b06 	vmul.f64	d6, d2, d6
10007cb2:	0fdb      	lsrs	r3, r3, #31
10007cb4:	ee03 3a90 	vmov	s7, r3
10007cb8:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007cbc:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10007cc0:	ed90 8b00 	vldr	d8, [r0]
10007cc4:	ed8d ab02 	vstr	d10, [sp, #8]
10007cc8:	ee2b 1b47 	vnmul.f64	d1, d11, d7
10007ccc:	ed9d ab04 	vldr	d10, [sp, #16]
10007cd0:	eeaa 1b08 	vfma.f64	d1, d10, d8
10007cd4:	ee24 4b47 	vnmul.f64	d4, d4, d7
10007cd8:	eea0 4b08 	vfma.f64	d4, d0, d8
10007cdc:	eeb8 3be3 	vcvt.f64.s32	d3, s7
10007ce0:	ee34 4b07 	vadd.f64	d4, d4, d7
10007ce4:	ed9d 8b0a 	vldr	d8, [sp, #40]	@ 0x28
10007ce8:	ed90 ab02 	vldr	d10, [r0, #8]
10007cec:	ed8d 3b1a 	vstr	d3, [sp, #104]	@ 0x68
10007cf0:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10007cf4:	ed8d 4b10 	vstr	d4, [sp, #64]	@ 0x40
10007cf8:	ee2c 3b47 	vnmul.f64	d3, d12, d7
10007cfc:	ed90 4b0a 	vldr	d4, [r0, #40]	@ 0x28
10007d00:	eeaf 3b04 	vfma.f64	d3, d15, d4
10007d04:	ee26 6b47 	vnmul.f64	d6, d6, d7
10007d08:	eea2 6b04 	vfma.f64	d6, d2, d4
10007d0c:	ee28 8b47 	vnmul.f64	d8, d8, d7
10007d10:	eea0 8b0a 	vfma.f64	d8, d0, d10
10007d14:	ee33 4b07 	vadd.f64	d4, d3, d7
10007d18:	ed9d ab08 	vldr	d10, [sp, #32]
10007d1c:	ed90 9b1a 	vldr	d9, [r0, #104]	@ 0x68
10007d20:	ed90 0b0c 	vldr	d0, [r0, #48]	@ 0x30
10007d24:	ee36 3b07 	vadd.f64	d3, d6, d7
10007d28:	ed9d 6b02 	vldr	d6, [sp, #8]
10007d2c:	ed8d 3b0e 	vstr	d3, [sp, #56]	@ 0x38
10007d30:	ee2a 3b47 	vnmul.f64	d3, d10, d7
10007d34:	eea2 3b00 	vfma.f64	d3, d2, d0
10007d38:	ee31 1b07 	vadd.f64	d1, d1, d7
10007d3c:	ed9d 2b00 	vldr	d2, [sp]
10007d40:	ee29 ab02 	vmul.f64	d10, d9, d2
10007d44:	ee29 9b06 	vmul.f64	d9, d9, d6
10007d48:	ee21 0b05 	vmul.f64	d0, d1, d5
10007d4c:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10007d50:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10007d54:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10007d58:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10007d5c:	ed8d 9b0c 	vstr	d9, [sp, #48]	@ 0x30
10007d60:	ee24 9b05 	vmul.f64	d9, d4, d5
10007d64:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10007d68:	ee00 1b47 	vmls.f64	d1, d0, d7
10007d6c:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10007d70:	ee3b 0b00 	vadd.f64	d0, d11, d0
10007d74:	ed8d 1b12 	vstr	d1, [sp, #72]	@ 0x48
10007d78:	eeb0 bb44 	vmov.f64	d11, d4
10007d7c:	ee09 bb47 	vmls.f64	d11, d9, d7
10007d80:	ee38 8b07 	vadd.f64	d8, d8, d7
10007d84:	ed8d bb16 	vstr	d11, [sp, #88]	@ 0x58
10007d88:	ed90 bb18 	vldr	d11, [r0, #96]	@ 0x60
10007d8c:	ed9d 1b0a 	vldr	d1, [sp, #40]	@ 0x28
10007d90:	ee2b 4b02 	vmul.f64	d4, d11, d2
10007d94:	ee28 2b05 	vmul.f64	d2, d8, d5
10007d98:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10007d9c:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10007da0:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10007da4:	ee02 8b47 	vmls.f64	d8, d2, d7
10007da8:	ee31 2b02 	vadd.f64	d2, d1, d2
10007dac:	eeb7 1b00 	vmov.f64	d1, #112	@ 0x3f800000  1.0
10007db0:	ee33 3b07 	vadd.f64	d3, d3, d7
10007db4:	ee2b 6b06 	vmul.f64	d6, d11, d6
10007db8:	ee3c 9b09 	vadd.f64	d9, d12, d9
10007dbc:	ed9d cb12 	vldr	d12, [sp, #72]	@ 0x48
10007dc0:	eeb8 bb44 	vcvt.f64.u32	d11, s8
10007dc4:	ee3d 4b41 	vsub.f64	d4, d13, d1
10007dc8:	ed8d bb06 	vstr	d11, [sp, #24]
10007dcc:	ee23 bb05 	vmul.f64	d11, d3, d5
10007dd0:	ee34 4b0c 	vadd.f64	d4, d4, d12
10007dd4:	eebc bbcb 	vcvt.u32.f64	s22, d11
10007dd8:	ee34 cb08 	vadd.f64	d12, d4, d8
10007ddc:	ed9d 4b16 	vldr	d4, [sp, #88]	@ 0x58
10007de0:	ee3e 8b41 	vsub.f64	d8, d14, d1
10007de4:	eebc abca 	vcvt.u32.f64	s20, d10
10007de8:	ee38 8b04 	vadd.f64	d8, d8, d4
10007dec:	eeb8 4b4b 	vcvt.f64.u32	d4, s22
10007df0:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10007df4:	ee32 2b41 	vsub.f64	d2, d2, d1
10007df8:	ed9d bb00 	vldr	d11, [sp]
10007dfc:	ee04 3b47 	vmls.f64	d3, d4, d7
10007e00:	ee38 8b03 	vadd.f64	d8, d8, d3
10007e04:	ed90 db16 	vldr	d13, [r0, #88]	@ 0x58
10007e08:	ee2a 3b47 	vnmul.f64	d3, d10, d7
10007e0c:	eeab 3b0d 	vfma.f64	d3, d11, d13
10007e10:	ee30 0b41 	vsub.f64	d0, d0, d1
10007e14:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007e18:	ee30 0b02 	vadd.f64	d0, d0, d2
10007e1c:	ed9d 2b08 	vldr	d2, [sp, #32]
10007e20:	ee33 3b07 	vadd.f64	d3, d3, d7
10007e24:	ee32 4b04 	vadd.f64	d4, d2, d4
10007e28:	ed9d 2b06 	vldr	d2, [sp, #24]
10007e2c:	ee23 3b05 	vmul.f64	d3, d3, d5
10007e30:	ee34 4b41 	vsub.f64	d4, d4, d1
10007e34:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10007e38:	ee39 9b41 	vsub.f64	d9, d9, d1
10007e3c:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10007e40:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10007e44:	ee39 9b04 	vadd.f64	d9, d9, d4
10007e48:	ee26 6b47 	vnmul.f64	d6, d6, d7
10007e4c:	ed90 4b14 	vldr	d4, [r0, #80]	@ 0x50
10007e50:	ee22 2b47 	vnmul.f64	d2, d2, d7
10007e54:	eeab 2b04 	vfma.f64	d2, d11, d4
10007e58:	ee33 3b0a 	vadd.f64	d3, d3, d10
10007e5c:	ed9d ab02 	vldr	d10, [sp, #8]
10007e60:	eeaa 6b04 	vfma.f64	d6, d10, d4
10007e64:	ee32 2b07 	vadd.f64	d2, d2, d7
10007e68:	ed9d 4b10 	vldr	d4, [sp, #64]	@ 0x40
10007e6c:	ed9d db0e 	vldr	d13, [sp, #56]	@ 0x38
10007e70:	ed9d eb0c 	vldr	d14, [sp, #48]	@ 0x30
10007e74:	ee24 ab05 	vmul.f64	d10, d4, d5
10007e78:	eebc abca 	vcvt.u32.f64	s20, d10
10007e7c:	ee2d bb05 	vmul.f64	d11, d13, d5
10007e80:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10007e84:	eebc bbcb 	vcvt.u32.f64	s22, d11
10007e88:	ee0a 4b47 	vmls.f64	d4, d10, d7
10007e8c:	eeb8 bb4b 	vcvt.f64.u32	d11, s22
10007e90:	ee34 4b00 	vadd.f64	d4, d4, d0
10007e94:	eeb0 0b4d 	vmov.f64	d0, d13
10007e98:	ee0b 0b47 	vmls.f64	d0, d11, d7
10007e9c:	ed90 bb16 	vldr	d11, [r0, #88]	@ 0x58
10007ea0:	ed9d ab02 	vldr	d10, [sp, #8]
10007ea4:	ee30 0b09 	vadd.f64	d0, d0, d9
10007ea8:	ee2e 9b47 	vnmul.f64	d9, d14, d7
10007eac:	eeaa 9b0b 	vfma.f64	d9, d10, d11
10007eb0:	ee22 ab05 	vmul.f64	d10, d2, d5
10007eb4:	ed9d db06 	vldr	d13, [sp, #24]
10007eb8:	ee33 3b41 	vsub.f64	d3, d3, d1
10007ebc:	eefc bbca 	vcvt.u32.f64	s23, d10
10007ec0:	ee2c ab05 	vmul.f64	d10, d12, d5
10007ec4:	ee39 9b07 	vadd.f64	d9, d9, d7
10007ec8:	eebc bbca 	vcvt.u32.f64	s22, d10
10007ecc:	eeb8 ab6b 	vcvt.f64.u32	d10, s23
10007ed0:	ee0a 2b47 	vmls.f64	d2, d10, d7
10007ed4:	ee3d ab0a 	vadd.f64	d10, d13, d10
10007ed8:	ee33 3b02 	vadd.f64	d3, d3, d2
10007edc:	eeb8 2b4b 	vcvt.f64.u32	d2, s22
10007ee0:	eeb0 bb4c 	vmov.f64	d11, d12
10007ee4:	ee34 4b02 	vadd.f64	d4, d4, d2
10007ee8:	ee02 bb47 	vmls.f64	d11, d2, d7
10007eec:	ee28 2b05 	vmul.f64	d2, d8, d5
10007ef0:	ee29 cb05 	vmul.f64	d12, d9, d5
10007ef4:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10007ef8:	eebc cbcc 	vcvt.u32.f64	s24, d12
10007efc:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10007f00:	ee02 8b47 	vmls.f64	d8, d2, d7
10007f04:	ee30 0b02 	vadd.f64	d0, d0, d2
10007f08:	eeb8 2b4c 	vcvt.f64.u32	d2, s24
10007f0c:	ee02 9b47 	vmls.f64	d9, d2, d7
10007f10:	ee3e 2b02 	vadd.f64	d2, d14, d2
10007f14:	ee33 3b09 	vadd.f64	d3, d3, d9
10007f18:	ed9f 9b2f 	vldr	d9, [pc, #188]	@ 10007fd8 <fp64e_cmul_prepared+0x450>
10007f1c:	ed90 cb02 	vldr	d12, [r0, #8]
10007f20:	ee32 2b41 	vsub.f64	d2, d2, d1
10007f24:	ee3a ab41 	vsub.f64	d10, d10, d1
10007f28:	ee34 4b09 	vadd.f64	d4, d4, d9
10007f2c:	ee3a ab02 	vadd.f64	d10, d10, d2
10007f30:	ed9d 2b14 	vldr	d2, [sp, #80]	@ 0x50
10007f34:	ee36 6b07 	vadd.f64	d6, d6, d7
10007f38:	ee30 0b09 	vadd.f64	d0, d0, d9
10007f3c:	ee02 4b4c 	vmls.f64	d4, d2, d12
10007f40:	ed9d 2b18 	vldr	d2, [sp, #96]	@ 0x60
10007f44:	ed90 cb0c 	vldr	d12, [r0, #48]	@ 0x30
10007f48:	ee02 0b4c 	vmls.f64	d0, d2, d12
10007f4c:	ed90 2b08 	vldr	d2, [r0, #32]
10007f50:	ed9d db04 	vldr	d13, [sp, #16]
10007f54:	ee26 cb05 	vmul.f64	d12, d6, d5
10007f58:	eebc cbcc 	vcvt.u32.f64	s24, d12
10007f5c:	eeb8 cb4c 	vcvt.f64.u32	d12, s24
10007f60:	ee0d 4b42 	vmls.f64	d4, d13, d2
10007f64:	ee0c 6b47 	vmls.f64	d6, d12, d7
10007f68:	ed90 2b12 	vldr	d2, [r0, #72]	@ 0x48
10007f6c:	ee0f 0b42 	vmls.f64	d0, d15, d2
10007f70:	ee36 6b0a 	vadd.f64	d6, d6, d10
10007f74:	ee24 ab05 	vmul.f64	d10, d4, d5
10007f78:	ee23 2b05 	vmul.f64	d2, d3, d5
10007f7c:	eebc abca 	vcvt.u32.f64	s20, d10
10007f80:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10007f84:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10007f88:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10007f8c:	ee0a 4b47 	vmls.f64	d4, d10, d7
10007f90:	ee36 6b02 	vadd.f64	d6, d6, d2
10007f94:	ee20 ab05 	vmul.f64	d10, d0, d5
10007f98:	ee36 6b09 	vadd.f64	d6, d6, d9
10007f9c:	ee02 3b47 	vmls.f64	d3, d2, d7
10007fa0:	ed9d 2b1a 	vldr	d2, [sp, #104]	@ 0x68
10007fa4:	eebc abca 	vcvt.u32.f64	s20, d10
10007fa8:	ed90 9b16 	vldr	d9, [r0, #88]	@ 0x58
10007fac:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10007fb0:	ee02 6b49 	vmls.f64	d6, d2, d9
10007fb4:	ee38 2b0b 	vadd.f64	d2, d8, d11
10007fb8:	ee0a 0b47 	vmls.f64	d0, d10, d7
10007fbc:	ee3b 9b07 	vadd.f64	d9, d11, d7
10007fc0:	ee22 ab05 	vmul.f64	d10, d2, d5
10007fc4:	e00c      	b.n	10007fe0 <fp64e_cmul_prepared+0x458>
10007fc6:	bf00      	nop
10007fc8:	00000000 	.word	0x00000000
10007fcc:	3df00000 	.word	0x3df00000
10007fd0:	00000000 	.word	0x00000000
10007fd4:	41f00000 	.word	0x41f00000
10007fd8:	00000000 	.word	0x00000000
10007fdc:	42000000 	.word	0x42000000
10007fe0:	eebc abca 	vcvt.u32.f64	s20, d10
10007fe4:	ee39 9b48 	vsub.f64	d9, d9, d8
10007fe8:	ed90 8b1c 	vldr	d8, [r0, #112]	@ 0x70
10007fec:	ed9d bb00 	vldr	d11, [sp]
10007ff0:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10007ff4:	ee0b 6b48 	vmls.f64	d6, d11, d8
10007ff8:	ee0a 2b47 	vmls.f64	d2, d10, d7
10007ffc:	ee33 3b07 	vadd.f64	d3, d3, d7
10008000:	ee30 8b04 	vadd.f64	d8, d0, d4
10008004:	ee33 3b42 	vsub.f64	d3, d3, d2
10008008:	ee38 8b0a 	vadd.f64	d8, d8, d10
1000800c:	ee26 2b05 	vmul.f64	d2, d6, d5
10008010:	ee34 4b07 	vadd.f64	d4, d4, d7
10008014:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10008018:	ee34 0b40 	vsub.f64	d0, d4, d0
1000801c:	ee28 4b05 	vmul.f64	d4, d8, d5
10008020:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10008024:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10008028:	ee02 6b47 	vmls.f64	d6, d2, d7
1000802c:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10008030:	ee36 2b07 	vadd.f64	d2, d6, d7
10008034:	ee04 8b47 	vmls.f64	d8, d4, d7
10008038:	ee29 6b05 	vmul.f64	d6, d9, d5
1000803c:	ee23 4b05 	vmul.f64	d4, d3, d5
10008040:	ee32 2b48 	vsub.f64	d2, d2, d8
10008044:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10008048:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000804c:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10008050:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10008054:	ee30 0b41 	vsub.f64	d0, d0, d1
10008058:	ee32 2b41 	vsub.f64	d2, d2, d1
1000805c:	ee30 0b06 	vadd.f64	d0, d0, d6
10008060:	ee32 2b04 	vadd.f64	d2, d2, d4
10008064:	eeb0 1b49 	vmov.f64	d1, d9
10008068:	ee04 3b47 	vmls.f64	d3, d4, d7
1000806c:	ee06 1b47 	vmls.f64	d1, d6, d7
10008070:	ee20 6b05 	vmul.f64	d6, d0, d5
10008074:	ee22 5b05 	vmul.f64	d5, d2, d5
10008078:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000807c:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10008080:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10008084:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10008088:	ee06 0b47 	vmls.f64	d0, d6, d7
1000808c:	ee05 2b47 	vmls.f64	d2, d5, d7
10008090:	b034      	add	sp, #208	@ 0xd0
10008092:	ecbd 8b10 	vpop	{d8-d15}
10008096:	4770      	bx	lr

