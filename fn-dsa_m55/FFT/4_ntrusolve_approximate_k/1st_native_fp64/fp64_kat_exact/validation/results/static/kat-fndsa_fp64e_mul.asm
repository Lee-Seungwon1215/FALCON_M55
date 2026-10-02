
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_kat_exact/validation/build/kat/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10004fe0 <fndsa_fp64e_mul>:
10004fe0:	eefc 7bc2 	vcvt.u32.f64	s15, d2
10004fe4:	ee17 3a90 	vmov	r3, s15
10004fe8:	eefc 7bc0 	vcvt.u32.f64	s15, d0
10004fec:	ee17 2a90 	vmov	r2, s15
10004ff0:	ed9f 6b5b 	vldr	d6, [pc, #364]	@ 10005160 <fndsa_fp64e_mul+0x180>
10004ff4:	0fd2      	lsrs	r2, r2, #31
10004ff6:	ed2d 8b10 	vpush	{d8-d15}
10004ffa:	ee07 2a90 	vmov	s15, r2
10004ffe:	eeb0 eb41 	vmov.f64	d14, d1
10005002:	eeb0 db43 	vmov.f64	d13, d3
10005006:	ee21 1b06 	vmul.f64	d1, d1, d6
1000500a:	ee23 3b06 	vmul.f64	d3, d3, d6
1000500e:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10005012:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10005016:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000501a:	b094      	sub	sp, #80	@ 0x50
1000501c:	0fdb      	lsrs	r3, r3, #31
1000501e:	ed9f 5b52 	vldr	d5, [pc, #328]	@ 10005168 <fndsa_fp64e_mul+0x188>
10005022:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10005026:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000502a:	ed8d 7b00 	vstr	d7, [sp]
1000502e:	eeb0 ab4e 	vmov.f64	d10, d14
10005032:	ee07 3a90 	vmov	s15, r3
10005036:	eeb0 9b4d 	vmov.f64	d9, d13
1000503a:	ee01 ab45 	vmls.f64	d10, d1, d5
1000503e:	ee03 9b45 	vmls.f64	d9, d3, d5
10005042:	eeb8 4be7 	vcvt.f64.s32	d4, s15
10005046:	ed9f 7b4a 	vldr	d7, [pc, #296]	@ 10005170 <fndsa_fp64e_mul+0x190>
1000504a:	ee0a 7b09 	vmla.f64	d7, d10, d9
1000504e:	ee27 7b06 	vmul.f64	d7, d7, d6
10005052:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005056:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000505a:	ee22 8b06 	vmul.f64	d8, d2, d6
1000505e:	ee0a 7b03 	vmla.f64	d7, d10, d3
10005062:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10005066:	ee01 7b09 	vmla.f64	d7, d1, d9
1000506a:	eeb8 bb48 	vcvt.f64.u32	d11, s16
1000506e:	ee27 7b06 	vmul.f64	d7, d7, d6
10005072:	ed8d 4b02 	vstr	d4, [sp, #8]
10005076:	ee0b 2b45 	vmls.f64	d2, d11, d5
1000507a:	ee20 4b06 	vmul.f64	d4, d0, d6
1000507e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005082:	eeb0 cb42 	vmov.f64	d12, d2
10005086:	eefc 4bc4 	vcvt.u32.f64	s9, d4
1000508a:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000508e:	eeb8 2b64 	vcvt.f64.u32	d2, s9
10005092:	ee0a 7b0c 	vmla.f64	d7, d10, d12
10005096:	ee02 0b45 	vmls.f64	d0, d2, d5
1000509a:	ee01 7b03 	vmla.f64	d7, d1, d3
1000509e:	ee00 7b09 	vmla.f64	d7, d0, d9
100050a2:	ee27 8b06 	vmul.f64	d8, d7, d6
100050a6:	eebc 8bc8 	vcvt.u32.f64	s16, d8
100050aa:	eeb8 8b48 	vcvt.f64.u32	d8, s16
100050ae:	eeb0 4b48 	vmov.f64	d4, d8
100050b2:	ee0a 4b0b 	vmla.f64	d4, d10, d11
100050b6:	ee01 4b0c 	vmla.f64	d4, d1, d12
100050ba:	ee00 4b03 	vmla.f64	d4, d0, d3
100050be:	ee02 4b09 	vmla.f64	d4, d2, d9
100050c2:	ee08 7b45 	vmls.f64	d7, d8, d5
100050c6:	ee24 8b06 	vmul.f64	d8, d4, d6
100050ca:	eebc 8bc8 	vcvt.u32.f64	s16, d8
100050ce:	eeb8 8b48 	vcvt.f64.u32	d8, s16
100050d2:	eeb0 ab47 	vmov.f64	d10, d7
100050d6:	eeb0 7b48 	vmov.f64	d7, d8
100050da:	ee01 7b0b 	vmla.f64	d7, d1, d11
100050de:	ee00 7b0c 	vmla.f64	d7, d0, d12
100050e2:	ee02 7b03 	vmla.f64	d7, d2, d3
100050e6:	ee27 3b06 	vmul.f64	d3, d7, d6
100050ea:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100050ee:	ee08 4b45 	vmls.f64	d4, d8, d5
100050f2:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100050f6:	eeb0 1b4a 	vmov.f64	d1, d10
100050fa:	ee04 1b05 	vmla.f64	d1, d4, d5
100050fe:	eeb0 4b43 	vmov.f64	d4, d3
10005102:	ee00 4b0b 	vmla.f64	d4, d0, d11
10005106:	ee02 4b0c 	vmla.f64	d4, d2, d12
1000510a:	ee24 6b06 	vmul.f64	d6, d4, d6
1000510e:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10005112:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005116:	ee03 7b45 	vmls.f64	d7, d3, d5
1000511a:	ee06 4b45 	vmls.f64	d4, d6, d5
1000511e:	ed9f fb16 	vldr	d15, [pc, #88]	@ 10005178 <fndsa_fp64e_mul+0x198>
10005122:	ee04 7b05 	vmla.f64	d7, d4, d5
10005126:	ee37 0b0f 	vadd.f64	d0, d7, d15
1000512a:	ed9d 7b00 	vldr	d7, [sp]
1000512e:	ed9d 4b02 	vldr	d4, [sp, #8]
10005132:	ee07 0b4d 	vmls.f64	d0, d7, d13
10005136:	ed9f 7b12 	vldr	d7, [pc, #72]	@ 10005180 <fndsa_fp64e_mul+0x1a0>
1000513a:	ee04 0b4e 	vmls.f64	d0, d4, d14
1000513e:	ee20 7b07 	vmul.f64	d7, d0, d7
10005142:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005146:	ed9f 6b10 	vldr	d6, [pc, #64]	@ 10005188 <fndsa_fp64e_mul+0x1a8>
1000514a:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000514e:	ee07 0b46 	vmls.f64	d0, d7, d6
10005152:	b014      	add	sp, #80	@ 0x50
10005154:	ecbd 8b10 	vpop	{d8-d15}
10005158:	4770      	bx	lr
1000515a:	bf00      	nop
1000515c:	f3af 8000 	nop.w
10005160:	00000000 	.word	0x00000000
10005164:	3ef00000 	.word	0x3ef00000
10005168:	00000000 	.word	0x00000000
1000516c:	40f00000 	.word	0x40f00000
	...
1000517c:	42000000 	.word	0x42000000
10005180:	00000000 	.word	0x00000000
10005184:	3df00000 	.word	0x3df00000
10005188:	00000000 	.word	0x00000000
1000518c:	41f00000 	.word	0x41f00000
