
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/r2-kat/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10004dc0 <fxr_div_fp64_exact>:
10004dc0:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10004dc4:	4607      	mov	r7, r0
10004dc6:	f04f 0c00 	mov.w	ip, #0
10004dca:	ea4f 79d1 	mov.w	r9, r1, lsr #31
10004dce:	ea4f 78d3 	mov.w	r8, r3, lsr #31
10004dd2:	ea82 74e3 	eor.w	r4, r2, r3, asr #31
10004dd6:	ea83 75e3 	eor.w	r5, r3, r3, asr #31
10004dda:	ea89 0308 	eor.w	r3, r9, r8
10004dde:	b0a7      	sub	sp, #156	@ 0x9c
10004de0:	425a      	negs	r2, r3
10004de2:	ea87 77e1 	eor.w	r7, r7, r1, asr #31
10004de6:	ea81 76e1 	eor.w	r6, r1, r1, asr #31
10004dea:	9212      	str	r2, [sp, #72]	@ 0x48
10004dec:	9213      	str	r2, [sp, #76]	@ 0x4c
10004dee:	eb17 0209 	adds.w	r2, r7, r9
10004df2:	930b      	str	r3, [sp, #44]	@ 0x2c
10004df4:	f146 0300 	adc.w	r3, r6, #0
10004df8:	eb14 0408 	adds.w	r4, r4, r8
10004dfc:	f145 0500 	adc.w	r5, r5, #0
10004e00:	ea45 0604 	orr.w	r6, r5, r4
10004e04:	462f      	mov	r7, r5
10004e06:	ee07 5a90 	vmov	s15, r5
10004e0a:	4275      	negs	r5, r6
10004e0c:	4335      	orrs	r5, r6
10004e0e:	0fed      	lsrs	r5, r5, #31
10004e10:	9517      	str	r5, [sp, #92]	@ 0x5c
10004e12:	9d17      	ldr	r5, [sp, #92]	@ 0x5c
10004e14:	ed9f 6bce 	vldr	d6, [pc, #824]	@ 10005150 <fxr_div_fp64_exact+0x390>
10004e18:	f085 0501 	eor.w	r5, r5, #1
10004e1c:	f115 3aff 	adds.w	sl, r5, #4294967295	@ 0xffffffff
10004e20:	f14c 38ff 	adc.w	r8, ip, #4294967295	@ 0xffffffff
10004e24:	ea08 0803 	and.w	r8, r8, r3
10004e28:	ea0a 0602 	and.w	r6, sl, r2
10004e2c:	ee02 6a90 	vmov	s5, r6
10004e30:	ee05 8a90 	vmov	s11, r8
10004e34:	eeb8 4b67 	vcvt.f64.u32	d4, s15
10004e38:	eeb8 5b65 	vcvt.f64.u32	d5, s11
10004e3c:	eeb8 7b62 	vcvt.f64.u32	d7, s5
10004e40:	ea44 0a05 	orr.w	sl, r4, r5
10004e44:	ee05 7b06 	vmla.f64	d7, d5, d6
10004e48:	ee05 aa90 	vmov	s11, sl
10004e4c:	eeb8 5b65 	vcvt.f64.u32	d5, s11
10004e50:	ee04 5b06 	vmla.f64	d5, d4, d6
10004e54:	950a      	str	r5, [sp, #40]	@ 0x28
10004e56:	2400      	movs	r4, #0
10004e58:	2500      	movs	r5, #0
10004e5a:	ee86 4b05 	vdiv.f64	d4, d6, d5
10004e5e:	17de      	asrs	r6, r3, #31
10004e60:	46bb      	mov	fp, r7
10004e62:	9611      	str	r6, [sp, #68]	@ 0x44
10004e64:	9709      	str	r7, [sp, #36]	@ 0x24
10004e66:	4626      	mov	r6, r4
10004e68:	462f      	mov	r7, r5
10004e6a:	ed9f 3bbb 	vldr	d3, [pc, #748]	@ 10005158 <fxr_div_fp64_exact+0x398>
10004e6e:	ee27 7b04 	vmul.f64	d7, d7, d4
10004e72:	e9cd 6700 	strd	r6, r7, [sp]
10004e76:	e9cd 6704 	strd	r6, r7, [sp, #16]
10004e7a:	e9cd 6706 	strd	r6, r7, [sp, #24]
10004e7e:	4616      	mov	r6, r2
10004e80:	461f      	mov	r7, r3
10004e82:	ee27 7b03 	vmul.f64	d7, d7, d3
10004e86:	ea52 73df 	lsrl	r2, r3, #31
10004e8a:	ea56 779f 	lsrl	r6, r7, #30
10004e8e:	ed8d 7b02 	vstr	d7, [sp, #8]
10004e92:	43d7      	mvns	r7, r2
10004e94:	43f6      	mvns	r6, r6
10004e96:	f8df e2d0 	ldr.w	lr, [pc, #720]	@ 10005168 <fxr_div_fp64_exact+0x3a8>
10004e9a:	f00a 0101 	and.w	r1, sl, #1
10004e9e:	48b0      	ldr	r0, [pc, #704]	@ (10005160 <fxr_div_fp64_exact+0x3a0>)
10004ea0:	910f      	str	r1, [sp, #60]	@ 0x3c
10004ea2:	49b0      	ldr	r1, [pc, #704]	@ (10005164 <fxr_div_fp64_exact+0x3a4>)
10004ea4:	970e      	str	r7, [sp, #56]	@ 0x38
10004ea6:	e9dd 9702 	ldrd	r9, r7, [sp, #8]
10004eaa:	ebbe 0209 	subs.w	r2, lr, r9
10004eae:	eb61 0207 	sbc.w	r2, r1, r7
10004eb2:	f006 0301 	and.w	r3, r6, #1
10004eb6:	ea47 0600 	orr.w	r6, r7, r0
10004eba:	4032      	ands	r2, r6
10004ebc:	ea07 0600 	and.w	r6, r7, r0
10004ec0:	4332      	orrs	r2, r6
10004ec2:	0fd2      	lsrs	r2, r2, #31
10004ec4:	9216      	str	r2, [sp, #88]	@ 0x58
10004ec6:	9a16      	ldr	r2, [sp, #88]	@ 0x58
10004ec8:	9310      	str	r3, [sp, #64]	@ 0x40
10004eca:	4254      	negs	r4, r2
10004ecc:	eb6c 050c 	sbc.w	r5, ip, ip
10004ed0:	e9cd 4524 	strd	r4, r5, [sp, #144]	@ 0x90
10004ed4:	e9dd 2324 	ldrd	r2, r3, [sp, #144]	@ 0x90
10004ed8:	ea89 050e 	eor.w	r5, r9, lr
10004edc:	ea87 0401 	eor.w	r4, r7, r1
10004ee0:	4015      	ands	r5, r2
10004ee2:	401c      	ands	r4, r3
10004ee4:	ea85 0209 	eor.w	r2, r5, r9
10004ee8:	407c      	eors	r4, r7
10004eea:	9200      	str	r2, [sp, #0]
10004eec:	9401      	str	r4, [sp, #4]
10004eee:	ed9d 7b00 	vldr	d7, [sp]
10004ef2:	4654      	mov	r4, sl
10004ef4:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10004ef8:	465d      	mov	r5, fp
10004efa:	ee17 6a90 	vmov	r6, s15
10004efe:	ea54 055f 	lsrl	r4, r5, #1
10004f02:	2200      	movs	r2, #0
10004f04:	2300      	movs	r3, #0
10004f06:	ee12 9a90 	vmov	r9, s5
10004f0a:	e9cd 450c 	strd	r4, r5, [sp, #48]	@ 0x30
10004f0e:	e9cd 2302 	strd	r2, r3, [sp, #8]
10004f12:	fba6 420a 	umull	r4, r2, r6, sl
10004f16:	ebb9 0304 	subs.w	r3, r9, r4
10004f1a:	46e1      	mov	r9, ip
10004f1c:	fbeb 2906 	umlal	r2, r9, fp, r6
10004f20:	eb68 0602 	sbc.w	r6, r8, r2
10004f24:	ea62 0408 	orn	r4, r2, r8
10004f28:	4034      	ands	r4, r6
10004f2a:	ea22 0208 	bic.w	r2, r2, r8
10004f2e:	4314      	orrs	r4, r2
10004f30:	0fe4      	lsrs	r4, r4, #31
10004f32:	941c      	str	r4, [sp, #112]	@ 0x70
10004f34:	9a1c      	ldr	r2, [sp, #112]	@ 0x70
10004f36:	edcd 7a00 	vstr	s15, [sp]
10004f3a:	eb09 0802 	add.w	r8, r9, r2
10004f3e:	f1c8 0700 	rsb	r7, r8, #0
10004f42:	ea0a 74e7 	and.w	r4, sl, r7, asr #31
10004f46:	191b      	adds	r3, r3, r4
10004f48:	ea0b 74e7 	and.w	r4, fp, r7, asr #31
10004f4c:	4621      	mov	r1, r4
10004f4e:	eb46 0504 	adc.w	r5, r6, r4
10004f52:	ebb3 040a 	subs.w	r4, r3, sl
10004f56:	ea66 0405 	orn	r4, r6, r5
10004f5a:	ea04 0401 	and.w	r4, r4, r1
10004f5e:	ea26 0605 	bic.w	r6, r6, r5
10004f62:	ea44 0406 	orr.w	r4, r4, r6
10004f66:	ee17 6a90 	vmov	r6, s15
10004f6a:	ea4f 74d4 	mov.w	r4, r4, lsr #31
10004f6e:	941d      	str	r4, [sp, #116]	@ 0x74
10004f70:	9c1d      	ldr	r4, [sp, #116]	@ 0x74
10004f72:	497c      	ldr	r1, [pc, #496]	@ (10005164 <fxr_div_fp64_exact+0x3a4>)
10004f74:	eba2 0204 	sub.w	r2, r2, r4
10004f78:	444a      	add	r2, r9
10004f7a:	eba4 0408 	sub.w	r4, r4, r8
10004f7e:	ea42 0204 	orr.w	r2, r2, r4
10004f82:	ea4f 72d2 	mov.w	r2, r2, lsr #31
10004f86:	921e      	str	r2, [sp, #120]	@ 0x78
10004f88:	ea6b 0405 	orn	r4, fp, r5
10004f8c:	eb65 020b 	sbc.w	r2, r5, fp
10004f90:	4022      	ands	r2, r4
10004f92:	ea2b 0405 	bic.w	r4, fp, r5
10004f96:	4322      	orrs	r2, r4
10004f98:	0fd2      	lsrs	r2, r2, #31
10004f9a:	9c1e      	ldr	r4, [sp, #120]	@ 0x78
10004f9c:	921f      	str	r2, [sp, #124]	@ 0x7c
10004f9e:	9a1f      	ldr	r2, [sp, #124]	@ 0x7c
10004fa0:	f082 0201 	eor.w	r2, r2, #1
10004fa4:	4322      	orrs	r2, r4
10004fa6:	18b4      	adds	r4, r6, r2
10004fa8:	4252      	negs	r2, r2
10004faa:	eba4 78d7 	sub.w	r8, r4, r7, lsr #31
10004fae:	ea02 020a 	and.w	r2, r2, sl
10004fb2:	eb6c 040c 	sbc.w	r4, ip, ip
10004fb6:	ea04 040b 	and.w	r4, r4, fp
10004fba:	1a9b      	subs	r3, r3, r2
10004fbc:	eb65 0404 	sbc.w	r4, r5, r4
10004fc0:	ee07 4a90 	vmov	s15, r4
10004fc4:	eeb8 5b67 	vcvt.f64.u32	d5, s15
10004fc8:	ee07 3a90 	vmov	s15, r3
10004fcc:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10004fd0:	ee05 7b06 	vmla.f64	d7, d5, d6
10004fd4:	ee27 7b04 	vmul.f64	d7, d7, d4
10004fd8:	ed8d 7b00 	vstr	d7, [sp]
10004fdc:	e9dd 5200 	ldrd	r5, r2, [sp]
10004fe0:	ebbe 0605 	subs.w	r6, lr, r5
10004fe4:	eb61 0702 	sbc.w	r7, r1, r2
10004fe8:	ea82 0601 	eor.w	r6, r2, r1
10004fec:	ea42 0100 	orr.w	r1, r2, r0
10004ff0:	4039      	ands	r1, r7
10004ff2:	4010      	ands	r0, r2
10004ff4:	4301      	orrs	r1, r0
10004ff6:	0fc9      	lsrs	r1, r1, #31
10004ff8:	9115      	str	r1, [sp, #84]	@ 0x54
10004ffa:	9915      	ldr	r1, [sp, #84]	@ 0x54
10004ffc:	ea85 0e0e 	eor.w	lr, r5, lr
10005000:	4249      	negs	r1, r1
10005002:	9104      	str	r1, [sp, #16]
10005004:	eb6c 010c 	sbc.w	r1, ip, ip
10005008:	9105      	str	r1, [sp, #20]
1000500a:	e9dd 0104 	ldrd	r0, r1, [sp, #16]
1000500e:	e9cd 0122 	strd	r0, r1, [sp, #136]	@ 0x88
10005012:	e9dd 0122 	ldrd	r0, r1, [sp, #136]	@ 0x88
10005016:	ea0e 0e00 	and.w	lr, lr, r0
1000501a:	4031      	ands	r1, r6
1000501c:	404a      	eors	r2, r1
1000501e:	ea8e 0605 	eor.w	r6, lr, r5
10005022:	9606      	str	r6, [sp, #24]
10005024:	9207      	str	r2, [sp, #28]
10005026:	ed9d 7b06 	vldr	d7, [sp, #24]
1000502a:	eefc 7bc7 	vcvt.u32.f64	s15, d7
1000502e:	ee17 9a90 	vmov	r9, s15
10005032:	46e6      	mov	lr, ip
10005034:	fba9 210a 	umull	r2, r1, r9, sl
10005038:	fbeb 1e09 	umlal	r1, lr, fp, r9
1000503c:	4677      	mov	r7, lr
1000503e:	ebbc 0202 	subs.w	r2, ip, r2
10005042:	eb63 0601 	sbc.w	r6, r3, r1
10005046:	ea61 0003 	orn	r0, r1, r3
1000504a:	4030      	ands	r0, r6
1000504c:	ea21 0103 	bic.w	r1, r1, r3
10005050:	4308      	orrs	r0, r1
10005052:	0fc0      	lsrs	r0, r0, #31
10005054:	9018      	str	r0, [sp, #96]	@ 0x60
10005056:	9b18      	ldr	r3, [sp, #96]	@ 0x60
10005058:	1ae5      	subs	r5, r4, r3
1000505a:	1bed      	subs	r5, r5, r7
1000505c:	ea0a 71e5 	and.w	r1, sl, r5, asr #31
10005060:	ea0b 7ee5 	and.w	lr, fp, r5, asr #31
10005064:	1852      	adds	r2, r2, r1
10005066:	eb46 000e 	adc.w	r0, r6, lr
1000506a:	ebb2 010a 	subs.w	r1, r2, sl
1000506e:	ea66 0100 	orn	r1, r6, r0
10005072:	ea01 010e 	and.w	r1, r1, lr
10005076:	ea26 0600 	bic.w	r6, r6, r0
1000507a:	ea41 0106 	orr.w	r1, r1, r6
1000507e:	ea4f 71d1 	mov.w	r1, r1, lsr #31
10005082:	9119      	str	r1, [sp, #100]	@ 0x64
10005084:	9919      	ldr	r1, [sp, #100]	@ 0x64
10005086:	eba3 0301 	sub.w	r3, r3, r1
1000508a:	eba3 0304 	sub.w	r3, r3, r4
1000508e:	4429      	add	r1, r5
10005090:	443b      	add	r3, r7
10005092:	ea43 0301 	orr.w	r3, r3, r1
10005096:	ea4f 73d3 	mov.w	r3, r3, lsr #31
1000509a:	931a      	str	r3, [sp, #104]	@ 0x68
1000509c:	ea6b 0100 	orn	r1, fp, r0
100050a0:	eb60 030b 	sbc.w	r3, r0, fp
100050a4:	400b      	ands	r3, r1
100050a6:	ea2b 0100 	bic.w	r1, fp, r0
100050aa:	430b      	orrs	r3, r1
100050ac:	0fdb      	lsrs	r3, r3, #31
100050ae:	991a      	ldr	r1, [sp, #104]	@ 0x68
100050b0:	931b      	str	r3, [sp, #108]	@ 0x6c
100050b2:	9b1b      	ldr	r3, [sp, #108]	@ 0x6c
100050b4:	f083 0301 	eor.w	r3, r3, #1
100050b8:	430b      	orrs	r3, r1
100050ba:	4499      	add	r9, r3
100050bc:	425b      	negs	r3, r3
100050be:	eb6c 010c 	sbc.w	r1, ip, ip
100050c2:	ea03 030a 	and.w	r3, r3, sl
100050c6:	1ad3      	subs	r3, r2, r3
100050c8:	ea01 010b 	and.w	r1, r1, fp
100050cc:	eb60 0101 	sbc.w	r1, r0, r1
100050d0:	980f      	ldr	r0, [sp, #60]	@ 0x3c
100050d2:	e9dd ab0c 	ldrd	sl, fp, [sp, #48]	@ 0x30
100050d6:	eb1a 0000 	adds.w	r0, sl, r0
100050da:	f14b 0200 	adc.w	r2, fp, #0
100050de:	1a18      	subs	r0, r3, r0
100050e0:	eb61 0302 	sbc.w	r3, r1, r2
100050e4:	ea62 0001 	orn	r0, r2, r1
100050e8:	4003      	ands	r3, r0
100050ea:	ea22 0201 	bic.w	r2, r2, r1
100050ee:	4313      	orrs	r3, r2
100050f0:	0fdb      	lsrs	r3, r3, #31
100050f2:	9314      	str	r3, [sp, #80]	@ 0x50
100050f4:	9b14      	ldr	r3, [sp, #80]	@ 0x50
100050f6:	eba9 79d5 	sub.w	r9, r9, r5, lsr #31
100050fa:	f083 0301 	eor.w	r3, r3, #1
100050fe:	9d0a      	ldr	r5, [sp, #40]	@ 0x28
10005100:	eb13 0309 	adds.w	r3, r3, r9
10005104:	f148 0200 	adc.w	r2, r8, #0
10005108:	4269      	negs	r1, r5
1000510a:	9102      	str	r1, [sp, #8]
1000510c:	eb6c 010c 	sbc.w	r1, ip, ip
10005110:	9103      	str	r1, [sp, #12]
10005112:	9f0e      	ldr	r7, [sp, #56]	@ 0x38
10005114:	9810      	ldr	r0, [sp, #64]	@ 0x40
10005116:	9e11      	ldr	r6, [sp, #68]	@ 0x44
10005118:	19c0      	adds	r0, r0, r7
1000511a:	9c12      	ldr	r4, [sp, #72]	@ 0x48
1000511c:	9d13      	ldr	r5, [sp, #76]	@ 0x4c
1000511e:	f166 0100 	sbc.w	r1, r6, #0
10005122:	4058      	eors	r0, r3
10005124:	e9dd 8902 	ldrd	r8, r9, [sp, #8]
10005128:	e9cd 8920 	strd	r8, r9, [sp, #128]	@ 0x80
1000512c:	e9dd 6720 	ldrd	r6, r7, [sp, #128]	@ 0x80
10005130:	405c      	eors	r4, r3
10005132:	4051      	eors	r1, r2
10005134:	ea85 0302 	eor.w	r3, r5, r2
10005138:	4030      	ands	r0, r6
1000513a:	9a0b      	ldr	r2, [sp, #44]	@ 0x2c
1000513c:	4039      	ands	r1, r7
1000513e:	4060      	eors	r0, r4
10005140:	1880      	adds	r0, r0, r2
10005142:	ea81 0103 	eor.w	r1, r1, r3
10005146:	f141 0100 	adc.w	r1, r1, #0
1000514a:	b027      	add	sp, #156	@ 0x9c
1000514c:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10005150:	00000000 	.word	0x00000000
10005154:	41f00000 	.word	0x41f00000
10005158:	00000000 	.word	0x00000000
1000515c:	3df00000 	.word	0x3df00000
10005160:	be100000 	.word	0xbe100000
10005164:	41efffff 	.word	0x41efffff
10005168:	ffe00000 	.word	0xffe00000
