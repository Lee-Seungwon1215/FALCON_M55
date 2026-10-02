
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/r2-perf/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10006ee0 <fndsa_vect_iFFT_fp64_exact>:
10006ee0:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10006ee4:	ed2d 8b10 	vpush	{d8-d15}
10006ee8:	1e44      	subs	r4, r0, #1
10006eea:	b0c3      	sub	sp, #268	@ 0x10c
10006eec:	f000 8335 	beq.w	1000755a <fndsa_vect_iFFT_fp64_exact+0x67a>
10006ef0:	2310      	movs	r3, #16
10006ef2:	f04f 0c01 	mov.w	ip, #1
10006ef6:	ed9f abf2 	vldr	d10, [pc, #968]	@ 100072c0 <fndsa_vect_iFFT_fp64_exact+0x3e0>
10006efa:	ed9f ebf3 	vldr	d14, [pc, #972]	@ 100072c8 <fndsa_vect_iFFT_fp64_exact+0x3e8>
10006efe:	ed9f fbf4 	vldr	d15, [pc, #976]	@ 100072d0 <fndsa_vect_iFFT_fp64_exact+0x3f0>
10006f02:	fa03 f604 	lsl.w	r6, r3, r4
10006f06:	2301      	movs	r3, #1
10006f08:	4660      	mov	r0, ip
10006f0a:	f04f 0810 	mov.w	r8, #16
10006f0e:	46b2      	mov	sl, r6
10006f10:	f04f 0b00 	mov.w	fp, #0
10006f14:	460e      	mov	r6, r1
10006f16:	fa0c fc03 	lsl.w	ip, ip, r3
10006f1a:	4afb      	ldr	r2, [pc, #1004]	@ (10007308 <fndsa_vect_iFFT_fp64_exact+0x428>)
10006f1c:	40a3      	lsls	r3, r4
10006f1e:	eb03 0353 	add.w	r3, r3, r3, lsr #1
10006f22:	eb02 1303 	add.w	r3, r2, r3, lsl #4
10006f26:	e9cd c307 	strd	ip, r3, [sp, #28]
10006f2a:	e9cd 0409 	strd	r0, r4, [sp, #36]	@ 0x24
10006f2e:	fa08 f804 	lsl.w	r8, r8, r4
10006f32:	4490      	add	r8, r2
10006f34:	eb01 1700 	add.w	r7, r1, r0, lsl #4
10006f38:	910b      	str	r1, [sp, #44]	@ 0x2c
10006f3a:	ea4f 190c 	mov.w	r9, ip, lsl #4
10006f3e:	edd8 7a02 	vldr	s15, [r8, #8]
10006f42:	f8d8 3004 	ldr.w	r3, [r8, #4]
10006f46:	eeb8 5b67 	vcvt.f64.u32	d5, s15
10006f4a:	0fdb      	lsrs	r3, r3, #31
10006f4c:	ee03 3a10 	vmov	s6, r3
10006f50:	ee3a 5b45 	vsub.f64	d5, d10, d5
10006f54:	eeb8 3bc3 	vcvt.f64.s32	d3, s6
10006f58:	edd8 7a03 	vldr	s15, [r8, #12]
10006f5c:	ed8d 3b2c 	vstr	d3, [sp, #176]	@ 0xb0
10006f60:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10006f64:	ee25 3b0e 	vmul.f64	d3, d5, d14
10006f68:	eeb7 bb00 	vmov.f64	d11, #112	@ 0x3f800000  1.0
10006f6c:	edd8 6a00 	vldr	s13, [r8]
10006f70:	edd8 4a01 	vldr	s9, [r8, #4]
10006f74:	ee3a 7b47 	vsub.f64	d7, d10, d7
10006f78:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006f7c:	eeb8 6b66 	vcvt.f64.u32	d6, s13
10006f80:	eeb8 4b64 	vcvt.f64.u32	d4, s9
10006f84:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10006f88:	ed9f 0bd3 	vldr	d0, [pc, #844]	@ 100072d8 <fndsa_vect_iFFT_fp64_exact+0x3f8>
10006f8c:	ed9f 8bd4 	vldr	d8, [pc, #848]	@ 100072e0 <fndsa_vect_iFFT_fp64_exact+0x400>
10006f90:	ee37 7b4b 	vsub.f64	d7, d7, d11
10006f94:	ee03 5b4a 	vmls.f64	d5, d3, d10
10006f98:	ee37 7b03 	vadd.f64	d7, d7, d3
10006f9c:	ee24 2b00 	vmul.f64	d2, d4, d0
10006fa0:	ee26 3b08 	vmul.f64	d3, d6, d8
10006fa4:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10006fa8:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006fac:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10006fb0:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10006fb4:	ed9f 9bcc 	vldr	d9, [pc, #816]	@ 100072e8 <fndsa_vect_iFFT_fp64_exact+0x408>
10006fb8:	eeb0 1b44 	vmov.f64	d1, d4
10006fbc:	ed9f cbcc 	vldr	d12, [pc, #816]	@ 100072f0 <fndsa_vect_iFFT_fp64_exact+0x410>
10006fc0:	ee02 1b49 	vmls.f64	d1, d2, d9
10006fc4:	ed8d 2b28 	vstr	d2, [sp, #160]	@ 0xa0
10006fc8:	eeb0 2b43 	vmov.f64	d2, d3
10006fcc:	ee01 2b0c 	vmla.f64	d2, d1, d12
10006fd0:	ed9f dbc9 	vldr	d13, [pc, #804]	@ 100072f8 <fndsa_vect_iFFT_fp64_exact+0x418>
10006fd4:	ed8d 2b26 	vstr	d2, [sp, #152]	@ 0x98
10006fd8:	eeb0 2b46 	vmov.f64	d2, d6
10006fdc:	ee03 2b4d 	vmls.f64	d2, d3, d13
10006fe0:	ee27 3b0e 	vmul.f64	d3, d7, d14
10006fe4:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006fe8:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10006fec:	ee03 7b4a 	vmls.f64	d7, d3, d10
10006ff0:	eebc 3bc7 	vcvt.u32.f64	s6, d7
10006ff4:	ee13 2a10 	vmov	r2, s6
10006ff8:	0fd2      	lsrs	r2, r2, #31
10006ffa:	ee03 2a10 	vmov	s6, r2
10006ffe:	ed8d 6b2a 	vstr	d6, [sp, #168]	@ 0xa8
10007002:	eeb8 3bc3 	vcvt.f64.s32	d3, s6
10007006:	ee35 6b06 	vadd.f64	d6, d5, d6
1000700a:	ed8d 3b36 	vstr	d3, [sp, #216]	@ 0xd8
1000700e:	ee26 3b0e 	vmul.f64	d3, d6, d14
10007012:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10007016:	ee37 4b04 	vadd.f64	d4, d7, d4
1000701a:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000701e:	ee34 4b03 	vadd.f64	d4, d4, d3
10007022:	ee03 6b4a 	vmls.f64	d6, d3, d10
10007026:	ed8d 2b24 	vstr	d2, [sp, #144]	@ 0x90
1000702a:	ee26 3b08 	vmul.f64	d3, d6, d8
1000702e:	ee24 2b0e 	vmul.f64	d2, d4, d14
10007032:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10007036:	eebc 2bc2 	vcvt.u32.f64	s4, d2
1000703a:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000703e:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10007042:	ed8d 6b3e 	vstr	d6, [sp, #248]	@ 0xf8
10007046:	ee02 4b4a 	vmls.f64	d4, d2, d10
1000704a:	ee03 6b4d 	vmls.f64	d6, d3, d13
1000704e:	ed8d 6b38 	vstr	d6, [sp, #224]	@ 0xe0
10007052:	eebc 6bc4 	vcvt.u32.f64	s12, d4
10007056:	ee16 2a10 	vmov	r2, s12
1000705a:	0fd2      	lsrs	r2, r2, #31
1000705c:	ee06 2a10 	vmov	s12, r2
10007060:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10007064:	ed8d 6b40 	vstr	d6, [sp, #256]	@ 0x100
10007068:	ee27 6b00 	vmul.f64	d6, d7, d0
1000706c:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007070:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10007074:	ee06 7b49 	vmls.f64	d7, d6, d9
10007078:	ed8d 6b32 	vstr	d6, [sp, #200]	@ 0xc8
1000707c:	ee24 6b00 	vmul.f64	d6, d4, d0
10007080:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007084:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10007088:	ee06 4b49 	vmls.f64	d4, d6, d9
1000708c:	ed8d 6b3c 	vstr	d6, [sp, #240]	@ 0xf0
10007090:	ee25 6b08 	vmul.f64	d6, d5, d8
10007094:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007098:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000709c:	ed8d 5b34 	vstr	d5, [sp, #208]	@ 0xd0
100070a0:	ee04 3b0c 	vmla.f64	d3, d4, d12
100070a4:	ee06 5b4d 	vmls.f64	d5, d6, d13
100070a8:	ee07 6b0c 	vmla.f64	d6, d7, d12
100070ac:	9b09      	ldr	r3, [sp, #36]	@ 0x24
100070ae:	ed8d 3b3a 	vstr	d3, [sp, #232]	@ 0xe8
100070b2:	445b      	add	r3, fp
100070b4:	459b      	cmp	fp, r3
100070b6:	ed8d 5b2e 	vstr	d5, [sp, #184]	@ 0xb8
100070ba:	ed8d 6b30 	vstr	d6, [sp, #192]	@ 0xc0
100070be:	f080 823a 	bcs.w	10007536 <fndsa_vect_iFFT_fp64_exact+0x656>
100070c2:	4639      	mov	r1, r7
100070c4:	4632      	mov	r2, r6
100070c6:	eb0a 0506 	add.w	r5, sl, r6
100070ca:	eb0a 0407 	add.w	r4, sl, r7
100070ce:	9606      	str	r6, [sp, #24]
100070d0:	ed92 3b02 	vldr	d3, [r2, #8]
100070d4:	ed91 4b02 	vldr	d4, [r1, #8]
100070d8:	ed94 6b02 	vldr	d6, [r4, #8]
100070dc:	ed95 7b02 	vldr	d7, [r5, #8]
100070e0:	ee33 1b0a 	vadd.f64	d1, d3, d10
100070e4:	ed92 5b00 	vldr	d5, [r2]
100070e8:	ee31 1b44 	vsub.f64	d1, d1, d4
100070ec:	ee37 2b0a 	vadd.f64	d2, d7, d10
100070f0:	ee36 7b07 	vadd.f64	d7, d6, d7
100070f4:	ed91 0b00 	vldr	d0, [r1]
100070f8:	ee33 3b04 	vadd.f64	d3, d3, d4
100070fc:	ee32 2b46 	vsub.f64	d2, d2, d6
10007100:	ee21 4b0e 	vmul.f64	d4, d1, d14
10007104:	ee27 8b0e 	vmul.f64	d8, d7, d14
10007108:	ee35 6b0a 	vadd.f64	d6, d5, d10
1000710c:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10007110:	ee36 6b40 	vsub.f64	d6, d6, d0
10007114:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10007118:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000711c:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10007120:	ee36 6b4b 	vsub.f64	d6, d6, d11
10007124:	ed95 db00 	vldr	d13, [r5]
10007128:	ee36 6b04 	vadd.f64	d6, d6, d4
1000712c:	ee08 7b4a 	vmls.f64	d7, d8, d10
10007130:	ee04 1b4a 	vmls.f64	d1, d4, d10
10007134:	ee23 4b0e 	vmul.f64	d4, d3, d14
10007138:	ed94 cb00 	vldr	d12, [r4]
1000713c:	ee37 9b0b 	vadd.f64	d9, d7, d11
10007140:	ee30 5b05 	vadd.f64	d5, d0, d5
10007144:	ee3d 7b0a 	vadd.f64	d7, d13, d10
10007148:	ee22 0b0e 	vmul.f64	d0, d2, d14
1000714c:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10007150:	ee37 7b4c 	vsub.f64	d7, d7, d12
10007154:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10007158:	eebc 0bc0 	vcvt.u32.f64	s0, d0
1000715c:	ee35 5b04 	vadd.f64	d5, d5, d4
10007160:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10007164:	ee04 3b4a 	vmls.f64	d3, d4, d10
10007168:	ee37 7b4b 	vsub.f64	d7, d7, d11
1000716c:	ee3d 4b0c 	vadd.f64	d4, d13, d12
10007170:	ee37 7b00 	vadd.f64	d7, d7, d0
10007174:	ee34 4b08 	vadd.f64	d4, d4, d8
10007178:	ee00 2b4a 	vmls.f64	d2, d0, d10
1000717c:	ee26 8b0e 	vmul.f64	d8, d6, d14
10007180:	ee25 0b0e 	vmul.f64	d0, d5, d14
10007184:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10007188:	eebc 0bc0 	vcvt.u32.f64	s0, d0
1000718c:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10007190:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10007194:	ee08 6b4a 	vmls.f64	d6, d8, d10
10007198:	ee00 5b4a 	vmls.f64	d5, d0, d10
1000719c:	ee24 8b0e 	vmul.f64	d8, d4, d14
100071a0:	ee27 0b0e 	vmul.f64	d0, d7, d14
100071a4:	eebc 8bc8 	vcvt.u32.f64	s16, d8
100071a8:	eebc 0bc0 	vcvt.u32.f64	s0, d0
100071ac:	ee31 1b0b 	vadd.f64	d1, d1, d11
100071b0:	ee33 3b0b 	vadd.f64	d3, d3, d11
100071b4:	eeb8 8b48 	vcvt.f64.u32	d8, s16
100071b8:	eeb8 0b40 	vcvt.f64.u32	d0, s0
100071bc:	ee08 4b4a 	vmls.f64	d4, d8, d10
100071c0:	ee00 7b4a 	vmls.f64	d7, d0, d10
100071c4:	ee21 8b0e 	vmul.f64	d8, d1, d14
100071c8:	ee23 0b0e 	vmul.f64	d0, d3, d14
100071cc:	ed9f cb4c 	vldr	d12, [pc, #304]	@ 10007300 <fndsa_vect_iFFT_fp64_exact+0x420>
100071d0:	eebc 8bc8 	vcvt.u32.f64	s16, d8
100071d4:	eebc 0bc0 	vcvt.u32.f64	s0, d0
100071d8:	eeb8 8b48 	vcvt.f64.u32	d8, s16
100071dc:	eeb8 0b40 	vcvt.f64.u32	d0, s0
100071e0:	ee36 6b0c 	vadd.f64	d6, d6, d12
100071e4:	ee08 1b4a 	vmls.f64	d1, d8, d10
100071e8:	ee36 6b08 	vadd.f64	d6, d6, d8
100071ec:	ee00 3b4a 	vmls.f64	d3, d0, d10
100071f0:	eeb6 8b00 	vmov.f64	d8, #96	@ 0x3f000000  0.5
100071f4:	ee23 3b08 	vmul.f64	d3, d3, d8
100071f8:	ee32 2b0b 	vadd.f64	d2, d2, d11
100071fc:	ee35 5b0c 	vadd.f64	d5, d5, d12
10007200:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10007204:	ee21 1b08 	vmul.f64	d1, d1, d8
10007208:	ee35 5b00 	vadd.f64	d5, d5, d0
1000720c:	eeb8 0b43 	vcvt.f64.u32	d0, s6
10007210:	ee22 3b0e 	vmul.f64	d3, d2, d14
10007214:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10007218:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000721c:	eeb8 db41 	vcvt.f64.u32	d13, s2
10007220:	ee29 1b0e 	vmul.f64	d1, d9, d14
10007224:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10007228:	ee37 7b0c 	vadd.f64	d7, d7, d12
1000722c:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10007230:	ee37 7b03 	vadd.f64	d7, d7, d3
10007234:	ee03 2b4a 	vmls.f64	d2, d3, d10
10007238:	ee26 3b0e 	vmul.f64	d3, d6, d14
1000723c:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10007240:	ee34 4b0c 	vadd.f64	d4, d4, d12
10007244:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10007248:	ee34 4b01 	vadd.f64	d4, d4, d1
1000724c:	ee01 9b4a 	vmls.f64	d9, d1, d10
10007250:	ee25 1b0e 	vmul.f64	d1, d5, d14
10007254:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10007258:	eebc 1bc1 	vcvt.u32.f64	s2, d1
1000725c:	ee03 6b4a 	vmls.f64	d6, d3, d10
10007260:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10007264:	eefc 6bc6 	vcvt.u32.f64	s13, d6
10007268:	ee01 5b4a 	vmls.f64	d5, d1, d10
1000726c:	ee16 ca90 	vmov	ip, s13
10007270:	eefc 6bc5 	vcvt.u32.f64	s13, d5
10007274:	ea4f 76dc 	mov.w	r6, ip, lsr #31
10007278:	ee05 6a10 	vmov	s10, r6
1000727c:	ea4f 065c 	mov.w	r6, ip, lsr #1
10007280:	f00c 0c01 	and.w	ip, ip, #1
10007284:	ee16 3a90 	vmov	r3, s13
10007288:	ee03 6a10 	vmov	s6, r6
1000728c:	ee06 ca90 	vmov	s13, ip
10007290:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
10007294:	eeb8 6be6 	vcvt.f64.s32	d6, s13
10007298:	eeb8 3bc3 	vcvt.f64.s32	d3, s6
1000729c:	ea4f 0e53 	mov.w	lr, r3, lsr #1
100072a0:	0fde      	lsrs	r6, r3, #31
100072a2:	ee05 3b0f 	vmla.f64	d3, d5, d15
100072a6:	ee06 db0f 	vmla.f64	d13, d6, d15
100072aa:	ee05 6a10 	vmov	s10, r6
100072ae:	ee06 ea90 	vmov	s13, lr
100072b2:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
100072b6:	eeb8 6be6 	vcvt.f64.s32	d6, s13
100072ba:	e027      	b.n	1000730c <fndsa_vect_iFFT_fp64_exact+0x42c>
100072bc:	f3af 8000 	nop.w
100072c0:	00000000 	.word	0x00000000
100072c4:	41f00000 	.word	0x41f00000
100072c8:	00000000 	.word	0x00000000
100072cc:	3df00000 	.word	0x3df00000
100072d0:	00000000 	.word	0x00000000
100072d4:	41e00000 	.word	0x41e00000
100072d8:	00000000 	.word	0x00000000
100072dc:	3ef00000 	.word	0x3ef00000
100072e0:	00000000 	.word	0x00000000
100072e4:	3e700000 	.word	0x3e700000
100072e8:	00000000 	.word	0x00000000
100072ec:	40f00000 	.word	0x40f00000
100072f0:	00000000 	.word	0x00000000
100072f4:	40700000 	.word	0x40700000
100072f8:	00000000 	.word	0x00000000
100072fc:	41700000 	.word	0x41700000
	...
10007308:	300039a0 	.word	0x300039a0
1000730c:	ee05 6b0f 	vmla.f64	d6, d5, d15
10007310:	ee24 5b0e 	vmul.f64	d5, d4, d14
10007314:	f003 0301 	and.w	r3, r3, #1
10007318:	ed82 6b00 	vstr	d6, [r2]
1000731c:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10007320:	ee06 3a90 	vmov	s13, r3
10007324:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10007328:	eeb8 6be6 	vcvt.f64.s32	d6, s13
1000732c:	ee05 4b4a 	vmls.f64	d4, d5, d10
10007330:	ee06 0b0f 	vmla.f64	d0, d6, d15
10007334:	ee27 6b0e 	vmul.f64	d6, d7, d14
10007338:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000733c:	eefc 6bc4 	vcvt.u32.f64	s13, d4
10007340:	ee16 3a90 	vmov	r3, s13
10007344:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10007348:	ee06 7b4a 	vmls.f64	d7, d6, d10
1000734c:	0fde      	lsrs	r6, r3, #31
1000734e:	ee05 6a10 	vmov	s10, r6
10007352:	085e      	lsrs	r6, r3, #1
10007354:	ee06 6a10 	vmov	s12, r6
10007358:	ee29 9b08 	vmul.f64	d9, d9, d8
1000735c:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10007360:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
10007364:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10007368:	f003 0301 	and.w	r3, r3, #1
1000736c:	ee17 ca90 	vmov	ip, s15
10007370:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10007374:	ee07 3a90 	vmov	s15, r3
10007378:	ee05 6b0f 	vmla.f64	d6, d5, d15
1000737c:	ee22 2b08 	vmul.f64	d2, d2, d8
10007380:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10007384:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10007388:	ea4f 73dc 	mov.w	r3, ip, lsr #31
1000738c:	ed82 0b02 	vstr	d0, [r2, #8]
10007390:	ed85 6b00 	vstr	d6, [r5]
10007394:	ee06 3a10 	vmov	s12, r3
10007398:	ea4f 035c 	mov.w	r3, ip, lsr #1
1000739c:	ee08 3a10 	vmov	s16, r3
100073a0:	f00c 0301 	and.w	r3, ip, #1
100073a4:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100073a8:	ee07 9b0f 	vmla.f64	d9, d7, d15
100073ac:	ee07 3a10 	vmov	s14, r3
100073b0:	eeb8 cb42 	vcvt.f64.u32	d12, s4
100073b4:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100073b8:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
100073bc:	eeb8 8bc8 	vcvt.f64.s32	d8, s16
100073c0:	ee07 cb0f 	vmla.f64	d12, d7, d15
100073c4:	ee06 8b0f 	vmla.f64	d8, d6, d15
100073c8:	eeb0 0b43 	vmov.f64	d0, d3
100073cc:	eeb0 1b4d 	vmov.f64	d1, d13
100073d0:	ed85 9b02 	vstr	d9, [r5, #8]
100073d4:	a824      	add	r0, sp, #144	@ 0x90
100073d6:	ed8d 3b1c 	vstr	d3, [sp, #112]	@ 0x70
100073da:	ed8d 3b00 	vstr	d3, [sp]
100073de:	ed8d db1e 	vstr	d13, [sp, #120]	@ 0x78
100073e2:	ed8d cb22 	vstr	d12, [sp, #136]	@ 0x88
100073e6:	ed8d 8b20 	vstr	d8, [sp, #128]	@ 0x80
100073ea:	f7fe fe99 	bl	10006120 <fp64e_mul24_prepared>
100073ee:	a82e      	add	r0, sp, #184	@ 0xb8
100073f0:	eeb0 9b40 	vmov.f64	d9, d0
100073f4:	ed8d 0b0c 	vstr	d0, [sp, #48]	@ 0x30
100073f8:	ed8d 1b0e 	vstr	d1, [sp, #56]	@ 0x38
100073fc:	eeb0 0b48 	vmov.f64	d0, d8
10007400:	ed8d 1b04 	vstr	d1, [sp, #16]
10007404:	eeb0 1b4c 	vmov.f64	d1, d12
10007408:	f7fe fe8a 	bl	10006120 <fp64e_mul24_prepared>
1000740c:	eeb0 5b41 	vmov.f64	d5, d1
10007410:	ee3c 1b0d 	vadd.f64	d1, d12, d13
10007414:	ee21 4b0e 	vmul.f64	d4, d1, d14
10007418:	ed9d 3b00 	vldr	d3, [sp]
1000741c:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10007420:	eeb0 6b40 	vmov.f64	d6, d0
10007424:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10007428:	ee38 0b03 	vadd.f64	d0, d8, d3
1000742c:	ee30 0b04 	vadd.f64	d0, d0, d4
10007430:	ee04 1b4a 	vmls.f64	d1, d4, d10
10007434:	ee20 4b0e 	vmul.f64	d4, d0, d14
10007438:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000743c:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10007440:	ee04 0b4a 	vmls.f64	d0, d4, d10
10007444:	a838      	add	r0, sp, #224	@ 0xe0
10007446:	ed8d 6b10 	vstr	d6, [sp, #64]	@ 0x40
1000744a:	ed8d 6b02 	vstr	d6, [sp, #8]
1000744e:	ed8d 5b12 	vstr	d5, [sp, #72]	@ 0x48
10007452:	ed8d 5b00 	vstr	d5, [sp]
10007456:	ed8d 1b1a 	vstr	d1, [sp, #104]	@ 0x68
1000745a:	ed8d 0b18 	vstr	d0, [sp, #96]	@ 0x60
1000745e:	f7fe fe5f 	bl	10006120 <fp64e_mul24_prepared>
10007462:	ed9d 5b00 	vldr	d5, [sp]
10007466:	ed9d 7b04 	vldr	d7, [sp, #16]
1000746a:	ee37 4b05 	vadd.f64	d4, d7, d5
1000746e:	ee37 7b0a 	vadd.f64	d7, d7, d10
10007472:	ed9d 6b02 	vldr	d6, [sp, #8]
10007476:	ee37 7b45 	vsub.f64	d7, d7, d5
1000747a:	ee24 5b0e 	vmul.f64	d5, d4, d14
1000747e:	eefc 3bc5 	vcvt.u32.f64	s7, d5
10007482:	ee39 5b06 	vadd.f64	d5, d9, d6
10007486:	ee39 9b0a 	vadd.f64	d9, d9, d10
1000748a:	ee39 9b46 	vsub.f64	d9, d9, d6
1000748e:	eeb8 6b63 	vcvt.f64.u32	d6, s7
10007492:	ee35 5b06 	vadd.f64	d5, d5, d6
10007496:	ee06 4b4a 	vmls.f64	d4, d6, d10
1000749a:	ee27 6b0e 	vmul.f64	d6, d7, d14
1000749e:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100074a2:	ee39 9b4b 	vsub.f64	d9, d9, d11
100074a6:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100074aa:	ee39 9b06 	vadd.f64	d9, d9, d6
100074ae:	ee06 7b4a 	vmls.f64	d7, d6, d10
100074b2:	ee25 3b0e 	vmul.f64	d3, d5, d14
100074b6:	ed81 7b02 	vstr	d7, [r1, #8]
100074ba:	ee29 7b0e 	vmul.f64	d7, d9, d14
100074be:	ed8d 1b16 	vstr	d1, [sp, #88]	@ 0x58
100074c2:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100074c6:	ee31 1b0a 	vadd.f64	d1, d1, d10
100074ca:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100074ce:	ee31 4b44 	vsub.f64	d4, d1, d4
100074d2:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100074d6:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100074da:	ee07 9b4a 	vmls.f64	d9, d7, d10
100074de:	ed8d 0b14 	vstr	d0, [sp, #80]	@ 0x50
100074e2:	ee24 7b0e 	vmul.f64	d7, d4, d14
100074e6:	ee30 0b0a 	vadd.f64	d0, d0, d10
100074ea:	ee03 5b4a 	vmls.f64	d5, d3, d10
100074ee:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100074f2:	ee30 0b45 	vsub.f64	d0, d0, d5
100074f6:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100074fa:	ee30 0b4b 	vsub.f64	d0, d0, d11
100074fe:	ee30 0b07 	vadd.f64	d0, d0, d7
10007502:	ee07 4b4a 	vmls.f64	d4, d7, d10
10007506:	ee20 7b0e 	vmul.f64	d7, d0, d14
1000750a:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000750e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007512:	ee07 0b4a 	vmls.f64	d0, d7, d10
10007516:	3210      	adds	r2, #16
10007518:	3410      	adds	r4, #16
1000751a:	4297      	cmp	r7, r2
1000751c:	f101 0110 	add.w	r1, r1, #16
10007520:	ed01 9b04 	vstr	d9, [r1, #-16]
10007524:	f105 0510 	add.w	r5, r5, #16
10007528:	ed04 4b02 	vstr	d4, [r4, #-8]
1000752c:	ed04 0b04 	vstr	d0, [r4, #-16]
10007530:	f47f adce 	bne.w	100070d0 <fndsa_vect_iFFT_fp64_exact+0x1f0>
10007534:	9e06      	ldr	r6, [sp, #24]
10007536:	9b07      	ldr	r3, [sp, #28]
10007538:	f108 0810 	add.w	r8, r8, #16
1000753c:	449b      	add	fp, r3
1000753e:	9b08      	ldr	r3, [sp, #32]
10007540:	444e      	add	r6, r9
10007542:	4543      	cmp	r3, r8
10007544:	444f      	add	r7, r9
10007546:	f47f acfa 	bne.w	10006f3e <fndsa_vect_iFFT_fp64_exact+0x5e>
1000754a:	9c0a      	ldr	r4, [sp, #40]	@ 0x28
1000754c:	4656      	mov	r6, sl
1000754e:	3c01      	subs	r4, #1
10007550:	f8dd c01c 	ldr.w	ip, [sp, #28]
10007554:	990b      	ldr	r1, [sp, #44]	@ 0x2c
10007556:	f47f acd6 	bne.w	10006f06 <fndsa_vect_iFFT_fp64_exact+0x26>
1000755a:	b043      	add	sp, #268	@ 0x10c
1000755c:	ecbd 8b10 	vpop	{d8-d15}
10007560:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
