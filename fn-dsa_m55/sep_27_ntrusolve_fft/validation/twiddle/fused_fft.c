/* Independent test of the fused butterfly; no production backend changes. */
#include "kgen_inner.h"
#include "table.h"
extern void trial_fused_butterfly(fxr *const *, unsigned, const fxc *, unsigned);
void trial_fused_fft(unsigned logn, fxr *f, unsigned cutoff)
{
    size_t hn = (size_t)1 << (logn - 1), t = hn;
    for (unsigned lm = 1; lm < logn; lm++) {
        size_t m = (size_t)1 << lm, ht = t >> 1, j0 = 0;
        for (size_t i = 0; i < m / 2; i++, j0 += t) {
            fxc s = {{original_twiddles[m+i][0]}, {original_twiddles[m+i][1]}};
            if (ht < cutoff) {
                for (size_t j = j0; j < j0 + ht; j++) {
                    fxc x = {f[j], f[j+hn]}, y = {f[j+ht], f[j+ht+hn]};
                    y = fxc_mul(s, y);
                    fxc a = fxc_add(x, y), b = fxc_sub(x, y);
                    f[j] = a.re; f[j+hn] = a.im; f[j+ht] = b.re; f[j+ht+hn] = b.im;
                }
            } else {
                fxr *p[] = {f+j0, f+j0+hn, f+j0+ht, f+j0+ht+hn};
                trial_fused_butterfly(p, (unsigned)ht, &s, 0);
            }
        }
        t = ht;
    }
}
void trial_fused_ifft(unsigned logn, fxr *f, unsigned cutoff)
{
    size_t hn = (size_t)1 << (logn - 1), ht = 1;
    for (unsigned lm = logn - 1; lm > 0; lm--) {
        size_t m = (size_t)1 << lm, t = ht << 1, j0 = 0;
        for (size_t i = 0; i < m / 2; i++, j0 += t) {
            fxc s = {{original_twiddles[m+i][0]}, {-original_twiddles[m+i][1]}};
            if (ht < cutoff) {
                for (size_t j = j0; j < j0 + ht; j++) {
                    fxc x = {f[j], f[j+hn]}, y = {f[j+ht], f[j+ht+hn]};
                    fxc a = fxc_half(fxc_add(x, y));
                    fxc b = fxc_mul(s, fxc_half(fxc_sub(x, y)));
                    f[j] = a.re; f[j+hn] = a.im; f[j+ht] = b.re; f[j+ht+hn] = b.im;
                }
            } else {
                fxr *p[] = {f+j0, f+j0+hn, f+j0+ht, f+j0+ht+hn};
                trial_fused_butterfly(p, (unsigned)ht, &s, 1);
            }
        }
        ht <<= 1;
    }
}
