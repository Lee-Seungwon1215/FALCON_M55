#ifndef FNDSA_KGEN_FFT_CM55_H__
#define FNDSA_KGEN_FFT_CM55_H__

/* Private C/assembly ABI. Implementations are in this tree's kgen_fft_cm55.s.
 * Transform sizes, memory strides and directions are public. Input-conversion
 * scale offsets can depend on secret coefficients; their handling is masked.
 */
#include "kgen_inner.h"

/* Four double-single butterflies. Component pointers address high words;
 * stride is the byte distance to the corresponding low-word plane.
 * Each root argument contains four high floats followed by four low floats.
 */
void ds32_bfly_fwd4(float *xr, float *xi, float *yr, float *yi,
    const float *root_re, const float *root_im, unsigned stride);
void ds32_bfly_inv4(float *xr, float *xi, float *yr, float *yi,
    const float *root_re, const float *root_im, unsigned stride);
void ds32_bfly_fwd4_span(float *xr, float *xi, float *yr, float *yi,
    const float *root_re, const float *root_im, unsigned stride, unsigned blocks);
void ds32_bfly_inv4_span(float *xr, float *xi, float *yr, float *yi,
    const float *root_re, const float *root_im, unsigned stride, unsigned blocks);

/* Short-span packed butterflies. Root entries keep their 12-byte stride:
 * high float, low float, zero padding. ht is 1 or 2; blocks is positive.
 */
void ds32_tail_fwd4(float *real, float *imag, const void *root_re,
    const void *root_im, unsigned stride, unsigned blocks, unsigned ht);
void ds32_tail_inv4(float *real, float *imag, const void *root_re,
    const void *root_im, unsigned stride, unsigned blocks, unsigned ht);

/* params = {coefficient count, limb count, word offset, bit offset}.
 * Same Q32 window and sign extension as the original poly_big_to_fixed().
 * Word/bit offsets are scale-derived, not assumed public. The assembly scans
 * every input limb; these offsets must not become secret-indexed loads.
 */
void fndsa_fixed_input_mve(fxr *d, const uint32_t *f,
    const uint32_t params[4]);
void fndsa_fxr_div4(fxr a[4], const fxr b[4]);

/* p = {x.real, x.imag, y.real, y.imag}; count is a positive multiple of 4.
 * root is an entry of the original GM_TAB, conjugated for inverse != 0.
 */
void fndsa_ntru_q32_butterfly(fxr *const *p, unsigned count,
    const fxc *root, unsigned inverse);

/* hn >= 8. flags has ht (1 or 2) in its low bits and inverse in bit 2. */
void fndsa_ntru_q32_tail(fxr *f, unsigned hn,
    const fxc *roots, unsigned flags);

#endif
