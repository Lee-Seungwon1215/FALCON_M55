/* Independent candidate C: continuous double-single NTRU approximation.
 * hi/lo are two FP32 components of EACH real or imaginary number.
 * They are not the real and imaginary parts of one scalar.
 */
#ifndef FNDSA_KGEN_DS_C_H__
#define FNDSA_KGEN_DS_C_H__
#include "kgen_inner.h"
typedef struct {
    float re[2][512], im[2][512];
} fndsa_ds_poly;
void fndsa_ds_from_big(unsigned logn, fndsa_ds_poly *d,
    const uint32_t *f, size_t len, uint32_t sc);
void fndsa_ds_from_i32(unsigned logn, fndsa_ds_poly *d,
    const uint32_t *f, unsigned sc);
void fndsa_ds_fft(unsigned logn, fndsa_ds_poly *d);
void fndsa_ds_ifft(unsigned logn, fndsa_ds_poly *d);
void fndsa_ds_inverse(unsigned logn, fndsa_ds_poly *d, unsigned e);
void fndsa_ds_mul(unsigned logn, fndsa_ds_poly *d, const fndsa_ds_poly *b);
/* Immutable multiplier cache, logn=3..10, exactly 2*(1<<logn) words.
 * Each four-complex tile stores four lanes of real-high, real-low,
 * imaginary-high, imaginary-low Q32 words, in that order. Decode the
 * represented DS values (not the values before DS encoding). Cache must
 * be disjoint from d and remains unchanged by mul_cached. */
void fndsa_ds_prepare_mul(unsigned logn, uint32_t *cache,
    const fndsa_ds_poly *b);
void fndsa_ds_mul_cached(unsigned logn, fndsa_ds_poly *d,
    const uint32_t *cache);
void fndsa_ds_div_real(unsigned logn, fndsa_ds_poly *d,
    const fndsa_ds_poly *b);
int fndsa_ds_to_k(unsigned logn, int32_t *d, const fndsa_ds_poly *s);
#endif
