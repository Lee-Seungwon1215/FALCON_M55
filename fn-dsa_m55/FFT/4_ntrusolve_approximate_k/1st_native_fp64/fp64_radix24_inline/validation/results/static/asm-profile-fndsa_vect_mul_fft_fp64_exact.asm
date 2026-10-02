
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/asm-profile/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

100076e0 <fndsa_vect_mul_fft_fp64_exact>:
100076e0:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
100076e4:	f04f 0a10 	mov.w	sl, #16
100076e8:	ed2d 8b10 	vpush	{d8-d15}
100076ec:	3801      	subs	r0, #1
100076ee:	fa0a fa00 	lsl.w	sl, sl, r0
100076f2:	f1aa 0e10 	sub.w	lr, sl, #16
100076f6:	ea4f 1e1e 	mov.w	lr, lr, lsr #4
100076fa:	b0b9      	sub	sp, #228	@ 0xe4
100076fc:	eb01 0b0a 	add.w	fp, r1, sl
10007700:	f10e 0e01 	add.w	lr, lr, #1
10007704:	4492      	add	sl, r2
10007706:	e9cd ab1e 	strd	sl, fp, [sp, #120]	@ 0x78
1000770a:	2700      	movs	r7, #0
1000770c:	ed9f 0bf8 	vldr	d0, [pc, #992]	@ 10007af0 <fndsa_vect_mul_fft_fp64_exact+0x410>
10007710:	ed9f 9bf9 	vldr	d9, [pc, #996]	@ 10007af8 <fndsa_vect_mul_fft_fp64_exact+0x418>
10007714:	ed9f dbfa 	vldr	d13, [pc, #1000]	@ 10007b00 <fndsa_vect_mul_fft_fp64_exact+0x420>
10007718:	ed9f bbfb 	vldr	d11, [pc, #1004]	@ 10007b08 <fndsa_vect_mul_fft_fp64_exact+0x428>
1000771c:	f04e e001 	dls	lr, lr
10007720:	ed9f abfb 	vldr	d10, [pc, #1004]	@ 10007b10 <fndsa_vect_mul_fft_fp64_exact+0x430>
10007724:	468a      	mov	sl, r1
10007726:	4693      	mov	fp, r2
10007728:	f10d 09a0 	add.w	r9, sp, #160	@ 0xa0
1000772c:	f10d 08b0 	add.w	r8, sp, #176	@ 0xb0
10007730:	9b1f      	ldr	r3, [sp, #124]	@ 0x7c
10007732:	eb0a 0507 	add.w	r5, sl, r7
10007736:	19dc      	adds	r4, r3, r7
10007738:	9b1e      	ldr	r3, [sp, #120]	@ 0x78
1000773a:	eb0b 0c07 	add.w	ip, fp, r7
1000773e:	19de      	adds	r6, r3, r7
10007740:	e895 000f 	ldmia.w	r5, {r0, r1, r2, r3}
10007744:	e889 000f 	stmia.w	r9, {r0, r1, r2, r3}
10007748:	e894 000f 	ldmia.w	r4, {r0, r1, r2, r3}
1000774c:	e888 000f 	stmia.w	r8, {r0, r1, r2, r3}
10007750:	e89c 000f 	ldmia.w	ip, {r0, r1, r2, r3}
10007754:	f10d 0cc0 	add.w	ip, sp, #192	@ 0xc0
10007758:	e88c 000f 	stmia.w	ip, {r0, r1, r2, r3}
1000775c:	e896 000f 	ldmia.w	r6, {r0, r1, r2, r3}
10007760:	ae34      	add	r6, sp, #208	@ 0xd0
10007762:	e886 000f 	stmia.w	r6, {r0, r1, r2, r3}
10007766:	ed9d 3b28 	vldr	d3, [sp, #160]	@ 0xa0
1000776a:	ed9d eb2c 	vldr	d14, [sp, #176]	@ 0xb0
1000776e:	eefc 7bc3 	vcvt.u32.f64	s15, d3
10007772:	ed9d 4b30 	vldr	d4, [sp, #192]	@ 0xc0
10007776:	ee17 1a90 	vmov	r1, s15
1000777a:	eefc 7bce 	vcvt.u32.f64	s15, d14
1000777e:	ee17 2a90 	vmov	r2, s15
10007782:	eefc 7bc4 	vcvt.u32.f64	s15, d4
10007786:	0fc9      	lsrs	r1, r1, #31
10007788:	ee17 3a90 	vmov	r3, s15
1000778c:	ee07 1a90 	vmov	s15, r1
10007790:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10007794:	0fd2      	lsrs	r2, r2, #31
10007796:	ed8d 7b10 	vstr	d7, [sp, #64]	@ 0x40
1000779a:	ee07 2a90 	vmov	s15, r2
1000779e:	0fdb      	lsrs	r3, r3, #31
100077a0:	eeb8 6be7 	vcvt.f64.s32	d6, s15
100077a4:	ed9d fb2e 	vldr	d15, [sp, #184]	@ 0xb8
100077a8:	ee07 3a90 	vmov	s15, r3
100077ac:	ed9d 8b2a 	vldr	d8, [sp, #168]	@ 0xa8
100077b0:	ed9d 5b34 	vldr	d5, [sp, #208]	@ 0xd0
100077b4:	eeb8 2be7 	vcvt.f64.s32	d2, s15
100077b8:	ee38 8b0f 	vadd.f64	d8, d8, d15
100077bc:	ed9d 7b36 	vldr	d7, [sp, #216]	@ 0xd8
100077c0:	ed9d fb32 	vldr	d15, [sp, #200]	@ 0xc8
100077c4:	ed8d 2b12 	vstr	d2, [sp, #72]	@ 0x48
100077c8:	ee3f 2b07 	vadd.f64	d2, d15, d7
100077cc:	eefc 7bc5 	vcvt.u32.f64	s15, d5
100077d0:	ee17 3a90 	vmov	r3, s15
100077d4:	0fdb      	lsrs	r3, r3, #31
100077d6:	ee07 3a90 	vmov	s15, r3
100077da:	ed8d 6b18 	vstr	d6, [sp, #96]	@ 0x60
100077de:	ee28 6b0b 	vmul.f64	d6, d8, d11
100077e2:	eeb8 fbe7 	vcvt.f64.s32	d15, s15
100077e6:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100077ea:	ee22 7b0b 	vmul.f64	d7, d2, d11
100077ee:	ed8d fb1a 	vstr	d15, [sp, #104]	@ 0x68
100077f2:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100077f6:	eeb0 fb42 	vmov.f64	d15, d2
100077fa:	ee33 2b0e 	vadd.f64	d2, d3, d14
100077fe:	ee06 8b4a 	vmls.f64	d8, d6, d10
10007802:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007806:	ee32 6b06 	vadd.f64	d6, d2, d6
1000780a:	eeb8 7b47 	vcvt.f64.u32	d7, s14
1000780e:	ed8d 6b08 	vstr	d6, [sp, #32]
10007812:	ee34 6b05 	vadd.f64	d6, d4, d5
10007816:	ed9f 1bc2 	vldr	d1, [pc, #776]	@ 10007b20 <fndsa_vect_mul_fft_fp64_exact+0x440>
1000781a:	ee07 fb4a 	vmls.f64	d15, d7, d10
1000781e:	ee36 7b07 	vadd.f64	d7, d6, d7
10007822:	ed8d 7b0a 	vstr	d7, [sp, #40]	@ 0x28
10007826:	ee23 7b01 	vmul.f64	d7, d3, d1
1000782a:	eefc 6bc7 	vcvt.u32.f64	s13, d7
1000782e:	ee24 7b01 	vmul.f64	d7, d4, d1
10007832:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10007836:	ed8d 8b00 	vstr	d8, [sp]
1000783a:	eeb8 8b67 	vcvt.f64.u32	d8, s15
1000783e:	ee2e 7b01 	vmul.f64	d7, d14, d1
10007842:	ee08 4b4d 	vmls.f64	d4, d8, d13
10007846:	eeb0 2b44 	vmov.f64	d2, d4
1000784a:	eefc 4bc7 	vcvt.u32.f64	s9, d7
1000784e:	ed8d fb02 	vstr	d15, [sp, #8]
10007852:	ee25 7b01 	vmul.f64	d7, d5, d1
10007856:	eeb8 fb66 	vcvt.f64.u32	d15, s13
1000785a:	eeb8 6b64 	vcvt.f64.u32	d6, s9
1000785e:	ed9d 4b2a 	vldr	d4, [sp, #168]	@ 0xa8
10007862:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10007866:	ee24 4b00 	vmul.f64	d4, d4, d0
1000786a:	eeb8 cb67 	vcvt.f64.u32	d12, s15
1000786e:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10007872:	ee0c 5b4d 	vmls.f64	d5, d12, d13
10007876:	eeb8 4b44 	vcvt.f64.u32	d4, s8
1000787a:	ed9d 7b32 	vldr	d7, [sp, #200]	@ 0xc8
1000787e:	ee0f 3b4d 	vmls.f64	d3, d15, d13
10007882:	ed9f 1ba9 	vldr	d1, [pc, #676]	@ 10007b28 <fndsa_vect_mul_fft_fp64_exact+0x448>
10007886:	ed8d 5b16 	vstr	d5, [sp, #88]	@ 0x58
1000788a:	ee27 7b00 	vmul.f64	d7, d7, d0
1000788e:	eeb0 5b44 	vmov.f64	d5, d4
10007892:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007896:	ee03 5b01 	vmla.f64	d5, d3, d1
1000789a:	ed9d 3b2a 	vldr	d3, [sp, #168]	@ 0xa8
1000789e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100078a2:	ee04 3b49 	vmls.f64	d3, d4, d9
100078a6:	ee06 eb4d 	vmls.f64	d14, d6, d13
100078aa:	ed8d 6b06 	vstr	d6, [sp, #24]
100078ae:	ed9d 4b32 	vldr	d4, [sp, #200]	@ 0xc8
100078b2:	eeb0 6b43 	vmov.f64	d6, d3
100078b6:	eeb0 3b47 	vmov.f64	d3, d7
100078ba:	ed8d eb14 	vstr	d14, [sp, #80]	@ 0x50
100078be:	ee02 3b01 	vmla.f64	d3, d2, d1
100078c2:	ee07 4b49 	vmls.f64	d4, d7, d9
100078c6:	ee26 7b04 	vmul.f64	d7, d6, d4
100078ca:	ee26 2b03 	vmul.f64	d2, d6, d3
100078ce:	ee26 1b08 	vmul.f64	d1, d6, d8
100078d2:	ee25 eb08 	vmul.f64	d14, d5, d8
100078d6:	ee05 2b04 	vmla.f64	d2, d5, d4
100078da:	ee05 1b03 	vmla.f64	d1, d5, d3
100078de:	ee0f eb03 	vmla.f64	d14, d15, d3
100078e2:	ee0f 1b04 	vmla.f64	d1, d15, d4
100078e6:	ed9d 3b2e 	vldr	d3, [sp, #184]	@ 0xb8
100078ea:	ee27 7b00 	vmul.f64	d7, d7, d0
100078ee:	ee23 6b00 	vmul.f64	d6, d3, d0
100078f2:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100078f6:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100078fa:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100078fe:	ed9d fb08 	vldr	d15, [sp, #32]
10007902:	ee37 3b02 	vadd.f64	d3, d7, d2
10007906:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000790a:	ed9d 4b36 	vldr	d4, [sp, #216]	@ 0xd8
1000790e:	ed9d 7b2e 	vldr	d7, [sp, #184]	@ 0xb8
10007912:	ee2f 8b0b 	vmul.f64	d8, d15, d11
10007916:	ee06 7b49 	vmls.f64	d7, d6, d9
1000791a:	ed8d 3b04 	vstr	d3, [sp, #16]
1000791e:	eeb0 3b46 	vmov.f64	d3, d6
10007922:	ee24 6b00 	vmul.f64	d6, d4, d0
10007926:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000792a:	eefc 6bc8 	vcvt.u32.f64	s13, d8
1000792e:	ed9d 5b14 	vldr	d5, [sp, #80]	@ 0x50
10007932:	ed9f 2b7d 	vldr	d2, [pc, #500]	@ 10007b28 <fndsa_vect_mul_fft_fp64_exact+0x448>
10007936:	ed8d eb0e 	vstr	d14, [sp, #56]	@ 0x38
1000793a:	ed8d 1b0c 	vstr	d1, [sp, #48]	@ 0x30
1000793e:	edcd 6a1c 	vstr	s13, [sp, #112]	@ 0x70
10007942:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10007946:	ee05 3b02 	vmla.f64	d3, d5, d2
1000794a:	eeb0 4b46 	vmov.f64	d4, d6
1000794e:	ed9d 5b16 	vldr	d5, [sp, #88]	@ 0x58
10007952:	ee05 4b02 	vmla.f64	d4, d5, d2
10007956:	ed9d 5b36 	vldr	d5, [sp, #216]	@ 0xd8
1000795a:	ed9d 8b06 	vldr	d8, [sp, #24]
1000795e:	ee06 5b49 	vmls.f64	d5, d6, d9
10007962:	ee27 6b05 	vmul.f64	d6, d7, d5
10007966:	ee27 2b04 	vmul.f64	d2, d7, d4
1000796a:	ee27 eb0c 	vmul.f64	d14, d7, d12
1000796e:	ee23 1b0c 	vmul.f64	d1, d3, d12
10007972:	ee03 2b05 	vmla.f64	d2, d3, d5
10007976:	ee03 eb04 	vmla.f64	d14, d3, d4
1000797a:	ee08 1b04 	vmla.f64	d1, d8, d4
1000797e:	ee08 eb05 	vmla.f64	d14, d8, d5
10007982:	ee26 6b00 	vmul.f64	d6, d6, d0
10007986:	eddd 7a1c 	vldr	s15, [sp, #112]	@ 0x70
1000798a:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000798e:	eeb8 8b67 	vcvt.f64.u32	d8, s15
10007992:	eeb0 3b4f 	vmov.f64	d3, d15
10007996:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000799a:	ee08 3b4a 	vmls.f64	d3, d8, d10
1000799e:	ee36 7b02 	vadd.f64	d7, d6, d2
100079a2:	ed8d 7b06 	vstr	d7, [sp, #24]
100079a6:	eefc 7bc3 	vcvt.u32.f64	s15, d3
100079aa:	ee17 3a90 	vmov	r3, s15
100079ae:	0fdb      	lsrs	r3, r3, #31
100079b0:	ed9d 4b0a 	vldr	d4, [sp, #40]	@ 0x28
100079b4:	ee07 3a90 	vmov	s15, r3
100079b8:	eeb8 6be7 	vcvt.f64.s32	d6, s15
100079bc:	ee24 7b0b 	vmul.f64	d7, d4, d11
100079c0:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100079c4:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100079c8:	ee07 4b4a 	vmls.f64	d4, d7, d10
100079cc:	eefc 7bc4 	vcvt.u32.f64	s15, d4
100079d0:	ee17 3a90 	vmov	r3, s15
100079d4:	0fdb      	lsrs	r3, r3, #31
100079d6:	ee07 3a90 	vmov	s15, r3
100079da:	ed9d 2b00 	vldr	d2, [sp]
100079de:	ed8d 6b16 	vstr	d6, [sp, #88]	@ 0x58
100079e2:	eeb8 7be7 	vcvt.f64.s32	d7, s15
100079e6:	ed9f 6b4e 	vldr	d6, [pc, #312]	@ 10007b20 <fndsa_vect_mul_fft_fp64_exact+0x440>
100079ea:	ed8d 7b1c 	vstr	d7, [sp, #112]	@ 0x70
100079ee:	ee23 5b06 	vmul.f64	d5, d3, d6
100079f2:	ee22 7b00 	vmul.f64	d7, d2, d0
100079f6:	eebc 5bc5 	vcvt.u32.f64	s10, d5
100079fa:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100079fe:	eeb8 8b45 	vcvt.f64.u32	d8, s10
10007a02:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007a06:	ed8d 1b14 	vstr	d1, [sp, #80]	@ 0x50
10007a0a:	ee08 3b4d 	vmls.f64	d3, d8, d13
10007a0e:	ed9f cb46 	vldr	d12, [pc, #280]	@ 10007b28 <fndsa_vect_mul_fft_fp64_exact+0x448>
10007a12:	eeb0 1b47 	vmov.f64	d1, d7
10007a16:	ed8d eb08 	vstr	d14, [sp, #32]
10007a1a:	ee03 1b0c 	vmla.f64	d1, d3, d12
10007a1e:	ed9d eb02 	vldr	d14, [sp, #8]
10007a22:	eeb0 3b42 	vmov.f64	d3, d2
10007a26:	ee24 5b06 	vmul.f64	d5, d4, d6
10007a2a:	ee07 3b49 	vmls.f64	d3, d7, d9
10007a2e:	ee2e 7b00 	vmul.f64	d7, d14, d0
10007a32:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10007a36:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007a3a:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10007a3e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007a42:	ee05 4b4d 	vmls.f64	d4, d5, d13
10007a46:	eeb0 fb47 	vmov.f64	d15, d7
10007a4a:	eeb0 2b43 	vmov.f64	d2, d3
10007a4e:	ee04 fb0c 	vmla.f64	d15, d4, d12
10007a52:	ed9d 3b04 	vldr	d3, [sp, #16]
10007a56:	eeb0 cb4f 	vmov.f64	d12, d15
10007a5a:	ee23 3b00 	vmul.f64	d3, d3, d0
10007a5e:	eeb0 4b4e 	vmov.f64	d4, d14
10007a62:	eeb0 fb42 	vmov.f64	d15, d2
10007a66:	ee07 4b49 	vmls.f64	d4, d7, d9
10007a6a:	eeb0 6b4c 	vmov.f64	d6, d12
10007a6e:	ee2f 7b04 	vmul.f64	d7, d15, d4
10007a72:	ee2f 2b06 	vmul.f64	d2, d15, d6
10007a76:	ee2f eb05 	vmul.f64	d14, d15, d5
10007a7a:	ee21 cb05 	vmul.f64	d12, d1, d5
10007a7e:	ee01 2b04 	vmla.f64	d2, d1, d4
10007a82:	ee01 eb06 	vmla.f64	d14, d1, d6
10007a86:	ee08 cb06 	vmla.f64	d12, d8, d6
10007a8a:	ee08 eb04 	vmla.f64	d14, d8, d4
10007a8e:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10007a92:	ee27 7b00 	vmul.f64	d7, d7, d0
10007a96:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10007a9a:	ed9d 8b0c 	vldr	d8, [sp, #48]	@ 0x30
10007a9e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007aa2:	ee38 5b03 	vadd.f64	d5, d8, d3
10007aa6:	ed9d fb04 	vldr	d15, [sp, #16]
10007aaa:	ed9d 6b06 	vldr	d6, [sp, #24]
10007aae:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007ab2:	ee03 fb49 	vmls.f64	d15, d3, d9
10007ab6:	ee37 7b02 	vadd.f64	d7, d7, d2
10007aba:	ee25 3b00 	vmul.f64	d3, d5, d0
10007abe:	ee26 2b00 	vmul.f64	d2, d6, d0
10007ac2:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10007ac6:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10007aca:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10007ace:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10007ad2:	eeb0 4b4f 	vmov.f64	d4, d15
10007ad6:	ed9d 8b08 	vldr	d8, [sp, #32]
10007ada:	ed9f fb0f 	vldr	d15, [pc, #60]	@ 10007b18 <fndsa_vect_mul_fft_fp64_exact+0x438>
10007ade:	ee38 8b02 	vadd.f64	d8, d8, d2
10007ae2:	ee24 4b0f 	vmul.f64	d4, d4, d15
10007ae6:	ee03 5b49 	vmls.f64	d5, d3, d9
10007aea:	ee02 6b49 	vmls.f64	d6, d2, d9
10007aee:	e023      	b.n	10007b38 <fndsa_vect_mul_fft_fp64_exact+0x458>
10007af0:	00000000 	.word	0x00000000
10007af4:	3e700000 	.word	0x3e700000
10007af8:	00000000 	.word	0x00000000
10007afc:	41700000 	.word	0x41700000
10007b00:	00000000 	.word	0x00000000
10007b04:	40f00000 	.word	0x40f00000
10007b08:	00000000 	.word	0x00000000
10007b0c:	3df00000 	.word	0x3df00000
10007b10:	00000000 	.word	0x00000000
10007b14:	41f00000 	.word	0x41f00000
10007b18:	00000000 	.word	0x00000000
10007b1c:	3f700000 	.word	0x3f700000
10007b20:	00000000 	.word	0x00000000
10007b24:	3ef00000 	.word	0x3ef00000
10007b28:	00000000 	.word	0x00000000
10007b2c:	40700000 	.word	0x40700000
10007b30:	00000000 	.word	0x00000000
10007b34:	42000000 	.word	0x42000000
10007b38:	ed8d cb0a 	vstr	d12, [sp, #40]	@ 0x28
10007b3c:	ee26 6b0f 	vmul.f64	d6, d6, d15
10007b40:	eeb0 cb45 	vmov.f64	d12, d5
10007b44:	ee27 fb00 	vmul.f64	d15, d7, d0
10007b48:	ee28 5b00 	vmul.f64	d5, d8, d0
10007b4c:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10007b50:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007b54:	eeb8 1b44 	vcvt.f64.u32	d1, s8
10007b58:	eefc 6bc5 	vcvt.u32.f64	s13, d5
10007b5c:	ed9d 4b0e 	vldr	d4, [sp, #56]	@ 0x38
10007b60:	eebc fbcf 	vcvt.u32.f64	s30, d15
10007b64:	ee34 2b03 	vadd.f64	d2, d4, d3
10007b68:	eeb8 fb4f 	vcvt.f64.u32	d15, s30
10007b6c:	eeb8 3b46 	vcvt.f64.u32	d3, s12
10007b70:	ed9d 4b14 	vldr	d4, [sp, #80]	@ 0x50
10007b74:	eeb8 6b66 	vcvt.f64.u32	d6, s13
10007b78:	ee0f 7b49 	vmls.f64	d7, d15, d9
10007b7c:	ee34 5b06 	vadd.f64	d5, d4, d6
10007b80:	ee3e 4b0f 	vadd.f64	d4, d14, d15
10007b84:	ed1f fb1c 	vldr	d15, [pc, #-112]	@ 10007b18 <fndsa_vect_mul_fft_fp64_exact+0x438>
10007b88:	ee27 7b0f 	vmul.f64	d7, d7, d15
10007b8c:	ee06 8b49 	vmls.f64	d8, d6, d9
10007b90:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007b94:	ee22 6b00 	vmul.f64	d6, d2, d0
10007b98:	eefc 7bc6 	vcvt.u32.f64	s15, d6
10007b9c:	eeb8 6b47 	vcvt.f64.u32	d6, s14
10007ba0:	ed8d 6b04 	vstr	d6, [sp, #16]
10007ba4:	ee25 6b00 	vmul.f64	d6, d5, d0
10007ba8:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10007bac:	eefc 6bc6 	vcvt.u32.f64	s13, d6
10007bb0:	ee07 2b49 	vmls.f64	d2, d7, d9
10007bb4:	eeb8 7b66 	vcvt.f64.u32	d7, s13
10007bb8:	eeb0 6b45 	vmov.f64	d6, d5
10007bbc:	ee07 6b49 	vmls.f64	d6, d7, d9
10007bc0:	ed1f 7b29 	vldr	d7, [pc, #-164]	@ 10007b20 <fndsa_vect_mul_fft_fp64_exact+0x440>
10007bc4:	eeb0 eb46 	vmov.f64	d14, d6
10007bc8:	ee2c 6b07 	vmul.f64	d6, d12, d7
10007bcc:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007bd0:	eeb0 5b4c 	vmov.f64	d5, d12
10007bd4:	ee28 7b07 	vmul.f64	d7, d8, d7
10007bd8:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10007bdc:	eefc cbc7 	vcvt.u32.f64	s25, d7
10007be0:	ee06 5b4d 	vmls.f64	d5, d6, d13
10007be4:	eeb0 7b46 	vmov.f64	d7, d6
10007be8:	ed1f fb31 	vldr	d15, [pc, #-196]	@ 10007b28 <fndsa_vect_mul_fft_fp64_exact+0x448>
10007bec:	ee05 1b0d 	vmla.f64	d1, d5, d13
10007bf0:	ee02 7b0f 	vmla.f64	d7, d2, d15
10007bf4:	ed1f 6b32 	vldr	d6, [pc, #-200]	@ 10007b30 <fndsa_vect_mul_fft_fp64_exact+0x450>
10007bf8:	eeb0 2b41 	vmov.f64	d2, d1
10007bfc:	ed9d 5b10 	vldr	d5, [sp, #64]	@ 0x40
10007c00:	ed9d 1b32 	vldr	d1, [sp, #200]	@ 0xc8
10007c04:	ee37 7b06 	vadd.f64	d7, d7, d6
10007c08:	eeb0 fb46 	vmov.f64	d15, d6
10007c0c:	ee05 7b41 	vmls.f64	d7, d5, d1
10007c10:	eeb8 6b6c 	vcvt.f64.u32	d6, s25
10007c14:	ed9d 5b12 	vldr	d5, [sp, #72]	@ 0x48
10007c18:	ed9d 1b2a 	vldr	d1, [sp, #168]	@ 0xa8
10007c1c:	ee06 8b4d 	vmls.f64	d8, d6, d13
10007c20:	ee05 7b41 	vmls.f64	d7, d5, d1
10007c24:	ed1f cb40 	vldr	d12, [pc, #-256]	@ 10007b28 <fndsa_vect_mul_fft_fp64_exact+0x448>
10007c28:	eeb0 5b46 	vmov.f64	d5, d6
10007c2c:	eeb0 1b43 	vmov.f64	d1, d3
10007c30:	ee0e 5b0c 	vmla.f64	d5, d14, d12
10007c34:	ee08 1b0d 	vmla.f64	d1, d8, d13
10007c38:	ee27 3b0b 	vmul.f64	d3, d7, d11
10007c3c:	eeb0 eb41 	vmov.f64	d14, d1
10007c40:	ed9d 8b36 	vldr	d8, [sp, #216]	@ 0xd8
10007c44:	ed9d 1b18 	vldr	d1, [sp, #96]	@ 0x60
10007c48:	ee24 6b00 	vmul.f64	d6, d4, d0
10007c4c:	ee35 5b0f 	vadd.f64	d5, d5, d15
10007c50:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10007c54:	ee01 5b48 	vmls.f64	d5, d1, d8
10007c58:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10007c5c:	ed9d 1b1a 	vldr	d1, [sp, #104]	@ 0x68
10007c60:	ed9d 8b2e 	vldr	d8, [sp, #184]	@ 0xb8
10007c64:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10007c68:	ee01 5b48 	vmls.f64	d5, d1, d8
10007c6c:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10007c70:	ee03 7b4a 	vmls.f64	d7, d3, d10
10007c74:	ed9d cb0a 	vldr	d12, [sp, #40]	@ 0x28
10007c78:	eeb0 8b45 	vmov.f64	d8, d5
10007c7c:	ee06 4b49 	vmls.f64	d4, d6, d9
10007c80:	ee3c 5b06 	vadd.f64	d5, d12, d6
10007c84:	eeb0 6b47 	vmov.f64	d6, d7
10007c88:	ed1f 7b5b 	vldr	d7, [pc, #-364]	@ 10007b20 <fndsa_vect_mul_fft_fp64_exact+0x440>
10007c8c:	ee25 3b00 	vmul.f64	d3, d5, d0
10007c90:	ee24 7b07 	vmul.f64	d7, d4, d7
10007c94:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10007c98:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007c9c:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10007ca0:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007ca4:	ee03 5b49 	vmls.f64	d5, d3, d9
10007ca8:	eeb0 1b47 	vmov.f64	d1, d7
10007cac:	ed1f 3b62 	vldr	d3, [pc, #-392]	@ 10007b28 <fndsa_vect_mul_fft_fp64_exact+0x448>
10007cb0:	ee07 4b4d 	vmls.f64	d4, d7, d13
10007cb4:	ee05 1b03 	vmla.f64	d1, d5, d3
10007cb8:	ed9d fb04 	vldr	d15, [sp, #16]
10007cbc:	ed1f 7b64 	vldr	d7, [pc, #-400]	@ 10007b30 <fndsa_vect_mul_fft_fp64_exact+0x450>
10007cc0:	ee04 fb0d 	vmla.f64	d15, d4, d13
10007cc4:	ee31 5b07 	vadd.f64	d5, d1, d7
10007cc8:	ed9d 7b16 	vldr	d7, [sp, #88]	@ 0x58
10007ccc:	ed9d 4b02 	vldr	d4, [sp, #8]
10007cd0:	ed9d 3b00 	vldr	d3, [sp]
10007cd4:	ee07 5b44 	vmls.f64	d5, d7, d4
10007cd8:	ed9d 7b1c 	vldr	d7, [sp, #112]	@ 0x70
10007cdc:	ee07 5b43 	vmls.f64	d5, d7, d3
10007ce0:	ee28 7b0b 	vmul.f64	d7, d8, d11
10007ce4:	ee32 3b0e 	vadd.f64	d3, d2, d14
10007ce8:	ee32 4b0a 	vadd.f64	d4, d2, d10
10007cec:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10007cf0:	ee23 2b0b 	vmul.f64	d2, d3, d11
10007cf4:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10007cf8:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10007cfc:	ee07 8b4a 	vmls.f64	d8, d7, d10
10007d00:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10007d04:	ee36 7b08 	vadd.f64	d7, d6, d8
10007d08:	ee02 3b4a 	vmls.f64	d3, d2, d10
10007d0c:	ee3f fb0a 	vadd.f64	d15, d15, d10
10007d10:	ee37 7b02 	vadd.f64	d7, d7, d2
10007d14:	ee3f 3b43 	vsub.f64	d3, d15, d3
10007d18:	ee25 2b0b 	vmul.f64	d2, d5, d11
10007d1c:	ee36 6b0a 	vadd.f64	d6, d6, d10
10007d20:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10007d24:	ee36 6b48 	vsub.f64	d6, d6, d8
10007d28:	ee23 8b0b 	vmul.f64	d8, d3, d11
10007d2c:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10007d30:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10007d34:	ee02 5b4a 	vmls.f64	d5, d2, d10
10007d38:	eeb8 2b48 	vcvt.f64.u32	d2, s16
10007d3c:	ee02 3b4a 	vmls.f64	d3, d2, d10
10007d40:	ed8d 3b26 	vstr	d3, [sp, #152]	@ 0x98
10007d44:	ee27 3b0b 	vmul.f64	d3, d7, d11
10007d48:	ee34 4b4e 	vsub.f64	d4, d4, d14
10007d4c:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10007d50:	ee24 8b0b 	vmul.f64	d8, d4, d11
10007d54:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10007d58:	eeb7 1b00 	vmov.f64	d1, #112	@ 0x3f800000  1.0
10007d5c:	ee35 5b0a 	vadd.f64	d5, d5, d10
10007d60:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10007d64:	ee03 7b4a 	vmls.f64	d7, d3, d10
10007d68:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10007d6c:	ee35 7b47 	vsub.f64	d7, d5, d7
10007d70:	ee36 6b41 	vsub.f64	d6, d6, d1
10007d74:	ee37 7b41 	vsub.f64	d7, d7, d1
10007d78:	ee36 6b08 	vadd.f64	d6, d6, d8
10007d7c:	ee08 4b4a 	vmls.f64	d4, d8, d10
10007d80:	ee26 5b0b 	vmul.f64	d5, d6, d11
10007d84:	ee37 7b02 	vadd.f64	d7, d7, d2
10007d88:	ed8d 4b22 	vstr	d4, [sp, #136]	@ 0x88
10007d8c:	eebc 4bc5 	vcvt.u32.f64	s8, d5
10007d90:	ee27 5b0b 	vmul.f64	d5, d7, d11
10007d94:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10007d98:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10007d9c:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10007da0:	ee04 6b4a 	vmls.f64	d6, d4, d10
10007da4:	ee05 7b4a 	vmls.f64	d7, d5, d10
10007da8:	ed8d 6b20 	vstr	d6, [sp, #128]	@ 0x80
10007dac:	ed8d 7b24 	vstr	d7, [sp, #144]	@ 0x90
10007db0:	ab20      	add	r3, sp, #128	@ 0x80
10007db2:	cb0f      	ldmia	r3, {r0, r1, r2, r3}
10007db4:	e885 000f 	stmia.w	r5, {r0, r1, r2, r3}
10007db8:	ab24      	add	r3, sp, #144	@ 0x90
10007dba:	cb0f      	ldmia	r3, {r0, r1, r2, r3}
10007dbc:	3710      	adds	r7, #16
10007dbe:	e884 000f 	stmia.w	r4, {r0, r1, r2, r3}
10007dc2:	f1be 0e01 	subs.w	lr, lr, #1
10007dc6:	f47f acb3 	bne.w	10007730 <fndsa_vect_mul_fft_fp64_exact+0x50>
10007dca:	b039      	add	sp, #228	@ 0xe4
10007dcc:	ecbd 8b10 	vpop	{d8-d15}
10007dd0:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
