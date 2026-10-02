#include "kgen_inner.h"
#include <stdio.h>
#include <string.h>
#include <zephyr/kernel.h>
#include <cmsis_core.h>

extern void fndsa_fxr_div4(fxr a[4], const fxr b[4]);
static fxr num[8] __attribute__((aligned(16)));
static fxr den[8] __attribute__((aligned(16)));
static fxr saved[8], expected[8];
static fxr array[1028], original[1028], result[1028];
static uint64_t x[4], y[4], state = UINT64_C(0x7365703237667872);
static volatile uint32_t sink;
static const uint64_t guard = UINT64_C(0xa5a5a5a55a5a5a5a);
static const uint64_t edges[] = {
    0, 1, 2, 3, UINT64_MAX, UINT64_MAX - 1,
    UINT64_C(0x8000000000000000), UINT64_C(0x7fffffffffffffff),
    UINT64_C(0x100000000), UINT64_C(0xffffffff), UINT64_C(0x7fffffff),
    UINT64_C(0x80000000), UINT64_C(0xffffffff00000000),
    UINT64_C(0x5555555555555555), UINT64_C(0xaaaaaaaaaaaaaaaa)
};
static uint64_t rnd(void)
{
    state ^= state << 13; state ^= state >> 7; state ^= state << 17;
    return state;
}
static uint32_t ticks(void) { __DSB(); __ISB(); return DWT->CYCCNT; }
static void init(unsigned off)
{
    for (unsigned i = 0; i < 8; i ++) num[i].v = den[i].v = guard;
    for (unsigned i = 0; i < 4; i ++) {
        num[i + off].v = x[i]; den[i + off].v = y[i];
    }
    memcpy(saved, num, sizeof num);
    memcpy(expected, num, sizeof num);
}
static int check(unsigned kind, unsigned index, unsigned alias)
{
    unsigned off = index & 3;
    init(off);
    fndsa_fxr_div4(num + off, alias ? num + off : den + off);
    for (unsigned i = 0; i < 4; i ++) {
        expected[i + off].v = inner_fxr_div(x[i], alias ? x[i] : y[i]);
        if (num[i + off].v != expected[i + off].v) {
            printf("FXDIV_FAIL kind=%u index=%u alias=%u lane=%u x=%016llx y=%016llx got=%016llx want=%016llx\n",
                kind, index, alias, i, (unsigned long long)x[i],
                (unsigned long long)(alias ? x[i] : y[i]),
                (unsigned long long)num[i + off].v,
                (unsigned long long)expected[i + off].v);
            return 0;
        }
    }
    if (memcmp(num, expected, sizeof num)) {
        printf("FXDIV_FAIL output_guard index=%u\n", index); return 0;
    }
    for (unsigned i = 0; i < 8; i ++) {
        uint64_t want = (i >= off && i < off + 4) ? y[i - off] : guard;
        if (den[i].v != want) {
            printf("FXDIV_FAIL denominator index=%u slot=%u\n", index, i);
            return 0;
        }
    }
    return 1;
}
static __attribute__((noipa)) void scalar4(void)
{
    for (unsigned i = 0; i < 4; i ++)
        num[i + 2].v = inner_fxr_div(num[i + 2].v, den[i + 2].v);
}
/* Exact pre-A8 function body, with current unchanged fxr arithmetic. */
static __attribute__((noipa)) void inverse_original(unsigned logn, fxr *a, unsigned e)
{
    size_t hn = (size_t)1 << (logn - 1);
    for (size_t u = 0; u < hn; u ++) {
        fxr re = a[u], im = fxr_neg(a[u + hn]);
        fxr z = fxr_add(fxr_sqr(re), fxr_sqr(im));
        a[u] = fxr_div(fxr_mul2e(re, e), z);
        a[u + hn] = fxr_div(fxr_mul2e(im, e), z);
    }
}
static __attribute__((noipa)) uint32_t measure_div(unsigned old)
{
    for (unsigned j = 0; j < 4; j ++) {
        init(2); if (old) scalar4(); else fndsa_fxr_div4(num + 2, den + 2);
    }
    init(2);
    unsigned irq = irq_lock(); uint32_t t = ticks();
    for (unsigned j = 0; j < 64; j ++) {
        memcpy(num, saved, sizeof num);
        if (old) scalar4(); else fndsa_fxr_div4(num + 2, den + 2);
        __asm__ volatile("" ::: "memory");
    }
    t = ticks() - t; irq_unlock(irq); sink ^= num[2].v;
    return t;
}
static __attribute__((noipa)) uint32_t measure_inverse(unsigned logn, unsigned old)
{
    size_t bytes = ((size_t)1 << logn) * sizeof(fxr);
    for (unsigned j = 0; j < 4; j ++) {
        memcpy(array + 2, original + 2, bytes);
        if (old) inverse_original(logn, array + 2, 4);
        else vect_inv_mul2e_fft(logn, array + 2, 4);
    }
    uint32_t sum = 0;
    unsigned irq = irq_lock();
    for (unsigned j = 0; j < 32; j ++) {
        memcpy(array + 2, original + 2, bytes);
        uint32_t t = ticks();
        if (old) inverse_original(logn, array + 2, 4);
        else vect_inv_mul2e_fft(logn, array + 2, 4);
        sum += ticks() - t;
        __asm__ volatile("" ::: "memory");
    }
    irq_unlock(irq); sink ^= array[2].v;
    return sum;
}
int mlk_test_main(int argc, char **argv)
{
    (void)argc; (void)argv;
    CoreDebug->DEMCR |= CoreDebug_DEMCR_TRCENA_Msk;
    DWT->CTRL |= DWT_CTRL_CYCCNTENA_Msk;
    unsigned cases = 0, inverse = 0;
    for (unsigned a = 0; a < 15; a ++) for (unsigned b = 0; b < 15; b ++) {
        for (unsigned i = 0; i < 4; i ++) {
            x[i] = edges[(a + i) % 15]; y[i] = edges[(b + 3*i) % 15];
        }
        if (!check(0, cases, 0) || !check(1, cases, 1)) return 1;
        cases += 2;
    }
    for (unsigned j = 0; j < 250000; j ++) {
        for (unsigned i = 0; i < 4; i ++) { x[i] = rnd(); y[i] = rnd(); }
        if (!check(2, j, 0)) return 2;
        cases ++;
    }
    for (unsigned bit = 0; bit < 64; bit ++) for (unsigned j = 0; j < 64; j ++) {
        for (unsigned i = 0; i < 4; i ++) {
            y[i] = (UINT64_C(1) << bit) + (j & 3) - 1;
            x[i] = (UINT64_C(1) << ((j + i) & 63)) + (j % 3) - 1;
            if (i & 1) x[i] = -x[i];
            if (i & 2) y[i] = -y[i];
        }
        if (!check(3, cases, 0)) return 3;
        cases ++;
    }
    for (unsigned logn = 1; logn <= 10; logn ++) for (unsigned trial = 0; trial < 32; trial ++) {
        size_t n = (size_t)1 << logn, off = trial & 3;
        for (size_t i = 0; i < 1028; i ++) array[i].v = guard;
        for (size_t i = 0; i < n; i ++)
            array[i + off].v = trial < 15 ? edges[(trial+i) % 15] : rnd();
        memcpy(result, array, sizeof array);
        inverse_original(logn, result + off, trial);
        vect_inv_mul2e_fft(logn, array + off, trial);
        if (memcmp(result, array, sizeof array)) {
            printf("FXDIV_FAIL inverse logn=%u trial=%u\n", logn, trial); return 4;
        }
        inverse ++;
    }
    for (unsigned cls = 0; cls < 32; cls ++) {
        for (unsigned i = 0; i < 4; i ++) {
            x[i] = cls < 15 ? edges[cls] : rnd();
            y[i] = cls < 15 ? edges[(cls+5) % 15] : rnd();
        }
        for (unsigned old = 0; old < 2; old ++) {
            uint32_t min = UINT32_MAX, max = 0;
            for (unsigned j = 0; j < 20; j ++) {
                uint32_t t = measure_div(old);
                if (t < min) min = t;
                if (t > max) max = t;
            }
            printf("FXDIV_TIMING class=%u scalar=%u calls=64 lanes=4 min=%u max=%u\n", cls, old, min, max);
        }
    }
    for (unsigned i = 0; i < 1024; i ++) original[i+2] = fxr_of((int32_t)(rnd() % 127) - 63);
    for (unsigned logn = 1; logn <= 10; logn ++) for (unsigned old = 0; old < 2; old ++) {
        uint32_t t = measure_inverse(logn, old);
        printf("FXDIV_INVERSE logn=%u scalar=%u calls=32 total=%u\n", logn, old, t);
    }
    printf("FXDIV_DONE cases=%u values=%u inverse=%u failures=0\n", cases, cases*4, inverse);
    return 0;
}
