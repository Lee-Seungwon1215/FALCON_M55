10005f58 <fp64e_cmul_prepared>:
10005f58:	eefc 6bc0 	vcvt.u32.f64	s13, d0
10005f5c:	ee16 2a90 	vmov	r2, s13
10005f60:	eefc 6bc2 	vcvt.u32.f64	s13, d2
10005f64:	0fd2      	lsrs	r2, r2, #31
10005f66:	ee16 3a90 	vmov	r3, s13
10005f6a:	ee06 2a90 	vmov	s13, r2
10005f6e:	ed2d 8b10 	vpush	{d8-d15}
10005f72:	eeb8 6be6 	vcvt.f64.s32	d6, s13
10005f76:	b0b4      	sub	sp, #208	@ 0xd0
10005f78:	0fdb      	lsrs	r3, r3, #31
10005f7a:	ed8d 6b14 	vstr	d6, [sp, #80]	@ 0x50
10005f7e:	ee06 3a90 	vmov	s13, r3
10005f82:	eeb0 fb43 	vmov.f64	d15, d3
10005f86:	eeb0 db41 	vmov.f64	d13, d1
10005f8a:	ed90 3b06 	vldr	d3, [r0, #24]
10005f8e:	eeb8 5be6 	vcvt.f64.s32	d5, s13
10005f92:	ee31 eb0f 	vadd.f64	d14, d1, d15
10005f96:	ed8d 5b18 	vstr	d5, [sp, #96]	@ 0x60
10005f9a:	ed9f 5bff 	vldr	d5, [pc, #1020]	@ 10006398 <fp64e_cmul_prepared+0x440>
10005f9e:	ed90 1b10 	vldr	d1, [r0, #64]	@ 0x40
10005fa2:	ee2d 9b03 	vmul.f64	d9, d13, d3
10005fa6:	ee20 3b03 	vmul.f64	d3, d0, d3
10005faa:	ee2e 8b05 	vmul.f64	d8, d14, d5
10005fae:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10005fb2:	eefc 3bc8 	vcvt.u32.f64	s7, d8
10005fb6:	eeb8 8b43 	vcvt.f64.u32	d8, s6
10005fba:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10005fbe:	ed8d 8b0a 	vstr	d8, [sp, #40]	@ 0x28
10005fc2:	ee2f 8b01 	vmul.f64	d8, d15, d1
10005fc6:	ed90 6b0e 	vldr	d6, [r0, #56]	@ 0x38
10005fca:	ed90 4b04 	vldr	d4, [r0, #16]
10005fce:	ee22 1b01 	vmul.f64	d1, d2, d1
10005fd2:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10005fd6:	eeb8 ab41 	vcvt.f64.u32	d10, s2
10005fda:	ed8d ab08 	vstr	d10, [sp, #32]
10005fde:	ee2f ab06 	vmul.f64	d10, d15, d6
10005fe2:	ed9f 7bef 	vldr	d7, [pc, #956]	@ 100063a0 <fp64e_cmul_prepared+0x448>
10005fe6:	eebc abca 	vcvt.u32.f64	s20, d10
10005fea:	ee2d 1b04 	vmul.f64	d1, d13, d4
10005fee:	eeb8 cb4a 	vcvt.f64.u32	d12, s20
10005ff2:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10005ff6:	eeb8 3b63 	vcvt.f64.u32	d3, s7
10005ffa:	ee30 ab02 	vadd.f64	d10, d0, d2
10005ffe:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10006002:	ee3a ab03 	vadd.f64	d10, d10, d3
10006006:	eeb8 bb41 	vcvt.f64.u32	d11, s2
1000600a:	ee03 eb47 	vmls.f64	d14, d3, d7
1000600e:	ee29 1b47 	vnmul.f64	d1, d9, d7
10006012:	ed90 3b02 	vldr	d3, [r0, #8]
10006016:	eead 1b03 	vfma.f64	d1, d13, d3
1000601a:	ee31 1b07 	vadd.f64	d1, d1, d7
1000601e:	ed8d db04 	vstr	d13, [sp, #16]
10006022:	eebc 8bc8 	vcvt.u32.f64	s16, d8
10006026:	ee21 1b05 	vmul.f64	d1, d1, d5
1000602a:	eeb8 8b48 	vcvt.f64.u32	d8, s16
1000602e:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10006032:	eeb8 1b41 	vcvt.f64.u32	d1, s2
10006036:	ee28 3b47 	vnmul.f64	d3, d8, d7
1000603a:	ee31 db09 	vadd.f64	d13, d1, d9
1000603e:	ee2a 1b05 	vmul.f64	d1, d10, d5
10006042:	ed90 9b0c 	vldr	d9, [r0, #48]	@ 0x30
10006046:	eeaf 3b09 	vfma.f64	d3, d15, d9
1000604a:	ee33 3b07 	vadd.f64	d3, d3, d7
1000604e:	ed8d eb00 	vstr	d14, [sp]
10006052:	eebc 1bc1 	vcvt.u32.f64	s2, d1
10006056:	ee23 3b05 	vmul.f64	d3, d3, d5
1000605a:	eeb8 1b41 	vcvt.f64.u32	d1, s2
1000605e:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006062:	ee01 ab47 	vmls.f64	d10, d1, d7
10006066:	eeb8 3b43 	vcvt.f64.u32	d3, s6
1000606a:	ee20 4b04 	vmul.f64	d4, d0, d4
1000606e:	ee33 eb08 	vadd.f64	d14, d3, d8
10006072:	eefc 3bca 	vcvt.u32.f64	s7, d10
10006076:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000607a:	ee13 3a90 	vmov	r3, s7
1000607e:	ee22 6b06 	vmul.f64	d6, d2, d6
10006082:	0fdb      	lsrs	r3, r3, #31
10006084:	ee03 3a90 	vmov	s7, r3
10006088:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000608c:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10006090:	ed90 8b00 	vldr	d8, [r0]
10006094:	ed8d ab02 	vstr	d10, [sp, #8]
10006098:	ee2b 1b47 	vnmul.f64	d1, d11, d7
1000609c:	ed9d ab04 	vldr	d10, [sp, #16]
100060a0:	eeaa 1b08 	vfma.f64	d1, d10, d8
100060a4:	ee24 4b47 	vnmul.f64	d4, d4, d7
100060a8:	eea0 4b08 	vfma.f64	d4, d0, d8
100060ac:	eeb8 3be3 	vcvt.f64.s32	d3, s7
100060b0:	ee34 4b07 	vadd.f64	d4, d4, d7
100060b4:	ed9d 8b0a 	vldr	d8, [sp, #40]	@ 0x28
100060b8:	ed90 ab02 	vldr	d10, [r0, #8]
100060bc:	ed8d 3b1a 	vstr	d3, [sp, #104]	@ 0x68
100060c0:	eeb8 6b46 	vcvt.f64.u32	d6, s12
100060c4:	ed8d 4b10 	vstr	d4, [sp, #64]	@ 0x40
100060c8:	ee2c 3b47 	vnmul.f64	d3, d12, d7
100060cc:	ed90 4b0a 	vldr	d4, [r0, #40]	@ 0x28
100060d0:	eeaf 3b04 	vfma.f64	d3, d15, d4
100060d4:	ee26 6b47 	vnmul.f64	d6, d6, d7
100060d8:	eea2 6b04 	vfma.f64	d6, d2, d4
100060dc:	ee28 8b47 	vnmul.f64	d8, d8, d7
100060e0:	eea0 8b0a 	vfma.f64	d8, d0, d10
100060e4:	ee33 4b07 	vadd.f64	d4, d3, d7
100060e8:	ed9d ab08 	vldr	d10, [sp, #32]
100060ec:	ed90 9b1a 	vldr	d9, [r0, #104]	@ 0x68
100060f0:	ed90 0b0c 	vldr	d0, [r0, #48]	@ 0x30
100060f4:	ee36 3b07 	vadd.f64	d3, d6, d7
100060f8:	ed9d 6b02 	vldr	d6, [sp, #8]
100060fc:	ed8d 3b0e 	vstr	d3, [sp, #56]	@ 0x38
10006100:	ee2a 3b47 	vnmul.f64	d3, d10, d7
10006104:	eea2 3b00 	vfma.f64	d3, d2, d0
10006108:	ee31 1b07 	vadd.f64	d1, d1, d7
1000610c:	ed9d 2b00 	vldr	d2, [sp]
10006110:	ee29 ab02 	vmul.f64	d10, d9, d2
10006114:	ee29 9b06 	vmul.f64	d9, d9, d6
10006118:	ee21 0b05 	vmul.f64	d0, d1, d5
1000611c:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10006120:	eebc 0bc0 	vcvt.u32.f64	s0, d0
10006124:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10006128:	eeb8 0b40 	vcvt.f64.u32	d0, s0
1000612c:	ed8d 9b0c 	vstr	d9, [sp, #48]	@ 0x30
10006130:	ee24 9b05 	vmul.f64	d9, d4, d5
10006134:	eebc 9bc9 	vcvt.u32.f64	s18, d9
10006138:	ee00 1b47 	vmls.f64	d1, d0, d7
1000613c:	eeb8 9b49 	vcvt.f64.u32	d9, s18
10006140:	ee3b 0b00 	vadd.f64	d0, d11, d0
10006144:	ed8d 1b12 	vstr	d1, [sp, #72]	@ 0x48
10006148:	eeb0 bb44 	vmov.f64	d11, d4
1000614c:	ee09 bb47 	vmls.f64	d11, d9, d7
10006150:	ee38 8b07 	vadd.f64	d8, d8, d7
10006154:	ed8d bb16 	vstr	d11, [sp, #88]	@ 0x58
10006158:	ed90 bb18 	vldr	d11, [r0, #96]	@ 0x60
1000615c:	ed9d 1b0a 	vldr	d1, [sp, #40]	@ 0x28
10006160:	ee2b 4b02 	vmul.f64	d4, d11, d2
10006164:	ee28 2b05 	vmul.f64	d2, d8, d5
10006168:	eebc 2bc2 	vcvt.u32.f64	s4, d2
1000616c:	eeb8 2b42 	vcvt.f64.u32	d2, s4
10006170:	eebc 4bc4 	vcvt.u32.f64	s8, d4
10006174:	ee02 8b47 	vmls.f64	d8, d2, d7
10006178:	ee31 2b02 	vadd.f64	d2, d1, d2
1000617c:	eeb7 1b00 	vmov.f64	d1, #112	@ 0x3f800000  1.0
10006180:	ee33 3b07 	vadd.f64	d3, d3, d7
10006184:	ee2b 6b06 	vmul.f64	d6, d11, d6
10006188:	ee3c 9b09 	vadd.f64	d9, d12, d9
1000618c:	ed9d cb12 	vldr	d12, [sp, #72]	@ 0x48
10006190:	eeb8 bb44 	vcvt.f64.u32	d11, s8
10006194:	ee3d 4b41 	vsub.f64	d4, d13, d1
10006198:	ed8d bb06 	vstr	d11, [sp, #24]
1000619c:	ee23 bb05 	vmul.f64	d11, d3, d5
100061a0:	ee34 4b0c 	vadd.f64	d4, d4, d12
100061a4:	eebc bbcb 	vcvt.u32.f64	s22, d11
100061a8:	ee34 cb08 	vadd.f64	d12, d4, d8
100061ac:	ed9d 4b16 	vldr	d4, [sp, #88]	@ 0x58
100061b0:	ee3e 8b41 	vsub.f64	d8, d14, d1
100061b4:	eebc abca 	vcvt.u32.f64	s20, d10
100061b8:	ee38 8b04 	vadd.f64	d8, d8, d4
100061bc:	eeb8 4b4b 	vcvt.f64.u32	d4, s22
100061c0:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
100061c4:	ee32 2b41 	vsub.f64	d2, d2, d1
100061c8:	ed9d bb00 	vldr	d11, [sp]
100061cc:	ee04 3b47 	vmls.f64	d3, d4, d7
100061d0:	ee38 8b03 	vadd.f64	d8, d8, d3
100061d4:	ed90 db16 	vldr	d13, [r0, #88]	@ 0x58
100061d8:	ee2a 3b47 	vnmul.f64	d3, d10, d7
100061dc:	eeab 3b0d 	vfma.f64	d3, d11, d13
100061e0:	ee30 0b41 	vsub.f64	d0, d0, d1
100061e4:	eebc 6bc6 	vcvt.u32.f64	s12, d6
100061e8:	ee30 0b02 	vadd.f64	d0, d0, d2
100061ec:	ed9d 2b08 	vldr	d2, [sp, #32]
100061f0:	ee33 3b07 	vadd.f64	d3, d3, d7
100061f4:	ee32 4b04 	vadd.f64	d4, d2, d4
100061f8:	ed9d 2b06 	vldr	d2, [sp, #24]
100061fc:	ee23 3b05 	vmul.f64	d3, d3, d5
10006200:	ee34 4b41 	vsub.f64	d4, d4, d1
10006204:	eebc 3bc3 	vcvt.u32.f64	s6, d3
10006208:	ee39 9b41 	vsub.f64	d9, d9, d1
1000620c:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006210:	eeb8 3b43 	vcvt.f64.u32	d3, s6
10006214:	ee39 9b04 	vadd.f64	d9, d9, d4
10006218:	ee26 6b47 	vnmul.f64	d6, d6, d7
1000621c:	ed90 4b14 	vldr	d4, [r0, #80]	@ 0x50
10006220:	ee22 2b47 	vnmul.f64	d2, d2, d7
10006224:	eeab 2b04 	vfma.f64	d2, d11, d4
10006228:	ee33 3b0a 	vadd.f64	d3, d3, d10
1000622c:	ed9d ab02 	vldr	d10, [sp, #8]
10006230:	eeaa 6b04 	vfma.f64	d6, d10, d4
10006234:	ee32 2b07 	vadd.f64	d2, d2, d7
10006238:	ed9d 4b10 	vldr	d4, [sp, #64]	@ 0x40
1000623c:	ed9d db0e 	vldr	d13, [sp, #56]	@ 0x38
10006240:	ed9d eb0c 	vldr	d14, [sp, #48]	@ 0x30
10006244:	ee24 ab05 	vmul.f64	d10, d4, d5
10006248:	ee2d bb05 	vmul.f64	d11, d13, d5
1000624c:	eebc abca 	vcvt.u32.f64	s20, d10
10006250:	eebc bbcb 	vcvt.u32.f64	s22, d11
10006254:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10006258:	eeb8 bb4b 	vcvt.f64.u32	d11, s22
1000625c:	ee0a 4b47 	vmls.f64	d4, d10, d7
10006260:	ee34 4b00 	vadd.f64	d4, d4, d0
10006264:	eeb0 0b4d 	vmov.f64	d0, d13
10006268:	ee0b 0b47 	vmls.f64	d0, d11, d7
1000626c:	ed90 bb16 	vldr	d11, [r0, #88]	@ 0x58
10006270:	ed9d ab02 	vldr	d10, [sp, #8]
10006274:	ee30 0b09 	vadd.f64	d0, d0, d9
10006278:	ee2e 9b47 	vnmul.f64	d9, d14, d7
1000627c:	eeaa 9b0b 	vfma.f64	d9, d10, d11
10006280:	ee22 ab05 	vmul.f64	d10, d2, d5
10006284:	ed9d db06 	vldr	d13, [sp, #24]
10006288:	ee33 3b41 	vsub.f64	d3, d3, d1
1000628c:	eefc bbca 	vcvt.u32.f64	s23, d10
10006290:	ee2c ab05 	vmul.f64	d10, d12, d5
10006294:	ee39 9b07 	vadd.f64	d9, d9, d7
10006298:	eebc bbca 	vcvt.u32.f64	s22, d10
1000629c:	eeb8 ab6b 	vcvt.f64.u32	d10, s23
100062a0:	ee0a 2b47 	vmls.f64	d2, d10, d7
100062a4:	ee3d ab0a 	vadd.f64	d10, d13, d10
100062a8:	ee33 3b02 	vadd.f64	d3, d3, d2
100062ac:	eeb8 2b4b 	vcvt.f64.u32	d2, s22
100062b0:	eeb0 bb4c 	vmov.f64	d11, d12
100062b4:	ee34 4b02 	vadd.f64	d4, d4, d2
100062b8:	ee02 bb47 	vmls.f64	d11, d2, d7
100062bc:	ee28 2b05 	vmul.f64	d2, d8, d5
100062c0:	ee29 cb05 	vmul.f64	d12, d9, d5
100062c4:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100062c8:	eebc cbcc 	vcvt.u32.f64	s24, d12
100062cc:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100062d0:	ee02 8b47 	vmls.f64	d8, d2, d7
100062d4:	ee30 0b02 	vadd.f64	d0, d0, d2
100062d8:	eeb8 2b4c 	vcvt.f64.u32	d2, s24
100062dc:	ee02 9b47 	vmls.f64	d9, d2, d7
100062e0:	ee3e 2b02 	vadd.f64	d2, d14, d2
100062e4:	ee33 3b09 	vadd.f64	d3, d3, d9
100062e8:	ed9f 9b2f 	vldr	d9, [pc, #188]	@ 100063a8 <fp64e_cmul_prepared+0x450>
100062ec:	ed90 cb02 	vldr	d12, [r0, #8]
100062f0:	ee32 2b41 	vsub.f64	d2, d2, d1
100062f4:	ee3a ab41 	vsub.f64	d10, d10, d1
100062f8:	ee34 4b09 	vadd.f64	d4, d4, d9
100062fc:	ee3a ab02 	vadd.f64	d10, d10, d2
10006300:	ed9d 2b14 	vldr	d2, [sp, #80]	@ 0x50
10006304:	ee36 6b07 	vadd.f64	d6, d6, d7
10006308:	ee30 0b09 	vadd.f64	d0, d0, d9
1000630c:	ee02 4b4c 	vmls.f64	d4, d2, d12
10006310:	ed9d 2b18 	vldr	d2, [sp, #96]	@ 0x60
10006314:	ed90 cb0c 	vldr	d12, [r0, #48]	@ 0x30
10006318:	ee02 0b4c 	vmls.f64	d0, d2, d12
1000631c:	ed90 2b08 	vldr	d2, [r0, #32]
10006320:	ed9d db04 	vldr	d13, [sp, #16]
10006324:	ee26 cb05 	vmul.f64	d12, d6, d5
10006328:	eebc cbcc 	vcvt.u32.f64	s24, d12
1000632c:	eeb8 cb4c 	vcvt.f64.u32	d12, s24
10006330:	ee0d 4b42 	vmls.f64	d4, d13, d2
10006334:	ee0c 6b47 	vmls.f64	d6, d12, d7
10006338:	ed90 2b12 	vldr	d2, [r0, #72]	@ 0x48
1000633c:	ee0f 0b42 	vmls.f64	d0, d15, d2
10006340:	ee36 6b0a 	vadd.f64	d6, d6, d10
10006344:	ee24 ab05 	vmul.f64	d10, d4, d5
10006348:	ee23 2b05 	vmul.f64	d2, d3, d5
1000634c:	eebc abca 	vcvt.u32.f64	s20, d10
10006350:	eebc 2bc2 	vcvt.u32.f64	s4, d2
10006354:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10006358:	eeb8 2b42 	vcvt.f64.u32	d2, s4
1000635c:	ee0a 4b47 	vmls.f64	d4, d10, d7
10006360:	ee36 6b02 	vadd.f64	d6, d6, d2
10006364:	ee20 ab05 	vmul.f64	d10, d0, d5
10006368:	ee36 6b09 	vadd.f64	d6, d6, d9
1000636c:	ee02 3b47 	vmls.f64	d3, d2, d7
10006370:	ed9d 2b1a 	vldr	d2, [sp, #104]	@ 0x68
10006374:	eebc abca 	vcvt.u32.f64	s20, d10
10006378:	ed90 9b16 	vldr	d9, [r0, #88]	@ 0x58
1000637c:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
10006380:	ee02 6b49 	vmls.f64	d6, d2, d9
10006384:	ee38 2b0b 	vadd.f64	d2, d8, d11
10006388:	ee0a 0b47 	vmls.f64	d0, d10, d7
1000638c:	ee3b 9b07 	vadd.f64	d9, d11, d7
10006390:	ee22 ab05 	vmul.f64	d10, d2, d5
10006394:	e00c      	b.n	100063b0 <fp64e_cmul_prepared+0x458>
10006396:	bf00      	nop
10006398:	00000000 	.word	0x00000000
1000639c:	3df00000 	.word	0x3df00000
100063a0:	00000000 	.word	0x00000000
100063a4:	41f00000 	.word	0x41f00000
100063a8:	00000000 	.word	0x00000000
100063ac:	42000000 	.word	0x42000000
100063b0:	eebc abca 	vcvt.u32.f64	s20, d10
100063b4:	ee39 9b48 	vsub.f64	d9, d9, d8
100063b8:	ed90 8b1c 	vldr	d8, [r0, #112]	@ 0x70
100063bc:	ed9d bb00 	vldr	d11, [sp]
100063c0:	eeb8 ab4a 	vcvt.f64.u32	d10, s20
100063c4:	ee0b 6b48 	vmls.f64	d6, d11, d8
100063c8:	ee0a 2b47 	vmls.f64	d2, d10, d7
100063cc:	ee33 3b07 	vadd.f64	d3, d3, d7
100063d0:	ee30 8b04 	vadd.f64	d8, d0, d4
100063d4:	ee33 3b42 	vsub.f64	d3, d3, d2
100063d8:	ee26 2b05 	vmul.f64	d2, d6, d5
100063dc:	ee38 8b0a 	vadd.f64	d8, d8, d10
100063e0:	ee34 4b07 	vadd.f64	d4, d4, d7
100063e4:	eebc 2bc2 	vcvt.u32.f64	s4, d2
100063e8:	ee34 0b40 	vsub.f64	d0, d4, d0
100063ec:	ee28 4b05 	vmul.f64	d4, d8, d5
100063f0:	eeb8 2b42 	vcvt.f64.u32	d2, s4
100063f4:	eebc 4bc4 	vcvt.u32.f64	s8, d4
100063f8:	ee02 6b47 	vmls.f64	d6, d2, d7
100063fc:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10006400:	ee36 2b07 	vadd.f64	d2, d6, d7
10006404:	ee04 8b47 	vmls.f64	d8, d4, d7
10006408:	ee29 6b05 	vmul.f64	d6, d9, d5
1000640c:	ee23 4b05 	vmul.f64	d4, d3, d5
10006410:	ee32 2b48 	vsub.f64	d2, d2, d8
10006414:	eebc 6bc6 	vcvt.u32.f64	s12, d6
10006418:	eebc 4bc4 	vcvt.u32.f64	s8, d4
1000641c:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006420:	eeb8 4b44 	vcvt.f64.u32	d4, s8
10006424:	ee30 0b41 	vsub.f64	d0, d0, d1
10006428:	ee32 2b41 	vsub.f64	d2, d2, d1
1000642c:	ee30 0b06 	vadd.f64	d0, d0, d6
10006430:	ee32 2b04 	vadd.f64	d2, d2, d4
10006434:	eeb0 1b49 	vmov.f64	d1, d9
10006438:	ee04 3b47 	vmls.f64	d3, d4, d7
1000643c:	ee06 1b47 	vmls.f64	d1, d6, d7
10006440:	ee20 6b05 	vmul.f64	d6, d0, d5
10006444:	ee22 5b05 	vmul.f64	d5, d2, d5
10006448:	eebc 6bc6 	vcvt.u32.f64	s12, d6
1000644c:	eebc 5bc5 	vcvt.u32.f64	s10, d5
10006450:	eeb8 6b46 	vcvt.f64.u32	d6, s12
10006454:	eeb8 5b45 	vcvt.f64.u32	d5, s10
10006458:	ee06 0b47 	vmls.f64	d0, d6, d7
1000645c:	ee05 2b47 	vmls.f64	d2, d5, d7
10006460:	b034      	add	sp, #208	@ 0xd0
10006462:	ecbd 8b10 	vpop	{d8-d15}
10006466:	4770      	bx	lr

