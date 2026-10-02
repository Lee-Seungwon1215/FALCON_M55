
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/r1-kat/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

100057a0 <fndsa_vect_iFFT_fp64_exact>:
100057a0:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
100057a4:	ed2d 8b10 	vpush	{d8-d15}
100057a8:	1e44      	subs	r4, r0, #1
100057aa:	b0bb      	sub	sp, #236	@ 0xec
100057ac:	f000 82cb 	beq.w	10005d46 <fndsa_vect_iFFT_fp64_exact+0x5a6>
100057b0:	2310      	movs	r3, #16
100057b2:	f04f 0c01 	mov.w	ip, #1
100057b6:	ed9f dbfa 	vldr	d13, [pc, #1000]	@ 10005ba0 <fndsa_vect_iFFT_fp64_exact+0x400>
100057ba:	ed9f fbfb 	vldr	d15, [pc, #1004]	@ 10005ba8 <fndsa_vect_iFFT_fp64_exact+0x408>
100057be:	fa03 fb04 	lsl.w	fp, r3, r4
100057c2:	2301      	movs	r3, #1
100057c4:	46e6      	mov	lr, ip
100057c6:	2710      	movs	r7, #16
100057c8:	46d9      	mov	r9, fp
100057ca:	eeb7 eb00 	vmov.f64	d14, #112	@ 0x3f800000  1.0
100057ce:	f04f 0a00 	mov.w	sl, #0
100057d2:	468b      	mov	fp, r1
100057d4:	4afa      	ldr	r2, [pc, #1000]	@ (10005bc0 <fndsa_vect_iFFT_fp64_exact+0x420>)
100057d6:	40a3      	lsls	r3, r4
100057d8:	eb03 0353 	add.w	r3, r3, r3, lsr #1
100057dc:	e9cd e413 	strd	lr, r4, [sp, #76]	@ 0x4c
100057e0:	ea4f 0c4c 	mov.w	ip, ip, lsl #1
100057e4:	eb02 1303 	add.w	r3, r2, r3, lsl #4
100057e8:	40a7      	lsls	r7, r4
100057ea:	9312      	str	r3, [sp, #72]	@ 0x48
100057ec:	eb01 160e 	add.w	r6, r1, lr, lsl #4
100057f0:	4417      	add	r7, r2
100057f2:	f8cd c044 	str.w	ip, [sp, #68]	@ 0x44
100057f6:	9115      	str	r1, [sp, #84]	@ 0x54
100057f8:	ea4f 180c 	mov.w	r8, ip, lsl #4
100057fc:	9b13      	ldr	r3, [sp, #76]	@ 0x4c
100057fe:	4453      	add	r3, sl
10005800:	459a      	cmp	sl, r3
10005802:	f080 828f 	bcs.w	10005d24 <fndsa_vect_iFFT_fp64_exact+0x584>
10005806:	edd7 7a02 	vldr	s15, [r7, #8]
1000580a:	edd7 6a00 	vldr	s13, [r7]
1000580e:	eeb8 5b67 	vcvt.f64.u32	d5, s15
10005812:	eeb8 3b66 	vcvt.f64.u32	d3, s13
10005816:	ee3d 5b45 	vsub.f64	d5, d13, d5
1000581a:	edd7 6a01 	vldr	s13, [r7, #4]
1000581e:	edd7 7a03 	vldr	s15, [r7, #12]
10005822:	eeb8 2b66 	vcvt.f64.u32	d2, s13
10005826:	eeb8 7b67 	vcvt.f64.u32	d7, s15
1000582a:	ee25 6b0f 	vmul.f64	d6, d5, d15
1000582e:	ee3d 7b47 	vsub.f64	d7, d13, d7
10005832:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10005836:	ee37 7b4e 	vsub.f64	d7, d7, d14
1000583a:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000583e:	ee37 7b06 	vadd.f64	d7, d7, d6
10005842:	ee27 4b0f 	vmul.f64	d4, d7, d15
10005846:	ee06 5b4d 	vmls.f64	d5, d6, d13
1000584a:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000584e:	ed8d 5b06 	vstr	d5, [sp, #24]
10005852:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10005856:	ee35 5b03 	vadd.f64	d5, d5, d3
1000585a:	ee04 7b4d 	vmls.f64	d7, d4, d13
1000585e:	ee25 6b0f 	vmul.f64	d6, d5, d15
10005862:	eeb0 4b47 	vmov.f64	d4, d7
10005866:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000586a:	ed8d 7b04 	vstr	d7, [sp, #16]
1000586e:	eeb8 7b46 	vcvt.f64.u32	d7, s12
10005872:	ee34 6b02 	vadd.f64	d6, d4, d2
10005876:	ee36 6b07 	vadd.f64	d6, d6, d7
1000587a:	ee07 5b4d 	vmls.f64	d5, d7, d13
1000587e:	ee26 7b0f 	vmul.f64	d7, d6, d15
10005882:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005886:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000588a:	ee07 6b4d 	vmls.f64	d6, d7, d13
1000588e:	ed8d 3b0a 	vstr	d3, [sp, #40]	@ 0x28
10005892:	ed8d 2b08 	vstr	d2, [sp, #32]
10005896:	4634      	mov	r4, r6
10005898:	4659      	mov	r1, fp
1000589a:	ed8d 5b0e 	vstr	d5, [sp, #56]	@ 0x38
1000589e:	ed8d 6b0c 	vstr	d6, [sp, #48]	@ 0x30
100058a2:	eb09 050b 	add.w	r5, r9, fp
100058a6:	eb09 0006 	add.w	r0, r9, r6
100058aa:	9710      	str	r7, [sp, #64]	@ 0x40
100058ac:	ed91 3b02 	vldr	d3, [r1, #8]
100058b0:	ed9d 4b08 	vldr	d4, [sp, #32]
100058b4:	ed94 2b02 	vldr	d2, [r4, #8]
100058b8:	ed95 7b02 	vldr	d7, [r5, #8]
100058bc:	eeb0 0b44 	vmov.f64	d0, d4
100058c0:	ed8d 4b2a 	vstr	d4, [sp, #168]	@ 0xa8
100058c4:	ed9d 6b04 	vldr	d6, [sp, #16]
100058c8:	ee33 4b0d 	vadd.f64	d4, d3, d13
100058cc:	ed91 5b00 	vldr	d5, [r1]
100058d0:	ee33 3b02 	vadd.f64	d3, d3, d2
100058d4:	ee34 4b42 	vsub.f64	d4, d4, d2
100058d8:	ed8d 6b2e 	vstr	d6, [sp, #184]	@ 0xb8
100058dc:	ee37 2b0d 	vadd.f64	d2, d7, d13
100058e0:	ed90 6b02 	vldr	d6, [r0, #8]
100058e4:	ed94 9b00 	vldr	d9, [r4]
100058e8:	ee36 7b07 	vadd.f64	d7, d6, d7
100058ec:	ee32 2b46 	vsub.f64	d2, d2, d6
100058f0:	ed9d 8b06 	vldr	d8, [sp, #24]
100058f4:	ee35 6b0d 	vadd.f64	d6, d5, d13
100058f8:	ed8d 8b30 	vstr	d8, [sp, #192]	@ 0xc0
100058fc:	ee35 5b09 	vadd.f64	d5, d5, d9
10005900:	ee24 8b0f 	vmul.f64	d8, d4, d15
10005904:	ee36 6b49 	vsub.f64	d6, d6, d9
10005908:	ee27 9b0f 	vmul.f64	d9, d7, d15
1000590c:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10005910:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10005914:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10005918:	eeb8 9b49 	vcvt.f64.u32	d9, s18
1000591c:	ee08 4b4d 	vmls.f64	d4, d8, d13
10005920:	ee09 7b4d 	vmls.f64	d7, d9, d13
10005924:	ee36 6b4e 	vsub.f64	d6, d6, d14
10005928:	ee34 bb0e 	vadd.f64	d11, d4, d14
1000592c:	ee36 6b08 	vadd.f64	d6, d6, d8
10005930:	ee23 4b0f 	vmul.f64	d4, d3, d15
10005934:	ee37 cb0e 	vadd.f64	d12, d7, d14
10005938:	ee22 8b0f 	vmul.f64	d8, d2, d15
1000593c:	ed95 7b00 	vldr	d7, [r5]
10005940:	ed90 ab00 	vldr	d10, [r0]
10005944:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10005948:	eebc 8bc8 	vcvt.u32.f64	s16, d8
1000594c:	ee37 7b0d 	vadd.f64	d7, d7, d13
10005950:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10005954:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10005958:	ee37 7b4a 	vsub.f64	d7, d7, d10
1000595c:	ee35 5b04 	vadd.f64	d5, d5, d4
10005960:	ee08 2b4d 	vmls.f64	d2, d8, d13
10005964:	ee04 3b4d 	vmls.f64	d3, d4, d13
10005968:	ee37 7b4e 	vsub.f64	d7, d7, d14
1000596c:	ed95 4b00 	vldr	d4, [r5]
10005970:	ee37 7b08 	vadd.f64	d7, d7, d8
10005974:	ee34 4b0a 	vadd.f64	d4, d4, d10
10005978:	ee26 8b0f 	vmul.f64	d8, d6, d15
1000597c:	ee32 ab0e 	vadd.f64	d10, d2, d14
10005980:	ee25 2b0f 	vmul.f64	d2, d5, d15
10005984:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10005988:	eebc 2bc2 	vcvt.u32.f64	s4, d2
1000598c:	ee34 4b09 	vadd.f64	d4, d4, d9
10005990:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10005994:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10005998:	ee08 6b4d 	vmls.f64	d6, d8, d13
1000599c:	ee02 5b4d 	vmls.f64	d5, d2, d13
100059a0:	ee24 8b0f 	vmul.f64	d8, d4, d15
100059a4:	ee27 2b0f 	vmul.f64	d2, d7, d15
100059a8:	eebc 8bc8 	vcvt.u32.f64	s16, d8
100059ac:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100059b0:	eeb8 8b48 	vcvt.f64.u32	d8, s16
100059b4:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100059b8:	ed9f 9b7d 	vldr	d9, [pc, #500]	@ 10005bb0 <fndsa_vect_iFFT_fp64_exact+0x410>
100059bc:	ee33 3b0e 	vadd.f64	d3, d3, d14
100059c0:	ee08 4b4d 	vmls.f64	d4, d8, d13
100059c4:	ee02 7b4d 	vmls.f64	d7, d2, d13
100059c8:	ee36 6b09 	vadd.f64	d6, d6, d9
100059cc:	ee23 2b0f 	vmul.f64	d2, d3, d15
100059d0:	ee35 5b09 	vadd.f64	d5, d5, d9
100059d4:	ee34 4b09 	vadd.f64	d4, d4, d9
100059d8:	ee37 7b09 	vadd.f64	d7, d7, d9
100059dc:	ee2b 9b0f 	vmul.f64	d9, d11, d15
100059e0:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100059e4:	eebc 9bc9 	vcvt.u32.f64	s18, d9
100059e8:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100059ec:	eeb8 9b49 	vcvt.f64.u32	d9, s18
100059f0:	ee02 3b4d 	vmls.f64	d3, d2, d13
100059f4:	ee36 6b09 	vadd.f64	d6, d6, d9
100059f8:	ee09 bb4d 	vmls.f64	d11, d9, d13
100059fc:	eeb6 9b00 	vmov.f64	d9, #96	@ 0x3f000000  0.5
10005a00:	ee35 5b02 	vadd.f64	d5, d5, d2
10005a04:	ee2b 8b09 	vmul.f64	d8, d11, d9
10005a08:	ee23 3b09 	vmul.f64	d3, d3, d9
10005a0c:	ee2c 2b0f 	vmul.f64	d2, d12, d15
10005a10:	ee2a bb0f 	vmul.f64	d11, d10, d15
10005a14:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10005a18:	eebc bbcb 	vcvt.u32.f64	s22, d11
10005a1c:	eefc 3bc2 	vcvt.u32.f64	s7, d2
10005a20:	eeb8 bb4b 	vcvt.f64.u32	d11, s22
10005a24:	eeb8 9b43 	vcvt.f64.u32	d9, s6
10005a28:	eeb8 3b63 	vcvt.f64.u32	d3, s7
10005a2c:	ee0b ab4d 	vmls.f64	d10, d11, d13
10005a30:	ee34 4b03 	vadd.f64	d4, d4, d3
10005a34:	ee03 cb4d 	vmls.f64	d12, d3, d13
10005a38:	eeb6 3b00 	vmov.f64	d3, #96	@ 0x3f000000  0.5
10005a3c:	ee2c 2b03 	vmul.f64	d2, d12, d3
10005a40:	ee2a ab03 	vmul.f64	d10, d10, d3
10005a44:	ee26 3b0f 	vmul.f64	d3, d6, d15
10005a48:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10005a4c:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10005a50:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10005a54:	ee37 7b0b 	vadd.f64	d7, d7, d11
10005a58:	eeb8 bb42 	vcvt.f64.u32	d11, s4
10005a5c:	ee25 2b0f 	vmul.f64	d2, d5, d15
10005a60:	ee03 6b4d 	vmls.f64	d6, d3, d13
10005a64:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10005a68:	eefc 6bc6 	vcvt.u32.f64	s13, d6
10005a6c:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10005a70:	ee16 3a90 	vmov	r3, s13
10005a74:	ee02 5b4d 	vmls.f64	d5, d2, d13
10005a78:	0fdf      	lsrs	r7, r3, #31
10005a7a:	eefc 6bc5 	vcvt.u32.f64	s13, d5
10005a7e:	ee05 7a10 	vmov	s10, r7
10005a82:	085f      	lsrs	r7, r3, #1
10005a84:	ee06 7a10 	vmov	s12, r7
10005a88:	ee16 2a90 	vmov	r2, s13
10005a8c:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10005a90:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10005a94:	f003 0301 	and.w	r3, r3, #1
10005a98:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10005a9c:	eeb0 2b46 	vmov.f64	d2, d6
10005aa0:	ee06 3a90 	vmov	s13, r3
10005aa4:	ed9f 3b44 	vldr	d3, [pc, #272]	@ 10005bb8 <fndsa_vect_iFFT_fp64_exact+0x418>
10005aa8:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
10005aac:	eeb8 6be6 	vcvt.f64.s32	d6, s13
10005ab0:	eeb0 cb48 	vmov.f64	d12, d8
10005ab4:	ea4f 0c52 	mov.w	ip, r2, lsr #1
10005ab8:	0fd7      	lsrs	r7, r2, #31
10005aba:	ee05 2b03 	vmla.f64	d2, d5, d3
10005abe:	ee06 cb03 	vmla.f64	d12, d6, d3
10005ac2:	ee05 7a10 	vmov	s10, r7
10005ac6:	ee06 ca90 	vmov	s13, ip
10005aca:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
10005ace:	eeb8 6be6 	vcvt.f64.s32	d6, s13
10005ad2:	ee05 6b03 	vmla.f64	d6, d5, d3
10005ad6:	f002 0201 	and.w	r2, r2, #1
10005ada:	ed81 6b00 	vstr	d6, [r1]
10005ade:	ee06 2a90 	vmov	s13, r2
10005ae2:	eeb8 6be6 	vcvt.f64.s32	d6, s13
10005ae6:	ee06 9b03 	vmla.f64	d9, d6, d3
10005aea:	ee24 6b0f 	vmul.f64	d6, d4, d15
10005aee:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10005af2:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005af6:	ee27 5b0f 	vmul.f64	d5, d7, d15
10005afa:	ee06 4b4d 	vmls.f64	d4, d6, d13
10005afe:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10005b02:	eefc 6bc4 	vcvt.u32.f64	s13, d4
10005b06:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10005b0a:	ee16 2a90 	vmov	r2, s13
10005b0e:	ee05 7b4d 	vmls.f64	d7, d5, d13
10005b12:	0fd7      	lsrs	r7, r2, #31
10005b14:	ee06 7a10 	vmov	s12, r7
10005b18:	0857      	lsrs	r7, r2, #1
10005b1a:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10005b1e:	ee07 7a10 	vmov	s14, r7
10005b22:	ee17 3a90 	vmov	r3, s15
10005b26:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10005b2a:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10005b2e:	ee06 7b03 	vmla.f64	d7, d6, d3
10005b32:	f002 0201 	and.w	r2, r2, #1
10005b36:	ed81 9b02 	vstr	d9, [r1, #8]
10005b3a:	ed85 7b00 	vstr	d7, [r5]
10005b3e:	ee07 2a90 	vmov	s15, r2
10005b42:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10005b46:	0fda      	lsrs	r2, r3, #31
10005b48:	ee07 bb03 	vmla.f64	d11, d7, d3
10005b4c:	ee07 2a10 	vmov	s14, r2
10005b50:	085a      	lsrs	r2, r3, #1
10005b52:	ee08 2a10 	vmov	s16, r2
10005b56:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10005b5a:	eeb8 8bc8 	vcvt.f64.s32	d8, s16
10005b5e:	f003 0301 	and.w	r3, r3, #1
10005b62:	ee07 8b03 	vmla.f64	d8, d7, d3
10005b66:	eebc abca 	vcvt.u32.f64	s20, d10
10005b6a:	ee07 3a90 	vmov	s15, r3
10005b6e:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10005b72:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10005b76:	ed9d 1b0a 	vldr	d1, [sp, #40]	@ 0x28
10005b7a:	ee07 ab03 	vmla.f64	d10, d7, d3
10005b7e:	ed85 bb02 	vstr	d11, [r5, #8]
10005b82:	eeb0 3b4c 	vmov.f64	d3, d12
10005b86:	ed8d 1b2c 	vstr	d1, [sp, #176]	@ 0xb0
10005b8a:	ed8d 2b32 	vstr	d2, [sp, #200]	@ 0xc8
10005b8e:	ed8d cb34 	vstr	d12, [sp, #208]	@ 0xd0
10005b92:	ed8d 2b00 	vstr	d2, [sp]
10005b96:	ed8d cb02 	vstr	d12, [sp, #8]
10005b9a:	e013      	b.n	10005bc4 <fndsa_vect_iFFT_fp64_exact+0x424>
10005b9c:	f3af 8000 	nop.w
10005ba0:	00000000 	.word	0x00000000
10005ba4:	41f00000 	.word	0x41f00000
10005ba8:	00000000 	.word	0x00000000
10005bac:	3df00000 	.word	0x3df00000
	...
10005bbc:	41e00000 	.word	0x41e00000
10005bc0:	300039a0 	.word	0x300039a0
10005bc4:	ed8d 8b36 	vstr	d8, [sp, #216]	@ 0xd8
10005bc8:	ed8d ab38 	vstr	d10, [sp, #224]	@ 0xe0
10005bcc:	f7ff fa08 	bl	10004fe0 <fndsa_fp64e_mul>
10005bd0:	eeb0 2b48 	vmov.f64	d2, d8
10005bd4:	eeb0 9b40 	vmov.f64	d9, d0
10005bd8:	eeb0 bb41 	vmov.f64	d11, d1
10005bdc:	ed8d 0b16 	vstr	d0, [sp, #88]	@ 0x58
10005be0:	ed8d 1b18 	vstr	d1, [sp, #96]	@ 0x60
10005be4:	ed9d 0b04 	vldr	d0, [sp, #16]
10005be8:	ed9d 1b06 	vldr	d1, [sp, #24]
10005bec:	eeb0 3b4a 	vmov.f64	d3, d10
10005bf0:	f7ff f9f6 	bl	10004fe0 <fndsa_fp64e_mul>
10005bf4:	ed9d 6b02 	vldr	d6, [sp, #8]
10005bf8:	ee3a 3b06 	vadd.f64	d3, d10, d6
10005bfc:	ee23 6b0f 	vmul.f64	d6, d3, d15
10005c00:	ed9d 2b00 	vldr	d2, [sp]
10005c04:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10005c08:	ee38 2b02 	vadd.f64	d2, d8, d2
10005c0c:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005c10:	ee32 2b06 	vadd.f64	d2, d2, d6
10005c14:	ee06 3b4d 	vmls.f64	d3, d6, d13
10005c18:	ee22 6b0f 	vmul.f64	d6, d2, d15
10005c1c:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10005c20:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005c24:	ed9d 7b0e 	vldr	d7, [sp, #56]	@ 0x38
10005c28:	eeb0 cb40 	vmov.f64	d12, d0
10005c2c:	ee06 2b4d 	vmls.f64	d2, d6, d13
10005c30:	ed8d 0b1a 	vstr	d0, [sp, #104]	@ 0x68
10005c34:	ed9d 0b0c 	vldr	d0, [sp, #48]	@ 0x30
10005c38:	ed8d 1b1c 	vstr	d1, [sp, #112]	@ 0x70
10005c3c:	ed8d 1b00 	vstr	d1, [sp]
10005c40:	eeb0 1b47 	vmov.f64	d1, d7
10005c44:	ed8d 0b26 	vstr	d0, [sp, #152]	@ 0x98
10005c48:	ed8d 7b28 	vstr	d7, [sp, #160]	@ 0xa0
10005c4c:	ed8d 3b24 	vstr	d3, [sp, #144]	@ 0x90
10005c50:	ed8d 2b22 	vstr	d2, [sp, #136]	@ 0x88
10005c54:	f7ff f9c4 	bl	10004fe0 <fndsa_fp64e_mul>
10005c58:	ed9d 7b00 	vldr	d7, [sp]
10005c5c:	ee3b 6b07 	vadd.f64	d6, d11, d7
10005c60:	ee26 5b0f 	vmul.f64	d5, d6, d15
10005c64:	ee3b bb0d 	vadd.f64	d11, d11, d13
10005c68:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10005c6c:	ee3b bb47 	vsub.f64	d11, d11, d7
10005c70:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10005c74:	ee39 7b0c 	vadd.f64	d7, d9, d12
10005c78:	ee37 7b05 	vadd.f64	d7, d7, d5
10005c7c:	ee27 4b0f 	vmul.f64	d4, d7, d15
10005c80:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10005c84:	ee05 6b4d 	vmls.f64	d6, d5, d13
10005c88:	ed8d 1b20 	vstr	d1, [sp, #128]	@ 0x80
10005c8c:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10005c90:	ee31 1b0d 	vadd.f64	d1, d1, d13
10005c94:	ee04 7b4d 	vmls.f64	d7, d4, d13
10005c98:	ee31 6b46 	vsub.f64	d6, d1, d6
10005c9c:	ed8d 0b1e 	vstr	d0, [sp, #120]	@ 0x78
10005ca0:	ee30 0b0d 	vadd.f64	d0, d0, d13
10005ca4:	ee30 0b47 	vsub.f64	d0, d0, d7
10005ca8:	ee26 7b0f 	vmul.f64	d7, d6, d15
10005cac:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005cb0:	ee30 0b4e 	vsub.f64	d0, d0, d14
10005cb4:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005cb8:	ee2b 5b0f 	vmul.f64	d5, d11, d15
10005cbc:	ee30 0b07 	vadd.f64	d0, d0, d7
10005cc0:	ee39 9b0d 	vadd.f64	d9, d9, d13
10005cc4:	ee07 6b4d 	vmls.f64	d6, d7, d13
10005cc8:	ee39 9b4c 	vsub.f64	d9, d9, d12
10005ccc:	ee20 7b0f 	vmul.f64	d7, d0, d15
10005cd0:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10005cd4:	ee39 9b4e 	vsub.f64	d9, d9, d14
10005cd8:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10005cdc:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005ce0:	ee39 9b05 	vadd.f64	d9, d9, d5
10005ce4:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005ce8:	ee07 0b4d 	vmls.f64	d0, d7, d13
10005cec:	ee29 7b0f 	vmul.f64	d7, d9, d15
10005cf0:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005cf4:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005cf8:	ee05 bb4d 	vmls.f64	d11, d5, d13
10005cfc:	ee07 9b4d 	vmls.f64	d9, d7, d13
10005d00:	3110      	adds	r1, #16
10005d02:	3010      	adds	r0, #16
10005d04:	428e      	cmp	r6, r1
10005d06:	f104 0410 	add.w	r4, r4, #16
10005d0a:	ed04 bb02 	vstr	d11, [r4, #-8]
10005d0e:	ed04 9b04 	vstr	d9, [r4, #-16]
10005d12:	f105 0510 	add.w	r5, r5, #16
10005d16:	ed00 0b04 	vstr	d0, [r0, #-16]
10005d1a:	ed00 6b02 	vstr	d6, [r0, #-8]
10005d1e:	f47f adc5 	bne.w	100058ac <fndsa_vect_iFFT_fp64_exact+0x10c>
10005d22:	9f10      	ldr	r7, [sp, #64]	@ 0x40
10005d24:	9b11      	ldr	r3, [sp, #68]	@ 0x44
10005d26:	3710      	adds	r7, #16
10005d28:	449a      	add	sl, r3
10005d2a:	9b12      	ldr	r3, [sp, #72]	@ 0x48
10005d2c:	44c3      	add	fp, r8
10005d2e:	42bb      	cmp	r3, r7
10005d30:	4446      	add	r6, r8
10005d32:	f47f ad63 	bne.w	100057fc <fndsa_vect_iFFT_fp64_exact+0x5c>
10005d36:	9c14      	ldr	r4, [sp, #80]	@ 0x50
10005d38:	46cb      	mov	fp, r9
10005d3a:	3c01      	subs	r4, #1
10005d3c:	f8dd c044 	ldr.w	ip, [sp, #68]	@ 0x44
10005d40:	9915      	ldr	r1, [sp, #84]	@ 0x54
10005d42:	f47f ad3e 	bne.w	100057c2 <fndsa_vect_iFFT_fp64_exact+0x22>
10005d46:	b03b      	add	sp, #236	@ 0xec
10005d48:	ecbd 8b10 	vpop	{d8-d15}
10005d4c:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
