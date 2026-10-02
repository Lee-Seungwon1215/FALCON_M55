10000368 <fp64e_cmul_prepared>:
10000368:	eefc 6bc0 	vcvt.u32.f64	s13, d0
1000036c:	ee16 2a90 	vmov	r2, s13
10000370:	eefc 6bc2 	vcvt.u32.f64	s13, d2
10000374:	0fd2      	lsrs	r2, r2, #31
10000376:	ee16 3a90 	vmov	r3, s13
1000037a:	ee06 2a90 	vmov	s13, r2
1000037e:	ed2d 8b10 	vpush	{d8-d15}
10000382:	eeb8 6be6 	vcvt.f64.s32	d6, s13
10000386:	b0b4      	sub	sp, #208	@ 0xd0
10000388:	0fdb      	lsrs	r3, r3, #31
1000038a:	ed8d 6b14 	vstr	d6, [sp, #80]	@ 0x50
1000038e:	ee06 3a90 	vmov	s13, r3
10000392:	eeb0 fb43 	vmov.f64	d15, d3
10000396:	eeb0 db41 	vmov.f64	d13, d1
1000039a:	ed90 3b06 	vldr	d3, [r0, #24]
1000039e:	eeb8 5be6 	vcvt.f64.s32	d5, s13
100003a2:	ee31 eb0f 	vadd.f64	d14, d1, d15
100003a6:	ed8d 5b18 	vstr	d5, [sp, #96]	@ 0x60
100003aa:	ed9f 5bff 	vldr	d5, [pc, #1020]	@ 100007a8 <fp64e_cmul_prepared+0x440>
100003ae:	ed90 1b10 	vldr	d1, [r0, #64]	@ 0x40
100003b2:	ee2d 9b03 	vmul.f64	d9, d13, d3
100003b6:	ee20 3b03 	vmul.f64	d3, d0, d3
100003ba:	ee2e 8b05 	vmul.f64	d8, d14, d5
100003be:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100003c2:	eefc 3bc8 	vcvt.u32.f64	s7, d8
100003c6:	eeb8 8b43 	vcvt.f64.u32	d8, s6
100003ca:	eebc 9bc9 	vcvt.u32.f64	s18, d9
100003ce:	ed8d 8b0a 	vstr	d8, [sp, #40]	@ 0x28
100003d2:	ee2f 8b01 	vmul.f64	d8, d15, d1
100003d6:	ed90 6b0e 	vldr	d6, [r0, #56]	@ 0x38
100003da:	ed90 4b04 	vldr	d4, [r0, #16]
100003de:	ee22 1b01 	vmul.f64	d1, d2, d1
100003e2:	eebc 1bc1 	vcvt.u32.f64	s2, d1
100003e6:	eeb8 ab41 	vcvt.f64.u32	d10, s2
100003ea:	ed8d ab08 	vstr	d10, [sp, #32]
100003ee:	ee2f ab06 	vmul.f64	d10, d15, d6
100003f2:	ed9f 7bef 	vldr	d7, [pc, #956]	@ 100007b0 <fp64e_cmul_prepared+0x448>
100003f6:	eebc abca 	vcvt.u32.f64	s20, d10
100003fa:	ee2d 1b04 	vmul.f64	d1, d13, d4
100003fe:	eeb8 cb4a 	vcvt.f64.u32	d12, s20
10000402:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10000406:	eeb8 3b63 	vcvt.f64.u32	d3, s7
1000040a:	ee30 ab02 	vadd.f64	d10, d0, d2
1000040e:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10000412:	ee3a ab03 	vadd.f64	d10, d10, d3
10000416:	eeb8 bb41 	vcvt.f64.u32	d11, s2
1000041a:	ee03 eb47 	vmls.f64	d14, d3, d7
1000041e:	ee29 1b47 	vnmul.f64	d1, d9, d7
10000422:	ed90 3b02 	vldr	d3, [r0, #8]
10000426:	eead 1b03 	vfma.f64	d1, d13, d3
1000042a:	ee31 1b07 	vadd.f64	d1, d1, d7
1000042e:	ed8d db04 	vstr	d13, [sp, #16]
10000432:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10000436:	ee21 1b05 	vmul.f64	d1, d1, d5
1000043a:	eeb8 8b48 	vcvt.f64.u32	d8, s16
1000043e:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10000442:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10000446:	ee28 3b47 	vnmul.f64	d3, d8, d7
1000044a:	ee31 db09 	vadd.f64	d13, d1, d9
1000044e:	ee2a 1b05 	vmul.f64	d1, d10, d5
10000452:	ed90 9b0c 	vldr	d9, [r0, #48]	@ 0x30
10000456:	eeaf 3b09 	vfma.f64	d3, d15, d9
1000045a:	ee33 3b07 	vadd.f64	d3, d3, d7
1000045e:	ed8d eb00 	vstr	d14, [sp]
10000462:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10000466:	ee23 3b05 	vmul.f64	d3, d3, d5
1000046a:	eeb8 1b41 	vcvt.f64.u32	d1, s2
1000046e:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10000472:	ee01 ab47 	vmls.f64	d10, d1, d7
10000476:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000047a:	ee20 4b04 	vmul.f64	d4, d0, d4
1000047e:	ee33 eb08 	vadd.f64	d14, d3, d8
10000482:	eefc 3bca 	vcvt.u32.f64	s7, d10
10000486:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000048a:	ee13 3a90 	vmov	r3, s7
1000048e:	ee22 6b06 	vmul.f64	d6, d2, d6
10000492:	0fdb      	lsrs	r3, r3, #31
10000494:	ee03 3a90 	vmov	s7, r3
10000498:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000049c:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100004a0:	ed90 8b00 	vldr	d8, [r0]
100004a4:	ed8d ab02 	vstr	d10, [sp, #8]
100004a8:	ee2b 1b47 	vnmul.f64	d1, d11, d7
100004ac:	ed9d ab04 	vldr	d10, [sp, #16]
100004b0:	eeaa 1b08 	vfma.f64	d1, d10, d8
100004b4:	ee24 4b47 	vnmul.f64	d4, d4, d7
100004b8:	eea0 4b08 	vfma.f64	d4, d0, d8
100004bc:	eeb8 3be3 	vcvt.f64.s32	d3, s7
100004c0:	ee34 4b07 	vadd.f64	d4, d4, d7
100004c4:	ed9d 8b0a 	vldr	d8, [sp, #40]	@ 0x28
100004c8:	ed90 ab02 	vldr	d10, [r0, #8]
100004cc:	ed8d 3b1a 	vstr	d3, [sp, #104]	@ 0x68
100004d0:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100004d4:	ed8d 4b10 	vstr	d4, [sp, #64]	@ 0x40
100004d8:	ee2c 3b47 	vnmul.f64	d3, d12, d7
100004dc:	ed90 4b0a 	vldr	d4, [r0, #40]	@ 0x28
100004e0:	eeaf 3b04 	vfma.f64	d3, d15, d4
100004e4:	ee26 6b47 	vnmul.f64	d6, d6, d7
100004e8:	eea2 6b04 	vfma.f64	d6, d2, d4
100004ec:	ee28 8b47 	vnmul.f64	d8, d8, d7
100004f0:	eea0 8b0a 	vfma.f64	d8, d0, d10
100004f4:	ee33 4b07 	vadd.f64	d4, d3, d7
100004f8:	ed9d ab08 	vldr	d10, [sp, #32]
100004fc:	ed90 9b1a 	vldr	d9, [r0, #104]	@ 0x68
10000500:	ed90 0b0c 	vldr	d0, [r0, #48]	@ 0x30
10000504:	ee36 3b07 	vadd.f64	d3, d6, d7
10000508:	ed9d 6b02 	vldr	d6, [sp, #8]
1000050c:	ed8d 3b0e 	vstr	d3, [sp, #56]	@ 0x38
10000510:	ee2a 3b47 	vnmul.f64	d3, d10, d7
10000514:	eea2 3b00 	vfma.f64	d3, d2, d0
10000518:	ee31 1b07 	vadd.f64	d1, d1, d7
1000051c:	ed9d 2b00 	vldr	d2, [sp]
10000520:	ee29 ab02 	vmul.f64	d10, d9, d2
10000524:	ee29 9b06 	vmul.f64	d9, d9, d6
10000528:	ee21 0b05 	vmul.f64	d0, d1, d5
1000052c:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10000530:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10000534:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10000538:	eeb8 0b40 	vcvt.f64.u32	d0, s0
1000053c:	ed8d 9b0c 	vstr	d9, [sp, #48]	@ 0x30
10000540:	ee24 9b05 	vmul.f64	d9, d4, d5
10000544:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10000548:	ee00 1b47 	vmls.f64	d1, d0, d7
1000054c:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10000550:	ee3b 0b00 	vadd.f64	d0, d11, d0
10000554:	ed8d 1b12 	vstr	d1, [sp, #72]	@ 0x48
10000558:	eeb0 bb44 	vmov.f64	d11, d4
1000055c:	ee09 bb47 	vmls.f64	d11, d9, d7
10000560:	ee38 8b07 	vadd.f64	d8, d8, d7
10000564:	ed8d bb16 	vstr	d11, [sp, #88]	@ 0x58
10000568:	ed90 bb18 	vldr	d11, [r0, #96]	@ 0x60
1000056c:	ed9d 1b0a 	vldr	d1, [sp, #40]	@ 0x28
10000570:	ee2b 4b02 	vmul.f64	d4, d11, d2
10000574:	ee28 2b05 	vmul.f64	d2, d8, d5
10000578:	eebc 2bc2 	vcvt.u32.f64	s4, d2
1000057c:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10000580:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10000584:	ee02 8b47 	vmls.f64	d8, d2, d7
10000588:	ee31 2b02 	vadd.f64	d2, d1, d2
1000058c:	eeb7 1b00 	vmov.f64	d1, #112	@ 0x3f800000  1.0
10000590:	ee33 3b07 	vadd.f64	d3, d3, d7
10000594:	ee2b 6b06 	vmul.f64	d6, d11, d6
10000598:	ee3c 9b09 	vadd.f64	d9, d12, d9
1000059c:	ed9d cb12 	vldr	d12, [sp, #72]	@ 0x48
100005a0:	eeb8 bb44 	vcvt.f64.u32	d11, s8
100005a4:	ee3d 4b41 	vsub.f64	d4, d13, d1
100005a8:	ed8d bb06 	vstr	d11, [sp, #24]
100005ac:	ee23 bb05 	vmul.f64	d11, d3, d5
100005b0:	ee34 4b0c 	vadd.f64	d4, d4, d12
100005b4:	eebc bbcb 	vcvt.u32.f64	s22, d11
100005b8:	ee34 cb08 	vadd.f64	d12, d4, d8
100005bc:	ed9d 4b16 	vldr	d4, [sp, #88]	@ 0x58
100005c0:	ee3e 8b41 	vsub.f64	d8, d14, d1
100005c4:	eebc abca 	vcvt.u32.f64	s20, d10
100005c8:	ee38 8b04 	vadd.f64	d8, d8, d4
100005cc:	eeb8 4b4b 	vcvt.f64.u32	d4, s22
100005d0:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
100005d4:	ee32 2b41 	vsub.f64	d2, d2, d1
100005d8:	ed9d bb00 	vldr	d11, [sp]
100005dc:	ee04 3b47 	vmls.f64	d3, d4, d7
100005e0:	ee38 8b03 	vadd.f64	d8, d8, d3
100005e4:	ed90 db16 	vldr	d13, [r0, #88]	@ 0x58
100005e8:	ee2a 3b47 	vnmul.f64	d3, d10, d7
100005ec:	eeab 3b0d 	vfma.f64	d3, d11, d13
100005f0:	ee30 0b41 	vsub.f64	d0, d0, d1
100005f4:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100005f8:	ee30 0b02 	vadd.f64	d0, d0, d2
100005fc:	ed9d 2b08 	vldr	d2, [sp, #32]
10000600:	ee33 3b07 	vadd.f64	d3, d3, d7
10000604:	ee32 4b04 	vadd.f64	d4, d2, d4
10000608:	ed9d 2b06 	vldr	d2, [sp, #24]
1000060c:	ee23 3b05 	vmul.f64	d3, d3, d5
10000610:	ee34 4b41 	vsub.f64	d4, d4, d1
10000614:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10000618:	ee39 9b41 	vsub.f64	d9, d9, d1
1000061c:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10000620:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10000624:	ee39 9b04 	vadd.f64	d9, d9, d4
10000628:	ee26 6b47 	vnmul.f64	d6, d6, d7
1000062c:	ed90 4b14 	vldr	d4, [r0, #80]	@ 0x50
10000630:	ee22 2b47 	vnmul.f64	d2, d2, d7
10000634:	eeab 2b04 	vfma.f64	d2, d11, d4
10000638:	ee33 3b0a 	vadd.f64	d3, d3, d10
1000063c:	ed9d ab02 	vldr	d10, [sp, #8]
10000640:	eeaa 6b04 	vfma.f64	d6, d10, d4
10000644:	ee32 2b07 	vadd.f64	d2, d2, d7
10000648:	ed9d 4b10 	vldr	d4, [sp, #64]	@ 0x40
1000064c:	ed9d db0e 	vldr	d13, [sp, #56]	@ 0x38
10000650:	ed9d eb0c 	vldr	d14, [sp, #48]	@ 0x30
10000654:	ee24 ab05 	vmul.f64	d10, d4, d5
10000658:	eebc abca 	vcvt.u32.f64	s20, d10
1000065c:	ee2d bb05 	vmul.f64	d11, d13, d5
10000660:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10000664:	eebc bbcb 	vcvt.u32.f64	s22, d11
10000668:	ee0a 4b47 	vmls.f64	d4, d10, d7
1000066c:	eeb8 bb4b 	vcvt.f64.u32	d11, s22
10000670:	ee34 4b00 	vadd.f64	d4, d4, d0
10000674:	eeb0 0b4d 	vmov.f64	d0, d13
10000678:	ee0b 0b47 	vmls.f64	d0, d11, d7
1000067c:	ed90 bb16 	vldr	d11, [r0, #88]	@ 0x58
10000680:	ed9d ab02 	vldr	d10, [sp, #8]
10000684:	ee30 0b09 	vadd.f64	d0, d0, d9
10000688:	ee2e 9b47 	vnmul.f64	d9, d14, d7
1000068c:	eeaa 9b0b 	vfma.f64	d9, d10, d11
10000690:	ee22 ab05 	vmul.f64	d10, d2, d5
10000694:	ed9d db06 	vldr	d13, [sp, #24]
10000698:	ee33 3b41 	vsub.f64	d3, d3, d1
1000069c:	eefc bbca 	vcvt.u32.f64	s23, d10
100006a0:	ee2c ab05 	vmul.f64	d10, d12, d5
100006a4:	ee39 9b07 	vadd.f64	d9, d9, d7
100006a8:	eebc bbca 	vcvt.u32.f64	s22, d10
100006ac:	eeb8 ab6b 	vcvt.f64.u32	d10, s23
100006b0:	ee0a 2b47 	vmls.f64	d2, d10, d7
100006b4:	ee3d ab0a 	vadd.f64	d10, d13, d10
100006b8:	ee33 3b02 	vadd.f64	d3, d3, d2
100006bc:	eeb8 2b4b 	vcvt.f64.u32	d2, s22
100006c0:	eeb0 bb4c 	vmov.f64	d11, d12
100006c4:	ee34 4b02 	vadd.f64	d4, d4, d2
100006c8:	ee02 bb47 	vmls.f64	d11, d2, d7
100006cc:	ee28 2b05 	vmul.f64	d2, d8, d5
100006d0:	ee29 cb05 	vmul.f64	d12, d9, d5
100006d4:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100006d8:	eebc cbcc 	vcvt.u32.f64	s24, d12
100006dc:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100006e0:	ee02 8b47 	vmls.f64	d8, d2, d7
100006e4:	ee30 0b02 	vadd.f64	d0, d0, d2
100006e8:	eeb8 2b4c 	vcvt.f64.u32	d2, s24
100006ec:	ee02 9b47 	vmls.f64	d9, d2, d7
100006f0:	ee3e 2b02 	vadd.f64	d2, d14, d2
100006f4:	ee33 3b09 	vadd.f64	d3, d3, d9
100006f8:	ed9f 9b2f 	vldr	d9, [pc, #188]	@ 100007b8 <fp64e_cmul_prepared+0x450>
100006fc:	ed90 cb02 	vldr	d12, [r0, #8]
10000700:	ee32 2b41 	vsub.f64	d2, d2, d1
10000704:	ee3a ab41 	vsub.f64	d10, d10, d1
10000708:	ee34 4b09 	vadd.f64	d4, d4, d9
1000070c:	ee3a ab02 	vadd.f64	d10, d10, d2
10000710:	ed9d 2b14 	vldr	d2, [sp, #80]	@ 0x50
10000714:	ee36 6b07 	vadd.f64	d6, d6, d7
10000718:	ee30 0b09 	vadd.f64	d0, d0, d9
1000071c:	ee02 4b4c 	vmls.f64	d4, d2, d12
10000720:	ed9d 2b18 	vldr	d2, [sp, #96]	@ 0x60
10000724:	ed90 cb0c 	vldr	d12, [r0, #48]	@ 0x30
10000728:	ee02 0b4c 	vmls.f64	d0, d2, d12
1000072c:	ed90 2b08 	vldr	d2, [r0, #32]
10000730:	ed9d db04 	vldr	d13, [sp, #16]
10000734:	ee26 cb05 	vmul.f64	d12, d6, d5
10000738:	eebc cbcc 	vcvt.u32.f64	s24, d12
1000073c:	eeb8 cb4c 	vcvt.f64.u32	d12, s24
10000740:	ee0d 4b42 	vmls.f64	d4, d13, d2
10000744:	ee0c 6b47 	vmls.f64	d6, d12, d7
10000748:	ed90 2b12 	vldr	d2, [r0, #72]	@ 0x48
1000074c:	ee0f 0b42 	vmls.f64	d0, d15, d2
10000750:	ee36 6b0a 	vadd.f64	d6, d6, d10
10000754:	ee24 ab05 	vmul.f64	d10, d4, d5
10000758:	ee23 2b05 	vmul.f64	d2, d3, d5
1000075c:	eebc abca 	vcvt.u32.f64	s20, d10
10000760:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10000764:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10000768:	eeb8 2b42 	vcvt.f64.u32	d2, s4
1000076c:	ee0a 4b47 	vmls.f64	d4, d10, d7
10000770:	ee36 6b02 	vadd.f64	d6, d6, d2
10000774:	ee20 ab05 	vmul.f64	d10, d0, d5
10000778:	ee36 6b09 	vadd.f64	d6, d6, d9
1000077c:	ee02 3b47 	vmls.f64	d3, d2, d7
10000780:	ed9d 2b1a 	vldr	d2, [sp, #104]	@ 0x68
10000784:	eebc abca 	vcvt.u32.f64	s20, d10
10000788:	ed90 9b16 	vldr	d9, [r0, #88]	@ 0x58
1000078c:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10000790:	ee02 6b49 	vmls.f64	d6, d2, d9
10000794:	ee38 2b0b 	vadd.f64	d2, d8, d11
10000798:	ee0a 0b47 	vmls.f64	d0, d10, d7
1000079c:	ee3b 9b07 	vadd.f64	d9, d11, d7
100007a0:	ee22 ab05 	vmul.f64	d10, d2, d5
100007a4:	e00c      	b.n	100007c0 <fp64e_cmul_prepared+0x458>
100007a6:	bf00      	nop
100007a8:	00000000 	.word	0x00000000
100007ac:	3df00000 	.word	0x3df00000
100007b0:	00000000 	.word	0x00000000
100007b4:	41f00000 	.word	0x41f00000
100007b8:	00000000 	.word	0x00000000
100007bc:	42000000 	.word	0x42000000
100007c0:	eebc abca 	vcvt.u32.f64	s20, d10
100007c4:	ee39 9b48 	vsub.f64	d9, d9, d8
100007c8:	ed90 8b1c 	vldr	d8, [r0, #112]	@ 0x70
100007cc:	ed9d bb00 	vldr	d11, [sp]
100007d0:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
100007d4:	ee0b 6b48 	vmls.f64	d6, d11, d8
100007d8:	ee0a 2b47 	vmls.f64	d2, d10, d7
100007dc:	ee33 3b07 	vadd.f64	d3, d3, d7
100007e0:	ee30 8b04 	vadd.f64	d8, d0, d4
100007e4:	ee33 3b42 	vsub.f64	d3, d3, d2
100007e8:	ee38 8b0a 	vadd.f64	d8, d8, d10
100007ec:	ee26 2b05 	vmul.f64	d2, d6, d5
100007f0:	ee34 4b07 	vadd.f64	d4, d4, d7
100007f4:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100007f8:	ee34 0b40 	vsub.f64	d0, d4, d0
100007fc:	ee28 4b05 	vmul.f64	d4, d8, d5
10000800:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10000804:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10000808:	ee02 6b47 	vmls.f64	d6, d2, d7
1000080c:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10000810:	ee36 2b07 	vadd.f64	d2, d6, d7
10000814:	ee04 8b47 	vmls.f64	d8, d4, d7
10000818:	ee29 6b05 	vmul.f64	d6, d9, d5
1000081c:	ee23 4b05 	vmul.f64	d4, d3, d5
10000820:	ee32 2b48 	vsub.f64	d2, d2, d8
10000824:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10000828:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000082c:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10000830:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10000834:	ee30 0b41 	vsub.f64	d0, d0, d1
10000838:	ee32 2b41 	vsub.f64	d2, d2, d1
1000083c:	ee30 0b06 	vadd.f64	d0, d0, d6
10000840:	ee32 2b04 	vadd.f64	d2, d2, d4
10000844:	eeb0 1b49 	vmov.f64	d1, d9
10000848:	ee04 3b47 	vmls.f64	d3, d4, d7
1000084c:	ee06 1b47 	vmls.f64	d1, d6, d7
10000850:	ee20 6b05 	vmul.f64	d6, d0, d5
10000854:	ee22 5b05 	vmul.f64	d5, d2, d5
10000858:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000085c:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10000860:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10000864:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10000868:	ee06 0b47 	vmls.f64	d0, d6, d7
1000086c:	ee05 2b47 	vmls.f64	d2, d5, d7
10000870:	b034      	add	sp, #208	@ 0xd0
10000872:	ecbd 8b10 	vpop	{d8-d15}
10000876:	4770      	bx	lr

