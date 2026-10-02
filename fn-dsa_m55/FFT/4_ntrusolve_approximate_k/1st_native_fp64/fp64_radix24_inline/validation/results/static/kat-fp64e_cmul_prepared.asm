
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/kat/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10004c30 <fp64e_cmul_prepared>:
10004c30:	ed2d 8b10 	vpush	{d8-d15}
10004c34:	eeb0 8b40 	vmov.f64	d8, d0
10004c38:	eefc 6bc8 	vcvt.u32.f64	s13, d8
10004c3c:	ee16 2a90 	vmov	r2, s13
10004c40:	eefc 6bc2 	vcvt.u32.f64	s13, d2
10004c44:	0fd2      	lsrs	r2, r2, #31
10004c46:	ee16 3a90 	vmov	r3, s13
10004c4a:	ee06 2a90 	vmov	s13, r2
10004c4e:	eeb8 6be6 	vcvt.f64.s32	d6, s13
10004c52:	b0b0      	sub	sp, #192	@ 0xc0
10004c54:	0fdb      	lsrs	r3, r3, #31
10004c56:	ed9f 7bfe 	vldr	d7, [pc, #1016]	@ 10005050 <fp64e_cmul_prepared+0x420>
10004c5a:	eeb0 cb43 	vmov.f64	d12, d3
10004c5e:	eeb0 5b41 	vmov.f64	d5, d1
10004c62:	ed8d 6b10 	vstr	d6, [sp, #64]	@ 0x40
10004c66:	ed9f 9bfc 	vldr	d9, [pc, #1008]	@ 10005058 <fp64e_cmul_prepared+0x428>
10004c6a:	ee06 3a90 	vmov	s13, r3
10004c6e:	ee20 3b09 	vmul.f64	d3, d0, d9
10004c72:	ee35 ab0c 	vadd.f64	d10, d5, d12
10004c76:	ee21 0b07 	vmul.f64	d0, d1, d7
10004c7a:	eeb8 1be6 	vcvt.f64.s32	d1, s13
10004c7e:	ed9f 6bf8 	vldr	d6, [pc, #992]	@ 10005060 <fp64e_cmul_prepared+0x430>
10004c82:	eeb0 bb45 	vmov.f64	d11, d5
10004c86:	ee22 5b09 	vmul.f64	d5, d2, d9
10004c8a:	ee2a 9b06 	vmul.f64	d9, d10, d6
10004c8e:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10004c92:	ee38 4b02 	vadd.f64	d4, d8, d2
10004c96:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10004c9a:	ee34 4b09 	vadd.f64	d4, d4, d9
10004c9e:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10004ca2:	ee24 db06 	vmul.f64	d13, d4, d6
10004ca6:	ed9f ebf0 	vldr	d14, [pc, #960]	@ 10005068 <fp64e_cmul_prepared+0x438>
10004caa:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10004cae:	eebc dbcd 	vcvt.u32.f64	s26, d13
10004cb2:	ed8d 5b02 	vstr	d5, [sp, #8]
10004cb6:	ee05 2b4e 	vmls.f64	d2, d5, d14
10004cba:	eeb8 db4d 	vcvt.f64.u32	d13, s26
10004cbe:	ed9f 5bec 	vldr	d5, [pc, #944]	@ 10005070 <fp64e_cmul_prepared+0x440>
10004cc2:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10004cc6:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10004cca:	ee0d 4b45 	vmls.f64	d4, d13, d5
10004cce:	ed8d 1b14 	vstr	d1, [sp, #80]	@ 0x50
10004cd2:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10004cd6:	ee2c 1b07 	vmul.f64	d1, d12, d7
10004cda:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10004cde:	ed8d 4b04 	vstr	d4, [sp, #16]
10004ce2:	eefc 4bc4 	vcvt.u32.f64	s9, d4
10004ce6:	ee03 8b4e 	vmls.f64	d8, d3, d14
10004cea:	ee09 ab45 	vmls.f64	d10, d9, d5
10004cee:	ed9f dbe2 	vldr	d13, [pc, #904]	@ 10005078 <fp64e_cmul_prepared+0x448>
10004cf2:	eeb0 9b40 	vmov.f64	d9, d0
10004cf6:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10004cfa:	ee14 3a90 	vmov	r3, s9
10004cfe:	ed9f fbe0 	vldr	d15, [pc, #896]	@ 10005080 <fp64e_cmul_prepared+0x450>
10004d02:	ee08 9b0d 	vmla.f64	d9, d8, d13
10004d06:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10004d0a:	eeb0 8b4b 	vmov.f64	d8, d11
10004d0e:	0fdb      	lsrs	r3, r3, #31
10004d10:	ee00 8b4f 	vmls.f64	d8, d0, d15
10004d14:	ee04 3a90 	vmov	s9, r3
10004d18:	eeb0 0b41 	vmov.f64	d0, d1
10004d1c:	ed8d cb08 	vstr	d12, [sp, #32]
10004d20:	ee02 0b0d 	vmla.f64	d0, d2, d13
10004d24:	ee01 cb4f 	vmls.f64	d12, d1, d15
10004d28:	eeb8 2be4 	vcvt.f64.s32	d2, s9
10004d2c:	ed8d 0b12 	vstr	d0, [sp, #72]	@ 0x48
10004d30:	ed8d ab00 	vstr	d10, [sp]
10004d34:	ed90 4b04 	vldr	d4, [r0, #16]
10004d38:	ed90 ab00 	vldr	d10, [r0]
10004d3c:	ed8d bb06 	vstr	d11, [sp, #24]
10004d40:	eeb0 db4c 	vmov.f64	d13, d12
10004d44:	ed8d 2b16 	vstr	d2, [sp, #88]	@ 0x58
10004d48:	ed90 cb02 	vldr	d12, [r0, #8]
10004d4c:	ee28 2b0a 	vmul.f64	d2, d8, d10
10004d50:	ee28 bb0c 	vmul.f64	d11, d8, d12
10004d54:	ee28 1b04 	vmul.f64	d1, d8, d4
10004d58:	ee29 0b04 	vmul.f64	d0, d9, d4
10004d5c:	ee09 bb0a 	vmla.f64	d11, d9, d10
10004d60:	ee09 1b0c 	vmla.f64	d1, d9, d12
10004d64:	ee03 0b0c 	vmla.f64	d0, d3, d12
10004d68:	ee03 1b0a 	vmla.f64	d1, d3, d10
10004d6c:	ee22 2b07 	vmul.f64	d2, d2, d7
10004d70:	ed8d bb0a 	vstr	d11, [sp, #40]	@ 0x28
10004d74:	ed9d ab12 	vldr	d10, [sp, #72]	@ 0x48
10004d78:	ed8d 1b0c 	vstr	d1, [sp, #48]	@ 0x30
10004d7c:	ed8d 0b0e 	vstr	d0, [sp, #56]	@ 0x38
10004d80:	ed9d 1b02 	vldr	d1, [sp, #8]
10004d84:	ed90 0b0e 	vldr	d0, [r0, #56]	@ 0x38
10004d88:	eefc bbc2 	vcvt.u32.f64	s23, d2
10004d8c:	eeb0 cb4d 	vmov.f64	d12, d13
10004d90:	ed90 2b0c 	vldr	d2, [r0, #48]	@ 0x30
10004d94:	ed90 db0a 	vldr	d13, [r0, #40]	@ 0x28
10004d98:	ee2c 3b0d 	vmul.f64	d3, d12, d13
10004d9c:	ee2c 9b02 	vmul.f64	d9, d12, d2
10004da0:	ee2c 8b00 	vmul.f64	d8, d12, d0
10004da4:	ee2a 4b00 	vmul.f64	d4, d10, d0
10004da8:	ee0a 9b0d 	vmla.f64	d9, d10, d13
10004dac:	ee0a 8b02 	vmla.f64	d8, d10, d2
10004db0:	ee01 4b02 	vmla.f64	d4, d1, d2
10004db4:	ee01 8b0d 	vmla.f64	d8, d1, d13
10004db8:	ee23 3b07 	vmul.f64	d3, d3, d7
10004dbc:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10004dc0:	eeb8 2b6b 	vcvt.f64.u32	d2, s23
10004dc4:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10004dc8:	ed9d bb0a 	vldr	d11, [sp, #40]	@ 0x28
10004dcc:	ed8d 4b12 	vstr	d4, [sp, #72]	@ 0x48
10004dd0:	ee32 2b0b 	vadd.f64	d2, d2, d11
10004dd4:	ed9d 4b04 	vldr	d4, [sp, #16]
10004dd8:	ed9d bb00 	vldr	d11, [sp]
10004ddc:	ee33 3b09 	vadd.f64	d3, d3, d9
10004de0:	ed9f 9b9d 	vldr	d9, [pc, #628]	@ 10005058 <fp64e_cmul_prepared+0x428>
10004de4:	ee24 0b09 	vmul.f64	d0, d4, d9
10004de8:	ee2b 9b07 	vmul.f64	d9, d11, d7
10004dec:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10004df0:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10004df4:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10004df8:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10004dfc:	ee00 4b4e 	vmls.f64	d4, d0, d14
10004e00:	eeb0 ab49 	vmov.f64	d10, d9
10004e04:	ed9f db9c 	vldr	d13, [pc, #624]	@ 10005078 <fp64e_cmul_prepared+0x448>
10004e08:	ee04 ab0d 	vmla.f64	d10, d4, d13
10004e0c:	eeb0 4b4b 	vmov.f64	d4, d11
10004e10:	ee09 4b4f 	vmls.f64	d4, d9, d15
10004e14:	ee23 9b07 	vmul.f64	d9, d3, d7
10004e18:	eeb0 bb44 	vmov.f64	d11, d4
10004e1c:	ee22 4b07 	vmul.f64	d4, d2, d7
10004e20:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10004e24:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10004e28:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10004e2c:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10004e30:	ee09 3b4f 	vmls.f64	d3, d9, d15
10004e34:	ed9d 1b0c 	vldr	d1, [sp, #48]	@ 0x30
10004e38:	ee04 2b4f 	vmls.f64	d2, d4, d15
10004e3c:	ee38 8b09 	vadd.f64	d8, d8, d9
10004e40:	ee31 1b04 	vadd.f64	d1, d1, d4
10004e44:	ed90 9b18 	vldr	d9, [r0, #96]	@ 0x60
10004e48:	ed8d 2b04 	vstr	d2, [sp, #16]
10004e4c:	ed8d 8b02 	vstr	d8, [sp, #8]
10004e50:	ed8d 3b0a 	vstr	d3, [sp, #40]	@ 0x28
10004e54:	eeb0 cb4b 	vmov.f64	d12, d11
10004e58:	ed90 db14 	vldr	d13, [r0, #80]	@ 0x50
10004e5c:	ed90 8b16 	vldr	d8, [r0, #88]	@ 0x58
10004e60:	ee2c 4b0d 	vmul.f64	d4, d12, d13
10004e64:	ee2c 2b08 	vmul.f64	d2, d12, d8
10004e68:	ee2c 3b09 	vmul.f64	d3, d12, d9
10004e6c:	ee2a bb09 	vmul.f64	d11, d10, d9
10004e70:	ee0a 2b0d 	vmla.f64	d2, d10, d13
10004e74:	ee0a 3b08 	vmla.f64	d3, d10, d8
10004e78:	ee00 bb08 	vmla.f64	d11, d0, d8
10004e7c:	ee00 3b0d 	vmla.f64	d3, d0, d13
10004e80:	ee24 4b07 	vmul.f64	d4, d4, d7
10004e84:	ee21 0b07 	vmul.f64	d0, d1, d7
10004e88:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10004e8c:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10004e90:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10004e94:	ed9d 8b02 	vldr	d8, [sp, #8]
10004e98:	ee34 4b02 	vadd.f64	d4, d4, d2
10004e9c:	eeb8 2b40 	vcvt.f64.u32	d2, s0
10004ea0:	ed9d 0b0e 	vldr	d0, [sp, #56]	@ 0x38
10004ea4:	ee02 1b4f 	vmls.f64	d1, d2, d15
10004ea8:	ee30 ab02 	vadd.f64	d10, d0, d2
10004eac:	ee28 2b07 	vmul.f64	d2, d8, d7
10004eb0:	ee24 9b07 	vmul.f64	d9, d4, d7
10004eb4:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10004eb8:	eeb0 0b41 	vmov.f64	d0, d1
10004ebc:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10004ec0:	ed9d 1b12 	vldr	d1, [sp, #72]	@ 0x48
10004ec4:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10004ec8:	ee31 1b02 	vadd.f64	d1, d1, d2
10004ecc:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10004ed0:	ee02 8b4f 	vmls.f64	d8, d2, d15
10004ed4:	ee09 4b4f 	vmls.f64	d4, d9, d15
10004ed8:	ee21 2b07 	vmul.f64	d2, d1, d7
10004edc:	eeb0 cb44 	vmov.f64	d12, d4
10004ee0:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10004ee4:	ee2a 4b07 	vmul.f64	d4, d10, d7
10004ee8:	ee33 3b09 	vadd.f64	d3, d3, d9
10004eec:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10004ef0:	ed9f 9b59 	vldr	d9, [pc, #356]	@ 10005058 <fp64e_cmul_prepared+0x428>
10004ef4:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10004ef8:	ee02 1b4f 	vmls.f64	d1, d2, d15
10004efc:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10004f00:	ee20 2b09 	vmul.f64	d2, d0, d9
10004f04:	ee04 ab4f 	vmls.f64	d10, d4, d15
10004f08:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10004f0c:	ee28 4b09 	vmul.f64	d4, d8, d9
10004f10:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10004f14:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10004f18:	ed9f db57 	vldr	d13, [pc, #348]	@ 10005078 <fp64e_cmul_prepared+0x448>
10004f1c:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10004f20:	eeb0 9b42 	vmov.f64	d9, d2
10004f24:	ee0a 9b0d 	vmla.f64	d9, d10, d13
10004f28:	eeb0 ab44 	vmov.f64	d10, d4
10004f2c:	ee02 0b4e 	vmls.f64	d0, d2, d14
10004f30:	ee04 8b4e 	vmls.f64	d8, d4, d14
10004f34:	ee01 ab0d 	vmla.f64	d10, d1, d13
10004f38:	ed8d 9b02 	vstr	d9, [sp, #8]
10004f3c:	eeb0 db4a 	vmov.f64	d13, d10
10004f40:	eeb0 9b40 	vmov.f64	d9, d0
10004f44:	eeb0 ab48 	vmov.f64	d10, d8
10004f48:	ed9d 0b04 	vldr	d0, [sp, #16]
10004f4c:	ed9f 8b4e 	vldr	d8, [pc, #312]	@ 10005088 <fp64e_cmul_prepared+0x458>
10004f50:	ee23 2b07 	vmul.f64	d2, d3, d7
10004f54:	ee20 0b08 	vmul.f64	d0, d0, d8
10004f58:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10004f5c:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10004f60:	ed9d 4b0a 	vldr	d4, [sp, #40]	@ 0x28
10004f64:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10004f68:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10004f6c:	ee24 1b08 	vmul.f64	d1, d4, d8
10004f70:	ee02 3b4f 	vmls.f64	d3, d2, d15
10004f74:	ee3b 4b02 	vadd.f64	d4, d11, d2
10004f78:	ee09 0b0e 	vmla.f64	d0, d9, d14
10004f7c:	ed9f 9b36 	vldr	d9, [pc, #216]	@ 10005058 <fp64e_cmul_prepared+0x428>
10004f80:	ee2c 8b08 	vmul.f64	d8, d12, d8
10004f84:	ee24 7b07 	vmul.f64	d7, d4, d7
10004f88:	ee23 cb09 	vmul.f64	d12, d3, d9
10004f8c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10004f90:	eebc cbcc 	vcvt.u32.f64	s24, d12
10004f94:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10004f98:	eeb8 cb4c 	vcvt.f64.u32	d12, s24
10004f9c:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10004fa0:	ee07 4b4f 	vmls.f64	d4, d7, d15
10004fa4:	ee0c 3b4e 	vmls.f64	d3, d12, d14
10004fa8:	eeb0 7b4c 	vmov.f64	d7, d12
10004fac:	ed9f 2b32 	vldr	d2, [pc, #200]	@ 10005078 <fp64e_cmul_prepared+0x448>
10004fb0:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10004fb4:	ee04 7b02 	vmla.f64	d7, d4, d2
10004fb8:	ee03 8b0e 	vmla.f64	d8, d3, d14
10004fbc:	ed9f 2b34 	vldr	d2, [pc, #208]	@ 10005090 <fp64e_cmul_prepared+0x460>
10004fc0:	ed9d 9b02 	vldr	d9, [sp, #8]
10004fc4:	ee38 3b05 	vadd.f64	d3, d8, d5
10004fc8:	ee39 4b02 	vadd.f64	d4, d9, d2
10004fcc:	ee3d 8b02 	vadd.f64	d8, d13, d2
10004fd0:	ed9d 9b10 	vldr	d9, [sp, #64]	@ 0x40
10004fd4:	ee37 7b02 	vadd.f64	d7, d7, d2
10004fd8:	ed90 2b06 	vldr	d2, [r0, #24]
10004fdc:	ee09 4b42 	vmls.f64	d4, d9, d2
10004fe0:	ed90 2b10 	vldr	d2, [r0, #64]	@ 0x40
10004fe4:	ed9d 9b14 	vldr	d9, [sp, #80]	@ 0x50
10004fe8:	ee09 8b42 	vmls.f64	d8, d9, d2
10004fec:	ed90 2b08 	vldr	d2, [r0, #32]
10004ff0:	ed9d 9b06 	vldr	d9, [sp, #24]
10004ff4:	ed9d cb08 	vldr	d12, [sp, #32]
10004ff8:	ee09 4b42 	vmls.f64	d4, d9, d2
10004ffc:	ed90 2b12 	vldr	d2, [r0, #72]	@ 0x48
10005000:	ee24 9b06 	vmul.f64	d9, d4, d6
10005004:	ee0c 8b42 	vmls.f64	d8, d12, d2
10005008:	eebc 1bc1 	vcvt.u32.f64	s2, d1
1000500c:	ee28 2b06 	vmul.f64	d2, d8, d6
10005010:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10005014:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10005018:	ee0a 1b0e 	vmla.f64	d1, d10, d14
1000501c:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10005020:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10005024:	ee09 4b45 	vmls.f64	d4, d9, d5
10005028:	eeb8 2b42 	vcvt.f64.u32	d2, s4
1000502c:	ee31 9b00 	vadd.f64	d9, d1, d0
10005030:	ee30 0b05 	vadd.f64	d0, d0, d5
10005034:	ee02 8b45 	vmls.f64	d8, d2, d5
10005038:	ee30 1b41 	vsub.f64	d1, d0, d1
1000503c:	ed90 2b1a 	vldr	d2, [r0, #104]	@ 0x68
10005040:	ed9d 0b16 	vldr	d0, [sp, #88]	@ 0x58
10005044:	ee00 7b42 	vmls.f64	d7, d0, d2
10005048:	e026      	b.n	10005098 <fp64e_cmul_prepared+0x468>
1000504a:	bf00      	nop
1000504c:	f3af 8000 	nop.w
10005050:	00000000 	.word	0x00000000
10005054:	3e700000 	.word	0x3e700000
10005058:	00000000 	.word	0x00000000
1000505c:	3ef00000 	.word	0x3ef00000
10005060:	00000000 	.word	0x00000000
10005064:	3df00000 	.word	0x3df00000
10005068:	00000000 	.word	0x00000000
1000506c:	40f00000 	.word	0x40f00000
10005070:	00000000 	.word	0x00000000
10005074:	41f00000 	.word	0x41f00000
10005078:	00000000 	.word	0x00000000
1000507c:	40700000 	.word	0x40700000
10005080:	00000000 	.word	0x00000000
10005084:	41700000 	.word	0x41700000
10005088:	00000000 	.word	0x00000000
1000508c:	3f700000 	.word	0x3f700000
10005090:	00000000 	.word	0x00000000
10005094:	42000000 	.word	0x42000000
10005098:	ee29 2b06 	vmul.f64	d2, d9, d6
1000509c:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100050a0:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100050a4:	ed90 0b1c 	vldr	d0, [r0, #112]	@ 0x70
100050a8:	ee02 9b45 	vmls.f64	d9, d2, d5
100050ac:	ed9d bb00 	vldr	d11, [sp]
100050b0:	ee33 3b49 	vsub.f64	d3, d3, d9
100050b4:	ee0b 7b40 	vmls.f64	d7, d11, d0
100050b8:	ee38 9b04 	vadd.f64	d9, d8, d4
100050bc:	ee34 4b05 	vadd.f64	d4, d4, d5
100050c0:	ee39 9b02 	vadd.f64	d9, d9, d2
100050c4:	ee34 0b48 	vsub.f64	d0, d4, d8
100050c8:	ee27 8b06 	vmul.f64	d8, d7, d6
100050cc:	ee29 2b06 	vmul.f64	d2, d9, d6
100050d0:	eebc 8bc8 	vcvt.u32.f64	s16, d8
100050d4:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100050d8:	eeb8 8b48 	vcvt.f64.u32	d8, s16
100050dc:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100050e0:	ee08 7b45 	vmls.f64	d7, d8, d5
100050e4:	ee02 9b45 	vmls.f64	d9, d2, d5
100050e8:	ee37 2b05 	vadd.f64	d2, d7, d5
100050ec:	eeb7 4b00 	vmov.f64	d4, #112	@ 0x3f800000  1.0
100050f0:	ee32 2b49 	vsub.f64	d2, d2, d9
100050f4:	ee21 7b06 	vmul.f64	d7, d1, d6
100050f8:	ee30 0b44 	vsub.f64	d0, d0, d4
100050fc:	ee32 2b44 	vsub.f64	d2, d2, d4
10005100:	ee23 4b06 	vmul.f64	d4, d3, d6
10005104:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005108:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000510c:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005110:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10005114:	ee30 0b07 	vadd.f64	d0, d0, d7
10005118:	ee32 2b04 	vadd.f64	d2, d2, d4
1000511c:	ee07 1b45 	vmls.f64	d1, d7, d5
10005120:	ee20 7b06 	vmul.f64	d7, d0, d6
10005124:	ee22 6b06 	vmul.f64	d6, d2, d6
10005128:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000512c:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10005130:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005134:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005138:	ee07 0b45 	vmls.f64	d0, d7, d5
1000513c:	ee04 3b45 	vmls.f64	d3, d4, d5
10005140:	ee06 2b45 	vmls.f64	d2, d6, d5
10005144:	b030      	add	sp, #192	@ 0xc0
10005146:	ecbd 8b10 	vpop	{d8-d15}
1000514a:	4770      	bx	lr
