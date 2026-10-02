10001110 <fndsa_vect_iFFT_fp64_exact.constprop.0>:
10001110:	1e41      	subs	r1, r0, #1
10001112:	f000 8268 	beq.w	100015e6 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x4d6>
10001116:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
1000111a:	2301      	movs	r3, #1
1000111c:	ed2d 8b10 	vpush	{d8-d15}
10001120:	2210      	movs	r2, #16
10001122:	ed9f ebf3 	vldr	d14, [pc, #972]	@ 100014f0 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x3e0>
10001126:	ed9f fbf4 	vldr	d15, [pc, #976]	@ 100014f8 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x3e8>
1000112a:	ed9f 9bf5 	vldr	d9, [pc, #980]	@ 10001500 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x3f0>
1000112e:	b0af      	sub	sp, #188	@ 0xbc
10001130:	fa03 f501 	lsl.w	r5, r3, r1
10001134:	469a      	mov	sl, r3
10001136:	fa02 f301 	lsl.w	r3, r2, r1
1000113a:	9305      	str	r3, [sp, #20]
1000113c:	9507      	str	r5, [sp, #28]
1000113e:	2301      	movs	r3, #1
10001140:	f04f 0910 	mov.w	r9, #16
10001144:	4652      	mov	r2, sl
10001146:	f04f 0800 	mov.w	r8, #0
1000114a:	eeb7 db00 	vmov.f64	d13, #112	@ 0x3f800000  1.0
1000114e:	fa0a fa03 	lsl.w	sl, sl, r3
10001152:	fa03 f701 	lsl.w	r7, r3, r1
10001156:	ea4f 130a 	mov.w	r3, sl, lsl #4
1000115a:	9302      	str	r3, [sp, #8]
1000115c:	4bec      	ldr	r3, [pc, #944]	@ (10001510 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x400>)
1000115e:	eb07 0757 	add.w	r7, r7, r7, lsr #1
10001162:	fa09 f901 	lsl.w	r9, r9, r1
10001166:	eb03 1707 	add.w	r7, r3, r7, lsl #4
1000116a:	eb09 0503 	add.w	r5, r9, r3
1000116e:	4be9      	ldr	r3, [pc, #932]	@ (10001514 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x404>)
10001170:	9106      	str	r1, [sp, #24]
10001172:	eb03 1602 	add.w	r6, r3, r2, lsl #4
10001176:	9b07      	ldr	r3, [sp, #28]
10001178:	9203      	str	r2, [sp, #12]
1000117a:	1a9b      	subs	r3, r3, r2
1000117c:	9304      	str	r3, [sp, #16]
1000117e:	edd5 7a02 	vldr	s15, [r5, #8]
10001182:	686b      	ldr	r3, [r5, #4]
10001184:	eeb8 4b67 	vcvt.f64.u32	d4, s15
10001188:	0fdb      	lsrs	r3, r3, #31
1000118a:	ee03 3a10 	vmov	s6, r3
1000118e:	ee3e 4b44 	vsub.f64	d4, d14, d4
10001192:	eeb8 3bc3 	vcvt.f64.s32	d3, s6
10001196:	edd5 7a03 	vldr	s15, [r5, #12]
1000119a:	ed8d 3b18 	vstr	d3, [sp, #96]	@ 0x60
1000119e:	eeb8 7b67 	vcvt.f64.u32	d7, s15
100011a2:	ee24 3b0f 	vmul.f64	d3, d4, d15
100011a6:	ee3e 7b47 	vsub.f64	d7, d14, d7
100011aa:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100011ae:	edd5 6a00 	vldr	s13, [r5]
100011b2:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100011b6:	ee37 7b4d 	vsub.f64	d7, d7, d13
100011ba:	eeb8 5b66 	vcvt.f64.u32	d5, s13
100011be:	ee37 7b03 	vadd.f64	d7, d7, d3
100011c2:	edd5 6a01 	vldr	s13, [r5, #4]
100011c6:	ee03 4b4e 	vmls.f64	d4, d3, d14
100011ca:	eeb8 6b66 	vcvt.f64.u32	d6, s13
100011ce:	ee27 3b0f 	vmul.f64	d3, d7, d15
100011d2:	ee26 2b0f 	vmul.f64	d2, d6, d15
100011d6:	ee25 1b0f 	vmul.f64	d1, d5, d15
100011da:	ed8d 5b12 	vstr	d5, [sp, #72]	@ 0x48
100011de:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100011e2:	ee35 5b04 	vadd.f64	d5, d5, d4
100011e6:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100011ea:	ed8d 2b14 	vstr	d2, [sp, #80]	@ 0x50
100011ee:	ed8d 4b1c 	vstr	d4, [sp, #112]	@ 0x70
100011f2:	ee24 2b0f 	vmul.f64	d2, d4, d15
100011f6:	ee25 4b0f 	vmul.f64	d4, d5, d15
100011fa:	ee03 7b4e 	vmls.f64	d7, d3, d14
100011fe:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10001202:	eefc 3bc7 	vcvt.u32.f64	s7, d7
10001206:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000120a:	ed8d 6b10 	vstr	d6, [sp, #64]	@ 0x40
1000120e:	ee36 6b07 	vadd.f64	d6, d6, d7
10001212:	9b03      	ldr	r3, [sp, #12]
10001214:	ed8d 7b1a 	vstr	d7, [sp, #104]	@ 0x68
10001218:	eb03 0108 	add.w	r1, r3, r8
1000121c:	ee13 3a90 	vmov	r3, s7
10001220:	ee27 3b0f 	vmul.f64	d3, d7, d15
10001224:	ee36 7b04 	vadd.f64	d7, d6, d4
10001228:	ee27 6b0f 	vmul.f64	d6, d7, d15
1000122c:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10001230:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10001234:	ee06 7b4e 	vmls.f64	d7, d6, d14
10001238:	eefc 6bc7 	vcvt.u32.f64	s13, d7
1000123c:	0fdb      	lsrs	r3, r3, #31
1000123e:	ee04 5b4e 	vmls.f64	d5, d4, d14
10001242:	ee04 3a10 	vmov	s8, r3
10001246:	ee16 3a90 	vmov	r3, s13
1000124a:	0fdb      	lsrs	r3, r3, #31
1000124c:	ee27 6b0f 	vmul.f64	d6, d7, d15
10001250:	ed8d 7b24 	vstr	d7, [sp, #144]	@ 0x90
10001254:	ee07 3a10 	vmov	s14, r3
10001258:	ed8d 2b20 	vstr	d2, [sp, #128]	@ 0x80
1000125c:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
10001260:	ee25 2b0f 	vmul.f64	d2, d5, d15
10001264:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10001268:	4588      	cmp	r8, r1
1000126a:	ed8d 1b16 	vstr	d1, [sp, #88]	@ 0x58
1000126e:	ed8d 3b1e 	vstr	d3, [sp, #120]	@ 0x78
10001272:	ed8d 5b26 	vstr	d5, [sp, #152]	@ 0x98
10001276:	ed8d 4b22 	vstr	d4, [sp, #136]	@ 0x88
1000127a:	ed8d 2b2a 	vstr	d2, [sp, #168]	@ 0xa8
1000127e:	ed8d 6b28 	vstr	d6, [sp, #160]	@ 0xa0
10001282:	ed8d 7b2c 	vstr	d7, [sp, #176]	@ 0xb0
10001286:	f080 819e 	bcs.w	100015c6 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x4b6>
1000128a:	46b3      	mov	fp, r6
1000128c:	4ba1      	ldr	r3, [pc, #644]	@ (10001514 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x404>)
1000128e:	eb03 1108 	add.w	r1, r3, r8, lsl #4
10001292:	9b04      	ldr	r3, [sp, #16]
10001294:	eb06 1903 	add.w	r9, r6, r3, lsl #4
10001298:	9b05      	ldr	r3, [sp, #20]
1000129a:	199c      	adds	r4, r3, r6
1000129c:	ed91 ab02 	vldr	d10, [r1, #8]
100012a0:	ed9b 7b02 	vldr	d7, [fp, #8]
100012a4:	ee3a 0b0e 	vadd.f64	d0, d10, d14
100012a8:	ed91 cb00 	vldr	d12, [r1]
100012ac:	ee3a ab07 	vadd.f64	d10, d10, d7
100012b0:	ee30 7b47 	vsub.f64	d7, d0, d7
100012b4:	ed9b 3b00 	vldr	d3, [fp]
100012b8:	ee3c 1b0e 	vadd.f64	d1, d12, d14
100012bc:	ee27 2b0f 	vmul.f64	d2, d7, d15
100012c0:	ee33 cb0c 	vadd.f64	d12, d3, d12
100012c4:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100012c8:	ee31 3b43 	vsub.f64	d3, d1, d3
100012cc:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100012d0:	ee33 3b4d 	vsub.f64	d3, d3, d13
100012d4:	ee33 3b02 	vadd.f64	d3, d3, d2
100012d8:	ee02 7b4e 	vmls.f64	d7, d2, d14
100012dc:	ee23 1b0f 	vmul.f64	d1, d3, d15
100012e0:	ee37 7b0d 	vadd.f64	d7, d7, d13
100012e4:	eebc 1bc1 	vcvt.u32.f64	s2, d1
100012e8:	ed99 bb02 	vldr	d11, [r9, #8]
100012ec:	ee27 2b0f 	vmul.f64	d2, d7, d15
100012f0:	eeb8 1b41 	vcvt.f64.u32	d1, s2
100012f4:	ed94 5b02 	vldr	d5, [r4, #8]
100012f8:	eefc 0bc2 	vcvt.u32.f64	s1, d2
100012fc:	ee01 3b4e 	vmls.f64	d3, d1, d14
10001300:	ee3b 2b0e 	vadd.f64	d2, d11, d14
10001304:	ed9f 4b80 	vldr	d4, [pc, #512]	@ 10001508 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x3f8>
10001308:	ee35 bb0b 	vadd.f64	d11, d5, d11
1000130c:	ee32 2b45 	vsub.f64	d2, d2, d5
10001310:	ee33 3b04 	vadd.f64	d3, d3, d4
10001314:	eeb8 5b60 	vcvt.f64.u32	d5, s1
10001318:	ed94 8b00 	vldr	d8, [r4]
1000131c:	ed99 6b00 	vldr	d6, [r9]
10001320:	ee33 3b05 	vadd.f64	d3, d3, d5
10001324:	ee36 4b0e 	vadd.f64	d4, d6, d14
10001328:	ee23 0b0f 	vmul.f64	d0, d3, d15
1000132c:	ee36 6b08 	vadd.f64	d6, d6, d8
10001330:	ee05 7b4e 	vmls.f64	d7, d5, d14
10001334:	ee22 5b0f 	vmul.f64	d5, d2, d15
10001338:	ed8d 6b00 	vstr	d6, [sp]
1000133c:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10001340:	eeb6 6b00 	vmov.f64	d6, #96	@ 0x3f000000  0.5
10001344:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10001348:	ee27 7b06 	vmul.f64	d7, d7, d6
1000134c:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10001350:	ee34 6b48 	vsub.f64	d6, d4, d8
10001354:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10001358:	ee00 3b4e 	vmls.f64	d3, d0, d14
1000135c:	ee36 6b4d 	vsub.f64	d6, d6, d13
10001360:	ee05 2b4e 	vmls.f64	d2, d5, d14
10001364:	ee36 6b05 	vadd.f64	d6, d6, d5
10001368:	eefc 5bc3 	vcvt.u32.f64	s11, d3
1000136c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10001370:	ee32 2b0d 	vadd.f64	d2, d2, d13
10001374:	ee15 3a90 	vmov	r3, s11
10001378:	eeb8 1b47 	vcvt.f64.u32	d1, s14
1000137c:	ee22 7b0f 	vmul.f64	d7, d2, d15
10001380:	0fda      	lsrs	r2, r3, #31
10001382:	eefc 3bc7 	vcvt.u32.f64	s7, d7
10001386:	ee07 2a10 	vmov	s14, r2
1000138a:	085a      	lsrs	r2, r3, #1
1000138c:	ee00 2a10 	vmov	s0, r2
10001390:	ee26 4b0f 	vmul.f64	d4, d6, d15
10001394:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10001398:	eeb8 0bc0 	vcvt.f64.s32	d0, s0
1000139c:	f003 0301 	and.w	r3, r3, #1
100013a0:	ee07 0b09 	vmla.f64	d0, d7, d9
100013a4:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100013a8:	ee07 3a90 	vmov	s15, r3
100013ac:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100013b0:	eeb8 7be7 	vcvt.f64.s32	d7, s15
100013b4:	ee04 6b4e 	vmls.f64	d6, d4, d14
100013b8:	ee07 1b09 	vmla.f64	d1, d7, d9
100013bc:	ed9f 7b52 	vldr	d7, [pc, #328]	@ 10001508 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x3f8>
100013c0:	eeb8 4b63 	vcvt.f64.u32	d4, s7
100013c4:	ee36 6b07 	vadd.f64	d6, d6, d7
100013c8:	ee36 7b04 	vadd.f64	d7, d6, d4
100013cc:	ee2a 5b0f 	vmul.f64	d5, d10, d15
100013d0:	ee04 2b4e 	vmls.f64	d2, d4, d14
100013d4:	ee27 4b0f 	vmul.f64	d4, d7, d15
100013d8:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100013dc:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100013e0:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100013e4:	eeb6 6b00 	vmov.f64	d6, #96	@ 0x3f000000  0.5
100013e8:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100013ec:	ee22 2b06 	vmul.f64	d2, d2, d6
100013f0:	ee3c 6b05 	vadd.f64	d6, d12, d5
100013f4:	ee04 7b4e 	vmls.f64	d7, d4, d14
100013f8:	ee26 8b0f 	vmul.f64	d8, d6, d15
100013fc:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10001400:	ee05 ab4e 	vmls.f64	d10, d5, d14
10001404:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10001408:	ee3a 5b0d 	vadd.f64	d5, d10, d13
1000140c:	eeb8 3b42 	vcvt.f64.u32	d3, s4
10001410:	eebc 2bc8 	vcvt.u32.f64	s4, d8
10001414:	ee17 3a90 	vmov	r3, s15
10001418:	eeb8 2b42 	vcvt.f64.u32	d2, s4
1000141c:	ee25 4b0f 	vmul.f64	d4, d5, d15
10001420:	0fda      	lsrs	r2, r3, #31
10001422:	ee08 2a10 	vmov	s16, r2
10001426:	085a      	lsrs	r2, r3, #1
10001428:	ee02 6b4e 	vmls.f64	d6, d2, d14
1000142c:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10001430:	ee02 2a10 	vmov	s4, r2
10001434:	ed9f 7b34 	vldr	d7, [pc, #208]	@ 10001508 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x3f8>
10001438:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000143c:	eeb8 8bc8 	vcvt.f64.s32	d8, s16
10001440:	eeb8 2bc2 	vcvt.f64.s32	d2, s4
10001444:	ee36 6b07 	vadd.f64	d6, d6, d7
10001448:	ee08 2b09 	vmla.f64	d2, d8, d9
1000144c:	eeb6 ab00 	vmov.f64	d10, #96	@ 0x3f000000  0.5
10001450:	ee2b 8b0f 	vmul.f64	d8, d11, d15
10001454:	ee04 5b4e 	vmls.f64	d5, d4, d14
10001458:	ee36 6b04 	vadd.f64	d6, d6, d4
1000145c:	f003 0301 	and.w	r3, r3, #1
10001460:	ee25 5b0a 	vmul.f64	d5, d5, d10
10001464:	ee07 3a90 	vmov	s15, r3
10001468:	eebc 8bc8 	vcvt.u32.f64	s16, d8
1000146c:	ee26 4b0f 	vmul.f64	d4, d6, d15
10001470:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10001474:	eebc abc5 	vcvt.u32.f64	s20, d5
10001478:	eeb8 7be7 	vcvt.f64.s32	d7, s15
1000147c:	ed9d 5b00 	vldr	d5, [sp]
10001480:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10001484:	ee07 3b09 	vmla.f64	d3, d7, d9
10001488:	ee35 7b08 	vadd.f64	d7, d5, d8
1000148c:	eeb0 5b4b 	vmov.f64	d5, d11
10001490:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10001494:	ee08 5b4e 	vmls.f64	d5, d8, d14
10001498:	ee27 cb0f 	vmul.f64	d12, d7, d15
1000149c:	ee04 6b4e 	vmls.f64	d6, d4, d14
100014a0:	ee35 5b0d 	vadd.f64	d5, d5, d13
100014a4:	eebc cbcc 	vcvt.u32.f64	s24, d12
100014a8:	eefc 6bc6 	vcvt.u32.f64	s13, d6
100014ac:	ee25 4b0f 	vmul.f64	d4, d5, d15
100014b0:	eeb8 cb4c 	vcvt.f64.u32	d12, s24
100014b4:	ee16 3a90 	vmov	r3, s13
100014b8:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100014bc:	ed9f 6b12 	vldr	d6, [pc, #72]	@ 10001508 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x3f8>
100014c0:	ee0c 7b4e 	vmls.f64	d7, d12, d14
100014c4:	0fda      	lsrs	r2, r3, #31
100014c6:	eeb8 bb4a 	vcvt.f64.u32	d11, s20
100014ca:	ee0a 2a10 	vmov	s20, r2
100014ce:	085a      	lsrs	r2, r3, #1
100014d0:	f003 0301 	and.w	r3, r3, #1
100014d4:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100014d8:	ee37 7b06 	vadd.f64	d7, d7, d6
100014dc:	ee06 3a90 	vmov	s13, r3
100014e0:	ee37 7b04 	vadd.f64	d7, d7, d4
100014e4:	eeb8 6be6 	vcvt.f64.s32	d6, s13
100014e8:	ee06 bb09 	vmla.f64	d11, d6, d9
100014ec:	e014      	b.n	10001518 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x408>
100014ee:	bf00      	nop
100014f0:	00000000 	.word	0x00000000
100014f4:	41f00000 	.word	0x41f00000
100014f8:	00000000 	.word	0x00000000
100014fc:	3df00000 	.word	0x3df00000
10001500:	00000000 	.word	0x00000000
10001504:	41e00000 	.word	0x41e00000
	...
10001510:	300009a0 	.word	0x300009a0
10001514:	3001b0e0 	.word	0x3001b0e0
10001518:	ee27 6b0f 	vmul.f64	d6, d7, d15
1000151c:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10001520:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10001524:	ee08 2a10 	vmov	s16, r2
10001528:	ee06 7b4e 	vmls.f64	d7, d6, d14
1000152c:	eeb8 abca 	vcvt.f64.s32	d10, s20
10001530:	eeb8 8bc8 	vcvt.f64.s32	d8, s16
10001534:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10001538:	ee04 5b4e 	vmls.f64	d5, d4, d14
1000153c:	ee0a 8b09 	vmla.f64	d8, d10, d9
10001540:	eeb6 ab00 	vmov.f64	d10, #96	@ 0x3f000000  0.5
10001544:	ee17 3a90 	vmov	r3, s15
10001548:	ee25 5b0a 	vmul.f64	d5, d5, d10
1000154c:	0fda      	lsrs	r2, r3, #31
1000154e:	ee04 2a10 	vmov	s8, r2
10001552:	085a      	lsrs	r2, r3, #1
10001554:	f003 0301 	and.w	r3, r3, #1
10001558:	ee06 2a10 	vmov	s12, r2
1000155c:	ee07 3a90 	vmov	s15, r3
10001560:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10001564:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
10001568:	eeb8 7be7 	vcvt.f64.s32	d7, s15
1000156c:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10001570:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10001574:	ee07 5b09 	vmla.f64	d5, d7, d9
10001578:	ee04 6b09 	vmla.f64	d6, d4, d9
1000157c:	ed81 8b00 	vstr	d8, [r1]
10001580:	ed81 bb02 	vstr	d11, [r1, #8]
10001584:	a810      	add	r0, sp, #64	@ 0x40
10001586:	ed89 6b00 	vstr	d6, [r9]
1000158a:	ed89 5b02 	vstr	d5, [r9, #8]
1000158e:	f7ff f9cb 	bl	10000928 <fp64e_cmul_prepared>
10001592:	3110      	adds	r1, #16
10001594:	428e      	cmp	r6, r1
10001596:	ed8b 0b00 	vstr	d0, [fp]
1000159a:	ed8b 1b02 	vstr	d1, [fp, #8]
1000159e:	ed8d 0b08 	vstr	d0, [sp, #32]
100015a2:	ed84 2b00 	vstr	d2, [r4]
100015a6:	ed84 3b02 	vstr	d3, [r4, #8]
100015aa:	ed8d 1b0a 	vstr	d1, [sp, #40]	@ 0x28
100015ae:	ed8d 2b0c 	vstr	d2, [sp, #48]	@ 0x30
100015b2:	ed8d 3b0e 	vstr	d3, [sp, #56]	@ 0x38
100015b6:	f109 0910 	add.w	r9, r9, #16
100015ba:	f10b 0b10 	add.w	fp, fp, #16
100015be:	f104 0410 	add.w	r4, r4, #16
100015c2:	f47f ae6b 	bne.w	1000129c <fndsa_vect_iFFT_fp64_exact.constprop.0+0x18c>
100015c6:	9b02      	ldr	r3, [sp, #8]
100015c8:	3510      	adds	r5, #16
100015ca:	42af      	cmp	r7, r5
100015cc:	44d0      	add	r8, sl
100015ce:	441e      	add	r6, r3
100015d0:	f47f add5 	bne.w	1000117e <fndsa_vect_iFFT_fp64_exact.constprop.0+0x6e>
100015d4:	9906      	ldr	r1, [sp, #24]
100015d6:	3901      	subs	r1, #1
100015d8:	f47f adb1 	bne.w	1000113e <fndsa_vect_iFFT_fp64_exact.constprop.0+0x2e>
100015dc:	b02f      	add	sp, #188	@ 0xbc
100015de:	ecbd 8b10 	vpop	{d8-d15}
100015e2:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
100015e6:	4770      	bx	lr

