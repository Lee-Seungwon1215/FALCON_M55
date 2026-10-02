
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_q32_compat/validation/build/kernels/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10001308 <fndsa_vect_mul_fft_fp64q>:
10001308:	2308      	movs	r3, #8
1000130a:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
1000130e:	2501      	movs	r5, #1
10001310:	f04f 0a00 	mov.w	sl, #0
10001314:	1e44      	subs	r4, r0, #1
10001316:	f1a1 0908 	sub.w	r9, r1, #8
1000131a:	3a08      	subs	r2, #8
1000131c:	40a3      	lsls	r3, r4
1000131e:	b09d      	sub	sp, #116	@ 0x74
10001320:	fa05 f104 	lsl.w	r1, r5, r4
10001324:	eb03 0809 	add.w	r8, r3, r9
10001328:	4413      	add	r3, r2
1000132a:	9205      	str	r2, [sp, #20]
1000132c:	9109      	str	r1, [sp, #36]	@ 0x24
1000132e:	9306      	str	r3, [sp, #24]
10001330:	e9f9 2302 	ldrd	r2, r3, [r9, #8]!
10001334:	4615      	mov	r5, r2
10001336:	e9f8 0102 	ldrd	r0, r1, [r8, #8]!
1000133a:	461c      	mov	r4, r3
1000133c:	e9cd 010e 	strd	r0, r1, [sp, #56]	@ 0x38
10001340:	9103      	str	r1, [sp, #12]
10001342:	9905      	ldr	r1, [sp, #20]
10001344:	4606      	mov	r6, r0
10001346:	e9cd 230c 	strd	r2, r3, [sp, #48]	@ 0x30
1000134a:	e9f1 2302 	ldrd	r2, r3, [r1, #8]!
1000134e:	4618      	mov	r0, r3
10001350:	4693      	mov	fp, r2
10001352:	9105      	str	r1, [sp, #20]
10001354:	9906      	ldr	r1, [sp, #24]
10001356:	e9cd 5414 	strd	r5, r4, [sp, #80]	@ 0x50
1000135a:	e9cd 2310 	strd	r2, r3, [sp, #64]	@ 0x40
1000135e:	e9f1 2302 	ldrd	r2, r3, [r1, #8]!
10001362:	9502      	str	r5, [sp, #8]
10001364:	4617      	mov	r7, r2
10001366:	461d      	mov	r5, r3
10001368:	9019      	str	r0, [sp, #100]	@ 0x64
1000136a:	f8cd b060 	str.w	fp, [sp, #96]	@ 0x60
1000136e:	e9cd 2312 	strd	r2, r3, [sp, #72]	@ 0x48
10001372:	e9dd 2318 	ldrd	r2, r3, [sp, #96]	@ 0x60
10001376:	9004      	str	r0, [sp, #16]
10001378:	e9cd 2300 	strd	r2, r3, [sp]
1000137c:	e9dd 2314 	ldrd	r2, r3, [sp, #80]	@ 0x50
10001380:	a80a      	add	r0, sp, #40	@ 0x28
10001382:	9106      	str	r1, [sp, #24]
10001384:	f7ff f8ac 	bl	100004e0 <fp64q_mul>
10001388:	e9cd 751a 	strd	r7, r5, [sp, #104]	@ 0x68
1000138c:	9b03      	ldr	r3, [sp, #12]
1000138e:	9a0a      	ldr	r2, [sp, #40]	@ 0x28
10001390:	990b      	ldr	r1, [sp, #44]	@ 0x2c
10001392:	9616      	str	r6, [sp, #88]	@ 0x58
10001394:	9317      	str	r3, [sp, #92]	@ 0x5c
10001396:	9207      	str	r2, [sp, #28]
10001398:	e9dd 231a 	ldrd	r2, r3, [sp, #104]	@ 0x68
1000139c:	e9cd 2300 	strd	r2, r3, [sp]
100013a0:	e9dd 2316 	ldrd	r2, r3, [sp, #88]	@ 0x58
100013a4:	9108      	str	r1, [sp, #32]
100013a6:	f7ff f89b 	bl	100004e0 <fp64q_mul>
100013aa:	9902      	ldr	r1, [sp, #8]
100013ac:	f10a 0a01 	add.w	sl, sl, #1
100013b0:	1872      	adds	r2, r6, r1
100013b2:	9e03      	ldr	r6, [sp, #12]
100013b4:	9904      	ldr	r1, [sp, #16]
100013b6:	eb44 0306 	adc.w	r3, r4, r6
100013ba:	eb17 070b 	adds.w	r7, r7, fp
100013be:	eb41 0505 	adc.w	r5, r1, r5
100013c2:	e9cd 7500 	strd	r7, r5, [sp]
100013c6:	e9dd 450a 	ldrd	r4, r5, [sp, #40]	@ 0x28
100013ca:	f7ff f889 	bl	100004e0 <fp64q_mul>
100013ce:	e9dd 600a 	ldrd	r6, r0, [sp, #40]	@ 0x28
100013d2:	9b07      	ldr	r3, [sp, #28]
100013d4:	9908      	ldr	r1, [sp, #32]
100013d6:	191a      	adds	r2, r3, r4
100013d8:	eb41 0705 	adc.w	r7, r1, r5
100013dc:	1ab2      	subs	r2, r6, r2
100013de:	eb60 0007 	sbc.w	r0, r0, r7
100013e2:	1b1b      	subs	r3, r3, r4
100013e4:	eb61 0105 	sbc.w	r1, r1, r5
100013e8:	e9c9 3100 	strd	r3, r1, [r9]
100013ec:	9b09      	ldr	r3, [sp, #36]	@ 0x24
100013ee:	e9c8 2000 	strd	r2, r0, [r8]
100013f2:	4553      	cmp	r3, sl
100013f4:	d19c      	bne.n	10001330 <fndsa_vect_mul_fft_fp64q+0x28>
100013f6:	b01d      	add	sp, #116	@ 0x74
100013f8:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
