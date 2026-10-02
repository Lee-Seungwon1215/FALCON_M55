#include "sign_inner.h"
extern const fpr fndsa_sign_gm[];
/* Frozen original emulated functions. */
/* see sign_inner.h */
TARGET_SSE2 TARGET_NEON
void
oracle_split_fft(unsigned logn, fpr *f0, fpr *f1, const fpr *f)
{
	size_t hn = (size_t)1 << (logn - 1);
	size_t qn = hn >> 1;

	if (logn == 1) {
		f0[0] = f[0];
		f1[0] = f[hn];
	}

#if FNDSA_SSE2
	static union {
		fpr f[2];
		__m128d x;
	} h = { {
		FPR(4503599627370496, -53), FPR(4503599627370496, -53)
	} };
	const double *ff = (const double *)f;
	double *ff0 = (double *)f0;
	double *ff1 = (double *)f1;
	__m128d cz = _mm_castsi128_pd(_mm_setr_epi32(0, 0, 0, -0x80000000));
	for (size_t i = 0; i < qn; i ++) {
		__m128d ab_re = _mm_loadu_pd(ff + (i << 1));
		__m128d ab_im = _mm_loadu_pd(ff + (i << 1) + hn);
		__m128d a = _mm_shuffle_pd(ab_re, ab_im, 0);
		__m128d b = _mm_shuffle_pd(ab_re, ab_im, 3);
		__m128d u = _mm_add_pd(a, b);
		__m128d v = _mm_sub_pd(a, b);
		__m128d s = _mm_loadu_pd((const double *)fndsa_sign_gm + ((i + hn) << 1));
		__m128d sc = _mm_xor_pd(s, cz);
		/* We compute w = v*conj(s) */
		__m128d w1 = _mm_mul_pd(v, s);
		__m128d w2 = _mm_mul_pd(v, _mm_shuffle_pd(sc, sc, 1));
		__m128d w = _mm_add_pd(
			_mm_shuffle_pd(w1, w2, 0),
			_mm_shuffle_pd(w1, w2, 3));
		u = _mm_mul_pd(u, h.x);
		w = _mm_mul_pd(w, h.x);
		_mm_store_sd(ff0 + i, u);
		_mm_store_sd(ff0 + i + qn, _mm_shuffle_pd(u, u, 1));
		_mm_store_sd(ff1 + i, w);
		_mm_store_sd(ff1 + i + qn, _mm_shuffle_pd(w, w, 1));
	}
#elif FNDSA_NEON
	static union { fpr f[2]; uint64x2_t w; float64x2_t x; }
		h = { {
			FPR(4503599627370496, -53), FPR(4503599627370496, -53)
		} },
		cz = { {
			FPR_ZERO, FPR_NZERO,
		} };
	const float64_t *ff = (const float64_t *)f;
	float64_t *ff0 = (float64_t *)f0;
	float64_t *ff1 = (float64_t *)f1;
	for (size_t i = 0; i < qn; i ++) {
		float64x2_t ab_re = vld1q_f64(ff + (i << 1));
		float64x2_t ab_im = vld1q_f64(ff + (i << 1) + hn);
		float64x2_t a = vzip1q_f64(ab_re, ab_im);
		float64x2_t b = vzip2q_f64(ab_re, ab_im);
		float64x2_t u = vaddq_f64(a, b);
		float64x2_t v = vsubq_f64(a, b);
		float64x2_t s = vld1q_f64(
			(const float64_t *)fndsa_sign_gm + ((i + hn) << 1));
		float64x2_t sc = vreinterpretq_f64_u64(
			veorq_u64(vreinterpretq_u64_f64(s), cz.w));
		/* We compute w = v*conj(s) */
		float64x2_t w1 = vmulq_f64(v, s);
		float64x2_t w2 = vmulq_f64(v, vextq_f64(sc, sc, 1));
		float64x2_t w = vaddq_f64(
			vzip1q_f64(w1, w2),
			vzip2q_f64(w1, w2));
		u = vmulq_f64(u, h.x);
		w = vmulq_f64(w, h.x);
		vst1_f64(ff0 + i, vget_low_f64(u));
		vst1_f64(ff0 + i + qn, vget_high_f64(u));
		vst1_f64(ff1 + i, vget_low_f64(w));
		vst1_f64(ff1 + i + qn, vget_high_f64(w));
	}
#elif FNDSA_RV64D
	const f64 *ff = (const f64 *)f;
	f64 *ff0 = (f64 *)f0;
	f64 *ff1 = (f64 *)f1;
	for (size_t i = 0; i < qn; i ++) {
		f64 a_re = ff[(i << 1) + 0], a_im = ff[(i << 1) + 0 + hn];
		f64 b_re = ff[(i << 1) + 1], b_im = ff[(i << 1) + 1 + hn];
		f64 t_re, t_im;

		t_re = f64_add(a_re, b_re);
		t_im = f64_add(a_im, b_im);
		ff0[i] = f64_half(t_re);
		ff0[i + qn] = f64_half(t_im);

		t_re = f64_sub(a_re, b_re);
		t_im = f64_sub(a_im, b_im);
		f64 u_re = ((const f64 *)fndsa_sign_gm)[((i + hn) << 1) + 0];
		f64 u_im = ((const f64 *)fndsa_sign_gm)[((i + hn) << 1) + 1];
		f64 v_re = f64_add(f64_mul(t_re, u_re), f64_mul(t_im, u_im));
		f64 v_im = f64_sub(f64_mul(t_im, u_re), f64_mul(t_re, u_im));
		ff1[i] = f64_half(v_re);
		ff1[i + qn] = f64_half(v_im);
	}
#else
	for (size_t i = 0; i < qn; i ++) {
		fpr a_re = f[(i << 1) + 0], a_im = f[(i << 1) + 0 + hn];
		fpr b_re = f[(i << 1) + 1], b_im = f[(i << 1) + 1 + hn];
		fpr t_re, t_im, u_re, u_im;

		FPR_ADD_SUB(t_re, u_re, a_re, b_re);
		FPR_ADD_SUB(t_im, u_im, a_im, b_im);
		f0[i] = fpr_half(t_re);
		f0[i + qn] = fpr_half(t_im);
		FPC_MUL(u_re, u_im, u_re, u_im,
			fndsa_sign_gm[((i + hn) << 1) + 0],
			fpr_neg(fndsa_sign_gm[((i + hn) << 1) + 1]));
		f1[i] = fpr_half(u_re);
		f1[i + qn] = fpr_half(u_im);
	}
#endif
}

/* see sign_inner.h */
TARGET_SSE2 TARGET_NEON
void
oracle_merge_fft(unsigned logn, fpr *f, const fpr *f0, const fpr *f1)
{
	size_t hn = (size_t)1 << (logn - 1);
	size_t qn = hn >> 1;

	if (logn == 1) {
		f[0] = f0[0];
		f[hn] = f1[0];
	}

#if FNDSA_SSE2
	const double *ff0 = (const double *)f0;
	const double *ff1 = (const double *)f1;
	double *ff = (double *)f;
	__m128d cz = _mm_castsi128_pd(_mm_setr_epi32(0, 0, 0, -0x80000000));
	for (size_t i = 0; i < qn; i ++) {
		__m128d a_re = _mm_load_sd(ff0 + i);
		__m128d a_im = _mm_load_sd(ff0 + i + qn);
		__m128d b_re = _mm_load_sd(ff1 + i);
		__m128d b_im = _mm_load_sd(ff1 + i + qn);

		__m128d s = _mm_loadu_pd((const double *)fndsa_sign_gm + ((i + hn) << 1));
		__m128d c1 = _mm_mul_pd(s, _mm_shuffle_pd(b_re, b_im, 0));
		__m128d c2 = _mm_mul_pd(s, _mm_shuffle_pd(b_im, b_re, 0));

		/* c_re <- re(b*s):-re(b*s)
		   c_im <- im(b*s):-im(b*s) */
		__m128d c_re = _mm_sub_pd(c1, _mm_shuffle_pd(c1, c1, 1));
		__m128d c_im = _mm_xor_pd(cz,
			_mm_add_pd(c2, _mm_shuffle_pd(c2, c2, 1)));

		_mm_storeu_pd(ff + (i << 1),
			_mm_add_pd(c_re, _mm_shuffle_pd(a_re, a_re, 0)));
		_mm_storeu_pd(ff + (i << 1) + hn,
			_mm_add_pd(c_im, _mm_shuffle_pd(a_im, a_im, 0)));
	}
#elif FNDSA_NEON
	static const union { fpr f[2]; uint64x2_t w; }
		cz = { { FPR_ZERO, FPR_NZERO } };
	const float64_t *ff0 = (const float64_t *)f0;
	const float64_t *ff1 = (const float64_t *)f1;
	float64_t *ff = (float64_t *)f;
	for (size_t i = 0; i < qn; i ++) {
		float64x1_t a_re = vld1_f64(ff0 + i);
		float64x1_t a_im = vld1_f64(ff0 + i + qn);
		float64x1_t b_re = vld1_f64(ff1 + i);
		float64x1_t b_im = vld1_f64(ff1 + i + qn);
		float64x2_t b = vcombine_f64(b_re, b_im);

		float64x2_t s = vld1q_f64(
			(const float64_t *)fndsa_sign_gm + ((i + hn) << 1));
		float64x2_t c1 = vmulq_f64(s, b);
		float64x2_t c2 = vmulq_f64(s, vextq_f64(b, b, 1));

		/* c_re <- re(b*s):-re(b*s)
		   c_im <- im(b*s):-im(b*s) */
		float64x2_t c_re = vsubq_f64(c1, vextq_f64(c1, c1, 1));
		float64x2_t c_im = vreinterpretq_f64_u64(
			veorq_u64(cz.w, vreinterpretq_u64_f64(
				vaddq_f64(c2, vextq_f64(c2, c2, 1)))));

		vst1q_f64(ff + (i << 1),
			vaddq_f64(c_re, vdupq_lane_f64(a_re, 0)));
		vst1q_f64(ff + (i << 1) + hn,
			vaddq_f64(c_im, vdupq_lane_f64(a_im, 0)));
	}
#elif FNDSA_RV64D
	const f64 *ff0 = (const f64 *)f0;
	const f64 *ff1 = (const f64 *)f1;
	f64 *ff = (f64 *)f;
	for (size_t i = 0; i < qn; i ++) {
		f64 a_re = ff0[i], a_im = ff0[i + qn];
		f64 b_re = ff1[i], b_im = ff1[i + qn];
		f64 s_re = ((const f64 *)fndsa_sign_gm)[((i + hn) << 1) + 0];
		f64 s_im = ((const f64 *)fndsa_sign_gm)[((i + hn) << 1) + 1];
		f64 c_re = f64_sub(f64_mul(b_re, s_re), f64_mul(b_im, s_im));
		f64 c_im = f64_add(f64_mul(b_im, s_re), f64_mul(b_re, s_im));
		ff[(i << 1) + 0] = f64_add(a_re, c_re);
		ff[(i << 1) + 0 + hn] = f64_add(a_im, c_im);
		ff[(i << 1) + 1] = f64_sub(a_re, c_re);
		ff[(i << 1) + 1 + hn] = f64_sub(a_im, c_im);
	}
#else
	for (size_t i = 0; i < qn; i ++) {
		fpr a_re = f0[i], a_im = f0[i + qn];
		fpr b_re = f1[i], b_im = f1[i + qn];
		FPC_MUL(b_re, b_im, b_re, b_im,
			fndsa_sign_gm[((i + hn) << 1) + 0], fndsa_sign_gm[((i + hn) << 1) + 1]);
		FPR_ADD_SUB(
			f[(i << 1) + 0], f[(i << 1) + 1],
			a_re, b_re);
		FPR_ADD_SUB(
			f[(i << 1) + 0 + hn], f[(i << 1) + 1 + hn],
			a_im, b_im);
	}
#endif
}

