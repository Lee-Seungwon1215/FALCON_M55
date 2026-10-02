10005a48 <fndsa_poly_big_to_fp64_exact>:
10005a48:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10005a4c:	ed2d 8b10 	vpush	{d8-d15}
10005a50:	b0b9      	sub	sp, #228	@ 0xe4
10005a52:	4607      	mov	r7, r0
10005a54:	9d52      	ldr	r5, [sp, #328]	@ 0x148
10005a56:	4608      	mov	r0, r1
10005a58:	2b00      	cmp	r3, #0
10005a5a:	f000 8272 	beq.w	10005f42 <fndsa_poly_big_to_fp64_exact+0x4fa>
10005a5e:	eb05 1145 	add.w	r1, r5, r5, lsl #5
10005a62:	eb01 2181 	add.w	r1, r1, r1, lsl #10
10005a66:	eb05 0441 	add.w	r4, r5, r1, lsl #1
10005a6a:	0d64      	lsrs	r4, r4, #21
10005a6c:	4601      	mov	r1, r0
10005a6e:	ebc4 1044 	rsb	r0, r4, r4, lsl #5
10005a72:	1a2d      	subs	r5, r5, r0
10005a74:	1e6e      	subs	r6, r5, #1
10005a76:	eba4 78d6 	sub.w	r8, r4, r6, lsr #31
10005a7a:	eea6 8b10 	vdup.32	q3, r8
10005a7e:	ed9f 0b96 	vldr	d0, [pc, #600]	@ 10005cd8 <fndsa_poly_big_to_fp64_exact+0x290>
10005a82:	ed9f 1b97 	vldr	d1, [pc, #604]	@ 10005ce0 <fndsa_poly_big_to_fp64_exact+0x298>
10005a86:	ed9f 2b98 	vldr	d2, [pc, #608]	@ 10005ce8 <fndsa_poly_big_to_fp64_exact+0x2a0>
10005a8a:	ed9f 3b99 	vldr	d3, [pc, #612]	@ 10005cf0 <fndsa_poly_big_to_fp64_exact+0x2a8>
10005a8e:	ed9f 4b9a 	vldr	d4, [pc, #616]	@ 10005cf8 <fndsa_poly_big_to_fp64_exact+0x2b0>
10005a92:	ed9f 5b9b 	vldr	d5, [pc, #620]	@ 10005d00 <fndsa_poly_big_to_fp64_exact+0x2b8>
10005a96:	ef26 0840 	vadd.i32	q0, q3, q0
10005a9a:	ef26 2842 	vadd.i32	q1, q3, q1
10005a9e:	ef26 6844 	vadd.i32	q3, q3, q2
10005aa2:	1b18      	subs	r0, r3, r4
10005aa4:	17f4      	asrs	r4, r6, #31
10005aa6:	f004 041f 	and.w	r4, r4, #31
10005aaa:	eb00 70d6 	add.w	r0, r0, r6, lsr #31
10005aae:	ea44 0605 	orr.w	r6, r4, r5
10005ab2:	2404      	movs	r4, #4
10005ab4:	eeae 7b10 	vdup.32	q7, r7
10005ab8:	ed8d 1f14 	vstrw.32	q0, [sp, #80]
10005abc:	ed8d 3f18 	vstrw.32	q1, [sp, #96]
10005ac0:	ed8d 7f1c 	vstrw.32	q3, [sp, #112]
10005ac4:	1e5d      	subs	r5, r3, #1
10005ac6:	9521      	str	r5, [sp, #132]	@ 0x84
10005ac8:	1e45      	subs	r5, r0, #1
10005aca:	17ed      	asrs	r5, r5, #31
10005acc:	9523      	str	r5, [sp, #140]	@ 0x8c
10005ace:	40bc      	lsls	r4, r7
10005ad0:	1e85      	subs	r5, r0, #2
10005ad2:	17c0      	asrs	r0, r0, #31
10005ad4:	1914      	adds	r4, r2, r4
10005ad6:	9022      	str	r0, [sp, #136]	@ 0x88
10005ad8:	17e8      	asrs	r0, r5, #31
10005ada:	1e5d      	subs	r5, r3, #1
10005adc:	40bd      	lsls	r5, r7
10005ade:	9024      	str	r0, [sp, #144]	@ 0x90
10005ae0:	9429      	str	r4, [sp, #164]	@ 0xa4
10005ae2:	1f10      	subs	r0, r2, #4
10005ae4:	f1c6 0420 	rsb	r4, r6, #32
10005ae8:	eb00 0085 	add.w	r0, r0, r5, lsl #2
10005aec:	9427      	str	r4, [sp, #156]	@ 0x9c
10005aee:	f1c6 041f 	rsb	r4, r6, #31
10005af2:	9020      	str	r0, [sp, #128]	@ 0x80
10005af4:	1e75      	subs	r5, r6, #1
10005af6:	f108 30ff 	add.w	r0, r8, #4294967295	@ 0xffffffff
10005afa:	9428      	str	r4, [sp, #160]	@ 0xa0
10005afc:	089c      	lsrs	r4, r3, #2
10005afe:	9625      	str	r6, [sp, #148]	@ 0x94
10005b00:	f108 0901 	add.w	r9, r8, #1
10005b04:	9526      	str	r5, [sp, #152]	@ 0x98
10005b06:	942a      	str	r4, [sp, #168]	@ 0xa8
10005b08:	902b      	str	r0, [sp, #172]	@ 0xac
10005b0a:	9821      	ldr	r0, [sp, #132]	@ 0x84
10005b0c:	2804      	cmp	r0, #4
10005b0e:	f240 8212 	bls.w	10005f36 <fndsa_poly_big_to_fp64_exact+0x4ee>
10005b12:	ef80 6050 	vmov.i32	q3, #0	@ 0x00000000
10005b16:	ed9f 8b7c 	vldr	d8, [pc, #496]	@ 10005d08 <fndsa_poly_big_to_fp64_exact+0x2c0>
10005b1a:	ed9f 9b7d 	vldr	d9, [pc, #500]	@ 10005d10 <fndsa_poly_big_to_fp64_exact+0x2c8>
10005b1e:	982a      	ldr	r0, [sp, #168]	@ 0xa8
10005b20:	ed8d 7f08 	vstrw.32	q3, [sp, #32]
10005b24:	f040 e001 	dls	lr, r0
10005b28:	ed8d 7f04 	vstrw.32	q3, [sp, #16]
10005b2c:	ed8d 7f00 	vstrw.32	q3, [sp, #0]
10005b30:	ed9f cb79 	vldr	d12, [pc, #484]	@ 10005d18 <fndsa_poly_big_to_fp64_exact+0x2d0>
10005b34:	ed9f db7a 	vldr	d13, [pc, #488]	@ 10005d20 <fndsa_poly_big_to_fp64_exact+0x2d8>
10005b38:	ed9f ab7b 	vldr	d10, [pc, #492]	@ 10005d28 <fndsa_poly_big_to_fp64_exact+0x2e0>
10005b3c:	ed9f bb7c 	vldr	d11, [pc, #496]	@ 10005d30 <fndsa_poly_big_to_fp64_exact+0x2e8>
10005b40:	ed8d 9f0c 	vstrw.32	q4, [sp, #48]
10005b44:	ff2e 644a 	vshl.u32	q3, q5, q7
10005b48:	ee16 6a10 	vmov	r6, s12
10005b4c:	ee36 5b10 	vmov.32	r5, d6[1]
10005b50:	ee17 4b10 	vmov.32	r4, d7[0]
10005b54:	ee37 0b10 	vmov.32	r0, d7[1]
10005b58:	ed9d 7f1c 	vldrw.u32	q3, [sp, #112]
10005b5c:	ed9d 1f18 	vldrw.u32	q0, [sp, #96]
10005b60:	ff0a 4156 	veor	q2, q5, q3
10005b64:	ef80 6054 	vmov.i32	q3, #4	@ 0x00000004
10005b68:	ef26 8156 	vmov	q4, q3
10005b6c:	ef2a a846 	vadd.i32	q5, q5, q3
10005b70:	ff0c 6150 	veor	q3, q6, q0
10005b74:	ff87 2e5f 	vmov.i8	q1, #255	@ 0xff
10005b78:	ff87 677f 	vbic.i32	q3, #4278190080	@ 0xff000000
10005b7c:	ef26 6842 	vadd.i32	q3, q3, q1
10005b80:	efa1 6056 	vshr.s32	q3, q3, #31
10005b84:	ed9d 1f14 	vldrw.u32	q0, [sp, #80]
10005b88:	ed8d 7f10 	vstrw.32	q3, [sp, #64]
10005b8c:	ed9d 7f0c 	vldrw.u32	q3, [sp, #48]
10005b90:	ff06 0150 	veor	q0, q3, q0
10005b94:	ff87 477f 	vbic.i32	q2, #4278190080	@ 0xff000000
10005b98:	ff87 077f 	vbic.i32	q0, #4278190080	@ 0xff000000
10005b9c:	ef24 4842 	vadd.i32	q2, q2, q1
10005ba0:	ef20 0842 	vadd.i32	q0, q0, q1
10005ba4:	ff2e 244c 	vshl.u32	q1, q6, q7
10005ba8:	f852 6026 	ldr.w	r6, [r2, r6, lsl #2]
10005bac:	efa1 4054 	vshr.s32	q2, q2, #31
10005bb0:	9634      	str	r6, [sp, #208]	@ 0xd0
10005bb2:	ee12 6a10 	vmov	r6, s4
10005bb6:	f852 5025 	ldr.w	r5, [r2, r5, lsl #2]
10005bba:	efa1 0050 	vshr.s32	q0, q0, #31
10005bbe:	9535      	str	r5, [sp, #212]	@ 0xd4
10005bc0:	ee32 5b10 	vmov.32	r5, d2[1]
10005bc4:	f852 4024 	ldr.w	r4, [r2, r4, lsl #2]
10005bc8:	ef2c c848 	vadd.i32	q6, q6, q4
10005bcc:	9436      	str	r4, [sp, #216]	@ 0xd8
10005bce:	ee13 4b10 	vmov.32	r4, d3[0]
10005bd2:	f852 0020 	ldr.w	r0, [r2, r0, lsl #2]
10005bd6:	9037      	str	r0, [sp, #220]	@ 0xdc
10005bd8:	ee33 0b10 	vmov.32	r0, d3[1]
10005bdc:	ff2e 2446 	vshl.u32	q1, q3, q7
10005be0:	f852 6026 	ldr.w	r6, [r2, r6, lsl #2]
10005be4:	ef26 6848 	vadd.i32	q3, q3, q4
10005be8:	9630      	str	r6, [sp, #192]	@ 0xc0
10005bea:	f852 5025 	ldr.w	r5, [r2, r5, lsl #2]
10005bee:	ee12 6a10 	vmov	r6, s4
10005bf2:	9531      	str	r5, [sp, #196]	@ 0xc4
10005bf4:	f852 4024 	ldr.w	r4, [r2, r4, lsl #2]
10005bf8:	ee32 5b10 	vmov.32	r5, d2[1]
10005bfc:	9432      	str	r4, [sp, #200]	@ 0xc8
10005bfe:	f852 0020 	ldr.w	r0, [r2, r0, lsl #2]
10005c02:	ee13 4b10 	vmov.32	r4, d3[0]
10005c06:	9033      	str	r0, [sp, #204]	@ 0xcc
10005c08:	ee33 0b10 	vmov.32	r0, d3[1]
10005c0c:	ed9d 3f34 	vldrw.u32	q1, [sp, #208]
10005c10:	ef02 2154 	vand	q1, q1, q2
10005c14:	ed9d 5f00 	vldrw.u32	q2, [sp, #0]
10005c18:	ef24 4152 	vorr	q2, q2, q1
10005c1c:	f852 6026 	ldr.w	r6, [r2, r6, lsl #2]
10005c20:	ed8d 7f0c 	vstrw.32	q3, [sp, #48]
10005c24:	962c      	str	r6, [sp, #176]	@ 0xb0
10005c26:	f852 5025 	ldr.w	r5, [r2, r5, lsl #2]
10005c2a:	952d      	str	r5, [sp, #180]	@ 0xb4
10005c2c:	f852 4024 	ldr.w	r4, [r2, r4, lsl #2]
10005c30:	942e      	str	r4, [sp, #184]	@ 0xb8
10005c32:	f852 0020 	ldr.w	r0, [r2, r0, lsl #2]
10005c36:	902f      	str	r0, [sp, #188]	@ 0xbc
10005c38:	ed8d 5f00 	vstrw.32	q2, [sp, #0]
10005c3c:	ed9d 7f10 	vldrw.u32	q3, [sp, #64]
10005c40:	ed9d 5f30 	vldrw.u32	q2, [sp, #192]
10005c44:	ef04 4156 	vand	q2, q2, q3
10005c48:	ed9d 7f04 	vldrw.u32	q3, [sp, #16]
10005c4c:	ef26 6154 	vorr	q3, q3, q2
10005c50:	ed8d 7f04 	vstrw.32	q3, [sp, #16]
10005c54:	ed9d 7f2c 	vldrw.u32	q3, [sp, #176]
10005c58:	ed9d 5f08 	vldrw.u32	q2, [sp, #32]
10005c5c:	ef06 6150 	vand	q3, q3, q0
10005c60:	ef24 6156 	vorr	q3, q2, q3
10005c64:	ed8d 7f08 	vstrw.32	q3, [sp, #32]
10005c68:	f00f c095 	le	lr, 10005b44 <fndsa_poly_big_to_fp64_exact+0xfc>
10005c6c:	ed9d 7f00 	vldrw.u32	q3, [sp, #0]
10005c70:	ed9d 5f04 	vldrw.u32	q2, [sp, #16]
10005c74:	ee37 0b10 	vmov.32	r0, d7[1]
10005c78:	ee16 6a10 	vmov	r6, s12
10005c7c:	ee36 5b10 	vmov.32	r5, d6[1]
10005c80:	4306      	orrs	r6, r0
10005c82:	ee14 0a10 	vmov	r0, s8
10005c86:	ee34 cb10 	vmov.32	ip, d4[1]
10005c8a:	4305      	orrs	r5, r0
10005c8c:	ee17 0b10 	vmov.32	r0, d7[0]
10005c90:	ea40 000c 	orr.w	r0, r0, ip
10005c94:	ee15 cb10 	vmov.32	ip, d5[0]
10005c98:	ed9d 7f08 	vldrw.u32	q3, [sp, #32]
10005c9c:	ea46 060c 	orr.w	r6, r6, ip
10005ca0:	ee35 cb10 	vmov.32	ip, d5[1]
10005ca4:	ea45 050c 	orr.w	r5, r5, ip
10005ca8:	ee16 ca10 	vmov	ip, s12
10005cac:	ea40 000c 	orr.w	r0, r0, ip
10005cb0:	ee36 cb10 	vmov.32	ip, d6[1]
10005cb4:	ea46 060c 	orr.w	r6, r6, ip
10005cb8:	ee17 cb10 	vmov.32	ip, d7[0]
10005cbc:	ea45 050c 	orr.w	r5, r5, ip
10005cc0:	ee37 cb10 	vmov.32	ip, d7[1]
10005cc4:	079c      	lsls	r4, r3, #30
10005cc6:	ea40 000c 	orr.w	r0, r0, ip
10005cca:	f000 80f1 	beq.w	10005eb0 <fndsa_poly_big_to_fp64_exact+0x468>
10005cce:	f023 0c03 	bic.w	ip, r3, #3
10005cd2:	e031      	b.n	10005d38 <fndsa_poly_big_to_fp64_exact+0x2f0>
10005cd4:	f3af 8000 	nop.w
10005cd8:	ffffffff 	.word	0xffffffff
10005cdc:	00000001 	.word	0x00000001
10005ce0:	00000000 	.word	0x00000000
10005ce4:	ffffffff 	.word	0xffffffff
10005ce8:	00000000 	.word	0x00000000
10005cec:	ffffffff 	.word	0xffffffff
10005cf0:	00000001 	.word	0x00000001
10005cf4:	00000000 	.word	0x00000000
10005cf8:	00000001 	.word	0x00000001
10005cfc:	00000000 	.word	0x00000000
10005d00:	ffffffff 	.word	0xffffffff
10005d04:	00000001 	.word	0x00000001
10005d08:	00000002 	.word	0x00000002
10005d0c:	00000003 	.word	0x00000003
10005d10:	00000003 	.word	0x00000003
10005d14:	00000003 	.word	0x00000003
10005d18:	00000001 	.word	0x00000001
10005d1c:	00000001 	.word	0x00000001
10005d20:	00000002 	.word	0x00000002
10005d24:	00000002 	.word	0x00000002
	...
10005d34:	00000001 	.word	0x00000001
10005d38:	9c2b      	ldr	r4, [sp, #172]	@ 0xac
10005d3a:	fa0c fe07 	lsl.w	lr, ip, r7
10005d3e:	f852 a02e 	ldr.w	sl, [r2, lr, lsl #2]
10005d42:	ea84 0e0c 	eor.w	lr, r4, ip
10005d46:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10005d4a:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10005d4e:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
10005d52:	ea40 000e 	orr.w	r0, r0, lr
10005d56:	ea88 0e0c 	eor.w	lr, r8, ip
10005d5a:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10005d5e:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10005d62:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
10005d66:	ea45 050e 	orr.w	r5, r5, lr
10005d6a:	ea89 0e0c 	eor.w	lr, r9, ip
10005d6e:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10005d72:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10005d76:	ea0a 7aee 	and.w	sl, sl, lr, asr #31
10005d7a:	f10c 0e01 	add.w	lr, ip, #1
10005d7e:	4573      	cmp	r3, lr
10005d80:	ea46 060a 	orr.w	r6, r6, sl
10005d84:	f240 8094 	bls.w	10005eb0 <fndsa_poly_big_to_fp64_exact+0x468>
10005d88:	fa0e fa07 	lsl.w	sl, lr, r7
10005d8c:	f852 b02a 	ldr.w	fp, [r2, sl, lsl #2]
10005d90:	ea84 0a0e 	eor.w	sl, r4, lr
10005d94:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10005d98:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10005d9c:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10005da0:	ea40 000a 	orr.w	r0, r0, sl
10005da4:	ea88 0a0e 	eor.w	sl, r8, lr
10005da8:	ea89 0e0e 	eor.w	lr, r9, lr
10005dac:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10005db0:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10005db4:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10005db8:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10005dbc:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10005dc0:	ea0b 7bee 	and.w	fp, fp, lr, asr #31
10005dc4:	f10c 0e02 	add.w	lr, ip, #2
10005dc8:	4573      	cmp	r3, lr
10005dca:	ea45 050a 	orr.w	r5, r5, sl
10005dce:	ea46 060b 	orr.w	r6, r6, fp
10005dd2:	d96d      	bls.n	10005eb0 <fndsa_poly_big_to_fp64_exact+0x468>
10005dd4:	fa0e fa07 	lsl.w	sl, lr, r7
10005dd8:	f852 b02a 	ldr.w	fp, [r2, sl, lsl #2]
10005ddc:	ea84 0a0e 	eor.w	sl, r4, lr
10005de0:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10005de4:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10005de8:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10005dec:	ea40 000a 	orr.w	r0, r0, sl
10005df0:	ea88 0a0e 	eor.w	sl, r8, lr
10005df4:	ea89 0e0e 	eor.w	lr, r9, lr
10005df8:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10005dfc:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10005e00:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10005e04:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10005e08:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10005e0c:	ea0b 7bee 	and.w	fp, fp, lr, asr #31
10005e10:	f10c 0e03 	add.w	lr, ip, #3
10005e14:	4573      	cmp	r3, lr
10005e16:	ea45 050a 	orr.w	r5, r5, sl
10005e1a:	ea46 060b 	orr.w	r6, r6, fp
10005e1e:	d947      	bls.n	10005eb0 <fndsa_poly_big_to_fp64_exact+0x468>
10005e20:	fa0e fa07 	lsl.w	sl, lr, r7
10005e24:	f852 b02a 	ldr.w	fp, [r2, sl, lsl #2]
10005e28:	ea84 0a0e 	eor.w	sl, r4, lr
10005e2c:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10005e30:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10005e34:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10005e38:	ea40 000a 	orr.w	r0, r0, sl
10005e3c:	ea88 0a0e 	eor.w	sl, r8, lr
10005e40:	ea89 0e0e 	eor.w	lr, r9, lr
10005e44:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10005e48:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10005e4c:	f10c 0c04 	add.w	ip, ip, #4
10005e50:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10005e54:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10005e58:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10005e5c:	4563      	cmp	r3, ip
10005e5e:	ea0b 7bee 	and.w	fp, fp, lr, asr #31
10005e62:	ea45 050a 	orr.w	r5, r5, sl
10005e66:	ea46 060b 	orr.w	r6, r6, fp
10005e6a:	d921      	bls.n	10005eb0 <fndsa_poly_big_to_fp64_exact+0x468>
10005e6c:	fa0c fe07 	lsl.w	lr, ip, r7
10005e70:	f852 a02e 	ldr.w	sl, [r2, lr, lsl #2]
10005e74:	ea84 0e0c 	eor.w	lr, r4, ip
10005e78:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10005e7c:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10005e80:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
10005e84:	ea40 000e 	orr.w	r0, r0, lr
10005e88:	ea88 0e0c 	eor.w	lr, r8, ip
10005e8c:	ea89 0c0c 	eor.w	ip, r9, ip
10005e90:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10005e94:	f02c 4c7f 	bic.w	ip, ip, #4278190080	@ 0xff000000
10005e98:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10005e9c:	f10c 3cff 	add.w	ip, ip, #4294967295	@ 0xffffffff
10005ea0:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
10005ea4:	ea0a 7aec 	and.w	sl, sl, ip, asr #31
10005ea8:	ea45 050e 	orr.w	r5, r5, lr
10005eac:	ea46 060a 	orr.w	r6, r6, sl
10005eb0:	9c20      	ldr	r4, [sp, #128]	@ 0x80
10005eb2:	3204      	adds	r2, #4
10005eb4:	f854 cf04 	ldr.w	ip, [r4, #4]!
10005eb8:	3110      	adds	r1, #16
10005eba:	9420      	str	r4, [sp, #128]	@ 0x80
10005ebc:	ea4f 7c9c 	mov.w	ip, ip, lsr #30
10005ec0:	9c24      	ldr	r4, [sp, #144]	@ 0x90
10005ec2:	f1cc 0c00 	rsb	ip, ip, #0
10005ec6:	ea04 0e5c 	and.w	lr, r4, ip, lsr #1
10005eca:	ea4e 0e06 	orr.w	lr, lr, r6
10005ece:	ea4f 064e 	mov.w	r6, lr, lsl #1
10005ed2:	9c28      	ldr	r4, [sp, #160]	@ 0xa0
10005ed4:	f006 4600 	and.w	r6, r6, #2147483648	@ 0x80000000
10005ed8:	ea46 060e 	orr.w	r6, r6, lr
10005edc:	40a6      	lsls	r6, r4
10005ede:	9c23      	ldr	r4, [sp, #140]	@ 0x8c
10005ee0:	ea04 0e5c 	and.w	lr, r4, ip, lsr #1
10005ee4:	9c22      	ldr	r4, [sp, #136]	@ 0x88
10005ee6:	ea4e 0e05 	orr.w	lr, lr, r5
10005eea:	ea04 0c5c 	and.w	ip, r4, ip, lsr #1
10005eee:	ea4c 0c00 	orr.w	ip, ip, r0
10005ef2:	9826      	ldr	r0, [sp, #152]	@ 0x98
10005ef4:	fa2c fc00 	lsr.w	ip, ip, r0
10005ef8:	9827      	ldr	r0, [sp, #156]	@ 0x9c
10005efa:	fa0e f000 	lsl.w	r0, lr, r0
10005efe:	ea4c 0c00 	orr.w	ip, ip, r0
10005f02:	9825      	ldr	r0, [sp, #148]	@ 0x94
10005f04:	fa2e fe00 	lsr.w	lr, lr, r0
10005f08:	ea46 060e 	orr.w	r6, r6, lr
10005f0c:	ee07 6a90 	vmov	s15, r6
10005f10:	eeb8 6b67 	vcvt.f64.u32	d6, s15
10005f14:	ee07 ca90 	vmov	s15, ip
10005f18:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10005f1c:	9829      	ldr	r0, [sp, #164]	@ 0xa4
10005f1e:	ed01 6b04 	vstr	d6, [r1, #-16]
10005f22:	4282      	cmp	r2, r0
10005f24:	ed01 7b02 	vstr	d7, [r1, #-8]
10005f28:	f47f adef 	bne.w	10005b0a <fndsa_poly_big_to_fp64_exact+0xc2>
10005f2c:	b039      	add	sp, #228	@ 0xe4
10005f2e:	ecbd 8b10 	vpop	{d8-d15}
10005f32:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10005f36:	f04f 0c00 	mov.w	ip, #0
10005f3a:	4666      	mov	r6, ip
10005f3c:	4665      	mov	r5, ip
10005f3e:	4660      	mov	r0, ip
10005f40:	e6fa      	b.n	10005d38 <fndsa_poly_big_to_fp64_exact+0x2f0>
10005f42:	2210      	movs	r2, #16
10005f44:	4619      	mov	r1, r3
10005f46:	40ba      	lsls	r2, r7
10005f48:	b039      	add	sp, #228	@ 0xe4
10005f4a:	ecbd 8b10 	vpop	{d8-d15}
10005f4e:	e8bd 4ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10005f52:	f00e be11 	b.w	10014b78 <memset>
10005f56:	bf00      	nop

