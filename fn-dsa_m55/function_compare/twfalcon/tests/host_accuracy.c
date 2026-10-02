#include "api.h"

#include <inttypes.h>
#include <stdio.h>
#include <string.h>

static uint64_t seed = UINT64_C(0x243f6a8885a308d3);

static uint32_t
prng(void)
{
	seed ^= seed << 13;
	seed ^= seed >> 7;
	seed ^= seed << 17;
	return (uint32_t)seed;
}

static uint64_t
absdiff(uint64_t a, uint64_t b)
{
	int64_t d = (int64_t)(a - b);
	return d < 0 ? -(uint64_t)d : (uint64_t)d;
}

int
main(void)
{
	static uint64_t src[TW32_NMAX], q[TW32_NMAX], tq[TW32_NMAX];
	static tw32_fft tw;
	uint64_t fft_max = 0, roundtrip_max = 0, mismatches = 0;
	for (unsigned logn = 2; logn <= 10; logn ++) {
		size_t n = (size_t)1 << logn;
		for (unsigned round = 0; round < 20; round ++) {
			for (size_t i = 0; i < n; i ++) {
				int32_t x = (int32_t)(prng() % 2049) - 1024;
				src[i] = (uint64_t)(int64_t)x << 32;
			}
			memcpy(q, src, n * sizeof *q);
			ref_fft_q32(logn, q);
			tw32_from_q32(logn, &tw, src);
			tw32_fft_scalar(logn, &tw);
			tw32_to_q32(logn, tq, &tw);
			for (size_t i = 0; i < n; i ++) {
				uint64_t d = absdiff(q[i], tq[i]);
				if (d > fft_max) fft_max = d;
				mismatches += d != 0;
			}
			tw32_ifft_scalar(logn, &tw);
			tw32_to_q32(logn, tq, &tw);
			for (size_t i = 0; i < n; i ++) {
				uint64_t d = absdiff(src[i], tq[i]);
				if (d > roundtrip_max) roundtrip_max = d;
			}
		}
	}
	printf("HOST_ACCURACY fft_max_q32_lsb=%" PRIu64
		" fft_nonidentical=%" PRIu64 " roundtrip_max_q32_lsb=%" PRIu64 "\n",
		fft_max, mismatches, roundtrip_max);
	return roundtrip_max > 4;
}
