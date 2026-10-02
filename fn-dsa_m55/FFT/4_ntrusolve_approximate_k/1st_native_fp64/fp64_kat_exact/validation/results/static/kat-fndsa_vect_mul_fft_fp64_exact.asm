
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_kat_exact/validation/build/kat/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10005d38 <fndsa_vect_mul_fft_fp64_exact>:
10005d38:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10005d3c:	2310      	movs	r3, #16
10005d3e:	ed2d 8b10 	vpush	{d8-d15}
10005d42:	3801      	subs	r0, #1
10005d44:	4083      	lsls	r3, r0
10005d46:	b0c9      	sub	sp, #292	@ 0x124
10005d48:	eb01 0b03 	add.w	fp, r1, r3
10005d4c:	eb02 0a03 	add.w	sl, r2, r3
10005d50:	e9cd 3a0d 	strd	r3, sl, [sp, #52]	@ 0x34
10005d54:	f8cd b03c 	str.w	fp, [sp, #60]	@ 0x3c
10005d58:	2600      	movs	r6, #0
10005d5a:	ed9f bb97 	vldr	d11, [pc, #604]	@ 10005fb8 <fndsa_vect_mul_fft_fp64_exact+0x280>
10005d5e:	ed9f ab98 	vldr	d10, [pc, #608]	@ 10005fc0 <fndsa_vect_mul_fft_fp64_exact+0x288>
10005d62:	468a      	mov	sl, r1
10005d64:	4693      	mov	fp, r2
10005d66:	f10d 09a0 	add.w	r9, sp, #160	@ 0xa0
10005d6a:	f10d 08b0 	add.w	r8, sp, #176	@ 0xb0
10005d6e:	af24      	add	r7, sp, #144	@ 0x90
10005d70:	9b0f      	ldr	r3, [sp, #60]	@ 0x3c
10005d72:	eb0a 0506 	add.w	r5, sl, r6
10005d76:	199c      	adds	r4, r3, r6
10005d78:	9b0e      	ldr	r3, [sp, #56]	@ 0x38
10005d7a:	eb0b 0e06 	add.w	lr, fp, r6
10005d7e:	eb03 0c06 	add.w	ip, r3, r6
10005d82:	e895 000f 	ldmia.w	r5, {r0, r1, r2, r3}
10005d86:	e889 000f 	stmia.w	r9, {r0, r1, r2, r3}
10005d8a:	e894 000f 	ldmia.w	r4, {r0, r1, r2, r3}
10005d8e:	e888 000f 	stmia.w	r8, {r0, r1, r2, r3}
10005d92:	e89e 000f 	ldmia.w	lr, {r0, r1, r2, r3}
10005d96:	f10d 0ec0 	add.w	lr, sp, #192	@ 0xc0
10005d9a:	e88e 000f 	stmia.w	lr, {r0, r1, r2, r3}
10005d9e:	e89c 000f 	ldmia.w	ip, {r0, r1, r2, r3}
10005da2:	f10d 0cd0 	add.w	ip, sp, #208	@ 0xd0
10005da6:	e88c 000f 	stmia.w	ip, {r0, r1, r2, r3}
10005daa:	ed9d 7b32 	vldr	d7, [sp, #200]	@ 0xc8
10005dae:	ed9d 5b28 	vldr	d5, [sp, #160]	@ 0xa0
10005db2:	ed9d 6b30 	vldr	d6, [sp, #192]	@ 0xc0
10005db6:	ed9d fb2a 	vldr	d15, [sp, #168]	@ 0xa8
10005dba:	eeb0 3b47 	vmov.f64	d3, d7
10005dbe:	ed8d 7b42 	vstr	d7, [sp, #264]	@ 0x108
10005dc2:	ed8d 7b06 	vstr	d7, [sp, #24]
10005dc6:	ed9d 7b34 	vldr	d7, [sp, #208]	@ 0xd0
10005dca:	eeb0 0b45 	vmov.f64	d0, d5
10005dce:	eeb0 2b46 	vmov.f64	d2, d6
10005dd2:	eeb0 1b4f 	vmov.f64	d1, d15
10005dd6:	ed9d 9b2c 	vldr	d9, [sp, #176]	@ 0xb0
10005dda:	ed9d cb2e 	vldr	d12, [sp, #184]	@ 0xb8
10005dde:	ed9d db36 	vldr	d13, [sp, #216]	@ 0xd8
10005de2:	ed8d 5b38 	vstr	d5, [sp, #224]	@ 0xe0
10005de6:	ed8d 5b0a 	vstr	d5, [sp, #40]	@ 0x28
10005dea:	ed8d 6b40 	vstr	d6, [sp, #256]	@ 0x100
10005dee:	ed8d 6b08 	vstr	d6, [sp, #32]
10005df2:	ed8d 7b00 	vstr	d7, [sp]
10005df6:	ed8d fb3a 	vstr	d15, [sp, #232]	@ 0xe8
10005dfa:	f7ff f8f1 	bl	10004fe0 <fndsa_fp64e_mul>
10005dfe:	ed9d 7b00 	vldr	d7, [sp]
10005e02:	eeb0 eb40 	vmov.f64	d14, d0
10005e06:	eeb0 8b41 	vmov.f64	d8, d1
10005e0a:	eeb0 2b47 	vmov.f64	d2, d7
10005e0e:	eeb0 3b4d 	vmov.f64	d3, d13
10005e12:	ed8d 0b10 	vstr	d0, [sp, #64]	@ 0x40
10005e16:	ed8d 1b12 	vstr	d1, [sp, #72]	@ 0x48
10005e1a:	eeb0 0b49 	vmov.f64	d0, d9
10005e1e:	eeb0 1b4c 	vmov.f64	d1, d12
10005e22:	ed8d 9b3c 	vstr	d9, [sp, #240]	@ 0xf0
10005e26:	ed8d cb3e 	vstr	d12, [sp, #248]	@ 0xf8
10005e2a:	ed8d 7b44 	vstr	d7, [sp, #272]	@ 0x110
10005e2e:	ed8d 9b04 	vstr	d9, [sp, #16]
10005e32:	ed8d cb02 	vstr	d12, [sp, #8]
10005e36:	ed8d db46 	vstr	d13, [sp, #280]	@ 0x118
10005e3a:	f7ff f8d1 	bl	10004fe0 <fndsa_fp64e_mul>
10005e3e:	ed9d 6b02 	vldr	d6, [sp, #8]
10005e42:	eeb0 cb41 	vmov.f64	d12, d1
10005e46:	ed9d 7b06 	vldr	d7, [sp, #24]
10005e4a:	ee3f 1b06 	vadd.f64	d1, d15, d6
10005e4e:	ed9d 5b00 	vldr	d5, [sp]
10005e52:	ed9d 6b08 	vldr	d6, [sp, #32]
10005e56:	ee37 3b0d 	vadd.f64	d3, d7, d13
10005e5a:	ee36 2b05 	vadd.f64	d2, d6, d5
10005e5e:	ed9d 7b04 	vldr	d7, [sp, #16]
10005e62:	ed9d 5b0a 	vldr	d5, [sp, #40]	@ 0x28
10005e66:	eeb0 9b40 	vmov.f64	d9, d0
10005e6a:	ee35 0b07 	vadd.f64	d0, d5, d7
10005e6e:	ee23 7b0b 	vmul.f64	d7, d3, d11
10005e72:	ee21 6b0b 	vmul.f64	d6, d1, d11
10005e76:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005e7a:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10005e7e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005e82:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005e86:	ee32 5b07 	vadd.f64	d5, d2, d7
10005e8a:	ee30 0b06 	vadd.f64	d0, d0, d6
10005e8e:	ee06 1b4a 	vmls.f64	d1, d6, d10
10005e92:	ee25 6b0b 	vmul.f64	d6, d5, d11
10005e96:	ee07 3b4a 	vmls.f64	d3, d7, d10
10005e9a:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10005e9e:	ee20 7b0b 	vmul.f64	d7, d0, d11
10005ea2:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005ea6:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005eaa:	ee06 5b4a 	vmls.f64	d5, d6, d10
10005eae:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005eb2:	eeb0 6b40 	vmov.f64	d6, d0
10005eb6:	ee07 6b4a 	vmls.f64	d6, d7, d10
10005eba:	eeb0 2b45 	vmov.f64	d2, d5
10005ebe:	eeb0 0b46 	vmov.f64	d0, d6
10005ec2:	ed8d 9b14 	vstr	d9, [sp, #80]	@ 0x50
10005ec6:	ed8d 1b1e 	vstr	d1, [sp, #120]	@ 0x78
10005eca:	ed8d 3b1a 	vstr	d3, [sp, #104]	@ 0x68
10005ece:	ed8d 6b1c 	vstr	d6, [sp, #112]	@ 0x70
10005ed2:	ed8d 5b18 	vstr	d5, [sp, #96]	@ 0x60
10005ed6:	ed8d cb16 	vstr	d12, [sp, #88]	@ 0x58
10005eda:	f7ff f881 	bl	10004fe0 <fndsa_fp64e_mul>
10005ede:	ee38 6b0c 	vadd.f64	d6, d8, d12
10005ee2:	ee26 3b0b 	vmul.f64	d3, d6, d11
10005ee6:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10005eea:	ee3e 5b09 	vadd.f64	d5, d14, d9
10005eee:	eeb8 2b43 	vcvt.f64.u32	d2, s6
10005ef2:	ee38 8b0a 	vadd.f64	d8, d8, d10
10005ef6:	ee35 5b02 	vadd.f64	d5, d5, d2
10005efa:	ee38 8b4c 	vsub.f64	d8, d8, d12
10005efe:	ee31 1b0a 	vadd.f64	d1, d1, d10
10005f02:	ee30 7b0a 	vadd.f64	d7, d0, d10
10005f06:	ee02 6b4a 	vmls.f64	d6, d2, d10
10005f0a:	ee28 0b0b 	vmul.f64	d0, d8, d11
10005f0e:	ee25 2b0b 	vmul.f64	d2, d5, d11
10005f12:	ee3e 4b0a 	vadd.f64	d4, d14, d10
10005f16:	ee31 6b46 	vsub.f64	d6, d1, d6
10005f1a:	ee34 4b49 	vsub.f64	d4, d4, d9
10005f1e:	eebc 1bc2 	vcvt.u32.f64	s2, d2
10005f22:	eeb7 9b00 	vmov.f64	d9, #112	@ 0x3f800000  1.0
10005f26:	eebc 3bc0 	vcvt.u32.f64	s6, d0
10005f2a:	ee34 4b49 	vsub.f64	d4, d4, d9
10005f2e:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10005f32:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10005f36:	ee34 4b03 	vadd.f64	d4, d4, d3
10005f3a:	ee03 8b4a 	vmls.f64	d8, d3, d10
10005f3e:	ee01 5b4a 	vmls.f64	d5, d1, d10
10005f42:	ee26 3b0b 	vmul.f64	d3, d6, d11
10005f46:	ee37 7b45 	vsub.f64	d7, d7, d5
10005f4a:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10005f4e:	ee37 7b49 	vsub.f64	d7, d7, d9
10005f52:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10005f56:	ee03 6b4a 	vmls.f64	d6, d3, d10
10005f5a:	ee37 7b03 	vadd.f64	d7, d7, d3
10005f5e:	ee24 2b0b 	vmul.f64	d2, d4, d11
10005f62:	ed8d 6b26 	vstr	d6, [sp, #152]	@ 0x98
10005f66:	ee27 6b0b 	vmul.f64	d6, d7, d11
10005f6a:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10005f6e:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10005f72:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10005f76:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005f7a:	ee02 4b4a 	vmls.f64	d4, d2, d10
10005f7e:	ee06 7b4a 	vmls.f64	d7, d6, d10
10005f82:	ed8d 8b22 	vstr	d8, [sp, #136]	@ 0x88
10005f86:	ed8d 4b20 	vstr	d4, [sp, #128]	@ 0x80
10005f8a:	ed8d 7b24 	vstr	d7, [sp, #144]	@ 0x90
10005f8e:	ab20      	add	r3, sp, #128	@ 0x80
10005f90:	cb0f      	ldmia	r3, {r0, r1, r2, r3}
10005f92:	e885 000f 	stmia.w	r5, {r0, r1, r2, r3}
10005f96:	e897 000f 	ldmia.w	r7, {r0, r1, r2, r3}
10005f9a:	e884 000f 	stmia.w	r4, {r0, r1, r2, r3}
10005f9e:	9b0d      	ldr	r3, [sp, #52]	@ 0x34
10005fa0:	3610      	adds	r6, #16
10005fa2:	42b3      	cmp	r3, r6
10005fa4:	f47f aee4 	bne.w	10005d70 <fndsa_vect_mul_fft_fp64_exact+0x38>
10005fa8:	b049      	add	sp, #292	@ 0x124
10005faa:	ecbd 8b10 	vpop	{d8-d15}
10005fae:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10005fb2:	bf00      	nop
10005fb4:	f3af 8000 	nop.w
10005fb8:	00000000 	.word	0x00000000
10005fbc:	3df00000 	.word	0x3df00000
10005fc0:	00000000 	.word	0x00000000
10005fc4:	41f00000 	.word	0x41f00000
