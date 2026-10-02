#include "benchmark.h"
#include "fndsa.h"
#include <stddef.h>
#include <string.h>
#include "stm32n6xx.h"

volatile struct bench_results bench_results
    __attribute__((section(".bench_results"), aligned(32)));
static uint8_t sk[FNDSA_SIGN_KEY_SIZE(10)];
static uint8_t pk[FNDSA_VRFY_KEY_SIZE(10)];
static uint8_t sig[FNDSA_SIGNATURE_SIZE(10)];
static uint8_t tmp[59 * 1024 + 31] __attribute__((aligned(32)));

static inline uint32_t ticks(void)
{
    __asm__ volatile ("" ::: "memory");
    return DWT->CYCCNT;
}
static inline void publish(void) { __DMB(); }

/* Identical public benchmark seeds to the M4 measurement. */
static void seed_for(uint8_t *dst, size_t len, unsigned logn,
    unsigned phase, unsigned index)
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
    platform_finish();
}
static uint32_t one_iteration(unsigned logn, unsigned index,
    int measured, uint32_t h)
{
    unsigned d = logn - 9;
    uint8_t key_seed[32], sign_seed[40];
    seed_for(key_seed, sizeof key_seed, logn, measured ? 1 : 0, index);
    seed_for(sign_seed, sizeof sign_seed, logn, measured ? 2 : 0, index);
    size_t sklen = FNDSA_SIGN_KEY_SIZE(logn), pklen = FNDSA_VRFY_KEY_SIZE(logn);
    size_t siglen = FNDSA_SIGNATURE_SIZE(logn), tmplen = ((size_t)59 << logn) + 31;
    uint32_t start, elapsed;
    bench_results.degree = 1u << logn;
    bench_results.iteration = index;
    bench_results.operation = 0;
    start = ticks();
    int ok = fndsa_keygen_seeded_temp(logn, key_seed, sizeof key_seed, sk, pk, tmp, tmplen);
    elapsed = ticks() - start;
    if (!ok) benchmark_fail(0x10u + logn);
    if (measured) {
        bench_results.cycles[d][0][index] = elapsed;
        publish();
        bench_results.counts[d][0] = index + 1;
    }
    h = fingerprint(h, sk, sklen);
    h = fingerprint(h, pk, pklen);
    bench_results.operation = 1;
    start = ticks();
    size_t written = fndsa_sign_seeded_temp(sk, sklen, NULL, 0,
        FNDSA_HASH_ID_RAW, "blah", 4, sign_seed, sizeof sign_seed,
        sig, siglen, tmp, tmplen);
    elapsed = ticks() - start;
    if (written != siglen) benchmark_fail(0x20u + logn);
    if (measured) {
        bench_results.cycles[d][1][index] = elapsed;
        publish();
        bench_results.counts[d][1] = index + 1;
    }
    h = fingerprint(h, sig, siglen);
    bench_results.operation = 2;
    start = ticks();
    ok = fndsa_verify_temp(sig, siglen, pk, pklen, NULL, 0,
        FNDSA_HASH_ID_RAW, "blah", 4, tmp, tmplen);
    elapsed = ticks() - start;
    if (!ok) benchmark_fail(0x30u + logn);
    if (measured) {
        bench_results.cycles[d][2][index] = elapsed;
        publish();
        bench_results.counts[d][2] = index + 1;
    } else {
        sig[50] ^= 1;
        if (fndsa_verify_temp(sig, siglen, pk, pklen, NULL, 0,
            FNDSA_HASH_ID_RAW, "blah", 4, tmp, tmplen)) benchmark_fail(0x40u + logn);
        sig[50] ^= 1;
    }
    return h;
}
int main(void)
{
    platform_memory_init();
    memset((void *)&bench_results, 0, sizeof bench_results);
    bench_results.magic = BENCH_MAGIC;
    bench_results.version = 1;
    bench_results.runs = BENCH_RUNS;
    bench_results.assembly = FNDSA_ASM_CORTEXM4;
    bench_results.m55_compat = FNDSA_ASM_CORTEXM55;
    bench_results.gcc_version = __GNUC__ * 10000 + __GNUC_MINOR__ * 100 + __GNUC_PATCHLEVEL__;
#ifdef __ARM_FEATURE_MVE
    bench_results.mve_compiled = __ARM_FEATURE_MVE;
#endif
    platform_init();
    for (unsigned logn = 9; logn <= 10; logn++)
        bench_results.warmup_fingerprint[logn - 9] = one_iteration(logn, 0, 0, 2166136261u);
    publish();
    bench_results.state = BENCH_READY;
    while (bench_results.command != BENCH_GO) { __NOP(); }
    bench_results.state = BENCH_RUNNING;
    for (unsigned logn = 9; logn <= 10; logn++) {
        uint32_t h = 2166136261u;
        for (unsigned j = 0; j < BENCH_RUNS; j++) {
            h = one_iteration(logn, j, 1, h);
            bench_results.fingerprint[logn - 9] = h;
        }
    }
    publish();
    bench_results.state = BENCH_DONE;
    platform_finish();
    return 0;
}
