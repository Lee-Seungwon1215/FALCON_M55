
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/r2-kat/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

100059f0 <fndsa_vect_iFFT_fp64_exact>:
100059f0:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
100059f4:	ed2d 8b10 	vpush	{d8-d15}
100059f8:	1e44      	subs	r4, r0, #1
100059fa:	b0c3      	sub	sp, #268	@ 0x10c
100059fc:	f000 8335 	beq.w	1000606a <fndsa_vect_iFFT_fp64_exact+0x67a>
10005a00:	2310      	movs	r3, #16
10005a02:	f04f 0c01 	mov.w	ip, #1
10005a06:	ed9f abf2 	vldr	d10, [pc, #968]	@ 10005dd0 <fndsa_vect_iFFT_fp64_exact+0x3e0>
10005a0a:	ed9f ebf3 	vldr	d14, [pc, #972]	@ 10005dd8 <fndsa_vect_iFFT_fp64_exact+0x3e8>
10005a0e:	ed9f fbf4 	vldr	d15, [pc, #976]	@ 10005de0 <fndsa_vect_iFFT_fp64_exact+0x3f0>
10005a12:	fa03 f604 	lsl.w	r6, r3, r4
10005a16:	2301      	movs	r3, #1
10005a18:	4660      	mov	r0, ip
10005a1a:	f04f 0810 	mov.w	r8, #16
10005a1e:	46b2      	mov	sl, r6
10005a20:	f04f 0b00 	mov.w	fp, #0
10005a24:	460e      	mov	r6, r1
10005a26:	fa0c fc03 	lsl.w	ip, ip, r3
10005a2a:	4afb      	ldr	r2, [pc, #1004]	@ (10005e18 <fndsa_vect_iFFT_fp64_exact+0x428>)
10005a2c:	40a3      	lsls	r3, r4
10005a2e:	eb03 0353 	add.w	r3, r3, r3, lsr #1
10005a32:	eb02 1303 	add.w	r3, r2, r3, lsl #4
10005a36:	e9cd c307 	strd	ip, r3, [sp, #28]
10005a3a:	e9cd 0409 	strd	r0, r4, [sp, #36]	@ 0x24
10005a3e:	fa08 f804 	lsl.w	r8, r8, r4
10005a42:	4490      	add	r8, r2
10005a44:	eb01 1700 	add.w	r7, r1, r0, lsl #4
10005a48:	910b      	str	r1, [sp, #44]	@ 0x2c
10005a4a:	ea4f 190c 	mov.w	r9, ip, lsl #4
10005a4e:	edd8 7a02 	vldr	s15, [r8, #8]
10005a52:	f8d8 3004 	ldr.w	r3, [r8, #4]
10005a56:	eeb8 5b67 	vcvt.f64.u32	d5, s15
10005a5a:	0fdb      	lsrs	r3, r3, #31
10005a5c:	ee03 3a10 	vmov	s6, r3
10005a60:	ee3a 5b45 	vsub.f64	d5, d10, d5
10005a64:	eeb8 3bc3 	vcvt.f64.s32	d3, s6
10005a68:	edd8 7a03 	vldr	s15, [r8, #12]
10005a6c:	ed8d 3b2c 	vstr	d3, [sp, #176]	@ 0xb0
10005a70:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10005a74:	ee25 3b0e 	vmul.f64	d3, d5, d14
10005a78:	eeb7 bb00 	vmov.f64	d11, #112	@ 0x3f800000  1.0
10005a7c:	edd8 6a00 	vldr	s13, [r8]
10005a80:	edd8 4a01 	vldr	s9, [r8, #4]
10005a84:	ee3a 7b47 	vsub.f64	d7, d10, d7
10005a88:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10005a8c:	eeb8 6b66 	vcvt.f64.u32	d6, s13
10005a90:	eeb8 4b64 	vcvt.f64.u32	d4, s9
10005a94:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10005a98:	ed9f 0bd3 	vldr	d0, [pc, #844]	@ 10005de8 <fndsa_vect_iFFT_fp64_exact+0x3f8>
10005a9c:	ed9f 8bd4 	vldr	d8, [pc, #848]	@ 10005df0 <fndsa_vect_iFFT_fp64_exact+0x400>
10005aa0:	ee37 7b4b 	vsub.f64	d7, d7, d11
10005aa4:	ee03 5b4a 	vmls.f64	d5, d3, d10
10005aa8:	ee37 7b03 	vadd.f64	d7, d7, d3
10005aac:	ee24 2b00 	vmul.f64	d2, d4, d0
10005ab0:	ee26 3b08 	vmul.f64	d3, d6, d8
10005ab4:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10005ab8:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10005abc:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10005ac0:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10005ac4:	ed9f 9bcc 	vldr	d9, [pc, #816]	@ 10005df8 <fndsa_vect_iFFT_fp64_exact+0x408>
10005ac8:	eeb0 1b44 	vmov.f64	d1, d4
10005acc:	ed9f cbcc 	vldr	d12, [pc, #816]	@ 10005e00 <fndsa_vect_iFFT_fp64_exact+0x410>
10005ad0:	ee02 1b49 	vmls.f64	d1, d2, d9
10005ad4:	ed8d 2b28 	vstr	d2, [sp, #160]	@ 0xa0
10005ad8:	eeb0 2b43 	vmov.f64	d2, d3
10005adc:	ee01 2b0c 	vmla.f64	d2, d1, d12
10005ae0:	ed9f dbc9 	vldr	d13, [pc, #804]	@ 10005e08 <fndsa_vect_iFFT_fp64_exact+0x418>
10005ae4:	ed8d 2b26 	vstr	d2, [sp, #152]	@ 0x98
10005ae8:	eeb0 2b46 	vmov.f64	d2, d6
10005aec:	ee03 2b4d 	vmls.f64	d2, d3, d13
10005af0:	ee27 3b0e 	vmul.f64	d3, d7, d14
10005af4:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10005af8:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10005afc:	ee03 7b4a 	vmls.f64	d7, d3, d10
10005b00:	eebc 3bc7 	vcvt.u32.f64	s6, d7
10005b04:	ee13 2a10 	vmov	r2, s6
10005b08:	0fd2      	lsrs	r2, r2, #31
10005b0a:	ee03 2a10 	vmov	s6, r2
10005b0e:	ed8d 6b2a 	vstr	d6, [sp, #168]	@ 0xa8
10005b12:	eeb8 3bc3 	vcvt.f64.s32	d3, s6
10005b16:	ee35 6b06 	vadd.f64	d6, d5, d6
10005b1a:	ed8d 3b36 	vstr	d3, [sp, #216]	@ 0xd8
10005b1e:	ee26 3b0e 	vmul.f64	d3, d6, d14
10005b22:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10005b26:	ee37 4b04 	vadd.f64	d4, d7, d4
10005b2a:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10005b2e:	ee34 4b03 	vadd.f64	d4, d4, d3
10005b32:	ee03 6b4a 	vmls.f64	d6, d3, d10
10005b36:	ed8d 2b24 	vstr	d2, [sp, #144]	@ 0x90
10005b3a:	ee26 3b08 	vmul.f64	d3, d6, d8
10005b3e:	ee24 2b0e 	vmul.f64	d2, d4, d14
10005b42:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10005b46:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10005b4a:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10005b4e:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10005b52:	ed8d 6b3e 	vstr	d6, [sp, #248]	@ 0xf8
10005b56:	ee02 4b4a 	vmls.f64	d4, d2, d10
10005b5a:	ee03 6b4d 	vmls.f64	d6, d3, d13
10005b5e:	ed8d 6b38 	vstr	d6, [sp, #224]	@ 0xe0
10005b62:	eebc 6bc4 	vcvt.u32.f64	s12, d4
10005b66:	ee16 2a10 	vmov	r2, s12
10005b6a:	0fd2      	lsrs	r2, r2, #31
10005b6c:	ee06 2a10 	vmov	s12, r2
10005b70:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10005b74:	ed8d 6b40 	vstr	d6, [sp, #256]	@ 0x100
10005b78:	ee27 6b00 	vmul.f64	d6, d7, d0
10005b7c:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10005b80:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005b84:	ee06 7b49 	vmls.f64	d7, d6, d9
10005b88:	ed8d 6b32 	vstr	d6, [sp, #200]	@ 0xc8
10005b8c:	ee24 6b00 	vmul.f64	d6, d4, d0
10005b90:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10005b94:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005b98:	ee06 4b49 	vmls.f64	d4, d6, d9
10005b9c:	ed8d 6b3c 	vstr	d6, [sp, #240]	@ 0xf0
10005ba0:	ee25 6b08 	vmul.f64	d6, d5, d8
10005ba4:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10005ba8:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005bac:	ed8d 5b34 	vstr	d5, [sp, #208]	@ 0xd0
10005bb0:	ee04 3b0c 	vmla.f64	d3, d4, d12
10005bb4:	ee06 5b4d 	vmls.f64	d5, d6, d13
10005bb8:	ee07 6b0c 	vmla.f64	d6, d7, d12
10005bbc:	9b09      	ldr	r3, [sp, #36]	@ 0x24
10005bbe:	ed8d 3b3a 	vstr	d3, [sp, #232]	@ 0xe8
10005bc2:	445b      	add	r3, fp
10005bc4:	459b      	cmp	fp, r3
10005bc6:	ed8d 5b2e 	vstr	d5, [sp, #184]	@ 0xb8
10005bca:	ed8d 6b30 	vstr	d6, [sp, #192]	@ 0xc0
10005bce:	f080 823a 	bcs.w	10006046 <fndsa_vect_iFFT_fp64_exact+0x656>
10005bd2:	4639      	mov	r1, r7
10005bd4:	4632      	mov	r2, r6
10005bd6:	eb0a 0506 	add.w	r5, sl, r6
10005bda:	eb0a 0407 	add.w	r4, sl, r7
10005bde:	9606      	str	r6, [sp, #24]
10005be0:	ed92 3b02 	vldr	d3, [r2, #8]
10005be4:	ed91 4b02 	vldr	d4, [r1, #8]
10005be8:	ed94 6b02 	vldr	d6, [r4, #8]
10005bec:	ed95 7b02 	vldr	d7, [r5, #8]
10005bf0:	ee33 1b0a 	vadd.f64	d1, d3, d10
10005bf4:	ed92 5b00 	vldr	d5, [r2]
10005bf8:	ee31 1b44 	vsub.f64	d1, d1, d4
10005bfc:	ee37 2b0a 	vadd.f64	d2, d7, d10
10005c00:	ee36 7b07 	vadd.f64	d7, d6, d7
10005c04:	ed91 0b00 	vldr	d0, [r1]
10005c08:	ee33 3b04 	vadd.f64	d3, d3, d4
10005c0c:	ee32 2b46 	vsub.f64	d2, d2, d6
10005c10:	ee21 4b0e 	vmul.f64	d4, d1, d14
10005c14:	ee27 8b0e 	vmul.f64	d8, d7, d14
10005c18:	ee35 6b0a 	vadd.f64	d6, d5, d10
10005c1c:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10005c20:	ee36 6b40 	vsub.f64	d6, d6, d0
10005c24:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10005c28:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10005c2c:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10005c30:	ee36 6b4b 	vsub.f64	d6, d6, d11
10005c34:	ed95 db00 	vldr	d13, [r5]
10005c38:	ee36 6b04 	vadd.f64	d6, d6, d4
10005c3c:	ee08 7b4a 	vmls.f64	d7, d8, d10
10005c40:	ee04 1b4a 	vmls.f64	d1, d4, d10
10005c44:	ee23 4b0e 	vmul.f64	d4, d3, d14
10005c48:	ed94 cb00 	vldr	d12, [r4]
10005c4c:	ee37 9b0b 	vadd.f64	d9, d7, d11
10005c50:	ee30 5b05 	vadd.f64	d5, d0, d5
10005c54:	ee3d 7b0a 	vadd.f64	d7, d13, d10
10005c58:	ee22 0b0e 	vmul.f64	d0, d2, d14
10005c5c:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10005c60:	ee37 7b4c 	vsub.f64	d7, d7, d12
10005c64:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10005c68:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10005c6c:	ee35 5b04 	vadd.f64	d5, d5, d4
10005c70:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10005c74:	ee04 3b4a 	vmls.f64	d3, d4, d10
10005c78:	ee37 7b4b 	vsub.f64	d7, d7, d11
10005c7c:	ee3d 4b0c 	vadd.f64	d4, d13, d12
10005c80:	ee37 7b00 	vadd.f64	d7, d7, d0
10005c84:	ee34 4b08 	vadd.f64	d4, d4, d8
10005c88:	ee00 2b4a 	vmls.f64	d2, d0, d10
10005c8c:	ee26 8b0e 	vmul.f64	d8, d6, d14
10005c90:	ee25 0b0e 	vmul.f64	d0, d5, d14
10005c94:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10005c98:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10005c9c:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10005ca0:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10005ca4:	ee08 6b4a 	vmls.f64	d6, d8, d10
10005ca8:	ee00 5b4a 	vmls.f64	d5, d0, d10
10005cac:	ee24 8b0e 	vmul.f64	d8, d4, d14
10005cb0:	ee27 0b0e 	vmul.f64	d0, d7, d14
10005cb4:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10005cb8:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10005cbc:	ee31 1b0b 	vadd.f64	d1, d1, d11
10005cc0:	ee33 3b0b 	vadd.f64	d3, d3, d11
10005cc4:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10005cc8:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10005ccc:	ee08 4b4a 	vmls.f64	d4, d8, d10
10005cd0:	ee00 7b4a 	vmls.f64	d7, d0, d10
10005cd4:	ee21 8b0e 	vmul.f64	d8, d1, d14
10005cd8:	ee23 0b0e 	vmul.f64	d0, d3, d14
10005cdc:	ed9f cb4c 	vldr	d12, [pc, #304]	@ 10005e10 <fndsa_vect_iFFT_fp64_exact+0x420>
10005ce0:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10005ce4:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10005ce8:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10005cec:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10005cf0:	ee36 6b0c 	vadd.f64	d6, d6, d12
10005cf4:	ee08 1b4a 	vmls.f64	d1, d8, d10
10005cf8:	ee36 6b08 	vadd.f64	d6, d6, d8
10005cfc:	ee00 3b4a 	vmls.f64	d3, d0, d10
10005d00:	eeb6 8b00 	vmov.f64	d8, #96	@ 0x3f000000  0.5
10005d04:	ee23 3b08 	vmul.f64	d3, d3, d8
10005d08:	ee32 2b0b 	vadd.f64	d2, d2, d11
10005d0c:	ee35 5b0c 	vadd.f64	d5, d5, d12
10005d10:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10005d14:	ee21 1b08 	vmul.f64	d1, d1, d8
10005d18:	ee35 5b00 	vadd.f64	d5, d5, d0
10005d1c:	eeb8 0b43 	vcvt.f64.u32	d0, s6
10005d20:	ee22 3b0e 	vmul.f64	d3, d2, d14
10005d24:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10005d28:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10005d2c:	eeb8 db41 	vcvt.f64.u32	d13, s2
10005d30:	ee29 1b0e 	vmul.f64	d1, d9, d14
10005d34:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10005d38:	ee37 7b0c 	vadd.f64	d7, d7, d12
10005d3c:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10005d40:	ee37 7b03 	vadd.f64	d7, d7, d3
10005d44:	ee03 2b4a 	vmls.f64	d2, d3, d10
10005d48:	ee26 3b0e 	vmul.f64	d3, d6, d14
10005d4c:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10005d50:	ee34 4b0c 	vadd.f64	d4, d4, d12
10005d54:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10005d58:	ee34 4b01 	vadd.f64	d4, d4, d1
10005d5c:	ee01 9b4a 	vmls.f64	d9, d1, d10
10005d60:	ee25 1b0e 	vmul.f64	d1, d5, d14
10005d64:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10005d68:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10005d6c:	ee03 6b4a 	vmls.f64	d6, d3, d10
10005d70:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10005d74:	eefc 6bc6 	vcvt.u32.f64	s13, d6
10005d78:	ee01 5b4a 	vmls.f64	d5, d1, d10
10005d7c:	ee16 ca90 	vmov	ip, s13
10005d80:	eefc 6bc5 	vcvt.u32.f64	s13, d5
10005d84:	ea4f 76dc 	mov.w	r6, ip, lsr #31
10005d88:	ee05 6a10 	vmov	s10, r6
10005d8c:	ea4f 065c 	mov.w	r6, ip, lsr #1
10005d90:	f00c 0c01 	and.w	ip, ip, #1
10005d94:	ee16 3a90 	vmov	r3, s13
10005d98:	ee03 6a10 	vmov	s6, r6
10005d9c:	ee06 ca90 	vmov	s13, ip
10005da0:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
10005da4:	eeb8 6be6 	vcvt.f64.s32	d6, s13
10005da8:	eeb8 3bc3 	vcvt.f64.s32	d3, s6
10005dac:	ea4f 0e53 	mov.w	lr, r3, lsr #1
10005db0:	0fde      	lsrs	r6, r3, #31
10005db2:	ee05 3b0f 	vmla.f64	d3, d5, d15
10005db6:	ee06 db0f 	vmla.f64	d13, d6, d15
10005dba:	ee05 6a10 	vmov	s10, r6
10005dbe:	ee06 ea90 	vmov	s13, lr
10005dc2:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
10005dc6:	eeb8 6be6 	vcvt.f64.s32	d6, s13
10005dca:	e027      	b.n	10005e1c <fndsa_vect_iFFT_fp64_exact+0x42c>
10005dcc:	f3af 8000 	nop.w
10005dd0:	00000000 	.word	0x00000000
10005dd4:	41f00000 	.word	0x41f00000
10005dd8:	00000000 	.word	0x00000000
10005ddc:	3df00000 	.word	0x3df00000
10005de0:	00000000 	.word	0x00000000
10005de4:	41e00000 	.word	0x41e00000
10005de8:	00000000 	.word	0x00000000
10005dec:	3ef00000 	.word	0x3ef00000
10005df0:	00000000 	.word	0x00000000
10005df4:	3e700000 	.word	0x3e700000
10005df8:	00000000 	.word	0x00000000
10005dfc:	40f00000 	.word	0x40f00000
10005e00:	00000000 	.word	0x00000000
10005e04:	40700000 	.word	0x40700000
10005e08:	00000000 	.word	0x00000000
10005e0c:	41700000 	.word	0x41700000
	...
10005e18:	300039a0 	.word	0x300039a0
10005e1c:	ee05 6b0f 	vmla.f64	d6, d5, d15
10005e20:	ee24 5b0e 	vmul.f64	d5, d4, d14
10005e24:	f003 0301 	and.w	r3, r3, #1
10005e28:	ed82 6b00 	vstr	d6, [r2]
10005e2c:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10005e30:	ee06 3a90 	vmov	s13, r3
10005e34:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10005e38:	eeb8 6be6 	vcvt.f64.s32	d6, s13
10005e3c:	ee05 4b4a 	vmls.f64	d4, d5, d10
10005e40:	ee06 0b0f 	vmla.f64	d0, d6, d15
10005e44:	ee27 6b0e 	vmul.f64	d6, d7, d14
10005e48:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10005e4c:	eefc 6bc4 	vcvt.u32.f64	s13, d4
10005e50:	ee16 3a90 	vmov	r3, s13
10005e54:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005e58:	ee06 7b4a 	vmls.f64	d7, d6, d10
10005e5c:	0fde      	lsrs	r6, r3, #31
10005e5e:	ee05 6a10 	vmov	s10, r6
10005e62:	085e      	lsrs	r6, r3, #1
10005e64:	ee06 6a10 	vmov	s12, r6
10005e68:	ee29 9b08 	vmul.f64	d9, d9, d8
10005e6c:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10005e70:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
10005e74:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10005e78:	f003 0301 	and.w	r3, r3, #1
10005e7c:	ee17 ca90 	vmov	ip, s15
10005e80:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10005e84:	ee07 3a90 	vmov	s15, r3
10005e88:	ee05 6b0f 	vmla.f64	d6, d5, d15
10005e8c:	ee22 2b08 	vmul.f64	d2, d2, d8
10005e90:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10005e94:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10005e98:	ea4f 73dc 	mov.w	r3, ip, lsr #31
10005e9c:	ed82 0b02 	vstr	d0, [r2, #8]
10005ea0:	ed85 6b00 	vstr	d6, [r5]
10005ea4:	ee06 3a10 	vmov	s12, r3
10005ea8:	ea4f 035c 	mov.w	r3, ip, lsr #1
10005eac:	ee08 3a10 	vmov	s16, r3
10005eb0:	f00c 0301 	and.w	r3, ip, #1
10005eb4:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10005eb8:	ee07 9b0f 	vmla.f64	d9, d7, d15
10005ebc:	ee07 3a10 	vmov	s14, r3
10005ec0:	eeb8 cb42 	vcvt.f64.u32	d12, s4
10005ec4:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10005ec8:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10005ecc:	eeb8 8bc8 	vcvt.f64.s32	d8, s16
10005ed0:	ee07 cb0f 	vmla.f64	d12, d7, d15
10005ed4:	ee06 8b0f 	vmla.f64	d8, d6, d15
10005ed8:	eeb0 0b43 	vmov.f64	d0, d3
10005edc:	eeb0 1b4d 	vmov.f64	d1, d13
10005ee0:	ed85 9b02 	vstr	d9, [r5, #8]
10005ee4:	a824      	add	r0, sp, #144	@ 0x90
10005ee6:	ed8d 3b1c 	vstr	d3, [sp, #112]	@ 0x70
10005eea:	ed8d 3b00 	vstr	d3, [sp]
10005eee:	ed8d db1e 	vstr	d13, [sp, #120]	@ 0x78
10005ef2:	ed8d cb22 	vstr	d12, [sp, #136]	@ 0x88
10005ef6:	ed8d 8b20 	vstr	d8, [sp, #128]	@ 0x80
10005efa:	f7fe fe99 	bl	10004c30 <fp64e_mul24_prepared>
10005efe:	a82e      	add	r0, sp, #184	@ 0xb8
10005f00:	eeb0 9b40 	vmov.f64	d9, d0
10005f04:	ed8d 0b0c 	vstr	d0, [sp, #48]	@ 0x30
10005f08:	ed8d 1b0e 	vstr	d1, [sp, #56]	@ 0x38
10005f0c:	eeb0 0b48 	vmov.f64	d0, d8
10005f10:	ed8d 1b04 	vstr	d1, [sp, #16]
10005f14:	eeb0 1b4c 	vmov.f64	d1, d12
10005f18:	f7fe fe8a 	bl	10004c30 <fp64e_mul24_prepared>
10005f1c:	eeb0 5b41 	vmov.f64	d5, d1
10005f20:	ee3c 1b0d 	vadd.f64	d1, d12, d13
10005f24:	ee21 4b0e 	vmul.f64	d4, d1, d14
10005f28:	ed9d 3b00 	vldr	d3, [sp]
10005f2c:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10005f30:	eeb0 6b40 	vmov.f64	d6, d0
10005f34:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10005f38:	ee38 0b03 	vadd.f64	d0, d8, d3
10005f3c:	ee30 0b04 	vadd.f64	d0, d0, d4
10005f40:	ee04 1b4a 	vmls.f64	d1, d4, d10
10005f44:	ee20 4b0e 	vmul.f64	d4, d0, d14
10005f48:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10005f4c:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10005f50:	ee04 0b4a 	vmls.f64	d0, d4, d10
10005f54:	a838      	add	r0, sp, #224	@ 0xe0
10005f56:	ed8d 6b10 	vstr	d6, [sp, #64]	@ 0x40
10005f5a:	ed8d 6b02 	vstr	d6, [sp, #8]
10005f5e:	ed8d 5b12 	vstr	d5, [sp, #72]	@ 0x48
10005f62:	ed8d 5b00 	vstr	d5, [sp]
10005f66:	ed8d 1b1a 	vstr	d1, [sp, #104]	@ 0x68
10005f6a:	ed8d 0b18 	vstr	d0, [sp, #96]	@ 0x60
10005f6e:	f7fe fe5f 	bl	10004c30 <fp64e_mul24_prepared>
10005f72:	ed9d 5b00 	vldr	d5, [sp]
10005f76:	ed9d 7b04 	vldr	d7, [sp, #16]
10005f7a:	ee37 4b05 	vadd.f64	d4, d7, d5
10005f7e:	ee37 7b0a 	vadd.f64	d7, d7, d10
10005f82:	ed9d 6b02 	vldr	d6, [sp, #8]
10005f86:	ee37 7b45 	vsub.f64	d7, d7, d5
10005f8a:	ee24 5b0e 	vmul.f64	d5, d4, d14
10005f8e:	eefc 3bc5 	vcvt.u32.f64	s7, d5
10005f92:	ee39 5b06 	vadd.f64	d5, d9, d6
10005f96:	ee39 9b0a 	vadd.f64	d9, d9, d10
10005f9a:	ee39 9b46 	vsub.f64	d9, d9, d6
10005f9e:	eeb8 6b63 	vcvt.f64.u32	d6, s7
10005fa2:	ee35 5b06 	vadd.f64	d5, d5, d6
10005fa6:	ee06 4b4a 	vmls.f64	d4, d6, d10
10005faa:	ee27 6b0e 	vmul.f64	d6, d7, d14
10005fae:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10005fb2:	ee39 9b4b 	vsub.f64	d9, d9, d11
10005fb6:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005fba:	ee39 9b06 	vadd.f64	d9, d9, d6
10005fbe:	ee06 7b4a 	vmls.f64	d7, d6, d10
10005fc2:	ee25 3b0e 	vmul.f64	d3, d5, d14
10005fc6:	ed81 7b02 	vstr	d7, [r1, #8]
10005fca:	ee29 7b0e 	vmul.f64	d7, d9, d14
10005fce:	ed8d 1b16 	vstr	d1, [sp, #88]	@ 0x58
10005fd2:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10005fd6:	ee31 1b0a 	vadd.f64	d1, d1, d10
10005fda:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005fde:	ee31 4b44 	vsub.f64	d4, d1, d4
10005fe2:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005fe6:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10005fea:	ee07 9b4a 	vmls.f64	d9, d7, d10
10005fee:	ed8d 0b14 	vstr	d0, [sp, #80]	@ 0x50
10005ff2:	ee24 7b0e 	vmul.f64	d7, d4, d14
10005ff6:	ee30 0b0a 	vadd.f64	d0, d0, d10
10005ffa:	ee03 5b4a 	vmls.f64	d5, d3, d10
10005ffe:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006002:	ee30 0b45 	vsub.f64	d0, d0, d5
10006006:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000600a:	ee30 0b4b 	vsub.f64	d0, d0, d11
1000600e:	ee30 0b07 	vadd.f64	d0, d0, d7
10006012:	ee07 4b4a 	vmls.f64	d4, d7, d10
10006016:	ee20 7b0e 	vmul.f64	d7, d0, d14
1000601a:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000601e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006022:	ee07 0b4a 	vmls.f64	d0, d7, d10
10006026:	3210      	adds	r2, #16
10006028:	3410      	adds	r4, #16
1000602a:	4297      	cmp	r7, r2
1000602c:	f101 0110 	add.w	r1, r1, #16
10006030:	ed01 9b04 	vstr	d9, [r1, #-16]
10006034:	f105 0510 	add.w	r5, r5, #16
10006038:	ed04 4b02 	vstr	d4, [r4, #-8]
1000603c:	ed04 0b04 	vstr	d0, [r4, #-16]
10006040:	f47f adce 	bne.w	10005be0 <fndsa_vect_iFFT_fp64_exact+0x1f0>
10006044:	9e06      	ldr	r6, [sp, #24]
10006046:	9b07      	ldr	r3, [sp, #28]
10006048:	f108 0810 	add.w	r8, r8, #16
1000604c:	449b      	add	fp, r3
1000604e:	9b08      	ldr	r3, [sp, #32]
10006050:	444e      	add	r6, r9
10006052:	4543      	cmp	r3, r8
10006054:	444f      	add	r7, r9
10006056:	f47f acfa 	bne.w	10005a4e <fndsa_vect_iFFT_fp64_exact+0x5e>
1000605a:	9c0a      	ldr	r4, [sp, #40]	@ 0x28
1000605c:	4656      	mov	r6, sl
1000605e:	3c01      	subs	r4, #1
10006060:	f8dd c01c 	ldr.w	ip, [sp, #28]
10006064:	990b      	ldr	r1, [sp, #44]	@ 0x2c
10006066:	f47f acd6 	bne.w	10005a16 <fndsa_vect_iFFT_fp64_exact+0x26>
1000606a:	b043      	add	sp, #268	@ 0x10c
1000606c:	ecbd 8b10 	vpop	{d8-d15}
10006070:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
