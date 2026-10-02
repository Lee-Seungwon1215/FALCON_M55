
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_q32_compat/validation/build/compat-profile/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10006120 <fp64q_mul>:
10006120:	b570      	push	{r4, r5, r6, lr}
10006122:	ed2d 8b02 	vpush	{d8}
10006126:	b084      	sub	sp, #16
10006128:	e9dd 410a 	ldrd	r4, r1, [sp, #40]	@ 0x28
1000612c:	ee06 2a90 	vmov	s13, r2
10006130:	ee07 4a90 	vmov	s15, r4
10006134:	461d      	mov	r5, r3
10006136:	eeb8 3b67 	vcvt.f64.u32	d3, s15
1000613a:	eeb8 6b66 	vcvt.f64.u32	d6, s13
1000613e:	ee07 1a90 	vmov	s15, r1
10006142:	ee05 5a90 	vmov	s11, r5
10006146:	ee26 0b03 	vmul.f64	d0, d6, d3
1000614a:	eeb8 1b67 	vcvt.f64.u32	d1, s15
1000614e:	ed9f 7b46 	vldr	d7, [pc, #280]	@ 10006268 <fp64q_mul+0x148>
10006152:	eeb8 5b65 	vcvt.f64.u32	d5, s11
10006156:	ee21 1b06 	vmul.f64	d1, d1, d6
1000615a:	ee20 6b07 	vmul.f64	d6, d0, d7
1000615e:	ee25 5b03 	vmul.f64	d5, d5, d3
10006162:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006166:	ee21 3b07 	vmul.f64	d3, d1, d7
1000616a:	ee25 7b07 	vmul.f64	d7, d5, d7
1000616e:	ed9f 4b40 	vldr	d4, [pc, #256]	@ 10006270 <fp64q_mul+0x150>
10006172:	eeb8 2b46 	vcvt.f64.u32	d2, s12
10006176:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000617a:	eefc 7bc3 	vcvt.u32.f64	s15, d3
1000617e:	ee22 2b04 	vmul.f64	d2, d2, d4
10006182:	eeb8 3b67 	vcvt.f64.u32	d3, s15
10006186:	fb01 fe02 	mul.w	lr, r1, r2
1000618a:	fb04 f302 	mul.w	r3, r4, r2
1000618e:	ea02 72e1 	and.w	r2, r2, r1, asr #31
10006192:	fb05 f101 	mul.w	r1, r5, r1
10006196:	fb04 fc05 	mul.w	ip, r4, r5
1000619a:	ea04 74e5 	and.w	r4, r4, r5, asr #31
1000619e:	1b09      	subs	r1, r1, r4
100061a0:	ee10 6a90 	vmov	r6, s1
100061a4:	ec55 4b12 	vmov	r4, r5, d2
100061a8:	1a89      	subs	r1, r1, r2
100061aa:	ee10 2a10 	vmov	r2, s0
100061ae:	ee23 3b04 	vmul.f64	d3, d3, d4
100061b2:	4062      	eors	r2, r4
100061b4:	ea86 0405 	eor.w	r4, r6, r5
100061b8:	4322      	orrs	r2, r4
100061ba:	ee11 5a10 	vmov	r5, s2
100061be:	ee13 4a10 	vmov	r4, s6
100061c2:	ee11 6a90 	vmov	r6, s3
100061c6:	406c      	eors	r4, r5
100061c8:	ee13 5a90 	vmov	r5, s7
100061cc:	eeb8 8b47 	vcvt.f64.u32	d8, s14
100061d0:	4075      	eors	r5, r6
100061d2:	4325      	orrs	r5, r4
100061d4:	4254      	negs	r4, r2
100061d6:	4322      	orrs	r2, r4
100061d8:	0fd2      	lsrs	r2, r2, #31
100061da:	9203      	str	r2, [sp, #12]
100061dc:	9a03      	ldr	r2, [sp, #12]
100061de:	426c      	negs	r4, r5
100061e0:	f082 0201 	eor.w	r2, r2, #1
100061e4:	ea02 73d3 	and.w	r3, r2, r3, lsr #31
100061e8:	ee16 2a10 	vmov	r2, s12
100061ec:	432c      	orrs	r4, r5
100061ee:	0fe4      	lsrs	r4, r4, #31
100061f0:	9402      	str	r4, [sp, #8]
100061f2:	ee17 4a90 	vmov	r4, s15
100061f6:	ee28 4b04 	vmul.f64	d4, d8, d4
100061fa:	1ad2      	subs	r2, r2, r3
100061fc:	9b02      	ldr	r3, [sp, #8]
100061fe:	eb12 020e 	adds.w	r2, r2, lr
10006202:	f083 0301 	eor.w	r3, r3, #1
10006206:	ea03 73de 	and.w	r3, r3, lr, lsr #31
1000620a:	eba4 0303 	sub.w	r3, r4, r3
1000620e:	eb43 0101 	adc.w	r1, r3, r1
10006212:	eb12 020c 	adds.w	r2, r2, ip
10006216:	ee14 3a10 	vmov	r3, s8
1000621a:	6002      	str	r2, [r0, #0]
1000621c:	ee15 2a10 	vmov	r2, s10
10006220:	ee15 4a90 	vmov	r4, s11
10006224:	ea83 0302 	eor.w	r3, r3, r2
10006228:	ee14 2a90 	vmov	r2, s9
1000622c:	ea82 0204 	eor.w	r2, r2, r4
10006230:	ea42 0203 	orr.w	r2, r2, r3
10006234:	f1c2 0300 	rsb	r3, r2, #0
10006238:	ea43 0302 	orr.w	r3, r3, r2
1000623c:	ee17 2a10 	vmov	r2, s14
10006240:	ea4f 73d3 	mov.w	r3, r3, lsr #31
10006244:	9301      	str	r3, [sp, #4]
10006246:	9b01      	ldr	r3, [sp, #4]
10006248:	f083 0301 	eor.w	r3, r3, #1
1000624c:	ea03 73dc 	and.w	r3, r3, ip, lsr #31
10006250:	eba2 0303 	sub.w	r3, r2, r3
10006254:	eb43 0301 	adc.w	r3, r3, r1
10006258:	6043      	str	r3, [r0, #4]
1000625a:	b004      	add	sp, #16
1000625c:	ecbd 8b02 	vpop	{d8}
10006260:	bd70      	pop	{r4, r5, r6, pc}
10006262:	bf00      	nop
10006264:	f3af 8000 	nop.w
10006268:	00000000 	.word	0x00000000
1000626c:	3df00000 	.word	0x3df00000
10006270:	00000000 	.word	0x00000000
10006274:	41f00000 	.word	0x41f00000
