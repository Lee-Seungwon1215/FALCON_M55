10000368 <fp64e_cmul>:
10000368:	ed2d 8b10 	vpush	{d8-d15}
1000036c:	eeb0 8b41 	vmov.f64	d8, d1
10000370:	eeb0 1b44 	vmov.f64	d1, d4
10000374:	eefc 4bc0 	vcvt.u32.f64	s9, d0
10000378:	ee14 0a90 	vmov	r0, s9
1000037c:	eefc 4bc2 	vcvt.u32.f64	s9, d2
10000380:	ee14 1a90 	vmov	r1, s9
10000384:	eefc 4bc1 	vcvt.u32.f64	s9, d1
10000388:	ee14 2a90 	vmov	r2, s9
1000038c:	eefc 4bc6 	vcvt.u32.f64	s9, d6
10000390:	0fc0      	lsrs	r0, r0, #31
10000392:	ee14 3a90 	vmov	r3, s9
10000396:	ee04 0a90 	vmov	s9, r0
1000039a:	0fc9      	lsrs	r1, r1, #31
1000039c:	eeb8 bbe4 	vcvt.f64.s32	d11, s9
100003a0:	ee04 1a90 	vmov	s9, r1
100003a4:	0fd2      	lsrs	r2, r2, #31
100003a6:	eeb8 9be4 	vcvt.f64.s32	d9, s9
100003aa:	ee04 2a90 	vmov	s9, r2
100003ae:	b0c2      	sub	sp, #264	@ 0x108
100003b0:	ed8d 3b02 	vstr	d3, [sp, #8]
100003b4:	ed8d bb14 	vstr	d11, [sp, #80]	@ 0x50
100003b8:	ed8d 9b1a 	vstr	d9, [sp, #104]	@ 0x68
100003bc:	eeb8 cbe4 	vcvt.f64.s32	d12, s9
100003c0:	ee38 9b03 	vadd.f64	d9, d8, d3
100003c4:	ed9f bbfc 	vldr	d11, [pc, #1008]	@ 100007b8 <fp64e_cmul+0x450>
100003c8:	ed9f 3bfd 	vldr	d3, [pc, #1012]	@ 100007c0 <fp64e_cmul+0x458>
100003cc:	0fdb      	lsrs	r3, r3, #31
100003ce:	ed8d cb16 	vstr	d12, [sp, #88]	@ 0x58
100003d2:	ee04 3a90 	vmov	s9, r3
100003d6:	ee20 cb03 	vmul.f64	d12, d0, d3
100003da:	ee29 3b0b 	vmul.f64	d3, d9, d11
100003de:	eeb0 ab45 	vmov.f64	d10, d5
100003e2:	eeb8 dbe4 	vcvt.f64.s32	d13, s9
100003e6:	eebc cbcc 	vcvt.u32.f64	s24, d12
100003ea:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100003ee:	ed9f fbf6 	vldr	d15, [pc, #984]	@ 100007c8 <fp64e_cmul+0x460>
100003f2:	ed8d 8b00 	vstr	d8, [sp]
100003f6:	ed8d 7b04 	vstr	d7, [sp, #16]
100003fa:	ee3a 8b07 	vadd.f64	d8, d10, d7
100003fe:	ed8d db1c 	vstr	d13, [sp, #112]	@ 0x70
10000402:	ee30 7b02 	vadd.f64	d7, d0, d2
10000406:	ed9f dbf2 	vldr	d13, [pc, #968]	@ 100007d0 <fp64e_cmul+0x468>
1000040a:	eeb8 cb4c 	vcvt.f64.u32	d12, s24
1000040e:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10000412:	ee0c 0b4d 	vmls.f64	d0, d12, d13
10000416:	ee03 9b4f 	vmls.f64	d9, d3, d15
1000041a:	ee37 7b03 	vadd.f64	d7, d7, d3
1000041e:	ed9f 3be8 	vldr	d3, [pc, #928]	@ 100007c0 <fp64e_cmul+0x458>
10000422:	ed8d 0b0c 	vstr	d0, [sp, #48]	@ 0x30
10000426:	ee28 0b0b 	vmul.f64	d0, d8, d11
1000042a:	eeb0 bb43 	vmov.f64	d11, d3
1000042e:	ee21 3b03 	vmul.f64	d3, d1, d3
10000432:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10000436:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000043a:	eeb0 4b4a 	vmov.f64	d4, d10
1000043e:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10000442:	ee31 ab06 	vadd.f64	d10, d1, d6
10000446:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000044a:	ed8d 9b08 	vstr	d9, [sp, #32]
1000044e:	ee03 1b4d 	vmls.f64	d1, d3, d13
10000452:	ee3a 9b00 	vadd.f64	d9, d10, d0
10000456:	ed8d 9b0e 	vstr	d9, [sp, #56]	@ 0x38
1000045a:	eeb0 9b41 	vmov.f64	d9, d1
1000045e:	ee22 1b0b 	vmul.f64	d1, d2, d11
10000462:	ee00 8b4f 	vmls.f64	d8, d0, d15
10000466:	eefc 0bc1 	vcvt.u32.f64	s1, d1
1000046a:	ed8d 8b06 	vstr	d8, [sp, #24]
1000046e:	eeb0 8b4d 	vmov.f64	d8, d13
10000472:	eeb8 db60 	vcvt.f64.u32	d13, s1
10000476:	ee0d 2b48 	vmls.f64	d2, d13, d8
1000047a:	ed9f 5bd7 	vldr	d5, [pc, #860]	@ 100007d8 <fp64e_cmul+0x470>
1000047e:	ed8d 2b18 	vstr	d2, [sp, #96]	@ 0x60
10000482:	ed9d 2b00 	vldr	d2, [sp]
10000486:	ee26 1b0b 	vmul.f64	d1, d6, d11
1000048a:	ee22 0b05 	vmul.f64	d0, d2, d5
1000048e:	eefc 1bc1 	vcvt.u32.f64	s3, d1
10000492:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10000496:	eeb8 1b61 	vcvt.f64.u32	d1, s3
1000049a:	eeb8 0b40 	vcvt.f64.u32	d0, s0
1000049e:	eeb0 bb46 	vmov.f64	d11, d6
100004a2:	ee24 6b05 	vmul.f64	d6, d4, d5
100004a6:	ed8d 1b0a 	vstr	d1, [sp, #40]	@ 0x28
100004aa:	ee01 bb48 	vmls.f64	d11, d1, d8
100004ae:	eeb0 ab40 	vmov.f64	d10, d0
100004b2:	ed9d 1b0c 	vldr	d1, [sp, #48]	@ 0x30
100004b6:	ed9f 8bd2 	vldr	d8, [pc, #840]	@ 10000800 <fp64e_cmul+0x498>
100004ba:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100004be:	ee01 ab08 	vmla.f64	d10, d1, d8
100004c2:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100004c6:	eeb0 1b4a 	vmov.f64	d1, d10
100004ca:	eeb0 ab46 	vmov.f64	d10, d6
100004ce:	ed9f ebc4 	vldr	d14, [pc, #784]	@ 100007e0 <fp64e_cmul+0x478>
100004d2:	ee09 ab08 	vmla.f64	d10, d9, d8
100004d6:	eeb0 9b44 	vmov.f64	d9, d4
100004da:	ee06 9b4e 	vmls.f64	d9, d6, d14
100004de:	ee00 2b4e 	vmls.f64	d2, d0, d14
100004e2:	ed8d 4b0c 	vstr	d4, [sp, #48]	@ 0x30
100004e6:	eeb0 8b4a 	vmov.f64	d8, d10
100004ea:	eeb0 0b49 	vmov.f64	d0, d9
100004ee:	ee22 6b00 	vmul.f64	d6, d2, d0
100004f2:	ee22 9b08 	vmul.f64	d9, d2, d8
100004f6:	ee22 ab03 	vmul.f64	d10, d2, d3
100004fa:	ee21 4b03 	vmul.f64	d4, d1, d3
100004fe:	eea1 9b00 	vfma.f64	d9, d1, d0
10000502:	eea1 ab08 	vfma.f64	d10, d1, d8
10000506:	eeac 4b08 	vfma.f64	d4, d12, d8
1000050a:	eeac ab00 	vfma.f64	d10, d12, d0
1000050e:	ed9d 3b02 	vldr	d3, [sp, #8]
10000512:	ee26 6b05 	vmul.f64	d6, d6, d5
10000516:	ee23 2b05 	vmul.f64	d2, d3, d5
1000051a:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000051e:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10000522:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10000526:	eeb8 2b42 	vcvt.f64.u32	d2, s4
1000052a:	ed9d 0b04 	vldr	d0, [sp, #16]
1000052e:	ee36 cb09 	vadd.f64	d12, d6, d9
10000532:	ed8d ab10 	vstr	d10, [sp, #64]	@ 0x40
10000536:	ed9d 6b18 	vldr	d6, [sp, #96]	@ 0x60
1000053a:	ed9f 1bb1 	vldr	d1, [pc, #708]	@ 10000800 <fp64e_cmul+0x498>
1000053e:	eeb0 ab42 	vmov.f64	d10, d2
10000542:	ee06 ab01 	vmla.f64	d10, d6, d1
10000546:	ee20 6b05 	vmul.f64	d6, d0, d5
1000054a:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000054e:	eeb0 8b4a 	vmov.f64	d8, d10
10000552:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10000556:	ed9f ab98 	vldr	d10, [pc, #608]	@ 100007b8 <fp64e_cmul+0x450>
1000055a:	ee27 9b0a 	vmul.f64	d9, d7, d10
1000055e:	eeb0 ab46 	vmov.f64	d10, d6
10000562:	ee02 3b4e 	vmls.f64	d3, d2, d14
10000566:	ee0b ab01 	vmla.f64	d10, d11, d1
1000056a:	eeb0 2b40 	vmov.f64	d2, d0
1000056e:	ed9d bb0a 	vldr	d11, [sp, #40]	@ 0x28
10000572:	ed8d 4b12 	vstr	d4, [sp, #72]	@ 0x48
10000576:	ee06 2b4e 	vmls.f64	d2, d6, d14
1000057a:	eeb0 1b4a 	vmov.f64	d1, d10
1000057e:	ee23 6b02 	vmul.f64	d6, d3, d2
10000582:	ee23 0b01 	vmul.f64	d0, d3, d1
10000586:	ee23 4b0b 	vmul.f64	d4, d3, d11
1000058a:	ee28 ab0b 	vmul.f64	d10, d8, d11
1000058e:	eea8 0b02 	vfma.f64	d0, d8, d2
10000592:	eea8 4b01 	vfma.f64	d4, d8, d1
10000596:	eead ab01 	vfma.f64	d10, d13, d1
1000059a:	eead 4b02 	vfma.f64	d4, d13, d2
1000059e:	eebc 9bc9 	vcvt.u32.f64	s18, d9
100005a2:	ee26 6b05 	vmul.f64	d6, d6, d5
100005a6:	eeb8 9b49 	vcvt.f64.u32	d9, s18
100005aa:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100005ae:	ee09 7b4f 	vmls.f64	d7, d9, d15
100005b2:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100005b6:	ee36 3b00 	vadd.f64	d3, d6, d0
100005ba:	eefc 6bc7 	vcvt.u32.f64	s13, d7
100005be:	ee16 3a90 	vmov	r3, s13
100005c2:	0fdb      	lsrs	r3, r3, #31
100005c4:	ee06 3a90 	vmov	s13, r3
100005c8:	ed8d ab18 	vstr	d10, [sp, #96]	@ 0x60
100005cc:	eeb8 1be6 	vcvt.f64.s32	d1, s13
100005d0:	ed9f ab79 	vldr	d10, [pc, #484]	@ 100007b8 <fp64e_cmul+0x450>
100005d4:	ed9d 6b0e 	vldr	d6, [sp, #56]	@ 0x38
100005d8:	ed8d 3b0a 	vstr	d3, [sp, #40]	@ 0x28
100005dc:	ee26 3b0a 	vmul.f64	d3, d6, d10
100005e0:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100005e4:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100005e8:	ee03 6b4f 	vmls.f64	d6, d3, d15
100005ec:	eeb0 ab46 	vmov.f64	d10, d6
100005f0:	eefc 6bc6 	vcvt.u32.f64	s13, d6
100005f4:	ed9d db08 	vldr	d13, [sp, #32]
100005f8:	ed9f 8b71 	vldr	d8, [pc, #452]	@ 100007c0 <fp64e_cmul+0x458>
100005fc:	ee16 3a90 	vmov	r3, s13
10000600:	ee27 2b08 	vmul.f64	d2, d7, d8
10000604:	ee2d 3b05 	vmul.f64	d3, d13, d5
10000608:	0fdb      	lsrs	r3, r3, #31
1000060a:	ee06 3a90 	vmov	s13, r3
1000060e:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10000612:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10000616:	ed8d 1b1e 	vstr	d1, [sp, #120]	@ 0x78
1000061a:	eeb8 2b42 	vcvt.f64.u32	d2, s4
1000061e:	ed9f 0b6c 	vldr	d0, [pc, #432]	@ 100007d0 <fp64e_cmul+0x468>
10000622:	eeb8 1be6 	vcvt.f64.s32	d1, s13
10000626:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000062a:	ee02 7b40 	vmls.f64	d7, d2, d0
1000062e:	ed8d 1b20 	vstr	d1, [sp, #128]	@ 0x80
10000632:	eeb0 bb43 	vmov.f64	d11, d3
10000636:	ee2a 1b08 	vmul.f64	d1, d10, d8
1000063a:	ed9f 8b71 	vldr	d8, [pc, #452]	@ 10000800 <fp64e_cmul+0x498>
1000063e:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10000642:	ee07 bb08 	vmla.f64	d11, d7, d8
10000646:	eeb0 7b4d 	vmov.f64	d7, d13
1000064a:	eeb8 1b41 	vcvt.f64.u32	d1, s2
1000064e:	ee03 7b4e 	vmls.f64	d7, d3, d14
10000652:	ed9d 3b06 	vldr	d3, [sp, #24]
10000656:	ee01 ab40 	vmls.f64	d10, d1, d0
1000065a:	eeb0 0b47 	vmov.f64	d0, d7
1000065e:	ee23 7b05 	vmul.f64	d7, d3, d5
10000662:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10000666:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000066a:	ee2c db05 	vmul.f64	d13, d12, d5
1000066e:	eeb0 9b47 	vmov.f64	d9, d7
10000672:	eebc dbcd 	vcvt.u32.f64	s26, d13
10000676:	ee0a 9b08 	vmla.f64	d9, d10, d8
1000067a:	eeb0 8b43 	vmov.f64	d8, d3
1000067e:	eeb8 db4d 	vcvt.f64.u32	d13, s26
10000682:	ee07 8b4e 	vmls.f64	d8, d7, d14
10000686:	ee20 7b08 	vmul.f64	d7, d0, d8
1000068a:	ee20 ab09 	vmul.f64	d10, d0, d9
1000068e:	ee20 3b01 	vmul.f64	d3, d0, d1
10000692:	ee2b 6b01 	vmul.f64	d6, d11, d1
10000696:	eeab ab08 	vfma.f64	d10, d11, d8
1000069a:	eeab 3b09 	vfma.f64	d3, d11, d9
1000069e:	eea2 6b09 	vfma.f64	d6, d2, d9
100006a2:	eea2 3b08 	vfma.f64	d3, d2, d8
100006a6:	ed8d 6b0e 	vstr	d6, [sp, #56]	@ 0x38
100006aa:	ee27 7b05 	vmul.f64	d7, d7, d5
100006ae:	ed9d 0b10 	vldr	d0, [sp, #64]	@ 0x40
100006b2:	ed9d 6b0a 	vldr	d6, [sp, #40]	@ 0x28
100006b6:	ee30 9b0d 	vadd.f64	d9, d0, d13
100006ba:	ee26 1b05 	vmul.f64	d1, d6, d5
100006be:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100006c2:	ee29 8b05 	vmul.f64	d8, d9, d5
100006c6:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100006ca:	eebc 1bc1 	vcvt.u32.f64	s2, d1
100006ce:	ee0d cb4e 	vmls.f64	d12, d13, d14
100006d2:	ee37 7b0a 	vadd.f64	d7, d7, d10
100006d6:	eeb8 1b41 	vcvt.f64.u32	d1, s2
100006da:	ed9f ab43 	vldr	d10, [pc, #268]	@ 100007e8 <fp64e_cmul+0x480>
100006de:	eebc 8bc8 	vcvt.u32.f64	s16, d8
100006e2:	eeb0 0b4a 	vmov.f64	d0, d10
100006e6:	ee2c cb0a 	vmul.f64	d12, d12, d10
100006ea:	eeb8 8b48 	vcvt.f64.u32	d8, s16
100006ee:	ee34 ab01 	vadd.f64	d10, d4, d1
100006f2:	ed9d 4b12 	vldr	d4, [sp, #72]	@ 0x48
100006f6:	ee08 9b4e 	vmls.f64	d9, d8, d14
100006fa:	ee27 db05 	vmul.f64	d13, d7, d5
100006fe:	ee01 6b4e 	vmls.f64	d6, d1, d14
10000702:	ee34 1b08 	vadd.f64	d1, d4, d8
10000706:	ee2a 8b05 	vmul.f64	d8, d10, d5
1000070a:	eebc dbcd 	vcvt.u32.f64	s26, d13
1000070e:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10000712:	ed9d 4b18 	vldr	d4, [sp, #96]	@ 0x60
10000716:	eeb8 8b48 	vcvt.f64.u32	d8, s16
1000071a:	eeb8 db4d 	vcvt.f64.u32	d13, s26
1000071e:	ee34 2b08 	vadd.f64	d2, d4, d8
10000722:	ee0d 7b4e 	vmls.f64	d7, d13, d14
10000726:	ee26 6b00 	vmul.f64	d6, d6, d0
1000072a:	ee27 7b00 	vmul.f64	d7, d7, d0
1000072e:	ee22 0b05 	vmul.f64	d0, d2, d5
10000732:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10000736:	ed9f 4b22 	vldr	d4, [pc, #136]	@ 100007c0 <fp64e_cmul+0x458>
1000073a:	eeb8 0b40 	vcvt.f64.u32	d0, s0
1000073e:	eeb0 bb42 	vmov.f64	d11, d2
10000742:	ee08 ab4e 	vmls.f64	d10, d8, d14
10000746:	ee00 bb4e 	vmls.f64	d11, d0, d14
1000074a:	ee21 8b05 	vmul.f64	d8, d1, d5
1000074e:	ee29 0b04 	vmul.f64	d0, d9, d4
10000752:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10000756:	eebc 0bc0 	vcvt.u32.f64	s0, d0
1000075a:	eeb8 8b48 	vcvt.f64.u32	d8, s16
1000075e:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10000762:	ee08 1b4e 	vmls.f64	d1, d8, d14
10000766:	ed9f 2b26 	vldr	d2, [pc, #152]	@ 10000800 <fp64e_cmul+0x498>
1000076a:	eeb0 8b4b 	vmov.f64	d8, d11
1000076e:	eeb0 bb40 	vmov.f64	d11, d0
10000772:	eebc cbcc 	vcvt.u32.f64	s24, d12
10000776:	ee01 bb02 	vmla.f64	d11, d1, d2
1000077a:	ed9f 1b15 	vldr	d1, [pc, #84]	@ 100007d0 <fp64e_cmul+0x468>
1000077e:	ee33 3b0d 	vadd.f64	d3, d3, d13
10000782:	ee00 9b41 	vmls.f64	d9, d0, d1
10000786:	ee2a db04 	vmul.f64	d13, d10, d4
1000078a:	ed9f 0b19 	vldr	d0, [pc, #100]	@ 100007f0 <fp64e_cmul+0x488>
1000078e:	eeb8 cb4c 	vcvt.f64.u32	d12, s24
10000792:	eeb0 4b40 	vmov.f64	d4, d0
10000796:	ee09 cb01 	vmla.f64	d12, d9, d1
1000079a:	ee3b 0b00 	vadd.f64	d0, d11, d0
1000079e:	ed9d 9b0c 	vldr	d9, [sp, #48]	@ 0x30
100007a2:	ed9d bb14 	vldr	d11, [sp, #80]	@ 0x50
100007a6:	eebc dbcd 	vcvt.u32.f64	s26, d13
100007aa:	ee0b 0b49 	vmls.f64	d0, d11, d9
100007ae:	eeb8 db4d 	vcvt.f64.u32	d13, s26
100007b2:	e02d      	b.n	10000810 <fp64e_cmul+0x4a8>
100007b4:	f3af 8000 	nop.w
100007b8:	00000000 	.word	0x00000000
100007bc:	3df00000 	.word	0x3df00000
100007c0:	00000000 	.word	0x00000000
100007c4:	3ef00000 	.word	0x3ef00000
100007c8:	00000000 	.word	0x00000000
100007cc:	41f00000 	.word	0x41f00000
100007d0:	00000000 	.word	0x00000000
100007d4:	40f00000 	.word	0x40f00000
100007d8:	00000000 	.word	0x00000000
100007dc:	3e700000 	.word	0x3e700000
100007e0:	00000000 	.word	0x00000000
100007e4:	41700000 	.word	0x41700000
100007e8:	00000000 	.word	0x00000000
100007ec:	3f700000 	.word	0x3f700000
100007f0:	00000000 	.word	0x00000000
100007f4:	42000000 	.word	0x42000000
100007f8:	00000000 	.word	0x00000000
100007fc:	3ef00000 	.word	0x3ef00000
10000800:	00000000 	.word	0x00000000
10000804:	40700000 	.word	0x40700000
10000808:	00000000 	.word	0x00000000
1000080c:	3df00000 	.word	0x3df00000
10000810:	ed9d bb16 	vldr	d11, [sp, #88]	@ 0x58
10000814:	ed9d 9b00 	vldr	d9, [sp]
10000818:	ed1f 2b07 	vldr	d2, [pc, #-28]	@ 10000800 <fp64e_cmul+0x498>
1000081c:	ee0b 0b49 	vmls.f64	d0, d11, d9
10000820:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10000824:	eeb0 9b4d 	vmov.f64	d9, d13
10000828:	ee0d ab41 	vmls.f64	d10, d13, d1
1000082c:	ee08 9b02 	vmla.f64	d9, d8, d2
10000830:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10000834:	ee23 2b05 	vmul.f64	d2, d3, d5
10000838:	ee0a 6b01 	vmla.f64	d6, d10, d1
1000083c:	ed9d bb1a 	vldr	d11, [sp, #104]	@ 0x68
10000840:	ed9d ab04 	vldr	d10, [sp, #16]
10000844:	ee39 9b04 	vadd.f64	d9, d9, d4
10000848:	eeb0 db41 	vmov.f64	d13, d1
1000084c:	ee0b 9b4a 	vmls.f64	d9, d11, d10
10000850:	ed9d 1b02 	vldr	d1, [sp, #8]
10000854:	ed9d bb1c 	vldr	d11, [sp, #112]	@ 0x70
10000858:	eebc 2bc2 	vcvt.u32.f64	s4, d2
1000085c:	ee0b 9b41 	vmls.f64	d9, d11, d1
10000860:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10000864:	ed9d bb0e 	vldr	d11, [sp, #56]	@ 0x38
10000868:	ee02 3b4e 	vmls.f64	d3, d2, d14
1000086c:	ee3b 1b02 	vadd.f64	d1, d11, d2
10000870:	ed1f ab1b 	vldr	d10, [pc, #-108]	@ 10000808 <fp64e_cmul+0x4a0>
10000874:	ed1f 2b20 	vldr	d2, [pc, #-128]	@ 100007f8 <fp64e_cmul+0x490>
10000878:	ee20 8b0a 	vmul.f64	d8, d0, d10
1000087c:	ee23 bb02 	vmul.f64	d11, d3, d2
10000880:	ee21 5b05 	vmul.f64	d5, d1, d5
10000884:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10000888:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000088c:	eebc bbcb 	vcvt.u32.f64	s22, d11
10000890:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10000894:	eeb8 bb4b 	vcvt.f64.u32	d11, s22
10000898:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000089c:	ee08 0b4f 	vmls.f64	d0, d8, d15
100008a0:	ee05 1b4e 	vmls.f64	d1, d5, d14
100008a4:	ed1f 8b2a 	vldr	d8, [pc, #-168]	@ 10000800 <fp64e_cmul+0x498>
100008a8:	eeb0 5b4b 	vmov.f64	d5, d11
100008ac:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100008b0:	ee29 2b0a 	vmul.f64	d2, d9, d10
100008b4:	ee0b 3b4d 	vmls.f64	d3, d11, d13
100008b8:	ee01 5b08 	vmla.f64	d5, d1, d8
100008bc:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100008c0:	eefc 2bc2 	vcvt.u32.f64	s5, d2
100008c4:	ee03 7b0d 	vmla.f64	d7, d3, d13
100008c8:	ee35 5b04 	vadd.f64	d5, d5, d4
100008cc:	ed9d 3b06 	vldr	d3, [sp, #24]
100008d0:	ed9d 4b1e 	vldr	d4, [sp, #120]	@ 0x78
100008d4:	ee04 5b43 	vmls.f64	d5, d4, d3
100008d8:	eeb8 3b62 	vcvt.f64.u32	d3, s5
100008dc:	ed1f ab36 	vldr	d10, [pc, #-216]	@ 10000808 <fp64e_cmul+0x4a0>
100008e0:	ee03 9b4f 	vmls.f64	d9, d3, d15
100008e4:	ee36 3b0c 	vadd.f64	d3, d6, d12
100008e8:	ee3c cb0f 	vadd.f64	d12, d12, d15
100008ec:	ee3c 1b46 	vsub.f64	d1, d12, d6
100008f0:	ee23 6b0a 	vmul.f64	d6, d3, d10
100008f4:	ed9d 4b20 	vldr	d4, [sp, #128]	@ 0x80
100008f8:	ed9d db08 	vldr	d13, [sp, #32]
100008fc:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10000900:	ee04 5b4d 	vmls.f64	d5, d4, d13
10000904:	ee39 2b00 	vadd.f64	d2, d9, d0
10000908:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000090c:	ee25 8b0a 	vmul.f64	d8, d5, d10
10000910:	ee37 7b0f 	vadd.f64	d7, d7, d15
10000914:	ee32 2b06 	vadd.f64	d2, d2, d6
10000918:	ee06 3b4f 	vmls.f64	d3, d6, d15
1000091c:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10000920:	ee37 3b43 	vsub.f64	d3, d7, d3
10000924:	ee22 7b0a 	vmul.f64	d7, d2, d10
10000928:	eeb8 8b48 	vcvt.f64.u32	d8, s16
1000092c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10000930:	ee08 5b4f 	vmls.f64	d5, d8, d15
10000934:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10000938:	ee23 6b0a 	vmul.f64	d6, d3, d10
1000093c:	ee07 2b4f 	vmls.f64	d2, d7, d15
10000940:	ee35 5b0f 	vadd.f64	d5, d5, d15
10000944:	ee21 7b0a 	vmul.f64	d7, d1, d10
10000948:	ee30 0b0f 	vadd.f64	d0, d0, d15
1000094c:	ee35 2b42 	vsub.f64	d2, d5, d2
10000950:	ee30 0b49 	vsub.f64	d0, d0, d9
10000954:	eeb7 5b00 	vmov.f64	d5, #112	@ 0x3f800000  1.0
10000958:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000095c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10000960:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10000964:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10000968:	ee30 0b45 	vsub.f64	d0, d0, d5
1000096c:	ee32 2b45 	vsub.f64	d2, d2, d5
10000970:	ee30 0b07 	vadd.f64	d0, d0, d7
10000974:	ee32 2b06 	vadd.f64	d2, d2, d6
10000978:	ee07 1b4f 	vmls.f64	d1, d7, d15
1000097c:	ee20 7b0a 	vmul.f64	d7, d0, d10
10000980:	ee22 4b0a 	vmul.f64	d4, d2, d10
10000984:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10000988:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000098c:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10000990:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10000994:	ee06 3b4f 	vmls.f64	d3, d6, d15
10000998:	ee07 0b4f 	vmls.f64	d0, d7, d15
1000099c:	ee04 2b4f 	vmls.f64	d2, d4, d15
100009a0:	b042      	add	sp, #264	@ 0x108
100009a2:	ecbd 8b10 	vpop	{d8-d15}
100009a6:	4770      	bx	lr

