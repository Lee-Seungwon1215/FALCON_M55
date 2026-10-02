/* Same production FFTs, with explicit timer/IRQ/data/stack context sweeps.
 * Diagnostic only: no replacement implementation and no secret dispatch. */
#include "kgen_inner.h"
#include <stdio.h>
#include <string.h>
#include <zephyr/kernel.h>
#include <cmsis_core.h>
typedef void (*fft_fn)(unsigned, fxr *);
extern void trial_stack_call(unsigned, fxr *, fft_fn, unsigned);
volatile uint32_t trial_entry_sp;
_Alignas(32) static fxr input[1032], expected[1032], arena[9224];
static uint64_t state;
static volatile uint64_t sink;
static uint64_t next_word(void) { state ^= state << 13; state ^= state >> 7; state ^= state << 17; return state; }
static const uint64_t edges[] = {0, 1, UINT64_MAX, UINT64_C(0x8000000000000000),
    UINT64_C(0x7fffffffffffffff), UINT64_C(0x100000000), UINT64_C(0xffffffff),
    UINT64_C(0x7fffffff), UINT64_C(0x80000000), UINT64_C(0x5555555555555555),
    UINT64_C(0xaaaaaaaaaaaaaaaa), UINT64_C(0xffffffff00000000)};
static uint32_t ticks(void) { __DSB(); __ISB(); return DWT->CYCCNT; }
struct times { uint32_t dwt; uint64_t clock; };
static __attribute__((noipa)) struct times measure(fft_fn fn, unsigned logn,
    fxr *block, unsigned pad, unsigned masked)
{
    memcpy(block, input, sizeof input);
    unsigned irq = 0; if (masked) irq = irq_lock();
    __DSB(); __ISB(); uint64_t k0 = k_cycle_get_64(); uint32_t d0 = ticks();
    trial_stack_call(logn, block + 4, fn, pad);
    uint32_t d1 = ticks(); __DSB(); __ISB(); uint64_t k1 = k_cycle_get_64();
    if (masked) irq_unlock(irq);
    sink ^= block[4].v; return (struct times){d1 - d0, k1 - k0};
}
int mlk_test_main(int argc, char **argv)
{
    (void)argc; (void)argv; CoreDebug->DEMCR |= CoreDebug_DEMCR_TRCENA_Msk;
    DWT->CTRL |= DWT_CTRL_CYCCNTENA_Msk;
    const unsigned pads[] = {0, 4096, 16384}; unsigned cases = 0;
    printf("CONTEXT_HW control=%08x ccr=%08x fpccr=%08x fpscr=%08x\n",
        __get_CONTROL(), SCB->CCR, FPU->FPCCR, __get_FPSCR());
    for (unsigned logn = 7; logn <= 10; logn++) for (unsigned inverse = 0; inverse < 2; inverse++)
      for (unsigned region = 0; region < 3; region++) for (unsigned p = 0; p < 3; p++)
       for (unsigned masked = 0; masked < 2; masked++) {
        fxr *block = arena + 4096 * region;
        fft_fn old = inverse ? vect_iFFT_fixed : vect_FFT_fixed;
        fft_fn current = inverse ? vect_iFFT_ntru : vect_FFT_ntru;
        uint32_t dm[2] = {UINT32_MAX, UINT32_MAX}, dx[2] = {0, 0};
        uint64_t km[2] = {UINT64_MAX, UINT64_MAX}, kx[2] = {0, 0};
        state = UINT64_C(0x5345503237435458) ^ ((uint64_t)logn << 8) ^ inverse;
        for (unsigned cls = 0; cls < 8; cls++) {
            for (unsigned i = 0; i < 1032; i++) input[i].v = UINT64_C(0xa55a771122334455);
            for (unsigned i = 0; i < (1u << logn); i++)
                input[4 + i].v = cls < 6 ? edges[(cls + i) % 12] : next_word();
            memcpy(expected, input, sizeof input); old(logn, expected + 4);
            for (unsigned repeat = 0; repeat < 10; repeat++) for (unsigned v = 0; v < 2; v++) {
                struct times t = measure(v ? current : old, logn, block, pads[p], masked);
                if (t.dwt < dm[v]) dm[v] = t.dwt; if (t.dwt > dx[v]) dx[v] = t.dwt;
                if (t.clock < km[v]) km[v] = t.clock; if (t.clock > kx[v]) kx[v] = t.clock;
                if (memcmp(block, expected, sizeof input)) {
                    printf("CONTEXT_FAIL logn=%u inverse=%u region=%u pad=%u masked=%u class=%u variant=%u\n",
                        logn, inverse, region, pads[p], masked, cls, v); return 1;
                }
            }
            cases++;
        }
        printf("CONTEXT logn=%u inverse=%u region=%u pad=%u masked=%u data=%08x sp=%08x old_dwt=%u old_dwt_max=%u new_dwt=%u new_dwt_max=%u old_clock=%llu new_clock=%llu old_clock_max=%llu new_clock_max=%llu\n",
            logn, inverse, region, pads[p], masked, (unsigned)(uintptr_t)(block + 4), trial_entry_sp,
            dm[0], dx[0], dm[1], dx[1], (unsigned long long)km[0], (unsigned long long)km[1],
            (unsigned long long)kx[0], (unsigned long long)kx[1]);
    }
    printf("CONTEXT_DONE cases=%u failures=0\n", cases); return 0;
}
