
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/r2-kat/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10006078 <fndsa_vect_mul_fft_fp64_exact>:
10006078:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
1000607c:	2310      	movs	r3, #16
1000607e:	ed2d 8b10 	vpush	{d8-d15}
10006082:	3801      	subs	r0, #1
10006084:	4083      	lsls	r3, r0
10006086:	b0c9      	sub	sp, #292	@ 0x124
10006088:	eb01 0b03 	add.w	fp, r1, r3
1000608c:	eb02 0a03 	add.w	sl, r2, r3
10006090:	e9cd 3a0d 	strd	r3, sl, [sp, #52]	@ 0x34
10006094:	f8cd b03c 	str.w	fp, [sp, #60]	@ 0x3c
10006098:	2600      	movs	r6, #0
1000609a:	ed9f bb97 	vldr	d11, [pc, #604]	@ 100062f8 <fndsa_vect_mul_fft_fp64_exact+0x280>
1000609e:	ed9f ab98 	vldr	d10, [pc, #608]	@ 10006300 <fndsa_vect_mul_fft_fp64_exact+0x288>
100060a2:	468a      	mov	sl, r1
100060a4:	4693      	mov	fp, r2
100060a6:	f10d 09a0 	add.w	r9, sp, #160	@ 0xa0
100060aa:	f10d 08b0 	add.w	r8, sp, #176	@ 0xb0
100060ae:	af24      	add	r7, sp, #144	@ 0x90
100060b0:	9b0f      	ldr	r3, [sp, #60]	@ 0x3c
100060b2:	eb0a 0506 	add.w	r5, sl, r6
100060b6:	199c      	adds	r4, r3, r6
100060b8:	9b0e      	ldr	r3, [sp, #56]	@ 0x38
100060ba:	eb0b 0e06 	add.w	lr, fp, r6
100060be:	eb03 0c06 	add.w	ip, r3, r6
100060c2:	e895 000f 	ldmia.w	r5, {r0, r1, r2, r3}
100060c6:	e889 000f 	stmia.w	r9, {r0, r1, r2, r3}
100060ca:	e894 000f 	ldmia.w	r4, {r0, r1, r2, r3}
100060ce:	e888 000f 	stmia.w	r8, {r0, r1, r2, r3}
100060d2:	e89e 000f 	ldmia.w	lr, {r0, r1, r2, r3}
100060d6:	f10d 0ec0 	add.w	lr, sp, #192	@ 0xc0
100060da:	e88e 000f 	stmia.w	lr, {r0, r1, r2, r3}
100060de:	e89c 000f 	ldmia.w	ip, {r0, r1, r2, r3}
100060e2:	f10d 0cd0 	add.w	ip, sp, #208	@ 0xd0
100060e6:	e88c 000f 	stmia.w	ip, {r0, r1, r2, r3}
100060ea:	ed9d 7b32 	vldr	d7, [sp, #200]	@ 0xc8
100060ee:	ed9d 5b28 	vldr	d5, [sp, #160]	@ 0xa0
100060f2:	ed9d 6b30 	vldr	d6, [sp, #192]	@ 0xc0
100060f6:	ed9d fb2a 	vldr	d15, [sp, #168]	@ 0xa8
100060fa:	eeb0 3b47 	vmov.f64	d3, d7
100060fe:	ed8d 7b42 	vstr	d7, [sp, #264]	@ 0x108
10006102:	ed8d 7b06 	vstr	d7, [sp, #24]
10006106:	ed9d 7b34 	vldr	d7, [sp, #208]	@ 0xd0
1000610a:	eeb0 0b45 	vmov.f64	d0, d5
1000610e:	eeb0 2b46 	vmov.f64	d2, d6
10006112:	eeb0 1b4f 	vmov.f64	d1, d15
10006116:	ed9d 9b2c 	vldr	d9, [sp, #176]	@ 0xb0
1000611a:	ed9d cb2e 	vldr	d12, [sp, #184]	@ 0xb8
1000611e:	ed9d db36 	vldr	d13, [sp, #216]	@ 0xd8
10006122:	ed8d 5b38 	vstr	d5, [sp, #224]	@ 0xe0
10006126:	ed8d 5b0a 	vstr	d5, [sp, #40]	@ 0x28
1000612a:	ed8d 6b40 	vstr	d6, [sp, #256]	@ 0x100
1000612e:	ed8d 6b08 	vstr	d6, [sp, #32]
10006132:	ed8d 7b00 	vstr	d7, [sp]
10006136:	ed8d fb3a 	vstr	d15, [sp, #232]	@ 0xe8
1000613a:	f7ff f819 	bl	10005170 <fndsa_fp64e_mul>
1000613e:	ed9d 7b00 	vldr	d7, [sp]
10006142:	eeb0 eb40 	vmov.f64	d14, d0
10006146:	eeb0 8b41 	vmov.f64	d8, d1
1000614a:	eeb0 2b47 	vmov.f64	d2, d7
1000614e:	eeb0 3b4d 	vmov.f64	d3, d13
10006152:	ed8d 0b10 	vstr	d0, [sp, #64]	@ 0x40
10006156:	ed8d 1b12 	vstr	d1, [sp, #72]	@ 0x48
1000615a:	eeb0 0b49 	vmov.f64	d0, d9
1000615e:	eeb0 1b4c 	vmov.f64	d1, d12
10006162:	ed8d 9b3c 	vstr	d9, [sp, #240]	@ 0xf0
10006166:	ed8d cb3e 	vstr	d12, [sp, #248]	@ 0xf8
1000616a:	ed8d 7b44 	vstr	d7, [sp, #272]	@ 0x110
1000616e:	ed8d 9b04 	vstr	d9, [sp, #16]
10006172:	ed8d cb02 	vstr	d12, [sp, #8]
10006176:	ed8d db46 	vstr	d13, [sp, #280]	@ 0x118
1000617a:	f7fe fff9 	bl	10005170 <fndsa_fp64e_mul>
1000617e:	ed9d 6b02 	vldr	d6, [sp, #8]
10006182:	eeb0 cb41 	vmov.f64	d12, d1
10006186:	ed9d 7b06 	vldr	d7, [sp, #24]
1000618a:	ee3f 1b06 	vadd.f64	d1, d15, d6
1000618e:	ed9d 5b00 	vldr	d5, [sp]
10006192:	ed9d 6b08 	vldr	d6, [sp, #32]
10006196:	ee37 3b0d 	vadd.f64	d3, d7, d13
1000619a:	ee36 2b05 	vadd.f64	d2, d6, d5
1000619e:	ed9d 7b04 	vldr	d7, [sp, #16]
100061a2:	ed9d 5b0a 	vldr	d5, [sp, #40]	@ 0x28
100061a6:	eeb0 9b40 	vmov.f64	d9, d0
100061aa:	ee35 0b07 	vadd.f64	d0, d5, d7
100061ae:	ee23 7b0b 	vmul.f64	d7, d3, d11
100061b2:	ee21 6b0b 	vmul.f64	d6, d1, d11
100061b6:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100061ba:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100061be:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100061c2:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100061c6:	ee32 5b07 	vadd.f64	d5, d2, d7
100061ca:	ee30 0b06 	vadd.f64	d0, d0, d6
100061ce:	ee06 1b4a 	vmls.f64	d1, d6, d10
100061d2:	ee25 6b0b 	vmul.f64	d6, d5, d11
100061d6:	ee07 3b4a 	vmls.f64	d3, d7, d10
100061da:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100061de:	ee20 7b0b 	vmul.f64	d7, d0, d11
100061e2:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100061e6:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100061ea:	ee06 5b4a 	vmls.f64	d5, d6, d10
100061ee:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100061f2:	eeb0 6b40 	vmov.f64	d6, d0
100061f6:	ee07 6b4a 	vmls.f64	d6, d7, d10
100061fa:	eeb0 2b45 	vmov.f64	d2, d5
100061fe:	eeb0 0b46 	vmov.f64	d0, d6
10006202:	ed8d 9b14 	vstr	d9, [sp, #80]	@ 0x50
10006206:	ed8d 1b1e 	vstr	d1, [sp, #120]	@ 0x78
1000620a:	ed8d 3b1a 	vstr	d3, [sp, #104]	@ 0x68
1000620e:	ed8d 6b1c 	vstr	d6, [sp, #112]	@ 0x70
10006212:	ed8d 5b18 	vstr	d5, [sp, #96]	@ 0x60
10006216:	ed8d cb16 	vstr	d12, [sp, #88]	@ 0x58
1000621a:	f7fe ffa9 	bl	10005170 <fndsa_fp64e_mul>
1000621e:	ee38 6b0c 	vadd.f64	d6, d8, d12
10006222:	ee26 3b0b 	vmul.f64	d3, d6, d11
10006226:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000622a:	ee3e 5b09 	vadd.f64	d5, d14, d9
1000622e:	eeb8 2b43 	vcvt.f64.u32	d2, s6
10006232:	ee38 8b0a 	vadd.f64	d8, d8, d10
10006236:	ee35 5b02 	vadd.f64	d5, d5, d2
1000623a:	ee38 8b4c 	vsub.f64	d8, d8, d12
1000623e:	ee31 1b0a 	vadd.f64	d1, d1, d10
10006242:	ee30 7b0a 	vadd.f64	d7, d0, d10
10006246:	ee02 6b4a 	vmls.f64	d6, d2, d10
1000624a:	ee28 0b0b 	vmul.f64	d0, d8, d11
1000624e:	ee25 2b0b 	vmul.f64	d2, d5, d11
10006252:	ee3e 4b0a 	vadd.f64	d4, d14, d10
10006256:	ee31 6b46 	vsub.f64	d6, d1, d6
1000625a:	ee34 4b49 	vsub.f64	d4, d4, d9
1000625e:	eebc 1bc2 	vcvt.u32.f64	s2, d2
10006262:	eeb7 9b00 	vmov.f64	d9, #112	@ 0x3f800000  1.0
10006266:	eebc 3bc0 	vcvt.u32.f64	s6, d0
1000626a:	ee34 4b49 	vsub.f64	d4, d4, d9
1000626e:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10006272:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10006276:	ee34 4b03 	vadd.f64	d4, d4, d3
1000627a:	ee03 8b4a 	vmls.f64	d8, d3, d10
1000627e:	ee01 5b4a 	vmls.f64	d5, d1, d10
10006282:	ee26 3b0b 	vmul.f64	d3, d6, d11
10006286:	ee37 7b45 	vsub.f64	d7, d7, d5
1000628a:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000628e:	ee37 7b49 	vsub.f64	d7, d7, d9
10006292:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10006296:	ee03 6b4a 	vmls.f64	d6, d3, d10
1000629a:	ee37 7b03 	vadd.f64	d7, d7, d3
1000629e:	ee24 2b0b 	vmul.f64	d2, d4, d11
100062a2:	ed8d 6b26 	vstr	d6, [sp, #152]	@ 0x98
100062a6:	ee27 6b0b 	vmul.f64	d6, d7, d11
100062aa:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100062ae:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100062b2:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100062b6:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100062ba:	ee02 4b4a 	vmls.f64	d4, d2, d10
100062be:	ee06 7b4a 	vmls.f64	d7, d6, d10
100062c2:	ed8d 8b22 	vstr	d8, [sp, #136]	@ 0x88
100062c6:	ed8d 4b20 	vstr	d4, [sp, #128]	@ 0x80
100062ca:	ed8d 7b24 	vstr	d7, [sp, #144]	@ 0x90
100062ce:	ab20      	add	r3, sp, #128	@ 0x80
100062d0:	cb0f      	ldmia	r3, {r0, r1, r2, r3}
100062d2:	e885 000f 	stmia.w	r5, {r0, r1, r2, r3}
100062d6:	e897 000f 	ldmia.w	r7, {r0, r1, r2, r3}
100062da:	e884 000f 	stmia.w	r4, {r0, r1, r2, r3}
100062de:	9b0d      	ldr	r3, [sp, #52]	@ 0x34
100062e0:	3610      	adds	r6, #16
100062e2:	42b3      	cmp	r3, r6
100062e4:	f47f aee4 	bne.w	100060b0 <fndsa_vect_mul_fft_fp64_exact+0x38>
100062e8:	b049      	add	sp, #292	@ 0x124
100062ea:	ecbd 8b10 	vpop	{d8-d15}
100062ee:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
100062f2:	bf00      	nop
100062f4:	f3af 8000 	nop.w
100062f8:	00000000 	.word	0x00000000
100062fc:	3df00000 	.word	0x3df00000
10006300:	00000000 	.word	0x00000000
10006304:	41f00000 	.word	0x41f00000
