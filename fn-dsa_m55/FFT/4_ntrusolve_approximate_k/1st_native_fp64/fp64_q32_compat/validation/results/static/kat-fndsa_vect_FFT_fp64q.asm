
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_q32_compat/validation/build/kat/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10004d88 <fndsa_vect_FFT_fp64q>:
10004d88:	2801      	cmp	r0, #1
10004d8a:	f240 82d8 	bls.w	1000533e <fndsa_vect_FFT_fp64q+0x5b6>
10004d8e:	2301      	movs	r3, #1
10004d90:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10004d94:	1e42      	subs	r2, r0, #1
10004d96:	ed2d 8b10 	vpush	{d8-d15}
10004d9a:	fa03 f502 	lsl.w	r5, r3, r2
10004d9e:	ed9f fb3a 	vldr	d15, [pc, #232]	@ 10004e88 <fndsa_vect_FFT_fp64q+0x100>
10004da2:	ed9f eb3b 	vldr	d14, [pc, #236]	@ 10004e90 <fndsa_vect_FFT_fp64q+0x108>
10004da6:	469b      	mov	fp, r3
10004da8:	46a9      	mov	r9, r5
10004daa:	b0b9      	sub	sp, #228	@ 0xe4
10004dac:	3908      	subs	r1, #8
10004dae:	9123      	str	r1, [sp, #140]	@ 0x8c
10004db0:	9524      	str	r5, [sp, #144]	@ 0x90
10004db2:	9025      	str	r0, [sp, #148]	@ 0x94
10004db4:	2301      	movs	r3, #1
10004db6:	2210      	movs	r2, #16
10004db8:	46c8      	mov	r8, r9
10004dba:	2700      	movs	r7, #0
10004dbc:	4936      	ldr	r1, [pc, #216]	@ (10004e98 <fndsa_vect_FFT_fp64q+0x110>)
10004dbe:	fa03 f30b 	lsl.w	r3, r3, fp
10004dc2:	eb03 0353 	add.w	r3, r3, r3, lsr #1
10004dc6:	eb01 1303 	add.w	r3, r1, r3, lsl #4
10004dca:	931f      	str	r3, [sp, #124]	@ 0x7c
10004dcc:	9b24      	ldr	r3, [sp, #144]	@ 0x90
10004dce:	ea4f 0959 	mov.w	r9, r9, lsr #1
10004dd2:	eba3 0309 	sub.w	r3, r3, r9
10004dd6:	3301      	adds	r3, #1
10004dd8:	9321      	str	r3, [sp, #132]	@ 0x84
10004dda:	9b23      	ldr	r3, [sp, #140]	@ 0x8c
10004ddc:	fa02 f20b 	lsl.w	r2, r2, fp
10004de0:	ea4f 0ac9 	mov.w	sl, r9, lsl #3
10004de4:	188d      	adds	r5, r1, r2
10004de6:	eb03 0cc9 	add.w	ip, r3, r9, lsl #3
10004dea:	f8cd 9078 	str.w	r9, [sp, #120]	@ 0x78
10004dee:	f8cd b088 	str.w	fp, [sp, #136]	@ 0x88
10004df2:	f8cd a010 	str.w	sl, [sp, #16]
10004df6:	f8cd 8080 	str.w	r8, [sp, #128]	@ 0x80
10004dfa:	9b1e      	ldr	r3, [sp, #120]	@ 0x78
10004dfc:	ac30      	add	r4, sp, #192	@ 0xc0
10004dfe:	eb03 0e07 	add.w	lr, r3, r7
10004e02:	45be      	cmp	lr, r7
10004e04:	e895 000f 	ldmia.w	r5, {r0, r1, r2, r3}
10004e08:	e884 000f 	stmia.w	r4, {r0, r1, r2, r3}
10004e0c:	f240 827f 	bls.w	1000530e <fndsa_vect_FFT_fp64q+0x586>
10004e10:	9a30      	ldr	r2, [sp, #192]	@ 0xc0
10004e12:	9932      	ldr	r1, [sp, #200]	@ 0xc8
10004e14:	ee07 2a90 	vmov	s15, r2
10004e18:	eeb8 ab67 	vcvt.f64.u32	d10, s15
10004e1c:	ee07 1a90 	vmov	s15, r1
10004e20:	9c31      	ldr	r4, [sp, #196]	@ 0xc4
10004e22:	eeb8 bb67 	vcvt.f64.u32	d11, s15
10004e26:	ee07 4a90 	vmov	s15, r4
10004e2a:	9833      	ldr	r0, [sp, #204]	@ 0xcc
10004e2c:	eeb8 9b67 	vcvt.f64.u32	d9, s15
10004e30:	ee07 0a90 	vmov	s15, r0
10004e34:	9215      	str	r2, [sp, #84]	@ 0x54
10004e36:	1852      	adds	r2, r2, r1
10004e38:	eeb8 8b67 	vcvt.f64.u32	d8, s15
10004e3c:	ee07 2a90 	vmov	s15, r2
10004e40:	9219      	str	r2, [sp, #100]	@ 0x64
10004e42:	eb40 0204 	adc.w	r2, r0, r4
10004e46:	eeb8 db67 	vcvt.f64.u32	d13, s15
10004e4a:	ee07 2a90 	vmov	s15, r2
10004e4e:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10004e52:	9b04      	ldr	r3, [sp, #16]
10004e54:	ed8d 7b12 	vstr	d7, [sp, #72]	@ 0x48
10004e58:	f1a3 0e08 	sub.w	lr, r3, #8
10004e5c:	ea4f 0ede 	mov.w	lr, lr, lsr #3
10004e60:	f10e 0e01 	add.w	lr, lr, #1
10004e64:	f04e e001 	dls	lr, lr
10004e68:	ebac 0b03 	sub.w	fp, ip, r3
10004e6c:	e9cd 7c1b 	strd	r7, ip, [sp, #108]	@ 0x6c
10004e70:	9b21      	ldr	r3, [sp, #132]	@ 0x84
10004e72:	9117      	str	r1, [sp, #92]	@ 0x5c
10004e74:	9416      	str	r4, [sp, #88]	@ 0x58
10004e76:	9018      	str	r0, [sp, #96]	@ 0x60
10004e78:	921a      	str	r2, [sp, #104]	@ 0x68
10004e7a:	951d      	str	r5, [sp, #116]	@ 0x74
10004e7c:	eb0c 0ac3 	add.w	sl, ip, r3, lsl #3
10004e80:	e00c      	b.n	10004e9c <fndsa_vect_FFT_fp64q+0x114>
10004e82:	bf00      	nop
10004e84:	f3af 8000 	nop.w
10004e88:	00000000 	.word	0x00000000
10004e8c:	3df00000 	.word	0x3df00000
10004e90:	00000000 	.word	0x00000000
10004e94:	41f00000 	.word	0x41f00000
10004e98:	300039a0 	.word	0x300039a0
10004e9c:	f85b 3f08 	ldr.w	r3, [fp, #8]!
10004ea0:	9a04      	ldr	r2, [sp, #16]
10004ea2:	930b      	str	r3, [sp, #44]	@ 0x2c
10004ea4:	eb0b 0002 	add.w	r0, fp, r2
10004ea8:	6803      	ldr	r3, [r0, #0]
10004eaa:	6847      	ldr	r7, [r0, #4]
10004eac:	4699      	mov	r9, r3
10004eae:	ee07 9a90 	vmov	s15, r9
10004eb2:	eeb8 4b67 	vcvt.f64.u32	d4, s15
10004eb6:	ee07 7a90 	vmov	s15, r7
10004eba:	eb0a 0102 	add.w	r1, sl, r2
10004ebe:	9334      	str	r3, [sp, #208]	@ 0xd0
10004ec0:	680b      	ldr	r3, [r1, #0]
10004ec2:	eeb8 0b67 	vcvt.f64.u32	d0, s15
10004ec6:	ee07 3a90 	vmov	s15, r3
10004eca:	684e      	ldr	r6, [r1, #4]
10004ecc:	ee2a 1b04 	vmul.f64	d1, d10, d4
10004ed0:	eeb8 5b67 	vcvt.f64.u32	d5, s15
10004ed4:	ee07 6a90 	vmov	s15, r6
10004ed8:	eeb8 3b67 	vcvt.f64.u32	d3, s15
10004edc:	ee21 7b0f 	vmul.f64	d7, d1, d15
10004ee0:	eefc 2bc7 	vcvt.u32.f64	s5, d7
10004ee4:	ee2b cb05 	vmul.f64	d12, d11, d5
10004ee8:	ee28 7b05 	vmul.f64	d7, d8, d5
10004eec:	eeb8 5b62 	vcvt.f64.u32	d5, s5
10004ef0:	ee20 0b0a 	vmul.f64	d0, d0, d10
10004ef4:	ee29 6b04 	vmul.f64	d6, d9, d4
10004ef8:	ed8d 7b0c 	vstr	d7, [sp, #48]	@ 0x30
10004efc:	ee25 7b0e 	vmul.f64	d7, d5, d14
10004f00:	ee20 4b0f 	vmul.f64	d4, d0, d15
10004f04:	eeb0 5b47 	vmov.f64	d5, d7
10004f08:	ed8d 6b02 	vstr	d6, [sp, #8]
10004f0c:	ee2c 7b0f 	vmul.f64	d7, d12, d15
10004f10:	ee26 6b0f 	vmul.f64	d6, d6, d15
10004f14:	4698      	mov	r8, r3
10004f16:	eefc 6bc6 	vcvt.u32.f64	s13, d6
10004f1a:	eebc 6bc4 	vcvt.u32.f64	s12, d4
10004f1e:	eefc 4bc7 	vcvt.u32.f64	s9, d7
10004f22:	9c16      	ldr	r4, [sp, #88]	@ 0x58
10004f24:	9007      	str	r0, [sp, #28]
10004f26:	fb09 f004 	mul.w	r0, r9, r4
10004f2a:	9601      	str	r6, [sp, #4]
10004f2c:	9106      	str	r1, [sp, #24]
10004f2e:	9008      	str	r0, [sp, #32]
10004f30:	9901      	ldr	r1, [sp, #4]
10004f32:	9817      	ldr	r0, [sp, #92]	@ 0x5c
10004f34:	9637      	str	r6, [sp, #220]	@ 0xdc
10004f36:	fb01 f100 	mul.w	r1, r1, r0
10004f3a:	fb08 f500 	mul.w	r5, r8, r0
10004f3e:	fb07 f604 	mul.w	r6, r7, r4
10004f42:	910f      	str	r1, [sp, #60]	@ 0x3c
10004f44:	9918      	ldr	r1, [sp, #96]	@ 0x60
10004f46:	9510      	str	r5, [sp, #64]	@ 0x40
10004f48:	fb08 f501 	mul.w	r5, r8, r1
10004f4c:	ea09 74e4 	and.w	r4, r9, r4, asr #31
10004f50:	1b34      	subs	r4, r6, r4
10004f52:	9e01      	ldr	r6, [sp, #4]
10004f54:	950e      	str	r5, [sp, #56]	@ 0x38
10004f56:	fb06 f501 	mul.w	r5, r6, r1
10004f5a:	9336      	str	r3, [sp, #216]	@ 0xd8
10004f5c:	9b15      	ldr	r3, [sp, #84]	@ 0x54
10004f5e:	9511      	str	r5, [sp, #68]	@ 0x44
10004f60:	ea03 75e7 	and.w	r5, r3, r7, asr #31
10004f64:	fb07 f203 	mul.w	r2, r7, r3
10004f68:	fb09 fc03 	mul.w	ip, r9, r3
10004f6c:	1b63      	subs	r3, r4, r5
10004f6e:	ea08 75e1 	and.w	r5, r8, r1, asr #31
10004f72:	ea00 74e6 	and.w	r4, r0, r6, asr #31
10004f76:	192c      	adds	r4, r5, r4
10004f78:	f8da 0000 	ldr.w	r0, [sl]
10004f7c:	9405      	str	r4, [sp, #20]
10004f7e:	f8db 4004 	ldr.w	r4, [fp, #4]
10004f82:	9735      	str	r7, [sp, #212]	@ 0xd4
10004f84:	9414      	str	r4, [sp, #80]	@ 0x50
10004f86:	9009      	str	r0, [sp, #36]	@ 0x24
10004f88:	f8da 5004 	ldr.w	r5, [sl, #4]
10004f8c:	ee11 0a10 	vmov	r0, s2
10004f90:	ee15 1a10 	vmov	r1, s10
10004f94:	950a      	str	r5, [sp, #40]	@ 0x28
10004f96:	ee15 5a90 	vmov	r5, s11
10004f9a:	eeb8 5b64 	vcvt.f64.u32	d5, s9
10004f9e:	ea81 0400 	eor.w	r4, r1, r0
10004fa2:	ee25 7b0e 	vmul.f64	d7, d5, d14
10004fa6:	ee11 0a90 	vmov	r0, s3
10004faa:	eeb0 5b47 	vmov.f64	d5, d7
10004fae:	4045      	eors	r5, r0
10004fb0:	ee12 0a90 	vmov	r0, s5
10004fb4:	4325      	orrs	r5, r4
10004fb6:	426c      	negs	r4, r5
10004fb8:	432c      	orrs	r4, r5
10004fba:	0fe4      	lsrs	r4, r4, #31
10004fbc:	9429      	str	r4, [sp, #164]	@ 0xa4
10004fbe:	9c29      	ldr	r4, [sp, #164]	@ 0xa4
10004fc0:	ee15 1a10 	vmov	r1, s10
10004fc4:	f084 0401 	eor.w	r4, r4, #1
10004fc8:	ea04 74dc 	and.w	r4, r4, ip, lsr #31
10004fcc:	1b04      	subs	r4, r0, r4
10004fce:	ee1c 0a10 	vmov	r0, s24
10004fd2:	ee23 3b0b 	vmul.f64	d3, d3, d11
10004fd6:	eb14 0c02 	adds.w	ip, r4, r2
10004fda:	ea81 0400 	eor.w	r4, r1, r0
10004fde:	ee1c 0a90 	vmov	r0, s25
10004fe2:	ed9d cb0c 	vldr	d12, [sp, #48]	@ 0x30
10004fe6:	ee23 7b0f 	vmul.f64	d7, d3, d15
10004fea:	ee15 5a90 	vmov	r5, s11
10004fee:	ee2c 5b0f 	vmul.f64	d5, d12, d15
10004ff2:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10004ff6:	eefc 7bc5 	vcvt.u32.f64	s15, d5
10004ffa:	eeb8 5b67 	vcvt.f64.u32	d5, s15
10004ffe:	ee25 2b0e 	vmul.f64	d2, d5, d14
10005002:	ee1c 1a10 	vmov	r1, s24
10005006:	ea85 0500 	eor.w	r5, r5, r0
1000500a:	ee12 0a10 	vmov	r0, s4
1000500e:	eeb8 5b46 	vcvt.f64.u32	d5, s12
10005012:	ea45 0504 	orr.w	r5, r5, r4
10005016:	f1c5 0400 	rsb	r4, r5, #0
1000501a:	ea80 0001 	eor.w	r0, r0, r1
1000501e:	ea44 0405 	orr.w	r4, r4, r5
10005022:	ee12 1a90 	vmov	r1, s5
10005026:	ee1c 5a90 	vmov	r5, s25
1000502a:	ee25 1b0e 	vmul.f64	d1, d5, d14
1000502e:	ea81 0105 	eor.w	r1, r1, r5
10005032:	ea41 0100 	orr.w	r1, r1, r0
10005036:	f1c1 0000 	rsb	r0, r1, #0
1000503a:	ee11 6a10 	vmov	r6, s2
1000503e:	ea40 0001 	orr.w	r0, r0, r1
10005042:	ee10 1a10 	vmov	r1, s0
10005046:	ee11 5a90 	vmov	r5, s3
1000504a:	ea86 0101 	eor.w	r1, r6, r1
1000504e:	ee10 6a90 	vmov	r6, s1
10005052:	eeb8 5b66 	vcvt.f64.u32	d5, s13
10005056:	ea85 0506 	eor.w	r5, r5, r6
1000505a:	ee16 6a10 	vmov	r6, s12
1000505e:	ed9d 1b02 	vldr	d1, [sp, #8]
10005062:	ee25 2b0e 	vmul.f64	d2, d5, d14
10005066:	ea45 0501 	orr.w	r5, r5, r1
1000506a:	f1c5 0100 	rsb	r1, r5, #0
1000506e:	ea41 0105 	orr.w	r1, r1, r5
10005072:	ea4f 71d1 	mov.w	r1, r1, lsr #31
10005076:	9128      	str	r1, [sp, #160]	@ 0xa0
10005078:	9d28      	ldr	r5, [sp, #160]	@ 0xa0
1000507a:	eeb8 5b47 	vcvt.f64.u32	d5, s14
1000507e:	f085 0501 	eor.w	r5, r5, #1
10005082:	ea05 75d2 	and.w	r5, r5, r2, lsr #31
10005086:	eba6 0505 	sub.w	r5, r6, r5
1000508a:	eb45 0503 	adc.w	r5, r5, r3
1000508e:	9b08      	ldr	r3, [sp, #32]
10005090:	ee11 6a10 	vmov	r6, s2
10005094:	eb1c 0c03 	adds.w	ip, ip, r3
10005098:	ee12 3a10 	vmov	r3, s4
1000509c:	ea83 0206 	eor.w	r2, r3, r6
100050a0:	ee11 6a90 	vmov	r6, s3
100050a4:	ee12 3a90 	vmov	r3, s5
100050a8:	ea83 0306 	eor.w	r3, r3, r6
100050ac:	ee16 6a90 	vmov	r6, s13
100050b0:	ea42 0203 	orr.w	r2, r2, r3
100050b4:	f1c2 0300 	rsb	r3, r2, #0
100050b8:	ea43 0302 	orr.w	r3, r3, r2
100050bc:	ea4f 73d3 	mov.w	r3, r3, lsr #31
100050c0:	9327      	str	r3, [sp, #156]	@ 0x9c
100050c2:	9927      	ldr	r1, [sp, #156]	@ 0x9c
100050c4:	9b08      	ldr	r3, [sp, #32]
100050c6:	f081 0101 	eor.w	r1, r1, #1
100050ca:	ea01 71d3 	and.w	r1, r1, r3, lsr #31
100050ce:	ee25 5b0e 	vmul.f64	d5, d5, d14
100050d2:	eba6 0101 	sub.w	r1, r6, r1
100050d6:	ee14 6a90 	vmov	r6, s9
100050da:	ea4f 74d4 	mov.w	r4, r4, lsr #31
100050de:	942c      	str	r4, [sp, #176]	@ 0xb0
100050e0:	9b2c      	ldr	r3, [sp, #176]	@ 0xb0
100050e2:	9a10      	ldr	r2, [sp, #64]	@ 0x40
100050e4:	9c05      	ldr	r4, [sp, #20]
100050e6:	eb41 0105 	adc.w	r1, r1, r5
100050ea:	f083 0301 	eor.w	r3, r3, #1
100050ee:	ea03 73d2 	and.w	r3, r3, r2, lsr #31
100050f2:	190a      	adds	r2, r1, r4
100050f4:	1af3      	subs	r3, r6, r3
100050f6:	9208      	str	r2, [sp, #32]
100050f8:	ee15 6a10 	vmov	r6, s10
100050fc:	ee13 2a10 	vmov	r2, s6
10005100:	ee15 4a90 	vmov	r4, s11
10005104:	4072      	eors	r2, r6
10005106:	ee13 6a90 	vmov	r6, s7
1000510a:	4074      	eors	r4, r6
1000510c:	ee17 6a10 	vmov	r6, s14
10005110:	4314      	orrs	r4, r2
10005112:	4262      	negs	r2, r4
10005114:	4322      	orrs	r2, r4
10005116:	0fd2      	lsrs	r2, r2, #31
10005118:	922b      	str	r2, [sp, #172]	@ 0xac
1000511a:	9a2b      	ldr	r2, [sp, #172]	@ 0xac
1000511c:	9d0f      	ldr	r5, [sp, #60]	@ 0x3c
1000511e:	f082 0201 	eor.w	r2, r2, #1
10005122:	ea02 72d5 	and.w	r2, r2, r5, lsr #31
10005126:	1ab2      	subs	r2, r6, r2
10005128:	ee17 6a90 	vmov	r6, s15
1000512c:	0fc0      	lsrs	r0, r0, #31
1000512e:	195b      	adds	r3, r3, r5
10005130:	902a      	str	r0, [sp, #168]	@ 0xa8
10005132:	9d11      	ldr	r5, [sp, #68]	@ 0x44
10005134:	9c2a      	ldr	r4, [sp, #168]	@ 0xa8
10005136:	eb45 0202 	adc.w	r2, r5, r2
1000513a:	9d0e      	ldr	r5, [sp, #56]	@ 0x38
1000513c:	f084 0401 	eor.w	r4, r4, #1
10005140:	ea04 74d5 	and.w	r4, r4, r5, lsr #31
10005144:	195b      	adds	r3, r3, r5
10005146:	eba6 0404 	sub.w	r4, r6, r4
1000514a:	eb44 0502 	adc.w	r5, r4, r2
1000514e:	eb13 000c 	adds.w	r0, r3, ip
10005152:	eb45 0101 	adc.w	r1, r5, r1
10005156:	9502      	str	r5, [sp, #8]
10005158:	eb18 0509 	adds.w	r5, r8, r9
1000515c:	ee07 5a90 	vmov	s15, r5
10005160:	eeb8 5b67 	vcvt.f64.u32	d5, s15
10005164:	9e01      	ldr	r6, [sp, #4]
10005166:	ee2d 3b05 	vmul.f64	d3, d13, d5
1000516a:	eb47 0206 	adc.w	r2, r7, r6
1000516e:	ee07 2a90 	vmov	s15, r2
10005172:	ee23 2b0f 	vmul.f64	d2, d3, d15
10005176:	eeb8 4b67 	vcvt.f64.u32	d4, s15
1000517a:	eebc 2bc2 	vcvt.u32.f64	s4, d2
1000517e:	ee24 4b0d 	vmul.f64	d4, d4, d13
10005182:	9f19      	ldr	r7, [sp, #100]	@ 0x64
10005184:	ee24 6b0f 	vmul.f64	d6, d4, d15
10005188:	fb05 f607 	mul.w	r6, r5, r7
1000518c:	960c      	str	r6, [sp, #48]	@ 0x30
1000518e:	9e1a      	ldr	r6, [sp, #104]	@ 0x68
10005190:	eeb8 0b42 	vcvt.f64.u32	d0, s4
10005194:	fb05 f406 	mul.w	r4, r5, r6
10005198:	fb02 f906 	mul.w	r9, r2, r6
1000519c:	ea05 75e6 	and.w	r5, r5, r6, asr #31
100051a0:	9e05      	ldr	r6, [sp, #20]
100051a2:	fb02 f807 	mul.w	r8, r2, r7
100051a6:	ea07 72e2 	and.w	r2, r7, r2, asr #31
100051aa:	4415      	add	r5, r2
100051ac:	1b8e      	subs	r6, r1, r6
100051ae:	9501      	str	r5, [sp, #4]
100051b0:	960e      	str	r6, [sp, #56]	@ 0x38
100051b2:	ed9d 7b12 	vldr	d7, [sp, #72]	@ 0x48
100051b6:	eefc 2bc6 	vcvt.u32.f64	s5, d6
100051ba:	ee20 1b0e 	vmul.f64	d1, d0, d14
100051be:	ee27 5b05 	vmul.f64	d5, d7, d5
100051c2:	ec57 6b11 	vmov	r6, r7, d1
100051c6:	ee13 5a10 	vmov	r5, s6
100051ca:	eeb8 6b62 	vcvt.f64.u32	d6, s5
100051ce:	ee25 cb0f 	vmul.f64	d12, d5, d15
100051d2:	ea86 0205 	eor.w	r2, r6, r5
100051d6:	ee26 6b0e 	vmul.f64	d6, d6, d14
100051da:	ee13 5a90 	vmov	r5, s7
100051de:	eebc cbcc 	vcvt.u32.f64	s24, d12
100051e2:	ee14 6a10 	vmov	r6, s8
100051e6:	406f      	eors	r7, r5
100051e8:	ee16 5a10 	vmov	r5, s12
100051ec:	eeb8 7b4c 	vcvt.f64.u32	d7, s24
100051f0:	4317      	orrs	r7, r2
100051f2:	ea85 0206 	eor.w	r2, r5, r6
100051f6:	ee14 5a90 	vmov	r5, s9
100051fa:	ee16 6a90 	vmov	r6, s13
100051fe:	ee27 7b0e 	vmul.f64	d7, d7, d14
10005202:	406e      	eors	r6, r5
10005204:	4316      	orrs	r6, r2
10005206:	427a      	negs	r2, r7
10005208:	433a      	orrs	r2, r7
1000520a:	0fd2      	lsrs	r2, r2, #31
1000520c:	922f      	str	r2, [sp, #188]	@ 0xbc
1000520e:	ee17 5a10 	vmov	r5, s14
10005212:	ee15 2a10 	vmov	r2, s10
10005216:	ea85 0702 	eor.w	r7, r5, r2
1000521a:	ee15 5a90 	vmov	r5, s11
1000521e:	ee17 2a90 	vmov	r2, s15
10005222:	406a      	eors	r2, r5
10005224:	ee12 5a10 	vmov	r5, s4
10005228:	433a      	orrs	r2, r7
1000522a:	4277      	negs	r7, r6
1000522c:	4337      	orrs	r7, r6
1000522e:	4256      	negs	r6, r2
10005230:	0fff      	lsrs	r7, r7, #31
10005232:	4316      	orrs	r6, r2
10005234:	9a2f      	ldr	r2, [sp, #188]	@ 0xbc
10005236:	972e      	str	r7, [sp, #184]	@ 0xb8
10005238:	9f0c      	ldr	r7, [sp, #48]	@ 0x30
1000523a:	f082 0201 	eor.w	r2, r2, #1
1000523e:	ea02 72d7 	and.w	r2, r2, r7, lsr #31
10005242:	1aaa      	subs	r2, r5, r2
10005244:	ee12 5a90 	vmov	r5, s5
10005248:	9f2e      	ldr	r7, [sp, #184]	@ 0xb8
1000524a:	0ff6      	lsrs	r6, r6, #31
1000524c:	f087 0701 	eor.w	r7, r7, #1
10005250:	ea07 77d8 	and.w	r7, r7, r8, lsr #31
10005254:	1bef      	subs	r7, r5, r7
10005256:	ee1c 5a10 	vmov	r5, s24
1000525a:	962d      	str	r6, [sp, #180]	@ 0xb4
1000525c:	9e2d      	ldr	r6, [sp, #180]	@ 0xb4
1000525e:	eb12 0208 	adds.w	r2, r2, r8
10005262:	f086 0601 	eor.w	r6, r6, #1
10005266:	ea06 76d4 	and.w	r6, r6, r4, lsr #31
1000526a:	eb49 0707 	adc.w	r7, r9, r7
1000526e:	1bae      	subs	r6, r5, r6
10005270:	1912      	adds	r2, r2, r4
10005272:	eb46 0607 	adc.w	r6, r6, r7
10005276:	9c08      	ldr	r4, [sp, #32]
10005278:	9d02      	ldr	r5, [sp, #8]
1000527a:	f11c 0c00 	adds.w	ip, ip, #0
1000527e:	ebbc 0703 	subs.w	r7, ip, r3
10005282:	eb64 0805 	sbc.w	r8, r4, r5
10005286:	9c0b      	ldr	r4, [sp, #44]	@ 0x2c
10005288:	9d14      	ldr	r5, [sp, #80]	@ 0x50
1000528a:	193f      	adds	r7, r7, r4
1000528c:	f8cb 7000 	str.w	r7, [fp]
10005290:	9c05      	ldr	r4, [sp, #20]
10005292:	eb45 0708 	adc.w	r7, r5, r8
10005296:	f8cb 7004 	str.w	r7, [fp, #4]
1000529a:	4247      	negs	r7, r0
1000529c:	eb64 0101 	sbc.w	r1, r4, r1
100052a0:	9c01      	ldr	r4, [sp, #4]
100052a2:	19d7      	adds	r7, r2, r7
100052a4:	eba6 0804 	sub.w	r8, r6, r4
100052a8:	9c09      	ldr	r4, [sp, #36]	@ 0x24
100052aa:	eb48 0801 	adc.w	r8, r8, r1
100052ae:	193f      	adds	r7, r7, r4
100052b0:	f8ca 7000 	str.w	r7, [sl]
100052b4:	9f0a      	ldr	r7, [sp, #40]	@ 0x28
100052b6:	9c08      	ldr	r4, [sp, #32]
100052b8:	eb47 0108 	adc.w	r1, r7, r8
100052bc:	9f02      	ldr	r7, [sp, #8]
100052be:	ebb3 030c 	subs.w	r3, r3, ip
100052c2:	eb67 0404 	sbc.w	r4, r7, r4
100052c6:	9f0b      	ldr	r7, [sp, #44]	@ 0x2c
100052c8:	f8ca 1004 	str.w	r1, [sl, #4]
100052cc:	19db      	adds	r3, r3, r7
100052ce:	9f0e      	ldr	r7, [sp, #56]	@ 0x38
100052d0:	eb45 0404 	adc.w	r4, r5, r4
100052d4:	9d01      	ldr	r5, [sp, #4]
100052d6:	1a80      	subs	r0, r0, r2
100052d8:	eb67 0206 	sbc.w	r2, r7, r6
100052dc:	4415      	add	r5, r2
100052de:	9a04      	ldr	r2, [sp, #16]
100052e0:	3000      	adds	r0, #0
100052e2:	f84b 3002 	str.w	r3, [fp, r2]
100052e6:	9b07      	ldr	r3, [sp, #28]
100052e8:	9f0a      	ldr	r7, [sp, #40]	@ 0x28
100052ea:	605c      	str	r4, [r3, #4]
100052ec:	9c09      	ldr	r4, [sp, #36]	@ 0x24
100052ee:	1900      	adds	r0, r0, r4
100052f0:	f84a 0002 	str.w	r0, [sl, r2]
100052f4:	9906      	ldr	r1, [sp, #24]
100052f6:	eb47 0505 	adc.w	r5, r7, r5
100052fa:	604d      	str	r5, [r1, #4]
100052fc:	f10a 0a08 	add.w	sl, sl, #8
10005300:	f1be 0e01 	subs.w	lr, lr, #1
10005304:	f47f adca 	bne.w	10004e9c <fndsa_vect_FFT_fp64q+0x114>
10005308:	e9dd 7c1b 	ldrd	r7, ip, [sp, #108]	@ 0x6c
1000530c:	9d1d      	ldr	r5, [sp, #116]	@ 0x74
1000530e:	9b20      	ldr	r3, [sp, #128]	@ 0x80
10005310:	3510      	adds	r5, #16
10005312:	441f      	add	r7, r3
10005314:	eb0c 0cc3 	add.w	ip, ip, r3, lsl #3
10005318:	9b1f      	ldr	r3, [sp, #124]	@ 0x7c
1000531a:	42ab      	cmp	r3, r5
1000531c:	f47f ad6d 	bne.w	10004dfa <fndsa_vect_FFT_fp64q+0x72>
10005320:	f8dd b088 	ldr.w	fp, [sp, #136]	@ 0x88
10005324:	9b25      	ldr	r3, [sp, #148]	@ 0x94
10005326:	f10b 0b01 	add.w	fp, fp, #1
1000532a:	455b      	cmp	r3, fp
1000532c:	f8dd 9078 	ldr.w	r9, [sp, #120]	@ 0x78
10005330:	f47f ad40 	bne.w	10004db4 <fndsa_vect_FFT_fp64q+0x2c>
10005334:	b039      	add	sp, #228	@ 0xe4
10005336:	ecbd 8b10 	vpop	{d8-d15}
1000533a:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
1000533e:	4770      	bx	lr
