
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_kat_exact_inlineasm/validation/build/kat/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10004fe0 <fndsa_vect_inv_mul2e_fft_fp64_exact>:
10004fe0:	b5f0      	push	{r4, r5, r6, r7, lr}
10004fe2:	2701      	movs	r7, #1
10004fe4:	fa07 f202 	lsl.w	r2, r7, r2
10004fe8:	ee07 2a90 	vmov	s15, r2
10004fec:	2410      	movs	r4, #16
10004fee:	ed2d 8b10 	vpush	{d8-d15}
10004ff2:	2600      	movs	r6, #0
10004ff4:	ed9f ab70 	vldr	d10, [pc, #448]	@ 100051b8 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x1d8>
10004ff8:	ed9f db71 	vldr	d13, [pc, #452]	@ 100051c0 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x1e0>
10004ffc:	eeb7 fb00 	vmov.f64	d15, #112	@ 0x3f800000  1.0
10005000:	460d      	mov	r5, r1
10005002:	eeb8 cb67 	vcvt.f64.u32	d12, s15
10005006:	3801      	subs	r0, #1
10005008:	4084      	lsls	r4, r0
1000500a:	b093      	sub	sp, #76	@ 0x4c
1000500c:	4087      	lsls	r7, r0
1000500e:	440c      	add	r4, r1
10005010:	ed94 8b02 	vldr	d8, [r4, #8]
10005014:	ee3a 8b48 	vsub.f64	d8, d10, d8
10005018:	ed94 9b00 	vldr	d9, [r4]
1000501c:	ee28 7b0d 	vmul.f64	d7, d8, d13
10005020:	ee3a 9b49 	vsub.f64	d9, d10, d9
10005024:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005028:	ee39 9b4f 	vsub.f64	d9, d9, d15
1000502c:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005030:	ee39 9b07 	vadd.f64	d9, d9, d7
10005034:	ee07 8b4a 	vmls.f64	d8, d7, d10
10005038:	ee29 7b0d 	vmul.f64	d7, d9, d13
1000503c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005040:	ed95 eb00 	vldr	d14, [r5]
10005044:	ed95 bb02 	vldr	d11, [r5, #8]
10005048:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000504c:	eeb0 1b4b 	vmov.f64	d1, d11
10005050:	eeb0 3b4b 	vmov.f64	d3, d11
10005054:	eeb0 0b4e 	vmov.f64	d0, d14
10005058:	eeb0 2b4e 	vmov.f64	d2, d14
1000505c:	ee07 9b4a 	vmls.f64	d9, d7, d10
10005060:	ed8d bb04 	vstr	d11, [sp, #16]
10005064:	ed8d eb02 	vstr	d14, [sp, #8]
10005068:	f003 f9b4 	bl	100083d4 <fndsa_fp64e_mul>
1000506c:	eeb0 7b40 	vmov.f64	d7, d0
10005070:	eeb0 6b41 	vmov.f64	d6, d1
10005074:	eeb0 2b49 	vmov.f64	d2, d9
10005078:	eeb0 1b48 	vmov.f64	d1, d8
1000507c:	eeb0 3b48 	vmov.f64	d3, d8
10005080:	eeb0 0b49 	vmov.f64	d0, d9
10005084:	ed8d 7b0a 	vstr	d7, [sp, #40]	@ 0x28
10005088:	ed8d 6b0c 	vstr	d6, [sp, #48]	@ 0x30
1000508c:	ed8d 8b08 	vstr	d8, [sp, #32]
10005090:	ed8d 9b06 	vstr	d9, [sp, #24]
10005094:	f003 f99e 	bl	100083d4 <fndsa_fp64e_mul>
10005098:	ee2b bb0c 	vmul.f64	d11, d11, d12
1000509c:	ed9d 6b0c 	vldr	d6, [sp, #48]	@ 0x30
100050a0:	ee2b 7b0d 	vmul.f64	d7, d11, d13
100050a4:	ee36 6b01 	vadd.f64	d6, d6, d1
100050a8:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100050ac:	ee26 5b0d 	vmul.f64	d5, d6, d13
100050b0:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100050b4:	ed9d 3b0a 	vldr	d3, [sp, #40]	@ 0x28
100050b8:	eeb0 4b47 	vmov.f64	d4, d7
100050bc:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100050c0:	ee0e 4b0c 	vmla.f64	d4, d14, d12
100050c4:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100050c8:	ee33 3b00 	vadd.f64	d3, d3, d0
100050cc:	ee05 6b4a 	vmls.f64	d6, d5, d10
100050d0:	ee33 3b05 	vadd.f64	d3, d3, d5
100050d4:	ee24 5b0d 	vmul.f64	d5, d4, d13
100050d8:	ee07 bb4a 	vmls.f64	d11, d7, d10
100050dc:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100050e0:	ee23 7b0d 	vmul.f64	d7, d3, d13
100050e4:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100050e8:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100050ec:	ee05 4b4a 	vmls.f64	d4, d5, d10
100050f0:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100050f4:	eefc 6bc6 	vcvt.u32.f64	s13, d6
100050f8:	ee07 3b4a 	vmls.f64	d3, d7, d10
100050fc:	eefc 7bc4 	vcvt.u32.f64	s15, d4
10005100:	ee16 2a90 	vmov	r2, s13
10005104:	ee17 1a90 	vmov	r1, s15
10005108:	eefc 6bcb 	vcvt.u32.f64	s13, d11
1000510c:	eefc 7bc3 	vcvt.u32.f64	s15, d3
10005110:	ee16 0a90 	vmov	r0, s13
10005114:	ee17 3a90 	vmov	r3, s15
10005118:	edcd 7a00 	vstr	s15, [sp]
1000511c:	9201      	str	r2, [sp, #4]
1000511e:	ed8d 0b0e 	vstr	d0, [sp, #56]	@ 0x38
10005122:	ed8d 1b10 	vstr	d1, [sp, #64]	@ 0x40
10005126:	f7ff fd83 	bl	10004c30 <fxr_div_fp64_exact>
1000512a:	e9dd 3200 	ldrd	r3, r2, [sp]
1000512e:	ee2c 8b08 	vmul.f64	d8, d12, d8
10005132:	ee28 7b0d 	vmul.f64	d7, d8, d13
10005136:	ee06 1a10 	vmov	s12, r1
1000513a:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000513e:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005142:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005146:	ed85 6b00 	vstr	d6, [r5]
1000514a:	eeb0 6b47 	vmov.f64	d6, d7
1000514e:	ee0c 6b09 	vmla.f64	d6, d12, d9
10005152:	ee07 8b4a 	vmls.f64	d8, d7, d10
10005156:	ee26 7b0d 	vmul.f64	d7, d6, d13
1000515a:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000515e:	ee05 0a10 	vmov	s10, r0
10005162:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005166:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000516a:	ee07 6b4a 	vmls.f64	d6, d7, d10
1000516e:	ed85 5b02 	vstr	d5, [r5, #8]
10005172:	eefc 7bc6 	vcvt.u32.f64	s15, d6
10005176:	eefc 5bc8 	vcvt.u32.f64	s11, d8
1000517a:	ee17 1a90 	vmov	r1, s15
1000517e:	ee15 0a90 	vmov	r0, s11
10005182:	f7ff fd55 	bl	10004c30 <fxr_div_fp64_exact>
10005186:	ee06 0a10 	vmov	s12, r0
1000518a:	ee07 1a10 	vmov	s14, r1
1000518e:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005192:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005196:	3601      	adds	r6, #1
10005198:	42b7      	cmp	r7, r6
1000519a:	f104 0410 	add.w	r4, r4, #16
1000519e:	f105 0510 	add.w	r5, r5, #16
100051a2:	ed04 6b02 	vstr	d6, [r4, #-8]
100051a6:	ed04 7b04 	vstr	d7, [r4, #-16]
100051aa:	f47f af31 	bne.w	10005010 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x30>
100051ae:	b013      	add	sp, #76	@ 0x4c
100051b0:	ecbd 8b10 	vpop	{d8-d15}
100051b4:	bdf0      	pop	{r4, r5, r6, r7, pc}
100051b6:	bf00      	nop
100051b8:	00000000 	.word	0x00000000
100051bc:	41f00000 	.word	0x41f00000
100051c0:	00000000 	.word	0x00000000
100051c4:	3df00000 	.word	0x3df00000
