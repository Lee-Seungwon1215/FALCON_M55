#include "profile.h"
#include <stddef.h>
#include <stdint.h>

#define WRAP_BEGIN(cat) unsigned entered = profile_enter(cat)
#define WRAP_END() profile_leave(&entered)

size_t __real_fndsa_mqpoly_decode(unsigned, const uint8_t *, uint16_t *);
size_t __wrap_fndsa_mqpoly_decode(unsigned logn, const uint8_t *d, uint16_t *h)
{
    WRAP_BEGIN(CAT_CODEC); size_t r = __real_fndsa_mqpoly_decode(logn, d, h); WRAP_END(); return r;
}
int __real_fndsa_comp_decode(unsigned, const uint8_t *, size_t, int16_t *);
int __wrap_fndsa_comp_decode(unsigned logn, const uint8_t *d, size_t len, int16_t *s)
{
    WRAP_BEGIN(CAT_CODEC); int r = __real_fndsa_comp_decode(logn, d, len, s); WRAP_END(); return r;
}
void __real_fndsa_sha3_process_block(uint64_t *, unsigned);
void __wrap_fndsa_sha3_process_block(uint64_t *state, unsigned rate)
{
    WRAP_BEGIN(CAT_SHAKE); __real_fndsa_sha3_process_block(state, rate); WRAP_END();
}
void __real_fndsa_mqpoly_int_to_ntt(unsigned, uint16_t *);
void __wrap_fndsa_mqpoly_int_to_ntt(unsigned logn, uint16_t *d)
{
    WRAP_BEGIN(CAT_NTT_Q); __real_fndsa_mqpoly_int_to_ntt(logn, d); WRAP_END();
}
void __real_fndsa_mqpoly_ntt_to_int(unsigned, uint16_t *);
void __wrap_fndsa_mqpoly_ntt_to_int(unsigned logn, uint16_t *d)
{
    WRAP_BEGIN(CAT_NTT_Q); __real_fndsa_mqpoly_ntt_to_int(logn, d); WRAP_END();
}
uint32_t __real_fndsa_mqpoly_sqnorm_binf_int(unsigned, const uint16_t *);
uint32_t __wrap_fndsa_mqpoly_sqnorm_binf_int(unsigned logn, const uint16_t *a)
{
    WRAP_BEGIN(CAT_NORM); uint32_t r = __real_fndsa_mqpoly_sqnorm_binf_int(logn, a); WRAP_END(); return r;
}
uint32_t __real_fndsa_mqpoly_sqnorm_int_to_signed(unsigned, uint16_t *);
uint32_t __wrap_fndsa_mqpoly_sqnorm_int_to_signed(unsigned logn, uint16_t *a)
{
    WRAP_BEGIN(CAT_NORM); uint32_t r = __real_fndsa_mqpoly_sqnorm_int_to_signed(logn, a); WRAP_END(); return r;
}
uint32_t __real_fndsa_mqpoly_sqnorm_signed(unsigned, const uint16_t *);
uint32_t __wrap_fndsa_mqpoly_sqnorm_signed(unsigned logn, const uint16_t *a)
{
    WRAP_BEGIN(CAT_NORM); uint32_t r = __real_fndsa_mqpoly_sqnorm_signed(logn, a); WRAP_END(); return r;
}
int32_t __real_fndsa_gaussian0_helper(uint64_t, uint32_t);
int32_t __wrap_fndsa_gaussian0_helper(uint64_t lo, uint32_t hi)
{
    WRAP_BEGIN(CAT_GAUSSIAN0); int32_t r = __real_fndsa_gaussian0_helper(lo, hi); WRAP_END(); return r;
}
