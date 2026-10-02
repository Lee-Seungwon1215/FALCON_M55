/*
 * Exhaustive scalar model for the two 16-bit MVE constant-multiplication
 * candidates used in stage 3.  This models the lane semantics of VMUL,
 * VQRDMULH and VQRDMLAH; it does not benchmark host code.
 */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#define Q 12289
#define R15 32768
#define R16 65536

static int32_t
sat16(int64_t x)
{
	if (x < -32768) {
		return -32768;
	}
	if (x > 32767) {
		return 32767;
	}
	return (int32_t)x;
}

static int32_t
s16(int64_t x)
{
	uint32_t y = (uint32_t)x & 0xFFFFu;
	return (int32_t)(y ^ 0x8000u) - 0x8000;
}

/* Signed 16-bit VQRDMULH lane semantics. */
static int32_t
qrdmulh16(int32_t a, int32_t b)
{
	return sat16(((int64_t)2 * a * b + R15) >> 16);
}

/* Signed 16-bit VQRDMLAH lane semantics. */
static int32_t
qrdmlah16(int32_t d, int32_t a, int32_t b)
{
	return sat16((int64_t)d
		+ (((int64_t)2 * a * b + R15) >> 16));
}

static int32_t
mod_inverse(int32_t a, int32_t m)
{
	int32_t t = 0, nt = 1;
	int32_t r = m, nr = a;
	while (nr != 0) {
		int32_t q = r / nr;
		int32_t z = t - q * nt;
		t = nt;
		nt = z;
		z = r - q * nr;
		r = nr;
		nr = z;
	}
	if (t < 0) {
		t += m;
	}
	return t;
}

static int32_t
odd_rep(int32_t x)
{
	int32_t best = 0x7FFFFFFF;
	for (int k = -1; k <= 1; k ++) {
		int32_t z = x + k * Q;
		if (z > -32768 && z < 32768 && (z & 1) != 0
			&& abs(z) < abs(best))
		{
			best = z;
		}
	}
	return best;
}

static int32_t
round_div(int64_t x, int32_t d)
{
	if (x >= 0) {
		return (int32_t)((x + (d >> 1)) / d);
	} else {
		return -(int32_t)((-x + (d >> 1)) / d);
	}
}

static int32_t
mont3(int32_t a, int32_t w, int32_t qinv)
{
	int32_t b = odd_rep((int32_t)(((int64_t)w * R15) % Q));
	int32_t bt = s16(-(int64_t)b * qinv);
	int32_t h = qrdmulh16(a, b);
	int32_t l = s16((int64_t)a * bt);
	return qrdmlah16(h, l, Q);
}

static int32_t
barrett3(int32_t a, int32_t w)
{
	int32_t wc = w <= (Q >> 1) ? w : w - Q;
	int32_t wt = -round_div((int64_t)wc * R15, Q);
	int32_t t = qrdmulh16(a, wt);
	return s16((int64_t)a * wc + (int64_t)t * Q);
}

int
main(void)
{
	int32_t qinv = mod_inverse(Q, R16);
	int32_t lo_m = 32767, hi_m = -32768;
	int32_t lo_b = 32767, hi_b = -32768;
	int32_t lo_m_a = 0, lo_m_w = 0, hi_m_a = 0, hi_m_w = 0;
	int32_t lo_b_a = 0, lo_b_w = 0, hi_b_a = 0, hi_b_w = 0;
	for (int32_t w = 0; w < Q; w ++) {
		for (int32_t a = 0; a <= Q; a ++) {
			int32_t expect = (int32_t)(((int64_t)a * w) % Q);
			int32_t zm = mont3(a, w, qinv);
			int32_t zb = barrett3(a, w);
			if ((zm % Q + Q) % Q != expect) {
				printf("MONT3_FAIL a=%d w=%d got=%d expect=%d\n",
					a, w, zm, expect);
				return 1;
			}
			if ((zb % Q + Q) % Q != expect) {
				printf("BARRETT3_FAIL a=%d w=%d got=%d expect=%d\n",
					a, w, zb, expect);
				return 1;
			}
			if (zm < lo_m) { lo_m = zm; lo_m_a = a; lo_m_w = w; }
			if (zm > hi_m) { hi_m = zm; hi_m_a = a; hi_m_w = w; }
			if (zb < lo_b) { lo_b = zb; lo_b_a = a; lo_b_w = w; }
			if (zb > hi_b) { hi_b = zb; hi_b_a = a; hi_b_w = w; }
		}
	}
	printf("PASS q=%d inputs=%d mont3_range=[%d,%d] "
		"barrett3_range=[%d,%d]\n", Q, Q * (Q + 1),
		lo_m, hi_m, lo_b, hi_b);
	printf("MONT3 extrema: min(a=%d,w=%d) max(a=%d,w=%d)\n",
		lo_m_a, lo_m_w, hi_m_a, hi_m_w);
	printf("BARRETT3 extrema: min(a=%d,w=%d) max(a=%d,w=%d)\n",
		lo_b_a, lo_b_w, hi_b_a, hi_b_w);
	return 0;
}
