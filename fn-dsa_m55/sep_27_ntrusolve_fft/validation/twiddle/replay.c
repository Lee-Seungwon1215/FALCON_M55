#include "kgen_inner.h"
#include <stdio.h>
#include <string.h>
#include <zephyr/kernel.h>
#include <cmsis_core.h>
typedef void (*fft_fn)(unsigned, fxr *);
_Alignas(32) static fxr saved_input[512], saved_output[512];
static unsigned calls[11][2], failures;
static uint32_t dm[11][2][3], dx[11][2][3];
static uint64_t total[11][2][3];
static uint32_t ticks(void) { __DSB(); __ISB(); return DWT->CYCCNT; }
static __attribute__((noipa)) uint32_t timed(fft_fn fn, unsigned logn, fxr *f)
{
    uint32_t t = ticks(); fn(logn, f); return ticks() - t;
}
void trial_replay(unsigned logn, fxr *f, unsigned inverse)
{
    fft_fn current = inverse ? vect_iFFT_ntru : vect_FFT_ntru;
    if (logn < 7 || logn > 9 || calls[logn][inverse] >= 16) {
        current(logn, f); return;
    }
    CoreDebug->DEMCR |= CoreDebug_DEMCR_TRCENA_Msk; DWT->CTRL |= DWT_CTRL_CYCCNTENA_Msk;
    unsigned index = calls[logn][inverse]++;
    size_t bytes = (size_t)8 << logn;
    memcpy(saved_input, f, bytes);
    uint32_t before_fpscr = __get_FPSCR(), before_control = __get_CONTROL(), before_sp;
    __asm__ volatile("mov %0, sp" : "=r"(before_sp));
    unsigned irq = irq_lock();
    uint32_t t[3];
    t[0] = timed(current, logn, f);
    memcpy(saved_output, f, bytes);
    memcpy(f, saved_input, bytes);
    t[1] = timed(current, logn, f);
    failures += memcmp(f, saved_output, bytes) != 0;
    memcpy(f, saved_input, bytes);
    t[2] = timed(inverse ? vect_iFFT_fixed : vect_FFT_fixed, logn, f);
    failures += memcmp(f, saved_output, bytes) != 0;
    irq_unlock(irq);
    // Leave the original-bit-equivalent output in the actual caller's array.
    for (unsigned v = 0; v < 3; v++) {
        if (!index || t[v] < dm[logn][inverse][v]) dm[logn][inverse][v] = t[v];
        if (t[v] > dx[logn][inverse][v]) dx[logn][inverse][v] = t[v];
        total[logn][inverse][v] += t[v];
    }
    if (!index) printf("REPLAY_FIRST logn=%u inverse=%u data=%08x sp=%08x fpscr=%08x control=%08x first=%u repeat=%u original=%u\n",
        logn, inverse, (unsigned)(uintptr_t)f, before_sp, before_fpscr, before_control,
        t[0], t[1], t[2]);
}
int trial_replay_report(void)
{
    unsigned count = 0;
    for (unsigned l = 7; l <= 9; l++) for (unsigned inv = 0; inv < 2; inv++) {
        count += calls[l][inv];
        for (unsigned v = 0; v < 3; v++)
            printf("REPLAY logn=%u inverse=%u variant=%u calls=%u min=%u max=%u total=%llu\n",
                l, inv, v, calls[l][inv], dm[l][inv][v], dx[l][inv][v],
                (unsigned long long)total[l][inv][v]);
    }
    printf("REPLAY_DONE calls=%u failures=%u\n", count, failures);
    return failures != 0 || count != 96;
}
