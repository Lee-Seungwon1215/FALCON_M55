
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_kat_exact_inlineasm/validation/build/asm-profile/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

100064d0 <fndsa_vect_inv_mul2e_fft_fp64_exact>:
100064d0:	b5f0      	push	{r4, r5, r6, r7, lr}
100064d2:	2701      	movs	r7, #1
100064d4:	fa07 f202 	lsl.w	r2, r7, r2
100064d8:	ee07 2a90 	vmov	s15, r2
100064dc:	2410      	movs	r4, #16
100064de:	ed2d 8b10 	vpush	{d8-d15}
100064e2:	2600      	movs	r6, #0
100064e4:	ed9f ab70 	vldr	d10, [pc, #448]	@ 100066a8 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x1d8>
100064e8:	ed9f db71 	vldr	d13, [pc, #452]	@ 100066b0 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x1e0>
100064ec:	eeb7 fb00 	vmov.f64	d15, #112	@ 0x3f800000  1.0
100064f0:	460d      	mov	r5, r1
100064f2:	eeb8 cb67 	vcvt.f64.u32	d12, s15
100064f6:	3801      	subs	r0, #1
100064f8:	4084      	lsls	r4, r0
100064fa:	b093      	sub	sp, #76	@ 0x4c
100064fc:	4087      	lsls	r7, r0
100064fe:	440c      	add	r4, r1
10006500:	ed94 8b02 	vldr	d8, [r4, #8]
10006504:	ee3a 8b48 	vsub.f64	d8, d10, d8
10006508:	ed94 9b00 	vldr	d9, [r4]
1000650c:	ee28 7b0d 	vmul.f64	d7, d8, d13
10006510:	ee3a 9b49 	vsub.f64	d9, d10, d9
10006514:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006518:	ee39 9b4f 	vsub.f64	d9, d9, d15
1000651c:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006520:	ee39 9b07 	vadd.f64	d9, d9, d7
10006524:	ee07 8b4a 	vmls.f64	d8, d7, d10
10006528:	ee29 7b0d 	vmul.f64	d7, d9, d13
1000652c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006530:	ed95 eb00 	vldr	d14, [r5]
10006534:	ed95 bb02 	vldr	d11, [r5, #8]
10006538:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000653c:	eeb0 1b4b 	vmov.f64	d1, d11
10006540:	eeb0 3b4b 	vmov.f64	d3, d11
10006544:	eeb0 0b4e 	vmov.f64	d0, d14
10006548:	eeb0 2b4e 	vmov.f64	d2, d14
1000654c:	ee07 9b4a 	vmls.f64	d9, d7, d10
10006550:	ed8d bb04 	vstr	d11, [sp, #16]
10006554:	ed8d eb02 	vstr	d14, [sp, #8]
10006558:	f003 ff02 	bl	1000a360 <fndsa_fp64e_mul>
1000655c:	eeb0 7b40 	vmov.f64	d7, d0
10006560:	eeb0 6b41 	vmov.f64	d6, d1
10006564:	eeb0 2b49 	vmov.f64	d2, d9
10006568:	eeb0 1b48 	vmov.f64	d1, d8
1000656c:	eeb0 3b48 	vmov.f64	d3, d8
10006570:	eeb0 0b49 	vmov.f64	d0, d9
10006574:	ed8d 7b0a 	vstr	d7, [sp, #40]	@ 0x28
10006578:	ed8d 6b0c 	vstr	d6, [sp, #48]	@ 0x30
1000657c:	ed8d 8b08 	vstr	d8, [sp, #32]
10006580:	ed8d 9b06 	vstr	d9, [sp, #24]
10006584:	f003 feec 	bl	1000a360 <fndsa_fp64e_mul>
10006588:	ee2b bb0c 	vmul.f64	d11, d11, d12
1000658c:	ed9d 6b0c 	vldr	d6, [sp, #48]	@ 0x30
10006590:	ee2b 7b0d 	vmul.f64	d7, d11, d13
10006594:	ee36 6b01 	vadd.f64	d6, d6, d1
10006598:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000659c:	ee26 5b0d 	vmul.f64	d5, d6, d13
100065a0:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100065a4:	ed9d 3b0a 	vldr	d3, [sp, #40]	@ 0x28
100065a8:	eeb0 4b47 	vmov.f64	d4, d7
100065ac:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100065b0:	ee0e 4b0c 	vmla.f64	d4, d14, d12
100065b4:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100065b8:	ee33 3b00 	vadd.f64	d3, d3, d0
100065bc:	ee05 6b4a 	vmls.f64	d6, d5, d10
100065c0:	ee33 3b05 	vadd.f64	d3, d3, d5
100065c4:	ee24 5b0d 	vmul.f64	d5, d4, d13
100065c8:	ee07 bb4a 	vmls.f64	d11, d7, d10
100065cc:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100065d0:	ee23 7b0d 	vmul.f64	d7, d3, d13
100065d4:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100065d8:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100065dc:	ee05 4b4a 	vmls.f64	d4, d5, d10
100065e0:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100065e4:	eefc 6bc6 	vcvt.u32.f64	s13, d6
100065e8:	ee07 3b4a 	vmls.f64	d3, d7, d10
100065ec:	eefc 7bc4 	vcvt.u32.f64	s15, d4
100065f0:	ee16 2a90 	vmov	r2, s13
100065f4:	ee17 1a90 	vmov	r1, s15
100065f8:	eefc 6bcb 	vcvt.u32.f64	s13, d11
100065fc:	eefc 7bc3 	vcvt.u32.f64	s15, d3
10006600:	ee16 0a90 	vmov	r0, s13
10006604:	ee17 3a90 	vmov	r3, s15
10006608:	edcd 7a00 	vstr	s15, [sp]
1000660c:	9201      	str	r2, [sp, #4]
1000660e:	ed8d 0b0e 	vstr	d0, [sp, #56]	@ 0x38
10006612:	ed8d 1b10 	vstr	d1, [sp, #64]	@ 0x40
10006616:	f7ff fd83 	bl	10006120 <fxr_div_fp64_exact>
1000661a:	e9dd 3200 	ldrd	r3, r2, [sp]
1000661e:	ee2c 8b08 	vmul.f64	d8, d12, d8
10006622:	ee28 7b0d 	vmul.f64	d7, d8, d13
10006626:	ee06 1a10 	vmov	s12, r1
1000662a:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000662e:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006632:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006636:	ed85 6b00 	vstr	d6, [r5]
1000663a:	eeb0 6b47 	vmov.f64	d6, d7
1000663e:	ee0c 6b09 	vmla.f64	d6, d12, d9
10006642:	ee07 8b4a 	vmls.f64	d8, d7, d10
10006646:	ee26 7b0d 	vmul.f64	d7, d6, d13
1000664a:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000664e:	ee05 0a10 	vmov	s10, r0
10006652:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006656:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000665a:	ee07 6b4a 	vmls.f64	d6, d7, d10
1000665e:	ed85 5b02 	vstr	d5, [r5, #8]
10006662:	eefc 7bc6 	vcvt.u32.f64	s15, d6
10006666:	eefc 5bc8 	vcvt.u32.f64	s11, d8
1000666a:	ee17 1a90 	vmov	r1, s15
1000666e:	ee15 0a90 	vmov	r0, s11
10006672:	f7ff fd55 	bl	10006120 <fxr_div_fp64_exact>
10006676:	ee06 0a10 	vmov	s12, r0
1000667a:	ee07 1a10 	vmov	s14, r1
1000667e:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006682:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006686:	3601      	adds	r6, #1
10006688:	42b7      	cmp	r7, r6
1000668a:	f104 0410 	add.w	r4, r4, #16
1000668e:	f105 0510 	add.w	r5, r5, #16
10006692:	ed04 6b02 	vstr	d6, [r4, #-8]
10006696:	ed04 7b04 	vstr	d7, [r4, #-16]
1000669a:	f47f af31 	bne.w	10006500 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x30>
1000669e:	b013      	add	sp, #76	@ 0x4c
100066a0:	ecbd 8b10 	vpop	{d8-d15}
100066a4:	bdf0      	pop	{r4, r5, r6, r7, pc}
100066a6:	bf00      	nop
100066a8:	00000000 	.word	0x00000000
100066ac:	41f00000 	.word	0x41f00000
100066b0:	00000000 	.word	0x00000000
100066b4:	3df00000 	.word	0x3df00000
