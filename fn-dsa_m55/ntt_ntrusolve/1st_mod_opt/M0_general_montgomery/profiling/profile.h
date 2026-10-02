#ifndef FNDSA_PROFILE_H
#define FNDSA_PROFILE_H
#include <stdint.h>

enum fndsa_operation { OP_KEYGEN, OP_SIGN, OP_VERIFY, OP_COUNT };
enum fndsa_category {
    CAT_OTHER, CAT_SHAKE, CAT_CODEC, CAT_HASH_TO_POINT, CAT_MESSAGE_HASH,
    CAT_FFT_FIXED, CAT_FFT_FPR, CAT_NTT_Q, CAT_NTT_MODP, CAT_KEYGEN,
    CAT_KEY_PREP, CAT_NTRU, CAT_CRT, CAT_TREE, CAT_SAMPLER,
    CAT_GAUSSIAN_FG, CAT_GAUSSIAN0, CAT_BEREXP, CAT_NORM,
    CAT_SIGN, CAT_VERIFY, CAT_COUNT
};
struct fndsa_profile_stats {
    uint64_t ticks[CAT_COUNT];
    uint64_t total, minimum, maximum;
    uint32_t entries[CAT_COUNT];
    uint32_t calls;
};
extern struct fndsa_profile_stats fndsa_profile_stats[OP_COUNT];
extern volatile uint32_t fndsa_profile_error;
void profile_clock_init(void);
void profile_reset(void);
void profile_begin(unsigned operation);
void profile_end(void);
unsigned profile_enter(unsigned category);
void profile_leave(unsigned *entered);
void profile_report(void);

#if FNDSA_PROFILE
#define FNDSA_SCOPE(category) \
    unsigned _fndsa_scope __attribute__((cleanup(profile_leave), unused)) \
        = profile_enter(category)
#else
#define FNDSA_SCOPE(category) ((void)0)
#endif
#endif
