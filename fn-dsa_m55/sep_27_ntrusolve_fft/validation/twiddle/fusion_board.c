#include "kgen_inner.h"
#include <stdio.h>
#include <string.h>
#include <zephyr/kernel.h>
#include <cmsis_core.h>
#include "table.h"
extern void trial_fused_butterfly(fxr *const *, unsigned, const fxc *, unsigned);
extern void trial_fused_fft(unsigned, fxr *, unsigned);
extern void trial_fused_ifft(unsigned, fxr *, unsigned);
_Alignas(32) static fxr input[1032], actual[1032], expected[1032];
static uint64_t state = UINT64_C(0x5345503237465553);
static volatile uint64_t sink;
static uint64_t next_word(void) { state ^= state << 13; state ^= state >> 7; state ^= state << 17; return state; }
static const uint64_t edges[] = {0, 1, UINT64_MAX, UINT64_C(0x8000000000000000),
    UINT64_C(0x7fffffffffffffff), UINT64_C(0x100000000), UINT64_C(0xffffffff),
    UINT64_C(0x7fffffff), UINT64_C(0x80000000), UINT64_C(0x5555555555555555),
    UINT64_C(0xaaaaaaaaaaaaaaaa), UINT64_C(0xffffffff00000000)};
static void fill(unsigned n, unsigned off, unsigned cls)
{
    for (unsigned i = 0; i < 1032; i++) input[i].v = UINT64_C(0xa55a771122334455);
    for (unsigned i = 0; i < n; i++) {
        if (cls == 0) input[off+i].v = 0;
        else if (cls == 1) input[off+i].v = UINT64_MAX;
        else if (cls == 2) input[off+i].v = (uint64_t)(int64_t)(int32_t)next_word();
        else if (cls < 15) input[off+i].v = edges[(cls + i) % 12];
        else input[off+i].v = next_word();
    }
}
static int butterfly_check(unsigned n, unsigned off, unsigned inverse, fxc s)
{
    memcpy(actual, input, sizeof input); memcpy(expected, input, sizeof input);
    fxr *p[] = {actual+off, actual+off+n, actual+off+2*n, actual+off+3*n};
    for (unsigned j = 0; j < n; j++) {
        fxc x = {input[off+j], input[off+n+j]}, y = {input[off+2*n+j], input[off+3*n+j]};
        fxc a, b;
        if (inverse) { a = fxc_half(fxc_add(x, y)); b = fxc_mul(s, fxc_half(fxc_sub(x, y))); }
        else { y = fxc_mul(s, y); a = fxc_add(x, y); b = fxc_sub(x, y); }
        expected[off+j] = a.re; expected[off+n+j] = a.im;
        expected[off+2*n+j] = b.re; expected[off+3*n+j] = b.im;
    }
    trial_fused_butterfly(p, n, &s, inverse);
    return memcmp(actual, expected, sizeof actual) == 0;
}
static uint32_t ticks(void) { __DSB(); __ISB(); return DWT->CYCCNT; }
static __attribute__((noipa)) uint32_t measure(unsigned variant, unsigned inverse,
    unsigned logn, unsigned off, unsigned cutoff)
{
    memcpy(actual, input, sizeof input);
    unsigned irq = irq_lock(); uint32_t t = ticks();
    if (variant == 0) {
        if (inverse) vect_iFFT_fixed(logn, actual+off); else vect_FFT_fixed(logn, actual+off);
    } else if (variant == 1) {
        if (inverse) vect_iFFT_ntru(logn, actual+off); else vect_FFT_ntru(logn, actual+off);
    } else {
        if (inverse) trial_fused_ifft(logn, actual+off, cutoff); else trial_fused_fft(logn, actual+off, cutoff);
    }
    t = ticks() - t; irq_unlock(irq); sink ^= actual[off].v; return t;
}
int mlk_test_main(int argc, char **argv)
{
    (void)argc; (void)argv; CoreDebug->DEMCR |= CoreDebug_DEMCR_TRCENA_Msk;
    DWT->CTRL |= DWT_CTRL_CYCCNTENA_Msk;
    unsigned butterfly_cases = 0, fft_cases = 0;
    for (unsigned lm = 1; lm < 10; lm++) {
        unsigned m = 1u << lm;
        for (unsigned j = m; j < m + m/2; j++) for (unsigned inv = 0; inv < 2; inv++)
          for (unsigned cls = 0; cls < 16; cls++) {
            fxc s = {{original_twiddles[j][0]}, {original_twiddles[j][1]}};
            if (inv) s.im = fxr_neg(s.im);
            unsigned off = cls & 3; fill(16, off, cls);
            if (!butterfly_check(4, off, inv, s)) {
                printf("FUSION_FAIL butterfly root=%u inverse=%u class=%u\n", j, inv, cls); return 1;
            }
            butterfly_cases++;
        }
    }
    for (unsigned lg = 2; lg <= 8; lg++) for (unsigned inv = 0; inv < 2; inv++)
      for (unsigned cls = 0; cls < 16; cls++) {
        unsigned n = 1u << lg, off = cls & 3, j = 256 + 7 * cls;
        fxc s = {{original_twiddles[j][0]}, {original_twiddles[j][1]}};
        if (inv) s.im = fxr_neg(s.im);
        fill(4*n, off, cls);
        if (!butterfly_check(n, off, inv, s)) {
            printf("FUSION_FAIL span n=%u inverse=%u class=%u\n", n, inv, cls); return 2;
        }
        butterfly_cases++;
    }
    for (unsigned l = 1; l <= 10; l++) for (unsigned inv = 0; inv < 2; inv++)
      for (unsigned cutoff = 4; cutoff <= 16; cutoff *= 2) {
        uint32_t mn[3] = {UINT32_MAX,UINT32_MAX,UINT32_MAX}, mx[3] = {0,0,0};
        state = UINT64_C(0x5345503237465553) ^ ((uint64_t)l << 8) ^ inv;
        for (unsigned cls = 0; cls < 64; cls++) {
            unsigned off = (cls >> 4) & 3; fill(1u << l, off, cls);
            memcpy(expected, input, sizeof input);
            if (inv) vect_iFFT_fixed(l, expected+off); else vect_FFT_fixed(l, expected+off);
            for (unsigned v = 0; v < 3; v++) for (unsigned trial = 0; trial < (cls < 16 ? 20 : 1); trial++) {
                uint32_t t = measure(v, inv, l, off, cutoff);
                if (memcmp(actual, expected, sizeof actual)) {
                    printf("FUSION_FAIL fft logn=%u inverse=%u cutoff=%u class=%u variant=%u\n", l, inv, cutoff, cls, v); return 3;
                }
                if (cls < 16) { if (t < mn[v]) mn[v] = t; if (t > mx[v]) mx[v] = t; }
            }
            fft_cases++;
        }
        printf("FUSION logn=%u inverse=%u cutoff=%u fixed_min=%u fixed_max=%u incumbent_min=%u incumbent_max=%u fused_min=%u fused_max=%u\n",
            l, inv, cutoff, mn[0], mx[0], mn[1], mx[1], mn[2], mx[2]);
    }
    printf("FUSION_DONE butterflies=%u transforms=%u failures=0\n", butterfly_cases, fft_cases); return 0;
}
