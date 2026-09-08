#ifndef FALCON_PROFILE_H
#define FALCON_PROFILE_H

#include <stdint.h>

/*
 * Optional cycle profiler for the Falcon clean implementation.
 *
 * All hooks compile to no-ops unless FALCON_PROFILE is defined.  The normal
 * PQClean build therefore keeps the profiling runtime out of the binary.
 */
#if defined(FALCON_PROFILE)

typedef enum {
    FALCON_PROF_OP_KEYGEN = 0,
    FALCON_PROF_OP_SIGN,
    FALCON_PROF_OP_VERIFY,
    FALCON_PROF_OP_COUNT
} falcon_profile_operation;

typedef enum {
    FALCON_PROF_OTHER = 0,
    FALCON_PROF_RNG,
    FALCON_PROF_CODEC,
    FALCON_PROF_HASH_TO_POINT,
    FALCON_PROF_FFT,
    FALCON_PROF_NTT_Q,
    FALCON_PROF_NTT_MODP,
    FALCON_PROF_KEYGEN_CORE,
    FALCON_PROF_KEY_PREP,
    FALCON_PROF_NTRU,
    FALCON_PROF_CRT,
    FALCON_PROF_TREE,
    FALCON_PROF_SAMPLER,
    FALCON_PROF_GAUSSIAN0,
    FALCON_PROF_BEREXP,
    FALCON_PROF_NORM,
    FALCON_PROF_SIGN_CORE,
    FALCON_PROF_VERIFY_CORE,
    FALCON_PROF_CATEGORY_COUNT
} falcon_profile_category;

/*
 * Raw exclusive-cycle counters.  On a Cortex-M target these remain in RAM so
 * that a debugger can read them without UART or floating-point printf support.
 */
typedef struct {
    uint64_t category_ticks[FALCON_PROF_CATEGORY_COUNT];
    uint64_t total_ticks;
    uint32_t calls;
} falcon_profile_operation_stats;

extern falcon_profile_operation_stats
falcon_profile_stats[FALCON_PROF_OP_COUNT];

void falcon_profile_clock_init(void);
void falcon_profile_reset(void);
void falcon_profile_api_begin(falcon_profile_operation operation);
void falcon_profile_api_end(void);
void falcon_profile_enter(falcon_profile_category category);
void falcon_profile_leave(void);
void falcon_profile_report(void);

#define FALCON_PROF_API_BEGIN(operation) \
    falcon_profile_api_begin((operation))
#define FALCON_PROF_API_END() falcon_profile_api_end()
#define FALCON_PROF_ENTER(category) falcon_profile_enter((category))
#define FALCON_PROF_LEAVE() falcon_profile_leave()

#else

#define FALCON_PROF_API_BEGIN(operation) ((void)0)
#define FALCON_PROF_API_END() ((void)0)
#define FALCON_PROF_ENTER(category) ((void)0)
#define FALCON_PROF_LEAVE() ((void)0)

#endif

#endif
