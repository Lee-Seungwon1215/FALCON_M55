10000878 <fndsa_vect_FFT_fp64_exact>:
10000878:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
1000087c:	2301      	movs	r3, #1
1000087e:	ed2d 8b10 	vpush	{d8-d15}
10000882:	f100 3aff 	add.w	sl, r0, #4294967295	@ 0xffffffff
10000886:	2802      	cmp	r0, #2
10000888:	4604      	mov	r4, r0
1000088a:	460e      	mov	r6, r1
1000088c:	b0df      	sub	sp, #380	@ 0x17c
1000088e:	fa03 f80a 	lsl.w	r8, r3, sl
10000892:	f200 857e 	bhi.w	10001392 <fndsa_vect_FFT_fp64_exact+0xb1a>
10000896:	bf08      	it	eq
10000898:	4686      	moveq	lr, r0
1000089a:	f040 8575 	bne.w	10001388 <fndsa_vect_FFT_fp64_exact+0xb10>
1000089e:	2010      	movs	r0, #16
100008a0:	9417      	str	r4, [sp, #92]	@ 0x5c
100008a2:	ed9f 9bbf 	vldr	d9, [pc, #764]	@ 10000ba0 <fndsa_vect_FFT_fp64_exact+0x328>
100008a6:	ed9f 8bc0 	vldr	d8, [pc, #768]	@ 10000ba8 <fndsa_vect_FFT_fp64_exact+0x330>
100008aa:	2401      	movs	r4, #1
100008ac:	f8cd 8058 	str.w	r8, [sp, #88]	@ 0x58
100008b0:	46c4      	mov	ip, r8
100008b2:	f8df 82fc 	ldr.w	r8, [pc, #764]	@ 10000bb0 <fndsa_vect_FFT_fp64_exact+0x338>
100008b6:	af18      	add	r7, sp, #96	@ 0x60
100008b8:	f8cd a050 	str.w	sl, [sp, #80]	@ 0x50
100008bc:	fa00 fb0a 	lsl.w	fp, r0, sl
100008c0:	f8cd e048 	str.w	lr, [sp, #72]	@ 0x48
100008c4:	2301      	movs	r3, #1
100008c6:	f04f 0a10 	mov.w	sl, #16
100008ca:	4662      	mov	r2, ip
100008cc:	40a3      	lsls	r3, r4
100008ce:	eb03 0353 	add.w	r3, r3, r3, lsr #1
100008d2:	eb08 1303 	add.w	r3, r8, r3, lsl #4
100008d6:	ea4f 0c5c 	mov.w	ip, ip, lsr #1
100008da:	fa0a fa04 	lsl.w	sl, sl, r4
100008de:	930a      	str	r3, [sp, #40]	@ 0x28
100008e0:	eb06 190c 	add.w	r9, r6, ip, lsl #4
100008e4:	4633      	mov	r3, r6
100008e6:	eb0a 0008 	add.w	r0, sl, r8
100008ea:	9610      	str	r6, [sp, #64]	@ 0x40
100008ec:	46da      	mov	sl, fp
100008ee:	f04f 0b00 	mov.w	fp, #0
100008f2:	f8cd c020 	str.w	ip, [sp, #32]
100008f6:	4616      	mov	r6, r2
100008f8:	940c      	str	r4, [sp, #48]	@ 0x30
100008fa:	eeb7 eb00 	vmov.f64	d14, #112	@ 0x3f800000  1.0
100008fe:	f8cd 8038 	str.w	r8, [sp, #56]	@ 0x38
10000902:	edd0 7a00 	vldr	s15, [r0]
10000906:	eeb8 1b67 	vcvt.f64.u32	d1, s15
1000090a:	edd0 7a02 	vldr	s15, [r0, #8]
1000090e:	eeb8 4b67 	vcvt.f64.u32	d4, s15
10000912:	edd0 7a01 	vldr	s15, [r0, #4]
10000916:	eeb8 2b67 	vcvt.f64.u32	d2, s15
1000091a:	edd0 7a03 	vldr	s15, [r0, #12]
1000091e:	6842      	ldr	r2, [r0, #4]
10000920:	eeb8 3b67 	vcvt.f64.u32	d3, s15
10000924:	0fd2      	lsrs	r2, r2, #31
10000926:	ee06 2a10 	vmov	s12, r2
1000092a:	ee17 2a90 	vmov	r2, s15
1000092e:	0fd2      	lsrs	r2, r2, #31
10000930:	ee07 2a10 	vmov	s14, r2
10000934:	ee31 5b04 	vadd.f64	d5, d1, d4
10000938:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
1000093c:	ee32 cb03 	vadd.f64	d12, d2, d3
10000940:	ed8d 7b52 	vstr	d7, [sp, #328]	@ 0x148
10000944:	ee25 7b09 	vmul.f64	d7, d5, d9
10000948:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000094c:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10000950:	ee3c cb07 	vadd.f64	d12, d12, d7
10000954:	ee07 5b48 	vmls.f64	d5, d7, d8
10000958:	9a08      	ldr	r2, [sp, #32]
1000095a:	eb02 010b 	add.w	r1, r2, fp
1000095e:	ee2c 7b09 	vmul.f64	d7, d12, d9
10000962:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10000966:	eebc 7bc7 	vcvt.u32.f64	s14, d7
1000096a:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000096e:	ee07 cb48 	vmls.f64	d12, d7, d8
10000972:	eebc 7bcc 	vcvt.u32.f64	s14, d12
10000976:	ee17 2a10 	vmov	r2, s14
1000097a:	0fd2      	lsrs	r2, r2, #31
1000097c:	ed8d 6b48 	vstr	d6, [sp, #288]	@ 0x120
10000980:	ee07 2a10 	vmov	s14, r2
10000984:	ee25 6b09 	vmul.f64	d6, d5, d9
10000988:	ee21 0b09 	vmul.f64	d0, d1, d9
1000098c:	ed8d 1b42 	vstr	d1, [sp, #264]	@ 0x108
10000990:	ed8d 6b5a 	vstr	d6, [sp, #360]	@ 0x168
10000994:	ee22 ab09 	vmul.f64	d10, d2, d9
10000998:	ee24 1b09 	vmul.f64	d1, d4, d9
1000099c:	ee23 bb09 	vmul.f64	d11, d3, d9
100009a0:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100009a4:	ee2c 6b09 	vmul.f64	d6, d12, d9
100009a8:	458b      	cmp	fp, r1
100009aa:	ed8d 2b40 	vstr	d2, [sp, #256]	@ 0x100
100009ae:	ed8d 3b4a 	vstr	d3, [sp, #296]	@ 0x128
100009b2:	ed8d 4b4c 	vstr	d4, [sp, #304]	@ 0x130
100009b6:	ed8d 0b46 	vstr	d0, [sp, #280]	@ 0x118
100009ba:	ed8d 1b50 	vstr	d1, [sp, #320]	@ 0x140
100009be:	ed8d ab44 	vstr	d10, [sp, #272]	@ 0x110
100009c2:	ed8d bb4e 	vstr	d11, [sp, #312]	@ 0x138
100009c6:	ed8d 5b56 	vstr	d5, [sp, #344]	@ 0x158
100009ca:	ed8d cb54 	vstr	d12, [sp, #336]	@ 0x150
100009ce:	ed8d 6b58 	vstr	d6, [sp, #352]	@ 0x160
100009d2:	ed8d 7b5c 	vstr	d7, [sp, #368]	@ 0x170
100009d6:	f080 80ae 	bcs.w	10000b36 <fndsa_vect_FFT_fp64_exact+0x2be>
100009da:	4649      	mov	r1, r9
100009dc:	461c      	mov	r4, r3
100009de:	4680      	mov	r8, r0
100009e0:	9604      	str	r6, [sp, #16]
100009e2:	eb0a 0509 	add.w	r5, sl, r9
100009e6:	9306      	str	r3, [sp, #24]
100009e8:	eb0a 0603 	add.w	r6, sl, r3
100009ec:	ed91 0b00 	vldr	d0, [r1]
100009f0:	ed95 2b00 	vldr	d2, [r5]
100009f4:	ed95 3b02 	vldr	d3, [r5, #8]
100009f8:	ed91 1b02 	vldr	d1, [r1, #8]
100009fc:	a840      	add	r0, sp, #256	@ 0x100
100009fe:	f7ff fcb3 	bl	10000368 <fp64e_cmul_prepared>
10000a02:	ed94 db02 	vldr	d13, [r4, #8]
10000a06:	ee3d 7b01 	vadd.f64	d7, d13, d1
10000a0a:	ed96 ab00 	vldr	d10, [r6]
10000a0e:	ed96 cb02 	vldr	d12, [r6, #8]
10000a12:	ed94 bb00 	vldr	d11, [r4]
10000a16:	ed87 1b02 	vstr	d1, [r7, #8]
10000a1a:	ed87 0b00 	vstr	d0, [r7]
10000a1e:	ed87 2b04 	vstr	d2, [r7, #16]
10000a22:	ed87 3b06 	vstr	d3, [r7, #24]
10000a26:	ee3c 6b03 	vadd.f64	d6, d12, d3
10000a2a:	ee3d 5b08 	vadd.f64	d5, d13, d8
10000a2e:	ee3a db02 	vadd.f64	d13, d10, d2
10000a32:	ee3a ab08 	vadd.f64	d10, d10, d8
10000a36:	ee3b fb00 	vadd.f64	d15, d11, d0
10000a3a:	ee3a ab42 	vsub.f64	d10, d10, d2
10000a3e:	ee26 4b09 	vmul.f64	d4, d6, d9
10000a42:	ee3c cb08 	vadd.f64	d12, d12, d8
10000a46:	ee3b bb08 	vadd.f64	d11, d11, d8
10000a4a:	ee35 1b41 	vsub.f64	d1, d5, d1
10000a4e:	ee3b bb40 	vsub.f64	d11, d11, d0
10000a52:	eebc 0bc4 	vcvt.u32.f64	s0, d4
10000a56:	ee3c 2b43 	vsub.f64	d2, d12, d3
10000a5a:	ee27 5b09 	vmul.f64	d5, d7, d9
10000a5e:	ee3a 3b4e 	vsub.f64	d3, d10, d14
10000a62:	eebc abc5 	vcvt.u32.f64	s20, d5
10000a66:	ee22 cb09 	vmul.f64	d12, d2, d9
10000a6a:	ed8d 3b02 	vstr	d3, [sp, #8]
10000a6e:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10000a72:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10000a76:	ee21 3b09 	vmul.f64	d3, d1, d9
10000a7a:	ee3b 5b4e 	vsub.f64	d5, d11, d14
10000a7e:	ee0a 7b48 	vmls.f64	d7, d10, d8
10000a82:	ed8d 5b00 	vstr	d5, [sp]
10000a86:	ee00 6b48 	vmls.f64	d6, d0, d8
10000a8a:	eebc cbcc 	vcvt.u32.f64	s24, d12
10000a8e:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10000a92:	eeb8 4b4c 	vcvt.f64.u32	d4, s24
10000a96:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10000a9a:	eeb0 cb47 	vmov.f64	d12, d7
10000a9e:	ee3d bb00 	vadd.f64	d11, d13, d0
10000aa2:	ed9d 7b00 	vldr	d7, [sp]
10000aa6:	eeb0 db46 	vmov.f64	d13, d6
10000aaa:	ed9d 6b02 	vldr	d6, [sp, #8]
10000aae:	ee3f 5b0a 	vadd.f64	d5, d15, d10
10000ab2:	ee37 7b03 	vadd.f64	d7, d7, d3
10000ab6:	ee36 6b04 	vadd.f64	d6, d6, d4
10000aba:	ee25 0b09 	vmul.f64	d0, d5, d9
10000abe:	ee2b ab09 	vmul.f64	d10, d11, d9
10000ac2:	ee03 1b48 	vmls.f64	d1, d3, d8
10000ac6:	ee04 2b48 	vmls.f64	d2, d4, d8
10000aca:	ee27 3b09 	vmul.f64	d3, d7, d9
10000ace:	ee26 4b09 	vmul.f64	d4, d6, d9
10000ad2:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10000ad6:	eebc abca 	vcvt.u32.f64	s20, d10
10000ada:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10000ade:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10000ae2:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10000ae6:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10000aea:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10000aee:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10000af2:	ee00 5b48 	vmls.f64	d5, d0, d8
10000af6:	ee0a bb48 	vmls.f64	d11, d10, d8
10000afa:	ee03 7b48 	vmls.f64	d7, d3, d8
10000afe:	ee04 6b48 	vmls.f64	d6, d4, d8
10000b02:	3410      	adds	r4, #16
10000b04:	3610      	adds	r6, #16
10000b06:	3110      	adds	r1, #16
10000b08:	3510      	adds	r5, #16
10000b0a:	45a1      	cmp	r9, r4
10000b0c:	ed04 cb02 	vstr	d12, [r4, #-8]
10000b10:	ed04 5b04 	vstr	d5, [r4, #-16]
10000b14:	ed06 bb04 	vstr	d11, [r6, #-16]
10000b18:	ed06 db02 	vstr	d13, [r6, #-8]
10000b1c:	ed01 1b02 	vstr	d1, [r1, #-8]
10000b20:	ed01 7b04 	vstr	d7, [r1, #-16]
10000b24:	ed05 6b04 	vstr	d6, [r5, #-16]
10000b28:	ed05 2b02 	vstr	d2, [r5, #-8]
10000b2c:	f47f af5e 	bne.w	100009ec <fndsa_vect_FFT_fp64_exact+0x174>
10000b30:	4640      	mov	r0, r8
10000b32:	9e04      	ldr	r6, [sp, #16]
10000b34:	9b06      	ldr	r3, [sp, #24]
10000b36:	9a0a      	ldr	r2, [sp, #40]	@ 0x28
10000b38:	3010      	adds	r0, #16
10000b3a:	4282      	cmp	r2, r0
10000b3c:	44b3      	add	fp, r6
10000b3e:	eb03 1306 	add.w	r3, r3, r6, lsl #4
10000b42:	eb09 1906 	add.w	r9, r9, r6, lsl #4
10000b46:	f47f aedc 	bne.w	10000902 <fndsa_vect_FFT_fp64_exact+0x8a>
10000b4a:	9c0c      	ldr	r4, [sp, #48]	@ 0x30
10000b4c:	9b12      	ldr	r3, [sp, #72]	@ 0x48
10000b4e:	3401      	adds	r4, #1
10000b50:	429c      	cmp	r4, r3
10000b52:	46d3      	mov	fp, sl
10000b54:	f8dd c020 	ldr.w	ip, [sp, #32]
10000b58:	f8dd 8038 	ldr.w	r8, [sp, #56]	@ 0x38
10000b5c:	9e10      	ldr	r6, [sp, #64]	@ 0x40
10000b5e:	f4ff aeb1 	bcc.w	100008c4 <fndsa_vect_FFT_fp64_exact+0x4c>
10000b62:	4645      	mov	r5, r8
10000b64:	e9dd 8416 	ldrd	r8, r4, [sp, #88]	@ 0x58
10000b68:	2c02      	cmp	r4, #2
10000b6a:	f8dd a050 	ldr.w	sl, [sp, #80]	@ 0x50
10000b6e:	f000 840b 	beq.w	10001388 <fndsa_vect_FFT_fp64_exact+0xb10>
10000b72:	4631      	mov	r1, r6
10000b74:	2410      	movs	r4, #16
10000b76:	ed9f eb0a 	vldr	d14, [pc, #40]	@ 10000ba0 <fndsa_vect_FFT_fp64_exact+0x328>
10000b7a:	ed9f fb0b 	vldr	d15, [pc, #44]	@ 10000ba8 <fndsa_vect_FFT_fp64_exact+0x330>
10000b7e:	f108 33ff 	add.w	r3, r8, #4294967295	@ 0xffffffff
10000b82:	fa04 f40a 	lsl.w	r4, r4, sl
10000b86:	ea4f 0658 	mov.w	r6, r8, lsr #1
10000b8a:	089b      	lsrs	r3, r3, #2
10000b8c:	f101 0740 	add.w	r7, r1, #64	@ 0x40
10000b90:	eb05 1606 	add.w	r6, r5, r6, lsl #4
10000b94:	eb07 1783 	add.w	r7, r7, r3, lsl #6
10000b98:	4425      	add	r5, r4
10000b9a:	440c      	add	r4, r1
10000b9c:	e00a      	b.n	10000bb4 <fndsa_vect_FFT_fp64_exact+0x33c>
10000b9e:	bf00      	nop
10000ba0:	00000000 	.word	0x00000000
10000ba4:	3df00000 	.word	0x3df00000
10000ba8:	00000000 	.word	0x00000000
10000bac:	41f00000 	.word	0x41f00000
10000bb0:	300009a0 	.word	0x300009a0
10000bb4:	ed91 7b02 	vldr	d7, [r1, #8]
10000bb8:	ed91 3b06 	vldr	d3, [r1, #24]
10000bbc:	ed8d 7b02 	vstr	d7, [sp, #8]
10000bc0:	edd6 7a00 	vldr	s15, [r6]
10000bc4:	ed94 2b04 	vldr	d2, [r4, #16]
10000bc8:	ed91 5b04 	vldr	d5, [r1, #16]
10000bcc:	ed91 4b00 	vldr	d4, [r1]
10000bd0:	ed8d 3b00 	vstr	d3, [sp]
10000bd4:	eeb8 3b67 	vcvt.f64.u32	d3, s15
10000bd8:	edd6 7a02 	vldr	s15, [r6, #8]
10000bdc:	6873      	ldr	r3, [r6, #4]
10000bde:	ed8d 2b06 	vstr	d2, [sp, #24]
10000be2:	0fdb      	lsrs	r3, r3, #31
10000be4:	ee02 3a10 	vmov	s4, r3
10000be8:	68f3      	ldr	r3, [r6, #12]
10000bea:	ed94 6b02 	vldr	d6, [r4, #8]
10000bee:	0fdb      	lsrs	r3, r3, #31
10000bf0:	ed8d 5b0a 	vstr	d5, [sp, #40]	@ 0x28
10000bf4:	ee05 3a10 	vmov	s10, r3
10000bf8:	ed8d 4b0c 	vstr	d4, [sp, #48]	@ 0x30
10000bfc:	eeb8 4b67 	vcvt.f64.u32	d4, s15
10000c00:	edd6 7a01 	vldr	s15, [r6, #4]
10000c04:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
10000c08:	ed8d 6b12 	vstr	d6, [sp, #72]	@ 0x48
10000c0c:	eeb8 6b67 	vcvt.f64.u32	d6, s15
10000c10:	edd6 7a03 	vldr	s15, [r6, #12]
10000c14:	ed94 bb00 	vldr	d11, [r4]
10000c18:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10000c1c:	ed94 1b06 	vldr	d1, [r4, #24]
10000c20:	eeb8 2bc2 	vcvt.f64.s32	d2, s4
10000c24:	ed94 0b0c 	vldr	d0, [r4, #48]	@ 0x30
10000c28:	ed8d 3b42 	vstr	d3, [sp, #264]	@ 0x108
10000c2c:	ed8d 4b4c 	vstr	d4, [sp, #304]	@ 0x130
10000c30:	ed8d 5b52 	vstr	d5, [sp, #328]	@ 0x148
10000c34:	ee33 5b04 	vadd.f64	d5, d3, d4
10000c38:	ed91 cb0c 	vldr	d12, [r1, #48]	@ 0x30
10000c3c:	ed91 db0e 	vldr	d13, [r1, #56]	@ 0x38
10000c40:	ed8d bb08 	vstr	d11, [sp, #32]
10000c44:	ed8d 1b04 	vstr	d1, [sp, #16]
10000c48:	ee23 3b0e 	vmul.f64	d3, d3, d14
10000c4c:	ee24 4b0e 	vmul.f64	d4, d4, d14
10000c50:	ed8d 0b10 	vstr	d0, [sp, #64]	@ 0x40
10000c54:	ed8d 2b48 	vstr	d2, [sp, #288]	@ 0x120
10000c58:	ed8d 6b40 	vstr	d6, [sp, #256]	@ 0x100
10000c5c:	ed8d 7b4a 	vstr	d7, [sp, #296]	@ 0x128
10000c60:	ed8d 3b46 	vstr	d3, [sp, #280]	@ 0x118
10000c64:	ed8d 4b50 	vstr	d4, [sp, #320]	@ 0x140
10000c68:	ee25 4b0e 	vmul.f64	d4, d5, d14
10000c6c:	eefc 3bc4 	vcvt.u32.f64	s7, d4
10000c70:	ee36 4b07 	vadd.f64	d4, d6, d7
10000c74:	ee27 7b0e 	vmul.f64	d7, d7, d14
10000c78:	ed8d 7b4e 	vstr	d7, [sp, #312]	@ 0x138
10000c7c:	eeb8 7b63 	vcvt.f64.u32	d7, s7
10000c80:	ee34 4b07 	vadd.f64	d4, d4, d7
10000c84:	ee07 5b4f 	vmls.f64	d5, d7, d15
10000c88:	ee24 7b0e 	vmul.f64	d7, d4, d14
10000c8c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10000c90:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10000c94:	ee07 4b4f 	vmls.f64	d4, d7, d15
10000c98:	eebc 7bc4 	vcvt.u32.f64	s14, d4
10000c9c:	ee17 3a10 	vmov	r3, s14
10000ca0:	0fdb      	lsrs	r3, r3, #31
10000ca2:	ed94 8b0e 	vldr	d8, [r4, #56]	@ 0x38
10000ca6:	ee07 3a10 	vmov	s14, r3
10000caa:	ed8d 5b56 	vstr	d5, [sp, #344]	@ 0x158
10000cae:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10000cb2:	ed8d 4b54 	vstr	d4, [sp, #336]	@ 0x150
10000cb6:	ee24 4b0e 	vmul.f64	d4, d4, d14
10000cba:	ed91 0b08 	vldr	d0, [r1, #32]
10000cbe:	ed91 1b0a 	vldr	d1, [r1, #40]	@ 0x28
10000cc2:	ed94 2b08 	vldr	d2, [r4, #32]
10000cc6:	a840      	add	r0, sp, #256	@ 0x100
10000cc8:	ed94 3b0a 	vldr	d3, [r4, #40]	@ 0x28
10000ccc:	ee26 6b0e 	vmul.f64	d6, d6, d14
10000cd0:	ed8d 4b58 	vstr	d4, [sp, #352]	@ 0x160
10000cd4:	ed8d 7b5c 	vstr	d7, [sp, #368]	@ 0x170
10000cd8:	ee25 5b0e 	vmul.f64	d5, d5, d14
10000cdc:	ed8d 6b44 	vstr	d6, [sp, #272]	@ 0x110
10000ce0:	ed8d 5b5a 	vstr	d5, [sp, #360]	@ 0x168
10000ce4:	ed8d 8b0e 	vstr	d8, [sp, #56]	@ 0x38
10000ce8:	f7ff fb3e 	bl	10000368 <fp64e_cmul_prepared>
10000cec:	eeb0 9b40 	vmov.f64	d9, d0
10000cf0:	eeb0 8b42 	vmov.f64	d8, d2
10000cf4:	ed9d 2b10 	vldr	d2, [sp, #64]	@ 0x40
10000cf8:	eeb0 ab43 	vmov.f64	d10, d3
10000cfc:	ed9d 3b0e 	vldr	d3, [sp, #56]	@ 0x38
10000d00:	eeb0 bb41 	vmov.f64	d11, d1
10000d04:	ed8d 9b20 	vstr	d9, [sp, #128]	@ 0x80
10000d08:	eeb0 1b4d 	vmov.f64	d1, d13
10000d0c:	ed8d bb22 	vstr	d11, [sp, #136]	@ 0x88
10000d10:	eeb0 0b4c 	vmov.f64	d0, d12
10000d14:	ed8d 8b24 	vstr	d8, [sp, #144]	@ 0x90
10000d18:	ed8d ab26 	vstr	d10, [sp, #152]	@ 0x98
10000d1c:	f7ff fb24 	bl	10000368 <fp64e_cmul_prepared>
10000d20:	edd5 7a00 	vldr	s15, [r5]
10000d24:	eeb8 5b67 	vcvt.f64.u32	d5, s15
10000d28:	edd5 7a02 	vldr	s15, [r5, #8]
10000d2c:	eeb8 6b67 	vcvt.f64.u32	d6, s15
10000d30:	edd5 7a01 	vldr	s15, [r5, #4]
10000d34:	686b      	ldr	r3, [r5, #4]
10000d36:	eeb8 cb67 	vcvt.f64.u32	d12, s15
10000d3a:	0fdb      	lsrs	r3, r3, #31
10000d3c:	ee04 3a10 	vmov	s8, r3
10000d40:	68eb      	ldr	r3, [r5, #12]
10000d42:	edd5 7a03 	vldr	s15, [r5, #12]
10000d46:	0fdb      	lsrs	r3, r3, #31
10000d48:	ee07 3a10 	vmov	s14, r3
10000d4c:	eeb8 db67 	vcvt.f64.u32	d13, s15
10000d50:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10000d54:	ed8d 6b4c 	vstr	d6, [sp, #304]	@ 0x130
10000d58:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
10000d5c:	ed8d 7b52 	vstr	d7, [sp, #328]	@ 0x148
10000d60:	ee35 7b06 	vadd.f64	d7, d5, d6
10000d64:	ed8d 4b48 	vstr	d4, [sp, #288]	@ 0x120
10000d68:	ed8d 5b42 	vstr	d5, [sp, #264]	@ 0x108
10000d6c:	ed9d 4b02 	vldr	d4, [sp, #8]
10000d70:	ee26 6b0e 	vmul.f64	d6, d6, d14
10000d74:	ee25 5b0e 	vmul.f64	d5, d5, d14
10000d78:	ed8d 6b50 	vstr	d6, [sp, #320]	@ 0x140
10000d7c:	ee27 6b0e 	vmul.f64	d6, d7, d14
10000d80:	ed8d 5b46 	vstr	d5, [sp, #280]	@ 0x118
10000d84:	ee34 5b0f 	vadd.f64	d5, d4, d15
10000d88:	ee34 4b0b 	vadd.f64	d4, d4, d11
10000d8c:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10000d90:	ed8d 4b10 	vstr	d4, [sp, #64]	@ 0x40
10000d94:	eeb8 4b46 	vcvt.f64.u32	d4, s12
10000d98:	ed9d 6b12 	vldr	d6, [sp, #72]	@ 0x48
10000d9c:	ee04 7b4f 	vmls.f64	d7, d4, d15
10000da0:	ed8d 7b56 	vstr	d7, [sp, #344]	@ 0x158
10000da4:	ee27 7b0e 	vmul.f64	d7, d7, d14
10000da8:	ed8d 7b5a 	vstr	d7, [sp, #360]	@ 0x168
10000dac:	ee36 7b0f 	vadd.f64	d7, d6, d15
10000db0:	ed8d 0b28 	vstr	d0, [sp, #160]	@ 0xa0
10000db4:	ed8d 1b2a 	vstr	d1, [sp, #168]	@ 0xa8
10000db8:	ed8d 2b2c 	vstr	d2, [sp, #176]	@ 0xb0
10000dbc:	ed8d 3b2e 	vstr	d3, [sp, #184]	@ 0xb8
10000dc0:	ee3a 6b06 	vadd.f64	d6, d10, d6
10000dc4:	ee37 ab4a 	vsub.f64	d10, d7, d10
10000dc8:	ed8d cb40 	vstr	d12, [sp, #256]	@ 0x100
10000dcc:	ed8d db4a 	vstr	d13, [sp, #296]	@ 0x128
10000dd0:	ed8d 6b0e 	vstr	d6, [sp, #56]	@ 0x38
10000dd4:	ed9d 6b00 	vldr	d6, [sp]
10000dd8:	ee36 7b0f 	vadd.f64	d7, d6, d15
10000ddc:	ee36 6b01 	vadd.f64	d6, d6, d1
10000de0:	ee37 7b41 	vsub.f64	d7, d7, d1
10000de4:	ed9d 1b04 	vldr	d1, [sp, #16]
10000de8:	ee35 bb4b 	vsub.f64	d11, d5, d11
10000dec:	ed8d 7b02 	vstr	d7, [sp, #8]
10000df0:	ee31 5b0f 	vadd.f64	d5, d1, d15
10000df4:	ee31 7b03 	vadd.f64	d7, d1, d3
10000df8:	ee35 3b43 	vsub.f64	d3, d5, d3
10000dfc:	ee3c 5b0d 	vadd.f64	d5, d12, d13
10000e00:	ee2c cb0e 	vmul.f64	d12, d12, d14
10000e04:	ee35 1b04 	vadd.f64	d1, d5, d4
10000e08:	ed8d cb44 	vstr	d12, [sp, #272]	@ 0x110
10000e0c:	ee26 5b0e 	vmul.f64	d5, d6, d14
10000e10:	eefc 4bc5 	vcvt.u32.f64	s9, d5
10000e14:	ee27 5b0e 	vmul.f64	d5, d7, d14
10000e18:	eeb8 cb64 	vcvt.f64.u32	d12, s9
10000e1c:	eefc 5bc5 	vcvt.u32.f64	s11, d5
10000e20:	ee2d db0e 	vmul.f64	d13, d13, d14
10000e24:	ed9d 4b0e 	vldr	d4, [sp, #56]	@ 0x38
10000e28:	ed8d 1b14 	vstr	d1, [sp, #80]	@ 0x50
10000e2c:	eeb0 1b46 	vmov.f64	d1, d6
10000e30:	ed8d db4e 	vstr	d13, [sp, #312]	@ 0x138
10000e34:	eeb8 db65 	vcvt.f64.u32	d13, s11
10000e38:	ee24 6b0e 	vmul.f64	d6, d4, d14
10000e3c:	ed9d 5b10 	vldr	d5, [sp, #64]	@ 0x40
10000e40:	ed8d 3b00 	vstr	d3, [sp]
10000e44:	eeb0 3b47 	vmov.f64	d3, d7
10000e48:	ee25 7b0e 	vmul.f64	d7, d5, d14
10000e4c:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10000e50:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10000e54:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10000e58:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10000e5c:	ee06 4b4f 	vmls.f64	d4, d6, d15
10000e60:	ed8d 6b04 	vstr	d6, [sp, #16]
10000e64:	ee07 5b4f 	vmls.f64	d5, d7, d15
10000e68:	ed8d 4b0e 	vstr	d4, [sp, #56]	@ 0x38
10000e6c:	ed9d 4b0c 	vldr	d4, [sp, #48]	@ 0x30
10000e70:	ee2b 6b0e 	vmul.f64	d6, d11, d14
10000e74:	ed8d 5b12 	vstr	d5, [sp, #72]	@ 0x48
10000e78:	ee34 5b0f 	vadd.f64	d5, d4, d15
10000e7c:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10000e80:	ee34 4b09 	vadd.f64	d4, d4, d9
10000e84:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10000e88:	ee34 4b07 	vadd.f64	d4, d4, d7
10000e8c:	ee35 5b49 	vsub.f64	d5, d5, d9
10000e90:	eeb7 7b00 	vmov.f64	d7, #112	@ 0x3f800000  1.0
10000e94:	eeb0 9b4b 	vmov.f64	d9, d11
10000e98:	ee35 5b47 	vsub.f64	d5, d5, d7
10000e9c:	ed9d bb08 	vldr	d11, [sp, #32]
10000ea0:	ee06 9b4f 	vmls.f64	d9, d6, d15
10000ea4:	ee2a 7b0e 	vmul.f64	d7, d10, d14
10000ea8:	ed8d 9b0c 	vstr	d9, [sp, #48]	@ 0x30
10000eac:	ee35 9b06 	vadd.f64	d9, d5, d6
10000eb0:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10000eb4:	ee3b 6b0f 	vadd.f64	d6, d11, d15
10000eb8:	ee3b 5b08 	vadd.f64	d5, d11, d8
10000ebc:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10000ec0:	eeb7 bb00 	vmov.f64	d11, #112	@ 0x3f800000  1.0
10000ec4:	ee36 6b48 	vsub.f64	d6, d6, d8
10000ec8:	ed9d 8b04 	vldr	d8, [sp, #16]
10000ecc:	ee07 ab4f 	vmls.f64	d10, d7, d15
10000ed0:	ee36 6b4b 	vsub.f64	d6, d6, d11
10000ed4:	ed8d ab08 	vstr	d10, [sp, #32]
10000ed8:	ee35 8b08 	vadd.f64	d8, d5, d8
10000edc:	ee36 ab07 	vadd.f64	d10, d6, d7
10000ee0:	ed9d 6b02 	vldr	d6, [sp, #8]
10000ee4:	ee26 5b0e 	vmul.f64	d5, d6, d14
10000ee8:	ed9d 6b0a 	vldr	d6, [sp, #40]	@ 0x28
10000eec:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10000ef0:	ee36 7b0f 	vadd.f64	d7, d6, d15
10000ef4:	ee36 6b00 	vadd.f64	d6, d6, d0
10000ef8:	ee37 7b40 	vsub.f64	d7, d7, d0
10000efc:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10000f00:	ee36 0b0c 	vadd.f64	d0, d6, d12
10000f04:	ed9d 6b02 	vldr	d6, [sp, #8]
10000f08:	ee05 6b4f 	vmls.f64	d6, d5, d15
10000f0c:	ee0c 1b4f 	vmls.f64	d1, d12, d15
10000f10:	ed8d 6b02 	vstr	d6, [sp, #8]
10000f14:	ee37 7b4b 	vsub.f64	d7, d7, d11
10000f18:	eeb0 cb4b 	vmov.f64	d12, d11
10000f1c:	ee37 5b05 	vadd.f64	d5, d7, d5
10000f20:	ed9d bb00 	vldr	d11, [sp]
10000f24:	ed9d 6b06 	vldr	d6, [sp, #24]
10000f28:	ee2b bb0e 	vmul.f64	d11, d11, d14
10000f2c:	ee36 7b0f 	vadd.f64	d7, d6, d15
10000f30:	eebc bbcb 	vcvt.u32.f64	s22, d11
10000f34:	ee36 6b02 	vadd.f64	d6, d6, d2
10000f38:	ee37 7b42 	vsub.f64	d7, d7, d2
10000f3c:	ee36 2b0d 	vadd.f64	d2, d6, d13
10000f40:	ee37 7b4c 	vsub.f64	d7, d7, d12
10000f44:	ee0d 3b4f 	vmls.f64	d3, d13, d15
10000f48:	ed9d db00 	vldr	d13, [sp]
10000f4c:	eeb8 bb4b 	vcvt.f64.u32	d11, s22
10000f50:	ee0b db4f 	vmls.f64	d13, d11, d15
10000f54:	ee37 bb0b 	vadd.f64	d11, d7, d11
10000f58:	ed9d 7b14 	vldr	d7, [sp, #80]	@ 0x50
10000f5c:	ee27 6b0e 	vmul.f64	d6, d7, d14
10000f60:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10000f64:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10000f68:	ee06 7b4f 	vmls.f64	d7, d6, d15
10000f6c:	eefc 6bc7 	vcvt.u32.f64	s13, d7
10000f70:	ed8d 7b54 	vstr	d7, [sp, #336]	@ 0x150
10000f74:	ee16 3a90 	vmov	r3, s13
10000f78:	ee27 7b0e 	vmul.f64	d7, d7, d14
10000f7c:	0fdb      	lsrs	r3, r3, #31
10000f7e:	ed8d 7b58 	vstr	d7, [sp, #352]	@ 0x160
10000f82:	ee07 3a10 	vmov	s14, r3
10000f86:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10000f8a:	ee28 6b0e 	vmul.f64	d6, d8, d14
10000f8e:	ed8d 7b5c 	vstr	d7, [sp, #368]	@ 0x170
10000f92:	ee24 7b0e 	vmul.f64	d7, d4, d14
10000f96:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10000f9a:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10000f9e:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10000fa2:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10000fa6:	ee06 8b4f 	vmls.f64	d8, d6, d15
10000faa:	ee07 4b4f 	vmls.f64	d4, d7, d15
10000fae:	ed8d 8b0a 	vstr	d8, [sp, #40]	@ 0x28
10000fb2:	ee29 7b0e 	vmul.f64	d7, d9, d14
10000fb6:	ee22 6b0e 	vmul.f64	d6, d2, d14
10000fba:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10000fbe:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10000fc2:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10000fc6:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10000fca:	ee07 9b4f 	vmls.f64	d9, d7, d15
10000fce:	ee25 7b0e 	vmul.f64	d7, d5, d14
10000fd2:	ee06 2b4f 	vmls.f64	d2, d6, d15
10000fd6:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10000fda:	ee2a 6b0e 	vmul.f64	d6, d10, d14
10000fde:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10000fe2:	eeb0 8b45 	vmov.f64	d8, d5
10000fe6:	ee20 cb0e 	vmul.f64	d12, d0, d14
10000fea:	ee07 8b4f 	vmls.f64	d8, d7, d15
10000fee:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10000ff2:	ee2b 7b0e 	vmul.f64	d7, d11, d14
10000ff6:	eebc cbcc 	vcvt.u32.f64	s24, d12
10000ffa:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10000ffe:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10001002:	eeb8 cb4c 	vcvt.f64.u32	d12, s24
10001006:	ee06 ab4f 	vmls.f64	d10, d6, d15
1000100a:	ed8d 4b10 	vstr	d4, [sp, #64]	@ 0x40
1000100e:	ed8d db00 	vstr	d13, [sp]
10001012:	ed8d 9b06 	vstr	d9, [sp, #24]
10001016:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000101a:	ee0c 0b4f 	vmls.f64	d0, d12, d15
1000101e:	ed8d ab04 	vstr	d10, [sp, #16]
10001022:	ee07 bb4f 	vmls.f64	d11, d7, d15
10001026:	f7ff f99f 	bl	10000368 <fp64e_cmul_prepared>
1000102a:	edd5 7a04 	vldr	s15, [r5, #16]
1000102e:	696b      	ldr	r3, [r5, #20]
10001030:	eeb0 db42 	vmov.f64	d13, d2
10001034:	0fdb      	lsrs	r3, r3, #31
10001036:	eeb0 2b4b 	vmov.f64	d2, d11
1000103a:	ee0b 3a10 	vmov	s22, r3
1000103e:	69eb      	ldr	r3, [r5, #28]
10001040:	eeb0 cb40 	vmov.f64	d12, d0
10001044:	0fdb      	lsrs	r3, r3, #31
10001046:	eeb0 0b48 	vmov.f64	d0, d8
1000104a:	ee05 3a10 	vmov	s10, r3
1000104e:	eeb8 8b67 	vcvt.f64.u32	d8, s15
10001052:	edd5 7a06 	vldr	s15, [r5, #24]
10001056:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
1000105a:	ed8d 8b42 	vstr	d8, [sp, #264]	@ 0x108
1000105e:	eeb8 4b67 	vcvt.f64.u32	d4, s15
10001062:	edd5 7a05 	vldr	s15, [r5, #20]
10001066:	ed8d 5b52 	vstr	d5, [sp, #328]	@ 0x148
1000106a:	ee38 5b04 	vadd.f64	d5, d8, d4
1000106e:	ee28 8b0e 	vmul.f64	d8, d8, d14
10001072:	eeb8 6b67 	vcvt.f64.u32	d6, s15
10001076:	ed8d 8b46 	vstr	d8, [sp, #280]	@ 0x118
1000107a:	ee25 8b0e 	vmul.f64	d8, d5, d14
1000107e:	edd5 7a07 	vldr	s15, [r5, #28]
10001082:	ed8d 4b4c 	vstr	d4, [sp, #304]	@ 0x130
10001086:	eeb8 7b67 	vcvt.f64.u32	d7, s15
1000108a:	eebc 8bc8 	vcvt.u32.f64	s16, d8
1000108e:	ee24 4b0e 	vmul.f64	d4, d4, d14
10001092:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10001096:	ed8d 4b50 	vstr	d4, [sp, #320]	@ 0x140
1000109a:	ee36 4b07 	vadd.f64	d4, d6, d7
1000109e:	ed8d 7b4a 	vstr	d7, [sp, #296]	@ 0x128
100010a2:	ee34 4b08 	vadd.f64	d4, d4, d8
100010a6:	ee27 7b0e 	vmul.f64	d7, d7, d14
100010aa:	ed8d 7b4e 	vstr	d7, [sp, #312]	@ 0x138
100010ae:	ee24 7b0e 	vmul.f64	d7, d4, d14
100010b2:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100010b6:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100010ba:	ee07 4b4f 	vmls.f64	d4, d7, d15
100010be:	eebc 7bc4 	vcvt.u32.f64	s14, d4
100010c2:	ee17 3a10 	vmov	r3, s14
100010c6:	0fdb      	lsrs	r3, r3, #31
100010c8:	ee08 5b4f 	vmls.f64	d5, d8, d15
100010cc:	ed8d 6b40 	vstr	d6, [sp, #256]	@ 0x100
100010d0:	ee07 3a10 	vmov	s14, r3
100010d4:	eeb0 ab41 	vmov.f64	d10, d1
100010d8:	eeb0 9b43 	vmov.f64	d9, d3
100010dc:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100010e0:	eeb8 bbcb 	vcvt.f64.s32	d11, s22
100010e4:	ee26 6b0e 	vmul.f64	d6, d6, d14
100010e8:	ed8d 5b56 	vstr	d5, [sp, #344]	@ 0x158
100010ec:	ed8d 4b54 	vstr	d4, [sp, #336]	@ 0x150
100010f0:	ed9d 1b02 	vldr	d1, [sp, #8]
100010f4:	ed9d 3b00 	vldr	d3, [sp]
100010f8:	ed8d cb30 	vstr	d12, [sp, #192]	@ 0xc0
100010fc:	ed8d ab32 	vstr	d10, [sp, #200]	@ 0xc8
10001100:	ed8d db34 	vstr	d13, [sp, #208]	@ 0xd0
10001104:	ed8d 9b36 	vstr	d9, [sp, #216]	@ 0xd8
10001108:	ee25 5b0e 	vmul.f64	d5, d5, d14
1000110c:	ee24 4b0e 	vmul.f64	d4, d4, d14
10001110:	ed8d bb48 	vstr	d11, [sp, #288]	@ 0x120
10001114:	ed8d 6b44 	vstr	d6, [sp, #272]	@ 0x110
10001118:	ed8d 5b5a 	vstr	d5, [sp, #360]	@ 0x168
1000111c:	ed8d 4b58 	vstr	d4, [sp, #352]	@ 0x160
10001120:	ed8d 7b5c 	vstr	d7, [sp, #368]	@ 0x170
10001124:	f7ff f920 	bl	10000368 <fp64e_cmul_prepared>
10001128:	ed9d 5b12 	vldr	d5, [sp, #72]	@ 0x48
1000112c:	ee35 6b0a 	vadd.f64	d6, d5, d10
10001130:	ed9d 7b0e 	vldr	d7, [sp, #56]	@ 0x38
10001134:	ee35 4b0f 	vadd.f64	d4, d5, d15
10001138:	ed9d 5b0c 	vldr	d5, [sp, #48]	@ 0x30
1000113c:	ed8d 1b3a 	vstr	d1, [sp, #232]	@ 0xe8
10001140:	ee37 8b0f 	vadd.f64	d8, d7, d15
10001144:	ee35 bb0f 	vadd.f64	d11, d5, d15
10001148:	ee37 7b09 	vadd.f64	d7, d7, d9
1000114c:	ee38 8b49 	vsub.f64	d8, d8, d9
10001150:	ee3b bb41 	vsub.f64	d11, d11, d1
10001154:	ee35 9b01 	vadd.f64	d9, d5, d1
10001158:	ed9d 1b08 	vldr	d1, [sp, #32]
1000115c:	ee31 5b0f 	vadd.f64	d5, d1, d15
10001160:	ee34 4b4a 	vsub.f64	d4, d4, d10
10001164:	ee35 5b43 	vsub.f64	d5, d5, d3
10001168:	ee31 ab03 	vadd.f64	d10, d1, d3
1000116c:	ed8d 5b00 	vstr	d5, [sp]
10001170:	ed8d 3b3e 	vstr	d3, [sp, #248]	@ 0xf8
10001174:	ee26 5b0e 	vmul.f64	d5, d6, d14
10001178:	ee27 3b0e 	vmul.f64	d3, d7, d14
1000117c:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10001180:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10001184:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10001188:	eeb8 1b43 	vcvt.f64.u32	d1, s6
1000118c:	ed9d 3b10 	vldr	d3, [sp, #64]	@ 0x40
10001190:	ee01 7b4f 	vmls.f64	d7, d1, d15
10001194:	ee05 6b4f 	vmls.f64	d6, d5, d15
10001198:	ed8d 7b02 	vstr	d7, [sp, #8]
1000119c:	ee24 7b0e 	vmul.f64	d7, d4, d14
100011a0:	ed81 6b02 	vstr	d6, [r1, #8]
100011a4:	ee33 6b0f 	vadd.f64	d6, d3, d15
100011a8:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100011ac:	ee33 3b0c 	vadd.f64	d3, d3, d12
100011b0:	ee36 6b4c 	vsub.f64	d6, d6, d12
100011b4:	eeb7 cb00 	vmov.f64	d12, #112	@ 0x3f800000  1.0
100011b8:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100011bc:	ee36 6b4c 	vsub.f64	d6, d6, d12
100011c0:	eeb0 cb44 	vmov.f64	d12, d4
100011c4:	ed9d 4b0a 	vldr	d4, [sp, #40]	@ 0x28
100011c8:	ee07 cb4f 	vmls.f64	d12, d7, d15
100011cc:	ed8d cb08 	vstr	d12, [sp, #32]
100011d0:	ee36 cb07 	vadd.f64	d12, d6, d7
100011d4:	ee28 7b0e 	vmul.f64	d7, d8, d14
100011d8:	ee33 3b05 	vadd.f64	d3, d3, d5
100011dc:	ee34 6b0f 	vadd.f64	d6, d4, d15
100011e0:	ee34 5b0d 	vadd.f64	d5, d4, d13
100011e4:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100011e8:	ee35 1b01 	vadd.f64	d1, d5, d1
100011ec:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100011f0:	ee36 6b4d 	vsub.f64	d6, d6, d13
100011f4:	ed9d 4b06 	vldr	d4, [sp, #24]
100011f8:	eeb7 5b00 	vmov.f64	d5, #112	@ 0x3f800000  1.0
100011fc:	ee07 8b4f 	vmls.f64	d8, d7, d15
10001200:	ee36 6b45 	vsub.f64	d6, d6, d5
10001204:	eeb0 db48 	vmov.f64	d13, d8
10001208:	ee2b 5b0e 	vmul.f64	d5, d11, d14
1000120c:	ee36 8b07 	vadd.f64	d8, d6, d7
10001210:	eefc 5bc5 	vcvt.u32.f64	s11, d5
10001214:	ee29 7b0e 	vmul.f64	d7, d9, d14
10001218:	edcd 5a0a 	vstr	s11, [sp, #40]	@ 0x28
1000121c:	ed8d 0b38 	vstr	d0, [sp, #224]	@ 0xe0
10001220:	ee34 5b0f 	vadd.f64	d5, d4, d15
10001224:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10001228:	ee34 4b00 	vadd.f64	d4, d4, d0
1000122c:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10001230:	ee35 5b40 	vsub.f64	d5, d5, d0
10001234:	ee07 9b4f 	vmls.f64	d9, d7, d15
10001238:	ee34 0b07 	vadd.f64	d0, d4, d7
1000123c:	eddd 7a0a 	vldr	s15, [sp, #40]	@ 0x28
10001240:	eeb7 4b00 	vmov.f64	d4, #112	@ 0x3f800000  1.0
10001244:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10001248:	ee35 5b44 	vsub.f64	d5, d5, d4
1000124c:	ee07 bb4f 	vmls.f64	d11, d7, d15
10001250:	ee2a 6b0e 	vmul.f64	d6, d10, d14
10001254:	ee35 5b07 	vadd.f64	d5, d5, d7
10001258:	ed9d 7b00 	vldr	d7, [sp]
1000125c:	ed9d 4b04 	vldr	d4, [sp, #16]
10001260:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10001264:	ee27 7b0e 	vmul.f64	d7, d7, d14
10001268:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000126c:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10001270:	ee06 ab4f 	vmls.f64	d10, d6, d15
10001274:	edcd 7a06 	vstr	s15, [sp, #24]
10001278:	ed8d 2b3c 	vstr	d2, [sp, #240]	@ 0xf0
1000127c:	ee34 7b0f 	vadd.f64	d7, d4, d15
10001280:	ee34 4b02 	vadd.f64	d4, d4, d2
10001284:	ee37 7b42 	vsub.f64	d7, d7, d2
10001288:	ee34 4b06 	vadd.f64	d4, d4, d6
1000128c:	eddd 6a06 	vldr	s13, [sp, #24]
10001290:	eeb7 2b00 	vmov.f64	d2, #112	@ 0x3f800000  1.0
10001294:	eeb8 6b66 	vcvt.f64.u32	d6, s13
10001298:	ee37 7b42 	vsub.f64	d7, d7, d2
1000129c:	ed9d 2b00 	vldr	d2, [sp]
100012a0:	ee06 2b4f 	vmls.f64	d2, d6, d15
100012a4:	ed8d 2b00 	vstr	d2, [sp]
100012a8:	ee23 2b0e 	vmul.f64	d2, d3, d14
100012ac:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100012b0:	ee37 7b06 	vadd.f64	d7, d7, d6
100012b4:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100012b8:	ee21 6b0e 	vmul.f64	d6, d1, d14
100012bc:	ee02 3b4f 	vmls.f64	d3, d2, d15
100012c0:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100012c4:	ed81 3b00 	vstr	d3, [r1]
100012c8:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100012cc:	ed9d 3b02 	vldr	d3, [sp, #8]
100012d0:	ee06 1b4f 	vmls.f64	d1, d6, d15
100012d4:	ed84 3b02 	vstr	d3, [r4, #8]
100012d8:	ed9d 6b08 	vldr	d6, [sp, #32]
100012dc:	ee2c 3b0e 	vmul.f64	d3, d12, d14
100012e0:	ed84 1b00 	vstr	d1, [r4]
100012e4:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100012e8:	ed81 6b06 	vstr	d6, [r1, #24]
100012ec:	ee28 6b0e 	vmul.f64	d6, d8, d14
100012f0:	ed9d 2b00 	vldr	d2, [sp]
100012f4:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100012f8:	eefc 6bc6 	vcvt.u32.f64	s13, d6
100012fc:	ee03 cb4f 	vmls.f64	d12, d3, d15
10001300:	eeb8 3b66 	vcvt.f64.u32	d3, s13
10001304:	ee20 6b0e 	vmul.f64	d6, d0, d14
10001308:	ee24 1b0e 	vmul.f64	d1, d4, d14
1000130c:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10001310:	ee03 8b4f 	vmls.f64	d8, d3, d15
10001314:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10001318:	ee25 3b0e 	vmul.f64	d3, d5, d14
1000131c:	ee06 0b4f 	vmls.f64	d0, d6, d15
10001320:	ee27 6b0e 	vmul.f64	d6, d7, d14
10001324:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10001328:	eebc 1bc1 	vcvt.u32.f64	s2, d1
1000132c:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10001330:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10001334:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10001338:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000133c:	ee01 4b4f 	vmls.f64	d4, d1, d15
10001340:	ee03 5b4f 	vmls.f64	d5, d3, d15
10001344:	ee06 7b4f 	vmls.f64	d7, d6, d15
10001348:	3140      	adds	r1, #64	@ 0x40
1000134a:	428f      	cmp	r7, r1
1000134c:	f104 0440 	add.w	r4, r4, #64	@ 0x40
10001350:	ed01 cb0c 	vstr	d12, [r1, #-48]	@ 0xffffffd0
10001354:	f106 0610 	add.w	r6, r6, #16
10001358:	ed04 db0a 	vstr	d13, [r4, #-40]	@ 0xffffffd8
1000135c:	ed04 8b0c 	vstr	d8, [r4, #-48]	@ 0xffffffd0
10001360:	f105 0520 	add.w	r5, r5, #32
10001364:	ed01 9b06 	vstr	d9, [r1, #-24]	@ 0xffffffe8
10001368:	ed01 0b08 	vstr	d0, [r1, #-32]	@ 0xffffffe0
1000136c:	ed04 ab06 	vstr	d10, [r4, #-24]	@ 0xffffffe8
10001370:	ed04 4b08 	vstr	d4, [r4, #-32]	@ 0xffffffe0
10001374:	ed01 5b04 	vstr	d5, [r1, #-16]
10001378:	ed01 bb02 	vstr	d11, [r1, #-8]
1000137c:	ed04 2b02 	vstr	d2, [r4, #-8]
10001380:	ed04 7b04 	vstr	d7, [r4, #-16]
10001384:	f47f ac16 	bne.w	10000bb4 <fndsa_vect_FFT_fp64_exact+0x33c>
10001388:	b05f      	add	sp, #380	@ 0x17c
1000138a:	ecbd 8b10 	vpop	{d8-d15}
1000138e:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10001392:	2803      	cmp	r0, #3
10001394:	f1a0 0e02 	sub.w	lr, r0, #2
10001398:	f47f aa81 	bne.w	1000089e <fndsa_vect_FFT_fp64_exact+0x26>
1000139c:	4d01      	ldr	r5, [pc, #4]	@ (100013a4 <fndsa_vect_FFT_fp64_exact+0xb2c>)
1000139e:	f7ff bbe8 	b.w	10000b72 <fndsa_vect_FFT_fp64_exact+0x2fa>
100013a2:	bf00      	nop
100013a4:	300009a0 	.word	0x300009a0

