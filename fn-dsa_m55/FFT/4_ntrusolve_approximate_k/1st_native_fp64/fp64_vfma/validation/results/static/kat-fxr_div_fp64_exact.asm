10005150 <fxr_div_fp64_exact>:
10005150:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10005154:	4607      	mov	r7, r0
10005156:	f04f 0c00 	mov.w	ip, #0
1000515a:	ea4f 79d1 	mov.w	r9, r1, lsr #31
1000515e:	ea4f 78d3 	mov.w	r8, r3, lsr #31
10005162:	ea82 74e3 	eor.w	r4, r2, r3, asr #31
10005166:	ea83 75e3 	eor.w	r5, r3, r3, asr #31
1000516a:	ea89 0308 	eor.w	r3, r9, r8
1000516e:	b0a7      	sub	sp, #156	@ 0x9c
10005170:	425a      	negs	r2, r3
10005172:	ea87 77e1 	eor.w	r7, r7, r1, asr #31
10005176:	ea81 76e1 	eor.w	r6, r1, r1, asr #31
1000517a:	9212      	str	r2, [sp, #72]	@ 0x48
1000517c:	9213      	str	r2, [sp, #76]	@ 0x4c
1000517e:	eb17 0209 	adds.w	r2, r7, r9
10005182:	930b      	str	r3, [sp, #44]	@ 0x2c
10005184:	f146 0300 	adc.w	r3, r6, #0
10005188:	eb14 0408 	adds.w	r4, r4, r8
1000518c:	f145 0500 	adc.w	r5, r5, #0
10005190:	ea45 0604 	orr.w	r6, r5, r4
10005194:	462f      	mov	r7, r5
10005196:	ee07 5a90 	vmov	s15, r5
1000519a:	4275      	negs	r5, r6
1000519c:	4335      	orrs	r5, r6
1000519e:	0fed      	lsrs	r5, r5, #31
100051a0:	9517      	str	r5, [sp, #92]	@ 0x5c
100051a2:	9d17      	ldr	r5, [sp, #92]	@ 0x5c
100051a4:	ed9f 6bce 	vldr	d6, [pc, #824]	@ 100054e0 <fxr_div_fp64_exact+0x390>
100051a8:	f085 0501 	eor.w	r5, r5, #1
100051ac:	f115 3aff 	adds.w	sl, r5, #4294967295	@ 0xffffffff
100051b0:	f14c 38ff 	adc.w	r8, ip, #4294967295	@ 0xffffffff
100051b4:	ea08 0803 	and.w	r8, r8, r3
100051b8:	ea0a 0602 	and.w	r6, sl, r2
100051bc:	ee02 6a90 	vmov	s5, r6
100051c0:	ee05 8a90 	vmov	s11, r8
100051c4:	eeb8 4b67 	vcvt.f64.u32	d4, s15
100051c8:	eeb8 5b65 	vcvt.f64.u32	d5, s11
100051cc:	eeb8 7b62 	vcvt.f64.u32	d7, s5
100051d0:	ea44 0a05 	orr.w	sl, r4, r5
100051d4:	ee05 7b06 	vmla.f64	d7, d5, d6
100051d8:	ee05 aa90 	vmov	s11, sl
100051dc:	eeb8 5b65 	vcvt.f64.u32	d5, s11
100051e0:	ee04 5b06 	vmla.f64	d5, d4, d6
100051e4:	950a      	str	r5, [sp, #40]	@ 0x28
100051e6:	2400      	movs	r4, #0
100051e8:	2500      	movs	r5, #0
100051ea:	ee86 4b05 	vdiv.f64	d4, d6, d5
100051ee:	17de      	asrs	r6, r3, #31
100051f0:	46bb      	mov	fp, r7
100051f2:	9611      	str	r6, [sp, #68]	@ 0x44
100051f4:	9709      	str	r7, [sp, #36]	@ 0x24
100051f6:	4626      	mov	r6, r4
100051f8:	462f      	mov	r7, r5
100051fa:	ed9f 3bbb 	vldr	d3, [pc, #748]	@ 100054e8 <fxr_div_fp64_exact+0x398>
100051fe:	ee27 7b04 	vmul.f64	d7, d7, d4
10005202:	e9cd 6700 	strd	r6, r7, [sp]
10005206:	e9cd 6704 	strd	r6, r7, [sp, #16]
1000520a:	e9cd 6706 	strd	r6, r7, [sp, #24]
1000520e:	4616      	mov	r6, r2
10005210:	461f      	mov	r7, r3
10005212:	ee27 7b03 	vmul.f64	d7, d7, d3
10005216:	ea52 73df 	lsrl	r2, r3, #31
1000521a:	ea56 779f 	lsrl	r6, r7, #30
1000521e:	ed8d 7b02 	vstr	d7, [sp, #8]
10005222:	43d7      	mvns	r7, r2
10005224:	43f6      	mvns	r6, r6
10005226:	f8df e2d0 	ldr.w	lr, [pc, #720]	@ 100054f8 <fxr_div_fp64_exact+0x3a8>
1000522a:	f00a 0101 	and.w	r1, sl, #1
1000522e:	48b0      	ldr	r0, [pc, #704]	@ (100054f0 <fxr_div_fp64_exact+0x3a0>)
10005230:	910f      	str	r1, [sp, #60]	@ 0x3c
10005232:	49b0      	ldr	r1, [pc, #704]	@ (100054f4 <fxr_div_fp64_exact+0x3a4>)
10005234:	970e      	str	r7, [sp, #56]	@ 0x38
10005236:	e9dd 9702 	ldrd	r9, r7, [sp, #8]
1000523a:	ebbe 0209 	subs.w	r2, lr, r9
1000523e:	eb61 0207 	sbc.w	r2, r1, r7
10005242:	f006 0301 	and.w	r3, r6, #1
10005246:	ea47 0600 	orr.w	r6, r7, r0
1000524a:	4032      	ands	r2, r6
1000524c:	ea07 0600 	and.w	r6, r7, r0
10005250:	4332      	orrs	r2, r6
10005252:	0fd2      	lsrs	r2, r2, #31
10005254:	9216      	str	r2, [sp, #88]	@ 0x58
10005256:	9a16      	ldr	r2, [sp, #88]	@ 0x58
10005258:	9310      	str	r3, [sp, #64]	@ 0x40
1000525a:	4254      	negs	r4, r2
1000525c:	eb6c 050c 	sbc.w	r5, ip, ip
10005260:	e9cd 4524 	strd	r4, r5, [sp, #144]	@ 0x90
10005264:	e9dd 2324 	ldrd	r2, r3, [sp, #144]	@ 0x90
10005268:	ea89 050e 	eor.w	r5, r9, lr
1000526c:	ea87 0401 	eor.w	r4, r7, r1
10005270:	4015      	ands	r5, r2
10005272:	401c      	ands	r4, r3
10005274:	ea85 0209 	eor.w	r2, r5, r9
10005278:	407c      	eors	r4, r7
1000527a:	9200      	str	r2, [sp, #0]
1000527c:	9401      	str	r4, [sp, #4]
1000527e:	ed9d 7b00 	vldr	d7, [sp]
10005282:	4654      	mov	r4, sl
10005284:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10005288:	465d      	mov	r5, fp
1000528a:	ee17 6a90 	vmov	r6, s15
1000528e:	ea54 055f 	lsrl	r4, r5, #1
10005292:	2200      	movs	r2, #0
10005294:	2300      	movs	r3, #0
10005296:	ee12 9a90 	vmov	r9, s5
1000529a:	e9cd 450c 	strd	r4, r5, [sp, #48]	@ 0x30
1000529e:	e9cd 2302 	strd	r2, r3, [sp, #8]
100052a2:	fba6 420a 	umull	r4, r2, r6, sl
100052a6:	ebb9 0304 	subs.w	r3, r9, r4
100052aa:	46e1      	mov	r9, ip
100052ac:	fbeb 2906 	umlal	r2, r9, fp, r6
100052b0:	eb68 0602 	sbc.w	r6, r8, r2
100052b4:	ea62 0408 	orn	r4, r2, r8
100052b8:	4034      	ands	r4, r6
100052ba:	ea22 0208 	bic.w	r2, r2, r8
100052be:	4314      	orrs	r4, r2
100052c0:	0fe4      	lsrs	r4, r4, #31
100052c2:	941c      	str	r4, [sp, #112]	@ 0x70
100052c4:	9a1c      	ldr	r2, [sp, #112]	@ 0x70
100052c6:	edcd 7a00 	vstr	s15, [sp]
100052ca:	eb09 0802 	add.w	r8, r9, r2
100052ce:	f1c8 0700 	rsb	r7, r8, #0
100052d2:	ea0a 74e7 	and.w	r4, sl, r7, asr #31
100052d6:	191b      	adds	r3, r3, r4
100052d8:	ea0b 74e7 	and.w	r4, fp, r7, asr #31
100052dc:	4621      	mov	r1, r4
100052de:	eb46 0504 	adc.w	r5, r6, r4
100052e2:	ebb3 040a 	subs.w	r4, r3, sl
100052e6:	ea66 0405 	orn	r4, r6, r5
100052ea:	ea04 0401 	and.w	r4, r4, r1
100052ee:	ea26 0605 	bic.w	r6, r6, r5
100052f2:	ea44 0406 	orr.w	r4, r4, r6
100052f6:	ee17 6a90 	vmov	r6, s15
100052fa:	ea4f 74d4 	mov.w	r4, r4, lsr #31
100052fe:	941d      	str	r4, [sp, #116]	@ 0x74
10005300:	9c1d      	ldr	r4, [sp, #116]	@ 0x74
10005302:	497c      	ldr	r1, [pc, #496]	@ (100054f4 <fxr_div_fp64_exact+0x3a4>)
10005304:	eba2 0204 	sub.w	r2, r2, r4
10005308:	444a      	add	r2, r9
1000530a:	eba4 0408 	sub.w	r4, r4, r8
1000530e:	ea42 0204 	orr.w	r2, r2, r4
10005312:	ea4f 72d2 	mov.w	r2, r2, lsr #31
10005316:	921e      	str	r2, [sp, #120]	@ 0x78
10005318:	ea6b 0405 	orn	r4, fp, r5
1000531c:	eb65 020b 	sbc.w	r2, r5, fp
10005320:	4022      	ands	r2, r4
10005322:	ea2b 0405 	bic.w	r4, fp, r5
10005326:	4322      	orrs	r2, r4
10005328:	0fd2      	lsrs	r2, r2, #31
1000532a:	9c1e      	ldr	r4, [sp, #120]	@ 0x78
1000532c:	921f      	str	r2, [sp, #124]	@ 0x7c
1000532e:	9a1f      	ldr	r2, [sp, #124]	@ 0x7c
10005330:	f082 0201 	eor.w	r2, r2, #1
10005334:	4322      	orrs	r2, r4
10005336:	18b4      	adds	r4, r6, r2
10005338:	4252      	negs	r2, r2
1000533a:	eba4 78d7 	sub.w	r8, r4, r7, lsr #31
1000533e:	ea02 020a 	and.w	r2, r2, sl
10005342:	eb6c 040c 	sbc.w	r4, ip, ip
10005346:	ea04 040b 	and.w	r4, r4, fp
1000534a:	1a9b      	subs	r3, r3, r2
1000534c:	eb65 0404 	sbc.w	r4, r5, r4
10005350:	ee07 4a90 	vmov	s15, r4
10005354:	eeb8 5b67 	vcvt.f64.u32	d5, s15
10005358:	ee07 3a90 	vmov	s15, r3
1000535c:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10005360:	ee05 7b06 	vmla.f64	d7, d5, d6
10005364:	ee27 7b04 	vmul.f64	d7, d7, d4
10005368:	ed8d 7b00 	vstr	d7, [sp]
1000536c:	e9dd 5200 	ldrd	r5, r2, [sp]
10005370:	ebbe 0605 	subs.w	r6, lr, r5
10005374:	eb61 0702 	sbc.w	r7, r1, r2
10005378:	ea82 0601 	eor.w	r6, r2, r1
1000537c:	ea42 0100 	orr.w	r1, r2, r0
10005380:	4039      	ands	r1, r7
10005382:	4010      	ands	r0, r2
10005384:	4301      	orrs	r1, r0
10005386:	0fc9      	lsrs	r1, r1, #31
10005388:	9115      	str	r1, [sp, #84]	@ 0x54
1000538a:	9915      	ldr	r1, [sp, #84]	@ 0x54
1000538c:	ea85 0e0e 	eor.w	lr, r5, lr
10005390:	4249      	negs	r1, r1
10005392:	9104      	str	r1, [sp, #16]
10005394:	eb6c 010c 	sbc.w	r1, ip, ip
10005398:	9105      	str	r1, [sp, #20]
1000539a:	e9dd 0104 	ldrd	r0, r1, [sp, #16]
1000539e:	e9cd 0122 	strd	r0, r1, [sp, #136]	@ 0x88
100053a2:	e9dd 0122 	ldrd	r0, r1, [sp, #136]	@ 0x88
100053a6:	ea0e 0e00 	and.w	lr, lr, r0
100053aa:	4031      	ands	r1, r6
100053ac:	404a      	eors	r2, r1
100053ae:	ea8e 0605 	eor.w	r6, lr, r5
100053b2:	9606      	str	r6, [sp, #24]
100053b4:	9207      	str	r2, [sp, #28]
100053b6:	ed9d 7b06 	vldr	d7, [sp, #24]
100053ba:	eefc 7bc7 	vcvt.u32.f64	s15, d7
100053be:	ee17 9a90 	vmov	r9, s15
100053c2:	46e6      	mov	lr, ip
100053c4:	fba9 210a 	umull	r2, r1, r9, sl
100053c8:	fbeb 1e09 	umlal	r1, lr, fp, r9
100053cc:	4677      	mov	r7, lr
100053ce:	ebbc 0202 	subs.w	r2, ip, r2
100053d2:	eb63 0601 	sbc.w	r6, r3, r1
100053d6:	ea61 0003 	orn	r0, r1, r3
100053da:	4030      	ands	r0, r6
100053dc:	ea21 0103 	bic.w	r1, r1, r3
100053e0:	4308      	orrs	r0, r1
100053e2:	0fc0      	lsrs	r0, r0, #31
100053e4:	9018      	str	r0, [sp, #96]	@ 0x60
100053e6:	9b18      	ldr	r3, [sp, #96]	@ 0x60
100053e8:	1ae5      	subs	r5, r4, r3
100053ea:	1bed      	subs	r5, r5, r7
100053ec:	ea0a 71e5 	and.w	r1, sl, r5, asr #31
100053f0:	ea0b 7ee5 	and.w	lr, fp, r5, asr #31
100053f4:	1852      	adds	r2, r2, r1
100053f6:	eb46 000e 	adc.w	r0, r6, lr
100053fa:	ebb2 010a 	subs.w	r1, r2, sl
100053fe:	ea66 0100 	orn	r1, r6, r0
10005402:	ea01 010e 	and.w	r1, r1, lr
10005406:	ea26 0600 	bic.w	r6, r6, r0
1000540a:	ea41 0106 	orr.w	r1, r1, r6
1000540e:	ea4f 71d1 	mov.w	r1, r1, lsr #31
10005412:	9119      	str	r1, [sp, #100]	@ 0x64
10005414:	9919      	ldr	r1, [sp, #100]	@ 0x64
10005416:	eba3 0301 	sub.w	r3, r3, r1
1000541a:	eba3 0304 	sub.w	r3, r3, r4
1000541e:	4429      	add	r1, r5
10005420:	443b      	add	r3, r7
10005422:	ea43 0301 	orr.w	r3, r3, r1
10005426:	ea4f 73d3 	mov.w	r3, r3, lsr #31
1000542a:	931a      	str	r3, [sp, #104]	@ 0x68
1000542c:	ea6b 0100 	orn	r1, fp, r0
10005430:	eb60 030b 	sbc.w	r3, r0, fp
10005434:	400b      	ands	r3, r1
10005436:	ea2b 0100 	bic.w	r1, fp, r0
1000543a:	430b      	orrs	r3, r1
1000543c:	0fdb      	lsrs	r3, r3, #31
1000543e:	991a      	ldr	r1, [sp, #104]	@ 0x68
10005440:	931b      	str	r3, [sp, #108]	@ 0x6c
10005442:	9b1b      	ldr	r3, [sp, #108]	@ 0x6c
10005444:	f083 0301 	eor.w	r3, r3, #1
10005448:	430b      	orrs	r3, r1
1000544a:	4499      	add	r9, r3
1000544c:	425b      	negs	r3, r3
1000544e:	eb6c 010c 	sbc.w	r1, ip, ip
10005452:	ea03 030a 	and.w	r3, r3, sl
10005456:	1ad3      	subs	r3, r2, r3
10005458:	ea01 010b 	and.w	r1, r1, fp
1000545c:	eb60 0101 	sbc.w	r1, r0, r1
10005460:	980f      	ldr	r0, [sp, #60]	@ 0x3c
10005462:	e9dd ab0c 	ldrd	sl, fp, [sp, #48]	@ 0x30
10005466:	eb1a 0000 	adds.w	r0, sl, r0
1000546a:	f14b 0200 	adc.w	r2, fp, #0
1000546e:	1a18      	subs	r0, r3, r0
10005470:	eb61 0302 	sbc.w	r3, r1, r2
10005474:	ea62 0001 	orn	r0, r2, r1
10005478:	4003      	ands	r3, r0
1000547a:	ea22 0201 	bic.w	r2, r2, r1
1000547e:	4313      	orrs	r3, r2
10005480:	0fdb      	lsrs	r3, r3, #31
10005482:	9314      	str	r3, [sp, #80]	@ 0x50
10005484:	9b14      	ldr	r3, [sp, #80]	@ 0x50
10005486:	eba9 79d5 	sub.w	r9, r9, r5, lsr #31
1000548a:	f083 0301 	eor.w	r3, r3, #1
1000548e:	9d0a      	ldr	r5, [sp, #40]	@ 0x28
10005490:	eb13 0309 	adds.w	r3, r3, r9
10005494:	f148 0200 	adc.w	r2, r8, #0
10005498:	4269      	negs	r1, r5
1000549a:	9102      	str	r1, [sp, #8]
1000549c:	eb6c 010c 	sbc.w	r1, ip, ip
100054a0:	9103      	str	r1, [sp, #12]
100054a2:	9f0e      	ldr	r7, [sp, #56]	@ 0x38
100054a4:	9810      	ldr	r0, [sp, #64]	@ 0x40
100054a6:	9e11      	ldr	r6, [sp, #68]	@ 0x44
100054a8:	19c0      	adds	r0, r0, r7
100054aa:	9c12      	ldr	r4, [sp, #72]	@ 0x48
100054ac:	9d13      	ldr	r5, [sp, #76]	@ 0x4c
100054ae:	f166 0100 	sbc.w	r1, r6, #0
100054b2:	4058      	eors	r0, r3
100054b4:	e9dd 8902 	ldrd	r8, r9, [sp, #8]
100054b8:	e9cd 8920 	strd	r8, r9, [sp, #128]	@ 0x80
100054bc:	e9dd 6720 	ldrd	r6, r7, [sp, #128]	@ 0x80
100054c0:	405c      	eors	r4, r3
100054c2:	4051      	eors	r1, r2
100054c4:	ea85 0302 	eor.w	r3, r5, r2
100054c8:	4030      	ands	r0, r6
100054ca:	9a0b      	ldr	r2, [sp, #44]	@ 0x2c
100054cc:	4039      	ands	r1, r7
100054ce:	4060      	eors	r0, r4
100054d0:	1880      	adds	r0, r0, r2
100054d2:	ea81 0103 	eor.w	r1, r1, r3
100054d6:	f141 0100 	adc.w	r1, r1, #0
100054da:	b027      	add	sp, #156	@ 0x9c
100054dc:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
100054e0:	00000000 	.word	0x00000000
100054e4:	41f00000 	.word	0x41f00000
100054e8:	00000000 	.word	0x00000000
100054ec:	3df00000 	.word	0x3df00000
100054f0:	be100000 	.word	0xbe100000
100054f4:	41efffff 	.word	0x41efffff
100054f8:	ffe00000 	.word	0xffe00000
100054fc:	00000000 	.word	0x00000000

