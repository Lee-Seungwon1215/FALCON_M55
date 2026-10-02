10006f38 <fndsa_poly_big_to_fp64_exact>:
10006f38:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10006f3c:	ed2d 8b10 	vpush	{d8-d15}
10006f40:	b0b9      	sub	sp, #228	@ 0xe4
10006f42:	4607      	mov	r7, r0
10006f44:	9d52      	ldr	r5, [sp, #328]	@ 0x148
10006f46:	4608      	mov	r0, r1
10006f48:	2b00      	cmp	r3, #0
10006f4a:	f000 8272 	beq.w	10007432 <fndsa_poly_big_to_fp64_exact+0x4fa>
10006f4e:	eb05 1145 	add.w	r1, r5, r5, lsl #5
10006f52:	eb01 2181 	add.w	r1, r1, r1, lsl #10
10006f56:	eb05 0441 	add.w	r4, r5, r1, lsl #1
10006f5a:	0d64      	lsrs	r4, r4, #21
10006f5c:	4601      	mov	r1, r0
10006f5e:	ebc4 1044 	rsb	r0, r4, r4, lsl #5
10006f62:	1a2d      	subs	r5, r5, r0
10006f64:	1e6e      	subs	r6, r5, #1
10006f66:	eba4 78d6 	sub.w	r8, r4, r6, lsr #31
10006f6a:	eea6 8b10 	vdup.32	q3, r8
10006f6e:	ed9f 0b96 	vldr	d0, [pc, #600]	@ 100071c8 <fndsa_poly_big_to_fp64_exact+0x290>
10006f72:	ed9f 1b97 	vldr	d1, [pc, #604]	@ 100071d0 <fndsa_poly_big_to_fp64_exact+0x298>
10006f76:	ed9f 2b98 	vldr	d2, [pc, #608]	@ 100071d8 <fndsa_poly_big_to_fp64_exact+0x2a0>
10006f7a:	ed9f 3b99 	vldr	d3, [pc, #612]	@ 100071e0 <fndsa_poly_big_to_fp64_exact+0x2a8>
10006f7e:	ed9f 4b9a 	vldr	d4, [pc, #616]	@ 100071e8 <fndsa_poly_big_to_fp64_exact+0x2b0>
10006f82:	ed9f 5b9b 	vldr	d5, [pc, #620]	@ 100071f0 <fndsa_poly_big_to_fp64_exact+0x2b8>
10006f86:	ef26 0840 	vadd.i32	q0, q3, q0
10006f8a:	ef26 2842 	vadd.i32	q1, q3, q1
10006f8e:	ef26 6844 	vadd.i32	q3, q3, q2
10006f92:	1b18      	subs	r0, r3, r4
10006f94:	17f4      	asrs	r4, r6, #31
10006f96:	f004 041f 	and.w	r4, r4, #31
10006f9a:	eb00 70d6 	add.w	r0, r0, r6, lsr #31
10006f9e:	ea44 0605 	orr.w	r6, r4, r5
10006fa2:	2404      	movs	r4, #4
10006fa4:	eeae 7b10 	vdup.32	q7, r7
10006fa8:	ed8d 1f14 	vstrw.32	q0, [sp, #80]
10006fac:	ed8d 3f18 	vstrw.32	q1, [sp, #96]
10006fb0:	ed8d 7f1c 	vstrw.32	q3, [sp, #112]
10006fb4:	1e5d      	subs	r5, r3, #1
10006fb6:	9521      	str	r5, [sp, #132]	@ 0x84
10006fb8:	1e45      	subs	r5, r0, #1
10006fba:	17ed      	asrs	r5, r5, #31
10006fbc:	9523      	str	r5, [sp, #140]	@ 0x8c
10006fbe:	40bc      	lsls	r4, r7
10006fc0:	1e85      	subs	r5, r0, #2
10006fc2:	17c0      	asrs	r0, r0, #31
10006fc4:	1914      	adds	r4, r2, r4
10006fc6:	9022      	str	r0, [sp, #136]	@ 0x88
10006fc8:	17e8      	asrs	r0, r5, #31
10006fca:	1e5d      	subs	r5, r3, #1
10006fcc:	40bd      	lsls	r5, r7
10006fce:	9024      	str	r0, [sp, #144]	@ 0x90
10006fd0:	9429      	str	r4, [sp, #164]	@ 0xa4
10006fd2:	1f10      	subs	r0, r2, #4
10006fd4:	f1c6 0420 	rsb	r4, r6, #32
10006fd8:	eb00 0085 	add.w	r0, r0, r5, lsl #2
10006fdc:	9427      	str	r4, [sp, #156]	@ 0x9c
10006fde:	f1c6 041f 	rsb	r4, r6, #31
10006fe2:	9020      	str	r0, [sp, #128]	@ 0x80
10006fe4:	1e75      	subs	r5, r6, #1
10006fe6:	f108 30ff 	add.w	r0, r8, #4294967295	@ 0xffffffff
10006fea:	9428      	str	r4, [sp, #160]	@ 0xa0
10006fec:	089c      	lsrs	r4, r3, #2
10006fee:	9625      	str	r6, [sp, #148]	@ 0x94
10006ff0:	f108 0901 	add.w	r9, r8, #1
10006ff4:	9526      	str	r5, [sp, #152]	@ 0x98
10006ff6:	942a      	str	r4, [sp, #168]	@ 0xa8
10006ff8:	902b      	str	r0, [sp, #172]	@ 0xac
10006ffa:	9821      	ldr	r0, [sp, #132]	@ 0x84
10006ffc:	2804      	cmp	r0, #4
10006ffe:	f240 8212 	bls.w	10007426 <fndsa_poly_big_to_fp64_exact+0x4ee>
10007002:	ef80 6050 	vmov.i32	q3, #0	@ 0x00000000
10007006:	ed9f 8b7c 	vldr	d8, [pc, #496]	@ 100071f8 <fndsa_poly_big_to_fp64_exact+0x2c0>
1000700a:	ed9f 9b7d 	vldr	d9, [pc, #500]	@ 10007200 <fndsa_poly_big_to_fp64_exact+0x2c8>
1000700e:	982a      	ldr	r0, [sp, #168]	@ 0xa8
10007010:	ed8d 7f08 	vstrw.32	q3, [sp, #32]
10007014:	f040 e001 	dls	lr, r0
10007018:	ed8d 7f04 	vstrw.32	q3, [sp, #16]
1000701c:	ed8d 7f00 	vstrw.32	q3, [sp, #0]
10007020:	ed9f cb79 	vldr	d12, [pc, #484]	@ 10007208 <fndsa_poly_big_to_fp64_exact+0x2d0>
10007024:	ed9f db7a 	vldr	d13, [pc, #488]	@ 10007210 <fndsa_poly_big_to_fp64_exact+0x2d8>
10007028:	ed9f ab7b 	vldr	d10, [pc, #492]	@ 10007218 <fndsa_poly_big_to_fp64_exact+0x2e0>
1000702c:	ed9f bb7c 	vldr	d11, [pc, #496]	@ 10007220 <fndsa_poly_big_to_fp64_exact+0x2e8>
10007030:	ed8d 9f0c 	vstrw.32	q4, [sp, #48]
10007034:	ff2e 644a 	vshl.u32	q3, q5, q7
10007038:	ee16 6a10 	vmov	r6, s12
1000703c:	ee36 5b10 	vmov.32	r5, d6[1]
10007040:	ee17 4b10 	vmov.32	r4, d7[0]
10007044:	ee37 0b10 	vmov.32	r0, d7[1]
10007048:	ed9d 7f1c 	vldrw.u32	q3, [sp, #112]
1000704c:	ed9d 1f18 	vldrw.u32	q0, [sp, #96]
10007050:	ff0a 4156 	veor	q2, q5, q3
10007054:	ef80 6054 	vmov.i32	q3, #4	@ 0x00000004
10007058:	ef26 8156 	vmov	q4, q3
1000705c:	ef2a a846 	vadd.i32	q5, q5, q3
10007060:	ff0c 6150 	veor	q3, q6, q0
10007064:	ff87 2e5f 	vmov.i8	q1, #255	@ 0xff
10007068:	ff87 677f 	vbic.i32	q3, #4278190080	@ 0xff000000
1000706c:	ef26 6842 	vadd.i32	q3, q3, q1
10007070:	efa1 6056 	vshr.s32	q3, q3, #31
10007074:	ed9d 1f14 	vldrw.u32	q0, [sp, #80]
10007078:	ed8d 7f10 	vstrw.32	q3, [sp, #64]
1000707c:	ed9d 7f0c 	vldrw.u32	q3, [sp, #48]
10007080:	ff06 0150 	veor	q0, q3, q0
10007084:	ff87 477f 	vbic.i32	q2, #4278190080	@ 0xff000000
10007088:	ff87 077f 	vbic.i32	q0, #4278190080	@ 0xff000000
1000708c:	ef24 4842 	vadd.i32	q2, q2, q1
10007090:	ef20 0842 	vadd.i32	q0, q0, q1
10007094:	ff2e 244c 	vshl.u32	q1, q6, q7
10007098:	f852 6026 	ldr.w	r6, [r2, r6, lsl #2]
1000709c:	efa1 4054 	vshr.s32	q2, q2, #31
100070a0:	9634      	str	r6, [sp, #208]	@ 0xd0
100070a2:	ee12 6a10 	vmov	r6, s4
100070a6:	f852 5025 	ldr.w	r5, [r2, r5, lsl #2]
100070aa:	efa1 0050 	vshr.s32	q0, q0, #31
100070ae:	9535      	str	r5, [sp, #212]	@ 0xd4
100070b0:	ee32 5b10 	vmov.32	r5, d2[1]
100070b4:	f852 4024 	ldr.w	r4, [r2, r4, lsl #2]
100070b8:	ef2c c848 	vadd.i32	q6, q6, q4
100070bc:	9436      	str	r4, [sp, #216]	@ 0xd8
100070be:	ee13 4b10 	vmov.32	r4, d3[0]
100070c2:	f852 0020 	ldr.w	r0, [r2, r0, lsl #2]
100070c6:	9037      	str	r0, [sp, #220]	@ 0xdc
100070c8:	ee33 0b10 	vmov.32	r0, d3[1]
100070cc:	ff2e 2446 	vshl.u32	q1, q3, q7
100070d0:	f852 6026 	ldr.w	r6, [r2, r6, lsl #2]
100070d4:	ef26 6848 	vadd.i32	q3, q3, q4
100070d8:	9630      	str	r6, [sp, #192]	@ 0xc0
100070da:	f852 5025 	ldr.w	r5, [r2, r5, lsl #2]
100070de:	ee12 6a10 	vmov	r6, s4
100070e2:	9531      	str	r5, [sp, #196]	@ 0xc4
100070e4:	f852 4024 	ldr.w	r4, [r2, r4, lsl #2]
100070e8:	ee32 5b10 	vmov.32	r5, d2[1]
100070ec:	9432      	str	r4, [sp, #200]	@ 0xc8
100070ee:	f852 0020 	ldr.w	r0, [r2, r0, lsl #2]
100070f2:	ee13 4b10 	vmov.32	r4, d3[0]
100070f6:	9033      	str	r0, [sp, #204]	@ 0xcc
100070f8:	ee33 0b10 	vmov.32	r0, d3[1]
100070fc:	ed9d 3f34 	vldrw.u32	q1, [sp, #208]
10007100:	ef02 2154 	vand	q1, q1, q2
10007104:	ed9d 5f00 	vldrw.u32	q2, [sp, #0]
10007108:	ef24 4152 	vorr	q2, q2, q1
1000710c:	f852 6026 	ldr.w	r6, [r2, r6, lsl #2]
10007110:	ed8d 7f0c 	vstrw.32	q3, [sp, #48]
10007114:	962c      	str	r6, [sp, #176]	@ 0xb0
10007116:	f852 5025 	ldr.w	r5, [r2, r5, lsl #2]
1000711a:	952d      	str	r5, [sp, #180]	@ 0xb4
1000711c:	f852 4024 	ldr.w	r4, [r2, r4, lsl #2]
10007120:	942e      	str	r4, [sp, #184]	@ 0xb8
10007122:	f852 0020 	ldr.w	r0, [r2, r0, lsl #2]
10007126:	902f      	str	r0, [sp, #188]	@ 0xbc
10007128:	ed8d 5f00 	vstrw.32	q2, [sp, #0]
1000712c:	ed9d 7f10 	vldrw.u32	q3, [sp, #64]
10007130:	ed9d 5f30 	vldrw.u32	q2, [sp, #192]
10007134:	ef04 4156 	vand	q2, q2, q3
10007138:	ed9d 7f04 	vldrw.u32	q3, [sp, #16]
1000713c:	ef26 6154 	vorr	q3, q3, q2
10007140:	ed8d 7f04 	vstrw.32	q3, [sp, #16]
10007144:	ed9d 7f2c 	vldrw.u32	q3, [sp, #176]
10007148:	ed9d 5f08 	vldrw.u32	q2, [sp, #32]
1000714c:	ef06 6150 	vand	q3, q3, q0
10007150:	ef24 6156 	vorr	q3, q2, q3
10007154:	ed8d 7f08 	vstrw.32	q3, [sp, #32]
10007158:	f00f c095 	le	lr, 10007034 <fndsa_poly_big_to_fp64_exact+0xfc>
1000715c:	ed9d 7f00 	vldrw.u32	q3, [sp, #0]
10007160:	ed9d 5f04 	vldrw.u32	q2, [sp, #16]
10007164:	ee37 0b10 	vmov.32	r0, d7[1]
10007168:	ee16 6a10 	vmov	r6, s12
1000716c:	ee36 5b10 	vmov.32	r5, d6[1]
10007170:	4306      	orrs	r6, r0
10007172:	ee14 0a10 	vmov	r0, s8
10007176:	ee34 cb10 	vmov.32	ip, d4[1]
1000717a:	4305      	orrs	r5, r0
1000717c:	ee17 0b10 	vmov.32	r0, d7[0]
10007180:	ea40 000c 	orr.w	r0, r0, ip
10007184:	ee15 cb10 	vmov.32	ip, d5[0]
10007188:	ed9d 7f08 	vldrw.u32	q3, [sp, #32]
1000718c:	ea46 060c 	orr.w	r6, r6, ip
10007190:	ee35 cb10 	vmov.32	ip, d5[1]
10007194:	ea45 050c 	orr.w	r5, r5, ip
10007198:	ee16 ca10 	vmov	ip, s12
1000719c:	ea40 000c 	orr.w	r0, r0, ip
100071a0:	ee36 cb10 	vmov.32	ip, d6[1]
100071a4:	ea46 060c 	orr.w	r6, r6, ip
100071a8:	ee17 cb10 	vmov.32	ip, d7[0]
100071ac:	ea45 050c 	orr.w	r5, r5, ip
100071b0:	ee37 cb10 	vmov.32	ip, d7[1]
100071b4:	079c      	lsls	r4, r3, #30
100071b6:	ea40 000c 	orr.w	r0, r0, ip
100071ba:	f000 80f1 	beq.w	100073a0 <fndsa_poly_big_to_fp64_exact+0x468>
100071be:	f023 0c03 	bic.w	ip, r3, #3
100071c2:	e031      	b.n	10007228 <fndsa_poly_big_to_fp64_exact+0x2f0>
100071c4:	f3af 8000 	nop.w
100071c8:	ffffffff 	.word	0xffffffff
100071cc:	00000001 	.word	0x00000001
100071d0:	00000000 	.word	0x00000000
100071d4:	ffffffff 	.word	0xffffffff
100071d8:	00000000 	.word	0x00000000
100071dc:	ffffffff 	.word	0xffffffff
100071e0:	00000001 	.word	0x00000001
100071e4:	00000000 	.word	0x00000000
100071e8:	00000001 	.word	0x00000001
100071ec:	00000000 	.word	0x00000000
100071f0:	ffffffff 	.word	0xffffffff
100071f4:	00000001 	.word	0x00000001
100071f8:	00000002 	.word	0x00000002
100071fc:	00000003 	.word	0x00000003
10007200:	00000003 	.word	0x00000003
10007204:	00000003 	.word	0x00000003
10007208:	00000001 	.word	0x00000001
1000720c:	00000001 	.word	0x00000001
10007210:	00000002 	.word	0x00000002
10007214:	00000002 	.word	0x00000002
	...
10007224:	00000001 	.word	0x00000001
10007228:	9c2b      	ldr	r4, [sp, #172]	@ 0xac
1000722a:	fa0c fe07 	lsl.w	lr, ip, r7
1000722e:	f852 a02e 	ldr.w	sl, [r2, lr, lsl #2]
10007232:	ea84 0e0c 	eor.w	lr, r4, ip
10007236:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
1000723a:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
1000723e:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
10007242:	ea40 000e 	orr.w	r0, r0, lr
10007246:	ea88 0e0c 	eor.w	lr, r8, ip
1000724a:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
1000724e:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10007252:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
10007256:	ea45 050e 	orr.w	r5, r5, lr
1000725a:	ea89 0e0c 	eor.w	lr, r9, ip
1000725e:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10007262:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10007266:	ea0a 7aee 	and.w	sl, sl, lr, asr #31
1000726a:	f10c 0e01 	add.w	lr, ip, #1
1000726e:	4573      	cmp	r3, lr
10007270:	ea46 060a 	orr.w	r6, r6, sl
10007274:	f240 8094 	bls.w	100073a0 <fndsa_poly_big_to_fp64_exact+0x468>
10007278:	fa0e fa07 	lsl.w	sl, lr, r7
1000727c:	f852 b02a 	ldr.w	fp, [r2, sl, lsl #2]
10007280:	ea84 0a0e 	eor.w	sl, r4, lr
10007284:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10007288:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
1000728c:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10007290:	ea40 000a 	orr.w	r0, r0, sl
10007294:	ea88 0a0e 	eor.w	sl, r8, lr
10007298:	ea89 0e0e 	eor.w	lr, r9, lr
1000729c:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
100072a0:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
100072a4:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
100072a8:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
100072ac:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
100072b0:	ea0b 7bee 	and.w	fp, fp, lr, asr #31
100072b4:	f10c 0e02 	add.w	lr, ip, #2
100072b8:	4573      	cmp	r3, lr
100072ba:	ea45 050a 	orr.w	r5, r5, sl
100072be:	ea46 060b 	orr.w	r6, r6, fp
100072c2:	d96d      	bls.n	100073a0 <fndsa_poly_big_to_fp64_exact+0x468>
100072c4:	fa0e fa07 	lsl.w	sl, lr, r7
100072c8:	f852 b02a 	ldr.w	fp, [r2, sl, lsl #2]
100072cc:	ea84 0a0e 	eor.w	sl, r4, lr
100072d0:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
100072d4:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
100072d8:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
100072dc:	ea40 000a 	orr.w	r0, r0, sl
100072e0:	ea88 0a0e 	eor.w	sl, r8, lr
100072e4:	ea89 0e0e 	eor.w	lr, r9, lr
100072e8:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
100072ec:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
100072f0:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
100072f4:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
100072f8:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
100072fc:	ea0b 7bee 	and.w	fp, fp, lr, asr #31
10007300:	f10c 0e03 	add.w	lr, ip, #3
10007304:	4573      	cmp	r3, lr
10007306:	ea45 050a 	orr.w	r5, r5, sl
1000730a:	ea46 060b 	orr.w	r6, r6, fp
1000730e:	d947      	bls.n	100073a0 <fndsa_poly_big_to_fp64_exact+0x468>
10007310:	fa0e fa07 	lsl.w	sl, lr, r7
10007314:	f852 b02a 	ldr.w	fp, [r2, sl, lsl #2]
10007318:	ea84 0a0e 	eor.w	sl, r4, lr
1000731c:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10007320:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10007324:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10007328:	ea40 000a 	orr.w	r0, r0, sl
1000732c:	ea88 0a0e 	eor.w	sl, r8, lr
10007330:	ea89 0e0e 	eor.w	lr, r9, lr
10007334:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10007338:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
1000733c:	f10c 0c04 	add.w	ip, ip, #4
10007340:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10007344:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10007348:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
1000734c:	4563      	cmp	r3, ip
1000734e:	ea0b 7bee 	and.w	fp, fp, lr, asr #31
10007352:	ea45 050a 	orr.w	r5, r5, sl
10007356:	ea46 060b 	orr.w	r6, r6, fp
1000735a:	d921      	bls.n	100073a0 <fndsa_poly_big_to_fp64_exact+0x468>
1000735c:	fa0c fe07 	lsl.w	lr, ip, r7
10007360:	f852 a02e 	ldr.w	sl, [r2, lr, lsl #2]
10007364:	ea84 0e0c 	eor.w	lr, r4, ip
10007368:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
1000736c:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10007370:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
10007374:	ea40 000e 	orr.w	r0, r0, lr
10007378:	ea88 0e0c 	eor.w	lr, r8, ip
1000737c:	ea89 0c0c 	eor.w	ip, r9, ip
10007380:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10007384:	f02c 4c7f 	bic.w	ip, ip, #4278190080	@ 0xff000000
10007388:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
1000738c:	f10c 3cff 	add.w	ip, ip, #4294967295	@ 0xffffffff
10007390:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
10007394:	ea0a 7aec 	and.w	sl, sl, ip, asr #31
10007398:	ea45 050e 	orr.w	r5, r5, lr
1000739c:	ea46 060a 	orr.w	r6, r6, sl
100073a0:	9c20      	ldr	r4, [sp, #128]	@ 0x80
100073a2:	3204      	adds	r2, #4
100073a4:	f854 cf04 	ldr.w	ip, [r4, #4]!
100073a8:	3110      	adds	r1, #16
100073aa:	9420      	str	r4, [sp, #128]	@ 0x80
100073ac:	ea4f 7c9c 	mov.w	ip, ip, lsr #30
100073b0:	9c24      	ldr	r4, [sp, #144]	@ 0x90
100073b2:	f1cc 0c00 	rsb	ip, ip, #0
100073b6:	ea04 0e5c 	and.w	lr, r4, ip, lsr #1
100073ba:	ea4e 0e06 	orr.w	lr, lr, r6
100073be:	ea4f 064e 	mov.w	r6, lr, lsl #1
100073c2:	9c28      	ldr	r4, [sp, #160]	@ 0xa0
100073c4:	f006 4600 	and.w	r6, r6, #2147483648	@ 0x80000000
100073c8:	ea46 060e 	orr.w	r6, r6, lr
100073cc:	40a6      	lsls	r6, r4
100073ce:	9c23      	ldr	r4, [sp, #140]	@ 0x8c
100073d0:	ea04 0e5c 	and.w	lr, r4, ip, lsr #1
100073d4:	9c22      	ldr	r4, [sp, #136]	@ 0x88
100073d6:	ea4e 0e05 	orr.w	lr, lr, r5
100073da:	ea04 0c5c 	and.w	ip, r4, ip, lsr #1
100073de:	ea4c 0c00 	orr.w	ip, ip, r0
100073e2:	9826      	ldr	r0, [sp, #152]	@ 0x98
100073e4:	fa2c fc00 	lsr.w	ip, ip, r0
100073e8:	9827      	ldr	r0, [sp, #156]	@ 0x9c
100073ea:	fa0e f000 	lsl.w	r0, lr, r0
100073ee:	ea4c 0c00 	orr.w	ip, ip, r0
100073f2:	9825      	ldr	r0, [sp, #148]	@ 0x94
100073f4:	fa2e fe00 	lsr.w	lr, lr, r0
100073f8:	ea46 060e 	orr.w	r6, r6, lr
100073fc:	ee07 6a90 	vmov	s15, r6
10007400:	eeb8 6b67 	vcvt.f64.u32	d6, s15
10007404:	ee07 ca90 	vmov	s15, ip
10007408:	eeb8 7b67 	vcvt.f64.u32	d7, s15
1000740c:	9829      	ldr	r0, [sp, #164]	@ 0xa4
1000740e:	ed01 6b04 	vstr	d6, [r1, #-16]
10007412:	4282      	cmp	r2, r0
10007414:	ed01 7b02 	vstr	d7, [r1, #-8]
10007418:	f47f adef 	bne.w	10006ffa <fndsa_poly_big_to_fp64_exact+0xc2>
1000741c:	b039      	add	sp, #228	@ 0xe4
1000741e:	ecbd 8b10 	vpop	{d8-d15}
10007422:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10007426:	f04f 0c00 	mov.w	ip, #0
1000742a:	4666      	mov	r6, ip
1000742c:	4665      	mov	r5, ip
1000742e:	4660      	mov	r0, ip
10007430:	e6fa      	b.n	10007228 <fndsa_poly_big_to_fp64_exact+0x2f0>
10007432:	2210      	movs	r2, #16
10007434:	4619      	mov	r1, r3
10007436:	40ba      	lsls	r2, r7
10007438:	b039      	add	sp, #228	@ 0xe4
1000743a:	ecbd 8b10 	vpop	{d8-d15}
1000743e:	e8bd 4ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10007442:	f00f b929 	b.w	10016698 <memset>
10007446:	bf00      	nop

