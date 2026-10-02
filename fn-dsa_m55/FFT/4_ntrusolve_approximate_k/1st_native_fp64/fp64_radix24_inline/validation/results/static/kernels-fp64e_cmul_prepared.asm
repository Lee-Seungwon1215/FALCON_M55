
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/kernels/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

100009a8 <fp64e_cmul_prepared>:
100009a8:	ed2d 8b10 	vpush	{d8-d15}
100009ac:	eeb0 8b40 	vmov.f64	d8, d0
100009b0:	eefc 6bc8 	vcvt.u32.f64	s13, d8
100009b4:	ee16 2a90 	vmov	r2, s13
100009b8:	eefc 6bc2 	vcvt.u32.f64	s13, d2
100009bc:	0fd2      	lsrs	r2, r2, #31
100009be:	ee16 3a90 	vmov	r3, s13
100009c2:	ee06 2a90 	vmov	s13, r2
100009c6:	eeb8 6be6 	vcvt.f64.s32	d6, s13
100009ca:	b0b0      	sub	sp, #192	@ 0xc0
100009cc:	0fdb      	lsrs	r3, r3, #31
100009ce:	ed9f 7bfe 	vldr	d7, [pc, #1016]	@ 10000dc8 <fp64e_cmul_prepared+0x420>
100009d2:	eeb0 cb43 	vmov.f64	d12, d3
100009d6:	eeb0 5b41 	vmov.f64	d5, d1
100009da:	ed8d 6b10 	vstr	d6, [sp, #64]	@ 0x40
100009de:	ed9f 9bfc 	vldr	d9, [pc, #1008]	@ 10000dd0 <fp64e_cmul_prepared+0x428>
100009e2:	ee06 3a90 	vmov	s13, r3
100009e6:	ee20 3b09 	vmul.f64	d3, d0, d9
100009ea:	ee35 ab0c 	vadd.f64	d10, d5, d12
100009ee:	ee21 0b07 	vmul.f64	d0, d1, d7
100009f2:	eeb8 1be6 	vcvt.f64.s32	d1, s13
100009f6:	ed9f 6bf8 	vldr	d6, [pc, #992]	@ 10000dd8 <fp64e_cmul_prepared+0x430>
100009fa:	eeb0 bb45 	vmov.f64	d11, d5
100009fe:	ee22 5b09 	vmul.f64	d5, d2, d9
10000a02:	ee2a 9b06 	vmul.f64	d9, d10, d6
10000a06:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10000a0a:	ee38 4b02 	vadd.f64	d4, d8, d2
10000a0e:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10000a12:	ee34 4b09 	vadd.f64	d4, d4, d9
10000a16:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10000a1a:	ee24 db06 	vmul.f64	d13, d4, d6
10000a1e:	ed9f ebf0 	vldr	d14, [pc, #960]	@ 10000de0 <fp64e_cmul_prepared+0x438>
10000a22:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10000a26:	eebc dbcd 	vcvt.u32.f64	s26, d13
10000a2a:	ed8d 5b02 	vstr	d5, [sp, #8]
10000a2e:	ee05 2b4e 	vmls.f64	d2, d5, d14
10000a32:	eeb8 db4d 	vcvt.f64.u32	d13, s26
10000a36:	ed9f 5bec 	vldr	d5, [pc, #944]	@ 10000de8 <fp64e_cmul_prepared+0x440>
10000a3a:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10000a3e:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10000a42:	ee0d 4b45 	vmls.f64	d4, d13, d5
10000a46:	ed8d 1b14 	vstr	d1, [sp, #80]	@ 0x50
10000a4a:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10000a4e:	ee2c 1b07 	vmul.f64	d1, d12, d7
10000a52:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10000a56:	ed8d 4b04 	vstr	d4, [sp, #16]
10000a5a:	eefc 4bc4 	vcvt.u32.f64	s9, d4
10000a5e:	ee03 8b4e 	vmls.f64	d8, d3, d14
10000a62:	ee09 ab45 	vmls.f64	d10, d9, d5
10000a66:	ed9f dbe2 	vldr	d13, [pc, #904]	@ 10000df0 <fp64e_cmul_prepared+0x448>
10000a6a:	eeb0 9b40 	vmov.f64	d9, d0
10000a6e:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10000a72:	ee14 3a90 	vmov	r3, s9
10000a76:	ed9f fbe0 	vldr	d15, [pc, #896]	@ 10000df8 <fp64e_cmul_prepared+0x450>
10000a7a:	ee08 9b0d 	vmla.f64	d9, d8, d13
10000a7e:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10000a82:	eeb0 8b4b 	vmov.f64	d8, d11
10000a86:	0fdb      	lsrs	r3, r3, #31
10000a88:	ee00 8b4f 	vmls.f64	d8, d0, d15
10000a8c:	ee04 3a90 	vmov	s9, r3
10000a90:	eeb0 0b41 	vmov.f64	d0, d1
10000a94:	ed8d cb08 	vstr	d12, [sp, #32]
10000a98:	ee02 0b0d 	vmla.f64	d0, d2, d13
10000a9c:	ee01 cb4f 	vmls.f64	d12, d1, d15
10000aa0:	eeb8 2be4 	vcvt.f64.s32	d2, s9
10000aa4:	ed8d 0b12 	vstr	d0, [sp, #72]	@ 0x48
10000aa8:	ed8d ab00 	vstr	d10, [sp]
10000aac:	ed90 4b04 	vldr	d4, [r0, #16]
10000ab0:	ed90 ab00 	vldr	d10, [r0]
10000ab4:	ed8d bb06 	vstr	d11, [sp, #24]
10000ab8:	eeb0 db4c 	vmov.f64	d13, d12
10000abc:	ed8d 2b16 	vstr	d2, [sp, #88]	@ 0x58
10000ac0:	ed90 cb02 	vldr	d12, [r0, #8]
10000ac4:	ee28 2b0a 	vmul.f64	d2, d8, d10
10000ac8:	ee28 bb0c 	vmul.f64	d11, d8, d12
10000acc:	ee28 1b04 	vmul.f64	d1, d8, d4
10000ad0:	ee29 0b04 	vmul.f64	d0, d9, d4
10000ad4:	ee09 bb0a 	vmla.f64	d11, d9, d10
10000ad8:	ee09 1b0c 	vmla.f64	d1, d9, d12
10000adc:	ee03 0b0c 	vmla.f64	d0, d3, d12
10000ae0:	ee03 1b0a 	vmla.f64	d1, d3, d10
10000ae4:	ee22 2b07 	vmul.f64	d2, d2, d7
10000ae8:	ed8d bb0a 	vstr	d11, [sp, #40]	@ 0x28
10000aec:	ed9d ab12 	vldr	d10, [sp, #72]	@ 0x48
10000af0:	ed8d 1b0c 	vstr	d1, [sp, #48]	@ 0x30
10000af4:	ed8d 0b0e 	vstr	d0, [sp, #56]	@ 0x38
10000af8:	ed9d 1b02 	vldr	d1, [sp, #8]
10000afc:	ed90 0b0e 	vldr	d0, [r0, #56]	@ 0x38
10000b00:	eefc bbc2 	vcvt.u32.f64	s23, d2
10000b04:	eeb0 cb4d 	vmov.f64	d12, d13
10000b08:	ed90 2b0c 	vldr	d2, [r0, #48]	@ 0x30
10000b0c:	ed90 db0a 	vldr	d13, [r0, #40]	@ 0x28
10000b10:	ee2c 3b0d 	vmul.f64	d3, d12, d13
10000b14:	ee2c 9b02 	vmul.f64	d9, d12, d2
10000b18:	ee2c 8b00 	vmul.f64	d8, d12, d0
10000b1c:	ee2a 4b00 	vmul.f64	d4, d10, d0
10000b20:	ee0a 9b0d 	vmla.f64	d9, d10, d13
10000b24:	ee0a 8b02 	vmla.f64	d8, d10, d2
10000b28:	ee01 4b02 	vmla.f64	d4, d1, d2
10000b2c:	ee01 8b0d 	vmla.f64	d8, d1, d13
10000b30:	ee23 3b07 	vmul.f64	d3, d3, d7
10000b34:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10000b38:	eeb8 2b6b 	vcvt.f64.u32	d2, s23
10000b3c:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10000b40:	ed9d bb0a 	vldr	d11, [sp, #40]	@ 0x28
10000b44:	ed8d 4b12 	vstr	d4, [sp, #72]	@ 0x48
10000b48:	ee32 2b0b 	vadd.f64	d2, d2, d11
10000b4c:	ed9d 4b04 	vldr	d4, [sp, #16]
10000b50:	ed9d bb00 	vldr	d11, [sp]
10000b54:	ee33 3b09 	vadd.f64	d3, d3, d9
10000b58:	ed9f 9b9d 	vldr	d9, [pc, #628]	@ 10000dd0 <fp64e_cmul_prepared+0x428>
10000b5c:	ee24 0b09 	vmul.f64	d0, d4, d9
10000b60:	ee2b 9b07 	vmul.f64	d9, d11, d7
10000b64:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10000b68:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10000b6c:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10000b70:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10000b74:	ee00 4b4e 	vmls.f64	d4, d0, d14
10000b78:	eeb0 ab49 	vmov.f64	d10, d9
10000b7c:	ed9f db9c 	vldr	d13, [pc, #624]	@ 10000df0 <fp64e_cmul_prepared+0x448>
10000b80:	ee04 ab0d 	vmla.f64	d10, d4, d13
10000b84:	eeb0 4b4b 	vmov.f64	d4, d11
10000b88:	ee09 4b4f 	vmls.f64	d4, d9, d15
10000b8c:	ee23 9b07 	vmul.f64	d9, d3, d7
10000b90:	eeb0 bb44 	vmov.f64	d11, d4
10000b94:	ee22 4b07 	vmul.f64	d4, d2, d7
10000b98:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10000b9c:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10000ba0:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10000ba4:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10000ba8:	ee09 3b4f 	vmls.f64	d3, d9, d15
10000bac:	ed9d 1b0c 	vldr	d1, [sp, #48]	@ 0x30
10000bb0:	ee04 2b4f 	vmls.f64	d2, d4, d15
10000bb4:	ee38 8b09 	vadd.f64	d8, d8, d9
10000bb8:	ee31 1b04 	vadd.f64	d1, d1, d4
10000bbc:	ed90 9b18 	vldr	d9, [r0, #96]	@ 0x60
10000bc0:	ed8d 2b04 	vstr	d2, [sp, #16]
10000bc4:	ed8d 8b02 	vstr	d8, [sp, #8]
10000bc8:	ed8d 3b0a 	vstr	d3, [sp, #40]	@ 0x28
10000bcc:	eeb0 cb4b 	vmov.f64	d12, d11
10000bd0:	ed90 db14 	vldr	d13, [r0, #80]	@ 0x50
10000bd4:	ed90 8b16 	vldr	d8, [r0, #88]	@ 0x58
10000bd8:	ee2c 4b0d 	vmul.f64	d4, d12, d13
10000bdc:	ee2c 2b08 	vmul.f64	d2, d12, d8
10000be0:	ee2c 3b09 	vmul.f64	d3, d12, d9
10000be4:	ee2a bb09 	vmul.f64	d11, d10, d9
10000be8:	ee0a 2b0d 	vmla.f64	d2, d10, d13
10000bec:	ee0a 3b08 	vmla.f64	d3, d10, d8
10000bf0:	ee00 bb08 	vmla.f64	d11, d0, d8
10000bf4:	ee00 3b0d 	vmla.f64	d3, d0, d13
10000bf8:	ee24 4b07 	vmul.f64	d4, d4, d7
10000bfc:	ee21 0b07 	vmul.f64	d0, d1, d7
10000c00:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10000c04:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10000c08:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10000c0c:	ed9d 8b02 	vldr	d8, [sp, #8]
10000c10:	ee34 4b02 	vadd.f64	d4, d4, d2
10000c14:	eeb8 2b40 	vcvt.f64.u32	d2, s0
10000c18:	ed9d 0b0e 	vldr	d0, [sp, #56]	@ 0x38
10000c1c:	ee02 1b4f 	vmls.f64	d1, d2, d15
10000c20:	ee30 ab02 	vadd.f64	d10, d0, d2
10000c24:	ee28 2b07 	vmul.f64	d2, d8, d7
10000c28:	ee24 9b07 	vmul.f64	d9, d4, d7
10000c2c:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10000c30:	eeb0 0b41 	vmov.f64	d0, d1
10000c34:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10000c38:	ed9d 1b12 	vldr	d1, [sp, #72]	@ 0x48
10000c3c:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10000c40:	ee31 1b02 	vadd.f64	d1, d1, d2
10000c44:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10000c48:	ee02 8b4f 	vmls.f64	d8, d2, d15
10000c4c:	ee09 4b4f 	vmls.f64	d4, d9, d15
10000c50:	ee21 2b07 	vmul.f64	d2, d1, d7
10000c54:	eeb0 cb44 	vmov.f64	d12, d4
10000c58:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10000c5c:	ee2a 4b07 	vmul.f64	d4, d10, d7
10000c60:	ee33 3b09 	vadd.f64	d3, d3, d9
10000c64:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10000c68:	ed9f 9b59 	vldr	d9, [pc, #356]	@ 10000dd0 <fp64e_cmul_prepared+0x428>
10000c6c:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10000c70:	ee02 1b4f 	vmls.f64	d1, d2, d15
10000c74:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10000c78:	ee20 2b09 	vmul.f64	d2, d0, d9
10000c7c:	ee04 ab4f 	vmls.f64	d10, d4, d15
10000c80:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10000c84:	ee28 4b09 	vmul.f64	d4, d8, d9
10000c88:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10000c8c:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10000c90:	ed9f db57 	vldr	d13, [pc, #348]	@ 10000df0 <fp64e_cmul_prepared+0x448>
10000c94:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10000c98:	eeb0 9b42 	vmov.f64	d9, d2
10000c9c:	ee0a 9b0d 	vmla.f64	d9, d10, d13
10000ca0:	eeb0 ab44 	vmov.f64	d10, d4
10000ca4:	ee02 0b4e 	vmls.f64	d0, d2, d14
10000ca8:	ee04 8b4e 	vmls.f64	d8, d4, d14
10000cac:	ee01 ab0d 	vmla.f64	d10, d1, d13
10000cb0:	ed8d 9b02 	vstr	d9, [sp, #8]
10000cb4:	eeb0 db4a 	vmov.f64	d13, d10
10000cb8:	eeb0 9b40 	vmov.f64	d9, d0
10000cbc:	eeb0 ab48 	vmov.f64	d10, d8
10000cc0:	ed9d 0b04 	vldr	d0, [sp, #16]
10000cc4:	ed9f 8b4e 	vldr	d8, [pc, #312]	@ 10000e00 <fp64e_cmul_prepared+0x458>
10000cc8:	ee23 2b07 	vmul.f64	d2, d3, d7
10000ccc:	ee20 0b08 	vmul.f64	d0, d0, d8
10000cd0:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10000cd4:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10000cd8:	ed9d 4b0a 	vldr	d4, [sp, #40]	@ 0x28
10000cdc:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10000ce0:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10000ce4:	ee24 1b08 	vmul.f64	d1, d4, d8
10000ce8:	ee02 3b4f 	vmls.f64	d3, d2, d15
10000cec:	ee3b 4b02 	vadd.f64	d4, d11, d2
10000cf0:	ee09 0b0e 	vmla.f64	d0, d9, d14
10000cf4:	ed9f 9b36 	vldr	d9, [pc, #216]	@ 10000dd0 <fp64e_cmul_prepared+0x428>
10000cf8:	ee2c 8b08 	vmul.f64	d8, d12, d8
10000cfc:	ee24 7b07 	vmul.f64	d7, d4, d7
10000d00:	ee23 cb09 	vmul.f64	d12, d3, d9
10000d04:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10000d08:	eebc cbcc 	vcvt.u32.f64	s24, d12
10000d0c:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10000d10:	eeb8 cb4c 	vcvt.f64.u32	d12, s24
10000d14:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10000d18:	ee07 4b4f 	vmls.f64	d4, d7, d15
10000d1c:	ee0c 3b4e 	vmls.f64	d3, d12, d14
10000d20:	eeb0 7b4c 	vmov.f64	d7, d12
10000d24:	ed9f 2b32 	vldr	d2, [pc, #200]	@ 10000df0 <fp64e_cmul_prepared+0x448>
10000d28:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10000d2c:	ee04 7b02 	vmla.f64	d7, d4, d2
10000d30:	ee03 8b0e 	vmla.f64	d8, d3, d14
10000d34:	ed9f 2b34 	vldr	d2, [pc, #208]	@ 10000e08 <fp64e_cmul_prepared+0x460>
10000d38:	ed9d 9b02 	vldr	d9, [sp, #8]
10000d3c:	ee38 3b05 	vadd.f64	d3, d8, d5
10000d40:	ee39 4b02 	vadd.f64	d4, d9, d2
10000d44:	ee3d 8b02 	vadd.f64	d8, d13, d2
10000d48:	ed9d 9b10 	vldr	d9, [sp, #64]	@ 0x40
10000d4c:	ee37 7b02 	vadd.f64	d7, d7, d2
10000d50:	ed90 2b06 	vldr	d2, [r0, #24]
10000d54:	ee09 4b42 	vmls.f64	d4, d9, d2
10000d58:	ed90 2b10 	vldr	d2, [r0, #64]	@ 0x40
10000d5c:	ed9d 9b14 	vldr	d9, [sp, #80]	@ 0x50
10000d60:	ee09 8b42 	vmls.f64	d8, d9, d2
10000d64:	ed90 2b08 	vldr	d2, [r0, #32]
10000d68:	ed9d 9b06 	vldr	d9, [sp, #24]
10000d6c:	ed9d cb08 	vldr	d12, [sp, #32]
10000d70:	ee09 4b42 	vmls.f64	d4, d9, d2
10000d74:	ed90 2b12 	vldr	d2, [r0, #72]	@ 0x48
10000d78:	ee24 9b06 	vmul.f64	d9, d4, d6
10000d7c:	ee0c 8b42 	vmls.f64	d8, d12, d2
10000d80:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10000d84:	ee28 2b06 	vmul.f64	d2, d8, d6
10000d88:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10000d8c:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10000d90:	ee0a 1b0e 	vmla.f64	d1, d10, d14
10000d94:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10000d98:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10000d9c:	ee09 4b45 	vmls.f64	d4, d9, d5
10000da0:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10000da4:	ee31 9b00 	vadd.f64	d9, d1, d0
10000da8:	ee30 0b05 	vadd.f64	d0, d0, d5
10000dac:	ee02 8b45 	vmls.f64	d8, d2, d5
10000db0:	ee30 1b41 	vsub.f64	d1, d0, d1
10000db4:	ed90 2b1a 	vldr	d2, [r0, #104]	@ 0x68
10000db8:	ed9d 0b16 	vldr	d0, [sp, #88]	@ 0x58
10000dbc:	ee00 7b42 	vmls.f64	d7, d0, d2
10000dc0:	e026      	b.n	10000e10 <fp64e_cmul_prepared+0x468>
10000dc2:	bf00      	nop
10000dc4:	f3af 8000 	nop.w
10000dc8:	00000000 	.word	0x00000000
10000dcc:	3e700000 	.word	0x3e700000
10000dd0:	00000000 	.word	0x00000000
10000dd4:	3ef00000 	.word	0x3ef00000
10000dd8:	00000000 	.word	0x00000000
10000ddc:	3df00000 	.word	0x3df00000
10000de0:	00000000 	.word	0x00000000
10000de4:	40f00000 	.word	0x40f00000
10000de8:	00000000 	.word	0x00000000
10000dec:	41f00000 	.word	0x41f00000
10000df0:	00000000 	.word	0x00000000
10000df4:	40700000 	.word	0x40700000
10000df8:	00000000 	.word	0x00000000
10000dfc:	41700000 	.word	0x41700000
10000e00:	00000000 	.word	0x00000000
10000e04:	3f700000 	.word	0x3f700000
10000e08:	00000000 	.word	0x00000000
10000e0c:	42000000 	.word	0x42000000
10000e10:	ee29 2b06 	vmul.f64	d2, d9, d6
10000e14:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10000e18:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10000e1c:	ed90 0b1c 	vldr	d0, [r0, #112]	@ 0x70
10000e20:	ee02 9b45 	vmls.f64	d9, d2, d5
10000e24:	ed9d bb00 	vldr	d11, [sp]
10000e28:	ee33 3b49 	vsub.f64	d3, d3, d9
10000e2c:	ee0b 7b40 	vmls.f64	d7, d11, d0
10000e30:	ee38 9b04 	vadd.f64	d9, d8, d4
10000e34:	ee34 4b05 	vadd.f64	d4, d4, d5
10000e38:	ee39 9b02 	vadd.f64	d9, d9, d2
10000e3c:	ee34 0b48 	vsub.f64	d0, d4, d8
10000e40:	ee27 8b06 	vmul.f64	d8, d7, d6
10000e44:	ee29 2b06 	vmul.f64	d2, d9, d6
10000e48:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10000e4c:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10000e50:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10000e54:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10000e58:	ee08 7b45 	vmls.f64	d7, d8, d5
10000e5c:	ee02 9b45 	vmls.f64	d9, d2, d5
10000e60:	ee37 2b05 	vadd.f64	d2, d7, d5
10000e64:	eeb7 4b00 	vmov.f64	d4, #112	@ 0x3f800000  1.0
10000e68:	ee32 2b49 	vsub.f64	d2, d2, d9
10000e6c:	ee21 7b06 	vmul.f64	d7, d1, d6
10000e70:	ee30 0b44 	vsub.f64	d0, d0, d4
10000e74:	ee32 2b44 	vsub.f64	d2, d2, d4
10000e78:	ee23 4b06 	vmul.f64	d4, d3, d6
10000e7c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10000e80:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10000e84:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10000e88:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10000e8c:	ee30 0b07 	vadd.f64	d0, d0, d7
10000e90:	ee32 2b04 	vadd.f64	d2, d2, d4
10000e94:	ee07 1b45 	vmls.f64	d1, d7, d5
10000e98:	ee20 7b06 	vmul.f64	d7, d0, d6
10000e9c:	ee22 6b06 	vmul.f64	d6, d2, d6
10000ea0:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10000ea4:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10000ea8:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10000eac:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10000eb0:	ee07 0b45 	vmls.f64	d0, d7, d5
10000eb4:	ee04 3b45 	vmls.f64	d3, d4, d5
10000eb8:	ee06 2b45 	vmls.f64	d2, d6, d5
10000ebc:	b030      	add	sp, #192	@ 0xc0
10000ebe:	ecbd 8b10 	vpop	{d8-d15}
10000ec2:	4770      	bx	lr
