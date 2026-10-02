10005908 <fndsa_vect_FFT_fp64_exact>:
10005908:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
1000590c:	2301      	movs	r3, #1
1000590e:	ed2d 8b10 	vpush	{d8-d15}
10005912:	f100 3aff 	add.w	sl, r0, #4294967295	@ 0xffffffff
10005916:	2802      	cmp	r0, #2
10005918:	4604      	mov	r4, r0
1000591a:	460e      	mov	r6, r1
1000591c:	b0df      	sub	sp, #380	@ 0x17c
1000591e:	fa03 f80a 	lsl.w	r8, r3, sl
10005922:	f200 857e 	bhi.w	10006422 <fndsa_vect_FFT_fp64_exact+0xb1a>
10005926:	bf08      	it	eq
10005928:	4686      	moveq	lr, r0
1000592a:	f040 8575 	bne.w	10006418 <fndsa_vect_FFT_fp64_exact+0xb10>
1000592e:	2010      	movs	r0, #16
10005930:	9417      	str	r4, [sp, #92]	@ 0x5c
10005932:	ed9f 9bbf 	vldr	d9, [pc, #764]	@ 10005c30 <fndsa_vect_FFT_fp64_exact+0x328>
10005936:	ed9f 8bc0 	vldr	d8, [pc, #768]	@ 10005c38 <fndsa_vect_FFT_fp64_exact+0x330>
1000593a:	2401      	movs	r4, #1
1000593c:	46c4      	mov	ip, r8
1000593e:	f8cd 8058 	str.w	r8, [sp, #88]	@ 0x58
10005942:	f8df 82fc 	ldr.w	r8, [pc, #764]	@ 10005c40 <fndsa_vect_FFT_fp64_exact+0x338>
10005946:	af18      	add	r7, sp, #96	@ 0x60
10005948:	fa00 fb0a 	lsl.w	fp, r0, sl
1000594c:	f8cd a050 	str.w	sl, [sp, #80]	@ 0x50
10005950:	f8cd e048 	str.w	lr, [sp, #72]	@ 0x48
10005954:	2301      	movs	r3, #1
10005956:	f04f 0a10 	mov.w	sl, #16
1000595a:	4662      	mov	r2, ip
1000595c:	40a3      	lsls	r3, r4
1000595e:	eb03 0353 	add.w	r3, r3, r3, lsr #1
10005962:	eb08 1303 	add.w	r3, r8, r3, lsl #4
10005966:	ea4f 0c5c 	mov.w	ip, ip, lsr #1
1000596a:	fa0a fa04 	lsl.w	sl, sl, r4
1000596e:	930a      	str	r3, [sp, #40]	@ 0x28
10005970:	eb06 190c 	add.w	r9, r6, ip, lsl #4
10005974:	4633      	mov	r3, r6
10005976:	eb0a 0008 	add.w	r0, sl, r8
1000597a:	9610      	str	r6, [sp, #64]	@ 0x40
1000597c:	46da      	mov	sl, fp
1000597e:	eeb7 eb00 	vmov.f64	d14, #112	@ 0x3f800000  1.0
10005982:	f04f 0b00 	mov.w	fp, #0
10005986:	4616      	mov	r6, r2
10005988:	f8cd c020 	str.w	ip, [sp, #32]
1000598c:	940c      	str	r4, [sp, #48]	@ 0x30
1000598e:	f8cd 8038 	str.w	r8, [sp, #56]	@ 0x38
10005992:	edd0 7a00 	vldr	s15, [r0]
10005996:	eeb8 1b67 	vcvt.f64.u32	d1, s15
1000599a:	edd0 7a02 	vldr	s15, [r0, #8]
1000599e:	eeb8 4b67 	vcvt.f64.u32	d4, s15
100059a2:	edd0 7a01 	vldr	s15, [r0, #4]
100059a6:	eeb8 2b67 	vcvt.f64.u32	d2, s15
100059aa:	edd0 7a03 	vldr	s15, [r0, #12]
100059ae:	6842      	ldr	r2, [r0, #4]
100059b0:	eeb8 3b67 	vcvt.f64.u32	d3, s15
100059b4:	0fd2      	lsrs	r2, r2, #31
100059b6:	ee06 2a10 	vmov	s12, r2
100059ba:	ee17 2a90 	vmov	r2, s15
100059be:	0fd2      	lsrs	r2, r2, #31
100059c0:	ee07 2a10 	vmov	s14, r2
100059c4:	ee31 5b04 	vadd.f64	d5, d1, d4
100059c8:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100059cc:	ed8d 7b52 	vstr	d7, [sp, #328]	@ 0x148
100059d0:	ee25 7b09 	vmul.f64	d7, d5, d9
100059d4:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100059d8:	ee32 cb03 	vadd.f64	d12, d2, d3
100059dc:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100059e0:	ee3c cb07 	vadd.f64	d12, d12, d7
100059e4:	ee07 5b48 	vmls.f64	d5, d7, d8
100059e8:	ee2c 7b09 	vmul.f64	d7, d12, d9
100059ec:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100059f0:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100059f4:	ee07 cb48 	vmls.f64	d12, d7, d8
100059f8:	eebc 7bcc 	vcvt.u32.f64	s14, d12
100059fc:	9a08      	ldr	r2, [sp, #32]
100059fe:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10005a02:	eb02 010b 	add.w	r1, r2, fp
10005a06:	ee17 2a10 	vmov	r2, s14
10005a0a:	0fd2      	lsrs	r2, r2, #31
10005a0c:	ed8d 6b48 	vstr	d6, [sp, #288]	@ 0x120
10005a10:	ee07 2a10 	vmov	s14, r2
10005a14:	ee25 6b09 	vmul.f64	d6, d5, d9
10005a18:	ee21 0b09 	vmul.f64	d0, d1, d9
10005a1c:	ed8d 1b42 	vstr	d1, [sp, #264]	@ 0x108
10005a20:	ee22 ab09 	vmul.f64	d10, d2, d9
10005a24:	ee24 1b09 	vmul.f64	d1, d4, d9
10005a28:	ee23 bb09 	vmul.f64	d11, d3, d9
10005a2c:	ed8d 6b5a 	vstr	d6, [sp, #360]	@ 0x168
10005a30:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10005a34:	ee2c 6b09 	vmul.f64	d6, d12, d9
10005a38:	458b      	cmp	fp, r1
10005a3a:	ed8d 2b40 	vstr	d2, [sp, #256]	@ 0x100
10005a3e:	ed8d 3b4a 	vstr	d3, [sp, #296]	@ 0x128
10005a42:	ed8d 4b4c 	vstr	d4, [sp, #304]	@ 0x130
10005a46:	ed8d 0b46 	vstr	d0, [sp, #280]	@ 0x118
10005a4a:	ed8d 1b50 	vstr	d1, [sp, #320]	@ 0x140
10005a4e:	ed8d ab44 	vstr	d10, [sp, #272]	@ 0x110
10005a52:	ed8d bb4e 	vstr	d11, [sp, #312]	@ 0x138
10005a56:	ed8d 5b56 	vstr	d5, [sp, #344]	@ 0x158
10005a5a:	ed8d cb54 	vstr	d12, [sp, #336]	@ 0x150
10005a5e:	ed8d 6b58 	vstr	d6, [sp, #352]	@ 0x160
10005a62:	ed8d 7b5c 	vstr	d7, [sp, #368]	@ 0x170
10005a66:	f080 80ae 	bcs.w	10005bc6 <fndsa_vect_FFT_fp64_exact+0x2be>
10005a6a:	4649      	mov	r1, r9
10005a6c:	461c      	mov	r4, r3
10005a6e:	4680      	mov	r8, r0
10005a70:	9604      	str	r6, [sp, #16]
10005a72:	eb0a 0509 	add.w	r5, sl, r9
10005a76:	9306      	str	r3, [sp, #24]
10005a78:	eb0a 0603 	add.w	r6, sl, r3
10005a7c:	ed91 0b00 	vldr	d0, [r1]
10005a80:	ed95 2b00 	vldr	d2, [r5]
10005a84:	ed95 3b02 	vldr	d3, [r5, #8]
10005a88:	ed91 1b02 	vldr	d1, [r1, #8]
10005a8c:	a840      	add	r0, sp, #256	@ 0x100
10005a8e:	f7ff f8cf 	bl	10004c30 <fp64e_cmul_prepared>
10005a92:	ed94 db02 	vldr	d13, [r4, #8]
10005a96:	ed96 ab00 	vldr	d10, [r6]
10005a9a:	ed96 cb02 	vldr	d12, [r6, #8]
10005a9e:	ed94 bb00 	vldr	d11, [r4]
10005aa2:	ee3d 7b01 	vadd.f64	d7, d13, d1
10005aa6:	ee3c 6b03 	vadd.f64	d6, d12, d3
10005aaa:	ee3d 5b08 	vadd.f64	d5, d13, d8
10005aae:	ee3a db02 	vadd.f64	d13, d10, d2
10005ab2:	ee3a ab08 	vadd.f64	d10, d10, d8
10005ab6:	ee3b fb00 	vadd.f64	d15, d11, d0
10005aba:	ee3a ab42 	vsub.f64	d10, d10, d2
10005abe:	ee26 4b09 	vmul.f64	d4, d6, d9
10005ac2:	ee3c cb08 	vadd.f64	d12, d12, d8
10005ac6:	ee3b bb08 	vadd.f64	d11, d11, d8
10005aca:	ed87 1b02 	vstr	d1, [r7, #8]
10005ace:	ee35 1b41 	vsub.f64	d1, d5, d1
10005ad2:	ee27 5b09 	vmul.f64	d5, d7, d9
10005ad6:	ee3b bb40 	vsub.f64	d11, d11, d0
10005ada:	ed87 0b00 	vstr	d0, [r7]
10005ade:	ed87 2b04 	vstr	d2, [r7, #16]
10005ae2:	eebc 0bc4 	vcvt.u32.f64	s0, d4
10005ae6:	ee3c 2b43 	vsub.f64	d2, d12, d3
10005aea:	ed87 3b06 	vstr	d3, [r7, #24]
10005aee:	ee3a 3b4e 	vsub.f64	d3, d10, d14
10005af2:	eebc abc5 	vcvt.u32.f64	s20, d5
10005af6:	ee22 cb09 	vmul.f64	d12, d2, d9
10005afa:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10005afe:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10005b02:	ed8d 3b02 	vstr	d3, [sp, #8]
10005b06:	ee21 3b09 	vmul.f64	d3, d1, d9
10005b0a:	ee3b 5b4e 	vsub.f64	d5, d11, d14
10005b0e:	ee0a 7b48 	vmls.f64	d7, d10, d8
10005b12:	ee00 6b48 	vmls.f64	d6, d0, d8
10005b16:	eebc cbcc 	vcvt.u32.f64	s24, d12
10005b1a:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10005b1e:	ed8d 5b00 	vstr	d5, [sp]
10005b22:	eeb8 4b4c 	vcvt.f64.u32	d4, s24
10005b26:	ee3d bb00 	vadd.f64	d11, d13, d0
10005b2a:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10005b2e:	eeb0 cb47 	vmov.f64	d12, d7
10005b32:	eeb0 db46 	vmov.f64	d13, d6
10005b36:	ed9d 7b00 	vldr	d7, [sp]
10005b3a:	ed9d 6b02 	vldr	d6, [sp, #8]
10005b3e:	ee3f 5b0a 	vadd.f64	d5, d15, d10
10005b42:	ee37 7b03 	vadd.f64	d7, d7, d3
10005b46:	ee36 6b04 	vadd.f64	d6, d6, d4
10005b4a:	ee25 0b09 	vmul.f64	d0, d5, d9
10005b4e:	ee2b ab09 	vmul.f64	d10, d11, d9
10005b52:	ee03 1b48 	vmls.f64	d1, d3, d8
10005b56:	ee04 2b48 	vmls.f64	d2, d4, d8
10005b5a:	ee27 3b09 	vmul.f64	d3, d7, d9
10005b5e:	ee26 4b09 	vmul.f64	d4, d6, d9
10005b62:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10005b66:	eebc abca 	vcvt.u32.f64	s20, d10
10005b6a:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10005b6e:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10005b72:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10005b76:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10005b7a:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10005b7e:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10005b82:	ee00 5b48 	vmls.f64	d5, d0, d8
10005b86:	ee0a bb48 	vmls.f64	d11, d10, d8
10005b8a:	ee03 7b48 	vmls.f64	d7, d3, d8
10005b8e:	ee04 6b48 	vmls.f64	d6, d4, d8
10005b92:	3410      	adds	r4, #16
10005b94:	3610      	adds	r6, #16
10005b96:	3110      	adds	r1, #16
10005b98:	3510      	adds	r5, #16
10005b9a:	45a1      	cmp	r9, r4
10005b9c:	ed04 cb02 	vstr	d12, [r4, #-8]
10005ba0:	ed04 5b04 	vstr	d5, [r4, #-16]
10005ba4:	ed06 bb04 	vstr	d11, [r6, #-16]
10005ba8:	ed06 db02 	vstr	d13, [r6, #-8]
10005bac:	ed01 1b02 	vstr	d1, [r1, #-8]
10005bb0:	ed01 7b04 	vstr	d7, [r1, #-16]
10005bb4:	ed05 6b04 	vstr	d6, [r5, #-16]
10005bb8:	ed05 2b02 	vstr	d2, [r5, #-8]
10005bbc:	f47f af5e 	bne.w	10005a7c <fndsa_vect_FFT_fp64_exact+0x174>
10005bc0:	4640      	mov	r0, r8
10005bc2:	9e04      	ldr	r6, [sp, #16]
10005bc4:	9b06      	ldr	r3, [sp, #24]
10005bc6:	9a0a      	ldr	r2, [sp, #40]	@ 0x28
10005bc8:	3010      	adds	r0, #16
10005bca:	4282      	cmp	r2, r0
10005bcc:	44b3      	add	fp, r6
10005bce:	eb03 1306 	add.w	r3, r3, r6, lsl #4
10005bd2:	eb09 1906 	add.w	r9, r9, r6, lsl #4
10005bd6:	f47f aedc 	bne.w	10005992 <fndsa_vect_FFT_fp64_exact+0x8a>
10005bda:	9c0c      	ldr	r4, [sp, #48]	@ 0x30
10005bdc:	9b12      	ldr	r3, [sp, #72]	@ 0x48
10005bde:	3401      	adds	r4, #1
10005be0:	429c      	cmp	r4, r3
10005be2:	46d3      	mov	fp, sl
10005be4:	f8dd c020 	ldr.w	ip, [sp, #32]
10005be8:	f8dd 8038 	ldr.w	r8, [sp, #56]	@ 0x38
10005bec:	9e10      	ldr	r6, [sp, #64]	@ 0x40
10005bee:	f4ff aeb1 	bcc.w	10005954 <fndsa_vect_FFT_fp64_exact+0x4c>
10005bf2:	4645      	mov	r5, r8
10005bf4:	e9dd 8416 	ldrd	r8, r4, [sp, #88]	@ 0x58
10005bf8:	2c02      	cmp	r4, #2
10005bfa:	f8dd a050 	ldr.w	sl, [sp, #80]	@ 0x50
10005bfe:	f000 840b 	beq.w	10006418 <fndsa_vect_FFT_fp64_exact+0xb10>
10005c02:	4631      	mov	r1, r6
10005c04:	2410      	movs	r4, #16
10005c06:	ed9f eb0a 	vldr	d14, [pc, #40]	@ 10005c30 <fndsa_vect_FFT_fp64_exact+0x328>
10005c0a:	ed9f fb0b 	vldr	d15, [pc, #44]	@ 10005c38 <fndsa_vect_FFT_fp64_exact+0x330>
10005c0e:	f108 33ff 	add.w	r3, r8, #4294967295	@ 0xffffffff
10005c12:	fa04 f40a 	lsl.w	r4, r4, sl
10005c16:	ea4f 0658 	mov.w	r6, r8, lsr #1
10005c1a:	089b      	lsrs	r3, r3, #2
10005c1c:	f101 0740 	add.w	r7, r1, #64	@ 0x40
10005c20:	eb05 1606 	add.w	r6, r5, r6, lsl #4
10005c24:	eb07 1783 	add.w	r7, r7, r3, lsl #6
10005c28:	4425      	add	r5, r4
10005c2a:	440c      	add	r4, r1
10005c2c:	e00a      	b.n	10005c44 <fndsa_vect_FFT_fp64_exact+0x33c>
10005c2e:	bf00      	nop
10005c30:	00000000 	.word	0x00000000
10005c34:	3df00000 	.word	0x3df00000
10005c38:	00000000 	.word	0x00000000
10005c3c:	41f00000 	.word	0x41f00000
10005c40:	300039a0 	.word	0x300039a0
10005c44:	ed91 7b02 	vldr	d7, [r1, #8]
10005c48:	ed91 3b06 	vldr	d3, [r1, #24]
10005c4c:	ed8d 7b02 	vstr	d7, [sp, #8]
10005c50:	edd6 7a00 	vldr	s15, [r6]
10005c54:	ed94 2b04 	vldr	d2, [r4, #16]
10005c58:	ed91 5b04 	vldr	d5, [r1, #16]
10005c5c:	ed91 4b00 	vldr	d4, [r1]
10005c60:	ed8d 3b00 	vstr	d3, [sp]
10005c64:	eeb8 3b67 	vcvt.f64.u32	d3, s15
10005c68:	edd6 7a02 	vldr	s15, [r6, #8]
10005c6c:	6873      	ldr	r3, [r6, #4]
10005c6e:	ed8d 2b06 	vstr	d2, [sp, #24]
10005c72:	0fdb      	lsrs	r3, r3, #31
10005c74:	ee02 3a10 	vmov	s4, r3
10005c78:	68f3      	ldr	r3, [r6, #12]
10005c7a:	ed94 6b02 	vldr	d6, [r4, #8]
10005c7e:	0fdb      	lsrs	r3, r3, #31
10005c80:	ed8d 5b0a 	vstr	d5, [sp, #40]	@ 0x28
10005c84:	ed8d 4b0c 	vstr	d4, [sp, #48]	@ 0x30
10005c88:	ee05 3a10 	vmov	s10, r3
10005c8c:	eeb8 4b67 	vcvt.f64.u32	d4, s15
10005c90:	edd6 7a01 	vldr	s15, [r6, #4]
10005c94:	ed8d 6b12 	vstr	d6, [sp, #72]	@ 0x48
10005c98:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
10005c9c:	eeb8 6b67 	vcvt.f64.u32	d6, s15
10005ca0:	edd6 7a03 	vldr	s15, [r6, #12]
10005ca4:	ed94 bb00 	vldr	d11, [r4]
10005ca8:	ed94 1b06 	vldr	d1, [r4, #24]
10005cac:	ed94 0b0c 	vldr	d0, [r4, #48]	@ 0x30
10005cb0:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10005cb4:	eeb8 2bc2 	vcvt.f64.s32	d2, s4
10005cb8:	ed8d 3b42 	vstr	d3, [sp, #264]	@ 0x108
10005cbc:	ed8d 4b4c 	vstr	d4, [sp, #304]	@ 0x130
10005cc0:	ed8d 5b52 	vstr	d5, [sp, #328]	@ 0x148
10005cc4:	ee33 5b04 	vadd.f64	d5, d3, d4
10005cc8:	ee23 3b0e 	vmul.f64	d3, d3, d14
10005ccc:	ee24 4b0e 	vmul.f64	d4, d4, d14
10005cd0:	ed91 cb0c 	vldr	d12, [r1, #48]	@ 0x30
10005cd4:	ed91 db0e 	vldr	d13, [r1, #56]	@ 0x38
10005cd8:	ed8d bb08 	vstr	d11, [sp, #32]
10005cdc:	ed8d 1b04 	vstr	d1, [sp, #16]
10005ce0:	ed8d 0b10 	vstr	d0, [sp, #64]	@ 0x40
10005ce4:	ed8d 2b48 	vstr	d2, [sp, #288]	@ 0x120
10005ce8:	ed8d 6b40 	vstr	d6, [sp, #256]	@ 0x100
10005cec:	ed8d 7b4a 	vstr	d7, [sp, #296]	@ 0x128
10005cf0:	ed8d 3b46 	vstr	d3, [sp, #280]	@ 0x118
10005cf4:	ed8d 4b50 	vstr	d4, [sp, #320]	@ 0x140
10005cf8:	ee25 4b0e 	vmul.f64	d4, d5, d14
10005cfc:	eefc 3bc4 	vcvt.u32.f64	s7, d4
10005d00:	ee36 4b07 	vadd.f64	d4, d6, d7
10005d04:	ee27 7b0e 	vmul.f64	d7, d7, d14
10005d08:	ed8d 7b4e 	vstr	d7, [sp, #312]	@ 0x138
10005d0c:	eeb8 7b63 	vcvt.f64.u32	d7, s7
10005d10:	ee34 4b07 	vadd.f64	d4, d4, d7
10005d14:	ee07 5b4f 	vmls.f64	d5, d7, d15
10005d18:	ee24 7b0e 	vmul.f64	d7, d4, d14
10005d1c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005d20:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005d24:	ee07 4b4f 	vmls.f64	d4, d7, d15
10005d28:	eebc 7bc4 	vcvt.u32.f64	s14, d4
10005d2c:	ee17 3a10 	vmov	r3, s14
10005d30:	0fdb      	lsrs	r3, r3, #31
10005d32:	ee07 3a10 	vmov	s14, r3
10005d36:	ed94 8b0e 	vldr	d8, [r4, #56]	@ 0x38
10005d3a:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10005d3e:	ee26 6b0e 	vmul.f64	d6, d6, d14
10005d42:	ed8d 5b56 	vstr	d5, [sp, #344]	@ 0x158
10005d46:	ed8d 4b54 	vstr	d4, [sp, #336]	@ 0x150
10005d4a:	ee25 5b0e 	vmul.f64	d5, d5, d14
10005d4e:	ee24 4b0e 	vmul.f64	d4, d4, d14
10005d52:	ed91 0b08 	vldr	d0, [r1, #32]
10005d56:	ed91 1b0a 	vldr	d1, [r1, #40]	@ 0x28
10005d5a:	ed94 2b08 	vldr	d2, [r4, #32]
10005d5e:	ed94 3b0a 	vldr	d3, [r4, #40]	@ 0x28
10005d62:	a840      	add	r0, sp, #256	@ 0x100
10005d64:	ed8d 4b58 	vstr	d4, [sp, #352]	@ 0x160
10005d68:	ed8d 7b5c 	vstr	d7, [sp, #368]	@ 0x170
10005d6c:	ed8d 6b44 	vstr	d6, [sp, #272]	@ 0x110
10005d70:	ed8d 5b5a 	vstr	d5, [sp, #360]	@ 0x168
10005d74:	ed8d 8b0e 	vstr	d8, [sp, #56]	@ 0x38
10005d78:	f7fe ff5a 	bl	10004c30 <fp64e_cmul_prepared>
10005d7c:	eeb0 9b40 	vmov.f64	d9, d0
10005d80:	eeb0 8b42 	vmov.f64	d8, d2
10005d84:	eeb0 bb41 	vmov.f64	d11, d1
10005d88:	eeb0 ab43 	vmov.f64	d10, d3
10005d8c:	ed9d 2b10 	vldr	d2, [sp, #64]	@ 0x40
10005d90:	eeb0 0b4c 	vmov.f64	d0, d12
10005d94:	eeb0 1b4d 	vmov.f64	d1, d13
10005d98:	ed9d 3b0e 	vldr	d3, [sp, #56]	@ 0x38
10005d9c:	ed8d 9b20 	vstr	d9, [sp, #128]	@ 0x80
10005da0:	ed8d bb22 	vstr	d11, [sp, #136]	@ 0x88
10005da4:	ed8d 8b24 	vstr	d8, [sp, #144]	@ 0x90
10005da8:	ed8d ab26 	vstr	d10, [sp, #152]	@ 0x98
10005dac:	f7fe ff40 	bl	10004c30 <fp64e_cmul_prepared>
10005db0:	edd5 7a00 	vldr	s15, [r5]
10005db4:	eeb8 5b67 	vcvt.f64.u32	d5, s15
10005db8:	edd5 7a02 	vldr	s15, [r5, #8]
10005dbc:	eeb8 6b67 	vcvt.f64.u32	d6, s15
10005dc0:	edd5 7a01 	vldr	s15, [r5, #4]
10005dc4:	686b      	ldr	r3, [r5, #4]
10005dc6:	eeb8 cb67 	vcvt.f64.u32	d12, s15
10005dca:	0fdb      	lsrs	r3, r3, #31
10005dcc:	ee04 3a10 	vmov	s8, r3
10005dd0:	68eb      	ldr	r3, [r5, #12]
10005dd2:	edd5 7a03 	vldr	s15, [r5, #12]
10005dd6:	0fdb      	lsrs	r3, r3, #31
10005dd8:	ee07 3a10 	vmov	s14, r3
10005ddc:	eeb8 db67 	vcvt.f64.u32	d13, s15
10005de0:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10005de4:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
10005de8:	ed8d 6b4c 	vstr	d6, [sp, #304]	@ 0x130
10005dec:	ed8d 7b52 	vstr	d7, [sp, #328]	@ 0x148
10005df0:	ee35 7b06 	vadd.f64	d7, d5, d6
10005df4:	ee26 6b0e 	vmul.f64	d6, d6, d14
10005df8:	ed8d 4b48 	vstr	d4, [sp, #288]	@ 0x120
10005dfc:	ed8d 5b42 	vstr	d5, [sp, #264]	@ 0x108
10005e00:	ed9d 4b02 	vldr	d4, [sp, #8]
10005e04:	ee25 5b0e 	vmul.f64	d5, d5, d14
10005e08:	ed8d 6b50 	vstr	d6, [sp, #320]	@ 0x140
10005e0c:	ee27 6b0e 	vmul.f64	d6, d7, d14
10005e10:	ed8d 5b46 	vstr	d5, [sp, #280]	@ 0x118
10005e14:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10005e18:	ee34 5b0f 	vadd.f64	d5, d4, d15
10005e1c:	ee34 4b0b 	vadd.f64	d4, d4, d11
10005e20:	ed8d 4b10 	vstr	d4, [sp, #64]	@ 0x40
10005e24:	eeb8 4b46 	vcvt.f64.u32	d4, s12
10005e28:	ee04 7b4f 	vmls.f64	d7, d4, d15
10005e2c:	ed9d 6b12 	vldr	d6, [sp, #72]	@ 0x48
10005e30:	ed8d 7b56 	vstr	d7, [sp, #344]	@ 0x158
10005e34:	ee27 7b0e 	vmul.f64	d7, d7, d14
10005e38:	ed8d 7b5a 	vstr	d7, [sp, #360]	@ 0x168
10005e3c:	ee36 7b0f 	vadd.f64	d7, d6, d15
10005e40:	ee3a 6b06 	vadd.f64	d6, d10, d6
10005e44:	ed8d 0b28 	vstr	d0, [sp, #160]	@ 0xa0
10005e48:	ed8d 1b2a 	vstr	d1, [sp, #168]	@ 0xa8
10005e4c:	ed8d 2b2c 	vstr	d2, [sp, #176]	@ 0xb0
10005e50:	ed8d 3b2e 	vstr	d3, [sp, #184]	@ 0xb8
10005e54:	ed8d cb40 	vstr	d12, [sp, #256]	@ 0x100
10005e58:	ed8d db4a 	vstr	d13, [sp, #296]	@ 0x128
10005e5c:	ed8d 6b0e 	vstr	d6, [sp, #56]	@ 0x38
10005e60:	ed9d 6b00 	vldr	d6, [sp]
10005e64:	ee37 ab4a 	vsub.f64	d10, d7, d10
10005e68:	ee36 7b0f 	vadd.f64	d7, d6, d15
10005e6c:	ee36 6b01 	vadd.f64	d6, d6, d1
10005e70:	ee37 7b41 	vsub.f64	d7, d7, d1
10005e74:	ed9d 1b04 	vldr	d1, [sp, #16]
10005e78:	ee35 bb4b 	vsub.f64	d11, d5, d11
10005e7c:	ee31 5b0f 	vadd.f64	d5, d1, d15
10005e80:	ed8d 7b02 	vstr	d7, [sp, #8]
10005e84:	ee31 7b03 	vadd.f64	d7, d1, d3
10005e88:	ee35 3b43 	vsub.f64	d3, d5, d3
10005e8c:	ee3c 5b0d 	vadd.f64	d5, d12, d13
10005e90:	ee35 1b04 	vadd.f64	d1, d5, d4
10005e94:	ee26 5b0e 	vmul.f64	d5, d6, d14
10005e98:	ee2c cb0e 	vmul.f64	d12, d12, d14
10005e9c:	eefc 4bc5 	vcvt.u32.f64	s9, d5
10005ea0:	ee27 5b0e 	vmul.f64	d5, d7, d14
10005ea4:	ed8d cb44 	vstr	d12, [sp, #272]	@ 0x110
10005ea8:	ee2d db0e 	vmul.f64	d13, d13, d14
10005eac:	eeb8 cb64 	vcvt.f64.u32	d12, s9
10005eb0:	eefc 5bc5 	vcvt.u32.f64	s11, d5
10005eb4:	ed9d 4b0e 	vldr	d4, [sp, #56]	@ 0x38
10005eb8:	ed8d 1b14 	vstr	d1, [sp, #80]	@ 0x50
10005ebc:	ed8d db4e 	vstr	d13, [sp, #312]	@ 0x138
10005ec0:	eeb0 1b46 	vmov.f64	d1, d6
10005ec4:	eeb8 db65 	vcvt.f64.u32	d13, s11
10005ec8:	ee24 6b0e 	vmul.f64	d6, d4, d14
10005ecc:	ed9d 5b10 	vldr	d5, [sp, #64]	@ 0x40
10005ed0:	ed8d 3b00 	vstr	d3, [sp]
10005ed4:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10005ed8:	eeb0 3b47 	vmov.f64	d3, d7
10005edc:	ee25 7b0e 	vmul.f64	d7, d5, d14
10005ee0:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005ee4:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005ee8:	ee06 4b4f 	vmls.f64	d4, d6, d15
10005eec:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005ef0:	ed8d 6b04 	vstr	d6, [sp, #16]
10005ef4:	ee07 5b4f 	vmls.f64	d5, d7, d15
10005ef8:	ee2b 6b0e 	vmul.f64	d6, d11, d14
10005efc:	ed8d 4b0e 	vstr	d4, [sp, #56]	@ 0x38
10005f00:	ed9d 4b0c 	vldr	d4, [sp, #48]	@ 0x30
10005f04:	ed8d 5b12 	vstr	d5, [sp, #72]	@ 0x48
10005f08:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10005f0c:	ee34 5b0f 	vadd.f64	d5, d4, d15
10005f10:	ee34 4b09 	vadd.f64	d4, d4, d9
10005f14:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005f18:	ee34 4b07 	vadd.f64	d4, d4, d7
10005f1c:	ee35 5b49 	vsub.f64	d5, d5, d9
10005f20:	eeb7 7b00 	vmov.f64	d7, #112	@ 0x3f800000  1.0
10005f24:	eeb0 9b4b 	vmov.f64	d9, d11
10005f28:	ee35 5b47 	vsub.f64	d5, d5, d7
10005f2c:	ed9d bb08 	vldr	d11, [sp, #32]
10005f30:	ee06 9b4f 	vmls.f64	d9, d6, d15
10005f34:	ee2a 7b0e 	vmul.f64	d7, d10, d14
10005f38:	ed8d 9b0c 	vstr	d9, [sp, #48]	@ 0x30
10005f3c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10005f40:	ee35 9b06 	vadd.f64	d9, d5, d6
10005f44:	ee3b 6b0f 	vadd.f64	d6, d11, d15
10005f48:	ee3b 5b08 	vadd.f64	d5, d11, d8
10005f4c:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10005f50:	eeb7 bb00 	vmov.f64	d11, #112	@ 0x3f800000  1.0
10005f54:	ee36 6b48 	vsub.f64	d6, d6, d8
10005f58:	ee07 ab4f 	vmls.f64	d10, d7, d15
10005f5c:	ee36 6b4b 	vsub.f64	d6, d6, d11
10005f60:	ed9d 8b04 	vldr	d8, [sp, #16]
10005f64:	ed8d ab08 	vstr	d10, [sp, #32]
10005f68:	ee36 ab07 	vadd.f64	d10, d6, d7
10005f6c:	ed9d 6b02 	vldr	d6, [sp, #8]
10005f70:	ee35 8b08 	vadd.f64	d8, d5, d8
10005f74:	ee26 5b0e 	vmul.f64	d5, d6, d14
10005f78:	ed9d 6b0a 	vldr	d6, [sp, #40]	@ 0x28
10005f7c:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10005f80:	ee36 7b0f 	vadd.f64	d7, d6, d15
10005f84:	ee36 6b00 	vadd.f64	d6, d6, d0
10005f88:	ee37 7b40 	vsub.f64	d7, d7, d0
10005f8c:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10005f90:	ee36 0b0c 	vadd.f64	d0, d6, d12
10005f94:	ed9d 6b02 	vldr	d6, [sp, #8]
10005f98:	ee05 6b4f 	vmls.f64	d6, d5, d15
10005f9c:	ee0c 1b4f 	vmls.f64	d1, d12, d15
10005fa0:	ee37 7b4b 	vsub.f64	d7, d7, d11
10005fa4:	eeb0 cb4b 	vmov.f64	d12, d11
10005fa8:	ed8d 6b02 	vstr	d6, [sp, #8]
10005fac:	ed9d bb00 	vldr	d11, [sp]
10005fb0:	ed9d 6b06 	vldr	d6, [sp, #24]
10005fb4:	ee37 5b05 	vadd.f64	d5, d7, d5
10005fb8:	ee2b bb0e 	vmul.f64	d11, d11, d14
10005fbc:	ee36 7b0f 	vadd.f64	d7, d6, d15
10005fc0:	eebc bbcb 	vcvt.u32.f64	s22, d11
10005fc4:	ee36 6b02 	vadd.f64	d6, d6, d2
10005fc8:	ee37 7b42 	vsub.f64	d7, d7, d2
10005fcc:	ee0d 3b4f 	vmls.f64	d3, d13, d15
10005fd0:	ee36 2b0d 	vadd.f64	d2, d6, d13
10005fd4:	ee37 7b4c 	vsub.f64	d7, d7, d12
10005fd8:	ed9d db00 	vldr	d13, [sp]
10005fdc:	eeb8 bb4b 	vcvt.f64.u32	d11, s22
10005fe0:	ee0b db4f 	vmls.f64	d13, d11, d15
10005fe4:	ee37 bb0b 	vadd.f64	d11, d7, d11
10005fe8:	ed9d 7b14 	vldr	d7, [sp, #80]	@ 0x50
10005fec:	ee27 6b0e 	vmul.f64	d6, d7, d14
10005ff0:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10005ff4:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10005ff8:	ee06 7b4f 	vmls.f64	d7, d6, d15
10005ffc:	eefc 6bc7 	vcvt.u32.f64	s13, d7
10006000:	ee16 3a90 	vmov	r3, s13
10006004:	ed8d 7b54 	vstr	d7, [sp, #336]	@ 0x150
10006008:	ee27 7b0e 	vmul.f64	d7, d7, d14
1000600c:	0fdb      	lsrs	r3, r3, #31
1000600e:	ed8d 7b58 	vstr	d7, [sp, #352]	@ 0x160
10006012:	ee07 3a10 	vmov	s14, r3
10006016:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
1000601a:	ed8d 7b5c 	vstr	d7, [sp, #368]	@ 0x170
1000601e:	ee24 7b0e 	vmul.f64	d7, d4, d14
10006022:	ee22 6b0e 	vmul.f64	d6, d2, d14
10006026:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000602a:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000602e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006032:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006036:	ee07 4b4f 	vmls.f64	d4, d7, d15
1000603a:	ee29 7b0e 	vmul.f64	d7, d9, d14
1000603e:	ee06 2b4f 	vmls.f64	d2, d6, d15
10006042:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006046:	ee28 6b0e 	vmul.f64	d6, d8, d14
1000604a:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000604e:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006052:	ee07 9b4f 	vmls.f64	d9, d7, d15
10006056:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000605a:	ee25 7b0e 	vmul.f64	d7, d5, d14
1000605e:	ee06 8b4f 	vmls.f64	d8, d6, d15
10006062:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006066:	ee2a 6b0e 	vmul.f64	d6, d10, d14
1000606a:	ed8d 8b0a 	vstr	d8, [sp, #40]	@ 0x28
1000606e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006072:	eeb0 8b45 	vmov.f64	d8, d5
10006076:	ee20 cb0e 	vmul.f64	d12, d0, d14
1000607a:	ee07 8b4f 	vmls.f64	d8, d7, d15
1000607e:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006082:	ee2b 7b0e 	vmul.f64	d7, d11, d14
10006086:	eebc cbcc 	vcvt.u32.f64	s24, d12
1000608a:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000608e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006092:	eeb8 cb4c 	vcvt.f64.u32	d12, s24
10006096:	ee06 ab4f 	vmls.f64	d10, d6, d15
1000609a:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000609e:	ee0c 0b4f 	vmls.f64	d0, d12, d15
100060a2:	ee07 bb4f 	vmls.f64	d11, d7, d15
100060a6:	ed8d 4b10 	vstr	d4, [sp, #64]	@ 0x40
100060aa:	ed8d db00 	vstr	d13, [sp]
100060ae:	ed8d 9b06 	vstr	d9, [sp, #24]
100060b2:	ed8d ab04 	vstr	d10, [sp, #16]
100060b6:	f7fe fdbb 	bl	10004c30 <fp64e_cmul_prepared>
100060ba:	edd5 7a04 	vldr	s15, [r5, #16]
100060be:	696b      	ldr	r3, [r5, #20]
100060c0:	eeb0 db42 	vmov.f64	d13, d2
100060c4:	0fdb      	lsrs	r3, r3, #31
100060c6:	eeb0 2b4b 	vmov.f64	d2, d11
100060ca:	ee0b 3a10 	vmov	s22, r3
100060ce:	69eb      	ldr	r3, [r5, #28]
100060d0:	eeb0 cb40 	vmov.f64	d12, d0
100060d4:	0fdb      	lsrs	r3, r3, #31
100060d6:	eeb0 0b48 	vmov.f64	d0, d8
100060da:	ee05 3a10 	vmov	s10, r3
100060de:	eeb8 8b67 	vcvt.f64.u32	d8, s15
100060e2:	edd5 7a06 	vldr	s15, [r5, #24]
100060e6:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
100060ea:	eeb8 4b67 	vcvt.f64.u32	d4, s15
100060ee:	ed8d 8b42 	vstr	d8, [sp, #264]	@ 0x108
100060f2:	edd5 7a05 	vldr	s15, [r5, #20]
100060f6:	ed8d 5b52 	vstr	d5, [sp, #328]	@ 0x148
100060fa:	ee38 5b04 	vadd.f64	d5, d8, d4
100060fe:	ee28 8b0e 	vmul.f64	d8, d8, d14
10006102:	eeb8 6b67 	vcvt.f64.u32	d6, s15
10006106:	ed8d 8b46 	vstr	d8, [sp, #280]	@ 0x118
1000610a:	edd5 7a07 	vldr	s15, [r5, #28]
1000610e:	ee25 8b0e 	vmul.f64	d8, d5, d14
10006112:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10006116:	ed8d 4b4c 	vstr	d4, [sp, #304]	@ 0x130
1000611a:	eebc 8bc8 	vcvt.u32.f64	s16, d8
1000611e:	ee24 4b0e 	vmul.f64	d4, d4, d14
10006122:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10006126:	ed8d 4b50 	vstr	d4, [sp, #320]	@ 0x140
1000612a:	ee36 4b07 	vadd.f64	d4, d6, d7
1000612e:	ed8d 7b4a 	vstr	d7, [sp, #296]	@ 0x128
10006132:	ee34 4b08 	vadd.f64	d4, d4, d8
10006136:	ee27 7b0e 	vmul.f64	d7, d7, d14
1000613a:	ed8d 7b4e 	vstr	d7, [sp, #312]	@ 0x138
1000613e:	ee24 7b0e 	vmul.f64	d7, d4, d14
10006142:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006146:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000614a:	ee07 4b4f 	vmls.f64	d4, d7, d15
1000614e:	eebc 7bc4 	vcvt.u32.f64	s14, d4
10006152:	ee17 3a10 	vmov	r3, s14
10006156:	0fdb      	lsrs	r3, r3, #31
10006158:	ee08 5b4f 	vmls.f64	d5, d8, d15
1000615c:	ee07 3a10 	vmov	s14, r3
10006160:	eeb0 ab41 	vmov.f64	d10, d1
10006164:	eeb0 9b43 	vmov.f64	d9, d3
10006168:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
1000616c:	eeb8 bbcb 	vcvt.f64.s32	d11, s22
10006170:	ed8d 6b40 	vstr	d6, [sp, #256]	@ 0x100
10006174:	ed8d 5b56 	vstr	d5, [sp, #344]	@ 0x158
10006178:	ee26 6b0e 	vmul.f64	d6, d6, d14
1000617c:	ee25 5b0e 	vmul.f64	d5, d5, d14
10006180:	ed8d 4b54 	vstr	d4, [sp, #336]	@ 0x150
10006184:	ee24 4b0e 	vmul.f64	d4, d4, d14
10006188:	ed9d 1b02 	vldr	d1, [sp, #8]
1000618c:	ed9d 3b00 	vldr	d3, [sp]
10006190:	ed8d cb30 	vstr	d12, [sp, #192]	@ 0xc0
10006194:	ed8d ab32 	vstr	d10, [sp, #200]	@ 0xc8
10006198:	ed8d db34 	vstr	d13, [sp, #208]	@ 0xd0
1000619c:	ed8d 9b36 	vstr	d9, [sp, #216]	@ 0xd8
100061a0:	ed8d bb48 	vstr	d11, [sp, #288]	@ 0x120
100061a4:	ed8d 6b44 	vstr	d6, [sp, #272]	@ 0x110
100061a8:	ed8d 5b5a 	vstr	d5, [sp, #360]	@ 0x168
100061ac:	ed8d 4b58 	vstr	d4, [sp, #352]	@ 0x160
100061b0:	ed8d 7b5c 	vstr	d7, [sp, #368]	@ 0x170
100061b4:	f7fe fd3c 	bl	10004c30 <fp64e_cmul_prepared>
100061b8:	ed9d 5b12 	vldr	d5, [sp, #72]	@ 0x48
100061bc:	ed9d 7b0e 	vldr	d7, [sp, #56]	@ 0x38
100061c0:	ee35 6b0a 	vadd.f64	d6, d5, d10
100061c4:	ee35 4b0f 	vadd.f64	d4, d5, d15
100061c8:	ed9d 5b0c 	vldr	d5, [sp, #48]	@ 0x30
100061cc:	ee37 8b0f 	vadd.f64	d8, d7, d15
100061d0:	ee35 bb0f 	vadd.f64	d11, d5, d15
100061d4:	ee37 7b09 	vadd.f64	d7, d7, d9
100061d8:	ee38 8b49 	vsub.f64	d8, d8, d9
100061dc:	ee3b bb41 	vsub.f64	d11, d11, d1
100061e0:	ee35 9b01 	vadd.f64	d9, d5, d1
100061e4:	ed8d 1b3a 	vstr	d1, [sp, #232]	@ 0xe8
100061e8:	ed9d 1b08 	vldr	d1, [sp, #32]
100061ec:	ee31 5b0f 	vadd.f64	d5, d1, d15
100061f0:	ee35 5b43 	vsub.f64	d5, d5, d3
100061f4:	ee34 4b4a 	vsub.f64	d4, d4, d10
100061f8:	ed8d 5b00 	vstr	d5, [sp]
100061fc:	ee31 ab03 	vadd.f64	d10, d1, d3
10006200:	ee26 5b0e 	vmul.f64	d5, d6, d14
10006204:	ed8d 3b3e 	vstr	d3, [sp, #248]	@ 0xf8
10006208:	ee27 3b0e 	vmul.f64	d3, d7, d14
1000620c:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10006210:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006214:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10006218:	eeb8 1b43 	vcvt.f64.u32	d1, s6
1000621c:	ee05 6b4f 	vmls.f64	d6, d5, d15
10006220:	ee01 7b4f 	vmls.f64	d7, d1, d15
10006224:	ed9d 3b10 	vldr	d3, [sp, #64]	@ 0x40
10006228:	ed8d 7b02 	vstr	d7, [sp, #8]
1000622c:	ed81 6b02 	vstr	d6, [r1, #8]
10006230:	ee24 7b0e 	vmul.f64	d7, d4, d14
10006234:	ee33 6b0f 	vadd.f64	d6, d3, d15
10006238:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000623c:	ee33 3b0c 	vadd.f64	d3, d3, d12
10006240:	ee36 6b4c 	vsub.f64	d6, d6, d12
10006244:	eeb7 cb00 	vmov.f64	d12, #112	@ 0x3f800000  1.0
10006248:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000624c:	ee36 6b4c 	vsub.f64	d6, d6, d12
10006250:	eeb0 cb44 	vmov.f64	d12, d4
10006254:	ee07 cb4f 	vmls.f64	d12, d7, d15
10006258:	ed9d 4b0a 	vldr	d4, [sp, #40]	@ 0x28
1000625c:	ed8d cb08 	vstr	d12, [sp, #32]
10006260:	ee36 cb07 	vadd.f64	d12, d6, d7
10006264:	ee28 7b0e 	vmul.f64	d7, d8, d14
10006268:	ee33 3b05 	vadd.f64	d3, d3, d5
1000626c:	ee34 6b0f 	vadd.f64	d6, d4, d15
10006270:	ee34 5b0d 	vadd.f64	d5, d4, d13
10006274:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10006278:	ee35 1b01 	vadd.f64	d1, d5, d1
1000627c:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10006280:	ee36 6b4d 	vsub.f64	d6, d6, d13
10006284:	eeb7 5b00 	vmov.f64	d5, #112	@ 0x3f800000  1.0
10006288:	ee07 8b4f 	vmls.f64	d8, d7, d15
1000628c:	ee36 6b45 	vsub.f64	d6, d6, d5
10006290:	eeb0 db48 	vmov.f64	d13, d8
10006294:	ee2b 5b0e 	vmul.f64	d5, d11, d14
10006298:	ee36 8b07 	vadd.f64	d8, d6, d7
1000629c:	ee29 7b0e 	vmul.f64	d7, d9, d14
100062a0:	ed9d 4b06 	vldr	d4, [sp, #24]
100062a4:	eefc 5bc5 	vcvt.u32.f64	s11, d5
100062a8:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100062ac:	edcd 5a0a 	vstr	s11, [sp, #40]	@ 0x28
100062b0:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100062b4:	ee34 5b0f 	vadd.f64	d5, d4, d15
100062b8:	ee34 4b00 	vadd.f64	d4, d4, d0
100062bc:	ee07 9b4f 	vmls.f64	d9, d7, d15
100062c0:	ed8d 0b38 	vstr	d0, [sp, #224]	@ 0xe0
100062c4:	ee35 5b40 	vsub.f64	d5, d5, d0
100062c8:	ee34 0b07 	vadd.f64	d0, d4, d7
100062cc:	eddd 7a0a 	vldr	s15, [sp, #40]	@ 0x28
100062d0:	eeb7 4b00 	vmov.f64	d4, #112	@ 0x3f800000  1.0
100062d4:	eeb8 7b67 	vcvt.f64.u32	d7, s15
100062d8:	ee35 5b44 	vsub.f64	d5, d5, d4
100062dc:	ee07 bb4f 	vmls.f64	d11, d7, d15
100062e0:	ee35 5b07 	vadd.f64	d5, d5, d7
100062e4:	ed9d 7b00 	vldr	d7, [sp]
100062e8:	ee2a 6b0e 	vmul.f64	d6, d10, d14
100062ec:	ee27 7b0e 	vmul.f64	d7, d7, d14
100062f0:	ed9d 4b04 	vldr	d4, [sp, #16]
100062f4:	eefc 7bc7 	vcvt.u32.f64	s15, d7
100062f8:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100062fc:	edcd 7a06 	vstr	s15, [sp, #24]
10006300:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006304:	ee34 7b0f 	vadd.f64	d7, d4, d15
10006308:	ee34 4b02 	vadd.f64	d4, d4, d2
1000630c:	ee06 ab4f 	vmls.f64	d10, d6, d15
10006310:	ee34 4b06 	vadd.f64	d4, d4, d6
10006314:	ed8d 2b3c 	vstr	d2, [sp, #240]	@ 0xf0
10006318:	ee37 7b42 	vsub.f64	d7, d7, d2
1000631c:	eddd 6a06 	vldr	s13, [sp, #24]
10006320:	eeb7 2b00 	vmov.f64	d2, #112	@ 0x3f800000  1.0
10006324:	eeb8 6b66 	vcvt.f64.u32	d6, s13
10006328:	ee37 7b42 	vsub.f64	d7, d7, d2
1000632c:	ed9d 2b00 	vldr	d2, [sp]
10006330:	ee06 2b4f 	vmls.f64	d2, d6, d15
10006334:	ed8d 2b00 	vstr	d2, [sp]
10006338:	ee23 2b0e 	vmul.f64	d2, d3, d14
1000633c:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10006340:	ee37 7b06 	vadd.f64	d7, d7, d6
10006344:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10006348:	ee21 6b0e 	vmul.f64	d6, d1, d14
1000634c:	ee02 3b4f 	vmls.f64	d3, d2, d15
10006350:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006354:	ed81 3b00 	vstr	d3, [r1]
10006358:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000635c:	ed9d 3b02 	vldr	d3, [sp, #8]
10006360:	ee06 1b4f 	vmls.f64	d1, d6, d15
10006364:	ed84 3b02 	vstr	d3, [r4, #8]
10006368:	ed9d 6b08 	vldr	d6, [sp, #32]
1000636c:	ee2c 3b0e 	vmul.f64	d3, d12, d14
10006370:	ed84 1b00 	vstr	d1, [r4]
10006374:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006378:	ed81 6b06 	vstr	d6, [r1, #24]
1000637c:	ee28 6b0e 	vmul.f64	d6, d8, d14
10006380:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10006384:	eefc 6bc6 	vcvt.u32.f64	s13, d6
10006388:	ee03 cb4f 	vmls.f64	d12, d3, d15
1000638c:	eeb8 3b66 	vcvt.f64.u32	d3, s13
10006390:	ee20 6b0e 	vmul.f64	d6, d0, d14
10006394:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006398:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000639c:	ee24 1b0e 	vmul.f64	d1, d4, d14
100063a0:	ee03 8b4f 	vmls.f64	d8, d3, d15
100063a4:	ee06 0b4f 	vmls.f64	d0, d6, d15
100063a8:	ee25 3b0e 	vmul.f64	d3, d5, d14
100063ac:	ee27 6b0e 	vmul.f64	d6, d7, d14
100063b0:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100063b4:	eebc 1bc1 	vcvt.u32.f64	s2, d1
100063b8:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100063bc:	eeb8 1b41 	vcvt.f64.u32	d1, s2
100063c0:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100063c4:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100063c8:	ee01 4b4f 	vmls.f64	d4, d1, d15
100063cc:	ee03 5b4f 	vmls.f64	d5, d3, d15
100063d0:	ed9d 2b00 	vldr	d2, [sp]
100063d4:	ee06 7b4f 	vmls.f64	d7, d6, d15
100063d8:	3140      	adds	r1, #64	@ 0x40
100063da:	428f      	cmp	r7, r1
100063dc:	f104 0440 	add.w	r4, r4, #64	@ 0x40
100063e0:	ed01 cb0c 	vstr	d12, [r1, #-48]	@ 0xffffffd0
100063e4:	f106 0610 	add.w	r6, r6, #16
100063e8:	ed04 db0a 	vstr	d13, [r4, #-40]	@ 0xffffffd8
100063ec:	ed04 8b0c 	vstr	d8, [r4, #-48]	@ 0xffffffd0
100063f0:	f105 0520 	add.w	r5, r5, #32
100063f4:	ed01 9b06 	vstr	d9, [r1, #-24]	@ 0xffffffe8
100063f8:	ed01 0b08 	vstr	d0, [r1, #-32]	@ 0xffffffe0
100063fc:	ed04 ab06 	vstr	d10, [r4, #-24]	@ 0xffffffe8
10006400:	ed04 4b08 	vstr	d4, [r4, #-32]	@ 0xffffffe0
10006404:	ed01 5b04 	vstr	d5, [r1, #-16]
10006408:	ed01 bb02 	vstr	d11, [r1, #-8]
1000640c:	ed04 2b02 	vstr	d2, [r4, #-8]
10006410:	ed04 7b04 	vstr	d7, [r4, #-16]
10006414:	f47f ac16 	bne.w	10005c44 <fndsa_vect_FFT_fp64_exact+0x33c>
10006418:	b05f      	add	sp, #380	@ 0x17c
1000641a:	ecbd 8b10 	vpop	{d8-d15}
1000641e:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10006422:	2803      	cmp	r0, #3
10006424:	f1a0 0e02 	sub.w	lr, r0, #2
10006428:	f47f aa81 	bne.w	1000592e <fndsa_vect_FFT_fp64_exact+0x26>
1000642c:	4d01      	ldr	r5, [pc, #4]	@ (10006434 <fndsa_vect_FFT_fp64_exact+0xb2c>)
1000642e:	f7ff bbe8 	b.w	10005c02 <fndsa_vect_FFT_fp64_exact+0x2fa>
10006432:	bf00      	nop
10006434:	300039a0 	.word	0x300039a0

