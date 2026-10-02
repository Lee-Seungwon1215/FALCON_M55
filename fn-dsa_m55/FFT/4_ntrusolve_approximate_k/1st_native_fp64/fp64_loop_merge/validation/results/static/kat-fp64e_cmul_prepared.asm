10004c30 <fp64e_cmul_prepared>:
10004c30:	eefc 6bc0 	vcvt.u32.f64	s13, d0
10004c34:	ee16 2a90 	vmov	r2, s13
10004c38:	eefc 6bc2 	vcvt.u32.f64	s13, d2
10004c3c:	0fd2      	lsrs	r2, r2, #31
10004c3e:	ee16 3a90 	vmov	r3, s13
10004c42:	ee06 2a90 	vmov	s13, r2
10004c46:	ed2d 8b10 	vpush	{d8-d15}
10004c4a:	eeb8 6be6 	vcvt.f64.s32	d6, s13
10004c4e:	b0b4      	sub	sp, #208	@ 0xd0
10004c50:	0fdb      	lsrs	r3, r3, #31
10004c52:	ed8d 6b14 	vstr	d6, [sp, #80]	@ 0x50
10004c56:	ee06 3a90 	vmov	s13, r3
10004c5a:	eeb0 fb43 	vmov.f64	d15, d3
10004c5e:	eeb0 db41 	vmov.f64	d13, d1
10004c62:	ed90 3b06 	vldr	d3, [r0, #24]
10004c66:	eeb8 5be6 	vcvt.f64.s32	d5, s13
10004c6a:	ee31 eb0f 	vadd.f64	d14, d1, d15
10004c6e:	ee2d 9b03 	vmul.f64	d9, d13, d3
10004c72:	ed8d 5b18 	vstr	d5, [sp, #96]	@ 0x60
10004c76:	ee20 3b03 	vmul.f64	d3, d0, d3
10004c7a:	ed9f 5bfd 	vldr	d5, [pc, #1012]	@ 10005070 <fp64e_cmul_prepared+0x440>
10004c7e:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10004c82:	ee2e 8b05 	vmul.f64	d8, d14, d5
10004c86:	ed90 1b10 	vldr	d1, [r0, #64]	@ 0x40
10004c8a:	eefc 3bc8 	vcvt.u32.f64	s7, d8
10004c8e:	eeb8 8b43 	vcvt.f64.u32	d8, s6
10004c92:	ed8d 8b0a 	vstr	d8, [sp, #40]	@ 0x28
10004c96:	ee2f 8b01 	vmul.f64	d8, d15, d1
10004c9a:	ee22 1b01 	vmul.f64	d1, d2, d1
10004c9e:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10004ca2:	ed90 6b0e 	vldr	d6, [r0, #56]	@ 0x38
10004ca6:	eeb8 ab41 	vcvt.f64.u32	d10, s2
10004caa:	ed90 4b04 	vldr	d4, [r0, #16]
10004cae:	ed8d ab08 	vstr	d10, [sp, #32]
10004cb2:	ee2f ab06 	vmul.f64	d10, d15, d6
10004cb6:	ee2d 1b04 	vmul.f64	d1, d13, d4
10004cba:	eebc abca 	vcvt.u32.f64	s20, d10
10004cbe:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10004cc2:	ed9f 7bed 	vldr	d7, [pc, #948]	@ 10005078 <fp64e_cmul_prepared+0x448>
10004cc6:	eeb8 cb4a 	vcvt.f64.u32	d12, s20
10004cca:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10004cce:	eeb8 3b63 	vcvt.f64.u32	d3, s7
10004cd2:	ee30 ab02 	vadd.f64	d10, d0, d2
10004cd6:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10004cda:	ee03 eb47 	vmls.f64	d14, d3, d7
10004cde:	eeb8 bb41 	vcvt.f64.u32	d11, s2
10004ce2:	ee3a ab03 	vadd.f64	d10, d10, d3
10004ce6:	ee29 1b47 	vnmul.f64	d1, d9, d7
10004cea:	ed90 3b02 	vldr	d3, [r0, #8]
10004cee:	eead 1b03 	vfma.f64	d1, d13, d3
10004cf2:	ee31 1b07 	vadd.f64	d1, d1, d7
10004cf6:	ee21 1b05 	vmul.f64	d1, d1, d5
10004cfa:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10004cfe:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10004d02:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10004d06:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10004d0a:	ed8d db04 	vstr	d13, [sp, #16]
10004d0e:	ee28 3b47 	vnmul.f64	d3, d8, d7
10004d12:	ee31 db09 	vadd.f64	d13, d1, d9
10004d16:	ee2a 1b05 	vmul.f64	d1, d10, d5
10004d1a:	ed90 9b0c 	vldr	d9, [r0, #48]	@ 0x30
10004d1e:	eeaf 3b09 	vfma.f64	d3, d15, d9
10004d22:	ee33 3b07 	vadd.f64	d3, d3, d7
10004d26:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10004d2a:	ee23 3b05 	vmul.f64	d3, d3, d5
10004d2e:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10004d32:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10004d36:	ee01 ab47 	vmls.f64	d10, d1, d7
10004d3a:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10004d3e:	ed8d eb00 	vstr	d14, [sp]
10004d42:	ee33 eb08 	vadd.f64	d14, d3, d8
10004d46:	eefc 3bca 	vcvt.u32.f64	s7, d10
10004d4a:	ee20 4b04 	vmul.f64	d4, d0, d4
10004d4e:	ee13 3a90 	vmov	r3, s7
10004d52:	ee22 6b06 	vmul.f64	d6, d2, d6
10004d56:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10004d5a:	0fdb      	lsrs	r3, r3, #31
10004d5c:	ee03 3a90 	vmov	s7, r3
10004d60:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10004d64:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10004d68:	ed90 8b00 	vldr	d8, [r0]
10004d6c:	ed8d ab02 	vstr	d10, [sp, #8]
10004d70:	ee2b 1b47 	vnmul.f64	d1, d11, d7
10004d74:	ed9d ab04 	vldr	d10, [sp, #16]
10004d78:	eeaa 1b08 	vfma.f64	d1, d10, d8
10004d7c:	ee24 4b47 	vnmul.f64	d4, d4, d7
10004d80:	eea0 4b08 	vfma.f64	d4, d0, d8
10004d84:	eeb8 3be3 	vcvt.f64.s32	d3, s7
10004d88:	ee34 4b07 	vadd.f64	d4, d4, d7
10004d8c:	ed9d 8b0a 	vldr	d8, [sp, #40]	@ 0x28
10004d90:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10004d94:	ed90 ab02 	vldr	d10, [r0, #8]
10004d98:	ed8d 3b1a 	vstr	d3, [sp, #104]	@ 0x68
10004d9c:	ed8d 4b10 	vstr	d4, [sp, #64]	@ 0x40
10004da0:	ee2c 3b47 	vnmul.f64	d3, d12, d7
10004da4:	ed90 4b0a 	vldr	d4, [r0, #40]	@ 0x28
10004da8:	eeaf 3b04 	vfma.f64	d3, d15, d4
10004dac:	ee26 6b47 	vnmul.f64	d6, d6, d7
10004db0:	eea2 6b04 	vfma.f64	d6, d2, d4
10004db4:	ee28 8b47 	vnmul.f64	d8, d8, d7
10004db8:	eea0 8b0a 	vfma.f64	d8, d0, d10
10004dbc:	ee33 4b07 	vadd.f64	d4, d3, d7
10004dc0:	ed9d ab08 	vldr	d10, [sp, #32]
10004dc4:	ee36 3b07 	vadd.f64	d3, d6, d7
10004dc8:	ed90 9b1a 	vldr	d9, [r0, #104]	@ 0x68
10004dcc:	ed90 0b0c 	vldr	d0, [r0, #48]	@ 0x30
10004dd0:	ed9d 6b02 	vldr	d6, [sp, #8]
10004dd4:	ed8d 3b0e 	vstr	d3, [sp, #56]	@ 0x38
10004dd8:	ee2a 3b47 	vnmul.f64	d3, d10, d7
10004ddc:	eea2 3b00 	vfma.f64	d3, d2, d0
10004de0:	ed9d 2b00 	vldr	d2, [sp]
10004de4:	ee29 ab02 	vmul.f64	d10, d9, d2
10004de8:	ee29 9b06 	vmul.f64	d9, d9, d6
10004dec:	ee31 1b07 	vadd.f64	d1, d1, d7
10004df0:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10004df4:	ee21 0b05 	vmul.f64	d0, d1, d5
10004df8:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10004dfc:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10004e00:	ed8d 9b0c 	vstr	d9, [sp, #48]	@ 0x30
10004e04:	ee24 9b05 	vmul.f64	d9, d4, d5
10004e08:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10004e0c:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10004e10:	ee00 1b47 	vmls.f64	d1, d0, d7
10004e14:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10004e18:	ee3b 0b00 	vadd.f64	d0, d11, d0
10004e1c:	eeb0 bb44 	vmov.f64	d11, d4
10004e20:	ee09 bb47 	vmls.f64	d11, d9, d7
10004e24:	ee38 8b07 	vadd.f64	d8, d8, d7
10004e28:	ed8d 1b12 	vstr	d1, [sp, #72]	@ 0x48
10004e2c:	ed8d bb16 	vstr	d11, [sp, #88]	@ 0x58
10004e30:	ed90 bb18 	vldr	d11, [r0, #96]	@ 0x60
10004e34:	ee2b 4b02 	vmul.f64	d4, d11, d2
10004e38:	ee28 2b05 	vmul.f64	d2, d8, d5
10004e3c:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10004e40:	ed9d 1b0a 	vldr	d1, [sp, #40]	@ 0x28
10004e44:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10004e48:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10004e4c:	ee02 8b47 	vmls.f64	d8, d2, d7
10004e50:	ee31 2b02 	vadd.f64	d2, d1, d2
10004e54:	eeb7 1b00 	vmov.f64	d1, #112	@ 0x3f800000  1.0
10004e58:	ee33 3b07 	vadd.f64	d3, d3, d7
10004e5c:	ee2b 6b06 	vmul.f64	d6, d11, d6
10004e60:	ee3c 9b09 	vadd.f64	d9, d12, d9
10004e64:	eeb8 bb44 	vcvt.f64.u32	d11, s8
10004e68:	ed9d cb12 	vldr	d12, [sp, #72]	@ 0x48
10004e6c:	ee3d 4b41 	vsub.f64	d4, d13, d1
10004e70:	ed8d bb06 	vstr	d11, [sp, #24]
10004e74:	ee34 4b0c 	vadd.f64	d4, d4, d12
10004e78:	ee23 bb05 	vmul.f64	d11, d3, d5
10004e7c:	ee34 cb08 	vadd.f64	d12, d4, d8
10004e80:	eebc bbcb 	vcvt.u32.f64	s22, d11
10004e84:	ee3e 8b41 	vsub.f64	d8, d14, d1
10004e88:	ed9d 4b16 	vldr	d4, [sp, #88]	@ 0x58
10004e8c:	eebc abca 	vcvt.u32.f64	s20, d10
10004e90:	ee38 8b04 	vadd.f64	d8, d8, d4
10004e94:	eeb8 4b4b 	vcvt.f64.u32	d4, s22
10004e98:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10004e9c:	ee04 3b47 	vmls.f64	d3, d4, d7
10004ea0:	ed9d bb00 	vldr	d11, [sp]
10004ea4:	ee32 2b41 	vsub.f64	d2, d2, d1
10004ea8:	ee38 8b03 	vadd.f64	d8, d8, d3
10004eac:	ed90 db16 	vldr	d13, [r0, #88]	@ 0x58
10004eb0:	ee2a 3b47 	vnmul.f64	d3, d10, d7
10004eb4:	eeab 3b0d 	vfma.f64	d3, d11, d13
10004eb8:	ee30 0b41 	vsub.f64	d0, d0, d1
10004ebc:	ee33 3b07 	vadd.f64	d3, d3, d7
10004ec0:	ee30 0b02 	vadd.f64	d0, d0, d2
10004ec4:	ee23 3b05 	vmul.f64	d3, d3, d5
10004ec8:	ed9d 2b08 	vldr	d2, [sp, #32]
10004ecc:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10004ed0:	ee32 4b04 	vadd.f64	d4, d2, d4
10004ed4:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10004ed8:	ee34 4b41 	vsub.f64	d4, d4, d1
10004edc:	ee39 9b41 	vsub.f64	d9, d9, d1
10004ee0:	ed9d 2b06 	vldr	d2, [sp, #24]
10004ee4:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10004ee8:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10004eec:	ee39 9b04 	vadd.f64	d9, d9, d4
10004ef0:	ee26 6b47 	vnmul.f64	d6, d6, d7
10004ef4:	ed90 4b14 	vldr	d4, [r0, #80]	@ 0x50
10004ef8:	ee22 2b47 	vnmul.f64	d2, d2, d7
10004efc:	eeab 2b04 	vfma.f64	d2, d11, d4
10004f00:	ee33 3b0a 	vadd.f64	d3, d3, d10
10004f04:	ed9d ab02 	vldr	d10, [sp, #8]
10004f08:	eeaa 6b04 	vfma.f64	d6, d10, d4
10004f0c:	ed9d 4b10 	vldr	d4, [sp, #64]	@ 0x40
10004f10:	ee24 ab05 	vmul.f64	d10, d4, d5
10004f14:	ed9d db0e 	vldr	d13, [sp, #56]	@ 0x38
10004f18:	eebc abca 	vcvt.u32.f64	s20, d10
10004f1c:	ee2d bb05 	vmul.f64	d11, d13, d5
10004f20:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10004f24:	eebc bbcb 	vcvt.u32.f64	s22, d11
10004f28:	ee0a 4b47 	vmls.f64	d4, d10, d7
10004f2c:	eeb8 bb4b 	vcvt.f64.u32	d11, s22
10004f30:	ee34 4b00 	vadd.f64	d4, d4, d0
10004f34:	eeb0 0b4d 	vmov.f64	d0, d13
10004f38:	ee32 2b07 	vadd.f64	d2, d2, d7
10004f3c:	ee0b 0b47 	vmls.f64	d0, d11, d7
10004f40:	ed9d eb0c 	vldr	d14, [sp, #48]	@ 0x30
10004f44:	ed90 bb16 	vldr	d11, [r0, #88]	@ 0x58
10004f48:	ed9d ab02 	vldr	d10, [sp, #8]
10004f4c:	ee30 0b09 	vadd.f64	d0, d0, d9
10004f50:	ee2e 9b47 	vnmul.f64	d9, d14, d7
10004f54:	eeaa 9b0b 	vfma.f64	d9, d10, d11
10004f58:	ee22 ab05 	vmul.f64	d10, d2, d5
10004f5c:	eefc bbca 	vcvt.u32.f64	s23, d10
10004f60:	ee2c ab05 	vmul.f64	d10, d12, d5
10004f64:	eebc bbca 	vcvt.u32.f64	s22, d10
10004f68:	eeb8 ab6b 	vcvt.f64.u32	d10, s23
10004f6c:	ee33 3b41 	vsub.f64	d3, d3, d1
10004f70:	ee0a 2b47 	vmls.f64	d2, d10, d7
10004f74:	ee33 3b02 	vadd.f64	d3, d3, d2
10004f78:	eeb8 2b4b 	vcvt.f64.u32	d2, s22
10004f7c:	eeb0 bb4c 	vmov.f64	d11, d12
10004f80:	ee39 9b07 	vadd.f64	d9, d9, d7
10004f84:	ee02 bb47 	vmls.f64	d11, d2, d7
10004f88:	ee34 4b02 	vadd.f64	d4, d4, d2
10004f8c:	ee28 2b05 	vmul.f64	d2, d8, d5
10004f90:	ee29 cb05 	vmul.f64	d12, d9, d5
10004f94:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10004f98:	eebc cbcc 	vcvt.u32.f64	s24, d12
10004f9c:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10004fa0:	ed9d db06 	vldr	d13, [sp, #24]
10004fa4:	ee02 8b47 	vmls.f64	d8, d2, d7
10004fa8:	ee30 0b02 	vadd.f64	d0, d0, d2
10004fac:	eeb8 2b4c 	vcvt.f64.u32	d2, s24
10004fb0:	ee3d ab0a 	vadd.f64	d10, d13, d10
10004fb4:	ee02 9b47 	vmls.f64	d9, d2, d7
10004fb8:	ee3e 2b02 	vadd.f64	d2, d14, d2
10004fbc:	ee33 3b09 	vadd.f64	d3, d3, d9
10004fc0:	ee32 2b41 	vsub.f64	d2, d2, d1
10004fc4:	ed9f 9b2e 	vldr	d9, [pc, #184]	@ 10005080 <fp64e_cmul_prepared+0x450>
10004fc8:	ee3a ab41 	vsub.f64	d10, d10, d1
10004fcc:	ed90 cb02 	vldr	d12, [r0, #8]
10004fd0:	ee3a ab02 	vadd.f64	d10, d10, d2
10004fd4:	ee34 4b09 	vadd.f64	d4, d4, d9
10004fd8:	ed9d 2b14 	vldr	d2, [sp, #80]	@ 0x50
10004fdc:	ee36 6b07 	vadd.f64	d6, d6, d7
10004fe0:	ee02 4b4c 	vmls.f64	d4, d2, d12
10004fe4:	ee30 0b09 	vadd.f64	d0, d0, d9
10004fe8:	ed9d 2b18 	vldr	d2, [sp, #96]	@ 0x60
10004fec:	ed90 cb0c 	vldr	d12, [r0, #48]	@ 0x30
10004ff0:	ee02 0b4c 	vmls.f64	d0, d2, d12
10004ff4:	ee26 cb05 	vmul.f64	d12, d6, d5
10004ff8:	eebc cbcc 	vcvt.u32.f64	s24, d12
10004ffc:	ed90 2b08 	vldr	d2, [r0, #32]
10005000:	ed9d db04 	vldr	d13, [sp, #16]
10005004:	eeb8 cb4c 	vcvt.f64.u32	d12, s24
10005008:	ee0d 4b42 	vmls.f64	d4, d13, d2
1000500c:	ee0c 6b47 	vmls.f64	d6, d12, d7
10005010:	ed90 2b12 	vldr	d2, [r0, #72]	@ 0x48
10005014:	ee36 6b0a 	vadd.f64	d6, d6, d10
10005018:	ee0f 0b42 	vmls.f64	d0, d15, d2
1000501c:	ee24 ab05 	vmul.f64	d10, d4, d5
10005020:	ee23 2b05 	vmul.f64	d2, d3, d5
10005024:	eebc abca 	vcvt.u32.f64	s20, d10
10005028:	eebc 2bc2 	vcvt.u32.f64	s4, d2
1000502c:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10005030:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10005034:	ee0a 4b47 	vmls.f64	d4, d10, d7
10005038:	ee36 6b02 	vadd.f64	d6, d6, d2
1000503c:	ee20 ab05 	vmul.f64	d10, d0, d5
10005040:	ee02 3b47 	vmls.f64	d3, d2, d7
10005044:	ee36 6b09 	vadd.f64	d6, d6, d9
10005048:	ed9d 2b1a 	vldr	d2, [sp, #104]	@ 0x68
1000504c:	ed90 9b16 	vldr	d9, [r0, #88]	@ 0x58
10005050:	eebc abca 	vcvt.u32.f64	s20, d10
10005054:	ee02 6b49 	vmls.f64	d6, d2, d9
10005058:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
1000505c:	ee38 2b0b 	vadd.f64	d2, d8, d11
10005060:	ee0a 0b47 	vmls.f64	d0, d10, d7
10005064:	ee22 ab05 	vmul.f64	d10, d2, d5
10005068:	ee3b 9b07 	vadd.f64	d9, d11, d7
1000506c:	e00c      	b.n	10005088 <fp64e_cmul_prepared+0x458>
1000506e:	bf00      	nop
10005070:	00000000 	.word	0x00000000
10005074:	3df00000 	.word	0x3df00000
10005078:	00000000 	.word	0x00000000
1000507c:	41f00000 	.word	0x41f00000
10005080:	00000000 	.word	0x00000000
10005084:	42000000 	.word	0x42000000
10005088:	eebc abca 	vcvt.u32.f64	s20, d10
1000508c:	ee39 9b48 	vsub.f64	d9, d9, d8
10005090:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10005094:	ed90 8b1c 	vldr	d8, [r0, #112]	@ 0x70
10005098:	ed9d bb00 	vldr	d11, [sp]
1000509c:	ee0a 2b47 	vmls.f64	d2, d10, d7
100050a0:	ee0b 6b48 	vmls.f64	d6, d11, d8
100050a4:	ee33 3b07 	vadd.f64	d3, d3, d7
100050a8:	ee30 8b04 	vadd.f64	d8, d0, d4
100050ac:	ee33 3b42 	vsub.f64	d3, d3, d2
100050b0:	ee38 8b0a 	vadd.f64	d8, d8, d10
100050b4:	ee26 2b05 	vmul.f64	d2, d6, d5
100050b8:	ee34 4b07 	vadd.f64	d4, d4, d7
100050bc:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100050c0:	ee34 0b40 	vsub.f64	d0, d4, d0
100050c4:	ee28 4b05 	vmul.f64	d4, d8, d5
100050c8:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100050cc:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100050d0:	ee02 6b47 	vmls.f64	d6, d2, d7
100050d4:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100050d8:	ee36 2b07 	vadd.f64	d2, d6, d7
100050dc:	ee04 8b47 	vmls.f64	d8, d4, d7
100050e0:	ee29 6b05 	vmul.f64	d6, d9, d5
100050e4:	ee23 4b05 	vmul.f64	d4, d3, d5
100050e8:	ee32 2b48 	vsub.f64	d2, d2, d8
100050ec:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100050f0:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100050f4:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100050f8:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100050fc:	ee30 0b41 	vsub.f64	d0, d0, d1
10005100:	ee32 2b41 	vsub.f64	d2, d2, d1
10005104:	ee30 0b06 	vadd.f64	d0, d0, d6
10005108:	ee32 2b04 	vadd.f64	d2, d2, d4
1000510c:	eeb0 1b49 	vmov.f64	d1, d9
10005110:	ee06 1b47 	vmls.f64	d1, d6, d7
10005114:	ee20 6b05 	vmul.f64	d6, d0, d5
10005118:	ee22 5b05 	vmul.f64	d5, d2, d5
1000511c:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10005120:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10005124:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005128:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000512c:	ee06 0b47 	vmls.f64	d0, d6, d7
10005130:	ee04 3b47 	vmls.f64	d3, d4, d7
10005134:	ee05 2b47 	vmls.f64	d2, d5, d7
10005138:	b034      	add	sp, #208	@ 0xd0
1000513a:	ecbd 8b10 	vpop	{d8-d15}
1000513e:	4770      	bx	lr

