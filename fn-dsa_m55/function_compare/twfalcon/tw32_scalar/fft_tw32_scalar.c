#include "api.h"
#include "triple_float.h"

#include <string.h>

_Static_assert(sizeof(tw32) == sizeof(tw_fpr), "triple-float ABI mismatch");

static inline tw_fpr
load_tw(const float p[3][TW32_NMAX / 2], size_t i)
{
	return (tw_fpr){{ p[0][i], p[1][i], p[2][i] }};
}

static inline void
store_tw(float p[3][TW32_NMAX / 2], size_t i, tw_fpr x)
{
	p[0][i] = x.x[0];
	p[1][i] = x.x[1];
	p[2][i] = x.x[2];
}

static inline tw_fpr
tw_neg(tw_fpr x)
{
	return (tw_fpr){{ -x.x[0], -x.x[1], -x.x[2] }};
}

static inline tw_fpr
tw_half(tw_fpr x)
{
	return (tw_fpr){{ x.x[0] * 0.5f, x.x[1] * 0.5f, x.x[2] * 0.5f }};
}

static inline tw_fpr
tw_from_q32(uint64_t x)
{
	double d = (double)(int64_t)x * 0x1p-32;
	float h = (float)d;
	float m = (float)(d - (double)h);
	float l = (float)(d - (double)h - (double)m);
	return (tw_fpr){{ h, m, l }};
}

static inline uint64_t
tw_to_q32(tw_fpr x)
{
	double d = (double)x.x[0] + (double)x.x[1] + (double)x.x[2];
	return (uint64_t)(int64_t)(d * 0x1p32);
}

static inline tw_fpr
tw_add(tw_fpr a, tw_fpr b)
{
	return tw_sum_ct(a, b);
}

static inline tw_fpr
tw_subtract(tw_fpr a, tw_fpr b)
{
	return tw_sum_ct(a, tw_neg(b));
}

static inline void
tw_cmul(tw_fpr ar, tw_fpr ai, tw_fpr br, tw_fpr bi,
	tw_fpr *rr, tw_fpr *ri)
{
	/* TWFalcon explicitly selects the four-real-product formula. */
	tw_fpr p0 = tw_prod_fast_ct(ar, br);
	tw_fpr p1 = tw_prod_fast_ct(ai, bi);
	tw_fpr p2 = tw_prod_fast_ct(ar, bi);
	tw_fpr p3 = tw_prod_fast_ct(ai, br);
	*rr = tw_subtract(p0, p1);
	*ri = tw_add(p2, p3);
}

void
tw32_from_q32(unsigned logn, tw32_fft *d, const uint64_t *s)
{
	size_t hn = (size_t)1 << (logn - 1);
	for (size_t i = 0; i < hn; i ++) {
		store_tw(d->re, i, tw_from_q32(s[i]));
		store_tw(d->im, i, tw_from_q32(s[i + hn]));
	}
}

void
ds32_from_q32(unsigned logn, tw32_fft *d, const uint64_t *s)
{
	size_t hn = (size_t)1 << (logn - 1);
	for (size_t i = 0; i < hn; i ++) {
		double re = (double)(int64_t)s[i] * 0x1p-32;
		double im = (double)(int64_t)s[i + hn] * 0x1p-32;
		d->re[0][i] = (float)re;
		d->re[1][i] = (float)(re - (double)d->re[0][i]);
		d->re[2][i] = 0.0f;
		d->im[0][i] = (float)im;
		d->im[1][i] = (float)(im - (double)d->im[0][i]);
		d->im[2][i] = 0.0f;
	}
}

void
tw32_to_q32(unsigned logn, uint64_t *d, const tw32_fft *s)
{
	size_t hn = (size_t)1 << (logn - 1);
	for (size_t i = 0; i < hn; i ++) {
		d[i] = tw_to_q32(load_tw(s->re, i));
		d[i + hn] = tw_to_q32(load_tw(s->im, i));
	}
}

void
tw32_fft_scalar(unsigned logn, tw32_fft *f)
{
	size_t hn = (size_t)1 << (logn - 1);
	size_t t = hn;
	for (unsigned lm = 1; lm < logn; lm ++) {
		size_t m = (size_t)1 << lm;
		size_t ht = t >> 1;
		size_t j0 = 0;
		for (size_t i = 0; i < (m >> 1); i ++) {
			tw_fpr sr = tw_from_q32(tw_gm_q32[m + i][0]);
			tw_fpr si = tw_from_q32(tw_gm_q32[m + i][1]);
			for (size_t j = j0; j < j0 + ht; j ++) {
				tw_fpr xr = load_tw(f->re, j);
				tw_fpr xi = load_tw(f->im, j);
				tw_fpr yr = load_tw(f->re, j + ht);
				tw_fpr yi = load_tw(f->im, j + ht);
				tw_fpr zr, zi, ap, am;
				tw_cmul(yr, yi, sr, si, &zr, &zi);
				tw_add_sub_ct(xr, zr, &ap, &am);
				store_tw(f->re, j, ap);
				store_tw(f->re, j + ht, am);
				tw_add_sub_ct(xi, zi, &ap, &am);
				store_tw(f->im, j, ap);
				store_tw(f->im, j + ht, am);
			}
			j0 += t;
		}
		t = ht;
	}
}

void
tw32_ifft_scalar(unsigned logn, tw32_fft *f)
{
	size_t ht = 1;
	for (unsigned lm = logn - 1; lm > 0; lm --) {
		size_t m = (size_t)1 << lm;
		size_t t = ht << 1;
		size_t j0 = 0;
		for (size_t i = 0; i < (m >> 1); i ++) {
			tw_fpr sr = tw_from_q32(tw_gm_q32[m + i][0]);
			tw_fpr si = tw_neg(tw_from_q32(tw_gm_q32[m + i][1]));
			for (size_t j = j0; j < j0 + ht; j ++) {
				tw_fpr xr = load_tw(f->re, j);
				tw_fpr xi = load_tw(f->im, j);
				tw_fpr yr = load_tw(f->re, j + ht);
				tw_fpr yi = load_tw(f->im, j + ht);
				tw_fpr sumr, diffr, sumi, diffi, zr, zi;
				tw_add_sub_ct(xr, yr, &sumr, &diffr);
				tw_add_sub_ct(xi, yi, &sumi, &diffi);
				store_tw(f->re, j, tw_half(sumr));
				store_tw(f->im, j, tw_half(sumi));
				tw_cmul(tw_half(diffr), tw_half(diffi), sr, si, &zr, &zi);
				store_tw(f->re, j + ht, zr);
				store_tw(f->im, j + ht, zi);
			}
			j0 += t;
		}
		ht = t;
	}
}
