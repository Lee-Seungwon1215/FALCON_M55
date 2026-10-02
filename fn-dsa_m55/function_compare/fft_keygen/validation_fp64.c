/*
 * Host oracle for the first native-FP64 key-generation FFT baseline.
 * This file is not linked into FN-DSA.  It compares the experimental kernels
 * against the unchanged fixed-point kernels on identical inputs.
 */
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include "kgen_inner.h"

static uint64_t rng_state = UINT64_C(0x6a09e667f3bcc909);

static uint32_t
prng32(void)
{
	rng_state ^= rng_state << 13;
	rng_state ^= rng_state >> 7;
	rng_state ^= rng_state << 17;
	return (uint32_t)rng_state;
}

static int64_t
fp64_to_raw(double x)
{
	return (int64_t)(x * 0x1p32);
}

static int
compare_vector(const char *name, unsigned logn, unsigned round,
	const fxr *ref, const double *trial, size_t len, const fxr *input)
{
	for (size_t i = 0; i < len; i ++) {
		int64_t a = (int64_t)ref[i].v;
		int64_t b = fp64_to_raw(trial[i]);
		if (a != b) {
			printf("FAIL kernel=%s logn=%u round=%u index=%zu "
				"fixed=%016" PRIx64 " fp64=%016" PRIx64 "\n",
				name, logn, round, i, (uint64_t)a, (uint64_t)b);
			if (input != NULL) {
				printf("INPUT");
				for (size_t j = 0; j < ((size_t)1 << logn); j ++) {
					printf(" %" PRId64, (int64_t)input[j].v >> 32);
				}
				printf("\n");
			}
			return 0;
		}
	}
	return 1;
}

static void
make_input(unsigned logn, fxr *ref, double *trial, unsigned salt)
{
	size_t n = (size_t)1 << logn;
	for (size_t i = 0; i < n; i ++) {
		/* Integer key-generation coefficients with mixed signs. */
		int32_t v = (int32_t)(prng32() % (2u * (256u + salt) + 1u))
			- (int32_t)(256u + salt);
		ref[i].v = (uint64_t)(int64_t)v << 32;
		trial[i] = (double)v;
	}
}

int
main(void)
{
	fxr a[1024], b[1024], d[512];
	double x[1024], y[1024], u[1024], z[512];
	unsigned checks = 0;

	for (unsigned logn = 2; logn <= 10; logn ++) {
		size_t n = (size_t)1 << logn;
		for (unsigned round = 0; round < 100; round ++) {
			make_input(logn, a, x, round);
			memcpy(b, a, n * sizeof *a);
			memcpy(y, x, n * sizeof *x);
			memcpy(u, x, n * sizeof *u);

			vect_FFT_fixed(logn, a);
			vect_FFT_fp64(logn, x);
			if (!compare_vector("FFT", logn, round, a, x, n, b)) {
				return 1;
			}
			checks ++;
			vect_FFT(logn, u);
			if (!compare_vector("FFT-fused2", logn, round,
					a, u, n, b)) {
				return 1;
			}
			checks ++;

			vect_FFT_fixed(logn, b);
			vect_FFT_fp64(logn, y);
			vect_invnorm_fft_fixed(logn, d, a, b, 0);
			vect_invnorm_fft_fp64(logn, z, x, y, 0);
			if (!compare_vector("invnorm", logn, round, d, z,
					(size_t)1 << (logn - 1), NULL)) {
				return 1;
			}
			checks ++;

			vect_iFFT_fixed(logn, a);
			vect_iFFT_fp64(logn, x);
			if (!compare_vector("iFFT", logn, round, a, x, n, NULL)) {
				return 1;
			}
			checks ++;
			vect_iFFT(logn, u);
			if (!compare_vector("iFFT-fused2", logn, round,
					a, u, n, NULL)) {
				return 1;
			}
			checks ++;
		}
	}

	printf("PASS checks=%u kernels=FFT,FFT-fused2,invnorm,iFFT,iFFT-fused2 logn=2..10 "
		"rounds=100\n", checks);
	return 0;
}
