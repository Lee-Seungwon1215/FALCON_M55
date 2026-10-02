#ifndef FNDSA_TW_COMPARE_API_H
#define FNDSA_TW_COMPARE_API_H

#include <stddef.h>
#include <stdint.h>

#define TW32_NMAX 1024

typedef struct {
	float v[3];
} tw32;

/* Falcon stores hn real values followed by hn imaginary values. */
typedef struct {
	float re[3][TW32_NMAX / 2];
	float im[3][TW32_NMAX / 2];
} tw32_fft;

void ref_fft_q32(unsigned logn, uint64_t *f);
void ref_ifft_q32(unsigned logn, uint64_t *f);
void ref_fft_fp64(unsigned logn, double *f);
void ref_ifft_fp64(unsigned logn, double *f);

void tw32_from_q32(unsigned logn, tw32_fft *d, const uint64_t *s);
void tw32_to_q32(unsigned logn, uint64_t *d, const tw32_fft *s);
void tw32_init_twiddles(void);
void tw32_fft_scalar(unsigned logn, tw32_fft *f);
void tw32_ifft_scalar(unsigned logn, tw32_fft *f);
void tw32_fft_mve(unsigned logn, tw32_fft *f);
void tw32_ifft_mve(unsigned logn, tw32_fft *f);
void ds32_fft_mve(unsigned logn, tw32_fft *f);
void ds32_ifft_mve(unsigned logn, tw32_fft *f);
/* ht=1/2 only, blocks>=1. Roots are tw_fpr triples, not splatted ds4. */
void ds32_tail_fwd4(float *re, float *im, const void *sr, const void *si,
	unsigned stride, unsigned blocks, unsigned ht);
void ds32_tail_inv4(float *re, float *im, const void *sr, const void *si,
	unsigned stride, unsigned blocks, unsigned ht);

extern const uint64_t tw_gm_q32[1024][2];

/* Four-lane error-free FP32 primitives implemented in MVE assembly. */
void tw32_two_sum4(const float *a, const float *b, float *s, float *e);
void tw32_two_prod4(const float *a, const float *b, float *p, float *e);
void tw32_add4_full(float *d, const float *a, const float *b);
void tw32_sub4_full(float *d, const float *a, const float *b);
void tw32_addsub4_full(float *sum, float *diff,
	const float *a, const float *b);
void tw32_mul4_full(float *d, const float *a, const float *b);
void tw32_cmul4_full(float *rr, float *ri,
	const float *ar, const float *ai,
	const float *br, const float *bi);
void tw32_bfly_fwd4(float *xr, float *xi, float *yr, float *yi,
	const float *sr, const float *si);
void tw32_bfly_inv4(float *xr, float *xi, float *yr, float *yi,
	const float *sr, const float *si);
void ds32_bfly_fwd4(float *xr, float *xi, float *yr, float *yi,
	const float *sr, const float *si, unsigned stride);
void ds32_bfly_inv4(float *xr, float *xi, float *yr, float *yi,
	const float *sr, const float *si, unsigned stride);
void ds32_bfly_fwd4_span(float *xr, float *xi, float *yr, float *yi,
	const float *sr, const float *si, unsigned stride, unsigned blocks);
void ds32_bfly_inv4_span(float *xr, float *xi, float *yr, float *yi,
	const float *sr, const float *si, unsigned stride, unsigned blocks);
void tw32_debug_add4(float d[3][4], const float a[3][4],
	const float b[3][4]);
void tw32_debug_mul4(float d[3][4], const float a[3][4],
	const float b[3][4]);
void tw32_debug_cmul4(float dr[3][4], float di[3][4],
	const float ar[3][4], const float ai[3][4],
	const float br[3][4], const float bi[3][4]);

#endif
