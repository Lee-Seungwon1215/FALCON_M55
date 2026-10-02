100095d8 <fndsa_poly_big_to_fp64_exact>:
100095d8:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
100095dc:	ed2d 8b10 	vpush	{d8-d15}
100095e0:	b0b9      	sub	sp, #228	@ 0xe4
100095e2:	4607      	mov	r7, r0
100095e4:	9d52      	ldr	r5, [sp, #328]	@ 0x148
100095e6:	4608      	mov	r0, r1
100095e8:	2b00      	cmp	r3, #0
100095ea:	f000 8272 	beq.w	10009ad2 <fndsa_poly_big_to_fp64_exact+0x4fa>
100095ee:	eb05 1145 	add.w	r1, r5, r5, lsl #5
100095f2:	eb01 2181 	add.w	r1, r1, r1, lsl #10
100095f6:	eb05 0441 	add.w	r4, r5, r1, lsl #1
100095fa:	0d64      	lsrs	r4, r4, #21
100095fc:	4601      	mov	r1, r0
100095fe:	ebc4 1044 	rsb	r0, r4, r4, lsl #5
10009602:	1a2d      	subs	r5, r5, r0
10009604:	1e6e      	subs	r6, r5, #1
10009606:	eba4 78d6 	sub.w	r8, r4, r6, lsr #31
1000960a:	eea6 8b10 	vdup.32	q3, r8
1000960e:	ed9f 0b96 	vldr	d0, [pc, #600]	@ 10009868 <fndsa_poly_big_to_fp64_exact+0x290>
10009612:	ed9f 1b97 	vldr	d1, [pc, #604]	@ 10009870 <fndsa_poly_big_to_fp64_exact+0x298>
10009616:	ed9f 2b98 	vldr	d2, [pc, #608]	@ 10009878 <fndsa_poly_big_to_fp64_exact+0x2a0>
1000961a:	ed9f 3b99 	vldr	d3, [pc, #612]	@ 10009880 <fndsa_poly_big_to_fp64_exact+0x2a8>
1000961e:	ed9f 4b9a 	vldr	d4, [pc, #616]	@ 10009888 <fndsa_poly_big_to_fp64_exact+0x2b0>
10009622:	ed9f 5b9b 	vldr	d5, [pc, #620]	@ 10009890 <fndsa_poly_big_to_fp64_exact+0x2b8>
10009626:	ef26 0840 	vadd.i32	q0, q3, q0
1000962a:	ef26 2842 	vadd.i32	q1, q3, q1
1000962e:	ef26 6844 	vadd.i32	q3, q3, q2
10009632:	1b18      	subs	r0, r3, r4
10009634:	17f4      	asrs	r4, r6, #31
10009636:	f004 041f 	and.w	r4, r4, #31
1000963a:	eb00 70d6 	add.w	r0, r0, r6, lsr #31
1000963e:	ea44 0605 	orr.w	r6, r4, r5
10009642:	2404      	movs	r4, #4
10009644:	eeae 7b10 	vdup.32	q7, r7
10009648:	ed8d 1f14 	vstrw.32	q0, [sp, #80]
1000964c:	ed8d 3f18 	vstrw.32	q1, [sp, #96]
10009650:	ed8d 7f1c 	vstrw.32	q3, [sp, #112]
10009654:	1e5d      	subs	r5, r3, #1
10009656:	9521      	str	r5, [sp, #132]	@ 0x84
10009658:	1e45      	subs	r5, r0, #1
1000965a:	17ed      	asrs	r5, r5, #31
1000965c:	9523      	str	r5, [sp, #140]	@ 0x8c
1000965e:	40bc      	lsls	r4, r7
10009660:	1e85      	subs	r5, r0, #2
10009662:	17c0      	asrs	r0, r0, #31
10009664:	1914      	adds	r4, r2, r4
10009666:	9022      	str	r0, [sp, #136]	@ 0x88
10009668:	17e8      	asrs	r0, r5, #31
1000966a:	1e5d      	subs	r5, r3, #1
1000966c:	40bd      	lsls	r5, r7
1000966e:	9024      	str	r0, [sp, #144]	@ 0x90
10009670:	9429      	str	r4, [sp, #164]	@ 0xa4
10009672:	1f10      	subs	r0, r2, #4
10009674:	f1c6 0420 	rsb	r4, r6, #32
10009678:	eb00 0085 	add.w	r0, r0, r5, lsl #2
1000967c:	9427      	str	r4, [sp, #156]	@ 0x9c
1000967e:	f1c6 041f 	rsb	r4, r6, #31
10009682:	9020      	str	r0, [sp, #128]	@ 0x80
10009684:	1e75      	subs	r5, r6, #1
10009686:	f108 30ff 	add.w	r0, r8, #4294967295	@ 0xffffffff
1000968a:	9428      	str	r4, [sp, #160]	@ 0xa0
1000968c:	089c      	lsrs	r4, r3, #2
1000968e:	9625      	str	r6, [sp, #148]	@ 0x94
10009690:	f108 0901 	add.w	r9, r8, #1
10009694:	9526      	str	r5, [sp, #152]	@ 0x98
10009696:	942a      	str	r4, [sp, #168]	@ 0xa8
10009698:	902b      	str	r0, [sp, #172]	@ 0xac
1000969a:	9821      	ldr	r0, [sp, #132]	@ 0x84
1000969c:	2804      	cmp	r0, #4
1000969e:	f240 8212 	bls.w	10009ac6 <fndsa_poly_big_to_fp64_exact+0x4ee>
100096a2:	ef80 6050 	vmov.i32	q3, #0	@ 0x00000000
100096a6:	ed9f 8b7c 	vldr	d8, [pc, #496]	@ 10009898 <fndsa_poly_big_to_fp64_exact+0x2c0>
100096aa:	ed9f 9b7d 	vldr	d9, [pc, #500]	@ 100098a0 <fndsa_poly_big_to_fp64_exact+0x2c8>
100096ae:	982a      	ldr	r0, [sp, #168]	@ 0xa8
100096b0:	ed8d 7f08 	vstrw.32	q3, [sp, #32]
100096b4:	f040 e001 	dls	lr, r0
100096b8:	ed8d 7f04 	vstrw.32	q3, [sp, #16]
100096bc:	ed8d 7f00 	vstrw.32	q3, [sp, #0]
100096c0:	ed9f cb79 	vldr	d12, [pc, #484]	@ 100098a8 <fndsa_poly_big_to_fp64_exact+0x2d0>
100096c4:	ed9f db7a 	vldr	d13, [pc, #488]	@ 100098b0 <fndsa_poly_big_to_fp64_exact+0x2d8>
100096c8:	ed9f ab7b 	vldr	d10, [pc, #492]	@ 100098b8 <fndsa_poly_big_to_fp64_exact+0x2e0>
100096cc:	ed9f bb7c 	vldr	d11, [pc, #496]	@ 100098c0 <fndsa_poly_big_to_fp64_exact+0x2e8>
100096d0:	ed8d 9f0c 	vstrw.32	q4, [sp, #48]
100096d4:	ff2e 644a 	vshl.u32	q3, q5, q7
100096d8:	ee16 6a10 	vmov	r6, s12
100096dc:	ee36 5b10 	vmov.32	r5, d6[1]
100096e0:	ee17 4b10 	vmov.32	r4, d7[0]
100096e4:	ee37 0b10 	vmov.32	r0, d7[1]
100096e8:	ed9d 7f1c 	vldrw.u32	q3, [sp, #112]
100096ec:	ed9d 1f18 	vldrw.u32	q0, [sp, #96]
100096f0:	ff0a 4156 	veor	q2, q5, q3
100096f4:	ef80 6054 	vmov.i32	q3, #4	@ 0x00000004
100096f8:	ef26 8156 	vmov	q4, q3
100096fc:	ef2a a846 	vadd.i32	q5, q5, q3
10009700:	ff0c 6150 	veor	q3, q6, q0
10009704:	ff87 2e5f 	vmov.i8	q1, #255	@ 0xff
10009708:	ff87 677f 	vbic.i32	q3, #4278190080	@ 0xff000000
1000970c:	ef26 6842 	vadd.i32	q3, q3, q1
10009710:	efa1 6056 	vshr.s32	q3, q3, #31
10009714:	ed9d 1f14 	vldrw.u32	q0, [sp, #80]
10009718:	ed8d 7f10 	vstrw.32	q3, [sp, #64]
1000971c:	ed9d 7f0c 	vldrw.u32	q3, [sp, #48]
10009720:	ff06 0150 	veor	q0, q3, q0
10009724:	ff87 477f 	vbic.i32	q2, #4278190080	@ 0xff000000
10009728:	ff87 077f 	vbic.i32	q0, #4278190080	@ 0xff000000
1000972c:	ef24 4842 	vadd.i32	q2, q2, q1
10009730:	ef20 0842 	vadd.i32	q0, q0, q1
10009734:	ff2e 244c 	vshl.u32	q1, q6, q7
10009738:	f852 6026 	ldr.w	r6, [r2, r6, lsl #2]
1000973c:	efa1 4054 	vshr.s32	q2, q2, #31
10009740:	9634      	str	r6, [sp, #208]	@ 0xd0
10009742:	ee12 6a10 	vmov	r6, s4
10009746:	f852 5025 	ldr.w	r5, [r2, r5, lsl #2]
1000974a:	efa1 0050 	vshr.s32	q0, q0, #31
1000974e:	9535      	str	r5, [sp, #212]	@ 0xd4
10009750:	ee32 5b10 	vmov.32	r5, d2[1]
10009754:	f852 4024 	ldr.w	r4, [r2, r4, lsl #2]
10009758:	ef2c c848 	vadd.i32	q6, q6, q4
1000975c:	9436      	str	r4, [sp, #216]	@ 0xd8
1000975e:	ee13 4b10 	vmov.32	r4, d3[0]
10009762:	f852 0020 	ldr.w	r0, [r2, r0, lsl #2]
10009766:	9037      	str	r0, [sp, #220]	@ 0xdc
10009768:	ee33 0b10 	vmov.32	r0, d3[1]
1000976c:	ff2e 2446 	vshl.u32	q1, q3, q7
10009770:	f852 6026 	ldr.w	r6, [r2, r6, lsl #2]
10009774:	ef26 6848 	vadd.i32	q3, q3, q4
10009778:	9630      	str	r6, [sp, #192]	@ 0xc0
1000977a:	f852 5025 	ldr.w	r5, [r2, r5, lsl #2]
1000977e:	ee12 6a10 	vmov	r6, s4
10009782:	9531      	str	r5, [sp, #196]	@ 0xc4
10009784:	f852 4024 	ldr.w	r4, [r2, r4, lsl #2]
10009788:	ee32 5b10 	vmov.32	r5, d2[1]
1000978c:	9432      	str	r4, [sp, #200]	@ 0xc8
1000978e:	f852 0020 	ldr.w	r0, [r2, r0, lsl #2]
10009792:	ee13 4b10 	vmov.32	r4, d3[0]
10009796:	9033      	str	r0, [sp, #204]	@ 0xcc
10009798:	ee33 0b10 	vmov.32	r0, d3[1]
1000979c:	ed9d 3f34 	vldrw.u32	q1, [sp, #208]
100097a0:	ef02 2154 	vand	q1, q1, q2
100097a4:	ed9d 5f00 	vldrw.u32	q2, [sp, #0]
100097a8:	ef24 4152 	vorr	q2, q2, q1
100097ac:	f852 6026 	ldr.w	r6, [r2, r6, lsl #2]
100097b0:	ed8d 7f0c 	vstrw.32	q3, [sp, #48]
100097b4:	962c      	str	r6, [sp, #176]	@ 0xb0
100097b6:	f852 5025 	ldr.w	r5, [r2, r5, lsl #2]
100097ba:	952d      	str	r5, [sp, #180]	@ 0xb4
100097bc:	f852 4024 	ldr.w	r4, [r2, r4, lsl #2]
100097c0:	942e      	str	r4, [sp, #184]	@ 0xb8
100097c2:	f852 0020 	ldr.w	r0, [r2, r0, lsl #2]
100097c6:	902f      	str	r0, [sp, #188]	@ 0xbc
100097c8:	ed8d 5f00 	vstrw.32	q2, [sp, #0]
100097cc:	ed9d 7f10 	vldrw.u32	q3, [sp, #64]
100097d0:	ed9d 5f30 	vldrw.u32	q2, [sp, #192]
100097d4:	ef04 4156 	vand	q2, q2, q3
100097d8:	ed9d 7f04 	vldrw.u32	q3, [sp, #16]
100097dc:	ef26 6154 	vorr	q3, q3, q2
100097e0:	ed8d 7f04 	vstrw.32	q3, [sp, #16]
100097e4:	ed9d 7f2c 	vldrw.u32	q3, [sp, #176]
100097e8:	ed9d 5f08 	vldrw.u32	q2, [sp, #32]
100097ec:	ef06 6150 	vand	q3, q3, q0
100097f0:	ef24 6156 	vorr	q3, q2, q3
100097f4:	ed8d 7f08 	vstrw.32	q3, [sp, #32]
100097f8:	f00f c095 	le	lr, 100096d4 <fndsa_poly_big_to_fp64_exact+0xfc>
100097fc:	ed9d 7f00 	vldrw.u32	q3, [sp, #0]
10009800:	ed9d 5f04 	vldrw.u32	q2, [sp, #16]
10009804:	ee37 0b10 	vmov.32	r0, d7[1]
10009808:	ee16 6a10 	vmov	r6, s12
1000980c:	ee36 5b10 	vmov.32	r5, d6[1]
10009810:	4306      	orrs	r6, r0
10009812:	ee14 0a10 	vmov	r0, s8
10009816:	ee34 cb10 	vmov.32	ip, d4[1]
1000981a:	4305      	orrs	r5, r0
1000981c:	ee17 0b10 	vmov.32	r0, d7[0]
10009820:	ea40 000c 	orr.w	r0, r0, ip
10009824:	ee15 cb10 	vmov.32	ip, d5[0]
10009828:	ed9d 7f08 	vldrw.u32	q3, [sp, #32]
1000982c:	ea46 060c 	orr.w	r6, r6, ip
10009830:	ee35 cb10 	vmov.32	ip, d5[1]
10009834:	ea45 050c 	orr.w	r5, r5, ip
10009838:	ee16 ca10 	vmov	ip, s12
1000983c:	ea40 000c 	orr.w	r0, r0, ip
10009840:	ee36 cb10 	vmov.32	ip, d6[1]
10009844:	ea46 060c 	orr.w	r6, r6, ip
10009848:	ee17 cb10 	vmov.32	ip, d7[0]
1000984c:	ea45 050c 	orr.w	r5, r5, ip
10009850:	ee37 cb10 	vmov.32	ip, d7[1]
10009854:	079c      	lsls	r4, r3, #30
10009856:	ea40 000c 	orr.w	r0, r0, ip
1000985a:	f000 80f1 	beq.w	10009a40 <fndsa_poly_big_to_fp64_exact+0x468>
1000985e:	f023 0c03 	bic.w	ip, r3, #3
10009862:	e031      	b.n	100098c8 <fndsa_poly_big_to_fp64_exact+0x2f0>
10009864:	f3af 8000 	nop.w
10009868:	ffffffff 	.word	0xffffffff
1000986c:	00000001 	.word	0x00000001
10009870:	00000000 	.word	0x00000000
10009874:	ffffffff 	.word	0xffffffff
10009878:	00000000 	.word	0x00000000
1000987c:	ffffffff 	.word	0xffffffff
10009880:	00000001 	.word	0x00000001
10009884:	00000000 	.word	0x00000000
10009888:	00000001 	.word	0x00000001
1000988c:	00000000 	.word	0x00000000
10009890:	ffffffff 	.word	0xffffffff
10009894:	00000001 	.word	0x00000001
10009898:	00000002 	.word	0x00000002
1000989c:	00000003 	.word	0x00000003
100098a0:	00000003 	.word	0x00000003
100098a4:	00000003 	.word	0x00000003
100098a8:	00000001 	.word	0x00000001
100098ac:	00000001 	.word	0x00000001
100098b0:	00000002 	.word	0x00000002
100098b4:	00000002 	.word	0x00000002
	...
100098c4:	00000001 	.word	0x00000001
100098c8:	9c2b      	ldr	r4, [sp, #172]	@ 0xac
100098ca:	fa0c fe07 	lsl.w	lr, ip, r7
100098ce:	f852 a02e 	ldr.w	sl, [r2, lr, lsl #2]
100098d2:	ea84 0e0c 	eor.w	lr, r4, ip
100098d6:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
100098da:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
100098de:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
100098e2:	ea40 000e 	orr.w	r0, r0, lr
100098e6:	ea88 0e0c 	eor.w	lr, r8, ip
100098ea:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
100098ee:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
100098f2:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
100098f6:	ea45 050e 	orr.w	r5, r5, lr
100098fa:	ea89 0e0c 	eor.w	lr, r9, ip
100098fe:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10009902:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10009906:	ea0a 7aee 	and.w	sl, sl, lr, asr #31
1000990a:	f10c 0e01 	add.w	lr, ip, #1
1000990e:	4573      	cmp	r3, lr
10009910:	ea46 060a 	orr.w	r6, r6, sl
10009914:	f240 8094 	bls.w	10009a40 <fndsa_poly_big_to_fp64_exact+0x468>
10009918:	fa0e fa07 	lsl.w	sl, lr, r7
1000991c:	f852 b02a 	ldr.w	fp, [r2, sl, lsl #2]
10009920:	ea84 0a0e 	eor.w	sl, r4, lr
10009924:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10009928:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
1000992c:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10009930:	ea40 000a 	orr.w	r0, r0, sl
10009934:	ea88 0a0e 	eor.w	sl, r8, lr
10009938:	ea89 0e0e 	eor.w	lr, r9, lr
1000993c:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10009940:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10009944:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10009948:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
1000994c:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10009950:	ea0b 7bee 	and.w	fp, fp, lr, asr #31
10009954:	f10c 0e02 	add.w	lr, ip, #2
10009958:	4573      	cmp	r3, lr
1000995a:	ea45 050a 	orr.w	r5, r5, sl
1000995e:	ea46 060b 	orr.w	r6, r6, fp
10009962:	d96d      	bls.n	10009a40 <fndsa_poly_big_to_fp64_exact+0x468>
10009964:	fa0e fa07 	lsl.w	sl, lr, r7
10009968:	f852 b02a 	ldr.w	fp, [r2, sl, lsl #2]
1000996c:	ea84 0a0e 	eor.w	sl, r4, lr
10009970:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10009974:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10009978:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
1000997c:	ea40 000a 	orr.w	r0, r0, sl
10009980:	ea88 0a0e 	eor.w	sl, r8, lr
10009984:	ea89 0e0e 	eor.w	lr, r9, lr
10009988:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
1000998c:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10009990:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10009994:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10009998:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
1000999c:	ea0b 7bee 	and.w	fp, fp, lr, asr #31
100099a0:	f10c 0e03 	add.w	lr, ip, #3
100099a4:	4573      	cmp	r3, lr
100099a6:	ea45 050a 	orr.w	r5, r5, sl
100099aa:	ea46 060b 	orr.w	r6, r6, fp
100099ae:	d947      	bls.n	10009a40 <fndsa_poly_big_to_fp64_exact+0x468>
100099b0:	fa0e fa07 	lsl.w	sl, lr, r7
100099b4:	f852 b02a 	ldr.w	fp, [r2, sl, lsl #2]
100099b8:	ea84 0a0e 	eor.w	sl, r4, lr
100099bc:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
100099c0:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
100099c4:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
100099c8:	ea40 000a 	orr.w	r0, r0, sl
100099cc:	ea88 0a0e 	eor.w	sl, r8, lr
100099d0:	ea89 0e0e 	eor.w	lr, r9, lr
100099d4:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
100099d8:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
100099dc:	f10c 0c04 	add.w	ip, ip, #4
100099e0:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
100099e4:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
100099e8:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
100099ec:	4563      	cmp	r3, ip
100099ee:	ea0b 7bee 	and.w	fp, fp, lr, asr #31
100099f2:	ea45 050a 	orr.w	r5, r5, sl
100099f6:	ea46 060b 	orr.w	r6, r6, fp
100099fa:	d921      	bls.n	10009a40 <fndsa_poly_big_to_fp64_exact+0x468>
100099fc:	fa0c fe07 	lsl.w	lr, ip, r7
10009a00:	f852 a02e 	ldr.w	sl, [r2, lr, lsl #2]
10009a04:	ea84 0e0c 	eor.w	lr, r4, ip
10009a08:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10009a0c:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10009a10:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
10009a14:	ea40 000e 	orr.w	r0, r0, lr
10009a18:	ea88 0e0c 	eor.w	lr, r8, ip
10009a1c:	ea89 0c0c 	eor.w	ip, r9, ip
10009a20:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10009a24:	f02c 4c7f 	bic.w	ip, ip, #4278190080	@ 0xff000000
10009a28:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10009a2c:	f10c 3cff 	add.w	ip, ip, #4294967295	@ 0xffffffff
10009a30:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
10009a34:	ea0a 7aec 	and.w	sl, sl, ip, asr #31
10009a38:	ea45 050e 	orr.w	r5, r5, lr
10009a3c:	ea46 060a 	orr.w	r6, r6, sl
10009a40:	9c20      	ldr	r4, [sp, #128]	@ 0x80
10009a42:	3204      	adds	r2, #4
10009a44:	f854 cf04 	ldr.w	ip, [r4, #4]!
10009a48:	3110      	adds	r1, #16
10009a4a:	9420      	str	r4, [sp, #128]	@ 0x80
10009a4c:	ea4f 7c9c 	mov.w	ip, ip, lsr #30
10009a50:	9c24      	ldr	r4, [sp, #144]	@ 0x90
10009a52:	f1cc 0c00 	rsb	ip, ip, #0
10009a56:	ea04 0e5c 	and.w	lr, r4, ip, lsr #1
10009a5a:	ea4e 0e06 	orr.w	lr, lr, r6
10009a5e:	ea4f 064e 	mov.w	r6, lr, lsl #1
10009a62:	9c28      	ldr	r4, [sp, #160]	@ 0xa0
10009a64:	f006 4600 	and.w	r6, r6, #2147483648	@ 0x80000000
10009a68:	ea46 060e 	orr.w	r6, r6, lr
10009a6c:	40a6      	lsls	r6, r4
10009a6e:	9c23      	ldr	r4, [sp, #140]	@ 0x8c
10009a70:	ea04 0e5c 	and.w	lr, r4, ip, lsr #1
10009a74:	9c22      	ldr	r4, [sp, #136]	@ 0x88
10009a76:	ea4e 0e05 	orr.w	lr, lr, r5
10009a7a:	ea04 0c5c 	and.w	ip, r4, ip, lsr #1
10009a7e:	ea4c 0c00 	orr.w	ip, ip, r0
10009a82:	9826      	ldr	r0, [sp, #152]	@ 0x98
10009a84:	fa2c fc00 	lsr.w	ip, ip, r0
10009a88:	9827      	ldr	r0, [sp, #156]	@ 0x9c
10009a8a:	fa0e f000 	lsl.w	r0, lr, r0
10009a8e:	ea4c 0c00 	orr.w	ip, ip, r0
10009a92:	9825      	ldr	r0, [sp, #148]	@ 0x94
10009a94:	fa2e fe00 	lsr.w	lr, lr, r0
10009a98:	ea46 060e 	orr.w	r6, r6, lr
10009a9c:	ee07 6a90 	vmov	s15, r6
10009aa0:	eeb8 6b67 	vcvt.f64.u32	d6, s15
10009aa4:	ee07 ca90 	vmov	s15, ip
10009aa8:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10009aac:	9829      	ldr	r0, [sp, #164]	@ 0xa4
10009aae:	ed01 6b04 	vstr	d6, [r1, #-16]
10009ab2:	4282      	cmp	r2, r0
10009ab4:	ed01 7b02 	vstr	d7, [r1, #-8]
10009ab8:	f47f adef 	bne.w	1000969a <fndsa_poly_big_to_fp64_exact+0xc2>
10009abc:	b039      	add	sp, #228	@ 0xe4
10009abe:	ecbd 8b10 	vpop	{d8-d15}
10009ac2:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10009ac6:	f04f 0c00 	mov.w	ip, #0
10009aca:	4666      	mov	r6, ip
10009acc:	4665      	mov	r5, ip
10009ace:	4660      	mov	r0, ip
10009ad0:	e6fa      	b.n	100098c8 <fndsa_poly_big_to_fp64_exact+0x2f0>
10009ad2:	2210      	movs	r2, #16
10009ad4:	4619      	mov	r1, r3
10009ad6:	40ba      	lsls	r2, r7
10009ad8:	b039      	add	sp, #228	@ 0xe4
10009ada:	ecbd 8b10 	vpop	{d8-d15}
10009ade:	e8bd 4ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10009ae2:	f00e bac9 	b.w	10018078 <memset>
10009ae6:	bf00      	nop

