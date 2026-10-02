10006f98 <fndsa_vect_iFFT_fp64_exact>:
10006f98:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10006f9c:	ed2d 8b10 	vpush	{d8-d15}
10006fa0:	2802      	cmp	r0, #2
10006fa2:	460d      	mov	r5, r1
10006fa4:	b0e5      	sub	sp, #404	@ 0x194
10006fa6:	f100 3aff 	add.w	sl, r0, #4294967295	@ 0xffffffff
10006faa:	f241 831c 	bls.w	100085e6 <fndsa_vect_iFFT_fp64_exact+0x164e>
10006fae:	2301      	movs	r3, #1
10006fb0:	2410      	movs	r4, #16
10006fb2:	4683      	mov	fp, r0
10006fb4:	ed9f fbf8 	vldr	d15, [pc, #992]	@ 10007398 <fndsa_vect_iFFT_fp64_exact+0x400>
10006fb8:	ed9f ebf9 	vldr	d14, [pc, #996]	@ 100073a0 <fndsa_vect_iFFT_fp64_exact+0x408>
10006fbc:	fa03 f30a 	lsl.w	r3, r3, sl
10006fc0:	4efb      	ldr	r6, [pc, #1004]	@ (100073b0 <fndsa_vect_iFFT_fp64_exact+0x418>)
10006fc2:	1e5a      	subs	r2, r3, #1
10006fc4:	fa04 f40a 	lsl.w	r4, r4, sl
10006fc8:	f101 0840 	add.w	r8, r1, #64	@ 0x40
10006fcc:	085b      	lsrs	r3, r3, #1
10006fce:	0892      	lsrs	r2, r2, #2
10006fd0:	eb06 1703 	add.w	r7, r6, r3, lsl #4
10006fd4:	eb08 1882 	add.w	r8, r8, r2, lsl #6
10006fd8:	4426      	add	r6, r4
10006fda:	440c      	add	r4, r1
10006fdc:	edd6 7a02 	vldr	s15, [r6, #8]
10006fe0:	eeb8 db67 	vcvt.f64.u32	d13, s15
10006fe4:	edd6 7a03 	vldr	s15, [r6, #12]
10006fe8:	6873      	ldr	r3, [r6, #4]
10006fea:	eeb8 2b67 	vcvt.f64.u32	d2, s15
10006fee:	0fdb      	lsrs	r3, r3, #31
10006ff0:	ee08 3a10 	vmov	s16, r3
10006ff4:	eeb7 0b00 	vmov.f64	d0, #112	@ 0x3f800000  1.0
10006ff8:	eeb8 8bc8 	vcvt.f64.s32	d8, s16
10006ffc:	ee3e 2b42 	vsub.f64	d2, d14, d2
10007000:	ed91 9b0a 	vldr	d9, [r1, #40]	@ 0x28
10007004:	edd6 7a00 	vldr	s15, [r6]
10007008:	ed91 4b02 	vldr	d4, [r1, #8]
1000700c:	ed91 bb0e 	vldr	d11, [r1, #56]	@ 0x38
10007010:	ed94 ab0a 	vldr	d10, [r4, #40]	@ 0x28
10007014:	eeb8 6b67 	vcvt.f64.u32	d6, s15
10007018:	ee32 2b40 	vsub.f64	d2, d2, d0
1000701c:	edd6 7a01 	vldr	s15, [r6, #4]
10007020:	ed8d 8b4e 	vstr	d8, [sp, #312]	@ 0x138
10007024:	ed91 3b06 	vldr	d3, [r1, #24]
10007028:	ed94 5b02 	vldr	d5, [r4, #8]
1000702c:	ed94 cb0e 	vldr	d12, [r4, #56]	@ 0x38
10007030:	ee39 8b0e 	vadd.f64	d8, d9, d14
10007034:	ed8d 2b12 	vstr	d2, [sp, #72]	@ 0x48
10007038:	ee39 9b0b 	vadd.f64	d9, d9, d11
1000703c:	ee38 bb4b 	vsub.f64	d11, d8, d11
10007040:	ed91 8b00 	vldr	d8, [r1]
10007044:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10007048:	ee34 2b0e 	vadd.f64	d2, d4, d14
1000704c:	ee3a 0b0e 	vadd.f64	d0, d10, d14
10007050:	ee33 4b04 	vadd.f64	d4, d3, d4
10007054:	ed94 1b06 	vldr	d1, [r4, #24]
10007058:	ed8d 7b00 	vstr	d7, [sp]
1000705c:	ed8d 7b46 	vstr	d7, [sp, #280]	@ 0x118
10007060:	ed91 7b00 	vldr	d7, [r1]
10007064:	ee32 2b43 	vsub.f64	d2, d2, d3
10007068:	ee3a ab0c 	vadd.f64	d10, d10, d12
1000706c:	ee30 cb4c 	vsub.f64	d12, d0, d12
10007070:	ee35 3b0e 	vadd.f64	d3, d5, d14
10007074:	ee38 0b0e 	vadd.f64	d0, d8, d14
10007078:	ed91 8b04 	vldr	d8, [r1, #16]
1000707c:	ee35 5b01 	vadd.f64	d5, d5, d1
10007080:	ee33 3b41 	vsub.f64	d3, d3, d1
10007084:	ee38 8b07 	vadd.f64	d8, d8, d7
10007088:	ee22 1b0f 	vmul.f64	d1, d2, d15
1000708c:	ed8d 8b02 	vstr	d8, [sp, #8]
10007090:	ed91 8b04 	vldr	d8, [r1, #16]
10007094:	eeb7 7b00 	vmov.f64	d7, #112	@ 0x3f800000  1.0
10007098:	eebc 1bc1 	vcvt.u32.f64	s2, d1
1000709c:	ee30 0b48 	vsub.f64	d0, d0, d8
100070a0:	ed94 8b00 	vldr	d8, [r4]
100070a4:	eeb8 1b41 	vcvt.f64.u32	d1, s2
100070a8:	ee30 0b47 	vsub.f64	d0, d0, d7
100070ac:	ee01 2b4e 	vmls.f64	d2, d1, d14
100070b0:	ee30 0b01 	vadd.f64	d0, d0, d1
100070b4:	ee32 1b07 	vadd.f64	d1, d2, d7
100070b8:	ed94 7b04 	vldr	d7, [r4, #16]
100070bc:	ee23 2b0f 	vmul.f64	d2, d3, d15
100070c0:	ed8d 1b0c 	vstr	d1, [sp, #48]	@ 0x30
100070c4:	ee38 1b0e 	vadd.f64	d1, d8, d14
100070c8:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100070cc:	ee38 8b07 	vadd.f64	d8, d8, d7
100070d0:	ee31 1b47 	vsub.f64	d1, d1, d7
100070d4:	eeb7 7b00 	vmov.f64	d7, #112	@ 0x3f800000  1.0
100070d8:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100070dc:	ee31 1b47 	vsub.f64	d1, d1, d7
100070e0:	ee02 3b4e 	vmls.f64	d3, d2, d14
100070e4:	ee31 1b02 	vadd.f64	d1, d1, d2
100070e8:	ee33 2b07 	vadd.f64	d2, d3, d7
100070ec:	ee24 3b0f 	vmul.f64	d3, d4, d15
100070f0:	ed8d 2b0a 	vstr	d2, [sp, #40]	@ 0x28
100070f4:	ed8d 8b04 	vstr	d8, [sp, #16]
100070f8:	ed9d 8b02 	vldr	d8, [sp, #8]
100070fc:	ee25 2b0f 	vmul.f64	d2, d5, d15
10007100:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10007104:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10007108:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000710c:	ee03 4b4e 	vmls.f64	d4, d3, d14
10007110:	ee38 8b03 	vadd.f64	d8, d8, d3
10007114:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10007118:	eeb0 3b47 	vmov.f64	d3, d7
1000711c:	ee34 7b07 	vadd.f64	d7, d4, d7
10007120:	ed9d 4b04 	vldr	d4, [sp, #16]
10007124:	ee02 5b4e 	vmls.f64	d5, d2, d14
10007128:	ee34 4b02 	vadd.f64	d4, d4, d2
1000712c:	ee35 5b03 	vadd.f64	d5, d5, d3
10007130:	ed8d 4b02 	vstr	d4, [sp, #8]
10007134:	ed8d 6b48 	vstr	d6, [sp, #288]	@ 0x120
10007138:	ed8d 7b10 	vstr	d7, [sp, #64]	@ 0x40
1000713c:	ee29 4b0f 	vmul.f64	d4, d9, d15
10007140:	ed8d 5b0e 	vstr	d5, [sp, #56]	@ 0x38
10007144:	ee2a 5b0f 	vmul.f64	d5, d10, d15
10007148:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000714c:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10007150:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10007154:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10007158:	ee04 9b4e 	vmls.f64	d9, d4, d14
1000715c:	ee39 7b03 	vadd.f64	d7, d9, d3
10007160:	ee05 ab4e 	vmls.f64	d10, d5, d14
10007164:	ed8d 7b08 	vstr	d7, [sp, #32]
10007168:	ed91 7b0c 	vldr	d7, [r1, #48]	@ 0x30
1000716c:	ee3a 2b03 	vadd.f64	d2, d10, d3
10007170:	ee2b 9b0f 	vmul.f64	d9, d11, d15
10007174:	ed91 ab08 	vldr	d10, [r1, #32]
10007178:	ed91 3b08 	vldr	d3, [r1, #32]
1000717c:	ed8d 2b06 	vstr	d2, [sp, #24]
10007180:	ee3a 2b07 	vadd.f64	d2, d10, d7
10007184:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10007188:	ee33 3b0e 	vadd.f64	d3, d3, d14
1000718c:	ee32 2b04 	vadd.f64	d2, d2, d4
10007190:	ee33 3b47 	vsub.f64	d3, d3, d7
10007194:	eeb7 4b00 	vmov.f64	d4, #112	@ 0x3f800000  1.0
10007198:	eeb8 9b49 	vcvt.f64.u32	d9, s18
1000719c:	ee33 3b44 	vsub.f64	d3, d3, d4
100071a0:	ee09 bb4e 	vmls.f64	d11, d9, d14
100071a4:	ee33 9b09 	vadd.f64	d9, d3, d9
100071a8:	ee3b 3b04 	vadd.f64	d3, d11, d4
100071ac:	eeb0 7b44 	vmov.f64	d7, d4
100071b0:	ee3e db4d 	vsub.f64	d13, d14, d13
100071b4:	ed8d 3b04 	vstr	d3, [sp, #16]
100071b8:	ed94 3b08 	vldr	d3, [r4, #32]
100071bc:	ed94 bb0c 	vldr	d11, [r4, #48]	@ 0x30
100071c0:	ee33 4b0e 	vadd.f64	d4, d3, d14
100071c4:	ee33 3b0b 	vadd.f64	d3, d3, d11
100071c8:	ee34 4b4b 	vsub.f64	d4, d4, d11
100071cc:	ee2c ab0f 	vmul.f64	d10, d12, d15
100071d0:	eebc abca 	vcvt.u32.f64	s20, d10
100071d4:	ee34 4b47 	vsub.f64	d4, d4, d7
100071d8:	ed9d bb12 	vldr	d11, [sp, #72]	@ 0x48
100071dc:	ee33 3b05 	vadd.f64	d3, d3, d5
100071e0:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
100071e4:	ee2d 5b0f 	vmul.f64	d5, d13, d15
100071e8:	ee0a cb4e 	vmls.f64	d12, d10, d14
100071ec:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100071f0:	ee34 ab0a 	vadd.f64	d10, d4, d10
100071f4:	ee20 4b0f 	vmul.f64	d4, d0, d15
100071f8:	ee3c cb07 	vadd.f64	d12, d12, d7
100071fc:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10007200:	eefc 7bc4 	vcvt.u32.f64	s15, d4
10007204:	ee05 db4e 	vmls.f64	d13, d5, d14
10007208:	ee3b bb05 	vadd.f64	d11, d11, d5
1000720c:	eeb8 5b67 	vcvt.f64.u32	d5, s15
10007210:	ed9f 7b65 	vldr	d7, [pc, #404]	@ 100073a8 <fndsa_vect_iFFT_fp64_exact+0x410>
10007214:	ee05 0b4e 	vmls.f64	d0, d5, d14
10007218:	ee21 5b0f 	vmul.f64	d5, d1, d15
1000721c:	ee30 0b07 	vadd.f64	d0, d0, d7
10007220:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10007224:	ed8d 0b12 	vstr	d0, [sp, #72]	@ 0x48
10007228:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000722c:	ee28 0b0f 	vmul.f64	d0, d8, d15
10007230:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10007234:	ee05 1b4e 	vmls.f64	d1, d5, d14
10007238:	eeb8 0b40 	vcvt.f64.u32	d0, s0
1000723c:	eeb0 4b4d 	vmov.f64	d4, d13
10007240:	ee00 8b4e 	vmls.f64	d8, d0, d14
10007244:	ee31 0b07 	vadd.f64	d0, d1, d7
10007248:	ed9d 1b02 	vldr	d1, [sp, #8]
1000724c:	ed8d db52 	vstr	d13, [sp, #328]	@ 0x148
10007250:	ee21 5b0f 	vmul.f64	d5, d1, d15
10007254:	ee22 db0f 	vmul.f64	d13, d2, d15
10007258:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000725c:	eebc dbcd 	vcvt.u32.f64	s26, d13
10007260:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10007264:	ee05 1b4e 	vmls.f64	d1, d5, d14
10007268:	eeb8 5b4d 	vcvt.f64.u32	d5, s26
1000726c:	ee31 db07 	vadd.f64	d13, d1, d7
10007270:	ee05 2b4e 	vmls.f64	d2, d5, d14
10007274:	ed8d db02 	vstr	d13, [sp, #8]
10007278:	ee23 5b0f 	vmul.f64	d5, d3, d15
1000727c:	ee32 db07 	vadd.f64	d13, d2, d7
10007280:	ee29 2b0f 	vmul.f64	d2, d9, d15
10007284:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10007288:	eebc 2bc2 	vcvt.u32.f64	s4, d2
1000728c:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10007290:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10007294:	ee05 3b4e 	vmls.f64	d3, d5, d14
10007298:	ed8d db14 	vstr	d13, [sp, #80]	@ 0x50
1000729c:	ee02 9b4e 	vmls.f64	d9, d2, d14
100072a0:	ee2a 5b0f 	vmul.f64	d5, d10, d15
100072a4:	ee33 db07 	vadd.f64	d13, d3, d7
100072a8:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100072ac:	ee2b 3b0f 	vmul.f64	d3, d11, d15
100072b0:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100072b4:	eefc 2bc3 	vcvt.u32.f64	s5, d3
100072b8:	ee39 3b07 	vadd.f64	d3, d9, d7
100072bc:	ee05 ab4e 	vmls.f64	d10, d5, d14
100072c0:	ed8d 3b16 	vstr	d3, [sp, #88]	@ 0x58
100072c4:	ed9d 1b0c 	vldr	d1, [sp, #48]	@ 0x30
100072c8:	eeb8 5b62 	vcvt.f64.u32	d5, s5
100072cc:	ee3a 3b07 	vadd.f64	d3, d10, d7
100072d0:	ee05 bb4e 	vmls.f64	d11, d5, d14
100072d4:	ed8d 3b18 	vstr	d3, [sp, #96]	@ 0x60
100072d8:	ee34 3b06 	vadd.f64	d3, d4, d6
100072dc:	eebc 5bcb 	vcvt.u32.f64	s10, d11
100072e0:	ee15 3a10 	vmov	r3, s10
100072e4:	ee26 6b0f 	vmul.f64	d6, d6, d15
100072e8:	0fdb      	lsrs	r3, r3, #31
100072ea:	ee05 3a10 	vmov	s10, r3
100072ee:	ee24 4b0f 	vmul.f64	d4, d4, d15
100072f2:	ed8d 6b4c 	vstr	d6, [sp, #304]	@ 0x130
100072f6:	ed9d ab0a 	vldr	d10, [sp, #40]	@ 0x28
100072fa:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
100072fe:	ee21 6b0f 	vmul.f64	d6, d1, d15
10007302:	ed8d 5b58 	vstr	d5, [sp, #352]	@ 0x160
10007306:	ed8d 4b56 	vstr	d4, [sp, #344]	@ 0x158
1000730a:	ed9d 2b12 	vldr	d2, [sp, #72]	@ 0x48
1000730e:	ee2a 5b0f 	vmul.f64	d5, d10, d15
10007312:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007316:	eefc 4bc5 	vcvt.u32.f64	s9, d5
1000731a:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000731e:	eeb6 9b00 	vmov.f64	d9, #96	@ 0x3f000000  0.5
10007322:	ee32 2b06 	vadd.f64	d2, d2, d6
10007326:	ee06 1b4e 	vmls.f64	d1, d6, d14
1000732a:	eeb8 6b64 	vcvt.f64.u32	d6, s9
1000732e:	ee21 5b09 	vmul.f64	d5, d1, d9
10007332:	ee06 ab4e 	vmls.f64	d10, d6, d14
10007336:	ee30 1b06 	vadd.f64	d1, d0, d6
1000733a:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000733e:	eeb0 0b49 	vmov.f64	d0, d9
10007342:	eeb8 6b45 	vcvt.f64.u32	d6, s10
10007346:	ee2a 4b09 	vmul.f64	d4, d10, d9
1000734a:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000734e:	ee38 8b07 	vadd.f64	d8, d8, d7
10007352:	ed9d 9b10 	vldr	d9, [sp, #64]	@ 0x40
10007356:	ed8d 6b0c 	vstr	d6, [sp, #48]	@ 0x30
1000735a:	ed9d ab0e 	vldr	d10, [sp, #56]	@ 0x38
1000735e:	ee29 6b0f 	vmul.f64	d6, d9, d15
10007362:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10007366:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000736a:	ee2a 5b0f 	vmul.f64	d5, d10, d15
1000736e:	ed8d 4b10 	vstr	d4, [sp, #64]	@ 0x40
10007372:	ed9d 7b08 	vldr	d7, [sp, #32]
10007376:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000737a:	eefc 4bc5 	vcvt.u32.f64	s9, d5
1000737e:	ee06 9b4e 	vmls.f64	d9, d6, d14
10007382:	ee38 8b06 	vadd.f64	d8, d8, d6
10007386:	ee29 5b00 	vmul.f64	d5, d9, d0
1000738a:	eeb8 6b64 	vcvt.f64.u32	d6, s9
1000738e:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10007392:	ee06 ab4e 	vmls.f64	d10, d6, d14
10007396:	e00d      	b.n	100073b4 <fndsa_vect_iFFT_fp64_exact+0x41c>
10007398:	00000000 	.word	0x00000000
1000739c:	3df00000 	.word	0x3df00000
100073a0:	00000000 	.word	0x00000000
100073a4:	41f00000 	.word	0x41f00000
	...
100073b0:	300039a0 	.word	0x300039a0
100073b4:	ee2a 4b00 	vmul.f64	d4, d10, d0
100073b8:	ed9d 9b02 	vldr	d9, [sp, #8]
100073bc:	eeb8 ab45 	vcvt.f64.u32	d10, s10
100073c0:	ee39 9b06 	vadd.f64	d9, d9, d6
100073c4:	ed8d ab0a 	vstr	d10, [sp, #40]	@ 0x28
100073c8:	ed9d ab06 	vldr	d10, [sp, #24]
100073cc:	ee27 6b0f 	vmul.f64	d6, d7, d15
100073d0:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100073d4:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100073d8:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100073dc:	ee2a 5b0f 	vmul.f64	d5, d10, d15
100073e0:	ed8d 4b08 	vstr	d4, [sp, #32]
100073e4:	ed8d bb50 	vstr	d11, [sp, #320]	@ 0x140
100073e8:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100073ec:	eefc 4bc5 	vcvt.u32.f64	s9, d5
100073f0:	ee06 7b4e 	vmls.f64	d7, d6, d14
100073f4:	ed9d 5b14 	vldr	d5, [sp, #80]	@ 0x50
100073f8:	ee35 5b06 	vadd.f64	d5, d5, d6
100073fc:	eeb8 6b64 	vcvt.f64.u32	d6, s9
10007400:	eeb0 4b4a 	vmov.f64	d4, d10
10007404:	ed8d 5b06 	vstr	d5, [sp, #24]
10007408:	ee27 5b00 	vmul.f64	d5, d7, d0
1000740c:	ed9d ab04 	vldr	d10, [sp, #16]
10007410:	ee06 4b4e 	vmls.f64	d4, d6, d14
10007414:	ee24 4b00 	vmul.f64	d4, d4, d0
10007418:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000741c:	eeb0 7b40 	vmov.f64	d7, d0
10007420:	ee3d db06 	vadd.f64	d13, d13, d6
10007424:	eeb8 0b45 	vcvt.f64.u32	d0, s10
10007428:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000742c:	ee2c 5b0f 	vmul.f64	d5, d12, d15
10007430:	ed8d 0b0e 	vstr	d0, [sp, #56]	@ 0x38
10007434:	eeb8 0b44 	vcvt.f64.u32	d0, s8
10007438:	ee2a 6b0f 	vmul.f64	d6, d10, d15
1000743c:	ed8d 0b04 	vstr	d0, [sp, #16]
10007440:	eefc 0bc5 	vcvt.u32.f64	s1, d5
10007444:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007448:	ed9d 5b16 	vldr	d5, [sp, #88]	@ 0x58
1000744c:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10007450:	ee35 4b06 	vadd.f64	d4, d5, d6
10007454:	eeb0 5b4a 	vmov.f64	d5, d10
10007458:	ee06 5b4e 	vmls.f64	d5, d6, d14
1000745c:	eeb8 6b60 	vcvt.f64.u32	d6, s1
10007460:	eeb0 0b47 	vmov.f64	d0, d7
10007464:	ee06 cb4e 	vmls.f64	d12, d6, d14
10007468:	ee25 5b07 	vmul.f64	d5, d5, d7
1000746c:	ed9d 7b18 	vldr	d7, [sp, #96]	@ 0x60
10007470:	ee2c cb00 	vmul.f64	d12, d12, d0
10007474:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10007478:	ee37 7b06 	vadd.f64	d7, d7, d6
1000747c:	eefc 5bcc 	vcvt.u32.f64	s11, d12
10007480:	eeb8 cb45 	vcvt.f64.u32	d12, s10
10007484:	eeb8 5b65 	vcvt.f64.u32	d5, s11
10007488:	ee23 6b0f 	vmul.f64	d6, d3, d15
1000748c:	ed8d 7b02 	vstr	d7, [sp, #8]
10007490:	ed9d 7b00 	vldr	d7, [sp]
10007494:	ed8d 5b18 	vstr	d5, [sp, #96]	@ 0x60
10007498:	ee3b 5b07 	vadd.f64	d5, d11, d7
1000749c:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100074a0:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100074a4:	ee27 7b0f 	vmul.f64	d7, d7, d15
100074a8:	ee06 3b4e 	vmls.f64	d3, d6, d14
100074ac:	ed8d 7b4a 	vstr	d7, [sp, #296]	@ 0x128
100074b0:	ee22 7b0f 	vmul.f64	d7, d2, d15
100074b4:	ee35 5b06 	vadd.f64	d5, d5, d6
100074b8:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100074bc:	ee21 6b0f 	vmul.f64	d6, d1, d15
100074c0:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100074c4:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100074c8:	ee07 2b4e 	vmls.f64	d2, d7, d14
100074cc:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100074d0:	eefc 7bc2 	vcvt.u32.f64	s15, d2
100074d4:	ee17 2a90 	vmov	r2, s15
100074d8:	ee06 1b4e 	vmls.f64	d1, d6, d14
100074dc:	0fd3      	lsrs	r3, r2, #31
100074de:	eefc 7bc1 	vcvt.u32.f64	s15, d1
100074e2:	ee07 3a10 	vmov	s14, r3
100074e6:	0853      	lsrs	r3, r2, #1
100074e8:	ee2b bb0f 	vmul.f64	d11, d11, d15
100074ec:	f002 0201 	and.w	r2, r2, #1
100074f0:	ee00 3a10 	vmov	s0, r3
100074f4:	ee17 ca90 	vmov	ip, s15
100074f8:	ed8d bb54 	vstr	d11, [sp, #336]	@ 0x150
100074fc:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10007500:	ee23 bb0f 	vmul.f64	d11, d3, d15
10007504:	ed8d 3b5c 	vstr	d3, [sp, #368]	@ 0x170
10007508:	ea4f 035c 	mov.w	r3, ip, lsr #1
1000750c:	ed9f 3bfa 	vldr	d3, [pc, #1000]	@ 100078f8 <fndsa_vect_iFFT_fp64_exact+0x960>
10007510:	ed9d 1b0c 	vldr	d1, [sp, #48]	@ 0x30
10007514:	eeb8 0bc0 	vcvt.f64.s32	d0, s0
10007518:	ee02 3a10 	vmov	s4, r3
1000751c:	ee07 0b03 	vmla.f64	d0, d7, d3
10007520:	ea4f 73dc 	mov.w	r3, ip, lsr #31
10007524:	ee07 3a10 	vmov	s14, r3
10007528:	ee07 2a90 	vmov	s15, r2
1000752c:	eeb8 2bc2 	vcvt.f64.s32	d2, s4
10007530:	eeb8 6be7 	vcvt.f64.s32	d6, s15
10007534:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10007538:	f00c 0301 	and.w	r3, ip, #1
1000753c:	ee07 2b03 	vmla.f64	d2, d7, d3
10007540:	ee07 3a90 	vmov	s15, r3
10007544:	ee06 1b03 	vmla.f64	d1, d6, d3
10007548:	eeb8 7be7 	vcvt.f64.s32	d7, s15
1000754c:	eeb0 6b43 	vmov.f64	d6, d3
10007550:	ed9d 3b10 	vldr	d3, [sp, #64]	@ 0x40
10007554:	ee07 3b06 	vmla.f64	d3, d7, d6
10007558:	ee28 7b0f 	vmul.f64	d7, d8, d15
1000755c:	eeb0 ab46 	vmov.f64	d10, d6
10007560:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007564:	ee29 6b0f 	vmul.f64	d6, d9, d15
10007568:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000756c:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007570:	ee07 8b4e 	vmls.f64	d8, d7, d14
10007574:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10007578:	eefc 7bc8 	vcvt.u32.f64	s15, d8
1000757c:	ee17 2a90 	vmov	r2, s15
10007580:	ee06 9b4e 	vmls.f64	d9, d6, d14
10007584:	0fd3      	lsrs	r3, r2, #31
10007586:	ee07 3a10 	vmov	s14, r3
1000758a:	0853      	lsrs	r3, r2, #1
1000758c:	eefc 7bc9 	vcvt.u32.f64	s15, d9
10007590:	ee06 3a10 	vmov	s12, r3
10007594:	ee17 ca90 	vmov	ip, s15
10007598:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
1000759c:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100075a0:	eeb0 9b4a 	vmov.f64	d9, d10
100075a4:	ee07 6b0a 	vmla.f64	d6, d7, d10
100075a8:	f002 0201 	and.w	r2, r2, #1
100075ac:	ea4f 73dc 	mov.w	r3, ip, lsr #31
100075b0:	ee07 2a90 	vmov	s15, r2
100075b4:	ed8d 6b14 	vstr	d6, [sp, #80]	@ 0x50
100075b8:	ee06 3a10 	vmov	s12, r3
100075bc:	eeb8 8be7 	vcvt.f64.s32	d8, s15
100075c0:	ea4f 035c 	mov.w	r3, ip, lsr #1
100075c4:	ee07 3a10 	vmov	s14, r3
100075c8:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
100075cc:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100075d0:	f00c 0301 	and.w	r3, ip, #1
100075d4:	ee06 7b09 	vmla.f64	d7, d6, d9
100075d8:	ed9d ab0a 	vldr	d10, [sp, #40]	@ 0x28
100075dc:	ed8d 7b10 	vstr	d7, [sp, #64]	@ 0x40
100075e0:	ee07 3a90 	vmov	s15, r3
100075e4:	eeb8 7be7 	vcvt.f64.s32	d7, s15
100075e8:	ee08 ab09 	vmla.f64	d10, d8, d9
100075ec:	eeb0 8b49 	vmov.f64	d8, d9
100075f0:	ed9d 9b08 	vldr	d9, [sp, #32]
100075f4:	ee07 9b08 	vmla.f64	d9, d7, d8
100075f8:	ee2d 6b0f 	vmul.f64	d6, d13, d15
100075fc:	ed8d 9b12 	vstr	d9, [sp, #72]	@ 0x48
10007600:	ed9d 9b06 	vldr	d9, [sp, #24]
10007604:	ee29 7b0f 	vmul.f64	d7, d9, d15
10007608:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000760c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007610:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10007614:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007618:	ee07 9b4e 	vmls.f64	d9, d7, d14
1000761c:	eefc 7bc9 	vcvt.u32.f64	s15, d9
10007620:	ee17 2a90 	vmov	r2, s15
10007624:	ee06 db4e 	vmls.f64	d13, d6, d14
10007628:	0fd3      	lsrs	r3, r2, #31
1000762a:	ee06 3a10 	vmov	s12, r3
1000762e:	0853      	lsrs	r3, r2, #1
10007630:	ee07 3a10 	vmov	s14, r3
10007634:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10007638:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
1000763c:	ed8d ab16 	vstr	d10, [sp, #88]	@ 0x58
10007640:	eeb0 ab47 	vmov.f64	d10, d7
10007644:	eefc 7bcd 	vcvt.u32.f64	s15, d13
10007648:	eeb0 9b48 	vmov.f64	d9, d8
1000764c:	ee17 ca90 	vmov	ip, s15
10007650:	ee06 ab08 	vmla.f64	d10, d6, d8
10007654:	f002 0201 	and.w	r2, r2, #1
10007658:	ea4f 73dc 	mov.w	r3, ip, lsr #31
1000765c:	ed9d db0e 	vldr	d13, [sp, #56]	@ 0x38
10007660:	ee07 2a90 	vmov	s15, r2
10007664:	ee06 3a10 	vmov	s12, r3
10007668:	ea4f 035c 	mov.w	r3, ip, lsr #1
1000766c:	eeb8 8be7 	vcvt.f64.s32	d8, s15
10007670:	ee07 3a10 	vmov	s14, r3
10007674:	ee08 db09 	vmla.f64	d13, d8, d9
10007678:	f00c 0301 	and.w	r3, ip, #1
1000767c:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10007680:	ed8d db0e 	vstr	d13, [sp, #56]	@ 0x38
10007684:	eeb0 db47 	vmov.f64	d13, d7
10007688:	ee07 3a90 	vmov	s15, r3
1000768c:	ed8d ab0c 	vstr	d10, [sp, #48]	@ 0x30
10007690:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10007694:	ed9d ab04 	vldr	d10, [sp, #16]
10007698:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
1000769c:	ee07 ab09 	vmla.f64	d10, d7, d9
100076a0:	ee24 7b0f 	vmul.f64	d7, d4, d15
100076a4:	ee06 db09 	vmla.f64	d13, d6, d9
100076a8:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100076ac:	ed8d db0a 	vstr	d13, [sp, #40]	@ 0x28
100076b0:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100076b4:	ed9d db02 	vldr	d13, [sp, #8]
100076b8:	ee07 4b4e 	vmls.f64	d4, d7, d14
100076bc:	ee2d 6b0f 	vmul.f64	d6, d13, d15
100076c0:	eefc 7bc4 	vcvt.u32.f64	s15, d4
100076c4:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100076c8:	ee17 2a90 	vmov	r2, s15
100076cc:	eeb8 7b46 	vcvt.f64.u32	d7, s12
100076d0:	ee07 db4e 	vmls.f64	d13, d7, d14
100076d4:	0fd3      	lsrs	r3, r2, #31
100076d6:	eefc 7bcd 	vcvt.u32.f64	s15, d13
100076da:	ee06 3a10 	vmov	s12, r3
100076de:	0853      	lsrs	r3, r2, #1
100076e0:	ee08 3a10 	vmov	s16, r3
100076e4:	ee17 ca90 	vmov	ip, s15
100076e8:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
100076ec:	eeb8 8bc8 	vcvt.f64.s32	d8, s16
100076f0:	ea4f 035c 	mov.w	r3, ip, lsr #1
100076f4:	ee07 3a10 	vmov	s14, r3
100076f8:	ee06 8b09 	vmla.f64	d8, d6, d9
100076fc:	ea4f 73dc 	mov.w	r3, ip, lsr #31
10007700:	f002 0201 	and.w	r2, r2, #1
10007704:	ee07 2a90 	vmov	s15, r2
10007708:	ee06 3a10 	vmov	s12, r3
1000770c:	eeb8 4be7 	vcvt.f64.s32	d4, s15
10007710:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10007714:	ee04 cb09 	vmla.f64	d12, d4, d9
10007718:	f00c 0301 	and.w	r3, ip, #1
1000771c:	eeb0 4b47 	vmov.f64	d4, d7
10007720:	ed8d cb04 	vstr	d12, [sp, #16]
10007724:	ee07 3a90 	vmov	s15, r3
10007728:	ed9d cb18 	vldr	d12, [sp, #96]	@ 0x60
1000772c:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10007730:	ee07 cb09 	vmla.f64	d12, d7, d9
10007734:	ee25 7b0f 	vmul.f64	d7, d5, d15
10007738:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000773c:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007740:	ee07 5b4e 	vmls.f64	d5, d7, d14
10007744:	eebc 7bc5 	vcvt.u32.f64	s14, d5
10007748:	ee17 3a10 	vmov	r3, s14
1000774c:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10007750:	0fdb      	lsrs	r3, r3, #31
10007752:	ee06 4b09 	vmla.f64	d4, d6, d9
10007756:	a846      	add	r0, sp, #280	@ 0x118
10007758:	ee07 3a10 	vmov	s14, r3
1000775c:	ed8d 4b00 	vstr	d4, [sp]
10007760:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10007764:	ed8d ab08 	vstr	d10, [sp, #32]
10007768:	ed8d cb02 	vstr	d12, [sp, #8]
1000776c:	ed8d 5b5a 	vstr	d5, [sp, #360]	@ 0x168
10007770:	ee25 5b0f 	vmul.f64	d5, d5, d15
10007774:	ed8d 7b62 	vstr	d7, [sp, #392]	@ 0x188
10007778:	ed8d 5b5e 	vstr	d5, [sp, #376]	@ 0x178
1000777c:	ed8d bb60 	vstr	d11, [sp, #384]	@ 0x180
10007780:	f7fe fbea 	bl	10005f58 <fp64e_cmul_prepared>
10007784:	edd6 7a06 	vldr	s15, [r6, #24]
10007788:	6973      	ldr	r3, [r6, #20]
1000778a:	eeb8 5b67 	vcvt.f64.u32	d5, s15
1000778e:	0fdb      	lsrs	r3, r3, #31
10007790:	ee04 3a10 	vmov	s8, r3
10007794:	ee3e 5b45 	vsub.f64	d5, d14, d5
10007798:	edd6 7a07 	vldr	s15, [r6, #28]
1000779c:	eeb8 6b67 	vcvt.f64.u32	d6, s15
100077a0:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
100077a4:	ee3e 6b46 	vsub.f64	d6, d14, d6
100077a8:	ed8d 4b4e 	vstr	d4, [sp, #312]	@ 0x138
100077ac:	eeb7 4b00 	vmov.f64	d4, #112	@ 0x3f800000  1.0
100077b0:	eeb0 cb40 	vmov.f64	d12, d0
100077b4:	ee36 6b44 	vsub.f64	d6, d6, d4
100077b8:	edd6 7a04 	vldr	s15, [r6, #16]
100077bc:	ee25 4b0f 	vmul.f64	d4, d5, d15
100077c0:	eeb0 0b48 	vmov.f64	d0, d8
100077c4:	eeb8 8b67 	vcvt.f64.u32	d8, s15
100077c8:	edd6 7a05 	vldr	s15, [r6, #20]
100077cc:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100077d0:	eeb8 7b67 	vcvt.f64.u32	d7, s15
100077d4:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100077d8:	ee27 bb0f 	vmul.f64	d11, d7, d15
100077dc:	ee36 6b04 	vadd.f64	d6, d6, d4
100077e0:	ed8d bb4a 	vstr	d11, [sp, #296]	@ 0x128
100077e4:	ee26 bb0f 	vmul.f64	d11, d6, d15
100077e8:	eebc bbcb 	vcvt.u32.f64	s22, d11
100077ec:	ee04 5b4e 	vmls.f64	d5, d4, d14
100077f0:	eeb8 bb4b 	vcvt.f64.u32	d11, s22
100077f4:	ee35 4b08 	vadd.f64	d4, d5, d8
100077f8:	ed8d 5b52 	vstr	d5, [sp, #328]	@ 0x148
100077fc:	ee25 5b0f 	vmul.f64	d5, d5, d15
10007800:	ee0b 6b4e 	vmls.f64	d6, d11, d14
10007804:	ed8d 5b56 	vstr	d5, [sp, #344]	@ 0x158
10007808:	ed8d 7b46 	vstr	d7, [sp, #280]	@ 0x118
1000780c:	eefc 5bc6 	vcvt.u32.f64	s11, d6
10007810:	ee36 7b07 	vadd.f64	d7, d6, d7
10007814:	ed8d 6b50 	vstr	d6, [sp, #320]	@ 0x140
10007818:	ee15 3a90 	vmov	r3, s11
1000781c:	ee26 6b0f 	vmul.f64	d6, d6, d15
10007820:	0fdb      	lsrs	r3, r3, #31
10007822:	ed8d 6b54 	vstr	d6, [sp, #336]	@ 0x150
10007826:	ee06 3a10 	vmov	s12, r3
1000782a:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
1000782e:	ed8d 6b58 	vstr	d6, [sp, #352]	@ 0x160
10007832:	ee24 6b0f 	vmul.f64	d6, d4, d15
10007836:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000783a:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000783e:	ee37 7b06 	vadd.f64	d7, d7, d6
10007842:	ee06 4b4e 	vmls.f64	d4, d6, d14
10007846:	ee27 6b0f 	vmul.f64	d6, d7, d15
1000784a:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000784e:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10007852:	ee06 7b4e 	vmls.f64	d7, d6, d14
10007856:	eefc 6bc7 	vcvt.u32.f64	s13, d7
1000785a:	ed8d 7b5a 	vstr	d7, [sp, #360]	@ 0x168
1000785e:	ee16 3a90 	vmov	r3, s13
10007862:	ee27 7b0f 	vmul.f64	d7, d7, d15
10007866:	0fdb      	lsrs	r3, r3, #31
10007868:	ed8d 7b5e 	vstr	d7, [sp, #376]	@ 0x178
1000786c:	ee07 3a10 	vmov	s14, r3
10007870:	eeb0 9b43 	vmov.f64	d9, d3
10007874:	eeb0 ab41 	vmov.f64	d10, d1
10007878:	eeb0 db42 	vmov.f64	d13, d2
1000787c:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10007880:	ed8d 8b48 	vstr	d8, [sp, #288]	@ 0x120
10007884:	ee28 8b0f 	vmul.f64	d8, d8, d15
10007888:	ed8d 4b5c 	vstr	d4, [sp, #368]	@ 0x170
1000788c:	ed9d 2b00 	vldr	d2, [sp]
10007890:	ed9d 1b04 	vldr	d1, [sp, #16]
10007894:	ed9d 3b02 	vldr	d3, [sp, #8]
10007898:	ed8d 7b62 	vstr	d7, [sp, #392]	@ 0x188
1000789c:	ed8d cb2e 	vstr	d12, [sp, #184]	@ 0xb8
100078a0:	ed8d ab30 	vstr	d10, [sp, #192]	@ 0xc0
100078a4:	ed8d db32 	vstr	d13, [sp, #200]	@ 0xc8
100078a8:	ed8d 9b34 	vstr	d9, [sp, #208]	@ 0xd0
100078ac:	ee24 4b0f 	vmul.f64	d4, d4, d15
100078b0:	ed8d 8b4c 	vstr	d8, [sp, #304]	@ 0x130
100078b4:	ed8d 4b60 	vstr	d4, [sp, #384]	@ 0x180
100078b8:	f7fe fb4e 	bl	10005f58 <fp64e_cmul_prepared>
100078bc:	edd7 7a02 	vldr	s15, [r7, #8]
100078c0:	edd7 5a00 	vldr	s11, [r7]
100078c4:	687b      	ldr	r3, [r7, #4]
100078c6:	eeb8 4b65 	vcvt.f64.u32	d4, s11
100078ca:	0fdb      	lsrs	r3, r3, #31
100078cc:	eeb8 6b67 	vcvt.f64.u32	d6, s15
100078d0:	ee05 3a10 	vmov	s10, r3
100078d4:	ee3e bb46 	vsub.f64	d11, d14, d6
100078d8:	edd7 5a01 	vldr	s11, [r7, #4]
100078dc:	edd7 7a03 	vldr	s15, [r7, #12]
100078e0:	eeb8 8b65 	vcvt.f64.u32	d8, s11
100078e4:	eeb8 7b67 	vcvt.f64.u32	d7, s15
100078e8:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
100078ec:	ee3e 7b47 	vsub.f64	d7, d14, d7
100078f0:	ed8d 5b4e 	vstr	d5, [sp, #312]	@ 0x138
100078f4:	e008      	b.n	10007908 <fndsa_vect_iFFT_fp64_exact+0x970>
100078f6:	bf00      	nop
100078f8:	00000000 	.word	0x00000000
100078fc:	41e00000 	.word	0x41e00000
	...
10007908:	eeb7 5b00 	vmov.f64	d5, #112	@ 0x3f800000  1.0
1000790c:	ed8d bb06 	vstr	d11, [sp, #24]
10007910:	ee37 bb45 	vsub.f64	d11, d7, d5
10007914:	ed9d 6b16 	vldr	d6, [sp, #88]	@ 0x58
10007918:	ee36 7b0e 	vadd.f64	d7, d6, d14
1000791c:	ed8d bb1a 	vstr	d11, [sp, #104]	@ 0x68
10007920:	ed9d bb0e 	vldr	d11, [sp, #56]	@ 0x38
10007924:	ed9d 5b08 	vldr	d5, [sp, #32]
10007928:	ee3b 6b06 	vadd.f64	d6, d11, d6
1000792c:	ee37 7b4b 	vsub.f64	d7, d7, d11
10007930:	ed8d 6b0e 	vstr	d6, [sp, #56]	@ 0x38
10007934:	ed9d 6b12 	vldr	d6, [sp, #72]	@ 0x48
10007938:	ee36 bb0e 	vadd.f64	d11, d6, d14
1000793c:	ee35 6b06 	vadd.f64	d6, d5, d6
10007940:	ed8d 6b04 	vstr	d6, [sp, #16]
10007944:	ee3a 6b0e 	vadd.f64	d6, d10, d14
10007948:	ed8d 1b38 	vstr	d1, [sp, #224]	@ 0xe0
1000794c:	ed8d 0b36 	vstr	d0, [sp, #216]	@ 0xd8
10007950:	ed8d 2b3a 	vstr	d2, [sp, #232]	@ 0xe8
10007954:	ed8d 3b3c 	vstr	d3, [sp, #240]	@ 0xf0
10007958:	ee3a ab01 	vadd.f64	d10, d10, d1
1000795c:	ee36 1b41 	vsub.f64	d1, d6, d1
10007960:	ee39 6b0e 	vadd.f64	d6, d9, d14
10007964:	ee3b bb45 	vsub.f64	d11, d11, d5
10007968:	ed8d 8b00 	vstr	d8, [sp]
1000796c:	ed8d 8b46 	vstr	d8, [sp, #280]	@ 0x118
10007970:	ed8d 4b48 	vstr	d4, [sp, #288]	@ 0x120
10007974:	ed8d 1b08 	vstr	d1, [sp, #32]
10007978:	ed8d 7b02 	vstr	d7, [sp, #8]
1000797c:	ee39 1b03 	vadd.f64	d1, d9, d3
10007980:	ee36 9b43 	vsub.f64	d9, d6, d3
10007984:	ed9d 3b14 	vldr	d3, [sp, #80]	@ 0x50
10007988:	ed9d 8b0c 	vldr	d8, [sp, #48]	@ 0x30
1000798c:	ee27 6b0f 	vmul.f64	d6, d7, d15
10007990:	ee33 5b0e 	vadd.f64	d5, d3, d14
10007994:	ee38 3b03 	vadd.f64	d3, d8, d3
10007998:	ee35 5b48 	vsub.f64	d5, d5, d8
1000799c:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100079a0:	eeb7 7b00 	vmov.f64	d7, #112	@ 0x3f800000  1.0
100079a4:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100079a8:	eeb0 8b47 	vmov.f64	d8, d7
100079ac:	ee35 5b47 	vsub.f64	d5, d5, d7
100079b0:	ed9d 7b02 	vldr	d7, [sp, #8]
100079b4:	ee06 7b4e 	vmls.f64	d7, d6, d14
100079b8:	ee35 5b06 	vadd.f64	d5, d5, d6
100079bc:	ee37 7b08 	vadd.f64	d7, d7, d8
100079c0:	ed8d 5b0c 	vstr	d5, [sp, #48]	@ 0x30
100079c4:	ed8d 7b14 	vstr	d7, [sp, #80]	@ 0x50
100079c8:	ee2b 7b0f 	vmul.f64	d7, d11, d15
100079cc:	ed9d 5b10 	vldr	d5, [sp, #64]	@ 0x40
100079d0:	ed9d 8b0a 	vldr	d8, [sp, #40]	@ 0x28
100079d4:	ee35 6b0e 	vadd.f64	d6, d5, d14
100079d8:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100079dc:	ee38 5b05 	vadd.f64	d5, d8, d5
100079e0:	ee36 6b48 	vsub.f64	d6, d6, d8
100079e4:	eeb7 8b00 	vmov.f64	d8, #112	@ 0x3f800000  1.0
100079e8:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100079ec:	ee36 6b48 	vsub.f64	d6, d6, d8
100079f0:	ee07 bb4e 	vmls.f64	d11, d7, d14
100079f4:	ee36 7b07 	vadd.f64	d7, d6, d7
100079f8:	ee3b bb08 	vadd.f64	d11, d11, d8
100079fc:	ed9d 8b0e 	vldr	d8, [sp, #56]	@ 0x38
10007a00:	ed8d 7b0a 	vstr	d7, [sp, #40]	@ 0x28
10007a04:	ed9d 6b04 	vldr	d6, [sp, #16]
10007a08:	ee28 7b0f 	vmul.f64	d7, d8, d15
10007a0c:	ed8d bb12 	vstr	d11, [sp, #72]	@ 0x48
10007a10:	ee26 6b0f 	vmul.f64	d6, d6, d15
10007a14:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007a18:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007a1c:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007a20:	ee33 bb07 	vadd.f64	d11, d3, d7
10007a24:	eeb0 3b48 	vmov.f64	d3, d8
10007a28:	eeb7 8b00 	vmov.f64	d8, #112	@ 0x3f800000  1.0
10007a2c:	ee07 3b4e 	vmls.f64	d3, d7, d14
10007a30:	eeb8 7b46 	vcvt.f64.u32	d7, s12
10007a34:	ee33 3b08 	vadd.f64	d3, d3, d8
10007a38:	ed9d 6b04 	vldr	d6, [sp, #16]
10007a3c:	ee07 6b4e 	vmls.f64	d6, d7, d14
10007a40:	ed8d 3b18 	vstr	d3, [sp, #96]	@ 0x60
10007a44:	ee35 3b07 	vadd.f64	d3, d5, d7
10007a48:	ee36 6b08 	vadd.f64	d6, d6, d8
10007a4c:	ee2a 7b0f 	vmul.f64	d7, d10, d15
10007a50:	ed8d 6b16 	vstr	d6, [sp, #88]	@ 0x58
10007a54:	ed8d 3b0e 	vstr	d3, [sp, #56]	@ 0x38
10007a58:	ee21 6b0f 	vmul.f64	d6, d1, d15
10007a5c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007a60:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007a64:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007a68:	eeb8 3b46 	vcvt.f64.u32	d3, s12
10007a6c:	ee07 ab4e 	vmls.f64	d10, d7, d14
10007a70:	ee03 1b4e 	vmls.f64	d1, d3, d14
10007a74:	ee31 6b08 	vadd.f64	d6, d1, d8
10007a78:	ee3a ab08 	vadd.f64	d10, d10, d8
10007a7c:	ed9d 8b08 	vldr	d8, [sp, #32]
10007a80:	ed8d 6b10 	vstr	d6, [sp, #64]	@ 0x40
10007a84:	ee28 6b0f 	vmul.f64	d6, d8, d15
10007a88:	ee3c 5b0e 	vadd.f64	d5, d12, d14
10007a8c:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007a90:	ee3c cb00 	vadd.f64	d12, d12, d0
10007a94:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10007a98:	ee35 5b40 	vsub.f64	d5, d5, d0
10007a9c:	ee3c 1b07 	vadd.f64	d1, d12, d7
10007aa0:	eeb7 7b00 	vmov.f64	d7, #112	@ 0x3f800000  1.0
10007aa4:	eeb0 cb48 	vmov.f64	d12, d8
10007aa8:	ee35 5b47 	vsub.f64	d5, d5, d7
10007aac:	ed9d 8b06 	vldr	d8, [sp, #24]
10007ab0:	ee06 cb4e 	vmls.f64	d12, d6, d14
10007ab4:	ee35 0b06 	vadd.f64	d0, d5, d6
10007ab8:	ee3c cb07 	vadd.f64	d12, d12, d7
10007abc:	eeb0 5b47 	vmov.f64	d5, d7
10007ac0:	ee29 7b0f 	vmul.f64	d7, d9, d15
10007ac4:	ee3d 6b0e 	vadd.f64	d6, d13, d14
10007ac8:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007acc:	ee32 db0d 	vadd.f64	d13, d2, d13
10007ad0:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007ad4:	ee36 6b42 	vsub.f64	d6, d6, d2
10007ad8:	ee3d 3b03 	vadd.f64	d3, d13, d3
10007adc:	ee36 6b45 	vsub.f64	d6, d6, d5
10007ae0:	ee07 9b4e 	vmls.f64	d9, d7, d14
10007ae4:	ee39 db05 	vadd.f64	d13, d9, d5
10007ae8:	ee36 2b07 	vadd.f64	d2, d6, d7
10007aec:	ed8d db04 	vstr	d13, [sp, #16]
10007af0:	ed9d db0c 	vldr	d13, [sp, #48]	@ 0x30
10007af4:	ee28 7b0f 	vmul.f64	d7, d8, d15
10007af8:	ee2d 6b0f 	vmul.f64	d6, d13, d15
10007afc:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007b00:	eefc 5bc6 	vcvt.u32.f64	s11, d6
10007b04:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007b08:	ed9d 6b1a 	vldr	d6, [sp, #104]	@ 0x68
10007b0c:	ee36 9b07 	vadd.f64	d9, d6, d7
10007b10:	eeb0 6b48 	vmov.f64	d6, d8
10007b14:	ed1f 8b86 	vldr	d8, [pc, #-536]	@ 10007900 <fndsa_vect_iFFT_fp64_exact+0x968>
10007b18:	ee07 6b4e 	vmls.f64	d6, d7, d14
10007b1c:	ed8d cb02 	vstr	d12, [sp, #8]
10007b20:	ed9d cb0a 	vldr	d12, [sp, #40]	@ 0x28
10007b24:	eeb8 7b65 	vcvt.f64.u32	d7, s11
10007b28:	eeb0 5b4d 	vmov.f64	d5, d13
10007b2c:	ee07 5b4e 	vmls.f64	d5, d7, d14
10007b30:	ee2c 7b0f 	vmul.f64	d7, d12, d15
10007b34:	ee35 5b08 	vadd.f64	d5, d5, d8
10007b38:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007b3c:	ed8d 5b08 	vstr	d5, [sp, #32]
10007b40:	ee2b 5b0f 	vmul.f64	d5, d11, d15
10007b44:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007b48:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10007b4c:	ee07 cb4e 	vmls.f64	d12, d7, d14
10007b50:	ed9d db0e 	vldr	d13, [sp, #56]	@ 0x38
10007b54:	eeb8 7b45 	vcvt.f64.u32	d7, s10
10007b58:	ee21 5b0f 	vmul.f64	d5, d1, d15
10007b5c:	ee07 bb4e 	vmls.f64	d11, d7, d14
10007b60:	ee3c 7b08 	vadd.f64	d7, d12, d8
10007b64:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10007b68:	eeb0 cb47 	vmov.f64	d12, d7
10007b6c:	ee2d 7b0f 	vmul.f64	d7, d13, d15
10007b70:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007b74:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007b78:	ee07 db4e 	vmls.f64	d13, d7, d14
10007b7c:	eeb8 7b45 	vcvt.f64.u32	d7, s10
10007b80:	ee07 1b4e 	vmls.f64	d1, d7, d14
10007b84:	ee3d 7b08 	vadd.f64	d7, d13, d8
10007b88:	ee31 1b08 	vadd.f64	d1, d1, d8
10007b8c:	ed8d 7b06 	vstr	d7, [sp, #24]
10007b90:	ee23 7b0f 	vmul.f64	d7, d3, d15
10007b94:	ed8d 1b0c 	vstr	d1, [sp, #48]	@ 0x30
10007b98:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007b9c:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007ba0:	ee20 5b0f 	vmul.f64	d5, d0, d15
10007ba4:	ee07 3b4e 	vmls.f64	d3, d7, d14
10007ba8:	ee22 7b0f 	vmul.f64	d7, d2, d15
10007bac:	eefc 1bc5 	vcvt.u32.f64	s3, d5
10007bb0:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007bb4:	ee29 5b0f 	vmul.f64	d5, d9, d15
10007bb8:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007bbc:	ee33 3b08 	vadd.f64	d3, d3, d8
10007bc0:	ee07 2b4e 	vmls.f64	d2, d7, d14
10007bc4:	ed8d 3b1a 	vstr	d3, [sp, #104]	@ 0x68
10007bc8:	eeb8 7b61 	vcvt.f64.u32	d7, s3
10007bcc:	eefc 3bc5 	vcvt.u32.f64	s7, d5
10007bd0:	ee07 0b4e 	vmls.f64	d0, d7, d14
10007bd4:	eeb8 7b63 	vcvt.f64.u32	d7, s7
10007bd8:	ee07 9b4e 	vmls.f64	d9, d7, d14
10007bdc:	eebc 7bc9 	vcvt.u32.f64	s14, d9
10007be0:	ee17 3a10 	vmov	r3, s14
10007be4:	0fdb      	lsrs	r3, r3, #31
10007be6:	ee07 3a10 	vmov	s14, r3
10007bea:	ee36 3b04 	vadd.f64	d3, d6, d4
10007bee:	ed8d 6b52 	vstr	d6, [sp, #328]	@ 0x148
10007bf2:	ee32 2b08 	vadd.f64	d2, d2, d8
10007bf6:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10007bfa:	ee24 4b0f 	vmul.f64	d4, d4, d15
10007bfe:	ed8d 2b1c 	vstr	d2, [sp, #112]	@ 0x70
10007c02:	ed8d 9b50 	vstr	d9, [sp, #320]	@ 0x140
10007c06:	ed8d 7b58 	vstr	d7, [sp, #352]	@ 0x160
10007c0a:	ee26 6b0f 	vmul.f64	d6, d6, d15
10007c0e:	ed8d 4b4c 	vstr	d4, [sp, #304]	@ 0x130
10007c12:	ed9d 2b14 	vldr	d2, [sp, #80]	@ 0x50
10007c16:	ed9d 1b12 	vldr	d1, [sp, #72]	@ 0x48
10007c1a:	ee22 7b0f 	vmul.f64	d7, d2, d15
10007c1e:	ed8d 6b56 	vstr	d6, [sp, #344]	@ 0x158
10007c22:	ed9d 4b08 	vldr	d4, [sp, #32]
10007c26:	ee21 6b0f 	vmul.f64	d6, d1, d15
10007c2a:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007c2e:	eefc 5bc6 	vcvt.u32.f64	s11, d6
10007c32:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007c36:	eeb0 6b42 	vmov.f64	d6, d2
10007c3a:	ee34 4b07 	vadd.f64	d4, d4, d7
10007c3e:	ee07 6b4e 	vmls.f64	d6, d7, d14
10007c42:	eeb8 7b65 	vcvt.f64.u32	d7, s11
10007c46:	eeb0 5b41 	vmov.f64	d5, d1
10007c4a:	ee30 0b08 	vadd.f64	d0, d0, d8
10007c4e:	ee3b bb08 	vadd.f64	d11, d11, d8
10007c52:	ee07 5b4e 	vmls.f64	d5, d7, d14
10007c56:	eeb6 8b00 	vmov.f64	d8, #96	@ 0x3f000000  0.5
10007c5a:	ee3c 2b07 	vadd.f64	d2, d12, d7
10007c5e:	ed9d cb18 	vldr	d12, [sp, #96]	@ 0x60
10007c62:	ed9d db16 	vldr	d13, [sp, #88]	@ 0x58
10007c66:	ee26 6b08 	vmul.f64	d6, d6, d8
10007c6a:	ee25 5b08 	vmul.f64	d5, d5, d8
10007c6e:	ee2c 7b0f 	vmul.f64	d7, d12, d15
10007c72:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007c76:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10007c7a:	eeb8 1b46 	vcvt.f64.u32	d1, s12
10007c7e:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10007c82:	ee2d 6b0f 	vmul.f64	d6, d13, d15
10007c86:	ed8d 5b18 	vstr	d5, [sp, #96]	@ 0x60
10007c8a:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007c8e:	eefc 5bc6 	vcvt.u32.f64	s11, d6
10007c92:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007c96:	eeb0 6b4c 	vmov.f64	d6, d12
10007c9a:	ee3b bb07 	vadd.f64	d11, d11, d7
10007c9e:	ee07 6b4e 	vmls.f64	d6, d7, d14
10007ca2:	eeb8 7b65 	vcvt.f64.u32	d7, s11
10007ca6:	ee26 6b08 	vmul.f64	d6, d6, d8
10007caa:	ed9d 5b06 	vldr	d5, [sp, #24]
10007cae:	ee35 5b07 	vadd.f64	d5, d5, d7
10007cb2:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007cb6:	ed8d 5b08 	vstr	d5, [sp, #32]
10007cba:	eeb0 5b4d 	vmov.f64	d5, d13
10007cbe:	ed9d cb10 	vldr	d12, [sp, #64]	@ 0x40
10007cc2:	ee07 5b4e 	vmls.f64	d5, d7, d14
10007cc6:	eeb8 7b46 	vcvt.f64.u32	d7, s12
10007cca:	ee25 5b08 	vmul.f64	d5, d5, d8
10007cce:	ed8d 7b0a 	vstr	d7, [sp, #40]	@ 0x28
10007cd2:	ee2a 7b0f 	vmul.f64	d7, d10, d15
10007cd6:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10007cda:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007cde:	ee2c 6b0f 	vmul.f64	d6, d12, d15
10007ce2:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007ce6:	eefc 5bc6 	vcvt.u32.f64	s11, d6
10007cea:	ee07 ab4e 	vmls.f64	d10, d7, d14
10007cee:	ed9d 6b0c 	vldr	d6, [sp, #48]	@ 0x30
10007cf2:	ee36 6b07 	vadd.f64	d6, d6, d7
10007cf6:	ed8d 6b06 	vstr	d6, [sp, #24]
10007cfa:	ee2a 6b08 	vmul.f64	d6, d10, d8
10007cfe:	eeb8 7b65 	vcvt.f64.u32	d7, s11
10007d02:	eeb8 db45 	vcvt.f64.u32	d13, s10
10007d06:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007d0a:	eeb0 5b4c 	vmov.f64	d5, d12
10007d0e:	eeb8 cb46 	vcvt.f64.u32	d12, s12
10007d12:	ee07 5b4e 	vmls.f64	d5, d7, d14
10007d16:	ed9d ab1a 	vldr	d10, [sp, #104]	@ 0x68
10007d1a:	ed8d cb12 	vstr	d12, [sp, #72]	@ 0x48
10007d1e:	ed9d cb02 	vldr	d12, [sp, #8]
10007d22:	ed8d db0e 	vstr	d13, [sp, #56]	@ 0x38
10007d26:	ed9d db04 	vldr	d13, [sp, #16]
10007d2a:	ee3a ab07 	vadd.f64	d10, d10, d7
10007d2e:	ee25 5b08 	vmul.f64	d5, d5, d8
10007d32:	ee2c 7b0f 	vmul.f64	d7, d12, d15
10007d36:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10007d3a:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007d3e:	eeb8 cb45 	vcvt.f64.u32	d12, s10
10007d42:	ee2d 6b0f 	vmul.f64	d6, d13, d15
10007d46:	ed8d cb14 	vstr	d12, [sp, #80]	@ 0x50
10007d4a:	ed9d cb02 	vldr	d12, [sp, #8]
10007d4e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007d52:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007d56:	ee30 5b07 	vadd.f64	d5, d0, d7
10007d5a:	ee07 cb4e 	vmls.f64	d12, d7, d14
10007d5e:	eeb8 7b46 	vcvt.f64.u32	d7, s12
10007d62:	ee2c 6b08 	vmul.f64	d6, d12, d8
10007d66:	ed9d 0b1c 	vldr	d0, [sp, #112]	@ 0x70
10007d6a:	ee07 db4e 	vmls.f64	d13, d7, d14
10007d6e:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007d72:	ee2d db08 	vmul.f64	d13, d13, d8
10007d76:	ed9d 8b00 	vldr	d8, [sp]
10007d7a:	ee30 cb07 	vadd.f64	d12, d0, d7
10007d7e:	ee23 7b0f 	vmul.f64	d7, d3, d15
10007d82:	eefc 6bcd 	vcvt.u32.f64	s13, d13
10007d86:	eeb8 db46 	vcvt.f64.u32	d13, s12
10007d8a:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007d8e:	eeb8 0b66 	vcvt.f64.u32	d0, s13
10007d92:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007d96:	ee39 6b08 	vadd.f64	d6, d9, d8
10007d9a:	ee28 8b0f 	vmul.f64	d8, d8, d15
10007d9e:	ee07 3b4e 	vmls.f64	d3, d7, d14
10007da2:	ed8d 8b4a 	vstr	d8, [sp, #296]	@ 0x128
10007da6:	ee36 8b07 	vadd.f64	d8, d6, d7
10007daa:	ee24 7b0f 	vmul.f64	d7, d4, d15
10007dae:	ee22 6b0f 	vmul.f64	d6, d2, d15
10007db2:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007db6:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007dba:	ee07 4b4e 	vmls.f64	d4, d7, d14
10007dbe:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007dc2:	eefc 7bc4 	vcvt.u32.f64	s15, d4
10007dc6:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10007dca:	ee17 2a90 	vmov	r2, s15
10007dce:	ee06 2b4e 	vmls.f64	d2, d6, d14
10007dd2:	0fd3      	lsrs	r3, r2, #31
10007dd4:	eefc 7bc2 	vcvt.u32.f64	s15, d2
10007dd8:	ee07 3a10 	vmov	s14, r3
10007ddc:	0853      	lsrs	r3, r2, #1
10007dde:	ed8d 0b16 	vstr	d0, [sp, #88]	@ 0x58
10007de2:	ee00 3a10 	vmov	s0, r3
10007de6:	ee17 ca90 	vmov	ip, s15
10007dea:	eeb8 0bc0 	vcvt.f64.s32	d0, s0
10007dee:	ee29 9b0f 	vmul.f64	d9, d9, d15
10007df2:	f002 0201 	and.w	r2, r2, #1
10007df6:	ea4f 035c 	mov.w	r3, ip, lsr #1
10007dfa:	ee07 2a90 	vmov	s15, r2
10007dfe:	ed8d 9b54 	vstr	d9, [sp, #336]	@ 0x150
10007e02:	eeb8 6be7 	vcvt.f64.s32	d6, s15
10007e06:	ed9f 9bde 	vldr	d9, [pc, #888]	@ 10008180 <fndsa_vect_iFFT_fp64_exact+0x11e8>
10007e0a:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10007e0e:	ee02 3a10 	vmov	s4, r3
10007e12:	ee07 0b09 	vmla.f64	d0, d7, d9
10007e16:	ea4f 73dc 	mov.w	r3, ip, lsr #31
10007e1a:	ed8d 3b5c 	vstr	d3, [sp, #368]	@ 0x170
10007e1e:	ee07 3a10 	vmov	s14, r3
10007e22:	eeb8 2bc2 	vcvt.f64.s32	d2, s4
10007e26:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10007e2a:	f00c 0301 	and.w	r3, ip, #1
10007e2e:	ee07 2b09 	vmla.f64	d2, d7, d9
10007e32:	ee07 3a90 	vmov	s15, r3
10007e36:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10007e3a:	ee23 3b0f 	vmul.f64	d3, d3, d15
10007e3e:	ee06 1b09 	vmla.f64	d1, d6, d9
10007e42:	ed8d 3b60 	vstr	d3, [sp, #384]	@ 0x180
10007e46:	ed9d 3b18 	vldr	d3, [sp, #96]	@ 0x60
10007e4a:	ed9d 4b08 	vldr	d4, [sp, #32]
10007e4e:	ee07 3b09 	vmla.f64	d3, d7, d9
10007e52:	ee2b 7b0f 	vmul.f64	d7, d11, d15
10007e56:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007e5a:	ee24 6b0f 	vmul.f64	d6, d4, d15
10007e5e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007e62:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007e66:	ee07 bb4e 	vmls.f64	d11, d7, d14
10007e6a:	eefc 7bcb 	vcvt.u32.f64	s15, d11
10007e6e:	ee17 2a90 	vmov	r2, s15
10007e72:	eeb8 7b46 	vcvt.f64.u32	d7, s12
10007e76:	eeb0 6b44 	vmov.f64	d6, d4
10007e7a:	ee07 6b4e 	vmls.f64	d6, d7, d14
10007e7e:	0fd3      	lsrs	r3, r2, #31
10007e80:	eefc 7bc6 	vcvt.u32.f64	s15, d6
10007e84:	ee06 3a10 	vmov	s12, r3
10007e88:	0853      	lsrs	r3, r2, #1
10007e8a:	ee04 3a10 	vmov	s8, r3
10007e8e:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10007e92:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
10007e96:	ee17 ea90 	vmov	lr, s15
10007e9a:	ee06 4b09 	vmla.f64	d4, d6, d9
10007e9e:	f002 0201 	and.w	r2, r2, #1
10007ea2:	ea4f 73de 	mov.w	r3, lr, lsr #31
10007ea6:	ea4f 0c5e 	mov.w	ip, lr, lsr #1
10007eaa:	ee07 2a90 	vmov	s15, r2
10007eae:	ed8d 4b18 	vstr	d4, [sp, #96]	@ 0x60
10007eb2:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10007eb6:	ed9d 4b0a 	vldr	d4, [sp, #40]	@ 0x28
10007eba:	ee07 4b09 	vmla.f64	d4, d7, d9
10007ebe:	ee06 3a10 	vmov	s12, r3
10007ec2:	ee07 ca90 	vmov	s15, ip
10007ec6:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10007eca:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10007ece:	f00e 0301 	and.w	r3, lr, #1
10007ed2:	ee06 7b09 	vmla.f64	d7, d6, d9
10007ed6:	ed8d 4b10 	vstr	d4, [sp, #64]	@ 0x40
10007eda:	ed8d 7b0c 	vstr	d7, [sp, #48]	@ 0x30
10007ede:	ee07 3a90 	vmov	s15, r3
10007ee2:	ed9d 6b06 	vldr	d6, [sp, #24]
10007ee6:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10007eea:	ed9d bb0e 	vldr	d11, [sp, #56]	@ 0x38
10007eee:	eeb0 4b49 	vmov.f64	d4, d9
10007ef2:	ee07 bb09 	vmla.f64	d11, d7, d9
10007ef6:	ee26 7b0f 	vmul.f64	d7, d6, d15
10007efa:	ee2a 9b0f 	vmul.f64	d9, d10, d15
10007efe:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007f02:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10007f06:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007f0a:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10007f0e:	ee07 6b4e 	vmls.f64	d6, d7, d14
10007f12:	eefc 7bc6 	vcvt.u32.f64	s15, d6
10007f16:	ee17 2a90 	vmov	r2, s15
10007f1a:	ee09 ab4e 	vmls.f64	d10, d9, d14
10007f1e:	0fd3      	lsrs	r3, r2, #31
10007f20:	ee06 3a10 	vmov	s12, r3
10007f24:	0853      	lsrs	r3, r2, #1
10007f26:	eefc 7bca 	vcvt.u32.f64	s15, d10
10007f2a:	ee07 3a10 	vmov	s14, r3
10007f2e:	ee17 ea90 	vmov	lr, s15
10007f32:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10007f36:	f002 0201 	and.w	r2, r2, #1
10007f3a:	eeb0 ab47 	vmov.f64	d10, d7
10007f3e:	ee07 2a90 	vmov	s15, r2
10007f42:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10007f46:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10007f4a:	ed9d 9b12 	vldr	d9, [sp, #72]	@ 0x48
10007f4e:	ea4f 73de 	mov.w	r3, lr, lsr #31
10007f52:	ea4f 0c5e 	mov.w	ip, lr, lsr #1
10007f56:	ee06 ab04 	vmla.f64	d10, d6, d4
10007f5a:	ee07 9b04 	vmla.f64	d9, d7, d4
10007f5e:	ee06 3a10 	vmov	s12, r3
10007f62:	ee07 ca90 	vmov	s15, ip
10007f66:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10007f6a:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10007f6e:	f00e 0301 	and.w	r3, lr, #1
10007f72:	ee06 7b04 	vmla.f64	d7, d6, d4
10007f76:	ed8d 7b04 	vstr	d7, [sp, #16]
10007f7a:	ee07 3a90 	vmov	s15, r3
10007f7e:	ed9d 6b14 	vldr	d6, [sp, #80]	@ 0x50
10007f82:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10007f86:	ee07 6b04 	vmla.f64	d6, d7, d4
10007f8a:	ee25 7b0f 	vmul.f64	d7, d5, d15
10007f8e:	ed8d 6b06 	vstr	d6, [sp, #24]
10007f92:	ee2c 6b0f 	vmul.f64	d6, d12, d15
10007f96:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007f9a:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007f9e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007fa2:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10007fa6:	ee07 5b4e 	vmls.f64	d5, d7, d14
10007faa:	eefc 7bc5 	vcvt.u32.f64	s15, d5
10007fae:	ee17 3a90 	vmov	r3, s15
10007fb2:	ee06 cb4e 	vmls.f64	d12, d6, d14
10007fb6:	0fda      	lsrs	r2, r3, #31
10007fb8:	ee07 2a10 	vmov	s14, r2
10007fbc:	085a      	lsrs	r2, r3, #1
10007fbe:	ed8d ab08 	vstr	d10, [sp, #32]
10007fc2:	eefc 7bcc 	vcvt.u32.f64	s15, d12
10007fc6:	ee0a 2a10 	vmov	s20, r2
10007fca:	ee17 ea90 	vmov	lr, s15
10007fce:	eeb8 abca 	vcvt.f64.s32	d10, s20
10007fd2:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10007fd6:	f003 0301 	and.w	r3, r3, #1
10007fda:	ee07 ab04 	vmla.f64	d10, d7, d4
10007fde:	ea4f 025e 	mov.w	r2, lr, lsr #1
10007fe2:	ed8d 9b0a 	vstr	d9, [sp, #40]	@ 0x28
10007fe6:	ea4f 7cde 	mov.w	ip, lr, lsr #31
10007fea:	ee07 3a90 	vmov	s15, r3
10007fee:	ee09 2a10 	vmov	s18, r2
10007ff2:	f00e 0201 	and.w	r2, lr, #1
10007ff6:	ee07 2a10 	vmov	s14, r2
10007ffa:	eeb8 6be7 	vcvt.f64.s32	d6, s15
10007ffe:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10008002:	ee06 db04 	vmla.f64	d13, d6, d4
10008006:	ed9d 5b16 	vldr	d5, [sp, #88]	@ 0x58
1000800a:	ee07 5b04 	vmla.f64	d5, d7, d4
1000800e:	ee28 7b0f 	vmul.f64	d7, d8, d15
10008012:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10008016:	ee07 ca90 	vmov	s15, ip
1000801a:	eeb8 6be7 	vcvt.f64.s32	d6, s15
1000801e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10008022:	ee07 8b4e 	vmls.f64	d8, d7, d14
10008026:	eebc 7bc8 	vcvt.u32.f64	s14, d8
1000802a:	ee17 3a10 	vmov	r3, s14
1000802e:	0fdb      	lsrs	r3, r3, #31
10008030:	ee07 3a10 	vmov	s14, r3
10008034:	ed8d 8b5a 	vstr	d8, [sp, #360]	@ 0x168
10008038:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
1000803c:	eeb8 9bc9 	vcvt.f64.s32	d9, s18
10008040:	ee28 8b0f 	vmul.f64	d8, d8, d15
10008044:	ed8d 5b00 	vstr	d5, [sp]
10008048:	ee06 9b04 	vmla.f64	d9, d6, d4
1000804c:	ed8d 7b62 	vstr	d7, [sp, #392]	@ 0x188
10008050:	ed8d bb0e 	vstr	d11, [sp, #56]	@ 0x38
10008054:	ed8d db02 	vstr	d13, [sp, #8]
10008058:	ed8d 8b5e 	vstr	d8, [sp, #376]	@ 0x178
1000805c:	f7fd ff7c 	bl	10005f58 <fp64e_cmul_prepared>
10008060:	eeb0 bb40 	vmov.f64	d11, d0
10008064:	eeb0 8b43 	vmov.f64	d8, d3
10008068:	ed9d 3b00 	vldr	d3, [sp]
1000806c:	eeb0 db41 	vmov.f64	d13, d1
10008070:	ed9d 1b02 	vldr	d1, [sp, #8]
10008074:	eeb0 cb42 	vmov.f64	d12, d2
10008078:	ed8d bb1e 	vstr	d11, [sp, #120]	@ 0x78
1000807c:	eeb0 0b4a 	vmov.f64	d0, d10
10008080:	ed8d db20 	vstr	d13, [sp, #128]	@ 0x80
10008084:	eeb0 2b49 	vmov.f64	d2, d9
10008088:	ed8d cb22 	vstr	d12, [sp, #136]	@ 0x88
1000808c:	ed8d 8b24 	vstr	d8, [sp, #144]	@ 0x90
10008090:	f7fd ff62 	bl	10005f58 <fp64e_cmul_prepared>
10008094:	ed9d 4b18 	vldr	d4, [sp, #96]	@ 0x60
10008098:	ed9d 7b0e 	vldr	d7, [sp, #56]	@ 0x38
1000809c:	ed81 4b00 	vstr	d4, [r1]
100080a0:	ed9d 4b10 	vldr	d4, [sp, #64]	@ 0x40
100080a4:	ed9d 5b0c 	vldr	d5, [sp, #48]	@ 0x30
100080a8:	ed9d ab08 	vldr	d10, [sp, #32]
100080ac:	ed9d 9b0a 	vldr	d9, [sp, #40]	@ 0x28
100080b0:	ed81 4b02 	vstr	d4, [r1, #8]
100080b4:	ed9d 6b06 	vldr	d6, [sp, #24]
100080b8:	ed84 7b02 	vstr	d7, [r4, #8]
100080bc:	ed9d 7b04 	vldr	d7, [sp, #16]
100080c0:	ed84 5b00 	vstr	d5, [r4]
100080c4:	3140      	adds	r1, #64	@ 0x40
100080c6:	ed01 ab0c 	vstr	d10, [r1, #-48]	@ 0xffffffd0
100080ca:	ed01 9b0a 	vstr	d9, [r1, #-40]	@ 0xffffffd8
100080ce:	4588      	cmp	r8, r1
100080d0:	ed84 7b04 	vstr	d7, [r4, #16]
100080d4:	f106 0620 	add.w	r6, r6, #32
100080d8:	ed84 6b06 	vstr	d6, [r4, #24]
100080dc:	f104 0440 	add.w	r4, r4, #64	@ 0x40
100080e0:	ed8d 0b26 	vstr	d0, [sp, #152]	@ 0x98
100080e4:	f107 0710 	add.w	r7, r7, #16
100080e8:	ed01 bb08 	vstr	d11, [r1, #-32]	@ 0xffffffe0
100080ec:	ed01 db06 	vstr	d13, [r1, #-24]	@ 0xffffffe8
100080f0:	ed04 cb08 	vstr	d12, [r4, #-32]	@ 0xffffffe0
100080f4:	ed04 8b06 	vstr	d8, [r4, #-24]	@ 0xffffffe8
100080f8:	ed01 0b04 	vstr	d0, [r1, #-16]
100080fc:	ed01 1b02 	vstr	d1, [r1, #-8]
10008100:	ed8d 1b28 	vstr	d1, [sp, #160]	@ 0xa0
10008104:	ed04 2b04 	vstr	d2, [r4, #-16]
10008108:	ed04 3b02 	vstr	d3, [r4, #-8]
1000810c:	ed8d 2b2a 	vstr	d2, [sp, #168]	@ 0xa8
10008110:	ed8d 3b2c 	vstr	d3, [sp, #176]	@ 0xb0
10008114:	f47e af62 	bne.w	10006fdc <fndsa_vect_iFFT_fp64_exact+0x44>
10008118:	f04f 0e04 	mov.w	lr, #4
1000811c:	f1ab 0103 	sub.w	r1, fp, #3
10008120:	2900      	cmp	r1, #0
10008122:	f000 825b 	beq.w	100085dc <fndsa_vect_iFFT_fp64_exact+0x1644>
10008126:	2310      	movs	r3, #16
10008128:	ed9f eb17 	vldr	d14, [pc, #92]	@ 10008188 <fndsa_vect_iFFT_fp64_exact+0x11f0>
1000812c:	ed9f fb18 	vldr	d15, [pc, #96]	@ 10008190 <fndsa_vect_iFFT_fp64_exact+0x11f8>
10008130:	ed9f 9b13 	vldr	d9, [pc, #76]	@ 10008180 <fndsa_vect_iFFT_fp64_exact+0x11e8>
10008134:	4e18      	ldr	r6, [pc, #96]	@ (10008198 <fndsa_vect_iFFT_fp64_exact+0x1200>)
10008136:	fa03 fc0a 	lsl.w	ip, r3, sl
1000813a:	4672      	mov	r2, lr
1000813c:	2301      	movs	r3, #1
1000813e:	f04f 0810 	mov.w	r8, #16
10008142:	eb05 1702 	add.w	r7, r5, r2, lsl #4
10008146:	9208      	str	r2, [sp, #32]
10008148:	eeb7 db00 	vmov.f64	d13, #112	@ 0x3f800000  1.0
1000814c:	462a      	mov	r2, r5
1000814e:	f04f 0b00 	mov.w	fp, #0
10008152:	46e1      	mov	r9, ip
10008154:	408b      	lsls	r3, r1
10008156:	eb03 0353 	add.w	r3, r3, r3, lsr #1
1000815a:	eb06 1303 	add.w	r3, r6, r3, lsl #4
1000815e:	9306      	str	r3, [sp, #24]
10008160:	ea4f 0e4e 	mov.w	lr, lr, lsl #1
10008164:	910a      	str	r1, [sp, #40]	@ 0x28
10008166:	fa08 f801 	lsl.w	r8, r8, r1
1000816a:	f8cd e010 	str.w	lr, [sp, #16]
1000816e:	eb08 0a06 	add.w	sl, r8, r6
10008172:	960c      	str	r6, [sp, #48]	@ 0x30
10008174:	ea4f 180e 	mov.w	r8, lr, lsl #4
10008178:	950e      	str	r5, [sp, #56]	@ 0x38
1000817a:	e00f      	b.n	1000819c <fndsa_vect_iFFT_fp64_exact+0x1204>
1000817c:	f3af 8000 	nop.w
10008180:	00000000 	.word	0x00000000
10008184:	41e00000 	.word	0x41e00000
10008188:	00000000 	.word	0x00000000
1000818c:	41f00000 	.word	0x41f00000
10008190:	00000000 	.word	0x00000000
10008194:	3df00000 	.word	0x3df00000
10008198:	300039a0 	.word	0x300039a0
1000819c:	edda 7a02 	vldr	s15, [sl, #8]
100081a0:	f8da 3004 	ldr.w	r3, [sl, #4]
100081a4:	eeb8 4b67 	vcvt.f64.u32	d4, s15
100081a8:	0fdb      	lsrs	r3, r3, #31
100081aa:	ee03 3a10 	vmov	s6, r3
100081ae:	ee3e 4b44 	vsub.f64	d4, d14, d4
100081b2:	edda 7a03 	vldr	s15, [sl, #12]
100081b6:	eeb8 3bc3 	vcvt.f64.s32	d3, s6
100081ba:	eeb8 7b67 	vcvt.f64.u32	d7, s15
100081be:	ed8d 3b4e 	vstr	d3, [sp, #312]	@ 0x138
100081c2:	ee24 3b0f 	vmul.f64	d3, d4, d15
100081c6:	edda 6a00 	vldr	s13, [sl]
100081ca:	ee3e 7b47 	vsub.f64	d7, d14, d7
100081ce:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100081d2:	eeb8 5b66 	vcvt.f64.u32	d5, s13
100081d6:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100081da:	ee37 7b4d 	vsub.f64	d7, d7, d13
100081de:	ee37 7b03 	vadd.f64	d7, d7, d3
100081e2:	ee03 4b4e 	vmls.f64	d4, d3, d14
100081e6:	edda 6a01 	vldr	s13, [sl, #4]
100081ea:	ed8d 5b48 	vstr	d5, [sp, #288]	@ 0x120
100081ee:	eeb8 6b66 	vcvt.f64.u32	d6, s13
100081f2:	ee27 3b0f 	vmul.f64	d3, d7, d15
100081f6:	ee26 2b0f 	vmul.f64	d2, d6, d15
100081fa:	ee25 1b0f 	vmul.f64	d1, d5, d15
100081fe:	ed8d 2b4a 	vstr	d2, [sp, #296]	@ 0x128
10008202:	ed8d 4b52 	vstr	d4, [sp, #328]	@ 0x148
10008206:	ed8d 6b46 	vstr	d6, [sp, #280]	@ 0x118
1000820a:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000820e:	ee34 5b05 	vadd.f64	d5, d4, d5
10008212:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10008216:	ee24 2b0f 	vmul.f64	d2, d4, d15
1000821a:	ee25 4b0f 	vmul.f64	d4, d5, d15
1000821e:	ee03 7b4e 	vmls.f64	d7, d3, d14
10008222:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10008226:	eefc 3bc7 	vcvt.u32.f64	s7, d7
1000822a:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000822e:	ee37 6b06 	vadd.f64	d6, d7, d6
10008232:	ed8d 7b50 	vstr	d7, [sp, #320]	@ 0x140
10008236:	ee13 1a90 	vmov	r1, s7
1000823a:	ee27 3b0f 	vmul.f64	d3, d7, d15
1000823e:	ee36 7b04 	vadd.f64	d7, d6, d4
10008242:	ee27 6b0f 	vmul.f64	d6, d7, d15
10008246:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000824a:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000824e:	ee06 7b4e 	vmls.f64	d7, d6, d14
10008252:	eefc 6bc7 	vcvt.u32.f64	s13, d7
10008256:	0fc9      	lsrs	r1, r1, #31
10008258:	ee04 5b4e 	vmls.f64	d5, d4, d14
1000825c:	ee04 1a10 	vmov	s8, r1
10008260:	ee16 1a90 	vmov	r1, s13
10008264:	0fc9      	lsrs	r1, r1, #31
10008266:	ee27 6b0f 	vmul.f64	d6, d7, d15
1000826a:	ed8d 7b5a 	vstr	d7, [sp, #360]	@ 0x168
1000826e:	ed8d 2b56 	vstr	d2, [sp, #344]	@ 0x158
10008272:	9b08      	ldr	r3, [sp, #32]
10008274:	ed8d 1b4c 	vstr	d1, [sp, #304]	@ 0x130
10008278:	ee07 1a10 	vmov	s14, r1
1000827c:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
10008280:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10008284:	ee25 2b0f 	vmul.f64	d2, d5, d15
10008288:	445b      	add	r3, fp
1000828a:	459b      	cmp	fp, r3
1000828c:	ed8d 3b54 	vstr	d3, [sp, #336]	@ 0x150
10008290:	ed8d 5b5c 	vstr	d5, [sp, #368]	@ 0x170
10008294:	ed8d 4b58 	vstr	d4, [sp, #352]	@ 0x160
10008298:	ed8d 2b60 	vstr	d2, [sp, #384]	@ 0x180
1000829c:	ed8d 6b5e 	vstr	d6, [sp, #376]	@ 0x178
100082a0:	ed8d 7b62 	vstr	d7, [sp, #392]	@ 0x188
100082a4:	f080 8187 	bcs.w	100085b6 <fndsa_vect_iFFT_fp64_exact+0x161e>
100082a8:	463e      	mov	r6, r7
100082aa:	4611      	mov	r1, r2
100082ac:	eb09 0502 	add.w	r5, r9, r2
100082b0:	eb09 0407 	add.w	r4, r9, r7
100082b4:	9202      	str	r2, [sp, #8]
100082b6:	ed91 ab02 	vldr	d10, [r1, #8]
100082ba:	ee3a 0b0e 	vadd.f64	d0, d10, d14
100082be:	ed96 7b02 	vldr	d7, [r6, #8]
100082c2:	ed91 cb00 	vldr	d12, [r1]
100082c6:	ed96 3b00 	vldr	d3, [r6]
100082ca:	ed95 bb02 	vldr	d11, [r5, #8]
100082ce:	ed94 5b02 	vldr	d5, [r4, #8]
100082d2:	ee37 ab0a 	vadd.f64	d10, d7, d10
100082d6:	ee30 7b47 	vsub.f64	d7, d0, d7
100082da:	ee3c 1b0e 	vadd.f64	d1, d12, d14
100082de:	ee27 2b0f 	vmul.f64	d2, d7, d15
100082e2:	ee33 cb0c 	vadd.f64	d12, d3, d12
100082e6:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100082ea:	ee31 3b43 	vsub.f64	d3, d1, d3
100082ee:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100082f2:	ee33 3b4d 	vsub.f64	d3, d3, d13
100082f6:	ee02 7b4e 	vmls.f64	d7, d2, d14
100082fa:	ee33 3b02 	vadd.f64	d3, d3, d2
100082fe:	ee37 7b0d 	vadd.f64	d7, d7, d13
10008302:	ee23 1b0f 	vmul.f64	d1, d3, d15
10008306:	ee27 2b0f 	vmul.f64	d2, d7, d15
1000830a:	eebc 1bc1 	vcvt.u32.f64	s2, d1
1000830e:	eefc 0bc2 	vcvt.u32.f64	s1, d2
10008312:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10008316:	ee01 3b4e 	vmls.f64	d3, d1, d14
1000831a:	ed9f 4bb5 	vldr	d4, [pc, #724]	@ 100085f0 <fndsa_vect_iFFT_fp64_exact+0x1658>
1000831e:	ed94 8b00 	vldr	d8, [r4]
10008322:	ed95 6b00 	vldr	d6, [r5]
10008326:	ee3b 2b0e 	vadd.f64	d2, d11, d14
1000832a:	ee3b bb05 	vadd.f64	d11, d11, d5
1000832e:	ee32 2b45 	vsub.f64	d2, d2, d5
10008332:	eeb8 5b60 	vcvt.f64.u32	d5, s1
10008336:	ee33 3b04 	vadd.f64	d3, d3, d4
1000833a:	ee33 3b05 	vadd.f64	d3, d3, d5
1000833e:	ee36 4b0e 	vadd.f64	d4, d6, d14
10008342:	ee23 0b0f 	vmul.f64	d0, d3, d15
10008346:	ee36 6b08 	vadd.f64	d6, d6, d8
1000834a:	ee05 7b4e 	vmls.f64	d7, d5, d14
1000834e:	ee22 5b0f 	vmul.f64	d5, d2, d15
10008352:	ed8d 6b00 	vstr	d6, [sp]
10008356:	eebc 0bc0 	vcvt.u32.f64	s0, d0
1000835a:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000835e:	eeb6 6b00 	vmov.f64	d6, #96	@ 0x3f000000  0.5
10008362:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10008366:	eeb8 0b40 	vcvt.f64.u32	d0, s0
1000836a:	ee05 2b4e 	vmls.f64	d2, d5, d14
1000836e:	ee27 7b06 	vmul.f64	d7, d7, d6
10008372:	ee34 6b48 	vsub.f64	d6, d4, d8
10008376:	ee00 3b4e 	vmls.f64	d3, d0, d14
1000837a:	ee36 6b4d 	vsub.f64	d6, d6, d13
1000837e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10008382:	ee36 6b05 	vadd.f64	d6, d6, d5
10008386:	eefc 5bc3 	vcvt.u32.f64	s11, d3
1000838a:	eeb8 1b47 	vcvt.f64.u32	d1, s14
1000838e:	ee15 3a90 	vmov	r3, s11
10008392:	ee32 2b0d 	vadd.f64	d2, d2, d13
10008396:	ee22 7b0f 	vmul.f64	d7, d2, d15
1000839a:	0fda      	lsrs	r2, r3, #31
1000839c:	eefc 3bc7 	vcvt.u32.f64	s7, d7
100083a0:	ee07 2a10 	vmov	s14, r2
100083a4:	085a      	lsrs	r2, r3, #1
100083a6:	ee00 2a10 	vmov	s0, r2
100083aa:	ee26 4b0f 	vmul.f64	d4, d6, d15
100083ae:	f003 0301 	and.w	r3, r3, #1
100083b2:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100083b6:	eeb8 0bc0 	vcvt.f64.s32	d0, s0
100083ba:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100083be:	ee07 0b09 	vmla.f64	d0, d7, d9
100083c2:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100083c6:	ee07 3a90 	vmov	s15, r3
100083ca:	ee04 6b4e 	vmls.f64	d6, d4, d14
100083ce:	eeb8 7be7 	vcvt.f64.s32	d7, s15
100083d2:	eeb8 4b63 	vcvt.f64.u32	d4, s7
100083d6:	ee07 1b09 	vmla.f64	d1, d7, d9
100083da:	ed9f 7b85 	vldr	d7, [pc, #532]	@ 100085f0 <fndsa_vect_iFFT_fp64_exact+0x1658>
100083de:	ee36 6b07 	vadd.f64	d6, d6, d7
100083e2:	ee2a 5b0f 	vmul.f64	d5, d10, d15
100083e6:	ee36 7b04 	vadd.f64	d7, d6, d4
100083ea:	ee04 2b4e 	vmls.f64	d2, d4, d14
100083ee:	ee27 4b0f 	vmul.f64	d4, d7, d15
100083f2:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100083f6:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100083fa:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100083fe:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10008402:	eeb6 6b00 	vmov.f64	d6, #96	@ 0x3f000000  0.5
10008406:	ee04 7b4e 	vmls.f64	d7, d4, d14
1000840a:	ee22 2b06 	vmul.f64	d2, d2, d6
1000840e:	ee3c 6b05 	vadd.f64	d6, d12, d5
10008412:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10008416:	ee26 8b0f 	vmul.f64	d8, d6, d15
1000841a:	ee05 ab4e 	vmls.f64	d10, d5, d14
1000841e:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10008422:	eeb8 3b42 	vcvt.f64.u32	d3, s4
10008426:	ee3a 5b0d 	vadd.f64	d5, d10, d13
1000842a:	eebc 2bc8 	vcvt.u32.f64	s4, d8
1000842e:	ee17 3a90 	vmov	r3, s15
10008432:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10008436:	ee25 4b0f 	vmul.f64	d4, d5, d15
1000843a:	0fda      	lsrs	r2, r3, #31
1000843c:	ee08 2a10 	vmov	s16, r2
10008440:	085a      	lsrs	r2, r3, #1
10008442:	ee02 6b4e 	vmls.f64	d6, d2, d14
10008446:	ed9f 7b6a 	vldr	d7, [pc, #424]	@ 100085f0 <fndsa_vect_iFFT_fp64_exact+0x1658>
1000844a:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000844e:	ee36 6b07 	vadd.f64	d6, d6, d7
10008452:	ee02 2a10 	vmov	s4, r2
10008456:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000845a:	eeb8 8bc8 	vcvt.f64.s32	d8, s16
1000845e:	eeb8 2bc2 	vcvt.f64.s32	d2, s4
10008462:	eeb6 ab00 	vmov.f64	d10, #96	@ 0x3f000000  0.5
10008466:	ee08 2b09 	vmla.f64	d2, d8, d9
1000846a:	ee2b 8b0f 	vmul.f64	d8, d11, d15
1000846e:	ee36 6b04 	vadd.f64	d6, d6, d4
10008472:	ee04 5b4e 	vmls.f64	d5, d4, d14
10008476:	ee25 5b0a 	vmul.f64	d5, d5, d10
1000847a:	f003 0301 	and.w	r3, r3, #1
1000847e:	ee07 3a90 	vmov	s15, r3
10008482:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10008486:	ee26 4b0f 	vmul.f64	d4, d6, d15
1000848a:	eeb8 8b48 	vcvt.f64.u32	d8, s16
1000848e:	eebc abc5 	vcvt.u32.f64	s20, d5
10008492:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10008496:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000849a:	ee07 3b09 	vmla.f64	d3, d7, d9
1000849e:	ed9d 5b00 	vldr	d5, [sp]
100084a2:	ee35 7b08 	vadd.f64	d7, d5, d8
100084a6:	eeb0 5b4b 	vmov.f64	d5, d11
100084aa:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100084ae:	ee08 5b4e 	vmls.f64	d5, d8, d14
100084b2:	ee27 cb0f 	vmul.f64	d12, d7, d15
100084b6:	ee04 6b4e 	vmls.f64	d6, d4, d14
100084ba:	ee35 5b0d 	vadd.f64	d5, d5, d13
100084be:	eebc cbcc 	vcvt.u32.f64	s24, d12
100084c2:	eefc 6bc6 	vcvt.u32.f64	s13, d6
100084c6:	ee25 4b0f 	vmul.f64	d4, d5, d15
100084ca:	eeb8 cb4c 	vcvt.f64.u32	d12, s24
100084ce:	ee16 3a90 	vmov	r3, s13
100084d2:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100084d6:	ed9f 6b46 	vldr	d6, [pc, #280]	@ 100085f0 <fndsa_vect_iFFT_fp64_exact+0x1658>
100084da:	ee0c 7b4e 	vmls.f64	d7, d12, d14
100084de:	0fda      	lsrs	r2, r3, #31
100084e0:	eeb8 bb4a 	vcvt.f64.u32	d11, s20
100084e4:	ee0a 2a10 	vmov	s20, r2
100084e8:	085a      	lsrs	r2, r3, #1
100084ea:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100084ee:	ee37 7b06 	vadd.f64	d7, d7, d6
100084f2:	f003 0301 	and.w	r3, r3, #1
100084f6:	ee06 3a90 	vmov	s13, r3
100084fa:	ee37 7b04 	vadd.f64	d7, d7, d4
100084fe:	eeb8 6be6 	vcvt.f64.s32	d6, s13
10008502:	ee08 2a10 	vmov	s16, r2
10008506:	ee06 bb09 	vmla.f64	d11, d6, d9
1000850a:	ee27 6b0f 	vmul.f64	d6, d7, d15
1000850e:	eeb8 abca 	vcvt.f64.s32	d10, s20
10008512:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10008516:	eeb8 8bc8 	vcvt.f64.s32	d8, s16
1000851a:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000851e:	ee04 5b4e 	vmls.f64	d5, d4, d14
10008522:	ee06 7b4e 	vmls.f64	d7, d6, d14
10008526:	ee0a 8b09 	vmla.f64	d8, d10, d9
1000852a:	eefc 7bc7 	vcvt.u32.f64	s15, d7
1000852e:	eeb6 ab00 	vmov.f64	d10, #96	@ 0x3f000000  0.5
10008532:	ee17 3a90 	vmov	r3, s15
10008536:	ee25 5b0a 	vmul.f64	d5, d5, d10
1000853a:	0fda      	lsrs	r2, r3, #31
1000853c:	ee04 2a10 	vmov	s8, r2
10008540:	085a      	lsrs	r2, r3, #1
10008542:	f003 0301 	and.w	r3, r3, #1
10008546:	ee06 2a10 	vmov	s12, r2
1000854a:	ee07 3a90 	vmov	s15, r3
1000854e:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10008552:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
10008556:	eeb8 7be7 	vcvt.f64.s32	d7, s15
1000855a:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000855e:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10008562:	ee07 5b09 	vmla.f64	d5, d7, d9
10008566:	ed81 8b00 	vstr	d8, [r1]
1000856a:	ed81 bb02 	vstr	d11, [r1, #8]
1000856e:	ee04 6b09 	vmla.f64	d6, d4, d9
10008572:	a846      	add	r0, sp, #280	@ 0x118
10008574:	ed85 6b00 	vstr	d6, [r5]
10008578:	ed85 5b02 	vstr	d5, [r5, #8]
1000857c:	f7fd fcec 	bl	10005f58 <fp64e_cmul_prepared>
10008580:	3110      	adds	r1, #16
10008582:	428f      	cmp	r7, r1
10008584:	ed86 0b00 	vstr	d0, [r6]
10008588:	f105 0510 	add.w	r5, r5, #16
1000858c:	ed86 1b02 	vstr	d1, [r6, #8]
10008590:	f106 0610 	add.w	r6, r6, #16
10008594:	ed8d 0b3e 	vstr	d0, [sp, #248]	@ 0xf8
10008598:	ed84 2b00 	vstr	d2, [r4]
1000859c:	ed84 3b02 	vstr	d3, [r4, #8]
100085a0:	f104 0410 	add.w	r4, r4, #16
100085a4:	ed8d 1b40 	vstr	d1, [sp, #256]	@ 0x100
100085a8:	ed8d 2b42 	vstr	d2, [sp, #264]	@ 0x108
100085ac:	ed8d 3b44 	vstr	d3, [sp, #272]	@ 0x110
100085b0:	f47f ae81 	bne.w	100082b6 <fndsa_vect_iFFT_fp64_exact+0x131e>
100085b4:	9a02      	ldr	r2, [sp, #8]
100085b6:	9b04      	ldr	r3, [sp, #16]
100085b8:	f10a 0a10 	add.w	sl, sl, #16
100085bc:	449b      	add	fp, r3
100085be:	9b06      	ldr	r3, [sp, #24]
100085c0:	4442      	add	r2, r8
100085c2:	4553      	cmp	r3, sl
100085c4:	4447      	add	r7, r8
100085c6:	f47f ade9 	bne.w	1000819c <fndsa_vect_iFFT_fp64_exact+0x1204>
100085ca:	990a      	ldr	r1, [sp, #40]	@ 0x28
100085cc:	46cc      	mov	ip, r9
100085ce:	3901      	subs	r1, #1
100085d0:	f8dd e010 	ldr.w	lr, [sp, #16]
100085d4:	9e0c      	ldr	r6, [sp, #48]	@ 0x30
100085d6:	9d0e      	ldr	r5, [sp, #56]	@ 0x38
100085d8:	f47f adaf 	bne.w	1000813a <fndsa_vect_iFFT_fp64_exact+0x11a2>
100085dc:	b065      	add	sp, #404	@ 0x194
100085de:	ecbd 8b10 	vpop	{d8-d15}
100085e2:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
100085e6:	4651      	mov	r1, sl
100085e8:	f04f 0e01 	mov.w	lr, #1
100085ec:	e598      	b.n	10008120 <fndsa_vect_iFFT_fp64_exact+0x1188>
100085ee:	bf00      	nop
	...

