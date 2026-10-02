#include "profile.h"
#include <stdio.h>
#include <string.h>

struct stats {
    uint64_t cycles[CAT_COUNT], inclusive[CAT_COUNT];
    uint32_t entries[CAT_COUNT], children[CAT_COUNT];
    uint64_t total, minimum, maximum;
    uint32_t calls;
};
static struct stats all[2][OP_COUNT];
static struct { unsigned parent, category; uint64_t start; } stack[16];
static unsigned active, depth, degree, operation, current;
static uint64_t previous, started, high;
static uint32_t last;
volatile uint32_t profile_error;

static uint64_t ticks(void)
{
    uint32_t lo = *(volatile uint32_t *)0xE0001004;
    if (lo < last) high += UINT64_C(1) << 32;
    last = lo;
    return high | lo;
}
void profile_clock_init(void)
{
    *(volatile uint32_t *)0xE000EDFC |= 1u << 24;
    *(volatile uint32_t *)0xE0001FB0 = 0xC5ACCE55;
    *(volatile uint32_t *)0xE0001004 = 0;
    *(volatile uint32_t *)0xE0001000 |= 1;
    high = last = 0;
}
void profile_reset(void)
{
    memset(all, 0, sizeof all);
    active = depth = profile_error = 0;
}
void profile_begin(unsigned d, unsigned op)
{
    if (active || d >= 2 || op >= OP_COUNT) { profile_error |= 1; return; }
    degree = d; operation = op; current = depth = 0; active = 1;
    previous = started = ticks();
}
void profile_enter(unsigned category)
{
    if (!active) return;
    uint64_t now = ticks();
    if (depth == 16 || category == 0 || category >= CAT_COUNT) { profile_error |= 2; return; }
    struct stats *s = &all[degree][operation];
    s->cycles[current] += now - previous;
    s->children[current]++;
    s->entries[category]++;
    stack[depth].parent = current;
    stack[depth].category = category;
    stack[depth++].start = now;
    current = category; previous = now;
}
void profile_leave(unsigned category)
{
    if (!active) return;
    uint64_t now = ticks();
    if (!depth || stack[depth-1].category != category) { profile_error |= 4; return; }
    struct stats *s = &all[degree][operation];
    s->cycles[current] += now - previous;
    --depth;
    s->inclusive[category] += now - stack[depth].start;
    current = stack[depth].parent; previous = now;
}
void profile_end(void)
{
    if (!active || depth) { profile_error |= 8; return; }
    uint64_t now = ticks(), elapsed = now - started;
    struct stats *s = &all[degree][operation];
    s->cycles[current] += now - previous;
    s->total += elapsed;
    if (!s->calls || elapsed < s->minimum) s->minimum = elapsed;
    if (elapsed > s->maximum) s->maximum = elapsed;
    s->calls++; active = 0;
    uint64_t sum = 0;
    for (unsigned c=0; c<CAT_COUNT; c++) sum += s->cycles[c];
    if (sum != s->total) profile_error |= 16;
}
extern void profile_empty(void);
extern void profile_raw_empty(void);
void profile_calibrate(void)
{
    const unsigned runs = 2000;
    profile_reset();
    for (unsigned i=0; i<runs; i++) {
        profile_begin(0, OP_VERIFY); profile_empty(); profile_end();
    }
    uint64_t total = all[0][OP_VERIFY].total, self = all[0][OP_VERIFY].cycles[1];
    profile_reset();
    for (unsigned i=0; i<runs; i++) {
        profile_begin(0, OP_VERIFY); profile_raw_empty(); profile_end();
    }
    printf("PROBE_CALIBRATION runs=%u empty_total=%llu empty_self=%llu raw_total=%llu\n",
        runs, (unsigned long long)total, (unsigned long long)self,
        (unsigned long long)all[0][OP_VERIFY].total);
}
static const char *names[CAT_COUNT] = {
    "other", "shake_init", "shake_inject", "shake_flip", "shake_extract",
    "sha3_init", "sha3_update", "sha3_close", "process_block", "inject_chunk",
    "bit_split_1", "bit_split_2", "bit_split_3", "bit_split_4", "bit_split_5",
    "bit_merge_1", "bit_merge_2", "bit_merge_3", "bit_merge_4", "bit_merge_5"
};
void profile_report(void)
{
    static const char *ops[] = {"keygen", "sign", "verify"};
    for (unsigned d=0; d<2; d++) for (unsigned op=0; op<OP_COUNT; op++) {
        struct stats *s = &all[d][op];
        printf("PROFILE_TOTAL degree=%u operation=%s calls=%u total=%llu min=%llu max=%llu\n",
            512u << d, ops[op], s->calls, (unsigned long long)s->total,
            (unsigned long long)s->minimum, (unsigned long long)s->maximum);
        for (unsigned c=0; c<CAT_COUNT; c++)
            printf("PROFILE_CATEGORY degree=%u operation=%s category=%s cycles=%llu entries=%u inclusive=%llu children=%u\n",
                512u << d, ops[op], names[c], (unsigned long long)s->cycles[c],
                s->entries[c], (unsigned long long)s->inclusive[c], s->children[c]);
    }
}
