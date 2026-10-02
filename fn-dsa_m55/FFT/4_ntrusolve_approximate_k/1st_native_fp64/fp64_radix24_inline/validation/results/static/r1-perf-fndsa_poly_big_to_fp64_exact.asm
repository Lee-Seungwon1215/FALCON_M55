
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/r1-perf/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

100074d0 <fndsa_poly_big_to_fp64_exact>:
100074d0:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
100074d4:	ed2d 8b10 	vpush	{d8-d15}
100074d8:	b0b9      	sub	sp, #228	@ 0xe4
100074da:	4607      	mov	r7, r0
100074dc:	9d52      	ldr	r5, [sp, #328]	@ 0x148
100074de:	4608      	mov	r0, r1
100074e0:	2b00      	cmp	r3, #0
100074e2:	f000 8272 	beq.w	100079ca <fndsa_poly_big_to_fp64_exact+0x4fa>
100074e6:	eb05 1145 	add.w	r1, r5, r5, lsl #5
100074ea:	eb01 2181 	add.w	r1, r1, r1, lsl #10
100074ee:	eb05 0441 	add.w	r4, r5, r1, lsl #1
100074f2:	0d64      	lsrs	r4, r4, #21
100074f4:	4601      	mov	r1, r0
100074f6:	ebc4 1044 	rsb	r0, r4, r4, lsl #5
100074fa:	1a2d      	subs	r5, r5, r0
100074fc:	1e6e      	subs	r6, r5, #1
100074fe:	eba4 78d6 	sub.w	r8, r4, r6, lsr #31
10007502:	eea6 8b10 	vdup.32	q3, r8
10007506:	ed9f 0b96 	vldr	d0, [pc, #600]	@ 10007760 <fndsa_poly_big_to_fp64_exact+0x290>
1000750a:	ed9f 1b97 	vldr	d1, [pc, #604]	@ 10007768 <fndsa_poly_big_to_fp64_exact+0x298>
1000750e:	ed9f 2b98 	vldr	d2, [pc, #608]	@ 10007770 <fndsa_poly_big_to_fp64_exact+0x2a0>
10007512:	ed9f 3b99 	vldr	d3, [pc, #612]	@ 10007778 <fndsa_poly_big_to_fp64_exact+0x2a8>
10007516:	ed9f 4b9a 	vldr	d4, [pc, #616]	@ 10007780 <fndsa_poly_big_to_fp64_exact+0x2b0>
1000751a:	ed9f 5b9b 	vldr	d5, [pc, #620]	@ 10007788 <fndsa_poly_big_to_fp64_exact+0x2b8>
1000751e:	ef26 0840 	vadd.i32	q0, q3, q0
10007522:	ef26 2842 	vadd.i32	q1, q3, q1
10007526:	ef26 6844 	vadd.i32	q3, q3, q2
1000752a:	1b18      	subs	r0, r3, r4
1000752c:	17f4      	asrs	r4, r6, #31
1000752e:	f004 041f 	and.w	r4, r4, #31
10007532:	eb00 70d6 	add.w	r0, r0, r6, lsr #31
10007536:	ea44 0605 	orr.w	r6, r4, r5
1000753a:	2404      	movs	r4, #4
1000753c:	eeae 7b10 	vdup.32	q7, r7
10007540:	ed8d 1f14 	vstrw.32	q0, [sp, #80]
10007544:	ed8d 3f18 	vstrw.32	q1, [sp, #96]
10007548:	ed8d 7f1c 	vstrw.32	q3, [sp, #112]
1000754c:	1e5d      	subs	r5, r3, #1
1000754e:	9521      	str	r5, [sp, #132]	@ 0x84
10007550:	1e45      	subs	r5, r0, #1
10007552:	17ed      	asrs	r5, r5, #31
10007554:	9523      	str	r5, [sp, #140]	@ 0x8c
10007556:	40bc      	lsls	r4, r7
10007558:	1e85      	subs	r5, r0, #2
1000755a:	17c0      	asrs	r0, r0, #31
1000755c:	1914      	adds	r4, r2, r4
1000755e:	9022      	str	r0, [sp, #136]	@ 0x88
10007560:	17e8      	asrs	r0, r5, #31
10007562:	1e5d      	subs	r5, r3, #1
10007564:	40bd      	lsls	r5, r7
10007566:	9024      	str	r0, [sp, #144]	@ 0x90
10007568:	9429      	str	r4, [sp, #164]	@ 0xa4
1000756a:	1f10      	subs	r0, r2, #4
1000756c:	f1c6 0420 	rsb	r4, r6, #32
10007570:	eb00 0085 	add.w	r0, r0, r5, lsl #2
10007574:	9427      	str	r4, [sp, #156]	@ 0x9c
10007576:	f1c6 041f 	rsb	r4, r6, #31
1000757a:	9020      	str	r0, [sp, #128]	@ 0x80
1000757c:	1e75      	subs	r5, r6, #1
1000757e:	f108 30ff 	add.w	r0, r8, #4294967295	@ 0xffffffff
10007582:	9428      	str	r4, [sp, #160]	@ 0xa0
10007584:	089c      	lsrs	r4, r3, #2
10007586:	9625      	str	r6, [sp, #148]	@ 0x94
10007588:	f108 0901 	add.w	r9, r8, #1
1000758c:	9526      	str	r5, [sp, #152]	@ 0x98
1000758e:	942a      	str	r4, [sp, #168]	@ 0xa8
10007590:	902b      	str	r0, [sp, #172]	@ 0xac
10007592:	9821      	ldr	r0, [sp, #132]	@ 0x84
10007594:	2804      	cmp	r0, #4
10007596:	f240 8212 	bls.w	100079be <fndsa_poly_big_to_fp64_exact+0x4ee>
1000759a:	ef80 6050 	vmov.i32	q3, #0	@ 0x00000000
1000759e:	ed9f 8b7c 	vldr	d8, [pc, #496]	@ 10007790 <fndsa_poly_big_to_fp64_exact+0x2c0>
100075a2:	ed9f 9b7d 	vldr	d9, [pc, #500]	@ 10007798 <fndsa_poly_big_to_fp64_exact+0x2c8>
100075a6:	982a      	ldr	r0, [sp, #168]	@ 0xa8
100075a8:	ed8d 7f08 	vstrw.32	q3, [sp, #32]
100075ac:	f040 e001 	dls	lr, r0
100075b0:	ed8d 7f04 	vstrw.32	q3, [sp, #16]
100075b4:	ed8d 7f00 	vstrw.32	q3, [sp, #0]
100075b8:	ed9f cb79 	vldr	d12, [pc, #484]	@ 100077a0 <fndsa_poly_big_to_fp64_exact+0x2d0>
100075bc:	ed9f db7a 	vldr	d13, [pc, #488]	@ 100077a8 <fndsa_poly_big_to_fp64_exact+0x2d8>
100075c0:	ed9f ab7b 	vldr	d10, [pc, #492]	@ 100077b0 <fndsa_poly_big_to_fp64_exact+0x2e0>
100075c4:	ed9f bb7c 	vldr	d11, [pc, #496]	@ 100077b8 <fndsa_poly_big_to_fp64_exact+0x2e8>
100075c8:	ed8d 9f0c 	vstrw.32	q4, [sp, #48]
100075cc:	ff2e 644a 	vshl.u32	q3, q5, q7
100075d0:	ee16 6a10 	vmov	r6, s12
100075d4:	ee36 5b10 	vmov.32	r5, d6[1]
100075d8:	ee17 4b10 	vmov.32	r4, d7[0]
100075dc:	ee37 0b10 	vmov.32	r0, d7[1]
100075e0:	ed9d 7f1c 	vldrw.u32	q3, [sp, #112]
100075e4:	ed9d 1f18 	vldrw.u32	q0, [sp, #96]
100075e8:	ff0a 4156 	veor	q2, q5, q3
100075ec:	ef80 6054 	vmov.i32	q3, #4	@ 0x00000004
100075f0:	ef26 8156 	vmov	q4, q3
100075f4:	ef2a a846 	vadd.i32	q5, q5, q3
100075f8:	ff0c 6150 	veor	q3, q6, q0
100075fc:	ff87 2e5f 	vmov.i8	q1, #255	@ 0xff
10007600:	ff87 677f 	vbic.i32	q3, #4278190080	@ 0xff000000
10007604:	ef26 6842 	vadd.i32	q3, q3, q1
10007608:	efa1 6056 	vshr.s32	q3, q3, #31
1000760c:	ed9d 1f14 	vldrw.u32	q0, [sp, #80]
10007610:	ed8d 7f10 	vstrw.32	q3, [sp, #64]
10007614:	ed9d 7f0c 	vldrw.u32	q3, [sp, #48]
10007618:	ff06 0150 	veor	q0, q3, q0
1000761c:	ff87 477f 	vbic.i32	q2, #4278190080	@ 0xff000000
10007620:	ff87 077f 	vbic.i32	q0, #4278190080	@ 0xff000000
10007624:	ef24 4842 	vadd.i32	q2, q2, q1
10007628:	ef20 0842 	vadd.i32	q0, q0, q1
1000762c:	ff2e 244c 	vshl.u32	q1, q6, q7
10007630:	f852 6026 	ldr.w	r6, [r2, r6, lsl #2]
10007634:	efa1 4054 	vshr.s32	q2, q2, #31
10007638:	9634      	str	r6, [sp, #208]	@ 0xd0
1000763a:	ee12 6a10 	vmov	r6, s4
1000763e:	f852 5025 	ldr.w	r5, [r2, r5, lsl #2]
10007642:	efa1 0050 	vshr.s32	q0, q0, #31
10007646:	9535      	str	r5, [sp, #212]	@ 0xd4
10007648:	ee32 5b10 	vmov.32	r5, d2[1]
1000764c:	f852 4024 	ldr.w	r4, [r2, r4, lsl #2]
10007650:	ef2c c848 	vadd.i32	q6, q6, q4
10007654:	9436      	str	r4, [sp, #216]	@ 0xd8
10007656:	ee13 4b10 	vmov.32	r4, d3[0]
1000765a:	f852 0020 	ldr.w	r0, [r2, r0, lsl #2]
1000765e:	9037      	str	r0, [sp, #220]	@ 0xdc
10007660:	ee33 0b10 	vmov.32	r0, d3[1]
10007664:	ff2e 2446 	vshl.u32	q1, q3, q7
10007668:	f852 6026 	ldr.w	r6, [r2, r6, lsl #2]
1000766c:	ef26 6848 	vadd.i32	q3, q3, q4
10007670:	9630      	str	r6, [sp, #192]	@ 0xc0
10007672:	f852 5025 	ldr.w	r5, [r2, r5, lsl #2]
10007676:	ee12 6a10 	vmov	r6, s4
1000767a:	9531      	str	r5, [sp, #196]	@ 0xc4
1000767c:	f852 4024 	ldr.w	r4, [r2, r4, lsl #2]
10007680:	ee32 5b10 	vmov.32	r5, d2[1]
10007684:	9432      	str	r4, [sp, #200]	@ 0xc8
10007686:	f852 0020 	ldr.w	r0, [r2, r0, lsl #2]
1000768a:	ee13 4b10 	vmov.32	r4, d3[0]
1000768e:	9033      	str	r0, [sp, #204]	@ 0xcc
10007690:	ee33 0b10 	vmov.32	r0, d3[1]
10007694:	ed9d 3f34 	vldrw.u32	q1, [sp, #208]
10007698:	ef02 2154 	vand	q1, q1, q2
1000769c:	ed9d 5f00 	vldrw.u32	q2, [sp, #0]
100076a0:	ef24 4152 	vorr	q2, q2, q1
100076a4:	f852 6026 	ldr.w	r6, [r2, r6, lsl #2]
100076a8:	ed8d 7f0c 	vstrw.32	q3, [sp, #48]
100076ac:	962c      	str	r6, [sp, #176]	@ 0xb0
100076ae:	f852 5025 	ldr.w	r5, [r2, r5, lsl #2]
100076b2:	952d      	str	r5, [sp, #180]	@ 0xb4
100076b4:	f852 4024 	ldr.w	r4, [r2, r4, lsl #2]
100076b8:	942e      	str	r4, [sp, #184]	@ 0xb8
100076ba:	f852 0020 	ldr.w	r0, [r2, r0, lsl #2]
100076be:	902f      	str	r0, [sp, #188]	@ 0xbc
100076c0:	ed8d 5f00 	vstrw.32	q2, [sp, #0]
100076c4:	ed9d 7f10 	vldrw.u32	q3, [sp, #64]
100076c8:	ed9d 5f30 	vldrw.u32	q2, [sp, #192]
100076cc:	ef04 4156 	vand	q2, q2, q3
100076d0:	ed9d 7f04 	vldrw.u32	q3, [sp, #16]
100076d4:	ef26 6154 	vorr	q3, q3, q2
100076d8:	ed8d 7f04 	vstrw.32	q3, [sp, #16]
100076dc:	ed9d 7f2c 	vldrw.u32	q3, [sp, #176]
100076e0:	ed9d 5f08 	vldrw.u32	q2, [sp, #32]
100076e4:	ef06 6150 	vand	q3, q3, q0
100076e8:	ef24 6156 	vorr	q3, q2, q3
100076ec:	ed8d 7f08 	vstrw.32	q3, [sp, #32]
100076f0:	f00f c095 	le	lr, 100075cc <fndsa_poly_big_to_fp64_exact+0xfc>
100076f4:	ed9d 7f00 	vldrw.u32	q3, [sp, #0]
100076f8:	ed9d 5f04 	vldrw.u32	q2, [sp, #16]
100076fc:	ee37 0b10 	vmov.32	r0, d7[1]
10007700:	ee16 6a10 	vmov	r6, s12
10007704:	ee36 5b10 	vmov.32	r5, d6[1]
10007708:	4306      	orrs	r6, r0
1000770a:	ee14 0a10 	vmov	r0, s8
1000770e:	ee34 cb10 	vmov.32	ip, d4[1]
10007712:	4305      	orrs	r5, r0
10007714:	ee17 0b10 	vmov.32	r0, d7[0]
10007718:	ea40 000c 	orr.w	r0, r0, ip
1000771c:	ee15 cb10 	vmov.32	ip, d5[0]
10007720:	ed9d 7f08 	vldrw.u32	q3, [sp, #32]
10007724:	ea46 060c 	orr.w	r6, r6, ip
10007728:	ee35 cb10 	vmov.32	ip, d5[1]
1000772c:	ea45 050c 	orr.w	r5, r5, ip
10007730:	ee16 ca10 	vmov	ip, s12
10007734:	ea40 000c 	orr.w	r0, r0, ip
10007738:	ee36 cb10 	vmov.32	ip, d6[1]
1000773c:	ea46 060c 	orr.w	r6, r6, ip
10007740:	ee17 cb10 	vmov.32	ip, d7[0]
10007744:	ea45 050c 	orr.w	r5, r5, ip
10007748:	ee37 cb10 	vmov.32	ip, d7[1]
1000774c:	079c      	lsls	r4, r3, #30
1000774e:	ea40 000c 	orr.w	r0, r0, ip
10007752:	f000 80f1 	beq.w	10007938 <fndsa_poly_big_to_fp64_exact+0x468>
10007756:	f023 0c03 	bic.w	ip, r3, #3
1000775a:	e031      	b.n	100077c0 <fndsa_poly_big_to_fp64_exact+0x2f0>
1000775c:	f3af 8000 	nop.w
10007760:	ffffffff 	.word	0xffffffff
10007764:	00000001 	.word	0x00000001
10007768:	00000000 	.word	0x00000000
1000776c:	ffffffff 	.word	0xffffffff
10007770:	00000000 	.word	0x00000000
10007774:	ffffffff 	.word	0xffffffff
10007778:	00000001 	.word	0x00000001
1000777c:	00000000 	.word	0x00000000
10007780:	00000001 	.word	0x00000001
10007784:	00000000 	.word	0x00000000
10007788:	ffffffff 	.word	0xffffffff
1000778c:	00000001 	.word	0x00000001
10007790:	00000002 	.word	0x00000002
10007794:	00000003 	.word	0x00000003
10007798:	00000003 	.word	0x00000003
1000779c:	00000003 	.word	0x00000003
100077a0:	00000001 	.word	0x00000001
100077a4:	00000001 	.word	0x00000001
100077a8:	00000002 	.word	0x00000002
100077ac:	00000002 	.word	0x00000002
	...
100077bc:	00000001 	.word	0x00000001
100077c0:	9c2b      	ldr	r4, [sp, #172]	@ 0xac
100077c2:	fa0c fe07 	lsl.w	lr, ip, r7
100077c6:	f852 a02e 	ldr.w	sl, [r2, lr, lsl #2]
100077ca:	ea84 0e0c 	eor.w	lr, r4, ip
100077ce:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
100077d2:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
100077d6:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
100077da:	ea40 000e 	orr.w	r0, r0, lr
100077de:	ea88 0e0c 	eor.w	lr, r8, ip
100077e2:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
100077e6:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
100077ea:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
100077ee:	ea45 050e 	orr.w	r5, r5, lr
100077f2:	ea89 0e0c 	eor.w	lr, r9, ip
100077f6:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
100077fa:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
100077fe:	ea0a 7aee 	and.w	sl, sl, lr, asr #31
10007802:	f10c 0e01 	add.w	lr, ip, #1
10007806:	4573      	cmp	r3, lr
10007808:	ea46 060a 	orr.w	r6, r6, sl
1000780c:	f240 8094 	bls.w	10007938 <fndsa_poly_big_to_fp64_exact+0x468>
10007810:	fa0e fa07 	lsl.w	sl, lr, r7
10007814:	f852 b02a 	ldr.w	fp, [r2, sl, lsl #2]
10007818:	ea84 0a0e 	eor.w	sl, r4, lr
1000781c:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10007820:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10007824:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10007828:	ea40 000a 	orr.w	r0, r0, sl
1000782c:	ea88 0a0e 	eor.w	sl, r8, lr
10007830:	ea89 0e0e 	eor.w	lr, r9, lr
10007834:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10007838:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
1000783c:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10007840:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10007844:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10007848:	ea0b 7bee 	and.w	fp, fp, lr, asr #31
1000784c:	f10c 0e02 	add.w	lr, ip, #2
10007850:	4573      	cmp	r3, lr
10007852:	ea45 050a 	orr.w	r5, r5, sl
10007856:	ea46 060b 	orr.w	r6, r6, fp
1000785a:	d96d      	bls.n	10007938 <fndsa_poly_big_to_fp64_exact+0x468>
1000785c:	fa0e fa07 	lsl.w	sl, lr, r7
10007860:	f852 b02a 	ldr.w	fp, [r2, sl, lsl #2]
10007864:	ea84 0a0e 	eor.w	sl, r4, lr
10007868:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
1000786c:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10007870:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10007874:	ea40 000a 	orr.w	r0, r0, sl
10007878:	ea88 0a0e 	eor.w	sl, r8, lr
1000787c:	ea89 0e0e 	eor.w	lr, r9, lr
10007880:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10007884:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10007888:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
1000788c:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10007890:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10007894:	ea0b 7bee 	and.w	fp, fp, lr, asr #31
10007898:	f10c 0e03 	add.w	lr, ip, #3
1000789c:	4573      	cmp	r3, lr
1000789e:	ea45 050a 	orr.w	r5, r5, sl
100078a2:	ea46 060b 	orr.w	r6, r6, fp
100078a6:	d947      	bls.n	10007938 <fndsa_poly_big_to_fp64_exact+0x468>
100078a8:	fa0e fa07 	lsl.w	sl, lr, r7
100078ac:	f852 b02a 	ldr.w	fp, [r2, sl, lsl #2]
100078b0:	ea84 0a0e 	eor.w	sl, r4, lr
100078b4:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
100078b8:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
100078bc:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
100078c0:	ea40 000a 	orr.w	r0, r0, sl
100078c4:	ea88 0a0e 	eor.w	sl, r8, lr
100078c8:	ea89 0e0e 	eor.w	lr, r9, lr
100078cc:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
100078d0:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
100078d4:	f10c 0c04 	add.w	ip, ip, #4
100078d8:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
100078dc:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
100078e0:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
100078e4:	4563      	cmp	r3, ip
100078e6:	ea0b 7bee 	and.w	fp, fp, lr, asr #31
100078ea:	ea45 050a 	orr.w	r5, r5, sl
100078ee:	ea46 060b 	orr.w	r6, r6, fp
100078f2:	d921      	bls.n	10007938 <fndsa_poly_big_to_fp64_exact+0x468>
100078f4:	fa0c fe07 	lsl.w	lr, ip, r7
100078f8:	f852 a02e 	ldr.w	sl, [r2, lr, lsl #2]
100078fc:	ea84 0e0c 	eor.w	lr, r4, ip
10007900:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10007904:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10007908:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
1000790c:	ea40 000e 	orr.w	r0, r0, lr
10007910:	ea88 0e0c 	eor.w	lr, r8, ip
10007914:	ea89 0c0c 	eor.w	ip, r9, ip
10007918:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
1000791c:	f02c 4c7f 	bic.w	ip, ip, #4278190080	@ 0xff000000
10007920:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10007924:	f10c 3cff 	add.w	ip, ip, #4294967295	@ 0xffffffff
10007928:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
1000792c:	ea0a 7aec 	and.w	sl, sl, ip, asr #31
10007930:	ea45 050e 	orr.w	r5, r5, lr
10007934:	ea46 060a 	orr.w	r6, r6, sl
10007938:	9c20      	ldr	r4, [sp, #128]	@ 0x80
1000793a:	3204      	adds	r2, #4
1000793c:	f854 cf04 	ldr.w	ip, [r4, #4]!
10007940:	3110      	adds	r1, #16
10007942:	9420      	str	r4, [sp, #128]	@ 0x80
10007944:	ea4f 7c9c 	mov.w	ip, ip, lsr #30
10007948:	9c24      	ldr	r4, [sp, #144]	@ 0x90
1000794a:	f1cc 0c00 	rsb	ip, ip, #0
1000794e:	ea04 0e5c 	and.w	lr, r4, ip, lsr #1
10007952:	ea4e 0e06 	orr.w	lr, lr, r6
10007956:	ea4f 064e 	mov.w	r6, lr, lsl #1
1000795a:	9c28      	ldr	r4, [sp, #160]	@ 0xa0
1000795c:	f006 4600 	and.w	r6, r6, #2147483648	@ 0x80000000
10007960:	ea46 060e 	orr.w	r6, r6, lr
10007964:	40a6      	lsls	r6, r4
10007966:	9c23      	ldr	r4, [sp, #140]	@ 0x8c
10007968:	ea04 0e5c 	and.w	lr, r4, ip, lsr #1
1000796c:	9c22      	ldr	r4, [sp, #136]	@ 0x88
1000796e:	ea4e 0e05 	orr.w	lr, lr, r5
10007972:	ea04 0c5c 	and.w	ip, r4, ip, lsr #1
10007976:	ea4c 0c00 	orr.w	ip, ip, r0
1000797a:	9826      	ldr	r0, [sp, #152]	@ 0x98
1000797c:	fa2c fc00 	lsr.w	ip, ip, r0
10007980:	9827      	ldr	r0, [sp, #156]	@ 0x9c
10007982:	fa0e f000 	lsl.w	r0, lr, r0
10007986:	ea4c 0c00 	orr.w	ip, ip, r0
1000798a:	9825      	ldr	r0, [sp, #148]	@ 0x94
1000798c:	fa2e fe00 	lsr.w	lr, lr, r0
10007990:	ea46 060e 	orr.w	r6, r6, lr
10007994:	ee07 6a90 	vmov	s15, r6
10007998:	eeb8 6b67 	vcvt.f64.u32	d6, s15
1000799c:	ee07 ca90 	vmov	s15, ip
100079a0:	eeb8 7b67 	vcvt.f64.u32	d7, s15
100079a4:	9829      	ldr	r0, [sp, #164]	@ 0xa4
100079a6:	ed01 6b04 	vstr	d6, [r1, #-16]
100079aa:	4282      	cmp	r2, r0
100079ac:	ed01 7b02 	vstr	d7, [r1, #-8]
100079b0:	f47f adef 	bne.w	10007592 <fndsa_poly_big_to_fp64_exact+0xc2>
100079b4:	b039      	add	sp, #228	@ 0xe4
100079b6:	ecbd 8b10 	vpop	{d8-d15}
100079ba:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
100079be:	f04f 0c00 	mov.w	ip, #0
100079c2:	4666      	mov	r6, ip
100079c4:	4665      	mov	r5, ip
100079c6:	4660      	mov	r0, ip
100079c8:	e6fa      	b.n	100077c0 <fndsa_poly_big_to_fp64_exact+0x2f0>
100079ca:	2210      	movs	r2, #16
100079cc:	4619      	mov	r1, r3
100079ce:	40ba      	lsls	r2, r7
100079d0:	b039      	add	sp, #228	@ 0xe4
100079d2:	ecbd 8b10 	vpop	{d8-d15}
100079d6:	e8bd 4ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
100079da:	f00e bac9 	b.w	10015f70 <memset>
