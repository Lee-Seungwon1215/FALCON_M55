
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_kat_exact_inlineasm/validation/build/kernels/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10005c68 <fndsa_fp64e_mul>:
10005c68:	ed2d 8b0e 	vpush	{d8-d14}
10005c6c:	4b64      	ldr	r3, [pc, #400]	@ (10005e00 <fndsa_fp64e_mul+0x198>)
10005c6e:	b090      	sub	sp, #64	@ 0x40
10005c70:	ed8d 0b08 	vstr	d0, [sp, #32]
10005c74:	ed8d 1b0a 	vstr	d1, [sp, #40]	@ 0x28
10005c78:	ed8d 2b04 	vstr	d2, [sp, #16]
10005c7c:	ed8d 3b06 	vstr	d3, [sp, #24]
10005c80:	eebc 4bc0 	vcvt.u32.f64	s8, d0
10005c84:	ee14 2a10 	vmov	r2, s8
10005c88:	0fd2      	lsrs	r2, r2, #31
10005c8a:	ee04 2a10 	vmov	s8, r2
10005c8e:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10005c92:	ee24 eb03 	vmul.f64	d14, d4, d3
10005c96:	eebc 4bc2 	vcvt.u32.f64	s8, d2
10005c9a:	ee14 2a10 	vmov	r2, s8
10005c9e:	0fd2      	lsrs	r2, r2, #31
10005ca0:	ee04 2a10 	vmov	s8, r2
10005ca4:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10005ca8:	ee04 eb01 	vmla.f64	d14, d4, d1
10005cac:	eeb0 8b40 	vmov.f64	d8, d0
10005cb0:	eeb0 9b41 	vmov.f64	d9, d1
10005cb4:	eeb0 ab42 	vmov.f64	d10, d2
10005cb8:	eeb0 bb43 	vmov.f64	d11, d3
10005cbc:	ed93 cb00 	vldr	d12, [r3]
10005cc0:	ed93 db02 	vldr	d13, [r3, #8]
10005cc4:	ee29 1b0d 	vmul.f64	d1, d9, d13
10005cc8:	ee28 3b0d 	vmul.f64	d3, d8, d13
10005ccc:	ee2b 5b0d 	vmul.f64	d5, d11, d13
10005cd0:	ee2a 7b0d 	vmul.f64	d7, d10, d13
10005cd4:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10005cd8:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10005cdc:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10005ce0:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005ce4:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10005ce8:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10005cec:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10005cf0:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005cf4:	eeb0 0b49 	vmov.f64	d0, d9
10005cf8:	eeb0 2b48 	vmov.f64	d2, d8
10005cfc:	eeb0 4b4b 	vmov.f64	d4, d11
10005d00:	eeb0 6b4a 	vmov.f64	d6, d10
10005d04:	ee01 0b4c 	vmls.f64	d0, d1, d12
10005d08:	ee03 2b4c 	vmls.f64	d2, d3, d12
10005d0c:	ee05 4b4c 	vmls.f64	d4, d5, d12
10005d10:	ee07 6b4c 	vmls.f64	d6, d7, d12
10005d14:	ee20 8b04 	vmul.f64	d8, d0, d4
10005d18:	ee28 9b0d 	vmul.f64	d9, d8, d13
10005d1c:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10005d20:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10005d24:	eeb0 8b49 	vmov.f64	d8, d9
10005d28:	ee00 8b05 	vmla.f64	d8, d0, d5
10005d2c:	ee01 8b04 	vmla.f64	d8, d1, d4
10005d30:	ee28 9b0d 	vmul.f64	d9, d8, d13
10005d34:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10005d38:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10005d3c:	eeb0 8b49 	vmov.f64	d8, d9
10005d40:	ee00 8b06 	vmla.f64	d8, d0, d6
10005d44:	ee01 8b05 	vmla.f64	d8, d1, d5
10005d48:	ee02 8b04 	vmla.f64	d8, d2, d4
10005d4c:	ee28 9b0d 	vmul.f64	d9, d8, d13
10005d50:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10005d54:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10005d58:	ee09 8b4c 	vmls.f64	d8, d9, d12
10005d5c:	eeb0 ab48 	vmov.f64	d10, d8
10005d60:	eeb0 8b49 	vmov.f64	d8, d9
10005d64:	ee00 8b07 	vmla.f64	d8, d0, d7
10005d68:	ee01 8b06 	vmla.f64	d8, d1, d6
10005d6c:	ee02 8b05 	vmla.f64	d8, d2, d5
10005d70:	ee03 8b04 	vmla.f64	d8, d3, d4
10005d74:	ee28 9b0d 	vmul.f64	d9, d8, d13
10005d78:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10005d7c:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10005d80:	ee09 8b4c 	vmls.f64	d8, d9, d12
10005d84:	ee08 ab0c 	vmla.f64	d10, d8, d12
10005d88:	eeb0 8b49 	vmov.f64	d8, d9
10005d8c:	ee01 8b07 	vmla.f64	d8, d1, d7
10005d90:	ee02 8b06 	vmla.f64	d8, d2, d6
10005d94:	ee03 8b05 	vmla.f64	d8, d3, d5
10005d98:	ee28 9b0d 	vmul.f64	d9, d8, d13
10005d9c:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10005da0:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10005da4:	ee09 8b4c 	vmls.f64	d8, d9, d12
10005da8:	eeb0 bb48 	vmov.f64	d11, d8
10005dac:	eeb0 8b49 	vmov.f64	d8, d9
10005db0:	ee02 8b07 	vmla.f64	d8, d2, d7
10005db4:	ee03 8b06 	vmla.f64	d8, d3, d6
10005db8:	ee28 9b0d 	vmul.f64	d9, d8, d13
10005dbc:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10005dc0:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10005dc4:	ee09 8b4c 	vmls.f64	d8, d9, d12
10005dc8:	ee08 bb0c 	vmla.f64	d11, d8, d12
10005dcc:	ed93 cb04 	vldr	d12, [r3, #16]
10005dd0:	ee3b bb0c 	vadd.f64	d11, d11, d12
10005dd4:	ee3b bb4e 	vsub.f64	d11, d11, d14
10005dd8:	ed93 cb06 	vldr	d12, [r3, #24]
10005ddc:	ed93 db08 	vldr	d13, [r3, #32]
10005de0:	ee2b 9b0d 	vmul.f64	d9, d11, d13
10005de4:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10005de8:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10005dec:	ee09 bb4c 	vmls.f64	d11, d9, d12
10005df0:	eeb0 0b4b 	vmov.f64	d0, d11
10005df4:	eeb0 1b4a 	vmov.f64	d1, d10
10005df8:	b010      	add	sp, #64	@ 0x40
10005dfa:	ecbd 8b0e 	vpop	{d8-d14}
10005dfe:	4770      	bx	lr
10005e00:	30004a40 	.word	0x30004a40
