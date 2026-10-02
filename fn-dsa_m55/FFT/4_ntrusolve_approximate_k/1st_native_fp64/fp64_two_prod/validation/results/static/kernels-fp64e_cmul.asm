10000368 <fp64e_cmul>:
10000368:	ed2d 8b10 	vpush	{d8-d15}
1000036c:	eeb0 ab46 	vmov.f64	d10, d6
10000370:	eefc 6bc4 	vcvt.u32.f64	s13, d4
10000374:	ee16 2a90 	vmov	r2, s13
10000378:	eefc 6bca 	vcvt.u32.f64	s13, d10
1000037c:	ee16 3a90 	vmov	r3, s13
10000380:	eefc 6bc0 	vcvt.u32.f64	s13, d0
10000384:	ee16 0a90 	vmov	r0, s13
10000388:	eefc 6bc2 	vcvt.u32.f64	s13, d2
1000038c:	0fc0      	lsrs	r0, r0, #31
1000038e:	ee16 1a90 	vmov	r1, s13
10000392:	ee06 0a90 	vmov	s13, r0
10000396:	0fc9      	lsrs	r1, r1, #31
10000398:	eeb0 eb42 	vmov.f64	d14, d2
1000039c:	eeb8 2be6 	vcvt.f64.s32	d2, s13
100003a0:	ee06 1a90 	vmov	s13, r1
100003a4:	eeb8 6be6 	vcvt.f64.s32	d6, s13
100003a8:	b0c8      	sub	sp, #288	@ 0x120
100003aa:	0fd2      	lsrs	r2, r2, #31
100003ac:	ed8d 6b20 	vstr	d6, [sp, #128]	@ 0x80
100003b0:	ee06 2a90 	vmov	s13, r2
100003b4:	0fdb      	lsrs	r3, r3, #31
100003b6:	eeb0 cb44 	vmov.f64	d12, d4
100003ba:	eeb0 8b47 	vmov.f64	d8, d7
100003be:	eeb8 4be6 	vcvt.f64.s32	d4, s13
100003c2:	ee06 3a90 	vmov	s13, r3
100003c6:	ed9f 7bfe 	vldr	d7, [pc, #1016]	@ 100007c0 <fp64e_cmul+0x458>
100003ca:	eeb0 db40 	vmov.f64	d13, d0
100003ce:	ee35 9b08 	vadd.f64	d9, d5, d8
100003d2:	eeb8 0be6 	vcvt.f64.s32	d0, s13
100003d6:	eeb0 6b48 	vmov.f64	d6, d8
100003da:	ee31 8b03 	vadd.f64	d8, d1, d3
100003de:	ed8d 1b00 	vstr	d1, [sp]
100003e2:	ee3d bb0e 	vadd.f64	d11, d13, d14
100003e6:	ee28 1b07 	vmul.f64	d1, d8, d7
100003ea:	ed8d 2b1a 	vstr	d2, [sp, #104]	@ 0x68
100003ee:	eebc 1bc1 	vcvt.u32.f64	s2, d1
100003f2:	eeb0 2b4b 	vmov.f64	d2, d11
100003f6:	ee29 bb07 	vmul.f64	d11, d9, d7
100003fa:	ed9f fbf3 	vldr	d15, [pc, #972]	@ 100007c8 <fp64e_cmul+0x460>
100003fe:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10000402:	eebc bbcb 	vcvt.u32.f64	s22, d11
10000406:	ee01 8b4f 	vmls.f64	d8, d1, d15
1000040a:	ed8d 0b22 	vstr	d0, [sp, #136]	@ 0x88
1000040e:	eeb8 bb4b 	vcvt.f64.u32	d11, s22
10000412:	ee3c 0b0a 	vadd.f64	d0, d12, d10
10000416:	ed8d 3b02 	vstr	d3, [sp, #8]
1000041a:	ee0b 9b4f 	vmls.f64	d9, d11, d15
1000041e:	ee25 3b07 	vmul.f64	d3, d5, d7
10000422:	ed8d 4b1c 	vstr	d4, [sp, #112]	@ 0x70
10000426:	ee30 0b0b 	vadd.f64	d0, d0, d11
1000042a:	ee26 4b07 	vmul.f64	d4, d6, d7
1000042e:	ed9d bb00 	vldr	d11, [sp]
10000432:	ed8d 8b16 	vstr	d8, [sp, #88]	@ 0x58
10000436:	ed9d 8b02 	vldr	d8, [sp, #8]
1000043a:	ed8d 9b04 	vstr	d9, [sp, #16]
1000043e:	ee24 8b08 	vmul.f64	d8, d4, d8
10000442:	ee32 9b01 	vadd.f64	d9, d2, d1
10000446:	ee24 4b0e 	vmul.f64	d4, d4, d14
1000044a:	ee2b 1b03 	vmul.f64	d1, d11, d3
1000044e:	ee2d 3b03 	vmul.f64	d3, d13, d3
10000452:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10000456:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000045a:	ed8d 5b06 	vstr	d5, [sp, #24]
1000045e:	ed8d 6b08 	vstr	d6, [sp, #32]
10000462:	ee2c 5b07 	vmul.f64	d5, d12, d7
10000466:	ee2a 6b07 	vmul.f64	d6, d10, d7
1000046a:	eeb8 2b44 	vcvt.f64.u32	d2, s8
1000046e:	eefc 3bc8 	vcvt.u32.f64	s7, d8
10000472:	ed9d 4b02 	vldr	d4, [sp, #8]
10000476:	eeb8 8b43 	vcvt.f64.u32	d8, s6
1000047a:	ee26 4b04 	vmul.f64	d4, d6, d4
1000047e:	ed8d 8b10 	vstr	d8, [sp, #64]	@ 0x40
10000482:	ee2b 8b05 	vmul.f64	d8, d11, d5
10000486:	ee2d 5b05 	vmul.f64	d5, d13, d5
1000048a:	ee26 6b0e 	vmul.f64	d6, d6, d14
1000048e:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10000492:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10000496:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000049a:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000049e:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100004a2:	ed8d 4b0c 	vstr	d4, [sp, #48]	@ 0x30
100004a6:	ee25 5b4f 	vnmul.f64	d5, d5, d15
100004aa:	eead 5b0c 	vfma.f64	d5, d13, d12
100004ae:	eebc 1bc1 	vcvt.u32.f64	s2, d1
100004b2:	ee35 4b0f 	vadd.f64	d4, d5, d15
100004b6:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100004ba:	ee20 5b07 	vmul.f64	d5, d0, d7
100004be:	eeb8 1b41 	vcvt.f64.u32	d1, s2
100004c2:	eebc 8bc8 	vcvt.u32.f64	s16, d8
100004c6:	ee26 6b4f 	vnmul.f64	d6, d6, d15
100004ca:	eeae 6b0a 	vfma.f64	d6, d14, d10
100004ce:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100004d2:	ee36 6b0f 	vadd.f64	d6, d6, d15
100004d6:	eeb8 bb48 	vcvt.f64.u32	d11, s16
100004da:	ed8d 4b14 	vstr	d4, [sp, #80]	@ 0x50
100004de:	ed9d 8b06 	vldr	d8, [sp, #24]
100004e2:	ed9d 4b00 	vldr	d4, [sp]
100004e6:	ed8d 6b12 	vstr	d6, [sp, #72]	@ 0x48
100004ea:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100004ee:	ee21 6b4f 	vnmul.f64	d6, d1, d15
100004f2:	eea4 6b08 	vfma.f64	d6, d4, d8
100004f6:	ee36 6b0f 	vadd.f64	d6, d6, d15
100004fa:	ee05 0b4f 	vmls.f64	d0, d5, d15
100004fe:	ee26 6b07 	vmul.f64	d6, d6, d7
10000502:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10000506:	eefc 6bc0 	vcvt.u32.f64	s13, d0
1000050a:	ee16 3a90 	vmov	r3, s13
1000050e:	0fdb      	lsrs	r3, r3, #31
10000510:	ee05 3a90 	vmov	s11, r3
10000514:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10000518:	ed8d 0b0a 	vstr	d0, [sp, #40]	@ 0x28
1000051c:	ee36 6b01 	vadd.f64	d6, d6, d1
10000520:	eeb7 0b00 	vmov.f64	d0, #112	@ 0x3f800000  1.0
10000524:	eeb8 1be5 	vcvt.f64.s32	d1, s11
10000528:	eeb8 3b63 	vcvt.f64.u32	d3, s7
1000052c:	ed8d 1b26 	vstr	d1, [sp, #152]	@ 0x98
10000530:	ee36 1b40 	vsub.f64	d1, d6, d0
10000534:	ed9d 8b02 	vldr	d8, [sp, #8]
10000538:	ee29 5b07 	vmul.f64	d5, d9, d7
1000053c:	ed8d 1b18 	vstr	d1, [sp, #96]	@ 0x60
10000540:	ee23 6b4f 	vnmul.f64	d6, d3, d15
10000544:	ed9d 1b08 	vldr	d1, [sp, #32]
10000548:	eea8 6b01 	vfma.f64	d6, d8, d1
1000054c:	ee36 6b0f 	vadd.f64	d6, d6, d15
10000550:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10000554:	ee26 6b07 	vmul.f64	d6, d6, d7
10000558:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000055c:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10000560:	ee05 9b4f 	vmls.f64	d9, d5, d15
10000564:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10000568:	eeb0 5b49 	vmov.f64	d5, d9
1000056c:	ee36 6b03 	vadd.f64	d6, d6, d3
10000570:	ee36 3b40 	vsub.f64	d3, d6, d0
10000574:	eefc 6bc5 	vcvt.u32.f64	s13, d5
10000578:	ee16 3a90 	vmov	r3, s13
1000057c:	0fdb      	lsrs	r3, r3, #31
1000057e:	ee06 3a90 	vmov	s13, r3
10000582:	ed8d 3b1e 	vstr	d3, [sp, #120]	@ 0x78
10000586:	ee2b 1b4f 	vnmul.f64	d1, d11, d15
1000058a:	eea4 1b0c 	vfma.f64	d1, d4, d12
1000058e:	ed9d 3b0c 	vldr	d3, [sp, #48]	@ 0x30
10000592:	eeb0 cb45 	vmov.f64	d12, d5
10000596:	eeb8 5be6 	vcvt.f64.s32	d5, s13
1000059a:	ed9d 9b04 	vldr	d9, [sp, #16]
1000059e:	ed9d 6b0a 	vldr	d6, [sp, #40]	@ 0x28
100005a2:	ed8d 5b24 	vstr	d5, [sp, #144]	@ 0x90
100005a6:	ee23 3b4f 	vnmul.f64	d3, d3, d15
100005aa:	eea8 3b0a 	vfma.f64	d3, d8, d10
100005ae:	ed9d ab10 	vldr	d10, [sp, #64]	@ 0x40
100005b2:	ee26 4b07 	vmul.f64	d4, d6, d7
100005b6:	ee29 0b07 	vmul.f64	d0, d9, d7
100005ba:	ee2a 6b4f 	vnmul.f64	d6, d10, d15
100005be:	ed9d 5b06 	vldr	d5, [sp, #24]
100005c2:	eead 6b05 	vfma.f64	d6, d13, d5
100005c6:	ee22 5b4f 	vnmul.f64	d5, d2, d15
100005ca:	ed9d db08 	vldr	d13, [sp, #32]
100005ce:	eeae 5b0d 	vfma.f64	d5, d14, d13
100005d2:	ed9d eb16 	vldr	d14, [sp, #88]	@ 0x58
100005d6:	ee20 9b0e 	vmul.f64	d9, d0, d14
100005da:	ee20 0b0c 	vmul.f64	d0, d0, d12
100005de:	ee31 1b0f 	vadd.f64	d1, d1, d15
100005e2:	ee33 3b0f 	vadd.f64	d3, d3, d15
100005e6:	eebc 0bc0 	vcvt.u32.f64	s0, d0
100005ea:	ee21 8b07 	vmul.f64	d8, d1, d7
100005ee:	eeb8 db40 	vcvt.f64.u32	d13, s0
100005f2:	ee23 0b07 	vmul.f64	d0, d3, d7
100005f6:	eebc 8bc8 	vcvt.u32.f64	s16, d8
100005fa:	eebc 0bc0 	vcvt.u32.f64	s0, d0
100005fe:	ed9d ab0c 	vldr	d10, [sp, #48]	@ 0x30
10000602:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10000606:	eeb8 0b40 	vcvt.f64.u32	d0, s0
1000060a:	ee36 6b0f 	vadd.f64	d6, d6, d15
1000060e:	ee08 1b4f 	vmls.f64	d1, d8, d15
10000612:	ee00 3b4f 	vmls.f64	d3, d0, d15
10000616:	ee3b 8b08 	vadd.f64	d8, d11, d8
1000061a:	ee3a 0b00 	vadd.f64	d0, d10, d0
1000061e:	ed9d bb18 	vldr	d11, [sp, #96]	@ 0x60
10000622:	ed9d ab1e 	vldr	d10, [sp, #120]	@ 0x78
10000626:	ee3b 1b01 	vadd.f64	d1, d11, d1
1000062a:	ee3a 3b03 	vadd.f64	d3, d10, d3
1000062e:	ee26 bb07 	vmul.f64	d11, d6, d7
10000632:	ee24 ab0e 	vmul.f64	d10, d4, d14
10000636:	ed8d 2b0e 	vstr	d2, [sp, #56]	@ 0x38
1000063a:	eefc abca 	vcvt.u32.f64	s21, d10
1000063e:	eeb7 2b00 	vmov.f64	d2, #112	@ 0x3f800000  1.0
10000642:	eebc abcb 	vcvt.u32.f64	s20, d11
10000646:	ee38 8b42 	vsub.f64	d8, d8, d2
1000064a:	eeb8 bb6a 	vcvt.f64.u32	d11, s21
1000064e:	ed8d 3b16 	vstr	d3, [sp, #88]	@ 0x58
10000652:	ee30 0b42 	vsub.f64	d0, d0, d2
10000656:	eeb0 3b42 	vmov.f64	d3, d2
1000065a:	ee24 4b0c 	vmul.f64	d4, d4, d12
1000065e:	ed9d 2b10 	vldr	d2, [sp, #64]	@ 0x40
10000662:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10000666:	eebc 9bc9 	vcvt.u32.f64	s18, d9
1000066a:	ee0a 6b4f 	vmls.f64	d6, d10, d15
1000066e:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10000672:	ee32 ab0a 	vadd.f64	d10, d2, d10
10000676:	ee35 5b0f 	vadd.f64	d5, d5, d15
1000067a:	eeb8 9b49 	vcvt.f64.u32	d9, s18
1000067e:	ee3a ab43 	vsub.f64	d10, d10, d3
10000682:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10000686:	ed9d 3b0a 	vldr	d3, [sp, #40]	@ 0x28
1000068a:	ee31 6b06 	vadd.f64	d6, d1, d6
1000068e:	ee38 ab0a 	vadd.f64	d10, d8, d10
10000692:	ee25 1b07 	vmul.f64	d1, d5, d7
10000696:	ed8d cb0c 	vstr	d12, [sp, #48]	@ 0x30
1000069a:	ed9d 8b04 	vldr	d8, [sp, #16]
1000069e:	ee24 4b4f 	vnmul.f64	d4, d4, d15
100006a2:	eeac 4b03 	vfma.f64	d4, d12, d3
100006a6:	ee34 cb0f 	vadd.f64	d12, d4, d15
100006aa:	ee29 4b4f 	vnmul.f64	d4, d9, d15
100006ae:	eeae 4b08 	vfma.f64	d4, d14, d8
100006b2:	ee34 4b0f 	vadd.f64	d4, d4, d15
100006b6:	eebc 1bc1 	vcvt.u32.f64	s2, d1
100006ba:	ee24 4b07 	vmul.f64	d4, d4, d7
100006be:	ed9d 2b0e 	vldr	d2, [sp, #56]	@ 0x38
100006c2:	eeb8 1b41 	vcvt.f64.u32	d1, s2
100006c6:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100006ca:	ee01 5b4f 	vmls.f64	d5, d1, d15
100006ce:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100006d2:	ee32 1b01 	vadd.f64	d1, d2, d1
100006d6:	eeb7 2b00 	vmov.f64	d2, #112	@ 0x3f800000  1.0
100006da:	ee34 9b09 	vadd.f64	d9, d4, d9
100006de:	ee31 1b42 	vsub.f64	d1, d1, d2
100006e2:	ed9d 4b14 	vldr	d4, [sp, #80]	@ 0x50
100006e6:	ed9d 8b16 	vldr	d8, [sp, #88]	@ 0x58
100006ea:	ee30 1b01 	vadd.f64	d1, d0, d1
100006ee:	ee39 9b42 	vsub.f64	d9, d9, d2
100006f2:	ee24 0b07 	vmul.f64	d0, d4, d7
100006f6:	ed9d 2b12 	vldr	d2, [sp, #72]	@ 0x48
100006fa:	ee38 5b05 	vadd.f64	d5, d8, d5
100006fe:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10000702:	ee2b 8b4f 	vnmul.f64	d8, d11, d15
10000706:	eeae 8b03 	vfma.f64	d8, d14, d3
1000070a:	ee22 3b07 	vmul.f64	d3, d2, d7
1000070e:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10000712:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10000716:	ee00 4b4f 	vmls.f64	d4, d0, d15
1000071a:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000071e:	eeb0 0b42 	vmov.f64	d0, d2
10000722:	ee38 8b0f 	vadd.f64	d8, d8, d15
10000726:	ee03 0b4f 	vmls.f64	d0, d3, d15
1000072a:	ee34 4b0a 	vadd.f64	d4, d4, d10
1000072e:	ee2d 3b4f 	vnmul.f64	d3, d13, d15
10000732:	ed9d ab04 	vldr	d10, [sp, #16]
10000736:	ee30 0b01 	vadd.f64	d0, d0, d1
1000073a:	ed9d 1b0c 	vldr	d1, [sp, #48]	@ 0x30
1000073e:	eea1 3b0a 	vfma.f64	d3, d1, d10
10000742:	ee28 1b07 	vmul.f64	d1, d8, d7
10000746:	ee26 ab07 	vmul.f64	d10, d6, d7
1000074a:	eebc 1bc1 	vcvt.u32.f64	s2, d1
1000074e:	eebc abca 	vcvt.u32.f64	s20, d10
10000752:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10000756:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
1000075a:	ee01 8b4f 	vmls.f64	d8, d1, d15
1000075e:	eeb7 2b00 	vmov.f64	d2, #112	@ 0x3f800000  1.0
10000762:	ee39 8b08 	vadd.f64	d8, d9, d8
10000766:	ee3b 1b01 	vadd.f64	d1, d11, d1
1000076a:	ee34 4b0a 	vadd.f64	d4, d4, d10
1000076e:	ed9f 9b18 	vldr	d9, [pc, #96]	@ 100007d0 <fp64e_cmul+0x468>
10000772:	ee31 1b42 	vsub.f64	d1, d1, d2
10000776:	ed9d bb06 	vldr	d11, [sp, #24]
1000077a:	ed9d 2b1a 	vldr	d2, [sp, #104]	@ 0x68
1000077e:	ee34 4b09 	vadd.f64	d4, d4, d9
10000782:	ed9d 9b00 	vldr	d9, [sp]
10000786:	ee02 4b4b 	vmls.f64	d4, d2, d11
1000078a:	ed9d 2b1c 	vldr	d2, [sp, #112]	@ 0x70
1000078e:	ee33 3b0f 	vadd.f64	d3, d3, d15
10000792:	ee02 4b49 	vmls.f64	d4, d2, d9
10000796:	ee25 9b07 	vmul.f64	d9, d5, d7
1000079a:	ee0a 6b4f 	vmls.f64	d6, d10, d15
1000079e:	eebc 9bc9 	vcvt.u32.f64	s18, d9
100007a2:	ee23 ab07 	vmul.f64	d10, d3, d7
100007a6:	eeb8 9b49 	vcvt.f64.u32	d9, s18
100007aa:	eebc abca 	vcvt.u32.f64	s20, d10
100007ae:	ee09 5b4f 	vmls.f64	d5, d9, d15
100007b2:	ee30 0b09 	vadd.f64	d0, d0, d9
100007b6:	eeb8 9b4a 	vcvt.f64.u32	d9, s20
100007ba:	e00d      	b.n	100007d8 <fp64e_cmul+0x470>
100007bc:	f3af 8000 	nop.w
100007c0:	00000000 	.word	0x00000000
100007c4:	3df00000 	.word	0x3df00000
100007c8:	00000000 	.word	0x00000000
100007cc:	41f00000 	.word	0x41f00000
100007d0:	00000000 	.word	0x00000000
100007d4:	42000000 	.word	0x42000000
100007d8:	ee09 3b4f 	vmls.f64	d3, d9, d15
100007dc:	ee3d 9b09 	vadd.f64	d9, d13, d9
100007e0:	eeb7 db00 	vmov.f64	d13, #112	@ 0x3f800000  1.0
100007e4:	ee39 9b4d 	vsub.f64	d9, d9, d13
100007e8:	ee31 9b09 	vadd.f64	d9, d1, d9
100007ec:	ee2c 1b07 	vmul.f64	d1, d12, d7
100007f0:	ee38 3b03 	vadd.f64	d3, d8, d3
100007f4:	eebc 1bc1 	vcvt.u32.f64	s2, d1
100007f8:	ee23 8b07 	vmul.f64	d8, d3, d7
100007fc:	ed1f bb0c 	vldr	d11, [pc, #-48]	@ 100007d0 <fp64e_cmul+0x468>
10000800:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10000804:	ed9d 2b20 	vldr	d2, [sp, #128]	@ 0x80
10000808:	ee01 cb4f 	vmls.f64	d12, d1, d15
1000080c:	ee30 0b0b 	vadd.f64	d0, d0, d11
10000810:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10000814:	ed9d bb08 	vldr	d11, [sp, #32]
10000818:	ed9d ab02 	vldr	d10, [sp, #8]
1000081c:	ee02 0b4b 	vmls.f64	d0, d2, d11
10000820:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10000824:	ed9d 2b22 	vldr	d2, [sp, #136]	@ 0x88
10000828:	ee3c cb09 	vadd.f64	d12, d12, d9
1000082c:	ee02 0b4a 	vmls.f64	d0, d2, d10
10000830:	ee08 3b4f 	vmls.f64	d3, d8, d15
10000834:	ee3c cb08 	vadd.f64	d12, d12, d8
10000838:	ee24 8b07 	vmul.f64	d8, d4, d7
1000083c:	ee20 1b07 	vmul.f64	d1, d0, d7
10000840:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10000844:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10000848:	eeb8 8b48 	vcvt.f64.u32	d8, s16
1000084c:	ed1f bb20 	vldr	d11, [pc, #-128]	@ 100007d0 <fp64e_cmul+0x468>
10000850:	ee08 4b4f 	vmls.f64	d4, d8, d15
10000854:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10000858:	ee35 8b06 	vadd.f64	d8, d5, d6
1000085c:	ee36 6b0f 	vadd.f64	d6, d6, d15
10000860:	ee01 0b4f 	vmls.f64	d0, d1, d15
10000864:	ee3c cb0b 	vadd.f64	d12, d12, d11
10000868:	ee36 1b45 	vsub.f64	d1, d6, d5
1000086c:	ed9d 9b24 	vldr	d9, [sp, #144]	@ 0x90
10000870:	ee28 5b07 	vmul.f64	d5, d8, d7
10000874:	ed9d ab04 	vldr	d10, [sp, #16]
10000878:	ed9d 2b26 	vldr	d2, [sp, #152]	@ 0x98
1000087c:	ee09 cb4a 	vmls.f64	d12, d9, d10
10000880:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10000884:	ee02 cb4e 	vmls.f64	d12, d2, d14
10000888:	ee30 6b04 	vadd.f64	d6, d0, d4
1000088c:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10000890:	ee34 4b0f 	vadd.f64	d4, d4, d15
10000894:	ee36 6b05 	vadd.f64	d6, d6, d5
10000898:	ee34 0b40 	vsub.f64	d0, d4, d0
1000089c:	ee2c 4b07 	vmul.f64	d4, d12, d7
100008a0:	ee05 8b4f 	vmls.f64	d8, d5, d15
100008a4:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100008a8:	ee26 5b07 	vmul.f64	d5, d6, d7
100008ac:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100008b0:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100008b4:	ee04 cb4f 	vmls.f64	d12, d4, d15
100008b8:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100008bc:	ee3c cb0f 	vadd.f64	d12, d12, d15
100008c0:	ee05 6b4f 	vmls.f64	d6, d5, d15
100008c4:	ee3c cb46 	vsub.f64	d12, d12, d6
100008c8:	ee21 6b07 	vmul.f64	d6, d1, d7
100008cc:	ee33 3b0f 	vadd.f64	d3, d3, d15
100008d0:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100008d4:	ee33 3b48 	vsub.f64	d3, d3, d8
100008d8:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100008dc:	ee30 0b4d 	vsub.f64	d0, d0, d13
100008e0:	ee06 1b4f 	vmls.f64	d1, d6, d15
100008e4:	ee30 0b06 	vadd.f64	d0, d0, d6
100008e8:	ee23 6b07 	vmul.f64	d6, d3, d7
100008ec:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100008f0:	ee3c 2b4d 	vsub.f64	d2, d12, d13
100008f4:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100008f8:	ee32 2b06 	vadd.f64	d2, d2, d6
100008fc:	ee06 3b4f 	vmls.f64	d3, d6, d15
10000900:	ee20 6b07 	vmul.f64	d6, d0, d7
10000904:	ee22 7b07 	vmul.f64	d7, d2, d7
10000908:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000090c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10000910:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10000914:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10000918:	ee06 0b4f 	vmls.f64	d0, d6, d15
1000091c:	ee07 2b4f 	vmls.f64	d2, d7, d15
10000920:	b048      	add	sp, #288	@ 0x120
10000922:	ecbd 8b10 	vpop	{d8-d15}
10000926:	4770      	bx	lr

