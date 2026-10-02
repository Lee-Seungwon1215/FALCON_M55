10001360 <fndsa_fp64e_mul>:
10001360:	ed9f 5b51 	vldr	d5, [pc, #324]	@ 100014a8 <fndsa_fp64e_mul+0x148>
10001364:	ed2d 8b10 	vpush	{d8-d15}
10001368:	ee23 7b05 	vmul.f64	d7, d3, d5
1000136c:	eeb0 9b43 	vmov.f64	d9, d3
10001370:	eefc 3bc0 	vcvt.u32.f64	s7, d0
10001374:	ee13 2a90 	vmov	r2, s7
10001378:	eefc 3bc2 	vcvt.u32.f64	s7, d2
1000137c:	0fd2      	lsrs	r2, r2, #31
1000137e:	ee13 3a90 	vmov	r3, s7
10001382:	ee03 2a90 	vmov	s7, r2
10001386:	0fdb      	lsrs	r3, r3, #31
10001388:	ee22 6b05 	vmul.f64	d6, d2, d5
1000138c:	eeb8 ebe3 	vcvt.f64.s32	d14, s7
10001390:	ee03 3a90 	vmov	s7, r3
10001394:	eeb0 8b41 	vmov.f64	d8, d1
10001398:	eeb8 fbe3 	vcvt.f64.s32	d15, s7
1000139c:	ee27 3b01 	vmul.f64	d3, d7, d1
100013a0:	ee26 1b01 	vmul.f64	d1, d6, d1
100013a4:	ee20 6b06 	vmul.f64	d6, d0, d6
100013a8:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100013ac:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100013b0:	ed9f 4b3f 	vldr	d4, [pc, #252]	@ 100014b0 <fndsa_fp64e_mul+0x150>
100013b4:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100013b8:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100013bc:	ee26 6b44 	vnmul.f64	d6, d6, d4
100013c0:	eea0 6b02 	vfma.f64	d6, d0, d2
100013c4:	ee36 bb04 	vadd.f64	d11, d6, d4
100013c8:	ee23 6b44 	vnmul.f64	d6, d3, d4
100013cc:	eea8 6b09 	vfma.f64	d6, d8, d9
100013d0:	ee36 6b04 	vadd.f64	d6, d6, d4
100013d4:	ee20 7b07 	vmul.f64	d7, d0, d7
100013d8:	ee26 6b05 	vmul.f64	d6, d6, d5
100013dc:	eebc 1bc1 	vcvt.u32.f64	s2, d1
100013e0:	eebc cbc6 	vcvt.u32.f64	s24, d6
100013e4:	eeb8 1b41 	vcvt.f64.u32	d1, s2
100013e8:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100013ec:	ee21 6b44 	vnmul.f64	d6, d1, d4
100013f0:	eea8 6b02 	vfma.f64	d6, d8, d2
100013f4:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100013f8:	ee36 2b04 	vadd.f64	d2, d6, d4
100013fc:	eeb8 6b4c 	vcvt.f64.u32	d6, s24
10001400:	eeb7 ab00 	vmov.f64	d10, #112	@ 0x3f800000  1.0
10001404:	ee36 6b03 	vadd.f64	d6, d6, d3
10001408:	ee27 3b44 	vnmul.f64	d3, d7, d4
1000140c:	eea0 3b09 	vfma.f64	d3, d0, d9
10001410:	ee33 3b04 	vadd.f64	d3, d3, d4
10001414:	ee36 cb4a 	vsub.f64	d12, d6, d10
10001418:	ee23 0b05 	vmul.f64	d0, d3, d5
1000141c:	ee22 6b05 	vmul.f64	d6, d2, d5
10001420:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10001424:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10001428:	eeb8 0b40 	vcvt.f64.u32	d0, s0
1000142c:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10001430:	ee37 7b00 	vadd.f64	d7, d7, d0
10001434:	ee06 2b44 	vmls.f64	d2, d6, d4
10001438:	ee31 6b06 	vadd.f64	d6, d1, d6
1000143c:	ee37 7b4a 	vsub.f64	d7, d7, d10
10001440:	ee36 6b4a 	vsub.f64	d6, d6, d10
10001444:	ee00 3b44 	vmls.f64	d3, d0, d4
10001448:	ee36 7b07 	vadd.f64	d7, d6, d7
1000144c:	ee3c 1b02 	vadd.f64	d1, d12, d2
10001450:	ee2b 6b05 	vmul.f64	d6, d11, d5
10001454:	ee31 1b03 	vadd.f64	d1, d1, d3
10001458:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000145c:	ee21 3b05 	vmul.f64	d3, d1, d5
10001460:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10001464:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10001468:	ee06 bb44 	vmls.f64	d11, d6, d4
1000146c:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10001470:	ee3b 0b07 	vadd.f64	d0, d11, d7
10001474:	ed9f db10 	vldr	d13, [pc, #64]	@ 100014b8 <fndsa_fp64e_mul+0x158>
10001478:	ee30 0b03 	vadd.f64	d0, d0, d3
1000147c:	ee30 0b0d 	vadd.f64	d0, d0, d13
10001480:	ee0e 0b49 	vmls.f64	d0, d14, d9
10001484:	ee0f 0b48 	vmls.f64	d0, d15, d8
10001488:	ee20 5b05 	vmul.f64	d5, d0, d5
1000148c:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10001490:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10001494:	ee03 1b44 	vmls.f64	d1, d3, d4
10001498:	ee05 0b44 	vmls.f64	d0, d5, d4
1000149c:	b090      	sub	sp, #64	@ 0x40
1000149e:	b010      	add	sp, #64	@ 0x40
100014a0:	ecbd 8b10 	vpop	{d8-d15}
100014a4:	4770      	bx	lr
100014a6:	bf00      	nop
100014a8:	00000000 	.word	0x00000000
100014ac:	3df00000 	.word	0x3df00000
100014b0:	00000000 	.word	0x00000000
100014b4:	41f00000 	.word	0x41f00000
100014b8:	00000000 	.word	0x00000000
100014bc:	42000000 	.word	0x42000000

