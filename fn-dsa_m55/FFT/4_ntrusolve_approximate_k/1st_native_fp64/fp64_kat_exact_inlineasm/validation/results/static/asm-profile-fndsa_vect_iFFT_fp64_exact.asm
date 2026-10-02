
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_kat_exact_inlineasm/validation/build/asm-profile/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10006ab8 <fndsa_vect_iFFT_fp64_exact>:
10006ab8:	3801      	subs	r0, #1
10006aba:	f000 82d3 	beq.w	10007064 <fndsa_vect_iFFT_fp64_exact+0x5ac>
10006abe:	2210      	movs	r2, #16
10006ac0:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10006ac4:	4082      	lsls	r2, r0
10006ac6:	ed2d 8b10 	vpush	{d8-d15}
10006aca:	188f      	adds	r7, r1, r2
10006acc:	468c      	mov	ip, r1
10006ace:	ed9f 9bf8 	vldr	d9, [pc, #992]	@ 10006eb0 <fndsa_vect_iFFT_fp64_exact+0x3f8>
10006ad2:	ed9f dbf9 	vldr	d13, [pc, #996]	@ 10006eb8 <fndsa_vect_iFFT_fp64_exact+0x400>
10006ad6:	ed9f ebfa 	vldr	d14, [pc, #1000]	@ 10006ec0 <fndsa_vect_iFFT_fp64_exact+0x408>
10006ada:	2101      	movs	r1, #1
10006adc:	463b      	mov	r3, r7
10006ade:	b0b7      	sub	sp, #220	@ 0xdc
10006ae0:	2201      	movs	r2, #1
10006ae2:	2700      	movs	r7, #0
10006ae4:	f04f 0a10 	mov.w	sl, #16
10006ae8:	4689      	mov	r9, r1
10006aea:	4091      	lsls	r1, r2
10006aec:	fa0a fa00 	lsl.w	sl, sl, r0
10006af0:	4082      	lsls	r2, r0
10006af2:	9011      	str	r0, [sp, #68]	@ 0x44
10006af4:	eeb7 fb00 	vmov.f64	d15, #112	@ 0x3f800000  1.0
10006af8:	4608      	mov	r0, r1
10006afa:	46bb      	mov	fp, r7
10006afc:	4639      	mov	r1, r7
10006afe:	0852      	lsrs	r2, r2, #1
10006b00:	9210      	str	r2, [sp, #64]	@ 0x40
10006b02:	4af3      	ldr	r2, [pc, #972]	@ (10006ed0 <fndsa_vect_iFFT_fp64_exact+0x418>)
10006b04:	4492      	add	sl, r2
10006b06:	45cb      	cmp	fp, r9
10006b08:	f080 8299 	bcs.w	1000703e <fndsa_vect_iFFT_fp64_exact+0x586>
10006b0c:	edda 7a02 	vldr	s15, [sl, #8]
10006b10:	edda 6a00 	vldr	s13, [sl]
10006b14:	eeb8 5b67 	vcvt.f64.u32	d5, s15
10006b18:	eeb8 4b66 	vcvt.f64.u32	d4, s13
10006b1c:	ee39 5b45 	vsub.f64	d5, d9, d5
10006b20:	edda 6a01 	vldr	s13, [sl, #4]
10006b24:	edda 7a03 	vldr	s15, [sl, #12]
10006b28:	eeb8 3b66 	vcvt.f64.u32	d3, s13
10006b2c:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10006b30:	ee25 6b0d 	vmul.f64	d6, d5, d13
10006b34:	ee39 7b47 	vsub.f64	d7, d9, d7
10006b38:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006b3c:	ee37 7b4f 	vsub.f64	d7, d7, d15
10006b40:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006b44:	ee37 7b06 	vadd.f64	d7, d7, d6
10006b48:	ee06 5b49 	vmls.f64	d5, d6, d9
10006b4c:	ee27 6b0d 	vmul.f64	d6, d7, d13
10006b50:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006b54:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006b58:	ee06 7b49 	vmls.f64	d7, d6, d9
10006b5c:	ed8d 5b04 	vstr	d5, [sp, #16]
10006b60:	ed8d 7b02 	vstr	d7, [sp, #8]
10006b64:	ee35 5b04 	vadd.f64	d5, d5, d4
10006b68:	ee37 7b03 	vadd.f64	d7, d7, d3
10006b6c:	e9cd 010e 	strd	r0, r1, [sp, #56]	@ 0x38
10006b70:	ed8d 4b08 	vstr	d4, [sp, #32]
10006b74:	ed8d 3b06 	vstr	d3, [sp, #24]
10006b78:	ed8d 5b0c 	vstr	d5, [sp, #48]	@ 0x30
10006b7c:	ed8d 7b0a 	vstr	d7, [sp, #40]	@ 0x28
10006b80:	4659      	mov	r1, fp
10006b82:	461f      	mov	r7, r3
10006b84:	46e0      	mov	r8, ip
10006b86:	eb03 160b 	add.w	r6, r3, fp, lsl #4
10006b8a:	eb0c 1509 	add.w	r5, ip, r9, lsl #4
10006b8e:	eb03 1409 	add.w	r4, r3, r9, lsl #4
10006b92:	eb0c 100b 	add.w	r0, ip, fp, lsl #4
10006b96:	ed90 4b02 	vldr	d4, [r0, #8]
10006b9a:	ed95 2b02 	vldr	d2, [r5, #8]
10006b9e:	ee34 3b09 	vadd.f64	d3, d4, d9
10006ba2:	ee33 3b42 	vsub.f64	d3, d3, d2
10006ba6:	ee23 8b0d 	vmul.f64	d8, d3, d13
10006baa:	ed9d 7b02 	vldr	d7, [sp, #8]
10006bae:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10006bb2:	ed96 5b02 	vldr	d5, [r6, #8]
10006bb6:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10006bba:	ed8d 7b2a 	vstr	d7, [sp, #168]	@ 0xa8
10006bbe:	ed9d 7b04 	vldr	d7, [sp, #16]
10006bc2:	ed90 6b00 	vldr	d6, [r0]
10006bc6:	ee34 4b02 	vadd.f64	d4, d4, d2
10006bca:	ee08 3b49 	vmls.f64	d3, d8, d9
10006bce:	ed8d 7b2c 	vstr	d7, [sp, #176]	@ 0xb0
10006bd2:	ee35 2b09 	vadd.f64	d2, d5, d9
10006bd6:	ed94 7b02 	vldr	d7, [r4, #8]
10006bda:	ed95 ab00 	vldr	d10, [r5]
10006bde:	ee37 5b05 	vadd.f64	d5, d7, d5
10006be2:	ee32 2b47 	vsub.f64	d2, d2, d7
10006be6:	ee33 cb0f 	vadd.f64	d12, d3, d15
10006bea:	ee36 7b09 	vadd.f64	d7, d6, d9
10006bee:	ee24 3b0d 	vmul.f64	d3, d4, d13
10006bf2:	ee36 6b0a 	vadd.f64	d6, d6, d10
10006bf6:	ee37 7b4a 	vsub.f64	d7, d7, d10
10006bfa:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006bfe:	ee25 ab0d 	vmul.f64	d10, d5, d13
10006c02:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10006c06:	ee37 7b4f 	vsub.f64	d7, d7, d15
10006c0a:	eebc abca 	vcvt.u32.f64	s20, d10
10006c0e:	ee37 7b08 	vadd.f64	d7, d7, d8
10006c12:	ee36 6b03 	vadd.f64	d6, d6, d3
10006c16:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10006c1a:	ee22 8b0d 	vmul.f64	d8, d2, d13
10006c1e:	ee03 4b49 	vmls.f64	d4, d3, d9
10006c22:	ed96 3b00 	vldr	d3, [r6]
10006c26:	ed94 bb00 	vldr	d11, [r4]
10006c2a:	ee0a 5b49 	vmls.f64	d5, d10, d9
10006c2e:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10006c32:	ee33 3b09 	vadd.f64	d3, d3, d9
10006c36:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10006c3a:	ee35 5b0f 	vadd.f64	d5, d5, d15
10006c3e:	ee33 3b4b 	vsub.f64	d3, d3, d11
10006c42:	ed8d 5b00 	vstr	d5, [sp]
10006c46:	ee08 2b49 	vmls.f64	d2, d8, d9
10006c4a:	ed96 5b00 	vldr	d5, [r6]
10006c4e:	ee33 3b4f 	vsub.f64	d3, d3, d15
10006c52:	ee35 5b0b 	vadd.f64	d5, d5, d11
10006c56:	ee33 3b08 	vadd.f64	d3, d3, d8
10006c5a:	ee32 bb0f 	vadd.f64	d11, d2, d15
10006c5e:	ee27 8b0d 	vmul.f64	d8, d7, d13
10006c62:	ee26 2b0d 	vmul.f64	d2, d6, d13
10006c66:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10006c6a:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10006c6e:	ee35 5b0a 	vadd.f64	d5, d5, d10
10006c72:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10006c76:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10006c7a:	ee08 7b49 	vmls.f64	d7, d8, d9
10006c7e:	ee02 6b49 	vmls.f64	d6, d2, d9
10006c82:	ee25 8b0d 	vmul.f64	d8, d5, d13
10006c86:	ee23 2b0d 	vmul.f64	d2, d3, d13
10006c8a:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10006c8e:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10006c92:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10006c96:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10006c9a:	ed9f ab8b 	vldr	d10, [pc, #556]	@ 10006ec8 <fndsa_vect_iFFT_fp64_exact+0x410>
10006c9e:	ee34 4b0f 	vadd.f64	d4, d4, d15
10006ca2:	ee08 5b49 	vmls.f64	d5, d8, d9
10006ca6:	ee02 3b49 	vmls.f64	d3, d2, d9
10006caa:	ee37 7b0a 	vadd.f64	d7, d7, d10
10006cae:	ee33 3b0a 	vadd.f64	d3, d3, d10
10006cb2:	ee24 2b0d 	vmul.f64	d2, d4, d13
10006cb6:	ee36 6b0a 	vadd.f64	d6, d6, d10
10006cba:	ee35 5b0a 	vadd.f64	d5, d5, d10
10006cbe:	ee2c ab0d 	vmul.f64	d10, d12, d13
10006cc2:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10006cc6:	eebc abca 	vcvt.u32.f64	s20, d10
10006cca:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10006cce:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10006cd2:	ee36 6b02 	vadd.f64	d6, d6, d2
10006cd6:	ee37 7b0a 	vadd.f64	d7, d7, d10
10006cda:	ee0a cb49 	vmls.f64	d12, d10, d9
10006cde:	ee02 4b49 	vmls.f64	d4, d2, d9
10006ce2:	eeb6 ab00 	vmov.f64	d10, #96	@ 0x3f000000  0.5
10006ce6:	ed9d 2b00 	vldr	d2, [sp]
10006cea:	ee24 4b0a 	vmul.f64	d4, d4, d10
10006cee:	ee22 2b0d 	vmul.f64	d2, d2, d13
10006cf2:	ee2c 8b0a 	vmul.f64	d8, d12, d10
10006cf6:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10006cfa:	ee2b ab0d 	vmul.f64	d10, d11, d13
10006cfe:	eefc 4bc2 	vcvt.u32.f64	s9, d2
10006d02:	eeb8 cb44 	vcvt.f64.u32	d12, s8
10006d06:	ed9d 2b00 	vldr	d2, [sp]
10006d0a:	eeb8 4b64 	vcvt.f64.u32	d4, s9
10006d0e:	eebc abca 	vcvt.u32.f64	s20, d10
10006d12:	ee35 5b04 	vadd.f64	d5, d5, d4
10006d16:	ee04 2b49 	vmls.f64	d2, d4, d9
10006d1a:	eeb8 4b4a 	vcvt.f64.u32	d4, s20
10006d1e:	eeb6 ab00 	vmov.f64	d10, #96	@ 0x3f000000  0.5
10006d22:	ee04 bb49 	vmls.f64	d11, d4, d9
10006d26:	ee22 2b0a 	vmul.f64	d2, d2, d10
10006d2a:	ee33 ab04 	vadd.f64	d10, d3, d4
10006d2e:	eeb6 4b00 	vmov.f64	d4, #96	@ 0x3f000000  0.5
10006d32:	ee2b bb04 	vmul.f64	d11, d11, d4
10006d36:	ee27 4b0d 	vmul.f64	d4, d7, d13
10006d3a:	eebc bbcb 	vcvt.u32.f64	s22, d11
10006d3e:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10006d42:	eeb8 3b4b 	vcvt.f64.u32	d3, s22
10006d46:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10006d4a:	ed8d 3b00 	vstr	d3, [sp]
10006d4e:	ee26 3b0d 	vmul.f64	d3, d6, d13
10006d52:	ee04 7b49 	vmls.f64	d7, d4, d9
10006d56:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006d5a:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10006d5e:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10006d62:	ee17 ea90 	vmov	lr, s15
10006d66:	ee03 6b49 	vmls.f64	d6, d3, d9
10006d6a:	ea4f 73de 	mov.w	r3, lr, lsr #31
10006d6e:	eefc 7bc6 	vcvt.u32.f64	s15, d6
10006d72:	ee06 3a10 	vmov	s12, r3
10006d76:	ea4f 035e 	mov.w	r3, lr, lsr #1
10006d7a:	ee0b 3a10 	vmov	s22, r3
10006d7e:	ee17 ca90 	vmov	ip, s15
10006d82:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10006d86:	f00e 0e01 	and.w	lr, lr, #1
10006d8a:	eeb8 bbcb 	vcvt.f64.s32	d11, s22
10006d8e:	ee07 ea90 	vmov	s15, lr
10006d92:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10006d96:	ea4f 73dc 	mov.w	r3, ip, lsr #31
10006d9a:	ee06 bb0e 	vmla.f64	d11, d6, d14
10006d9e:	ee06 3a10 	vmov	s12, r3
10006da2:	ea4f 035c 	mov.w	r3, ip, lsr #1
10006da6:	ee04 3a90 	vmov	s9, r3
10006daa:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10006dae:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10006db2:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10006db6:	ee07 8b0e 	vmla.f64	d8, d7, d14
10006dba:	eeb8 7be4 	vcvt.f64.s32	d7, s9
10006dbe:	ee06 7b0e 	vmla.f64	d7, d6, d14
10006dc2:	f00c 0c01 	and.w	ip, ip, #1
10006dc6:	ed80 7b00 	vstr	d7, [r0]
10006dca:	ee07 ca90 	vmov	s15, ip
10006dce:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10006dd2:	ee07 cb0e 	vmla.f64	d12, d7, d14
10006dd6:	ee25 7b0d 	vmul.f64	d7, d5, d13
10006dda:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006dde:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006de2:	ee2a 6b0d 	vmul.f64	d6, d10, d13
10006de6:	ee07 5b49 	vmls.f64	d5, d7, d9
10006dea:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006dee:	eefc 7bc5 	vcvt.u32.f64	s15, d5
10006df2:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006df6:	ee17 ea90 	vmov	lr, s15
10006dfa:	ee06 ab49 	vmls.f64	d10, d6, d9
10006dfe:	ea4f 73de 	mov.w	r3, lr, lsr #31
10006e02:	ee06 3a10 	vmov	s12, r3
10006e06:	ea4f 035e 	mov.w	r3, lr, lsr #1
10006e0a:	eefc 7bca 	vcvt.u32.f64	s15, d10
10006e0e:	ee07 3a10 	vmov	s14, r3
10006e12:	ee17 ca90 	vmov	ip, s15
10006e16:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10006e1a:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10006e1e:	ee06 7b0e 	vmla.f64	d7, d6, d14
10006e22:	f00e 0e01 	and.w	lr, lr, #1
10006e26:	ed80 cb02 	vstr	d12, [r0, #8]
10006e2a:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10006e2e:	ed86 7b00 	vstr	d7, [r6]
10006e32:	ee07 ea90 	vmov	s15, lr
10006e36:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10006e3a:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10006e3e:	ea4f 73dc 	mov.w	r3, ip, lsr #31
10006e42:	ee06 3a10 	vmov	s12, r3
10006e46:	ea4f 035c 	mov.w	r3, ip, lsr #1
10006e4a:	f00c 0c01 	and.w	ip, ip, #1
10006e4e:	ee07 2b0e 	vmla.f64	d2, d7, d14
10006e52:	ee0a 3a10 	vmov	s20, r3
10006e56:	ee07 ca90 	vmov	s15, ip
10006e5a:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10006e5e:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10006e62:	ed9d cb00 	vldr	d12, [sp]
10006e66:	eeb8 abca 	vcvt.f64.s32	d10, s20
10006e6a:	ee07 cb0e 	vmla.f64	d12, d7, d14
10006e6e:	ee06 ab0e 	vmla.f64	d10, d6, d14
10006e72:	ed9d 0b06 	vldr	d0, [sp, #24]
10006e76:	ed9d 1b08 	vldr	d1, [sp, #32]
10006e7a:	ed86 2b02 	vstr	d2, [r6, #8]
10006e7e:	eeb0 3b48 	vmov.f64	d3, d8
10006e82:	eeb0 2b4b 	vmov.f64	d2, d11
10006e86:	ed8d 0b26 	vstr	d0, [sp, #152]	@ 0x98
10006e8a:	ed8d 1b28 	vstr	d1, [sp, #160]	@ 0xa0
10006e8e:	ed8d ab32 	vstr	d10, [sp, #200]	@ 0xc8
10006e92:	ed8d bb2e 	vstr	d11, [sp, #184]	@ 0xb8
10006e96:	ed8d 8b30 	vstr	d8, [sp, #192]	@ 0xc0
10006e9a:	ed8d cb34 	vstr	d12, [sp, #208]	@ 0xd0
10006e9e:	f003 fa5f 	bl	1000a360 <fndsa_fp64e_mul>
10006ea2:	ed9d 2b32 	vldr	d2, [sp, #200]	@ 0xc8
10006ea6:	ed8d 0b12 	vstr	d0, [sp, #72]	@ 0x48
10006eaa:	ed8d 1b14 	vstr	d1, [sp, #80]	@ 0x50
10006eae:	e011      	b.n	10006ed4 <fndsa_vect_iFFT_fp64_exact+0x41c>
10006eb0:	00000000 	.word	0x00000000
10006eb4:	41f00000 	.word	0x41f00000
10006eb8:	00000000 	.word	0x00000000
10006ebc:	3df00000 	.word	0x3df00000
10006ec0:	00000000 	.word	0x00000000
10006ec4:	41e00000 	.word	0x41e00000
	...
10006ed0:	300039a0 	.word	0x300039a0
10006ed4:	ed9d 0b2a 	vldr	d0, [sp, #168]	@ 0xa8
10006ed8:	ed9d 1b2c 	vldr	d1, [sp, #176]	@ 0xb0
10006edc:	ed9d 3b34 	vldr	d3, [sp, #208]	@ 0xd0
10006ee0:	f003 fa3e 	bl	1000a360 <fndsa_fp64e_mul>
10006ee4:	ed9d 6b0c 	vldr	d6, [sp, #48]	@ 0x30
10006ee8:	ee26 7b0d 	vmul.f64	d7, d6, d13
10006eec:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006ef0:	ed9d 5b0a 	vldr	d5, [sp, #40]	@ 0x28
10006ef4:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006ef8:	ee3c 3b08 	vadd.f64	d3, d12, d8
10006efc:	ee07 6b49 	vmls.f64	d6, d7, d9
10006f00:	ed8d 0b16 	vstr	d0, [sp, #88]	@ 0x58
10006f04:	ee35 0b07 	vadd.f64	d0, d5, d7
10006f08:	ee23 7b0d 	vmul.f64	d7, d3, d13
10006f0c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006f10:	ee3a ab0b 	vadd.f64	d10, d10, d11
10006f14:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006f18:	ee3a 2b07 	vadd.f64	d2, d10, d7
10006f1c:	ee07 3b49 	vmls.f64	d3, d7, d9
10006f20:	ed8d 1b18 	vstr	d1, [sp, #96]	@ 0x60
10006f24:	ee22 7b0d 	vmul.f64	d7, d2, d13
10006f28:	eeb0 1b46 	vmov.f64	d1, d6
10006f2c:	ed8d 6b24 	vstr	d6, [sp, #144]	@ 0x90
10006f30:	ee20 6b0d 	vmul.f64	d6, d0, d13
10006f34:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006f38:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006f3c:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006f40:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006f44:	ee07 2b49 	vmls.f64	d2, d7, d9
10006f48:	ee06 0b49 	vmls.f64	d0, d6, d9
10006f4c:	ed8d 3b20 	vstr	d3, [sp, #128]	@ 0x80
10006f50:	ed8d 0b22 	vstr	d0, [sp, #136]	@ 0x88
10006f54:	ed8d 2b1e 	vstr	d2, [sp, #120]	@ 0x78
10006f58:	f003 fa02 	bl	1000a360 <fndsa_fp64e_mul>
10006f5c:	ed9d 4b18 	vldr	d4, [sp, #96]	@ 0x60
10006f60:	ed9d 5b14 	vldr	d5, [sp, #80]	@ 0x50
10006f64:	ee35 6b04 	vadd.f64	d6, d5, d4
10006f68:	ee26 3b0d 	vmul.f64	d3, d6, d13
10006f6c:	ed9d 2b16 	vldr	d2, [sp, #88]	@ 0x58
10006f70:	ed9d 7b12 	vldr	d7, [sp, #72]	@ 0x48
10006f74:	ee35 5b09 	vadd.f64	d5, d5, d9
10006f78:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006f7c:	ee35 5b44 	vsub.f64	d5, d5, d4
10006f80:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10006f84:	ee37 4b02 	vadd.f64	d4, d7, d2
10006f88:	ee03 6b49 	vmls.f64	d6, d3, d9
10006f8c:	ee34 4b03 	vadd.f64	d4, d4, d3
10006f90:	ee37 7b09 	vadd.f64	d7, d7, d9
10006f94:	ee25 3b0d 	vmul.f64	d3, d5, d13
10006f98:	ee37 7b42 	vsub.f64	d7, d7, d2
10006f9c:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006fa0:	ee24 2b0d 	vmul.f64	d2, d4, d13
10006fa4:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10006fa8:	ed8d 1b1c 	vstr	d1, [sp, #112]	@ 0x70
10006fac:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10006fb0:	ee31 1b09 	vadd.f64	d1, d1, d9
10006fb4:	ee03 5b49 	vmls.f64	d5, d3, d9
10006fb8:	ee31 6b46 	vsub.f64	d6, d1, d6
10006fbc:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10006fc0:	ed85 5b02 	vstr	d5, [r5, #8]
10006fc4:	ed8d 0b1a 	vstr	d0, [sp, #104]	@ 0x68
10006fc8:	ee26 5b0d 	vmul.f64	d5, d6, d13
10006fcc:	ee30 0b09 	vadd.f64	d0, d0, d9
10006fd0:	ee02 4b49 	vmls.f64	d4, d2, d9
10006fd4:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10006fd8:	ee30 0b44 	vsub.f64	d0, d0, d4
10006fdc:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10006fe0:	ee30 0b4f 	vsub.f64	d0, d0, d15
10006fe4:	ee30 0b05 	vadd.f64	d0, d0, d5
10006fe8:	ee05 6b49 	vmls.f64	d6, d5, d9
10006fec:	ee20 5b0d 	vmul.f64	d5, d0, d13
10006ff0:	ee37 7b4f 	vsub.f64	d7, d7, d15
10006ff4:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10006ff8:	ee37 7b03 	vadd.f64	d7, d7, d3
10006ffc:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10007000:	ee05 0b49 	vmls.f64	d0, d5, d9
10007004:	ee27 5b0d 	vmul.f64	d5, d7, d13
10007008:	eebc 5bc5 	vcvt.u32.f64	s10, d5
1000700c:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10007010:	ee05 7b49 	vmls.f64	d7, d5, d9
10007014:	3101      	adds	r1, #1
10007016:	3410      	adds	r4, #16
10007018:	4549      	cmp	r1, r9
1000701a:	f105 0510 	add.w	r5, r5, #16
1000701e:	ed05 7b04 	vstr	d7, [r5, #-16]
10007022:	f100 0010 	add.w	r0, r0, #16
10007026:	ed04 0b04 	vstr	d0, [r4, #-16]
1000702a:	ed04 6b02 	vstr	d6, [r4, #-8]
1000702e:	f106 0610 	add.w	r6, r6, #16
10007032:	f47f adb0 	bne.w	10006b96 <fndsa_vect_iFFT_fp64_exact+0xde>
10007036:	e9dd 010e 	ldrd	r0, r1, [sp, #56]	@ 0x38
1000703a:	463b      	mov	r3, r7
1000703c:	46c4      	mov	ip, r8
1000703e:	9a10      	ldr	r2, [sp, #64]	@ 0x40
10007040:	3101      	adds	r1, #1
10007042:	4291      	cmp	r1, r2
10007044:	4483      	add	fp, r0
10007046:	4481      	add	r9, r0
10007048:	f10a 0a10 	add.w	sl, sl, #16
1000704c:	f47f ad5b 	bne.w	10006b06 <fndsa_vect_iFFT_fp64_exact+0x4e>
10007050:	4601      	mov	r1, r0
10007052:	9811      	ldr	r0, [sp, #68]	@ 0x44
10007054:	3801      	subs	r0, #1
10007056:	f47f ad43 	bne.w	10006ae0 <fndsa_vect_iFFT_fp64_exact+0x28>
1000705a:	b037      	add	sp, #220	@ 0xdc
1000705c:	ecbd 8b10 	vpop	{d8-d15}
10007060:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10007064:	4770      	bx	lr
