10006df8 <fndsa_vect_FFT_fp64_exact>:
10006df8:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10006dfc:	2301      	movs	r3, #1
10006dfe:	ed2d 8b10 	vpush	{d8-d15}
10006e02:	f100 3aff 	add.w	sl, r0, #4294967295	@ 0xffffffff
10006e06:	2802      	cmp	r0, #2
10006e08:	4604      	mov	r4, r0
10006e0a:	460e      	mov	r6, r1
10006e0c:	b0df      	sub	sp, #380	@ 0x17c
10006e0e:	fa03 f80a 	lsl.w	r8, r3, sl
10006e12:	f200 857e 	bhi.w	10007912 <fndsa_vect_FFT_fp64_exact+0xb1a>
10006e16:	bf08      	it	eq
10006e18:	4686      	moveq	lr, r0
10006e1a:	f040 8575 	bne.w	10007908 <fndsa_vect_FFT_fp64_exact+0xb10>
10006e1e:	2010      	movs	r0, #16
10006e20:	9417      	str	r4, [sp, #92]	@ 0x5c
10006e22:	ed9f 9bbf 	vldr	d9, [pc, #764]	@ 10007120 <fndsa_vect_FFT_fp64_exact+0x328>
10006e26:	ed9f 8bc0 	vldr	d8, [pc, #768]	@ 10007128 <fndsa_vect_FFT_fp64_exact+0x330>
10006e2a:	2401      	movs	r4, #1
10006e2c:	46c4      	mov	ip, r8
10006e2e:	f8cd 8058 	str.w	r8, [sp, #88]	@ 0x58
10006e32:	f8df 82fc 	ldr.w	r8, [pc, #764]	@ 10007130 <fndsa_vect_FFT_fp64_exact+0x338>
10006e36:	af18      	add	r7, sp, #96	@ 0x60
10006e38:	fa00 fb0a 	lsl.w	fp, r0, sl
10006e3c:	f8cd a050 	str.w	sl, [sp, #80]	@ 0x50
10006e40:	f8cd e048 	str.w	lr, [sp, #72]	@ 0x48
10006e44:	2301      	movs	r3, #1
10006e46:	f04f 0a10 	mov.w	sl, #16
10006e4a:	4662      	mov	r2, ip
10006e4c:	40a3      	lsls	r3, r4
10006e4e:	eb03 0353 	add.w	r3, r3, r3, lsr #1
10006e52:	eb08 1303 	add.w	r3, r8, r3, lsl #4
10006e56:	ea4f 0c5c 	mov.w	ip, ip, lsr #1
10006e5a:	fa0a fa04 	lsl.w	sl, sl, r4
10006e5e:	930a      	str	r3, [sp, #40]	@ 0x28
10006e60:	eb06 190c 	add.w	r9, r6, ip, lsl #4
10006e64:	4633      	mov	r3, r6
10006e66:	eb0a 0008 	add.w	r0, sl, r8
10006e6a:	9610      	str	r6, [sp, #64]	@ 0x40
10006e6c:	46da      	mov	sl, fp
10006e6e:	eeb7 eb00 	vmov.f64	d14, #112	@ 0x3f800000  1.0
10006e72:	f04f 0b00 	mov.w	fp, #0
10006e76:	4616      	mov	r6, r2
10006e78:	f8cd c020 	str.w	ip, [sp, #32]
10006e7c:	940c      	str	r4, [sp, #48]	@ 0x30
10006e7e:	f8cd 8038 	str.w	r8, [sp, #56]	@ 0x38
10006e82:	edd0 7a00 	vldr	s15, [r0]
10006e86:	eeb8 1b67 	vcvt.f64.u32	d1, s15
10006e8a:	edd0 7a02 	vldr	s15, [r0, #8]
10006e8e:	eeb8 4b67 	vcvt.f64.u32	d4, s15
10006e92:	edd0 7a01 	vldr	s15, [r0, #4]
10006e96:	eeb8 2b67 	vcvt.f64.u32	d2, s15
10006e9a:	edd0 7a03 	vldr	s15, [r0, #12]
10006e9e:	6842      	ldr	r2, [r0, #4]
10006ea0:	eeb8 3b67 	vcvt.f64.u32	d3, s15
10006ea4:	0fd2      	lsrs	r2, r2, #31
10006ea6:	ee06 2a10 	vmov	s12, r2
10006eaa:	ee17 2a90 	vmov	r2, s15
10006eae:	0fd2      	lsrs	r2, r2, #31
10006eb0:	ee07 2a10 	vmov	s14, r2
10006eb4:	ee31 5b04 	vadd.f64	d5, d1, d4
10006eb8:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10006ebc:	ed8d 7b52 	vstr	d7, [sp, #328]	@ 0x148
10006ec0:	ee25 7b09 	vmul.f64	d7, d5, d9
10006ec4:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006ec8:	ee32 cb03 	vadd.f64	d12, d2, d3
10006ecc:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006ed0:	ee3c cb07 	vadd.f64	d12, d12, d7
10006ed4:	ee07 5b48 	vmls.f64	d5, d7, d8
10006ed8:	ee2c 7b09 	vmul.f64	d7, d12, d9
10006edc:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006ee0:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006ee4:	ee07 cb48 	vmls.f64	d12, d7, d8
10006ee8:	eebc 7bcc 	vcvt.u32.f64	s14, d12
10006eec:	9a08      	ldr	r2, [sp, #32]
10006eee:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10006ef2:	eb02 010b 	add.w	r1, r2, fp
10006ef6:	ee17 2a10 	vmov	r2, s14
10006efa:	0fd2      	lsrs	r2, r2, #31
10006efc:	ed8d 6b48 	vstr	d6, [sp, #288]	@ 0x120
10006f00:	ee07 2a10 	vmov	s14, r2
10006f04:	ee25 6b09 	vmul.f64	d6, d5, d9
10006f08:	ee21 0b09 	vmul.f64	d0, d1, d9
10006f0c:	ed8d 1b42 	vstr	d1, [sp, #264]	@ 0x108
10006f10:	ee22 ab09 	vmul.f64	d10, d2, d9
10006f14:	ee24 1b09 	vmul.f64	d1, d4, d9
10006f18:	ee23 bb09 	vmul.f64	d11, d3, d9
10006f1c:	ed8d 6b5a 	vstr	d6, [sp, #360]	@ 0x168
10006f20:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10006f24:	ee2c 6b09 	vmul.f64	d6, d12, d9
10006f28:	458b      	cmp	fp, r1
10006f2a:	ed8d 2b40 	vstr	d2, [sp, #256]	@ 0x100
10006f2e:	ed8d 3b4a 	vstr	d3, [sp, #296]	@ 0x128
10006f32:	ed8d 4b4c 	vstr	d4, [sp, #304]	@ 0x130
10006f36:	ed8d 0b46 	vstr	d0, [sp, #280]	@ 0x118
10006f3a:	ed8d 1b50 	vstr	d1, [sp, #320]	@ 0x140
10006f3e:	ed8d ab44 	vstr	d10, [sp, #272]	@ 0x110
10006f42:	ed8d bb4e 	vstr	d11, [sp, #312]	@ 0x138
10006f46:	ed8d 5b56 	vstr	d5, [sp, #344]	@ 0x158
10006f4a:	ed8d cb54 	vstr	d12, [sp, #336]	@ 0x150
10006f4e:	ed8d 6b58 	vstr	d6, [sp, #352]	@ 0x160
10006f52:	ed8d 7b5c 	vstr	d7, [sp, #368]	@ 0x170
10006f56:	f080 80ae 	bcs.w	100070b6 <fndsa_vect_FFT_fp64_exact+0x2be>
10006f5a:	4649      	mov	r1, r9
10006f5c:	461c      	mov	r4, r3
10006f5e:	4680      	mov	r8, r0
10006f60:	9604      	str	r6, [sp, #16]
10006f62:	eb0a 0509 	add.w	r5, sl, r9
10006f66:	9306      	str	r3, [sp, #24]
10006f68:	eb0a 0603 	add.w	r6, sl, r3
10006f6c:	ed91 0b00 	vldr	d0, [r1]
10006f70:	ed95 2b00 	vldr	d2, [r5]
10006f74:	ed95 3b02 	vldr	d3, [r5, #8]
10006f78:	ed91 1b02 	vldr	d1, [r1, #8]
10006f7c:	a840      	add	r0, sp, #256	@ 0x100
10006f7e:	f7ff f8cf 	bl	10006120 <fp64e_cmul_prepared>
10006f82:	ed94 db02 	vldr	d13, [r4, #8]
10006f86:	ed96 ab00 	vldr	d10, [r6]
10006f8a:	ed96 cb02 	vldr	d12, [r6, #8]
10006f8e:	ed94 bb00 	vldr	d11, [r4]
10006f92:	ee3d 7b01 	vadd.f64	d7, d13, d1
10006f96:	ee3c 6b03 	vadd.f64	d6, d12, d3
10006f9a:	ee3d 5b08 	vadd.f64	d5, d13, d8
10006f9e:	ee3a db02 	vadd.f64	d13, d10, d2
10006fa2:	ee3a ab08 	vadd.f64	d10, d10, d8
10006fa6:	ee3b fb00 	vadd.f64	d15, d11, d0
10006faa:	ee3a ab42 	vsub.f64	d10, d10, d2
10006fae:	ee26 4b09 	vmul.f64	d4, d6, d9
10006fb2:	ee3c cb08 	vadd.f64	d12, d12, d8
10006fb6:	ee3b bb08 	vadd.f64	d11, d11, d8
10006fba:	ed87 1b02 	vstr	d1, [r7, #8]
10006fbe:	ee35 1b41 	vsub.f64	d1, d5, d1
10006fc2:	ee27 5b09 	vmul.f64	d5, d7, d9
10006fc6:	ee3b bb40 	vsub.f64	d11, d11, d0
10006fca:	ed87 0b00 	vstr	d0, [r7]
10006fce:	ed87 2b04 	vstr	d2, [r7, #16]
10006fd2:	eebc 0bc4 	vcvt.u32.f64	s0, d4
10006fd6:	ee3c 2b43 	vsub.f64	d2, d12, d3
10006fda:	ed87 3b06 	vstr	d3, [r7, #24]
10006fde:	ee3a 3b4e 	vsub.f64	d3, d10, d14
10006fe2:	eebc abc5 	vcvt.u32.f64	s20, d5
10006fe6:	ee22 cb09 	vmul.f64	d12, d2, d9
10006fea:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10006fee:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10006ff2:	ed8d 3b02 	vstr	d3, [sp, #8]
10006ff6:	ee21 3b09 	vmul.f64	d3, d1, d9
10006ffa:	ee3b 5b4e 	vsub.f64	d5, d11, d14
10006ffe:	ee0a 7b48 	vmls.f64	d7, d10, d8
10007002:	ee00 6b48 	vmls.f64	d6, d0, d8
10007006:	eebc cbcc 	vcvt.u32.f64	s24, d12
1000700a:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000700e:	ed8d 5b00 	vstr	d5, [sp]
10007012:	eeb8 4b4c 	vcvt.f64.u32	d4, s24
10007016:	ee3d bb00 	vadd.f64	d11, d13, d0
1000701a:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000701e:	eeb0 cb47 	vmov.f64	d12, d7
10007022:	eeb0 db46 	vmov.f64	d13, d6
10007026:	ed9d 7b00 	vldr	d7, [sp]
1000702a:	ed9d 6b02 	vldr	d6, [sp, #8]
1000702e:	ee3f 5b0a 	vadd.f64	d5, d15, d10
10007032:	ee37 7b03 	vadd.f64	d7, d7, d3
10007036:	ee36 6b04 	vadd.f64	d6, d6, d4
1000703a:	ee25 0b09 	vmul.f64	d0, d5, d9
1000703e:	ee2b ab09 	vmul.f64	d10, d11, d9
10007042:	ee03 1b48 	vmls.f64	d1, d3, d8
10007046:	ee04 2b48 	vmls.f64	d2, d4, d8
1000704a:	ee27 3b09 	vmul.f64	d3, d7, d9
1000704e:	ee26 4b09 	vmul.f64	d4, d6, d9
10007052:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10007056:	eebc abca 	vcvt.u32.f64	s20, d10
1000705a:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000705e:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10007062:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10007066:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
1000706a:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000706e:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10007072:	ee00 5b48 	vmls.f64	d5, d0, d8
10007076:	ee0a bb48 	vmls.f64	d11, d10, d8
1000707a:	ee03 7b48 	vmls.f64	d7, d3, d8
1000707e:	ee04 6b48 	vmls.f64	d6, d4, d8
10007082:	3410      	adds	r4, #16
10007084:	3610      	adds	r6, #16
10007086:	3110      	adds	r1, #16
10007088:	3510      	adds	r5, #16
1000708a:	45a1      	cmp	r9, r4
1000708c:	ed04 cb02 	vstr	d12, [r4, #-8]
10007090:	ed04 5b04 	vstr	d5, [r4, #-16]
10007094:	ed06 bb04 	vstr	d11, [r6, #-16]
10007098:	ed06 db02 	vstr	d13, [r6, #-8]
1000709c:	ed01 1b02 	vstr	d1, [r1, #-8]
100070a0:	ed01 7b04 	vstr	d7, [r1, #-16]
100070a4:	ed05 6b04 	vstr	d6, [r5, #-16]
100070a8:	ed05 2b02 	vstr	d2, [r5, #-8]
100070ac:	f47f af5e 	bne.w	10006f6c <fndsa_vect_FFT_fp64_exact+0x174>
100070b0:	4640      	mov	r0, r8
100070b2:	9e04      	ldr	r6, [sp, #16]
100070b4:	9b06      	ldr	r3, [sp, #24]
100070b6:	9a0a      	ldr	r2, [sp, #40]	@ 0x28
100070b8:	3010      	adds	r0, #16
100070ba:	4282      	cmp	r2, r0
100070bc:	44b3      	add	fp, r6
100070be:	eb03 1306 	add.w	r3, r3, r6, lsl #4
100070c2:	eb09 1906 	add.w	r9, r9, r6, lsl #4
100070c6:	f47f aedc 	bne.w	10006e82 <fndsa_vect_FFT_fp64_exact+0x8a>
100070ca:	9c0c      	ldr	r4, [sp, #48]	@ 0x30
100070cc:	9b12      	ldr	r3, [sp, #72]	@ 0x48
100070ce:	3401      	adds	r4, #1
100070d0:	429c      	cmp	r4, r3
100070d2:	46d3      	mov	fp, sl
100070d4:	f8dd c020 	ldr.w	ip, [sp, #32]
100070d8:	f8dd 8038 	ldr.w	r8, [sp, #56]	@ 0x38
100070dc:	9e10      	ldr	r6, [sp, #64]	@ 0x40
100070de:	f4ff aeb1 	bcc.w	10006e44 <fndsa_vect_FFT_fp64_exact+0x4c>
100070e2:	4645      	mov	r5, r8
100070e4:	e9dd 8416 	ldrd	r8, r4, [sp, #88]	@ 0x58
100070e8:	2c02      	cmp	r4, #2
100070ea:	f8dd a050 	ldr.w	sl, [sp, #80]	@ 0x50
100070ee:	f000 840b 	beq.w	10007908 <fndsa_vect_FFT_fp64_exact+0xb10>
100070f2:	4631      	mov	r1, r6
100070f4:	2410      	movs	r4, #16
100070f6:	ed9f eb0a 	vldr	d14, [pc, #40]	@ 10007120 <fndsa_vect_FFT_fp64_exact+0x328>
100070fa:	ed9f fb0b 	vldr	d15, [pc, #44]	@ 10007128 <fndsa_vect_FFT_fp64_exact+0x330>
100070fe:	f108 33ff 	add.w	r3, r8, #4294967295	@ 0xffffffff
10007102:	fa04 f40a 	lsl.w	r4, r4, sl
10007106:	ea4f 0658 	mov.w	r6, r8, lsr #1
1000710a:	089b      	lsrs	r3, r3, #2
1000710c:	f101 0740 	add.w	r7, r1, #64	@ 0x40
10007110:	eb05 1606 	add.w	r6, r5, r6, lsl #4
10007114:	eb07 1783 	add.w	r7, r7, r3, lsl #6
10007118:	4425      	add	r5, r4
1000711a:	440c      	add	r4, r1
1000711c:	e00a      	b.n	10007134 <fndsa_vect_FFT_fp64_exact+0x33c>
1000711e:	bf00      	nop
10007120:	00000000 	.word	0x00000000
10007124:	3df00000 	.word	0x3df00000
10007128:	00000000 	.word	0x00000000
1000712c:	41f00000 	.word	0x41f00000
10007130:	300039a0 	.word	0x300039a0
10007134:	ed91 7b02 	vldr	d7, [r1, #8]
10007138:	ed91 3b06 	vldr	d3, [r1, #24]
1000713c:	ed8d 7b02 	vstr	d7, [sp, #8]
10007140:	edd6 7a00 	vldr	s15, [r6]
10007144:	ed94 2b04 	vldr	d2, [r4, #16]
10007148:	ed91 5b04 	vldr	d5, [r1, #16]
1000714c:	ed91 4b00 	vldr	d4, [r1]
10007150:	ed8d 3b00 	vstr	d3, [sp]
10007154:	eeb8 3b67 	vcvt.f64.u32	d3, s15
10007158:	edd6 7a02 	vldr	s15, [r6, #8]
1000715c:	6873      	ldr	r3, [r6, #4]
1000715e:	ed8d 2b06 	vstr	d2, [sp, #24]
10007162:	0fdb      	lsrs	r3, r3, #31
10007164:	ee02 3a10 	vmov	s4, r3
10007168:	68f3      	ldr	r3, [r6, #12]
1000716a:	ed94 6b02 	vldr	d6, [r4, #8]
1000716e:	0fdb      	lsrs	r3, r3, #31
10007170:	ed8d 5b0a 	vstr	d5, [sp, #40]	@ 0x28
10007174:	ed8d 4b0c 	vstr	d4, [sp, #48]	@ 0x30
10007178:	ee05 3a10 	vmov	s10, r3
1000717c:	eeb8 4b67 	vcvt.f64.u32	d4, s15
10007180:	edd6 7a01 	vldr	s15, [r6, #4]
10007184:	ed8d 6b12 	vstr	d6, [sp, #72]	@ 0x48
10007188:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
1000718c:	eeb8 6b67 	vcvt.f64.u32	d6, s15
10007190:	edd6 7a03 	vldr	s15, [r6, #12]
10007194:	ed94 bb00 	vldr	d11, [r4]
10007198:	ed94 1b06 	vldr	d1, [r4, #24]
1000719c:	ed94 0b0c 	vldr	d0, [r4, #48]	@ 0x30
100071a0:	eeb8 7b67 	vcvt.f64.u32	d7, s15
100071a4:	eeb8 2bc2 	vcvt.f64.s32	d2, s4
100071a8:	ed8d 3b42 	vstr	d3, [sp, #264]	@ 0x108
100071ac:	ed8d 4b4c 	vstr	d4, [sp, #304]	@ 0x130
100071b0:	ed8d 5b52 	vstr	d5, [sp, #328]	@ 0x148
100071b4:	ee33 5b04 	vadd.f64	d5, d3, d4
100071b8:	ee23 3b0e 	vmul.f64	d3, d3, d14
100071bc:	ee24 4b0e 	vmul.f64	d4, d4, d14
100071c0:	ed91 cb0c 	vldr	d12, [r1, #48]	@ 0x30
100071c4:	ed91 db0e 	vldr	d13, [r1, #56]	@ 0x38
100071c8:	ed8d bb08 	vstr	d11, [sp, #32]
100071cc:	ed8d 1b04 	vstr	d1, [sp, #16]
100071d0:	ed8d 0b10 	vstr	d0, [sp, #64]	@ 0x40
100071d4:	ed8d 2b48 	vstr	d2, [sp, #288]	@ 0x120
100071d8:	ed8d 6b40 	vstr	d6, [sp, #256]	@ 0x100
100071dc:	ed8d 7b4a 	vstr	d7, [sp, #296]	@ 0x128
100071e0:	ed8d 3b46 	vstr	d3, [sp, #280]	@ 0x118
100071e4:	ed8d 4b50 	vstr	d4, [sp, #320]	@ 0x140
100071e8:	ee25 4b0e 	vmul.f64	d4, d5, d14
100071ec:	eefc 3bc4 	vcvt.u32.f64	s7, d4
100071f0:	ee36 4b07 	vadd.f64	d4, d6, d7
100071f4:	ee27 7b0e 	vmul.f64	d7, d7, d14
100071f8:	ed8d 7b4e 	vstr	d7, [sp, #312]	@ 0x138
100071fc:	eeb8 7b63 	vcvt.f64.u32	d7, s7
10007200:	ee34 4b07 	vadd.f64	d4, d4, d7
10007204:	ee07 5b4f 	vmls.f64	d5, d7, d15
10007208:	ee24 7b0e 	vmul.f64	d7, d4, d14
1000720c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007210:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007214:	ee07 4b4f 	vmls.f64	d4, d7, d15
10007218:	eebc 7bc4 	vcvt.u32.f64	s14, d4
1000721c:	ee17 3a10 	vmov	r3, s14
10007220:	0fdb      	lsrs	r3, r3, #31
10007222:	ee07 3a10 	vmov	s14, r3
10007226:	ed94 8b0e 	vldr	d8, [r4, #56]	@ 0x38
1000722a:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
1000722e:	ee26 6b0e 	vmul.f64	d6, d6, d14
10007232:	ed8d 5b56 	vstr	d5, [sp, #344]	@ 0x158
10007236:	ed8d 4b54 	vstr	d4, [sp, #336]	@ 0x150
1000723a:	ee25 5b0e 	vmul.f64	d5, d5, d14
1000723e:	ee24 4b0e 	vmul.f64	d4, d4, d14
10007242:	ed91 0b08 	vldr	d0, [r1, #32]
10007246:	ed91 1b0a 	vldr	d1, [r1, #40]	@ 0x28
1000724a:	ed94 2b08 	vldr	d2, [r4, #32]
1000724e:	ed94 3b0a 	vldr	d3, [r4, #40]	@ 0x28
10007252:	a840      	add	r0, sp, #256	@ 0x100
10007254:	ed8d 4b58 	vstr	d4, [sp, #352]	@ 0x160
10007258:	ed8d 7b5c 	vstr	d7, [sp, #368]	@ 0x170
1000725c:	ed8d 6b44 	vstr	d6, [sp, #272]	@ 0x110
10007260:	ed8d 5b5a 	vstr	d5, [sp, #360]	@ 0x168
10007264:	ed8d 8b0e 	vstr	d8, [sp, #56]	@ 0x38
10007268:	f7fe ff5a 	bl	10006120 <fp64e_cmul_prepared>
1000726c:	eeb0 9b40 	vmov.f64	d9, d0
10007270:	eeb0 8b42 	vmov.f64	d8, d2
10007274:	eeb0 bb41 	vmov.f64	d11, d1
10007278:	eeb0 ab43 	vmov.f64	d10, d3
1000727c:	ed9d 2b10 	vldr	d2, [sp, #64]	@ 0x40
10007280:	eeb0 0b4c 	vmov.f64	d0, d12
10007284:	eeb0 1b4d 	vmov.f64	d1, d13
10007288:	ed9d 3b0e 	vldr	d3, [sp, #56]	@ 0x38
1000728c:	ed8d 9b20 	vstr	d9, [sp, #128]	@ 0x80
10007290:	ed8d bb22 	vstr	d11, [sp, #136]	@ 0x88
10007294:	ed8d 8b24 	vstr	d8, [sp, #144]	@ 0x90
10007298:	ed8d ab26 	vstr	d10, [sp, #152]	@ 0x98
1000729c:	f7fe ff40 	bl	10006120 <fp64e_cmul_prepared>
100072a0:	edd5 7a00 	vldr	s15, [r5]
100072a4:	eeb8 5b67 	vcvt.f64.u32	d5, s15
100072a8:	edd5 7a02 	vldr	s15, [r5, #8]
100072ac:	eeb8 6b67 	vcvt.f64.u32	d6, s15
100072b0:	edd5 7a01 	vldr	s15, [r5, #4]
100072b4:	686b      	ldr	r3, [r5, #4]
100072b6:	eeb8 cb67 	vcvt.f64.u32	d12, s15
100072ba:	0fdb      	lsrs	r3, r3, #31
100072bc:	ee04 3a10 	vmov	s8, r3
100072c0:	68eb      	ldr	r3, [r5, #12]
100072c2:	edd5 7a03 	vldr	s15, [r5, #12]
100072c6:	0fdb      	lsrs	r3, r3, #31
100072c8:	ee07 3a10 	vmov	s14, r3
100072cc:	eeb8 db67 	vcvt.f64.u32	d13, s15
100072d0:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100072d4:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
100072d8:	ed8d 6b4c 	vstr	d6, [sp, #304]	@ 0x130
100072dc:	ed8d 7b52 	vstr	d7, [sp, #328]	@ 0x148
100072e0:	ee35 7b06 	vadd.f64	d7, d5, d6
100072e4:	ee26 6b0e 	vmul.f64	d6, d6, d14
100072e8:	ed8d 4b48 	vstr	d4, [sp, #288]	@ 0x120
100072ec:	ed8d 5b42 	vstr	d5, [sp, #264]	@ 0x108
100072f0:	ed9d 4b02 	vldr	d4, [sp, #8]
100072f4:	ee25 5b0e 	vmul.f64	d5, d5, d14
100072f8:	ed8d 6b50 	vstr	d6, [sp, #320]	@ 0x140
100072fc:	ee27 6b0e 	vmul.f64	d6, d7, d14
10007300:	ed8d 5b46 	vstr	d5, [sp, #280]	@ 0x118
10007304:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007308:	ee34 5b0f 	vadd.f64	d5, d4, d15
1000730c:	ee34 4b0b 	vadd.f64	d4, d4, d11
10007310:	ed8d 4b10 	vstr	d4, [sp, #64]	@ 0x40
10007314:	eeb8 4b46 	vcvt.f64.u32	d4, s12
10007318:	ee04 7b4f 	vmls.f64	d7, d4, d15
1000731c:	ed9d 6b12 	vldr	d6, [sp, #72]	@ 0x48
10007320:	ed8d 7b56 	vstr	d7, [sp, #344]	@ 0x158
10007324:	ee27 7b0e 	vmul.f64	d7, d7, d14
10007328:	ed8d 7b5a 	vstr	d7, [sp, #360]	@ 0x168
1000732c:	ee36 7b0f 	vadd.f64	d7, d6, d15
10007330:	ee3a 6b06 	vadd.f64	d6, d10, d6
10007334:	ed8d 0b28 	vstr	d0, [sp, #160]	@ 0xa0
10007338:	ed8d 1b2a 	vstr	d1, [sp, #168]	@ 0xa8
1000733c:	ed8d 2b2c 	vstr	d2, [sp, #176]	@ 0xb0
10007340:	ed8d 3b2e 	vstr	d3, [sp, #184]	@ 0xb8
10007344:	ed8d cb40 	vstr	d12, [sp, #256]	@ 0x100
10007348:	ed8d db4a 	vstr	d13, [sp, #296]	@ 0x128
1000734c:	ed8d 6b0e 	vstr	d6, [sp, #56]	@ 0x38
10007350:	ed9d 6b00 	vldr	d6, [sp]
10007354:	ee37 ab4a 	vsub.f64	d10, d7, d10
10007358:	ee36 7b0f 	vadd.f64	d7, d6, d15
1000735c:	ee36 6b01 	vadd.f64	d6, d6, d1
10007360:	ee37 7b41 	vsub.f64	d7, d7, d1
10007364:	ed9d 1b04 	vldr	d1, [sp, #16]
10007368:	ee35 bb4b 	vsub.f64	d11, d5, d11
1000736c:	ee31 5b0f 	vadd.f64	d5, d1, d15
10007370:	ed8d 7b02 	vstr	d7, [sp, #8]
10007374:	ee31 7b03 	vadd.f64	d7, d1, d3
10007378:	ee35 3b43 	vsub.f64	d3, d5, d3
1000737c:	ee3c 5b0d 	vadd.f64	d5, d12, d13
10007380:	ee35 1b04 	vadd.f64	d1, d5, d4
10007384:	ee26 5b0e 	vmul.f64	d5, d6, d14
10007388:	ee2c cb0e 	vmul.f64	d12, d12, d14
1000738c:	eefc 4bc5 	vcvt.u32.f64	s9, d5
10007390:	ee27 5b0e 	vmul.f64	d5, d7, d14
10007394:	ed8d cb44 	vstr	d12, [sp, #272]	@ 0x110
10007398:	ee2d db0e 	vmul.f64	d13, d13, d14
1000739c:	eeb8 cb64 	vcvt.f64.u32	d12, s9
100073a0:	eefc 5bc5 	vcvt.u32.f64	s11, d5
100073a4:	ed9d 4b0e 	vldr	d4, [sp, #56]	@ 0x38
100073a8:	ed8d 1b14 	vstr	d1, [sp, #80]	@ 0x50
100073ac:	ed8d db4e 	vstr	d13, [sp, #312]	@ 0x138
100073b0:	eeb0 1b46 	vmov.f64	d1, d6
100073b4:	eeb8 db65 	vcvt.f64.u32	d13, s11
100073b8:	ee24 6b0e 	vmul.f64	d6, d4, d14
100073bc:	ed9d 5b10 	vldr	d5, [sp, #64]	@ 0x40
100073c0:	ed8d 3b00 	vstr	d3, [sp]
100073c4:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100073c8:	eeb0 3b47 	vmov.f64	d3, d7
100073cc:	ee25 7b0e 	vmul.f64	d7, d5, d14
100073d0:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100073d4:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100073d8:	ee06 4b4f 	vmls.f64	d4, d6, d15
100073dc:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100073e0:	ed8d 6b04 	vstr	d6, [sp, #16]
100073e4:	ee07 5b4f 	vmls.f64	d5, d7, d15
100073e8:	ee2b 6b0e 	vmul.f64	d6, d11, d14
100073ec:	ed8d 4b0e 	vstr	d4, [sp, #56]	@ 0x38
100073f0:	ed9d 4b0c 	vldr	d4, [sp, #48]	@ 0x30
100073f4:	ed8d 5b12 	vstr	d5, [sp, #72]	@ 0x48
100073f8:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100073fc:	ee34 5b0f 	vadd.f64	d5, d4, d15
10007400:	ee34 4b09 	vadd.f64	d4, d4, d9
10007404:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10007408:	ee34 4b07 	vadd.f64	d4, d4, d7
1000740c:	ee35 5b49 	vsub.f64	d5, d5, d9
10007410:	eeb7 7b00 	vmov.f64	d7, #112	@ 0x3f800000  1.0
10007414:	eeb0 9b4b 	vmov.f64	d9, d11
10007418:	ee35 5b47 	vsub.f64	d5, d5, d7
1000741c:	ed9d bb08 	vldr	d11, [sp, #32]
10007420:	ee06 9b4f 	vmls.f64	d9, d6, d15
10007424:	ee2a 7b0e 	vmul.f64	d7, d10, d14
10007428:	ed8d 9b0c 	vstr	d9, [sp, #48]	@ 0x30
1000742c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007430:	ee35 9b06 	vadd.f64	d9, d5, d6
10007434:	ee3b 6b0f 	vadd.f64	d6, d11, d15
10007438:	ee3b 5b08 	vadd.f64	d5, d11, d8
1000743c:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007440:	eeb7 bb00 	vmov.f64	d11, #112	@ 0x3f800000  1.0
10007444:	ee36 6b48 	vsub.f64	d6, d6, d8
10007448:	ee07 ab4f 	vmls.f64	d10, d7, d15
1000744c:	ee36 6b4b 	vsub.f64	d6, d6, d11
10007450:	ed9d 8b04 	vldr	d8, [sp, #16]
10007454:	ed8d ab08 	vstr	d10, [sp, #32]
10007458:	ee36 ab07 	vadd.f64	d10, d6, d7
1000745c:	ed9d 6b02 	vldr	d6, [sp, #8]
10007460:	ee35 8b08 	vadd.f64	d8, d5, d8
10007464:	ee26 5b0e 	vmul.f64	d5, d6, d14
10007468:	ed9d 6b0a 	vldr	d6, [sp, #40]	@ 0x28
1000746c:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10007470:	ee36 7b0f 	vadd.f64	d7, d6, d15
10007474:	ee36 6b00 	vadd.f64	d6, d6, d0
10007478:	ee37 7b40 	vsub.f64	d7, d7, d0
1000747c:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10007480:	ee36 0b0c 	vadd.f64	d0, d6, d12
10007484:	ed9d 6b02 	vldr	d6, [sp, #8]
10007488:	ee05 6b4f 	vmls.f64	d6, d5, d15
1000748c:	ee0c 1b4f 	vmls.f64	d1, d12, d15
10007490:	ee37 7b4b 	vsub.f64	d7, d7, d11
10007494:	eeb0 cb4b 	vmov.f64	d12, d11
10007498:	ed8d 6b02 	vstr	d6, [sp, #8]
1000749c:	ed9d bb00 	vldr	d11, [sp]
100074a0:	ed9d 6b06 	vldr	d6, [sp, #24]
100074a4:	ee37 5b05 	vadd.f64	d5, d7, d5
100074a8:	ee2b bb0e 	vmul.f64	d11, d11, d14
100074ac:	ee36 7b0f 	vadd.f64	d7, d6, d15
100074b0:	eebc bbcb 	vcvt.u32.f64	s22, d11
100074b4:	ee36 6b02 	vadd.f64	d6, d6, d2
100074b8:	ee37 7b42 	vsub.f64	d7, d7, d2
100074bc:	ee0d 3b4f 	vmls.f64	d3, d13, d15
100074c0:	ee36 2b0d 	vadd.f64	d2, d6, d13
100074c4:	ee37 7b4c 	vsub.f64	d7, d7, d12
100074c8:	ed9d db00 	vldr	d13, [sp]
100074cc:	eeb8 bb4b 	vcvt.f64.u32	d11, s22
100074d0:	ee0b db4f 	vmls.f64	d13, d11, d15
100074d4:	ee37 bb0b 	vadd.f64	d11, d7, d11
100074d8:	ed9d 7b14 	vldr	d7, [sp, #80]	@ 0x50
100074dc:	ee27 6b0e 	vmul.f64	d6, d7, d14
100074e0:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100074e4:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100074e8:	ee06 7b4f 	vmls.f64	d7, d6, d15
100074ec:	eefc 6bc7 	vcvt.u32.f64	s13, d7
100074f0:	ee16 3a90 	vmov	r3, s13
100074f4:	ed8d 7b54 	vstr	d7, [sp, #336]	@ 0x150
100074f8:	ee27 7b0e 	vmul.f64	d7, d7, d14
100074fc:	0fdb      	lsrs	r3, r3, #31
100074fe:	ed8d 7b58 	vstr	d7, [sp, #352]	@ 0x160
10007502:	ee07 3a10 	vmov	s14, r3
10007506:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
1000750a:	ed8d 7b5c 	vstr	d7, [sp, #368]	@ 0x170
1000750e:	ee24 7b0e 	vmul.f64	d7, d4, d14
10007512:	ee22 6b0e 	vmul.f64	d6, d2, d14
10007516:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000751a:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000751e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007522:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10007526:	ee07 4b4f 	vmls.f64	d4, d7, d15
1000752a:	ee29 7b0e 	vmul.f64	d7, d9, d14
1000752e:	ee06 2b4f 	vmls.f64	d2, d6, d15
10007532:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007536:	ee28 6b0e 	vmul.f64	d6, d8, d14
1000753a:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000753e:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007542:	ee07 9b4f 	vmls.f64	d9, d7, d15
10007546:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000754a:	ee25 7b0e 	vmul.f64	d7, d5, d14
1000754e:	ee06 8b4f 	vmls.f64	d8, d6, d15
10007552:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007556:	ee2a 6b0e 	vmul.f64	d6, d10, d14
1000755a:	ed8d 8b0a 	vstr	d8, [sp, #40]	@ 0x28
1000755e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007562:	eeb0 8b45 	vmov.f64	d8, d5
10007566:	ee20 cb0e 	vmul.f64	d12, d0, d14
1000756a:	ee07 8b4f 	vmls.f64	d8, d7, d15
1000756e:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007572:	ee2b 7b0e 	vmul.f64	d7, d11, d14
10007576:	eebc cbcc 	vcvt.u32.f64	s24, d12
1000757a:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000757e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007582:	eeb8 cb4c 	vcvt.f64.u32	d12, s24
10007586:	ee06 ab4f 	vmls.f64	d10, d6, d15
1000758a:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000758e:	ee0c 0b4f 	vmls.f64	d0, d12, d15
10007592:	ee07 bb4f 	vmls.f64	d11, d7, d15
10007596:	ed8d 4b10 	vstr	d4, [sp, #64]	@ 0x40
1000759a:	ed8d db00 	vstr	d13, [sp]
1000759e:	ed8d 9b06 	vstr	d9, [sp, #24]
100075a2:	ed8d ab04 	vstr	d10, [sp, #16]
100075a6:	f7fe fdbb 	bl	10006120 <fp64e_cmul_prepared>
100075aa:	edd5 7a04 	vldr	s15, [r5, #16]
100075ae:	696b      	ldr	r3, [r5, #20]
100075b0:	eeb0 db42 	vmov.f64	d13, d2
100075b4:	0fdb      	lsrs	r3, r3, #31
100075b6:	eeb0 2b4b 	vmov.f64	d2, d11
100075ba:	ee0b 3a10 	vmov	s22, r3
100075be:	69eb      	ldr	r3, [r5, #28]
100075c0:	eeb0 cb40 	vmov.f64	d12, d0
100075c4:	0fdb      	lsrs	r3, r3, #31
100075c6:	eeb0 0b48 	vmov.f64	d0, d8
100075ca:	ee05 3a10 	vmov	s10, r3
100075ce:	eeb8 8b67 	vcvt.f64.u32	d8, s15
100075d2:	edd5 7a06 	vldr	s15, [r5, #24]
100075d6:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
100075da:	eeb8 4b67 	vcvt.f64.u32	d4, s15
100075de:	ed8d 8b42 	vstr	d8, [sp, #264]	@ 0x108
100075e2:	edd5 7a05 	vldr	s15, [r5, #20]
100075e6:	ed8d 5b52 	vstr	d5, [sp, #328]	@ 0x148
100075ea:	ee38 5b04 	vadd.f64	d5, d8, d4
100075ee:	ee28 8b0e 	vmul.f64	d8, d8, d14
100075f2:	eeb8 6b67 	vcvt.f64.u32	d6, s15
100075f6:	ed8d 8b46 	vstr	d8, [sp, #280]	@ 0x118
100075fa:	edd5 7a07 	vldr	s15, [r5, #28]
100075fe:	ee25 8b0e 	vmul.f64	d8, d5, d14
10007602:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10007606:	ed8d 4b4c 	vstr	d4, [sp, #304]	@ 0x130
1000760a:	eebc 8bc8 	vcvt.u32.f64	s16, d8
1000760e:	ee24 4b0e 	vmul.f64	d4, d4, d14
10007612:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10007616:	ed8d 4b50 	vstr	d4, [sp, #320]	@ 0x140
1000761a:	ee36 4b07 	vadd.f64	d4, d6, d7
1000761e:	ed8d 7b4a 	vstr	d7, [sp, #296]	@ 0x128
10007622:	ee34 4b08 	vadd.f64	d4, d4, d8
10007626:	ee27 7b0e 	vmul.f64	d7, d7, d14
1000762a:	ed8d 7b4e 	vstr	d7, [sp, #312]	@ 0x138
1000762e:	ee24 7b0e 	vmul.f64	d7, d4, d14
10007632:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007636:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000763a:	ee07 4b4f 	vmls.f64	d4, d7, d15
1000763e:	eebc 7bc4 	vcvt.u32.f64	s14, d4
10007642:	ee17 3a10 	vmov	r3, s14
10007646:	0fdb      	lsrs	r3, r3, #31
10007648:	ee08 5b4f 	vmls.f64	d5, d8, d15
1000764c:	ee07 3a10 	vmov	s14, r3
10007650:	eeb0 ab41 	vmov.f64	d10, d1
10007654:	eeb0 9b43 	vmov.f64	d9, d3
10007658:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
1000765c:	eeb8 bbcb 	vcvt.f64.s32	d11, s22
10007660:	ed8d 6b40 	vstr	d6, [sp, #256]	@ 0x100
10007664:	ed8d 5b56 	vstr	d5, [sp, #344]	@ 0x158
10007668:	ee26 6b0e 	vmul.f64	d6, d6, d14
1000766c:	ee25 5b0e 	vmul.f64	d5, d5, d14
10007670:	ed8d 4b54 	vstr	d4, [sp, #336]	@ 0x150
10007674:	ee24 4b0e 	vmul.f64	d4, d4, d14
10007678:	ed9d 1b02 	vldr	d1, [sp, #8]
1000767c:	ed9d 3b00 	vldr	d3, [sp]
10007680:	ed8d cb30 	vstr	d12, [sp, #192]	@ 0xc0
10007684:	ed8d ab32 	vstr	d10, [sp, #200]	@ 0xc8
10007688:	ed8d db34 	vstr	d13, [sp, #208]	@ 0xd0
1000768c:	ed8d 9b36 	vstr	d9, [sp, #216]	@ 0xd8
10007690:	ed8d bb48 	vstr	d11, [sp, #288]	@ 0x120
10007694:	ed8d 6b44 	vstr	d6, [sp, #272]	@ 0x110
10007698:	ed8d 5b5a 	vstr	d5, [sp, #360]	@ 0x168
1000769c:	ed8d 4b58 	vstr	d4, [sp, #352]	@ 0x160
100076a0:	ed8d 7b5c 	vstr	d7, [sp, #368]	@ 0x170
100076a4:	f7fe fd3c 	bl	10006120 <fp64e_cmul_prepared>
100076a8:	ed9d 5b12 	vldr	d5, [sp, #72]	@ 0x48
100076ac:	ed9d 7b0e 	vldr	d7, [sp, #56]	@ 0x38
100076b0:	ee35 6b0a 	vadd.f64	d6, d5, d10
100076b4:	ee35 4b0f 	vadd.f64	d4, d5, d15
100076b8:	ed9d 5b0c 	vldr	d5, [sp, #48]	@ 0x30
100076bc:	ee37 8b0f 	vadd.f64	d8, d7, d15
100076c0:	ee35 bb0f 	vadd.f64	d11, d5, d15
100076c4:	ee37 7b09 	vadd.f64	d7, d7, d9
100076c8:	ee38 8b49 	vsub.f64	d8, d8, d9
100076cc:	ee3b bb41 	vsub.f64	d11, d11, d1
100076d0:	ee35 9b01 	vadd.f64	d9, d5, d1
100076d4:	ed8d 1b3a 	vstr	d1, [sp, #232]	@ 0xe8
100076d8:	ed9d 1b08 	vldr	d1, [sp, #32]
100076dc:	ee31 5b0f 	vadd.f64	d5, d1, d15
100076e0:	ee35 5b43 	vsub.f64	d5, d5, d3
100076e4:	ee34 4b4a 	vsub.f64	d4, d4, d10
100076e8:	ed8d 5b00 	vstr	d5, [sp]
100076ec:	ee31 ab03 	vadd.f64	d10, d1, d3
100076f0:	ee26 5b0e 	vmul.f64	d5, d6, d14
100076f4:	ed8d 3b3e 	vstr	d3, [sp, #248]	@ 0xf8
100076f8:	ee27 3b0e 	vmul.f64	d3, d7, d14
100076fc:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10007700:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10007704:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10007708:	eeb8 1b43 	vcvt.f64.u32	d1, s6
1000770c:	ee05 6b4f 	vmls.f64	d6, d5, d15
10007710:	ee01 7b4f 	vmls.f64	d7, d1, d15
10007714:	ed9d 3b10 	vldr	d3, [sp, #64]	@ 0x40
10007718:	ed8d 7b02 	vstr	d7, [sp, #8]
1000771c:	ed81 6b02 	vstr	d6, [r1, #8]
10007720:	ee24 7b0e 	vmul.f64	d7, d4, d14
10007724:	ee33 6b0f 	vadd.f64	d6, d3, d15
10007728:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000772c:	ee33 3b0c 	vadd.f64	d3, d3, d12
10007730:	ee36 6b4c 	vsub.f64	d6, d6, d12
10007734:	eeb7 cb00 	vmov.f64	d12, #112	@ 0x3f800000  1.0
10007738:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000773c:	ee36 6b4c 	vsub.f64	d6, d6, d12
10007740:	eeb0 cb44 	vmov.f64	d12, d4
10007744:	ee07 cb4f 	vmls.f64	d12, d7, d15
10007748:	ed9d 4b0a 	vldr	d4, [sp, #40]	@ 0x28
1000774c:	ed8d cb08 	vstr	d12, [sp, #32]
10007750:	ee36 cb07 	vadd.f64	d12, d6, d7
10007754:	ee28 7b0e 	vmul.f64	d7, d8, d14
10007758:	ee33 3b05 	vadd.f64	d3, d3, d5
1000775c:	ee34 6b0f 	vadd.f64	d6, d4, d15
10007760:	ee34 5b0d 	vadd.f64	d5, d4, d13
10007764:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007768:	ee35 1b01 	vadd.f64	d1, d5, d1
1000776c:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007770:	ee36 6b4d 	vsub.f64	d6, d6, d13
10007774:	eeb7 5b00 	vmov.f64	d5, #112	@ 0x3f800000  1.0
10007778:	ee07 8b4f 	vmls.f64	d8, d7, d15
1000777c:	ee36 6b45 	vsub.f64	d6, d6, d5
10007780:	eeb0 db48 	vmov.f64	d13, d8
10007784:	ee2b 5b0e 	vmul.f64	d5, d11, d14
10007788:	ee36 8b07 	vadd.f64	d8, d6, d7
1000778c:	ee29 7b0e 	vmul.f64	d7, d9, d14
10007790:	ed9d 4b06 	vldr	d4, [sp, #24]
10007794:	eefc 5bc5 	vcvt.u32.f64	s11, d5
10007798:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000779c:	edcd 5a0a 	vstr	s11, [sp, #40]	@ 0x28
100077a0:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100077a4:	ee34 5b0f 	vadd.f64	d5, d4, d15
100077a8:	ee34 4b00 	vadd.f64	d4, d4, d0
100077ac:	ee07 9b4f 	vmls.f64	d9, d7, d15
100077b0:	ed8d 0b38 	vstr	d0, [sp, #224]	@ 0xe0
100077b4:	ee35 5b40 	vsub.f64	d5, d5, d0
100077b8:	ee34 0b07 	vadd.f64	d0, d4, d7
100077bc:	eddd 7a0a 	vldr	s15, [sp, #40]	@ 0x28
100077c0:	eeb7 4b00 	vmov.f64	d4, #112	@ 0x3f800000  1.0
100077c4:	eeb8 7b67 	vcvt.f64.u32	d7, s15
100077c8:	ee35 5b44 	vsub.f64	d5, d5, d4
100077cc:	ee07 bb4f 	vmls.f64	d11, d7, d15
100077d0:	ee35 5b07 	vadd.f64	d5, d5, d7
100077d4:	ed9d 7b00 	vldr	d7, [sp]
100077d8:	ee2a 6b0e 	vmul.f64	d6, d10, d14
100077dc:	ee27 7b0e 	vmul.f64	d7, d7, d14
100077e0:	ed9d 4b04 	vldr	d4, [sp, #16]
100077e4:	eefc 7bc7 	vcvt.u32.f64	s15, d7
100077e8:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100077ec:	edcd 7a06 	vstr	s15, [sp, #24]
100077f0:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100077f4:	ee34 7b0f 	vadd.f64	d7, d4, d15
100077f8:	ee34 4b02 	vadd.f64	d4, d4, d2
100077fc:	ee06 ab4f 	vmls.f64	d10, d6, d15
10007800:	ee34 4b06 	vadd.f64	d4, d4, d6
10007804:	ed8d 2b3c 	vstr	d2, [sp, #240]	@ 0xf0
10007808:	ee37 7b42 	vsub.f64	d7, d7, d2
1000780c:	eddd 6a06 	vldr	s13, [sp, #24]
10007810:	eeb7 2b00 	vmov.f64	d2, #112	@ 0x3f800000  1.0
10007814:	eeb8 6b66 	vcvt.f64.u32	d6, s13
10007818:	ee37 7b42 	vsub.f64	d7, d7, d2
1000781c:	ed9d 2b00 	vldr	d2, [sp]
10007820:	ee06 2b4f 	vmls.f64	d2, d6, d15
10007824:	ed8d 2b00 	vstr	d2, [sp]
10007828:	ee23 2b0e 	vmul.f64	d2, d3, d14
1000782c:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10007830:	ee37 7b06 	vadd.f64	d7, d7, d6
10007834:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10007838:	ee21 6b0e 	vmul.f64	d6, d1, d14
1000783c:	ee02 3b4f 	vmls.f64	d3, d2, d15
10007840:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007844:	ed81 3b00 	vstr	d3, [r1]
10007848:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000784c:	ed9d 3b02 	vldr	d3, [sp, #8]
10007850:	ee06 1b4f 	vmls.f64	d1, d6, d15
10007854:	ed84 3b02 	vstr	d3, [r4, #8]
10007858:	ed9d 6b08 	vldr	d6, [sp, #32]
1000785c:	ee2c 3b0e 	vmul.f64	d3, d12, d14
10007860:	ed84 1b00 	vstr	d1, [r4]
10007864:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10007868:	ed81 6b06 	vstr	d6, [r1, #24]
1000786c:	ee28 6b0e 	vmul.f64	d6, d8, d14
10007870:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10007874:	eefc 6bc6 	vcvt.u32.f64	s13, d6
10007878:	ee03 cb4f 	vmls.f64	d12, d3, d15
1000787c:	eeb8 3b66 	vcvt.f64.u32	d3, s13
10007880:	ee20 6b0e 	vmul.f64	d6, d0, d14
10007884:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007888:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000788c:	ee24 1b0e 	vmul.f64	d1, d4, d14
10007890:	ee03 8b4f 	vmls.f64	d8, d3, d15
10007894:	ee06 0b4f 	vmls.f64	d0, d6, d15
10007898:	ee25 3b0e 	vmul.f64	d3, d5, d14
1000789c:	ee27 6b0e 	vmul.f64	d6, d7, d14
100078a0:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100078a4:	eebc 1bc1 	vcvt.u32.f64	s2, d1
100078a8:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100078ac:	eeb8 1b41 	vcvt.f64.u32	d1, s2
100078b0:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100078b4:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100078b8:	ee01 4b4f 	vmls.f64	d4, d1, d15
100078bc:	ee03 5b4f 	vmls.f64	d5, d3, d15
100078c0:	ed9d 2b00 	vldr	d2, [sp]
100078c4:	ee06 7b4f 	vmls.f64	d7, d6, d15
100078c8:	3140      	adds	r1, #64	@ 0x40
100078ca:	428f      	cmp	r7, r1
100078cc:	f104 0440 	add.w	r4, r4, #64	@ 0x40
100078d0:	ed01 cb0c 	vstr	d12, [r1, #-48]	@ 0xffffffd0
100078d4:	f106 0610 	add.w	r6, r6, #16
100078d8:	ed04 db0a 	vstr	d13, [r4, #-40]	@ 0xffffffd8
100078dc:	ed04 8b0c 	vstr	d8, [r4, #-48]	@ 0xffffffd0
100078e0:	f105 0520 	add.w	r5, r5, #32
100078e4:	ed01 9b06 	vstr	d9, [r1, #-24]	@ 0xffffffe8
100078e8:	ed01 0b08 	vstr	d0, [r1, #-32]	@ 0xffffffe0
100078ec:	ed04 ab06 	vstr	d10, [r4, #-24]	@ 0xffffffe8
100078f0:	ed04 4b08 	vstr	d4, [r4, #-32]	@ 0xffffffe0
100078f4:	ed01 5b04 	vstr	d5, [r1, #-16]
100078f8:	ed01 bb02 	vstr	d11, [r1, #-8]
100078fc:	ed04 2b02 	vstr	d2, [r4, #-8]
10007900:	ed04 7b04 	vstr	d7, [r4, #-16]
10007904:	f47f ac16 	bne.w	10007134 <fndsa_vect_FFT_fp64_exact+0x33c>
10007908:	b05f      	add	sp, #380	@ 0x17c
1000790a:	ecbd 8b10 	vpop	{d8-d15}
1000790e:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10007912:	2803      	cmp	r0, #3
10007914:	f1a0 0e02 	sub.w	lr, r0, #2
10007918:	f47f aa81 	bne.w	10006e1e <fndsa_vect_FFT_fp64_exact+0x26>
1000791c:	4d01      	ldr	r5, [pc, #4]	@ (10007924 <fndsa_vect_FFT_fp64_exact+0xb2c>)
1000791e:	f7ff bbe8 	b.w	100070f2 <fndsa_vect_FFT_fp64_exact+0x2fa>
10007922:	bf00      	nop
10007924:	300039a0 	.word	0x300039a0

