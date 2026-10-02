10002148 <fndsa_vect_iFFT_fp64_exact>:
10002148:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
1000214c:	ed2d 8b10 	vpush	{d8-d15}
10002150:	2802      	cmp	r0, #2
10002152:	460d      	mov	r5, r1
10002154:	b0e5      	sub	sp, #404	@ 0x194
10002156:	f100 3aff 	add.w	sl, r0, #4294967295	@ 0xffffffff
1000215a:	f241 831c 	bls.w	10003796 <fndsa_vect_iFFT_fp64_exact+0x164e>
1000215e:	2301      	movs	r3, #1
10002160:	2410      	movs	r4, #16
10002162:	4683      	mov	fp, r0
10002164:	ed9f fbf8 	vldr	d15, [pc, #992]	@ 10002548 <fndsa_vect_iFFT_fp64_exact+0x400>
10002168:	ed9f ebf9 	vldr	d14, [pc, #996]	@ 10002550 <fndsa_vect_iFFT_fp64_exact+0x408>
1000216c:	fa03 f30a 	lsl.w	r3, r3, sl
10002170:	4efb      	ldr	r6, [pc, #1004]	@ (10002560 <fndsa_vect_iFFT_fp64_exact+0x418>)
10002172:	1e5a      	subs	r2, r3, #1
10002174:	fa04 f40a 	lsl.w	r4, r4, sl
10002178:	f101 0840 	add.w	r8, r1, #64	@ 0x40
1000217c:	085b      	lsrs	r3, r3, #1
1000217e:	0892      	lsrs	r2, r2, #2
10002180:	eb06 1703 	add.w	r7, r6, r3, lsl #4
10002184:	eb08 1882 	add.w	r8, r8, r2, lsl #6
10002188:	4426      	add	r6, r4
1000218a:	440c      	add	r4, r1
1000218c:	edd6 7a02 	vldr	s15, [r6, #8]
10002190:	eeb8 db67 	vcvt.f64.u32	d13, s15
10002194:	edd6 7a03 	vldr	s15, [r6, #12]
10002198:	6873      	ldr	r3, [r6, #4]
1000219a:	eeb8 2b67 	vcvt.f64.u32	d2, s15
1000219e:	0fdb      	lsrs	r3, r3, #31
100021a0:	ee08 3a10 	vmov	s16, r3
100021a4:	ed91 9b0a 	vldr	d9, [r1, #40]	@ 0x28
100021a8:	edd6 7a00 	vldr	s15, [r6]
100021ac:	eeb8 8bc8 	vcvt.f64.s32	d8, s16
100021b0:	eeb7 0b00 	vmov.f64	d0, #112	@ 0x3f800000  1.0
100021b4:	ee3e 2b42 	vsub.f64	d2, d14, d2
100021b8:	ed91 4b02 	vldr	d4, [r1, #8]
100021bc:	ed91 bb0e 	vldr	d11, [r1, #56]	@ 0x38
100021c0:	ed94 ab0a 	vldr	d10, [r4, #40]	@ 0x28
100021c4:	eeb8 6b67 	vcvt.f64.u32	d6, s15
100021c8:	ee32 2b40 	vsub.f64	d2, d2, d0
100021cc:	edd6 7a01 	vldr	s15, [r6, #4]
100021d0:	ed8d 8b4e 	vstr	d8, [sp, #312]	@ 0x138
100021d4:	ee39 8b0e 	vadd.f64	d8, d9, d14
100021d8:	ed91 3b06 	vldr	d3, [r1, #24]
100021dc:	ed94 5b02 	vldr	d5, [r4, #8]
100021e0:	ed94 cb0e 	vldr	d12, [r4, #56]	@ 0x38
100021e4:	eeb8 7b67 	vcvt.f64.u32	d7, s15
100021e8:	ee39 9b0b 	vadd.f64	d9, d9, d11
100021ec:	ee3a 0b0e 	vadd.f64	d0, d10, d14
100021f0:	ee38 bb4b 	vsub.f64	d11, d8, d11
100021f4:	ed8d 2b12 	vstr	d2, [sp, #72]	@ 0x48
100021f8:	ed91 8b00 	vldr	d8, [r1]
100021fc:	ee34 2b0e 	vadd.f64	d2, d4, d14
10002200:	ed94 1b06 	vldr	d1, [r4, #24]
10002204:	ee33 4b04 	vadd.f64	d4, d3, d4
10002208:	ee32 2b43 	vsub.f64	d2, d2, d3
1000220c:	ee3a ab0c 	vadd.f64	d10, d10, d12
10002210:	ed8d 7b00 	vstr	d7, [sp]
10002214:	ee30 cb4c 	vsub.f64	d12, d0, d12
10002218:	ed8d 7b46 	vstr	d7, [sp, #280]	@ 0x118
1000221c:	ee35 3b0e 	vadd.f64	d3, d5, d14
10002220:	ed91 7b00 	vldr	d7, [r1]
10002224:	ee38 0b0e 	vadd.f64	d0, d8, d14
10002228:	ed91 8b04 	vldr	d8, [r1, #16]
1000222c:	ee35 5b01 	vadd.f64	d5, d5, d1
10002230:	ee33 3b41 	vsub.f64	d3, d3, d1
10002234:	ee38 8b07 	vadd.f64	d8, d8, d7
10002238:	ee22 1b0f 	vmul.f64	d1, d2, d15
1000223c:	ed8d 8b02 	vstr	d8, [sp, #8]
10002240:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10002244:	ed91 8b04 	vldr	d8, [r1, #16]
10002248:	eeb8 1b41 	vcvt.f64.u32	d1, s2
1000224c:	eeb7 7b00 	vmov.f64	d7, #112	@ 0x3f800000  1.0
10002250:	ee30 0b48 	vsub.f64	d0, d0, d8
10002254:	ee01 2b4e 	vmls.f64	d2, d1, d14
10002258:	ee30 0b47 	vsub.f64	d0, d0, d7
1000225c:	ed94 8b00 	vldr	d8, [r4]
10002260:	ee30 0b01 	vadd.f64	d0, d0, d1
10002264:	ee32 1b07 	vadd.f64	d1, d2, d7
10002268:	ee23 2b0f 	vmul.f64	d2, d3, d15
1000226c:	ed94 7b04 	vldr	d7, [r4, #16]
10002270:	ed8d 1b0c 	vstr	d1, [sp, #48]	@ 0x30
10002274:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10002278:	ee38 1b0e 	vadd.f64	d1, d8, d14
1000227c:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10002280:	ee38 8b07 	vadd.f64	d8, d8, d7
10002284:	ee31 1b47 	vsub.f64	d1, d1, d7
10002288:	eeb7 7b00 	vmov.f64	d7, #112	@ 0x3f800000  1.0
1000228c:	ee02 3b4e 	vmls.f64	d3, d2, d14
10002290:	ee31 1b47 	vsub.f64	d1, d1, d7
10002294:	ee31 1b02 	vadd.f64	d1, d1, d2
10002298:	ee33 2b07 	vadd.f64	d2, d3, d7
1000229c:	ee24 3b0f 	vmul.f64	d3, d4, d15
100022a0:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100022a4:	ed8d 2b0a 	vstr	d2, [sp, #40]	@ 0x28
100022a8:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100022ac:	ee25 2b0f 	vmul.f64	d2, d5, d15
100022b0:	ed8d 8b04 	vstr	d8, [sp, #16]
100022b4:	ee03 4b4e 	vmls.f64	d4, d3, d14
100022b8:	ed9d 8b02 	vldr	d8, [sp, #8]
100022bc:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100022c0:	ee38 8b03 	vadd.f64	d8, d8, d3
100022c4:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100022c8:	eeb0 3b47 	vmov.f64	d3, d7
100022cc:	ee34 7b07 	vadd.f64	d7, d4, d7
100022d0:	ed9d 4b04 	vldr	d4, [sp, #16]
100022d4:	ee02 5b4e 	vmls.f64	d5, d2, d14
100022d8:	ee34 4b02 	vadd.f64	d4, d4, d2
100022dc:	ee35 5b03 	vadd.f64	d5, d5, d3
100022e0:	ed8d 4b02 	vstr	d4, [sp, #8]
100022e4:	ee29 4b0f 	vmul.f64	d4, d9, d15
100022e8:	ed8d 6b48 	vstr	d6, [sp, #288]	@ 0x120
100022ec:	ed8d 7b10 	vstr	d7, [sp, #64]	@ 0x40
100022f0:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100022f4:	ed8d 5b0e 	vstr	d5, [sp, #56]	@ 0x38
100022f8:	ee2a 5b0f 	vmul.f64	d5, d10, d15
100022fc:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10002300:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10002304:	ee04 9b4e 	vmls.f64	d9, d4, d14
10002308:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000230c:	ee39 7b03 	vadd.f64	d7, d9, d3
10002310:	ee05 ab4e 	vmls.f64	d10, d5, d14
10002314:	ed8d 7b08 	vstr	d7, [sp, #32]
10002318:	ee3a 2b03 	vadd.f64	d2, d10, d3
1000231c:	ed91 7b0c 	vldr	d7, [r1, #48]	@ 0x30
10002320:	ed91 ab08 	vldr	d10, [r1, #32]
10002324:	ed91 3b08 	vldr	d3, [r1, #32]
10002328:	ee2b 9b0f 	vmul.f64	d9, d11, d15
1000232c:	ed8d 2b06 	vstr	d2, [sp, #24]
10002330:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10002334:	ee3a 2b07 	vadd.f64	d2, d10, d7
10002338:	ee33 3b0e 	vadd.f64	d3, d3, d14
1000233c:	ee32 2b04 	vadd.f64	d2, d2, d4
10002340:	ee33 3b47 	vsub.f64	d3, d3, d7
10002344:	eeb7 4b00 	vmov.f64	d4, #112	@ 0x3f800000  1.0
10002348:	eeb8 9b49 	vcvt.f64.u32	d9, s18
1000234c:	ee33 3b44 	vsub.f64	d3, d3, d4
10002350:	ee09 bb4e 	vmls.f64	d11, d9, d14
10002354:	ee33 9b09 	vadd.f64	d9, d3, d9
10002358:	ee3b 3b04 	vadd.f64	d3, d11, d4
1000235c:	ed8d 3b04 	vstr	d3, [sp, #16]
10002360:	ed94 3b08 	vldr	d3, [r4, #32]
10002364:	eeb0 7b44 	vmov.f64	d7, d4
10002368:	ed94 bb0c 	vldr	d11, [r4, #48]	@ 0x30
1000236c:	ee2c ab0f 	vmul.f64	d10, d12, d15
10002370:	ee33 4b0e 	vadd.f64	d4, d3, d14
10002374:	ee3e db4d 	vsub.f64	d13, d14, d13
10002378:	ee33 3b0b 	vadd.f64	d3, d3, d11
1000237c:	ee34 4b4b 	vsub.f64	d4, d4, d11
10002380:	eebc abca 	vcvt.u32.f64	s20, d10
10002384:	ee34 4b47 	vsub.f64	d4, d4, d7
10002388:	ee33 3b05 	vadd.f64	d3, d3, d5
1000238c:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10002390:	ee2d 5b0f 	vmul.f64	d5, d13, d15
10002394:	ee0a cb4e 	vmls.f64	d12, d10, d14
10002398:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000239c:	ee34 ab0a 	vadd.f64	d10, d4, d10
100023a0:	ee20 4b0f 	vmul.f64	d4, d0, d15
100023a4:	ee3c cb07 	vadd.f64	d12, d12, d7
100023a8:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100023ac:	eefc 7bc4 	vcvt.u32.f64	s15, d4
100023b0:	ed9d bb12 	vldr	d11, [sp, #72]	@ 0x48
100023b4:	ee05 db4e 	vmls.f64	d13, d5, d14
100023b8:	ee3b bb05 	vadd.f64	d11, d11, d5
100023bc:	eeb8 5b67 	vcvt.f64.u32	d5, s15
100023c0:	ed9f 7b65 	vldr	d7, [pc, #404]	@ 10002558 <fndsa_vect_iFFT_fp64_exact+0x410>
100023c4:	ee05 0b4e 	vmls.f64	d0, d5, d14
100023c8:	ee21 5b0f 	vmul.f64	d5, d1, d15
100023cc:	ee30 0b07 	vadd.f64	d0, d0, d7
100023d0:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100023d4:	ed8d 0b12 	vstr	d0, [sp, #72]	@ 0x48
100023d8:	ee28 0b0f 	vmul.f64	d0, d8, d15
100023dc:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100023e0:	eebc 0bc0 	vcvt.u32.f64	s0, d0
100023e4:	ee05 1b4e 	vmls.f64	d1, d5, d14
100023e8:	eeb8 0b40 	vcvt.f64.u32	d0, s0
100023ec:	ee00 8b4e 	vmls.f64	d8, d0, d14
100023f0:	ee31 0b07 	vadd.f64	d0, d1, d7
100023f4:	ed9d 1b02 	vldr	d1, [sp, #8]
100023f8:	ee21 5b0f 	vmul.f64	d5, d1, d15
100023fc:	eeb0 4b4d 	vmov.f64	d4, d13
10002400:	ed8d db52 	vstr	d13, [sp, #328]	@ 0x148
10002404:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10002408:	ee22 db0f 	vmul.f64	d13, d2, d15
1000240c:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10002410:	eebc dbcd 	vcvt.u32.f64	s26, d13
10002414:	ee05 1b4e 	vmls.f64	d1, d5, d14
10002418:	eeb8 5b4d 	vcvt.f64.u32	d5, s26
1000241c:	ee31 db07 	vadd.f64	d13, d1, d7
10002420:	ee05 2b4e 	vmls.f64	d2, d5, d14
10002424:	ed8d db02 	vstr	d13, [sp, #8]
10002428:	ee23 5b0f 	vmul.f64	d5, d3, d15
1000242c:	ee32 db07 	vadd.f64	d13, d2, d7
10002430:	ee29 2b0f 	vmul.f64	d2, d9, d15
10002434:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10002438:	eebc 2bc2 	vcvt.u32.f64	s4, d2
1000243c:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10002440:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10002444:	ee05 3b4e 	vmls.f64	d3, d5, d14
10002448:	ee02 9b4e 	vmls.f64	d9, d2, d14
1000244c:	ee2a 5b0f 	vmul.f64	d5, d10, d15
10002450:	ed8d db14 	vstr	d13, [sp, #80]	@ 0x50
10002454:	ee33 db07 	vadd.f64	d13, d3, d7
10002458:	ee39 3b07 	vadd.f64	d3, d9, d7
1000245c:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10002460:	ed8d 3b16 	vstr	d3, [sp, #88]	@ 0x58
10002464:	ee2b 3b0f 	vmul.f64	d3, d11, d15
10002468:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000246c:	eefc 2bc3 	vcvt.u32.f64	s5, d3
10002470:	ee05 ab4e 	vmls.f64	d10, d5, d14
10002474:	eeb8 5b62 	vcvt.f64.u32	d5, s5
10002478:	ee05 bb4e 	vmls.f64	d11, d5, d14
1000247c:	eebc 5bcb 	vcvt.u32.f64	s10, d11
10002480:	ee3a 3b07 	vadd.f64	d3, d10, d7
10002484:	ee15 3a10 	vmov	r3, s10
10002488:	ed9d 1b0c 	vldr	d1, [sp, #48]	@ 0x30
1000248c:	ed8d 3b18 	vstr	d3, [sp, #96]	@ 0x60
10002490:	ee34 3b06 	vadd.f64	d3, d4, d6
10002494:	ee26 6b0f 	vmul.f64	d6, d6, d15
10002498:	0fdb      	lsrs	r3, r3, #31
1000249a:	ee05 3a10 	vmov	s10, r3
1000249e:	ed8d 6b4c 	vstr	d6, [sp, #304]	@ 0x130
100024a2:	ee21 6b0f 	vmul.f64	d6, d1, d15
100024a6:	ed9d ab0a 	vldr	d10, [sp, #40]	@ 0x28
100024aa:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
100024ae:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100024b2:	ee24 4b0f 	vmul.f64	d4, d4, d15
100024b6:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100024ba:	ed8d 5b58 	vstr	d5, [sp, #352]	@ 0x160
100024be:	ee2a 5b0f 	vmul.f64	d5, d10, d15
100024c2:	eeb6 9b00 	vmov.f64	d9, #96	@ 0x3f000000  0.5
100024c6:	ed8d 4b56 	vstr	d4, [sp, #344]	@ 0x158
100024ca:	ee06 1b4e 	vmls.f64	d1, d6, d14
100024ce:	eefc 4bc5 	vcvt.u32.f64	s9, d5
100024d2:	ed9d 2b12 	vldr	d2, [sp, #72]	@ 0x48
100024d6:	ee21 5b09 	vmul.f64	d5, d1, d9
100024da:	ee32 2b06 	vadd.f64	d2, d2, d6
100024de:	eeb8 6b64 	vcvt.f64.u32	d6, s9
100024e2:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100024e6:	ee06 ab4e 	vmls.f64	d10, d6, d14
100024ea:	ee30 1b06 	vadd.f64	d1, d0, d6
100024ee:	ee2a 4b09 	vmul.f64	d4, d10, d9
100024f2:	eeb0 0b49 	vmov.f64	d0, d9
100024f6:	eeb8 6b45 	vcvt.f64.u32	d6, s10
100024fa:	ed9d 9b10 	vldr	d9, [sp, #64]	@ 0x40
100024fe:	ed8d 6b0c 	vstr	d6, [sp, #48]	@ 0x30
10002502:	ee29 6b0f 	vmul.f64	d6, d9, d15
10002506:	ed9d ab0e 	vldr	d10, [sp, #56]	@ 0x38
1000250a:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000250e:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10002512:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10002516:	ee2a 5b0f 	vmul.f64	d5, d10, d15
1000251a:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000251e:	ed8d 4b10 	vstr	d4, [sp, #64]	@ 0x40
10002522:	ee06 9b4e 	vmls.f64	d9, d6, d14
10002526:	eefc 4bc5 	vcvt.u32.f64	s9, d5
1000252a:	ee38 8b07 	vadd.f64	d8, d8, d7
1000252e:	ee29 5b00 	vmul.f64	d5, d9, d0
10002532:	ee38 8b06 	vadd.f64	d8, d8, d6
10002536:	eeb8 6b64 	vcvt.f64.u32	d6, s9
1000253a:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000253e:	ee06 ab4e 	vmls.f64	d10, d6, d14
10002542:	ed9d 7b08 	vldr	d7, [sp, #32]
10002546:	e00d      	b.n	10002564 <fndsa_vect_iFFT_fp64_exact+0x41c>
10002548:	00000000 	.word	0x00000000
1000254c:	3df00000 	.word	0x3df00000
10002550:	00000000 	.word	0x00000000
10002554:	41f00000 	.word	0x41f00000
	...
10002560:	300009a0 	.word	0x300009a0
10002564:	ee2a 4b00 	vmul.f64	d4, d10, d0
10002568:	ed9d 9b02 	vldr	d9, [sp, #8]
1000256c:	eeb8 ab45 	vcvt.f64.u32	d10, s10
10002570:	ee39 9b06 	vadd.f64	d9, d9, d6
10002574:	ed8d ab0a 	vstr	d10, [sp, #40]	@ 0x28
10002578:	ee27 6b0f 	vmul.f64	d6, d7, d15
1000257c:	ed9d ab06 	vldr	d10, [sp, #24]
10002580:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10002584:	ee2a 5b0f 	vmul.f64	d5, d10, d15
10002588:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000258c:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10002590:	ed8d 4b08 	vstr	d4, [sp, #32]
10002594:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10002598:	eefc 4bc5 	vcvt.u32.f64	s9, d5
1000259c:	ed8d bb50 	vstr	d11, [sp, #320]	@ 0x140
100025a0:	ed9d 5b14 	vldr	d5, [sp, #80]	@ 0x50
100025a4:	ee06 7b4e 	vmls.f64	d7, d6, d14
100025a8:	ee35 5b06 	vadd.f64	d5, d5, d6
100025ac:	eeb8 6b64 	vcvt.f64.u32	d6, s9
100025b0:	eeb0 4b4a 	vmov.f64	d4, d10
100025b4:	ed8d 5b06 	vstr	d5, [sp, #24]
100025b8:	ee06 4b4e 	vmls.f64	d4, d6, d14
100025bc:	ee27 5b00 	vmul.f64	d5, d7, d0
100025c0:	ed9d ab04 	vldr	d10, [sp, #16]
100025c4:	ee24 4b00 	vmul.f64	d4, d4, d0
100025c8:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100025cc:	eeb0 7b40 	vmov.f64	d7, d0
100025d0:	ee3d db06 	vadd.f64	d13, d13, d6
100025d4:	eeb8 0b45 	vcvt.f64.u32	d0, s10
100025d8:	ee2a 6b0f 	vmul.f64	d6, d10, d15
100025dc:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100025e0:	ed8d 0b0e 	vstr	d0, [sp, #56]	@ 0x38
100025e4:	ee2c 5b0f 	vmul.f64	d5, d12, d15
100025e8:	eeb8 0b44 	vcvt.f64.u32	d0, s8
100025ec:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100025f0:	ed8d 0b04 	vstr	d0, [sp, #16]
100025f4:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100025f8:	eefc 0bc5 	vcvt.u32.f64	s1, d5
100025fc:	ed9d 5b16 	vldr	d5, [sp, #88]	@ 0x58
10002600:	ee35 4b06 	vadd.f64	d4, d5, d6
10002604:	eeb0 5b4a 	vmov.f64	d5, d10
10002608:	ee06 5b4e 	vmls.f64	d5, d6, d14
1000260c:	eeb8 6b60 	vcvt.f64.u32	d6, s1
10002610:	eeb0 0b47 	vmov.f64	d0, d7
10002614:	ee06 cb4e 	vmls.f64	d12, d6, d14
10002618:	ee25 5b07 	vmul.f64	d5, d5, d7
1000261c:	ee2c cb00 	vmul.f64	d12, d12, d0
10002620:	ed9d 7b18 	vldr	d7, [sp, #96]	@ 0x60
10002624:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10002628:	ee37 7b06 	vadd.f64	d7, d7, d6
1000262c:	eefc 5bcc 	vcvt.u32.f64	s11, d12
10002630:	ed8d 7b02 	vstr	d7, [sp, #8]
10002634:	eeb8 cb45 	vcvt.f64.u32	d12, s10
10002638:	ed9d 7b00 	vldr	d7, [sp]
1000263c:	eeb8 5b65 	vcvt.f64.u32	d5, s11
10002640:	ed8d 5b18 	vstr	d5, [sp, #96]	@ 0x60
10002644:	ee3b 5b07 	vadd.f64	d5, d11, d7
10002648:	ee27 7b0f 	vmul.f64	d7, d7, d15
1000264c:	ee23 6b0f 	vmul.f64	d6, d3, d15
10002650:	ed8d 7b4a 	vstr	d7, [sp, #296]	@ 0x128
10002654:	ee22 7b0f 	vmul.f64	d7, d2, d15
10002658:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000265c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10002660:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10002664:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10002668:	ee06 3b4e 	vmls.f64	d3, d6, d14
1000266c:	ee35 5b06 	vadd.f64	d5, d5, d6
10002670:	ee21 6b0f 	vmul.f64	d6, d1, d15
10002674:	ee07 2b4e 	vmls.f64	d2, d7, d14
10002678:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000267c:	eefc 7bc2 	vcvt.u32.f64	s15, d2
10002680:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10002684:	ee17 2a90 	vmov	r2, s15
10002688:	ee06 1b4e 	vmls.f64	d1, d6, d14
1000268c:	0fd3      	lsrs	r3, r2, #31
1000268e:	eefc 7bc1 	vcvt.u32.f64	s15, d1
10002692:	ee07 3a10 	vmov	s14, r3
10002696:	0853      	lsrs	r3, r2, #1
10002698:	ee2b bb0f 	vmul.f64	d11, d11, d15
1000269c:	ee00 3a10 	vmov	s0, r3
100026a0:	ee17 ca90 	vmov	ip, s15
100026a4:	ed8d bb54 	vstr	d11, [sp, #336]	@ 0x150
100026a8:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100026ac:	ee23 bb0f 	vmul.f64	d11, d3, d15
100026b0:	ed8d 3b5c 	vstr	d3, [sp, #368]	@ 0x170
100026b4:	eeb8 0bc0 	vcvt.f64.s32	d0, s0
100026b8:	ed9f 3bfb 	vldr	d3, [pc, #1004]	@ 10002aa8 <fndsa_vect_iFFT_fp64_exact+0x960>
100026bc:	ea4f 73dc 	mov.w	r3, ip, lsr #31
100026c0:	ee07 0b03 	vmla.f64	d0, d7, d3
100026c4:	f002 0201 	and.w	r2, r2, #1
100026c8:	ee07 3a10 	vmov	s14, r3
100026cc:	ea4f 035c 	mov.w	r3, ip, lsr #1
100026d0:	ee07 2a90 	vmov	s15, r2
100026d4:	ee02 3a10 	vmov	s4, r3
100026d8:	eeb8 6be7 	vcvt.f64.s32	d6, s15
100026dc:	eeb8 2bc2 	vcvt.f64.s32	d2, s4
100026e0:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100026e4:	f00c 0301 	and.w	r3, ip, #1
100026e8:	ee07 2b03 	vmla.f64	d2, d7, d3
100026ec:	ed9d 1b0c 	vldr	d1, [sp, #48]	@ 0x30
100026f0:	ee07 3a90 	vmov	s15, r3
100026f4:	ee06 1b03 	vmla.f64	d1, d6, d3
100026f8:	eeb8 7be7 	vcvt.f64.s32	d7, s15
100026fc:	eeb0 6b43 	vmov.f64	d6, d3
10002700:	ed9d 3b10 	vldr	d3, [sp, #64]	@ 0x40
10002704:	ee07 3b06 	vmla.f64	d3, d7, d6
10002708:	ee28 7b0f 	vmul.f64	d7, d8, d15
1000270c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10002710:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10002714:	eeb0 ab46 	vmov.f64	d10, d6
10002718:	ee29 6b0f 	vmul.f64	d6, d9, d15
1000271c:	ee07 8b4e 	vmls.f64	d8, d7, d14
10002720:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10002724:	eefc 7bc8 	vcvt.u32.f64	s15, d8
10002728:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000272c:	ee17 2a90 	vmov	r2, s15
10002730:	ee06 9b4e 	vmls.f64	d9, d6, d14
10002734:	0fd3      	lsrs	r3, r2, #31
10002736:	ee07 3a10 	vmov	s14, r3
1000273a:	0853      	lsrs	r3, r2, #1
1000273c:	eefc 7bc9 	vcvt.u32.f64	s15, d9
10002740:	ee06 3a10 	vmov	s12, r3
10002744:	ee17 ca90 	vmov	ip, s15
10002748:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
1000274c:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10002750:	ee07 6b0a 	vmla.f64	d6, d7, d10
10002754:	ea4f 73dc 	mov.w	r3, ip, lsr #31
10002758:	ed8d 6b14 	vstr	d6, [sp, #80]	@ 0x50
1000275c:	f002 0201 	and.w	r2, r2, #1
10002760:	ee06 3a10 	vmov	s12, r3
10002764:	ea4f 035c 	mov.w	r3, ip, lsr #1
10002768:	ee07 2a90 	vmov	s15, r2
1000276c:	ee07 3a10 	vmov	s14, r3
10002770:	eeb0 9b4a 	vmov.f64	d9, d10
10002774:	eeb8 8be7 	vcvt.f64.s32	d8, s15
10002778:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
1000277c:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10002780:	ee06 7b09 	vmla.f64	d7, d6, d9
10002784:	f00c 0301 	and.w	r3, ip, #1
10002788:	ed9d ab0a 	vldr	d10, [sp, #40]	@ 0x28
1000278c:	ed8d 7b10 	vstr	d7, [sp, #64]	@ 0x40
10002790:	ee07 3a90 	vmov	s15, r3
10002794:	ee08 ab09 	vmla.f64	d10, d8, d9
10002798:	eeb8 7be7 	vcvt.f64.s32	d7, s15
1000279c:	eeb0 8b49 	vmov.f64	d8, d9
100027a0:	ed9d 9b08 	vldr	d9, [sp, #32]
100027a4:	ee07 9b08 	vmla.f64	d9, d7, d8
100027a8:	ed8d 9b12 	vstr	d9, [sp, #72]	@ 0x48
100027ac:	ed9d 9b06 	vldr	d9, [sp, #24]
100027b0:	ee29 7b0f 	vmul.f64	d7, d9, d15
100027b4:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100027b8:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100027bc:	ee2d 6b0f 	vmul.f64	d6, d13, d15
100027c0:	ee07 9b4e 	vmls.f64	d9, d7, d14
100027c4:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100027c8:	eefc 7bc9 	vcvt.u32.f64	s15, d9
100027cc:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100027d0:	ee17 2a90 	vmov	r2, s15
100027d4:	ee06 db4e 	vmls.f64	d13, d6, d14
100027d8:	0fd3      	lsrs	r3, r2, #31
100027da:	ee06 3a10 	vmov	s12, r3
100027de:	0853      	lsrs	r3, r2, #1
100027e0:	eefc 7bcd 	vcvt.u32.f64	s15, d13
100027e4:	ee07 3a10 	vmov	s14, r3
100027e8:	ee17 ca90 	vmov	ip, s15
100027ec:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100027f0:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
100027f4:	ed8d ab16 	vstr	d10, [sp, #88]	@ 0x58
100027f8:	f002 0201 	and.w	r2, r2, #1
100027fc:	eeb0 ab47 	vmov.f64	d10, d7
10002800:	ee07 2a90 	vmov	s15, r2
10002804:	ea4f 73dc 	mov.w	r3, ip, lsr #31
10002808:	ee06 ab08 	vmla.f64	d10, d6, d8
1000280c:	ee06 3a10 	vmov	s12, r3
10002810:	ea4f 035c 	mov.w	r3, ip, lsr #1
10002814:	eeb0 9b48 	vmov.f64	d9, d8
10002818:	ed9d db0e 	vldr	d13, [sp, #56]	@ 0x38
1000281c:	eeb8 8be7 	vcvt.f64.s32	d8, s15
10002820:	ee07 3a10 	vmov	s14, r3
10002824:	ee08 db09 	vmla.f64	d13, d8, d9
10002828:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
1000282c:	f00c 0301 	and.w	r3, ip, #1
10002830:	ed8d db0e 	vstr	d13, [sp, #56]	@ 0x38
10002834:	eeb0 db47 	vmov.f64	d13, d7
10002838:	ee07 3a90 	vmov	s15, r3
1000283c:	ed8d ab0c 	vstr	d10, [sp, #48]	@ 0x30
10002840:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10002844:	ed9d ab04 	vldr	d10, [sp, #16]
10002848:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
1000284c:	ee07 ab09 	vmla.f64	d10, d7, d9
10002850:	ee24 7b0f 	vmul.f64	d7, d4, d15
10002854:	ee06 db09 	vmla.f64	d13, d6, d9
10002858:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000285c:	ed8d db0a 	vstr	d13, [sp, #40]	@ 0x28
10002860:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10002864:	ed9d db02 	vldr	d13, [sp, #8]
10002868:	ee07 4b4e 	vmls.f64	d4, d7, d14
1000286c:	ee2d 6b0f 	vmul.f64	d6, d13, d15
10002870:	eefc 7bc4 	vcvt.u32.f64	s15, d4
10002874:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10002878:	ee17 2a90 	vmov	r2, s15
1000287c:	eeb8 7b46 	vcvt.f64.u32	d7, s12
10002880:	ee07 db4e 	vmls.f64	d13, d7, d14
10002884:	0fd3      	lsrs	r3, r2, #31
10002886:	eefc 7bcd 	vcvt.u32.f64	s15, d13
1000288a:	ee06 3a10 	vmov	s12, r3
1000288e:	0853      	lsrs	r3, r2, #1
10002890:	ee08 3a10 	vmov	s16, r3
10002894:	ee17 ca90 	vmov	ip, s15
10002898:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
1000289c:	eeb8 8bc8 	vcvt.f64.s32	d8, s16
100028a0:	ea4f 73dc 	mov.w	r3, ip, lsr #31
100028a4:	ee06 8b09 	vmla.f64	d8, d6, d9
100028a8:	f002 0201 	and.w	r2, r2, #1
100028ac:	ee06 3a10 	vmov	s12, r3
100028b0:	ea4f 035c 	mov.w	r3, ip, lsr #1
100028b4:	ee07 2a90 	vmov	s15, r2
100028b8:	ee07 3a10 	vmov	s14, r3
100028bc:	eeb8 4be7 	vcvt.f64.s32	d4, s15
100028c0:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100028c4:	f00c 0301 	and.w	r3, ip, #1
100028c8:	ee04 cb09 	vmla.f64	d12, d4, d9
100028cc:	eeb0 4b47 	vmov.f64	d4, d7
100028d0:	ee07 3a90 	vmov	s15, r3
100028d4:	ed8d cb04 	vstr	d12, [sp, #16]
100028d8:	eeb8 7be7 	vcvt.f64.s32	d7, s15
100028dc:	ed9d cb18 	vldr	d12, [sp, #96]	@ 0x60
100028e0:	ee07 cb09 	vmla.f64	d12, d7, d9
100028e4:	ee25 7b0f 	vmul.f64	d7, d5, d15
100028e8:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100028ec:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100028f0:	ee07 5b4e 	vmls.f64	d5, d7, d14
100028f4:	eebc 7bc5 	vcvt.u32.f64	s14, d5
100028f8:	ee17 3a10 	vmov	r3, s14
100028fc:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10002900:	0fdb      	lsrs	r3, r3, #31
10002902:	ee06 4b09 	vmla.f64	d4, d6, d9
10002906:	ee07 3a10 	vmov	s14, r3
1000290a:	ed8d 4b00 	vstr	d4, [sp]
1000290e:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10002912:	ed8d ab08 	vstr	d10, [sp, #32]
10002916:	ed8d cb02 	vstr	d12, [sp, #8]
1000291a:	ed8d 5b5a 	vstr	d5, [sp, #360]	@ 0x168
1000291e:	ee25 5b0f 	vmul.f64	d5, d5, d15
10002922:	a846      	add	r0, sp, #280	@ 0x118
10002924:	ed8d 7b62 	vstr	d7, [sp, #392]	@ 0x188
10002928:	ed8d 5b5e 	vstr	d5, [sp, #376]	@ 0x178
1000292c:	ed8d bb60 	vstr	d11, [sp, #384]	@ 0x180
10002930:	f7fd fffa 	bl	10000928 <fp64e_cmul_prepared>
10002934:	edd6 7a06 	vldr	s15, [r6, #24]
10002938:	6973      	ldr	r3, [r6, #20]
1000293a:	eeb8 5b67 	vcvt.f64.u32	d5, s15
1000293e:	0fdb      	lsrs	r3, r3, #31
10002940:	edd6 7a07 	vldr	s15, [r6, #28]
10002944:	ee04 3a10 	vmov	s8, r3
10002948:	eeb8 6b67 	vcvt.f64.u32	d6, s15
1000294c:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
10002950:	ee3e 5b45 	vsub.f64	d5, d14, d5
10002954:	ed8d 4b4e 	vstr	d4, [sp, #312]	@ 0x138
10002958:	ee3e 6b46 	vsub.f64	d6, d14, d6
1000295c:	eeb7 4b00 	vmov.f64	d4, #112	@ 0x3f800000  1.0
10002960:	edd6 7a04 	vldr	s15, [r6, #16]
10002964:	ee36 6b44 	vsub.f64	d6, d6, d4
10002968:	ee25 4b0f 	vmul.f64	d4, d5, d15
1000296c:	eeb0 cb40 	vmov.f64	d12, d0
10002970:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10002974:	eeb0 0b48 	vmov.f64	d0, d8
10002978:	eeb8 8b67 	vcvt.f64.u32	d8, s15
1000297c:	edd6 7a05 	vldr	s15, [r6, #20]
10002980:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10002984:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10002988:	ee36 6b04 	vadd.f64	d6, d6, d4
1000298c:	ee27 bb0f 	vmul.f64	d11, d7, d15
10002990:	ed8d bb4a 	vstr	d11, [sp, #296]	@ 0x128
10002994:	ee26 bb0f 	vmul.f64	d11, d6, d15
10002998:	eebc bbcb 	vcvt.u32.f64	s22, d11
1000299c:	ee04 5b4e 	vmls.f64	d5, d4, d14
100029a0:	eeb8 bb4b 	vcvt.f64.u32	d11, s22
100029a4:	ee35 4b08 	vadd.f64	d4, d5, d8
100029a8:	ee0b 6b4e 	vmls.f64	d6, d11, d14
100029ac:	ed8d 5b52 	vstr	d5, [sp, #328]	@ 0x148
100029b0:	ee25 5b0f 	vmul.f64	d5, d5, d15
100029b4:	ed8d 5b56 	vstr	d5, [sp, #344]	@ 0x158
100029b8:	eefc 5bc6 	vcvt.u32.f64	s11, d6
100029bc:	ee15 3a90 	vmov	r3, s11
100029c0:	ed8d 7b46 	vstr	d7, [sp, #280]	@ 0x118
100029c4:	ed8d 6b50 	vstr	d6, [sp, #320]	@ 0x140
100029c8:	ee36 7b07 	vadd.f64	d7, d6, d7
100029cc:	ee26 6b0f 	vmul.f64	d6, d6, d15
100029d0:	0fdb      	lsrs	r3, r3, #31
100029d2:	ed8d 6b54 	vstr	d6, [sp, #336]	@ 0x150
100029d6:	ee06 3a10 	vmov	s12, r3
100029da:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
100029de:	ed8d 6b58 	vstr	d6, [sp, #352]	@ 0x160
100029e2:	ee24 6b0f 	vmul.f64	d6, d4, d15
100029e6:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100029ea:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100029ee:	ee37 7b06 	vadd.f64	d7, d7, d6
100029f2:	ee06 4b4e 	vmls.f64	d4, d6, d14
100029f6:	ee27 6b0f 	vmul.f64	d6, d7, d15
100029fa:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100029fe:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10002a02:	ee06 7b4e 	vmls.f64	d7, d6, d14
10002a06:	eefc 6bc7 	vcvt.u32.f64	s13, d7
10002a0a:	ee16 3a90 	vmov	r3, s13
10002a0e:	ed8d 7b5a 	vstr	d7, [sp, #360]	@ 0x168
10002a12:	ee27 7b0f 	vmul.f64	d7, d7, d15
10002a16:	0fdb      	lsrs	r3, r3, #31
10002a18:	ed8d 7b5e 	vstr	d7, [sp, #376]	@ 0x178
10002a1c:	ee07 3a10 	vmov	s14, r3
10002a20:	eeb0 9b43 	vmov.f64	d9, d3
10002a24:	eeb0 ab41 	vmov.f64	d10, d1
10002a28:	eeb0 db42 	vmov.f64	d13, d2
10002a2c:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10002a30:	ed8d 8b48 	vstr	d8, [sp, #288]	@ 0x120
10002a34:	ed8d 4b5c 	vstr	d4, [sp, #368]	@ 0x170
10002a38:	ee28 8b0f 	vmul.f64	d8, d8, d15
10002a3c:	ee24 4b0f 	vmul.f64	d4, d4, d15
10002a40:	ed9d 2b00 	vldr	d2, [sp]
10002a44:	ed9d 1b04 	vldr	d1, [sp, #16]
10002a48:	ed9d 3b02 	vldr	d3, [sp, #8]
10002a4c:	ed8d 7b62 	vstr	d7, [sp, #392]	@ 0x188
10002a50:	ed8d cb2e 	vstr	d12, [sp, #184]	@ 0xb8
10002a54:	ed8d ab30 	vstr	d10, [sp, #192]	@ 0xc0
10002a58:	ed8d db32 	vstr	d13, [sp, #200]	@ 0xc8
10002a5c:	ed8d 9b34 	vstr	d9, [sp, #208]	@ 0xd0
10002a60:	ed8d 8b4c 	vstr	d8, [sp, #304]	@ 0x130
10002a64:	ed8d 4b60 	vstr	d4, [sp, #384]	@ 0x180
10002a68:	f7fd ff5e 	bl	10000928 <fp64e_cmul_prepared>
10002a6c:	edd7 7a02 	vldr	s15, [r7, #8]
10002a70:	edd7 5a00 	vldr	s11, [r7]
10002a74:	687b      	ldr	r3, [r7, #4]
10002a76:	eeb8 4b65 	vcvt.f64.u32	d4, s11
10002a7a:	0fdb      	lsrs	r3, r3, #31
10002a7c:	edd7 5a01 	vldr	s11, [r7, #4]
10002a80:	eeb8 6b67 	vcvt.f64.u32	d6, s15
10002a84:	ee05 3a10 	vmov	s10, r3
10002a88:	edd7 7a03 	vldr	s15, [r7, #12]
10002a8c:	eeb8 8b65 	vcvt.f64.u32	d8, s11
10002a90:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10002a94:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
10002a98:	ee3e bb46 	vsub.f64	d11, d14, d6
10002a9c:	ed8d 5b4e 	vstr	d5, [sp, #312]	@ 0x138
10002aa0:	ee3e 7b47 	vsub.f64	d7, d14, d7
10002aa4:	e008      	b.n	10002ab8 <fndsa_vect_iFFT_fp64_exact+0x970>
10002aa6:	bf00      	nop
10002aa8:	00000000 	.word	0x00000000
10002aac:	41e00000 	.word	0x41e00000
	...
10002ab8:	eeb7 5b00 	vmov.f64	d5, #112	@ 0x3f800000  1.0
10002abc:	ed8d bb06 	vstr	d11, [sp, #24]
10002ac0:	ee37 bb45 	vsub.f64	d11, d7, d5
10002ac4:	ed9d 6b16 	vldr	d6, [sp, #88]	@ 0x58
10002ac8:	ed8d bb1a 	vstr	d11, [sp, #104]	@ 0x68
10002acc:	ed9d bb0e 	vldr	d11, [sp, #56]	@ 0x38
10002ad0:	ee36 7b0e 	vadd.f64	d7, d6, d14
10002ad4:	ee3b 6b06 	vadd.f64	d6, d11, d6
10002ad8:	ed9d 5b08 	vldr	d5, [sp, #32]
10002adc:	ed8d 6b0e 	vstr	d6, [sp, #56]	@ 0x38
10002ae0:	ed9d 6b12 	vldr	d6, [sp, #72]	@ 0x48
10002ae4:	ee37 7b4b 	vsub.f64	d7, d7, d11
10002ae8:	ee36 bb0e 	vadd.f64	d11, d6, d14
10002aec:	ee35 6b06 	vadd.f64	d6, d5, d6
10002af0:	ed8d 6b04 	vstr	d6, [sp, #16]
10002af4:	ee3a 6b0e 	vadd.f64	d6, d10, d14
10002af8:	ed8d 1b38 	vstr	d1, [sp, #224]	@ 0xe0
10002afc:	ee3a ab01 	vadd.f64	d10, d10, d1
10002b00:	ee36 1b41 	vsub.f64	d1, d6, d1
10002b04:	ee39 6b0e 	vadd.f64	d6, d9, d14
10002b08:	ed8d 0b36 	vstr	d0, [sp, #216]	@ 0xd8
10002b0c:	ed8d 2b3a 	vstr	d2, [sp, #232]	@ 0xe8
10002b10:	ed8d 3b3c 	vstr	d3, [sp, #240]	@ 0xf0
10002b14:	ed8d 8b00 	vstr	d8, [sp]
10002b18:	ed8d 8b46 	vstr	d8, [sp, #280]	@ 0x118
10002b1c:	ed8d 4b48 	vstr	d4, [sp, #288]	@ 0x120
10002b20:	ed8d 1b08 	vstr	d1, [sp, #32]
10002b24:	ed8d 7b02 	vstr	d7, [sp, #8]
10002b28:	ee39 1b03 	vadd.f64	d1, d9, d3
10002b2c:	ee36 9b43 	vsub.f64	d9, d6, d3
10002b30:	ed9d 3b14 	vldr	d3, [sp, #80]	@ 0x50
10002b34:	ed9d 8b0c 	vldr	d8, [sp, #48]	@ 0x30
10002b38:	ee3b bb45 	vsub.f64	d11, d11, d5
10002b3c:	ee27 6b0f 	vmul.f64	d6, d7, d15
10002b40:	ee33 5b0e 	vadd.f64	d5, d3, d14
10002b44:	eeb7 7b00 	vmov.f64	d7, #112	@ 0x3f800000  1.0
10002b48:	ee35 5b48 	vsub.f64	d5, d5, d8
10002b4c:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10002b50:	ee38 3b03 	vadd.f64	d3, d8, d3
10002b54:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10002b58:	eeb0 8b47 	vmov.f64	d8, d7
10002b5c:	ee35 5b47 	vsub.f64	d5, d5, d7
10002b60:	ed9d 7b02 	vldr	d7, [sp, #8]
10002b64:	ee06 7b4e 	vmls.f64	d7, d6, d14
10002b68:	ee35 5b06 	vadd.f64	d5, d5, d6
10002b6c:	ee37 7b08 	vadd.f64	d7, d7, d8
10002b70:	ed8d 5b0c 	vstr	d5, [sp, #48]	@ 0x30
10002b74:	ed8d 7b14 	vstr	d7, [sp, #80]	@ 0x50
10002b78:	ed9d 5b10 	vldr	d5, [sp, #64]	@ 0x40
10002b7c:	ee2b 7b0f 	vmul.f64	d7, d11, d15
10002b80:	ed9d 8b0a 	vldr	d8, [sp, #40]	@ 0x28
10002b84:	ee35 6b0e 	vadd.f64	d6, d5, d14
10002b88:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10002b8c:	ee38 5b05 	vadd.f64	d5, d8, d5
10002b90:	ee36 6b48 	vsub.f64	d6, d6, d8
10002b94:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10002b98:	eeb7 8b00 	vmov.f64	d8, #112	@ 0x3f800000  1.0
10002b9c:	ee07 bb4e 	vmls.f64	d11, d7, d14
10002ba0:	ee36 6b48 	vsub.f64	d6, d6, d8
10002ba4:	ee3b bb08 	vadd.f64	d11, d11, d8
10002ba8:	ee36 7b07 	vadd.f64	d7, d6, d7
10002bac:	ed9d 8b0e 	vldr	d8, [sp, #56]	@ 0x38
10002bb0:	ed8d 7b0a 	vstr	d7, [sp, #40]	@ 0x28
10002bb4:	ee28 7b0f 	vmul.f64	d7, d8, d15
10002bb8:	ed9d 6b04 	vldr	d6, [sp, #16]
10002bbc:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10002bc0:	ee26 6b0f 	vmul.f64	d6, d6, d15
10002bc4:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10002bc8:	ed8d bb12 	vstr	d11, [sp, #72]	@ 0x48
10002bcc:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10002bd0:	ee33 bb07 	vadd.f64	d11, d3, d7
10002bd4:	eeb0 3b48 	vmov.f64	d3, d8
10002bd8:	ee07 3b4e 	vmls.f64	d3, d7, d14
10002bdc:	eeb8 7b46 	vcvt.f64.u32	d7, s12
10002be0:	ed9d 6b04 	vldr	d6, [sp, #16]
10002be4:	eeb7 8b00 	vmov.f64	d8, #112	@ 0x3f800000  1.0
10002be8:	ee07 6b4e 	vmls.f64	d6, d7, d14
10002bec:	ee33 3b08 	vadd.f64	d3, d3, d8
10002bf0:	ee36 6b08 	vadd.f64	d6, d6, d8
10002bf4:	ed8d 3b18 	vstr	d3, [sp, #96]	@ 0x60
10002bf8:	ed8d 6b16 	vstr	d6, [sp, #88]	@ 0x58
10002bfc:	ee35 3b07 	vadd.f64	d3, d5, d7
10002c00:	ee21 6b0f 	vmul.f64	d6, d1, d15
10002c04:	ee2a 7b0f 	vmul.f64	d7, d10, d15
10002c08:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10002c0c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10002c10:	ed8d 3b0e 	vstr	d3, [sp, #56]	@ 0x38
10002c14:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10002c18:	eeb8 3b46 	vcvt.f64.u32	d3, s12
10002c1c:	ee07 ab4e 	vmls.f64	d10, d7, d14
10002c20:	ee03 1b4e 	vmls.f64	d1, d3, d14
10002c24:	ee3a ab08 	vadd.f64	d10, d10, d8
10002c28:	ee31 6b08 	vadd.f64	d6, d1, d8
10002c2c:	ed9d 8b08 	vldr	d8, [sp, #32]
10002c30:	ed8d 6b10 	vstr	d6, [sp, #64]	@ 0x40
10002c34:	ee28 6b0f 	vmul.f64	d6, d8, d15
10002c38:	ee3c 5b0e 	vadd.f64	d5, d12, d14
10002c3c:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10002c40:	ee3c cb00 	vadd.f64	d12, d12, d0
10002c44:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10002c48:	ee3c 1b07 	vadd.f64	d1, d12, d7
10002c4c:	ee35 5b40 	vsub.f64	d5, d5, d0
10002c50:	eeb7 7b00 	vmov.f64	d7, #112	@ 0x3f800000  1.0
10002c54:	eeb0 cb48 	vmov.f64	d12, d8
10002c58:	ee35 5b47 	vsub.f64	d5, d5, d7
10002c5c:	ee06 cb4e 	vmls.f64	d12, d6, d14
10002c60:	ee35 0b06 	vadd.f64	d0, d5, d6
10002c64:	ee3c cb07 	vadd.f64	d12, d12, d7
10002c68:	eeb0 5b47 	vmov.f64	d5, d7
10002c6c:	ee29 7b0f 	vmul.f64	d7, d9, d15
10002c70:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10002c74:	ee3d 6b0e 	vadd.f64	d6, d13, d14
10002c78:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10002c7c:	ee32 db0d 	vadd.f64	d13, d2, d13
10002c80:	ee07 9b4e 	vmls.f64	d9, d7, d14
10002c84:	ee36 6b42 	vsub.f64	d6, d6, d2
10002c88:	ed9d 8b06 	vldr	d8, [sp, #24]
10002c8c:	ee36 6b45 	vsub.f64	d6, d6, d5
10002c90:	ee3d 3b03 	vadd.f64	d3, d13, d3
10002c94:	ee39 db05 	vadd.f64	d13, d9, d5
10002c98:	ee36 2b07 	vadd.f64	d2, d6, d7
10002c9c:	ed8d db04 	vstr	d13, [sp, #16]
10002ca0:	ee28 7b0f 	vmul.f64	d7, d8, d15
10002ca4:	ed9d db0c 	vldr	d13, [sp, #48]	@ 0x30
10002ca8:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10002cac:	ee2d 6b0f 	vmul.f64	d6, d13, d15
10002cb0:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10002cb4:	eefc 5bc6 	vcvt.u32.f64	s11, d6
10002cb8:	ed9d 6b1a 	vldr	d6, [sp, #104]	@ 0x68
10002cbc:	ee36 9b07 	vadd.f64	d9, d6, d7
10002cc0:	eeb0 6b48 	vmov.f64	d6, d8
10002cc4:	ee07 6b4e 	vmls.f64	d6, d7, d14
10002cc8:	eeb8 7b65 	vcvt.f64.u32	d7, s11
10002ccc:	eeb0 5b4d 	vmov.f64	d5, d13
10002cd0:	ed1f 8b89 	vldr	d8, [pc, #-548]	@ 10002ab0 <fndsa_vect_iFFT_fp64_exact+0x968>
10002cd4:	ed8d cb02 	vstr	d12, [sp, #8]
10002cd8:	ee07 5b4e 	vmls.f64	d5, d7, d14
10002cdc:	ed9d cb0a 	vldr	d12, [sp, #40]	@ 0x28
10002ce0:	ee35 5b08 	vadd.f64	d5, d5, d8
10002ce4:	ee2c 7b0f 	vmul.f64	d7, d12, d15
10002ce8:	ed8d 5b08 	vstr	d5, [sp, #32]
10002cec:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10002cf0:	ee2b 5b0f 	vmul.f64	d5, d11, d15
10002cf4:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10002cf8:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10002cfc:	ee07 cb4e 	vmls.f64	d12, d7, d14
10002d00:	eeb8 7b45 	vcvt.f64.u32	d7, s10
10002d04:	ed9d db0e 	vldr	d13, [sp, #56]	@ 0x38
10002d08:	ee07 bb4e 	vmls.f64	d11, d7, d14
10002d0c:	ee3c 7b08 	vadd.f64	d7, d12, d8
10002d10:	eeb0 cb47 	vmov.f64	d12, d7
10002d14:	ee2d 7b0f 	vmul.f64	d7, d13, d15
10002d18:	ee21 5b0f 	vmul.f64	d5, d1, d15
10002d1c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10002d20:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10002d24:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10002d28:	ee07 db4e 	vmls.f64	d13, d7, d14
10002d2c:	eeb8 7b45 	vcvt.f64.u32	d7, s10
10002d30:	ee07 1b4e 	vmls.f64	d1, d7, d14
10002d34:	ee3d 7b08 	vadd.f64	d7, d13, d8
10002d38:	ed8d 7b06 	vstr	d7, [sp, #24]
10002d3c:	ee23 7b0f 	vmul.f64	d7, d3, d15
10002d40:	ee31 1b08 	vadd.f64	d1, d1, d8
10002d44:	ee20 5b0f 	vmul.f64	d5, d0, d15
10002d48:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10002d4c:	ed8d 1b0c 	vstr	d1, [sp, #48]	@ 0x30
10002d50:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10002d54:	eefc 1bc5 	vcvt.u32.f64	s3, d5
10002d58:	ee07 3b4e 	vmls.f64	d3, d7, d14
10002d5c:	eeb8 7b61 	vcvt.f64.u32	d7, s3
10002d60:	ee07 0b4e 	vmls.f64	d0, d7, d14
10002d64:	ee22 7b0f 	vmul.f64	d7, d2, d15
10002d68:	ee33 3b08 	vadd.f64	d3, d3, d8
10002d6c:	ee29 5b0f 	vmul.f64	d5, d9, d15
10002d70:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10002d74:	ed8d 3b1a 	vstr	d3, [sp, #104]	@ 0x68
10002d78:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10002d7c:	eefc 3bc5 	vcvt.u32.f64	s7, d5
10002d80:	ee07 2b4e 	vmls.f64	d2, d7, d14
10002d84:	eeb8 7b63 	vcvt.f64.u32	d7, s7
10002d88:	ee07 9b4e 	vmls.f64	d9, d7, d14
10002d8c:	eebc 7bc9 	vcvt.u32.f64	s14, d9
10002d90:	ee17 3a10 	vmov	r3, s14
10002d94:	0fdb      	lsrs	r3, r3, #31
10002d96:	ee07 3a10 	vmov	s14, r3
10002d9a:	ee36 3b04 	vadd.f64	d3, d6, d4
10002d9e:	ee32 2b08 	vadd.f64	d2, d2, d8
10002da2:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10002da6:	ee24 4b0f 	vmul.f64	d4, d4, d15
10002daa:	ed8d 6b52 	vstr	d6, [sp, #328]	@ 0x148
10002dae:	ed8d 2b1c 	vstr	d2, [sp, #112]	@ 0x70
10002db2:	ed8d 9b50 	vstr	d9, [sp, #320]	@ 0x140
10002db6:	ed8d 7b58 	vstr	d7, [sp, #352]	@ 0x160
10002dba:	ed8d 4b4c 	vstr	d4, [sp, #304]	@ 0x130
10002dbe:	ed9d 2b14 	vldr	d2, [sp, #80]	@ 0x50
10002dc2:	ed9d 1b12 	vldr	d1, [sp, #72]	@ 0x48
10002dc6:	ee22 7b0f 	vmul.f64	d7, d2, d15
10002dca:	ee26 6b0f 	vmul.f64	d6, d6, d15
10002dce:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10002dd2:	ed8d 6b56 	vstr	d6, [sp, #344]	@ 0x158
10002dd6:	ee21 6b0f 	vmul.f64	d6, d1, d15
10002dda:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10002dde:	eefc 5bc6 	vcvt.u32.f64	s11, d6
10002de2:	ed9d 4b08 	vldr	d4, [sp, #32]
10002de6:	eeb0 6b42 	vmov.f64	d6, d2
10002dea:	ee34 4b07 	vadd.f64	d4, d4, d7
10002dee:	ee07 6b4e 	vmls.f64	d6, d7, d14
10002df2:	eeb8 7b65 	vcvt.f64.u32	d7, s11
10002df6:	eeb0 5b41 	vmov.f64	d5, d1
10002dfa:	ee30 0b08 	vadd.f64	d0, d0, d8
10002dfe:	ee3b bb08 	vadd.f64	d11, d11, d8
10002e02:	ee07 5b4e 	vmls.f64	d5, d7, d14
10002e06:	eeb6 8b00 	vmov.f64	d8, #96	@ 0x3f000000  0.5
10002e0a:	ee3c 2b07 	vadd.f64	d2, d12, d7
10002e0e:	ee26 6b08 	vmul.f64	d6, d6, d8
10002e12:	ed9d cb18 	vldr	d12, [sp, #96]	@ 0x60
10002e16:	ee25 5b08 	vmul.f64	d5, d5, d8
10002e1a:	ed9d db16 	vldr	d13, [sp, #88]	@ 0x58
10002e1e:	ee2c 7b0f 	vmul.f64	d7, d12, d15
10002e22:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10002e26:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10002e2a:	eeb8 1b46 	vcvt.f64.u32	d1, s12
10002e2e:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10002e32:	ee2d 6b0f 	vmul.f64	d6, d13, d15
10002e36:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10002e3a:	ed8d 5b18 	vstr	d5, [sp, #96]	@ 0x60
10002e3e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10002e42:	eefc 5bc6 	vcvt.u32.f64	s11, d6
10002e46:	eeb0 6b4c 	vmov.f64	d6, d12
10002e4a:	ee3b bb07 	vadd.f64	d11, d11, d7
10002e4e:	ee07 6b4e 	vmls.f64	d6, d7, d14
10002e52:	eeb8 7b65 	vcvt.f64.u32	d7, s11
10002e56:	ed9d 5b06 	vldr	d5, [sp, #24]
10002e5a:	ee26 6b08 	vmul.f64	d6, d6, d8
10002e5e:	ee35 5b07 	vadd.f64	d5, d5, d7
10002e62:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10002e66:	ed8d 5b08 	vstr	d5, [sp, #32]
10002e6a:	eeb0 5b4d 	vmov.f64	d5, d13
10002e6e:	ee07 5b4e 	vmls.f64	d5, d7, d14
10002e72:	eeb8 7b46 	vcvt.f64.u32	d7, s12
10002e76:	ed9d cb10 	vldr	d12, [sp, #64]	@ 0x40
10002e7a:	ed8d 7b0a 	vstr	d7, [sp, #40]	@ 0x28
10002e7e:	ee2a 7b0f 	vmul.f64	d7, d10, d15
10002e82:	ee25 5b08 	vmul.f64	d5, d5, d8
10002e86:	ee2c 6b0f 	vmul.f64	d6, d12, d15
10002e8a:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10002e8e:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10002e92:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10002e96:	eefc 5bc6 	vcvt.u32.f64	s11, d6
10002e9a:	ed9d 6b0c 	vldr	d6, [sp, #48]	@ 0x30
10002e9e:	ee07 ab4e 	vmls.f64	d10, d7, d14
10002ea2:	ee36 6b07 	vadd.f64	d6, d6, d7
10002ea6:	ed8d 6b06 	vstr	d6, [sp, #24]
10002eaa:	ee2a 6b08 	vmul.f64	d6, d10, d8
10002eae:	eeb8 7b65 	vcvt.f64.u32	d7, s11
10002eb2:	eeb8 db45 	vcvt.f64.u32	d13, s10
10002eb6:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10002eba:	eeb0 5b4c 	vmov.f64	d5, d12
10002ebe:	eeb8 cb46 	vcvt.f64.u32	d12, s12
10002ec2:	ee07 5b4e 	vmls.f64	d5, d7, d14
10002ec6:	ed9d ab1a 	vldr	d10, [sp, #104]	@ 0x68
10002eca:	ee25 5b08 	vmul.f64	d5, d5, d8
10002ece:	ed8d cb12 	vstr	d12, [sp, #72]	@ 0x48
10002ed2:	ed9d cb02 	vldr	d12, [sp, #8]
10002ed6:	ee3a ab07 	vadd.f64	d10, d10, d7
10002eda:	ed8d db0e 	vstr	d13, [sp, #56]	@ 0x38
10002ede:	ee2c 7b0f 	vmul.f64	d7, d12, d15
10002ee2:	ed9d db04 	vldr	d13, [sp, #16]
10002ee6:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10002eea:	ee2d 6b0f 	vmul.f64	d6, d13, d15
10002eee:	eeb8 cb45 	vcvt.f64.u32	d12, s10
10002ef2:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10002ef6:	ed8d cb14 	vstr	d12, [sp, #80]	@ 0x50
10002efa:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10002efe:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10002f02:	ed9d cb02 	vldr	d12, [sp, #8]
10002f06:	ee30 5b07 	vadd.f64	d5, d0, d7
10002f0a:	ee07 cb4e 	vmls.f64	d12, d7, d14
10002f0e:	eeb8 7b46 	vcvt.f64.u32	d7, s12
10002f12:	ed9d 0b1c 	vldr	d0, [sp, #112]	@ 0x70
10002f16:	ee07 db4e 	vmls.f64	d13, d7, d14
10002f1a:	ee2c 6b08 	vmul.f64	d6, d12, d8
10002f1e:	ee2d db08 	vmul.f64	d13, d13, d8
10002f22:	ee30 cb07 	vadd.f64	d12, d0, d7
10002f26:	ee23 7b0f 	vmul.f64	d7, d3, d15
10002f2a:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10002f2e:	ed9d 8b00 	vldr	d8, [sp]
10002f32:	eefc 6bcd 	vcvt.u32.f64	s13, d13
10002f36:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10002f3a:	eeb8 0b66 	vcvt.f64.u32	d0, s13
10002f3e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10002f42:	eeb8 db46 	vcvt.f64.u32	d13, s12
10002f46:	ee39 6b08 	vadd.f64	d6, d9, d8
10002f4a:	ee28 8b0f 	vmul.f64	d8, d8, d15
10002f4e:	ee07 3b4e 	vmls.f64	d3, d7, d14
10002f52:	ed8d 8b4a 	vstr	d8, [sp, #296]	@ 0x128
10002f56:	ee36 8b07 	vadd.f64	d8, d6, d7
10002f5a:	ee24 7b0f 	vmul.f64	d7, d4, d15
10002f5e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10002f62:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10002f66:	ee22 6b0f 	vmul.f64	d6, d2, d15
10002f6a:	ee07 4b4e 	vmls.f64	d4, d7, d14
10002f6e:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10002f72:	eefc 7bc4 	vcvt.u32.f64	s15, d4
10002f76:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10002f7a:	ee17 2a90 	vmov	r2, s15
10002f7e:	ee06 2b4e 	vmls.f64	d2, d6, d14
10002f82:	0fd3      	lsrs	r3, r2, #31
10002f84:	eefc 7bc2 	vcvt.u32.f64	s15, d2
10002f88:	ee07 3a10 	vmov	s14, r3
10002f8c:	0853      	lsrs	r3, r2, #1
10002f8e:	ed8d 0b16 	vstr	d0, [sp, #88]	@ 0x58
10002f92:	ee29 9b0f 	vmul.f64	d9, d9, d15
10002f96:	ee00 3a10 	vmov	s0, r3
10002f9a:	ee17 ca90 	vmov	ip, s15
10002f9e:	ed8d 9b54 	vstr	d9, [sp, #336]	@ 0x150
10002fa2:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10002fa6:	ed9f 9be2 	vldr	d9, [pc, #904]	@ 10003330 <fndsa_vect_iFFT_fp64_exact+0x11e8>
10002faa:	eeb8 0bc0 	vcvt.f64.s32	d0, s0
10002fae:	ea4f 73dc 	mov.w	r3, ip, lsr #31
10002fb2:	ee07 0b09 	vmla.f64	d0, d7, d9
10002fb6:	f002 0201 	and.w	r2, r2, #1
10002fba:	ee07 3a10 	vmov	s14, r3
10002fbe:	ea4f 035c 	mov.w	r3, ip, lsr #1
10002fc2:	ee07 2a90 	vmov	s15, r2
10002fc6:	ee02 3a10 	vmov	s4, r3
10002fca:	eeb8 6be7 	vcvt.f64.s32	d6, s15
10002fce:	eeb8 2bc2 	vcvt.f64.s32	d2, s4
10002fd2:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10002fd6:	f00c 0301 	and.w	r3, ip, #1
10002fda:	ee07 2b09 	vmla.f64	d2, d7, d9
10002fde:	ed8d 3b5c 	vstr	d3, [sp, #368]	@ 0x170
10002fe2:	ee07 3a90 	vmov	s15, r3
10002fe6:	ee23 3b0f 	vmul.f64	d3, d3, d15
10002fea:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10002fee:	ed8d 3b60 	vstr	d3, [sp, #384]	@ 0x180
10002ff2:	ed9d 3b18 	vldr	d3, [sp, #96]	@ 0x60
10002ff6:	ee07 3b09 	vmla.f64	d3, d7, d9
10002ffa:	ee2b 7b0f 	vmul.f64	d7, d11, d15
10002ffe:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10003002:	ed9d 4b08 	vldr	d4, [sp, #32]
10003006:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000300a:	ee06 1b09 	vmla.f64	d1, d6, d9
1000300e:	ee07 bb4e 	vmls.f64	d11, d7, d14
10003012:	ee24 6b0f 	vmul.f64	d6, d4, d15
10003016:	eefc 7bcb 	vcvt.u32.f64	s15, d11
1000301a:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000301e:	ee17 2a90 	vmov	r2, s15
10003022:	eeb8 7b46 	vcvt.f64.u32	d7, s12
10003026:	eeb0 6b44 	vmov.f64	d6, d4
1000302a:	ee07 6b4e 	vmls.f64	d6, d7, d14
1000302e:	0fd3      	lsrs	r3, r2, #31
10003030:	eefc 7bc6 	vcvt.u32.f64	s15, d6
10003034:	ee06 3a10 	vmov	s12, r3
10003038:	0853      	lsrs	r3, r2, #1
1000303a:	ee04 3a10 	vmov	s8, r3
1000303e:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10003042:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
10003046:	f002 0201 	and.w	r2, r2, #1
1000304a:	ee17 ea90 	vmov	lr, s15
1000304e:	ee06 4b09 	vmla.f64	d4, d6, d9
10003052:	ee07 2a90 	vmov	s15, r2
10003056:	ed8d 4b18 	vstr	d4, [sp, #96]	@ 0x60
1000305a:	eeb8 7be7 	vcvt.f64.s32	d7, s15
1000305e:	ed9d 4b0a 	vldr	d4, [sp, #40]	@ 0x28
10003062:	ea4f 73de 	mov.w	r3, lr, lsr #31
10003066:	ea4f 0c5e 	mov.w	ip, lr, lsr #1
1000306a:	ee07 4b09 	vmla.f64	d4, d7, d9
1000306e:	ee06 3a10 	vmov	s12, r3
10003072:	ee07 ca90 	vmov	s15, ip
10003076:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
1000307a:	eeb8 7be7 	vcvt.f64.s32	d7, s15
1000307e:	ee06 7b09 	vmla.f64	d7, d6, d9
10003082:	f00e 0301 	and.w	r3, lr, #1
10003086:	ed8d 4b10 	vstr	d4, [sp, #64]	@ 0x40
1000308a:	ed8d 7b0c 	vstr	d7, [sp, #48]	@ 0x30
1000308e:	ee07 3a90 	vmov	s15, r3
10003092:	ed9d 6b06 	vldr	d6, [sp, #24]
10003096:	ed9d bb0e 	vldr	d11, [sp, #56]	@ 0x38
1000309a:	eeb8 7be7 	vcvt.f64.s32	d7, s15
1000309e:	ee07 bb09 	vmla.f64	d11, d7, d9
100030a2:	ee26 7b0f 	vmul.f64	d7, d6, d15
100030a6:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100030aa:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100030ae:	eeb0 4b49 	vmov.f64	d4, d9
100030b2:	ee2a 9b0f 	vmul.f64	d9, d10, d15
100030b6:	ee07 6b4e 	vmls.f64	d6, d7, d14
100030ba:	eebc 9bc9 	vcvt.u32.f64	s18, d9
100030be:	eefc 7bc6 	vcvt.u32.f64	s15, d6
100030c2:	eeb8 9b49 	vcvt.f64.u32	d9, s18
100030c6:	ee17 2a90 	vmov	r2, s15
100030ca:	ee09 ab4e 	vmls.f64	d10, d9, d14
100030ce:	0fd3      	lsrs	r3, r2, #31
100030d0:	ee06 3a10 	vmov	s12, r3
100030d4:	0853      	lsrs	r3, r2, #1
100030d6:	eefc 7bca 	vcvt.u32.f64	s15, d10
100030da:	ee07 3a10 	vmov	s14, r3
100030de:	ee17 ea90 	vmov	lr, s15
100030e2:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100030e6:	f002 0201 	and.w	r2, r2, #1
100030ea:	eeb0 ab47 	vmov.f64	d10, d7
100030ee:	ee07 2a90 	vmov	s15, r2
100030f2:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
100030f6:	eeb8 7be7 	vcvt.f64.s32	d7, s15
100030fa:	ed9d 9b12 	vldr	d9, [sp, #72]	@ 0x48
100030fe:	ea4f 73de 	mov.w	r3, lr, lsr #31
10003102:	ea4f 0c5e 	mov.w	ip, lr, lsr #1
10003106:	ee06 ab04 	vmla.f64	d10, d6, d4
1000310a:	ee07 9b04 	vmla.f64	d9, d7, d4
1000310e:	ee06 3a10 	vmov	s12, r3
10003112:	ee07 ca90 	vmov	s15, ip
10003116:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
1000311a:	eeb8 7be7 	vcvt.f64.s32	d7, s15
1000311e:	ee06 7b04 	vmla.f64	d7, d6, d4
10003122:	f00e 0301 	and.w	r3, lr, #1
10003126:	ed8d 7b04 	vstr	d7, [sp, #16]
1000312a:	ee07 3a90 	vmov	s15, r3
1000312e:	ed9d 6b14 	vldr	d6, [sp, #80]	@ 0x50
10003132:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10003136:	ee07 6b04 	vmla.f64	d6, d7, d4
1000313a:	ee25 7b0f 	vmul.f64	d7, d5, d15
1000313e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10003142:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10003146:	ed8d 6b06 	vstr	d6, [sp, #24]
1000314a:	ee2c 6b0f 	vmul.f64	d6, d12, d15
1000314e:	ee07 5b4e 	vmls.f64	d5, d7, d14
10003152:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10003156:	eefc 7bc5 	vcvt.u32.f64	s15, d5
1000315a:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000315e:	ee17 3a90 	vmov	r3, s15
10003162:	ee06 cb4e 	vmls.f64	d12, d6, d14
10003166:	0fda      	lsrs	r2, r3, #31
10003168:	ee07 2a10 	vmov	s14, r2
1000316c:	085a      	lsrs	r2, r3, #1
1000316e:	ed8d ab08 	vstr	d10, [sp, #32]
10003172:	eefc 7bcc 	vcvt.u32.f64	s15, d12
10003176:	ee0a 2a10 	vmov	s20, r2
1000317a:	ee17 ea90 	vmov	lr, s15
1000317e:	eeb8 abca 	vcvt.f64.s32	d10, s20
10003182:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10003186:	f003 0301 	and.w	r3, r3, #1
1000318a:	ee07 ab04 	vmla.f64	d10, d7, d4
1000318e:	ee07 3a90 	vmov	s15, r3
10003192:	ea4f 025e 	mov.w	r2, lr, lsr #1
10003196:	ed8d 9b0a 	vstr	d9, [sp, #40]	@ 0x28
1000319a:	ea4f 7cde 	mov.w	ip, lr, lsr #31
1000319e:	ee09 2a10 	vmov	s18, r2
100031a2:	f00e 0201 	and.w	r2, lr, #1
100031a6:	ee07 2a10 	vmov	s14, r2
100031aa:	eeb8 6be7 	vcvt.f64.s32	d6, s15
100031ae:	ee07 ca90 	vmov	s15, ip
100031b2:	ee06 db04 	vmla.f64	d13, d6, d4
100031b6:	ed9d 5b16 	vldr	d5, [sp, #88]	@ 0x58
100031ba:	eeb8 6be7 	vcvt.f64.s32	d6, s15
100031be:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100031c2:	ee07 5b04 	vmla.f64	d5, d7, d4
100031c6:	ee28 7b0f 	vmul.f64	d7, d8, d15
100031ca:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100031ce:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100031d2:	ee07 8b4e 	vmls.f64	d8, d7, d14
100031d6:	eebc 7bc8 	vcvt.u32.f64	s14, d8
100031da:	ee17 3a10 	vmov	r3, s14
100031de:	0fdb      	lsrs	r3, r3, #31
100031e0:	ee07 3a10 	vmov	s14, r3
100031e4:	ed8d 8b5a 	vstr	d8, [sp, #360]	@ 0x168
100031e8:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100031ec:	ee28 8b0f 	vmul.f64	d8, d8, d15
100031f0:	eeb8 9bc9 	vcvt.f64.s32	d9, s18
100031f4:	ed8d 5b00 	vstr	d5, [sp]
100031f8:	ee06 9b04 	vmla.f64	d9, d6, d4
100031fc:	ed8d 7b62 	vstr	d7, [sp, #392]	@ 0x188
10003200:	ed8d bb0e 	vstr	d11, [sp, #56]	@ 0x38
10003204:	ed8d db02 	vstr	d13, [sp, #8]
10003208:	ed8d 8b5e 	vstr	d8, [sp, #376]	@ 0x178
1000320c:	f7fd fb8c 	bl	10000928 <fp64e_cmul_prepared>
10003210:	eeb0 bb40 	vmov.f64	d11, d0
10003214:	eeb0 db41 	vmov.f64	d13, d1
10003218:	eeb0 cb42 	vmov.f64	d12, d2
1000321c:	eeb0 8b43 	vmov.f64	d8, d3
10003220:	eeb0 0b4a 	vmov.f64	d0, d10
10003224:	eeb0 2b49 	vmov.f64	d2, d9
10003228:	ed9d 3b00 	vldr	d3, [sp]
1000322c:	ed9d 1b02 	vldr	d1, [sp, #8]
10003230:	ed8d bb1e 	vstr	d11, [sp, #120]	@ 0x78
10003234:	ed8d db20 	vstr	d13, [sp, #128]	@ 0x80
10003238:	ed8d cb22 	vstr	d12, [sp, #136]	@ 0x88
1000323c:	ed8d 8b24 	vstr	d8, [sp, #144]	@ 0x90
10003240:	f7fd fb72 	bl	10000928 <fp64e_cmul_prepared>
10003244:	ed9d 4b18 	vldr	d4, [sp, #96]	@ 0x60
10003248:	ed9d 7b0e 	vldr	d7, [sp, #56]	@ 0x38
1000324c:	ed81 4b00 	vstr	d4, [r1]
10003250:	ed9d 4b10 	vldr	d4, [sp, #64]	@ 0x40
10003254:	ed9d 5b0c 	vldr	d5, [sp, #48]	@ 0x30
10003258:	ed9d ab08 	vldr	d10, [sp, #32]
1000325c:	ed9d 9b0a 	vldr	d9, [sp, #40]	@ 0x28
10003260:	ed81 4b02 	vstr	d4, [r1, #8]
10003264:	ed9d 6b06 	vldr	d6, [sp, #24]
10003268:	ed84 7b02 	vstr	d7, [r4, #8]
1000326c:	ed9d 7b04 	vldr	d7, [sp, #16]
10003270:	ed84 5b00 	vstr	d5, [r4]
10003274:	3140      	adds	r1, #64	@ 0x40
10003276:	ed01 ab0c 	vstr	d10, [r1, #-48]	@ 0xffffffd0
1000327a:	ed01 9b0a 	vstr	d9, [r1, #-40]	@ 0xffffffd8
1000327e:	4588      	cmp	r8, r1
10003280:	ed84 7b04 	vstr	d7, [r4, #16]
10003284:	ed84 6b06 	vstr	d6, [r4, #24]
10003288:	ed8d 0b26 	vstr	d0, [sp, #152]	@ 0x98
1000328c:	ed01 bb08 	vstr	d11, [r1, #-32]	@ 0xffffffe0
10003290:	ed01 db06 	vstr	d13, [r1, #-24]	@ 0xffffffe8
10003294:	f104 0440 	add.w	r4, r4, #64	@ 0x40
10003298:	ed04 cb08 	vstr	d12, [r4, #-32]	@ 0xffffffe0
1000329c:	ed04 8b06 	vstr	d8, [r4, #-24]	@ 0xffffffe8
100032a0:	f106 0620 	add.w	r6, r6, #32
100032a4:	ed01 0b04 	vstr	d0, [r1, #-16]
100032a8:	ed01 1b02 	vstr	d1, [r1, #-8]
100032ac:	f107 0710 	add.w	r7, r7, #16
100032b0:	ed8d 1b28 	vstr	d1, [sp, #160]	@ 0xa0
100032b4:	ed04 2b04 	vstr	d2, [r4, #-16]
100032b8:	ed04 3b02 	vstr	d3, [r4, #-8]
100032bc:	ed8d 2b2a 	vstr	d2, [sp, #168]	@ 0xa8
100032c0:	ed8d 3b2c 	vstr	d3, [sp, #176]	@ 0xb0
100032c4:	f47e af62 	bne.w	1000218c <fndsa_vect_iFFT_fp64_exact+0x44>
100032c8:	f04f 0e04 	mov.w	lr, #4
100032cc:	f1ab 0103 	sub.w	r1, fp, #3
100032d0:	2900      	cmp	r1, #0
100032d2:	f000 825b 	beq.w	1000378c <fndsa_vect_iFFT_fp64_exact+0x1644>
100032d6:	2310      	movs	r3, #16
100032d8:	ed9f eb17 	vldr	d14, [pc, #92]	@ 10003338 <fndsa_vect_iFFT_fp64_exact+0x11f0>
100032dc:	ed9f fb18 	vldr	d15, [pc, #96]	@ 10003340 <fndsa_vect_iFFT_fp64_exact+0x11f8>
100032e0:	ed9f 9b13 	vldr	d9, [pc, #76]	@ 10003330 <fndsa_vect_iFFT_fp64_exact+0x11e8>
100032e4:	4e18      	ldr	r6, [pc, #96]	@ (10003348 <fndsa_vect_iFFT_fp64_exact+0x1200>)
100032e6:	fa03 fc0a 	lsl.w	ip, r3, sl
100032ea:	4672      	mov	r2, lr
100032ec:	2301      	movs	r3, #1
100032ee:	f04f 0810 	mov.w	r8, #16
100032f2:	eb05 1702 	add.w	r7, r5, r2, lsl #4
100032f6:	9208      	str	r2, [sp, #32]
100032f8:	eeb7 db00 	vmov.f64	d13, #112	@ 0x3f800000  1.0
100032fc:	462a      	mov	r2, r5
100032fe:	f04f 0b00 	mov.w	fp, #0
10003302:	46e1      	mov	r9, ip
10003304:	408b      	lsls	r3, r1
10003306:	eb03 0353 	add.w	r3, r3, r3, lsr #1
1000330a:	ea4f 0e4e 	mov.w	lr, lr, lsl #1
1000330e:	fa08 f801 	lsl.w	r8, r8, r1
10003312:	eb06 1303 	add.w	r3, r6, r3, lsl #4
10003316:	eb08 0a06 	add.w	sl, r8, r6
1000331a:	9306      	str	r3, [sp, #24]
1000331c:	910a      	str	r1, [sp, #40]	@ 0x28
1000331e:	f8cd e010 	str.w	lr, [sp, #16]
10003322:	ea4f 180e 	mov.w	r8, lr, lsl #4
10003326:	960c      	str	r6, [sp, #48]	@ 0x30
10003328:	950e      	str	r5, [sp, #56]	@ 0x38
1000332a:	e00f      	b.n	1000334c <fndsa_vect_iFFT_fp64_exact+0x1204>
1000332c:	f3af 8000 	nop.w
10003330:	00000000 	.word	0x00000000
10003334:	41e00000 	.word	0x41e00000
10003338:	00000000 	.word	0x00000000
1000333c:	41f00000 	.word	0x41f00000
10003340:	00000000 	.word	0x00000000
10003344:	3df00000 	.word	0x3df00000
10003348:	300009a0 	.word	0x300009a0
1000334c:	edda 7a02 	vldr	s15, [sl, #8]
10003350:	f8da 3004 	ldr.w	r3, [sl, #4]
10003354:	eeb8 4b67 	vcvt.f64.u32	d4, s15
10003358:	0fdb      	lsrs	r3, r3, #31
1000335a:	ee03 3a10 	vmov	s6, r3
1000335e:	ee3e 4b44 	vsub.f64	d4, d14, d4
10003362:	eeb8 3bc3 	vcvt.f64.s32	d3, s6
10003366:	edda 7a03 	vldr	s15, [sl, #12]
1000336a:	ed8d 3b4e 	vstr	d3, [sp, #312]	@ 0x138
1000336e:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10003372:	ee24 3b0f 	vmul.f64	d3, d4, d15
10003376:	ee3e 7b47 	vsub.f64	d7, d14, d7
1000337a:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000337e:	edda 6a00 	vldr	s13, [sl]
10003382:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10003386:	ee37 7b4d 	vsub.f64	d7, d7, d13
1000338a:	eeb8 5b66 	vcvt.f64.u32	d5, s13
1000338e:	ee37 7b03 	vadd.f64	d7, d7, d3
10003392:	edda 6a01 	vldr	s13, [sl, #4]
10003396:	ee03 4b4e 	vmls.f64	d4, d3, d14
1000339a:	eeb8 6b66 	vcvt.f64.u32	d6, s13
1000339e:	ee27 3b0f 	vmul.f64	d3, d7, d15
100033a2:	ee26 2b0f 	vmul.f64	d2, d6, d15
100033a6:	ee25 1b0f 	vmul.f64	d1, d5, d15
100033aa:	ed8d 5b48 	vstr	d5, [sp, #288]	@ 0x120
100033ae:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100033b2:	ee34 5b05 	vadd.f64	d5, d4, d5
100033b6:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100033ba:	ed8d 2b4a 	vstr	d2, [sp, #296]	@ 0x128
100033be:	ed8d 4b52 	vstr	d4, [sp, #328]	@ 0x148
100033c2:	ee24 2b0f 	vmul.f64	d2, d4, d15
100033c6:	ee25 4b0f 	vmul.f64	d4, d5, d15
100033ca:	ee03 7b4e 	vmls.f64	d7, d3, d14
100033ce:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100033d2:	eefc 3bc7 	vcvt.u32.f64	s7, d7
100033d6:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100033da:	ed8d 6b46 	vstr	d6, [sp, #280]	@ 0x118
100033de:	ee37 6b06 	vadd.f64	d6, d7, d6
100033e2:	ee13 1a90 	vmov	r1, s7
100033e6:	ed8d 7b50 	vstr	d7, [sp, #320]	@ 0x140
100033ea:	ee27 3b0f 	vmul.f64	d3, d7, d15
100033ee:	ee36 7b04 	vadd.f64	d7, d6, d4
100033f2:	ee27 6b0f 	vmul.f64	d6, d7, d15
100033f6:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100033fa:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100033fe:	ee06 7b4e 	vmls.f64	d7, d6, d14
10003402:	eefc 6bc7 	vcvt.u32.f64	s13, d7
10003406:	0fc9      	lsrs	r1, r1, #31
10003408:	ee04 5b4e 	vmls.f64	d5, d4, d14
1000340c:	ee04 1a10 	vmov	s8, r1
10003410:	ee16 1a90 	vmov	r1, s13
10003414:	0fc9      	lsrs	r1, r1, #31
10003416:	ee27 6b0f 	vmul.f64	d6, d7, d15
1000341a:	ed8d 7b5a 	vstr	d7, [sp, #360]	@ 0x168
1000341e:	ee07 1a10 	vmov	s14, r1
10003422:	ed8d 2b56 	vstr	d2, [sp, #344]	@ 0x158
10003426:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
1000342a:	ee25 2b0f 	vmul.f64	d2, d5, d15
1000342e:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10003432:	9b08      	ldr	r3, [sp, #32]
10003434:	ed8d 1b4c 	vstr	d1, [sp, #304]	@ 0x130
10003438:	445b      	add	r3, fp
1000343a:	459b      	cmp	fp, r3
1000343c:	ed8d 3b54 	vstr	d3, [sp, #336]	@ 0x150
10003440:	ed8d 5b5c 	vstr	d5, [sp, #368]	@ 0x170
10003444:	ed8d 4b58 	vstr	d4, [sp, #352]	@ 0x160
10003448:	ed8d 2b60 	vstr	d2, [sp, #384]	@ 0x180
1000344c:	ed8d 6b5e 	vstr	d6, [sp, #376]	@ 0x178
10003450:	ed8d 7b62 	vstr	d7, [sp, #392]	@ 0x188
10003454:	f080 8187 	bcs.w	10003766 <fndsa_vect_iFFT_fp64_exact+0x161e>
10003458:	463e      	mov	r6, r7
1000345a:	4611      	mov	r1, r2
1000345c:	eb09 0502 	add.w	r5, r9, r2
10003460:	eb09 0407 	add.w	r4, r9, r7
10003464:	9202      	str	r2, [sp, #8]
10003466:	ed91 ab02 	vldr	d10, [r1, #8]
1000346a:	ed96 7b02 	vldr	d7, [r6, #8]
1000346e:	ee3a 0b0e 	vadd.f64	d0, d10, d14
10003472:	ed91 cb00 	vldr	d12, [r1]
10003476:	ee37 ab0a 	vadd.f64	d10, d7, d10
1000347a:	ee30 7b47 	vsub.f64	d7, d0, d7
1000347e:	ed96 3b00 	vldr	d3, [r6]
10003482:	ee3c 1b0e 	vadd.f64	d1, d12, d14
10003486:	ee27 2b0f 	vmul.f64	d2, d7, d15
1000348a:	ee33 cb0c 	vadd.f64	d12, d3, d12
1000348e:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10003492:	ee31 3b43 	vsub.f64	d3, d1, d3
10003496:	eeb8 2b42 	vcvt.f64.u32	d2, s4
1000349a:	ee33 3b4d 	vsub.f64	d3, d3, d13
1000349e:	ee33 3b02 	vadd.f64	d3, d3, d2
100034a2:	ee02 7b4e 	vmls.f64	d7, d2, d14
100034a6:	ee23 1b0f 	vmul.f64	d1, d3, d15
100034aa:	ee37 7b0d 	vadd.f64	d7, d7, d13
100034ae:	eebc 1bc1 	vcvt.u32.f64	s2, d1
100034b2:	ed95 bb02 	vldr	d11, [r5, #8]
100034b6:	ee27 2b0f 	vmul.f64	d2, d7, d15
100034ba:	eeb8 1b41 	vcvt.f64.u32	d1, s2
100034be:	ed94 5b02 	vldr	d5, [r4, #8]
100034c2:	eefc 0bc2 	vcvt.u32.f64	s1, d2
100034c6:	ee01 3b4e 	vmls.f64	d3, d1, d14
100034ca:	ee3b 2b0e 	vadd.f64	d2, d11, d14
100034ce:	ed9f 4bb4 	vldr	d4, [pc, #720]	@ 100037a0 <fndsa_vect_iFFT_fp64_exact+0x1658>
100034d2:	ee3b bb05 	vadd.f64	d11, d11, d5
100034d6:	ee32 2b45 	vsub.f64	d2, d2, d5
100034da:	ee33 3b04 	vadd.f64	d3, d3, d4
100034de:	eeb8 5b60 	vcvt.f64.u32	d5, s1
100034e2:	ed94 8b00 	vldr	d8, [r4]
100034e6:	ed95 6b00 	vldr	d6, [r5]
100034ea:	ee33 3b05 	vadd.f64	d3, d3, d5
100034ee:	ee36 4b0e 	vadd.f64	d4, d6, d14
100034f2:	ee23 0b0f 	vmul.f64	d0, d3, d15
100034f6:	ee36 6b08 	vadd.f64	d6, d6, d8
100034fa:	ee05 7b4e 	vmls.f64	d7, d5, d14
100034fe:	ee22 5b0f 	vmul.f64	d5, d2, d15
10003502:	ed8d 6b00 	vstr	d6, [sp]
10003506:	eebc 0bc0 	vcvt.u32.f64	s0, d0
1000350a:	eeb6 6b00 	vmov.f64	d6, #96	@ 0x3f000000  0.5
1000350e:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10003512:	ee27 7b06 	vmul.f64	d7, d7, d6
10003516:	eeb8 0b40 	vcvt.f64.u32	d0, s0
1000351a:	ee34 6b48 	vsub.f64	d6, d4, d8
1000351e:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10003522:	ee00 3b4e 	vmls.f64	d3, d0, d14
10003526:	ee36 6b4d 	vsub.f64	d6, d6, d13
1000352a:	ee05 2b4e 	vmls.f64	d2, d5, d14
1000352e:	ee36 6b05 	vadd.f64	d6, d6, d5
10003532:	eefc 5bc3 	vcvt.u32.f64	s11, d3
10003536:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000353a:	ee32 2b0d 	vadd.f64	d2, d2, d13
1000353e:	ee15 3a90 	vmov	r3, s11
10003542:	eeb8 1b47 	vcvt.f64.u32	d1, s14
10003546:	ee22 7b0f 	vmul.f64	d7, d2, d15
1000354a:	0fda      	lsrs	r2, r3, #31
1000354c:	eefc 3bc7 	vcvt.u32.f64	s7, d7
10003550:	ee07 2a10 	vmov	s14, r2
10003554:	085a      	lsrs	r2, r3, #1
10003556:	ee00 2a10 	vmov	s0, r2
1000355a:	ee26 4b0f 	vmul.f64	d4, d6, d15
1000355e:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10003562:	eeb8 0bc0 	vcvt.f64.s32	d0, s0
10003566:	f003 0301 	and.w	r3, r3, #1
1000356a:	ee07 0b09 	vmla.f64	d0, d7, d9
1000356e:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10003572:	ee07 3a90 	vmov	s15, r3
10003576:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000357a:	eeb8 7be7 	vcvt.f64.s32	d7, s15
1000357e:	ee04 6b4e 	vmls.f64	d6, d4, d14
10003582:	ee07 1b09 	vmla.f64	d1, d7, d9
10003586:	ed9f 7b86 	vldr	d7, [pc, #536]	@ 100037a0 <fndsa_vect_iFFT_fp64_exact+0x1658>
1000358a:	eeb8 4b63 	vcvt.f64.u32	d4, s7
1000358e:	ee36 6b07 	vadd.f64	d6, d6, d7
10003592:	ee36 7b04 	vadd.f64	d7, d6, d4
10003596:	ee2a 5b0f 	vmul.f64	d5, d10, d15
1000359a:	ee04 2b4e 	vmls.f64	d2, d4, d14
1000359e:	ee27 4b0f 	vmul.f64	d4, d7, d15
100035a2:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100035a6:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100035aa:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100035ae:	eeb6 6b00 	vmov.f64	d6, #96	@ 0x3f000000  0.5
100035b2:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100035b6:	ee22 2b06 	vmul.f64	d2, d2, d6
100035ba:	ee3c 6b05 	vadd.f64	d6, d12, d5
100035be:	ee04 7b4e 	vmls.f64	d7, d4, d14
100035c2:	ee26 8b0f 	vmul.f64	d8, d6, d15
100035c6:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100035ca:	ee05 ab4e 	vmls.f64	d10, d5, d14
100035ce:	eefc 7bc7 	vcvt.u32.f64	s15, d7
100035d2:	ee3a 5b0d 	vadd.f64	d5, d10, d13
100035d6:	eeb8 3b42 	vcvt.f64.u32	d3, s4
100035da:	eebc 2bc8 	vcvt.u32.f64	s4, d8
100035de:	ee17 3a90 	vmov	r3, s15
100035e2:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100035e6:	ee25 4b0f 	vmul.f64	d4, d5, d15
100035ea:	0fda      	lsrs	r2, r3, #31
100035ec:	ee08 2a10 	vmov	s16, r2
100035f0:	085a      	lsrs	r2, r3, #1
100035f2:	ee02 6b4e 	vmls.f64	d6, d2, d14
100035f6:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100035fa:	ee02 2a10 	vmov	s4, r2
100035fe:	ed9f 7b68 	vldr	d7, [pc, #416]	@ 100037a0 <fndsa_vect_iFFT_fp64_exact+0x1658>
10003602:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10003606:	eeb8 8bc8 	vcvt.f64.s32	d8, s16
1000360a:	eeb8 2bc2 	vcvt.f64.s32	d2, s4
1000360e:	ee36 6b07 	vadd.f64	d6, d6, d7
10003612:	ee08 2b09 	vmla.f64	d2, d8, d9
10003616:	eeb6 ab00 	vmov.f64	d10, #96	@ 0x3f000000  0.5
1000361a:	ee2b 8b0f 	vmul.f64	d8, d11, d15
1000361e:	ee04 5b4e 	vmls.f64	d5, d4, d14
10003622:	ee36 6b04 	vadd.f64	d6, d6, d4
10003626:	f003 0301 	and.w	r3, r3, #1
1000362a:	ee25 5b0a 	vmul.f64	d5, d5, d10
1000362e:	ee07 3a90 	vmov	s15, r3
10003632:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10003636:	ee26 4b0f 	vmul.f64	d4, d6, d15
1000363a:	eeb8 8b48 	vcvt.f64.u32	d8, s16
1000363e:	eebc abc5 	vcvt.u32.f64	s20, d5
10003642:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10003646:	ed9d 5b00 	vldr	d5, [sp]
1000364a:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000364e:	ee07 3b09 	vmla.f64	d3, d7, d9
10003652:	ee35 7b08 	vadd.f64	d7, d5, d8
10003656:	eeb0 5b4b 	vmov.f64	d5, d11
1000365a:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000365e:	ee08 5b4e 	vmls.f64	d5, d8, d14
10003662:	ee27 cb0f 	vmul.f64	d12, d7, d15
10003666:	ee04 6b4e 	vmls.f64	d6, d4, d14
1000366a:	ee35 5b0d 	vadd.f64	d5, d5, d13
1000366e:	eebc cbcc 	vcvt.u32.f64	s24, d12
10003672:	eefc 6bc6 	vcvt.u32.f64	s13, d6
10003676:	ee25 4b0f 	vmul.f64	d4, d5, d15
1000367a:	eeb8 cb4c 	vcvt.f64.u32	d12, s24
1000367e:	ee16 3a90 	vmov	r3, s13
10003682:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10003686:	ed9f 6b46 	vldr	d6, [pc, #280]	@ 100037a0 <fndsa_vect_iFFT_fp64_exact+0x1658>
1000368a:	ee0c 7b4e 	vmls.f64	d7, d12, d14
1000368e:	0fda      	lsrs	r2, r3, #31
10003690:	eeb8 bb4a 	vcvt.f64.u32	d11, s20
10003694:	ee0a 2a10 	vmov	s20, r2
10003698:	085a      	lsrs	r2, r3, #1
1000369a:	f003 0301 	and.w	r3, r3, #1
1000369e:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100036a2:	ee37 7b06 	vadd.f64	d7, d7, d6
100036a6:	ee06 3a90 	vmov	s13, r3
100036aa:	ee37 7b04 	vadd.f64	d7, d7, d4
100036ae:	eeb8 6be6 	vcvt.f64.s32	d6, s13
100036b2:	ee06 bb09 	vmla.f64	d11, d6, d9
100036b6:	ee27 6b0f 	vmul.f64	d6, d7, d15
100036ba:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100036be:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100036c2:	ee08 2a10 	vmov	s16, r2
100036c6:	ee06 7b4e 	vmls.f64	d7, d6, d14
100036ca:	eeb8 abca 	vcvt.f64.s32	d10, s20
100036ce:	eeb8 8bc8 	vcvt.f64.s32	d8, s16
100036d2:	eefc 7bc7 	vcvt.u32.f64	s15, d7
100036d6:	ee04 5b4e 	vmls.f64	d5, d4, d14
100036da:	ee0a 8b09 	vmla.f64	d8, d10, d9
100036de:	eeb6 ab00 	vmov.f64	d10, #96	@ 0x3f000000  0.5
100036e2:	ee17 3a90 	vmov	r3, s15
100036e6:	ee25 5b0a 	vmul.f64	d5, d5, d10
100036ea:	0fda      	lsrs	r2, r3, #31
100036ec:	ee04 2a10 	vmov	s8, r2
100036f0:	085a      	lsrs	r2, r3, #1
100036f2:	f003 0301 	and.w	r3, r3, #1
100036f6:	ee06 2a10 	vmov	s12, r2
100036fa:	ee07 3a90 	vmov	s15, r3
100036fe:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10003702:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
10003706:	eeb8 7be7 	vcvt.f64.s32	d7, s15
1000370a:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000370e:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10003712:	ee07 5b09 	vmla.f64	d5, d7, d9
10003716:	ee04 6b09 	vmla.f64	d6, d4, d9
1000371a:	ed81 8b00 	vstr	d8, [r1]
1000371e:	ed81 bb02 	vstr	d11, [r1, #8]
10003722:	a846      	add	r0, sp, #280	@ 0x118
10003724:	ed85 6b00 	vstr	d6, [r5]
10003728:	ed85 5b02 	vstr	d5, [r5, #8]
1000372c:	f7fd f8fc 	bl	10000928 <fp64e_cmul_prepared>
10003730:	3110      	adds	r1, #16
10003732:	428f      	cmp	r7, r1
10003734:	ed86 0b00 	vstr	d0, [r6]
10003738:	ed86 1b02 	vstr	d1, [r6, #8]
1000373c:	ed8d 0b3e 	vstr	d0, [sp, #248]	@ 0xf8
10003740:	ed84 2b00 	vstr	d2, [r4]
10003744:	ed84 3b02 	vstr	d3, [r4, #8]
10003748:	ed8d 1b40 	vstr	d1, [sp, #256]	@ 0x100
1000374c:	ed8d 2b42 	vstr	d2, [sp, #264]	@ 0x108
10003750:	ed8d 3b44 	vstr	d3, [sp, #272]	@ 0x110
10003754:	f105 0510 	add.w	r5, r5, #16
10003758:	f106 0610 	add.w	r6, r6, #16
1000375c:	f104 0410 	add.w	r4, r4, #16
10003760:	f47f ae81 	bne.w	10003466 <fndsa_vect_iFFT_fp64_exact+0x131e>
10003764:	9a02      	ldr	r2, [sp, #8]
10003766:	9b04      	ldr	r3, [sp, #16]
10003768:	f10a 0a10 	add.w	sl, sl, #16
1000376c:	449b      	add	fp, r3
1000376e:	9b06      	ldr	r3, [sp, #24]
10003770:	4442      	add	r2, r8
10003772:	4553      	cmp	r3, sl
10003774:	4447      	add	r7, r8
10003776:	f47f ade9 	bne.w	1000334c <fndsa_vect_iFFT_fp64_exact+0x1204>
1000377a:	990a      	ldr	r1, [sp, #40]	@ 0x28
1000377c:	46cc      	mov	ip, r9
1000377e:	3901      	subs	r1, #1
10003780:	f8dd e010 	ldr.w	lr, [sp, #16]
10003784:	9e0c      	ldr	r6, [sp, #48]	@ 0x30
10003786:	9d0e      	ldr	r5, [sp, #56]	@ 0x38
10003788:	f47f adaf 	bne.w	100032ea <fndsa_vect_iFFT_fp64_exact+0x11a2>
1000378c:	b065      	add	sp, #404	@ 0x194
1000378e:	ecbd 8b10 	vpop	{d8-d15}
10003792:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10003796:	4651      	mov	r1, sl
10003798:	f04f 0e01 	mov.w	lr, #1
1000379c:	e598      	b.n	100032d0 <fndsa_vect_iFFT_fp64_exact+0x1188>
1000379e:	bf00      	nop
	...

