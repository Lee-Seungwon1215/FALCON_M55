
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/r1-kernels/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10000a38 <fndsa_vect_FFT_fp64_exact.constprop.0>:
10000a38:	2801      	cmp	r0, #1
10000a3a:	f240 8200 	bls.w	10000e3e <fndsa_vect_FFT_fp64_exact.constprop.0+0x406>
10000a3e:	2101      	movs	r1, #1
10000a40:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10000a44:	2310      	movs	r3, #16
10000a46:	ed2d 8b10 	vpush	{d8-d15}
10000a4a:	460c      	mov	r4, r1
10000a4c:	ed9f dbea 	vldr	d13, [pc, #936]	@ 10000df8 <fndsa_vect_FFT_fp64_exact.constprop.0+0x3c0>
10000a50:	ed9f cbeb 	vldr	d12, [pc, #940]	@ 10000e00 <fndsa_vect_FFT_fp64_exact.constprop.0+0x3c8>
10000a54:	1e42      	subs	r2, r0, #1
10000a56:	4093      	lsls	r3, r2
10000a58:	fa01 fe02 	lsl.w	lr, r1, r2
10000a5c:	4aea      	ldr	r2, [pc, #936]	@ (10000e08 <fndsa_vect_FFT_fp64_exact.constprop.0+0x3d0>)
10000a5e:	b0d1      	sub	sp, #324	@ 0x144
10000a60:	189f      	adds	r7, r3, r2
10000a62:	e9cd 7022 	strd	r7, r0, [sp, #136]	@ 0x88
10000a66:	f10d 08e0 	add.w	r8, sp, #224	@ 0xe0
10000a6a:	f10d 0af0 	add.w	sl, sp, #240	@ 0xf0
10000a6e:	2301      	movs	r3, #1
10000a70:	2710      	movs	r7, #16
10000a72:	eeb7 bb00 	vmov.f64	d11, #112	@ 0x3f800000  1.0
10000a76:	2200      	movs	r2, #0
10000a78:	4de4      	ldr	r5, [pc, #912]	@ (10000e0c <fndsa_vect_FFT_fp64_exact.constprop.0+0x3d4>)
10000a7a:	40a3      	lsls	r3, r4
10000a7c:	eb03 0353 	add.w	r3, r3, r3, lsr #1
10000a80:	eb05 1303 	add.w	r3, r5, r3, lsl #4
10000a84:	4670      	mov	r0, lr
10000a86:	ea4f 0e5e 	mov.w	lr, lr, lsr #1
10000a8a:	931f      	str	r3, [sp, #124]	@ 0x7c
10000a8c:	ea4f 130e 	mov.w	r3, lr, lsl #4
10000a90:	3308      	adds	r3, #8
10000a92:	9320      	str	r3, [sp, #128]	@ 0x80
10000a94:	4bdc      	ldr	r3, [pc, #880]	@ (10000e08 <fndsa_vect_FFT_fp64_exact.constprop.0+0x3d0>)
10000a96:	9922      	ldr	r1, [sp, #136]	@ 0x88
10000a98:	eb03 1b0e 	add.w	fp, r3, lr, lsl #4
10000a9c:	fa07 f304 	lsl.w	r3, r7, r4
10000aa0:	442b      	add	r3, r5
10000aa2:	f8cd e078 	str.w	lr, [sp, #120]	@ 0x78
10000aa6:	9421      	str	r4, [sp, #132]	@ 0x84
10000aa8:	9c1e      	ldr	r4, [sp, #120]	@ 0x78
10000aaa:	4414      	add	r4, r2
10000aac:	42a2      	cmp	r2, r4
10000aae:	f080 81af 	bcs.w	10000e10 <fndsa_vect_FFT_fp64_exact.constprop.0+0x3d8>
10000ab2:	edd3 5a01 	vldr	s11, [r3, #4]
10000ab6:	edd3 7a00 	vldr	s15, [r3]
10000aba:	edd3 6a02 	vldr	s13, [r3, #8]
10000abe:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10000ac2:	eeb8 6b66 	vcvt.f64.u32	d6, s13
10000ac6:	eeb8 4b65 	vcvt.f64.u32	d4, s11
10000aca:	edd3 5a03 	vldr	s11, [r3, #12]
10000ace:	eeb8 3b65 	vcvt.f64.u32	d3, s11
10000ad2:	ee37 5b06 	vadd.f64	d5, d7, d6
10000ad6:	ed8d 7b10 	vstr	d7, [sp, #64]	@ 0x40
10000ada:	ee25 7b0d 	vmul.f64	d7, d5, d13
10000ade:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10000ae2:	ed8d 6b14 	vstr	d6, [sp, #80]	@ 0x50
10000ae6:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10000aea:	ee34 6b03 	vadd.f64	d6, d4, d3
10000aee:	ee36 6b07 	vadd.f64	d6, d6, d7
10000af2:	ee07 5b4c 	vmls.f64	d5, d7, d12
10000af6:	ee26 7b0d 	vmul.f64	d7, d6, d13
10000afa:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10000afe:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10000b02:	ee07 6b4c 	vmls.f64	d6, d7, d12
10000b06:	9e20      	ldr	r6, [sp, #128]	@ 0x80
10000b08:	ed8d 4b0e 	vstr	d4, [sp, #56]	@ 0x38
10000b0c:	1877      	adds	r7, r6, r1
10000b0e:	ed8d 3b12 	vstr	d3, [sp, #72]	@ 0x48
10000b12:	460d      	mov	r5, r1
10000b14:	ed8d 5b18 	vstr	d5, [sp, #96]	@ 0x60
10000b18:	ed8d 6b16 	vstr	d6, [sp, #88]	@ 0x58
10000b1c:	460e      	mov	r6, r1
10000b1e:	4cba      	ldr	r4, [pc, #744]	@ (10000e08 <fndsa_vect_FFT_fp64_exact.constprop.0+0x3d0>)
10000b20:	e9cd 201b 	strd	r2, r0, [sp, #108]	@ 0x6c
10000b24:	eb04 1402 	add.w	r4, r4, r2, lsl #4
10000b28:	f10b 0908 	add.w	r9, fp, #8
10000b2c:	931d      	str	r3, [sp, #116]	@ 0x74
10000b2e:	ed94 8b00 	vldr	d8, [r4]
10000b32:	f1a9 0308 	sub.w	r3, r9, #8
10000b36:	cb0f      	ldmia	r3, {r0, r1, r2, r3}
10000b38:	e888 000f 	stmia.w	r8, {r0, r1, r2, r3}
10000b3c:	ed95 2b02 	vldr	d2, [r5, #8]
10000b40:	ed9d eb3a 	vldr	d14, [sp, #232]	@ 0xe8
10000b44:	ed8d 8b02 	vstr	d8, [sp, #8]
10000b48:	ed9d 8b38 	vldr	d8, [sp, #224]	@ 0xe0
10000b4c:	ed94 7b02 	vldr	d7, [r4, #8]
10000b50:	ed95 5b00 	vldr	d5, [r5]
10000b54:	ed9d 1b10 	vldr	d1, [sp, #64]	@ 0x40
10000b58:	ed9d 0b0e 	vldr	d0, [sp, #56]	@ 0x38
10000b5c:	f1a7 0c08 	sub.w	ip, r7, #8
10000b60:	e89c 000f 	ldmia.w	ip, {r0, r1, r2, r3}
10000b64:	e88a 000f 	stmia.w	sl, {r0, r1, r2, r3}
10000b68:	ed8d 2b06 	vstr	d2, [sp, #24]
10000b6c:	eeb0 3b4e 	vmov.f64	d3, d14
10000b70:	eeb0 2b48 	vmov.f64	d2, d8
10000b74:	ed8d 7b04 	vstr	d7, [sp, #16]
10000b78:	ed8d 5b00 	vstr	d5, [sp]
10000b7c:	ed8d 0b40 	vstr	d0, [sp, #256]	@ 0x100
10000b80:	ed8d 1b42 	vstr	d1, [sp, #264]	@ 0x108
10000b84:	ed8d 8b48 	vstr	d8, [sp, #288]	@ 0x120
10000b88:	ed8d eb4a 	vstr	d14, [sp, #296]	@ 0x128
10000b8c:	ed9d 9b3c 	vldr	d9, [sp, #240]	@ 0xf0
10000b90:	f7ff fdc2 	bl	10000718 <fndsa_fp64e_mul>
10000b94:	ed9d ab3e 	vldr	d10, [sp, #248]	@ 0xf8
10000b98:	ed9d 6b14 	vldr	d6, [sp, #80]	@ 0x50
10000b9c:	eeb0 5b40 	vmov.f64	d5, d0
10000ba0:	ed9d 0b12 	vldr	d0, [sp, #72]	@ 0x48
10000ba4:	eeb0 2b49 	vmov.f64	d2, d9
10000ba8:	ed8d 1b26 	vstr	d1, [sp, #152]	@ 0x98
10000bac:	ed8d 1b0a 	vstr	d1, [sp, #40]	@ 0x28
10000bb0:	eeb0 3b4a 	vmov.f64	d3, d10
10000bb4:	eeb0 1b46 	vmov.f64	d1, d6
10000bb8:	ed8d 5b24 	vstr	d5, [sp, #144]	@ 0x90
10000bbc:	ed8d 5b0c 	vstr	d5, [sp, #48]	@ 0x30
10000bc0:	ed8d 0b44 	vstr	d0, [sp, #272]	@ 0x110
10000bc4:	ed8d 6b46 	vstr	d6, [sp, #280]	@ 0x118
10000bc8:	ed8d 9b4c 	vstr	d9, [sp, #304]	@ 0x130
10000bcc:	ed8d ab4e 	vstr	d10, [sp, #312]	@ 0x138
10000bd0:	f7ff fda2 	bl	10000718 <fndsa_fp64e_mul>
10000bd4:	ee3e 3b0a 	vadd.f64	d3, d14, d10
10000bd8:	ee23 4b0d 	vmul.f64	d4, d3, d13
10000bdc:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10000be0:	ee38 2b09 	vadd.f64	d2, d8, d9
10000be4:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10000be8:	ee32 2b04 	vadd.f64	d2, d2, d4
10000bec:	ee04 3b4c 	vmls.f64	d3, d4, d12
10000bf0:	ee22 4b0d 	vmul.f64	d4, d2, d13
10000bf4:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10000bf8:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10000bfc:	ed9d 6b18 	vldr	d6, [sp, #96]	@ 0x60
10000c00:	ee04 2b4c 	vmls.f64	d2, d4, d12
10000c04:	eeb0 fb40 	vmov.f64	d15, d0
10000c08:	ed8d 0b28 	vstr	d0, [sp, #160]	@ 0xa0
10000c0c:	ed9d 0b16 	vldr	d0, [sp, #88]	@ 0x58
10000c10:	ed8d 1b2a 	vstr	d1, [sp, #168]	@ 0xa8
10000c14:	ed8d 1b08 	vstr	d1, [sp, #32]
10000c18:	eeb0 1b46 	vmov.f64	d1, d6
10000c1c:	ed8d 0b34 	vstr	d0, [sp, #208]	@ 0xd0
10000c20:	ed8d 6b36 	vstr	d6, [sp, #216]	@ 0xd8
10000c24:	ed8d 3b32 	vstr	d3, [sp, #200]	@ 0xc8
10000c28:	ed8d 2b30 	vstr	d2, [sp, #192]	@ 0xc0
10000c2c:	f7ff fd74 	bl	10000718 <fndsa_fp64e_mul>
10000c30:	ed9d 7b08 	vldr	d7, [sp, #32]
10000c34:	ed9d 6b0a 	vldr	d6, [sp, #40]	@ 0x28
10000c38:	ee36 4b07 	vadd.f64	d4, d6, d7
10000c3c:	ee24 3b0d 	vmul.f64	d3, d4, d13
10000c40:	ed9d 5b0c 	vldr	d5, [sp, #48]	@ 0x30
10000c44:	ee36 6b0c 	vadd.f64	d6, d6, d12
10000c48:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10000c4c:	ee36 6b47 	vsub.f64	d6, d6, d7
10000c50:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10000c54:	ee35 7b0f 	vadd.f64	d7, d5, d15
10000c58:	ee37 7b03 	vadd.f64	d7, d7, d3
10000c5c:	ee27 2b0d 	vmul.f64	d2, d7, d13
10000c60:	ee03 4b4c 	vmls.f64	d4, d3, d12
10000c64:	ee35 5b0c 	vadd.f64	d5, d5, d12
10000c68:	ee26 3b0d 	vmul.f64	d3, d6, d13
10000c6c:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10000c70:	ed8d 1b2e 	vstr	d1, [sp, #184]	@ 0xb8
10000c74:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10000c78:	ee31 1b0c 	vadd.f64	d1, d1, d12
10000c7c:	ee35 5b4f 	vsub.f64	d5, d5, d15
10000c80:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10000c84:	ee31 4b44 	vsub.f64	d4, d1, d4
10000c88:	ee02 7b4c 	vmls.f64	d7, d2, d12
10000c8c:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10000c90:	ed8d 0b2c 	vstr	d0, [sp, #176]	@ 0xb0
10000c94:	ee35 5b4b 	vsub.f64	d5, d5, d11
10000c98:	ee30 0b0c 	vadd.f64	d0, d0, d12
10000c9c:	ee35 5b03 	vadd.f64	d5, d5, d3
10000ca0:	ee30 0b47 	vsub.f64	d0, d0, d7
10000ca4:	ee24 7b0d 	vmul.f64	d7, d4, d13
10000ca8:	ee03 6b4c 	vmls.f64	d6, d3, d12
10000cac:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10000cb0:	ee25 3b0d 	vmul.f64	d3, d5, d13
10000cb4:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10000cb8:	ee30 0b4b 	vsub.f64	d0, d0, d11
10000cbc:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10000cc0:	ee30 0b07 	vadd.f64	d0, d0, d7
10000cc4:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10000cc8:	ee07 4b4c 	vmls.f64	d4, d7, d12
10000ccc:	ee03 5b4c 	vmls.f64	d5, d3, d12
10000cd0:	ed9d 7b04 	vldr	d7, [sp, #16]
10000cd4:	ee20 3b0d 	vmul.f64	d3, d0, d13
10000cd8:	ee37 2b0c 	vadd.f64	d2, d7, d12
10000cdc:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10000ce0:	ee36 7b07 	vadd.f64	d7, d6, d7
10000ce4:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10000ce8:	ee32 6b46 	vsub.f64	d6, d2, d6
10000cec:	ed9d 2b06 	vldr	d2, [sp, #24]
10000cf0:	ee03 0b4c 	vmls.f64	d0, d3, d12
10000cf4:	ee32 3b0c 	vadd.f64	d3, d2, d12
10000cf8:	ee34 2b02 	vadd.f64	d2, d4, d2
10000cfc:	ee33 4b44 	vsub.f64	d4, d3, d4
10000d00:	ee27 3b0d 	vmul.f64	d3, d7, d13
10000d04:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10000d08:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10000d0c:	ed9d 8b02 	vldr	d8, [sp, #8]
10000d10:	ee03 7b4c 	vmls.f64	d7, d3, d12
10000d14:	ed84 7b02 	vstr	d7, [r4, #8]
10000d18:	ee38 7b0c 	vadd.f64	d7, d8, d12
10000d1c:	ee22 1b0d 	vmul.f64	d1, d2, d13
10000d20:	ee26 9b0d 	vmul.f64	d9, d6, d13
10000d24:	ee38 8b05 	vadd.f64	d8, d8, d5
10000d28:	ee37 7b45 	vsub.f64	d7, d7, d5
10000d2c:	ed9d 5b00 	vldr	d5, [sp]
10000d30:	ee38 8b03 	vadd.f64	d8, d8, d3
10000d34:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10000d38:	ee35 3b0c 	vadd.f64	d3, d5, d12
10000d3c:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10000d40:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10000d44:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10000d48:	ee35 5b00 	vadd.f64	d5, d5, d0
10000d4c:	ee33 3b40 	vsub.f64	d3, d3, d0
10000d50:	ee37 7b4b 	vsub.f64	d7, d7, d11
10000d54:	ee28 0b0d 	vmul.f64	d0, d8, d13
10000d58:	ee37 7b09 	vadd.f64	d7, d7, d9
10000d5c:	ee09 6b4c 	vmls.f64	d6, d9, d12
10000d60:	ee35 5b01 	vadd.f64	d5, d5, d1
10000d64:	ee24 9b0d 	vmul.f64	d9, d4, d13
10000d68:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10000d6c:	ee01 2b4c 	vmls.f64	d2, d1, d12
10000d70:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10000d74:	ee25 1b0d 	vmul.f64	d1, d5, d13
10000d78:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10000d7c:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10000d80:	ee33 3b4b 	vsub.f64	d3, d3, d11
10000d84:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10000d88:	ee00 8b4c 	vmls.f64	d8, d0, d12
10000d8c:	3510      	adds	r5, #16
10000d8e:	ed84 8b00 	vstr	d8, [r4]
10000d92:	ee33 3b09 	vadd.f64	d3, d3, d9
10000d96:	ed05 2b02 	vstr	d2, [r5, #-8]
10000d9a:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10000d9e:	ee27 2b0d 	vmul.f64	d2, d7, d13
10000da2:	ee01 5b4c 	vmls.f64	d5, d1, d12
10000da6:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10000daa:	ee23 1b0d 	vmul.f64	d1, d3, d13
10000dae:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10000db2:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10000db6:	464b      	mov	r3, r9
10000db8:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10000dbc:	ee02 7b4c 	vmls.f64	d7, d2, d12
10000dc0:	ed05 5b04 	vstr	d5, [r5, #-16]
10000dc4:	ee09 4b4c 	vmls.f64	d4, d9, d12
10000dc8:	ed09 7b02 	vstr	d7, [r9, #-8]
10000dcc:	ee01 3b4c 	vmls.f64	d3, d1, d12
10000dd0:	ed83 6b00 	vstr	d6, [r3]
10000dd4:	463b      	mov	r3, r7
10000dd6:	3410      	adds	r4, #16
10000dd8:	45a3      	cmp	fp, r4
10000dda:	ed07 3b02 	vstr	d3, [r7, #-8]
10000dde:	f109 0910 	add.w	r9, r9, #16
10000de2:	ed83 4b00 	vstr	d4, [r3]
10000de6:	f107 0710 	add.w	r7, r7, #16
10000dea:	f47f aea0 	bne.w	10000b2e <fndsa_vect_FFT_fp64_exact.constprop.0+0xf6>
10000dee:	e9dd 201b 	ldrd	r2, r0, [sp, #108]	@ 0x6c
10000df2:	4631      	mov	r1, r6
10000df4:	9b1d      	ldr	r3, [sp, #116]	@ 0x74
10000df6:	e00b      	b.n	10000e10 <fndsa_vect_FFT_fp64_exact.constprop.0+0x3d8>
10000df8:	00000000 	.word	0x00000000
10000dfc:	3df00000 	.word	0x3df00000
10000e00:	00000000 	.word	0x00000000
10000e04:	41f00000 	.word	0x41f00000
10000e08:	3001b0e0 	.word	0x3001b0e0
10000e0c:	300009a0 	.word	0x300009a0
10000e10:	9c1f      	ldr	r4, [sp, #124]	@ 0x7c
10000e12:	3310      	adds	r3, #16
10000e14:	429c      	cmp	r4, r3
10000e16:	4402      	add	r2, r0
10000e18:	eb01 1100 	add.w	r1, r1, r0, lsl #4
10000e1c:	eb0b 1b00 	add.w	fp, fp, r0, lsl #4
10000e20:	f47f ae42 	bne.w	10000aa8 <fndsa_vect_FFT_fp64_exact.constprop.0+0x70>
10000e24:	9c21      	ldr	r4, [sp, #132]	@ 0x84
10000e26:	9b23      	ldr	r3, [sp, #140]	@ 0x8c
10000e28:	3401      	adds	r4, #1
10000e2a:	42a3      	cmp	r3, r4
10000e2c:	f8dd e078 	ldr.w	lr, [sp, #120]	@ 0x78
10000e30:	f47f ae1d 	bne.w	10000a6e <fndsa_vect_FFT_fp64_exact.constprop.0+0x36>
10000e34:	b051      	add	sp, #324	@ 0x144
10000e36:	ecbd 8b10 	vpop	{d8-d15}
10000e3a:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10000e3e:	4770      	bx	lr
