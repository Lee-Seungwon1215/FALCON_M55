
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_kat_exact_inlineasm/validation/build/asm-perf/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10007068 <fndsa_vect_mul_fft_fp64_exact>:
10007068:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
1000706c:	f04f 0b01 	mov.w	fp, #1
10007070:	ed2d 8b10 	vpush	{d8-d15}
10007074:	2600      	movs	r6, #0
10007076:	2410      	movs	r4, #16
10007078:	3801      	subs	r0, #1
1000707a:	b0c3      	sub	sp, #268	@ 0x10c
1000707c:	fa0b fb00 	lsl.w	fp, fp, r0
10007080:	e9cd b108 	strd	fp, r1, [sp, #32]
10007084:	ed9f db94 	vldr	d13, [pc, #592]	@ 100072d8 <fndsa_vect_mul_fft_fp64_exact+0x270>
10007088:	ed9f 8b95 	vldr	d8, [pc, #596]	@ 100072e0 <fndsa_vect_mul_fft_fp64_exact+0x278>
1000708c:	eeb7 6b00 	vmov.f64	d6, #112	@ 0x3f800000  1.0
10007090:	46b2      	mov	sl, r6
10007092:	4693      	mov	fp, r2
10007094:	4084      	lsls	r4, r0
10007096:	190b      	adds	r3, r1, r4
10007098:	9307      	str	r3, [sp, #28]
1000709a:	1913      	adds	r3, r2, r4
1000709c:	f10d 0988 	add.w	r9, sp, #136	@ 0x88
100070a0:	f10d 0898 	add.w	r8, sp, #152	@ 0x98
100070a4:	9306      	str	r3, [sp, #24]
100070a6:	af1a      	add	r7, sp, #104	@ 0x68
100070a8:	9b09      	ldr	r3, [sp, #36]	@ 0x24
100070aa:	eb0b 0e06 	add.w	lr, fp, r6
100070ae:	199d      	adds	r5, r3, r6
100070b0:	9b07      	ldr	r3, [sp, #28]
100070b2:	ed8d 6b04 	vstr	d6, [sp, #16]
100070b6:	199c      	adds	r4, r3, r6
100070b8:	9b06      	ldr	r3, [sp, #24]
100070ba:	f10a 0a01 	add.w	sl, sl, #1
100070be:	eb03 0c06 	add.w	ip, r3, r6
100070c2:	e895 000f 	ldmia.w	r5, {r0, r1, r2, r3}
100070c6:	e889 000f 	stmia.w	r9, {r0, r1, r2, r3}
100070ca:	e894 000f 	ldmia.w	r4, {r0, r1, r2, r3}
100070ce:	e888 000f 	stmia.w	r8, {r0, r1, r2, r3}
100070d2:	e89e 000f 	ldmia.w	lr, {r0, r1, r2, r3}
100070d6:	f10d 0ea8 	add.w	lr, sp, #168	@ 0xa8
100070da:	e88e 000f 	stmia.w	lr, {r0, r1, r2, r3}
100070de:	e89c 000f 	ldmia.w	ip, {r0, r1, r2, r3}
100070e2:	f10d 0cb8 	add.w	ip, sp, #184	@ 0xb8
100070e6:	e88c 000f 	stmia.w	ip, {r0, r1, r2, r3}
100070ea:	ed9d 4b2a 	vldr	d4, [sp, #168]	@ 0xa8
100070ee:	ed9d 9b22 	vldr	d9, [sp, #136]	@ 0x88
100070f2:	ed9d fb24 	vldr	d15, [sp, #144]	@ 0x90
100070f6:	ed9d eb2c 	vldr	d14, [sp, #176]	@ 0xb0
100070fa:	ed9d 7b2e 	vldr	d7, [sp, #184]	@ 0xb8
100070fe:	eeb0 2b44 	vmov.f64	d2, d4
10007102:	eeb0 0b49 	vmov.f64	d0, d9
10007106:	eeb0 1b4f 	vmov.f64	d1, d15
1000710a:	eeb0 3b4e 	vmov.f64	d3, d14
1000710e:	ed9d ab26 	vldr	d10, [sp, #152]	@ 0x98
10007112:	ed9d cb28 	vldr	d12, [sp, #160]	@ 0xa0
10007116:	ed9d bb30 	vldr	d11, [sp, #192]	@ 0xc0
1000711a:	ed8d 4b3a 	vstr	d4, [sp, #232]	@ 0xe8
1000711e:	ed8d 4b02 	vstr	d4, [sp, #8]
10007122:	ed8d 9b32 	vstr	d9, [sp, #200]	@ 0xc8
10007126:	ed8d fb34 	vstr	d15, [sp, #208]	@ 0xd0
1000712a:	ed8d eb3c 	vstr	d14, [sp, #240]	@ 0xf0
1000712e:	ed8d 7b00 	vstr	d7, [sp]
10007132:	f003 f8f3 	bl	1000a31c <fndsa_fp64e_mul>
10007136:	ed9d 7b00 	vldr	d7, [sp]
1000713a:	eeb0 3b4b 	vmov.f64	d3, d11
1000713e:	eeb0 2b47 	vmov.f64	d2, d7
10007142:	ed8d 0b0a 	vstr	d0, [sp, #40]	@ 0x28
10007146:	ed8d 1b0c 	vstr	d1, [sp, #48]	@ 0x30
1000714a:	eeb0 0b4a 	vmov.f64	d0, d10
1000714e:	eeb0 1b4c 	vmov.f64	d1, d12
10007152:	ed8d ab36 	vstr	d10, [sp, #216]	@ 0xd8
10007156:	ed8d 7b3e 	vstr	d7, [sp, #248]	@ 0xf8
1000715a:	ed8d cb38 	vstr	d12, [sp, #224]	@ 0xe0
1000715e:	ed8d bb40 	vstr	d11, [sp, #256]	@ 0x100
10007162:	f003 f8db 	bl	1000a31c <fndsa_fp64e_mul>
10007166:	ed9d 7b00 	vldr	d7, [sp]
1000716a:	ee3f fb0c 	vadd.f64	d15, d15, d12
1000716e:	ee3e eb0b 	vadd.f64	d14, d14, d11
10007172:	ed9d 4b02 	vldr	d4, [sp, #8]
10007176:	ee2f 5b0d 	vmul.f64	d5, d15, d13
1000717a:	ee34 4b07 	vadd.f64	d4, d4, d7
1000717e:	ee2e 7b0d 	vmul.f64	d7, d14, d13
10007182:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10007186:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000718a:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000718e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007192:	ee39 9b0a 	vadd.f64	d9, d9, d10
10007196:	ee34 4b07 	vadd.f64	d4, d4, d7
1000719a:	ee39 9b05 	vadd.f64	d9, d9, d5
1000719e:	ee05 fb48 	vmls.f64	d15, d5, d8
100071a2:	ee07 eb48 	vmls.f64	d14, d7, d8
100071a6:	ee24 5b0d 	vmul.f64	d5, d4, d13
100071aa:	ee29 7b0d 	vmul.f64	d7, d9, d13
100071ae:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100071b2:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100071b6:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100071ba:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100071be:	ee05 4b48 	vmls.f64	d4, d5, d8
100071c2:	ee07 9b48 	vmls.f64	d9, d7, d8
100071c6:	eeb0 2b44 	vmov.f64	d2, d4
100071ca:	ed8d 0b0e 	vstr	d0, [sp, #56]	@ 0x38
100071ce:	ed8d 1b10 	vstr	d1, [sp, #64]	@ 0x40
100071d2:	eeb0 0b49 	vmov.f64	d0, d9
100071d6:	eeb0 1b4f 	vmov.f64	d1, d15
100071da:	eeb0 3b4e 	vmov.f64	d3, d14
100071de:	ed8d 9b16 	vstr	d9, [sp, #88]	@ 0x58
100071e2:	ed8d 4b12 	vstr	d4, [sp, #72]	@ 0x48
100071e6:	ed8d fb18 	vstr	d15, [sp, #96]	@ 0x60
100071ea:	ed8d eb14 	vstr	d14, [sp, #80]	@ 0x50
100071ee:	f003 f895 	bl	1000a31c <fndsa_fp64e_mul>
100071f2:	ed9d 2b10 	vldr	d2, [sp, #64]	@ 0x40
100071f6:	ed9d 4b0c 	vldr	d4, [sp, #48]	@ 0x30
100071fa:	ee34 5b02 	vadd.f64	d5, d4, d2
100071fe:	ee25 9b0d 	vmul.f64	d9, d5, d13
10007202:	ed9d 7b0a 	vldr	d7, [sp, #40]	@ 0x28
10007206:	ed9d ab0e 	vldr	d10, [sp, #56]	@ 0x38
1000720a:	ee34 4b08 	vadd.f64	d4, d4, d8
1000720e:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10007212:	ee37 3b0a 	vadd.f64	d3, d7, d10
10007216:	eeb8 9b49 	vcvt.f64.u32	d9, s18
1000721a:	ee34 4b42 	vsub.f64	d4, d4, d2
1000721e:	ee33 3b09 	vadd.f64	d3, d3, d9
10007222:	ee24 2b0d 	vmul.f64	d2, d4, d13
10007226:	ee37 7b08 	vadd.f64	d7, d7, d8
1000722a:	ed9d 6b04 	vldr	d6, [sp, #16]
1000722e:	ee09 5b48 	vmls.f64	d5, d9, d8
10007232:	ee37 7b4a 	vsub.f64	d7, d7, d10
10007236:	ee23 9b0d 	vmul.f64	d9, d3, d13
1000723a:	eebc 2bc2 	vcvt.u32.f64	s4, d2
1000723e:	ee31 1b08 	vadd.f64	d1, d1, d8
10007242:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10007246:	ee37 7b46 	vsub.f64	d7, d7, d6
1000724a:	eebc 9bc9 	vcvt.u32.f64	s18, d9
1000724e:	ee31 5b45 	vsub.f64	d5, d1, d5
10007252:	ee37 7b02 	vadd.f64	d7, d7, d2
10007256:	eeb8 9b49 	vcvt.f64.u32	d9, s18
1000725a:	ee02 4b48 	vmls.f64	d4, d2, d8
1000725e:	ee25 1b0d 	vmul.f64	d1, d5, d13
10007262:	ee27 2b0d 	vmul.f64	d2, d7, d13
10007266:	ee30 0b08 	vadd.f64	d0, d0, d8
1000726a:	ee09 3b48 	vmls.f64	d3, d9, d8
1000726e:	ed8d 4b1c 	vstr	d4, [sp, #112]	@ 0x70
10007272:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10007276:	eebc 4bc1 	vcvt.u32.f64	s8, d1
1000727a:	ee30 0b43 	vsub.f64	d0, d0, d3
1000727e:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10007282:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10007286:	ee30 0b46 	vsub.f64	d0, d0, d6
1000728a:	ee02 7b48 	vmls.f64	d7, d2, d8
1000728e:	ee30 0b04 	vadd.f64	d0, d0, d4
10007292:	ed8d 7b1a 	vstr	d7, [sp, #104]	@ 0x68
10007296:	ee20 7b0d 	vmul.f64	d7, d0, d13
1000729a:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000729e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100072a2:	ee04 5b48 	vmls.f64	d5, d4, d8
100072a6:	ee07 0b48 	vmls.f64	d0, d7, d8
100072aa:	ed8d 5b20 	vstr	d5, [sp, #128]	@ 0x80
100072ae:	ed8d 0b1e 	vstr	d0, [sp, #120]	@ 0x78
100072b2:	e897 000f 	ldmia.w	r7, {r0, r1, r2, r3}
100072b6:	e885 000f 	stmia.w	r5, {r0, r1, r2, r3}
100072ba:	ab1e      	add	r3, sp, #120	@ 0x78
100072bc:	cb0f      	ldmia	r3, {r0, r1, r2, r3}
100072be:	e884 000f 	stmia.w	r4, {r0, r1, r2, r3}
100072c2:	9b08      	ldr	r3, [sp, #32]
100072c4:	3610      	adds	r6, #16
100072c6:	4553      	cmp	r3, sl
100072c8:	f47f aeee 	bne.w	100070a8 <fndsa_vect_mul_fft_fp64_exact+0x40>
100072cc:	b043      	add	sp, #268	@ 0x10c
100072ce:	ecbd 8b10 	vpop	{d8-d15}
100072d2:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
100072d6:	bf00      	nop
100072d8:	00000000 	.word	0x00000000
100072dc:	3df00000 	.word	0x3df00000
100072e0:	00000000 	.word	0x00000000
100072e4:	41f00000 	.word	0x41f00000
