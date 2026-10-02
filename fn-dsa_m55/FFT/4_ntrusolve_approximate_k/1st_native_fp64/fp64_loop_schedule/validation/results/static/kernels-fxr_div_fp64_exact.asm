10002fc8 <fxr_div_fp64_exact>:
10002fc8:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10002fcc:	4607      	mov	r7, r0
10002fce:	f04f 0c00 	mov.w	ip, #0
10002fd2:	ea4f 79d1 	mov.w	r9, r1, lsr #31
10002fd6:	ea4f 78d3 	mov.w	r8, r3, lsr #31
10002fda:	ea82 74e3 	eor.w	r4, r2, r3, asr #31
10002fde:	ea83 75e3 	eor.w	r5, r3, r3, asr #31
10002fe2:	ea89 0308 	eor.w	r3, r9, r8
10002fe6:	b0a7      	sub	sp, #156	@ 0x9c
10002fe8:	425a      	negs	r2, r3
10002fea:	ea87 77e1 	eor.w	r7, r7, r1, asr #31
10002fee:	ea81 76e1 	eor.w	r6, r1, r1, asr #31
10002ff2:	9212      	str	r2, [sp, #72]	@ 0x48
10002ff4:	9213      	str	r2, [sp, #76]	@ 0x4c
10002ff6:	eb17 0209 	adds.w	r2, r7, r9
10002ffa:	930b      	str	r3, [sp, #44]	@ 0x2c
10002ffc:	f146 0300 	adc.w	r3, r6, #0
10003000:	eb14 0408 	adds.w	r4, r4, r8
10003004:	f145 0500 	adc.w	r5, r5, #0
10003008:	ea45 0604 	orr.w	r6, r5, r4
1000300c:	462f      	mov	r7, r5
1000300e:	ee07 5a90 	vmov	s15, r5
10003012:	4275      	negs	r5, r6
10003014:	4335      	orrs	r5, r6
10003016:	0fed      	lsrs	r5, r5, #31
10003018:	9517      	str	r5, [sp, #92]	@ 0x5c
1000301a:	9d17      	ldr	r5, [sp, #92]	@ 0x5c
1000301c:	ed9f 6bce 	vldr	d6, [pc, #824]	@ 10003358 <fxr_div_fp64_exact+0x390>
10003020:	f085 0501 	eor.w	r5, r5, #1
10003024:	f115 3aff 	adds.w	sl, r5, #4294967295	@ 0xffffffff
10003028:	f14c 38ff 	adc.w	r8, ip, #4294967295	@ 0xffffffff
1000302c:	ea08 0803 	and.w	r8, r8, r3
10003030:	ea0a 0602 	and.w	r6, sl, r2
10003034:	ee02 6a90 	vmov	s5, r6
10003038:	ee05 8a90 	vmov	s11, r8
1000303c:	eeb8 4b67 	vcvt.f64.u32	d4, s15
10003040:	eeb8 5b65 	vcvt.f64.u32	d5, s11
10003044:	eeb8 7b62 	vcvt.f64.u32	d7, s5
10003048:	ea44 0a05 	orr.w	sl, r4, r5
1000304c:	ee05 7b06 	vmla.f64	d7, d5, d6
10003050:	ee05 aa90 	vmov	s11, sl
10003054:	eeb8 5b65 	vcvt.f64.u32	d5, s11
10003058:	ee04 5b06 	vmla.f64	d5, d4, d6
1000305c:	950a      	str	r5, [sp, #40]	@ 0x28
1000305e:	2400      	movs	r4, #0
10003060:	2500      	movs	r5, #0
10003062:	ee86 4b05 	vdiv.f64	d4, d6, d5
10003066:	17de      	asrs	r6, r3, #31
10003068:	46bb      	mov	fp, r7
1000306a:	9611      	str	r6, [sp, #68]	@ 0x44
1000306c:	9709      	str	r7, [sp, #36]	@ 0x24
1000306e:	4626      	mov	r6, r4
10003070:	462f      	mov	r7, r5
10003072:	ed9f 3bbb 	vldr	d3, [pc, #748]	@ 10003360 <fxr_div_fp64_exact+0x398>
10003076:	ee27 7b04 	vmul.f64	d7, d7, d4
1000307a:	e9cd 6700 	strd	r6, r7, [sp]
1000307e:	e9cd 6704 	strd	r6, r7, [sp, #16]
10003082:	e9cd 6706 	strd	r6, r7, [sp, #24]
10003086:	4616      	mov	r6, r2
10003088:	461f      	mov	r7, r3
1000308a:	ee27 7b03 	vmul.f64	d7, d7, d3
1000308e:	ea52 73df 	lsrl	r2, r3, #31
10003092:	ea56 779f 	lsrl	r6, r7, #30
10003096:	ed8d 7b02 	vstr	d7, [sp, #8]
1000309a:	43d7      	mvns	r7, r2
1000309c:	43f6      	mvns	r6, r6
1000309e:	f8df e2d0 	ldr.w	lr, [pc, #720]	@ 10003370 <fxr_div_fp64_exact+0x3a8>
100030a2:	f00a 0101 	and.w	r1, sl, #1
100030a6:	48b0      	ldr	r0, [pc, #704]	@ (10003368 <fxr_div_fp64_exact+0x3a0>)
100030a8:	910f      	str	r1, [sp, #60]	@ 0x3c
100030aa:	49b0      	ldr	r1, [pc, #704]	@ (1000336c <fxr_div_fp64_exact+0x3a4>)
100030ac:	970e      	str	r7, [sp, #56]	@ 0x38
100030ae:	e9dd 9702 	ldrd	r9, r7, [sp, #8]
100030b2:	ebbe 0209 	subs.w	r2, lr, r9
100030b6:	eb61 0207 	sbc.w	r2, r1, r7
100030ba:	f006 0301 	and.w	r3, r6, #1
100030be:	ea47 0600 	orr.w	r6, r7, r0
100030c2:	4032      	ands	r2, r6
100030c4:	ea07 0600 	and.w	r6, r7, r0
100030c8:	4332      	orrs	r2, r6
100030ca:	0fd2      	lsrs	r2, r2, #31
100030cc:	9216      	str	r2, [sp, #88]	@ 0x58
100030ce:	9a16      	ldr	r2, [sp, #88]	@ 0x58
100030d0:	9310      	str	r3, [sp, #64]	@ 0x40
100030d2:	4254      	negs	r4, r2
100030d4:	eb6c 050c 	sbc.w	r5, ip, ip
100030d8:	e9cd 4524 	strd	r4, r5, [sp, #144]	@ 0x90
100030dc:	e9dd 2324 	ldrd	r2, r3, [sp, #144]	@ 0x90
100030e0:	ea89 050e 	eor.w	r5, r9, lr
100030e4:	ea87 0401 	eor.w	r4, r7, r1
100030e8:	4015      	ands	r5, r2
100030ea:	401c      	ands	r4, r3
100030ec:	ea85 0209 	eor.w	r2, r5, r9
100030f0:	407c      	eors	r4, r7
100030f2:	9200      	str	r2, [sp, #0]
100030f4:	9401      	str	r4, [sp, #4]
100030f6:	ed9d 7b00 	vldr	d7, [sp]
100030fa:	4654      	mov	r4, sl
100030fc:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10003100:	465d      	mov	r5, fp
10003102:	ee17 6a90 	vmov	r6, s15
10003106:	ea54 055f 	lsrl	r4, r5, #1
1000310a:	2200      	movs	r2, #0
1000310c:	2300      	movs	r3, #0
1000310e:	ee12 9a90 	vmov	r9, s5
10003112:	e9cd 450c 	strd	r4, r5, [sp, #48]	@ 0x30
10003116:	e9cd 2302 	strd	r2, r3, [sp, #8]
1000311a:	fba6 420a 	umull	r4, r2, r6, sl
1000311e:	ebb9 0304 	subs.w	r3, r9, r4
10003122:	46e1      	mov	r9, ip
10003124:	fbeb 2906 	umlal	r2, r9, fp, r6
10003128:	eb68 0602 	sbc.w	r6, r8, r2
1000312c:	ea62 0408 	orn	r4, r2, r8
10003130:	4034      	ands	r4, r6
10003132:	ea22 0208 	bic.w	r2, r2, r8
10003136:	4314      	orrs	r4, r2
10003138:	0fe4      	lsrs	r4, r4, #31
1000313a:	941c      	str	r4, [sp, #112]	@ 0x70
1000313c:	9a1c      	ldr	r2, [sp, #112]	@ 0x70
1000313e:	edcd 7a00 	vstr	s15, [sp]
10003142:	eb09 0802 	add.w	r8, r9, r2
10003146:	f1c8 0700 	rsb	r7, r8, #0
1000314a:	ea0a 74e7 	and.w	r4, sl, r7, asr #31
1000314e:	191b      	adds	r3, r3, r4
10003150:	ea0b 74e7 	and.w	r4, fp, r7, asr #31
10003154:	4621      	mov	r1, r4
10003156:	eb46 0504 	adc.w	r5, r6, r4
1000315a:	ebb3 040a 	subs.w	r4, r3, sl
1000315e:	ea66 0405 	orn	r4, r6, r5
10003162:	ea04 0401 	and.w	r4, r4, r1
10003166:	ea26 0605 	bic.w	r6, r6, r5
1000316a:	ea44 0406 	orr.w	r4, r4, r6
1000316e:	ee17 6a90 	vmov	r6, s15
10003172:	ea4f 74d4 	mov.w	r4, r4, lsr #31
10003176:	941d      	str	r4, [sp, #116]	@ 0x74
10003178:	9c1d      	ldr	r4, [sp, #116]	@ 0x74
1000317a:	497c      	ldr	r1, [pc, #496]	@ (1000336c <fxr_div_fp64_exact+0x3a4>)
1000317c:	eba2 0204 	sub.w	r2, r2, r4
10003180:	444a      	add	r2, r9
10003182:	eba4 0408 	sub.w	r4, r4, r8
10003186:	ea42 0204 	orr.w	r2, r2, r4
1000318a:	ea4f 72d2 	mov.w	r2, r2, lsr #31
1000318e:	921e      	str	r2, [sp, #120]	@ 0x78
10003190:	ea6b 0405 	orn	r4, fp, r5
10003194:	eb65 020b 	sbc.w	r2, r5, fp
10003198:	4022      	ands	r2, r4
1000319a:	ea2b 0405 	bic.w	r4, fp, r5
1000319e:	4322      	orrs	r2, r4
100031a0:	0fd2      	lsrs	r2, r2, #31
100031a2:	9c1e      	ldr	r4, [sp, #120]	@ 0x78
100031a4:	921f      	str	r2, [sp, #124]	@ 0x7c
100031a6:	9a1f      	ldr	r2, [sp, #124]	@ 0x7c
100031a8:	f082 0201 	eor.w	r2, r2, #1
100031ac:	4322      	orrs	r2, r4
100031ae:	18b4      	adds	r4, r6, r2
100031b0:	4252      	negs	r2, r2
100031b2:	eba4 78d7 	sub.w	r8, r4, r7, lsr #31
100031b6:	ea02 020a 	and.w	r2, r2, sl
100031ba:	eb6c 040c 	sbc.w	r4, ip, ip
100031be:	ea04 040b 	and.w	r4, r4, fp
100031c2:	1a9b      	subs	r3, r3, r2
100031c4:	eb65 0404 	sbc.w	r4, r5, r4
100031c8:	ee07 4a90 	vmov	s15, r4
100031cc:	eeb8 5b67 	vcvt.f64.u32	d5, s15
100031d0:	ee07 3a90 	vmov	s15, r3
100031d4:	eeb8 7b67 	vcvt.f64.u32	d7, s15
100031d8:	ee05 7b06 	vmla.f64	d7, d5, d6
100031dc:	ee27 7b04 	vmul.f64	d7, d7, d4
100031e0:	ed8d 7b00 	vstr	d7, [sp]
100031e4:	e9dd 5200 	ldrd	r5, r2, [sp]
100031e8:	ebbe 0605 	subs.w	r6, lr, r5
100031ec:	eb61 0702 	sbc.w	r7, r1, r2
100031f0:	ea82 0601 	eor.w	r6, r2, r1
100031f4:	ea42 0100 	orr.w	r1, r2, r0
100031f8:	4039      	ands	r1, r7
100031fa:	4010      	ands	r0, r2
100031fc:	4301      	orrs	r1, r0
100031fe:	0fc9      	lsrs	r1, r1, #31
10003200:	9115      	str	r1, [sp, #84]	@ 0x54
10003202:	9915      	ldr	r1, [sp, #84]	@ 0x54
10003204:	ea85 0e0e 	eor.w	lr, r5, lr
10003208:	4249      	negs	r1, r1
1000320a:	9104      	str	r1, [sp, #16]
1000320c:	eb6c 010c 	sbc.w	r1, ip, ip
10003210:	9105      	str	r1, [sp, #20]
10003212:	e9dd 0104 	ldrd	r0, r1, [sp, #16]
10003216:	e9cd 0122 	strd	r0, r1, [sp, #136]	@ 0x88
1000321a:	e9dd 0122 	ldrd	r0, r1, [sp, #136]	@ 0x88
1000321e:	ea0e 0e00 	and.w	lr, lr, r0
10003222:	4031      	ands	r1, r6
10003224:	404a      	eors	r2, r1
10003226:	ea8e 0605 	eor.w	r6, lr, r5
1000322a:	9606      	str	r6, [sp, #24]
1000322c:	9207      	str	r2, [sp, #28]
1000322e:	ed9d 7b06 	vldr	d7, [sp, #24]
10003232:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10003236:	ee17 9a90 	vmov	r9, s15
1000323a:	46e6      	mov	lr, ip
1000323c:	fba9 210a 	umull	r2, r1, r9, sl
10003240:	fbeb 1e09 	umlal	r1, lr, fp, r9
10003244:	4677      	mov	r7, lr
10003246:	ebbc 0202 	subs.w	r2, ip, r2
1000324a:	eb63 0601 	sbc.w	r6, r3, r1
1000324e:	ea61 0003 	orn	r0, r1, r3
10003252:	4030      	ands	r0, r6
10003254:	ea21 0103 	bic.w	r1, r1, r3
10003258:	4308      	orrs	r0, r1
1000325a:	0fc0      	lsrs	r0, r0, #31
1000325c:	9018      	str	r0, [sp, #96]	@ 0x60
1000325e:	9b18      	ldr	r3, [sp, #96]	@ 0x60
10003260:	1ae5      	subs	r5, r4, r3
10003262:	1bed      	subs	r5, r5, r7
10003264:	ea0a 71e5 	and.w	r1, sl, r5, asr #31
10003268:	ea0b 7ee5 	and.w	lr, fp, r5, asr #31
1000326c:	1852      	adds	r2, r2, r1
1000326e:	eb46 000e 	adc.w	r0, r6, lr
10003272:	ebb2 010a 	subs.w	r1, r2, sl
10003276:	ea66 0100 	orn	r1, r6, r0
1000327a:	ea01 010e 	and.w	r1, r1, lr
1000327e:	ea26 0600 	bic.w	r6, r6, r0
10003282:	ea41 0106 	orr.w	r1, r1, r6
10003286:	ea4f 71d1 	mov.w	r1, r1, lsr #31
1000328a:	9119      	str	r1, [sp, #100]	@ 0x64
1000328c:	9919      	ldr	r1, [sp, #100]	@ 0x64
1000328e:	eba3 0301 	sub.w	r3, r3, r1
10003292:	eba3 0304 	sub.w	r3, r3, r4
10003296:	4429      	add	r1, r5
10003298:	443b      	add	r3, r7
1000329a:	ea43 0301 	orr.w	r3, r3, r1
1000329e:	ea4f 73d3 	mov.w	r3, r3, lsr #31
100032a2:	931a      	str	r3, [sp, #104]	@ 0x68
100032a4:	ea6b 0100 	orn	r1, fp, r0
100032a8:	eb60 030b 	sbc.w	r3, r0, fp
100032ac:	400b      	ands	r3, r1
100032ae:	ea2b 0100 	bic.w	r1, fp, r0
100032b2:	430b      	orrs	r3, r1
100032b4:	0fdb      	lsrs	r3, r3, #31
100032b6:	991a      	ldr	r1, [sp, #104]	@ 0x68
100032b8:	931b      	str	r3, [sp, #108]	@ 0x6c
100032ba:	9b1b      	ldr	r3, [sp, #108]	@ 0x6c
100032bc:	f083 0301 	eor.w	r3, r3, #1
100032c0:	430b      	orrs	r3, r1
100032c2:	4499      	add	r9, r3
100032c4:	425b      	negs	r3, r3
100032c6:	eb6c 010c 	sbc.w	r1, ip, ip
100032ca:	ea03 030a 	and.w	r3, r3, sl
100032ce:	1ad3      	subs	r3, r2, r3
100032d0:	ea01 010b 	and.w	r1, r1, fp
100032d4:	eb60 0101 	sbc.w	r1, r0, r1
100032d8:	980f      	ldr	r0, [sp, #60]	@ 0x3c
100032da:	e9dd ab0c 	ldrd	sl, fp, [sp, #48]	@ 0x30
100032de:	eb1a 0000 	adds.w	r0, sl, r0
100032e2:	f14b 0200 	adc.w	r2, fp, #0
100032e6:	1a18      	subs	r0, r3, r0
100032e8:	eb61 0302 	sbc.w	r3, r1, r2
100032ec:	ea62 0001 	orn	r0, r2, r1
100032f0:	4003      	ands	r3, r0
100032f2:	ea22 0201 	bic.w	r2, r2, r1
100032f6:	4313      	orrs	r3, r2
100032f8:	0fdb      	lsrs	r3, r3, #31
100032fa:	9314      	str	r3, [sp, #80]	@ 0x50
100032fc:	9b14      	ldr	r3, [sp, #80]	@ 0x50
100032fe:	eba9 79d5 	sub.w	r9, r9, r5, lsr #31
10003302:	f083 0301 	eor.w	r3, r3, #1
10003306:	9d0a      	ldr	r5, [sp, #40]	@ 0x28
10003308:	eb13 0309 	adds.w	r3, r3, r9
1000330c:	f148 0200 	adc.w	r2, r8, #0
10003310:	4269      	negs	r1, r5
10003312:	9102      	str	r1, [sp, #8]
10003314:	eb6c 010c 	sbc.w	r1, ip, ip
10003318:	9103      	str	r1, [sp, #12]
1000331a:	9f0e      	ldr	r7, [sp, #56]	@ 0x38
1000331c:	9810      	ldr	r0, [sp, #64]	@ 0x40
1000331e:	9e11      	ldr	r6, [sp, #68]	@ 0x44
10003320:	19c0      	adds	r0, r0, r7
10003322:	9c12      	ldr	r4, [sp, #72]	@ 0x48
10003324:	9d13      	ldr	r5, [sp, #76]	@ 0x4c
10003326:	f166 0100 	sbc.w	r1, r6, #0
1000332a:	4058      	eors	r0, r3
1000332c:	e9dd 8902 	ldrd	r8, r9, [sp, #8]
10003330:	e9cd 8920 	strd	r8, r9, [sp, #128]	@ 0x80
10003334:	e9dd 6720 	ldrd	r6, r7, [sp, #128]	@ 0x80
10003338:	405c      	eors	r4, r3
1000333a:	4051      	eors	r1, r2
1000333c:	ea85 0302 	eor.w	r3, r5, r2
10003340:	4030      	ands	r0, r6
10003342:	9a0b      	ldr	r2, [sp, #44]	@ 0x2c
10003344:	4039      	ands	r1, r7
10003346:	4060      	eors	r0, r4
10003348:	1880      	adds	r0, r0, r2
1000334a:	ea81 0103 	eor.w	r1, r1, r3
1000334e:	f141 0100 	adc.w	r1, r1, #0
10003352:	b027      	add	sp, #156	@ 0x9c
10003354:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10003358:	00000000 	.word	0x00000000
1000335c:	41f00000 	.word	0x41f00000
10003360:	00000000 	.word	0x00000000
10003364:	3df00000 	.word	0x3df00000
10003368:	be100000 	.word	0xbe100000
1000336c:	41efffff 	.word	0x41efffff
10003370:	ffe00000 	.word	0xffe00000
10003374:	00000000 	.word	0x00000000

