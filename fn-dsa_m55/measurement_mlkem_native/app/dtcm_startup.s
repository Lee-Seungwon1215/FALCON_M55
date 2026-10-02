/* Local adaptation of the pinned upstream DTCM ECC scrub hook.
 * GDB has already loaded constants and initialized data into DTCM.
 * Preserve that prefix; initialize BSS/noinit/stacks and remaining capacity
 * with aligned STRD before Zephyr uses an early stack. No ECC settings change.
 */
.syntax unified
.thumb
.section .text.__wrap_soc_early_reset_hook,"ax",%progbits
.global __wrap_soc_early_reset_hook
.type __wrap_soc_early_reset_hook,%function
.thumb_func
__wrap_soc_early_reset_hook:
    movs r2, #0
    movs r3, #0
    ldr r0, =__fndsa_dtcm_loaded_end
    ldr r1, =0x30040000
1:
    strd r2, r3, [r0], #8
    cmp r0, r1
    blo 1b
    dsb
    isb
    bx lr
.size __wrap_soc_early_reset_hook, .-__wrap_soc_early_reset_hook
.ltorg
.section .note.GNU-stack,"",%progbits
