10008098 <fndsa_vect_FFT_fp64_exact>:
10008098:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
1000809c:	2301      	movs	r3, #1
1000809e:	ed2d 8b10 	vpush	{d8-d15}
100080a2:	f100 3aff 	add.w	sl, r0, #4294967295	@ 0xffffffff
100080a6:	2802      	cmp	r0, #2
100080a8:	4604      	mov	r4, r0
100080aa:	460e      	mov	r6, r1
100080ac:	b0df      	sub	sp, #380	@ 0x17c
100080ae:	fa03 f80a 	lsl.w	r8, r3, sl
100080b2:	f200 857e 	bhi.w	10008bb2 <fndsa_vect_FFT_fp64_exact+0xb1a>
100080b6:	bf08      	it	eq
100080b8:	4686      	moveq	lr, r0
100080ba:	f040 8575 	bne.w	10008ba8 <fndsa_vect_FFT_fp64_exact+0xb10>
100080be:	2010      	movs	r0, #16
100080c0:	9417      	str	r4, [sp, #92]	@ 0x5c
100080c2:	ed9f 9bbf 	vldr	d9, [pc, #764]	@ 100083c0 <fndsa_vect_FFT_fp64_exact+0x328>
100080c6:	ed9f 8bc0 	vldr	d8, [pc, #768]	@ 100083c8 <fndsa_vect_FFT_fp64_exact+0x330>
100080ca:	2401      	movs	r4, #1
100080cc:	f8cd 8058 	str.w	r8, [sp, #88]	@ 0x58
100080d0:	46c4      	mov	ip, r8
100080d2:	f8df 82fc 	ldr.w	r8, [pc, #764]	@ 100083d0 <fndsa_vect_FFT_fp64_exact+0x338>
100080d6:	af18      	add	r7, sp, #96	@ 0x60
100080d8:	f8cd a050 	str.w	sl, [sp, #80]	@ 0x50
100080dc:	fa00 fb0a 	lsl.w	fp, r0, sl
100080e0:	f8cd e048 	str.w	lr, [sp, #72]	@ 0x48
100080e4:	2301      	movs	r3, #1
100080e6:	f04f 0a10 	mov.w	sl, #16
100080ea:	4662      	mov	r2, ip
100080ec:	40a3      	lsls	r3, r4
100080ee:	eb03 0353 	add.w	r3, r3, r3, lsr #1
100080f2:	eb08 1303 	add.w	r3, r8, r3, lsl #4
100080f6:	ea4f 0c5c 	mov.w	ip, ip, lsr #1
100080fa:	fa0a fa04 	lsl.w	sl, sl, r4
100080fe:	930a      	str	r3, [sp, #40]	@ 0x28
10008100:	eb06 190c 	add.w	r9, r6, ip, lsl #4
10008104:	4633      	mov	r3, r6
10008106:	eb0a 0008 	add.w	r0, sl, r8
1000810a:	9610      	str	r6, [sp, #64]	@ 0x40
1000810c:	46da      	mov	sl, fp
1000810e:	f04f 0b00 	mov.w	fp, #0
10008112:	f8cd c020 	str.w	ip, [sp, #32]
10008116:	4616      	mov	r6, r2
10008118:	940c      	str	r4, [sp, #48]	@ 0x30
1000811a:	eeb7 eb00 	vmov.f64	d14, #112	@ 0x3f800000  1.0
1000811e:	f8cd 8038 	str.w	r8, [sp, #56]	@ 0x38
10008122:	edd0 7a00 	vldr	s15, [r0]
10008126:	eeb8 1b67 	vcvt.f64.u32	d1, s15
1000812a:	edd0 7a02 	vldr	s15, [r0, #8]
1000812e:	eeb8 4b67 	vcvt.f64.u32	d4, s15
10008132:	edd0 7a01 	vldr	s15, [r0, #4]
10008136:	eeb8 2b67 	vcvt.f64.u32	d2, s15
1000813a:	edd0 7a03 	vldr	s15, [r0, #12]
1000813e:	6842      	ldr	r2, [r0, #4]
10008140:	eeb8 3b67 	vcvt.f64.u32	d3, s15
10008144:	0fd2      	lsrs	r2, r2, #31
10008146:	ee06 2a10 	vmov	s12, r2
1000814a:	ee17 2a90 	vmov	r2, s15
1000814e:	0fd2      	lsrs	r2, r2, #31
10008150:	ee07 2a10 	vmov	s14, r2
10008154:	ee31 5b04 	vadd.f64	d5, d1, d4
10008158:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
1000815c:	ee32 cb03 	vadd.f64	d12, d2, d3
10008160:	ed8d 7b52 	vstr	d7, [sp, #328]	@ 0x148
10008164:	ee25 7b09 	vmul.f64	d7, d5, d9
10008168:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000816c:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10008170:	ee3c cb07 	vadd.f64	d12, d12, d7
10008174:	ee07 5b48 	vmls.f64	d5, d7, d8
10008178:	9a08      	ldr	r2, [sp, #32]
1000817a:	eb02 010b 	add.w	r1, r2, fp
1000817e:	ee2c 7b09 	vmul.f64	d7, d12, d9
10008182:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10008186:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000818a:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000818e:	ee07 cb48 	vmls.f64	d12, d7, d8
10008192:	eebc 7bcc 	vcvt.u32.f64	s14, d12
10008196:	ee17 2a10 	vmov	r2, s14
1000819a:	0fd2      	lsrs	r2, r2, #31
1000819c:	ed8d 6b48 	vstr	d6, [sp, #288]	@ 0x120
100081a0:	ee07 2a10 	vmov	s14, r2
100081a4:	ee25 6b09 	vmul.f64	d6, d5, d9
100081a8:	ee21 0b09 	vmul.f64	d0, d1, d9
100081ac:	ed8d 1b42 	vstr	d1, [sp, #264]	@ 0x108
100081b0:	ed8d 6b5a 	vstr	d6, [sp, #360]	@ 0x168
100081b4:	ee22 ab09 	vmul.f64	d10, d2, d9
100081b8:	ee24 1b09 	vmul.f64	d1, d4, d9
100081bc:	ee23 bb09 	vmul.f64	d11, d3, d9
100081c0:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100081c4:	ee2c 6b09 	vmul.f64	d6, d12, d9
100081c8:	458b      	cmp	fp, r1
100081ca:	ed8d 2b40 	vstr	d2, [sp, #256]	@ 0x100
100081ce:	ed8d 3b4a 	vstr	d3, [sp, #296]	@ 0x128
100081d2:	ed8d 4b4c 	vstr	d4, [sp, #304]	@ 0x130
100081d6:	ed8d 0b46 	vstr	d0, [sp, #280]	@ 0x118
100081da:	ed8d 1b50 	vstr	d1, [sp, #320]	@ 0x140
100081de:	ed8d ab44 	vstr	d10, [sp, #272]	@ 0x110
100081e2:	ed8d bb4e 	vstr	d11, [sp, #312]	@ 0x138
100081e6:	ed8d 5b56 	vstr	d5, [sp, #344]	@ 0x158
100081ea:	ed8d cb54 	vstr	d12, [sp, #336]	@ 0x150
100081ee:	ed8d 6b58 	vstr	d6, [sp, #352]	@ 0x160
100081f2:	ed8d 7b5c 	vstr	d7, [sp, #368]	@ 0x170
100081f6:	f080 80ae 	bcs.w	10008356 <fndsa_vect_FFT_fp64_exact+0x2be>
100081fa:	4649      	mov	r1, r9
100081fc:	461c      	mov	r4, r3
100081fe:	4680      	mov	r8, r0
10008200:	9604      	str	r6, [sp, #16]
10008202:	eb0a 0509 	add.w	r5, sl, r9
10008206:	9306      	str	r3, [sp, #24]
10008208:	eb0a 0603 	add.w	r6, sl, r3
1000820c:	ed91 0b00 	vldr	d0, [r1]
10008210:	ed95 2b00 	vldr	d2, [r5]
10008214:	ed95 3b02 	vldr	d3, [r5, #8]
10008218:	ed91 1b02 	vldr	d1, [r1, #8]
1000821c:	a840      	add	r0, sp, #256	@ 0x100
1000821e:	f7ff fcb3 	bl	10007b88 <fp64e_cmul_prepared>
10008222:	ed94 db02 	vldr	d13, [r4, #8]
10008226:	ee3d 7b01 	vadd.f64	d7, d13, d1
1000822a:	ed96 ab00 	vldr	d10, [r6]
1000822e:	ed96 cb02 	vldr	d12, [r6, #8]
10008232:	ed94 bb00 	vldr	d11, [r4]
10008236:	ed87 1b02 	vstr	d1, [r7, #8]
1000823a:	ed87 0b00 	vstr	d0, [r7]
1000823e:	ed87 2b04 	vstr	d2, [r7, #16]
10008242:	ed87 3b06 	vstr	d3, [r7, #24]
10008246:	ee3c 6b03 	vadd.f64	d6, d12, d3
1000824a:	ee3d 5b08 	vadd.f64	d5, d13, d8
1000824e:	ee3a db02 	vadd.f64	d13, d10, d2
10008252:	ee3a ab08 	vadd.f64	d10, d10, d8
10008256:	ee3b fb00 	vadd.f64	d15, d11, d0
1000825a:	ee3a ab42 	vsub.f64	d10, d10, d2
1000825e:	ee26 4b09 	vmul.f64	d4, d6, d9
10008262:	ee3c cb08 	vadd.f64	d12, d12, d8
10008266:	ee3b bb08 	vadd.f64	d11, d11, d8
1000826a:	ee35 1b41 	vsub.f64	d1, d5, d1
1000826e:	ee3b bb40 	vsub.f64	d11, d11, d0
10008272:	eebc 0bc4 	vcvt.u32.f64	s0, d4
10008276:	ee3c 2b43 	vsub.f64	d2, d12, d3
1000827a:	ee27 5b09 	vmul.f64	d5, d7, d9
1000827e:	ee3a 3b4e 	vsub.f64	d3, d10, d14
10008282:	eebc abc5 	vcvt.u32.f64	s20, d5
10008286:	ee22 cb09 	vmul.f64	d12, d2, d9
1000828a:	ed8d 3b02 	vstr	d3, [sp, #8]
1000828e:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10008292:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10008296:	ee21 3b09 	vmul.f64	d3, d1, d9
1000829a:	ee3b 5b4e 	vsub.f64	d5, d11, d14
1000829e:	ee0a 7b48 	vmls.f64	d7, d10, d8
100082a2:	ed8d 5b00 	vstr	d5, [sp]
100082a6:	ee00 6b48 	vmls.f64	d6, d0, d8
100082aa:	eebc cbcc 	vcvt.u32.f64	s24, d12
100082ae:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100082b2:	eeb8 4b4c 	vcvt.f64.u32	d4, s24
100082b6:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100082ba:	eeb0 cb47 	vmov.f64	d12, d7
100082be:	ee3d bb00 	vadd.f64	d11, d13, d0
100082c2:	ed9d 7b00 	vldr	d7, [sp]
100082c6:	eeb0 db46 	vmov.f64	d13, d6
100082ca:	ed9d 6b02 	vldr	d6, [sp, #8]
100082ce:	ee3f 5b0a 	vadd.f64	d5, d15, d10
100082d2:	ee37 7b03 	vadd.f64	d7, d7, d3
100082d6:	ee36 6b04 	vadd.f64	d6, d6, d4
100082da:	ee25 0b09 	vmul.f64	d0, d5, d9
100082de:	ee2b ab09 	vmul.f64	d10, d11, d9
100082e2:	ee03 1b48 	vmls.f64	d1, d3, d8
100082e6:	ee04 2b48 	vmls.f64	d2, d4, d8
100082ea:	ee27 3b09 	vmul.f64	d3, d7, d9
100082ee:	ee26 4b09 	vmul.f64	d4, d6, d9
100082f2:	eebc 0bc0 	vcvt.u32.f64	s0, d0
100082f6:	eebc abca 	vcvt.u32.f64	s20, d10
100082fa:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100082fe:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10008302:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10008306:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
1000830a:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000830e:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10008312:	ee00 5b48 	vmls.f64	d5, d0, d8
10008316:	ee0a bb48 	vmls.f64	d11, d10, d8
1000831a:	ee03 7b48 	vmls.f64	d7, d3, d8
1000831e:	ee04 6b48 	vmls.f64	d6, d4, d8
10008322:	3410      	adds	r4, #16
10008324:	3610      	adds	r6, #16
10008326:	3110      	adds	r1, #16
10008328:	3510      	adds	r5, #16
1000832a:	45a1      	cmp	r9, r4
1000832c:	ed04 cb02 	vstr	d12, [r4, #-8]
10008330:	ed04 5b04 	vstr	d5, [r4, #-16]
10008334:	ed06 bb04 	vstr	d11, [r6, #-16]
10008338:	ed06 db02 	vstr	d13, [r6, #-8]
1000833c:	ed01 1b02 	vstr	d1, [r1, #-8]
10008340:	ed01 7b04 	vstr	d7, [r1, #-16]
10008344:	ed05 6b04 	vstr	d6, [r5, #-16]
10008348:	ed05 2b02 	vstr	d2, [r5, #-8]
1000834c:	f47f af5e 	bne.w	1000820c <fndsa_vect_FFT_fp64_exact+0x174>
10008350:	4640      	mov	r0, r8
10008352:	9e04      	ldr	r6, [sp, #16]
10008354:	9b06      	ldr	r3, [sp, #24]
10008356:	9a0a      	ldr	r2, [sp, #40]	@ 0x28
10008358:	3010      	adds	r0, #16
1000835a:	4282      	cmp	r2, r0
1000835c:	44b3      	add	fp, r6
1000835e:	eb03 1306 	add.w	r3, r3, r6, lsl #4
10008362:	eb09 1906 	add.w	r9, r9, r6, lsl #4
10008366:	f47f aedc 	bne.w	10008122 <fndsa_vect_FFT_fp64_exact+0x8a>
1000836a:	9c0c      	ldr	r4, [sp, #48]	@ 0x30
1000836c:	9b12      	ldr	r3, [sp, #72]	@ 0x48
1000836e:	3401      	adds	r4, #1
10008370:	429c      	cmp	r4, r3
10008372:	46d3      	mov	fp, sl
10008374:	f8dd c020 	ldr.w	ip, [sp, #32]
10008378:	f8dd 8038 	ldr.w	r8, [sp, #56]	@ 0x38
1000837c:	9e10      	ldr	r6, [sp, #64]	@ 0x40
1000837e:	f4ff aeb1 	bcc.w	100080e4 <fndsa_vect_FFT_fp64_exact+0x4c>
10008382:	4645      	mov	r5, r8
10008384:	e9dd 8416 	ldrd	r8, r4, [sp, #88]	@ 0x58
10008388:	2c02      	cmp	r4, #2
1000838a:	f8dd a050 	ldr.w	sl, [sp, #80]	@ 0x50
1000838e:	f000 840b 	beq.w	10008ba8 <fndsa_vect_FFT_fp64_exact+0xb10>
10008392:	4631      	mov	r1, r6
10008394:	2410      	movs	r4, #16
10008396:	ed9f eb0a 	vldr	d14, [pc, #40]	@ 100083c0 <fndsa_vect_FFT_fp64_exact+0x328>
1000839a:	ed9f fb0b 	vldr	d15, [pc, #44]	@ 100083c8 <fndsa_vect_FFT_fp64_exact+0x330>
1000839e:	f108 33ff 	add.w	r3, r8, #4294967295	@ 0xffffffff
100083a2:	fa04 f40a 	lsl.w	r4, r4, sl
100083a6:	ea4f 0658 	mov.w	r6, r8, lsr #1
100083aa:	089b      	lsrs	r3, r3, #2
100083ac:	f101 0740 	add.w	r7, r1, #64	@ 0x40
100083b0:	eb05 1606 	add.w	r6, r5, r6, lsl #4
100083b4:	eb07 1783 	add.w	r7, r7, r3, lsl #6
100083b8:	4425      	add	r5, r4
100083ba:	440c      	add	r4, r1
100083bc:	e00a      	b.n	100083d4 <fndsa_vect_FFT_fp64_exact+0x33c>
100083be:	bf00      	nop
100083c0:	00000000 	.word	0x00000000
100083c4:	3df00000 	.word	0x3df00000
100083c8:	00000000 	.word	0x00000000
100083cc:	41f00000 	.word	0x41f00000
100083d0:	300039a0 	.word	0x300039a0
100083d4:	ed91 7b02 	vldr	d7, [r1, #8]
100083d8:	ed91 3b06 	vldr	d3, [r1, #24]
100083dc:	ed8d 7b02 	vstr	d7, [sp, #8]
100083e0:	edd6 7a00 	vldr	s15, [r6]
100083e4:	ed94 2b04 	vldr	d2, [r4, #16]
100083e8:	ed91 5b04 	vldr	d5, [r1, #16]
100083ec:	ed91 4b00 	vldr	d4, [r1]
100083f0:	ed8d 3b00 	vstr	d3, [sp]
100083f4:	eeb8 3b67 	vcvt.f64.u32	d3, s15
100083f8:	edd6 7a02 	vldr	s15, [r6, #8]
100083fc:	6873      	ldr	r3, [r6, #4]
100083fe:	ed8d 2b06 	vstr	d2, [sp, #24]
10008402:	0fdb      	lsrs	r3, r3, #31
10008404:	ee02 3a10 	vmov	s4, r3
10008408:	68f3      	ldr	r3, [r6, #12]
1000840a:	ed94 6b02 	vldr	d6, [r4, #8]
1000840e:	0fdb      	lsrs	r3, r3, #31
10008410:	ed8d 5b0a 	vstr	d5, [sp, #40]	@ 0x28
10008414:	ee05 3a10 	vmov	s10, r3
10008418:	ed8d 4b0c 	vstr	d4, [sp, #48]	@ 0x30
1000841c:	eeb8 4b67 	vcvt.f64.u32	d4, s15
10008420:	edd6 7a01 	vldr	s15, [r6, #4]
10008424:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
10008428:	ed8d 6b12 	vstr	d6, [sp, #72]	@ 0x48
1000842c:	eeb8 6b67 	vcvt.f64.u32	d6, s15
10008430:	edd6 7a03 	vldr	s15, [r6, #12]
10008434:	ed94 bb00 	vldr	d11, [r4]
10008438:	eeb8 7b67 	vcvt.f64.u32	d7, s15
1000843c:	ed94 1b06 	vldr	d1, [r4, #24]
10008440:	eeb8 2bc2 	vcvt.f64.s32	d2, s4
10008444:	ed94 0b0c 	vldr	d0, [r4, #48]	@ 0x30
10008448:	ed8d 3b42 	vstr	d3, [sp, #264]	@ 0x108
1000844c:	ed8d 4b4c 	vstr	d4, [sp, #304]	@ 0x130
10008450:	ed8d 5b52 	vstr	d5, [sp, #328]	@ 0x148
10008454:	ee33 5b04 	vadd.f64	d5, d3, d4
10008458:	ed91 cb0c 	vldr	d12, [r1, #48]	@ 0x30
1000845c:	ed91 db0e 	vldr	d13, [r1, #56]	@ 0x38
10008460:	ed8d bb08 	vstr	d11, [sp, #32]
10008464:	ed8d 1b04 	vstr	d1, [sp, #16]
10008468:	ee23 3b0e 	vmul.f64	d3, d3, d14
1000846c:	ee24 4b0e 	vmul.f64	d4, d4, d14
10008470:	ed8d 0b10 	vstr	d0, [sp, #64]	@ 0x40
10008474:	ed8d 2b48 	vstr	d2, [sp, #288]	@ 0x120
10008478:	ed8d 6b40 	vstr	d6, [sp, #256]	@ 0x100
1000847c:	ed8d 7b4a 	vstr	d7, [sp, #296]	@ 0x128
10008480:	ed8d 3b46 	vstr	d3, [sp, #280]	@ 0x118
10008484:	ed8d 4b50 	vstr	d4, [sp, #320]	@ 0x140
10008488:	ee25 4b0e 	vmul.f64	d4, d5, d14
1000848c:	eefc 3bc4 	vcvt.u32.f64	s7, d4
10008490:	ee36 4b07 	vadd.f64	d4, d6, d7
10008494:	ee27 7b0e 	vmul.f64	d7, d7, d14
10008498:	ed8d 7b4e 	vstr	d7, [sp, #312]	@ 0x138
1000849c:	eeb8 7b63 	vcvt.f64.u32	d7, s7
100084a0:	ee34 4b07 	vadd.f64	d4, d4, d7
100084a4:	ee07 5b4f 	vmls.f64	d5, d7, d15
100084a8:	ee24 7b0e 	vmul.f64	d7, d4, d14
100084ac:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100084b0:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100084b4:	ee07 4b4f 	vmls.f64	d4, d7, d15
100084b8:	eebc 7bc4 	vcvt.u32.f64	s14, d4
100084bc:	ee17 3a10 	vmov	r3, s14
100084c0:	0fdb      	lsrs	r3, r3, #31
100084c2:	ed94 8b0e 	vldr	d8, [r4, #56]	@ 0x38
100084c6:	ee07 3a10 	vmov	s14, r3
100084ca:	ed8d 5b56 	vstr	d5, [sp, #344]	@ 0x158
100084ce:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100084d2:	ed8d 4b54 	vstr	d4, [sp, #336]	@ 0x150
100084d6:	ee24 4b0e 	vmul.f64	d4, d4, d14
100084da:	ed91 0b08 	vldr	d0, [r1, #32]
100084de:	ed91 1b0a 	vldr	d1, [r1, #40]	@ 0x28
100084e2:	ed94 2b08 	vldr	d2, [r4, #32]
100084e6:	a840      	add	r0, sp, #256	@ 0x100
100084e8:	ed94 3b0a 	vldr	d3, [r4, #40]	@ 0x28
100084ec:	ee26 6b0e 	vmul.f64	d6, d6, d14
100084f0:	ed8d 4b58 	vstr	d4, [sp, #352]	@ 0x160
100084f4:	ed8d 7b5c 	vstr	d7, [sp, #368]	@ 0x170
100084f8:	ee25 5b0e 	vmul.f64	d5, d5, d14
100084fc:	ed8d 6b44 	vstr	d6, [sp, #272]	@ 0x110
10008500:	ed8d 5b5a 	vstr	d5, [sp, #360]	@ 0x168
10008504:	ed8d 8b0e 	vstr	d8, [sp, #56]	@ 0x38
10008508:	f7ff fb3e 	bl	10007b88 <fp64e_cmul_prepared>
1000850c:	eeb0 9b40 	vmov.f64	d9, d0
10008510:	eeb0 8b42 	vmov.f64	d8, d2
10008514:	ed9d 2b10 	vldr	d2, [sp, #64]	@ 0x40
10008518:	eeb0 ab43 	vmov.f64	d10, d3
1000851c:	ed9d 3b0e 	vldr	d3, [sp, #56]	@ 0x38
10008520:	eeb0 bb41 	vmov.f64	d11, d1
10008524:	ed8d 9b20 	vstr	d9, [sp, #128]	@ 0x80
10008528:	eeb0 1b4d 	vmov.f64	d1, d13
1000852c:	ed8d bb22 	vstr	d11, [sp, #136]	@ 0x88
10008530:	eeb0 0b4c 	vmov.f64	d0, d12
10008534:	ed8d 8b24 	vstr	d8, [sp, #144]	@ 0x90
10008538:	ed8d ab26 	vstr	d10, [sp, #152]	@ 0x98
1000853c:	f7ff fb24 	bl	10007b88 <fp64e_cmul_prepared>
10008540:	edd5 7a00 	vldr	s15, [r5]
10008544:	eeb8 5b67 	vcvt.f64.u32	d5, s15
10008548:	edd5 7a02 	vldr	s15, [r5, #8]
1000854c:	eeb8 6b67 	vcvt.f64.u32	d6, s15
10008550:	edd5 7a01 	vldr	s15, [r5, #4]
10008554:	686b      	ldr	r3, [r5, #4]
10008556:	eeb8 cb67 	vcvt.f64.u32	d12, s15
1000855a:	0fdb      	lsrs	r3, r3, #31
1000855c:	ee04 3a10 	vmov	s8, r3
10008560:	68eb      	ldr	r3, [r5, #12]
10008562:	edd5 7a03 	vldr	s15, [r5, #12]
10008566:	0fdb      	lsrs	r3, r3, #31
10008568:	ee07 3a10 	vmov	s14, r3
1000856c:	eeb8 db67 	vcvt.f64.u32	d13, s15
10008570:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10008574:	ed8d 6b4c 	vstr	d6, [sp, #304]	@ 0x130
10008578:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
1000857c:	ed8d 7b52 	vstr	d7, [sp, #328]	@ 0x148
10008580:	ee35 7b06 	vadd.f64	d7, d5, d6
10008584:	ed8d 4b48 	vstr	d4, [sp, #288]	@ 0x120
10008588:	ed8d 5b42 	vstr	d5, [sp, #264]	@ 0x108
1000858c:	ed9d 4b02 	vldr	d4, [sp, #8]
10008590:	ee26 6b0e 	vmul.f64	d6, d6, d14
10008594:	ee25 5b0e 	vmul.f64	d5, d5, d14
10008598:	ed8d 6b50 	vstr	d6, [sp, #320]	@ 0x140
1000859c:	ee27 6b0e 	vmul.f64	d6, d7, d14
100085a0:	ed8d 5b46 	vstr	d5, [sp, #280]	@ 0x118
100085a4:	ee34 5b0f 	vadd.f64	d5, d4, d15
100085a8:	ee34 4b0b 	vadd.f64	d4, d4, d11
100085ac:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100085b0:	ed8d 4b10 	vstr	d4, [sp, #64]	@ 0x40
100085b4:	eeb8 4b46 	vcvt.f64.u32	d4, s12
100085b8:	ed9d 6b12 	vldr	d6, [sp, #72]	@ 0x48
100085bc:	ee04 7b4f 	vmls.f64	d7, d4, d15
100085c0:	ed8d 7b56 	vstr	d7, [sp, #344]	@ 0x158
100085c4:	ee27 7b0e 	vmul.f64	d7, d7, d14
100085c8:	ed8d 7b5a 	vstr	d7, [sp, #360]	@ 0x168
100085cc:	ee36 7b0f 	vadd.f64	d7, d6, d15
100085d0:	ed8d 0b28 	vstr	d0, [sp, #160]	@ 0xa0
100085d4:	ed8d 1b2a 	vstr	d1, [sp, #168]	@ 0xa8
100085d8:	ed8d 2b2c 	vstr	d2, [sp, #176]	@ 0xb0
100085dc:	ed8d 3b2e 	vstr	d3, [sp, #184]	@ 0xb8
100085e0:	ee3a 6b06 	vadd.f64	d6, d10, d6
100085e4:	ee37 ab4a 	vsub.f64	d10, d7, d10
100085e8:	ed8d cb40 	vstr	d12, [sp, #256]	@ 0x100
100085ec:	ed8d db4a 	vstr	d13, [sp, #296]	@ 0x128
100085f0:	ed8d 6b0e 	vstr	d6, [sp, #56]	@ 0x38
100085f4:	ed9d 6b00 	vldr	d6, [sp]
100085f8:	ee36 7b0f 	vadd.f64	d7, d6, d15
100085fc:	ee36 6b01 	vadd.f64	d6, d6, d1
10008600:	ee37 7b41 	vsub.f64	d7, d7, d1
10008604:	ed9d 1b04 	vldr	d1, [sp, #16]
10008608:	ee35 bb4b 	vsub.f64	d11, d5, d11
1000860c:	ed8d 7b02 	vstr	d7, [sp, #8]
10008610:	ee31 5b0f 	vadd.f64	d5, d1, d15
10008614:	ee31 7b03 	vadd.f64	d7, d1, d3
10008618:	ee35 3b43 	vsub.f64	d3, d5, d3
1000861c:	ee3c 5b0d 	vadd.f64	d5, d12, d13
10008620:	ee2c cb0e 	vmul.f64	d12, d12, d14
10008624:	ee35 1b04 	vadd.f64	d1, d5, d4
10008628:	ed8d cb44 	vstr	d12, [sp, #272]	@ 0x110
1000862c:	ee26 5b0e 	vmul.f64	d5, d6, d14
10008630:	eefc 4bc5 	vcvt.u32.f64	s9, d5
10008634:	ee27 5b0e 	vmul.f64	d5, d7, d14
10008638:	eeb8 cb64 	vcvt.f64.u32	d12, s9
1000863c:	eefc 5bc5 	vcvt.u32.f64	s11, d5
10008640:	ee2d db0e 	vmul.f64	d13, d13, d14
10008644:	ed9d 4b0e 	vldr	d4, [sp, #56]	@ 0x38
10008648:	ed8d 1b14 	vstr	d1, [sp, #80]	@ 0x50
1000864c:	eeb0 1b46 	vmov.f64	d1, d6
10008650:	ed8d db4e 	vstr	d13, [sp, #312]	@ 0x138
10008654:	eeb8 db65 	vcvt.f64.u32	d13, s11
10008658:	ee24 6b0e 	vmul.f64	d6, d4, d14
1000865c:	ed9d 5b10 	vldr	d5, [sp, #64]	@ 0x40
10008660:	ed8d 3b00 	vstr	d3, [sp]
10008664:	eeb0 3b47 	vmov.f64	d3, d7
10008668:	ee25 7b0e 	vmul.f64	d7, d5, d14
1000866c:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10008670:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10008674:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10008678:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000867c:	ee06 4b4f 	vmls.f64	d4, d6, d15
10008680:	ed8d 6b04 	vstr	d6, [sp, #16]
10008684:	ee07 5b4f 	vmls.f64	d5, d7, d15
10008688:	ed8d 4b0e 	vstr	d4, [sp, #56]	@ 0x38
1000868c:	ed9d 4b0c 	vldr	d4, [sp, #48]	@ 0x30
10008690:	ee2b 6b0e 	vmul.f64	d6, d11, d14
10008694:	ed8d 5b12 	vstr	d5, [sp, #72]	@ 0x48
10008698:	ee34 5b0f 	vadd.f64	d5, d4, d15
1000869c:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100086a0:	ee34 4b09 	vadd.f64	d4, d4, d9
100086a4:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100086a8:	ee34 4b07 	vadd.f64	d4, d4, d7
100086ac:	ee35 5b49 	vsub.f64	d5, d5, d9
100086b0:	eeb7 7b00 	vmov.f64	d7, #112	@ 0x3f800000  1.0
100086b4:	eeb0 9b4b 	vmov.f64	d9, d11
100086b8:	ee35 5b47 	vsub.f64	d5, d5, d7
100086bc:	ed9d bb08 	vldr	d11, [sp, #32]
100086c0:	ee06 9b4f 	vmls.f64	d9, d6, d15
100086c4:	ee2a 7b0e 	vmul.f64	d7, d10, d14
100086c8:	ed8d 9b0c 	vstr	d9, [sp, #48]	@ 0x30
100086cc:	ee35 9b06 	vadd.f64	d9, d5, d6
100086d0:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100086d4:	ee3b 6b0f 	vadd.f64	d6, d11, d15
100086d8:	ee3b 5b08 	vadd.f64	d5, d11, d8
100086dc:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100086e0:	eeb7 bb00 	vmov.f64	d11, #112	@ 0x3f800000  1.0
100086e4:	ee36 6b48 	vsub.f64	d6, d6, d8
100086e8:	ed9d 8b04 	vldr	d8, [sp, #16]
100086ec:	ee07 ab4f 	vmls.f64	d10, d7, d15
100086f0:	ee36 6b4b 	vsub.f64	d6, d6, d11
100086f4:	ed8d ab08 	vstr	d10, [sp, #32]
100086f8:	ee35 8b08 	vadd.f64	d8, d5, d8
100086fc:	ee36 ab07 	vadd.f64	d10, d6, d7
10008700:	ed9d 6b02 	vldr	d6, [sp, #8]
10008704:	ee26 5b0e 	vmul.f64	d5, d6, d14
10008708:	ed9d 6b0a 	vldr	d6, [sp, #40]	@ 0x28
1000870c:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10008710:	ee36 7b0f 	vadd.f64	d7, d6, d15
10008714:	ee36 6b00 	vadd.f64	d6, d6, d0
10008718:	ee37 7b40 	vsub.f64	d7, d7, d0
1000871c:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10008720:	ee36 0b0c 	vadd.f64	d0, d6, d12
10008724:	ed9d 6b02 	vldr	d6, [sp, #8]
10008728:	ee05 6b4f 	vmls.f64	d6, d5, d15
1000872c:	ee0c 1b4f 	vmls.f64	d1, d12, d15
10008730:	ed8d 6b02 	vstr	d6, [sp, #8]
10008734:	ee37 7b4b 	vsub.f64	d7, d7, d11
10008738:	eeb0 cb4b 	vmov.f64	d12, d11
1000873c:	ee37 5b05 	vadd.f64	d5, d7, d5
10008740:	ed9d bb00 	vldr	d11, [sp]
10008744:	ed9d 6b06 	vldr	d6, [sp, #24]
10008748:	ee2b bb0e 	vmul.f64	d11, d11, d14
1000874c:	ee36 7b0f 	vadd.f64	d7, d6, d15
10008750:	eebc bbcb 	vcvt.u32.f64	s22, d11
10008754:	ee36 6b02 	vadd.f64	d6, d6, d2
10008758:	ee37 7b42 	vsub.f64	d7, d7, d2
1000875c:	ee36 2b0d 	vadd.f64	d2, d6, d13
10008760:	ee37 7b4c 	vsub.f64	d7, d7, d12
10008764:	ee0d 3b4f 	vmls.f64	d3, d13, d15
10008768:	ed9d db00 	vldr	d13, [sp]
1000876c:	eeb8 bb4b 	vcvt.f64.u32	d11, s22
10008770:	ee0b db4f 	vmls.f64	d13, d11, d15
10008774:	ee37 bb0b 	vadd.f64	d11, d7, d11
10008778:	ed9d 7b14 	vldr	d7, [sp, #80]	@ 0x50
1000877c:	ee27 6b0e 	vmul.f64	d6, d7, d14
10008780:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10008784:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10008788:	ee06 7b4f 	vmls.f64	d7, d6, d15
1000878c:	eefc 6bc7 	vcvt.u32.f64	s13, d7
10008790:	ed8d 7b54 	vstr	d7, [sp, #336]	@ 0x150
10008794:	ee16 3a90 	vmov	r3, s13
10008798:	ee27 7b0e 	vmul.f64	d7, d7, d14
1000879c:	0fdb      	lsrs	r3, r3, #31
1000879e:	ed8d 7b58 	vstr	d7, [sp, #352]	@ 0x160
100087a2:	ee07 3a10 	vmov	s14, r3
100087a6:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100087aa:	ee28 6b0e 	vmul.f64	d6, d8, d14
100087ae:	ed8d 7b5c 	vstr	d7, [sp, #368]	@ 0x170
100087b2:	ee24 7b0e 	vmul.f64	d7, d4, d14
100087b6:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100087ba:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100087be:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100087c2:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100087c6:	ee06 8b4f 	vmls.f64	d8, d6, d15
100087ca:	ee07 4b4f 	vmls.f64	d4, d7, d15
100087ce:	ed8d 8b0a 	vstr	d8, [sp, #40]	@ 0x28
100087d2:	ee29 7b0e 	vmul.f64	d7, d9, d14
100087d6:	ee22 6b0e 	vmul.f64	d6, d2, d14
100087da:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100087de:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100087e2:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100087e6:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100087ea:	ee07 9b4f 	vmls.f64	d9, d7, d15
100087ee:	ee25 7b0e 	vmul.f64	d7, d5, d14
100087f2:	ee06 2b4f 	vmls.f64	d2, d6, d15
100087f6:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100087fa:	ee2a 6b0e 	vmul.f64	d6, d10, d14
100087fe:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10008802:	eeb0 8b45 	vmov.f64	d8, d5
10008806:	ee20 cb0e 	vmul.f64	d12, d0, d14
1000880a:	ee07 8b4f 	vmls.f64	d8, d7, d15
1000880e:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10008812:	ee2b 7b0e 	vmul.f64	d7, d11, d14
10008816:	eebc cbcc 	vcvt.u32.f64	s24, d12
1000881a:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000881e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10008822:	eeb8 cb4c 	vcvt.f64.u32	d12, s24
10008826:	ee06 ab4f 	vmls.f64	d10, d6, d15
1000882a:	ed8d 4b10 	vstr	d4, [sp, #64]	@ 0x40
1000882e:	ed8d db00 	vstr	d13, [sp]
10008832:	ed8d 9b06 	vstr	d9, [sp, #24]
10008836:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000883a:	ee0c 0b4f 	vmls.f64	d0, d12, d15
1000883e:	ed8d ab04 	vstr	d10, [sp, #16]
10008842:	ee07 bb4f 	vmls.f64	d11, d7, d15
10008846:	f7ff f99f 	bl	10007b88 <fp64e_cmul_prepared>
1000884a:	edd5 7a04 	vldr	s15, [r5, #16]
1000884e:	696b      	ldr	r3, [r5, #20]
10008850:	eeb0 db42 	vmov.f64	d13, d2
10008854:	0fdb      	lsrs	r3, r3, #31
10008856:	eeb0 2b4b 	vmov.f64	d2, d11
1000885a:	ee0b 3a10 	vmov	s22, r3
1000885e:	69eb      	ldr	r3, [r5, #28]
10008860:	eeb0 cb40 	vmov.f64	d12, d0
10008864:	0fdb      	lsrs	r3, r3, #31
10008866:	eeb0 0b48 	vmov.f64	d0, d8
1000886a:	ee05 3a10 	vmov	s10, r3
1000886e:	eeb8 8b67 	vcvt.f64.u32	d8, s15
10008872:	edd5 7a06 	vldr	s15, [r5, #24]
10008876:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
1000887a:	ed8d 8b42 	vstr	d8, [sp, #264]	@ 0x108
1000887e:	eeb8 4b67 	vcvt.f64.u32	d4, s15
10008882:	edd5 7a05 	vldr	s15, [r5, #20]
10008886:	ed8d 5b52 	vstr	d5, [sp, #328]	@ 0x148
1000888a:	ee38 5b04 	vadd.f64	d5, d8, d4
1000888e:	ee28 8b0e 	vmul.f64	d8, d8, d14
10008892:	eeb8 6b67 	vcvt.f64.u32	d6, s15
10008896:	ed8d 8b46 	vstr	d8, [sp, #280]	@ 0x118
1000889a:	ee25 8b0e 	vmul.f64	d8, d5, d14
1000889e:	edd5 7a07 	vldr	s15, [r5, #28]
100088a2:	ed8d 4b4c 	vstr	d4, [sp, #304]	@ 0x130
100088a6:	eeb8 7b67 	vcvt.f64.u32	d7, s15
100088aa:	eebc 8bc8 	vcvt.u32.f64	s16, d8
100088ae:	ee24 4b0e 	vmul.f64	d4, d4, d14
100088b2:	eeb8 8b48 	vcvt.f64.u32	d8, s16
100088b6:	ed8d 4b50 	vstr	d4, [sp, #320]	@ 0x140
100088ba:	ee36 4b07 	vadd.f64	d4, d6, d7
100088be:	ed8d 7b4a 	vstr	d7, [sp, #296]	@ 0x128
100088c2:	ee34 4b08 	vadd.f64	d4, d4, d8
100088c6:	ee27 7b0e 	vmul.f64	d7, d7, d14
100088ca:	ed8d 7b4e 	vstr	d7, [sp, #312]	@ 0x138
100088ce:	ee24 7b0e 	vmul.f64	d7, d4, d14
100088d2:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100088d6:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100088da:	ee07 4b4f 	vmls.f64	d4, d7, d15
100088de:	eebc 7bc4 	vcvt.u32.f64	s14, d4
100088e2:	ee17 3a10 	vmov	r3, s14
100088e6:	0fdb      	lsrs	r3, r3, #31
100088e8:	ee08 5b4f 	vmls.f64	d5, d8, d15
100088ec:	ed8d 6b40 	vstr	d6, [sp, #256]	@ 0x100
100088f0:	ee07 3a10 	vmov	s14, r3
100088f4:	eeb0 ab41 	vmov.f64	d10, d1
100088f8:	eeb0 9b43 	vmov.f64	d9, d3
100088fc:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10008900:	eeb8 bbcb 	vcvt.f64.s32	d11, s22
10008904:	ee26 6b0e 	vmul.f64	d6, d6, d14
10008908:	ed8d 5b56 	vstr	d5, [sp, #344]	@ 0x158
1000890c:	ed8d 4b54 	vstr	d4, [sp, #336]	@ 0x150
10008910:	ed9d 1b02 	vldr	d1, [sp, #8]
10008914:	ed9d 3b00 	vldr	d3, [sp]
10008918:	ed8d cb30 	vstr	d12, [sp, #192]	@ 0xc0
1000891c:	ed8d ab32 	vstr	d10, [sp, #200]	@ 0xc8
10008920:	ed8d db34 	vstr	d13, [sp, #208]	@ 0xd0
10008924:	ed8d 9b36 	vstr	d9, [sp, #216]	@ 0xd8
10008928:	ee25 5b0e 	vmul.f64	d5, d5, d14
1000892c:	ee24 4b0e 	vmul.f64	d4, d4, d14
10008930:	ed8d bb48 	vstr	d11, [sp, #288]	@ 0x120
10008934:	ed8d 6b44 	vstr	d6, [sp, #272]	@ 0x110
10008938:	ed8d 5b5a 	vstr	d5, [sp, #360]	@ 0x168
1000893c:	ed8d 4b58 	vstr	d4, [sp, #352]	@ 0x160
10008940:	ed8d 7b5c 	vstr	d7, [sp, #368]	@ 0x170
10008944:	f7ff f920 	bl	10007b88 <fp64e_cmul_prepared>
10008948:	ed9d 5b12 	vldr	d5, [sp, #72]	@ 0x48
1000894c:	ee35 6b0a 	vadd.f64	d6, d5, d10
10008950:	ed9d 7b0e 	vldr	d7, [sp, #56]	@ 0x38
10008954:	ee35 4b0f 	vadd.f64	d4, d5, d15
10008958:	ed9d 5b0c 	vldr	d5, [sp, #48]	@ 0x30
1000895c:	ed8d 1b3a 	vstr	d1, [sp, #232]	@ 0xe8
10008960:	ee37 8b0f 	vadd.f64	d8, d7, d15
10008964:	ee35 bb0f 	vadd.f64	d11, d5, d15
10008968:	ee37 7b09 	vadd.f64	d7, d7, d9
1000896c:	ee38 8b49 	vsub.f64	d8, d8, d9
10008970:	ee3b bb41 	vsub.f64	d11, d11, d1
10008974:	ee35 9b01 	vadd.f64	d9, d5, d1
10008978:	ed9d 1b08 	vldr	d1, [sp, #32]
1000897c:	ee31 5b0f 	vadd.f64	d5, d1, d15
10008980:	ee34 4b4a 	vsub.f64	d4, d4, d10
10008984:	ee35 5b43 	vsub.f64	d5, d5, d3
10008988:	ee31 ab03 	vadd.f64	d10, d1, d3
1000898c:	ed8d 5b00 	vstr	d5, [sp]
10008990:	ed8d 3b3e 	vstr	d3, [sp, #248]	@ 0xf8
10008994:	ee26 5b0e 	vmul.f64	d5, d6, d14
10008998:	ee27 3b0e 	vmul.f64	d3, d7, d14
1000899c:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100089a0:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100089a4:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100089a8:	eeb8 1b43 	vcvt.f64.u32	d1, s6
100089ac:	ed9d 3b10 	vldr	d3, [sp, #64]	@ 0x40
100089b0:	ee01 7b4f 	vmls.f64	d7, d1, d15
100089b4:	ee05 6b4f 	vmls.f64	d6, d5, d15
100089b8:	ed8d 7b02 	vstr	d7, [sp, #8]
100089bc:	ee24 7b0e 	vmul.f64	d7, d4, d14
100089c0:	ed81 6b02 	vstr	d6, [r1, #8]
100089c4:	ee33 6b0f 	vadd.f64	d6, d3, d15
100089c8:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100089cc:	ee33 3b0c 	vadd.f64	d3, d3, d12
100089d0:	ee36 6b4c 	vsub.f64	d6, d6, d12
100089d4:	eeb7 cb00 	vmov.f64	d12, #112	@ 0x3f800000  1.0
100089d8:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100089dc:	ee36 6b4c 	vsub.f64	d6, d6, d12
100089e0:	eeb0 cb44 	vmov.f64	d12, d4
100089e4:	ed9d 4b0a 	vldr	d4, [sp, #40]	@ 0x28
100089e8:	ee07 cb4f 	vmls.f64	d12, d7, d15
100089ec:	ed8d cb08 	vstr	d12, [sp, #32]
100089f0:	ee36 cb07 	vadd.f64	d12, d6, d7
100089f4:	ee28 7b0e 	vmul.f64	d7, d8, d14
100089f8:	ee33 3b05 	vadd.f64	d3, d3, d5
100089fc:	ee34 6b0f 	vadd.f64	d6, d4, d15
10008a00:	ee34 5b0d 	vadd.f64	d5, d4, d13
10008a04:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10008a08:	ee35 1b01 	vadd.f64	d1, d5, d1
10008a0c:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10008a10:	ee36 6b4d 	vsub.f64	d6, d6, d13
10008a14:	ed9d 4b06 	vldr	d4, [sp, #24]
10008a18:	eeb7 5b00 	vmov.f64	d5, #112	@ 0x3f800000  1.0
10008a1c:	ee07 8b4f 	vmls.f64	d8, d7, d15
10008a20:	ee36 6b45 	vsub.f64	d6, d6, d5
10008a24:	eeb0 db48 	vmov.f64	d13, d8
10008a28:	ee2b 5b0e 	vmul.f64	d5, d11, d14
10008a2c:	ee36 8b07 	vadd.f64	d8, d6, d7
10008a30:	eefc 5bc5 	vcvt.u32.f64	s11, d5
10008a34:	ee29 7b0e 	vmul.f64	d7, d9, d14
10008a38:	edcd 5a0a 	vstr	s11, [sp, #40]	@ 0x28
10008a3c:	ed8d 0b38 	vstr	d0, [sp, #224]	@ 0xe0
10008a40:	ee34 5b0f 	vadd.f64	d5, d4, d15
10008a44:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10008a48:	ee34 4b00 	vadd.f64	d4, d4, d0
10008a4c:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10008a50:	ee35 5b40 	vsub.f64	d5, d5, d0
10008a54:	ee07 9b4f 	vmls.f64	d9, d7, d15
10008a58:	ee34 0b07 	vadd.f64	d0, d4, d7
10008a5c:	eddd 7a0a 	vldr	s15, [sp, #40]	@ 0x28
10008a60:	eeb7 4b00 	vmov.f64	d4, #112	@ 0x3f800000  1.0
10008a64:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10008a68:	ee35 5b44 	vsub.f64	d5, d5, d4
10008a6c:	ee07 bb4f 	vmls.f64	d11, d7, d15
10008a70:	ee2a 6b0e 	vmul.f64	d6, d10, d14
10008a74:	ee35 5b07 	vadd.f64	d5, d5, d7
10008a78:	ed9d 7b00 	vldr	d7, [sp]
10008a7c:	ed9d 4b04 	vldr	d4, [sp, #16]
10008a80:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10008a84:	ee27 7b0e 	vmul.f64	d7, d7, d14
10008a88:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10008a8c:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10008a90:	ee06 ab4f 	vmls.f64	d10, d6, d15
10008a94:	edcd 7a06 	vstr	s15, [sp, #24]
10008a98:	ed8d 2b3c 	vstr	d2, [sp, #240]	@ 0xf0
10008a9c:	ee34 7b0f 	vadd.f64	d7, d4, d15
10008aa0:	ee34 4b02 	vadd.f64	d4, d4, d2
10008aa4:	ee37 7b42 	vsub.f64	d7, d7, d2
10008aa8:	ee34 4b06 	vadd.f64	d4, d4, d6
10008aac:	eddd 6a06 	vldr	s13, [sp, #24]
10008ab0:	eeb7 2b00 	vmov.f64	d2, #112	@ 0x3f800000  1.0
10008ab4:	eeb8 6b66 	vcvt.f64.u32	d6, s13
10008ab8:	ee37 7b42 	vsub.f64	d7, d7, d2
10008abc:	ed9d 2b00 	vldr	d2, [sp]
10008ac0:	ee06 2b4f 	vmls.f64	d2, d6, d15
10008ac4:	ed8d 2b00 	vstr	d2, [sp]
10008ac8:	ee23 2b0e 	vmul.f64	d2, d3, d14
10008acc:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10008ad0:	ee37 7b06 	vadd.f64	d7, d7, d6
10008ad4:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10008ad8:	ee21 6b0e 	vmul.f64	d6, d1, d14
10008adc:	ee02 3b4f 	vmls.f64	d3, d2, d15
10008ae0:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10008ae4:	ed81 3b00 	vstr	d3, [r1]
10008ae8:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10008aec:	ed9d 3b02 	vldr	d3, [sp, #8]
10008af0:	ee06 1b4f 	vmls.f64	d1, d6, d15
10008af4:	ed84 3b02 	vstr	d3, [r4, #8]
10008af8:	ed9d 6b08 	vldr	d6, [sp, #32]
10008afc:	ee2c 3b0e 	vmul.f64	d3, d12, d14
10008b00:	ed84 1b00 	vstr	d1, [r4]
10008b04:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10008b08:	ed81 6b06 	vstr	d6, [r1, #24]
10008b0c:	ee28 6b0e 	vmul.f64	d6, d8, d14
10008b10:	ed9d 2b00 	vldr	d2, [sp]
10008b14:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10008b18:	eefc 6bc6 	vcvt.u32.f64	s13, d6
10008b1c:	ee03 cb4f 	vmls.f64	d12, d3, d15
10008b20:	eeb8 3b66 	vcvt.f64.u32	d3, s13
10008b24:	ee20 6b0e 	vmul.f64	d6, d0, d14
10008b28:	ee24 1b0e 	vmul.f64	d1, d4, d14
10008b2c:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10008b30:	ee03 8b4f 	vmls.f64	d8, d3, d15
10008b34:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10008b38:	ee25 3b0e 	vmul.f64	d3, d5, d14
10008b3c:	ee06 0b4f 	vmls.f64	d0, d6, d15
10008b40:	ee27 6b0e 	vmul.f64	d6, d7, d14
10008b44:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10008b48:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10008b4c:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10008b50:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10008b54:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10008b58:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10008b5c:	ee01 4b4f 	vmls.f64	d4, d1, d15
10008b60:	ee03 5b4f 	vmls.f64	d5, d3, d15
10008b64:	ee06 7b4f 	vmls.f64	d7, d6, d15
10008b68:	3140      	adds	r1, #64	@ 0x40
10008b6a:	428f      	cmp	r7, r1
10008b6c:	f104 0440 	add.w	r4, r4, #64	@ 0x40
10008b70:	ed01 cb0c 	vstr	d12, [r1, #-48]	@ 0xffffffd0
10008b74:	f106 0610 	add.w	r6, r6, #16
10008b78:	ed04 db0a 	vstr	d13, [r4, #-40]	@ 0xffffffd8
10008b7c:	ed04 8b0c 	vstr	d8, [r4, #-48]	@ 0xffffffd0
10008b80:	f105 0520 	add.w	r5, r5, #32
10008b84:	ed01 9b06 	vstr	d9, [r1, #-24]	@ 0xffffffe8
10008b88:	ed01 0b08 	vstr	d0, [r1, #-32]	@ 0xffffffe0
10008b8c:	ed04 ab06 	vstr	d10, [r4, #-24]	@ 0xffffffe8
10008b90:	ed04 4b08 	vstr	d4, [r4, #-32]	@ 0xffffffe0
10008b94:	ed01 5b04 	vstr	d5, [r1, #-16]
10008b98:	ed01 bb02 	vstr	d11, [r1, #-8]
10008b9c:	ed04 2b02 	vstr	d2, [r4, #-8]
10008ba0:	ed04 7b04 	vstr	d7, [r4, #-16]
10008ba4:	f47f ac16 	bne.w	100083d4 <fndsa_vect_FFT_fp64_exact+0x33c>
10008ba8:	b05f      	add	sp, #380	@ 0x17c
10008baa:	ecbd 8b10 	vpop	{d8-d15}
10008bae:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10008bb2:	2803      	cmp	r0, #3
10008bb4:	f1a0 0e02 	sub.w	lr, r0, #2
10008bb8:	f47f aa81 	bne.w	100080be <fndsa_vect_FFT_fp64_exact+0x26>
10008bbc:	4d01      	ldr	r5, [pc, #4]	@ (10008bc4 <fndsa_vect_FFT_fp64_exact+0xb2c>)
10008bbe:	f7ff bbe8 	b.w	10008392 <fndsa_vect_FFT_fp64_exact+0x2fa>
10008bc2:	bf00      	nop
10008bc4:	300039a0 	.word	0x300039a0

