10007a98 <fndsa_vect_mul_fft_fp64_exact>:
10007a98:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10007a9c:	2310      	movs	r3, #16
10007a9e:	ed2d 8b10 	vpush	{d8-d15}
10007aa2:	3801      	subs	r0, #1
10007aa4:	4083      	lsls	r3, r0
10007aa6:	f1a3 0e10 	sub.w	lr, r3, #16
10007aaa:	ea4f 1e1e 	mov.w	lr, lr, lsr #4
10007aae:	b0bb      	sub	sp, #236	@ 0xec
10007ab0:	eb01 0b03 	add.w	fp, r1, r3
10007ab4:	f10e 0e01 	add.w	lr, lr, #1
10007ab8:	18d3      	adds	r3, r2, r3
10007aba:	e9cd 3b1f 	strd	r3, fp, [sp, #124]	@ 0x7c
10007abe:	2700      	movs	r7, #0
10007ac0:	ed9f fb09 	vldr	d15, [pc, #36]	@ 10007ae8 <fndsa_vect_mul_fft_fp64_exact+0x50>
10007ac4:	ed9f cb0a 	vldr	d12, [pc, #40]	@ 10007af0 <fndsa_vect_mul_fft_fp64_exact+0x58>
10007ac8:	eeb7 bb00 	vmov.f64	d11, #112	@ 0x3f800000  1.0
10007acc:	f04e e001 	dls	lr, lr
10007ad0:	4693      	mov	fp, r2
10007ad2:	f10d 0aa8 	add.w	sl, sp, #168	@ 0xa8
10007ad6:	f10d 09b8 	add.w	r9, sp, #184	@ 0xb8
10007ada:	f10d 08c8 	add.w	r8, sp, #200	@ 0xc8
10007ade:	9121      	str	r1, [sp, #132]	@ 0x84
10007ae0:	e00a      	b.n	10007af8 <fndsa_vect_mul_fft_fp64_exact+0x60>
10007ae2:	bf00      	nop
10007ae4:	f3af 8000 	nop.w
10007ae8:	00000000 	.word	0x00000000
10007aec:	3df00000 	.word	0x3df00000
10007af0:	00000000 	.word	0x00000000
10007af4:	41f00000 	.word	0x41f00000
10007af8:	9b21      	ldr	r3, [sp, #132]	@ 0x84
10007afa:	eb0b 0c07 	add.w	ip, fp, r7
10007afe:	19dd      	adds	r5, r3, r7
10007b00:	9b20      	ldr	r3, [sp, #128]	@ 0x80
10007b02:	19dc      	adds	r4, r3, r7
10007b04:	9b1f      	ldr	r3, [sp, #124]	@ 0x7c
10007b06:	19de      	adds	r6, r3, r7
10007b08:	e895 000f 	ldmia.w	r5, {r0, r1, r2, r3}
10007b0c:	e88a 000f 	stmia.w	sl, {r0, r1, r2, r3}
10007b10:	e894 000f 	ldmia.w	r4, {r0, r1, r2, r3}
10007b14:	e889 000f 	stmia.w	r9, {r0, r1, r2, r3}
10007b18:	e89c 000f 	ldmia.w	ip, {r0, r1, r2, r3}
10007b1c:	e888 000f 	stmia.w	r8, {r0, r1, r2, r3}
10007b20:	e896 000f 	ldmia.w	r6, {r0, r1, r2, r3}
10007b24:	ae36      	add	r6, sp, #216	@ 0xd8
10007b26:	e886 000f 	stmia.w	r6, {r0, r1, r2, r3}
10007b2a:	ed9d eb2a 	vldr	d14, [sp, #168]	@ 0xa8
10007b2e:	ed9d 7b34 	vldr	d7, [sp, #208]	@ 0xd0
10007b32:	ed9d 8b32 	vldr	d8, [sp, #200]	@ 0xc8
10007b36:	ee27 9b0f 	vmul.f64	d9, d7, d15
10007b3a:	eefc 7bce 	vcvt.u32.f64	s15, d14
10007b3e:	ed9d 1b2e 	vldr	d1, [sp, #184]	@ 0xb8
10007b42:	ee17 0a90 	vmov	r0, s15
10007b46:	eefc 7bc8 	vcvt.u32.f64	s15, d8
10007b4a:	ed9d ab36 	vldr	d10, [sp, #216]	@ 0xd8
10007b4e:	ee17 2a90 	vmov	r2, s15
10007b52:	eefc 7bc1 	vcvt.u32.f64	s15, d1
10007b56:	ee17 1a90 	vmov	r1, s15
10007b5a:	eefc 7bca 	vcvt.u32.f64	s15, d10
10007b5e:	ee17 3a90 	vmov	r3, s15
10007b62:	ed9d 7b2c 	vldr	d7, [sp, #176]	@ 0xb0
10007b66:	0fc0      	lsrs	r0, r0, #31
10007b68:	ee27 4b09 	vmul.f64	d4, d7, d9
10007b6c:	ee07 0a90 	vmov	s15, r0
10007b70:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10007b74:	0fc9      	lsrs	r1, r1, #31
10007b76:	ed8d 7b12 	vstr	d7, [sp, #72]	@ 0x48
10007b7a:	ee07 1a90 	vmov	s15, r1
10007b7e:	0fd2      	lsrs	r2, r2, #31
10007b80:	eeb8 3be7 	vcvt.f64.s32	d3, s15
10007b84:	ee07 2a90 	vmov	s15, r2
10007b88:	0fdb      	lsrs	r3, r3, #31
10007b8a:	eeb8 2be7 	vcvt.f64.s32	d2, s15
10007b8e:	ee07 3a90 	vmov	s15, r3
10007b92:	ee2e 9b09 	vmul.f64	d9, d14, d9
10007b96:	eeb8 0be7 	vcvt.f64.s32	d0, s15
10007b9a:	ed8d 3b16 	vstr	d3, [sp, #88]	@ 0x58
10007b9e:	ed9d 7b34 	vldr	d7, [sp, #208]	@ 0xd0
10007ba2:	ed9d 3b38 	vldr	d3, [sp, #224]	@ 0xe0
10007ba6:	ed8d 0b18 	vstr	d0, [sp, #96]	@ 0x60
10007baa:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10007bae:	ee37 0b03 	vadd.f64	d0, d7, d3
10007bb2:	ed9d 7b2c 	vldr	d7, [sp, #176]	@ 0xb0
10007bb6:	ed9d 3b30 	vldr	d3, [sp, #192]	@ 0xc0
10007bba:	ee28 6b0f 	vmul.f64	d6, d8, d15
10007bbe:	ee37 db03 	vadd.f64	d13, d7, d3
10007bc2:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10007bc6:	ed9d 3b2c 	vldr	d3, [sp, #176]	@ 0xb0
10007bca:	ed8d 9b08 	vstr	d9, [sp, #32]
10007bce:	ee23 3b06 	vmul.f64	d3, d3, d6
10007bd2:	ee20 9b0f 	vmul.f64	d9, d0, d15
10007bd6:	eefc 3bc3 	vcvt.u32.f64	s7, d3
10007bda:	eebc 3bc9 	vcvt.u32.f64	s6, d9
10007bde:	ed9d 7b38 	vldr	d7, [sp, #224]	@ 0xe0
10007be2:	ee2e 6b06 	vmul.f64	d6, d14, d6
10007be6:	eeb8 9b63 	vcvt.f64.u32	d9, s7
10007bea:	ed8d 2b14 	vstr	d2, [sp, #80]	@ 0x50
10007bee:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10007bf2:	ee38 2b0a 	vadd.f64	d2, d8, d10
10007bf6:	ee27 5b0f 	vmul.f64	d5, d7, d15
10007bfa:	ee32 2b03 	vadd.f64	d2, d2, d3
10007bfe:	ee03 0b4c 	vmls.f64	d0, d3, d12
10007c02:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007c06:	ed9d 3b30 	vldr	d3, [sp, #192]	@ 0xc0
10007c0a:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10007c0e:	ee23 3b05 	vmul.f64	d3, d3, d5
10007c12:	ee25 5b01 	vmul.f64	d5, d5, d1
10007c16:	ee26 6b4c 	vnmul.f64	d6, d6, d12
10007c1a:	eeae 6b08 	vfma.f64	d6, d14, d8
10007c1e:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10007c22:	ee36 6b0c 	vadd.f64	d6, d6, d12
10007c26:	ee2a 7b0f 	vmul.f64	d7, d10, d15
10007c2a:	ed8d 9b00 	vstr	d9, [sp]
10007c2e:	ed8d 6b0e 	vstr	d6, [sp, #56]	@ 0x38
10007c32:	eeb0 9b40 	vmov.f64	d9, d0
10007c36:	ee2d 6b0f 	vmul.f64	d6, d13, d15
10007c3a:	ed9d 0b30 	vldr	d0, [sp, #192]	@ 0xc0
10007c3e:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10007c42:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007c46:	ed8d 5b0c 	vstr	d5, [sp, #48]	@ 0x30
10007c4a:	ee20 5b07 	vmul.f64	d5, d0, d7
10007c4e:	ee27 7b01 	vmul.f64	d7, d7, d1
10007c52:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10007c56:	ee3e 0b01 	vadd.f64	d0, d14, d1
10007c5a:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007c5e:	ee30 0b06 	vadd.f64	d0, d0, d6
10007c62:	ee06 db4c 	vmls.f64	d13, d6, d12
10007c66:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10007c6a:	ee22 6b0f 	vmul.f64	d6, d2, d15
10007c6e:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10007c72:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007c76:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10007c7a:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10007c7e:	ee27 7b4c 	vnmul.f64	d7, d7, d12
10007c82:	eea1 7b0a 	vfma.f64	d7, d1, d10
10007c86:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007c8a:	ee37 7b0c 	vadd.f64	d7, d7, d12
10007c8e:	ed8d db02 	vstr	d13, [sp, #8]
10007c92:	ed8d 5b0a 	vstr	d5, [sp, #40]	@ 0x28
10007c96:	ed9d db2c 	vldr	d13, [sp, #176]	@ 0xb0
10007c9a:	ed9d 5b34 	vldr	d5, [sp, #208]	@ 0xd0
10007c9e:	ed8d 7b10 	vstr	d7, [sp, #64]	@ 0x40
10007ca2:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10007ca6:	ee24 7b4c 	vnmul.f64	d7, d4, d12
10007caa:	eead 7b05 	vfma.f64	d7, d13, d5
10007cae:	ee37 7b0c 	vadd.f64	d7, d7, d12
10007cb2:	ee06 2b4c 	vmls.f64	d2, d6, d12
10007cb6:	ee27 7b0f 	vmul.f64	d7, d7, d15
10007cba:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007cbe:	eefc 7bc2 	vcvt.u32.f64	s15, d2
10007cc2:	ee17 3a90 	vmov	r3, s15
10007cc6:	0fdb      	lsrs	r3, r3, #31
10007cc8:	ee07 3a90 	vmov	s15, r3
10007ccc:	eeb8 5b47 	vcvt.f64.u32	d5, s14
10007cd0:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10007cd4:	ee35 5b04 	vadd.f64	d5, d5, d4
10007cd8:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10007cdc:	eeb8 4be7 	vcvt.f64.s32	d4, s15
10007ce0:	ed8d 2b04 	vstr	d2, [sp, #16]
10007ce4:	ee23 7b4c 	vnmul.f64	d7, d3, d12
10007ce8:	ed9d 2b30 	vldr	d2, [sp, #192]	@ 0xc0
10007cec:	ed8d 4b1c 	vstr	d4, [sp, #112]	@ 0x70
10007cf0:	ed9d 4b38 	vldr	d4, [sp, #224]	@ 0xe0
10007cf4:	eea2 7b04 	vfma.f64	d7, d2, d4
10007cf8:	ee20 4b0f 	vmul.f64	d4, d0, d15
10007cfc:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10007d00:	ee37 6b0c 	vadd.f64	d6, d7, d12
10007d04:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10007d08:	eeb0 7b40 	vmov.f64	d7, d0
10007d0c:	ee04 7b4c 	vmls.f64	d7, d4, d12
10007d10:	ed9d db00 	vldr	d13, [sp]
10007d14:	ed8d 7b00 	vstr	d7, [sp]
10007d18:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10007d1c:	ee26 6b0f 	vmul.f64	d6, d6, d15
10007d20:	ee17 3a90 	vmov	r3, s15
10007d24:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007d28:	0fdb      	lsrs	r3, r3, #31
10007d2a:	ee07 3a90 	vmov	s15, r3
10007d2e:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10007d32:	ed8d 9b06 	vstr	d9, [sp, #24]
10007d36:	ee29 2b0f 	vmul.f64	d2, d9, d15
10007d3a:	ed9d 4b2c 	vldr	d4, [sp, #176]	@ 0xb0
10007d3e:	ed9d 0b08 	vldr	d0, [sp, #32]
10007d42:	ee36 6b03 	vadd.f64	d6, d6, d3
10007d46:	ee2d 9b4c 	vnmul.f64	d9, d13, d12
10007d4a:	eea4 9b08 	vfma.f64	d9, d4, d8
10007d4e:	ed9d 3b0a 	vldr	d3, [sp, #40]	@ 0x28
10007d52:	eeb8 8be7 	vcvt.f64.s32	d8, s15
10007d56:	ed9d 4b30 	vldr	d4, [sp, #192]	@ 0xc0
10007d5a:	ed8d 8b1a 	vstr	d8, [sp, #104]	@ 0x68
10007d5e:	ee20 7b4c 	vnmul.f64	d7, d0, d12
10007d62:	ee23 8b4c 	vnmul.f64	d8, d3, d12
10007d66:	eea4 8b0a 	vfma.f64	d8, d4, d10
10007d6a:	ed9d 4b04 	vldr	d4, [sp, #16]
10007d6e:	ed9d ab34 	vldr	d10, [sp, #208]	@ 0xd0
10007d72:	eeae 7b0a 	vfma.f64	d7, d14, d10
10007d76:	ed9d eb0c 	vldr	d14, [sp, #48]	@ 0x30
10007d7a:	ee24 3b0f 	vmul.f64	d3, d4, d15
10007d7e:	ed9d ab38 	vldr	d10, [sp, #224]	@ 0xe0
10007d82:	ee2e 4b4c 	vnmul.f64	d4, d14, d12
10007d86:	eea1 4b0a 	vfma.f64	d4, d1, d10
10007d8a:	ed9d ab00 	vldr	d10, [sp]
10007d8e:	ed9d 1b02 	vldr	d1, [sp, #8]
10007d92:	ee21 0b02 	vmul.f64	d0, d1, d2
10007d96:	ee2a 2b02 	vmul.f64	d2, d10, d2
10007d9a:	ee39 9b0c 	vadd.f64	d9, d9, d12
10007d9e:	ee38 8b0c 	vadd.f64	d8, d8, d12
10007da2:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10007da6:	ee29 1b0f 	vmul.f64	d1, d9, d15
10007daa:	eeb8 eb42 	vcvt.f64.u32	d14, s4
10007dae:	ee28 2b0f 	vmul.f64	d2, d8, d15
10007db2:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10007db6:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10007dba:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10007dbe:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10007dc2:	ee01 9b4c 	vmls.f64	d9, d1, d12
10007dc6:	ee02 8b4c 	vmls.f64	d8, d2, d12
10007dca:	ee35 5b4b 	vsub.f64	d5, d5, d11
10007dce:	ee36 6b4b 	vsub.f64	d6, d6, d11
10007dd2:	ee35 5b09 	vadd.f64	d5, d5, d9
10007dd6:	ee36 6b08 	vadd.f64	d6, d6, d8
10007dda:	ed9d 9b0a 	vldr	d9, [sp, #40]	@ 0x28
10007dde:	ee37 7b0c 	vadd.f64	d7, d7, d12
10007de2:	ed9d 8b02 	vldr	d8, [sp, #8]
10007de6:	ee39 2b02 	vadd.f64	d2, d9, d2
10007dea:	ee28 8b03 	vmul.f64	d8, d8, d3
10007dee:	ee27 9b0f 	vmul.f64	d9, d7, d15
10007df2:	eefc 8bc8 	vcvt.u32.f64	s17, d8
10007df6:	eebc 8bc9 	vcvt.u32.f64	s16, d9
10007dfa:	ee2a 3b03 	vmul.f64	d3, d10, d3
10007dfe:	eeb8 9b68 	vcvt.f64.u32	d9, s17
10007e02:	ee3d 1b01 	vadd.f64	d1, d13, d1
10007e06:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10007e0a:	ed9d db08 	vldr	d13, [sp, #32]
10007e0e:	ee08 7b4c 	vmls.f64	d7, d8, d12
10007e12:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10007e16:	ee3d 8b08 	vadd.f64	d8, d13, d8
10007e1a:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10007e1e:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10007e22:	ee34 4b0c 	vadd.f64	d4, d4, d12
10007e26:	ee31 1b4b 	vsub.f64	d1, d1, d11
10007e2a:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10007e2e:	ee38 8b4b 	vsub.f64	d8, d8, d11
10007e32:	ee35 7b07 	vadd.f64	d7, d5, d7
10007e36:	ee31 8b08 	vadd.f64	d8, d1, d8
10007e3a:	ed9d 5b04 	vldr	d5, [sp, #16]
10007e3e:	ed9d 1b06 	vldr	d1, [sp, #24]
10007e42:	ed9d db02 	vldr	d13, [sp, #8]
10007e46:	ee23 3b4c 	vnmul.f64	d3, d3, d12
10007e4a:	eeaa 3b05 	vfma.f64	d3, d10, d5
10007e4e:	ee20 5b4c 	vnmul.f64	d5, d0, d12
10007e52:	eead 5b01 	vfma.f64	d5, d13, d1
10007e56:	ee33 ab0c 	vadd.f64	d10, d3, d12
10007e5a:	ee35 5b0c 	vadd.f64	d5, d5, d12
10007e5e:	ee24 3b0f 	vmul.f64	d3, d4, d15
10007e62:	ee25 5b0f 	vmul.f64	d5, d5, d15
10007e66:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10007e6a:	ed9d db0c 	vldr	d13, [sp, #48]	@ 0x30
10007e6e:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10007e72:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10007e76:	ee03 4b4c 	vmls.f64	d4, d3, d12
10007e7a:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10007e7e:	ee3d 3b03 	vadd.f64	d3, d13, d3
10007e82:	ee36 4b04 	vadd.f64	d4, d6, d4
10007e86:	ee33 3b4b 	vsub.f64	d3, d3, d11
10007e8a:	ed9d 6b04 	vldr	d6, [sp, #16]
10007e8e:	ee35 5b00 	vadd.f64	d5, d5, d0
10007e92:	ee29 1b4c 	vnmul.f64	d1, d9, d12
10007e96:	ed9d 0b02 	vldr	d0, [sp, #8]
10007e9a:	eea0 1b06 	vfma.f64	d1, d0, d6
10007e9e:	ee32 2b4b 	vsub.f64	d2, d2, d11
10007ea2:	ed9d 6b0e 	vldr	d6, [sp, #56]	@ 0x38
10007ea6:	ed9d db10 	vldr	d13, [sp, #64]	@ 0x40
10007eaa:	ee32 2b03 	vadd.f64	d2, d2, d3
10007eae:	ee26 3b0f 	vmul.f64	d3, d6, d15
10007eb2:	ee2d 0b0f 	vmul.f64	d0, d13, d15
10007eb6:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10007eba:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10007ebe:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10007ec2:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10007ec6:	ee03 6b4c 	vmls.f64	d6, d3, d12
10007eca:	eeb0 3b4d 	vmov.f64	d3, d13
10007ece:	ee31 1b0c 	vadd.f64	d1, d1, d12
10007ed2:	ee00 3b4c 	vmls.f64	d3, d0, d12
10007ed6:	ee36 6b08 	vadd.f64	d6, d6, d8
10007eda:	ed9d 0b00 	vldr	d0, [sp]
10007ede:	ed9d 8b06 	vldr	d8, [sp, #24]
10007ee2:	ee33 3b02 	vadd.f64	d3, d3, d2
10007ee6:	ee2e 2b4c 	vnmul.f64	d2, d14, d12
10007eea:	eea0 2b08 	vfma.f64	d2, d0, d8
10007eee:	ee21 0b0f 	vmul.f64	d0, d1, d15
10007ef2:	ee27 8b0f 	vmul.f64	d8, d7, d15
10007ef6:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10007efa:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10007efe:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10007f02:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10007f06:	ee35 5b4b 	vsub.f64	d5, d5, d11
10007f0a:	ee00 1b4c 	vmls.f64	d1, d0, d12
10007f0e:	ee36 6b08 	vadd.f64	d6, d6, d8
10007f12:	ee39 0b00 	vadd.f64	d0, d9, d0
10007f16:	ed9f 9b72 	vldr	d9, [pc, #456]	@ 100080e0 <fndsa_vect_mul_fft_fp64_exact+0x648>
10007f1a:	ee35 1b01 	vadd.f64	d1, d5, d1
10007f1e:	ed9d db34 	vldr	d13, [sp, #208]	@ 0xd0
10007f22:	ed9d 5b12 	vldr	d5, [sp, #72]	@ 0x48
10007f26:	ee36 6b09 	vadd.f64	d6, d6, d9
10007f2a:	ee05 6b4d 	vmls.f64	d6, d5, d13
10007f2e:	ed9d db14 	vldr	d13, [sp, #80]	@ 0x50
10007f32:	ed9d 5b2c 	vldr	d5, [sp, #176]	@ 0xb0
10007f36:	ee0d 6b45 	vmls.f64	d6, d13, d5
10007f3a:	ee24 5b0f 	vmul.f64	d5, d4, d15
10007f3e:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10007f42:	ee32 2b0c 	vadd.f64	d2, d2, d12
10007f46:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10007f4a:	ee08 7b4c 	vmls.f64	d7, d8, d12
10007f4e:	ee33 3b05 	vadd.f64	d3, d3, d5
10007f52:	ee22 8b0f 	vmul.f64	d8, d2, d15
10007f56:	ee05 4b4c 	vmls.f64	d4, d5, d12
10007f5a:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10007f5e:	ed9d 5b16 	vldr	d5, [sp, #88]	@ 0x58
10007f62:	ee33 3b09 	vadd.f64	d3, d3, d9
10007f66:	ed9d db38 	vldr	d13, [sp, #224]	@ 0xe0
10007f6a:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10007f6e:	ee05 3b4d 	vmls.f64	d3, d5, d13
10007f72:	ed9d 5b18 	vldr	d5, [sp, #96]	@ 0x60
10007f76:	ed9d db30 	vldr	d13, [sp, #192]	@ 0xc0
10007f7a:	ee08 2b4c 	vmls.f64	d2, d8, d12
10007f7e:	ee05 3b4d 	vmls.f64	d3, d5, d13
10007f82:	ee2a 5b0f 	vmul.f64	d5, d10, d15
10007f86:	ee3e eb08 	vadd.f64	d14, d14, d8
10007f8a:	ee31 2b02 	vadd.f64	d2, d1, d2
10007f8e:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10007f92:	ee22 1b0f 	vmul.f64	d1, d2, d15
10007f96:	ee30 0b4b 	vsub.f64	d0, d0, d11
10007f9a:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10007f9e:	ee3e eb4b 	vsub.f64	d14, d14, d11
10007fa2:	ee05 ab4c 	vmls.f64	d10, d5, d12
10007fa6:	ee30 eb0e 	vadd.f64	d14, d0, d14
10007faa:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10007fae:	ee3a ab0e 	vadd.f64	d10, d10, d14
10007fb2:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10007fb6:	ee3a ab01 	vadd.f64	d10, d10, d1
10007fba:	ed9d 5b1a 	vldr	d5, [sp, #104]	@ 0x68
10007fbe:	ee3a ab09 	vadd.f64	d10, d10, d9
10007fc2:	ed9d 8b06 	vldr	d8, [sp, #24]
10007fc6:	ee05 ab48 	vmls.f64	d10, d5, d8
10007fca:	ee37 5b04 	vadd.f64	d5, d7, d4
10007fce:	ee37 7b0c 	vadd.f64	d7, d7, d12
10007fd2:	ee01 2b4c 	vmls.f64	d2, d1, d12
10007fd6:	ee37 7b44 	vsub.f64	d7, d7, d4
10007fda:	ed9d 1b1c 	vldr	d1, [sp, #112]	@ 0x70
10007fde:	ed9d 0b02 	vldr	d0, [sp, #8]
10007fe2:	ee01 ab40 	vmls.f64	d10, d1, d0
10007fe6:	ee27 1b0f 	vmul.f64	d1, d7, d15
10007fea:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10007fee:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10007ff2:	ee01 7b4c 	vmls.f64	d7, d1, d12
10007ff6:	ed8d 7b24 	vstr	d7, [sp, #144]	@ 0x90
10007ffa:	ee26 7b0f 	vmul.f64	d7, d6, d15
10007ffe:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10008002:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10008006:	ee07 6b4c 	vmls.f64	d6, d7, d12
1000800a:	ee23 7b0f 	vmul.f64	d7, d3, d15
1000800e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10008012:	ee25 0b0f 	vmul.f64	d0, d5, d15
10008016:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000801a:	eebc 0bc0 	vcvt.u32.f64	s0, d0
1000801e:	ee07 3b4c 	vmls.f64	d3, d7, d12
10008022:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10008026:	ee36 7b0c 	vadd.f64	d7, d6, d12
1000802a:	ee36 6b03 	vadd.f64	d6, d6, d3
1000802e:	ee2a 4b0f 	vmul.f64	d4, d10, d15
10008032:	ee36 6b00 	vadd.f64	d6, d6, d0
10008036:	ee37 3b43 	vsub.f64	d3, d7, d3
1000803a:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000803e:	ee26 7b0f 	vmul.f64	d7, d6, d15
10008042:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10008046:	ee32 2b0c 	vadd.f64	d2, d2, d12
1000804a:	ee00 5b4c 	vmls.f64	d5, d0, d12
1000804e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10008052:	ee04 ab4c 	vmls.f64	d10, d4, d12
10008056:	ee32 5b45 	vsub.f64	d5, d2, d5
1000805a:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000805e:	ee25 4b0f 	vmul.f64	d4, d5, d15
10008062:	ee07 6b4c 	vmls.f64	d6, d7, d12
10008066:	ee3a ab0c 	vadd.f64	d10, d10, d12
1000806a:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000806e:	ee3a 7b46 	vsub.f64	d7, d10, d6
10008072:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10008076:	ee33 3b4b 	vsub.f64	d3, d3, d11
1000807a:	ee37 7b4b 	vsub.f64	d7, d7, d11
1000807e:	ee04 5b4c 	vmls.f64	d5, d4, d12
10008082:	ee33 3b01 	vadd.f64	d3, d3, d1
10008086:	ee37 7b04 	vadd.f64	d7, d7, d4
1000808a:	ed8d 5b28 	vstr	d5, [sp, #160]	@ 0xa0
1000808e:	ee27 6b0f 	vmul.f64	d6, d7, d15
10008092:	ee23 5b0f 	vmul.f64	d5, d3, d15
10008096:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000809a:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000809e:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100080a2:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100080a6:	ee06 7b4c 	vmls.f64	d7, d6, d12
100080aa:	ee05 3b4c 	vmls.f64	d3, d5, d12
100080ae:	ed8d 7b26 	vstr	d7, [sp, #152]	@ 0x98
100080b2:	ed8d 3b22 	vstr	d3, [sp, #136]	@ 0x88
100080b6:	ab22      	add	r3, sp, #136	@ 0x88
100080b8:	cb0f      	ldmia	r3, {r0, r1, r2, r3}
100080ba:	e885 000f 	stmia.w	r5, {r0, r1, r2, r3}
100080be:	ab26      	add	r3, sp, #152	@ 0x98
100080c0:	cb0f      	ldmia	r3, {r0, r1, r2, r3}
100080c2:	3710      	adds	r7, #16
100080c4:	e884 000f 	stmia.w	r4, {r0, r1, r2, r3}
100080c8:	f1be 0e01 	subs.w	lr, lr, #1
100080cc:	f47f ad14 	bne.w	10007af8 <fndsa_vect_mul_fft_fp64_exact+0x60>
100080d0:	b03b      	add	sp, #236	@ 0xec
100080d2:	ecbd 8b10 	vpop	{d8-d15}
100080d6:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
100080da:	bf00      	nop
100080dc:	f3af 8000 	nop.w
100080e0:	00000000 	.word	0x00000000
100080e4:	42000000 	.word	0x42000000

