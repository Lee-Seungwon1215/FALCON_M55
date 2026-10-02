#include "benchmark.h"
#include "inner.h"
#include <stddef.h>
#include <string.h>
#ifdef BENCH_HOST
#include <stdio.h>
#include <stdlib.h>
#elif defined(BENCH_M4)
#include "stm32l4xx.h"
#else
#include "stm32n6xx.h"
#endif

#ifdef BENCH_HOST
volatile struct bench_results bench_results;
#else
volatile struct bench_results bench_results
    __attribute__((section(".bench_results"), aligned(32)));
#endif
static uint8_t sk[FNDSA_SIGN_KEY_SIZE(10)] __attribute__((aligned(32)));
static uint8_t pk[FNDSA_VRFY_KEY_SIZE(10)] __attribute__((aligned(32)));
static uint8_t sig[FNDSA_SIGNATURE_SIZE(10)] __attribute__((aligned(32)));
static uint8_t tmp[59 * 1024 + 31] __attribute__((aligned(32)));
static inline uint32_t ticks(void)
{
#ifdef BENCH_HOST
    return 0;
#else
    __asm__ volatile ("" ::: "memory");
    return DWT->CYCCNT;
#endif
}
static inline void publish(void)
{
#ifndef BENCH_HOST
    __DMB();
#endif
}
static inline uint32_t microticks(void)
{
#ifdef BENCH_HOST
    return 0;
#else
    return TIM2->CNT;
#endif
}
void benchmark_timer_start(uint32_t kernel_hz)
{
#ifndef BENCH_HOST
    if (kernel_hz != 24000000u) benchmark_fail(0x90);
    TIM2->CR1 = 0; TIM2->DIER = 0; TIM2->PSC = 23;
    TIM2->ARR = 0xFFFFFFFFu; TIM2->EGR = TIM_EGR_UG;
    TIM2->SR = 0; TIM2->CNT = 0; TIM2->CR1 = TIM_CR1_CEN;
    bench_results.timer_kernel_hz = kernel_hz;
    bench_results.timer_psc = TIM2->PSC; bench_results.timer_cr1 = TIM2->CR1;
    bench_results.timer_arr = TIM2->ARR; bench_results.timer_dier = TIM2->DIER;
#else
    (void)kernel_hz;
#endif
}
/* TIM2 counts at 1 MHz without interrupts. Its wider time span determines
 * the number of DWT wraps while DWT retains exact cycle resolution.
 * TIM2 is read outside the DWT interval; the resulting small boundary
 * discrepancy must remain below 4096 cycles for every measured API. */
static uint64_t elapsed_cycles(uint32_t start, uint32_t us_start, uint32_t *us)
{
    uint32_t low = ticks() - start;
    *us = microticks() - us_start;
    uint64_t approximate = (uint64_t)*us * 24;
    uint64_t wraps = (approximate + ((uint64_t)1 << 31) - low) >> 32;
    uint64_t cycles = (wraps << 32) | low;
    uint64_t error = cycles > approximate ? cycles - approximate : approximate - cycles;
    if (error > 4096) benchmark_fail(0x91);
    if (error > bench_results.max_timer_error_cycles)
        bench_results.max_timer_error_cycles = (uint32_t)error;
    return cycles;
}
/* Exactly the same public seeds as the previously recorded measurements. */
static void seed_for(uint8_t *dst, size_t len, unsigned logn, unsigned phase, unsigned index)
{
    for (size_t j = 0; j < len; j++)
        dst[j] = (uint8_t)(0xA5u + 29u * j + 13u * phase + 7u * logn);
    for (unsigned j = 0; j < 4; j++) dst[j] ^= (uint8_t)(index >> (8 * j));
}
static uint32_t fingerprint(uint32_t h, const uint8_t *data, size_t len)
{
    for (size_t j = 0; j < len; j++) h = (h ^ data[j]) * 16777619u;
    return h;
}
void benchmark_fail(uint32_t error)
{
    bench_results.error = error;
    publish();
    bench_results.state = BENCH_FAILED;
#ifdef BENCH_HOST
    fprintf(stderr, "benchmark failure: %u\n", error);
    exit(1);
#else
    platform_finish();
#endif
}
static uint32_t one_iteration(unsigned logn, unsigned index, int measured,
    uint32_t h, shake_context *audit)
{
    unsigned d = logn - 9;
    uint8_t key_seed[32], sign_seed[40];
    seed_for(key_seed, sizeof key_seed, logn, measured ? 1 : 0, index);
    seed_for(sign_seed, sizeof sign_seed, logn, measured ? 2 : 0, index);
    size_t sklen = FNDSA_SIGN_KEY_SIZE(logn), pklen = FNDSA_VRFY_KEY_SIZE(logn);
    size_t siglen = FNDSA_SIGNATURE_SIZE(logn), tmplen = ((size_t)59 << logn) + 31;
    uint32_t start, us_start, us;
    uint64_t elapsed;
    bench_results.degree = 1u << logn;
    bench_results.iteration = index;
    bench_results.operation = 0;
    us_start = microticks(); start = ticks();
    int ok = fndsa_keygen_seeded_temp(logn, key_seed, sizeof key_seed, sk, pk, tmp, tmplen);
    elapsed = elapsed_cycles(start, us_start, &us);
    if (!ok) benchmark_fail(0x10u + logn);
    if (measured) {
        bench_results.cycles[d][0][index] = elapsed;
        bench_results.microseconds[d][0][index] = us;
        publish(); bench_results.counts[d][0] = index + 1;
    }
    h = fingerprint(h, sk, sklen); h = fingerprint(h, pk, pklen);
    shake_inject(audit, sk, sklen); shake_inject(audit, pk, pklen);
    bench_results.operation = 1;
    us_start = microticks(); start = ticks();
    size_t written = fndsa_sign_seeded_temp(sk, sklen, NULL, 0,
        FNDSA_HASH_ID_RAW, "blah", 4, sign_seed, sizeof sign_seed, sig, siglen, tmp, tmplen);
    elapsed = elapsed_cycles(start, us_start, &us);
    if (written != siglen) benchmark_fail(0x20u + logn);
    if (measured) {
        bench_results.cycles[d][1][index] = elapsed;
        bench_results.microseconds[d][1][index] = us;
        publish(); bench_results.counts[d][1] = index + 1;
    }
    h = fingerprint(h, sig, siglen); shake_inject(audit, sig, siglen);
    bench_results.operation = 2;
    us_start = microticks(); start = ticks();
    ok = fndsa_verify_temp(sig, siglen, pk, pklen, NULL, 0,
        FNDSA_HASH_ID_RAW, "blah", 4, tmp, tmplen);
    elapsed = elapsed_cycles(start, us_start, &us);
    if (!ok) benchmark_fail(0x30u + logn);
    if (measured) {
        bench_results.cycles[d][2][index] = elapsed;
        bench_results.microseconds[d][2][index] = us;
        publish(); bench_results.counts[d][2] = index + 1;
    } else {
        sig[50] ^= 1;
        if (fndsa_verify_temp(sig, siglen, pk, pklen, NULL, 0,
            FNDSA_HASH_ID_RAW, "blah", 4, tmp, tmplen)) benchmark_fail(0x40u + logn);
        sig[50] ^= 1;
    }
    return h;
}
static void finish_digest(shake_context *sc, volatile uint32_t *out)
{
    uint32_t value[8];
    shake_flip(sc); shake_extract(sc, value, sizeof value);
    for (unsigned i = 0; i < 8; i++) out[i] = value[i];
}
int main(void)
{
#ifndef BENCH_HOST
    platform_memory_init();
#endif
    memset((void *)&bench_results, 0, sizeof bench_results);
    bench_results.magic = BENCH_MAGIC;
    bench_results.version = 2;
    bench_results.runs = BENCH_RUNS;
    bench_results.assembly = FNDSA_ASM_CORTEXM4;
#ifdef FNDSA_ASM_CORTEXM55
    bench_results.m55_compat = FNDSA_ASM_CORTEXM55;
#endif
    bench_results.gcc_version = __GNUC__ * 10000 + __GNUC_MINOR__ * 100 + __GNUC_PATCHLEVEL__;
#ifdef __ARM_FEATURE_MVE
    bench_results.mve_compiled = __ARM_FEATURE_MVE;
#endif
#ifndef BENCH_HOST
    platform_init();
#endif
    for (unsigned logn = 9; logn <= 10; logn++) {
        shake_context audit; shake_init(&audit, 256);
        bench_results.warmup_fingerprint[logn - 9] = one_iteration(logn, 0, 0, 2166136261u, &audit);
        finish_digest(&audit, bench_results.warmup_digest[logn - 9]);
    }
    publish(); bench_results.state = BENCH_READY;
#ifndef BENCH_HOST
    while (bench_results.command != BENCH_GO) { __NOP(); }
#endif
    bench_results.state = BENCH_RUNNING;
    for (unsigned logn = 9; logn <= 10; logn++) {
        uint32_t h = 2166136261u;
        shake_context audit; shake_init(&audit, 256);
        for (unsigned j = 0; j < BENCH_RUNS; j++) {
            h = one_iteration(logn, j, 1, h, &audit);
            bench_results.fingerprint[logn - 9] = h;
        }
        finish_digest(&audit, bench_results.output_digest[logn - 9]);
    }
    publish(); bench_results.state = BENCH_DONE;
#ifdef BENCH_HOST
    printf("{\"warmup_fingerprint\":[%u,%u],\"fingerprint\":[%u,%u],",
        bench_results.warmup_fingerprint[0], bench_results.warmup_fingerprint[1],
        bench_results.fingerprint[0], bench_results.fingerprint[1]);
    for (unsigned warm = 0; warm < 2; warm++) {
        printf("\"%s\":[", warm ? "warmup_digest" : "output_digest");
        for (unsigned d = 0; d < 2; d++) {
            printf("%s[", d ? "," : "");
            for (unsigned i = 0; i < 8; i++) printf("%s%u", i ? "," : "",
                warm ? bench_results.warmup_digest[d][i] : bench_results.output_digest[d][i]);
            printf("]");
        }
        printf("]%s", warm ? "}\n" : ",");
    }
#else
    platform_finish();
#endif
    return 0;
}
