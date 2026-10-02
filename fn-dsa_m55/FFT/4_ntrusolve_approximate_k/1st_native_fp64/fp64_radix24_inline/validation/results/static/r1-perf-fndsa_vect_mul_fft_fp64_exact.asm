
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/r1-perf/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10007240 <fndsa_vect_mul_fft_fp64_exact>:
10007240:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10007244:	2310      	movs	r3, #16
10007246:	ed2d 8b10 	vpush	{d8-d15}
1000724a:	3801      	subs	r0, #1
1000724c:	4083      	lsls	r3, r0
1000724e:	b0c9      	sub	sp, #292	@ 0x124
10007250:	eb01 0b03 	add.w	fp, r1, r3
10007254:	eb02 0a03 	add.w	sl, r2, r3
10007258:	e9cd 3a0d 	strd	r3, sl, [sp, #52]	@ 0x34
1000725c:	f8cd b03c 	str.w	fp, [sp, #60]	@ 0x3c
10007260:	2600      	movs	r6, #0
10007262:	ed9f bb97 	vldr	d11, [pc, #604]	@ 100074c0 <fndsa_vect_mul_fft_fp64_exact+0x280>
10007266:	ed9f ab98 	vldr	d10, [pc, #608]	@ 100074c8 <fndsa_vect_mul_fft_fp64_exact+0x288>
1000726a:	468a      	mov	sl, r1
1000726c:	4693      	mov	fp, r2
1000726e:	f10d 09a0 	add.w	r9, sp, #160	@ 0xa0
10007272:	f10d 08b0 	add.w	r8, sp, #176	@ 0xb0
10007276:	af24      	add	r7, sp, #144	@ 0x90
10007278:	9b0f      	ldr	r3, [sp, #60]	@ 0x3c
1000727a:	eb0a 0506 	add.w	r5, sl, r6
1000727e:	199c      	adds	r4, r3, r6
10007280:	9b0e      	ldr	r3, [sp, #56]	@ 0x38
10007282:	eb0b 0e06 	add.w	lr, fp, r6
10007286:	eb03 0c06 	add.w	ip, r3, r6
1000728a:	e895 000f 	ldmia.w	r5, {r0, r1, r2, r3}
1000728e:	e889 000f 	stmia.w	r9, {r0, r1, r2, r3}
10007292:	e894 000f 	ldmia.w	r4, {r0, r1, r2, r3}
10007296:	e888 000f 	stmia.w	r8, {r0, r1, r2, r3}
1000729a:	e89e 000f 	ldmia.w	lr, {r0, r1, r2, r3}
1000729e:	f10d 0ec0 	add.w	lr, sp, #192	@ 0xc0
100072a2:	e88e 000f 	stmia.w	lr, {r0, r1, r2, r3}
100072a6:	e89c 000f 	ldmia.w	ip, {r0, r1, r2, r3}
100072aa:	f10d 0cd0 	add.w	ip, sp, #208	@ 0xd0
100072ae:	e88c 000f 	stmia.w	ip, {r0, r1, r2, r3}
100072b2:	ed9d 7b32 	vldr	d7, [sp, #200]	@ 0xc8
100072b6:	ed9d 5b28 	vldr	d5, [sp, #160]	@ 0xa0
100072ba:	ed9d 6b30 	vldr	d6, [sp, #192]	@ 0xc0
100072be:	ed9d fb2a 	vldr	d15, [sp, #168]	@ 0xa8
100072c2:	eeb0 3b47 	vmov.f64	d3, d7
100072c6:	ed8d 7b42 	vstr	d7, [sp, #264]	@ 0x108
100072ca:	ed8d 7b06 	vstr	d7, [sp, #24]
100072ce:	ed9d 7b34 	vldr	d7, [sp, #208]	@ 0xd0
100072d2:	eeb0 0b45 	vmov.f64	d0, d5
100072d6:	eeb0 2b46 	vmov.f64	d2, d6
100072da:	eeb0 1b4f 	vmov.f64	d1, d15
100072de:	ed9d 9b2c 	vldr	d9, [sp, #176]	@ 0xb0
100072e2:	ed9d cb2e 	vldr	d12, [sp, #184]	@ 0xb8
100072e6:	ed9d db36 	vldr	d13, [sp, #216]	@ 0xd8
100072ea:	ed8d 5b38 	vstr	d5, [sp, #224]	@ 0xe0
100072ee:	ed8d 5b0a 	vstr	d5, [sp, #40]	@ 0x28
100072f2:	ed8d 6b40 	vstr	d6, [sp, #256]	@ 0x100
100072f6:	ed8d 6b08 	vstr	d6, [sp, #32]
100072fa:	ed8d 7b00 	vstr	d7, [sp]
100072fe:	ed8d fb3a 	vstr	d15, [sp, #232]	@ 0xe8
10007302:	f7ff f8e5 	bl	100064d0 <fndsa_fp64e_mul>
10007306:	ed9d 7b00 	vldr	d7, [sp]
1000730a:	eeb0 eb40 	vmov.f64	d14, d0
1000730e:	eeb0 8b41 	vmov.f64	d8, d1
10007312:	eeb0 2b47 	vmov.f64	d2, d7
10007316:	eeb0 3b4d 	vmov.f64	d3, d13
1000731a:	ed8d 0b10 	vstr	d0, [sp, #64]	@ 0x40
1000731e:	ed8d 1b12 	vstr	d1, [sp, #72]	@ 0x48
10007322:	eeb0 0b49 	vmov.f64	d0, d9
10007326:	eeb0 1b4c 	vmov.f64	d1, d12
1000732a:	ed8d 9b3c 	vstr	d9, [sp, #240]	@ 0xf0
1000732e:	ed8d cb3e 	vstr	d12, [sp, #248]	@ 0xf8
10007332:	ed8d 7b44 	vstr	d7, [sp, #272]	@ 0x110
10007336:	ed8d 9b04 	vstr	d9, [sp, #16]
1000733a:	ed8d cb02 	vstr	d12, [sp, #8]
1000733e:	ed8d db46 	vstr	d13, [sp, #280]	@ 0x118
10007342:	f7ff f8c5 	bl	100064d0 <fndsa_fp64e_mul>
10007346:	ed9d 6b02 	vldr	d6, [sp, #8]
1000734a:	eeb0 cb41 	vmov.f64	d12, d1
1000734e:	ed9d 7b06 	vldr	d7, [sp, #24]
10007352:	ee3f 1b06 	vadd.f64	d1, d15, d6
10007356:	ed9d 5b00 	vldr	d5, [sp]
1000735a:	ed9d 6b08 	vldr	d6, [sp, #32]
1000735e:	ee37 3b0d 	vadd.f64	d3, d7, d13
10007362:	ee36 2b05 	vadd.f64	d2, d6, d5
10007366:	ed9d 7b04 	vldr	d7, [sp, #16]
1000736a:	ed9d 5b0a 	vldr	d5, [sp, #40]	@ 0x28
1000736e:	eeb0 9b40 	vmov.f64	d9, d0
10007372:	ee35 0b07 	vadd.f64	d0, d5, d7
10007376:	ee23 7b0b 	vmul.f64	d7, d3, d11
1000737a:	ee21 6b0b 	vmul.f64	d6, d1, d11
1000737e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007382:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007386:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000738a:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000738e:	ee32 5b07 	vadd.f64	d5, d2, d7
10007392:	ee30 0b06 	vadd.f64	d0, d0, d6
10007396:	ee06 1b4a 	vmls.f64	d1, d6, d10
1000739a:	ee25 6b0b 	vmul.f64	d6, d5, d11
1000739e:	ee07 3b4a 	vmls.f64	d3, d7, d10
100073a2:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100073a6:	ee20 7b0b 	vmul.f64	d7, d0, d11
100073aa:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100073ae:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100073b2:	ee06 5b4a 	vmls.f64	d5, d6, d10
100073b6:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100073ba:	eeb0 6b40 	vmov.f64	d6, d0
100073be:	ee07 6b4a 	vmls.f64	d6, d7, d10
100073c2:	eeb0 2b45 	vmov.f64	d2, d5
100073c6:	eeb0 0b46 	vmov.f64	d0, d6
100073ca:	ed8d 9b14 	vstr	d9, [sp, #80]	@ 0x50
100073ce:	ed8d 1b1e 	vstr	d1, [sp, #120]	@ 0x78
100073d2:	ed8d 3b1a 	vstr	d3, [sp, #104]	@ 0x68
100073d6:	ed8d 6b1c 	vstr	d6, [sp, #112]	@ 0x70
100073da:	ed8d 5b18 	vstr	d5, [sp, #96]	@ 0x60
100073de:	ed8d cb16 	vstr	d12, [sp, #88]	@ 0x58
100073e2:	f7ff f875 	bl	100064d0 <fndsa_fp64e_mul>
100073e6:	ee38 6b0c 	vadd.f64	d6, d8, d12
100073ea:	ee26 3b0b 	vmul.f64	d3, d6, d11
100073ee:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100073f2:	ee3e 5b09 	vadd.f64	d5, d14, d9
100073f6:	eeb8 2b43 	vcvt.f64.u32	d2, s6
100073fa:	ee38 8b0a 	vadd.f64	d8, d8, d10
100073fe:	ee35 5b02 	vadd.f64	d5, d5, d2
10007402:	ee38 8b4c 	vsub.f64	d8, d8, d12
10007406:	ee31 1b0a 	vadd.f64	d1, d1, d10
1000740a:	ee30 7b0a 	vadd.f64	d7, d0, d10
1000740e:	ee02 6b4a 	vmls.f64	d6, d2, d10
10007412:	ee28 0b0b 	vmul.f64	d0, d8, d11
10007416:	ee25 2b0b 	vmul.f64	d2, d5, d11
1000741a:	ee3e 4b0a 	vadd.f64	d4, d14, d10
1000741e:	ee31 6b46 	vsub.f64	d6, d1, d6
10007422:	ee34 4b49 	vsub.f64	d4, d4, d9
10007426:	eebc 1bc2 	vcvt.u32.f64	s2, d2
1000742a:	eeb7 9b00 	vmov.f64	d9, #112	@ 0x3f800000  1.0
1000742e:	eebc 3bc0 	vcvt.u32.f64	s6, d0
10007432:	ee34 4b49 	vsub.f64	d4, d4, d9
10007436:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000743a:	eeb8 1b41 	vcvt.f64.u32	d1, s2
1000743e:	ee34 4b03 	vadd.f64	d4, d4, d3
10007442:	ee03 8b4a 	vmls.f64	d8, d3, d10
10007446:	ee01 5b4a 	vmls.f64	d5, d1, d10
1000744a:	ee26 3b0b 	vmul.f64	d3, d6, d11
1000744e:	ee37 7b45 	vsub.f64	d7, d7, d5
10007452:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10007456:	ee37 7b49 	vsub.f64	d7, d7, d9
1000745a:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000745e:	ee03 6b4a 	vmls.f64	d6, d3, d10
10007462:	ee37 7b03 	vadd.f64	d7, d7, d3
10007466:	ee24 2b0b 	vmul.f64	d2, d4, d11
1000746a:	ed8d 6b26 	vstr	d6, [sp, #152]	@ 0x98
1000746e:	ee27 6b0b 	vmul.f64	d6, d7, d11
10007472:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10007476:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000747a:	eeb8 2b42 	vcvt.f64.u32	d2, s4
1000747e:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10007482:	ee02 4b4a 	vmls.f64	d4, d2, d10
10007486:	ee06 7b4a 	vmls.f64	d7, d6, d10
1000748a:	ed8d 8b22 	vstr	d8, [sp, #136]	@ 0x88
1000748e:	ed8d 4b20 	vstr	d4, [sp, #128]	@ 0x80
10007492:	ed8d 7b24 	vstr	d7, [sp, #144]	@ 0x90
10007496:	ab20      	add	r3, sp, #128	@ 0x80
10007498:	cb0f      	ldmia	r3, {r0, r1, r2, r3}
1000749a:	e885 000f 	stmia.w	r5, {r0, r1, r2, r3}
1000749e:	e897 000f 	ldmia.w	r7, {r0, r1, r2, r3}
100074a2:	e884 000f 	stmia.w	r4, {r0, r1, r2, r3}
100074a6:	9b0d      	ldr	r3, [sp, #52]	@ 0x34
100074a8:	3610      	adds	r6, #16
100074aa:	42b3      	cmp	r3, r6
100074ac:	f47f aee4 	bne.w	10007278 <fndsa_vect_mul_fft_fp64_exact+0x38>
100074b0:	b049      	add	sp, #292	@ 0x124
100074b2:	ecbd 8b10 	vpop	{d8-d15}
100074b6:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
100074ba:	bf00      	nop
100074bc:	f3af 8000 	nop.w
100074c0:	00000000 	.word	0x00000000
100074c4:	3df00000 	.word	0x3df00000
100074c8:	00000000 	.word	0x00000000
100074cc:	41f00000 	.word	0x41f00000
