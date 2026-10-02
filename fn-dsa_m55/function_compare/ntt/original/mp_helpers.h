#pragma once
#include <stdint.h>
#include <stddef.h>
#define FNDSA_ASM_CORTEXM4 1

static inline uint32_t
tbmask(uint32_t x)
{
	return (uint32_t)(*(int32_t *)&x >> 31);
}

static inline uint32_t
mp_R(uint32_t p)
{
	/* Since 2*p < 2^32 < 3*p, we just return 2^32 - 2*p. */
	return -(p << 1);
}

static inline uint32_t
mp_hR(uint32_t p)
{
	/* Since p < 2^31 < (3/2)*p, we just return 2^31 - p. */
	return ((uint32_t)1 << 31) - p;
}

static inline uint32_t
mp_add(uint32_t a, uint32_t b, uint32_t p)
{
	uint32_t d = a + b - p;
	return d + (p & tbmask(d));
}

static inline uint32_t
mp_sub(uint32_t a, uint32_t b, uint32_t p)
{
	uint32_t d = a - b;
	return d + (p & tbmask(d));
}

static inline uint32_t
mp_half(uint32_t a, uint32_t p)
{
#if FNDSA_ASM_CORTEXM4
	uint32_t t;
	__asm__(
		"ubfx	%1, %0, #0, #1\n\t"
		"umlal	%0, %1, %1, %2\n\t"
		"lsr.w	%0, %0, #1"
		: "+r" (a), "=&r" (t)
		: "r" (p));
	return a;
#else
	return (a + (p & -(a & 1))) >> 1;
#endif
}

static inline uint32_t
mp_mmul(uint32_t a, uint32_t b, uint32_t p, uint32_t p0i)
{
#if FNDSA_ASM_CORTEXM4
	uint32_t d;
	__asm__(
		"umull	%0, %2, %0, %1\n\t"
		"mul	%1, %0, %4\n\t"
		"umlal	%0, %2, %1, %3\n\t"
		"sub.w	%2, %2, %3\n\t"
		"and	%0, %3, %2, asr #31\n\t"
		"add.w	%2, %2, %0"
		: "+r" (a), "+r" (b), "=&r" (d)
		: "r" (p), "r" (p0i));
	return d;
#else
	uint64_t z = (uint64_t)a * (uint64_t)b;
	uint32_t w = (uint32_t)z * p0i;
	uint32_t d = (uint32_t)((z + (uint64_t)w * (uint64_t)p) >> 32) - p;
	return d + (p & tbmask(d));
#endif
}
