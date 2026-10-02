10008f88 <fndsa_vect_mul_fft_fp64_exact>:
10008f88:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10008f8c:	2310      	movs	r3, #16
10008f8e:	ed2d 8b10 	vpush	{d8-d15}
10008f92:	3801      	subs	r0, #1
10008f94:	4083      	lsls	r3, r0
10008f96:	f1a3 0e10 	sub.w	lr, r3, #16
10008f9a:	ea4f 1e1e 	mov.w	lr, lr, lsr #4
10008f9e:	b0bb      	sub	sp, #236	@ 0xec
10008fa0:	eb01 0b03 	add.w	fp, r1, r3
10008fa4:	f10e 0e01 	add.w	lr, lr, #1
10008fa8:	18d3      	adds	r3, r2, r3
10008faa:	e9cd 3b1f 	strd	r3, fp, [sp, #124]	@ 0x7c
10008fae:	2700      	movs	r7, #0
10008fb0:	ed9f fb09 	vldr	d15, [pc, #36]	@ 10008fd8 <fndsa_vect_mul_fft_fp64_exact+0x50>
10008fb4:	ed9f cb0a 	vldr	d12, [pc, #40]	@ 10008fe0 <fndsa_vect_mul_fft_fp64_exact+0x58>
10008fb8:	eeb7 bb00 	vmov.f64	d11, #112	@ 0x3f800000  1.0
10008fbc:	f04e e001 	dls	lr, lr
10008fc0:	4693      	mov	fp, r2
10008fc2:	f10d 0aa8 	add.w	sl, sp, #168	@ 0xa8
10008fc6:	f10d 09b8 	add.w	r9, sp, #184	@ 0xb8
10008fca:	f10d 08c8 	add.w	r8, sp, #200	@ 0xc8
10008fce:	9121      	str	r1, [sp, #132]	@ 0x84
10008fd0:	e00a      	b.n	10008fe8 <fndsa_vect_mul_fft_fp64_exact+0x60>
10008fd2:	bf00      	nop
10008fd4:	f3af 8000 	nop.w
10008fd8:	00000000 	.word	0x00000000
10008fdc:	3df00000 	.word	0x3df00000
10008fe0:	00000000 	.word	0x00000000
10008fe4:	41f00000 	.word	0x41f00000
10008fe8:	9b21      	ldr	r3, [sp, #132]	@ 0x84
10008fea:	eb0b 0c07 	add.w	ip, fp, r7
10008fee:	19dd      	adds	r5, r3, r7
10008ff0:	9b20      	ldr	r3, [sp, #128]	@ 0x80
10008ff2:	19dc      	adds	r4, r3, r7
10008ff4:	9b1f      	ldr	r3, [sp, #124]	@ 0x7c
10008ff6:	19de      	adds	r6, r3, r7
10008ff8:	e895 000f 	ldmia.w	r5, {r0, r1, r2, r3}
10008ffc:	e88a 000f 	stmia.w	sl, {r0, r1, r2, r3}
10009000:	e894 000f 	ldmia.w	r4, {r0, r1, r2, r3}
10009004:	e889 000f 	stmia.w	r9, {r0, r1, r2, r3}
10009008:	e89c 000f 	ldmia.w	ip, {r0, r1, r2, r3}
1000900c:	e888 000f 	stmia.w	r8, {r0, r1, r2, r3}
10009010:	e896 000f 	ldmia.w	r6, {r0, r1, r2, r3}
10009014:	ae36      	add	r6, sp, #216	@ 0xd8
10009016:	e886 000f 	stmia.w	r6, {r0, r1, r2, r3}
1000901a:	ed9d eb2a 	vldr	d14, [sp, #168]	@ 0xa8
1000901e:	ed9d 7b34 	vldr	d7, [sp, #208]	@ 0xd0
10009022:	ed9d 8b32 	vldr	d8, [sp, #200]	@ 0xc8
10009026:	ee27 9b0f 	vmul.f64	d9, d7, d15
1000902a:	eefc 7bce 	vcvt.u32.f64	s15, d14
1000902e:	ed9d 1b2e 	vldr	d1, [sp, #184]	@ 0xb8
10009032:	ee17 0a90 	vmov	r0, s15
10009036:	eefc 7bc8 	vcvt.u32.f64	s15, d8
1000903a:	ed9d ab36 	vldr	d10, [sp, #216]	@ 0xd8
1000903e:	ee17 2a90 	vmov	r2, s15
10009042:	eefc 7bc1 	vcvt.u32.f64	s15, d1
10009046:	ee17 1a90 	vmov	r1, s15
1000904a:	eefc 7bca 	vcvt.u32.f64	s15, d10
1000904e:	ee17 3a90 	vmov	r3, s15
10009052:	ed9d 7b2c 	vldr	d7, [sp, #176]	@ 0xb0
10009056:	0fc0      	lsrs	r0, r0, #31
10009058:	ee27 4b09 	vmul.f64	d4, d7, d9
1000905c:	ee07 0a90 	vmov	s15, r0
10009060:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10009064:	0fc9      	lsrs	r1, r1, #31
10009066:	ed8d 7b12 	vstr	d7, [sp, #72]	@ 0x48
1000906a:	ee07 1a90 	vmov	s15, r1
1000906e:	0fd2      	lsrs	r2, r2, #31
10009070:	eeb8 3be7 	vcvt.f64.s32	d3, s15
10009074:	ee07 2a90 	vmov	s15, r2
10009078:	0fdb      	lsrs	r3, r3, #31
1000907a:	eeb8 2be7 	vcvt.f64.s32	d2, s15
1000907e:	ee07 3a90 	vmov	s15, r3
10009082:	ee2e 9b09 	vmul.f64	d9, d14, d9
10009086:	eeb8 0be7 	vcvt.f64.s32	d0, s15
1000908a:	ed8d 3b16 	vstr	d3, [sp, #88]	@ 0x58
1000908e:	ed9d 7b34 	vldr	d7, [sp, #208]	@ 0xd0
10009092:	ed9d 3b38 	vldr	d3, [sp, #224]	@ 0xe0
10009096:	ed8d 0b18 	vstr	d0, [sp, #96]	@ 0x60
1000909a:	eebc 9bc9 	vcvt.u32.f64	s18, d9
1000909e:	ee37 0b03 	vadd.f64	d0, d7, d3
100090a2:	ed9d 7b2c 	vldr	d7, [sp, #176]	@ 0xb0
100090a6:	ed9d 3b30 	vldr	d3, [sp, #192]	@ 0xc0
100090aa:	ee28 6b0f 	vmul.f64	d6, d8, d15
100090ae:	ee37 db03 	vadd.f64	d13, d7, d3
100090b2:	eeb8 9b49 	vcvt.f64.u32	d9, s18
100090b6:	ed9d 3b2c 	vldr	d3, [sp, #176]	@ 0xb0
100090ba:	ed8d 9b08 	vstr	d9, [sp, #32]
100090be:	ee23 3b06 	vmul.f64	d3, d3, d6
100090c2:	ee20 9b0f 	vmul.f64	d9, d0, d15
100090c6:	eefc 3bc3 	vcvt.u32.f64	s7, d3
100090ca:	eebc 3bc9 	vcvt.u32.f64	s6, d9
100090ce:	ed9d 7b38 	vldr	d7, [sp, #224]	@ 0xe0
100090d2:	ee2e 6b06 	vmul.f64	d6, d14, d6
100090d6:	eeb8 9b63 	vcvt.f64.u32	d9, s7
100090da:	ed8d 2b14 	vstr	d2, [sp, #80]	@ 0x50
100090de:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100090e2:	ee38 2b0a 	vadd.f64	d2, d8, d10
100090e6:	ee27 5b0f 	vmul.f64	d5, d7, d15
100090ea:	ee32 2b03 	vadd.f64	d2, d2, d3
100090ee:	ee03 0b4c 	vmls.f64	d0, d3, d12
100090f2:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100090f6:	ed9d 3b30 	vldr	d3, [sp, #192]	@ 0xc0
100090fa:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100090fe:	ee23 3b05 	vmul.f64	d3, d3, d5
10009102:	ee25 5b01 	vmul.f64	d5, d5, d1
10009106:	ee26 6b4c 	vnmul.f64	d6, d6, d12
1000910a:	eeae 6b08 	vfma.f64	d6, d14, d8
1000910e:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10009112:	ee36 6b0c 	vadd.f64	d6, d6, d12
10009116:	ee2a 7b0f 	vmul.f64	d7, d10, d15
1000911a:	ed8d 9b00 	vstr	d9, [sp]
1000911e:	ed8d 6b0e 	vstr	d6, [sp, #56]	@ 0x38
10009122:	eeb0 9b40 	vmov.f64	d9, d0
10009126:	ee2d 6b0f 	vmul.f64	d6, d13, d15
1000912a:	ed9d 0b30 	vldr	d0, [sp, #192]	@ 0xc0
1000912e:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10009132:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10009136:	ed8d 5b0c 	vstr	d5, [sp, #48]	@ 0x30
1000913a:	ee20 5b07 	vmul.f64	d5, d0, d7
1000913e:	ee27 7b01 	vmul.f64	d7, d7, d1
10009142:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10009146:	ee3e 0b01 	vadd.f64	d0, d14, d1
1000914a:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000914e:	ee30 0b06 	vadd.f64	d0, d0, d6
10009152:	ee06 db4c 	vmls.f64	d13, d6, d12
10009156:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000915a:	ee22 6b0f 	vmul.f64	d6, d2, d15
1000915e:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10009162:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10009166:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000916a:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000916e:	ee27 7b4c 	vnmul.f64	d7, d7, d12
10009172:	eea1 7b0a 	vfma.f64	d7, d1, d10
10009176:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000917a:	ee37 7b0c 	vadd.f64	d7, d7, d12
1000917e:	ed8d db02 	vstr	d13, [sp, #8]
10009182:	ed8d 5b0a 	vstr	d5, [sp, #40]	@ 0x28
10009186:	ed9d db2c 	vldr	d13, [sp, #176]	@ 0xb0
1000918a:	ed9d 5b34 	vldr	d5, [sp, #208]	@ 0xd0
1000918e:	ed8d 7b10 	vstr	d7, [sp, #64]	@ 0x40
10009192:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10009196:	ee24 7b4c 	vnmul.f64	d7, d4, d12
1000919a:	eead 7b05 	vfma.f64	d7, d13, d5
1000919e:	ee37 7b0c 	vadd.f64	d7, d7, d12
100091a2:	ee06 2b4c 	vmls.f64	d2, d6, d12
100091a6:	ee27 7b0f 	vmul.f64	d7, d7, d15
100091aa:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100091ae:	eefc 7bc2 	vcvt.u32.f64	s15, d2
100091b2:	ee17 3a90 	vmov	r3, s15
100091b6:	0fdb      	lsrs	r3, r3, #31
100091b8:	ee07 3a90 	vmov	s15, r3
100091bc:	eeb8 5b47 	vcvt.f64.u32	d5, s14
100091c0:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100091c4:	ee35 5b04 	vadd.f64	d5, d5, d4
100091c8:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100091cc:	eeb8 4be7 	vcvt.f64.s32	d4, s15
100091d0:	ed8d 2b04 	vstr	d2, [sp, #16]
100091d4:	ee23 7b4c 	vnmul.f64	d7, d3, d12
100091d8:	ed9d 2b30 	vldr	d2, [sp, #192]	@ 0xc0
100091dc:	ed8d 4b1c 	vstr	d4, [sp, #112]	@ 0x70
100091e0:	ed9d 4b38 	vldr	d4, [sp, #224]	@ 0xe0
100091e4:	eea2 7b04 	vfma.f64	d7, d2, d4
100091e8:	ee20 4b0f 	vmul.f64	d4, d0, d15
100091ec:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100091f0:	ee37 6b0c 	vadd.f64	d6, d7, d12
100091f4:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100091f8:	eeb0 7b40 	vmov.f64	d7, d0
100091fc:	ee04 7b4c 	vmls.f64	d7, d4, d12
10009200:	ed9d db00 	vldr	d13, [sp]
10009204:	ed8d 7b00 	vstr	d7, [sp]
10009208:	eefc 7bc7 	vcvt.u32.f64	s15, d7
1000920c:	ee26 6b0f 	vmul.f64	d6, d6, d15
10009210:	ee17 3a90 	vmov	r3, s15
10009214:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10009218:	0fdb      	lsrs	r3, r3, #31
1000921a:	ee07 3a90 	vmov	s15, r3
1000921e:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10009222:	ed8d 9b06 	vstr	d9, [sp, #24]
10009226:	ee29 2b0f 	vmul.f64	d2, d9, d15
1000922a:	ed9d 4b2c 	vldr	d4, [sp, #176]	@ 0xb0
1000922e:	ed9d 0b08 	vldr	d0, [sp, #32]
10009232:	ee36 6b03 	vadd.f64	d6, d6, d3
10009236:	ee2d 9b4c 	vnmul.f64	d9, d13, d12
1000923a:	eea4 9b08 	vfma.f64	d9, d4, d8
1000923e:	ed9d 3b0a 	vldr	d3, [sp, #40]	@ 0x28
10009242:	eeb8 8be7 	vcvt.f64.s32	d8, s15
10009246:	ed9d 4b30 	vldr	d4, [sp, #192]	@ 0xc0
1000924a:	ed8d 8b1a 	vstr	d8, [sp, #104]	@ 0x68
1000924e:	ee20 7b4c 	vnmul.f64	d7, d0, d12
10009252:	ee23 8b4c 	vnmul.f64	d8, d3, d12
10009256:	eea4 8b0a 	vfma.f64	d8, d4, d10
1000925a:	ed9d 4b04 	vldr	d4, [sp, #16]
1000925e:	ed9d ab34 	vldr	d10, [sp, #208]	@ 0xd0
10009262:	eeae 7b0a 	vfma.f64	d7, d14, d10
10009266:	ed9d eb0c 	vldr	d14, [sp, #48]	@ 0x30
1000926a:	ee24 3b0f 	vmul.f64	d3, d4, d15
1000926e:	ed9d ab38 	vldr	d10, [sp, #224]	@ 0xe0
10009272:	ee2e 4b4c 	vnmul.f64	d4, d14, d12
10009276:	eea1 4b0a 	vfma.f64	d4, d1, d10
1000927a:	ed9d ab00 	vldr	d10, [sp]
1000927e:	ed9d 1b02 	vldr	d1, [sp, #8]
10009282:	ee21 0b02 	vmul.f64	d0, d1, d2
10009286:	ee2a 2b02 	vmul.f64	d2, d10, d2
1000928a:	ee39 9b0c 	vadd.f64	d9, d9, d12
1000928e:	ee38 8b0c 	vadd.f64	d8, d8, d12
10009292:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10009296:	ee29 1b0f 	vmul.f64	d1, d9, d15
1000929a:	eeb8 eb42 	vcvt.f64.u32	d14, s4
1000929e:	ee28 2b0f 	vmul.f64	d2, d8, d15
100092a2:	eebc 1bc1 	vcvt.u32.f64	s2, d1
100092a6:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100092aa:	eeb8 1b41 	vcvt.f64.u32	d1, s2
100092ae:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100092b2:	ee01 9b4c 	vmls.f64	d9, d1, d12
100092b6:	ee02 8b4c 	vmls.f64	d8, d2, d12
100092ba:	ee35 5b4b 	vsub.f64	d5, d5, d11
100092be:	ee36 6b4b 	vsub.f64	d6, d6, d11
100092c2:	ee35 5b09 	vadd.f64	d5, d5, d9
100092c6:	ee36 6b08 	vadd.f64	d6, d6, d8
100092ca:	ed9d 9b0a 	vldr	d9, [sp, #40]	@ 0x28
100092ce:	ee37 7b0c 	vadd.f64	d7, d7, d12
100092d2:	ed9d 8b02 	vldr	d8, [sp, #8]
100092d6:	ee39 2b02 	vadd.f64	d2, d9, d2
100092da:	ee28 8b03 	vmul.f64	d8, d8, d3
100092de:	ee27 9b0f 	vmul.f64	d9, d7, d15
100092e2:	eefc 8bc8 	vcvt.u32.f64	s17, d8
100092e6:	eebc 8bc9 	vcvt.u32.f64	s16, d9
100092ea:	ee2a 3b03 	vmul.f64	d3, d10, d3
100092ee:	eeb8 9b68 	vcvt.f64.u32	d9, s17
100092f2:	ee3d 1b01 	vadd.f64	d1, d13, d1
100092f6:	eeb8 8b48 	vcvt.f64.u32	d8, s16
100092fa:	ed9d db08 	vldr	d13, [sp, #32]
100092fe:	ee08 7b4c 	vmls.f64	d7, d8, d12
10009302:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10009306:	ee3d 8b08 	vadd.f64	d8, d13, d8
1000930a:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000930e:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10009312:	ee34 4b0c 	vadd.f64	d4, d4, d12
10009316:	ee31 1b4b 	vsub.f64	d1, d1, d11
1000931a:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000931e:	ee38 8b4b 	vsub.f64	d8, d8, d11
10009322:	ee35 7b07 	vadd.f64	d7, d5, d7
10009326:	ee31 8b08 	vadd.f64	d8, d1, d8
1000932a:	ed9d 5b04 	vldr	d5, [sp, #16]
1000932e:	ed9d 1b06 	vldr	d1, [sp, #24]
10009332:	ed9d db02 	vldr	d13, [sp, #8]
10009336:	ee23 3b4c 	vnmul.f64	d3, d3, d12
1000933a:	eeaa 3b05 	vfma.f64	d3, d10, d5
1000933e:	ee20 5b4c 	vnmul.f64	d5, d0, d12
10009342:	eead 5b01 	vfma.f64	d5, d13, d1
10009346:	ee33 ab0c 	vadd.f64	d10, d3, d12
1000934a:	ee35 5b0c 	vadd.f64	d5, d5, d12
1000934e:	ee24 3b0f 	vmul.f64	d3, d4, d15
10009352:	ee25 5b0f 	vmul.f64	d5, d5, d15
10009356:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000935a:	ed9d db0c 	vldr	d13, [sp, #48]	@ 0x30
1000935e:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10009362:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10009366:	ee03 4b4c 	vmls.f64	d4, d3, d12
1000936a:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000936e:	ee3d 3b03 	vadd.f64	d3, d13, d3
10009372:	ee36 4b04 	vadd.f64	d4, d6, d4
10009376:	ee33 3b4b 	vsub.f64	d3, d3, d11
1000937a:	ed9d 6b04 	vldr	d6, [sp, #16]
1000937e:	ee35 5b00 	vadd.f64	d5, d5, d0
10009382:	ee29 1b4c 	vnmul.f64	d1, d9, d12
10009386:	ed9d 0b02 	vldr	d0, [sp, #8]
1000938a:	eea0 1b06 	vfma.f64	d1, d0, d6
1000938e:	ee32 2b4b 	vsub.f64	d2, d2, d11
10009392:	ed9d 6b0e 	vldr	d6, [sp, #56]	@ 0x38
10009396:	ed9d db10 	vldr	d13, [sp, #64]	@ 0x40
1000939a:	ee32 2b03 	vadd.f64	d2, d2, d3
1000939e:	ee26 3b0f 	vmul.f64	d3, d6, d15
100093a2:	ee2d 0b0f 	vmul.f64	d0, d13, d15
100093a6:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100093aa:	eebc 0bc0 	vcvt.u32.f64	s0, d0
100093ae:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100093b2:	eeb8 0b40 	vcvt.f64.u32	d0, s0
100093b6:	ee03 6b4c 	vmls.f64	d6, d3, d12
100093ba:	eeb0 3b4d 	vmov.f64	d3, d13
100093be:	ee31 1b0c 	vadd.f64	d1, d1, d12
100093c2:	ee00 3b4c 	vmls.f64	d3, d0, d12
100093c6:	ee36 6b08 	vadd.f64	d6, d6, d8
100093ca:	ed9d 0b00 	vldr	d0, [sp]
100093ce:	ed9d 8b06 	vldr	d8, [sp, #24]
100093d2:	ee33 3b02 	vadd.f64	d3, d3, d2
100093d6:	ee2e 2b4c 	vnmul.f64	d2, d14, d12
100093da:	eea0 2b08 	vfma.f64	d2, d0, d8
100093de:	ee21 0b0f 	vmul.f64	d0, d1, d15
100093e2:	ee27 8b0f 	vmul.f64	d8, d7, d15
100093e6:	eebc 0bc0 	vcvt.u32.f64	s0, d0
100093ea:	eebc 8bc8 	vcvt.u32.f64	s16, d8
100093ee:	eeb8 0b40 	vcvt.f64.u32	d0, s0
100093f2:	eeb8 8b48 	vcvt.f64.u32	d8, s16
100093f6:	ee35 5b4b 	vsub.f64	d5, d5, d11
100093fa:	ee00 1b4c 	vmls.f64	d1, d0, d12
100093fe:	ee36 6b08 	vadd.f64	d6, d6, d8
10009402:	ee39 0b00 	vadd.f64	d0, d9, d0
10009406:	ed9f 9b72 	vldr	d9, [pc, #456]	@ 100095d0 <fndsa_vect_mul_fft_fp64_exact+0x648>
1000940a:	ee35 1b01 	vadd.f64	d1, d5, d1
1000940e:	ed9d db34 	vldr	d13, [sp, #208]	@ 0xd0
10009412:	ed9d 5b12 	vldr	d5, [sp, #72]	@ 0x48
10009416:	ee36 6b09 	vadd.f64	d6, d6, d9
1000941a:	ee05 6b4d 	vmls.f64	d6, d5, d13
1000941e:	ed9d db14 	vldr	d13, [sp, #80]	@ 0x50
10009422:	ed9d 5b2c 	vldr	d5, [sp, #176]	@ 0xb0
10009426:	ee0d 6b45 	vmls.f64	d6, d13, d5
1000942a:	ee24 5b0f 	vmul.f64	d5, d4, d15
1000942e:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10009432:	ee32 2b0c 	vadd.f64	d2, d2, d12
10009436:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000943a:	ee08 7b4c 	vmls.f64	d7, d8, d12
1000943e:	ee33 3b05 	vadd.f64	d3, d3, d5
10009442:	ee22 8b0f 	vmul.f64	d8, d2, d15
10009446:	ee05 4b4c 	vmls.f64	d4, d5, d12
1000944a:	eebc 8bc8 	vcvt.u32.f64	s16, d8
1000944e:	ed9d 5b16 	vldr	d5, [sp, #88]	@ 0x58
10009452:	ee33 3b09 	vadd.f64	d3, d3, d9
10009456:	ed9d db38 	vldr	d13, [sp, #224]	@ 0xe0
1000945a:	eeb8 8b48 	vcvt.f64.u32	d8, s16
1000945e:	ee05 3b4d 	vmls.f64	d3, d5, d13
10009462:	ed9d 5b18 	vldr	d5, [sp, #96]	@ 0x60
10009466:	ed9d db30 	vldr	d13, [sp, #192]	@ 0xc0
1000946a:	ee08 2b4c 	vmls.f64	d2, d8, d12
1000946e:	ee05 3b4d 	vmls.f64	d3, d5, d13
10009472:	ee2a 5b0f 	vmul.f64	d5, d10, d15
10009476:	ee3e eb08 	vadd.f64	d14, d14, d8
1000947a:	ee31 2b02 	vadd.f64	d2, d1, d2
1000947e:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10009482:	ee22 1b0f 	vmul.f64	d1, d2, d15
10009486:	ee30 0b4b 	vsub.f64	d0, d0, d11
1000948a:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000948e:	ee3e eb4b 	vsub.f64	d14, d14, d11
10009492:	ee05 ab4c 	vmls.f64	d10, d5, d12
10009496:	ee30 eb0e 	vadd.f64	d14, d0, d14
1000949a:	eebc 1bc1 	vcvt.u32.f64	s2, d1
1000949e:	ee3a ab0e 	vadd.f64	d10, d10, d14
100094a2:	eeb8 1b41 	vcvt.f64.u32	d1, s2
100094a6:	ee3a ab01 	vadd.f64	d10, d10, d1
100094aa:	ed9d 5b1a 	vldr	d5, [sp, #104]	@ 0x68
100094ae:	ee3a ab09 	vadd.f64	d10, d10, d9
100094b2:	ed9d 8b06 	vldr	d8, [sp, #24]
100094b6:	ee05 ab48 	vmls.f64	d10, d5, d8
100094ba:	ee37 5b04 	vadd.f64	d5, d7, d4
100094be:	ee37 7b0c 	vadd.f64	d7, d7, d12
100094c2:	ee01 2b4c 	vmls.f64	d2, d1, d12
100094c6:	ee37 7b44 	vsub.f64	d7, d7, d4
100094ca:	ed9d 1b1c 	vldr	d1, [sp, #112]	@ 0x70
100094ce:	ed9d 0b02 	vldr	d0, [sp, #8]
100094d2:	ee01 ab40 	vmls.f64	d10, d1, d0
100094d6:	ee27 1b0f 	vmul.f64	d1, d7, d15
100094da:	eebc 1bc1 	vcvt.u32.f64	s2, d1
100094de:	eeb8 1b41 	vcvt.f64.u32	d1, s2
100094e2:	ee01 7b4c 	vmls.f64	d7, d1, d12
100094e6:	ed8d 7b24 	vstr	d7, [sp, #144]	@ 0x90
100094ea:	ee26 7b0f 	vmul.f64	d7, d6, d15
100094ee:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100094f2:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100094f6:	ee07 6b4c 	vmls.f64	d6, d7, d12
100094fa:	ee23 7b0f 	vmul.f64	d7, d3, d15
100094fe:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10009502:	ee25 0b0f 	vmul.f64	d0, d5, d15
10009506:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000950a:	eebc 0bc0 	vcvt.u32.f64	s0, d0
1000950e:	ee07 3b4c 	vmls.f64	d3, d7, d12
10009512:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10009516:	ee36 7b0c 	vadd.f64	d7, d6, d12
1000951a:	ee36 6b03 	vadd.f64	d6, d6, d3
1000951e:	ee2a 4b0f 	vmul.f64	d4, d10, d15
10009522:	ee36 6b00 	vadd.f64	d6, d6, d0
10009526:	ee37 3b43 	vsub.f64	d3, d7, d3
1000952a:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000952e:	ee26 7b0f 	vmul.f64	d7, d6, d15
10009532:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10009536:	ee32 2b0c 	vadd.f64	d2, d2, d12
1000953a:	ee00 5b4c 	vmls.f64	d5, d0, d12
1000953e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10009542:	ee04 ab4c 	vmls.f64	d10, d4, d12
10009546:	ee32 5b45 	vsub.f64	d5, d2, d5
1000954a:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000954e:	ee25 4b0f 	vmul.f64	d4, d5, d15
10009552:	ee07 6b4c 	vmls.f64	d6, d7, d12
10009556:	ee3a ab0c 	vadd.f64	d10, d10, d12
1000955a:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000955e:	ee3a 7b46 	vsub.f64	d7, d10, d6
10009562:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10009566:	ee33 3b4b 	vsub.f64	d3, d3, d11
1000956a:	ee37 7b4b 	vsub.f64	d7, d7, d11
1000956e:	ee04 5b4c 	vmls.f64	d5, d4, d12
10009572:	ee33 3b01 	vadd.f64	d3, d3, d1
10009576:	ee37 7b04 	vadd.f64	d7, d7, d4
1000957a:	ed8d 5b28 	vstr	d5, [sp, #160]	@ 0xa0
1000957e:	ee27 6b0f 	vmul.f64	d6, d7, d15
10009582:	ee23 5b0f 	vmul.f64	d5, d3, d15
10009586:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000958a:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000958e:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10009592:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10009596:	ee06 7b4c 	vmls.f64	d7, d6, d12
1000959a:	ee05 3b4c 	vmls.f64	d3, d5, d12
1000959e:	ed8d 7b26 	vstr	d7, [sp, #152]	@ 0x98
100095a2:	ed8d 3b22 	vstr	d3, [sp, #136]	@ 0x88
100095a6:	ab22      	add	r3, sp, #136	@ 0x88
100095a8:	cb0f      	ldmia	r3, {r0, r1, r2, r3}
100095aa:	e885 000f 	stmia.w	r5, {r0, r1, r2, r3}
100095ae:	ab26      	add	r3, sp, #152	@ 0x98
100095b0:	cb0f      	ldmia	r3, {r0, r1, r2, r3}
100095b2:	3710      	adds	r7, #16
100095b4:	e884 000f 	stmia.w	r4, {r0, r1, r2, r3}
100095b8:	f1be 0e01 	subs.w	lr, lr, #1
100095bc:	f47f ad14 	bne.w	10008fe8 <fndsa_vect_mul_fft_fp64_exact+0x60>
100095c0:	b03b      	add	sp, #236	@ 0xec
100095c2:	ecbd 8b10 	vpop	{d8-d15}
100095c6:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
100095ca:	bf00      	nop
100095cc:	f3af 8000 	nop.w
100095d0:	00000000 	.word	0x00000000
100095d4:	42000000 	.word	0x42000000

