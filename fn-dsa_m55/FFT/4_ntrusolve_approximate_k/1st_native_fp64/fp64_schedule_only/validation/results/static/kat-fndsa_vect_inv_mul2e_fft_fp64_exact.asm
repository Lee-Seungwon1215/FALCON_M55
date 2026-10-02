10004fe0 <fndsa_vect_inv_mul2e_fft_fp64_exact>:
10004fe0:	b5f0      	push	{r4, r5, r6, r7, lr}
10004fe2:	2701      	movs	r7, #1
10004fe4:	fa07 f202 	lsl.w	r2, r7, r2
10004fe8:	ee07 2a90 	vmov	s15, r2
10004fec:	2410      	movs	r4, #16
10004fee:	ed2d 8b10 	vpush	{d8-d15}
10004ff2:	2600      	movs	r6, #0
10004ff4:	ed9f fbf8 	vldr	d15, [pc, #992]	@ 100053d8 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x3f8>
10004ff8:	ed9f ebf9 	vldr	d14, [pc, #996]	@ 100053e0 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x400>
10004ffc:	460d      	mov	r5, r1
10004ffe:	eeb8 bb67 	vcvt.f64.u32	d11, s15
10005002:	3801      	subs	r0, #1
10005004:	4084      	lsls	r4, r0
10005006:	b091      	sub	sp, #68	@ 0x44
10005008:	4087      	lsls	r7, r0
1000500a:	440c      	add	r4, r1
1000500c:	ed94 9b02 	vldr	d9, [r4, #8]
10005010:	ed95 3b00 	vldr	d3, [r5]
10005014:	ed95 6b02 	vldr	d6, [r5, #8]
10005018:	ee3f 9b49 	vsub.f64	d9, d15, d9
1000501c:	eebc abc3 	vcvt.u32.f64	s20, d3
10005020:	ed94 5b00 	vldr	d5, [r4]
10005024:	ee26 1b0e 	vmul.f64	d1, d6, d14
10005028:	ee29 2b0e 	vmul.f64	d2, d9, d14
1000502c:	ee1a 3a10 	vmov	r3, s20
10005030:	eeb7 4b00 	vmov.f64	d4, #112	@ 0x3f800000  1.0
10005034:	ed95 0b00 	vldr	d0, [r5]
10005038:	ee26 3b01 	vmul.f64	d3, d6, d1
1000503c:	ee3f 5b45 	vsub.f64	d5, d15, d5
10005040:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10005044:	0fdb      	lsrs	r3, r3, #31
10005046:	ed95 7b00 	vldr	d7, [r5]
1000504a:	ee35 5b44 	vsub.f64	d5, d5, d4
1000504e:	ee20 1b01 	vmul.f64	d1, d0, d1
10005052:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10005056:	ee0a 3a10 	vmov	s20, r3
1000505a:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000505e:	ee35 cb02 	vadd.f64	d12, d5, d2
10005062:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10005066:	ee27 7b0e 	vmul.f64	d7, d7, d14
1000506a:	eebc 1bc1 	vcvt.u32.f64	s2, d1
1000506e:	eeb8 abca 	vcvt.f64.s32	d10, s20
10005072:	ee02 9b4f 	vmls.f64	d9, d2, d15
10005076:	ee26 8b07 	vmul.f64	d8, d6, d7
1000507a:	ee23 2b4f 	vnmul.f64	d2, d3, d15
1000507e:	eea6 2b06 	vfma.f64	d2, d6, d6
10005082:	ee20 7b07 	vmul.f64	d7, d0, d7
10005086:	ee32 2b0f 	vadd.f64	d2, d2, d15
1000508a:	ee2a 0b06 	vmul.f64	d0, d10, d6
1000508e:	eeb8 ab41 	vcvt.f64.u32	d10, s2
10005092:	ee2c 1b0e 	vmul.f64	d1, d12, d14
10005096:	ee22 2b0e 	vmul.f64	d2, d2, d14
1000509a:	eebc 1bc1 	vcvt.u32.f64	s2, d1
1000509e:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100050a2:	eeb8 1b41 	vcvt.f64.u32	d1, s2
100050a6:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100050aa:	ee01 cb4f 	vmls.f64	d12, d1, d15
100050ae:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100050b2:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100050b6:	ee32 2b03 	vadd.f64	d2, d2, d3
100050ba:	eebc 3bcc 	vcvt.u32.f64	s6, d12
100050be:	ed95 5b00 	vldr	d5, [r5]
100050c2:	ee27 7b4f 	vnmul.f64	d7, d7, d15
100050c6:	eea5 7b05 	vfma.f64	d7, d5, d5
100050ca:	ee37 7b0f 	vadd.f64	d7, d7, d15
100050ce:	ee13 3a10 	vmov	r3, s6
100050d2:	ee27 5b0e 	vmul.f64	d5, d7, d14
100050d6:	0fdb      	lsrs	r3, r3, #31
100050d8:	ee03 3a10 	vmov	s6, r3
100050dc:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100050e0:	ee32 2b44 	vsub.f64	d2, d2, d4
100050e4:	eeb8 3bc3 	vcvt.f64.s32	d3, s6
100050e8:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100050ec:	ed8d 2b0c 	vstr	d2, [sp, #48]	@ 0x30
100050f0:	ee05 7b4f 	vmls.f64	d7, d5, d15
100050f4:	ee29 2b0e 	vmul.f64	d2, d9, d14
100050f8:	ee23 5b09 	vmul.f64	d5, d3, d9
100050fc:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10005100:	ed8d 5b06 	vstr	d5, [sp, #24]
10005104:	ee2c 3b0e 	vmul.f64	d3, d12, d14
10005108:	ee22 5b09 	vmul.f64	d5, d2, d9
1000510c:	ee22 2b0c 	vmul.f64	d2, d2, d12
10005110:	ed8d 0b08 	vstr	d0, [sp, #32]
10005114:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10005118:	ee23 0b09 	vmul.f64	d0, d3, d9
1000511c:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10005120:	ee23 3b0c 	vmul.f64	d3, d3, d12
10005124:	ed95 1b00 	vldr	d1, [r5]
10005128:	ed8d 7b0e 	vstr	d7, [sp, #56]	@ 0x38
1000512c:	eeb8 db42 	vcvt.f64.u32	d13, s4
10005130:	ee28 7b4f 	vnmul.f64	d7, d8, d15
10005134:	eea6 7b01 	vfma.f64	d7, d6, d1
10005138:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000513c:	ee2a 2b4f 	vnmul.f64	d2, d10, d15
10005140:	eea1 2b06 	vfma.f64	d2, d1, d6
10005144:	ee26 6b0b 	vmul.f64	d6, d6, d11
10005148:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000514c:	ed8d 6b0a 	vstr	d6, [sp, #40]	@ 0x28
10005150:	eeb8 6b43 	vcvt.f64.u32	d6, s6
10005154:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10005158:	eebc 0bc0 	vcvt.u32.f64	s0, d0
1000515c:	ee26 6b4f 	vnmul.f64	d6, d6, d15
10005160:	eeac 6b0c 	vfma.f64	d6, d12, d12
10005164:	ee36 3b0f 	vadd.f64	d3, d6, d15
10005168:	eeb8 0b40 	vcvt.f64.u32	d0, s0
1000516c:	ed8d 3b04 	vstr	d3, [sp, #16]
10005170:	ee25 3b4f 	vnmul.f64	d3, d5, d15
10005174:	eea9 3b09 	vfma.f64	d3, d9, d9
10005178:	ee33 3b0f 	vadd.f64	d3, d3, d15
1000517c:	ee20 1b4f 	vnmul.f64	d1, d0, d15
10005180:	eea9 1b0c 	vfma.f64	d1, d9, d12
10005184:	ee23 3b0e 	vmul.f64	d3, d3, d14
10005188:	ee31 1b0f 	vadd.f64	d1, d1, d15
1000518c:	ed8d 8b00 	vstr	d8, [sp]
10005190:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10005194:	ee21 8b0e 	vmul.f64	d8, d1, d14
10005198:	ee37 7b0f 	vadd.f64	d7, d7, d15
1000519c:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100051a0:	eebc 8bc8 	vcvt.u32.f64	s16, d8
100051a4:	ee27 6b0e 	vmul.f64	d6, d7, d14
100051a8:	ee33 3b05 	vadd.f64	d3, d3, d5
100051ac:	eeb8 8b48 	vcvt.f64.u32	d8, s16
100051b0:	ee33 3b44 	vsub.f64	d3, d3, d4
100051b4:	ee32 2b0f 	vadd.f64	d2, d2, d15
100051b8:	ee08 1b4f 	vmls.f64	d1, d8, d15
100051bc:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100051c0:	ed8d ab02 	vstr	d10, [sp, #8]
100051c4:	ee33 1b01 	vadd.f64	d1, d3, d1
100051c8:	ed9d ab00 	vldr	d10, [sp]
100051cc:	ee22 3b0e 	vmul.f64	d3, d2, d14
100051d0:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100051d4:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100051d8:	ee06 7b4f 	vmls.f64	d7, d6, d15
100051dc:	ee3a 6b06 	vadd.f64	d6, d10, d6
100051e0:	ed9d ab0c 	vldr	d10, [sp, #48]	@ 0x30
100051e4:	ee2d 5b4f 	vnmul.f64	d5, d13, d15
100051e8:	eeac 5b09 	vfma.f64	d5, d12, d9
100051ec:	ee3a 7b07 	vadd.f64	d7, d10, d7
100051f0:	ee35 5b0f 	vadd.f64	d5, d5, d15
100051f4:	ed9d ab02 	vldr	d10, [sp, #8]
100051f8:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100051fc:	ee30 8b08 	vadd.f64	d8, d0, d8
10005200:	ee03 2b4f 	vmls.f64	d2, d3, d15
10005204:	ee25 0b0e 	vmul.f64	d0, d5, d14
10005208:	ee3a 3b03 	vadd.f64	d3, d10, d3
1000520c:	ee36 6b44 	vsub.f64	d6, d6, d4
10005210:	ee33 3b44 	vsub.f64	d3, d3, d4
10005214:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10005218:	ee36 6b03 	vadd.f64	d6, d6, d3
1000521c:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10005220:	ed9d 3b0e 	vldr	d3, [sp, #56]	@ 0x38
10005224:	ee3d db00 	vadd.f64	d13, d13, d0
10005228:	ee33 6b06 	vadd.f64	d6, d3, d6
1000522c:	ed9d 3b04 	vldr	d3, [sp, #16]
10005230:	ee38 8b44 	vsub.f64	d8, d8, d4
10005234:	ee37 2b02 	vadd.f64	d2, d7, d2
10005238:	ee3d db44 	vsub.f64	d13, d13, d4
1000523c:	ee23 4b0e 	vmul.f64	d4, d3, d14
10005240:	ee22 7b0e 	vmul.f64	d7, d2, d14
10005244:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10005248:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000524c:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10005250:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005254:	ee04 3b4f 	vmls.f64	d3, d4, d15
10005258:	ee00 5b4f 	vmls.f64	d5, d0, d15
1000525c:	ee38 db0d 	vadd.f64	d13, d8, d13
10005260:	ee31 5b05 	vadd.f64	d5, d1, d5
10005264:	ee33 ab0d 	vadd.f64	d10, d3, d13
10005268:	ee36 6b07 	vadd.f64	d6, d6, d7
1000526c:	ed9f 3b5e 	vldr	d3, [pc, #376]	@ 100053e8 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x408>
10005270:	ee07 2b4f 	vmls.f64	d2, d7, d15
10005274:	ee25 4b0e 	vmul.f64	d4, d5, d14
10005278:	ed9d 7b08 	vldr	d7, [sp, #32]
1000527c:	ee36 6b03 	vadd.f64	d6, d6, d3
10005280:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10005284:	ee36 6b47 	vsub.f64	d6, d6, d7
10005288:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000528c:	ee36 6b47 	vsub.f64	d6, d6, d7
10005290:	ed9d 0b0a 	vldr	d0, [sp, #40]	@ 0x28
10005294:	ee3a ab04 	vadd.f64	d10, d10, d4
10005298:	ee20 7b0e 	vmul.f64	d7, d0, d14
1000529c:	ee04 5b4f 	vmls.f64	d5, d4, d15
100052a0:	ee26 4b0e 	vmul.f64	d4, d6, d14
100052a4:	ee35 5b02 	vadd.f64	d5, d5, d2
100052a8:	ee3a ab03 	vadd.f64	d10, d10, d3
100052ac:	eebc 2bc7 	vcvt.u32.f64	s4, d7
100052b0:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100052b4:	ed9d 7b06 	vldr	d7, [sp, #24]
100052b8:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100052bc:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100052c0:	ee3a ab47 	vsub.f64	d10, d10, d7
100052c4:	ee04 6b4f 	vmls.f64	d6, d4, d15
100052c8:	ed95 8b00 	vldr	d8, [r5]
100052cc:	ee3a 7b47 	vsub.f64	d7, d10, d7
100052d0:	eeb0 4b42 	vmov.f64	d4, d2
100052d4:	ee27 1b0e 	vmul.f64	d1, d7, d14
100052d8:	ee08 4b0b 	vmla.f64	d4, d8, d11
100052dc:	ee02 0b4f 	vmls.f64	d0, d2, d15
100052e0:	eebc 1bc1 	vcvt.u32.f64	s2, d1
100052e4:	ee24 2b0e 	vmul.f64	d2, d4, d14
100052e8:	eefc 1bc0 	vcvt.u32.f64	s3, d0
100052ec:	ee25 3b0e 	vmul.f64	d3, d5, d14
100052f0:	ee11 0a90 	vmov	r0, s3
100052f4:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100052f8:	eeb8 1b41 	vcvt.f64.u32	d1, s2
100052fc:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10005300:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10005304:	ee01 7b4f 	vmls.f64	d7, d1, d15
10005308:	ee02 4b4f 	vmls.f64	d4, d2, d15
1000530c:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10005310:	ee37 7b06 	vadd.f64	d7, d7, d6
10005314:	eefc 6bc4 	vcvt.u32.f64	s13, d4
10005318:	ee37 7b03 	vadd.f64	d7, d7, d3
1000531c:	ee16 1a90 	vmov	r1, s13
10005320:	ee27 6b0e 	vmul.f64	d6, d7, d14
10005324:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10005328:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000532c:	ee03 5b4f 	vmls.f64	d5, d3, d15
10005330:	ee06 7b4f 	vmls.f64	d7, d6, d15
10005334:	eefc 5bc5 	vcvt.u32.f64	s11, d5
10005338:	eefc 7bc7 	vcvt.u32.f64	s15, d7
1000533c:	ee15 2a90 	vmov	r2, s11
10005340:	ee17 3a90 	vmov	r3, s15
10005344:	edcd 5a02 	vstr	s11, [sp, #8]
10005348:	edcd 7a00 	vstr	s15, [sp]
1000534c:	f7ff fc70 	bl	10004c30 <fxr_div_fp64_exact>
10005350:	ee29 5b0b 	vmul.f64	d5, d9, d11
10005354:	ee25 7b0e 	vmul.f64	d7, d5, d14
10005358:	ee06 1a10 	vmov	s12, r1
1000535c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005360:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005364:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005368:	ed85 6b00 	vstr	d6, [r5]
1000536c:	eeb0 6b47 	vmov.f64	d6, d7
10005370:	ee0c 6b0b 	vmla.f64	d6, d12, d11
10005374:	ee07 5b4f 	vmls.f64	d5, d7, d15
10005378:	ee26 7b0e 	vmul.f64	d7, d6, d14
1000537c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005380:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005384:	ee04 0a10 	vmov	s8, r0
10005388:	ee07 6b4f 	vmls.f64	d6, d7, d15
1000538c:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10005390:	eefc 7bc6 	vcvt.u32.f64	s15, d6
10005394:	eefc 5bc5 	vcvt.u32.f64	s11, d5
10005398:	ed85 4b02 	vstr	d4, [r5, #8]
1000539c:	ee17 1a90 	vmov	r1, s15
100053a0:	ee15 0a90 	vmov	r0, s11
100053a4:	9a02      	ldr	r2, [sp, #8]
100053a6:	9b00      	ldr	r3, [sp, #0]
100053a8:	f7ff fc42 	bl	10004c30 <fxr_div_fp64_exact>
100053ac:	ee06 0a10 	vmov	s12, r0
100053b0:	ee07 1a10 	vmov	s14, r1
100053b4:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100053b8:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100053bc:	3601      	adds	r6, #1
100053be:	42b7      	cmp	r7, r6
100053c0:	f104 0410 	add.w	r4, r4, #16
100053c4:	f105 0510 	add.w	r5, r5, #16
100053c8:	ed04 6b02 	vstr	d6, [r4, #-8]
100053cc:	ed04 7b04 	vstr	d7, [r4, #-16]
100053d0:	f47f ae1c 	bne.w	1000500c <fndsa_vect_inv_mul2e_fft_fp64_exact+0x2c>
100053d4:	e00c      	b.n	100053f0 <fndsa_vect_inv_mul2e_fft_fp64_exact+0x410>
100053d6:	bf00      	nop
100053d8:	00000000 	.word	0x00000000
100053dc:	41f00000 	.word	0x41f00000
100053e0:	00000000 	.word	0x00000000
100053e4:	3df00000 	.word	0x3df00000
100053e8:	00000000 	.word	0x00000000
100053ec:	42000000 	.word	0x42000000
100053f0:	b011      	add	sp, #68	@ 0x44
100053f2:	ecbd 8b10 	vpop	{d8-d15}
100053f6:	bdf0      	pop	{r4, r5, r6, r7, pc}

