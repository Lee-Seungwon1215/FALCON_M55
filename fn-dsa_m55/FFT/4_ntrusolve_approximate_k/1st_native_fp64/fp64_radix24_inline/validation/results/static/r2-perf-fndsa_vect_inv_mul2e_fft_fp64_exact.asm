
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/r2-perf/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10006828 <fndsa_vect_inv_mul2e_fft_fp64_exact>:
10006828:	b5f0      	push	{r4, r5, r6, r7, lr}
1000682a:	2701      	movs	r7, #1
1000682c:	fa07 f202 	lsl.w	r2, r7, r2
10006830:	ee07 2a90 	vmov	s15, r2
10006834:	2410      	movs	r4, #16
10006836:	ed2d 8b10 	vpush	{d8-d15}
1000683a:	2600      	movs	r6, #0
1000683c:	ed9f ab70 	vldr	d10, [pc, #448]	@ 10006a00 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x1d8>
10006840:	ed9f db71 	vldr	d13, [pc, #452]	@ 10006a08 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x1e0>
10006844:	460d      	mov	r5, r1
10006846:	eeb8 cb67 	vcvt.f64.u32	d12, s15
1000684a:	3801      	subs	r0, #1
1000684c:	4084      	lsls	r4, r0
1000684e:	b095      	sub	sp, #84	@ 0x54
10006850:	4087      	lsls	r7, r0
10006852:	440c      	add	r4, r1
10006854:	ed94 8b02 	vldr	d8, [r4, #8]
10006858:	ee3a 8b48 	vsub.f64	d8, d10, d8
1000685c:	ed94 9b00 	vldr	d9, [r4]
10006860:	ee28 7b0d 	vmul.f64	d7, d8, d13
10006864:	eeb7 6b00 	vmov.f64	d6, #112	@ 0x3f800000  1.0
10006868:	ee3a 9b49 	vsub.f64	d9, d10, d9
1000686c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006870:	ee39 9b46 	vsub.f64	d9, d9, d6
10006874:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006878:	ee39 9b07 	vadd.f64	d9, d9, d7
1000687c:	ee07 8b4a 	vmls.f64	d8, d7, d10
10006880:	ee29 7b0d 	vmul.f64	d7, d9, d13
10006884:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006888:	ed95 eb00 	vldr	d14, [r5]
1000688c:	ed95 bb02 	vldr	d11, [r5, #8]
10006890:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006894:	eeb0 1b4b 	vmov.f64	d1, d11
10006898:	eeb0 3b4b 	vmov.f64	d3, d11
1000689c:	eeb0 0b4e 	vmov.f64	d0, d14
100068a0:	eeb0 2b4e 	vmov.f64	d2, d14
100068a4:	ee07 9b4a 	vmls.f64	d9, d7, d10
100068a8:	ed8d bb06 	vstr	d11, [sp, #24]
100068ac:	ed8d eb04 	vstr	d14, [sp, #16]
100068b0:	f7ff fed6 	bl	10006660 <fndsa_fp64e_mul>
100068b4:	ee2b bb0c 	vmul.f64	d11, d11, d12
100068b8:	eeb0 7b41 	vmov.f64	d7, d1
100068bc:	eeb0 fb40 	vmov.f64	d15, d0
100068c0:	eeb0 1b48 	vmov.f64	d1, d8
100068c4:	eeb0 2b49 	vmov.f64	d2, d9
100068c8:	eeb0 3b48 	vmov.f64	d3, d8
100068cc:	eeb0 0b49 	vmov.f64	d0, d9
100068d0:	ed8d fb0c 	vstr	d15, [sp, #48]	@ 0x30
100068d4:	ed8d 7b0e 	vstr	d7, [sp, #56]	@ 0x38
100068d8:	ed8d 7b00 	vstr	d7, [sp]
100068dc:	ed8d 8b0a 	vstr	d8, [sp, #40]	@ 0x28
100068e0:	ed8d 9b08 	vstr	d9, [sp, #32]
100068e4:	f7ff febc 	bl	10006660 <fndsa_fp64e_mul>
100068e8:	ed9d 7b00 	vldr	d7, [sp]
100068ec:	ee2b 5b0d 	vmul.f64	d5, d11, d13
100068f0:	ee37 7b01 	vadd.f64	d7, d7, d1
100068f4:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100068f8:	ee27 6b0d 	vmul.f64	d6, d7, d13
100068fc:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10006900:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006904:	eeb0 4b45 	vmov.f64	d4, d5
10006908:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000690c:	ee0e 4b0c 	vmla.f64	d4, d14, d12
10006910:	ee05 bb4a 	vmls.f64	d11, d5, d10
10006914:	ee3f fb00 	vadd.f64	d15, d15, d0
10006918:	ee06 7b4a 	vmls.f64	d7, d6, d10
1000691c:	ee3f 5b06 	vadd.f64	d5, d15, d6
10006920:	ee24 3b0d 	vmul.f64	d3, d4, d13
10006924:	eefc 6bcb 	vcvt.u32.f64	s13, d11
10006928:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000692c:	ee16 0a90 	vmov	r0, s13
10006930:	ee25 6b0d 	vmul.f64	d6, d5, d13
10006934:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10006938:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000693c:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10006940:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006944:	ee03 4b4a 	vmls.f64	d4, d3, d10
10006948:	ee06 5b4a 	vmls.f64	d5, d6, d10
1000694c:	ee17 2a90 	vmov	r2, s15
10006950:	edcd 7a03 	vstr	s15, [sp, #12]
10006954:	eefc 7bc4 	vcvt.u32.f64	s15, d4
10006958:	ee17 1a90 	vmov	r1, s15
1000695c:	eefc 7bc5 	vcvt.u32.f64	s15, d5
10006960:	ee17 3a90 	vmov	r3, s15
10006964:	edcd 7a00 	vstr	s15, [sp]
10006968:	ed8d 0b10 	vstr	d0, [sp, #64]	@ 0x40
1000696c:	ed8d 1b12 	vstr	d1, [sp, #72]	@ 0x48
10006970:	f7ff fc9e 	bl	100062b0 <fxr_div_fp64_exact>
10006974:	ee2c 8b08 	vmul.f64	d8, d12, d8
10006978:	ee28 7b0d 	vmul.f64	d7, d8, d13
1000697c:	ee06 1a10 	vmov	s12, r1
10006980:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006984:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006988:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000698c:	ed85 6b00 	vstr	d6, [r5]
10006990:	eeb0 6b47 	vmov.f64	d6, d7
10006994:	ee0c 6b09 	vmla.f64	d6, d12, d9
10006998:	ee07 8b4a 	vmls.f64	d8, d7, d10
1000699c:	ee26 7b0d 	vmul.f64	d7, d6, d13
100069a0:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100069a4:	ee05 0a10 	vmov	s10, r0
100069a8:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100069ac:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100069b0:	ee07 6b4a 	vmls.f64	d6, d7, d10
100069b4:	ed85 5b02 	vstr	d5, [r5, #8]
100069b8:	eefc 7bc6 	vcvt.u32.f64	s15, d6
100069bc:	eefc 5bc8 	vcvt.u32.f64	s11, d8
100069c0:	ee17 1a90 	vmov	r1, s15
100069c4:	ee15 0a90 	vmov	r0, s11
100069c8:	9a03      	ldr	r2, [sp, #12]
100069ca:	9b00      	ldr	r3, [sp, #0]
100069cc:	f7ff fc70 	bl	100062b0 <fxr_div_fp64_exact>
100069d0:	ee06 0a10 	vmov	s12, r0
100069d4:	ee07 1a10 	vmov	s14, r1
100069d8:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100069dc:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100069e0:	3601      	adds	r6, #1
100069e2:	42b7      	cmp	r7, r6
100069e4:	f104 0410 	add.w	r4, r4, #16
100069e8:	f105 0510 	add.w	r5, r5, #16
100069ec:	ed04 6b02 	vstr	d6, [r4, #-8]
100069f0:	ed04 7b04 	vstr	d7, [r4, #-16]
100069f4:	f47f af2e 	bne.w	10006854 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x2c>
100069f8:	b015      	add	sp, #84	@ 0x54
100069fa:	ecbd 8b10 	vpop	{d8-d15}
100069fe:	bdf0      	pop	{r4, r5, r6, r7, pc}
10006a00:	00000000 	.word	0x00000000
10006a04:	41f00000 	.word	0x41f00000
10006a08:	00000000 	.word	0x00000000
10006a0c:	3df00000 	.word	0x3df00000
