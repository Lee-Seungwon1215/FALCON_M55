
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/asm-perf/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10007dd8 <fndsa_poly_big_to_fp64_exact>:
10007dd8:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10007ddc:	ed2d 8b10 	vpush	{d8-d15}
10007de0:	b0b9      	sub	sp, #228	@ 0xe4
10007de2:	4607      	mov	r7, r0
10007de4:	9d52      	ldr	r5, [sp, #328]	@ 0x148
10007de6:	4608      	mov	r0, r1
10007de8:	2b00      	cmp	r3, #0
10007dea:	f000 8272 	beq.w	100082d2 <fndsa_poly_big_to_fp64_exact+0x4fa>
10007dee:	eb05 1145 	add.w	r1, r5, r5, lsl #5
10007df2:	eb01 2181 	add.w	r1, r1, r1, lsl #10
10007df6:	eb05 0441 	add.w	r4, r5, r1, lsl #1
10007dfa:	0d64      	lsrs	r4, r4, #21
10007dfc:	4601      	mov	r1, r0
10007dfe:	ebc4 1044 	rsb	r0, r4, r4, lsl #5
10007e02:	1a2d      	subs	r5, r5, r0
10007e04:	1e6e      	subs	r6, r5, #1
10007e06:	eba4 78d6 	sub.w	r8, r4, r6, lsr #31
10007e0a:	eea6 8b10 	vdup.32	q3, r8
10007e0e:	ed9f 0b96 	vldr	d0, [pc, #600]	@ 10008068 <fndsa_poly_big_to_fp64_exact+0x290>
10007e12:	ed9f 1b97 	vldr	d1, [pc, #604]	@ 10008070 <fndsa_poly_big_to_fp64_exact+0x298>
10007e16:	ed9f 2b98 	vldr	d2, [pc, #608]	@ 10008078 <fndsa_poly_big_to_fp64_exact+0x2a0>
10007e1a:	ed9f 3b99 	vldr	d3, [pc, #612]	@ 10008080 <fndsa_poly_big_to_fp64_exact+0x2a8>
10007e1e:	ed9f 4b9a 	vldr	d4, [pc, #616]	@ 10008088 <fndsa_poly_big_to_fp64_exact+0x2b0>
10007e22:	ed9f 5b9b 	vldr	d5, [pc, #620]	@ 10008090 <fndsa_poly_big_to_fp64_exact+0x2b8>
10007e26:	ef26 0840 	vadd.i32	q0, q3, q0
10007e2a:	ef26 2842 	vadd.i32	q1, q3, q1
10007e2e:	ef26 6844 	vadd.i32	q3, q3, q2
10007e32:	1b18      	subs	r0, r3, r4
10007e34:	17f4      	asrs	r4, r6, #31
10007e36:	f004 041f 	and.w	r4, r4, #31
10007e3a:	eb00 70d6 	add.w	r0, r0, r6, lsr #31
10007e3e:	ea44 0605 	orr.w	r6, r4, r5
10007e42:	2404      	movs	r4, #4
10007e44:	eeae 7b10 	vdup.32	q7, r7
10007e48:	ed8d 1f14 	vstrw.32	q0, [sp, #80]
10007e4c:	ed8d 3f18 	vstrw.32	q1, [sp, #96]
10007e50:	ed8d 7f1c 	vstrw.32	q3, [sp, #112]
10007e54:	1e5d      	subs	r5, r3, #1
10007e56:	9521      	str	r5, [sp, #132]	@ 0x84
10007e58:	1e45      	subs	r5, r0, #1
10007e5a:	17ed      	asrs	r5, r5, #31
10007e5c:	9523      	str	r5, [sp, #140]	@ 0x8c
10007e5e:	40bc      	lsls	r4, r7
10007e60:	1e85      	subs	r5, r0, #2
10007e62:	17c0      	asrs	r0, r0, #31
10007e64:	1914      	adds	r4, r2, r4
10007e66:	9022      	str	r0, [sp, #136]	@ 0x88
10007e68:	17e8      	asrs	r0, r5, #31
10007e6a:	1e5d      	subs	r5, r3, #1
10007e6c:	40bd      	lsls	r5, r7
10007e6e:	9024      	str	r0, [sp, #144]	@ 0x90
10007e70:	9429      	str	r4, [sp, #164]	@ 0xa4
10007e72:	1f10      	subs	r0, r2, #4
10007e74:	f1c6 0420 	rsb	r4, r6, #32
10007e78:	eb00 0085 	add.w	r0, r0, r5, lsl #2
10007e7c:	9427      	str	r4, [sp, #156]	@ 0x9c
10007e7e:	f1c6 041f 	rsb	r4, r6, #31
10007e82:	9020      	str	r0, [sp, #128]	@ 0x80
10007e84:	1e75      	subs	r5, r6, #1
10007e86:	f108 30ff 	add.w	r0, r8, #4294967295	@ 0xffffffff
10007e8a:	9428      	str	r4, [sp, #160]	@ 0xa0
10007e8c:	089c      	lsrs	r4, r3, #2
10007e8e:	9625      	str	r6, [sp, #148]	@ 0x94
10007e90:	f108 0901 	add.w	r9, r8, #1
10007e94:	9526      	str	r5, [sp, #152]	@ 0x98
10007e96:	942a      	str	r4, [sp, #168]	@ 0xa8
10007e98:	902b      	str	r0, [sp, #172]	@ 0xac
10007e9a:	9821      	ldr	r0, [sp, #132]	@ 0x84
10007e9c:	2804      	cmp	r0, #4
10007e9e:	f240 8212 	bls.w	100082c6 <fndsa_poly_big_to_fp64_exact+0x4ee>
10007ea2:	ef80 6050 	vmov.i32	q3, #0	@ 0x00000000
10007ea6:	ed9f 8b7c 	vldr	d8, [pc, #496]	@ 10008098 <fndsa_poly_big_to_fp64_exact+0x2c0>
10007eaa:	ed9f 9b7d 	vldr	d9, [pc, #500]	@ 100080a0 <fndsa_poly_big_to_fp64_exact+0x2c8>
10007eae:	982a      	ldr	r0, [sp, #168]	@ 0xa8
10007eb0:	ed8d 7f08 	vstrw.32	q3, [sp, #32]
10007eb4:	f040 e001 	dls	lr, r0
10007eb8:	ed8d 7f04 	vstrw.32	q3, [sp, #16]
10007ebc:	ed8d 7f00 	vstrw.32	q3, [sp, #0]
10007ec0:	ed9f cb79 	vldr	d12, [pc, #484]	@ 100080a8 <fndsa_poly_big_to_fp64_exact+0x2d0>
10007ec4:	ed9f db7a 	vldr	d13, [pc, #488]	@ 100080b0 <fndsa_poly_big_to_fp64_exact+0x2d8>
10007ec8:	ed9f ab7b 	vldr	d10, [pc, #492]	@ 100080b8 <fndsa_poly_big_to_fp64_exact+0x2e0>
10007ecc:	ed9f bb7c 	vldr	d11, [pc, #496]	@ 100080c0 <fndsa_poly_big_to_fp64_exact+0x2e8>
10007ed0:	ed8d 9f0c 	vstrw.32	q4, [sp, #48]
10007ed4:	ff2e 644a 	vshl.u32	q3, q5, q7
10007ed8:	ee16 6a10 	vmov	r6, s12
10007edc:	ee36 5b10 	vmov.32	r5, d6[1]
10007ee0:	ee17 4b10 	vmov.32	r4, d7[0]
10007ee4:	ee37 0b10 	vmov.32	r0, d7[1]
10007ee8:	ed9d 7f1c 	vldrw.u32	q3, [sp, #112]
10007eec:	ed9d 1f18 	vldrw.u32	q0, [sp, #96]
10007ef0:	ff0a 4156 	veor	q2, q5, q3
10007ef4:	ef80 6054 	vmov.i32	q3, #4	@ 0x00000004
10007ef8:	ef26 8156 	vmov	q4, q3
10007efc:	ef2a a846 	vadd.i32	q5, q5, q3
10007f00:	ff0c 6150 	veor	q3, q6, q0
10007f04:	ff87 2e5f 	vmov.i8	q1, #255	@ 0xff
10007f08:	ff87 677f 	vbic.i32	q3, #4278190080	@ 0xff000000
10007f0c:	ef26 6842 	vadd.i32	q3, q3, q1
10007f10:	efa1 6056 	vshr.s32	q3, q3, #31
10007f14:	ed9d 1f14 	vldrw.u32	q0, [sp, #80]
10007f18:	ed8d 7f10 	vstrw.32	q3, [sp, #64]
10007f1c:	ed9d 7f0c 	vldrw.u32	q3, [sp, #48]
10007f20:	ff06 0150 	veor	q0, q3, q0
10007f24:	ff87 477f 	vbic.i32	q2, #4278190080	@ 0xff000000
10007f28:	ff87 077f 	vbic.i32	q0, #4278190080	@ 0xff000000
10007f2c:	ef24 4842 	vadd.i32	q2, q2, q1
10007f30:	ef20 0842 	vadd.i32	q0, q0, q1
10007f34:	ff2e 244c 	vshl.u32	q1, q6, q7
10007f38:	f852 6026 	ldr.w	r6, [r2, r6, lsl #2]
10007f3c:	efa1 4054 	vshr.s32	q2, q2, #31
10007f40:	9634      	str	r6, [sp, #208]	@ 0xd0
10007f42:	ee12 6a10 	vmov	r6, s4
10007f46:	f852 5025 	ldr.w	r5, [r2, r5, lsl #2]
10007f4a:	efa1 0050 	vshr.s32	q0, q0, #31
10007f4e:	9535      	str	r5, [sp, #212]	@ 0xd4
10007f50:	ee32 5b10 	vmov.32	r5, d2[1]
10007f54:	f852 4024 	ldr.w	r4, [r2, r4, lsl #2]
10007f58:	ef2c c848 	vadd.i32	q6, q6, q4
10007f5c:	9436      	str	r4, [sp, #216]	@ 0xd8
10007f5e:	ee13 4b10 	vmov.32	r4, d3[0]
10007f62:	f852 0020 	ldr.w	r0, [r2, r0, lsl #2]
10007f66:	9037      	str	r0, [sp, #220]	@ 0xdc
10007f68:	ee33 0b10 	vmov.32	r0, d3[1]
10007f6c:	ff2e 2446 	vshl.u32	q1, q3, q7
10007f70:	f852 6026 	ldr.w	r6, [r2, r6, lsl #2]
10007f74:	ef26 6848 	vadd.i32	q3, q3, q4
10007f78:	9630      	str	r6, [sp, #192]	@ 0xc0
10007f7a:	f852 5025 	ldr.w	r5, [r2, r5, lsl #2]
10007f7e:	ee12 6a10 	vmov	r6, s4
10007f82:	9531      	str	r5, [sp, #196]	@ 0xc4
10007f84:	f852 4024 	ldr.w	r4, [r2, r4, lsl #2]
10007f88:	ee32 5b10 	vmov.32	r5, d2[1]
10007f8c:	9432      	str	r4, [sp, #200]	@ 0xc8
10007f8e:	f852 0020 	ldr.w	r0, [r2, r0, lsl #2]
10007f92:	ee13 4b10 	vmov.32	r4, d3[0]
10007f96:	9033      	str	r0, [sp, #204]	@ 0xcc
10007f98:	ee33 0b10 	vmov.32	r0, d3[1]
10007f9c:	ed9d 3f34 	vldrw.u32	q1, [sp, #208]
10007fa0:	ef02 2154 	vand	q1, q1, q2
10007fa4:	ed9d 5f00 	vldrw.u32	q2, [sp, #0]
10007fa8:	ef24 4152 	vorr	q2, q2, q1
10007fac:	f852 6026 	ldr.w	r6, [r2, r6, lsl #2]
10007fb0:	ed8d 7f0c 	vstrw.32	q3, [sp, #48]
10007fb4:	962c      	str	r6, [sp, #176]	@ 0xb0
10007fb6:	f852 5025 	ldr.w	r5, [r2, r5, lsl #2]
10007fba:	952d      	str	r5, [sp, #180]	@ 0xb4
10007fbc:	f852 4024 	ldr.w	r4, [r2, r4, lsl #2]
10007fc0:	942e      	str	r4, [sp, #184]	@ 0xb8
10007fc2:	f852 0020 	ldr.w	r0, [r2, r0, lsl #2]
10007fc6:	902f      	str	r0, [sp, #188]	@ 0xbc
10007fc8:	ed8d 5f00 	vstrw.32	q2, [sp, #0]
10007fcc:	ed9d 7f10 	vldrw.u32	q3, [sp, #64]
10007fd0:	ed9d 5f30 	vldrw.u32	q2, [sp, #192]
10007fd4:	ef04 4156 	vand	q2, q2, q3
10007fd8:	ed9d 7f04 	vldrw.u32	q3, [sp, #16]
10007fdc:	ef26 6154 	vorr	q3, q3, q2
10007fe0:	ed8d 7f04 	vstrw.32	q3, [sp, #16]
10007fe4:	ed9d 7f2c 	vldrw.u32	q3, [sp, #176]
10007fe8:	ed9d 5f08 	vldrw.u32	q2, [sp, #32]
10007fec:	ef06 6150 	vand	q3, q3, q0
10007ff0:	ef24 6156 	vorr	q3, q2, q3
10007ff4:	ed8d 7f08 	vstrw.32	q3, [sp, #32]
10007ff8:	f00f c095 	le	lr, 10007ed4 <fndsa_poly_big_to_fp64_exact+0xfc>
10007ffc:	ed9d 7f00 	vldrw.u32	q3, [sp, #0]
10008000:	ed9d 5f04 	vldrw.u32	q2, [sp, #16]
10008004:	ee37 0b10 	vmov.32	r0, d7[1]
10008008:	ee16 6a10 	vmov	r6, s12
1000800c:	ee36 5b10 	vmov.32	r5, d6[1]
10008010:	4306      	orrs	r6, r0
10008012:	ee14 0a10 	vmov	r0, s8
10008016:	ee34 cb10 	vmov.32	ip, d4[1]
1000801a:	4305      	orrs	r5, r0
1000801c:	ee17 0b10 	vmov.32	r0, d7[0]
10008020:	ea40 000c 	orr.w	r0, r0, ip
10008024:	ee15 cb10 	vmov.32	ip, d5[0]
10008028:	ed9d 7f08 	vldrw.u32	q3, [sp, #32]
1000802c:	ea46 060c 	orr.w	r6, r6, ip
10008030:	ee35 cb10 	vmov.32	ip, d5[1]
10008034:	ea45 050c 	orr.w	r5, r5, ip
10008038:	ee16 ca10 	vmov	ip, s12
1000803c:	ea40 000c 	orr.w	r0, r0, ip
10008040:	ee36 cb10 	vmov.32	ip, d6[1]
10008044:	ea46 060c 	orr.w	r6, r6, ip
10008048:	ee17 cb10 	vmov.32	ip, d7[0]
1000804c:	ea45 050c 	orr.w	r5, r5, ip
10008050:	ee37 cb10 	vmov.32	ip, d7[1]
10008054:	079c      	lsls	r4, r3, #30
10008056:	ea40 000c 	orr.w	r0, r0, ip
1000805a:	f000 80f1 	beq.w	10008240 <fndsa_poly_big_to_fp64_exact+0x468>
1000805e:	f023 0c03 	bic.w	ip, r3, #3
10008062:	e031      	b.n	100080c8 <fndsa_poly_big_to_fp64_exact+0x2f0>
10008064:	f3af 8000 	nop.w
10008068:	ffffffff 	.word	0xffffffff
1000806c:	00000001 	.word	0x00000001
10008070:	00000000 	.word	0x00000000
10008074:	ffffffff 	.word	0xffffffff
10008078:	00000000 	.word	0x00000000
1000807c:	ffffffff 	.word	0xffffffff
10008080:	00000001 	.word	0x00000001
10008084:	00000000 	.word	0x00000000
10008088:	00000001 	.word	0x00000001
1000808c:	00000000 	.word	0x00000000
10008090:	ffffffff 	.word	0xffffffff
10008094:	00000001 	.word	0x00000001
10008098:	00000002 	.word	0x00000002
1000809c:	00000003 	.word	0x00000003
100080a0:	00000003 	.word	0x00000003
100080a4:	00000003 	.word	0x00000003
100080a8:	00000001 	.word	0x00000001
100080ac:	00000001 	.word	0x00000001
100080b0:	00000002 	.word	0x00000002
100080b4:	00000002 	.word	0x00000002
	...
100080c4:	00000001 	.word	0x00000001
100080c8:	9c2b      	ldr	r4, [sp, #172]	@ 0xac
100080ca:	fa0c fe07 	lsl.w	lr, ip, r7
100080ce:	f852 a02e 	ldr.w	sl, [r2, lr, lsl #2]
100080d2:	ea84 0e0c 	eor.w	lr, r4, ip
100080d6:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
100080da:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
100080de:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
100080e2:	ea40 000e 	orr.w	r0, r0, lr
100080e6:	ea88 0e0c 	eor.w	lr, r8, ip
100080ea:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
100080ee:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
100080f2:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
100080f6:	ea45 050e 	orr.w	r5, r5, lr
100080fa:	ea89 0e0c 	eor.w	lr, r9, ip
100080fe:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10008102:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10008106:	ea0a 7aee 	and.w	sl, sl, lr, asr #31
1000810a:	f10c 0e01 	add.w	lr, ip, #1
1000810e:	4573      	cmp	r3, lr
10008110:	ea46 060a 	orr.w	r6, r6, sl
10008114:	f240 8094 	bls.w	10008240 <fndsa_poly_big_to_fp64_exact+0x468>
10008118:	fa0e fa07 	lsl.w	sl, lr, r7
1000811c:	f852 b02a 	ldr.w	fp, [r2, sl, lsl #2]
10008120:	ea84 0a0e 	eor.w	sl, r4, lr
10008124:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10008128:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
1000812c:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10008130:	ea40 000a 	orr.w	r0, r0, sl
10008134:	ea88 0a0e 	eor.w	sl, r8, lr
10008138:	ea89 0e0e 	eor.w	lr, r9, lr
1000813c:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10008140:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10008144:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10008148:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
1000814c:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
10008150:	ea0b 7bee 	and.w	fp, fp, lr, asr #31
10008154:	f10c 0e02 	add.w	lr, ip, #2
10008158:	4573      	cmp	r3, lr
1000815a:	ea45 050a 	orr.w	r5, r5, sl
1000815e:	ea46 060b 	orr.w	r6, r6, fp
10008162:	d96d      	bls.n	10008240 <fndsa_poly_big_to_fp64_exact+0x468>
10008164:	fa0e fa07 	lsl.w	sl, lr, r7
10008168:	f852 b02a 	ldr.w	fp, [r2, sl, lsl #2]
1000816c:	ea84 0a0e 	eor.w	sl, r4, lr
10008170:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
10008174:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10008178:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
1000817c:	ea40 000a 	orr.w	r0, r0, sl
10008180:	ea88 0a0e 	eor.w	sl, r8, lr
10008184:	ea89 0e0e 	eor.w	lr, r9, lr
10008188:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
1000818c:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10008190:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10008194:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
10008198:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
1000819c:	ea0b 7bee 	and.w	fp, fp, lr, asr #31
100081a0:	f10c 0e03 	add.w	lr, ip, #3
100081a4:	4573      	cmp	r3, lr
100081a6:	ea45 050a 	orr.w	r5, r5, sl
100081aa:	ea46 060b 	orr.w	r6, r6, fp
100081ae:	d947      	bls.n	10008240 <fndsa_poly_big_to_fp64_exact+0x468>
100081b0:	fa0e fa07 	lsl.w	sl, lr, r7
100081b4:	f852 b02a 	ldr.w	fp, [r2, sl, lsl #2]
100081b8:	ea84 0a0e 	eor.w	sl, r4, lr
100081bc:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
100081c0:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
100081c4:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
100081c8:	ea40 000a 	orr.w	r0, r0, sl
100081cc:	ea88 0a0e 	eor.w	sl, r8, lr
100081d0:	ea89 0e0e 	eor.w	lr, r9, lr
100081d4:	f02a 4a7f 	bic.w	sl, sl, #4278190080	@ 0xff000000
100081d8:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
100081dc:	f10c 0c04 	add.w	ip, ip, #4
100081e0:	f10a 3aff 	add.w	sl, sl, #4294967295	@ 0xffffffff
100081e4:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
100081e8:	ea0b 7aea 	and.w	sl, fp, sl, asr #31
100081ec:	4563      	cmp	r3, ip
100081ee:	ea0b 7bee 	and.w	fp, fp, lr, asr #31
100081f2:	ea45 050a 	orr.w	r5, r5, sl
100081f6:	ea46 060b 	orr.w	r6, r6, fp
100081fa:	d921      	bls.n	10008240 <fndsa_poly_big_to_fp64_exact+0x468>
100081fc:	fa0c fe07 	lsl.w	lr, ip, r7
10008200:	f852 a02e 	ldr.w	sl, [r2, lr, lsl #2]
10008204:	ea84 0e0c 	eor.w	lr, r4, ip
10008208:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
1000820c:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
10008210:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
10008214:	ea40 000e 	orr.w	r0, r0, lr
10008218:	ea88 0e0c 	eor.w	lr, r8, ip
1000821c:	ea89 0c0c 	eor.w	ip, r9, ip
10008220:	f02e 4e7f 	bic.w	lr, lr, #4278190080	@ 0xff000000
10008224:	f02c 4c7f 	bic.w	ip, ip, #4278190080	@ 0xff000000
10008228:	f10e 3eff 	add.w	lr, lr, #4294967295	@ 0xffffffff
1000822c:	f10c 3cff 	add.w	ip, ip, #4294967295	@ 0xffffffff
10008230:	ea0a 7eee 	and.w	lr, sl, lr, asr #31
10008234:	ea0a 7aec 	and.w	sl, sl, ip, asr #31
10008238:	ea45 050e 	orr.w	r5, r5, lr
1000823c:	ea46 060a 	orr.w	r6, r6, sl
10008240:	9c20      	ldr	r4, [sp, #128]	@ 0x80
10008242:	3204      	adds	r2, #4
10008244:	f854 cf04 	ldr.w	ip, [r4, #4]!
10008248:	3110      	adds	r1, #16
1000824a:	9420      	str	r4, [sp, #128]	@ 0x80
1000824c:	ea4f 7c9c 	mov.w	ip, ip, lsr #30
10008250:	9c24      	ldr	r4, [sp, #144]	@ 0x90
10008252:	f1cc 0c00 	rsb	ip, ip, #0
10008256:	ea04 0e5c 	and.w	lr, r4, ip, lsr #1
1000825a:	ea4e 0e06 	orr.w	lr, lr, r6
1000825e:	ea4f 064e 	mov.w	r6, lr, lsl #1
10008262:	9c28      	ldr	r4, [sp, #160]	@ 0xa0
10008264:	f006 4600 	and.w	r6, r6, #2147483648	@ 0x80000000
10008268:	ea46 060e 	orr.w	r6, r6, lr
1000826c:	40a6      	lsls	r6, r4
1000826e:	9c23      	ldr	r4, [sp, #140]	@ 0x8c
10008270:	ea04 0e5c 	and.w	lr, r4, ip, lsr #1
10008274:	9c22      	ldr	r4, [sp, #136]	@ 0x88
10008276:	ea4e 0e05 	orr.w	lr, lr, r5
1000827a:	ea04 0c5c 	and.w	ip, r4, ip, lsr #1
1000827e:	ea4c 0c00 	orr.w	ip, ip, r0
10008282:	9826      	ldr	r0, [sp, #152]	@ 0x98
10008284:	fa2c fc00 	lsr.w	ip, ip, r0
10008288:	9827      	ldr	r0, [sp, #156]	@ 0x9c
1000828a:	fa0e f000 	lsl.w	r0, lr, r0
1000828e:	ea4c 0c00 	orr.w	ip, ip, r0
10008292:	9825      	ldr	r0, [sp, #148]	@ 0x94
10008294:	fa2e fe00 	lsr.w	lr, lr, r0
10008298:	ea46 060e 	orr.w	r6, r6, lr
1000829c:	ee07 6a90 	vmov	s15, r6
100082a0:	eeb8 6b67 	vcvt.f64.u32	d6, s15
100082a4:	ee07 ca90 	vmov	s15, ip
100082a8:	eeb8 7b67 	vcvt.f64.u32	d7, s15
100082ac:	9829      	ldr	r0, [sp, #164]	@ 0xa4
100082ae:	ed01 6b04 	vstr	d6, [r1, #-16]
100082b2:	4282      	cmp	r2, r0
100082b4:	ed01 7b02 	vstr	d7, [r1, #-8]
100082b8:	f47f adef 	bne.w	10007e9a <fndsa_poly_big_to_fp64_exact+0xc2>
100082bc:	b039      	add	sp, #228	@ 0xe4
100082be:	ecbd 8b10 	vpop	{d8-d15}
100082c2:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
100082c6:	f04f 0c00 	mov.w	ip, #0
100082ca:	4666      	mov	r6, ip
100082cc:	4665      	mov	r5, ip
100082ce:	4660      	mov	r0, ip
100082d0:	e6fa      	b.n	100080c8 <fndsa_poly_big_to_fp64_exact+0x2f0>
100082d2:	2210      	movs	r2, #16
100082d4:	4619      	mov	r1, r3
100082d6:	40ba      	lsls	r2, r7
100082d8:	b039      	add	sp, #228	@ 0xe4
100082da:	ecbd 8b10 	vpop	{d8-d15}
100082de:	e8bd 4ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
100082e2:	f00e bac9 	b.w	10016878 <memset>
