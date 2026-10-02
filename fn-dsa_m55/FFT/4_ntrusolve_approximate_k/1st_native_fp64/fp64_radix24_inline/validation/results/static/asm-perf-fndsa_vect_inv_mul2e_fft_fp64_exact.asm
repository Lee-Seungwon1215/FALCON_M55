
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/asm-perf/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

100069f0 <fndsa_vect_inv_mul2e_fft_fp64_exact>:
100069f0:	b5f0      	push	{r4, r5, r6, r7, lr}
100069f2:	2701      	movs	r7, #1
100069f4:	fa07 f202 	lsl.w	r2, r7, r2
100069f8:	ee07 2a90 	vmov	s15, r2
100069fc:	ed2d 8b10 	vpush	{d8-d15}
10006a00:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10006a04:	2410      	movs	r4, #16
10006a06:	b08f      	sub	sp, #60	@ 0x3c
10006a08:	2600      	movs	r6, #0
10006a0a:	ed9f 9bf3 	vldr	d9, [pc, #972]	@ 10006dd8 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x3e8>
10006a0e:	ed9f ebf4 	vldr	d14, [pc, #976]	@ 10006de0 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x3f0>
10006a12:	ed9f bbf5 	vldr	d11, [pc, #980]	@ 10006de8 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x3f8>
10006a16:	ed9f dbf6 	vldr	d13, [pc, #984]	@ 10006df0 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x400>
10006a1a:	ed9f cbf7 	vldr	d12, [pc, #988]	@ 10006df8 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x408>
10006a1e:	460d      	mov	r5, r1
10006a20:	ed8d 7b02 	vstr	d7, [sp, #8]
10006a24:	3801      	subs	r0, #1
10006a26:	4084      	lsls	r4, r0
10006a28:	4087      	lsls	r7, r0
10006a2a:	440c      	add	r4, r1
10006a2c:	ed95 0b00 	vldr	d0, [r5]
10006a30:	ed94 fb02 	vldr	d15, [r4, #8]
10006a34:	ed9f 6bf2 	vldr	d6, [pc, #968]	@ 10006e00 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x410>
10006a38:	ee39 fb4f 	vsub.f64	d15, d9, d15
10006a3c:	ee20 4b06 	vmul.f64	d4, d0, d6
10006a40:	eefc 6bc0 	vcvt.u32.f64	s13, d0
10006a44:	ed94 3b00 	vldr	d3, [r4]
10006a48:	ee16 3a90 	vmov	r3, s13
10006a4c:	ee2f 6b0e 	vmul.f64	d6, d15, d14
10006a50:	eeb7 1b00 	vmov.f64	d1, #112	@ 0x3f800000  1.0
10006a54:	ee39 3b43 	vsub.f64	d3, d9, d3
10006a58:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006a5c:	0fdb      	lsrs	r3, r3, #31
10006a5e:	ed95 7b02 	vldr	d7, [r5, #8]
10006a62:	ee33 3b41 	vsub.f64	d3, d3, d1
10006a66:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006a6a:	ee01 3a10 	vmov	s2, r3
10006a6e:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10006a72:	ee33 ab06 	vadd.f64	d10, d3, d6
10006a76:	ee27 5b0b 	vmul.f64	d5, d7, d11
10006a7a:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10006a7e:	eeb8 1bc1 	vcvt.f64.s32	d1, s2
10006a82:	eeb0 3b40 	vmov.f64	d3, d0
10006a86:	ee21 2b07 	vmul.f64	d2, d1, d7
10006a8a:	ee04 3b4c 	vmls.f64	d3, d4, d12
10006a8e:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10006a92:	ed8d 2b08 	vstr	d2, [sp, #32]
10006a96:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10006a9a:	eeb0 2b43 	vmov.f64	d2, d3
10006a9e:	eeb0 3b47 	vmov.f64	d3, d7
10006aa2:	ee05 3b4d 	vmls.f64	d3, d5, d13
10006aa6:	ee06 fb49 	vmls.f64	d15, d6, d9
10006aaa:	eeb0 6b43 	vmov.f64	d6, d3
10006aae:	ed9f 3bd6 	vldr	d3, [pc, #856]	@ 10006e08 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x418>
10006ab2:	ee02 5b03 	vmla.f64	d5, d2, d3
10006ab6:	ed9d 2b02 	vldr	d2, [sp, #8]
10006aba:	ee27 2b02 	vmul.f64	d2, d7, d2
10006abe:	ee2a 7b0e 	vmul.f64	d7, d10, d14
10006ac2:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006ac6:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006aca:	ee2f 1b0b 	vmul.f64	d1, d15, d11
10006ace:	ee07 ab49 	vmls.f64	d10, d7, d9
10006ad2:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10006ad6:	ed8d ab00 	vstr	d10, [sp]
10006ada:	eeb8 8b41 	vcvt.f64.u32	d8, s2
10006ade:	ee26 7b06 	vmul.f64	d7, d6, d6
10006ae2:	ee26 1b05 	vmul.f64	d1, d6, d5
10006ae6:	ee26 3b04 	vmul.f64	d3, d6, d4
10006aea:	ee25 ab04 	vmul.f64	d10, d5, d4
10006aee:	ee05 1b06 	vmla.f64	d1, d5, d6
10006af2:	ee05 3b05 	vmla.f64	d3, d5, d5
10006af6:	ee04 ab05 	vmla.f64	d10, d4, d5
10006afa:	ee04 3b06 	vmla.f64	d3, d4, d6
10006afe:	ed9d 5b00 	vldr	d5, [sp]
10006b02:	eebc 6bc5 	vcvt.u32.f64	s12, d5
10006b06:	ee16 3a10 	vmov	r3, s12
10006b0a:	0fdb      	lsrs	r3, r3, #31
10006b0c:	ee06 3a10 	vmov	s12, r3
10006b10:	ee27 7b0b 	vmul.f64	d7, d7, d11
10006b14:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10006b18:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006b1c:	ee26 4b0f 	vmul.f64	d4, d6, d15
10006b20:	ed9f 6bb7 	vldr	d6, [pc, #732]	@ 10006e00 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x410>
10006b24:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006b28:	ee25 6b06 	vmul.f64	d6, d5, d6
10006b2c:	eeb0 5b4f 	vmov.f64	d5, d15
10006b30:	ee37 7b01 	vadd.f64	d7, d7, d1
10006b34:	ee08 5b4d 	vmls.f64	d5, d8, d13
10006b38:	ed8d 5b04 	vstr	d5, [sp, #16]
10006b3c:	ee27 5b0b 	vmul.f64	d5, d7, d11
10006b40:	ee22 1b0e 	vmul.f64	d1, d2, d14
10006b44:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10006b48:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10006b4c:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10006b50:	ed8d 4b06 	vstr	d4, [sp, #24]
10006b54:	ee33 3b05 	vadd.f64	d3, d3, d5
10006b58:	ed9f 4bad 	vldr	d4, [pc, #692]	@ 10006e10 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x420>
10006b5c:	ee05 7b4d 	vmls.f64	d7, d5, d13
10006b60:	eeb8 5b41 	vcvt.f64.u32	d5, s2
10006b64:	ed8d ab0c 	vstr	d10, [sp, #48]	@ 0x30
10006b68:	ee27 1b04 	vmul.f64	d1, d7, d4
10006b6c:	ee05 2b49 	vmls.f64	d2, d5, d9
10006b70:	ed9d 7b02 	vldr	d7, [sp, #8]
10006b74:	eeb0 ab45 	vmov.f64	d10, d5
10006b78:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006b7c:	ee00 ab07 	vmla.f64	d10, d0, d7
10006b80:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006b84:	eefc 7bc2 	vcvt.u32.f64	s15, d2
10006b88:	ed9d 2b00 	vldr	d2, [sp]
10006b8c:	ed9f 0b9e 	vldr	d0, [pc, #632]	@ 10006e08 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x418>
10006b90:	ee06 2b4c 	vmls.f64	d2, d6, d12
10006b94:	eebc 7bc1 	vcvt.u32.f64	s14, d1
10006b98:	ee02 8b00 	vmla.f64	d8, d2, d0
10006b9c:	ed8d ab0a 	vstr	d10, [sp, #40]	@ 0x28
10006ba0:	eeb0 5b48 	vmov.f64	d5, d8
10006ba4:	ed9d ab04 	vldr	d10, [sp, #16]
10006ba8:	ee17 0a90 	vmov	r0, s15
10006bac:	eeb8 8b47 	vcvt.f64.u32	d8, s14
10006bb0:	ee2a 7b0a 	vmul.f64	d7, d10, d10
10006bb4:	ee2a 1b05 	vmul.f64	d1, d10, d5
10006bb8:	ee2a 2b06 	vmul.f64	d2, d10, d6
10006bbc:	ee25 0b06 	vmul.f64	d0, d5, d6
10006bc0:	ee05 1b0a 	vmla.f64	d1, d5, d10
10006bc4:	ee05 2b05 	vmla.f64	d2, d5, d5
10006bc8:	ee06 0b05 	vmla.f64	d0, d6, d5
10006bcc:	ee06 2b0a 	vmla.f64	d2, d6, d10
10006bd0:	ee27 7b0b 	vmul.f64	d7, d7, d11
10006bd4:	ee23 5b0b 	vmul.f64	d5, d3, d11
10006bd8:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006bdc:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10006be0:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006be4:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10006be8:	ee37 7b01 	vadd.f64	d7, d7, d1
10006bec:	ed9d 1b0c 	vldr	d1, [sp, #48]	@ 0x30
10006bf0:	ee31 6b05 	vadd.f64	d6, d1, d5
10006bf4:	eeb0 1b43 	vmov.f64	d1, d3
10006bf8:	ee05 1b4d 	vmls.f64	d1, d5, d13
10006bfc:	ee27 5b0b 	vmul.f64	d5, d7, d11
10006c00:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10006c04:	ee26 3b0b 	vmul.f64	d3, d6, d11
10006c08:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10006c0c:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006c10:	ee05 7b4d 	vmls.f64	d7, d5, d13
10006c14:	ee32 2b05 	vadd.f64	d2, d2, d5
10006c18:	ee27 7b04 	vmul.f64	d7, d7, d4
10006c1c:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10006c20:	ed9f 4b77 	vldr	d4, [pc, #476]	@ 10006e00 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x410>
10006c24:	ee03 6b4d 	vmls.f64	d6, d3, d13
10006c28:	ee22 5b0b 	vmul.f64	d5, d2, d11
10006c2c:	ee21 3b04 	vmul.f64	d3, d1, d4
10006c30:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10006c34:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006c38:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10006c3c:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10006c40:	ee05 2b4d 	vmls.f64	d2, d5, d13
10006c44:	ee03 1b4c 	vmls.f64	d1, d3, d12
10006c48:	eeb0 ab44 	vmov.f64	d10, d4
10006c4c:	ee30 4b05 	vadd.f64	d4, d0, d5
10006c50:	ed9f 0b6d 	vldr	d0, [pc, #436]	@ 10006e08 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x418>
10006c54:	eeb0 5b43 	vmov.f64	d5, d3
10006c58:	ee01 8b0c 	vmla.f64	d8, d1, d12
10006c5c:	ee06 5b00 	vmla.f64	d5, d6, d0
10006c60:	ed9f 1b6d 	vldr	d1, [pc, #436]	@ 10006e18 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x428>
10006c64:	ed9d 6b08 	vldr	d6, [sp, #32]
10006c68:	ee35 5b01 	vadd.f64	d5, d5, d1
10006c6c:	ee35 5b46 	vsub.f64	d5, d5, d6
10006c70:	ee22 3b0a 	vmul.f64	d3, d2, d10
10006c74:	ee35 5b46 	vsub.f64	d5, d5, d6
10006c78:	ee24 6b0b 	vmul.f64	d6, d4, d11
10006c7c:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006c80:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006c84:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10006c88:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006c8c:	ee06 4b4d 	vmls.f64	d4, d6, d13
10006c90:	eeb0 6b43 	vmov.f64	d6, d3
10006c94:	ee04 6b00 	vmla.f64	d6, d4, d0
10006c98:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006c9c:	ed9d 4b06 	vldr	d4, [sp, #24]
10006ca0:	ee36 6b01 	vadd.f64	d6, d6, d1
10006ca4:	ee03 2b4c 	vmls.f64	d2, d3, d12
10006ca8:	ee36 6b44 	vsub.f64	d6, d6, d4
10006cac:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006cb0:	ee36 6b44 	vsub.f64	d6, d6, d4
10006cb4:	ee02 7b0c 	vmla.f64	d7, d2, d12
10006cb8:	ee26 1b0e 	vmul.f64	d1, d6, d14
10006cbc:	ee25 2b0e 	vmul.f64	d2, d5, d14
10006cc0:	ee37 7b08 	vadd.f64	d7, d7, d8
10006cc4:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10006cc8:	ee27 4b0e 	vmul.f64	d4, d7, d14
10006ccc:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10006cd0:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10006cd4:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10006cd8:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10006cdc:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10006ce0:	ee02 5b49 	vmls.f64	d5, d2, d9
10006ce4:	ee01 6b49 	vmls.f64	d6, d1, d9
10006ce8:	ee04 7b49 	vmls.f64	d7, d4, d9
10006cec:	ee36 6b05 	vadd.f64	d6, d6, d5
10006cf0:	ed9d 0b0a 	vldr	d0, [sp, #40]	@ 0x28
10006cf4:	ee36 6b04 	vadd.f64	d6, d6, d4
10006cf8:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10006cfc:	ee20 3b0e 	vmul.f64	d3, d0, d14
10006d00:	ee17 2a90 	vmov	r2, s15
10006d04:	edcd 7a06 	vstr	s15, [sp, #24]
10006d08:	ee26 7b0e 	vmul.f64	d7, d6, d14
10006d0c:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006d10:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006d14:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10006d18:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006d1c:	eeb0 5b40 	vmov.f64	d5, d0
10006d20:	ee07 6b49 	vmls.f64	d6, d7, d9
10006d24:	ee03 5b49 	vmls.f64	d5, d3, d9
10006d28:	eefc 7bc6 	vcvt.u32.f64	s15, d6
10006d2c:	eefc 5bc5 	vcvt.u32.f64	s11, d5
10006d30:	ee17 3a90 	vmov	r3, s15
10006d34:	ee15 1a90 	vmov	r1, s11
10006d38:	edcd 7a04 	vstr	s15, [sp, #16]
10006d3c:	f7ff fc80 	bl	10006640 <fxr_div_fp64_exact>
10006d40:	ed9d 3b02 	vldr	d3, [sp, #8]
10006d44:	ee2f 5b03 	vmul.f64	d5, d15, d3
10006d48:	ee25 7b0e 	vmul.f64	d7, d5, d14
10006d4c:	ee04 0a10 	vmov	s8, r0
10006d50:	ee06 1a10 	vmov	s12, r1
10006d54:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006d58:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10006d5c:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006d60:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006d64:	ed85 4b02 	vstr	d4, [r5, #8]
10006d68:	ed85 6b00 	vstr	d6, [r5]
10006d6c:	ed9d 4b00 	vldr	d4, [sp]
10006d70:	eeb0 6b47 	vmov.f64	d6, d7
10006d74:	ee04 6b03 	vmla.f64	d6, d4, d3
10006d78:	ee07 5b49 	vmls.f64	d5, d7, d9
10006d7c:	ee26 7b0e 	vmul.f64	d7, d6, d14
10006d80:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006d84:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006d88:	ee07 6b49 	vmls.f64	d6, d7, d9
10006d8c:	eefc 5bc5 	vcvt.u32.f64	s11, d5
10006d90:	eefc 7bc6 	vcvt.u32.f64	s15, d6
10006d94:	ee15 0a90 	vmov	r0, s11
10006d98:	ee17 1a90 	vmov	r1, s15
10006d9c:	9a06      	ldr	r2, [sp, #24]
10006d9e:	9b04      	ldr	r3, [sp, #16]
10006da0:	f7ff fc4e 	bl	10006640 <fxr_div_fp64_exact>
10006da4:	ee06 0a10 	vmov	s12, r0
10006da8:	ee07 1a10 	vmov	s14, r1
10006dac:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006db0:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006db4:	3601      	adds	r6, #1
10006db6:	42b7      	cmp	r7, r6
10006db8:	f104 0410 	add.w	r4, r4, #16
10006dbc:	f105 0510 	add.w	r5, r5, #16
10006dc0:	ed04 6b02 	vstr	d6, [r4, #-8]
10006dc4:	ed04 7b04 	vstr	d7, [r4, #-16]
10006dc8:	f47f ae30 	bne.w	10006a2c <fndsa_vect_inv_mul2e_fft_fp64_exact+0x3c>
10006dcc:	b00f      	add	sp, #60	@ 0x3c
10006dce:	ecbd 8b10 	vpop	{d8-d15}
10006dd2:	bdf0      	pop	{r4, r5, r6, r7, pc}
10006dd4:	f3af 8000 	nop.w
10006dd8:	00000000 	.word	0x00000000
10006ddc:	41f00000 	.word	0x41f00000
10006de0:	00000000 	.word	0x00000000
10006de4:	3df00000 	.word	0x3df00000
10006de8:	00000000 	.word	0x00000000
10006dec:	3e700000 	.word	0x3e700000
10006df0:	00000000 	.word	0x00000000
10006df4:	41700000 	.word	0x41700000
10006df8:	00000000 	.word	0x00000000
10006dfc:	40f00000 	.word	0x40f00000
10006e00:	00000000 	.word	0x00000000
10006e04:	3ef00000 	.word	0x3ef00000
10006e08:	00000000 	.word	0x00000000
10006e0c:	40700000 	.word	0x40700000
10006e10:	00000000 	.word	0x00000000
10006e14:	3f700000 	.word	0x3f700000
10006e18:	00000000 	.word	0x00000000
10006e1c:	42000000 	.word	0x42000000
