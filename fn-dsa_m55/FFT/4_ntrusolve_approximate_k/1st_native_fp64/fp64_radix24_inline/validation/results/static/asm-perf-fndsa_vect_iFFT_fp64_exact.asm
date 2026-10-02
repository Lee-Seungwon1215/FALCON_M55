
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/asm-perf/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10007178 <fndsa_vect_iFFT_fp64_exact>:
10007178:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
1000717c:	ed2d 8b10 	vpush	{d8-d15}
10007180:	1e44      	subs	r4, r0, #1
10007182:	b0ad      	sub	sp, #180	@ 0xb4
10007184:	f000 82a5 	beq.w	100076d2 <fndsa_vect_iFFT_fp64_exact+0x55a>
10007188:	2310      	movs	r3, #16
1000718a:	460d      	mov	r5, r1
1000718c:	f04f 0e01 	mov.w	lr, #1
10007190:	ed9f db79 	vldr	d13, [pc, #484]	@ 10007378 <fndsa_vect_iFFT_fp64_exact+0x200>
10007194:	ed9f cb7a 	vldr	d12, [pc, #488]	@ 10007380 <fndsa_vect_iFFT_fp64_exact+0x208>
10007198:	ed9f fb7b 	vldr	d15, [pc, #492]	@ 10007388 <fndsa_vect_iFFT_fp64_exact+0x210>
1000719c:	ed9f eb7c 	vldr	d14, [pc, #496]	@ 10007390 <fndsa_vect_iFFT_fp64_exact+0x218>
100071a0:	fa03 f204 	lsl.w	r2, r3, r4
100071a4:	f04f 0910 	mov.w	r9, #16
100071a8:	4670      	mov	r0, lr
100071aa:	2301      	movs	r3, #1
100071ac:	4984      	ldr	r1, [pc, #528]	@ (100073c0 <fndsa_vect_iFFT_fp64_exact+0x248>)
100071ae:	fa09 f904 	lsl.w	r9, r9, r4
100071b2:	e9cd 0403 	strd	r0, r4, [sp, #12]
100071b6:	eb05 1800 	add.w	r8, r5, r0, lsl #4
100071ba:	eb09 0a01 	add.w	sl, r9, r1
100071be:	4628      	mov	r0, r5
100071c0:	f04f 0b00 	mov.w	fp, #0
100071c4:	4691      	mov	r9, r2
100071c6:	fa0e fe03 	lsl.w	lr, lr, r3
100071ca:	40a3      	lsls	r3, r4
100071cc:	eb03 0353 	add.w	r3, r3, r3, lsr #1
100071d0:	eb01 1303 	add.w	r3, r1, r3, lsl #4
100071d4:	e9cd e301 	strd	lr, r3, [sp, #4]
100071d8:	ea4f 170e 	mov.w	r7, lr, lsl #4
100071dc:	9505      	str	r5, [sp, #20]
100071de:	edda 7a02 	vldr	s15, [sl, #8]
100071e2:	f8da 3004 	ldr.w	r3, [sl, #4]
100071e6:	eeb8 5b67 	vcvt.f64.u32	d5, s15
100071ea:	0fdb      	lsrs	r3, r3, #31
100071ec:	ee03 3a10 	vmov	s6, r3
100071f0:	ee3d 5b45 	vsub.f64	d5, d13, d5
100071f4:	eeb8 3bc3 	vcvt.f64.s32	d3, s6
100071f8:	edda 7a03 	vldr	s15, [sl, #12]
100071fc:	ed8d 3b16 	vstr	d3, [sp, #88]	@ 0x58
10007200:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10007204:	ee25 3b0c 	vmul.f64	d3, d5, d12
10007208:	eeb7 bb00 	vmov.f64	d11, #112	@ 0x3f800000  1.0
1000720c:	edda 6a00 	vldr	s13, [sl]
10007210:	edda 4a01 	vldr	s9, [sl, #4]
10007214:	ee3d 7b47 	vsub.f64	d7, d13, d7
10007218:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000721c:	eeb8 6b66 	vcvt.f64.u32	d6, s13
10007220:	eeb8 4b64 	vcvt.f64.u32	d4, s9
10007224:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10007228:	ed9f 0b5b 	vldr	d0, [pc, #364]	@ 10007398 <fndsa_vect_iFFT_fp64_exact+0x220>
1000722c:	ed9f 8b5c 	vldr	d8, [pc, #368]	@ 100073a0 <fndsa_vect_iFFT_fp64_exact+0x228>
10007230:	ee37 7b4b 	vsub.f64	d7, d7, d11
10007234:	ee03 5b4d 	vmls.f64	d5, d3, d13
10007238:	ee37 7b03 	vadd.f64	d7, d7, d3
1000723c:	ee24 2b00 	vmul.f64	d2, d4, d0
10007240:	ee26 3b08 	vmul.f64	d3, d6, d8
10007244:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10007248:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000724c:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10007250:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10007254:	ed9f 9b54 	vldr	d9, [pc, #336]	@ 100073a8 <fndsa_vect_iFFT_fp64_exact+0x230>
10007258:	eeb0 1b44 	vmov.f64	d1, d4
1000725c:	ed9f ab54 	vldr	d10, [pc, #336]	@ 100073b0 <fndsa_vect_iFFT_fp64_exact+0x238>
10007260:	ee02 1b49 	vmls.f64	d1, d2, d9
10007264:	ed8d 2b12 	vstr	d2, [sp, #72]	@ 0x48
10007268:	eeb0 2b43 	vmov.f64	d2, d3
1000726c:	ee01 2b0a 	vmla.f64	d2, d1, d10
10007270:	ed9f 1b51 	vldr	d1, [pc, #324]	@ 100073b8 <fndsa_vect_iFFT_fp64_exact+0x240>
10007274:	ed8d 2b10 	vstr	d2, [sp, #64]	@ 0x40
10007278:	eeb0 2b46 	vmov.f64	d2, d6
1000727c:	ee03 2b41 	vmls.f64	d2, d3, d1
10007280:	ee27 3b0c 	vmul.f64	d3, d7, d12
10007284:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10007288:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000728c:	ee03 7b4d 	vmls.f64	d7, d3, d13
10007290:	eebc 3bc7 	vcvt.u32.f64	s6, d7
10007294:	ee13 2a10 	vmov	r2, s6
10007298:	0fd2      	lsrs	r2, r2, #31
1000729a:	ee03 2a10 	vmov	s6, r2
1000729e:	ed8d 6b14 	vstr	d6, [sp, #80]	@ 0x50
100072a2:	eeb8 3bc3 	vcvt.f64.s32	d3, s6
100072a6:	ee35 6b06 	vadd.f64	d6, d5, d6
100072aa:	ed8d 3b20 	vstr	d3, [sp, #128]	@ 0x80
100072ae:	ee26 3b0c 	vmul.f64	d3, d6, d12
100072b2:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100072b6:	ee37 4b04 	vadd.f64	d4, d7, d4
100072ba:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100072be:	ee34 4b03 	vadd.f64	d4, d4, d3
100072c2:	ee03 6b4d 	vmls.f64	d6, d3, d13
100072c6:	ed8d 2b0e 	vstr	d2, [sp, #56]	@ 0x38
100072ca:	ee24 2b0c 	vmul.f64	d2, d4, d12
100072ce:	ee26 3b08 	vmul.f64	d3, d6, d8
100072d2:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100072d6:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100072da:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100072de:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100072e2:	ee02 4b4d 	vmls.f64	d4, d2, d13
100072e6:	ed9f 2b34 	vldr	d2, [pc, #208]	@ 100073b8 <fndsa_vect_iFFT_fp64_exact+0x240>
100072ea:	ed8d 6b28 	vstr	d6, [sp, #160]	@ 0xa0
100072ee:	ee03 6b42 	vmls.f64	d6, d3, d2
100072f2:	ed8d 6b22 	vstr	d6, [sp, #136]	@ 0x88
100072f6:	eebc 6bc4 	vcvt.u32.f64	s12, d4
100072fa:	ee16 2a10 	vmov	r2, s12
100072fe:	0fd2      	lsrs	r2, r2, #31
10007300:	ee06 2a10 	vmov	s12, r2
10007304:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10007308:	ed8d 6b2a 	vstr	d6, [sp, #168]	@ 0xa8
1000730c:	ee27 6b00 	vmul.f64	d6, d7, d0
10007310:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007314:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10007318:	ee06 7b49 	vmls.f64	d7, d6, d9
1000731c:	ed8d 6b1c 	vstr	d6, [sp, #112]	@ 0x70
10007320:	ee24 6b00 	vmul.f64	d6, d4, d0
10007324:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007328:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000732c:	ee06 4b49 	vmls.f64	d4, d6, d9
10007330:	ed8d 6b26 	vstr	d6, [sp, #152]	@ 0x98
10007334:	ee25 6b08 	vmul.f64	d6, d5, d8
10007338:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000733c:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10007340:	ed8d 5b1e 	vstr	d5, [sp, #120]	@ 0x78
10007344:	ee04 3b0a 	vmla.f64	d3, d4, d10
10007348:	ee06 5b42 	vmls.f64	d5, d6, d2
1000734c:	ee07 6b0a 	vmla.f64	d6, d7, d10
10007350:	9b03      	ldr	r3, [sp, #12]
10007352:	ed8d 3b24 	vstr	d3, [sp, #144]	@ 0x90
10007356:	445b      	add	r3, fp
10007358:	459b      	cmp	fp, r3
1000735a:	ed8d 5b18 	vstr	d5, [sp, #96]	@ 0x60
1000735e:	ed8d 6b1a 	vstr	d6, [sp, #104]	@ 0x68
10007362:	f080 81a4 	bcs.w	100076ae <fndsa_vect_iFFT_fp64_exact+0x536>
10007366:	4601      	mov	r1, r0
10007368:	4646      	mov	r6, r8
1000736a:	eb09 0508 	add.w	r5, r9, r8
1000736e:	9000      	str	r0, [sp, #0]
10007370:	eb09 0400 	add.w	r4, r9, r0
10007374:	e026      	b.n	100073c4 <fndsa_vect_iFFT_fp64_exact+0x24c>
10007376:	bf00      	nop
10007378:	00000000 	.word	0x00000000
1000737c:	41f00000 	.word	0x41f00000
10007380:	00000000 	.word	0x00000000
10007384:	3df00000 	.word	0x3df00000
	...
10007394:	41e00000 	.word	0x41e00000
10007398:	00000000 	.word	0x00000000
1000739c:	3ef00000 	.word	0x3ef00000
100073a0:	00000000 	.word	0x00000000
100073a4:	3e700000 	.word	0x3e700000
100073a8:	00000000 	.word	0x00000000
100073ac:	40f00000 	.word	0x40f00000
100073b0:	00000000 	.word	0x00000000
100073b4:	40700000 	.word	0x40700000
100073b8:	00000000 	.word	0x00000000
100073bc:	41700000 	.word	0x41700000
100073c0:	300039a0 	.word	0x300039a0
100073c4:	ed91 3b02 	vldr	d3, [r1, #8]
100073c8:	ed96 6b02 	vldr	d6, [r6, #8]
100073cc:	ed95 5b02 	vldr	d5, [r5, #8]
100073d0:	ed94 2b02 	vldr	d2, [r4, #8]
100073d4:	ee33 7b0d 	vadd.f64	d7, d3, d13
100073d8:	ee33 3b06 	vadd.f64	d3, d3, d6
100073dc:	ee37 7b46 	vsub.f64	d7, d7, d6
100073e0:	ee35 6b02 	vadd.f64	d6, d5, d2
100073e4:	ee26 0b0c 	vmul.f64	d0, d6, d12
100073e8:	ee32 2b0d 	vadd.f64	d2, d2, d13
100073ec:	eebc 0bc0 	vcvt.u32.f64	s0, d0
100073f0:	ee32 2b45 	vsub.f64	d2, d2, d5
100073f4:	eeb8 0b40 	vcvt.f64.u32	d0, s0
100073f8:	ee27 5b0c 	vmul.f64	d5, d7, d12
100073fc:	ed91 4b00 	vldr	d4, [r1]
10007400:	ee23 1b0c 	vmul.f64	d1, d3, d12
10007404:	ee00 6b4d 	vmls.f64	d6, d0, d13
10007408:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000740c:	ed96 9b00 	vldr	d9, [r6]
10007410:	ee36 8b0b 	vadd.f64	d8, d6, d11
10007414:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10007418:	ee34 6b0d 	vadd.f64	d6, d4, d13
1000741c:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10007420:	ee05 7b4d 	vmls.f64	d7, d5, d13
10007424:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10007428:	ee39 4b04 	vadd.f64	d4, d9, d4
1000742c:	ee36 6b49 	vsub.f64	d6, d6, d9
10007430:	ee34 4b01 	vadd.f64	d4, d4, d1
10007434:	ee37 9b0b 	vadd.f64	d9, d7, d11
10007438:	ee01 3b4d 	vmls.f64	d3, d1, d13
1000743c:	ed94 7b00 	vldr	d7, [r4]
10007440:	ee22 1b0c 	vmul.f64	d1, d2, d12
10007444:	ee36 6b4b 	vsub.f64	d6, d6, d11
10007448:	ed95 ab00 	vldr	d10, [r5]
1000744c:	ee36 6b05 	vadd.f64	d6, d6, d5
10007450:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10007454:	ed94 5b00 	vldr	d5, [r4]
10007458:	ee37 7b0d 	vadd.f64	d7, d7, d13
1000745c:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10007460:	ee35 5b0a 	vadd.f64	d5, d5, d10
10007464:	ee37 7b4a 	vsub.f64	d7, d7, d10
10007468:	ee35 5b00 	vadd.f64	d5, d5, d0
1000746c:	ee01 2b4d 	vmls.f64	d2, d1, d13
10007470:	ee37 7b4b 	vsub.f64	d7, d7, d11
10007474:	ee32 0b0b 	vadd.f64	d0, d2, d11
10007478:	ee37 7b01 	vadd.f64	d7, d7, d1
1000747c:	ee25 2b0c 	vmul.f64	d2, d5, d12
10007480:	ee24 1b0c 	vmul.f64	d1, d4, d12
10007484:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10007488:	eebc 1bc1 	vcvt.u32.f64	s2, d1
1000748c:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10007490:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10007494:	ee02 5b4d 	vmls.f64	d5, d2, d13
10007498:	ee01 4b4d 	vmls.f64	d4, d1, d13
1000749c:	ee27 2b0c 	vmul.f64	d2, d7, d12
100074a0:	ee26 1b0c 	vmul.f64	d1, d6, d12
100074a4:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100074a8:	eebc 1bc1 	vcvt.u32.f64	s2, d1
100074ac:	ee33 3b0b 	vadd.f64	d3, d3, d11
100074b0:	eeb8 1b41 	vcvt.f64.u32	d1, s2
100074b4:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100074b8:	ee01 6b4d 	vmls.f64	d6, d1, d13
100074bc:	ee02 7b4d 	vmls.f64	d7, d2, d13
100074c0:	ee28 1b0c 	vmul.f64	d1, d8, d12
100074c4:	ee23 2b0c 	vmul.f64	d2, d3, d12
100074c8:	eebc 1bc1 	vcvt.u32.f64	s2, d1
100074cc:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100074d0:	eeb8 1b41 	vcvt.f64.u32	d1, s2
100074d4:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100074d8:	ee34 4b0f 	vadd.f64	d4, d4, d15
100074dc:	ee01 8b4d 	vmls.f64	d8, d1, d13
100074e0:	ee34 4b02 	vadd.f64	d4, d4, d2
100074e4:	ee02 3b4d 	vmls.f64	d3, d2, d13
100074e8:	ee35 5b0f 	vadd.f64	d5, d5, d15
100074ec:	eeb6 2b00 	vmov.f64	d2, #96	@ 0x3f000000  0.5
100074f0:	ee35 5b01 	vadd.f64	d5, d5, d1
100074f4:	ee23 3b02 	vmul.f64	d3, d3, d2
100074f8:	eeb0 1b42 	vmov.f64	d1, d2
100074fc:	ee28 2b02 	vmul.f64	d2, d8, d2
10007500:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10007504:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10007508:	eeb8 8b43 	vcvt.f64.u32	d8, s6
1000750c:	eeb8 ab42 	vcvt.f64.u32	d10, s4
10007510:	ee29 3b0c 	vmul.f64	d3, d9, d12
10007514:	ee20 2b0c 	vmul.f64	d2, d0, d12
10007518:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000751c:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10007520:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10007524:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10007528:	ee36 6b0f 	vadd.f64	d6, d6, d15
1000752c:	ee37 7b0f 	vadd.f64	d7, d7, d15
10007530:	ee36 6b03 	vadd.f64	d6, d6, d3
10007534:	ee03 9b4d 	vmls.f64	d9, d3, d13
10007538:	ee02 0b4d 	vmls.f64	d0, d2, d13
1000753c:	eeb0 3b41 	vmov.f64	d3, d1
10007540:	ee37 7b02 	vadd.f64	d7, d7, d2
10007544:	ee24 2b0c 	vmul.f64	d2, d4, d12
10007548:	ee20 0b03 	vmul.f64	d0, d0, d3
1000754c:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10007550:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10007554:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10007558:	eeb8 3b40 	vcvt.f64.u32	d3, s0
1000755c:	ee25 0b0c 	vmul.f64	d0, d5, d12
10007560:	ee02 4b4d 	vmls.f64	d4, d2, d13
10007564:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10007568:	eefc 4bc4 	vcvt.u32.f64	s9, d4
1000756c:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10007570:	ee14 ca90 	vmov	ip, s9
10007574:	ee00 5b4d 	vmls.f64	d5, d0, d13
10007578:	ea4f 72dc 	mov.w	r2, ip, lsr #31
1000757c:	ee04 2a10 	vmov	s8, r2
10007580:	ea4f 025c 	mov.w	r2, ip, lsr #1
10007584:	eefc 5bc5 	vcvt.u32.f64	s11, d5
10007588:	ee05 2a10 	vmov	s10, r2
1000758c:	ee15 3a90 	vmov	r3, s11
10007590:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
10007594:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
10007598:	ee04 5b0e 	vmla.f64	d5, d4, d14
1000759c:	f00c 0e01 	and.w	lr, ip, #1
100075a0:	ed81 5b00 	vstr	d5, [r1]
100075a4:	ee05 ea90 	vmov	s11, lr
100075a8:	eeb8 5be5 	vcvt.f64.s32	d5, s11
100075ac:	0fda      	lsrs	r2, r3, #31
100075ae:	ea4f 0c53 	mov.w	ip, r3, lsr #1
100075b2:	ee05 8b0e 	vmla.f64	d8, d5, d14
100075b6:	ee04 2a10 	vmov	s8, r2
100075ba:	ee05 ca90 	vmov	s11, ip
100075be:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
100075c2:	eeb8 5be5 	vcvt.f64.s32	d5, s11
100075c6:	ee04 5b0e 	vmla.f64	d5, d4, d14
100075ca:	f003 0301 	and.w	r3, r3, #1
100075ce:	ed81 8b02 	vstr	d8, [r1, #8]
100075d2:	ed84 5b00 	vstr	d5, [r4]
100075d6:	ee05 3a90 	vmov	s11, r3
100075da:	eeb8 5be5 	vcvt.f64.s32	d5, s11
100075de:	ee05 ab0e 	vmla.f64	d10, d5, d14
100075e2:	ee26 5b0c 	vmul.f64	d5, d6, d12
100075e6:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100075ea:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100075ee:	ee05 6b4d 	vmls.f64	d6, d5, d13
100075f2:	ee27 5b0c 	vmul.f64	d5, d7, d12
100075f6:	eefc 6bc6 	vcvt.u32.f64	s13, d6
100075fa:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100075fe:	ee16 3a90 	vmov	r3, s13
10007602:	eeb8 6b45 	vcvt.f64.u32	d6, s10
10007606:	ee06 7b4d 	vmls.f64	d7, d6, d13
1000760a:	eefc 7bc7 	vcvt.u32.f64	s15, d7
1000760e:	0fda      	lsrs	r2, r3, #31
10007610:	ee05 2a10 	vmov	s10, r2
10007614:	085a      	lsrs	r2, r3, #1
10007616:	f003 0301 	and.w	r3, r3, #1
1000761a:	ee06 3a90 	vmov	s13, r3
1000761e:	ee17 3a90 	vmov	r3, s15
10007622:	ee00 2a10 	vmov	s0, r2
10007626:	0fda      	lsrs	r2, r3, #31
10007628:	ee07 2a10 	vmov	s14, r2
1000762c:	085a      	lsrs	r2, r3, #1
1000762e:	ee02 2a10 	vmov	s4, r2
10007632:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10007636:	ee29 1b01 	vmul.f64	d1, d9, d1
1000763a:	eeb8 2bc2 	vcvt.f64.s32	d2, s4
1000763e:	f003 0301 	and.w	r3, r3, #1
10007642:	ee07 2b0e 	vmla.f64	d2, d7, d14
10007646:	eebc 1bc1 	vcvt.u32.f64	s2, d1
1000764a:	ee07 3a90 	vmov	s15, r3
1000764e:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
10007652:	eeb8 6be6 	vcvt.f64.s32	d6, s13
10007656:	eeb8 7be7 	vcvt.f64.s32	d7, s15
1000765a:	eeb8 1b41 	vcvt.f64.u32	d1, s2
1000765e:	eeb8 0bc0 	vcvt.f64.s32	d0, s0
10007662:	ee06 1b0e 	vmla.f64	d1, d6, d14
10007666:	ee05 0b0e 	vmla.f64	d0, d5, d14
1000766a:	ee07 3b0e 	vmla.f64	d3, d7, d14
1000766e:	ed84 ab02 	vstr	d10, [r4, #8]
10007672:	a80e      	add	r0, sp, #56	@ 0x38
10007674:	f7fe fd54 	bl	10006120 <fp64e_cmul_prepared>
10007678:	3110      	adds	r1, #16
1000767a:	4588      	cmp	r8, r1
1000767c:	ed86 0b00 	vstr	d0, [r6]
10007680:	ed86 1b02 	vstr	d1, [r6, #8]
10007684:	ed8d 0b06 	vstr	d0, [sp, #24]
10007688:	ed85 2b00 	vstr	d2, [r5]
1000768c:	ed85 3b02 	vstr	d3, [r5, #8]
10007690:	ed8d 1b08 	vstr	d1, [sp, #32]
10007694:	ed8d 2b0a 	vstr	d2, [sp, #40]	@ 0x28
10007698:	ed8d 3b0c 	vstr	d3, [sp, #48]	@ 0x30
1000769c:	f104 0410 	add.w	r4, r4, #16
100076a0:	f106 0610 	add.w	r6, r6, #16
100076a4:	f105 0510 	add.w	r5, r5, #16
100076a8:	f47f ae8c 	bne.w	100073c4 <fndsa_vect_iFFT_fp64_exact+0x24c>
100076ac:	9800      	ldr	r0, [sp, #0]
100076ae:	9b01      	ldr	r3, [sp, #4]
100076b0:	f10a 0a10 	add.w	sl, sl, #16
100076b4:	449b      	add	fp, r3
100076b6:	9b02      	ldr	r3, [sp, #8]
100076b8:	4438      	add	r0, r7
100076ba:	4553      	cmp	r3, sl
100076bc:	44b8      	add	r8, r7
100076be:	f47f ad8e 	bne.w	100071de <fndsa_vect_iFFT_fp64_exact+0x66>
100076c2:	9c04      	ldr	r4, [sp, #16]
100076c4:	464a      	mov	r2, r9
100076c6:	3c01      	subs	r4, #1
100076c8:	f8dd e004 	ldr.w	lr, [sp, #4]
100076cc:	9d05      	ldr	r5, [sp, #20]
100076ce:	f47f ad69 	bne.w	100071a4 <fndsa_vect_iFFT_fp64_exact+0x2c>
100076d2:	b02d      	add	sp, #180	@ 0xb4
100076d4:	ecbd 8b10 	vpop	{d8-d15}
100076d8:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
