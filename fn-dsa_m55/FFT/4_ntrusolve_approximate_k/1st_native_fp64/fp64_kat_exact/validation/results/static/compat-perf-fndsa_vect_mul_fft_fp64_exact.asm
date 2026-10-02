
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_kat_exact/validation/build/compat-perf/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10007228 <fndsa_vect_mul_fft_fp64_exact>:
10007228:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
1000722c:	2310      	movs	r3, #16
1000722e:	ed2d 8b10 	vpush	{d8-d15}
10007232:	3801      	subs	r0, #1
10007234:	4083      	lsls	r3, r0
10007236:	b0c9      	sub	sp, #292	@ 0x124
10007238:	eb01 0b03 	add.w	fp, r1, r3
1000723c:	eb02 0a03 	add.w	sl, r2, r3
10007240:	e9cd 3a0d 	strd	r3, sl, [sp, #52]	@ 0x34
10007244:	f8cd b03c 	str.w	fp, [sp, #60]	@ 0x3c
10007248:	2600      	movs	r6, #0
1000724a:	ed9f bb97 	vldr	d11, [pc, #604]	@ 100074a8 <fndsa_vect_mul_fft_fp64_exact+0x280>
1000724e:	ed9f ab98 	vldr	d10, [pc, #608]	@ 100074b0 <fndsa_vect_mul_fft_fp64_exact+0x288>
10007252:	468a      	mov	sl, r1
10007254:	4693      	mov	fp, r2
10007256:	f10d 09a0 	add.w	r9, sp, #160	@ 0xa0
1000725a:	f10d 08b0 	add.w	r8, sp, #176	@ 0xb0
1000725e:	af24      	add	r7, sp, #144	@ 0x90
10007260:	9b0f      	ldr	r3, [sp, #60]	@ 0x3c
10007262:	eb0a 0506 	add.w	r5, sl, r6
10007266:	199c      	adds	r4, r3, r6
10007268:	9b0e      	ldr	r3, [sp, #56]	@ 0x38
1000726a:	eb0b 0e06 	add.w	lr, fp, r6
1000726e:	eb03 0c06 	add.w	ip, r3, r6
10007272:	e895 000f 	ldmia.w	r5, {r0, r1, r2, r3}
10007276:	e889 000f 	stmia.w	r9, {r0, r1, r2, r3}
1000727a:	e894 000f 	ldmia.w	r4, {r0, r1, r2, r3}
1000727e:	e888 000f 	stmia.w	r8, {r0, r1, r2, r3}
10007282:	e89e 000f 	ldmia.w	lr, {r0, r1, r2, r3}
10007286:	f10d 0ec0 	add.w	lr, sp, #192	@ 0xc0
1000728a:	e88e 000f 	stmia.w	lr, {r0, r1, r2, r3}
1000728e:	e89c 000f 	ldmia.w	ip, {r0, r1, r2, r3}
10007292:	f10d 0cd0 	add.w	ip, sp, #208	@ 0xd0
10007296:	e88c 000f 	stmia.w	ip, {r0, r1, r2, r3}
1000729a:	ed9d 7b32 	vldr	d7, [sp, #200]	@ 0xc8
1000729e:	ed9d 5b28 	vldr	d5, [sp, #160]	@ 0xa0
100072a2:	ed9d 6b30 	vldr	d6, [sp, #192]	@ 0xc0
100072a6:	ed9d fb2a 	vldr	d15, [sp, #168]	@ 0xa8
100072aa:	eeb0 3b47 	vmov.f64	d3, d7
100072ae:	ed8d 7b42 	vstr	d7, [sp, #264]	@ 0x108
100072b2:	ed8d 7b06 	vstr	d7, [sp, #24]
100072b6:	ed9d 7b34 	vldr	d7, [sp, #208]	@ 0xd0
100072ba:	eeb0 0b45 	vmov.f64	d0, d5
100072be:	eeb0 2b46 	vmov.f64	d2, d6
100072c2:	eeb0 1b4f 	vmov.f64	d1, d15
100072c6:	ed9d 9b2c 	vldr	d9, [sp, #176]	@ 0xb0
100072ca:	ed9d cb2e 	vldr	d12, [sp, #184]	@ 0xb8
100072ce:	ed9d db36 	vldr	d13, [sp, #216]	@ 0xd8
100072d2:	ed8d 5b38 	vstr	d5, [sp, #224]	@ 0xe0
100072d6:	ed8d 5b0a 	vstr	d5, [sp, #40]	@ 0x28
100072da:	ed8d 6b40 	vstr	d6, [sp, #256]	@ 0x100
100072de:	ed8d 6b08 	vstr	d6, [sp, #32]
100072e2:	ed8d 7b00 	vstr	d7, [sp]
100072e6:	ed8d fb3a 	vstr	d15, [sp, #232]	@ 0xe8
100072ea:	f7ff f8f1 	bl	100064d0 <fndsa_fp64e_mul>
100072ee:	ed9d 7b00 	vldr	d7, [sp]
100072f2:	eeb0 eb40 	vmov.f64	d14, d0
100072f6:	eeb0 8b41 	vmov.f64	d8, d1
100072fa:	eeb0 2b47 	vmov.f64	d2, d7
100072fe:	eeb0 3b4d 	vmov.f64	d3, d13
10007302:	ed8d 0b10 	vstr	d0, [sp, #64]	@ 0x40
10007306:	ed8d 1b12 	vstr	d1, [sp, #72]	@ 0x48
1000730a:	eeb0 0b49 	vmov.f64	d0, d9
1000730e:	eeb0 1b4c 	vmov.f64	d1, d12
10007312:	ed8d 9b3c 	vstr	d9, [sp, #240]	@ 0xf0
10007316:	ed8d cb3e 	vstr	d12, [sp, #248]	@ 0xf8
1000731a:	ed8d 7b44 	vstr	d7, [sp, #272]	@ 0x110
1000731e:	ed8d 9b04 	vstr	d9, [sp, #16]
10007322:	ed8d cb02 	vstr	d12, [sp, #8]
10007326:	ed8d db46 	vstr	d13, [sp, #280]	@ 0x118
1000732a:	f7ff f8d1 	bl	100064d0 <fndsa_fp64e_mul>
1000732e:	ed9d 6b02 	vldr	d6, [sp, #8]
10007332:	eeb0 cb41 	vmov.f64	d12, d1
10007336:	ed9d 7b06 	vldr	d7, [sp, #24]
1000733a:	ee3f 1b06 	vadd.f64	d1, d15, d6
1000733e:	ed9d 5b00 	vldr	d5, [sp]
10007342:	ed9d 6b08 	vldr	d6, [sp, #32]
10007346:	ee37 3b0d 	vadd.f64	d3, d7, d13
1000734a:	ee36 2b05 	vadd.f64	d2, d6, d5
1000734e:	ed9d 7b04 	vldr	d7, [sp, #16]
10007352:	ed9d 5b0a 	vldr	d5, [sp, #40]	@ 0x28
10007356:	eeb0 9b40 	vmov.f64	d9, d0
1000735a:	ee35 0b07 	vadd.f64	d0, d5, d7
1000735e:	ee23 7b0b 	vmul.f64	d7, d3, d11
10007362:	ee21 6b0b 	vmul.f64	d6, d1, d11
10007366:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000736a:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000736e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007372:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10007376:	ee32 5b07 	vadd.f64	d5, d2, d7
1000737a:	ee30 0b06 	vadd.f64	d0, d0, d6
1000737e:	ee06 1b4a 	vmls.f64	d1, d6, d10
10007382:	ee25 6b0b 	vmul.f64	d6, d5, d11
10007386:	ee07 3b4a 	vmls.f64	d3, d7, d10
1000738a:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000738e:	ee20 7b0b 	vmul.f64	d7, d0, d11
10007392:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10007396:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000739a:	ee06 5b4a 	vmls.f64	d5, d6, d10
1000739e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100073a2:	eeb0 6b40 	vmov.f64	d6, d0
100073a6:	ee07 6b4a 	vmls.f64	d6, d7, d10
100073aa:	eeb0 2b45 	vmov.f64	d2, d5
100073ae:	eeb0 0b46 	vmov.f64	d0, d6
100073b2:	ed8d 9b14 	vstr	d9, [sp, #80]	@ 0x50
100073b6:	ed8d 1b1e 	vstr	d1, [sp, #120]	@ 0x78
100073ba:	ed8d 3b1a 	vstr	d3, [sp, #104]	@ 0x68
100073be:	ed8d 6b1c 	vstr	d6, [sp, #112]	@ 0x70
100073c2:	ed8d 5b18 	vstr	d5, [sp, #96]	@ 0x60
100073c6:	ed8d cb16 	vstr	d12, [sp, #88]	@ 0x58
100073ca:	f7ff f881 	bl	100064d0 <fndsa_fp64e_mul>
100073ce:	ee38 6b0c 	vadd.f64	d6, d8, d12
100073d2:	ee26 3b0b 	vmul.f64	d3, d6, d11
100073d6:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100073da:	ee3e 5b09 	vadd.f64	d5, d14, d9
100073de:	eeb8 2b43 	vcvt.f64.u32	d2, s6
100073e2:	ee38 8b0a 	vadd.f64	d8, d8, d10
100073e6:	ee35 5b02 	vadd.f64	d5, d5, d2
100073ea:	ee38 8b4c 	vsub.f64	d8, d8, d12
100073ee:	ee31 1b0a 	vadd.f64	d1, d1, d10
100073f2:	ee30 7b0a 	vadd.f64	d7, d0, d10
100073f6:	ee02 6b4a 	vmls.f64	d6, d2, d10
100073fa:	ee28 0b0b 	vmul.f64	d0, d8, d11
100073fe:	ee25 2b0b 	vmul.f64	d2, d5, d11
10007402:	ee3e 4b0a 	vadd.f64	d4, d14, d10
10007406:	ee31 6b46 	vsub.f64	d6, d1, d6
1000740a:	ee34 4b49 	vsub.f64	d4, d4, d9
1000740e:	eebc 1bc2 	vcvt.u32.f64	s2, d2
10007412:	eeb7 9b00 	vmov.f64	d9, #112	@ 0x3f800000  1.0
10007416:	eebc 3bc0 	vcvt.u32.f64	s6, d0
1000741a:	ee34 4b49 	vsub.f64	d4, d4, d9
1000741e:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10007422:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10007426:	ee34 4b03 	vadd.f64	d4, d4, d3
1000742a:	ee03 8b4a 	vmls.f64	d8, d3, d10
1000742e:	ee01 5b4a 	vmls.f64	d5, d1, d10
10007432:	ee26 3b0b 	vmul.f64	d3, d6, d11
10007436:	ee37 7b45 	vsub.f64	d7, d7, d5
1000743a:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000743e:	ee37 7b49 	vsub.f64	d7, d7, d9
10007442:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10007446:	ee03 6b4a 	vmls.f64	d6, d3, d10
1000744a:	ee37 7b03 	vadd.f64	d7, d7, d3
1000744e:	ee24 2b0b 	vmul.f64	d2, d4, d11
10007452:	ed8d 6b26 	vstr	d6, [sp, #152]	@ 0x98
10007456:	ee27 6b0b 	vmul.f64	d6, d7, d11
1000745a:	eebc 2bc2 	vcvt.u32.f64	s4, d2
1000745e:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007462:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10007466:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000746a:	ee02 4b4a 	vmls.f64	d4, d2, d10
1000746e:	ee06 7b4a 	vmls.f64	d7, d6, d10
10007472:	ed8d 8b22 	vstr	d8, [sp, #136]	@ 0x88
10007476:	ed8d 4b20 	vstr	d4, [sp, #128]	@ 0x80
1000747a:	ed8d 7b24 	vstr	d7, [sp, #144]	@ 0x90
1000747e:	ab20      	add	r3, sp, #128	@ 0x80
10007480:	cb0f      	ldmia	r3, {r0, r1, r2, r3}
10007482:	e885 000f 	stmia.w	r5, {r0, r1, r2, r3}
10007486:	e897 000f 	ldmia.w	r7, {r0, r1, r2, r3}
1000748a:	e884 000f 	stmia.w	r4, {r0, r1, r2, r3}
1000748e:	9b0d      	ldr	r3, [sp, #52]	@ 0x34
10007490:	3610      	adds	r6, #16
10007492:	42b3      	cmp	r3, r6
10007494:	f47f aee4 	bne.w	10007260 <fndsa_vect_mul_fft_fp64_exact+0x38>
10007498:	b049      	add	sp, #292	@ 0x124
1000749a:	ecbd 8b10 	vpop	{d8-d15}
1000749e:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
100074a2:	bf00      	nop
100074a4:	f3af 8000 	nop.w
100074a8:	00000000 	.word	0x00000000
100074ac:	3df00000 	.word	0x3df00000
100074b0:	00000000 	.word	0x00000000
100074b4:	41f00000 	.word	0x41f00000
