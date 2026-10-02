
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_q32_compat/validation/build/kernels/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10000bf0 <fndsa_vect_iFFT_fp64q>:
10000bf0:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10000bf4:	ed2d 8b10 	vpush	{d8-d15}
10000bf8:	1e44      	subs	r4, r0, #1
10000bfa:	b0bd      	sub	sp, #244	@ 0xf4
10000bfc:	f000 82d4 	beq.w	100011a8 <fndsa_vect_iFFT_fp64q+0x5b8>
10000c00:	2301      	movs	r3, #1
10000c02:	ed9f 6b3b 	vldr	d6, [pc, #236]	@ 10000cf0 <fndsa_vect_iFFT_fp64q+0x100>
10000c06:	ed9f 7b3c 	vldr	d7, [pc, #240]	@ 10000cf8 <fndsa_vect_iFFT_fp64q+0x108>
10000c0a:	4625      	mov	r5, r4
10000c0c:	f1a1 0808 	sub.w	r8, r1, #8
10000c10:	fa03 f904 	lsl.w	r9, r3, r4
10000c14:	9321      	str	r3, [sp, #132]	@ 0x84
10000c16:	f8cd 90a0 	str.w	r9, [sp, #160]	@ 0xa0
10000c1a:	f8cd 80a4 	str.w	r8, [sp, #164]	@ 0xa4
10000c1e:	9b21      	ldr	r3, [sp, #132]	@ 0x84
10000c20:	4937      	ldr	r1, [pc, #220]	@ (10000d00 <fndsa_vect_iFFT_fp64q+0x110>)
10000c22:	4618      	mov	r0, r3
10000c24:	005a      	lsls	r2, r3, #1
10000c26:	2301      	movs	r3, #1
10000c28:	40ab      	lsls	r3, r5
10000c2a:	eb03 0353 	add.w	r3, r3, r3, lsr #1
10000c2e:	eb01 1303 	add.w	r3, r1, r3, lsl #4
10000c32:	9322      	str	r3, [sp, #136]	@ 0x88
10000c34:	2310      	movs	r3, #16
10000c36:	f04f 0c00 	mov.w	ip, #0
10000c3a:	40ab      	lsls	r3, r5
10000c3c:	18cf      	adds	r7, r1, r3
10000c3e:	00d3      	lsls	r3, r2, #3
10000c40:	9323      	str	r3, [sp, #140]	@ 0x8c
10000c42:	9b28      	ldr	r3, [sp, #160]	@ 0xa0
10000c44:	ea4f 0ac0 	mov.w	sl, r0, lsl #3
10000c48:	1a1b      	subs	r3, r3, r0
10000c4a:	3301      	adds	r3, #1
10000c4c:	9325      	str	r3, [sp, #148]	@ 0x94
10000c4e:	9b29      	ldr	r3, [sp, #164]	@ 0xa4
10000c50:	9221      	str	r2, [sp, #132]	@ 0x84
10000c52:	eb03 0bc0 	add.w	fp, r3, r0, lsl #3
10000c56:	9527      	str	r5, [sp, #156]	@ 0x9c
10000c58:	9024      	str	r0, [sp, #144]	@ 0x90
10000c5a:	f8cd a098 	str.w	sl, [sp, #152]	@ 0x98
10000c5e:	9b24      	ldr	r3, [sp, #144]	@ 0x90
10000c60:	ac38      	add	r4, sp, #224	@ 0xe0
10000c62:	eb0c 0603 	add.w	r6, ip, r3
10000c66:	e897 000f 	ldmia.w	r7, {r0, r1, r2, r3}
10000c6a:	e884 000f 	stmia.w	r4, {r0, r1, r2, r3}
10000c6e:	45b4      	cmp	ip, r6
10000c70:	e9dd 0138 	ldrd	r0, r1, [sp, #224]	@ 0xe0
10000c74:	e9cd 0134 	strd	r0, r1, [sp, #208]	@ 0xd0
10000c78:	f080 8289 	bcs.w	1000118e <fndsa_vect_iFFT_fp64q+0x59e>
10000c7c:	9c34      	ldr	r4, [sp, #208]	@ 0xd0
10000c7e:	4251      	negs	r1, r2
10000c80:	ee05 4a90 	vmov	s11, r4
10000c84:	eeb8 0b65 	vcvt.f64.u32	d0, s11
10000c88:	ee05 1a90 	vmov	s11, r1
10000c8c:	9d35      	ldr	r5, [sp, #212]	@ 0xd4
10000c8e:	eeb8 1b65 	vcvt.f64.u32	d1, s11
10000c92:	ee05 5a90 	vmov	s11, r5
10000c96:	eb63 0043 	sbc.w	r0, r3, r3, lsl #1
10000c9a:	eeb8 8b65 	vcvt.f64.u32	d8, s11
10000c9e:	ee05 0a90 	vmov	s11, r0
10000ca2:	1aa2      	subs	r2, r4, r2
10000ca4:	eeb8 cb65 	vcvt.f64.u32	d12, s11
10000ca8:	ee05 2a90 	vmov	s11, r2
10000cac:	eb65 0303 	sbc.w	r3, r5, r3
10000cb0:	eeb8 2b65 	vcvt.f64.u32	d2, s11
10000cb4:	ee05 3a90 	vmov	s11, r3
10000cb8:	9118      	str	r1, [sp, #96]	@ 0x60
10000cba:	9926      	ldr	r1, [sp, #152]	@ 0x98
10000cbc:	eeb8 db65 	vcvt.f64.u32	d13, s11
10000cc0:	f1a1 0e08 	sub.w	lr, r1, #8
10000cc4:	ea4f 0ede 	mov.w	lr, lr, lsr #3
10000cc8:	f10e 0e01 	add.w	lr, lr, #1
10000ccc:	f04e e001 	dls	lr, lr
10000cd0:	931d      	str	r3, [sp, #116]	@ 0x74
10000cd2:	e9cd cb1e 	strd	ip, fp, [sp, #120]	@ 0x78
10000cd6:	9b25      	ldr	r3, [sp, #148]	@ 0x94
10000cd8:	941a      	str	r4, [sp, #104]	@ 0x68
10000cda:	951b      	str	r5, [sp, #108]	@ 0x6c
10000cdc:	901c      	str	r0, [sp, #112]	@ 0x70
10000cde:	9219      	str	r2, [sp, #100]	@ 0x64
10000ce0:	eb0b 08c3 	add.w	r8, fp, r3, lsl #3
10000ce4:	9720      	str	r7, [sp, #128]	@ 0x80
10000ce6:	9108      	str	r1, [sp, #32]
10000ce8:	ebab 0a01 	sub.w	sl, fp, r1
10000cec:	e00a      	b.n	10000d04 <fndsa_vect_iFFT_fp64q+0x114>
10000cee:	bf00      	nop
10000cf0:	00000000 	.word	0x00000000
10000cf4:	3df00000 	.word	0x3df00000
10000cf8:	00000000 	.word	0x00000000
10000cfc:	41f00000 	.word	0x41f00000
10000d00:	300009a0 	.word	0x300009a0
10000d04:	f8da 3008 	ldr.w	r3, [sl, #8]
10000d08:	9d08      	ldr	r5, [sp, #32]
10000d0a:	1c59      	adds	r1, r3, #1
10000d0c:	f8da 200c 	ldr.w	r2, [sl, #12]
10000d10:	f8d8 3000 	ldr.w	r3, [r8]
10000d14:	f10a 0a08 	add.w	sl, sl, #8
10000d18:	f85a 4005 	ldr.w	r4, [sl, r5]
10000d1c:	f142 0200 	adc.w	r2, r2, #0
10000d20:	1c58      	adds	r0, r3, #1
10000d22:	f8d8 3004 	ldr.w	r3, [r8, #4]
10000d26:	9215      	str	r2, [sp, #84]	@ 0x54
10000d28:	f143 0300 	adc.w	r3, r3, #0
10000d2c:	1b0c      	subs	r4, r1, r4
10000d2e:	9406      	str	r4, [sp, #24]
10000d30:	eb0a 0405 	add.w	r4, sl, r5
10000d34:	6866      	ldr	r6, [r4, #4]
10000d36:	9114      	str	r1, [sp, #80]	@ 0x50
10000d38:	eb62 0206 	sbc.w	r2, r2, r6
10000d3c:	9207      	str	r2, [sp, #28]
10000d3e:	f858 2005 	ldr.w	r2, [r8, r5]
10000d42:	9016      	str	r0, [sp, #88]	@ 0x58
10000d44:	1a82      	subs	r2, r0, r2
10000d46:	9204      	str	r2, [sp, #16]
10000d48:	eb08 0205 	add.w	r2, r8, r5
10000d4c:	6851      	ldr	r1, [r2, #4]
10000d4e:	9317      	str	r3, [sp, #92]	@ 0x5c
10000d50:	eb63 0001 	sbc.w	r0, r3, r1
10000d54:	9b1a      	ldr	r3, [sp, #104]	@ 0x68
10000d56:	940e      	str	r4, [sp, #56]	@ 0x38
10000d58:	9209      	str	r2, [sp, #36]	@ 0x24
10000d5a:	e9dd 4506 	ldrd	r4, r5, [sp, #24]
10000d5e:	ea03 72e5 	and.w	r2, r3, r5, asr #31
10000d62:	ea54 056f 	asrl	r4, r5, #1
10000d66:	ee05 4a90 	vmov	s11, r4
10000d6a:	eeb8 fb65 	vcvt.f64.u32	d15, s11
10000d6e:	ee05 5a90 	vmov	s11, r5
10000d72:	ee20 ab0f 	vmul.f64	d10, d0, d15
10000d76:	eeb8 eb65 	vcvt.f64.u32	d14, s11
10000d7a:	ee2a bb06 	vmul.f64	d11, d10, d6
10000d7e:	ee2e eb00 	vmul.f64	d14, d14, d0
10000d82:	462f      	mov	r7, r5
10000d84:	ee2e 4b06 	vmul.f64	d4, d14, d6
10000d88:	eebc bbcb 	vcvt.u32.f64	s22, d11
10000d8c:	9005      	str	r0, [sp, #20]
10000d8e:	9610      	str	r6, [sp, #64]	@ 0x40
10000d90:	4626      	mov	r6, r4
10000d92:	9805      	ldr	r0, [sp, #20]
10000d94:	910f      	str	r1, [sp, #60]	@ 0x3c
10000d96:	9918      	ldr	r1, [sp, #96]	@ 0x60
10000d98:	eefc 9bc4 	vcvt.u32.f64	s19, d4
10000d9c:	ea01 70e0 	and.w	r0, r1, r0, asr #31
10000da0:	fb03 f104 	mul.w	r1, r3, r4
10000da4:	9c1b      	ldr	r4, [sp, #108]	@ 0x6c
10000da6:	eeb8 3b4b 	vcvt.f64.u32	d3, s22
10000daa:	9013      	str	r0, [sp, #76]	@ 0x4c
10000dac:	fb03 f007 	mul.w	r0, r3, r7
10000db0:	4623      	mov	r3, r4
10000db2:	ee28 fb0f 	vmul.f64	d15, d8, d15
10000db6:	e9cd 6702 	strd	r6, r7, [sp, #8]
10000dba:	fb04 f506 	mul.w	r5, r4, r6
10000dbe:	9e03      	ldr	r6, [sp, #12]
10000dc0:	ee23 3b07 	vmul.f64	d3, d3, d7
10000dc4:	fb04 f406 	mul.w	r4, r4, r6
10000dc8:	9e02      	ldr	r6, [sp, #8]
10000dca:	eeb8 4b69 	vcvt.f64.u32	d4, s19
10000dce:	ea06 73e3 	and.w	r3, r6, r3, asr #31
10000dd2:	e9dd 6704 	ldrd	r6, r7, [sp, #16]
10000dd6:	ea56 076f 	asrl	r6, r7, #1
10000dda:	ee2f 5b06 	vmul.f64	d5, d15, d6
10000dde:	ee24 4b07 	vmul.f64	d4, d4, d7
10000de2:	ee1a ca10 	vmov	ip, s20
10000de6:	e9cd 6700 	strd	r6, r7, [sp]
10000dea:	ee13 7a10 	vmov	r7, s6
10000dee:	eebc 9bc5 	vcvt.u32.f64	s18, d5
10000df2:	4413      	add	r3, r2
10000df4:	ee1a 6a90 	vmov	r6, s21
10000df8:	1ae4      	subs	r4, r4, r3
10000dfa:	ee13 3a90 	vmov	r3, s7
10000dfe:	ea87 020c 	eor.w	r2, r7, ip
10000e02:	ee1e 9a10 	vmov	r9, s28
10000e06:	ee14 ca10 	vmov	ip, s8
10000e0a:	eeb8 5b49 	vcvt.f64.u32	d5, s18
10000e0e:	4073      	eors	r3, r6
10000e10:	4313      	orrs	r3, r2
10000e12:	e9dd 6700 	ldrd	r6, r7, [sp]
10000e16:	ea8c 0209 	eor.w	r2, ip, r9
10000e1a:	ee14 7a90 	vmov	r7, s9
10000e1e:	ee1e ca90 	vmov	ip, s29
10000e22:	ee25 5b07 	vmul.f64	d5, d5, d7
10000e26:	ee03 6a90 	vmov	s7, r6
10000e2a:	ea87 0c0c 	eor.w	ip, r7, ip
10000e2e:	ea4c 0c02 	orr.w	ip, ip, r2
10000e32:	425a      	negs	r2, r3
10000e34:	431a      	orrs	r2, r3
10000e36:	0fd2      	lsrs	r2, r2, #31
10000e38:	922d      	str	r2, [sp, #180]	@ 0xb4
10000e3a:	ee15 7a10 	vmov	r7, s10
10000e3e:	ee1f 9a10 	vmov	r9, s30
10000e42:	ee1f 2a90 	vmov	r2, s31
10000e46:	ee15 6a90 	vmov	r6, s11
10000e4a:	eeb8 3b63 	vcvt.f64.u32	d3, s7
10000e4e:	ea87 0309 	eor.w	r3, r7, r9
10000e52:	4056      	eors	r6, r2
10000e54:	431e      	orrs	r6, r3
10000e56:	f1cc 0300 	rsb	r3, ip, #0
10000e5a:	ea43 030c 	orr.w	r3, r3, ip
10000e5e:	0fdb      	lsrs	r3, r3, #31
10000e60:	4272      	negs	r2, r6
10000e62:	ee23 eb01 	vmul.f64	d14, d3, d1
10000e66:	ed9d aa01 	vldr	s20, [sp, #4]
10000e6a:	4332      	orrs	r2, r6
10000e6c:	9e2d      	ldr	r6, [sp, #180]	@ 0xb4
10000e6e:	932c      	str	r3, [sp, #176]	@ 0xb0
10000e70:	ee1b 3a10 	vmov	r3, s22
10000e74:	f086 0601 	eor.w	r6, r6, #1
10000e78:	ea06 76d1 	and.w	r6, r6, r1, lsr #31
10000e7c:	ee2c 5b03 	vmul.f64	d5, d12, d3
10000e80:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10000e84:	ee2e 3b06 	vmul.f64	d3, d14, d6
10000e88:	1b9b      	subs	r3, r3, r6
10000e8a:	ee19 6a90 	vmov	r6, s19
10000e8e:	992c      	ldr	r1, [sp, #176]	@ 0xb0
10000e90:	ee2a fb01 	vmul.f64	d15, d10, d1
10000e94:	f081 0101 	eor.w	r1, r1, #1
10000e98:	ea01 71d0 	and.w	r1, r1, r0, lsr #31
10000e9c:	1a71      	subs	r1, r6, r1
10000e9e:	ee19 6a10 	vmov	r6, s18
10000ea2:	eebc 9bc3 	vcvt.u32.f64	s18, d3
10000ea6:	ee2f ab06 	vmul.f64	d10, d15, d6
10000eaa:	eeb8 4b49 	vcvt.f64.u32	d4, s18
10000eae:	eebc abca 	vcvt.u32.f64	s20, d10
10000eb2:	ee24 4b07 	vmul.f64	d4, d4, d7
10000eb6:	ee1e ba10 	vmov	fp, s28
10000eba:	ee14 7a10 	vmov	r7, s8
10000ebe:	eeb8 3b4a 	vcvt.f64.u32	d3, s20
10000ec2:	eeb0 bb45 	vmov.f64	d11, d5
10000ec6:	ee25 5b06 	vmul.f64	d5, d5, d6
10000eca:	0fd2      	lsrs	r2, r2, #31
10000ecc:	922b      	str	r2, [sp, #172]	@ 0xac
10000ece:	9a2b      	ldr	r2, [sp, #172]	@ 0xac
10000ed0:	195b      	adds	r3, r3, r5
10000ed2:	f082 0201 	eor.w	r2, r2, #1
10000ed6:	ea02 72d5 	and.w	r2, r2, r5, lsr #31
10000eda:	eba6 0202 	sub.w	r2, r6, r2
10000ede:	eb42 0204 	adc.w	r2, r2, r4
10000ee2:	181b      	adds	r3, r3, r0
10000ee4:	9c00      	ldr	r4, [sp, #0]
10000ee6:	981c      	ldr	r0, [sp, #112]	@ 0x70
10000ee8:	eb41 0102 	adc.w	r1, r1, r2
10000eec:	9a18      	ldr	r2, [sp, #96]	@ 0x60
10000eee:	fb00 f904 	mul.w	r9, r0, r4
10000ef2:	fb02 f604 	mul.w	r6, r2, r4
10000ef6:	9c01      	ldr	r4, [sp, #4]
10000ef8:	9d01      	ldr	r5, [sp, #4]
10000efa:	fb02 f404 	mul.w	r4, r2, r4
10000efe:	9a00      	ldr	r2, [sp, #0]
10000f00:	fb00 f505 	mul.w	r5, r0, r5
10000f04:	ea02 72e0 	and.w	r2, r2, r0, asr #31
10000f08:	9813      	ldr	r0, [sp, #76]	@ 0x4c
10000f0a:	ee23 3b07 	vmul.f64	d3, d3, d7
10000f0e:	eb00 0c01 	add.w	ip, r0, r1
10000f12:	4494      	add	ip, r2
10000f14:	9212      	str	r2, [sp, #72]	@ 0x48
10000f16:	ea87 020b 	eor.w	r2, r7, fp
10000f1a:	ee14 7a90 	vmov	r7, s9
10000f1e:	ee1e ba90 	vmov	fp, s29
10000f22:	eefc 9bc5 	vcvt.u32.f64	s19, d5
10000f26:	ee1f 0a10 	vmov	r0, s30
10000f2a:	ea87 0b0b 	eor.w	fp, r7, fp
10000f2e:	ee13 7a10 	vmov	r7, s6
10000f32:	eeb8 5b69 	vcvt.f64.u32	d5, s19
10000f36:	ea4b 0b02 	orr.w	fp, fp, r2
10000f3a:	4078      	eors	r0, r7
10000f3c:	ee13 2a90 	vmov	r2, s7
10000f40:	ee1f 7a90 	vmov	r7, s31
10000f44:	ee25 5b07 	vmul.f64	d5, d5, d7
10000f48:	407a      	eors	r2, r7
10000f4a:	4302      	orrs	r2, r0
10000f4c:	f1cb 0000 	rsb	r0, fp, #0
10000f50:	ee1b 7a10 	vmov	r7, s22
10000f54:	ea40 000b 	orr.w	r0, r0, fp
10000f58:	ee15 ba10 	vmov	fp, s10
10000f5c:	0fc0      	lsrs	r0, r0, #31
10000f5e:	9030      	str	r0, [sp, #192]	@ 0xc0
10000f60:	ea8b 0007 	eor.w	r0, fp, r7
10000f64:	ee1b 7a90 	vmov	r7, s23
10000f68:	ee15 ba90 	vmov	fp, s11
10000f6c:	ea8b 0b07 	eor.w	fp, fp, r7
10000f70:	ee19 7a10 	vmov	r7, s18
10000f74:	ea4b 0b00 	orr.w	fp, fp, r0
10000f78:	4250      	negs	r0, r2
10000f7a:	4302      	orrs	r2, r0
10000f7c:	f1cb 0000 	rsb	r0, fp, #0
10000f80:	ea40 000b 	orr.w	r0, r0, fp
10000f84:	f8dd b0c0 	ldr.w	fp, [sp, #192]	@ 0xc0
10000f88:	0fd2      	lsrs	r2, r2, #31
10000f8a:	f08b 0b01 	eor.w	fp, fp, #1
10000f8e:	ea0b 7bd6 	and.w	fp, fp, r6, lsr #31
10000f92:	922f      	str	r2, [sp, #188]	@ 0xbc
10000f94:	eba7 020b 	sub.w	r2, r7, fp
10000f98:	ee1a 7a10 	vmov	r7, s20
10000f9c:	9e2f      	ldr	r6, [sp, #188]	@ 0xbc
10000f9e:	0fc0      	lsrs	r0, r0, #31
10000fa0:	f086 0601 	eor.w	r6, r6, #1
10000fa4:	ea06 76d4 	and.w	r6, r6, r4, lsr #31
10000fa8:	1bbe      	subs	r6, r7, r6
10000faa:	ee19 7a90 	vmov	r7, s19
10000fae:	902e      	str	r0, [sp, #184]	@ 0xb8
10000fb0:	982e      	ldr	r0, [sp, #184]	@ 0xb8
10000fb2:	eb12 0209 	adds.w	r2, r2, r9
10000fb6:	f080 0001 	eor.w	r0, r0, #1
10000fba:	ea00 70d9 	and.w	r0, r0, r9, lsr #31
10000fbe:	eba7 0000 	sub.w	r0, r7, r0
10000fc2:	eb45 0000 	adc.w	r0, r5, r0
10000fc6:	1912      	adds	r2, r2, r4
10000fc8:	eb46 0700 	adc.w	r7, r6, r0
10000fcc:	9c02      	ldr	r4, [sp, #8]
10000fce:	9711      	str	r7, [sp, #68]	@ 0x44
10000fd0:	9f00      	ldr	r7, [sp, #0]
10000fd2:	9d08      	ldr	r5, [sp, #32]
10000fd4:	1938      	adds	r0, r7, r4
10000fd6:	ee05 0a90 	vmov	s11, r0
10000fda:	9f03      	ldr	r7, [sp, #12]
10000fdc:	9c01      	ldr	r4, [sp, #4]
10000fde:	eeb8 fb65 	vcvt.f64.u32	d15, s11
10000fe2:	eb47 0404 	adc.w	r4, r7, r4
10000fe6:	ee05 4a90 	vmov	s11, r4
10000fea:	ee22 bb0f 	vmul.f64	d11, d2, d15
10000fee:	eeb8 eb65 	vcvt.f64.u32	d14, s11
10000ff2:	ee2b 3b06 	vmul.f64	d3, d11, d6
10000ff6:	ee2e eb02 	vmul.f64	d14, d14, d2
10000ffa:	eefc 9bc3 	vcvt.u32.f64	s19, d3
10000ffe:	ee2e 4b06 	vmul.f64	d4, d14, d6
10001002:	eebc 9bc4 	vcvt.u32.f64	s18, d4
10001006:	eeb8 4b69 	vcvt.f64.u32	d4, s19
1000100a:	f85a 7005 	ldr.w	r7, [sl, r5]
1000100e:	9d14      	ldr	r5, [sp, #80]	@ 0x50
10001010:	9e10      	ldr	r6, [sp, #64]	@ 0x40
10001012:	197f      	adds	r7, r7, r5
10001014:	970a      	str	r7, [sp, #40]	@ 0x28
10001016:	9d15      	ldr	r5, [sp, #84]	@ 0x54
10001018:	ee24 4b07 	vmul.f64	d4, d4, d7
1000101c:	eb46 0705 	adc.w	r7, r6, r5
10001020:	9d08      	ldr	r5, [sp, #32]
10001022:	970b      	str	r7, [sp, #44]	@ 0x2c
10001024:	f858 7005 	ldr.w	r7, [r8, r5]
10001028:	9d16      	ldr	r5, [sp, #88]	@ 0x58
1000102a:	9e0f      	ldr	r6, [sp, #60]	@ 0x3c
1000102c:	197f      	adds	r7, r7, r5
1000102e:	9d17      	ldr	r5, [sp, #92]	@ 0x5c
10001030:	970c      	str	r7, [sp, #48]	@ 0x30
10001032:	eb46 0605 	adc.w	r6, r6, r5
10001036:	9f11      	ldr	r7, [sp, #68]	@ 0x44
10001038:	9d13      	ldr	r5, [sp, #76]	@ 0x4c
1000103a:	960d      	str	r6, [sp, #52]	@ 0x34
1000103c:	1a9e      	subs	r6, r3, r2
1000103e:	9600      	str	r6, [sp, #0]
10001040:	eb6c 0707 	sbc.w	r7, ip, r7
10001044:	9e12      	ldr	r6, [sp, #72]	@ 0x48
10001046:	425b      	negs	r3, r3
10001048:	eb65 0101 	sbc.w	r1, r5, r1
1000104c:	1875      	adds	r5, r6, r1
1000104e:	9e1d      	ldr	r6, [sp, #116]	@ 0x74
10001050:	9919      	ldr	r1, [sp, #100]	@ 0x64
10001052:	ee2d fb0f 	vmul.f64	d15, d13, d15
10001056:	fb00 f901 	mul.w	r9, r0, r1
1000105a:	ea00 71e6 	and.w	r1, r0, r6, asr #31
1000105e:	1a69      	subs	r1, r5, r1
10001060:	fb04 1106 	mla	r1, r4, r6, r1
10001064:	9d19      	ldr	r5, [sp, #100]	@ 0x64
10001066:	fb06 f000 	mul.w	r0, r6, r0
1000106a:	fb04 fc05 	mul.w	ip, r4, r5
1000106e:	ea05 74e4 	and.w	r4, r5, r4, asr #31
10001072:	1b09      	subs	r1, r1, r4
10001074:	e9dd 450a 	ldrd	r4, r5, [sp, #40]	@ 0x28
10001078:	ea54 056f 	asrl	r4, r5, #1
1000107c:	ee1b 6a10 	vmov	r6, s22
10001080:	e9ca 4500 	strd	r4, r5, [sl]
10001084:	eeb8 3b49 	vcvt.f64.u32	d3, s18
10001088:	ee14 5a10 	vmov	r5, s8
1000108c:	ee2f ab06 	vmul.f64	d10, d15, d6
10001090:	ea85 0406 	eor.w	r4, r5, r6
10001094:	ee23 3b07 	vmul.f64	d3, d3, d7
10001098:	ee14 5a90 	vmov	r5, s9
1000109c:	ee1b 6a90 	vmov	r6, s23
100010a0:	eebc abca 	vcvt.u32.f64	s20, d10
100010a4:	ea85 0b06 	eor.w	fp, r5, r6
100010a8:	ee13 5a10 	vmov	r5, s6
100010ac:	ee1e 6a10 	vmov	r6, s28
100010b0:	eeb8 5b4a 	vcvt.f64.u32	d5, s20
100010b4:	ea4b 0b04 	orr.w	fp, fp, r4
100010b8:	ea85 0406 	eor.w	r4, r5, r6
100010bc:	ee1e 6a90 	vmov	r6, s29
100010c0:	ee13 5a90 	vmov	r5, s7
100010c4:	ee25 5b07 	vmul.f64	d5, d5, d7
100010c8:	4075      	eors	r5, r6
100010ca:	4325      	orrs	r5, r4
100010cc:	f1cb 0400 	rsb	r4, fp, #0
100010d0:	ee15 6a10 	vmov	r6, s10
100010d4:	ea44 040b 	orr.w	r4, r4, fp
100010d8:	ee1f ba10 	vmov	fp, s30
100010dc:	0fe4      	lsrs	r4, r4, #31
100010de:	9433      	str	r4, [sp, #204]	@ 0xcc
100010e0:	ea86 040b 	eor.w	r4, r6, fp
100010e4:	ee15 6a90 	vmov	r6, s11
100010e8:	ee1f ba90 	vmov	fp, s31
100010ec:	ea86 0b0b 	eor.w	fp, r6, fp
100010f0:	ea4b 0b04 	orr.w	fp, fp, r4
100010f4:	426c      	negs	r4, r5
100010f6:	4325      	orrs	r5, r4
100010f8:	0fed      	lsrs	r5, r5, #31
100010fa:	f1cb 0400 	rsb	r4, fp, #0
100010fe:	ea44 040b 	orr.w	r4, r4, fp
10001102:	f8dd b0cc 	ldr.w	fp, [sp, #204]	@ 0xcc
10001106:	9532      	str	r5, [sp, #200]	@ 0xc8
10001108:	ee19 5a90 	vmov	r5, s19
1000110c:	ee19 6a10 	vmov	r6, s18
10001110:	f08b 0b01 	eor.w	fp, fp, #1
10001114:	ea0b 7bd9 	and.w	fp, fp, r9, lsr #31
10001118:	eba5 0b0b 	sub.w	fp, r5, fp
1000111c:	9d32      	ldr	r5, [sp, #200]	@ 0xc8
1000111e:	0fe4      	lsrs	r4, r4, #31
10001120:	f085 0501 	eor.w	r5, r5, #1
10001124:	9431      	str	r4, [sp, #196]	@ 0xc4
10001126:	ea05 75dc 	and.w	r5, r5, ip, lsr #31
1000112a:	1b74      	subs	r4, r6, r5
1000112c:	9d31      	ldr	r5, [sp, #196]	@ 0xc4
1000112e:	eb13 030b 	adds.w	r3, r3, fp
10001132:	f085 0501 	eor.w	r5, r5, #1
10001136:	f141 0100 	adc.w	r1, r1, #0
1000113a:	ea05 75d0 	and.w	r5, r5, r0, lsr #31
1000113e:	181b      	adds	r3, r3, r0
10001140:	ee1a 0a10 	vmov	r0, s20
10001144:	eba0 0505 	sub.w	r5, r0, r5
10001148:	eb45 0501 	adc.w	r5, r5, r1
1000114c:	eb13 030c 	adds.w	r3, r3, ip
10001150:	eb44 0405 	adc.w	r4, r4, r5
10001154:	1a99      	subs	r1, r3, r2
10001156:	9b11      	ldr	r3, [sp, #68]	@ 0x44
10001158:	9e00      	ldr	r6, [sp, #0]
1000115a:	eb64 0403 	sbc.w	r4, r4, r3
1000115e:	e9dd 230c 	ldrd	r2, r3, [sp, #48]	@ 0x30
10001162:	ea52 036f 	asrl	r2, r3, #1
10001166:	e9c8 2300 	strd	r2, r3, [r8]
1000116a:	9a08      	ldr	r2, [sp, #32]
1000116c:	9b0e      	ldr	r3, [sp, #56]	@ 0x38
1000116e:	f84a 6002 	str.w	r6, [sl, r2]
10001172:	605f      	str	r7, [r3, #4]
10001174:	f848 1002 	str.w	r1, [r8, r2]
10001178:	9a09      	ldr	r2, [sp, #36]	@ 0x24
1000117a:	f108 0808 	add.w	r8, r8, #8
1000117e:	6054      	str	r4, [r2, #4]
10001180:	f1be 0e01 	subs.w	lr, lr, #1
10001184:	f47f adbe 	bne.w	10000d04 <fndsa_vect_iFFT_fp64q+0x114>
10001188:	e9dd cb1e 	ldrd	ip, fp, [sp, #120]	@ 0x78
1000118c:	9f20      	ldr	r7, [sp, #128]	@ 0x80
1000118e:	9b21      	ldr	r3, [sp, #132]	@ 0x84
10001190:	3710      	adds	r7, #16
10001192:	449c      	add	ip, r3
10001194:	9b23      	ldr	r3, [sp, #140]	@ 0x8c
10001196:	449b      	add	fp, r3
10001198:	9b22      	ldr	r3, [sp, #136]	@ 0x88
1000119a:	42bb      	cmp	r3, r7
1000119c:	f47f ad5f 	bne.w	10000c5e <fndsa_vect_iFFT_fp64q+0x6e>
100011a0:	9d27      	ldr	r5, [sp, #156]	@ 0x9c
100011a2:	3d01      	subs	r5, #1
100011a4:	f47f ad3b 	bne.w	10000c1e <fndsa_vect_iFFT_fp64q+0x2e>
100011a8:	b03d      	add	sp, #244	@ 0xf4
100011aa:	ecbd 8b10 	vpop	{d8-d15}
100011ae:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
