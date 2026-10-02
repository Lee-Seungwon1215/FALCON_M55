
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/r2-perf/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10007568 <fndsa_vect_mul_fft_fp64_exact>:
10007568:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
1000756c:	2310      	movs	r3, #16
1000756e:	ed2d 8b10 	vpush	{d8-d15}
10007572:	3801      	subs	r0, #1
10007574:	4083      	lsls	r3, r0
10007576:	b0c9      	sub	sp, #292	@ 0x124
10007578:	eb01 0b03 	add.w	fp, r1, r3
1000757c:	eb02 0a03 	add.w	sl, r2, r3
10007580:	e9cd 3a0d 	strd	r3, sl, [sp, #52]	@ 0x34
10007584:	f8cd b03c 	str.w	fp, [sp, #60]	@ 0x3c
10007588:	2600      	movs	r6, #0
1000758a:	ed9f bb97 	vldr	d11, [pc, #604]	@ 100077e8 <fndsa_vect_mul_fft_fp64_exact+0x280>
1000758e:	ed9f ab98 	vldr	d10, [pc, #608]	@ 100077f0 <fndsa_vect_mul_fft_fp64_exact+0x288>
10007592:	468a      	mov	sl, r1
10007594:	4693      	mov	fp, r2
10007596:	f10d 09a0 	add.w	r9, sp, #160	@ 0xa0
1000759a:	f10d 08b0 	add.w	r8, sp, #176	@ 0xb0
1000759e:	af24      	add	r7, sp, #144	@ 0x90
100075a0:	9b0f      	ldr	r3, [sp, #60]	@ 0x3c
100075a2:	eb0a 0506 	add.w	r5, sl, r6
100075a6:	199c      	adds	r4, r3, r6
100075a8:	9b0e      	ldr	r3, [sp, #56]	@ 0x38
100075aa:	eb0b 0e06 	add.w	lr, fp, r6
100075ae:	eb03 0c06 	add.w	ip, r3, r6
100075b2:	e895 000f 	ldmia.w	r5, {r0, r1, r2, r3}
100075b6:	e889 000f 	stmia.w	r9, {r0, r1, r2, r3}
100075ba:	e894 000f 	ldmia.w	r4, {r0, r1, r2, r3}
100075be:	e888 000f 	stmia.w	r8, {r0, r1, r2, r3}
100075c2:	e89e 000f 	ldmia.w	lr, {r0, r1, r2, r3}
100075c6:	f10d 0ec0 	add.w	lr, sp, #192	@ 0xc0
100075ca:	e88e 000f 	stmia.w	lr, {r0, r1, r2, r3}
100075ce:	e89c 000f 	ldmia.w	ip, {r0, r1, r2, r3}
100075d2:	f10d 0cd0 	add.w	ip, sp, #208	@ 0xd0
100075d6:	e88c 000f 	stmia.w	ip, {r0, r1, r2, r3}
100075da:	ed9d 7b32 	vldr	d7, [sp, #200]	@ 0xc8
100075de:	ed9d 5b28 	vldr	d5, [sp, #160]	@ 0xa0
100075e2:	ed9d 6b30 	vldr	d6, [sp, #192]	@ 0xc0
100075e6:	ed9d fb2a 	vldr	d15, [sp, #168]	@ 0xa8
100075ea:	eeb0 3b47 	vmov.f64	d3, d7
100075ee:	ed8d 7b42 	vstr	d7, [sp, #264]	@ 0x108
100075f2:	ed8d 7b06 	vstr	d7, [sp, #24]
100075f6:	ed9d 7b34 	vldr	d7, [sp, #208]	@ 0xd0
100075fa:	eeb0 0b45 	vmov.f64	d0, d5
100075fe:	eeb0 2b46 	vmov.f64	d2, d6
10007602:	eeb0 1b4f 	vmov.f64	d1, d15
10007606:	ed9d 9b2c 	vldr	d9, [sp, #176]	@ 0xb0
1000760a:	ed9d cb2e 	vldr	d12, [sp, #184]	@ 0xb8
1000760e:	ed9d db36 	vldr	d13, [sp, #216]	@ 0xd8
10007612:	ed8d 5b38 	vstr	d5, [sp, #224]	@ 0xe0
10007616:	ed8d 5b0a 	vstr	d5, [sp, #40]	@ 0x28
1000761a:	ed8d 6b40 	vstr	d6, [sp, #256]	@ 0x100
1000761e:	ed8d 6b08 	vstr	d6, [sp, #32]
10007622:	ed8d 7b00 	vstr	d7, [sp]
10007626:	ed8d fb3a 	vstr	d15, [sp, #232]	@ 0xe8
1000762a:	f7ff f819 	bl	10006660 <fndsa_fp64e_mul>
1000762e:	ed9d 7b00 	vldr	d7, [sp]
10007632:	eeb0 eb40 	vmov.f64	d14, d0
10007636:	eeb0 8b41 	vmov.f64	d8, d1
1000763a:	eeb0 2b47 	vmov.f64	d2, d7
1000763e:	eeb0 3b4d 	vmov.f64	d3, d13
10007642:	ed8d 0b10 	vstr	d0, [sp, #64]	@ 0x40
10007646:	ed8d 1b12 	vstr	d1, [sp, #72]	@ 0x48
1000764a:	eeb0 0b49 	vmov.f64	d0, d9
1000764e:	eeb0 1b4c 	vmov.f64	d1, d12
10007652:	ed8d 9b3c 	vstr	d9, [sp, #240]	@ 0xf0
10007656:	ed8d cb3e 	vstr	d12, [sp, #248]	@ 0xf8
1000765a:	ed8d 7b44 	vstr	d7, [sp, #272]	@ 0x110
1000765e:	ed8d 9b04 	vstr	d9, [sp, #16]
10007662:	ed8d cb02 	vstr	d12, [sp, #8]
10007666:	ed8d db46 	vstr	d13, [sp, #280]	@ 0x118
1000766a:	f7fe fff9 	bl	10006660 <fndsa_fp64e_mul>
1000766e:	ed9d 6b02 	vldr	d6, [sp, #8]
10007672:	eeb0 cb41 	vmov.f64	d12, d1
10007676:	ed9d 7b06 	vldr	d7, [sp, #24]
1000767a:	ee3f 1b06 	vadd.f64	d1, d15, d6
1000767e:	ed9d 5b00 	vldr	d5, [sp]
10007682:	ed9d 6b08 	vldr	d6, [sp, #32]
10007686:	ee37 3b0d 	vadd.f64	d3, d7, d13
1000768a:	ee36 2b05 	vadd.f64	d2, d6, d5
1000768e:	ed9d 7b04 	vldr	d7, [sp, #16]
10007692:	ed9d 5b0a 	vldr	d5, [sp, #40]	@ 0x28
10007696:	eeb0 9b40 	vmov.f64	d9, d0
1000769a:	ee35 0b07 	vadd.f64	d0, d5, d7
1000769e:	ee23 7b0b 	vmul.f64	d7, d3, d11
100076a2:	ee21 6b0b 	vmul.f64	d6, d1, d11
100076a6:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100076aa:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100076ae:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100076b2:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100076b6:	ee32 5b07 	vadd.f64	d5, d2, d7
100076ba:	ee30 0b06 	vadd.f64	d0, d0, d6
100076be:	ee06 1b4a 	vmls.f64	d1, d6, d10
100076c2:	ee25 6b0b 	vmul.f64	d6, d5, d11
100076c6:	ee07 3b4a 	vmls.f64	d3, d7, d10
100076ca:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100076ce:	ee20 7b0b 	vmul.f64	d7, d0, d11
100076d2:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100076d6:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100076da:	ee06 5b4a 	vmls.f64	d5, d6, d10
100076de:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100076e2:	eeb0 6b40 	vmov.f64	d6, d0
100076e6:	ee07 6b4a 	vmls.f64	d6, d7, d10
100076ea:	eeb0 2b45 	vmov.f64	d2, d5
100076ee:	eeb0 0b46 	vmov.f64	d0, d6
100076f2:	ed8d 9b14 	vstr	d9, [sp, #80]	@ 0x50
100076f6:	ed8d 1b1e 	vstr	d1, [sp, #120]	@ 0x78
100076fa:	ed8d 3b1a 	vstr	d3, [sp, #104]	@ 0x68
100076fe:	ed8d 6b1c 	vstr	d6, [sp, #112]	@ 0x70
10007702:	ed8d 5b18 	vstr	d5, [sp, #96]	@ 0x60
10007706:	ed8d cb16 	vstr	d12, [sp, #88]	@ 0x58
1000770a:	f7fe ffa9 	bl	10006660 <fndsa_fp64e_mul>
1000770e:	ee38 6b0c 	vadd.f64	d6, d8, d12
10007712:	ee26 3b0b 	vmul.f64	d3, d6, d11
10007716:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000771a:	ee3e 5b09 	vadd.f64	d5, d14, d9
1000771e:	eeb8 2b43 	vcvt.f64.u32	d2, s6
10007722:	ee38 8b0a 	vadd.f64	d8, d8, d10
10007726:	ee35 5b02 	vadd.f64	d5, d5, d2
1000772a:	ee38 8b4c 	vsub.f64	d8, d8, d12
1000772e:	ee31 1b0a 	vadd.f64	d1, d1, d10
10007732:	ee30 7b0a 	vadd.f64	d7, d0, d10
10007736:	ee02 6b4a 	vmls.f64	d6, d2, d10
1000773a:	ee28 0b0b 	vmul.f64	d0, d8, d11
1000773e:	ee25 2b0b 	vmul.f64	d2, d5, d11
10007742:	ee3e 4b0a 	vadd.f64	d4, d14, d10
10007746:	ee31 6b46 	vsub.f64	d6, d1, d6
1000774a:	ee34 4b49 	vsub.f64	d4, d4, d9
1000774e:	eebc 1bc2 	vcvt.u32.f64	s2, d2
10007752:	eeb7 9b00 	vmov.f64	d9, #112	@ 0x3f800000  1.0
10007756:	eebc 3bc0 	vcvt.u32.f64	s6, d0
1000775a:	ee34 4b49 	vsub.f64	d4, d4, d9
1000775e:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10007762:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10007766:	ee34 4b03 	vadd.f64	d4, d4, d3
1000776a:	ee03 8b4a 	vmls.f64	d8, d3, d10
1000776e:	ee01 5b4a 	vmls.f64	d5, d1, d10
10007772:	ee26 3b0b 	vmul.f64	d3, d6, d11
10007776:	ee37 7b45 	vsub.f64	d7, d7, d5
1000777a:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000777e:	ee37 7b49 	vsub.f64	d7, d7, d9
10007782:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10007786:	ee03 6b4a 	vmls.f64	d6, d3, d10
1000778a:	ee37 7b03 	vadd.f64	d7, d7, d3
1000778e:	ee24 2b0b 	vmul.f64	d2, d4, d11
10007792:	ed8d 6b26 	vstr	d6, [sp, #152]	@ 0x98
10007796:	ee27 6b0b 	vmul.f64	d6, d7, d11
1000779a:	eebc 2bc2 	vcvt.u32.f64	s4, d2
1000779e:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100077a2:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100077a6:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100077aa:	ee02 4b4a 	vmls.f64	d4, d2, d10
100077ae:	ee06 7b4a 	vmls.f64	d7, d6, d10
100077b2:	ed8d 8b22 	vstr	d8, [sp, #136]	@ 0x88
100077b6:	ed8d 4b20 	vstr	d4, [sp, #128]	@ 0x80
100077ba:	ed8d 7b24 	vstr	d7, [sp, #144]	@ 0x90
100077be:	ab20      	add	r3, sp, #128	@ 0x80
100077c0:	cb0f      	ldmia	r3, {r0, r1, r2, r3}
100077c2:	e885 000f 	stmia.w	r5, {r0, r1, r2, r3}
100077c6:	e897 000f 	ldmia.w	r7, {r0, r1, r2, r3}
100077ca:	e884 000f 	stmia.w	r4, {r0, r1, r2, r3}
100077ce:	9b0d      	ldr	r3, [sp, #52]	@ 0x34
100077d0:	3610      	adds	r6, #16
100077d2:	42b3      	cmp	r3, r6
100077d4:	f47f aee4 	bne.w	100075a0 <fndsa_vect_mul_fft_fp64_exact+0x38>
100077d8:	b049      	add	sp, #292	@ 0x124
100077da:	ecbd 8b10 	vpop	{d8-d15}
100077de:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
100077e2:	bf00      	nop
100077e4:	f3af 8000 	nop.w
100077e8:	00000000 	.word	0x00000000
100077ec:	3df00000 	.word	0x3df00000
100077f0:	00000000 	.word	0x00000000
100077f4:	41f00000 	.word	0x41f00000
