
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/asm-profile/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10006120 <fp64e_cmul_prepared>:
10006120:	ed2d 8b10 	vpush	{d8-d15}
10006124:	eeb0 8b40 	vmov.f64	d8, d0
10006128:	eefc 6bc8 	vcvt.u32.f64	s13, d8
1000612c:	ee16 2a90 	vmov	r2, s13
10006130:	eefc 6bc2 	vcvt.u32.f64	s13, d2
10006134:	0fd2      	lsrs	r2, r2, #31
10006136:	ee16 3a90 	vmov	r3, s13
1000613a:	ee06 2a90 	vmov	s13, r2
1000613e:	eeb8 6be6 	vcvt.f64.s32	d6, s13
10006142:	b0b0      	sub	sp, #192	@ 0xc0
10006144:	0fdb      	lsrs	r3, r3, #31
10006146:	ed9f 7bfe 	vldr	d7, [pc, #1016]	@ 10006540 <fp64e_cmul_prepared+0x420>
1000614a:	eeb0 cb43 	vmov.f64	d12, d3
1000614e:	eeb0 5b41 	vmov.f64	d5, d1
10006152:	ed8d 6b10 	vstr	d6, [sp, #64]	@ 0x40
10006156:	ed9f 9bfc 	vldr	d9, [pc, #1008]	@ 10006548 <fp64e_cmul_prepared+0x428>
1000615a:	ee06 3a90 	vmov	s13, r3
1000615e:	ee20 3b09 	vmul.f64	d3, d0, d9
10006162:	ee35 ab0c 	vadd.f64	d10, d5, d12
10006166:	ee21 0b07 	vmul.f64	d0, d1, d7
1000616a:	eeb8 1be6 	vcvt.f64.s32	d1, s13
1000616e:	ed9f 6bf8 	vldr	d6, [pc, #992]	@ 10006550 <fp64e_cmul_prepared+0x430>
10006172:	eeb0 bb45 	vmov.f64	d11, d5
10006176:	ee22 5b09 	vmul.f64	d5, d2, d9
1000617a:	ee2a 9b06 	vmul.f64	d9, d10, d6
1000617e:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10006182:	ee38 4b02 	vadd.f64	d4, d8, d2
10006186:	eeb8 9b49 	vcvt.f64.u32	d9, s18
1000618a:	ee34 4b09 	vadd.f64	d4, d4, d9
1000618e:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10006192:	ee24 db06 	vmul.f64	d13, d4, d6
10006196:	ed9f ebf0 	vldr	d14, [pc, #960]	@ 10006558 <fp64e_cmul_prepared+0x438>
1000619a:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000619e:	eebc dbcd 	vcvt.u32.f64	s26, d13
100061a2:	ed8d 5b02 	vstr	d5, [sp, #8]
100061a6:	ee05 2b4e 	vmls.f64	d2, d5, d14
100061aa:	eeb8 db4d 	vcvt.f64.u32	d13, s26
100061ae:	ed9f 5bec 	vldr	d5, [pc, #944]	@ 10006560 <fp64e_cmul_prepared+0x440>
100061b2:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100061b6:	eebc 0bc0 	vcvt.u32.f64	s0, d0
100061ba:	ee0d 4b45 	vmls.f64	d4, d13, d5
100061be:	ed8d 1b14 	vstr	d1, [sp, #80]	@ 0x50
100061c2:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100061c6:	ee2c 1b07 	vmul.f64	d1, d12, d7
100061ca:	eeb8 0b40 	vcvt.f64.u32	d0, s0
100061ce:	ed8d 4b04 	vstr	d4, [sp, #16]
100061d2:	eefc 4bc4 	vcvt.u32.f64	s9, d4
100061d6:	ee03 8b4e 	vmls.f64	d8, d3, d14
100061da:	ee09 ab45 	vmls.f64	d10, d9, d5
100061de:	ed9f dbe2 	vldr	d13, [pc, #904]	@ 10006568 <fp64e_cmul_prepared+0x448>
100061e2:	eeb0 9b40 	vmov.f64	d9, d0
100061e6:	eebc 1bc1 	vcvt.u32.f64	s2, d1
100061ea:	ee14 3a90 	vmov	r3, s9
100061ee:	ed9f fbe0 	vldr	d15, [pc, #896]	@ 10006570 <fp64e_cmul_prepared+0x450>
100061f2:	ee08 9b0d 	vmla.f64	d9, d8, d13
100061f6:	eeb8 1b41 	vcvt.f64.u32	d1, s2
100061fa:	eeb0 8b4b 	vmov.f64	d8, d11
100061fe:	0fdb      	lsrs	r3, r3, #31
10006200:	ee00 8b4f 	vmls.f64	d8, d0, d15
10006204:	ee04 3a90 	vmov	s9, r3
10006208:	eeb0 0b41 	vmov.f64	d0, d1
1000620c:	ed8d cb08 	vstr	d12, [sp, #32]
10006210:	ee02 0b0d 	vmla.f64	d0, d2, d13
10006214:	ee01 cb4f 	vmls.f64	d12, d1, d15
10006218:	eeb8 2be4 	vcvt.f64.s32	d2, s9
1000621c:	ed8d 0b12 	vstr	d0, [sp, #72]	@ 0x48
10006220:	ed8d ab00 	vstr	d10, [sp]
10006224:	ed90 4b04 	vldr	d4, [r0, #16]
10006228:	ed90 ab00 	vldr	d10, [r0]
1000622c:	ed8d bb06 	vstr	d11, [sp, #24]
10006230:	eeb0 db4c 	vmov.f64	d13, d12
10006234:	ed8d 2b16 	vstr	d2, [sp, #88]	@ 0x58
10006238:	ed90 cb02 	vldr	d12, [r0, #8]
1000623c:	ee28 2b0a 	vmul.f64	d2, d8, d10
10006240:	ee28 bb0c 	vmul.f64	d11, d8, d12
10006244:	ee28 1b04 	vmul.f64	d1, d8, d4
10006248:	ee29 0b04 	vmul.f64	d0, d9, d4
1000624c:	ee09 bb0a 	vmla.f64	d11, d9, d10
10006250:	ee09 1b0c 	vmla.f64	d1, d9, d12
10006254:	ee03 0b0c 	vmla.f64	d0, d3, d12
10006258:	ee03 1b0a 	vmla.f64	d1, d3, d10
1000625c:	ee22 2b07 	vmul.f64	d2, d2, d7
10006260:	ed8d bb0a 	vstr	d11, [sp, #40]	@ 0x28
10006264:	ed9d ab12 	vldr	d10, [sp, #72]	@ 0x48
10006268:	ed8d 1b0c 	vstr	d1, [sp, #48]	@ 0x30
1000626c:	ed8d 0b0e 	vstr	d0, [sp, #56]	@ 0x38
10006270:	ed9d 1b02 	vldr	d1, [sp, #8]
10006274:	ed90 0b0e 	vldr	d0, [r0, #56]	@ 0x38
10006278:	eefc bbc2 	vcvt.u32.f64	s23, d2
1000627c:	eeb0 cb4d 	vmov.f64	d12, d13
10006280:	ed90 2b0c 	vldr	d2, [r0, #48]	@ 0x30
10006284:	ed90 db0a 	vldr	d13, [r0, #40]	@ 0x28
10006288:	ee2c 3b0d 	vmul.f64	d3, d12, d13
1000628c:	ee2c 9b02 	vmul.f64	d9, d12, d2
10006290:	ee2c 8b00 	vmul.f64	d8, d12, d0
10006294:	ee2a 4b00 	vmul.f64	d4, d10, d0
10006298:	ee0a 9b0d 	vmla.f64	d9, d10, d13
1000629c:	ee0a 8b02 	vmla.f64	d8, d10, d2
100062a0:	ee01 4b02 	vmla.f64	d4, d1, d2
100062a4:	ee01 8b0d 	vmla.f64	d8, d1, d13
100062a8:	ee23 3b07 	vmul.f64	d3, d3, d7
100062ac:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100062b0:	eeb8 2b6b 	vcvt.f64.u32	d2, s23
100062b4:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100062b8:	ed9d bb0a 	vldr	d11, [sp, #40]	@ 0x28
100062bc:	ed8d 4b12 	vstr	d4, [sp, #72]	@ 0x48
100062c0:	ee32 2b0b 	vadd.f64	d2, d2, d11
100062c4:	ed9d 4b04 	vldr	d4, [sp, #16]
100062c8:	ed9d bb00 	vldr	d11, [sp]
100062cc:	ee33 3b09 	vadd.f64	d3, d3, d9
100062d0:	ed9f 9b9d 	vldr	d9, [pc, #628]	@ 10006548 <fp64e_cmul_prepared+0x428>
100062d4:	ee24 0b09 	vmul.f64	d0, d4, d9
100062d8:	ee2b 9b07 	vmul.f64	d9, d11, d7
100062dc:	eebc 0bc0 	vcvt.u32.f64	s0, d0
100062e0:	eebc 9bc9 	vcvt.u32.f64	s18, d9
100062e4:	eeb8 0b40 	vcvt.f64.u32	d0, s0
100062e8:	eeb8 9b49 	vcvt.f64.u32	d9, s18
100062ec:	ee00 4b4e 	vmls.f64	d4, d0, d14
100062f0:	eeb0 ab49 	vmov.f64	d10, d9
100062f4:	ed9f db9c 	vldr	d13, [pc, #624]	@ 10006568 <fp64e_cmul_prepared+0x448>
100062f8:	ee04 ab0d 	vmla.f64	d10, d4, d13
100062fc:	eeb0 4b4b 	vmov.f64	d4, d11
10006300:	ee09 4b4f 	vmls.f64	d4, d9, d15
10006304:	ee23 9b07 	vmul.f64	d9, d3, d7
10006308:	eeb0 bb44 	vmov.f64	d11, d4
1000630c:	ee22 4b07 	vmul.f64	d4, d2, d7
10006310:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10006314:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10006318:	eeb8 9b49 	vcvt.f64.u32	d9, s18
1000631c:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10006320:	ee09 3b4f 	vmls.f64	d3, d9, d15
10006324:	ed9d 1b0c 	vldr	d1, [sp, #48]	@ 0x30
10006328:	ee04 2b4f 	vmls.f64	d2, d4, d15
1000632c:	ee38 8b09 	vadd.f64	d8, d8, d9
10006330:	ee31 1b04 	vadd.f64	d1, d1, d4
10006334:	ed90 9b18 	vldr	d9, [r0, #96]	@ 0x60
10006338:	ed8d 2b04 	vstr	d2, [sp, #16]
1000633c:	ed8d 8b02 	vstr	d8, [sp, #8]
10006340:	ed8d 3b0a 	vstr	d3, [sp, #40]	@ 0x28
10006344:	eeb0 cb4b 	vmov.f64	d12, d11
10006348:	ed90 db14 	vldr	d13, [r0, #80]	@ 0x50
1000634c:	ed90 8b16 	vldr	d8, [r0, #88]	@ 0x58
10006350:	ee2c 4b0d 	vmul.f64	d4, d12, d13
10006354:	ee2c 2b08 	vmul.f64	d2, d12, d8
10006358:	ee2c 3b09 	vmul.f64	d3, d12, d9
1000635c:	ee2a bb09 	vmul.f64	d11, d10, d9
10006360:	ee0a 2b0d 	vmla.f64	d2, d10, d13
10006364:	ee0a 3b08 	vmla.f64	d3, d10, d8
10006368:	ee00 bb08 	vmla.f64	d11, d0, d8
1000636c:	ee00 3b0d 	vmla.f64	d3, d0, d13
10006370:	ee24 4b07 	vmul.f64	d4, d4, d7
10006374:	ee21 0b07 	vmul.f64	d0, d1, d7
10006378:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000637c:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10006380:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10006384:	ed9d 8b02 	vldr	d8, [sp, #8]
10006388:	ee34 4b02 	vadd.f64	d4, d4, d2
1000638c:	eeb8 2b40 	vcvt.f64.u32	d2, s0
10006390:	ed9d 0b0e 	vldr	d0, [sp, #56]	@ 0x38
10006394:	ee02 1b4f 	vmls.f64	d1, d2, d15
10006398:	ee30 ab02 	vadd.f64	d10, d0, d2
1000639c:	ee28 2b07 	vmul.f64	d2, d8, d7
100063a0:	ee24 9b07 	vmul.f64	d9, d4, d7
100063a4:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100063a8:	eeb0 0b41 	vmov.f64	d0, d1
100063ac:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100063b0:	ed9d 1b12 	vldr	d1, [sp, #72]	@ 0x48
100063b4:	eebc 9bc9 	vcvt.u32.f64	s18, d9
100063b8:	ee31 1b02 	vadd.f64	d1, d1, d2
100063bc:	eeb8 9b49 	vcvt.f64.u32	d9, s18
100063c0:	ee02 8b4f 	vmls.f64	d8, d2, d15
100063c4:	ee09 4b4f 	vmls.f64	d4, d9, d15
100063c8:	ee21 2b07 	vmul.f64	d2, d1, d7
100063cc:	eeb0 cb44 	vmov.f64	d12, d4
100063d0:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100063d4:	ee2a 4b07 	vmul.f64	d4, d10, d7
100063d8:	ee33 3b09 	vadd.f64	d3, d3, d9
100063dc:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100063e0:	ed9f 9b59 	vldr	d9, [pc, #356]	@ 10006548 <fp64e_cmul_prepared+0x428>
100063e4:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100063e8:	ee02 1b4f 	vmls.f64	d1, d2, d15
100063ec:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100063f0:	ee20 2b09 	vmul.f64	d2, d0, d9
100063f4:	ee04 ab4f 	vmls.f64	d10, d4, d15
100063f8:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100063fc:	ee28 4b09 	vmul.f64	d4, d8, d9
10006400:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10006404:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10006408:	ed9f db57 	vldr	d13, [pc, #348]	@ 10006568 <fp64e_cmul_prepared+0x448>
1000640c:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10006410:	eeb0 9b42 	vmov.f64	d9, d2
10006414:	ee0a 9b0d 	vmla.f64	d9, d10, d13
10006418:	eeb0 ab44 	vmov.f64	d10, d4
1000641c:	ee02 0b4e 	vmls.f64	d0, d2, d14
10006420:	ee04 8b4e 	vmls.f64	d8, d4, d14
10006424:	ee01 ab0d 	vmla.f64	d10, d1, d13
10006428:	ed8d 9b02 	vstr	d9, [sp, #8]
1000642c:	eeb0 db4a 	vmov.f64	d13, d10
10006430:	eeb0 9b40 	vmov.f64	d9, d0
10006434:	eeb0 ab48 	vmov.f64	d10, d8
10006438:	ed9d 0b04 	vldr	d0, [sp, #16]
1000643c:	ed9f 8b4e 	vldr	d8, [pc, #312]	@ 10006578 <fp64e_cmul_prepared+0x458>
10006440:	ee23 2b07 	vmul.f64	d2, d3, d7
10006444:	ee20 0b08 	vmul.f64	d0, d0, d8
10006448:	eebc 2bc2 	vcvt.u32.f64	s4, d2
1000644c:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10006450:	ed9d 4b0a 	vldr	d4, [sp, #40]	@ 0x28
10006454:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10006458:	eeb8 0b40 	vcvt.f64.u32	d0, s0
1000645c:	ee24 1b08 	vmul.f64	d1, d4, d8
10006460:	ee02 3b4f 	vmls.f64	d3, d2, d15
10006464:	ee3b 4b02 	vadd.f64	d4, d11, d2
10006468:	ee09 0b0e 	vmla.f64	d0, d9, d14
1000646c:	ed9f 9b36 	vldr	d9, [pc, #216]	@ 10006548 <fp64e_cmul_prepared+0x428>
10006470:	ee2c 8b08 	vmul.f64	d8, d12, d8
10006474:	ee24 7b07 	vmul.f64	d7, d4, d7
10006478:	ee23 cb09 	vmul.f64	d12, d3, d9
1000647c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006480:	eebc cbcc 	vcvt.u32.f64	s24, d12
10006484:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006488:	eeb8 cb4c 	vcvt.f64.u32	d12, s24
1000648c:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10006490:	ee07 4b4f 	vmls.f64	d4, d7, d15
10006494:	ee0c 3b4e 	vmls.f64	d3, d12, d14
10006498:	eeb0 7b4c 	vmov.f64	d7, d12
1000649c:	ed9f 2b32 	vldr	d2, [pc, #200]	@ 10006568 <fp64e_cmul_prepared+0x448>
100064a0:	eeb8 8b48 	vcvt.f64.u32	d8, s16
100064a4:	ee04 7b02 	vmla.f64	d7, d4, d2
100064a8:	ee03 8b0e 	vmla.f64	d8, d3, d14
100064ac:	ed9f 2b34 	vldr	d2, [pc, #208]	@ 10006580 <fp64e_cmul_prepared+0x460>
100064b0:	ed9d 9b02 	vldr	d9, [sp, #8]
100064b4:	ee38 3b05 	vadd.f64	d3, d8, d5
100064b8:	ee39 4b02 	vadd.f64	d4, d9, d2
100064bc:	ee3d 8b02 	vadd.f64	d8, d13, d2
100064c0:	ed9d 9b10 	vldr	d9, [sp, #64]	@ 0x40
100064c4:	ee37 7b02 	vadd.f64	d7, d7, d2
100064c8:	ed90 2b06 	vldr	d2, [r0, #24]
100064cc:	ee09 4b42 	vmls.f64	d4, d9, d2
100064d0:	ed90 2b10 	vldr	d2, [r0, #64]	@ 0x40
100064d4:	ed9d 9b14 	vldr	d9, [sp, #80]	@ 0x50
100064d8:	ee09 8b42 	vmls.f64	d8, d9, d2
100064dc:	ed90 2b08 	vldr	d2, [r0, #32]
100064e0:	ed9d 9b06 	vldr	d9, [sp, #24]
100064e4:	ed9d cb08 	vldr	d12, [sp, #32]
100064e8:	ee09 4b42 	vmls.f64	d4, d9, d2
100064ec:	ed90 2b12 	vldr	d2, [r0, #72]	@ 0x48
100064f0:	ee24 9b06 	vmul.f64	d9, d4, d6
100064f4:	ee0c 8b42 	vmls.f64	d8, d12, d2
100064f8:	eebc 1bc1 	vcvt.u32.f64	s2, d1
100064fc:	ee28 2b06 	vmul.f64	d2, d8, d6
10006500:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10006504:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10006508:	ee0a 1b0e 	vmla.f64	d1, d10, d14
1000650c:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10006510:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10006514:	ee09 4b45 	vmls.f64	d4, d9, d5
10006518:	eeb8 2b42 	vcvt.f64.u32	d2, s4
1000651c:	ee31 9b00 	vadd.f64	d9, d1, d0
10006520:	ee30 0b05 	vadd.f64	d0, d0, d5
10006524:	ee02 8b45 	vmls.f64	d8, d2, d5
10006528:	ee30 1b41 	vsub.f64	d1, d0, d1
1000652c:	ed90 2b1a 	vldr	d2, [r0, #104]	@ 0x68
10006530:	ed9d 0b16 	vldr	d0, [sp, #88]	@ 0x58
10006534:	ee00 7b42 	vmls.f64	d7, d0, d2
10006538:	e026      	b.n	10006588 <fp64e_cmul_prepared+0x468>
1000653a:	bf00      	nop
1000653c:	f3af 8000 	nop.w
10006540:	00000000 	.word	0x00000000
10006544:	3e700000 	.word	0x3e700000
10006548:	00000000 	.word	0x00000000
1000654c:	3ef00000 	.word	0x3ef00000
10006550:	00000000 	.word	0x00000000
10006554:	3df00000 	.word	0x3df00000
10006558:	00000000 	.word	0x00000000
1000655c:	40f00000 	.word	0x40f00000
10006560:	00000000 	.word	0x00000000
10006564:	41f00000 	.word	0x41f00000
10006568:	00000000 	.word	0x00000000
1000656c:	40700000 	.word	0x40700000
10006570:	00000000 	.word	0x00000000
10006574:	41700000 	.word	0x41700000
10006578:	00000000 	.word	0x00000000
1000657c:	3f700000 	.word	0x3f700000
10006580:	00000000 	.word	0x00000000
10006584:	42000000 	.word	0x42000000
10006588:	ee29 2b06 	vmul.f64	d2, d9, d6
1000658c:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10006590:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10006594:	ed90 0b1c 	vldr	d0, [r0, #112]	@ 0x70
10006598:	ee02 9b45 	vmls.f64	d9, d2, d5
1000659c:	ed9d bb00 	vldr	d11, [sp]
100065a0:	ee33 3b49 	vsub.f64	d3, d3, d9
100065a4:	ee0b 7b40 	vmls.f64	d7, d11, d0
100065a8:	ee38 9b04 	vadd.f64	d9, d8, d4
100065ac:	ee34 4b05 	vadd.f64	d4, d4, d5
100065b0:	ee39 9b02 	vadd.f64	d9, d9, d2
100065b4:	ee34 0b48 	vsub.f64	d0, d4, d8
100065b8:	ee27 8b06 	vmul.f64	d8, d7, d6
100065bc:	ee29 2b06 	vmul.f64	d2, d9, d6
100065c0:	eebc 8bc8 	vcvt.u32.f64	s16, d8
100065c4:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100065c8:	eeb8 8b48 	vcvt.f64.u32	d8, s16
100065cc:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100065d0:	ee08 7b45 	vmls.f64	d7, d8, d5
100065d4:	ee02 9b45 	vmls.f64	d9, d2, d5
100065d8:	ee37 2b05 	vadd.f64	d2, d7, d5
100065dc:	eeb7 4b00 	vmov.f64	d4, #112	@ 0x3f800000  1.0
100065e0:	ee32 2b49 	vsub.f64	d2, d2, d9
100065e4:	ee21 7b06 	vmul.f64	d7, d1, d6
100065e8:	ee30 0b44 	vsub.f64	d0, d0, d4
100065ec:	ee32 2b44 	vsub.f64	d2, d2, d4
100065f0:	ee23 4b06 	vmul.f64	d4, d3, d6
100065f4:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100065f8:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100065fc:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006600:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10006604:	ee30 0b07 	vadd.f64	d0, d0, d7
10006608:	ee32 2b04 	vadd.f64	d2, d2, d4
1000660c:	ee07 1b45 	vmls.f64	d1, d7, d5
10006610:	ee20 7b06 	vmul.f64	d7, d0, d6
10006614:	ee22 6b06 	vmul.f64	d6, d2, d6
10006618:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000661c:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006620:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006624:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006628:	ee07 0b45 	vmls.f64	d0, d7, d5
1000662c:	ee04 3b45 	vmls.f64	d3, d4, d5
10006630:	ee06 2b45 	vmls.f64	d2, d6, d5
10006634:	b030      	add	sp, #192	@ 0xc0
10006636:	ecbd 8b10 	vpop	{d8-d15}
1000663a:	4770      	bx	lr
