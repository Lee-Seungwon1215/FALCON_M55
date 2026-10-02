#pragma once
#include <stdint.h>
#include <stddef.h>
typedef struct { uint32_t p, p0i, R2, g, ig, s; } small_prime;
extern const small_prime PRIMES[];
void mp_mkgmigm(unsigned, uint32_t *, uint32_t *, uint32_t, uint32_t, uint32_t, uint32_t);
void mp_mkigm_full(unsigned, uint32_t *, const uint32_t *, uint32_t);
typedef void (*mq_fn)(unsigned, uint16_t *);
typedef void (*mp_fn)(unsigned, uint32_t *, const uint32_t *, uint32_t, uint32_t);
void orig_mqpoly_int_to_ntt(unsigned, uint16_t *);
void orig_mqpoly_ntt_to_int(unsigned, uint16_t *);
void opt_mqpoly_int_to_ntt(unsigned, uint16_t *);
void opt_mqpoly_ntt_to_int(unsigned, uint16_t *);
void orig_mp_NTT(unsigned, uint32_t *, const uint32_t *, uint32_t, uint32_t);
void orig_mp_iNTT(unsigned, uint32_t *, const uint32_t *, uint32_t, uint32_t);
void opt_mp_NTT(unsigned, uint32_t *, const uint32_t *, uint32_t, uint32_t);
void opt_mp_iNTT(unsigned, uint32_t *, const uint32_t *, uint32_t, uint32_t);
void opt_mp_NTT_c(unsigned, uint32_t *, const uint32_t *, uint32_t, uint32_t);
void opt_mp_iNTT_c(unsigned, uint32_t *, const uint32_t *, uint32_t, uint32_t);
extern const uint16_t orig_mq_GM[], orig_mq_iGM[], opt_mq_GM[], opt_mq_iGM[];
