#ifndef FNDSA_M55_NTRU_PROFILE_H
#define FNDSA_M55_NTRU_PROFILE_H

#include <stdint.h>

enum ntru_phase {
	PHASE_ORCHESTRATION,
	PHASE_DEEPEST,
	PHASE_INTERMEDIATE_D1,
	PHASE_INTERMEDIATE_D2,
	PHASE_INTERMEDIATE_D3,
	PHASE_INTERMEDIATE_D4,
	PHASE_INTERMEDIATE_D5,
	PHASE_INTERMEDIATE_D6,
	PHASE_INTERMEDIATE_D7,
	PHASE_INTERMEDIATE_D8,
	PHASE_INTERMEDIATE_D9,
	PHASE_DEPTH0,
	PHASE_COUNT
};

enum ntru_kernel {
	KERNEL_OTHER,
	KERNEL_MP_NTT,
	KERNEL_MP_INTT,
	KERNEL_TWIDDLE,
	KERNEL_CRT,
	KERNEL_BEZOUT,
	KERNEL_FFT,
	KERNEL_IFFT,
	KERNEL_FXP_SPECTRAL,
	KERNEL_FIXED_CONVERT,
	KERNEL_SUB_NTT,
	KERNEL_SUB_DEPTH1,
	KERNEL_SUB_PLAIN,
	KERNEL_COUNT
};

enum ntru_ntt_direction {
	NTT_FORWARD,
	NTT_INVERSE,
	NTT_DIRECTION_COUNT
};

#define NTT_LOGN_COUNT   11

struct ntru_ntt_logn_scope {
	uint32_t started;
	uint8_t direction;
	uint8_t logn;
	uint8_t entered;
};

struct ntru_profile_stats {
	uint64_t phase_ticks[PHASE_COUNT];
	uint64_t kernel_ticks[KERNEL_COUNT];
	uint64_t total, minimum, maximum;
	uint32_t phase_entries[PHASE_COUNT];
	uint32_t kernel_entries[KERNEL_COUNT];
	uint64_t ntt_logn_ticks[NTT_DIRECTION_COUNT][NTT_LOGN_COUNT];
	uint32_t ntt_logn_entries[NTT_DIRECTION_COUNT][NTT_LOGN_COUNT];
	uint32_t calls;
};

extern struct ntru_profile_stats ntru_profile_stats[2];
extern volatile uint32_t profile_error;

void profile_clock_init(void);
void profile_reset(void);
unsigned profile_ntru_enter(unsigned logn);
void profile_ntru_leave(unsigned *entered);
unsigned profile_phase_enter(unsigned phase);
void profile_phase_leave(unsigned *entered);
unsigned profile_kernel_enter(unsigned kernel);
void profile_kernel_leave(unsigned *entered);
struct ntru_ntt_logn_scope profile_ntt_logn_enter(
	unsigned direction, unsigned logn);
void profile_ntt_logn_leave(struct ntru_ntt_logn_scope *scope);
void profile_report(void);

#define NTRU_PROFILE_SCOPE(logn) \
	unsigned _ntru_profile_scope \
	__attribute__((cleanup(profile_ntru_leave), unused)) \
		= profile_ntru_enter(logn)

#define NTRU_PHASE_SCOPE(phase) \
	unsigned _ntru_phase_scope \
	__attribute__((cleanup(profile_phase_leave), unused)) \
		= profile_phase_enter(phase)

#define NTRU_KERNEL_SCOPE(kernel) \
	unsigned _ntru_kernel_scope \
	__attribute__((cleanup(profile_kernel_leave), unused)) \
		= profile_kernel_enter(kernel)

#define NTRU_NTT_LOGN_SCOPE(direction, logn) \
	struct ntru_ntt_logn_scope _ntru_ntt_logn_scope \
	__attribute__((cleanup(profile_ntt_logn_leave), unused)) \
		= profile_ntt_logn_enter((direction), (logn))

#endif
