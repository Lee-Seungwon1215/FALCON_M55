100034f0 <fndsa_fp64e_mul>:
100034f0:	ed9f 5b51 	vldr	d5, [pc, #324]	@ 10003638 <fndsa_fp64e_mul+0x148>
100034f4:	ed2d 8b10 	vpush	{d8-d15}
100034f8:	ee23 7b05 	vmul.f64	d7, d3, d5
100034fc:	eeb0 9b43 	vmov.f64	d9, d3
10003500:	eefc 3bc0 	vcvt.u32.f64	s7, d0
10003504:	ee13 2a90 	vmov	r2, s7
10003508:	eefc 3bc2 	vcvt.u32.f64	s7, d2
1000350c:	0fd2      	lsrs	r2, r2, #31
1000350e:	ee13 3a90 	vmov	r3, s7
10003512:	ee03 2a90 	vmov	s7, r2
10003516:	0fdb      	lsrs	r3, r3, #31
10003518:	ee22 6b05 	vmul.f64	d6, d2, d5
1000351c:	eeb8 ebe3 	vcvt.f64.s32	d14, s7
10003520:	ee03 3a90 	vmov	s7, r3
10003524:	eeb0 8b41 	vmov.f64	d8, d1
10003528:	eeb8 fbe3 	vcvt.f64.s32	d15, s7
1000352c:	ee27 3b01 	vmul.f64	d3, d7, d1
10003530:	ee26 1b01 	vmul.f64	d1, d6, d1
10003534:	ee20 6b06 	vmul.f64	d6, d0, d6
10003538:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000353c:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10003540:	ed9f 4b3f 	vldr	d4, [pc, #252]	@ 10003640 <fndsa_fp64e_mul+0x150>
10003544:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10003548:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000354c:	ee26 6b44 	vnmul.f64	d6, d6, d4
10003550:	eea0 6b02 	vfma.f64	d6, d0, d2
10003554:	ee36 bb04 	vadd.f64	d11, d6, d4
10003558:	ee23 6b44 	vnmul.f64	d6, d3, d4
1000355c:	eea8 6b09 	vfma.f64	d6, d8, d9
10003560:	ee36 6b04 	vadd.f64	d6, d6, d4
10003564:	ee20 7b07 	vmul.f64	d7, d0, d7
10003568:	ee26 6b05 	vmul.f64	d6, d6, d5
1000356c:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10003570:	eebc cbc6 	vcvt.u32.f64	s24, d6
10003574:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10003578:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000357c:	ee21 6b44 	vnmul.f64	d6, d1, d4
10003580:	eea8 6b02 	vfma.f64	d6, d8, d2
10003584:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10003588:	ee36 2b04 	vadd.f64	d2, d6, d4
1000358c:	eeb8 6b4c 	vcvt.f64.u32	d6, s24
10003590:	eeb7 ab00 	vmov.f64	d10, #112	@ 0x3f800000  1.0
10003594:	ee36 6b03 	vadd.f64	d6, d6, d3
10003598:	ee27 3b44 	vnmul.f64	d3, d7, d4
1000359c:	eea0 3b09 	vfma.f64	d3, d0, d9
100035a0:	ee33 3b04 	vadd.f64	d3, d3, d4
100035a4:	ee36 cb4a 	vsub.f64	d12, d6, d10
100035a8:	ee23 0b05 	vmul.f64	d0, d3, d5
100035ac:	ee22 6b05 	vmul.f64	d6, d2, d5
100035b0:	eebc 0bc0 	vcvt.u32.f64	s0, d0
100035b4:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100035b8:	eeb8 0b40 	vcvt.f64.u32	d0, s0
100035bc:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100035c0:	ee37 7b00 	vadd.f64	d7, d7, d0
100035c4:	ee06 2b44 	vmls.f64	d2, d6, d4
100035c8:	ee31 6b06 	vadd.f64	d6, d1, d6
100035cc:	ee37 7b4a 	vsub.f64	d7, d7, d10
100035d0:	ee36 6b4a 	vsub.f64	d6, d6, d10
100035d4:	ee00 3b44 	vmls.f64	d3, d0, d4
100035d8:	ee36 7b07 	vadd.f64	d7, d6, d7
100035dc:	ee3c 1b02 	vadd.f64	d1, d12, d2
100035e0:	ee2b 6b05 	vmul.f64	d6, d11, d5
100035e4:	ee31 1b03 	vadd.f64	d1, d1, d3
100035e8:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100035ec:	ee21 3b05 	vmul.f64	d3, d1, d5
100035f0:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100035f4:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100035f8:	ee06 bb44 	vmls.f64	d11, d6, d4
100035fc:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10003600:	ee3b 0b07 	vadd.f64	d0, d11, d7
10003604:	ed9f db10 	vldr	d13, [pc, #64]	@ 10003648 <fndsa_fp64e_mul+0x158>
10003608:	ee30 0b03 	vadd.f64	d0, d0, d3
1000360c:	ee30 0b0d 	vadd.f64	d0, d0, d13
10003610:	ee0e 0b49 	vmls.f64	d0, d14, d9
10003614:	ee0f 0b48 	vmls.f64	d0, d15, d8
10003618:	ee20 5b05 	vmul.f64	d5, d0, d5
1000361c:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10003620:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10003624:	ee03 1b44 	vmls.f64	d1, d3, d4
10003628:	ee05 0b44 	vmls.f64	d0, d5, d4
1000362c:	b090      	sub	sp, #64	@ 0x40
1000362e:	b010      	add	sp, #64	@ 0x40
10003630:	ecbd 8b10 	vpop	{d8-d15}
10003634:	4770      	bx	lr
10003636:	bf00      	nop
10003638:	00000000 	.word	0x00000000
1000363c:	3df00000 	.word	0x3df00000
10003640:	00000000 	.word	0x00000000
10003644:	41f00000 	.word	0x41f00000
10003648:	00000000 	.word	0x00000000
1000364c:	42000000 	.word	0x42000000

