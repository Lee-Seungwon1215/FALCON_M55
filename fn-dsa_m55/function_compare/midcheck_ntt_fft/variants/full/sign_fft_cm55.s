/* Cortex-M55 signing FFT/iFFT. One binary64 value per D register.
 * Two radix-2 layers are fused only in storage, not in arithmetic:
 * every multiply and sum retains the original rounding boundary.
 * No VFMA, FP32, Q32 conversion, data-dependent branch, or helper call.
 * ABI r0=logn (1..10), r1=fpr array. Preserve r4-r11 and d8-d15.
 */
 .syntax unified
 .thumb
 .arch armv8.1-m.main
 .fpu fpv5-d16

 .macro FORWARD
 vldr d2,[r2]
 vldr d3,[r3]
 vldr d4,[r4]
 vldr d5,[r5]
 vmul.f64 d6,d4,d0
 vmls.f64 d6,d5,d1
 vmul.f64 d4,d4,d1
 vmla.f64 d4,d5,d0
 vadd.f64 d5,d2,d6
 vsub.f64 d2,d2,d6
 vstr d5,[r2]
 vstr d2,[r4]
 vadd.f64 d6,d3,d4
 vsub.f64 d3,d3,d4
 vstr d6,[r3]
 vstr d3,[r5]
 .endm
 .macro INVERSE
 vldr d2,[r2]
 vldr d3,[r3]
 vldr d4,[r4]
 vldr d5,[r5]
 vsub.f64 d6,d2,d4
 vsub.f64 d7,d3,d5
 vadd.f64 d2,d2,d4
 vadd.f64 d3,d3,d5
 vstr d2,[r2]
 vstr d3,[r3]
 vmul.f64 d2,d6,d0
 vmls.f64 d2,d7,d1
 vmul.f64 d6,d6,d1
 vmla.f64 d6,d7,d0
 vstr d2,[r4]
 vstr d6,[r5]
 .endm
 .macro INVERSE2_SCALED
 vldr d2,[r2]
 vldr d3,[r3]
 vldr d4,[r4]
 vldr d5,[r5]
 vldr d8,[r2,#8]
 vldr d9,[r3,#8]
 vldr d10,[r4,#8]
 vldr d11,[r5,#8]
 vsub.f64 d6,d2,d4
 vsub.f64 d12,d8,d10
 vsub.f64 d7,d3,d5
 vsub.f64 d13,d9,d11
 vadd.f64 d2,d2,d4
 vadd.f64 d8,d8,d10
 vadd.f64 d3,d3,d5
 vadd.f64 d9,d9,d11
 SCALED_STORE d2,r2,0
 SCALED_STORE d8,r2,8
 SCALED_STORE d3,r3,0
 SCALED_STORE d9,r3,8
 vmul.f64 d2,d6,d0
 vmul.f64 d8,d12,d0
 vmls.f64 d2,d7,d1
 vmls.f64 d8,d13,d1
 vmul.f64 d6,d6,d1
 vmul.f64 d12,d12,d1
 vmla.f64 d6,d7,d0
 vmla.f64 d12,d13,d0
 SCALED_STORE d2,r4,0
 SCALED_STORE d8,r4,8
 SCALED_STORE d6,r5,0
 SCALED_STORE d12,r5,8
 .endm
 .macro SCALED_STORE val,ptr,off
 vmov r0,r12,\val
 sub r9,r12,r10
 eor r12,r12,r9
 asr r12,r12,#31
 and r12,r12,r10
 add r12,r12,r9
 strd r0,r12,[\ptr,#\off]
 .endm
 .macro REG_FORWARD xr,xi,yr,yi,sr=d0,si=d1
 vmul.f64 d10,\yr,\sr
 vmls.f64 d10,\yi,\si
 vmul.f64 d11,\yr,\si
 vmla.f64 d11,\yi,\sr
 vsub.f64 \yr,\xr,d10
 vadd.f64 \xr,\xr,d10
 vsub.f64 \yi,\xi,d11
 vadd.f64 \xi,\xi,d11
 .endm
 .macro REG_INVERSE xr,xi,yr,yi,sr=d0,si=d1
 vsub.f64 d10,\xr,\yr
 vsub.f64 d11,\xi,\yi
 vadd.f64 \xr,\xr,\yr
 vadd.f64 \xi,\xi,\yi
 vmul.f64 \yr,d10,\sr
 vmls.f64 \yr,d11,\si
 vmul.f64 \yi,d10,\si
 vmla.f64 \yi,d11,\sr
 .endm

 /* Four coefficient pointers r2,r4,r5,r11. r8 is the fixed imaginary
  * offset; r3 is only an address scratch register. Three complex
  * twiddles remain in d0/d1, d12/d13, d14/d15 throughout the group. */
 .macro LOAD_STRIDED
 vldr d2,[r2]
 add r3,r2,r8
 vldr d3,[r3]
 vldr d4,[r4]
 add r3,r4,r8
 vldr d5,[r3]
 vldr d6,[r5]
 add r3,r5,r8
 vldr d7,[r3]
 vldr d8,[r11]
 add r3,r11,r8
 vldr d9,[r3]
 .endm
 .macro STORE_STRIDED scaled=0
 .if \scaled
 SCALED_STORE d2,r2,0
 add r3,r2,r8
 SCALED_STORE d3,r3,0
 SCALED_STORE d4,r4,0
 add r3,r4,r8
 SCALED_STORE d5,r3,0
 SCALED_STORE d6,r5,0
 add r3,r5,r8
 SCALED_STORE d7,r3,0
 SCALED_STORE d8,r11,0
 add r3,r11,r8
 SCALED_STORE d9,r3,0
 .else
 vstr d2,[r2]
 add r3,r2,r8
 vstr d3,[r3]
 vstr d4,[r4]
 add r3,r4,r8
 vstr d5,[r3]
 vstr d6,[r5]
 add r3,r5,r8
 vstr d7,[r3]
 vstr d8,[r11]
 add r3,r11,r8
 vstr d9,[r3]
 .endif
 .endm
 .macro ADVANCE4
 add r2,r2,#8
 add r4,r4,#8
 add r5,r5,#8
 add r11,r11,#8
 .endm
 .macro ROOTS inverse=0
 vldr d0,[r6]
 vldr d1,[r6,#8]
 vldr d12,[r0]
 vldr d13,[r0,#8]
 vldr d14,[r0,#16]
 vldr d15,[r0,#24]
 .if \inverse
 vneg.f64 d1,d1
 vneg.f64 d13,d13
 vneg.f64 d15,d15
 .endif
 add r6,r6,#16
 add r0,r0,#32
 .endm
 .macro INVERSE_LAYERS
 REG_INVERSE d2,d3,d4,d5,d12,d13
 REG_INVERSE d6,d7,d8,d9,d14,d15
 REG_INVERSE d2,d3,d6,d7
 REG_INVERSE d4,d5,d8,d9
 .endm

 .section .text.fndsa_fpoly_FFT,"ax",%progbits
 .p2align 2
 .global fndsa_fpoly_FFT
 .type fndsa_fpoly_FFT,%function
 .thumb_func
fndsa_fpoly_FFT:
 cmp r0,#1
 bls .Lfft_return
 vpush {d8-d15}
 push {r4-r11,lr}
 sub sp,sp,#12
 str r1,[sp]
 mov r8,#4
 lsl r8,r8,r0
 lsr r7,r8,#2
 sub r9,r0,#1
 mov r10,#1
.Lfft_stage:
 cmp r9,#1
 beq .Lfft_last
 ldr r6,=fndsa_sign_gm
 add r0,r6,r10,lsl #6
 add r6,r6,r10,lsl #5
 ldr r2,[sp]
 mov r1,r10
.Lfft_group:
 add r4,r2,r7
 add r5,r4,r7
 add r11,r5,r7
 ROOTS
 lsr lr,r7,#3
 dls lr,lr
.Lfft_pair_layers:
 LOAD_STRIDED
 REG_FORWARD d2,d3,d6,d7
 REG_FORWARD d4,d5,d8,d9
 REG_FORWARD d2,d3,d4,d5,d12,d13
 REG_FORWARD d6,d7,d8,d9,d14,d15
 STORE_STRIDED
 ADVANCE4
 le lr,.Lfft_pair_layers
 mov r2,r11
 subs r1,r1,#1
 bne .Lfft_group
 lsl r10,r10,#2
 lsr r7,r7,#2
 subs r9,r9,#2
 bne .Lfft_stage
 b .Lfft_done
.Lfft_last:
 ldr r6,=fndsa_sign_gm
 add r6,r6,r10,lsl #5
 ldr r2,[sp]
 add r3,r2,r8
 add r4,r2,#8
 add r5,r3,#8
 mov lr,r10
 dls lr,lr
.Lfft_last_loop:
 vldr d0,[r6]
 vldr d1,[r6,#8]
 FORWARD
 add r6,r6,#16
 add r2,r2,#16
 add r3,r3,#16
 add r4,r4,#16
 add r5,r5,#16
 le lr,.Lfft_last_loop
.Lfft_done:
 add sp,sp,#12
 pop {r4-r11,lr}
 vpop {d8-d15}
.Lfft_return:
 bx lr
 .size fndsa_fpoly_FFT,.-fndsa_fpoly_FFT
 .ltorg

 .section .text.fndsa_fpoly_iFFT,"ax",%progbits
 .p2align 2
 .global fndsa_fpoly_iFFT
 .type fndsa_fpoly_iFFT,%function
 .thumb_func
fndsa_fpoly_iFFT:
 cmp r0,#1
 bls .Lifft_return
 vpush {d8-d15}
 push {r4-r11,lr}
 sub sp,sp,#12
 str r1,[sp]
 str r0,[sp,#4]
 mov r8,#4
 lsl r8,r8,r0
 mov r7,#8
 sub r9,r0,#1
 lsr r10,r8,#5
.Lifft_stage:
 cmp r9,#1
 beq .Lifft_final
 ldr r6,=fndsa_sign_gm
 add r0,r6,r10,lsl #6
 add r6,r6,r10,lsl #5
 ldr r2,[sp]
 mov r1,r10
.Lifft_group:
 add r4,r2,r7
 add r5,r4,r7
 add r11,r5,r7
 ROOTS 1
 lsr lr,r7,#3
 cmp r9,#2
 beq .Lifft_final_pair
 dls lr,lr
.Lifft_pair_layers:
 LOAD_STRIDED
 INVERSE_LAYERS
 STORE_STRIDED
 ADVANCE4
 le lr,.Lifft_pair_layers
 mov r2,r11
 subs r1,r1,#1
 bne .Lifft_group
 lsr r10,r10,#2
 lsl r7,r7,#2
 subs r9,r9,#2
 bne .Lifft_stage
 b .Lifft_done
.Lifft_final_pair:
 ldr r10,[sp,#4]
 sub r10,r10,#1
 lsl r10,r10,#20
 dls lr,lr
.Lifft_final_pair_loop:
 LOAD_STRIDED
 INVERSE_LAYERS
 STORE_STRIDED 1
 ADVANCE4
 le lr,.Lifft_final_pair_loop
 b .Lifft_done
.Lifft_final:
 ldr r2,[sp]
 add r3,r2,r8
 add r4,r2,r7
 add r5,r3,r7
 ldr r6,=fndsa_sign_gm+32
 vldr d0,[r6]
 vldr d1,[r6,#8]
 vneg.f64 d1,d1
 cmp r7,#8
 beq .Lifft_small
 ldr r10,[sp,#4]
 sub r10,r10,#1
 lsl r10,r10,#20
 lsr lr,r7,#4
 dls lr,lr
.Lifft_final_loop:
 INVERSE2_SCALED
 add r2,r2,#16
 add r3,r3,#16
 add r4,r4,#16
 add r5,r5,#16
 le lr,.Lifft_final_loop
 b .Lifft_done
.Lifft_small:
 INVERSE
 ldr r1,[sp]
 add r1,r1,#4
 mov r4,#0x100000
 mov lr,#4
 dls lr,lr
.Lifft_small_scale:
 ldr r2,[r1]
 sub r3,r2,r4
 eor r2,r2,r3
 asr r2,r2,#31
 and r2,r2,r4
 add r3,r3,r2
 str r3,[r1],#8
 le lr,.Lifft_small_scale
.Lifft_done:
 add sp,sp,#12
 pop {r4-r11,lr}
 vpop {d8-d15}
.Lifft_return:
 bx lr
 .size fndsa_fpoly_iFFT,.-fndsa_fpoly_iFFT
 .ltorg
 .section .note.GNU-stack,"",%progbits
