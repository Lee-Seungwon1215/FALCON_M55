/* Same-image whole-function/control/inner-region measurement, no optimization. */
#include <stdio.h>
#include <string.h>
#include "kgen_inner.h"
#include "bridge_profile.h"
#include <stm32n6xx.h>

#define ROUNDS 100
#define WARMUP 10
#define BATCHES 5
struct bp_stat bp_stats[BP_COUNT];
static double source[1024] __attribute__((aligned(32)));
static double data[1024] __attribute__((aligned(32)));
static double expected[1024] __attribute__((aligned(32)));
static fxr fixed[1024] __attribute__((aligned(32)));
static uint64_t state = UINT64_C(0x6a09e667f3bcc909);
static volatile uint64_t sink;

static uint32_t random32(void)
{
    state ^= state << 13; state ^= state >> 7; state ^= state << 17;
    return (uint32_t)state;
}

/* Keep every backend at a single callsite; no compiler-cloned timer paths. */
static uint32_t __attribute__((noinline, noclone))
measure(unsigned backend, unsigned inverse, unsigned logn)
{
    __DSB(); __ISB();
    uint32_t t = bp_tick();
    switch (backend) {
    case 0:
        if (inverse) vect_iFFT_fp64(logn, data);
        else vect_FFT_fp64(logn, data);
        break;
    case 1:
        if (inverse) vect_iFFT(logn, data);
        else vect_FFT(logn, data);
        break;
    case 2:
        if (inverse) bc_tw32_bridge_ifft(logn, data);
        else bc_tw32_bridge_fft(logn, data);
        break;
    case 3:
        if (inverse) bp_tw32_bridge_ifft(logn, data);
        else bp_tw32_bridge_fft(logn, data);
        break;
    default:
        if (inverse) vect_iFFT_fixed(logn, fixed);
        else vect_FFT_fixed(logn, fixed);
        break;
    }
    __DSB(); __ISB();
    return bp_tick()-t;
}

static unsigned run(unsigned logn, unsigned inverse, unsigned batch)
{
    unsigned n = 1u << logn, errors = 0;
    uint64_t total[5] = {0}, region[BP_COUNT] = {0};
    uint32_t minimum[5] = {~0u, ~0u, ~0u, ~0u, ~0u};
    uint32_t maximum[5] = {0}, calls[BP_COUNT] = {0};
    for (unsigned round = 0; round < ROUNDS+WARMUP; round ++) {
        for (unsigned i = 0; i < n; i ++) {
            int32_t v = (int32_t)(random32() % (2u*(256u+round)+1u)) - (int32_t)(256u+round);
            source[i] = (double)v;
        }
        /* Prepare a realistic inverse-domain input, outside all timers. */
        if (inverse) vect_FFT_fp64(logn, source);
        memcpy(data, source, n*sizeof *data);
        (void)measure(0, inverse, logn);
        memcpy(expected, data, n*sizeof *data);
        for (unsigned slot = 0; slot < 5; slot ++) {
            unsigned backend = (slot+round+batch)%5;
            memcpy(data, source, n*sizeof *data);
            for (unsigned i = 0; i < n; i ++) {
                fixed[i].v = (uint64_t)(int64_t)(source[i]*0x1p32);
            }
            memset(bp_stats, 0, sizeof bp_stats);
            uint32_t elapsed = measure(backend, inverse, logn);
            if (backend != 4 && memcmp(data, expected, n*sizeof *data)) errors ++;
            if (backend == 4) sink ^= fixed[round % n].v;
            else { uint64_t u; memcpy(&u, data+(round % n), sizeof u); sink ^= u; }
            if (round < WARMUP) continue;
            total[backend] += elapsed;
            if (elapsed < minimum[backend]) minimum[backend] = elapsed;
            if (elapsed > maximum[backend]) maximum[backend] = elapsed;
            if (backend == 3) {
                for (unsigned j = 0; j < BP_COUNT; j ++) {
                    region[j] += bp_stats[j].cycles;
                    calls[j] += bp_stats[j].calls;
                }
            }
        }
    }
    const char *names[] = {"public_fp64", "public_alias", "clone_control", "profile", "M55_ref_fixed"};
    const char *parts[] = {"input", "core_inclusive", "roots", "output"};
    for (unsigned i = 0; i < 5; i ++) {
        printf("BPRO_TOTAL degree=%u inverse=%u batch=%u backend=%s calls=%u cycles=%llu min=%u max=%u\n",
            n, inverse, batch, names[i], ROUNDS, (unsigned long long)total[i], minimum[i], maximum[i]);
    }
    for (unsigned i = 0; i < BP_COUNT; i ++) {
        printf("BPRO_REGION degree=%u inverse=%u batch=%u part=%s calls=%u cycles=%llu\n",
            n, inverse, batch, parts[i], calls[i], (unsigned long long)region[i]);
    }
    uint64_t outside = region[BP_INPUT]+region[BP_CORE]+region[BP_OUTPUT];
    if (outside > total[3] || region[BP_ROOTS] > region[BP_CORE]) errors ++;
    unsigned roots = (1u << (logn-3))+1u;
    if (calls[BP_ROOTS] != ROUNDS*roots) errors ++;
    for (unsigned j = 0; j < BP_COUNT; j ++) {
        if (j != BP_ROOTS && calls[j] != ROUNDS) errors ++;
    }
    printf("BPRO_CHECK degree=%u inverse=%u batch=%u cases=%u mismatches=%u\n",
        n, inverse, batch, (ROUNDS+WARMUP)*4, errors);
    return errors;
}

int mlk_test_main(int argc, char **argv)
{
    (void)argc; (void)argv;
    printf("BPRO_HW cpu=%u fpscr=%08x ccr=%08x tcm=%08x\n", (unsigned)SystemCoreClock,
        (unsigned)__get_FPSCR(), (unsigned)SCB->CCR, *(volatile unsigned *)0x56008008);
    if (SystemCoreClock != 800000000u || (SCB->CCR & 0x30000u)
        || *(volatile unsigned *)0x56008008 != 0x99u || (__get_FPSCR() & 0x1C00000u)) return 10;
    CoreDebug->DEMCR |= CoreDebug_DEMCR_TRCENA_Msk;
    DWT->CTRL |= DWT_CTRL_CYCCNTENA_Msk;
    __disable_irq();
    memset(bp_stats, 0, sizeof bp_stats);
    uint32_t t = bp_tick();
    for (unsigned i = 0; i < 10000; i ++) {
        uint32_t s = bp_tick(); bp_end(BP_INPUT, s);
    }
    printf("BPRO_EMPTY calls=10000 region_cycles=%llu loop_cycles=%u\n",
        (unsigned long long)bp_stats[BP_INPUT].cycles, bp_tick()-t);
    unsigned errors = 0;
    for (unsigned batch = 0; batch < BATCHES; batch ++) {
        for (unsigned logn = 9; logn <= 10; logn ++) {
            errors += run(logn, 0, batch);
            errors += run(logn, 1, batch);
        }
    }
    printf("BPRO_DONE batches=%u mismatches=%u sink=%016llx\n", BATCHES, errors, (unsigned long long)sink);
    __enable_irq();
    return errors != 0;
}
