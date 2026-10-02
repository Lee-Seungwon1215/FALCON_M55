/* Private double-single FFT workspace. Each real/imaginary component is
 * represented by two FP32 values (hi + lo), not two parts of one complex value.
 * The fixed layout is part of the assembly ABI; supported logn is 1..10.
 */
#ifndef FNDSA_KGEN_DS_C_H__
#define FNDSA_KGEN_DS_C_H__
#include "kgen_inner.h"
typedef struct {
    float re[2][512], im[2][512];
} fndsa_ds_poly;
void fndsa_ds_fft(unsigned logn, fndsa_ds_poly *d);
void fndsa_ds_ifft(unsigned logn, fndsa_ds_poly *d);

/* Double interfaces include both conversions and an 8 KiB stack workspace. */
void fndsa_fft_bridge_forward(unsigned logn, double *f);
void fndsa_fft_bridge_inverse(unsigned logn, double *f);
#endif
