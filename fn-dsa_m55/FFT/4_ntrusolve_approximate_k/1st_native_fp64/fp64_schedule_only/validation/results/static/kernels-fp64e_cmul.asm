10001028 <fp64e_cmul>:
10001028:	ed2d 8b10 	vpush	{d8-d15}
1000102c:	eeb0 ab46 	vmov.f64	d10, d6
10001030:	eefc 6bc4 	vcvt.u32.f64	s13, d4
10001034:	ee16 2a90 	vmov	r2, s13
10001038:	eefc 6bca 	vcvt.u32.f64	s13, d10
1000103c:	ee16 3a90 	vmov	r3, s13
10001040:	eefc 6bc0 	vcvt.u32.f64	s13, d0
10001044:	ee16 0a90 	vmov	r0, s13
10001048:	eefc 6bc2 	vcvt.u32.f64	s13, d2
1000104c:	0fc0      	lsrs	r0, r0, #31
1000104e:	ee16 1a90 	vmov	r1, s13
10001052:	ee06 0a90 	vmov	s13, r0
10001056:	0fc9      	lsrs	r1, r1, #31
10001058:	eeb0 eb42 	vmov.f64	d14, d2
1000105c:	eeb8 2be6 	vcvt.f64.s32	d2, s13
10001060:	ee06 1a90 	vmov	s13, r1
10001064:	eeb8 6be6 	vcvt.f64.s32	d6, s13
10001068:	b0c8      	sub	sp, #288	@ 0x120
1000106a:	0fd2      	lsrs	r2, r2, #31
1000106c:	ed8d 6b20 	vstr	d6, [sp, #128]	@ 0x80
10001070:	ee06 2a90 	vmov	s13, r2
10001074:	0fdb      	lsrs	r3, r3, #31
10001076:	eeb0 cb44 	vmov.f64	d12, d4
1000107a:	eeb0 8b47 	vmov.f64	d8, d7
1000107e:	eeb8 4be6 	vcvt.f64.s32	d4, s13
10001082:	ee06 3a90 	vmov	s13, r3
10001086:	ed9f 7bfe 	vldr	d7, [pc, #1016]	@ 10001480 <fp64e_cmul+0x458>
1000108a:	eeb0 db40 	vmov.f64	d13, d0
1000108e:	ee35 9b08 	vadd.f64	d9, d5, d8
10001092:	eeb8 0be6 	vcvt.f64.s32	d0, s13
10001096:	eeb0 6b48 	vmov.f64	d6, d8
1000109a:	ee31 8b03 	vadd.f64	d8, d1, d3
1000109e:	ed8d 1b00 	vstr	d1, [sp]
100010a2:	ee3d bb0e 	vadd.f64	d11, d13, d14
100010a6:	ee28 1b07 	vmul.f64	d1, d8, d7
100010aa:	ed8d 2b1a 	vstr	d2, [sp, #104]	@ 0x68
100010ae:	eebc 1bc1 	vcvt.u32.f64	s2, d1
100010b2:	eeb0 2b4b 	vmov.f64	d2, d11
100010b6:	ee29 bb07 	vmul.f64	d11, d9, d7
100010ba:	ed9f fbf3 	vldr	d15, [pc, #972]	@ 10001488 <fp64e_cmul+0x460>
100010be:	eeb8 1b41 	vcvt.f64.u32	d1, s2
100010c2:	eebc bbcb 	vcvt.u32.f64	s22, d11
100010c6:	ee01 8b4f 	vmls.f64	d8, d1, d15
100010ca:	ed8d 0b22 	vstr	d0, [sp, #136]	@ 0x88
100010ce:	eeb8 bb4b 	vcvt.f64.u32	d11, s22
100010d2:	ee3c 0b0a 	vadd.f64	d0, d12, d10
100010d6:	ed8d 3b02 	vstr	d3, [sp, #8]
100010da:	ee0b 9b4f 	vmls.f64	d9, d11, d15
100010de:	ee25 3b07 	vmul.f64	d3, d5, d7
100010e2:	ed8d 4b1c 	vstr	d4, [sp, #112]	@ 0x70
100010e6:	ee30 0b0b 	vadd.f64	d0, d0, d11
100010ea:	ee26 4b07 	vmul.f64	d4, d6, d7
100010ee:	ed9d bb00 	vldr	d11, [sp]
100010f2:	ed8d 8b16 	vstr	d8, [sp, #88]	@ 0x58
100010f6:	ed9d 8b02 	vldr	d8, [sp, #8]
100010fa:	ed8d 9b04 	vstr	d9, [sp, #16]
100010fe:	ee24 8b08 	vmul.f64	d8, d4, d8
10001102:	ee32 9b01 	vadd.f64	d9, d2, d1
10001106:	ee24 4b0e 	vmul.f64	d4, d4, d14
1000110a:	ee2b 1b03 	vmul.f64	d1, d11, d3
1000110e:	ee2d 3b03 	vmul.f64	d3, d13, d3
10001112:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10001116:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000111a:	ed8d 5b06 	vstr	d5, [sp, #24]
1000111e:	ed8d 6b08 	vstr	d6, [sp, #32]
10001122:	ee2c 5b07 	vmul.f64	d5, d12, d7
10001126:	ee2a 6b07 	vmul.f64	d6, d10, d7
1000112a:	eeb8 2b44 	vcvt.f64.u32	d2, s8
1000112e:	eefc 3bc8 	vcvt.u32.f64	s7, d8
10001132:	ed9d 4b02 	vldr	d4, [sp, #8]
10001136:	eeb8 8b43 	vcvt.f64.u32	d8, s6
1000113a:	ee26 4b04 	vmul.f64	d4, d6, d4
1000113e:	ed8d 8b10 	vstr	d8, [sp, #64]	@ 0x40
10001142:	ee2b 8b05 	vmul.f64	d8, d11, d5
10001146:	ee2d 5b05 	vmul.f64	d5, d13, d5
1000114a:	ee26 6b0e 	vmul.f64	d6, d6, d14
1000114e:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10001152:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10001156:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000115a:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000115e:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10001162:	ed8d 4b0c 	vstr	d4, [sp, #48]	@ 0x30
10001166:	ee25 5b4f 	vnmul.f64	d5, d5, d15
1000116a:	eead 5b0c 	vfma.f64	d5, d13, d12
1000116e:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10001172:	ee35 4b0f 	vadd.f64	d4, d5, d15
10001176:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000117a:	ee20 5b07 	vmul.f64	d5, d0, d7
1000117e:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10001182:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10001186:	ee26 6b4f 	vnmul.f64	d6, d6, d15
1000118a:	eeae 6b0a 	vfma.f64	d6, d14, d10
1000118e:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10001192:	ee36 6b0f 	vadd.f64	d6, d6, d15
10001196:	eeb8 bb48 	vcvt.f64.u32	d11, s16
1000119a:	ed8d 4b14 	vstr	d4, [sp, #80]	@ 0x50
1000119e:	ed9d 8b06 	vldr	d8, [sp, #24]
100011a2:	ed9d 4b00 	vldr	d4, [sp]
100011a6:	ed8d 6b12 	vstr	d6, [sp, #72]	@ 0x48
100011aa:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100011ae:	ee21 6b4f 	vnmul.f64	d6, d1, d15
100011b2:	eea4 6b08 	vfma.f64	d6, d4, d8
100011b6:	ee36 6b0f 	vadd.f64	d6, d6, d15
100011ba:	ee05 0b4f 	vmls.f64	d0, d5, d15
100011be:	ee26 6b07 	vmul.f64	d6, d6, d7
100011c2:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100011c6:	eefc 6bc0 	vcvt.u32.f64	s13, d0
100011ca:	ee16 3a90 	vmov	r3, s13
100011ce:	0fdb      	lsrs	r3, r3, #31
100011d0:	ee05 3a90 	vmov	s11, r3
100011d4:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100011d8:	ed8d 0b0a 	vstr	d0, [sp, #40]	@ 0x28
100011dc:	ee36 6b01 	vadd.f64	d6, d6, d1
100011e0:	eeb7 0b00 	vmov.f64	d0, #112	@ 0x3f800000  1.0
100011e4:	eeb8 1be5 	vcvt.f64.s32	d1, s11
100011e8:	eeb8 3b63 	vcvt.f64.u32	d3, s7
100011ec:	ed8d 1b26 	vstr	d1, [sp, #152]	@ 0x98
100011f0:	ee36 1b40 	vsub.f64	d1, d6, d0
100011f4:	ed9d 8b02 	vldr	d8, [sp, #8]
100011f8:	ee29 5b07 	vmul.f64	d5, d9, d7
100011fc:	ed8d 1b18 	vstr	d1, [sp, #96]	@ 0x60
10001200:	ee23 6b4f 	vnmul.f64	d6, d3, d15
10001204:	ed9d 1b08 	vldr	d1, [sp, #32]
10001208:	eea8 6b01 	vfma.f64	d6, d8, d1
1000120c:	ee36 6b0f 	vadd.f64	d6, d6, d15
10001210:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10001214:	ee26 6b07 	vmul.f64	d6, d6, d7
10001218:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000121c:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10001220:	ee05 9b4f 	vmls.f64	d9, d5, d15
10001224:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10001228:	eeb0 5b49 	vmov.f64	d5, d9
1000122c:	ee36 6b03 	vadd.f64	d6, d6, d3
10001230:	ee36 3b40 	vsub.f64	d3, d6, d0
10001234:	eefc 6bc5 	vcvt.u32.f64	s13, d5
10001238:	ee16 3a90 	vmov	r3, s13
1000123c:	0fdb      	lsrs	r3, r3, #31
1000123e:	ee06 3a90 	vmov	s13, r3
10001242:	ed8d 3b1e 	vstr	d3, [sp, #120]	@ 0x78
10001246:	ee2b 1b4f 	vnmul.f64	d1, d11, d15
1000124a:	eea4 1b0c 	vfma.f64	d1, d4, d12
1000124e:	ed9d 3b0c 	vldr	d3, [sp, #48]	@ 0x30
10001252:	eeb0 cb45 	vmov.f64	d12, d5
10001256:	eeb8 5be6 	vcvt.f64.s32	d5, s13
1000125a:	ed9d 9b04 	vldr	d9, [sp, #16]
1000125e:	ed9d 6b0a 	vldr	d6, [sp, #40]	@ 0x28
10001262:	ed8d 5b24 	vstr	d5, [sp, #144]	@ 0x90
10001266:	ee23 3b4f 	vnmul.f64	d3, d3, d15
1000126a:	eea8 3b0a 	vfma.f64	d3, d8, d10
1000126e:	ed9d ab10 	vldr	d10, [sp, #64]	@ 0x40
10001272:	ee26 4b07 	vmul.f64	d4, d6, d7
10001276:	ee29 0b07 	vmul.f64	d0, d9, d7
1000127a:	ee2a 6b4f 	vnmul.f64	d6, d10, d15
1000127e:	ed9d 5b06 	vldr	d5, [sp, #24]
10001282:	eead 6b05 	vfma.f64	d6, d13, d5
10001286:	ee22 5b4f 	vnmul.f64	d5, d2, d15
1000128a:	ed9d db08 	vldr	d13, [sp, #32]
1000128e:	eeae 5b0d 	vfma.f64	d5, d14, d13
10001292:	ed9d eb16 	vldr	d14, [sp, #88]	@ 0x58
10001296:	ee20 9b0e 	vmul.f64	d9, d0, d14
1000129a:	ee20 0b0c 	vmul.f64	d0, d0, d12
1000129e:	ee31 1b0f 	vadd.f64	d1, d1, d15
100012a2:	ee33 3b0f 	vadd.f64	d3, d3, d15
100012a6:	eebc 0bc0 	vcvt.u32.f64	s0, d0
100012aa:	ee21 8b07 	vmul.f64	d8, d1, d7
100012ae:	eeb8 db40 	vcvt.f64.u32	d13, s0
100012b2:	ee23 0b07 	vmul.f64	d0, d3, d7
100012b6:	eebc 8bc8 	vcvt.u32.f64	s16, d8
100012ba:	eebc 0bc0 	vcvt.u32.f64	s0, d0
100012be:	ed9d ab0c 	vldr	d10, [sp, #48]	@ 0x30
100012c2:	eeb8 8b48 	vcvt.f64.u32	d8, s16
100012c6:	eeb8 0b40 	vcvt.f64.u32	d0, s0
100012ca:	ee36 6b0f 	vadd.f64	d6, d6, d15
100012ce:	ee08 1b4f 	vmls.f64	d1, d8, d15
100012d2:	ee00 3b4f 	vmls.f64	d3, d0, d15
100012d6:	ee3b 8b08 	vadd.f64	d8, d11, d8
100012da:	ee3a 0b00 	vadd.f64	d0, d10, d0
100012de:	ed9d bb18 	vldr	d11, [sp, #96]	@ 0x60
100012e2:	ed9d ab1e 	vldr	d10, [sp, #120]	@ 0x78
100012e6:	ee3b 1b01 	vadd.f64	d1, d11, d1
100012ea:	ee3a 3b03 	vadd.f64	d3, d10, d3
100012ee:	ee26 bb07 	vmul.f64	d11, d6, d7
100012f2:	ee24 ab0e 	vmul.f64	d10, d4, d14
100012f6:	ed8d 2b0e 	vstr	d2, [sp, #56]	@ 0x38
100012fa:	eefc abca 	vcvt.u32.f64	s21, d10
100012fe:	eeb7 2b00 	vmov.f64	d2, #112	@ 0x3f800000  1.0
10001302:	eebc abcb 	vcvt.u32.f64	s20, d11
10001306:	ee38 8b42 	vsub.f64	d8, d8, d2
1000130a:	eeb8 bb6a 	vcvt.f64.u32	d11, s21
1000130e:	ed8d 3b16 	vstr	d3, [sp, #88]	@ 0x58
10001312:	ee30 0b42 	vsub.f64	d0, d0, d2
10001316:	eeb0 3b42 	vmov.f64	d3, d2
1000131a:	ee24 4b0c 	vmul.f64	d4, d4, d12
1000131e:	ed9d 2b10 	vldr	d2, [sp, #64]	@ 0x40
10001322:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10001326:	eebc 9bc9 	vcvt.u32.f64	s18, d9
1000132a:	ee0a 6b4f 	vmls.f64	d6, d10, d15
1000132e:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10001332:	ee32 ab0a 	vadd.f64	d10, d2, d10
10001336:	ee35 5b0f 	vadd.f64	d5, d5, d15
1000133a:	eeb8 9b49 	vcvt.f64.u32	d9, s18
1000133e:	ee3a ab43 	vsub.f64	d10, d10, d3
10001342:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10001346:	ed9d 3b0a 	vldr	d3, [sp, #40]	@ 0x28
1000134a:	ee31 6b06 	vadd.f64	d6, d1, d6
1000134e:	ee38 ab0a 	vadd.f64	d10, d8, d10
10001352:	ee25 1b07 	vmul.f64	d1, d5, d7
10001356:	ed8d cb0c 	vstr	d12, [sp, #48]	@ 0x30
1000135a:	ed9d 8b04 	vldr	d8, [sp, #16]
1000135e:	ee24 4b4f 	vnmul.f64	d4, d4, d15
10001362:	eeac 4b03 	vfma.f64	d4, d12, d3
10001366:	ee34 cb0f 	vadd.f64	d12, d4, d15
1000136a:	ee29 4b4f 	vnmul.f64	d4, d9, d15
1000136e:	eeae 4b08 	vfma.f64	d4, d14, d8
10001372:	ee34 4b0f 	vadd.f64	d4, d4, d15
10001376:	eebc 1bc1 	vcvt.u32.f64	s2, d1
1000137a:	ee24 4b07 	vmul.f64	d4, d4, d7
1000137e:	ed9d 2b0e 	vldr	d2, [sp, #56]	@ 0x38
10001382:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10001386:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000138a:	ee01 5b4f 	vmls.f64	d5, d1, d15
1000138e:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10001392:	ee32 1b01 	vadd.f64	d1, d2, d1
10001396:	eeb7 2b00 	vmov.f64	d2, #112	@ 0x3f800000  1.0
1000139a:	ee34 9b09 	vadd.f64	d9, d4, d9
1000139e:	ee31 1b42 	vsub.f64	d1, d1, d2
100013a2:	ed9d 4b14 	vldr	d4, [sp, #80]	@ 0x50
100013a6:	ed9d 8b16 	vldr	d8, [sp, #88]	@ 0x58
100013aa:	ee30 1b01 	vadd.f64	d1, d0, d1
100013ae:	ee39 9b42 	vsub.f64	d9, d9, d2
100013b2:	ee24 0b07 	vmul.f64	d0, d4, d7
100013b6:	ed9d 2b12 	vldr	d2, [sp, #72]	@ 0x48
100013ba:	ee38 5b05 	vadd.f64	d5, d8, d5
100013be:	eebc 0bc0 	vcvt.u32.f64	s0, d0
100013c2:	ee2b 8b4f 	vnmul.f64	d8, d11, d15
100013c6:	eeae 8b03 	vfma.f64	d8, d14, d3
100013ca:	ee22 3b07 	vmul.f64	d3, d2, d7
100013ce:	eeb8 0b40 	vcvt.f64.u32	d0, s0
100013d2:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100013d6:	ee00 4b4f 	vmls.f64	d4, d0, d15
100013da:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100013de:	eeb0 0b42 	vmov.f64	d0, d2
100013e2:	ee38 8b0f 	vadd.f64	d8, d8, d15
100013e6:	ee03 0b4f 	vmls.f64	d0, d3, d15
100013ea:	ee34 4b0a 	vadd.f64	d4, d4, d10
100013ee:	ee2d 3b4f 	vnmul.f64	d3, d13, d15
100013f2:	ed9d ab04 	vldr	d10, [sp, #16]
100013f6:	ee30 0b01 	vadd.f64	d0, d0, d1
100013fa:	ed9d 1b0c 	vldr	d1, [sp, #48]	@ 0x30
100013fe:	eea1 3b0a 	vfma.f64	d3, d1, d10
10001402:	ee28 1b07 	vmul.f64	d1, d8, d7
10001406:	ee26 ab07 	vmul.f64	d10, d6, d7
1000140a:	eebc 1bc1 	vcvt.u32.f64	s2, d1
1000140e:	eebc abca 	vcvt.u32.f64	s20, d10
10001412:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10001416:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
1000141a:	ee01 8b4f 	vmls.f64	d8, d1, d15
1000141e:	eeb7 2b00 	vmov.f64	d2, #112	@ 0x3f800000  1.0
10001422:	ee39 8b08 	vadd.f64	d8, d9, d8
10001426:	ee3b 1b01 	vadd.f64	d1, d11, d1
1000142a:	ee34 4b0a 	vadd.f64	d4, d4, d10
1000142e:	ed9f 9b18 	vldr	d9, [pc, #96]	@ 10001490 <fp64e_cmul+0x468>
10001432:	ee31 1b42 	vsub.f64	d1, d1, d2
10001436:	ed9d bb06 	vldr	d11, [sp, #24]
1000143a:	ed9d 2b1a 	vldr	d2, [sp, #104]	@ 0x68
1000143e:	ee34 4b09 	vadd.f64	d4, d4, d9
10001442:	ed9d 9b00 	vldr	d9, [sp]
10001446:	ee02 4b4b 	vmls.f64	d4, d2, d11
1000144a:	ed9d 2b1c 	vldr	d2, [sp, #112]	@ 0x70
1000144e:	ee33 3b0f 	vadd.f64	d3, d3, d15
10001452:	ee02 4b49 	vmls.f64	d4, d2, d9
10001456:	ee25 9b07 	vmul.f64	d9, d5, d7
1000145a:	ee0a 6b4f 	vmls.f64	d6, d10, d15
1000145e:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10001462:	ee23 ab07 	vmul.f64	d10, d3, d7
10001466:	eeb8 9b49 	vcvt.f64.u32	d9, s18
1000146a:	eebc abca 	vcvt.u32.f64	s20, d10
1000146e:	ee09 5b4f 	vmls.f64	d5, d9, d15
10001472:	ee30 0b09 	vadd.f64	d0, d0, d9
10001476:	eeb8 9b4a 	vcvt.f64.u32	d9, s20
1000147a:	e00d      	b.n	10001498 <fp64e_cmul+0x470>
1000147c:	f3af 8000 	nop.w
10001480:	00000000 	.word	0x00000000
10001484:	3df00000 	.word	0x3df00000
10001488:	00000000 	.word	0x00000000
1000148c:	41f00000 	.word	0x41f00000
10001490:	00000000 	.word	0x00000000
10001494:	42000000 	.word	0x42000000
10001498:	ee09 3b4f 	vmls.f64	d3, d9, d15
1000149c:	ee3d 9b09 	vadd.f64	d9, d13, d9
100014a0:	eeb7 db00 	vmov.f64	d13, #112	@ 0x3f800000  1.0
100014a4:	ee39 9b4d 	vsub.f64	d9, d9, d13
100014a8:	ee31 9b09 	vadd.f64	d9, d1, d9
100014ac:	ee2c 1b07 	vmul.f64	d1, d12, d7
100014b0:	ee38 3b03 	vadd.f64	d3, d8, d3
100014b4:	eebc 1bc1 	vcvt.u32.f64	s2, d1
100014b8:	ee23 8b07 	vmul.f64	d8, d3, d7
100014bc:	ed1f bb0c 	vldr	d11, [pc, #-48]	@ 10001490 <fp64e_cmul+0x468>
100014c0:	eeb8 1b41 	vcvt.f64.u32	d1, s2
100014c4:	ed9d 2b20 	vldr	d2, [sp, #128]	@ 0x80
100014c8:	ee01 cb4f 	vmls.f64	d12, d1, d15
100014cc:	ee30 0b0b 	vadd.f64	d0, d0, d11
100014d0:	eebc 8bc8 	vcvt.u32.f64	s16, d8
100014d4:	ed9d bb08 	vldr	d11, [sp, #32]
100014d8:	ed9d ab02 	vldr	d10, [sp, #8]
100014dc:	ee02 0b4b 	vmls.f64	d0, d2, d11
100014e0:	eeb8 8b48 	vcvt.f64.u32	d8, s16
100014e4:	ed9d 2b22 	vldr	d2, [sp, #136]	@ 0x88
100014e8:	ee3c cb09 	vadd.f64	d12, d12, d9
100014ec:	ee02 0b4a 	vmls.f64	d0, d2, d10
100014f0:	ee08 3b4f 	vmls.f64	d3, d8, d15
100014f4:	ee3c cb08 	vadd.f64	d12, d12, d8
100014f8:	ee24 8b07 	vmul.f64	d8, d4, d7
100014fc:	ee20 1b07 	vmul.f64	d1, d0, d7
10001500:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10001504:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10001508:	eeb8 8b48 	vcvt.f64.u32	d8, s16
1000150c:	ed1f bb20 	vldr	d11, [pc, #-128]	@ 10001490 <fp64e_cmul+0x468>
10001510:	ee08 4b4f 	vmls.f64	d4, d8, d15
10001514:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10001518:	ee35 8b06 	vadd.f64	d8, d5, d6
1000151c:	ee36 6b0f 	vadd.f64	d6, d6, d15
10001520:	ee01 0b4f 	vmls.f64	d0, d1, d15
10001524:	ee3c cb0b 	vadd.f64	d12, d12, d11
10001528:	ee36 1b45 	vsub.f64	d1, d6, d5
1000152c:	ed9d 9b24 	vldr	d9, [sp, #144]	@ 0x90
10001530:	ee28 5b07 	vmul.f64	d5, d8, d7
10001534:	ed9d ab04 	vldr	d10, [sp, #16]
10001538:	ed9d 2b26 	vldr	d2, [sp, #152]	@ 0x98
1000153c:	ee09 cb4a 	vmls.f64	d12, d9, d10
10001540:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10001544:	ee02 cb4e 	vmls.f64	d12, d2, d14
10001548:	ee30 6b04 	vadd.f64	d6, d0, d4
1000154c:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10001550:	ee34 4b0f 	vadd.f64	d4, d4, d15
10001554:	ee36 6b05 	vadd.f64	d6, d6, d5
10001558:	ee34 0b40 	vsub.f64	d0, d4, d0
1000155c:	ee2c 4b07 	vmul.f64	d4, d12, d7
10001560:	ee05 8b4f 	vmls.f64	d8, d5, d15
10001564:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10001568:	ee26 5b07 	vmul.f64	d5, d6, d7
1000156c:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10001570:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10001574:	ee04 cb4f 	vmls.f64	d12, d4, d15
10001578:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000157c:	ee3c cb0f 	vadd.f64	d12, d12, d15
10001580:	ee05 6b4f 	vmls.f64	d6, d5, d15
10001584:	ee3c cb46 	vsub.f64	d12, d12, d6
10001588:	ee21 6b07 	vmul.f64	d6, d1, d7
1000158c:	ee33 3b0f 	vadd.f64	d3, d3, d15
10001590:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10001594:	ee33 3b48 	vsub.f64	d3, d3, d8
10001598:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000159c:	ee30 0b4d 	vsub.f64	d0, d0, d13
100015a0:	ee06 1b4f 	vmls.f64	d1, d6, d15
100015a4:	ee30 0b06 	vadd.f64	d0, d0, d6
100015a8:	ee23 6b07 	vmul.f64	d6, d3, d7
100015ac:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100015b0:	ee3c 2b4d 	vsub.f64	d2, d12, d13
100015b4:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100015b8:	ee32 2b06 	vadd.f64	d2, d2, d6
100015bc:	ee06 3b4f 	vmls.f64	d3, d6, d15
100015c0:	ee20 6b07 	vmul.f64	d6, d0, d7
100015c4:	ee22 7b07 	vmul.f64	d7, d2, d7
100015c8:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100015cc:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100015d0:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100015d4:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100015d8:	ee06 0b4f 	vmls.f64	d0, d6, d15
100015dc:	ee07 2b4f 	vmls.f64	d2, d7, d15
100015e0:	b048      	add	sp, #288	@ 0x120
100015e2:	ecbd 8b10 	vpop	{d8-d15}
100015e6:	4770      	bx	lr

