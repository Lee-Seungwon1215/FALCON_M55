
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/r2-kernels/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10000b80 <fxr_div_fp64_exact>:
10000b80:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10000b84:	4607      	mov	r7, r0
10000b86:	f04f 0c00 	mov.w	ip, #0
10000b8a:	ea4f 79d1 	mov.w	r9, r1, lsr #31
10000b8e:	ea4f 78d3 	mov.w	r8, r3, lsr #31
10000b92:	ea82 74e3 	eor.w	r4, r2, r3, asr #31
10000b96:	ea83 75e3 	eor.w	r5, r3, r3, asr #31
10000b9a:	ea89 0308 	eor.w	r3, r9, r8
10000b9e:	b0a7      	sub	sp, #156	@ 0x9c
10000ba0:	425a      	negs	r2, r3
10000ba2:	ea87 77e1 	eor.w	r7, r7, r1, asr #31
10000ba6:	ea81 76e1 	eor.w	r6, r1, r1, asr #31
10000baa:	9212      	str	r2, [sp, #72]	@ 0x48
10000bac:	9213      	str	r2, [sp, #76]	@ 0x4c
10000bae:	eb17 0209 	adds.w	r2, r7, r9
10000bb2:	930b      	str	r3, [sp, #44]	@ 0x2c
10000bb4:	f146 0300 	adc.w	r3, r6, #0
10000bb8:	eb14 0408 	adds.w	r4, r4, r8
10000bbc:	f145 0500 	adc.w	r5, r5, #0
10000bc0:	ea45 0604 	orr.w	r6, r5, r4
10000bc4:	462f      	mov	r7, r5
10000bc6:	ee07 5a90 	vmov	s15, r5
10000bca:	4275      	negs	r5, r6
10000bcc:	4335      	orrs	r5, r6
10000bce:	0fed      	lsrs	r5, r5, #31
10000bd0:	9517      	str	r5, [sp, #92]	@ 0x5c
10000bd2:	9d17      	ldr	r5, [sp, #92]	@ 0x5c
10000bd4:	ed9f 6bce 	vldr	d6, [pc, #824]	@ 10000f10 <fxr_div_fp64_exact+0x390>
10000bd8:	f085 0501 	eor.w	r5, r5, #1
10000bdc:	f115 3aff 	adds.w	sl, r5, #4294967295	@ 0xffffffff
10000be0:	f14c 38ff 	adc.w	r8, ip, #4294967295	@ 0xffffffff
10000be4:	ea08 0803 	and.w	r8, r8, r3
10000be8:	ea0a 0602 	and.w	r6, sl, r2
10000bec:	ee02 6a90 	vmov	s5, r6
10000bf0:	ee05 8a90 	vmov	s11, r8
10000bf4:	eeb8 4b67 	vcvt.f64.u32	d4, s15
10000bf8:	eeb8 5b65 	vcvt.f64.u32	d5, s11
10000bfc:	eeb8 7b62 	vcvt.f64.u32	d7, s5
10000c00:	ea44 0a05 	orr.w	sl, r4, r5
10000c04:	ee05 7b06 	vmla.f64	d7, d5, d6
10000c08:	ee05 aa90 	vmov	s11, sl
10000c0c:	eeb8 5b65 	vcvt.f64.u32	d5, s11
10000c10:	ee04 5b06 	vmla.f64	d5, d4, d6
10000c14:	950a      	str	r5, [sp, #40]	@ 0x28
10000c16:	2400      	movs	r4, #0
10000c18:	2500      	movs	r5, #0
10000c1a:	ee86 4b05 	vdiv.f64	d4, d6, d5
10000c1e:	17de      	asrs	r6, r3, #31
10000c20:	46bb      	mov	fp, r7
10000c22:	9611      	str	r6, [sp, #68]	@ 0x44
10000c24:	9709      	str	r7, [sp, #36]	@ 0x24
10000c26:	4626      	mov	r6, r4
10000c28:	462f      	mov	r7, r5
10000c2a:	ed9f 3bbb 	vldr	d3, [pc, #748]	@ 10000f18 <fxr_div_fp64_exact+0x398>
10000c2e:	ee27 7b04 	vmul.f64	d7, d7, d4
10000c32:	e9cd 6700 	strd	r6, r7, [sp]
10000c36:	e9cd 6704 	strd	r6, r7, [sp, #16]
10000c3a:	e9cd 6706 	strd	r6, r7, [sp, #24]
10000c3e:	4616      	mov	r6, r2
10000c40:	461f      	mov	r7, r3
10000c42:	ee27 7b03 	vmul.f64	d7, d7, d3
10000c46:	ea52 73df 	lsrl	r2, r3, #31
10000c4a:	ea56 779f 	lsrl	r6, r7, #30
10000c4e:	ed8d 7b02 	vstr	d7, [sp, #8]
10000c52:	43d7      	mvns	r7, r2
10000c54:	43f6      	mvns	r6, r6
10000c56:	f8df e2d0 	ldr.w	lr, [pc, #720]	@ 10000f28 <fxr_div_fp64_exact+0x3a8>
10000c5a:	f00a 0101 	and.w	r1, sl, #1
10000c5e:	48b0      	ldr	r0, [pc, #704]	@ (10000f20 <fxr_div_fp64_exact+0x3a0>)
10000c60:	910f      	str	r1, [sp, #60]	@ 0x3c
10000c62:	49b0      	ldr	r1, [pc, #704]	@ (10000f24 <fxr_div_fp64_exact+0x3a4>)
10000c64:	970e      	str	r7, [sp, #56]	@ 0x38
10000c66:	e9dd 9702 	ldrd	r9, r7, [sp, #8]
10000c6a:	ebbe 0209 	subs.w	r2, lr, r9
10000c6e:	eb61 0207 	sbc.w	r2, r1, r7
10000c72:	f006 0301 	and.w	r3, r6, #1
10000c76:	ea47 0600 	orr.w	r6, r7, r0
10000c7a:	4032      	ands	r2, r6
10000c7c:	ea07 0600 	and.w	r6, r7, r0
10000c80:	4332      	orrs	r2, r6
10000c82:	0fd2      	lsrs	r2, r2, #31
10000c84:	9216      	str	r2, [sp, #88]	@ 0x58
10000c86:	9a16      	ldr	r2, [sp, #88]	@ 0x58
10000c88:	9310      	str	r3, [sp, #64]	@ 0x40
10000c8a:	4254      	negs	r4, r2
10000c8c:	eb6c 050c 	sbc.w	r5, ip, ip
10000c90:	e9cd 4524 	strd	r4, r5, [sp, #144]	@ 0x90
10000c94:	e9dd 2324 	ldrd	r2, r3, [sp, #144]	@ 0x90
10000c98:	ea89 050e 	eor.w	r5, r9, lr
10000c9c:	ea87 0401 	eor.w	r4, r7, r1
10000ca0:	4015      	ands	r5, r2
10000ca2:	401c      	ands	r4, r3
10000ca4:	ea85 0209 	eor.w	r2, r5, r9
10000ca8:	407c      	eors	r4, r7
10000caa:	9200      	str	r2, [sp, #0]
10000cac:	9401      	str	r4, [sp, #4]
10000cae:	ed9d 7b00 	vldr	d7, [sp]
10000cb2:	4654      	mov	r4, sl
10000cb4:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10000cb8:	465d      	mov	r5, fp
10000cba:	ee17 6a90 	vmov	r6, s15
10000cbe:	ea54 055f 	lsrl	r4, r5, #1
10000cc2:	2200      	movs	r2, #0
10000cc4:	2300      	movs	r3, #0
10000cc6:	ee12 9a90 	vmov	r9, s5
10000cca:	e9cd 450c 	strd	r4, r5, [sp, #48]	@ 0x30
10000cce:	e9cd 2302 	strd	r2, r3, [sp, #8]
10000cd2:	fba6 420a 	umull	r4, r2, r6, sl
10000cd6:	ebb9 0304 	subs.w	r3, r9, r4
10000cda:	46e1      	mov	r9, ip
10000cdc:	fbeb 2906 	umlal	r2, r9, fp, r6
10000ce0:	eb68 0602 	sbc.w	r6, r8, r2
10000ce4:	ea62 0408 	orn	r4, r2, r8
10000ce8:	4034      	ands	r4, r6
10000cea:	ea22 0208 	bic.w	r2, r2, r8
10000cee:	4314      	orrs	r4, r2
10000cf0:	0fe4      	lsrs	r4, r4, #31
10000cf2:	941c      	str	r4, [sp, #112]	@ 0x70
10000cf4:	9a1c      	ldr	r2, [sp, #112]	@ 0x70
10000cf6:	edcd 7a00 	vstr	s15, [sp]
10000cfa:	eb09 0802 	add.w	r8, r9, r2
10000cfe:	f1c8 0700 	rsb	r7, r8, #0
10000d02:	ea0a 74e7 	and.w	r4, sl, r7, asr #31
10000d06:	191b      	adds	r3, r3, r4
10000d08:	ea0b 74e7 	and.w	r4, fp, r7, asr #31
10000d0c:	4621      	mov	r1, r4
10000d0e:	eb46 0504 	adc.w	r5, r6, r4
10000d12:	ebb3 040a 	subs.w	r4, r3, sl
10000d16:	ea66 0405 	orn	r4, r6, r5
10000d1a:	ea04 0401 	and.w	r4, r4, r1
10000d1e:	ea26 0605 	bic.w	r6, r6, r5
10000d22:	ea44 0406 	orr.w	r4, r4, r6
10000d26:	ee17 6a90 	vmov	r6, s15
10000d2a:	ea4f 74d4 	mov.w	r4, r4, lsr #31
10000d2e:	941d      	str	r4, [sp, #116]	@ 0x74
10000d30:	9c1d      	ldr	r4, [sp, #116]	@ 0x74
10000d32:	497c      	ldr	r1, [pc, #496]	@ (10000f24 <fxr_div_fp64_exact+0x3a4>)
10000d34:	eba2 0204 	sub.w	r2, r2, r4
10000d38:	444a      	add	r2, r9
10000d3a:	eba4 0408 	sub.w	r4, r4, r8
10000d3e:	ea42 0204 	orr.w	r2, r2, r4
10000d42:	ea4f 72d2 	mov.w	r2, r2, lsr #31
10000d46:	921e      	str	r2, [sp, #120]	@ 0x78
10000d48:	ea6b 0405 	orn	r4, fp, r5
10000d4c:	eb65 020b 	sbc.w	r2, r5, fp
10000d50:	4022      	ands	r2, r4
10000d52:	ea2b 0405 	bic.w	r4, fp, r5
10000d56:	4322      	orrs	r2, r4
10000d58:	0fd2      	lsrs	r2, r2, #31
10000d5a:	9c1e      	ldr	r4, [sp, #120]	@ 0x78
10000d5c:	921f      	str	r2, [sp, #124]	@ 0x7c
10000d5e:	9a1f      	ldr	r2, [sp, #124]	@ 0x7c
10000d60:	f082 0201 	eor.w	r2, r2, #1
10000d64:	4322      	orrs	r2, r4
10000d66:	18b4      	adds	r4, r6, r2
10000d68:	4252      	negs	r2, r2
10000d6a:	eba4 78d7 	sub.w	r8, r4, r7, lsr #31
10000d6e:	ea02 020a 	and.w	r2, r2, sl
10000d72:	eb6c 040c 	sbc.w	r4, ip, ip
10000d76:	ea04 040b 	and.w	r4, r4, fp
10000d7a:	1a9b      	subs	r3, r3, r2
10000d7c:	eb65 0404 	sbc.w	r4, r5, r4
10000d80:	ee07 4a90 	vmov	s15, r4
10000d84:	eeb8 5b67 	vcvt.f64.u32	d5, s15
10000d88:	ee07 3a90 	vmov	s15, r3
10000d8c:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10000d90:	ee05 7b06 	vmla.f64	d7, d5, d6
10000d94:	ee27 7b04 	vmul.f64	d7, d7, d4
10000d98:	ed8d 7b00 	vstr	d7, [sp]
10000d9c:	e9dd 5200 	ldrd	r5, r2, [sp]
10000da0:	ebbe 0605 	subs.w	r6, lr, r5
10000da4:	eb61 0702 	sbc.w	r7, r1, r2
10000da8:	ea82 0601 	eor.w	r6, r2, r1
10000dac:	ea42 0100 	orr.w	r1, r2, r0
10000db0:	4039      	ands	r1, r7
10000db2:	4010      	ands	r0, r2
10000db4:	4301      	orrs	r1, r0
10000db6:	0fc9      	lsrs	r1, r1, #31
10000db8:	9115      	str	r1, [sp, #84]	@ 0x54
10000dba:	9915      	ldr	r1, [sp, #84]	@ 0x54
10000dbc:	ea85 0e0e 	eor.w	lr, r5, lr
10000dc0:	4249      	negs	r1, r1
10000dc2:	9104      	str	r1, [sp, #16]
10000dc4:	eb6c 010c 	sbc.w	r1, ip, ip
10000dc8:	9105      	str	r1, [sp, #20]
10000dca:	e9dd 0104 	ldrd	r0, r1, [sp, #16]
10000dce:	e9cd 0122 	strd	r0, r1, [sp, #136]	@ 0x88
10000dd2:	e9dd 0122 	ldrd	r0, r1, [sp, #136]	@ 0x88
10000dd6:	ea0e 0e00 	and.w	lr, lr, r0
10000dda:	4031      	ands	r1, r6
10000ddc:	404a      	eors	r2, r1
10000dde:	ea8e 0605 	eor.w	r6, lr, r5
10000de2:	9606      	str	r6, [sp, #24]
10000de4:	9207      	str	r2, [sp, #28]
10000de6:	ed9d 7b06 	vldr	d7, [sp, #24]
10000dea:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10000dee:	ee17 9a90 	vmov	r9, s15
10000df2:	46e6      	mov	lr, ip
10000df4:	fba9 210a 	umull	r2, r1, r9, sl
10000df8:	fbeb 1e09 	umlal	r1, lr, fp, r9
10000dfc:	4677      	mov	r7, lr
10000dfe:	ebbc 0202 	subs.w	r2, ip, r2
10000e02:	eb63 0601 	sbc.w	r6, r3, r1
10000e06:	ea61 0003 	orn	r0, r1, r3
10000e0a:	4030      	ands	r0, r6
10000e0c:	ea21 0103 	bic.w	r1, r1, r3
10000e10:	4308      	orrs	r0, r1
10000e12:	0fc0      	lsrs	r0, r0, #31
10000e14:	9018      	str	r0, [sp, #96]	@ 0x60
10000e16:	9b18      	ldr	r3, [sp, #96]	@ 0x60
10000e18:	1ae5      	subs	r5, r4, r3
10000e1a:	1bed      	subs	r5, r5, r7
10000e1c:	ea0a 71e5 	and.w	r1, sl, r5, asr #31
10000e20:	ea0b 7ee5 	and.w	lr, fp, r5, asr #31
10000e24:	1852      	adds	r2, r2, r1
10000e26:	eb46 000e 	adc.w	r0, r6, lr
10000e2a:	ebb2 010a 	subs.w	r1, r2, sl
10000e2e:	ea66 0100 	orn	r1, r6, r0
10000e32:	ea01 010e 	and.w	r1, r1, lr
10000e36:	ea26 0600 	bic.w	r6, r6, r0
10000e3a:	ea41 0106 	orr.w	r1, r1, r6
10000e3e:	ea4f 71d1 	mov.w	r1, r1, lsr #31
10000e42:	9119      	str	r1, [sp, #100]	@ 0x64
10000e44:	9919      	ldr	r1, [sp, #100]	@ 0x64
10000e46:	eba3 0301 	sub.w	r3, r3, r1
10000e4a:	eba3 0304 	sub.w	r3, r3, r4
10000e4e:	4429      	add	r1, r5
10000e50:	443b      	add	r3, r7
10000e52:	ea43 0301 	orr.w	r3, r3, r1
10000e56:	ea4f 73d3 	mov.w	r3, r3, lsr #31
10000e5a:	931a      	str	r3, [sp, #104]	@ 0x68
10000e5c:	ea6b 0100 	orn	r1, fp, r0
10000e60:	eb60 030b 	sbc.w	r3, r0, fp
10000e64:	400b      	ands	r3, r1
10000e66:	ea2b 0100 	bic.w	r1, fp, r0
10000e6a:	430b      	orrs	r3, r1
10000e6c:	0fdb      	lsrs	r3, r3, #31
10000e6e:	991a      	ldr	r1, [sp, #104]	@ 0x68
10000e70:	931b      	str	r3, [sp, #108]	@ 0x6c
10000e72:	9b1b      	ldr	r3, [sp, #108]	@ 0x6c
10000e74:	f083 0301 	eor.w	r3, r3, #1
10000e78:	430b      	orrs	r3, r1
10000e7a:	4499      	add	r9, r3
10000e7c:	425b      	negs	r3, r3
10000e7e:	eb6c 010c 	sbc.w	r1, ip, ip
10000e82:	ea03 030a 	and.w	r3, r3, sl
10000e86:	1ad3      	subs	r3, r2, r3
10000e88:	ea01 010b 	and.w	r1, r1, fp
10000e8c:	eb60 0101 	sbc.w	r1, r0, r1
10000e90:	980f      	ldr	r0, [sp, #60]	@ 0x3c
10000e92:	e9dd ab0c 	ldrd	sl, fp, [sp, #48]	@ 0x30
10000e96:	eb1a 0000 	adds.w	r0, sl, r0
10000e9a:	f14b 0200 	adc.w	r2, fp, #0
10000e9e:	1a18      	subs	r0, r3, r0
10000ea0:	eb61 0302 	sbc.w	r3, r1, r2
10000ea4:	ea62 0001 	orn	r0, r2, r1
10000ea8:	4003      	ands	r3, r0
10000eaa:	ea22 0201 	bic.w	r2, r2, r1
10000eae:	4313      	orrs	r3, r2
10000eb0:	0fdb      	lsrs	r3, r3, #31
10000eb2:	9314      	str	r3, [sp, #80]	@ 0x50
10000eb4:	9b14      	ldr	r3, [sp, #80]	@ 0x50
10000eb6:	eba9 79d5 	sub.w	r9, r9, r5, lsr #31
10000eba:	f083 0301 	eor.w	r3, r3, #1
10000ebe:	9d0a      	ldr	r5, [sp, #40]	@ 0x28
10000ec0:	eb13 0309 	adds.w	r3, r3, r9
10000ec4:	f148 0200 	adc.w	r2, r8, #0
10000ec8:	4269      	negs	r1, r5
10000eca:	9102      	str	r1, [sp, #8]
10000ecc:	eb6c 010c 	sbc.w	r1, ip, ip
10000ed0:	9103      	str	r1, [sp, #12]
10000ed2:	9f0e      	ldr	r7, [sp, #56]	@ 0x38
10000ed4:	9810      	ldr	r0, [sp, #64]	@ 0x40
10000ed6:	9e11      	ldr	r6, [sp, #68]	@ 0x44
10000ed8:	19c0      	adds	r0, r0, r7
10000eda:	9c12      	ldr	r4, [sp, #72]	@ 0x48
10000edc:	9d13      	ldr	r5, [sp, #76]	@ 0x4c
10000ede:	f166 0100 	sbc.w	r1, r6, #0
10000ee2:	4058      	eors	r0, r3
10000ee4:	e9dd 8902 	ldrd	r8, r9, [sp, #8]
10000ee8:	e9cd 8920 	strd	r8, r9, [sp, #128]	@ 0x80
10000eec:	e9dd 6720 	ldrd	r6, r7, [sp, #128]	@ 0x80
10000ef0:	405c      	eors	r4, r3
10000ef2:	4051      	eors	r1, r2
10000ef4:	ea85 0302 	eor.w	r3, r5, r2
10000ef8:	4030      	ands	r0, r6
10000efa:	9a0b      	ldr	r2, [sp, #44]	@ 0x2c
10000efc:	4039      	ands	r1, r7
10000efe:	4060      	eors	r0, r4
10000f00:	1880      	adds	r0, r0, r2
10000f02:	ea81 0103 	eor.w	r1, r1, r3
10000f06:	f141 0100 	adc.w	r1, r1, #0
10000f0a:	b027      	add	sp, #156	@ 0x9c
10000f0c:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10000f10:	00000000 	.word	0x00000000
10000f14:	41f00000 	.word	0x41f00000
10000f18:	00000000 	.word	0x00000000
10000f1c:	3df00000 	.word	0x3df00000
10000f20:	be100000 	.word	0xbe100000
10000f24:	41efffff 	.word	0x41efffff
10000f28:	ffe00000 	.word	0xffe00000
