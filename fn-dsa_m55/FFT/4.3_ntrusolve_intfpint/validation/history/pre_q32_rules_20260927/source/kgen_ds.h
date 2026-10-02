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
void fndsa_ds_div_real(unsigned logn, fndsa_ds_poly *d,
    const fndsa_ds_poly *b);
int fndsa_ds_to_k(unsigned logn, int32_t *d, const fndsa_ds_poly *s);
#endif
