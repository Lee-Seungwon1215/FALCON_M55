
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/r1-kernels/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10000e40 <fndsa_vect_iFFT_fp64_exact.constprop.0>:
10000e40:	1e41      	subs	r1, r0, #1
10000e42:	f000 82db 	beq.w	100013fc <fndsa_vect_iFFT_fp64_exact.constprop.0+0x5bc>
10000e46:	2301      	movs	r3, #1
10000e48:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10000e4c:	461f      	mov	r7, r3
10000e4e:	ed2d 8b10 	vpush	{d8-d15}
10000e52:	2010      	movs	r0, #16
10000e54:	ed9f dbf4 	vldr	d13, [pc, #976]	@ 10001228 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x3e8>
10000e58:	ed9f fbf5 	vldr	d15, [pc, #980]	@ 10001230 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x3f0>
10000e5c:	46ba      	mov	sl, r7
10000e5e:	b0bb      	sub	sp, #236	@ 0xec
10000e60:	fa03 f401 	lsl.w	r4, r3, r1
10000e64:	fa00 f301 	lsl.w	r3, r0, r1
10000e68:	9313      	str	r3, [sp, #76]	@ 0x4c
10000e6a:	9415      	str	r4, [sp, #84]	@ 0x54
10000e6c:	2700      	movs	r7, #0
10000e6e:	2301      	movs	r3, #1
10000e70:	f04f 0b10 	mov.w	fp, #16
10000e74:	46d1      	mov	r9, sl
10000e76:	eeb7 eb00 	vmov.f64	d14, #112	@ 0x3f800000  1.0
10000e7a:	463e      	mov	r6, r7
10000e7c:	fa0a fa03 	lsl.w	sl, sl, r3
10000e80:	fa03 f801 	lsl.w	r8, r3, r1
10000e84:	ea4f 130a 	mov.w	r3, sl, lsl #4
10000e88:	9311      	str	r3, [sp, #68]	@ 0x44
10000e8a:	4bef      	ldr	r3, [pc, #956]	@ (10001248 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x408>)
10000e8c:	fa0b fb01 	lsl.w	fp, fp, r1
10000e90:	eb08 0858 	add.w	r8, r8, r8, lsr #1
10000e94:	eb0b 0503 	add.w	r5, fp, r3
10000e98:	eb03 1808 	add.w	r8, r3, r8, lsl #4
10000e9c:	9b15      	ldr	r3, [sp, #84]	@ 0x54
10000e9e:	4aeb      	ldr	r2, [pc, #940]	@ (1000124c <fndsa_vect_iFFT_fp64_exact.constprop.0+0x40c>)
10000ea0:	eba3 0309 	sub.w	r3, r3, r9
10000ea4:	9312      	str	r3, [sp, #72]	@ 0x48
10000ea6:	9114      	str	r1, [sp, #80]	@ 0x50
10000ea8:	eb02 1b09 	add.w	fp, r2, r9, lsl #4
10000eac:	eb09 0306 	add.w	r3, r9, r6
10000eb0:	429e      	cmp	r6, r3
10000eb2:	f080 8293 	bcs.w	100013dc <fndsa_vect_iFFT_fp64_exact.constprop.0+0x59c>
10000eb6:	edd5 7a02 	vldr	s15, [r5, #8]
10000eba:	edd5 6a00 	vldr	s13, [r5]
10000ebe:	eeb8 5b67 	vcvt.f64.u32	d5, s15
10000ec2:	eeb8 3b66 	vcvt.f64.u32	d3, s13
10000ec6:	ee3d 5b45 	vsub.f64	d5, d13, d5
10000eca:	edd5 6a01 	vldr	s13, [r5, #4]
10000ece:	edd5 7a03 	vldr	s15, [r5, #12]
10000ed2:	eeb8 2b66 	vcvt.f64.u32	d2, s13
10000ed6:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10000eda:	ee25 6b0f 	vmul.f64	d6, d5, d15
10000ede:	ee3d 7b47 	vsub.f64	d7, d13, d7
10000ee2:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10000ee6:	ee37 7b4e 	vsub.f64	d7, d7, d14
10000eea:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10000eee:	ee37 7b06 	vadd.f64	d7, d7, d6
10000ef2:	ee27 4b0f 	vmul.f64	d4, d7, d15
10000ef6:	ee06 5b4d 	vmls.f64	d5, d6, d13
10000efa:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10000efe:	ed8d 5b06 	vstr	d5, [sp, #24]
10000f02:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10000f06:	ee33 5b05 	vadd.f64	d5, d3, d5
10000f0a:	ee04 7b4d 	vmls.f64	d7, d4, d13
10000f0e:	ee25 6b0f 	vmul.f64	d6, d5, d15
10000f12:	eeb0 4b47 	vmov.f64	d4, d7
10000f16:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10000f1a:	ed8d 7b04 	vstr	d7, [sp, #16]
10000f1e:	eeb8 7b46 	vcvt.f64.u32	d7, s12
10000f22:	ee32 6b04 	vadd.f64	d6, d2, d4
10000f26:	ee36 6b07 	vadd.f64	d6, d6, d7
10000f2a:	ee07 5b4d 	vmls.f64	d5, d7, d13
10000f2e:	ee26 7b0f 	vmul.f64	d7, d6, d15
10000f32:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10000f36:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10000f3a:	ee07 6b4d 	vmls.f64	d6, d7, d13
10000f3e:	ed8d 3b0a 	vstr	d3, [sp, #40]	@ 0x28
10000f42:	ed8d 2b08 	vstr	d2, [sp, #32]
10000f46:	465f      	mov	r7, fp
10000f48:	ed8d 5b0e 	vstr	d5, [sp, #56]	@ 0x38
10000f4c:	ed8d 6b0c 	vstr	d6, [sp, #48]	@ 0x30
10000f50:	4bbe      	ldr	r3, [pc, #760]	@ (1000124c <fndsa_vect_iFFT_fp64_exact.constprop.0+0x40c>)
10000f52:	9510      	str	r5, [sp, #64]	@ 0x40
10000f54:	eb03 1106 	add.w	r1, r3, r6, lsl #4
10000f58:	9b12      	ldr	r3, [sp, #72]	@ 0x48
10000f5a:	eb0b 1403 	add.w	r4, fp, r3, lsl #4
10000f5e:	9b13      	ldr	r3, [sp, #76]	@ 0x4c
10000f60:	eb03 000b 	add.w	r0, r3, fp
10000f64:	ed91 3b02 	vldr	d3, [r1, #8]
10000f68:	ed9d 4b08 	vldr	d4, [sp, #32]
10000f6c:	ed97 2b02 	vldr	d2, [r7, #8]
10000f70:	ed94 7b02 	vldr	d7, [r4, #8]
10000f74:	eeb0 0b44 	vmov.f64	d0, d4
10000f78:	ed8d 4b2a 	vstr	d4, [sp, #168]	@ 0xa8
10000f7c:	ed9d 6b04 	vldr	d6, [sp, #16]
10000f80:	ee33 4b0d 	vadd.f64	d4, d3, d13
10000f84:	ed91 5b00 	vldr	d5, [r1]
10000f88:	ee33 3b02 	vadd.f64	d3, d3, d2
10000f8c:	ee34 4b42 	vsub.f64	d4, d4, d2
10000f90:	ed8d 6b2e 	vstr	d6, [sp, #184]	@ 0xb8
10000f94:	ee37 2b0d 	vadd.f64	d2, d7, d13
10000f98:	ed90 6b02 	vldr	d6, [r0, #8]
10000f9c:	ed97 9b00 	vldr	d9, [r7]
10000fa0:	ee36 7b07 	vadd.f64	d7, d6, d7
10000fa4:	ee32 2b46 	vsub.f64	d2, d2, d6
10000fa8:	ed9d 8b06 	vldr	d8, [sp, #24]
10000fac:	ee35 6b0d 	vadd.f64	d6, d5, d13
10000fb0:	ed8d 8b30 	vstr	d8, [sp, #192]	@ 0xc0
10000fb4:	ee35 5b09 	vadd.f64	d5, d5, d9
10000fb8:	ee24 8b0f 	vmul.f64	d8, d4, d15
10000fbc:	ee36 6b49 	vsub.f64	d6, d6, d9
10000fc0:	ee27 9b0f 	vmul.f64	d9, d7, d15
10000fc4:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10000fc8:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10000fcc:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10000fd0:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10000fd4:	ee08 4b4d 	vmls.f64	d4, d8, d13
10000fd8:	ee09 7b4d 	vmls.f64	d7, d9, d13
10000fdc:	ee36 6b4e 	vsub.f64	d6, d6, d14
10000fe0:	ee34 bb0e 	vadd.f64	d11, d4, d14
10000fe4:	ee36 6b08 	vadd.f64	d6, d6, d8
10000fe8:	ee23 4b0f 	vmul.f64	d4, d3, d15
10000fec:	ee37 cb0e 	vadd.f64	d12, d7, d14
10000ff0:	ee22 8b0f 	vmul.f64	d8, d2, d15
10000ff4:	ed94 7b00 	vldr	d7, [r4]
10000ff8:	ed90 ab00 	vldr	d10, [r0]
10000ffc:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10001000:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10001004:	ee37 7b0d 	vadd.f64	d7, d7, d13
10001008:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000100c:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10001010:	ee37 7b4a 	vsub.f64	d7, d7, d10
10001014:	ee35 5b04 	vadd.f64	d5, d5, d4
10001018:	ee08 2b4d 	vmls.f64	d2, d8, d13
1000101c:	ee04 3b4d 	vmls.f64	d3, d4, d13
10001020:	ee37 7b4e 	vsub.f64	d7, d7, d14
10001024:	ed94 4b00 	vldr	d4, [r4]
10001028:	ee37 7b08 	vadd.f64	d7, d7, d8
1000102c:	ee34 4b0a 	vadd.f64	d4, d4, d10
10001030:	ee26 8b0f 	vmul.f64	d8, d6, d15
10001034:	ee32 ab0e 	vadd.f64	d10, d2, d14
10001038:	ee25 2b0f 	vmul.f64	d2, d5, d15
1000103c:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10001040:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10001044:	ee34 4b09 	vadd.f64	d4, d4, d9
10001048:	eeb8 8b48 	vcvt.f64.u32	d8, s16
1000104c:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10001050:	ee08 6b4d 	vmls.f64	d6, d8, d13
10001054:	ee02 5b4d 	vmls.f64	d5, d2, d13
10001058:	ee24 8b0f 	vmul.f64	d8, d4, d15
1000105c:	ee27 2b0f 	vmul.f64	d2, d7, d15
10001060:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10001064:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10001068:	eeb8 8b48 	vcvt.f64.u32	d8, s16
1000106c:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10001070:	ed9f 9b71 	vldr	d9, [pc, #452]	@ 10001238 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x3f8>
10001074:	ee33 3b0e 	vadd.f64	d3, d3, d14
10001078:	ee08 4b4d 	vmls.f64	d4, d8, d13
1000107c:	ee02 7b4d 	vmls.f64	d7, d2, d13
10001080:	ee36 6b09 	vadd.f64	d6, d6, d9
10001084:	ee23 2b0f 	vmul.f64	d2, d3, d15
10001088:	ee35 5b09 	vadd.f64	d5, d5, d9
1000108c:	ee34 4b09 	vadd.f64	d4, d4, d9
10001090:	ee37 7b09 	vadd.f64	d7, d7, d9
10001094:	ee2b 9b0f 	vmul.f64	d9, d11, d15
10001098:	eebc 2bc2 	vcvt.u32.f64	s4, d2
1000109c:	eebc 9bc9 	vcvt.u32.f64	s18, d9
100010a0:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100010a4:	eeb8 9b49 	vcvt.f64.u32	d9, s18
100010a8:	ee02 3b4d 	vmls.f64	d3, d2, d13
100010ac:	ee36 6b09 	vadd.f64	d6, d6, d9
100010b0:	ee09 bb4d 	vmls.f64	d11, d9, d13
100010b4:	eeb6 9b00 	vmov.f64	d9, #96	@ 0x3f000000  0.5
100010b8:	ee35 5b02 	vadd.f64	d5, d5, d2
100010bc:	ee2b 8b09 	vmul.f64	d8, d11, d9
100010c0:	ee23 3b09 	vmul.f64	d3, d3, d9
100010c4:	ee2c 2b0f 	vmul.f64	d2, d12, d15
100010c8:	ee2a bb0f 	vmul.f64	d11, d10, d15
100010cc:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100010d0:	eebc bbcb 	vcvt.u32.f64	s22, d11
100010d4:	eefc 3bc2 	vcvt.u32.f64	s7, d2
100010d8:	eeb8 bb4b 	vcvt.f64.u32	d11, s22
100010dc:	eeb8 9b43 	vcvt.f64.u32	d9, s6
100010e0:	eeb8 3b63 	vcvt.f64.u32	d3, s7
100010e4:	ee0b ab4d 	vmls.f64	d10, d11, d13
100010e8:	ee34 4b03 	vadd.f64	d4, d4, d3
100010ec:	ee03 cb4d 	vmls.f64	d12, d3, d13
100010f0:	eeb6 3b00 	vmov.f64	d3, #96	@ 0x3f000000  0.5
100010f4:	ee2c 2b03 	vmul.f64	d2, d12, d3
100010f8:	ee2a ab03 	vmul.f64	d10, d10, d3
100010fc:	ee26 3b0f 	vmul.f64	d3, d6, d15
10001100:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10001104:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10001108:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000110c:	ee37 7b0b 	vadd.f64	d7, d7, d11
10001110:	eeb8 bb42 	vcvt.f64.u32	d11, s4
10001114:	ee25 2b0f 	vmul.f64	d2, d5, d15
10001118:	ee03 6b4d 	vmls.f64	d6, d3, d13
1000111c:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10001120:	eefc 6bc6 	vcvt.u32.f64	s13, d6
10001124:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10001128:	ee16 3a90 	vmov	r3, s13
1000112c:	ee02 5b4d 	vmls.f64	d5, d2, d13
10001130:	0fdd      	lsrs	r5, r3, #31
10001132:	eefc 6bc5 	vcvt.u32.f64	s13, d5
10001136:	ee05 5a10 	vmov	s10, r5
1000113a:	085d      	lsrs	r5, r3, #1
1000113c:	ee06 5a10 	vmov	s12, r5
10001140:	ee16 2a90 	vmov	r2, s13
10001144:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10001148:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
1000114c:	f003 0301 	and.w	r3, r3, #1
10001150:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10001154:	eeb0 2b46 	vmov.f64	d2, d6
10001158:	ee06 3a90 	vmov	s13, r3
1000115c:	ed9f 3b38 	vldr	d3, [pc, #224]	@ 10001240 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x400>
10001160:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
10001164:	eeb8 6be6 	vcvt.f64.s32	d6, s13
10001168:	eeb0 cb48 	vmov.f64	d12, d8
1000116c:	ea4f 0c52 	mov.w	ip, r2, lsr #1
10001170:	0fd5      	lsrs	r5, r2, #31
10001172:	ee05 2b03 	vmla.f64	d2, d5, d3
10001176:	ee06 cb03 	vmla.f64	d12, d6, d3
1000117a:	ee05 5a10 	vmov	s10, r5
1000117e:	ee06 ca90 	vmov	s13, ip
10001182:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
10001186:	eeb8 6be6 	vcvt.f64.s32	d6, s13
1000118a:	ee05 6b03 	vmla.f64	d6, d5, d3
1000118e:	f002 0201 	and.w	r2, r2, #1
10001192:	ed81 6b00 	vstr	d6, [r1]
10001196:	ee06 2a90 	vmov	s13, r2
1000119a:	eeb8 6be6 	vcvt.f64.s32	d6, s13
1000119e:	ee06 9b03 	vmla.f64	d9, d6, d3
100011a2:	ee24 6b0f 	vmul.f64	d6, d4, d15
100011a6:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100011aa:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100011ae:	ee27 5b0f 	vmul.f64	d5, d7, d15
100011b2:	ee06 4b4d 	vmls.f64	d4, d6, d13
100011b6:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100011ba:	eefc 6bc4 	vcvt.u32.f64	s13, d4
100011be:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100011c2:	ee16 2a90 	vmov	r2, s13
100011c6:	ee05 7b4d 	vmls.f64	d7, d5, d13
100011ca:	0fd5      	lsrs	r5, r2, #31
100011cc:	ee06 5a10 	vmov	s12, r5
100011d0:	0855      	lsrs	r5, r2, #1
100011d2:	eefc 7bc7 	vcvt.u32.f64	s15, d7
100011d6:	ee07 5a10 	vmov	s14, r5
100011da:	ee17 3a90 	vmov	r3, s15
100011de:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
100011e2:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100011e6:	ee06 7b03 	vmla.f64	d7, d6, d3
100011ea:	f002 0201 	and.w	r2, r2, #1
100011ee:	ed81 9b02 	vstr	d9, [r1, #8]
100011f2:	ed84 7b00 	vstr	d7, [r4]
100011f6:	ee07 2a90 	vmov	s15, r2
100011fa:	eeb8 7be7 	vcvt.f64.s32	d7, s15
100011fe:	0fda      	lsrs	r2, r3, #31
10001200:	ee07 bb03 	vmla.f64	d11, d7, d3
10001204:	ee07 2a10 	vmov	s14, r2
10001208:	085a      	lsrs	r2, r3, #1
1000120a:	ee08 2a10 	vmov	s16, r2
1000120e:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10001212:	eeb8 8bc8 	vcvt.f64.s32	d8, s16
10001216:	f003 0301 	and.w	r3, r3, #1
1000121a:	ee07 8b03 	vmla.f64	d8, d7, d3
1000121e:	eebc abca 	vcvt.u32.f64	s20, d10
10001222:	ee07 3a90 	vmov	s15, r3
10001226:	e013      	b.n	10001250 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x410>
10001228:	00000000 	.word	0x00000000
1000122c:	41f00000 	.word	0x41f00000
10001230:	00000000 	.word	0x00000000
10001234:	3df00000 	.word	0x3df00000
	...
10001244:	41e00000 	.word	0x41e00000
10001248:	300009a0 	.word	0x300009a0
1000124c:	3001b0e0 	.word	0x3001b0e0
10001250:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10001254:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10001258:	ed9d 1b0a 	vldr	d1, [sp, #40]	@ 0x28
1000125c:	ee07 ab03 	vmla.f64	d10, d7, d3
10001260:	ed84 bb02 	vstr	d11, [r4, #8]
10001264:	eeb0 3b4c 	vmov.f64	d3, d12
10001268:	ed8d 1b2c 	vstr	d1, [sp, #176]	@ 0xb0
1000126c:	ed8d 2b32 	vstr	d2, [sp, #200]	@ 0xc8
10001270:	ed8d cb34 	vstr	d12, [sp, #208]	@ 0xd0
10001274:	ed8d 2b00 	vstr	d2, [sp]
10001278:	ed8d cb02 	vstr	d12, [sp, #8]
1000127c:	ed8d 8b36 	vstr	d8, [sp, #216]	@ 0xd8
10001280:	ed8d ab38 	vstr	d10, [sp, #224]	@ 0xe0
10001284:	f7ff fa48 	bl	10000718 <fndsa_fp64e_mul>
10001288:	eeb0 2b48 	vmov.f64	d2, d8
1000128c:	eeb0 9b40 	vmov.f64	d9, d0
10001290:	eeb0 bb41 	vmov.f64	d11, d1
10001294:	ed8d 0b16 	vstr	d0, [sp, #88]	@ 0x58
10001298:	ed8d 1b18 	vstr	d1, [sp, #96]	@ 0x60
1000129c:	ed9d 0b04 	vldr	d0, [sp, #16]
100012a0:	ed9d 1b06 	vldr	d1, [sp, #24]
100012a4:	eeb0 3b4a 	vmov.f64	d3, d10
100012a8:	f7ff fa36 	bl	10000718 <fndsa_fp64e_mul>
100012ac:	ed9d 6b02 	vldr	d6, [sp, #8]
100012b0:	ee3a 3b06 	vadd.f64	d3, d10, d6
100012b4:	ee23 6b0f 	vmul.f64	d6, d3, d15
100012b8:	ed9d 2b00 	vldr	d2, [sp]
100012bc:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100012c0:	ee38 2b02 	vadd.f64	d2, d8, d2
100012c4:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100012c8:	ee32 2b06 	vadd.f64	d2, d2, d6
100012cc:	ee06 3b4d 	vmls.f64	d3, d6, d13
100012d0:	ee22 6b0f 	vmul.f64	d6, d2, d15
100012d4:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100012d8:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100012dc:	ed9d 7b0e 	vldr	d7, [sp, #56]	@ 0x38
100012e0:	eeb0 cb40 	vmov.f64	d12, d0
100012e4:	ee06 2b4d 	vmls.f64	d2, d6, d13
100012e8:	ed8d 0b1a 	vstr	d0, [sp, #104]	@ 0x68
100012ec:	ed9d 0b0c 	vldr	d0, [sp, #48]	@ 0x30
100012f0:	ed8d 1b1c 	vstr	d1, [sp, #112]	@ 0x70
100012f4:	ed8d 1b00 	vstr	d1, [sp]
100012f8:	eeb0 1b47 	vmov.f64	d1, d7
100012fc:	ed8d 0b26 	vstr	d0, [sp, #152]	@ 0x98
10001300:	ed8d 7b28 	vstr	d7, [sp, #160]	@ 0xa0
10001304:	ed8d 3b24 	vstr	d3, [sp, #144]	@ 0x90
10001308:	ed8d 2b22 	vstr	d2, [sp, #136]	@ 0x88
1000130c:	f7ff fa04 	bl	10000718 <fndsa_fp64e_mul>
10001310:	ed9d 7b00 	vldr	d7, [sp]
10001314:	ee3b 6b07 	vadd.f64	d6, d11, d7
10001318:	ee26 5b0f 	vmul.f64	d5, d6, d15
1000131c:	ee3b bb0d 	vadd.f64	d11, d11, d13
10001320:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10001324:	ee3b bb47 	vsub.f64	d11, d11, d7
10001328:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000132c:	ee39 7b0c 	vadd.f64	d7, d9, d12
10001330:	ee37 7b05 	vadd.f64	d7, d7, d5
10001334:	ee27 4b0f 	vmul.f64	d4, d7, d15
10001338:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000133c:	ee05 6b4d 	vmls.f64	d6, d5, d13
10001340:	ed8d 1b20 	vstr	d1, [sp, #128]	@ 0x80
10001344:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10001348:	ee31 1b0d 	vadd.f64	d1, d1, d13
1000134c:	ee04 7b4d 	vmls.f64	d7, d4, d13
10001350:	ee31 6b46 	vsub.f64	d6, d1, d6
10001354:	ed8d 0b1e 	vstr	d0, [sp, #120]	@ 0x78
10001358:	ee30 0b0d 	vadd.f64	d0, d0, d13
1000135c:	ee30 0b47 	vsub.f64	d0, d0, d7
10001360:	ee26 7b0f 	vmul.f64	d7, d6, d15
10001364:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10001368:	ee30 0b4e 	vsub.f64	d0, d0, d14
1000136c:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10001370:	ee2b 5b0f 	vmul.f64	d5, d11, d15
10001374:	ee30 0b07 	vadd.f64	d0, d0, d7
10001378:	ee39 9b0d 	vadd.f64	d9, d9, d13
1000137c:	ee07 6b4d 	vmls.f64	d6, d7, d13
10001380:	ee39 9b4c 	vsub.f64	d9, d9, d12
10001384:	ee20 7b0f 	vmul.f64	d7, d0, d15
10001388:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000138c:	ee39 9b4e 	vsub.f64	d9, d9, d14
10001390:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10001394:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10001398:	ee39 9b05 	vadd.f64	d9, d9, d5
1000139c:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100013a0:	ee07 0b4d 	vmls.f64	d0, d7, d13
100013a4:	ee29 7b0f 	vmul.f64	d7, d9, d15
100013a8:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100013ac:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100013b0:	ee05 bb4d 	vmls.f64	d11, d5, d13
100013b4:	ee07 9b4d 	vmls.f64	d9, d7, d13
100013b8:	3110      	adds	r1, #16
100013ba:	3010      	adds	r0, #16
100013bc:	458b      	cmp	fp, r1
100013be:	f107 0710 	add.w	r7, r7, #16
100013c2:	ed07 bb02 	vstr	d11, [r7, #-8]
100013c6:	ed07 9b04 	vstr	d9, [r7, #-16]
100013ca:	f104 0410 	add.w	r4, r4, #16
100013ce:	ed00 0b04 	vstr	d0, [r0, #-16]
100013d2:	ed00 6b02 	vstr	d6, [r0, #-8]
100013d6:	f47f adc5 	bne.w	10000f64 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x124>
100013da:	9d10      	ldr	r5, [sp, #64]	@ 0x40
100013dc:	9b11      	ldr	r3, [sp, #68]	@ 0x44
100013de:	3510      	adds	r5, #16
100013e0:	45a8      	cmp	r8, r5
100013e2:	4456      	add	r6, sl
100013e4:	449b      	add	fp, r3
100013e6:	f47f ad61 	bne.w	10000eac <fndsa_vect_iFFT_fp64_exact.constprop.0+0x6c>
100013ea:	9914      	ldr	r1, [sp, #80]	@ 0x50
100013ec:	3901      	subs	r1, #1
100013ee:	f47f ad3d 	bne.w	10000e6c <fndsa_vect_iFFT_fp64_exact.constprop.0+0x2c>
100013f2:	b03b      	add	sp, #236	@ 0xec
100013f4:	ecbd 8b10 	vpop	{d8-d15}
100013f8:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
100013fc:	4770      	bx	lr
