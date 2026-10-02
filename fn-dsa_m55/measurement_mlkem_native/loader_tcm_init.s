/* Pre-load initialization only; not linked into the measured application.
 * Initialize both 256 KiB TCM banks with aligned doubleword CPU stores so
 * subsequent debugger section writes do not read uninitialized ECC granules.
 * The code runs in the upstream-reserved AXISRAM window, without a stack.
 * ECC remains enabled. No RCC/clock/cache/Flash settings are changed. */
.syntax unified
.arch armv8.1-m.main
.thumb
.section .text
.global loader_tcm_init
.type loader_tcm_init, %function
.thumb_func
loader_tcm_init:
    cpsid i
    movs r2, #0
    movs r3, #0
    ldr r0, =0x10000000
    ldr r1, =0x10040000
1:  strd r2, r3, [r0], #8
    cmp r0, r1
    blo 1b
    ldr r0, =0x30000000
    ldr r1, =0x30040000
2:  strd r2, r3, [r0], #8
    cmp r0, r1
    blo 2b
    dsb
    isb
.global loader_tcm_done
.thumb_func
loader_tcm_done:
    bkpt #0
    b loader_tcm_done

/* Optional second diagnostic: copy the unchanged load image from AXISRAM
 * with CPU doubleword stores, avoiding debugger/S-AHB writes into ITCM.
 * Inputs: r0 = source, r1 = destination, r4 = exclusive destination end. */
.global loader_tcm_copy
.thumb_func
loader_tcm_copy:
    cpsid i
3:  ldrd r2, r3, [r0], #8
    strd r2, r3, [r1], #8
    cmp r1, r4
    blo 3b
    dsb
    isb
.global loader_tcm_copy_done
.thumb_func
loader_tcm_copy_done:
    bkpt #0
    b loader_tcm_copy_done
.ltorg
