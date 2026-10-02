/* SPDX-License-Identifier: MIT
 * Handwritten M55/MVE Keccak-f[1600] x4.
 * Hybrid: low/high x4 state + ML-KEM-style fused theta/rho/pi.
 * NEON 64-bit rotates are replaced by low/high 32-bit MVE operations.
 * This is NOT VecFalcon's AArch64 2-scalar/2-NEON register schedule.
 * Four vector lanes correspond to four independent SHAKE states.
 * No data-dependent branches/addresses; 24 fixed rounds. No Slothy.
 */
.syntax unified
.thumb
.arch armv8.1-m.main
.arch_extension mve
.section .text.fndsa_keccakx4_permute, "ax", %progbits
.p2align 4
.global fndsa_keccakx4_permute
.type fndsa_keccakx4_permute, %function
.thumb_func
fndsa_keccakx4_permute:
  push {r4-r12, lr}
  vpush {d8-d15}
  mov r7, sp
  sub sp, sp, #976
  mov r6, sp
  bic r6, r6, #15
  mov sp, r6
  addw r6, sp, #800
  mov r10, r0
  addw r11, r0, #400
  mov r4, sp
  addw r5, sp, #400
  ldr r9, =.Lround_constants
  movs r8, #24
.Lround:
  vldrw.u32 q0, [r10, #0]
  vldrw.u32 q1, [r10, #80]
  veor.u32 q0, q0, q1
  vldrw.u32 q1, [r10, #160]
  veor.u32 q0, q0, q1
  vldrw.u32 q1, [r10, #240]
  veor.u32 q0, q0, q1
  vldrw.u32 q1, [r10, #320]
  veor.u32 q0, q0, q1
  vstrw.32 q0, [r6, #0]
  vldrw.u32 q0, [r10, #16]
  vldrw.u32 q1, [r10, #96]
  veor.u32 q0, q0, q1
  vldrw.u32 q1, [r10, #176]
  veor.u32 q0, q0, q1
  vldrw.u32 q1, [r10, #256]
  veor.u32 q0, q0, q1
  vldrw.u32 q1, [r10, #336]
  veor.u32 q0, q0, q1
  vstrw.32 q0, [r6, #16]
  vldrw.u32 q0, [r10, #32]
  vldrw.u32 q1, [r10, #112]
  veor.u32 q0, q0, q1
  vldrw.u32 q1, [r10, #192]
  veor.u32 q0, q0, q1
  vldrw.u32 q1, [r10, #272]
  veor.u32 q0, q0, q1
  vldrw.u32 q1, [r10, #352]
  veor.u32 q0, q0, q1
  vstrw.32 q0, [r6, #32]
  vldrw.u32 q0, [r10, #48]
  vldrw.u32 q1, [r10, #128]
  veor.u32 q0, q0, q1
  vldrw.u32 q1, [r10, #208]
  veor.u32 q0, q0, q1
  vldrw.u32 q1, [r10, #288]
  veor.u32 q0, q0, q1
  vldrw.u32 q1, [r10, #368]
  veor.u32 q0, q0, q1
  vstrw.32 q0, [r6, #48]
  vldrw.u32 q0, [r10, #64]
  vldrw.u32 q1, [r10, #144]
  veor.u32 q0, q0, q1
  vldrw.u32 q1, [r10, #224]
  veor.u32 q0, q0, q1
  vldrw.u32 q1, [r10, #304]
  veor.u32 q0, q0, q1
  vldrw.u32 q1, [r10, #384]
  veor.u32 q0, q0, q1
  vstrw.32 q0, [r6, #64]
  vldrw.u32 q0, [r11, #0]
  vldrw.u32 q1, [r11, #80]
  veor.u32 q0, q0, q1
  vldrw.u32 q1, [r11, #160]
  veor.u32 q0, q0, q1
  vldrw.u32 q1, [r11, #240]
  veor.u32 q0, q0, q1
  vldrw.u32 q1, [r11, #320]
  veor.u32 q0, q0, q1
  vstrw.32 q0, [r6, #80]
  vldrw.u32 q0, [r11, #16]
  vldrw.u32 q1, [r11, #96]
  veor.u32 q0, q0, q1
  vldrw.u32 q1, [r11, #176]
  veor.u32 q0, q0, q1
  vldrw.u32 q1, [r11, #256]
  veor.u32 q0, q0, q1
  vldrw.u32 q1, [r11, #336]
  veor.u32 q0, q0, q1
  vstrw.32 q0, [r6, #96]
  vldrw.u32 q0, [r11, #32]
  vldrw.u32 q1, [r11, #112]
  veor.u32 q0, q0, q1
  vldrw.u32 q1, [r11, #192]
  veor.u32 q0, q0, q1
  vldrw.u32 q1, [r11, #272]
  veor.u32 q0, q0, q1
  vldrw.u32 q1, [r11, #352]
  veor.u32 q0, q0, q1
  vstrw.32 q0, [r6, #112]
  vldrw.u32 q0, [r11, #48]
  vldrw.u32 q1, [r11, #128]
  veor.u32 q0, q0, q1
  vldrw.u32 q1, [r11, #208]
  veor.u32 q0, q0, q1
  vldrw.u32 q1, [r11, #288]
  veor.u32 q0, q0, q1
  vldrw.u32 q1, [r11, #368]
  veor.u32 q0, q0, q1
  vstrw.32 q0, [r6, #128]
  vldrw.u32 q0, [r11, #64]
  vldrw.u32 q1, [r11, #144]
  veor.u32 q0, q0, q1
  vldrw.u32 q1, [r11, #224]
  veor.u32 q0, q0, q1
  vldrw.u32 q1, [r11, #304]
  veor.u32 q0, q0, q1
  vldrw.u32 q1, [r11, #384]
  veor.u32 q0, q0, q1
  vstrw.32 q0, [r6, #144]
  @ Theta correction, column 0
  vldrw.u32 q0, [r6, #64]
  vldrw.u32 q1, [r6, #144]
  vldrw.u32 q2, [r6, #16]
  vldrw.u32 q3, [r6, #96]
  vshl.i32 q4, q2, #1
  vsri.32 q4, q3, #31
  vshl.i32 q5, q3, #1
  vsri.32 q5, q2, #31
  veor.u32 q6, q0, q4
  veor.u32 q7, q1, q5
  vldrw.u32 q0, [r10, #0]
  vldrw.u32 q1, [r11, #0]
  veor.u32 q0, q0, q6
  veor.u32 q1, q1, q7
  vmov q2, q0
  vmov q3, q1
  vstrw.32 q2, [r4, #0]
  vstrw.32 q3, [r5, #0]
  vldrw.u32 q0, [r10, #80]
  vldrw.u32 q1, [r11, #80]
  veor.u32 q0, q0, q6
  veor.u32 q1, q1, q7
  vshl.i32 q2, q1, #4
  vsri.32 q2, q0, #28
  vshl.i32 q3, q0, #4
  vsri.32 q3, q1, #28
  vstrw.32 q2, [r4, #256]
  vstrw.32 q3, [r5, #256]
  vldrw.u32 q0, [r10, #160]
  vldrw.u32 q1, [r11, #160]
  veor.u32 q0, q0, q6
  veor.u32 q1, q1, q7
  vshl.i32 q2, q0, #3
  vsri.32 q2, q1, #29
  vshl.i32 q3, q1, #3
  vsri.32 q3, q0, #29
  vstrw.32 q2, [r4, #112]
  vstrw.32 q3, [r5, #112]
  vldrw.u32 q0, [r10, #240]
  vldrw.u32 q1, [r11, #240]
  veor.u32 q0, q0, q6
  veor.u32 q1, q1, q7
  vshl.i32 q2, q1, #9
  vsri.32 q2, q0, #23
  vshl.i32 q3, q0, #9
  vsri.32 q3, q1, #23
  vstrw.32 q2, [r4, #368]
  vstrw.32 q3, [r5, #368]
  vldrw.u32 q0, [r10, #320]
  vldrw.u32 q1, [r11, #320]
  veor.u32 q0, q0, q6
  veor.u32 q1, q1, q7
  vshl.i32 q2, q0, #18
  vsri.32 q2, q1, #14
  vshl.i32 q3, q1, #18
  vsri.32 q3, q0, #14
  vstrw.32 q2, [r4, #224]
  vstrw.32 q3, [r5, #224]
  @ Theta correction, column 1
  vldrw.u32 q0, [r6, #0]
  vldrw.u32 q1, [r6, #80]
  vldrw.u32 q2, [r6, #32]
  vldrw.u32 q3, [r6, #112]
  vshl.i32 q4, q2, #1
  vsri.32 q4, q3, #31
  vshl.i32 q5, q3, #1
  vsri.32 q5, q2, #31
  veor.u32 q6, q0, q4
  veor.u32 q7, q1, q5
  vldrw.u32 q0, [r10, #16]
  vldrw.u32 q1, [r11, #16]
  veor.u32 q0, q0, q6
  veor.u32 q1, q1, q7
  vshl.i32 q2, q0, #1
  vsri.32 q2, q1, #31
  vshl.i32 q3, q1, #1
  vsri.32 q3, q0, #31
  vstrw.32 q2, [r4, #160]
  vstrw.32 q3, [r5, #160]
  vldrw.u32 q0, [r10, #96]
  vldrw.u32 q1, [r11, #96]
  veor.u32 q0, q0, q6
  veor.u32 q1, q1, q7
  vshl.i32 q2, q1, #12
  vsri.32 q2, q0, #20
  vshl.i32 q3, q0, #12
  vsri.32 q3, q1, #20
  vstrw.32 q2, [r4, #16]
  vstrw.32 q3, [r5, #16]
  vldrw.u32 q0, [r10, #176]
  vldrw.u32 q1, [r11, #176]
  veor.u32 q0, q0, q6
  veor.u32 q1, q1, q7
  vshl.i32 q2, q0, #10
  vsri.32 q2, q1, #22
  vshl.i32 q3, q1, #10
  vsri.32 q3, q0, #22
  vstrw.32 q2, [r4, #272]
  vstrw.32 q3, [r5, #272]
  vldrw.u32 q0, [r10, #256]
  vldrw.u32 q1, [r11, #256]
  veor.u32 q0, q0, q6
  veor.u32 q1, q1, q7
  vshl.i32 q2, q1, #13
  vsri.32 q2, q0, #19
  vshl.i32 q3, q0, #13
  vsri.32 q3, q1, #19
  vstrw.32 q2, [r4, #128]
  vstrw.32 q3, [r5, #128]
  vldrw.u32 q0, [r10, #336]
  vldrw.u32 q1, [r11, #336]
  veor.u32 q0, q0, q6
  veor.u32 q1, q1, q7
  vshl.i32 q2, q0, #2
  vsri.32 q2, q1, #30
  vshl.i32 q3, q1, #2
  vsri.32 q3, q0, #30
  vstrw.32 q2, [r4, #384]
  vstrw.32 q3, [r5, #384]
  @ Theta correction, column 2
  vldrw.u32 q0, [r6, #16]
  vldrw.u32 q1, [r6, #96]
  vldrw.u32 q2, [r6, #48]
  vldrw.u32 q3, [r6, #128]
  vshl.i32 q4, q2, #1
  vsri.32 q4, q3, #31
  vshl.i32 q5, q3, #1
  vsri.32 q5, q2, #31
  veor.u32 q6, q0, q4
  veor.u32 q7, q1, q5
  vldrw.u32 q0, [r10, #32]
  vldrw.u32 q1, [r11, #32]
  veor.u32 q0, q0, q6
  veor.u32 q1, q1, q7
  vshl.i32 q2, q1, #30
  vsri.32 q2, q0, #2
  vshl.i32 q3, q0, #30
  vsri.32 q3, q1, #2
  vstrw.32 q2, [r4, #320]
  vstrw.32 q3, [r5, #320]
  vldrw.u32 q0, [r10, #112]
  vldrw.u32 q1, [r11, #112]
  veor.u32 q0, q0, q6
  veor.u32 q1, q1, q7
  vshl.i32 q2, q0, #6
  vsri.32 q2, q1, #26
  vshl.i32 q3, q1, #6
  vsri.32 q3, q0, #26
  vstrw.32 q2, [r4, #176]
  vstrw.32 q3, [r5, #176]
  vldrw.u32 q0, [r10, #192]
  vldrw.u32 q1, [r11, #192]
  veor.u32 q0, q0, q6
  veor.u32 q1, q1, q7
  vshl.i32 q2, q1, #11
  vsri.32 q2, q0, #21
  vshl.i32 q3, q0, #11
  vsri.32 q3, q1, #21
  vstrw.32 q2, [r4, #32]
  vstrw.32 q3, [r5, #32]
  vldrw.u32 q0, [r10, #272]
  vldrw.u32 q1, [r11, #272]
  veor.u32 q0, q0, q6
  veor.u32 q1, q1, q7
  vshl.i32 q2, q0, #15
  vsri.32 q2, q1, #17
  vshl.i32 q3, q1, #15
  vsri.32 q3, q0, #17
  vstrw.32 q2, [r4, #288]
  vstrw.32 q3, [r5, #288]
  vldrw.u32 q0, [r10, #352]
  vldrw.u32 q1, [r11, #352]
  veor.u32 q0, q0, q6
  veor.u32 q1, q1, q7
  vshl.i32 q2, q1, #29
  vsri.32 q2, q0, #3
  vshl.i32 q3, q0, #29
  vsri.32 q3, q1, #3
  vstrw.32 q2, [r4, #144]
  vstrw.32 q3, [r5, #144]
  @ Theta correction, column 3
  vldrw.u32 q0, [r6, #32]
  vldrw.u32 q1, [r6, #112]
  vldrw.u32 q2, [r6, #64]
  vldrw.u32 q3, [r6, #144]
  vshl.i32 q4, q2, #1
  vsri.32 q4, q3, #31
  vshl.i32 q5, q3, #1
  vsri.32 q5, q2, #31
  veor.u32 q6, q0, q4
  veor.u32 q7, q1, q5
  vldrw.u32 q0, [r10, #48]
  vldrw.u32 q1, [r11, #48]
  veor.u32 q0, q0, q6
  veor.u32 q1, q1, q7
  vshl.i32 q2, q0, #28
  vsri.32 q2, q1, #4
  vshl.i32 q3, q1, #28
  vsri.32 q3, q0, #4
  vstrw.32 q2, [r4, #80]
  vstrw.32 q3, [r5, #80]
  vldrw.u32 q0, [r10, #128]
  vldrw.u32 q1, [r11, #128]
  veor.u32 q0, q0, q6
  veor.u32 q1, q1, q7
  vshl.i32 q2, q1, #23
  vsri.32 q2, q0, #9
  vshl.i32 q3, q0, #23
  vsri.32 q3, q1, #9
  vstrw.32 q2, [r4, #336]
  vstrw.32 q3, [r5, #336]
  vldrw.u32 q0, [r10, #208]
  vldrw.u32 q1, [r11, #208]
  veor.u32 q0, q0, q6
  veor.u32 q1, q1, q7
  vshl.i32 q2, q0, #25
  vsri.32 q2, q1, #7
  vshl.i32 q3, q1, #25
  vsri.32 q3, q0, #7
  vstrw.32 q2, [r4, #192]
  vstrw.32 q3, [r5, #192]
  vldrw.u32 q0, [r10, #288]
  vldrw.u32 q1, [r11, #288]
  veor.u32 q0, q0, q6
  veor.u32 q1, q1, q7
  vshl.i32 q2, q0, #21
  vsri.32 q2, q1, #11
  vshl.i32 q3, q1, #21
  vsri.32 q3, q0, #11
  vstrw.32 q2, [r4, #48]
  vstrw.32 q3, [r5, #48]
  vldrw.u32 q0, [r10, #368]
  vldrw.u32 q1, [r11, #368]
  veor.u32 q0, q0, q6
  veor.u32 q1, q1, q7
  vshl.i32 q2, q1, #24
  vsri.32 q2, q0, #8
  vshl.i32 q3, q0, #24
  vsri.32 q3, q1, #8
  vstrw.32 q2, [r4, #304]
  vstrw.32 q3, [r5, #304]
  @ Theta correction, column 4
  vldrw.u32 q0, [r6, #48]
  vldrw.u32 q1, [r6, #128]
  vldrw.u32 q2, [r6, #0]
  vldrw.u32 q3, [r6, #80]
  vshl.i32 q4, q2, #1
  vsri.32 q4, q3, #31
  vshl.i32 q5, q3, #1
  vsri.32 q5, q2, #31
  veor.u32 q6, q0, q4
  veor.u32 q7, q1, q5
  vldrw.u32 q0, [r10, #64]
  vldrw.u32 q1, [r11, #64]
  veor.u32 q0, q0, q6
  veor.u32 q1, q1, q7
  vshl.i32 q2, q0, #27
  vsri.32 q2, q1, #5
  vshl.i32 q3, q1, #27
  vsri.32 q3, q0, #5
  vstrw.32 q2, [r4, #240]
  vstrw.32 q3, [r5, #240]
  vldrw.u32 q0, [r10, #144]
  vldrw.u32 q1, [r11, #144]
  veor.u32 q0, q0, q6
  veor.u32 q1, q1, q7
  vshl.i32 q2, q0, #20
  vsri.32 q2, q1, #12
  vshl.i32 q3, q1, #20
  vsri.32 q3, q0, #12
  vstrw.32 q2, [r4, #96]
  vstrw.32 q3, [r5, #96]
  vldrw.u32 q0, [r10, #224]
  vldrw.u32 q1, [r11, #224]
  veor.u32 q0, q0, q6
  veor.u32 q1, q1, q7
  vshl.i32 q2, q1, #7
  vsri.32 q2, q0, #25
  vshl.i32 q3, q0, #7
  vsri.32 q3, q1, #25
  vstrw.32 q2, [r4, #352]
  vstrw.32 q3, [r5, #352]
  vldrw.u32 q0, [r10, #304]
  vldrw.u32 q1, [r11, #304]
  veor.u32 q0, q0, q6
  veor.u32 q1, q1, q7
  vshl.i32 q2, q0, #8
  vsri.32 q2, q1, #24
  vshl.i32 q3, q1, #8
  vsri.32 q3, q0, #24
  vstrw.32 q2, [r4, #208]
  vstrw.32 q3, [r5, #208]
  vldrw.u32 q0, [r10, #384]
  vldrw.u32 q1, [r11, #384]
  veor.u32 q0, q0, q6
  veor.u32 q1, q1, q7
  vshl.i32 q2, q0, #14
  vsri.32 q2, q1, #18
  vshl.i32 q3, q1, #14
  vsri.32 q3, q0, #18
  vstrw.32 q2, [r4, #64]
  vstrw.32 q3, [r5, #64]
  vldrw.u32 q0, [r4, #0]
  vldrw.u32 q1, [r4, #16]
  vldrw.u32 q2, [r4, #32]
  vldrw.u32 q3, [r4, #48]
  vldrw.u32 q4, [r4, #64]
  vbic.u32 q5, q2, q1
  veor.u32 q5, q5, q0
  vstrw.32 q5, [r10, #0]
  vbic.u32 q5, q3, q2
  veor.u32 q5, q5, q1
  vstrw.32 q5, [r10, #16]
  vbic.u32 q5, q4, q3
  veor.u32 q5, q5, q2
  vstrw.32 q5, [r10, #32]
  vbic.u32 q5, q0, q4
  veor.u32 q5, q5, q3
  vstrw.32 q5, [r10, #48]
  vbic.u32 q5, q1, q0
  veor.u32 q5, q5, q4
  vstrw.32 q5, [r10, #64]
  vldrw.u32 q0, [r4, #80]
  vldrw.u32 q1, [r4, #96]
  vldrw.u32 q2, [r4, #112]
  vldrw.u32 q3, [r4, #128]
  vldrw.u32 q4, [r4, #144]
  vbic.u32 q5, q2, q1
  veor.u32 q5, q5, q0
  vstrw.32 q5, [r10, #80]
  vbic.u32 q5, q3, q2
  veor.u32 q5, q5, q1
  vstrw.32 q5, [r10, #96]
  vbic.u32 q5, q4, q3
  veor.u32 q5, q5, q2
  vstrw.32 q5, [r10, #112]
  vbic.u32 q5, q0, q4
  veor.u32 q5, q5, q3
  vstrw.32 q5, [r10, #128]
  vbic.u32 q5, q1, q0
  veor.u32 q5, q5, q4
  vstrw.32 q5, [r10, #144]
  vldrw.u32 q0, [r4, #160]
  vldrw.u32 q1, [r4, #176]
  vldrw.u32 q2, [r4, #192]
  vldrw.u32 q3, [r4, #208]
  vldrw.u32 q4, [r4, #224]
  vbic.u32 q5, q2, q1
  veor.u32 q5, q5, q0
  vstrw.32 q5, [r10, #160]
  vbic.u32 q5, q3, q2
  veor.u32 q5, q5, q1
  vstrw.32 q5, [r10, #176]
  vbic.u32 q5, q4, q3
  veor.u32 q5, q5, q2
  vstrw.32 q5, [r10, #192]
  vbic.u32 q5, q0, q4
  veor.u32 q5, q5, q3
  vstrw.32 q5, [r10, #208]
  vbic.u32 q5, q1, q0
  veor.u32 q5, q5, q4
  vstrw.32 q5, [r10, #224]
  vldrw.u32 q0, [r4, #240]
  vldrw.u32 q1, [r4, #256]
  vldrw.u32 q2, [r4, #272]
  vldrw.u32 q3, [r4, #288]
  vldrw.u32 q4, [r4, #304]
  vbic.u32 q5, q2, q1
  veor.u32 q5, q5, q0
  vstrw.32 q5, [r10, #240]
  vbic.u32 q5, q3, q2
  veor.u32 q5, q5, q1
  vstrw.32 q5, [r10, #256]
  vbic.u32 q5, q4, q3
  veor.u32 q5, q5, q2
  vstrw.32 q5, [r10, #272]
  vbic.u32 q5, q0, q4
  veor.u32 q5, q5, q3
  vstrw.32 q5, [r10, #288]
  vbic.u32 q5, q1, q0
  veor.u32 q5, q5, q4
  vstrw.32 q5, [r10, #304]
  vldrw.u32 q0, [r4, #320]
  vldrw.u32 q1, [r4, #336]
  vldrw.u32 q2, [r4, #352]
  vldrw.u32 q3, [r4, #368]
  vldrw.u32 q4, [r4, #384]
  vbic.u32 q5, q2, q1
  veor.u32 q5, q5, q0
  vstrw.32 q5, [r10, #320]
  vbic.u32 q5, q3, q2
  veor.u32 q5, q5, q1
  vstrw.32 q5, [r10, #336]
  vbic.u32 q5, q4, q3
  veor.u32 q5, q5, q2
  vstrw.32 q5, [r10, #352]
  vbic.u32 q5, q0, q4
  veor.u32 q5, q5, q3
  vstrw.32 q5, [r10, #368]
  vbic.u32 q5, q1, q0
  veor.u32 q5, q5, q4
  vstrw.32 q5, [r10, #384]
  vldrw.u32 q0, [r5, #0]
  vldrw.u32 q1, [r5, #16]
  vldrw.u32 q2, [r5, #32]
  vldrw.u32 q3, [r5, #48]
  vldrw.u32 q4, [r5, #64]
  vbic.u32 q5, q2, q1
  veor.u32 q5, q5, q0
  vstrw.32 q5, [r11, #0]
  vbic.u32 q5, q3, q2
  veor.u32 q5, q5, q1
  vstrw.32 q5, [r11, #16]
  vbic.u32 q5, q4, q3
  veor.u32 q5, q5, q2
  vstrw.32 q5, [r11, #32]
  vbic.u32 q5, q0, q4
  veor.u32 q5, q5, q3
  vstrw.32 q5, [r11, #48]
  vbic.u32 q5, q1, q0
  veor.u32 q5, q5, q4
  vstrw.32 q5, [r11, #64]
  vldrw.u32 q0, [r5, #80]
  vldrw.u32 q1, [r5, #96]
  vldrw.u32 q2, [r5, #112]
  vldrw.u32 q3, [r5, #128]
  vldrw.u32 q4, [r5, #144]
  vbic.u32 q5, q2, q1
  veor.u32 q5, q5, q0
  vstrw.32 q5, [r11, #80]
  vbic.u32 q5, q3, q2
  veor.u32 q5, q5, q1
  vstrw.32 q5, [r11, #96]
  vbic.u32 q5, q4, q3
  veor.u32 q5, q5, q2
  vstrw.32 q5, [r11, #112]
  vbic.u32 q5, q0, q4
  veor.u32 q5, q5, q3
  vstrw.32 q5, [r11, #128]
  vbic.u32 q5, q1, q0
  veor.u32 q5, q5, q4
  vstrw.32 q5, [r11, #144]
  vldrw.u32 q0, [r5, #160]
  vldrw.u32 q1, [r5, #176]
  vldrw.u32 q2, [r5, #192]
  vldrw.u32 q3, [r5, #208]
  vldrw.u32 q4, [r5, #224]
  vbic.u32 q5, q2, q1
  veor.u32 q5, q5, q0
  vstrw.32 q5, [r11, #160]
  vbic.u32 q5, q3, q2
  veor.u32 q5, q5, q1
  vstrw.32 q5, [r11, #176]
  vbic.u32 q5, q4, q3
  veor.u32 q5, q5, q2
  vstrw.32 q5, [r11, #192]
  vbic.u32 q5, q0, q4
  veor.u32 q5, q5, q3
  vstrw.32 q5, [r11, #208]
  vbic.u32 q5, q1, q0
  veor.u32 q5, q5, q4
  vstrw.32 q5, [r11, #224]
  vldrw.u32 q0, [r5, #240]
  vldrw.u32 q1, [r5, #256]
  vldrw.u32 q2, [r5, #272]
  vldrw.u32 q3, [r5, #288]
  vldrw.u32 q4, [r5, #304]
  vbic.u32 q5, q2, q1
  veor.u32 q5, q5, q0
  vstrw.32 q5, [r11, #240]
  vbic.u32 q5, q3, q2
  veor.u32 q5, q5, q1
  vstrw.32 q5, [r11, #256]
  vbic.u32 q5, q4, q3
  veor.u32 q5, q5, q2
  vstrw.32 q5, [r11, #272]
  vbic.u32 q5, q0, q4
  veor.u32 q5, q5, q3
  vstrw.32 q5, [r11, #288]
  vbic.u32 q5, q1, q0
  veor.u32 q5, q5, q4
  vstrw.32 q5, [r11, #304]
  vldrw.u32 q0, [r5, #320]
  vldrw.u32 q1, [r5, #336]
  vldrw.u32 q2, [r5, #352]
  vldrw.u32 q3, [r5, #368]
  vldrw.u32 q4, [r5, #384]
  vbic.u32 q5, q2, q1
  veor.u32 q5, q5, q0
  vstrw.32 q5, [r11, #320]
  vbic.u32 q5, q3, q2
  veor.u32 q5, q5, q1
  vstrw.32 q5, [r11, #336]
  vbic.u32 q5, q4, q3
  veor.u32 q5, q5, q2
  vstrw.32 q5, [r11, #352]
  vbic.u32 q5, q0, q4
  veor.u32 q5, q5, q3
  vstrw.32 q5, [r11, #368]
  vbic.u32 q5, q1, q0
  veor.u32 q5, q5, q4
  vstrw.32 q5, [r11, #384]
  ldrd r0, r1, [r9], #8
  vdup.32 q2, r0
  vdup.32 q3, r1
  vldrw.u32 q0, [r10]
  vldrw.u32 q1, [r11]
  veor.u32 q0, q0, q2
  veor.u32 q1, q1, q3
  vstrw.32 q0, [r10]
  vstrw.32 q1, [r11]
  subs r8, r8, #1
  bne .Lround
  mov sp, r7
  vpop {d8-d15}
  pop {r4-r12, pc}
.size fndsa_keccakx4_permute, .-fndsa_keccakx4_permute
.ltorg
.section .rodata.keccakx4_constants, "a", %progbits
.p2align 3
.Lround_constants:
  .word 0x1, 0x0
  .word 0x8082, 0x0
  .word 0x808a, 0x80000000
  .word 0x80008000, 0x80000000
  .word 0x808b, 0x0
  .word 0x80000001, 0x0
  .word 0x80008081, 0x80000000
  .word 0x8009, 0x80000000
  .word 0x8a, 0x0
  .word 0x88, 0x0
  .word 0x80008009, 0x0
  .word 0x8000000a, 0x0
  .word 0x8000808b, 0x0
  .word 0x8b, 0x80000000
  .word 0x8089, 0x80000000
  .word 0x8003, 0x80000000
  .word 0x8002, 0x80000000
  .word 0x80, 0x80000000
  .word 0x800a, 0x0
  .word 0x8000000a, 0x80000000
  .word 0x80008081, 0x80000000
  .word 0x8080, 0x80000000
  .word 0x80000001, 0x0
  .word 0x80008008, 0x80000000
/* Four lo/high pairs become four consecutive 64-bit output chunks.
 * VST2 performs the fixed transpose. Exactly 17 SHAKE256 rate words. */
.section .text.fndsa_keccakx4_squeeze256, "ax", %progbits
.p2align 4
.global fndsa_keccakx4_squeeze256
.type fndsa_keccakx4_squeeze256, %function
.thumb_func
fndsa_keccakx4_squeeze256:
  push {r4, lr}
  addw r2, r1, #400
  movs r3, #17
  dls lr, r3
.Lsqueeze:
  vldrw.u32 q0, [r1], #16
  vldrw.u32 q1, [r2], #16
  vst20.32 {q0,q1}, [r0]
  vst21.32 {q0,q1}, [r0]
  add r0, r0, #32
  le lr, .Lsqueeze
  pop {r4, pc}
.size fndsa_keccakx4_squeeze256, .-fndsa_keccakx4_squeeze256
/* Each lane is stored to its OWN stream buffer, stride bytes apart.
 * Scatter offsets depend only on the public buffer size, not state bytes.
 * r0: lane-0 block destination, r1: packed state, r2: stream stride.
 * Exactly 136 bytes are stored for each of the four independent streams. */
.section .text.fndsa_keccakx4_squeeze_separate, "ax", %progbits
.p2align 4
.global fndsa_keccakx4_squeeze_separate
.type fndsa_keccakx4_squeeze_separate, %function
.thumb_func
fndsa_keccakx4_squeeze_separate:
  push {r4, lr}
  movs r4, #0
  vidup.u32 q2, r4, #1
  vmul.i32 q2, q2, r2
  add r4, r0, #4
  addw r2, r1, #400
  movs r3, #17
  dls lr, r3
.Lsqueeze_separate:
  vldrw.u32 q0, [r1], #16
  vldrw.u32 q1, [r2], #16
  vstrw.32 q0, [r0, q2]
  vstrw.32 q1, [r4, q2]
  add r0, r0, #8
  add r4, r4, #8
  le lr, .Lsqueeze_separate
  pop {r4, pc}
.size fndsa_keccakx4_squeeze_separate, .-fndsa_keccakx4_squeeze_separate
.section .note.GNU-stack, "", %progbits
