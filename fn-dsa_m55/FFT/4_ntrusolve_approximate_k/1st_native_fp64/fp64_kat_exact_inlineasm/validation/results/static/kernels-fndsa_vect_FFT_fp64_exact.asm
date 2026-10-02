
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_kat_exact_inlineasm/validation/build/kernels/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10000870 <fndsa_vect_FFT_fp64_exact.constprop.0>:
10000870:	2801      	cmp	r0, #1
10000872:	f240 81ea 	bls.w	10000c4a <fndsa_vect_FFT_fp64_exact.constprop.0+0x3da>
10000876:	2101      	movs	r1, #1
10000878:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
1000087c:	2310      	movs	r3, #16
1000087e:	ed2d 8b10 	vpush	{d8-d15}
10000882:	460c      	mov	r4, r1
10000884:	ed9f bbf2 	vldr	d11, [pc, #968]	@ 10000c50 <fndsa_vect_FFT_fp64_exact.constprop.0+0x3e0>
10000888:	ed9f fbf3 	vldr	d15, [pc, #972]	@ 10000c58 <fndsa_vect_FFT_fp64_exact.constprop.0+0x3e8>
1000088c:	1e42      	subs	r2, r0, #1
1000088e:	4093      	lsls	r3, r2
10000890:	fa01 f502 	lsl.w	r5, r1, r2
10000894:	4af2      	ldr	r2, [pc, #968]	@ (10000c60 <fndsa_vect_FFT_fp64_exact.constprop.0+0x3f0>)
10000896:	b0c9      	sub	sp, #292	@ 0x124
10000898:	eb03 0e02 	add.w	lr, r3, r2
1000089c:	901b      	str	r0, [sp, #108]	@ 0x6c
1000089e:	2701      	movs	r7, #1
100008a0:	2110      	movs	r1, #16
100008a2:	462e      	mov	r6, r5
100008a4:	2300      	movs	r3, #0
100008a6:	4aee      	ldr	r2, [pc, #952]	@ (10000c60 <fndsa_vect_FFT_fp64_exact.constprop.0+0x3f0>)
100008a8:	40fd      	lsrs	r5, r7
100008aa:	eb02 1005 	add.w	r0, r2, r5, lsl #4
100008ae:	f100 0208 	add.w	r2, r0, #8
100008b2:	40a7      	lsls	r7, r4
100008b4:	9218      	str	r2, [sp, #96]	@ 0x60
100008b6:	087a      	lsrs	r2, r7, #1
100008b8:	9217      	str	r2, [sp, #92]	@ 0x5c
100008ba:	4aea      	ldr	r2, [pc, #936]	@ (10000c64 <fndsa_vect_FFT_fp64_exact.constprop.0+0x3f4>)
100008bc:	40a1      	lsls	r1, r4
100008be:	4411      	add	r1, r2
100008c0:	4618      	mov	r0, r3
100008c2:	4632      	mov	r2, r6
100008c4:	46aa      	mov	sl, r5
100008c6:	e9cd 5419 	strd	r5, r4, [sp, #100]	@ 0x64
100008ca:	4553      	cmp	r3, sl
100008cc:	f080 81a8 	bcs.w	10000c20 <fndsa_vect_FFT_fp64_exact.constprop.0+0x3b0>
100008d0:	edd1 7a01 	vldr	s15, [r1, #4]
100008d4:	edd1 5a03 	vldr	s11, [r1, #12]
100008d8:	eeb8 7b67 	vcvt.f64.u32	d7, s15
100008dc:	eeb8 5b65 	vcvt.f64.u32	d5, s11
100008e0:	edd1 6a00 	vldr	s13, [r1]
100008e4:	edd1 4a02 	vldr	s9, [r1, #8]
100008e8:	eeb8 6b66 	vcvt.f64.u32	d6, s13
100008ec:	eeb8 4b64 	vcvt.f64.u32	d4, s9
100008f0:	ed8d 7b06 	vstr	d7, [sp, #24]
100008f4:	ee37 7b05 	vadd.f64	d7, d7, d5
100008f8:	ed8d 7b0e 	vstr	d7, [sp, #56]	@ 0x38
100008fc:	ee36 7b04 	vadd.f64	d7, d6, d4
10000900:	ed8d 6b08 	vstr	d6, [sp, #32]
10000904:	ed8d 5b0a 	vstr	d5, [sp, #40]	@ 0x28
10000908:	ed8d 4b0c 	vstr	d4, [sp, #48]	@ 0x30
1000090c:	eeb7 db00 	vmov.f64	d13, #112	@ 0x3f800000  1.0
10000910:	4698      	mov	r8, r3
10000912:	ed8d 7b10 	vstr	d7, [sp, #64]	@ 0x40
10000916:	460f      	mov	r7, r1
10000918:	4cd1      	ldr	r4, [pc, #836]	@ (10000c60 <fndsa_vect_FFT_fp64_exact.constprop.0+0x3f0>)
1000091a:	9e18      	ldr	r6, [sp, #96]	@ 0x60
1000091c:	e9cd 0313 	strd	r0, r3, [sp, #76]	@ 0x4c
10000920:	e9cd e215 	strd	lr, r2, [sp, #84]	@ 0x54
10000924:	f10e 0908 	add.w	r9, lr, #8
10000928:	eb04 1503 	add.w	r5, r4, r3, lsl #4
1000092c:	eb09 190a 	add.w	r9, r9, sl, lsl #4
10000930:	eb0e 1403 	add.w	r4, lr, r3, lsl #4
10000934:	eb06 1603 	add.w	r6, r6, r3, lsl #4
10000938:	f10d 0bc0 	add.w	fp, sp, #192	@ 0xc0
1000093c:	ed94 7b00 	vldr	d7, [r4]
10000940:	f1a6 0308 	sub.w	r3, r6, #8
10000944:	cb0f      	ldmia	r3, {r0, r1, r2, r3}
10000946:	e88b 000f 	stmia.w	fp, {r0, r1, r2, r3}
1000094a:	ed95 1b00 	vldr	d1, [r5]
1000094e:	ed9d 6b08 	vldr	d6, [sp, #32]
10000952:	ed9d eb30 	vldr	d14, [sp, #192]	@ 0xc0
10000956:	ed8d 7b00 	vstr	d7, [sp]
1000095a:	ed9d 7b32 	vldr	d7, [sp, #200]	@ 0xc8
1000095e:	ed9d 0b06 	vldr	d0, [sp, #24]
10000962:	f1a9 0c08 	sub.w	ip, r9, #8
10000966:	e89c 000f 	ldmia.w	ip, {r0, r1, r2, r3}
1000096a:	f10d 0cd0 	add.w	ip, sp, #208	@ 0xd0
1000096e:	e88c 000f 	stmia.w	ip, {r0, r1, r2, r3}
10000972:	eeb0 3b47 	vmov.f64	d3, d7
10000976:	ed8d 1b02 	vstr	d1, [sp, #8]
1000097a:	eeb0 2b4e 	vmov.f64	d2, d14
1000097e:	eeb0 1b46 	vmov.f64	d1, d6
10000982:	ed95 cb02 	vldr	d12, [r5, #8]
10000986:	ed94 8b02 	vldr	d8, [r4, #8]
1000098a:	ed9d 9b34 	vldr	d9, [sp, #208]	@ 0xd0
1000098e:	ed8d 7b42 	vstr	d7, [sp, #264]	@ 0x108
10000992:	ed8d 7b04 	vstr	d7, [sp, #16]
10000996:	ed8d 0b38 	vstr	d0, [sp, #224]	@ 0xe0
1000099a:	ed8d 6b3a 	vstr	d6, [sp, #232]	@ 0xe8
1000099e:	ed8d eb40 	vstr	d14, [sp, #256]	@ 0x100
100009a2:	ed9d ab36 	vldr	d10, [sp, #216]	@ 0xd8
100009a6:	f005 f95f 	bl	10005c68 <fndsa_fp64e_mul>
100009aa:	ed9d 6b0c 	vldr	d6, [sp, #48]	@ 0x30
100009ae:	ed8d 0b1c 	vstr	d0, [sp, #112]	@ 0x70
100009b2:	ed9d 0b0a 	vldr	d0, [sp, #40]	@ 0x28
100009b6:	eeb0 2b49 	vmov.f64	d2, d9
100009ba:	ed8d 1b1e 	vstr	d1, [sp, #120]	@ 0x78
100009be:	eeb0 3b4a 	vmov.f64	d3, d10
100009c2:	eeb0 1b46 	vmov.f64	d1, d6
100009c6:	ed8d 0b3c 	vstr	d0, [sp, #240]	@ 0xf0
100009ca:	ed8d 6b3e 	vstr	d6, [sp, #248]	@ 0xf8
100009ce:	ed8d 9b44 	vstr	d9, [sp, #272]	@ 0x110
100009d2:	ed8d ab46 	vstr	d10, [sp, #280]	@ 0x118
100009d6:	f005 f947 	bl	10005c68 <fndsa_fp64e_mul>
100009da:	ed9d 7b04 	vldr	d7, [sp, #16]
100009de:	ed9d 5b10 	vldr	d5, [sp, #64]	@ 0x40
100009e2:	ee37 3b0a 	vadd.f64	d3, d7, d10
100009e6:	ee25 7b0b 	vmul.f64	d7, d5, d11
100009ea:	ee23 6b0b 	vmul.f64	d6, d3, d11
100009ee:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100009f2:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100009f6:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100009fa:	ed9d 4b0e 	vldr	d4, [sp, #56]	@ 0x38
100009fe:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10000a02:	ee3e 2b09 	vadd.f64	d2, d14, d9
10000a06:	ed8d 0b20 	vstr	d0, [sp, #128]	@ 0x80
10000a0a:	ee32 2b06 	vadd.f64	d2, d2, d6
10000a0e:	ee34 0b07 	vadd.f64	d0, d4, d7
10000a12:	ee07 5b4f 	vmls.f64	d5, d7, d15
10000a16:	ee06 3b4f 	vmls.f64	d3, d6, d15
10000a1a:	ee20 7b0b 	vmul.f64	d7, d0, d11
10000a1e:	ee22 6b0b 	vmul.f64	d6, d2, d11
10000a22:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10000a26:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10000a2a:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10000a2e:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10000a32:	ee07 0b4f 	vmls.f64	d0, d7, d15
10000a36:	ee06 2b4f 	vmls.f64	d2, d6, d15
10000a3a:	ed8d 1b22 	vstr	d1, [sp, #136]	@ 0x88
10000a3e:	eeb0 1b45 	vmov.f64	d1, d5
10000a42:	ed8d 5b2e 	vstr	d5, [sp, #184]	@ 0xb8
10000a46:	ed8d 3b2a 	vstr	d3, [sp, #168]	@ 0xa8
10000a4a:	ed8d 0b2c 	vstr	d0, [sp, #176]	@ 0xb0
10000a4e:	ed8d 2b28 	vstr	d2, [sp, #160]	@ 0xa0
10000a52:	f005 f909 	bl	10005c68 <fndsa_fp64e_mul>
10000a56:	ed9d 4b22 	vldr	d4, [sp, #136]	@ 0x88
10000a5a:	ed9d 5b1e 	vldr	d5, [sp, #120]	@ 0x78
10000a5e:	ee35 6b04 	vadd.f64	d6, d5, d4
10000a62:	ee26 3b0b 	vmul.f64	d3, d6, d11
10000a66:	ed9d 2b20 	vldr	d2, [sp, #128]	@ 0x80
10000a6a:	ed9d 7b1c 	vldr	d7, [sp, #112]	@ 0x70
10000a6e:	ee35 5b0f 	vadd.f64	d5, d5, d15
10000a72:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10000a76:	ee35 5b44 	vsub.f64	d5, d5, d4
10000a7a:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10000a7e:	ee37 4b02 	vadd.f64	d4, d7, d2
10000a82:	ee37 7b0f 	vadd.f64	d7, d7, d15
10000a86:	ee34 4b03 	vadd.f64	d4, d4, d3
10000a8a:	ee37 7b42 	vsub.f64	d7, d7, d2
10000a8e:	ee24 2b0b 	vmul.f64	d2, d4, d11
10000a92:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10000a96:	ee03 6b4f 	vmls.f64	d6, d3, d15
10000a9a:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10000a9e:	ed8d 1b26 	vstr	d1, [sp, #152]	@ 0x98
10000aa2:	ee31 1b0f 	vadd.f64	d1, d1, d15
10000aa6:	ee25 3b0b 	vmul.f64	d3, d5, d11
10000aaa:	ee31 6b46 	vsub.f64	d6, d1, d6
10000aae:	ee02 4b4f 	vmls.f64	d4, d2, d15
10000ab2:	ed8d 0b24 	vstr	d0, [sp, #144]	@ 0x90
10000ab6:	ee30 0b0f 	vadd.f64	d0, d0, d15
10000aba:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10000abe:	ee30 0b44 	vsub.f64	d0, d0, d4
10000ac2:	ee26 4b0b 	vmul.f64	d4, d6, d11
10000ac6:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10000aca:	ee37 7b4d 	vsub.f64	d7, d7, d13
10000ace:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10000ad2:	ee37 7b03 	vadd.f64	d7, d7, d3
10000ad6:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10000ada:	ee30 0b4d 	vsub.f64	d0, d0, d13
10000ade:	ee03 5b4f 	vmls.f64	d5, d3, d15
10000ae2:	ee30 0b04 	vadd.f64	d0, d0, d4
10000ae6:	ee27 3b0b 	vmul.f64	d3, d7, d11
10000aea:	ee04 6b4f 	vmls.f64	d6, d4, d15
10000aee:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10000af2:	ee20 4b0b 	vmul.f64	d4, d0, d11
10000af6:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10000afa:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10000afe:	ee03 7b4f 	vmls.f64	d7, d3, d15
10000b02:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10000b06:	ee3c 3b0f 	vadd.f64	d3, d12, d15
10000b0a:	ee35 cb0c 	vadd.f64	d12, d5, d12
10000b0e:	ee04 0b4f 	vmls.f64	d0, d4, d15
10000b12:	ee33 5b45 	vsub.f64	d5, d3, d5
10000b16:	ee38 4b0f 	vadd.f64	d4, d8, d15
10000b1a:	ee2c 3b0b 	vmul.f64	d3, d12, d11
10000b1e:	ed9d 1b02 	vldr	d1, [sp, #8]
10000b22:	ee36 8b08 	vadd.f64	d8, d6, d8
10000b26:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10000b2a:	ee34 6b46 	vsub.f64	d6, d4, d6
10000b2e:	ee31 4b0f 	vadd.f64	d4, d1, d15
10000b32:	ee28 2b0b 	vmul.f64	d2, d8, d11
10000b36:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10000b3a:	ee25 9b0b 	vmul.f64	d9, d5, d11
10000b3e:	ee31 1b07 	vadd.f64	d1, d1, d7
10000b42:	ee34 4b47 	vsub.f64	d4, d4, d7
10000b46:	ed9d 7b00 	vldr	d7, [sp]
10000b4a:	ee31 1b03 	vadd.f64	d1, d1, d3
10000b4e:	ee03 cb4f 	vmls.f64	d12, d3, d15
10000b52:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10000b56:	ee37 3b0f 	vadd.f64	d3, d7, d15
10000b5a:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10000b5e:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10000b62:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10000b66:	ee37 7b00 	vadd.f64	d7, d7, d0
10000b6a:	ee33 3b40 	vsub.f64	d3, d3, d0
10000b6e:	ee34 4b4d 	vsub.f64	d4, d4, d13
10000b72:	ee21 0b0b 	vmul.f64	d0, d1, d11
10000b76:	ee34 4b09 	vadd.f64	d4, d4, d9
10000b7a:	ee09 5b4f 	vmls.f64	d5, d9, d15
10000b7e:	ee37 7b02 	vadd.f64	d7, d7, d2
10000b82:	ee26 9b0b 	vmul.f64	d9, d6, d11
10000b86:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10000b8a:	ee02 8b4f 	vmls.f64	d8, d2, d15
10000b8e:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10000b92:	ee27 2b0b 	vmul.f64	d2, d7, d11
10000b96:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10000b9a:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10000b9e:	ee00 1b4f 	vmls.f64	d1, d0, d15
10000ba2:	ee33 3b4d 	vsub.f64	d3, d3, d13
10000ba6:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10000baa:	ed85 1b00 	vstr	d1, [r5]
10000bae:	ee33 3b09 	vadd.f64	d3, d3, d9
10000bb2:	ee24 1b0b 	vmul.f64	d1, d4, d11
10000bb6:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10000bba:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10000bbe:	ee02 7b4f 	vmls.f64	d7, d2, d15
10000bc2:	ee23 2b0b 	vmul.f64	d2, d3, d11
10000bc6:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10000bca:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10000bce:	4633      	mov	r3, r6
10000bd0:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10000bd4:	ee01 4b4f 	vmls.f64	d4, d1, d15
10000bd8:	3410      	adds	r4, #16
10000bda:	ed85 cb02 	vstr	d12, [r5, #8]
10000bde:	ee09 6b4f 	vmls.f64	d6, d9, d15
10000be2:	ed04 8b02 	vstr	d8, [r4, #-8]
10000be6:	ed04 7b04 	vstr	d7, [r4, #-16]
10000bea:	ee02 3b4f 	vmls.f64	d3, d2, d15
10000bee:	ed06 4b02 	vstr	d4, [r6, #-8]
10000bf2:	ed83 5b00 	vstr	d5, [r3]
10000bf6:	464b      	mov	r3, r9
10000bf8:	f108 0801 	add.w	r8, r8, #1
10000bfc:	45d0      	cmp	r8, sl
10000bfe:	ed09 3b02 	vstr	d3, [r9, #-8]
10000c02:	f105 0510 	add.w	r5, r5, #16
10000c06:	ed83 6b00 	vstr	d6, [r3]
10000c0a:	f106 0610 	add.w	r6, r6, #16
10000c0e:	f109 0910 	add.w	r9, r9, #16
10000c12:	f47f ae93 	bne.w	1000093c <fndsa_vect_FFT_fp64_exact.constprop.0+0xcc>
10000c16:	e9dd 0313 	ldrd	r0, r3, [sp, #76]	@ 0x4c
10000c1a:	e9dd e215 	ldrd	lr, r2, [sp, #84]	@ 0x54
10000c1e:	4639      	mov	r1, r7
10000c20:	9c17      	ldr	r4, [sp, #92]	@ 0x5c
10000c22:	3001      	adds	r0, #1
10000c24:	42a0      	cmp	r0, r4
10000c26:	4413      	add	r3, r2
10000c28:	4492      	add	sl, r2
10000c2a:	f101 0110 	add.w	r1, r1, #16
10000c2e:	f47f ae4c 	bne.w	100008ca <fndsa_vect_FFT_fp64_exact.constprop.0+0x5a>
10000c32:	e9dd 5419 	ldrd	r5, r4, [sp, #100]	@ 0x64
10000c36:	9b1b      	ldr	r3, [sp, #108]	@ 0x6c
10000c38:	3401      	adds	r4, #1
10000c3a:	42a3      	cmp	r3, r4
10000c3c:	f47f ae2f 	bne.w	1000089e <fndsa_vect_FFT_fp64_exact.constprop.0+0x2e>
10000c40:	b049      	add	sp, #292	@ 0x124
10000c42:	ecbd 8b10 	vpop	{d8-d15}
10000c46:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10000c4a:	4770      	bx	lr
10000c4c:	f3af 8000 	nop.w
10000c50:	00000000 	.word	0x00000000
10000c54:	3df00000 	.word	0x3df00000
10000c58:	00000000 	.word	0x00000000
10000c5c:	41f00000 	.word	0x41f00000
10000c60:	3001b0a0 	.word	0x3001b0a0
10000c64:	300009a0 	.word	0x300009a0
