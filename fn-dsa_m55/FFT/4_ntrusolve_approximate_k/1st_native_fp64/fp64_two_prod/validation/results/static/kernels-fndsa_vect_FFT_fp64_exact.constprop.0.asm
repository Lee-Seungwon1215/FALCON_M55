10000e38 <fndsa_vect_FFT_fp64_exact.constprop.0>:
10000e38:	2801      	cmp	r0, #1
10000e3a:	f240 815c 	bls.w	100010f6 <fndsa_vect_FFT_fp64_exact.constprop.0+0x2be>
10000e3e:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10000e42:	2201      	movs	r2, #1
10000e44:	ed2d 8b10 	vpush	{d8-d15}
10000e48:	4605      	mov	r5, r0
10000e4a:	1e43      	subs	r3, r0, #1
10000e4c:	2010      	movs	r0, #16
10000e4e:	fa02 f603 	lsl.w	r6, r2, r3
10000e52:	b0b1      	sub	sp, #196	@ 0xc4
10000e54:	e9cd 6508 	strd	r6, r5, [sp, #32]
10000e58:	ed9f 9ba7 	vldr	d9, [pc, #668]	@ 100010f8 <fndsa_vect_FFT_fp64_exact.constprop.0+0x2c0>
10000e5c:	ed9f 8ba8 	vldr	d8, [pc, #672]	@ 10001100 <fndsa_vect_FFT_fp64_exact.constprop.0+0x2c8>
10000e60:	eeb7 eb00 	vmov.f64	d14, #112	@ 0x3f800000  1.0
10000e64:	4614      	mov	r4, r2
10000e66:	4635      	mov	r5, r6
10000e68:	fa00 f303 	lsl.w	r3, r0, r3
10000e6c:	9306      	str	r3, [sp, #24]
10000e6e:	2201      	movs	r2, #1
10000e70:	2310      	movs	r3, #16
10000e72:	fa02 fa04 	lsl.w	sl, r2, r4
10000e76:	40a3      	lsls	r3, r4
10000e78:	9407      	str	r4, [sp, #28]
10000e7a:	2400      	movs	r4, #0
10000e7c:	462f      	mov	r7, r5
10000e7e:	40d5      	lsrs	r5, r2
10000e80:	4aa1      	ldr	r2, [pc, #644]	@ (10001108 <fndsa_vect_FFT_fp64_exact.constprop.0+0x2d0>)
10000e82:	9808      	ldr	r0, [sp, #32]
10000e84:	eb02 1905 	add.w	r9, r2, r5, lsl #4
10000e88:	4aa0      	ldr	r2, [pc, #640]	@ (1000110c <fndsa_vect_FFT_fp64_exact.constprop.0+0x2d4>)
10000e8a:	eb0a 0a5a 	add.w	sl, sl, sl, lsr #1
10000e8e:	eb02 110a 	add.w	r1, r2, sl, lsl #4
10000e92:	1b40      	subs	r0, r0, r5
10000e94:	9104      	str	r1, [sp, #16]
10000e96:	9005      	str	r0, [sp, #20]
10000e98:	eb02 0b03 	add.w	fp, r2, r3
10000e9c:	eddb 7a00 	vldr	s15, [fp]
10000ea0:	eeb8 1b67 	vcvt.f64.u32	d1, s15
10000ea4:	eddb 7a02 	vldr	s15, [fp, #8]
10000ea8:	eeb8 4b67 	vcvt.f64.u32	d4, s15
10000eac:	eddb 7a01 	vldr	s15, [fp, #4]
10000eb0:	eeb8 2b67 	vcvt.f64.u32	d2, s15
10000eb4:	eddb 7a03 	vldr	s15, [fp, #12]
10000eb8:	f8db 3004 	ldr.w	r3, [fp, #4]
10000ebc:	eeb8 3b67 	vcvt.f64.u32	d3, s15
10000ec0:	0fdb      	lsrs	r3, r3, #31
10000ec2:	ee06 3a10 	vmov	s12, r3
10000ec6:	ee17 3a90 	vmov	r3, s15
10000eca:	0fdb      	lsrs	r3, r3, #31
10000ecc:	ee07 3a10 	vmov	s14, r3
10000ed0:	ee31 5b04 	vadd.f64	d5, d1, d4
10000ed4:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10000ed8:	ed8d 7b24 	vstr	d7, [sp, #144]	@ 0x90
10000edc:	ee25 7b09 	vmul.f64	d7, d5, d9
10000ee0:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10000ee4:	ee32 cb03 	vadd.f64	d12, d2, d3
10000ee8:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10000eec:	ee3c cb07 	vadd.f64	d12, d12, d7
10000ef0:	ee07 5b48 	vmls.f64	d5, d7, d8
10000ef4:	ee2c 7b09 	vmul.f64	d7, d12, d9
10000ef8:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10000efc:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10000f00:	ee07 cb48 	vmls.f64	d12, d7, d8
10000f04:	eebc 7bcc 	vcvt.u32.f64	s14, d12
10000f08:	ee17 2a10 	vmov	r2, s14
10000f0c:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10000f10:	0fd2      	lsrs	r2, r2, #31
10000f12:	ed8d 6b1a 	vstr	d6, [sp, #104]	@ 0x68
10000f16:	ee07 2a10 	vmov	s14, r2
10000f1a:	ee25 6b09 	vmul.f64	d6, d5, d9
10000f1e:	ee21 0b09 	vmul.f64	d0, d1, d9
10000f22:	ed8d 1b14 	vstr	d1, [sp, #80]	@ 0x50
10000f26:	ee22 ab09 	vmul.f64	d10, d2, d9
10000f2a:	ee24 1b09 	vmul.f64	d1, d4, d9
10000f2e:	ee23 bb09 	vmul.f64	d11, d3, d9
10000f32:	ed8d 6b2c 	vstr	d6, [sp, #176]	@ 0xb0
10000f36:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10000f3a:	ee2c 6b09 	vmul.f64	d6, d12, d9
10000f3e:	192b      	adds	r3, r5, r4
10000f40:	429c      	cmp	r4, r3
10000f42:	ed8d 2b12 	vstr	d2, [sp, #72]	@ 0x48
10000f46:	ed8d 3b1c 	vstr	d3, [sp, #112]	@ 0x70
10000f4a:	ed8d 4b1e 	vstr	d4, [sp, #120]	@ 0x78
10000f4e:	ed8d 0b18 	vstr	d0, [sp, #96]	@ 0x60
10000f52:	ed8d 1b22 	vstr	d1, [sp, #136]	@ 0x88
10000f56:	ed8d ab16 	vstr	d10, [sp, #88]	@ 0x58
10000f5a:	ed8d bb20 	vstr	d11, [sp, #128]	@ 0x80
10000f5e:	ed8d 5b28 	vstr	d5, [sp, #160]	@ 0xa0
10000f62:	ed8d cb26 	vstr	d12, [sp, #152]	@ 0x98
10000f66:	ed8d 6b2a 	vstr	d6, [sp, #168]	@ 0xa8
10000f6a:	ed8d 7b2e 	vstr	d7, [sp, #184]	@ 0xb8
10000f6e:	f080 80ae 	bcs.w	100010ce <fndsa_vect_FFT_fp64_exact.constprop.0+0x296>
10000f72:	46c8      	mov	r8, r9
10000f74:	4b64      	ldr	r3, [pc, #400]	@ (10001108 <fndsa_vect_FFT_fp64_exact.constprop.0+0x2d0>)
10000f76:	eb03 1604 	add.w	r6, r3, r4, lsl #4
10000f7a:	9b05      	ldr	r3, [sp, #20]
10000f7c:	eb09 1103 	add.w	r1, r9, r3, lsl #4
10000f80:	9b06      	ldr	r3, [sp, #24]
10000f82:	eb03 0a09 	add.w	sl, r3, r9
10000f86:	ed98 0b00 	vldr	d0, [r8]
10000f8a:	ed9a 2b00 	vldr	d2, [sl]
10000f8e:	ed9a 3b02 	vldr	d3, [sl, #8]
10000f92:	ed98 1b02 	vldr	d1, [r8, #8]
10000f96:	a812      	add	r0, sp, #72	@ 0x48
10000f98:	f7ff fcc6 	bl	10000928 <fp64e_cmul_prepared>
10000f9c:	ed96 db02 	vldr	d13, [r6, #8]
10000fa0:	ed91 ab00 	vldr	d10, [r1]
10000fa4:	ed91 cb02 	vldr	d12, [r1, #8]
10000fa8:	ed96 bb00 	vldr	d11, [r6]
10000fac:	ee3d 7b01 	vadd.f64	d7, d13, d1
10000fb0:	ee3c 6b03 	vadd.f64	d6, d12, d3
10000fb4:	ee3d 5b08 	vadd.f64	d5, d13, d8
10000fb8:	ee3a db02 	vadd.f64	d13, d10, d2
10000fbc:	ee3a ab08 	vadd.f64	d10, d10, d8
10000fc0:	ee3b fb00 	vadd.f64	d15, d11, d0
10000fc4:	ee3a ab42 	vsub.f64	d10, d10, d2
10000fc8:	ee26 4b09 	vmul.f64	d4, d6, d9
10000fcc:	ee3c cb08 	vadd.f64	d12, d12, d8
10000fd0:	ee3b bb08 	vadd.f64	d11, d11, d8
10000fd4:	ed8d 1b0c 	vstr	d1, [sp, #48]	@ 0x30
10000fd8:	ee35 1b41 	vsub.f64	d1, d5, d1
10000fdc:	ee27 5b09 	vmul.f64	d5, d7, d9
10000fe0:	ee3b bb40 	vsub.f64	d11, d11, d0
10000fe4:	ed8d 0b0a 	vstr	d0, [sp, #40]	@ 0x28
10000fe8:	ed8d 2b0e 	vstr	d2, [sp, #56]	@ 0x38
10000fec:	eebc 0bc4 	vcvt.u32.f64	s0, d4
10000ff0:	ee3c 2b43 	vsub.f64	d2, d12, d3
10000ff4:	ed8d 3b10 	vstr	d3, [sp, #64]	@ 0x40
10000ff8:	ee3a 3b4e 	vsub.f64	d3, d10, d14
10000ffc:	eebc abc5 	vcvt.u32.f64	s20, d5
10001000:	ee22 cb09 	vmul.f64	d12, d2, d9
10001004:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10001008:	eeb8 0b40 	vcvt.f64.u32	d0, s0
1000100c:	ed8d 3b02 	vstr	d3, [sp, #8]
10001010:	ee21 3b09 	vmul.f64	d3, d1, d9
10001014:	ee3b 5b4e 	vsub.f64	d5, d11, d14
10001018:	ee0a 7b48 	vmls.f64	d7, d10, d8
1000101c:	ee00 6b48 	vmls.f64	d6, d0, d8
10001020:	eebc 4bcc 	vcvt.u32.f64	s8, d12
10001024:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10001028:	ed8d 5b00 	vstr	d5, [sp]
1000102c:	ee3d bb00 	vadd.f64	d11, d13, d0
10001030:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10001034:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10001038:	eeb0 cb47 	vmov.f64	d12, d7
1000103c:	eeb0 db46 	vmov.f64	d13, d6
10001040:	ed9d 7b00 	vldr	d7, [sp]
10001044:	ed9d 6b02 	vldr	d6, [sp, #8]
10001048:	ee3f 5b0a 	vadd.f64	d5, d15, d10
1000104c:	ee37 7b03 	vadd.f64	d7, d7, d3
10001050:	ee36 6b04 	vadd.f64	d6, d6, d4
10001054:	ee25 0b09 	vmul.f64	d0, d5, d9
10001058:	ee2b ab09 	vmul.f64	d10, d11, d9
1000105c:	ee03 1b48 	vmls.f64	d1, d3, d8
10001060:	ee04 2b48 	vmls.f64	d2, d4, d8
10001064:	ee27 3b09 	vmul.f64	d3, d7, d9
10001068:	ee26 4b09 	vmul.f64	d4, d6, d9
1000106c:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10001070:	eebc abca 	vcvt.u32.f64	s20, d10
10001074:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10001078:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000107c:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10001080:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10001084:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10001088:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000108c:	ee00 5b48 	vmls.f64	d5, d0, d8
10001090:	ee0a bb48 	vmls.f64	d11, d10, d8
10001094:	ee03 7b48 	vmls.f64	d7, d3, d8
10001098:	ee04 6b48 	vmls.f64	d6, d4, d8
1000109c:	3610      	adds	r6, #16
1000109e:	3110      	adds	r1, #16
100010a0:	f108 0810 	add.w	r8, r8, #16
100010a4:	f10a 0a10 	add.w	sl, sl, #16
100010a8:	45b1      	cmp	r9, r6
100010aa:	ed06 cb02 	vstr	d12, [r6, #-8]
100010ae:	ed06 5b04 	vstr	d5, [r6, #-16]
100010b2:	ed01 bb04 	vstr	d11, [r1, #-16]
100010b6:	ed01 db02 	vstr	d13, [r1, #-8]
100010ba:	ed08 1b02 	vstr	d1, [r8, #-8]
100010be:	ed08 7b04 	vstr	d7, [r8, #-16]
100010c2:	ed0a 6b04 	vstr	d6, [sl, #-16]
100010c6:	ed0a 2b02 	vstr	d2, [sl, #-8]
100010ca:	f47f af5c 	bne.w	10000f86 <fndsa_vect_FFT_fp64_exact.constprop.0+0x14e>
100010ce:	9b04      	ldr	r3, [sp, #16]
100010d0:	f10b 0b10 	add.w	fp, fp, #16
100010d4:	455b      	cmp	r3, fp
100010d6:	443c      	add	r4, r7
100010d8:	eb09 1907 	add.w	r9, r9, r7, lsl #4
100010dc:	f47f aede 	bne.w	10000e9c <fndsa_vect_FFT_fp64_exact.constprop.0+0x64>
100010e0:	9c07      	ldr	r4, [sp, #28]
100010e2:	9b09      	ldr	r3, [sp, #36]	@ 0x24
100010e4:	3401      	adds	r4, #1
100010e6:	42a3      	cmp	r3, r4
100010e8:	f47f aec1 	bne.w	10000e6e <fndsa_vect_FFT_fp64_exact.constprop.0+0x36>
100010ec:	b031      	add	sp, #196	@ 0xc4
100010ee:	ecbd 8b10 	vpop	{d8-d15}
100010f2:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
100010f6:	4770      	bx	lr
100010f8:	00000000 	.word	0x00000000
100010fc:	3df00000 	.word	0x3df00000
10001100:	00000000 	.word	0x00000000
10001104:	41f00000 	.word	0x41f00000
10001108:	3001b0e0 	.word	0x3001b0e0
1000110c:	300009a0 	.word	0x300009a0

