
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_kat_exact/validation/build/compat-profile/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10006120 <fxr_div_fp64_exact>:
10006120:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10006124:	4607      	mov	r7, r0
10006126:	f04f 0c00 	mov.w	ip, #0
1000612a:	ea4f 79d1 	mov.w	r9, r1, lsr #31
1000612e:	ea4f 78d3 	mov.w	r8, r3, lsr #31
10006132:	ea82 74e3 	eor.w	r4, r2, r3, asr #31
10006136:	ea83 75e3 	eor.w	r5, r3, r3, asr #31
1000613a:	ea89 0308 	eor.w	r3, r9, r8
1000613e:	b0a7      	sub	sp, #156	@ 0x9c
10006140:	425a      	negs	r2, r3
10006142:	ea87 77e1 	eor.w	r7, r7, r1, asr #31
10006146:	ea81 76e1 	eor.w	r6, r1, r1, asr #31
1000614a:	9212      	str	r2, [sp, #72]	@ 0x48
1000614c:	9213      	str	r2, [sp, #76]	@ 0x4c
1000614e:	eb17 0209 	adds.w	r2, r7, r9
10006152:	930b      	str	r3, [sp, #44]	@ 0x2c
10006154:	f146 0300 	adc.w	r3, r6, #0
10006158:	eb14 0408 	adds.w	r4, r4, r8
1000615c:	f145 0500 	adc.w	r5, r5, #0
10006160:	ea45 0604 	orr.w	r6, r5, r4
10006164:	462f      	mov	r7, r5
10006166:	ee07 5a90 	vmov	s15, r5
1000616a:	4275      	negs	r5, r6
1000616c:	4335      	orrs	r5, r6
1000616e:	0fed      	lsrs	r5, r5, #31
10006170:	9517      	str	r5, [sp, #92]	@ 0x5c
10006172:	9d17      	ldr	r5, [sp, #92]	@ 0x5c
10006174:	ed9f 6bce 	vldr	d6, [pc, #824]	@ 100064b0 <fxr_div_fp64_exact+0x390>
10006178:	f085 0501 	eor.w	r5, r5, #1
1000617c:	f115 3aff 	adds.w	sl, r5, #4294967295	@ 0xffffffff
10006180:	f14c 38ff 	adc.w	r8, ip, #4294967295	@ 0xffffffff
10006184:	ea08 0803 	and.w	r8, r8, r3
10006188:	ea0a 0602 	and.w	r6, sl, r2
1000618c:	ee02 6a90 	vmov	s5, r6
10006190:	ee05 8a90 	vmov	s11, r8
10006194:	eeb8 4b67 	vcvt.f64.u32	d4, s15
10006198:	eeb8 5b65 	vcvt.f64.u32	d5, s11
1000619c:	eeb8 7b62 	vcvt.f64.u32	d7, s5
100061a0:	ea44 0a05 	orr.w	sl, r4, r5
100061a4:	ee05 7b06 	vmla.f64	d7, d5, d6
100061a8:	ee05 aa90 	vmov	s11, sl
100061ac:	eeb8 5b65 	vcvt.f64.u32	d5, s11
100061b0:	ee04 5b06 	vmla.f64	d5, d4, d6
100061b4:	950a      	str	r5, [sp, #40]	@ 0x28
100061b6:	2400      	movs	r4, #0
100061b8:	2500      	movs	r5, #0
100061ba:	ee86 4b05 	vdiv.f64	d4, d6, d5
100061be:	17de      	asrs	r6, r3, #31
100061c0:	46bb      	mov	fp, r7
100061c2:	9611      	str	r6, [sp, #68]	@ 0x44
100061c4:	9709      	str	r7, [sp, #36]	@ 0x24
100061c6:	4626      	mov	r6, r4
100061c8:	462f      	mov	r7, r5
100061ca:	ed9f 3bbb 	vldr	d3, [pc, #748]	@ 100064b8 <fxr_div_fp64_exact+0x398>
100061ce:	ee27 7b04 	vmul.f64	d7, d7, d4
100061d2:	e9cd 6700 	strd	r6, r7, [sp]
100061d6:	e9cd 6704 	strd	r6, r7, [sp, #16]
100061da:	e9cd 6706 	strd	r6, r7, [sp, #24]
100061de:	4616      	mov	r6, r2
100061e0:	461f      	mov	r7, r3
100061e2:	ee27 7b03 	vmul.f64	d7, d7, d3
100061e6:	ea52 73df 	lsrl	r2, r3, #31
100061ea:	ea56 779f 	lsrl	r6, r7, #30
100061ee:	ed8d 7b02 	vstr	d7, [sp, #8]
100061f2:	43d7      	mvns	r7, r2
100061f4:	43f6      	mvns	r6, r6
100061f6:	f8df e2d0 	ldr.w	lr, [pc, #720]	@ 100064c8 <fxr_div_fp64_exact+0x3a8>
100061fa:	f00a 0101 	and.w	r1, sl, #1
100061fe:	48b0      	ldr	r0, [pc, #704]	@ (100064c0 <fxr_div_fp64_exact+0x3a0>)
10006200:	910f      	str	r1, [sp, #60]	@ 0x3c
10006202:	49b0      	ldr	r1, [pc, #704]	@ (100064c4 <fxr_div_fp64_exact+0x3a4>)
10006204:	970e      	str	r7, [sp, #56]	@ 0x38
10006206:	e9dd 9702 	ldrd	r9, r7, [sp, #8]
1000620a:	ebbe 0209 	subs.w	r2, lr, r9
1000620e:	eb61 0207 	sbc.w	r2, r1, r7
10006212:	f006 0301 	and.w	r3, r6, #1
10006216:	ea47 0600 	orr.w	r6, r7, r0
1000621a:	4032      	ands	r2, r6
1000621c:	ea07 0600 	and.w	r6, r7, r0
10006220:	4332      	orrs	r2, r6
10006222:	0fd2      	lsrs	r2, r2, #31
10006224:	9216      	str	r2, [sp, #88]	@ 0x58
10006226:	9a16      	ldr	r2, [sp, #88]	@ 0x58
10006228:	9310      	str	r3, [sp, #64]	@ 0x40
1000622a:	4254      	negs	r4, r2
1000622c:	eb6c 050c 	sbc.w	r5, ip, ip
10006230:	e9cd 4524 	strd	r4, r5, [sp, #144]	@ 0x90
10006234:	e9dd 2324 	ldrd	r2, r3, [sp, #144]	@ 0x90
10006238:	ea89 050e 	eor.w	r5, r9, lr
1000623c:	ea87 0401 	eor.w	r4, r7, r1
10006240:	4015      	ands	r5, r2
10006242:	401c      	ands	r4, r3
10006244:	ea85 0209 	eor.w	r2, r5, r9
10006248:	407c      	eors	r4, r7
1000624a:	9200      	str	r2, [sp, #0]
1000624c:	9401      	str	r4, [sp, #4]
1000624e:	ed9d 7b00 	vldr	d7, [sp]
10006252:	4654      	mov	r4, sl
10006254:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10006258:	465d      	mov	r5, fp
1000625a:	ee17 6a90 	vmov	r6, s15
1000625e:	ea54 055f 	lsrl	r4, r5, #1
10006262:	2200      	movs	r2, #0
10006264:	2300      	movs	r3, #0
10006266:	ee12 9a90 	vmov	r9, s5
1000626a:	e9cd 450c 	strd	r4, r5, [sp, #48]	@ 0x30
1000626e:	e9cd 2302 	strd	r2, r3, [sp, #8]
10006272:	fba6 420a 	umull	r4, r2, r6, sl
10006276:	ebb9 0304 	subs.w	r3, r9, r4
1000627a:	46e1      	mov	r9, ip
1000627c:	fbeb 2906 	umlal	r2, r9, fp, r6
10006280:	eb68 0602 	sbc.w	r6, r8, r2
10006284:	ea62 0408 	orn	r4, r2, r8
10006288:	4034      	ands	r4, r6
1000628a:	ea22 0208 	bic.w	r2, r2, r8
1000628e:	4314      	orrs	r4, r2
10006290:	0fe4      	lsrs	r4, r4, #31
10006292:	941c      	str	r4, [sp, #112]	@ 0x70
10006294:	9a1c      	ldr	r2, [sp, #112]	@ 0x70
10006296:	edcd 7a00 	vstr	s15, [sp]
1000629a:	eb09 0802 	add.w	r8, r9, r2
1000629e:	f1c8 0700 	rsb	r7, r8, #0
100062a2:	ea0a 74e7 	and.w	r4, sl, r7, asr #31
100062a6:	191b      	adds	r3, r3, r4
100062a8:	ea0b 74e7 	and.w	r4, fp, r7, asr #31
100062ac:	4621      	mov	r1, r4
100062ae:	eb46 0504 	adc.w	r5, r6, r4
100062b2:	ebb3 040a 	subs.w	r4, r3, sl
100062b6:	ea66 0405 	orn	r4, r6, r5
100062ba:	ea04 0401 	and.w	r4, r4, r1
100062be:	ea26 0605 	bic.w	r6, r6, r5
100062c2:	ea44 0406 	orr.w	r4, r4, r6
100062c6:	ee17 6a90 	vmov	r6, s15
100062ca:	ea4f 74d4 	mov.w	r4, r4, lsr #31
100062ce:	941d      	str	r4, [sp, #116]	@ 0x74
100062d0:	9c1d      	ldr	r4, [sp, #116]	@ 0x74
100062d2:	497c      	ldr	r1, [pc, #496]	@ (100064c4 <fxr_div_fp64_exact+0x3a4>)
100062d4:	eba2 0204 	sub.w	r2, r2, r4
100062d8:	444a      	add	r2, r9
100062da:	eba4 0408 	sub.w	r4, r4, r8
100062de:	ea42 0204 	orr.w	r2, r2, r4
100062e2:	ea4f 72d2 	mov.w	r2, r2, lsr #31
100062e6:	921e      	str	r2, [sp, #120]	@ 0x78
100062e8:	ea6b 0405 	orn	r4, fp, r5
100062ec:	eb65 020b 	sbc.w	r2, r5, fp
100062f0:	4022      	ands	r2, r4
100062f2:	ea2b 0405 	bic.w	r4, fp, r5
100062f6:	4322      	orrs	r2, r4
100062f8:	0fd2      	lsrs	r2, r2, #31
100062fa:	9c1e      	ldr	r4, [sp, #120]	@ 0x78
100062fc:	921f      	str	r2, [sp, #124]	@ 0x7c
100062fe:	9a1f      	ldr	r2, [sp, #124]	@ 0x7c
10006300:	f082 0201 	eor.w	r2, r2, #1
10006304:	4322      	orrs	r2, r4
10006306:	18b4      	adds	r4, r6, r2
10006308:	4252      	negs	r2, r2
1000630a:	eba4 78d7 	sub.w	r8, r4, r7, lsr #31
1000630e:	ea02 020a 	and.w	r2, r2, sl
10006312:	eb6c 040c 	sbc.w	r4, ip, ip
10006316:	ea04 040b 	and.w	r4, r4, fp
1000631a:	1a9b      	subs	r3, r3, r2
1000631c:	eb65 0404 	sbc.w	r4, r5, r4
10006320:	ee07 4a90 	vmov	s15, r4
10006324:	eeb8 5b67 	vcvt.f64.u32	d5, s15
10006328:	ee07 3a90 	vmov	s15, r3
1000632c:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10006330:	ee05 7b06 	vmla.f64	d7, d5, d6
10006334:	ee27 7b04 	vmul.f64	d7, d7, d4
10006338:	ed8d 7b00 	vstr	d7, [sp]
1000633c:	e9dd 5200 	ldrd	r5, r2, [sp]
10006340:	ebbe 0605 	subs.w	r6, lr, r5
10006344:	eb61 0702 	sbc.w	r7, r1, r2
10006348:	ea82 0601 	eor.w	r6, r2, r1
1000634c:	ea42 0100 	orr.w	r1, r2, r0
10006350:	4039      	ands	r1, r7
10006352:	4010      	ands	r0, r2
10006354:	4301      	orrs	r1, r0
10006356:	0fc9      	lsrs	r1, r1, #31
10006358:	9115      	str	r1, [sp, #84]	@ 0x54
1000635a:	9915      	ldr	r1, [sp, #84]	@ 0x54
1000635c:	ea85 0e0e 	eor.w	lr, r5, lr
10006360:	4249      	negs	r1, r1
10006362:	9104      	str	r1, [sp, #16]
10006364:	eb6c 010c 	sbc.w	r1, ip, ip
10006368:	9105      	str	r1, [sp, #20]
1000636a:	e9dd 0104 	ldrd	r0, r1, [sp, #16]
1000636e:	e9cd 0122 	strd	r0, r1, [sp, #136]	@ 0x88
10006372:	e9dd 0122 	ldrd	r0, r1, [sp, #136]	@ 0x88
10006376:	ea0e 0e00 	and.w	lr, lr, r0
1000637a:	4031      	ands	r1, r6
1000637c:	404a      	eors	r2, r1
1000637e:	ea8e 0605 	eor.w	r6, lr, r5
10006382:	9606      	str	r6, [sp, #24]
10006384:	9207      	str	r2, [sp, #28]
10006386:	ed9d 7b06 	vldr	d7, [sp, #24]
1000638a:	eefc 7bc7 	vcvt.u32.f64	s15, d7
1000638e:	ee17 9a90 	vmov	r9, s15
10006392:	46e6      	mov	lr, ip
10006394:	fba9 210a 	umull	r2, r1, r9, sl
10006398:	fbeb 1e09 	umlal	r1, lr, fp, r9
1000639c:	4677      	mov	r7, lr
1000639e:	ebbc 0202 	subs.w	r2, ip, r2
100063a2:	eb63 0601 	sbc.w	r6, r3, r1
100063a6:	ea61 0003 	orn	r0, r1, r3
100063aa:	4030      	ands	r0, r6
100063ac:	ea21 0103 	bic.w	r1, r1, r3
100063b0:	4308      	orrs	r0, r1
100063b2:	0fc0      	lsrs	r0, r0, #31
100063b4:	9018      	str	r0, [sp, #96]	@ 0x60
100063b6:	9b18      	ldr	r3, [sp, #96]	@ 0x60
100063b8:	1ae5      	subs	r5, r4, r3
100063ba:	1bed      	subs	r5, r5, r7
100063bc:	ea0a 71e5 	and.w	r1, sl, r5, asr #31
100063c0:	ea0b 7ee5 	and.w	lr, fp, r5, asr #31
100063c4:	1852      	adds	r2, r2, r1
100063c6:	eb46 000e 	adc.w	r0, r6, lr
100063ca:	ebb2 010a 	subs.w	r1, r2, sl
100063ce:	ea66 0100 	orn	r1, r6, r0
100063d2:	ea01 010e 	and.w	r1, r1, lr
100063d6:	ea26 0600 	bic.w	r6, r6, r0
100063da:	ea41 0106 	orr.w	r1, r1, r6
100063de:	ea4f 71d1 	mov.w	r1, r1, lsr #31
100063e2:	9119      	str	r1, [sp, #100]	@ 0x64
100063e4:	9919      	ldr	r1, [sp, #100]	@ 0x64
100063e6:	eba3 0301 	sub.w	r3, r3, r1
100063ea:	eba3 0304 	sub.w	r3, r3, r4
100063ee:	4429      	add	r1, r5
100063f0:	443b      	add	r3, r7
100063f2:	ea43 0301 	orr.w	r3, r3, r1
100063f6:	ea4f 73d3 	mov.w	r3, r3, lsr #31
100063fa:	931a      	str	r3, [sp, #104]	@ 0x68
100063fc:	ea6b 0100 	orn	r1, fp, r0
10006400:	eb60 030b 	sbc.w	r3, r0, fp
10006404:	400b      	ands	r3, r1
10006406:	ea2b 0100 	bic.w	r1, fp, r0
1000640a:	430b      	orrs	r3, r1
1000640c:	0fdb      	lsrs	r3, r3, #31
1000640e:	991a      	ldr	r1, [sp, #104]	@ 0x68
10006410:	931b      	str	r3, [sp, #108]	@ 0x6c
10006412:	9b1b      	ldr	r3, [sp, #108]	@ 0x6c
10006414:	f083 0301 	eor.w	r3, r3, #1
10006418:	430b      	orrs	r3, r1
1000641a:	4499      	add	r9, r3
1000641c:	425b      	negs	r3, r3
1000641e:	eb6c 010c 	sbc.w	r1, ip, ip
10006422:	ea03 030a 	and.w	r3, r3, sl
10006426:	1ad3      	subs	r3, r2, r3
10006428:	ea01 010b 	and.w	r1, r1, fp
1000642c:	eb60 0101 	sbc.w	r1, r0, r1
10006430:	980f      	ldr	r0, [sp, #60]	@ 0x3c
10006432:	e9dd ab0c 	ldrd	sl, fp, [sp, #48]	@ 0x30
10006436:	eb1a 0000 	adds.w	r0, sl, r0
1000643a:	f14b 0200 	adc.w	r2, fp, #0
1000643e:	1a18      	subs	r0, r3, r0
10006440:	eb61 0302 	sbc.w	r3, r1, r2
10006444:	ea62 0001 	orn	r0, r2, r1
10006448:	4003      	ands	r3, r0
1000644a:	ea22 0201 	bic.w	r2, r2, r1
1000644e:	4313      	orrs	r3, r2
10006450:	0fdb      	lsrs	r3, r3, #31
10006452:	9314      	str	r3, [sp, #80]	@ 0x50
10006454:	9b14      	ldr	r3, [sp, #80]	@ 0x50
10006456:	eba9 79d5 	sub.w	r9, r9, r5, lsr #31
1000645a:	f083 0301 	eor.w	r3, r3, #1
1000645e:	9d0a      	ldr	r5, [sp, #40]	@ 0x28
10006460:	eb13 0309 	adds.w	r3, r3, r9
10006464:	f148 0200 	adc.w	r2, r8, #0
10006468:	4269      	negs	r1, r5
1000646a:	9102      	str	r1, [sp, #8]
1000646c:	eb6c 010c 	sbc.w	r1, ip, ip
10006470:	9103      	str	r1, [sp, #12]
10006472:	9f0e      	ldr	r7, [sp, #56]	@ 0x38
10006474:	9810      	ldr	r0, [sp, #64]	@ 0x40
10006476:	9e11      	ldr	r6, [sp, #68]	@ 0x44
10006478:	19c0      	adds	r0, r0, r7
1000647a:	9c12      	ldr	r4, [sp, #72]	@ 0x48
1000647c:	9d13      	ldr	r5, [sp, #76]	@ 0x4c
1000647e:	f166 0100 	sbc.w	r1, r6, #0
10006482:	4058      	eors	r0, r3
10006484:	e9dd 8902 	ldrd	r8, r9, [sp, #8]
10006488:	e9cd 8920 	strd	r8, r9, [sp, #128]	@ 0x80
1000648c:	e9dd 6720 	ldrd	r6, r7, [sp, #128]	@ 0x80
10006490:	405c      	eors	r4, r3
10006492:	4051      	eors	r1, r2
10006494:	ea85 0302 	eor.w	r3, r5, r2
10006498:	4030      	ands	r0, r6
1000649a:	9a0b      	ldr	r2, [sp, #44]	@ 0x2c
1000649c:	4039      	ands	r1, r7
1000649e:	4060      	eors	r0, r4
100064a0:	1880      	adds	r0, r0, r2
100064a2:	ea81 0103 	eor.w	r1, r1, r3
100064a6:	f141 0100 	adc.w	r1, r1, #0
100064aa:	b027      	add	sp, #156	@ 0x9c
100064ac:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
100064b0:	00000000 	.word	0x00000000
100064b4:	41f00000 	.word	0x41f00000
100064b8:	00000000 	.word	0x00000000
100064bc:	3df00000 	.word	0x3df00000
100064c0:	be100000 	.word	0xbe100000
100064c4:	41efffff 	.word	0x41efffff
100064c8:	ffe00000 	.word	0xffe00000
