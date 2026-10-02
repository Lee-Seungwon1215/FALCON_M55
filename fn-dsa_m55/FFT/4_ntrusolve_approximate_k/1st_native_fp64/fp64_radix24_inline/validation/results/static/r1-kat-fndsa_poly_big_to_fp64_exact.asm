
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/r1-kat/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10005fe0 <fndsa_poly_big_to_fp64_exact>:
10005fe0:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10005fe4:	ed2d 8b10 	vpush	{d8-d15}
10005fe8:	b0b9      	sub	sp, #228	@ 0xe4
10005fea:	4607      	mov	r7, r0
10005fec:	9d52      	ldr	r5, [sp, #328]	@ 0x148
10005fee:	4608      	mov	r0, r1
10005ff0:	2b00      	cmp	r3, #0
10005ff2:	f000 8272 	beq.w	100064da <fndsa_poly_big_to_fp64_exact+0x4fa>
10005ff6:	eb05 1145 	add.w	r1, r5, r5, lsl #5
10005ffa:	eb01 2181 	add.w	r1, r1, r1, lsl #10
10005ffe:	eb05 0441 	add.w	r4, r5, r1, lsl #1
10006002:	0d64      	lsrs	r4, r4, #21
10006004:	4601      	mov	r1, r0
10006006:	ebc4 1044 	rsb	r0, r4, r4, lsl #5
1000600a:	1a2d      	subs	r5, r5, r0
1000600c:	1e6e      	subs	r6, r5, #1
1000600e:	eba4 78d6 	sub.w	r8, r4, r6, lsr #31
10006012:	eea6 8b10 	vdup.32	q3, r8
10006016:	ed9f 0b96 	vldr	d0, [pc, #600]	@ 10006270 <fndsa_poly_big_to_fp64_exact+0x290>
1000601a:	ed9f 1b97 	vldr	d1, [pc, #604]	@ 10006278 <fndsa_poly_big_to_fp64_exact+0x298>
1000601e:	ed9f 2b98 	vldr	d2, [pc, #608]	@ 10006280 <fndsa_poly_big_to_fp64_exact+0x2a0>
10006022:	ed9f 3b99 	vldr	d3, [pc, #612]	@ 10006288 <fndsa_poly_big_to_fp64_exact+0x2a8>
10006026:	ed9f 4b9a 	vldr	d4, [pc, #616]	@ 10006290 <fndsa_poly_big_to_fp64_exact+0x2b0>
1000602a:	ed9f 5b9b 	vldr	d5, [pc, #620]	@ 10006298 <fndsa_poly_big_to_fp64_exact+0x2b8>
1000602e:	ef26 0840 	vadd.i32	q0, q3, q0
10006032:	ef26 2842 	vadd.i32	q1, q3, q1
10006036:	ef26 6844 	vadd.i32	q3, q3, q2
1000603a:	1b18      	subs	r0, r3, r4
1000603c:	17f4      	asrs	r4, r6, #31
1000603e:	f004 041f 	and.w	r4, r4, #31
10006042:	eb00 70d6 	add.w	r0, r0, r6, lsr #31
10006046:	ea44 0605 	orr.w	r6, r4, r5
1000604a:	2404      	movs	r4, #4
1000604c:	eeae 7b10 	vdup.32	q7, r7
10006050:	ed8d 1f14 	vstrw.32	q0, [sp, #80]
10006054:	ed8d 3f18 	vstrw.32	q1, [sp, #96]
10006058:	ed8d 7f1c 	vstrw.32	q3, [sp, #112]
1000605c:	1e5d      	subs	r5, r3, #1
1000605e:	9521      	str	r5, [sp, #132]	@ 0x84
10006060:	1e45      	subs	r5, r0, #1
10006062:	17ed      	asrs	r5, r5, #31
10006064:	9523      	str	r5, [sp, #140]	@ 0x8c
10006066:	40bc      	lsls	r4, r7
10006068:	1e85      	subs	r5, r0, #2
1000606a:	17c0      	asrs	r0, r0, #31
1000606c:	1914      	adds	r4, r2, r4
1000606e:	9022      	str	r0, [sp, #136]	@ 0x88
10006070:	17e8      	asrs	r0, r5, #31
10006072:	1e5d      	subs	r5, r3, #1
10006074:	40bd      	lsls	r5, r7
10006076:	9024      	str	r0, [sp, #144]	@ 0x90
10006078:	9429      	str	r4, [sp, #164]	@ 0xa4
1000607a:	1f10      	subs	r0, r2, #4
1000607c:	f1c6 0420 	rsb	r4, r6, #32
10006080:	eb00 0085 	add.w	r0, r0, r5, lsl #2
10006084:	9427      	str	r4, [sp, #156]	@ 0x9c
10006086:	f1c6 041f 	rsb	r4, r6, #31
1000608a:	9020      	str	r0, [sp, #128]	@ 0x80
1000608c:	1e75      	subs	r5, r6, #1
1000608e:	f108 30ff 	add.w	r0, r8, #4294967295	@ 0xffffffff
10006092:	9428      	str	r4, [sp, #160]	@ 0xa0
10006094:	089c      	lsrs	r4, r3, #2
10006096:	9625      	str	r6, [sp, #148]	@ 0x94
10006098:	f108 0901 	add.w	r9, r8, #1
1000609c:	9526      	str	r5, [sp, #152]	@ 0x98
1000609e:	942a      	str	r4, [sp, #168]	@ 0xa8
100060a0:	902b      	str	r0, [sp, #172]	@ 0xac
100060a2:	9821      	ldr	r0, [sp, #132]	@ 0x84
100060a4:	2804      	cmp	r0, #4
100060a6:	f240 8212 	bls.w	100064ce <fndsa_poly_big_to_fp64_exact+0x4ee>
100060aa:	ef80 6050 	vmov.i32	q3, #0	@ 0x00000000
100060ae:	ed9f 8b7c 	vldr	d8, [pc, #496]	@ 100062a0 <fndsa_poly_big_to_fp64_exact+0x2c0>
100060b2:	ed9f 9b7d 	vldr	d9, [pc, #500]	@ 100062a8 <fndsa_poly_big_to_fp64_exact+0x2c8>
100060b6:	982a      	ldr	r0, [sp, #168]	@ 0xa8
100060b8:	ed8d 7f08 	vstrw.32	q3, [sp, #32]
100060bc:	f040 e001 	dls	lr, r0
100060c0:	ed8d 7f04 	vstrw.32	q3, [sp, #16]
100060c4:	ed8d 7f00 	vstrw.32	q3, [sp, #0]
100060c8:	ed9f cb79 	vldr	d12, [pc, #484]	@ 100062b0 <fndsa_poly_big_to_fp64_exact+0x2d0>
100060cc:	ed9f db7a 	vldr	d13, [pc, #488]	@ 100062b8 <fndsa_poly_big_to_fp64_exact+0x2d8>
100060d0:	ed9f ab7b 	vldr	d10, [pc, #492]	@ 100062c0 <fndsa_poly_big_to_fp64_exact+0x2e0>
100060d4:	ed9f bb7c 	vldr	d11, [pc, #496]	@ 100062c8 <fndsa_poly_big_to_fp64_exact+0x2e8>
100060d8:	ed8d 9f0c 	vstrw.32	q4, [sp, #48]
100060dc:	ff2e 644a 	vshl.u32	q3, q5, q7
100060e0:	ee16 6a10 	vmov	r6, s12
100060e4:	ee36 5b10 	vmov.32	r5, d6[1]
100060e8:	ee17 4b10 	vmov.32	r4, d7[0]
100060ec:	ee37 0b10 	vmov.32	r0, d7[1]
100060f0:	ed9d 7f1c 	vldrw.u32	q3, [sp, #112]
100060f4:	ed9d 1f18 	vldrw.u32	q0, [sp, #96]
100060f8:	ff0a 4156 	veor	q2, q5, q3
100060fc:	ef80 6054 	vmov.i32	q3, #4	@ 0x00000004
10006100:	ef26 8156 	vmov	q4, q3
10006104:	ef2a a846 	vadd.i32	q5, q5, q3
10006108:	ff0c 6150 	veor	q3, q6, q0
1000610c:	ff87 2e5f 	vmov.i8	q1, #255	@ 0xff
10006110:	ff87 677f 	vbic.i32	q3, #4278190080	@ 0xff000000
10006114:	ef26 6842 	vadd.i32	q3, q3, q1
10006118:	efa1 6056 	vshr.s32	q3, q3, #31
1000611c:	ed9d 1f14 	vldrw.u32	q0, [sp, #80]
10006120:	ed8d 7f10 	vstrw.32	q3, [sp, #64]
10006124:	ed9d 7f0c 	vldrw.u32	q3, [sp, #48]
10006128:	ff06 0150 	veor	q0, q3, q0
1000612c:	ff87 477f 	vbic.i32	q2, #4278190080	@ 0xff000000
10006130:	ff87 077f 	vbic.i32	q0, #4278190080	@ 0xff000000
10006134:	ef24 4842 	vadd.i32	q2, q2, q1
10006138:	ef20 0842 	vadd.i32	q0, q0, q1
1000613c:	ff2e 244c 	vshl.u32	q1, q6, q7
10006140:	f852 6026 	ldr.w	r6, [r2, r6, lsl #2]
10006144:	efa1 4054 	vshr.s32	q2, q2, #31
10006148:	9634      	str	r6, [sp, #208]	@ 0xd0
1000614a:	ee12 6a10 	vmov	r6, s4
1000614e:	f852 5025 	ldr.w	r5, [r2, r5, lsl #2]
10006152:	efa1 0050 	vshr.s32	q0, q0, #31
10006156:	9535      	str	r5, [sp, #212]	@ 0xd4
10006158:	ee32 5b10 	vmov.32	r5, d2[1]
1000615c:	f852 4024 	ldr.w	r4, [r2, r4, lsl #2]
10006160:	ef2c c848 	vadd.i32	q6, q6, q4
10006164:	9436      	str	r4, [sp, #216]	@ 0xd8
10006166:	ee13 4b10 	vmov.32	r4, d3[0]
1000616a:	f852 0020 	ldr.w	r0, [r2, r0, lsl #2]
1000616e:	9037      	str	r0, [sp, #220]	@ 0xdc
10006170:	ee33 0b10 	vmov.32	r0, d3[1]
10006174:	ff2e 2446 	vshl.u32	q1, q3, q7
10006178:	f852 6026 	ldr.w	r6, [r2, r6, lsl #2]
1000617c:	ef26 6848 	vadd.i32	q3, q3, q4
10006180:	9630      	str	r6, [sp, #192]	@ 0xc0
10006182:	f852 5025 	ldr.w	r5, [r2, r5, lsl #2]
10006186:	ee12 6a10 	vmov	r6, s4
1000618a:	9531      	str	r5, [sp, #196]	@ 0xc4
1000618c:	f852 4024 	ldr.w	r4, [r2, r4, lsl #2]
10006190:	ee32 5b10 	vmov.32	r5, d2[1]
10006194:	9432      	str	r4, [sp, #200]	@ 0xc8
10006196:	f852 0020 	ldr.w	r0, [r2, r0, lsl #2]
1000619a:	ee13 4b10 	vmov.32	r4, d3[0]
1000619e:	9033      	str	r0, [sp, #204]	@ 0xcc
100061a0:	ee33 0b10 	vmov.32	r0, d3[1]
100061a4:	ed9d 3f34 	vldrw.u32	q1, [sp, #208]
100061a8:	ef02 2154 	vand	q1, q1, q2
100061ac:	ed9d 5f00 	vldrw.u32	q2, [sp, #0]
100061b0:	ef24 4152 	vorr	q2, q2, q1
100061b4:	f852 6026 	ldr.w	r6, [r2, r6, lsl #2]
100061b8:	ed8d 7f0c 	vstrw.32	q3, [sp, #48]
100061bc:	962c      	str	r6, [sp, #176]	@ 0xb0
100061be:	f852 5025 	ldr.w	r5, [r2, r5, lsl #2]
100061c2:	952d      	str	r5, [sp, #180]	@ 0xb4
100061c4:	f852 4024 	ldr.w	r4, [r2, r4, lsl #2]
100061c8:	942e      	str	r4, [sp, #184]	@ 0xb8
100061ca:	f852 0020 	ldr.w	r0, [r2, r0, lsl #2]
100061ce:	902f      	str	r0, [sp, #188]	@ 0xbc
100061d0:	ed8d 5f00 	vstrw.32	q2, [sp, #0]
100061d4:	ed9d 7f10 	vldrw.u32	q3, [sp, #64]
100061d8:	ed9d 5f30 	vldrw.u32	q2, [sp, #192]
100061dc:	ef04 4156 	vand	q2, q2, q3
100061e0:	ed9d 7f04 	vldrw.u32	q3, [sp, #16]
100061e4:	ef26 6154 	vorr	q3, q3, q2
100061e8:	ed8d 7f04 	vstrw.32	q3, [sp, #16]
100061ec:	ed9d 7f2c 	vldrw.u32	q3, [sp, #176]
100061f0:	ed9d 5f08 	vldrw.u32	q2, [sp, #32]
100061f4:	ef06 6150 	vand	q3, q3, q0
100061f8:	ef24 6156 	vorr	q3, q2, q3
100061fc:	ed8d 7f08 	vstrw.32	q3, [sp, #32]
10006200:	f00f c095 	le	lr, 100060dc <fndsa_poly_big_to_fp64_exact+0xfc>
10006204:	ed9d 7f00 	vldrw.u32	q3, [sp, #0]
10006208:	ed9d 5f04 	vldrw.u32	q2, [sp, #16]
1000620c:	ee37 0b10 	vmov.32	r0, d7[1]
10006210:	ee16 6a10 	vmov	r6, s12
10006214:	ee36 5b10 	vmov.32	r5, d6[1]
10006218:	4306      	orrs	r6, r0
1000621a:	ee14 0a10 	vmov	r0, s8
1000621e:	ee34 cb10 	vmov.32	ip, d4[1]
10006222:	4305      	orrs	r5, r0
10006224:	ee17 0b10 	vmov.32	r0, d7[0]
10006228:	ea40 000c 	orr.w	r0, r0, ip
1000622c:	ee15 cb10 	vmov.32	ip, d5[0]
10006230:	ed9d 7f08 	vldrw.u32	q3, [sp, #32]
10006234:	ea46 060c 	orr.w	r6, r6, ip
10006238:	ee35 cb10 	vmov.32	ip, d5[1]
1000623c:	ea45 050c 	orr.w	r5, r5, ip
10006240:	ee16 ca10 	vmov	ip, s12
10006244:	ea40 000c 	orr.w	r0, r0, ip
10006248:	ee36 cb10 	vmov.32	ip, d6[1]
1000624c:	ea46 060c 	orr.w	r6, r6, ip
10006250:	ee17 cb10 	vmov.32	ip, d7[0]
10006254:	ea45 050c 	orr.w	r5, r5, ip
10006258:	ee37 cb10 	vmov.32	ip, d7[1]
1000625c:	079c      	lsls	r4, r3, #30
1000625e:	ea40 000c 	orr.w	r0, r0, ip
10006262:	f000 80f1 	beq.w	10006448 <fndsa_poly_big_to_fp64_exact+0x468>
10006266:	f023 0c03 	bic.w	ip, r3, #3
1000626a:	e031      	b.n	100062d0 <fndsa_poly_big_to_fp64_exact+0x2f0>
1000626c:	f3af 8000 	nop.w
10006270:	ffffffff 	.word	0xffffffff
10006274:	00000001 	.word	0x00000001
10006278:	00000000 	.word	0x00000000
1000627c:	ffffffff 	.word	0xffffffff
10006280:	00000000 	.word	0x00000000
10006284:	ffffffff 	.word	0xffffffff
10006288:	00000001 	.word	0x00000001
1000628c:	00000000 	.word	0x00000000
10006290:	00000001 	.word	0x00000001
10006294:	00000000 	.word	0x00000000
10006298:	ffffffff 	.word	0xffffffff
1000629c:	00000001 	.word	0x00000001
100062a0:	00000002 	.word	0x00000002
100062a4:	00000003 	.word	0x00000003
100062a8:	00000003 	.word	0x00000003
100062ac:	00000003 	.word	0x00000003
100062b0:	00000001 	.word	0x00000001
100062b4:	00000001 	.word	0x00000001
100062b8:	00000002 	.word	0x00000002
100062bc:	00000002 	.word	0x00000002
	...
100062cc:	00000001 	.word	0x00000001
100062d0:	9c2b      	ldr	r4, [sp, #172]	@ 0xac
100062d2:	fa0c fe07 	lsl.w	lr, ip, r7
100062d6:	f852 a02e 	ldr.w	sl, [r2, lr, lsl #2]
100062da:	ea84 0e0c 	eor.w	lr, r4, ip
100062de:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
100062e2:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
100062e6:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
100062ea:	ea40 000e 	orr.w	r0, r0, lr
100062ee:	ea88 0e0c 	eor.w	lr, r8, ip
100062f2:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
100062f6:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
100062fa:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
100062fe:	ea45 050e 	orr.w	r5, r5, lr
10006302:	ea89 0e0c 	eor.w	lr, r9, ip
10006306:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
1000630a:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
1000630e:	ea0a 7aee 	and.w	sl, sl, lr, asr #31
10006312:	f10c 0e01 	add.w	lr, ip, #1
10006316:	4573      	cmp	r3, lr
10006318:	ea46 060a 	orr.w	r6, r6, sl
1000631c:	f240 8094 	bls.w	10006448 <fndsa_poly_big_to_fp64_exact+0x468>
10006320:	fa0e fa07 	lsl.w	sl, lr, r7
10006324:	f852 b02a 	ldr.w	fp, [r2, sl, lsl #2]
10006328:	ea84 0a0e 	eor.w	sl, r4, lr
1000632c:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10006330:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10006334:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10006338:	ea40 000a 	orr.w	r0, r0, sl
1000633c:	ea88 0a0e 	eor.w	sl, r8, lr
10006340:	ea89 0e0e 	eor.w	lr, r9, lr
10006344:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10006348:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
1000634c:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10006350:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10006354:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10006358:	ea0b 7bee 	and.w	fp, fp, lr, asr #31
1000635c:	f10c 0e02 	add.w	lr, ip, #2
10006360:	4573      	cmp	r3, lr
10006362:	ea45 050a 	orr.w	r5, r5, sl
10006366:	ea46 060b 	orr.w	r6, r6, fp
1000636a:	d96d      	bls.n	10006448 <fndsa_poly_big_to_fp64_exact+0x468>
1000636c:	fa0e fa07 	lsl.w	sl, lr, r7
10006370:	f852 b02a 	ldr.w	fp, [r2, sl, lsl #2]
10006374:	ea84 0a0e 	eor.w	sl, r4, lr
10006378:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
1000637c:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10006380:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10006384:	ea40 000a 	orr.w	r0, r0, sl
10006388:	ea88 0a0e 	eor.w	sl, r8, lr
1000638c:	ea89 0e0e 	eor.w	lr, r9, lr
10006390:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10006394:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10006398:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
1000639c:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
100063a0:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
100063a4:	ea0b 7bee 	and.w	fp, fp, lr, asr #31
100063a8:	f10c 0e03 	add.w	lr, ip, #3
100063ac:	4573      	cmp	r3, lr
100063ae:	ea45 050a 	orr.w	r5, r5, sl
100063b2:	ea46 060b 	orr.w	r6, r6, fp
100063b6:	d947      	bls.n	10006448 <fndsa_poly_big_to_fp64_exact+0x468>
100063b8:	fa0e fa07 	lsl.w	sl, lr, r7
100063bc:	f852 b02a 	ldr.w	fp, [r2, sl, lsl #2]
100063c0:	ea84 0a0e 	eor.w	sl, r4, lr
100063c4:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
100063c8:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
100063cc:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
100063d0:	ea40 000a 	orr.w	r0, r0, sl
100063d4:	ea88 0a0e 	eor.w	sl, r8, lr
100063d8:	ea89 0e0e 	eor.w	lr, r9, lr
100063dc:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
100063e0:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
100063e4:	f10c 0c04 	add.w	ip, ip, #4
100063e8:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
100063ec:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
100063f0:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
100063f4:	4563      	cmp	r3, ip
100063f6:	ea0b 7bee 	and.w	fp, fp, lr, asr #31
100063fa:	ea45 050a 	orr.w	r5, r5, sl
100063fe:	ea46 060b 	orr.w	r6, r6, fp
10006402:	d921      	bls.n	10006448 <fndsa_poly_big_to_fp64_exact+0x468>
10006404:	fa0c fe07 	lsl.w	lr, ip, r7
10006408:	f852 a02e 	ldr.w	sl, [r2, lr, lsl #2]
1000640c:	ea84 0e0c 	eor.w	lr, r4, ip
10006410:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10006414:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10006418:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
1000641c:	ea40 000e 	orr.w	r0, r0, lr
10006420:	ea88 0e0c 	eor.w	lr, r8, ip
10006424:	ea89 0c0c 	eor.w	ip, r9, ip
10006428:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
1000642c:	f02c 4c7f 	bic.w	ip, ip, #4278190080	@ 0xff000000
10006430:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10006434:	f10c 3cff 	add.w	ip, ip, #4294967295	@ 0xffffffff
10006438:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
1000643c:	ea0a 7aec 	and.w	sl, sl, ip, asr #31
10006440:	ea45 050e 	orr.w	r5, r5, lr
10006444:	ea46 060a 	orr.w	r6, r6, sl
10006448:	9c20      	ldr	r4, [sp, #128]	@ 0x80
1000644a:	3204      	adds	r2, #4
1000644c:	f854 cf04 	ldr.w	ip, [r4, #4]!
10006450:	3110      	adds	r1, #16
10006452:	9420      	str	r4, [sp, #128]	@ 0x80
10006454:	ea4f 7c9c 	mov.w	ip, ip, lsr #30
10006458:	9c24      	ldr	r4, [sp, #144]	@ 0x90
1000645a:	f1cc 0c00 	rsb	ip, ip, #0
1000645e:	ea04 0e5c 	and.w	lr, r4, ip, lsr #1
10006462:	ea4e 0e06 	orr.w	lr, lr, r6
10006466:	ea4f 064e 	mov.w	r6, lr, lsl #1
1000646a:	9c28      	ldr	r4, [sp, #160]	@ 0xa0
1000646c:	f006 4600 	and.w	r6, r6, #2147483648	@ 0x80000000
10006470:	ea46 060e 	orr.w	r6, r6, lr
10006474:	40a6      	lsls	r6, r4
10006476:	9c23      	ldr	r4, [sp, #140]	@ 0x8c
10006478:	ea04 0e5c 	and.w	lr, r4, ip, lsr #1
1000647c:	9c22      	ldr	r4, [sp, #136]	@ 0x88
1000647e:	ea4e 0e05 	orr.w	lr, lr, r5
10006482:	ea04 0c5c 	and.w	ip, r4, ip, lsr #1
10006486:	ea4c 0c00 	orr.w	ip, ip, r0
1000648a:	9826      	ldr	r0, [sp, #152]	@ 0x98
1000648c:	fa2c fc00 	lsr.w	ip, ip, r0
10006490:	9827      	ldr	r0, [sp, #156]	@ 0x9c
10006492:	fa0e f000 	lsl.w	r0, lr, r0
10006496:	ea4c 0c00 	orr.w	ip, ip, r0
1000649a:	9825      	ldr	r0, [sp, #148]	@ 0x94
1000649c:	fa2e fe00 	lsr.w	lr, lr, r0
100064a0:	ea46 060e 	orr.w	r6, r6, lr
100064a4:	ee07 6a90 	vmov	s15, r6
100064a8:	eeb8 6b67 	vcvt.f64.u32	d6, s15
100064ac:	ee07 ca90 	vmov	s15, ip
100064b0:	eeb8 7b67 	vcvt.f64.u32	d7, s15
100064b4:	9829      	ldr	r0, [sp, #164]	@ 0xa4
100064b6:	ed01 6b04 	vstr	d6, [r1, #-16]
100064ba:	4282      	cmp	r2, r0
100064bc:	ed01 7b02 	vstr	d7, [r1, #-8]
100064c0:	f47f adef 	bne.w	100060a2 <fndsa_poly_big_to_fp64_exact+0xc2>
100064c4:	b039      	add	sp, #228	@ 0xe4
100064c6:	ecbd 8b10 	vpop	{d8-d15}
100064ca:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
100064ce:	f04f 0c00 	mov.w	ip, #0
100064d2:	4666      	mov	r6, ip
100064d4:	4665      	mov	r5, ip
100064d6:	4660      	mov	r0, ip
100064d8:	e6fa      	b.n	100062d0 <fndsa_poly_big_to_fp64_exact+0x2f0>
100064da:	2210      	movs	r2, #16
100064dc:	4619      	mov	r1, r3
100064de:	40ba      	lsls	r2, r7
100064e0:	b039      	add	sp, #228	@ 0xe4
100064e2:	ecbd 8b10 	vpop	{d8-d15}
100064e6:	e8bd 4ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
100064ea:	f00c bac1 	b.w	10012a70 <memset>
