/* Measurement support only. No cryptographic substitutions. All intervals
 * are disjoint, limited to intermediate approximate-k calculation. */
#include "approx_profile.h"
#include <stdio.h>
#include <string.h>
static uint64_t cycles[AP_COUNT][11];
static uint32_t calls[AP_COUNT][11];
static const char *names[AP_COUNT] = {
    "input_f", "FFT_f", "inverse", "input_F", "FFT_F",
    "pointwise", "iFFT", "round", "guard"
};
void ap_end(unsigned op, unsigned logn, uint32_t start)
{
    __DSB(); __ISB();
    uint32_t elapsed = DWT->CYCCNT - start;
    cycles[op][logn] += elapsed;
    calls[op][logn] ++;
}
void ap_reset(void)
{
    memset(cycles, 0, sizeof cycles);
    memset(calls, 0, sizeof calls);
}
void ap_calibrate(void)
{
    ap_reset();
    for (unsigned i = 0; i < 1000; i ++) {
        uint32_t t = ap_start();
        ap_end(AP_INPUT_F, 1, t);
    }
    printf("APRO_EMPTY calls=%u cycles=%llu\n", calls[AP_INPUT_F][1],
        (unsigned long long)cycles[AP_INPUT_F][1]);
    ap_reset();
}
void ap_report(unsigned key_logn)
{
    for (unsigned op = 0; op < AP_COUNT; op ++) {
        for (unsigned l = 1; l < key_logn; l ++) {
            printf("APRO degree=%u logn=%u op=%s calls=%u cycles=%llu\n",
                1u << key_logn, l, names[op], calls[op][l],
                (unsigned long long)cycles[op][l]);
        }
    }
}
