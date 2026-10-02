
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/c-perf/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10006c78 <fndsa_vect_iFFT_fp64_exact>:
10006c78:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10006c7c:	ed2d 8b10 	vpush	{d8-d15}
10006c80:	1e44      	subs	r4, r0, #1
10006c82:	b0bb      	sub	sp, #236	@ 0xec
10006c84:	f000 82cb 	beq.w	1000721e <fndsa_vect_iFFT_fp64_exact+0x5a6>
10006c88:	2310      	movs	r3, #16
10006c8a:	f04f 0c01 	mov.w	ip, #1
10006c8e:	ed9f dbfa 	vldr	d13, [pc, #1000]	@ 10007078 <fndsa_vect_iFFT_fp64_exact+0x400>
10006c92:	ed9f fbfb 	vldr	d15, [pc, #1004]	@ 10007080 <fndsa_vect_iFFT_fp64_exact+0x408>
10006c96:	fa03 fb04 	lsl.w	fp, r3, r4
10006c9a:	2301      	movs	r3, #1
10006c9c:	46e6      	mov	lr, ip
10006c9e:	2710      	movs	r7, #16
10006ca0:	46d9      	mov	r9, fp
10006ca2:	eeb7 eb00 	vmov.f64	d14, #112	@ 0x3f800000  1.0
10006ca6:	f04f 0a00 	mov.w	sl, #0
10006caa:	468b      	mov	fp, r1
10006cac:	4afa      	ldr	r2, [pc, #1000]	@ (10007098 <fndsa_vect_iFFT_fp64_exact+0x420>)
10006cae:	40a3      	lsls	r3, r4
10006cb0:	eb03 0353 	add.w	r3, r3, r3, lsr #1
10006cb4:	e9cd e413 	strd	lr, r4, [sp, #76]	@ 0x4c
10006cb8:	ea4f 0c4c 	mov.w	ip, ip, lsl #1
10006cbc:	eb02 1303 	add.w	r3, r2, r3, lsl #4
10006cc0:	40a7      	lsls	r7, r4
10006cc2:	9312      	str	r3, [sp, #72]	@ 0x48
10006cc4:	eb01 160e 	add.w	r6, r1, lr, lsl #4
10006cc8:	4417      	add	r7, r2
10006cca:	f8cd c044 	str.w	ip, [sp, #68]	@ 0x44
10006cce:	9115      	str	r1, [sp, #84]	@ 0x54
10006cd0:	ea4f 180c 	mov.w	r8, ip, lsl #4
10006cd4:	9b13      	ldr	r3, [sp, #76]	@ 0x4c
10006cd6:	4453      	add	r3, sl
10006cd8:	459a      	cmp	sl, r3
10006cda:	f080 828f 	bcs.w	100071fc <fndsa_vect_iFFT_fp64_exact+0x584>
10006cde:	edd7 7a02 	vldr	s15, [r7, #8]
10006ce2:	edd7 6a00 	vldr	s13, [r7]
10006ce6:	eeb8 5b67 	vcvt.f64.u32	d5, s15
10006cea:	eeb8 3b66 	vcvt.f64.u32	d3, s13
10006cee:	ee3d 5b45 	vsub.f64	d5, d13, d5
10006cf2:	edd7 6a01 	vldr	s13, [r7, #4]
10006cf6:	edd7 7a03 	vldr	s15, [r7, #12]
10006cfa:	eeb8 2b66 	vcvt.f64.u32	d2, s13
10006cfe:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10006d02:	ee25 6b0f 	vmul.f64	d6, d5, d15
10006d06:	ee3d 7b47 	vsub.f64	d7, d13, d7
10006d0a:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006d0e:	ee37 7b4e 	vsub.f64	d7, d7, d14
10006d12:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006d16:	ee37 7b06 	vadd.f64	d7, d7, d6
10006d1a:	ee27 4b0f 	vmul.f64	d4, d7, d15
10006d1e:	ee06 5b4d 	vmls.f64	d5, d6, d13
10006d22:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10006d26:	ed8d 5b06 	vstr	d5, [sp, #24]
10006d2a:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10006d2e:	ee35 5b03 	vadd.f64	d5, d5, d3
10006d32:	ee04 7b4d 	vmls.f64	d7, d4, d13
10006d36:	ee25 6b0f 	vmul.f64	d6, d5, d15
10006d3a:	eeb0 4b47 	vmov.f64	d4, d7
10006d3e:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006d42:	ed8d 7b04 	vstr	d7, [sp, #16]
10006d46:	eeb8 7b46 	vcvt.f64.u32	d7, s12
10006d4a:	ee34 6b02 	vadd.f64	d6, d4, d2
10006d4e:	ee36 6b07 	vadd.f64	d6, d6, d7
10006d52:	ee07 5b4d 	vmls.f64	d5, d7, d13
10006d56:	ee26 7b0f 	vmul.f64	d7, d6, d15
10006d5a:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006d5e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006d62:	ee07 6b4d 	vmls.f64	d6, d7, d13
10006d66:	ed8d 3b0a 	vstr	d3, [sp, #40]	@ 0x28
10006d6a:	ed8d 2b08 	vstr	d2, [sp, #32]
10006d6e:	4634      	mov	r4, r6
10006d70:	4659      	mov	r1, fp
10006d72:	ed8d 5b0e 	vstr	d5, [sp, #56]	@ 0x38
10006d76:	ed8d 6b0c 	vstr	d6, [sp, #48]	@ 0x30
10006d7a:	eb09 050b 	add.w	r5, r9, fp
10006d7e:	eb09 0006 	add.w	r0, r9, r6
10006d82:	9710      	str	r7, [sp, #64]	@ 0x40
10006d84:	ed91 3b02 	vldr	d3, [r1, #8]
10006d88:	ed9d 4b08 	vldr	d4, [sp, #32]
10006d8c:	ed94 2b02 	vldr	d2, [r4, #8]
10006d90:	ed95 7b02 	vldr	d7, [r5, #8]
10006d94:	eeb0 0b44 	vmov.f64	d0, d4
10006d98:	ed8d 4b2a 	vstr	d4, [sp, #168]	@ 0xa8
10006d9c:	ed9d 6b04 	vldr	d6, [sp, #16]
10006da0:	ee33 4b0d 	vadd.f64	d4, d3, d13
10006da4:	ed91 5b00 	vldr	d5, [r1]
10006da8:	ee33 3b02 	vadd.f64	d3, d3, d2
10006dac:	ee34 4b42 	vsub.f64	d4, d4, d2
10006db0:	ed8d 6b2e 	vstr	d6, [sp, #184]	@ 0xb8
10006db4:	ee37 2b0d 	vadd.f64	d2, d7, d13
10006db8:	ed90 6b02 	vldr	d6, [r0, #8]
10006dbc:	ed94 9b00 	vldr	d9, [r4]
10006dc0:	ee36 7b07 	vadd.f64	d7, d6, d7
10006dc4:	ee32 2b46 	vsub.f64	d2, d2, d6
10006dc8:	ed9d 8b06 	vldr	d8, [sp, #24]
10006dcc:	ee35 6b0d 	vadd.f64	d6, d5, d13
10006dd0:	ed8d 8b30 	vstr	d8, [sp, #192]	@ 0xc0
10006dd4:	ee35 5b09 	vadd.f64	d5, d5, d9
10006dd8:	ee24 8b0f 	vmul.f64	d8, d4, d15
10006ddc:	ee36 6b49 	vsub.f64	d6, d6, d9
10006de0:	ee27 9b0f 	vmul.f64	d9, d7, d15
10006de4:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10006de8:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10006dec:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10006df0:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10006df4:	ee08 4b4d 	vmls.f64	d4, d8, d13
10006df8:	ee09 7b4d 	vmls.f64	d7, d9, d13
10006dfc:	ee36 6b4e 	vsub.f64	d6, d6, d14
10006e00:	ee34 bb0e 	vadd.f64	d11, d4, d14
10006e04:	ee36 6b08 	vadd.f64	d6, d6, d8
10006e08:	ee23 4b0f 	vmul.f64	d4, d3, d15
10006e0c:	ee37 cb0e 	vadd.f64	d12, d7, d14
10006e10:	ee22 8b0f 	vmul.f64	d8, d2, d15
10006e14:	ed95 7b00 	vldr	d7, [r5]
10006e18:	ed90 ab00 	vldr	d10, [r0]
10006e1c:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10006e20:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10006e24:	ee37 7b0d 	vadd.f64	d7, d7, d13
10006e28:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10006e2c:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10006e30:	ee37 7b4a 	vsub.f64	d7, d7, d10
10006e34:	ee35 5b04 	vadd.f64	d5, d5, d4
10006e38:	ee08 2b4d 	vmls.f64	d2, d8, d13
10006e3c:	ee04 3b4d 	vmls.f64	d3, d4, d13
10006e40:	ee37 7b4e 	vsub.f64	d7, d7, d14
10006e44:	ed95 4b00 	vldr	d4, [r5]
10006e48:	ee37 7b08 	vadd.f64	d7, d7, d8
10006e4c:	ee34 4b0a 	vadd.f64	d4, d4, d10
10006e50:	ee26 8b0f 	vmul.f64	d8, d6, d15
10006e54:	ee32 ab0e 	vadd.f64	d10, d2, d14
10006e58:	ee25 2b0f 	vmul.f64	d2, d5, d15
10006e5c:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10006e60:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10006e64:	ee34 4b09 	vadd.f64	d4, d4, d9
10006e68:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10006e6c:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10006e70:	ee08 6b4d 	vmls.f64	d6, d8, d13
10006e74:	ee02 5b4d 	vmls.f64	d5, d2, d13
10006e78:	ee24 8b0f 	vmul.f64	d8, d4, d15
10006e7c:	ee27 2b0f 	vmul.f64	d2, d7, d15
10006e80:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10006e84:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10006e88:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10006e8c:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10006e90:	ed9f 9b7d 	vldr	d9, [pc, #500]	@ 10007088 <fndsa_vect_iFFT_fp64_exact+0x410>
10006e94:	ee33 3b0e 	vadd.f64	d3, d3, d14
10006e98:	ee08 4b4d 	vmls.f64	d4, d8, d13
10006e9c:	ee02 7b4d 	vmls.f64	d7, d2, d13
10006ea0:	ee36 6b09 	vadd.f64	d6, d6, d9
10006ea4:	ee23 2b0f 	vmul.f64	d2, d3, d15
10006ea8:	ee35 5b09 	vadd.f64	d5, d5, d9
10006eac:	ee34 4b09 	vadd.f64	d4, d4, d9
10006eb0:	ee37 7b09 	vadd.f64	d7, d7, d9
10006eb4:	ee2b 9b0f 	vmul.f64	d9, d11, d15
10006eb8:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10006ebc:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10006ec0:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10006ec4:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10006ec8:	ee02 3b4d 	vmls.f64	d3, d2, d13
10006ecc:	ee36 6b09 	vadd.f64	d6, d6, d9
10006ed0:	ee09 bb4d 	vmls.f64	d11, d9, d13
10006ed4:	eeb6 9b00 	vmov.f64	d9, #96	@ 0x3f000000  0.5
10006ed8:	ee35 5b02 	vadd.f64	d5, d5, d2
10006edc:	ee2b 8b09 	vmul.f64	d8, d11, d9
10006ee0:	ee23 3b09 	vmul.f64	d3, d3, d9
10006ee4:	ee2c 2b0f 	vmul.f64	d2, d12, d15
10006ee8:	ee2a bb0f 	vmul.f64	d11, d10, d15
10006eec:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006ef0:	eebc bbcb 	vcvt.u32.f64	s22, d11
10006ef4:	eefc 3bc2 	vcvt.u32.f64	s7, d2
10006ef8:	eeb8 bb4b 	vcvt.f64.u32	d11, s22
10006efc:	eeb8 9b43 	vcvt.f64.u32	d9, s6
10006f00:	eeb8 3b63 	vcvt.f64.u32	d3, s7
10006f04:	ee0b ab4d 	vmls.f64	d10, d11, d13
10006f08:	ee34 4b03 	vadd.f64	d4, d4, d3
10006f0c:	ee03 cb4d 	vmls.f64	d12, d3, d13
10006f10:	eeb6 3b00 	vmov.f64	d3, #96	@ 0x3f000000  0.5
10006f14:	ee2c 2b03 	vmul.f64	d2, d12, d3
10006f18:	ee2a ab03 	vmul.f64	d10, d10, d3
10006f1c:	ee26 3b0f 	vmul.f64	d3, d6, d15
10006f20:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006f24:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10006f28:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10006f2c:	ee37 7b0b 	vadd.f64	d7, d7, d11
10006f30:	eeb8 bb42 	vcvt.f64.u32	d11, s4
10006f34:	ee25 2b0f 	vmul.f64	d2, d5, d15
10006f38:	ee03 6b4d 	vmls.f64	d6, d3, d13
10006f3c:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10006f40:	eefc 6bc6 	vcvt.u32.f64	s13, d6
10006f44:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10006f48:	ee16 3a90 	vmov	r3, s13
10006f4c:	ee02 5b4d 	vmls.f64	d5, d2, d13
10006f50:	0fdf      	lsrs	r7, r3, #31
10006f52:	eefc 6bc5 	vcvt.u32.f64	s13, d5
10006f56:	ee05 7a10 	vmov	s10, r7
10006f5a:	085f      	lsrs	r7, r3, #1
10006f5c:	ee06 7a10 	vmov	s12, r7
10006f60:	ee16 2a90 	vmov	r2, s13
10006f64:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10006f68:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10006f6c:	f003 0301 	and.w	r3, r3, #1
10006f70:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10006f74:	eeb0 2b46 	vmov.f64	d2, d6
10006f78:	ee06 3a90 	vmov	s13, r3
10006f7c:	ed9f 3b44 	vldr	d3, [pc, #272]	@ 10007090 <fndsa_vect_iFFT_fp64_exact+0x418>
10006f80:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
10006f84:	eeb8 6be6 	vcvt.f64.s32	d6, s13
10006f88:	eeb0 cb48 	vmov.f64	d12, d8
10006f8c:	ea4f 0c52 	mov.w	ip, r2, lsr #1
10006f90:	0fd7      	lsrs	r7, r2, #31
10006f92:	ee05 2b03 	vmla.f64	d2, d5, d3
10006f96:	ee06 cb03 	vmla.f64	d12, d6, d3
10006f9a:	ee05 7a10 	vmov	s10, r7
10006f9e:	ee06 ca90 	vmov	s13, ip
10006fa2:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
10006fa6:	eeb8 6be6 	vcvt.f64.s32	d6, s13
10006faa:	ee05 6b03 	vmla.f64	d6, d5, d3
10006fae:	f002 0201 	and.w	r2, r2, #1
10006fb2:	ed81 6b00 	vstr	d6, [r1]
10006fb6:	ee06 2a90 	vmov	s13, r2
10006fba:	eeb8 6be6 	vcvt.f64.s32	d6, s13
10006fbe:	ee06 9b03 	vmla.f64	d9, d6, d3
10006fc2:	ee24 6b0f 	vmul.f64	d6, d4, d15
10006fc6:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006fca:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006fce:	ee27 5b0f 	vmul.f64	d5, d7, d15
10006fd2:	ee06 4b4d 	vmls.f64	d4, d6, d13
10006fd6:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10006fda:	eefc 6bc4 	vcvt.u32.f64	s13, d4
10006fde:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10006fe2:	ee16 2a90 	vmov	r2, s13
10006fe6:	ee05 7b4d 	vmls.f64	d7, d5, d13
10006fea:	0fd7      	lsrs	r7, r2, #31
10006fec:	ee06 7a10 	vmov	s12, r7
10006ff0:	0857      	lsrs	r7, r2, #1
10006ff2:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10006ff6:	ee07 7a10 	vmov	s14, r7
10006ffa:	ee17 3a90 	vmov	r3, s15
10006ffe:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10007002:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10007006:	ee06 7b03 	vmla.f64	d7, d6, d3
1000700a:	f002 0201 	and.w	r2, r2, #1
1000700e:	ed81 9b02 	vstr	d9, [r1, #8]
10007012:	ed85 7b00 	vstr	d7, [r5]
10007016:	ee07 2a90 	vmov	s15, r2
1000701a:	eeb8 7be7 	vcvt.f64.s32	d7, s15
1000701e:	0fda      	lsrs	r2, r3, #31
10007020:	ee07 bb03 	vmla.f64	d11, d7, d3
10007024:	ee07 2a10 	vmov	s14, r2
10007028:	085a      	lsrs	r2, r3, #1
1000702a:	ee08 2a10 	vmov	s16, r2
1000702e:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10007032:	eeb8 8bc8 	vcvt.f64.s32	d8, s16
10007036:	f003 0301 	and.w	r3, r3, #1
1000703a:	ee07 8b03 	vmla.f64	d8, d7, d3
1000703e:	eebc abca 	vcvt.u32.f64	s20, d10
10007042:	ee07 3a90 	vmov	s15, r3
10007046:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
1000704a:	eeb8 7be7 	vcvt.f64.s32	d7, s15
1000704e:	ed9d 1b0a 	vldr	d1, [sp, #40]	@ 0x28
10007052:	ee07 ab03 	vmla.f64	d10, d7, d3
10007056:	ed85 bb02 	vstr	d11, [r5, #8]
1000705a:	eeb0 3b4c 	vmov.f64	d3, d12
1000705e:	ed8d 1b2c 	vstr	d1, [sp, #176]	@ 0xb0
10007062:	ed8d 2b32 	vstr	d2, [sp, #200]	@ 0xc8
10007066:	ed8d cb34 	vstr	d12, [sp, #208]	@ 0xd0
1000706a:	ed8d 2b00 	vstr	d2, [sp]
1000706e:	ed8d cb02 	vstr	d12, [sp, #8]
10007072:	e013      	b.n	1000709c <fndsa_vect_iFFT_fp64_exact+0x424>
10007074:	f3af 8000 	nop.w
10007078:	00000000 	.word	0x00000000
1000707c:	41f00000 	.word	0x41f00000
10007080:	00000000 	.word	0x00000000
10007084:	3df00000 	.word	0x3df00000
	...
10007094:	41e00000 	.word	0x41e00000
10007098:	300039a0 	.word	0x300039a0
1000709c:	ed8d 8b36 	vstr	d8, [sp, #216]	@ 0xd8
100070a0:	ed8d ab38 	vstr	d10, [sp, #224]	@ 0xe0
100070a4:	f7ff fa14 	bl	100064d0 <fndsa_fp64e_mul>
100070a8:	eeb0 2b48 	vmov.f64	d2, d8
100070ac:	eeb0 9b40 	vmov.f64	d9, d0
100070b0:	eeb0 bb41 	vmov.f64	d11, d1
100070b4:	ed8d 0b16 	vstr	d0, [sp, #88]	@ 0x58
100070b8:	ed8d 1b18 	vstr	d1, [sp, #96]	@ 0x60
100070bc:	ed9d 0b04 	vldr	d0, [sp, #16]
100070c0:	ed9d 1b06 	vldr	d1, [sp, #24]
100070c4:	eeb0 3b4a 	vmov.f64	d3, d10
100070c8:	f7ff fa02 	bl	100064d0 <fndsa_fp64e_mul>
100070cc:	ed9d 6b02 	vldr	d6, [sp, #8]
100070d0:	ee3a 3b06 	vadd.f64	d3, d10, d6
100070d4:	ee23 6b0f 	vmul.f64	d6, d3, d15
100070d8:	ed9d 2b00 	vldr	d2, [sp]
100070dc:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100070e0:	ee38 2b02 	vadd.f64	d2, d8, d2
100070e4:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100070e8:	ee32 2b06 	vadd.f64	d2, d2, d6
100070ec:	ee06 3b4d 	vmls.f64	d3, d6, d13
100070f0:	ee22 6b0f 	vmul.f64	d6, d2, d15
100070f4:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100070f8:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100070fc:	ed9d 7b0e 	vldr	d7, [sp, #56]	@ 0x38
10007100:	eeb0 cb40 	vmov.f64	d12, d0
10007104:	ee06 2b4d 	vmls.f64	d2, d6, d13
10007108:	ed8d 0b1a 	vstr	d0, [sp, #104]	@ 0x68
1000710c:	ed9d 0b0c 	vldr	d0, [sp, #48]	@ 0x30
10007110:	ed8d 1b1c 	vstr	d1, [sp, #112]	@ 0x70
10007114:	ed8d 1b00 	vstr	d1, [sp]
10007118:	eeb0 1b47 	vmov.f64	d1, d7
1000711c:	ed8d 0b26 	vstr	d0, [sp, #152]	@ 0x98
10007120:	ed8d 7b28 	vstr	d7, [sp, #160]	@ 0xa0
10007124:	ed8d 3b24 	vstr	d3, [sp, #144]	@ 0x90
10007128:	ed8d 2b22 	vstr	d2, [sp, #136]	@ 0x88
1000712c:	f7ff f9d0 	bl	100064d0 <fndsa_fp64e_mul>
10007130:	ed9d 7b00 	vldr	d7, [sp]
10007134:	ee3b 6b07 	vadd.f64	d6, d11, d7
10007138:	ee26 5b0f 	vmul.f64	d5, d6, d15
1000713c:	ee3b bb0d 	vadd.f64	d11, d11, d13
10007140:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10007144:	ee3b bb47 	vsub.f64	d11, d11, d7
10007148:	eeb8 5b45 	vcvt.f64.u32	d5, s10
1000714c:	ee39 7b0c 	vadd.f64	d7, d9, d12
10007150:	ee37 7b05 	vadd.f64	d7, d7, d5
10007154:	ee27 4b0f 	vmul.f64	d4, d7, d15
10007158:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000715c:	ee05 6b4d 	vmls.f64	d6, d5, d13
10007160:	ed8d 1b20 	vstr	d1, [sp, #128]	@ 0x80
10007164:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10007168:	ee31 1b0d 	vadd.f64	d1, d1, d13
1000716c:	ee04 7b4d 	vmls.f64	d7, d4, d13
10007170:	ee31 6b46 	vsub.f64	d6, d1, d6
10007174:	ed8d 0b1e 	vstr	d0, [sp, #120]	@ 0x78
10007178:	ee30 0b0d 	vadd.f64	d0, d0, d13
1000717c:	ee30 0b47 	vsub.f64	d0, d0, d7
10007180:	ee26 7b0f 	vmul.f64	d7, d6, d15
10007184:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007188:	ee30 0b4e 	vsub.f64	d0, d0, d14
1000718c:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007190:	ee2b 5b0f 	vmul.f64	d5, d11, d15
10007194:	ee30 0b07 	vadd.f64	d0, d0, d7
10007198:	ee39 9b0d 	vadd.f64	d9, d9, d13
1000719c:	ee07 6b4d 	vmls.f64	d6, d7, d13
100071a0:	ee39 9b4c 	vsub.f64	d9, d9, d12
100071a4:	ee20 7b0f 	vmul.f64	d7, d0, d15
100071a8:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100071ac:	ee39 9b4e 	vsub.f64	d9, d9, d14
100071b0:	eeb8 5b45 	vcvt.f64.u32	d5, s10
100071b4:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100071b8:	ee39 9b05 	vadd.f64	d9, d9, d5
100071bc:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100071c0:	ee07 0b4d 	vmls.f64	d0, d7, d13
100071c4:	ee29 7b0f 	vmul.f64	d7, d9, d15
100071c8:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100071cc:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100071d0:	ee05 bb4d 	vmls.f64	d11, d5, d13
100071d4:	ee07 9b4d 	vmls.f64	d9, d7, d13
100071d8:	3110      	adds	r1, #16
100071da:	3010      	adds	r0, #16
100071dc:	428e      	cmp	r6, r1
100071de:	f104 0410 	add.w	r4, r4, #16
100071e2:	ed04 bb02 	vstr	d11, [r4, #-8]
100071e6:	ed04 9b04 	vstr	d9, [r4, #-16]
100071ea:	f105 0510 	add.w	r5, r5, #16
100071ee:	ed00 0b04 	vstr	d0, [r0, #-16]
100071f2:	ed00 6b02 	vstr	d6, [r0, #-8]
100071f6:	f47f adc5 	bne.w	10006d84 <fndsa_vect_iFFT_fp64_exact+0x10c>
100071fa:	9f10      	ldr	r7, [sp, #64]	@ 0x40
100071fc:	9b11      	ldr	r3, [sp, #68]	@ 0x44
100071fe:	3710      	adds	r7, #16
10007200:	449a      	add	sl, r3
10007202:	9b12      	ldr	r3, [sp, #72]	@ 0x48
10007204:	44c3      	add	fp, r8
10007206:	42bb      	cmp	r3, r7
10007208:	4446      	add	r6, r8
1000720a:	f47f ad63 	bne.w	10006cd4 <fndsa_vect_iFFT_fp64_exact+0x5c>
1000720e:	9c14      	ldr	r4, [sp, #80]	@ 0x50
10007210:	46cb      	mov	fp, r9
10007212:	3c01      	subs	r4, #1
10007214:	f8dd c044 	ldr.w	ip, [sp, #68]	@ 0x44
10007218:	9915      	ldr	r1, [sp, #84]	@ 0x54
1000721a:	f47f ad3e 	bne.w	10006c9a <fndsa_vect_iFFT_fp64_exact+0x22>
1000721e:	b03b      	add	sp, #236	@ 0xec
10007220:	ecbd 8b10 	vpop	{d8-d15}
10007224:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
