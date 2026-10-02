100068e8 <fndsa_poly_big_to_fp64_exact>:
100068e8:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
100068ec:	ed2d 8b10 	vpush	{d8-d15}
100068f0:	b0b9      	sub	sp, #228	@ 0xe4
100068f2:	4607      	mov	r7, r0
100068f4:	9d52      	ldr	r5, [sp, #328]	@ 0x148
100068f6:	4608      	mov	r0, r1
100068f8:	2b00      	cmp	r3, #0
100068fa:	f000 8272 	beq.w	10006de2 <fndsa_poly_big_to_fp64_exact+0x4fa>
100068fe:	eb05 1145 	add.w	r1, r5, r5, lsl #5
10006902:	eb01 2181 	add.w	r1, r1, r1, lsl #10
10006906:	eb05 0441 	add.w	r4, r5, r1, lsl #1
1000690a:	0d64      	lsrs	r4, r4, #21
1000690c:	4601      	mov	r1, r0
1000690e:	ebc4 1044 	rsb	r0, r4, r4, lsl #5
10006912:	1a2d      	subs	r5, r5, r0
10006914:	1e6e      	subs	r6, r5, #1
10006916:	eba4 78d6 	sub.w	r8, r4, r6, lsr #31
1000691a:	eea6 8b10 	vdup.32	q3, r8
1000691e:	ed9f 0b96 	vldr	d0, [pc, #600]	@ 10006b78 <fndsa_poly_big_to_fp64_exact+0x290>
10006922:	ed9f 1b97 	vldr	d1, [pc, #604]	@ 10006b80 <fndsa_poly_big_to_fp64_exact+0x298>
10006926:	ed9f 2b98 	vldr	d2, [pc, #608]	@ 10006b88 <fndsa_poly_big_to_fp64_exact+0x2a0>
1000692a:	ed9f 3b99 	vldr	d3, [pc, #612]	@ 10006b90 <fndsa_poly_big_to_fp64_exact+0x2a8>
1000692e:	ed9f 4b9a 	vldr	d4, [pc, #616]	@ 10006b98 <fndsa_poly_big_to_fp64_exact+0x2b0>
10006932:	ed9f 5b9b 	vldr	d5, [pc, #620]	@ 10006ba0 <fndsa_poly_big_to_fp64_exact+0x2b8>
10006936:	ef26 0840 	vadd.i32	q0, q3, q0
1000693a:	ef26 2842 	vadd.i32	q1, q3, q1
1000693e:	ef26 6844 	vadd.i32	q3, q3, q2
10006942:	1b18      	subs	r0, r3, r4
10006944:	17f4      	asrs	r4, r6, #31
10006946:	f004 041f 	and.w	r4, r4, #31
1000694a:	eb00 70d6 	add.w	r0, r0, r6, lsr #31
1000694e:	ea44 0605 	orr.w	r6, r4, r5
10006952:	2404      	movs	r4, #4
10006954:	eeae 7b10 	vdup.32	q7, r7
10006958:	ed8d 1f14 	vstrw.32	q0, [sp, #80]
1000695c:	ed8d 3f18 	vstrw.32	q1, [sp, #96]
10006960:	ed8d 7f1c 	vstrw.32	q3, [sp, #112]
10006964:	1e5d      	subs	r5, r3, #1
10006966:	9521      	str	r5, [sp, #132]	@ 0x84
10006968:	1e45      	subs	r5, r0, #1
1000696a:	17ed      	asrs	r5, r5, #31
1000696c:	9523      	str	r5, [sp, #140]	@ 0x8c
1000696e:	40bc      	lsls	r4, r7
10006970:	1e85      	subs	r5, r0, #2
10006972:	17c0      	asrs	r0, r0, #31
10006974:	1914      	adds	r4, r2, r4
10006976:	9022      	str	r0, [sp, #136]	@ 0x88
10006978:	17e8      	asrs	r0, r5, #31
1000697a:	1e5d      	subs	r5, r3, #1
1000697c:	40bd      	lsls	r5, r7
1000697e:	9024      	str	r0, [sp, #144]	@ 0x90
10006980:	9429      	str	r4, [sp, #164]	@ 0xa4
10006982:	1f10      	subs	r0, r2, #4
10006984:	f1c6 0420 	rsb	r4, r6, #32
10006988:	eb00 0085 	add.w	r0, r0, r5, lsl #2
1000698c:	9427      	str	r4, [sp, #156]	@ 0x9c
1000698e:	f1c6 041f 	rsb	r4, r6, #31
10006992:	9020      	str	r0, [sp, #128]	@ 0x80
10006994:	1e75      	subs	r5, r6, #1
10006996:	f108 30ff 	add.w	r0, r8, #4294967295	@ 0xffffffff
1000699a:	9428      	str	r4, [sp, #160]	@ 0xa0
1000699c:	089c      	lsrs	r4, r3, #2
1000699e:	9625      	str	r6, [sp, #148]	@ 0x94
100069a0:	f108 0901 	add.w	r9, r8, #1
100069a4:	9526      	str	r5, [sp, #152]	@ 0x98
100069a6:	942a      	str	r4, [sp, #168]	@ 0xa8
100069a8:	902b      	str	r0, [sp, #172]	@ 0xac
100069aa:	9821      	ldr	r0, [sp, #132]	@ 0x84
100069ac:	2804      	cmp	r0, #4
100069ae:	f240 8212 	bls.w	10006dd6 <fndsa_poly_big_to_fp64_exact+0x4ee>
100069b2:	ef80 6050 	vmov.i32	q3, #0	@ 0x00000000
100069b6:	ed9f 8b7c 	vldr	d8, [pc, #496]	@ 10006ba8 <fndsa_poly_big_to_fp64_exact+0x2c0>
100069ba:	ed9f 9b7d 	vldr	d9, [pc, #500]	@ 10006bb0 <fndsa_poly_big_to_fp64_exact+0x2c8>
100069be:	982a      	ldr	r0, [sp, #168]	@ 0xa8
100069c0:	ed8d 7f08 	vstrw.32	q3, [sp, #32]
100069c4:	f040 e001 	dls	lr, r0
100069c8:	ed8d 7f04 	vstrw.32	q3, [sp, #16]
100069cc:	ed8d 7f00 	vstrw.32	q3, [sp, #0]
100069d0:	ed9f cb79 	vldr	d12, [pc, #484]	@ 10006bb8 <fndsa_poly_big_to_fp64_exact+0x2d0>
100069d4:	ed9f db7a 	vldr	d13, [pc, #488]	@ 10006bc0 <fndsa_poly_big_to_fp64_exact+0x2d8>
100069d8:	ed9f ab7b 	vldr	d10, [pc, #492]	@ 10006bc8 <fndsa_poly_big_to_fp64_exact+0x2e0>
100069dc:	ed9f bb7c 	vldr	d11, [pc, #496]	@ 10006bd0 <fndsa_poly_big_to_fp64_exact+0x2e8>
100069e0:	ed8d 9f0c 	vstrw.32	q4, [sp, #48]
100069e4:	ff2e 644a 	vshl.u32	q3, q5, q7
100069e8:	ee16 6a10 	vmov	r6, s12
100069ec:	ee36 5b10 	vmov.32	r5, d6[1]
100069f0:	ee17 4b10 	vmov.32	r4, d7[0]
100069f4:	ee37 0b10 	vmov.32	r0, d7[1]
100069f8:	ed9d 7f1c 	vldrw.u32	q3, [sp, #112]
100069fc:	ed9d 1f18 	vldrw.u32	q0, [sp, #96]
10006a00:	ff0a 4156 	veor	q2, q5, q3
10006a04:	ef80 6054 	vmov.i32	q3, #4	@ 0x00000004
10006a08:	ef26 8156 	vmov	q4, q3
10006a0c:	ef2a a846 	vadd.i32	q5, q5, q3
10006a10:	ff0c 6150 	veor	q3, q6, q0
10006a14:	ff87 2e5f 	vmov.i8	q1, #255	@ 0xff
10006a18:	ff87 677f 	vbic.i32	q3, #4278190080	@ 0xff000000
10006a1c:	ef26 6842 	vadd.i32	q3, q3, q1
10006a20:	efa1 6056 	vshr.s32	q3, q3, #31
10006a24:	ed9d 1f14 	vldrw.u32	q0, [sp, #80]
10006a28:	ed8d 7f10 	vstrw.32	q3, [sp, #64]
10006a2c:	ed9d 7f0c 	vldrw.u32	q3, [sp, #48]
10006a30:	ff06 0150 	veor	q0, q3, q0
10006a34:	ff87 477f 	vbic.i32	q2, #4278190080	@ 0xff000000
10006a38:	ff87 077f 	vbic.i32	q0, #4278190080	@ 0xff000000
10006a3c:	ef24 4842 	vadd.i32	q2, q2, q1
10006a40:	ef20 0842 	vadd.i32	q0, q0, q1
10006a44:	ff2e 244c 	vshl.u32	q1, q6, q7
10006a48:	f852 6026 	ldr.w	r6, [r2, r6, lsl #2]
10006a4c:	efa1 4054 	vshr.s32	q2, q2, #31
10006a50:	9634      	str	r6, [sp, #208]	@ 0xd0
10006a52:	ee12 6a10 	vmov	r6, s4
10006a56:	f852 5025 	ldr.w	r5, [r2, r5, lsl #2]
10006a5a:	efa1 0050 	vshr.s32	q0, q0, #31
10006a5e:	9535      	str	r5, [sp, #212]	@ 0xd4
10006a60:	ee32 5b10 	vmov.32	r5, d2[1]
10006a64:	f852 4024 	ldr.w	r4, [r2, r4, lsl #2]
10006a68:	ef2c c848 	vadd.i32	q6, q6, q4
10006a6c:	9436      	str	r4, [sp, #216]	@ 0xd8
10006a6e:	ee13 4b10 	vmov.32	r4, d3[0]
10006a72:	f852 0020 	ldr.w	r0, [r2, r0, lsl #2]
10006a76:	9037      	str	r0, [sp, #220]	@ 0xdc
10006a78:	ee33 0b10 	vmov.32	r0, d3[1]
10006a7c:	ff2e 2446 	vshl.u32	q1, q3, q7
10006a80:	f852 6026 	ldr.w	r6, [r2, r6, lsl #2]
10006a84:	ef26 6848 	vadd.i32	q3, q3, q4
10006a88:	9630      	str	r6, [sp, #192]	@ 0xc0
10006a8a:	f852 5025 	ldr.w	r5, [r2, r5, lsl #2]
10006a8e:	ee12 6a10 	vmov	r6, s4
10006a92:	9531      	str	r5, [sp, #196]	@ 0xc4
10006a94:	f852 4024 	ldr.w	r4, [r2, r4, lsl #2]
10006a98:	ee32 5b10 	vmov.32	r5, d2[1]
10006a9c:	9432      	str	r4, [sp, #200]	@ 0xc8
10006a9e:	f852 0020 	ldr.w	r0, [r2, r0, lsl #2]
10006aa2:	ee13 4b10 	vmov.32	r4, d3[0]
10006aa6:	9033      	str	r0, [sp, #204]	@ 0xcc
10006aa8:	ee33 0b10 	vmov.32	r0, d3[1]
10006aac:	ed9d 3f34 	vldrw.u32	q1, [sp, #208]
10006ab0:	ef02 2154 	vand	q1, q1, q2
10006ab4:	ed9d 5f00 	vldrw.u32	q2, [sp, #0]
10006ab8:	ef24 4152 	vorr	q2, q2, q1
10006abc:	f852 6026 	ldr.w	r6, [r2, r6, lsl #2]
10006ac0:	ed8d 7f0c 	vstrw.32	q3, [sp, #48]
10006ac4:	962c      	str	r6, [sp, #176]	@ 0xb0
10006ac6:	f852 5025 	ldr.w	r5, [r2, r5, lsl #2]
10006aca:	952d      	str	r5, [sp, #180]	@ 0xb4
10006acc:	f852 4024 	ldr.w	r4, [r2, r4, lsl #2]
10006ad0:	942e      	str	r4, [sp, #184]	@ 0xb8
10006ad2:	f852 0020 	ldr.w	r0, [r2, r0, lsl #2]
10006ad6:	902f      	str	r0, [sp, #188]	@ 0xbc
10006ad8:	ed8d 5f00 	vstrw.32	q2, [sp, #0]
10006adc:	ed9d 7f10 	vldrw.u32	q3, [sp, #64]
10006ae0:	ed9d 5f30 	vldrw.u32	q2, [sp, #192]
10006ae4:	ef04 4156 	vand	q2, q2, q3
10006ae8:	ed9d 7f04 	vldrw.u32	q3, [sp, #16]
10006aec:	ef26 6154 	vorr	q3, q3, q2
10006af0:	ed8d 7f04 	vstrw.32	q3, [sp, #16]
10006af4:	ed9d 7f2c 	vldrw.u32	q3, [sp, #176]
10006af8:	ed9d 5f08 	vldrw.u32	q2, [sp, #32]
10006afc:	ef06 6150 	vand	q3, q3, q0
10006b00:	ef24 6156 	vorr	q3, q2, q3
10006b04:	ed8d 7f08 	vstrw.32	q3, [sp, #32]
10006b08:	f00f c095 	le	lr, 100069e4 <fndsa_poly_big_to_fp64_exact+0xfc>
10006b0c:	ed9d 7f00 	vldrw.u32	q3, [sp, #0]
10006b10:	ed9d 5f04 	vldrw.u32	q2, [sp, #16]
10006b14:	ee37 0b10 	vmov.32	r0, d7[1]
10006b18:	ee16 6a10 	vmov	r6, s12
10006b1c:	ee36 5b10 	vmov.32	r5, d6[1]
10006b20:	4306      	orrs	r6, r0
10006b22:	ee14 0a10 	vmov	r0, s8
10006b26:	ee34 cb10 	vmov.32	ip, d4[1]
10006b2a:	4305      	orrs	r5, r0
10006b2c:	ee17 0b10 	vmov.32	r0, d7[0]
10006b30:	ea40 000c 	orr.w	r0, r0, ip
10006b34:	ee15 cb10 	vmov.32	ip, d5[0]
10006b38:	ed9d 7f08 	vldrw.u32	q3, [sp, #32]
10006b3c:	ea46 060c 	orr.w	r6, r6, ip
10006b40:	ee35 cb10 	vmov.32	ip, d5[1]
10006b44:	ea45 050c 	orr.w	r5, r5, ip
10006b48:	ee16 ca10 	vmov	ip, s12
10006b4c:	ea40 000c 	orr.w	r0, r0, ip
10006b50:	ee36 cb10 	vmov.32	ip, d6[1]
10006b54:	ea46 060c 	orr.w	r6, r6, ip
10006b58:	ee17 cb10 	vmov.32	ip, d7[0]
10006b5c:	ea45 050c 	orr.w	r5, r5, ip
10006b60:	ee37 cb10 	vmov.32	ip, d7[1]
10006b64:	079c      	lsls	r4, r3, #30
10006b66:	ea40 000c 	orr.w	r0, r0, ip
10006b6a:	f000 80f1 	beq.w	10006d50 <fndsa_poly_big_to_fp64_exact+0x468>
10006b6e:	f023 0c03 	bic.w	ip, r3, #3
10006b72:	e031      	b.n	10006bd8 <fndsa_poly_big_to_fp64_exact+0x2f0>
10006b74:	f3af 8000 	nop.w
10006b78:	ffffffff 	.word	0xffffffff
10006b7c:	00000001 	.word	0x00000001
10006b80:	00000000 	.word	0x00000000
10006b84:	ffffffff 	.word	0xffffffff
10006b88:	00000000 	.word	0x00000000
10006b8c:	ffffffff 	.word	0xffffffff
10006b90:	00000001 	.word	0x00000001
10006b94:	00000000 	.word	0x00000000
10006b98:	00000001 	.word	0x00000001
10006b9c:	00000000 	.word	0x00000000
10006ba0:	ffffffff 	.word	0xffffffff
10006ba4:	00000001 	.word	0x00000001
10006ba8:	00000002 	.word	0x00000002
10006bac:	00000003 	.word	0x00000003
10006bb0:	00000003 	.word	0x00000003
10006bb4:	00000003 	.word	0x00000003
10006bb8:	00000001 	.word	0x00000001
10006bbc:	00000001 	.word	0x00000001
10006bc0:	00000002 	.word	0x00000002
10006bc4:	00000002 	.word	0x00000002
	...
10006bd4:	00000001 	.word	0x00000001
10006bd8:	9c2b      	ldr	r4, [sp, #172]	@ 0xac
10006bda:	fa0c fe07 	lsl.w	lr, ip, r7
10006bde:	f852 a02e 	ldr.w	sl, [r2, lr, lsl #2]
10006be2:	ea84 0e0c 	eor.w	lr, r4, ip
10006be6:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10006bea:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10006bee:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
10006bf2:	ea40 000e 	orr.w	r0, r0, lr
10006bf6:	ea88 0e0c 	eor.w	lr, r8, ip
10006bfa:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10006bfe:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10006c02:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
10006c06:	ea45 050e 	orr.w	r5, r5, lr
10006c0a:	ea89 0e0c 	eor.w	lr, r9, ip
10006c0e:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10006c12:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10006c16:	ea0a 7aee 	and.w	sl, sl, lr, asr #31
10006c1a:	f10c 0e01 	add.w	lr, ip, #1
10006c1e:	4573      	cmp	r3, lr
10006c20:	ea46 060a 	orr.w	r6, r6, sl
10006c24:	f240 8094 	bls.w	10006d50 <fndsa_poly_big_to_fp64_exact+0x468>
10006c28:	fa0e fa07 	lsl.w	sl, lr, r7
10006c2c:	f852 b02a 	ldr.w	fp, [r2, sl, lsl #2]
10006c30:	ea84 0a0e 	eor.w	sl, r4, lr
10006c34:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10006c38:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10006c3c:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10006c40:	ea40 000a 	orr.w	r0, r0, sl
10006c44:	ea88 0a0e 	eor.w	sl, r8, lr
10006c48:	ea89 0e0e 	eor.w	lr, r9, lr
10006c4c:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10006c50:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10006c54:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10006c58:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10006c5c:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10006c60:	ea0b 7bee 	and.w	fp, fp, lr, asr #31
10006c64:	f10c 0e02 	add.w	lr, ip, #2
10006c68:	4573      	cmp	r3, lr
10006c6a:	ea45 050a 	orr.w	r5, r5, sl
10006c6e:	ea46 060b 	orr.w	r6, r6, fp
10006c72:	d96d      	bls.n	10006d50 <fndsa_poly_big_to_fp64_exact+0x468>
10006c74:	fa0e fa07 	lsl.w	sl, lr, r7
10006c78:	f852 b02a 	ldr.w	fp, [r2, sl, lsl #2]
10006c7c:	ea84 0a0e 	eor.w	sl, r4, lr
10006c80:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10006c84:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10006c88:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10006c8c:	ea40 000a 	orr.w	r0, r0, sl
10006c90:	ea88 0a0e 	eor.w	sl, r8, lr
10006c94:	ea89 0e0e 	eor.w	lr, r9, lr
10006c98:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10006c9c:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10006ca0:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10006ca4:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10006ca8:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10006cac:	ea0b 7bee 	and.w	fp, fp, lr, asr #31
10006cb0:	f10c 0e03 	add.w	lr, ip, #3
10006cb4:	4573      	cmp	r3, lr
10006cb6:	ea45 050a 	orr.w	r5, r5, sl
10006cba:	ea46 060b 	orr.w	r6, r6, fp
10006cbe:	d947      	bls.n	10006d50 <fndsa_poly_big_to_fp64_exact+0x468>
10006cc0:	fa0e fa07 	lsl.w	sl, lr, r7
10006cc4:	f852 b02a 	ldr.w	fp, [r2, sl, lsl #2]
10006cc8:	ea84 0a0e 	eor.w	sl, r4, lr
10006ccc:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10006cd0:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10006cd4:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10006cd8:	ea40 000a 	orr.w	r0, r0, sl
10006cdc:	ea88 0a0e 	eor.w	sl, r8, lr
10006ce0:	ea89 0e0e 	eor.w	lr, r9, lr
10006ce4:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10006ce8:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10006cec:	f10c 0c04 	add.w	ip, ip, #4
10006cf0:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10006cf4:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10006cf8:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10006cfc:	4563      	cmp	r3, ip
10006cfe:	ea0b 7bee 	and.w	fp, fp, lr, asr #31
10006d02:	ea45 050a 	orr.w	r5, r5, sl
10006d06:	ea46 060b 	orr.w	r6, r6, fp
10006d0a:	d921      	bls.n	10006d50 <fndsa_poly_big_to_fp64_exact+0x468>
10006d0c:	fa0c fe07 	lsl.w	lr, ip, r7
10006d10:	f852 a02e 	ldr.w	sl, [r2, lr, lsl #2]
10006d14:	ea84 0e0c 	eor.w	lr, r4, ip
10006d18:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10006d1c:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10006d20:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
10006d24:	ea40 000e 	orr.w	r0, r0, lr
10006d28:	ea88 0e0c 	eor.w	lr, r8, ip
10006d2c:	ea89 0c0c 	eor.w	ip, r9, ip
10006d30:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10006d34:	f02c 4c7f 	bic.w	ip, ip, #4278190080	@ 0xff000000
10006d38:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10006d3c:	f10c 3cff 	add.w	ip, ip, #4294967295	@ 0xffffffff
10006d40:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
10006d44:	ea0a 7aec 	and.w	sl, sl, ip, asr #31
10006d48:	ea45 050e 	orr.w	r5, r5, lr
10006d4c:	ea46 060a 	orr.w	r6, r6, sl
10006d50:	9c20      	ldr	r4, [sp, #128]	@ 0x80
10006d52:	3204      	adds	r2, #4
10006d54:	f854 cf04 	ldr.w	ip, [r4, #4]!
10006d58:	3110      	adds	r1, #16
10006d5a:	9420      	str	r4, [sp, #128]	@ 0x80
10006d5c:	ea4f 7c9c 	mov.w	ip, ip, lsr #30
10006d60:	9c24      	ldr	r4, [sp, #144]	@ 0x90
10006d62:	f1cc 0c00 	rsb	ip, ip, #0
10006d66:	ea04 0e5c 	and.w	lr, r4, ip, lsr #1
10006d6a:	ea4e 0e06 	orr.w	lr, lr, r6
10006d6e:	ea4f 064e 	mov.w	r6, lr, lsl #1
10006d72:	9c28      	ldr	r4, [sp, #160]	@ 0xa0
10006d74:	f006 4600 	and.w	r6, r6, #2147483648	@ 0x80000000
10006d78:	ea46 060e 	orr.w	r6, r6, lr
10006d7c:	40a6      	lsls	r6, r4
10006d7e:	9c23      	ldr	r4, [sp, #140]	@ 0x8c
10006d80:	ea04 0e5c 	and.w	lr, r4, ip, lsr #1
10006d84:	9c22      	ldr	r4, [sp, #136]	@ 0x88
10006d86:	ea4e 0e05 	orr.w	lr, lr, r5
10006d8a:	ea04 0c5c 	and.w	ip, r4, ip, lsr #1
10006d8e:	ea4c 0c00 	orr.w	ip, ip, r0
10006d92:	9826      	ldr	r0, [sp, #152]	@ 0x98
10006d94:	fa2c fc00 	lsr.w	ip, ip, r0
10006d98:	9827      	ldr	r0, [sp, #156]	@ 0x9c
10006d9a:	fa0e f000 	lsl.w	r0, lr, r0
10006d9e:	ea4c 0c00 	orr.w	ip, ip, r0
10006da2:	9825      	ldr	r0, [sp, #148]	@ 0x94
10006da4:	fa2e fe00 	lsr.w	lr, lr, r0
10006da8:	ea46 060e 	orr.w	r6, r6, lr
10006dac:	ee07 6a90 	vmov	s15, r6
10006db0:	eeb8 6b67 	vcvt.f64.u32	d6, s15
10006db4:	ee07 ca90 	vmov	s15, ip
10006db8:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10006dbc:	9829      	ldr	r0, [sp, #164]	@ 0xa4
10006dbe:	ed01 6b04 	vstr	d6, [r1, #-16]
10006dc2:	4282      	cmp	r2, r0
10006dc4:	ed01 7b02 	vstr	d7, [r1, #-8]
10006dc8:	f47f adef 	bne.w	100069aa <fndsa_poly_big_to_fp64_exact+0xc2>
10006dcc:	b039      	add	sp, #228	@ 0xe4
10006dce:	ecbd 8b10 	vpop	{d8-d15}
10006dd2:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10006dd6:	f04f 0c00 	mov.w	ip, #0
10006dda:	4666      	mov	r6, ip
10006ddc:	4665      	mov	r5, ip
10006dde:	4660      	mov	r0, ip
10006de0:	e6fa      	b.n	10006bd8 <fndsa_poly_big_to_fp64_exact+0x2f0>
10006de2:	2210      	movs	r2, #16
10006de4:	4619      	mov	r1, r3
10006de6:	40ba      	lsls	r2, r7
10006de8:	b039      	add	sp, #228	@ 0xe4
10006dea:	ecbd 8b10 	vpop	{d8-d15}
10006dee:	e8bd 4ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10006df2:	f00c bac1 	b.w	10013378 <memset>
10006df6:	bf00      	nop

