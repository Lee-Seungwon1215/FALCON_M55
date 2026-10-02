
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_kat_exact_inlineasm/validation/build/asm-profile/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

100072e8 <fndsa_poly_big_to_fp64_exact>:
100072e8:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
100072ec:	ed2d 8b10 	vpush	{d8-d15}
100072f0:	b0b9      	sub	sp, #228	@ 0xe4
100072f2:	4607      	mov	r7, r0
100072f4:	9d52      	ldr	r5, [sp, #328]	@ 0x148
100072f6:	4608      	mov	r0, r1
100072f8:	2b00      	cmp	r3, #0
100072fa:	f000 8272 	beq.w	100077e2 <fndsa_poly_big_to_fp64_exact+0x4fa>
100072fe:	eb05 1145 	add.w	r1, r5, r5, lsl #5
10007302:	eb01 2181 	add.w	r1, r1, r1, lsl #10
10007306:	eb05 0441 	add.w	r4, r5, r1, lsl #1
1000730a:	0d64      	lsrs	r4, r4, #21
1000730c:	4601      	mov	r1, r0
1000730e:	ebc4 1044 	rsb	r0, r4, r4, lsl #5
10007312:	1a2d      	subs	r5, r5, r0
10007314:	1e6e      	subs	r6, r5, #1
10007316:	eba4 78d6 	sub.w	r8, r4, r6, lsr #31
1000731a:	eea6 8b10 	vdup.32	q3, r8
1000731e:	ed9f 0b96 	vldr	d0, [pc, #600]	@ 10007578 <fndsa_poly_big_to_fp64_exact+0x290>
10007322:	ed9f 1b97 	vldr	d1, [pc, #604]	@ 10007580 <fndsa_poly_big_to_fp64_exact+0x298>
10007326:	ed9f 2b98 	vldr	d2, [pc, #608]	@ 10007588 <fndsa_poly_big_to_fp64_exact+0x2a0>
1000732a:	ed9f 3b99 	vldr	d3, [pc, #612]	@ 10007590 <fndsa_poly_big_to_fp64_exact+0x2a8>
1000732e:	ed9f 4b9a 	vldr	d4, [pc, #616]	@ 10007598 <fndsa_poly_big_to_fp64_exact+0x2b0>
10007332:	ed9f 5b9b 	vldr	d5, [pc, #620]	@ 100075a0 <fndsa_poly_big_to_fp64_exact+0x2b8>
10007336:	ef26 0840 	vadd.i32	q0, q3, q0
1000733a:	ef26 2842 	vadd.i32	q1, q3, q1
1000733e:	ef26 6844 	vadd.i32	q3, q3, q2
10007342:	1b18      	subs	r0, r3, r4
10007344:	17f4      	asrs	r4, r6, #31
10007346:	f004 041f 	and.w	r4, r4, #31
1000734a:	eb00 70d6 	add.w	r0, r0, r6, lsr #31
1000734e:	ea44 0605 	orr.w	r6, r4, r5
10007352:	2404      	movs	r4, #4
10007354:	eeae 7b10 	vdup.32	q7, r7
10007358:	ed8d 1f14 	vstrw.32	q0, [sp, #80]
1000735c:	ed8d 3f18 	vstrw.32	q1, [sp, #96]
10007360:	ed8d 7f1c 	vstrw.32	q3, [sp, #112]
10007364:	1e5d      	subs	r5, r3, #1
10007366:	9521      	str	r5, [sp, #132]	@ 0x84
10007368:	1e45      	subs	r5, r0, #1
1000736a:	17ed      	asrs	r5, r5, #31
1000736c:	9523      	str	r5, [sp, #140]	@ 0x8c
1000736e:	40bc      	lsls	r4, r7
10007370:	1e85      	subs	r5, r0, #2
10007372:	17c0      	asrs	r0, r0, #31
10007374:	1914      	adds	r4, r2, r4
10007376:	9022      	str	r0, [sp, #136]	@ 0x88
10007378:	17e8      	asrs	r0, r5, #31
1000737a:	1e5d      	subs	r5, r3, #1
1000737c:	40bd      	lsls	r5, r7
1000737e:	9024      	str	r0, [sp, #144]	@ 0x90
10007380:	9429      	str	r4, [sp, #164]	@ 0xa4
10007382:	1f10      	subs	r0, r2, #4
10007384:	f1c6 0420 	rsb	r4, r6, #32
10007388:	eb00 0085 	add.w	r0, r0, r5, lsl #2
1000738c:	9427      	str	r4, [sp, #156]	@ 0x9c
1000738e:	f1c6 041f 	rsb	r4, r6, #31
10007392:	9020      	str	r0, [sp, #128]	@ 0x80
10007394:	1e75      	subs	r5, r6, #1
10007396:	f108 30ff 	add.w	r0, r8, #4294967295	@ 0xffffffff
1000739a:	9428      	str	r4, [sp, #160]	@ 0xa0
1000739c:	089c      	lsrs	r4, r3, #2
1000739e:	9625      	str	r6, [sp, #148]	@ 0x94
100073a0:	f108 0901 	add.w	r9, r8, #1
100073a4:	9526      	str	r5, [sp, #152]	@ 0x98
100073a6:	942a      	str	r4, [sp, #168]	@ 0xa8
100073a8:	902b      	str	r0, [sp, #172]	@ 0xac
100073aa:	9821      	ldr	r0, [sp, #132]	@ 0x84
100073ac:	2804      	cmp	r0, #4
100073ae:	f240 8212 	bls.w	100077d6 <fndsa_poly_big_to_fp64_exact+0x4ee>
100073b2:	ef80 6050 	vmov.i32	q3, #0	@ 0x00000000
100073b6:	ed9f 8b7c 	vldr	d8, [pc, #496]	@ 100075a8 <fndsa_poly_big_to_fp64_exact+0x2c0>
100073ba:	ed9f 9b7d 	vldr	d9, [pc, #500]	@ 100075b0 <fndsa_poly_big_to_fp64_exact+0x2c8>
100073be:	982a      	ldr	r0, [sp, #168]	@ 0xa8
100073c0:	ed8d 7f08 	vstrw.32	q3, [sp, #32]
100073c4:	f040 e001 	dls	lr, r0
100073c8:	ed8d 7f04 	vstrw.32	q3, [sp, #16]
100073cc:	ed8d 7f00 	vstrw.32	q3, [sp, #0]
100073d0:	ed9f cb79 	vldr	d12, [pc, #484]	@ 100075b8 <fndsa_poly_big_to_fp64_exact+0x2d0>
100073d4:	ed9f db7a 	vldr	d13, [pc, #488]	@ 100075c0 <fndsa_poly_big_to_fp64_exact+0x2d8>
100073d8:	ed9f ab7b 	vldr	d10, [pc, #492]	@ 100075c8 <fndsa_poly_big_to_fp64_exact+0x2e0>
100073dc:	ed9f bb7c 	vldr	d11, [pc, #496]	@ 100075d0 <fndsa_poly_big_to_fp64_exact+0x2e8>
100073e0:	ed8d 9f0c 	vstrw.32	q4, [sp, #48]
100073e4:	ff2e 644a 	vshl.u32	q3, q5, q7
100073e8:	ee16 6a10 	vmov	r6, s12
100073ec:	ee36 5b10 	vmov.32	r5, d6[1]
100073f0:	ee17 4b10 	vmov.32	r4, d7[0]
100073f4:	ee37 0b10 	vmov.32	r0, d7[1]
100073f8:	ed9d 7f1c 	vldrw.u32	q3, [sp, #112]
100073fc:	ed9d 1f18 	vldrw.u32	q0, [sp, #96]
10007400:	ff0a 4156 	veor	q2, q5, q3
10007404:	ef80 6054 	vmov.i32	q3, #4	@ 0x00000004
10007408:	ef26 8156 	vmov	q4, q3
1000740c:	ef2a a846 	vadd.i32	q5, q5, q3
10007410:	ff0c 6150 	veor	q3, q6, q0
10007414:	ff87 2e5f 	vmov.i8	q1, #255	@ 0xff
10007418:	ff87 677f 	vbic.i32	q3, #4278190080	@ 0xff000000
1000741c:	ef26 6842 	vadd.i32	q3, q3, q1
10007420:	efa1 6056 	vshr.s32	q3, q3, #31
10007424:	ed9d 1f14 	vldrw.u32	q0, [sp, #80]
10007428:	ed8d 7f10 	vstrw.32	q3, [sp, #64]
1000742c:	ed9d 7f0c 	vldrw.u32	q3, [sp, #48]
10007430:	ff06 0150 	veor	q0, q3, q0
10007434:	ff87 477f 	vbic.i32	q2, #4278190080	@ 0xff000000
10007438:	ff87 077f 	vbic.i32	q0, #4278190080	@ 0xff000000
1000743c:	ef24 4842 	vadd.i32	q2, q2, q1
10007440:	ef20 0842 	vadd.i32	q0, q0, q1
10007444:	ff2e 244c 	vshl.u32	q1, q6, q7
10007448:	f852 6026 	ldr.w	r6, [r2, r6, lsl #2]
1000744c:	efa1 4054 	vshr.s32	q2, q2, #31
10007450:	9634      	str	r6, [sp, #208]	@ 0xd0
10007452:	ee12 6a10 	vmov	r6, s4
10007456:	f852 5025 	ldr.w	r5, [r2, r5, lsl #2]
1000745a:	efa1 0050 	vshr.s32	q0, q0, #31
1000745e:	9535      	str	r5, [sp, #212]	@ 0xd4
10007460:	ee32 5b10 	vmov.32	r5, d2[1]
10007464:	f852 4024 	ldr.w	r4, [r2, r4, lsl #2]
10007468:	ef2c c848 	vadd.i32	q6, q6, q4
1000746c:	9436      	str	r4, [sp, #216]	@ 0xd8
1000746e:	ee13 4b10 	vmov.32	r4, d3[0]
10007472:	f852 0020 	ldr.w	r0, [r2, r0, lsl #2]
10007476:	9037      	str	r0, [sp, #220]	@ 0xdc
10007478:	ee33 0b10 	vmov.32	r0, d3[1]
1000747c:	ff2e 2446 	vshl.u32	q1, q3, q7
10007480:	f852 6026 	ldr.w	r6, [r2, r6, lsl #2]
10007484:	ef26 6848 	vadd.i32	q3, q3, q4
10007488:	9630      	str	r6, [sp, #192]	@ 0xc0
1000748a:	f852 5025 	ldr.w	r5, [r2, r5, lsl #2]
1000748e:	ee12 6a10 	vmov	r6, s4
10007492:	9531      	str	r5, [sp, #196]	@ 0xc4
10007494:	f852 4024 	ldr.w	r4, [r2, r4, lsl #2]
10007498:	ee32 5b10 	vmov.32	r5, d2[1]
1000749c:	9432      	str	r4, [sp, #200]	@ 0xc8
1000749e:	f852 0020 	ldr.w	r0, [r2, r0, lsl #2]
100074a2:	ee13 4b10 	vmov.32	r4, d3[0]
100074a6:	9033      	str	r0, [sp, #204]	@ 0xcc
100074a8:	ee33 0b10 	vmov.32	r0, d3[1]
100074ac:	ed9d 3f34 	vldrw.u32	q1, [sp, #208]
100074b0:	ef02 2154 	vand	q1, q1, q2
100074b4:	ed9d 5f00 	vldrw.u32	q2, [sp, #0]
100074b8:	ef24 4152 	vorr	q2, q2, q1
100074bc:	f852 6026 	ldr.w	r6, [r2, r6, lsl #2]
100074c0:	ed8d 7f0c 	vstrw.32	q3, [sp, #48]
100074c4:	962c      	str	r6, [sp, #176]	@ 0xb0
100074c6:	f852 5025 	ldr.w	r5, [r2, r5, lsl #2]
100074ca:	952d      	str	r5, [sp, #180]	@ 0xb4
100074cc:	f852 4024 	ldr.w	r4, [r2, r4, lsl #2]
100074d0:	942e      	str	r4, [sp, #184]	@ 0xb8
100074d2:	f852 0020 	ldr.w	r0, [r2, r0, lsl #2]
100074d6:	902f      	str	r0, [sp, #188]	@ 0xbc
100074d8:	ed8d 5f00 	vstrw.32	q2, [sp, #0]
100074dc:	ed9d 7f10 	vldrw.u32	q3, [sp, #64]
100074e0:	ed9d 5f30 	vldrw.u32	q2, [sp, #192]
100074e4:	ef04 4156 	vand	q2, q2, q3
100074e8:	ed9d 7f04 	vldrw.u32	q3, [sp, #16]
100074ec:	ef26 6154 	vorr	q3, q3, q2
100074f0:	ed8d 7f04 	vstrw.32	q3, [sp, #16]
100074f4:	ed9d 7f2c 	vldrw.u32	q3, [sp, #176]
100074f8:	ed9d 5f08 	vldrw.u32	q2, [sp, #32]
100074fc:	ef06 6150 	vand	q3, q3, q0
10007500:	ef24 6156 	vorr	q3, q2, q3
10007504:	ed8d 7f08 	vstrw.32	q3, [sp, #32]
10007508:	f00f c095 	le	lr, 100073e4 <fndsa_poly_big_to_fp64_exact+0xfc>
1000750c:	ed9d 7f00 	vldrw.u32	q3, [sp, #0]
10007510:	ed9d 5f04 	vldrw.u32	q2, [sp, #16]
10007514:	ee37 0b10 	vmov.32	r0, d7[1]
10007518:	ee16 6a10 	vmov	r6, s12
1000751c:	ee36 5b10 	vmov.32	r5, d6[1]
10007520:	4306      	orrs	r6, r0
10007522:	ee14 0a10 	vmov	r0, s8
10007526:	ee34 cb10 	vmov.32	ip, d4[1]
1000752a:	4305      	orrs	r5, r0
1000752c:	ee17 0b10 	vmov.32	r0, d7[0]
10007530:	ea40 000c 	orr.w	r0, r0, ip
10007534:	ee15 cb10 	vmov.32	ip, d5[0]
10007538:	ed9d 7f08 	vldrw.u32	q3, [sp, #32]
1000753c:	ea46 060c 	orr.w	r6, r6, ip
10007540:	ee35 cb10 	vmov.32	ip, d5[1]
10007544:	ea45 050c 	orr.w	r5, r5, ip
10007548:	ee16 ca10 	vmov	ip, s12
1000754c:	ea40 000c 	orr.w	r0, r0, ip
10007550:	ee36 cb10 	vmov.32	ip, d6[1]
10007554:	ea46 060c 	orr.w	r6, r6, ip
10007558:	ee17 cb10 	vmov.32	ip, d7[0]
1000755c:	ea45 050c 	orr.w	r5, r5, ip
10007560:	ee37 cb10 	vmov.32	ip, d7[1]
10007564:	079c      	lsls	r4, r3, #30
10007566:	ea40 000c 	orr.w	r0, r0, ip
1000756a:	f000 80f1 	beq.w	10007750 <fndsa_poly_big_to_fp64_exact+0x468>
1000756e:	f023 0c03 	bic.w	ip, r3, #3
10007572:	e031      	b.n	100075d8 <fndsa_poly_big_to_fp64_exact+0x2f0>
10007574:	f3af 8000 	nop.w
10007578:	ffffffff 	.word	0xffffffff
1000757c:	00000001 	.word	0x00000001
10007580:	00000000 	.word	0x00000000
10007584:	ffffffff 	.word	0xffffffff
10007588:	00000000 	.word	0x00000000
1000758c:	ffffffff 	.word	0xffffffff
10007590:	00000001 	.word	0x00000001
10007594:	00000000 	.word	0x00000000
10007598:	00000001 	.word	0x00000001
1000759c:	00000000 	.word	0x00000000
100075a0:	ffffffff 	.word	0xffffffff
100075a4:	00000001 	.word	0x00000001
100075a8:	00000002 	.word	0x00000002
100075ac:	00000003 	.word	0x00000003
100075b0:	00000003 	.word	0x00000003
100075b4:	00000003 	.word	0x00000003
100075b8:	00000001 	.word	0x00000001
100075bc:	00000001 	.word	0x00000001
100075c0:	00000002 	.word	0x00000002
100075c4:	00000002 	.word	0x00000002
	...
100075d4:	00000001 	.word	0x00000001
100075d8:	9c2b      	ldr	r4, [sp, #172]	@ 0xac
100075da:	fa0c fe07 	lsl.w	lr, ip, r7
100075de:	f852 a02e 	ldr.w	sl, [r2, lr, lsl #2]
100075e2:	ea84 0e0c 	eor.w	lr, r4, ip
100075e6:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
100075ea:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
100075ee:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
100075f2:	ea40 000e 	orr.w	r0, r0, lr
100075f6:	ea88 0e0c 	eor.w	lr, r8, ip
100075fa:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
100075fe:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10007602:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
10007606:	ea45 050e 	orr.w	r5, r5, lr
1000760a:	ea89 0e0c 	eor.w	lr, r9, ip
1000760e:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10007612:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10007616:	ea0a 7aee 	and.w	sl, sl, lr, asr #31
1000761a:	f10c 0e01 	add.w	lr, ip, #1
1000761e:	4573      	cmp	r3, lr
10007620:	ea46 060a 	orr.w	r6, r6, sl
10007624:	f240 8094 	bls.w	10007750 <fndsa_poly_big_to_fp64_exact+0x468>
10007628:	fa0e fa07 	lsl.w	sl, lr, r7
1000762c:	f852 b02a 	ldr.w	fp, [r2, sl, lsl #2]
10007630:	ea84 0a0e 	eor.w	sl, r4, lr
10007634:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10007638:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
1000763c:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10007640:	ea40 000a 	orr.w	r0, r0, sl
10007644:	ea88 0a0e 	eor.w	sl, r8, lr
10007648:	ea89 0e0e 	eor.w	lr, r9, lr
1000764c:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10007650:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10007654:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10007658:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
1000765c:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10007660:	ea0b 7bee 	and.w	fp, fp, lr, asr #31
10007664:	f10c 0e02 	add.w	lr, ip, #2
10007668:	4573      	cmp	r3, lr
1000766a:	ea45 050a 	orr.w	r5, r5, sl
1000766e:	ea46 060b 	orr.w	r6, r6, fp
10007672:	d96d      	bls.n	10007750 <fndsa_poly_big_to_fp64_exact+0x468>
10007674:	fa0e fa07 	lsl.w	sl, lr, r7
10007678:	f852 b02a 	ldr.w	fp, [r2, sl, lsl #2]
1000767c:	ea84 0a0e 	eor.w	sl, r4, lr
10007680:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10007684:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10007688:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
1000768c:	ea40 000a 	orr.w	r0, r0, sl
10007690:	ea88 0a0e 	eor.w	sl, r8, lr
10007694:	ea89 0e0e 	eor.w	lr, r9, lr
10007698:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
1000769c:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
100076a0:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
100076a4:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
100076a8:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
100076ac:	ea0b 7bee 	and.w	fp, fp, lr, asr #31
100076b0:	f10c 0e03 	add.w	lr, ip, #3
100076b4:	4573      	cmp	r3, lr
100076b6:	ea45 050a 	orr.w	r5, r5, sl
100076ba:	ea46 060b 	orr.w	r6, r6, fp
100076be:	d947      	bls.n	10007750 <fndsa_poly_big_to_fp64_exact+0x468>
100076c0:	fa0e fa07 	lsl.w	sl, lr, r7
100076c4:	f852 b02a 	ldr.w	fp, [r2, sl, lsl #2]
100076c8:	ea84 0a0e 	eor.w	sl, r4, lr
100076cc:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
100076d0:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
100076d4:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
100076d8:	ea40 000a 	orr.w	r0, r0, sl
100076dc:	ea88 0a0e 	eor.w	sl, r8, lr
100076e0:	ea89 0e0e 	eor.w	lr, r9, lr
100076e4:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
100076e8:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
100076ec:	f10c 0c04 	add.w	ip, ip, #4
100076f0:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
100076f4:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
100076f8:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
100076fc:	4563      	cmp	r3, ip
100076fe:	ea0b 7bee 	and.w	fp, fp, lr, asr #31
10007702:	ea45 050a 	orr.w	r5, r5, sl
10007706:	ea46 060b 	orr.w	r6, r6, fp
1000770a:	d921      	bls.n	10007750 <fndsa_poly_big_to_fp64_exact+0x468>
1000770c:	fa0c fe07 	lsl.w	lr, ip, r7
10007710:	f852 a02e 	ldr.w	sl, [r2, lr, lsl #2]
10007714:	ea84 0e0c 	eor.w	lr, r4, ip
10007718:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
1000771c:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10007720:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
10007724:	ea40 000e 	orr.w	r0, r0, lr
10007728:	ea88 0e0c 	eor.w	lr, r8, ip
1000772c:	ea89 0c0c 	eor.w	ip, r9, ip
10007730:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10007734:	f02c 4c7f 	bic.w	ip, ip, #4278190080	@ 0xff000000
10007738:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
1000773c:	f10c 3cff 	add.w	ip, ip, #4294967295	@ 0xffffffff
10007740:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
10007744:	ea0a 7aec 	and.w	sl, sl, ip, asr #31
10007748:	ea45 050e 	orr.w	r5, r5, lr
1000774c:	ea46 060a 	orr.w	r6, r6, sl
10007750:	9c20      	ldr	r4, [sp, #128]	@ 0x80
10007752:	3204      	adds	r2, #4
10007754:	f854 cf04 	ldr.w	ip, [r4, #4]!
10007758:	3110      	adds	r1, #16
1000775a:	9420      	str	r4, [sp, #128]	@ 0x80
1000775c:	ea4f 7c9c 	mov.w	ip, ip, lsr #30
10007760:	9c24      	ldr	r4, [sp, #144]	@ 0x90
10007762:	f1cc 0c00 	rsb	ip, ip, #0
10007766:	ea04 0e5c 	and.w	lr, r4, ip, lsr #1
1000776a:	ea4e 0e06 	orr.w	lr, lr, r6
1000776e:	ea4f 064e 	mov.w	r6, lr, lsl #1
10007772:	9c28      	ldr	r4, [sp, #160]	@ 0xa0
10007774:	f006 4600 	and.w	r6, r6, #2147483648	@ 0x80000000
10007778:	ea46 060e 	orr.w	r6, r6, lr
1000777c:	40a6      	lsls	r6, r4
1000777e:	9c23      	ldr	r4, [sp, #140]	@ 0x8c
10007780:	ea04 0e5c 	and.w	lr, r4, ip, lsr #1
10007784:	9c22      	ldr	r4, [sp, #136]	@ 0x88
10007786:	ea4e 0e05 	orr.w	lr, lr, r5
1000778a:	ea04 0c5c 	and.w	ip, r4, ip, lsr #1
1000778e:	ea4c 0c00 	orr.w	ip, ip, r0
10007792:	9826      	ldr	r0, [sp, #152]	@ 0x98
10007794:	fa2c fc00 	lsr.w	ip, ip, r0
10007798:	9827      	ldr	r0, [sp, #156]	@ 0x9c
1000779a:	fa0e f000 	lsl.w	r0, lr, r0
1000779e:	ea4c 0c00 	orr.w	ip, ip, r0
100077a2:	9825      	ldr	r0, [sp, #148]	@ 0x94
100077a4:	fa2e fe00 	lsr.w	lr, lr, r0
100077a8:	ea46 060e 	orr.w	r6, r6, lr
100077ac:	ee07 6a90 	vmov	s15, r6
100077b0:	eeb8 6b67 	vcvt.f64.u32	d6, s15
100077b4:	ee07 ca90 	vmov	s15, ip
100077b8:	eeb8 7b67 	vcvt.f64.u32	d7, s15
100077bc:	9829      	ldr	r0, [sp, #164]	@ 0xa4
100077be:	ed01 6b04 	vstr	d6, [r1, #-16]
100077c2:	4282      	cmp	r2, r0
100077c4:	ed01 7b02 	vstr	d7, [r1, #-8]
100077c8:	f47f adef 	bne.w	100073aa <fndsa_poly_big_to_fp64_exact+0xc2>
100077cc:	b039      	add	sp, #228	@ 0xe4
100077ce:	ecbd 8b10 	vpop	{d8-d15}
100077d2:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
100077d6:	f04f 0c00 	mov.w	ip, #0
100077da:	4666      	mov	r6, ip
100077dc:	4665      	mov	r5, ip
100077de:	4660      	mov	r0, ip
100077e0:	e6fa      	b.n	100075d8 <fndsa_poly_big_to_fp64_exact+0x2f0>
100077e2:	2210      	movs	r2, #16
100077e4:	4619      	mov	r1, r3
100077e6:	40ba      	lsls	r2, r7
100077e8:	b039      	add	sp, #228	@ 0xe4
100077ea:	ecbd 8b10 	vpop	{d8-d15}
100077ee:	e8bd 4ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
100077f2:	f00e bbeb 	b.w	10015fcc <memset>
