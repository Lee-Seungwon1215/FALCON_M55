@ Stage-4 combination: S1-B phase-grouped multiply scheduling +
@ S2-B cross-layer butterfly scheduling.
@ S3-A twiddle preload is integrated directly in this source.
@ The stage-3 B1 Barrett formula, tables and layer layout are retained.
@ S1/S2/S3 jointly schedule products, butterflies and memory operations.
@ Revised S2-B uses scalar-vector twiddles to shorten vector live ranges.
	.syntax	unified
	.file	"mq_cm55.s"
	.text

	.equ	Q, 12289
	.equ	Q1I, 4143984639
	.equ	Q1ILO, (Q1I & 0xFFFF)
	.equ	Q1IHI, (Q1I >> 16)
	.equ	R, 10952
	.equ	R2, 5664
	.equ	B_INF, 840

@ MVE helpers derived from the logn=9 two-layer candidate.
@ They implement B1 Barrett constant multiplication and the CT/GS
@ butterflies used by the common two-layer passes.

@ Load root[index] and twist[index], packing root in the low half and twist
@ in the high half of one GPR. r9 is twist_base-root_base.
	.macro	MQ_LOAD_PAIR dst, ptr
	ldrh	\dst, [\ptr]
	add.w	r14, \ptr, r9
	ldrh	r14, [r14]
	@ S3-A: retire the current pair's public table pointer while the
	@ twist halfword load is in flight.  This leaves one independent
	@ scalar instruction between that load and the dependent pack, while
	@ preserving the exact root,twist memory-access order.
	add.w	\ptr, \ptr, #2
	orr	\dst, \dst, r14, lsl #16
	.endm

	.macro	MQ_LOAD_PAIR_OFF dst, ptr, off
	ldrh	\dst, [\ptr, #\off]
	add.w	r14, \ptr, r9
	ldrh	r14, [r14, #\off]
	orr	\dst, \dst, r14, lsl #16
	.endm

@ Duplicate the two signed halfwords of a packed root/twist GPR.
	.macro	MQ_DUP_PAIR rootv, twistv, pair
	vdup.16	\rootv, \pair
	asr.w	r14, \pair, #16
	vdup.16	\twistv, r14
	.endm

@ Build q7/q6 root/twist vectors for two groups packed into their low/high
@ 64-bit halves.  This is the existing packed-kernel sequence factored out
@ so cross-layer macros can retain the exact instruction multiset.
	.macro	MQ_DUP_PACKED_PAIR_Q7_Q6 low_pair, high_pair
	MQ_DUP_PAIR	q7, q6, \low_pair
	uxth	r12, \high_pair
	orr	r12, r12, r12, lsl #16
	vmov	d15, r12, r12
	asr.w	r12, \high_pair, #16
	uxth	r12, r12
	orr	r12, r12, r12, lsl #16
	vmov	d13, r12, r12
	.endm

	.macro	MQ_MVE_MMUL data, root, tmp, twist
	vqrdmulh.s16	\tmp, \data, \twist
	vmul.i16	\data, \data, \root
	vmla.i16	\data, \tmp, r10
	@ Exhaustive q=12289 analysis gives [-8447,8447]; one masked add
	@ restores the existing [0,q) contract.
	vcmp.s16	lt, \data, zr
	vpst
	vaddt.i16	\data, \data, r10
	.endm

@ Evaluate two independent products with a shared vector root/twist.  Group
@ both QH operations, then both low multiplies, then both corrections.  The
@ second QH result may overwrite twist after both QH operations consume it.
	.macro	MQ_MVE_MMUL2_PHASE_GROUPED data0, data1, root, tmp0, twist
	vqrdmulh.s16	\tmp0, \data0, \twist
	vqrdmulh.s16	\twist, \data1, \twist
	vmul.i16	\data0, \data0, \root
	vmul.i16	\data1, \data1, \root
	vmla.i16	\data0, \tmp0, r10
	vmla.i16	\data1, \twist, r10
	vcmp.s16	lt, \data0, zr
	vpst
	vaddt.i16	\data0, \data0, r10
	vcmp.s16	lt, \data1, zr
	vpst
	vaddt.i16	\data1, \data1, r10
	.endm

@ Phase-group two products whose packed root/twist values may differ.  Split
@ MQ_DUP_PAIR into its twist and root halves so that the same instructions are
@ retained, but their order follows QH/QH, MUL/MUL, MLA/MLA.  pair0 and pair1
@ may be equal; reconstructing both is intentional for an instruction-count-
@ neutral scheduling experiment.
	.macro	MQ_MVE_MMUL2P_PHASE_GROUPED data0, data1, tmp0, root, twist, pair0, pair1
	asr.w	r14, \pair0, #16
	vdup.16	\twist, r14
	vqrdmulh.s16	\tmp0, \data0, \twist
	asr.w	r14, \pair1, #16
	vdup.16	\twist, r14
	vqrdmulh.s16	\twist, \data1, \twist
	vdup.16	\root, \pair0
	vmul.i16	\data0, \data0, \root
	vdup.16	\root, \pair1
	vmul.i16	\data1, \data1, \root
	vmla.i16	\data0, \tmp0, r10
	vmla.i16	\data1, \twist, r10
	vcmp.s16	lt, \data0, zr
	vpst
	vaddt.i16	\data0, \data0, r10
	vcmp.s16	lt, \data1, zr
	vpst
	vaddt.i16	\data1, \data1, r10
	.endm

	.macro	MQ_MVE_MMUL_DEADTW data, root, twist
	vqrdmulh.s16	\twist, \data, \twist
	vmul.i16	\data, \data, \root
	vmla.i16	\data, \twist, r10
	vcmp.s16	lt, \data, zr
	vpst
	vaddt.i16	\data, \data, r10
	.endm

	.macro	MQ_MVE_CT a, b, tmp, qv
	vadd.i16	\tmp, \a, \b
	vsub.i16	\tmp, \tmp, \qv
	vcmp.s16	lt, \tmp, zr
	vpst
	vaddt.i16	\tmp, \tmp, \qv
	vsub.i16	\b, \a, \b
	vcmp.s16	lt, \b, zr
	vpst
	vaddt.i16	\b, \b, \qv
	vmov	\a, \tmp
	.endm

@ Finish a CT butterfly from layer L while starting both twiddle products
@ needed by layer L+1.  The sum stays in tmp, so the dead old a register can
@ carry the first multiply temporary.  This is instruction-count neutral
@ with MQ_MVE_CT followed by two MQ_MVE_MMUL calls.
	.macro	MQ_MVE_CT_MUL2_CROSS_LAYER a, b, tmp, qv, pair_a, pair_b, twist
	vadd.i16	\tmp, \a, \b
	vsub.i16	\tmp, \tmp, \qv
	vcmp.s16	lt, \tmp, zr
	vpst
	vaddt.i16	\tmp, \tmp, \qv
	vsub.i16	\b, \a, \b
	vcmp.s16	lt, \b, zr
	vpst
	vaddt.i16	\b, \b, \qv

	@ Cross the layer boundary, then phase-group the independent products.
	MQ_MVE_MMUL2P_PHASE_GROUPED	\tmp, \b, \a, \qv, \twist, \pair_a, \pair_b
	vmov	\a, \tmp
	.endm

@ Packed counterpart for the 512 m=32/64 kernel.  q7/q6 hold two distinct
@ group twiddles in their low/high halves; q5 keeps the layer-L sum while the
@ dead old left operand carries multiply temporaries.
	.macro	MQ_MVE_CT_MUL2_PACKED_CROSS_LAYER a, b, tmp, pair_a_lo, pair_a_hi, pair_b_lo, pair_b_hi
	vadd.i16	\tmp, \a, \b
	vsub.i16	\tmp, \tmp, q7
	vcmp.s16	lt, \tmp, zr
	vpst
	vaddt.i16	\tmp, \tmp, q7
	vsub.i16	\b, \a, \b
	vcmp.s16	lt, \b, zr
	vpst
	vaddt.i16	\b, \b, q7

	@ Packed A/B twist phase.
	asr.w	r14, \pair_a_lo, #16
	vdup.16	q6, r14
	asr.w	r12, \pair_a_hi, #16
	uxth	r12, r12
	orr	r12, r12, r12, lsl #16
	vmov	d13, r12, r12
	vqrdmulh.s16	\a, \tmp, q6
	asr.w	r14, \pair_b_lo, #16
	vdup.16	q6, r14
	asr.w	r12, \pair_b_hi, #16
	uxth	r12, r12
	orr	r12, r12, r12, lsl #16
	vmov	d13, r12, r12
	vqrdmulh.s16	q6, \b, q6

	@ Packed A/B root and multiply phase.
	vdup.16	q7, \pair_a_lo
	uxth	r12, \pair_a_hi
	orr	r12, r12, r12, lsl #16
	vmov	d15, r12, r12
	vmul.i16	\tmp, \tmp, q7
	vdup.16	q7, \pair_b_lo
	uxth	r12, \pair_b_hi
	orr	r12, r12, r12, lsl #16
	vmov	d15, r12, r12
	vmul.i16	\b, \b, q7

	@ Shared correction phase.
	vmla.i16	\tmp, \a, r10
	vmla.i16	\b, q6, r10
	vcmp.s16	lt, \tmp, zr
	vpst
	vaddt.i16	\tmp, \tmp, r10
	vcmp.s16	lt, \b, zr
	vpst
	vaddt.i16	\b, \b, r10
	vmov	\a, \tmp
	.endm

	.macro	MQ_MVE_GS a, b, tmp1, tmp2, qv
	vadd.i16	\tmp1, \a, \b
	vsub.i16	\tmp1, \tmp1, \qv
	vcmp.s16	lt, \tmp1, zr
	vpst
	vaddt.i16	\tmp1, \tmp1, \qv
	vsub.i16	\b, \a, \b
	vcmp.s16	lt, \b, zr
	vpst
	vaddt.i16	\b, \b, \qv
	vmov.i16	\tmp2, #1
	vand	\tmp2, \tmp1, \tmp2
	vcmp.i16	ne, \tmp2, zr
	vpst
	vaddt.i16	\tmp1, \tmp1, \qv
	vshr.u16	\a, \tmp1, #1
	.endm

@ Complete a child GS (including its twiddle product), but issue the first
@ independent add of its parent GS between VMLA and the child's correction.
@ Then finish that parent.  This is exactly two original GS+MMUL sequences
@ with one parent-layer instruction pulled across the layer boundary.
	.macro	MQ_MVE_GS_CHILD_PARENT_CROSS_LAYER pleft, cleft, cright, child_pair, parent_pair, sumtmp, work, qv
	vadd.i16	\sumtmp, \cleft, \cright
	vsub.i16	\sumtmp, \sumtmp, \qv
	vcmp.s16	lt, \sumtmp, zr
	vpst
	vaddt.i16	\sumtmp, \sumtmp, \qv
	vsub.i16	\cright, \cleft, \cright
	vcmp.s16	lt, \cright, zr
	vpst
	vaddt.i16	\cright, \cright, \qv
	vmov.i16	\work, #1
	vand	\work, \sumtmp, \work
	vcmp.i16	ne, \work, zr
	vpst
	vaddt.i16	\sumtmp, \sumtmp, \qv
	vshr.u16	\cleft, \sumtmp, #1

	MQ_DUP_PAIR	\qv, \work, \child_pair
	vqrdmulh.s16	\sumtmp, \cright, \work
	vmul.i16	\cright, \cright, \qv
	vmla.i16	\cright, \sumtmp, r10
	@ cleft is now ready for the parent while cright awaits correction.
	vadd.i16	\sumtmp, \pleft, \cleft
	vcmp.s16	lt, \cright, zr
	vpst
	vaddt.i16	\cright, \cright, r10

	@ Original parent GS, continuing after its already-issued first add.
	vdup.16	\qv, r10
	vsub.i16	\sumtmp, \sumtmp, \qv
	vcmp.s16	lt, \sumtmp, zr
	vpst
	vaddt.i16	\sumtmp, \sumtmp, \qv
	vsub.i16	\cleft, \pleft, \cleft
	vcmp.s16	lt, \cleft, zr
	vpst
	vaddt.i16	\cleft, \cleft, \qv
	vmov.i16	\work, #1
	vand	\work, \sumtmp, \work
	vcmp.i16	ne, \work, zr
	vpst
	vaddt.i16	\sumtmp, \sumtmp, \qv
	vshr.u16	\pleft, \sumtmp, #1
	MQ_DUP_PAIR	\qv, \work, \parent_pair
	MQ_MVE_MMUL	\cleft, \qv, \sumtmp, \work
	.endm

@ Packed 512 counterpart of MQ_MVE_GS_CHILD_PARENT_CROSS_LAYER.  All packed
@ root/twist construction stays in its original loop; only arithmetic from
@ the dependent parent layer crosses the child-product correction.
	.macro	MQ_MVE_GS_CHILD_PARENT_PACKED_CROSS_LAYER pleft, cleft, cright, child_lo, child_hi, parent_lo, parent_hi, sumtmp, work, qv
	vadd.i16	\sumtmp, \cleft, \cright
	vsub.i16	\sumtmp, \sumtmp, \qv
	vcmp.s16	lt, \sumtmp, zr
	vpst
	vaddt.i16	\sumtmp, \sumtmp, \qv
	vsub.i16	\cright, \cleft, \cright
	vcmp.s16	lt, \cright, zr
	vpst
	vaddt.i16	\cright, \cright, \qv
	vmov.i16	\work, #1
	vand	\work, \sumtmp, \work
	vcmp.i16	ne, \work, zr
	vpst
	vaddt.i16	\sumtmp, \sumtmp, \qv
	vshr.u16	\cleft, \sumtmp, #1

	MQ_DUP_PACKED_PAIR_Q7_Q6	\child_lo, \child_hi
	vqrdmulh.s16	\sumtmp, \cright, q6
	vmul.i16	\cright, \cright, q7
	vmla.i16	\cright, \sumtmp, r10
	vadd.i16	\sumtmp, \pleft, \cleft
	vcmp.s16	lt, \cright, zr
	vpst
	vaddt.i16	\cright, \cright, r10

	vdup.16	\qv, r10
	vsub.i16	\sumtmp, \sumtmp, \qv
	vcmp.s16	lt, \sumtmp, zr
	vpst
	vaddt.i16	\sumtmp, \sumtmp, \qv
	vsub.i16	\cleft, \pleft, \cleft
	vcmp.s16	lt, \cleft, zr
	vpst
	vaddt.i16	\cleft, \cleft, \qv
	vmov.i16	\work, #1
	vand	\work, \sumtmp, \work
	vcmp.i16	ne, \work, zr
	vpst
	vaddt.i16	\sumtmp, \sumtmp, \qv
	vshr.u16	\pleft, \sumtmp, #1
	MQ_DUP_PACKED_PAIR_Q7_Q6	\parent_lo, \parent_hi
	MQ_MVE_MMUL	\cleft, q7, \sumtmp, q6
	.endm

@ MVE building blocks used only by the logn=9 three-layer experiment.
@ They retain the exact q=12289 relaxed representation and Montgomery
@ convention of the scalar Cortex-M4 implementation.

	.macro	MQ3_MVE_MMUL d, t0, t1, tw
	MQ_DUP_PAIR	\t1, \t0, \tw
	vqrdmulh.s16	\t0, \d, \t0
	vmul.i16	\d, \d, \t1
	vmla.i16	\d, \t0, r10
	vcmp.s16	lt, \d, zr
	vpst
	vaddt.i16	\d, \d, r10
	.endm

	.macro	MQ3_MVE_CT a, b, t0, t1
	vsub.i16	\t0, \a, \b
	vadd.i16	\a, \a, \b
	vdup.16	\t1, r10
	vsub.i16	\a, \a, \t1
	vcmp.s16	lt, \a, zr
	vpst
	vaddt.i16	\a, \a, \t1
	vcmp.s16	lt, \t0, zr
	vpst
	vaddt.i16	\t0, \t0, \t1
	vmov	\b, \t0
	.endm

@ Cross a CT layer boundary while retaining the selected S1 multiply order.
@ Scalar-vector forms remove twiddle broadcasts and lower vector pressure.
@ Same Barrett values/ranges; this changes instruction selection as well as
@ scheduling.  See REFERENCE/m55_ntt-ftt_opt.pdf pp.17-18.
	.macro	MQ3_MVE_CT_MUL2_CROSS_LAYER a, b, diff, quot, pair_a, pair_b
	@ Uniform twiddles stay packed in GPRs: low half=root, high half=twist.
	@ b dies after forming diff and becomes the first quotient temporary.
	@ Only a,b,diff,quot are touched, leaving q7 free for S3-B preloading.
	vsub.i16	\diff, \a, \b
	vadd.i16	\a, \a, \b
	vsub.i16	\a, \a, r10
	vcmp.s16	lt, \a, zr
	vpst
	vaddt.i16	\a, \a, r10
	@ S2-B: start the next layer before the difference correction.
	asr.w	r14, \pair_a, #16
	vqrdmulh.s16	\b, \a, r14
	vcmp.s16	lt, \diff, zr
	vpst
	vaddt.i16	\diff, \diff, r10
	asr.w	r14, \pair_b, #16
	vqrdmulh.s16	\quot, \diff, r14
	vmul.i16	\a, \a, \pair_a
	vmul.i16	\diff, \diff, \pair_b
	vmla.i16	\a, \b, r10
	vmla.i16	\diff, \quot, r10
	vcmp.s16	lt, \a, zr
	vpst
	vaddt.i16	\a, \a, r10
	vcmp.s16	lt, \diff, zr
	vpst
	vaddt.i16	\diff, \diff, r10
	vmov	\b, \diff
	.endm

	.macro	MQ3_MVE_GS a, b, t0, t1, t2, tw
	@ Preserve the difference before overwriting a with half(a+b).
	vsub.i16	\t0, \a, \b
	vdup.16	\t1, r10
	vcmp.s16	lt, \t0, zr
	vpst
	vaddt.i16	\t0, \t0, \t1
	vadd.i16	\a, \a, \b
	vsub.i16	\a, \a, \t1
	vcmp.s16	lt, \a, zr
	vpst
	vaddt.i16	\a, \a, \t1
	vmov.i16	\t2, #1
	vand	\t2, \a, \t2
	vcmp.i16	ne, \t2, zr
	vpst
	vaddt.i16	\a, \a, \t1
	vshr.u16	\a, \a, #1
	vmov	\b, \t0
	MQ3_MVE_MMUL	\b, \t1, \t2, \tw
	.endm

@ Pair a child GS and its dependent parent GS.  Once cleft is available,
@ begin the parent's difference on the integer pipe while the child twiddle
@ product is still being corrected.
	.macro	MQ3_MVE_GS_CHILD_PARENT_CROSS_LAYER pleft, cleft, cright, child_tw, parent_tw, t0, t1, t2
	@ Child GS butterfly.
	vsub.i16	\t0, \cleft, \cright
	vdup.16	\t1, r10
	vcmp.s16	lt, \t0, zr
	vpst
	vaddt.i16	\t0, \t0, \t1
	vadd.i16	\cleft, \cleft, \cright
	vsub.i16	\cleft, \cleft, \t1
	vcmp.s16	lt, \cleft, zr
	vpst
	vaddt.i16	\cleft, \cleft, \t1
	vmov.i16	\t2, #1
	vand	\t2, \cleft, \t2
	vcmp.i16	ne, \t2, zr
	vpst
	vaddt.i16	\cleft, \cleft, \t1
	vshr.u16	\cleft, \cleft, #1
	vmov	\cright, \t0

	@ Child twiddle multiplication, with the parent difference interleaved.
	MQ_DUP_PAIR	\t2, \t1, \child_tw
	vqrdmulh.s16	\t1, \cright, \t1
	vmul.i16	\cright, \cright, \t2
	vmla.i16	\cright, \t1, r10
	vsub.i16	\t0, \pleft, \cleft
	vcmp.s16	lt, \cright, zr
	vpst
	vaddt.i16	\cright, \cright, r10

	@ Parent GS, continuing after the first difference instruction.
	vdup.16	\t1, r10
	vcmp.s16	lt, \t0, zr
	vpst
	vaddt.i16	\t0, \t0, \t1
	vadd.i16	\pleft, \pleft, \cleft
	vsub.i16	\pleft, \pleft, \t1
	vcmp.s16	lt, \pleft, zr
	vpst
	vaddt.i16	\pleft, \pleft, \t1
	vmov.i16	\t2, #1
	vand	\t2, \pleft, \t2
	vcmp.i16	ne, \t2, zr
	vpst
	vaddt.i16	\pleft, \pleft, \t1
	vshr.u16	\pleft, \pleft, #1
	vmov	\cleft, \t0
	MQ3_MVE_MMUL	\cleft, \t1, \t2, \parent_tw
	.endm

@ MVE helpers used by the logn=10 two-layer kernels below.  They keep
@ the q=12289 Montgomery representation and the relaxed [0,Q] range of
@ the original Cortex-M4 implementation.  MQ_MUL_X8 preserves the
@ twiddle vector and uses two temporary vectors.

	.macro	MQ_MUL_X8 data, root, tmp, twist
	vqrdmulh.s16	\tmp, \data, \twist
	vmul.i16	\data, \data, \root
	vmla.i16	\data, \tmp, r10
	@ Exhaustive q=12289 analysis gives [-8447,8447]; one masked add
	@ restores the existing [0,q) contract.
	vcmp.s16	lt, \data, zr
	vpst
	vaddt.i16	\data, \data, r10
	.endm

@ Cooley--Tukey butterfly.  The right operand has already been
@ Montgomery-multiplied by its layer twiddle.
	.macro	MQ_CT_X8 left, right, tmp
	vadd.i16	\tmp, \left, \right
	vsub.i16	\tmp, \tmp, r10
	vcmp.s16	lt, \tmp, zr
	vpst
	vaddt.i16	\tmp, \tmp, r10
	vsub.i16	\right, \left, \right
	vcmp.s16	lt, \right, zr
	vpst
	vaddt.i16	\right, \right, r10
	vmov	\left, \tmp
	.endm

@ MQ_CT_X8 followed by the two next-layer products, reordered so that both
@ branches cross the layer boundary before the final two CT butterflies.
	.macro	MQ_CT_X8_MUL2_CROSS_LAYER left, right, tmp, pair_left, pair_right, rootv, twistv
	vadd.i16	\tmp, \left, \right
	vsub.i16	\tmp, \tmp, r10
	vcmp.s16	lt, \tmp, zr
	vpst
	vaddt.i16	\tmp, \tmp, r10
	vsub.i16	\right, \left, \right
	vcmp.s16	lt, \right, zr
	vpst
	vaddt.i16	\right, \right, r10

	MQ_MVE_MMUL2P_PHASE_GROUPED	\tmp, \right, \left, \rootv, \twistv, \pair_left, \pair_right
	vmov	\left, \tmp
	.endm

@ Gentleman--Sande butterfly.  The twiddle is supplied in a scalar GPR;
@ the macro leaves half(left+right) in left and
@ Montgomery((left-right)*twiddle) in right.
	.macro	MQ_GS_X8 left, right, twreg, tmp0, tmp1, tmp2
	vadd.i16	\tmp0, \left, \right
	vsub.i16	\tmp0, \tmp0, r10
	vcmp.s16	lt, \tmp0, zr
	vpst
	vaddt.i16	\tmp0, \tmp0, r10
	vsub.i16	\right, \left, \right
	vcmp.s16	lt, \right, zr
	vpst
	vaddt.i16	\right, \right, r10
	vmov.i16	\tmp1, #1
	vand	\tmp1, \tmp0, \tmp1
	vcmp.i16	ne, \tmp1, zr
	vpst
	vaddt.i16	\tmp0, \tmp0, r10
	vshr.u16	\left, \tmp0, #1
	MQ_DUP_PAIR	\tmp2, \tmp1, \twreg
	MQ_MUL_X8	\right, \tmp2, \tmp0, \tmp1
	.endm

@ Two dependent GS calls across adjacent layers.  The parent sum is issued
@ after the child VMLA but before its correction, overlapping independent
@ integer work with the multiply result chain.
	.macro	MQ_GS_X8_CHILD_PARENT_CROSS_LAYER pleft, cleft, cright, child_tw, parent_tw, tmp0, tmp1, tmp2
	@ Child GS.
	vadd.i16	\tmp0, \cleft, \cright
	vsub.i16	\tmp0, \tmp0, r10
	vcmp.s16	lt, \tmp0, zr
	vpst
	vaddt.i16	\tmp0, \tmp0, r10
	vsub.i16	\cright, \cleft, \cright
	vcmp.s16	lt, \cright, zr
	vpst
	vaddt.i16	\cright, \cright, r10
	vmov.i16	\tmp1, #1
	vand	\tmp1, \tmp0, \tmp1
	vcmp.i16	ne, \tmp1, zr
	vpst
	vaddt.i16	\tmp0, \tmp0, r10
	vshr.u16	\cleft, \tmp0, #1
	MQ_DUP_PAIR	\tmp2, \tmp1, \child_tw
	vqrdmulh.s16	\tmp0, \cright, \tmp1
	vmul.i16	\cright, \cright, \tmp2
	vmla.i16	\cright, \tmp0, r10
	@ First parent operation crosses the layer boundary here.
	vadd.i16	\tmp0, \pleft, \cleft
	vcmp.s16	lt, \cright, zr
	vpst
	vaddt.i16	\cright, \cright, r10

	@ Parent GS after its first add.
	vsub.i16	\tmp0, \tmp0, r10
	vcmp.s16	lt, \tmp0, zr
	vpst
	vaddt.i16	\tmp0, \tmp0, r10
	vsub.i16	\cleft, \pleft, \cleft
	vcmp.s16	lt, \cleft, zr
	vpst
	vaddt.i16	\cleft, \cleft, r10
	vmov.i16	\tmp1, #1
	vand	\tmp1, \tmp0, \tmp1
	vcmp.i16	ne, \tmp1, zr
	vpst
	vaddt.i16	\tmp0, \tmp0, r10
	vshr.u16	\pleft, \tmp0, #1
	MQ_DUP_PAIR	\tmp2, \tmp1, \parent_tw
	MQ_MUL_X8	\cleft, \tmp2, \tmp0, \tmp1
	.endm

@ =======================================================================
@ void fndsa_mqpoly_small_to_int(unsigned logn, const int8_t *f, uint16_t *d)
@ =======================================================================

	.align	2
	.global	fndsa_mqpoly_small_to_int
	.thumb
	.thumb_func
	.type	fndsa_mqpoly_small_to_int, %function
fndsa_mqpoly_small_to_int:
	@ This implementation actually normalizes to [1,q] (strict internal
	@ representation).
	push	{ r4, r5, r6, r7 }
	@ Set r3 to n = 2^logn
	movs	r3, #1
	lsls	r3, r0
	@ Set both halves of r0 to Q
	movw	r0, #Q
	movt	r0, #Q
	@ Set both halves of r7 to 1
	mov	r7, #0x00010001
fndsa_mqpoly_small_to_int__L1:
	@ Get next four source bytes.
	ldr	r5, [r1], #4
	@ Expand bytes to 16-bit each; for each byte whose value is negative
	@ or zero, we need to add Q.
	sxtb16	r4, r5
	sadd16	r6, r4, r0
	ssub16	r12, r4, r7
	sel	r4, r4, r6
	sxtb16	r5, r5, ror #8
	sadd16	r6, r5, r0
	ssub16	r12, r5, r7
	sel	r5, r5, r6
	@ We need to interleave the values to get them in the right order.
	pkhtb	r6, r5, r4, asr #16
	pkhbt	r5, r4, r5, lsl #16
	@ We can use strd because the caller ensured that the output is
	@ aligned.
	strd	r5, r6, [r2], #8
	subs	r3, #4
	bne	fndsa_mqpoly_small_to_int__L1

	pop	{ r4, r5, r6, r7 }
	bx	lr
	.size	fndsa_mqpoly_small_to_int,.-fndsa_mqpoly_small_to_int

@ =======================================================================
@ void fndsa_mqpoly_signed_to_int(unsigned logn, uint16_t *d)
@ =======================================================================

	.align	2
	.global	fndsa_mqpoly_signed_to_int
	.thumb
	.thumb_func
	.type	fndsa_mqpoly_signed_to_int, %function
fndsa_mqpoly_signed_to_int:
	@ This implementation actually normalizes to [1,q] (strict internal
	@ representation).
	push	{ r4, r5, r6 }
	movs	r3, #1
	lsls	r3, r0
	@ Set both halves of r0 to Q
	movw	r0, #Q
	movt	r0, #Q
	@ Set both halves of r2 to 1
	mov	r2, #0x00010001
fndsa_mqpoly_signed_to_int__L1:
	@ We can use ldrd because the caller ensured that the input is
	@ aligned.
	ldrd	r4, r5, [r1]
	@ For each word half, we want to add q if the value is negative or 0.
	sadd16	r6, r4, r0
	ssub16	r12, r4, r2
	sel	r4, r4, r6
	sadd16	r6, r5, r0
	ssub16	r12, r5, r2
	sel	r5, r5, r6
	strd	r4, r5, [r1], #8
	subs	r3, #4
	bne	fndsa_mqpoly_signed_to_int__L1

	pop	{ r4, r5, r6 }
	bx	lr
	.size	fndsa_mqpoly_signed_to_int,.-fndsa_mqpoly_signed_to_int

@ =======================================================================
@ void fndsa_mqpoly_int_to_ext(unsigned logn, uint16_t *d)
@ =======================================================================

	.align	2
	.global	fndsa_mqpoly_int_to_ext
	.thumb
	.thumb_func
	.type	fndsa_mqpoly_int_to_ext, %function
fndsa_mqpoly_int_to_ext:
	push.w	{ r4, r5, r6 }
	movs	r3, #1
	lsls	r3, r0
	@ Set both halves of r0 to Q
	movw	r0, #Q
	movt	r0, #Q
	@ Set both halves of r2 to 0xFFFF
	mov	r2, #0xFFFFFFFF
	@ Set r6 to zero
	movw	r6, #0
fndsa_mqpoly_int_to_ext__L1:
	@ We can use ldrd because the caller ensured that the input is
	@ aligned.
	ldrd	r4, r5, [r1]
	@ Each word half equal to q must be set to 0; others are untouched.
	ssub16	r12, r4, r0
	sel	r4, r6, r4
	ssub16	r12, r5, r0
	sel	r5, r6, r5
	strd	r4, r5, [r1], #8
	subs	r3, #4
	bne	fndsa_mqpoly_int_to_ext__L1

	pop	{ r4, r5, r6 }
	bx	lr
	.size	fndsa_mqpoly_int_to_ext,.-fndsa_mqpoly_int_to_ext

@ =======================================================================
@ void fndsa_mqpoly_mul_ntt(unsigned logn, uint16_t *a, const uint16_t *b)
@ =======================================================================

	.align	2
	.global	fndsa_mqpoly_mul_ntt
	.thumb
	.thumb_func
	.type	fndsa_mqpoly_mul_ntt, %function
fndsa_mqpoly_mul_ntt:
	push.w	{ r4, r5, r6, r7, r8, r10, lr }
	movs	r3, #1
	lsls	r3, r0

	@ r10 <- q
	movw	r10, #Q
	@ r14 <- -1/q mod 2^32
	movw	r14, #(Q1I & 0xFFFF)
	movt	r14, #(Q1I >> 16)
	@ r0 <- 2^64 mod q
	movw	r0, #R2

	@ r12 is a temporary

fndsa_mqpoly_mul_ntt__L1:
	@ A sequence of four ldr is faster than two ldrd or two ldm.
	ldr	r5, [r1]
	ldr	r6, [r1, #4]
	ldr.w	r7, [r2], #4
	ldr.w	r8, [r2], #4

	@ First pair of words (r5 and r7)
	@ Products over integers.
	smulbb	r4, r5, r7
	smultt	r5, r5, r7
	@ Montgomery reduction.
	mul	r12, r4, r14
	umaal	r14, r4, r12, r10
	mul	r12, r5, r14
	umaal	r14, r5, r12, r10
	@ Conversion Montgomery -> normal
	muls	r4, r0
	muls	r5, r0
	mul	r12, r4, r14
	umaal	r14, r4, r12, r10
	mul	r12, r5, r14
	umaal	r14, r5, r12, r10
	@ Repack the two output values and write word
	pkhbt	r7, r4, r5, lsl #16
	str.w	r7, [r1], #4

	@ Second pair of words (r6 and r8)
	@ Products over integers.
	smulbb	r4, r6, r8
	smultt	r5, r6, r8
	@ Montgomery reduction.
	mul	r12, r4, r14
	umaal	r14, r4, r12, r10
	mul	r12, r5, r14
	umaal	r14, r5, r12, r10
	@ Conversion Montgomery -> normal
	muls	r4, r0
	muls	r5, r0
	mul	r12, r4, r14
	umaal	r14, r4, r12, r10
	mul	r12, r5, r14
	umaal	r14, r5, r12, r10
	@ Repack the two output values and write word
	pkhbt	r8, r4, r5, lsl #16
	str.w	r8, [r1], #4

	@ Store the four output values.
	subs	r3, #4
	bne	fndsa_mqpoly_mul_ntt__L1

	pop	{ r4, r5, r6, r7, r8, r10, pc }
	.size	fndsa_mqpoly_mul_ntt,.-fndsa_mqpoly_mul_ntt

@ =======================================================================
@ void fndsa_mqpoly_sub(unsigned logn, uint16_t *a, const uint16_t *b)
@ =======================================================================

	.align	2
	.global	fndsa_mqpoly_sub
	.thumb
	.thumb_func
	.type	fndsa_mqpoly_sub, %function
fndsa_mqpoly_sub:
	push.w	{ r4, r5, r6, r7, lr }
	movs	r3, #1
	lsls	r3, r0

	@ r0 <- 0
	movw	r0, #0
	@ r14 <- q (both halves)
	movw	r14, #Q
	movt	r14, #Q

fndsa_mqpoly_sub__L1:
	@ Four ldr are faster than two ldrd or two ldm.
	ldr	r4, [r1]
	ldr	r5, [r1, #4]
	ldr.w	r6, [r2], #4
	ldr.w	r7, [r2], #4

	@ We do the subtraction over the integers, then add q back if
	@ the result is negative.
	ssub16	r4, r4, r6
	sel	r12, r0, r14
	sadd16	r4, r4, r12
	str.w	r4, [r1], #4
	ssub16	r5, r5, r7
	sel	r12, r0, r14
	sadd16	r5, r5, r12
	str.w	r5, [r1], #4

	subs	r3, #4
	bne	fndsa_mqpoly_sub__L1

	pop	{ r4, r5, r6, r7, pc }
	.size	fndsa_mqpoly_sub,.-fndsa_mqpoly_sub

@ =======================================================================
@ void fndsa_mqpoly_add(unsigned logn, uint16_t *a, const uint16_t *b)
@ =======================================================================

	.align	2
	.global	fndsa_mqpoly_add
	.thumb
	.thumb_func
	.type	fndsa_mqpoly_add, %function
fndsa_mqpoly_add:
	push.w	{ r4, r5, r6, r7, lr }
	movs	r3, #1
	lsls	r3, r0

	@ r14 <- q (both halves)
	movw	r14, #Q
	movt	r14, #Q

fndsa_mqpoly_add__L1:
	@ Four ldr are faster than two ldrd or two ldm.
	ldr	r4, [r1]
	ldr	r5, [r1, #4]
	ldr.w	r6, [r2], #4
	ldr.w	r7, [r2], #4

	@ We do the addition over the integers, then subtract q, but
	@ discard the subtraction if the result is negative.
	sadd16	r4, r4, r6
	ssub16	r12, r4, r14
	sel	r4, r12, r4
	str.w	r4, [r1], #4
	sadd16	r5, r5, r7
	ssub16	r12, r5, r14
	sel	r5, r12, r5
	str.w	r5, [r1], #4

	subs	r3, #4
	bne	fndsa_mqpoly_add__L1

	pop	{ r4, r5, r6, r7, pc }
	.size	fndsa_mqpoly_add,.-fndsa_mqpoly_add

@ =======================================================================
@ uint32_t fndsa_mqpoly_sqnorm_signed(unsigned logn, const uint16_t *a)
@ =======================================================================

	.align	2
	.global	fndsa_mqpoly_sqnorm_signed
	.thumb
	.thumb_func
	.type	fndsa_mqpoly_sqnorm_signed, %function
fndsa_mqpoly_sqnorm_signed:
	movs	r3, #1
	lsls	r3, r0

	movw	r0, #0
fndsa_mqpoly_sqnorm_signed__L1:
	@ We can use ldrd because the caller ensured that the input is
	@ aligned.
	ldrd	r2, r12, [r1], #8
	smlad	r0, r2, r2, r0
	smlad	r0, r12, r12, r0
	@ The whole operation cannot overflow in unsigned convention,
	@ since signed values are at most 2047 (in absolute value) and
	@ there are at most 1024 of them, hence a maximum squared norm
	@ of 1024*2047*2047 = 4290774016, which fits on 32 bits.
	subs	r3, #4
	bne	fndsa_mqpoly_sqnorm_signed__L1

	bx	lr
	.size	fndsa_mqpoly_sqnorm_signed,.-fndsa_mqpoly_sqnorm_signed

@ =======================================================================
@ uint32_t fndsa_mqpoly_sqnorm_binf_int(unsigned logn, const uint16_t *a)
@ =======================================================================

	.align	2
	.global	fndsa_mqpoly_sqnorm_binf_int
	.thumb
	.thumb_func
	.type	fndsa_mqpoly_sqnorm_binf_int, %function
fndsa_mqpoly_sqnorm_binf_int:
	push.w	{ r4, r5, r6, r7, lr }
	movs	r3, #1
	lsls	r3, r0

	@ r5 <- q (in both halves)
	movw	r5, #Q
	movt	r5, #Q
	@ r6 <- ceil(q/2) (in both halves)
	movw	r6, #((Q + 1) >> 1)
	movt	r6, #((Q + 1) >> 1)
	@ r12 <- B_INF (in both halves)
	movw	r14, #B_INF
	movt	r14, #B_INF

	movw	r0, #0
	@ We clear the Q flag, which we will use to detect overflows.
	msr	APSR_nzcvq, r0
fndsa_mqpoly_sqnorm_binf_int__L1:
	@ We can use ldrd because the caller ensured that the input is
	@ aligned.
	ldrd	r2, r4, [r1], #8

	@ Normalize values to [-q/2,+q/2]
	ssub16	r7, r2, r5
	ssub16	r12, r2, r6
	sel	r2, r7, r2
	ssub16	r7, r4, r5
	ssub16	r12, r4, r6
	sel	r4, r7, r4
	@ If any addition overflows (signed interpretation), then the Q
	@ flag will be set.
	smlad	r0, r2, r2, r0
	smlad	r0, r4, r4, r0
	@ Also check the L-infinity norm. For each signed value z (half of
	@ r2 or r4), B_INF - z and B_INF + z must be non-negative. usat16
	@ will set the Q flag whenever a signed value saturates (i.e. is
	@ negative).
	ssub16	r7, r14, r2
	sadd16	r2, r14, r2
	usat16	r7, #15, r7
	usat16	r2, #15, r2
	ssub16	r7, r14, r4
	sadd16	r4, r14, r4
	usat16	r7, #15, r7
	usat16	r4, #15, r4

	subs	r3, #4
	bne	fndsa_mqpoly_sqnorm_binf_int__L1

	@ If the Q flag is set, saturate the returned value to 0xFFFFFFFF
	mrs	r1, APSR
	sbfx	r1, r1, #27, #1
	orrs	r0, r1

	pop	{ r4, r5, r6, r7, pc }
	.size	fndsa_mqpoly_sqnorm_binf_int,.-fndsa_mqpoly_sqnorm_binf_int

@ =======================================================================
@ uint32_t fndsa_mqpoly_sqnorm_int_to_signed(unsigned logn, uint16_t *a)
@ =======================================================================

	.align	2
	.global	fndsa_mqpoly_sqnorm_int_to_signed
	.thumb
	.thumb_func
	.type	fndsa_mqpoly_sqnorm_int_to_signed, %function
fndsa_mqpoly_sqnorm_int_to_signed:
	push.w	{ r4, r5, r6, r7 }
	movs	r3, #1
	lsls	r3, r0

	@ r5 <- q (in both halves)
	movw	r5, #Q
	movt	r5, #Q
	@ r6 <- ceil(q/2) (in both halves)
	movw	r6, #((Q + 1) >> 1)
	movt	r6, #((Q + 1) >> 1)

	movw	r0, #0
	@ We clear the Q flag, which we will use to detect overflows.
	msr	APSR_nzcvq, r0
fndsa_mqpoly_sqnorm_int_to_signed__L1:
	@ We can use ldrd because the caller ensured that the input is
	@ aligned.
	ldrd	r2, r4, [r1]

	@ Normalize values to [-q/2,+q/2]
	ssub16	r7, r2, r5
	ssub16	r12, r2, r6
	sel	r2, r7, r2
	str	r2, [r1], #4
	ssub16	r7, r4, r5
	ssub16	r12, r4, r6
	sel	r4, r7, r4
	str	r4, [r1], #4

	@ If any addition overflows (signed interpretation), then the Q
	@ flag will be set.
	smlad	r0, r2, r2, r0
	smlad	r0, r4, r4, r0
	subs	r3, #4
	bne	fndsa_mqpoly_sqnorm_int_to_signed__L1

	@ If the Q flag is set, saturate the returned value to 0xFFFFFFFF
	mrs	r1, APSR
	sbfx	r1, r1, #27, #1
	orrs	r0, r1

	pop	{ r4, r5, r6, r7 }
	bx	lr
	.size	fndsa_mqpoly_sqnorm_int_to_signed,.-fndsa_mqpoly_sqnorm_int_to_signed
	.align	2
fndsa_mqpoly_int_to_ntt__gmaddr_plus1_near:
	.word	fndsa_mq_GM + 2
fndsa_mqpoly_int_to_ntt__stage3_gmaddrs:
	.word	fndsa_mq_barrett3_GM
	.word	fndsa_mq_barrett3_GM_twist

@ =======================================================================
@ void fndsa_mqpoly_int_to_ntt(unsigned logn, uint16_t *d)
@ =======================================================================

	.align	2
	.global	fndsa_mqpoly_int_to_ntt
	.thumb
	.thumb_func
	.type	fndsa_mqpoly_int_to_ntt, %function
fndsa_mqpoly_int_to_ntt:
	push.w	{ r0, r4, r5, r6, r7, r8, r9, r10, r11, lr }
	vpush	{ d8-d15 }      @ q4-q7 (s16-s31) are callee-saved
	vmov	s0, r0          @ public logn; q0 otherwise holds scalar state

	@ ASSUMPTION: logn >= 2

	@ State:
	@   r0    0
	@   r1    &d[j1]
	@   r2    t = ht*2
	@   r3    middle loop counter
	@   r6    s
	@   r7    innermost loop counter
	@   r8    &mq_GM[i + m]
	@   r10   q
	@   r11   q:q
	@   r12   scratch
	@   r14   -1/q mod 2^32
	@
	@   s2    d
	@   s3    m

	vmov	s2, r1         @ original &d[0]
	movs	r2, #1
	lsls	r2, r0         @ r2 <- t = ht*2 (initially equal to n)
	movw	r0, #1         @ m <- 1
	vmov	s3, r0

	@ Constants.
	@ r0 <- 0
	movw	r0, #0
	@ r10 <- q
	movw	r10, #Q
	@ r11 <- q (both halves)
	orr	r11, r10, r10, lsl #16
	@ r14 <- -1/q mod 2^32
	movw	r14, #(Q1I & 0xFFFF)
	movt	r14, #(Q1I >> 16)

	@ q=12289 stage-3 tables are used only by FN-DSA-512/1024.
	@ r0 has already been cleared above; recover the public logn saved
	@ in s0 before selecting the table pair.
	vmov	r12, s0
	cmp	r12, #9
	blo	fndsa_mqpoly_int_to_ntt__legacy_gm
	adr	r12, fndsa_mqpoly_int_to_ntt__stage3_gmaddrs
	ldmia.w	r12, { r8, r9 }
	sub.w	r9, r9, r8
	add.w	r8, r8, #2
	b	fndsa_mqpoly_int_to_ntt__gm_ready
fndsa_mqpoly_int_to_ntt__legacy_gm:
	adr	r8, fndsa_mqpoly_int_to_ntt__gmaddr_plus1_near
	ldr	r8, [r8]
	movs	r9, #0
fndsa_mqpoly_int_to_ntt__gm_ready:

	@ FN-DSA-512 mixed schedule, first pass: fuse m=1 and m=2.
	@ This block is identical to the common CT2 pass in 512_2layer; after
	@ it, the candidate diverts to the m=4,8,16 three-layer kernel.
	cmp	r2, #512
	bne.w	fndsa_mqpoly_int_to_ntt__L512_not
	movw	r2, #256
	movs	r11, #1
	add.w	r0, r8, #2
	vmov	r1, s2

fndsa_mqpoly_int_to_ntt__L512_CT2_pass:
	vmov	s3, r11
fndsa_mqpoly_int_to_ntt__L512_CT2_group:
	MQ_LOAD_PAIR	r5, r8
	MQ_LOAD_PAIR	r6, r0
	MQ_LOAD_PAIR	r7, r0
	lsr.w	r3, r2, #4
fndsa_mqpoly_int_to_ntt__L512_CT2_chunk:
	@ SLOTHY B: halving pipeline a; (b;a)^(N-1); b.
	sub.w	r3, r3, #1
	vldrh.u16	q4, [r1]
	add.w	r4, r1, r2
	vldrh.u16	q2, [r4]
	add.w	r4, r4, r2
	asr.w	r14, r5, #16
	vdup.16	q5, r14
	vldrh.u16	q1, [r4]
	vdup.16	q6, r5
	vqrdmulh.s16	q3, q1, q5
	add.w	r4, r4, r2
	vmul.i16	q1, q1, q6
	vdup.16	q7, r10
	vmla.i16	q1, q3, r10
	vcmp.s16	lt, q1, zr
	vpst
	vaddt.i16	q1, q1, r10
	asr.w	r14, r6, #16
	vadd.i16	q3, q4, q1
	vsub.i16	q3, q3, q7
	vsub.i16	q1, q4, q1
	vldrh.u16	q4, [r4]
	vcmp.s16	lt, q1, zr
	vpst
	vaddt.i16	q1, q1, q7
	add.w	r4, r1, r2
	vqrdmulh.s16	q5, q4, q5
	vcmp.s16	lt, q3, zr
	vpst
	vaddt.i16	q3, q3, q7
	vmul.i16	q4, q4, q6
	vmla.i16	q4, q5, r10
	vdup.16	q6, r14
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	asr.w	r14, r7, #16
	vadd.i16	q5, q2, q4
	vsub.i16	q4, q2, q4
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q7
	vmov	q3, q3
	vsub.i16	q5, q5, q7
fndsa_mqpoly_int_to_ntt__L512_CT2_chunk_slothyB_kernel:
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q7
	vdup.16	q2, r6
	vqrdmulh.s16	q7, q5, q6
	vdup.16	q6, r14
	vmul.i16	q5, q5, q2
	vdup.16	q2, r7
	vmla.i16	q5, q7, r10
	vdup.16	q7, r10
	vqrdmulh.s16	q6, q4, q6
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, r10
	vmul.i16	q4, q4, q2
	asr.w	r14, r5, #16
	vmla.i16	q4, q6, r10
	vmov	q5, q5
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	vadd.i16	q6, q1, q4
	vsub.i16	q4, q1, q4
	vadd.i16	q1, q3, q5
	vsub.i16	q1, q1, q7
	vcmp.s16	lt, q1, zr
	vpst
	vaddt.i16	q1, q1, q7
	vmov	q2, q1
	vsub.i16	q5, q3, q5
	vstrh.16	q2, [r1]
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q7
	add.w	r1, r1, #16
	vsub.i16	q6, q6, q7
	vstrh.16	q5, [r4]
	vcmp.s16	lt, q6, zr
	vpst
	vaddt.i16	q6, q6, q7
	add.w	r4, r4, r2
	vmov	q6, q6
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q7
	vstrh.16	q6, [r4]
	add.w	r4, r4, r2
	vstrh.16	q4, [r4]
	add.w	r4, r1, r2
	vdup.16	q5, r14
	vldrh.u16	q6, [r1]
	vdup.16	q3, r5
	vldrh.u16	q2, [r4]
	add.w	r4, r4, r2
	vldrh.u16	q1, [r4]
	add.w	r4, r4, r2
	vqrdmulh.s16	q4, q1, q5
	vdup.16	q7, r10
	vmul.i16	q1, q1, q3
	asr.w	r14, r6, #16
	vmla.i16	q1, q4, r10
	vldrh.u16	q4, [r4]
	vcmp.s16	lt, q1, zr
	vpst
	vaddt.i16	q1, q1, r10
	vqrdmulh.s16	q5, q4, q5
	add.w	r4, r1, r2
	vmul.i16	q4, q4, q3
	vadd.i16	q3, q6, q1
	vmla.i16	q4, q5, r10
	vsub.i16	q3, q3, q7
	vsub.i16	q1, q6, q1
	vcmp.s16	lt, q1, zr
	vpst
	vaddt.i16	q1, q1, q7
	vcmp.s16	lt, q3, zr
	vpst
	vaddt.i16	q3, q3, q7
	vdup.16	q6, r14
	asr.w	r14, r7, #16
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	vadd.i16	q5, q2, q4
	vsub.i16	q4, q2, q4
	vmov	q3, q3
	vsub.i16	q5, q5, q7
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q7
	subs	r3, #1
	bne	fndsa_mqpoly_int_to_ntt__L512_CT2_chunk_slothyB_kernel
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q7
	vdup.16	q2, r6
	vqrdmulh.s16	q7, q5, q6
	vdup.16	q6, r14
	vmul.i16	q5, q5, q2
	vdup.16	q2, r7
	vmla.i16	q5, q7, r10
	vdup.16	q7, r10
	vqrdmulh.s16	q6, q4, q6
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, r10
	vmul.i16	q4, q4, q2
	vmla.i16	q4, q6, r10
	vmov	q2, q5
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	vadd.i16	q5, q1, q4
	vsub.i16	q4, q1, q4
	vadd.i16	q1, q3, q2
	vsub.i16	q1, q1, q7
	vcmp.s16	lt, q1, zr
	vpst
	vaddt.i16	q1, q1, q7
	vmov	q1, q1
	vsub.i16	q2, q3, q2
	vstrh.16	q1, [r1]
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, q7
	add.w	r1, r1, #16
	vsub.i16	q5, q5, q7
	vstrh.16	q2, [r4]
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q7
	add.w	r4, r4, r2
	vmov	q3, q5
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q7
	vstrh.16	q3, [r4]
	add.w	r4, r4, r2
	vstrh.16	q4, [r4]
	add.w	r1, r1, r2, lsl #1
	add.w	r1, r1, r2
	vmov	r3, s3
	subs	r3, #1
	vmov	s3, r3
	bne.w	fndsa_mqpoly_int_to_ntt__L512_CT2_group

	@ Evolve GM pointers from m=1/2 to m=4, the start of CT3.
	add.w	r8, r8, r11, lsl #2
	add.w	r0, r0, r11, lsl #3
	lsl.w	r11, r11, #2
	lsr.w	r2, r2, #2
	vmov	r1, s2
	b	fndsa_mqpoly_int_to_ntt__L3x512

fndsa_mqpoly_int_to_ntt__L512_not:
	@ FN-DSA-1024: use the dedicated four CT2-pair path.
	cmp	r2, #1024
	beq	fndsa_mqpoly_int_to_ntt__F2_setup

	@ If n = 4, then skip directly to the specialized code for the
	@ last two iterations.
	cmp	r2, #4
	beq	fndsa_mqpoly_int_to_ntt__L4

fndsa_mqpoly_int_to_ntt__L1:
	@ Middle loop has m iterations.
	vmov	r3, s3
	lsl	r6, r3, #1     @ prepare m for next iteration
	vmov	s3, r6
	@ In the 512 mixed candidate, replace layers m=4,8,16 with one
	@ depth-first three-layer kernel.  All other public sizes and layers
	@ continue through the original loop.
	cmp	r3, #4
	bne	fndsa_mqpoly_int_to_ntt__L2
	vmov	r4, s0
	cmp	r4, #9
	beq	fndsa_mqpoly_int_to_ntt__L3x512
fndsa_mqpoly_int_to_ntt__L2:
	ldrh	r6, [r8], #2   @ s <- mq_GM[i + m]
	lsr	r7, r2, #1     @ r7 <- ht

	@ Process eight butterflies per iteration whenever ht >= 8.  q0 is
	@ deliberately left untouched: s2 and s3 hold persistent scalar state.
	@ q4 is preserved in the function prologue/epilogue as required by AAPCS.
	cmp	r7, #8
	blo	fndsa_mqpoly_int_to_ntt__L3
fndsa_mqpoly_int_to_ntt__L3_mve:
	@ q1 <- x1[0..7], q2 <- x2[0..7], q3 <- s replicated.
	@ r4 points to the second half of this butterfly group.
	add.w	r4, r1, r2
	vldrh.u16	q1, [r1]
	vldrh.u16	q2, [r4]
	vmov.i32	q3, #0
	vcmp.i16	eq, q2, q3       @ remember lanes whose input is exactly 0
	vdup.16	q3, r6

	@ Eight parallel Montgomery products mmul(x2, s).  This is the same
	@ 16-bit decomposition as mq_mred_x8() in the portable SIMD code:
	@   lo = low16(x2*s), hi = high16(x2*s)
	@   z  = high16(lo*Q1ILO) + low16(lo*Q1IHI)
	@        + low16(hi*Q1ILO)              (mod 2^16)
	@   x2 = high16(z*Q) + 1
	@ For non-zero x2 this equals the Cortex-M4 UMAAL result.  For x2=0,
	@ the decomposition yields 1 while UMAAL yields 0, so the remembered
	@ input-zero predicate cancels that +1 on those lanes only.
	vmulh.u16	q4, q2, q3       @ hi
	vmul.i16	q2, q2, q3       @ lo
	vdup.16	q3, r14            @ Q1ILO (low half of Q1I)
	vmulh.u16	q3, q2, q3       @ high16(lo*Q1ILO)
	movw	r12, #Q1IHI
	vmul.i16	q2, q2, r12      @ low16(lo*Q1IHI)
	vmul.i16	q4, q4, r14      @ low16(hi*Q1ILO)
	vadd.i16	q2, q2, q4
	vadd.i16	q2, q2, q3
	vdup.16	q3, r10            @ Q
	vmulh.u16	q2, q2, q3
	movs	r12, #1
	vadd.i16	q2, q2, r12
	vpst
	vsubt.i16	q2, q2, r12

	@ Butterfly outputs, normalized to the Cortex-M4-compatible relaxed
	@ internal range [0,Q].
	@ Predication depends on lane values but executes no secret branch and
	@ does not alter the memory access pattern.
	vadd.i16	q4, q1, q2
	vsub.i16	q4, q4, q3
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q3
	vstrh.16	q4, [r1]

	vsub.i16	q4, q1, q2
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q3
	vstrh.16	q4, [r4]

	add.w	r1, r1, #16
	subs	r7, #8
	bne	fndsa_mqpoly_int_to_ntt__L3_mve
	b	fndsa_mqpoly_int_to_ntt__L3_done

fndsa_mqpoly_int_to_ntt__L3:
	@ Each inner loop iteration processes two pairs (x1,x2) and (y1,y2).
	ldr.w	r4, [r1, r2]   @ r4 <- x2:y2

	@ r5 <- mmul(y2, s)
	smultb	r5, r4, r6
	mul	r12, r5, r14
	umaal	r14, r5, r12, r10
	@ r4 <- mmul(x2, s)
	smulbb	r4, r4, r6
	mul	r12, r4, r14
	umaal	r14, r4, r12, r10
	@ r5 <- x2:y2
	pkhbt	r5, r4, r5, lsl #16

	@ r4 <- x1:y1
	ldr.w	r4, [r1]       @ r4 <- x1:y1

	@ d[j1] <- x1+x2 : y1+y2
	@ d[j2] <- x1-x2 : y1-y2
	sadd16	r12, r4, r5
	ssub16	r5, r4, r5
	sel	r4, r0, r11
	sadd16	r5, r5, r4
	str.w	r5, [r1, r2]
	ssub16	r4, r12, r11
	sel	r4, r4, r12
	str.w	r4, [r1], #4

	@ loop ht/2 times
	subs	r7, #2
	bne	fndsa_mqpoly_int_to_ntt__L3

fndsa_mqpoly_int_to_ntt__L3_done:

	@ ---------------------------

	@ j0 <- j0 + t
	@ j0 is implicit in r1, which has been increased for ht elements,
	@ hence we add ht here (ht*2, since elements are 2-byte values)
	add.w	r1, r1, r2
	@ We loop m times
	subs	r3, #1
	bne	fndsa_mqpoly_int_to_ntt__L2

	@ r1 now contains &d[n], we must reset it to &d[0] for the next
	@ iteration.
	vmov	r1, s2

	@ replace t with ht
	@ Loop until t reaches 2
	lsr	r2, r2, #1
	cmp	r2, #4
	bne	fndsa_mqpoly_int_to_ntt__L1
	b	fndsa_mqpoly_int_to_ntt__L4

@ Three forward layers for logn=9: m=4,8,16 (t=128,64,32).
@ Four 128-coefficient blocks are processed depth-first.  Within each
@ block the four upper streams stay in q0-q3; only the four lower streams
@ are written once to their canonical locations and reloaded.  Thus the
@ intermediate traffic is one half-block, not two complete arrays.
fndsa_mqpoly_int_to_ntt__L3x512:
	sub	sp, sp, #16
	vmov	r12, s2
	str	r8, [sp, #0]       @ p0 = &GM[4]
	add.w	r4, r8, #8
	str	r4, [sp, #4]       @ p1 = &GM[8]
	add.w	r4, r8, #24
	str	r4, [sp, #8]       @ p2 = &GM[16]
	str	r12, [sp, #12]     @ original d
	mov	r1, r12
	movs	r3, #4

fndsa_mqpoly_int_to_ntt__L3x512_block:
	@ Seven twiddles for this radix-8 block: 1 + 2 + 4.
	ldr	r12, [sp, #0]
	MQ_LOAD_PAIR	r4, r12
	str	r12, [sp, #0]
	ldr	r12, [sp, #4]
	MQ_LOAD_PAIR	r5, r12
	MQ_LOAD_PAIR	r6, r12
	str	r12, [sp, #4]
	ldr	r12, [sp, #8]
	MQ_LOAD_PAIR	r7, r12
	MQ_LOAD_PAIR	r8, r12
	MQ_LOAD_PAIR	r11, r12
	MQ_LOAD_PAIR	r0, r12
	str	r12, [sp, #8]

	movs	r2, #2            @ two groups of eight lanes
fndsa_mqpoly_int_to_ntt__L3x512_lanes:
	@ SLOTHY B: halving pipeline a; (b;a)^(N-1); b.
	sub.w	r2, r2, #1
	vldrh.u16	q0, [r1]
	add.w	r12, r1, #32
	vldrh.u16	q1, [r12]
	add.w	r12, r1, #64
	vldrh.u16	q2, [r12]
	add.w	r12, r1, #96
	vldrh.u16	q3, [r12]
	add.w	r12, r1, #128
	asr.w	r14, r4, #16
	vdup.16	q6, r14
	vldrh.u16	q5, [r12]
	vdup.16	q4, r4
	vqrdmulh.s16	q6, q5, q6
	asr.w	r14, r4, #16
	vmul.i16	q5, q5, q4
	vdup.16	q4, r10
	vmla.i16	q5, q6, r10
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, r10
	add.w	r12, r1, #128
	vsub.i16	q6, q0, q5
	vcmp.s16	lt, q6, zr
	vpst
	vaddt.i16	q6, q6, q4
	vmov	q6, q6
	vadd.i16	q0, q0, q5
	vstrh.16	q6, [r12]
	vsub.i16	q0, q0, q4
	add.w	r12, r1, #160
	vdup.16	q5, r14
	vcmp.s16	lt, q0, zr
	vpst
	vaddt.i16	q0, q0, q4
	vldrh.u16	q4, [r12]
	add.w	r12, r1, #160
	vqrdmulh.s16	q5, q4, q5
	vdup.16	q6, r4
	asr.w	r14, r4, #16
	vmul.i16	q4, q4, q6
	vdup.16	q6, r4
	vmla.i16	q4, q5, r10
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	vsub.i16	q5, q1, q4
	vadd.i16	q1, q1, q4
	vdup.16	q4, r10
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q4
	vmov	q5, q5
	vsub.i16	q1, q1, q4
	vstrh.16	q5, [r12]
	vdup.16	q5, r14
	add.w	r12, r1, #192
	vcmp.s16	lt, q1, zr
	vpst
	vaddt.i16	q1, q1, q4
	vldrh.u16	q4, [r12]
	vqrdmulh.s16	q5, q4, q5
	vmul.i16	q4, q4, q6
	vmla.i16	q4, q5, r10
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	add.w	r12, r1, #192
	vsub.i16	q5, q2, q4
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, r10
	asr.w	r14, r6, #16
	vqrdmulh.s16	q6, q5, r14
	vadd.i16	q2, q2, q4
	vmul.i16	q5, q5, r6
	vsub.i16	q2, q2, r10
	vmla.i16	q5, q6, r10
	asr.w	r14, r4, #16
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, r10
	vmov	q5, q5
	vstrh.16	q5, [r12]
	add.w	r12, r1, #224
	vdup.16	q6, r14
	vldrh.u16	q4, [r12]
	vdup.16	q5, r4
	vqrdmulh.s16	q6, q4, q6
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, r10
	vmul.i16	q4, q4, q5
	asr.w	r14, r5, #16
	vmla.i16	q4, q6, r10
	add.w	r12, r1, #224
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	vsub.i16	q5, q3, q4
	vadd.i16	q3, q3, q4
	vqrdmulh.s16	q4, q2, r14
	vsub.i16	q3, q3, r10
	vmul.i16	q2, q2, r5
	vcmp.s16	lt, q3, zr
	vpst
	vaddt.i16	q3, q3, r10
	vmla.i16	q2, q4, r10
	asr.w	r14, r5, #16
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, r10
	vqrdmulh.s16	q4, q3, r14
	asr.w	r14, r6, #16
	vqrdmulh.s16	q6, q5, r14
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, r10
	vmul.i16	q5, q5, r6
	vmla.i16	q5, q6, r10
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, r10
	vmul.i16	q3, q3, r5
	vmla.i16	q3, q4, r10
	vmov	q4, q5
	vcmp.s16	lt, q3, zr
	vpst
	vaddt.i16	q3, q3, r10
	vdup.16	q5, r10
fndsa_mqpoly_int_to_ntt__L3x512_lanes_slothyB_kernel:
	vstrh.16	q4, [r12]
	vsub.i16	q4, q0, q2
	add.w	r12, r1, #32
	vadd.i16	q0, q0, q2
	asr.w	r14, r7, #16
	vsub.i16	q0, q0, q5
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q5
	vmov	q2, q4
	vsub.i16	q4, q1, q3
	vadd.i16	q1, q1, q3
	vsub.i16	q1, q1, r10
	vcmp.s16	lt, q1, zr
	vpst
	vaddt.i16	q1, q1, r10
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	vqrdmulh.s16	q3, q1, r14
	asr.w	r14, r8, #16
	vmul.i16	q1, q1, r7
	vcmp.s16	lt, q0, zr
	vpst
	vaddt.i16	q0, q0, q5
	vmla.i16	q1, q3, r10
	vqrdmulh.s16	q5, q4, r14
	vcmp.s16	lt, q1, zr
	vpst
	vaddt.i16	q1, q1, r10
	vmul.i16	q4, q4, r8
	vmla.i16	q4, q5, r10
	vdup.16	q5, r10
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	vmov	q3, q4
	vsub.i16	q4, q0, q1
	vadd.i16	q0, q0, q1
	vsub.i16	q0, q0, q5
	vcmp.s16	lt, q0, zr
	vpst
	vaddt.i16	q0, q0, q5
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q5
	vstrh.16	q0, [r1]
	vmov	q1, q4
	vsub.i16	q4, q2, q3
	vstrh.16	q1, [r12]
	vadd.i16	q2, q2, q3
	add.w	r12, r1, #64
	vdup.16	q5, r10
	vsub.i16	q2, q2, q5
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, q5
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q5
	vstrh.16	q2, [r12]
	add.w	r12, r1, #96
	vmov	q3, q4
	vstrh.16	q3, [r12]
	add.w	r12, r1, #128
	vldrh.u16	q0, [r12]
	add.w	r12, r1, #160
	vldrh.u16	q2, [r12]
	add.w	r12, r1, #192
	vldrh.u16	q4, [r12]
	vdup.16	q3, r10
	add.w	r12, r1, #224
	vsub.i16	q5, q0, q4
	vldrh.u16	q1, [r12]
	vadd.i16	q0, q0, q4
	asr.w	r14, r11, #16
	vsub.i16	q4, q2, q1
	add.w	r12, r1, #128
	vadd.i16	q2, q2, q1
	vsub.i16	q2, q2, r10
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, r10
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	vqrdmulh.s16	q1, q2, r14
	asr.w	r14, r0, #16
	vmul.i16	q2, q2, r11
	vsub.i16	q0, q0, q3
	vmla.i16	q2, q1, r10
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q3
	vqrdmulh.s16	q1, q4, r14
	vmul.i16	q4, q4, r0
	vcmp.s16	lt, q0, zr
	vpst
	vaddt.i16	q0, q0, q3
	vmla.i16	q4, q1, r10
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, r10
	vsub.i16	q3, q0, q2
	vadd.i16	q0, q0, q2
	vdup.16	q2, r10
	vsub.i16	q0, q0, q2
	vcmp.s16	lt, q0, zr
	vpst
	vaddt.i16	q0, q0, q2
	vcmp.s16	lt, q3, zr
	vpst
	vaddt.i16	q3, q3, q2
	vstrh.16	q0, [r12]
	add.w	r12, r1, #160
	vmov	q1, q3
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	vstrh.16	q1, [r12]
	add.w	r12, r1, #192
	vmov	q3, q4
	vmov	q2, q5
	vsub.i16	q4, q2, q3
	vadd.i16	q2, q2, q3
	vdup.16	q5, r10
	vsub.i16	q2, q2, q5
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, q5
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q5
	vstrh.16	q2, [r12]
	add.w	r12, r1, #224
	vmov	q3, q4
	vstrh.16	q3, [r12]
	add.w	r1, r1, #16
	add.w	r12, r1, #32
	vldrh.u16	q0, [r1]
	asr.w	r14, r4, #16
	vldrh.u16	q1, [r12]
	add.w	r12, r1, #64
	vldrh.u16	q2, [r12]
	add.w	r12, r1, #96
	vldrh.u16	q3, [r12]
	add.w	r12, r1, #128
	vdup.16	q5, r14
	vldrh.u16	q6, [r12]
	vdup.16	q4, r4
	vqrdmulh.s16	q5, q6, q5
	asr.w	r14, r4, #16
	vmul.i16	q6, q6, q4
	vdup.16	q4, r10
	vmla.i16	q6, q5, r10
	add.w	r12, r1, #128
	vcmp.s16	lt, q6, zr
	vpst
	vaddt.i16	q6, q6, r10
	vsub.i16	q5, q0, q6
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q4
	vmov	q5, q5
	vadd.i16	q0, q0, q6
	vstrh.16	q5, [r12]
	vsub.i16	q0, q0, q4
	add.w	r12, r1, #160
	vdup.16	q5, r14
	vldrh.u16	q6, [r12]
	vcmp.s16	lt, q0, zr
	vpst
	vaddt.i16	q0, q0, q4
	add.w	r12, r1, #160
	vqrdmulh.s16	q5, q6, q5
	asr.w	r14, r4, #16
	vdup.16	q4, r4
	vmul.i16	q6, q6, q4
	vdup.16	q4, r10
	vmla.i16	q6, q5, r10
	vcmp.s16	lt, q6, zr
	vpst
	vaddt.i16	q6, q6, r10
	vsub.i16	q5, q1, q6
	vadd.i16	q1, q1, q6
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q4
	vmov	q5, q5
	vdup.16	q6, r4
	vstrh.16	q5, [r12]
	vsub.i16	q1, q1, q4
	add.w	r12, r1, #192
	vdup.16	q5, r14
	vcmp.s16	lt, q1, zr
	vpst
	vaddt.i16	q1, q1, q4
	vldrh.u16	q4, [r12]
	vqrdmulh.s16	q5, q4, q5
	add.w	r12, r1, #192
	vmul.i16	q4, q4, q6
	vmla.i16	q4, q5, r10
	asr.w	r14, r6, #16
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	vsub.i16	q5, q2, q4
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, r10
	vqrdmulh.s16	q6, q5, r14
	vadd.i16	q2, q2, q4
	vmul.i16	q5, q5, r6
	vsub.i16	q2, q2, r10
	vmla.i16	q5, q6, r10
	asr.w	r14, r4, #16
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, r10
	vmov	q5, q5
	vstrh.16	q5, [r12]
	add.w	r12, r1, #224
	vdup.16	q6, r14
	vldrh.u16	q4, [r12]
	vdup.16	q5, r4
	vqrdmulh.s16	q6, q4, q6
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, r10
	vmul.i16	q4, q4, q5
	vmla.i16	q4, q6, r10
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	asr.w	r14, r5, #16
	vqrdmulh.s16	q6, q2, r14
	asr.w	r14, r5, #16
	vsub.i16	q5, q3, q4
	add.w	r12, r1, #224
	vadd.i16	q3, q3, q4
	vmul.i16	q2, q2, r5
	vsub.i16	q3, q3, r10
	vcmp.s16	lt, q3, zr
	vpst
	vaddt.i16	q3, q3, r10
	vmla.i16	q2, q6, r10
	vqrdmulh.s16	q4, q3, r14
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, r10
	vmul.i16	q3, q3, r5
	asr.w	r14, r6, #16
	vmla.i16	q3, q4, r10
	vqrdmulh.s16	q6, q5, r14
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, r10
	vmul.i16	q5, q5, r6
	vmla.i16	q5, q6, r10
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, r10
	vmov	q4, q5
	vdup.16	q5, r10
	vcmp.s16	lt, q3, zr
	vpst
	vaddt.i16	q3, q3, r10
	subs	r2, #1
	bne	fndsa_mqpoly_int_to_ntt__L3x512_lanes_slothyB_kernel
	vstrh.16	q4, [r12]
	vsub.i16	q4, q0, q2
	add.w	r12, r1, #32
	vadd.i16	q0, q0, q2
	asr.w	r14, r7, #16
	vsub.i16	q0, q0, q5
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q5
	vmov	q2, q4
	vsub.i16	q4, q1, q3
	vadd.i16	q1, q1, q3
	vsub.i16	q1, q1, r10
	vcmp.s16	lt, q1, zr
	vpst
	vaddt.i16	q1, q1, r10
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	vqrdmulh.s16	q3, q1, r14
	asr.w	r14, r8, #16
	vmul.i16	q1, q1, r7
	vcmp.s16	lt, q0, zr
	vpst
	vaddt.i16	q0, q0, q5
	vmla.i16	q1, q3, r10
	vqrdmulh.s16	q5, q4, r14
	vcmp.s16	lt, q1, zr
	vpst
	vaddt.i16	q1, q1, r10
	vmul.i16	q4, q4, r8
	vmla.i16	q4, q5, r10
	vdup.16	q3, r10
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	vmov	q5, q4
	vsub.i16	q4, q0, q1
	vadd.i16	q0, q0, q1
	vsub.i16	q0, q0, q3
	vcmp.s16	lt, q0, zr
	vpst
	vaddt.i16	q0, q0, q3
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q3
	vstrh.16	q0, [r1]
	vmov	q1, q4
	vsub.i16	q4, q2, q5
	vstrh.16	q1, [r12]
	vadd.i16	q2, q2, q5
	add.w	r12, r1, #64
	vdup.16	q5, r10
	vsub.i16	q2, q2, q5
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, q5
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q5
	vstrh.16	q2, [r12]
	add.w	r12, r1, #96
	vmov	q3, q4
	vstrh.16	q3, [r12]
	add.w	r12, r1, #128
	vldrh.u16	q0, [r12]
	add.w	r12, r1, #160
	vldrh.u16	q2, [r12]
	add.w	r12, r1, #192
	vldrh.u16	q5, [r12]
	vdup.16	q1, r10
	add.w	r12, r1, #224
	vsub.i16	q4, q0, q5
	vldrh.u16	q3, [r12]
	vadd.i16	q0, q0, q5
	asr.w	r14, r11, #16
	vsub.i16	q5, q2, q3
	add.w	r12, r1, #128
	vadd.i16	q2, q2, q3
	vsub.i16	q2, q2, r10
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, r10
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, r10
	vsub.i16	q0, q0, q1
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q1
	vqrdmulh.s16	q3, q2, r14
	vmul.i16	q2, q2, r11
	vcmp.s16	lt, q0, zr
	vpst
	vaddt.i16	q0, q0, q1
	asr.w	r14, r0, #16
	vmla.i16	q2, q3, r10
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, r10
	vsub.i16	q3, q0, q2
	vadd.i16	q0, q0, q2
	vdup.16	q2, r10
	vsub.i16	q0, q0, q2
	vcmp.s16	lt, q0, zr
	vpst
	vaddt.i16	q0, q0, q2
	vqrdmulh.s16	q1, q5, r14
	vcmp.s16	lt, q3, zr
	vpst
	vaddt.i16	q3, q3, q2
	vmul.i16	q5, q5, r0
	vstrh.16	q0, [r12]
	vmla.i16	q5, q1, r10
	vmov	q1, q3
	add.w	r12, r1, #160
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, r10
	vstrh.16	q1, [r12]
	add.w	r12, r1, #192
	vmov	q3, q5
	vmov	q2, q4
	vsub.i16	q4, q2, q3
	vadd.i16	q2, q2, q3
	vdup.16	q5, r10
	vsub.i16	q2, q2, q5
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, q5
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q5
	vstrh.16	q2, [r12]
	vmov	q3, q4
	add.w	r12, r1, #224
	vstrh.16	q3, [r12]
	add.w	r1, r1, #16
	add.w	r1, r1, #224      @ next 128-coefficient block
	subs	r3, #1
	bne	fndsa_mqpoly_int_to_ntt__L3x512_block

	@ p2 has advanced over GM[16..31], hence now points to GM[32].
	@ Continue with the packed m=32,64 CT2 pass below.
	ldr	r8, [sp, #8]
	ldr	r1, [sp, #12]
	add	sp, sp, #16
	vmov	s2, r1

@ Final general CT2 pass for logn=9: m=32 and m=64.  H=4, so two
@ 16-coefficient groups are packed into the low/high 64-bit halves of
@ q1-q4.  This still performs eight 16-bit butterflies per instruction.
fndsa_mqpoly_int_to_ntt__L512_CT2_packed:
	mov	r4, r8              @ parent twiddles GM[32]
	add.w	r0, r8, #64       @ child twiddles GM[64]
	movs	r2, #16            @ two groups per iteration
	vmov	r1, s2
fndsa_mqpoly_int_to_ntt__L512_CT2_packed_loop:
	@ SLOTHY B: halving pipeline a; (b;a)^(N-1); b.
	sub.w	r2, r2, #1
	ldrh	r5, [r4]
	add.w	r14, r4, r9
	ldrh	r14, [r14]
	add.w	r4, r4, #2
	orr	r5, r5, r14, lsl #16
	ldrh	r6, [r4]
	add.w	r14, r4, r9
	ldrh	r14, [r14]
	add.w	r4, r4, #2
	orr	r6, r6, r14, lsl #16
	ldrh	r7, [r0]
	add.w	r14, r0, r9
	ldrh	r14, [r14]
	add.w	r0, r0, #2
	orr	r7, r7, r14, lsl #16
	ldrh	r8, [r0]
	add.w	r14, r0, r9
	ldrh	r14, [r14]
	add.w	r0, r0, #2
	orr	r8, r8, r14, lsl #16
	ldrh	r11, [r0]
	add.w	r14, r0, r9
	ldrh	r14, [r14]
	add.w	r0, r0, #2
	orr	r11, r11, r14, lsl #16
	ldrh	r3, [r0]
	add.w	r14, r0, r9
	ldrh	r14, [r14]
	add.w	r0, r0, #2
	orr	r3, r3, r14, lsl #16
	vldr	d2, [r1, #0]
	vdup.16	q7, r5
	vldr	d3, [r1, #32]
	asr.w	r14, r5, #16
	vldr	d4, [r1, #8]
	vdup.16	q6, r14
	vldr	d5, [r1, #40]
	uxth	r12, r6
	vldr	d6, [r1, #16]
	orr	r12, r12, r12, lsl #16
	vldr	d7, [r1, #48]
	vmov	d15, r12, r12
	vldr	d8, [r1, #24]
	asr.w	r12, r6, #16
	vldr	d9, [r1, #56]
	uxth	r12, r12
	orr	r12, r12, r12, lsl #16
	vmov	d13, r12, r12
	vqrdmulh.s16	q5, q3, q6
	asr.w	r14, r7, #16
	vmul.i16	q3, q3, q7
	vmla.i16	q3, q5, r10
	vcmp.s16	lt, q3, zr
	vpst
	vaddt.i16	q3, q3, r10
	vqrdmulh.s16	q6, q4, q6
	vmul.i16	q4, q4, q7
	vdup.16	q7, r10
	vmla.i16	q4, q6, r10
	vdup.16	q6, r14
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
fndsa_mqpoly_int_to_ntt__L512_CT2_packed_loop_slothyB_kernel:
	vadd.i16	q5, q1, q3
	asr.w	r12, r11, #16
	vsub.i16	q3, q1, q3
	uxth	r12, r12
	vadd.i16	q1, q2, q4
	orr	r12, r12, r12, lsl #16
	vmov	d13, r12, r12
	uxth	r12, r11
	vsub.i16	q4, q2, q4
	orr	r12, r12, r12, lsl #16
	vsub.i16	q5, q5, q7
	vcmp.s16	lt, q3, zr
	vpst
	vaddt.i16	q3, q3, q7
	vsub.i16	q1, q1, q7
	vcmp.s16	lt, q1, zr
	vpst
	vaddt.i16	q1, q1, q7
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q7
	vqrdmulh.s16	q2, q1, q6
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q7
	asr.w	r14, r8, #16
	vdup.16	q7, r7
	vmov	d15, r12, r12
	asr.w	r12, r3, #16
	vmov	q5, q5
	vmul.i16	q1, q1, q7
	vdup.16	q6, r14
	vmla.i16	q1, q2, r10
	vdup.16	q7, r8
	uxth	r12, r12
	vcmp.s16	lt, q1, zr
	vpst
	vaddt.i16	q1, q1, r10
	orr	r12, r12, r12, lsl #16
	vmov	d13, r12, r12
	uxth	r12, r3
	vmov	q2, q1
	orr	r12, r12, r12, lsl #16
	vmov	d15, r12, r12
	vqrdmulh.s16	q6, q4, q6
	vadd.i16	q1, q5, q2
	vmul.i16	q4, q4, q7
	vdup.16	q7, r10
	vmla.i16	q4, q6, r10
	vsub.i16	q1, q1, q7
	vcmp.s16	lt, q1, zr
	vpst
	vaddt.i16	q1, q1, q7
	vmov	q1, q1
	vsub.i16	q2, q5, q2
	vstr	d2, [r1, #0]
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	vadd.i16	q5, q3, q4
	vsub.i16	q5, q5, q7
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, q7
	vsub.i16	q4, q3, q4
	vstr	d3, [r1, #32]
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q7
	vstr	d4, [r1, #8]
	add.w	r14, r4, r9
	vstr	d5, [r1, #40]
	vmov	q3, q5
	vstr	d6, [r1, #16]
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q7
	vstr	d7, [r1, #48]
	vstr	d8, [r1, #24]
	vstr	d9, [r1, #56]
	add.w	r1, r1, #64
	ldrh	r5, [r4]
	ldrh	r14, [r14]
	add.w	r4, r4, #2
	orr	r5, r5, r14, lsl #16
	ldrh	r6, [r4]
	add.w	r14, r4, r9
	ldrh	r14, [r14]
	add.w	r4, r4, #2
	orr	r6, r6, r14, lsl #16
	ldrh	r7, [r0]
	add.w	r14, r0, r9
	ldrh	r14, [r14]
	add.w	r0, r0, #2
	orr	r7, r7, r14, lsl #16
	ldrh	r8, [r0]
	add.w	r14, r0, r9
	ldrh	r14, [r14]
	add.w	r0, r0, #2
	orr	r8, r8, r14, lsl #16
	ldrh	r11, [r0]
	add.w	r14, r0, r9
	ldrh	r14, [r14]
	add.w	r0, r0, #2
	orr	r11, r11, r14, lsl #16
	ldrh	r3, [r0]
	add.w	r14, r0, r9
	ldrh	r14, [r14]
	add.w	r0, r0, #2
	orr	r3, r3, r14, lsl #16
	vldr	d2, [r1, #0]
	vdup.16	q7, r5
	vldr	d3, [r1, #32]
	asr.w	r14, r5, #16
	vldr	d4, [r1, #8]
	vdup.16	q6, r14
	vldr	d5, [r1, #40]
	uxth	r12, r6
	vldr	d6, [r1, #16]
	orr	r12, r12, r12, lsl #16
	vldr	d7, [r1, #48]
	vmov	d15, r12, r12
	asr.w	r12, r6, #16
	uxth	r12, r12
	orr	r12, r12, r12, lsl #16
	vmov	d13, r12, r12
	vldr	d8, [r1, #24]
	vqrdmulh.s16	q5, q3, q6
	vldr	d9, [r1, #56]
	vmul.i16	q3, q3, q7
	asr.w	r14, r7, #16
	vmla.i16	q3, q5, r10
	vcmp.s16	lt, q3, zr
	vpst
	vaddt.i16	q3, q3, r10
	vqrdmulh.s16	q6, q4, q6
	vmul.i16	q4, q4, q7
	vdup.16	q7, r10
	vmla.i16	q4, q6, r10
	vdup.16	q6, r14
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	subs	r2, #1
	bne	fndsa_mqpoly_int_to_ntt__L512_CT2_packed_loop_slothyB_kernel
	vadd.i16	q5, q2, q4
	asr.w	r12, r11, #16
	vsub.i16	q4, q2, q4
	uxth	r12, r12
	vadd.i16	q2, q1, q3
	vsub.i16	q2, q2, q7
	orr	r12, r12, r12, lsl #16
	vsub.i16	q3, q1, q3
	vmov	d13, r12, r12
	asr.w	r12, r3, #16
	vsub.i16	q5, q5, q7
	asr.w	r14, r8, #16
	vcmp.s16	lt, q3, zr
	vpst
	vaddt.i16	q3, q3, q7
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q7
	uxth	r12, r12
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, q7
	vmov	q1, q2
	vqrdmulh.s16	q2, q5, q6
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q7
	vdup.16	q6, r14
	orr	r12, r12, r12, lsl #16
	vmov	d13, r12, r12
	uxth	r12, r11
	vdup.16	q7, r7
	orr	r12, r12, r12, lsl #16
	vmov	d15, r12, r12
	uxth	r12, r3
	vmul.i16	q5, q5, q7
	vdup.16	q7, r8
	orr	r12, r12, r12, lsl #16
	vmla.i16	q5, q2, r10
	vmov	d15, r12, r12
	vqrdmulh.s16	q6, q4, q6
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, r10
	vmul.i16	q4, q4, q7
	vmla.i16	q4, q6, r10
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	vmov	q2, q5
	vdup.16	q7, r10
	vadd.i16	q5, q1, q2
	vsub.i16	q5, q5, q7
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q7
	vsub.i16	q2, q1, q2
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, q7
	vmov	q1, q5
	vadd.i16	q5, q3, q4
	vstr	d2, [r1, #0]
	vsub.i16	q5, q5, q7
	vstr	d3, [r1, #32]
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q7
	vstr	d4, [r1, #8]
	vstr	d5, [r1, #40]
	vsub.i16	q4, q3, q4
	vmov	q3, q5
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q7
	vstr	d6, [r1, #16]
	vstr	d7, [r1, #48]
	vstr	d8, [r1, #24]
	vstr	d9, [r1, #56]
	add.w	r1, r1, #64

	@ Child pointer is now GM[128], exactly what the existing final-two-
	@ layer VLD4/VST4 kernel expects.
	mov	r8, r0
	vmov	r1, s2
	movs	r3, #128
	vmov	s3, r3
	movs	r2, #4
	movs	r0, #0
	movw	r10, #Q
	orr	r11, r10, r10, lsl #16
	b	fndsa_mqpoly_int_to_ntt__L4

fndsa_mqpoly_int_to_ntt__F2_setup:
	@ Pair state starts at m=1,t=1024.  s3 holds m because r6 is used
	@ for the second child twiddle inside each radix-4 group.
	movs	r6, #1
	vmov	s3, r6

fndsa_mqpoly_int_to_ntt__F2_outer:
	vmov	r1, s2
	vmov	r6, s3
	mov	r3, r6
	@ r8=&GM[m], r7=&GM[2*m].
	add.w	r7, r8, r6, lsl #1
	@ Four equally sized input/output streams are t/4 coefficients
	@ apart, i.e. t/2 bytes apart.
	lsr.w	r4, r2, #1

fndsa_mqpoly_int_to_ntt__F2_middle:
	@ Parent twiddle and the two child twiddles for this radix-4 group.
	MQ_LOAD_PAIR	r5, r8
	MQ_LOAD_PAIR	r11, r7
	MQ_LOAD_PAIR	r6, r7

	@ The fourth pair has four coefficients per stream.  Use 64-bit
	@ loads/stores for its live lanes, avoiding an out-of-bounds 128-bit
	@ access at the end of d.  All earlier pairs use all eight MVE lanes.
	cmp	r2, #16
	beq	fndsa_mqpoly_int_to_ntt__F2_half
	lsr.w	r0, r2, #5

fndsa_mqpoly_int_to_ntt__F2_vector:
	vldrh.u16	q1, [r1]
	add.w	r12, r1, r4
	vldrh.u16	q2, [r12]
	add.w	r12, r12, r4
	vldrh.u16	q3, [r12]
	add.w	r12, r12, r4
	vldrh.u16	q4, [r12]
	b	fndsa_mqpoly_int_to_ntt__F2_butterflies

fndsa_mqpoly_int_to_ntt__F2_half:
	vldr	d2, [r1]
	add.w	r12, r1, r4
	vldr	d4, [r12]
	add.w	r12, r12, r4
	vldr	d6, [r12]
	add.w	r12, r12, r4
	vldr	d8, [r12]

fndsa_mqpoly_int_to_ntt__F2_butterflies:
	@ SLOTHY iteration-local arithmetic schedule (A and B).
	vdup.16	q5, r5
	asr.w	r14, r5, #16
	vdup.16	q6, r14
	asr.w	r14, r11, #16
	vqrdmulh.s16	q7, q3, q6
	vmul.i16	q3, q3, q5
	vmla.i16	q3, q7, r10
	vdup.16	q7, r11
	vcmp.s16	lt, q3, zr
	vpst
	vaddt.i16	q3, q3, r10
	vqrdmulh.s16	q6, q4, q6
	vmul.i16	q4, q4, q5
	vadd.i16	q5, q1, q3
	vmla.i16	q4, q6, r10
	vsub.i16	q3, q1, q3
	vdup.16	q1, r14
	asr.w	r14, r6, #16
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	vadd.i16	q6, q2, q4
	vsub.i16	q6, q6, r10
	vcmp.s16	lt, q6, zr
	vpst
	vaddt.i16	q6, q6, r10
	vsub.i16	q4, q2, q4
	vqrdmulh.s16	q1, q6, q1
	vcmp.s16	lt, q3, zr
	vpst
	vaddt.i16	q3, q3, r10
	vmul.i16	q6, q6, q7
	vsub.i16	q5, q5, r10
	vdup.16	q7, r6
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, r10
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	vmla.i16	q6, q1, r10
	vcmp.s16	lt, q6, zr
	vpst
	vaddt.i16	q6, q6, r10
	vmov	q5, q5
	vmov	q2, q6
	vdup.16	q6, r14
	vadd.i16	q1, q5, q2
	vqrdmulh.s16	q6, q4, q6
	vsub.i16	q1, q1, r10
	vmul.i16	q4, q4, q7
	vcmp.s16	lt, q1, zr
	vpst
	vaddt.i16	q1, q1, r10
	vmla.i16	q4, q6, r10
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	vsub.i16	q2, q5, q2
	vadd.i16	q5, q3, q4
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, r10
	vmov	q1, q1
	vsub.i16	q5, q5, r10
	vsub.i16	q4, q3, q4
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, r10
	vmov	q3, q5
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	cmp	r2, #16
	beq	fndsa_mqpoly_int_to_ntt__F2_half_store
	vstrh.16	q1, [r1]
	add.w	r12, r1, r4
	vstrh.16	q2, [r12]
	add.w	r12, r12, r4
	vstrh.16	q3, [r12]
	add.w	r12, r12, r4
	vstrh.16	q4, [r12]
	add.w	r1, r1, #16
	subs	r0, #1
	bne	fndsa_mqpoly_int_to_ntt__F2_vector
	@ r1 is at the end of the first stream; skip the other three.
	add.w	r1, r1, r4, lsl #1
	add.w	r1, r1, r4
	b	fndsa_mqpoly_int_to_ntt__F2_middle_done

fndsa_mqpoly_int_to_ntt__F2_half_store:
	vstr	d2, [r1]
	add.w	r12, r1, r4
	vstr	d4, [r12]
	add.w	r12, r12, r4
	vstr	d6, [r12]
	add.w	r12, r12, r4
	vstr	d8, [r12]
	add.w	r1, r1, r4, lsl #2

fndsa_mqpoly_int_to_ntt__F2_middle_done:
	subs	r3, #1
	bne	fndsa_mqpoly_int_to_ntt__F2_middle

	@ The next pair starts four levels farther in the GM tree.  r7 has
	@ advanced exactly to &GM[4*m].
	mov	r8, r7
	vmov	r6, s3
	lsl.w	r6, r6, #2
	vmov	s3, r6
	lsr.w	r2, r2, #2
	cmp	r2, #4
	bne	fndsa_mqpoly_int_to_ntt__F2_outer
	vmov	r1, s2
	b	fndsa_mqpoly_int_to_ntt__L4

fndsa_mqpoly_int_to_ntt__L4:
	@ Last two outer iterations use specialized code.
	@   m = n/4
	@   t = 4
	@ We do n/4 inner iterations, each processing four consecutive values.

	@ Loop counter (m = n/4).
	vmov	r3, s3

	@ We need two pointers to read s values; we use r8 and r7.
	@ At this point, r8 is correct (&mq_GM[m]) and we set r7 to
	@ &mq_GM[2*m] by adding 2*m (in bytes) to r8.
	add	r7, r8, r3, lsl #1

	@ r2 is free, since we know it contains 4.

	@ For m >= 8, fuse the last two layers for eight four-coefficient
	@ groups.  VLD4 deinterleaves
	@   x1 y1 x2 y2 | x1 y1 x2 y2 | ...
	@ directly into four 8x16-bit vectors; VST4 restores that exact layout.
	cmp	r3, #8
	blo	fndsa_mqpoly_int_to_ntt__L5
	cmp	r9, #0
	beq	fndsa_mqpoly_int_to_ntt__L5_mve

fndsa_mqpoly_int_to_ntt__L5_mve_stage3:
	@ SLOTHY B: halving pipeline a; (b;a)^(N-1); b.
	sub.w	r3, r3, #8
	vld40.16	{ q1, q2, q3, q4 }, [r1]
	vld41.16	{ q1, q2, q3, q4 }, [r1]
	vld42.16	{ q1, q2, q3, q4 }, [r1]
	vld43.16	{ q1, q2, q3, q4 }, [r1]
	add.w	r12, r8, r9
	vldrh.u16	q6, [r8]
	add.w	r8, r8, #16
	vldrh.u16	q5, [r12]
	add.w	r12, r7, r9
	vqrdmulh.s16	q7, q3, q5
	vmul.i16	q3, q3, q6
	vmla.i16	q3, q7, r10
	vdup.16	q7, r10
	vqrdmulh.s16	q5, q4, q5
	vcmp.s16	lt, q3, zr
	vpst
	vaddt.i16	q3, q3, r10
	vmul.i16	q4, q4, q6
	vmla.i16	q4, q5, r10
	vadd.i16	q6, q1, q3
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	vsub.i16	q6, q6, q7
	vadd.i16	q5, q2, q4
	vcmp.s16	lt, q6, zr
	vpst
	vaddt.i16	q6, q6, q7
	vsub.i16	q3, q1, q3
	vsub.i16	q5, q5, q7
	vsub.i16	q4, q2, q4
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q7
	vmov	q1, q6
	vmov	q2, q5
	vcmp.s16	lt, q3, zr
	vpst
	vaddt.i16	q3, q3, q7
	vld20.16	{ q5, q6 }, [r7]
	vld21.16	{ q5, q6 }, [r7]
fndsa_mqpoly_int_to_ntt__L5_mve_stage3_slothyB_kernel:
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q7
	vld20.16	{ q6, q7 }, [r12]
	vld21.16	{ q6, q7 }, [r12]
	add.w	r12, r8, r9
	vqrdmulh.s16	q6, q2, q6
	vmul.i16	q2, q2, q5
	vmla.i16	q2, q6, r10
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, r10
	vld20.16	{ q5, q6 }, [r7]
	vld21.16	{ q5, q6 }, [r7]
	vqrdmulh.s16	q7, q4, q7
	vadd.i16	q5, q1, q2
	vmul.i16	q4, q4, q6
	vdup.16	q6, r10
	vmla.i16	q4, q7, r10
	vsub.i16	q5, q5, q6
	add.w	r7, r7, #32
	vsub.i16	q2, q1, q2
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q6
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, q6
	vmov	q1, q5
	vadd.i16	q7, q3, q4
	vsub.i16	q7, q7, q6
	vsub.i16	q4, q3, q4
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q6
	vcmp.s16	lt, q7, zr
	vpst
	vaddt.i16	q7, q7, q6
	vmov	q3, q7
	vst40.16	{ q1, q2, q3, q4 }, [r1]
	vst41.16	{ q1, q2, q3, q4 }, [r1]
	vst42.16	{ q1, q2, q3, q4 }, [r1]
	vst43.16	{ q1, q2, q3, q4 }, [r1]
	add.w	r1, r1, #64
	vld40.16	{ q1, q2, q3, q4 }, [r1]
	vld41.16	{ q1, q2, q3, q4 }, [r1]
	vld42.16	{ q1, q2, q3, q4 }, [r1]
	vld43.16	{ q1, q2, q3, q4 }, [r1]
	vldrh.u16	q5, [r8]
	add.w	r8, r8, #16
	vldrh.u16	q6, [r12]
	add.w	r12, r7, r9
	vqrdmulh.s16	q7, q3, q6
	vmul.i16	q3, q3, q5
	vmla.i16	q3, q7, r10
	vdup.16	q7, r10
	vqrdmulh.s16	q6, q4, q6
	vcmp.s16	lt, q3, zr
	vpst
	vaddt.i16	q3, q3, r10
	vmul.i16	q4, q4, q5
	vmla.i16	q4, q6, r10
	vadd.i16	q6, q1, q3
	vsub.i16	q6, q6, q7
	vsub.i16	q3, q1, q3
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	vadd.i16	q5, q2, q4
	vsub.i16	q5, q5, q7
	vcmp.s16	lt, q6, zr
	vpst
	vaddt.i16	q6, q6, q7
	vmov	q1, q6
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q7
	vsub.i16	q4, q2, q4
	vmov	q2, q5
	vld20.16	{ q5, q6 }, [r7]
	vld21.16	{ q5, q6 }, [r7]
	vcmp.s16	lt, q3, zr
	vpst
	vaddt.i16	q3, q3, q7
	subs	r3, #8
	bne	fndsa_mqpoly_int_to_ntt__L5_mve_stage3_slothyB_kernel
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q7
	vld20.16	{ q6, q7 }, [r12]
	vld21.16	{ q6, q7 }, [r12]
	vqrdmulh.s16	q6, q2, q6
	vmul.i16	q2, q2, q5
	vmla.i16	q2, q6, r10
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, r10
	vld20.16	{ q5, q6 }, [r7]
	vld21.16	{ q5, q6 }, [r7]
	vqrdmulh.s16	q7, q4, q7
	vadd.i16	q5, q1, q2
	vmul.i16	q4, q4, q6
	vdup.16	q6, r10
	vmla.i16	q4, q7, r10
	vsub.i16	q5, q5, q6
	vsub.i16	q2, q1, q2
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	add.w	r7, r7, #32
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q6
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, q6
	vmov	q1, q5
	vadd.i16	q5, q3, q4
	vsub.i16	q5, q5, q6
	vsub.i16	q4, q3, q4
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q6
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q6
	vmov	q3, q5
	vst40.16	{ q1, q2, q3, q4 }, [r1]
	vst41.16	{ q1, q2, q3, q4 }, [r1]
	vst42.16	{ q1, q2, q3, q4 }, [r1]
	vst43.16	{ q1, q2, q3, q4 }, [r1]
	add.w	r1, r1, #64
	b	fndsa_mqpoly_int_to_ntt__Lend


fndsa_mqpoly_int_to_ntt__L5_mve:
	@ q1=x1[0..7], q2=y1[0..7], q3=x2[0..7], q4=y2[0..7].
	vld40.16	{ q1, q2, q3, q4 }, [r1]
	vld41.16	{ q1, q2, q3, q4 }, [r1]
	vld42.16	{ q1, q2, q3, q4 }, [r1]
	vld43.16	{ q1, q2, q3, q4 }, [r1]
	vldrh.u16	q7, [r8]          @ one first-layer twiddle per group
	add.w	r8, r8, #16

	@ q3 <- mmul(q3,q7), preserving q7 for q4.
	vmov.i32	q5, #0
	vcmp.i16	eq, q3, q5
	vmulh.u16	q5, q3, q7
	vmul.i16	q3, q3, q7
	vdup.16	q6, r14
	vmulh.u16	q6, q3, q6
	movw	r12, #Q1IHI
	vmul.i16	q3, q3, r12
	vmul.i16	q5, q5, r14
	vadd.i16	q3, q3, q5
	vadd.i16	q3, q3, q6
	vdup.16	q6, r10
	vmulh.u16	q3, q3, q6
	movs	r12, #1
	vadd.i16	q3, q3, r12
	vpst
	vsubt.i16	q3, q3, r12

	@ q4 <- mmul(q4,q7).
	vmov.i32	q5, #0
	vcmp.i16	eq, q4, q5
	vmulh.u16	q5, q4, q7
	vmul.i16	q4, q4, q7
	vdup.16	q6, r14
	vmulh.u16	q6, q4, q6
	movw	r12, #Q1IHI
	vmul.i16	q4, q4, r12
	vmul.i16	q5, q5, r14
	vadd.i16	q4, q4, q5
	vadd.i16	q4, q4, q6
	vdup.16	q6, r10
	vmulh.u16	q4, q4, q6
	movs	r12, #1
	vadd.i16	q4, q4, r12
	vpst
	vsubt.i16	q4, q4, r12

	@ First of the fused layers.  q1/q3 become the x sum/difference;
	@ q2/q4 become the y sum/difference.
	vdup.16	q6, r10
	vadd.i16	q5, q1, q3
	vsub.i16	q5, q5, q6
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q6
	vsub.i16	q3, q1, q3
	vcmp.s16	lt, q3, zr
	vpst
	vaddt.i16	q3, q3, q6
	vmov	q1, q5

	vadd.i16	q5, q2, q4
	vsub.i16	q5, q5, q6
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q6
	vsub.i16	q4, q2, q4
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q6
	vmov	q2, q5

	@ The final-layer twiddles are stored sx0,sy0,sx1,sy1,... .
	vld20.16	{ q5, q6 }, [r7]
	vld21.16	{ q5, q6 }, [r7]
	add.w	r7, r7, #32

	@ q2 <- mmul(q2,q5); q5 is dead after the initial vector product.
	vmov.i32	q7, #0
	vcmp.i16	eq, q2, q7
	vmulh.u16	q7, q2, q5
	vmul.i16	q2, q2, q5
	vdup.16	q5, r14
	vmulh.u16	q5, q2, q5
	movw	r12, #Q1IHI
	vmul.i16	q2, q2, r12
	vmul.i16	q7, q7, r14
	vadd.i16	q2, q2, q7
	vadd.i16	q2, q2, q5
	vdup.16	q5, r10
	vmulh.u16	q2, q2, q5
	movs	r12, #1
	vadd.i16	q2, q2, r12
	vpst
	vsubt.i16	q2, q2, r12

	@ q4 <- mmul(q4,q6); q6 is dead after the initial vector product.
	vmov.i32	q7, #0
	vcmp.i16	eq, q4, q7
	vmulh.u16	q7, q4, q6
	vmul.i16	q4, q4, q6
	vdup.16	q6, r14
	vmulh.u16	q6, q4, q6
	movw	r12, #Q1IHI
	vmul.i16	q4, q4, r12
	vmul.i16	q7, q7, r14
	vadd.i16	q4, q4, q7
	vadd.i16	q4, q4, q6
	vdup.16	q6, r10
	vmulh.u16	q4, q4, q6
	movs	r12, #1
	vadd.i16	q4, q4, r12
	vpst
	vsubt.i16	q4, q4, r12

	@ Second fused layer.
	vdup.16	q6, r10
	vadd.i16	q5, q1, q2
	vsub.i16	q5, q5, q6
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q6
	vsub.i16	q2, q1, q2
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, q6
	vmov	q1, q5

	vadd.i16	q5, q3, q4
	vsub.i16	q5, q5, q6
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q6
	vsub.i16	q4, q3, q4
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q6
	vmov	q3, q5

	@ q1,q2,q3,q4 are now x1,x2,y1,y2 for the structure store.
	vst40.16	{ q1, q2, q3, q4 }, [r1]
	vst41.16	{ q1, q2, q3, q4 }, [r1]
	vst42.16	{ q1, q2, q3, q4 }, [r1]
	vst43.16	{ q1, q2, q3, q4 }, [r1]
	add.w	r1, r1, #64

	subs	r3, #8
	bne	fndsa_mqpoly_int_to_ntt__L5_mve
	b	fndsa_mqpoly_int_to_ntt__Lend

fndsa_mqpoly_int_to_ntt__L5:
	@ Next-to-last outer iteration: the four values are, in RAM order:
	@   x1 y1 x2 y2
	@ We load x2:y2 (into r5) and s (into r6)
	ldr.w	r5, [r1, #4]
	ldrh	r6, [r8], #2

	@ r4 <- mmul(x2, s)
	smulbb	r4, r5, r6
	mul	r12, r4, r14
	umaal	r14, r4, r12, r10
	@ r5 <- mmul(y2, s)
	smultb	r5, r5, r6
	mul	r12, r5, r14
	umaal	r14, r5, r12, r10
	@ r5 <- mmul(x2, s) : mmul(y2, s)
	pkhbt	r5, r4, r5, lsl #16

	@ Load x1:y1 (into r4)
	ldr.w	r4, [r1]

	@ r4 <- (x1+mmul(x2,s)):(y1+mmul(y2,s))
	@ r5 <- (x1-mmul(x2,s)):(y1-mmul(y2,s))
	sadd16	r12, r4, r5
	ssub16	r5, r4, r5
	sel	r4, r0, r11
	sadd16	r5, r5, r4
	ssub16	r4, r12, r11
	sel	r4, r4, r12

	@ Last iteration: the four values are, in RAM order: x1 x2 y1 y2
	@ The values have not been really written to RAM, though; they
	@ are in r4 (x1:x2) and r5 (y1:y2).
	@ Get the two relevant s values into r6.
	ldr	r6, [r7], #4

	@ r2 <- x1:y1
	pkhbt	r2, r4, r5, lsl #16
	@ r5 <- mmul(x2,s):mmul(y2,s)
	smultb	r4, r4, r6
	mul	r12, r4, r14
	umaal	r14, r4, r12, r10
	smultt	r5, r5, r6
	mul	r12, r5, r14
	umaal	r14, r5, r12, r10
	pkhbt	r5, r4, r5, lsl #16
	@ r4 <- (x1+mmul(x2,s):(y1+mmul(y2,s))
	sadd16	r4, r2, r5
	ssub16	r12, r4, r11
	sel	r4, r12, r4
	@ r5 <- (x1-mmul(x2,s):(y1-mmul(y2,s))
	ssub16	r5, r2, r5
	sel	r12, r0, r11
	sadd16	r5, r5, r12

	@ We write the four final values in x1 x2 y1 y2 order.
	pkhbt	r12, r4, r5, lsl #16
	str.w	r12, [r1], #4
	pkhtb	r12, r5, r4, asr #16
	str.w	r12, [r1], #4

	subs	r3, #1
	bne	fndsa_mqpoly_int_to_ntt__L5

fndsa_mqpoly_int_to_ntt__Lend:
	vpop	{ d8-d15 }
	pop.w	{ r0, r4, r5, r6, r7, r8, r9, r10, r11, pc }
	.size	fndsa_mqpoly_int_to_ntt,.-fndsa_mqpoly_int_to_ntt
	.align	2
fndsa_mqpoly_ntt_to_int__igmaddr_near:
	.word	fndsa_mq_iGM
fndsa_mqpoly_ntt_to_int__stage3_igmaddrs:
	.word	fndsa_mq_barrett3_iGM
	.word	fndsa_mq_barrett3_iGM_twist

@ =======================================================================
@ void fndsa_mqpoly_ntt_to_int(unsigned logn, uint16_t *d)
@ =======================================================================

	.align	2
	.global	fndsa_mqpoly_ntt_to_int
	.thumb
	.thumb_func
	.type	fndsa_mqpoly_ntt_to_int, %function
fndsa_mqpoly_ntt_to_int:
	push.w	{ r0, r4, r5, r6, r7, r8, r9, r10, r11, lr }
	vpush	{ d8-d15 }      @ q4-q7 (s16-s31) are callee-saved
	vmov	s0, r0          @ public logn; q0 otherwise holds scalar state

	@ ASSUMPTION: logn >= 2

	@ State:
	@   r0    scratch
	@   r1    &d[j1]
	@   r2    dt = 2*t
	@   r3    middle loop counter
	@   r4    x1
	@   r5    x2
	@   r6    s
	@   r7    innermost loop counter
	@   r8    &mq_GM[i + hm]
	@   r10   q
	@   r11   q:q
	@   r12   scratch
	@   r14   -1/q mod 2^32
	@
	@   s2    d
	@   s3    m

	@ We save the original d in s2.
	vmov	s2, r1
	@ m = n initially; we save m/2 to s3, and set r8 to &mq_iGM[m/2]
	cmp	r0, #9
	blo	fndsa_mqpoly_ntt_to_int__legacy_igm
	adr	r12, fndsa_mqpoly_ntt_to_int__stage3_igmaddrs
	ldmia.w	r12, { r8, r9 }
	sub.w	r9, r9, r8
	b	fndsa_mqpoly_ntt_to_int__igm_ready
fndsa_mqpoly_ntt_to_int__legacy_igm:
	adr	r8, fndsa_mqpoly_ntt_to_int__igmaddr_near
	ldr	r8, [r8]
	movs	r9, #0
fndsa_mqpoly_ntt_to_int__igm_ready:
	movs	r3, #1
	subs	r0, #1
	lsl	r0, r3, r0     @ r0 <- n/2 = 2^(logn-1)
	add.w	r8, r8, r0     @ r8 <- &mq_iGM[n/4]
	lsr	r3, r0, #1
	vmov	s3, r3         @ s3 <- n/4

	@ r0 <- 0
	movw	r0, #0
	@ r10 <- q
	movw	r10, #Q
	@ r11 <- q:q
	orr	r11, r10, r10, lsl #16
	@ r14 <- -1/q mod 2^32
	movw	r14, #(Q1I & 0xFFFF)
	movt	r14, #(Q1I >> 16)

	@ r8 is the pointer into mq_GM[] for the second outer iteration.
	@ r7 is the pointer into mq_GM[] for the first outer iteration.
	add	r7, r8, r3, lsl #1

	@ r3 is the loop counter. r10, r11 and r14 are constants used for
	@ modular reduction. r2, r4, r5 and r12 are scratch.

	@ First two iterations are specialized.
	@ For n >= 32, process eight four-coefficient groups in parallel while
	@ preserving the existing two-layer fusion.  Smaller public sizes keep
	@ the scalar Cortex-M4 path below.
	cmp	r3, #8
	blo	fndsa_mqpoly_ntt_to_int__L0
	cmp	r9, #0
	beq	fndsa_mqpoly_ntt_to_int__L0_mve

fndsa_mqpoly_ntt_to_int__L0_mve_stage3:
	@ SLOTHY B: halving pipeline a; (b;a)^(N-1); b.
	sub.w	r3, r3, #8
	vld40.16	{ q1, q2, q3, q4 }, [r1]
	vld41.16	{ q1, q2, q3, q4 }, [r1]
	vld42.16	{ q1, q2, q3, q4 }, [r1]
	vld43.16	{ q1, q2, q3, q4 }, [r1]
	vmov.i16	q5, #1
	add.w	r12, r7, r9
	vmov.i16	q7, #1
	vadd.i16	q6, q1, q2
	vsub.i16	q6, q6, r10
	vcmp.s16	lt, q6, zr
	vpst
	vaddt.i16	q6, q6, r10
	vsub.i16	q2, q1, q2
	vand	q5, q6, q5
	vcmp.i16	ne, q5, zr
	vpst
	vaddt.i16	q6, q6, r10
	vshr.u16	q1, q6, #1
	vld20.16	{ q5, q6 }, [r7]
	vld21.16	{ q5, q6 }, [r7]
	vadd.i16	q6, q3, q4
	vsub.i16	q6, q6, r10
	vcmp.s16	lt, q6, zr
	vpst
	vaddt.i16	q6, q6, r10
	vsub.i16	q4, q3, q4
	vand	q7, q6, q7
	vcmp.i16	ne, q7, zr
	vpst
	vaddt.i16	q6, q6, r10
	vshr.u16	q3, q6, #1
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, r10
	vld20.16	{ q6, q7 }, [r12]
	vld21.16	{ q6, q7 }, [r12]
	add.w	r12, r7, r9
	vadd.i16	q7, q1, q3
	vqrdmulh.s16	q6, q2, q6
	vsub.i16	q7, q7, r10
	vmul.i16	q2, q2, q5
	vcmp.s16	lt, q7, zr
	vpst
	vaddt.i16	q7, q7, r10
	vmov.i16	q5, #1
	vand	q5, q7, q5
	vsub.i16	q3, q1, q3
	vcmp.i16	ne, q5, zr
	vpst
	vaddt.i16	q7, q7, r10
	vshr.u16	q1, q7, #1
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
fndsa_mqpoly_ntt_to_int__L0_mve_stage3_slothyB_kernel:
	vmla.i16	q2, q6, r10
	vld20.16	{ q6, q7 }, [r12]
	vld21.16	{ q6, q7 }, [r12]
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, r10
	vqrdmulh.s16	q7, q4, q7
	vld20.16	{ q5, q6 }, [r7]
	vld21.16	{ q5, q6 }, [r7]
	vcmp.s16	lt, q3, zr
	vpst
	vaddt.i16	q3, q3, r10
	vmul.i16	q4, q4, q6
	add.w	r7, r7, #32
	vmla.i16	q4, q7, r10
	add.w	r12, r8, r9
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	vldrh.u16	q5, [r8]
	add.w	r8, r8, #16
	vldrh.u16	q6, [r12]
	vadd.i16	q7, q2, q4
	add.w	r12, r7, r9
	vsub.i16	q4, q2, q4
	vqrdmulh.s16	q2, q3, q6
	vsub.i16	q7, q7, r10
	vmul.i16	q3, q3, q5
	vcmp.s16	lt, q7, zr
	vpst
	vaddt.i16	q7, q7, r10
	vmla.i16	q3, q2, r10
	vmov.i16	q2, #1
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	vand	q2, q7, q2
	vqrdmulh.s16	q6, q4, q6
	vcmp.i16	ne, q2, zr
	vpst
	vaddt.i16	q7, q7, r10
	vmul.i16	q4, q4, q5
	vmla.i16	q4, q6, r10
	vshr.u16	q2, q7, #1
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	vcmp.s16	lt, q3, zr
	vpst
	vaddt.i16	q3, q3, r10
	vst40.16	{ q1, q2, q3, q4 }, [r1]
	vst41.16	{ q1, q2, q3, q4 }, [r1]
	vst42.16	{ q1, q2, q3, q4 }, [r1]
	vst43.16	{ q1, q2, q3, q4 }, [r1]
	add.w	r1, r1, #64
	vmov.i16	q5, #1
	vld40.16	{ q1, q2, q3, q4 }, [r1]
	vld41.16	{ q1, q2, q3, q4 }, [r1]
	vld42.16	{ q1, q2, q3, q4 }, [r1]
	vld43.16	{ q1, q2, q3, q4 }, [r1]
	vmov.i16	q7, #1
	vadd.i16	q6, q1, q2
	vsub.i16	q6, q6, r10
	vcmp.s16	lt, q6, zr
	vpst
	vaddt.i16	q6, q6, r10
	vsub.i16	q2, q1, q2
	vand	q7, q6, q7
	vcmp.i16	ne, q7, zr
	vpst
	vaddt.i16	q6, q6, r10
	vshr.u16	q1, q6, #1
	vadd.i16	q7, q3, q4
	vsub.i16	q7, q7, r10
	vcmp.s16	lt, q7, zr
	vpst
	vaddt.i16	q7, q7, r10
	vsub.i16	q4, q3, q4
	vand	q5, q7, q5
	vcmp.i16	ne, q5, zr
	vpst
	vaddt.i16	q7, q7, r10
	vld20.16	{ q5, q6 }, [r7]
	vld21.16	{ q5, q6 }, [r7]
	vshr.u16	q3, q7, #1
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, r10
	vld20.16	{ q6, q7 }, [r12]
	vld21.16	{ q6, q7 }, [r12]
	vadd.i16	q7, q1, q3
	vsub.i16	q7, q7, r10
	vcmp.s16	lt, q7, zr
	vpst
	vaddt.i16	q7, q7, r10
	vqrdmulh.s16	q6, q2, q6
	vmul.i16	q2, q2, q5
	vmov.i16	q5, #1
	vand	q5, q7, q5
	vsub.i16	q3, q1, q3
	vcmp.i16	ne, q5, zr
	vpst
	vaddt.i16	q7, q7, r10
	add.w	r12, r7, r9
	vshr.u16	q1, q7, #1
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	subs	r3, #8
	bne	fndsa_mqpoly_ntt_to_int__L0_mve_stage3_slothyB_kernel
	vmla.i16	q2, q6, r10
	vld20.16	{ q6, q7 }, [r12]
	vld21.16	{ q6, q7 }, [r12]
	vcmp.s16	lt, q3, zr
	vpst
	vaddt.i16	q3, q3, r10
	vqrdmulh.s16	q7, q4, q7
	vld20.16	{ q5, q6 }, [r7]
	vld21.16	{ q5, q6 }, [r7]
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, r10
	vmul.i16	q4, q4, q6
	vmla.i16	q4, q7, r10
	vmov.i16	q6, #1
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	add.w	r12, r8, r9
	add.w	r7, r7, #32
	vadd.i16	q5, q2, q4
	vldrh.u16	q7, [r8]
	vsub.i16	q5, q5, r10
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, r10
	add.w	r8, r8, #16
	vsub.i16	q4, q2, q4
	vand	q6, q5, q6
	vcmp.i16	ne, q6, zr
	vpst
	vaddt.i16	q5, q5, r10
	vldrh.u16	q6, [r12]
	vshr.u16	q2, q5, #1
	vqrdmulh.s16	q5, q3, q6
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	vmul.i16	q3, q3, q7
	vmla.i16	q3, q5, r10
	vqrdmulh.s16	q6, q4, q6
	vcmp.s16	lt, q3, zr
	vpst
	vaddt.i16	q3, q3, r10
	vmul.i16	q4, q4, q7
	vmla.i16	q4, q6, r10
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	vst40.16	{ q1, q2, q3, q4 }, [r1]
	vst41.16	{ q1, q2, q3, q4 }, [r1]
	vst42.16	{ q1, q2, q3, q4 }, [r1]
	vst43.16	{ q1, q2, q3, q4 }, [r1]
	add.w	r1, r1, #64
	@ Restore public logn kept in s0 for the shared epilogue.
	ldr	r12, [sp, #64]
	vmov	s0, r12
	b	fndsa_mqpoly_ntt_to_int__L0_done


fndsa_mqpoly_ntt_to_int__L0_mve:
	@ Input layout for each group is x1,x2,y1,y2.  VLD4 deinterleaves
	@ eight groups directly into q1,q2,q3,q4.
	vld40.16	{ q1, q2, q3, q4 }, [r1]
	vld41.16	{ q1, q2, q3, q4 }, [r1]
	vld42.16	{ q1, q2, q3, q4 }, [r1]
	vld43.16	{ q1, q2, q3, q4 }, [r1]

	@ First-layer twiddles are interleaved s1,s2 for each group.
	vld20.16	{ q5, q6 }, [r7]
	vld21.16	{ q5, q6 }, [r7]
	add.w	r7, r7, #32

	@ First inverse butterfly: q1 <- half(q1+q2), q2 <- q1-q2.
	vadd.i16	q7, q1, q2
	vsub.i16	q7, q7, r10
	vcmp.s16	lt, q7, zr
	vpst
	vaddt.i16	q7, q7, r10
	vsub.i16	q2, q1, q2
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, r10
	vmov.i16	q1, #1
	vand	q1, q7, q1
	vcmp.i16	ne, q1, zr
	vpst
	vaddt.i16	q7, q7, r10
	vshr.u16	q1, q7, #1

	@ q2 <- mmul(q2,q5); q5 is dead after the initial vector product.
	vmov.i32	q7, #0
	vcmp.i16	eq, q2, q7
	vmulh.u16	q7, q2, q5
	vmul.i16	q2, q2, q5
	vdup.16	q5, r14
	vmulh.u16	q5, q2, q5
	movw	r12, #Q1IHI
	vmul.i16	q2, q2, r12
	vmul.i16	q7, q7, r14
	vadd.i16	q2, q2, q7
	vadd.i16	q2, q2, q5
	vdup.16	q5, r10
	vmulh.u16	q2, q2, q5
	movs	r12, #1
	vadd.i16	q2, q2, r12
	vpst
	vsubt.i16	q2, q2, r12

	@ Second inverse butterfly: q3 <- half(q3+q4), q4 <- q3-q4.
	vadd.i16	q5, q3, q4
	vsub.i16	q5, q5, r10
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, r10
	vsub.i16	q4, q3, q4
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	vmov.i16	q3, #1
	vand	q3, q5, q3
	vcmp.i16	ne, q3, zr
	vpst
	vaddt.i16	q5, q5, r10
	vshr.u16	q3, q5, #1

	@ q4 <- mmul(q4,q6); q6 is dead after the initial vector product.
	vmov.i32	q7, #0
	vcmp.i16	eq, q4, q7
	vmulh.u16	q7, q4, q6
	vmul.i16	q4, q4, q6
	vdup.16	q6, r14
	vmulh.u16	q6, q4, q6
	movw	r12, #Q1IHI
	vmul.i16	q4, q4, r12
	vmul.i16	q7, q7, r14
	vadd.i16	q4, q4, q7
	vadd.i16	q4, q4, q6
	vdup.16	q6, r10
	vmulh.u16	q4, q4, q6
	movs	r12, #1
	vadd.i16	q4, q4, r12
	vpst
	vsubt.i16	q4, q4, r12

	@ Second fused layer.  q1/q3 and q2/q4 are its two butterflies.
	@ Both use the same per-group twiddle loaded contiguously from r8.
	vldrh.u16	q7, [r8]
	add.w	r8, r8, #16

	vadd.i16	q5, q1, q3
	vsub.i16	q5, q5, r10
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, r10
	vsub.i16	q3, q1, q3
	vcmp.s16	lt, q3, zr
	vpst
	vaddt.i16	q3, q3, r10
	vmov.i16	q6, #1
	vand	q6, q5, q6
	vcmp.i16	ne, q6, zr
	vpst
	vaddt.i16	q5, q5, r10
	vshr.u16	q1, q5, #1

	vadd.i16	q5, q2, q4
	vsub.i16	q5, q5, r10
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, r10
	vsub.i16	q4, q2, q4
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	vmov.i16	q6, #1
	vand	q6, q5, q6
	vcmp.i16	ne, q6, zr
	vpst
	vaddt.i16	q5, q5, r10
	vshr.u16	q2, q5, #1

	@ q3 <- mmul(q3,q7), preserving q7 for q4.
	vmov.i32	q5, #0
	vcmp.i16	eq, q3, q5
	vmulh.u16	q5, q3, q7
	vmul.i16	q3, q3, q7
	vdup.16	q6, r14
	vmulh.u16	q6, q3, q6
	movw	r12, #Q1IHI
	vmul.i16	q3, q3, r12
	vmul.i16	q5, q5, r14
	vadd.i16	q3, q3, q5
	vadd.i16	q3, q3, q6
	vdup.16	q6, r10
	vmulh.u16	q3, q3, q6
	movs	r12, #1
	vadd.i16	q3, q3, r12
	vpst
	vsubt.i16	q3, q3, r12

	@ q4 <- mmul(q4,q7).
	vmov.i32	q5, #0
	vcmp.i16	eq, q4, q5
	vmulh.u16	q5, q4, q7
	vmul.i16	q4, q4, q7
	vdup.16	q6, r14
	vmulh.u16	q6, q4, q6
	movw	r12, #Q1IHI
	vmul.i16	q4, q4, r12
	vmul.i16	q5, q5, r14
	vadd.i16	q4, q4, q5
	vadd.i16	q4, q4, q6
	vdup.16	q6, r10
	vmulh.u16	q4, q4, q6
	movs	r12, #1
	vadd.i16	q4, q4, r12
	vpst
	vsubt.i16	q4, q4, r12

	@ Output layout is z0,z1,z2,z3 for each of the eight groups.
	vst40.16	{ q1, q2, q3, q4 }, [r1]
	vst41.16	{ q1, q2, q3, q4 }, [r1]
	vst42.16	{ q1, q2, q3, q4 }, [r1]
	vst43.16	{ q1, q2, q3, q4 }, [r1]
	add.w	r1, r1, #64

	subs	r3, #8
	bne	fndsa_mqpoly_ntt_to_int__L0_mve
	b	fndsa_mqpoly_ntt_to_int__L0_done

fndsa_mqpoly_ntt_to_int__L0:
	@ First iteration: values are in x1 x2 y1 y2 order.
	ldr	r2, [r1]        @ r2 <- x1:x2
	ldr	r5, [r1, #4]    @ r5 <- y1:y2
	ldr.w	r6, [r7], #4    @ r6 <- s1:s2

	@ r4 <- x1:y1
	pkhbt	r4, r2, r5, lsl #16
	@ r5 <- x2:y2
	pkhtb	r5, r5, r2, asr #16
	@ r2 <- (x1+x2)/2:(y1+y2)/2
	sadd16	r2, r4, r5
	ssub16	r12, r2, r11
	sel	r2, r12, r2
	and	r12, r2, #0x00010001
	umlal	r2, r12, r12, r10
	lsr.w	r2, r2, #1
	@ r5 <- (x1-x2):(y1-y2)
	ssub16	r5, r4, r5
	sel	r12, r0, r11
	sadd16	r5, r5, r12
	@ r4 <- mmul(x1-x2,s)
	smulbb	r4, r5, r6
	mul	r12, r4, r14
	umaal	r14, r4, r12, r10
	@ r5 <- mmul(y1-y2,s)
	smultt	r5, r5, r6
	mul	r12, r5, r14
	umaal	r14, r5, r12, r10

	@ Second iteration. Normally we get x1 y1 x2 y2 from RAM; here,
	@ we have x1:x2 in r2, y1 in r4 and y2 in r5.  Preload this
	@ current group's second public twiddle before the independent
	@ register-only repack, without crossing a loop-iteration boundary.
	ldrh	r6, [r8], #2
	@ Reorganize the values:
	pkhbt	r4, r2, r4, lsl #16   @ r4 <- x1:y1
	lsl.w	r5, r5, #16
	orr	r5, r5, r2, lsr #16   @ r5 <- x2:y2

	@ r2 <- (x1+x2)/2:(y1+y2)/2
	sadd16	r2, r4, r5
	ssub16	r12, r2, r11
	sel	r2, r12, r2
	and	r12, r2, #0x00010001
	umlal	r2, r12, r12, r10
	lsr.w	r2, r2, #1
	@ r5 <- (x1-x2):(y1-y2)
	ssub16	r5, r4, r5
	sel	r12, r0, r11
	sadd16	r5, r5, r12
	@ r4 <- mmul(x1-x2,s)
	smulbb	r4, r5, r6
	mul	r12, r4, r14
	umaal	r14, r4, r12, r10
	@ r5 <- mmul(y1-y2,s)
	smultb	r5, r5, r6
	mul	r12, r5, r14
	umaal	r14, r5, r12, r10

	@ Repack values, to write them in x1 y1 x2 y2 order.
	str.w	r2, [r1], #4
	pkhbt	r4, r4, r5, lsl #16
	str.w	r4, [r1], #4

	@ Loop n/4 times.
	subs	r3, #1
	bne	fndsa_mqpoly_ntt_to_int__L0

fndsa_mqpoly_ntt_to_int__L0_done:
	@ FN-DSA-512 mixed schedule.  The existing boundary kernel has just
	@ reversed forward layers m=256 and m=128.  Reverse m=64 and m=32 in
	@ one packed GS2 pass before entering the middle GS3 kernel.
	vmov	r4, s0
	cmp	r4, #9
	beq	fndsa_mqpoly_ntt_to_int__L512_GS2_packed

	@ Prepare for remaining iterations.
	@ r2 <- -2*t = -8
	movs	r2, #8
	rsbs	r2, #0
	@ r3 <- m (for next iteration)
	vmov	r3, s3

	@ If logn=2 then m=1 and we are finished.
	cmp	r3, #1
	beq	fndsa_mqpoly_ntt_to_int__Lend

	@ Only FN-DSA-1024 has m=n/4=256 here.  Its remaining eight inverse
	@ layers use the dedicated four-pair GS path below.  Other public
	@ degrees retain the stage-1 loop byte-for-byte.
	cmp	r3, #256
	beq	fndsa_mqpoly_ntt_to_int__I2_setup
	b	fndsa_mqpoly_ntt_to_int__L1

fndsa_mqpoly_ntt_to_int__I2_setup:
	@ The already existing L0 kernel consumed inverse layers 0 and 1.
	@ Start the first remaining pair with m=256 and t=4 coefficients.
	movs	r2, #4

fndsa_mqpoly_ntt_to_int__I2_outer:
	vmov	r1, s2
	vmov	r3, s3
	@ For a pair beginning at m, the first inverse layer consumes
	@ iGM[m/2..m-1], while the second consumes iGM[m/4..m/2-1].
	adr	r8, fndsa_mqpoly_ntt_to_int__stage3_igmaddrs
	ldr	r8, [r8]
	add.w	r7, r8, r3
	add.w	r8, r8, r3, lsr #1
	lsr.w	r3, r3, #2
	@ Byte distance between each of the four streams.
	lsl.w	r4, r2, #1

fndsa_mqpoly_ntt_to_int__I2_middle:
	@ Two first-layer inverse twiddles, followed by their parent.
	MQ_LOAD_PAIR	r5, r7
	MQ_LOAD_PAIR	r6, r7
	MQ_LOAD_PAIR	r11, r8

	@ As in the forward kernel, t=4 uses only the low half of each q
	@ register so that no 128-bit load crosses the end of the array.
	cmp	r2, #4
	beq	fndsa_mqpoly_ntt_to_int__I2_half
	lsr.w	r0, r2, #3

fndsa_mqpoly_ntt_to_int__I2_vector:
	vldrh.u16	q1, [r1]
	add.w	r12, r1, r4
	vldrh.u16	q2, [r12]
	add.w	r12, r12, r4
	vldrh.u16	q3, [r12]
	add.w	r12, r12, r4
	vldrh.u16	q4, [r12]
	b	fndsa_mqpoly_ntt_to_int__I2_butterflies

fndsa_mqpoly_ntt_to_int__I2_half:
	vldr	d2, [r1]
	add.w	r12, r1, r4
	vldr	d4, [r12]
	add.w	r12, r12, r4
	vldr	d6, [r12]
	add.w	r12, r12, r4
	vldr	d8, [r12]

fndsa_mqpoly_ntt_to_int__I2_butterflies:
	@ SLOTHY iteration-local arithmetic schedule (A and B).
	vadd.i16	q6, q1, q2
	asr.w	r14, r5, #16
	vsub.i16	q6, q6, r10
	vcmp.s16	lt, q6, zr
	vpst
	vaddt.i16	q6, q6, r10
	vsub.i16	q2, q1, q2
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, r10
	vmov.i16	q5, #1
	vand	q5, q6, q5
	vcmp.i16	ne, q5, zr
	vpst
	vaddt.i16	q6, q6, r10
	vdup.16	q7, r5
	vdup.16	q1, r14
	vshr.u16	q5, q6, #1
	asr.w	r14, r6, #16
	vadd.i16	q6, q3, q4
	vqrdmulh.s16	q1, q2, q1
	vsub.i16	q6, q6, r10
	vmul.i16	q2, q2, q7
	vcmp.s16	lt, q6, zr
	vpst
	vaddt.i16	q6, q6, r10
	vmla.i16	q2, q1, r10
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, r10
	vsub.i16	q4, q3, q4
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	vmov.i16	q3, #1
	vand	q3, q6, q3
	vcmp.i16	ne, q3, zr
	vpst
	vaddt.i16	q6, q6, r10
	vshr.u16	q3, q6, #1
	vdup.16	q6, r6
	vdup.16	q7, r14
	asr.w	r14, r11, #16
	vadd.i16	q1, q5, q3
	vqrdmulh.s16	q7, q4, q7
	vsub.i16	q1, q1, r10
	vmul.i16	q4, q4, q6
	vcmp.s16	lt, q1, zr
	vpst
	vaddt.i16	q1, q1, r10
	vmla.i16	q4, q7, r10
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	vsub.i16	q3, q5, q3
	vcmp.s16	lt, q3, zr
	vpst
	vaddt.i16	q3, q3, r10
	vmov.i16	q5, #1
	vand	q5, q1, q5
	vcmp.i16	ne, q5, zr
	vpst
	vaddt.i16	q1, q1, r10
	vdup.16	q5, r14
	vdup.16	q6, r11
	vqrdmulh.s16	q7, q3, q5
	vadd.i16	q5, q2, q4
	vmul.i16	q3, q3, q6
	vsub.i16	q5, q5, r10
	asr.w	r14, r11, #16
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, r10
	vmla.i16	q3, q7, r10
	vsub.i16	q4, q2, q4
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	vmov.i16	q2, #1
	vand	q2, q5, q2
	vcmp.i16	ne, q2, zr
	vpst
	vaddt.i16	q5, q5, r10
	vdup.16	q6, r14
	vshr.u16	q2, q5, #1
	vqrdmulh.s16	q5, q4, q6
	vdup.16	q7, r11
	vshr.u16	q1, q1, #1
	vmul.i16	q4, q4, q7
	vcmp.s16	lt, q3, zr
	vpst
	vaddt.i16	q3, q3, r10
	vmla.i16	q4, q5, r10
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	cmp	r2, #4
	beq	fndsa_mqpoly_ntt_to_int__I2_half_store
	vstrh.16	q1, [r1]
	add.w	r12, r1, r4
	vstrh.16	q2, [r12]
	add.w	r12, r12, r4
	vstrh.16	q3, [r12]
	add.w	r12, r12, r4
	vstrh.16	q4, [r12]
	add.w	r1, r1, #16
	subs	r0, #1
	bne	fndsa_mqpoly_ntt_to_int__I2_vector
	add.w	r1, r1, r4, lsl #1
	add.w	r1, r1, r4
	b	fndsa_mqpoly_ntt_to_int__I2_middle_done

fndsa_mqpoly_ntt_to_int__I2_half_store:
	vstr	d2, [r1]
	add.w	r12, r1, r4
	vstr	d4, [r12]
	add.w	r12, r12, r4
	vstr	d6, [r12]
	add.w	r12, r12, r4
	vstr	d8, [r12]
	add.w	r1, r1, r4, lsl #2

fndsa_mqpoly_ntt_to_int__I2_middle_done:
	subs	r3, #1
	bne	fndsa_mqpoly_ntt_to_int__I2_middle

	@ Move four levels toward the NTT root and grow t by four.
	vmov	r3, s3
	lsr.w	r3, r3, #2
	vmov	s3, r3
	lsl.w	r2, r2, #2
	cmp	r3, #1
	bne	fndsa_mqpoly_ntt_to_int__I2_outer
	b	fndsa_mqpoly_ntt_to_int__Lend

fndsa_mqpoly_ntt_to_int__L1:
	@ In the 512 mixed candidate, inverse layers corresponding to forward
	@ m=16,8,4 are handled together.  Test m first because q0 is reused by
	@ that kernel and no longer carries logn afterwards.
	cmp	r3, #32
	bne	fndsa_mqpoly_ntt_to_int__L1_regular
	vmov	r4, s0
	cmp	r4, #9
	beq	fndsa_mqpoly_ntt_to_int__L3x512
fndsa_mqpoly_ntt_to_int__L1_regular:
	@ Rewind r1 to start of array.
	vmov	r1, s2

	@ m is in r3. r8 was left at &mq_iGM[2*m]; we need to adjust it
	@ to &mq_iGM[m/2], by subtracting 3*m (each element is two bytes).
	sub	r8, r8, r3, lsl #1
	sub.w	r8, r8, r3

	@ Middle loop has m/2 iterations (r3 is used as counter).
fndsa_mqpoly_ntt_to_int__L2:
	ldrh	r6, [r8], #2   @ s <- mq_iGM[i + m/2]

	asrs	r7, r2, #1     @ r7 <- -t
	@ We use r1 to point to the second pair (x2:y2); r2 is negative.
	@ The inner loop will inherently adjust r1 to point to the start
	@ of the next chunk for the next middle loop iteration.
	subs	r1, r1, r2

	@ Process eight inverse butterflies per iteration whenever t >= 8.
	@ r7 is the negative coefficient count (-t), hence -4 uses the scalar
	@ pairwise path below and -8,-16,... use this vector path.
	cmp	r7, #-8
	bgt	fndsa_mqpoly_ntt_to_int__L3

fndsa_mqpoly_ntt_to_int__L3_mve:
	@ q1 <- first half, q2 <- second half.
	add.w	r4, r1, r2
	vldrh.u16	q1, [r4]
	vldrh.u16	q2, [r1]
	vdup.16	q3, r10

	@ First output is mq_half(mq_add(q1,q2)).
	vadd.i16	q4, q1, q2
	vsub.i16	q4, q4, q3
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q3
	vmov.i16	q3, #1
	vand	q3, q4, q3
	vcmp.i16	ne, q3, zr
	vdup.16	q3, r10
	vpst
	vaddt.i16	q4, q4, q3
	vshr.u16	q4, q4, #1
	vstrh.16	q4, [r4]

	@ q4 <- mq_sub(q1,q2), then q4 <- mmul(q4,s).
	vsub.i16	q4, q1, q2
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q3
	vmov.i32	q1, #0
	vcmp.i16	eq, q4, q1
	vdup.16	q3, r6
	vmulh.u16	q1, q4, q3
	vmul.i16	q4, q4, q3
	vdup.16	q2, r14
	vmulh.u16	q2, q4, q2
	movw	r12, #Q1IHI
	vmul.i16	q4, q4, r12
	vmul.i16	q1, q1, r14
	vadd.i16	q4, q4, q1
	vadd.i16	q4, q4, q2
	vdup.16	q2, r10
	vmulh.u16	q4, q4, q2
	movs	r12, #1
	vadd.i16	q4, q4, r12
	vpst
	vsubt.i16	q4, q4, r12
	vstrh.16	q4, [r1]

	add.w	r1, r1, #16
	adds	r7, #8
	bne	fndsa_mqpoly_ntt_to_int__L3_mve
	b	fndsa_mqpoly_ntt_to_int__L3_done

fndsa_mqpoly_ntt_to_int__L3:
	@ Each inner loop iteration processes two pairs (x1,x2) and (y1,y2).
	ldr	r4, [r1, r2]   @ r4 <- x1:y1
	ldr	r5, [r1]       @ r5 <- x2:y2

	@ r4 <- (x1+x2):(y1+y2)
	@ r5 <- (x1-x2):(y1-x2)
	sadd16	r12, r4, r5
	ssub16	r5, r4, r5
	sel	r4, r0, r11
	sadd16	r5, r5, r4
	ssub16	r4, r12, r11
	sel	r4, r4, r12
	@ r4 <- (x1+x2)/2:(y1+y2)/2
	and	r12, r4, #0x00010001
	umlal	r4, r12, r12, r10
	lsr.w	r4, r4, #1
	@ Write first output word
	str.w	r4, [r1, r2]

	@ r5 <- mmul(x1-x2,s):mmul(y1-y2,s)
	smulbb	r4, r5, r6
	mul	r12, r4, r14
	umaal	r14, r4, r12, r10
	smultb	r5, r5, r6
	mul	r12, r5, r14
	umaal	r14, r5, r12, r10
	pkhbt	r5, r4, r5, lsl #16
	@ Write second output word
	str.w	r5, [r1], #4

	@ We should do t iterations, but since we process a pair of elements
	@ each time, we only do t/2 iterations. Take care that the r7 counter
	@ is negative.
	adds	r7, #2
	bne	fndsa_mqpoly_ntt_to_int__L3

fndsa_mqpoly_ntt_to_int__L3_done:

	@ We loop m/2 times
	subs	r3, #2
	bne	fndsa_mqpoly_ntt_to_int__L2

	@ Replace -t with -dt = 2*(-t)
	lsl.w	r2, r2, #1

	@ Replace m with m/2. We are finished when m becomes 1.
	vmov	r3, s3
	lsr.w	r3, r3, #1
	vmov	s3, r3
	cmp	r3, #1
	bne	fndsa_mqpoly_ntt_to_int__L1
	b	fndsa_mqpoly_ntt_to_int__Lend

@ Packed inverse of forward m=64 and m=32.  Two 16-coefficient groups
@ occupy the low/high 64-bit halves of q1-q4.
	.align	2
fndsa_mqpoly_ntt_to_int__L512_GS2_packed_slothyB_igmaddr:
	.word	fndsa_mq_barrett3_iGM
fndsa_mqpoly_ntt_to_int__L512_GS2_packed:
	adr	r8, fndsa_mqpoly_ntt_to_int__L512_GS2_packed_slothyB_igmaddr
	ldr	r8, [r8]
	add.w	r4, r8, #64       @ parent iGM[32]
	add.w	r0, r8, #128      @ children iGM[64]
	movs	r2, #16
	vmov	r1, s2
fndsa_mqpoly_ntt_to_int__L512_GS2_packed_loop:
	@ SLOTHY B: halving pipeline a; (b;a)^(N-1); b.
	sub.w	r2, r2, #1
	ldrh	r5, [r4]
	add.w	r14, r4, r9
	ldrh	r14, [r14]
	add.w	r4, r4, #2
	orr	r5, r5, r14, lsl #16
	ldrh	r6, [r4]
	add.w	r14, r4, r9
	ldrh	r14, [r14]
	orr	r6, r6, r14, lsl #16
	ldrh	r7, [r0]
	add.w	r14, r0, r9
	ldrh	r14, [r14]
	add.w	r0, r0, #2
	orr	r7, r7, r14, lsl #16
	ldrh	r8, [r0]
	add.w	r14, r0, r9
	ldrh	r14, [r14]
	add.w	r0, r0, #2
	orr	r8, r8, r14, lsl #16
	ldrh	r11, [r0]
	add.w	r14, r0, r9
	ldrh	r14, [r14]
	add.w	r0, r0, #2
	orr	r11, r11, r14, lsl #16
	ldrh	r3, [r0]
	add.w	r14, r0, r9
	ldrh	r14, [r14]
	vldr	d2, [r1, #0]
	orr	r3, r3, r14, lsl #16
	vldr	d3, [r1, #32]
	vmov.i16	q6, #1
	vldr	d4, [r1, #8]
	vdup.16	q7, r10
	vldr	d5, [r1, #40]
	add.w	r0, r0, #2
	vadd.i16	q5, q1, q2
	vldr	d6, [r1, #16]
	vsub.i16	q5, q5, q7
	vldr	d7, [r1, #48]
	vsub.i16	q2, q1, q2
	vldr	d8, [r1, #24]
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q7
	add.w	r4, r4, #2
	vldr	d9, [r1, #56]
	vand	q6, q5, q6
	vcmp.i16	ne, q6, zr
	vpst
	vaddt.i16	q5, q5, q7
	vshr.u16	q1, q5, #1
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, q7
	vdup.16	q7, r10
	asr.w	r14, r7, #16
	vdup.16	q6, r14
	asr.w	r12, r11, #16
	vadd.i16	q5, q3, q4
	uxth	r12, r12
	vsub.i16	q5, q5, q7
	orr	r12, r12, r12, lsl #16
	vmov	d13, r12, r12
	uxth	r12, r11
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q7
	orr	r12, r12, r12, lsl #16
	asr.w	r14, r8, #16
	vsub.i16	q4, q3, q4
	vqrdmulh.s16	q3, q2, q6
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q7
	vmov.i16	q6, #1
	vand	q6, q5, q6
	vcmp.i16	ne, q6, zr
	vpst
	vaddt.i16	q5, q5, q7
	vdup.16	q7, r7
	vmov	d15, r12, r12
	uxth	r12, r3
	vdup.16	q6, r14
fndsa_mqpoly_ntt_to_int__L512_GS2_packed_loop_slothyB_kernel:
	vmul.i16	q2, q2, q7
	vdup.16	q7, r8
	vmla.i16	q2, q3, r10
	vshr.u16	q3, q5, #1
	orr	r12, r12, r12, lsl #16
	vmov	d15, r12, r12
	asr.w	r12, r3, #16
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, r10
	uxth	r12, r12
	orr	r12, r12, r12, lsl #16
	asr.w	r14, r5, #16
	vmov	d13, r12, r12
	asr.w	r12, r6, #16
	vadd.i16	q5, q1, q3
	uxth	r12, r12
	vsub.i16	q3, q1, q3
	vqrdmulh.s16	q1, q4, q6
	vmov.i16	q6, #1
	vmul.i16	q4, q4, q7
	vdup.16	q7, r10
	vmla.i16	q4, q1, r10
	vsub.i16	q5, q5, q7
	orr	r12, r12, r12, lsl #16
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q7
	vand	q6, q5, q6
	vcmp.i16	ne, q6, zr
	vpst
	vaddt.i16	q5, q5, q7
	vshr.u16	q1, q5, #1
	vcmp.s16	lt, q3, zr
	vpst
	vaddt.i16	q3, q3, q7
	vstr	d2, [r1, #0]
	vdup.16	q6, r14
	vadd.i16	q5, q2, q4
	asr.w	r14, r5, #16
	vmov	d13, r12, r12
	uxth	r12, r6
	vdup.16	q7, r5
	orr	r12, r12, r12, lsl #16
	vsub.i16	q4, q2, q4
	vqrdmulh.s16	q2, q3, q6
	vmov	d15, r12, r12
	uxth	r12, r6
	vmov.i16	q6, #1
	vmul.i16	q3, q3, q7
	vdup.16	q7, r10
	vmla.i16	q3, q2, r10
	vsub.i16	q5, q5, q7
	orr	r12, r12, r12, lsl #16
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q7
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q7
	vstr	d3, [r1, #32]
	vand	q6, q5, q6
	vcmp.i16	ne, q6, zr
	vpst
	vaddt.i16	q5, q5, q7
	vdup.16	q7, r5
	vmov	d15, r12, r12
	asr.w	r12, r6, #16
	vshr.u16	q2, q5, #1
	uxth	r12, r12
	vdup.16	q6, r14
	orr	r12, r12, r12, lsl #16
	vmov	d13, r12, r12
	vstr	d4, [r1, #8]
	vqrdmulh.s16	q5, q4, q6
	vcmp.s16	lt, q3, zr
	vpst
	vaddt.i16	q3, q3, r10
	vmul.i16	q4, q4, q7
	vstr	d5, [r1, #40]
	vmla.i16	q4, q5, r10
	vstr	d6, [r1, #16]
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	vstr	d7, [r1, #48]
	add.w	r14, r4, r9
	vstr	d8, [r1, #24]
	vstr	d9, [r1, #56]
	add.w	r1, r1, #64
	ldrh	r5, [r4]
	ldrh	r14, [r14]
	add.w	r4, r4, #2
	orr	r5, r5, r14, lsl #16
	ldrh	r6, [r4]
	add.w	r14, r4, r9
	ldrh	r14, [r14]
	orr	r6, r6, r14, lsl #16
	ldrh	r7, [r0]
	add.w	r14, r0, r9
	ldrh	r14, [r14]
	add.w	r0, r0, #2
	orr	r7, r7, r14, lsl #16
	ldrh	r8, [r0]
	add.w	r14, r0, r9
	ldrh	r14, [r14]
	add.w	r0, r0, #2
	orr	r8, r8, r14, lsl #16
	ldrh	r11, [r0]
	add.w	r14, r0, r9
	ldrh	r14, [r14]
	add.w	r0, r0, #2
	orr	r11, r11, r14, lsl #16
	ldrh	r3, [r0]
	add.w	r14, r0, r9
	ldrh	r14, [r14]
	vldr	d2, [r1, #0]
	orr	r3, r3, r14, lsl #16
	vldr	d3, [r1, #32]
	vmov.i16	q6, #1
	vldr	d4, [r1, #8]
	vdup.16	q7, r10
	vldr	d5, [r1, #40]
	add.w	r0, r0, #2
	vadd.i16	q5, q1, q2
	vldr	d6, [r1, #16]
	vsub.i16	q5, q5, q7
	vldr	d7, [r1, #48]
	vsub.i16	q2, q1, q2
	vldr	d8, [r1, #24]
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q7
	add.w	r4, r4, #2
	vldr	d9, [r1, #56]
	asr.w	r14, r7, #16
	vand	q6, q5, q6
	asr.w	r12, r11, #16
	vcmp.i16	ne, q6, zr
	vpst
	vaddt.i16	q5, q5, q7
	uxth	r12, r12
	orr	r12, r12, r12, lsl #16
	vshr.u16	q1, q5, #1
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, q7
	vdup.16	q7, r10
	vdup.16	q6, r14
	asr.w	r14, r8, #16
	vadd.i16	q5, q3, q4
	vsub.i16	q5, q5, q7
	vmov	d13, r12, r12
	uxth	r12, r11
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q7
	orr	r12, r12, r12, lsl #16
	vsub.i16	q4, q3, q4
	vqrdmulh.s16	q3, q2, q6
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q7
	vmov.i16	q6, #1
	vand	q6, q5, q6
	vcmp.i16	ne, q6, zr
	vpst
	vaddt.i16	q5, q5, q7
	vdup.16	q7, r7
	vmov	d15, r12, r12
	uxth	r12, r3
	vdup.16	q6, r14
	subs	r2, #1
	bne	fndsa_mqpoly_ntt_to_int__L512_GS2_packed_loop_slothyB_kernel
	vmul.i16	q2, q2, q7
	vdup.16	q7, r8
	vmla.i16	q2, q3, r10
	vshr.u16	q3, q5, #1
	orr	r12, r12, r12, lsl #16
	vmov	d15, r12, r12
	asr.w	r12, r3, #16
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, r10
	uxth	r12, r12
	orr	r12, r12, r12, lsl #16
	vmov	d13, r12, r12
	vadd.i16	q5, q1, q3
	vsub.i16	q3, q1, q3
	vqrdmulh.s16	q1, q4, q6
	vmov.i16	q6, #1
	vmul.i16	q4, q4, q7
	vdup.16	q7, r10
	vmla.i16	q4, q1, r10
	vsub.i16	q5, q5, q7
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q7
	vand	q6, q5, q6
	vcmp.i16	ne, q6, zr
	vpst
	vaddt.i16	q5, q5, q7
	vshr.u16	q1, q5, #1
	vcmp.s16	lt, q3, zr
	vpst
	vaddt.i16	q3, q3, q7
	vdup.16	q7, r5
	asr.w	r14, r5, #16
	vdup.16	q6, r14
	asr.w	r12, r6, #16
	uxth	r12, r12
	vadd.i16	q5, q2, q4
	orr	r12, r12, r12, lsl #16
	vmov	d13, r12, r12
	uxth	r12, r6
	vsub.i16	q4, q2, q4
	orr	r12, r12, r12, lsl #16
	vmov	d15, r12, r12
	vqrdmulh.s16	q2, q3, q6
	vmov.i16	q6, #1
	vmul.i16	q3, q3, q7
	vdup.16	q7, r10
	vmla.i16	q3, q2, r10
	vsub.i16	q5, q5, q7
	asr.w	r14, r5, #16
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q7
	uxth	r12, r6
	orr	r12, r12, r12, lsl #16
	vstr	d2, [r1, #0]
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q7
	vstr	d3, [r1, #32]
	vand	q6, q5, q6
	vcmp.i16	ne, q6, zr
	vpst
	vaddt.i16	q5, q5, q7
	vdup.16	q7, r5
	vmov	d15, r12, r12
	asr.w	r12, r6, #16
	vshr.u16	q2, q5, #1
	uxth	r12, r12
	vdup.16	q6, r14
	orr	r12, r12, r12, lsl #16
	vmov	d13, r12, r12
	vstr	d4, [r1, #8]
	vqrdmulh.s16	q5, q4, q6
	vcmp.s16	lt, q3, zr
	vpst
	vaddt.i16	q3, q3, r10
	vmul.i16	q4, q4, q7
	vstr	d5, [r1, #40]
	vmla.i16	q4, q5, r10
	vstr	d6, [r1, #16]
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	vstr	d7, [r1, #48]
	vstr	d8, [r1, #24]
	vstr	d9, [r1, #56]
	add.w	r1, r1, #64

	@ r4 is now iGM[64], the state expected by the m=16,8,4 GS3 block.
	mov	r8, r4
	movs	r3, #32
	b	fndsa_mqpoly_ntt_to_int__L3x512

@ Three inverse layers for logn=9, reversing the forward m=16,8,4
@ block.  Each 128-coefficient block is evaluated depth-first: two GS
@ layers are completed independently in each half, then the halves are
@ joined by the third GS layer.  Only the upper half is spilled once.
fndsa_mqpoly_ntt_to_int__L3x512:
	sub	sp, sp, #16
	vmov	r12, s2
	@ At entry r8 is &iGM[64].  Derive starts for iGM[4], [8], [16].
	sub.w	r4, r8, #96
	str	r4, [sp, #8]       @ p2 = &iGM[16]
	sub.w	r5, r4, #16
	str	r5, [sp, #4]       @ p1 = &iGM[8]
	sub.w	r5, r4, #24
	str	r5, [sp, #0]       @ p0 = &iGM[4]
	str	r12, [sp, #12]
	mov	r1, r12
	movs	r3, #4

fndsa_mqpoly_ntt_to_int__L3x512_block:
	@ Seven inverse twiddles for this radix-8 block: 1 + 2 + 4.
	ldr	r12, [sp, #0]
	MQ_LOAD_PAIR	r4, r12
	str	r12, [sp, #0]
	ldr	r12, [sp, #4]
	MQ_LOAD_PAIR	r5, r12
	MQ_LOAD_PAIR	r6, r12
	str	r12, [sp, #4]
	ldr	r12, [sp, #8]
	MQ_LOAD_PAIR	r7, r12
	MQ_LOAD_PAIR	r8, r12
	MQ_LOAD_PAIR	r11, r12
	MQ_LOAD_PAIR	r0, r12
	str	r12, [sp, #8]

	movs	r2, #2
fndsa_mqpoly_ntt_to_int__L3x512_lanes:
	@ SLOTHY B: halving pipeline a; (b;a)^(N-1); b.
	sub.w	r2, r2, #1
	vdup.16	q6, r7
	vldrh.u16	q0, [r1]
	vmov.i16	q2, #1
	add.w	r12, r1, #32
	vdup.16	q4, r10
	vldrh.u16	q1, [r12]
	vdup.16	q3, r10
	add.w	r12, r1, #64
	vsub.i16	q5, q0, q1
	asr.w	r14, r7, #16
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q4
	vadd.i16	q0, q0, q1
	vsub.i16	q0, q0, q4
	vmov	q1, q5
	vdup.16	q5, r14
	asr.w	r14, r8, #16
	vcmp.s16	lt, q0, zr
	vpst
	vaddt.i16	q0, q0, q4
	vqrdmulh.s16	q5, q1, q5
	vmul.i16	q1, q1, q6
	vand	q2, q0, q2
	vmla.i16	q1, q5, r10
	vcmp.i16	ne, q2, zr
	vpst
	vaddt.i16	q0, q0, q4
	vldrh.u16	q2, [r12]
	add.w	r12, r1, #96
	vldrh.u16	q5, [r12]
	vshr.u16	q0, q0, #1
	vsub.i16	q4, q2, q5
	vadd.i16	q2, q2, q5
	vsub.i16	q2, q2, q3
	vdup.16	q6, r8
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, q3
	vmov.i16	q5, #1
	vand	q5, q2, q5
	vcmp.i16	ne, q5, zr
	vpst
	vaddt.i16	q2, q2, q3
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q3
	vmov	q3, q4
	vdup.16	q4, r14
	vshr.u16	q2, q2, #1
	vqrdmulh.s16	q4, q3, q4
	vdup.16	q5, r10
	vmul.i16	q3, q3, q6
	vcmp.s16	lt, q1, zr
	vpst
	vaddt.i16	q1, q1, r10
	vmla.i16	q3, q4, r10
	vcmp.s16	lt, q3, zr
	vpst
	vaddt.i16	q3, q3, r10
	vsub.i16	q4, q0, q2
	vadd.i16	q0, q0, q2
	vsub.i16	q0, q0, q5
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q5
	vmov	q2, q4
	asr.w	r14, r5, #16
	vdup.16	q6, r14
	asr.w	r14, r5, #16
	vsub.i16	q4, q1, q3
	vqrdmulh.s16	q6, q2, q6
	vadd.i16	q1, q1, q3
	add.w	r12, r1, #32
	vcmp.s16	lt, q0, zr
	vpst
	vaddt.i16	q0, q0, q5
	vmov.i16	q3, #1
	vand	q3, q0, q3
	vcmp.i16	ne, q3, zr
	vpst
	vaddt.i16	q0, q0, q5
	vshr.u16	q0, q0, #1
	vdup.16	q3, r5
	vstrh.16	q0, [r1]
	vdup.16	q5, r10
	vmul.i16	q2, q2, q3
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q5
	vmla.i16	q2, q6, r10
	vsub.i16	q1, q1, q5
	vcmp.s16	lt, q1, zr
	vpst
	vaddt.i16	q1, q1, q5
	vmov.i16	q6, #1
	vand	q6, q1, q6
	vcmp.i16	ne, q6, zr
	vpst
	vaddt.i16	q1, q1, q5
	vmov	q3, q4
	vdup.16	q5, r14
	vdup.16	q6, r5
	vqrdmulh.s16	q5, q3, q5
	vshr.u16	q1, q1, #1
	vmul.i16	q3, q3, q6
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, r10
	vstrh.16	q1, [r12]
	vmla.i16	q3, q5, r10
	add.w	r12, r1, #64
	vcmp.s16	lt, q3, zr
	vpst
	vaddt.i16	q3, q3, r10
	vstrh.16	q2, [r12]
	add.w	r12, r1, #96
	vstrh.16	q3, [r12]
	add.w	r12, r1, #128
	vdup.16	q5, r10
	vldrh.u16	q0, [r12]
	add.w	r12, r1, #160
	vldrh.u16	q1, [r12]
	add.w	r12, r1, #192
	vldrh.u16	q2, [r12]
	add.w	r12, r1, #224
	vsub.i16	q4, q0, q1
	vldrh.u16	q3, [r12]
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q5
	asr.w	r14, r11, #16
	vadd.i16	q0, q0, q1
	vsub.i16	q0, q0, q5
	vcmp.s16	lt, q0, zr
	vpst
	vaddt.i16	q0, q0, q5
	vmov.i16	q1, #1
	vand	q1, q0, q1
	vcmp.i16	ne, q1, zr
	vpst
	vaddt.i16	q0, q0, q5
	vshr.u16	q0, q0, #1
	vmov	q1, q4
	vdup.16	q6, r11
	vdup.16	q4, r14
	asr.w	r14, r0, #16
	vsub.i16	q5, q2, q3
	vqrdmulh.s16	q4, q1, q4
	vadd.i16	q2, q2, q3
	vmul.i16	q1, q1, q6
	vdup.16	q6, r10
	vmla.i16	q1, q4, r10
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q6
	vcmp.s16	lt, q1, zr
	vpst
	vaddt.i16	q1, q1, r10
	vsub.i16	q2, q2, q6
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, q6
	vmov.i16	q4, #1
	vand	q4, q2, q4
	vcmp.i16	ne, q4, zr
	vpst
	vaddt.i16	q2, q2, q6
	vshr.u16	q2, q2, #1
	vmov	q3, q5
	vdup.16	q5, r0
	vdup.16	q6, r14
	asr.w	r14, r6, #16
	vsub.i16	q4, q0, q2
	vqrdmulh.s16	q6, q3, q6
	vadd.i16	q0, q0, q2
fndsa_mqpoly_ntt_to_int__L3x512_lanes_slothyB_kernel:
	vdup.16	q2, r10
	vmul.i16	q3, q3, q5
	vsub.i16	q0, q0, q2
	vmla.i16	q3, q6, r10
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q2
	add.w	r12, r1, #128
	vldrh.u16	q5, [r1]
	vcmp.s16	lt, q0, zr
	vpst
	vaddt.i16	q0, q0, q2
	vmov.i16	q7, #1
	vand	q7, q0, q7
	vcmp.i16	ne, q7, zr
	vpst
	vaddt.i16	q0, q0, q2
	vshr.u16	q0, q0, #1
	vdup.16	q7, r14
	vcmp.s16	lt, q3, zr
	vpst
	vaddt.i16	q3, q3, r10
	asr.w	r14, r6, #16
	vmov	q2, q4
	vdup.16	q4, r6
	vqrdmulh.s16	q7, q2, q7
	vsub.i16	q6, q1, q3
	vmul.i16	q2, q2, q4
	vdup.16	q4, r10
	vmla.i16	q2, q7, r10
	vcmp.s16	lt, q6, zr
	vpst
	vaddt.i16	q6, q6, q4
	vmov.i16	q7, #1
	vadd.i16	q1, q1, q3
	vsub.i16	q1, q1, q4
	vcmp.s16	lt, q1, zr
	vpst
	vaddt.i16	q1, q1, q4
	vmov.i16	q3, #1
	vand	q3, q1, q3
	vcmp.i16	ne, q3, zr
	vpst
	vaddt.i16	q1, q1, q4
	vmov	q3, q6
	vsub.i16	q6, q5, q0
	vdup.16	q4, r10
	vadd.i16	q5, q5, q0
	vcmp.s16	lt, q6, zr
	vpst
	vaddt.i16	q6, q6, q4
	vmov	q0, q6
	vdup.16	q6, r14
	asr.w	r14, r4, #16
	vsub.i16	q5, q5, q4
	vqrdmulh.s16	q6, q3, q6
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q4
	vand	q7, q5, q7
	vcmp.i16	ne, q7, zr
	vpst
	vaddt.i16	q5, q5, q4
	vdup.16	q4, r14
	vdup.16	q7, r4
	vqrdmulh.s16	q4, q0, q4
	vshr.u16	q1, q1, #1
	vmul.i16	q0, q0, q7
	vshr.u16	q5, q5, #1
	vmla.i16	q0, q4, r10
	vdup.16	q4, r6
	vstrh.16	q5, [r1]
	vcmp.s16	lt, q0, zr
	vpst
	vaddt.i16	q0, q0, r10
	vmul.i16	q3, q3, q4
	asr.w	r14, r4, #16
	vmla.i16	q3, q6, r10
	vdup.16	q5, r10
	vstrh.16	q0, [r12]
	vcmp.s16	lt, q3, zr
	vpst
	vaddt.i16	q3, q3, r10
	add.w	r12, r1, #32
	vldrh.u16	q4, [r12]
	add.w	r12, r1, #32
	vsub.i16	q6, q4, q1
	vadd.i16	q4, q4, q1
	vsub.i16	q4, q4, q5
	vdup.16	q7, r14
	asr.w	r14, r4, #16
	vcmp.s16	lt, q6, zr
	vpst
	vaddt.i16	q6, q6, q5
	vmov	q1, q6
	vdup.16	q6, r4
	vqrdmulh.s16	q7, q1, q7
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q5
	vmul.i16	q1, q1, q6
	vmla.i16	q1, q7, r10
	vmov.i16	q6, #1
	vand	q6, q4, q6
	vcmp.i16	ne, q6, zr
	vpst
	vaddt.i16	q4, q4, q5
	vshr.u16	q4, q4, #1
	vcmp.s16	lt, q1, zr
	vpst
	vaddt.i16	q1, q1, r10
	vstrh.16	q4, [r12]
	add.w	r12, r1, #160
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, r10
	vstrh.16	q1, [r12]
	add.w	r12, r1, #64
	vdup.16	q7, r4
	vldrh.u16	q6, [r12]
	vdup.16	q5, r10
	add.w	r12, r1, #64
	vsub.i16	q4, q6, q2
	vadd.i16	q6, q6, q2
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q5
	vmov	q2, q4
	vdup.16	q4, r14
	vsub.i16	q6, q6, q5
	vqrdmulh.s16	q4, q2, q4
	vcmp.s16	lt, q6, zr
	vpst
	vaddt.i16	q6, q6, q5
	vmov.i16	q1, #1
	vmul.i16	q2, q2, q7
	vand	q1, q6, q1
	vmla.i16	q2, q4, r10
	vcmp.i16	ne, q1, zr
	vpst
	vaddt.i16	q6, q6, q5
	asr.w	r14, r4, #16
	vshr.u16	q6, q6, #1
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, r10
	vstrh.16	q6, [r12]
	add.w	r12, r1, #192
	vdup.16	q6, r10
	vstrh.16	q2, [r12]
	vmov.i16	q2, #1
	add.w	r12, r1, #96
	vdup.16	q1, r14
	vldrh.u16	q5, [r12]
	vdup.16	q7, r4
	add.w	r12, r1, #96
	vsub.i16	q4, q5, q3
	asr.w	r14, r7, #16
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q6
	vadd.i16	q5, q5, q3
	vsub.i16	q5, q5, q6
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q6
	vmov	q3, q4
	vand	q2, q5, q2
	vqrdmulh.s16	q1, q3, q1
	vcmp.i16	ne, q2, zr
	vpst
	vaddt.i16	q5, q5, q6
	vmul.i16	q3, q3, q7
	vmla.i16	q3, q1, r10
	vshr.u16	q5, q5, #1
	vcmp.s16	lt, q3, zr
	vpst
	vaddt.i16	q3, q3, r10
	vstrh.16	q5, [r12]
	add.w	r12, r1, #224
	add.w	r1, r1, #16
	vstrh.16	q3, [r12]
	vdup.16	q6, r7
	add.w	r12, r1, #32
	vmov.i16	q2, #1
	vldrh.u16	q0, [r1]
	vdup.16	q4, r10
	vldrh.u16	q1, [r12]
	vdup.16	q3, r10
	add.w	r12, r1, #64
	vsub.i16	q5, q0, q1
	vadd.i16	q0, q0, q1
	vsub.i16	q0, q0, q4
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q4
	vmov	q1, q5
	vcmp.s16	lt, q0, zr
	vpst
	vaddt.i16	q0, q0, q4
	vdup.16	q5, r14
	vand	q2, q0, q2
	vqrdmulh.s16	q5, q1, q5
	vcmp.i16	ne, q2, zr
	vpst
	vaddt.i16	q0, q0, q4
	vmul.i16	q1, q1, q6
	asr.w	r14, r8, #16
	vmla.i16	q1, q5, r10
	vshr.u16	q0, q0, #1
	vldrh.u16	q5, [r12]
	vcmp.s16	lt, q1, zr
	vpst
	vaddt.i16	q1, q1, r10
	add.w	r12, r1, #96
	vldrh.u16	q4, [r12]
	add.w	r12, r1, #32
	vsub.i16	q6, q5, q4
	vadd.i16	q5, q5, q4
	vsub.i16	q5, q5, q3
	vdup.16	q4, r8
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q3
	vmov.i16	q2, #1
	vand	q2, q5, q2
	vcmp.i16	ne, q2, zr
	vpst
	vaddt.i16	q5, q5, q3
	vdup.16	q2, r14
	asr.w	r14, r5, #16
	vcmp.s16	lt, q6, zr
	vpst
	vaddt.i16	q6, q6, q3
	vmov	q3, q6
	vshr.u16	q5, q5, #1
	vqrdmulh.s16	q2, q3, q2
	vsub.i16	q6, q0, q5
	vadd.i16	q0, q0, q5
	vdup.16	q5, r10
	vcmp.s16	lt, q6, zr
	vpst
	vaddt.i16	q6, q6, q5
	vmul.i16	q3, q3, q4
	vmla.i16	q3, q2, r10
	vmov	q2, q6
	vdup.16	q6, r14
	asr.w	r14, r5, #16
	vsub.i16	q0, q0, q5
	vqrdmulh.s16	q6, q2, q6
	vcmp.s16	lt, q3, zr
	vpst
	vaddt.i16	q3, q3, r10
	vsub.i16	q4, q1, q3
	vadd.i16	q1, q1, q3
	vmov.i16	q3, #1
	vcmp.s16	lt, q0, zr
	vpst
	vaddt.i16	q0, q0, q5
	vand	q3, q0, q3
	vcmp.i16	ne, q3, zr
	vpst
	vaddt.i16	q0, q0, q5
	vshr.u16	q0, q0, #1
	vdup.16	q5, r5
	vstrh.16	q0, [r1]
	vdup.16	q3, r10
	vmul.i16	q2, q2, q5
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q3
	vmla.i16	q2, q6, r10
	vsub.i16	q1, q1, q3
	vcmp.s16	lt, q1, zr
	vpst
	vaddt.i16	q1, q1, q3
	vmov.i16	q6, #1
	vand	q6, q1, q6
	vcmp.i16	ne, q6, zr
	vpst
	vaddt.i16	q1, q1, q3
	vmov	q5, q4
	vdup.16	q6, r14
	asr.w	r14, r11, #16
	vdup.16	q3, r5
	vqrdmulh.s16	q6, q5, q6
	vshr.u16	q1, q1, #1
	vmul.i16	q5, q5, q3
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, r10
	vstrh.16	q1, [r12]
	vmla.i16	q5, q6, r10
	add.w	r12, r1, #64
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, r10
	vstrh.16	q2, [r12]
	add.w	r12, r1, #96
	vstrh.16	q5, [r12]
	add.w	r12, r1, #128
	vdup.16	q5, r10
	vldrh.u16	q0, [r12]
	vmov.i16	q3, #1
	add.w	r12, r1, #160
	vdup.16	q6, r11
	vldrh.u16	q2, [r12]
	vdup.16	q4, r14
	add.w	r12, r1, #192
	vsub.i16	q1, q0, q2
	asr.w	r14, r0, #16
	vcmp.s16	lt, q1, zr
	vpst
	vaddt.i16	q1, q1, q5
	vadd.i16	q0, q0, q2
	vldrh.u16	q2, [r12]
	vsub.i16	q0, q0, q5
	add.w	r12, r1, #224
	vcmp.s16	lt, q0, zr
	vpst
	vaddt.i16	q0, q0, q5
	vand	q3, q0, q3
	vcmp.i16	ne, q3, zr
	vpst
	vaddt.i16	q0, q0, q5
	vldrh.u16	q3, [r12]
	vshr.u16	q0, q0, #1
	vmov	q1, q1
	vsub.i16	q5, q2, q3
	vqrdmulh.s16	q4, q1, q4
	vadd.i16	q2, q2, q3
	vmul.i16	q1, q1, q6
	vdup.16	q6, r10
	vmla.i16	q1, q4, r10
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q6
	vsub.i16	q2, q2, q6
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, q6
	vmov.i16	q3, #1
	vand	q3, q2, q3
	vcmp.i16	ne, q3, zr
	vpst
	vaddt.i16	q2, q2, q6
	vshr.u16	q2, q2, #1
	vmov	q3, q5
	vdup.16	q5, r0
	vdup.16	q6, r14
	asr.w	r14, r6, #16
	vsub.i16	q4, q0, q2
	vqrdmulh.s16	q6, q3, q6
	vadd.i16	q0, q0, q2
	vcmp.s16	lt, q1, zr
	vpst
	vaddt.i16	q1, q1, r10
	subs	r2, #1
	bne	fndsa_mqpoly_ntt_to_int__L3x512_lanes_slothyB_kernel
	vmul.i16	q3, q3, q5
	vdup.16	q2, r10
	vmla.i16	q3, q6, r10
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q2
	vsub.i16	q0, q0, q2
	vcmp.s16	lt, q0, zr
	vpst
	vaddt.i16	q0, q0, q2
	vmov.i16	q6, #1
	vand	q6, q0, q6
	vcmp.i16	ne, q6, zr
	vpst
	vaddt.i16	q0, q0, q2
	vshr.u16	q0, q0, #1
	vmov	q2, q4
	vdup.16	q6, r6
	vdup.16	q5, r14
	vcmp.s16	lt, q3, zr
	vpst
	vaddt.i16	q3, q3, r10
	vsub.i16	q7, q1, q3
	vqrdmulh.s16	q5, q2, q5
	vmov.i16	q4, #1
	vmul.i16	q2, q2, q6
	vdup.16	q6, r10
	vcmp.s16	lt, q7, zr
	vpst
	vaddt.i16	q7, q7, q6
	asr.w	r14, r6, #16
	vadd.i16	q1, q1, q3
	vsub.i16	q1, q1, q6
	vcmp.s16	lt, q1, zr
	vpst
	vaddt.i16	q1, q1, q6
	vmla.i16	q2, q5, r10
	vldrh.u16	q5, [r1]
	vmov.i16	q3, #1
	vand	q3, q1, q3
	vcmp.i16	ne, q3, zr
	vpst
	vaddt.i16	q1, q1, q6
	vmov	q3, q7
	vsub.i16	q6, q5, q0
	vdup.16	q7, r10
	vadd.i16	q5, q5, q0
	vcmp.s16	lt, q6, zr
	vpst
	vaddt.i16	q6, q6, q7
	vmov	q0, q6
	vdup.16	q6, r14
	vsub.i16	q5, q5, q7
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q7
	add.w	r12, r1, #128
	asr.w	r14, r4, #16
	vand	q4, q5, q4
	vcmp.i16	ne, q4, zr
	vpst
	vaddt.i16	q5, q5, q7
	vdup.16	q4, r14
	vqrdmulh.s16	q6, q3, q6
	vdup.16	q7, r4
	vqrdmulh.s16	q4, q0, q4
	vshr.u16	q1, q1, #1
	vmul.i16	q0, q0, q7
	vshr.u16	q5, q5, #1
	vmla.i16	q0, q4, r10
	vdup.16	q4, r6
	vstrh.16	q5, [r1]
	vcmp.s16	lt, q0, zr
	vpst
	vaddt.i16	q0, q0, r10
	vmul.i16	q3, q3, q4
	vmla.i16	q3, q6, r10
	vdup.16	q6, r10
	vstrh.16	q0, [r12]
	vcmp.s16	lt, q3, zr
	vpst
	vaddt.i16	q3, q3, r10
	add.w	r12, r1, #32
	vldrh.u16	q4, [r12]
	vsub.i16	q5, q4, q1
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, r10
	vadd.i16	q4, q4, q1
	vsub.i16	q4, q4, q6
	asr.w	r14, r4, #16
	vdup.16	q7, r14
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q6
	vmov	q1, q5
	vdup.16	q5, r4
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q6
	vqrdmulh.s16	q7, q1, q7
	add.w	r12, r1, #32
	vmul.i16	q1, q1, q5
	vmov.i16	q5, #1
	vand	q5, q4, q5
	vmla.i16	q1, q7, r10
	vcmp.i16	ne, q5, zr
	vpst
	vaddt.i16	q4, q4, q6
	asr.w	r14, r4, #16
	vshr.u16	q4, q4, #1
	vcmp.s16	lt, q1, zr
	vpst
	vaddt.i16	q1, q1, r10
	vstrh.16	q4, [r12]
	add.w	r12, r1, #160
	vstrh.16	q1, [r12]
	add.w	r12, r1, #64
	vdup.16	q7, r4
	vldrh.u16	q6, [r12]
	vdup.16	q5, r10
	vsub.i16	q4, q6, q2
	vadd.i16	q6, q6, q2
	add.w	r12, r1, #64
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q5
	vmov	q2, q4
	vdup.16	q4, r14
	vsub.i16	q6, q6, q5
	vqrdmulh.s16	q4, q2, q4
	vcmp.s16	lt, q6, zr
	vpst
	vaddt.i16	q6, q6, q5
	vmul.i16	q2, q2, q7
	vmla.i16	q2, q4, r10
	vmov.i16	q4, #1
	vand	q4, q6, q4
	vcmp.i16	ne, q4, zr
	vpst
	vaddt.i16	q6, q6, q5
	vshr.u16	q6, q6, #1
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, r10
	vstrh.16	q6, [r12]
	add.w	r12, r1, #192
	vstrh.16	q2, [r12]
	vdup.16	q6, r10
	add.w	r12, r1, #96
	vldrh.u16	q4, [r12]
	vsub.i16	q5, q4, q3
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q6
	asr.w	r14, r4, #16
	vadd.i16	q4, q4, q3
	vsub.i16	q4, q4, q6
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q6
	vmov.i16	q7, #1
	vand	q7, q4, q7
	vcmp.i16	ne, q7, zr
	vpst
	vaddt.i16	q4, q4, q6
	add.w	r12, r1, #96
	vmov	q3, q5
	vdup.16	q6, r14
	vdup.16	q7, r4
	vqrdmulh.s16	q6, q3, q6
	vshr.u16	q4, q4, #1
	vmul.i16	q3, q3, q7
	vmla.i16	q3, q6, r10
	vcmp.s16	lt, q3, zr
	vpst
	vaddt.i16	q3, q3, r10
	vstrh.16	q4, [r12]
	add.w	r12, r1, #224
	add.w	r1, r1, #16
	vstrh.16	q3, [r12]
	add.w	r1, r1, #224
	subs	r3, #1
	bne	fndsa_mqpoly_ntt_to_int__L3x512_block

	@ p0 now points to iGM[8].  The remaining inverse m=2 and m=1 layers
	@ are handled directly by the wide GS2 pass below.
	ldr	r8, [sp, #0]
	ldr	r1, [sp, #12]
	add	sp, sp, #16
	vmov	s2, r1
	movw	r10, #Q

@ Final wide GS2 pass, reversing forward m=2 then m=1.  Its twiddles
@ are fixed iGM[2], iGM[3], then iGM[1].
fndsa_mqpoly_ntt_to_int__L512_GS2_wide:
	adr	r8, fndsa_mqpoly_ntt_to_int__igmaddr
	ldr	r8, [r8]
	MQ_LOAD_PAIR_OFF	r5, r8, 2
	MQ_LOAD_PAIR_OFF	r6, r8, 4
	MQ_LOAD_PAIR_OFF	r7, r8, 6
	movw	r2, #256
	movs	r3, #16
	vmov	r1, s2
fndsa_mqpoly_ntt_to_int__L512_GS2_wide_loop:
	@ SLOTHY B: halving pipeline a; (b;a)^(N-1); b.
	sub.w	r3, r3, #1
	vdup.16	q7, r6
	vldrh.u16	q4, [r1]
	vdup.16	q3, r7
	add.w	r4, r1, r2
	vdup.16	q5, r10
	vldrh.u16	q2, [r4]
	vmov.i16	q6, #1
	asr.w	r14, r6, #16
	vadd.i16	q1, q4, q2
	add.w	r4, r4, r2
	vsub.i16	q1, q1, q5
	vsub.i16	q2, q4, q2
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, q5
	vdup.16	q4, r14
	asr.w	r14, r7, #16
	vcmp.s16	lt, q1, zr
	vpst
	vaddt.i16	q1, q1, q5
	vqrdmulh.s16	q4, q2, q4
	vmul.i16	q2, q2, q7
	vand	q6, q1, q6
	vmla.i16	q2, q4, r10
	vmov.i16	q7, #1
	vcmp.i16	ne, q6, zr
	vpst
	vaddt.i16	q1, q1, q5
	vldrh.u16	q6, [r4]
	add.w	r4, r4, r2
	vldrh.u16	q4, [r4]
	vshr.u16	q1, q1, #1
	vadd.i16	q5, q6, q4
	vsub.i16	q4, q6, q4
	vdup.16	q6, r10
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q6
	vsub.i16	q5, q5, q6
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q6
	vand	q7, q5, q7
	vcmp.i16	ne, q7, zr
	vpst
	vaddt.i16	q5, q5, q6
	vdup.16	q6, r14
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, r10
	vqrdmulh.s16	q6, q4, q6
	vmul.i16	q4, q4, q3
	vdup.16	q7, r10
	vmla.i16	q4, q6, r10
	vshr.u16	q3, q5, #1
fndsa_mqpoly_ntt_to_int__L512_GS2_wide_loop_slothyB_kernel:
	vadd.i16	q6, q1, q3
	asr.w	r14, r5, #16
	vsub.i16	q3, q1, q3
	add.w	r4, r1, r2
	vmov.i16	q5, #1
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	vsub.i16	q6, q6, q7
	vcmp.s16	lt, q3, zr
	vpst
	vaddt.i16	q3, q3, q7
	vcmp.s16	lt, q6, zr
	vpst
	vaddt.i16	q6, q6, q7
	vand	q5, q6, q5
	vcmp.i16	ne, q5, zr
	vpst
	vaddt.i16	q6, q6, q7
	vshr.u16	q1, q6, #1
	vdup.16	q7, r14
	vstrh.16	q1, [r1]
	vdup.16	q5, r5
	vqrdmulh.s16	q6, q3, q7
	vadd.i16	q7, q2, q4
	vmul.i16	q3, q3, q5
	vdup.16	q5, r10
	vmla.i16	q3, q6, r10
	vsub.i16	q7, q7, q5
	asr.w	r14, r5, #16
	vcmp.s16	lt, q7, zr
	vpst
	vaddt.i16	q7, q7, q5
	add.w	r1, r1, #16
	vsub.i16	q4, q2, q4
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q5
	vmov.i16	q6, #1
	vand	q6, q7, q6
	vcmp.i16	ne, q6, zr
	vpst
	vaddt.i16	q7, q7, q5
	vdup.16	q6, r14
	vdup.16	q5, r5
	vqrdmulh.s16	q2, q4, q6
	vshr.u16	q7, q7, #1
	vmul.i16	q4, q4, q5
	vcmp.s16	lt, q3, zr
	vpst
	vaddt.i16	q3, q3, r10
	vmla.i16	q4, q2, r10
	vstrh.16	q7, [r4]
	add.w	r4, r4, r2
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	vstrh.16	q3, [r4]
	add.w	r4, r4, r2
	vstrh.16	q4, [r4]
	vdup.16	q7, r6
	add.w	r4, r1, r2
	vldrh.u16	q4, [r1]
	vdup.16	q3, r7
	vldrh.u16	q2, [r4]
	vdup.16	q5, r10
	vmov.i16	q6, #1
	asr.w	r14, r6, #16
	vadd.i16	q1, q4, q2
	add.w	r4, r4, r2
	vsub.i16	q1, q1, q5
	vsub.i16	q2, q4, q2
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, q5
	vdup.16	q4, r14
	asr.w	r14, r7, #16
	vcmp.s16	lt, q1, zr
	vpst
	vaddt.i16	q1, q1, q5
	vqrdmulh.s16	q4, q2, q4
	vmul.i16	q2, q2, q7
	vand	q6, q1, q6
	vmla.i16	q2, q4, r10
	vcmp.i16	ne, q6, zr
	vpst
	vaddt.i16	q1, q1, q5
	vldrh.u16	q6, [r4]
	add.w	r4, r4, r2
	vldrh.u16	q4, [r4]
	vmov.i16	q7, #1
	vadd.i16	q5, q6, q4
	vsub.i16	q4, q6, q4
	vdup.16	q6, r10
	vsub.i16	q5, q5, q6
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q6
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q6
	vand	q7, q5, q7
	vcmp.i16	ne, q7, zr
	vpst
	vaddt.i16	q5, q5, q6
	vdup.16	q7, r14
	vshr.u16	q1, q1, #1
	vqrdmulh.s16	q6, q4, q7
	vdup.16	q7, r10
	vmul.i16	q4, q4, q3
	vshr.u16	q3, q5, #1
	vmla.i16	q4, q6, r10
	vcmp.s16	lt, q2, zr
	vpst
	vaddt.i16	q2, q2, r10
	subs	r3, #1
	bne	fndsa_mqpoly_ntt_to_int__L512_GS2_wide_loop_slothyB_kernel
	vadd.i16	q5, q1, q3
	vsub.i16	q3, q1, q3
	vmov.i16	q6, #1
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	vsub.i16	q5, q5, q7
	vcmp.s16	lt, q3, zr
	vpst
	vaddt.i16	q3, q3, q7
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q7
	vand	q6, q5, q6
	asr.w	r14, r5, #16
	vcmp.i16	ne, q6, zr
	vpst
	vaddt.i16	q5, q5, q7
	add.w	r4, r1, r2
	vshr.u16	q1, q5, #1
	vdup.16	q7, r14
	vstrh.16	q1, [r1]
	vdup.16	q6, r5
	vqrdmulh.s16	q7, q3, q7
	vadd.i16	q5, q2, q4
	vmul.i16	q3, q3, q6
	vdup.16	q6, r10
	vmla.i16	q3, q7, r10
	vsub.i16	q5, q5, q6
	asr.w	r14, r5, #16
	vcmp.s16	lt, q5, zr
	vpst
	vaddt.i16	q5, q5, q6
	add.w	r1, r1, #16
	vsub.i16	q4, q2, q4
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, q6
	vmov.i16	q2, #1
	vand	q2, q5, q2
	vcmp.i16	ne, q2, zr
	vpst
	vaddt.i16	q5, q5, q6
	vdup.16	q6, r14
	vshr.u16	q2, q5, #1
	vdup.16	q7, r5
	vqrdmulh.s16	q5, q4, q6
	vcmp.s16	lt, q3, zr
	vpst
	vaddt.i16	q3, q3, r10
	vmul.i16	q4, q4, q7
	vmla.i16	q4, q5, r10
	vstrh.16	q2, [r4]
	vcmp.s16	lt, q4, zr
	vpst
	vaddt.i16	q4, q4, r10
	add.w	r4, r4, r2
	vstrh.16	q3, [r4]
	add.w	r4, r4, r2
	vstrh.16	q4, [r4]
	b	fndsa_mqpoly_ntt_to_int__Lend

fndsa_mqpoly_ntt_to_int__Lend:
	vpop	{ d8-d15 }
	pop.w	{ r0, r4, r5, r6, r7, r8, r9, r10, r11, pc }
	.align	2
fndsa_mqpoly_ntt_to_int__igmaddr:
	.word	fndsa_mq_barrett3_iGM
	.size	fndsa_mqpoly_ntt_to_int,.-fndsa_mqpoly_ntt_to_int


@ Diagnostic entry used by the stage-3 exactness harness.  q0-q3 and r0-r3
@ are caller-saved; r10 is preserved explicitly.
	.align	2
	.global	fndsa_stage3_mul_probe
	.thumb
	.thumb_func
	.type	fndsa_stage3_mul_probe, %function
fndsa_stage3_mul_probe:
	push	{ r10, lr }
	movw	r10, #Q
	vdup.16	q0, r0
	uxth	r1, r1
	orr	r1, r1, r2, lsl #16
	MQ_DUP_PAIR	q1, q3, r1
	MQ_MVE_MMUL	q0, q1, q2, q3
	vmov	r0, s0
	uxth	r0, r0
	pop	{ r10, pc }
	.size	fndsa_stage3_mul_probe,.-fndsa_stage3_mul_probe
