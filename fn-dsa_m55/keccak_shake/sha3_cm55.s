	.syntax	unified
	.file	"sha3_cm55.s"
	.text

@ =======================================================================
@ void fndsa_sha3_inject_chunk(void *dst, const void *src, size_t len)
@ =======================================================================

	.align	2
	.global	fndsa_sha3_inject_chunk
	.thumb
	.thumb_func
	.type	fndsa_sha3_inject_chunk, %function
fndsa_sha3_inject_chunk:
	push	{ r4, r5 }

	@ If less than 8 bytes to inject, do it byte-by-byte.
	cmp	r2, #8
	blo	fndsa_sha3_inject_chunk__L4

	@ Process some bytes until the destination is aligned.
	rsbs	r5, r0, #0
	ands	r5, r5, #3
	beq	fndsa_sha3_inject_chunk__L2
	subs	r2, r5
fndsa_sha3_inject_chunk__L1:
	ldrb.w	r3, [r0]
	ldrb	r4, [r1], #1
	eor	r3, r3, r4
	strb	r3, [r0], #1
	subs	r5, #1
	bne	fndsa_sha3_inject_chunk__L1

fndsa_sha3_inject_chunk__L2:
	@ Destination is aligned. Source might be unaligned, but the
	@ Cortex-M4 tolerates unaligns accesses with a penalty which is
	@ lower than doing word reassembly in software.
	lsr	r5, r2, #2
fndsa_sha3_inject_chunk__L3:
	ldr.w	r3, [r0]
	ldr	r4, [r1], #4
	eor	r3, r3, r4
	str	r3, [r0], #4
	subs	r5, #1
	bne	fndsa_sha3_inject_chunk__L3

	@ We may have a remaining tail of up to 3 bytes.
	ands	r2, r2, #3
	beq.w	fndsa_sha3_inject_chunk__L5

fndsa_sha3_inject_chunk__L4:
	@ Byte-by-byte processing for the data tail.
	ldrb.w	r3, [r0]
	ldrb	r4, [r1], #1
	eor	r3, r3, r4
	strb	r3, [r0], #1
	subs	r2, #1
	bne	fndsa_sha3_inject_chunk__L4

fndsa_sha3_inject_chunk__L5:
	pop	{ r4, r5 }
	bx	lr
	.size	fndsa_sha3_inject_chunk,.-fndsa_sha3_inject_chunk

@ =======================================================================
@ bit_split_5(uint64_t x0, uint64_t x1, uint64_t x2, uint64_t x3, uint64_t x4)
@ Split inputs x0 to x4 into even-indexed and odd-indexed bits.
@ Internal function only; non-standard ABI:
@ input:
@    r0:r1    x0
@    r2:r3    x1
@    r4:r5    x2
@    r6:r7    x3
@    r10:r11  x4
@ ASPR.GE flags must have pattern 0110.
@
@ output:
@    r0     even-indexed bits of x0
@    r1     odd-indexed bits of x0
@    r2     even-indexed bits of x1
@    r3     odd-indexed bits of x1
@    r4     even-indexed bits of x2
@    r5     odd-indexed bits of x2
@    r6     even-indexed bits of x3
@    r7     odd-indexed bits of x3
@    r10    even-indexed bits of x4
@    r11    odd-indexed bits of x4
@ clobbers:
@    r8, r14
@
@ bit_split_1, bit_split_2, bit_split_3 and bit_split_4 are alternate
@ entry points that process only the first 1, 2, 3 or 4 words.
@ =======================================================================

	@ This macro splits a word (input register xx) into its
	@ even-indexed bits (into the low half of output register dd)
	@ and odd-indexed bits (high half of dd).
	@ This macro assumes that the ASPR.GE flags have the 0110 pattern.
	@ dd and xx cannot be the same register. xx is consumed.
.macro	BIT_SPLIT_32  xx, dd
	eor	\dd, \xx, \xx, lsr #1
	and	\dd, \dd, #0x22222222
	eor	\xx, \xx, \dd
	eor	\xx, \xx, \dd, lsl #1
	eor	\dd, \xx, \xx, lsr #2
	and	\dd, \dd, #0x0C0C0C0C
	eor	\xx, \xx, \dd
	eor	\xx, \xx, \dd, lsl #2
	eor	\dd, \xx, \xx, lsr #4
	and	\dd, \dd, #0x00F000F0
	eor	\xx, \xx, \dd
	eor	\xx, \xx, \dd, lsl #4
	rev	\dd, \xx
	sel	\dd, \dd, \xx
.endm

	@ Split a 64-bit value x0:x1 into its even-indexed bits (into x0)
	@ and high-indexed bits (into x1). xt is a scratch register.
	@ This macro assumes that the ASPR.GE flags have the 0110 pattern.
.macro	BIT_SPLIT_64  x0, x1, xt
	BIT_SPLIT_32  \x0, \xt
	BIT_SPLIT_32  \x1, \x0
	pkhtb	\x1, \x0, \xt, asr #16
	pkhbt	\x0, \xt, \x0, lsl #16
.endm

	.align	2
	.thumb
	.thumb_func
	.type	bit_split_5, %function
bit_split_5:
	BIT_SPLIT_64	r10, r11, r8
bit_split_4:
	BIT_SPLIT_64	r6,  r7,  r8
bit_split_3:
	BIT_SPLIT_64	r4,  r5,  r8
bit_split_2:
	BIT_SPLIT_64	r2,  r3,  r8
bit_split_1:
	BIT_SPLIT_64	r0,  r1,  r8
	bx	lr
	.size	bit_split_5, .-bit_split_5

@ =======================================================================
@ bit_merge_5(uint64_t x0, uint64_t x1, uint64_t x2, uint64_t x3, uint64_t x4)
@ Merge inputs x0 to x4 with bit interleaving. For i = 0 to 4, the
@ low word of x_i contains the even-indexed bits, and the high word
@ contains the odd-indexed bits.
@ Internal function only; non-standard ABI:
@ input:
@    r0:r1    x0
@    r2:r3    x1
@    r4:r5    x2
@    r6:r7    x3
@    r10:r11  x4
@ ASPR.GE flags must have pattern 0110.
@
@ output:
@    r0:r1    merged x0
@    r2:r3    merged x1
@    r4:r5    merged x2
@    r6:r7    merged x3
@    r10:r11  merged x4
@ clobbers:
@    r8, r14
@
@ bit_merge_1, bit_merge_2, bit_merge_3 and bit_merge_4 are alternate
@ entry points that process only the first 1, 2, 3 or 4 words.
@ =======================================================================

	@ This macro merges a word (input register xx): low half yields
	@ the even-indexed bits, and hight half provides the odd-indexed
	@ bits. Output is written into register dd.
	@ This macro assumes that the ASPR.GE flags have the 0110 pattern.
	@ dd and xx cannot be the same register. xx is consumed.
.macro	BIT_MERGE_32  xx, dd
	rev	\dd, \xx
	sel	\xx, \dd, \xx
	eor	\dd, \xx, \xx, lsr #4
	and	\dd, \dd, #0x00F000F0
	eor	\xx, \xx, \dd
	eor	\xx, \xx, \dd, lsl #4
	eor	\dd, \xx, \xx, lsr #2
	and	\dd, \dd, #0x0C0C0C0C
	eor	\xx, \xx, \dd
	eor	\xx, \xx, \dd, lsl #2
	eor	\dd, \xx, \xx, lsr #1
	and	\dd, \dd, #0x22222222
	eor	\xx, \xx, \dd
	eor	\dd, \xx, \dd, lsl #1
.endm

	@ BIT_MERGE_64 interleaves the bits from x0 and from x1, result
	@ is written back to x0:x1. xt is a scratch register.
	@ This macro assumes that the ASPR.GE flags have the 0110 pattern.
.macro	BIT_MERGE_64  x0, x1, xt
	pkhtb	\xt, \x1, \x0, asr #16
	pkhbt	\x1, \x0, \x1, lsl #16
	BIT_MERGE_32	\x1, \x0
	BIT_MERGE_32	\xt, \x1
.endm

	.align	2
	.thumb
	.thumb_func
	.type	bit_merge_5, %function
bit_merge_5:
	BIT_MERGE_64	r10, r11, r8
bit_merge_4:
	BIT_MERGE_64	r6,  r7,  r8
bit_merge_3:
	BIT_MERGE_64	r4,  r5,  r8
bit_merge_2:
	BIT_MERGE_64	r2,  r3,  r8
bit_merge_1:
	BIT_MERGE_64	r0,  r1,  r8
	bx	lr
	.size	bit_merge_5, .-bit_merge_5

@ =======================================================================
@ Single-state Keccak-f[1600], all state arithmetic uses MVE integer ops.
@ K_STATE_FORMAT: canonical32
@ K_IOTA: fused_chi
@ Internally each lane is (low32, high32), not even/odd.
@ Canonical lanes 0..20; even/odd-interleaved lanes 21..24 at the API boundary.
@ This intentionally preserves sha3_cm4.s's existing boundary representation.
@ Scalar instructions only handle addresses, public counters and ABI saves.
@ No scalar fifth-column fallback, no FP arithmetic, no SLOTHY.
@
@ A: low32/high32 planes 160 bytes apart, five 32-byte rows.
@ B: low32/high32 planes 240 bytes apart, five 48-byte rows. Each row has
@    columns [0,1,2,3,4,0,1,2,3,pad,pad,pad] for the cyclic chi windows.
@ C and D: two 32-byte planes; only columns 0..4 are semantically live.
@ The extra vector lanes are private padding, never extra Keccak states.
@ Stack: A[320], B[480], C[64], D[64], metadata[16], aligned to 16 bytes.
@ =======================================================================

.equ K_B,       320
.equ K_C,       800
.equ K_D,       864
.equ K_OLDSP,   928
.equ K_FRAME,   944

.macro K_ADDR reg,label
    movw \reg,#:lower16:\label
    movt \reg,#:upper16:\label
.endm

@ Four independent 32-bit words: compress even-positioned bits.
@ Q2/Q3 hold low-word even/odd, Q4/Q5 high-word even/odd.
.macro K_COMPACT_STEP shift,mask
    vmov.i32 q7,#\mask
    vshr.u32 q6,q2,#\shift
    vorr q2,q2,q6
    vand q2,q2,q7
    vshr.u32 q6,q3,#\shift
    vorr q3,q3,q6
    vand q3,q3,q7
    vshr.u32 q6,q4,#\shift
    vorr q4,q4,q6
    vand q4,q4,q7
    vshr.u32 q6,q5,#\shift
    vorr q5,q5,q6
    vand q5,q5,q7
.endm

@ Q0/Q1: four canonical low/high words -> four even32/odd32 pairs.
.macro K_SPLIT4
    vmov.i32 q7,#0x55555555
    vand q2,q0,q7
    vshr.u32 q3,q0,#1
    vand q3,q3,q7
    vand q4,q1,q7
    vshr.u32 q5,q1,#1
    vand q5,q5,q7
    K_COMPACT_STEP 1,0x33333333
    K_COMPACT_STEP 2,0x0f0f0f0f
    K_COMPACT_STEP 4,0x00ff00ff
    K_COMPACT_STEP 8,0x0000ffff
    vshl.i32 q4,q4,#16
    vshl.i32 q5,q5,#16
    vorr q0,q2,q4
    vorr q1,q3,q5
.endm

.macro K_SPREAD_STEP shift,mask
    vmov.i32 q7,#\mask
    vshl.i32 q6,q2,#\shift
    vorr q2,q2,q6
    vand q2,q2,q7
    vshl.i32 q6,q3,#\shift
    vorr q3,q3,q6
    vand q3,q3,q7
    vshl.i32 q6,q4,#\shift
    vorr q4,q4,q6
    vand q4,q4,q7
    vshl.i32 q6,q5,#\shift
    vorr q5,q5,q6
    vand q5,q5,q7
.endm

@ Inverse of K_SPLIT4; no integer/FP conversions or scalar bit operations.
.macro K_MERGE4
    vmov.i32 q7,#0x0000ffff
    vand q2,q0,q7
    vand q3,q1,q7
    vshr.u32 q4,q0,#16
    vshr.u32 q5,q1,#16
    K_SPREAD_STEP 8,0x00ff00ff
    K_SPREAD_STEP 4,0x0f0f0f0f
    K_SPREAD_STEP 2,0x33333333
    K_SPREAD_STEP 1,0x55555555
    vshl.i32 q3,q3,#1
    vshl.i32 q5,q5,#1
    vorr q0,q2,q3
    vorr q1,q4,q5
.endm

.macro K_INPUT_ROW row
    add.w r0,r8,#(40*(\row))
    vld20.32 {q0,q1},[r0]
    vld21.32 {q0,q1},[r0]
    vstrw.32 q0,[r4,#(32*(\row))]
    vstrw.32 q1,[r4,#(160+32*(\row))]
.endm
.macro K_OUTPUT_ROW row
    vldrw.u32 q0,[r4,#(32*(\row))]
    vldrw.u32 q1,[r4,#(160+32*(\row))]
    add.w r0,r8,#(40*(\row))
    vst20.32 {q0,q1},[r0]
    vst21.32 {q0,q1},[r0]
.endm

@ Initial parity: first four columns and replicated fifth column.
@ Gather avoids reading uninitialized A padding on the first round.
.macro K_INITIAL_PARITY plane
    add.w r0,r4,#\plane
    K_ADDR r3,.Lkeccak_tail_offset
    vldrw.u32 q5,[r3]
    vldrw.u32 q0,[r0]
    vldrw.u32 q1,[r0,q5]
    .irp row,1,2,3,4
        add.w r1,r0,#(32*\row)
        vldrw.u32 q2,[r1]
        vldrw.u32 q3,[r1,q5]
        veor q0,q0,q2
        veor q1,q1,q3
    .endr
    vstrw.32 q0,[r6,#((\plane)/5)]
    vstrw.32 q1,[r6,#((\plane)/5+16)]
.endm

@ Four D[x] values at once, including D[4] in the second invocation.
@ D[x] = C[x-1] XOR ROL64(C[x+1],1), split into low/high words.
@ VSRI joins the cross-word carry bit; no scalar carry is involved.
.macro K_THETA offset
    .if (\offset)==0
        vldrw.u32 q4,[r3]
        vldrw.u32 q0,[r6,q4]
        add.w r0,r6,#32
        vldrw.u32 q1,[r0,q4]
        vldrw.u32 q2,[r6,#4]
        vldrw.u32 q3,[r6,#36]
    .else
        @ Only D[4] (lane zero) is live in this tail vector.
        vldrw.u32 q0,[r6,#12]
        vldrw.u32 q1,[r6,#44]
        vldrw.u32 q2,[r6]
        vldrw.u32 q3,[r6,#32]
    .endif
    vshl.i32 q4,q2,#1
    vshl.i32 q5,q3,#1
    vsri.32 q4,q3,#31
    vsri.32 q5,q2,#31
    veor q0,q0,q4
    vstrw.32 q0,[r7,#\offset]
    veor q1,q1,q5
    vstrw.32 q1,[r7,#(32+\offset)]
.endm

@ Public gather indices pre-swap low/high inputs for rotations >= 32.
@ Counts s and s-32 implement exact cross-word ROL64, including s=0.
@ The next group's indices are prefetched while storing the current group.
@ Both theta injection and rho/pi are vector operations, no scalar tail.
.macro K_RHOPI4 offset,scatter=0
    @ Q6/Q7 hold the current group's public A offsets.
    vldrw.u32 q0,[r4,q6]
    vldrw.u32 q2,[r3],#16
    vldrw.u32 q1,[r4,q7]
    vldrw.u32 q3,[r3],#16
    vldrw.u32 q4,[r7,q2]
    veor q0,q0,q4
    vldrw.u32 q5,[r7,q3]
    vldrw.u32 q6,[r3],#16
    veor q1,q1,q5
    vshl.u32 q2,q0,q6
    vldrw.u32 q4,[r3],#16
    vshl.u32 q3,q1,q6
    vshl.u32 q0,q0,q4
    vshl.u32 q1,q1,q4
    vorr q2,q2,q1
    .if \scatter
        vldrw.u32 q6,[r3],#16
        vorr q3,q3,q0
        vstrw.32 q2,[r5,q6]
        add.w r0,r5,#240
        vstrw.32 q3,[r0,q6]
    .else
        vldrw.u32 q6,[r3],#16
        vstrw.32 q2,[r5,#\offset]
        vorr q3,q3,q0
        vldrw.u32 q7,[r3],#16
        vstrw.32 q3,[r5,#(240+\offset)]
        vstrw.32 q2,[r5,#(\offset+20)]
        vstrw.32 q3,[r5,#(240+\offset+20)]
    .endif
.endm

@ Single remaining rho/pi lane uses contiguous loads and a public lane-0 store.
@ Other vector lanes are padding; no scalar state operations.
.macro K_RHOPI_LAST
    vldrw.u32 q0,[r4,#132]
    vldrw.u32 q1,[r4,#292]
    vldrw.u32 q2,[r7,#4]
    vldrw.u32 q3,[r7,#36]
    veor q0,q0,q2
    veor q1,q1,q3
    vshl.i32 q2,q0,#2
    vshl.i32 q3,q1,#2
    vsri.32 q2,q1,#30
    vsri.32 q3,q0,#30
    vpstt
    vstrwt.32 q2,[r5,#208]
    vstrwt.32 q3,[r5,#448]
.endm

@ Interleave chi ALU work with next-row loads on the independent MVE LSU.
@ The register names rotate; no spill/reload is introduced.
.macro K_CHI_PLANE plane
    veor q6,q6,q6
    veor q7,q7,q7
    vldrw.u32 q0,[r5,#(\plane)]
    vldrw.u32 q1,[r5,#(\plane+4)]
    vldrw.u32 q2,[r5,#(\plane+8)]
    vldrw.u32 q3,[r5,#(\plane+16)]
    @ Row 0
    vbic q4,q1,q0
    vbic q2,q2,q1
    vldrw.u32 q1,[r5,#(48+\plane)]
    veor q3,q3,q4
    vldrw.u32 q5,[r10,#((\plane)/15)]
    vldrw.u32 q4,[r5,#(52+\plane)]
    veor q0,q0,q2
    veor q0,q0,q5
    vldrw.u32 q2,[r5,#(56+\plane)]
    veor q6,q6,q0
    vldrw.u32 q5,[r5,#(64+\plane)]
    veor q7,q7,q3
    vstrw.32 q0,[r4,#(0+(\plane)*2/3)]
    vstrw.32 q3,[r4,#(16+(\plane)*2/3)]
    @ Row 1
    vbic q0,q4,q1
    vbic q2,q2,q4
    vldrw.u32 q4,[r5,#(96+\plane)]
    veor q5,q5,q0
    vldrw.u32 q0,[r5,#(100+\plane)]
    veor q1,q1,q2
    vldrw.u32 q2,[r5,#(104+\plane)]
    veor q6,q6,q1
    vldrw.u32 q3,[r5,#(112+\plane)]
    veor q7,q7,q5
    vstrw.32 q1,[r4,#(32+(\plane)*2/3)]
    vstrw.32 q5,[r4,#(48+(\plane)*2/3)]
    @ Row 2
    vbic q1,q0,q4
    vbic q2,q2,q0
    vldrw.u32 q0,[r5,#(144+\plane)]
    veor q3,q3,q1
    vldrw.u32 q1,[r5,#(148+\plane)]
    veor q4,q4,q2
    vldrw.u32 q2,[r5,#(152+\plane)]
    veor q6,q6,q4
    vldrw.u32 q5,[r5,#(160+\plane)]
    veor q7,q7,q3
    vstrw.32 q4,[r4,#(64+(\plane)*2/3)]
    vstrw.32 q3,[r4,#(80+(\plane)*2/3)]
    @ Row 3
    vbic q3,q1,q0
    vbic q2,q2,q1
    vldrw.u32 q1,[r5,#(192+\plane)]
    veor q5,q5,q3
    vldrw.u32 q3,[r5,#(196+\plane)]
    veor q0,q0,q2
    vldrw.u32 q2,[r5,#(200+\plane)]
    veor q6,q6,q0
    vldrw.u32 q4,[r5,#(208+\plane)]
    veor q7,q7,q5
    vstrw.32 q0,[r4,#(96+(\plane)*2/3)]
    vstrw.32 q5,[r4,#(112+(\plane)*2/3)]
    @ Row 4
    vbic q0,q3,q1
    vbic q2,q2,q3
    veor q4,q4,q0
    veor q1,q1,q2
    veor q6,q6,q1
    veor q7,q7,q4
    vstrw.32 q1,[r4,#(128+(\plane)*2/3)]
    vstrw.32 q4,[r4,#(144+(\plane)*2/3)]
    vstrw.32 q6,[r6,#((\plane)*2/15)]
    vstrw.32 q7,[r6,#((\plane)*2/15+16)]
.endm

.align 2
.global fndsa_sha3_process_block
.thumb
.thumb_func
.type fndsa_sha3_process_block,%function
fndsa_sha3_process_block:
    push.w {r4-r11,lr}
    sub sp,sp,#4
    vpush {d8-d15}
    mov r2,sp
    sub.w r3,r2,#K_FRAME
    bic r3,r3,#15
    mov sp,r3
    str r2,[sp,#K_OLDSP]
    mov r8,r0
    mov r4,sp
    add.w r5,r4,#K_B
    add.w r6,r4,#K_C
    add.w r7,r4,#K_D

    K_INPUT_ROW 0
    K_INPUT_ROW 1
    K_INPUT_ROW 2
    K_INPUT_ROW 3
    @ The fifth columns of rows 0..3 are processed together, not scalar.
    K_ADDR r3,.Lkeccak_tail_io
    vldrw.u32 q6,[r3]
    vldrw.u32 q7,[r3,#16]
    vldrw.u32 q0,[r8,q6]
    vldrw.u32 q1,[r8,q7]
    K_ADDR r3,.Lkeccak_tail_a
    vldrw.u32 q6,[r3]
    vstrw.32 q0,[r4,q6]
    add.w r0,r4,#160
    vstrw.32 q1,[r0,q6]

    @ Lane 20: a one-lane predicated vector transfer. Never read past state.
    @ P0 remains lane-0 active throughout the public 24-round loop.
    add.w r0,r8,#160
    K_ADDR r3,.Lkeccak_io_offsets
    vldrw.u32 q6,[r3]
    vldrw.u32 q7,[r3,#16]
    movs r1,#1
    vctp.32 r1
    vpstt
    vldrwt.u32 q0,[r0,q6]
    vldrwt.u32 q1,[r0,q7]
    vpstt
    vstrwt.32 q0,[r4,#128]
    vstrwt.32 q1,[r4,#288]
    @ Lanes 21..24 already use even/odd format at the existing API boundary.
    add.w r0,r8,#168
    vld20.32 {q0,q1},[r0]
    vld21.32 {q0,q1},[r0]
    K_MERGE4
    vstrw.32 q0,[r4,#132]
    vstrw.32 q1,[r4,#292]

    K_INITIAL_PARITY 0
    K_INITIAL_PARITY 160
    K_ADDR r10,.Lkeccak_mve_rc
    movs r11,#24
.Lkeccak_mve_round:
    K_ADDR r3,.Lkeccak_theta_offsets
    K_THETA 0
    K_THETA 16
    K_ADDR r3,.Lkeccak_rhopi_table
    vldrw.u32 q6,[r3],#16
    vldrw.u32 q7,[r3],#16
    K_RHOPI4 0
    K_RHOPI4 48
    K_RHOPI4 96
    K_RHOPI4 144
    K_RHOPI4 192
    K_RHOPI4 0,1
    K_RHOPI_LAST
    K_CHI_PLANE 0
    K_CHI_PLANE 240

    @ Iota is also MVE: fused into first-row chi and parity above.
    add r10,r10,#32
    subs r11,r11,#1
    bne.w .Lkeccak_mve_round

    K_OUTPUT_ROW 0
    K_OUTPUT_ROW 1
    K_OUTPUT_ROW 2
    K_OUTPUT_ROW 3
    K_ADDR r3,.Lkeccak_tail_a
    vldrw.u32 q6,[r3]
    vldrw.u32 q0,[r4,q6]
    add.w r0,r4,#160
    vldrw.u32 q1,[r0,q6]
    K_ADDR r3,.Lkeccak_tail_io
    vldrw.u32 q6,[r3]
    vldrw.u32 q7,[r3,#16]
    vstrw.32 q0,[r8,q6]
    vstrw.32 q1,[r8,q7]
    vldrw.u32 q0,[r4,#128]
    vldrw.u32 q1,[r4,#288]
    add.w r0,r8,#160
    K_ADDR r3,.Lkeccak_io_offsets
    vldrw.u32 q6,[r3]
    vldrw.u32 q7,[r3,#16]
    movs r1,#1
    vctp.32 r1
    vpstt
    vstrwt.32 q0,[r0,q6]
    vstrwt.32 q1,[r0,q7]
    vldrw.u32 q0,[r4,#132]
    vldrw.u32 q1,[r4,#292]
    K_SPLIT4
    add.w r0,r8,#168
    vst20.32 {q0,q1},[r0]
    vst21.32 {q0,q1},[r0]

    ldr r2,[sp,#K_OLDSP]
    mov sp,r2
    vpop {d8-d15}
    add sp,sp,#4
    pop.w {r4-r11,pc}

.balign 16
.Lkeccak_mve_rc:
    .word 0x00000001,0,0,0,0x00000000,0,0,0
    .word 0x00008082,0,0,0,0x00000000,0,0,0
    .word 0x0000808a,0,0,0,0x80000000,0,0,0
    .word 0x80008000,0,0,0,0x80000000,0,0,0
    .word 0x0000808b,0,0,0,0x00000000,0,0,0
    .word 0x80000001,0,0,0,0x00000000,0,0,0
    .word 0x80008081,0,0,0,0x80000000,0,0,0
    .word 0x00008009,0,0,0,0x80000000,0,0,0
    .word 0x0000008a,0,0,0,0x00000000,0,0,0
    .word 0x00000088,0,0,0,0x00000000,0,0,0
    .word 0x80008009,0,0,0,0x00000000,0,0,0
    .word 0x8000000a,0,0,0,0x00000000,0,0,0
    .word 0x8000808b,0,0,0,0x00000000,0,0,0
    .word 0x0000008b,0,0,0,0x80000000,0,0,0
    .word 0x00008089,0,0,0,0x80000000,0,0,0
    .word 0x00008003,0,0,0,0x80000000,0,0,0
    .word 0x00008002,0,0,0,0x80000000,0,0,0
    .word 0x00000080,0,0,0,0x80000000,0,0,0
    .word 0x0000800a,0,0,0,0x00000000,0,0,0
    .word 0x8000000a,0,0,0,0x80000000,0,0,0
    .word 0x80008081,0,0,0,0x80000000,0,0,0
    .word 0x00008080,0,0,0,0x80000000,0,0,0
    .word 0x80000001,0,0,0,0x00000000,0,0,0
    .word 0x80008008,0,0,0,0x80000000,0,0,0
.size fndsa_sha3_process_block,.-fndsa_sha3_process_block

.section .rodata.keccak_fullmve,"a",%progbits
.balign 16
.Lkeccak_io_offsets:
    .word 0,8,16,24
    .word 4,12,20,28
.Lkeccak_tail_io:
    .word 32,72,112,152
    .word 36,76,116,156
.Lkeccak_tail_a:
    .word 16,48,80,112
.Lkeccak_tail_offset:
    .word 16,16,16,16
.Lkeccak_theta_offsets:
    .word 16,0,4,8
@ Six destination groups: A low/high, D low/high, positive/negative
@ public rotation counts, plus B scatter offsets for group 5.
@ Destination (4,4) is handled by K_RHOPI_LAST with fixed public offsets.
.Lkeccak_rhopi_table:
    @ Destination group 0
    .word 0,196,232,108
    .word 160,36,72,268
    .word 0,36,40,12
    .word 32,4,8,44
    .word 0,12,11,21
    .word -32,-20,-21,-11
    @ Destination group 1
    .word 12,48,64,260
    .word 172,208,224,100
    .word 12,16,0,36
    .word 44,48,32,4
    .word 28,20,3,13
    .word -4,-12,-29,-19
    @ Destination group 2
    .word 4,40,76,112
    .word 164,200,236,272
    .word 4,8,12,16
    .word 36,40,44,48
    .word 1,6,25,8
    .word -31,-26,-7,-24
    @ Destination group 3
    .word 16,192,68,104
    .word 176,32,228,264
    .word 16,32,4,8
    .word 48,0,36,40
    .word 27,4,10,15
    .word -5,-28,-22,-17
    @ Destination group 4
    .word 168,204,240,256
    .word 8,44,80,96
    .word 40,44,48,32
    .word 8,12,16,0
    .word 30,23,7,9
    .word -2,-9,-25,-23
    @ Destination group 5
    .word 144,296,128,300
    .word 304,136,288,140
    .word 16,40,0,44
    .word 48,8,32,12
    .word 14,29,18,24
    .word -18,-3,-14,-8
    .word 16,64,112,160
