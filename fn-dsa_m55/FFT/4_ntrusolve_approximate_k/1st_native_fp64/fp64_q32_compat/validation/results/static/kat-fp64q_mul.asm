
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_q32_compat/validation/build/kat/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10004c30 <fp64q_mul>:
10004c30:	b570      	push	{r4, r5, r6, lr}
10004c32:	ed2d 8b02 	vpush	{d8}
10004c36:	b084      	sub	sp, #16
10004c38:	e9dd 410a 	ldrd	r4, r1, [sp, #40]	@ 0x28
10004c3c:	ee06 2a90 	vmov	s13, r2
10004c40:	ee07 4a90 	vmov	s15, r4
10004c44:	461d      	mov	r5, r3
10004c46:	eeb8 3b67 	vcvt.f64.u32	d3, s15
10004c4a:	eeb8 6b66 	vcvt.f64.u32	d6, s13
10004c4e:	ee07 1a90 	vmov	s15, r1
10004c52:	ee05 5a90 	vmov	s11, r5
10004c56:	ee26 0b03 	vmul.f64	d0, d6, d3
10004c5a:	eeb8 1b67 	vcvt.f64.u32	d1, s15
10004c5e:	ed9f 7b46 	vldr	d7, [pc, #280]	@ 10004d78 <fp64q_mul+0x148>
10004c62:	eeb8 5b65 	vcvt.f64.u32	d5, s11
10004c66:	ee21 1b06 	vmul.f64	d1, d1, d6
10004c6a:	ee20 6b07 	vmul.f64	d6, d0, d7
10004c6e:	ee25 5b03 	vmul.f64	d5, d5, d3
10004c72:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10004c76:	ee21 3b07 	vmul.f64	d3, d1, d7
10004c7a:	ee25 7b07 	vmul.f64	d7, d5, d7
10004c7e:	ed9f 4b40 	vldr	d4, [pc, #256]	@ 10004d80 <fp64q_mul+0x150>
10004c82:	eeb8 2b46 	vcvt.f64.u32	d2, s12
10004c86:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10004c8a:	eefc 7bc3 	vcvt.u32.f64	s15, d3
10004c8e:	ee22 2b04 	vmul.f64	d2, d2, d4
10004c92:	eeb8 3b67 	vcvt.f64.u32	d3, s15
10004c96:	fb01 fe02 	mul.w	lr, r1, r2
10004c9a:	fb04 f302 	mul.w	r3, r4, r2
10004c9e:	ea02 72e1 	and.w	r2, r2, r1, asr #31
10004ca2:	fb05 f101 	mul.w	r1, r5, r1
10004ca6:	fb04 fc05 	mul.w	ip, r4, r5
10004caa:	ea04 74e5 	and.w	r4, r4, r5, asr #31
10004cae:	1b09      	subs	r1, r1, r4
10004cb0:	ee10 6a90 	vmov	r6, s1
10004cb4:	ec55 4b12 	vmov	r4, r5, d2
10004cb8:	1a89      	subs	r1, r1, r2
10004cba:	ee10 2a10 	vmov	r2, s0
10004cbe:	ee23 3b04 	vmul.f64	d3, d3, d4
10004cc2:	4062      	eors	r2, r4
10004cc4:	ea86 0405 	eor.w	r4, r6, r5
10004cc8:	4322      	orrs	r2, r4
10004cca:	ee11 5a10 	vmov	r5, s2
10004cce:	ee13 4a10 	vmov	r4, s6
10004cd2:	ee11 6a90 	vmov	r6, s3
10004cd6:	406c      	eors	r4, r5
10004cd8:	ee13 5a90 	vmov	r5, s7
10004cdc:	eeb8 8b47 	vcvt.f64.u32	d8, s14
10004ce0:	4075      	eors	r5, r6
10004ce2:	4325      	orrs	r5, r4
10004ce4:	4254      	negs	r4, r2
10004ce6:	4322      	orrs	r2, r4
10004ce8:	0fd2      	lsrs	r2, r2, #31
10004cea:	9203      	str	r2, [sp, #12]
10004cec:	9a03      	ldr	r2, [sp, #12]
10004cee:	426c      	negs	r4, r5
10004cf0:	f082 0201 	eor.w	r2, r2, #1
10004cf4:	ea02 73d3 	and.w	r3, r2, r3, lsr #31
10004cf8:	ee16 2a10 	vmov	r2, s12
10004cfc:	432c      	orrs	r4, r5
10004cfe:	0fe4      	lsrs	r4, r4, #31
10004d00:	9402      	str	r4, [sp, #8]
10004d02:	ee17 4a90 	vmov	r4, s15
10004d06:	ee28 4b04 	vmul.f64	d4, d8, d4
10004d0a:	1ad2      	subs	r2, r2, r3
10004d0c:	9b02      	ldr	r3, [sp, #8]
10004d0e:	eb12 020e 	adds.w	r2, r2, lr
10004d12:	f083 0301 	eor.w	r3, r3, #1
10004d16:	ea03 73de 	and.w	r3, r3, lr, lsr #31
10004d1a:	eba4 0303 	sub.w	r3, r4, r3
10004d1e:	eb43 0101 	adc.w	r1, r3, r1
10004d22:	eb12 020c 	adds.w	r2, r2, ip
10004d26:	ee14 3a10 	vmov	r3, s8
10004d2a:	6002      	str	r2, [r0, #0]
10004d2c:	ee15 2a10 	vmov	r2, s10
10004d30:	ee15 4a90 	vmov	r4, s11
10004d34:	ea83 0302 	eor.w	r3, r3, r2
10004d38:	ee14 2a90 	vmov	r2, s9
10004d3c:	ea82 0204 	eor.w	r2, r2, r4
10004d40:	ea42 0203 	orr.w	r2, r2, r3
10004d44:	f1c2 0300 	rsb	r3, r2, #0
10004d48:	ea43 0302 	orr.w	r3, r3, r2
10004d4c:	ee17 2a10 	vmov	r2, s14
10004d50:	ea4f 73d3 	mov.w	r3, r3, lsr #31
10004d54:	9301      	str	r3, [sp, #4]
10004d56:	9b01      	ldr	r3, [sp, #4]
10004d58:	f083 0301 	eor.w	r3, r3, #1
10004d5c:	ea03 73dc 	and.w	r3, r3, ip, lsr #31
10004d60:	eba2 0303 	sub.w	r3, r2, r3
10004d64:	eb43 0301 	adc.w	r3, r3, r1
10004d68:	6043      	str	r3, [r0, #4]
10004d6a:	b004      	add	sp, #16
10004d6c:	ecbd 8b02 	vpop	{d8}
10004d70:	bd70      	pop	{r4, r5, r6, pc}
10004d72:	bf00      	nop
10004d74:	f3af 8000 	nop.w
10004d78:	00000000 	.word	0x00000000
10004d7c:	3df00000 	.word	0x3df00000
10004d80:	00000000 	.word	0x00000000
10004d84:	41f00000 	.word	0x41f00000
