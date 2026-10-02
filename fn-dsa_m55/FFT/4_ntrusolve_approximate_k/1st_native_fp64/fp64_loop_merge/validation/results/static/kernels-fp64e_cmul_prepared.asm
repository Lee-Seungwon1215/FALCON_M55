10000928 <fp64e_cmul_prepared>:
10000928:	eefc 6bc0 	vcvt.u32.f64	s13, d0
1000092c:	ee16 2a90 	vmov	r2, s13
10000930:	eefc 6bc2 	vcvt.u32.f64	s13, d2
10000934:	0fd2      	lsrs	r2, r2, #31
10000936:	ee16 3a90 	vmov	r3, s13
1000093a:	ee06 2a90 	vmov	s13, r2
1000093e:	ed2d 8b10 	vpush	{d8-d15}
10000942:	eeb8 6be6 	vcvt.f64.s32	d6, s13
10000946:	b0b4      	sub	sp, #208	@ 0xd0
10000948:	0fdb      	lsrs	r3, r3, #31
1000094a:	ed8d 6b14 	vstr	d6, [sp, #80]	@ 0x50
1000094e:	ee06 3a90 	vmov	s13, r3
10000952:	eeb0 fb43 	vmov.f64	d15, d3
10000956:	eeb0 db41 	vmov.f64	d13, d1
1000095a:	ed90 3b06 	vldr	d3, [r0, #24]
1000095e:	eeb8 5be6 	vcvt.f64.s32	d5, s13
10000962:	ee31 eb0f 	vadd.f64	d14, d1, d15
10000966:	ee2d 9b03 	vmul.f64	d9, d13, d3
1000096a:	ed8d 5b18 	vstr	d5, [sp, #96]	@ 0x60
1000096e:	ee20 3b03 	vmul.f64	d3, d0, d3
10000972:	ed9f 5bfd 	vldr	d5, [pc, #1012]	@ 10000d68 <fp64e_cmul_prepared+0x440>
10000976:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000097a:	ee2e 8b05 	vmul.f64	d8, d14, d5
1000097e:	ed90 1b10 	vldr	d1, [r0, #64]	@ 0x40
10000982:	eefc 3bc8 	vcvt.u32.f64	s7, d8
10000986:	eeb8 8b43 	vcvt.f64.u32	d8, s6
1000098a:	ed8d 8b0a 	vstr	d8, [sp, #40]	@ 0x28
1000098e:	ee2f 8b01 	vmul.f64	d8, d15, d1
10000992:	ee22 1b01 	vmul.f64	d1, d2, d1
10000996:	eebc 1bc1 	vcvt.u32.f64	s2, d1
1000099a:	ed90 6b0e 	vldr	d6, [r0, #56]	@ 0x38
1000099e:	eeb8 ab41 	vcvt.f64.u32	d10, s2
100009a2:	ed90 4b04 	vldr	d4, [r0, #16]
100009a6:	ed8d ab08 	vstr	d10, [sp, #32]
100009aa:	ee2f ab06 	vmul.f64	d10, d15, d6
100009ae:	ee2d 1b04 	vmul.f64	d1, d13, d4
100009b2:	eebc abca 	vcvt.u32.f64	s20, d10
100009b6:	eebc 9bc9 	vcvt.u32.f64	s18, d9
100009ba:	ed9f 7bed 	vldr	d7, [pc, #948]	@ 10000d70 <fp64e_cmul_prepared+0x448>
100009be:	eeb8 cb4a 	vcvt.f64.u32	d12, s20
100009c2:	eeb8 9b49 	vcvt.f64.u32	d9, s18
100009c6:	eeb8 3b63 	vcvt.f64.u32	d3, s7
100009ca:	ee30 ab02 	vadd.f64	d10, d0, d2
100009ce:	eebc 1bc1 	vcvt.u32.f64	s2, d1
100009d2:	ee03 eb47 	vmls.f64	d14, d3, d7
100009d6:	eeb8 bb41 	vcvt.f64.u32	d11, s2
100009da:	ee3a ab03 	vadd.f64	d10, d10, d3
100009de:	ee29 1b47 	vnmul.f64	d1, d9, d7
100009e2:	ed90 3b02 	vldr	d3, [r0, #8]
100009e6:	eead 1b03 	vfma.f64	d1, d13, d3
100009ea:	ee31 1b07 	vadd.f64	d1, d1, d7
100009ee:	ee21 1b05 	vmul.f64	d1, d1, d5
100009f2:	eebc 8bc8 	vcvt.u32.f64	s16, d8
100009f6:	eebc 1bc1 	vcvt.u32.f64	s2, d1
100009fa:	eeb8 8b48 	vcvt.f64.u32	d8, s16
100009fe:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10000a02:	ed8d db04 	vstr	d13, [sp, #16]
10000a06:	ee28 3b47 	vnmul.f64	d3, d8, d7
10000a0a:	ee31 db09 	vadd.f64	d13, d1, d9
10000a0e:	ee2a 1b05 	vmul.f64	d1, d10, d5
10000a12:	ed90 9b0c 	vldr	d9, [r0, #48]	@ 0x30
10000a16:	eeaf 3b09 	vfma.f64	d3, d15, d9
10000a1a:	ee33 3b07 	vadd.f64	d3, d3, d7
10000a1e:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10000a22:	ee23 3b05 	vmul.f64	d3, d3, d5
10000a26:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10000a2a:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10000a2e:	ee01 ab47 	vmls.f64	d10, d1, d7
10000a32:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10000a36:	ed8d eb00 	vstr	d14, [sp]
10000a3a:	ee33 eb08 	vadd.f64	d14, d3, d8
10000a3e:	eefc 3bca 	vcvt.u32.f64	s7, d10
10000a42:	ee20 4b04 	vmul.f64	d4, d0, d4
10000a46:	ee13 3a90 	vmov	r3, s7
10000a4a:	ee22 6b06 	vmul.f64	d6, d2, d6
10000a4e:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10000a52:	0fdb      	lsrs	r3, r3, #31
10000a54:	ee03 3a90 	vmov	s7, r3
10000a58:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10000a5c:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10000a60:	ed90 8b00 	vldr	d8, [r0]
10000a64:	ed8d ab02 	vstr	d10, [sp, #8]
10000a68:	ee2b 1b47 	vnmul.f64	d1, d11, d7
10000a6c:	ed9d ab04 	vldr	d10, [sp, #16]
10000a70:	eeaa 1b08 	vfma.f64	d1, d10, d8
10000a74:	ee24 4b47 	vnmul.f64	d4, d4, d7
10000a78:	eea0 4b08 	vfma.f64	d4, d0, d8
10000a7c:	eeb8 3be3 	vcvt.f64.s32	d3, s7
10000a80:	ee34 4b07 	vadd.f64	d4, d4, d7
10000a84:	ed9d 8b0a 	vldr	d8, [sp, #40]	@ 0x28
10000a88:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10000a8c:	ed90 ab02 	vldr	d10, [r0, #8]
10000a90:	ed8d 3b1a 	vstr	d3, [sp, #104]	@ 0x68
10000a94:	ed8d 4b10 	vstr	d4, [sp, #64]	@ 0x40
10000a98:	ee2c 3b47 	vnmul.f64	d3, d12, d7
10000a9c:	ed90 4b0a 	vldr	d4, [r0, #40]	@ 0x28
10000aa0:	eeaf 3b04 	vfma.f64	d3, d15, d4
10000aa4:	ee26 6b47 	vnmul.f64	d6, d6, d7
10000aa8:	eea2 6b04 	vfma.f64	d6, d2, d4
10000aac:	ee28 8b47 	vnmul.f64	d8, d8, d7
10000ab0:	eea0 8b0a 	vfma.f64	d8, d0, d10
10000ab4:	ee33 4b07 	vadd.f64	d4, d3, d7
10000ab8:	ed9d ab08 	vldr	d10, [sp, #32]
10000abc:	ee36 3b07 	vadd.f64	d3, d6, d7
10000ac0:	ed90 9b1a 	vldr	d9, [r0, #104]	@ 0x68
10000ac4:	ed90 0b0c 	vldr	d0, [r0, #48]	@ 0x30
10000ac8:	ed9d 6b02 	vldr	d6, [sp, #8]
10000acc:	ed8d 3b0e 	vstr	d3, [sp, #56]	@ 0x38
10000ad0:	ee2a 3b47 	vnmul.f64	d3, d10, d7
10000ad4:	eea2 3b00 	vfma.f64	d3, d2, d0
10000ad8:	ed9d 2b00 	vldr	d2, [sp]
10000adc:	ee29 ab02 	vmul.f64	d10, d9, d2
10000ae0:	ee29 9b06 	vmul.f64	d9, d9, d6
10000ae4:	ee31 1b07 	vadd.f64	d1, d1, d7
10000ae8:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10000aec:	ee21 0b05 	vmul.f64	d0, d1, d5
10000af0:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10000af4:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10000af8:	ed8d 9b0c 	vstr	d9, [sp, #48]	@ 0x30
10000afc:	ee24 9b05 	vmul.f64	d9, d4, d5
10000b00:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10000b04:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10000b08:	ee00 1b47 	vmls.f64	d1, d0, d7
10000b0c:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10000b10:	ee3b 0b00 	vadd.f64	d0, d11, d0
10000b14:	eeb0 bb44 	vmov.f64	d11, d4
10000b18:	ee09 bb47 	vmls.f64	d11, d9, d7
10000b1c:	ee38 8b07 	vadd.f64	d8, d8, d7
10000b20:	ed8d 1b12 	vstr	d1, [sp, #72]	@ 0x48
10000b24:	ed8d bb16 	vstr	d11, [sp, #88]	@ 0x58
10000b28:	ed90 bb18 	vldr	d11, [r0, #96]	@ 0x60
10000b2c:	ee2b 4b02 	vmul.f64	d4, d11, d2
10000b30:	ee28 2b05 	vmul.f64	d2, d8, d5
10000b34:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10000b38:	ed9d 1b0a 	vldr	d1, [sp, #40]	@ 0x28
10000b3c:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10000b40:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10000b44:	ee02 8b47 	vmls.f64	d8, d2, d7
10000b48:	ee31 2b02 	vadd.f64	d2, d1, d2
10000b4c:	eeb7 1b00 	vmov.f64	d1, #112	@ 0x3f800000  1.0
10000b50:	ee33 3b07 	vadd.f64	d3, d3, d7
10000b54:	ee2b 6b06 	vmul.f64	d6, d11, d6
10000b58:	ee3c 9b09 	vadd.f64	d9, d12, d9
10000b5c:	eeb8 bb44 	vcvt.f64.u32	d11, s8
10000b60:	ed9d cb12 	vldr	d12, [sp, #72]	@ 0x48
10000b64:	ee3d 4b41 	vsub.f64	d4, d13, d1
10000b68:	ed8d bb06 	vstr	d11, [sp, #24]
10000b6c:	ee34 4b0c 	vadd.f64	d4, d4, d12
10000b70:	ee23 bb05 	vmul.f64	d11, d3, d5
10000b74:	ee34 cb08 	vadd.f64	d12, d4, d8
10000b78:	eebc bbcb 	vcvt.u32.f64	s22, d11
10000b7c:	ee3e 8b41 	vsub.f64	d8, d14, d1
10000b80:	ed9d 4b16 	vldr	d4, [sp, #88]	@ 0x58
10000b84:	eebc abca 	vcvt.u32.f64	s20, d10
10000b88:	ee38 8b04 	vadd.f64	d8, d8, d4
10000b8c:	eeb8 4b4b 	vcvt.f64.u32	d4, s22
10000b90:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10000b94:	ee04 3b47 	vmls.f64	d3, d4, d7
10000b98:	ed9d bb00 	vldr	d11, [sp]
10000b9c:	ee32 2b41 	vsub.f64	d2, d2, d1
10000ba0:	ee38 8b03 	vadd.f64	d8, d8, d3
10000ba4:	ed90 db16 	vldr	d13, [r0, #88]	@ 0x58
10000ba8:	ee2a 3b47 	vnmul.f64	d3, d10, d7
10000bac:	eeab 3b0d 	vfma.f64	d3, d11, d13
10000bb0:	ee30 0b41 	vsub.f64	d0, d0, d1
10000bb4:	ee33 3b07 	vadd.f64	d3, d3, d7
10000bb8:	ee30 0b02 	vadd.f64	d0, d0, d2
10000bbc:	ee23 3b05 	vmul.f64	d3, d3, d5
10000bc0:	ed9d 2b08 	vldr	d2, [sp, #32]
10000bc4:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10000bc8:	ee32 4b04 	vadd.f64	d4, d2, d4
10000bcc:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10000bd0:	ee34 4b41 	vsub.f64	d4, d4, d1
10000bd4:	ee39 9b41 	vsub.f64	d9, d9, d1
10000bd8:	ed9d 2b06 	vldr	d2, [sp, #24]
10000bdc:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10000be0:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10000be4:	ee39 9b04 	vadd.f64	d9, d9, d4
10000be8:	ee26 6b47 	vnmul.f64	d6, d6, d7
10000bec:	ed90 4b14 	vldr	d4, [r0, #80]	@ 0x50
10000bf0:	ee22 2b47 	vnmul.f64	d2, d2, d7
10000bf4:	eeab 2b04 	vfma.f64	d2, d11, d4
10000bf8:	ee33 3b0a 	vadd.f64	d3, d3, d10
10000bfc:	ed9d ab02 	vldr	d10, [sp, #8]
10000c00:	eeaa 6b04 	vfma.f64	d6, d10, d4
10000c04:	ed9d 4b10 	vldr	d4, [sp, #64]	@ 0x40
10000c08:	ee24 ab05 	vmul.f64	d10, d4, d5
10000c0c:	ed9d db0e 	vldr	d13, [sp, #56]	@ 0x38
10000c10:	eebc abca 	vcvt.u32.f64	s20, d10
10000c14:	ee2d bb05 	vmul.f64	d11, d13, d5
10000c18:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10000c1c:	eebc bbcb 	vcvt.u32.f64	s22, d11
10000c20:	ee0a 4b47 	vmls.f64	d4, d10, d7
10000c24:	eeb8 bb4b 	vcvt.f64.u32	d11, s22
10000c28:	ee34 4b00 	vadd.f64	d4, d4, d0
10000c2c:	eeb0 0b4d 	vmov.f64	d0, d13
10000c30:	ee32 2b07 	vadd.f64	d2, d2, d7
10000c34:	ee0b 0b47 	vmls.f64	d0, d11, d7
10000c38:	ed9d eb0c 	vldr	d14, [sp, #48]	@ 0x30
10000c3c:	ed90 bb16 	vldr	d11, [r0, #88]	@ 0x58
10000c40:	ed9d ab02 	vldr	d10, [sp, #8]
10000c44:	ee30 0b09 	vadd.f64	d0, d0, d9
10000c48:	ee2e 9b47 	vnmul.f64	d9, d14, d7
10000c4c:	eeaa 9b0b 	vfma.f64	d9, d10, d11
10000c50:	ee22 ab05 	vmul.f64	d10, d2, d5
10000c54:	eefc bbca 	vcvt.u32.f64	s23, d10
10000c58:	ee2c ab05 	vmul.f64	d10, d12, d5
10000c5c:	eebc bbca 	vcvt.u32.f64	s22, d10
10000c60:	eeb8 ab6b 	vcvt.f64.u32	d10, s23
10000c64:	ee33 3b41 	vsub.f64	d3, d3, d1
10000c68:	ee0a 2b47 	vmls.f64	d2, d10, d7
10000c6c:	ee33 3b02 	vadd.f64	d3, d3, d2
10000c70:	eeb8 2b4b 	vcvt.f64.u32	d2, s22
10000c74:	eeb0 bb4c 	vmov.f64	d11, d12
10000c78:	ee39 9b07 	vadd.f64	d9, d9, d7
10000c7c:	ee02 bb47 	vmls.f64	d11, d2, d7
10000c80:	ee34 4b02 	vadd.f64	d4, d4, d2
10000c84:	ee28 2b05 	vmul.f64	d2, d8, d5
10000c88:	ee29 cb05 	vmul.f64	d12, d9, d5
10000c8c:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10000c90:	eebc cbcc 	vcvt.u32.f64	s24, d12
10000c94:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10000c98:	ed9d db06 	vldr	d13, [sp, #24]
10000c9c:	ee02 8b47 	vmls.f64	d8, d2, d7
10000ca0:	ee30 0b02 	vadd.f64	d0, d0, d2
10000ca4:	eeb8 2b4c 	vcvt.f64.u32	d2, s24
10000ca8:	ee3d ab0a 	vadd.f64	d10, d13, d10
10000cac:	ee02 9b47 	vmls.f64	d9, d2, d7
10000cb0:	ee3e 2b02 	vadd.f64	d2, d14, d2
10000cb4:	ee33 3b09 	vadd.f64	d3, d3, d9
10000cb8:	ee32 2b41 	vsub.f64	d2, d2, d1
10000cbc:	ed9f 9b2e 	vldr	d9, [pc, #184]	@ 10000d78 <fp64e_cmul_prepared+0x450>
10000cc0:	ee3a ab41 	vsub.f64	d10, d10, d1
10000cc4:	ed90 cb02 	vldr	d12, [r0, #8]
10000cc8:	ee3a ab02 	vadd.f64	d10, d10, d2
10000ccc:	ee34 4b09 	vadd.f64	d4, d4, d9
10000cd0:	ed9d 2b14 	vldr	d2, [sp, #80]	@ 0x50
10000cd4:	ee36 6b07 	vadd.f64	d6, d6, d7
10000cd8:	ee02 4b4c 	vmls.f64	d4, d2, d12
10000cdc:	ee30 0b09 	vadd.f64	d0, d0, d9
10000ce0:	ed9d 2b18 	vldr	d2, [sp, #96]	@ 0x60
10000ce4:	ed90 cb0c 	vldr	d12, [r0, #48]	@ 0x30
10000ce8:	ee02 0b4c 	vmls.f64	d0, d2, d12
10000cec:	ee26 cb05 	vmul.f64	d12, d6, d5
10000cf0:	eebc cbcc 	vcvt.u32.f64	s24, d12
10000cf4:	ed90 2b08 	vldr	d2, [r0, #32]
10000cf8:	ed9d db04 	vldr	d13, [sp, #16]
10000cfc:	eeb8 cb4c 	vcvt.f64.u32	d12, s24
10000d00:	ee0d 4b42 	vmls.f64	d4, d13, d2
10000d04:	ee0c 6b47 	vmls.f64	d6, d12, d7
10000d08:	ed90 2b12 	vldr	d2, [r0, #72]	@ 0x48
10000d0c:	ee36 6b0a 	vadd.f64	d6, d6, d10
10000d10:	ee0f 0b42 	vmls.f64	d0, d15, d2
10000d14:	ee24 ab05 	vmul.f64	d10, d4, d5
10000d18:	ee23 2b05 	vmul.f64	d2, d3, d5
10000d1c:	eebc abca 	vcvt.u32.f64	s20, d10
10000d20:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10000d24:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10000d28:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10000d2c:	ee0a 4b47 	vmls.f64	d4, d10, d7
10000d30:	ee36 6b02 	vadd.f64	d6, d6, d2
10000d34:	ee20 ab05 	vmul.f64	d10, d0, d5
10000d38:	ee02 3b47 	vmls.f64	d3, d2, d7
10000d3c:	ee36 6b09 	vadd.f64	d6, d6, d9
10000d40:	ed9d 2b1a 	vldr	d2, [sp, #104]	@ 0x68
10000d44:	ed90 9b16 	vldr	d9, [r0, #88]	@ 0x58
10000d48:	eebc abca 	vcvt.u32.f64	s20, d10
10000d4c:	ee02 6b49 	vmls.f64	d6, d2, d9
10000d50:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10000d54:	ee38 2b0b 	vadd.f64	d2, d8, d11
10000d58:	ee0a 0b47 	vmls.f64	d0, d10, d7
10000d5c:	ee22 ab05 	vmul.f64	d10, d2, d5
10000d60:	ee3b 9b07 	vadd.f64	d9, d11, d7
10000d64:	e00c      	b.n	10000d80 <fp64e_cmul_prepared+0x458>
10000d66:	bf00      	nop
10000d68:	00000000 	.word	0x00000000
10000d6c:	3df00000 	.word	0x3df00000
10000d70:	00000000 	.word	0x00000000
10000d74:	41f00000 	.word	0x41f00000
10000d78:	00000000 	.word	0x00000000
10000d7c:	42000000 	.word	0x42000000
10000d80:	eebc abca 	vcvt.u32.f64	s20, d10
10000d84:	ee39 9b48 	vsub.f64	d9, d9, d8
10000d88:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10000d8c:	ed90 8b1c 	vldr	d8, [r0, #112]	@ 0x70
10000d90:	ed9d bb00 	vldr	d11, [sp]
10000d94:	ee0a 2b47 	vmls.f64	d2, d10, d7
10000d98:	ee0b 6b48 	vmls.f64	d6, d11, d8
10000d9c:	ee33 3b07 	vadd.f64	d3, d3, d7
10000da0:	ee30 8b04 	vadd.f64	d8, d0, d4
10000da4:	ee33 3b42 	vsub.f64	d3, d3, d2
10000da8:	ee38 8b0a 	vadd.f64	d8, d8, d10
10000dac:	ee26 2b05 	vmul.f64	d2, d6, d5
10000db0:	ee34 4b07 	vadd.f64	d4, d4, d7
10000db4:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10000db8:	ee34 0b40 	vsub.f64	d0, d4, d0
10000dbc:	ee28 4b05 	vmul.f64	d4, d8, d5
10000dc0:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10000dc4:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10000dc8:	ee02 6b47 	vmls.f64	d6, d2, d7
10000dcc:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10000dd0:	ee36 2b07 	vadd.f64	d2, d6, d7
10000dd4:	ee04 8b47 	vmls.f64	d8, d4, d7
10000dd8:	ee29 6b05 	vmul.f64	d6, d9, d5
10000ddc:	ee23 4b05 	vmul.f64	d4, d3, d5
10000de0:	ee32 2b48 	vsub.f64	d2, d2, d8
10000de4:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10000de8:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10000dec:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10000df0:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10000df4:	ee30 0b41 	vsub.f64	d0, d0, d1
10000df8:	ee32 2b41 	vsub.f64	d2, d2, d1
10000dfc:	ee30 0b06 	vadd.f64	d0, d0, d6
10000e00:	ee32 2b04 	vadd.f64	d2, d2, d4
10000e04:	eeb0 1b49 	vmov.f64	d1, d9
10000e08:	ee06 1b47 	vmls.f64	d1, d6, d7
10000e0c:	ee20 6b05 	vmul.f64	d6, d0, d5
10000e10:	ee22 5b05 	vmul.f64	d5, d2, d5
10000e14:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10000e18:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10000e1c:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10000e20:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10000e24:	ee06 0b47 	vmls.f64	d0, d6, d7
10000e28:	ee04 3b47 	vmls.f64	d3, d4, d7
10000e2c:	ee05 2b47 	vmls.f64	d2, d5, d7
10000e30:	b034      	add	sp, #208	@ 0xd0
10000e32:	ecbd 8b10 	vpop	{d8-d15}
10000e36:	4770      	bx	lr

