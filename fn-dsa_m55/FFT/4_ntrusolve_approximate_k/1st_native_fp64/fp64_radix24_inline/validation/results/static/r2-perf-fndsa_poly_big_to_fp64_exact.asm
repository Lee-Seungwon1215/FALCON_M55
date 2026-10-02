
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/r2-perf/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

100077f8 <fndsa_poly_big_to_fp64_exact>:
100077f8:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
100077fc:	ed2d 8b10 	vpush	{d8-d15}
10007800:	b0b9      	sub	sp, #228	@ 0xe4
10007802:	4607      	mov	r7, r0
10007804:	9d52      	ldr	r5, [sp, #328]	@ 0x148
10007806:	4608      	mov	r0, r1
10007808:	2b00      	cmp	r3, #0
1000780a:	f000 8272 	beq.w	10007cf2 <fndsa_poly_big_to_fp64_exact+0x4fa>
1000780e:	eb05 1145 	add.w	r1, r5, r5, lsl #5
10007812:	eb01 2181 	add.w	r1, r1, r1, lsl #10
10007816:	eb05 0441 	add.w	r4, r5, r1, lsl #1
1000781a:	0d64      	lsrs	r4, r4, #21
1000781c:	4601      	mov	r1, r0
1000781e:	ebc4 1044 	rsb	r0, r4, r4, lsl #5
10007822:	1a2d      	subs	r5, r5, r0
10007824:	1e6e      	subs	r6, r5, #1
10007826:	eba4 78d6 	sub.w	r8, r4, r6, lsr #31
1000782a:	eea6 8b10 	vdup.32	q3, r8
1000782e:	ed9f 0b96 	vldr	d0, [pc, #600]	@ 10007a88 <fndsa_poly_big_to_fp64_exact+0x290>
10007832:	ed9f 1b97 	vldr	d1, [pc, #604]	@ 10007a90 <fndsa_poly_big_to_fp64_exact+0x298>
10007836:	ed9f 2b98 	vldr	d2, [pc, #608]	@ 10007a98 <fndsa_poly_big_to_fp64_exact+0x2a0>
1000783a:	ed9f 3b99 	vldr	d3, [pc, #612]	@ 10007aa0 <fndsa_poly_big_to_fp64_exact+0x2a8>
1000783e:	ed9f 4b9a 	vldr	d4, [pc, #616]	@ 10007aa8 <fndsa_poly_big_to_fp64_exact+0x2b0>
10007842:	ed9f 5b9b 	vldr	d5, [pc, #620]	@ 10007ab0 <fndsa_poly_big_to_fp64_exact+0x2b8>
10007846:	ef26 0840 	vadd.i32	q0, q3, q0
1000784a:	ef26 2842 	vadd.i32	q1, q3, q1
1000784e:	ef26 6844 	vadd.i32	q3, q3, q2
10007852:	1b18      	subs	r0, r3, r4
10007854:	17f4      	asrs	r4, r6, #31
10007856:	f004 041f 	and.w	r4, r4, #31
1000785a:	eb00 70d6 	add.w	r0, r0, r6, lsr #31
1000785e:	ea44 0605 	orr.w	r6, r4, r5
10007862:	2404      	movs	r4, #4
10007864:	eeae 7b10 	vdup.32	q7, r7
10007868:	ed8d 1f14 	vstrw.32	q0, [sp, #80]
1000786c:	ed8d 3f18 	vstrw.32	q1, [sp, #96]
10007870:	ed8d 7f1c 	vstrw.32	q3, [sp, #112]
10007874:	1e5d      	subs	r5, r3, #1
10007876:	9521      	str	r5, [sp, #132]	@ 0x84
10007878:	1e45      	subs	r5, r0, #1
1000787a:	17ed      	asrs	r5, r5, #31
1000787c:	9523      	str	r5, [sp, #140]	@ 0x8c
1000787e:	40bc      	lsls	r4, r7
10007880:	1e85      	subs	r5, r0, #2
10007882:	17c0      	asrs	r0, r0, #31
10007884:	1914      	adds	r4, r2, r4
10007886:	9022      	str	r0, [sp, #136]	@ 0x88
10007888:	17e8      	asrs	r0, r5, #31
1000788a:	1e5d      	subs	r5, r3, #1
1000788c:	40bd      	lsls	r5, r7
1000788e:	9024      	str	r0, [sp, #144]	@ 0x90
10007890:	9429      	str	r4, [sp, #164]	@ 0xa4
10007892:	1f10      	subs	r0, r2, #4
10007894:	f1c6 0420 	rsb	r4, r6, #32
10007898:	eb00 0085 	add.w	r0, r0, r5, lsl #2
1000789c:	9427      	str	r4, [sp, #156]	@ 0x9c
1000789e:	f1c6 041f 	rsb	r4, r6, #31
100078a2:	9020      	str	r0, [sp, #128]	@ 0x80
100078a4:	1e75      	subs	r5, r6, #1
100078a6:	f108 30ff 	add.w	r0, r8, #4294967295	@ 0xffffffff
100078aa:	9428      	str	r4, [sp, #160]	@ 0xa0
100078ac:	089c      	lsrs	r4, r3, #2
100078ae:	9625      	str	r6, [sp, #148]	@ 0x94
100078b0:	f108 0901 	add.w	r9, r8, #1
100078b4:	9526      	str	r5, [sp, #152]	@ 0x98
100078b6:	942a      	str	r4, [sp, #168]	@ 0xa8
100078b8:	902b      	str	r0, [sp, #172]	@ 0xac
100078ba:	9821      	ldr	r0, [sp, #132]	@ 0x84
100078bc:	2804      	cmp	r0, #4
100078be:	f240 8212 	bls.w	10007ce6 <fndsa_poly_big_to_fp64_exact+0x4ee>
100078c2:	ef80 6050 	vmov.i32	q3, #0	@ 0x00000000
100078c6:	ed9f 8b7c 	vldr	d8, [pc, #496]	@ 10007ab8 <fndsa_poly_big_to_fp64_exact+0x2c0>
100078ca:	ed9f 9b7d 	vldr	d9, [pc, #500]	@ 10007ac0 <fndsa_poly_big_to_fp64_exact+0x2c8>
100078ce:	982a      	ldr	r0, [sp, #168]	@ 0xa8
100078d0:	ed8d 7f08 	vstrw.32	q3, [sp, #32]
100078d4:	f040 e001 	dls	lr, r0
100078d8:	ed8d 7f04 	vstrw.32	q3, [sp, #16]
100078dc:	ed8d 7f00 	vstrw.32	q3, [sp, #0]
100078e0:	ed9f cb79 	vldr	d12, [pc, #484]	@ 10007ac8 <fndsa_poly_big_to_fp64_exact+0x2d0>
100078e4:	ed9f db7a 	vldr	d13, [pc, #488]	@ 10007ad0 <fndsa_poly_big_to_fp64_exact+0x2d8>
100078e8:	ed9f ab7b 	vldr	d10, [pc, #492]	@ 10007ad8 <fndsa_poly_big_to_fp64_exact+0x2e0>
100078ec:	ed9f bb7c 	vldr	d11, [pc, #496]	@ 10007ae0 <fndsa_poly_big_to_fp64_exact+0x2e8>
100078f0:	ed8d 9f0c 	vstrw.32	q4, [sp, #48]
100078f4:	ff2e 644a 	vshl.u32	q3, q5, q7
100078f8:	ee16 6a10 	vmov	r6, s12
100078fc:	ee36 5b10 	vmov.32	r5, d6[1]
10007900:	ee17 4b10 	vmov.32	r4, d7[0]
10007904:	ee37 0b10 	vmov.32	r0, d7[1]
10007908:	ed9d 7f1c 	vldrw.u32	q3, [sp, #112]
1000790c:	ed9d 1f18 	vldrw.u32	q0, [sp, #96]
10007910:	ff0a 4156 	veor	q2, q5, q3
10007914:	ef80 6054 	vmov.i32	q3, #4	@ 0x00000004
10007918:	ef26 8156 	vmov	q4, q3
1000791c:	ef2a a846 	vadd.i32	q5, q5, q3
10007920:	ff0c 6150 	veor	q3, q6, q0
10007924:	ff87 2e5f 	vmov.i8	q1, #255	@ 0xff
10007928:	ff87 677f 	vbic.i32	q3, #4278190080	@ 0xff000000
1000792c:	ef26 6842 	vadd.i32	q3, q3, q1
10007930:	efa1 6056 	vshr.s32	q3, q3, #31
10007934:	ed9d 1f14 	vldrw.u32	q0, [sp, #80]
10007938:	ed8d 7f10 	vstrw.32	q3, [sp, #64]
1000793c:	ed9d 7f0c 	vldrw.u32	q3, [sp, #48]
10007940:	ff06 0150 	veor	q0, q3, q0
10007944:	ff87 477f 	vbic.i32	q2, #4278190080	@ 0xff000000
10007948:	ff87 077f 	vbic.i32	q0, #4278190080	@ 0xff000000
1000794c:	ef24 4842 	vadd.i32	q2, q2, q1
10007950:	ef20 0842 	vadd.i32	q0, q0, q1
10007954:	ff2e 244c 	vshl.u32	q1, q6, q7
10007958:	f852 6026 	ldr.w	r6, [r2, r6, lsl #2]
1000795c:	efa1 4054 	vshr.s32	q2, q2, #31
10007960:	9634      	str	r6, [sp, #208]	@ 0xd0
10007962:	ee12 6a10 	vmov	r6, s4
10007966:	f852 5025 	ldr.w	r5, [r2, r5, lsl #2]
1000796a:	efa1 0050 	vshr.s32	q0, q0, #31
1000796e:	9535      	str	r5, [sp, #212]	@ 0xd4
10007970:	ee32 5b10 	vmov.32	r5, d2[1]
10007974:	f852 4024 	ldr.w	r4, [r2, r4, lsl #2]
10007978:	ef2c c848 	vadd.i32	q6, q6, q4
1000797c:	9436      	str	r4, [sp, #216]	@ 0xd8
1000797e:	ee13 4b10 	vmov.32	r4, d3[0]
10007982:	f852 0020 	ldr.w	r0, [r2, r0, lsl #2]
10007986:	9037      	str	r0, [sp, #220]	@ 0xdc
10007988:	ee33 0b10 	vmov.32	r0, d3[1]
1000798c:	ff2e 2446 	vshl.u32	q1, q3, q7
10007990:	f852 6026 	ldr.w	r6, [r2, r6, lsl #2]
10007994:	ef26 6848 	vadd.i32	q3, q3, q4
10007998:	9630      	str	r6, [sp, #192]	@ 0xc0
1000799a:	f852 5025 	ldr.w	r5, [r2, r5, lsl #2]
1000799e:	ee12 6a10 	vmov	r6, s4
100079a2:	9531      	str	r5, [sp, #196]	@ 0xc4
100079a4:	f852 4024 	ldr.w	r4, [r2, r4, lsl #2]
100079a8:	ee32 5b10 	vmov.32	r5, d2[1]
100079ac:	9432      	str	r4, [sp, #200]	@ 0xc8
100079ae:	f852 0020 	ldr.w	r0, [r2, r0, lsl #2]
100079b2:	ee13 4b10 	vmov.32	r4, d3[0]
100079b6:	9033      	str	r0, [sp, #204]	@ 0xcc
100079b8:	ee33 0b10 	vmov.32	r0, d3[1]
100079bc:	ed9d 3f34 	vldrw.u32	q1, [sp, #208]
100079c0:	ef02 2154 	vand	q1, q1, q2
100079c4:	ed9d 5f00 	vldrw.u32	q2, [sp, #0]
100079c8:	ef24 4152 	vorr	q2, q2, q1
100079cc:	f852 6026 	ldr.w	r6, [r2, r6, lsl #2]
100079d0:	ed8d 7f0c 	vstrw.32	q3, [sp, #48]
100079d4:	962c      	str	r6, [sp, #176]	@ 0xb0
100079d6:	f852 5025 	ldr.w	r5, [r2, r5, lsl #2]
100079da:	952d      	str	r5, [sp, #180]	@ 0xb4
100079dc:	f852 4024 	ldr.w	r4, [r2, r4, lsl #2]
100079e0:	942e      	str	r4, [sp, #184]	@ 0xb8
100079e2:	f852 0020 	ldr.w	r0, [r2, r0, lsl #2]
100079e6:	902f      	str	r0, [sp, #188]	@ 0xbc
100079e8:	ed8d 5f00 	vstrw.32	q2, [sp, #0]
100079ec:	ed9d 7f10 	vldrw.u32	q3, [sp, #64]
100079f0:	ed9d 5f30 	vldrw.u32	q2, [sp, #192]
100079f4:	ef04 4156 	vand	q2, q2, q3
100079f8:	ed9d 7f04 	vldrw.u32	q3, [sp, #16]
100079fc:	ef26 6154 	vorr	q3, q3, q2
10007a00:	ed8d 7f04 	vstrw.32	q3, [sp, #16]
10007a04:	ed9d 7f2c 	vldrw.u32	q3, [sp, #176]
10007a08:	ed9d 5f08 	vldrw.u32	q2, [sp, #32]
10007a0c:	ef06 6150 	vand	q3, q3, q0
10007a10:	ef24 6156 	vorr	q3, q2, q3
10007a14:	ed8d 7f08 	vstrw.32	q3, [sp, #32]
10007a18:	f00f c095 	le	lr, 100078f4 <fndsa_poly_big_to_fp64_exact+0xfc>
10007a1c:	ed9d 7f00 	vldrw.u32	q3, [sp, #0]
10007a20:	ed9d 5f04 	vldrw.u32	q2, [sp, #16]
10007a24:	ee37 0b10 	vmov.32	r0, d7[1]
10007a28:	ee16 6a10 	vmov	r6, s12
10007a2c:	ee36 5b10 	vmov.32	r5, d6[1]
10007a30:	4306      	orrs	r6, r0
10007a32:	ee14 0a10 	vmov	r0, s8
10007a36:	ee34 cb10 	vmov.32	ip, d4[1]
10007a3a:	4305      	orrs	r5, r0
10007a3c:	ee17 0b10 	vmov.32	r0, d7[0]
10007a40:	ea40 000c 	orr.w	r0, r0, ip
10007a44:	ee15 cb10 	vmov.32	ip, d5[0]
10007a48:	ed9d 7f08 	vldrw.u32	q3, [sp, #32]
10007a4c:	ea46 060c 	orr.w	r6, r6, ip
10007a50:	ee35 cb10 	vmov.32	ip, d5[1]
10007a54:	ea45 050c 	orr.w	r5, r5, ip
10007a58:	ee16 ca10 	vmov	ip, s12
10007a5c:	ea40 000c 	orr.w	r0, r0, ip
10007a60:	ee36 cb10 	vmov.32	ip, d6[1]
10007a64:	ea46 060c 	orr.w	r6, r6, ip
10007a68:	ee17 cb10 	vmov.32	ip, d7[0]
10007a6c:	ea45 050c 	orr.w	r5, r5, ip
10007a70:	ee37 cb10 	vmov.32	ip, d7[1]
10007a74:	079c      	lsls	r4, r3, #30
10007a76:	ea40 000c 	orr.w	r0, r0, ip
10007a7a:	f000 80f1 	beq.w	10007c60 <fndsa_poly_big_to_fp64_exact+0x468>
10007a7e:	f023 0c03 	bic.w	ip, r3, #3
10007a82:	e031      	b.n	10007ae8 <fndsa_poly_big_to_fp64_exact+0x2f0>
10007a84:	f3af 8000 	nop.w
10007a88:	ffffffff 	.word	0xffffffff
10007a8c:	00000001 	.word	0x00000001
10007a90:	00000000 	.word	0x00000000
10007a94:	ffffffff 	.word	0xffffffff
10007a98:	00000000 	.word	0x00000000
10007a9c:	ffffffff 	.word	0xffffffff
10007aa0:	00000001 	.word	0x00000001
10007aa4:	00000000 	.word	0x00000000
10007aa8:	00000001 	.word	0x00000001
10007aac:	00000000 	.word	0x00000000
10007ab0:	ffffffff 	.word	0xffffffff
10007ab4:	00000001 	.word	0x00000001
10007ab8:	00000002 	.word	0x00000002
10007abc:	00000003 	.word	0x00000003
10007ac0:	00000003 	.word	0x00000003
10007ac4:	00000003 	.word	0x00000003
10007ac8:	00000001 	.word	0x00000001
10007acc:	00000001 	.word	0x00000001
10007ad0:	00000002 	.word	0x00000002
10007ad4:	00000002 	.word	0x00000002
	...
10007ae4:	00000001 	.word	0x00000001
10007ae8:	9c2b      	ldr	r4, [sp, #172]	@ 0xac
10007aea:	fa0c fe07 	lsl.w	lr, ip, r7
10007aee:	f852 a02e 	ldr.w	sl, [r2, lr, lsl #2]
10007af2:	ea84 0e0c 	eor.w	lr, r4, ip
10007af6:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10007afa:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10007afe:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
10007b02:	ea40 000e 	orr.w	r0, r0, lr
10007b06:	ea88 0e0c 	eor.w	lr, r8, ip
10007b0a:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10007b0e:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10007b12:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
10007b16:	ea45 050e 	orr.w	r5, r5, lr
10007b1a:	ea89 0e0c 	eor.w	lr, r9, ip
10007b1e:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10007b22:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10007b26:	ea0a 7aee 	and.w	sl, sl, lr, asr #31
10007b2a:	f10c 0e01 	add.w	lr, ip, #1
10007b2e:	4573      	cmp	r3, lr
10007b30:	ea46 060a 	orr.w	r6, r6, sl
10007b34:	f240 8094 	bls.w	10007c60 <fndsa_poly_big_to_fp64_exact+0x468>
10007b38:	fa0e fa07 	lsl.w	sl, lr, r7
10007b3c:	f852 b02a 	ldr.w	fp, [r2, sl, lsl #2]
10007b40:	ea84 0a0e 	eor.w	sl, r4, lr
10007b44:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10007b48:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10007b4c:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10007b50:	ea40 000a 	orr.w	r0, r0, sl
10007b54:	ea88 0a0e 	eor.w	sl, r8, lr
10007b58:	ea89 0e0e 	eor.w	lr, r9, lr
10007b5c:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10007b60:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10007b64:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10007b68:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10007b6c:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10007b70:	ea0b 7bee 	and.w	fp, fp, lr, asr #31
10007b74:	f10c 0e02 	add.w	lr, ip, #2
10007b78:	4573      	cmp	r3, lr
10007b7a:	ea45 050a 	orr.w	r5, r5, sl
10007b7e:	ea46 060b 	orr.w	r6, r6, fp
10007b82:	d96d      	bls.n	10007c60 <fndsa_poly_big_to_fp64_exact+0x468>
10007b84:	fa0e fa07 	lsl.w	sl, lr, r7
10007b88:	f852 b02a 	ldr.w	fp, [r2, sl, lsl #2]
10007b8c:	ea84 0a0e 	eor.w	sl, r4, lr
10007b90:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10007b94:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10007b98:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10007b9c:	ea40 000a 	orr.w	r0, r0, sl
10007ba0:	ea88 0a0e 	eor.w	sl, r8, lr
10007ba4:	ea89 0e0e 	eor.w	lr, r9, lr
10007ba8:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10007bac:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10007bb0:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10007bb4:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10007bb8:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10007bbc:	ea0b 7bee 	and.w	fp, fp, lr, asr #31
10007bc0:	f10c 0e03 	add.w	lr, ip, #3
10007bc4:	4573      	cmp	r3, lr
10007bc6:	ea45 050a 	orr.w	r5, r5, sl
10007bca:	ea46 060b 	orr.w	r6, r6, fp
10007bce:	d947      	bls.n	10007c60 <fndsa_poly_big_to_fp64_exact+0x468>
10007bd0:	fa0e fa07 	lsl.w	sl, lr, r7
10007bd4:	f852 b02a 	ldr.w	fp, [r2, sl, lsl #2]
10007bd8:	ea84 0a0e 	eor.w	sl, r4, lr
10007bdc:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10007be0:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10007be4:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10007be8:	ea40 000a 	orr.w	r0, r0, sl
10007bec:	ea88 0a0e 	eor.w	sl, r8, lr
10007bf0:	ea89 0e0e 	eor.w	lr, r9, lr
10007bf4:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10007bf8:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10007bfc:	f10c 0c04 	add.w	ip, ip, #4
10007c00:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10007c04:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10007c08:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10007c0c:	4563      	cmp	r3, ip
10007c0e:	ea0b 7bee 	and.w	fp, fp, lr, asr #31
10007c12:	ea45 050a 	orr.w	r5, r5, sl
10007c16:	ea46 060b 	orr.w	r6, r6, fp
10007c1a:	d921      	bls.n	10007c60 <fndsa_poly_big_to_fp64_exact+0x468>
10007c1c:	fa0c fe07 	lsl.w	lr, ip, r7
10007c20:	f852 a02e 	ldr.w	sl, [r2, lr, lsl #2]
10007c24:	ea84 0e0c 	eor.w	lr, r4, ip
10007c28:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10007c2c:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10007c30:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
10007c34:	ea40 000e 	orr.w	r0, r0, lr
10007c38:	ea88 0e0c 	eor.w	lr, r8, ip
10007c3c:	ea89 0c0c 	eor.w	ip, r9, ip
10007c40:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10007c44:	f02c 4c7f 	bic.w	ip, ip, #4278190080	@ 0xff000000
10007c48:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10007c4c:	f10c 3cff 	add.w	ip, ip, #4294967295	@ 0xffffffff
10007c50:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
10007c54:	ea0a 7aec 	and.w	sl, sl, ip, asr #31
10007c58:	ea45 050e 	orr.w	r5, r5, lr
10007c5c:	ea46 060a 	orr.w	r6, r6, sl
10007c60:	9c20      	ldr	r4, [sp, #128]	@ 0x80
10007c62:	3204      	adds	r2, #4
10007c64:	f854 cf04 	ldr.w	ip, [r4, #4]!
10007c68:	3110      	adds	r1, #16
10007c6a:	9420      	str	r4, [sp, #128]	@ 0x80
10007c6c:	ea4f 7c9c 	mov.w	ip, ip, lsr #30
10007c70:	9c24      	ldr	r4, [sp, #144]	@ 0x90
10007c72:	f1cc 0c00 	rsb	ip, ip, #0
10007c76:	ea04 0e5c 	and.w	lr, r4, ip, lsr #1
10007c7a:	ea4e 0e06 	orr.w	lr, lr, r6
10007c7e:	ea4f 064e 	mov.w	r6, lr, lsl #1
10007c82:	9c28      	ldr	r4, [sp, #160]	@ 0xa0
10007c84:	f006 4600 	and.w	r6, r6, #2147483648	@ 0x80000000
10007c88:	ea46 060e 	orr.w	r6, r6, lr
10007c8c:	40a6      	lsls	r6, r4
10007c8e:	9c23      	ldr	r4, [sp, #140]	@ 0x8c
10007c90:	ea04 0e5c 	and.w	lr, r4, ip, lsr #1
10007c94:	9c22      	ldr	r4, [sp, #136]	@ 0x88
10007c96:	ea4e 0e05 	orr.w	lr, lr, r5
10007c9a:	ea04 0c5c 	and.w	ip, r4, ip, lsr #1
10007c9e:	ea4c 0c00 	orr.w	ip, ip, r0
10007ca2:	9826      	ldr	r0, [sp, #152]	@ 0x98
10007ca4:	fa2c fc00 	lsr.w	ip, ip, r0
10007ca8:	9827      	ldr	r0, [sp, #156]	@ 0x9c
10007caa:	fa0e f000 	lsl.w	r0, lr, r0
10007cae:	ea4c 0c00 	orr.w	ip, ip, r0
10007cb2:	9825      	ldr	r0, [sp, #148]	@ 0x94
10007cb4:	fa2e fe00 	lsr.w	lr, lr, r0
10007cb8:	ea46 060e 	orr.w	r6, r6, lr
10007cbc:	ee07 6a90 	vmov	s15, r6
10007cc0:	eeb8 6b67 	vcvt.f64.u32	d6, s15
10007cc4:	ee07 ca90 	vmov	s15, ip
10007cc8:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10007ccc:	9829      	ldr	r0, [sp, #164]	@ 0xa4
10007cce:	ed01 6b04 	vstr	d6, [r1, #-16]
10007cd2:	4282      	cmp	r2, r0
10007cd4:	ed01 7b02 	vstr	d7, [r1, #-8]
10007cd8:	f47f adef 	bne.w	100078ba <fndsa_poly_big_to_fp64_exact+0xc2>
10007cdc:	b039      	add	sp, #228	@ 0xe4
10007cde:	ecbd 8b10 	vpop	{d8-d15}
10007ce2:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10007ce6:	f04f 0c00 	mov.w	ip, #0
10007cea:	4666      	mov	r6, ip
10007cec:	4665      	mov	r5, ip
10007cee:	4660      	mov	r0, ip
10007cf0:	e6fa      	b.n	10007ae8 <fndsa_poly_big_to_fp64_exact+0x2f0>
10007cf2:	2210      	movs	r2, #16
10007cf4:	4619      	mov	r1, r3
10007cf6:	40ba      	lsls	r2, r7
10007cf8:	b039      	add	sp, #228	@ 0xe4
10007cfa:	ecbd 8b10 	vpop	{d8-d15}
10007cfe:	e8bd 4ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10007d02:	f00e bac9 	b.w	10016298 <memset>
