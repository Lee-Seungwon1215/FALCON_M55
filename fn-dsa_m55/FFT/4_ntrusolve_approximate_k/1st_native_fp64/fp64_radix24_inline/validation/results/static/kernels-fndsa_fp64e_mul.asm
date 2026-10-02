
/Users/seungwon/FALCON/fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build/kernels/zephyr/zephyr.elf:     file format elf32-littlearm


Disassembly of section rom_start:

Disassembly of section text:

10001d18 <fndsa_fp64e_mul>:
10001d18:	eefc 7bc0 	vcvt.u32.f64	s15, d0
10001d1c:	ee17 2a90 	vmov	r2, s15
10001d20:	eefc 7bc2 	vcvt.u32.f64	s15, d2
10001d24:	0fd2      	lsrs	r2, r2, #31
10001d26:	ee17 3a90 	vmov	r3, s15
10001d2a:	ee07 2a90 	vmov	s15, r2
10001d2e:	ed2d 8b10 	vpush	{d8-d15}
10001d32:	eeb8 7be7 	vcvt.f64.s32	d7, s15
10001d36:	b094      	sub	sp, #80	@ 0x50
10001d38:	0fdb      	lsrs	r3, r3, #31
10001d3a:	ed8d 7b00 	vstr	d7, [sp]
10001d3e:	ee07 3a90 	vmov	s15, r3
10001d42:	eeb0 bb43 	vmov.f64	d11, d3
10001d46:	eeb8 4be7 	vcvt.f64.s32	d4, s15
10001d4a:	ed9f 3b53 	vldr	d3, [pc, #332]	@ 10001e98 <fndsa_fp64e_mul+0x180>
10001d4e:	ed9f 6b54 	vldr	d6, [pc, #336]	@ 10001ea0 <fndsa_fp64e_mul+0x188>
10001d52:	ed8d 4b02 	vstr	d4, [sp, #8]
10001d56:	ee22 4b03 	vmul.f64	d4, d2, d3
10001d5a:	ee20 5b03 	vmul.f64	d5, d0, d3
10001d5e:	ee21 9b06 	vmul.f64	d9, d1, d6
10001d62:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10001d66:	eeb0 cb41 	vmov.f64	d12, d1
10001d6a:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10001d6e:	ed9f 1b4e 	vldr	d1, [pc, #312]	@ 10001ea8 <fndsa_fp64e_mul+0x190>
10001d72:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10001d76:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10001d7a:	ee2b 7b06 	vmul.f64	d7, d11, d6
10001d7e:	ee04 2b41 	vmls.f64	d2, d4, d1
10001d82:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10001d86:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10001d8a:	ee05 0b41 	vmls.f64	d0, d5, d1
10001d8e:	ed9f eb48 	vldr	d14, [pc, #288]	@ 10001eb0 <fndsa_fp64e_mul+0x198>
10001d92:	eeb0 8b42 	vmov.f64	d8, d2
10001d96:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10001d9a:	eeb0 2b49 	vmov.f64	d2, d9
10001d9e:	ed9f 3b46 	vldr	d3, [pc, #280]	@ 10001eb8 <fndsa_fp64e_mul+0x1a0>
10001da2:	ee00 2b0e 	vmla.f64	d2, d0, d14
10001da6:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10001daa:	eeb0 0b4c 	vmov.f64	d0, d12
10001dae:	ee09 0b43 	vmls.f64	d0, d9, d3
10001db2:	eeb0 9b47 	vmov.f64	d9, d7
10001db6:	ee08 9b0e 	vmla.f64	d9, d8, d14
10001dba:	eeb0 8b4b 	vmov.f64	d8, d11
10001dbe:	ee07 8b43 	vmls.f64	d8, d7, d3
10001dc2:	ee20 7b08 	vmul.f64	d7, d0, d8
10001dc6:	ee20 ab09 	vmul.f64	d10, d0, d9
10001dca:	ee20 fb04 	vmul.f64	d15, d0, d4
10001dce:	ee22 db04 	vmul.f64	d13, d2, d4
10001dd2:	ee02 ab08 	vmla.f64	d10, d2, d8
10001dd6:	ee02 fb09 	vmla.f64	d15, d2, d9
10001dda:	ee05 db09 	vmla.f64	d13, d5, d9
10001dde:	ee05 fb08 	vmla.f64	d15, d5, d8
10001de2:	ee27 7b06 	vmul.f64	d7, d7, d6
10001de6:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10001dea:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10001dee:	ee37 7b0a 	vadd.f64	d7, d7, d10
10001df2:	ee27 4b06 	vmul.f64	d4, d7, d6
10001df6:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10001dfa:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10001dfe:	ed9f 5b30 	vldr	d5, [pc, #192]	@ 10001ec0 <fndsa_fp64e_mul+0x1a8>
10001e02:	ee3f 2b04 	vadd.f64	d2, d15, d4
10001e06:	ee04 7b43 	vmls.f64	d7, d4, d3
10001e0a:	ee27 7b05 	vmul.f64	d7, d7, d5
10001e0e:	ee22 5b06 	vmul.f64	d5, d2, d6
10001e12:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10001e16:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10001e1a:	ee3d 4b05 	vadd.f64	d4, d13, d5
10001e1e:	ee05 2b43 	vmls.f64	d2, d5, d3
10001e22:	ed9f 5b1d 	vldr	d5, [pc, #116]	@ 10001e98 <fndsa_fp64e_mul+0x180>
10001e26:	ee24 6b06 	vmul.f64	d6, d4, d6
10001e2a:	ee22 db05 	vmul.f64	d13, d2, d5
10001e2e:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10001e32:	eebc dbcd 	vcvt.u32.f64	s26, d13
10001e36:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10001e3a:	eeb8 db4d 	vcvt.f64.u32	d13, s26
10001e3e:	eebc 7bc7 	vcvt.u32.f64	s14, d7
10001e42:	ee06 4b43 	vmls.f64	d4, d6, d3
10001e46:	ee0d 2b41 	vmls.f64	d2, d13, d1
10001e4a:	eeb0 0b4d 	vmov.f64	d0, d13
10001e4e:	eeb8 7b47 	vcvt.f64.u32	d7, s14
10001e52:	ee04 0b0e 	vmla.f64	d0, d4, d14
10001e56:	ee02 7b01 	vmla.f64	d7, d2, d1
10001e5a:	ed9f 8b1b 	vldr	d8, [pc, #108]	@ 10001ec8 <fndsa_fp64e_mul+0x1b0>
10001e5e:	eeb0 1b47 	vmov.f64	d1, d7
10001e62:	ed9d 7b00 	vldr	d7, [sp]
10001e66:	ee30 0b08 	vadd.f64	d0, d0, d8
10001e6a:	ed9d 4b02 	vldr	d4, [sp, #8]
10001e6e:	ee07 0b4b 	vmls.f64	d0, d7, d11
10001e72:	ed9f 9b17 	vldr	d9, [pc, #92]	@ 10001ed0 <fndsa_fp64e_mul+0x1b8>
10001e76:	ee04 0b4c 	vmls.f64	d0, d4, d12
10001e7a:	ee20 9b09 	vmul.f64	d9, d0, d9
10001e7e:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10001e82:	ed9f 7b15 	vldr	d7, [pc, #84]	@ 10001ed8 <fndsa_fp64e_mul+0x1c0>
10001e86:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10001e8a:	ee09 0b47 	vmls.f64	d0, d9, d7
10001e8e:	b014      	add	sp, #80	@ 0x50
10001e90:	ecbd 8b10 	vpop	{d8-d15}
10001e94:	4770      	bx	lr
10001e96:	bf00      	nop
10001e98:	00000000 	.word	0x00000000
10001e9c:	3ef00000 	.word	0x3ef00000
10001ea0:	00000000 	.word	0x00000000
10001ea4:	3e700000 	.word	0x3e700000
10001ea8:	00000000 	.word	0x00000000
10001eac:	40f00000 	.word	0x40f00000
10001eb0:	00000000 	.word	0x00000000
10001eb4:	40700000 	.word	0x40700000
10001eb8:	00000000 	.word	0x00000000
10001ebc:	41700000 	.word	0x41700000
10001ec0:	00000000 	.word	0x00000000
10001ec4:	3f700000 	.word	0x3f700000
10001ec8:	00000000 	.word	0x00000000
10001ecc:	42000000 	.word	0x42000000
10001ed0:	00000000 	.word	0x00000000
10001ed4:	3df00000 	.word	0x3df00000
10001ed8:	00000000 	.word	0x00000000
10001edc:	41f00000 	.word	0x41f00000
