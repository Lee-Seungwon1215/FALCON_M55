
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_kat_exact/validation/build/compat-perf/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10006680 <fndsa_vect_inv_mul2e_fft_fp64_exact>:
10006680:	b5f0      	push	{r4, r5, r6, r7, lr}
10006682:	2701      	movs	r7, #1
10006684:	fa07 f202 	lsl.w	r2, r7, r2
10006688:	ee07 2a90 	vmov	s15, r2
1000668c:	2410      	movs	r4, #16
1000668e:	ed2d 8b10 	vpush	{d8-d15}
10006692:	2600      	movs	r6, #0
10006694:	ed9f ab70 	vldr	d10, [pc, #448]	@ 10006858 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x1d8>
10006698:	ed9f db71 	vldr	d13, [pc, #452]	@ 10006860 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x1e0>
1000669c:	460d      	mov	r5, r1
1000669e:	eeb8 cb67 	vcvt.f64.u32	d12, s15
100066a2:	3801      	subs	r0, #1
100066a4:	4084      	lsls	r4, r0
100066a6:	b095      	sub	sp, #84	@ 0x54
100066a8:	4087      	lsls	r7, r0
100066aa:	440c      	add	r4, r1
100066ac:	ed94 8b02 	vldr	d8, [r4, #8]
100066b0:	ee3a 8b48 	vsub.f64	d8, d10, d8
100066b4:	ed94 9b00 	vldr	d9, [r4]
100066b8:	ee28 7b0d 	vmul.f64	d7, d8, d13
100066bc:	eeb7 6b00 	vmov.f64	d6, #112	@ 0x3f800000  1.0
100066c0:	ee3a 9b49 	vsub.f64	d9, d10, d9
100066c4:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100066c8:	ee39 9b46 	vsub.f64	d9, d9, d6
100066cc:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100066d0:	ee39 9b07 	vadd.f64	d9, d9, d7
100066d4:	ee07 8b4a 	vmls.f64	d8, d7, d10
100066d8:	ee29 7b0d 	vmul.f64	d7, d9, d13
100066dc:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100066e0:	ed95 eb00 	vldr	d14, [r5]
100066e4:	ed95 bb02 	vldr	d11, [r5, #8]
100066e8:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100066ec:	eeb0 1b4b 	vmov.f64	d1, d11
100066f0:	eeb0 3b4b 	vmov.f64	d3, d11
100066f4:	eeb0 0b4e 	vmov.f64	d0, d14
100066f8:	eeb0 2b4e 	vmov.f64	d2, d14
100066fc:	ee07 9b4a 	vmls.f64	d9, d7, d10
10006700:	ed8d bb06 	vstr	d11, [sp, #24]
10006704:	ed8d eb04 	vstr	d14, [sp, #16]
10006708:	f7ff fee2 	bl	100064d0 <fndsa_fp64e_mul>
1000670c:	ee2b bb0c 	vmul.f64	d11, d11, d12
10006710:	eeb0 7b41 	vmov.f64	d7, d1
10006714:	eeb0 fb40 	vmov.f64	d15, d0
10006718:	eeb0 1b48 	vmov.f64	d1, d8
1000671c:	eeb0 2b49 	vmov.f64	d2, d9
10006720:	eeb0 3b48 	vmov.f64	d3, d8
10006724:	eeb0 0b49 	vmov.f64	d0, d9
10006728:	ed8d fb0c 	vstr	d15, [sp, #48]	@ 0x30
1000672c:	ed8d 7b0e 	vstr	d7, [sp, #56]	@ 0x38
10006730:	ed8d 7b00 	vstr	d7, [sp]
10006734:	ed8d 8b0a 	vstr	d8, [sp, #40]	@ 0x28
10006738:	ed8d 9b08 	vstr	d9, [sp, #32]
1000673c:	f7ff fec8 	bl	100064d0 <fndsa_fp64e_mul>
10006740:	ed9d 7b00 	vldr	d7, [sp]
10006744:	ee2b 5b0d 	vmul.f64	d5, d11, d13
10006748:	ee37 7b01 	vadd.f64	d7, d7, d1
1000674c:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10006750:	ee27 6b0d 	vmul.f64	d6, d7, d13
10006754:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10006758:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000675c:	eeb0 4b45 	vmov.f64	d4, d5
10006760:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006764:	ee0e 4b0c 	vmla.f64	d4, d14, d12
10006768:	ee05 bb4a 	vmls.f64	d11, d5, d10
1000676c:	ee3f fb00 	vadd.f64	d15, d15, d0
10006770:	ee06 7b4a 	vmls.f64	d7, d6, d10
10006774:	ee3f 5b06 	vadd.f64	d5, d15, d6
10006778:	ee24 3b0d 	vmul.f64	d3, d4, d13
1000677c:	eefc 6bcb 	vcvt.u32.f64	s13, d11
10006780:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006784:	ee16 0a90 	vmov	r0, s13
10006788:	ee25 6b0d 	vmul.f64	d6, d5, d13
1000678c:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10006790:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006794:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10006798:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000679c:	ee03 4b4a 	vmls.f64	d4, d3, d10
100067a0:	ee06 5b4a 	vmls.f64	d5, d6, d10
100067a4:	ee17 2a90 	vmov	r2, s15
100067a8:	edcd 7a03 	vstr	s15, [sp, #12]
100067ac:	eefc 7bc4 	vcvt.u32.f64	s15, d4
100067b0:	ee17 1a90 	vmov	r1, s15
100067b4:	eefc 7bc5 	vcvt.u32.f64	s15, d5
100067b8:	ee17 3a90 	vmov	r3, s15
100067bc:	edcd 7a00 	vstr	s15, [sp]
100067c0:	ed8d 0b10 	vstr	d0, [sp, #64]	@ 0x40
100067c4:	ed8d 1b12 	vstr	d1, [sp, #72]	@ 0x48
100067c8:	f7ff fcaa 	bl	10006120 <fxr_div_fp64_exact>
100067cc:	ee2c 8b08 	vmul.f64	d8, d12, d8
100067d0:	ee28 7b0d 	vmul.f64	d7, d8, d13
100067d4:	ee06 1a10 	vmov	s12, r1
100067d8:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100067dc:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100067e0:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100067e4:	ed85 6b00 	vstr	d6, [r5]
100067e8:	eeb0 6b47 	vmov.f64	d6, d7
100067ec:	ee0c 6b09 	vmla.f64	d6, d12, d9
100067f0:	ee07 8b4a 	vmls.f64	d8, d7, d10
100067f4:	ee26 7b0d 	vmul.f64	d7, d6, d13
100067f8:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100067fc:	ee05 0a10 	vmov	s10, r0
10006800:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006804:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10006808:	ee07 6b4a 	vmls.f64	d6, d7, d10
1000680c:	ed85 5b02 	vstr	d5, [r5, #8]
10006810:	eefc 7bc6 	vcvt.u32.f64	s15, d6
10006814:	eefc 5bc8 	vcvt.u32.f64	s11, d8
10006818:	ee17 1a90 	vmov	r1, s15
1000681c:	ee15 0a90 	vmov	r0, s11
10006820:	9a03      	ldr	r2, [sp, #12]
10006822:	9b00      	ldr	r3, [sp, #0]
10006824:	f7ff fc7c 	bl	10006120 <fxr_div_fp64_exact>
10006828:	ee06 0a10 	vmov	s12, r0
1000682c:	ee07 1a10 	vmov	s14, r1
10006830:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006834:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006838:	3601      	adds	r6, #1
1000683a:	42b7      	cmp	r7, r6
1000683c:	f104 0410 	add.w	r4, r4, #16
10006840:	f105 0510 	add.w	r5, r5, #16
10006844:	ed04 6b02 	vstr	d6, [r4, #-8]
10006848:	ed04 7b04 	vstr	d7, [r4, #-16]
1000684c:	f47f af2e 	bne.w	100066ac <fndsa_vect_inv_mul2e_fft_fp64_exact+0x2c>
10006850:	b015      	add	sp, #84	@ 0x54
10006852:	ecbd 8b10 	vpop	{d8-d15}
10006856:	bdf0      	pop	{r4, r5, r6, r7, pc}
10006858:	00000000 	.word	0x00000000
1000685c:	41f00000 	.word	0x41f00000
10006860:	00000000 	.word	0x00000000
10006864:	3df00000 	.word	0x3df00000
