/* Host diagnostic: compare the complete fixed and FP64-boundary orthogonal
 * norm paths, not merely the three isolated kernels. */
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "kgen_inner.h"

static int
ortho_fixed(unsigned logn, const int8_t *f, const int8_t *g, fxr *tmp)
{
	size_t n = (size_t)1 << logn;
	fxr *rt1 = tmp;
	fxr *rt2 = rt1 + n;
	fxr *rt3 = rt2 + n;
	vect_set(logn, rt1, f);
	vect_set(logn, rt2, g);
	vect_FFT_fixed(logn, rt1);
	vect_FFT_fixed(logn, rt2);
	vect_invnorm_fft_fixed(logn, rt3, rt1, rt2, 0);
	vect_adj_fft(logn, rt1);
	vect_adj_fft(logn, rt2);
	vect_mul_realconst(logn, rt1, fxr_of(12289));
	vect_mul_realconst(logn, rt2, fxr_of(12289));
	vect_mul_selfadj_fft(logn, rt1, rt3);
	vect_mul_selfadj_fft(logn, rt2, rt3);
	vect_iFFT_fixed(logn, rt1);
	vect_iFFT_fixed(logn, rt2);
	fxr sn = fxr_zero;
	for (size_t i = 0; i < n; i ++) {
		sn = fxr_add(sn, fxr_add(fxr_sqr(rt1[i]), fxr_sqr(rt2[i])));
	}
	return fxr_lt(sn, fxr_of_scaled32(UINT64_C(72107278641426)));
}

static int
ortho_fp64(unsigned logn, const int8_t *f, const int8_t *g, fxr *tmp)
{
	size_t n = (size_t)1 << logn;
	fxr *rt1 = tmp;
	fxr *rt2 = rt1 + n;
	fxr *rt3 = rt2 + n;
	vect_set(logn, rt1, f);
	vect_set(logn, rt2, g);
	vect_fxr_to_fp64_inplace(logn, rt1);
	vect_fxr_to_fp64_inplace(logn, rt2);
	vect_FFT(logn, (double *)rt1);
	vect_FFT(logn, (double *)rt2);
	vect_invnorm_fft(logn, (double *)rt3,
		(const double *)rt1, (const double *)rt2, 0);
	vect_fp64_to_fxr_inplace(logn, rt1);
	vect_fp64_to_fxr_inplace(logn, rt2);
	vect_fp64_to_fxr_inplace(logn - 1, rt3);
	memset(rt3 + (n >> 1), 0, (n >> 1) * sizeof *rt3);
	vect_adj_fft(logn, rt1);
	vect_adj_fft(logn, rt2);
	vect_mul_realconst(logn, rt1, fxr_of(12289));
	vect_mul_realconst(logn, rt2, fxr_of(12289));
	vect_mul_selfadj_fft(logn, rt1, rt3);
	vect_mul_selfadj_fft(logn, rt2, rt3);
	vect_fxr_to_fp64_inplace(logn, rt1);
	vect_fxr_to_fp64_inplace(logn, rt2);
	vect_iFFT(logn, (double *)rt1);
	vect_iFFT(logn, (double *)rt2);
	vect_fp64_to_fxr_inplace(logn, rt1);
	vect_fp64_to_fxr_inplace(logn, rt2);
	fxr sn = fxr_zero;
	for (size_t i = 0; i < n; i ++) {
		sn = fxr_add(sn, fxr_add(fxr_sqr(rt1[i]), fxr_sqr(rt2[i])));
	}
	return fxr_lt(sn, fxr_of_scaled32(UINT64_C(72107278641426)));
}

int
main(void)
{
	static int8_t f[1024], g[1024];
	static fxr t0[3 * 1024], t1[3 * 1024];
	uint32_t s = 1;
	unsigned mismatch = 0, pass0 = 0, pass1 = 0;
	for (unsigned logn = 8; logn <= 10; logn ++) {
		size_t n = (size_t)1 << logn;
		for (unsigned r = 0; r < 1000; r ++) {
			for (size_t i = 0; i < n; i ++) {
				s = s * 1664525u + 1013904223u;
				f[i] = (int8_t)((s >> 24) % 25) - 12;
				s = s * 1664525u + 1013904223u;
				g[i] = (int8_t)((s >> 24) % 25) - 12;
			}
			int a = ortho_fixed(logn, f, g, t0);
			int b = ortho_fp64(logn, f, g, t1);
			pass0 += a;
			pass1 += b;
			if (a != b && mismatch ++ < 8) {
				printf("ORTHO_MISMATCH logn=%u round=%u fixed=%d fp64=%d\n",
					logn, r, a, b);
			}
		}
	}
	printf("ORTHO_DONE mismatch=%u fixed_pass=%u fp64_pass=%u\n",
		mismatch, pass0, pass1);
	return mismatch != 0;
}
