	.syntax unified
	.thumb
	.section .text.trial_stack_call,"ax",%progbits
	.balign 4
	.global trial_stack_call
	.type trial_stack_call,%function
	.thumb_func
/* Test-only public stack padding. r0=logn,r1=array,r2=kernel,r3=padding.
 * Test cases use 0/8/16/24 or 0/4096/16384; all fit the reserved 64-KiB stack.
 * Every called kernel receives an ABI-valid 8-byte-aligned stack. */
trial_stack_call:
	push {r4,lr}
	mov r4, r3
	sub sp, sp, r4
	ldr r12, =trial_entry_sp
	mov lr, sp
	str lr, [r12]
	blx r2
	add sp, sp, r4
	pop {r4,pc}
	.size trial_stack_call, .-trial_stack_call
