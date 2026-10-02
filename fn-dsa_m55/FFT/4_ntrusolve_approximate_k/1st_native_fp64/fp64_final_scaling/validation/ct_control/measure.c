#include "measure.h"
#include <stdio.h>
#include <string.h>
static uint32_t started;
static uint64_t cycles[2][11];
static uint32_t calls[2][11];
void approx_begin(unsigned kind, unsigned logn)
{
	(void)kind; (void)logn;
	started = *(volatile uint32_t *)0xE0001004;
}
void approx_end(unsigned kind, unsigned logn)
{
	uint32_t elapsed = *(volatile uint32_t *)0xE0001004 - started;
	cycles[kind][logn] += elapsed;
	calls[kind][logn] ++;
}
void approx_reset(void)
{
	memset(cycles, 0, sizeof cycles);
	memset(calls, 0, sizeof calls);
}
void approx_report(unsigned logn)
{
	for (unsigned kind = 0; kind < 2; kind ++) {
		for (unsigned l = 1; l < logn; l ++) {
			printf("APPROX degree=%u kind=%u logn=%u calls=%u cycles=%llu\n",
				1u << logn, kind, l, (unsigned)calls[kind][l],
				(unsigned long long)cycles[kind][l]);
		}
	}
}
