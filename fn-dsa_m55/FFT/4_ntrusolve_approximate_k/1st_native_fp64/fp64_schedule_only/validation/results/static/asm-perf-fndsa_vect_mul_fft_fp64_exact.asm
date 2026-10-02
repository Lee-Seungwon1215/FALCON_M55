100068e8 <fndsa_vect_mul_fft_fp64_exact>:
100068e8:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
100068ec:	2310      	movs	r3, #16
100068ee:	ed2d 8b10 	vpush	{d8-d15}
100068f2:	3801      	subs	r0, #1
100068f4:	4083      	lsls	r3, r0
100068f6:	f1a3 0e10 	sub.w	lr, r3, #16
100068fa:	ea4f 1e1e 	mov.w	lr, lr, lsr #4
100068fe:	b0bb      	sub	sp, #236	@ 0xec
10006900:	eb01 0b03 	add.w	fp, r1, r3
10006904:	f10e 0e01 	add.w	lr, lr, #1
10006908:	18d3      	adds	r3, r2, r3
1000690a:	e9cd 3b1f 	strd	r3, fp, [sp, #124]	@ 0x7c
1000690e:	2700      	movs	r7, #0
10006910:	ed9f fb09 	vldr	d15, [pc, #36]	@ 10006938 <fndsa_vect_mul_fft_fp64_exact+0x50>
10006914:	ed9f cb0a 	vldr	d12, [pc, #40]	@ 10006940 <fndsa_vect_mul_fft_fp64_exact+0x58>
10006918:	eeb7 bb00 	vmov.f64	d11, #112	@ 0x3f800000  1.0
1000691c:	f04e e001 	dls	lr, lr
10006920:	4693      	mov	fp, r2
10006922:	f10d 0aa8 	add.w	sl, sp, #168	@ 0xa8
10006926:	f10d 09b8 	add.w	r9, sp, #184	@ 0xb8
1000692a:	f10d 08c8 	add.w	r8, sp, #200	@ 0xc8
1000692e:	9121      	str	r1, [sp, #132]	@ 0x84
10006930:	e00a      	b.n	10006948 <fndsa_vect_mul_fft_fp64_exact+0x60>
10006932:	bf00      	nop
10006934:	f3af 8000 	nop.w
10006938:	00000000 	.word	0x00000000
1000693c:	3df00000 	.word	0x3df00000
10006940:	00000000 	.word	0x00000000
10006944:	41f00000 	.word	0x41f00000
10006948:	9b21      	ldr	r3, [sp, #132]	@ 0x84
1000694a:	eb0b 0c07 	add.w	ip, fp, r7
1000694e:	19dd      	adds	r5, r3, r7
10006950:	9b20      	ldr	r3, [sp, #128]	@ 0x80
10006952:	19dc      	adds	r4, r3, r7
10006954:	9b1f      	ldr	r3, [sp, #124]	@ 0x7c
10006956:	19de      	adds	r6, r3, r7
10006958:	e895 000f 	ldmia.w	r5, {r0, r1, r2, r3}
1000695c:	e88a 000f 	stmia.w	sl, {r0, r1, r2, r3}
10006960:	e894 000f 	ldmia.w	r4, {r0, r1, r2, r3}
10006964:	e889 000f 	stmia.w	r9, {r0, r1, r2, r3}
10006968:	e89c 000f 	ldmia.w	ip, {r0, r1, r2, r3}
1000696c:	e888 000f 	stmia.w	r8, {r0, r1, r2, r3}
10006970:	e896 000f 	ldmia.w	r6, {r0, r1, r2, r3}
10006974:	ae36      	add	r6, sp, #216	@ 0xd8
10006976:	e886 000f 	stmia.w	r6, {r0, r1, r2, r3}
1000697a:	ed9d eb2a 	vldr	d14, [sp, #168]	@ 0xa8
1000697e:	ed9d 7b34 	vldr	d7, [sp, #208]	@ 0xd0
10006982:	ed9d 8b32 	vldr	d8, [sp, #200]	@ 0xc8
10006986:	ee27 9b0f 	vmul.f64	d9, d7, d15
1000698a:	eefc 7bce 	vcvt.u32.f64	s15, d14
1000698e:	ed9d 1b2e 	vldr	d1, [sp, #184]	@ 0xb8
10006992:	ee17 0a90 	vmov	r0, s15
10006996:	eefc 7bc8 	vcvt.u32.f64	s15, d8
1000699a:	ed9d ab36 	vldr	d10, [sp, #216]	@ 0xd8
1000699e:	ee17 2a90 	vmov	r2, s15
100069a2:	eefc 7bc1 	vcvt.u32.f64	s15, d1
100069a6:	ee17 1a90 	vmov	r1, s15
100069aa:	eefc 7bca 	vcvt.u32.f64	s15, d10
100069ae:	ee17 3a90 	vmov	r3, s15
100069b2:	ed9d 7b2c 	vldr	d7, [sp, #176]	@ 0xb0
100069b6:	0fc0      	lsrs	r0, r0, #31
100069b8:	ee27 4b09 	vmul.f64	d4, d7, d9
100069bc:	ee07 0a90 	vmov	s15, r0
100069c0:	eeb8 7be7 	vcvt.f64.s32	d7, s15
100069c4:	0fc9      	lsrs	r1, r1, #31
100069c6:	ed8d 7b12 	vstr	d7, [sp, #72]	@ 0x48
100069ca:	ee07 1a90 	vmov	s15, r1
100069ce:	0fd2      	lsrs	r2, r2, #31
100069d0:	eeb8 3be7 	vcvt.f64.s32	d3, s15
100069d4:	ee07 2a90 	vmov	s15, r2
100069d8:	0fdb      	lsrs	r3, r3, #31
100069da:	eeb8 2be7 	vcvt.f64.s32	d2, s15
100069de:	ee07 3a90 	vmov	s15, r3
100069e2:	ee2e 9b09 	vmul.f64	d9, d14, d9
100069e6:	eeb8 0be7 	vcvt.f64.s32	d0, s15
100069ea:	ed8d 3b16 	vstr	d3, [sp, #88]	@ 0x58
100069ee:	ed9d 7b34 	vldr	d7, [sp, #208]	@ 0xd0
100069f2:	ed9d 3b38 	vldr	d3, [sp, #224]	@ 0xe0
100069f6:	ed8d 0b18 	vstr	d0, [sp, #96]	@ 0x60
100069fa:	eebc 9bc9 	vcvt.u32.f64	s18, d9
100069fe:	ee37 0b03 	vadd.f64	d0, d7, d3
10006a02:	ed9d 7b2c 	vldr	d7, [sp, #176]	@ 0xb0
10006a06:	ed9d 3b30 	vldr	d3, [sp, #192]	@ 0xc0
10006a0a:	ee28 6b0f 	vmul.f64	d6, d8, d15
10006a0e:	ee37 db03 	vadd.f64	d13, d7, d3
10006a12:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10006a16:	ed9d 3b2c 	vldr	d3, [sp, #176]	@ 0xb0
10006a1a:	ed8d 9b08 	vstr	d9, [sp, #32]
10006a1e:	ee23 3b06 	vmul.f64	d3, d3, d6
10006a22:	ee20 9b0f 	vmul.f64	d9, d0, d15
10006a26:	eefc 3bc3 	vcvt.u32.f64	s7, d3
10006a2a:	eebc 3bc9 	vcvt.u32.f64	s6, d9
10006a2e:	ed9d 7b38 	vldr	d7, [sp, #224]	@ 0xe0
10006a32:	ee2e 6b06 	vmul.f64	d6, d14, d6
10006a36:	eeb8 9b63 	vcvt.f64.u32	d9, s7
10006a3a:	ed8d 2b14 	vstr	d2, [sp, #80]	@ 0x50
10006a3e:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10006a42:	ee38 2b0a 	vadd.f64	d2, d8, d10
10006a46:	ee27 5b0f 	vmul.f64	d5, d7, d15
10006a4a:	ee32 2b03 	vadd.f64	d2, d2, d3
10006a4e:	ee03 0b4c 	vmls.f64	d0, d3, d12
10006a52:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006a56:	ed9d 3b30 	vldr	d3, [sp, #192]	@ 0xc0
10006a5a:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006a5e:	ee23 3b05 	vmul.f64	d3, d3, d5
10006a62:	ee25 5b01 	vmul.f64	d5, d5, d1
10006a66:	ee26 6b4c 	vnmul.f64	d6, d6, d12
10006a6a:	eeae 6b08 	vfma.f64	d6, d14, d8
10006a6e:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10006a72:	ee36 6b0c 	vadd.f64	d6, d6, d12
10006a76:	ee2a 7b0f 	vmul.f64	d7, d10, d15
10006a7a:	ed8d 9b00 	vstr	d9, [sp]
10006a7e:	ed8d 6b0e 	vstr	d6, [sp, #56]	@ 0x38
10006a82:	eeb0 9b40 	vmov.f64	d9, d0
10006a86:	ee2d 6b0f 	vmul.f64	d6, d13, d15
10006a8a:	ed9d 0b30 	vldr	d0, [sp, #192]	@ 0xc0
10006a8e:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10006a92:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006a96:	ed8d 5b0c 	vstr	d5, [sp, #48]	@ 0x30
10006a9a:	ee20 5b07 	vmul.f64	d5, d0, d7
10006a9e:	ee27 7b01 	vmul.f64	d7, d7, d1
10006aa2:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006aa6:	ee3e 0b01 	vadd.f64	d0, d14, d1
10006aaa:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006aae:	ee30 0b06 	vadd.f64	d0, d0, d6
10006ab2:	ee06 db4c 	vmls.f64	d13, d6, d12
10006ab6:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10006aba:	ee22 6b0f 	vmul.f64	d6, d2, d15
10006abe:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10006ac2:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006ac6:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10006aca:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10006ace:	ee27 7b4c 	vnmul.f64	d7, d7, d12
10006ad2:	eea1 7b0a 	vfma.f64	d7, d1, d10
10006ad6:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006ada:	ee37 7b0c 	vadd.f64	d7, d7, d12
10006ade:	ed8d db02 	vstr	d13, [sp, #8]
10006ae2:	ed8d 5b0a 	vstr	d5, [sp, #40]	@ 0x28
10006ae6:	ed9d db2c 	vldr	d13, [sp, #176]	@ 0xb0
10006aea:	ed9d 5b34 	vldr	d5, [sp, #208]	@ 0xd0
10006aee:	ed8d 7b10 	vstr	d7, [sp, #64]	@ 0x40
10006af2:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006af6:	ee24 7b4c 	vnmul.f64	d7, d4, d12
10006afa:	eead 7b05 	vfma.f64	d7, d13, d5
10006afe:	ee37 7b0c 	vadd.f64	d7, d7, d12
10006b02:	ee06 2b4c 	vmls.f64	d2, d6, d12
10006b06:	ee27 7b0f 	vmul.f64	d7, d7, d15
10006b0a:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006b0e:	eefc 7bc2 	vcvt.u32.f64	s15, d2
10006b12:	ee17 3a90 	vmov	r3, s15
10006b16:	0fdb      	lsrs	r3, r3, #31
10006b18:	ee07 3a90 	vmov	s15, r3
10006b1c:	eeb8 5b47 	vcvt.f64.u32	d5, s14
10006b20:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006b24:	ee35 5b04 	vadd.f64	d5, d5, d4
10006b28:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10006b2c:	eeb8 4be7 	vcvt.f64.s32	d4, s15
10006b30:	ed8d 2b04 	vstr	d2, [sp, #16]
10006b34:	ee23 7b4c 	vnmul.f64	d7, d3, d12
10006b38:	ed9d 2b30 	vldr	d2, [sp, #192]	@ 0xc0
10006b3c:	ed8d 4b1c 	vstr	d4, [sp, #112]	@ 0x70
10006b40:	ed9d 4b38 	vldr	d4, [sp, #224]	@ 0xe0
10006b44:	eea2 7b04 	vfma.f64	d7, d2, d4
10006b48:	ee20 4b0f 	vmul.f64	d4, d0, d15
10006b4c:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10006b50:	ee37 6b0c 	vadd.f64	d6, d7, d12
10006b54:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10006b58:	eeb0 7b40 	vmov.f64	d7, d0
10006b5c:	ee04 7b4c 	vmls.f64	d7, d4, d12
10006b60:	ed9d db00 	vldr	d13, [sp]
10006b64:	ed8d 7b00 	vstr	d7, [sp]
10006b68:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10006b6c:	ee26 6b0f 	vmul.f64	d6, d6, d15
10006b70:	ee17 3a90 	vmov	r3, s15
10006b74:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006b78:	0fdb      	lsrs	r3, r3, #31
10006b7a:	ee07 3a90 	vmov	s15, r3
10006b7e:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006b82:	ed8d 9b06 	vstr	d9, [sp, #24]
10006b86:	ee29 2b0f 	vmul.f64	d2, d9, d15
10006b8a:	ed9d 4b2c 	vldr	d4, [sp, #176]	@ 0xb0
10006b8e:	ed9d 0b08 	vldr	d0, [sp, #32]
10006b92:	ee36 6b03 	vadd.f64	d6, d6, d3
10006b96:	ee2d 9b4c 	vnmul.f64	d9, d13, d12
10006b9a:	eea4 9b08 	vfma.f64	d9, d4, d8
10006b9e:	ed9d 3b0a 	vldr	d3, [sp, #40]	@ 0x28
10006ba2:	eeb8 8be7 	vcvt.f64.s32	d8, s15
10006ba6:	ed9d 4b30 	vldr	d4, [sp, #192]	@ 0xc0
10006baa:	ed8d 8b1a 	vstr	d8, [sp, #104]	@ 0x68
10006bae:	ee20 7b4c 	vnmul.f64	d7, d0, d12
10006bb2:	ee23 8b4c 	vnmul.f64	d8, d3, d12
10006bb6:	eea4 8b0a 	vfma.f64	d8, d4, d10
10006bba:	ed9d 4b04 	vldr	d4, [sp, #16]
10006bbe:	ed9d ab34 	vldr	d10, [sp, #208]	@ 0xd0
10006bc2:	eeae 7b0a 	vfma.f64	d7, d14, d10
10006bc6:	ed9d eb0c 	vldr	d14, [sp, #48]	@ 0x30
10006bca:	ee24 3b0f 	vmul.f64	d3, d4, d15
10006bce:	ed9d ab38 	vldr	d10, [sp, #224]	@ 0xe0
10006bd2:	ee2e 4b4c 	vnmul.f64	d4, d14, d12
10006bd6:	eea1 4b0a 	vfma.f64	d4, d1, d10
10006bda:	ed9d ab00 	vldr	d10, [sp]
10006bde:	ed9d 1b02 	vldr	d1, [sp, #8]
10006be2:	ee21 0b02 	vmul.f64	d0, d1, d2
10006be6:	ee2a 2b02 	vmul.f64	d2, d10, d2
10006bea:	ee39 9b0c 	vadd.f64	d9, d9, d12
10006bee:	ee38 8b0c 	vadd.f64	d8, d8, d12
10006bf2:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10006bf6:	ee29 1b0f 	vmul.f64	d1, d9, d15
10006bfa:	eeb8 eb42 	vcvt.f64.u32	d14, s4
10006bfe:	ee28 2b0f 	vmul.f64	d2, d8, d15
10006c02:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10006c06:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10006c0a:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10006c0e:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10006c12:	ee01 9b4c 	vmls.f64	d9, d1, d12
10006c16:	ee02 8b4c 	vmls.f64	d8, d2, d12
10006c1a:	ee35 5b4b 	vsub.f64	d5, d5, d11
10006c1e:	ee36 6b4b 	vsub.f64	d6, d6, d11
10006c22:	ee35 5b09 	vadd.f64	d5, d5, d9
10006c26:	ee36 6b08 	vadd.f64	d6, d6, d8
10006c2a:	ed9d 9b0a 	vldr	d9, [sp, #40]	@ 0x28
10006c2e:	ee37 7b0c 	vadd.f64	d7, d7, d12
10006c32:	ed9d 8b02 	vldr	d8, [sp, #8]
10006c36:	ee39 2b02 	vadd.f64	d2, d9, d2
10006c3a:	ee28 8b03 	vmul.f64	d8, d8, d3
10006c3e:	ee27 9b0f 	vmul.f64	d9, d7, d15
10006c42:	eefc 8bc8 	vcvt.u32.f64	s17, d8
10006c46:	eebc 8bc9 	vcvt.u32.f64	s16, d9
10006c4a:	ee2a 3b03 	vmul.f64	d3, d10, d3
10006c4e:	eeb8 9b68 	vcvt.f64.u32	d9, s17
10006c52:	ee3d 1b01 	vadd.f64	d1, d13, d1
10006c56:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10006c5a:	ed9d db08 	vldr	d13, [sp, #32]
10006c5e:	ee08 7b4c 	vmls.f64	d7, d8, d12
10006c62:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10006c66:	ee3d 8b08 	vadd.f64	d8, d13, d8
10006c6a:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006c6e:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10006c72:	ee34 4b0c 	vadd.f64	d4, d4, d12
10006c76:	ee31 1b4b 	vsub.f64	d1, d1, d11
10006c7a:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10006c7e:	ee38 8b4b 	vsub.f64	d8, d8, d11
10006c82:	ee35 7b07 	vadd.f64	d7, d5, d7
10006c86:	ee31 8b08 	vadd.f64	d8, d1, d8
10006c8a:	ed9d 5b04 	vldr	d5, [sp, #16]
10006c8e:	ed9d 1b06 	vldr	d1, [sp, #24]
10006c92:	ed9d db02 	vldr	d13, [sp, #8]
10006c96:	ee23 3b4c 	vnmul.f64	d3, d3, d12
10006c9a:	eeaa 3b05 	vfma.f64	d3, d10, d5
10006c9e:	ee20 5b4c 	vnmul.f64	d5, d0, d12
10006ca2:	eead 5b01 	vfma.f64	d5, d13, d1
10006ca6:	ee33 ab0c 	vadd.f64	d10, d3, d12
10006caa:	ee35 5b0c 	vadd.f64	d5, d5, d12
10006cae:	ee24 3b0f 	vmul.f64	d3, d4, d15
10006cb2:	ee25 5b0f 	vmul.f64	d5, d5, d15
10006cb6:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006cba:	ed9d db0c 	vldr	d13, [sp, #48]	@ 0x30
10006cbe:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10006cc2:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10006cc6:	ee03 4b4c 	vmls.f64	d4, d3, d12
10006cca:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10006cce:	ee3d 3b03 	vadd.f64	d3, d13, d3
10006cd2:	ee36 4b04 	vadd.f64	d4, d6, d4
10006cd6:	ee33 3b4b 	vsub.f64	d3, d3, d11
10006cda:	ed9d 6b04 	vldr	d6, [sp, #16]
10006cde:	ee35 5b00 	vadd.f64	d5, d5, d0
10006ce2:	ee29 1b4c 	vnmul.f64	d1, d9, d12
10006ce6:	ed9d 0b02 	vldr	d0, [sp, #8]
10006cea:	eea0 1b06 	vfma.f64	d1, d0, d6
10006cee:	ee32 2b4b 	vsub.f64	d2, d2, d11
10006cf2:	ed9d 6b0e 	vldr	d6, [sp, #56]	@ 0x38
10006cf6:	ed9d db10 	vldr	d13, [sp, #64]	@ 0x40
10006cfa:	ee32 2b03 	vadd.f64	d2, d2, d3
10006cfe:	ee26 3b0f 	vmul.f64	d3, d6, d15
10006d02:	ee2d 0b0f 	vmul.f64	d0, d13, d15
10006d06:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006d0a:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10006d0e:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10006d12:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10006d16:	ee03 6b4c 	vmls.f64	d6, d3, d12
10006d1a:	eeb0 3b4d 	vmov.f64	d3, d13
10006d1e:	ee31 1b0c 	vadd.f64	d1, d1, d12
10006d22:	ee00 3b4c 	vmls.f64	d3, d0, d12
10006d26:	ee36 6b08 	vadd.f64	d6, d6, d8
10006d2a:	ed9d 0b00 	vldr	d0, [sp]
10006d2e:	ed9d 8b06 	vldr	d8, [sp, #24]
10006d32:	ee33 3b02 	vadd.f64	d3, d3, d2
10006d36:	ee2e 2b4c 	vnmul.f64	d2, d14, d12
10006d3a:	eea0 2b08 	vfma.f64	d2, d0, d8
10006d3e:	ee21 0b0f 	vmul.f64	d0, d1, d15
10006d42:	ee27 8b0f 	vmul.f64	d8, d7, d15
10006d46:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10006d4a:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10006d4e:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10006d52:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10006d56:	ee35 5b4b 	vsub.f64	d5, d5, d11
10006d5a:	ee00 1b4c 	vmls.f64	d1, d0, d12
10006d5e:	ee36 6b08 	vadd.f64	d6, d6, d8
10006d62:	ee39 0b00 	vadd.f64	d0, d9, d0
10006d66:	ed9f 9b72 	vldr	d9, [pc, #456]	@ 10006f30 <fndsa_vect_mul_fft_fp64_exact+0x648>
10006d6a:	ee35 1b01 	vadd.f64	d1, d5, d1
10006d6e:	ed9d db34 	vldr	d13, [sp, #208]	@ 0xd0
10006d72:	ed9d 5b12 	vldr	d5, [sp, #72]	@ 0x48
10006d76:	ee36 6b09 	vadd.f64	d6, d6, d9
10006d7a:	ee05 6b4d 	vmls.f64	d6, d5, d13
10006d7e:	ed9d db14 	vldr	d13, [sp, #80]	@ 0x50
10006d82:	ed9d 5b2c 	vldr	d5, [sp, #176]	@ 0xb0
10006d86:	ee0d 6b45 	vmls.f64	d6, d13, d5
10006d8a:	ee24 5b0f 	vmul.f64	d5, d4, d15
10006d8e:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10006d92:	ee32 2b0c 	vadd.f64	d2, d2, d12
10006d96:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10006d9a:	ee08 7b4c 	vmls.f64	d7, d8, d12
10006d9e:	ee33 3b05 	vadd.f64	d3, d3, d5
10006da2:	ee22 8b0f 	vmul.f64	d8, d2, d15
10006da6:	ee05 4b4c 	vmls.f64	d4, d5, d12
10006daa:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10006dae:	ed9d 5b16 	vldr	d5, [sp, #88]	@ 0x58
10006db2:	ee33 3b09 	vadd.f64	d3, d3, d9
10006db6:	ed9d db38 	vldr	d13, [sp, #224]	@ 0xe0
10006dba:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10006dbe:	ee05 3b4d 	vmls.f64	d3, d5, d13
10006dc2:	ed9d 5b18 	vldr	d5, [sp, #96]	@ 0x60
10006dc6:	ed9d db30 	vldr	d13, [sp, #192]	@ 0xc0
10006dca:	ee08 2b4c 	vmls.f64	d2, d8, d12
10006dce:	ee05 3b4d 	vmls.f64	d3, d5, d13
10006dd2:	ee2a 5b0f 	vmul.f64	d5, d10, d15
10006dd6:	ee3e eb08 	vadd.f64	d14, d14, d8
10006dda:	ee31 2b02 	vadd.f64	d2, d1, d2
10006dde:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10006de2:	ee22 1b0f 	vmul.f64	d1, d2, d15
10006de6:	ee30 0b4b 	vsub.f64	d0, d0, d11
10006dea:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10006dee:	ee3e eb4b 	vsub.f64	d14, d14, d11
10006df2:	ee05 ab4c 	vmls.f64	d10, d5, d12
10006df6:	ee30 eb0e 	vadd.f64	d14, d0, d14
10006dfa:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10006dfe:	ee3a ab0e 	vadd.f64	d10, d10, d14
10006e02:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10006e06:	ee3a ab01 	vadd.f64	d10, d10, d1
10006e0a:	ed9d 5b1a 	vldr	d5, [sp, #104]	@ 0x68
10006e0e:	ee3a ab09 	vadd.f64	d10, d10, d9
10006e12:	ed9d 8b06 	vldr	d8, [sp, #24]
10006e16:	ee05 ab48 	vmls.f64	d10, d5, d8
10006e1a:	ee37 5b04 	vadd.f64	d5, d7, d4
10006e1e:	ee37 7b0c 	vadd.f64	d7, d7, d12
10006e22:	ee01 2b4c 	vmls.f64	d2, d1, d12
10006e26:	ee37 7b44 	vsub.f64	d7, d7, d4
10006e2a:	ed9d 1b1c 	vldr	d1, [sp, #112]	@ 0x70
10006e2e:	ed9d 0b02 	vldr	d0, [sp, #8]
10006e32:	ee01 ab40 	vmls.f64	d10, d1, d0
10006e36:	ee27 1b0f 	vmul.f64	d1, d7, d15
10006e3a:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10006e3e:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10006e42:	ee01 7b4c 	vmls.f64	d7, d1, d12
10006e46:	ed8d 7b24 	vstr	d7, [sp, #144]	@ 0x90
10006e4a:	ee26 7b0f 	vmul.f64	d7, d6, d15
10006e4e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006e52:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006e56:	ee07 6b4c 	vmls.f64	d6, d7, d12
10006e5a:	ee23 7b0f 	vmul.f64	d7, d3, d15
10006e5e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006e62:	ee25 0b0f 	vmul.f64	d0, d5, d15
10006e66:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006e6a:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10006e6e:	ee07 3b4c 	vmls.f64	d3, d7, d12
10006e72:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10006e76:	ee36 7b0c 	vadd.f64	d7, d6, d12
10006e7a:	ee36 6b03 	vadd.f64	d6, d6, d3
10006e7e:	ee2a 4b0f 	vmul.f64	d4, d10, d15
10006e82:	ee36 6b00 	vadd.f64	d6, d6, d0
10006e86:	ee37 3b43 	vsub.f64	d3, d7, d3
10006e8a:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10006e8e:	ee26 7b0f 	vmul.f64	d7, d6, d15
10006e92:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10006e96:	ee32 2b0c 	vadd.f64	d2, d2, d12
10006e9a:	ee00 5b4c 	vmls.f64	d5, d0, d12
10006e9e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006ea2:	ee04 ab4c 	vmls.f64	d10, d4, d12
10006ea6:	ee32 5b45 	vsub.f64	d5, d2, d5
10006eaa:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006eae:	ee25 4b0f 	vmul.f64	d4, d5, d15
10006eb2:	ee07 6b4c 	vmls.f64	d6, d7, d12
10006eb6:	ee3a ab0c 	vadd.f64	d10, d10, d12
10006eba:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10006ebe:	ee3a 7b46 	vsub.f64	d7, d10, d6
10006ec2:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10006ec6:	ee33 3b4b 	vsub.f64	d3, d3, d11
10006eca:	ee37 7b4b 	vsub.f64	d7, d7, d11
10006ece:	ee04 5b4c 	vmls.f64	d5, d4, d12
10006ed2:	ee33 3b01 	vadd.f64	d3, d3, d1
10006ed6:	ee37 7b04 	vadd.f64	d7, d7, d4
10006eda:	ed8d 5b28 	vstr	d5, [sp, #160]	@ 0xa0
10006ede:	ee27 6b0f 	vmul.f64	d6, d7, d15
10006ee2:	ee23 5b0f 	vmul.f64	d5, d3, d15
10006ee6:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006eea:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10006eee:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006ef2:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10006ef6:	ee06 7b4c 	vmls.f64	d7, d6, d12
10006efa:	ee05 3b4c 	vmls.f64	d3, d5, d12
10006efe:	ed8d 7b26 	vstr	d7, [sp, #152]	@ 0x98
10006f02:	ed8d 3b22 	vstr	d3, [sp, #136]	@ 0x88
10006f06:	ab22      	add	r3, sp, #136	@ 0x88
10006f08:	cb0f      	ldmia	r3, {r0, r1, r2, r3}
10006f0a:	e885 000f 	stmia.w	r5, {r0, r1, r2, r3}
10006f0e:	ab26      	add	r3, sp, #152	@ 0x98
10006f10:	cb0f      	ldmia	r3, {r0, r1, r2, r3}
10006f12:	3710      	adds	r7, #16
10006f14:	e884 000f 	stmia.w	r4, {r0, r1, r2, r3}
10006f18:	f1be 0e01 	subs.w	lr, lr, #1
10006f1c:	f47f ad14 	bne.w	10006948 <fndsa_vect_mul_fft_fp64_exact+0x60>
10006f20:	b03b      	add	sp, #236	@ 0xec
10006f22:	ecbd 8b10 	vpop	{d8-d15}
10006f26:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10006f2a:	bf00      	nop
10006f2c:	f3af 8000 	nop.w
10006f30:	00000000 	.word	0x00000000
10006f34:	42000000 	.word	0x42000000

