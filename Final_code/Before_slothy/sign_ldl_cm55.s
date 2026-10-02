/* M55 native binary64 LDL. Public logn=1..10.
 * Four separately rounded products, then sum and subtract; no fused FMA.
 * r0=logn, r1=g00, r2=g01, r3=g11. No helper calls or secret branches. */
 .syntax unified
 .thumb
 .arch armv8.1-m.main
 .fpu fpv5-d16
 .text
 .p2align 2
 .global fndsa_fpoly_LDL_fft
 .type fndsa_fpoly_LDL_fft,%function
 .thumb_func
fndsa_fpoly_LDL_fft:
 push {r4,lr}
 sub r0,r0,#1
 mov r4,#1
 lsl r4,r4,r0
 add r12,r2,r4,lsl #3
 vmov.f64 d7,#1.0
 dls lr,r4
.Lloop:
 vldmia r1!,{d0}
 vdiv.f64 d0,d7,d0
 vldr d1,[r2]
 vldr d2,[r12]
 vmul.f64 d4,d1,d0
 vmul.f64 d5,d2,d0
 vmul.f64 d1,d4,d1
 vmla.f64 d1,d5,d2
 vldr d3,[r3]
 vneg.f64 d5,d5
 vsub.f64 d3,d3,d1
 vstmia r2!,{d4}
 vstmia r12!,{d5}
 vstmia r3!,{d3}
 le lr,.Lloop
 pop {r4,pc}
 .size fndsa_fpoly_LDL_fft,.-fndsa_fpoly_LDL_fft
 .section .note.GNU-stack,"",%progbits
