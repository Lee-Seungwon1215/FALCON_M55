@ Test-only adapters appended after the complete, unmodified sha3_cm4.s.
@ Separate section: original .text must remain byte-for-byte identical.
@ Helpers have private register ABI. Every adapter restores the C ABI.
.section .text.keccak_bench,"ax",%progbits
.thumb

.macro HELPER_BENCH name, target, group=0
.balign 32
.global \name
.type \name,%function
.thumb_func
\name:
    push.w {r4-r11,lr}
    sub sp,sp,#20
    str r0,[sp,#0]
    mov r9,r1
    movw r7,#0xff00
    movt r7,#0x00ff
    uadd8 r7,r7,r7             @ APSR.GE = 0110
    mov r12,r0
    ldm r12,{r0-r7,r10,r11}
    movw r12,#0x1004
    movt r12,#0xe000           @ DWT_CYCCNT, helpers preserve r12
    dsb
    isb
    ldr r8,[r12]
    str r8,[sp,#8]
1:
.ifnc \target,none
    bl \target
.if \group
    bl \target
    bl \target
    bl \target
.ifc \target,bit_split_5
    bl bit_split_1
.else
    bl bit_merge_1
.endif
.endif
.endif
    subs r9,r9,#1
    bne 1b
    ldr r8,[r12]
    ldr r9,[sp,#8]
    sub r8,r8,r9
    str r8,[sp,#12]
    ldr r12,[sp,#0]
    stm r12,{r0-r7,r10,r11}
    ldr r0,[sp,#12]
    add sp,sp,#20
    pop.w {r4-r11,pc}
.size \name,.-\name
.endm

HELPER_BENCH bench_split1,bit_split_1
HELPER_BENCH bench_split2,bit_split_2
HELPER_BENCH bench_split3,bit_split_3
HELPER_BENCH bench_split4,bit_split_4
HELPER_BENCH bench_split5,bit_split_5
HELPER_BENCH bench_merge1,bit_merge_1
HELPER_BENCH bench_merge2,bit_merge_2
HELPER_BENCH bench_merge3,bit_merge_3
HELPER_BENCH bench_merge4,bit_merge_4
HELPER_BENCH bench_merge5,bit_merge_5
HELPER_BENCH bench_split_group,bit_split_5,1
HELPER_BENCH bench_merge_group,bit_merge_5,1
HELPER_BENCH bench_helper_empty,none

.macro PROCESS_BENCH name, do_call
.balign 32
.global \name
.type \name,%function
.thumb_func
\name:
    push {r4-r8,lr}
    mov r4,r0
    mov r5,r1
    movw r6,#0x1004
    movt r6,#0xe000
    dsb
    isb
    ldr r7,[r6]
1:
    mov r0,r4
    movs r1,#17                @ SHAKE256 rate, in 64-bit words
.if \do_call
    bl fndsa_sha3_process_block
.endif
    subs r5,r5,#1
    bne 1b
    ldr r0,[r6]
    subs r0,r0,r7
    pop {r4-r8,pc}
.size \name,.-\name
.endm
PROCESS_BENCH bench_process,1
PROCESS_BENCH bench_process_empty,0
