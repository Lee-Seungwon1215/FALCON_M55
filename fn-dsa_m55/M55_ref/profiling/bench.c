#include "fndsa.h"
#include "profile.h"
#include <stddef.h>
#include <stdint.h>
#include <string.h>
#ifndef FNDSA_PROFILE_CORTEX_M
#include <stdio.h>
#else
void platform_init(void);
void platform_finish(void);
#endif

#ifndef KEYGEN_RUNS
#define KEYGEN_RUNS 10
#endif
#ifndef SIGN_RUNS
#define SIGN_RUNS 100
#endif
#ifndef VERIFY_RUNS
#define VERIFY_RUNS 100
#endif
#define LOGN 9

volatile uint32_t fndsa_bench_state, fndsa_bench_error;
volatile uint32_t fndsa_bench_core_clock_hz, fndsa_bench_cpuid;
volatile uint32_t fndsa_bench_device_id, fndsa_bench_cache_control;
volatile uint32_t fndsa_bench_progress[3], fndsa_bench_fingerprint;
static uint8_t sk[FNDSA_SIGN_KEY_SIZE(LOGN)];
static uint8_t pk[FNDSA_VRFY_KEY_SIZE(LOGN)];
static uint8_t signature[FNDSA_SIGNATURE_SIZE(LOGN)];
static uint8_t workspace[59 * (1 << LOGN) + 31] __attribute__((aligned(32)));
static const uint8_t message[] = "FN-DSA-512 M4/M55 reference profiling";

static void seed_for(uint8_t *seed, size_t len, unsigned phase, unsigned index)
{
    /* Fixed public benchmark seeds, NEVER production randomness. */
    for (size_t i = 0; i < len; i++)
        seed[i] = (uint8_t)(0xA5u + 29u * i + 13u * phase);
    for (unsigned i = 0; i < 4; i++) seed[i] ^= (uint8_t)(index >> (8 * i));
}
static void fingerprint(const uint8_t *data, size_t len)
{
    uint32_t h = fndsa_bench_fingerprint;
    for (size_t i = 0; i < len; i++) h = (h ^ data[i]) * 16777619u;
    fndsa_bench_fingerprint = h;
}
static int keygen(const uint8_t *seed)
{
    return fndsa_keygen_seeded_temp(LOGN, seed, 32, sk, pk,
        workspace, sizeof workspace);
}
static int sign_message(const uint8_t *seed)
{
    return fndsa_sign_seeded_temp(sk, sizeof sk, NULL, 0,
        FNDSA_HASH_ID_RAW, message, sizeof message - 1, seed, 40,
        signature, sizeof signature, workspace, sizeof workspace) == sizeof signature;
}
static int verify_message(void)
{
    return fndsa_verify_temp(signature, sizeof signature, pk, sizeof pk,
        NULL, 0, FNDSA_HASH_ID_RAW, message, sizeof message - 1,
        workspace, sizeof workspace);
}
__attribute__((noinline)) void fndsa_bench_done(void)
{
#ifdef FNDSA_PROFILE_CORTEX_M
    platform_finish();
#endif
}
static int finish(unsigned error)
{
    fndsa_bench_error = error;
    fndsa_bench_state = error ? 0xBAD00000u | error : 0x600D0000u;
    profile_report();
#ifndef FNDSA_PROFILE_CORTEX_M
    printf("RESULT,state=%08x,error=%u,profile_error=%u,fingerprint=%08x\n",
        (unsigned)fndsa_bench_state, error, (unsigned)fndsa_profile_error,
        (unsigned)fndsa_bench_fingerprint);
#endif
    fndsa_bench_done();
    return error != 0;
}
int main(void)
{
#ifdef FNDSA_PROFILE_CORTEX_M
    platform_init();
#endif
    uint8_t seed[40];
    fndsa_bench_fingerprint = 2166136261u;
    fndsa_bench_state = 0x10000001;
    profile_clock_init();
    seed_for(seed, sizeof seed, 0, 0);
    if (!keygen(seed)) return finish(1);
    if (!sign_message(seed)) return finish(2);
    if (!verify_message()) return finish(3);
    signature[50] ^= 1;
    if (verify_message()) return finish(4);
    signature[50] ^= 1;
    profile_reset();
    profile_clock_init();
    fndsa_bench_state = 0x10000002;
#ifdef FNDSA_PROFILE_CORTEX_M
    __asm__ volatile ("cpsid i" ::: "memory");
#endif
    for (unsigned i = 0; i < KEYGEN_RUNS; i++) {
        seed_for(seed, sizeof seed, 1, i);
        profile_begin(OP_KEYGEN);
        int ok = keygen(seed);
        profile_end();
        if (!ok) return finish(5);
        fingerprint(sk, sizeof sk);
        fingerprint(pk, sizeof pk);
        fndsa_bench_progress[0] = i + 1;
    }
    for (unsigned i = 0; i < SIGN_RUNS; i++) {
        seed_for(seed, sizeof seed, 2, i);
        profile_begin(OP_SIGN);
        int ok = sign_message(seed);
        profile_end();
        if (!ok) return finish(6);
        if (!verify_message()) return finish(7); /* Outside timed interval. */
        fingerprint(signature, sizeof signature);
        fndsa_bench_progress[1] = i + 1;
    }
    for (unsigned i = 0; i < VERIFY_RUNS; i++) {
        profile_begin(OP_VERIFY);
        int ok = verify_message();
        profile_end();
        if (!ok) return finish(8);
        fndsa_bench_progress[2] = i + 1;
    }
    return finish(fndsa_profile_error ? 9 : 0);
}
