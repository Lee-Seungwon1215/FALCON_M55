
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_kat_exact_inlineasm/validation/build/kat/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10005b78 <fndsa_vect_mul_fft_fp64_exact>:
10005b78:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10005b7c:	f04f 0b01 	mov.w	fp, #1
10005b80:	ed2d 8b10 	vpush	{d8-d15}
10005b84:	2600      	movs	r6, #0
10005b86:	2410      	movs	r4, #16
10005b88:	3801      	subs	r0, #1
10005b8a:	b0c3      	sub	sp, #268	@ 0x10c
10005b8c:	fa0b fb00 	lsl.w	fp, fp, r0
10005b90:	e9cd b108 	strd	fp, r1, [sp, #32]
10005b94:	ed9f db94 	vldr	d13, [pc, #592]	@ 10005de8 <fndsa_vect_mul_fft_fp64_exact+0x270>
10005b98:	ed9f 8b95 	vldr	d8, [pc, #596]	@ 10005df0 <fndsa_vect_mul_fft_fp64_exact+0x278>
10005b9c:	eeb7 6b00 	vmov.f64	d6, #112	@ 0x3f800000  1.0
10005ba0:	46b2      	mov	sl, r6
10005ba2:	4693      	mov	fp, r2
10005ba4:	4084      	lsls	r4, r0
10005ba6:	190b      	adds	r3, r1, r4
10005ba8:	9307      	str	r3, [sp, #28]
10005baa:	1913      	adds	r3, r2, r4
10005bac:	f10d 0988 	add.w	r9, sp, #136	@ 0x88
10005bb0:	f10d 0898 	add.w	r8, sp, #152	@ 0x98
10005bb4:	9306      	str	r3, [sp, #24]
10005bb6:	af1a      	add	r7, sp, #104	@ 0x68
10005bb8:	9b09      	ldr	r3, [sp, #36]	@ 0x24
10005bba:	eb0b 0e06 	add.w	lr, fp, r6
10005bbe:	199d      	adds	r5, r3, r6
10005bc0:	9b07      	ldr	r3, [sp, #28]
10005bc2:	ed8d 6b04 	vstr	d6, [sp, #16]
10005bc6:	199c      	adds	r4, r3, r6
10005bc8:	9b06      	ldr	r3, [sp, #24]
10005bca:	f10a 0a01 	add.w	sl, sl, #1
10005bce:	eb03 0c06 	add.w	ip, r3, r6
10005bd2:	e895 000f 	ldmia.w	r5, {r0, r1, r2, r3}
10005bd6:	e889 000f 	stmia.w	r9, {r0, r1, r2, r3}
10005bda:	e894 000f 	ldmia.w	r4, {r0, r1, r2, r3}
10005bde:	e888 000f 	stmia.w	r8, {r0, r1, r2, r3}
10005be2:	e89e 000f 	ldmia.w	lr, {r0, r1, r2, r3}
10005be6:	f10d 0ea8 	add.w	lr, sp, #168	@ 0xa8
10005bea:	e88e 000f 	stmia.w	lr, {r0, r1, r2, r3}
10005bee:	e89c 000f 	ldmia.w	ip, {r0, r1, r2, r3}
10005bf2:	f10d 0cb8 	add.w	ip, sp, #184	@ 0xb8
10005bf6:	e88c 000f 	stmia.w	ip, {r0, r1, r2, r3}
10005bfa:	ed9d 4b2a 	vldr	d4, [sp, #168]	@ 0xa8
10005bfe:	ed9d 9b22 	vldr	d9, [sp, #136]	@ 0x88
10005c02:	ed9d fb24 	vldr	d15, [sp, #144]	@ 0x90
10005c06:	ed9d eb2c 	vldr	d14, [sp, #176]	@ 0xb0
10005c0a:	ed9d 7b2e 	vldr	d7, [sp, #184]	@ 0xb8
10005c0e:	eeb0 2b44 	vmov.f64	d2, d4
10005c12:	eeb0 0b49 	vmov.f64	d0, d9
10005c16:	eeb0 1b4f 	vmov.f64	d1, d15
10005c1a:	eeb0 3b4e 	vmov.f64	d3, d14
10005c1e:	ed9d ab26 	vldr	d10, [sp, #152]	@ 0x98
10005c22:	ed9d cb28 	vldr	d12, [sp, #160]	@ 0xa0
10005c26:	ed9d bb30 	vldr	d11, [sp, #192]	@ 0xc0
10005c2a:	ed8d 4b3a 	vstr	d4, [sp, #232]	@ 0xe8
10005c2e:	ed8d 4b02 	vstr	d4, [sp, #8]
10005c32:	ed8d 9b32 	vstr	d9, [sp, #200]	@ 0xc8
10005c36:	ed8d fb34 	vstr	d15, [sp, #208]	@ 0xd0
10005c3a:	ed8d eb3c 	vstr	d14, [sp, #240]	@ 0xf0
10005c3e:	ed8d 7b00 	vstr	d7, [sp]
10005c42:	f002 fbc7 	bl	100083d4 <fndsa_fp64e_mul>
10005c46:	ed9d 7b00 	vldr	d7, [sp]
10005c4a:	eeb0 3b4b 	vmov.f64	d3, d11
10005c4e:	eeb0 2b47 	vmov.f64	d2, d7
10005c52:	ed8d 0b0a 	vstr	d0, [sp, #40]	@ 0x28
10005c56:	ed8d 1b0c 	vstr	d1, [sp, #48]	@ 0x30
10005c5a:	eeb0 0b4a 	vmov.f64	d0, d10
10005c5e:	eeb0 1b4c 	vmov.f64	d1, d12
10005c62:	ed8d ab36 	vstr	d10, [sp, #216]	@ 0xd8
10005c66:	ed8d 7b3e 	vstr	d7, [sp, #248]	@ 0xf8
10005c6a:	ed8d cb38 	vstr	d12, [sp, #224]	@ 0xe0
10005c6e:	ed8d bb40 	vstr	d11, [sp, #256]	@ 0x100
10005c72:	f002 fbaf 	bl	100083d4 <fndsa_fp64e_mul>
10005c76:	ed9d 7b00 	vldr	d7, [sp]
10005c7a:	ee3f fb0c 	vadd.f64	d15, d15, d12
10005c7e:	ee3e eb0b 	vadd.f64	d14, d14, d11
10005c82:	ed9d 4b02 	vldr	d4, [sp, #8]
10005c86:	ee2f 5b0d 	vmul.f64	d5, d15, d13
10005c8a:	ee34 4b07 	vadd.f64	d4, d4, d7
10005c8e:	ee2e 7b0d 	vmul.f64	d7, d14, d13
10005c92:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10005c96:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005c9a:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10005c9e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005ca2:	ee39 9b0a 	vadd.f64	d9, d9, d10
10005ca6:	ee34 4b07 	vadd.f64	d4, d4, d7
10005caa:	ee39 9b05 	vadd.f64	d9, d9, d5
10005cae:	ee05 fb48 	vmls.f64	d15, d5, d8
10005cb2:	ee07 eb48 	vmls.f64	d14, d7, d8
10005cb6:	ee24 5b0d 	vmul.f64	d5, d4, d13
10005cba:	ee29 7b0d 	vmul.f64	d7, d9, d13
10005cbe:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10005cc2:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005cc6:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10005cca:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005cce:	ee05 4b48 	vmls.f64	d4, d5, d8
10005cd2:	ee07 9b48 	vmls.f64	d9, d7, d8
10005cd6:	eeb0 2b44 	vmov.f64	d2, d4
10005cda:	ed8d 0b0e 	vstr	d0, [sp, #56]	@ 0x38
10005cde:	ed8d 1b10 	vstr	d1, [sp, #64]	@ 0x40
10005ce2:	eeb0 0b49 	vmov.f64	d0, d9
10005ce6:	eeb0 1b4f 	vmov.f64	d1, d15
10005cea:	eeb0 3b4e 	vmov.f64	d3, d14
10005cee:	ed8d 9b16 	vstr	d9, [sp, #88]	@ 0x58
10005cf2:	ed8d 4b12 	vstr	d4, [sp, #72]	@ 0x48
10005cf6:	ed8d fb18 	vstr	d15, [sp, #96]	@ 0x60
10005cfa:	ed8d eb14 	vstr	d14, [sp, #80]	@ 0x50
10005cfe:	f002 fb69 	bl	100083d4 <fndsa_fp64e_mul>
10005d02:	ed9d 2b10 	vldr	d2, [sp, #64]	@ 0x40
10005d06:	ed9d 4b0c 	vldr	d4, [sp, #48]	@ 0x30
10005d0a:	ee34 5b02 	vadd.f64	d5, d4, d2
10005d0e:	ee25 9b0d 	vmul.f64	d9, d5, d13
10005d12:	ed9d 7b0a 	vldr	d7, [sp, #40]	@ 0x28
10005d16:	ed9d ab0e 	vldr	d10, [sp, #56]	@ 0x38
10005d1a:	ee34 4b08 	vadd.f64	d4, d4, d8
10005d1e:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10005d22:	ee37 3b0a 	vadd.f64	d3, d7, d10
10005d26:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10005d2a:	ee34 4b42 	vsub.f64	d4, d4, d2
10005d2e:	ee33 3b09 	vadd.f64	d3, d3, d9
10005d32:	ee24 2b0d 	vmul.f64	d2, d4, d13
10005d36:	ee37 7b08 	vadd.f64	d7, d7, d8
10005d3a:	ed9d 6b04 	vldr	d6, [sp, #16]
10005d3e:	ee09 5b48 	vmls.f64	d5, d9, d8
10005d42:	ee37 7b4a 	vsub.f64	d7, d7, d10
10005d46:	ee23 9b0d 	vmul.f64	d9, d3, d13
10005d4a:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10005d4e:	ee31 1b08 	vadd.f64	d1, d1, d8
10005d52:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10005d56:	ee37 7b46 	vsub.f64	d7, d7, d6
10005d5a:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10005d5e:	ee31 5b45 	vsub.f64	d5, d1, d5
10005d62:	ee37 7b02 	vadd.f64	d7, d7, d2
10005d66:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10005d6a:	ee02 4b48 	vmls.f64	d4, d2, d8
10005d6e:	ee25 1b0d 	vmul.f64	d1, d5, d13
10005d72:	ee27 2b0d 	vmul.f64	d2, d7, d13
10005d76:	ee30 0b08 	vadd.f64	d0, d0, d8
10005d7a:	ee09 3b48 	vmls.f64	d3, d9, d8
10005d7e:	ed8d 4b1c 	vstr	d4, [sp, #112]	@ 0x70
10005d82:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10005d86:	eebc 4bc1 	vcvt.u32.f64	s8, d1
10005d8a:	ee30 0b43 	vsub.f64	d0, d0, d3
10005d8e:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10005d92:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10005d96:	ee30 0b46 	vsub.f64	d0, d0, d6
10005d9a:	ee02 7b48 	vmls.f64	d7, d2, d8
10005d9e:	ee30 0b04 	vadd.f64	d0, d0, d4
10005da2:	ed8d 7b1a 	vstr	d7, [sp, #104]	@ 0x68
10005da6:	ee20 7b0d 	vmul.f64	d7, d0, d13
10005daa:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005dae:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005db2:	ee04 5b48 	vmls.f64	d5, d4, d8
10005db6:	ee07 0b48 	vmls.f64	d0, d7, d8
10005dba:	ed8d 5b20 	vstr	d5, [sp, #128]	@ 0x80
10005dbe:	ed8d 0b1e 	vstr	d0, [sp, #120]	@ 0x78
10005dc2:	e897 000f 	ldmia.w	r7, {r0, r1, r2, r3}
10005dc6:	e885 000f 	stmia.w	r5, {r0, r1, r2, r3}
10005dca:	ab1e      	add	r3, sp, #120	@ 0x78
10005dcc:	cb0f      	ldmia	r3, {r0, r1, r2, r3}
10005dce:	e884 000f 	stmia.w	r4, {r0, r1, r2, r3}
10005dd2:	9b08      	ldr	r3, [sp, #32]
10005dd4:	3610      	adds	r6, #16
10005dd6:	4553      	cmp	r3, sl
10005dd8:	f47f aeee 	bne.w	10005bb8 <fndsa_vect_mul_fft_fp64_exact+0x40>
10005ddc:	b043      	add	sp, #268	@ 0x10c
10005dde:	ecbd 8b10 	vpop	{d8-d15}
10005de2:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10005de6:	bf00      	nop
10005de8:	00000000 	.word	0x00000000
10005dec:	3df00000 	.word	0x3df00000
10005df0:	00000000 	.word	0x00000000
10005df4:	41f00000 	.word	0x41f00000
