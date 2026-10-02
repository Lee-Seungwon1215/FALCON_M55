#ifndef FNDSA_NTT_AUX_PROFILE_H
#define FNDSA_NTT_AUX_PROFILE_H
#include <stdint.h>

enum profile_operation { OP_KEYGEN, OP_SIGN, OP_VERIFY, OP_COUNT };
enum profile_category {
    CAT_OTHER, CAT_NTRU_REST, CAT_TABLE_GM, CAT_TABLE_IGM, CAT_TABLE_BOTH,
    CAT_MQ_MUL, CAT_MQ_DIV, CAT_RNS_DESCENT, CAT_RNS_LIFTING,
    CAT_RNS_DEPTH0_BABAI, CAT_RNS_DEPTH0_RECOVER,
    CAT_RNS_SCALED_SUB, CAT_RNS_DEPTH1_SUB, CAT_COUNT
};
struct profile_stats {
    uint64_t ticks[CAT_COUNT];
    uint64_t total, minimum, maximum;
    uint32_t entries[CAT_COUNT];
    uint32_t calls;
};
extern struct profile_stats profile_stats[2][OP_COUNT];
extern volatile uint32_t profile_error;
void profile_clock_init(void);
void profile_reset(void);
void profile_begin(unsigned degree_index, unsigned operation);
void profile_switch(unsigned category);
void profile_end(void);
unsigned profile_enter(unsigned category);
void profile_leave(unsigned *entered);
void profile_report(void);
#define FNDSA_SCOPE(category) \
    unsigned _fndsa_scope __attribute__((cleanup(profile_leave), unused)) \
        = profile_enter(category)
#endif
