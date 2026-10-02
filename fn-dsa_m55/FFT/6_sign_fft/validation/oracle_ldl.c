/* Frozen test-only LDL oracle, extracted before the native LDL edit.
 * Source: Final_code/Before_slothy/sign_fpoly.c
 * SHA-256: 92aded616f3eb7820338ed6f17e93b1aca14ec5c06b2c1ff2cf86f953d0821a0
 * Only the public function name is changed. Not part of the library. */
#include "sign_inner.h"

/* see sign_inner.h */
TARGET_SSE2 TARGET_NEON
void
oracle_LDL_fft(unsigned logn, const fpr *g00, fpr *g01, fpr *g11)
{
	size_t hn = (size_t)1 << (logn - 1);
#if FNDSA_SSE2
	static const union {
		fpr f[2];
		__m128d x;
	} one = { { FPR_ONE, FPR_ONE } };
	__m128d nz = _mm_castsi128_pd(
		_mm_setr_epi32(0, -0x80000000, 0, -0x80000000));
	const double *p00 = (const double *)g00;
	double *p01 = (double *)g01;
	double *p11 = (double *)g11;
	if (hn >= 2) {
		for (size_t i = 0; i < hn; i += 2) {
			__m128d g00_re = _mm_loadu_pd(p00 + i);
			__m128d g01_re = _mm_loadu_pd(p01 + i);
			__m128d g01_im = _mm_loadu_pd(p01 + i + hn);
			__m128d g11_re = _mm_loadu_pd(p11 + i);
			__m128d inv_g00_re = _mm_div_pd(one.x, g00_re);
			__m128d mu_re = _mm_mul_pd(g01_re, inv_g00_re);
			__m128d mu_im = _mm_mul_pd(g01_im, inv_g00_re);
			__m128d zo_re = _mm_add_pd(
				_mm_mul_pd(mu_re, g01_re),
				_mm_mul_pd(mu_im, g01_im));
			_mm_storeu_pd(p11 + i, _mm_sub_pd(g11_re, zo_re));
			_mm_storeu_pd(p01 + i, mu_re);
			_mm_storeu_pd(p01 + i + hn, _mm_xor_pd(nz, mu_im));
		}
	} else {
		__m128d g00_re = _mm_load_sd(p00);
		__m128d g01_re = _mm_load_sd(p01);
		__m128d g01_im = _mm_load_sd(p01 + 1);
		__m128d g11_re = _mm_load_sd(p11);
		__m128d inv_g00_re = _mm_div_sd(one.x, g00_re);
		__m128d mu_re = _mm_mul_sd(g01_re, inv_g00_re);
		__m128d mu_im = _mm_mul_sd(g01_im, inv_g00_re);
		__m128d zo_re = _mm_add_sd(
			_mm_mul_sd(mu_re, g01_re),
			_mm_mul_sd(mu_im, g01_im));
		_mm_store_sd(p11, _mm_sub_sd(g11_re, zo_re));
		_mm_store_sd(p01, mu_re);
		_mm_store_sd(p01 + 1, _mm_xor_pd(nz, mu_im));
	}
#elif FNDSA_NEON
	static const union {
		fpr f[2];
		float64x1_t s;
		float64x2_t x;
	} one = { { FPR_ONE, FPR_ONE } };
	const float64_t *p00 = (const float64_t *)g00;
	float64_t *p01 = (float64_t *)g01;
	float64_t *p11 = (float64_t *)g11;
	if (hn >= 2) {
		for (size_t i = 0; i < hn; i += 2) {
			float64x2_t g00_re = vld1q_f64(p00 + i);
			float64x2_t g01_re = vld1q_f64(p01 + i);
			float64x2_t g01_im = vld1q_f64(p01 + i + hn);
			float64x2_t g11_re = vld1q_f64(p11 + i);
			float64x2_t inv_g00_re = vdivq_f64(one.x, g00_re);
			float64x2_t mu_re = vmulq_f64(g01_re, inv_g00_re);
			float64x2_t mu_im = vmulq_f64(g01_im, inv_g00_re);
			float64x2_t zo_re = vaddq_f64(
				vmulq_f64(mu_re, g01_re),
				vmulq_f64(mu_im, g01_im));
			vst1q_f64(p11 + i, vsubq_f64(g11_re, zo_re));
			vst1q_f64(p01 + i, mu_re);
			vst1q_f64(p01 + i + hn, vnegq_f64(mu_im));
		}
	} else {
		float64x1_t g00_re = vld1_f64(p00);
		float64x1_t g01_re = vld1_f64(p01);
		float64x1_t g01_im = vld1_f64(p01 + 1);
		float64x1_t g11_re = vld1_f64(p11);
		float64x1_t inv_g00_re = vdiv_f64(one.s, g00_re);
		float64x1_t mu_re = vmul_f64(g01_re, inv_g00_re);
		float64x1_t mu_im = vmul_f64(g01_im, inv_g00_re);
		float64x1_t zo_re = vadd_f64(
			vmul_f64(mu_re, g01_re),
			vmul_f64(mu_im, g01_im));
		vst1_f64(p11, vsub_f64(g11_re, zo_re));
		vst1_f64(p01, mu_re);
		vst1_f64(p01 + 1, vneg_f64(mu_im));
	}
#elif FNDSA_RV64D
	const f64 *gg00 = (const f64 *)g00;
	f64 *gg01 = (f64 *)g01;
	f64 *gg11 = (f64 *)g11;
	for (size_t i = 0; i < hn; i ++) {
		f64 g00_re = gg00[i];
		f64 g01_re = gg01[i], g01_im = gg01[i + hn];
		f64 g11_re = gg11[i];
		f64 inv_g00_re = f64_inv(g00_re);
		f64 mu_re = f64_mul(g01_re, inv_g00_re);
		f64 mu_im = f64_mul(g01_im, inv_g00_re);
		f64 zo_re = f64_add(
			f64_mul(mu_re, g01_re),
			f64_mul(mu_im, g01_im));
		gg11[i] = f64_sub(g11_re, zo_re);
		gg01[i] = mu_re;
		gg01[i + hn] = f64_neg(mu_im);
	}
#else
	for (size_t i = 0; i < hn; i ++) {
		fpr g00_re = g00[i];
		fpr g01_re = g01[i], g01_im = g01[i + hn];
		fpr g11_re = g11[i];
		fpr inv_g00_re = fpr_inv(g00_re);
		fpr mu_re = fpr_mul(g01_re, inv_g00_re);
		fpr mu_im = fpr_mul(g01_im, inv_g00_re);
		fpr zo_re = fpr_add(
			fpr_mul(mu_re, g01_re),
			fpr_mul(mu_im, g01_im));
		g11[i] = fpr_sub(g11_re, zo_re);
		g01[i] = mu_re;
		g01[i + hn] = fpr_neg(mu_im);
	}
#endif
}
