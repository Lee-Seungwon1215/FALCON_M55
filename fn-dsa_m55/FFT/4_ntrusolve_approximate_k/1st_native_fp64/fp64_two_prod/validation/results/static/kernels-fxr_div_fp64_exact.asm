100015e8 <fxr_div_fp64_exact>:
100015e8:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
100015ec:	4607      	mov	r7, r0
100015ee:	f04f 0c00 	mov.w	ip, #0
100015f2:	ea4f 79d1 	mov.w	r9, r1, lsr #31
100015f6:	ea4f 78d3 	mov.w	r8, r3, lsr #31
100015fa:	ea82 74e3 	eor.w	r4, r2, r3, asr #31
100015fe:	ea83 75e3 	eor.w	r5, r3, r3, asr #31
10001602:	ea89 0308 	eor.w	r3, r9, r8
10001606:	b0a7      	sub	sp, #156	@ 0x9c
10001608:	425a      	negs	r2, r3
1000160a:	ea87 77e1 	eor.w	r7, r7, r1, asr #31
1000160e:	ea81 76e1 	eor.w	r6, r1, r1, asr #31
10001612:	9212      	str	r2, [sp, #72]	@ 0x48
10001614:	9213      	str	r2, [sp, #76]	@ 0x4c
10001616:	eb17 0209 	adds.w	r2, r7, r9
1000161a:	930b      	str	r3, [sp, #44]	@ 0x2c
1000161c:	f146 0300 	adc.w	r3, r6, #0
10001620:	eb14 0408 	adds.w	r4, r4, r8
10001624:	f145 0500 	adc.w	r5, r5, #0
10001628:	ea45 0604 	orr.w	r6, r5, r4
1000162c:	462f      	mov	r7, r5
1000162e:	ee07 5a90 	vmov	s15, r5
10001632:	4275      	negs	r5, r6
10001634:	4335      	orrs	r5, r6
10001636:	0fed      	lsrs	r5, r5, #31
10001638:	9517      	str	r5, [sp, #92]	@ 0x5c
1000163a:	9d17      	ldr	r5, [sp, #92]	@ 0x5c
1000163c:	ed9f 6bce 	vldr	d6, [pc, #824]	@ 10001978 <fxr_div_fp64_exact+0x390>
10001640:	f085 0501 	eor.w	r5, r5, #1
10001644:	f115 3aff 	adds.w	sl, r5, #4294967295	@ 0xffffffff
10001648:	f14c 38ff 	adc.w	r8, ip, #4294967295	@ 0xffffffff
1000164c:	ea08 0803 	and.w	r8, r8, r3
10001650:	ea0a 0602 	and.w	r6, sl, r2
10001654:	ee02 6a90 	vmov	s5, r6
10001658:	ee05 8a90 	vmov	s11, r8
1000165c:	eeb8 4b67 	vcvt.f64.u32	d4, s15
10001660:	eeb8 5b65 	vcvt.f64.u32	d5, s11
10001664:	eeb8 7b62 	vcvt.f64.u32	d7, s5
10001668:	ea44 0a05 	orr.w	sl, r4, r5
1000166c:	ee05 7b06 	vmla.f64	d7, d5, d6
10001670:	ee05 aa90 	vmov	s11, sl
10001674:	eeb8 5b65 	vcvt.f64.u32	d5, s11
10001678:	ee04 5b06 	vmla.f64	d5, d4, d6
1000167c:	950a      	str	r5, [sp, #40]	@ 0x28
1000167e:	2400      	movs	r4, #0
10001680:	2500      	movs	r5, #0
10001682:	ee86 4b05 	vdiv.f64	d4, d6, d5
10001686:	17de      	asrs	r6, r3, #31
10001688:	46bb      	mov	fp, r7
1000168a:	9611      	str	r6, [sp, #68]	@ 0x44
1000168c:	9709      	str	r7, [sp, #36]	@ 0x24
1000168e:	4626      	mov	r6, r4
10001690:	462f      	mov	r7, r5
10001692:	ed9f 3bbb 	vldr	d3, [pc, #748]	@ 10001980 <fxr_div_fp64_exact+0x398>
10001696:	ee27 7b04 	vmul.f64	d7, d7, d4
1000169a:	e9cd 6700 	strd	r6, r7, [sp]
1000169e:	e9cd 6704 	strd	r6, r7, [sp, #16]
100016a2:	e9cd 6706 	strd	r6, r7, [sp, #24]
100016a6:	4616      	mov	r6, r2
100016a8:	461f      	mov	r7, r3
100016aa:	ee27 7b03 	vmul.f64	d7, d7, d3
100016ae:	ea52 73df 	lsrl	r2, r3, #31
100016b2:	ea56 779f 	lsrl	r6, r7, #30
100016b6:	ed8d 7b02 	vstr	d7, [sp, #8]
100016ba:	43d7      	mvns	r7, r2
100016bc:	43f6      	mvns	r6, r6
100016be:	f8df e2d0 	ldr.w	lr, [pc, #720]	@ 10001990 <fxr_div_fp64_exact+0x3a8>
100016c2:	f00a 0101 	and.w	r1, sl, #1
100016c6:	48b0      	ldr	r0, [pc, #704]	@ (10001988 <fxr_div_fp64_exact+0x3a0>)
100016c8:	910f      	str	r1, [sp, #60]	@ 0x3c
100016ca:	49b0      	ldr	r1, [pc, #704]	@ (1000198c <fxr_div_fp64_exact+0x3a4>)
100016cc:	970e      	str	r7, [sp, #56]	@ 0x38
100016ce:	e9dd 9702 	ldrd	r9, r7, [sp, #8]
100016d2:	ebbe 0209 	subs.w	r2, lr, r9
100016d6:	eb61 0207 	sbc.w	r2, r1, r7
100016da:	f006 0301 	and.w	r3, r6, #1
100016de:	ea47 0600 	orr.w	r6, r7, r0
100016e2:	4032      	ands	r2, r6
100016e4:	ea07 0600 	and.w	r6, r7, r0
100016e8:	4332      	orrs	r2, r6
100016ea:	0fd2      	lsrs	r2, r2, #31
100016ec:	9216      	str	r2, [sp, #88]	@ 0x58
100016ee:	9a16      	ldr	r2, [sp, #88]	@ 0x58
100016f0:	9310      	str	r3, [sp, #64]	@ 0x40
100016f2:	4254      	negs	r4, r2
100016f4:	eb6c 050c 	sbc.w	r5, ip, ip
100016f8:	e9cd 4524 	strd	r4, r5, [sp, #144]	@ 0x90
100016fc:	e9dd 2324 	ldrd	r2, r3, [sp, #144]	@ 0x90
10001700:	ea89 050e 	eor.w	r5, r9, lr
10001704:	ea87 0401 	eor.w	r4, r7, r1
10001708:	4015      	ands	r5, r2
1000170a:	401c      	ands	r4, r3
1000170c:	ea85 0209 	eor.w	r2, r5, r9
10001710:	407c      	eors	r4, r7
10001712:	9200      	str	r2, [sp, #0]
10001714:	9401      	str	r4, [sp, #4]
10001716:	ed9d 7b00 	vldr	d7, [sp]
1000171a:	4654      	mov	r4, sl
1000171c:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10001720:	465d      	mov	r5, fp
10001722:	ee17 6a90 	vmov	r6, s15
10001726:	ea54 055f 	lsrl	r4, r5, #1
1000172a:	2200      	movs	r2, #0
1000172c:	2300      	movs	r3, #0
1000172e:	ee12 9a90 	vmov	r9, s5
10001732:	e9cd 450c 	strd	r4, r5, [sp, #48]	@ 0x30
10001736:	e9cd 2302 	strd	r2, r3, [sp, #8]
1000173a:	fba6 420a 	umull	r4, r2, r6, sl
1000173e:	ebb9 0304 	subs.w	r3, r9, r4
10001742:	46e1      	mov	r9, ip
10001744:	fbeb 2906 	umlal	r2, r9, fp, r6
10001748:	eb68 0602 	sbc.w	r6, r8, r2
1000174c:	ea62 0408 	orn	r4, r2, r8
10001750:	4034      	ands	r4, r6
10001752:	ea22 0208 	bic.w	r2, r2, r8
10001756:	4314      	orrs	r4, r2
10001758:	0fe4      	lsrs	r4, r4, #31
1000175a:	941c      	str	r4, [sp, #112]	@ 0x70
1000175c:	9a1c      	ldr	r2, [sp, #112]	@ 0x70
1000175e:	edcd 7a00 	vstr	s15, [sp]
10001762:	eb09 0802 	add.w	r8, r9, r2
10001766:	f1c8 0700 	rsb	r7, r8, #0
1000176a:	ea0a 74e7 	and.w	r4, sl, r7, asr #31
1000176e:	191b      	adds	r3, r3, r4
10001770:	ea0b 74e7 	and.w	r4, fp, r7, asr #31
10001774:	4621      	mov	r1, r4
10001776:	eb46 0504 	adc.w	r5, r6, r4
1000177a:	ebb3 040a 	subs.w	r4, r3, sl
1000177e:	ea66 0405 	orn	r4, r6, r5
10001782:	ea04 0401 	and.w	r4, r4, r1
10001786:	ea26 0605 	bic.w	r6, r6, r5
1000178a:	ea44 0406 	orr.w	r4, r4, r6
1000178e:	ee17 6a90 	vmov	r6, s15
10001792:	ea4f 74d4 	mov.w	r4, r4, lsr #31
10001796:	941d      	str	r4, [sp, #116]	@ 0x74
10001798:	9c1d      	ldr	r4, [sp, #116]	@ 0x74
1000179a:	497c      	ldr	r1, [pc, #496]	@ (1000198c <fxr_div_fp64_exact+0x3a4>)
1000179c:	eba2 0204 	sub.w	r2, r2, r4
100017a0:	444a      	add	r2, r9
100017a2:	eba4 0408 	sub.w	r4, r4, r8
100017a6:	ea42 0204 	orr.w	r2, r2, r4
100017aa:	ea4f 72d2 	mov.w	r2, r2, lsr #31
100017ae:	921e      	str	r2, [sp, #120]	@ 0x78
100017b0:	ea6b 0405 	orn	r4, fp, r5
100017b4:	eb65 020b 	sbc.w	r2, r5, fp
100017b8:	4022      	ands	r2, r4
100017ba:	ea2b 0405 	bic.w	r4, fp, r5
100017be:	4322      	orrs	r2, r4
100017c0:	0fd2      	lsrs	r2, r2, #31
100017c2:	9c1e      	ldr	r4, [sp, #120]	@ 0x78
100017c4:	921f      	str	r2, [sp, #124]	@ 0x7c
100017c6:	9a1f      	ldr	r2, [sp, #124]	@ 0x7c
100017c8:	f082 0201 	eor.w	r2, r2, #1
100017cc:	4322      	orrs	r2, r4
100017ce:	18b4      	adds	r4, r6, r2
100017d0:	4252      	negs	r2, r2
100017d2:	eba4 78d7 	sub.w	r8, r4, r7, lsr #31
100017d6:	ea02 020a 	and.w	r2, r2, sl
100017da:	eb6c 040c 	sbc.w	r4, ip, ip
100017de:	ea04 040b 	and.w	r4, r4, fp
100017e2:	1a9b      	subs	r3, r3, r2
100017e4:	eb65 0404 	sbc.w	r4, r5, r4
100017e8:	ee07 4a90 	vmov	s15, r4
100017ec:	eeb8 5b67 	vcvt.f64.u32	d5, s15
100017f0:	ee07 3a90 	vmov	s15, r3
100017f4:	eeb8 7b67 	vcvt.f64.u32	d7, s15
100017f8:	ee05 7b06 	vmla.f64	d7, d5, d6
100017fc:	ee27 7b04 	vmul.f64	d7, d7, d4
10001800:	ed8d 7b00 	vstr	d7, [sp]
10001804:	e9dd 5200 	ldrd	r5, r2, [sp]
10001808:	ebbe 0605 	subs.w	r6, lr, r5
1000180c:	eb61 0702 	sbc.w	r7, r1, r2
10001810:	ea82 0601 	eor.w	r6, r2, r1
10001814:	ea42 0100 	orr.w	r1, r2, r0
10001818:	4039      	ands	r1, r7
1000181a:	4010      	ands	r0, r2
1000181c:	4301      	orrs	r1, r0
1000181e:	0fc9      	lsrs	r1, r1, #31
10001820:	9115      	str	r1, [sp, #84]	@ 0x54
10001822:	9915      	ldr	r1, [sp, #84]	@ 0x54
10001824:	ea85 0e0e 	eor.w	lr, r5, lr
10001828:	4249      	negs	r1, r1
1000182a:	9104      	str	r1, [sp, #16]
1000182c:	eb6c 010c 	sbc.w	r1, ip, ip
10001830:	9105      	str	r1, [sp, #20]
10001832:	e9dd 0104 	ldrd	r0, r1, [sp, #16]
10001836:	e9cd 0122 	strd	r0, r1, [sp, #136]	@ 0x88
1000183a:	e9dd 0122 	ldrd	r0, r1, [sp, #136]	@ 0x88
1000183e:	ea0e 0e00 	and.w	lr, lr, r0
10001842:	4031      	ands	r1, r6
10001844:	404a      	eors	r2, r1
10001846:	ea8e 0605 	eor.w	r6, lr, r5
1000184a:	9606      	str	r6, [sp, #24]
1000184c:	9207      	str	r2, [sp, #28]
1000184e:	ed9d 7b06 	vldr	d7, [sp, #24]
10001852:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10001856:	ee17 9a90 	vmov	r9, s15
1000185a:	46e6      	mov	lr, ip
1000185c:	fba9 210a 	umull	r2, r1, r9, sl
10001860:	fbeb 1e09 	umlal	r1, lr, fp, r9
10001864:	4677      	mov	r7, lr
10001866:	ebbc 0202 	subs.w	r2, ip, r2
1000186a:	eb63 0601 	sbc.w	r6, r3, r1
1000186e:	ea61 0003 	orn	r0, r1, r3
10001872:	4030      	ands	r0, r6
10001874:	ea21 0103 	bic.w	r1, r1, r3
10001878:	4308      	orrs	r0, r1
1000187a:	0fc0      	lsrs	r0, r0, #31
1000187c:	9018      	str	r0, [sp, #96]	@ 0x60
1000187e:	9b18      	ldr	r3, [sp, #96]	@ 0x60
10001880:	1ae5      	subs	r5, r4, r3
10001882:	1bed      	subs	r5, r5, r7
10001884:	ea0a 71e5 	and.w	r1, sl, r5, asr #31
10001888:	ea0b 7ee5 	and.w	lr, fp, r5, asr #31
1000188c:	1852      	adds	r2, r2, r1
1000188e:	eb46 000e 	adc.w	r0, r6, lr
10001892:	ebb2 010a 	subs.w	r1, r2, sl
10001896:	ea66 0100 	orn	r1, r6, r0
1000189a:	ea01 010e 	and.w	r1, r1, lr
1000189e:	ea26 0600 	bic.w	r6, r6, r0
100018a2:	ea41 0106 	orr.w	r1, r1, r6
100018a6:	ea4f 71d1 	mov.w	r1, r1, lsr #31
100018aa:	9119      	str	r1, [sp, #100]	@ 0x64
100018ac:	9919      	ldr	r1, [sp, #100]	@ 0x64
100018ae:	eba3 0301 	sub.w	r3, r3, r1
100018b2:	eba3 0304 	sub.w	r3, r3, r4
100018b6:	4429      	add	r1, r5
100018b8:	443b      	add	r3, r7
100018ba:	ea43 0301 	orr.w	r3, r3, r1
100018be:	ea4f 73d3 	mov.w	r3, r3, lsr #31
100018c2:	931a      	str	r3, [sp, #104]	@ 0x68
100018c4:	ea6b 0100 	orn	r1, fp, r0
100018c8:	eb60 030b 	sbc.w	r3, r0, fp
100018cc:	400b      	ands	r3, r1
100018ce:	ea2b 0100 	bic.w	r1, fp, r0
100018d2:	430b      	orrs	r3, r1
100018d4:	0fdb      	lsrs	r3, r3, #31
100018d6:	991a      	ldr	r1, [sp, #104]	@ 0x68
100018d8:	931b      	str	r3, [sp, #108]	@ 0x6c
100018da:	9b1b      	ldr	r3, [sp, #108]	@ 0x6c
100018dc:	f083 0301 	eor.w	r3, r3, #1
100018e0:	430b      	orrs	r3, r1
100018e2:	4499      	add	r9, r3
100018e4:	425b      	negs	r3, r3
100018e6:	eb6c 010c 	sbc.w	r1, ip, ip
100018ea:	ea03 030a 	and.w	r3, r3, sl
100018ee:	1ad3      	subs	r3, r2, r3
100018f0:	ea01 010b 	and.w	r1, r1, fp
100018f4:	eb60 0101 	sbc.w	r1, r0, r1
100018f8:	980f      	ldr	r0, [sp, #60]	@ 0x3c
100018fa:	e9dd ab0c 	ldrd	sl, fp, [sp, #48]	@ 0x30
100018fe:	eb1a 0000 	adds.w	r0, sl, r0
10001902:	f14b 0200 	adc.w	r2, fp, #0
10001906:	1a18      	subs	r0, r3, r0
10001908:	eb61 0302 	sbc.w	r3, r1, r2
1000190c:	ea62 0001 	orn	r0, r2, r1
10001910:	4003      	ands	r3, r0
10001912:	ea22 0201 	bic.w	r2, r2, r1
10001916:	4313      	orrs	r3, r2
10001918:	0fdb      	lsrs	r3, r3, #31
1000191a:	9314      	str	r3, [sp, #80]	@ 0x50
1000191c:	9b14      	ldr	r3, [sp, #80]	@ 0x50
1000191e:	eba9 79d5 	sub.w	r9, r9, r5, lsr #31
10001922:	f083 0301 	eor.w	r3, r3, #1
10001926:	9d0a      	ldr	r5, [sp, #40]	@ 0x28
10001928:	eb13 0309 	adds.w	r3, r3, r9
1000192c:	f148 0200 	adc.w	r2, r8, #0
10001930:	4269      	negs	r1, r5
10001932:	9102      	str	r1, [sp, #8]
10001934:	eb6c 010c 	sbc.w	r1, ip, ip
10001938:	9103      	str	r1, [sp, #12]
1000193a:	9f0e      	ldr	r7, [sp, #56]	@ 0x38
1000193c:	9810      	ldr	r0, [sp, #64]	@ 0x40
1000193e:	9e11      	ldr	r6, [sp, #68]	@ 0x44
10001940:	19c0      	adds	r0, r0, r7
10001942:	9c12      	ldr	r4, [sp, #72]	@ 0x48
10001944:	9d13      	ldr	r5, [sp, #76]	@ 0x4c
10001946:	f166 0100 	sbc.w	r1, r6, #0
1000194a:	4058      	eors	r0, r3
1000194c:	e9dd 8902 	ldrd	r8, r9, [sp, #8]
10001950:	e9cd 8920 	strd	r8, r9, [sp, #128]	@ 0x80
10001954:	e9dd 6720 	ldrd	r6, r7, [sp, #128]	@ 0x80
10001958:	405c      	eors	r4, r3
1000195a:	4051      	eors	r1, r2
1000195c:	ea85 0302 	eor.w	r3, r5, r2
10001960:	4030      	ands	r0, r6
10001962:	9a0b      	ldr	r2, [sp, #44]	@ 0x2c
10001964:	4039      	ands	r1, r7
10001966:	4060      	eors	r0, r4
10001968:	1880      	adds	r0, r0, r2
1000196a:	ea81 0103 	eor.w	r1, r1, r3
1000196e:	f141 0100 	adc.w	r1, r1, #0
10001972:	b027      	add	sp, #156	@ 0x9c
10001974:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10001978:	00000000 	.word	0x00000000
1000197c:	41f00000 	.word	0x41f00000
10001980:	00000000 	.word	0x00000000
10001984:	3df00000 	.word	0x3df00000
10001988:	be100000 	.word	0xbe100000
1000198c:	41efffff 	.word	0x41efffff
10001990:	ffe00000 	.word	0xffe00000
10001994:	00000000 	.word	0x00000000

