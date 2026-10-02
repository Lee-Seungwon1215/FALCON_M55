10007bf8 <fndsa_poly_big_to_fp64_exact>:
10007bf8:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10007bfc:	ed2d 8b10 	vpush	{d8-d15}
10007c00:	b0b9      	sub	sp, #228	@ 0xe4
10007c02:	4607      	mov	r7, r0
10007c04:	9d52      	ldr	r5, [sp, #328]	@ 0x148
10007c06:	4608      	mov	r0, r1
10007c08:	2b00      	cmp	r3, #0
10007c0a:	f000 8272 	beq.w	100080f2 <fndsa_poly_big_to_fp64_exact+0x4fa>
10007c0e:	eb05 1145 	add.w	r1, r5, r5, lsl #5
10007c12:	eb01 2181 	add.w	r1, r1, r1, lsl #10
10007c16:	eb05 0441 	add.w	r4, r5, r1, lsl #1
10007c1a:	0d64      	lsrs	r4, r4, #21
10007c1c:	4601      	mov	r1, r0
10007c1e:	ebc4 1044 	rsb	r0, r4, r4, lsl #5
10007c22:	1a2d      	subs	r5, r5, r0
10007c24:	1e6e      	subs	r6, r5, #1
10007c26:	eba4 78d6 	sub.w	r8, r4, r6, lsr #31
10007c2a:	eea6 8b10 	vdup.32	q3, r8
10007c2e:	ed9f 0b96 	vldr	d0, [pc, #600]	@ 10007e88 <fndsa_poly_big_to_fp64_exact+0x290>
10007c32:	ed9f 1b97 	vldr	d1, [pc, #604]	@ 10007e90 <fndsa_poly_big_to_fp64_exact+0x298>
10007c36:	ed9f 2b98 	vldr	d2, [pc, #608]	@ 10007e98 <fndsa_poly_big_to_fp64_exact+0x2a0>
10007c3a:	ed9f 3b99 	vldr	d3, [pc, #612]	@ 10007ea0 <fndsa_poly_big_to_fp64_exact+0x2a8>
10007c3e:	ed9f 4b9a 	vldr	d4, [pc, #616]	@ 10007ea8 <fndsa_poly_big_to_fp64_exact+0x2b0>
10007c42:	ed9f 5b9b 	vldr	d5, [pc, #620]	@ 10007eb0 <fndsa_poly_big_to_fp64_exact+0x2b8>
10007c46:	ef26 0840 	vadd.i32	q0, q3, q0
10007c4a:	ef26 2842 	vadd.i32	q1, q3, q1
10007c4e:	ef26 6844 	vadd.i32	q3, q3, q2
10007c52:	1b18      	subs	r0, r3, r4
10007c54:	17f4      	asrs	r4, r6, #31
10007c56:	f004 041f 	and.w	r4, r4, #31
10007c5a:	eb00 70d6 	add.w	r0, r0, r6, lsr #31
10007c5e:	ea44 0605 	orr.w	r6, r4, r5
10007c62:	2404      	movs	r4, #4
10007c64:	eeae 7b10 	vdup.32	q7, r7
10007c68:	ed8d 1f14 	vstrw.32	q0, [sp, #80]
10007c6c:	ed8d 3f18 	vstrw.32	q1, [sp, #96]
10007c70:	ed8d 7f1c 	vstrw.32	q3, [sp, #112]
10007c74:	1e5d      	subs	r5, r3, #1
10007c76:	9521      	str	r5, [sp, #132]	@ 0x84
10007c78:	1e45      	subs	r5, r0, #1
10007c7a:	17ed      	asrs	r5, r5, #31
10007c7c:	9523      	str	r5, [sp, #140]	@ 0x8c
10007c7e:	40bc      	lsls	r4, r7
10007c80:	1e85      	subs	r5, r0, #2
10007c82:	17c0      	asrs	r0, r0, #31
10007c84:	1914      	adds	r4, r2, r4
10007c86:	9022      	str	r0, [sp, #136]	@ 0x88
10007c88:	17e8      	asrs	r0, r5, #31
10007c8a:	1e5d      	subs	r5, r3, #1
10007c8c:	40bd      	lsls	r5, r7
10007c8e:	9024      	str	r0, [sp, #144]	@ 0x90
10007c90:	9429      	str	r4, [sp, #164]	@ 0xa4
10007c92:	1f10      	subs	r0, r2, #4
10007c94:	f1c6 0420 	rsb	r4, r6, #32
10007c98:	eb00 0085 	add.w	r0, r0, r5, lsl #2
10007c9c:	9427      	str	r4, [sp, #156]	@ 0x9c
10007c9e:	f1c6 041f 	rsb	r4, r6, #31
10007ca2:	9020      	str	r0, [sp, #128]	@ 0x80
10007ca4:	1e75      	subs	r5, r6, #1
10007ca6:	f108 30ff 	add.w	r0, r8, #4294967295	@ 0xffffffff
10007caa:	9428      	str	r4, [sp, #160]	@ 0xa0
10007cac:	089c      	lsrs	r4, r3, #2
10007cae:	9625      	str	r6, [sp, #148]	@ 0x94
10007cb0:	f108 0901 	add.w	r9, r8, #1
10007cb4:	9526      	str	r5, [sp, #152]	@ 0x98
10007cb6:	942a      	str	r4, [sp, #168]	@ 0xa8
10007cb8:	902b      	str	r0, [sp, #172]	@ 0xac
10007cba:	9821      	ldr	r0, [sp, #132]	@ 0x84
10007cbc:	2804      	cmp	r0, #4
10007cbe:	f240 8212 	bls.w	100080e6 <fndsa_poly_big_to_fp64_exact+0x4ee>
10007cc2:	ef80 6050 	vmov.i32	q3, #0	@ 0x00000000
10007cc6:	ed9f 8b7c 	vldr	d8, [pc, #496]	@ 10007eb8 <fndsa_poly_big_to_fp64_exact+0x2c0>
10007cca:	ed9f 9b7d 	vldr	d9, [pc, #500]	@ 10007ec0 <fndsa_poly_big_to_fp64_exact+0x2c8>
10007cce:	982a      	ldr	r0, [sp, #168]	@ 0xa8
10007cd0:	ed8d 7f08 	vstrw.32	q3, [sp, #32]
10007cd4:	f040 e001 	dls	lr, r0
10007cd8:	ed8d 7f04 	vstrw.32	q3, [sp, #16]
10007cdc:	ed8d 7f00 	vstrw.32	q3, [sp, #0]
10007ce0:	ed9f cb79 	vldr	d12, [pc, #484]	@ 10007ec8 <fndsa_poly_big_to_fp64_exact+0x2d0>
10007ce4:	ed9f db7a 	vldr	d13, [pc, #488]	@ 10007ed0 <fndsa_poly_big_to_fp64_exact+0x2d8>
10007ce8:	ed9f ab7b 	vldr	d10, [pc, #492]	@ 10007ed8 <fndsa_poly_big_to_fp64_exact+0x2e0>
10007cec:	ed9f bb7c 	vldr	d11, [pc, #496]	@ 10007ee0 <fndsa_poly_big_to_fp64_exact+0x2e8>
10007cf0:	ed8d 9f0c 	vstrw.32	q4, [sp, #48]
10007cf4:	ff2e 644a 	vshl.u32	q3, q5, q7
10007cf8:	ee16 6a10 	vmov	r6, s12
10007cfc:	ee36 5b10 	vmov.32	r5, d6[1]
10007d00:	ee17 4b10 	vmov.32	r4, d7[0]
10007d04:	ee37 0b10 	vmov.32	r0, d7[1]
10007d08:	ed9d 7f1c 	vldrw.u32	q3, [sp, #112]
10007d0c:	ed9d 1f18 	vldrw.u32	q0, [sp, #96]
10007d10:	ff0a 4156 	veor	q2, q5, q3
10007d14:	ef80 6054 	vmov.i32	q3, #4	@ 0x00000004
10007d18:	ef26 8156 	vmov	q4, q3
10007d1c:	ef2a a846 	vadd.i32	q5, q5, q3
10007d20:	ff0c 6150 	veor	q3, q6, q0
10007d24:	ff87 2e5f 	vmov.i8	q1, #255	@ 0xff
10007d28:	ff87 677f 	vbic.i32	q3, #4278190080	@ 0xff000000
10007d2c:	ef26 6842 	vadd.i32	q3, q3, q1
10007d30:	efa1 6056 	vshr.s32	q3, q3, #31
10007d34:	ed9d 1f14 	vldrw.u32	q0, [sp, #80]
10007d38:	ed8d 7f10 	vstrw.32	q3, [sp, #64]
10007d3c:	ed9d 7f0c 	vldrw.u32	q3, [sp, #48]
10007d40:	ff06 0150 	veor	q0, q3, q0
10007d44:	ff87 477f 	vbic.i32	q2, #4278190080	@ 0xff000000
10007d48:	ff87 077f 	vbic.i32	q0, #4278190080	@ 0xff000000
10007d4c:	ef24 4842 	vadd.i32	q2, q2, q1
10007d50:	ef20 0842 	vadd.i32	q0, q0, q1
10007d54:	ff2e 244c 	vshl.u32	q1, q6, q7
10007d58:	f852 6026 	ldr.w	r6, [r2, r6, lsl #2]
10007d5c:	efa1 4054 	vshr.s32	q2, q2, #31
10007d60:	9634      	str	r6, [sp, #208]	@ 0xd0
10007d62:	ee12 6a10 	vmov	r6, s4
10007d66:	f852 5025 	ldr.w	r5, [r2, r5, lsl #2]
10007d6a:	efa1 0050 	vshr.s32	q0, q0, #31
10007d6e:	9535      	str	r5, [sp, #212]	@ 0xd4
10007d70:	ee32 5b10 	vmov.32	r5, d2[1]
10007d74:	f852 4024 	ldr.w	r4, [r2, r4, lsl #2]
10007d78:	ef2c c848 	vadd.i32	q6, q6, q4
10007d7c:	9436      	str	r4, [sp, #216]	@ 0xd8
10007d7e:	ee13 4b10 	vmov.32	r4, d3[0]
10007d82:	f852 0020 	ldr.w	r0, [r2, r0, lsl #2]
10007d86:	9037      	str	r0, [sp, #220]	@ 0xdc
10007d88:	ee33 0b10 	vmov.32	r0, d3[1]
10007d8c:	ff2e 2446 	vshl.u32	q1, q3, q7
10007d90:	f852 6026 	ldr.w	r6, [r2, r6, lsl #2]
10007d94:	ef26 6848 	vadd.i32	q3, q3, q4
10007d98:	9630      	str	r6, [sp, #192]	@ 0xc0
10007d9a:	f852 5025 	ldr.w	r5, [r2, r5, lsl #2]
10007d9e:	ee12 6a10 	vmov	r6, s4
10007da2:	9531      	str	r5, [sp, #196]	@ 0xc4
10007da4:	f852 4024 	ldr.w	r4, [r2, r4, lsl #2]
10007da8:	ee32 5b10 	vmov.32	r5, d2[1]
10007dac:	9432      	str	r4, [sp, #200]	@ 0xc8
10007dae:	f852 0020 	ldr.w	r0, [r2, r0, lsl #2]
10007db2:	ee13 4b10 	vmov.32	r4, d3[0]
10007db6:	9033      	str	r0, [sp, #204]	@ 0xcc
10007db8:	ee33 0b10 	vmov.32	r0, d3[1]
10007dbc:	ed9d 3f34 	vldrw.u32	q1, [sp, #208]
10007dc0:	ef02 2154 	vand	q1, q1, q2
10007dc4:	ed9d 5f00 	vldrw.u32	q2, [sp, #0]
10007dc8:	ef24 4152 	vorr	q2, q2, q1
10007dcc:	f852 6026 	ldr.w	r6, [r2, r6, lsl #2]
10007dd0:	ed8d 7f0c 	vstrw.32	q3, [sp, #48]
10007dd4:	962c      	str	r6, [sp, #176]	@ 0xb0
10007dd6:	f852 5025 	ldr.w	r5, [r2, r5, lsl #2]
10007dda:	952d      	str	r5, [sp, #180]	@ 0xb4
10007ddc:	f852 4024 	ldr.w	r4, [r2, r4, lsl #2]
10007de0:	942e      	str	r4, [sp, #184]	@ 0xb8
10007de2:	f852 0020 	ldr.w	r0, [r2, r0, lsl #2]
10007de6:	902f      	str	r0, [sp, #188]	@ 0xbc
10007de8:	ed8d 5f00 	vstrw.32	q2, [sp, #0]
10007dec:	ed9d 7f10 	vldrw.u32	q3, [sp, #64]
10007df0:	ed9d 5f30 	vldrw.u32	q2, [sp, #192]
10007df4:	ef04 4156 	vand	q2, q2, q3
10007df8:	ed9d 7f04 	vldrw.u32	q3, [sp, #16]
10007dfc:	ef26 6154 	vorr	q3, q3, q2
10007e00:	ed8d 7f04 	vstrw.32	q3, [sp, #16]
10007e04:	ed9d 7f2c 	vldrw.u32	q3, [sp, #176]
10007e08:	ed9d 5f08 	vldrw.u32	q2, [sp, #32]
10007e0c:	ef06 6150 	vand	q3, q3, q0
10007e10:	ef24 6156 	vorr	q3, q2, q3
10007e14:	ed8d 7f08 	vstrw.32	q3, [sp, #32]
10007e18:	f00f c095 	le	lr, 10007cf4 <fndsa_poly_big_to_fp64_exact+0xfc>
10007e1c:	ed9d 7f00 	vldrw.u32	q3, [sp, #0]
10007e20:	ed9d 5f04 	vldrw.u32	q2, [sp, #16]
10007e24:	ee37 0b10 	vmov.32	r0, d7[1]
10007e28:	ee16 6a10 	vmov	r6, s12
10007e2c:	ee36 5b10 	vmov.32	r5, d6[1]
10007e30:	4306      	orrs	r6, r0
10007e32:	ee14 0a10 	vmov	r0, s8
10007e36:	ee34 cb10 	vmov.32	ip, d4[1]
10007e3a:	4305      	orrs	r5, r0
10007e3c:	ee17 0b10 	vmov.32	r0, d7[0]
10007e40:	ea40 000c 	orr.w	r0, r0, ip
10007e44:	ee15 cb10 	vmov.32	ip, d5[0]
10007e48:	ed9d 7f08 	vldrw.u32	q3, [sp, #32]
10007e4c:	ea46 060c 	orr.w	r6, r6, ip
10007e50:	ee35 cb10 	vmov.32	ip, d5[1]
10007e54:	ea45 050c 	orr.w	r5, r5, ip
10007e58:	ee16 ca10 	vmov	ip, s12
10007e5c:	ea40 000c 	orr.w	r0, r0, ip
10007e60:	ee36 cb10 	vmov.32	ip, d6[1]
10007e64:	ea46 060c 	orr.w	r6, r6, ip
10007e68:	ee17 cb10 	vmov.32	ip, d7[0]
10007e6c:	ea45 050c 	orr.w	r5, r5, ip
10007e70:	ee37 cb10 	vmov.32	ip, d7[1]
10007e74:	079c      	lsls	r4, r3, #30
10007e76:	ea40 000c 	orr.w	r0, r0, ip
10007e7a:	f000 80f1 	beq.w	10008060 <fndsa_poly_big_to_fp64_exact+0x468>
10007e7e:	f023 0c03 	bic.w	ip, r3, #3
10007e82:	e031      	b.n	10007ee8 <fndsa_poly_big_to_fp64_exact+0x2f0>
10007e84:	f3af 8000 	nop.w
10007e88:	ffffffff 	.word	0xffffffff
10007e8c:	00000001 	.word	0x00000001
10007e90:	00000000 	.word	0x00000000
10007e94:	ffffffff 	.word	0xffffffff
10007e98:	00000000 	.word	0x00000000
10007e9c:	ffffffff 	.word	0xffffffff
10007ea0:	00000001 	.word	0x00000001
10007ea4:	00000000 	.word	0x00000000
10007ea8:	00000001 	.word	0x00000001
10007eac:	00000000 	.word	0x00000000
10007eb0:	ffffffff 	.word	0xffffffff
10007eb4:	00000001 	.word	0x00000001
10007eb8:	00000002 	.word	0x00000002
10007ebc:	00000003 	.word	0x00000003
10007ec0:	00000003 	.word	0x00000003
10007ec4:	00000003 	.word	0x00000003
10007ec8:	00000001 	.word	0x00000001
10007ecc:	00000001 	.word	0x00000001
10007ed0:	00000002 	.word	0x00000002
10007ed4:	00000002 	.word	0x00000002
	...
10007ee4:	00000001 	.word	0x00000001
10007ee8:	9c2b      	ldr	r4, [sp, #172]	@ 0xac
10007eea:	fa0c fe07 	lsl.w	lr, ip, r7
10007eee:	f852 a02e 	ldr.w	sl, [r2, lr, lsl #2]
10007ef2:	ea84 0e0c 	eor.w	lr, r4, ip
10007ef6:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10007efa:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10007efe:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
10007f02:	ea40 000e 	orr.w	r0, r0, lr
10007f06:	ea88 0e0c 	eor.w	lr, r8, ip
10007f0a:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10007f0e:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10007f12:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
10007f16:	ea45 050e 	orr.w	r5, r5, lr
10007f1a:	ea89 0e0c 	eor.w	lr, r9, ip
10007f1e:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10007f22:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10007f26:	ea0a 7aee 	and.w	sl, sl, lr, asr #31
10007f2a:	f10c 0e01 	add.w	lr, ip, #1
10007f2e:	4573      	cmp	r3, lr
10007f30:	ea46 060a 	orr.w	r6, r6, sl
10007f34:	f240 8094 	bls.w	10008060 <fndsa_poly_big_to_fp64_exact+0x468>
10007f38:	fa0e fa07 	lsl.w	sl, lr, r7
10007f3c:	f852 b02a 	ldr.w	fp, [r2, sl, lsl #2]
10007f40:	ea84 0a0e 	eor.w	sl, r4, lr
10007f44:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10007f48:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10007f4c:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10007f50:	ea40 000a 	orr.w	r0, r0, sl
10007f54:	ea88 0a0e 	eor.w	sl, r8, lr
10007f58:	ea89 0e0e 	eor.w	lr, r9, lr
10007f5c:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10007f60:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10007f64:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10007f68:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10007f6c:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10007f70:	ea0b 7bee 	and.w	fp, fp, lr, asr #31
10007f74:	f10c 0e02 	add.w	lr, ip, #2
10007f78:	4573      	cmp	r3, lr
10007f7a:	ea45 050a 	orr.w	r5, r5, sl
10007f7e:	ea46 060b 	orr.w	r6, r6, fp
10007f82:	d96d      	bls.n	10008060 <fndsa_poly_big_to_fp64_exact+0x468>
10007f84:	fa0e fa07 	lsl.w	sl, lr, r7
10007f88:	f852 b02a 	ldr.w	fp, [r2, sl, lsl #2]
10007f8c:	ea84 0a0e 	eor.w	sl, r4, lr
10007f90:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10007f94:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10007f98:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10007f9c:	ea40 000a 	orr.w	r0, r0, sl
10007fa0:	ea88 0a0e 	eor.w	sl, r8, lr
10007fa4:	ea89 0e0e 	eor.w	lr, r9, lr
10007fa8:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10007fac:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10007fb0:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10007fb4:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10007fb8:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10007fbc:	ea0b 7bee 	and.w	fp, fp, lr, asr #31
10007fc0:	f10c 0e03 	add.w	lr, ip, #3
10007fc4:	4573      	cmp	r3, lr
10007fc6:	ea45 050a 	orr.w	r5, r5, sl
10007fca:	ea46 060b 	orr.w	r6, r6, fp
10007fce:	d947      	bls.n	10008060 <fndsa_poly_big_to_fp64_exact+0x468>
10007fd0:	fa0e fa07 	lsl.w	sl, lr, r7
10007fd4:	f852 b02a 	ldr.w	fp, [r2, sl, lsl #2]
10007fd8:	ea84 0a0e 	eor.w	sl, r4, lr
10007fdc:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10007fe0:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10007fe4:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10007fe8:	ea40 000a 	orr.w	r0, r0, sl
10007fec:	ea88 0a0e 	eor.w	sl, r8, lr
10007ff0:	ea89 0e0e 	eor.w	lr, r9, lr
10007ff4:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10007ff8:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10007ffc:	f10c 0c04 	add.w	ip, ip, #4
10008000:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10008004:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10008008:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
1000800c:	4563      	cmp	r3, ip
1000800e:	ea0b 7bee 	and.w	fp, fp, lr, asr #31
10008012:	ea45 050a 	orr.w	r5, r5, sl
10008016:	ea46 060b 	orr.w	r6, r6, fp
1000801a:	d921      	bls.n	10008060 <fndsa_poly_big_to_fp64_exact+0x468>
1000801c:	fa0c fe07 	lsl.w	lr, ip, r7
10008020:	f852 a02e 	ldr.w	sl, [r2, lr, lsl #2]
10008024:	ea84 0e0c 	eor.w	lr, r4, ip
10008028:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
1000802c:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10008030:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
10008034:	ea40 000e 	orr.w	r0, r0, lr
10008038:	ea88 0e0c 	eor.w	lr, r8, ip
1000803c:	ea89 0c0c 	eor.w	ip, r9, ip
10008040:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10008044:	f02c 4c7f 	bic.w	ip, ip, #4278190080	@ 0xff000000
10008048:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
1000804c:	f10c 3cff 	add.w	ip, ip, #4294967295	@ 0xffffffff
10008050:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
10008054:	ea0a 7aec 	and.w	sl, sl, ip, asr #31
10008058:	ea45 050e 	orr.w	r5, r5, lr
1000805c:	ea46 060a 	orr.w	r6, r6, sl
10008060:	9c20      	ldr	r4, [sp, #128]	@ 0x80
10008062:	3204      	adds	r2, #4
10008064:	f854 cf04 	ldr.w	ip, [r4, #4]!
10008068:	3110      	adds	r1, #16
1000806a:	9420      	str	r4, [sp, #128]	@ 0x80
1000806c:	ea4f 7c9c 	mov.w	ip, ip, lsr #30
10008070:	9c24      	ldr	r4, [sp, #144]	@ 0x90
10008072:	f1cc 0c00 	rsb	ip, ip, #0
10008076:	ea04 0e5c 	and.w	lr, r4, ip, lsr #1
1000807a:	ea4e 0e06 	orr.w	lr, lr, r6
1000807e:	ea4f 064e 	mov.w	r6, lr, lsl #1
10008082:	9c28      	ldr	r4, [sp, #160]	@ 0xa0
10008084:	f006 4600 	and.w	r6, r6, #2147483648	@ 0x80000000
10008088:	ea46 060e 	orr.w	r6, r6, lr
1000808c:	40a6      	lsls	r6, r4
1000808e:	9c23      	ldr	r4, [sp, #140]	@ 0x8c
10008090:	ea04 0e5c 	and.w	lr, r4, ip, lsr #1
10008094:	9c22      	ldr	r4, [sp, #136]	@ 0x88
10008096:	ea4e 0e05 	orr.w	lr, lr, r5
1000809a:	ea04 0c5c 	and.w	ip, r4, ip, lsr #1
1000809e:	ea4c 0c00 	orr.w	ip, ip, r0
100080a2:	9826      	ldr	r0, [sp, #152]	@ 0x98
100080a4:	fa2c fc00 	lsr.w	ip, ip, r0
100080a8:	9827      	ldr	r0, [sp, #156]	@ 0x9c
100080aa:	fa0e f000 	lsl.w	r0, lr, r0
100080ae:	ea4c 0c00 	orr.w	ip, ip, r0
100080b2:	9825      	ldr	r0, [sp, #148]	@ 0x94
100080b4:	fa2e fe00 	lsr.w	lr, lr, r0
100080b8:	ea46 060e 	orr.w	r6, r6, lr
100080bc:	ee07 6a90 	vmov	s15, r6
100080c0:	eeb8 6b67 	vcvt.f64.u32	d6, s15
100080c4:	ee07 ca90 	vmov	s15, ip
100080c8:	eeb8 7b67 	vcvt.f64.u32	d7, s15
100080cc:	9829      	ldr	r0, [sp, #164]	@ 0xa4
100080ce:	ed01 6b04 	vstr	d6, [r1, #-16]
100080d2:	4282      	cmp	r2, r0
100080d4:	ed01 7b02 	vstr	d7, [r1, #-8]
100080d8:	f47f adef 	bne.w	10007cba <fndsa_poly_big_to_fp64_exact+0xc2>
100080dc:	b039      	add	sp, #228	@ 0xe4
100080de:	ecbd 8b10 	vpop	{d8-d15}
100080e2:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
100080e6:	f04f 0c00 	mov.w	ip, #0
100080ea:	4666      	mov	r6, ip
100080ec:	4665      	mov	r5, ip
100080ee:	4660      	mov	r0, ip
100080f0:	e6fa      	b.n	10007ee8 <fndsa_poly_big_to_fp64_exact+0x2f0>
100080f2:	2210      	movs	r2, #16
100080f4:	4619      	mov	r1, r3
100080f6:	40ba      	lsls	r2, r7
100080f8:	b039      	add	sp, #228	@ 0xe4
100080fa:	ecbd 8b10 	vpop	{d8-d15}
100080fe:	e8bd 4ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10008102:	f00e bac9 	b.w	10016698 <memset>
10008106:	bf00      	nop

