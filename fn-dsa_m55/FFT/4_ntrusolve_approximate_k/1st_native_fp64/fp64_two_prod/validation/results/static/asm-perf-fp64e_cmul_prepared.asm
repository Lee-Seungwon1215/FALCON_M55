10006120 <fp64e_cmul_prepared>:
10006120:	eefc 6bc0 	vcvt.u32.f64	s13, d0
10006124:	ee16 2a90 	vmov	r2, s13
10006128:	eefc 6bc2 	vcvt.u32.f64	s13, d2
1000612c:	0fd2      	lsrs	r2, r2, #31
1000612e:	ee16 3a90 	vmov	r3, s13
10006132:	ee06 2a90 	vmov	s13, r2
10006136:	ed2d 8b10 	vpush	{d8-d15}
1000613a:	eeb8 6be6 	vcvt.f64.s32	d6, s13
1000613e:	b0b4      	sub	sp, #208	@ 0xd0
10006140:	0fdb      	lsrs	r3, r3, #31
10006142:	ed8d 6b14 	vstr	d6, [sp, #80]	@ 0x50
10006146:	ee06 3a90 	vmov	s13, r3
1000614a:	eeb0 fb43 	vmov.f64	d15, d3
1000614e:	eeb0 db41 	vmov.f64	d13, d1
10006152:	ed90 3b06 	vldr	d3, [r0, #24]
10006156:	eeb8 5be6 	vcvt.f64.s32	d5, s13
1000615a:	ee31 eb0f 	vadd.f64	d14, d1, d15
1000615e:	ee2d 9b03 	vmul.f64	d9, d13, d3
10006162:	ed8d 5b18 	vstr	d5, [sp, #96]	@ 0x60
10006166:	ee20 3b03 	vmul.f64	d3, d0, d3
1000616a:	ed9f 5bfd 	vldr	d5, [pc, #1012]	@ 10006560 <fp64e_cmul_prepared+0x440>
1000616e:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006172:	ee2e 8b05 	vmul.f64	d8, d14, d5
10006176:	ed90 1b10 	vldr	d1, [r0, #64]	@ 0x40
1000617a:	eefc 3bc8 	vcvt.u32.f64	s7, d8
1000617e:	eeb8 8b43 	vcvt.f64.u32	d8, s6
10006182:	ed8d 8b0a 	vstr	d8, [sp, #40]	@ 0x28
10006186:	ee2f 8b01 	vmul.f64	d8, d15, d1
1000618a:	ee22 1b01 	vmul.f64	d1, d2, d1
1000618e:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10006192:	ed90 6b0e 	vldr	d6, [r0, #56]	@ 0x38
10006196:	eeb8 ab41 	vcvt.f64.u32	d10, s2
1000619a:	ed90 4b04 	vldr	d4, [r0, #16]
1000619e:	ed8d ab08 	vstr	d10, [sp, #32]
100061a2:	ee2f ab06 	vmul.f64	d10, d15, d6
100061a6:	ee2d 1b04 	vmul.f64	d1, d13, d4
100061aa:	eebc abca 	vcvt.u32.f64	s20, d10
100061ae:	eebc 9bc9 	vcvt.u32.f64	s18, d9
100061b2:	ed9f 7bed 	vldr	d7, [pc, #948]	@ 10006568 <fp64e_cmul_prepared+0x448>
100061b6:	eeb8 cb4a 	vcvt.f64.u32	d12, s20
100061ba:	eeb8 9b49 	vcvt.f64.u32	d9, s18
100061be:	eeb8 3b63 	vcvt.f64.u32	d3, s7
100061c2:	ee30 ab02 	vadd.f64	d10, d0, d2
100061c6:	eebc 1bc1 	vcvt.u32.f64	s2, d1
100061ca:	ee03 eb47 	vmls.f64	d14, d3, d7
100061ce:	eeb8 bb41 	vcvt.f64.u32	d11, s2
100061d2:	ee3a ab03 	vadd.f64	d10, d10, d3
100061d6:	ee29 1b47 	vnmul.f64	d1, d9, d7
100061da:	ed90 3b02 	vldr	d3, [r0, #8]
100061de:	eead 1b03 	vfma.f64	d1, d13, d3
100061e2:	ee31 1b07 	vadd.f64	d1, d1, d7
100061e6:	ee21 1b05 	vmul.f64	d1, d1, d5
100061ea:	eebc 8bc8 	vcvt.u32.f64	s16, d8
100061ee:	eebc 1bc1 	vcvt.u32.f64	s2, d1
100061f2:	eeb8 8b48 	vcvt.f64.u32	d8, s16
100061f6:	eeb8 1b41 	vcvt.f64.u32	d1, s2
100061fa:	ed8d db04 	vstr	d13, [sp, #16]
100061fe:	ee28 3b47 	vnmul.f64	d3, d8, d7
10006202:	ee31 db09 	vadd.f64	d13, d1, d9
10006206:	ee2a 1b05 	vmul.f64	d1, d10, d5
1000620a:	ed90 9b0c 	vldr	d9, [r0, #48]	@ 0x30
1000620e:	eeaf 3b09 	vfma.f64	d3, d15, d9
10006212:	ee33 3b07 	vadd.f64	d3, d3, d7
10006216:	eebc 1bc1 	vcvt.u32.f64	s2, d1
1000621a:	ee23 3b05 	vmul.f64	d3, d3, d5
1000621e:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10006222:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006226:	ee01 ab47 	vmls.f64	d10, d1, d7
1000622a:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000622e:	ed8d eb00 	vstr	d14, [sp]
10006232:	ee33 eb08 	vadd.f64	d14, d3, d8
10006236:	eefc 3bca 	vcvt.u32.f64	s7, d10
1000623a:	ee20 4b04 	vmul.f64	d4, d0, d4
1000623e:	ee13 3a90 	vmov	r3, s7
10006242:	ee22 6b06 	vmul.f64	d6, d2, d6
10006246:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000624a:	0fdb      	lsrs	r3, r3, #31
1000624c:	ee03 3a90 	vmov	s7, r3
10006250:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006254:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10006258:	ed90 8b00 	vldr	d8, [r0]
1000625c:	ed8d ab02 	vstr	d10, [sp, #8]
10006260:	ee2b 1b47 	vnmul.f64	d1, d11, d7
10006264:	ed9d ab04 	vldr	d10, [sp, #16]
10006268:	eeaa 1b08 	vfma.f64	d1, d10, d8
1000626c:	ee24 4b47 	vnmul.f64	d4, d4, d7
10006270:	eea0 4b08 	vfma.f64	d4, d0, d8
10006274:	eeb8 3be3 	vcvt.f64.s32	d3, s7
10006278:	ee34 4b07 	vadd.f64	d4, d4, d7
1000627c:	ed9d 8b0a 	vldr	d8, [sp, #40]	@ 0x28
10006280:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006284:	ed90 ab02 	vldr	d10, [r0, #8]
10006288:	ed8d 3b1a 	vstr	d3, [sp, #104]	@ 0x68
1000628c:	ed8d 4b10 	vstr	d4, [sp, #64]	@ 0x40
10006290:	ee2c 3b47 	vnmul.f64	d3, d12, d7
10006294:	ed90 4b0a 	vldr	d4, [r0, #40]	@ 0x28
10006298:	eeaf 3b04 	vfma.f64	d3, d15, d4
1000629c:	ee26 6b47 	vnmul.f64	d6, d6, d7
100062a0:	eea2 6b04 	vfma.f64	d6, d2, d4
100062a4:	ee28 8b47 	vnmul.f64	d8, d8, d7
100062a8:	eea0 8b0a 	vfma.f64	d8, d0, d10
100062ac:	ee33 4b07 	vadd.f64	d4, d3, d7
100062b0:	ed9d ab08 	vldr	d10, [sp, #32]
100062b4:	ee36 3b07 	vadd.f64	d3, d6, d7
100062b8:	ed90 9b1a 	vldr	d9, [r0, #104]	@ 0x68
100062bc:	ed90 0b0c 	vldr	d0, [r0, #48]	@ 0x30
100062c0:	ed9d 6b02 	vldr	d6, [sp, #8]
100062c4:	ed8d 3b0e 	vstr	d3, [sp, #56]	@ 0x38
100062c8:	ee2a 3b47 	vnmul.f64	d3, d10, d7
100062cc:	eea2 3b00 	vfma.f64	d3, d2, d0
100062d0:	ed9d 2b00 	vldr	d2, [sp]
100062d4:	ee29 ab02 	vmul.f64	d10, d9, d2
100062d8:	ee29 9b06 	vmul.f64	d9, d9, d6
100062dc:	ee31 1b07 	vadd.f64	d1, d1, d7
100062e0:	eebc 9bc9 	vcvt.u32.f64	s18, d9
100062e4:	ee21 0b05 	vmul.f64	d0, d1, d5
100062e8:	eeb8 9b49 	vcvt.f64.u32	d9, s18
100062ec:	eebc 0bc0 	vcvt.u32.f64	s0, d0
100062f0:	ed8d 9b0c 	vstr	d9, [sp, #48]	@ 0x30
100062f4:	ee24 9b05 	vmul.f64	d9, d4, d5
100062f8:	eeb8 0b40 	vcvt.f64.u32	d0, s0
100062fc:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10006300:	ee00 1b47 	vmls.f64	d1, d0, d7
10006304:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10006308:	ee3b 0b00 	vadd.f64	d0, d11, d0
1000630c:	eeb0 bb44 	vmov.f64	d11, d4
10006310:	ee09 bb47 	vmls.f64	d11, d9, d7
10006314:	ee38 8b07 	vadd.f64	d8, d8, d7
10006318:	ed8d 1b12 	vstr	d1, [sp, #72]	@ 0x48
1000631c:	ed8d bb16 	vstr	d11, [sp, #88]	@ 0x58
10006320:	ed90 bb18 	vldr	d11, [r0, #96]	@ 0x60
10006324:	ee2b 4b02 	vmul.f64	d4, d11, d2
10006328:	ee28 2b05 	vmul.f64	d2, d8, d5
1000632c:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10006330:	ed9d 1b0a 	vldr	d1, [sp, #40]	@ 0x28
10006334:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10006338:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000633c:	ee02 8b47 	vmls.f64	d8, d2, d7
10006340:	ee31 2b02 	vadd.f64	d2, d1, d2
10006344:	eeb7 1b00 	vmov.f64	d1, #112	@ 0x3f800000  1.0
10006348:	ee33 3b07 	vadd.f64	d3, d3, d7
1000634c:	ee2b 6b06 	vmul.f64	d6, d11, d6
10006350:	ee3c 9b09 	vadd.f64	d9, d12, d9
10006354:	eeb8 bb44 	vcvt.f64.u32	d11, s8
10006358:	ed9d cb12 	vldr	d12, [sp, #72]	@ 0x48
1000635c:	ee3d 4b41 	vsub.f64	d4, d13, d1
10006360:	ed8d bb06 	vstr	d11, [sp, #24]
10006364:	ee34 4b0c 	vadd.f64	d4, d4, d12
10006368:	ee23 bb05 	vmul.f64	d11, d3, d5
1000636c:	ee34 cb08 	vadd.f64	d12, d4, d8
10006370:	eebc bbcb 	vcvt.u32.f64	s22, d11
10006374:	ee3e 8b41 	vsub.f64	d8, d14, d1
10006378:	ed9d 4b16 	vldr	d4, [sp, #88]	@ 0x58
1000637c:	eebc abca 	vcvt.u32.f64	s20, d10
10006380:	ee38 8b04 	vadd.f64	d8, d8, d4
10006384:	eeb8 4b4b 	vcvt.f64.u32	d4, s22
10006388:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
1000638c:	ee04 3b47 	vmls.f64	d3, d4, d7
10006390:	ed9d bb00 	vldr	d11, [sp]
10006394:	ee32 2b41 	vsub.f64	d2, d2, d1
10006398:	ee38 8b03 	vadd.f64	d8, d8, d3
1000639c:	ed90 db16 	vldr	d13, [r0, #88]	@ 0x58
100063a0:	ee2a 3b47 	vnmul.f64	d3, d10, d7
100063a4:	eeab 3b0d 	vfma.f64	d3, d11, d13
100063a8:	ee30 0b41 	vsub.f64	d0, d0, d1
100063ac:	ee33 3b07 	vadd.f64	d3, d3, d7
100063b0:	ee30 0b02 	vadd.f64	d0, d0, d2
100063b4:	ee23 3b05 	vmul.f64	d3, d3, d5
100063b8:	ed9d 2b08 	vldr	d2, [sp, #32]
100063bc:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100063c0:	ee32 4b04 	vadd.f64	d4, d2, d4
100063c4:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100063c8:	ee34 4b41 	vsub.f64	d4, d4, d1
100063cc:	ee39 9b41 	vsub.f64	d9, d9, d1
100063d0:	ed9d 2b06 	vldr	d2, [sp, #24]
100063d4:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100063d8:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100063dc:	ee39 9b04 	vadd.f64	d9, d9, d4
100063e0:	ee26 6b47 	vnmul.f64	d6, d6, d7
100063e4:	ed90 4b14 	vldr	d4, [r0, #80]	@ 0x50
100063e8:	ee22 2b47 	vnmul.f64	d2, d2, d7
100063ec:	eeab 2b04 	vfma.f64	d2, d11, d4
100063f0:	ee33 3b0a 	vadd.f64	d3, d3, d10
100063f4:	ed9d ab02 	vldr	d10, [sp, #8]
100063f8:	eeaa 6b04 	vfma.f64	d6, d10, d4
100063fc:	ed9d 4b10 	vldr	d4, [sp, #64]	@ 0x40
10006400:	ee24 ab05 	vmul.f64	d10, d4, d5
10006404:	ed9d db0e 	vldr	d13, [sp, #56]	@ 0x38
10006408:	eebc abca 	vcvt.u32.f64	s20, d10
1000640c:	ee2d bb05 	vmul.f64	d11, d13, d5
10006410:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10006414:	eebc bbcb 	vcvt.u32.f64	s22, d11
10006418:	ee0a 4b47 	vmls.f64	d4, d10, d7
1000641c:	eeb8 bb4b 	vcvt.f64.u32	d11, s22
10006420:	ee34 4b00 	vadd.f64	d4, d4, d0
10006424:	eeb0 0b4d 	vmov.f64	d0, d13
10006428:	ee32 2b07 	vadd.f64	d2, d2, d7
1000642c:	ee0b 0b47 	vmls.f64	d0, d11, d7
10006430:	ed9d eb0c 	vldr	d14, [sp, #48]	@ 0x30
10006434:	ed90 bb16 	vldr	d11, [r0, #88]	@ 0x58
10006438:	ed9d ab02 	vldr	d10, [sp, #8]
1000643c:	ee30 0b09 	vadd.f64	d0, d0, d9
10006440:	ee2e 9b47 	vnmul.f64	d9, d14, d7
10006444:	eeaa 9b0b 	vfma.f64	d9, d10, d11
10006448:	ee22 ab05 	vmul.f64	d10, d2, d5
1000644c:	eefc bbca 	vcvt.u32.f64	s23, d10
10006450:	ee2c ab05 	vmul.f64	d10, d12, d5
10006454:	eebc bbca 	vcvt.u32.f64	s22, d10
10006458:	eeb8 ab6b 	vcvt.f64.u32	d10, s23
1000645c:	ee33 3b41 	vsub.f64	d3, d3, d1
10006460:	ee0a 2b47 	vmls.f64	d2, d10, d7
10006464:	ee33 3b02 	vadd.f64	d3, d3, d2
10006468:	eeb8 2b4b 	vcvt.f64.u32	d2, s22
1000646c:	eeb0 bb4c 	vmov.f64	d11, d12
10006470:	ee39 9b07 	vadd.f64	d9, d9, d7
10006474:	ee02 bb47 	vmls.f64	d11, d2, d7
10006478:	ee34 4b02 	vadd.f64	d4, d4, d2
1000647c:	ee28 2b05 	vmul.f64	d2, d8, d5
10006480:	ee29 cb05 	vmul.f64	d12, d9, d5
10006484:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10006488:	eebc cbcc 	vcvt.u32.f64	s24, d12
1000648c:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10006490:	ed9d db06 	vldr	d13, [sp, #24]
10006494:	ee02 8b47 	vmls.f64	d8, d2, d7
10006498:	ee30 0b02 	vadd.f64	d0, d0, d2
1000649c:	eeb8 2b4c 	vcvt.f64.u32	d2, s24
100064a0:	ee3d ab0a 	vadd.f64	d10, d13, d10
100064a4:	ee02 9b47 	vmls.f64	d9, d2, d7
100064a8:	ee3e 2b02 	vadd.f64	d2, d14, d2
100064ac:	ee33 3b09 	vadd.f64	d3, d3, d9
100064b0:	ee32 2b41 	vsub.f64	d2, d2, d1
100064b4:	ed9f 9b2e 	vldr	d9, [pc, #184]	@ 10006570 <fp64e_cmul_prepared+0x450>
100064b8:	ee3a ab41 	vsub.f64	d10, d10, d1
100064bc:	ed90 cb02 	vldr	d12, [r0, #8]
100064c0:	ee3a ab02 	vadd.f64	d10, d10, d2
100064c4:	ee34 4b09 	vadd.f64	d4, d4, d9
100064c8:	ed9d 2b14 	vldr	d2, [sp, #80]	@ 0x50
100064cc:	ee36 6b07 	vadd.f64	d6, d6, d7
100064d0:	ee02 4b4c 	vmls.f64	d4, d2, d12
100064d4:	ee30 0b09 	vadd.f64	d0, d0, d9
100064d8:	ed9d 2b18 	vldr	d2, [sp, #96]	@ 0x60
100064dc:	ed90 cb0c 	vldr	d12, [r0, #48]	@ 0x30
100064e0:	ee02 0b4c 	vmls.f64	d0, d2, d12
100064e4:	ee26 cb05 	vmul.f64	d12, d6, d5
100064e8:	eebc cbcc 	vcvt.u32.f64	s24, d12
100064ec:	ed90 2b08 	vldr	d2, [r0, #32]
100064f0:	ed9d db04 	vldr	d13, [sp, #16]
100064f4:	eeb8 cb4c 	vcvt.f64.u32	d12, s24
100064f8:	ee0d 4b42 	vmls.f64	d4, d13, d2
100064fc:	ee0c 6b47 	vmls.f64	d6, d12, d7
10006500:	ed90 2b12 	vldr	d2, [r0, #72]	@ 0x48
10006504:	ee36 6b0a 	vadd.f64	d6, d6, d10
10006508:	ee0f 0b42 	vmls.f64	d0, d15, d2
1000650c:	ee24 ab05 	vmul.f64	d10, d4, d5
10006510:	ee23 2b05 	vmul.f64	d2, d3, d5
10006514:	eebc abca 	vcvt.u32.f64	s20, d10
10006518:	eebc 2bc2 	vcvt.u32.f64	s4, d2
1000651c:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10006520:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10006524:	ee0a 4b47 	vmls.f64	d4, d10, d7
10006528:	ee36 6b02 	vadd.f64	d6, d6, d2
1000652c:	ee20 ab05 	vmul.f64	d10, d0, d5
10006530:	ee02 3b47 	vmls.f64	d3, d2, d7
10006534:	ee36 6b09 	vadd.f64	d6, d6, d9
10006538:	ed9d 2b1a 	vldr	d2, [sp, #104]	@ 0x68
1000653c:	ed90 9b16 	vldr	d9, [r0, #88]	@ 0x58
10006540:	eebc abca 	vcvt.u32.f64	s20, d10
10006544:	ee02 6b49 	vmls.f64	d6, d2, d9
10006548:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
1000654c:	ee38 2b0b 	vadd.f64	d2, d8, d11
10006550:	ee0a 0b47 	vmls.f64	d0, d10, d7
10006554:	ee22 ab05 	vmul.f64	d10, d2, d5
10006558:	ee3b 9b07 	vadd.f64	d9, d11, d7
1000655c:	e00c      	b.n	10006578 <fp64e_cmul_prepared+0x458>
1000655e:	bf00      	nop
10006560:	00000000 	.word	0x00000000
10006564:	3df00000 	.word	0x3df00000
10006568:	00000000 	.word	0x00000000
1000656c:	41f00000 	.word	0x41f00000
10006570:	00000000 	.word	0x00000000
10006574:	42000000 	.word	0x42000000
10006578:	eebc abca 	vcvt.u32.f64	s20, d10
1000657c:	ee39 9b48 	vsub.f64	d9, d9, d8
10006580:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10006584:	ed90 8b1c 	vldr	d8, [r0, #112]	@ 0x70
10006588:	ed9d bb00 	vldr	d11, [sp]
1000658c:	ee0a 2b47 	vmls.f64	d2, d10, d7
10006590:	ee0b 6b48 	vmls.f64	d6, d11, d8
10006594:	ee33 3b07 	vadd.f64	d3, d3, d7
10006598:	ee30 8b04 	vadd.f64	d8, d0, d4
1000659c:	ee33 3b42 	vsub.f64	d3, d3, d2
100065a0:	ee38 8b0a 	vadd.f64	d8, d8, d10
100065a4:	ee26 2b05 	vmul.f64	d2, d6, d5
100065a8:	ee34 4b07 	vadd.f64	d4, d4, d7
100065ac:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100065b0:	ee34 0b40 	vsub.f64	d0, d4, d0
100065b4:	ee28 4b05 	vmul.f64	d4, d8, d5
100065b8:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100065bc:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100065c0:	ee02 6b47 	vmls.f64	d6, d2, d7
100065c4:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100065c8:	ee36 2b07 	vadd.f64	d2, d6, d7
100065cc:	ee04 8b47 	vmls.f64	d8, d4, d7
100065d0:	ee29 6b05 	vmul.f64	d6, d9, d5
100065d4:	ee23 4b05 	vmul.f64	d4, d3, d5
100065d8:	ee32 2b48 	vsub.f64	d2, d2, d8
100065dc:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100065e0:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100065e4:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100065e8:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100065ec:	ee30 0b41 	vsub.f64	d0, d0, d1
100065f0:	ee32 2b41 	vsub.f64	d2, d2, d1
100065f4:	ee30 0b06 	vadd.f64	d0, d0, d6
100065f8:	ee32 2b04 	vadd.f64	d2, d2, d4
100065fc:	eeb0 1b49 	vmov.f64	d1, d9
10006600:	ee06 1b47 	vmls.f64	d1, d6, d7
10006604:	ee20 6b05 	vmul.f64	d6, d0, d5
10006608:	ee22 5b05 	vmul.f64	d5, d2, d5
1000660c:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006610:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10006614:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006618:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000661c:	ee06 0b47 	vmls.f64	d0, d6, d7
10006620:	ee04 3b47 	vmls.f64	d3, d4, d7
10006624:	ee05 2b47 	vmls.f64	d2, d5, d7
10006628:	b034      	add	sp, #208	@ 0xd0
1000662a:	ecbd 8b10 	vpop	{d8-d15}
1000662e:	4770      	bx	lr

