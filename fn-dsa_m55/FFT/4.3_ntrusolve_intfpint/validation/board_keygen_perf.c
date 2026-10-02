/* Full public keygen on the same 100 upstream KAT seeds for both trees.
 * Includes every rejection/retry, public-key derivation and key encoding.
 * Seed formatting, KAT/NTRU validation and output hashing are NOT timed.
 */
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include "inner.h"
#include "kgen_inner.h"
#include "upstream_kat.h"
#include <zephyr/kernel.h>
#include <cmsis_core.h>
#include <stm32n6xx.h>

static uint8_t sk[FNDSA_SIGN_KEY_SIZE(10)], pk[FNDSA_VRFY_KEY_SIZE(10)];
static uint8_t tmp[22*1024+31] __attribute__((aligned(32)));
static int8_t polys[4*1024];
static uint16_t mh[1024], mt[1024];
static uint64_t samples[100];
static unsigned keygen_ok;

static uint64_t __attribute__((noinline, noclone))
measure(unsigned logn, const void *seed, size_t seed_len)
{
    __DSB(); __ISB();
    uint64_t start = k_cycle_get_64();
    unsigned ok = fndsa_keygen_seeded_temp(logn, seed, seed_len,
        sk, pk, tmp, ((size_t)22 << logn)+31);
    __DSB(); __ISB();
    uint64_t elapsed = k_cycle_get_64()-start;
    keygen_ok = ok;
    return elapsed;
}

static void sort(uint64_t *a, unsigned n)
{
    for (unsigned i = 1; i < n; i ++) {
        uint64_t v = a[i]; unsigned j = i;
        while (j > 0 && a[j-1] > v) { a[j] = a[j-1]; j --; }
        a[j] = v;
    }
}

int mlk_test_main(int argc, char **argv)
{
    (void)argc; (void)argv;
    selftest_sha256();
    printf("KEYGEN_HW cpu=%u cycle_hz=%u fpscr=%08x ccr=%08x tcm=%08x irq_mask=%u calls=100 warmups=3\n",
        (unsigned)SystemCoreClock, (unsigned)CONFIG_SYS_CLOCK_HW_CYCLES_PER_SEC,
        (unsigned)__get_FPSCR(), (unsigned)SCB->CCR,
        *(volatile unsigned *)0x56008008, (unsigned)__get_PRIMASK());
    if (SystemCoreClock != 800000000u || CONFIG_SYS_CLOCK_HW_CYCLES_PER_SEC != 800000000
        || (SCB->CCR&0x30000u) || *(volatile unsigned*)0x56008008 != 0x99u
        || (__get_FPSCR()&0x1C00000u) || __get_PRIMASK()) return 10;
    unsigned count = 0, mismatches = 0;
    for (unsigned logn = 9; logn <= 10; logn ++) {
        size_t n = (size_t)1 << logn;
        const char *const *kat = logn == 9 ? KAT_KG512 : KAT_KG1024;
        for (unsigned w = 0; w < 3; w ++) {
            if (!fndsa_keygen_seeded_temp(logn, "test0", 5, sk, pk, tmp, 22*n+31)) return 11;
        }
        uint64_t total = 0;
        for (unsigned i = 0; i < 100; i ++) {
            if (kat[i] == NULL) return 12;
            char seed[32]; sprintf(seed, "test%u", i);
            uint64_t elapsed = measure(logn, seed, strlen(seed));
            if (!keygen_ok || elapsed == 0) return 13;
            samples[i] = elapsed; total += elapsed;

            int8_t *f = polys, *g = f+n, *F = g+n, *G = F+n;
            unsigned bits = logn == 10 ? 5 : 6; size_t off = 1;
            off += trim_i8_decode(logn, sk+off, f, bits);
            off += trim_i8_decode(logn, sk+off, g, bits);
            off += trim_i8_decode(logn, sk+off, F, 8);
            if (off+64 != FNDSA_SIGN_KEY_SIZE(logn)) return 20;
            if (1+mqpoly_decode(logn, pk+1, mh) != FNDSA_VRFY_KEY_SIZE(logn)) return 21;
            mqpoly_ext_to_int(logn, mh);
            mqpoly_small_to_int(logn, F, mt); mqpoly_int_to_ntt(logn, mt);
            mqpoly_mul_ntt(logn, mt, mh); mqpoly_ntt_to_int(logn, mt);
            if (!mqpoly_int_to_small(logn, mt, G)) return 22;
            for (size_t u = 0; u < n; u ++) {
                int32_t s = 0;
                for (size_t j = 0; j <= u; j ++) s += f[j]*G[u-j]-g[j]*F[u-j];
                for (size_t j = u+1; j < n; j ++) s -= f[j]*G[n+u-j]-g[j]*F[n+u-j];
                if (s != (u == 0 ? 12289 : 0)) return 23;
            }
            sha256_context c; uint8_t actual[32], expected[32], encoded[32];
            sha256_init(&c); sha256_update(&c, polys, 4*n); sha256_close(&c, actual);
            hextobin(expected, 32, kat[i]); unsigned match = memcmp(actual, expected, 32) == 0;
            mismatches += !match;
            sha256_init(&c); sha256_update(&c, sk, FNDSA_SIGN_KEY_SIZE(logn));
            sha256_update(&c, pk, FNDSA_VRFY_KEY_SIZE(logn)); sha256_close(&c, encoded);
            count ++;
            printf("KEYGEN_PERF degree=%u index=%u cycles=%llu match=%u equation=PASS keyhash=",
                1u << logn, i, (unsigned long long)elapsed, match);
            for (unsigned j = 0; j < 32; j ++) printf("%02x", encoded[j]);
            printf("\n");
        }
        if (kat[100] != NULL) return 24;
        sort(samples, 100);
        printf("KEYGEN_SUMMARY degree=%u calls=100 total=%llu median_lo=%llu median_hi=%llu min=%llu max=%llu\n",
            1u << logn, (unsigned long long)total,
            (unsigned long long)samples[49], (unsigned long long)samples[50],
            (unsigned long long)samples[0], (unsigned long long)samples[99]);
    }
    printf("KEYGEN_DONE count=%u mismatches=%u\n", count, mismatches);
    return mismatches != 0;
}

