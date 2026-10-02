
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/hybrid_fixed_div/validation/build/kat/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10004c30 <fxr_div_fp64_exact>:
10004c30:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10004c34:	4607      	mov	r7, r0
10004c36:	f04f 0c00 	mov.w	ip, #0
10004c3a:	ea4f 79d1 	mov.w	r9, r1, lsr #31
10004c3e:	ea4f 78d3 	mov.w	r8, r3, lsr #31
10004c42:	ea82 74e3 	eor.w	r4, r2, r3, asr #31
10004c46:	ea83 75e3 	eor.w	r5, r3, r3, asr #31
10004c4a:	ea89 0308 	eor.w	r3, r9, r8
10004c4e:	b0a7      	sub	sp, #156	@ 0x9c
10004c50:	425a      	negs	r2, r3
10004c52:	ea87 77e1 	eor.w	r7, r7, r1, asr #31
10004c56:	ea81 76e1 	eor.w	r6, r1, r1, asr #31
10004c5a:	9212      	str	r2, [sp, #72]	@ 0x48
10004c5c:	9213      	str	r2, [sp, #76]	@ 0x4c
10004c5e:	eb17 0209 	adds.w	r2, r7, r9
10004c62:	930b      	str	r3, [sp, #44]	@ 0x2c
10004c64:	f146 0300 	adc.w	r3, r6, #0
10004c68:	eb14 0408 	adds.w	r4, r4, r8
10004c6c:	f145 0500 	adc.w	r5, r5, #0
10004c70:	ea45 0604 	orr.w	r6, r5, r4
10004c74:	462f      	mov	r7, r5
10004c76:	ee07 5a90 	vmov	s15, r5
10004c7a:	4275      	negs	r5, r6
10004c7c:	4335      	orrs	r5, r6
10004c7e:	0fed      	lsrs	r5, r5, #31
10004c80:	9517      	str	r5, [sp, #92]	@ 0x5c
10004c82:	9d17      	ldr	r5, [sp, #92]	@ 0x5c
10004c84:	ed9f 6bce 	vldr	d6, [pc, #824]	@ 10004fc0 <fxr_div_fp64_exact+0x390>
10004c88:	f085 0501 	eor.w	r5, r5, #1
10004c8c:	f115 3aff 	adds.w	sl, r5, #4294967295	@ 0xffffffff
10004c90:	f14c 38ff 	adc.w	r8, ip, #4294967295	@ 0xffffffff
10004c94:	ea08 0803 	and.w	r8, r8, r3
10004c98:	ea0a 0602 	and.w	r6, sl, r2
10004c9c:	ee02 6a90 	vmov	s5, r6
10004ca0:	ee05 8a90 	vmov	s11, r8
10004ca4:	eeb8 4b67 	vcvt.f64.u32	d4, s15
10004ca8:	eeb8 5b65 	vcvt.f64.u32	d5, s11
10004cac:	eeb8 7b62 	vcvt.f64.u32	d7, s5
10004cb0:	ea44 0a05 	orr.w	sl, r4, r5
10004cb4:	ee05 7b06 	vmla.f64	d7, d5, d6
10004cb8:	ee05 aa90 	vmov	s11, sl
10004cbc:	eeb8 5b65 	vcvt.f64.u32	d5, s11
10004cc0:	ee04 5b06 	vmla.f64	d5, d4, d6
10004cc4:	950a      	str	r5, [sp, #40]	@ 0x28
10004cc6:	2400      	movs	r4, #0
10004cc8:	2500      	movs	r5, #0
10004cca:	ee86 4b05 	vdiv.f64	d4, d6, d5
10004cce:	17de      	asrs	r6, r3, #31
10004cd0:	46bb      	mov	fp, r7
10004cd2:	9611      	str	r6, [sp, #68]	@ 0x44
10004cd4:	9709      	str	r7, [sp, #36]	@ 0x24
10004cd6:	4626      	mov	r6, r4
10004cd8:	462f      	mov	r7, r5
10004cda:	ed9f 3bbb 	vldr	d3, [pc, #748]	@ 10004fc8 <fxr_div_fp64_exact+0x398>
10004cde:	ee27 7b04 	vmul.f64	d7, d7, d4
10004ce2:	e9cd 6700 	strd	r6, r7, [sp]
10004ce6:	e9cd 6704 	strd	r6, r7, [sp, #16]
10004cea:	e9cd 6706 	strd	r6, r7, [sp, #24]
10004cee:	4616      	mov	r6, r2
10004cf0:	461f      	mov	r7, r3
10004cf2:	ee27 7b03 	vmul.f64	d7, d7, d3
10004cf6:	ea52 73df 	lsrl	r2, r3, #31
10004cfa:	ea56 779f 	lsrl	r6, r7, #30
10004cfe:	ed8d 7b02 	vstr	d7, [sp, #8]
10004d02:	43d7      	mvns	r7, r2
10004d04:	43f6      	mvns	r6, r6
10004d06:	f8df e2d0 	ldr.w	lr, [pc, #720]	@ 10004fd8 <fxr_div_fp64_exact+0x3a8>
10004d0a:	f00a 0101 	and.w	r1, sl, #1
10004d0e:	48b0      	ldr	r0, [pc, #704]	@ (10004fd0 <fxr_div_fp64_exact+0x3a0>)
10004d10:	910f      	str	r1, [sp, #60]	@ 0x3c
10004d12:	49b0      	ldr	r1, [pc, #704]	@ (10004fd4 <fxr_div_fp64_exact+0x3a4>)
10004d14:	970e      	str	r7, [sp, #56]	@ 0x38
10004d16:	e9dd 9702 	ldrd	r9, r7, [sp, #8]
10004d1a:	ebbe 0209 	subs.w	r2, lr, r9
10004d1e:	eb61 0207 	sbc.w	r2, r1, r7
10004d22:	f006 0301 	and.w	r3, r6, #1
10004d26:	ea47 0600 	orr.w	r6, r7, r0
10004d2a:	4032      	ands	r2, r6
10004d2c:	ea07 0600 	and.w	r6, r7, r0
10004d30:	4332      	orrs	r2, r6
10004d32:	0fd2      	lsrs	r2, r2, #31
10004d34:	9216      	str	r2, [sp, #88]	@ 0x58
10004d36:	9a16      	ldr	r2, [sp, #88]	@ 0x58
10004d38:	9310      	str	r3, [sp, #64]	@ 0x40
10004d3a:	4254      	negs	r4, r2
10004d3c:	eb6c 050c 	sbc.w	r5, ip, ip
10004d40:	e9cd 4524 	strd	r4, r5, [sp, #144]	@ 0x90
10004d44:	e9dd 2324 	ldrd	r2, r3, [sp, #144]	@ 0x90
10004d48:	ea89 050e 	eor.w	r5, r9, lr
10004d4c:	ea87 0401 	eor.w	r4, r7, r1
10004d50:	4015      	ands	r5, r2
10004d52:	401c      	ands	r4, r3
10004d54:	ea85 0209 	eor.w	r2, r5, r9
10004d58:	407c      	eors	r4, r7
10004d5a:	9200      	str	r2, [sp, #0]
10004d5c:	9401      	str	r4, [sp, #4]
10004d5e:	ed9d 7b00 	vldr	d7, [sp]
10004d62:	4654      	mov	r4, sl
10004d64:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10004d68:	465d      	mov	r5, fp
10004d6a:	ee17 6a90 	vmov	r6, s15
10004d6e:	ea54 055f 	lsrl	r4, r5, #1
10004d72:	2200      	movs	r2, #0
10004d74:	2300      	movs	r3, #0
10004d76:	ee12 9a90 	vmov	r9, s5
10004d7a:	e9cd 450c 	strd	r4, r5, [sp, #48]	@ 0x30
10004d7e:	e9cd 2302 	strd	r2, r3, [sp, #8]
10004d82:	fba6 420a 	umull	r4, r2, r6, sl
10004d86:	ebb9 0304 	subs.w	r3, r9, r4
10004d8a:	46e1      	mov	r9, ip
10004d8c:	fbeb 2906 	umlal	r2, r9, fp, r6
10004d90:	eb68 0602 	sbc.w	r6, r8, r2
10004d94:	ea62 0408 	orn	r4, r2, r8
10004d98:	4034      	ands	r4, r6
10004d9a:	ea22 0208 	bic.w	r2, r2, r8
10004d9e:	4314      	orrs	r4, r2
10004da0:	0fe4      	lsrs	r4, r4, #31
10004da2:	941c      	str	r4, [sp, #112]	@ 0x70
10004da4:	9a1c      	ldr	r2, [sp, #112]	@ 0x70
10004da6:	edcd 7a00 	vstr	s15, [sp]
10004daa:	eb09 0802 	add.w	r8, r9, r2
10004dae:	f1c8 0700 	rsb	r7, r8, #0
10004db2:	ea0a 74e7 	and.w	r4, sl, r7, asr #31
10004db6:	191b      	adds	r3, r3, r4
10004db8:	ea0b 74e7 	and.w	r4, fp, r7, asr #31
10004dbc:	4621      	mov	r1, r4
10004dbe:	eb46 0504 	adc.w	r5, r6, r4
10004dc2:	ebb3 040a 	subs.w	r4, r3, sl
10004dc6:	ea66 0405 	orn	r4, r6, r5
10004dca:	ea04 0401 	and.w	r4, r4, r1
10004dce:	ea26 0605 	bic.w	r6, r6, r5
10004dd2:	ea44 0406 	orr.w	r4, r4, r6
10004dd6:	ee17 6a90 	vmov	r6, s15
10004dda:	ea4f 74d4 	mov.w	r4, r4, lsr #31
10004dde:	941d      	str	r4, [sp, #116]	@ 0x74
10004de0:	9c1d      	ldr	r4, [sp, #116]	@ 0x74
10004de2:	497c      	ldr	r1, [pc, #496]	@ (10004fd4 <fxr_div_fp64_exact+0x3a4>)
10004de4:	eba2 0204 	sub.w	r2, r2, r4
10004de8:	444a      	add	r2, r9
10004dea:	eba4 0408 	sub.w	r4, r4, r8
10004dee:	ea42 0204 	orr.w	r2, r2, r4
10004df2:	ea4f 72d2 	mov.w	r2, r2, lsr #31
10004df6:	921e      	str	r2, [sp, #120]	@ 0x78
10004df8:	ea6b 0405 	orn	r4, fp, r5
10004dfc:	eb65 020b 	sbc.w	r2, r5, fp
10004e00:	4022      	ands	r2, r4
10004e02:	ea2b 0405 	bic.w	r4, fp, r5
10004e06:	4322      	orrs	r2, r4
10004e08:	0fd2      	lsrs	r2, r2, #31
10004e0a:	9c1e      	ldr	r4, [sp, #120]	@ 0x78
10004e0c:	921f      	str	r2, [sp, #124]	@ 0x7c
10004e0e:	9a1f      	ldr	r2, [sp, #124]	@ 0x7c
10004e10:	f082 0201 	eor.w	r2, r2, #1
10004e14:	4322      	orrs	r2, r4
10004e16:	18b4      	adds	r4, r6, r2
10004e18:	4252      	negs	r2, r2
10004e1a:	eba4 78d7 	sub.w	r8, r4, r7, lsr #31
10004e1e:	ea02 020a 	and.w	r2, r2, sl
10004e22:	eb6c 040c 	sbc.w	r4, ip, ip
10004e26:	ea04 040b 	and.w	r4, r4, fp
10004e2a:	1a9b      	subs	r3, r3, r2
10004e2c:	eb65 0404 	sbc.w	r4, r5, r4
10004e30:	ee07 4a90 	vmov	s15, r4
10004e34:	eeb8 5b67 	vcvt.f64.u32	d5, s15
10004e38:	ee07 3a90 	vmov	s15, r3
10004e3c:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10004e40:	ee05 7b06 	vmla.f64	d7, d5, d6
10004e44:	ee27 7b04 	vmul.f64	d7, d7, d4
10004e48:	ed8d 7b00 	vstr	d7, [sp]
10004e4c:	e9dd 5200 	ldrd	r5, r2, [sp]
10004e50:	ebbe 0605 	subs.w	r6, lr, r5
10004e54:	eb61 0702 	sbc.w	r7, r1, r2
10004e58:	ea82 0601 	eor.w	r6, r2, r1
10004e5c:	ea42 0100 	orr.w	r1, r2, r0
10004e60:	4039      	ands	r1, r7
10004e62:	4010      	ands	r0, r2
10004e64:	4301      	orrs	r1, r0
10004e66:	0fc9      	lsrs	r1, r1, #31
10004e68:	9115      	str	r1, [sp, #84]	@ 0x54
10004e6a:	9915      	ldr	r1, [sp, #84]	@ 0x54
10004e6c:	ea85 0e0e 	eor.w	lr, r5, lr
10004e70:	4249      	negs	r1, r1
10004e72:	9104      	str	r1, [sp, #16]
10004e74:	eb6c 010c 	sbc.w	r1, ip, ip
10004e78:	9105      	str	r1, [sp, #20]
10004e7a:	e9dd 0104 	ldrd	r0, r1, [sp, #16]
10004e7e:	e9cd 0122 	strd	r0, r1, [sp, #136]	@ 0x88
10004e82:	e9dd 0122 	ldrd	r0, r1, [sp, #136]	@ 0x88
10004e86:	ea0e 0e00 	and.w	lr, lr, r0
10004e8a:	4031      	ands	r1, r6
10004e8c:	404a      	eors	r2, r1
10004e8e:	ea8e 0605 	eor.w	r6, lr, r5
10004e92:	9606      	str	r6, [sp, #24]
10004e94:	9207      	str	r2, [sp, #28]
10004e96:	ed9d 7b06 	vldr	d7, [sp, #24]
10004e9a:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10004e9e:	ee17 9a90 	vmov	r9, s15
10004ea2:	46e6      	mov	lr, ip
10004ea4:	fba9 210a 	umull	r2, r1, r9, sl
10004ea8:	fbeb 1e09 	umlal	r1, lr, fp, r9
10004eac:	4677      	mov	r7, lr
10004eae:	ebbc 0202 	subs.w	r2, ip, r2
10004eb2:	eb63 0601 	sbc.w	r6, r3, r1
10004eb6:	ea61 0003 	orn	r0, r1, r3
10004eba:	4030      	ands	r0, r6
10004ebc:	ea21 0103 	bic.w	r1, r1, r3
10004ec0:	4308      	orrs	r0, r1
10004ec2:	0fc0      	lsrs	r0, r0, #31
10004ec4:	9018      	str	r0, [sp, #96]	@ 0x60
10004ec6:	9b18      	ldr	r3, [sp, #96]	@ 0x60
10004ec8:	1ae5      	subs	r5, r4, r3
10004eca:	1bed      	subs	r5, r5, r7
10004ecc:	ea0a 71e5 	and.w	r1, sl, r5, asr #31
10004ed0:	ea0b 7ee5 	and.w	lr, fp, r5, asr #31
10004ed4:	1852      	adds	r2, r2, r1
10004ed6:	eb46 000e 	adc.w	r0, r6, lr
10004eda:	ebb2 010a 	subs.w	r1, r2, sl
10004ede:	ea66 0100 	orn	r1, r6, r0
10004ee2:	ea01 010e 	and.w	r1, r1, lr
10004ee6:	ea26 0600 	bic.w	r6, r6, r0
10004eea:	ea41 0106 	orr.w	r1, r1, r6
10004eee:	ea4f 71d1 	mov.w	r1, r1, lsr #31
10004ef2:	9119      	str	r1, [sp, #100]	@ 0x64
10004ef4:	9919      	ldr	r1, [sp, #100]	@ 0x64
10004ef6:	eba3 0301 	sub.w	r3, r3, r1
10004efa:	eba3 0304 	sub.w	r3, r3, r4
10004efe:	4429      	add	r1, r5
10004f00:	443b      	add	r3, r7
10004f02:	ea43 0301 	orr.w	r3, r3, r1
10004f06:	ea4f 73d3 	mov.w	r3, r3, lsr #31
10004f0a:	931a      	str	r3, [sp, #104]	@ 0x68
10004f0c:	ea6b 0100 	orn	r1, fp, r0
10004f10:	eb60 030b 	sbc.w	r3, r0, fp
10004f14:	400b      	ands	r3, r1
10004f16:	ea2b 0100 	bic.w	r1, fp, r0
10004f1a:	430b      	orrs	r3, r1
10004f1c:	0fdb      	lsrs	r3, r3, #31
10004f1e:	991a      	ldr	r1, [sp, #104]	@ 0x68
10004f20:	931b      	str	r3, [sp, #108]	@ 0x6c
10004f22:	9b1b      	ldr	r3, [sp, #108]	@ 0x6c
10004f24:	f083 0301 	eor.w	r3, r3, #1
10004f28:	430b      	orrs	r3, r1
10004f2a:	4499      	add	r9, r3
10004f2c:	425b      	negs	r3, r3
10004f2e:	eb6c 010c 	sbc.w	r1, ip, ip
10004f32:	ea03 030a 	and.w	r3, r3, sl
10004f36:	1ad3      	subs	r3, r2, r3
10004f38:	ea01 010b 	and.w	r1, r1, fp
10004f3c:	eb60 0101 	sbc.w	r1, r0, r1
10004f40:	980f      	ldr	r0, [sp, #60]	@ 0x3c
10004f42:	e9dd ab0c 	ldrd	sl, fp, [sp, #48]	@ 0x30
10004f46:	eb1a 0000 	adds.w	r0, sl, r0
10004f4a:	f14b 0200 	adc.w	r2, fp, #0
10004f4e:	1a18      	subs	r0, r3, r0
10004f50:	eb61 0302 	sbc.w	r3, r1, r2
10004f54:	ea62 0001 	orn	r0, r2, r1
10004f58:	4003      	ands	r3, r0
10004f5a:	ea22 0201 	bic.w	r2, r2, r1
10004f5e:	4313      	orrs	r3, r2
10004f60:	0fdb      	lsrs	r3, r3, #31
10004f62:	9314      	str	r3, [sp, #80]	@ 0x50
10004f64:	9b14      	ldr	r3, [sp, #80]	@ 0x50
10004f66:	eba9 79d5 	sub.w	r9, r9, r5, lsr #31
10004f6a:	f083 0301 	eor.w	r3, r3, #1
10004f6e:	9d0a      	ldr	r5, [sp, #40]	@ 0x28
10004f70:	eb13 0309 	adds.w	r3, r3, r9
10004f74:	f148 0200 	adc.w	r2, r8, #0
10004f78:	4269      	negs	r1, r5
10004f7a:	9102      	str	r1, [sp, #8]
10004f7c:	eb6c 010c 	sbc.w	r1, ip, ip
10004f80:	9103      	str	r1, [sp, #12]
10004f82:	9f0e      	ldr	r7, [sp, #56]	@ 0x38
10004f84:	9810      	ldr	r0, [sp, #64]	@ 0x40
10004f86:	9e11      	ldr	r6, [sp, #68]	@ 0x44
10004f88:	19c0      	adds	r0, r0, r7
10004f8a:	9c12      	ldr	r4, [sp, #72]	@ 0x48
10004f8c:	9d13      	ldr	r5, [sp, #76]	@ 0x4c
10004f8e:	f166 0100 	sbc.w	r1, r6, #0
10004f92:	4058      	eors	r0, r3
10004f94:	e9dd 8902 	ldrd	r8, r9, [sp, #8]
10004f98:	e9cd 8920 	strd	r8, r9, [sp, #128]	@ 0x80
10004f9c:	e9dd 6720 	ldrd	r6, r7, [sp, #128]	@ 0x80
10004fa0:	405c      	eors	r4, r3
10004fa2:	4051      	eors	r1, r2
10004fa4:	ea85 0302 	eor.w	r3, r5, r2
10004fa8:	4030      	ands	r0, r6
10004faa:	9a0b      	ldr	r2, [sp, #44]	@ 0x2c
10004fac:	4039      	ands	r1, r7
10004fae:	4060      	eors	r0, r4
10004fb0:	1880      	adds	r0, r0, r2
10004fb2:	ea81 0103 	eor.w	r1, r1, r3
10004fb6:	f141 0100 	adc.w	r1, r1, #0
10004fba:	b027      	add	sp, #156	@ 0x9c
10004fbc:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10004fc0:	00000000 	.word	0x00000000
10004fc4:	41f00000 	.word	0x41f00000
10004fc8:	00000000 	.word	0x00000000
10004fcc:	3df00000 	.word	0x3df00000
10004fd0:	be100000 	.word	0xbe100000
10004fd4:	41efffff 	.word	0x41efffff
10004fd8:	ffe00000 	.word	0xffe00000
