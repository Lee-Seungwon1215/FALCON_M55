
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/kat/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

100061f0 <fndsa_vect_mul_fft_fp64_exact>:
100061f0:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
100061f4:	f04f 0a10 	mov.w	sl, #16
100061f8:	ed2d 8b10 	vpush	{d8-d15}
100061fc:	3801      	subs	r0, #1
100061fe:	fa0a fa00 	lsl.w	sl, sl, r0
10006202:	f1aa 0e10 	sub.w	lr, sl, #16
10006206:	ea4f 1e1e 	mov.w	lr, lr, lsr #4
1000620a:	b0b9      	sub	sp, #228	@ 0xe4
1000620c:	eb01 0b0a 	add.w	fp, r1, sl
10006210:	f10e 0e01 	add.w	lr, lr, #1
10006214:	4492      	add	sl, r2
10006216:	e9cd ab1e 	strd	sl, fp, [sp, #120]	@ 0x78
1000621a:	2700      	movs	r7, #0
1000621c:	ed9f 0bf8 	vldr	d0, [pc, #992]	@ 10006600 <fndsa_vect_mul_fft_fp64_exact+0x410>
10006220:	ed9f 9bf9 	vldr	d9, [pc, #996]	@ 10006608 <fndsa_vect_mul_fft_fp64_exact+0x418>
10006224:	ed9f dbfa 	vldr	d13, [pc, #1000]	@ 10006610 <fndsa_vect_mul_fft_fp64_exact+0x420>
10006228:	ed9f bbfb 	vldr	d11, [pc, #1004]	@ 10006618 <fndsa_vect_mul_fft_fp64_exact+0x428>
1000622c:	f04e e001 	dls	lr, lr
10006230:	ed9f abfb 	vldr	d10, [pc, #1004]	@ 10006620 <fndsa_vect_mul_fft_fp64_exact+0x430>
10006234:	468a      	mov	sl, r1
10006236:	4693      	mov	fp, r2
10006238:	f10d 09a0 	add.w	r9, sp, #160	@ 0xa0
1000623c:	f10d 08b0 	add.w	r8, sp, #176	@ 0xb0
10006240:	9b1f      	ldr	r3, [sp, #124]	@ 0x7c
10006242:	eb0a 0507 	add.w	r5, sl, r7
10006246:	19dc      	adds	r4, r3, r7
10006248:	9b1e      	ldr	r3, [sp, #120]	@ 0x78
1000624a:	eb0b 0c07 	add.w	ip, fp, r7
1000624e:	19de      	adds	r6, r3, r7
10006250:	e895 000f 	ldmia.w	r5, {r0, r1, r2, r3}
10006254:	e889 000f 	stmia.w	r9, {r0, r1, r2, r3}
10006258:	e894 000f 	ldmia.w	r4, {r0, r1, r2, r3}
1000625c:	e888 000f 	stmia.w	r8, {r0, r1, r2, r3}
10006260:	e89c 000f 	ldmia.w	ip, {r0, r1, r2, r3}
10006264:	f10d 0cc0 	add.w	ip, sp, #192	@ 0xc0
10006268:	e88c 000f 	stmia.w	ip, {r0, r1, r2, r3}
1000626c:	e896 000f 	ldmia.w	r6, {r0, r1, r2, r3}
10006270:	ae34      	add	r6, sp, #208	@ 0xd0
10006272:	e886 000f 	stmia.w	r6, {r0, r1, r2, r3}
10006276:	ed9d 3b28 	vldr	d3, [sp, #160]	@ 0xa0
1000627a:	ed9d eb2c 	vldr	d14, [sp, #176]	@ 0xb0
1000627e:	eefc 7bc3 	vcvt.u32.f64	s15, d3
10006282:	ed9d 4b30 	vldr	d4, [sp, #192]	@ 0xc0
10006286:	ee17 1a90 	vmov	r1, s15
1000628a:	eefc 7bce 	vcvt.u32.f64	s15, d14
1000628e:	ee17 2a90 	vmov	r2, s15
10006292:	eefc 7bc4 	vcvt.u32.f64	s15, d4
10006296:	0fc9      	lsrs	r1, r1, #31
10006298:	ee17 3a90 	vmov	r3, s15
1000629c:	ee07 1a90 	vmov	s15, r1
100062a0:	eeb8 7be7 	vcvt.f64.s32	d7, s15
100062a4:	0fd2      	lsrs	r2, r2, #31
100062a6:	ed8d 7b10 	vstr	d7, [sp, #64]	@ 0x40
100062aa:	ee07 2a90 	vmov	s15, r2
100062ae:	0fdb      	lsrs	r3, r3, #31
100062b0:	eeb8 6be7 	vcvt.f64.s32	d6, s15
100062b4:	ed9d fb2e 	vldr	d15, [sp, #184]	@ 0xb8
100062b8:	ee07 3a90 	vmov	s15, r3
100062bc:	ed9d 8b2a 	vldr	d8, [sp, #168]	@ 0xa8
100062c0:	ed9d 5b34 	vldr	d5, [sp, #208]	@ 0xd0
100062c4:	eeb8 2be7 	vcvt.f64.s32	d2, s15
100062c8:	ee38 8b0f 	vadd.f64	d8, d8, d15
100062cc:	ed9d 7b36 	vldr	d7, [sp, #216]	@ 0xd8
100062d0:	ed9d fb32 	vldr	d15, [sp, #200]	@ 0xc8
100062d4:	ed8d 2b12 	vstr	d2, [sp, #72]	@ 0x48
100062d8:	ee3f 2b07 	vadd.f64	d2, d15, d7
100062dc:	eefc 7bc5 	vcvt.u32.f64	s15, d5
100062e0:	ee17 3a90 	vmov	r3, s15
100062e4:	0fdb      	lsrs	r3, r3, #31
100062e6:	ee07 3a90 	vmov	s15, r3
100062ea:	ed8d 6b18 	vstr	d6, [sp, #96]	@ 0x60
100062ee:	ee28 6b0b 	vmul.f64	d6, d8, d11
100062f2:	eeb8 fbe7 	vcvt.f64.s32	d15, s15
100062f6:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100062fa:	ee22 7b0b 	vmul.f64	d7, d2, d11
100062fe:	ed8d fb1a 	vstr	d15, [sp, #104]	@ 0x68
10006302:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006306:	eeb0 fb42 	vmov.f64	d15, d2
1000630a:	ee33 2b0e 	vadd.f64	d2, d3, d14
1000630e:	ee06 8b4a 	vmls.f64	d8, d6, d10
10006312:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006316:	ee32 6b06 	vadd.f64	d6, d2, d6
1000631a:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000631e:	ed8d 6b08 	vstr	d6, [sp, #32]
10006322:	ee34 6b05 	vadd.f64	d6, d4, d5
10006326:	ed9f 1bc2 	vldr	d1, [pc, #776]	@ 10006630 <fndsa_vect_mul_fft_fp64_exact+0x440>
1000632a:	ee07 fb4a 	vmls.f64	d15, d7, d10
1000632e:	ee36 7b07 	vadd.f64	d7, d6, d7
10006332:	ed8d 7b0a 	vstr	d7, [sp, #40]	@ 0x28
10006336:	ee23 7b01 	vmul.f64	d7, d3, d1
1000633a:	eefc 6bc7 	vcvt.u32.f64	s13, d7
1000633e:	ee24 7b01 	vmul.f64	d7, d4, d1
10006342:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10006346:	ed8d 8b00 	vstr	d8, [sp]
1000634a:	eeb8 8b67 	vcvt.f64.u32	d8, s15
1000634e:	ee2e 7b01 	vmul.f64	d7, d14, d1
10006352:	ee08 4b4d 	vmls.f64	d4, d8, d13
10006356:	eeb0 2b44 	vmov.f64	d2, d4
1000635a:	eefc 4bc7 	vcvt.u32.f64	s9, d7
1000635e:	ed8d fb02 	vstr	d15, [sp, #8]
10006362:	ee25 7b01 	vmul.f64	d7, d5, d1
10006366:	eeb8 fb66 	vcvt.f64.u32	d15, s13
1000636a:	eeb8 6b64 	vcvt.f64.u32	d6, s9
1000636e:	ed9d 4b2a 	vldr	d4, [sp, #168]	@ 0xa8
10006372:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10006376:	ee24 4b00 	vmul.f64	d4, d4, d0
1000637a:	eeb8 cb67 	vcvt.f64.u32	d12, s15
1000637e:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10006382:	ee0c 5b4d 	vmls.f64	d5, d12, d13
10006386:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000638a:	ed9d 7b32 	vldr	d7, [sp, #200]	@ 0xc8
1000638e:	ee0f 3b4d 	vmls.f64	d3, d15, d13
10006392:	ed9f 1ba9 	vldr	d1, [pc, #676]	@ 10006638 <fndsa_vect_mul_fft_fp64_exact+0x448>
10006396:	ed8d 5b16 	vstr	d5, [sp, #88]	@ 0x58
1000639a:	ee27 7b00 	vmul.f64	d7, d7, d0
1000639e:	eeb0 5b44 	vmov.f64	d5, d4
100063a2:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100063a6:	ee03 5b01 	vmla.f64	d5, d3, d1
100063aa:	ed9d 3b2a 	vldr	d3, [sp, #168]	@ 0xa8
100063ae:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100063b2:	ee04 3b49 	vmls.f64	d3, d4, d9
100063b6:	ee06 eb4d 	vmls.f64	d14, d6, d13
100063ba:	ed8d 6b06 	vstr	d6, [sp, #24]
100063be:	ed9d 4b32 	vldr	d4, [sp, #200]	@ 0xc8
100063c2:	eeb0 6b43 	vmov.f64	d6, d3
100063c6:	eeb0 3b47 	vmov.f64	d3, d7
100063ca:	ed8d eb14 	vstr	d14, [sp, #80]	@ 0x50
100063ce:	ee02 3b01 	vmla.f64	d3, d2, d1
100063d2:	ee07 4b49 	vmls.f64	d4, d7, d9
100063d6:	ee26 7b04 	vmul.f64	d7, d6, d4
100063da:	ee26 2b03 	vmul.f64	d2, d6, d3
100063de:	ee26 1b08 	vmul.f64	d1, d6, d8
100063e2:	ee25 eb08 	vmul.f64	d14, d5, d8
100063e6:	ee05 2b04 	vmla.f64	d2, d5, d4
100063ea:	ee05 1b03 	vmla.f64	d1, d5, d3
100063ee:	ee0f eb03 	vmla.f64	d14, d15, d3
100063f2:	ee0f 1b04 	vmla.f64	d1, d15, d4
100063f6:	ed9d 3b2e 	vldr	d3, [sp, #184]	@ 0xb8
100063fa:	ee27 7b00 	vmul.f64	d7, d7, d0
100063fe:	ee23 6b00 	vmul.f64	d6, d3, d0
10006402:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006406:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000640a:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000640e:	ed9d fb08 	vldr	d15, [sp, #32]
10006412:	ee37 3b02 	vadd.f64	d3, d7, d2
10006416:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000641a:	ed9d 4b36 	vldr	d4, [sp, #216]	@ 0xd8
1000641e:	ed9d 7b2e 	vldr	d7, [sp, #184]	@ 0xb8
10006422:	ee2f 8b0b 	vmul.f64	d8, d15, d11
10006426:	ee06 7b49 	vmls.f64	d7, d6, d9
1000642a:	ed8d 3b04 	vstr	d3, [sp, #16]
1000642e:	eeb0 3b46 	vmov.f64	d3, d6
10006432:	ee24 6b00 	vmul.f64	d6, d4, d0
10006436:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000643a:	eefc 6bc8 	vcvt.u32.f64	s13, d8
1000643e:	ed9d 5b14 	vldr	d5, [sp, #80]	@ 0x50
10006442:	ed9f 2b7d 	vldr	d2, [pc, #500]	@ 10006638 <fndsa_vect_mul_fft_fp64_exact+0x448>
10006446:	ed8d eb0e 	vstr	d14, [sp, #56]	@ 0x38
1000644a:	ed8d 1b0c 	vstr	d1, [sp, #48]	@ 0x30
1000644e:	edcd 6a1c 	vstr	s13, [sp, #112]	@ 0x70
10006452:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006456:	ee05 3b02 	vmla.f64	d3, d5, d2
1000645a:	eeb0 4b46 	vmov.f64	d4, d6
1000645e:	ed9d 5b16 	vldr	d5, [sp, #88]	@ 0x58
10006462:	ee05 4b02 	vmla.f64	d4, d5, d2
10006466:	ed9d 5b36 	vldr	d5, [sp, #216]	@ 0xd8
1000646a:	ed9d 8b06 	vldr	d8, [sp, #24]
1000646e:	ee06 5b49 	vmls.f64	d5, d6, d9
10006472:	ee27 6b05 	vmul.f64	d6, d7, d5
10006476:	ee27 2b04 	vmul.f64	d2, d7, d4
1000647a:	ee27 eb0c 	vmul.f64	d14, d7, d12
1000647e:	ee23 1b0c 	vmul.f64	d1, d3, d12
10006482:	ee03 2b05 	vmla.f64	d2, d3, d5
10006486:	ee03 eb04 	vmla.f64	d14, d3, d4
1000648a:	ee08 1b04 	vmla.f64	d1, d8, d4
1000648e:	ee08 eb05 	vmla.f64	d14, d8, d5
10006492:	ee26 6b00 	vmul.f64	d6, d6, d0
10006496:	eddd 7a1c 	vldr	s15, [sp, #112]	@ 0x70
1000649a:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000649e:	eeb8 8b67 	vcvt.f64.u32	d8, s15
100064a2:	eeb0 3b4f 	vmov.f64	d3, d15
100064a6:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100064aa:	ee08 3b4a 	vmls.f64	d3, d8, d10
100064ae:	ee36 7b02 	vadd.f64	d7, d6, d2
100064b2:	ed8d 7b06 	vstr	d7, [sp, #24]
100064b6:	eefc 7bc3 	vcvt.u32.f64	s15, d3
100064ba:	ee17 3a90 	vmov	r3, s15
100064be:	0fdb      	lsrs	r3, r3, #31
100064c0:	ed9d 4b0a 	vldr	d4, [sp, #40]	@ 0x28
100064c4:	ee07 3a90 	vmov	s15, r3
100064c8:	eeb8 6be7 	vcvt.f64.s32	d6, s15
100064cc:	ee24 7b0b 	vmul.f64	d7, d4, d11
100064d0:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100064d4:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100064d8:	ee07 4b4a 	vmls.f64	d4, d7, d10
100064dc:	eefc 7bc4 	vcvt.u32.f64	s15, d4
100064e0:	ee17 3a90 	vmov	r3, s15
100064e4:	0fdb      	lsrs	r3, r3, #31
100064e6:	ee07 3a90 	vmov	s15, r3
100064ea:	ed9d 2b00 	vldr	d2, [sp]
100064ee:	ed8d 6b16 	vstr	d6, [sp, #88]	@ 0x58
100064f2:	eeb8 7be7 	vcvt.f64.s32	d7, s15
100064f6:	ed9f 6b4e 	vldr	d6, [pc, #312]	@ 10006630 <fndsa_vect_mul_fft_fp64_exact+0x440>
100064fa:	ed8d 7b1c 	vstr	d7, [sp, #112]	@ 0x70
100064fe:	ee23 5b06 	vmul.f64	d5, d3, d6
10006502:	ee22 7b00 	vmul.f64	d7, d2, d0
10006506:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000650a:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000650e:	eeb8 8b45 	vcvt.f64.u32	d8, s10
10006512:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006516:	ed8d 1b14 	vstr	d1, [sp, #80]	@ 0x50
1000651a:	ee08 3b4d 	vmls.f64	d3, d8, d13
1000651e:	ed9f cb46 	vldr	d12, [pc, #280]	@ 10006638 <fndsa_vect_mul_fft_fp64_exact+0x448>
10006522:	eeb0 1b47 	vmov.f64	d1, d7
10006526:	ed8d eb08 	vstr	d14, [sp, #32]
1000652a:	ee03 1b0c 	vmla.f64	d1, d3, d12
1000652e:	ed9d eb02 	vldr	d14, [sp, #8]
10006532:	eeb0 3b42 	vmov.f64	d3, d2
10006536:	ee24 5b06 	vmul.f64	d5, d4, d6
1000653a:	ee07 3b49 	vmls.f64	d3, d7, d9
1000653e:	ee2e 7b00 	vmul.f64	d7, d14, d0
10006542:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10006546:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000654a:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000654e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006552:	ee05 4b4d 	vmls.f64	d4, d5, d13
10006556:	eeb0 fb47 	vmov.f64	d15, d7
1000655a:	eeb0 2b43 	vmov.f64	d2, d3
1000655e:	ee04 fb0c 	vmla.f64	d15, d4, d12
10006562:	ed9d 3b04 	vldr	d3, [sp, #16]
10006566:	eeb0 cb4f 	vmov.f64	d12, d15
1000656a:	ee23 3b00 	vmul.f64	d3, d3, d0
1000656e:	eeb0 4b4e 	vmov.f64	d4, d14
10006572:	eeb0 fb42 	vmov.f64	d15, d2
10006576:	ee07 4b49 	vmls.f64	d4, d7, d9
1000657a:	eeb0 6b4c 	vmov.f64	d6, d12
1000657e:	ee2f 7b04 	vmul.f64	d7, d15, d4
10006582:	ee2f 2b06 	vmul.f64	d2, d15, d6
10006586:	ee2f eb05 	vmul.f64	d14, d15, d5
1000658a:	ee21 cb05 	vmul.f64	d12, d1, d5
1000658e:	ee01 2b04 	vmla.f64	d2, d1, d4
10006592:	ee01 eb06 	vmla.f64	d14, d1, d6
10006596:	ee08 cb06 	vmla.f64	d12, d8, d6
1000659a:	ee08 eb04 	vmla.f64	d14, d8, d4
1000659e:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100065a2:	ee27 7b00 	vmul.f64	d7, d7, d0
100065a6:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100065aa:	ed9d 8b0c 	vldr	d8, [sp, #48]	@ 0x30
100065ae:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100065b2:	ee38 5b03 	vadd.f64	d5, d8, d3
100065b6:	ed9d fb04 	vldr	d15, [sp, #16]
100065ba:	ed9d 6b06 	vldr	d6, [sp, #24]
100065be:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100065c2:	ee03 fb49 	vmls.f64	d15, d3, d9
100065c6:	ee37 7b02 	vadd.f64	d7, d7, d2
100065ca:	ee25 3b00 	vmul.f64	d3, d5, d0
100065ce:	ee26 2b00 	vmul.f64	d2, d6, d0
100065d2:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100065d6:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100065da:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100065de:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100065e2:	eeb0 4b4f 	vmov.f64	d4, d15
100065e6:	ed9d 8b08 	vldr	d8, [sp, #32]
100065ea:	ed9f fb0f 	vldr	d15, [pc, #60]	@ 10006628 <fndsa_vect_mul_fft_fp64_exact+0x438>
100065ee:	ee38 8b02 	vadd.f64	d8, d8, d2
100065f2:	ee24 4b0f 	vmul.f64	d4, d4, d15
100065f6:	ee03 5b49 	vmls.f64	d5, d3, d9
100065fa:	ee02 6b49 	vmls.f64	d6, d2, d9
100065fe:	e023      	b.n	10006648 <fndsa_vect_mul_fft_fp64_exact+0x458>
10006600:	00000000 	.word	0x00000000
10006604:	3e700000 	.word	0x3e700000
10006608:	00000000 	.word	0x00000000
1000660c:	41700000 	.word	0x41700000
10006610:	00000000 	.word	0x00000000
10006614:	40f00000 	.word	0x40f00000
10006618:	00000000 	.word	0x00000000
1000661c:	3df00000 	.word	0x3df00000
10006620:	00000000 	.word	0x00000000
10006624:	41f00000 	.word	0x41f00000
10006628:	00000000 	.word	0x00000000
1000662c:	3f700000 	.word	0x3f700000
10006630:	00000000 	.word	0x00000000
10006634:	3ef00000 	.word	0x3ef00000
10006638:	00000000 	.word	0x00000000
1000663c:	40700000 	.word	0x40700000
10006640:	00000000 	.word	0x00000000
10006644:	42000000 	.word	0x42000000
10006648:	ed8d cb0a 	vstr	d12, [sp, #40]	@ 0x28
1000664c:	ee26 6b0f 	vmul.f64	d6, d6, d15
10006650:	eeb0 cb45 	vmov.f64	d12, d5
10006654:	ee27 fb00 	vmul.f64	d15, d7, d0
10006658:	ee28 5b00 	vmul.f64	d5, d8, d0
1000665c:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10006660:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006664:	eeb8 1b44 	vcvt.f64.u32	d1, s8
10006668:	eefc 6bc5 	vcvt.u32.f64	s13, d5
1000666c:	ed9d 4b0e 	vldr	d4, [sp, #56]	@ 0x38
10006670:	eebc fbcf 	vcvt.u32.f64	s30, d15
10006674:	ee34 2b03 	vadd.f64	d2, d4, d3
10006678:	eeb8 fb4f 	vcvt.f64.u32	d15, s30
1000667c:	eeb8 3b46 	vcvt.f64.u32	d3, s12
10006680:	ed9d 4b14 	vldr	d4, [sp, #80]	@ 0x50
10006684:	eeb8 6b66 	vcvt.f64.u32	d6, s13
10006688:	ee0f 7b49 	vmls.f64	d7, d15, d9
1000668c:	ee34 5b06 	vadd.f64	d5, d4, d6
10006690:	ee3e 4b0f 	vadd.f64	d4, d14, d15
10006694:	ed1f fb1c 	vldr	d15, [pc, #-112]	@ 10006628 <fndsa_vect_mul_fft_fp64_exact+0x438>
10006698:	ee27 7b0f 	vmul.f64	d7, d7, d15
1000669c:	ee06 8b49 	vmls.f64	d8, d6, d9
100066a0:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100066a4:	ee22 6b00 	vmul.f64	d6, d2, d0
100066a8:	eefc 7bc6 	vcvt.u32.f64	s15, d6
100066ac:	eeb8 6b47 	vcvt.f64.u32	d6, s14
100066b0:	ed8d 6b04 	vstr	d6, [sp, #16]
100066b4:	ee25 6b00 	vmul.f64	d6, d5, d0
100066b8:	eeb8 7b67 	vcvt.f64.u32	d7, s15
100066bc:	eefc 6bc6 	vcvt.u32.f64	s13, d6
100066c0:	ee07 2b49 	vmls.f64	d2, d7, d9
100066c4:	eeb8 7b66 	vcvt.f64.u32	d7, s13
100066c8:	eeb0 6b45 	vmov.f64	d6, d5
100066cc:	ee07 6b49 	vmls.f64	d6, d7, d9
100066d0:	ed1f 7b29 	vldr	d7, [pc, #-164]	@ 10006630 <fndsa_vect_mul_fft_fp64_exact+0x440>
100066d4:	eeb0 eb46 	vmov.f64	d14, d6
100066d8:	ee2c 6b07 	vmul.f64	d6, d12, d7
100066dc:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100066e0:	eeb0 5b4c 	vmov.f64	d5, d12
100066e4:	ee28 7b07 	vmul.f64	d7, d8, d7
100066e8:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100066ec:	eefc cbc7 	vcvt.u32.f64	s25, d7
100066f0:	ee06 5b4d 	vmls.f64	d5, d6, d13
100066f4:	eeb0 7b46 	vmov.f64	d7, d6
100066f8:	ed1f fb31 	vldr	d15, [pc, #-196]	@ 10006638 <fndsa_vect_mul_fft_fp64_exact+0x448>
100066fc:	ee05 1b0d 	vmla.f64	d1, d5, d13
10006700:	ee02 7b0f 	vmla.f64	d7, d2, d15
10006704:	ed1f 6b32 	vldr	d6, [pc, #-200]	@ 10006640 <fndsa_vect_mul_fft_fp64_exact+0x450>
10006708:	eeb0 2b41 	vmov.f64	d2, d1
1000670c:	ed9d 5b10 	vldr	d5, [sp, #64]	@ 0x40
10006710:	ed9d 1b32 	vldr	d1, [sp, #200]	@ 0xc8
10006714:	ee37 7b06 	vadd.f64	d7, d7, d6
10006718:	eeb0 fb46 	vmov.f64	d15, d6
1000671c:	ee05 7b41 	vmls.f64	d7, d5, d1
10006720:	eeb8 6b6c 	vcvt.f64.u32	d6, s25
10006724:	ed9d 5b12 	vldr	d5, [sp, #72]	@ 0x48
10006728:	ed9d 1b2a 	vldr	d1, [sp, #168]	@ 0xa8
1000672c:	ee06 8b4d 	vmls.f64	d8, d6, d13
10006730:	ee05 7b41 	vmls.f64	d7, d5, d1
10006734:	ed1f cb40 	vldr	d12, [pc, #-256]	@ 10006638 <fndsa_vect_mul_fft_fp64_exact+0x448>
10006738:	eeb0 5b46 	vmov.f64	d5, d6
1000673c:	eeb0 1b43 	vmov.f64	d1, d3
10006740:	ee0e 5b0c 	vmla.f64	d5, d14, d12
10006744:	ee08 1b0d 	vmla.f64	d1, d8, d13
10006748:	ee27 3b0b 	vmul.f64	d3, d7, d11
1000674c:	eeb0 eb41 	vmov.f64	d14, d1
10006750:	ed9d 8b36 	vldr	d8, [sp, #216]	@ 0xd8
10006754:	ed9d 1b18 	vldr	d1, [sp, #96]	@ 0x60
10006758:	ee24 6b00 	vmul.f64	d6, d4, d0
1000675c:	ee35 5b0f 	vadd.f64	d5, d5, d15
10006760:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006764:	ee01 5b48 	vmls.f64	d5, d1, d8
10006768:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000676c:	ed9d 1b1a 	vldr	d1, [sp, #104]	@ 0x68
10006770:	ed9d 8b2e 	vldr	d8, [sp, #184]	@ 0xb8
10006774:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006778:	ee01 5b48 	vmls.f64	d5, d1, d8
1000677c:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006780:	ee03 7b4a 	vmls.f64	d7, d3, d10
10006784:	ed9d cb0a 	vldr	d12, [sp, #40]	@ 0x28
10006788:	eeb0 8b45 	vmov.f64	d8, d5
1000678c:	ee06 4b49 	vmls.f64	d4, d6, d9
10006790:	ee3c 5b06 	vadd.f64	d5, d12, d6
10006794:	eeb0 6b47 	vmov.f64	d6, d7
10006798:	ed1f 7b5b 	vldr	d7, [pc, #-364]	@ 10006630 <fndsa_vect_mul_fft_fp64_exact+0x440>
1000679c:	ee25 3b00 	vmul.f64	d3, d5, d0
100067a0:	ee24 7b07 	vmul.f64	d7, d4, d7
100067a4:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100067a8:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100067ac:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100067b0:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100067b4:	ee03 5b49 	vmls.f64	d5, d3, d9
100067b8:	eeb0 1b47 	vmov.f64	d1, d7
100067bc:	ed1f 3b62 	vldr	d3, [pc, #-392]	@ 10006638 <fndsa_vect_mul_fft_fp64_exact+0x448>
100067c0:	ee07 4b4d 	vmls.f64	d4, d7, d13
100067c4:	ee05 1b03 	vmla.f64	d1, d5, d3
100067c8:	ed9d fb04 	vldr	d15, [sp, #16]
100067cc:	ed1f 7b64 	vldr	d7, [pc, #-400]	@ 10006640 <fndsa_vect_mul_fft_fp64_exact+0x450>
100067d0:	ee04 fb0d 	vmla.f64	d15, d4, d13
100067d4:	ee31 5b07 	vadd.f64	d5, d1, d7
100067d8:	ed9d 7b16 	vldr	d7, [sp, #88]	@ 0x58
100067dc:	ed9d 4b02 	vldr	d4, [sp, #8]
100067e0:	ed9d 3b00 	vldr	d3, [sp]
100067e4:	ee07 5b44 	vmls.f64	d5, d7, d4
100067e8:	ed9d 7b1c 	vldr	d7, [sp, #112]	@ 0x70
100067ec:	ee07 5b43 	vmls.f64	d5, d7, d3
100067f0:	ee28 7b0b 	vmul.f64	d7, d8, d11
100067f4:	ee32 3b0e 	vadd.f64	d3, d2, d14
100067f8:	ee32 4b0a 	vadd.f64	d4, d2, d10
100067fc:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006800:	ee23 2b0b 	vmul.f64	d2, d3, d11
10006804:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006808:	eebc 2bc2 	vcvt.u32.f64	s4, d2
1000680c:	ee07 8b4a 	vmls.f64	d8, d7, d10
10006810:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10006814:	ee36 7b08 	vadd.f64	d7, d6, d8
10006818:	ee02 3b4a 	vmls.f64	d3, d2, d10
1000681c:	ee3f fb0a 	vadd.f64	d15, d15, d10
10006820:	ee37 7b02 	vadd.f64	d7, d7, d2
10006824:	ee3f 3b43 	vsub.f64	d3, d15, d3
10006828:	ee25 2b0b 	vmul.f64	d2, d5, d11
1000682c:	ee36 6b0a 	vadd.f64	d6, d6, d10
10006830:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10006834:	ee36 6b48 	vsub.f64	d6, d6, d8
10006838:	ee23 8b0b 	vmul.f64	d8, d3, d11
1000683c:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10006840:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10006844:	ee02 5b4a 	vmls.f64	d5, d2, d10
10006848:	eeb8 2b48 	vcvt.f64.u32	d2, s16
1000684c:	ee02 3b4a 	vmls.f64	d3, d2, d10
10006850:	ed8d 3b26 	vstr	d3, [sp, #152]	@ 0x98
10006854:	ee27 3b0b 	vmul.f64	d3, d7, d11
10006858:	ee34 4b4e 	vsub.f64	d4, d4, d14
1000685c:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006860:	ee24 8b0b 	vmul.f64	d8, d4, d11
10006864:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10006868:	eeb7 1b00 	vmov.f64	d1, #112	@ 0x3f800000  1.0
1000686c:	ee35 5b0a 	vadd.f64	d5, d5, d10
10006870:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10006874:	ee03 7b4a 	vmls.f64	d7, d3, d10
10006878:	eeb8 8b48 	vcvt.f64.u32	d8, s16
1000687c:	ee35 7b47 	vsub.f64	d7, d5, d7
10006880:	ee36 6b41 	vsub.f64	d6, d6, d1
10006884:	ee37 7b41 	vsub.f64	d7, d7, d1
10006888:	ee36 6b08 	vadd.f64	d6, d6, d8
1000688c:	ee08 4b4a 	vmls.f64	d4, d8, d10
10006890:	ee26 5b0b 	vmul.f64	d5, d6, d11
10006894:	ee37 7b02 	vadd.f64	d7, d7, d2
10006898:	ed8d 4b22 	vstr	d4, [sp, #136]	@ 0x88
1000689c:	eebc 4bc5 	vcvt.u32.f64	s8, d5
100068a0:	ee27 5b0b 	vmul.f64	d5, d7, d11
100068a4:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100068a8:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100068ac:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100068b0:	ee04 6b4a 	vmls.f64	d6, d4, d10
100068b4:	ee05 7b4a 	vmls.f64	d7, d5, d10
100068b8:	ed8d 6b20 	vstr	d6, [sp, #128]	@ 0x80
100068bc:	ed8d 7b24 	vstr	d7, [sp, #144]	@ 0x90
100068c0:	ab20      	add	r3, sp, #128	@ 0x80
100068c2:	cb0f      	ldmia	r3, {r0, r1, r2, r3}
100068c4:	e885 000f 	stmia.w	r5, {r0, r1, r2, r3}
100068c8:	ab24      	add	r3, sp, #144	@ 0x90
100068ca:	cb0f      	ldmia	r3, {r0, r1, r2, r3}
100068cc:	3710      	adds	r7, #16
100068ce:	e884 000f 	stmia.w	r4, {r0, r1, r2, r3}
100068d2:	f1be 0e01 	subs.w	lr, lr, #1
100068d6:	f47f acb3 	bne.w	10006240 <fndsa_vect_mul_fft_fp64_exact+0x50>
100068da:	b039      	add	sp, #228	@ 0xe4
100068dc:	ecbd 8b10 	vpop	{d8-d15}
100068e0:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
