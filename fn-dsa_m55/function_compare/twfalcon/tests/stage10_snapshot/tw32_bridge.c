#include "tw32_api.h"

/* Isolated adapter; the selected production trees do not reference it. */
static tw32_fft workspace;

static void
split2(double x, float d[2])
{
	d[0] = (float)x;
	d[1] = (float)(x - (double)d[0]);
}

static void
from_double(unsigned logn, const double *f)
{
	size_t hn = (size_t)1 << (logn - 1);
	for (size_t u = 0; u < hn; u ++) {
		float x[2];
		split2(f[u], x);
		workspace.re[0][u] = x[0];
		workspace.re[1][u] = x[1];
		workspace.re[2][u] = 0.0f;
		split2(f[u + hn], x);
		workspace.im[0][u] = x[0];
		workspace.im[1][u] = x[1];
		workspace.im[2][u] = 0.0f;
	}
}

static void
to_double(unsigned logn, double *f)
{
	size_t hn = (size_t)1 << (logn - 1);
	for (size_t u = 0; u < hn; u ++) {
		f[u] = (double)workspace.re[0][u] + (double)workspace.re[1][u];
		f[u + hn] = (double)workspace.im[0][u]
			+ (double)workspace.im[1][u];
	}
}

void
tw32_bridge_fft(unsigned logn, double *f)
{
	from_double(logn, f);
	ds32_fft_mve(logn, &workspace);
	to_double(logn, f);
}

void
tw32_bridge_ifft(unsigned logn, double *f)
{
	from_double(logn, f);
	ds32_ifft_mve(logn, &workspace);
	to_double(logn, f);
}
