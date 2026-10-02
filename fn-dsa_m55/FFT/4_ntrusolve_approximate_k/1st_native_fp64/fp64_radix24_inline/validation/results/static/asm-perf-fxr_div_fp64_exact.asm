
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/asm-perf/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10006640 <fxr_div_fp64_exact>:
10006640:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10006644:	4607      	mov	r7, r0
10006646:	f04f 0c00 	mov.w	ip, #0
1000664a:	ea4f 79d1 	mov.w	r9, r1, lsr #31
1000664e:	ea4f 78d3 	mov.w	r8, r3, lsr #31
10006652:	ea82 74e3 	eor.w	r4, r2, r3, asr #31
10006656:	ea83 75e3 	eor.w	r5, r3, r3, asr #31
1000665a:	ea89 0308 	eor.w	r3, r9, r8
1000665e:	b0a7      	sub	sp, #156	@ 0x9c
10006660:	425a      	negs	r2, r3
10006662:	ea87 77e1 	eor.w	r7, r7, r1, asr #31
10006666:	ea81 76e1 	eor.w	r6, r1, r1, asr #31
1000666a:	9212      	str	r2, [sp, #72]	@ 0x48
1000666c:	9213      	str	r2, [sp, #76]	@ 0x4c
1000666e:	eb17 0209 	adds.w	r2, r7, r9
10006672:	930b      	str	r3, [sp, #44]	@ 0x2c
10006674:	f146 0300 	adc.w	r3, r6, #0
10006678:	eb14 0408 	adds.w	r4, r4, r8
1000667c:	f145 0500 	adc.w	r5, r5, #0
10006680:	ea45 0604 	orr.w	r6, r5, r4
10006684:	462f      	mov	r7, r5
10006686:	ee07 5a90 	vmov	s15, r5
1000668a:	4275      	negs	r5, r6
1000668c:	4335      	orrs	r5, r6
1000668e:	0fed      	lsrs	r5, r5, #31
10006690:	9517      	str	r5, [sp, #92]	@ 0x5c
10006692:	9d17      	ldr	r5, [sp, #92]	@ 0x5c
10006694:	ed9f 6bce 	vldr	d6, [pc, #824]	@ 100069d0 <fxr_div_fp64_exact+0x390>
10006698:	f085 0501 	eor.w	r5, r5, #1
1000669c:	f115 3aff 	adds.w	sl, r5, #4294967295	@ 0xffffffff
100066a0:	f14c 38ff 	adc.w	r8, ip, #4294967295	@ 0xffffffff
100066a4:	ea08 0803 	and.w	r8, r8, r3
100066a8:	ea0a 0602 	and.w	r6, sl, r2
100066ac:	ee02 6a90 	vmov	s5, r6
100066b0:	ee05 8a90 	vmov	s11, r8
100066b4:	eeb8 4b67 	vcvt.f64.u32	d4, s15
100066b8:	eeb8 5b65 	vcvt.f64.u32	d5, s11
100066bc:	eeb8 7b62 	vcvt.f64.u32	d7, s5
100066c0:	ea44 0a05 	orr.w	sl, r4, r5
100066c4:	ee05 7b06 	vmla.f64	d7, d5, d6
100066c8:	ee05 aa90 	vmov	s11, sl
100066cc:	eeb8 5b65 	vcvt.f64.u32	d5, s11
100066d0:	ee04 5b06 	vmla.f64	d5, d4, d6
100066d4:	950a      	str	r5, [sp, #40]	@ 0x28
100066d6:	2400      	movs	r4, #0
100066d8:	2500      	movs	r5, #0
100066da:	ee86 4b05 	vdiv.f64	d4, d6, d5
100066de:	17de      	asrs	r6, r3, #31
100066e0:	46bb      	mov	fp, r7
100066e2:	9611      	str	r6, [sp, #68]	@ 0x44
100066e4:	9709      	str	r7, [sp, #36]	@ 0x24
100066e6:	4626      	mov	r6, r4
100066e8:	462f      	mov	r7, r5
100066ea:	ed9f 3bbb 	vldr	d3, [pc, #748]	@ 100069d8 <fxr_div_fp64_exact+0x398>
100066ee:	ee27 7b04 	vmul.f64	d7, d7, d4
100066f2:	e9cd 6700 	strd	r6, r7, [sp]
100066f6:	e9cd 6704 	strd	r6, r7, [sp, #16]
100066fa:	e9cd 6706 	strd	r6, r7, [sp, #24]
100066fe:	4616      	mov	r6, r2
10006700:	461f      	mov	r7, r3
10006702:	ee27 7b03 	vmul.f64	d7, d7, d3
10006706:	ea52 73df 	lsrl	r2, r3, #31
1000670a:	ea56 779f 	lsrl	r6, r7, #30
1000670e:	ed8d 7b02 	vstr	d7, [sp, #8]
10006712:	43d7      	mvns	r7, r2
10006714:	43f6      	mvns	r6, r6
10006716:	f8df e2d0 	ldr.w	lr, [pc, #720]	@ 100069e8 <fxr_div_fp64_exact+0x3a8>
1000671a:	f00a 0101 	and.w	r1, sl, #1
1000671e:	48b0      	ldr	r0, [pc, #704]	@ (100069e0 <fxr_div_fp64_exact+0x3a0>)
10006720:	910f      	str	r1, [sp, #60]	@ 0x3c
10006722:	49b0      	ldr	r1, [pc, #704]	@ (100069e4 <fxr_div_fp64_exact+0x3a4>)
10006724:	970e      	str	r7, [sp, #56]	@ 0x38
10006726:	e9dd 9702 	ldrd	r9, r7, [sp, #8]
1000672a:	ebbe 0209 	subs.w	r2, lr, r9
1000672e:	eb61 0207 	sbc.w	r2, r1, r7
10006732:	f006 0301 	and.w	r3, r6, #1
10006736:	ea47 0600 	orr.w	r6, r7, r0
1000673a:	4032      	ands	r2, r6
1000673c:	ea07 0600 	and.w	r6, r7, r0
10006740:	4332      	orrs	r2, r6
10006742:	0fd2      	lsrs	r2, r2, #31
10006744:	9216      	str	r2, [sp, #88]	@ 0x58
10006746:	9a16      	ldr	r2, [sp, #88]	@ 0x58
10006748:	9310      	str	r3, [sp, #64]	@ 0x40
1000674a:	4254      	negs	r4, r2
1000674c:	eb6c 050c 	sbc.w	r5, ip, ip
10006750:	e9cd 4524 	strd	r4, r5, [sp, #144]	@ 0x90
10006754:	e9dd 2324 	ldrd	r2, r3, [sp, #144]	@ 0x90
10006758:	ea89 050e 	eor.w	r5, r9, lr
1000675c:	ea87 0401 	eor.w	r4, r7, r1
10006760:	4015      	ands	r5, r2
10006762:	401c      	ands	r4, r3
10006764:	ea85 0209 	eor.w	r2, r5, r9
10006768:	407c      	eors	r4, r7
1000676a:	9200      	str	r2, [sp, #0]
1000676c:	9401      	str	r4, [sp, #4]
1000676e:	ed9d 7b00 	vldr	d7, [sp]
10006772:	4654      	mov	r4, sl
10006774:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10006778:	465d      	mov	r5, fp
1000677a:	ee17 6a90 	vmov	r6, s15
1000677e:	ea54 055f 	lsrl	r4, r5, #1
10006782:	2200      	movs	r2, #0
10006784:	2300      	movs	r3, #0
10006786:	ee12 9a90 	vmov	r9, s5
1000678a:	e9cd 450c 	strd	r4, r5, [sp, #48]	@ 0x30
1000678e:	e9cd 2302 	strd	r2, r3, [sp, #8]
10006792:	fba6 420a 	umull	r4, r2, r6, sl
10006796:	ebb9 0304 	subs.w	r3, r9, r4
1000679a:	46e1      	mov	r9, ip
1000679c:	fbeb 2906 	umlal	r2, r9, fp, r6
100067a0:	eb68 0602 	sbc.w	r6, r8, r2
100067a4:	ea62 0408 	orn	r4, r2, r8
100067a8:	4034      	ands	r4, r6
100067aa:	ea22 0208 	bic.w	r2, r2, r8
100067ae:	4314      	orrs	r4, r2
100067b0:	0fe4      	lsrs	r4, r4, #31
100067b2:	941c      	str	r4, [sp, #112]	@ 0x70
100067b4:	9a1c      	ldr	r2, [sp, #112]	@ 0x70
100067b6:	edcd 7a00 	vstr	s15, [sp]
100067ba:	eb09 0802 	add.w	r8, r9, r2
100067be:	f1c8 0700 	rsb	r7, r8, #0
100067c2:	ea0a 74e7 	and.w	r4, sl, r7, asr #31
100067c6:	191b      	adds	r3, r3, r4
100067c8:	ea0b 74e7 	and.w	r4, fp, r7, asr #31
100067cc:	4621      	mov	r1, r4
100067ce:	eb46 0504 	adc.w	r5, r6, r4
100067d2:	ebb3 040a 	subs.w	r4, r3, sl
100067d6:	ea66 0405 	orn	r4, r6, r5
100067da:	ea04 0401 	and.w	r4, r4, r1
100067de:	ea26 0605 	bic.w	r6, r6, r5
100067e2:	ea44 0406 	orr.w	r4, r4, r6
100067e6:	ee17 6a90 	vmov	r6, s15
100067ea:	ea4f 74d4 	mov.w	r4, r4, lsr #31
100067ee:	941d      	str	r4, [sp, #116]	@ 0x74
100067f0:	9c1d      	ldr	r4, [sp, #116]	@ 0x74
100067f2:	497c      	ldr	r1, [pc, #496]	@ (100069e4 <fxr_div_fp64_exact+0x3a4>)
100067f4:	eba2 0204 	sub.w	r2, r2, r4
100067f8:	444a      	add	r2, r9
100067fa:	eba4 0408 	sub.w	r4, r4, r8
100067fe:	ea42 0204 	orr.w	r2, r2, r4
10006802:	ea4f 72d2 	mov.w	r2, r2, lsr #31
10006806:	921e      	str	r2, [sp, #120]	@ 0x78
10006808:	ea6b 0405 	orn	r4, fp, r5
1000680c:	eb65 020b 	sbc.w	r2, r5, fp
10006810:	4022      	ands	r2, r4
10006812:	ea2b 0405 	bic.w	r4, fp, r5
10006816:	4322      	orrs	r2, r4
10006818:	0fd2      	lsrs	r2, r2, #31
1000681a:	9c1e      	ldr	r4, [sp, #120]	@ 0x78
1000681c:	921f      	str	r2, [sp, #124]	@ 0x7c
1000681e:	9a1f      	ldr	r2, [sp, #124]	@ 0x7c
10006820:	f082 0201 	eor.w	r2, r2, #1
10006824:	4322      	orrs	r2, r4
10006826:	18b4      	adds	r4, r6, r2
10006828:	4252      	negs	r2, r2
1000682a:	eba4 78d7 	sub.w	r8, r4, r7, lsr #31
1000682e:	ea02 020a 	and.w	r2, r2, sl
10006832:	eb6c 040c 	sbc.w	r4, ip, ip
10006836:	ea04 040b 	and.w	r4, r4, fp
1000683a:	1a9b      	subs	r3, r3, r2
1000683c:	eb65 0404 	sbc.w	r4, r5, r4
10006840:	ee07 4a90 	vmov	s15, r4
10006844:	eeb8 5b67 	vcvt.f64.u32	d5, s15
10006848:	ee07 3a90 	vmov	s15, r3
1000684c:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10006850:	ee05 7b06 	vmla.f64	d7, d5, d6
10006854:	ee27 7b04 	vmul.f64	d7, d7, d4
10006858:	ed8d 7b00 	vstr	d7, [sp]
1000685c:	e9dd 5200 	ldrd	r5, r2, [sp]
10006860:	ebbe 0605 	subs.w	r6, lr, r5
10006864:	eb61 0702 	sbc.w	r7, r1, r2
10006868:	ea82 0601 	eor.w	r6, r2, r1
1000686c:	ea42 0100 	orr.w	r1, r2, r0
10006870:	4039      	ands	r1, r7
10006872:	4010      	ands	r0, r2
10006874:	4301      	orrs	r1, r0
10006876:	0fc9      	lsrs	r1, r1, #31
10006878:	9115      	str	r1, [sp, #84]	@ 0x54
1000687a:	9915      	ldr	r1, [sp, #84]	@ 0x54
1000687c:	ea85 0e0e 	eor.w	lr, r5, lr
10006880:	4249      	negs	r1, r1
10006882:	9104      	str	r1, [sp, #16]
10006884:	eb6c 010c 	sbc.w	r1, ip, ip
10006888:	9105      	str	r1, [sp, #20]
1000688a:	e9dd 0104 	ldrd	r0, r1, [sp, #16]
1000688e:	e9cd 0122 	strd	r0, r1, [sp, #136]	@ 0x88
10006892:	e9dd 0122 	ldrd	r0, r1, [sp, #136]	@ 0x88
10006896:	ea0e 0e00 	and.w	lr, lr, r0
1000689a:	4031      	ands	r1, r6
1000689c:	404a      	eors	r2, r1
1000689e:	ea8e 0605 	eor.w	r6, lr, r5
100068a2:	9606      	str	r6, [sp, #24]
100068a4:	9207      	str	r2, [sp, #28]
100068a6:	ed9d 7b06 	vldr	d7, [sp, #24]
100068aa:	eefc 7bc7 	vcvt.u32.f64	s15, d7
100068ae:	ee17 9a90 	vmov	r9, s15
100068b2:	46e6      	mov	lr, ip
100068b4:	fba9 210a 	umull	r2, r1, r9, sl
100068b8:	fbeb 1e09 	umlal	r1, lr, fp, r9
100068bc:	4677      	mov	r7, lr
100068be:	ebbc 0202 	subs.w	r2, ip, r2
100068c2:	eb63 0601 	sbc.w	r6, r3, r1
100068c6:	ea61 0003 	orn	r0, r1, r3
100068ca:	4030      	ands	r0, r6
100068cc:	ea21 0103 	bic.w	r1, r1, r3
100068d0:	4308      	orrs	r0, r1
100068d2:	0fc0      	lsrs	r0, r0, #31
100068d4:	9018      	str	r0, [sp, #96]	@ 0x60
100068d6:	9b18      	ldr	r3, [sp, #96]	@ 0x60
100068d8:	1ae5      	subs	r5, r4, r3
100068da:	1bed      	subs	r5, r5, r7
100068dc:	ea0a 71e5 	and.w	r1, sl, r5, asr #31
100068e0:	ea0b 7ee5 	and.w	lr, fp, r5, asr #31
100068e4:	1852      	adds	r2, r2, r1
100068e6:	eb46 000e 	adc.w	r0, r6, lr
100068ea:	ebb2 010a 	subs.w	r1, r2, sl
100068ee:	ea66 0100 	orn	r1, r6, r0
100068f2:	ea01 010e 	and.w	r1, r1, lr
100068f6:	ea26 0600 	bic.w	r6, r6, r0
100068fa:	ea41 0106 	orr.w	r1, r1, r6
100068fe:	ea4f 71d1 	mov.w	r1, r1, lsr #31
10006902:	9119      	str	r1, [sp, #100]	@ 0x64
10006904:	9919      	ldr	r1, [sp, #100]	@ 0x64
10006906:	eba3 0301 	sub.w	r3, r3, r1
1000690a:	eba3 0304 	sub.w	r3, r3, r4
1000690e:	4429      	add	r1, r5
10006910:	443b      	add	r3, r7
10006912:	ea43 0301 	orr.w	r3, r3, r1
10006916:	ea4f 73d3 	mov.w	r3, r3, lsr #31
1000691a:	931a      	str	r3, [sp, #104]	@ 0x68
1000691c:	ea6b 0100 	orn	r1, fp, r0
10006920:	eb60 030b 	sbc.w	r3, r0, fp
10006924:	400b      	ands	r3, r1
10006926:	ea2b 0100 	bic.w	r1, fp, r0
1000692a:	430b      	orrs	r3, r1
1000692c:	0fdb      	lsrs	r3, r3, #31
1000692e:	991a      	ldr	r1, [sp, #104]	@ 0x68
10006930:	931b      	str	r3, [sp, #108]	@ 0x6c
10006932:	9b1b      	ldr	r3, [sp, #108]	@ 0x6c
10006934:	f083 0301 	eor.w	r3, r3, #1
10006938:	430b      	orrs	r3, r1
1000693a:	4499      	add	r9, r3
1000693c:	425b      	negs	r3, r3
1000693e:	eb6c 010c 	sbc.w	r1, ip, ip
10006942:	ea03 030a 	and.w	r3, r3, sl
10006946:	1ad3      	subs	r3, r2, r3
10006948:	ea01 010b 	and.w	r1, r1, fp
1000694c:	eb60 0101 	sbc.w	r1, r0, r1
10006950:	980f      	ldr	r0, [sp, #60]	@ 0x3c
10006952:	e9dd ab0c 	ldrd	sl, fp, [sp, #48]	@ 0x30
10006956:	eb1a 0000 	adds.w	r0, sl, r0
1000695a:	f14b 0200 	adc.w	r2, fp, #0
1000695e:	1a18      	subs	r0, r3, r0
10006960:	eb61 0302 	sbc.w	r3, r1, r2
10006964:	ea62 0001 	orn	r0, r2, r1
10006968:	4003      	ands	r3, r0
1000696a:	ea22 0201 	bic.w	r2, r2, r1
1000696e:	4313      	orrs	r3, r2
10006970:	0fdb      	lsrs	r3, r3, #31
10006972:	9314      	str	r3, [sp, #80]	@ 0x50
10006974:	9b14      	ldr	r3, [sp, #80]	@ 0x50
10006976:	eba9 79d5 	sub.w	r9, r9, r5, lsr #31
1000697a:	f083 0301 	eor.w	r3, r3, #1
1000697e:	9d0a      	ldr	r5, [sp, #40]	@ 0x28
10006980:	eb13 0309 	adds.w	r3, r3, r9
10006984:	f148 0200 	adc.w	r2, r8, #0
10006988:	4269      	negs	r1, r5
1000698a:	9102      	str	r1, [sp, #8]
1000698c:	eb6c 010c 	sbc.w	r1, ip, ip
10006990:	9103      	str	r1, [sp, #12]
10006992:	9f0e      	ldr	r7, [sp, #56]	@ 0x38
10006994:	9810      	ldr	r0, [sp, #64]	@ 0x40
10006996:	9e11      	ldr	r6, [sp, #68]	@ 0x44
10006998:	19c0      	adds	r0, r0, r7
1000699a:	9c12      	ldr	r4, [sp, #72]	@ 0x48
1000699c:	9d13      	ldr	r5, [sp, #76]	@ 0x4c
1000699e:	f166 0100 	sbc.w	r1, r6, #0
100069a2:	4058      	eors	r0, r3
100069a4:	e9dd 8902 	ldrd	r8, r9, [sp, #8]
100069a8:	e9cd 8920 	strd	r8, r9, [sp, #128]	@ 0x80
100069ac:	e9dd 6720 	ldrd	r6, r7, [sp, #128]	@ 0x80
100069b0:	405c      	eors	r4, r3
100069b2:	4051      	eors	r1, r2
100069b4:	ea85 0302 	eor.w	r3, r5, r2
100069b8:	4030      	ands	r0, r6
100069ba:	9a0b      	ldr	r2, [sp, #44]	@ 0x2c
100069bc:	4039      	ands	r1, r7
100069be:	4060      	eors	r0, r4
100069c0:	1880      	adds	r0, r0, r2
100069c2:	ea81 0103 	eor.w	r1, r1, r3
100069c6:	f141 0100 	adc.w	r1, r1, #0
100069ca:	b027      	add	sp, #156	@ 0x9c
100069cc:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
100069d0:	00000000 	.word	0x00000000
100069d4:	41f00000 	.word	0x41f00000
100069d8:	00000000 	.word	0x00000000
100069dc:	3df00000 	.word	0x3df00000
100069e0:	be100000 	.word	0xbe100000
100069e4:	41efffff 	.word	0x41efffff
100069e8:	ffe00000 	.word	0xffe00000
