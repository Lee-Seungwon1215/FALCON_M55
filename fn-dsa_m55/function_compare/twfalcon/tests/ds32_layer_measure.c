/* Layer diagnosis only: same input and buffer address for all three paths. */
#include "ds32_layer_profile.h"
#include <cmsis_core.h>
#include <inttypes.h>
#include <stdio.h>
#include <string.h>

#define LAYER_WARMUP 10
#define LAYER_SAMPLES 100

static uint32_t
now(void)
{
	__DSB();
	__ISB();
	return DWT->CYCCNT;
}

static uint32_t
next_input(uint64_t *state)
{
	*state ^= *state << 13;
	*state ^= *state >> 7;
	*state ^= *state << 17;
	return (uint32_t)*state;
}

static uint32_t __attribute__((noinline))
time_transform(unsigned logn, unsigned inverse, unsigned variant,
	tw32_fft *work, ds32_layer_trace *trace)
{
	uint32_t primask = __get_PRIMASK();
	__disable_irq();
	uint32_t stamp = now();
	if (variant == 0) {
		if (inverse) ds32_ifft_mve(logn, work);
		else ds32_fft_mve(logn, work);
	} else if (variant == 1) {
		if (inverse) ds32_layer_control_ifft(logn, work);
		else ds32_layer_control_fft(logn, work);
	} else {
		if (inverse) ds32_layer_profile_ifft(logn, work, trace);
		else ds32_layer_profile_fft(logn, work, trace);
	}
	uint32_t elapsed = now() - stamp;
	if (!primask) __enable_irq();
	return elapsed;
}

unsigned
ds32_layer_measure(tw32_fft *work, tw32_fft *expected, uint64_t *input)
{
	/* Independent RNG: adding this test does not change the old test inputs. */
	uint64_t state = UINT64_C(0xb64f82447d8a21c9);
	unsigned mismatches = 0, comparisons = 0, accounting_errors = 0;
	ds32_layer_init();
	uint32_t floor_min = UINT32_MAX, floor_max = 0;
	uint64_t floor_sum = 0;
	for (unsigned k = 0; k < LAYER_SAMPLES; k ++) {
		uint32_t primask = __get_PRIMASK();
		__disable_irq();
		uint32_t stamp = now();
		uint32_t elapsed = now() - stamp;
		if (!primask) __enable_irq();
		if (elapsed < floor_min) floor_min = elapsed;
		if (elapsed > floor_max) floor_max = elapsed;
		floor_sum += elapsed;
	}
	printf("DS_LAYER_BEGIN samples=%u warmup=%u irq=masked input=Q32_INTEGER_FRACTION inverse_input=FFT_OUTPUT comparison=ALL_BYTES\n",
		LAYER_SAMPLES, LAYER_WARMUP);
	printf("DS_LAYER_TIMER samples=%u sum=%" PRIu64 " min=%u max=%u\n",
		LAYER_SAMPLES, floor_sum, floor_min, floor_max);
	for (unsigned logn = 9; logn <= 10; logn ++) {
		for (unsigned inverse = 0; inverse < 2; inverse ++) {
			uint64_t total[3] = {0}, layers[10] = {0};
			uint64_t scaling = 0, other = 0;
			uint32_t lo[3] = {UINT32_MAX, UINT32_MAX, UINT32_MAX};
			uint32_t hi[3] = {0};
			unsigned before = mismatches;
			const char *dir = inverse ? "ifft" : "fft";
			for (unsigned sample = 0; sample < LAYER_WARMUP + LAYER_SAMPLES; sample ++) {
				for (unsigned u = 0; u < (1u << logn); u ++) {
					int32_t integer = (int32_t)(next_input(&state) % 2049) - 1024;
					input[u] = ((uint64_t)(int64_t)integer << 32)
						| next_input(&state);
				}
				/* Cycle through all six execution-order permutations. */
				static const unsigned order[6][3] = {
					{0,1,2}, {2,1,0}, {1,2,0}, {0,2,1}, {2,0,1}, {1,0,2}
				};
				for (unsigned pos = 0; pos < 3; pos ++) {
					unsigned variant = order[sample % 6][pos];
					ds32_layer_trace trace = {{0}, 0};
					/* Include inactive planes/lanes in the equality check. */
					memset(work, 0xA5, sizeof *work);
					ds32_from_q32(logn, work, input);
					if (inverse) ds32_fft_mve(logn, work);
					uint32_t elapsed = time_transform(logn, inverse, variant, work, &trace);
					if (pos == 0) memcpy(expected, work, sizeof *work);
					else {
						mismatches += memcmp(expected, work, sizeof *work) != 0;
						comparisons ++;
					}
					if (sample < LAYER_WARMUP) continue;
					total[variant] += elapsed;
					if (elapsed < lo[variant]) lo[variant] = elapsed;
					if (elapsed > hi[variant]) hi[variant] = elapsed;
					if (variant == 2) {
						uint64_t measured = trace.scaling;
						for (unsigned lm = 1; lm < logn; lm ++) {
							layers[lm] += trace.cycles[lm];
							measured += trace.cycles[lm];
						}
						scaling += trace.scaling;
						if (measured > elapsed) accounting_errors ++;
						else other += elapsed - measured;
					}
				}
			}
			printf("DS_LAYER_TOTAL logn=%u dir=%s calls=%u original=%" PRIu64
				" control=%" PRIu64 " profiled=%" PRIu64 " other=%" PRIu64 " mismatches=%u\n",
				logn, dir, LAYER_SAMPLES, total[0], total[1], total[2], other, mismatches-before);
			for (unsigned v = 0; v < 3; v ++) {
				printf("DS_LAYER_RANGE logn=%u dir=%s variant=%u min=%u max=%u\n",
					logn, dir, v, lo[v], hi[v]);
			}
			for (unsigned step = 1; step < logn; step ++) {
				unsigned lm = inverse ? logn - step : step;
				printf("DS_LAYER logn=%u dir=%s lm=%u order=%u ht=%u groups=%u calls=%u cycles=%" PRIu64 "\n",
					logn, dir, lm, step, 1u << (logn-lm-1), 1u << (lm-1),
					LAYER_SAMPLES, layers[lm]);
			}
			printf("DS_LAYER_SCALE logn=%u dir=%s calls=%u cycles=%" PRIu64 "\n",
				logn, dir, LAYER_SAMPLES, scaling);
		}
	}
	printf("DS_LAYER_DONE cases=%u mismatches=%u accounting_errors=%u\n",
		comparisons, mismatches, accounting_errors);
	return mismatches + accounting_errors;
}
