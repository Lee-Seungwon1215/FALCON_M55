/* Measurement only: preserve the existing local assembly multiplication. */
#include "profile.h"
#include <stdint.h>

void __real_fndsa_mqpoly_mul_ntt(unsigned logn, uint16_t *a, const uint16_t *b);
void
__wrap_fndsa_mqpoly_mul_ntt(unsigned logn, uint16_t *a, const uint16_t *b)
{
    FNDSA_SCOPE(CAT_MQ_MUL);
    __real_fndsa_mqpoly_mul_ntt(logn, a, b);
}
