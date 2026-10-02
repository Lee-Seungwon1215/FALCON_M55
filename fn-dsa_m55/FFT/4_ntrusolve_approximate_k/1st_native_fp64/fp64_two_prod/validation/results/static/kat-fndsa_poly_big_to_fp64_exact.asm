10006708 <fndsa_poly_big_to_fp64_exact>:
10006708:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
1000670c:	ed2d 8b10 	vpush	{d8-d15}
10006710:	b0b9      	sub	sp, #228	@ 0xe4
10006712:	4607      	mov	r7, r0
10006714:	9d52      	ldr	r5, [sp, #328]	@ 0x148
10006716:	4608      	mov	r0, r1
10006718:	2b00      	cmp	r3, #0
1000671a:	f000 8272 	beq.w	10006c02 <fndsa_poly_big_to_fp64_exact+0x4fa>
1000671e:	eb05 1145 	add.w	r1, r5, r5, lsl #5
10006722:	eb01 2181 	add.w	r1, r1, r1, lsl #10
10006726:	eb05 0441 	add.w	r4, r5, r1, lsl #1
1000672a:	0d64      	lsrs	r4, r4, #21
1000672c:	4601      	mov	r1, r0
1000672e:	ebc4 1044 	rsb	r0, r4, r4, lsl #5
10006732:	1a2d      	subs	r5, r5, r0
10006734:	1e6e      	subs	r6, r5, #1
10006736:	eba4 78d6 	sub.w	r8, r4, r6, lsr #31
1000673a:	eea6 8b10 	vdup.32	q3, r8
1000673e:	ed9f 0b96 	vldr	d0, [pc, #600]	@ 10006998 <fndsa_poly_big_to_fp64_exact+0x290>
10006742:	ed9f 1b97 	vldr	d1, [pc, #604]	@ 100069a0 <fndsa_poly_big_to_fp64_exact+0x298>
10006746:	ed9f 2b98 	vldr	d2, [pc, #608]	@ 100069a8 <fndsa_poly_big_to_fp64_exact+0x2a0>
1000674a:	ed9f 3b99 	vldr	d3, [pc, #612]	@ 100069b0 <fndsa_poly_big_to_fp64_exact+0x2a8>
1000674e:	ed9f 4b9a 	vldr	d4, [pc, #616]	@ 100069b8 <fndsa_poly_big_to_fp64_exact+0x2b0>
10006752:	ed9f 5b9b 	vldr	d5, [pc, #620]	@ 100069c0 <fndsa_poly_big_to_fp64_exact+0x2b8>
10006756:	ef26 0840 	vadd.i32	q0, q3, q0
1000675a:	ef26 2842 	vadd.i32	q1, q3, q1
1000675e:	ef26 6844 	vadd.i32	q3, q3, q2
10006762:	1b18      	subs	r0, r3, r4
10006764:	17f4      	asrs	r4, r6, #31
10006766:	f004 041f 	and.w	r4, r4, #31
1000676a:	eb00 70d6 	add.w	r0, r0, r6, lsr #31
1000676e:	ea44 0605 	orr.w	r6, r4, r5
10006772:	2404      	movs	r4, #4
10006774:	eeae 7b10 	vdup.32	q7, r7
10006778:	ed8d 1f14 	vstrw.32	q0, [sp, #80]
1000677c:	ed8d 3f18 	vstrw.32	q1, [sp, #96]
10006780:	ed8d 7f1c 	vstrw.32	q3, [sp, #112]
10006784:	1e5d      	subs	r5, r3, #1
10006786:	9521      	str	r5, [sp, #132]	@ 0x84
10006788:	1e45      	subs	r5, r0, #1
1000678a:	17ed      	asrs	r5, r5, #31
1000678c:	9523      	str	r5, [sp, #140]	@ 0x8c
1000678e:	40bc      	lsls	r4, r7
10006790:	1e85      	subs	r5, r0, #2
10006792:	17c0      	asrs	r0, r0, #31
10006794:	1914      	adds	r4, r2, r4
10006796:	9022      	str	r0, [sp, #136]	@ 0x88
10006798:	17e8      	asrs	r0, r5, #31
1000679a:	1e5d      	subs	r5, r3, #1
1000679c:	40bd      	lsls	r5, r7
1000679e:	9024      	str	r0, [sp, #144]	@ 0x90
100067a0:	9429      	str	r4, [sp, #164]	@ 0xa4
100067a2:	1f10      	subs	r0, r2, #4
100067a4:	f1c6 0420 	rsb	r4, r6, #32
100067a8:	eb00 0085 	add.w	r0, r0, r5, lsl #2
100067ac:	9427      	str	r4, [sp, #156]	@ 0x9c
100067ae:	f1c6 041f 	rsb	r4, r6, #31
100067b2:	9020      	str	r0, [sp, #128]	@ 0x80
100067b4:	1e75      	subs	r5, r6, #1
100067b6:	f108 30ff 	add.w	r0, r8, #4294967295	@ 0xffffffff
100067ba:	9428      	str	r4, [sp, #160]	@ 0xa0
100067bc:	089c      	lsrs	r4, r3, #2
100067be:	9625      	str	r6, [sp, #148]	@ 0x94
100067c0:	f108 0901 	add.w	r9, r8, #1
100067c4:	9526      	str	r5, [sp, #152]	@ 0x98
100067c6:	942a      	str	r4, [sp, #168]	@ 0xa8
100067c8:	902b      	str	r0, [sp, #172]	@ 0xac
100067ca:	9821      	ldr	r0, [sp, #132]	@ 0x84
100067cc:	2804      	cmp	r0, #4
100067ce:	f240 8212 	bls.w	10006bf6 <fndsa_poly_big_to_fp64_exact+0x4ee>
100067d2:	ef80 6050 	vmov.i32	q3, #0	@ 0x00000000
100067d6:	ed9f 8b7c 	vldr	d8, [pc, #496]	@ 100069c8 <fndsa_poly_big_to_fp64_exact+0x2c0>
100067da:	ed9f 9b7d 	vldr	d9, [pc, #500]	@ 100069d0 <fndsa_poly_big_to_fp64_exact+0x2c8>
100067de:	982a      	ldr	r0, [sp, #168]	@ 0xa8
100067e0:	ed8d 7f08 	vstrw.32	q3, [sp, #32]
100067e4:	f040 e001 	dls	lr, r0
100067e8:	ed8d 7f04 	vstrw.32	q3, [sp, #16]
100067ec:	ed8d 7f00 	vstrw.32	q3, [sp, #0]
100067f0:	ed9f cb79 	vldr	d12, [pc, #484]	@ 100069d8 <fndsa_poly_big_to_fp64_exact+0x2d0>
100067f4:	ed9f db7a 	vldr	d13, [pc, #488]	@ 100069e0 <fndsa_poly_big_to_fp64_exact+0x2d8>
100067f8:	ed9f ab7b 	vldr	d10, [pc, #492]	@ 100069e8 <fndsa_poly_big_to_fp64_exact+0x2e0>
100067fc:	ed9f bb7c 	vldr	d11, [pc, #496]	@ 100069f0 <fndsa_poly_big_to_fp64_exact+0x2e8>
10006800:	ed8d 9f0c 	vstrw.32	q4, [sp, #48]
10006804:	ff2e 644a 	vshl.u32	q3, q5, q7
10006808:	ee16 6a10 	vmov	r6, s12
1000680c:	ee36 5b10 	vmov.32	r5, d6[1]
10006810:	ee17 4b10 	vmov.32	r4, d7[0]
10006814:	ee37 0b10 	vmov.32	r0, d7[1]
10006818:	ed9d 7f1c 	vldrw.u32	q3, [sp, #112]
1000681c:	ed9d 1f18 	vldrw.u32	q0, [sp, #96]
10006820:	ff0a 4156 	veor	q2, q5, q3
10006824:	ef80 6054 	vmov.i32	q3, #4	@ 0x00000004
10006828:	ef26 8156 	vmov	q4, q3
1000682c:	ef2a a846 	vadd.i32	q5, q5, q3
10006830:	ff0c 6150 	veor	q3, q6, q0
10006834:	ff87 2e5f 	vmov.i8	q1, #255	@ 0xff
10006838:	ff87 677f 	vbic.i32	q3, #4278190080	@ 0xff000000
1000683c:	ef26 6842 	vadd.i32	q3, q3, q1
10006840:	efa1 6056 	vshr.s32	q3, q3, #31
10006844:	ed9d 1f14 	vldrw.u32	q0, [sp, #80]
10006848:	ed8d 7f10 	vstrw.32	q3, [sp, #64]
1000684c:	ed9d 7f0c 	vldrw.u32	q3, [sp, #48]
10006850:	ff06 0150 	veor	q0, q3, q0
10006854:	ff87 477f 	vbic.i32	q2, #4278190080	@ 0xff000000
10006858:	ff87 077f 	vbic.i32	q0, #4278190080	@ 0xff000000
1000685c:	ef24 4842 	vadd.i32	q2, q2, q1
10006860:	ef20 0842 	vadd.i32	q0, q0, q1
10006864:	ff2e 244c 	vshl.u32	q1, q6, q7
10006868:	f852 6026 	ldr.w	r6, [r2, r6, lsl #2]
1000686c:	efa1 4054 	vshr.s32	q2, q2, #31
10006870:	9634      	str	r6, [sp, #208]	@ 0xd0
10006872:	ee12 6a10 	vmov	r6, s4
10006876:	f852 5025 	ldr.w	r5, [r2, r5, lsl #2]
1000687a:	efa1 0050 	vshr.s32	q0, q0, #31
1000687e:	9535      	str	r5, [sp, #212]	@ 0xd4
10006880:	ee32 5b10 	vmov.32	r5, d2[1]
10006884:	f852 4024 	ldr.w	r4, [r2, r4, lsl #2]
10006888:	ef2c c848 	vadd.i32	q6, q6, q4
1000688c:	9436      	str	r4, [sp, #216]	@ 0xd8
1000688e:	ee13 4b10 	vmov.32	r4, d3[0]
10006892:	f852 0020 	ldr.w	r0, [r2, r0, lsl #2]
10006896:	9037      	str	r0, [sp, #220]	@ 0xdc
10006898:	ee33 0b10 	vmov.32	r0, d3[1]
1000689c:	ff2e 2446 	vshl.u32	q1, q3, q7
100068a0:	f852 6026 	ldr.w	r6, [r2, r6, lsl #2]
100068a4:	ef26 6848 	vadd.i32	q3, q3, q4
100068a8:	9630      	str	r6, [sp, #192]	@ 0xc0
100068aa:	f852 5025 	ldr.w	r5, [r2, r5, lsl #2]
100068ae:	ee12 6a10 	vmov	r6, s4
100068b2:	9531      	str	r5, [sp, #196]	@ 0xc4
100068b4:	f852 4024 	ldr.w	r4, [r2, r4, lsl #2]
100068b8:	ee32 5b10 	vmov.32	r5, d2[1]
100068bc:	9432      	str	r4, [sp, #200]	@ 0xc8
100068be:	f852 0020 	ldr.w	r0, [r2, r0, lsl #2]
100068c2:	ee13 4b10 	vmov.32	r4, d3[0]
100068c6:	9033      	str	r0, [sp, #204]	@ 0xcc
100068c8:	ee33 0b10 	vmov.32	r0, d3[1]
100068cc:	ed9d 3f34 	vldrw.u32	q1, [sp, #208]
100068d0:	ef02 2154 	vand	q1, q1, q2
100068d4:	ed9d 5f00 	vldrw.u32	q2, [sp, #0]
100068d8:	ef24 4152 	vorr	q2, q2, q1
100068dc:	f852 6026 	ldr.w	r6, [r2, r6, lsl #2]
100068e0:	ed8d 7f0c 	vstrw.32	q3, [sp, #48]
100068e4:	962c      	str	r6, [sp, #176]	@ 0xb0
100068e6:	f852 5025 	ldr.w	r5, [r2, r5, lsl #2]
100068ea:	952d      	str	r5, [sp, #180]	@ 0xb4
100068ec:	f852 4024 	ldr.w	r4, [r2, r4, lsl #2]
100068f0:	942e      	str	r4, [sp, #184]	@ 0xb8
100068f2:	f852 0020 	ldr.w	r0, [r2, r0, lsl #2]
100068f6:	902f      	str	r0, [sp, #188]	@ 0xbc
100068f8:	ed8d 5f00 	vstrw.32	q2, [sp, #0]
100068fc:	ed9d 7f10 	vldrw.u32	q3, [sp, #64]
10006900:	ed9d 5f30 	vldrw.u32	q2, [sp, #192]
10006904:	ef04 4156 	vand	q2, q2, q3
10006908:	ed9d 7f04 	vldrw.u32	q3, [sp, #16]
1000690c:	ef26 6154 	vorr	q3, q3, q2
10006910:	ed8d 7f04 	vstrw.32	q3, [sp, #16]
10006914:	ed9d 7f2c 	vldrw.u32	q3, [sp, #176]
10006918:	ed9d 5f08 	vldrw.u32	q2, [sp, #32]
1000691c:	ef06 6150 	vand	q3, q3, q0
10006920:	ef24 6156 	vorr	q3, q2, q3
10006924:	ed8d 7f08 	vstrw.32	q3, [sp, #32]
10006928:	f00f c095 	le	lr, 10006804 <fndsa_poly_big_to_fp64_exact+0xfc>
1000692c:	ed9d 7f00 	vldrw.u32	q3, [sp, #0]
10006930:	ed9d 5f04 	vldrw.u32	q2, [sp, #16]
10006934:	ee37 0b10 	vmov.32	r0, d7[1]
10006938:	ee16 6a10 	vmov	r6, s12
1000693c:	ee36 5b10 	vmov.32	r5, d6[1]
10006940:	4306      	orrs	r6, r0
10006942:	ee14 0a10 	vmov	r0, s8
10006946:	ee34 cb10 	vmov.32	ip, d4[1]
1000694a:	4305      	orrs	r5, r0
1000694c:	ee17 0b10 	vmov.32	r0, d7[0]
10006950:	ea40 000c 	orr.w	r0, r0, ip
10006954:	ee15 cb10 	vmov.32	ip, d5[0]
10006958:	ed9d 7f08 	vldrw.u32	q3, [sp, #32]
1000695c:	ea46 060c 	orr.w	r6, r6, ip
10006960:	ee35 cb10 	vmov.32	ip, d5[1]
10006964:	ea45 050c 	orr.w	r5, r5, ip
10006968:	ee16 ca10 	vmov	ip, s12
1000696c:	ea40 000c 	orr.w	r0, r0, ip
10006970:	ee36 cb10 	vmov.32	ip, d6[1]
10006974:	ea46 060c 	orr.w	r6, r6, ip
10006978:	ee17 cb10 	vmov.32	ip, d7[0]
1000697c:	ea45 050c 	orr.w	r5, r5, ip
10006980:	ee37 cb10 	vmov.32	ip, d7[1]
10006984:	079c      	lsls	r4, r3, #30
10006986:	ea40 000c 	orr.w	r0, r0, ip
1000698a:	f000 80f1 	beq.w	10006b70 <fndsa_poly_big_to_fp64_exact+0x468>
1000698e:	f023 0c03 	bic.w	ip, r3, #3
10006992:	e031      	b.n	100069f8 <fndsa_poly_big_to_fp64_exact+0x2f0>
10006994:	f3af 8000 	nop.w
10006998:	ffffffff 	.word	0xffffffff
1000699c:	00000001 	.word	0x00000001
100069a0:	00000000 	.word	0x00000000
100069a4:	ffffffff 	.word	0xffffffff
100069a8:	00000000 	.word	0x00000000
100069ac:	ffffffff 	.word	0xffffffff
100069b0:	00000001 	.word	0x00000001
100069b4:	00000000 	.word	0x00000000
100069b8:	00000001 	.word	0x00000001
100069bc:	00000000 	.word	0x00000000
100069c0:	ffffffff 	.word	0xffffffff
100069c4:	00000001 	.word	0x00000001
100069c8:	00000002 	.word	0x00000002
100069cc:	00000003 	.word	0x00000003
100069d0:	00000003 	.word	0x00000003
100069d4:	00000003 	.word	0x00000003
100069d8:	00000001 	.word	0x00000001
100069dc:	00000001 	.word	0x00000001
100069e0:	00000002 	.word	0x00000002
100069e4:	00000002 	.word	0x00000002
	...
100069f4:	00000001 	.word	0x00000001
100069f8:	9c2b      	ldr	r4, [sp, #172]	@ 0xac
100069fa:	fa0c fe07 	lsl.w	lr, ip, r7
100069fe:	f852 a02e 	ldr.w	sl, [r2, lr, lsl #2]
10006a02:	ea84 0e0c 	eor.w	lr, r4, ip
10006a06:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10006a0a:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10006a0e:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
10006a12:	ea40 000e 	orr.w	r0, r0, lr
10006a16:	ea88 0e0c 	eor.w	lr, r8, ip
10006a1a:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10006a1e:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10006a22:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
10006a26:	ea45 050e 	orr.w	r5, r5, lr
10006a2a:	ea89 0e0c 	eor.w	lr, r9, ip
10006a2e:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10006a32:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10006a36:	ea0a 7aee 	and.w	sl, sl, lr, asr #31
10006a3a:	f10c 0e01 	add.w	lr, ip, #1
10006a3e:	4573      	cmp	r3, lr
10006a40:	ea46 060a 	orr.w	r6, r6, sl
10006a44:	f240 8094 	bls.w	10006b70 <fndsa_poly_big_to_fp64_exact+0x468>
10006a48:	fa0e fa07 	lsl.w	sl, lr, r7
10006a4c:	f852 b02a 	ldr.w	fp, [r2, sl, lsl #2]
10006a50:	ea84 0a0e 	eor.w	sl, r4, lr
10006a54:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10006a58:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10006a5c:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10006a60:	ea40 000a 	orr.w	r0, r0, sl
10006a64:	ea88 0a0e 	eor.w	sl, r8, lr
10006a68:	ea89 0e0e 	eor.w	lr, r9, lr
10006a6c:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10006a70:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10006a74:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10006a78:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10006a7c:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10006a80:	ea0b 7bee 	and.w	fp, fp, lr, asr #31
10006a84:	f10c 0e02 	add.w	lr, ip, #2
10006a88:	4573      	cmp	r3, lr
10006a8a:	ea45 050a 	orr.w	r5, r5, sl
10006a8e:	ea46 060b 	orr.w	r6, r6, fp
10006a92:	d96d      	bls.n	10006b70 <fndsa_poly_big_to_fp64_exact+0x468>
10006a94:	fa0e fa07 	lsl.w	sl, lr, r7
10006a98:	f852 b02a 	ldr.w	fp, [r2, sl, lsl #2]
10006a9c:	ea84 0a0e 	eor.w	sl, r4, lr
10006aa0:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10006aa4:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10006aa8:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10006aac:	ea40 000a 	orr.w	r0, r0, sl
10006ab0:	ea88 0a0e 	eor.w	sl, r8, lr
10006ab4:	ea89 0e0e 	eor.w	lr, r9, lr
10006ab8:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10006abc:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10006ac0:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10006ac4:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10006ac8:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10006acc:	ea0b 7bee 	and.w	fp, fp, lr, asr #31
10006ad0:	f10c 0e03 	add.w	lr, ip, #3
10006ad4:	4573      	cmp	r3, lr
10006ad6:	ea45 050a 	orr.w	r5, r5, sl
10006ada:	ea46 060b 	orr.w	r6, r6, fp
10006ade:	d947      	bls.n	10006b70 <fndsa_poly_big_to_fp64_exact+0x468>
10006ae0:	fa0e fa07 	lsl.w	sl, lr, r7
10006ae4:	f852 b02a 	ldr.w	fp, [r2, sl, lsl #2]
10006ae8:	ea84 0a0e 	eor.w	sl, r4, lr
10006aec:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10006af0:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10006af4:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10006af8:	ea40 000a 	orr.w	r0, r0, sl
10006afc:	ea88 0a0e 	eor.w	sl, r8, lr
10006b00:	ea89 0e0e 	eor.w	lr, r9, lr
10006b04:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10006b08:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10006b0c:	f10c 0c04 	add.w	ip, ip, #4
10006b10:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10006b14:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10006b18:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10006b1c:	4563      	cmp	r3, ip
10006b1e:	ea0b 7bee 	and.w	fp, fp, lr, asr #31
10006b22:	ea45 050a 	orr.w	r5, r5, sl
10006b26:	ea46 060b 	orr.w	r6, r6, fp
10006b2a:	d921      	bls.n	10006b70 <fndsa_poly_big_to_fp64_exact+0x468>
10006b2c:	fa0c fe07 	lsl.w	lr, ip, r7
10006b30:	f852 a02e 	ldr.w	sl, [r2, lr, lsl #2]
10006b34:	ea84 0e0c 	eor.w	lr, r4, ip
10006b38:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10006b3c:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10006b40:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
10006b44:	ea40 000e 	orr.w	r0, r0, lr
10006b48:	ea88 0e0c 	eor.w	lr, r8, ip
10006b4c:	ea89 0c0c 	eor.w	ip, r9, ip
10006b50:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10006b54:	f02c 4c7f 	bic.w	ip, ip, #4278190080	@ 0xff000000
10006b58:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10006b5c:	f10c 3cff 	add.w	ip, ip, #4294967295	@ 0xffffffff
10006b60:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
10006b64:	ea0a 7aec 	and.w	sl, sl, ip, asr #31
10006b68:	ea45 050e 	orr.w	r5, r5, lr
10006b6c:	ea46 060a 	orr.w	r6, r6, sl
10006b70:	9c20      	ldr	r4, [sp, #128]	@ 0x80
10006b72:	3204      	adds	r2, #4
10006b74:	f854 cf04 	ldr.w	ip, [r4, #4]!
10006b78:	3110      	adds	r1, #16
10006b7a:	9420      	str	r4, [sp, #128]	@ 0x80
10006b7c:	ea4f 7c9c 	mov.w	ip, ip, lsr #30
10006b80:	9c24      	ldr	r4, [sp, #144]	@ 0x90
10006b82:	f1cc 0c00 	rsb	ip, ip, #0
10006b86:	ea04 0e5c 	and.w	lr, r4, ip, lsr #1
10006b8a:	ea4e 0e06 	orr.w	lr, lr, r6
10006b8e:	ea4f 064e 	mov.w	r6, lr, lsl #1
10006b92:	9c28      	ldr	r4, [sp, #160]	@ 0xa0
10006b94:	f006 4600 	and.w	r6, r6, #2147483648	@ 0x80000000
10006b98:	ea46 060e 	orr.w	r6, r6, lr
10006b9c:	40a6      	lsls	r6, r4
10006b9e:	9c23      	ldr	r4, [sp, #140]	@ 0x8c
10006ba0:	ea04 0e5c 	and.w	lr, r4, ip, lsr #1
10006ba4:	9c22      	ldr	r4, [sp, #136]	@ 0x88
10006ba6:	ea4e 0e05 	orr.w	lr, lr, r5
10006baa:	ea04 0c5c 	and.w	ip, r4, ip, lsr #1
10006bae:	ea4c 0c00 	orr.w	ip, ip, r0
10006bb2:	9826      	ldr	r0, [sp, #152]	@ 0x98
10006bb4:	fa2c fc00 	lsr.w	ip, ip, r0
10006bb8:	9827      	ldr	r0, [sp, #156]	@ 0x9c
10006bba:	fa0e f000 	lsl.w	r0, lr, r0
10006bbe:	ea4c 0c00 	orr.w	ip, ip, r0
10006bc2:	9825      	ldr	r0, [sp, #148]	@ 0x94
10006bc4:	fa2e fe00 	lsr.w	lr, lr, r0
10006bc8:	ea46 060e 	orr.w	r6, r6, lr
10006bcc:	ee07 6a90 	vmov	s15, r6
10006bd0:	eeb8 6b67 	vcvt.f64.u32	d6, s15
10006bd4:	ee07 ca90 	vmov	s15, ip
10006bd8:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10006bdc:	9829      	ldr	r0, [sp, #164]	@ 0xa4
10006bde:	ed01 6b04 	vstr	d6, [r1, #-16]
10006be2:	4282      	cmp	r2, r0
10006be4:	ed01 7b02 	vstr	d7, [r1, #-8]
10006be8:	f47f adef 	bne.w	100067ca <fndsa_poly_big_to_fp64_exact+0xc2>
10006bec:	b039      	add	sp, #228	@ 0xe4
10006bee:	ecbd 8b10 	vpop	{d8-d15}
10006bf2:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10006bf6:	f04f 0c00 	mov.w	ip, #0
10006bfa:	4666      	mov	r6, ip
10006bfc:	4665      	mov	r5, ip
10006bfe:	4660      	mov	r0, ip
10006c00:	e6fa      	b.n	100069f8 <fndsa_poly_big_to_fp64_exact+0x2f0>
10006c02:	2210      	movs	r2, #16
10006c04:	4619      	mov	r1, r3
10006c06:	40ba      	lsls	r2, r7
10006c08:	b039      	add	sp, #228	@ 0xe4
10006c0a:	ecbd 8b10 	vpop	{d8-d15}
10006c0e:	e8bd 4ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10006c12:	f00c bac1 	b.w	10013198 <memset>
10006c16:	bf00      	nop

