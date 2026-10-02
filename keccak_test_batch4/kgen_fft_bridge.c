/* NTRU-only double boundary around the local two-FP32 MVE FFT.
 * Stack workspace makes calls reentrant; no shared mutable state or backend
 * selection by compiler flags. Both conversions are part of the call cost.
 */
#include "kgen_ds.h"

static void
fft_bridge(unsigned logn, double *f, unsigned inverse)
{
    fndsa_ds_poly work __attribute__((aligned(32)));
    size_t hn = (size_t)1 << (logn - 1);
    for (size_t i = 0; i < hn; i++) {
        float re = (float)f[i], im = (float)f[i + hn];
        work.re[0][i] = re;
        work.re[1][i] = (float)(f[i] - (double)re);
        work.im[0][i] = im;
        work.im[1][i] = (float)(f[i + hn] - (double)im);
    }
    if (inverse) {
        fndsa_ds_ifft(logn, &work);
    } else {
        fndsa_ds_fft(logn, &work);
    }
    for (size_t i = 0; i < hn; i++) {
        f[i] = (double)work.re[0][i] + (double)work.re[1][i];
        f[i + hn] = (double)work.im[0][i] + (double)work.im[1][i];
    }
}

void
fndsa_fft_bridge_forward(unsigned logn, double *f)
{
    fft_bridge(logn, f, 0);
}

void
fndsa_fft_bridge_inverse(unsigned logn, double *f)
{
    fft_bridge(logn, f, 1);
}
