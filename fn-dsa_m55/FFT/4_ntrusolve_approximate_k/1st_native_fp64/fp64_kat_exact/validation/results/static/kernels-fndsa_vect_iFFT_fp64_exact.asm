
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_kat_exact/validation/build/kernels/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10000e28 <fndsa_vect_iFFT_fp64_exact.constprop.0>:
10000e28:	1e41      	subs	r1, r0, #1
10000e2a:	f000 82db 	beq.w	100013e4 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x5bc>
10000e2e:	2301      	movs	r3, #1
10000e30:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10000e34:	461f      	mov	r7, r3
10000e36:	ed2d 8b10 	vpush	{d8-d15}
10000e3a:	2010      	movs	r0, #16
10000e3c:	ed9f dbf4 	vldr	d13, [pc, #976]	@ 10001210 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x3e8>
10000e40:	ed9f fbf5 	vldr	d15, [pc, #980]	@ 10001218 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x3f0>
10000e44:	46ba      	mov	sl, r7
10000e46:	b0bb      	sub	sp, #236	@ 0xec
10000e48:	fa03 f401 	lsl.w	r4, r3, r1
10000e4c:	fa00 f301 	lsl.w	r3, r0, r1
10000e50:	9313      	str	r3, [sp, #76]	@ 0x4c
10000e52:	9415      	str	r4, [sp, #84]	@ 0x54
10000e54:	2700      	movs	r7, #0
10000e56:	2301      	movs	r3, #1
10000e58:	f04f 0b10 	mov.w	fp, #16
10000e5c:	46d1      	mov	r9, sl
10000e5e:	eeb7 eb00 	vmov.f64	d14, #112	@ 0x3f800000  1.0
10000e62:	463e      	mov	r6, r7
10000e64:	fa0a fa03 	lsl.w	sl, sl, r3
10000e68:	fa03 f801 	lsl.w	r8, r3, r1
10000e6c:	ea4f 130a 	mov.w	r3, sl, lsl #4
10000e70:	9311      	str	r3, [sp, #68]	@ 0x44
10000e72:	4bef      	ldr	r3, [pc, #956]	@ (10001230 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x408>)
10000e74:	fa0b fb01 	lsl.w	fp, fp, r1
10000e78:	eb08 0858 	add.w	r8, r8, r8, lsr #1
10000e7c:	eb0b 0503 	add.w	r5, fp, r3
10000e80:	eb03 1808 	add.w	r8, r3, r8, lsl #4
10000e84:	9b15      	ldr	r3, [sp, #84]	@ 0x54
10000e86:	4aeb      	ldr	r2, [pc, #940]	@ (10001234 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x40c>)
10000e88:	eba3 0309 	sub.w	r3, r3, r9
10000e8c:	9312      	str	r3, [sp, #72]	@ 0x48
10000e8e:	9114      	str	r1, [sp, #80]	@ 0x50
10000e90:	eb02 1b09 	add.w	fp, r2, r9, lsl #4
10000e94:	eb09 0306 	add.w	r3, r9, r6
10000e98:	429e      	cmp	r6, r3
10000e9a:	f080 8293 	bcs.w	100013c4 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x59c>
10000e9e:	edd5 7a02 	vldr	s15, [r5, #8]
10000ea2:	edd5 6a00 	vldr	s13, [r5]
10000ea6:	eeb8 5b67 	vcvt.f64.u32	d5, s15
10000eaa:	eeb8 3b66 	vcvt.f64.u32	d3, s13
10000eae:	ee3d 5b45 	vsub.f64	d5, d13, d5
10000eb2:	edd5 6a01 	vldr	s13, [r5, #4]
10000eb6:	edd5 7a03 	vldr	s15, [r5, #12]
10000eba:	eeb8 2b66 	vcvt.f64.u32	d2, s13
10000ebe:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10000ec2:	ee25 6b0f 	vmul.f64	d6, d5, d15
10000ec6:	ee3d 7b47 	vsub.f64	d7, d13, d7
10000eca:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10000ece:	ee37 7b4e 	vsub.f64	d7, d7, d14
10000ed2:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10000ed6:	ee37 7b06 	vadd.f64	d7, d7, d6
10000eda:	ee27 4b0f 	vmul.f64	d4, d7, d15
10000ede:	ee06 5b4d 	vmls.f64	d5, d6, d13
10000ee2:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10000ee6:	ed8d 5b06 	vstr	d5, [sp, #24]
10000eea:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10000eee:	ee33 5b05 	vadd.f64	d5, d3, d5
10000ef2:	ee04 7b4d 	vmls.f64	d7, d4, d13
10000ef6:	ee25 6b0f 	vmul.f64	d6, d5, d15
10000efa:	eeb0 4b47 	vmov.f64	d4, d7
10000efe:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10000f02:	ed8d 7b04 	vstr	d7, [sp, #16]
10000f06:	eeb8 7b46 	vcvt.f64.u32	d7, s12
10000f0a:	ee32 6b04 	vadd.f64	d6, d2, d4
10000f0e:	ee36 6b07 	vadd.f64	d6, d6, d7
10000f12:	ee07 5b4d 	vmls.f64	d5, d7, d13
10000f16:	ee26 7b0f 	vmul.f64	d7, d6, d15
10000f1a:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10000f1e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10000f22:	ee07 6b4d 	vmls.f64	d6, d7, d13
10000f26:	ed8d 3b0a 	vstr	d3, [sp, #40]	@ 0x28
10000f2a:	ed8d 2b08 	vstr	d2, [sp, #32]
10000f2e:	465f      	mov	r7, fp
10000f30:	ed8d 5b0e 	vstr	d5, [sp, #56]	@ 0x38
10000f34:	ed8d 6b0c 	vstr	d6, [sp, #48]	@ 0x30
10000f38:	4bbe      	ldr	r3, [pc, #760]	@ (10001234 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x40c>)
10000f3a:	9510      	str	r5, [sp, #64]	@ 0x40
10000f3c:	eb03 1106 	add.w	r1, r3, r6, lsl #4
10000f40:	9b12      	ldr	r3, [sp, #72]	@ 0x48
10000f42:	eb0b 1403 	add.w	r4, fp, r3, lsl #4
10000f46:	9b13      	ldr	r3, [sp, #76]	@ 0x4c
10000f48:	eb03 000b 	add.w	r0, r3, fp
10000f4c:	ed91 3b02 	vldr	d3, [r1, #8]
10000f50:	ed9d 4b08 	vldr	d4, [sp, #32]
10000f54:	ed97 2b02 	vldr	d2, [r7, #8]
10000f58:	ed94 7b02 	vldr	d7, [r4, #8]
10000f5c:	eeb0 0b44 	vmov.f64	d0, d4
10000f60:	ed8d 4b2a 	vstr	d4, [sp, #168]	@ 0xa8
10000f64:	ed9d 6b04 	vldr	d6, [sp, #16]
10000f68:	ee33 4b0d 	vadd.f64	d4, d3, d13
10000f6c:	ed91 5b00 	vldr	d5, [r1]
10000f70:	ee33 3b02 	vadd.f64	d3, d3, d2
10000f74:	ee34 4b42 	vsub.f64	d4, d4, d2
10000f78:	ed8d 6b2e 	vstr	d6, [sp, #184]	@ 0xb8
10000f7c:	ee37 2b0d 	vadd.f64	d2, d7, d13
10000f80:	ed90 6b02 	vldr	d6, [r0, #8]
10000f84:	ed97 9b00 	vldr	d9, [r7]
10000f88:	ee36 7b07 	vadd.f64	d7, d6, d7
10000f8c:	ee32 2b46 	vsub.f64	d2, d2, d6
10000f90:	ed9d 8b06 	vldr	d8, [sp, #24]
10000f94:	ee35 6b0d 	vadd.f64	d6, d5, d13
10000f98:	ed8d 8b30 	vstr	d8, [sp, #192]	@ 0xc0
10000f9c:	ee35 5b09 	vadd.f64	d5, d5, d9
10000fa0:	ee24 8b0f 	vmul.f64	d8, d4, d15
10000fa4:	ee36 6b49 	vsub.f64	d6, d6, d9
10000fa8:	ee27 9b0f 	vmul.f64	d9, d7, d15
10000fac:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10000fb0:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10000fb4:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10000fb8:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10000fbc:	ee08 4b4d 	vmls.f64	d4, d8, d13
10000fc0:	ee09 7b4d 	vmls.f64	d7, d9, d13
10000fc4:	ee36 6b4e 	vsub.f64	d6, d6, d14
10000fc8:	ee34 bb0e 	vadd.f64	d11, d4, d14
10000fcc:	ee36 6b08 	vadd.f64	d6, d6, d8
10000fd0:	ee23 4b0f 	vmul.f64	d4, d3, d15
10000fd4:	ee37 cb0e 	vadd.f64	d12, d7, d14
10000fd8:	ee22 8b0f 	vmul.f64	d8, d2, d15
10000fdc:	ed94 7b00 	vldr	d7, [r4]
10000fe0:	ed90 ab00 	vldr	d10, [r0]
10000fe4:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10000fe8:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10000fec:	ee37 7b0d 	vadd.f64	d7, d7, d13
10000ff0:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10000ff4:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10000ff8:	ee37 7b4a 	vsub.f64	d7, d7, d10
10000ffc:	ee35 5b04 	vadd.f64	d5, d5, d4
10001000:	ee08 2b4d 	vmls.f64	d2, d8, d13
10001004:	ee04 3b4d 	vmls.f64	d3, d4, d13
10001008:	ee37 7b4e 	vsub.f64	d7, d7, d14
1000100c:	ed94 4b00 	vldr	d4, [r4]
10001010:	ee37 7b08 	vadd.f64	d7, d7, d8
10001014:	ee34 4b0a 	vadd.f64	d4, d4, d10
10001018:	ee26 8b0f 	vmul.f64	d8, d6, d15
1000101c:	ee32 ab0e 	vadd.f64	d10, d2, d14
10001020:	ee25 2b0f 	vmul.f64	d2, d5, d15
10001024:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10001028:	eebc 2bc2 	vcvt.u32.f64	s4, d2
1000102c:	ee34 4b09 	vadd.f64	d4, d4, d9
10001030:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10001034:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10001038:	ee08 6b4d 	vmls.f64	d6, d8, d13
1000103c:	ee02 5b4d 	vmls.f64	d5, d2, d13
10001040:	ee24 8b0f 	vmul.f64	d8, d4, d15
10001044:	ee27 2b0f 	vmul.f64	d2, d7, d15
10001048:	eebc 8bc8 	vcvt.u32.f64	s16, d8
1000104c:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10001050:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10001054:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10001058:	ed9f 9b71 	vldr	d9, [pc, #452]	@ 10001220 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x3f8>
1000105c:	ee33 3b0e 	vadd.f64	d3, d3, d14
10001060:	ee08 4b4d 	vmls.f64	d4, d8, d13
10001064:	ee02 7b4d 	vmls.f64	d7, d2, d13
10001068:	ee36 6b09 	vadd.f64	d6, d6, d9
1000106c:	ee23 2b0f 	vmul.f64	d2, d3, d15
10001070:	ee35 5b09 	vadd.f64	d5, d5, d9
10001074:	ee34 4b09 	vadd.f64	d4, d4, d9
10001078:	ee37 7b09 	vadd.f64	d7, d7, d9
1000107c:	ee2b 9b0f 	vmul.f64	d9, d11, d15
10001080:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10001084:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10001088:	eeb8 2b42 	vcvt.f64.u32	d2, s4
1000108c:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10001090:	ee02 3b4d 	vmls.f64	d3, d2, d13
10001094:	ee36 6b09 	vadd.f64	d6, d6, d9
10001098:	ee09 bb4d 	vmls.f64	d11, d9, d13
1000109c:	eeb6 9b00 	vmov.f64	d9, #96	@ 0x3f000000  0.5
100010a0:	ee35 5b02 	vadd.f64	d5, d5, d2
100010a4:	ee2b 8b09 	vmul.f64	d8, d11, d9
100010a8:	ee23 3b09 	vmul.f64	d3, d3, d9
100010ac:	ee2c 2b0f 	vmul.f64	d2, d12, d15
100010b0:	ee2a bb0f 	vmul.f64	d11, d10, d15
100010b4:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100010b8:	eebc bbcb 	vcvt.u32.f64	s22, d11
100010bc:	eefc 3bc2 	vcvt.u32.f64	s7, d2
100010c0:	eeb8 bb4b 	vcvt.f64.u32	d11, s22
100010c4:	eeb8 9b43 	vcvt.f64.u32	d9, s6
100010c8:	eeb8 3b63 	vcvt.f64.u32	d3, s7
100010cc:	ee0b ab4d 	vmls.f64	d10, d11, d13
100010d0:	ee34 4b03 	vadd.f64	d4, d4, d3
100010d4:	ee03 cb4d 	vmls.f64	d12, d3, d13
100010d8:	eeb6 3b00 	vmov.f64	d3, #96	@ 0x3f000000  0.5
100010dc:	ee2c 2b03 	vmul.f64	d2, d12, d3
100010e0:	ee2a ab03 	vmul.f64	d10, d10, d3
100010e4:	ee26 3b0f 	vmul.f64	d3, d6, d15
100010e8:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100010ec:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100010f0:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100010f4:	ee37 7b0b 	vadd.f64	d7, d7, d11
100010f8:	eeb8 bb42 	vcvt.f64.u32	d11, s4
100010fc:	ee25 2b0f 	vmul.f64	d2, d5, d15
10001100:	ee03 6b4d 	vmls.f64	d6, d3, d13
10001104:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10001108:	eefc 6bc6 	vcvt.u32.f64	s13, d6
1000110c:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10001110:	ee16 3a90 	vmov	r3, s13
10001114:	ee02 5b4d 	vmls.f64	d5, d2, d13
10001118:	0fdd      	lsrs	r5, r3, #31
1000111a:	eefc 6bc5 	vcvt.u32.f64	s13, d5
1000111e:	ee05 5a10 	vmov	s10, r5
10001122:	085d      	lsrs	r5, r3, #1
10001124:	ee06 5a10 	vmov	s12, r5
10001128:	ee16 2a90 	vmov	r2, s13
1000112c:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10001130:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10001134:	f003 0301 	and.w	r3, r3, #1
10001138:	eeb8 8b48 	vcvt.f64.u32	d8, s16
1000113c:	eeb0 2b46 	vmov.f64	d2, d6
10001140:	ee06 3a90 	vmov	s13, r3
10001144:	ed9f 3b38 	vldr	d3, [pc, #224]	@ 10001228 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x400>
10001148:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
1000114c:	eeb8 6be6 	vcvt.f64.s32	d6, s13
10001150:	eeb0 cb48 	vmov.f64	d12, d8
10001154:	ea4f 0c52 	mov.w	ip, r2, lsr #1
10001158:	0fd5      	lsrs	r5, r2, #31
1000115a:	ee05 2b03 	vmla.f64	d2, d5, d3
1000115e:	ee06 cb03 	vmla.f64	d12, d6, d3
10001162:	ee05 5a10 	vmov	s10, r5
10001166:	ee06 ca90 	vmov	s13, ip
1000116a:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
1000116e:	eeb8 6be6 	vcvt.f64.s32	d6, s13
10001172:	ee05 6b03 	vmla.f64	d6, d5, d3
10001176:	f002 0201 	and.w	r2, r2, #1
1000117a:	ed81 6b00 	vstr	d6, [r1]
1000117e:	ee06 2a90 	vmov	s13, r2
10001182:	eeb8 6be6 	vcvt.f64.s32	d6, s13
10001186:	ee06 9b03 	vmla.f64	d9, d6, d3
1000118a:	ee24 6b0f 	vmul.f64	d6, d4, d15
1000118e:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10001192:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10001196:	ee27 5b0f 	vmul.f64	d5, d7, d15
1000119a:	ee06 4b4d 	vmls.f64	d4, d6, d13
1000119e:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100011a2:	eefc 6bc4 	vcvt.u32.f64	s13, d4
100011a6:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100011aa:	ee16 2a90 	vmov	r2, s13
100011ae:	ee05 7b4d 	vmls.f64	d7, d5, d13
100011b2:	0fd5      	lsrs	r5, r2, #31
100011b4:	ee06 5a10 	vmov	s12, r5
100011b8:	0855      	lsrs	r5, r2, #1
100011ba:	eefc 7bc7 	vcvt.u32.f64	s15, d7
100011be:	ee07 5a10 	vmov	s14, r5
100011c2:	ee17 3a90 	vmov	r3, s15
100011c6:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
100011ca:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100011ce:	ee06 7b03 	vmla.f64	d7, d6, d3
100011d2:	f002 0201 	and.w	r2, r2, #1
100011d6:	ed81 9b02 	vstr	d9, [r1, #8]
100011da:	ed84 7b00 	vstr	d7, [r4]
100011de:	ee07 2a90 	vmov	s15, r2
100011e2:	eeb8 7be7 	vcvt.f64.s32	d7, s15
100011e6:	0fda      	lsrs	r2, r3, #31
100011e8:	ee07 bb03 	vmla.f64	d11, d7, d3
100011ec:	ee07 2a10 	vmov	s14, r2
100011f0:	085a      	lsrs	r2, r3, #1
100011f2:	ee08 2a10 	vmov	s16, r2
100011f6:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100011fa:	eeb8 8bc8 	vcvt.f64.s32	d8, s16
100011fe:	f003 0301 	and.w	r3, r3, #1
10001202:	ee07 8b03 	vmla.f64	d8, d7, d3
10001206:	eebc abca 	vcvt.u32.f64	s20, d10
1000120a:	ee07 3a90 	vmov	s15, r3
1000120e:	e013      	b.n	10001238 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x410>
10001210:	00000000 	.word	0x00000000
10001214:	41f00000 	.word	0x41f00000
10001218:	00000000 	.word	0x00000000
1000121c:	3df00000 	.word	0x3df00000
	...
1000122c:	41e00000 	.word	0x41e00000
10001230:	300009a0 	.word	0x300009a0
10001234:	30015820 	.word	0x30015820
10001238:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
1000123c:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10001240:	ed9d 1b0a 	vldr	d1, [sp, #40]	@ 0x28
10001244:	ee07 ab03 	vmla.f64	d10, d7, d3
10001248:	ed84 bb02 	vstr	d11, [r4, #8]
1000124c:	eeb0 3b4c 	vmov.f64	d3, d12
10001250:	ed8d 1b2c 	vstr	d1, [sp, #176]	@ 0xb0
10001254:	ed8d 2b32 	vstr	d2, [sp, #200]	@ 0xc8
10001258:	ed8d cb34 	vstr	d12, [sp, #208]	@ 0xd0
1000125c:	ed8d 2b00 	vstr	d2, [sp]
10001260:	ed8d cb02 	vstr	d12, [sp, #8]
10001264:	ed8d 8b36 	vstr	d8, [sp, #216]	@ 0xd8
10001268:	ed8d ab38 	vstr	d10, [sp, #224]	@ 0xe0
1000126c:	f7ff fa54 	bl	10000718 <fndsa_fp64e_mul>
10001270:	eeb0 2b48 	vmov.f64	d2, d8
10001274:	eeb0 9b40 	vmov.f64	d9, d0
10001278:	eeb0 bb41 	vmov.f64	d11, d1
1000127c:	ed8d 0b16 	vstr	d0, [sp, #88]	@ 0x58
10001280:	ed8d 1b18 	vstr	d1, [sp, #96]	@ 0x60
10001284:	ed9d 0b04 	vldr	d0, [sp, #16]
10001288:	ed9d 1b06 	vldr	d1, [sp, #24]
1000128c:	eeb0 3b4a 	vmov.f64	d3, d10
10001290:	f7ff fa42 	bl	10000718 <fndsa_fp64e_mul>
10001294:	ed9d 6b02 	vldr	d6, [sp, #8]
10001298:	ee3a 3b06 	vadd.f64	d3, d10, d6
1000129c:	ee23 6b0f 	vmul.f64	d6, d3, d15
100012a0:	ed9d 2b00 	vldr	d2, [sp]
100012a4:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100012a8:	ee38 2b02 	vadd.f64	d2, d8, d2
100012ac:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100012b0:	ee32 2b06 	vadd.f64	d2, d2, d6
100012b4:	ee06 3b4d 	vmls.f64	d3, d6, d13
100012b8:	ee22 6b0f 	vmul.f64	d6, d2, d15
100012bc:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100012c0:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100012c4:	ed9d 7b0e 	vldr	d7, [sp, #56]	@ 0x38
100012c8:	eeb0 cb40 	vmov.f64	d12, d0
100012cc:	ee06 2b4d 	vmls.f64	d2, d6, d13
100012d0:	ed8d 0b1a 	vstr	d0, [sp, #104]	@ 0x68
100012d4:	ed9d 0b0c 	vldr	d0, [sp, #48]	@ 0x30
100012d8:	ed8d 1b1c 	vstr	d1, [sp, #112]	@ 0x70
100012dc:	ed8d 1b00 	vstr	d1, [sp]
100012e0:	eeb0 1b47 	vmov.f64	d1, d7
100012e4:	ed8d 0b26 	vstr	d0, [sp, #152]	@ 0x98
100012e8:	ed8d 7b28 	vstr	d7, [sp, #160]	@ 0xa0
100012ec:	ed8d 3b24 	vstr	d3, [sp, #144]	@ 0x90
100012f0:	ed8d 2b22 	vstr	d2, [sp, #136]	@ 0x88
100012f4:	f7ff fa10 	bl	10000718 <fndsa_fp64e_mul>
100012f8:	ed9d 7b00 	vldr	d7, [sp]
100012fc:	ee3b 6b07 	vadd.f64	d6, d11, d7
10001300:	ee26 5b0f 	vmul.f64	d5, d6, d15
10001304:	ee3b bb0d 	vadd.f64	d11, d11, d13
10001308:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000130c:	ee3b bb47 	vsub.f64	d11, d11, d7
10001310:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10001314:	ee39 7b0c 	vadd.f64	d7, d9, d12
10001318:	ee37 7b05 	vadd.f64	d7, d7, d5
1000131c:	ee27 4b0f 	vmul.f64	d4, d7, d15
10001320:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10001324:	ee05 6b4d 	vmls.f64	d6, d5, d13
10001328:	ed8d 1b20 	vstr	d1, [sp, #128]	@ 0x80
1000132c:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10001330:	ee31 1b0d 	vadd.f64	d1, d1, d13
10001334:	ee04 7b4d 	vmls.f64	d7, d4, d13
10001338:	ee31 6b46 	vsub.f64	d6, d1, d6
1000133c:	ed8d 0b1e 	vstr	d0, [sp, #120]	@ 0x78
10001340:	ee30 0b0d 	vadd.f64	d0, d0, d13
10001344:	ee30 0b47 	vsub.f64	d0, d0, d7
10001348:	ee26 7b0f 	vmul.f64	d7, d6, d15
1000134c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10001350:	ee30 0b4e 	vsub.f64	d0, d0, d14
10001354:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10001358:	ee2b 5b0f 	vmul.f64	d5, d11, d15
1000135c:	ee30 0b07 	vadd.f64	d0, d0, d7
10001360:	ee39 9b0d 	vadd.f64	d9, d9, d13
10001364:	ee07 6b4d 	vmls.f64	d6, d7, d13
10001368:	ee39 9b4c 	vsub.f64	d9, d9, d12
1000136c:	ee20 7b0f 	vmul.f64	d7, d0, d15
10001370:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10001374:	ee39 9b4e 	vsub.f64	d9, d9, d14
10001378:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000137c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10001380:	ee39 9b05 	vadd.f64	d9, d9, d5
10001384:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10001388:	ee07 0b4d 	vmls.f64	d0, d7, d13
1000138c:	ee29 7b0f 	vmul.f64	d7, d9, d15
10001390:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10001394:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10001398:	ee05 bb4d 	vmls.f64	d11, d5, d13
1000139c:	ee07 9b4d 	vmls.f64	d9, d7, d13
100013a0:	3110      	adds	r1, #16
100013a2:	3010      	adds	r0, #16
100013a4:	458b      	cmp	fp, r1
100013a6:	f107 0710 	add.w	r7, r7, #16
100013aa:	ed07 bb02 	vstr	d11, [r7, #-8]
100013ae:	ed07 9b04 	vstr	d9, [r7, #-16]
100013b2:	f104 0410 	add.w	r4, r4, #16
100013b6:	ed00 0b04 	vstr	d0, [r0, #-16]
100013ba:	ed00 6b02 	vstr	d6, [r0, #-8]
100013be:	f47f adc5 	bne.w	10000f4c <fndsa_vect_iFFT_fp64_exact.constprop.0+0x124>
100013c2:	9d10      	ldr	r5, [sp, #64]	@ 0x40
100013c4:	9b11      	ldr	r3, [sp, #68]	@ 0x44
100013c6:	3510      	adds	r5, #16
100013c8:	45a8      	cmp	r8, r5
100013ca:	4456      	add	r6, sl
100013cc:	449b      	add	fp, r3
100013ce:	f47f ad61 	bne.w	10000e94 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x6c>
100013d2:	9914      	ldr	r1, [sp, #80]	@ 0x50
100013d4:	3901      	subs	r1, #1
100013d6:	f47f ad3d 	bne.w	10000e54 <fndsa_vect_iFFT_fp64_exact.constprop.0+0x2c>
100013da:	b03b      	add	sp, #236	@ 0xec
100013dc:	ecbd 8b10 	vpop	{d8-d15}
100013e0:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
100013e4:	4770      	bx	lr
