100070d0 <fndsa_vect_iFFT_fp64_exact>:
100070d0:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
100070d4:	ed2d 8b10 	vpush	{d8-d15}
100070d8:	1e45      	subs	r5, r0, #1
100070da:	b0af      	sub	sp, #188	@ 0xbc
100070dc:	f000 825e 	beq.w	1000759c <fndsa_vect_iFFT_fp64_exact+0x4cc>
100070e0:	2310      	movs	r3, #16
100070e2:	f04f 0e01 	mov.w	lr, #1
100070e6:	ed9f ebf8 	vldr	d14, [pc, #992]	@ 100074c8 <fndsa_vect_iFFT_fp64_exact+0x3f8>
100070ea:	ed9f fbf9 	vldr	d15, [pc, #996]	@ 100074d0 <fndsa_vect_iFFT_fp64_exact+0x400>
100070ee:	ed9f 9bfa 	vldr	d9, [pc, #1000]	@ 100074d8 <fndsa_vect_iFFT_fp64_exact+0x408>
100070f2:	fa03 fc05 	lsl.w	ip, r3, r5
100070f6:	4672      	mov	r2, lr
100070f8:	2301      	movs	r3, #1
100070fa:	f04f 0810 	mov.w	r8, #16
100070fe:	e9cd 2505 	strd	r2, r5, [sp, #20]
10007102:	eb01 1702 	add.w	r7, r1, r2, lsl #4
10007106:	eeb7 db00 	vmov.f64	d13, #112	@ 0x3f800000  1.0
1000710a:	460a      	mov	r2, r1
1000710c:	f04f 0b00 	mov.w	fp, #0
10007110:	46e1      	mov	r9, ip
10007112:	48f5      	ldr	r0, [pc, #980]	@ (100074e8 <fndsa_vect_iFFT_fp64_exact+0x418>)
10007114:	40ab      	lsls	r3, r5
10007116:	eb03 0353 	add.w	r3, r3, r3, lsr #1
1000711a:	ea4f 0e4e 	mov.w	lr, lr, lsl #1
1000711e:	fa08 f805 	lsl.w	r8, r8, r5
10007122:	eb00 1303 	add.w	r3, r0, r3, lsl #4
10007126:	eb08 0a00 	add.w	sl, r8, r0
1000712a:	9304      	str	r3, [sp, #16]
1000712c:	f8cd e00c 	str.w	lr, [sp, #12]
10007130:	ea4f 180e 	mov.w	r8, lr, lsl #4
10007134:	9107      	str	r1, [sp, #28]
10007136:	edda 7a02 	vldr	s15, [sl, #8]
1000713a:	f8da 3004 	ldr.w	r3, [sl, #4]
1000713e:	eeb8 4b67 	vcvt.f64.u32	d4, s15
10007142:	0fdb      	lsrs	r3, r3, #31
10007144:	ee03 3a10 	vmov	s6, r3
10007148:	ee3e 4b44 	vsub.f64	d4, d14, d4
1000714c:	eeb8 3bc3 	vcvt.f64.s32	d3, s6
10007150:	edda 7a03 	vldr	s15, [sl, #12]
10007154:	ed8d 3b18 	vstr	d3, [sp, #96]	@ 0x60
10007158:	eeb8 7b67 	vcvt.f64.u32	d7, s15
1000715c:	ee24 3b0f 	vmul.f64	d3, d4, d15
10007160:	ee3e 7b47 	vsub.f64	d7, d14, d7
10007164:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10007168:	edda 6a00 	vldr	s13, [sl]
1000716c:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10007170:	ee37 7b4d 	vsub.f64	d7, d7, d13
10007174:	eeb8 5b66 	vcvt.f64.u32	d5, s13
10007178:	ee37 7b03 	vadd.f64	d7, d7, d3
1000717c:	edda 6a01 	vldr	s13, [sl, #4]
10007180:	ee03 4b4e 	vmls.f64	d4, d3, d14
10007184:	eeb8 6b66 	vcvt.f64.u32	d6, s13
10007188:	ee27 3b0f 	vmul.f64	d3, d7, d15
1000718c:	ee26 2b0f 	vmul.f64	d2, d6, d15
10007190:	ee25 1b0f 	vmul.f64	d1, d5, d15
10007194:	ed8d 5b12 	vstr	d5, [sp, #72]	@ 0x48
10007198:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000719c:	ee34 5b05 	vadd.f64	d5, d4, d5
100071a0:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100071a4:	ed8d 2b14 	vstr	d2, [sp, #80]	@ 0x50
100071a8:	ed8d 4b1c 	vstr	d4, [sp, #112]	@ 0x70
100071ac:	ee24 2b0f 	vmul.f64	d2, d4, d15
100071b0:	ee25 4b0f 	vmul.f64	d4, d5, d15
100071b4:	ee03 7b4e 	vmls.f64	d7, d3, d14
100071b8:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100071bc:	eefc 3bc7 	vcvt.u32.f64	s7, d7
100071c0:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100071c4:	ed8d 6b10 	vstr	d6, [sp, #64]	@ 0x40
100071c8:	ee37 6b06 	vadd.f64	d6, d7, d6
100071cc:	9b05      	ldr	r3, [sp, #20]
100071ce:	ed8d 7b1a 	vstr	d7, [sp, #104]	@ 0x68
100071d2:	eb03 010b 	add.w	r1, r3, fp
100071d6:	ee13 3a90 	vmov	r3, s7
100071da:	ee27 3b0f 	vmul.f64	d3, d7, d15
100071de:	ee36 7b04 	vadd.f64	d7, d6, d4
100071e2:	ee27 6b0f 	vmul.f64	d6, d7, d15
100071e6:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100071ea:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100071ee:	ee06 7b4e 	vmls.f64	d7, d6, d14
100071f2:	eefc 6bc7 	vcvt.u32.f64	s13, d7
100071f6:	0fdb      	lsrs	r3, r3, #31
100071f8:	ee04 5b4e 	vmls.f64	d5, d4, d14
100071fc:	ee04 3a10 	vmov	s8, r3
10007200:	ee16 3a90 	vmov	r3, s13
10007204:	0fdb      	lsrs	r3, r3, #31
10007206:	ee27 6b0f 	vmul.f64	d6, d7, d15
1000720a:	ed8d 7b24 	vstr	d7, [sp, #144]	@ 0x90
1000720e:	ee07 3a10 	vmov	s14, r3
10007212:	ed8d 2b20 	vstr	d2, [sp, #128]	@ 0x80
10007216:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
1000721a:	ee25 2b0f 	vmul.f64	d2, d5, d15
1000721e:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10007222:	458b      	cmp	fp, r1
10007224:	ed8d 1b16 	vstr	d1, [sp, #88]	@ 0x58
10007228:	ed8d 3b1e 	vstr	d3, [sp, #120]	@ 0x78
1000722c:	ed8d 5b26 	vstr	d5, [sp, #152]	@ 0x98
10007230:	ed8d 4b22 	vstr	d4, [sp, #136]	@ 0x88
10007234:	ed8d 2b2a 	vstr	d2, [sp, #168]	@ 0xa8
10007238:	ed8d 6b28 	vstr	d6, [sp, #160]	@ 0xa0
1000723c:	ed8d 7b2c 	vstr	d7, [sp, #176]	@ 0xb0
10007240:	f080 819a 	bcs.w	10007578 <fndsa_vect_iFFT_fp64_exact+0x4a8>
10007244:	463e      	mov	r6, r7
10007246:	4611      	mov	r1, r2
10007248:	eb09 0502 	add.w	r5, r9, r2
1000724c:	eb09 0407 	add.w	r4, r9, r7
10007250:	9202      	str	r2, [sp, #8]
10007252:	ed91 ab02 	vldr	d10, [r1, #8]
10007256:	ed96 7b02 	vldr	d7, [r6, #8]
1000725a:	ee3a 0b0e 	vadd.f64	d0, d10, d14
1000725e:	ed91 cb00 	vldr	d12, [r1]
10007262:	ee3a ab07 	vadd.f64	d10, d10, d7
10007266:	ee30 7b47 	vsub.f64	d7, d0, d7
1000726a:	ed96 3b00 	vldr	d3, [r6]
1000726e:	ee3c 1b0e 	vadd.f64	d1, d12, d14
10007272:	ee27 2b0f 	vmul.f64	d2, d7, d15
10007276:	ee33 cb0c 	vadd.f64	d12, d3, d12
1000727a:	eebc 2bc2 	vcvt.u32.f64	s4, d2
1000727e:	ee31 3b43 	vsub.f64	d3, d1, d3
10007282:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10007286:	ee33 3b4d 	vsub.f64	d3, d3, d13
1000728a:	ee33 3b02 	vadd.f64	d3, d3, d2
1000728e:	ee02 7b4e 	vmls.f64	d7, d2, d14
10007292:	ee23 1b0f 	vmul.f64	d1, d3, d15
10007296:	ee37 7b0d 	vadd.f64	d7, d7, d13
1000729a:	eebc 1bc1 	vcvt.u32.f64	s2, d1
1000729e:	ed95 bb02 	vldr	d11, [r5, #8]
100072a2:	ee27 2b0f 	vmul.f64	d2, d7, d15
100072a6:	eeb8 1b41 	vcvt.f64.u32	d1, s2
100072aa:	ed94 5b02 	vldr	d5, [r4, #8]
100072ae:	eefc 0bc2 	vcvt.u32.f64	s1, d2
100072b2:	ee01 3b4e 	vmls.f64	d3, d1, d14
100072b6:	ee3b 2b0e 	vadd.f64	d2, d11, d14
100072ba:	ed9f 4b89 	vldr	d4, [pc, #548]	@ 100074e0 <fndsa_vect_iFFT_fp64_exact+0x410>
100072be:	ee35 bb0b 	vadd.f64	d11, d5, d11
100072c2:	ee32 2b45 	vsub.f64	d2, d2, d5
100072c6:	ee33 3b04 	vadd.f64	d3, d3, d4
100072ca:	eeb8 5b60 	vcvt.f64.u32	d5, s1
100072ce:	ed94 8b00 	vldr	d8, [r4]
100072d2:	ed95 6b00 	vldr	d6, [r5]
100072d6:	ee33 3b05 	vadd.f64	d3, d3, d5
100072da:	ee36 4b0e 	vadd.f64	d4, d6, d14
100072de:	ee23 0b0f 	vmul.f64	d0, d3, d15
100072e2:	ee36 6b08 	vadd.f64	d6, d6, d8
100072e6:	ee05 7b4e 	vmls.f64	d7, d5, d14
100072ea:	ee22 5b0f 	vmul.f64	d5, d2, d15
100072ee:	ed8d 6b00 	vstr	d6, [sp]
100072f2:	eebc 0bc0 	vcvt.u32.f64	s0, d0
100072f6:	eeb6 6b00 	vmov.f64	d6, #96	@ 0x3f000000  0.5
100072fa:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100072fe:	ee27 7b06 	vmul.f64	d7, d7, d6
10007302:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10007306:	ee34 6b48 	vsub.f64	d6, d4, d8
1000730a:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000730e:	ee00 3b4e 	vmls.f64	d3, d0, d14
10007312:	ee36 6b4d 	vsub.f64	d6, d6, d13
10007316:	ee05 2b4e 	vmls.f64	d2, d5, d14
1000731a:	ee36 6b05 	vadd.f64	d6, d6, d5
1000731e:	eefc 5bc3 	vcvt.u32.f64	s11, d3
10007322:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007326:	ee32 2b0d 	vadd.f64	d2, d2, d13
1000732a:	ee15 3a90 	vmov	r3, s11
1000732e:	eeb8 1b47 	vcvt.f64.u32	d1, s14
10007332:	ee22 7b0f 	vmul.f64	d7, d2, d15
10007336:	0fda      	lsrs	r2, r3, #31
10007338:	eefc 3bc7 	vcvt.u32.f64	s7, d7
1000733c:	ee07 2a10 	vmov	s14, r2
10007340:	085a      	lsrs	r2, r3, #1
10007342:	ee00 2a10 	vmov	s0, r2
10007346:	ee26 4b0f 	vmul.f64	d4, d6, d15
1000734a:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
1000734e:	eeb8 0bc0 	vcvt.f64.s32	d0, s0
10007352:	f003 0301 	and.w	r3, r3, #1
10007356:	ee07 0b09 	vmla.f64	d0, d7, d9
1000735a:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000735e:	ee07 3a90 	vmov	s15, r3
10007362:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10007366:	eeb8 7be7 	vcvt.f64.s32	d7, s15
1000736a:	ee04 6b4e 	vmls.f64	d6, d4, d14
1000736e:	ee07 1b09 	vmla.f64	d1, d7, d9
10007372:	ed9f 7b5b 	vldr	d7, [pc, #364]	@ 100074e0 <fndsa_vect_iFFT_fp64_exact+0x410>
10007376:	eeb8 4b63 	vcvt.f64.u32	d4, s7
1000737a:	ee36 6b07 	vadd.f64	d6, d6, d7
1000737e:	ee36 7b04 	vadd.f64	d7, d6, d4
10007382:	ee2a 5b0f 	vmul.f64	d5, d10, d15
10007386:	ee04 2b4e 	vmls.f64	d2, d4, d14
1000738a:	ee27 4b0f 	vmul.f64	d4, d7, d15
1000738e:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10007392:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10007396:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000739a:	eeb6 6b00 	vmov.f64	d6, #96	@ 0x3f000000  0.5
1000739e:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100073a2:	ee22 2b06 	vmul.f64	d2, d2, d6
100073a6:	ee3c 6b05 	vadd.f64	d6, d12, d5
100073aa:	ee04 7b4e 	vmls.f64	d7, d4, d14
100073ae:	ee26 8b0f 	vmul.f64	d8, d6, d15
100073b2:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100073b6:	ee05 ab4e 	vmls.f64	d10, d5, d14
100073ba:	eefc 7bc7 	vcvt.u32.f64	s15, d7
100073be:	ee3a 5b0d 	vadd.f64	d5, d10, d13
100073c2:	eeb8 3b42 	vcvt.f64.u32	d3, s4
100073c6:	eebc 2bc8 	vcvt.u32.f64	s4, d8
100073ca:	ee17 3a90 	vmov	r3, s15
100073ce:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100073d2:	ee25 4b0f 	vmul.f64	d4, d5, d15
100073d6:	0fda      	lsrs	r2, r3, #31
100073d8:	ee08 2a10 	vmov	s16, r2
100073dc:	085a      	lsrs	r2, r3, #1
100073de:	ee02 6b4e 	vmls.f64	d6, d2, d14
100073e2:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100073e6:	ee02 2a10 	vmov	s4, r2
100073ea:	ed9f 7b3d 	vldr	d7, [pc, #244]	@ 100074e0 <fndsa_vect_iFFT_fp64_exact+0x410>
100073ee:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100073f2:	eeb8 8bc8 	vcvt.f64.s32	d8, s16
100073f6:	eeb8 2bc2 	vcvt.f64.s32	d2, s4
100073fa:	ee36 6b07 	vadd.f64	d6, d6, d7
100073fe:	ee08 2b09 	vmla.f64	d2, d8, d9
10007402:	eeb6 ab00 	vmov.f64	d10, #96	@ 0x3f000000  0.5
10007406:	ee2b 8b0f 	vmul.f64	d8, d11, d15
1000740a:	ee04 5b4e 	vmls.f64	d5, d4, d14
1000740e:	ee36 6b04 	vadd.f64	d6, d6, d4
10007412:	f003 0301 	and.w	r3, r3, #1
10007416:	ee25 5b0a 	vmul.f64	d5, d5, d10
1000741a:	ee07 3a90 	vmov	s15, r3
1000741e:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10007422:	ee26 4b0f 	vmul.f64	d4, d6, d15
10007426:	eeb8 8b48 	vcvt.f64.u32	d8, s16
1000742a:	eebc abc5 	vcvt.u32.f64	s20, d5
1000742e:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10007432:	ed9d 5b00 	vldr	d5, [sp]
10007436:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000743a:	ee07 3b09 	vmla.f64	d3, d7, d9
1000743e:	ee35 7b08 	vadd.f64	d7, d5, d8
10007442:	eeb0 5b4b 	vmov.f64	d5, d11
10007446:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000744a:	ee08 5b4e 	vmls.f64	d5, d8, d14
1000744e:	ee27 cb0f 	vmul.f64	d12, d7, d15
10007452:	ee04 6b4e 	vmls.f64	d6, d4, d14
10007456:	ee35 5b0d 	vadd.f64	d5, d5, d13
1000745a:	eebc cbcc 	vcvt.u32.f64	s24, d12
1000745e:	eefc 6bc6 	vcvt.u32.f64	s13, d6
10007462:	ee25 4b0f 	vmul.f64	d4, d5, d15
10007466:	eeb8 cb4c 	vcvt.f64.u32	d12, s24
1000746a:	ee16 3a90 	vmov	r3, s13
1000746e:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10007472:	ed9f 6b1b 	vldr	d6, [pc, #108]	@ 100074e0 <fndsa_vect_iFFT_fp64_exact+0x410>
10007476:	ee0c 7b4e 	vmls.f64	d7, d12, d14
1000747a:	0fda      	lsrs	r2, r3, #31
1000747c:	eeb8 bb4a 	vcvt.f64.u32	d11, s20
10007480:	ee0a 2a10 	vmov	s20, r2
10007484:	085a      	lsrs	r2, r3, #1
10007486:	f003 0301 	and.w	r3, r3, #1
1000748a:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000748e:	ee37 7b06 	vadd.f64	d7, d7, d6
10007492:	ee06 3a90 	vmov	s13, r3
10007496:	ee37 7b04 	vadd.f64	d7, d7, d4
1000749a:	eeb8 6be6 	vcvt.f64.s32	d6, s13
1000749e:	ee06 bb09 	vmla.f64	d11, d6, d9
100074a2:	ee27 6b0f 	vmul.f64	d6, d7, d15
100074a6:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100074aa:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100074ae:	ee08 2a10 	vmov	s16, r2
100074b2:	ee06 7b4e 	vmls.f64	d7, d6, d14
100074b6:	eeb8 abca 	vcvt.f64.s32	d10, s20
100074ba:	eeb8 8bc8 	vcvt.f64.s32	d8, s16
100074be:	eefc 7bc7 	vcvt.u32.f64	s15, d7
100074c2:	ee04 5b4e 	vmls.f64	d5, d4, d14
100074c6:	e011      	b.n	100074ec <fndsa_vect_iFFT_fp64_exact+0x41c>
100074c8:	00000000 	.word	0x00000000
100074cc:	41f00000 	.word	0x41f00000
100074d0:	00000000 	.word	0x00000000
100074d4:	3df00000 	.word	0x3df00000
100074d8:	00000000 	.word	0x00000000
100074dc:	41e00000 	.word	0x41e00000
	...
100074e8:	300039a0 	.word	0x300039a0
100074ec:	ee0a 8b09 	vmla.f64	d8, d10, d9
100074f0:	eeb6 ab00 	vmov.f64	d10, #96	@ 0x3f000000  0.5
100074f4:	ee17 3a90 	vmov	r3, s15
100074f8:	ee25 5b0a 	vmul.f64	d5, d5, d10
100074fc:	0fda      	lsrs	r2, r3, #31
100074fe:	ee04 2a10 	vmov	s8, r2
10007502:	085a      	lsrs	r2, r3, #1
10007504:	f003 0301 	and.w	r3, r3, #1
10007508:	ee06 2a10 	vmov	s12, r2
1000750c:	ee07 3a90 	vmov	s15, r3
10007510:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10007514:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
10007518:	eeb8 7be7 	vcvt.f64.s32	d7, s15
1000751c:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10007520:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10007524:	ee07 5b09 	vmla.f64	d5, d7, d9
10007528:	ee04 6b09 	vmla.f64	d6, d4, d9
1000752c:	ed81 8b00 	vstr	d8, [r1]
10007530:	ed81 bb02 	vstr	d11, [r1, #8]
10007534:	a810      	add	r0, sp, #64	@ 0x40
10007536:	ed85 6b00 	vstr	d6, [r5]
1000753a:	ed85 5b02 	vstr	d5, [r5, #8]
1000753e:	f7fe fdef 	bl	10006120 <fp64e_cmul_prepared>
10007542:	3110      	adds	r1, #16
10007544:	428f      	cmp	r7, r1
10007546:	ed86 0b00 	vstr	d0, [r6]
1000754a:	ed86 1b02 	vstr	d1, [r6, #8]
1000754e:	ed8d 0b08 	vstr	d0, [sp, #32]
10007552:	ed84 2b00 	vstr	d2, [r4]
10007556:	ed84 3b02 	vstr	d3, [r4, #8]
1000755a:	ed8d 1b0a 	vstr	d1, [sp, #40]	@ 0x28
1000755e:	ed8d 2b0c 	vstr	d2, [sp, #48]	@ 0x30
10007562:	ed8d 3b0e 	vstr	d3, [sp, #56]	@ 0x38
10007566:	f105 0510 	add.w	r5, r5, #16
1000756a:	f106 0610 	add.w	r6, r6, #16
1000756e:	f104 0410 	add.w	r4, r4, #16
10007572:	f47f ae6e 	bne.w	10007252 <fndsa_vect_iFFT_fp64_exact+0x182>
10007576:	9a02      	ldr	r2, [sp, #8]
10007578:	9b03      	ldr	r3, [sp, #12]
1000757a:	f10a 0a10 	add.w	sl, sl, #16
1000757e:	449b      	add	fp, r3
10007580:	9b04      	ldr	r3, [sp, #16]
10007582:	4442      	add	r2, r8
10007584:	4553      	cmp	r3, sl
10007586:	4447      	add	r7, r8
10007588:	f47f add5 	bne.w	10007136 <fndsa_vect_iFFT_fp64_exact+0x66>
1000758c:	9d06      	ldr	r5, [sp, #24]
1000758e:	46cc      	mov	ip, r9
10007590:	3d01      	subs	r5, #1
10007592:	f8dd e00c 	ldr.w	lr, [sp, #12]
10007596:	9907      	ldr	r1, [sp, #28]
10007598:	f47f adad 	bne.w	100070f6 <fndsa_vect_iFFT_fp64_exact+0x26>
1000759c:	b02f      	add	sp, #188	@ 0xbc
1000759e:	ecbd 8b10 	vpop	{d8-d15}
100075a2:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
100075a6:	bf00      	nop

