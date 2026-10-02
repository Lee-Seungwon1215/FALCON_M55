/* Stage 11: unchanged on-demand roots versus preconverted roots, same image. */
#include <stdio.h>
#include <string.h>
#include "kgen_inner.h"
#include "twiddle_baseline.h"
#include "tw32_gm_ds32.h"
#include <cmsis_core.h>
#include <stm32n6xx.h>

#define ROUNDS 100
#define WARMUP 10
#define BATCHES 5
static double source[1024] __attribute__((aligned(32)));
static double data[1024] __attribute__((aligned(32)));
static double expected[1024] __attribute__((aligned(32)));
static fxr fixed[1024] __attribute__((aligned(32)));
static volatile uint64_t sink;
static uint64_t state = UINT64_C(0x6a09e667f3bcc909);
static uint32_t random32(void)
{
    state ^= state << 13; state ^= state >> 7; state ^= state << 17;
    return (uint32_t)state;
}
static uint32_t tick(void) { __DSB(); __ISB(); return DWT->CYCCNT; }

static uint32_t __attribute__((noinline, noclone))
measure(unsigned backend, unsigned inverse, unsigned logn)
{
    uint32_t t = tick();
    switch (backend) {
    case 0:
        if (inverse) old10_tw32_bridge_ifft(logn, data);
        else old10_tw32_bridge_fft(logn, data);
        break;
    case 1:
        if (inverse) vect_iFFT_fp64(logn, data);
        else vect_FFT_fp64(logn, data);
        break;
    case 2:
        if (inverse) vect_iFFT(logn, data);
        else vect_FFT(logn, data);
        break;
    default:
        if (inverse) vect_iFFT_fixed(logn, fixed);
        else vect_FFT_fixed(logn, fixed);
        break;
    }
    return tick()-t;
}
static void prepare(unsigned logn, unsigned round, unsigned inverse, unsigned fractional)
{
    unsigned n = 1u << logn;
    for (unsigned i = 0; i < n; i ++) {
        int32_t v = (int32_t)(random32() % (2u*(256u+round)+1u)) - (int32_t)(256u+round);
        source[i] = (double)v;
        if (fractional) source[i] += (double)random32()*0x1p-32;
    }
    if (inverse) old10_tw32_bridge_fft(logn, source);
}
static unsigned check_roots(void)
{
    unsigned errors = 0;
    for (unsigned i = 0; i < 1024; i ++) {
        for (unsigned part = 0; part < 2; part ++) {
            double d = (double)(int64_t)tw_gm_q32[i][part]*0x1p-32;
            float h = (float)d, lo = (float)(d-(double)h);
            tw_fpr ref = {{h, lo, (float)(d-(double)h-(double)lo)}};
            const tw_fpr *got = part ? tw_gm_ds32_im+i : tw_gm_ds32_re+i;
            for (unsigned k = 0; k < 3; k ++) {
                if (memcmp(ref.x+k, got->x+k, sizeof(float))) errors ++;
            }
        }
    }
    printf("TWROOT_CHECK roots=2048 components=6144 mismatches=%u\n", errors);
    return errors;
}
static unsigned accuracy(void)
{
    unsigned errors = 0;
    for (unsigned logn = 2; logn <= 10; logn ++) {
        unsigned n = 1u << logn, failures = 0;
        for (unsigned r = 0; r < 100; r ++) {
            for (unsigned inverse = 0; inverse < 2; inverse ++) {
                prepare(logn, r, inverse, r & 1u);
                memcpy(data, source, n*sizeof *data);
                (void)measure(0, inverse, logn);
                memcpy(expected, data, n*sizeof *data);
                for (unsigned b = 1; b <= 2; b ++) {
                    memcpy(data, source, n*sizeof *data);
                    (void)measure(b, inverse, logn);
                    failures += memcmp(expected, data, n*sizeof *data) != 0;
                }
            }
        }
        printf("TWROOT_OUTPUT logn=%u cases=400 mismatches=%u\n", logn, failures);
        errors += failures;
    }
    return errors;
}
static unsigned benchmark(unsigned logn, unsigned inverse, unsigned batch)
{
    unsigned n = 1u << logn, errors = 0;
    uint64_t sum[4] = {0};
    uint32_t minimum[4] = {~0u,~0u,~0u,~0u}, maximum[4] = {0};
    for (unsigned r = 0; r < ROUNDS+WARMUP; r ++) {
        prepare(logn, r, inverse, 0);
        memcpy(data, source, n*sizeof *data);
        (void)measure(0, inverse, logn);
        memcpy(expected, data, n*sizeof *data);
        for (unsigned slot = 0; slot < 4; slot ++) {
            unsigned b = (slot+r+batch)%4;
            memcpy(data, source, n*sizeof *data);
            for (unsigned i = 0; i < n; i ++) fixed[i].v = (uint64_t)(int64_t)(source[i]*0x1p32);
            uint32_t elapsed = measure(b, inverse, logn);
            if (b < 3) errors += memcmp(data, expected, n*sizeof *data) != 0;
            if (b == 3) sink ^= fixed[r % n].v;
            else { uint64_t u; memcpy(&u, data+(r%n), sizeof u); sink ^= u; }
            if (r < WARMUP) continue;
            sum[b] += elapsed;
            if (elapsed < minimum[b]) minimum[b] = elapsed;
            if (elapsed > maximum[b]) maximum[b] = elapsed;
        }
    }
    const char *names[] = {"stage10_ondemand", "stage11_precomputed", "stage11_alias", "M55_ref_fixed"};
    for (unsigned b = 0; b < 4; b ++) {
        printf("TWROOT_PERF degree=%u inverse=%u batch=%u backend=%s calls=%u cycles=%llu min=%u max=%u\n",
            n, inverse, batch, names[b], ROUNDS, (unsigned long long)sum[b], minimum[b], maximum[b]);
    }
    printf("TWROOT_BATCH degree=%u inverse=%u batch=%u cases=330 mismatches=%u\n", n, inverse, batch, errors);
    return errors;
}
static void timing(unsigned logn, unsigned inverse)
{
    for (unsigned cls = 0; cls < 8; cls ++) {
        unsigned n = 1u << logn;
        for (unsigned i = 0; i < n; i ++) {
            switch (cls) {
            case 0: source[i] = 0.0; break;
            case 1: source[i] = 1.0; break;
            case 2: source[i] = -1.0; break;
            case 3: source[i] = (i&1u) ? -32767.0 : 32767.0; break;
            case 4: source[i] = (i&1u) ? -0x1p-32 : 0x1p-32; break;
            case 5: source[i] = (double)(int32_t)random32()*0x1p-22; break;
            case 6: source[i] = (double)(int32_t)random32()*0x1p-32; break;
            default: source[i] = (i%31 == 0) ? 0.5 : 0.0; break;
            }
        }
        uint64_t sum = 0; uint32_t lo = ~0u, hi = 0;
        for (unsigned r = 0; r < ROUNDS+WARMUP; r ++) {
            memcpy(data, source, n*sizeof *data);
            uint32_t t = measure(1, inverse, logn);
            if (r < WARMUP) continue;
            sum += t; if (t < lo) lo = t; if (t > hi) hi = t;
        }
        printf("TWROOT_TIMING degree=%u inverse=%u class=%u calls=100 cycles=%llu min=%u max=%u\n",
            n, inverse, cls, (unsigned long long)sum, lo, hi);
    }
}
int mlk_test_main(int argc, char **argv)
{
    (void)argc; (void)argv;
    printf("TWROOT_HW cpu=%u fpscr=%08x ccr=%08x tcm=%08x\n", (unsigned)SystemCoreClock,
        (unsigned)__get_FPSCR(), (unsigned)SCB->CCR, *(volatile unsigned *)0x56008008);
    if (SystemCoreClock != 800000000u || (SCB->CCR & 0x30000u)
        || *(volatile unsigned *)0x56008008 != 0x99u || (__get_FPSCR() & 0x1C00000u)) return 10;
    CoreDebug->DEMCR |= CoreDebug_DEMCR_TRCENA_Msk;
    DWT->CTRL |= DWT_CTRL_CYCCNTENA_Msk;
    __disable_irq();
    unsigned errors = check_roots()+accuracy();
    for (unsigned batch = 0; batch < BATCHES; batch ++) {
        for (unsigned logn = 9; logn <= 10; logn ++) {
            errors += benchmark(logn, 0, batch);
            errors += benchmark(logn, 1, batch);
        }
    }
    for (unsigned logn = 9; logn <= 10; logn ++) {
        timing(logn, 0); timing(logn, 1);
    }
    printf("TWROOT_DONE batches=5 mismatches=%u sink=%016llx\n", errors, (unsigned long long)sink);
    __enable_irq();
    return errors != 0;
}
