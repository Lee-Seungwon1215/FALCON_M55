
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/r2-kernels/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10000f30 <fndsa_vect_FFT_fp64_exact.constprop.0>:
10000f30:	2801      	cmp	r0, #1
10000f32:	f240 8265 	bls.w	10001400 <fndsa_vect_FFT_fp64_exact.constprop.0+0x4d0>
10000f36:	2101      	movs	r1, #1
10000f38:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10000f3c:	2310      	movs	r3, #16
10000f3e:	ed2d 8b10 	vpush	{d8-d15}
10000f42:	460c      	mov	r4, r1
10000f44:	ed9f cb6c 	vldr	d12, [pc, #432]	@ 100010f8 <fndsa_vect_FFT_fp64_exact.constprop.0+0x1c8>
10000f48:	ed9f bb6d 	vldr	d11, [pc, #436]	@ 10001100 <fndsa_vect_FFT_fp64_exact.constprop.0+0x1d0>
10000f4c:	1e42      	subs	r2, r0, #1
10000f4e:	4093      	lsls	r3, r2
10000f50:	fa01 fe02 	lsl.w	lr, r1, r2
10000f54:	4a76      	ldr	r2, [pc, #472]	@ (10001130 <fndsa_vect_FFT_fp64_exact.constprop.0+0x200>)
10000f56:	b0d7      	sub	sp, #348	@ 0x15c
10000f58:	189f      	adds	r7, r3, r2
10000f5a:	e9cd 7016 	strd	r7, r0, [sp, #88]	@ 0x58
10000f5e:	2701      	movs	r7, #1
10000f60:	2310      	movs	r3, #16
10000f62:	2200      	movs	r2, #0
10000f64:	4d72      	ldr	r5, [pc, #456]	@ (10001130 <fndsa_vect_FFT_fp64_exact.constprop.0+0x200>)
10000f66:	4670      	mov	r0, lr
10000f68:	fa2e fe07 	lsr.w	lr, lr, r7
10000f6c:	ea4f 1c0e 	mov.w	ip, lr, lsl #4
10000f70:	eb05 1b0e 	add.w	fp, r5, lr, lsl #4
10000f74:	f10c 0508 	add.w	r5, ip, #8
10000f78:	9514      	str	r5, [sp, #80]	@ 0x50
10000f7a:	40a7      	lsls	r7, r4
10000f7c:	4d6d      	ldr	r5, [pc, #436]	@ (10001134 <fndsa_vect_FFT_fp64_exact.constprop.0+0x204>)
10000f7e:	40a3      	lsls	r3, r4
10000f80:	eb07 0757 	add.w	r7, r7, r7, lsr #1
10000f84:	442b      	add	r3, r5
10000f86:	eb05 1507 	add.w	r5, r5, r7, lsl #4
10000f8a:	e9cd e512 	strd	lr, r5, [sp, #72]	@ 0x48
10000f8e:	9916      	ldr	r1, [sp, #88]	@ 0x58
10000f90:	f10d 0aa0 	add.w	sl, sp, #160	@ 0xa0
10000f94:	9415      	str	r4, [sp, #84]	@ 0x54
10000f96:	edd3 7a00 	vldr	s15, [r3]
10000f9a:	eeb8 9b67 	vcvt.f64.u32	d9, s15
10000f9e:	edd3 7a02 	vldr	s15, [r3, #8]
10000fa2:	eeb8 4b67 	vcvt.f64.u32	d4, s15
10000fa6:	edd3 7a01 	vldr	s15, [r3, #4]
10000faa:	eeb8 8b67 	vcvt.f64.u32	d8, s15
10000fae:	edd3 7a03 	vldr	s15, [r3, #12]
10000fb2:	685c      	ldr	r4, [r3, #4]
10000fb4:	ed9f ab54 	vldr	d10, [pc, #336]	@ 10001108 <fndsa_vect_FFT_fp64_exact.constprop.0+0x1d8>
10000fb8:	0fe4      	lsrs	r4, r4, #31
10000fba:	ee06 4a10 	vmov	s12, r4
10000fbe:	ee17 4a90 	vmov	r4, s15
10000fc2:	0fe4      	lsrs	r4, r4, #31
10000fc4:	ee29 3b0a 	vmul.f64	d3, d9, d10
10000fc8:	ee07 4a10 	vmov	s14, r4
10000fcc:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10000fd0:	eeb8 0b67 	vcvt.f64.u32	d0, s15
10000fd4:	ed8d 6b40 	vstr	d6, [sp, #256]	@ 0x100
10000fd8:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10000fdc:	ee39 6b04 	vadd.f64	d6, d9, d4
10000fe0:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10000fe4:	ed9f db4a 	vldr	d13, [pc, #296]	@ 10001110 <fndsa_vect_FFT_fp64_exact.constprop.0+0x1e0>
10000fe8:	ed9f eb4b 	vldr	d14, [pc, #300]	@ 10001118 <fndsa_vect_FFT_fp64_exact.constprop.0+0x1e8>
10000fec:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10000ff0:	ed8d 7b4a 	vstr	d7, [sp, #296]	@ 0x128
10000ff4:	ee26 7b0c 	vmul.f64	d7, d6, d12
10000ff8:	ee20 2b0d 	vmul.f64	d2, d0, d13
10000ffc:	ee24 5b0a 	vmul.f64	d5, d4, d10
10001000:	ed8d 9b3e 	vstr	d9, [sp, #248]	@ 0xf8
10001004:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10001008:	ee03 9b4e 	vmls.f64	d9, d3, d14
1000100c:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10001010:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10001014:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10001018:	ed8d 9b38 	vstr	d9, [sp, #224]	@ 0xe0
1000101c:	ee38 9b00 	vadd.f64	d9, d8, d0
10001020:	ee07 6b4b 	vmls.f64	d6, d7, d11
10001024:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10001028:	ee39 7b07 	vadd.f64	d7, d9, d7
1000102c:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10001030:	ed9f 9b3b 	vldr	d9, [pc, #236]	@ 10001120 <fndsa_vect_FFT_fp64_exact.constprop.0+0x1f0>
10001034:	ed9f fb3c 	vldr	d15, [pc, #240]	@ 10001128 <fndsa_vect_FFT_fp64_exact.constprop.0+0x1f8>
10001038:	ee02 0b49 	vmls.f64	d0, d2, d9
1000103c:	ed8d 4b48 	vstr	d4, [sp, #288]	@ 0x120
10001040:	ee05 4b4e 	vmls.f64	d4, d5, d14
10001044:	ee00 5b0f 	vmla.f64	d5, d0, d15
10001048:	ed8d 4b42 	vstr	d4, [sp, #264]	@ 0x108
1000104c:	ee27 4b0c 	vmul.f64	d4, d7, d12
10001050:	ed8d 5b44 	vstr	d5, [sp, #272]	@ 0x110
10001054:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10001058:	ee26 5b0a 	vmul.f64	d5, d6, d10
1000105c:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10001060:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10001064:	ee04 7b4b 	vmls.f64	d7, d4, d11
10001068:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000106c:	ee27 4b0d 	vmul.f64	d4, d7, d13
10001070:	ee28 1b0d 	vmul.f64	d1, d8, d13
10001074:	ed8d 6b52 	vstr	d6, [sp, #328]	@ 0x148
10001078:	ee05 6b4e 	vmls.f64	d6, d5, d14
1000107c:	ed8d 2b46 	vstr	d2, [sp, #280]	@ 0x118
10001080:	eefc 2bc7 	vcvt.u32.f64	s5, d7
10001084:	ed8d 6b4c 	vstr	d6, [sp, #304]	@ 0x130
10001088:	eebc 1bc1 	vcvt.u32.f64	s2, d1
1000108c:	eebc 6bc4 	vcvt.u32.f64	s12, d4
10001090:	ee12 5a90 	vmov	r5, s5
10001094:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10001098:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000109c:	0fed      	lsrs	r5, r5, #31
1000109e:	ee01 8b49 	vmls.f64	d8, d1, d9
100010a2:	ee04 5a10 	vmov	s8, r5
100010a6:	ee06 7b49 	vmls.f64	d7, d6, d9
100010aa:	ee08 3b0f 	vmla.f64	d3, d8, d15
100010ae:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
100010b2:	ee07 5b0f 	vmla.f64	d5, d7, d15
100010b6:	9c12      	ldr	r4, [sp, #72]	@ 0x48
100010b8:	ed8d 1b3c 	vstr	d1, [sp, #240]	@ 0xf0
100010bc:	4414      	add	r4, r2
100010be:	42a2      	cmp	r2, r4
100010c0:	ed8d 3b3a 	vstr	d3, [sp, #232]	@ 0xe8
100010c4:	ed8d 4b54 	vstr	d4, [sp, #336]	@ 0x150
100010c8:	ed8d 6b50 	vstr	d6, [sp, #320]	@ 0x140
100010cc:	ed8d 5b4e 	vstr	d5, [sp, #312]	@ 0x138
100010d0:	f080 817f 	bcs.w	100013d2 <fndsa_vect_FFT_fp64_exact.constprop.0+0x4a2>
100010d4:	9e14      	ldr	r6, [sp, #80]	@ 0x50
100010d6:	eeb7 db00 	vmov.f64	d13, #112	@ 0x3f800000  1.0
100010da:	eb06 0801 	add.w	r8, r6, r1
100010de:	460d      	mov	r5, r1
100010e0:	461e      	mov	r6, r3
100010e2:	4c13      	ldr	r4, [pc, #76]	@ (10001130 <fndsa_vect_FFT_fp64_exact.constprop.0+0x200>)
100010e4:	e9cd 200f 	strd	r2, r0, [sp, #60]	@ 0x3c
100010e8:	eb04 1402 	add.w	r4, r4, r2, lsl #4
100010ec:	f10b 0908 	add.w	r9, fp, #8
100010f0:	af2c      	add	r7, sp, #176	@ 0xb0
100010f2:	9111      	str	r1, [sp, #68]	@ 0x44
100010f4:	e020      	b.n	10001138 <fndsa_vect_FFT_fp64_exact.constprop.0+0x208>
100010f6:	bf00      	nop
100010f8:	00000000 	.word	0x00000000
100010fc:	3df00000 	.word	0x3df00000
10001100:	00000000 	.word	0x00000000
10001104:	41f00000 	.word	0x41f00000
10001108:	00000000 	.word	0x00000000
1000110c:	3e700000 	.word	0x3e700000
10001110:	00000000 	.word	0x00000000
10001114:	3ef00000 	.word	0x3ef00000
10001118:	00000000 	.word	0x00000000
1000111c:	41700000 	.word	0x41700000
10001120:	00000000 	.word	0x00000000
10001124:	40f00000 	.word	0x40f00000
10001128:	00000000 	.word	0x00000000
1000112c:	40700000 	.word	0x40700000
10001130:	3001b0e0 	.word	0x3001b0e0
10001134:	300009a0 	.word	0x300009a0
10001138:	ed95 3b00 	vldr	d3, [r5]
1000113c:	f1a9 0308 	sub.w	r3, r9, #8
10001140:	cb0f      	ldmia	r3, {r0, r1, r2, r3}
10001142:	e88a 000f 	stmia.w	sl, {r0, r1, r2, r3}
10001146:	ed9d eb28 	vldr	d14, [sp, #160]	@ 0xa0
1000114a:	ed9d fb2a 	vldr	d15, [sp, #168]	@ 0xa8
1000114e:	ed94 4b02 	vldr	d4, [r4, #8]
10001152:	ed94 8b00 	vldr	d8, [r4]
10001156:	ed8d 3b00 	vstr	d3, [sp]
1000115a:	ed95 3b02 	vldr	d3, [r5, #8]
1000115e:	f1a8 0c08 	sub.w	ip, r8, #8
10001162:	e89c 000f 	ldmia.w	ip, {r0, r1, r2, r3}
10001166:	e887 000f 	stmia.w	r7, {r0, r1, r2, r3}
1000116a:	eeb0 0b4e 	vmov.f64	d0, d14
1000116e:	eeb0 1b4f 	vmov.f64	d1, d15
10001172:	a838      	add	r0, sp, #224	@ 0xe0
10001174:	ed9d 9b2c 	vldr	d9, [sp, #176]	@ 0xb0
10001178:	ed8d 4b0c 	vstr	d4, [sp, #48]	@ 0x30
1000117c:	ed8d 3b0a 	vstr	d3, [sp, #40]	@ 0x28
10001180:	ed9d ab2e 	vldr	d10, [sp, #184]	@ 0xb8
10001184:	ed8d 8b02 	vstr	d8, [sp, #8]
10001188:	ed8d eb30 	vstr	d14, [sp, #192]	@ 0xc0
1000118c:	ed8d fb32 	vstr	d15, [sp, #200]	@ 0xc8
10001190:	f7ff f8ea 	bl	10000368 <fp64e_mul24_prepared>
10001194:	a842      	add	r0, sp, #264	@ 0x108
10001196:	eeb0 8b41 	vmov.f64	d8, d1
1000119a:	ed8d 0b18 	vstr	d0, [sp, #96]	@ 0x60
1000119e:	ed8d 0b08 	vstr	d0, [sp, #32]
100011a2:	ed8d 1b1a 	vstr	d1, [sp, #104]	@ 0x68
100011a6:	eeb0 0b49 	vmov.f64	d0, d9
100011aa:	eeb0 1b4a 	vmov.f64	d1, d10
100011ae:	ed8d 9b34 	vstr	d9, [sp, #208]	@ 0xd0
100011b2:	ed8d ab36 	vstr	d10, [sp, #216]	@ 0xd8
100011b6:	f7ff f8d7 	bl	10000368 <fp64e_mul24_prepared>
100011ba:	eeb0 6b41 	vmov.f64	d6, d1
100011be:	ee3a 1b0f 	vadd.f64	d1, d10, d15
100011c2:	ee21 2b0c 	vmul.f64	d2, d1, d12
100011c6:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100011ca:	eeb0 7b40 	vmov.f64	d7, d0
100011ce:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100011d2:	ee3e 0b09 	vadd.f64	d0, d14, d9
100011d6:	ee30 0b02 	vadd.f64	d0, d0, d2
100011da:	ee02 1b4b 	vmls.f64	d1, d2, d11
100011de:	ee20 2b0c 	vmul.f64	d2, d0, d12
100011e2:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100011e6:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100011ea:	ee02 0b4b 	vmls.f64	d0, d2, d11
100011ee:	a84c      	add	r0, sp, #304	@ 0x130
100011f0:	ed8d 7b1c 	vstr	d7, [sp, #112]	@ 0x70
100011f4:	ed8d 7b06 	vstr	d7, [sp, #24]
100011f8:	ed8d 6b1e 	vstr	d6, [sp, #120]	@ 0x78
100011fc:	ed8d 6b04 	vstr	d6, [sp, #16]
10001200:	ed8d 1b26 	vstr	d1, [sp, #152]	@ 0x98
10001204:	ed8d 0b24 	vstr	d0, [sp, #144]	@ 0x90
10001208:	f7ff f8ae 	bl	10000368 <fp64e_mul24_prepared>
1000120c:	ed9d 6b04 	vldr	d6, [sp, #16]
10001210:	ee38 2b06 	vadd.f64	d2, d8, d6
10001214:	ee22 9b0c 	vmul.f64	d9, d2, d12
10001218:	ed9d 7b06 	vldr	d7, [sp, #24]
1000121c:	ed9d 5b08 	vldr	d5, [sp, #32]
10001220:	ee38 8b0b 	vadd.f64	d8, d8, d11
10001224:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10001228:	ee38 8b46 	vsub.f64	d8, d8, d6
1000122c:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10001230:	ee35 6b07 	vadd.f64	d6, d5, d7
10001234:	ed8d 1b22 	vstr	d1, [sp, #136]	@ 0x88
10001238:	ee36 6b09 	vadd.f64	d6, d6, d9
1000123c:	ee31 1b0b 	vadd.f64	d1, d1, d11
10001240:	ee09 2b4b 	vmls.f64	d2, d9, d11
10001244:	ee35 5b0b 	vadd.f64	d5, d5, d11
10001248:	ee31 2b42 	vsub.f64	d2, d1, d2
1000124c:	ee35 5b47 	vsub.f64	d5, d5, d7
10001250:	ee26 1b0c 	vmul.f64	d1, d6, d12
10001254:	ee28 7b0c 	vmul.f64	d7, d8, d12
10001258:	eebc 1bc1 	vcvt.u32.f64	s2, d1
1000125c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10001260:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10001264:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10001268:	ee35 5b4d 	vsub.f64	d5, d5, d13
1000126c:	ee07 8b4b 	vmls.f64	d8, d7, d11
10001270:	ee35 5b07 	vadd.f64	d5, d5, d7
10001274:	ed8d 0b20 	vstr	d0, [sp, #128]	@ 0x80
10001278:	ee22 7b0c 	vmul.f64	d7, d2, d12
1000127c:	ee30 0b0b 	vadd.f64	d0, d0, d11
10001280:	ee01 6b4b 	vmls.f64	d6, d1, d11
10001284:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10001288:	ee25 1b0c 	vmul.f64	d1, d5, d12
1000128c:	ee30 6b46 	vsub.f64	d6, d0, d6
10001290:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10001294:	ee36 6b4d 	vsub.f64	d6, d6, d13
10001298:	eebc 1bc1 	vcvt.u32.f64	s2, d1
1000129c:	ee36 6b07 	vadd.f64	d6, d6, d7
100012a0:	eeb8 1b41 	vcvt.f64.u32	d1, s2
100012a4:	ee01 5b4b 	vmls.f64	d5, d1, d11
100012a8:	ee26 1b0c 	vmul.f64	d1, d6, d12
100012ac:	ed9d 4b0c 	vldr	d4, [sp, #48]	@ 0x30
100012b0:	eebc 1bc1 	vcvt.u32.f64	s2, d1
100012b4:	ed9d 3b0a 	vldr	d3, [sp, #40]	@ 0x28
100012b8:	ee07 2b4b 	vmls.f64	d2, d7, d11
100012bc:	ee34 0b0b 	vadd.f64	d0, d4, d11
100012c0:	ee34 7b08 	vadd.f64	d7, d4, d8
100012c4:	eeb8 1b41 	vcvt.f64.u32	d1, s2
100012c8:	ee30 4b48 	vsub.f64	d4, d0, d8
100012cc:	ee01 6b4b 	vmls.f64	d6, d1, d11
100012d0:	ee33 0b0b 	vadd.f64	d0, d3, d11
100012d4:	ee33 1b02 	vadd.f64	d1, d3, d2
100012d8:	ee27 3b0c 	vmul.f64	d3, d7, d12
100012dc:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100012e0:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100012e4:	ed9d 8b02 	vldr	d8, [sp, #8]
100012e8:	ee03 7b4b 	vmls.f64	d7, d3, d11
100012ec:	ee24 9b0c 	vmul.f64	d9, d4, d12
100012f0:	ed84 7b02 	vstr	d7, [r4, #8]
100012f4:	ee38 7b0b 	vadd.f64	d7, d8, d11
100012f8:	eebc 9bc9 	vcvt.u32.f64	s18, d9
100012fc:	ee38 8b05 	vadd.f64	d8, d8, d5
10001300:	ee37 7b45 	vsub.f64	d7, d7, d5
10001304:	ee30 2b42 	vsub.f64	d2, d0, d2
10001308:	ee38 8b03 	vadd.f64	d8, d8, d3
1000130c:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10001310:	ed9d 3b00 	vldr	d3, [sp]
10001314:	ee37 7b4d 	vsub.f64	d7, d7, d13
10001318:	ee21 0b0c 	vmul.f64	d0, d1, d12
1000131c:	ee37 7b09 	vadd.f64	d7, d7, d9
10001320:	ee09 4b4b 	vmls.f64	d4, d9, d11
10001324:	ee33 5b0b 	vadd.f64	d5, d3, d11
10001328:	ee22 9b0c 	vmul.f64	d9, d2, d12
1000132c:	ee35 5b46 	vsub.f64	d5, d5, d6
10001330:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10001334:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10001338:	eeb8 0b40 	vcvt.f64.u32	d0, s0
1000133c:	ee33 3b06 	vadd.f64	d3, d3, d6
10001340:	ee35 5b4d 	vsub.f64	d5, d5, d13
10001344:	eeb8 6b49 	vcvt.f64.u32	d6, s18
10001348:	ee33 3b00 	vadd.f64	d3, d3, d0
1000134c:	ee06 2b4b 	vmls.f64	d2, d6, d11
10001350:	ee35 6b06 	vadd.f64	d6, d5, d6
10001354:	ee00 1b4b 	vmls.f64	d1, d0, d11
10001358:	ee23 5b0c 	vmul.f64	d5, d3, d12
1000135c:	ee26 0b0c 	vmul.f64	d0, d6, d12
10001360:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10001364:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10001368:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000136c:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10001370:	ee05 3b4b 	vmls.f64	d3, d5, d11
10001374:	ee00 6b4b 	vmls.f64	d6, d0, d11
10001378:	ee27 5b0c 	vmul.f64	d5, d7, d12
1000137c:	ee28 0b0c 	vmul.f64	d0, d8, d12
10001380:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10001384:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10001388:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000138c:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10001390:	464b      	mov	r3, r9
10001392:	ee05 7b4b 	vmls.f64	d7, d5, d11
10001396:	ee00 8b4b 	vmls.f64	d8, d0, d11
1000139a:	3510      	adds	r5, #16
1000139c:	ed84 8b00 	vstr	d8, [r4]
100013a0:	ed05 3b04 	vstr	d3, [r5, #-16]
100013a4:	ed05 1b02 	vstr	d1, [r5, #-8]
100013a8:	ed09 7b02 	vstr	d7, [r9, #-8]
100013ac:	ed83 4b00 	vstr	d4, [r3]
100013b0:	4643      	mov	r3, r8
100013b2:	3410      	adds	r4, #16
100013b4:	45a3      	cmp	fp, r4
100013b6:	ed08 6b02 	vstr	d6, [r8, #-8]
100013ba:	f109 0910 	add.w	r9, r9, #16
100013be:	ed83 2b00 	vstr	d2, [r3]
100013c2:	f108 0810 	add.w	r8, r8, #16
100013c6:	f47f aeb7 	bne.w	10001138 <fndsa_vect_FFT_fp64_exact.constprop.0+0x208>
100013ca:	e9dd 200f 	ldrd	r2, r0, [sp, #60]	@ 0x3c
100013ce:	4633      	mov	r3, r6
100013d0:	9911      	ldr	r1, [sp, #68]	@ 0x44
100013d2:	9c13      	ldr	r4, [sp, #76]	@ 0x4c
100013d4:	3310      	adds	r3, #16
100013d6:	429c      	cmp	r4, r3
100013d8:	4402      	add	r2, r0
100013da:	eb01 1100 	add.w	r1, r1, r0, lsl #4
100013de:	eb0b 1b00 	add.w	fp, fp, r0, lsl #4
100013e2:	f47f add8 	bne.w	10000f96 <fndsa_vect_FFT_fp64_exact.constprop.0+0x66>
100013e6:	9c15      	ldr	r4, [sp, #84]	@ 0x54
100013e8:	9b17      	ldr	r3, [sp, #92]	@ 0x5c
100013ea:	3401      	adds	r4, #1
100013ec:	42a3      	cmp	r3, r4
100013ee:	f8dd e048 	ldr.w	lr, [sp, #72]	@ 0x48
100013f2:	f47f adb4 	bne.w	10000f5e <fndsa_vect_FFT_fp64_exact.constprop.0+0x2e>
100013f6:	b057      	add	sp, #348	@ 0x15c
100013f8:	ecbd 8b10 	vpop	{d8-d15}
100013fc:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10001400:	4770      	bx	lr
