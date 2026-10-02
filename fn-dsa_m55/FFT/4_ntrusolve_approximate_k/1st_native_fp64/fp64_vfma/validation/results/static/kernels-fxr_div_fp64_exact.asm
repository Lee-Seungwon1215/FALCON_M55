10001790 <fxr_div_fp64_exact>:
10001790:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10001794:	4607      	mov	r7, r0
10001796:	f04f 0c00 	mov.w	ip, #0
1000179a:	ea4f 79d1 	mov.w	r9, r1, lsr #31
1000179e:	ea4f 78d3 	mov.w	r8, r3, lsr #31
100017a2:	ea82 74e3 	eor.w	r4, r2, r3, asr #31
100017a6:	ea83 75e3 	eor.w	r5, r3, r3, asr #31
100017aa:	ea89 0308 	eor.w	r3, r9, r8
100017ae:	b0a7      	sub	sp, #156	@ 0x9c
100017b0:	425a      	negs	r2, r3
100017b2:	ea87 77e1 	eor.w	r7, r7, r1, asr #31
100017b6:	ea81 76e1 	eor.w	r6, r1, r1, asr #31
100017ba:	9212      	str	r2, [sp, #72]	@ 0x48
100017bc:	9213      	str	r2, [sp, #76]	@ 0x4c
100017be:	eb17 0209 	adds.w	r2, r7, r9
100017c2:	930b      	str	r3, [sp, #44]	@ 0x2c
100017c4:	f146 0300 	adc.w	r3, r6, #0
100017c8:	eb14 0408 	adds.w	r4, r4, r8
100017cc:	f145 0500 	adc.w	r5, r5, #0
100017d0:	ea45 0604 	orr.w	r6, r5, r4
100017d4:	462f      	mov	r7, r5
100017d6:	ee07 5a90 	vmov	s15, r5
100017da:	4275      	negs	r5, r6
100017dc:	4335      	orrs	r5, r6
100017de:	0fed      	lsrs	r5, r5, #31
100017e0:	9517      	str	r5, [sp, #92]	@ 0x5c
100017e2:	9d17      	ldr	r5, [sp, #92]	@ 0x5c
100017e4:	ed9f 6bce 	vldr	d6, [pc, #824]	@ 10001b20 <fxr_div_fp64_exact+0x390>
100017e8:	f085 0501 	eor.w	r5, r5, #1
100017ec:	f115 3aff 	adds.w	sl, r5, #4294967295	@ 0xffffffff
100017f0:	f14c 38ff 	adc.w	r8, ip, #4294967295	@ 0xffffffff
100017f4:	ea08 0803 	and.w	r8, r8, r3
100017f8:	ea0a 0602 	and.w	r6, sl, r2
100017fc:	ee02 6a90 	vmov	s5, r6
10001800:	ee05 8a90 	vmov	s11, r8
10001804:	eeb8 4b67 	vcvt.f64.u32	d4, s15
10001808:	eeb8 5b65 	vcvt.f64.u32	d5, s11
1000180c:	eeb8 7b62 	vcvt.f64.u32	d7, s5
10001810:	ea44 0a05 	orr.w	sl, r4, r5
10001814:	ee05 7b06 	vmla.f64	d7, d5, d6
10001818:	ee05 aa90 	vmov	s11, sl
1000181c:	eeb8 5b65 	vcvt.f64.u32	d5, s11
10001820:	ee04 5b06 	vmla.f64	d5, d4, d6
10001824:	950a      	str	r5, [sp, #40]	@ 0x28
10001826:	2400      	movs	r4, #0
10001828:	2500      	movs	r5, #0
1000182a:	ee86 4b05 	vdiv.f64	d4, d6, d5
1000182e:	17de      	asrs	r6, r3, #31
10001830:	46bb      	mov	fp, r7
10001832:	9611      	str	r6, [sp, #68]	@ 0x44
10001834:	9709      	str	r7, [sp, #36]	@ 0x24
10001836:	4626      	mov	r6, r4
10001838:	462f      	mov	r7, r5
1000183a:	ed9f 3bbb 	vldr	d3, [pc, #748]	@ 10001b28 <fxr_div_fp64_exact+0x398>
1000183e:	ee27 7b04 	vmul.f64	d7, d7, d4
10001842:	e9cd 6700 	strd	r6, r7, [sp]
10001846:	e9cd 6704 	strd	r6, r7, [sp, #16]
1000184a:	e9cd 6706 	strd	r6, r7, [sp, #24]
1000184e:	4616      	mov	r6, r2
10001850:	461f      	mov	r7, r3
10001852:	ee27 7b03 	vmul.f64	d7, d7, d3
10001856:	ea52 73df 	lsrl	r2, r3, #31
1000185a:	ea56 779f 	lsrl	r6, r7, #30
1000185e:	ed8d 7b02 	vstr	d7, [sp, #8]
10001862:	43d7      	mvns	r7, r2
10001864:	43f6      	mvns	r6, r6
10001866:	f8df e2d0 	ldr.w	lr, [pc, #720]	@ 10001b38 <fxr_div_fp64_exact+0x3a8>
1000186a:	f00a 0101 	and.w	r1, sl, #1
1000186e:	48b0      	ldr	r0, [pc, #704]	@ (10001b30 <fxr_div_fp64_exact+0x3a0>)
10001870:	910f      	str	r1, [sp, #60]	@ 0x3c
10001872:	49b0      	ldr	r1, [pc, #704]	@ (10001b34 <fxr_div_fp64_exact+0x3a4>)
10001874:	970e      	str	r7, [sp, #56]	@ 0x38
10001876:	e9dd 9702 	ldrd	r9, r7, [sp, #8]
1000187a:	ebbe 0209 	subs.w	r2, lr, r9
1000187e:	eb61 0207 	sbc.w	r2, r1, r7
10001882:	f006 0301 	and.w	r3, r6, #1
10001886:	ea47 0600 	orr.w	r6, r7, r0
1000188a:	4032      	ands	r2, r6
1000188c:	ea07 0600 	and.w	r6, r7, r0
10001890:	4332      	orrs	r2, r6
10001892:	0fd2      	lsrs	r2, r2, #31
10001894:	9216      	str	r2, [sp, #88]	@ 0x58
10001896:	9a16      	ldr	r2, [sp, #88]	@ 0x58
10001898:	9310      	str	r3, [sp, #64]	@ 0x40
1000189a:	4254      	negs	r4, r2
1000189c:	eb6c 050c 	sbc.w	r5, ip, ip
100018a0:	e9cd 4524 	strd	r4, r5, [sp, #144]	@ 0x90
100018a4:	e9dd 2324 	ldrd	r2, r3, [sp, #144]	@ 0x90
100018a8:	ea89 050e 	eor.w	r5, r9, lr
100018ac:	ea87 0401 	eor.w	r4, r7, r1
100018b0:	4015      	ands	r5, r2
100018b2:	401c      	ands	r4, r3
100018b4:	ea85 0209 	eor.w	r2, r5, r9
100018b8:	407c      	eors	r4, r7
100018ba:	9200      	str	r2, [sp, #0]
100018bc:	9401      	str	r4, [sp, #4]
100018be:	ed9d 7b00 	vldr	d7, [sp]
100018c2:	4654      	mov	r4, sl
100018c4:	eefc 7bc7 	vcvt.u32.f64	s15, d7
100018c8:	465d      	mov	r5, fp
100018ca:	ee17 6a90 	vmov	r6, s15
100018ce:	ea54 055f 	lsrl	r4, r5, #1
100018d2:	2200      	movs	r2, #0
100018d4:	2300      	movs	r3, #0
100018d6:	ee12 9a90 	vmov	r9, s5
100018da:	e9cd 450c 	strd	r4, r5, [sp, #48]	@ 0x30
100018de:	e9cd 2302 	strd	r2, r3, [sp, #8]
100018e2:	fba6 420a 	umull	r4, r2, r6, sl
100018e6:	ebb9 0304 	subs.w	r3, r9, r4
100018ea:	46e1      	mov	r9, ip
100018ec:	fbeb 2906 	umlal	r2, r9, fp, r6
100018f0:	eb68 0602 	sbc.w	r6, r8, r2
100018f4:	ea62 0408 	orn	r4, r2, r8
100018f8:	4034      	ands	r4, r6
100018fa:	ea22 0208 	bic.w	r2, r2, r8
100018fe:	4314      	orrs	r4, r2
10001900:	0fe4      	lsrs	r4, r4, #31
10001902:	941c      	str	r4, [sp, #112]	@ 0x70
10001904:	9a1c      	ldr	r2, [sp, #112]	@ 0x70
10001906:	edcd 7a00 	vstr	s15, [sp]
1000190a:	eb09 0802 	add.w	r8, r9, r2
1000190e:	f1c8 0700 	rsb	r7, r8, #0
10001912:	ea0a 74e7 	and.w	r4, sl, r7, asr #31
10001916:	191b      	adds	r3, r3, r4
10001918:	ea0b 74e7 	and.w	r4, fp, r7, asr #31
1000191c:	4621      	mov	r1, r4
1000191e:	eb46 0504 	adc.w	r5, r6, r4
10001922:	ebb3 040a 	subs.w	r4, r3, sl
10001926:	ea66 0405 	orn	r4, r6, r5
1000192a:	ea04 0401 	and.w	r4, r4, r1
1000192e:	ea26 0605 	bic.w	r6, r6, r5
10001932:	ea44 0406 	orr.w	r4, r4, r6
10001936:	ee17 6a90 	vmov	r6, s15
1000193a:	ea4f 74d4 	mov.w	r4, r4, lsr #31
1000193e:	941d      	str	r4, [sp, #116]	@ 0x74
10001940:	9c1d      	ldr	r4, [sp, #116]	@ 0x74
10001942:	497c      	ldr	r1, [pc, #496]	@ (10001b34 <fxr_div_fp64_exact+0x3a4>)
10001944:	eba2 0204 	sub.w	r2, r2, r4
10001948:	444a      	add	r2, r9
1000194a:	eba4 0408 	sub.w	r4, r4, r8
1000194e:	ea42 0204 	orr.w	r2, r2, r4
10001952:	ea4f 72d2 	mov.w	r2, r2, lsr #31
10001956:	921e      	str	r2, [sp, #120]	@ 0x78
10001958:	ea6b 0405 	orn	r4, fp, r5
1000195c:	eb65 020b 	sbc.w	r2, r5, fp
10001960:	4022      	ands	r2, r4
10001962:	ea2b 0405 	bic.w	r4, fp, r5
10001966:	4322      	orrs	r2, r4
10001968:	0fd2      	lsrs	r2, r2, #31
1000196a:	9c1e      	ldr	r4, [sp, #120]	@ 0x78
1000196c:	921f      	str	r2, [sp, #124]	@ 0x7c
1000196e:	9a1f      	ldr	r2, [sp, #124]	@ 0x7c
10001970:	f082 0201 	eor.w	r2, r2, #1
10001974:	4322      	orrs	r2, r4
10001976:	18b4      	adds	r4, r6, r2
10001978:	4252      	negs	r2, r2
1000197a:	eba4 78d7 	sub.w	r8, r4, r7, lsr #31
1000197e:	ea02 020a 	and.w	r2, r2, sl
10001982:	eb6c 040c 	sbc.w	r4, ip, ip
10001986:	ea04 040b 	and.w	r4, r4, fp
1000198a:	1a9b      	subs	r3, r3, r2
1000198c:	eb65 0404 	sbc.w	r4, r5, r4
10001990:	ee07 4a90 	vmov	s15, r4
10001994:	eeb8 5b67 	vcvt.f64.u32	d5, s15
10001998:	ee07 3a90 	vmov	s15, r3
1000199c:	eeb8 7b67 	vcvt.f64.u32	d7, s15
100019a0:	ee05 7b06 	vmla.f64	d7, d5, d6
100019a4:	ee27 7b04 	vmul.f64	d7, d7, d4
100019a8:	ed8d 7b00 	vstr	d7, [sp]
100019ac:	e9dd 5200 	ldrd	r5, r2, [sp]
100019b0:	ebbe 0605 	subs.w	r6, lr, r5
100019b4:	eb61 0702 	sbc.w	r7, r1, r2
100019b8:	ea82 0601 	eor.w	r6, r2, r1
100019bc:	ea42 0100 	orr.w	r1, r2, r0
100019c0:	4039      	ands	r1, r7
100019c2:	4010      	ands	r0, r2
100019c4:	4301      	orrs	r1, r0
100019c6:	0fc9      	lsrs	r1, r1, #31
100019c8:	9115      	str	r1, [sp, #84]	@ 0x54
100019ca:	9915      	ldr	r1, [sp, #84]	@ 0x54
100019cc:	ea85 0e0e 	eor.w	lr, r5, lr
100019d0:	4249      	negs	r1, r1
100019d2:	9104      	str	r1, [sp, #16]
100019d4:	eb6c 010c 	sbc.w	r1, ip, ip
100019d8:	9105      	str	r1, [sp, #20]
100019da:	e9dd 0104 	ldrd	r0, r1, [sp, #16]
100019de:	e9cd 0122 	strd	r0, r1, [sp, #136]	@ 0x88
100019e2:	e9dd 0122 	ldrd	r0, r1, [sp, #136]	@ 0x88
100019e6:	ea0e 0e00 	and.w	lr, lr, r0
100019ea:	4031      	ands	r1, r6
100019ec:	404a      	eors	r2, r1
100019ee:	ea8e 0605 	eor.w	r6, lr, r5
100019f2:	9606      	str	r6, [sp, #24]
100019f4:	9207      	str	r2, [sp, #28]
100019f6:	ed9d 7b06 	vldr	d7, [sp, #24]
100019fa:	eefc 7bc7 	vcvt.u32.f64	s15, d7
100019fe:	ee17 9a90 	vmov	r9, s15
10001a02:	46e6      	mov	lr, ip
10001a04:	fba9 210a 	umull	r2, r1, r9, sl
10001a08:	fbeb 1e09 	umlal	r1, lr, fp, r9
10001a0c:	4677      	mov	r7, lr
10001a0e:	ebbc 0202 	subs.w	r2, ip, r2
10001a12:	eb63 0601 	sbc.w	r6, r3, r1
10001a16:	ea61 0003 	orn	r0, r1, r3
10001a1a:	4030      	ands	r0, r6
10001a1c:	ea21 0103 	bic.w	r1, r1, r3
10001a20:	4308      	orrs	r0, r1
10001a22:	0fc0      	lsrs	r0, r0, #31
10001a24:	9018      	str	r0, [sp, #96]	@ 0x60
10001a26:	9b18      	ldr	r3, [sp, #96]	@ 0x60
10001a28:	1ae5      	subs	r5, r4, r3
10001a2a:	1bed      	subs	r5, r5, r7
10001a2c:	ea0a 71e5 	and.w	r1, sl, r5, asr #31
10001a30:	ea0b 7ee5 	and.w	lr, fp, r5, asr #31
10001a34:	1852      	adds	r2, r2, r1
10001a36:	eb46 000e 	adc.w	r0, r6, lr
10001a3a:	ebb2 010a 	subs.w	r1, r2, sl
10001a3e:	ea66 0100 	orn	r1, r6, r0
10001a42:	ea01 010e 	and.w	r1, r1, lr
10001a46:	ea26 0600 	bic.w	r6, r6, r0
10001a4a:	ea41 0106 	orr.w	r1, r1, r6
10001a4e:	ea4f 71d1 	mov.w	r1, r1, lsr #31
10001a52:	9119      	str	r1, [sp, #100]	@ 0x64
10001a54:	9919      	ldr	r1, [sp, #100]	@ 0x64
10001a56:	eba3 0301 	sub.w	r3, r3, r1
10001a5a:	eba3 0304 	sub.w	r3, r3, r4
10001a5e:	4429      	add	r1, r5
10001a60:	443b      	add	r3, r7
10001a62:	ea43 0301 	orr.w	r3, r3, r1
10001a66:	ea4f 73d3 	mov.w	r3, r3, lsr #31
10001a6a:	931a      	str	r3, [sp, #104]	@ 0x68
10001a6c:	ea6b 0100 	orn	r1, fp, r0
10001a70:	eb60 030b 	sbc.w	r3, r0, fp
10001a74:	400b      	ands	r3, r1
10001a76:	ea2b 0100 	bic.w	r1, fp, r0
10001a7a:	430b      	orrs	r3, r1
10001a7c:	0fdb      	lsrs	r3, r3, #31
10001a7e:	991a      	ldr	r1, [sp, #104]	@ 0x68
10001a80:	931b      	str	r3, [sp, #108]	@ 0x6c
10001a82:	9b1b      	ldr	r3, [sp, #108]	@ 0x6c
10001a84:	f083 0301 	eor.w	r3, r3, #1
10001a88:	430b      	orrs	r3, r1
10001a8a:	4499      	add	r9, r3
10001a8c:	425b      	negs	r3, r3
10001a8e:	eb6c 010c 	sbc.w	r1, ip, ip
10001a92:	ea03 030a 	and.w	r3, r3, sl
10001a96:	1ad3      	subs	r3, r2, r3
10001a98:	ea01 010b 	and.w	r1, r1, fp
10001a9c:	eb60 0101 	sbc.w	r1, r0, r1
10001aa0:	980f      	ldr	r0, [sp, #60]	@ 0x3c
10001aa2:	e9dd ab0c 	ldrd	sl, fp, [sp, #48]	@ 0x30
10001aa6:	eb1a 0000 	adds.w	r0, sl, r0
10001aaa:	f14b 0200 	adc.w	r2, fp, #0
10001aae:	1a18      	subs	r0, r3, r0
10001ab0:	eb61 0302 	sbc.w	r3, r1, r2
10001ab4:	ea62 0001 	orn	r0, r2, r1
10001ab8:	4003      	ands	r3, r0
10001aba:	ea22 0201 	bic.w	r2, r2, r1
10001abe:	4313      	orrs	r3, r2
10001ac0:	0fdb      	lsrs	r3, r3, #31
10001ac2:	9314      	str	r3, [sp, #80]	@ 0x50
10001ac4:	9b14      	ldr	r3, [sp, #80]	@ 0x50
10001ac6:	eba9 79d5 	sub.w	r9, r9, r5, lsr #31
10001aca:	f083 0301 	eor.w	r3, r3, #1
10001ace:	9d0a      	ldr	r5, [sp, #40]	@ 0x28
10001ad0:	eb13 0309 	adds.w	r3, r3, r9
10001ad4:	f148 0200 	adc.w	r2, r8, #0
10001ad8:	4269      	negs	r1, r5
10001ada:	9102      	str	r1, [sp, #8]
10001adc:	eb6c 010c 	sbc.w	r1, ip, ip
10001ae0:	9103      	str	r1, [sp, #12]
10001ae2:	9f0e      	ldr	r7, [sp, #56]	@ 0x38
10001ae4:	9810      	ldr	r0, [sp, #64]	@ 0x40
10001ae6:	9e11      	ldr	r6, [sp, #68]	@ 0x44
10001ae8:	19c0      	adds	r0, r0, r7
10001aea:	9c12      	ldr	r4, [sp, #72]	@ 0x48
10001aec:	9d13      	ldr	r5, [sp, #76]	@ 0x4c
10001aee:	f166 0100 	sbc.w	r1, r6, #0
10001af2:	4058      	eors	r0, r3
10001af4:	e9dd 8902 	ldrd	r8, r9, [sp, #8]
10001af8:	e9cd 8920 	strd	r8, r9, [sp, #128]	@ 0x80
10001afc:	e9dd 6720 	ldrd	r6, r7, [sp, #128]	@ 0x80
10001b00:	405c      	eors	r4, r3
10001b02:	4051      	eors	r1, r2
10001b04:	ea85 0302 	eor.w	r3, r5, r2
10001b08:	4030      	ands	r0, r6
10001b0a:	9a0b      	ldr	r2, [sp, #44]	@ 0x2c
10001b0c:	4039      	ands	r1, r7
10001b0e:	4060      	eors	r0, r4
10001b10:	1880      	adds	r0, r0, r2
10001b12:	ea81 0103 	eor.w	r1, r1, r3
10001b16:	f141 0100 	adc.w	r1, r1, #0
10001b1a:	b027      	add	sp, #156	@ 0x9c
10001b1c:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10001b20:	00000000 	.word	0x00000000
10001b24:	41f00000 	.word	0x41f00000
10001b28:	00000000 	.word	0x00000000
10001b2c:	3df00000 	.word	0x3df00000
10001b30:	be100000 	.word	0xbe100000
10001b34:	41efffff 	.word	0x41efffff
10001b38:	ffe00000 	.word	0xffe00000
10001b3c:	00000000 	.word	0x00000000

