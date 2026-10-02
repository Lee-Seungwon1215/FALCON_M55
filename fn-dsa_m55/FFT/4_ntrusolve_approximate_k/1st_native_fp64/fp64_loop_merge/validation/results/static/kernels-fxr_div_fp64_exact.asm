10000e38 <fxr_div_fp64_exact>:
10000e38:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10000e3c:	4607      	mov	r7, r0
10000e3e:	f04f 0c00 	mov.w	ip, #0
10000e42:	ea4f 79d1 	mov.w	r9, r1, lsr #31
10000e46:	ea4f 78d3 	mov.w	r8, r3, lsr #31
10000e4a:	ea82 74e3 	eor.w	r4, r2, r3, asr #31
10000e4e:	ea83 75e3 	eor.w	r5, r3, r3, asr #31
10000e52:	ea89 0308 	eor.w	r3, r9, r8
10000e56:	b0a7      	sub	sp, #156	@ 0x9c
10000e58:	425a      	negs	r2, r3
10000e5a:	ea87 77e1 	eor.w	r7, r7, r1, asr #31
10000e5e:	ea81 76e1 	eor.w	r6, r1, r1, asr #31
10000e62:	9212      	str	r2, [sp, #72]	@ 0x48
10000e64:	9213      	str	r2, [sp, #76]	@ 0x4c
10000e66:	eb17 0209 	adds.w	r2, r7, r9
10000e6a:	930b      	str	r3, [sp, #44]	@ 0x2c
10000e6c:	f146 0300 	adc.w	r3, r6, #0
10000e70:	eb14 0408 	adds.w	r4, r4, r8
10000e74:	f145 0500 	adc.w	r5, r5, #0
10000e78:	ea45 0604 	orr.w	r6, r5, r4
10000e7c:	462f      	mov	r7, r5
10000e7e:	ee07 5a90 	vmov	s15, r5
10000e82:	4275      	negs	r5, r6
10000e84:	4335      	orrs	r5, r6
10000e86:	0fed      	lsrs	r5, r5, #31
10000e88:	9517      	str	r5, [sp, #92]	@ 0x5c
10000e8a:	9d17      	ldr	r5, [sp, #92]	@ 0x5c
10000e8c:	ed9f 6bce 	vldr	d6, [pc, #824]	@ 100011c8 <fxr_div_fp64_exact+0x390>
10000e90:	f085 0501 	eor.w	r5, r5, #1
10000e94:	f115 3aff 	adds.w	sl, r5, #4294967295	@ 0xffffffff
10000e98:	f14c 38ff 	adc.w	r8, ip, #4294967295	@ 0xffffffff
10000e9c:	ea08 0803 	and.w	r8, r8, r3
10000ea0:	ea0a 0602 	and.w	r6, sl, r2
10000ea4:	ee02 6a90 	vmov	s5, r6
10000ea8:	ee05 8a90 	vmov	s11, r8
10000eac:	eeb8 4b67 	vcvt.f64.u32	d4, s15
10000eb0:	eeb8 5b65 	vcvt.f64.u32	d5, s11
10000eb4:	eeb8 7b62 	vcvt.f64.u32	d7, s5
10000eb8:	ea44 0a05 	orr.w	sl, r4, r5
10000ebc:	ee05 7b06 	vmla.f64	d7, d5, d6
10000ec0:	ee05 aa90 	vmov	s11, sl
10000ec4:	eeb8 5b65 	vcvt.f64.u32	d5, s11
10000ec8:	ee04 5b06 	vmla.f64	d5, d4, d6
10000ecc:	950a      	str	r5, [sp, #40]	@ 0x28
10000ece:	2400      	movs	r4, #0
10000ed0:	2500      	movs	r5, #0
10000ed2:	ee86 4b05 	vdiv.f64	d4, d6, d5
10000ed6:	17de      	asrs	r6, r3, #31
10000ed8:	46bb      	mov	fp, r7
10000eda:	9611      	str	r6, [sp, #68]	@ 0x44
10000edc:	9709      	str	r7, [sp, #36]	@ 0x24
10000ede:	4626      	mov	r6, r4
10000ee0:	462f      	mov	r7, r5
10000ee2:	ed9f 3bbb 	vldr	d3, [pc, #748]	@ 100011d0 <fxr_div_fp64_exact+0x398>
10000ee6:	ee27 7b04 	vmul.f64	d7, d7, d4
10000eea:	e9cd 6700 	strd	r6, r7, [sp]
10000eee:	e9cd 6704 	strd	r6, r7, [sp, #16]
10000ef2:	e9cd 6706 	strd	r6, r7, [sp, #24]
10000ef6:	4616      	mov	r6, r2
10000ef8:	461f      	mov	r7, r3
10000efa:	ee27 7b03 	vmul.f64	d7, d7, d3
10000efe:	ea52 73df 	lsrl	r2, r3, #31
10000f02:	ea56 779f 	lsrl	r6, r7, #30
10000f06:	ed8d 7b02 	vstr	d7, [sp, #8]
10000f0a:	43d7      	mvns	r7, r2
10000f0c:	43f6      	mvns	r6, r6
10000f0e:	f8df e2d0 	ldr.w	lr, [pc, #720]	@ 100011e0 <fxr_div_fp64_exact+0x3a8>
10000f12:	f00a 0101 	and.w	r1, sl, #1
10000f16:	48b0      	ldr	r0, [pc, #704]	@ (100011d8 <fxr_div_fp64_exact+0x3a0>)
10000f18:	910f      	str	r1, [sp, #60]	@ 0x3c
10000f1a:	49b0      	ldr	r1, [pc, #704]	@ (100011dc <fxr_div_fp64_exact+0x3a4>)
10000f1c:	970e      	str	r7, [sp, #56]	@ 0x38
10000f1e:	e9dd 9702 	ldrd	r9, r7, [sp, #8]
10000f22:	ebbe 0209 	subs.w	r2, lr, r9
10000f26:	eb61 0207 	sbc.w	r2, r1, r7
10000f2a:	f006 0301 	and.w	r3, r6, #1
10000f2e:	ea47 0600 	orr.w	r6, r7, r0
10000f32:	4032      	ands	r2, r6
10000f34:	ea07 0600 	and.w	r6, r7, r0
10000f38:	4332      	orrs	r2, r6
10000f3a:	0fd2      	lsrs	r2, r2, #31
10000f3c:	9216      	str	r2, [sp, #88]	@ 0x58
10000f3e:	9a16      	ldr	r2, [sp, #88]	@ 0x58
10000f40:	9310      	str	r3, [sp, #64]	@ 0x40
10000f42:	4254      	negs	r4, r2
10000f44:	eb6c 050c 	sbc.w	r5, ip, ip
10000f48:	e9cd 4524 	strd	r4, r5, [sp, #144]	@ 0x90
10000f4c:	e9dd 2324 	ldrd	r2, r3, [sp, #144]	@ 0x90
10000f50:	ea89 050e 	eor.w	r5, r9, lr
10000f54:	ea87 0401 	eor.w	r4, r7, r1
10000f58:	4015      	ands	r5, r2
10000f5a:	401c      	ands	r4, r3
10000f5c:	ea85 0209 	eor.w	r2, r5, r9
10000f60:	407c      	eors	r4, r7
10000f62:	9200      	str	r2, [sp, #0]
10000f64:	9401      	str	r4, [sp, #4]
10000f66:	ed9d 7b00 	vldr	d7, [sp]
10000f6a:	4654      	mov	r4, sl
10000f6c:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10000f70:	465d      	mov	r5, fp
10000f72:	ee17 6a90 	vmov	r6, s15
10000f76:	ea54 055f 	lsrl	r4, r5, #1
10000f7a:	2200      	movs	r2, #0
10000f7c:	2300      	movs	r3, #0
10000f7e:	ee12 9a90 	vmov	r9, s5
10000f82:	e9cd 450c 	strd	r4, r5, [sp, #48]	@ 0x30
10000f86:	e9cd 2302 	strd	r2, r3, [sp, #8]
10000f8a:	fba6 420a 	umull	r4, r2, r6, sl
10000f8e:	ebb9 0304 	subs.w	r3, r9, r4
10000f92:	46e1      	mov	r9, ip
10000f94:	fbeb 2906 	umlal	r2, r9, fp, r6
10000f98:	eb68 0602 	sbc.w	r6, r8, r2
10000f9c:	ea62 0408 	orn	r4, r2, r8
10000fa0:	4034      	ands	r4, r6
10000fa2:	ea22 0208 	bic.w	r2, r2, r8
10000fa6:	4314      	orrs	r4, r2
10000fa8:	0fe4      	lsrs	r4, r4, #31
10000faa:	941c      	str	r4, [sp, #112]	@ 0x70
10000fac:	9a1c      	ldr	r2, [sp, #112]	@ 0x70
10000fae:	edcd 7a00 	vstr	s15, [sp]
10000fb2:	eb09 0802 	add.w	r8, r9, r2
10000fb6:	f1c8 0700 	rsb	r7, r8, #0
10000fba:	ea0a 74e7 	and.w	r4, sl, r7, asr #31
10000fbe:	191b      	adds	r3, r3, r4
10000fc0:	ea0b 74e7 	and.w	r4, fp, r7, asr #31
10000fc4:	4621      	mov	r1, r4
10000fc6:	eb46 0504 	adc.w	r5, r6, r4
10000fca:	ebb3 040a 	subs.w	r4, r3, sl
10000fce:	ea66 0405 	orn	r4, r6, r5
10000fd2:	ea04 0401 	and.w	r4, r4, r1
10000fd6:	ea26 0605 	bic.w	r6, r6, r5
10000fda:	ea44 0406 	orr.w	r4, r4, r6
10000fde:	ee17 6a90 	vmov	r6, s15
10000fe2:	ea4f 74d4 	mov.w	r4, r4, lsr #31
10000fe6:	941d      	str	r4, [sp, #116]	@ 0x74
10000fe8:	9c1d      	ldr	r4, [sp, #116]	@ 0x74
10000fea:	497c      	ldr	r1, [pc, #496]	@ (100011dc <fxr_div_fp64_exact+0x3a4>)
10000fec:	eba2 0204 	sub.w	r2, r2, r4
10000ff0:	444a      	add	r2, r9
10000ff2:	eba4 0408 	sub.w	r4, r4, r8
10000ff6:	ea42 0204 	orr.w	r2, r2, r4
10000ffa:	ea4f 72d2 	mov.w	r2, r2, lsr #31
10000ffe:	921e      	str	r2, [sp, #120]	@ 0x78
10001000:	ea6b 0405 	orn	r4, fp, r5
10001004:	eb65 020b 	sbc.w	r2, r5, fp
10001008:	4022      	ands	r2, r4
1000100a:	ea2b 0405 	bic.w	r4, fp, r5
1000100e:	4322      	orrs	r2, r4
10001010:	0fd2      	lsrs	r2, r2, #31
10001012:	9c1e      	ldr	r4, [sp, #120]	@ 0x78
10001014:	921f      	str	r2, [sp, #124]	@ 0x7c
10001016:	9a1f      	ldr	r2, [sp, #124]	@ 0x7c
10001018:	f082 0201 	eor.w	r2, r2, #1
1000101c:	4322      	orrs	r2, r4
1000101e:	18b4      	adds	r4, r6, r2
10001020:	4252      	negs	r2, r2
10001022:	eba4 78d7 	sub.w	r8, r4, r7, lsr #31
10001026:	ea02 020a 	and.w	r2, r2, sl
1000102a:	eb6c 040c 	sbc.w	r4, ip, ip
1000102e:	ea04 040b 	and.w	r4, r4, fp
10001032:	1a9b      	subs	r3, r3, r2
10001034:	eb65 0404 	sbc.w	r4, r5, r4
10001038:	ee07 4a90 	vmov	s15, r4
1000103c:	eeb8 5b67 	vcvt.f64.u32	d5, s15
10001040:	ee07 3a90 	vmov	s15, r3
10001044:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10001048:	ee05 7b06 	vmla.f64	d7, d5, d6
1000104c:	ee27 7b04 	vmul.f64	d7, d7, d4
10001050:	ed8d 7b00 	vstr	d7, [sp]
10001054:	e9dd 5200 	ldrd	r5, r2, [sp]
10001058:	ebbe 0605 	subs.w	r6, lr, r5
1000105c:	eb61 0702 	sbc.w	r7, r1, r2
10001060:	ea82 0601 	eor.w	r6, r2, r1
10001064:	ea42 0100 	orr.w	r1, r2, r0
10001068:	4039      	ands	r1, r7
1000106a:	4010      	ands	r0, r2
1000106c:	4301      	orrs	r1, r0
1000106e:	0fc9      	lsrs	r1, r1, #31
10001070:	9115      	str	r1, [sp, #84]	@ 0x54
10001072:	9915      	ldr	r1, [sp, #84]	@ 0x54
10001074:	ea85 0e0e 	eor.w	lr, r5, lr
10001078:	4249      	negs	r1, r1
1000107a:	9104      	str	r1, [sp, #16]
1000107c:	eb6c 010c 	sbc.w	r1, ip, ip
10001080:	9105      	str	r1, [sp, #20]
10001082:	e9dd 0104 	ldrd	r0, r1, [sp, #16]
10001086:	e9cd 0122 	strd	r0, r1, [sp, #136]	@ 0x88
1000108a:	e9dd 0122 	ldrd	r0, r1, [sp, #136]	@ 0x88
1000108e:	ea0e 0e00 	and.w	lr, lr, r0
10001092:	4031      	ands	r1, r6
10001094:	404a      	eors	r2, r1
10001096:	ea8e 0605 	eor.w	r6, lr, r5
1000109a:	9606      	str	r6, [sp, #24]
1000109c:	9207      	str	r2, [sp, #28]
1000109e:	ed9d 7b06 	vldr	d7, [sp, #24]
100010a2:	eefc 7bc7 	vcvt.u32.f64	s15, d7
100010a6:	ee17 9a90 	vmov	r9, s15
100010aa:	46e6      	mov	lr, ip
100010ac:	fba9 210a 	umull	r2, r1, r9, sl
100010b0:	fbeb 1e09 	umlal	r1, lr, fp, r9
100010b4:	4677      	mov	r7, lr
100010b6:	ebbc 0202 	subs.w	r2, ip, r2
100010ba:	eb63 0601 	sbc.w	r6, r3, r1
100010be:	ea61 0003 	orn	r0, r1, r3
100010c2:	4030      	ands	r0, r6
100010c4:	ea21 0103 	bic.w	r1, r1, r3
100010c8:	4308      	orrs	r0, r1
100010ca:	0fc0      	lsrs	r0, r0, #31
100010cc:	9018      	str	r0, [sp, #96]	@ 0x60
100010ce:	9b18      	ldr	r3, [sp, #96]	@ 0x60
100010d0:	1ae5      	subs	r5, r4, r3
100010d2:	1bed      	subs	r5, r5, r7
100010d4:	ea0a 71e5 	and.w	r1, sl, r5, asr #31
100010d8:	ea0b 7ee5 	and.w	lr, fp, r5, asr #31
100010dc:	1852      	adds	r2, r2, r1
100010de:	eb46 000e 	adc.w	r0, r6, lr
100010e2:	ebb2 010a 	subs.w	r1, r2, sl
100010e6:	ea66 0100 	orn	r1, r6, r0
100010ea:	ea01 010e 	and.w	r1, r1, lr
100010ee:	ea26 0600 	bic.w	r6, r6, r0
100010f2:	ea41 0106 	orr.w	r1, r1, r6
100010f6:	ea4f 71d1 	mov.w	r1, r1, lsr #31
100010fa:	9119      	str	r1, [sp, #100]	@ 0x64
100010fc:	9919      	ldr	r1, [sp, #100]	@ 0x64
100010fe:	eba3 0301 	sub.w	r3, r3, r1
10001102:	eba3 0304 	sub.w	r3, r3, r4
10001106:	4429      	add	r1, r5
10001108:	443b      	add	r3, r7
1000110a:	ea43 0301 	orr.w	r3, r3, r1
1000110e:	ea4f 73d3 	mov.w	r3, r3, lsr #31
10001112:	931a      	str	r3, [sp, #104]	@ 0x68
10001114:	ea6b 0100 	orn	r1, fp, r0
10001118:	eb60 030b 	sbc.w	r3, r0, fp
1000111c:	400b      	ands	r3, r1
1000111e:	ea2b 0100 	bic.w	r1, fp, r0
10001122:	430b      	orrs	r3, r1
10001124:	0fdb      	lsrs	r3, r3, #31
10001126:	991a      	ldr	r1, [sp, #104]	@ 0x68
10001128:	931b      	str	r3, [sp, #108]	@ 0x6c
1000112a:	9b1b      	ldr	r3, [sp, #108]	@ 0x6c
1000112c:	f083 0301 	eor.w	r3, r3, #1
10001130:	430b      	orrs	r3, r1
10001132:	4499      	add	r9, r3
10001134:	425b      	negs	r3, r3
10001136:	eb6c 010c 	sbc.w	r1, ip, ip
1000113a:	ea03 030a 	and.w	r3, r3, sl
1000113e:	1ad3      	subs	r3, r2, r3
10001140:	ea01 010b 	and.w	r1, r1, fp
10001144:	eb60 0101 	sbc.w	r1, r0, r1
10001148:	980f      	ldr	r0, [sp, #60]	@ 0x3c
1000114a:	e9dd ab0c 	ldrd	sl, fp, [sp, #48]	@ 0x30
1000114e:	eb1a 0000 	adds.w	r0, sl, r0
10001152:	f14b 0200 	adc.w	r2, fp, #0
10001156:	1a18      	subs	r0, r3, r0
10001158:	eb61 0302 	sbc.w	r3, r1, r2
1000115c:	ea62 0001 	orn	r0, r2, r1
10001160:	4003      	ands	r3, r0
10001162:	ea22 0201 	bic.w	r2, r2, r1
10001166:	4313      	orrs	r3, r2
10001168:	0fdb      	lsrs	r3, r3, #31
1000116a:	9314      	str	r3, [sp, #80]	@ 0x50
1000116c:	9b14      	ldr	r3, [sp, #80]	@ 0x50
1000116e:	eba9 79d5 	sub.w	r9, r9, r5, lsr #31
10001172:	f083 0301 	eor.w	r3, r3, #1
10001176:	9d0a      	ldr	r5, [sp, #40]	@ 0x28
10001178:	eb13 0309 	adds.w	r3, r3, r9
1000117c:	f148 0200 	adc.w	r2, r8, #0
10001180:	4269      	negs	r1, r5
10001182:	9102      	str	r1, [sp, #8]
10001184:	eb6c 010c 	sbc.w	r1, ip, ip
10001188:	9103      	str	r1, [sp, #12]
1000118a:	9f0e      	ldr	r7, [sp, #56]	@ 0x38
1000118c:	9810      	ldr	r0, [sp, #64]	@ 0x40
1000118e:	9e11      	ldr	r6, [sp, #68]	@ 0x44
10001190:	19c0      	adds	r0, r0, r7
10001192:	9c12      	ldr	r4, [sp, #72]	@ 0x48
10001194:	9d13      	ldr	r5, [sp, #76]	@ 0x4c
10001196:	f166 0100 	sbc.w	r1, r6, #0
1000119a:	4058      	eors	r0, r3
1000119c:	e9dd 8902 	ldrd	r8, r9, [sp, #8]
100011a0:	e9cd 8920 	strd	r8, r9, [sp, #128]	@ 0x80
100011a4:	e9dd 6720 	ldrd	r6, r7, [sp, #128]	@ 0x80
100011a8:	405c      	eors	r4, r3
100011aa:	4051      	eors	r1, r2
100011ac:	ea85 0302 	eor.w	r3, r5, r2
100011b0:	4030      	ands	r0, r6
100011b2:	9a0b      	ldr	r2, [sp, #44]	@ 0x2c
100011b4:	4039      	ands	r1, r7
100011b6:	4060      	eors	r0, r4
100011b8:	1880      	adds	r0, r0, r2
100011ba:	ea81 0103 	eor.w	r1, r1, r3
100011be:	f141 0100 	adc.w	r1, r1, #0
100011c2:	b027      	add	sp, #156	@ 0x9c
100011c4:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
100011c8:	00000000 	.word	0x00000000
100011cc:	41f00000 	.word	0x41f00000
100011d0:	00000000 	.word	0x00000000
100011d4:	3df00000 	.word	0x3df00000
100011d8:	be100000 	.word	0xbe100000
100011dc:	41efffff 	.word	0x41efffff
100011e0:	ffe00000 	.word	0xffe00000
100011e4:	00000000 	.word	0x00000000

