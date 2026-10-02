#include "sign_inner.h"
extern const fpr fndsa_sign_gm[];
/* Frozen native C comparators; test-only. */
/* fpr contains binary64 bits. Direct FP access avoids aliasing and
 * does not perform an integer-to-floating-point numerical conversion. */
static inline double
poly_load_fp64(const fpr *p)
{
    double x;
    __asm__("vldr %P0, %1" : "=w"(x) : "m"(*p));
    return x;
}
static inline void
poly_store_fp64(fpr *p, double x)
{
    __asm__("vstr %P1, %0" : "=m"(*p) : "w"(x));
}
/* Native binary64 split; preserve the original operation rounding order. */
void
native_split_fft(unsigned logn, fpr *f0, fpr *f1, const fpr *f)
{
    size_t hn = (size_t)1 << (logn - 1), qn = hn >> 1;
    if (logn == 1) { f0[0] = f[0]; f1[0] = f[1]; return; }
    for (size_t i = 0; i < qn; i++) {
        double ar = poly_load_fp64(f + 2*i);
        double ai = poly_load_fp64(f + 2*i + hn);
        double br = poly_load_fp64(f + 2*i + 1);
        double bi = poly_load_fp64(f + 2*i + 1 + hn);
        double tr = ar + br, ti = ai + bi;
        double ur = ar - br, ui = ai - bi;
        double sr = poly_load_fp64(fndsa_sign_gm + 2*(i + hn));
        double si = -poly_load_fp64(fndsa_sign_gm + 2*(i + hn) + 1);
        double vr = ur*sr - ui*si;
        double vi = ur*si + ui*sr;
        poly_store_fp64(f0 + i, tr * 0.5);
        poly_store_fp64(f0 + i + qn, ti * 0.5);
        poly_store_fp64(f1 + i, vr * 0.5);
        poly_store_fp64(f1 + i + qn, vi * 0.5);
    }
}
/* Native binary64 merge; no fused FMA or expression reassociation. */
void
native_merge_fft(unsigned logn, fpr *f, const fpr *f0, const fpr *f1)
{
    size_t hn = (size_t)1 << (logn - 1), qn = hn >> 1;
    if (logn == 1) { f[0] = f0[0]; f[1] = f1[0]; return; }
    for (size_t i = 0; i < qn; i++) {
        double ar = poly_load_fp64(f0 + i);
        double ai = poly_load_fp64(f0 + i + qn);
        double br = poly_load_fp64(f1 + i);
        double bi = poly_load_fp64(f1 + i + qn);
        double sr = poly_load_fp64(fndsa_sign_gm + 2*(i + hn));
        double si = poly_load_fp64(fndsa_sign_gm + 2*(i + hn) + 1);
        double cr = br*sr - bi*si;
        double ci = br*si + bi*sr;
        poly_store_fp64(f + 2*i, ar + cr);
        poly_store_fp64(f + 2*i + hn, ai + ci);
        poly_store_fp64(f + 2*i + 1, ar - cr);
        poly_store_fp64(f + 2*i + 1 + hn, ai - ci);
    }
}
