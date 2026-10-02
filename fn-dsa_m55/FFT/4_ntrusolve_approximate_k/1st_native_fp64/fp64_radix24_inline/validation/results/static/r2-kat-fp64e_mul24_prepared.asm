
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/r2-kat/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10004c30 <fp64e_mul24_prepared>:
10004c30:	ed9f 6b51 	vldr	d6, [pc, #324]	@ 10004d78 <fp64e_mul24_prepared+0x148>
10004c34:	eeb0 2b40 	vmov.f64	d2, d0
10004c38:	ed9f 7b51 	vldr	d7, [pc, #324]	@ 10004d80 <fp64e_mul24_prepared+0x150>
10004c3c:	ee22 4b07 	vmul.f64	d4, d2, d7
10004c40:	ee21 7b06 	vmul.f64	d7, d1, d6
10004c44:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10004c48:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10004c4c:	eefc 7bc2 	vcvt.u32.f64	s15, d2
10004c50:	ed2d 8b10 	vpush	{d8-d15}
10004c54:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10004c58:	ed9f 8b4b 	vldr	d8, [pc, #300]	@ 10004d88 <fp64e_mul24_prepared+0x158>
10004c5c:	ee17 3a90 	vmov	r3, s15
10004c60:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10004c64:	eeb0 0b41 	vmov.f64	d0, d1
10004c68:	ee04 2b48 	vmls.f64	d2, d4, d8
10004c6c:	ed9f 9b48 	vldr	d9, [pc, #288]	@ 10004d90 <fp64e_mul24_prepared+0x160>
10004c70:	eeb0 1b47 	vmov.f64	d1, d7
10004c74:	0fdb      	lsrs	r3, r3, #31
10004c76:	ed9f 3b48 	vldr	d3, [pc, #288]	@ 10004d98 <fp64e_mul24_prepared+0x168>
10004c7a:	ee02 1b09 	vmla.f64	d1, d2, d9
10004c7e:	ee05 3a90 	vmov	s11, r3
10004c82:	eeb0 2b40 	vmov.f64	d2, d0
10004c86:	eeb8 ebe5 	vcvt.f64.s32	d14, s11
10004c8a:	ee07 2b43 	vmls.f64	d2, d7, d3
10004c8e:	ed90 fb02 	vldr	d15, [r0, #8]
10004c92:	ed90 db04 	vldr	d13, [r0, #16]
10004c96:	ed90 5b00 	vldr	d5, [r0]
10004c9a:	ee22 7b05 	vmul.f64	d7, d2, d5
10004c9e:	ee22 ab0f 	vmul.f64	d10, d2, d15
10004ca2:	ee22 bb0d 	vmul.f64	d11, d2, d13
10004ca6:	ee21 cb0d 	vmul.f64	d12, d1, d13
10004caa:	ee01 ab05 	vmla.f64	d10, d1, d5
10004cae:	ee01 bb0f 	vmla.f64	d11, d1, d15
10004cb2:	ee04 cb0f 	vmla.f64	d12, d4, d15
10004cb6:	ee04 bb05 	vmla.f64	d11, d4, d5
10004cba:	ee27 7b06 	vmul.f64	d7, d7, d6
10004cbe:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10004cc2:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10004cc6:	ee37 7b0a 	vadd.f64	d7, d7, d10
10004cca:	ee27 2b06 	vmul.f64	d2, d7, d6
10004cce:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10004cd2:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10004cd6:	ed9f 4b32 	vldr	d4, [pc, #200]	@ 10004da0 <fp64e_mul24_prepared+0x170>
10004cda:	ee3b ab02 	vadd.f64	d10, d11, d2
10004cde:	ee02 7b43 	vmls.f64	d7, d2, d3
10004ce2:	ee27 7b04 	vmul.f64	d7, d7, d4
10004ce6:	ee2a 4b06 	vmul.f64	d4, d10, d6
10004cea:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10004cee:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10004cf2:	eeb8 1b47 	vcvt.f64.u32	d1, s14
10004cf6:	eeb8 7b44 	vcvt.f64.u32	d7, s8
10004cfa:	ed90 5b08 	vldr	d5, [r0, #32]
10004cfe:	ee3c 4b07 	vadd.f64	d4, d12, d7
10004d02:	ee07 ab43 	vmls.f64	d10, d7, d3
10004d06:	ed9f 7b1e 	vldr	d7, [pc, #120]	@ 10004d80 <fp64e_mul24_prepared+0x150>
10004d0a:	b08e      	sub	sp, #56	@ 0x38
10004d0c:	ed8d 5b00 	vstr	d5, [sp]
10004d10:	ee24 6b06 	vmul.f64	d6, d4, d6
10004d14:	ee2a 5b07 	vmul.f64	d5, d10, d7
10004d18:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10004d1c:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10004d20:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10004d24:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10004d28:	ee06 4b43 	vmls.f64	d4, d6, d3
10004d2c:	eeb0 7b45 	vmov.f64	d7, d5
10004d30:	ed9f db1d 	vldr	d13, [pc, #116]	@ 10004da8 <fp64e_mul24_prepared+0x178>
10004d34:	ee04 7b09 	vmla.f64	d7, d4, d9
10004d38:	ed90 fb06 	vldr	d15, [r0, #24]
10004d3c:	ee37 7b0d 	vadd.f64	d7, d7, d13
10004d40:	ee05 ab48 	vmls.f64	d10, d5, d8
10004d44:	ee0e 7b4f 	vmls.f64	d7, d14, d15
10004d48:	ed9d 5b00 	vldr	d5, [sp]
10004d4c:	ed9f 6b18 	vldr	d6, [pc, #96]	@ 10004db0 <fp64e_mul24_prepared+0x180>
10004d50:	ee00 7b45 	vmls.f64	d7, d0, d5
10004d54:	ee27 6b06 	vmul.f64	d6, d7, d6
10004d58:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10004d5c:	ed9f 5b16 	vldr	d5, [pc, #88]	@ 10004db8 <fp64e_mul24_prepared+0x188>
10004d60:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10004d64:	ee06 7b45 	vmls.f64	d7, d6, d5
10004d68:	ee0a 1b08 	vmla.f64	d1, d10, d8
10004d6c:	eeb0 0b47 	vmov.f64	d0, d7
10004d70:	b00e      	add	sp, #56	@ 0x38
10004d72:	ecbd 8b10 	vpop	{d8-d15}
10004d76:	4770      	bx	lr
10004d78:	00000000 	.word	0x00000000
10004d7c:	3e700000 	.word	0x3e700000
10004d80:	00000000 	.word	0x00000000
10004d84:	3ef00000 	.word	0x3ef00000
10004d88:	00000000 	.word	0x00000000
10004d8c:	40f00000 	.word	0x40f00000
10004d90:	00000000 	.word	0x00000000
10004d94:	40700000 	.word	0x40700000
10004d98:	00000000 	.word	0x00000000
10004d9c:	41700000 	.word	0x41700000
10004da0:	00000000 	.word	0x00000000
10004da4:	3f700000 	.word	0x3f700000
10004da8:	00000000 	.word	0x00000000
10004dac:	42000000 	.word	0x42000000
10004db0:	00000000 	.word	0x00000000
10004db4:	3df00000 	.word	0x3df00000
10004db8:	00000000 	.word	0x00000000
10004dbc:	41f00000 	.word	0x41f00000
