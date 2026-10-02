#include "kgen_inner.h"
#include <stdio.h>
#include <string.h>
#include <zephyr/kernel.h>
#include <cmsis_core.h>

typedef void (*mul_fn)(const uint64_t *, uint64_t *, unsigned, const uint64_t *);
#define DECLARE(off) extern void trial_twiddle_at_##off(const uint64_t *, uint64_t *, unsigned, const uint64_t *)
DECLARE(0); DECLARE(4); DECLARE(8); DECLARE(12);
DECLARE(16); DECLARE(20); DECLARE(24); DECLARE(28);
extern void fndsa_ntru_mve_q32_twiddle(const uint64_t *, uint64_t *, unsigned, const uint64_t *);
static const mul_fn functions[] = { trial_twiddle_at_0, trial_twiddle_at_4,
    trial_twiddle_at_8, trial_twiddle_at_12, trial_twiddle_at_16,
    trial_twiddle_at_20, trial_twiddle_at_24, trial_twiddle_at_28,
    fndsa_ntru_mve_q32_twiddle };
_Alignas(32) static uint64_t input[136], actual[136], expected[136];
static volatile uint64_t sink;
static uint64_t state;
static uint64_t next_word(void) { state ^= state << 13; state ^= state >> 7; state ^= state << 17; return state; }
static const uint64_t edges[] = { 0, 1, UINT64_MAX, UINT64_C(0x8000000000000000),
    UINT64_C(0x7fffffffffffffff), UINT64_C(0x100000000), UINT64_C(0xffffffff),
    UINT64_C(0x7fffffff), UINT64_C(0x80000000), UINT64_C(0x5555555555555555),
    UINT64_C(0xaaaaaaaaaaaaaaaa), UINT64_C(0xffffffff00000000) };
static uint32_t ticks(void) { __DSB(); __ISB(); return DWT->CYCCNT; }
static __attribute__((noipa)) uint32_t measure(mul_fn fn, unsigned n, unsigned calls, const uint64_t *tw)
{
    unsigned irq = irq_lock(); uint32_t start = ticks();
    for (unsigned i = 0; i < calls; i++) {
        fn(input, actual, n, tw); __asm__ volatile("" ::: "memory");
    }
    uint32_t elapsed = ticks() - start; irq_unlock(irq); sink ^= actual[0];
    return elapsed;
}
int mlk_test_main(int argc, char **argv)
{
    (void)argc; (void)argv; CoreDebug->DEMCR |= CoreDebug_DEMCR_TRCENA_Msk;
    DWT->CTRL |= DWT_CTRL_CYCCNTENA_Msk;
    unsigned cases = 0;
    for (unsigned size = 0; size < 2; size++) for (unsigned kind = 0; kind < 8; kind++)
      for (unsigned pos = 0; pos < 9; pos++) {
        unsigned n = size ? 128 : 4, calls = size ? 16 : 128;
        uint64_t tw = (uint64_t)(uint32_t)((int)(kind / 2) - 2) << 32
            | (kind & 1 ? UINT64_C(0xd2345679) : UINT64_C(0x34567891));
        uintptr_t address = (uintptr_t)functions[pos] & ~(uintptr_t)1;
        if (pos < 8 && (address & 31) != pos * 4) {
            printf("PLACEMENT_FAIL address pos=%u address=%08x\n", pos, (unsigned)address); return 1;
        }
        uint32_t min = UINT32_MAX, max = 0;
        state = UINT64_C(0x5345503237504c41) ^ ((uint64_t)n << 8) ^ kind;
        for (unsigned cls = 0; cls < 16; cls++) {
            for (unsigned i = 0; i < 136; i++) {
                input[i] = cls < 12 ? edges[(cls + i) % 12] : next_word();
                actual[i] = expected[i] = UINT64_C(0xa55a771122334455);
            }
            for (unsigned i = 0; i < n; i++) expected[i] = fxr_mul((fxr){input[i]}, (fxr){tw}).v;
            for (unsigned repeat = 0; repeat < 20; repeat++) {
                uint32_t t = measure(functions[pos], n, calls, &tw);
                if (t < min) min = t; if (t > max) max = t;
                if (memcmp(actual, expected, sizeof actual)) {
                    printf("PLACEMENT_FAIL n=%u kind=%u pos=%u class=%u\n", n, kind, pos, cls); return 2;
                }
            }
            cases++;
        }
        printf("PLACEMENT n=%u kind=%u pos=%u address=%08x calls=%u min=%u max=%u\n",
            n, kind, pos, (unsigned)address, calls, min, max);
    }
    printf("PLACEMENT_DONE cases=%u failures=0\n", cases); return 0;
}
