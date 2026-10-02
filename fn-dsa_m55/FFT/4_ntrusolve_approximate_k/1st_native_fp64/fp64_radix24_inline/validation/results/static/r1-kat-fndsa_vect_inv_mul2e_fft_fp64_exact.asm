
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/r1-kat/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

100051a8 <fndsa_vect_inv_mul2e_fft_fp64_exact>:
100051a8:	b5f0      	push	{r4, r5, r6, r7, lr}
100051aa:	2701      	movs	r7, #1
100051ac:	fa07 f202 	lsl.w	r2, r7, r2
100051b0:	ee07 2a90 	vmov	s15, r2
100051b4:	2410      	movs	r4, #16
100051b6:	ed2d 8b10 	vpush	{d8-d15}
100051ba:	2600      	movs	r6, #0
100051bc:	ed9f ab70 	vldr	d10, [pc, #448]	@ 10005380 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x1d8>
100051c0:	ed9f db71 	vldr	d13, [pc, #452]	@ 10005388 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x1e0>
100051c4:	460d      	mov	r5, r1
100051c6:	eeb8 cb67 	vcvt.f64.u32	d12, s15
100051ca:	3801      	subs	r0, #1
100051cc:	4084      	lsls	r4, r0
100051ce:	b095      	sub	sp, #84	@ 0x54
100051d0:	4087      	lsls	r7, r0
100051d2:	440c      	add	r4, r1
100051d4:	ed94 8b02 	vldr	d8, [r4, #8]
100051d8:	ee3a 8b48 	vsub.f64	d8, d10, d8
100051dc:	ed94 9b00 	vldr	d9, [r4]
100051e0:	ee28 7b0d 	vmul.f64	d7, d8, d13
100051e4:	eeb7 6b00 	vmov.f64	d6, #112	@ 0x3f800000  1.0
100051e8:	ee3a 9b49 	vsub.f64	d9, d10, d9
100051ec:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100051f0:	ee39 9b46 	vsub.f64	d9, d9, d6
100051f4:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100051f8:	ee39 9b07 	vadd.f64	d9, d9, d7
100051fc:	ee07 8b4a 	vmls.f64	d8, d7, d10
10005200:	ee29 7b0d 	vmul.f64	d7, d9, d13
10005204:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005208:	ed95 eb00 	vldr	d14, [r5]
1000520c:	ed95 bb02 	vldr	d11, [r5, #8]
10005210:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005214:	eeb0 1b4b 	vmov.f64	d1, d11
10005218:	eeb0 3b4b 	vmov.f64	d3, d11
1000521c:	eeb0 0b4e 	vmov.f64	d0, d14
10005220:	eeb0 2b4e 	vmov.f64	d2, d14
10005224:	ee07 9b4a 	vmls.f64	d9, d7, d10
10005228:	ed8d bb06 	vstr	d11, [sp, #24]
1000522c:	ed8d eb04 	vstr	d14, [sp, #16]
10005230:	f7ff fed6 	bl	10004fe0 <fndsa_fp64e_mul>
10005234:	ee2b bb0c 	vmul.f64	d11, d11, d12
10005238:	eeb0 7b41 	vmov.f64	d7, d1
1000523c:	eeb0 fb40 	vmov.f64	d15, d0
10005240:	eeb0 1b48 	vmov.f64	d1, d8
10005244:	eeb0 2b49 	vmov.f64	d2, d9
10005248:	eeb0 3b48 	vmov.f64	d3, d8
1000524c:	eeb0 0b49 	vmov.f64	d0, d9
10005250:	ed8d fb0c 	vstr	d15, [sp, #48]	@ 0x30
10005254:	ed8d 7b0e 	vstr	d7, [sp, #56]	@ 0x38
10005258:	ed8d 7b00 	vstr	d7, [sp]
1000525c:	ed8d 8b0a 	vstr	d8, [sp, #40]	@ 0x28
10005260:	ed8d 9b08 	vstr	d9, [sp, #32]
10005264:	f7ff febc 	bl	10004fe0 <fndsa_fp64e_mul>
10005268:	ed9d 7b00 	vldr	d7, [sp]
1000526c:	ee2b 5b0d 	vmul.f64	d5, d11, d13
10005270:	ee37 7b01 	vadd.f64	d7, d7, d1
10005274:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10005278:	ee27 6b0d 	vmul.f64	d6, d7, d13
1000527c:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10005280:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10005284:	eeb0 4b45 	vmov.f64	d4, d5
10005288:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000528c:	ee0e 4b0c 	vmla.f64	d4, d14, d12
10005290:	ee05 bb4a 	vmls.f64	d11, d5, d10
10005294:	ee3f fb00 	vadd.f64	d15, d15, d0
10005298:	ee06 7b4a 	vmls.f64	d7, d6, d10
1000529c:	ee3f 5b06 	vadd.f64	d5, d15, d6
100052a0:	ee24 3b0d 	vmul.f64	d3, d4, d13
100052a4:	eefc 6bcb 	vcvt.u32.f64	s13, d11
100052a8:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100052ac:	ee16 0a90 	vmov	r0, s13
100052b0:	ee25 6b0d 	vmul.f64	d6, d5, d13
100052b4:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100052b8:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100052bc:	eefc 7bc7 	vcvt.u32.f64	s15, d7
100052c0:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100052c4:	ee03 4b4a 	vmls.f64	d4, d3, d10
100052c8:	ee06 5b4a 	vmls.f64	d5, d6, d10
100052cc:	ee17 2a90 	vmov	r2, s15
100052d0:	edcd 7a03 	vstr	s15, [sp, #12]
100052d4:	eefc 7bc4 	vcvt.u32.f64	s15, d4
100052d8:	ee17 1a90 	vmov	r1, s15
100052dc:	eefc 7bc5 	vcvt.u32.f64	s15, d5
100052e0:	ee17 3a90 	vmov	r3, s15
100052e4:	edcd 7a00 	vstr	s15, [sp]
100052e8:	ed8d 0b10 	vstr	d0, [sp, #64]	@ 0x40
100052ec:	ed8d 1b12 	vstr	d1, [sp, #72]	@ 0x48
100052f0:	f7ff fc9e 	bl	10004c30 <fxr_div_fp64_exact>
100052f4:	ee2c 8b08 	vmul.f64	d8, d12, d8
100052f8:	ee28 7b0d 	vmul.f64	d7, d8, d13
100052fc:	ee06 1a10 	vmov	s12, r1
10005300:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005304:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005308:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000530c:	ed85 6b00 	vstr	d6, [r5]
10005310:	eeb0 6b47 	vmov.f64	d6, d7
10005314:	ee0c 6b09 	vmla.f64	d6, d12, d9
10005318:	ee07 8b4a 	vmls.f64	d8, d7, d10
1000531c:	ee26 7b0d 	vmul.f64	d7, d6, d13
10005320:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005324:	ee05 0a10 	vmov	s10, r0
10005328:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000532c:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10005330:	ee07 6b4a 	vmls.f64	d6, d7, d10
10005334:	ed85 5b02 	vstr	d5, [r5, #8]
10005338:	eefc 7bc6 	vcvt.u32.f64	s15, d6
1000533c:	eefc 5bc8 	vcvt.u32.f64	s11, d8
10005340:	ee17 1a90 	vmov	r1, s15
10005344:	ee15 0a90 	vmov	r0, s11
10005348:	9a03      	ldr	r2, [sp, #12]
1000534a:	9b00      	ldr	r3, [sp, #0]
1000534c:	f7ff fc70 	bl	10004c30 <fxr_div_fp64_exact>
10005350:	ee06 0a10 	vmov	s12, r0
10005354:	ee07 1a10 	vmov	s14, r1
10005358:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000535c:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005360:	3601      	adds	r6, #1
10005362:	42b7      	cmp	r7, r6
10005364:	f104 0410 	add.w	r4, r4, #16
10005368:	f105 0510 	add.w	r5, r5, #16
1000536c:	ed04 6b02 	vstr	d6, [r4, #-8]
10005370:	ed04 7b04 	vstr	d7, [r4, #-16]
10005374:	f47f af2e 	bne.w	100051d4 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x2c>
10005378:	b015      	add	sp, #84	@ 0x54
1000537a:	ecbd 8b10 	vpop	{d8-d15}
1000537e:	bdf0      	pop	{r4, r5, r6, r7, pc}
10005380:	00000000 	.word	0x00000000
10005384:	41f00000 	.word	0x41f00000
10005388:	00000000 	.word	0x00000000
1000538c:	3df00000 	.word	0x3df00000
