#define _POSIX_C_SOURCE 200809L
#include "profile.h"
#include <string.h>
#ifndef FNDSA_PROFILE_CORTEX_M
#include <time.h>
#include <stdio.h>
#include <inttypes.h>
#endif

struct fndsa_profile_stats fndsa_profile_stats[OP_COUNT];
volatile uint32_t fndsa_profile_error;
static unsigned categories[32], depth, operation, category, active;
static uint64_t previous, started;
#ifdef FNDSA_PROFILE_CORTEX_M
static uint32_t last_low;
static uint64_t high;
static uint64_t ticks(void)
{
    uint32_t low = *(volatile uint32_t *)0xE0001004;
    if (low < last_low) high += UINT64_C(1) << 32;
    last_low = low;
    return high | low;
}
void profile_clock_init(void)
{
    *(volatile uint32_t *)0xE000EDFC |= 1u << 24;
#ifdef FNDSA_PROFILE_DWT_UNLOCK
    *(volatile uint32_t *)0xE0001FB0 = 0xC5ACCE55;
#endif
    *(volatile uint32_t *)0xE0001004 = 0;
    *(volatile uint32_t *)0xE0001000 |= 1;
    last_low = 0;
    high = 0;
}
#else
static uint64_t ticks(void)
{
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (uint64_t)ts.tv_sec * 1000000000u + ts.tv_nsec;
}
void profile_clock_init(void) { }
#endif

void profile_reset(void)
{
    memset(fndsa_profile_stats, 0, sizeof fndsa_profile_stats);
    active = depth = 0;
    fndsa_profile_error = 0;
}
void profile_begin(unsigned op)
{
    if (active || op >= OP_COUNT) { fndsa_profile_error |= 1; return; }
    operation = op;
    category = CAT_OTHER;
    depth = 0;
    active = 1;
    previous = started = ticks();
}
unsigned profile_enter(unsigned next)
{
    if (!active) return 0;
    if (depth == 32 || next >= CAT_COUNT) {
        fndsa_profile_error |= 2;
        return 0;
    }
    uint64_t now = ticks();
    fndsa_profile_stats[operation].ticks[category] += now - previous;
    categories[depth++] = category;
    category = next;
    fndsa_profile_stats[operation].entries[next]++;
    previous = now;
    return 1;
}
void profile_leave(unsigned *entered)
{
    if (!*entered) return;
    if (!active || !depth) { fndsa_profile_error |= 4; return; }
    uint64_t now = ticks();
    fndsa_profile_stats[operation].ticks[category] += now - previous;
    category = categories[--depth];
    previous = now;
}
void profile_end(void)
{
    if (!active || depth) { fndsa_profile_error |= 8; return; }
    uint64_t now = ticks(), elapsed = now - started;
    struct fndsa_profile_stats *s = &fndsa_profile_stats[operation];
    s->ticks[category] += now - previous;
    s->total += elapsed;
    if (!s->calls || elapsed < s->minimum) s->minimum = elapsed;
    if (elapsed > s->maximum) s->maximum = elapsed;
    s->calls++;
    active = 0;
    uint64_t sum = 0;
    for (unsigned i = 0; i < CAT_COUNT; i++) sum += s->ticks[i];
    if (sum != s->total) fndsa_profile_error |= 16;
}
void profile_report(void)
{
#ifndef FNDSA_PROFILE_CORTEX_M
    for (unsigned op = 0; op < OP_COUNT; op++) {
        struct fndsa_profile_stats *s = &fndsa_profile_stats[op];
        printf("TOTAL,%u,%u,%" PRIu64 ",%" PRIu64 ",%" PRIu64 "\n",
            op, s->calls, s->total, s->minimum, s->maximum);
        for (unsigned c = 0; c < CAT_COUNT; c++)
            printf("CATEGORY,%u,%u,%" PRIu64 ",%u\n",
                op, c, s->ticks[c], s->entries[c]);
    }
#endif
}
