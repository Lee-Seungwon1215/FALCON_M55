#ifndef FNDSA_M55_STAGE_PROFILE_H
#define FNDSA_M55_STAGE_PROFILE_H

#include <stdint.h>

enum profile_operation { OP_KEYGEN, OP_SIGN, OP_VERIFY, OP_COUNT };
enum profile_category {
	CAT_OTHER,
	CAT_KG_GENERATE, CAT_KG_CHECK, CAT_KG_NTRU,
	CAT_KG_SK_COMPLETE, CAT_KG_PK_COMPUTE,
	CAT_SG_MESSAGE_HASH, CAT_SG_KEY_PREP, CAT_SG_HASH_TO_POINT,
	CAT_SG_FFT_BASIS, CAT_SG_LDL_FFSAMPLING, CAT_SG_GAUSSIAN_BEREXP,
	CAT_SG_RECON_NORM, CAT_SG_ENCODE,
	CAT_VR_MESSAGE_HASH, CAT_VR_DECODE, CAT_VR_NTT,
	CAT_VR_HASH_TO_POINT, CAT_VR_POLY, CAT_VR_NORM,
	CAT_COUNT
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
