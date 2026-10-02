100060b8 <fndsa_vect_mul_fft_fp64_exact>:
100060b8:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
100060bc:	2310      	movs	r3, #16
100060be:	ed2d 8b10 	vpush	{d8-d15}
100060c2:	3801      	subs	r0, #1
100060c4:	4083      	lsls	r3, r0
100060c6:	f1a3 0e10 	sub.w	lr, r3, #16
100060ca:	ea4f 1e1e 	mov.w	lr, lr, lsr #4
100060ce:	b0bb      	sub	sp, #236	@ 0xec
100060d0:	eb01 0b03 	add.w	fp, r1, r3
100060d4:	f10e 0e01 	add.w	lr, lr, #1
100060d8:	18d3      	adds	r3, r2, r3
100060da:	e9cd 3b1f 	strd	r3, fp, [sp, #124]	@ 0x7c
100060de:	2700      	movs	r7, #0
100060e0:	ed9f fb09 	vldr	d15, [pc, #36]	@ 10006108 <fndsa_vect_mul_fft_fp64_exact+0x50>
100060e4:	ed9f cb0a 	vldr	d12, [pc, #40]	@ 10006110 <fndsa_vect_mul_fft_fp64_exact+0x58>
100060e8:	eeb7 bb00 	vmov.f64	d11, #112	@ 0x3f800000  1.0
100060ec:	f04e e001 	dls	lr, lr
100060f0:	4693      	mov	fp, r2
100060f2:	f10d 0aa8 	add.w	sl, sp, #168	@ 0xa8
100060f6:	f10d 09b8 	add.w	r9, sp, #184	@ 0xb8
100060fa:	f10d 08c8 	add.w	r8, sp, #200	@ 0xc8
100060fe:	9121      	str	r1, [sp, #132]	@ 0x84
10006100:	e00a      	b.n	10006118 <fndsa_vect_mul_fft_fp64_exact+0x60>
10006102:	bf00      	nop
10006104:	f3af 8000 	nop.w
10006108:	00000000 	.word	0x00000000
1000610c:	3df00000 	.word	0x3df00000
10006110:	00000000 	.word	0x00000000
10006114:	41f00000 	.word	0x41f00000
10006118:	9b21      	ldr	r3, [sp, #132]	@ 0x84
1000611a:	eb0b 0c07 	add.w	ip, fp, r7
1000611e:	19dd      	adds	r5, r3, r7
10006120:	9b20      	ldr	r3, [sp, #128]	@ 0x80
10006122:	19dc      	adds	r4, r3, r7
10006124:	9b1f      	ldr	r3, [sp, #124]	@ 0x7c
10006126:	19de      	adds	r6, r3, r7
10006128:	e895 000f 	ldmia.w	r5, {r0, r1, r2, r3}
1000612c:	e88a 000f 	stmia.w	sl, {r0, r1, r2, r3}
10006130:	e894 000f 	ldmia.w	r4, {r0, r1, r2, r3}
10006134:	e889 000f 	stmia.w	r9, {r0, r1, r2, r3}
10006138:	e89c 000f 	ldmia.w	ip, {r0, r1, r2, r3}
1000613c:	e888 000f 	stmia.w	r8, {r0, r1, r2, r3}
10006140:	e896 000f 	ldmia.w	r6, {r0, r1, r2, r3}
10006144:	ae36      	add	r6, sp, #216	@ 0xd8
10006146:	e886 000f 	stmia.w	r6, {r0, r1, r2, r3}
1000614a:	ed9d eb2a 	vldr	d14, [sp, #168]	@ 0xa8
1000614e:	ed9d 7b34 	vldr	d7, [sp, #208]	@ 0xd0
10006152:	ed9d 8b32 	vldr	d8, [sp, #200]	@ 0xc8
10006156:	ee27 9b0f 	vmul.f64	d9, d7, d15
1000615a:	eefc 7bce 	vcvt.u32.f64	s15, d14
1000615e:	ed9d 1b2e 	vldr	d1, [sp, #184]	@ 0xb8
10006162:	ee17 0a90 	vmov	r0, s15
10006166:	eefc 7bc8 	vcvt.u32.f64	s15, d8
1000616a:	ed9d ab36 	vldr	d10, [sp, #216]	@ 0xd8
1000616e:	ee17 2a90 	vmov	r2, s15
10006172:	eefc 7bc1 	vcvt.u32.f64	s15, d1
10006176:	ee17 1a90 	vmov	r1, s15
1000617a:	eefc 7bca 	vcvt.u32.f64	s15, d10
1000617e:	ee17 3a90 	vmov	r3, s15
10006182:	ed9d 7b2c 	vldr	d7, [sp, #176]	@ 0xb0
10006186:	0fc0      	lsrs	r0, r0, #31
10006188:	ee27 4b09 	vmul.f64	d4, d7, d9
1000618c:	ee07 0a90 	vmov	s15, r0
10006190:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10006194:	0fc9      	lsrs	r1, r1, #31
10006196:	ed8d 7b12 	vstr	d7, [sp, #72]	@ 0x48
1000619a:	ee07 1a90 	vmov	s15, r1
1000619e:	0fd2      	lsrs	r2, r2, #31
100061a0:	eeb8 3be7 	vcvt.f64.s32	d3, s15
100061a4:	ee07 2a90 	vmov	s15, r2
100061a8:	0fdb      	lsrs	r3, r3, #31
100061aa:	eeb8 2be7 	vcvt.f64.s32	d2, s15
100061ae:	ee07 3a90 	vmov	s15, r3
100061b2:	ee2e 9b09 	vmul.f64	d9, d14, d9
100061b6:	eeb8 0be7 	vcvt.f64.s32	d0, s15
100061ba:	ed8d 3b16 	vstr	d3, [sp, #88]	@ 0x58
100061be:	ed9d 7b34 	vldr	d7, [sp, #208]	@ 0xd0
100061c2:	ed9d 3b38 	vldr	d3, [sp, #224]	@ 0xe0
100061c6:	ed8d 0b18 	vstr	d0, [sp, #96]	@ 0x60
100061ca:	eebc 9bc9 	vcvt.u32.f64	s18, d9
100061ce:	ee37 0b03 	vadd.f64	d0, d7, d3
100061d2:	ed9d 7b2c 	vldr	d7, [sp, #176]	@ 0xb0
100061d6:	ed9d 3b30 	vldr	d3, [sp, #192]	@ 0xc0
100061da:	ee28 6b0f 	vmul.f64	d6, d8, d15
100061de:	ee37 db03 	vadd.f64	d13, d7, d3
100061e2:	eeb8 9b49 	vcvt.f64.u32	d9, s18
100061e6:	ed9d 3b2c 	vldr	d3, [sp, #176]	@ 0xb0
100061ea:	ed8d 9b08 	vstr	d9, [sp, #32]
100061ee:	ee23 3b06 	vmul.f64	d3, d3, d6
100061f2:	ee20 9b0f 	vmul.f64	d9, d0, d15
100061f6:	eefc 3bc3 	vcvt.u32.f64	s7, d3
100061fa:	eebc 3bc9 	vcvt.u32.f64	s6, d9
100061fe:	ed9d 7b38 	vldr	d7, [sp, #224]	@ 0xe0
10006202:	ee2e 6b06 	vmul.f64	d6, d14, d6
10006206:	eeb8 9b63 	vcvt.f64.u32	d9, s7
1000620a:	ed8d 2b14 	vstr	d2, [sp, #80]	@ 0x50
1000620e:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10006212:	ee38 2b0a 	vadd.f64	d2, d8, d10
10006216:	ee27 5b0f 	vmul.f64	d5, d7, d15
1000621a:	ee32 2b03 	vadd.f64	d2, d2, d3
1000621e:	ee03 0b4c 	vmls.f64	d0, d3, d12
10006222:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006226:	ed9d 3b30 	vldr	d3, [sp, #192]	@ 0xc0
1000622a:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000622e:	ee23 3b05 	vmul.f64	d3, d3, d5
10006232:	ee25 5b01 	vmul.f64	d5, d5, d1
10006236:	ee26 6b4c 	vnmul.f64	d6, d6, d12
1000623a:	eeae 6b08 	vfma.f64	d6, d14, d8
1000623e:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10006242:	ee36 6b0c 	vadd.f64	d6, d6, d12
10006246:	ee2a 7b0f 	vmul.f64	d7, d10, d15
1000624a:	ed8d 9b00 	vstr	d9, [sp]
1000624e:	ed8d 6b0e 	vstr	d6, [sp, #56]	@ 0x38
10006252:	eeb0 9b40 	vmov.f64	d9, d0
10006256:	ee2d 6b0f 	vmul.f64	d6, d13, d15
1000625a:	ed9d 0b30 	vldr	d0, [sp, #192]	@ 0xc0
1000625e:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10006262:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006266:	ed8d 5b0c 	vstr	d5, [sp, #48]	@ 0x30
1000626a:	ee20 5b07 	vmul.f64	d5, d0, d7
1000626e:	ee27 7b01 	vmul.f64	d7, d7, d1
10006272:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006276:	ee3e 0b01 	vadd.f64	d0, d14, d1
1000627a:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000627e:	ee30 0b06 	vadd.f64	d0, d0, d6
10006282:	ee06 db4c 	vmls.f64	d13, d6, d12
10006286:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000628a:	ee22 6b0f 	vmul.f64	d6, d2, d15
1000628e:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10006292:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006296:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000629a:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000629e:	ee27 7b4c 	vnmul.f64	d7, d7, d12
100062a2:	eea1 7b0a 	vfma.f64	d7, d1, d10
100062a6:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100062aa:	ee37 7b0c 	vadd.f64	d7, d7, d12
100062ae:	ed8d db02 	vstr	d13, [sp, #8]
100062b2:	ed8d 5b0a 	vstr	d5, [sp, #40]	@ 0x28
100062b6:	ed9d db2c 	vldr	d13, [sp, #176]	@ 0xb0
100062ba:	ed9d 5b34 	vldr	d5, [sp, #208]	@ 0xd0
100062be:	ed8d 7b10 	vstr	d7, [sp, #64]	@ 0x40
100062c2:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100062c6:	ee24 7b4c 	vnmul.f64	d7, d4, d12
100062ca:	eead 7b05 	vfma.f64	d7, d13, d5
100062ce:	ee37 7b0c 	vadd.f64	d7, d7, d12
100062d2:	ee06 2b4c 	vmls.f64	d2, d6, d12
100062d6:	ee27 7b0f 	vmul.f64	d7, d7, d15
100062da:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100062de:	eefc 7bc2 	vcvt.u32.f64	s15, d2
100062e2:	ee17 3a90 	vmov	r3, s15
100062e6:	0fdb      	lsrs	r3, r3, #31
100062e8:	ee07 3a90 	vmov	s15, r3
100062ec:	eeb8 5b47 	vcvt.f64.u32	d5, s14
100062f0:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100062f4:	ee35 5b04 	vadd.f64	d5, d5, d4
100062f8:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100062fc:	eeb8 4be7 	vcvt.f64.s32	d4, s15
10006300:	ed8d 2b04 	vstr	d2, [sp, #16]
10006304:	ee23 7b4c 	vnmul.f64	d7, d3, d12
10006308:	ed9d 2b30 	vldr	d2, [sp, #192]	@ 0xc0
1000630c:	ed8d 4b1c 	vstr	d4, [sp, #112]	@ 0x70
10006310:	ed9d 4b38 	vldr	d4, [sp, #224]	@ 0xe0
10006314:	eea2 7b04 	vfma.f64	d7, d2, d4
10006318:	ee20 4b0f 	vmul.f64	d4, d0, d15
1000631c:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10006320:	ee37 6b0c 	vadd.f64	d6, d7, d12
10006324:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10006328:	eeb0 7b40 	vmov.f64	d7, d0
1000632c:	ee04 7b4c 	vmls.f64	d7, d4, d12
10006330:	ed9d db00 	vldr	d13, [sp]
10006334:	ed8d 7b00 	vstr	d7, [sp]
10006338:	eefc 7bc7 	vcvt.u32.f64	s15, d7
1000633c:	ee26 6b0f 	vmul.f64	d6, d6, d15
10006340:	ee17 3a90 	vmov	r3, s15
10006344:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006348:	0fdb      	lsrs	r3, r3, #31
1000634a:	ee07 3a90 	vmov	s15, r3
1000634e:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006352:	ed8d 9b06 	vstr	d9, [sp, #24]
10006356:	ee29 2b0f 	vmul.f64	d2, d9, d15
1000635a:	ed9d 4b2c 	vldr	d4, [sp, #176]	@ 0xb0
1000635e:	ed9d 0b08 	vldr	d0, [sp, #32]
10006362:	ee36 6b03 	vadd.f64	d6, d6, d3
10006366:	ee2d 9b4c 	vnmul.f64	d9, d13, d12
1000636a:	eea4 9b08 	vfma.f64	d9, d4, d8
1000636e:	ed9d 3b0a 	vldr	d3, [sp, #40]	@ 0x28
10006372:	eeb8 8be7 	vcvt.f64.s32	d8, s15
10006376:	ed9d 4b30 	vldr	d4, [sp, #192]	@ 0xc0
1000637a:	ed8d 8b1a 	vstr	d8, [sp, #104]	@ 0x68
1000637e:	ee20 7b4c 	vnmul.f64	d7, d0, d12
10006382:	ee23 8b4c 	vnmul.f64	d8, d3, d12
10006386:	eea4 8b0a 	vfma.f64	d8, d4, d10
1000638a:	ed9d 4b04 	vldr	d4, [sp, #16]
1000638e:	ed9d ab34 	vldr	d10, [sp, #208]	@ 0xd0
10006392:	eeae 7b0a 	vfma.f64	d7, d14, d10
10006396:	ed9d eb0c 	vldr	d14, [sp, #48]	@ 0x30
1000639a:	ee24 3b0f 	vmul.f64	d3, d4, d15
1000639e:	ed9d ab38 	vldr	d10, [sp, #224]	@ 0xe0
100063a2:	ee2e 4b4c 	vnmul.f64	d4, d14, d12
100063a6:	eea1 4b0a 	vfma.f64	d4, d1, d10
100063aa:	ed9d ab00 	vldr	d10, [sp]
100063ae:	ed9d 1b02 	vldr	d1, [sp, #8]
100063b2:	ee21 0b02 	vmul.f64	d0, d1, d2
100063b6:	ee2a 2b02 	vmul.f64	d2, d10, d2
100063ba:	ee39 9b0c 	vadd.f64	d9, d9, d12
100063be:	ee38 8b0c 	vadd.f64	d8, d8, d12
100063c2:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100063c6:	ee29 1b0f 	vmul.f64	d1, d9, d15
100063ca:	eeb8 eb42 	vcvt.f64.u32	d14, s4
100063ce:	ee28 2b0f 	vmul.f64	d2, d8, d15
100063d2:	eebc 1bc1 	vcvt.u32.f64	s2, d1
100063d6:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100063da:	eeb8 1b41 	vcvt.f64.u32	d1, s2
100063de:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100063e2:	ee01 9b4c 	vmls.f64	d9, d1, d12
100063e6:	ee02 8b4c 	vmls.f64	d8, d2, d12
100063ea:	ee35 5b4b 	vsub.f64	d5, d5, d11
100063ee:	ee36 6b4b 	vsub.f64	d6, d6, d11
100063f2:	ee35 5b09 	vadd.f64	d5, d5, d9
100063f6:	ee36 6b08 	vadd.f64	d6, d6, d8
100063fa:	ed9d 9b0a 	vldr	d9, [sp, #40]	@ 0x28
100063fe:	ee37 7b0c 	vadd.f64	d7, d7, d12
10006402:	ed9d 8b02 	vldr	d8, [sp, #8]
10006406:	ee39 2b02 	vadd.f64	d2, d9, d2
1000640a:	ee28 8b03 	vmul.f64	d8, d8, d3
1000640e:	ee27 9b0f 	vmul.f64	d9, d7, d15
10006412:	eefc 8bc8 	vcvt.u32.f64	s17, d8
10006416:	eebc 8bc9 	vcvt.u32.f64	s16, d9
1000641a:	ee2a 3b03 	vmul.f64	d3, d10, d3
1000641e:	eeb8 9b68 	vcvt.f64.u32	d9, s17
10006422:	ee3d 1b01 	vadd.f64	d1, d13, d1
10006426:	eeb8 8b48 	vcvt.f64.u32	d8, s16
1000642a:	ed9d db08 	vldr	d13, [sp, #32]
1000642e:	ee08 7b4c 	vmls.f64	d7, d8, d12
10006432:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10006436:	ee3d 8b08 	vadd.f64	d8, d13, d8
1000643a:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000643e:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10006442:	ee34 4b0c 	vadd.f64	d4, d4, d12
10006446:	ee31 1b4b 	vsub.f64	d1, d1, d11
1000644a:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000644e:	ee38 8b4b 	vsub.f64	d8, d8, d11
10006452:	ee35 7b07 	vadd.f64	d7, d5, d7
10006456:	ee31 8b08 	vadd.f64	d8, d1, d8
1000645a:	ed9d 5b04 	vldr	d5, [sp, #16]
1000645e:	ed9d 1b06 	vldr	d1, [sp, #24]
10006462:	ed9d db02 	vldr	d13, [sp, #8]
10006466:	ee23 3b4c 	vnmul.f64	d3, d3, d12
1000646a:	eeaa 3b05 	vfma.f64	d3, d10, d5
1000646e:	ee20 5b4c 	vnmul.f64	d5, d0, d12
10006472:	eead 5b01 	vfma.f64	d5, d13, d1
10006476:	ee33 ab0c 	vadd.f64	d10, d3, d12
1000647a:	ee35 5b0c 	vadd.f64	d5, d5, d12
1000647e:	ee24 3b0f 	vmul.f64	d3, d4, d15
10006482:	ee25 5b0f 	vmul.f64	d5, d5, d15
10006486:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000648a:	ed9d db0c 	vldr	d13, [sp, #48]	@ 0x30
1000648e:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10006492:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10006496:	ee03 4b4c 	vmls.f64	d4, d3, d12
1000649a:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000649e:	ee3d 3b03 	vadd.f64	d3, d13, d3
100064a2:	ee36 4b04 	vadd.f64	d4, d6, d4
100064a6:	ee33 3b4b 	vsub.f64	d3, d3, d11
100064aa:	ed9d 6b04 	vldr	d6, [sp, #16]
100064ae:	ee35 5b00 	vadd.f64	d5, d5, d0
100064b2:	ee29 1b4c 	vnmul.f64	d1, d9, d12
100064b6:	ed9d 0b02 	vldr	d0, [sp, #8]
100064ba:	eea0 1b06 	vfma.f64	d1, d0, d6
100064be:	ee32 2b4b 	vsub.f64	d2, d2, d11
100064c2:	ed9d 6b0e 	vldr	d6, [sp, #56]	@ 0x38
100064c6:	ed9d db10 	vldr	d13, [sp, #64]	@ 0x40
100064ca:	ee32 2b03 	vadd.f64	d2, d2, d3
100064ce:	ee26 3b0f 	vmul.f64	d3, d6, d15
100064d2:	ee2d 0b0f 	vmul.f64	d0, d13, d15
100064d6:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100064da:	eebc 0bc0 	vcvt.u32.f64	s0, d0
100064de:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100064e2:	eeb8 0b40 	vcvt.f64.u32	d0, s0
100064e6:	ee03 6b4c 	vmls.f64	d6, d3, d12
100064ea:	eeb0 3b4d 	vmov.f64	d3, d13
100064ee:	ee31 1b0c 	vadd.f64	d1, d1, d12
100064f2:	ee00 3b4c 	vmls.f64	d3, d0, d12
100064f6:	ee36 6b08 	vadd.f64	d6, d6, d8
100064fa:	ed9d 0b00 	vldr	d0, [sp]
100064fe:	ed9d 8b06 	vldr	d8, [sp, #24]
10006502:	ee33 3b02 	vadd.f64	d3, d3, d2
10006506:	ee2e 2b4c 	vnmul.f64	d2, d14, d12
1000650a:	eea0 2b08 	vfma.f64	d2, d0, d8
1000650e:	ee21 0b0f 	vmul.f64	d0, d1, d15
10006512:	ee27 8b0f 	vmul.f64	d8, d7, d15
10006516:	eebc 0bc0 	vcvt.u32.f64	s0, d0
1000651a:	eebc 8bc8 	vcvt.u32.f64	s16, d8
1000651e:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10006522:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10006526:	ee35 5b4b 	vsub.f64	d5, d5, d11
1000652a:	ee00 1b4c 	vmls.f64	d1, d0, d12
1000652e:	ee36 6b08 	vadd.f64	d6, d6, d8
10006532:	ee39 0b00 	vadd.f64	d0, d9, d0
10006536:	ed9f 9b72 	vldr	d9, [pc, #456]	@ 10006700 <fndsa_vect_mul_fft_fp64_exact+0x648>
1000653a:	ee35 1b01 	vadd.f64	d1, d5, d1
1000653e:	ed9d db34 	vldr	d13, [sp, #208]	@ 0xd0
10006542:	ed9d 5b12 	vldr	d5, [sp, #72]	@ 0x48
10006546:	ee36 6b09 	vadd.f64	d6, d6, d9
1000654a:	ee05 6b4d 	vmls.f64	d6, d5, d13
1000654e:	ed9d db14 	vldr	d13, [sp, #80]	@ 0x50
10006552:	ed9d 5b2c 	vldr	d5, [sp, #176]	@ 0xb0
10006556:	ee0d 6b45 	vmls.f64	d6, d13, d5
1000655a:	ee24 5b0f 	vmul.f64	d5, d4, d15
1000655e:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10006562:	ee32 2b0c 	vadd.f64	d2, d2, d12
10006566:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000656a:	ee08 7b4c 	vmls.f64	d7, d8, d12
1000656e:	ee33 3b05 	vadd.f64	d3, d3, d5
10006572:	ee22 8b0f 	vmul.f64	d8, d2, d15
10006576:	ee05 4b4c 	vmls.f64	d4, d5, d12
1000657a:	eebc 8bc8 	vcvt.u32.f64	s16, d8
1000657e:	ed9d 5b16 	vldr	d5, [sp, #88]	@ 0x58
10006582:	ee33 3b09 	vadd.f64	d3, d3, d9
10006586:	ed9d db38 	vldr	d13, [sp, #224]	@ 0xe0
1000658a:	eeb8 8b48 	vcvt.f64.u32	d8, s16
1000658e:	ee05 3b4d 	vmls.f64	d3, d5, d13
10006592:	ed9d 5b18 	vldr	d5, [sp, #96]	@ 0x60
10006596:	ed9d db30 	vldr	d13, [sp, #192]	@ 0xc0
1000659a:	ee08 2b4c 	vmls.f64	d2, d8, d12
1000659e:	ee05 3b4d 	vmls.f64	d3, d5, d13
100065a2:	ee2a 5b0f 	vmul.f64	d5, d10, d15
100065a6:	ee3e eb08 	vadd.f64	d14, d14, d8
100065aa:	ee31 2b02 	vadd.f64	d2, d1, d2
100065ae:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100065b2:	ee22 1b0f 	vmul.f64	d1, d2, d15
100065b6:	ee30 0b4b 	vsub.f64	d0, d0, d11
100065ba:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100065be:	ee3e eb4b 	vsub.f64	d14, d14, d11
100065c2:	ee05 ab4c 	vmls.f64	d10, d5, d12
100065c6:	ee30 eb0e 	vadd.f64	d14, d0, d14
100065ca:	eebc 1bc1 	vcvt.u32.f64	s2, d1
100065ce:	ee3a ab0e 	vadd.f64	d10, d10, d14
100065d2:	eeb8 1b41 	vcvt.f64.u32	d1, s2
100065d6:	ee3a ab01 	vadd.f64	d10, d10, d1
100065da:	ed9d 5b1a 	vldr	d5, [sp, #104]	@ 0x68
100065de:	ee3a ab09 	vadd.f64	d10, d10, d9
100065e2:	ed9d 8b06 	vldr	d8, [sp, #24]
100065e6:	ee05 ab48 	vmls.f64	d10, d5, d8
100065ea:	ee37 5b04 	vadd.f64	d5, d7, d4
100065ee:	ee37 7b0c 	vadd.f64	d7, d7, d12
100065f2:	ee01 2b4c 	vmls.f64	d2, d1, d12
100065f6:	ee37 7b44 	vsub.f64	d7, d7, d4
100065fa:	ed9d 1b1c 	vldr	d1, [sp, #112]	@ 0x70
100065fe:	ed9d 0b02 	vldr	d0, [sp, #8]
10006602:	ee01 ab40 	vmls.f64	d10, d1, d0
10006606:	ee27 1b0f 	vmul.f64	d1, d7, d15
1000660a:	eebc 1bc1 	vcvt.u32.f64	s2, d1
1000660e:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10006612:	ee01 7b4c 	vmls.f64	d7, d1, d12
10006616:	ed8d 7b24 	vstr	d7, [sp, #144]	@ 0x90
1000661a:	ee26 7b0f 	vmul.f64	d7, d6, d15
1000661e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006622:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006626:	ee07 6b4c 	vmls.f64	d6, d7, d12
1000662a:	ee23 7b0f 	vmul.f64	d7, d3, d15
1000662e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006632:	ee25 0b0f 	vmul.f64	d0, d5, d15
10006636:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000663a:	eebc 0bc0 	vcvt.u32.f64	s0, d0
1000663e:	ee07 3b4c 	vmls.f64	d3, d7, d12
10006642:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10006646:	ee36 7b0c 	vadd.f64	d7, d6, d12
1000664a:	ee36 6b03 	vadd.f64	d6, d6, d3
1000664e:	ee2a 4b0f 	vmul.f64	d4, d10, d15
10006652:	ee36 6b00 	vadd.f64	d6, d6, d0
10006656:	ee37 3b43 	vsub.f64	d3, d7, d3
1000665a:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000665e:	ee26 7b0f 	vmul.f64	d7, d6, d15
10006662:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10006666:	ee32 2b0c 	vadd.f64	d2, d2, d12
1000666a:	ee00 5b4c 	vmls.f64	d5, d0, d12
1000666e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006672:	ee04 ab4c 	vmls.f64	d10, d4, d12
10006676:	ee32 5b45 	vsub.f64	d5, d2, d5
1000667a:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000667e:	ee25 4b0f 	vmul.f64	d4, d5, d15
10006682:	ee07 6b4c 	vmls.f64	d6, d7, d12
10006686:	ee3a ab0c 	vadd.f64	d10, d10, d12
1000668a:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000668e:	ee3a 7b46 	vsub.f64	d7, d10, d6
10006692:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10006696:	ee33 3b4b 	vsub.f64	d3, d3, d11
1000669a:	ee37 7b4b 	vsub.f64	d7, d7, d11
1000669e:	ee04 5b4c 	vmls.f64	d5, d4, d12
100066a2:	ee33 3b01 	vadd.f64	d3, d3, d1
100066a6:	ee37 7b04 	vadd.f64	d7, d7, d4
100066aa:	ed8d 5b28 	vstr	d5, [sp, #160]	@ 0xa0
100066ae:	ee27 6b0f 	vmul.f64	d6, d7, d15
100066b2:	ee23 5b0f 	vmul.f64	d5, d3, d15
100066b6:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100066ba:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100066be:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100066c2:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100066c6:	ee06 7b4c 	vmls.f64	d7, d6, d12
100066ca:	ee05 3b4c 	vmls.f64	d3, d5, d12
100066ce:	ed8d 7b26 	vstr	d7, [sp, #152]	@ 0x98
100066d2:	ed8d 3b22 	vstr	d3, [sp, #136]	@ 0x88
100066d6:	ab22      	add	r3, sp, #136	@ 0x88
100066d8:	cb0f      	ldmia	r3, {r0, r1, r2, r3}
100066da:	e885 000f 	stmia.w	r5, {r0, r1, r2, r3}
100066de:	ab26      	add	r3, sp, #152	@ 0x98
100066e0:	cb0f      	ldmia	r3, {r0, r1, r2, r3}
100066e2:	3710      	adds	r7, #16
100066e4:	e884 000f 	stmia.w	r4, {r0, r1, r2, r3}
100066e8:	f1be 0e01 	subs.w	lr, lr, #1
100066ec:	f47f ad14 	bne.w	10006118 <fndsa_vect_mul_fft_fp64_exact+0x60>
100066f0:	b03b      	add	sp, #236	@ 0xec
100066f2:	ecbd 8b10 	vpop	{d8-d15}
100066f6:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
100066fa:	bf00      	nop
100066fc:	f3af 8000 	nop.w
10006700:	00000000 	.word	0x00000000
10006704:	42000000 	.word	0x42000000

