
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_kat_exact/validation/build/kat/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10005fc8 <fndsa_poly_big_to_fp64_exact>:
10005fc8:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10005fcc:	ed2d 8b10 	vpush	{d8-d15}
10005fd0:	b0b9      	sub	sp, #228	@ 0xe4
10005fd2:	4607      	mov	r7, r0
10005fd4:	9d52      	ldr	r5, [sp, #328]	@ 0x148
10005fd6:	4608      	mov	r0, r1
10005fd8:	2b00      	cmp	r3, #0
10005fda:	f000 8272 	beq.w	100064c2 <fndsa_poly_big_to_fp64_exact+0x4fa>
10005fde:	eb05 1145 	add.w	r1, r5, r5, lsl #5
10005fe2:	eb01 2181 	add.w	r1, r1, r1, lsl #10
10005fe6:	eb05 0441 	add.w	r4, r5, r1, lsl #1
10005fea:	0d64      	lsrs	r4, r4, #21
10005fec:	4601      	mov	r1, r0
10005fee:	ebc4 1044 	rsb	r0, r4, r4, lsl #5
10005ff2:	1a2d      	subs	r5, r5, r0
10005ff4:	1e6e      	subs	r6, r5, #1
10005ff6:	eba4 78d6 	sub.w	r8, r4, r6, lsr #31
10005ffa:	eea6 8b10 	vdup.32	q3, r8
10005ffe:	ed9f 0b96 	vldr	d0, [pc, #600]	@ 10006258 <fndsa_poly_big_to_fp64_exact+0x290>
10006002:	ed9f 1b97 	vldr	d1, [pc, #604]	@ 10006260 <fndsa_poly_big_to_fp64_exact+0x298>
10006006:	ed9f 2b98 	vldr	d2, [pc, #608]	@ 10006268 <fndsa_poly_big_to_fp64_exact+0x2a0>
1000600a:	ed9f 3b99 	vldr	d3, [pc, #612]	@ 10006270 <fndsa_poly_big_to_fp64_exact+0x2a8>
1000600e:	ed9f 4b9a 	vldr	d4, [pc, #616]	@ 10006278 <fndsa_poly_big_to_fp64_exact+0x2b0>
10006012:	ed9f 5b9b 	vldr	d5, [pc, #620]	@ 10006280 <fndsa_poly_big_to_fp64_exact+0x2b8>
10006016:	ef26 0840 	vadd.i32	q0, q3, q0
1000601a:	ef26 2842 	vadd.i32	q1, q3, q1
1000601e:	ef26 6844 	vadd.i32	q3, q3, q2
10006022:	1b18      	subs	r0, r3, r4
10006024:	17f4      	asrs	r4, r6, #31
10006026:	f004 041f 	and.w	r4, r4, #31
1000602a:	eb00 70d6 	add.w	r0, r0, r6, lsr #31
1000602e:	ea44 0605 	orr.w	r6, r4, r5
10006032:	2404      	movs	r4, #4
10006034:	eeae 7b10 	vdup.32	q7, r7
10006038:	ed8d 1f14 	vstrw.32	q0, [sp, #80]
1000603c:	ed8d 3f18 	vstrw.32	q1, [sp, #96]
10006040:	ed8d 7f1c 	vstrw.32	q3, [sp, #112]
10006044:	1e5d      	subs	r5, r3, #1
10006046:	9521      	str	r5, [sp, #132]	@ 0x84
10006048:	1e45      	subs	r5, r0, #1
1000604a:	17ed      	asrs	r5, r5, #31
1000604c:	9523      	str	r5, [sp, #140]	@ 0x8c
1000604e:	40bc      	lsls	r4, r7
10006050:	1e85      	subs	r5, r0, #2
10006052:	17c0      	asrs	r0, r0, #31
10006054:	1914      	adds	r4, r2, r4
10006056:	9022      	str	r0, [sp, #136]	@ 0x88
10006058:	17e8      	asrs	r0, r5, #31
1000605a:	1e5d      	subs	r5, r3, #1
1000605c:	40bd      	lsls	r5, r7
1000605e:	9024      	str	r0, [sp, #144]	@ 0x90
10006060:	9429      	str	r4, [sp, #164]	@ 0xa4
10006062:	1f10      	subs	r0, r2, #4
10006064:	f1c6 0420 	rsb	r4, r6, #32
10006068:	eb00 0085 	add.w	r0, r0, r5, lsl #2
1000606c:	9427      	str	r4, [sp, #156]	@ 0x9c
1000606e:	f1c6 041f 	rsb	r4, r6, #31
10006072:	9020      	str	r0, [sp, #128]	@ 0x80
10006074:	1e75      	subs	r5, r6, #1
10006076:	f108 30ff 	add.w	r0, r8, #4294967295	@ 0xffffffff
1000607a:	9428      	str	r4, [sp, #160]	@ 0xa0
1000607c:	089c      	lsrs	r4, r3, #2
1000607e:	9625      	str	r6, [sp, #148]	@ 0x94
10006080:	f108 0901 	add.w	r9, r8, #1
10006084:	9526      	str	r5, [sp, #152]	@ 0x98
10006086:	942a      	str	r4, [sp, #168]	@ 0xa8
10006088:	902b      	str	r0, [sp, #172]	@ 0xac
1000608a:	9821      	ldr	r0, [sp, #132]	@ 0x84
1000608c:	2804      	cmp	r0, #4
1000608e:	f240 8212 	bls.w	100064b6 <fndsa_poly_big_to_fp64_exact+0x4ee>
10006092:	ef80 6050 	vmov.i32	q3, #0	@ 0x00000000
10006096:	ed9f 8b7c 	vldr	d8, [pc, #496]	@ 10006288 <fndsa_poly_big_to_fp64_exact+0x2c0>
1000609a:	ed9f 9b7d 	vldr	d9, [pc, #500]	@ 10006290 <fndsa_poly_big_to_fp64_exact+0x2c8>
1000609e:	982a      	ldr	r0, [sp, #168]	@ 0xa8
100060a0:	ed8d 7f08 	vstrw.32	q3, [sp, #32]
100060a4:	f040 e001 	dls	lr, r0
100060a8:	ed8d 7f04 	vstrw.32	q3, [sp, #16]
100060ac:	ed8d 7f00 	vstrw.32	q3, [sp, #0]
100060b0:	ed9f cb79 	vldr	d12, [pc, #484]	@ 10006298 <fndsa_poly_big_to_fp64_exact+0x2d0>
100060b4:	ed9f db7a 	vldr	d13, [pc, #488]	@ 100062a0 <fndsa_poly_big_to_fp64_exact+0x2d8>
100060b8:	ed9f ab7b 	vldr	d10, [pc, #492]	@ 100062a8 <fndsa_poly_big_to_fp64_exact+0x2e0>
100060bc:	ed9f bb7c 	vldr	d11, [pc, #496]	@ 100062b0 <fndsa_poly_big_to_fp64_exact+0x2e8>
100060c0:	ed8d 9f0c 	vstrw.32	q4, [sp, #48]
100060c4:	ff2e 644a 	vshl.u32	q3, q5, q7
100060c8:	ee16 6a10 	vmov	r6, s12
100060cc:	ee36 5b10 	vmov.32	r5, d6[1]
100060d0:	ee17 4b10 	vmov.32	r4, d7[0]
100060d4:	ee37 0b10 	vmov.32	r0, d7[1]
100060d8:	ed9d 7f1c 	vldrw.u32	q3, [sp, #112]
100060dc:	ed9d 1f18 	vldrw.u32	q0, [sp, #96]
100060e0:	ff0a 4156 	veor	q2, q5, q3
100060e4:	ef80 6054 	vmov.i32	q3, #4	@ 0x00000004
100060e8:	ef26 8156 	vmov	q4, q3
100060ec:	ef2a a846 	vadd.i32	q5, q5, q3
100060f0:	ff0c 6150 	veor	q3, q6, q0
100060f4:	ff87 2e5f 	vmov.i8	q1, #255	@ 0xff
100060f8:	ff87 677f 	vbic.i32	q3, #4278190080	@ 0xff000000
100060fc:	ef26 6842 	vadd.i32	q3, q3, q1
10006100:	efa1 6056 	vshr.s32	q3, q3, #31
10006104:	ed9d 1f14 	vldrw.u32	q0, [sp, #80]
10006108:	ed8d 7f10 	vstrw.32	q3, [sp, #64]
1000610c:	ed9d 7f0c 	vldrw.u32	q3, [sp, #48]
10006110:	ff06 0150 	veor	q0, q3, q0
10006114:	ff87 477f 	vbic.i32	q2, #4278190080	@ 0xff000000
10006118:	ff87 077f 	vbic.i32	q0, #4278190080	@ 0xff000000
1000611c:	ef24 4842 	vadd.i32	q2, q2, q1
10006120:	ef20 0842 	vadd.i32	q0, q0, q1
10006124:	ff2e 244c 	vshl.u32	q1, q6, q7
10006128:	f852 6026 	ldr.w	r6, [r2, r6, lsl #2]
1000612c:	efa1 4054 	vshr.s32	q2, q2, #31
10006130:	9634      	str	r6, [sp, #208]	@ 0xd0
10006132:	ee12 6a10 	vmov	r6, s4
10006136:	f852 5025 	ldr.w	r5, [r2, r5, lsl #2]
1000613a:	efa1 0050 	vshr.s32	q0, q0, #31
1000613e:	9535      	str	r5, [sp, #212]	@ 0xd4
10006140:	ee32 5b10 	vmov.32	r5, d2[1]
10006144:	f852 4024 	ldr.w	r4, [r2, r4, lsl #2]
10006148:	ef2c c848 	vadd.i32	q6, q6, q4
1000614c:	9436      	str	r4, [sp, #216]	@ 0xd8
1000614e:	ee13 4b10 	vmov.32	r4, d3[0]
10006152:	f852 0020 	ldr.w	r0, [r2, r0, lsl #2]
10006156:	9037      	str	r0, [sp, #220]	@ 0xdc
10006158:	ee33 0b10 	vmov.32	r0, d3[1]
1000615c:	ff2e 2446 	vshl.u32	q1, q3, q7
10006160:	f852 6026 	ldr.w	r6, [r2, r6, lsl #2]
10006164:	ef26 6848 	vadd.i32	q3, q3, q4
10006168:	9630      	str	r6, [sp, #192]	@ 0xc0
1000616a:	f852 5025 	ldr.w	r5, [r2, r5, lsl #2]
1000616e:	ee12 6a10 	vmov	r6, s4
10006172:	9531      	str	r5, [sp, #196]	@ 0xc4
10006174:	f852 4024 	ldr.w	r4, [r2, r4, lsl #2]
10006178:	ee32 5b10 	vmov.32	r5, d2[1]
1000617c:	9432      	str	r4, [sp, #200]	@ 0xc8
1000617e:	f852 0020 	ldr.w	r0, [r2, r0, lsl #2]
10006182:	ee13 4b10 	vmov.32	r4, d3[0]
10006186:	9033      	str	r0, [sp, #204]	@ 0xcc
10006188:	ee33 0b10 	vmov.32	r0, d3[1]
1000618c:	ed9d 3f34 	vldrw.u32	q1, [sp, #208]
10006190:	ef02 2154 	vand	q1, q1, q2
10006194:	ed9d 5f00 	vldrw.u32	q2, [sp, #0]
10006198:	ef24 4152 	vorr	q2, q2, q1
1000619c:	f852 6026 	ldr.w	r6, [r2, r6, lsl #2]
100061a0:	ed8d 7f0c 	vstrw.32	q3, [sp, #48]
100061a4:	962c      	str	r6, [sp, #176]	@ 0xb0
100061a6:	f852 5025 	ldr.w	r5, [r2, r5, lsl #2]
100061aa:	952d      	str	r5, [sp, #180]	@ 0xb4
100061ac:	f852 4024 	ldr.w	r4, [r2, r4, lsl #2]
100061b0:	942e      	str	r4, [sp, #184]	@ 0xb8
100061b2:	f852 0020 	ldr.w	r0, [r2, r0, lsl #2]
100061b6:	902f      	str	r0, [sp, #188]	@ 0xbc
100061b8:	ed8d 5f00 	vstrw.32	q2, [sp, #0]
100061bc:	ed9d 7f10 	vldrw.u32	q3, [sp, #64]
100061c0:	ed9d 5f30 	vldrw.u32	q2, [sp, #192]
100061c4:	ef04 4156 	vand	q2, q2, q3
100061c8:	ed9d 7f04 	vldrw.u32	q3, [sp, #16]
100061cc:	ef26 6154 	vorr	q3, q3, q2
100061d0:	ed8d 7f04 	vstrw.32	q3, [sp, #16]
100061d4:	ed9d 7f2c 	vldrw.u32	q3, [sp, #176]
100061d8:	ed9d 5f08 	vldrw.u32	q2, [sp, #32]
100061dc:	ef06 6150 	vand	q3, q3, q0
100061e0:	ef24 6156 	vorr	q3, q2, q3
100061e4:	ed8d 7f08 	vstrw.32	q3, [sp, #32]
100061e8:	f00f c095 	le	lr, 100060c4 <fndsa_poly_big_to_fp64_exact+0xfc>
100061ec:	ed9d 7f00 	vldrw.u32	q3, [sp, #0]
100061f0:	ed9d 5f04 	vldrw.u32	q2, [sp, #16]
100061f4:	ee37 0b10 	vmov.32	r0, d7[1]
100061f8:	ee16 6a10 	vmov	r6, s12
100061fc:	ee36 5b10 	vmov.32	r5, d6[1]
10006200:	4306      	orrs	r6, r0
10006202:	ee14 0a10 	vmov	r0, s8
10006206:	ee34 cb10 	vmov.32	ip, d4[1]
1000620a:	4305      	orrs	r5, r0
1000620c:	ee17 0b10 	vmov.32	r0, d7[0]
10006210:	ea40 000c 	orr.w	r0, r0, ip
10006214:	ee15 cb10 	vmov.32	ip, d5[0]
10006218:	ed9d 7f08 	vldrw.u32	q3, [sp, #32]
1000621c:	ea46 060c 	orr.w	r6, r6, ip
10006220:	ee35 cb10 	vmov.32	ip, d5[1]
10006224:	ea45 050c 	orr.w	r5, r5, ip
10006228:	ee16 ca10 	vmov	ip, s12
1000622c:	ea40 000c 	orr.w	r0, r0, ip
10006230:	ee36 cb10 	vmov.32	ip, d6[1]
10006234:	ea46 060c 	orr.w	r6, r6, ip
10006238:	ee17 cb10 	vmov.32	ip, d7[0]
1000623c:	ea45 050c 	orr.w	r5, r5, ip
10006240:	ee37 cb10 	vmov.32	ip, d7[1]
10006244:	079c      	lsls	r4, r3, #30
10006246:	ea40 000c 	orr.w	r0, r0, ip
1000624a:	f000 80f1 	beq.w	10006430 <fndsa_poly_big_to_fp64_exact+0x468>
1000624e:	f023 0c03 	bic.w	ip, r3, #3
10006252:	e031      	b.n	100062b8 <fndsa_poly_big_to_fp64_exact+0x2f0>
10006254:	f3af 8000 	nop.w
10006258:	ffffffff 	.word	0xffffffff
1000625c:	00000001 	.word	0x00000001
10006260:	00000000 	.word	0x00000000
10006264:	ffffffff 	.word	0xffffffff
10006268:	00000000 	.word	0x00000000
1000626c:	ffffffff 	.word	0xffffffff
10006270:	00000001 	.word	0x00000001
10006274:	00000000 	.word	0x00000000
10006278:	00000001 	.word	0x00000001
1000627c:	00000000 	.word	0x00000000
10006280:	ffffffff 	.word	0xffffffff
10006284:	00000001 	.word	0x00000001
10006288:	00000002 	.word	0x00000002
1000628c:	00000003 	.word	0x00000003
10006290:	00000003 	.word	0x00000003
10006294:	00000003 	.word	0x00000003
10006298:	00000001 	.word	0x00000001
1000629c:	00000001 	.word	0x00000001
100062a0:	00000002 	.word	0x00000002
100062a4:	00000002 	.word	0x00000002
	...
100062b4:	00000001 	.word	0x00000001
100062b8:	9c2b      	ldr	r4, [sp, #172]	@ 0xac
100062ba:	fa0c fe07 	lsl.w	lr, ip, r7
100062be:	f852 a02e 	ldr.w	sl, [r2, lr, lsl #2]
100062c2:	ea84 0e0c 	eor.w	lr, r4, ip
100062c6:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
100062ca:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
100062ce:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
100062d2:	ea40 000e 	orr.w	r0, r0, lr
100062d6:	ea88 0e0c 	eor.w	lr, r8, ip
100062da:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
100062de:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
100062e2:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
100062e6:	ea45 050e 	orr.w	r5, r5, lr
100062ea:	ea89 0e0c 	eor.w	lr, r9, ip
100062ee:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
100062f2:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
100062f6:	ea0a 7aee 	and.w	sl, sl, lr, asr #31
100062fa:	f10c 0e01 	add.w	lr, ip, #1
100062fe:	4573      	cmp	r3, lr
10006300:	ea46 060a 	orr.w	r6, r6, sl
10006304:	f240 8094 	bls.w	10006430 <fndsa_poly_big_to_fp64_exact+0x468>
10006308:	fa0e fa07 	lsl.w	sl, lr, r7
1000630c:	f852 b02a 	ldr.w	fp, [r2, sl, lsl #2]
10006310:	ea84 0a0e 	eor.w	sl, r4, lr
10006314:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10006318:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
1000631c:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10006320:	ea40 000a 	orr.w	r0, r0, sl
10006324:	ea88 0a0e 	eor.w	sl, r8, lr
10006328:	ea89 0e0e 	eor.w	lr, r9, lr
1000632c:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10006330:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10006334:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10006338:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
1000633c:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10006340:	ea0b 7bee 	and.w	fp, fp, lr, asr #31
10006344:	f10c 0e02 	add.w	lr, ip, #2
10006348:	4573      	cmp	r3, lr
1000634a:	ea45 050a 	orr.w	r5, r5, sl
1000634e:	ea46 060b 	orr.w	r6, r6, fp
10006352:	d96d      	bls.n	10006430 <fndsa_poly_big_to_fp64_exact+0x468>
10006354:	fa0e fa07 	lsl.w	sl, lr, r7
10006358:	f852 b02a 	ldr.w	fp, [r2, sl, lsl #2]
1000635c:	ea84 0a0e 	eor.w	sl, r4, lr
10006360:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10006364:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10006368:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
1000636c:	ea40 000a 	orr.w	r0, r0, sl
10006370:	ea88 0a0e 	eor.w	sl, r8, lr
10006374:	ea89 0e0e 	eor.w	lr, r9, lr
10006378:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
1000637c:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10006380:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10006384:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10006388:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
1000638c:	ea0b 7bee 	and.w	fp, fp, lr, asr #31
10006390:	f10c 0e03 	add.w	lr, ip, #3
10006394:	4573      	cmp	r3, lr
10006396:	ea45 050a 	orr.w	r5, r5, sl
1000639a:	ea46 060b 	orr.w	r6, r6, fp
1000639e:	d947      	bls.n	10006430 <fndsa_poly_big_to_fp64_exact+0x468>
100063a0:	fa0e fa07 	lsl.w	sl, lr, r7
100063a4:	f852 b02a 	ldr.w	fp, [r2, sl, lsl #2]
100063a8:	ea84 0a0e 	eor.w	sl, r4, lr
100063ac:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
100063b0:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
100063b4:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
100063b8:	ea40 000a 	orr.w	r0, r0, sl
100063bc:	ea88 0a0e 	eor.w	sl, r8, lr
100063c0:	ea89 0e0e 	eor.w	lr, r9, lr
100063c4:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
100063c8:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
100063cc:	f10c 0c04 	add.w	ip, ip, #4
100063d0:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
100063d4:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
100063d8:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
100063dc:	4563      	cmp	r3, ip
100063de:	ea0b 7bee 	and.w	fp, fp, lr, asr #31
100063e2:	ea45 050a 	orr.w	r5, r5, sl
100063e6:	ea46 060b 	orr.w	r6, r6, fp
100063ea:	d921      	bls.n	10006430 <fndsa_poly_big_to_fp64_exact+0x468>
100063ec:	fa0c fe07 	lsl.w	lr, ip, r7
100063f0:	f852 a02e 	ldr.w	sl, [r2, lr, lsl #2]
100063f4:	ea84 0e0c 	eor.w	lr, r4, ip
100063f8:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
100063fc:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10006400:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
10006404:	ea40 000e 	orr.w	r0, r0, lr
10006408:	ea88 0e0c 	eor.w	lr, r8, ip
1000640c:	ea89 0c0c 	eor.w	ip, r9, ip
10006410:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10006414:	f02c 4c7f 	bic.w	ip, ip, #4278190080	@ 0xff000000
10006418:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
1000641c:	f10c 3cff 	add.w	ip, ip, #4294967295	@ 0xffffffff
10006420:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
10006424:	ea0a 7aec 	and.w	sl, sl, ip, asr #31
10006428:	ea45 050e 	orr.w	r5, r5, lr
1000642c:	ea46 060a 	orr.w	r6, r6, sl
10006430:	9c20      	ldr	r4, [sp, #128]	@ 0x80
10006432:	3204      	adds	r2, #4
10006434:	f854 cf04 	ldr.w	ip, [r4, #4]!
10006438:	3110      	adds	r1, #16
1000643a:	9420      	str	r4, [sp, #128]	@ 0x80
1000643c:	ea4f 7c9c 	mov.w	ip, ip, lsr #30
10006440:	9c24      	ldr	r4, [sp, #144]	@ 0x90
10006442:	f1cc 0c00 	rsb	ip, ip, #0
10006446:	ea04 0e5c 	and.w	lr, r4, ip, lsr #1
1000644a:	ea4e 0e06 	orr.w	lr, lr, r6
1000644e:	ea4f 064e 	mov.w	r6, lr, lsl #1
10006452:	9c28      	ldr	r4, [sp, #160]	@ 0xa0
10006454:	f006 4600 	and.w	r6, r6, #2147483648	@ 0x80000000
10006458:	ea46 060e 	orr.w	r6, r6, lr
1000645c:	40a6      	lsls	r6, r4
1000645e:	9c23      	ldr	r4, [sp, #140]	@ 0x8c
10006460:	ea04 0e5c 	and.w	lr, r4, ip, lsr #1
10006464:	9c22      	ldr	r4, [sp, #136]	@ 0x88
10006466:	ea4e 0e05 	orr.w	lr, lr, r5
1000646a:	ea04 0c5c 	and.w	ip, r4, ip, lsr #1
1000646e:	ea4c 0c00 	orr.w	ip, ip, r0
10006472:	9826      	ldr	r0, [sp, #152]	@ 0x98
10006474:	fa2c fc00 	lsr.w	ip, ip, r0
10006478:	9827      	ldr	r0, [sp, #156]	@ 0x9c
1000647a:	fa0e f000 	lsl.w	r0, lr, r0
1000647e:	ea4c 0c00 	orr.w	ip, ip, r0
10006482:	9825      	ldr	r0, [sp, #148]	@ 0x94
10006484:	fa2e fe00 	lsr.w	lr, lr, r0
10006488:	ea46 060e 	orr.w	r6, r6, lr
1000648c:	ee07 6a90 	vmov	s15, r6
10006490:	eeb8 6b67 	vcvt.f64.u32	d6, s15
10006494:	ee07 ca90 	vmov	s15, ip
10006498:	eeb8 7b67 	vcvt.f64.u32	d7, s15
1000649c:	9829      	ldr	r0, [sp, #164]	@ 0xa4
1000649e:	ed01 6b04 	vstr	d6, [r1, #-16]
100064a2:	4282      	cmp	r2, r0
100064a4:	ed01 7b02 	vstr	d7, [r1, #-8]
100064a8:	f47f adef 	bne.w	1000608a <fndsa_poly_big_to_fp64_exact+0xc2>
100064ac:	b039      	add	sp, #228	@ 0xe4
100064ae:	ecbd 8b10 	vpop	{d8-d15}
100064b2:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
100064b6:	f04f 0c00 	mov.w	ip, #0
100064ba:	4666      	mov	r6, ip
100064bc:	4665      	mov	r5, ip
100064be:	4660      	mov	r0, ip
100064c0:	e6fa      	b.n	100062b8 <fndsa_poly_big_to_fp64_exact+0x2f0>
100064c2:	2210      	movs	r2, #16
100064c4:	4619      	mov	r1, r3
100064c6:	40ba      	lsls	r2, r7
100064c8:	b039      	add	sp, #228	@ 0xe4
100064ca:	ecbd 8b10 	vpop	{d8-d15}
100064ce:	e8bd 4ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
100064d2:	f00c bac1 	b.w	10012a58 <memset>
