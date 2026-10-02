10008370 <fndsa_vect_iFFT_fp64_exact>:
10008370:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10008374:	ed2d 8b10 	vpush	{d8-d15}
10008378:	1e45      	subs	r5, r0, #1
1000837a:	b0af      	sub	sp, #188	@ 0xbc
1000837c:	f000 825e 	beq.w	1000883c <fndsa_vect_iFFT_fp64_exact+0x4cc>
10008380:	2310      	movs	r3, #16
10008382:	f04f 0e01 	mov.w	lr, #1
10008386:	ed9f ebf8 	vldr	d14, [pc, #992]	@ 10008768 <fndsa_vect_iFFT_fp64_exact+0x3f8>
1000838a:	ed9f fbf9 	vldr	d15, [pc, #996]	@ 10008770 <fndsa_vect_iFFT_fp64_exact+0x400>
1000838e:	ed9f 9bfa 	vldr	d9, [pc, #1000]	@ 10008778 <fndsa_vect_iFFT_fp64_exact+0x408>
10008392:	fa03 fc05 	lsl.w	ip, r3, r5
10008396:	4672      	mov	r2, lr
10008398:	2301      	movs	r3, #1
1000839a:	f04f 0810 	mov.w	r8, #16
1000839e:	e9cd 2505 	strd	r2, r5, [sp, #20]
100083a2:	eb01 1702 	add.w	r7, r1, r2, lsl #4
100083a6:	eeb7 db00 	vmov.f64	d13, #112	@ 0x3f800000  1.0
100083aa:	460a      	mov	r2, r1
100083ac:	f04f 0b00 	mov.w	fp, #0
100083b0:	46e1      	mov	r9, ip
100083b2:	48f5      	ldr	r0, [pc, #980]	@ (10008788 <fndsa_vect_iFFT_fp64_exact+0x418>)
100083b4:	40ab      	lsls	r3, r5
100083b6:	eb03 0353 	add.w	r3, r3, r3, lsr #1
100083ba:	fa08 f805 	lsl.w	r8, r8, r5
100083be:	eb00 1303 	add.w	r3, r0, r3, lsl #4
100083c2:	eb08 0a00 	add.w	sl, r8, r0
100083c6:	9304      	str	r3, [sp, #16]
100083c8:	ea4f 0e4e 	mov.w	lr, lr, lsl #1
100083cc:	f8cd e00c 	str.w	lr, [sp, #12]
100083d0:	ea4f 180e 	mov.w	r8, lr, lsl #4
100083d4:	9107      	str	r1, [sp, #28]
100083d6:	edda 7a02 	vldr	s15, [sl, #8]
100083da:	f8da 3004 	ldr.w	r3, [sl, #4]
100083de:	eeb8 4b67 	vcvt.f64.u32	d4, s15
100083e2:	0fdb      	lsrs	r3, r3, #31
100083e4:	ee03 3a10 	vmov	s6, r3
100083e8:	ee3e 4b44 	vsub.f64	d4, d14, d4
100083ec:	edda 7a03 	vldr	s15, [sl, #12]
100083f0:	eeb8 3bc3 	vcvt.f64.s32	d3, s6
100083f4:	eeb8 7b67 	vcvt.f64.u32	d7, s15
100083f8:	ed8d 3b18 	vstr	d3, [sp, #96]	@ 0x60
100083fc:	ee24 3b0f 	vmul.f64	d3, d4, d15
10008400:	edda 6a00 	vldr	s13, [sl]
10008404:	ee3e 7b47 	vsub.f64	d7, d14, d7
10008408:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000840c:	eeb8 5b66 	vcvt.f64.u32	d5, s13
10008410:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10008414:	ee37 7b4d 	vsub.f64	d7, d7, d13
10008418:	ee37 7b03 	vadd.f64	d7, d7, d3
1000841c:	ee03 4b4e 	vmls.f64	d4, d3, d14
10008420:	edda 6a01 	vldr	s13, [sl, #4]
10008424:	ed8d 5b12 	vstr	d5, [sp, #72]	@ 0x48
10008428:	eeb8 6b66 	vcvt.f64.u32	d6, s13
1000842c:	ee27 3b0f 	vmul.f64	d3, d7, d15
10008430:	ee26 2b0f 	vmul.f64	d2, d6, d15
10008434:	ee25 1b0f 	vmul.f64	d1, d5, d15
10008438:	ed8d 2b14 	vstr	d2, [sp, #80]	@ 0x50
1000843c:	ed8d 4b1c 	vstr	d4, [sp, #112]	@ 0x70
10008440:	ed8d 6b10 	vstr	d6, [sp, #64]	@ 0x40
10008444:	9b05      	ldr	r3, [sp, #20]
10008446:	eb03 010b 	add.w	r1, r3, fp
1000844a:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000844e:	ee34 5b05 	vadd.f64	d5, d4, d5
10008452:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10008456:	ee24 2b0f 	vmul.f64	d2, d4, d15
1000845a:	ee03 7b4e 	vmls.f64	d7, d3, d14
1000845e:	ee25 4b0f 	vmul.f64	d4, d5, d15
10008462:	ed8d 7b1a 	vstr	d7, [sp, #104]	@ 0x68
10008466:	eefc 3bc7 	vcvt.u32.f64	s7, d7
1000846a:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000846e:	ee13 3a90 	vmov	r3, s7
10008472:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10008476:	ee37 6b06 	vadd.f64	d6, d7, d6
1000847a:	ee27 3b0f 	vmul.f64	d3, d7, d15
1000847e:	ee36 7b04 	vadd.f64	d7, d6, d4
10008482:	ee27 6b0f 	vmul.f64	d6, d7, d15
10008486:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000848a:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000848e:	ee06 7b4e 	vmls.f64	d7, d6, d14
10008492:	eefc 6bc7 	vcvt.u32.f64	s13, d7
10008496:	0fdb      	lsrs	r3, r3, #31
10008498:	ee04 5b4e 	vmls.f64	d5, d4, d14
1000849c:	ee04 3a10 	vmov	s8, r3
100084a0:	ee16 3a90 	vmov	r3, s13
100084a4:	0fdb      	lsrs	r3, r3, #31
100084a6:	ee27 6b0f 	vmul.f64	d6, d7, d15
100084aa:	ed8d 7b24 	vstr	d7, [sp, #144]	@ 0x90
100084ae:	ed8d 2b20 	vstr	d2, [sp, #128]	@ 0x80
100084b2:	ee07 3a10 	vmov	s14, r3
100084b6:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
100084ba:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100084be:	ee25 2b0f 	vmul.f64	d2, d5, d15
100084c2:	458b      	cmp	fp, r1
100084c4:	ed8d 1b16 	vstr	d1, [sp, #88]	@ 0x58
100084c8:	ed8d 3b1e 	vstr	d3, [sp, #120]	@ 0x78
100084cc:	ed8d 5b26 	vstr	d5, [sp, #152]	@ 0x98
100084d0:	ed8d 4b22 	vstr	d4, [sp, #136]	@ 0x88
100084d4:	ed8d 2b2a 	vstr	d2, [sp, #168]	@ 0xa8
100084d8:	ed8d 6b28 	vstr	d6, [sp, #160]	@ 0xa0
100084dc:	ed8d 7b2c 	vstr	d7, [sp, #176]	@ 0xb0
100084e0:	f080 819a 	bcs.w	10008818 <fndsa_vect_iFFT_fp64_exact+0x4a8>
100084e4:	463e      	mov	r6, r7
100084e6:	4611      	mov	r1, r2
100084e8:	eb09 0502 	add.w	r5, r9, r2
100084ec:	eb09 0407 	add.w	r4, r9, r7
100084f0:	9202      	str	r2, [sp, #8]
100084f2:	ed91 ab02 	vldr	d10, [r1, #8]
100084f6:	ee3a 0b0e 	vadd.f64	d0, d10, d14
100084fa:	ed96 7b02 	vldr	d7, [r6, #8]
100084fe:	ed91 cb00 	vldr	d12, [r1]
10008502:	ed96 3b00 	vldr	d3, [r6]
10008506:	ed95 bb02 	vldr	d11, [r5, #8]
1000850a:	ed94 5b02 	vldr	d5, [r4, #8]
1000850e:	ee3a ab07 	vadd.f64	d10, d10, d7
10008512:	ee30 7b47 	vsub.f64	d7, d0, d7
10008516:	ee3c 1b0e 	vadd.f64	d1, d12, d14
1000851a:	ee27 2b0f 	vmul.f64	d2, d7, d15
1000851e:	ee33 cb0c 	vadd.f64	d12, d3, d12
10008522:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10008526:	ee31 3b43 	vsub.f64	d3, d1, d3
1000852a:	eeb8 2b42 	vcvt.f64.u32	d2, s4
1000852e:	ee33 3b4d 	vsub.f64	d3, d3, d13
10008532:	ee02 7b4e 	vmls.f64	d7, d2, d14
10008536:	ee33 3b02 	vadd.f64	d3, d3, d2
1000853a:	ee37 7b0d 	vadd.f64	d7, d7, d13
1000853e:	ee23 1b0f 	vmul.f64	d1, d3, d15
10008542:	ee27 2b0f 	vmul.f64	d2, d7, d15
10008546:	eebc 1bc1 	vcvt.u32.f64	s2, d1
1000854a:	eefc 0bc2 	vcvt.u32.f64	s1, d2
1000854e:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10008552:	ee01 3b4e 	vmls.f64	d3, d1, d14
10008556:	ed9f 4b8a 	vldr	d4, [pc, #552]	@ 10008780 <fndsa_vect_iFFT_fp64_exact+0x410>
1000855a:	ed94 8b00 	vldr	d8, [r4]
1000855e:	ed95 6b00 	vldr	d6, [r5]
10008562:	ee3b 2b0e 	vadd.f64	d2, d11, d14
10008566:	ee35 bb0b 	vadd.f64	d11, d5, d11
1000856a:	ee32 2b45 	vsub.f64	d2, d2, d5
1000856e:	eeb8 5b60 	vcvt.f64.u32	d5, s1
10008572:	ee33 3b04 	vadd.f64	d3, d3, d4
10008576:	ee33 3b05 	vadd.f64	d3, d3, d5
1000857a:	ee36 4b0e 	vadd.f64	d4, d6, d14
1000857e:	ee23 0b0f 	vmul.f64	d0, d3, d15
10008582:	ee36 6b08 	vadd.f64	d6, d6, d8
10008586:	ee05 7b4e 	vmls.f64	d7, d5, d14
1000858a:	ee22 5b0f 	vmul.f64	d5, d2, d15
1000858e:	ed8d 6b00 	vstr	d6, [sp]
10008592:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10008596:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000859a:	eeb6 6b00 	vmov.f64	d6, #96	@ 0x3f000000  0.5
1000859e:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100085a2:	eeb8 0b40 	vcvt.f64.u32	d0, s0
100085a6:	ee05 2b4e 	vmls.f64	d2, d5, d14
100085aa:	ee27 7b06 	vmul.f64	d7, d7, d6
100085ae:	ee34 6b48 	vsub.f64	d6, d4, d8
100085b2:	ee00 3b4e 	vmls.f64	d3, d0, d14
100085b6:	ee36 6b4d 	vsub.f64	d6, d6, d13
100085ba:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100085be:	ee36 6b05 	vadd.f64	d6, d6, d5
100085c2:	eefc 5bc3 	vcvt.u32.f64	s11, d3
100085c6:	eeb8 1b47 	vcvt.f64.u32	d1, s14
100085ca:	ee15 3a90 	vmov	r3, s11
100085ce:	ee32 2b0d 	vadd.f64	d2, d2, d13
100085d2:	ee22 7b0f 	vmul.f64	d7, d2, d15
100085d6:	0fda      	lsrs	r2, r3, #31
100085d8:	eefc 3bc7 	vcvt.u32.f64	s7, d7
100085dc:	ee07 2a10 	vmov	s14, r2
100085e0:	085a      	lsrs	r2, r3, #1
100085e2:	ee00 2a10 	vmov	s0, r2
100085e6:	ee26 4b0f 	vmul.f64	d4, d6, d15
100085ea:	f003 0301 	and.w	r3, r3, #1
100085ee:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100085f2:	eeb8 0bc0 	vcvt.f64.s32	d0, s0
100085f6:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100085fa:	ee07 0b09 	vmla.f64	d0, d7, d9
100085fe:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10008602:	ee07 3a90 	vmov	s15, r3
10008606:	ee04 6b4e 	vmls.f64	d6, d4, d14
1000860a:	eeb8 7be7 	vcvt.f64.s32	d7, s15
1000860e:	eeb8 4b63 	vcvt.f64.u32	d4, s7
10008612:	ee07 1b09 	vmla.f64	d1, d7, d9
10008616:	ed9f 7b5a 	vldr	d7, [pc, #360]	@ 10008780 <fndsa_vect_iFFT_fp64_exact+0x410>
1000861a:	ee36 6b07 	vadd.f64	d6, d6, d7
1000861e:	ee2a 5b0f 	vmul.f64	d5, d10, d15
10008622:	ee36 7b04 	vadd.f64	d7, d6, d4
10008626:	ee04 2b4e 	vmls.f64	d2, d4, d14
1000862a:	ee27 4b0f 	vmul.f64	d4, d7, d15
1000862e:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10008632:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10008636:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000863a:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000863e:	eeb6 6b00 	vmov.f64	d6, #96	@ 0x3f000000  0.5
10008642:	ee04 7b4e 	vmls.f64	d7, d4, d14
10008646:	ee22 2b06 	vmul.f64	d2, d2, d6
1000864a:	ee3c 6b05 	vadd.f64	d6, d12, d5
1000864e:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10008652:	ee26 8b0f 	vmul.f64	d8, d6, d15
10008656:	ee05 ab4e 	vmls.f64	d10, d5, d14
1000865a:	eefc 7bc7 	vcvt.u32.f64	s15, d7
1000865e:	eeb8 3b42 	vcvt.f64.u32	d3, s4
10008662:	ee3a 5b0d 	vadd.f64	d5, d10, d13
10008666:	eebc 2bc8 	vcvt.u32.f64	s4, d8
1000866a:	ee17 3a90 	vmov	r3, s15
1000866e:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10008672:	ee25 4b0f 	vmul.f64	d4, d5, d15
10008676:	0fda      	lsrs	r2, r3, #31
10008678:	ee08 2a10 	vmov	s16, r2
1000867c:	085a      	lsrs	r2, r3, #1
1000867e:	ee02 6b4e 	vmls.f64	d6, d2, d14
10008682:	ed9f 7b3f 	vldr	d7, [pc, #252]	@ 10008780 <fndsa_vect_iFFT_fp64_exact+0x410>
10008686:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000868a:	ee36 6b07 	vadd.f64	d6, d6, d7
1000868e:	ee02 2a10 	vmov	s4, r2
10008692:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10008696:	eeb8 8bc8 	vcvt.f64.s32	d8, s16
1000869a:	eeb8 2bc2 	vcvt.f64.s32	d2, s4
1000869e:	eeb6 ab00 	vmov.f64	d10, #96	@ 0x3f000000  0.5
100086a2:	ee08 2b09 	vmla.f64	d2, d8, d9
100086a6:	ee2b 8b0f 	vmul.f64	d8, d11, d15
100086aa:	ee36 6b04 	vadd.f64	d6, d6, d4
100086ae:	ee04 5b4e 	vmls.f64	d5, d4, d14
100086b2:	ee25 5b0a 	vmul.f64	d5, d5, d10
100086b6:	f003 0301 	and.w	r3, r3, #1
100086ba:	ee07 3a90 	vmov	s15, r3
100086be:	eebc 8bc8 	vcvt.u32.f64	s16, d8
100086c2:	ee26 4b0f 	vmul.f64	d4, d6, d15
100086c6:	eeb8 8b48 	vcvt.f64.u32	d8, s16
100086ca:	eebc abc5 	vcvt.u32.f64	s20, d5
100086ce:	eeb8 7be7 	vcvt.f64.s32	d7, s15
100086d2:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100086d6:	ee07 3b09 	vmla.f64	d3, d7, d9
100086da:	ed9d 5b00 	vldr	d5, [sp]
100086de:	ee35 7b08 	vadd.f64	d7, d5, d8
100086e2:	eeb0 5b4b 	vmov.f64	d5, d11
100086e6:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100086ea:	ee08 5b4e 	vmls.f64	d5, d8, d14
100086ee:	ee27 cb0f 	vmul.f64	d12, d7, d15
100086f2:	ee04 6b4e 	vmls.f64	d6, d4, d14
100086f6:	ee35 5b0d 	vadd.f64	d5, d5, d13
100086fa:	eebc cbcc 	vcvt.u32.f64	s24, d12
100086fe:	eefc 6bc6 	vcvt.u32.f64	s13, d6
10008702:	ee25 4b0f 	vmul.f64	d4, d5, d15
10008706:	eeb8 cb4c 	vcvt.f64.u32	d12, s24
1000870a:	ee16 3a90 	vmov	r3, s13
1000870e:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10008712:	ed9f 6b1b 	vldr	d6, [pc, #108]	@ 10008780 <fndsa_vect_iFFT_fp64_exact+0x410>
10008716:	ee0c 7b4e 	vmls.f64	d7, d12, d14
1000871a:	0fda      	lsrs	r2, r3, #31
1000871c:	eeb8 bb4a 	vcvt.f64.u32	d11, s20
10008720:	ee0a 2a10 	vmov	s20, r2
10008724:	085a      	lsrs	r2, r3, #1
10008726:	ee37 7b06 	vadd.f64	d7, d7, d6
1000872a:	f003 0301 	and.w	r3, r3, #1
1000872e:	ee06 3a90 	vmov	s13, r3
10008732:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10008736:	eeb8 6be6 	vcvt.f64.s32	d6, s13
1000873a:	ee37 7b04 	vadd.f64	d7, d7, d4
1000873e:	ee06 bb09 	vmla.f64	d11, d6, d9
10008742:	ee27 6b0f 	vmul.f64	d6, d7, d15
10008746:	ee08 2a10 	vmov	s16, r2
1000874a:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000874e:	eeb8 abca 	vcvt.f64.s32	d10, s20
10008752:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10008756:	eeb8 8bc8 	vcvt.f64.s32	d8, s16
1000875a:	ee06 7b4e 	vmls.f64	d7, d6, d14
1000875e:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10008762:	ee04 5b4e 	vmls.f64	d5, d4, d14
10008766:	e011      	b.n	1000878c <fndsa_vect_iFFT_fp64_exact+0x41c>
10008768:	00000000 	.word	0x00000000
1000876c:	41f00000 	.word	0x41f00000
10008770:	00000000 	.word	0x00000000
10008774:	3df00000 	.word	0x3df00000
10008778:	00000000 	.word	0x00000000
1000877c:	41e00000 	.word	0x41e00000
	...
10008788:	300039a0 	.word	0x300039a0
1000878c:	ee0a 8b09 	vmla.f64	d8, d10, d9
10008790:	eeb6 ab00 	vmov.f64	d10, #96	@ 0x3f000000  0.5
10008794:	ee17 3a90 	vmov	r3, s15
10008798:	ee25 5b0a 	vmul.f64	d5, d5, d10
1000879c:	0fda      	lsrs	r2, r3, #31
1000879e:	ee04 2a10 	vmov	s8, r2
100087a2:	085a      	lsrs	r2, r3, #1
100087a4:	f003 0301 	and.w	r3, r3, #1
100087a8:	ee06 2a10 	vmov	s12, r2
100087ac:	ee07 3a90 	vmov	s15, r3
100087b0:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100087b4:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
100087b8:	eeb8 7be7 	vcvt.f64.s32	d7, s15
100087bc:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100087c0:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
100087c4:	ee07 5b09 	vmla.f64	d5, d7, d9
100087c8:	ed81 8b00 	vstr	d8, [r1]
100087cc:	ed81 bb02 	vstr	d11, [r1, #8]
100087d0:	ee04 6b09 	vmla.f64	d6, d4, d9
100087d4:	a810      	add	r0, sp, #64	@ 0x40
100087d6:	ed85 6b00 	vstr	d6, [r5]
100087da:	ed85 5b02 	vstr	d5, [r5, #8]
100087de:	f7ff f9d3 	bl	10007b88 <fp64e_cmul_prepared>
100087e2:	3110      	adds	r1, #16
100087e4:	428f      	cmp	r7, r1
100087e6:	ed86 0b00 	vstr	d0, [r6]
100087ea:	f105 0510 	add.w	r5, r5, #16
100087ee:	ed86 1b02 	vstr	d1, [r6, #8]
100087f2:	f106 0610 	add.w	r6, r6, #16
100087f6:	ed8d 0b08 	vstr	d0, [sp, #32]
100087fa:	ed84 2b00 	vstr	d2, [r4]
100087fe:	ed84 3b02 	vstr	d3, [r4, #8]
10008802:	f104 0410 	add.w	r4, r4, #16
10008806:	ed8d 1b0a 	vstr	d1, [sp, #40]	@ 0x28
1000880a:	ed8d 2b0c 	vstr	d2, [sp, #48]	@ 0x30
1000880e:	ed8d 3b0e 	vstr	d3, [sp, #56]	@ 0x38
10008812:	f47f ae6e 	bne.w	100084f2 <fndsa_vect_iFFT_fp64_exact+0x182>
10008816:	9a02      	ldr	r2, [sp, #8]
10008818:	9b03      	ldr	r3, [sp, #12]
1000881a:	f10a 0a10 	add.w	sl, sl, #16
1000881e:	449b      	add	fp, r3
10008820:	9b04      	ldr	r3, [sp, #16]
10008822:	4442      	add	r2, r8
10008824:	4553      	cmp	r3, sl
10008826:	4447      	add	r7, r8
10008828:	f47f add5 	bne.w	100083d6 <fndsa_vect_iFFT_fp64_exact+0x66>
1000882c:	9d06      	ldr	r5, [sp, #24]
1000882e:	46cc      	mov	ip, r9
10008830:	3d01      	subs	r5, #1
10008832:	f8dd e00c 	ldr.w	lr, [sp, #12]
10008836:	9907      	ldr	r1, [sp, #28]
10008838:	f47f adad 	bne.w	10008396 <fndsa_vect_iFFT_fp64_exact+0x26>
1000883c:	b02f      	add	sp, #188	@ 0xbc
1000883e:	ecbd 8b10 	vpop	{d8-d15}
10008842:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10008846:	bf00      	nop

