/* Test-only stage-7 transform control and twiddles, copied from the
 * preserved source. Only exported function/span names differ. Small tails
 * deliberately share the unchanged production leaf functions.
 */
#include "api.h"
#include "triple_float.h"
#include <arm_mve.h>
#include <string.h>
typedef struct { float c[2][4]; } ds4;
static tw_fpr gm_re[TW32_NMAX], gm_im[TW32_NMAX];
extern void ds32_stage7_fwd4_span(float *, float *, float *, float *,
    const float *, const float *, unsigned, unsigned);
extern void ds32_stage7_inv4_span(float *, float *, float *, float *,
    const float *, const float *, unsigned, unsigned);
static inline tw_fpr neg1(tw_fpr x)
{
    return (tw_fpr){{-x.x[0], -x.x[1], -x.x[2]}};
}
static inline tw_fpr
q32_tw(uint64_t x)
{
	double d = (double)(int64_t)x * 0x1p-32;
	float h = (float)d;
	float m = (float)(d - (double)h);
	return (tw_fpr){{ h, m, (float)(d - (double)h - (double)m) }};
}

void
ds32_stage7_init_twiddles(void)
{
	for (size_t u = 0; u < TW32_NMAX; u ++) {
		gm_re[u] = q32_tw(tw_gm_q32[u][0]);
		gm_im[u] = q32_tw(tw_gm_q32[u][1]);
	}
}


static inline void
ds_splat4(ds4 *d, tw_fpr x)
{
	for (unsigned k = 0; k < 2; k ++) {
		for (unsigned u = 0; u < 4; u ++) d->c[k][u] = x.x[k];
	}
}

static inline void
ds_load_tail(ds4 *d, const float p[3][TW32_NMAX / 2], size_t i,
	unsigned lanes)
{
	mve_pred16_t pred = vctp32q(lanes);
	for (unsigned k = 0; k < 2; k ++) {
		vst1q_f32(d->c[k], vld1q_z_f32(p[k] + i, pred));
	}
}

static inline void
ds_store_tail(float p[3][TW32_NMAX / 2], size_t i, const ds4 *s,
	unsigned lanes)
{
	mve_pred16_t pred = vctp32q(lanes);
	for (unsigned k = 0; k < 2; k ++) {
		vst1q_p_f32(p[k] + i, vld1q_f32(s->c[k]), pred);
	}
}

/*
 * Apply the packed inverse-FFT normalization once, after all inverse
 * butterflies.  The scale is 2/n and therefore an exact binary power of
 * two; for the value range used by FN-DSA, moving this operation out of the
 * individual layers does not introduce an additional rounding step.
 */
static void
ds_final_scale(unsigned logn, tw32_fft *f)
{
	size_t hn = (size_t)1 << (logn - 1);
	union {
		uint32_t u;
		float f;
	} sc = { (uint32_t)(128u - logn) << 23 };
	float32x4_t vs = vdupq_n_f32(sc.f);
	for (unsigned k = 0; k < 2; k ++) {
		for (unsigned part = 0; part < 2; part ++) {
			float *p = part == 0 ? f->re[k] : f->im[k];
			size_t i = 0;
			for (; i + 4 <= hn; i += 4) {
				vst1q_f32(p + i, vmulq_f32(vld1q_f32(p + i), vs));
			}
			if (i < hn) {
				mve_pred16_t pred = vctp32q((unsigned)(hn - i));
				float32x4_t x = vld1q_z_f32(p + i, pred);
				vst1q_p_f32(p + i, vmulq_f32(x, vs), pred);
			}
		}
	}
}

void
ds32_stage7_fft_mve(unsigned logn, tw32_fft *f)
{
	size_t hn = (size_t)1 << (logn - 1), t = hn;
	for (unsigned lm = 1; lm < logn; lm ++) {
		size_t m = (size_t)1 << lm, ht = t >> 1, j0 = 0;
		for (size_t i = 0; i < (m >> 1); i ++) {
			ds4 sr, si;
			ds_splat4(&sr, gm_re[m + i]);
			ds_splat4(&si, gm_im[m + i]);
			size_t j = j0;
			unsigned blocks = (unsigned)((j0 + ht - j) >> 2);
			if (blocks != 0) {
				ds32_stage7_fwd4_span(f->re[0] + j, f->im[0] + j,
					f->re[0] + j + ht, f->im[0] + j + ht,
					&sr.c[0][0], &si.c[0][0],
					TW32_NMAX / 2 * sizeof(float), blocks);
				j += (size_t)blocks << 2;
			}
			if (j < j0 + ht) {
				unsigned lanes = (unsigned)(j0 + ht - j);
				ds4 xr, xi, yr, yi;
				ds_load_tail(&xr, f->re, j, lanes);
				ds_load_tail(&xi, f->im, j, lanes);
				ds_load_tail(&yr, f->re, j + ht, lanes);
				ds_load_tail(&yi, f->im, j + ht, lanes);
				ds32_bfly_fwd4(&xr.c[0][0], &xi.c[0][0],
					&yr.c[0][0], &yi.c[0][0],
					&sr.c[0][0], &si.c[0][0], 4 * sizeof(float));
				ds_store_tail(f->re, j, &xr, lanes);
				ds_store_tail(f->im, j, &xi, lanes);
				ds_store_tail(f->re, j + ht, &yr, lanes);
				ds_store_tail(f->im, j + ht, &yi, lanes);
			}
			j0 += t;
		}
		t = ht;
	}
}

void
ds32_stage7_ifft_mve(unsigned logn, tw32_fft *f)
{
	size_t ht = 1;
	for (unsigned lm = logn - 1; lm > 0; lm --) {
		size_t m = (size_t)1 << lm, t = ht << 1, j0 = 0;
		for (size_t i = 0; i < (m >> 1); i ++) {
			tw_fpr sri = gm_re[m + i];
			tw_fpr sii = neg1(gm_im[m + i]);
			ds4 sr, si;
			ds_splat4(&sr, sri);
			ds_splat4(&si, sii);
			size_t j = j0;
			unsigned blocks = (unsigned)((j0 + ht - j) >> 2);
			if (blocks != 0) {
				ds32_stage7_inv4_span(f->re[0] + j, f->im[0] + j,
					f->re[0] + j + ht, f->im[0] + j + ht,
					&sr.c[0][0], &si.c[0][0],
					TW32_NMAX / 2 * sizeof(float), blocks);
				j += (size_t)blocks << 2;
			}
			if (j < j0 + ht) {
				unsigned lanes = (unsigned)(j0 + ht - j);
				ds4 xr, xi, yr, yi;
				ds_load_tail(&xr, f->re, j, lanes);
				ds_load_tail(&xi, f->im, j, lanes);
				ds_load_tail(&yr, f->re, j + ht, lanes);
				ds_load_tail(&yi, f->im, j + ht, lanes);
				ds32_bfly_inv4(&xr.c[0][0], &xi.c[0][0],
					&yr.c[0][0], &yi.c[0][0],
					&sr.c[0][0], &si.c[0][0], 4 * sizeof(float));
				ds_store_tail(f->re, j, &xr, lanes);
				ds_store_tail(f->im, j, &xi, lanes);
				ds_store_tail(f->re, j + ht, &yr, lanes);
				ds_store_tail(f->im, j + ht, &yi, lanes);
			}
			j0 += t;
		}
		ht = t;
	}
	ds_final_scale(logn, f);
}

/* Same C control and twiddles, but the direct-memory stage-8 spans. */
extern void ds32_stage8_fwd4_span(float *, float *, float *, float *,
    const float *, const float *, unsigned, unsigned);
extern void ds32_stage8_inv4_span(float *, float *, float *, float *,
    const float *, const float *, unsigned, unsigned);
void
ds32_stage8_fft_mve(unsigned logn, tw32_fft *f)
{
	size_t hn = (size_t)1 << (logn - 1), t = hn;
	for (unsigned lm = 1; lm < logn; lm ++) {
		size_t m = (size_t)1 << lm, ht = t >> 1, j0 = 0;
		for (size_t i = 0; i < (m >> 1); i ++) {
			ds4 sr, si;
			ds_splat4(&sr, gm_re[m + i]);
			ds_splat4(&si, gm_im[m + i]);
			size_t j = j0;
			unsigned blocks = (unsigned)((j0 + ht - j) >> 2);
			if (blocks != 0) {
				ds32_stage8_fwd4_span(f->re[0] + j, f->im[0] + j,
					f->re[0] + j + ht, f->im[0] + j + ht,
					&sr.c[0][0], &si.c[0][0],
					TW32_NMAX / 2 * sizeof(float), blocks);
				j += (size_t)blocks << 2;
			}
			if (j < j0 + ht) {
				unsigned lanes = (unsigned)(j0 + ht - j);
				ds4 xr, xi, yr, yi;
				ds_load_tail(&xr, f->re, j, lanes);
				ds_load_tail(&xi, f->im, j, lanes);
				ds_load_tail(&yr, f->re, j + ht, lanes);
				ds_load_tail(&yi, f->im, j + ht, lanes);
				ds32_bfly_fwd4(&xr.c[0][0], &xi.c[0][0],
					&yr.c[0][0], &yi.c[0][0],
					&sr.c[0][0], &si.c[0][0], 4 * sizeof(float));
				ds_store_tail(f->re, j, &xr, lanes);
				ds_store_tail(f->im, j, &xi, lanes);
				ds_store_tail(f->re, j + ht, &yr, lanes);
				ds_store_tail(f->im, j + ht, &yi, lanes);
			}
			j0 += t;
		}
		t = ht;
	}
}

void
ds32_stage8_ifft_mve(unsigned logn, tw32_fft *f)
{
	size_t ht = 1;
	for (unsigned lm = logn - 1; lm > 0; lm --) {
		size_t m = (size_t)1 << lm, t = ht << 1, j0 = 0;
		for (size_t i = 0; i < (m >> 1); i ++) {
			tw_fpr sri = gm_re[m + i];
			tw_fpr sii = neg1(gm_im[m + i]);
			ds4 sr, si;
			ds_splat4(&sr, sri);
			ds_splat4(&si, sii);
			size_t j = j0;
			unsigned blocks = (unsigned)((j0 + ht - j) >> 2);
			if (blocks != 0) {
				ds32_stage8_inv4_span(f->re[0] + j, f->im[0] + j,
					f->re[0] + j + ht, f->im[0] + j + ht,
					&sr.c[0][0], &si.c[0][0],
					TW32_NMAX / 2 * sizeof(float), blocks);
				j += (size_t)blocks << 2;
			}
			if (j < j0 + ht) {
				unsigned lanes = (unsigned)(j0 + ht - j);
				ds4 xr, xi, yr, yi;
				ds_load_tail(&xr, f->re, j, lanes);
				ds_load_tail(&xi, f->im, j, lanes);
				ds_load_tail(&yr, f->re, j + ht, lanes);
				ds_load_tail(&yi, f->im, j + ht, lanes);
				ds32_bfly_inv4(&xr.c[0][0], &xi.c[0][0],
					&yr.c[0][0], &yi.c[0][0],
					&sr.c[0][0], &si.c[0][0], 4 * sizeof(float));
				ds_store_tail(f->re, j, &xr, lanes);
				ds_store_tail(f->im, j, &xi, lanes);
				ds_store_tail(f->re, j + ht, &yr, lanes);
				ds_store_tail(f->im, j + ht, &yi, lanes);
			}
			j0 += t;
		}
		ht = t;
	}
	ds_final_scale(logn, f);
}
