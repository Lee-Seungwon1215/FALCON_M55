#define _POSIX_C_SOURCE 200809L

#include <stddef.h>
#include <string.h>

#if !defined(FALCON_PROFILE_NO_STDIO)
#include <inttypes.h>
#include <stdio.h>
#endif

#include "falcon_profile.h"

#define PROFILE_STACK_SIZE 16

falcon_profile_operation_stats
falcon_profile_stats[FALCON_PROF_OP_COUNT];
static falcon_profile_category category_stack[PROFILE_STACK_SIZE];
static falcon_profile_operation current_operation;
static falcon_profile_category current_category;
static unsigned stack_depth;
static int profile_active;
static uint64_t last_tick;
static uint64_t operation_start;

#if defined(FALCON_PROFILE_CORTEX_M)

static uint32_t dwt_last;
static uint64_t dwt_high;

static uint64_t
read_ticks(void) {
    uint32_t now = *(volatile uint32_t *)0xE0001004u;

    if (now < dwt_last) {
        dwt_high += (uint64_t)1 << 32;
    }
    dwt_last = now;
    return dwt_high | now;
}

void
falcon_profile_clock_init(void) {
    volatile uint32_t *demcr = (volatile uint32_t *)0xE000EDFCu;
    volatile uint32_t *dwt_ctrl = (volatile uint32_t *)0xE0001000u;
    volatile uint32_t *dwt_cyccnt = (volatile uint32_t *)0xE0001004u;

    *demcr |= (uint32_t)1 << 24;
#if defined(FALCON_PROFILE_DWT_UNLOCK)
    *(volatile uint32_t *)0xE0001FB0u = 0xC5ACCE55u;
#endif
    *dwt_cyccnt = 0;
    *dwt_ctrl |= 1u;
    dwt_last = 0;
    dwt_high = 0;
}

#if !defined(FALCON_PROFILE_NO_STDIO)
static const char *tick_unit = "cycles";
#endif

#else

#include <time.h>

static uint64_t
read_ticks(void) {
    struct timespec ts;

    (void)clock_gettime(CLOCK_MONOTONIC, &ts);
    return (uint64_t)ts.tv_sec * UINT64_C(1000000000)
           + (uint64_t)ts.tv_nsec;
}

void
falcon_profile_clock_init(void) {
}

#if !defined(FALCON_PROFILE_NO_STDIO)
static const char *tick_unit = "ns";
#endif

#endif

void
falcon_profile_reset(void) {
    memset(falcon_profile_stats, 0, sizeof falcon_profile_stats);
    stack_depth = 0;
    profile_active = 0;
}

void
falcon_profile_api_begin(falcon_profile_operation operation) {
    if (profile_active || operation >= FALCON_PROF_OP_COUNT) {
        return;
    }
    current_operation = operation;
    current_category = FALCON_PROF_OTHER;
    stack_depth = 0;
    profile_active = 1;
    last_tick = read_ticks();
    operation_start = last_tick;
}

void
falcon_profile_enter(falcon_profile_category category) {
    uint64_t now;

    if (!profile_active || category >= FALCON_PROF_CATEGORY_COUNT
            || stack_depth >= PROFILE_STACK_SIZE) {
        return;
    }
    now = read_ticks();
    falcon_profile_stats[current_operation].category_ticks[current_category] +=
        now - last_tick;
    category_stack[stack_depth ++] = current_category;
    current_category = category;
    last_tick = now;
}

void
falcon_profile_leave(void) {
    uint64_t now;

    if (!profile_active || stack_depth == 0) {
        return;
    }
    now = read_ticks();
    falcon_profile_stats[current_operation].category_ticks[current_category] +=
        now - last_tick;
    current_category = category_stack[-- stack_depth];
    last_tick = now;
}

void
falcon_profile_api_end(void) {
    uint64_t now;

    if (!profile_active) {
        return;
    }
    now = read_ticks();
    falcon_profile_stats[current_operation].category_ticks[current_category] +=
        now - last_tick;
    falcon_profile_stats[current_operation].total_ticks += now - operation_start;
    falcon_profile_stats[current_operation].calls ++;
    stack_depth = 0;
    profile_active = 0;
}

#if !defined(FALCON_PROFILE_NO_STDIO)

static const char *const operation_names[FALCON_PROF_OP_COUNT] = {
    "Falcon-512 keygen",
    "Falcon-512 sign",
    "Falcon-512 verify"
};

static const char *const category_names[FALCON_PROF_CATEGORY_COUNT] = {
    "other / API glue",
    "RNG + seed SHAKE",
    "key/signature codec",
    "message hash-to-point",
    "FFT + iFFT (software fpr)",
    "q=12289 NTT + iNTT",
    "31-bit RNS NTT + iNTT",
    "keygen screening / other",
    "key completion / preparation",
    "NTRU solver (other)",
    "CRT reconstruction",
    "LDL tree + ffSampling plumbing",
    "sampler arithmetic / PRNG",
    "Gaussian0 sampler",
    "BerExp rejection test",
    "norm + rejection check",
    "sign core (other)",
    "verify core (other)"
};

void
falcon_profile_report(void) {
    unsigned op;

    for (op = 0; op < FALCON_PROF_OP_COUNT; op ++) {
        uint64_t sum = 0;
        unsigned category;

        if (falcon_profile_stats[op].calls == 0) {
            continue;
        }
        printf("\n[%s = 100%%, %" PRIu32 " calls]\n",
               operation_names[op], falcon_profile_stats[op].calls);
        printf("%-34s %16s %9s\n", "exclusive category", tick_unit, "share");
        for (category = 0; category < FALCON_PROF_CATEGORY_COUNT;
                category ++) {
            uint64_t ticks =
                falcon_profile_stats[op].category_ticks[category];
            double share;

            if (ticks == 0) {
                continue;
            }
            sum += ticks;
            share = 100.0 * (double)ticks
                    / (double)falcon_profile_stats[op].total_ticks;
            printf("%-34s %16" PRIu64 " %8.3f%%\n",
                   category_names[category], ticks, share);
        }
        printf("%-34s %16" PRIu64 " %8.3f%%\n",
               "TOTAL", falcon_profile_stats[op].total_ticks, 100.0);
        printf("%-34s %16" PRIu64 "\n", "ticks / call",
               falcon_profile_stats[op].total_ticks
                   / falcon_profile_stats[op].calls);
        if (sum != falcon_profile_stats[op].total_ticks) {
            printf("WARNING: category sum differs from total by %" PRId64
                   " ticks\n",
                   (int64_t)(sum - falcon_profile_stats[op].total_ticks));
        }
    }
}

#else

void
falcon_profile_report(void) {
}

#endif
