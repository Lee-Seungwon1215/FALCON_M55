
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_kat_exact/validation/build/kat/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10005788 <fndsa_vect_iFFT_fp64_exact>:
10005788:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
1000578c:	ed2d 8b10 	vpush	{d8-d15}
10005790:	1e44      	subs	r4, r0, #1
10005792:	b0bb      	sub	sp, #236	@ 0xec
10005794:	f000 82cb 	beq.w	10005d2e <fndsa_vect_iFFT_fp64_exact+0x5a6>
10005798:	2310      	movs	r3, #16
1000579a:	f04f 0c01 	mov.w	ip, #1
1000579e:	ed9f dbfa 	vldr	d13, [pc, #1000]	@ 10005b88 <fndsa_vect_iFFT_fp64_exact+0x400>
100057a2:	ed9f fbfb 	vldr	d15, [pc, #1004]	@ 10005b90 <fndsa_vect_iFFT_fp64_exact+0x408>
100057a6:	fa03 fb04 	lsl.w	fp, r3, r4
100057aa:	2301      	movs	r3, #1
100057ac:	46e6      	mov	lr, ip
100057ae:	2710      	movs	r7, #16
100057b0:	46d9      	mov	r9, fp
100057b2:	eeb7 eb00 	vmov.f64	d14, #112	@ 0x3f800000  1.0
100057b6:	f04f 0a00 	mov.w	sl, #0
100057ba:	468b      	mov	fp, r1
100057bc:	4afa      	ldr	r2, [pc, #1000]	@ (10005ba8 <fndsa_vect_iFFT_fp64_exact+0x420>)
100057be:	40a3      	lsls	r3, r4
100057c0:	eb03 0353 	add.w	r3, r3, r3, lsr #1
100057c4:	e9cd e413 	strd	lr, r4, [sp, #76]	@ 0x4c
100057c8:	ea4f 0c4c 	mov.w	ip, ip, lsl #1
100057cc:	eb02 1303 	add.w	r3, r2, r3, lsl #4
100057d0:	40a7      	lsls	r7, r4
100057d2:	9312      	str	r3, [sp, #72]	@ 0x48
100057d4:	eb01 160e 	add.w	r6, r1, lr, lsl #4
100057d8:	4417      	add	r7, r2
100057da:	f8cd c044 	str.w	ip, [sp, #68]	@ 0x44
100057de:	9115      	str	r1, [sp, #84]	@ 0x54
100057e0:	ea4f 180c 	mov.w	r8, ip, lsl #4
100057e4:	9b13      	ldr	r3, [sp, #76]	@ 0x4c
100057e6:	4453      	add	r3, sl
100057e8:	459a      	cmp	sl, r3
100057ea:	f080 828f 	bcs.w	10005d0c <fndsa_vect_iFFT_fp64_exact+0x584>
100057ee:	edd7 7a02 	vldr	s15, [r7, #8]
100057f2:	edd7 6a00 	vldr	s13, [r7]
100057f6:	eeb8 5b67 	vcvt.f64.u32	d5, s15
100057fa:	eeb8 3b66 	vcvt.f64.u32	d3, s13
100057fe:	ee3d 5b45 	vsub.f64	d5, d13, d5
10005802:	edd7 6a01 	vldr	s13, [r7, #4]
10005806:	edd7 7a03 	vldr	s15, [r7, #12]
1000580a:	eeb8 2b66 	vcvt.f64.u32	d2, s13
1000580e:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10005812:	ee25 6b0f 	vmul.f64	d6, d5, d15
10005816:	ee3d 7b47 	vsub.f64	d7, d13, d7
1000581a:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000581e:	ee37 7b4e 	vsub.f64	d7, d7, d14
10005822:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005826:	ee37 7b06 	vadd.f64	d7, d7, d6
1000582a:	ee27 4b0f 	vmul.f64	d4, d7, d15
1000582e:	ee06 5b4d 	vmls.f64	d5, d6, d13
10005832:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10005836:	ed8d 5b06 	vstr	d5, [sp, #24]
1000583a:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000583e:	ee35 5b03 	vadd.f64	d5, d5, d3
10005842:	ee04 7b4d 	vmls.f64	d7, d4, d13
10005846:	ee25 6b0f 	vmul.f64	d6, d5, d15
1000584a:	eeb0 4b47 	vmov.f64	d4, d7
1000584e:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10005852:	ed8d 7b04 	vstr	d7, [sp, #16]
10005856:	eeb8 7b46 	vcvt.f64.u32	d7, s12
1000585a:	ee34 6b02 	vadd.f64	d6, d4, d2
1000585e:	ee36 6b07 	vadd.f64	d6, d6, d7
10005862:	ee07 5b4d 	vmls.f64	d5, d7, d13
10005866:	ee26 7b0f 	vmul.f64	d7, d6, d15
1000586a:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000586e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005872:	ee07 6b4d 	vmls.f64	d6, d7, d13
10005876:	ed8d 3b0a 	vstr	d3, [sp, #40]	@ 0x28
1000587a:	ed8d 2b08 	vstr	d2, [sp, #32]
1000587e:	4634      	mov	r4, r6
10005880:	4659      	mov	r1, fp
10005882:	ed8d 5b0e 	vstr	d5, [sp, #56]	@ 0x38
10005886:	ed8d 6b0c 	vstr	d6, [sp, #48]	@ 0x30
1000588a:	eb09 050b 	add.w	r5, r9, fp
1000588e:	eb09 0006 	add.w	r0, r9, r6
10005892:	9710      	str	r7, [sp, #64]	@ 0x40
10005894:	ed91 3b02 	vldr	d3, [r1, #8]
10005898:	ed9d 4b08 	vldr	d4, [sp, #32]
1000589c:	ed94 2b02 	vldr	d2, [r4, #8]
100058a0:	ed95 7b02 	vldr	d7, [r5, #8]
100058a4:	eeb0 0b44 	vmov.f64	d0, d4
100058a8:	ed8d 4b2a 	vstr	d4, [sp, #168]	@ 0xa8
100058ac:	ed9d 6b04 	vldr	d6, [sp, #16]
100058b0:	ee33 4b0d 	vadd.f64	d4, d3, d13
100058b4:	ed91 5b00 	vldr	d5, [r1]
100058b8:	ee33 3b02 	vadd.f64	d3, d3, d2
100058bc:	ee34 4b42 	vsub.f64	d4, d4, d2
100058c0:	ed8d 6b2e 	vstr	d6, [sp, #184]	@ 0xb8
100058c4:	ee37 2b0d 	vadd.f64	d2, d7, d13
100058c8:	ed90 6b02 	vldr	d6, [r0, #8]
100058cc:	ed94 9b00 	vldr	d9, [r4]
100058d0:	ee36 7b07 	vadd.f64	d7, d6, d7
100058d4:	ee32 2b46 	vsub.f64	d2, d2, d6
100058d8:	ed9d 8b06 	vldr	d8, [sp, #24]
100058dc:	ee35 6b0d 	vadd.f64	d6, d5, d13
100058e0:	ed8d 8b30 	vstr	d8, [sp, #192]	@ 0xc0
100058e4:	ee35 5b09 	vadd.f64	d5, d5, d9
100058e8:	ee24 8b0f 	vmul.f64	d8, d4, d15
100058ec:	ee36 6b49 	vsub.f64	d6, d6, d9
100058f0:	ee27 9b0f 	vmul.f64	d9, d7, d15
100058f4:	eebc 8bc8 	vcvt.u32.f64	s16, d8
100058f8:	eebc 9bc9 	vcvt.u32.f64	s18, d9
100058fc:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10005900:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10005904:	ee08 4b4d 	vmls.f64	d4, d8, d13
10005908:	ee09 7b4d 	vmls.f64	d7, d9, d13
1000590c:	ee36 6b4e 	vsub.f64	d6, d6, d14
10005910:	ee34 bb0e 	vadd.f64	d11, d4, d14
10005914:	ee36 6b08 	vadd.f64	d6, d6, d8
10005918:	ee23 4b0f 	vmul.f64	d4, d3, d15
1000591c:	ee37 cb0e 	vadd.f64	d12, d7, d14
10005920:	ee22 8b0f 	vmul.f64	d8, d2, d15
10005924:	ed95 7b00 	vldr	d7, [r5]
10005928:	ed90 ab00 	vldr	d10, [r0]
1000592c:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10005930:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10005934:	ee37 7b0d 	vadd.f64	d7, d7, d13
10005938:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000593c:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10005940:	ee37 7b4a 	vsub.f64	d7, d7, d10
10005944:	ee35 5b04 	vadd.f64	d5, d5, d4
10005948:	ee08 2b4d 	vmls.f64	d2, d8, d13
1000594c:	ee04 3b4d 	vmls.f64	d3, d4, d13
10005950:	ee37 7b4e 	vsub.f64	d7, d7, d14
10005954:	ed95 4b00 	vldr	d4, [r5]
10005958:	ee37 7b08 	vadd.f64	d7, d7, d8
1000595c:	ee34 4b0a 	vadd.f64	d4, d4, d10
10005960:	ee26 8b0f 	vmul.f64	d8, d6, d15
10005964:	ee32 ab0e 	vadd.f64	d10, d2, d14
10005968:	ee25 2b0f 	vmul.f64	d2, d5, d15
1000596c:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10005970:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10005974:	ee34 4b09 	vadd.f64	d4, d4, d9
10005978:	eeb8 8b48 	vcvt.f64.u32	d8, s16
1000597c:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10005980:	ee08 6b4d 	vmls.f64	d6, d8, d13
10005984:	ee02 5b4d 	vmls.f64	d5, d2, d13
10005988:	ee24 8b0f 	vmul.f64	d8, d4, d15
1000598c:	ee27 2b0f 	vmul.f64	d2, d7, d15
10005990:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10005994:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10005998:	eeb8 8b48 	vcvt.f64.u32	d8, s16
1000599c:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100059a0:	ed9f 9b7d 	vldr	d9, [pc, #500]	@ 10005b98 <fndsa_vect_iFFT_fp64_exact+0x410>
100059a4:	ee33 3b0e 	vadd.f64	d3, d3, d14
100059a8:	ee08 4b4d 	vmls.f64	d4, d8, d13
100059ac:	ee02 7b4d 	vmls.f64	d7, d2, d13
100059b0:	ee36 6b09 	vadd.f64	d6, d6, d9
100059b4:	ee23 2b0f 	vmul.f64	d2, d3, d15
100059b8:	ee35 5b09 	vadd.f64	d5, d5, d9
100059bc:	ee34 4b09 	vadd.f64	d4, d4, d9
100059c0:	ee37 7b09 	vadd.f64	d7, d7, d9
100059c4:	ee2b 9b0f 	vmul.f64	d9, d11, d15
100059c8:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100059cc:	eebc 9bc9 	vcvt.u32.f64	s18, d9
100059d0:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100059d4:	eeb8 9b49 	vcvt.f64.u32	d9, s18
100059d8:	ee02 3b4d 	vmls.f64	d3, d2, d13
100059dc:	ee36 6b09 	vadd.f64	d6, d6, d9
100059e0:	ee09 bb4d 	vmls.f64	d11, d9, d13
100059e4:	eeb6 9b00 	vmov.f64	d9, #96	@ 0x3f000000  0.5
100059e8:	ee35 5b02 	vadd.f64	d5, d5, d2
100059ec:	ee2b 8b09 	vmul.f64	d8, d11, d9
100059f0:	ee23 3b09 	vmul.f64	d3, d3, d9
100059f4:	ee2c 2b0f 	vmul.f64	d2, d12, d15
100059f8:	ee2a bb0f 	vmul.f64	d11, d10, d15
100059fc:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10005a00:	eebc bbcb 	vcvt.u32.f64	s22, d11
10005a04:	eefc 3bc2 	vcvt.u32.f64	s7, d2
10005a08:	eeb8 bb4b 	vcvt.f64.u32	d11, s22
10005a0c:	eeb8 9b43 	vcvt.f64.u32	d9, s6
10005a10:	eeb8 3b63 	vcvt.f64.u32	d3, s7
10005a14:	ee0b ab4d 	vmls.f64	d10, d11, d13
10005a18:	ee34 4b03 	vadd.f64	d4, d4, d3
10005a1c:	ee03 cb4d 	vmls.f64	d12, d3, d13
10005a20:	eeb6 3b00 	vmov.f64	d3, #96	@ 0x3f000000  0.5
10005a24:	ee2c 2b03 	vmul.f64	d2, d12, d3
10005a28:	ee2a ab03 	vmul.f64	d10, d10, d3
10005a2c:	ee26 3b0f 	vmul.f64	d3, d6, d15
10005a30:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10005a34:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10005a38:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10005a3c:	ee37 7b0b 	vadd.f64	d7, d7, d11
10005a40:	eeb8 bb42 	vcvt.f64.u32	d11, s4
10005a44:	ee25 2b0f 	vmul.f64	d2, d5, d15
10005a48:	ee03 6b4d 	vmls.f64	d6, d3, d13
10005a4c:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10005a50:	eefc 6bc6 	vcvt.u32.f64	s13, d6
10005a54:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10005a58:	ee16 3a90 	vmov	r3, s13
10005a5c:	ee02 5b4d 	vmls.f64	d5, d2, d13
10005a60:	0fdf      	lsrs	r7, r3, #31
10005a62:	eefc 6bc5 	vcvt.u32.f64	s13, d5
10005a66:	ee05 7a10 	vmov	s10, r7
10005a6a:	085f      	lsrs	r7, r3, #1
10005a6c:	ee06 7a10 	vmov	s12, r7
10005a70:	ee16 2a90 	vmov	r2, s13
10005a74:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10005a78:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10005a7c:	f003 0301 	and.w	r3, r3, #1
10005a80:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10005a84:	eeb0 2b46 	vmov.f64	d2, d6
10005a88:	ee06 3a90 	vmov	s13, r3
10005a8c:	ed9f 3b44 	vldr	d3, [pc, #272]	@ 10005ba0 <fndsa_vect_iFFT_fp64_exact+0x418>
10005a90:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
10005a94:	eeb8 6be6 	vcvt.f64.s32	d6, s13
10005a98:	eeb0 cb48 	vmov.f64	d12, d8
10005a9c:	ea4f 0c52 	mov.w	ip, r2, lsr #1
10005aa0:	0fd7      	lsrs	r7, r2, #31
10005aa2:	ee05 2b03 	vmla.f64	d2, d5, d3
10005aa6:	ee06 cb03 	vmla.f64	d12, d6, d3
10005aaa:	ee05 7a10 	vmov	s10, r7
10005aae:	ee06 ca90 	vmov	s13, ip
10005ab2:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
10005ab6:	eeb8 6be6 	vcvt.f64.s32	d6, s13
10005aba:	ee05 6b03 	vmla.f64	d6, d5, d3
10005abe:	f002 0201 	and.w	r2, r2, #1
10005ac2:	ed81 6b00 	vstr	d6, [r1]
10005ac6:	ee06 2a90 	vmov	s13, r2
10005aca:	eeb8 6be6 	vcvt.f64.s32	d6, s13
10005ace:	ee06 9b03 	vmla.f64	d9, d6, d3
10005ad2:	ee24 6b0f 	vmul.f64	d6, d4, d15
10005ad6:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10005ada:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005ade:	ee27 5b0f 	vmul.f64	d5, d7, d15
10005ae2:	ee06 4b4d 	vmls.f64	d4, d6, d13
10005ae6:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10005aea:	eefc 6bc4 	vcvt.u32.f64	s13, d4
10005aee:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10005af2:	ee16 2a90 	vmov	r2, s13
10005af6:	ee05 7b4d 	vmls.f64	d7, d5, d13
10005afa:	0fd7      	lsrs	r7, r2, #31
10005afc:	ee06 7a10 	vmov	s12, r7
10005b00:	0857      	lsrs	r7, r2, #1
10005b02:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10005b06:	ee07 7a10 	vmov	s14, r7
10005b0a:	ee17 3a90 	vmov	r3, s15
10005b0e:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10005b12:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10005b16:	ee06 7b03 	vmla.f64	d7, d6, d3
10005b1a:	f002 0201 	and.w	r2, r2, #1
10005b1e:	ed81 9b02 	vstr	d9, [r1, #8]
10005b22:	ed85 7b00 	vstr	d7, [r5]
10005b26:	ee07 2a90 	vmov	s15, r2
10005b2a:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10005b2e:	0fda      	lsrs	r2, r3, #31
10005b30:	ee07 bb03 	vmla.f64	d11, d7, d3
10005b34:	ee07 2a10 	vmov	s14, r2
10005b38:	085a      	lsrs	r2, r3, #1
10005b3a:	ee08 2a10 	vmov	s16, r2
10005b3e:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10005b42:	eeb8 8bc8 	vcvt.f64.s32	d8, s16
10005b46:	f003 0301 	and.w	r3, r3, #1
10005b4a:	ee07 8b03 	vmla.f64	d8, d7, d3
10005b4e:	eebc abca 	vcvt.u32.f64	s20, d10
10005b52:	ee07 3a90 	vmov	s15, r3
10005b56:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10005b5a:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10005b5e:	ed9d 1b0a 	vldr	d1, [sp, #40]	@ 0x28
10005b62:	ee07 ab03 	vmla.f64	d10, d7, d3
10005b66:	ed85 bb02 	vstr	d11, [r5, #8]
10005b6a:	eeb0 3b4c 	vmov.f64	d3, d12
10005b6e:	ed8d 1b2c 	vstr	d1, [sp, #176]	@ 0xb0
10005b72:	ed8d 2b32 	vstr	d2, [sp, #200]	@ 0xc8
10005b76:	ed8d cb34 	vstr	d12, [sp, #208]	@ 0xd0
10005b7a:	ed8d 2b00 	vstr	d2, [sp]
10005b7e:	ed8d cb02 	vstr	d12, [sp, #8]
10005b82:	e013      	b.n	10005bac <fndsa_vect_iFFT_fp64_exact+0x424>
10005b84:	f3af 8000 	nop.w
10005b88:	00000000 	.word	0x00000000
10005b8c:	41f00000 	.word	0x41f00000
10005b90:	00000000 	.word	0x00000000
10005b94:	3df00000 	.word	0x3df00000
	...
10005ba4:	41e00000 	.word	0x41e00000
10005ba8:	300039a0 	.word	0x300039a0
10005bac:	ed8d 8b36 	vstr	d8, [sp, #216]	@ 0xd8
10005bb0:	ed8d ab38 	vstr	d10, [sp, #224]	@ 0xe0
10005bb4:	f7ff fa14 	bl	10004fe0 <fndsa_fp64e_mul>
10005bb8:	eeb0 2b48 	vmov.f64	d2, d8
10005bbc:	eeb0 9b40 	vmov.f64	d9, d0
10005bc0:	eeb0 bb41 	vmov.f64	d11, d1
10005bc4:	ed8d 0b16 	vstr	d0, [sp, #88]	@ 0x58
10005bc8:	ed8d 1b18 	vstr	d1, [sp, #96]	@ 0x60
10005bcc:	ed9d 0b04 	vldr	d0, [sp, #16]
10005bd0:	ed9d 1b06 	vldr	d1, [sp, #24]
10005bd4:	eeb0 3b4a 	vmov.f64	d3, d10
10005bd8:	f7ff fa02 	bl	10004fe0 <fndsa_fp64e_mul>
10005bdc:	ed9d 6b02 	vldr	d6, [sp, #8]
10005be0:	ee3a 3b06 	vadd.f64	d3, d10, d6
10005be4:	ee23 6b0f 	vmul.f64	d6, d3, d15
10005be8:	ed9d 2b00 	vldr	d2, [sp]
10005bec:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10005bf0:	ee38 2b02 	vadd.f64	d2, d8, d2
10005bf4:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005bf8:	ee32 2b06 	vadd.f64	d2, d2, d6
10005bfc:	ee06 3b4d 	vmls.f64	d3, d6, d13
10005c00:	ee22 6b0f 	vmul.f64	d6, d2, d15
10005c04:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10005c08:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005c0c:	ed9d 7b0e 	vldr	d7, [sp, #56]	@ 0x38
10005c10:	eeb0 cb40 	vmov.f64	d12, d0
10005c14:	ee06 2b4d 	vmls.f64	d2, d6, d13
10005c18:	ed8d 0b1a 	vstr	d0, [sp, #104]	@ 0x68
10005c1c:	ed9d 0b0c 	vldr	d0, [sp, #48]	@ 0x30
10005c20:	ed8d 1b1c 	vstr	d1, [sp, #112]	@ 0x70
10005c24:	ed8d 1b00 	vstr	d1, [sp]
10005c28:	eeb0 1b47 	vmov.f64	d1, d7
10005c2c:	ed8d 0b26 	vstr	d0, [sp, #152]	@ 0x98
10005c30:	ed8d 7b28 	vstr	d7, [sp, #160]	@ 0xa0
10005c34:	ed8d 3b24 	vstr	d3, [sp, #144]	@ 0x90
10005c38:	ed8d 2b22 	vstr	d2, [sp, #136]	@ 0x88
10005c3c:	f7ff f9d0 	bl	10004fe0 <fndsa_fp64e_mul>
10005c40:	ed9d 7b00 	vldr	d7, [sp]
10005c44:	ee3b 6b07 	vadd.f64	d6, d11, d7
10005c48:	ee26 5b0f 	vmul.f64	d5, d6, d15
10005c4c:	ee3b bb0d 	vadd.f64	d11, d11, d13
10005c50:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10005c54:	ee3b bb47 	vsub.f64	d11, d11, d7
10005c58:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10005c5c:	ee39 7b0c 	vadd.f64	d7, d9, d12
10005c60:	ee37 7b05 	vadd.f64	d7, d7, d5
10005c64:	ee27 4b0f 	vmul.f64	d4, d7, d15
10005c68:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10005c6c:	ee05 6b4d 	vmls.f64	d6, d5, d13
10005c70:	ed8d 1b20 	vstr	d1, [sp, #128]	@ 0x80
10005c74:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10005c78:	ee31 1b0d 	vadd.f64	d1, d1, d13
10005c7c:	ee04 7b4d 	vmls.f64	d7, d4, d13
10005c80:	ee31 6b46 	vsub.f64	d6, d1, d6
10005c84:	ed8d 0b1e 	vstr	d0, [sp, #120]	@ 0x78
10005c88:	ee30 0b0d 	vadd.f64	d0, d0, d13
10005c8c:	ee30 0b47 	vsub.f64	d0, d0, d7
10005c90:	ee26 7b0f 	vmul.f64	d7, d6, d15
10005c94:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005c98:	ee30 0b4e 	vsub.f64	d0, d0, d14
10005c9c:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005ca0:	ee2b 5b0f 	vmul.f64	d5, d11, d15
10005ca4:	ee30 0b07 	vadd.f64	d0, d0, d7
10005ca8:	ee39 9b0d 	vadd.f64	d9, d9, d13
10005cac:	ee07 6b4d 	vmls.f64	d6, d7, d13
10005cb0:	ee39 9b4c 	vsub.f64	d9, d9, d12
10005cb4:	ee20 7b0f 	vmul.f64	d7, d0, d15
10005cb8:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10005cbc:	ee39 9b4e 	vsub.f64	d9, d9, d14
10005cc0:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10005cc4:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005cc8:	ee39 9b05 	vadd.f64	d9, d9, d5
10005ccc:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005cd0:	ee07 0b4d 	vmls.f64	d0, d7, d13
10005cd4:	ee29 7b0f 	vmul.f64	d7, d9, d15
10005cd8:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005cdc:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005ce0:	ee05 bb4d 	vmls.f64	d11, d5, d13
10005ce4:	ee07 9b4d 	vmls.f64	d9, d7, d13
10005ce8:	3110      	adds	r1, #16
10005cea:	3010      	adds	r0, #16
10005cec:	428e      	cmp	r6, r1
10005cee:	f104 0410 	add.w	r4, r4, #16
10005cf2:	ed04 bb02 	vstr	d11, [r4, #-8]
10005cf6:	ed04 9b04 	vstr	d9, [r4, #-16]
10005cfa:	f105 0510 	add.w	r5, r5, #16
10005cfe:	ed00 0b04 	vstr	d0, [r0, #-16]
10005d02:	ed00 6b02 	vstr	d6, [r0, #-8]
10005d06:	f47f adc5 	bne.w	10005894 <fndsa_vect_iFFT_fp64_exact+0x10c>
10005d0a:	9f10      	ldr	r7, [sp, #64]	@ 0x40
10005d0c:	9b11      	ldr	r3, [sp, #68]	@ 0x44
10005d0e:	3710      	adds	r7, #16
10005d10:	449a      	add	sl, r3
10005d12:	9b12      	ldr	r3, [sp, #72]	@ 0x48
10005d14:	44c3      	add	fp, r8
10005d16:	42bb      	cmp	r3, r7
10005d18:	4446      	add	r6, r8
10005d1a:	f47f ad63 	bne.w	100057e4 <fndsa_vect_iFFT_fp64_exact+0x5c>
10005d1e:	9c14      	ldr	r4, [sp, #80]	@ 0x50
10005d20:	46cb      	mov	fp, r9
10005d22:	3c01      	subs	r4, #1
10005d24:	f8dd c044 	ldr.w	ip, [sp, #68]	@ 0x44
10005d28:	9915      	ldr	r1, [sp, #84]	@ 0x54
10005d2a:	f47f ad3e 	bne.w	100057aa <fndsa_vect_iFFT_fp64_exact+0x22>
10005d2e:	b03b      	add	sp, #236	@ 0xec
10005d30:	ecbd 8b10 	vpop	{d8-d15}
10005d34:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
