
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/r1-kat/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10004fe0 <fndsa_fp64e_mul>:
10004fe0:	eefc 7bc0 	vcvt.u32.f64	s15, d0
10004fe4:	ee17 2a90 	vmov	r2, s15
10004fe8:	eefc 7bc2 	vcvt.u32.f64	s15, d2
10004fec:	0fd2      	lsrs	r2, r2, #31
10004fee:	ee17 3a90 	vmov	r3, s15
10004ff2:	ee07 2a90 	vmov	s15, r2
10004ff6:	ed2d 8b10 	vpush	{d8-d15}
10004ffa:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10004ffe:	b094      	sub	sp, #80	@ 0x50
10005000:	0fdb      	lsrs	r3, r3, #31
10005002:	ed8d 7b00 	vstr	d7, [sp]
10005006:	ee07 3a90 	vmov	s15, r3
1000500a:	eeb0 bb43 	vmov.f64	d11, d3
1000500e:	eeb8 4be7 	vcvt.f64.s32	d4, s15
10005012:	ed9f 3b53 	vldr	d3, [pc, #332]	@ 10005160 <fndsa_fp64e_mul+0x180>
10005016:	ed9f 6b54 	vldr	d6, [pc, #336]	@ 10005168 <fndsa_fp64e_mul+0x188>
1000501a:	ed8d 4b02 	vstr	d4, [sp, #8]
1000501e:	ee22 4b03 	vmul.f64	d4, d2, d3
10005022:	ee20 5b03 	vmul.f64	d5, d0, d3
10005026:	ee21 9b06 	vmul.f64	d9, d1, d6
1000502a:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000502e:	eeb0 cb41 	vmov.f64	d12, d1
10005032:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10005036:	ed9f 1b4e 	vldr	d1, [pc, #312]	@ 10005170 <fndsa_fp64e_mul+0x190>
1000503a:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000503e:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10005042:	ee2b 7b06 	vmul.f64	d7, d11, d6
10005046:	ee04 2b41 	vmls.f64	d2, d4, d1
1000504a:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000504e:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10005052:	ee05 0b41 	vmls.f64	d0, d5, d1
10005056:	ed9f eb48 	vldr	d14, [pc, #288]	@ 10005178 <fndsa_fp64e_mul+0x198>
1000505a:	eeb0 8b42 	vmov.f64	d8, d2
1000505e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005062:	eeb0 2b49 	vmov.f64	d2, d9
10005066:	ed9f 3b46 	vldr	d3, [pc, #280]	@ 10005180 <fndsa_fp64e_mul+0x1a0>
1000506a:	ee00 2b0e 	vmla.f64	d2, d0, d14
1000506e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005072:	eeb0 0b4c 	vmov.f64	d0, d12
10005076:	ee09 0b43 	vmls.f64	d0, d9, d3
1000507a:	eeb0 9b47 	vmov.f64	d9, d7
1000507e:	ee08 9b0e 	vmla.f64	d9, d8, d14
10005082:	eeb0 8b4b 	vmov.f64	d8, d11
10005086:	ee07 8b43 	vmls.f64	d8, d7, d3
1000508a:	ee20 7b08 	vmul.f64	d7, d0, d8
1000508e:	ee20 ab09 	vmul.f64	d10, d0, d9
10005092:	ee20 fb04 	vmul.f64	d15, d0, d4
10005096:	ee22 db04 	vmul.f64	d13, d2, d4
1000509a:	ee02 ab08 	vmla.f64	d10, d2, d8
1000509e:	ee02 fb09 	vmla.f64	d15, d2, d9
100050a2:	ee05 db09 	vmla.f64	d13, d5, d9
100050a6:	ee05 fb08 	vmla.f64	d15, d5, d8
100050aa:	ee27 7b06 	vmul.f64	d7, d7, d6
100050ae:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100050b2:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100050b6:	ee37 7b0a 	vadd.f64	d7, d7, d10
100050ba:	ee27 4b06 	vmul.f64	d4, d7, d6
100050be:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100050c2:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100050c6:	ed9f 5b30 	vldr	d5, [pc, #192]	@ 10005188 <fndsa_fp64e_mul+0x1a8>
100050ca:	ee3f 2b04 	vadd.f64	d2, d15, d4
100050ce:	ee04 7b43 	vmls.f64	d7, d4, d3
100050d2:	ee27 7b05 	vmul.f64	d7, d7, d5
100050d6:	ee22 5b06 	vmul.f64	d5, d2, d6
100050da:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100050de:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100050e2:	ee3d 4b05 	vadd.f64	d4, d13, d5
100050e6:	ee05 2b43 	vmls.f64	d2, d5, d3
100050ea:	ed9f 5b1d 	vldr	d5, [pc, #116]	@ 10005160 <fndsa_fp64e_mul+0x180>
100050ee:	ee24 6b06 	vmul.f64	d6, d4, d6
100050f2:	ee22 db05 	vmul.f64	d13, d2, d5
100050f6:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100050fa:	eebc dbcd 	vcvt.u32.f64	s26, d13
100050fe:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005102:	eeb8 db4d 	vcvt.f64.u32	d13, s26
10005106:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000510a:	ee06 4b43 	vmls.f64	d4, d6, d3
1000510e:	ee0d 2b41 	vmls.f64	d2, d13, d1
10005112:	eeb0 0b4d 	vmov.f64	d0, d13
10005116:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000511a:	ee04 0b0e 	vmla.f64	d0, d4, d14
1000511e:	ee02 7b01 	vmla.f64	d7, d2, d1
10005122:	ed9f 8b1b 	vldr	d8, [pc, #108]	@ 10005190 <fndsa_fp64e_mul+0x1b0>
10005126:	eeb0 1b47 	vmov.f64	d1, d7
1000512a:	ed9d 7b00 	vldr	d7, [sp]
1000512e:	ee30 0b08 	vadd.f64	d0, d0, d8
10005132:	ed9d 4b02 	vldr	d4, [sp, #8]
10005136:	ee07 0b4b 	vmls.f64	d0, d7, d11
1000513a:	ed9f 9b17 	vldr	d9, [pc, #92]	@ 10005198 <fndsa_fp64e_mul+0x1b8>
1000513e:	ee04 0b4c 	vmls.f64	d0, d4, d12
10005142:	ee20 9b09 	vmul.f64	d9, d0, d9
10005146:	eebc 9bc9 	vcvt.u32.f64	s18, d9
1000514a:	ed9f 7b15 	vldr	d7, [pc, #84]	@ 100051a0 <fndsa_fp64e_mul+0x1c0>
1000514e:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10005152:	ee09 0b47 	vmls.f64	d0, d9, d7
10005156:	b014      	add	sp, #80	@ 0x50
10005158:	ecbd 8b10 	vpop	{d8-d15}
1000515c:	4770      	bx	lr
1000515e:	bf00      	nop
10005160:	00000000 	.word	0x00000000
10005164:	3ef00000 	.word	0x3ef00000
10005168:	00000000 	.word	0x00000000
1000516c:	3e700000 	.word	0x3e700000
10005170:	00000000 	.word	0x00000000
10005174:	40f00000 	.word	0x40f00000
10005178:	00000000 	.word	0x00000000
1000517c:	40700000 	.word	0x40700000
10005180:	00000000 	.word	0x00000000
10005184:	41700000 	.word	0x41700000
10005188:	00000000 	.word	0x00000000
1000518c:	3f700000 	.word	0x3f700000
10005190:	00000000 	.word	0x00000000
10005194:	42000000 	.word	0x42000000
10005198:	00000000 	.word	0x00000000
1000519c:	3df00000 	.word	0x3df00000
100051a0:	00000000 	.word	0x00000000
100051a4:	41f00000 	.word	0x41f00000
