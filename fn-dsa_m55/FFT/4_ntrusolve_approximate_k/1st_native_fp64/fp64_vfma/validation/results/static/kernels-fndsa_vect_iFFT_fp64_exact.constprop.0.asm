10000ec8 <fndsa_vect_iFFT_fp64_exact.constprop.0>:
10000ec8:	1e41      	subs	r1, r0, #1
10000eca:	f000 82b0 	beq.w	1000142e <fndsa_vect_iFFT_fp64_exact.constprop.0+0x566>
10000ece:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10000ed2:	2301      	movs	r3, #1
10000ed4:	ed2d 8b10 	vpush	{d8-d15}
10000ed8:	2010      	movs	r0, #16
10000eda:	ed9f db7f 	vldr	d13, [pc, #508]	@ 100010d8 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x210>
10000ede:	ed9f cb80 	vldr	d12, [pc, #512]	@ 100010e0 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x218>
10000ee2:	ed9f fb81 	vldr	d15, [pc, #516]	@ 100010e8 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x220>
10000ee6:	ed9f eb82 	vldr	d14, [pc, #520]	@ 100010f0 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x228>
10000eea:	b0af      	sub	sp, #188	@ 0xbc
10000eec:	fa03 f501 	lsl.w	r5, r3, r1
10000ef0:	469a      	mov	sl, r3
10000ef2:	fa00 f301 	lsl.w	r3, r0, r1
10000ef6:	9305      	str	r3, [sp, #20]
10000ef8:	9507      	str	r5, [sp, #28]
10000efa:	2701      	movs	r7, #1
10000efc:	f04f 0910 	mov.w	r9, #16
10000f00:	4652      	mov	r2, sl
10000f02:	fa0a fa07 	lsl.w	sl, sl, r7
10000f06:	ea4f 130a 	mov.w	r3, sl, lsl #4
10000f0a:	9302      	str	r3, [sp, #8]
10000f0c:	4b84      	ldr	r3, [pc, #528]	@ (10001120 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x258>)
10000f0e:	fa09 f901 	lsl.w	r9, r9, r1
10000f12:	eb09 0603 	add.w	r6, r9, r3
10000f16:	f04f 0900 	mov.w	r9, #0
10000f1a:	408f      	lsls	r7, r1
10000f1c:	eb07 0757 	add.w	r7, r7, r7, lsr #1
10000f20:	eb03 1707 	add.w	r7, r3, r7, lsl #4
10000f24:	9b07      	ldr	r3, [sp, #28]
10000f26:	487f      	ldr	r0, [pc, #508]	@ (10001124 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x25c>)
10000f28:	1a9b      	subs	r3, r3, r2
10000f2a:	9304      	str	r3, [sp, #16]
10000f2c:	9106      	str	r1, [sp, #24]
10000f2e:	9203      	str	r2, [sp, #12]
10000f30:	eb00 1802 	add.w	r8, r0, r2, lsl #4
10000f34:	edd6 7a02 	vldr	s15, [r6, #8]
10000f38:	6873      	ldr	r3, [r6, #4]
10000f3a:	eeb8 5b67 	vcvt.f64.u32	d5, s15
10000f3e:	0fdb      	lsrs	r3, r3, #31
10000f40:	ee03 3a10 	vmov	s6, r3
10000f44:	ee3d 5b45 	vsub.f64	d5, d13, d5
10000f48:	eeb8 3bc3 	vcvt.f64.s32	d3, s6
10000f4c:	edd6 7a03 	vldr	s15, [r6, #12]
10000f50:	ed8d 3b18 	vstr	d3, [sp, #96]	@ 0x60
10000f54:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10000f58:	ee25 3b0c 	vmul.f64	d3, d5, d12
10000f5c:	eeb7 bb00 	vmov.f64	d11, #112	@ 0x3f800000  1.0
10000f60:	edd6 6a00 	vldr	s13, [r6]
10000f64:	edd6 4a01 	vldr	s9, [r6, #4]
10000f68:	ee3d 7b47 	vsub.f64	d7, d13, d7
10000f6c:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10000f70:	eeb8 6b66 	vcvt.f64.u32	d6, s13
10000f74:	eeb8 4b64 	vcvt.f64.u32	d4, s9
10000f78:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10000f7c:	ed9f 0b5e 	vldr	d0, [pc, #376]	@ 100010f8 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x230>
10000f80:	ed9f 8b5f 	vldr	d8, [pc, #380]	@ 10001100 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x238>
10000f84:	ee37 7b4b 	vsub.f64	d7, d7, d11
10000f88:	ee03 5b4d 	vmls.f64	d5, d3, d13
10000f8c:	ee37 7b03 	vadd.f64	d7, d7, d3
10000f90:	ee24 2b00 	vmul.f64	d2, d4, d0
10000f94:	ee26 3b08 	vmul.f64	d3, d6, d8
10000f98:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10000f9c:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10000fa0:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10000fa4:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10000fa8:	ed9f 9b57 	vldr	d9, [pc, #348]	@ 10001108 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x240>
10000fac:	eeb0 1b44 	vmov.f64	d1, d4
10000fb0:	ed9f ab57 	vldr	d10, [pc, #348]	@ 10001110 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x248>
10000fb4:	ee02 1b49 	vmls.f64	d1, d2, d9
10000fb8:	ed8d 2b14 	vstr	d2, [sp, #80]	@ 0x50
10000fbc:	eeb0 2b43 	vmov.f64	d2, d3
10000fc0:	ee01 2b0a 	vmla.f64	d2, d1, d10
10000fc4:	ed9f 1b54 	vldr	d1, [pc, #336]	@ 10001118 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x250>
10000fc8:	ed8d 2b12 	vstr	d2, [sp, #72]	@ 0x48
10000fcc:	eeb0 2b46 	vmov.f64	d2, d6
10000fd0:	ee03 2b41 	vmls.f64	d2, d3, d1
10000fd4:	ee27 3b0c 	vmul.f64	d3, d7, d12
10000fd8:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10000fdc:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10000fe0:	ee03 7b4d 	vmls.f64	d7, d3, d13
10000fe4:	eebc 3bc7 	vcvt.u32.f64	s6, d7
10000fe8:	ee13 2a10 	vmov	r2, s6
10000fec:	0fd2      	lsrs	r2, r2, #31
10000fee:	ee03 2a10 	vmov	s6, r2
10000ff2:	ed8d 6b16 	vstr	d6, [sp, #88]	@ 0x58
10000ff6:	eeb8 3bc3 	vcvt.f64.s32	d3, s6
10000ffa:	ee36 6b05 	vadd.f64	d6, d6, d5
10000ffe:	ed8d 3b22 	vstr	d3, [sp, #136]	@ 0x88
10001002:	ee26 3b0c 	vmul.f64	d3, d6, d12
10001006:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000100a:	ee34 4b07 	vadd.f64	d4, d4, d7
1000100e:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10001012:	ee34 4b03 	vadd.f64	d4, d4, d3
10001016:	ee03 6b4d 	vmls.f64	d6, d3, d13
1000101a:	ed8d 2b10 	vstr	d2, [sp, #64]	@ 0x40
1000101e:	ee24 2b0c 	vmul.f64	d2, d4, d12
10001022:	ee26 3b08 	vmul.f64	d3, d6, d8
10001026:	eebc 2bc2 	vcvt.u32.f64	s4, d2
1000102a:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000102e:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10001032:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10001036:	ee02 4b4d 	vmls.f64	d4, d2, d13
1000103a:	ed9f 2b37 	vldr	d2, [pc, #220]	@ 10001118 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x250>
1000103e:	ed8d 6b2a 	vstr	d6, [sp, #168]	@ 0xa8
10001042:	ee03 6b42 	vmls.f64	d6, d3, d2
10001046:	ed8d 6b24 	vstr	d6, [sp, #144]	@ 0x90
1000104a:	eebc 6bc4 	vcvt.u32.f64	s12, d4
1000104e:	ee16 2a10 	vmov	r2, s12
10001052:	0fd2      	lsrs	r2, r2, #31
10001054:	ee06 2a10 	vmov	s12, r2
10001058:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
1000105c:	ed8d 6b2c 	vstr	d6, [sp, #176]	@ 0xb0
10001060:	ee27 6b00 	vmul.f64	d6, d7, d0
10001064:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10001068:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000106c:	ee06 7b49 	vmls.f64	d7, d6, d9
10001070:	ed8d 6b1e 	vstr	d6, [sp, #120]	@ 0x78
10001074:	ee24 6b00 	vmul.f64	d6, d4, d0
10001078:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000107c:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10001080:	ee06 4b49 	vmls.f64	d4, d6, d9
10001084:	ed8d 6b28 	vstr	d6, [sp, #160]	@ 0xa0
10001088:	ee25 6b08 	vmul.f64	d6, d5, d8
1000108c:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10001090:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10001094:	ed8d 5b20 	vstr	d5, [sp, #128]	@ 0x80
10001098:	ee04 3b0a 	vmla.f64	d3, d4, d10
1000109c:	ee06 5b42 	vmls.f64	d5, d6, d2
100010a0:	ee07 6b0a 	vmla.f64	d6, d7, d10
100010a4:	9b03      	ldr	r3, [sp, #12]
100010a6:	ed8d 3b26 	vstr	d3, [sp, #152]	@ 0x98
100010aa:	444b      	add	r3, r9
100010ac:	4599      	cmp	r9, r3
100010ae:	ed8d 5b1a 	vstr	d5, [sp, #104]	@ 0x68
100010b2:	ed8d 6b1c 	vstr	d6, [sp, #112]	@ 0x70
100010b6:	f080 81aa 	bcs.w	1000140e <fndsa_vect_iFFT_fp64_exact.constprop.0+0x546>
100010ba:	46c3      	mov	fp, r8
100010bc:	4b19      	ldr	r3, [pc, #100]	@ (10001124 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x25c>)
100010be:	9601      	str	r6, [sp, #4]
100010c0:	eb03 1109 	add.w	r1, r3, r9, lsl #4
100010c4:	9b04      	ldr	r3, [sp, #16]
100010c6:	eb08 1503 	add.w	r5, r8, r3, lsl #4
100010ca:	9b05      	ldr	r3, [sp, #20]
100010cc:	eb03 0408 	add.w	r4, r3, r8
100010d0:	e02a      	b.n	10001128 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x260>
100010d2:	bf00      	nop
100010d4:	f3af 8000 	nop.w
100010d8:	00000000 	.word	0x00000000
100010dc:	41f00000 	.word	0x41f00000
100010e0:	00000000 	.word	0x00000000
100010e4:	3df00000 	.word	0x3df00000
	...
100010f4:	41e00000 	.word	0x41e00000
100010f8:	00000000 	.word	0x00000000
100010fc:	3ef00000 	.word	0x3ef00000
10001100:	00000000 	.word	0x00000000
10001104:	3e700000 	.word	0x3e700000
10001108:	00000000 	.word	0x00000000
1000110c:	40f00000 	.word	0x40f00000
10001110:	00000000 	.word	0x00000000
10001114:	40700000 	.word	0x40700000
10001118:	00000000 	.word	0x00000000
1000111c:	41700000 	.word	0x41700000
10001120:	300009a0 	.word	0x300009a0
10001124:	3001b0e0 	.word	0x3001b0e0
10001128:	ed91 3b02 	vldr	d3, [r1, #8]
1000112c:	ed9b 6b02 	vldr	d6, [fp, #8]
10001130:	ed94 5b02 	vldr	d5, [r4, #8]
10001134:	ed95 2b02 	vldr	d2, [r5, #8]
10001138:	ee33 7b0d 	vadd.f64	d7, d3, d13
1000113c:	ee33 3b06 	vadd.f64	d3, d3, d6
10001140:	ee37 7b46 	vsub.f64	d7, d7, d6
10001144:	ee35 6b02 	vadd.f64	d6, d5, d2
10001148:	ee26 0b0c 	vmul.f64	d0, d6, d12
1000114c:	ee32 2b0d 	vadd.f64	d2, d2, d13
10001150:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10001154:	ee32 2b45 	vsub.f64	d2, d2, d5
10001158:	eeb8 0b40 	vcvt.f64.u32	d0, s0
1000115c:	ee27 5b0c 	vmul.f64	d5, d7, d12
10001160:	ed91 4b00 	vldr	d4, [r1]
10001164:	ee23 1b0c 	vmul.f64	d1, d3, d12
10001168:	ee00 6b4d 	vmls.f64	d6, d0, d13
1000116c:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10001170:	ed9b 9b00 	vldr	d9, [fp]
10001174:	ee36 8b0b 	vadd.f64	d8, d6, d11
10001178:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000117c:	ee34 6b0d 	vadd.f64	d6, d4, d13
10001180:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10001184:	ee05 7b4d 	vmls.f64	d7, d5, d13
10001188:	eeb8 1b41 	vcvt.f64.u32	d1, s2
1000118c:	ee39 4b04 	vadd.f64	d4, d9, d4
10001190:	ee36 6b49 	vsub.f64	d6, d6, d9
10001194:	ee34 4b01 	vadd.f64	d4, d4, d1
10001198:	ee37 9b0b 	vadd.f64	d9, d7, d11
1000119c:	ee01 3b4d 	vmls.f64	d3, d1, d13
100011a0:	ed95 7b00 	vldr	d7, [r5]
100011a4:	ee22 1b0c 	vmul.f64	d1, d2, d12
100011a8:	ee36 6b4b 	vsub.f64	d6, d6, d11
100011ac:	ed94 ab00 	vldr	d10, [r4]
100011b0:	ee36 6b05 	vadd.f64	d6, d6, d5
100011b4:	eebc 1bc1 	vcvt.u32.f64	s2, d1
100011b8:	ed95 5b00 	vldr	d5, [r5]
100011bc:	ee37 7b0d 	vadd.f64	d7, d7, d13
100011c0:	eeb8 1b41 	vcvt.f64.u32	d1, s2
100011c4:	ee35 5b0a 	vadd.f64	d5, d5, d10
100011c8:	ee37 7b4a 	vsub.f64	d7, d7, d10
100011cc:	ee35 5b00 	vadd.f64	d5, d5, d0
100011d0:	ee01 2b4d 	vmls.f64	d2, d1, d13
100011d4:	ee37 7b4b 	vsub.f64	d7, d7, d11
100011d8:	ee32 0b0b 	vadd.f64	d0, d2, d11
100011dc:	ee37 7b01 	vadd.f64	d7, d7, d1
100011e0:	ee25 2b0c 	vmul.f64	d2, d5, d12
100011e4:	ee24 1b0c 	vmul.f64	d1, d4, d12
100011e8:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100011ec:	eebc 1bc1 	vcvt.u32.f64	s2, d1
100011f0:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100011f4:	eeb8 1b41 	vcvt.f64.u32	d1, s2
100011f8:	ee02 5b4d 	vmls.f64	d5, d2, d13
100011fc:	ee01 4b4d 	vmls.f64	d4, d1, d13
10001200:	ee27 2b0c 	vmul.f64	d2, d7, d12
10001204:	ee26 1b0c 	vmul.f64	d1, d6, d12
10001208:	eebc 2bc2 	vcvt.u32.f64	s4, d2
1000120c:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10001210:	ee33 3b0b 	vadd.f64	d3, d3, d11
10001214:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10001218:	eeb8 2b42 	vcvt.f64.u32	d2, s4
1000121c:	ee01 6b4d 	vmls.f64	d6, d1, d13
10001220:	ee02 7b4d 	vmls.f64	d7, d2, d13
10001224:	ee28 1b0c 	vmul.f64	d1, d8, d12
10001228:	ee23 2b0c 	vmul.f64	d2, d3, d12
1000122c:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10001230:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10001234:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10001238:	eeb8 2b42 	vcvt.f64.u32	d2, s4
1000123c:	ee34 4b0f 	vadd.f64	d4, d4, d15
10001240:	ee01 8b4d 	vmls.f64	d8, d1, d13
10001244:	ee34 4b02 	vadd.f64	d4, d4, d2
10001248:	ee02 3b4d 	vmls.f64	d3, d2, d13
1000124c:	ee35 5b0f 	vadd.f64	d5, d5, d15
10001250:	eeb6 2b00 	vmov.f64	d2, #96	@ 0x3f000000  0.5
10001254:	ee35 5b01 	vadd.f64	d5, d5, d1
10001258:	ee23 3b02 	vmul.f64	d3, d3, d2
1000125c:	eeb0 1b42 	vmov.f64	d1, d2
10001260:	ee28 2b02 	vmul.f64	d2, d8, d2
10001264:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10001268:	eebc 2bc2 	vcvt.u32.f64	s4, d2
1000126c:	eeb8 8b43 	vcvt.f64.u32	d8, s6
10001270:	eeb8 ab42 	vcvt.f64.u32	d10, s4
10001274:	ee29 3b0c 	vmul.f64	d3, d9, d12
10001278:	ee20 2b0c 	vmul.f64	d2, d0, d12
1000127c:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10001280:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10001284:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10001288:	eeb8 2b42 	vcvt.f64.u32	d2, s4
1000128c:	ee36 6b0f 	vadd.f64	d6, d6, d15
10001290:	ee37 7b0f 	vadd.f64	d7, d7, d15
10001294:	ee36 6b03 	vadd.f64	d6, d6, d3
10001298:	ee03 9b4d 	vmls.f64	d9, d3, d13
1000129c:	ee02 0b4d 	vmls.f64	d0, d2, d13
100012a0:	eeb0 3b41 	vmov.f64	d3, d1
100012a4:	ee37 7b02 	vadd.f64	d7, d7, d2
100012a8:	ee24 2b0c 	vmul.f64	d2, d4, d12
100012ac:	ee20 0b03 	vmul.f64	d0, d0, d3
100012b0:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100012b4:	eebc 0bc0 	vcvt.u32.f64	s0, d0
100012b8:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100012bc:	eeb8 3b40 	vcvt.f64.u32	d3, s0
100012c0:	ee25 0b0c 	vmul.f64	d0, d5, d12
100012c4:	ee02 4b4d 	vmls.f64	d4, d2, d13
100012c8:	eebc 0bc0 	vcvt.u32.f64	s0, d0
100012cc:	eefc 4bc4 	vcvt.u32.f64	s9, d4
100012d0:	eeb8 0b40 	vcvt.f64.u32	d0, s0
100012d4:	ee14 2a90 	vmov	r2, s9
100012d8:	ee00 5b4d 	vmls.f64	d5, d0, d13
100012dc:	0fd6      	lsrs	r6, r2, #31
100012de:	ee04 6a10 	vmov	s8, r6
100012e2:	0856      	lsrs	r6, r2, #1
100012e4:	eefc 5bc5 	vcvt.u32.f64	s11, d5
100012e8:	ee05 6a10 	vmov	s10, r6
100012ec:	ee15 3a90 	vmov	r3, s11
100012f0:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
100012f4:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
100012f8:	ee04 5b0e 	vmla.f64	d5, d4, d14
100012fc:	f002 0201 	and.w	r2, r2, #1
10001300:	ed81 5b00 	vstr	d5, [r1]
10001304:	ee05 2a90 	vmov	s11, r2
10001308:	eeb8 5be5 	vcvt.f64.s32	d5, s11
1000130c:	ea4f 0c53 	mov.w	ip, r3, lsr #1
10001310:	0fde      	lsrs	r6, r3, #31
10001312:	ee05 8b0e 	vmla.f64	d8, d5, d14
10001316:	ee04 6a10 	vmov	s8, r6
1000131a:	ee05 ca90 	vmov	s11, ip
1000131e:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
10001322:	eeb8 5be5 	vcvt.f64.s32	d5, s11
10001326:	ee04 5b0e 	vmla.f64	d5, d4, d14
1000132a:	f003 0301 	and.w	r3, r3, #1
1000132e:	ed81 8b02 	vstr	d8, [r1, #8]
10001332:	ed85 5b00 	vstr	d5, [r5]
10001336:	ee05 3a90 	vmov	s11, r3
1000133a:	eeb8 5be5 	vcvt.f64.s32	d5, s11
1000133e:	ee05 ab0e 	vmla.f64	d10, d5, d14
10001342:	ee26 5b0c 	vmul.f64	d5, d6, d12
10001346:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000134a:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000134e:	ee05 6b4d 	vmls.f64	d6, d5, d13
10001352:	ee27 5b0c 	vmul.f64	d5, d7, d12
10001356:	eefc 6bc6 	vcvt.u32.f64	s13, d6
1000135a:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000135e:	ee16 3a90 	vmov	r3, s13
10001362:	eeb8 6b45 	vcvt.f64.u32	d6, s10
10001366:	ee06 7b4d 	vmls.f64	d7, d6, d13
1000136a:	eefc 7bc7 	vcvt.u32.f64	s15, d7
1000136e:	0fda      	lsrs	r2, r3, #31
10001370:	ee05 2a10 	vmov	s10, r2
10001374:	085a      	lsrs	r2, r3, #1
10001376:	f003 0301 	and.w	r3, r3, #1
1000137a:	ee06 3a90 	vmov	s13, r3
1000137e:	ee17 3a90 	vmov	r3, s15
10001382:	ee00 2a10 	vmov	s0, r2
10001386:	0fda      	lsrs	r2, r3, #31
10001388:	ee07 2a10 	vmov	s14, r2
1000138c:	085a      	lsrs	r2, r3, #1
1000138e:	ee02 2a10 	vmov	s4, r2
10001392:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10001396:	ee29 1b01 	vmul.f64	d1, d9, d1
1000139a:	eeb8 2bc2 	vcvt.f64.s32	d2, s4
1000139e:	f003 0301 	and.w	r3, r3, #1
100013a2:	ee07 2b0e 	vmla.f64	d2, d7, d14
100013a6:	eebc 1bc1 	vcvt.u32.f64	s2, d1
100013aa:	ee07 3a90 	vmov	s15, r3
100013ae:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
100013b2:	eeb8 6be6 	vcvt.f64.s32	d6, s13
100013b6:	eeb8 7be7 	vcvt.f64.s32	d7, s15
100013ba:	eeb8 1b41 	vcvt.f64.u32	d1, s2
100013be:	eeb8 0bc0 	vcvt.f64.s32	d0, s0
100013c2:	ee06 1b0e 	vmla.f64	d1, d6, d14
100013c6:	ee05 0b0e 	vmla.f64	d0, d5, d14
100013ca:	ee07 3b0e 	vmla.f64	d3, d7, d14
100013ce:	ed85 ab02 	vstr	d10, [r5, #8]
100013d2:	a810      	add	r0, sp, #64	@ 0x40
100013d4:	f7ff fae8 	bl	100009a8 <fp64e_cmul_prepared>
100013d8:	3110      	adds	r1, #16
100013da:	4588      	cmp	r8, r1
100013dc:	ed8b 0b00 	vstr	d0, [fp]
100013e0:	ed8b 1b02 	vstr	d1, [fp, #8]
100013e4:	ed8d 0b08 	vstr	d0, [sp, #32]
100013e8:	ed84 2b00 	vstr	d2, [r4]
100013ec:	ed84 3b02 	vstr	d3, [r4, #8]
100013f0:	ed8d 1b0a 	vstr	d1, [sp, #40]	@ 0x28
100013f4:	ed8d 2b0c 	vstr	d2, [sp, #48]	@ 0x30
100013f8:	ed8d 3b0e 	vstr	d3, [sp, #56]	@ 0x38
100013fc:	f105 0510 	add.w	r5, r5, #16
10001400:	f10b 0b10 	add.w	fp, fp, #16
10001404:	f104 0410 	add.w	r4, r4, #16
10001408:	f47f ae8e 	bne.w	10001128 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x260>
1000140c:	9e01      	ldr	r6, [sp, #4]
1000140e:	9b02      	ldr	r3, [sp, #8]
10001410:	3610      	adds	r6, #16
10001412:	42b7      	cmp	r7, r6
10001414:	44d1      	add	r9, sl
10001416:	4498      	add	r8, r3
10001418:	f47f ad8c 	bne.w	10000f34 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x6c>
1000141c:	9906      	ldr	r1, [sp, #24]
1000141e:	3901      	subs	r1, #1
10001420:	f47f ad6b 	bne.w	10000efa <fndsa_vect_iFFT_fp64_exact.constprop.0+0x32>
10001424:	b02f      	add	sp, #188	@ 0xbc
10001426:	ecbd 8b10 	vpop	{d8-d15}
1000142a:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
1000142e:	4770      	bx	lr

