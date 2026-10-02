/* Four unchanged crypto source trees; only the measurement driver is new.
 * Keygen: 64-bit Zephyr cycle counter, IRQ/SysTick ON (unbounded retries).
 * Verify: DWT, IRQ OFF, matching the previous signing timing policy.
 * Key/signature generation, correctness checks and digests are not timed
 * as verification. No changes or hooks inside crypto functions.
 */
#include "inner.h"
#include <cmsis_core.h>
#include <stm32n6xx.h>
#include <zephyr/kernel.h>
#include <stdio.h>

static uint8_t sk[FNDSA_SIGN_KEY_SIZE(10)];
static uint8_t pk[FNDSA_VRFY_KEY_SIZE(10)];
static uint8_t sig[FNDSA_SIGNATURE_SIZE(10)];
static uint8_t tmp[59 * 1024 + 31] __attribute__((aligned(32)));
static uint64_t samples[100];
static const uint8_t message[] = "FN-DSA M55 NTT before-after profiling";

static void
seed_for(uint8_t *dst, size_t len, unsigned logn, unsigned phase, unsigned index)
{
    for (size_t j = 0; j < len; j ++)
        dst[j] = (uint8_t)(0xA5u + 29u * j + 13u * phase + 7u * logn);
    for (unsigned j = 0; j < 4; j ++)
        dst[j] ^= (uint8_t)(index >> (8 * j));
}

static int
keygen_one(unsigned logn, const uint8_t seed[32])
{
    return fndsa_keygen_seeded_temp(logn, seed, 32, sk, pk, tmp,
        ((size_t)59 << logn) + 31);
}

static int
sign_one(unsigned logn, const uint8_t seed[40])
{
    size_t z = FNDSA_SIGNATURE_SIZE(logn);
    return fndsa_sign_seeded_temp(sk, FNDSA_SIGN_KEY_SIZE(logn), NULL, 0,
        FNDSA_HASH_ID_RAW, message, sizeof message - 1, seed, 40,
        sig, z, tmp, ((size_t)59 << logn) + 31) == z;
}

static int
verify_one(unsigned logn)
{
    return fndsa_verify_temp(sig, FNDSA_SIGNATURE_SIZE(logn), pk,
        FNDSA_VRFY_KEY_SIZE(logn), NULL, 0, FNDSA_HASH_ID_RAW,
        message, sizeof message - 1, tmp, ((size_t)59 << logn) + 31);
}

static int
reject_tamper(unsigned logn)
{
    sig[50] ^= 1;
    int rejected = !verify_one(logn);
    sig[50] ^= 1;
    return rejected;
}

static void
print_digest(const char *op, unsigned logn, sha3_context *hc)
{
    uint8_t digest[32];
    sha3_close(hc, digest);
    printf("KV_DIGEST op=%s degree=%u sha3=", op, 1u << logn);
    for (unsigned i = 0; i < sizeof digest; i ++)
        printf("%02x", digest[i]);
    printf("\n");
}

static void
summary(const char *op, unsigned logn, uint64_t total)
{
    for (unsigned i = 1; i < 100; i ++) {
        uint64_t x = samples[i];
        unsigned j = i;
        while (j && samples[j - 1] > x) {
            samples[j] = samples[j - 1];
            j --;
        }
        samples[j] = x;
    }
    printf("KV_SUMMARY op=%s degree=%u calls=100 total=%llu median_lo=%llu median_hi=%llu min=%llu max=%llu\n",
        op, 1u << logn, (unsigned long long)total,
        (unsigned long long)samples[49], (unsigned long long)samples[50],
        (unsigned long long)samples[0], (unsigned long long)samples[99]);
}

int
mlk_test_main(int argc, char **argv)
{
    (void)argc;
    (void)argv;
    printf("KV_HW cpu=%u fpscr=%08x ccr=%08x tcm=%08x calls=100 warmups=3 kg_irq=ON verify_irq=OFF\n",
        (unsigned)SystemCoreClock, (unsigned)__get_FPSCR(),
        (unsigned)SCB->CCR, *(volatile unsigned *)0x56008008);
    if (SystemCoreClock != 800000000u || (SCB->CCR & 0x30000u)
        || *(volatile unsigned *)0x56008008 != 0x99u
        || (__get_FPSCR() & 0x1C00000u) || __get_PRIMASK())
        return 10;
    CoreDebug->DEMCR |= CoreDebug_DEMCR_TRCENA_Msk;
    DWT->CTRL |= DWT_CTRL_CYCCNTENA_Msk;
    uint64_t c0 = k_cycle_get_64();
    uint32_t d0 = DWT->CYCCNT;
    k_busy_wait(100000);
    uint32_t delta32 = DWT->CYCCNT - d0;
    uint64_t delta64 = k_cycle_get_64() - c0;
    int64_t error = (int64_t)delta64 - delta32;
    if (delta64 < 79000000u || delta64 > 81000000u || error < -5000 || error > 5000)
        return 11;
    printf("KV_TIMER_CHECK result=PASS systick64=%llu dwt32=%u error=%lld\n",
        (unsigned long long)delta64, delta32, (long long)error);

    for (unsigned logn = 9; logn <= 10; logn ++) {
        uint8_t kg[32], sg[40];
        sha3_context hc;
        uint64_t total = 0;
        for (unsigned w = 0; w < 3; w ++) {
            seed_for(kg, sizeof kg, logn, 1, w);
            seed_for(sg, sizeof sg, logn, 2, w);
            if (!keygen_one(logn, kg) || !sign_one(logn, sg) || !verify_one(logn))
                return 1;
        }
        sha3_init(&hc, 256);
        for (unsigned i = 0; i < 100; i ++) {
            seed_for(kg, sizeof kg, logn, 1, i);
            __DSB();
            __ISB();
            uint64_t start = k_cycle_get_64();
            int ok = keygen_one(logn, kg);
            __DSB();
            __ISB();
            uint64_t elapsed = k_cycle_get_64() - start;
            if (!ok) return 2;
            samples[i] = elapsed;
            total += elapsed;
            sha3_update(&hc, sk, FNDSA_SIGN_KEY_SIZE(logn));
            sha3_update(&hc, pk, FNDSA_VRFY_KEY_SIZE(logn));
            seed_for(sg, sizeof sg, logn, 2, i);
            if (!sign_one(logn, sg) || !verify_one(logn) || !reject_tamper(logn))
                return 3;
            printf("KV_SAMPLE op=keygen degree=%u index=%u cycles=%llu\n",
                1u << logn, i, (unsigned long long)elapsed);
        }
        summary("keygen", logn, total);
        print_digest("keygen", logn, &hc);

        /* Same last-of-ten key and same signature seeds as sign_perf.c. */
        seed_for(kg, sizeof kg, logn, 1, 9);
        if (!keygen_one(logn, kg)) return 4;
        for (unsigned w = 0; w < 3; w ++) {
            seed_for(sg, sizeof sg, logn, 2, w);
            if (!sign_one(logn, sg) || !verify_one(logn)) return 5;
        }
        sha3_init(&hc, 256);
        sha3_update(&hc, pk, FNDSA_VRFY_KEY_SIZE(logn));
        total = 0;
        for (unsigned i = 0; i < 100; i ++) {
            seed_for(sg, sizeof sg, logn, 2, i);
            if (!sign_one(logn, sg)) return 6;
            sha3_update(&hc, sig, FNDSA_SIGNATURE_SIZE(logn));
            uint32_t mask = __get_PRIMASK();
            __disable_irq();
            __DSB();
            __ISB();
            uint32_t start = DWT->CYCCNT;
            int ok = verify_one(logn);
            __DSB();
            __ISB();
            uint32_t elapsed = DWT->CYCCNT - start;
            __set_PRIMASK(mask);
            if (!ok || !reject_tamper(logn)) return 7;
            samples[i] = elapsed;
            total += elapsed;
            printf("KV_SAMPLE op=verify degree=%u index=%u cycles=%u\n",
                1u << logn, i, elapsed);
        }
        summary("verify", logn, total);
        print_digest("verify", logn, &hc);
    }
    printf("KEYVERIFY_DONE keypairs=PASS verify=PASS tamper=PASS timer=PASS\n");
    return 0;
}
