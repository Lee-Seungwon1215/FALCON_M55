/*
 * Compact, paired FN-DSA key-generation benchmark for NUCLEO-N657X0-Q.
 *
 * All compared source trees use this exact file.  Ten public seeds are each
 * measured ten times (100 calls/degree); input generation, output checks and
 * printing stay outside the timed interval.
 */
#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include "inner.h"
#include <zephyr/kernel.h>
#include <cmsis_core.h>
#include <stm32n6xx.h>

#define BATCHES 10
#define ITERATIONS 10

static uint8_t sk[FNDSA_SIGN_KEY_SIZE(10)];
static uint8_t pk[FNDSA_VRFY_KEY_SIZE(10)];
static uint8_t tmp[22 * 1024 + 31] __attribute__((aligned(32)));
static uint64_t totals[2][BATCHES];

static void
make_seed(uint8_t seed[32], unsigned logn, unsigned batch)
{
	shake_context sc;
	uint8_t tag[4] = {
		0x46, 0x50, (uint8_t)logn, (uint8_t)batch
	};
	shake_init(&sc, 256);
	shake_inject(&sc, tag, sizeof tag);
	shake_flip(&sc);
	shake_extract(&sc, seed, 32);
}

static void
sort_u64(uint64_t *a, unsigned n)
{
	for (unsigned i = 1; i < n; i ++) {
		uint64_t x = a[i];
		unsigned j = i;
		while (j > 0 && a[j - 1] > x) {
			a[j] = a[j - 1];
			j --;
		}
		a[j] = x;
	}
}

int
mlk_test_main(int argc, char **argv)
{
	(void)argc;
	(void)argv;
	uint32_t tcm = *(volatile uint32_t *)0x56008008;
	printf("API_PERF_HW cpu=%u ccr=%08x tcm=%08x fpscr=%08x "
		"batches=%u iterations=%u\n", (unsigned)SystemCoreClock,
		(unsigned)SCB->CCR, (unsigned)tcm, (unsigned)__get_FPSCR(),
		BATCHES, ITERATIONS);
	if (SystemCoreClock != 800000000u || (SCB->CCR & 0x30000u)
		|| tcm != 0x99u || (__get_FPSCR() & 0x1C00000u))
	{
		return 10;
	}

	for (unsigned logn = 9; logn <= 10; logn ++) {
		size_t n = (size_t)1 << logn;
		for (unsigned batch = 0; batch < BATCHES; batch ++) {
			uint8_t seed[32];
			make_seed(seed, logn, batch);
			if (!fndsa_keygen_seeded_temp(logn, seed, sizeof seed,
				sk, pk, tmp, 22 * n + 31))
			{
				return 20;
			}
			uint64_t begin = k_cycle_get_64();
			unsigned ok = 1;
			for (unsigned j = 0; j < ITERATIONS; j ++) {
				ok &= fndsa_keygen_seeded_temp(logn, seed,
					sizeof seed, sk, pk, tmp, 22 * n + 31);
			}
			uint64_t elapsed = k_cycle_get_64() - begin;
			if (!ok) {
				return 21;
			}
			totals[logn - 9][batch] = elapsed;
			printf("API_PERF degree=%u batch=%u total=%llu per_call=%llu\n",
				1u << logn, batch, (unsigned long long)elapsed,
				(unsigned long long)(elapsed / ITERATIONS));
		}
		sort_u64(totals[logn - 9], BATCHES);
		printf("API_PERF_SUMMARY degree=%u upper_median=%llu min=%llu "
			"max=%llu calls=%u\n", 1u << logn,
			(unsigned long long)(totals[logn - 9][BATCHES / 2]
				/ ITERATIONS),
			(unsigned long long)(totals[logn - 9][0] / ITERATIONS),
			(unsigned long long)(totals[logn - 9][BATCHES - 1]
				/ ITERATIONS), BATCHES * ITERATIONS);
	}
	printf("API_PERF_DONE result=0\n");
	return 0;
}
