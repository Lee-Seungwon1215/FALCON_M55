
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_kat_exact_inlineasm/validation/build/kat/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10005df8 <fndsa_poly_big_to_fp64_exact>:
10005df8:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10005dfc:	ed2d 8b10 	vpush	{d8-d15}
10005e00:	b0b9      	sub	sp, #228	@ 0xe4
10005e02:	4607      	mov	r7, r0
10005e04:	9d52      	ldr	r5, [sp, #328]	@ 0x148
10005e06:	4608      	mov	r0, r1
10005e08:	2b00      	cmp	r3, #0
10005e0a:	f000 8272 	beq.w	100062f2 <fndsa_poly_big_to_fp64_exact+0x4fa>
10005e0e:	eb05 1145 	add.w	r1, r5, r5, lsl #5
10005e12:	eb01 2181 	add.w	r1, r1, r1, lsl #10
10005e16:	eb05 0441 	add.w	r4, r5, r1, lsl #1
10005e1a:	0d64      	lsrs	r4, r4, #21
10005e1c:	4601      	mov	r1, r0
10005e1e:	ebc4 1044 	rsb	r0, r4, r4, lsl #5
10005e22:	1a2d      	subs	r5, r5, r0
10005e24:	1e6e      	subs	r6, r5, #1
10005e26:	eba4 78d6 	sub.w	r8, r4, r6, lsr #31
10005e2a:	eea6 8b10 	vdup.32	q3, r8
10005e2e:	ed9f 0b96 	vldr	d0, [pc, #600]	@ 10006088 <fndsa_poly_big_to_fp64_exact+0x290>
10005e32:	ed9f 1b97 	vldr	d1, [pc, #604]	@ 10006090 <fndsa_poly_big_to_fp64_exact+0x298>
10005e36:	ed9f 2b98 	vldr	d2, [pc, #608]	@ 10006098 <fndsa_poly_big_to_fp64_exact+0x2a0>
10005e3a:	ed9f 3b99 	vldr	d3, [pc, #612]	@ 100060a0 <fndsa_poly_big_to_fp64_exact+0x2a8>
10005e3e:	ed9f 4b9a 	vldr	d4, [pc, #616]	@ 100060a8 <fndsa_poly_big_to_fp64_exact+0x2b0>
10005e42:	ed9f 5b9b 	vldr	d5, [pc, #620]	@ 100060b0 <fndsa_poly_big_to_fp64_exact+0x2b8>
10005e46:	ef26 0840 	vadd.i32	q0, q3, q0
10005e4a:	ef26 2842 	vadd.i32	q1, q3, q1
10005e4e:	ef26 6844 	vadd.i32	q3, q3, q2
10005e52:	1b18      	subs	r0, r3, r4
10005e54:	17f4      	asrs	r4, r6, #31
10005e56:	f004 041f 	and.w	r4, r4, #31
10005e5a:	eb00 70d6 	add.w	r0, r0, r6, lsr #31
10005e5e:	ea44 0605 	orr.w	r6, r4, r5
10005e62:	2404      	movs	r4, #4
10005e64:	eeae 7b10 	vdup.32	q7, r7
10005e68:	ed8d 1f14 	vstrw.32	q0, [sp, #80]
10005e6c:	ed8d 3f18 	vstrw.32	q1, [sp, #96]
10005e70:	ed8d 7f1c 	vstrw.32	q3, [sp, #112]
10005e74:	1e5d      	subs	r5, r3, #1
10005e76:	9521      	str	r5, [sp, #132]	@ 0x84
10005e78:	1e45      	subs	r5, r0, #1
10005e7a:	17ed      	asrs	r5, r5, #31
10005e7c:	9523      	str	r5, [sp, #140]	@ 0x8c
10005e7e:	40bc      	lsls	r4, r7
10005e80:	1e85      	subs	r5, r0, #2
10005e82:	17c0      	asrs	r0, r0, #31
10005e84:	1914      	adds	r4, r2, r4
10005e86:	9022      	str	r0, [sp, #136]	@ 0x88
10005e88:	17e8      	asrs	r0, r5, #31
10005e8a:	1e5d      	subs	r5, r3, #1
10005e8c:	40bd      	lsls	r5, r7
10005e8e:	9024      	str	r0, [sp, #144]	@ 0x90
10005e90:	9429      	str	r4, [sp, #164]	@ 0xa4
10005e92:	1f10      	subs	r0, r2, #4
10005e94:	f1c6 0420 	rsb	r4, r6, #32
10005e98:	eb00 0085 	add.w	r0, r0, r5, lsl #2
10005e9c:	9427      	str	r4, [sp, #156]	@ 0x9c
10005e9e:	f1c6 041f 	rsb	r4, r6, #31
10005ea2:	9020      	str	r0, [sp, #128]	@ 0x80
10005ea4:	1e75      	subs	r5, r6, #1
10005ea6:	f108 30ff 	add.w	r0, r8, #4294967295	@ 0xffffffff
10005eaa:	9428      	str	r4, [sp, #160]	@ 0xa0
10005eac:	089c      	lsrs	r4, r3, #2
10005eae:	9625      	str	r6, [sp, #148]	@ 0x94
10005eb0:	f108 0901 	add.w	r9, r8, #1
10005eb4:	9526      	str	r5, [sp, #152]	@ 0x98
10005eb6:	942a      	str	r4, [sp, #168]	@ 0xa8
10005eb8:	902b      	str	r0, [sp, #172]	@ 0xac
10005eba:	9821      	ldr	r0, [sp, #132]	@ 0x84
10005ebc:	2804      	cmp	r0, #4
10005ebe:	f240 8212 	bls.w	100062e6 <fndsa_poly_big_to_fp64_exact+0x4ee>
10005ec2:	ef80 6050 	vmov.i32	q3, #0	@ 0x00000000
10005ec6:	ed9f 8b7c 	vldr	d8, [pc, #496]	@ 100060b8 <fndsa_poly_big_to_fp64_exact+0x2c0>
10005eca:	ed9f 9b7d 	vldr	d9, [pc, #500]	@ 100060c0 <fndsa_poly_big_to_fp64_exact+0x2c8>
10005ece:	982a      	ldr	r0, [sp, #168]	@ 0xa8
10005ed0:	ed8d 7f08 	vstrw.32	q3, [sp, #32]
10005ed4:	f040 e001 	dls	lr, r0
10005ed8:	ed8d 7f04 	vstrw.32	q3, [sp, #16]
10005edc:	ed8d 7f00 	vstrw.32	q3, [sp, #0]
10005ee0:	ed9f cb79 	vldr	d12, [pc, #484]	@ 100060c8 <fndsa_poly_big_to_fp64_exact+0x2d0>
10005ee4:	ed9f db7a 	vldr	d13, [pc, #488]	@ 100060d0 <fndsa_poly_big_to_fp64_exact+0x2d8>
10005ee8:	ed9f ab7b 	vldr	d10, [pc, #492]	@ 100060d8 <fndsa_poly_big_to_fp64_exact+0x2e0>
10005eec:	ed9f bb7c 	vldr	d11, [pc, #496]	@ 100060e0 <fndsa_poly_big_to_fp64_exact+0x2e8>
10005ef0:	ed8d 9f0c 	vstrw.32	q4, [sp, #48]
10005ef4:	ff2e 644a 	vshl.u32	q3, q5, q7
10005ef8:	ee16 6a10 	vmov	r6, s12
10005efc:	ee36 5b10 	vmov.32	r5, d6[1]
10005f00:	ee17 4b10 	vmov.32	r4, d7[0]
10005f04:	ee37 0b10 	vmov.32	r0, d7[1]
10005f08:	ed9d 7f1c 	vldrw.u32	q3, [sp, #112]
10005f0c:	ed9d 1f18 	vldrw.u32	q0, [sp, #96]
10005f10:	ff0a 4156 	veor	q2, q5, q3
10005f14:	ef80 6054 	vmov.i32	q3, #4	@ 0x00000004
10005f18:	ef26 8156 	vmov	q4, q3
10005f1c:	ef2a a846 	vadd.i32	q5, q5, q3
10005f20:	ff0c 6150 	veor	q3, q6, q0
10005f24:	ff87 2e5f 	vmov.i8	q1, #255	@ 0xff
10005f28:	ff87 677f 	vbic.i32	q3, #4278190080	@ 0xff000000
10005f2c:	ef26 6842 	vadd.i32	q3, q3, q1
10005f30:	efa1 6056 	vshr.s32	q3, q3, #31
10005f34:	ed9d 1f14 	vldrw.u32	q0, [sp, #80]
10005f38:	ed8d 7f10 	vstrw.32	q3, [sp, #64]
10005f3c:	ed9d 7f0c 	vldrw.u32	q3, [sp, #48]
10005f40:	ff06 0150 	veor	q0, q3, q0
10005f44:	ff87 477f 	vbic.i32	q2, #4278190080	@ 0xff000000
10005f48:	ff87 077f 	vbic.i32	q0, #4278190080	@ 0xff000000
10005f4c:	ef24 4842 	vadd.i32	q2, q2, q1
10005f50:	ef20 0842 	vadd.i32	q0, q0, q1
10005f54:	ff2e 244c 	vshl.u32	q1, q6, q7
10005f58:	f852 6026 	ldr.w	r6, [r2, r6, lsl #2]
10005f5c:	efa1 4054 	vshr.s32	q2, q2, #31
10005f60:	9634      	str	r6, [sp, #208]	@ 0xd0
10005f62:	ee12 6a10 	vmov	r6, s4
10005f66:	f852 5025 	ldr.w	r5, [r2, r5, lsl #2]
10005f6a:	efa1 0050 	vshr.s32	q0, q0, #31
10005f6e:	9535      	str	r5, [sp, #212]	@ 0xd4
10005f70:	ee32 5b10 	vmov.32	r5, d2[1]
10005f74:	f852 4024 	ldr.w	r4, [r2, r4, lsl #2]
10005f78:	ef2c c848 	vadd.i32	q6, q6, q4
10005f7c:	9436      	str	r4, [sp, #216]	@ 0xd8
10005f7e:	ee13 4b10 	vmov.32	r4, d3[0]
10005f82:	f852 0020 	ldr.w	r0, [r2, r0, lsl #2]
10005f86:	9037      	str	r0, [sp, #220]	@ 0xdc
10005f88:	ee33 0b10 	vmov.32	r0, d3[1]
10005f8c:	ff2e 2446 	vshl.u32	q1, q3, q7
10005f90:	f852 6026 	ldr.w	r6, [r2, r6, lsl #2]
10005f94:	ef26 6848 	vadd.i32	q3, q3, q4
10005f98:	9630      	str	r6, [sp, #192]	@ 0xc0
10005f9a:	f852 5025 	ldr.w	r5, [r2, r5, lsl #2]
10005f9e:	ee12 6a10 	vmov	r6, s4
10005fa2:	9531      	str	r5, [sp, #196]	@ 0xc4
10005fa4:	f852 4024 	ldr.w	r4, [r2, r4, lsl #2]
10005fa8:	ee32 5b10 	vmov.32	r5, d2[1]
10005fac:	9432      	str	r4, [sp, #200]	@ 0xc8
10005fae:	f852 0020 	ldr.w	r0, [r2, r0, lsl #2]
10005fb2:	ee13 4b10 	vmov.32	r4, d3[0]
10005fb6:	9033      	str	r0, [sp, #204]	@ 0xcc
10005fb8:	ee33 0b10 	vmov.32	r0, d3[1]
10005fbc:	ed9d 3f34 	vldrw.u32	q1, [sp, #208]
10005fc0:	ef02 2154 	vand	q1, q1, q2
10005fc4:	ed9d 5f00 	vldrw.u32	q2, [sp, #0]
10005fc8:	ef24 4152 	vorr	q2, q2, q1
10005fcc:	f852 6026 	ldr.w	r6, [r2, r6, lsl #2]
10005fd0:	ed8d 7f0c 	vstrw.32	q3, [sp, #48]
10005fd4:	962c      	str	r6, [sp, #176]	@ 0xb0
10005fd6:	f852 5025 	ldr.w	r5, [r2, r5, lsl #2]
10005fda:	952d      	str	r5, [sp, #180]	@ 0xb4
10005fdc:	f852 4024 	ldr.w	r4, [r2, r4, lsl #2]
10005fe0:	942e      	str	r4, [sp, #184]	@ 0xb8
10005fe2:	f852 0020 	ldr.w	r0, [r2, r0, lsl #2]
10005fe6:	902f      	str	r0, [sp, #188]	@ 0xbc
10005fe8:	ed8d 5f00 	vstrw.32	q2, [sp, #0]
10005fec:	ed9d 7f10 	vldrw.u32	q3, [sp, #64]
10005ff0:	ed9d 5f30 	vldrw.u32	q2, [sp, #192]
10005ff4:	ef04 4156 	vand	q2, q2, q3
10005ff8:	ed9d 7f04 	vldrw.u32	q3, [sp, #16]
10005ffc:	ef26 6154 	vorr	q3, q3, q2
10006000:	ed8d 7f04 	vstrw.32	q3, [sp, #16]
10006004:	ed9d 7f2c 	vldrw.u32	q3, [sp, #176]
10006008:	ed9d 5f08 	vldrw.u32	q2, [sp, #32]
1000600c:	ef06 6150 	vand	q3, q3, q0
10006010:	ef24 6156 	vorr	q3, q2, q3
10006014:	ed8d 7f08 	vstrw.32	q3, [sp, #32]
10006018:	f00f c095 	le	lr, 10005ef4 <fndsa_poly_big_to_fp64_exact+0xfc>
1000601c:	ed9d 7f00 	vldrw.u32	q3, [sp, #0]
10006020:	ed9d 5f04 	vldrw.u32	q2, [sp, #16]
10006024:	ee37 0b10 	vmov.32	r0, d7[1]
10006028:	ee16 6a10 	vmov	r6, s12
1000602c:	ee36 5b10 	vmov.32	r5, d6[1]
10006030:	4306      	orrs	r6, r0
10006032:	ee14 0a10 	vmov	r0, s8
10006036:	ee34 cb10 	vmov.32	ip, d4[1]
1000603a:	4305      	orrs	r5, r0
1000603c:	ee17 0b10 	vmov.32	r0, d7[0]
10006040:	ea40 000c 	orr.w	r0, r0, ip
10006044:	ee15 cb10 	vmov.32	ip, d5[0]
10006048:	ed9d 7f08 	vldrw.u32	q3, [sp, #32]
1000604c:	ea46 060c 	orr.w	r6, r6, ip
10006050:	ee35 cb10 	vmov.32	ip, d5[1]
10006054:	ea45 050c 	orr.w	r5, r5, ip
10006058:	ee16 ca10 	vmov	ip, s12
1000605c:	ea40 000c 	orr.w	r0, r0, ip
10006060:	ee36 cb10 	vmov.32	ip, d6[1]
10006064:	ea46 060c 	orr.w	r6, r6, ip
10006068:	ee17 cb10 	vmov.32	ip, d7[0]
1000606c:	ea45 050c 	orr.w	r5, r5, ip
10006070:	ee37 cb10 	vmov.32	ip, d7[1]
10006074:	079c      	lsls	r4, r3, #30
10006076:	ea40 000c 	orr.w	r0, r0, ip
1000607a:	f000 80f1 	beq.w	10006260 <fndsa_poly_big_to_fp64_exact+0x468>
1000607e:	f023 0c03 	bic.w	ip, r3, #3
10006082:	e031      	b.n	100060e8 <fndsa_poly_big_to_fp64_exact+0x2f0>
10006084:	f3af 8000 	nop.w
10006088:	ffffffff 	.word	0xffffffff
1000608c:	00000001 	.word	0x00000001
10006090:	00000000 	.word	0x00000000
10006094:	ffffffff 	.word	0xffffffff
10006098:	00000000 	.word	0x00000000
1000609c:	ffffffff 	.word	0xffffffff
100060a0:	00000001 	.word	0x00000001
100060a4:	00000000 	.word	0x00000000
100060a8:	00000001 	.word	0x00000001
100060ac:	00000000 	.word	0x00000000
100060b0:	ffffffff 	.word	0xffffffff
100060b4:	00000001 	.word	0x00000001
100060b8:	00000002 	.word	0x00000002
100060bc:	00000003 	.word	0x00000003
100060c0:	00000003 	.word	0x00000003
100060c4:	00000003 	.word	0x00000003
100060c8:	00000001 	.word	0x00000001
100060cc:	00000001 	.word	0x00000001
100060d0:	00000002 	.word	0x00000002
100060d4:	00000002 	.word	0x00000002
	...
100060e4:	00000001 	.word	0x00000001
100060e8:	9c2b      	ldr	r4, [sp, #172]	@ 0xac
100060ea:	fa0c fe07 	lsl.w	lr, ip, r7
100060ee:	f852 a02e 	ldr.w	sl, [r2, lr, lsl #2]
100060f2:	ea84 0e0c 	eor.w	lr, r4, ip
100060f6:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
100060fa:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
100060fe:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
10006102:	ea40 000e 	orr.w	r0, r0, lr
10006106:	ea88 0e0c 	eor.w	lr, r8, ip
1000610a:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
1000610e:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10006112:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
10006116:	ea45 050e 	orr.w	r5, r5, lr
1000611a:	ea89 0e0c 	eor.w	lr, r9, ip
1000611e:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10006122:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10006126:	ea0a 7aee 	and.w	sl, sl, lr, asr #31
1000612a:	f10c 0e01 	add.w	lr, ip, #1
1000612e:	4573      	cmp	r3, lr
10006130:	ea46 060a 	orr.w	r6, r6, sl
10006134:	f240 8094 	bls.w	10006260 <fndsa_poly_big_to_fp64_exact+0x468>
10006138:	fa0e fa07 	lsl.w	sl, lr, r7
1000613c:	f852 b02a 	ldr.w	fp, [r2, sl, lsl #2]
10006140:	ea84 0a0e 	eor.w	sl, r4, lr
10006144:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10006148:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
1000614c:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10006150:	ea40 000a 	orr.w	r0, r0, sl
10006154:	ea88 0a0e 	eor.w	sl, r8, lr
10006158:	ea89 0e0e 	eor.w	lr, r9, lr
1000615c:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10006160:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10006164:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10006168:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
1000616c:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10006170:	ea0b 7bee 	and.w	fp, fp, lr, asr #31
10006174:	f10c 0e02 	add.w	lr, ip, #2
10006178:	4573      	cmp	r3, lr
1000617a:	ea45 050a 	orr.w	r5, r5, sl
1000617e:	ea46 060b 	orr.w	r6, r6, fp
10006182:	d96d      	bls.n	10006260 <fndsa_poly_big_to_fp64_exact+0x468>
10006184:	fa0e fa07 	lsl.w	sl, lr, r7
10006188:	f852 b02a 	ldr.w	fp, [r2, sl, lsl #2]
1000618c:	ea84 0a0e 	eor.w	sl, r4, lr
10006190:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10006194:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10006198:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
1000619c:	ea40 000a 	orr.w	r0, r0, sl
100061a0:	ea88 0a0e 	eor.w	sl, r8, lr
100061a4:	ea89 0e0e 	eor.w	lr, r9, lr
100061a8:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
100061ac:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
100061b0:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
100061b4:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
100061b8:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
100061bc:	ea0b 7bee 	and.w	fp, fp, lr, asr #31
100061c0:	f10c 0e03 	add.w	lr, ip, #3
100061c4:	4573      	cmp	r3, lr
100061c6:	ea45 050a 	orr.w	r5, r5, sl
100061ca:	ea46 060b 	orr.w	r6, r6, fp
100061ce:	d947      	bls.n	10006260 <fndsa_poly_big_to_fp64_exact+0x468>
100061d0:	fa0e fa07 	lsl.w	sl, lr, r7
100061d4:	f852 b02a 	ldr.w	fp, [r2, sl, lsl #2]
100061d8:	ea84 0a0e 	eor.w	sl, r4, lr
100061dc:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
100061e0:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
100061e4:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
100061e8:	ea40 000a 	orr.w	r0, r0, sl
100061ec:	ea88 0a0e 	eor.w	sl, r8, lr
100061f0:	ea89 0e0e 	eor.w	lr, r9, lr
100061f4:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
100061f8:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
100061fc:	f10c 0c04 	add.w	ip, ip, #4
10006200:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10006204:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10006208:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
1000620c:	4563      	cmp	r3, ip
1000620e:	ea0b 7bee 	and.w	fp, fp, lr, asr #31
10006212:	ea45 050a 	orr.w	r5, r5, sl
10006216:	ea46 060b 	orr.w	r6, r6, fp
1000621a:	d921      	bls.n	10006260 <fndsa_poly_big_to_fp64_exact+0x468>
1000621c:	fa0c fe07 	lsl.w	lr, ip, r7
10006220:	f852 a02e 	ldr.w	sl, [r2, lr, lsl #2]
10006224:	ea84 0e0c 	eor.w	lr, r4, ip
10006228:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
1000622c:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10006230:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
10006234:	ea40 000e 	orr.w	r0, r0, lr
10006238:	ea88 0e0c 	eor.w	lr, r8, ip
1000623c:	ea89 0c0c 	eor.w	ip, r9, ip
10006240:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10006244:	f02c 4c7f 	bic.w	ip, ip, #4278190080	@ 0xff000000
10006248:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
1000624c:	f10c 3cff 	add.w	ip, ip, #4294967295	@ 0xffffffff
10006250:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
10006254:	ea0a 7aec 	and.w	sl, sl, ip, asr #31
10006258:	ea45 050e 	orr.w	r5, r5, lr
1000625c:	ea46 060a 	orr.w	r6, r6, sl
10006260:	9c20      	ldr	r4, [sp, #128]	@ 0x80
10006262:	3204      	adds	r2, #4
10006264:	f854 cf04 	ldr.w	ip, [r4, #4]!
10006268:	3110      	adds	r1, #16
1000626a:	9420      	str	r4, [sp, #128]	@ 0x80
1000626c:	ea4f 7c9c 	mov.w	ip, ip, lsr #30
10006270:	9c24      	ldr	r4, [sp, #144]	@ 0x90
10006272:	f1cc 0c00 	rsb	ip, ip, #0
10006276:	ea04 0e5c 	and.w	lr, r4, ip, lsr #1
1000627a:	ea4e 0e06 	orr.w	lr, lr, r6
1000627e:	ea4f 064e 	mov.w	r6, lr, lsl #1
10006282:	9c28      	ldr	r4, [sp, #160]	@ 0xa0
10006284:	f006 4600 	and.w	r6, r6, #2147483648	@ 0x80000000
10006288:	ea46 060e 	orr.w	r6, r6, lr
1000628c:	40a6      	lsls	r6, r4
1000628e:	9c23      	ldr	r4, [sp, #140]	@ 0x8c
10006290:	ea04 0e5c 	and.w	lr, r4, ip, lsr #1
10006294:	9c22      	ldr	r4, [sp, #136]	@ 0x88
10006296:	ea4e 0e05 	orr.w	lr, lr, r5
1000629a:	ea04 0c5c 	and.w	ip, r4, ip, lsr #1
1000629e:	ea4c 0c00 	orr.w	ip, ip, r0
100062a2:	9826      	ldr	r0, [sp, #152]	@ 0x98
100062a4:	fa2c fc00 	lsr.w	ip, ip, r0
100062a8:	9827      	ldr	r0, [sp, #156]	@ 0x9c
100062aa:	fa0e f000 	lsl.w	r0, lr, r0
100062ae:	ea4c 0c00 	orr.w	ip, ip, r0
100062b2:	9825      	ldr	r0, [sp, #148]	@ 0x94
100062b4:	fa2e fe00 	lsr.w	lr, lr, r0
100062b8:	ea46 060e 	orr.w	r6, r6, lr
100062bc:	ee07 6a90 	vmov	s15, r6
100062c0:	eeb8 6b67 	vcvt.f64.u32	d6, s15
100062c4:	ee07 ca90 	vmov	s15, ip
100062c8:	eeb8 7b67 	vcvt.f64.u32	d7, s15
100062cc:	9829      	ldr	r0, [sp, #164]	@ 0xa4
100062ce:	ed01 6b04 	vstr	d6, [r1, #-16]
100062d2:	4282      	cmp	r2, r0
100062d4:	ed01 7b02 	vstr	d7, [r1, #-8]
100062d8:	f47f adef 	bne.w	10005eba <fndsa_poly_big_to_fp64_exact+0xc2>
100062dc:	b039      	add	sp, #228	@ 0xe4
100062de:	ecbd 8b10 	vpop	{d8-d15}
100062e2:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
100062e6:	f04f 0c00 	mov.w	ip, #0
100062ea:	4666      	mov	r6, ip
100062ec:	4665      	mov	r5, ip
100062ee:	4660      	mov	r0, ip
100062f0:	e6fa      	b.n	100060e8 <fndsa_poly_big_to_fp64_exact+0x2f0>
100062f2:	2210      	movs	r2, #16
100062f4:	4619      	mov	r1, r3
100062f6:	40ba      	lsls	r2, r7
100062f8:	b039      	add	sp, #228	@ 0xe4
100062fa:	ecbd 8b10 	vpop	{d8-d15}
100062fe:	e8bd 4ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10006302:	f00c bb8f 	b.w	10012a24 <memset>
