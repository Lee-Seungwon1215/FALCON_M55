
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/r2-kat/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10005170 <fndsa_fp64e_mul>:
10005170:	eefc 7bc0 	vcvt.u32.f64	s15, d0
10005174:	ee17 2a90 	vmov	r2, s15
10005178:	eefc 7bc2 	vcvt.u32.f64	s15, d2
1000517c:	0fd2      	lsrs	r2, r2, #31
1000517e:	ee17 3a90 	vmov	r3, s15
10005182:	ee07 2a90 	vmov	s15, r2
10005186:	ed2d 8b10 	vpush	{d8-d15}
1000518a:	eeb8 7be7 	vcvt.f64.s32	d7, s15
1000518e:	b094      	sub	sp, #80	@ 0x50
10005190:	0fdb      	lsrs	r3, r3, #31
10005192:	ed8d 7b00 	vstr	d7, [sp]
10005196:	ee07 3a90 	vmov	s15, r3
1000519a:	eeb0 bb43 	vmov.f64	d11, d3
1000519e:	eeb8 4be7 	vcvt.f64.s32	d4, s15
100051a2:	ed9f 3b53 	vldr	d3, [pc, #332]	@ 100052f0 <fndsa_fp64e_mul+0x180>
100051a6:	ed9f 6b54 	vldr	d6, [pc, #336]	@ 100052f8 <fndsa_fp64e_mul+0x188>
100051aa:	ed8d 4b02 	vstr	d4, [sp, #8]
100051ae:	ee22 4b03 	vmul.f64	d4, d2, d3
100051b2:	ee20 5b03 	vmul.f64	d5, d0, d3
100051b6:	ee21 9b06 	vmul.f64	d9, d1, d6
100051ba:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100051be:	eeb0 cb41 	vmov.f64	d12, d1
100051c2:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100051c6:	ed9f 1b4e 	vldr	d1, [pc, #312]	@ 10005300 <fndsa_fp64e_mul+0x190>
100051ca:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100051ce:	eebc 9bc9 	vcvt.u32.f64	s18, d9
100051d2:	ee2b 7b06 	vmul.f64	d7, d11, d6
100051d6:	ee04 2b41 	vmls.f64	d2, d4, d1
100051da:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100051de:	eeb8 9b49 	vcvt.f64.u32	d9, s18
100051e2:	ee05 0b41 	vmls.f64	d0, d5, d1
100051e6:	ed9f eb48 	vldr	d14, [pc, #288]	@ 10005308 <fndsa_fp64e_mul+0x198>
100051ea:	eeb0 8b42 	vmov.f64	d8, d2
100051ee:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100051f2:	eeb0 2b49 	vmov.f64	d2, d9
100051f6:	ed9f 3b46 	vldr	d3, [pc, #280]	@ 10005310 <fndsa_fp64e_mul+0x1a0>
100051fa:	ee00 2b0e 	vmla.f64	d2, d0, d14
100051fe:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005202:	eeb0 0b4c 	vmov.f64	d0, d12
10005206:	ee09 0b43 	vmls.f64	d0, d9, d3
1000520a:	eeb0 9b47 	vmov.f64	d9, d7
1000520e:	ee08 9b0e 	vmla.f64	d9, d8, d14
10005212:	eeb0 8b4b 	vmov.f64	d8, d11
10005216:	ee07 8b43 	vmls.f64	d8, d7, d3
1000521a:	ee20 7b08 	vmul.f64	d7, d0, d8
1000521e:	ee20 ab09 	vmul.f64	d10, d0, d9
10005222:	ee20 fb04 	vmul.f64	d15, d0, d4
10005226:	ee22 db04 	vmul.f64	d13, d2, d4
1000522a:	ee02 ab08 	vmla.f64	d10, d2, d8
1000522e:	ee02 fb09 	vmla.f64	d15, d2, d9
10005232:	ee05 db09 	vmla.f64	d13, d5, d9
10005236:	ee05 fb08 	vmla.f64	d15, d5, d8
1000523a:	ee27 7b06 	vmul.f64	d7, d7, d6
1000523e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005242:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005246:	ee37 7b0a 	vadd.f64	d7, d7, d10
1000524a:	ee27 4b06 	vmul.f64	d4, d7, d6
1000524e:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10005252:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10005256:	ed9f 5b30 	vldr	d5, [pc, #192]	@ 10005318 <fndsa_fp64e_mul+0x1a8>
1000525a:	ee3f 2b04 	vadd.f64	d2, d15, d4
1000525e:	ee04 7b43 	vmls.f64	d7, d4, d3
10005262:	ee27 7b05 	vmul.f64	d7, d7, d5
10005266:	ee22 5b06 	vmul.f64	d5, d2, d6
1000526a:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000526e:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10005272:	ee3d 4b05 	vadd.f64	d4, d13, d5
10005276:	ee05 2b43 	vmls.f64	d2, d5, d3
1000527a:	ed9f 5b1d 	vldr	d5, [pc, #116]	@ 100052f0 <fndsa_fp64e_mul+0x180>
1000527e:	ee24 6b06 	vmul.f64	d6, d4, d6
10005282:	ee22 db05 	vmul.f64	d13, d2, d5
10005286:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000528a:	eebc dbcd 	vcvt.u32.f64	s26, d13
1000528e:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005292:	eeb8 db4d 	vcvt.f64.u32	d13, s26
10005296:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000529a:	ee06 4b43 	vmls.f64	d4, d6, d3
1000529e:	ee0d 2b41 	vmls.f64	d2, d13, d1
100052a2:	eeb0 0b4d 	vmov.f64	d0, d13
100052a6:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100052aa:	ee04 0b0e 	vmla.f64	d0, d4, d14
100052ae:	ee02 7b01 	vmla.f64	d7, d2, d1
100052b2:	ed9f 8b1b 	vldr	d8, [pc, #108]	@ 10005320 <fndsa_fp64e_mul+0x1b0>
100052b6:	eeb0 1b47 	vmov.f64	d1, d7
100052ba:	ed9d 7b00 	vldr	d7, [sp]
100052be:	ee30 0b08 	vadd.f64	d0, d0, d8
100052c2:	ed9d 4b02 	vldr	d4, [sp, #8]
100052c6:	ee07 0b4b 	vmls.f64	d0, d7, d11
100052ca:	ed9f 9b17 	vldr	d9, [pc, #92]	@ 10005328 <fndsa_fp64e_mul+0x1b8>
100052ce:	ee04 0b4c 	vmls.f64	d0, d4, d12
100052d2:	ee20 9b09 	vmul.f64	d9, d0, d9
100052d6:	eebc 9bc9 	vcvt.u32.f64	s18, d9
100052da:	ed9f 7b15 	vldr	d7, [pc, #84]	@ 10005330 <fndsa_fp64e_mul+0x1c0>
100052de:	eeb8 9b49 	vcvt.f64.u32	d9, s18
100052e2:	ee09 0b47 	vmls.f64	d0, d9, d7
100052e6:	b014      	add	sp, #80	@ 0x50
100052e8:	ecbd 8b10 	vpop	{d8-d15}
100052ec:	4770      	bx	lr
100052ee:	bf00      	nop
100052f0:	00000000 	.word	0x00000000
100052f4:	3ef00000 	.word	0x3ef00000
100052f8:	00000000 	.word	0x00000000
100052fc:	3e700000 	.word	0x3e700000
10005300:	00000000 	.word	0x00000000
10005304:	40f00000 	.word	0x40f00000
10005308:	00000000 	.word	0x00000000
1000530c:	40700000 	.word	0x40700000
10005310:	00000000 	.word	0x00000000
10005314:	41700000 	.word	0x41700000
10005318:	00000000 	.word	0x00000000
1000531c:	3f700000 	.word	0x3f700000
10005320:	00000000 	.word	0x00000000
10005324:	42000000 	.word	0x42000000
10005328:	00000000 	.word	0x00000000
1000532c:	3df00000 	.word	0x3df00000
10005330:	00000000 	.word	0x00000000
10005334:	41f00000 	.word	0x41f00000
