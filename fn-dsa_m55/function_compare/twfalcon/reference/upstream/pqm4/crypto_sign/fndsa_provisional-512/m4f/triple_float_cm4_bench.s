@ Copyright 2025 NXP
@ SPDX-License-Identifier: MIT

.syntax	unified
.cpu	cortex-m4
.file	"triple_float.s"
.text
.extern tw_prod_fast_div_y_new

	.equ	SYSCNT_ADDR, 0xE0001004

@ =======================================================================
@ This macro defines a public function ('name') that calls another function
@ ('target') and measures its execution time. That time is returned (in
@ clock cycles). Incoming parameters (up to four registers) are passed
@ through to the target; the target's returned value is discarded.
@ =======================================================================
.macro	BENCH	name, target
	.align	2
	.global	\name
	.thumb
	.thumb_func
\name:
	push.w	{ r10, r11, lr }
	movw	r11, #(SYSCNT_ADDR & 0xFFFF)
	movt	r11, #(SYSCNT_ADDR >> 16)
	ldr.w	r10, [r11]
	bl	\target
	ldr.w	r0, [r11]
	sub.w	r0, r0, r10
	pop	{ r10, r11, pc }
	.size	\name,.-\name
.endm

BENCH	bench_none,    do_nothing
BENCH	bench_add,     fndsa_fpr_add
BENCH	bench_mul,     fndsa_fpr_mul
BENCH	bench_div,     fndsa_fpr_div
BENCH	bench_sqrt,    fndsa_fpr_sqrt

BENCH	bench_scaled,  fndsa_fpr_scaled

BENCH	bench_rint,     fpr_rint_speed
BENCH	bench_floor,    fpr_floor_speed
BENCH	bench_trunc,    fpr_trunc_speed

BENCH	bench_tw_add,     tw_sum_asm
BENCH	bench_tw_prod,     tw_prod_fast_asm
BENCH	bench_tw_div,     tw_div_fast_asm
BENCH	bench_tw_reci,    tw_reci_fast_asm
BENCH	bench_tw_sqrt,    tw_sqrt_fast_asm

BENCH	bench_tw_add_ct,     tw_sum_ct_asm
BENCH	bench_tw_add_f_ct,     tw_sum_f_ct_asm
BENCH	bench_tw_prod_ct,     tw_prod_fast_ct_asm
BENCH	bench_tw_prod_f_ct,     tw_prod_fast_f_ct_asm
BENCH	bench_tw_div_ct,     tw_div_fast_ct_asm
BENCH	bench_tw_reci_ct,    tw_reci_fast_ct_asm
BENCH	bench_tw_sqrt_ct,    tw_sqrt_fast_ct_asm

BENCH	bench_tw_fpr_of,     tw_from_int_ct_asm
BENCH	bench_tw_rint_ct,     tw_rint_fast_ct_asm
BENCH	bench_tw_floor_ct,    tw_floor_fast_asm 
BENCH	bench_tw_trunc_ct,     tw_trunc_fast_ct_asm
BENCH	bench_tw_trunc_full_ct,     tw_trunc_full_ct_asm

@ A do-nothing function, used for calibration. Its inherent cost should
@ be 2 cycles (a single 'bx lr' opcode).
	.align	2
	.thumb
	.thumb_func
	.type	do_nothing, %function
do_nothing:
	bx	lr
	.size	do_nothing,.-do_nothing

@ A special bench function for fndsa_fpr_add_sub, which uses a non-standard
@ ABI and requires the caller to save many more registers.
	.align	2
	.global	bench_add_sub
	.thumb
	.thumb_func
bench_add_sub:
	push.w	{ r4, r5, r6, r7, r8, r10, r11, lr }
	movw	r11, #(SYSCNT_ADDR & 0xFFFF)
	movt	r11, #(SYSCNT_ADDR >> 16)
	vmov	s1, r11
	ldr.w	r10, [r11]
	vmov	s0, r10
	bl	fndsa_fpr_add_sub
	vmov	r11, s1
	ldr.w	r0, [r11]
	vmov	r10, s0
	sub.w	r0, r0, r10
	pop	{ r4, r5, r6, r7, r8, r10, r11, pc }
	.size	bench_add_sub,.-bench_add_sub

@ A special bench function for tw_fpr_add_sub, which uses a non-standard
@ ABI and requires the caller to save many more registers.
	.align	2
	.global	bench_tw_add_sub_ct
	.thumb
	.thumb_func
bench_tw_add_sub_ct:
	push.w	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	vpush {d8}
	movw	r11, #(SYSCNT_ADDR & 0xFFFF)
	movt	r11, #(SYSCNT_ADDR >> 16)
	vmov s17, r11
	ldr   r10, [r11]
	vmov s16, r10
	bl	tw_add_sub_ct_asm
	vmov r11, s17
	ldr.w	r0, [r11]
	vmov r10, s16
	sub.w	r0, r0, r10
	vpop {d8}
	pop	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
	.size	bench_tw_add_sub_ct,.-bench_tw_add_sub_ct
# @ A special bench function for tw_fpr_add_sub, which uses a non-standard
# @ ABI and requires the caller to save many more registers.
# 	.align	2
# 	.global	bench_tw_add_sub_ct
# 	.thumb
# 	.thumb_func
# bench_tw_add_sub_ct:
# 	push.w	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
# 	movw	r11, #(SYSCNT_ADDR & 0xFFFF)
# 	movt	r11, #(SYSCNT_ADDR >> 16)
# 	ldr.w   r10, [r11]
# 	bl	tw_add_sub_ct_asm
# 	ldr.w	r0, [r11]
# 	sub.w	r0, r0, r10
# 	pop	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
# 	.size	bench_tw_add_sub_ct,.-bench_tw_add_sub_ct
