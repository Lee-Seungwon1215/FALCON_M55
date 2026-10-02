10001618 <fndsa_vect_FFT_fp64_exact>:
10001618:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
1000161c:	2301      	movs	r3, #1
1000161e:	ed2d 8b10 	vpush	{d8-d15}
10001622:	f100 3aff 	add.w	sl, r0, #4294967295	@ 0xffffffff
10001626:	2802      	cmp	r0, #2
10001628:	4604      	mov	r4, r0
1000162a:	460e      	mov	r6, r1
1000162c:	b0df      	sub	sp, #380	@ 0x17c
1000162e:	fa03 f80a 	lsl.w	r8, r3, sl
10001632:	f200 857e 	bhi.w	10002132 <fndsa_vect_FFT_fp64_exact+0xb1a>
10001636:	bf08      	it	eq
10001638:	4686      	moveq	lr, r0
1000163a:	f040 8575 	bne.w	10002128 <fndsa_vect_FFT_fp64_exact+0xb10>
1000163e:	2010      	movs	r0, #16
10001640:	9417      	str	r4, [sp, #92]	@ 0x5c
10001642:	ed9f 9bbf 	vldr	d9, [pc, #764]	@ 10001940 <fndsa_vect_FFT_fp64_exact+0x328>
10001646:	ed9f 8bc0 	vldr	d8, [pc, #768]	@ 10001948 <fndsa_vect_FFT_fp64_exact+0x330>
1000164a:	2401      	movs	r4, #1
1000164c:	46c4      	mov	ip, r8
1000164e:	f8cd 8058 	str.w	r8, [sp, #88]	@ 0x58
10001652:	f8df 82fc 	ldr.w	r8, [pc, #764]	@ 10001950 <fndsa_vect_FFT_fp64_exact+0x338>
10001656:	af18      	add	r7, sp, #96	@ 0x60
10001658:	fa00 fb0a 	lsl.w	fp, r0, sl
1000165c:	f8cd a050 	str.w	sl, [sp, #80]	@ 0x50
10001660:	f8cd e048 	str.w	lr, [sp, #72]	@ 0x48
10001664:	2301      	movs	r3, #1
10001666:	f04f 0a10 	mov.w	sl, #16
1000166a:	4662      	mov	r2, ip
1000166c:	40a3      	lsls	r3, r4
1000166e:	eb03 0353 	add.w	r3, r3, r3, lsr #1
10001672:	eb08 1303 	add.w	r3, r8, r3, lsl #4
10001676:	ea4f 0c5c 	mov.w	ip, ip, lsr #1
1000167a:	fa0a fa04 	lsl.w	sl, sl, r4
1000167e:	930a      	str	r3, [sp, #40]	@ 0x28
10001680:	eb06 190c 	add.w	r9, r6, ip, lsl #4
10001684:	4633      	mov	r3, r6
10001686:	eb0a 0008 	add.w	r0, sl, r8
1000168a:	9610      	str	r6, [sp, #64]	@ 0x40
1000168c:	46da      	mov	sl, fp
1000168e:	eeb7 eb00 	vmov.f64	d14, #112	@ 0x3f800000  1.0
10001692:	f04f 0b00 	mov.w	fp, #0
10001696:	4616      	mov	r6, r2
10001698:	f8cd c020 	str.w	ip, [sp, #32]
1000169c:	940c      	str	r4, [sp, #48]	@ 0x30
1000169e:	f8cd 8038 	str.w	r8, [sp, #56]	@ 0x38
100016a2:	edd0 7a00 	vldr	s15, [r0]
100016a6:	eeb8 1b67 	vcvt.f64.u32	d1, s15
100016aa:	edd0 7a02 	vldr	s15, [r0, #8]
100016ae:	eeb8 4b67 	vcvt.f64.u32	d4, s15
100016b2:	edd0 7a01 	vldr	s15, [r0, #4]
100016b6:	eeb8 2b67 	vcvt.f64.u32	d2, s15
100016ba:	edd0 7a03 	vldr	s15, [r0, #12]
100016be:	6842      	ldr	r2, [r0, #4]
100016c0:	eeb8 3b67 	vcvt.f64.u32	d3, s15
100016c4:	0fd2      	lsrs	r2, r2, #31
100016c6:	ee06 2a10 	vmov	s12, r2
100016ca:	ee17 2a90 	vmov	r2, s15
100016ce:	0fd2      	lsrs	r2, r2, #31
100016d0:	ee07 2a10 	vmov	s14, r2
100016d4:	ee31 5b04 	vadd.f64	d5, d1, d4
100016d8:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
100016dc:	ed8d 7b52 	vstr	d7, [sp, #328]	@ 0x148
100016e0:	ee25 7b09 	vmul.f64	d7, d5, d9
100016e4:	eebc 7bc7 	vcvt.u32.f64	s14, d7
100016e8:	ee32 cb03 	vadd.f64	d12, d2, d3
100016ec:	eeb8 7b47 	vcvt.f64.u32	d7, s14
100016f0:	ee3c cb07 	vadd.f64	d12, d12, d7
100016f4:	ee07 5b48 	vmls.f64	d5, d7, d8
100016f8:	ee2c 7b09 	vmul.f64	d7, d12, d9
100016fc:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10001700:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10001704:	ee07 cb48 	vmls.f64	d12, d7, d8
10001708:	eebc 7bcc 	vcvt.u32.f64	s14, d12
1000170c:	9a08      	ldr	r2, [sp, #32]
1000170e:	eeb8 6bc6 	vcvt.f64.s32	d6, s12
10001712:	eb02 010b 	add.w	r1, r2, fp
10001716:	ee17 2a10 	vmov	r2, s14
1000171a:	0fd2      	lsrs	r2, r2, #31
1000171c:	ed8d 6b48 	vstr	d6, [sp, #288]	@ 0x120
10001720:	ee07 2a10 	vmov	s14, r2
10001724:	ee25 6b09 	vmul.f64	d6, d5, d9
10001728:	ee21 0b09 	vmul.f64	d0, d1, d9
1000172c:	ed8d 1b42 	vstr	d1, [sp, #264]	@ 0x108
10001730:	ee22 ab09 	vmul.f64	d10, d2, d9
10001734:	ee24 1b09 	vmul.f64	d1, d4, d9
10001738:	ee23 bb09 	vmul.f64	d11, d3, d9
1000173c:	ed8d 6b5a 	vstr	d6, [sp, #360]	@ 0x168
10001740:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10001744:	ee2c 6b09 	vmul.f64	d6, d12, d9
10001748:	458b      	cmp	fp, r1
1000174a:	ed8d 2b40 	vstr	d2, [sp, #256]	@ 0x100
1000174e:	ed8d 3b4a 	vstr	d3, [sp, #296]	@ 0x128
10001752:	ed8d 4b4c 	vstr	d4, [sp, #304]	@ 0x130
10001756:	ed8d 0b46 	vstr	d0, [sp, #280]	@ 0x118
1000175a:	ed8d 1b50 	vstr	d1, [sp, #320]	@ 0x140
1000175e:	ed8d ab44 	vstr	d10, [sp, #272]	@ 0x110
10001762:	ed8d bb4e 	vstr	d11, [sp, #312]	@ 0x138
10001766:	ed8d 5b56 	vstr	d5, [sp, #344]	@ 0x158
1000176a:	ed8d cb54 	vstr	d12, [sp, #336]	@ 0x150
1000176e:	ed8d 6b58 	vstr	d6, [sp, #352]	@ 0x160
10001772:	ed8d 7b5c 	vstr	d7, [sp, #368]	@ 0x170
10001776:	f080 80ae 	bcs.w	100018d6 <fndsa_vect_FFT_fp64_exact+0x2be>
1000177a:	4649      	mov	r1, r9
1000177c:	461c      	mov	r4, r3
1000177e:	4680      	mov	r8, r0
10001780:	9604      	str	r6, [sp, #16]
10001782:	eb0a 0509 	add.w	r5, sl, r9
10001786:	9306      	str	r3, [sp, #24]
10001788:	eb0a 0603 	add.w	r6, sl, r3
1000178c:	ed91 0b00 	vldr	d0, [r1]
10001790:	ed95 2b00 	vldr	d2, [r5]
10001794:	ed95 3b02 	vldr	d3, [r5, #8]
10001798:	ed91 1b02 	vldr	d1, [r1, #8]
1000179c:	a840      	add	r0, sp, #256	@ 0x100
1000179e:	f7ff f8c3 	bl	10000928 <fp64e_cmul_prepared>
100017a2:	ed94 db02 	vldr	d13, [r4, #8]
100017a6:	ed96 ab00 	vldr	d10, [r6]
100017aa:	ed96 cb02 	vldr	d12, [r6, #8]
100017ae:	ed94 bb00 	vldr	d11, [r4]
100017b2:	ee3d 7b01 	vadd.f64	d7, d13, d1
100017b6:	ee3c 6b03 	vadd.f64	d6, d12, d3
100017ba:	ee3d 5b08 	vadd.f64	d5, d13, d8
100017be:	ee3a db02 	vadd.f64	d13, d10, d2
100017c2:	ee3a ab08 	vadd.f64	d10, d10, d8
100017c6:	ee3b fb00 	vadd.f64	d15, d11, d0
100017ca:	ee3a ab42 	vsub.f64	d10, d10, d2
100017ce:	ee26 4b09 	vmul.f64	d4, d6, d9
100017d2:	ee3c cb08 	vadd.f64	d12, d12, d8
100017d6:	ee3b bb08 	vadd.f64	d11, d11, d8
100017da:	ed87 1b02 	vstr	d1, [r7, #8]
100017de:	ee35 1b41 	vsub.f64	d1, d5, d1
100017e2:	ee27 5b09 	vmul.f64	d5, d7, d9
100017e6:	ee3b bb40 	vsub.f64	d11, d11, d0
100017ea:	ed87 0b00 	vstr	d0, [r7]
100017ee:	ed87 2b04 	vstr	d2, [r7, #16]
100017f2:	eebc 0bc4 	vcvt.u32.f64	s0, d4
100017f6:	ee3c 2b43 	vsub.f64	d2, d12, d3
100017fa:	ed87 3b06 	vstr	d3, [r7, #24]
100017fe:	ee3a 3b4e 	vsub.f64	d3, d10, d14
10001802:	eebc abc5 	vcvt.u32.f64	s20, d5
10001806:	ee22 cb09 	vmul.f64	d12, d2, d9
1000180a:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
1000180e:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10001812:	ed8d 3b02 	vstr	d3, [sp, #8]
10001816:	ee21 3b09 	vmul.f64	d3, d1, d9
1000181a:	ee3b 5b4e 	vsub.f64	d5, d11, d14
1000181e:	ee0a 7b48 	vmls.f64	d7, d10, d8
10001822:	ee00 6b48 	vmls.f64	d6, d0, d8
10001826:	eebc cbcc 	vcvt.u32.f64	s24, d12
1000182a:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000182e:	ed8d 5b00 	vstr	d5, [sp]
10001832:	eeb8 4b4c 	vcvt.f64.u32	d4, s24
10001836:	ee3d bb00 	vadd.f64	d11, d13, d0
1000183a:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000183e:	eeb0 cb47 	vmov.f64	d12, d7
10001842:	eeb0 db46 	vmov.f64	d13, d6
10001846:	ed9d 7b00 	vldr	d7, [sp]
1000184a:	ed9d 6b02 	vldr	d6, [sp, #8]
1000184e:	ee3f 5b0a 	vadd.f64	d5, d15, d10
10001852:	ee37 7b03 	vadd.f64	d7, d7, d3
10001856:	ee36 6b04 	vadd.f64	d6, d6, d4
1000185a:	ee25 0b09 	vmul.f64	d0, d5, d9
1000185e:	ee2b ab09 	vmul.f64	d10, d11, d9
10001862:	ee03 1b48 	vmls.f64	d1, d3, d8
10001866:	ee04 2b48 	vmls.f64	d2, d4, d8
1000186a:	ee27 3b09 	vmul.f64	d3, d7, d9
1000186e:	ee26 4b09 	vmul.f64	d4, d6, d9
10001872:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10001876:	eebc abca 	vcvt.u32.f64	s20, d10
1000187a:	eebc 3bc3 	vcvt.u32.f64	s6, d3
1000187e:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10001882:	eeb8 0b40 	vcvt.f64.u32	d0, s0
10001886:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
1000188a:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000188e:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10001892:	ee00 5b48 	vmls.f64	d5, d0, d8
10001896:	ee0a bb48 	vmls.f64	d11, d10, d8
1000189a:	ee03 7b48 	vmls.f64	d7, d3, d8
1000189e:	ee04 6b48 	vmls.f64	d6, d4, d8
100018a2:	3410      	adds	r4, #16
100018a4:	3610      	adds	r6, #16
100018a6:	3110      	adds	r1, #16
100018a8:	3510      	adds	r5, #16
100018aa:	45a1      	cmp	r9, r4
100018ac:	ed04 cb02 	vstr	d12, [r4, #-8]
100018b0:	ed04 5b04 	vstr	d5, [r4, #-16]
100018b4:	ed06 bb04 	vstr	d11, [r6, #-16]
100018b8:	ed06 db02 	vstr	d13, [r6, #-8]
100018bc:	ed01 1b02 	vstr	d1, [r1, #-8]
100018c0:	ed01 7b04 	vstr	d7, [r1, #-16]
100018c4:	ed05 6b04 	vstr	d6, [r5, #-16]
100018c8:	ed05 2b02 	vstr	d2, [r5, #-8]
100018cc:	f47f af5e 	bne.w	1000178c <fndsa_vect_FFT_fp64_exact+0x174>
100018d0:	4640      	mov	r0, r8
100018d2:	9e04      	ldr	r6, [sp, #16]
100018d4:	9b06      	ldr	r3, [sp, #24]
100018d6:	9a0a      	ldr	r2, [sp, #40]	@ 0x28
100018d8:	3010      	adds	r0, #16
100018da:	4282      	cmp	r2, r0
100018dc:	44b3      	add	fp, r6
100018de:	eb03 1306 	add.w	r3, r3, r6, lsl #4
100018e2:	eb09 1906 	add.w	r9, r9, r6, lsl #4
100018e6:	f47f aedc 	bne.w	100016a2 <fndsa_vect_FFT_fp64_exact+0x8a>
100018ea:	9c0c      	ldr	r4, [sp, #48]	@ 0x30
100018ec:	9b12      	ldr	r3, [sp, #72]	@ 0x48
100018ee:	3401      	adds	r4, #1
100018f0:	429c      	cmp	r4, r3
100018f2:	46d3      	mov	fp, sl
100018f4:	f8dd c020 	ldr.w	ip, [sp, #32]
100018f8:	f8dd 8038 	ldr.w	r8, [sp, #56]	@ 0x38
100018fc:	9e10      	ldr	r6, [sp, #64]	@ 0x40
100018fe:	f4ff aeb1 	bcc.w	10001664 <fndsa_vect_FFT_fp64_exact+0x4c>
10001902:	4645      	mov	r5, r8
10001904:	e9dd 8416 	ldrd	r8, r4, [sp, #88]	@ 0x58
10001908:	2c02      	cmp	r4, #2
1000190a:	f8dd a050 	ldr.w	sl, [sp, #80]	@ 0x50
1000190e:	f000 840b 	beq.w	10002128 <fndsa_vect_FFT_fp64_exact+0xb10>
10001912:	4631      	mov	r1, r6
10001914:	2410      	movs	r4, #16
10001916:	ed9f eb0a 	vldr	d14, [pc, #40]	@ 10001940 <fndsa_vect_FFT_fp64_exact+0x328>
1000191a:	ed9f fb0b 	vldr	d15, [pc, #44]	@ 10001948 <fndsa_vect_FFT_fp64_exact+0x330>
1000191e:	f108 33ff 	add.w	r3, r8, #4294967295	@ 0xffffffff
10001922:	fa04 f40a 	lsl.w	r4, r4, sl
10001926:	ea4f 0658 	mov.w	r6, r8, lsr #1
1000192a:	089b      	lsrs	r3, r3, #2
1000192c:	f101 0740 	add.w	r7, r1, #64	@ 0x40
10001930:	eb05 1606 	add.w	r6, r5, r6, lsl #4
10001934:	eb07 1783 	add.w	r7, r7, r3, lsl #6
10001938:	4425      	add	r5, r4
1000193a:	440c      	add	r4, r1
1000193c:	e00a      	b.n	10001954 <fndsa_vect_FFT_fp64_exact+0x33c>
1000193e:	bf00      	nop
10001940:	00000000 	.word	0x00000000
10001944:	3df00000 	.word	0x3df00000
10001948:	00000000 	.word	0x00000000
1000194c:	41f00000 	.word	0x41f00000
10001950:	300009a0 	.word	0x300009a0
10001954:	ed91 7b02 	vldr	d7, [r1, #8]
10001958:	ed91 3b06 	vldr	d3, [r1, #24]
1000195c:	ed8d 7b02 	vstr	d7, [sp, #8]
10001960:	edd6 7a00 	vldr	s15, [r6]
10001964:	ed94 2b04 	vldr	d2, [r4, #16]
10001968:	ed91 5b04 	vldr	d5, [r1, #16]
1000196c:	ed91 4b00 	vldr	d4, [r1]
10001970:	ed8d 3b00 	vstr	d3, [sp]
10001974:	eeb8 3b67 	vcvt.f64.u32	d3, s15
10001978:	edd6 7a02 	vldr	s15, [r6, #8]
1000197c:	6873      	ldr	r3, [r6, #4]
1000197e:	ed8d 2b06 	vstr	d2, [sp, #24]
10001982:	0fdb      	lsrs	r3, r3, #31
10001984:	ee02 3a10 	vmov	s4, r3
10001988:	68f3      	ldr	r3, [r6, #12]
1000198a:	ed94 6b02 	vldr	d6, [r4, #8]
1000198e:	0fdb      	lsrs	r3, r3, #31
10001990:	ed8d 5b0a 	vstr	d5, [sp, #40]	@ 0x28
10001994:	ed8d 4b0c 	vstr	d4, [sp, #48]	@ 0x30
10001998:	ee05 3a10 	vmov	s10, r3
1000199c:	eeb8 4b67 	vcvt.f64.u32	d4, s15
100019a0:	edd6 7a01 	vldr	s15, [r6, #4]
100019a4:	ed8d 6b12 	vstr	d6, [sp, #72]	@ 0x48
100019a8:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
100019ac:	eeb8 6b67 	vcvt.f64.u32	d6, s15
100019b0:	edd6 7a03 	vldr	s15, [r6, #12]
100019b4:	ed94 bb00 	vldr	d11, [r4]
100019b8:	ed94 1b06 	vldr	d1, [r4, #24]
100019bc:	ed94 0b0c 	vldr	d0, [r4, #48]	@ 0x30
100019c0:	eeb8 7b67 	vcvt.f64.u32	d7, s15
100019c4:	eeb8 2bc2 	vcvt.f64.s32	d2, s4
100019c8:	ed8d 3b42 	vstr	d3, [sp, #264]	@ 0x108
100019cc:	ed8d 4b4c 	vstr	d4, [sp, #304]	@ 0x130
100019d0:	ed8d 5b52 	vstr	d5, [sp, #328]	@ 0x148
100019d4:	ee33 5b04 	vadd.f64	d5, d3, d4
100019d8:	ee23 3b0e 	vmul.f64	d3, d3, d14
100019dc:	ee24 4b0e 	vmul.f64	d4, d4, d14
100019e0:	ed91 cb0c 	vldr	d12, [r1, #48]	@ 0x30
100019e4:	ed91 db0e 	vldr	d13, [r1, #56]	@ 0x38
100019e8:	ed8d bb08 	vstr	d11, [sp, #32]
100019ec:	ed8d 1b04 	vstr	d1, [sp, #16]
100019f0:	ed8d 0b10 	vstr	d0, [sp, #64]	@ 0x40
100019f4:	ed8d 2b48 	vstr	d2, [sp, #288]	@ 0x120
100019f8:	ed8d 6b40 	vstr	d6, [sp, #256]	@ 0x100
100019fc:	ed8d 7b4a 	vstr	d7, [sp, #296]	@ 0x128
10001a00:	ed8d 3b46 	vstr	d3, [sp, #280]	@ 0x118
10001a04:	ed8d 4b50 	vstr	d4, [sp, #320]	@ 0x140
10001a08:	ee25 4b0e 	vmul.f64	d4, d5, d14
10001a0c:	eefc 3bc4 	vcvt.u32.f64	s7, d4
10001a10:	ee36 4b07 	vadd.f64	d4, d6, d7
10001a14:	ee27 7b0e 	vmul.f64	d7, d7, d14
10001a18:	ed8d 7b4e 	vstr	d7, [sp, #312]	@ 0x138
10001a1c:	eeb8 7b63 	vcvt.f64.u32	d7, s7
10001a20:	ee34 4b07 	vadd.f64	d4, d4, d7
10001a24:	ee07 5b4f 	vmls.f64	d5, d7, d15
10001a28:	ee24 7b0e 	vmul.f64	d7, d4, d14
10001a2c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10001a30:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10001a34:	ee07 4b4f 	vmls.f64	d4, d7, d15
10001a38:	eebc 7bc4 	vcvt.u32.f64	s14, d4
10001a3c:	ee17 3a10 	vmov	r3, s14
10001a40:	0fdb      	lsrs	r3, r3, #31
10001a42:	ee07 3a10 	vmov	s14, r3
10001a46:	ed94 8b0e 	vldr	d8, [r4, #56]	@ 0x38
10001a4a:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10001a4e:	ee26 6b0e 	vmul.f64	d6, d6, d14
10001a52:	ed8d 5b56 	vstr	d5, [sp, #344]	@ 0x158
10001a56:	ed8d 4b54 	vstr	d4, [sp, #336]	@ 0x150
10001a5a:	ee25 5b0e 	vmul.f64	d5, d5, d14
10001a5e:	ee24 4b0e 	vmul.f64	d4, d4, d14
10001a62:	ed91 0b08 	vldr	d0, [r1, #32]
10001a66:	ed91 1b0a 	vldr	d1, [r1, #40]	@ 0x28
10001a6a:	ed94 2b08 	vldr	d2, [r4, #32]
10001a6e:	ed94 3b0a 	vldr	d3, [r4, #40]	@ 0x28
10001a72:	a840      	add	r0, sp, #256	@ 0x100
10001a74:	ed8d 4b58 	vstr	d4, [sp, #352]	@ 0x160
10001a78:	ed8d 7b5c 	vstr	d7, [sp, #368]	@ 0x170
10001a7c:	ed8d 6b44 	vstr	d6, [sp, #272]	@ 0x110
10001a80:	ed8d 5b5a 	vstr	d5, [sp, #360]	@ 0x168
10001a84:	ed8d 8b0e 	vstr	d8, [sp, #56]	@ 0x38
10001a88:	f7fe ff4e 	bl	10000928 <fp64e_cmul_prepared>
10001a8c:	eeb0 9b40 	vmov.f64	d9, d0
10001a90:	eeb0 8b42 	vmov.f64	d8, d2
10001a94:	eeb0 bb41 	vmov.f64	d11, d1
10001a98:	eeb0 ab43 	vmov.f64	d10, d3
10001a9c:	ed9d 2b10 	vldr	d2, [sp, #64]	@ 0x40
10001aa0:	eeb0 0b4c 	vmov.f64	d0, d12
10001aa4:	eeb0 1b4d 	vmov.f64	d1, d13
10001aa8:	ed9d 3b0e 	vldr	d3, [sp, #56]	@ 0x38
10001aac:	ed8d 9b20 	vstr	d9, [sp, #128]	@ 0x80
10001ab0:	ed8d bb22 	vstr	d11, [sp, #136]	@ 0x88
10001ab4:	ed8d 8b24 	vstr	d8, [sp, #144]	@ 0x90
10001ab8:	ed8d ab26 	vstr	d10, [sp, #152]	@ 0x98
10001abc:	f7fe ff34 	bl	10000928 <fp64e_cmul_prepared>
10001ac0:	edd5 7a00 	vldr	s15, [r5]
10001ac4:	eeb8 5b67 	vcvt.f64.u32	d5, s15
10001ac8:	edd5 7a02 	vldr	s15, [r5, #8]
10001acc:	eeb8 6b67 	vcvt.f64.u32	d6, s15
10001ad0:	edd5 7a01 	vldr	s15, [r5, #4]
10001ad4:	686b      	ldr	r3, [r5, #4]
10001ad6:	eeb8 cb67 	vcvt.f64.u32	d12, s15
10001ada:	0fdb      	lsrs	r3, r3, #31
10001adc:	ee04 3a10 	vmov	s8, r3
10001ae0:	68eb      	ldr	r3, [r5, #12]
10001ae2:	edd5 7a03 	vldr	s15, [r5, #12]
10001ae6:	0fdb      	lsrs	r3, r3, #31
10001ae8:	ee07 3a10 	vmov	s14, r3
10001aec:	eeb8 db67 	vcvt.f64.u32	d13, s15
10001af0:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10001af4:	eeb8 4bc4 	vcvt.f64.s32	d4, s8
10001af8:	ed8d 6b4c 	vstr	d6, [sp, #304]	@ 0x130
10001afc:	ed8d 7b52 	vstr	d7, [sp, #328]	@ 0x148
10001b00:	ee35 7b06 	vadd.f64	d7, d5, d6
10001b04:	ee26 6b0e 	vmul.f64	d6, d6, d14
10001b08:	ed8d 4b48 	vstr	d4, [sp, #288]	@ 0x120
10001b0c:	ed8d 5b42 	vstr	d5, [sp, #264]	@ 0x108
10001b10:	ed9d 4b02 	vldr	d4, [sp, #8]
10001b14:	ee25 5b0e 	vmul.f64	d5, d5, d14
10001b18:	ed8d 6b50 	vstr	d6, [sp, #320]	@ 0x140
10001b1c:	ee27 6b0e 	vmul.f64	d6, d7, d14
10001b20:	ed8d 5b46 	vstr	d5, [sp, #280]	@ 0x118
10001b24:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10001b28:	ee34 5b0f 	vadd.f64	d5, d4, d15
10001b2c:	ee34 4b0b 	vadd.f64	d4, d4, d11
10001b30:	ed8d 4b10 	vstr	d4, [sp, #64]	@ 0x40
10001b34:	eeb8 4b46 	vcvt.f64.u32	d4, s12
10001b38:	ee04 7b4f 	vmls.f64	d7, d4, d15
10001b3c:	ed9d 6b12 	vldr	d6, [sp, #72]	@ 0x48
10001b40:	ed8d 7b56 	vstr	d7, [sp, #344]	@ 0x158
10001b44:	ee27 7b0e 	vmul.f64	d7, d7, d14
10001b48:	ed8d 7b5a 	vstr	d7, [sp, #360]	@ 0x168
10001b4c:	ee36 7b0f 	vadd.f64	d7, d6, d15
10001b50:	ee3a 6b06 	vadd.f64	d6, d10, d6
10001b54:	ed8d 0b28 	vstr	d0, [sp, #160]	@ 0xa0
10001b58:	ed8d 1b2a 	vstr	d1, [sp, #168]	@ 0xa8
10001b5c:	ed8d 2b2c 	vstr	d2, [sp, #176]	@ 0xb0
10001b60:	ed8d 3b2e 	vstr	d3, [sp, #184]	@ 0xb8
10001b64:	ed8d cb40 	vstr	d12, [sp, #256]	@ 0x100
10001b68:	ed8d db4a 	vstr	d13, [sp, #296]	@ 0x128
10001b6c:	ed8d 6b0e 	vstr	d6, [sp, #56]	@ 0x38
10001b70:	ed9d 6b00 	vldr	d6, [sp]
10001b74:	ee37 ab4a 	vsub.f64	d10, d7, d10
10001b78:	ee36 7b0f 	vadd.f64	d7, d6, d15
10001b7c:	ee36 6b01 	vadd.f64	d6, d6, d1
10001b80:	ee37 7b41 	vsub.f64	d7, d7, d1
10001b84:	ed9d 1b04 	vldr	d1, [sp, #16]
10001b88:	ee35 bb4b 	vsub.f64	d11, d5, d11
10001b8c:	ee31 5b0f 	vadd.f64	d5, d1, d15
10001b90:	ed8d 7b02 	vstr	d7, [sp, #8]
10001b94:	ee31 7b03 	vadd.f64	d7, d1, d3
10001b98:	ee35 3b43 	vsub.f64	d3, d5, d3
10001b9c:	ee3c 5b0d 	vadd.f64	d5, d12, d13
10001ba0:	ee35 1b04 	vadd.f64	d1, d5, d4
10001ba4:	ee26 5b0e 	vmul.f64	d5, d6, d14
10001ba8:	ee2c cb0e 	vmul.f64	d12, d12, d14
10001bac:	eefc 4bc5 	vcvt.u32.f64	s9, d5
10001bb0:	ee27 5b0e 	vmul.f64	d5, d7, d14
10001bb4:	ed8d cb44 	vstr	d12, [sp, #272]	@ 0x110
10001bb8:	ee2d db0e 	vmul.f64	d13, d13, d14
10001bbc:	eeb8 cb64 	vcvt.f64.u32	d12, s9
10001bc0:	eefc 5bc5 	vcvt.u32.f64	s11, d5
10001bc4:	ed9d 4b0e 	vldr	d4, [sp, #56]	@ 0x38
10001bc8:	ed8d 1b14 	vstr	d1, [sp, #80]	@ 0x50
10001bcc:	ed8d db4e 	vstr	d13, [sp, #312]	@ 0x138
10001bd0:	eeb0 1b46 	vmov.f64	d1, d6
10001bd4:	eeb8 db65 	vcvt.f64.u32	d13, s11
10001bd8:	ee24 6b0e 	vmul.f64	d6, d4, d14
10001bdc:	ed9d 5b10 	vldr	d5, [sp, #64]	@ 0x40
10001be0:	ed8d 3b00 	vstr	d3, [sp]
10001be4:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10001be8:	eeb0 3b47 	vmov.f64	d3, d7
10001bec:	ee25 7b0e 	vmul.f64	d7, d5, d14
10001bf0:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10001bf4:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10001bf8:	ee06 4b4f 	vmls.f64	d4, d6, d15
10001bfc:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10001c00:	ed8d 6b04 	vstr	d6, [sp, #16]
10001c04:	ee07 5b4f 	vmls.f64	d5, d7, d15
10001c08:	ee2b 6b0e 	vmul.f64	d6, d11, d14
10001c0c:	ed8d 4b0e 	vstr	d4, [sp, #56]	@ 0x38
10001c10:	ed9d 4b0c 	vldr	d4, [sp, #48]	@ 0x30
10001c14:	ed8d 5b12 	vstr	d5, [sp, #72]	@ 0x48
10001c18:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10001c1c:	ee34 5b0f 	vadd.f64	d5, d4, d15
10001c20:	ee34 4b09 	vadd.f64	d4, d4, d9
10001c24:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10001c28:	ee34 4b07 	vadd.f64	d4, d4, d7
10001c2c:	ee35 5b49 	vsub.f64	d5, d5, d9
10001c30:	eeb7 7b00 	vmov.f64	d7, #112	@ 0x3f800000  1.0
10001c34:	eeb0 9b4b 	vmov.f64	d9, d11
10001c38:	ee35 5b47 	vsub.f64	d5, d5, d7
10001c3c:	ed9d bb08 	vldr	d11, [sp, #32]
10001c40:	ee06 9b4f 	vmls.f64	d9, d6, d15
10001c44:	ee2a 7b0e 	vmul.f64	d7, d10, d14
10001c48:	ed8d 9b0c 	vstr	d9, [sp, #48]	@ 0x30
10001c4c:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10001c50:	ee35 9b06 	vadd.f64	d9, d5, d6
10001c54:	ee3b 6b0f 	vadd.f64	d6, d11, d15
10001c58:	ee3b 5b08 	vadd.f64	d5, d11, d8
10001c5c:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10001c60:	eeb7 bb00 	vmov.f64	d11, #112	@ 0x3f800000  1.0
10001c64:	ee36 6b48 	vsub.f64	d6, d6, d8
10001c68:	ee07 ab4f 	vmls.f64	d10, d7, d15
10001c6c:	ee36 6b4b 	vsub.f64	d6, d6, d11
10001c70:	ed9d 8b04 	vldr	d8, [sp, #16]
10001c74:	ed8d ab08 	vstr	d10, [sp, #32]
10001c78:	ee36 ab07 	vadd.f64	d10, d6, d7
10001c7c:	ed9d 6b02 	vldr	d6, [sp, #8]
10001c80:	ee35 8b08 	vadd.f64	d8, d5, d8
10001c84:	ee26 5b0e 	vmul.f64	d5, d6, d14
10001c88:	ed9d 6b0a 	vldr	d6, [sp, #40]	@ 0x28
10001c8c:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10001c90:	ee36 7b0f 	vadd.f64	d7, d6, d15
10001c94:	ee36 6b00 	vadd.f64	d6, d6, d0
10001c98:	ee37 7b40 	vsub.f64	d7, d7, d0
10001c9c:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10001ca0:	ee36 0b0c 	vadd.f64	d0, d6, d12
10001ca4:	ed9d 6b02 	vldr	d6, [sp, #8]
10001ca8:	ee05 6b4f 	vmls.f64	d6, d5, d15
10001cac:	ee0c 1b4f 	vmls.f64	d1, d12, d15
10001cb0:	ee37 7b4b 	vsub.f64	d7, d7, d11
10001cb4:	eeb0 cb4b 	vmov.f64	d12, d11
10001cb8:	ed8d 6b02 	vstr	d6, [sp, #8]
10001cbc:	ed9d bb00 	vldr	d11, [sp]
10001cc0:	ed9d 6b06 	vldr	d6, [sp, #24]
10001cc4:	ee37 5b05 	vadd.f64	d5, d7, d5
10001cc8:	ee2b bb0e 	vmul.f64	d11, d11, d14
10001ccc:	ee36 7b0f 	vadd.f64	d7, d6, d15
10001cd0:	eebc bbcb 	vcvt.u32.f64	s22, d11
10001cd4:	ee36 6b02 	vadd.f64	d6, d6, d2
10001cd8:	ee37 7b42 	vsub.f64	d7, d7, d2
10001cdc:	ee0d 3b4f 	vmls.f64	d3, d13, d15
10001ce0:	ee36 2b0d 	vadd.f64	d2, d6, d13
10001ce4:	ee37 7b4c 	vsub.f64	d7, d7, d12
10001ce8:	ed9d db00 	vldr	d13, [sp]
10001cec:	eeb8 bb4b 	vcvt.f64.u32	d11, s22
10001cf0:	ee0b db4f 	vmls.f64	d13, d11, d15
10001cf4:	ee37 bb0b 	vadd.f64	d11, d7, d11
10001cf8:	ed9d 7b14 	vldr	d7, [sp, #80]	@ 0x50
10001cfc:	ee27 6b0e 	vmul.f64	d6, d7, d14
10001d00:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10001d04:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10001d08:	ee06 7b4f 	vmls.f64	d7, d6, d15
10001d0c:	eefc 6bc7 	vcvt.u32.f64	s13, d7
10001d10:	ee16 3a90 	vmov	r3, s13
10001d14:	ed8d 7b54 	vstr	d7, [sp, #336]	@ 0x150
10001d18:	ee27 7b0e 	vmul.f64	d7, d7, d14
10001d1c:	0fdb      	lsrs	r3, r3, #31
10001d1e:	ed8d 7b58 	vstr	d7, [sp, #352]	@ 0x160
10001d22:	ee07 3a10 	vmov	s14, r3
10001d26:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10001d2a:	ed8d 7b5c 	vstr	d7, [sp, #368]	@ 0x170
10001d2e:	ee24 7b0e 	vmul.f64	d7, d4, d14
10001d32:	ee22 6b0e 	vmul.f64	d6, d2, d14
10001d36:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10001d3a:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10001d3e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10001d42:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10001d46:	ee07 4b4f 	vmls.f64	d4, d7, d15
10001d4a:	ee29 7b0e 	vmul.f64	d7, d9, d14
10001d4e:	ee06 2b4f 	vmls.f64	d2, d6, d15
10001d52:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10001d56:	ee28 6b0e 	vmul.f64	d6, d8, d14
10001d5a:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10001d5e:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10001d62:	ee07 9b4f 	vmls.f64	d9, d7, d15
10001d66:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10001d6a:	ee25 7b0e 	vmul.f64	d7, d5, d14
10001d6e:	ee06 8b4f 	vmls.f64	d8, d6, d15
10001d72:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10001d76:	ee2a 6b0e 	vmul.f64	d6, d10, d14
10001d7a:	ed8d 8b0a 	vstr	d8, [sp, #40]	@ 0x28
10001d7e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10001d82:	eeb0 8b45 	vmov.f64	d8, d5
10001d86:	ee20 cb0e 	vmul.f64	d12, d0, d14
10001d8a:	ee07 8b4f 	vmls.f64	d8, d7, d15
10001d8e:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10001d92:	ee2b 7b0e 	vmul.f64	d7, d11, d14
10001d96:	eebc cbcc 	vcvt.u32.f64	s24, d12
10001d9a:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10001d9e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10001da2:	eeb8 cb4c 	vcvt.f64.u32	d12, s24
10001da6:	ee06 ab4f 	vmls.f64	d10, d6, d15
10001daa:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10001dae:	ee0c 0b4f 	vmls.f64	d0, d12, d15
10001db2:	ee07 bb4f 	vmls.f64	d11, d7, d15
10001db6:	ed8d 4b10 	vstr	d4, [sp, #64]	@ 0x40
10001dba:	ed8d db00 	vstr	d13, [sp]
10001dbe:	ed8d 9b06 	vstr	d9, [sp, #24]
10001dc2:	ed8d ab04 	vstr	d10, [sp, #16]
10001dc6:	f7fe fdaf 	bl	10000928 <fp64e_cmul_prepared>
10001dca:	edd5 7a04 	vldr	s15, [r5, #16]
10001dce:	696b      	ldr	r3, [r5, #20]
10001dd0:	eeb0 db42 	vmov.f64	d13, d2
10001dd4:	0fdb      	lsrs	r3, r3, #31
10001dd6:	eeb0 2b4b 	vmov.f64	d2, d11
10001dda:	ee0b 3a10 	vmov	s22, r3
10001dde:	69eb      	ldr	r3, [r5, #28]
10001de0:	eeb0 cb40 	vmov.f64	d12, d0
10001de4:	0fdb      	lsrs	r3, r3, #31
10001de6:	eeb0 0b48 	vmov.f64	d0, d8
10001dea:	ee05 3a10 	vmov	s10, r3
10001dee:	eeb8 8b67 	vcvt.f64.u32	d8, s15
10001df2:	edd5 7a06 	vldr	s15, [r5, #24]
10001df6:	eeb8 5bc5 	vcvt.f64.s32	d5, s10
10001dfa:	eeb8 4b67 	vcvt.f64.u32	d4, s15
10001dfe:	ed8d 8b42 	vstr	d8, [sp, #264]	@ 0x108
10001e02:	edd5 7a05 	vldr	s15, [r5, #20]
10001e06:	ed8d 5b52 	vstr	d5, [sp, #328]	@ 0x148
10001e0a:	ee38 5b04 	vadd.f64	d5, d8, d4
10001e0e:	ee28 8b0e 	vmul.f64	d8, d8, d14
10001e12:	eeb8 6b67 	vcvt.f64.u32	d6, s15
10001e16:	ed8d 8b46 	vstr	d8, [sp, #280]	@ 0x118
10001e1a:	edd5 7a07 	vldr	s15, [r5, #28]
10001e1e:	ee25 8b0e 	vmul.f64	d8, d5, d14
10001e22:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10001e26:	ed8d 4b4c 	vstr	d4, [sp, #304]	@ 0x130
10001e2a:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10001e2e:	ee24 4b0e 	vmul.f64	d4, d4, d14
10001e32:	eeb8 8b48 	vcvt.f64.u32	d8, s16
10001e36:	ed8d 4b50 	vstr	d4, [sp, #320]	@ 0x140
10001e3a:	ee36 4b07 	vadd.f64	d4, d6, d7
10001e3e:	ed8d 7b4a 	vstr	d7, [sp, #296]	@ 0x128
10001e42:	ee34 4b08 	vadd.f64	d4, d4, d8
10001e46:	ee27 7b0e 	vmul.f64	d7, d7, d14
10001e4a:	ed8d 7b4e 	vstr	d7, [sp, #312]	@ 0x138
10001e4e:	ee24 7b0e 	vmul.f64	d7, d4, d14
10001e52:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10001e56:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10001e5a:	ee07 4b4f 	vmls.f64	d4, d7, d15
10001e5e:	eebc 7bc4 	vcvt.u32.f64	s14, d4
10001e62:	ee17 3a10 	vmov	r3, s14
10001e66:	0fdb      	lsrs	r3, r3, #31
10001e68:	ee08 5b4f 	vmls.f64	d5, d8, d15
10001e6c:	ee07 3a10 	vmov	s14, r3
10001e70:	eeb0 ab41 	vmov.f64	d10, d1
10001e74:	eeb0 9b43 	vmov.f64	d9, d3
10001e78:	eeb8 7bc7 	vcvt.f64.s32	d7, s14
10001e7c:	eeb8 bbcb 	vcvt.f64.s32	d11, s22
10001e80:	ed8d 6b40 	vstr	d6, [sp, #256]	@ 0x100
10001e84:	ed8d 5b56 	vstr	d5, [sp, #344]	@ 0x158
10001e88:	ee26 6b0e 	vmul.f64	d6, d6, d14
10001e8c:	ee25 5b0e 	vmul.f64	d5, d5, d14
10001e90:	ed8d 4b54 	vstr	d4, [sp, #336]	@ 0x150
10001e94:	ee24 4b0e 	vmul.f64	d4, d4, d14
10001e98:	ed9d 1b02 	vldr	d1, [sp, #8]
10001e9c:	ed9d 3b00 	vldr	d3, [sp]
10001ea0:	ed8d cb30 	vstr	d12, [sp, #192]	@ 0xc0
10001ea4:	ed8d ab32 	vstr	d10, [sp, #200]	@ 0xc8
10001ea8:	ed8d db34 	vstr	d13, [sp, #208]	@ 0xd0
10001eac:	ed8d 9b36 	vstr	d9, [sp, #216]	@ 0xd8
10001eb0:	ed8d bb48 	vstr	d11, [sp, #288]	@ 0x120
10001eb4:	ed8d 6b44 	vstr	d6, [sp, #272]	@ 0x110
10001eb8:	ed8d 5b5a 	vstr	d5, [sp, #360]	@ 0x168
10001ebc:	ed8d 4b58 	vstr	d4, [sp, #352]	@ 0x160
10001ec0:	ed8d 7b5c 	vstr	d7, [sp, #368]	@ 0x170
10001ec4:	f7fe fd30 	bl	10000928 <fp64e_cmul_prepared>
10001ec8:	ed9d 5b12 	vldr	d5, [sp, #72]	@ 0x48
10001ecc:	ed9d 7b0e 	vldr	d7, [sp, #56]	@ 0x38
10001ed0:	ee35 6b0a 	vadd.f64	d6, d5, d10
10001ed4:	ee35 4b0f 	vadd.f64	d4, d5, d15
10001ed8:	ed9d 5b0c 	vldr	d5, [sp, #48]	@ 0x30
10001edc:	ee37 8b0f 	vadd.f64	d8, d7, d15
10001ee0:	ee35 bb0f 	vadd.f64	d11, d5, d15
10001ee4:	ee37 7b09 	vadd.f64	d7, d7, d9
10001ee8:	ee38 8b49 	vsub.f64	d8, d8, d9
10001eec:	ee3b bb41 	vsub.f64	d11, d11, d1
10001ef0:	ee35 9b01 	vadd.f64	d9, d5, d1
10001ef4:	ed8d 1b3a 	vstr	d1, [sp, #232]	@ 0xe8
10001ef8:	ed9d 1b08 	vldr	d1, [sp, #32]
10001efc:	ee31 5b0f 	vadd.f64	d5, d1, d15
10001f00:	ee35 5b43 	vsub.f64	d5, d5, d3
10001f04:	ee34 4b4a 	vsub.f64	d4, d4, d10
10001f08:	ed8d 5b00 	vstr	d5, [sp]
10001f0c:	ee31 ab03 	vadd.f64	d10, d1, d3
10001f10:	ee26 5b0e 	vmul.f64	d5, d6, d14
10001f14:	ed8d 3b3e 	vstr	d3, [sp, #248]	@ 0xf8
10001f18:	ee27 3b0e 	vmul.f64	d3, d7, d14
10001f1c:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10001f20:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10001f24:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10001f28:	eeb8 1b43 	vcvt.f64.u32	d1, s6
10001f2c:	ee05 6b4f 	vmls.f64	d6, d5, d15
10001f30:	ee01 7b4f 	vmls.f64	d7, d1, d15
10001f34:	ed9d 3b10 	vldr	d3, [sp, #64]	@ 0x40
10001f38:	ed8d 7b02 	vstr	d7, [sp, #8]
10001f3c:	ed81 6b02 	vstr	d6, [r1, #8]
10001f40:	ee24 7b0e 	vmul.f64	d7, d4, d14
10001f44:	ee33 6b0f 	vadd.f64	d6, d3, d15
10001f48:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10001f4c:	ee33 3b0c 	vadd.f64	d3, d3, d12
10001f50:	ee36 6b4c 	vsub.f64	d6, d6, d12
10001f54:	eeb7 cb00 	vmov.f64	d12, #112	@ 0x3f800000  1.0
10001f58:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10001f5c:	ee36 6b4c 	vsub.f64	d6, d6, d12
10001f60:	eeb0 cb44 	vmov.f64	d12, d4
10001f64:	ee07 cb4f 	vmls.f64	d12, d7, d15
10001f68:	ed9d 4b0a 	vldr	d4, [sp, #40]	@ 0x28
10001f6c:	ed8d cb08 	vstr	d12, [sp, #32]
10001f70:	ee36 cb07 	vadd.f64	d12, d6, d7
10001f74:	ee28 7b0e 	vmul.f64	d7, d8, d14
10001f78:	ee33 3b05 	vadd.f64	d3, d3, d5
10001f7c:	ee34 6b0f 	vadd.f64	d6, d4, d15
10001f80:	ee34 5b0d 	vadd.f64	d5, d4, d13
10001f84:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10001f88:	ee35 1b01 	vadd.f64	d1, d5, d1
10001f8c:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10001f90:	ee36 6b4d 	vsub.f64	d6, d6, d13
10001f94:	eeb7 5b00 	vmov.f64	d5, #112	@ 0x3f800000  1.0
10001f98:	ee07 8b4f 	vmls.f64	d8, d7, d15
10001f9c:	ee36 6b45 	vsub.f64	d6, d6, d5
10001fa0:	eeb0 db48 	vmov.f64	d13, d8
10001fa4:	ee2b 5b0e 	vmul.f64	d5, d11, d14
10001fa8:	ee36 8b07 	vadd.f64	d8, d6, d7
10001fac:	ee29 7b0e 	vmul.f64	d7, d9, d14
10001fb0:	ed9d 4b06 	vldr	d4, [sp, #24]
10001fb4:	eefc 5bc5 	vcvt.u32.f64	s11, d5
10001fb8:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10001fbc:	edcd 5a0a 	vstr	s11, [sp, #40]	@ 0x28
10001fc0:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10001fc4:	ee34 5b0f 	vadd.f64	d5, d4, d15
10001fc8:	ee34 4b00 	vadd.f64	d4, d4, d0
10001fcc:	ee07 9b4f 	vmls.f64	d9, d7, d15
10001fd0:	ed8d 0b38 	vstr	d0, [sp, #224]	@ 0xe0
10001fd4:	ee35 5b40 	vsub.f64	d5, d5, d0
10001fd8:	ee34 0b07 	vadd.f64	d0, d4, d7
10001fdc:	eddd 7a0a 	vldr	s15, [sp, #40]	@ 0x28
10001fe0:	eeb7 4b00 	vmov.f64	d4, #112	@ 0x3f800000  1.0
10001fe4:	eeb8 7b67 	vcvt.f64.u32	d7, s15
10001fe8:	ee35 5b44 	vsub.f64	d5, d5, d4
10001fec:	ee07 bb4f 	vmls.f64	d11, d7, d15
10001ff0:	ee35 5b07 	vadd.f64	d5, d5, d7
10001ff4:	ed9d 7b00 	vldr	d7, [sp]
10001ff8:	ee2a 6b0e 	vmul.f64	d6, d10, d14
10001ffc:	ee27 7b0e 	vmul.f64	d7, d7, d14
10002000:	ed9d 4b04 	vldr	d4, [sp, #16]
10002004:	eefc 7bc7 	vcvt.u32.f64	s15, d7
10002008:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000200c:	edcd 7a06 	vstr	s15, [sp, #24]
10002010:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10002014:	ee34 7b0f 	vadd.f64	d7, d4, d15
10002018:	ee34 4b02 	vadd.f64	d4, d4, d2
1000201c:	ee06 ab4f 	vmls.f64	d10, d6, d15
10002020:	ee34 4b06 	vadd.f64	d4, d4, d6
10002024:	ed8d 2b3c 	vstr	d2, [sp, #240]	@ 0xf0
10002028:	ee37 7b42 	vsub.f64	d7, d7, d2
1000202c:	eddd 6a06 	vldr	s13, [sp, #24]
10002030:	eeb7 2b00 	vmov.f64	d2, #112	@ 0x3f800000  1.0
10002034:	eeb8 6b66 	vcvt.f64.u32	d6, s13
10002038:	ee37 7b42 	vsub.f64	d7, d7, d2
1000203c:	ed9d 2b00 	vldr	d2, [sp]
10002040:	ee06 2b4f 	vmls.f64	d2, d6, d15
10002044:	ed8d 2b00 	vstr	d2, [sp]
10002048:	ee23 2b0e 	vmul.f64	d2, d3, d14
1000204c:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10002050:	ee37 7b06 	vadd.f64	d7, d7, d6
10002054:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10002058:	ee21 6b0e 	vmul.f64	d6, d1, d14
1000205c:	ee02 3b4f 	vmls.f64	d3, d2, d15
10002060:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10002064:	ed81 3b00 	vstr	d3, [r1]
10002068:	eeb8 6b46 	vcvt.f64.u32	d6, s12
1000206c:	ed9d 3b02 	vldr	d3, [sp, #8]
10002070:	ee06 1b4f 	vmls.f64	d1, d6, d15
10002074:	ed84 3b02 	vstr	d3, [r4, #8]
10002078:	ed9d 6b08 	vldr	d6, [sp, #32]
1000207c:	ee2c 3b0e 	vmul.f64	d3, d12, d14
10002080:	ed84 1b00 	vstr	d1, [r4]
10002084:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10002088:	ed81 6b06 	vstr	d6, [r1, #24]
1000208c:	ee28 6b0e 	vmul.f64	d6, d8, d14
10002090:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10002094:	eefc 6bc6 	vcvt.u32.f64	s13, d6
10002098:	ee03 cb4f 	vmls.f64	d12, d3, d15
1000209c:	eeb8 3b66 	vcvt.f64.u32	d3, s13
100020a0:	ee20 6b0e 	vmul.f64	d6, d0, d14
100020a4:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100020a8:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100020ac:	ee24 1b0e 	vmul.f64	d1, d4, d14
100020b0:	ee03 8b4f 	vmls.f64	d8, d3, d15
100020b4:	ee06 0b4f 	vmls.f64	d0, d6, d15
100020b8:	ee25 3b0e 	vmul.f64	d3, d5, d14
100020bc:	ee27 6b0e 	vmul.f64	d6, d7, d14
100020c0:	eebc 3bc3 	vcvt.u32.f64	s6, d3
100020c4:	eebc 1bc1 	vcvt.u32.f64	s2, d1
100020c8:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100020cc:	eeb8 1b41 	vcvt.f64.u32	d1, s2
100020d0:	eeb8 3b43 	vcvt.f64.u32	d3, s6
100020d4:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100020d8:	ee01 4b4f 	vmls.f64	d4, d1, d15
100020dc:	ee03 5b4f 	vmls.f64	d5, d3, d15
100020e0:	ed9d 2b00 	vldr	d2, [sp]
100020e4:	ee06 7b4f 	vmls.f64	d7, d6, d15
100020e8:	3140      	adds	r1, #64	@ 0x40
100020ea:	428f      	cmp	r7, r1
100020ec:	f104 0440 	add.w	r4, r4, #64	@ 0x40
100020f0:	ed01 cb0c 	vstr	d12, [r1, #-48]	@ 0xffffffd0
100020f4:	f106 0610 	add.w	r6, r6, #16
100020f8:	ed04 db0a 	vstr	d13, [r4, #-40]	@ 0xffffffd8
100020fc:	ed04 8b0c 	vstr	d8, [r4, #-48]	@ 0xffffffd0
10002100:	f105 0520 	add.w	r5, r5, #32
10002104:	ed01 9b06 	vstr	d9, [r1, #-24]	@ 0xffffffe8
10002108:	ed01 0b08 	vstr	d0, [r1, #-32]	@ 0xffffffe0
1000210c:	ed04 ab06 	vstr	d10, [r4, #-24]	@ 0xffffffe8
10002110:	ed04 4b08 	vstr	d4, [r4, #-32]	@ 0xffffffe0
10002114:	ed01 5b04 	vstr	d5, [r1, #-16]
10002118:	ed01 bb02 	vstr	d11, [r1, #-8]
1000211c:	ed04 2b02 	vstr	d2, [r4, #-8]
10002120:	ed04 7b04 	vstr	d7, [r4, #-16]
10002124:	f47f ac16 	bne.w	10001954 <fndsa_vect_FFT_fp64_exact+0x33c>
10002128:	b05f      	add	sp, #380	@ 0x17c
1000212a:	ecbd 8b10 	vpop	{d8-d15}
1000212e:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10002132:	2803      	cmp	r0, #3
10002134:	f1a0 0e02 	sub.w	lr, r0, #2
10002138:	f47f aa81 	bne.w	1000163e <fndsa_vect_FFT_fp64_exact+0x26>
1000213c:	4d01      	ldr	r5, [pc, #4]	@ (10002144 <fndsa_vect_FFT_fp64_exact+0xb2c>)
1000213e:	f7ff bbe8 	b.w	10001912 <fndsa_vect_FFT_fp64_exact+0x2fa>
10002142:	bf00      	nop
10002144:	300009a0 	.word	0x300009a0

