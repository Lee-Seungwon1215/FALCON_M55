10006468 <fndsa_vect_FFT_fp64_exact>:
10006468:	2801      	cmp	r0, #1
1000646a:	f240 815a 	bls.w	10006722 <fndsa_vect_FFT_fp64_exact+0x2ba>
1000646e:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10006472:	460f      	mov	r7, r1
10006474:	2101      	movs	r1, #1
10006476:	ed2d 8b10 	vpush	{d8-d15}
1000647a:	2210      	movs	r2, #16
1000647c:	ed9f 9baa 	vldr	d9, [pc, #680]	@ 10006728 <fndsa_vect_FFT_fp64_exact+0x2c0>
10006480:	ed9f 8bab 	vldr	d8, [pc, #684]	@ 10006730 <fndsa_vect_FFT_fp64_exact+0x2c8>
10006484:	eeb7 eb00 	vmov.f64	d14, #112	@ 0x3f800000  1.0
10006488:	460c      	mov	r4, r1
1000648a:	1e43      	subs	r3, r0, #1
1000648c:	b0b1      	sub	sp, #196	@ 0xc4
1000648e:	9009      	str	r0, [sp, #36]	@ 0x24
10006490:	409a      	lsls	r2, r3
10006492:	fa01 f003 	lsl.w	r0, r1, r3
10006496:	f04f 0a10 	mov.w	sl, #16
1000649a:	2301      	movs	r3, #1
1000649c:	4ea6      	ldr	r6, [pc, #664]	@ (10006738 <fndsa_vect_FFT_fp64_exact+0x2d0>)
1000649e:	fa0a fa04 	lsl.w	sl, sl, r4
100064a2:	4680      	mov	r8, r0
100064a4:	0840      	lsrs	r0, r0, #1
100064a6:	eb07 1900 	add.w	r9, r7, r0, lsl #4
100064aa:	9005      	str	r0, [sp, #20]
100064ac:	eb0a 0006 	add.w	r0, sl, r6
100064b0:	9708      	str	r7, [sp, #32]
100064b2:	4693      	mov	fp, r2
100064b4:	46ba      	mov	sl, r7
100064b6:	2700      	movs	r7, #0
100064b8:	fa03 f504 	lsl.w	r5, r3, r4
100064bc:	eb05 0555 	add.w	r5, r5, r5, lsr #1
100064c0:	eb06 1505 	add.w	r5, r6, r5, lsl #4
100064c4:	e9cd 5406 	strd	r5, r4, [sp, #24]
100064c8:	edd0 7a00 	vldr	s15, [r0]
100064cc:	eeb8 1b67 	vcvt.f64.u32	d1, s15
100064d0:	edd0 7a02 	vldr	s15, [r0, #8]
100064d4:	eeb8 4b67 	vcvt.f64.u32	d4, s15
100064d8:	edd0 7a01 	vldr	s15, [r0, #4]
100064dc:	eeb8 2b67 	vcvt.f64.u32	d2, s15
100064e0:	edd0 7a03 	vldr	s15, [r0, #12]
100064e4:	6843      	ldr	r3, [r0, #4]
100064e6:	eeb8 3b67 	vcvt.f64.u32	d3, s15
100064ea:	0fdb      	lsrs	r3, r3, #31
100064ec:	ee06 3a10 	vmov	s12, r3
100064f0:	ee17 3a90 	vmov	r3, s15
100064f4:	0fdb      	lsrs	r3, r3, #31
100064f6:	ee07 3a10 	vmov	s14, r3
100064fa:	ee31 5b04 	vadd.f64	d5, d1, d4
100064fe:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10006502:	ee32 cb03 	vadd.f64	d12, d2, d3
10006506:	ed8d 7b24 	vstr	d7, [sp, #144]	@ 0x90
1000650a:	ee25 7b09 	vmul.f64	d7, d5, d9
1000650e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006512:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006516:	ee3c cb07 	vadd.f64	d12, d12, d7
1000651a:	ee07 5b48 	vmls.f64	d5, d7, d8
1000651e:	9b05      	ldr	r3, [sp, #20]
10006520:	ee2c 7b09 	vmul.f64	d7, d12, d9
10006524:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10006528:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000652c:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006530:	ee07 cb48 	vmls.f64	d12, d7, d8
10006534:	eebc 7bcc 	vcvt.u32.f64	s14, d12
10006538:	19d9      	adds	r1, r3, r7
1000653a:	ee17 3a10 	vmov	r3, s14
1000653e:	0fdb      	lsrs	r3, r3, #31
10006540:	ed8d 6b1a 	vstr	d6, [sp, #104]	@ 0x68
10006544:	ee07 3a10 	vmov	s14, r3
10006548:	ee25 6b09 	vmul.f64	d6, d5, d9
1000654c:	ee21 0b09 	vmul.f64	d0, d1, d9
10006550:	ed8d 1b14 	vstr	d1, [sp, #80]	@ 0x50
10006554:	ed8d 6b2c 	vstr	d6, [sp, #176]	@ 0xb0
10006558:	ee22 ab09 	vmul.f64	d10, d2, d9
1000655c:	ee24 1b09 	vmul.f64	d1, d4, d9
10006560:	ee23 bb09 	vmul.f64	d11, d3, d9
10006564:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10006568:	ee2c 6b09 	vmul.f64	d6, d12, d9
1000656c:	428f      	cmp	r7, r1
1000656e:	ed8d 2b12 	vstr	d2, [sp, #72]	@ 0x48
10006572:	ed8d 3b1c 	vstr	d3, [sp, #112]	@ 0x70
10006576:	ed8d 4b1e 	vstr	d4, [sp, #120]	@ 0x78
1000657a:	ed8d 0b18 	vstr	d0, [sp, #96]	@ 0x60
1000657e:	ed8d 1b22 	vstr	d1, [sp, #136]	@ 0x88
10006582:	ed8d ab16 	vstr	d10, [sp, #88]	@ 0x58
10006586:	ed8d bb20 	vstr	d11, [sp, #128]	@ 0x80
1000658a:	ed8d 5b28 	vstr	d5, [sp, #160]	@ 0xa0
1000658e:	ed8d cb26 	vstr	d12, [sp, #152]	@ 0x98
10006592:	ed8d 6b2a 	vstr	d6, [sp, #168]	@ 0xa8
10006596:	ed8d 7b2e 	vstr	d7, [sp, #184]	@ 0xb8
1000659a:	f080 80aa 	bcs.w	100066f2 <fndsa_vect_FFT_fp64_exact+0x28a>
1000659e:	464d      	mov	r5, r9
100065a0:	4654      	mov	r4, sl
100065a2:	eb0b 010a 	add.w	r1, fp, sl
100065a6:	eb0b 0609 	add.w	r6, fp, r9
100065aa:	9004      	str	r0, [sp, #16]
100065ac:	ed95 0b00 	vldr	d0, [r5]
100065b0:	ed96 2b00 	vldr	d2, [r6]
100065b4:	ed96 3b02 	vldr	d3, [r6, #8]
100065b8:	ed95 1b02 	vldr	d1, [r5, #8]
100065bc:	a812      	add	r0, sp, #72	@ 0x48
100065be:	f7ff fccb 	bl	10005f58 <fp64e_cmul_prepared>
100065c2:	ed94 db02 	vldr	d13, [r4, #8]
100065c6:	ee3d 7b01 	vadd.f64	d7, d13, d1
100065ca:	ed91 ab00 	vldr	d10, [r1]
100065ce:	ed91 cb02 	vldr	d12, [r1, #8]
100065d2:	ed94 bb00 	vldr	d11, [r4]
100065d6:	ed8d 1b0c 	vstr	d1, [sp, #48]	@ 0x30
100065da:	ee3c 6b03 	vadd.f64	d6, d12, d3
100065de:	ed8d 0b0a 	vstr	d0, [sp, #40]	@ 0x28
100065e2:	ed8d 2b0e 	vstr	d2, [sp, #56]	@ 0x38
100065e6:	ed8d 3b10 	vstr	d3, [sp, #64]	@ 0x40
100065ea:	ee3d 5b08 	vadd.f64	d5, d13, d8
100065ee:	ee3a db02 	vadd.f64	d13, d10, d2
100065f2:	ee3a ab08 	vadd.f64	d10, d10, d8
100065f6:	ee3b fb00 	vadd.f64	d15, d11, d0
100065fa:	ee3a ab42 	vsub.f64	d10, d10, d2
100065fe:	ee26 4b09 	vmul.f64	d4, d6, d9
10006602:	ee3c cb08 	vadd.f64	d12, d12, d8
10006606:	ee3b bb08 	vadd.f64	d11, d11, d8
1000660a:	ee35 1b41 	vsub.f64	d1, d5, d1
1000660e:	ee3b bb40 	vsub.f64	d11, d11, d0
10006612:	eebc 0bc4 	vcvt.u32.f64	s0, d4
10006616:	ee3c 2b43 	vsub.f64	d2, d12, d3
1000661a:	ee27 5b09 	vmul.f64	d5, d7, d9
1000661e:	ee3a 3b4e 	vsub.f64	d3, d10, d14
10006622:	eebc abc5 	vcvt.u32.f64	s20, d5
10006626:	ee22 cb09 	vmul.f64	d12, d2, d9
1000662a:	ed8d 3b02 	vstr	d3, [sp, #8]
1000662e:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10006632:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10006636:	ee21 3b09 	vmul.f64	d3, d1, d9
1000663a:	ee3b 5b4e 	vsub.f64	d5, d11, d14
1000663e:	ee0a 7b48 	vmls.f64	d7, d10, d8
10006642:	ed8d 5b00 	vstr	d5, [sp]
10006646:	ee00 6b48 	vmls.f64	d6, d0, d8
1000664a:	eebc 4bcc 	vcvt.u32.f64	s8, d12
1000664e:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006652:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10006656:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000665a:	eeb0 cb47 	vmov.f64	d12, d7
1000665e:	ee3d bb00 	vadd.f64	d11, d13, d0
10006662:	ed9d 7b00 	vldr	d7, [sp]
10006666:	eeb0 db46 	vmov.f64	d13, d6
1000666a:	ed9d 6b02 	vldr	d6, [sp, #8]
1000666e:	ee3f 5b0a 	vadd.f64	d5, d15, d10
10006672:	ee37 7b03 	vadd.f64	d7, d7, d3
10006676:	ee36 6b04 	vadd.f64	d6, d6, d4
1000667a:	ee25 0b09 	vmul.f64	d0, d5, d9
1000667e:	ee2b ab09 	vmul.f64	d10, d11, d9
10006682:	ee03 1b48 	vmls.f64	d1, d3, d8
10006686:	ee04 2b48 	vmls.f64	d2, d4, d8
1000668a:	ee27 3b09 	vmul.f64	d3, d7, d9
1000668e:	ee26 4b09 	vmul.f64	d4, d6, d9
10006692:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10006696:	eebc abca 	vcvt.u32.f64	s20, d10
1000669a:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000669e:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100066a2:	eeb8 0b40 	vcvt.f64.u32	d0, s0
100066a6:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
100066aa:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100066ae:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100066b2:	ee00 5b48 	vmls.f64	d5, d0, d8
100066b6:	ee0a bb48 	vmls.f64	d11, d10, d8
100066ba:	ee03 7b48 	vmls.f64	d7, d3, d8
100066be:	ee04 6b48 	vmls.f64	d6, d4, d8
100066c2:	3410      	adds	r4, #16
100066c4:	3110      	adds	r1, #16
100066c6:	3510      	adds	r5, #16
100066c8:	3610      	adds	r6, #16
100066ca:	45a1      	cmp	r9, r4
100066cc:	ed04 cb02 	vstr	d12, [r4, #-8]
100066d0:	ed04 5b04 	vstr	d5, [r4, #-16]
100066d4:	ed01 bb04 	vstr	d11, [r1, #-16]
100066d8:	ed01 db02 	vstr	d13, [r1, #-8]
100066dc:	ed05 1b02 	vstr	d1, [r5, #-8]
100066e0:	ed05 7b04 	vstr	d7, [r5, #-16]
100066e4:	ed06 6b04 	vstr	d6, [r6, #-16]
100066e8:	ed06 2b02 	vstr	d2, [r6, #-8]
100066ec:	f47f af5e 	bne.w	100065ac <fndsa_vect_FFT_fp64_exact+0x144>
100066f0:	9804      	ldr	r0, [sp, #16]
100066f2:	9b06      	ldr	r3, [sp, #24]
100066f4:	3010      	adds	r0, #16
100066f6:	4283      	cmp	r3, r0
100066f8:	4447      	add	r7, r8
100066fa:	eb0a 1a08 	add.w	sl, sl, r8, lsl #4
100066fe:	eb09 1908 	add.w	r9, r9, r8, lsl #4
10006702:	f47f aee1 	bne.w	100064c8 <fndsa_vect_FFT_fp64_exact+0x60>
10006706:	9c07      	ldr	r4, [sp, #28]
10006708:	9b09      	ldr	r3, [sp, #36]	@ 0x24
1000670a:	3401      	adds	r4, #1
1000670c:	42a3      	cmp	r3, r4
1000670e:	465a      	mov	r2, fp
10006710:	9805      	ldr	r0, [sp, #20]
10006712:	9f08      	ldr	r7, [sp, #32]
10006714:	f47f aebf 	bne.w	10006496 <fndsa_vect_FFT_fp64_exact+0x2e>
10006718:	b031      	add	sp, #196	@ 0xc4
1000671a:	ecbd 8b10 	vpop	{d8-d15}
1000671e:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10006722:	4770      	bx	lr
10006724:	f3af 8000 	nop.w
10006728:	00000000 	.word	0x00000000
1000672c:	3df00000 	.word	0x3df00000
10006730:	00000000 	.word	0x00000000
10006734:	41f00000 	.word	0x41f00000
10006738:	300039a0 	.word	0x300039a0
1000673c:	00000000 	.word	0x00000000

