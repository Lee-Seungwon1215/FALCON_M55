#include "profile.h"

#include <stdio.h>
#include <string.h>

struct ntru_profile_stats ntru_profile_stats[2];
volatile uint32_t profile_error;

static unsigned active, degree_index;
static unsigned current_phase, current_kernel;
static unsigned phase_stack[16], phase_depth;
static unsigned kernel_stack[32], kernel_depth;
static uint64_t previous, started, high;
static uint32_t last_low;

static uint64_t
ticks(void)
{
	uint32_t low = *(volatile uint32_t *)0xE0001004;
	if (low < last_low) {
		high += UINT64_C(1) << 32;
	}
	last_low = low;
	return high | low;
}

static void
account(uint64_t now)
{
	uint64_t elapsed = now - previous;
	struct ntru_profile_stats *s = &ntru_profile_stats[degree_index];
	s->phase_ticks[current_phase] += elapsed;
	s->kernel_ticks[current_kernel] += elapsed;
	previous = now;
}

void
profile_clock_init(void)
{
	*(volatile uint32_t *)0xE000EDFC |= 1u << 24;
	*(volatile uint32_t *)0xE0001FB0 = 0xC5ACCE55;
	*(volatile uint32_t *)0xE0001004 = 0;
	*(volatile uint32_t *)0xE0001000 |= 1;
	last_low = 0;
	high = 0;
}

void
profile_reset(void)
{
	memset(ntru_profile_stats, 0, sizeof ntru_profile_stats);
	active = phase_depth = kernel_depth = 0;
	profile_error = 0;
}

unsigned
profile_ntru_enter(unsigned logn)
{
	if (active || logn < 9 || logn > 10) {
		profile_error |= 1;
		return 0;
	}
	degree_index = logn - 9;
	current_phase = PHASE_ORCHESTRATION;
	current_kernel = KERNEL_OTHER;
	phase_depth = kernel_depth = 0;
	active = 1;
	previous = started = ticks();
	return 1;
}

void
profile_ntru_leave(unsigned *entered)
{
	if (!*entered) {
		return;
	}
	if (!active || phase_depth != 0 || kernel_depth != 0) {
		profile_error |= 2;
		return;
	}
	uint64_t now = ticks();
	account(now);
	struct ntru_profile_stats *s = &ntru_profile_stats[degree_index];
	uint64_t elapsed = now - started;
	s->total += elapsed;
	if (s->calls == 0 || elapsed < s->minimum) {
		s->minimum = elapsed;
	}
	if (elapsed > s->maximum) {
		s->maximum = elapsed;
	}
	s->calls ++;
	active = 0;

	uint64_t phase_sum = 0, kernel_sum = 0;
	for (unsigned i = 0; i < PHASE_COUNT; i ++) {
		phase_sum += s->phase_ticks[i];
	}
	for (unsigned i = 0; i < KERNEL_COUNT; i ++) {
		kernel_sum += s->kernel_ticks[i];
	}
	if (phase_sum != s->total || kernel_sum != s->total) {
		profile_error |= 4;
	}
}

unsigned
profile_phase_enter(unsigned phase)
{
	if (!active) {
		return 0;
	}
	if (phase >= PHASE_COUNT || phase_depth >= 16) {
		profile_error |= 8;
		return 0;
	}
	account(ticks());
	phase_stack[phase_depth ++] = current_phase;
	current_phase = phase;
	ntru_profile_stats[degree_index].phase_entries[phase] ++;
	return 1;
}

void
profile_phase_leave(unsigned *entered)
{
	if (!*entered) {
		return;
	}
	if (!active || phase_depth == 0) {
		profile_error |= 16;
		return;
	}
	account(ticks());
	current_phase = phase_stack[-- phase_depth];
}

unsigned
profile_kernel_enter(unsigned kernel)
{
	if (!active) {
		return 0;
	}
	if (kernel >= KERNEL_COUNT || kernel_depth >= 32) {
		profile_error |= 32;
		return 0;
	}
	account(ticks());
	kernel_stack[kernel_depth ++] = current_kernel;
	current_kernel = kernel;
	ntru_profile_stats[degree_index].kernel_entries[kernel] ++;
	return 1;
}

void
profile_kernel_leave(unsigned *entered)
{
	if (!*entered) {
		return;
	}
	if (!active || kernel_depth == 0) {
		profile_error |= 64;
		return;
	}
	account(ticks());
	current_kernel = kernel_stack[-- kernel_depth];
}

struct ntru_ntt_logn_scope
profile_ntt_logn_enter(unsigned direction, unsigned logn)
{
	struct ntru_ntt_logn_scope scope = { 0, 0, 0, 0 };
	if (!active) {
		return scope;
	}
	if (direction >= NTT_DIRECTION_COUNT || logn >= NTT_LOGN_COUNT) {
		profile_error |= 128;
		return scope;
	}
	scope.started = *(volatile uint32_t *)0xE0001004;
	scope.direction = (uint8_t)direction;
	scope.logn = (uint8_t)logn;
	scope.entered = 1;
	ntru_profile_stats[degree_index].ntt_logn_entries[direction][logn] ++;
	return scope;
}

void
profile_ntt_logn_leave(struct ntru_ntt_logn_scope *scope)
{
	if (!scope->entered) {
		return;
	}
	uint32_t now = *(volatile uint32_t *)0xE0001004;
	ntru_profile_stats[degree_index]
		.ntt_logn_ticks[scope->direction][scope->logn] +=
		(uint32_t)(now - scope->started);
}

static const char *const phase_names[PHASE_COUNT] = {
	"orchestration", "deepest", "intermediate_d1", "intermediate_d2",
	"intermediate_d3", "intermediate_d4", "intermediate_d5",
	"intermediate_d6", "intermediate_d7", "intermediate_d8",
	"intermediate_d9", "depth0"
};

static const char *const kernel_names[KERNEL_COUNT] = {
	"other", "mp_ntt", "mp_intt", "twiddle", "crt", "bezout",
	"fft", "ifft", "fxp_spectral", "fixed_convert", "sub_ntt",
	"sub_depth1", "sub_plain"
};

void
profile_report(void)
{
	for (unsigned d = 0; d < 2; d ++) {
		struct ntru_profile_stats *s = &ntru_profile_stats[d];
		printf("NTRU_TOTAL degree=%u calls=%u total=%llu min=%llu max=%llu\n",
			d ? 1024 : 512, s->calls, (unsigned long long)s->total,
			(unsigned long long)s->minimum, (unsigned long long)s->maximum);
		for (unsigned i = 0; i < PHASE_COUNT; i ++) {
			printf("NTRU_PHASE degree=%u phase=%s cycles=%llu entries=%u\n",
				d ? 1024 : 512, phase_names[i],
				(unsigned long long)s->phase_ticks[i], s->phase_entries[i]);
		}
		for (unsigned i = 0; i < KERNEL_COUNT; i ++) {
			printf("NTRU_KERNEL degree=%u kernel=%s cycles=%llu entries=%u\n",
				d ? 1024 : 512, kernel_names[i],
				(unsigned long long)s->kernel_ticks[i], s->kernel_entries[i]);
		}
		for (unsigned direction = 0; direction < NTT_DIRECTION_COUNT;
			direction ++)
		{
			for (unsigned logn = 0; logn < NTT_LOGN_COUNT; logn ++) {
				printf("NTRU_NTT_LOGN degree=%u direction=%s logn=%u "
					"cycles=%llu entries=%u\n",
					d ? 1024 : 512, direction ? "inverse" : "forward",
					logn,
					(unsigned long long)s->ntt_logn_ticks[direction][logn],
					s->ntt_logn_entries[direction][logn]);
			}
		}
	}
}
