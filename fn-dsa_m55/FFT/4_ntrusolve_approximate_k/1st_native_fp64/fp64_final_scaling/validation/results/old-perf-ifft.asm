
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_final_scaling/validation/build/old-perf/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10009c24 <fndsa_vect_iFFT_fp64>:
10009c24:	1e42      	subs	r2, r0, #1
10009c26:	d077      	beq.n	10009d18 <fndsa_vect_iFFT_fp64+0xf4>
10009c28:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10009c2c:	f04f 0908 	mov.w	r9, #8
10009c30:	ed2d 8b02 	vpush	{d8}
10009c34:	4608      	mov	r0, r1
10009c36:	f04f 0a01 	mov.w	sl, #1
10009c3a:	eeb6 3b00 	vmov.f64	d3, #96	@ 0x3f000000  0.5
10009c3e:	4611      	mov	r1, r2
10009c40:	b083      	sub	sp, #12
10009c42:	fa09 f902 	lsl.w	r9, r9, r2
10009c46:	2301      	movs	r3, #1
10009c48:	2410      	movs	r4, #16
10009c4a:	4652      	mov	r2, sl
10009c4c:	4607      	mov	r7, r0
10009c4e:	f04f 0c00 	mov.w	ip, #0
10009c52:	fa03 fb01 	lsl.w	fp, r3, r1
10009c56:	fa0a fa03 	lsl.w	sl, sl, r3
10009c5a:	e9cd 1000 	strd	r1, r0, [sp]
10009c5e:	4b2f      	ldr	r3, [pc, #188]	@ (10009d1c <fndsa_vect_iFFT_fp64+0xf8>)
10009c60:	eb0b 0b5b 	add.w	fp, fp, fp, lsr #1
10009c64:	fa04 f501 	lsl.w	r5, r4, r1
10009c68:	ea4f 08ca 	mov.w	r8, sl, lsl #3
10009c6c:	eb03 1b0b 	add.w	fp, r3, fp, lsl #4
10009c70:	441d      	add	r5, r3
10009c72:	eb00 06c2 	add.w	r6, r0, r2, lsl #3
10009c76:	eb02 030c 	add.w	r3, r2, ip
10009c7a:	459c      	cmp	ip, r3
10009c7c:	d23d      	bcs.n	10009cfa <fndsa_vect_iFFT_fp64+0xd6>
10009c7e:	eba6 0e07 	sub.w	lr, r6, r7
10009c82:	f1ae 0e08 	sub.w	lr, lr, #8
10009c86:	ea4f 0ede 	mov.w	lr, lr, lsr #3
10009c8a:	f10e 0e01 	add.w	lr, lr, #1
10009c8e:	ed95 1b00 	vldr	d1, [r5]
10009c92:	ed95 2b02 	vldr	d2, [r5, #8]
10009c96:	f04e e001 	dls	lr, lr
10009c9a:	4634      	mov	r4, r6
10009c9c:	4638      	mov	r0, r7
10009c9e:	eb09 0107 	add.w	r1, r9, r7
10009ca2:	eb09 0306 	add.w	r3, r9, r6
10009ca6:	ed94 8b00 	vldr	d8, [r4]
10009caa:	ed93 0b00 	vldr	d0, [r3]
10009cae:	ed90 6b00 	vldr	d6, [r0]
10009cb2:	ed91 7b00 	vldr	d7, [r1]
10009cb6:	ee36 5b48 	vsub.f64	d5, d6, d8
10009cba:	ee37 4b40 	vsub.f64	d4, d7, d0
10009cbe:	ee25 5b03 	vmul.f64	d5, d5, d3
10009cc2:	ee24 4b03 	vmul.f64	d4, d4, d3
10009cc6:	ee36 6b08 	vadd.f64	d6, d6, d8
10009cca:	ee37 7b00 	vadd.f64	d7, d7, d0
10009cce:	ee22 8b44 	vnmul.f64	d8, d2, d4
10009cd2:	ee22 0b45 	vnmul.f64	d0, d2, d5
10009cd6:	ee26 6b03 	vmul.f64	d6, d6, d3
10009cda:	ee27 7b03 	vmul.f64	d7, d7, d3
10009cde:	ee04 0b01 	vmla.f64	d0, d4, d1
10009ce2:	ee15 8b01 	vnmls.f64	d8, d5, d1
10009ce6:	eca0 6b02 	vstmia	r0!, {d6}
10009cea:	eca1 7b02 	vstmia	r1!, {d7}
10009cee:	eca4 8b02 	vstmia	r4!, {d8}
10009cf2:	eca3 0b02 	vstmia	r3!, {d0}
10009cf6:	f00f c02b 	le	lr, 10009ca6 <fndsa_vect_iFFT_fp64+0x82>
10009cfa:	3510      	adds	r5, #16
10009cfc:	45ab      	cmp	fp, r5
10009cfe:	44d4      	add	ip, sl
10009d00:	4447      	add	r7, r8
10009d02:	4446      	add	r6, r8
10009d04:	d1b7      	bne.n	10009c76 <fndsa_vect_iFFT_fp64+0x52>
10009d06:	e9dd 1000 	ldrd	r1, r0, [sp]
10009d0a:	3901      	subs	r1, #1
10009d0c:	d19b      	bne.n	10009c46 <fndsa_vect_iFFT_fp64+0x22>
10009d0e:	b003      	add	sp, #12
10009d10:	ecbd 8b02 	vpop	{d8}
10009d14:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10009d18:	4770      	bx	lr
10009d1a:	bf00      	nop
10009d1c:	300039a0 	.word	0x300039a0
