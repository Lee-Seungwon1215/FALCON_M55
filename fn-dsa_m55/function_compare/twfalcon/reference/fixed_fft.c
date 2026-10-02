#include "api.h"

static inline uint64_t
qadd(uint64_t a, uint64_t b)
{
	return a + b;
}

static inline uint64_t
qsub(uint64_t a, uint64_t b)
{
	return a - b;
}

static inline uint64_t
qhalf(uint64_t x)
{
	x += 1;
	return (uint64_t)((int64_t)x >> 1);
}

static inline uint64_t
qmul(uint64_t x, uint64_t y)
{
#if defined(__arm__) && !defined(__aarch64__)
	uint32_t x0 = (uint32_t)x;
	uint32_t x1 = (uint32_t)(x >> 32);
	uint32_t y0 = (uint32_t)y;
	uint32_t y1 = (uint32_t)(y >> 32);
	uint32_t z0, z1, tt;
	__asm__(
		"and %0, %4, %5, asr #31\n\t"
		"and %1, %6, %3, asr #31\n\t"
		"umaal %1, %0, %4, %6\n\t"
		"umull %2, %0, %3, %5\n\t"
		"smlal %0, %1, %3, %6\n\t"
		"smlal %0, %1, %4, %5"
		: "=&r" (z0), "=&r" (z1), "=&r" (tt)
		: "r" (x0), "r" (x1), "r" (y0), "r" (y1));
	return (uint64_t)z0 | ((uint64_t)z1 << 32);
#else
	__int128 z = (__int128)(int64_t)x * (__int128)(int64_t)y;
	return (uint64_t)(z >> 32);
#endif
}

static inline void
qcmul(uint64_t ar, uint64_t ai, uint64_t br, uint64_t bi,
	uint64_t *rr, uint64_t *ri)
{
	uint64_t z0 = qmul(ar, br);
	uint64_t z1 = qmul(ai, bi);
	uint64_t z2 = qmul(qadd(ar, ai), qadd(br, bi));
	*rr = qsub(z0, z1);
	*ri = qsub(z2, qadd(z0, z1));
}

void
ref_fft_q32(unsigned logn, uint64_t *f)
{
	size_t hn = (size_t)1 << (logn - 1);
	size_t t = hn;
	for (unsigned lm = 1; lm < logn; lm ++) {
		size_t m = (size_t)1 << lm;
		size_t ht = t >> 1;
		size_t j0 = 0;
		for (size_t i = 0; i < (m >> 1); i ++) {
			uint64_t sr = tw_gm_q32[m + i][0];
			uint64_t si = tw_gm_q32[m + i][1];
			for (size_t j = j0; j < j0 + ht; j ++) {
				uint64_t yr, yi;
				qcmul(sr, si, f[j + ht], f[j + ht + hn], &yr, &yi);
				uint64_t xr = f[j], xi = f[j + hn];
				f[j] = qadd(xr, yr);
				f[j + hn] = qadd(xi, yi);
				f[j + ht] = qsub(xr, yr);
				f[j + ht + hn] = qsub(xi, yi);
			}
			j0 += t;
		}
		t = ht;
	}
}

void
ref_ifft_q32(unsigned logn, uint64_t *f)
{
	size_t hn = (size_t)1 << (logn - 1);
	size_t ht = 1;
	for (unsigned lm = logn - 1; lm > 0; lm --) {
		size_t m = (size_t)1 << lm;
		size_t t = ht << 1;
		size_t j0 = 0;
		for (size_t i = 0; i < (m >> 1); i ++) {
			uint64_t sr = tw_gm_q32[m + i][0];
			uint64_t si = -tw_gm_q32[m + i][1];
			for (size_t j = j0; j < j0 + ht; j ++) {
				uint64_t xr = f[j], xi = f[j + hn];
				uint64_t yr = f[j + ht], yi = f[j + ht + hn];
				f[j] = qhalf(qadd(xr, yr));
				f[j + hn] = qhalf(qadd(xi, yi));
				qcmul(sr, si, qhalf(qsub(xr, yr)),
					qhalf(qsub(xi, yi)), &f[j + ht], &f[j + ht + hn]);
			}
			j0 += t;
		}
		ht = t;
	}
}

static inline double
qdouble(uint64_t x)
{
	return (double)(int64_t)x * 0x1p-32;
}

void
ref_fft_fp64(unsigned logn, double *f)
{
	size_t hn = (size_t)1 << (logn - 1), t = hn;
	for (unsigned lm = 1; lm < logn; lm ++) {
		size_t m = (size_t)1 << lm, ht = t >> 1, j0 = 0;
		for (size_t i = 0; i < (m >> 1); i ++) {
			double sr = qdouble(tw_gm_q32[m + i][0]);
			double si = qdouble(tw_gm_q32[m + i][1]);
			for (size_t j = j0; j < j0 + ht; j ++) {
				double xr=f[j], xi=f[j+hn], yr=f[j+ht], yi=f[j+ht+hn];
				double zr=yr*sr-yi*si, zi=yr*si+yi*sr;
				f[j]=xr+zr; f[j+hn]=xi+zi;
				f[j+ht]=xr-zr; f[j+ht+hn]=xi-zi;
			}
			j0 += t;
		}
		t = ht;
	}
}

void
ref_ifft_fp64(unsigned logn, double *f)
{
	size_t hn = (size_t)1 << (logn - 1), ht = 1;
	for (unsigned lm = logn - 1; lm > 0; lm --) {
		size_t m=(size_t)1<<lm, t=ht<<1, j0=0;
		for (size_t i=0;i<(m>>1);i++) {
			double sr=qdouble(tw_gm_q32[m+i][0]);
			double si=-qdouble(tw_gm_q32[m+i][1]);
			for (size_t j=j0;j<j0+ht;j++) {
				double xr=f[j],xi=f[j+hn],yr=f[j+ht],yi=f[j+ht+hn];
				double dr=0.5*(xr-yr),di=0.5*(xi-yi);
				f[j]=0.5*(xr+yr); f[j+hn]=0.5*(xi+yi);
				f[j+ht]=dr*sr-di*si; f[j+ht+hn]=dr*si+di*sr;
			}
			j0 += t;
		}
		ht=t;
	}
}
