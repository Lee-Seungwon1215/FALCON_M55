/*
 * Direct M55 comparison of the unchanged fixed-point kernels and the first
 * scalar native-FP64/Q32-compatible kernels.  Input preparation, conversion,
 * copying and printing are outside the timed regions.
 */
#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include "kgen_inner.h"
#include <cmsis_core.h>
#include <stm32n6xx.h>

#define NMAX   1024
#define ROUNDS 100

static fxr ref_a[NMAX] __attribute__((aligned(32)));
static fxr ref_b[NMAX] __attribute__((aligned(32)));
static fxr ref_d[NMAX / 2] __attribute__((aligned(32)));
static fxr src_a[NMAX] __attribute__((aligned(32)));
static fxr src_b[NMAX] __attribute__((aligned(32)));
static double fp_a[NMAX] __attribute__((aligned(32)));
static double fp_b[NMAX] __attribute__((aligned(32)));
static double fp_fused[NMAX] __attribute__((aligned(32)));
static double fp_d[NMAX / 2] __attribute__((aligned(32)));
static double fp_src_a[NMAX] __attribute__((aligned(32)));
static double fp_src_b[NMAX] __attribute__((aligned(32)));
static volatile uint64_t sink;
static uint64_t rng_state = UINT64_C(0x6a09e667f3bcc909);

struct stats {
	uint32_t min;
	uint32_t max;
	uint64_t sum;
};

static uint32_t
prng32(void)
{
	rng_state ^= rng_state << 13;
	rng_state ^= rng_state >> 7;
	rng_state ^= rng_state << 17;
	return (uint32_t)rng_state;
}

static double
raw_to_fp64(uint64_t x)
{
	return (double)(int32_t)(x >> 32)
		+ (double)(uint32_t)x * 0x1p-32;
}

static uint64_t
fp64_to_raw(double x)
{
	return (uint64_t)(int64_t)(x * 0x1p32);
}

static void
make_input(unsigned logn, unsigned salt)
{
	size_t n = (size_t)1 << logn;
	for (size_t i = 0; i < n; i ++) {
		int32_t x = (int32_t)(prng32() % (2u * (256u + salt) + 1u))
			- (int32_t)(256u + salt);
		int32_t y = (int32_t)(prng32() % (2u * (193u + salt) + 1u))
			- (int32_t)(193u + salt);
		src_a[i].v = (uint64_t)(int64_t)x << 32;
		src_b[i].v = (uint64_t)(int64_t)y << 32;
		fp_src_a[i] = (double)x;
		fp_src_b[i] = (double)y;
	}
}

static unsigned reported_mismatches;

enum accuracy_op {
	ACC_FFT,
	ACC_FFT_ALIAS,
	ACC_INVNORM,
	ACC_IFFT,
	ACC_IFFT_ALIAS,
	ACC_COUNT
};

struct accuracy_stat {
	const char *name;
	uint64_t coefficients;
	uint64_t mismatches;
	uint64_t max_abs_q32_lsb;
};

static struct accuracy_stat accuracy_stats[ACC_COUNT] = {
	[ACC_FFT] = { "vect_FFT_fp64", 0, 0, 0 },
	[ACC_FFT_ALIAS] = { "vect_FFT", 0, 0, 0 },
	[ACC_INVNORM] = { "vect_invnorm_fft", 0, 0, 0 },
	[ACC_IFFT] = { "vect_iFFT_fp64", 0, 0, 0 },
	[ACC_IFFT_ALIAS] = { "vect_iFFT", 0, 0, 0 }
};

static unsigned
compare(enum accuracy_op op, unsigned logn, unsigned round,
	const fxr *ref, const double *fp, size_t len)
{
	struct accuracy_stat *st = &accuracy_stats[op];
	unsigned mismatches = 0;
	st->coefficients += len;
	for (size_t i = 0; i < len; i ++) {
		uint64_t x = ref[i].v;
		uint64_t y = fp64_to_raw(fp[i]);
		if (x != y) {
			int64_t sd = (int64_t)(y - x);
			uint64_t ad = sd < 0 ? -(uint64_t)sd : (uint64_t)sd;
			if (ad > st->max_abs_q32_lsb) {
				st->max_abs_q32_lsb = ad;
			}
			if (reported_mismatches < 16) {
				printf("KERNEL_FAIL op=%s logn=%u round=%u index=%u "
					"fixed=%016llx fp64=%016llx delta=%lld\n",
					st->name, logn,
					round, (unsigned)i, (unsigned long long)x,
					(unsigned long long)y, (long long)sd);
			}
			reported_mismatches ++;
			mismatches ++;
		}
	}
	st->mismatches += mismatches;
	return mismatches;
}

static unsigned
accuracy(void)
{
	unsigned checks = 0;
	unsigned mismatches = 0;
	for (unsigned logn = 2; logn <= 10; logn ++) {
		size_t n = (size_t)1 << logn;
		size_t hn = n >> 1;
		for (unsigned round = 0; round < 100; round ++) {
			make_input(logn, round);
			memcpy(ref_a, src_a, n * sizeof *ref_a);
			memcpy(ref_b, src_b, n * sizeof *ref_b);
			memcpy(fp_a, fp_src_a, n * sizeof *fp_a);
			memcpy(fp_b, fp_src_b, n * sizeof *fp_b);
			memcpy(fp_fused, fp_src_a, n * sizeof *fp_fused);

			vect_FFT_fixed(logn, ref_a);
			vect_FFT_fp64(logn, fp_a);
			mismatches += compare(ACC_FFT, logn, round,
				ref_a, fp_a, n);
			checks ++;
			vect_FFT(logn, fp_fused);
			mismatches += compare(ACC_FFT_ALIAS, logn, round,
				ref_a, fp_fused, n);
			checks ++;

			vect_FFT_fixed(logn, ref_b);
			vect_FFT_fp64(logn, fp_b);
			vect_invnorm_fft_fixed(logn, ref_d, ref_a, ref_b, 0);
			vect_invnorm_fft_fp64(logn, fp_d, fp_a, fp_b, 0);
			mismatches += compare(ACC_INVNORM, logn, round,
				ref_d, fp_d, hn);
			checks ++;

			vect_iFFT_fixed(logn, ref_a);
			vect_iFFT_fp64(logn, fp_a);
			mismatches += compare(ACC_IFFT, logn, round,
				ref_a, fp_a, n);
			checks ++;
			vect_iFFT(logn, fp_fused);
			mismatches += compare(ACC_IFFT_ALIAS, logn, round,
				ref_a, fp_fused, n);
			checks ++;
		}
	}
	for (unsigned i = 0; i < ACC_COUNT; i ++) {
		const struct accuracy_stat *st = &accuracy_stats[i];
		printf("KERNEL_ERROR op=%s coefficients=%llu mismatches=%llu "
			"max_abs_q32_lsb=%llu\n", st->name,
			(unsigned long long)st->coefficients,
			(unsigned long long)st->mismatches,
			(unsigned long long)st->max_abs_q32_lsb);
	}
	printf("KERNEL_ACCURACY_DONE checks=%u mismatches=%u "
		"logn=2..10 rounds=100\n", checks, mismatches);
	return mismatches;
}

static inline uint32_t
now(void)
{
	__DSB();
	__ISB();
	return DWT->CYCCNT;
}

static void
add(struct stats *s, uint32_t x, unsigned first)
{
	if (first || x < s->min) {
		s->min = x;
	}
	if (first || x > s->max) {
		s->max = x;
	}
	s->sum += x;
}

/* Keep one measurement site per backend; alternating callers must not
 * become different inlined/constant-propagated timer/function sequences. */
static uint32_t __attribute__((noinline, noclone))
time_fixed(unsigned logn, unsigned op)
{
	uint32_t t = now();
	if (op == 0) vect_FFT_fixed(logn, ref_a);
	else if (op == 1) vect_iFFT_fixed(logn, ref_a);
	else vect_invnorm_fft_fixed(logn, ref_d, ref_a, ref_b, 0);
	t = now() - t;
	sink = op == 2 ? ref_d[0].v : ref_a[0].v;
	return t;
}

static uint32_t __attribute__((noinline, noclone))
time_fp64(unsigned logn, unsigned op, unsigned fused)
{
	double *a = fused ? fp_fused : fp_a;
	uint32_t t = now();
	if (op == 0) {
		if (fused) vect_FFT(logn, a);
		else vect_FFT_fp64(logn, a);
	} else if (op == 1) {
		if (fused) vect_iFFT(logn, a);
		else vect_iFFT_fp64(logn, a);
	} else {
		vect_invnorm_fft_fp64(logn, fp_d, a, fp_b, 0);
	}
	t = now() - t;
	sink = fp64_to_raw(op == 2 ? fp_d[0] : a[0]);
	return t;
}

static void
benchmark_one(unsigned logn, const char *name, unsigned op)
{
	size_t n = (size_t)1 << logn;
	struct stats fixed = { 0, 0, 0 };
	struct stats fp64 = { 0, 0, 0 };
	struct stats fused = { 0, 0, 0 };

	make_input(logn, 17);
	if (op != 0) {
		memcpy(ref_a, src_a, n * sizeof *ref_a);
		memcpy(ref_b, src_b, n * sizeof *ref_b);
		vect_FFT_fixed(logn, ref_a);
		vect_FFT_fixed(logn, ref_b);
		memcpy(src_a, ref_a, n * sizeof *src_a);
		memcpy(src_b, ref_b, n * sizeof *src_b);
		for (size_t i = 0; i < n; i ++) {
			fp_src_a[i] = raw_to_fp64(src_a[i].v);
			fp_src_b[i] = raw_to_fp64(src_b[i].v);
		}
	}

	for (unsigned r = 0; r < ROUNDS + 10; r ++) {
		uint32_t tf, td, tg;
		memcpy(ref_a, src_a, n * sizeof *ref_a);
		memcpy(ref_b, src_b, n * sizeof *ref_b);
		memcpy(fp_a, fp_src_a, n * sizeof *fp_a);
		memcpy(fp_b, fp_src_b, n * sizeof *fp_b);
		memcpy(fp_fused, fp_src_a, n * sizeof *fp_fused);
		if ((r % 3u) == 0) {
			tf = time_fixed(logn, op);
			td = time_fp64(logn, op, 0);
			tg = time_fp64(logn, op, 1);
		} else if ((r % 3u) == 1) {
			td = time_fp64(logn, op, 0);
			tg = time_fp64(logn, op, 1);
			tf = time_fixed(logn, op);
		} else {
			tg = time_fp64(logn, op, 1);
			tf = time_fixed(logn, op);
			td = time_fp64(logn, op, 0);
		}
		if (r >= 10) {
			add(&fixed, tf, r == 10);
			add(&fp64, td, r == 10);
			add(&fused, tg, r == 10);
		}
	}

	printf("KERNEL_PERF op=%s logn=%u backend=fixed count=%u "
		"min=%u max=%u sum=%llu\n", name, logn, ROUNDS,
		fixed.min, fixed.max, (unsigned long long)fixed.sum);
	printf("KERNEL_PERF op=%s logn=%u backend=fp64 count=%u "
		"min=%u max=%u sum=%llu\n", name, logn, ROUNDS,
		fp64.min, fp64.max, (unsigned long long)fp64.sum);
	printf("KERNEL_PERF op=%s logn=%u backend=public-wrapper count=%u "
		"min=%u max=%u sum=%llu\n", name, logn, ROUNDS,
		fused.min, fused.max, (unsigned long long)fused.sum);
}

/*
 * Empirical timing classes.  Array initialization and copying remain outside
 * the measured interval.  These tests can expose an input-dependent path;
 * equal samples are not a proof of constant time.
 */
static void
timing_class_input(unsigned logn, unsigned cls)
{
	size_t n = (size_t)1 << logn;
	for (size_t i = 0; i < n; i ++) {
		double s = (i & 1) ? -1.0 : 1.0;
		switch (cls) {
		case 0:
			fp_src_a[i] = 1.0;
			fp_src_b[i] = 2.0;
			break;
		case 1:
			fp_src_a[i] = s * 0.5;
			fp_src_b[i] = -s * 1.5;
			break;
		case 2:
			fp_src_a[i] = s * (double)(1u + (i & 7u)) * 0x1p-8;
			fp_src_b[i] = (double)(1u + ((i * 3u) & 7u)) * 0x1p-7;
			break;
		case 3:
			fp_src_a[i] = s * (double)(33u + (i & 15u));
			fp_src_b[i] = (double)(65u + ((i * 5u) & 15u));
			break;
		default:
			fp_src_a[i] = s * (double)(257u + (i & 31u));
			fp_src_b[i] = -s * (double)(129u + ((i * 7u) & 31u));
			break;
		}
	}
}

static void
timing_classes(unsigned logn, const char *name, unsigned op)
{
	size_t n = (size_t)1 << logn;
	for (unsigned cls = 0; cls < 5; cls ++) {
		struct stats fp = { 0, 0, 0 };
		struct stats fixed = { 0, 0, 0 };
		timing_class_input(logn, cls);
		for (size_t i = 0; i < n; i ++) {
			src_a[i].v = fp64_to_raw(fp_src_a[i]);
			src_b[i].v = fp64_to_raw(fp_src_b[i]);
		}
		for (unsigned r = 0; r < ROUNDS + 10; r ++) {
			memcpy(fp_a, fp_src_a, n * sizeof *fp_a);
			memcpy(fp_b, fp_src_b, n * sizeof *fp_b);
			memcpy(ref_a, src_a, n * sizeof *ref_a);
			memcpy(ref_b, src_b, n * sizeof *ref_b);
			uint32_t tfp, tfix;
			if ((r & 1u) == 0) {
				tfp = time_fp64(logn, op, 0);
				tfix = time_fixed(logn, op);
			} else {
				tfix = time_fixed(logn, op);
				tfp = time_fp64(logn, op, 0);
			}
			if (r >= 10) {
				add(&fp, tfp, r == 10);
				add(&fixed, tfix, r == 10);
			}
		}
		printf("CT_TIMING op=%s logn=%u class=%u count=%u "
			"min=%u max=%u sum=%llu\n", name, logn, cls, ROUNDS,
			fp.min, fp.max, (unsigned long long)fp.sum);
		printf("CT_CONTROL op=%s logn=%u class=%u count=%u "
			"min=%u max=%u sum=%llu\n", name, logn, cls, ROUNDS,
			fixed.min, fixed.max, (unsigned long long)fixed.sum);
	}
}

int
mlk_test_main(int argc, char **argv)
{
	(void)argc;
	(void)argv;
	printf("KERNEL_HW cpu=%u fpscr=%08x ccr=%08x tcm=%08x\n",
		(unsigned)SystemCoreClock, (unsigned)__get_FPSCR(),
		(unsigned)SCB->CCR, *(volatile unsigned *)0x56008008);
	if (SystemCoreClock != 800000000u || (SCB->CCR & 0x30000u)
		|| *(volatile unsigned *)0x56008008 != 0x99u
		|| (__get_FPSCR() & 0x1C00000u))
	{
		return 10;
	}
	CoreDebug->DEMCR |= CoreDebug_DEMCR_TRCENA_Msk;
	DWT->CTRL |= DWT_CTRL_CYCCNTENA_Msk;
	__disable_irq();
	unsigned mismatches = accuracy();
	for (unsigned logn = 9; logn <= 10; logn ++) {
		benchmark_one(logn, "FFT", 0);
		benchmark_one(logn, "iFFT", 1);
		benchmark_one(logn, "invnorm", 2);
	}
	timing_classes(10, "FFT", 0);
	timing_classes(10, "iFFT", 1);
	timing_classes(10, "invnorm", 2);
	printf("KERNEL_DONE result=%u mismatches=%u sink=%016llx\n",
		mismatches != 0, mismatches, (unsigned long long)sink);
	__enable_irq();
	return mismatches != 0;
}
