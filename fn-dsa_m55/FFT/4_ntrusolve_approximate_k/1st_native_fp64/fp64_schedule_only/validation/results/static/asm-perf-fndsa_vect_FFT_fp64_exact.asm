10008098 <fndsa_vect_FFT_fp64_exact>:
10008098:	2801      	cmp	r0, #1
1000809a:	f240 815a 	bls.w	10008352 <fndsa_vect_FFT_fp64_exact+0x2ba>
1000809e:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
100080a2:	460f      	mov	r7, r1
100080a4:	2101      	movs	r1, #1
100080a6:	ed2d 8b10 	vpush	{d8-d15}
100080aa:	2210      	movs	r2, #16
100080ac:	ed9f 9baa 	vldr	d9, [pc, #680]	@ 10008358 <fndsa_vect_FFT_fp64_exact+0x2c0>
100080b0:	ed9f 8bab 	vldr	d8, [pc, #684]	@ 10008360 <fndsa_vect_FFT_fp64_exact+0x2c8>
100080b4:	eeb7 eb00 	vmov.f64	d14, #112	@ 0x3f800000  1.0
100080b8:	460c      	mov	r4, r1
100080ba:	1e43      	subs	r3, r0, #1
100080bc:	b0b1      	sub	sp, #196	@ 0xc4
100080be:	9009      	str	r0, [sp, #36]	@ 0x24
100080c0:	409a      	lsls	r2, r3
100080c2:	fa01 f003 	lsl.w	r0, r1, r3
100080c6:	f04f 0a10 	mov.w	sl, #16
100080ca:	2301      	movs	r3, #1
100080cc:	4ea6      	ldr	r6, [pc, #664]	@ (10008368 <fndsa_vect_FFT_fp64_exact+0x2d0>)
100080ce:	fa0a fa04 	lsl.w	sl, sl, r4
100080d2:	4680      	mov	r8, r0
100080d4:	0840      	lsrs	r0, r0, #1
100080d6:	eb07 1900 	add.w	r9, r7, r0, lsl #4
100080da:	9005      	str	r0, [sp, #20]
100080dc:	eb0a 0006 	add.w	r0, sl, r6
100080e0:	9708      	str	r7, [sp, #32]
100080e2:	4693      	mov	fp, r2
100080e4:	46ba      	mov	sl, r7
100080e6:	2700      	movs	r7, #0
100080e8:	fa03 f504 	lsl.w	r5, r3, r4
100080ec:	eb05 0555 	add.w	r5, r5, r5, lsr #1
100080f0:	eb06 1505 	add.w	r5, r6, r5, lsl #4
100080f4:	e9cd 5406 	strd	r5, r4, [sp, #24]
100080f8:	edd0 7a00 	vldr	s15, [r0]
100080fc:	eeb8 1b67 	vcvt.f64.u32	d1, s15
10008100:	edd0 7a02 	vldr	s15, [r0, #8]
10008104:	eeb8 4b67 	vcvt.f64.u32	d4, s15
10008108:	edd0 7a01 	vldr	s15, [r0, #4]
1000810c:	eeb8 2b67 	vcvt.f64.u32	d2, s15
10008110:	edd0 7a03 	vldr	s15, [r0, #12]
10008114:	6843      	ldr	r3, [r0, #4]
10008116:	eeb8 3b67 	vcvt.f64.u32	d3, s15
1000811a:	0fdb      	lsrs	r3, r3, #31
1000811c:	ee06 3a10 	vmov	s12, r3
10008120:	ee17 3a90 	vmov	r3, s15
10008124:	0fdb      	lsrs	r3, r3, #31
10008126:	ee07 3a10 	vmov	s14, r3
1000812a:	ee31 5b04 	vadd.f64	d5, d1, d4
1000812e:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10008132:	ee32 cb03 	vadd.f64	d12, d2, d3
10008136:	ed8d 7b24 	vstr	d7, [sp, #144]	@ 0x90
1000813a:	ee25 7b09 	vmul.f64	d7, d5, d9
1000813e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10008142:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10008146:	ee3c cb07 	vadd.f64	d12, d12, d7
1000814a:	ee07 5b48 	vmls.f64	d5, d7, d8
1000814e:	9b05      	ldr	r3, [sp, #20]
10008150:	ee2c 7b09 	vmul.f64	d7, d12, d9
10008154:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10008158:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000815c:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10008160:	ee07 cb48 	vmls.f64	d12, d7, d8
10008164:	eebc 7bcc 	vcvt.u32.f64	s14, d12
10008168:	19d9      	adds	r1, r3, r7
1000816a:	ee17 3a10 	vmov	r3, s14
1000816e:	0fdb      	lsrs	r3, r3, #31
10008170:	ed8d 6b1a 	vstr	d6, [sp, #104]	@ 0x68
10008174:	ee07 3a10 	vmov	s14, r3
10008178:	ee25 6b09 	vmul.f64	d6, d5, d9
1000817c:	ee21 0b09 	vmul.f64	d0, d1, d9
10008180:	ed8d 1b14 	vstr	d1, [sp, #80]	@ 0x50
10008184:	ed8d 6b2c 	vstr	d6, [sp, #176]	@ 0xb0
10008188:	ee22 ab09 	vmul.f64	d10, d2, d9
1000818c:	ee24 1b09 	vmul.f64	d1, d4, d9
10008190:	ee23 bb09 	vmul.f64	d11, d3, d9
10008194:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10008198:	ee2c 6b09 	vmul.f64	d6, d12, d9
1000819c:	428f      	cmp	r7, r1
1000819e:	ed8d 2b12 	vstr	d2, [sp, #72]	@ 0x48
100081a2:	ed8d 3b1c 	vstr	d3, [sp, #112]	@ 0x70
100081a6:	ed8d 4b1e 	vstr	d4, [sp, #120]	@ 0x78
100081aa:	ed8d 0b18 	vstr	d0, [sp, #96]	@ 0x60
100081ae:	ed8d 1b22 	vstr	d1, [sp, #136]	@ 0x88
100081b2:	ed8d ab16 	vstr	d10, [sp, #88]	@ 0x58
100081b6:	ed8d bb20 	vstr	d11, [sp, #128]	@ 0x80
100081ba:	ed8d 5b28 	vstr	d5, [sp, #160]	@ 0xa0
100081be:	ed8d cb26 	vstr	d12, [sp, #152]	@ 0x98
100081c2:	ed8d 6b2a 	vstr	d6, [sp, #168]	@ 0xa8
100081c6:	ed8d 7b2e 	vstr	d7, [sp, #184]	@ 0xb8
100081ca:	f080 80aa 	bcs.w	10008322 <fndsa_vect_FFT_fp64_exact+0x28a>
100081ce:	464d      	mov	r5, r9
100081d0:	4654      	mov	r4, sl
100081d2:	eb0b 010a 	add.w	r1, fp, sl
100081d6:	eb0b 0609 	add.w	r6, fp, r9
100081da:	9004      	str	r0, [sp, #16]
100081dc:	ed95 0b00 	vldr	d0, [r5]
100081e0:	ed96 2b00 	vldr	d2, [r6]
100081e4:	ed96 3b02 	vldr	d3, [r6, #8]
100081e8:	ed95 1b02 	vldr	d1, [r5, #8]
100081ec:	a812      	add	r0, sp, #72	@ 0x48
100081ee:	f7ff fccb 	bl	10007b88 <fp64e_cmul_prepared>
100081f2:	ed94 db02 	vldr	d13, [r4, #8]
100081f6:	ee3d 7b01 	vadd.f64	d7, d13, d1
100081fa:	ed91 ab00 	vldr	d10, [r1]
100081fe:	ed91 cb02 	vldr	d12, [r1, #8]
10008202:	ed94 bb00 	vldr	d11, [r4]
10008206:	ed8d 1b0c 	vstr	d1, [sp, #48]	@ 0x30
1000820a:	ee3c 6b03 	vadd.f64	d6, d12, d3
1000820e:	ed8d 0b0a 	vstr	d0, [sp, #40]	@ 0x28
10008212:	ed8d 2b0e 	vstr	d2, [sp, #56]	@ 0x38
10008216:	ed8d 3b10 	vstr	d3, [sp, #64]	@ 0x40
1000821a:	ee3d 5b08 	vadd.f64	d5, d13, d8
1000821e:	ee3a db02 	vadd.f64	d13, d10, d2
10008222:	ee3a ab08 	vadd.f64	d10, d10, d8
10008226:	ee3b fb00 	vadd.f64	d15, d11, d0
1000822a:	ee3a ab42 	vsub.f64	d10, d10, d2
1000822e:	ee26 4b09 	vmul.f64	d4, d6, d9
10008232:	ee3c cb08 	vadd.f64	d12, d12, d8
10008236:	ee3b bb08 	vadd.f64	d11, d11, d8
1000823a:	ee35 1b41 	vsub.f64	d1, d5, d1
1000823e:	ee3b bb40 	vsub.f64	d11, d11, d0
10008242:	eebc 0bc4 	vcvt.u32.f64	s0, d4
10008246:	ee3c 2b43 	vsub.f64	d2, d12, d3
1000824a:	ee27 5b09 	vmul.f64	d5, d7, d9
1000824e:	ee3a 3b4e 	vsub.f64	d3, d10, d14
10008252:	eebc abc5 	vcvt.u32.f64	s20, d5
10008256:	ee22 cb09 	vmul.f64	d12, d2, d9
1000825a:	ed8d 3b02 	vstr	d3, [sp, #8]
1000825e:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10008262:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10008266:	ee21 3b09 	vmul.f64	d3, d1, d9
1000826a:	ee3b 5b4e 	vsub.f64	d5, d11, d14
1000826e:	ee0a 7b48 	vmls.f64	d7, d10, d8
10008272:	ed8d 5b00 	vstr	d5, [sp]
10008276:	ee00 6b48 	vmls.f64	d6, d0, d8
1000827a:	eebc 4bcc 	vcvt.u32.f64	s8, d12
1000827e:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10008282:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10008286:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000828a:	eeb0 cb47 	vmov.f64	d12, d7
1000828e:	ee3d bb00 	vadd.f64	d11, d13, d0
10008292:	ed9d 7b00 	vldr	d7, [sp]
10008296:	eeb0 db46 	vmov.f64	d13, d6
1000829a:	ed9d 6b02 	vldr	d6, [sp, #8]
1000829e:	ee3f 5b0a 	vadd.f64	d5, d15, d10
100082a2:	ee37 7b03 	vadd.f64	d7, d7, d3
100082a6:	ee36 6b04 	vadd.f64	d6, d6, d4
100082aa:	ee25 0b09 	vmul.f64	d0, d5, d9
100082ae:	ee2b ab09 	vmul.f64	d10, d11, d9
100082b2:	ee03 1b48 	vmls.f64	d1, d3, d8
100082b6:	ee04 2b48 	vmls.f64	d2, d4, d8
100082ba:	ee27 3b09 	vmul.f64	d3, d7, d9
100082be:	ee26 4b09 	vmul.f64	d4, d6, d9
100082c2:	eebc 0bc0 	vcvt.u32.f64	s0, d0
100082c6:	eebc abca 	vcvt.u32.f64	s20, d10
100082ca:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100082ce:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100082d2:	eeb8 0b40 	vcvt.f64.u32	d0, s0
100082d6:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
100082da:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100082de:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100082e2:	ee00 5b48 	vmls.f64	d5, d0, d8
100082e6:	ee0a bb48 	vmls.f64	d11, d10, d8
100082ea:	ee03 7b48 	vmls.f64	d7, d3, d8
100082ee:	ee04 6b48 	vmls.f64	d6, d4, d8
100082f2:	3410      	adds	r4, #16
100082f4:	3110      	adds	r1, #16
100082f6:	3510      	adds	r5, #16
100082f8:	3610      	adds	r6, #16
100082fa:	45a1      	cmp	r9, r4
100082fc:	ed04 cb02 	vstr	d12, [r4, #-8]
10008300:	ed04 5b04 	vstr	d5, [r4, #-16]
10008304:	ed01 bb04 	vstr	d11, [r1, #-16]
10008308:	ed01 db02 	vstr	d13, [r1, #-8]
1000830c:	ed05 1b02 	vstr	d1, [r5, #-8]
10008310:	ed05 7b04 	vstr	d7, [r5, #-16]
10008314:	ed06 6b04 	vstr	d6, [r6, #-16]
10008318:	ed06 2b02 	vstr	d2, [r6, #-8]
1000831c:	f47f af5e 	bne.w	100081dc <fndsa_vect_FFT_fp64_exact+0x144>
10008320:	9804      	ldr	r0, [sp, #16]
10008322:	9b06      	ldr	r3, [sp, #24]
10008324:	3010      	adds	r0, #16
10008326:	4283      	cmp	r3, r0
10008328:	4447      	add	r7, r8
1000832a:	eb0a 1a08 	add.w	sl, sl, r8, lsl #4
1000832e:	eb09 1908 	add.w	r9, r9, r8, lsl #4
10008332:	f47f aee1 	bne.w	100080f8 <fndsa_vect_FFT_fp64_exact+0x60>
10008336:	9c07      	ldr	r4, [sp, #28]
10008338:	9b09      	ldr	r3, [sp, #36]	@ 0x24
1000833a:	3401      	adds	r4, #1
1000833c:	42a3      	cmp	r3, r4
1000833e:	465a      	mov	r2, fp
10008340:	9805      	ldr	r0, [sp, #20]
10008342:	9f08      	ldr	r7, [sp, #32]
10008344:	f47f aebf 	bne.w	100080c6 <fndsa_vect_FFT_fp64_exact+0x2e>
10008348:	b031      	add	sp, #196	@ 0xc4
1000834a:	ecbd 8b10 	vpop	{d8-d15}
1000834e:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10008352:	4770      	bx	lr
10008354:	f3af 8000 	nop.w
10008358:	00000000 	.word	0x00000000
1000835c:	3df00000 	.word	0x3df00000
10008360:	00000000 	.word	0x00000000
10008364:	41f00000 	.word	0x41f00000
10008368:	300039a0 	.word	0x300039a0
1000836c:	00000000 	.word	0x00000000

