/* Host diagnostic only. Every real keygen iFFT call is also computed with
 * the old per-stage implementation; compare all 64 bits, not just rounded k.
 */
#define fndsa_vect_iFFT_fp64 candidate_iFFT
#include "../kgen_fxp.c"
#undef fndsa_vect_iFFT_fp64
#include "baseline_ifft.h"
#include <assert.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
static unsigned long calls[11];
static double largest[11];
void fndsa_vect_iFFT_fp64(unsigned logn, double *f)
{
    assert(logn >= 1 && logn <= 10);
    size_t n = (size_t)1 << logn;
    double old[1024];
    memcpy(old, f, n * sizeof *f);
    for (size_t i = 0; i < n; i++) {
        assert(isfinite(f[i]));
        if (fabs(f[i]) > largest[logn]) largest[logn] = fabs(f[i]);
    }
    baseline_iFFT(logn, old);
    candidate_iFFT(logn, f);
    if (memcmp(old, f, n * sizeof *f)) {
        fprintf(stderr, "HOST_IFFT_BIT_MISMATCH logn=%u\n", logn);
        abort();
    }
    calls[logn]++;
}
__attribute__((destructor)) static void report(void)
{
    for (unsigned l = 1; l <= 10; l++)
        if (calls[l]) printf("HOST_IFFT logn=%u calls=%lu max_abs_input=%a bitexact=PASS\n", l, calls[l], largest[l]);
}
