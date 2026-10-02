/* M55 binary64 split/merge. Unchanged fpr bit layout and operation
 * rounding. No helper calls, fused FMA, or secret-dependent addresses.
 * Split: single position + exact exponent halving. Merge: pairs for n>=128.
 * Dedicated n=2 and n=4 paths avoid general-loop setup costs.
 * Public logn=1..10; input/output arrays follow sign_inner.h contracts. */
 .syntax unified
 .thumb
 .arch armv8.1-m.main
 .fpu fpv5-d16
 .text
/* Exact original fpr_half exponent rule, including both signed zeros. */
 .macro HALF_STORE val,ptr
 vmov r0,r12,\val
 sub r4,r12,#0x100000
 eor r12,r12,r4
 asr r12,r12,#31
 and r12,r12,#0x100000
 add r12,r12,r4
 strd r0,r12,[\ptr],#8
 .endm

 .p2align 2
 .global fndsa_fpoly_split_fft
 .type fndsa_fpoly_split_fft,%function
 .thumb_func
fndsa_fpoly_split_fft:
 cmp r0,#1
 beq .Lsplit_one
 cmp r0,#2
 beq .Lsplit_two
 push {r4-r10,lr}
 mov r4,#4
 lsl r4,r4,r0
 lsr r5,r4,#1
 add r6,r3,r4
 add r7,r1,r5
 add r8,r2,r5
 movw r9,#:lower16:fndsa_sign_gm
 movt r9,#:upper16:fndsa_sign_gm
 add r9,r9,r4,lsl #1
 lsr r10,r5,#3
 dls lr,r10
 .p2align 2
.Lsplit_loop:
 vldmia r3!,{d0-d1}
 vldmia r6!,{d2-d3}
 vadd.f64 d4,d0,d1
 vadd.f64 d5,d2,d3
 vsub.f64 d0,d0,d1
 vsub.f64 d1,d2,d3
 HALF_STORE d4,r1
 HALF_STORE d5,r7
 vldmia r9!,{d2-d3}
 vneg.f64 d3,d3
 vmul.f64 d6,d0,d2
 vmul.f64 d4,d0,d3
 vmls.f64 d6,d1,d3
 vmla.f64 d4,d1,d2
 HALF_STORE d6,r2
 HALF_STORE d4,r8
 le lr,.Lsplit_loop
 pop {r4-r10,pc}
.Lsplit_one:
 vldr d0,[r3]
 vldr d1,[r3,#8]
 vstr d0,[r1]
 vstr d1,[r2]
 bx lr
.Lsplit_two:
 push {r4,lr}
 vldmia r3!,{d0-d1}
 vldmia r3,{d2-d3}
 vadd.f64 d4,d0,d1
 vadd.f64 d5,d2,d3
 vsub.f64 d0,d0,d1
 vsub.f64 d1,d2,d3
 movw r12,#:lower16:fndsa_sign_gm
 movt r12,#:upper16:fndsa_sign_gm
 vldr d2,[r12,#32]
 vldr d3,[r12,#40]
 vneg.f64 d3,d3
 HALF_STORE d4,r1
 HALF_STORE d5,r1
 vmul.f64 d6,d0,d2
 vmul.f64 d4,d0,d3
 vmls.f64 d6,d1,d3
 vmla.f64 d4,d1,d2
 HALF_STORE d6,r2
 HALF_STORE d4,r2
 pop {r4,pc}
 .size fndsa_fpoly_split_fft,.-fndsa_fpoly_split_fft

 .p2align 2
 .global fndsa_fpoly_merge_fft
 .type fndsa_fpoly_merge_fft,%function
 .thumb_func
fndsa_fpoly_merge_fft:
 cmp r0,#1
 beq .Lmerge_one
 cmp r0,#2
 beq .Lmerge_two
 push {r4-r10,lr}
 mov r4,#4
 lsl r4,r4,r0
 lsr r5,r4,#1
 add r6,r1,r4
 add r7,r2,r5
 add r8,r3,r5
 movw r9,#:lower16:fndsa_sign_gm
 movt r9,#:upper16:fndsa_sign_gm
 add r9,r9,r4,lsl #1
 lsr r10,r5,#3
 cmp r10,#32
 blo .Lmerge_scalar
 vpush {d8-d15}
 lsr r10,r10,#1
 dls lr,r10
 .p2align 2
.Lmerge_pair:
 vldmia r2!,{d0-d1}
 vldmia r7!,{d2-d3}
 vldmia r3!,{d4-d5}
 vldmia r8!,{d6-d7}
 vldmia r9!,{d8-d11}
 vmul.f64 d12,d4,d8
 vmul.f64 d13,d4,d9
 vmul.f64 d14,d5,d10
 vmul.f64 d15,d5,d11
 vmls.f64 d12,d6,d9
 vmla.f64 d13,d6,d8
 vmls.f64 d14,d7,d11
 vmla.f64 d15,d7,d10
 vadd.f64 d4,d0,d12
 vsub.f64 d0,d0,d12
 vadd.f64 d5,d1,d14
 vsub.f64 d1,d1,d14
 vadd.f64 d6,d2,d13
 vsub.f64 d2,d2,d13
 vadd.f64 d7,d3,d15
 vsub.f64 d3,d3,d15
 vstr d4,[r1]
 vstr d0,[r1,#8]
 vstr d5,[r1,#16]
 vstr d1,[r1,#24]
 vstr d6,[r6]
 vstr d2,[r6,#8]
 vstr d7,[r6,#16]
 vstr d3,[r6,#24]
 add r1,r1,#32
 add r6,r6,#32
 le lr,.Lmerge_pair
 vpop {d8-d15}
 pop {r4-r10,pc}
.Lmerge_scalar:
 dls lr,r10
 .p2align 2
.Lmerge_loop:
 vldmia r2!,{d0}
 vldmia r7!,{d1}
 vldmia r3!,{d2}
 vldmia r8!,{d3}
 vldmia r9!,{d4-d5}
 vmul.f64 d6,d2,d4
 vmul.f64 d7,d2,d5
 vmls.f64 d6,d3,d5
 vmla.f64 d7,d3,d4
 vadd.f64 d3,d0,d6
 vsub.f64 d0,d0,d6
 vadd.f64 d4,d1,d7
 vsub.f64 d1,d1,d7
 vstr d3,[r1]
 vstr d0,[r1,#8]
 vstr d4,[r6]
 vstr d1,[r6,#8]
 add r1,r1,#16
 add r6,r6,#16
 le lr,.Lmerge_loop
 pop {r4-r10,pc}
.Lmerge_one:
 vldr d0,[r2]
 vldr d1,[r3]
 vstr d0,[r1]
 vstr d1,[r1,#8]
 bx lr
.Lmerge_two:
 vldmia r2,{d0-d1}
 vldmia r3,{d2-d3}
 movw r12,#:lower16:fndsa_sign_gm
 movt r12,#:upper16:fndsa_sign_gm
 vldr d4,[r12,#32]
 vldr d5,[r12,#40]
 vmul.f64 d6,d2,d4
 vmul.f64 d7,d2,d5
 vmls.f64 d6,d3,d5
 vmla.f64 d7,d3,d4
 vadd.f64 d3,d0,d6
 vsub.f64 d0,d0,d6
 vadd.f64 d4,d1,d7
 vsub.f64 d1,d1,d7
 vstr d3,[r1]
 vstr d0,[r1,#8]
 vstr d4,[r1,#16]
 vstr d1,[r1,#24]
 bx lr
 .size fndsa_fpoly_merge_fft,.-fndsa_fpoly_merge_fft
 .section .note.GNU-stack,"",%progbits
