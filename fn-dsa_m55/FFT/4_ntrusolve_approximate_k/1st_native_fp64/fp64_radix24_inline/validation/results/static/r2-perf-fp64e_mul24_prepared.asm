
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/r2-perf/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10006120 <fp64e_mul24_prepared>:
10006120:	ed9f 6b51 	vldr	d6, [pc, #324]	@ 10006268 <fp64e_mul24_prepared+0x148>
10006124:	eeb0 2b40 	vmov.f64	d2, d0
10006128:	ed9f 7b51 	vldr	d7, [pc, #324]	@ 10006270 <fp64e_mul24_prepared+0x150>
1000612c:	ee22 4b07 	vmul.f64	d4, d2, d7
10006130:	ee21 7b06 	vmul.f64	d7, d1, d6
10006134:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10006138:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000613c:	eefc 7bc2 	vcvt.u32.f64	s15, d2
10006140:	ed2d 8b10 	vpush	{d8-d15}
10006144:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10006148:	ed9f 8b4b 	vldr	d8, [pc, #300]	@ 10006278 <fp64e_mul24_prepared+0x158>
1000614c:	ee17 3a90 	vmov	r3, s15
10006150:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006154:	eeb0 0b41 	vmov.f64	d0, d1
10006158:	ee04 2b48 	vmls.f64	d2, d4, d8
1000615c:	ed9f 9b48 	vldr	d9, [pc, #288]	@ 10006280 <fp64e_mul24_prepared+0x160>
10006160:	eeb0 1b47 	vmov.f64	d1, d7
10006164:	0fdb      	lsrs	r3, r3, #31
10006166:	ed9f 3b48 	vldr	d3, [pc, #288]	@ 10006288 <fp64e_mul24_prepared+0x168>
1000616a:	ee02 1b09 	vmla.f64	d1, d2, d9
1000616e:	ee05 3a90 	vmov	s11, r3
10006172:	eeb0 2b40 	vmov.f64	d2, d0
10006176:	eeb8 ebe5 	vcvt.f64.s32	d14, s11
1000617a:	ee07 2b43 	vmls.f64	d2, d7, d3
1000617e:	ed90 fb02 	vldr	d15, [r0, #8]
10006182:	ed90 db04 	vldr	d13, [r0, #16]
10006186:	ed90 5b00 	vldr	d5, [r0]
1000618a:	ee22 7b05 	vmul.f64	d7, d2, d5
1000618e:	ee22 ab0f 	vmul.f64	d10, d2, d15
10006192:	ee22 bb0d 	vmul.f64	d11, d2, d13
10006196:	ee21 cb0d 	vmul.f64	d12, d1, d13
1000619a:	ee01 ab05 	vmla.f64	d10, d1, d5
1000619e:	ee01 bb0f 	vmla.f64	d11, d1, d15
100061a2:	ee04 cb0f 	vmla.f64	d12, d4, d15
100061a6:	ee04 bb05 	vmla.f64	d11, d4, d5
100061aa:	ee27 7b06 	vmul.f64	d7, d7, d6
100061ae:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100061b2:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100061b6:	ee37 7b0a 	vadd.f64	d7, d7, d10
100061ba:	ee27 2b06 	vmul.f64	d2, d7, d6
100061be:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100061c2:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100061c6:	ed9f 4b32 	vldr	d4, [pc, #200]	@ 10006290 <fp64e_mul24_prepared+0x170>
100061ca:	ee3b ab02 	vadd.f64	d10, d11, d2
100061ce:	ee02 7b43 	vmls.f64	d7, d2, d3
100061d2:	ee27 7b04 	vmul.f64	d7, d7, d4
100061d6:	ee2a 4b06 	vmul.f64	d4, d10, d6
100061da:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100061de:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100061e2:	eeb8 1b47 	vcvt.f64.u32	d1, s14
100061e6:	eeb8 7b44 	vcvt.f64.u32	d7, s8
100061ea:	ed90 5b08 	vldr	d5, [r0, #32]
100061ee:	ee3c 4b07 	vadd.f64	d4, d12, d7
100061f2:	ee07 ab43 	vmls.f64	d10, d7, d3
100061f6:	ed9f 7b1e 	vldr	d7, [pc, #120]	@ 10006270 <fp64e_mul24_prepared+0x150>
100061fa:	b08e      	sub	sp, #56	@ 0x38
100061fc:	ed8d 5b00 	vstr	d5, [sp]
10006200:	ee24 6b06 	vmul.f64	d6, d4, d6
10006204:	ee2a 5b07 	vmul.f64	d5, d10, d7
10006208:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000620c:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10006210:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006214:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10006218:	ee06 4b43 	vmls.f64	d4, d6, d3
1000621c:	eeb0 7b45 	vmov.f64	d7, d5
10006220:	ed9f db1d 	vldr	d13, [pc, #116]	@ 10006298 <fp64e_mul24_prepared+0x178>
10006224:	ee04 7b09 	vmla.f64	d7, d4, d9
10006228:	ed90 fb06 	vldr	d15, [r0, #24]
1000622c:	ee37 7b0d 	vadd.f64	d7, d7, d13
10006230:	ee05 ab48 	vmls.f64	d10, d5, d8
10006234:	ee0e 7b4f 	vmls.f64	d7, d14, d15
10006238:	ed9d 5b00 	vldr	d5, [sp]
1000623c:	ed9f 6b18 	vldr	d6, [pc, #96]	@ 100062a0 <fp64e_mul24_prepared+0x180>
10006240:	ee00 7b45 	vmls.f64	d7, d0, d5
10006244:	ee27 6b06 	vmul.f64	d6, d7, d6
10006248:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000624c:	ed9f 5b16 	vldr	d5, [pc, #88]	@ 100062a8 <fp64e_mul24_prepared+0x188>
10006250:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006254:	ee06 7b45 	vmls.f64	d7, d6, d5
10006258:	ee0a 1b08 	vmla.f64	d1, d10, d8
1000625c:	eeb0 0b47 	vmov.f64	d0, d7
10006260:	b00e      	add	sp, #56	@ 0x38
10006262:	ecbd 8b10 	vpop	{d8-d15}
10006266:	4770      	bx	lr
10006268:	00000000 	.word	0x00000000
1000626c:	3e700000 	.word	0x3e700000
10006270:	00000000 	.word	0x00000000
10006274:	3ef00000 	.word	0x3ef00000
10006278:	00000000 	.word	0x00000000
1000627c:	40f00000 	.word	0x40f00000
10006280:	00000000 	.word	0x00000000
10006284:	40700000 	.word	0x40700000
10006288:	00000000 	.word	0x00000000
1000628c:	41700000 	.word	0x41700000
10006290:	00000000 	.word	0x00000000
10006294:	3f700000 	.word	0x3f700000
10006298:	00000000 	.word	0x00000000
1000629c:	42000000 	.word	0x42000000
100062a0:	00000000 	.word	0x00000000
100062a4:	3df00000 	.word	0x3df00000
100062a8:	00000000 	.word	0x00000000
100062ac:	41f00000 	.word	0x41f00000
