
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/r2-kernels/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10000368 <fp64e_mul24_prepared>:
10000368:	ed9f 6b51 	vldr	d6, [pc, #324]	@ 100004b0 <fp64e_mul24_prepared+0x148>
1000036c:	eeb0 2b40 	vmov.f64	d2, d0
10000370:	ed9f 7b51 	vldr	d7, [pc, #324]	@ 100004b8 <fp64e_mul24_prepared+0x150>
10000374:	ee22 4b07 	vmul.f64	d4, d2, d7
10000378:	ee21 7b06 	vmul.f64	d7, d1, d6
1000037c:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10000380:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10000384:	eefc 7bc2 	vcvt.u32.f64	s15, d2
10000388:	ed2d 8b10 	vpush	{d8-d15}
1000038c:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10000390:	ed9f 8b4b 	vldr	d8, [pc, #300]	@ 100004c0 <fp64e_mul24_prepared+0x158>
10000394:	ee17 3a90 	vmov	r3, s15
10000398:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000039c:	eeb0 0b41 	vmov.f64	d0, d1
100003a0:	ee04 2b48 	vmls.f64	d2, d4, d8
100003a4:	ed9f 9b48 	vldr	d9, [pc, #288]	@ 100004c8 <fp64e_mul24_prepared+0x160>
100003a8:	eeb0 1b47 	vmov.f64	d1, d7
100003ac:	0fdb      	lsrs	r3, r3, #31
100003ae:	ed9f 3b48 	vldr	d3, [pc, #288]	@ 100004d0 <fp64e_mul24_prepared+0x168>
100003b2:	ee02 1b09 	vmla.f64	d1, d2, d9
100003b6:	ee05 3a90 	vmov	s11, r3
100003ba:	eeb0 2b40 	vmov.f64	d2, d0
100003be:	eeb8 ebe5 	vcvt.f64.s32	d14, s11
100003c2:	ee07 2b43 	vmls.f64	d2, d7, d3
100003c6:	ed90 fb02 	vldr	d15, [r0, #8]
100003ca:	ed90 db04 	vldr	d13, [r0, #16]
100003ce:	ed90 5b00 	vldr	d5, [r0]
100003d2:	ee22 7b05 	vmul.f64	d7, d2, d5
100003d6:	ee22 ab0f 	vmul.f64	d10, d2, d15
100003da:	ee22 bb0d 	vmul.f64	d11, d2, d13
100003de:	ee21 cb0d 	vmul.f64	d12, d1, d13
100003e2:	ee01 ab05 	vmla.f64	d10, d1, d5
100003e6:	ee01 bb0f 	vmla.f64	d11, d1, d15
100003ea:	ee04 cb0f 	vmla.f64	d12, d4, d15
100003ee:	ee04 bb05 	vmla.f64	d11, d4, d5
100003f2:	ee27 7b06 	vmul.f64	d7, d7, d6
100003f6:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100003fa:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100003fe:	ee37 7b0a 	vadd.f64	d7, d7, d10
10000402:	ee27 2b06 	vmul.f64	d2, d7, d6
10000406:	eebc 2bc2 	vcvt.u32.f64	s4, d2
1000040a:	eeb8 2b42 	vcvt.f64.u32	d2, s4
1000040e:	ed9f 4b32 	vldr	d4, [pc, #200]	@ 100004d8 <fp64e_mul24_prepared+0x170>
10000412:	ee3b ab02 	vadd.f64	d10, d11, d2
10000416:	ee02 7b43 	vmls.f64	d7, d2, d3
1000041a:	ee27 7b04 	vmul.f64	d7, d7, d4
1000041e:	ee2a 4b06 	vmul.f64	d4, d10, d6
10000422:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10000426:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000042a:	eeb8 1b47 	vcvt.f64.u32	d1, s14
1000042e:	eeb8 7b44 	vcvt.f64.u32	d7, s8
10000432:	ed90 5b08 	vldr	d5, [r0, #32]
10000436:	ee3c 4b07 	vadd.f64	d4, d12, d7
1000043a:	ee07 ab43 	vmls.f64	d10, d7, d3
1000043e:	ed9f 7b1e 	vldr	d7, [pc, #120]	@ 100004b8 <fp64e_mul24_prepared+0x150>
10000442:	b08e      	sub	sp, #56	@ 0x38
10000444:	ed8d 5b00 	vstr	d5, [sp]
10000448:	ee24 6b06 	vmul.f64	d6, d4, d6
1000044c:	ee2a 5b07 	vmul.f64	d5, d10, d7
10000450:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10000454:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10000458:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000045c:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10000460:	ee06 4b43 	vmls.f64	d4, d6, d3
10000464:	eeb0 7b45 	vmov.f64	d7, d5
10000468:	ed9f db1d 	vldr	d13, [pc, #116]	@ 100004e0 <fp64e_mul24_prepared+0x178>
1000046c:	ee04 7b09 	vmla.f64	d7, d4, d9
10000470:	ed90 fb06 	vldr	d15, [r0, #24]
10000474:	ee37 7b0d 	vadd.f64	d7, d7, d13
10000478:	ee05 ab48 	vmls.f64	d10, d5, d8
1000047c:	ee0e 7b4f 	vmls.f64	d7, d14, d15
10000480:	ed9d 5b00 	vldr	d5, [sp]
10000484:	ed9f 6b18 	vldr	d6, [pc, #96]	@ 100004e8 <fp64e_mul24_prepared+0x180>
10000488:	ee00 7b45 	vmls.f64	d7, d0, d5
1000048c:	ee27 6b06 	vmul.f64	d6, d7, d6
10000490:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10000494:	ed9f 5b16 	vldr	d5, [pc, #88]	@ 100004f0 <fp64e_mul24_prepared+0x188>
10000498:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000049c:	ee06 7b45 	vmls.f64	d7, d6, d5
100004a0:	ee0a 1b08 	vmla.f64	d1, d10, d8
100004a4:	eeb0 0b47 	vmov.f64	d0, d7
100004a8:	b00e      	add	sp, #56	@ 0x38
100004aa:	ecbd 8b10 	vpop	{d8-d15}
100004ae:	4770      	bx	lr
100004b0:	00000000 	.word	0x00000000
100004b4:	3e700000 	.word	0x3e700000
100004b8:	00000000 	.word	0x00000000
100004bc:	3ef00000 	.word	0x3ef00000
100004c0:	00000000 	.word	0x00000000
100004c4:	40f00000 	.word	0x40f00000
100004c8:	00000000 	.word	0x00000000
100004cc:	40700000 	.word	0x40700000
100004d0:	00000000 	.word	0x00000000
100004d4:	41700000 	.word	0x41700000
100004d8:	00000000 	.word	0x00000000
100004dc:	3f700000 	.word	0x3f700000
100004e0:	00000000 	.word	0x00000000
100004e4:	42000000 	.word	0x42000000
100004e8:	00000000 	.word	0x00000000
100004ec:	3df00000 	.word	0x3df00000
100004f0:	00000000 	.word	0x00000000
100004f4:	41f00000 	.word	0x41f00000
