
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_final_scaling/validation/build/new-perf/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10009c24 <fndsa_vect_iFFT_fp64>:
10009c24:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
10009c28:	1e45      	subs	r5, r0, #1
10009c2a:	b08b      	sub	sp, #44	@ 0x2c
10009c2c:	d06b      	beq.n	10009d06 <fndsa_vect_iFFT_fp64+0xe2>
10009c2e:	f04f 0908 	mov.w	r9, #8
10009c32:	f04f 0a01 	mov.w	sl, #1
10009c36:	462a      	mov	r2, r5
10009c38:	e9cd 5004 	strd	r5, r0, [sp, #16]
10009c3c:	fa09 f905 	lsl.w	r9, r9, r5
10009c40:	2301      	movs	r3, #1
10009c42:	2410      	movs	r4, #16
10009c44:	4650      	mov	r0, sl
10009c46:	460f      	mov	r7, r1
10009c48:	f04f 0c00 	mov.w	ip, #0
10009c4c:	fa03 fb02 	lsl.w	fp, r3, r2
10009c50:	fa0a fa03 	lsl.w	sl, sl, r3
10009c54:	e9cd 2101 	strd	r2, r1, [sp, #4]
10009c58:	4b40      	ldr	r3, [pc, #256]	@ (10009d5c <fndsa_vect_iFFT_fp64+0x138>)
10009c5a:	eb0b 0b5b 	add.w	fp, fp, fp, lsr #1
10009c5e:	fa04 f502 	lsl.w	r5, r4, r2
10009c62:	9103      	str	r1, [sp, #12]
10009c64:	ea4f 08ca 	mov.w	r8, sl, lsl #3
10009c68:	eb03 1b0b 	add.w	fp, r3, fp, lsl #4
10009c6c:	441d      	add	r5, r3
10009c6e:	eb01 06c0 	add.w	r6, r1, r0, lsl #3
10009c72:	eb00 030c 	add.w	r3, r0, ip
10009c76:	459c      	cmp	ip, r3
10009c78:	d235      	bcs.n	10009ce6 <fndsa_vect_iFFT_fp64+0xc2>
10009c7a:	eba6 0e07 	sub.w	lr, r6, r7
10009c7e:	f1ae 0e08 	sub.w	lr, lr, #8
10009c82:	ea4f 0ede 	mov.w	lr, lr, lsr #3
10009c86:	f10e 0e01 	add.w	lr, lr, #1
10009c8a:	ed95 1b00 	vldr	d1, [r5]
10009c8e:	ed95 2b02 	vldr	d2, [r5, #8]
10009c92:	f04e e001 	dls	lr, lr
10009c96:	4634      	mov	r4, r6
10009c98:	4639      	mov	r1, r7
10009c9a:	eb09 0207 	add.w	r2, r9, r7
10009c9e:	eb09 0306 	add.w	r3, r9, r6
10009ca2:	ed94 4b00 	vldr	d4, [r4]
10009ca6:	ed93 5b00 	vldr	d5, [r3]
10009caa:	ed91 6b00 	vldr	d6, [r1]
10009cae:	ed92 7b00 	vldr	d7, [r2]
10009cb2:	ee36 3b44 	vsub.f64	d3, d6, d4
10009cb6:	ee37 0b45 	vsub.f64	d0, d7, d5
10009cba:	ee36 6b04 	vadd.f64	d6, d6, d4
10009cbe:	ee37 7b05 	vadd.f64	d7, d7, d5
10009cc2:	ee22 4b40 	vnmul.f64	d4, d2, d0
10009cc6:	ee22 5b43 	vnmul.f64	d5, d2, d3
10009cca:	ee13 4b01 	vnmls.f64	d4, d3, d1
10009cce:	ee00 5b01 	vmla.f64	d5, d0, d1
10009cd2:	eca1 6b02 	vstmia	r1!, {d6}
10009cd6:	eca2 7b02 	vstmia	r2!, {d7}
10009cda:	eca4 4b02 	vstmia	r4!, {d4}
10009cde:	eca3 5b02 	vstmia	r3!, {d5}
10009ce2:	f00f c023 	le	lr, 10009ca2 <fndsa_vect_iFFT_fp64+0x7e>
10009ce6:	3510      	adds	r5, #16
10009ce8:	45ab      	cmp	fp, r5
10009cea:	44d4      	add	ip, sl
10009cec:	4447      	add	r7, r8
10009cee:	4446      	add	r6, r8
10009cf0:	d1bf      	bne.n	10009c72 <fndsa_vect_iFFT_fp64+0x4e>
10009cf2:	e9dd 2101 	ldrd	r2, r1, [sp, #4]
10009cf6:	3a01      	subs	r2, #1
10009cf8:	d1a2      	bne.n	10009c40 <fndsa_vect_iFFT_fp64+0x1c>
10009cfa:	4610      	mov	r0, r2
10009cfc:	9a05      	ldr	r2, [sp, #20]
10009cfe:	9d04      	ldr	r5, [sp, #16]
10009d00:	2a01      	cmp	r2, #1
10009d02:	9b03      	ldr	r3, [sp, #12]
10009d04:	d802      	bhi.n	10009d0c <fndsa_vect_iFFT_fp64+0xe8>
10009d06:	b00b      	add	sp, #44	@ 0x2c
10009d08:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10009d0c:	f5c2 6480 	rsb	r4, r2, #1024	@ 0x400
10009d10:	0524      	lsls	r4, r4, #20
10009d12:	2208      	movs	r2, #8
10009d14:	e9cd 0406 	strd	r0, r4, [sp, #24]
10009d18:	a906      	add	r1, sp, #24
10009d1a:	a808      	add	r0, sp, #32
10009d1c:	9301      	str	r3, [sp, #4]
10009d1e:	f00b f8c1 	bl	10014ea4 <memcpy>
10009d22:	2201      	movs	r2, #1
10009d24:	40aa      	lsls	r2, r5
10009d26:	0051      	lsls	r1, r2, #1
10009d28:	d0ed      	beq.n	10009d06 <fndsa_vect_iFFT_fp64+0xe2>
10009d2a:	ea4f 1e02 	mov.w	lr, r2, lsl #4
10009d2e:	f1ae 0e08 	sub.w	lr, lr, #8
10009d32:	ea4f 0ede 	mov.w	lr, lr, lsr #3
10009d36:	f10e 0e01 	add.w	lr, lr, #1
10009d3a:	f04e e001 	dls	lr, lr
10009d3e:	ed9d 6b08 	vldr	d6, [sp, #32]
10009d42:	9b01      	ldr	r3, [sp, #4]
10009d44:	ed93 7b00 	vldr	d7, [r3]
10009d48:	ee27 7b06 	vmul.f64	d7, d7, d6
10009d4c:	eca3 7b02 	vstmia	r3!, {d7}
10009d50:	f00f c009 	le	lr, 10009d44 <fndsa_vect_iFFT_fp64+0x120>
10009d54:	b00b      	add	sp, #44	@ 0x2c
10009d56:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
10009d5a:	bf00      	nop
10009d5c:	300039a0 	.word	0x300039a0
