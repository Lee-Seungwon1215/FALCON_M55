
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/r2-kat/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10006308 <fndsa_poly_big_to_fp64_exact>:
10006308:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
1000630c:	ed2d 8b10 	vpush	{d8-d15}
10006310:	b0b9      	sub	sp, #228	@ 0xe4
10006312:	4607      	mov	r7, r0
10006314:	9d52      	ldr	r5, [sp, #328]	@ 0x148
10006316:	4608      	mov	r0, r1
10006318:	2b00      	cmp	r3, #0
1000631a:	f000 8272 	beq.w	10006802 <fndsa_poly_big_to_fp64_exact+0x4fa>
1000631e:	eb05 1145 	add.w	r1, r5, r5, lsl #5
10006322:	eb01 2181 	add.w	r1, r1, r1, lsl #10
10006326:	eb05 0441 	add.w	r4, r5, r1, lsl #1
1000632a:	0d64      	lsrs	r4, r4, #21
1000632c:	4601      	mov	r1, r0
1000632e:	ebc4 1044 	rsb	r0, r4, r4, lsl #5
10006332:	1a2d      	subs	r5, r5, r0
10006334:	1e6e      	subs	r6, r5, #1
10006336:	eba4 78d6 	sub.w	r8, r4, r6, lsr #31
1000633a:	eea6 8b10 	vdup.32	q3, r8
1000633e:	ed9f 0b96 	vldr	d0, [pc, #600]	@ 10006598 <fndsa_poly_big_to_fp64_exact+0x290>
10006342:	ed9f 1b97 	vldr	d1, [pc, #604]	@ 100065a0 <fndsa_poly_big_to_fp64_exact+0x298>
10006346:	ed9f 2b98 	vldr	d2, [pc, #608]	@ 100065a8 <fndsa_poly_big_to_fp64_exact+0x2a0>
1000634a:	ed9f 3b99 	vldr	d3, [pc, #612]	@ 100065b0 <fndsa_poly_big_to_fp64_exact+0x2a8>
1000634e:	ed9f 4b9a 	vldr	d4, [pc, #616]	@ 100065b8 <fndsa_poly_big_to_fp64_exact+0x2b0>
10006352:	ed9f 5b9b 	vldr	d5, [pc, #620]	@ 100065c0 <fndsa_poly_big_to_fp64_exact+0x2b8>
10006356:	ef26 0840 	vadd.i32	q0, q3, q0
1000635a:	ef26 2842 	vadd.i32	q1, q3, q1
1000635e:	ef26 6844 	vadd.i32	q3, q3, q2
10006362:	1b18      	subs	r0, r3, r4
10006364:	17f4      	asrs	r4, r6, #31
10006366:	f004 041f 	and.w	r4, r4, #31
1000636a:	eb00 70d6 	add.w	r0, r0, r6, lsr #31
1000636e:	ea44 0605 	orr.w	r6, r4, r5
10006372:	2404      	movs	r4, #4
10006374:	eeae 7b10 	vdup.32	q7, r7
10006378:	ed8d 1f14 	vstrw.32	q0, [sp, #80]
1000637c:	ed8d 3f18 	vstrw.32	q1, [sp, #96]
10006380:	ed8d 7f1c 	vstrw.32	q3, [sp, #112]
10006384:	1e5d      	subs	r5, r3, #1
10006386:	9521      	str	r5, [sp, #132]	@ 0x84
10006388:	1e45      	subs	r5, r0, #1
1000638a:	17ed      	asrs	r5, r5, #31
1000638c:	9523      	str	r5, [sp, #140]	@ 0x8c
1000638e:	40bc      	lsls	r4, r7
10006390:	1e85      	subs	r5, r0, #2
10006392:	17c0      	asrs	r0, r0, #31
10006394:	1914      	adds	r4, r2, r4
10006396:	9022      	str	r0, [sp, #136]	@ 0x88
10006398:	17e8      	asrs	r0, r5, #31
1000639a:	1e5d      	subs	r5, r3, #1
1000639c:	40bd      	lsls	r5, r7
1000639e:	9024      	str	r0, [sp, #144]	@ 0x90
100063a0:	9429      	str	r4, [sp, #164]	@ 0xa4
100063a2:	1f10      	subs	r0, r2, #4
100063a4:	f1c6 0420 	rsb	r4, r6, #32
100063a8:	eb00 0085 	add.w	r0, r0, r5, lsl #2
100063ac:	9427      	str	r4, [sp, #156]	@ 0x9c
100063ae:	f1c6 041f 	rsb	r4, r6, #31
100063b2:	9020      	str	r0, [sp, #128]	@ 0x80
100063b4:	1e75      	subs	r5, r6, #1
100063b6:	f108 30ff 	add.w	r0, r8, #4294967295	@ 0xffffffff
100063ba:	9428      	str	r4, [sp, #160]	@ 0xa0
100063bc:	089c      	lsrs	r4, r3, #2
100063be:	9625      	str	r6, [sp, #148]	@ 0x94
100063c0:	f108 0901 	add.w	r9, r8, #1
100063c4:	9526      	str	r5, [sp, #152]	@ 0x98
100063c6:	942a      	str	r4, [sp, #168]	@ 0xa8
100063c8:	902b      	str	r0, [sp, #172]	@ 0xac
100063ca:	9821      	ldr	r0, [sp, #132]	@ 0x84
100063cc:	2804      	cmp	r0, #4
100063ce:	f240 8212 	bls.w	100067f6 <fndsa_poly_big_to_fp64_exact+0x4ee>
100063d2:	ef80 6050 	vmov.i32	q3, #0	@ 0x00000000
100063d6:	ed9f 8b7c 	vldr	d8, [pc, #496]	@ 100065c8 <fndsa_poly_big_to_fp64_exact+0x2c0>
100063da:	ed9f 9b7d 	vldr	d9, [pc, #500]	@ 100065d0 <fndsa_poly_big_to_fp64_exact+0x2c8>
100063de:	982a      	ldr	r0, [sp, #168]	@ 0xa8
100063e0:	ed8d 7f08 	vstrw.32	q3, [sp, #32]
100063e4:	f040 e001 	dls	lr, r0
100063e8:	ed8d 7f04 	vstrw.32	q3, [sp, #16]
100063ec:	ed8d 7f00 	vstrw.32	q3, [sp, #0]
100063f0:	ed9f cb79 	vldr	d12, [pc, #484]	@ 100065d8 <fndsa_poly_big_to_fp64_exact+0x2d0>
100063f4:	ed9f db7a 	vldr	d13, [pc, #488]	@ 100065e0 <fndsa_poly_big_to_fp64_exact+0x2d8>
100063f8:	ed9f ab7b 	vldr	d10, [pc, #492]	@ 100065e8 <fndsa_poly_big_to_fp64_exact+0x2e0>
100063fc:	ed9f bb7c 	vldr	d11, [pc, #496]	@ 100065f0 <fndsa_poly_big_to_fp64_exact+0x2e8>
10006400:	ed8d 9f0c 	vstrw.32	q4, [sp, #48]
10006404:	ff2e 644a 	vshl.u32	q3, q5, q7
10006408:	ee16 6a10 	vmov	r6, s12
1000640c:	ee36 5b10 	vmov.32	r5, d6[1]
10006410:	ee17 4b10 	vmov.32	r4, d7[0]
10006414:	ee37 0b10 	vmov.32	r0, d7[1]
10006418:	ed9d 7f1c 	vldrw.u32	q3, [sp, #112]
1000641c:	ed9d 1f18 	vldrw.u32	q0, [sp, #96]
10006420:	ff0a 4156 	veor	q2, q5, q3
10006424:	ef80 6054 	vmov.i32	q3, #4	@ 0x00000004
10006428:	ef26 8156 	vmov	q4, q3
1000642c:	ef2a a846 	vadd.i32	q5, q5, q3
10006430:	ff0c 6150 	veor	q3, q6, q0
10006434:	ff87 2e5f 	vmov.i8	q1, #255	@ 0xff
10006438:	ff87 677f 	vbic.i32	q3, #4278190080	@ 0xff000000
1000643c:	ef26 6842 	vadd.i32	q3, q3, q1
10006440:	efa1 6056 	vshr.s32	q3, q3, #31
10006444:	ed9d 1f14 	vldrw.u32	q0, [sp, #80]
10006448:	ed8d 7f10 	vstrw.32	q3, [sp, #64]
1000644c:	ed9d 7f0c 	vldrw.u32	q3, [sp, #48]
10006450:	ff06 0150 	veor	q0, q3, q0
10006454:	ff87 477f 	vbic.i32	q2, #4278190080	@ 0xff000000
10006458:	ff87 077f 	vbic.i32	q0, #4278190080	@ 0xff000000
1000645c:	ef24 4842 	vadd.i32	q2, q2, q1
10006460:	ef20 0842 	vadd.i32	q0, q0, q1
10006464:	ff2e 244c 	vshl.u32	q1, q6, q7
10006468:	f852 6026 	ldr.w	r6, [r2, r6, lsl #2]
1000646c:	efa1 4054 	vshr.s32	q2, q2, #31
10006470:	9634      	str	r6, [sp, #208]	@ 0xd0
10006472:	ee12 6a10 	vmov	r6, s4
10006476:	f852 5025 	ldr.w	r5, [r2, r5, lsl #2]
1000647a:	efa1 0050 	vshr.s32	q0, q0, #31
1000647e:	9535      	str	r5, [sp, #212]	@ 0xd4
10006480:	ee32 5b10 	vmov.32	r5, d2[1]
10006484:	f852 4024 	ldr.w	r4, [r2, r4, lsl #2]
10006488:	ef2c c848 	vadd.i32	q6, q6, q4
1000648c:	9436      	str	r4, [sp, #216]	@ 0xd8
1000648e:	ee13 4b10 	vmov.32	r4, d3[0]
10006492:	f852 0020 	ldr.w	r0, [r2, r0, lsl #2]
10006496:	9037      	str	r0, [sp, #220]	@ 0xdc
10006498:	ee33 0b10 	vmov.32	r0, d3[1]
1000649c:	ff2e 2446 	vshl.u32	q1, q3, q7
100064a0:	f852 6026 	ldr.w	r6, [r2, r6, lsl #2]
100064a4:	ef26 6848 	vadd.i32	q3, q3, q4
100064a8:	9630      	str	r6, [sp, #192]	@ 0xc0
100064aa:	f852 5025 	ldr.w	r5, [r2, r5, lsl #2]
100064ae:	ee12 6a10 	vmov	r6, s4
100064b2:	9531      	str	r5, [sp, #196]	@ 0xc4
100064b4:	f852 4024 	ldr.w	r4, [r2, r4, lsl #2]
100064b8:	ee32 5b10 	vmov.32	r5, d2[1]
100064bc:	9432      	str	r4, [sp, #200]	@ 0xc8
100064be:	f852 0020 	ldr.w	r0, [r2, r0, lsl #2]
100064c2:	ee13 4b10 	vmov.32	r4, d3[0]
100064c6:	9033      	str	r0, [sp, #204]	@ 0xcc
100064c8:	ee33 0b10 	vmov.32	r0, d3[1]
100064cc:	ed9d 3f34 	vldrw.u32	q1, [sp, #208]
100064d0:	ef02 2154 	vand	q1, q1, q2
100064d4:	ed9d 5f00 	vldrw.u32	q2, [sp, #0]
100064d8:	ef24 4152 	vorr	q2, q2, q1
100064dc:	f852 6026 	ldr.w	r6, [r2, r6, lsl #2]
100064e0:	ed8d 7f0c 	vstrw.32	q3, [sp, #48]
100064e4:	962c      	str	r6, [sp, #176]	@ 0xb0
100064e6:	f852 5025 	ldr.w	r5, [r2, r5, lsl #2]
100064ea:	952d      	str	r5, [sp, #180]	@ 0xb4
100064ec:	f852 4024 	ldr.w	r4, [r2, r4, lsl #2]
100064f0:	942e      	str	r4, [sp, #184]	@ 0xb8
100064f2:	f852 0020 	ldr.w	r0, [r2, r0, lsl #2]
100064f6:	902f      	str	r0, [sp, #188]	@ 0xbc
100064f8:	ed8d 5f00 	vstrw.32	q2, [sp, #0]
100064fc:	ed9d 7f10 	vldrw.u32	q3, [sp, #64]
10006500:	ed9d 5f30 	vldrw.u32	q2, [sp, #192]
10006504:	ef04 4156 	vand	q2, q2, q3
10006508:	ed9d 7f04 	vldrw.u32	q3, [sp, #16]
1000650c:	ef26 6154 	vorr	q3, q3, q2
10006510:	ed8d 7f04 	vstrw.32	q3, [sp, #16]
10006514:	ed9d 7f2c 	vldrw.u32	q3, [sp, #176]
10006518:	ed9d 5f08 	vldrw.u32	q2, [sp, #32]
1000651c:	ef06 6150 	vand	q3, q3, q0
10006520:	ef24 6156 	vorr	q3, q2, q3
10006524:	ed8d 7f08 	vstrw.32	q3, [sp, #32]
10006528:	f00f c095 	le	lr, 10006404 <fndsa_poly_big_to_fp64_exact+0xfc>
1000652c:	ed9d 7f00 	vldrw.u32	q3, [sp, #0]
10006530:	ed9d 5f04 	vldrw.u32	q2, [sp, #16]
10006534:	ee37 0b10 	vmov.32	r0, d7[1]
10006538:	ee16 6a10 	vmov	r6, s12
1000653c:	ee36 5b10 	vmov.32	r5, d6[1]
10006540:	4306      	orrs	r6, r0
10006542:	ee14 0a10 	vmov	r0, s8
10006546:	ee34 cb10 	vmov.32	ip, d4[1]
1000654a:	4305      	orrs	r5, r0
1000654c:	ee17 0b10 	vmov.32	r0, d7[0]
10006550:	ea40 000c 	orr.w	r0, r0, ip
10006554:	ee15 cb10 	vmov.32	ip, d5[0]
10006558:	ed9d 7f08 	vldrw.u32	q3, [sp, #32]
1000655c:	ea46 060c 	orr.w	r6, r6, ip
10006560:	ee35 cb10 	vmov.32	ip, d5[1]
10006564:	ea45 050c 	orr.w	r5, r5, ip
10006568:	ee16 ca10 	vmov	ip, s12
1000656c:	ea40 000c 	orr.w	r0, r0, ip
10006570:	ee36 cb10 	vmov.32	ip, d6[1]
10006574:	ea46 060c 	orr.w	r6, r6, ip
10006578:	ee17 cb10 	vmov.32	ip, d7[0]
1000657c:	ea45 050c 	orr.w	r5, r5, ip
10006580:	ee37 cb10 	vmov.32	ip, d7[1]
10006584:	079c      	lsls	r4, r3, #30
10006586:	ea40 000c 	orr.w	r0, r0, ip
1000658a:	f000 80f1 	beq.w	10006770 <fndsa_poly_big_to_fp64_exact+0x468>
1000658e:	f023 0c03 	bic.w	ip, r3, #3
10006592:	e031      	b.n	100065f8 <fndsa_poly_big_to_fp64_exact+0x2f0>
10006594:	f3af 8000 	nop.w
10006598:	ffffffff 	.word	0xffffffff
1000659c:	00000001 	.word	0x00000001
100065a0:	00000000 	.word	0x00000000
100065a4:	ffffffff 	.word	0xffffffff
100065a8:	00000000 	.word	0x00000000
100065ac:	ffffffff 	.word	0xffffffff
100065b0:	00000001 	.word	0x00000001
100065b4:	00000000 	.word	0x00000000
100065b8:	00000001 	.word	0x00000001
100065bc:	00000000 	.word	0x00000000
100065c0:	ffffffff 	.word	0xffffffff
100065c4:	00000001 	.word	0x00000001
100065c8:	00000002 	.word	0x00000002
100065cc:	00000003 	.word	0x00000003
100065d0:	00000003 	.word	0x00000003
100065d4:	00000003 	.word	0x00000003
100065d8:	00000001 	.word	0x00000001
100065dc:	00000001 	.word	0x00000001
100065e0:	00000002 	.word	0x00000002
100065e4:	00000002 	.word	0x00000002
	...
100065f4:	00000001 	.word	0x00000001
100065f8:	9c2b      	ldr	r4, [sp, #172]	@ 0xac
100065fa:	fa0c fe07 	lsl.w	lr, ip, r7
100065fe:	f852 a02e 	ldr.w	sl, [r2, lr, lsl #2]
10006602:	ea84 0e0c 	eor.w	lr, r4, ip
10006606:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
1000660a:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
1000660e:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
10006612:	ea40 000e 	orr.w	r0, r0, lr
10006616:	ea88 0e0c 	eor.w	lr, r8, ip
1000661a:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
1000661e:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10006622:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
10006626:	ea45 050e 	orr.w	r5, r5, lr
1000662a:	ea89 0e0c 	eor.w	lr, r9, ip
1000662e:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10006632:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10006636:	ea0a 7aee 	and.w	sl, sl, lr, asr #31
1000663a:	f10c 0e01 	add.w	lr, ip, #1
1000663e:	4573      	cmp	r3, lr
10006640:	ea46 060a 	orr.w	r6, r6, sl
10006644:	f240 8094 	bls.w	10006770 <fndsa_poly_big_to_fp64_exact+0x468>
10006648:	fa0e fa07 	lsl.w	sl, lr, r7
1000664c:	f852 b02a 	ldr.w	fp, [r2, sl, lsl #2]
10006650:	ea84 0a0e 	eor.w	sl, r4, lr
10006654:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10006658:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
1000665c:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10006660:	ea40 000a 	orr.w	r0, r0, sl
10006664:	ea88 0a0e 	eor.w	sl, r8, lr
10006668:	ea89 0e0e 	eor.w	lr, r9, lr
1000666c:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10006670:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10006674:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10006678:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
1000667c:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10006680:	ea0b 7bee 	and.w	fp, fp, lr, asr #31
10006684:	f10c 0e02 	add.w	lr, ip, #2
10006688:	4573      	cmp	r3, lr
1000668a:	ea45 050a 	orr.w	r5, r5, sl
1000668e:	ea46 060b 	orr.w	r6, r6, fp
10006692:	d96d      	bls.n	10006770 <fndsa_poly_big_to_fp64_exact+0x468>
10006694:	fa0e fa07 	lsl.w	sl, lr, r7
10006698:	f852 b02a 	ldr.w	fp, [r2, sl, lsl #2]
1000669c:	ea84 0a0e 	eor.w	sl, r4, lr
100066a0:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
100066a4:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
100066a8:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
100066ac:	ea40 000a 	orr.w	r0, r0, sl
100066b0:	ea88 0a0e 	eor.w	sl, r8, lr
100066b4:	ea89 0e0e 	eor.w	lr, r9, lr
100066b8:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
100066bc:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
100066c0:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
100066c4:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
100066c8:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
100066cc:	ea0b 7bee 	and.w	fp, fp, lr, asr #31
100066d0:	f10c 0e03 	add.w	lr, ip, #3
100066d4:	4573      	cmp	r3, lr
100066d6:	ea45 050a 	orr.w	r5, r5, sl
100066da:	ea46 060b 	orr.w	r6, r6, fp
100066de:	d947      	bls.n	10006770 <fndsa_poly_big_to_fp64_exact+0x468>
100066e0:	fa0e fa07 	lsl.w	sl, lr, r7
100066e4:	f852 b02a 	ldr.w	fp, [r2, sl, lsl #2]
100066e8:	ea84 0a0e 	eor.w	sl, r4, lr
100066ec:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
100066f0:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
100066f4:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
100066f8:	ea40 000a 	orr.w	r0, r0, sl
100066fc:	ea88 0a0e 	eor.w	sl, r8, lr
10006700:	ea89 0e0e 	eor.w	lr, r9, lr
10006704:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10006708:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
1000670c:	f10c 0c04 	add.w	ip, ip, #4
10006710:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10006714:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10006718:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
1000671c:	4563      	cmp	r3, ip
1000671e:	ea0b 7bee 	and.w	fp, fp, lr, asr #31
10006722:	ea45 050a 	orr.w	r5, r5, sl
10006726:	ea46 060b 	orr.w	r6, r6, fp
1000672a:	d921      	bls.n	10006770 <fndsa_poly_big_to_fp64_exact+0x468>
1000672c:	fa0c fe07 	lsl.w	lr, ip, r7
10006730:	f852 a02e 	ldr.w	sl, [r2, lr, lsl #2]
10006734:	ea84 0e0c 	eor.w	lr, r4, ip
10006738:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
1000673c:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10006740:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
10006744:	ea40 000e 	orr.w	r0, r0, lr
10006748:	ea88 0e0c 	eor.w	lr, r8, ip
1000674c:	ea89 0c0c 	eor.w	ip, r9, ip
10006750:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10006754:	f02c 4c7f 	bic.w	ip, ip, #4278190080	@ 0xff000000
10006758:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
1000675c:	f10c 3cff 	add.w	ip, ip, #4294967295	@ 0xffffffff
10006760:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
10006764:	ea0a 7aec 	and.w	sl, sl, ip, asr #31
10006768:	ea45 050e 	orr.w	r5, r5, lr
1000676c:	ea46 060a 	orr.w	r6, r6, sl
10006770:	9c20      	ldr	r4, [sp, #128]	@ 0x80
10006772:	3204      	adds	r2, #4
10006774:	f854 cf04 	ldr.w	ip, [r4, #4]!
10006778:	3110      	adds	r1, #16
1000677a:	9420      	str	r4, [sp, #128]	@ 0x80
1000677c:	ea4f 7c9c 	mov.w	ip, ip, lsr #30
10006780:	9c24      	ldr	r4, [sp, #144]	@ 0x90
10006782:	f1cc 0c00 	rsb	ip, ip, #0
10006786:	ea04 0e5c 	and.w	lr, r4, ip, lsr #1
1000678a:	ea4e 0e06 	orr.w	lr, lr, r6
1000678e:	ea4f 064e 	mov.w	r6, lr, lsl #1
10006792:	9c28      	ldr	r4, [sp, #160]	@ 0xa0
10006794:	f006 4600 	and.w	r6, r6, #2147483648	@ 0x80000000
10006798:	ea46 060e 	orr.w	r6, r6, lr
1000679c:	40a6      	lsls	r6, r4
1000679e:	9c23      	ldr	r4, [sp, #140]	@ 0x8c
100067a0:	ea04 0e5c 	and.w	lr, r4, ip, lsr #1
100067a4:	9c22      	ldr	r4, [sp, #136]	@ 0x88
100067a6:	ea4e 0e05 	orr.w	lr, lr, r5
100067aa:	ea04 0c5c 	and.w	ip, r4, ip, lsr #1
100067ae:	ea4c 0c00 	orr.w	ip, ip, r0
100067b2:	9826      	ldr	r0, [sp, #152]	@ 0x98
100067b4:	fa2c fc00 	lsr.w	ip, ip, r0
100067b8:	9827      	ldr	r0, [sp, #156]	@ 0x9c
100067ba:	fa0e f000 	lsl.w	r0, lr, r0
100067be:	ea4c 0c00 	orr.w	ip, ip, r0
100067c2:	9825      	ldr	r0, [sp, #148]	@ 0x94
100067c4:	fa2e fe00 	lsr.w	lr, lr, r0
100067c8:	ea46 060e 	orr.w	r6, r6, lr
100067cc:	ee07 6a90 	vmov	s15, r6
100067d0:	eeb8 6b67 	vcvt.f64.u32	d6, s15
100067d4:	ee07 ca90 	vmov	s15, ip
100067d8:	eeb8 7b67 	vcvt.f64.u32	d7, s15
100067dc:	9829      	ldr	r0, [sp, #164]	@ 0xa4
100067de:	ed01 6b04 	vstr	d6, [r1, #-16]
100067e2:	4282      	cmp	r2, r0
100067e4:	ed01 7b02 	vstr	d7, [r1, #-8]
100067e8:	f47f adef 	bne.w	100063ca <fndsa_poly_big_to_fp64_exact+0xc2>
100067ec:	b039      	add	sp, #228	@ 0xe4
100067ee:	ecbd 8b10 	vpop	{d8-d15}
100067f2:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
100067f6:	f04f 0c00 	mov.w	ip, #0
100067fa:	4666      	mov	r6, ip
100067fc:	4665      	mov	r5, ip
100067fe:	4660      	mov	r0, ip
10006800:	e6fa      	b.n	100065f8 <fndsa_poly_big_to_fp64_exact+0x2f0>
10006802:	2210      	movs	r2, #16
10006804:	4619      	mov	r1, r3
10006806:	40ba      	lsls	r2, r7
10006808:	b039      	add	sp, #228	@ 0xe4
1000680a:	ecbd 8b10 	vpop	{d8-d15}
1000680e:	e8bd 4ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10006812:	f00c bac1 	b.w	10012d98 <memset>
