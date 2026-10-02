/* FN-DSA stage B. The crypto sources under ../../ref are compiled in place.
 * Counts, block timing and upper-median selection match mlkem-native's
 * Nucleo benchmark at 637d076. Inputs are our documented FN-DSA seeded APIs.
 * This is not an implementation of the mlkem-native ML-KEM benchmark. */
#ifndef FNDSA_MP31_SELFTEST
#define FNDSA_MP31_SELFTEST   0
#endif
#ifndef FNDSA_MP31_SIGNED_SELFTEST
#define FNDSA_MP31_SIGNED_SELFTEST   0
#endif

#include "inner.h"
#if FNDSA_MP31_SELFTEST
#include "kgen_inner.h"
#endif
#include <inttypes.h>
#include <stdio.h>
#include <string.h>
#ifndef BENCH_HOST
#include <zephyr/kernel.h>
#include <cmsis_core.h>
#include <stm32n6xx.h>
#include <stm32n6xx_ll_rcc.h>
#endif

#define BATCHES 10u
#define WARMUPS 10u
#define ITERATIONS 10u
static uint8_t sk[FNDSA_SIGN_KEY_SIZE(10)] __attribute__((aligned(32)));
static uint8_t pk[FNDSA_VRFY_KEY_SIZE(10)] __attribute__((aligned(32)));
static uint8_t sig[FNDSA_SIGNATURE_SIZE(10)] __attribute__((aligned(32)));
static uint8_t tmp[59 * 1024 + 31] __attribute__((aligned(32)));
static uint16_t ntt_actual[1024] __attribute__((aligned(32)));
static uint16_t ntt_oracle[1024] __attribute__((aligned(32)));
#if FNDSA_MP31_SELFTEST
static uint32_t mp31_actual[1024] __attribute__((aligned(32)));
static uint32_t mp31_oracle[1024] __attribute__((aligned(32)));

extern void fndsa_mp_NTT_c(unsigned, uint32_t *, const uint32_t *,
                           uint32_t, uint32_t);
extern void fndsa_mp_iNTT_c(unsigned, uint32_t *, const uint32_t *,
                            uint32_t, uint32_t);
/* Optional M1-only entry; absent from M0 and garbage-collected in non-audit
 * firmware. This runs the production assembly multiplication macro. */
extern void fndsa_mp31_monty4_probe(uint32_t *, const uint32_t *,
                                  uint32_t, uint32_t) __attribute__((weak));
#endif
/* Retained in DTCM for post-completion debugger inspection. */
volatile uint64_t fndsa_batch_cycles[2][3][BATCHES];
volatile uint32_t fndsa_progress[5]; /* state, degree, batch, operation, error */

/* Upstream keeps CONFIG_MINIMAL_LIBC_LL_PRINTF disabled. Convert only
 * outside timing, without changing its libc configuration. */
static const char *u64_text(uint64_t x)
{
    static char buffers[4][21];
    static unsigned next;
    char *end = buffers[(next++) & 3u] + 20;
    *end = 0;
    do {
        *--end = (char)('0' + x % 10);
        x /= 10;
    } while (x != 0);
    return end;
}

static uint64_t cycles(void)
{
#ifdef BENCH_HOST
    return 0;
#else
    return k_cycle_get_64();
#endif
}

static void seed_for(uint8_t *dst, size_t len, unsigned logn,
                     unsigned phase, unsigned index)
{
    for (size_t j = 0; j < len; j++)
        dst[j] = (uint8_t)(0xA5u + 29u * j + 13u * phase + 7u * logn);
    for (unsigned j = 0; j < 4; j++)
        dst[j] ^= (uint8_t)(index >> (8 * j));
}

static void inject_outputs(shake_context *sc, unsigned logn)
{
    shake_inject(sc, sk, FNDSA_SIGN_KEY_SIZE(logn));
    shake_inject(sc, pk, FNDSA_VRFY_KEY_SIZE(logn));
    shake_inject(sc, sig, FNDSA_SIGNATURE_SIZE(logn));
}

static void print_digest(shake_context *sc)
{
    static const char hex[] = "0123456789abcdef";
    uint8_t bytes[32];
    char out[65];
    shake_flip(sc);
    shake_extract(sc, bytes, sizeof bytes);
    for (unsigned i = 0; i < sizeof bytes; i++) {
        out[2*i] = hex[bytes[i] >> 4];
        out[2*i+1] = hex[bytes[i] & 15];
    }
    out[64] = 0;
    printf("%s\n", out);
}

static int failure(unsigned code)
{
    fndsa_progress[4] = code;
    fndsa_progress[0] = 3;
    printf("FNDSA_FAILURE code=%u degree=%u batch=%u op=%u\n", code,
           (unsigned)fndsa_progress[1], (unsigned)fndsa_progress[2],
           (unsigned)fndsa_progress[3]);
    return 1;
}

/* Independent scalar oracle for the exact integer NTT contract.  mq_GM and
 * mq_iGM hold Montgomery-R32 roots, hence multiplication by R^-1=11857. */
#define NTT_Q 12289u
#define NTT_R32_INV 11857u

extern uint32_t fndsa_stage3_mul_probe(uint32_t, int32_t, int32_t)
    __attribute__((weak));
extern const int16_t fndsa_mq_mont3_GM[] __attribute__((weak));
extern const int16_t fndsa_mq_mont3_GM_twist[] __attribute__((weak));
extern const int16_t fndsa_mq_mont3_iGM[] __attribute__((weak));
extern const int16_t fndsa_mq_mont3_iGM_twist[] __attribute__((weak));
extern const int16_t fndsa_mq_barrett3_GM[] __attribute__((weak));
extern const int16_t fndsa_mq_barrett3_GM_twist[] __attribute__((weak));
extern const int16_t fndsa_mq_barrett3_iGM[] __attribute__((weak));
extern const int16_t fndsa_mq_barrett3_iGM_twist[] __attribute__((weak));

static uint16_t oracle_mmul(uint16_t x, uint16_t root_r32)
{
    uint32_t z = ((uint32_t)(x % NTT_Q) * root_r32) % NTT_Q;
    return (uint16_t)((z * NTT_R32_INV) % NTT_Q);
}

static uint16_t oracle_add(uint16_t x, uint16_t y)
{
    return (uint16_t)(((uint32_t)(x % NTT_Q) + (y % NTT_Q)) % NTT_Q);
}

static uint16_t oracle_sub(uint16_t x, uint16_t y)
{
    return (uint16_t)(((uint32_t)(x % NTT_Q) + NTT_Q
                       - (y % NTT_Q)) % NTT_Q);
}

static uint16_t oracle_half(uint16_t x)
{
    uint32_t z = x % NTT_Q;
    return (uint16_t)((z + (NTT_Q & -(z & 1u))) >> 1);
}

static void oracle_ntt(unsigned logn, uint16_t *d)
{
    size_t t = (size_t)1 << logn;
    for (unsigned lm = 0; lm < logn; lm++) {
        size_t m = (size_t)1 << lm;
        size_t ht = t >> 1;
        size_t j0 = 0;
        for (size_t i = 0; i < m; i++) {
            uint16_t root = mq_GM[i + m];
            for (size_t j = 0; j < ht; j++) {
                size_t j1 = j0 + j, j2 = j1 + ht;
                uint16_t x1 = d[j1];
                uint16_t x2 = oracle_mmul(d[j2], root);
                d[j1] = oracle_add(x1, x2);
                d[j2] = oracle_sub(x1, x2);
            }
            j0 += t;
        }
        t = ht;
    }
}

static void oracle_intt(unsigned logn, uint16_t *d)
{
    size_t t = 1;
    for (unsigned lm = 0; lm < logn; lm++) {
        size_t hm = (size_t)1 << (logn - 1 - lm);
        size_t dt = t << 1;
        size_t j0 = 0;
        for (size_t i = 0; i < hm; i++) {
            uint16_t root = mq_iGM[i + hm];
            for (size_t j = 0; j < t; j++) {
                size_t j1 = j0 + j, j2 = j1 + t;
                uint16_t x1 = d[j1], x2 = d[j2];
                d[j1] = oracle_half(oracle_add(x1, x2));
                d[j2] = oracle_mmul(oracle_sub(x1, x2), root);
            }
            j0 += dt;
        }
        t = dt;
    }
}

static int ntt_exactness_test(unsigned logn)
{
    size_t n = (size_t)1 << logn;
    if (fndsa_stage3_mul_probe != NULL) {
        const int16_t *roots = fndsa_mq_mont3_GM;
        const int16_t *twists = fndsa_mq_mont3_GM_twist;
        const int16_t *iroots = fndsa_mq_mont3_iGM;
        const int16_t *itwists = fndsa_mq_mont3_iGM_twist;
        const char *kind = "mont3";
        if (roots == NULL || twists == NULL) {
            roots = fndsa_mq_barrett3_GM;
            twists = fndsa_mq_barrett3_GM_twist;
            iroots = fndsa_mq_barrett3_iGM;
            itwists = fndsa_mq_barrett3_iGM_twist;
            kind = "barrett3";
        }
        unsigned table_bad = 0, first = 0, first_got = 0, first_expected = 0;
        for (unsigned inverse = 0; inverse < 2; inverse++) {
            const int16_t *rr = inverse ? iroots : roots;
            const int16_t *tt = inverse ? itwists : twists;
            const uint16_t *reference = inverse ? mq_iGM : mq_GM;
            for (unsigned i = 0; i < 1024; i++) {
                uint16_t input = (uint16_t)((1234u + 4051u * i) % NTT_Q);
                unsigned got = fndsa_stage3_mul_probe(
                    input, rr[i], tt[i]) % NTT_Q;
                unsigned expected = oracle_mmul(input, reference[i]);
                if (got != expected) {
                    if (table_bad == 0) {
                        first = i + (inverse << 16);
                        first_got = got;
                        first_expected = expected;
                    }
                    table_bad++;
                }
            }
        }
        printf("NTT_MUL_TABLE kind=%s pairs=2048 mismatches=%u first=%u "
               "actual=%u expected=%u\n", kind, table_bad, first,
               first_got, first_expected);
        if (table_bad != 0) return 0;
    }
    for (size_t i = 0; i < n; i++) {
        uint16_t x = (uint16_t)((i * 4051u + i * i * 17u + 3u) % NTT_Q);
        if ((i % 37u) == 0) x = NTT_Q; /* alternate relaxed zero */
        ntt_actual[i] = x;
        ntt_oracle[i] = x;
    }
    mqpoly_int_to_ntt(logn, ntt_actual);
    oracle_ntt(logn, ntt_oracle);
    unsigned forward_bad = 0, roundtrip_bad = 0, oracle_bad = 0;
    unsigned max_error = 0;
    size_t first_forward = n, first_roundtrip = n, first_oracle = n;
    unsigned first_actual = 0, first_expected = 0;
    for (size_t i = 0; i < n; i++) {
        unsigned a = ntt_actual[i] % NTT_Q;
        unsigned b = ntt_oracle[i] % NTT_Q;
        unsigned e = a > b ? a - b : b - a;
        if (e > NTT_Q - e) e = NTT_Q - e;
        if (a != b && first_forward == n) {
            first_forward = i;
            first_actual = a;
            first_expected = b;
        }
        forward_bad += a != b;
        if (e > max_error) max_error = e;
    }
    mqpoly_ntt_to_int(logn, ntt_actual);
    oracle_intt(logn, ntt_oracle);
    for (size_t i = 0; i < n; i++) {
        uint16_t original = (uint16_t)((i * 4051u + i * i * 17u + 3u) % NTT_Q);
        if ((i % 37u) == 0) original = NTT_Q;
        if ((ntt_actual[i] % NTT_Q) != (original % NTT_Q)
                && first_roundtrip == n) first_roundtrip = i;
        if ((ntt_oracle[i] % NTT_Q) != (original % NTT_Q)
                && first_oracle == n) first_oracle = i;
        roundtrip_bad += (ntt_actual[i] % NTT_Q) != (original % NTT_Q);
        oracle_bad += (ntt_oracle[i] % NTT_Q) != (original % NTT_Q);
    }
    printf("NTT_EXACT degree=%u forward_mismatches=%u "
           "roundtrip_mismatches=%u oracle_roundtrip_mismatches=%u "
           "max_mod_error=%u first_forward=%u actual=%u expected=%u "
           "first_roundtrip=%u first_oracle=%u\n", 1u << logn, forward_bad,
           roundtrip_bad, oracle_bad, max_error,
           first_forward == n ? 0xFFFFFFFFu : (unsigned)first_forward,
           first_actual, first_expected,
           first_roundtrip == n ? 0xFFFFFFFFu : (unsigned)first_roundtrip,
           first_oracle == n ? 0xFFFFFFFFu : (unsigned)first_oracle);
    return forward_bad == 0 && roundtrip_bad == 0 && oracle_bad == 0;
}

#if FNDSA_MP31_SELFTEST
/* All roots of the largest transform, both directions, with 12 edge inputs
 * plus four deterministic samples. No timing claims use this audit image. */
static int mp31_rounding_test(void)
{
    if (!fndsa_mp31_monty4_probe) return 1;
    uint32_t *gm = (uint32_t *)(void *)tmp;
    uint32_t *igm = gm + 1024;
    uint32_t a[4] __attribute__((aligned(16)));
    uint32_t b[4] __attribute__((aligned(16)));
    unsigned cases = 0, mismatches = 0, range_bad = 0;
    unsigned first_prime = 0xFFFFFFFFu, first_root = 0;
    uint32_t rng = 0x12345678u;
    for (unsigned pi = 0; PRIMES[pi].p != 0; pi++) {
        uint32_t p = PRIMES[pi].p, p0i = PRIMES[pi].p0i;
        mp_mkgmigm(10, gm, igm, PRIMES[pi].g, PRIMES[pi].ig, p, p0i);
        const uint32_t edges[12] = {0, 1, 2, p - 1, p - 2, p - 3,
            p >> 1, (p >> 1) + 1, 0x3FFFFFFF, 0x40000000,
            0x40000001, (p >> 1) - 1};
        for (unsigned direction = 0; direction < 2; direction++) {
            const uint32_t *roots = direction ? igm : gm;
            for (unsigned j = 0; j < 1024; j += 4) {
                memcpy(b, roots + j, sizeof b);
                for (unsigned pattern = 0; pattern < 16; pattern++) {
                    uint32_t expected[4];
                    for (unsigned lane = 0; lane < 4; lane++) {
                        rng = rng * 1664525u + 1013904223u;
                        a[lane] = pattern < 12 ? edges[pattern] : rng % p;
                        expected[lane] = mp_mmul(a[lane], b[lane], p, p0i);
                    }
                    fndsa_mp31_monty4_probe(a, b, p, p0i);
                    for (unsigned lane = 0; lane < 4; lane++) {
                        range_bad += a[lane] >= p;
                        if (a[lane] != expected[lane]) {
                            mismatches++;
                            if (first_prime == 0xFFFFFFFFu) {
                                first_prime = pi;
                                first_root = j + lane;
                            }
                        }
                        cases++;
                    }
                }
#if FNDSA_MP31_SIGNED_SELFTEST
                /* M1-improve feeds the exact signed result of x-y directly
                 * to the same production Montgomery macro.  Check the full
                 * (-p,p) boundary as two's-complement lane values; the scalar
                 * oracle receives the corresponding canonical residue. */
                for (unsigned pattern = 0; pattern < 14; pattern++) {
                    uint32_t expected[4];
                    for (unsigned lane = 0; lane < 4; lane++) {
                        int32_t value;
                        switch (pattern) {
                        case 0: value = -(int32_t)(p - 1); break;
                        case 1: value = -(int32_t)(p - 2); break;
                        case 2: value = -(int32_t)((p >> 1) + 1); break;
                        case 3: value = -(int32_t)(p >> 1); break;
                        case 4: value = -2; break;
                        case 5: value = -1; break;
                        case 6: value = 0; break;
                        case 7: value = 1; break;
                        case 8: value = 2; break;
                        case 9: value = (int32_t)(p >> 1); break;
                        case 10: value = (int32_t)((p >> 1) + 1); break;
                        case 11: value = (int32_t)(p - 2); break;
                        case 12: value = (int32_t)(p - 1); break;
                        default: {
                            rng = rng * 1664525u + 1013904223u;
                            int32_t x = (int32_t)(rng % p);
                            rng = rng * 1664525u + 1013904223u;
                            int32_t y = (int32_t)(rng % p);
                            value = x - y;
                            break;
                        }
                        }
                        a[lane] = (uint32_t)value;
                        uint32_t canonical = value < 0
                            ? (uint32_t)((int64_t)value + p)
                            : (uint32_t)value;
                        expected[lane] = mp_mmul(
                            canonical, b[lane], p, p0i);
                    }
                    fndsa_mp31_monty4_probe(a, b, p, p0i);
                    for (unsigned lane = 0; lane < 4; lane++) {
                        range_bad += a[lane] >= p;
                        if (a[lane] != expected[lane]) {
                            mismatches++;
                            if (first_prime == 0xFFFFFFFFu) {
                                first_prime = pi;
                                first_root = j + lane;
                            }
                        }
                        cases++;
                    }
                }
#endif
            }
        }
    }
    printf("MP31_ROUNDING cases=%u mismatches=%u range_errors=%u "
           "first_prime=%u first_root=%u\n", cases, mismatches,
           range_bad, first_prime, first_root);
    return mismatches == 0 && range_bad == 0;
}

/* Compare the MVE transform coefficient-for-coefficient with the retained C
 * implementation for every NTRU RNS prime and every vectorized logn.  The
 * existing large temporary buffer is reused before key generation starts. */
static int mp31_exactness_test(void)
{
    if (!mp31_rounding_test()) return 0;
    uint32_t *gm = (uint32_t *)(void *)tmp;
    uint32_t *igm = gm + 1024;
    uint32_t *source = igm + 1024;
    unsigned primes = 0, transforms = 0, forward_bad = 0;
    unsigned inverse_bad = 0, roundtrip_bad = 0, max_mod_error = 0;
    unsigned first_prime = 0xFFFFFFFFu, first_logn = 0, first_index = 0;

    for (unsigned pi = 0; PRIMES[pi].p != 0; pi++) {
        uint32_t p = PRIMES[pi].p;
        uint32_t p0i = PRIMES[pi].p0i;
        primes++;
        for (unsigned logn = 4; logn <= 10; logn++) {
            size_t n = (size_t)1 << logn;
            mp_mkgmigm(logn, gm, igm, PRIMES[pi].g, PRIMES[pi].ig,
                       p, p0i);
            for (size_t i = 0; i < n; i++) {
                uint32_t x = (uint32_t)(((uint64_t)(i + 1)
                    * 0x9E3779B1u + (uint64_t)(pi + 1)
                    * 0x6A09E667u + logn) % p);
                switch (i & 63u) {
                case 0: x = 0; break;
                case 1: x = 1; break;
                case 2: x = p >> 1; break;
                case 3: x = p - 2; break;
                case 4: x = p - 1; break;
                default: break;
                }
                source[i] = x;
                mp31_actual[i] = x;
                mp31_oracle[i] = x;
            }
            mp_NTT(logn, mp31_actual, gm, p, p0i);
            fndsa_mp_NTT_c(logn, mp31_oracle, gm, p, p0i);
            for (size_t i = 0; i < n; i++) {
                uint32_t x = mp31_actual[i], y = mp31_oracle[i];
                uint32_t e = x > y ? x - y : y - x;
                if (e > p - e) e = p - e;
                if (e > max_mod_error) max_mod_error = e;
                if (x != y) {
                    forward_bad++;
                    if (first_prime == 0xFFFFFFFFu) {
                        first_prime = pi;
                        first_logn = logn;
                        first_index = (unsigned)i;
                    }
                }
            }
            mp_iNTT(logn, mp31_actual, igm, p, p0i);
            fndsa_mp_iNTT_c(logn, mp31_oracle, igm, p, p0i);
            for (size_t i = 0; i < n; i++) {
                inverse_bad += mp31_actual[i] != mp31_oracle[i];
                roundtrip_bad += mp31_actual[i] != source[i];
            }
            transforms++;
        }
    }
    printf("MP31_EXACT primes=%u logn=4..10 transforms=%u "
           "forward_mismatches=%u inverse_mismatches=%u "
           "roundtrip_mismatches=%u max_mod_error=%u "
           "first_prime=%u first_logn=%u first_index=%u\n",
           primes, transforms, forward_bad, inverse_bad, roundtrip_bad,
           max_mod_error, first_prime, first_logn, first_index);
    return forward_bad == 0 && inverse_bad == 0 && roundtrip_bad == 0;
}

/* Direct transform timing for the public logn range used by the vector
 * implementation.  Root-domain preparation is deliberately included: it
 * is performed inside mp_NTT()/mp_iNTT() by the candidate and is therefore
 * a real kernel cost.  Ten batches of 100 calls expose placement/noise
 * without mixing these numbers with key-generation retry variability. */
static void mp31_cycle_test(void)
{
    enum { MP31_CYCLE_BATCHES = 10, MP31_CYCLE_CALLS = 100 };
    uint32_t *gm = (uint32_t *)(void *)tmp;
    uint32_t *igm = gm + 1024;
    uint32_t p = PRIMES[0].p, p0i = PRIMES[0].p0i;
    for (unsigned logn = 4; logn <= 10; logn++) {
        size_t n = (size_t)1 << logn;
        mp_mkgmigm(logn, gm, igm, PRIMES[0].g, PRIMES[0].ig, p, p0i);
        for (size_t i = 0; i < n; i++) {
            mp31_actual[i] = (uint32_t)(((uint64_t)(i + 1)
                * 0x9E3779B1u + logn) % p);
        }
        mp_NTT(logn, mp31_actual, gm, p, p0i);
        mp_iNTT(logn, mp31_actual, igm, p, p0i);
        for (unsigned direction = 0; direction < 2; direction++) {
            const uint32_t *roots = direction ? igm : gm;
            for (unsigned batch = 0; batch < MP31_CYCLE_BATCHES; batch++) {
                uint64_t start = cycles();
                for (unsigned j = 0; j < MP31_CYCLE_CALLS; j++) {
                    if (direction) {
                        mp_iNTT(logn, mp31_actual, roots, p, p0i);
                    } else {
                        mp_NTT(logn, mp31_actual, roots, p, p0i);
                    }
                }
                uint64_t elapsed = cycles() - start;
                printf("MP31_CYCLES logn=%u direction=%s batch=%u calls=%u "
                       "total=%s per_call=%s twiddle_prepare=included\n",
                       logn, direction ? "inverse" : "forward", batch,
                       MP31_CYCLE_CALLS, u64_text(elapsed),
                       u64_text(elapsed / MP31_CYCLE_CALLS));
            }
        }
    }
}
#endif

#ifndef BENCH_HOST
static uint32_t *stack_watermark_start, *stack_watermark_end;
static size_t main_stack_size;

static void stack_watermark_init(void)
{
    struct k_thread *thread = k_current_get();
    uintptr_t start = thread->stack_info.start;
    uintptr_t end = __get_PSP() - 4096u;
    main_stack_size = thread->stack_info.size;
    if (end <= start || end > start + main_stack_size) return;
    stack_watermark_start = (uint32_t *)((start + 3) & ~(uintptr_t)3);
    stack_watermark_end = (uint32_t *)(end & ~(uintptr_t)3);
    /* Only unused current-thread stack below a 4 KiB safety margin;
     * interrupts use their separate MSP. This is outside all timing. */
    for (uint32_t *p = stack_watermark_start; p < stack_watermark_end; p++)
        *p = 0xa5a5a5a5u;
    printf("STACK start=%08x size=%u watermarked_end=%08x\n",
           (unsigned)start, (unsigned)main_stack_size, (unsigned)end);
}

static void stack_watermark_report(void)
{
    uint32_t *p = stack_watermark_start;
    if (p == NULL) {
        printf("STACK watermark=UNAVAILABLE\n");
        return;
    }
    while (p < stack_watermark_end && *p == 0xa5a5a5a5u) p++;
    size_t unused = (size_t)(p - stack_watermark_start) * 4;
    printf("STACK untouched_prefix=%u used_upper_bound=%u\n",
           (unsigned)unused, (unsigned)(main_stack_size - unused));
}

static int hardware_audit(void)
{
    LL_RCC_ClocksTypeDef clocks;
    LL_RCC_GetSystemClocksFreq(&clocks);
    unsigned arm_mve = 0;
#ifdef __ARM_FEATURE_MVE
    arm_mve = __ARM_FEATURE_MVE;
#endif
    printf("BUILD gcc=%s asm_m4=%u m55_compat=%u mve_feature=%u\n",
           __VERSION__, FNDSA_ASM_CORTEXM4, FNDSA_ASM_CORTEXM55, arm_mve);
    printf("CONFIG cycle_hz=%u stack=%u fpu=%u cache_management=%u icache=%u dcache=%u\n",
           CONFIG_SYS_CLOCK_HW_CYCLES_PER_SEC, CONFIG_MAIN_STACK_SIZE,
           IS_ENABLED(CONFIG_FPU), IS_ENABLED(CONFIG_CACHE_MANAGEMENT),
           IS_ENABLED(CONFIG_ICACHE), IS_ENABLED(CONFIG_DCACHE));
    printf("CORE cpuid=%08x ccr=%08x vtor=%08x cpacr=%08x primask=%u basepri=%u control=%u\n",
           (unsigned)SCB->CPUID, (unsigned)SCB->CCR, (unsigned)SCB->VTOR,
           (unsigned)SCB->CPACR, (unsigned)__get_PRIMASK(),
           (unsigned)__get_BASEPRI(), (unsigned)__get_CONTROL());
    /* Do not access clock-gated SYSCFG merely for diagnostics. The loader
     * verifies FLEXMEM before boot, and these core registers give the live
     * enabled TCM sizes without peripheral-clock side effects. */
    printf("TCM itcmcr=%08x dtcmcr=%08x mpu=%08x\n",
           (unsigned)MEMSYSCTL->ITCMCR, (unsigned)MEMSYSCTL->DTCMCR,
           (unsigned)MPU->CTRL);
    printf("ADDR code=%08x sk=%08x pk=%08x sig=%08x tmp=%08x sp=%08x\n",
           (unsigned)(uintptr_t)&hardware_audit, (unsigned)(uintptr_t)sk,
           (unsigned)(uintptr_t)pk, (unsigned)(uintptr_t)sig,
           (unsigned)(uintptr_t)tmp, (unsigned)__get_PSP());
    printf("CLOCK SystemCoreClock=%u CFGR1=%08x CFGR2=%08x HSECFGR=%08x\n",
           (unsigned)SystemCoreClock, (unsigned)RCC->CFGR1,
           (unsigned)RCC->CFGR2, (unsigned)RCC->HSECFGR);
    printf("CLOCK IC1=%08x IC2=%08x IC6=%08x IC11=%08x\n",
           (unsigned)RCC->IC1CFGR, (unsigned)RCC->IC2CFGR,
           (unsigned)RCC->IC6CFGR, (unsigned)RCC->IC11CFGR);
    printf("CLOCK PLL1_1=%08x PLL1_2=%08x PLL1_3=%08x\n",
           (unsigned)RCC->PLL1CFGR1, (unsigned)RCC->PLL1CFGR2,
           (unsigned)RCC->PLL1CFGR3);
    printf("CLOCK_DECODE cpu=%u sysclk=%u hclk=%u pclk1=%u pclk2=%u pclk4=%u pclk5=%u\n",
           (unsigned)clocks.CPUCLK_Frequency, (unsigned)clocks.SYSCLK_Frequency,
           (unsigned)clocks.HCLK_Frequency, (unsigned)clocks.PCLK1_Frequency,
           (unsigned)clocks.PCLK2_Frequency, (unsigned)clocks.PCLK4_Frequency,
           (unsigned)clocks.PCLK5_Frequency);
    /* DWT is a pre-run cross-check, never the performance timer. Its
     * 32-bit counter is read within a short interval. k_busy_wait leaves
     * interrupts enabled, checking the 64-bit SysTick extension over wraps. */
    uint32_t old_demcr = CoreDebug->DEMCR, old_dwt_ctrl = DWT->CTRL;
    CoreDebug->DEMCR |= CoreDebug_DEMCR_TRCENA_Msk;
    DWT->CTRL |= DWT_CTRL_CYCCNTENA_Msk;
    uint64_t z0 = cycles();
    uint32_t d0 = DWT->CYCCNT;
    k_busy_wait(100000);
    uint32_t d1 = DWT->CYCCNT;
    uint64_t z1 = cycles();
    DWT->CTRL = old_dwt_ctrl;
    CoreDebug->DEMCR = old_demcr;
    uint64_t delta = z1 - z0;
    uint32_t ddelta = d1 - d0;
    uint64_t error = delta > ddelta ? delta - ddelta : ddelta - delta;
    printf("TIMER selfcheck_100ms_zephyr=%s dwt=%u error=%s\n",
           u64_text(delta), (unsigned)ddelta, u64_text(error));
    if (CONFIG_SYS_CLOCK_HW_CYCLES_PER_SEC != 800000000 ||
        SystemCoreClock != 800000000 || __get_PRIMASK() != 0 ||
        (SCB->CPUID & 0xFFF0u) != 0xD220u ||
        clocks.CPUCLK_Frequency != 800000000 ||
        clocks.SYSCLK_Frequency != 400000000 || clocks.HCLK_Frequency != 200000000 ||
        (SCB->CCR & (SCB_CCR_IC_Msk | SCB_CCR_DC_Msk)) != 0 ||
        (MEMSYSCTL->ITCMCR & 0x79u) != 0x49u ||
        (MEMSYSCTL->DTCMCR & 0x79u) != 0x49u ||
        delta < 79000000 || delta > 81000000 || error > 20000)
        return failure(0x90);
    return 0;
}
#endif

/* No logging, seeding, hash audit, or per-call timing within the block. */
#define MEASURE(OP, CALL, EXPECTED) do { \
    fndsa_progress[3] = (OP); \
    unsigned bad = 0; \
    printf("PHASE degree=%u batch=%u op=%u\n", 1u << logn, batch, (OP)); \
    for (unsigned j = 0; j < nwarm; j++) bad |= ((CALL) != (EXPECTED)); \
    if (bad) return failure(0x10 + (OP)); \
    uint64_t start = cycles(); \
    for (unsigned j = 0; j < niter; j++) bad |= ((CALL) != (EXPECTED)); \
    uint64_t elapsed = cycles() - start; \
    if (bad) return failure(0x20 + (OP)); \
    fndsa_batch_cycles[logn - 9][OP][batch] = elapsed; \
    printf("BATCH degree=%u batch=%u op=%u total=%s per_call=%s\n", \
           1u << logn, batch, (OP), u64_text(elapsed), u64_text(elapsed / niter)); \
} while (0)

static void summarize(unsigned logn, unsigned op, unsigned nbatch, unsigned niter)
{
    uint64_t sorted[BATCHES];
    for (unsigned j = 0; j < nbatch; j++) {
        uint64_t v = fndsa_batch_cycles[logn - 9][op][j];
        unsigned k = j;
        while (k > 0 && sorted[k - 1] > v) {
            sorted[k] = sorted[k - 1];
            k--;
        }
        sorted[k] = v;
    }
    printf("SUMMARY degree=%u op=%u upper_median=%s",
           1u << logn, op, u64_text(sorted[nbatch >> 1] / niter));
    static const unsigned percentiles[] = {1,10,20,30,40,50,60,70,80,90,99};
    for (unsigned j = 0; j < sizeof percentiles / sizeof percentiles[0]; j++) {
        unsigned p = percentiles[j];
        printf(" p%u=%s", p, u64_text(sorted[nbatch * p / 100] / niter));
    }
    printf("\n");
}

int mlk_test_main(int argc, char **argv)
{
    unsigned nbatch = BATCHES, nwarm = WARMUPS, niter = ITERATIONS;
    int pilot = argc > 1 && strcmp(argv[1], "--pilot") == 0;
    if (pilot) nbatch = nwarm = niter = 1;
#ifdef BENCH_HOST
    nwarm = 0;
    niter = 1;
#endif
    printf("FNDSA_BEGIN mode=%s batches=%u warmups=%u iterations=%u\n",
           pilot ? "pilot" : "full", nbatch, nwarm, niter);
    fndsa_progress[0] = 1;
#ifndef BENCH_HOST
    if (hardware_audit()) return 1;
    stack_watermark_init();
#endif
#ifndef BENCH_HOST
    for (unsigned logn = 9; logn <= 10; logn++) {
        fndsa_progress[1] = 1u << logn;
        if (!ntt_exactness_test(logn)) return failure(0xA0u + logn);
    }
#endif
#if FNDSA_MP31_SELFTEST
    if (!mp31_exactness_test()) return failure(0xB0);
    mp31_cycle_test();
#endif
    for (unsigned logn = 9; logn <= 10; logn++) {
        shake_context audit;
        shake_init(&audit, 256);
        fndsa_progress[1] = 1u << logn;
        for (unsigned batch = 0; batch < nbatch; batch++) {
            uint8_t key_seed[32], sign_seed[40];
            size_t sklen = FNDSA_SIGN_KEY_SIZE(logn);
            size_t pklen = FNDSA_VRFY_KEY_SIZE(logn);
            size_t siglen = FNDSA_SIGNATURE_SIZE(logn);
            size_t tmplen = ((size_t)59 << logn) + 31;
            seed_for(key_seed, sizeof key_seed, logn, 1, batch);
            seed_for(sign_seed, sizeof sign_seed, logn, 2, batch);
            fndsa_progress[2] = batch;
            MEASURE(0u, fndsa_keygen_seeded_temp(logn, key_seed,
                sizeof key_seed, sk, pk, tmp, tmplen), 1);
            MEASURE(1u, fndsa_sign_seeded_temp(sk, sklen, NULL, 0,
                FNDSA_HASH_ID_RAW, "blah", 4, sign_seed, sizeof sign_seed,
                sig, siglen, tmp, tmplen), siglen);
            MEASURE(2u, fndsa_verify_temp(sig, siglen, pk, pklen, NULL, 0,
                FNDSA_HASH_ID_RAW, "blah", 4, tmp, tmplen), 1);
            sig[50] ^= 1;
            int accepted = fndsa_verify_temp(sig, siglen, pk, pklen, NULL, 0,
                FNDSA_HASH_ID_RAW, "blah", 4, tmp, tmplen);
            sig[50] ^= 1;
            if (accepted) return failure(0x40);
#if FNDSA_MP31_SELFTEST
            /* This check is deliberately audit-only so that it cannot move
             * the production benchmark hot code and bias API comparisons. */
            accepted = fndsa_verify_temp(sig, siglen, pk, pklen, NULL, 0,
                FNDSA_HASH_ID_RAW, "blai", 4, tmp, tmplen);
            if (accepted) return failure(0x41);
#endif
            shake_context one;
            shake_init(&one, 256);
            inject_outputs(&one, logn);
            inject_outputs(&audit, logn);
            printf("DIGEST degree=%u batch=%u shake256=", 1u << logn, batch);
            print_digest(&one);
        }
        printf("AUDIT degree=%u shake256=", 1u << logn);
        print_digest(&audit);
        for (unsigned op = 0; op < 3; op++) summarize(logn, op, nbatch, niter);
    }
    fndsa_progress[0] = 2;
#ifndef BENCH_HOST
    stack_watermark_report();
#endif
    printf("FNDSA_DONE correctness=PASS tamper_rejection=PASS\n");
    return 0;
}

#ifdef BENCH_HOST
int main(int argc, char **argv) { return mlk_test_main(argc, argv); }
#endif

