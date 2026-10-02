/* Bitwise differential and timing tests against the unchanged stage-7 spans.
 * This file belongs only to the comparison executable, not the FN-DSA build.
 */
#include "api.h"
#include <cmsis_core.h>
#include <inttypes.h>
#include <stdio.h>
#include <string.h>

typedef void (*span_fn)(float *, float *, float *, float *,
    const float *, const float *, unsigned, unsigned);
extern void ds32_stage7_fwd4_span(float *, float *, float *, float *,
    const float *, const float *, unsigned, unsigned);
extern void ds32_stage7_inv4_span(float *, float *, float *, float *,
    const float *, const float *, unsigned, unsigned);
extern void ds32_stage8_fwd4_span(float *, float *, float *, float *,
    const float *, const float *, unsigned, unsigned);
extern void ds32_stage8_inv4_span(float *, float *, float *, float *,
    const float *, const float *, unsigned, unsigned);

static uint32_t state = UINT32_C(0x390ACE51);
static uint32_t next32(void)
{
    state ^= state << 13;
    state ^= state >> 17;
    state ^= state << 5;
    return state;
}

static void roots(float sr[2][4], float si[2][4], unsigned index,
    unsigned inverse)
{
    for (unsigned part = 0; part < 2; part ++) {
        double x = (double)(int64_t)tw_gm_q32[index][part] * 0x1p-32;
        if (part && inverse) x = -x;
        float hi = (float)x, lo = (float)(x - (double)hi);
        float (*p)[4] = part ? si : sr;
        for (unsigned lane = 0; lane < 4; lane ++) {
            p[0][lane] = hi;
            p[1][lane] = lo;
        }
    }
}

static void fill(tw32_fft *f, unsigned cls)
{
    /* Untouched planes and out-of-span coefficients serve as sentinels. */
    memset(f, 0x5a, sizeof *f);
    for (unsigned part = 0; part < 2; part ++) {
        float (*p)[TW32_NMAX / 2] = part ? f->im : f->re;
        for (unsigned j = 0; j < TW32_NMAX / 2; j ++) {
            double x = (double)(int32_t)next32() * 0x1p-8
                + (double)(int32_t)next32() * 0x1p-32;
            if (cls == 0) x = (j & 1) ? -0.0 : 0.0;
            if (cls == 1) x *= 0x1p-24;
            if (cls == 2 && j >= 256) {
                p[0][j] = p[0][j - 256];
                p[1][j] = p[1][j - 256];
            } else if (cls == 3 && j >= 256) {
                p[0][j] = -p[0][j - 256];
                p[1][j] = -p[1][j - 256];
            } else {
                p[0][j] = (float)x;
                p[1][j] = (float)(x - (double)p[0][j]);
            }
        }
    }
}

static void invoke(span_fn fn, tw32_fft *f, unsigned offset,
    unsigned blocks, const float *sr, const float *si)
{
    fn(f->re[0] + offset, f->im[0] + offset,
       f->re[0] + 256 + offset, f->im[0] + 256 + offset,
       sr, si, sizeof f->re[0], blocks);
}

static uint32_t timed(span_fn fn, tw32_fft *f, unsigned blocks,
    const float *sr, const float *si)
{
    uint32_t mask = __get_PRIMASK();
    __disable_irq();
    __DSB(); __ISB();
    uint32_t start = DWT->CYCCNT;
    invoke(fn, f, 0, blocks, sr, si);
    __DSB(); __ISB();
    uint32_t elapsed = DWT->CYCCNT - start;
    if (!mask) __enable_irq();
    return elapsed;
}

unsigned ds32_span_check(tw32_fft *candidate, tw32_fft *baseline)
{
    static const unsigned blocks_list[] = {1, 2, 3, 4, 8, 16, 32, 64};
    static const unsigned offsets[] = {0, 1, 3};
    span_fn old_fn[] = {ds32_stage7_fwd4_span, ds32_stage7_inv4_span};
    span_fn new_fn[] = {ds32_bfly_fwd4_span, ds32_bfly_inv4_span};
    span_fn direct_fn[] = {ds32_stage8_fwd4_span, ds32_stage8_inv4_span};
    unsigned cases = 0, mismatches = 0;
    for (unsigned dir = 0; dir < 2; dir ++) {
        for (unsigned b = 0; b < sizeof blocks_list / sizeof *blocks_list; b ++) {
            unsigned blocks = blocks_list[b];
            for (unsigned o = 0; o < sizeof offsets / sizeof *offsets; o ++) {
                unsigned offset = offsets[o];
                if (offset + 4 * blocks > 256) continue;
                for (unsigned r = 0; r < 32; r ++) {
                    float sr[2][4] __attribute__((aligned(16)));
                    float si[2][4] __attribute__((aligned(16)));
                    roots(sr, si, 2 + next32() % 1022, dir);
                    fill(candidate, r % 8);
                    memcpy(baseline, candidate, sizeof *baseline);
                    invoke(old_fn[dir], baseline, offset, blocks, sr[0], si[0]);
                    invoke(new_fn[dir], candidate, offset, blocks, sr[0], si[0]);
                    mismatches += memcmp(candidate, baseline, sizeof *baseline) != 0;
                    cases ++;
                }
            }
        }
    }
    printf("DS_SPAN_EQ cases=%u mismatches=%u comparison=ALL_BYTES\n",
        cases, mismatches);
    /* Input refresh is outside the timed region; alternate AB/BA order. */
    for (unsigned dir = 0; dir < 2; dir ++) {
        for (unsigned blocks = 1; blocks <= 64; blocks *= 8) {
            uint64_t sums[3] = {0, 0, 0};
            uint32_t low[3] = {UINT32_MAX, UINT32_MAX, UINT32_MAX}, high[3] = {0, 0, 0};
            float sr[2][4] __attribute__((aligned(16)));
            float si[2][4] __attribute__((aligned(16)));
            roots(sr, si, 2, dir);
            for (unsigned i = 0; i < 110; i ++) {
                fill(candidate, 4);
                for (unsigned pos = 0; pos < 3; pos ++) {
                    unsigned which = (i & 1) ? 2 - pos : pos;
                    memcpy(baseline, candidate, sizeof *baseline);
                    span_fn fn = which == 0 ? old_fn[dir]
                        : which == 1 ? direct_fn[dir] : new_fn[dir];
                    uint32_t cycles = timed(fn, baseline, blocks, sr[0], si[0]);
                    if (i < 10) continue;
                    sums[which] += cycles;
                    if (cycles < low[which]) low[which] = cycles;
                    if (cycles > high[which]) high[which] = cycles;
                }
            }
            printf("DS_SPAN_PERF dir=%s blocks=%u calls=100 old_sum=%" PRIu64
                " direct_sum=%" PRIu64 " new_sum=%" PRIu64
                " old_min=%u old_max=%u direct_min=%u direct_max=%u new_min=%u new_max=%u\n",
                dir ? "ifft" : "fft", blocks, sums[0], sums[1], sums[2],
                low[0], high[0], low[1], high[1], low[2], high[2]);
        }
    }
    return mismatches;
}
