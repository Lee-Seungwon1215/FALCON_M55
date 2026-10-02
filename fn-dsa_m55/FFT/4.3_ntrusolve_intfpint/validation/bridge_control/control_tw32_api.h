#ifndef FNDSA_TW_COMPARE_API_H
#define FNDSA_TW_COMPARE_API_H

#include <stddef.h>
#include <stdint.h>

#define TW32_NMAX 1024

typedef struct {
	float v[3];
} control_tw32;

/* Falcon stores hn real values followed by hn imaginary values. */
typedef struct {
	float re[3][TW32_NMAX / 2];
	float im[3][TW32_NMAX / 2];
} control_tw32_fft;

void ref_fft_q32(unsigned logn, uint64_t *f);
void ref_ifft_q32(unsigned logn, uint64_t *f);
void ref_fft_fp64(unsigned logn, double *f);
void ref_ifft_fp64(unsigned logn, double *f);

void control_tw32_from_q32(unsigned logn, control_tw32_fft *d, const uint64_t *s);
void control_tw32_to_q32(unsigned logn, uint64_t *d, const control_tw32_fft *s);
void control_tw32_init_twiddles(void);
void control_tw32_fft_scalar(unsigned logn, control_tw32_fft *f);
void control_tw32_ifft_scalar(unsigned logn, control_tw32_fft *f);
void control_tw32_fft_mve(unsigned logn, control_tw32_fft *f);
void control_tw32_ifft_mve(unsigned logn, control_tw32_fft *f);
void control_ds32_fft_mve(unsigned logn, control_tw32_fft *f);
void control_ds32_ifft_mve(unsigned logn, control_tw32_fft *f);
/* ht=1/2 only, blocks>=1. Roots are tw_fpr triples, not splatted ds4. */
void control_ds32_tail_fwd4(float *re, float *im, const void *sr, const void *si,
	unsigned stride, unsigned blocks, unsigned ht);
void control_ds32_tail_inv4(float *re, float *im, const void *sr, const void *si,
	unsigned stride, unsigned blocks, unsigned ht);

extern const uint64_t control_tw_gm_q32[1024][2];

/* Four-lane error-free FP32 primitives implemented in MVE assembly. */
void control_tw32_two_sum4(const float *a, const float *b, float *s, float *e);
void control_tw32_two_prod4(const float *a, const float *b, float *p, float *e);
void control_tw32_add4_full(float *d, const float *a, const float *b);
void control_tw32_sub4_full(float *d, const float *a, const float *b);
void control_tw32_addsub4_full(float *sum, float *diff,
	const float *a, const float *b);
void control_tw32_mul4_full(float *d, const float *a, const float *b);
void control_tw32_cmul4_full(float *rr, float *ri,
	const float *ar, const float *ai,
	const float *br, const float *bi);
void control_tw32_bfly_fwd4(float *xr, float *xi, float *yr, float *yi,
	const float *sr, const float *si);
void control_tw32_bfly_inv4(float *xr, float *xi, float *yr, float *yi,
	const float *sr, const float *si);
void control_ds32_bfly_fwd4(float *xr, float *xi, float *yr, float *yi,
	const float *sr, const float *si, unsigned stride);
void control_ds32_bfly_inv4(float *xr, float *xi, float *yr, float *yi,
	const float *sr, const float *si, unsigned stride);
void control_ds32_bfly_fwd4_span(float *xr, float *xi, float *yr, float *yi,
	const float *sr, const float *si, unsigned stride, unsigned blocks);
void control_ds32_bfly_inv4_span(float *xr, float *xi, float *yr, float *yi,
	const float *sr, const float *si, unsigned stride, unsigned blocks);
void control_tw32_debug_add4(float d[3][4], const float a[3][4],
	const float b[3][4]);
void control_tw32_debug_mul4(float d[3][4], const float a[3][4],
	const float b[3][4]);
void control_tw32_debug_cmul4(float dr[3][4], float di[3][4],
	const float ar[3][4], const float ai[3][4],
	const float br[3][4], const float bi[3][4]);

#endif
