
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/asm-profile/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10006e20 <fndsa_vect_FFT_fp64_exact>:
10006e20:	2801      	cmp	r0, #1
10006e22:	f240 8187 	bls.w	10007134 <fndsa_vect_FFT_fp64_exact+0x314>
10006e26:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10006e2a:	460f      	mov	r7, r1
10006e2c:	2101      	movs	r1, #1
10006e2e:	ed2d 8b10 	vpush	{d8-d15}
10006e32:	2210      	movs	r2, #16
10006e34:	ed9f fbc0 	vldr	d15, [pc, #768]	@ 10007138 <fndsa_vect_FFT_fp64_exact+0x318>
10006e38:	ed9f ebc1 	vldr	d14, [pc, #772]	@ 10007140 <fndsa_vect_FFT_fp64_exact+0x320>
10006e3c:	ed9f dbc2 	vldr	d13, [pc, #776]	@ 10007148 <fndsa_vect_FFT_fp64_exact+0x328>
10006e40:	460c      	mov	r4, r1
10006e42:	1e43      	subs	r3, r0, #1
10006e44:	b0ad      	sub	sp, #180	@ 0xb4
10006e46:	9005      	str	r0, [sp, #20]
10006e48:	409a      	lsls	r2, r3
10006e4a:	fa01 f003 	lsl.w	r0, r1, r3
10006e4e:	2501      	movs	r5, #1
10006e50:	f04f 0a10 	mov.w	sl, #16
10006e54:	4ec6      	ldr	r6, [pc, #792]	@ (10007170 <fndsa_vect_FFT_fp64_exact+0x350>)
10006e56:	fa0a fa04 	lsl.w	sl, sl, r4
10006e5a:	4680      	mov	r8, r0
10006e5c:	40e8      	lsrs	r0, r5
10006e5e:	eb07 1900 	add.w	r9, r7, r0, lsl #4
10006e62:	9001      	str	r0, [sp, #4]
10006e64:	9704      	str	r7, [sp, #16]
10006e66:	eb0a 0006 	add.w	r0, sl, r6
10006e6a:	eeb7 cb00 	vmov.f64	d12, #112	@ 0x3f800000  1.0
10006e6e:	46ba      	mov	sl, r7
10006e70:	4693      	mov	fp, r2
10006e72:	2700      	movs	r7, #0
10006e74:	40a5      	lsls	r5, r4
10006e76:	eb05 0555 	add.w	r5, r5, r5, lsr #1
10006e7a:	eb06 1505 	add.w	r5, r6, r5, lsl #4
10006e7e:	e9cd 5402 	strd	r5, r4, [sp, #8]
10006e82:	edd0 7a00 	vldr	s15, [r0]
10006e86:	eeb8 1b67 	vcvt.f64.u32	d1, s15
10006e8a:	edd0 7a02 	vldr	s15, [r0, #8]
10006e8e:	eeb8 3b67 	vcvt.f64.u32	d3, s15
10006e92:	edd0 7a01 	vldr	s15, [r0, #4]
10006e96:	eeb8 6b67 	vcvt.f64.u32	d6, s15
10006e9a:	edd0 7a03 	vldr	s15, [r0, #12]
10006e9e:	6843      	ldr	r3, [r0, #4]
10006ea0:	ee21 4b0f 	vmul.f64	d4, d1, d15
10006ea4:	0fdb      	lsrs	r3, r3, #31
10006ea6:	ee05 3a10 	vmov	s10, r3
10006eaa:	ee17 3a90 	vmov	r3, s15
10006eae:	0fdb      	lsrs	r3, r3, #31
10006eb0:	ed9f 9ba7 	vldr	d9, [pc, #668]	@ 10007150 <fndsa_vect_FFT_fp64_exact+0x330>
10006eb4:	ee07 3a10 	vmov	s14, r3
10006eb8:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10006ebc:	eeb8 2b67 	vcvt.f64.u32	d2, s15
10006ec0:	ee26 0b09 	vmul.f64	d0, d6, d9
10006ec4:	ed9f aba4 	vldr	d10, [pc, #656]	@ 10007158 <fndsa_vect_FFT_fp64_exact+0x338>
10006ec8:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10006ecc:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10006ed0:	ed8d 7b20 	vstr	d7, [sp, #128]	@ 0x80
10006ed4:	ed8d 1b14 	vstr	d1, [sp, #80]	@ 0x50
10006ed8:	ee31 7b03 	vadd.f64	d7, d1, d3
10006edc:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10006ee0:	ee04 1b4a 	vmls.f64	d1, d4, d10
10006ee4:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10006ee8:	ed9f bb9d 	vldr	d11, [pc, #628]	@ 10007160 <fndsa_vect_FFT_fp64_exact+0x340>
10006eec:	ed8d 1b0e 	vstr	d1, [sp, #56]	@ 0x38
10006ef0:	eeb0 1b46 	vmov.f64	d1, d6
10006ef4:	ed8d 0b12 	vstr	d0, [sp, #72]	@ 0x48
10006ef8:	ee00 1b4b 	vmls.f64	d1, d0, d11
10006efc:	ed9f 0b9a 	vldr	d0, [pc, #616]	@ 10007168 <fndsa_vect_FFT_fp64_exact+0x348>
10006f00:	ee22 8b09 	vmul.f64	d8, d2, d9
10006f04:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
10006f08:	ee01 4b00 	vmla.f64	d4, d1, d0
10006f0c:	ed8d 5b16 	vstr	d5, [sp, #88]	@ 0x58
10006f10:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10006f14:	ee23 5b0f 	vmul.f64	d5, d3, d15
10006f18:	ed8d 4b10 	vstr	d4, [sp, #64]	@ 0x40
10006f1c:	ee27 4b0e 	vmul.f64	d4, d7, d14
10006f20:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10006f24:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10006f28:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10006f2c:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10006f30:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10006f34:	ee36 6b02 	vadd.f64	d6, d6, d2
10006f38:	ee08 2b4b 	vmls.f64	d2, d8, d11
10006f3c:	ee36 6b04 	vadd.f64	d6, d6, d4
10006f40:	ed8d 3b1e 	vstr	d3, [sp, #120]	@ 0x78
10006f44:	ee05 3b4a 	vmls.f64	d3, d5, d10
10006f48:	ee02 5b00 	vmla.f64	d5, d2, d0
10006f4c:	ed8d 5b1a 	vstr	d5, [sp, #104]	@ 0x68
10006f50:	ee26 5b0e 	vmul.f64	d5, d6, d14
10006f54:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10006f58:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10006f5c:	ee05 6b4d 	vmls.f64	d6, d5, d13
10006f60:	ee04 7b4d 	vmls.f64	d7, d4, d13
10006f64:	ee26 5b09 	vmul.f64	d5, d6, d9
10006f68:	eebc 4bc6 	vcvt.u32.f64	s8, d6
10006f6c:	ed8d 3b18 	vstr	d3, [sp, #96]	@ 0x60
10006f70:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10006f74:	eeb0 3b47 	vmov.f64	d3, d7
10006f78:	ee27 7b0f 	vmul.f64	d7, d7, d15
10006f7c:	9b01      	ldr	r3, [sp, #4]
10006f7e:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10006f82:	19d9      	adds	r1, r3, r7
10006f84:	ee14 3a10 	vmov	r3, s8
10006f88:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006f8c:	0fdb      	lsrs	r3, r3, #31
10006f8e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006f92:	ee04 3a10 	vmov	s8, r3
10006f96:	ee05 6b4b 	vmls.f64	d6, d5, d11
10006f9a:	ed8d 3b28 	vstr	d3, [sp, #160]	@ 0xa0
10006f9e:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
10006fa2:	ee07 3b4a 	vmls.f64	d3, d7, d10
10006fa6:	ee06 7b00 	vmla.f64	d7, d6, d0
10006faa:	428f      	cmp	r7, r1
10006fac:	ed8d 8b1c 	vstr	d8, [sp, #112]	@ 0x70
10006fb0:	ed8d 3b22 	vstr	d3, [sp, #136]	@ 0x88
10006fb4:	ed8d 4b2a 	vstr	d4, [sp, #168]	@ 0xa8
10006fb8:	ed8d 5b26 	vstr	d5, [sp, #152]	@ 0x98
10006fbc:	ed8d 7b24 	vstr	d7, [sp, #144]	@ 0x90
10006fc0:	f080 80a0 	bcs.w	10007104 <fndsa_vect_FFT_fp64_exact+0x2e4>
10006fc4:	4649      	mov	r1, r9
10006fc6:	4654      	mov	r4, sl
10006fc8:	eb0b 050a 	add.w	r5, fp, sl
10006fcc:	eb0b 0609 	add.w	r6, fp, r9
10006fd0:	9000      	str	r0, [sp, #0]
10006fd2:	ed91 0b00 	vldr	d0, [r1]
10006fd6:	ed91 1b02 	vldr	d1, [r1, #8]
10006fda:	ed96 2b00 	vldr	d2, [r6]
10006fde:	ed96 3b02 	vldr	d3, [r6, #8]
10006fe2:	a80e      	add	r0, sp, #56	@ 0x38
10006fe4:	f7ff f89c 	bl	10006120 <fp64e_cmul_prepared>
10006fe8:	ed94 9b02 	vldr	d9, [r4, #8]
10006fec:	ee39 7b0d 	vadd.f64	d7, d9, d13
10006ff0:	ee39 9b01 	vadd.f64	d9, d9, d1
10006ff4:	ed95 ab02 	vldr	d10, [r5, #8]
10006ff8:	ee29 5b0e 	vmul.f64	d5, d9, d14
10006ffc:	ed94 8b00 	vldr	d8, [r4]
10007000:	ee3a 6b0d 	vadd.f64	d6, d10, d13
10007004:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10007008:	ee3a ab03 	vadd.f64	d10, d10, d3
1000700c:	ee36 6b43 	vsub.f64	d6, d6, d3
10007010:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10007014:	ed8d 3b0c 	vstr	d3, [sp, #48]	@ 0x30
10007018:	ee38 3b0d 	vadd.f64	d3, d8, d13
1000701c:	ee38 8b00 	vadd.f64	d8, d8, d0
10007020:	ed95 bb00 	vldr	d11, [r5]
10007024:	ee2a 4b0e 	vmul.f64	d4, d10, d14
10007028:	ee05 9b4d 	vmls.f64	d9, d5, d13
1000702c:	ee38 8b05 	vadd.f64	d8, d8, d5
10007030:	ee26 5b0e 	vmul.f64	d5, d6, d14
10007034:	ee33 3b40 	vsub.f64	d3, d3, d0
10007038:	ed8d 0b06 	vstr	d0, [sp, #24]
1000703c:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10007040:	eefc 0bc5 	vcvt.u32.f64	s1, d5
10007044:	ee3b 5b0d 	vadd.f64	d5, d11, d13
10007048:	ed84 9b02 	vstr	d9, [r4, #8]
1000704c:	ee37 7b41 	vsub.f64	d7, d7, d1
10007050:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10007054:	eeb0 9b4a 	vmov.f64	d9, d10
10007058:	ee35 5b42 	vsub.f64	d5, d5, d2
1000705c:	ed8d 1b08 	vstr	d1, [sp, #32]
10007060:	ee3b 1b02 	vadd.f64	d1, d11, d2
10007064:	ee27 ab0e 	vmul.f64	d10, d7, d14
10007068:	ee31 1b04 	vadd.f64	d1, d1, d4
1000706c:	ee04 9b4d 	vmls.f64	d9, d4, d13
10007070:	ee35 5b4c 	vsub.f64	d5, d5, d12
10007074:	eeb8 4b60 	vcvt.f64.u32	d4, s1
10007078:	eebc abca 	vcvt.u32.f64	s20, d10
1000707c:	ee35 5b04 	vadd.f64	d5, d5, d4
10007080:	ee04 6b4d 	vmls.f64	d6, d4, d13
10007084:	ee21 4b0e 	vmul.f64	d4, d1, d14
10007088:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
1000708c:	ee33 3b4c 	vsub.f64	d3, d3, d12
10007090:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10007094:	ee33 3b0a 	vadd.f64	d3, d3, d10
10007098:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000709c:	ee04 1b4d 	vmls.f64	d1, d4, d13
100070a0:	ee23 4b0e 	vmul.f64	d4, d3, d14
100070a4:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100070a8:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100070ac:	ed8d 2b0a 	vstr	d2, [sp, #40]	@ 0x28
100070b0:	ee04 3b4d 	vmls.f64	d3, d4, d13
100070b4:	ee25 2b0e 	vmul.f64	d2, d5, d14
100070b8:	ee28 4b0e 	vmul.f64	d4, d8, d14
100070bc:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100070c0:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100070c4:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100070c8:	eeb8 4b44 	vcvt.f64.u32	d4, s8
100070cc:	ee0a 7b4d 	vmls.f64	d7, d10, d13
100070d0:	ee02 5b4d 	vmls.f64	d5, d2, d13
100070d4:	ee04 8b4d 	vmls.f64	d8, d4, d13
100070d8:	3410      	adds	r4, #16
100070da:	3510      	adds	r5, #16
100070dc:	3110      	adds	r1, #16
100070de:	3610      	adds	r6, #16
100070e0:	45a1      	cmp	r9, r4
100070e2:	ed04 8b04 	vstr	d8, [r4, #-16]
100070e6:	ed05 1b04 	vstr	d1, [r5, #-16]
100070ea:	ed05 9b02 	vstr	d9, [r5, #-8]
100070ee:	ed01 3b04 	vstr	d3, [r1, #-16]
100070f2:	ed01 7b02 	vstr	d7, [r1, #-8]
100070f6:	ed06 5b04 	vstr	d5, [r6, #-16]
100070fa:	ed06 6b02 	vstr	d6, [r6, #-8]
100070fe:	f47f af68 	bne.w	10006fd2 <fndsa_vect_FFT_fp64_exact+0x1b2>
10007102:	9800      	ldr	r0, [sp, #0]
10007104:	9b02      	ldr	r3, [sp, #8]
10007106:	3010      	adds	r0, #16
10007108:	4283      	cmp	r3, r0
1000710a:	4447      	add	r7, r8
1000710c:	eb0a 1a08 	add.w	sl, sl, r8, lsl #4
10007110:	eb09 1908 	add.w	r9, r9, r8, lsl #4
10007114:	f47f aeb5 	bne.w	10006e82 <fndsa_vect_FFT_fp64_exact+0x62>
10007118:	9c03      	ldr	r4, [sp, #12]
1000711a:	9b05      	ldr	r3, [sp, #20]
1000711c:	3401      	adds	r4, #1
1000711e:	42a3      	cmp	r3, r4
10007120:	465a      	mov	r2, fp
10007122:	9801      	ldr	r0, [sp, #4]
10007124:	9f04      	ldr	r7, [sp, #16]
10007126:	f47f ae92 	bne.w	10006e4e <fndsa_vect_FFT_fp64_exact+0x2e>
1000712a:	b02d      	add	sp, #180	@ 0xb4
1000712c:	ecbd 8b10 	vpop	{d8-d15}
10007130:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10007134:	4770      	bx	lr
10007136:	bf00      	nop
10007138:	00000000 	.word	0x00000000
1000713c:	3e700000 	.word	0x3e700000
10007140:	00000000 	.word	0x00000000
10007144:	3df00000 	.word	0x3df00000
10007148:	00000000 	.word	0x00000000
1000714c:	41f00000 	.word	0x41f00000
10007150:	00000000 	.word	0x00000000
10007154:	3ef00000 	.word	0x3ef00000
10007158:	00000000 	.word	0x00000000
1000715c:	41700000 	.word	0x41700000
10007160:	00000000 	.word	0x00000000
10007164:	40f00000 	.word	0x40f00000
10007168:	00000000 	.word	0x00000000
1000716c:	40700000 	.word	0x40700000
10007170:	300039a0 	.word	0x300039a0
