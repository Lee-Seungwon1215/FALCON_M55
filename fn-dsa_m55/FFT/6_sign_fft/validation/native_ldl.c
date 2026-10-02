#include "sign_inner.h"
/* Frozen pre-scheduling native C comparator; never linked into production. */
/* fpr stores binary64 bits, not a Q32 value or an integer to convert.
 * Access the existing arrays directly through FP loads/stores; do not
 * type-pun through a double pointer or introduce a conversion buffer. */
static inline double
ldl_load_fp64(const fpr *p)
{
	double x;
	__asm__("vldr %P0, %1" : "=w" (x) : "m" (*p));
	return x;
}

static inline void
ldl_store_fp64(fpr *p, double x)
{
	__asm__("vstr %P1, %0" : "=m" (*p) : "w" (x));
}

/* see sign_inner.h
 * M55 native binary64 LDL only. Preserve the original operation ordering:
 * one reciprocal, four separate products, add, subtract, conjugation.
 * The project builds with -ffp-contract=off (no fused rounding).
 * The shared fpr_* emulation used by other signing functions is unchanged. */
void
native_LDL_fft(unsigned logn, const fpr *g00, fpr *g01, fpr *g11)
{
	size_t hn = (size_t)1 << (logn - 1);
	for (size_t i = 0; i < hn; i ++) {
		double a = ldl_load_fp64(g00 + i);
		double b = ldl_load_fp64(g01 + i);
		double c = ldl_load_fp64(g01 + i + hn);
		double d = ldl_load_fp64(g11 + i);
		double inv = 1.0 / a;
		double mu_re = b * inv;
		double mu_im = c * inv;
		double p_re = mu_re * b;
		double p_im = mu_im * c;
		double z = p_re + p_im;
		ldl_store_fp64(g11 + i, d - z);
		ldl_store_fp64(g01 + i, mu_re);
		ldl_store_fp64(g01 + i + hn, -mu_im);
	}
}


