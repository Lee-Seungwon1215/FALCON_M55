10006df8 <fndsa_vect_FFT_fp64_exact>:
10006df8:	2801      	cmp	r0, #1
10006dfa:	f240 815a 	bls.w	100070b2 <fndsa_vect_FFT_fp64_exact+0x2ba>
10006dfe:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10006e02:	460f      	mov	r7, r1
10006e04:	2101      	movs	r1, #1
10006e06:	ed2d 8b10 	vpush	{d8-d15}
10006e0a:	2210      	movs	r2, #16
10006e0c:	ed9f 9baa 	vldr	d9, [pc, #680]	@ 100070b8 <fndsa_vect_FFT_fp64_exact+0x2c0>
10006e10:	ed9f 8bab 	vldr	d8, [pc, #684]	@ 100070c0 <fndsa_vect_FFT_fp64_exact+0x2c8>
10006e14:	eeb7 eb00 	vmov.f64	d14, #112	@ 0x3f800000  1.0
10006e18:	460c      	mov	r4, r1
10006e1a:	1e43      	subs	r3, r0, #1
10006e1c:	b0b1      	sub	sp, #196	@ 0xc4
10006e1e:	9009      	str	r0, [sp, #36]	@ 0x24
10006e20:	409a      	lsls	r2, r3
10006e22:	fa01 f003 	lsl.w	r0, r1, r3
10006e26:	f04f 0a10 	mov.w	sl, #16
10006e2a:	2301      	movs	r3, #1
10006e2c:	4ea6      	ldr	r6, [pc, #664]	@ (100070c8 <fndsa_vect_FFT_fp64_exact+0x2d0>)
10006e2e:	fa0a fa04 	lsl.w	sl, sl, r4
10006e32:	4680      	mov	r8, r0
10006e34:	0840      	lsrs	r0, r0, #1
10006e36:	eb07 1900 	add.w	r9, r7, r0, lsl #4
10006e3a:	9005      	str	r0, [sp, #20]
10006e3c:	9708      	str	r7, [sp, #32]
10006e3e:	eb0a 0006 	add.w	r0, sl, r6
10006e42:	4693      	mov	fp, r2
10006e44:	46ba      	mov	sl, r7
10006e46:	2700      	movs	r7, #0
10006e48:	fa03 f504 	lsl.w	r5, r3, r4
10006e4c:	eb05 0555 	add.w	r5, r5, r5, lsr #1
10006e50:	eb06 1505 	add.w	r5, r6, r5, lsl #4
10006e54:	e9cd 5406 	strd	r5, r4, [sp, #24]
10006e58:	edd0 7a00 	vldr	s15, [r0]
10006e5c:	eeb8 1b67 	vcvt.f64.u32	d1, s15
10006e60:	edd0 7a02 	vldr	s15, [r0, #8]
10006e64:	eeb8 4b67 	vcvt.f64.u32	d4, s15
10006e68:	edd0 7a01 	vldr	s15, [r0, #4]
10006e6c:	eeb8 2b67 	vcvt.f64.u32	d2, s15
10006e70:	edd0 7a03 	vldr	s15, [r0, #12]
10006e74:	6843      	ldr	r3, [r0, #4]
10006e76:	eeb8 3b67 	vcvt.f64.u32	d3, s15
10006e7a:	0fdb      	lsrs	r3, r3, #31
10006e7c:	ee06 3a10 	vmov	s12, r3
10006e80:	ee17 3a90 	vmov	r3, s15
10006e84:	0fdb      	lsrs	r3, r3, #31
10006e86:	ee07 3a10 	vmov	s14, r3
10006e8a:	ee31 5b04 	vadd.f64	d5, d1, d4
10006e8e:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10006e92:	ed8d 7b24 	vstr	d7, [sp, #144]	@ 0x90
10006e96:	ee25 7b09 	vmul.f64	d7, d5, d9
10006e9a:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006e9e:	ee32 cb03 	vadd.f64	d12, d2, d3
10006ea2:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006ea6:	ee3c cb07 	vadd.f64	d12, d12, d7
10006eaa:	ee07 5b48 	vmls.f64	d5, d7, d8
10006eae:	ee2c 7b09 	vmul.f64	d7, d12, d9
10006eb2:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006eb6:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006eba:	ee07 cb48 	vmls.f64	d12, d7, d8
10006ebe:	eebc 7bcc 	vcvt.u32.f64	s14, d12
10006ec2:	9b05      	ldr	r3, [sp, #20]
10006ec4:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10006ec8:	19d9      	adds	r1, r3, r7
10006eca:	ee17 3a10 	vmov	r3, s14
10006ece:	0fdb      	lsrs	r3, r3, #31
10006ed0:	ed8d 6b1a 	vstr	d6, [sp, #104]	@ 0x68
10006ed4:	ee07 3a10 	vmov	s14, r3
10006ed8:	ee25 6b09 	vmul.f64	d6, d5, d9
10006edc:	ee21 0b09 	vmul.f64	d0, d1, d9
10006ee0:	ed8d 1b14 	vstr	d1, [sp, #80]	@ 0x50
10006ee4:	ee22 ab09 	vmul.f64	d10, d2, d9
10006ee8:	ee24 1b09 	vmul.f64	d1, d4, d9
10006eec:	ee23 bb09 	vmul.f64	d11, d3, d9
10006ef0:	ed8d 6b2c 	vstr	d6, [sp, #176]	@ 0xb0
10006ef4:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10006ef8:	ee2c 6b09 	vmul.f64	d6, d12, d9
10006efc:	428f      	cmp	r7, r1
10006efe:	ed8d 2b12 	vstr	d2, [sp, #72]	@ 0x48
10006f02:	ed8d 3b1c 	vstr	d3, [sp, #112]	@ 0x70
10006f06:	ed8d 4b1e 	vstr	d4, [sp, #120]	@ 0x78
10006f0a:	ed8d 0b18 	vstr	d0, [sp, #96]	@ 0x60
10006f0e:	ed8d 1b22 	vstr	d1, [sp, #136]	@ 0x88
10006f12:	ed8d ab16 	vstr	d10, [sp, #88]	@ 0x58
10006f16:	ed8d bb20 	vstr	d11, [sp, #128]	@ 0x80
10006f1a:	ed8d 5b28 	vstr	d5, [sp, #160]	@ 0xa0
10006f1e:	ed8d cb26 	vstr	d12, [sp, #152]	@ 0x98
10006f22:	ed8d 6b2a 	vstr	d6, [sp, #168]	@ 0xa8
10006f26:	ed8d 7b2e 	vstr	d7, [sp, #184]	@ 0xb8
10006f2a:	f080 80aa 	bcs.w	10007082 <fndsa_vect_FFT_fp64_exact+0x28a>
10006f2e:	464d      	mov	r5, r9
10006f30:	4654      	mov	r4, sl
10006f32:	eb0b 010a 	add.w	r1, fp, sl
10006f36:	eb0b 0609 	add.w	r6, fp, r9
10006f3a:	9004      	str	r0, [sp, #16]
10006f3c:	ed95 0b00 	vldr	d0, [r5]
10006f40:	ed96 2b00 	vldr	d2, [r6]
10006f44:	ed96 3b02 	vldr	d3, [r6, #8]
10006f48:	ed95 1b02 	vldr	d1, [r5, #8]
10006f4c:	a812      	add	r0, sp, #72	@ 0x48
10006f4e:	f7ff f8e7 	bl	10006120 <fp64e_cmul_prepared>
10006f52:	ed94 db02 	vldr	d13, [r4, #8]
10006f56:	ed91 ab00 	vldr	d10, [r1]
10006f5a:	ed91 cb02 	vldr	d12, [r1, #8]
10006f5e:	ed94 bb00 	vldr	d11, [r4]
10006f62:	ee3d 7b01 	vadd.f64	d7, d13, d1
10006f66:	ee3c 6b03 	vadd.f64	d6, d12, d3
10006f6a:	ee3d 5b08 	vadd.f64	d5, d13, d8
10006f6e:	ee3a db02 	vadd.f64	d13, d10, d2
10006f72:	ee3a ab08 	vadd.f64	d10, d10, d8
10006f76:	ee3b fb00 	vadd.f64	d15, d11, d0
10006f7a:	ee3a ab42 	vsub.f64	d10, d10, d2
10006f7e:	ee26 4b09 	vmul.f64	d4, d6, d9
10006f82:	ee3c cb08 	vadd.f64	d12, d12, d8
10006f86:	ee3b bb08 	vadd.f64	d11, d11, d8
10006f8a:	ed8d 1b0c 	vstr	d1, [sp, #48]	@ 0x30
10006f8e:	ee35 1b41 	vsub.f64	d1, d5, d1
10006f92:	ee27 5b09 	vmul.f64	d5, d7, d9
10006f96:	ee3b bb40 	vsub.f64	d11, d11, d0
10006f9a:	ed8d 0b0a 	vstr	d0, [sp, #40]	@ 0x28
10006f9e:	ed8d 2b0e 	vstr	d2, [sp, #56]	@ 0x38
10006fa2:	eebc 0bc4 	vcvt.u32.f64	s0, d4
10006fa6:	ee3c 2b43 	vsub.f64	d2, d12, d3
10006faa:	ed8d 3b10 	vstr	d3, [sp, #64]	@ 0x40
10006fae:	ee3a 3b4e 	vsub.f64	d3, d10, d14
10006fb2:	eebc abc5 	vcvt.u32.f64	s20, d5
10006fb6:	ee22 cb09 	vmul.f64	d12, d2, d9
10006fba:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10006fbe:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10006fc2:	ed8d 3b02 	vstr	d3, [sp, #8]
10006fc6:	ee21 3b09 	vmul.f64	d3, d1, d9
10006fca:	ee3b 5b4e 	vsub.f64	d5, d11, d14
10006fce:	ee0a 7b48 	vmls.f64	d7, d10, d8
10006fd2:	ee00 6b48 	vmls.f64	d6, d0, d8
10006fd6:	eebc 4bcc 	vcvt.u32.f64	s8, d12
10006fda:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006fde:	ed8d 5b00 	vstr	d5, [sp]
10006fe2:	ee3d bb00 	vadd.f64	d11, d13, d0
10006fe6:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10006fea:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10006fee:	eeb0 cb47 	vmov.f64	d12, d7
10006ff2:	eeb0 db46 	vmov.f64	d13, d6
10006ff6:	ed9d 7b00 	vldr	d7, [sp]
10006ffa:	ed9d 6b02 	vldr	d6, [sp, #8]
10006ffe:	ee3f 5b0a 	vadd.f64	d5, d15, d10
10007002:	ee37 7b03 	vadd.f64	d7, d7, d3
10007006:	ee36 6b04 	vadd.f64	d6, d6, d4
1000700a:	ee25 0b09 	vmul.f64	d0, d5, d9
1000700e:	ee2b ab09 	vmul.f64	d10, d11, d9
10007012:	ee03 1b48 	vmls.f64	d1, d3, d8
10007016:	ee04 2b48 	vmls.f64	d2, d4, d8
1000701a:	ee27 3b09 	vmul.f64	d3, d7, d9
1000701e:	ee26 4b09 	vmul.f64	d4, d6, d9
10007022:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10007026:	eebc abca 	vcvt.u32.f64	s20, d10
1000702a:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000702e:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10007032:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10007036:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
1000703a:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000703e:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10007042:	ee00 5b48 	vmls.f64	d5, d0, d8
10007046:	ee0a bb48 	vmls.f64	d11, d10, d8
1000704a:	ee03 7b48 	vmls.f64	d7, d3, d8
1000704e:	ee04 6b48 	vmls.f64	d6, d4, d8
10007052:	3410      	adds	r4, #16
10007054:	3110      	adds	r1, #16
10007056:	3510      	adds	r5, #16
10007058:	3610      	adds	r6, #16
1000705a:	45a1      	cmp	r9, r4
1000705c:	ed04 cb02 	vstr	d12, [r4, #-8]
10007060:	ed04 5b04 	vstr	d5, [r4, #-16]
10007064:	ed01 bb04 	vstr	d11, [r1, #-16]
10007068:	ed01 db02 	vstr	d13, [r1, #-8]
1000706c:	ed05 1b02 	vstr	d1, [r5, #-8]
10007070:	ed05 7b04 	vstr	d7, [r5, #-16]
10007074:	ed06 6b04 	vstr	d6, [r6, #-16]
10007078:	ed06 2b02 	vstr	d2, [r6, #-8]
1000707c:	f47f af5e 	bne.w	10006f3c <fndsa_vect_FFT_fp64_exact+0x144>
10007080:	9804      	ldr	r0, [sp, #16]
10007082:	9b06      	ldr	r3, [sp, #24]
10007084:	3010      	adds	r0, #16
10007086:	4283      	cmp	r3, r0
10007088:	4447      	add	r7, r8
1000708a:	eb0a 1a08 	add.w	sl, sl, r8, lsl #4
1000708e:	eb09 1908 	add.w	r9, r9, r8, lsl #4
10007092:	f47f aee1 	bne.w	10006e58 <fndsa_vect_FFT_fp64_exact+0x60>
10007096:	9c07      	ldr	r4, [sp, #28]
10007098:	9b09      	ldr	r3, [sp, #36]	@ 0x24
1000709a:	3401      	adds	r4, #1
1000709c:	42a3      	cmp	r3, r4
1000709e:	465a      	mov	r2, fp
100070a0:	9805      	ldr	r0, [sp, #20]
100070a2:	9f08      	ldr	r7, [sp, #32]
100070a4:	f47f aebf 	bne.w	10006e26 <fndsa_vect_FFT_fp64_exact+0x2e>
100070a8:	b031      	add	sp, #196	@ 0xc4
100070aa:	ecbd 8b10 	vpop	{d8-d15}
100070ae:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
100070b2:	4770      	bx	lr
100070b4:	f3af 8000 	nop.w
100070b8:	00000000 	.word	0x00000000
100070bc:	3df00000 	.word	0x3df00000
100070c0:	00000000 	.word	0x00000000
100070c4:	41f00000 	.word	0x41f00000
100070c8:	300039a0 	.word	0x300039a0
100070cc:	00000000 	.word	0x00000000

