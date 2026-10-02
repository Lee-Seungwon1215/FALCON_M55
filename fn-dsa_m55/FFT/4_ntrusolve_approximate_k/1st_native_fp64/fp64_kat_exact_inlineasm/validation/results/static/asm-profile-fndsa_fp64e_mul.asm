
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_kat_exact_inlineasm/validation/build/asm-profile/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

1000a360 <fndsa_fp64e_mul>:
1000a360:	ed2d 8b0e 	vpush	{d8-d14}
1000a364:	4b64      	ldr	r3, [pc, #400]	@ (1000a4f8 <fndsa_fp64e_mul+0x198>)
1000a366:	b090      	sub	sp, #64	@ 0x40
1000a368:	ed8d 0b08 	vstr	d0, [sp, #32]
1000a36c:	ed8d 1b0a 	vstr	d1, [sp, #40]	@ 0x28
1000a370:	ed8d 2b04 	vstr	d2, [sp, #16]
1000a374:	ed8d 3b06 	vstr	d3, [sp, #24]
1000a378:	eebc 4bc0 	vcvt.u32.f64	s8, d0
1000a37c:	ee14 2a10 	vmov	r2, s8
1000a380:	0fd2      	lsrs	r2, r2, #31
1000a382:	ee04 2a10 	vmov	s8, r2
1000a386:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000a38a:	ee24 eb03 	vmul.f64	d14, d4, d3
1000a38e:	eebc 4bc2 	vcvt.u32.f64	s8, d2
1000a392:	ee14 2a10 	vmov	r2, s8
1000a396:	0fd2      	lsrs	r2, r2, #31
1000a398:	ee04 2a10 	vmov	s8, r2
1000a39c:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000a3a0:	ee04 eb01 	vmla.f64	d14, d4, d1
1000a3a4:	eeb0 8b40 	vmov.f64	d8, d0
1000a3a8:	eeb0 9b41 	vmov.f64	d9, d1
1000a3ac:	eeb0 ab42 	vmov.f64	d10, d2
1000a3b0:	eeb0 bb43 	vmov.f64	d11, d3
1000a3b4:	ed93 cb00 	vldr	d12, [r3]
1000a3b8:	ed93 db02 	vldr	d13, [r3, #8]
1000a3bc:	ee29 1b0d 	vmul.f64	d1, d9, d13
1000a3c0:	ee28 3b0d 	vmul.f64	d3, d8, d13
1000a3c4:	ee2b 5b0d 	vmul.f64	d5, d11, d13
1000a3c8:	ee2a 7b0d 	vmul.f64	d7, d10, d13
1000a3cc:	eebc 1bc1 	vcvt.u32.f64	s2, d1
1000a3d0:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000a3d4:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000a3d8:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000a3dc:	eeb8 1b41 	vcvt.f64.u32	d1, s2
1000a3e0:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000a3e4:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000a3e8:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000a3ec:	eeb0 0b49 	vmov.f64	d0, d9
1000a3f0:	eeb0 2b48 	vmov.f64	d2, d8
1000a3f4:	eeb0 4b4b 	vmov.f64	d4, d11
1000a3f8:	eeb0 6b4a 	vmov.f64	d6, d10
1000a3fc:	ee01 0b4c 	vmls.f64	d0, d1, d12
1000a400:	ee03 2b4c 	vmls.f64	d2, d3, d12
1000a404:	ee05 4b4c 	vmls.f64	d4, d5, d12
1000a408:	ee07 6b4c 	vmls.f64	d6, d7, d12
1000a40c:	ee20 8b04 	vmul.f64	d8, d0, d4
1000a410:	ee28 9b0d 	vmul.f64	d9, d8, d13
1000a414:	eebc 9bc9 	vcvt.u32.f64	s18, d9
1000a418:	eeb8 9b49 	vcvt.f64.u32	d9, s18
1000a41c:	eeb0 8b49 	vmov.f64	d8, d9
1000a420:	ee00 8b05 	vmla.f64	d8, d0, d5
1000a424:	ee01 8b04 	vmla.f64	d8, d1, d4
1000a428:	ee28 9b0d 	vmul.f64	d9, d8, d13
1000a42c:	eebc 9bc9 	vcvt.u32.f64	s18, d9
1000a430:	eeb8 9b49 	vcvt.f64.u32	d9, s18
1000a434:	eeb0 8b49 	vmov.f64	d8, d9
1000a438:	ee00 8b06 	vmla.f64	d8, d0, d6
1000a43c:	ee01 8b05 	vmla.f64	d8, d1, d5
1000a440:	ee02 8b04 	vmla.f64	d8, d2, d4
1000a444:	ee28 9b0d 	vmul.f64	d9, d8, d13
1000a448:	eebc 9bc9 	vcvt.u32.f64	s18, d9
1000a44c:	eeb8 9b49 	vcvt.f64.u32	d9, s18
1000a450:	ee09 8b4c 	vmls.f64	d8, d9, d12
1000a454:	eeb0 ab48 	vmov.f64	d10, d8
1000a458:	eeb0 8b49 	vmov.f64	d8, d9
1000a45c:	ee00 8b07 	vmla.f64	d8, d0, d7
1000a460:	ee01 8b06 	vmla.f64	d8, d1, d6
1000a464:	ee02 8b05 	vmla.f64	d8, d2, d5
1000a468:	ee03 8b04 	vmla.f64	d8, d3, d4
1000a46c:	ee28 9b0d 	vmul.f64	d9, d8, d13
1000a470:	eebc 9bc9 	vcvt.u32.f64	s18, d9
1000a474:	eeb8 9b49 	vcvt.f64.u32	d9, s18
1000a478:	ee09 8b4c 	vmls.f64	d8, d9, d12
1000a47c:	ee08 ab0c 	vmla.f64	d10, d8, d12
1000a480:	eeb0 8b49 	vmov.f64	d8, d9
1000a484:	ee01 8b07 	vmla.f64	d8, d1, d7
1000a488:	ee02 8b06 	vmla.f64	d8, d2, d6
1000a48c:	ee03 8b05 	vmla.f64	d8, d3, d5
1000a490:	ee28 9b0d 	vmul.f64	d9, d8, d13
1000a494:	eebc 9bc9 	vcvt.u32.f64	s18, d9
1000a498:	eeb8 9b49 	vcvt.f64.u32	d9, s18
1000a49c:	ee09 8b4c 	vmls.f64	d8, d9, d12
1000a4a0:	eeb0 bb48 	vmov.f64	d11, d8
1000a4a4:	eeb0 8b49 	vmov.f64	d8, d9
1000a4a8:	ee02 8b07 	vmla.f64	d8, d2, d7
1000a4ac:	ee03 8b06 	vmla.f64	d8, d3, d6
1000a4b0:	ee28 9b0d 	vmul.f64	d9, d8, d13
1000a4b4:	eebc 9bc9 	vcvt.u32.f64	s18, d9
1000a4b8:	eeb8 9b49 	vcvt.f64.u32	d9, s18
1000a4bc:	ee09 8b4c 	vmls.f64	d8, d9, d12
1000a4c0:	ee08 bb0c 	vmla.f64	d11, d8, d12
1000a4c4:	ed93 cb04 	vldr	d12, [r3, #16]
1000a4c8:	ee3b bb0c 	vadd.f64	d11, d11, d12
1000a4cc:	ee3b bb4e 	vsub.f64	d11, d11, d14
1000a4d0:	ed93 cb06 	vldr	d12, [r3, #24]
1000a4d4:	ed93 db08 	vldr	d13, [r3, #32]
1000a4d8:	ee2b 9b0d 	vmul.f64	d9, d11, d13
1000a4dc:	eebc 9bc9 	vcvt.u32.f64	s18, d9
1000a4e0:	eeb8 9b49 	vcvt.f64.u32	d9, s18
1000a4e4:	ee09 bb4c 	vmls.f64	d11, d9, d12
1000a4e8:	eeb0 0b4b 	vmov.f64	d0, d11
1000a4ec:	eeb0 1b4a 	vmov.f64	d1, d10
1000a4f0:	b010      	add	sp, #64	@ 0x40
1000a4f2:	ecbd 8b0e 	vpop	{d8-d14}
1000a4f6:	4770      	bx	lr
1000a4f8:	300096c8 	.word	0x300096c8
