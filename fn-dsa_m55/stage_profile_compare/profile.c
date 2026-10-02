#include "profile.h"
#include <stdio.h>
#include <string.h>

struct profile_stats profile_stats[2][OP_COUNT];
volatile uint32_t profile_error;
static unsigned category_stack[32], depth, current_degree, current_operation;
static unsigned current_category, active;
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
	memset(profile_stats, 0, sizeof profile_stats);
	active = depth = 0;
	profile_error = 0;
}

void
profile_begin(unsigned degree_index, unsigned operation)
{
	if (active || degree_index >= 2 || operation >= OP_COUNT) {
		profile_error |= 1;
		return;
	}
	current_degree = degree_index;
	current_operation = operation;
	current_category = CAT_OTHER;
	depth = 0;
	active = 1;
	previous = started = ticks();
}

void
profile_switch(unsigned next)
{
	if (!active) {
		return;
	}
	if (depth != 0 || next >= CAT_COUNT) {
		profile_error |= 2;
		return;
	}
	uint64_t now = ticks();
	struct profile_stats *s = &profile_stats[current_degree][current_operation];
	s->ticks[current_category] += now - previous;
	current_category = next;
	s->entries[next] ++;
	previous = now;
}

unsigned
profile_enter(unsigned next)
{
	if (!active) {
		return 0;
	}
	if (depth == 32 || next >= CAT_COUNT) {
		profile_error |= 4;
		return 0;
	}
	uint64_t now = ticks();
	struct profile_stats *s = &profile_stats[current_degree][current_operation];
	s->ticks[current_category] += now - previous;
	category_stack[depth ++] = current_category;
	current_category = next;
	s->entries[next] ++;
	previous = now;
	return 1;
}

void
profile_leave(unsigned *entered)
{
	if (!*entered) {
		return;
	}
	if (!active || depth == 0) {
		profile_error |= 8;
		return;
	}
	uint64_t now = ticks();
	profile_stats[current_degree][current_operation].ticks[current_category]
		+= now - previous;
	current_category = category_stack[-- depth];
	previous = now;
}

void
profile_end(void)
{
	if (!active || depth != 0) {
		profile_error |= 16;
		return;
	}
	uint64_t now = ticks();
	struct profile_stats *s = &profile_stats[current_degree][current_operation];
	uint64_t elapsed = now - started;
	s->ticks[current_category] += now - previous;
	s->total += elapsed;
	if (s->calls == 0 || elapsed < s->minimum) {
		s->minimum = elapsed;
	}
	if (elapsed > s->maximum) {
		s->maximum = elapsed;
	}
	s->calls ++;
	active = 0;
	uint64_t sum = 0;
	for (unsigned i = 0; i < CAT_COUNT; i ++) {
		sum += s->ticks[i];
	}
	if (sum != s->total) {
		profile_error |= 32;
	}
}

static const char *const category_names[CAT_COUNT] = {
	"other",
	"kg_generate", "kg_check", "kg_ntru", "kg_sk_complete", "kg_pk_compute",
	"sg_message_hash", "sg_key_prep", "sg_hash_to_point", "sg_fft_basis",
	"sg_ldl_ffsampling", "sg_gaussian_berexp", "sg_recon_norm", "sg_encode",
	"vr_message_hash", "vr_decode", "vr_ntt", "vr_hash_to_point",
	"vr_poly", "vr_norm"
};
static const char *const operation_names[OP_COUNT] = {
	"keygen", "sign", "verify"
};

void
profile_report(void)
{
	for (unsigned d = 0; d < 2; d ++) {
		for (unsigned op = 0; op < OP_COUNT; op ++) {
			struct profile_stats *s = &profile_stats[d][op];
			printf("PROFILE_TOTAL degree=%u operation=%s calls=%u total=%llu min=%llu max=%llu\n",
				d ? 1024 : 512, operation_names[op], s->calls,
				(unsigned long long)s->total, (unsigned long long)s->minimum,
				(unsigned long long)s->maximum);
			for (unsigned c = 0; c < CAT_COUNT; c ++) {
				printf("PROFILE_CATEGORY degree=%u operation=%s category=%s cycles=%llu entries=%u\n",
					d ? 1024 : 512, operation_names[op], category_names[c],
					(unsigned long long)s->ticks[c], s->entries[c]);
			}
		}
	}
}
