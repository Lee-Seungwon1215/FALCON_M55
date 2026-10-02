/*
 * Computations modulo q = 12289.
 */

#include "inner.h"

/* Modulus q = 12289 */
#define Q          12289

/* -1/q mod 2^32 */
#define Q1I   4143984639

/* 2^64 mod q */
#define R2          5664

/* Q1I split into low and high parts (16 bits each), converted to
   signed 16-bit representation. */
#define Q1Ilo   12287
#define Q1Ihi   -2304

#if FNDSA_ASM_CORTEXM4
/*
 * On the ARM Cortex-M4, we use a relaxed internal representation with
 * values in [0,q]; this makes the ext-to-int operation trivial (internal
 * representation is a superset of external representation) and allows
 * some speed-ups in the NTT.
 */

static inline uint32_t
mq_add(uint32_t x, uint32_t y)
{
	x += y - Q;
	x += Q & (x >> 16);
	return x;
}

static inline uint32_t
mq_sub(uint32_t x, uint32_t y)
{
	x -= y;
	x += Q & (x >> 16);
	return x;
}

static inline uint32_t
mq_half(uint32_t x)
{
	x += Q & -(x & 1);
	return x >> 1;
}

static inline uint32_t
mq_mred(uint32_t x)
{
	uint32_t t;
	__asm__("mul %1, %0, %3\n\tumaal %3, %0, %1, %2"
		: "+r" (x), "=&r" (t)
		: "r" (Q), "r" (Q1I));
	(void)t;
	return x;
}

#else

static inline uint32_t
mq_add(uint32_t x, uint32_t y)
{
	/* -(x+y) in [-q,+q-2] */
	x = Q - (x + y);
	/* normalize to [0,+q-1] */
	x += Q & (x >> 16);
	/* negate to get x+y in [1,q] */
	return Q - x;
}

#if FNDSA_SSE2
TARGET_SSE2
static inline __m128i
mq_add_x8(__m128i x, __m128i y)
{
	__m128i qq = _mm_set1_epi16(Q);
	__m128i a = _mm_sub_epi16(qq, _mm_add_epi16(x, y));
	__m128i b = _mm_add_epi16(a, _mm_and_si128(qq, _mm_srai_epi16(a, 15)));
	return _mm_sub_epi16(qq, b);
}
#elif FNDSA_NEON
TARGET_NEON
static inline int16x8_t
mq_add_x8(int16x8_t x, int16x8_t y)
{
	int16x8_t qq = vdupq_n_s16(Q);
	int16x8_t a = vsubq_s16(qq, vaddq_s16(x, y));
	int16x8_t b = vaddq_s16(a, vandq_s16(qq, vshrq_n_s16(a, 15)));
	return vsubq_s16(qq, b);
}
#endif

static inline uint32_t
mq_sub(uint32_t x, uint32_t y)
{
	/* -(x-y) in [-(q-1),+q-1] */
	y -= x;
	/* normalize to [0,+q-1] */
	y += Q & (y >> 16);
	/* negate to get x-y in [1,q] */
	return Q - y;
}

#if FNDSA_SSE2
TARGET_SSE2
static inline __m128i
mq_sub_x8(__m128i x, __m128i y)
{
	__m128i qq = _mm_set1_epi16(Q);
	__m128i a = _mm_sub_epi16(y, x);
	__m128i b = _mm_add_epi16(a, _mm_and_si128(qq, _mm_srai_epi16(a, 15)));
	return _mm_sub_epi16(qq, b);
}
#elif FNDSA_NEON
TARGET_NEON
static inline int16x8_t
mq_sub_x8(int16x8_t x, int16x8_t y)
{
	int16x8_t qq = vdupq_n_s16(Q);
	int16x8_t a = vsubq_s16(y, x);
	int16x8_t b = vaddq_s16(a, vandq_s16(qq, vshrq_n_s16(a, 15)));
	return vsubq_s16(qq, b);
}
#endif

static inline uint32_t
mq_half(uint32_t x)
{
	x += Q & -(x & 1);
	return x >> 1;
}

#if FNDSA_SSE2
TARGET_SSE2
static inline __m128i
mq_half_x8(__m128i x)
{
	__m128i qq = _mm_set1_epi16(Q);
	__m128i y = _mm_and_si128(x, _mm_set1_epi16(1));
	y = _mm_sub_epi16(_mm_setzero_si128(), y);
	y = _mm_and_si128(y, qq);
	return _mm_srli_epi16(_mm_add_epi16(x, y), 1);
}
#elif FNDSA_NEON
TARGET_NEON
static inline int16x8_t
mq_half_x8(int16x8_t x)
{
	int16x8_t qq = vdupq_n_s16(Q);
	int16x8_t y = vshrq_n_s16(vshlq_n_s16(x, 15), 15);
	y = vandq_s16(y, qq);
	return vreinterpretq_s16_u16(
		vshrq_n_u16(vreinterpretq_u16_s16(vaddq_s16(x, y)), 1));
}
#endif

static inline uint32_t
mq_mred(uint32_t x)
{
	x *= Q1I;
	x = (x >> 16) * Q;
	return (x >> 16) + 1;
}

#if FNDSA_SSE2

TARGET_SSE2
static inline __m128i
mq_mred_x8(__m128i lo, __m128i hi)
{
	__m128i qx8 = _mm_set1_epi16(Q);
	__m128i q1ilox8 = _mm_set1_epi16(Q1Ilo);
	__m128i q1ihix8 = _mm_set1_epi16(Q1Ihi);

	/* x <- (x * Q1I) >> 16
	   32-bit input is split into its low and high halves. Q1I is
	   itself a 32-bit constant. Product is computed modulo 2^32,
	   and we are interested only in its high 16 bits. */
	__m128i x = _mm_add_epi16(
		_mm_add_epi16(
			_mm_mulhi_epu16(lo, q1ilox8),
			_mm_mullo_epi16(lo, q1ihix8)),
		_mm_mullo_epi16(hi, q1ilox8));

	/* x <- (x * Q) >> 16
	   x and Q both fit on 16 bits each. */
	x = _mm_mulhi_epu16(x, qx8);

	/* Result is x + 1. */
	return _mm_add_epi16(x, _mm_set1_epi16(1));
}

TARGET_SSE2
static inline __m128i
mq_mmul_x8(__m128i x, __m128i y)
{
	return mq_mred_x8(_mm_mullo_epi16(x, y), _mm_mulhi_epu16(x, y));
}

#elif FNDSA_NEON

TARGET_NEON
static inline int16x8_t
mq_mmul_x8(int16x8_t a, int16x8_t b)
{
	/* Compute 32-bit products. */
	uint32x4_t c0 = vreinterpretq_u32_s32(
		vmull_s16(vget_low_s16(a), vget_low_s16(b)));
	uint32x4_t c1 = vreinterpretq_u32_s32(
		vmull_s16(vget_high_s16(a), vget_high_s16(b)));

	/* x <- (x * Q1I) >> 16, reassembled into a single word. */
	uint32x4_t q1ix8 = vdupq_n_u32(Q1I);
	c0 = vmulq_u32(c0, q1ix8);
	c1 = vmulq_u32(c1, q1ix8);
	uint16x8_t d = vuzp2q_u16(
		vreinterpretq_u16_u32(c0),
		vreinterpretq_u16_u32(c1));

	/* x <- (x * Q) >> 16
	   x and Q both fit on 16 bits each. */
	uint16x4_t qx8 = vdup_n_u16(Q);
	c0 = vmull_u16(vget_low_u16(d), qx8);
	c1 = vmull_u16(vget_high_u16(d), qx8);
	d = vuzp2q_u16(vreinterpretq_u16_u32(c0), vreinterpretq_u16_u32(c1));

	return vreinterpretq_s16_u16(vaddq_u16(d, vdupq_n_u16(1)));
}

#endif

#endif

static inline uint32_t
mq_mmul(uint32_t x, uint32_t y) {
	return mq_mred(x * y);
}

static uint32_t
mq_div(uint32_t x, uint32_t y)
{
	/* Convert y to Montgomery representation. */
	y = mq_mmul(y, R2);

	/* 1/y = y^(q-2), with a custom addition chain. */
	uint32_t y2 = mq_mmul(y, y);
	uint32_t y3 = mq_mmul(y2, y);
	uint32_t y5 = mq_mmul(y3, y2);
	uint32_t y10 = mq_mmul(y5, y5);
	uint32_t y20 = mq_mmul(y10, y10);
	uint32_t y40 = mq_mmul(y20, y20);
	uint32_t y80 = mq_mmul(y40, y40);
	uint32_t y160 = mq_mmul(y80, y80);
	uint32_t y163 = mq_mmul(y160, y3);
	uint32_t y323 = mq_mmul(y163, y160);
	uint32_t y646 = mq_mmul(y323, y323);
	uint32_t y1292 = mq_mmul(y646, y646);
	uint32_t y1455 = mq_mmul(y1292, y163);
	uint32_t y2910 = mq_mmul(y1455, y1455);
	uint32_t y5820 = mq_mmul(y2910, y2910);
	uint32_t y6143 = mq_mmul(y5820, y323);
	uint32_t y12286 = mq_mmul(y6143, y6143);
	uint32_t iy = mq_mmul(y12286, y);

	/* Multiply by the dividend (x) to get x/y. Since iy is in
	   Montgomery representation but x is in normal representation,
	   the result is in normal representation. */
	return mq_mmul(x, iy);
}

#if FNDSA_SSE2
TARGET_SSE2
static __m128i
mq_div_x8(__m128i x, __m128i y)
{
	/* Convert y to Montgomery representation. */
	y = mq_mmul_x8(y, _mm_set1_epi16(R2));

	/* 1/y = y^(q-2), with a custom addition chain. */
	__m128i y2 = mq_mmul_x8(y, y);
	__m128i y3 = mq_mmul_x8(y2, y);
	__m128i y5 = mq_mmul_x8(y3, y2);
	__m128i y10 = mq_mmul_x8(y5, y5);
	__m128i y20 = mq_mmul_x8(y10, y10);
	__m128i y40 = mq_mmul_x8(y20, y20);
	__m128i y80 = mq_mmul_x8(y40, y40);
	__m128i y160 = mq_mmul_x8(y80, y80);
	__m128i y163 = mq_mmul_x8(y160, y3);
	__m128i y323 = mq_mmul_x8(y163, y160);
	__m128i y646 = mq_mmul_x8(y323, y323);
	__m128i y1292 = mq_mmul_x8(y646, y646);
	__m128i y1455 = mq_mmul_x8(y1292, y163);
	__m128i y2910 = mq_mmul_x8(y1455, y1455);
	__m128i y5820 = mq_mmul_x8(y2910, y2910);
	__m128i y6143 = mq_mmul_x8(y5820, y323);
	__m128i y12286 = mq_mmul_x8(y6143, y6143);
	__m128i iy = mq_mmul_x8(y12286, y);

	/* Multiply by the dividend (x) to get x/y. Since iy is in
	   Montgomery representation but x is in normal representation,
	   the result is in normal representation. */
	return mq_mmul_x8(x, iy);
}
#elif FNDSA_NEON
TARGET_SSE2
static int16x8_t
mq_div_x8(int16x8_t x, int16x8_t y)
{
	/* Convert y to Montgomery representation. */
	y = mq_mmul_x8(y, vdupq_n_s16(R2));

	/* 1/y = y^(q-2), with a custom addition chain. */
	int16x8_t y2 = mq_mmul_x8(y, y);
	int16x8_t y3 = mq_mmul_x8(y2, y);
	int16x8_t y5 = mq_mmul_x8(y3, y2);
	int16x8_t y10 = mq_mmul_x8(y5, y5);
	int16x8_t y20 = mq_mmul_x8(y10, y10);
	int16x8_t y40 = mq_mmul_x8(y20, y20);
	int16x8_t y80 = mq_mmul_x8(y40, y40);
	int16x8_t y160 = mq_mmul_x8(y80, y80);
	int16x8_t y163 = mq_mmul_x8(y160, y3);
	int16x8_t y323 = mq_mmul_x8(y163, y160);
	int16x8_t y646 = mq_mmul_x8(y323, y323);
	int16x8_t y1292 = mq_mmul_x8(y646, y646);
	int16x8_t y1455 = mq_mmul_x8(y1292, y163);
	int16x8_t y2910 = mq_mmul_x8(y1455, y1455);
	int16x8_t y5820 = mq_mmul_x8(y2910, y2910);
	int16x8_t y6143 = mq_mmul_x8(y5820, y323);
	int16x8_t y12286 = mq_mmul_x8(y6143, y6143);
	int16x8_t iy = mq_mmul_x8(y12286, y);

	/* Multiply by the dividend (x) to get x/y. Since iy is in
	   Montgomery representation but x is in normal representation,
	   the result is in normal representation. */
	return mq_mmul_x8(x, iy);
}
#endif

#if FNDSA_AVX2

TARGET_AVX2
static inline __m256i
mq_add_x16(__m256i x, __m256i y)
{
	__m256i qq = _mm256_set1_epi16(Q);
	__m256i a = _mm256_sub_epi16(qq, _mm256_add_epi16(x, y));
	__m256i b = _mm256_add_epi16(a,
		_mm256_and_si256(qq, _mm256_srai_epi16(a, 15)));
	return _mm256_sub_epi16(qq, b);
}

TARGET_AVX2
static inline __m256i
mq_sub_x16(__m256i x, __m256i y)
{
	__m256i qq = _mm256_set1_epi16(Q);
	__m256i a = _mm256_sub_epi16(y, x);
	__m256i b = _mm256_add_epi16(a,
		_mm256_and_si256(qq, _mm256_srai_epi16(a, 15)));
	return _mm256_sub_epi16(qq, b);
}

TARGET_AVX2
static inline __m256i
mq_half_x16(__m256i x)
{
	__m256i qq = _mm256_set1_epi16(Q);
	__m256i y = _mm256_and_si256(x, _mm256_set1_epi16(1));
	y = _mm256_sub_epi16(_mm256_setzero_si256(), y);
	y = _mm256_and_si256(y, qq);
	y = _mm256_add_epi16(x, y);
	return _mm256_srli_epi16(y, 1);
}

TARGET_AVX2
static inline __m256i
mq_mred_x16(__m256i lo, __m256i hi)
{
	__m256i qx16 = _mm256_set1_epi16(Q);
	__m256i q1ilox16 = _mm256_set1_epi16(Q1Ilo);
	__m256i q1ihix16 = _mm256_set1_epi16(Q1Ihi);

	/* x <- (x * Q1I) >> 16
	   32-bit input is split into its low and high halves. Q1I is
	   itself a 32-bit constant. Product is computed modulo 2^32,
	   and we are interested only in its high 16 bits. */
	__m256i x = _mm256_add_epi16(
		_mm256_add_epi16(
			_mm256_mulhi_epu16(lo, q1ilox16),
			_mm256_mullo_epi16(lo, q1ihix16)),
		_mm256_mullo_epi16(hi, q1ilox16));

	/* x <- (x * Q) >> 16
	   x and Q both fit on 16 bits each. */
	x = _mm256_mulhi_epu16(x, qx16);

	/* Result is x + 1. */
	return _mm256_add_epi16(x, _mm256_set1_epi16(1));
}

TARGET_AVX2
static inline __m256i
mq_mmul_x16(__m256i x, __m256i y)
{
	return mq_mred_x16(_mm256_mullo_epi16(x, y), _mm256_mulhi_epu16(x, y));
}

TARGET_AVX2
static __m256i
mq_div_x16(__m256i x, __m256i y)
{
	/* Convert y to Montgomery representation. */
	y = mq_mmul_x16(y, _mm256_set1_epi16(R2));

	/* 1/y = y^(q-2), with a custom addition chain. */
	__m256i y2 = mq_mmul_x16(y, y);
	__m256i y3 = mq_mmul_x16(y2, y);
	__m256i y5 = mq_mmul_x16(y3, y2);
	__m256i y10 = mq_mmul_x16(y5, y5);
	__m256i y20 = mq_mmul_x16(y10, y10);
	__m256i y40 = mq_mmul_x16(y20, y20);
	__m256i y80 = mq_mmul_x16(y40, y40);
	__m256i y160 = mq_mmul_x16(y80, y80);
	__m256i y163 = mq_mmul_x16(y160, y3);
	__m256i y323 = mq_mmul_x16(y163, y160);
	__m256i y646 = mq_mmul_x16(y323, y323);
	__m256i y1292 = mq_mmul_x16(y646, y646);
	__m256i y1455 = mq_mmul_x16(y1292, y163);
	__m256i y2910 = mq_mmul_x16(y1455, y1455);
	__m256i y5820 = mq_mmul_x16(y2910, y2910);
	__m256i y6143 = mq_mmul_x16(y5820, y323);
	__m256i y12286 = mq_mmul_x16(y6143, y6143);
	__m256i iy = mq_mmul_x16(y12286, y);

	/* Multiply by the dividend (x) to get x/y. Since iy is in
	   Montgomery representation but x is in normal representation,
	   the result is in normal representation. */
	return mq_mmul_x16(x, iy);
}

#endif

#if !FNDSA_ASM_CORTEXM4
/* see inner.h */
TARGET_SSE2
void
mqpoly_small_to_int(unsigned logn, const int8_t *f, uint16_t *d)
{
	size_t n = (size_t)1 << logn;
#if FNDSA_SSE2
	if (logn >= 4) {
		const __m128i *fp = (const __m128i *)f;
		__m128i *dp = (__m128i *)d;
		__m128i qq = _mm_set1_epi16(Q);
		for (size_t i = 0; i < (1u << (logn - 4)); i ++) {
			__m128i x = _mm_loadu_si128(fp + i);
			x = _mm_sub_epi8(_mm_setzero_si128(), x);
			__m128i x0 = _mm_srai_epi16(
				_mm_unpacklo_epi8(_mm_setzero_si128(), x), 8);
			__m128i x1 = _mm_srai_epi16(
				_mm_unpackhi_epi8(_mm_setzero_si128(), x), 8);
			x0 = _mm_add_epi16(x0,
				_mm_and_si128(_mm_srai_epi16(x0, 15), qq));
			x1 = _mm_add_epi16(x1,
				_mm_and_si128(_mm_srai_epi16(x1, 15), qq));
			x0 = _mm_sub_epi16(qq, x0);
			x1 = _mm_sub_epi16(qq, x1);
			_mm_storeu_si128(dp + (i << 1) + 0, x0);
			_mm_storeu_si128(dp + (i << 1) + 1, x1);
		}
		return;
	}
#elif FNDSA_NEON
	if (logn >= 4) {
		int16x8_t zero = vdupq_n_s16(0);
		int16x8_t qq = vdupq_n_s16(Q);
		for (size_t i = 0; i < n; i += 16) {
			int8x16_t x = vld1q_s8(f + i);
			int16x8_t x0 = vmovl_s8(vget_low_s8(x));
			int16x8_t x1 = vmovl_s8(vget_high_s8(x));
			x0 = vaddq_s16(x0, vandq_s16(qq, vcleq_s16(x0, zero)));
			x1 = vaddq_s16(x1, vandq_s16(qq, vcleq_s16(x1, zero)));
			vst1q_s16((int16_t *)d + i, x0);
			vst1q_s16((int16_t *)d + i + 8, x1);
		}
		return;
	}
#endif
	for (size_t i = 0; i < n; i ++) {
		uint32_t x = -(uint32_t)f[i];
		d[i] = (uint16_t)(Q - (x + (Q & (x >> 16))));
	}
}
#endif

#if FNDSA_AVX2
TARGET_AVX2
void
avx2_mqpoly_small_to_int(unsigned logn, const int8_t *f, uint16_t *d)
{
	if (logn >= 4) {
		const __m128i *fp = (const __m128i *)f;
		__m128i *dp = (__m128i *)d;
		__m128i qq = _mm_set1_epi16(Q);
		for (size_t i = 0; i < (1u << (logn - 4)); i ++) {
			__m128i x = _mm_loadu_si128(fp + i);
			x = _mm_sub_epi8(_mm_setzero_si128(), x);
			__m128i x0 = _mm_cvtepi8_epi16(x);
			__m128i x1 = _mm_cvtepi8_epi16(_mm_bsrli_si128(x, 8));
			x0 = _mm_add_epi16(x0,
				_mm_and_si128(_mm_srai_epi16(x0, 15), qq));
			x1 = _mm_add_epi16(x1,
				_mm_and_si128(_mm_srai_epi16(x1, 15), qq));
			x0 = _mm_sub_epi16(qq, x0);
			x1 = _mm_sub_epi16(qq, x1);
			_mm_storeu_si128(dp + (i << 1) + 0, x0);
			_mm_storeu_si128(dp + (i << 1) + 1, x1);
		}
	} else {
		size_t n = (size_t)1 << logn;
		for (size_t i = 0; i < n; i ++) {
			uint32_t x = -(uint32_t)f[i];
			d[i] = (uint16_t)(Q - (x + (Q & (x >> 16))));
		}
	}
}
#endif

#if !FNDSA_ASM_CORTEXM4
/* see inner.h */
TARGET_SSE2
void
mqpoly_signed_to_int(unsigned logn, uint16_t *d)
{
	size_t n = (size_t)1 << logn;
#if FNDSA_SSE2
	if (logn >= 3) {
		__m128i *dp = (__m128i *)d;
		__m128i qq = _mm_set1_epi16(Q);
		for (size_t i = 0; i < (1u << (logn - 3)); i ++) {
			__m128i y = _mm_loadu_si128(dp + i);
			y = _mm_sub_epi16(_mm_setzero_si128(), y);
			y = _mm_add_epi16(y,
				_mm_and_si128(qq, _mm_srai_epi16(y, 15)));
			y = _mm_sub_epi16(qq, y);
			_mm_storeu_si128(dp + i, y);
		}
		return;
	}
#elif FNDSA_NEON
	if (logn >= 3) {
		int16x8_t zero = vdupq_n_s16(0);
		int16x8_t qq = vdupq_n_s16(Q);
		for (size_t i = 0; i < n; i += 8) {
			int16x8_t x = vld1q_s16((int16_t *)d + i);
			x = vaddq_s16(x, vandq_s16(qq, vcleq_s16(x, zero)));
			vst1q_s16((int16_t *)d + i, x);
		}
		return;
	}
#endif
	for (size_t i = 0; i < n; i ++) {
		uint32_t x = -(uint32_t)*(int16_t *)&d[i];
		d[i] = (uint16_t)(Q - (x + (Q & (x >> 16))));
	}
}
#endif

#if FNDSA_AVX2
TARGET_AVX2
void
avx2_mqpoly_signed_to_int(unsigned logn, uint16_t *d)
{
	if (logn >= 4) {
		__m256i *dp = (__m256i *)d;
		__m256i qq = _mm256_set1_epi16(Q);
		for (size_t i = 0; i < (1u << (logn - 4)); i ++) {
			__m256i y = _mm256_loadu_si256(dp + i);
			y = _mm256_sub_epi16(_mm256_setzero_si256(), y);
			y = _mm256_add_epi16(y,
				_mm256_and_si256(qq, _mm256_srai_epi16(y, 15)));
			y = _mm256_sub_epi16(qq, y);
			_mm256_storeu_si256(dp + i, y);
		}
	} else {
		size_t n = (size_t)1 << logn;
		for (size_t i = 0; i < n; i ++) {
			uint32_t x = -(uint32_t)*(int16_t *)&d[i];
			d[i] = (uint16_t)(Q - (x + (Q & (x >> 16))));
		}
	}
}
#endif

/* see inner.h */
int
mqpoly_int_to_small(unsigned logn, const uint16_t *d, int8_t *f)
{
	size_t n = (size_t)1 << logn;
	uint32_t ov = 0;
	for (size_t i = 0; i < n; i ++) {
		/* We add 128. If the value is in-range, we get an integer
		   in [1,255]; otherwise, we get an integer in [256,q]. */
		uint32_t x = mq_add(d[i], 128);
		ov |= x;
#if FNDSA_ASM_CORTEXM4
		/* In the relaxed representation, we must also reject a
		   zero here. */
		ov |= x - 1;
#endif
		x -= 128;
		f[i] = (int8_t)*(int32_t *)&x;
	}
	return (ov >> 8) == 0;
}

#if FNDSA_AVX2
TARGET_AVX2
int
avx2_mqpoly_int_to_small(unsigned logn, const uint16_t *d, int8_t *f)
{
	if (logn >= 4) {
		const __m256i *dp = (const __m256i *)d;
		__m128i *fp = (__m128i *)f;
		__m256i y128 = _mm256_set1_epi16(128);
		__m256i sm = _mm256_setr_epi8(
			0, 2, 4, 6, 8, 10, 12, 14,
			-1, -1, -1, -1, -1, -1, -1, -1,
			0, 2, 4, 6, 8, 10, 12, 14,
			-1, -1, -1, -1, -1, -1, -1, -1);
		__m256i ov = _mm256_setzero_si256();
		for (size_t i = 0; i < (1u << (logn - 4)); i ++) {
			__m256i y = _mm256_loadu_si256(dp + i);
			y = mq_add_x16(y, y128);
			ov = _mm256_or_si256(ov, y);
			y = _mm256_sub_epi16(y, y128);
			y = _mm256_shuffle_epi8(y, sm);
			y = _mm256_permute4x64_epi64(y, 0x88);
			_mm_storeu_si128(fp + i, _mm256_castsi256_si128(y));
		}
		uint32_t r = (uint32_t)_mm256_movemask_epi8(ov);
		return (r & 0xAAAAAAAA) == 0;
	} else {
		size_t n = (size_t)1 << logn;
		uint32_t ov = 0;
		for (size_t i = 0; i < n; i ++) {
			/* We add 128. If the value is in-range, we get an
			   integer in [1,255]; otherwise, we get an integer
			   in [256,q]. */
			uint32_t x = mq_add(d[i], 128);
			ov |= x;
			x -= 128;
			f[i] = (int8_t)*(int32_t *)&x;
		}
		return (ov >> 8) == 0;
	}
}
#endif

/* see inner.h */
TARGET_SSE2
void
mqpoly_int_to_signed(unsigned logn, uint16_t *d)
{
	size_t n = (size_t)1 << logn;
#if FNDSA_SSE2
	if (logn >= 3) {
		__m128i xq = _mm_set1_epi16(Q);
		__m128i xh = _mm_set1_epi16((Q - 1) >> 1);
		for (size_t i = 0; i < n; i += 8) {
			__m128i xd = _mm_loadu_si128((__m128i *)(d + i));
			xd = _mm_sub_epi16(xd,
				_mm_and_si128(xq, _mm_cmpgt_epi16(xd, xh)));
			_mm_storeu_si128((__m128i *)(d + i), xd);
		}
		return;
	}
#elif FNDSA_NEON
	if (logn >= 3) {
		int16x8_t xq = vdupq_n_s16(Q);
		int16x8_t xh = vdupq_n_s16((Q - 1) >> 1);
		for (size_t i = 0; i < n; i += 8) {
			int16x8_t xd = vld1q_s16((int16_t *)(d + i));
			xd = vsubq_s16(xd, vandq_s16(xq, vcgtq_s16(xd, xh)));
			vst1q_s16((int16_t *)(d + i), xd);
		}
		return;
	}
#endif
	for (size_t i = 0; i < n; i ++) {
		uint32_t x = d[i];
		x -= Q & ((((Q - 1) >> 1) - x) >> 16);
		d[i] = (uint16_t)x;
	}
}

#if !FNDSA_ASM_CORTEXM4
/* see inner.h */
TARGET_SSE2
void
mqpoly_ext_to_int(unsigned logn, uint16_t *d)
{
	size_t n = (size_t)1 << logn;
#if FNDSA_SSE2
	if (logn >= 3) {
		__m128i xq = _mm_set1_epi16(Q);
		for (size_t i = 0; i < n; i += 8) {
			__m128i xd = _mm_loadu_si128((__m128i *)(d + i));
			xd = _mm_or_si128(xd, _mm_and_si128(xq,
				_mm_cmpeq_epi16(xd, _mm_setzero_si128())));
			_mm_storeu_si128((__m128i *)(d + i), xd);
		}
		return;
	}
#elif FNDSA_NEON
	if (logn >= 3) {
		int16x8_t xq = vdupq_n_s16(Q);
		for (size_t i = 0; i < n; i += 8) {
			int16x8_t xd = vld1q_s16((int16_t *)(d + i));
			xd = vorrq_s16(xd, vandq_s16(xq, vceqzq_s16(xd)));
			vst1q_s16((int16_t *)(d + i), xd);
		}
		return;
	}
#endif
	for (size_t i = 0; i < n; i ++) {
		uint32_t x = d[i];
		x += Q & ((x - 1) >> 16);
		d[i] = (uint16_t)x;
	}
}
#endif

#if FNDSA_AVX2
TARGET_AVX2
void
avx2_mqpoly_ext_to_int(unsigned logn, uint16_t *d)
{
	if (logn >= 4) {
		__m256i *dp = (__m256i *)d;
		__m256i qq = _mm256_set1_epi16(Q);
		for (size_t i = 0; i < (1u << (logn - 4)); i ++) {
			__m256i y = _mm256_loadu_si256(dp + i);
			y = _mm256_add_epi16(y, _mm256_and_si256(qq,
				_mm256_cmpeq_epi16(y, _mm256_setzero_si256())));
			_mm256_storeu_si256(dp + i, y);
		}
	} else {
		size_t n = (size_t)1 << logn;
		for (size_t i = 0; i < n; i ++) {
			uint32_t x = d[i];
			x += Q & ((x - 1) >> 16);
			d[i] = (uint16_t)x;
		}
	}
}
#endif

#if !FNDSA_ASM_CORTEXM4
/* see inner.h */
TARGET_SSE2
void
mqpoly_int_to_ext(unsigned logn, uint16_t *d)
{
	size_t n = (size_t)1 << logn;
#if FNDSA_SSE2
	if (logn >= 3) {
		__m128i xq = _mm_set1_epi16(Q);
		for (size_t i = 0; i < n; i += 8) {
			__m128i xd = _mm_loadu_si128((__m128i *)(d + i));
			xd = _mm_andnot_si128(_mm_cmpeq_epi16(xd, xq), xd);
			_mm_storeu_si128((__m128i *)(d + i), xd);
		}
		return;
	}
#elif FNDSA_NEON
	if (logn >= 3) {
		int16x8_t xq = vdupq_n_s16(Q);
		for (size_t i = 0; i < n; i += 8) {
			int16x8_t xd = vld1q_s16((int16_t *)(d + i));
			xd = vandq_s16(xd, vcltq_s16(xd, xq));
			vst1q_s16((int16_t *)(d + i), xd);
		}
		return;
	}
#endif
	for (size_t i = 0; i < n; i ++) {
		uint32_t x = (uint32_t)d[i] - Q;
		x += Q & (x >> 16);
		d[i] = (uint16_t)x;
	}
}
#endif

#if FNDSA_AVX2
TARGET_AVX2
void
avx2_mqpoly_int_to_ext(unsigned logn, uint16_t *d)
{
	if (logn >= 4) {
		__m256i *dp = (__m256i *)d;
		__m256i qq = _mm256_set1_epi16(Q);
		for (size_t i = 0; i < (1u << (logn - 4)); i ++) {
			__m256i y = _mm256_loadu_si256(dp + i);
			y = _mm256_andnot_si256(_mm256_cmpeq_epi16(y, qq), y);
			_mm256_storeu_si256(dp + i, y);
		}
	} else {
		size_t n = (size_t)1 << logn;
		for (size_t i = 0; i < n; i ++) {
			uint32_t x = (uint32_t)d[i] - Q;
			x += Q & (x >> 16);
			d[i] = (uint16_t)x;
		}
	}
}
#endif

#if !FNDSA_ASM_CORTEXM4

#if FNDSA_SSE2

TARGET_SSE2
static inline void
sse2_NTT16(__m128i *a0, __m128i *a1, size_t k)
{
	__m128i xa0, xa1, xt1, xt2, xt3, xt4, xg1, xg2, xg3;
	uint16_t g1_0, g1_1;

	xa0 = *a0;
	xa1 = *a1;

	/* t = 16, m = 1 */
	xt1 = xa0;
	xt2 = mq_mmul_x8(xa1, _mm_set1_epi16(mq_GM[k]));
	xa0 = mq_add_x8(xt1, xt2);
	xa1 = mq_sub_x8(xt1, xt2);

	/* xa0:  0  1  2  3  4  5  6  7 */
	/* xa1:  8  9 10 11 12 13 14 15 */

	/* t = 8, m = 2 */
	xt1 = _mm_unpacklo_epi64(xa0, xa1);
	xt2 = _mm_unpackhi_epi64(xa0, xa1);
	g1_0 = mq_GM[(k << 1) + 0];
	g1_1 = mq_GM[(k << 1) + 1];
	xg1 = _mm_setr_epi16(g1_0, g1_0, g1_0, g1_0, g1_1, g1_1, g1_1, g1_1);
	xt2 = mq_mmul_x8(xt2, xg1);
	xa0 = mq_add_x8(xt1, xt2);
	xa1 = mq_sub_x8(xt1, xt2);

	/* xa0:  0  1  2  3  8  9 10 11 */
	/* xa1:  4  5  6  7 12 13 14 15 */

	/* t = 4, m = 4 */
	xt3 = _mm_shuffle_epi32(xa0, 0xD8);
	xt4 = _mm_shuffle_epi32(xa1, 0xD8);
	xt1 = _mm_unpacklo_epi32(xt3, xt4);
	xt2 = _mm_unpackhi_epi32(xt3, xt4);
	xg2 = _mm_setr_epi32(
		*(int32_t *)(mq_GM + (k << 2)),
		*(int32_t *)(mq_GM + (k << 2) + 2),
		0, 0);
	xg2 = _mm_unpacklo_epi16(xg2, xg2);
	xt2 = mq_mmul_x8(xt2, xg2);
	xa0 = mq_add_x8(xt1, xt2);
	xa1 = mq_sub_x8(xt1, xt2);

	/* xa0:  0  1  4  5  8  9 12 13 */
	/* xa1:  2  3  6  7 10 11 14 15 */

	/* t = 2, m = 8 */
	xt3 = _mm_unpacklo_epi16(xa0, xa1);
	xt4 = _mm_unpackhi_epi16(xa0, xa1);
	/* xt3:  0  2  1  3  4  6  5  7 */
	/* xt4:  8 10  9 11 12 14 13 15 */
	xt3 = _mm_shuffle_epi32(xt3, 0xD8);
	xt4 = _mm_shuffle_epi32(xt4, 0xD8);
	/* xt3:  0  2  4  6  1  3  5  7 */
	/* xt4:  8 10 12 14  9 11 13 15 */
	xt1 = _mm_unpacklo_epi64(xt3, xt4);
	xt2 = _mm_unpackhi_epi64(xt3, xt4);
	xg3 = _mm_loadu_si128((__m128i *)(mq_GM + (k << 3)));
	xt2 = mq_mmul_x8(xt2, xg3);
	xa0 = mq_add_x8(xt1, xt2);
	xa1 = mq_sub_x8(xt1, xt2);

	/* xa0:  0  2  4  6  8 10 12 14 */
	/* xa1:  1  3  5  7  9 11 13 15 */
	*a0 = _mm_unpacklo_epi16(xa0, xa1);
	*a1 = _mm_unpackhi_epi16(xa0, xa1);
}

/* see inner.h */
TARGET_SSE2
void
mqpoly_int_to_ntt(unsigned logn, uint16_t *d)
{
	if (logn >= 4) {
		__m128i *dp = (__m128i *)d;
		size_t n = (size_t)1 << logn;
		size_t t = n >> 3;
		for (unsigned lm = 0; lm < (logn - 4); lm ++) {
			size_t m = (size_t)1 << lm;
			size_t ht = t >> 1;
			size_t j0 = 0;
			for (size_t i = 0; i < m; i ++) {
				__m128i xs = _mm_set1_epi16(mq_GM[i + m]);
				for (size_t j = 0; j < ht; j ++) {
					size_t j1 = j0 + j;
					size_t j2 = j1 + ht;
					__m128i x1, x2;
					x1 = _mm_loadu_si128(dp + j1);
					x2 = _mm_loadu_si128(dp + j2);
					x2 = mq_mmul_x8(x2, xs);
					_mm_storeu_si128(dp + j1,
						mq_add_x8(x1, x2));
					_mm_storeu_si128(dp + j2,
						mq_sub_x8(x1, x2));
				}
				j0 += t;
			}
			t = ht;
		}
		size_t m = n >> 4;
		for (size_t i = 0; i < m; i ++) {
			__m128i xa0 = _mm_loadu_si128(dp + (i << 1) + 0);
			__m128i xa1 = _mm_loadu_si128(dp + (i << 1) + 1);
			sse2_NTT16(&xa0, &xa1, i + m);
			_mm_storeu_si128(dp + (i << 1) + 0, xa0);
			_mm_storeu_si128(dp + (i << 1) + 1, xa1);
		}
	} else {
		size_t t = (size_t)1 << logn;
		for (unsigned lm = 0; lm < logn; lm ++) {
			size_t m = (size_t)1 << lm;
			size_t ht = t >> 1;
			size_t j0 = 0;
			for (size_t i = 0; i < m; i ++) {
				uint32_t s = mq_GM[i + m];
				for (size_t j = 0; j < ht; j ++) {
					size_t j1 = j0 + j;
					size_t j2 = j1 + ht;
					uint32_t x1 = d[j1];
					uint32_t x2 = mq_mmul(d[j2], s);
					d[j1] = (uint16_t)mq_add(x1, x2);
					d[j2] = (uint16_t)mq_sub(x1, x2);
				}
				j0 += t;
			}
			t = ht;
		}
	}
}

#elif FNDSA_NEON

TARGET_NEON
static inline void
neon_NTT16(int16x8_t *a0, int16x8_t *a1, size_t k)
{
	int16x8_t xa0, xa1, xt1, xt2, xt3, xt4, xg1, xg2, xg3;
	uint16_t g1_0, g1_1;

	xa0 = *a0;
	xa1 = *a1;

	/* t = 16, m = 1 */
	xt1 = xa0;
	xt2 = mq_mmul_x8(xa1, vdupq_n_s16(mq_GM[k]));
	xa0 = mq_add_x8(xt1, xt2);
	xa1 = mq_sub_x8(xt1, xt2);

	/* xa0:  0  1  2  3  4  5  6  7 */
	/* xa1:  8  9 10 11 12 13 14 15 */

	/* t = 8, m = 2 */
	xt1 = vreinterpretq_s16_s64(vzip1q_s64(
		vreinterpretq_s64_s16(xa0),
		vreinterpretq_s64_s16(xa1)));
	xt2 = vreinterpretq_s16_s64(vzip2q_s64(
		vreinterpretq_s64_s16(xa0),
		vreinterpretq_s64_s16(xa1)));
	g1_0 = mq_GM[(k << 1) + 0];
	g1_1 = mq_GM[(k << 1) + 1];
	xg1 = vcombine_s16(vdup_n_s16(g1_0), vdup_n_s16(g1_1));
	xt2 = mq_mmul_x8(xt2, xg1);
	xa0 = mq_add_x8(xt1, xt2);
	xa1 = mq_sub_x8(xt1, xt2);

	/* xa0:  0  1  2  3  8  9 10 11 */
	/* xa1:  4  5  6  7 12 13 14 15 */

	/* t = 4, m = 4 */
	xt1 = vreinterpretq_s16_s32(vtrn1q_s32(
		vreinterpretq_s32_s16(xa0),
		vreinterpretq_s32_s16(xa1)));
	xt2 = vreinterpretq_s16_s32(vtrn2q_s32(
		vreinterpretq_s32_s16(xa0),
		vreinterpretq_s32_s16(xa1)));
	xg2 = vreinterpretq_s16_u64(
		vdupq_n_u64(*(uint64_t *)(mq_GM + (k << 2))));
	xg2 = vzip1q_s16(xg2, xg2);
	xt2 = mq_mmul_x8(xt2, xg2);
	xa0 = mq_add_x8(xt1, xt2);
	xa1 = mq_sub_x8(xt1, xt2);

	/* xa0:  0  1  4  5  8  9 12 13 */
	/* xa1:  2  3  6  7 10 11 14 15 */

	/* t = 2, m = 8 */
	xt1 = vtrn1q_s16(xa0, xa1);
	xt2 = vtrn2q_s16(xa0, xa1);
	xg3 = vld1q_s16((int16_t *)(mq_GM + (k << 3)));
	xt2 = mq_mmul_x8(xt2, xg3);
	xa0 = mq_add_x8(xt1, xt2);
	xa1 = mq_sub_x8(xt1, xt2);

	/* xa0:  0  2  4  6  8 10 12 14 */
	/* xa1:  1  3  5  7  9 11 13 15 */
	*a0 = vzip1q_s16(xa0, xa1);
	*a1 = vzip2q_s16(xa0, xa1);
}

/* see inner.h */
TARGET_NEON
void
mqpoly_int_to_ntt(unsigned logn, uint16_t *d)
{
	if (logn >= 4) {
		size_t n = (size_t)1 << logn;
		size_t t = n >> 3;
		for (unsigned lm = 0; lm < (logn - 4); lm ++) {
			size_t m = (size_t)1 << lm;
			size_t ht = t >> 1;
			size_t j0 = 0;
			for (size_t i = 0; i < m; i ++) {
				int16x8_t xs = vdupq_n_s16(mq_GM[i + m]);
				for (size_t j = 0; j < ht; j ++) {
					size_t j1 = j0 + j;
					size_t j2 = j1 + ht;
					int16x8_t x1 = vld1q_s16(
						(int16_t *)d + (j1 << 3));
					int16x8_t x2 = vld1q_s16(
						(int16_t *)d + (j2 << 3));
					x2 = mq_mmul_x8(x2, xs);
					vst1q_s16((int16_t *)d + (j1 << 3),
						mq_add_x8(x1, x2));
					vst1q_s16((int16_t *)d + (j2 << 3),
						mq_sub_x8(x1, x2));
				}
				j0 += t;
			}
			t = ht;
		}
		size_t m = n >> 4;
		for (size_t i = 0; i < m; i ++) {
			int16x8_t xa0 = vld1q_s16((int16_t *)d + (i << 4) + 0);
			int16x8_t xa1 = vld1q_s16((int16_t *)d + (i << 4) + 8);
			neon_NTT16(&xa0, &xa1, i + m);
			vst1q_s16((int16_t *)d + (i << 4) + 0, xa0);
			vst1q_s16((int16_t *)d + (i << 4) + 8, xa1);
		}
	} else {
		size_t t = (size_t)1 << logn;
		for (unsigned lm = 0; lm < logn; lm ++) {
			size_t m = (size_t)1 << lm;
			size_t ht = t >> 1;
			size_t j0 = 0;
			for (size_t i = 0; i < m; i ++) {
				uint32_t s = mq_GM[i + m];
				for (size_t j = 0; j < ht; j ++) {
					size_t j1 = j0 + j;
					size_t j2 = j1 + ht;
					uint32_t x1 = d[j1];
					uint32_t x2 = mq_mmul(d[j2], s);
					d[j1] = (uint16_t)mq_add(x1, x2);
					d[j2] = (uint16_t)mq_sub(x1, x2);
				}
				j0 += t;
			}
			t = ht;
		}
	}
}

#else

/* see inner.h */
void
mqpoly_int_to_ntt(unsigned logn, uint16_t *d)
{
	if (logn == 0) {
		return;
	}
	size_t t = (size_t)1 << logn;
	for (unsigned lm = 0; lm < logn; lm ++) {
		size_t m = (size_t)1 << lm;
		size_t ht = t >> 1;
		size_t j0 = 0;
		for (size_t i = 0; i < m; i ++) {
			uint32_t s = mq_GM[i + m];
			for (size_t j = 0; j < ht; j ++) {
				size_t j1 = j0 + j;
				size_t j2 = j1 + ht;
				uint32_t x1 = d[j1];
				uint32_t x2 = mq_mmul(d[j2], s);
				d[j1] = (uint16_t)mq_add(x1, x2);
				d[j2] = (uint16_t)mq_sub(x1, x2);
			}
			j0 += t;
		}
		t = ht;
	}
}

#endif

#endif

#if FNDSA_AVX2
TARGET_AVX2
static inline void
avx2_NTT32(__m256i *a0, __m256i *a1, size_t k)
{
	__m256i ya0, ya1, yt1, yt2, yt3, yt4, yg1, yg2, yg3, ysk;
	uint16_t g1_0, g1_1;

	ya0 = *a0;
	ya1 = *a1;

	/* t = 32, m = 1 */
	yt1 = ya0;
	yt2 = mq_mmul_x16(ya1, _mm256_set1_epi16(mq_GM[k]));
	ya0 = mq_add_x16(yt1, yt2);
	ya1 = mq_sub_x16(yt1, yt2);

	/* ya0:  0  1  2  3  4  5  6  7 |  8  9 10 11 12 13 14 15 */
	/* ya1: 16 17 18 19 20 21 22 23 | 24 25 26 27 28 29 30 31 */

	/* t = 16, m = 2 */
	yt1 = _mm256_permute2x128_si256(ya0, ya1, 0x20);
	yt2 = _mm256_permute2x128_si256(ya0, ya1, 0x31);
	g1_0 = mq_GM[(k << 1) + 0];
	g1_1 = mq_GM[(k << 1) + 1];
	yg1 = _mm256_setr_epi16(
		g1_0, g1_0, g1_0, g1_0, g1_0, g1_0, g1_0, g1_0,
		g1_1, g1_1, g1_1, g1_1, g1_1, g1_1, g1_1, g1_1);
	yt2 = mq_mmul_x16(yt2, yg1);
	ya0 = mq_add_x16(yt1, yt2);
	ya1 = mq_sub_x16(yt1, yt2);

	/* ya0:  0  1  2  3  4  5  6  7 | 16 17 18 19 20 21 22 23 */
	/* ya1:  8  9 10 11 12 13 14 15 | 24 25 26 27 28 29 30 31 */

	/* t = 8, m = 4 */
	yt1 = _mm256_unpacklo_epi64(ya0, ya1);
	yt2 = _mm256_unpackhi_epi64(ya0, ya1);
	yg2 = _mm256_setr_epi64x(
		mq_GM[(k << 2) + 0], mq_GM[(k << 2) + 1],
		mq_GM[(k << 2) + 2], mq_GM[(k << 2) + 3]);
	yg2 = _mm256_or_si256(yg2, _mm256_slli_epi64(yg2, 32));
	yg2 = _mm256_or_si256(yg2, _mm256_slli_epi32(yg2, 16));
	yt2 = mq_mmul_x16(yt2, yg2);
	ya0 = mq_add_x16(yt1, yt2);
	ya1 = mq_sub_x16(yt1, yt2);

	/* ya0:  0  1  2  3  8  9 10 11 | 16 17 18 19 24 25 26 27 */
	/* ya1:  4  5  6  7 12 13 14 15 | 20 21 22 23 28 29 30 31 */

	/* t = 4, m = 8 */
	yt3 = _mm256_shuffle_epi32(ya0, 0xD8);
	yt4 = _mm256_shuffle_epi32(ya1, 0xD8);
	yt1 = _mm256_unpacklo_epi32(yt3, yt4);
	yt2 = _mm256_unpackhi_epi32(yt3, yt4);
	yg3 = _mm256_cvtepi16_epi32(
		_mm_loadu_si128((const __m128i *)mq_GM + k));
	yg3 = _mm256_or_si256(yg3, _mm256_slli_epi32(yg3, 16));
	yt2 = mq_mmul_x16(yt2, yg3);
	ya0 = mq_add_x16(yt1, yt2);
	ya1 = mq_sub_x16(yt1, yt2);

	/* ya0:  0  1  4  5  8  9 12 13 | 16 17 20 21 24 25 28 29 */
	/* ya1:  2  3  6  7 10 11 14 15 | 18 19 22 23 26 27 30 31 */

	/* t = 2, m = 16 */
	ysk = _mm256_setr_epi8(
		0, 1, 4, 5, 8, 9, 12, 13, 2, 3, 6, 7, 10, 11, 14, 15,
		0, 1, 4, 5, 8, 9, 12, 13, 2, 3, 6, 7, 10, 11, 14, 15);
	yt3 = _mm256_shuffle_epi8(ya0, ysk);
	yt4 = _mm256_shuffle_epi8(ya1, ysk);
	yt1 = _mm256_unpacklo_epi16(yt3, yt4);
	yt2 = _mm256_unpackhi_epi16(yt3, yt4);
	yt2 = mq_mmul_x16(yt2,
		_mm256_loadu_si256((const __m256i *)mq_GM + k));
	ya0 = mq_add_x16(yt1, yt2);
	ya1 = mq_sub_x16(yt1, yt2);

	/* ya0:  0  2  4  6  8 10 12 14 | 16 18 20 22 24 26 28 30 */
	/* ya1:  1  3  5  7  9 11 13 15 | 17 19 21 23 25 27 29 31 */
	yt1 = _mm256_unpacklo_epi16(ya0, ya1);
	yt2 = _mm256_unpackhi_epi16(ya0, ya1);
	ya0 = _mm256_permute2x128_si256(yt1, yt2, 0x20);
	ya1 = _mm256_permute2x128_si256(yt1, yt2, 0x31);

	*a0 = ya0;
	*a1 = ya1;
}

TARGET_AVX2
void
avx2_mqpoly_int_to_ntt(unsigned logn, uint16_t *d)
{
	if (logn == 0) {
		return;
	}
	if (logn >= 5) {
		__m256i *dp = (__m256i *)d;
		size_t n = (size_t)1 << logn;
		size_t t = n >> 4;
		for (unsigned lm = 0; lm < (logn - 5); lm ++) {
			size_t m = (size_t)1 << lm;
			size_t ht = t >> 1;
			size_t j0 = 0;
			for (size_t i = 0; i < m; i ++) {
				__m256i ys = _mm256_set1_epi16(mq_GM[i + m]);
				for (size_t j = 0; j < ht; j ++) {
					size_t j1 = j0 + j;
					size_t j2 = j1 + ht;
					__m256i y1, y2;
					y1 = _mm256_loadu_si256(dp + j1);
					y2 = _mm256_loadu_si256(dp + j2);
					y2 = mq_mmul_x16(y2, ys);
					_mm256_storeu_si256(dp + j1,
						mq_add_x16(y1, y2));
					_mm256_storeu_si256(dp + j2,
						mq_sub_x16(y1, y2));
				}
				j0 += t;
			}
			t = ht;
		}
		size_t m = n >> 5;
		for (size_t i = 0; i < m; i ++) {
			__m256i ya0 = _mm256_loadu_si256(dp + (i << 1) + 0);
			__m256i ya1 = _mm256_loadu_si256(dp + (i << 1) + 1);
			avx2_NTT32(&ya0, &ya1, i + m);
			_mm256_storeu_si256(dp + (i << 1) + 0, ya0);
			_mm256_storeu_si256(dp + (i << 1) + 1, ya1);
		}
	} else {
		size_t t = (size_t)1 << logn;
		for (unsigned lm = 0; lm < logn; lm ++) {
			size_t m = (size_t)1 << lm;
			size_t ht = t >> 1;
			size_t j0 = 0;
			for (size_t i = 0; i < m; i ++) {
				uint32_t s = mq_GM[i + m];
				for (size_t j = 0; j < ht; j ++) {
					size_t j1 = j0 + j;
					size_t j2 = j1 + ht;
					uint32_t x1 = d[j1];
					uint32_t x2 = mq_mmul(d[j2], s);
					d[j1] = (uint16_t)mq_add(x1, x2);
					d[j2] = (uint16_t)mq_sub(x1, x2);
				}
				j0 += t;
			}
			t = ht;
		}
	}
}
#endif

#if !FNDSA_ASM_CORTEXM4

#if FNDSA_SSE2

TARGET_SSE2
static inline void
sse2_iNTT16(__m128i *a0, __m128i *a1, size_t k)
{
	__m128i xa0, xa1, xt1, xt2, xt3, xt4, xig0, xig1, xig2, xig3;
	uint16_t ig1_0, ig1_1;

	xa0 = *a0;
	xa1 = *a1;

	/* xa0:  0  1  2  3  4  5  6  7 */
	/* xa1:  8  9 10 11 12 13 14 15 */
	xt1 = _mm_unpacklo_epi16(xa0, xa1);
	xt2 = _mm_unpackhi_epi16(xa0, xa1);
	xt3 = _mm_unpacklo_epi16(xt1, xt2);
	xt4 = _mm_unpackhi_epi16(xt1, xt2);
	xa0 = _mm_unpacklo_epi16(xt3, xt4);
	xa1 = _mm_unpackhi_epi16(xt3, xt4);

	/* xa0:  0  2  4  6  8 10 12 14 */
	/* xa1:  1  3  5  7  9 11 13 15 */
	xt1 = mq_add_x8(xa0, xa1);
	xt2 = mq_sub_x8(xa0, xa1);
	xig3 = _mm_loadu_si128((__m128i *)(mq_iGM + (k << 3)));
	xa0 = mq_half_x8(xt1);
	xa1 = mq_mmul_x8(xt2, xig3);

	/* xa0:  0  2  4  6  8 10 12 14 */
	/* xa1:  1  3  5  7  9 11 13 15 */
	xt1 = _mm_unpacklo_epi16(xa0, xa1);
	xt2 = _mm_unpackhi_epi16(xa0, xa1);
	xt3 = _mm_shuffle_epi32(xt1, 0xD8);
	xt4 = _mm_shuffle_epi32(xt2, 0xD8);
	xa0 = _mm_unpacklo_epi64(xt3, xt4);
	xa1 = _mm_unpackhi_epi64(xt3, xt4);

	/* xa0:  0  1  4  5  8  9 12 13 */
	/* xa1:  2  3  6  7 10 11 14 15 */
	xt1 = mq_add_x8(xa0, xa1);
	xt2 = mq_sub_x8(xa0, xa1);
	xig2 = _mm_setr_epi32(
		*(int32_t *)(mq_iGM + (k << 2)),
		*(int32_t *)(mq_iGM + (k << 2) + 2),
		0, 0);
	xig2 = _mm_unpacklo_epi16(xig2, xig2);
	xa0 = mq_half_x8(xt1);
	xa1 = mq_mmul_x8(xt2, xig2);

	/* xa0:  0  1  4  5  8  9 12 13 */
	/* xa1:  2  3  6  7 10 11 14 15 */
	xt1 = _mm_shuffle_epi32(xa0, 0xD8);
	xt2 = _mm_shuffle_epi32(xa1, 0xD8);
	xa0 = _mm_unpacklo_epi32(xt1, xt2);
	xa1 = _mm_unpackhi_epi32(xt1, xt2);

	/* xa0:  0  1  2  3  8  9 10 11 */
	/* xa1:  4  5  6  7 12 13 14 15 */
	xt1 = mq_add_x8(xa0, xa1);
	xt2 = mq_sub_x8(xa0, xa1);
	ig1_0 = mq_iGM[(k << 1) + 0];
	ig1_1 = mq_iGM[(k << 1) + 1];
	xig1 = _mm_setr_epi16(
		ig1_0, ig1_0, ig1_0, ig1_0, ig1_1, ig1_1, ig1_1, ig1_1);
	xa0 = mq_half_x8(xt1);
	xa1 = mq_mmul_x8(xt2, xig1);

	/* xa0:  0  1  2  3  8  9 10 11 */
	/* xa1:  4  5  6  7 12 13 14 15 */
	xt1 = _mm_unpacklo_epi64(xa0, xa1);
	xt2 = _mm_unpackhi_epi64(xa0, xa1);
	xa0 = xt1;
	xa1 = xt2;

	/* xa0:  0  1  2  3  4  5  6  7 */
	/* xa1:  8  9 10 11 12 13 14 15 */
	xt1 = mq_add_x8(xa0, xa1);
	xt2 = mq_sub_x8(xa0, xa1);
	xa0 = mq_half_x8(xt1);
	xa1 = mq_mmul_x8(xt2, _mm_set1_epi16(mq_iGM[k]));

	*a0 = xa0;
	*a1 = xa1;
}

/* see inner.h */
TARGET_SSE2
void
mqpoly_ntt_to_int(unsigned logn, uint16_t *d)
{
	if (logn >= 4) {
		__m128i *dp = (__m128i *)d;
		size_t n = (size_t)1 << logn;
		size_t m = n >> 4;
		for (size_t i = 0; i < m; i ++) {
			__m128i xa0 = _mm_loadu_si128(dp + (i << 1) + 0);
			__m128i xa1 = _mm_loadu_si128(dp + (i << 1) + 1);
			sse2_iNTT16(&xa0, &xa1, i + m);
			_mm_storeu_si128(dp + (i << 1) + 0, xa0);
			_mm_storeu_si128(dp + (i << 1) + 1, xa1);
		}
		size_t t = 2;
		for (unsigned lm = 4; lm < logn; lm ++) {
			size_t hm = (size_t)1 << (logn - 1 - lm);
			size_t dt = t << 1;
			size_t j0 = 0;
			for (size_t i = 0; i < hm; i ++) {
				__m128i xs = _mm_set1_epi16(mq_iGM[i + hm]);
				for (size_t j = 0; j < t; j ++) {
					size_t j1 = j0 + j;
					size_t j2 = j1 + t;
					__m128i x1, x2;
					x1 = _mm_loadu_si128(dp + j1);
					x2 = _mm_loadu_si128(dp + j2);
					_mm_storeu_si128(dp + j1,
						mq_half_x8(
							mq_add_x8(x1, x2)));
					_mm_storeu_si128(dp + j2,
						mq_mmul_x8(xs,
							mq_sub_x8(x1, x2)));
				}
				j0 += dt;
			}
			t = dt;
		}
	} else {
		size_t t = 1;
		for (unsigned lm = 0; lm < logn; lm ++) {
			size_t hm = (size_t)1 << (logn - 1 - lm);
			size_t dt = t << 1;
			size_t j0 = 0;
			for (size_t i = 0; i < hm; i ++) {
				uint32_t s = mq_iGM[i + hm];
				for (size_t j = 0; j < t; j ++) {
					size_t j1 = j0 + j;
					size_t j2 = j1 + t;
					uint32_t x1 = d[j1];
					uint32_t x2 = d[j2];
					d[j1] = mq_half(mq_add(x1, x2));
					d[j2] = mq_mmul(mq_sub(x1, x2), s);
				}
				j0 += dt;
			}
			t = dt;
		}
	}
}

#elif FNDSA_NEON

TARGET_NEON
static inline void
neon_iNTT16(int16x8_t *a0, int16x8_t *a1, size_t k)
{
	int16x8_t xa0, xa1, xt1, xt2, xt3, xt4, xig0, xig1, xig2, xig3;
	uint16_t ig1_0, ig1_1;

	xa0 = *a0;
	xa1 = *a1;

	/* xa0:  0  1  2  3  4  5  6  7 */
	/* xa1:  8  9 10 11 12 13 14 15 */
	xt3 = vuzp1q_s16(xa0, xa1);
	xt4 = vuzp2q_s16(xa0, xa1);
	xt1 = mq_add_x8(xt3, xt4);
	xt2 = mq_sub_x8(xt3, xt4);
	xig3 = vld1q_s16((int16_t *)(mq_iGM + (k << 3)));
	xa0 = mq_half_x8(xt1);
	xa1 = mq_mmul_x8(xt2, xig3);

	/* xa0:  0  2  4  6  8 10 12 14 */
	/* xa1:  1  3  5  7  9 11 13 15 */
	xt3 = vtrn1q_s16(xa0, xa1);
	xt4 = vtrn2q_s16(xa0, xa1);
	xt1 = mq_add_x8(xt3, xt4);
	xt2 = mq_sub_x8(xt3, xt4);
	xig2 = vreinterpretq_s16_u64(
		vdupq_n_u64(*(uint64_t *)(mq_iGM + (k << 2))));
	xig2 = vzip1q_s16(xig2, xig2);
	xa0 = mq_half_x8(xt1);
	xa1 = mq_mmul_x8(xt2, xig2);

	/* xa0:  0  1  4  5  8  9 12 13 */
	/* xa1:  2  3  6  7 10 11 14 15 */
	xt3 = vreinterpretq_s16_s32(vtrn1q_s32(
		vreinterpretq_s32_s16(xa0), vreinterpretq_s32_s16(xa1)));
	xt4 = vreinterpretq_s16_s32(vtrn2q_s32(
		vreinterpretq_s32_s16(xa0), vreinterpretq_s32_s16(xa1)));
	xt1 = mq_add_x8(xt3, xt4);
	xt2 = mq_sub_x8(xt3, xt4);
	ig1_0 = mq_iGM[(k << 1) + 0];
	ig1_1 = mq_iGM[(k << 1) + 1];
	xig1 = vcombine_s16(vdup_n_s16(ig1_0), vdup_n_s16(ig1_1));
	xa0 = mq_half_x8(xt1);
	xa1 = mq_mmul_x8(xt2, xig1);

	/* xa0:  0  1  2  3  8  9 10 11 */
	/* xa1:  4  5  6  7 12 13 14 15 */
	xt3 = vreinterpretq_s16_s64(vzip1q_s64(
		vreinterpretq_s64_s16(xa0), vreinterpretq_s64_s16(xa1)));
	xt4 = vreinterpretq_s16_s64(vzip2q_s64(
		vreinterpretq_s64_s16(xa0), vreinterpretq_s64_s16(xa1)));
	xt1 = mq_add_x8(xt3, xt4);
	xt2 = mq_sub_x8(xt3, xt4);
	xa0 = mq_half_x8(xt1);
	xa1 = mq_mmul_x8(xt2, vdupq_n_s16(mq_iGM[k]));

	/* xa0:  0  1  2  3  4  5  6  7 */
	/* xa1:  8  9 10 11 12 13 14 15 */
	*a0 = xa0;
	*a1 = xa1;
}

/* see inner.h */
TARGET_NEON
void
mqpoly_ntt_to_int(unsigned logn, uint16_t *d)
{
	if (logn >= 4) {
		size_t n = (size_t)1 << logn;
		size_t m = n >> 4;
		for (size_t i = 0; i < m; i ++) {
			int16x8_t xa0 = vld1q_s16((int16_t *)d + (i << 4) + 0);
			int16x8_t xa1 = vld1q_s16((int16_t *)d + (i << 4) + 8);
			neon_iNTT16(&xa0, &xa1, i + m);
			vst1q_s16((int16_t *)d + (i << 4) + 0, xa0);
			vst1q_s16((int16_t *)d + (i << 4) + 8, xa1);
		}
		size_t t = 2;
		for (unsigned lm = 4; lm < logn; lm ++) {
			size_t hm = (size_t)1 << (logn - 1 - lm);
			size_t dt = t << 1;
			size_t j0 = 0;
			for (size_t i = 0; i < hm; i ++) {
				int16x8_t xs = vdupq_n_s16(mq_iGM[i + hm]);
				for (size_t j = 0; j < t; j ++) {
					size_t j1 = j0 + j;
					size_t j2 = j1 + t;
					int16x8_t x1 = vld1q_s16(
						(int16_t *)d + (j1 << 3));
					int16x8_t x2 = vld1q_s16(
						(int16_t *)d + (j2 << 3));
					vst1q_s16((int16_t *)d + (j1 << 3),
						mq_half_x8(
							mq_add_x8(x1, x2)));
					vst1q_s16((int16_t *)d + (j2 << 3),
						mq_mmul_x8(xs,
							mq_sub_x8(x1, x2)));
				}
				j0 += dt;
			}
			t = dt;
		}
	} else {
		size_t t = 1;
		for (unsigned lm = 0; lm < logn; lm ++) {
			size_t hm = (size_t)1 << (logn - 1 - lm);
			size_t dt = t << 1;
			size_t j0 = 0;
			for (size_t i = 0; i < hm; i ++) {
				uint32_t s = mq_iGM[i + hm];
				for (size_t j = 0; j < t; j ++) {
					size_t j1 = j0 + j;
					size_t j2 = j1 + t;
					uint32_t x1 = d[j1];
					uint32_t x2 = d[j2];
					d[j1] = mq_half(mq_add(x1, x2));
					d[j2] = mq_mmul(mq_sub(x1, x2), s);
				}
				j0 += dt;
			}
			t = dt;
		}
	}
}

#else

/* see inner.h */
void
mqpoly_ntt_to_int(unsigned logn, uint16_t *d)
{
	if (logn == 0) {
		return;
	}
	size_t t = 1;
	for (unsigned lm = 0; lm < logn; lm ++) {
		size_t hm = (size_t)1 << (logn - 1 - lm);
		size_t dt = t << 1;
		size_t j0 = 0;
		for (size_t i = 0; i < hm; i ++) {
			uint32_t s = mq_iGM[i + hm];
			for (size_t j = 0; j < t; j ++) {
				size_t j1 = j0 + j;
				size_t j2 = j1 + t;
				uint32_t x1 = d[j1];
				uint32_t x2 = d[j2];
				d[j1] = (uint16_t)mq_half(mq_add(x1, x2));
				d[j2] = (uint16_t)mq_mmul(mq_sub(x1, x2), s);
			}
			j0 += dt;
		}
		t = dt;
	}
}

#endif

#endif

#if FNDSA_AVX2
TARGET_AVX2
static inline void
avx2_iNTT32(__m256i *a0, __m256i *a1, size_t k)
{
	__m256i ya0, ya1, yt1, yt2, yt3, yt4, yig0, yig1, yig2, yig3, ysk;
	uint16_t ig1_0, ig1_1;

	ya0 = *a0;
	ya1 = *a1;

	/* ya0:  0  1  2  3  4  5  6  7 |  8  9 10 11 12 13 14 15 */
	/* ya1: 16 17 18 19 20 21 22 23 | 24 25 26 27 28 29 30 31 */

	yt1 = _mm256_permute2x128_si256(ya0, ya1, 0x20);
	yt2 = _mm256_permute2x128_si256(ya0, ya1, 0x31);

	/* yt1:  0  1  2  3  4  5  6  7 | 16 17 18 19 20 21 22 23 */
	/* yt2:  8  9 10 11 12 13 14 15 | 24 25 26 27 28 29 30 31 */

	ysk = _mm256_setr_epi8(
		0, 1, 4, 5, 8, 9, 12, 13, 2, 3, 6, 7, 10, 11, 14, 15,
		0, 1, 4, 5, 8, 9, 12, 13, 2, 3, 6, 7, 10, 11, 14, 15);
	yt3 = _mm256_shuffle_epi8(yt1, ysk);
	yt4 = _mm256_shuffle_epi8(yt2, ysk);

	/* yt3:  0  2  4  6  1  3  5  7 | 16 18 20 22 17 19 21 23 */
	/* yt4:  8 10 12 14  9 11 13 15 | 24 26 28 30 25 27 29 31 */

	yt1 = _mm256_unpacklo_epi64(yt3, yt4);
	yt2 = _mm256_unpackhi_epi64(yt3, yt4);
	ya0 = mq_half_x16(mq_add_x16(yt1, yt2));
	ya1 = mq_mmul_x16(mq_sub_x16(yt1, yt2),
		_mm256_loadu_si256((const __m256i *)mq_iGM + k));

	/* ya0:  0  2  4  6  8 10 12 14 | 16 18 20 22 24 26 28 30 */
	/* ya1:  1  3  5  7  9 11 13 15 | 17 19 21 23 25 27 29 31 */

	yt1 = _mm256_blend_epi16(ya0, _mm256_slli_epi32(ya1, 16), 0xAA);
	yt2 = _mm256_blend_epi16(_mm256_srli_epi32(ya0, 16), ya1, 0xAA);
	yig3 = _mm256_cvtepi16_epi32(
		_mm_loadu_si128((const __m128i *)mq_iGM + k));
	yig3 = _mm256_or_si256(yig3, _mm256_slli_epi32(yig3, 16));
	ya0 = mq_half_x16(mq_add_x16(yt1, yt2));
	ya1 = mq_mmul_x16(mq_sub_x16(yt1, yt2), yig3);

	/* ya0:  0  1  4  5  8  9 12 13 | 16 17 20 21 24 25 28 29 */
	/* ya1:  2  3  6  7 10 11 14 15 | 18 19 22 23 26 27 30 31 */

	yt1 = _mm256_blend_epi16(ya0, _mm256_slli_epi64(ya1, 32), 0xCC);
	yt2 = _mm256_blend_epi16(_mm256_srli_epi64(ya0, 32), ya1, 0xCC);
	yig2 = _mm256_setr_epi64x(
		mq_iGM[(k << 2) + 0], mq_iGM[(k << 2) + 1],
		mq_iGM[(k << 2) + 2], mq_iGM[(k << 2) + 3]);
	yig2 = _mm256_or_si256(yig2, _mm256_slli_epi64(yig2, 32));
	yig2 = _mm256_or_si256(yig2, _mm256_slli_epi32(yig2, 16));
	ya0 = mq_half_x16(mq_add_x16(yt1, yt2));
	ya1 = mq_mmul_x16(mq_sub_x16(yt1, yt2), yig2);

	/* ya0:  0  1  2  3  8  9 10 11 | 16 17 18 19 24 25 26 27 */
	/* ya1:  4  5  6  7 12 13 14 15 | 20 21 22 23 28 29 30 31 */

	yt1 = _mm256_unpacklo_epi64(ya0, ya1);
	yt2 = _mm256_unpackhi_epi64(ya0, ya1);
	ig1_0 = mq_iGM[(k << 1) + 0];
	ig1_1 = mq_iGM[(k << 1) + 1];
	yig1 = _mm256_setr_epi16(
		ig1_0, ig1_0, ig1_0, ig1_0, ig1_0, ig1_0, ig1_0, ig1_0,
		ig1_1, ig1_1, ig1_1, ig1_1, ig1_1, ig1_1, ig1_1, ig1_1);
	ya0 = mq_half_x16(mq_add_x16(yt1, yt2));
	ya1 = mq_mmul_x16(mq_sub_x16(yt1, yt2), yig1);

	/* ya0:  0  1  2  3  4  5  6  7 | 16 17 18 19 20 21 22 23 */
	/* ya1:  8  9 10 11 12 13 14 15 | 24 25 26 27 28 29 30 31 */

	yt1 = _mm256_permute2x128_si256(ya0, ya1, 0x20);
	yt2 = _mm256_permute2x128_si256(ya0, ya1, 0x31);
	yig0 = _mm256_set1_epi16(mq_iGM[k]);
	ya0 = mq_half_x16(mq_add_x16(yt1, yt2));
	ya1 = mq_mmul_x16(mq_sub_x16(yt1, yt2), yig0);

	/* ya0:  0  1  2  3  4  5  6  7 |  8  9 10 11 12 13 14 15 */
	/* ya1: 16 17 18 19 20 21 22 23 | 24 25 26 27 28 29 30 31 */

	*a0 = ya0;
	*a1 = ya1;
}

TARGET_AVX2
void
avx2_mqpoly_ntt_to_int(unsigned logn, uint16_t *d)
{
	if (logn == 0) {
		return;
	}
	if (logn >= 5) {
		__m256i *dp = (__m256i *)d;
		size_t n = (size_t)1 << logn;
		size_t m = n >> 5;
		for (size_t i = 0; i < m; i ++) {
			__m256i ya0 = _mm256_loadu_si256(dp + (i << 1) + 0);
			__m256i ya1 = _mm256_loadu_si256(dp + (i << 1) + 1);
			avx2_iNTT32(&ya0, &ya1, i + m);
			_mm256_storeu_si256(dp + (i << 1) + 0, ya0);
			_mm256_storeu_si256(dp + (i << 1) + 1, ya1);
		}
		size_t t = 2;
		for (unsigned lm = 5; lm < logn; lm ++) {
			size_t hm = (size_t)1 << (logn - 1 - lm);
			size_t dt = t << 1;
			size_t j0 = 0;
			for (size_t i = 0; i < hm; i ++) {
				__m256i ys = _mm256_set1_epi16(mq_iGM[i + hm]);
				for (size_t j = 0; j < t; j ++) {
					size_t j1 = j0 + j;
					size_t j2 = j1 + t;
					__m256i y1, y2;
					y1 = _mm256_loadu_si256(dp + j1);
					y2 = _mm256_loadu_si256(dp + j2);
					_mm256_storeu_si256(dp + j1,
						mq_half_x16(
							mq_add_x16(y1, y2)));
					_mm256_storeu_si256(dp + j2,
						mq_mmul_x16(ys,
							mq_sub_x16(y1, y2)));
				}
				j0 += dt;
			}
			t = dt;
		}
	} else {
		size_t t = 1;
		for (unsigned lm = 0; lm < logn; lm ++) {
			size_t hm = (size_t)1 << (logn - 1 - lm);
			size_t dt = t << 1;
			size_t j0 = 0;
			for (size_t i = 0; i < hm; i ++) {
				uint32_t s = mq_iGM[i + hm];
				for (size_t j = 0; j < t; j ++) {
					size_t j1 = j0 + j;
					size_t j2 = j1 + t;
					uint32_t x1 = d[j1];
					uint32_t x2 = d[j2];
					d[j1] = mq_half(mq_add(x1, x2));
					d[j2] = mq_mmul(mq_sub(x1, x2), s);
				}
				j0 += dt;
			}
			t = dt;
		}
	}
}
#endif

#if !FNDSA_ASM_CORTEXM4
/* see inner.h */
TARGET_SSE2
void
mqpoly_mul_ntt(unsigned logn, uint16_t *a, const uint16_t *b)
{
	size_t n = (size_t)1 << logn;
#if FNDSA_SSE2
	if (logn >= 3) {
		__m128i xR2 = _mm_set1_epi16(R2);
		for (size_t i = 0; i < n; i += 8) {
			__m128i xa = _mm_loadu_si128((__m128i *)(a + i));
			__m128i xb = _mm_loadu_si128((__m128i *)(b + i));
			__m128i xc = mq_mmul_x8(mq_mmul_x8(xa, xb), xR2);
			_mm_storeu_si128((__m128i *)(a + i), xc);
		}
		return;
	}
#elif FNDSA_NEON
	if (logn >= 3) {
		int16x8_t xR2 = vdupq_n_s16(R2);
		for (size_t i = 0; i < n; i += 8) {
			int16x8_t xa = vld1q_s16((int16_t *)(a + i));
			int16x8_t xb = vld1q_s16((int16_t *)(b + i));
			int16x8_t xc = mq_mmul_x8(mq_mmul_x8(xa, xb), xR2);
			vst1q_s16((int16_t *)(a + i), xc);
		}
		return;
	}
#endif
	for (size_t i = 0; i < n; i ++) {
		a[i] = (uint16_t)mq_mmul(mq_mmul(a[i], b[i]), R2);
	}
}
#endif

/* see inner.h */
TARGET_SSE2
void
mqpoly_muladj_x2_ntt(unsigned logn, uint16_t *a, const uint16_t *b)
{
	// TODO: Arm Cortex M4 optimization
	size_t n = (size_t)1 << logn;
	size_t hn = n >> 1;
#if FNDSA_SSE2
	if (logn >= 4) {
		__m128i xR2 = _mm_set1_epi16(R2);
		for (size_t i = 0; i < hn; i += 8) {
			__m128i xa0 = _mm_loadu_si128((__m128i *)(a + i));
			__m128i xa1 = _mm_loadu_si128(
				(__m128i *)(a + n - 8 - i));
			__m128i xb0 = _mm_loadu_si128((__m128i *)(b + i));
			__m128i xb1 = _mm_loadu_si128(
				(__m128i *)(b + n - 8 - i));
			xa1 = _mm_or_si128(
				_mm_srli_epi32(xa1, 16),
				_mm_slli_epi32(xa1, 16));
			xa1 = _mm_shuffle_epi32(xa1, 0x1B);
			xb1 = _mm_or_si128(
				_mm_srli_epi32(xb1, 16),
				_mm_slli_epi32(xb1, 16));
			xb1 = _mm_shuffle_epi32(xb1, 0x1B);
			__m128i xc = mq_mmul_x8(mq_add_x8(
				mq_mmul_x8(xa0, xa1),
				mq_mmul_x8(xb0, xb1)), xR2);
			_mm_storeu_si128((__m128i *)(a + i), xc);
			xc = _mm_or_si128(
				_mm_srli_epi32(xc, 16),
				_mm_slli_epi32(xc, 16));
			xc = _mm_shuffle_epi32(xc, 0x1B);
			_mm_storeu_si128((__m128i *)(a + n - 8 - i), xc);
		}
		return;
	}
#elif FNDSA_NEON
	if (logn >= 4) {
		int16x8_t xR2 = vdupq_n_s16(R2);
		for (size_t i = 0; i < hn; i += 8) {
			int16x8_t xa0 = vld1q_s16((int16_t *)(a + i));
			int16x8_t xa1 = vld1q_s16(
				(int16_t *)(a + n - 8 - i));
			int16x8_t xb0 = vld1q_s16((int16_t *)(b + i));
			int16x8_t xb1 = vld1q_s16(
				(int16_t *)(b + n - 8 - i));
			xa1 = vrev64q_s16(xa1);
			xb1 = vrev64q_s16(xb1);
			xa1 = vextq_s16(xa1, xa1, 4);
			xb1 = vextq_s16(xb1, xb1, 4);
			int16x8_t xc = mq_mmul_x8(mq_add_x8(
				mq_mmul_x8(xa0, xa1),
				mq_mmul_x8(xb0, xb1)), xR2);
			vst1q_s16((int16_t *)(a + i), xc);
			xc = vrev64q_s16(xc);
			xc = vextq_s16(xc, xc, 4);
			vst1q_s16((int16_t *)(a + n - 8 - i), xc);
		}
		return;
	}
#endif
	for (size_t i = 0; i < hn; i ++) {
		a[i] = (uint16_t)mq_mmul(mq_add(
			mq_mmul(a[i], a[n - 1 - i]),
			mq_mmul(b[i], b[n - 1 - i])), R2);
	}
	for (size_t i = hn; i < n; i ++) {
		a[i] = a[n - 1 - i];
	}
}

#if FNDSA_AVX2
TARGET_AVX2
void
avx2_mqpoly_mul_ntt(unsigned logn, uint16_t *a, const uint16_t *b)
{
	if (logn >= 4) {
		__m256i *ap = (__m256i *)a;
		const __m256i *bp = (const __m256i *)b;
		__m256i yR2 = _mm256_set1_epi16(R2);
		for (size_t i = 0; i < (1u << (logn - 4)); i ++) {
			__m256i ya = _mm256_loadu_si256(ap + i);
			__m256i yb = _mm256_loadu_si256(bp + i);
			ya = mq_mmul_x16(mq_mmul_x16(ya, yb), yR2);
			_mm256_storeu_si256(ap + i, ya);
		}
	} else {
		size_t n = (size_t)1 << logn;
		for (size_t i = 0; i < n; i ++) {
			a[i] = (uint16_t)mq_mmul(mq_mmul(a[i], b[i]), R2);
		}
	}
}
#endif

/* see inner.h */
TARGET_SSE2
int
mqpoly_inv_ntt(unsigned logn, uint16_t *a, uint16_t *tmp)
{
	size_t n = (size_t)1 << logn;

	/* Inversion uses Montgomery's trick: given x and y, we have:
	     1/x = y*(1/(x*y))
	     1/y = x*(1/(x*y))
	   We replace n inversions with a single inversion, and 3*(n - 1)
	   multiplications.

	   Code uses Montgomery multiplications, which _assumes_ that the
	   values are in Montgomery representation, which is not the case;
	   a corrective factor is applied in mq_div(), which, in Montgomery
	   representation, should be mq_div(R2, ax): if ax = z*R, i.e. the
	   Montgomery representation of some z, then the normal inversion
	   should return R/z = R^2/ax. But since everything is actually
	   in normal representation, then we need to apply a 1/R^2 factor,
	   which is done by using 1 instead of R2 as first parameter to
	   mq_div(). */
#if FNDSA_SSE2
	if (logn >= 3) {
		__m128i ax = _mm_loadu_si128((__m128i *)a);
		_mm_storeu_si128((__m128i *)tmp, ax);
		for (size_t i = 8; i < n; i += 8) {
			ax = mq_mmul_x8(ax,
				_mm_loadu_si128((__m128i *)(a + i)));
			_mm_storeu_si128((__m128i *)(tmp + i), ax);
		}
		ax = mq_div_x8(_mm_set1_epi16(1), ax);
		__m128i xr = _mm_sub_epi16(ax, _mm_set1_epi16(Q));
		for (size_t i = n - 8; i > 0; i -= 8) {
			__m128i cx = mq_mmul_x8(ax,
				_mm_loadu_si128((__m128i *)(tmp + i - 8)));
			ax = mq_mmul_x8(ax,
				_mm_loadu_si128((__m128i *)(a + i)));
			_mm_storeu_si128((__m128i *)(a + i), cx);
		}
		_mm_storeu_si128((__m128i *)a, ax);
		return (_mm_movemask_epi8(xr) & 0xAAAA) == 0xAAAA;
	}
#elif FNDSA_NEON
	if (logn >= 3) {
		int16x8_t ax = vld1q_s16((int16_t *)a);
		vst1q_s16((int16_t *)tmp, ax);
		for (size_t i = 8; i < n; i += 8) {
			ax = mq_mmul_x8(ax,
				vld1q_s16((int16_t *)(a + i)));
			vst1q_s16((int16_t *)(tmp + i), ax);
		}
		ax = mq_div_x8(vdupq_n_s16(1), ax);
		int16x8_t r1 = vceqq_s16(ax, vdupq_n_s16(Q));
		for (size_t i = n - 8; i > 0; i -= 8) {
			int16x8_t cx = mq_mmul_x8(ax,
				vld1q_s16((int16_t *)(tmp + i - 8)));
			ax = mq_mmul_x8(ax,
				vld1q_s16((int16_t *)(a + i)));
			vst1q_s16((int16_t *)(a + i), cx);
		}
		vst1q_s16((int16_t *)a, ax);
		uint8x16_t r2 = vreinterpretq_u8_s16(r1);
		uint8x8_t r3 = vget_low_u8(vzip2q_u8(r2, r2));
		return vget_lane_u64(vreinterpret_u64_u8(r3), 0) == 0;
	}
#endif
	uint32_t ax = a[0];
	tmp[0] = (uint16_t)ax;
	for (size_t i = 1; i < n; i ++) {
		ax = mq_mmul(ax, a[i]);
		tmp[i] = (uint16_t)ax;
	}
	ax = mq_div(1, ax);
	uint32_t r = ax - Q;
#if FNDSA_ASM_CORTEXM4
	r &= -ax;
#endif
	for (size_t i = n - 1; i > 0; i --) {
		uint32_t cx = mq_mmul(ax, tmp[i - 1]);
		ax = mq_mmul(ax, a[i]);
		a[i] = (uint16_t)cx;
	}
	a[0] = (uint16_t)ax;
	return (r >> 16) != 0;
}

/* see inner.h */
TARGET_SSE2
int
mqpoly_div_ntt(unsigned logn, uint16_t *a, const uint16_t *b, uint16_t *tmp)
{
	/* See mqpoly_inv_ntt() for details on the algorithm. */
	size_t n = (size_t)1 << logn;
#if FNDSA_SSE2
	if (logn >= 3) {
		__m128i xR2 = _mm_set1_epi16(R2);
		__m128i bx = _mm_loadu_si128((__m128i *)b);
		_mm_storeu_si128((__m128i *)tmp, bx);
		for (size_t i = 8; i < n; i += 8) {
			bx = mq_mmul_x8(bx,
				_mm_loadu_si128((__m128i *)(b + i)));
			_mm_storeu_si128((__m128i *)(tmp + i), bx);
		}
		bx = mq_div_x8(_mm_set1_epi16(1), bx);
		__m128i xr = _mm_sub_epi16(bx, _mm_set1_epi16(Q));
		for (size_t i = n - 8; i > 0; i -= 8) {
			__m128i cx = mq_mmul_x8(bx,
				_mm_loadu_si128((__m128i *)(tmp + i - 8)));
			bx = mq_mmul_x8(bx,
				_mm_loadu_si128((__m128i *)(b + i)));
			__m128i ax = _mm_loadu_si128((__m128i *)(a + i));
			cx = mq_mmul_x8(cx, mq_mmul_x8(ax, xR2));
			_mm_storeu_si128((__m128i *)(a + i), cx);
		}
		__m128i ax = _mm_loadu_si128((__m128i *)a);
		ax = mq_mmul_x8(bx, mq_mmul_x8(ax, xR2));
		_mm_storeu_si128((__m128i *)a, ax);
		return (_mm_movemask_epi8(xr) & 0xAAAA) == 0xAAAA;
	}
#elif FNDSA_NEON
	if (logn >= 3) {
		int16x8_t xR2 = vdupq_n_s16(R2);
		int16x8_t bx = vld1q_s16((int16_t *)b);
		vst1q_s16((int16_t *)tmp, bx);
		for (size_t i = 8; i < n; i += 8) {
			bx = mq_mmul_x8(bx,
				vld1q_s16((int16_t *)(b + i)));
			vst1q_s16((int16_t *)(tmp + i), bx);
		}
		bx = mq_div_x8(vdupq_n_s16(1), bx);
		int16x8_t r1 = vceqq_s16(bx, vdupq_n_s16(Q));
		for (size_t i = n - 8; i > 0; i -= 8) {
			int16x8_t cx = mq_mmul_x8(bx,
				vld1q_s16((int16_t *)(tmp + i - 8)));
			bx = mq_mmul_x8(bx,
				vld1q_s16((int16_t *)(b + i)));
			cx = mq_mmul_x8(cx,
				mq_mmul_x8(vld1q_s16((int16_t *)(a + i)), xR2));
			vst1q_s16((int16_t *)(a + i), cx);
		}
		bx = mq_mmul_x8(bx, mq_mmul_x8(vld1q_s16((int16_t *)a), xR2));
		vst1q_s16((int16_t *)a, bx);
		uint8x16_t r2 = vreinterpretq_u8_s16(r1);
		uint8x8_t r3 = vget_low_u8(vzip2q_u8(r2, r2));
		return vget_lane_u64(vreinterpret_u64_u8(r3), 0) == 0;
	}
#endif
	uint32_t bx = b[0];
	tmp[0] = (uint16_t)bx;
	for (size_t i = 1; i < n; i ++) {
		bx = mq_mmul(bx, b[i]);
		tmp[i] = (uint16_t)bx;
	}
	bx = mq_div(1, bx);
	uint32_t r = bx - Q;
#if FNDSA_ASM_CORTEXM4
	r &= -bx;
#endif
	for (size_t i = n - 1; i > 0; i --) {
		uint32_t cx = mq_mmul(bx, tmp[i - 1]);
		bx = mq_mmul(bx, b[i]);
		a[i] = (uint16_t)mq_mmul(mq_mmul(a[i], cx), R2);
	}
	a[0] = (uint16_t)mq_mmul(mq_mmul(a[0], bx), R2);
	return (r >> 16) != 0;
}

#if FNDSA_AVX2
TARGET_AVX2
int
avx2_mqpoly_div_ntt(unsigned logn,
	uint16_t *a, const uint16_t *b, uint16_t *tmp)
{
	/* See mqpoly_inv_ntt() for details on the algorithm. */
	if (logn >= 4) {
		size_t hdn = (size_t)1 << (logn - 4);
		__m256i *ap = (__m256i *)a;
		const __m256i *bp = (const __m256i *)b;
		__m256i *tp = (__m256i *)tmp;
		__m256i bx = _mm256_loadu_si256(bp);
		_mm256_storeu_si256(tp, bx);
		for (size_t i = 1; i < hdn; i ++) {
			__m256i dx = _mm256_loadu_si256(bp + i);
			bx = mq_mmul_x16(bx, dx);
			_mm256_storeu_si256(tp + i, bx);
		}
		bx = mq_div_x16(_mm256_set1_epi16(1), bx);
		__m256i ov = _mm256_sub_epi16(bx, _mm256_set1_epi16(Q));
		__m256i yR2 = _mm256_set1_epi16(R2);
		uint32_t r = (uint32_t)_mm256_movemask_epi8(ov);
		for (size_t i = hdn - 1; i > 0; i --) {
			__m256i cx = _mm256_loadu_si256(tp + (i - 1));
			cx = mq_mmul_x16(bx, cx);
			bx = mq_mmul_x16(bx, _mm256_loadu_si256(bp + i));
			__m256i ax = _mm256_loadu_si256(ap + i);
			ax = mq_mmul_x16(mq_mmul_x16(ax, yR2), cx);
			_mm256_storeu_si256(ap + i, ax);
		}
		__m256i ax = _mm256_loadu_si256(ap);
		ax = mq_mmul_x16(mq_mmul_x16(ax, yR2), bx);
		_mm256_storeu_si256(ap, ax);
		return (r & 0xAAAAAAAA) == 0xAAAAAAAA;
	} else {
		size_t n = (size_t)1 << logn;

		uint32_t bx = b[0];
		tmp[0] = (uint16_t)bx;
		for (size_t i = 1; i < n; i ++) {
			bx = mq_mmul(bx, b[i]);
			tmp[i] = (uint16_t)bx;
		}
		bx = mq_div(1, bx);
		uint32_t r = bx - Q;
		for (size_t i = n - 1; i > 0; i --) {
			uint32_t cx = mq_mmul(bx, tmp[i - 1]);
			bx = mq_mmul(bx, b[i]);
			a[i] = (uint16_t)mq_mmul(mq_mmul(a[i], cx), R2);
		}
		a[0] = (uint16_t)mq_mmul(mq_mmul(a[0], bx), R2);
		return (r >> 16) != 0;
	}
}
#endif

#if !FNDSA_ASM_CORTEXM4
/* see inner.h */
TARGET_SSE2
void
mqpoly_sub(unsigned logn, uint16_t *a, const uint16_t *b)
{
	size_t n = (size_t)1 << logn;
#if FNDSA_SSE2
	if (logn >= 3) {
		for (size_t i = 0; i < n; i += 8) {
			__m128i xa = _mm_loadu_si128((__m128i *)(a + i));
			__m128i xb = _mm_loadu_si128((__m128i *)(b + i));
			__m128i xc = mq_sub_x8(xa, xb);
			_mm_storeu_si128((__m128i *)(a + i), xc);
		}
		return;
	}
#elif FNDSA_NEON
	if (logn >= 3) {
		for (size_t i = 0; i < n; i += 8) {
			int16x8_t xa = vld1q_s16((int16_t *)(a + i));
			int16x8_t xb = vld1q_s16((int16_t *)(b + i));
			int16x8_t xc = mq_sub_x8(xa, xb);
			vst1q_s16((int16_t *)(a + i), xc);
		}
		return;
	}
#endif
	for (size_t i = 0; i < n; i ++) {
		a[i] = (uint16_t)mq_sub(a[i], b[i]);
	}
}
#endif

/* see inner.h */
TARGET_SSE2
void
mqpoly_neg(unsigned logn, uint16_t *a)
{
	size_t n = (size_t)1 << logn;
#if FNDSA_ASM_CORTEXM4
	for (size_t i = 0; i < n; i ++) {
		a[i] = Q - a[i];
	}
#else
#if FNDSA_SSE2
	if (logn >= 3) {
		__m128i xq = _mm_set1_epi16(Q);
		for (size_t i = 0; i < n; i += 8) {
			__m128i x = _mm_loadu_si128((__m128i *)(a + i));
			x = _mm_sub_epi16(xq, x);
			x = _mm_or_si128(x, _mm_and_si128(xq,
				_mm_cmpeq_epi16(x, _mm_setzero_si128())));
			_mm_storeu_si128((__m128i *)(a + i), x);
		}
		return;
	}
#elif FNDSA_NEON
	if (logn >= 3) {
		int16x8_t xq = vdupq_n_s16(Q);
		int16x8_t xz = vdupq_n_s16(0);
		for (size_t i = 0; i < n; i += 8) {
			int16x8_t x = vld1q_s16((int16_t *)(a + i));
			x = vsubq_s16(xq, x);
			x = vorrq_s16(x, vandq_s16(xq, vceqq_s16(x, xz)));
			vst1q_s16((int16_t *)(a + i), x);
		}
		return;
	}
#endif
	for (size_t i = 0; i < n; i ++) {
		a[i] = (uint16_t)mq_sub(Q, a[i]);
	}
#endif
}

#if !FNDSA_ASM_CORTEXM4
/* see inner.h */
TARGET_SSE2
void
mqpoly_add(unsigned logn, uint16_t *a, const uint16_t *b)
{
	size_t n = (size_t)1 << logn;
#if FNDSA_SSE2
	if (logn >= 3) {
		for (size_t i = 0; i < n; i += 8) {
			__m128i xa = _mm_loadu_si128((__m128i *)(a + i));
			__m128i xb = _mm_loadu_si128((__m128i *)(b + i));
			__m128i xc = mq_add_x8(xa, xb);
			_mm_storeu_si128((__m128i *)(a + i), xc);
		}
		return;
	}
#elif FNDSA_NEON
	if (logn >= 3) {
		for (size_t i = 0; i < n; i += 8) {
			int16x8_t xa = vld1q_s16((int16_t *)(a + i));
			int16x8_t xb = vld1q_s16((int16_t *)(b + i));
			int16x8_t xc = mq_add_x8(xa, xb);
			vst1q_s16((int16_t *)(a + i), xc);
		}
		return;
	}
#endif
	for (size_t i = 0; i < n; i ++) {
		a[i] = (uint16_t)mq_add(a[i], b[i]);
	}
}
#endif

#if FNDSA_AVX2
TARGET_AVX2
void
avx2_mqpoly_sub(unsigned logn, uint16_t *a, const uint16_t *b)
{
	if (logn >= 4) {
		__m256i *ap = (__m256i *)a;
		const __m256i *bp = (const __m256i *)b;
		for (size_t i = 0; i < (1u << (logn - 4)); i ++) {
			__m256i ya = _mm256_loadu_si256(ap + i);
			__m256i yb = _mm256_loadu_si256(bp + i);
			ya = mq_sub_x16(ya, yb);
			_mm256_storeu_si256(ap + i, ya);
		}
	} else {
		size_t n = (size_t)1 << logn;
		for (size_t i = 0; i < n; i ++) {
			a[i] = (uint16_t)mq_sub(a[i], b[i]);
		}
	}
}
#endif

/* see inner.h */
int
mqpoly_is_invertible(unsigned logn, const int8_t *f, uint16_t *tmp)
{
	size_t n = (size_t)1 << logn;
	mqpoly_small_to_int(logn, f, tmp);
	mqpoly_int_to_ntt(logn, tmp);
	uint32_t r = 0xFFFFFFFF;
	for (size_t i = 0; i < n; i ++) {
#if FNDSA_ASM_CORTEXM4
		r &= -(uint32_t)tmp[i];
#endif
		r &= (uint32_t)tmp[i] - Q;
	}
	return (r >> 16) != 0;
}

/* see inner.h */
TARGET_SSE2
void
mqpoly_muladj_add_muladj(unsigned logn,
	uint16_t *a, const uint16_t *b, const uint16_t *c, const uint16_t *d)
{
	size_t n = (size_t)1 << logn;
#if FNDSA_SSE2
	if (logn >= 3) {
		__m128i xR2 = _mm_set1_epi16(R2);
		for (size_t i = 0; i < n; i += 8) {
			__m128i xa = _mm_loadu_si128((__m128i *)(a + i));
			__m128i xb = _mm_loadu_si128(
				(__m128i *)(b + n - 8 - i));
			xb = _mm_or_si128(
				_mm_srli_epi32(xb, 16),
				_mm_slli_epi32(xb, 16));
			xb = _mm_shuffle_epi32(xb, 0x1B);
			__m128i xc = _mm_loadu_si128((__m128i *)(c + i));
			__m128i xd = _mm_loadu_si128(
				(__m128i *)(d + n - 8 - i));
			xd = _mm_or_si128(
				_mm_srli_epi32(xd, 16),
				_mm_slli_epi32(xd, 16));
			xd = _mm_shuffle_epi32(xd, 0x1B);
			__m128i xe = mq_mmul_x8(mq_add_x8(
				mq_mmul_x8(xa, xb),
				mq_mmul_x8(xc, xd)), xR2);
			_mm_storeu_si128((__m128i *)(a + i), xe);
		}
		return;
	}
#elif FNDSA_NEON
	if (logn >= 3) {
		int16x8_t xR2 = vdupq_n_s16(R2);
		for (size_t i = 0; i < n; i += 8) {
			int16x8_t xa = vld1q_s16((int16_t *)(a + i));
			int16x8_t xb = vld1q_s16(
				(int16_t *)(b + n - 8 - i));
			xb = vrev64q_s16(xb);
			xb = vextq_s16(xb, xb, 4);
			int16x8_t xc = vld1q_s16((int16_t *)(c + i));
			int16x8_t xd = vld1q_s16(
				(int16_t *)(d + n - 8 - i));
			xd = vrev64q_s16(xd);
			xd = vextq_s16(xd, xd, 4);
			int16x8_t xe = mq_mmul_x8(mq_add_x8(
				mq_mmul_x8(xa, xb),
				mq_mmul_x8(xc, xd)), xR2);
			vst1q_s16((int16_t *)(a + i), xe);
		}
		return;
	}
#endif
	for (size_t i = 0; i < n; i ++) {
		uint32_t x = mq_mmul(a[i], b[n - 1 - i]);
		uint32_t y = mq_mmul(c[i], d[n - 1 - i]);
		a[i] = mq_mmul(mq_add(x, y), R2);
	}
}

#if FNDSA_AVX2
TARGET_AVX2
int
avx2_mqpoly_is_invertible(unsigned logn, const int8_t *f, uint16_t *tmp)
{
	size_t n = (size_t)1 << logn;
	avx2_mqpoly_small_to_int(logn, f, tmp);
	avx2_mqpoly_int_to_ntt(logn, tmp);
	if (logn >= 4) {
		const __m256i *tp = (const __m256i *)tmp;
		__m256i qq = _mm256_set1_epi16(Q);
		__m256i yr = _mm256_set1_epi16(-1);
		for (size_t i = 0; i < (n >> 4); i ++) {
			__m256i y = _mm256_loadu_si256(tp + i);
			yr = _mm256_and_si256(yr, _mm256_sub_epi16(y, qq));
		}
		uint32_t r = (uint32_t)_mm256_movemask_epi8(yr);
		return (r & 0xAAAAAAAA) == 0xAAAAAAAA;
	} else {
		uint32_t r = 0xFFFFFFFF;
		for (size_t i = 0; i < n; i ++) {
			r &= (uint32_t)tmp[i] - Q;
		}
		return (r >> 16) != 0;
	}
}
#endif

#if !FNDSA_ASM_CORTEXM4
/* see inner.h */
TARGET_SSE2
uint32_t
mqpoly_sqnorm_binf_int(unsigned logn, const uint16_t *a)
{
	/*
	 * If all values are at most B_INF in absolute value, then the
	 * maximum possible sum is 1024*B_INF^2, which is lower than
	 * 2^30; thus, the addition cannot overflow (i.e. if it does,
	 # then the B_INF check will saturate the output anyway).
	 */
	size_t n = (size_t)1 << logn;
#if FNDSA_SSE2
	if (logn >= 3) {
		__m128i xq = _mm_set1_epi16(Q);
		__m128i xh = _mm_set1_epi16((Q - 1) >> 1);
		__m128i bbp = _mm_set1_epi16(B_INF);
		__m128i bbm = _mm_set1_epi16(-B_INF);
		const __m128i *ap = (const __m128i *)a;
		__m128i xs = _mm_setzero_si128();
		__m128i xbb = _mm_setzero_si128();
		for (size_t i = 0; i < (1u << (logn - 3)); i ++) {
			__m128i x = _mm_loadu_si128(ap + i);
			/* Normalize to signed. */
			x = _mm_sub_epi16(x,
				_mm_and_si128(xq, _mm_cmpgt_epi16(x, xh)));
			/* Check infinity norm. */
			xbb = _mm_or_si128(xbb, _mm_cmpgt_epi16(x, bbp));
			xbb = _mm_or_si128(xbb, _mm_cmplt_epi16(x, bbm));
			/* Accumulate squared norm. */
			__m128i xlo = _mm_mullo_epi16(x, x);
			__m128i xhi = _mm_mulhi_epi16(x, x);
			__m128i x0 = _mm_unpacklo_epi16(xlo, xhi);
			__m128i x1 = _mm_unpackhi_epi16(xlo, xhi);
			xs = _mm_add_epi32(xs, _mm_add_epi32(x0, x1));
		}
		xs = _mm_add_epi32(xs, _mm_srli_epi64(xs, 32));
		xs = _mm_add_epi32(xs, _mm_bsrli_si128(xs, 8));
		/* Apply infinity norm check. */
		xbb = _mm_or_si128(xbb, _mm_slli_epi32(xbb, 16));
		xbb = _mm_or_si128(xbb, _mm_srli_epi32(xbb, 16));
		xbb = _mm_or_si128(xbb, _mm_srli_epi64(xbb, 32));
		xbb = _mm_or_si128(xbb, _mm_bsrli_si128(xbb, 8));
		xs = _mm_or_si128(xs, xbb);
		return (uint32_t)_mm_cvtsi128_si32(xs);
	}
#elif FNDSA_NEON
	if (logn >= 3) {
		int16x8_t xq = vdupq_n_s16(Q);
		int16x8_t xh = vdupq_n_s16((Q - 1) >> 1);
		int16x8_t bbp = vdupq_n_s16(B_INF);
		int16x8_t bbm = vdupq_n_s16(-B_INF);
		int32x4_t xs = vdupq_n_s32(0);
		int16x8_t xbb = vdupq_n_s16(0);
		for (size_t i = 0; i < (1u << (logn - 3)); i ++) {
			int16x8_t x = vld1q_s16((int16_t *)a + (i << 3));
			/* Normalize to signed. */
			x = vsubq_s16(x, vandq_s16(xq, vcgtq_s16(x, xh)));
			/* Check infinity norm. */
			xbb = vorrq_s16(xbb, vcgtq_s16(x, bbp));
			xbb = vorrq_s16(xbb, vcltq_s16(x, bbm));
			/* Accumulate squared norm. */
			int16x4_t xlo = vget_low_s16(x);
			int16x4_t xhi = vget_high_s16(x);
			int32x4_t x0 = vmull_s16(xlo, xlo);
			int32x4_t x1 = vmull_s16(xhi, xhi);
			xs = vaddq_s32(xs, vaddq_s32(x0, x1));
		}
		int32x2_t xsl = vadd_s32(vget_low_s32(xs), vget_high_s32(xs));
		uint32_t r = vget_lane_s32(xsl, 0) + vget_lane_s32(xsl, 1);
		/* Apply infinity norm check. */
		uint32x2_t bbl = vreinterpret_u32_s16(
			vorr_s16(vget_low_s16(xbb), vget_high_s16(xbb)));
		uint32_t b = vget_lane_u32(bbl, 0) | vget_lane_u32(bbl, 1);
		b |= (b << 16) | (b >> 16);
		return r | b;
	}
#endif
	uint32_t s = 0;
	uint32_t sat = 0;
	for (size_t i = 0; i < n; i ++) {
		uint32_t x = a[i];
		x -= Q & ((((Q - 1) >> 1) - x) >> 16);
		int32_t y = *(int32_t *)&x;
		s += (uint32_t)(y * y);
		sat |= s;
		sat |= (uint32_t)(B_INF - y);
		sat |= (uint32_t)(B_INF + y);
	}
	s |= -(sat >> 31);
	return s;
}
#endif

/* see inner.h */
TARGET_SSE2
uint32_t
mqpoly_sqnorm_binf_signed(unsigned logn, const int16_t *a)
{
	/*
	 * If all values are at most B_INF in absolute value, then the
	 * maximum possible sum is 1024*B_INF^2, which is lower than
	 * 2^30; thus, the addition cannot overflow (i.e. if it does,
	 # then the B_INF check will saturate the output anyway).
	 */
	size_t n = (size_t)1 << logn;
#if FNDSA_SSE2
	if (logn >= 3) {
		__m128i bbp = _mm_set1_epi16(B_INF);
		__m128i bbm = _mm_set1_epi16(-B_INF);
		const __m128i *ap = (const __m128i *)a;
		__m128i xs = _mm_setzero_si128();
		__m128i xbb = _mm_setzero_si128();
		for (size_t i = 0; i < (1u << (logn - 3)); i ++) {
			__m128i x = _mm_loadu_si128(ap + i);
			/* Check infinity norm. */
			xbb = _mm_or_si128(xbb, _mm_cmpgt_epi16(x, bbp));
			xbb = _mm_or_si128(xbb, _mm_cmplt_epi16(x, bbm));
			/* Accumulate squared norm. */
			__m128i xlo = _mm_mullo_epi16(x, x);
			__m128i xhi = _mm_mulhi_epi16(x, x);
			__m128i x0 = _mm_unpacklo_epi16(xlo, xhi);
			__m128i x1 = _mm_unpackhi_epi16(xlo, xhi);
			xs = _mm_add_epi32(xs, _mm_add_epi32(x0, x1));
		}
		xs = _mm_add_epi32(xs, _mm_srli_epi64(xs, 32));
		xs = _mm_add_epi32(xs, _mm_bsrli_si128(xs, 8));
		/* Apply infinity norm check. */
		xbb = _mm_or_si128(xbb, _mm_slli_epi32(xbb, 16));
		xbb = _mm_or_si128(xbb, _mm_srli_epi32(xbb, 16));
		xbb = _mm_or_si128(xbb, _mm_srli_epi64(xbb, 32));
		xbb = _mm_or_si128(xbb, _mm_bsrli_si128(xbb, 8));
		xs = _mm_or_si128(xs, xbb);
		return (uint32_t)_mm_cvtsi128_si32(xs);
	}
#elif FNDSA_NEON
	if (logn >= 3) {
		int16x8_t bbp = vdupq_n_s16(B_INF);
		int16x8_t bbm = vdupq_n_s16(-B_INF);
		int32x4_t xs = vdupq_n_s32(0);
		int16x8_t xbb = vdupq_n_s16(0);
		for (size_t i = 0; i < (1u << (logn - 3)); i ++) {
			int16x8_t x = vld1q_s16((int16_t *)a + (i << 3));
			/* Check infinity norm. */
			xbb = vorrq_s16(xbb, vcgtq_s16(x, bbp));
			xbb = vorrq_s16(xbb, vcltq_s16(x, bbm));
			/* Accumulate squared norm. */
			int16x4_t xlo = vget_low_s16(x);
			int16x4_t xhi = vget_high_s16(x);
			int32x4_t x0 = vmull_s16(xlo, xlo);
			int32x4_t x1 = vmull_s16(xhi, xhi);
			xs = vaddq_s32(xs, vaddq_s32(x0, x1));
		}
		int32x2_t xsl = vadd_s32(vget_low_s32(xs), vget_high_s32(xs));
		uint32_t r = vget_lane_s32(xsl, 0) + vget_lane_s32(xsl, 1);
		/* Apply infinity norm check. */
		uint32x2_t bbl = vreinterpret_u32_s16(
			vorr_s16(vget_low_s16(xbb), vget_high_s16(xbb)));
		uint32_t b = vget_lane_u32(bbl, 0) | vget_lane_u32(bbl, 1);
		b |= (b << 16) | (b >> 16);
		return r | b;
	}
#endif
	uint32_t s = 0;
	uint32_t sat = 0;
	for (size_t i = 0; i < n; i ++) {
		int32_t y = a[i];
		s += (uint32_t)(y * y);
		sat |= s;
		sat |= (uint32_t)(B_INF - y);
		sat |= (uint32_t)(B_INF + y);
	}
	s |= -(sat >> 31);
	return s;
}

#if 0 /* obsolete */
#if !FNDSA_ASM_CORTEXM4
/* see inner.h */
uint32_t
mqpoly_sqnorm_int_to_signed(unsigned logn, uint16_t *a)
{
	/*
	 * The normalized values are at most (q-1)/2 in absolute value,
	 * thus the squares are at most 37748736. If the sum overflows,
	 * then it must at some point be in [2^31,2^32-1], i.e. with
	 * the highest bit set.
	 */
	size_t n = (size_t)1 << logn;
	uint32_t s = 0;
	uint32_t sat = 0;
	for (size_t i = 0; i < n; i ++) {
		uint32_t x = a[i];
		x -= Q & ((((Q - 1) >> 1) - x) >> 16);
		a[i] = (uint16_t)x;
		int32_t y = *(int32_t *)&x;
		s += (uint32_t)(y * y);
		sat |= s;
	}
	s |= -(sat >> 31);
	return s;
}
#endif
#endif

#if FNDSA_AVX2
TARGET_AVX2
uint32_t
avx2_mqpoly_sqnorm_binf_ext(unsigned logn, const uint16_t *a)
{
	if (logn >= 4) {
		const __m256i *ap = (const __m256i *)a;
		__m256i ys = _mm256_setzero_si256();
		__m256i ysat = _mm256_setzero_si256();
		__m256i qq = _mm256_set1_epi16(Q);
		__m256i hq = _mm256_set1_epi16((Q - 1) >> 1);
		__m256i bbp = _mm256_set1_epi16(B_INF);
		__m256i bbm = _mm256_set1_epi16(-B_INF);
		__m256i ylif = _mm256_setzero_si256();
		for (size_t i = 0; i < (1u << (logn - 4)); i ++) {
			__m256i y = _mm256_loadu_si256(ap + i);

			/* Normalize to [-q/2,+q/2]. */
			__m256i ym = _mm256_cmpgt_epi16(y, hq);
			y = _mm256_sub_epi16(y, _mm256_and_si256(ym, qq));

			/* If the value is outside of [-B_INF,+B_INF],
			   some bits of ylif will be set to 1. */
			ylif = _mm256_or_si256(ylif, _mm256_or_si256(
				_mm256_cmpgt_epi16(y, bbp),
				_mm256_cmpgt_epi16(bbm, y)));

			/* Compute and add coefficient squares. */
			__m256i ylo = _mm256_mullo_epi16(y, y);
			__m256i yhi = _mm256_mulhi_epi16(y, y);
			__m256i y0 = _mm256_blend_epi16(
				ylo, _mm256_bslli_epi128(yhi, 2), 0xAA);
			__m256i y1 = _mm256_blend_epi16(
				_mm256_bsrli_epi128(ylo, 2), yhi, 0xAA);
			ys = _mm256_add_epi32(ys, _mm256_add_epi32(y0, y1));

			/* Since normalized values are at most floor(q/2)
			   (i.e. 6144), the addition above added at most
			   2*6144^2 = 75497472, which is (much) lower than
			   2^31. If an overflow occurs at some point, then
			   the corresponding slot must first go through
			   a value with its high bit set. */
			ysat = _mm256_or_si256(ysat, ys);
		}

		/* Merge the L-infinity failure bits into the overflow
		   bits in ysat. */
		ylif = _mm256_or_si256(ylif, _mm256_slli_epi32(ylif, 16));
		ysat = _mm256_or_si256(ysat, ylif);

		/* Finish the addition. We saturate to 2^32-1 if any of
		   the overflow of L-infinity bits was set. */
		ys = _mm256_add_epi32(ys, _mm256_srli_epi64(ys, 32));
		ysat = _mm256_or_si256(ysat, ys);
		ys = _mm256_add_epi32(ys, _mm256_bsrli_epi128(ys, 8));
		ysat = _mm256_or_si256(ysat, ys);
		__m128i xs = _mm_add_epi32(
			_mm256_castsi256_si128(ys),
			_mm256_extracti128_si256(ys, 1));
		uint32_t r = (uint32_t)_mm_cvtsi128_si32(xs);
		uint32_t sat = (uint32_t)_mm256_movemask_epi8(ysat);
		sat = (sat & 0x88888888) | (r & 0x80000000);
		sat |= -sat;
		return r | (uint32_t)(*(int32_t *)&sat >> 31);
	} else {
		size_t n = (size_t)1 << logn;
		uint32_t s = 0;
		uint32_t sat = 0;
		for (size_t i = 0; i < n; i ++) {
			uint32_t x = a[i];
			x -= Q & ((((Q - 1) >> 1) - x) >> 16);
			int32_t y = *(int32_t *)&x;
			s += (uint32_t)(y * y);
			sat |= s;
			/* Also check L-infinity norm. */
			sat |= (uint32_t)(B_INF - y);
			sat |= (uint32_t)(B_INF + y);
		}
		s |= -(sat >> 31);
		return s;
	}
}
#endif

#if !FNDSA_ASM_CORTEXM4
/* see inner.h */
TARGET_SSE2
uint32_t
mqpoly_sqnorm_signed(unsigned logn, const uint16_t *a)
{
	size_t n = (size_t)1 << logn;
#if FNDSA_SSE2
	if (logn >= 3) {
		const __m128i *ap = (const __m128i *)a;
		__m128i ys = _mm_setzero_si128();
		for (size_t i = 0; i < (1u << (logn - 3)); i ++) {
			__m128i y = _mm_loadu_si128(ap + i);
			__m128i ylo = _mm_mullo_epi16(y, y);
			__m128i yhi = _mm_mulhi_epi16(y, y);
			__m128i y0 = _mm_unpacklo_epi16(ylo, yhi);
			__m128i y1 = _mm_unpackhi_epi16(ylo, yhi);
			ys = _mm_add_epi32(ys, _mm_add_epi32(y0, y1));
		}
		ys = _mm_add_epi32(ys, _mm_srli_epi64(ys, 32));
		ys = _mm_add_epi32(ys, _mm_bsrli_si128(ys, 8));
		return (uint32_t)_mm_cvtsi128_si32(ys);
	}
#elif FNDSA_NEON
	if (logn >= 3) {
		int32x4_t ys = vdupq_n_s32(0);
		for (size_t i = 0; i < (1u << (logn - 3)); i ++) {
			int16x8_t y = vld1q_s16((int16_t *)a + (i << 3));
			int16x4_t ylo = vget_low_s16(y);
			int16x4_t yhi = vget_high_s16(y);
			int32x4_t y0 = vmull_s16(ylo, ylo);
			int32x4_t y1 = vmull_s16(yhi, yhi);
			ys = vaddq_s32(ys, vaddq_s32(y0, y1));
		}
		int32x2_t ysl = vadd_s32(vget_low_s32(ys), vget_high_s32(ys));
		return vget_lane_s32(ysl, 0) + vget_lane_s32(ysl, 1);
	}
#endif
	uint32_t s = 0;
	for (size_t i = 0; i < n; i ++) {
		int32_t y = *(int16_t *)&a[i];
		s += (uint32_t)(y * y);
	}
	return s;
}
#endif

#if FNDSA_AVX2
TARGET_AVX2
uint32_t
avx2_mqpoly_sqnorm_signed(unsigned logn, const uint16_t *a)
{
	if (logn >= 4) {
		const __m256i *ap = (const __m256i *)a;
		__m256i ys = _mm256_setzero_si256();
		for (size_t i = 0; i < (1u << (logn - 4)); i ++) {
			__m256i y = _mm256_loadu_si256(ap + i);
			__m256i ylo = _mm256_mullo_epi16(y, y);
			__m256i yhi = _mm256_mulhi_epi16(y, y);
			__m256i y0 = _mm256_blend_epi16(
				ylo, _mm256_bslli_epi128(yhi, 2), 0xAA);
			__m256i y1 = _mm256_blend_epi16(
				_mm256_bsrli_epi128(ylo, 2), yhi, 0xAA);
			ys = _mm256_add_epi32(ys, _mm256_add_epi32(y0, y1));
		}
		ys = _mm256_add_epi32(ys, _mm256_srli_epi64(ys, 32));
		ys = _mm256_add_epi32(ys, _mm256_bsrli_epi128(ys, 8));
		__m128i xs = _mm_add_epi32(
			_mm256_castsi256_si128(ys),
			_mm256_extracti128_si256(ys, 1));
		return (uint32_t)_mm_cvtsi128_si32(xs);
	} else {
		size_t n = (size_t)1 << logn;
		uint32_t s = 0;
		for (size_t i = 0; i < n; i ++) {
			int32_t y = *(int16_t *)&a[i];
			s += (uint32_t)(y * y);
		}
		return s;
	}
}
#endif

/* see inner.h */
int
mqpoly_sqnorm_is_acceptable(unsigned logn, uint32_t norm)
{
	static const uint32_t SQBETA[] = {
		0,        /* unused */
		101498,
		208714,
		428865,
		892039,
		1852696,
		3842630,
		7959734,
		16468416,
		34034726,
		70265242
	};
	return norm <= SQBETA[logn];
}

/* Constants are public so that they can be shared with alternate
   implementations. */
ALIGN32
const uint16_t mq_GM[] = {
	10952, 11183, 10651,  1669, 12036,  5517, 11593,  9397,  7900,  2739,
	10901,   589,   971,  1704,  4857,  5562,  6241, 10889,  7260,  3046,
	 3102,  8228,   519,  6606, 10000,  5956,  6332, 11479,   918,  6357,
	 7237,   196,  8614,  3587, 11068, 11665,  3165,  1074,  8124,  3246,
	 9490, 10617,   946,  1812,  2862,  6807,  6659,  7117,  8726,  9985,
	   10,  9788,  4473,  8204, 11528,  7220,   657, 11417, 10842,  1827,
	 2845,  7372,  8118, 12120, 11262,  7386,   672,  1521,   734,  8135,
	 7848,  5913, 12199, 10220,  8447,  4800,  6849,  8754, 12187,  3390,
	10989,  5616,  4584,  3792,   618,  7653,  2623,  3907,  3775,  8270,
	 2759, 11676,  1514,  9681,   182,  1180,  2453,  9557,  9954,   256,
	 6264,  1450, 11792, 10012,   203,  6988, 12216,  9655,  5443, 11387,
	 9242,  8739,  8394,  9453,   311,  7013,  7618,  1991, 11971,  3340,
	 4457,  7290,  7841,  3977,  8601, 10525,  4232,  8262,  9581, 11207,
	11931,  1055,  6997, 11064,   208, 11882,  5973,  1724, 10020,   954,
	 8750, 11356, 11685,  8508,  4350,  5786,  5458,  1491,   768,  7005,
	 4930,  8196,  9583,  8249,  1639,  9141,  4387,   219, 11680,  3614,
	12116, 10087,  5450,  1034,  4563, 10273,  3081,  2420,  1684,  4031,
	10170,   306,  2111, 11526,   270,  6207, 10670, 10435, 11721,  4420,
	11376, 10826,  3900,  7730,  4465,  7747,  3540, 11743, 10450,  4012,
	  964, 12057,  4262,   759,  3613,  2088,  5007,  4914,  4011,  3318,
	 5112,  9376,  4397, 10007,  1767,  4164,   878,  4072,   106,  2983,
	 7529, 10732,  9138,  2798,  5855,  4200,  6782,  9535,   588,  2867,
	 9859,  5582,  6867,  6710,  3222,  2794,  9738,   206, 10417,  3663,
	11025,  1528,  8132,  3703,  9062,  4601,  5436,  9451,  8397,  5016,
	   34, 11159,  9371,  2283,  4786, 12259, 10689,  6912,  9827,  3754,
	11782,   224,  5481,  4341, 10318,  2616,  8221,  7251,  5761,  8047,
	12181, 12264,  2763,  5760,  6141, 11321,  5722,  4283, 10712,  9762,
	 4502,  2180, 10873,  5134, 11648,  1786,  4530,  9924,   853,  4180,
	10729,  9197,  3043,  9466,  8115,  4268, 10521,  9604,  4260,  3717,
	 1616,  6291,  7617,  3470,  4828, 11586, 10317,  4095,  9487,  2765,
	 5059,  1740,  6777,  4641,  9748,  9994,   490,   341, 10264,  8748,
	11867,  9688,  7615,  6428,  2831,  3500,  4226,  4847,  4534,  4008,
	11122,  5533,  8350,   795, 11388,  5367,  3593,  7090,  7879,  9220,
	 8366,  1709,  3798, 11120,  7291,  6353, 10034,  4826,  3414,  1473,
	 5704,  6327,  5637,  7108,   640, 11982,    12,  6830,   452,  7387,
	 8918,  8664,  9596,  1311,  8475,   255, 12000,  9605,   225, 11317,
	 9947, 10609,  8712,  6113,  8638,  4958, 10454, 10385,  5769,  8504,
	 2950, 11834,  4612, 11536,  8996,  3903,  9480,   829,  3250, 10538,
	 3623, 11876, 10744, 11590,  2487,  8427,  7036,  2539, 11050,  1420,
	10192,  4635, 10030, 10742, 11709,  9879, 10924,  3439,  7271, 11355,
	 4237,   867,  9373, 11614,   765, 11442,  8079,  8356,  2585, 10953,
	 6577,  5505,  6050, 10731,  7026,  5040,  3812,  2703,  8981,  1510,
	 2385, 11817,  3501,  7979,  8782,   895,  6770,  2705,  5127, 11769,
	  941,  9207,  6692,  7466,  9035,  7667,  4419,  2047,  6765, 10100,
	 9872, 10933,  1414, 10113,  8201, 12253, 10369,   921, 12214,   324,
	 4991,  4000, 11852,  7295, 12204,  2825,  4708,  4731,  6540, 11072,
	  560,  7412,  6155,  2904,  5194, 10988,   251,  9730,  5358,  1923,
	 4248,  9176,   515,   233,  4234,  5304,  3820,  3160,  4680,  9276,
	10410,  1727, 10180, 10094,  6584,  7441, 11798,  1138,  5220,  9401,
	 1634,  4247,  8295,  8406,  5916,     4,  1666,  6075,  4486,  1266,
	 1023, 10819,  7623,  6885,  2252, 11900, 12024, 10976, 10500,  3796,
	 1733,  5294,  2930,  4547,   823, 11683, 10518,  1752,  7417,  4334,
	 6144,  6884,  2573,  4123,  6797, 11928,  9421,  2067,  6820,  2489,
	 1664,  9033,  9425,  8440,  3633,  9375,  8555,  4825,  7457,  6619,
	 6426,  7632,  1503,  1372, 11142,   531,  3742,  7921,  9866,  7518,
	 7712, 10433,  4985,   585,  6622,   395,  7745, 10782,  9746,   663,
	11926,  8450,    70,  7071,  6733,  8272,  6962,  1384,  4599,  6185,
	 2160,   500,  7626,  2448,  7670, 11106,  5100,  2546,  4704, 10647,
	 5138,  7789,  5780,  4524, 11659, 10095,  9973,  9022, 11076, 12122,
	11575, 11441,  3189,  2445,  7510,  1966,  4326,  4415,  6072,  2771,
	 1847,  8734,  7024,  7998, 10598,  6322,  1274,  8260,  4882,  5454,
	 8233,  1792,  6981, 10150,  8810,  8639,  1421, 12049, 11778,  6140,
	 1234,  5975,  3249, 12017,  9602,  4726,  2177, 12224,  4170,  1648,
	10063, 11091,  6621,  1874,  5731,  3261, 11051, 12230,  5046,  8678,
	 5622,  4715,  9783,  7385, 12112,  3714,  1456,  9440,  4944, 12068,
	 8695,  6678, 12094,  5758,  8061, 10400,  5872,  3635,  1339, 10437,
	 5376, 12168,  9932,  8216,  5636,  8587, 11473,  2542,  6131,  1533,
	 8026,   720, 11078,  9164,  1283,  7238,  7363, 10466,  9278,  4651,
	11788,  3639,  9745,  2142,  2488,  6948,  1890,  6582,   956, 11600,
	 8313,  6362,  5898,  2048,  2722,  4954,  6677,  5073,   202,  8467,
	11705,  3506,  6748, 10665,  5256,  5313,   713,  2327, 10471,  9820,
	 3499, 10937, 11206,  4187,  6201,  8604,    80,  4570,  6146,  3926,
	  742,  8592,  3547,  1390,  2521,  7297,  4118,  4822, 10607,  5300,
	 4116,  7780,  7568,  2207, 11202, 10103, 10265,  7269,  6721,  1442,
	11474,  1063,  3441, 10696,  7768,  1343,  1989,  7629,  1185,  4712,
	 9623, 10534,   238,  4379,  4152,  3692,  8924, 12079,  1089, 11517,
	 7344,  1700,  8740,  1568,  1500,  5809, 10781,  6023,  8391,  1601,
	 3460,  7173, 11533, 12114,  7052,  3453,  6120,  5513,  3187,  5403,
	 1250,  6889,  6936,  2971,  2377, 11360,  7802,   213,  7132,  8023,
	 5971,  4682,  1369,  2934,  9012,  4817,  7649,  5298, 12202,  5783,
	 5242,  1441, 11312,  7170,  4163, 12001,  9218,  7368, 10774,  4087,
	 4964,  7066, 10835, 12180, 10572,  7909,  6791,  8513,  3430,  2387,
	10403, 12080,  9335,  6371,  4149,  8129,  7528, 12211,  5004,  9351,
	 7160,  3478,  4120,  1864,  9294,  5565,  5982,   702,   573,   474,
	 5997,  3095,  9406, 11963,  2008,  4106,  1881,  7604,  8793,  9204,
	11609, 10311,  3061,  7422,  2592,   600,  4480, 10140,    84, 10943,
	 3164,  2553,   981, 11492,  5727,  9177, 10169,  1785, 10266,  5790,
	 1575,  5485,  8184,   529, 11828,  5924, 11310, 10128, 11733, 11250,
	 3516, 10372,  8361,  9104,  7706,  7018,  1527,  2743,  4915,  5803,
	10461,    32,   783,  9398,  1474,  7396,  5120,  9833,    96,  5484,
	 3616,  9940,  9899,  7867,  8765,  1460,  8229,  7708,  2734, 11784,
	 1741,  5751,  5081,  6069,  4166,  7564,  5355,  6360,  7397,  9336,
	 5806,  2937,  9172,  1668,  5483,  1383,    26, 10702,  2106,  6632,
	 1422, 10570,  4406,  8985, 12218,  6697,    29,  6265, 10523,  6646,
	11311,  8649,  6587,  3004,  9977,  3106,  1800,  4513,  6355,  2040,
	10488,  9255,  7659,  2797,  9898,  9346,  8251, 12037, 11138,  6447,
	11764,  2268, 10359,  3422,  9230,  1909, 11694,  7486,  8378,  8539,
	 8913,  3770,  3920,  2728,  6218,  8039, 11780,  3182,  1757,  6665,
	  639,  1172,  5158,  2787,  3605,  1631,  5060,   261,  2162,  9831,
	 8182,  3487, 11425, 12089,  9815,  9213,  9221,  2931,  8852,  7966,
	11962,  4362, 11438,  5151,  8909,  9686,  4545,    28, 11662,  5658,
	 6824,  8862,  7161,  1999,  4205, 11328,  3475,  9566, 10434,  3098,
	12055,  1994, 12131,   191
};

/* Constants are public so that they can be shared with alternate
   implementations. */
ALIGN32
const uint16_t mq_iGM[] = {
	 5476,   553,  5310,   819,  1446,   348,  3386,  6271,  9508,  3716,
	11437,  5659,  5850,   694,  4775,  8339, 12191,  2526,  2966, 11830,
	  405,  9123,  9311,  7289,  8986,  5885,  8175, 10738, 10766,  8659,
	  700,  3024,  6229,  8230,  8603,  4722,  5231,  6868,   436,  5816,
	 8679,  6525,  8187,  3908,  7395, 12284,  1152,  7926,  2586,  2815,
	 2741, 10858, 11383, 11816,   836,  7544, 10666,  8227, 11752,  4562,
	  312,  6755,  4351,  7982,  8158, 10173,   882,  1844,  4156,  2224,
	 8644,  3916, 10619,   159,  5149,  8480,  2638,  5989,  1418,  8092,
	 1775,  7668,   451,  3423,  1317,  6181,  8795,  6043,  7283,  6393,
	11564,  9157, 12161,  7312,  1366,  4918, 11699, 12198,  1304, 11532,
	 6451,  4765,  8154,  4257,  4191,  4833,  2318, 11980, 10393,  9997,
	 9481,   650, 10594,    51,  7912,  2720,  9889,  1921,  7179,    45,
	 3188,  8365,  2077, 11922,  5384, 11953,  8596,  6658, 10981,  7130,
	 3974,  3404, 12177,  6398, 10412,  1231,  8833,   800,    15,  9896,
	 5003,  1459,   565, 12272,  9781,  1946,  1419,  9571,  3844,  7758,
	 4293,  8223, 11525,   632,  4313,   936, 12186,  7420, 10892, 10678,
	 8934,  2711,  9498,  1215,  4711, 11995,  1377,  8898, 10189,  3217,
	10890,  7720,  6923,  2380,  4653, 12236, 10253, 11850, 10207,  5261,
	 1141,  3946,  7601,  9733, 10630,  4139,  9832,  3641, 11245,  4338,
	 5765, 10158,   116, 11807, 10283,  7064,   273, 10519,  2271,  3912,
	 8424, 10339,  6876,  6601, 10079,   284,   927,  6954,  3041, 12154,
	 6526,  5089, 12136,  7204,  4129, 11447, 11079,  4604,  1008,  3863,
	11772,  9564,  1101,  6231, 10482,  6449,  6035,  3951,  1574,  5325,
	 2020,  1353,  8191,  9824,  2642, 11905,  5399,  9560,  9396, 10114,
	 8035,   302,  6611,  7914, 11812,  7279, 11427,  3158,  6348, 12185,
	 6757,  2646,  5617,   179,   541,  1354,  9642,  5278, 10391,  7039,
	 6801,  6277,  6339, 11163,  2702,  2333,   735,  5633, 11656, 10046,
	 3107, 11456, 12287,  9331,  8086,  1997,  4021, 11472,  1444,  9679,
	11720,  6390,  2424,  8997,  7242,  7199,  5281,  7084,  7651,  9949,
	10709, 10379,  9637, 10172,  6028,  5887,  7701, 10165,  5183,  9610,
	 7424,  6019,  6795,  9692, 10837,  3067,  8583, 12009,  6753,  9019,
	 3779,  9935,  4732,  6187,  2497,  6363, 10289,  3649, 12127,  6182,
	 5684,   960,    18,  2044,  1088, 11582,   678,  7353,  7239,  2762,
	 5121,  3935,  2311,  1627,  8556,  8943,  1541,  5674,   260,  3581,
	 4792,  8904,  5697,  7898,  2155,  4394,   236,  4952, 11534,  1654,
	 4793, 10383,  9769,  8776,   779,  9264,  3392,  2856,   668,  4852,
	 8111,  2105,  6568,  5762,  6482,  1458,  5711,  4026,   467,  2509,
	 4425,  6827,  1205,   290,  6918,  7274,  3827,  7193, 11579,  6764,
	 4875,  8771,  1931,  4901,  6494,  6917,  6351,  4333,  7020, 10664,
	 5730,  7549,  4193,  7791,  6521,  9983,  6372, 10814,  8037,  3260,
	  952,  7062,  9810,  7970,  3088,  7933,   840,  1171,   486,  6032,
	 1342,  6289,  6017,  1907,  5489,  7491,  7957,  7830,  2451, 12063,
	 8874, 12283,  6298, 11969,  8735,  3326,  2981,  9437,  5408, 10582,
	 9876,  7272,  2968,  2499,  6729, 10390,  5290,  8106,  7679,  2205,
	 8744,  4348,  3461,  6595,  5747,  8114,  3378,  6728, 10285, 10022,
	 3721, 10176, 10539,  4729,  9075,  2337,  7445,   211,  7915,  7157,
	 5974, 12044,  7292,  7415,  3824,  2756, 11419,  3615,  4762,  1401,
	 4097,   986,  6496,  9875, 10554,  2336,  2999, 11481,  4286, 10159,
	 7487,   884, 10155,  2087,  7556,  4623,  1546,   780, 10199,  5718,
	 7327, 10024, 11396,  6465,  9722,   708, 11199, 10038,  7408,  6933,
	 4003,  9428,   484,  3074,  9409,  4763,  6157,    54,  2121,  3264,
	 2519,  2034,  6049,    79, 11292,   117, 10740,  7072,  7506,  4407,
	 6625,  4042,  5145,  2564,  7858,  8877,  9460,  6458, 12275,  3872,
	 7446,  1690,  3569,  6570, 10108,  6308,  8306,  7863,  4679,  1534,
	 1538,  1237,   100,   432,  4401,  8198,  1229, 11208,  6014,  9759,
	 5329,  4342,  4751,  9710, 11703,  5825,  2812,  5266, 10698,  6399,
	 2125,  9180, 10925, 10329, 10404,  1688,  1875,  8100,  8546,  6442,
	 5190,  7674, 10578,   965, 11155,  6407,  2921,  6720,   126,  2019,
	 7616,  7340,  4746,  2315,  1517,  7045, 11269,  2967,  3888, 11389,
	10736,  1156, 10787,  2851,  1820,   489,  8966,   883,  3012,  6130,
	 2796,  6180,  1652, 10086,  7004, 11578,  8973, 11236,  6938, 12276,
	 5453,  3403, 11455,  7703,  4676,  9386,  7621,  2446,  9109,  3467,
	 8507, 10206,  3110,  3604,  3269,  5274,  6397, 10922,  8435,  2030,
	11559,  1762,  2211,  1195,  7319, 10481,  9547, 12241,  1228,  9729,
	 8591, 11552,  7590,  5753, 12273,   914,  3243,  3687,  4773,  5381,
	 8780,  8436,  7737,  1964,  7103, 10531,  6664,   278,  7225,  6634,
	 9327,  6375,  5880,  8197,  3402,  5357,  9394,  7156,  5252,  1060,
	 1556,  3281,  6543,  5654,  4868, 10707,   673, 12247,  7219, 10049,
	11989, 10993,  8578,  4614,   989,   340,  7687,  1748,  8487,  5204,
	10236, 11285,   163,  7586,  4597,  3146, 12052,  5858, 11938,  9298,
	 3362,  7642, 11357, 10229, 10550,  8709,  1469,  9787,    39,  8525,
	 2080,  4070,  2959,  1477,  6249,   943,  4951, 10574,  1888,  2749,
	 2190,  7003,  6199,   727,  8756,  9807,  4101,  6902,  8605,  7680,
	  144,  4063,  8704,  6633,  5424,  9668,  3253,  6188,  9640,  2320,
	 3736,  7783, 10822,  5460,  9948,  3159,  2133,  8723,  6038,  8388,
	 6609,  4956,  4659,  8821,  2700, 11664,  3443,  4551,  3388,  9229,
	 4418,  8763,  6232,   378,  2558, 10559,  5344,  1949,  3133,   754,
	 3240, 11539, 11505,  7919, 11439,  8617,   386,  5600,   105,  7827,
	10443, 10213,  3955, 12170,  7022,  1333,  9933,  5552,  2330,  5150,
	 5473,  8405,  6941,  4424,  5613,  6552, 11568,  2784,  2510,  1012,
	 1093,  6688,  5041,  8505,  8399, 10231,  9639,   841,  9878, 10230,
	 2496,  4884, 11594,  4371,  7993, 11918, 10326,  9216, 10004, 12249,
	 7987,  3044,  4051,  6686,   676,  4395,  7379,   909,  4981,  5788,
	 3488,  9661,   812,  8915, 10536,   292,  1911, 12188,  3608,  2806,
	 9812, 10928, 11265,  9340,  9108,  1988,  6489, 11811,  8998, 11344,
	 8815, 11045, 11218,  1272,  4325,  6395,  3819,  7650,  7056,  2463,
	 8670,  5503,  7707,  6750, 11929,  8276,  5378,  3079, 11018,   408,
	 1851,  9471,  8181,  7323,  6205,  9601,   926,  5475,  4327,  9353,
	 7089,  2114,  9410,  6242,  8950,  1797,  6255,  9817,  7569, 11561,
	10432,  6233,  2452,  1253,  3787,  9478,  7950,  9766,  6174,   619,
	 4514,  3279, 11352,  2834,   599,  1113, 11465, 10204,  6177,  5056,
	 9926,  7488,   136,  4520,  3157, 11672,  9219,  6400,   120,  5434,
	 1825,  7884,  7214,  2654, 11393,  2028,  9562,  9848,  8159, 11652,
	 9128,  6990,  8290,  8777,  7922,  5221,  4759,  9253,  3937, 10126,
	11306,  8534,  4922,  4550,   424,   357,  6228,  6751,  7778,  1158,
	 1097,   315, 10027,  9399,  2250,  9720,   821,  9937, 11016,  9739,
	 6736,  8454, 11065,  8476, 12039, 11209,  3052,  3845, 11597,  8808,
	 8153,  2778,  2609, 12254,  8064,  6326,  5813,  7416,  6898,  2272,
	 5947,  8978,  5852,  3652,   928,  8433,  8530,  7356,  2184, 10418,
	 5879,  6718, 11603,  5393,  8473,  9076,  2835,  2416,  3732,  1867,
	 1457,  4328,  8069,  1432,  1628, 11457,  4900,  8879,  5111,  1434,
	 6325,  2746,  4083,  4858,  8847,  9217, 10122,  2436, 11413,  7030,
	  303,  5733,  3871, 10824
};

/* BEGIN GENERATED M55 STAGE3 TWIDDLES */
/*
 * q=12289 16-bit three-instruction known-twiddle Barrett constants.
 * The root and twist arrays have identical indices to mq_GM/mq_iGM.
 * Generated by generate_stage3_tables.py; do not edit by hand.
 */
ALIGN32
const int16_t fndsa_mq_barrett3_GM[1024] = {
	     1,  -1479,  -5146,   4043,  -1305,    722,   5736,  -4134,
	  3542,  -3504,  -2545,   3621,  -1646,   1212,   3195,   5860,
	 -4821,   2639,  -2625,   -949,   -563,  -2975,  -3006,  -2744,
	  5728,  -4591,   5023,   5828,  -3328,  -5777,  -4978,   1351,
	  2319,  -1170,   -955,   -790,  -3201,   3014,   5086,  -1326,
	  4846,  -2747,  -3135,   3712,   4805,  -3553,  -1062,  -2294,
	  3091,    -81,  -4320,  -1000,  -2963,  -4896,  -3051,   2366,
	 -1177,  -4255,  -1635,  -2768,   -140,  -1853,  -4611,   -726,
	  1260,   4388,   4632,  -5755,   2426,    334,   1428,   1696,
	  2013,  -3289,    729,   3241,   2881,   3284,  -5092,  -2089,
	 -3694,  -5179,  -1759,  -3707,   3382,   -355,  -2548,  -4231,
	  3637,   3459,    145,  -5542,  -2731,  -3932,  -4890,  -5911,
	 -2842,    480,   1022,      9,  -2468,    339,   5791,    544,
	 -1673,   4278,  -5331,  -4989,  -4177,  -3584,   1381,  -2525,
	  -953,  -3748,    827,   5767,   2476,    118,   2197,  -5067,
	  3949,  -3296,   4452,   2396,  -4354,    130,   2837,  -5374,
	  2401,    442,  -5101,  -1067,    390,    773,  -3833,   3778,
	   354,   4861,  -2912,   5698,   5012,  -2481,   2859,  -1045,
	  1017,  -4885,   1632,  -5084,     27,  -3066,  -3763,  -1440,
	  1537,    242,   4714,  -4143,  -2678,   3704,   5019,   -545,
	  1002,   5011,   5088,  -4284,  -4976,  -1607,  -3780,   -875,
	 -2437,   3646,   6022,   2987,  -2566,  -2187,  -6039,  -2422,
	 -1065,   2143,   -404,  -4645,   1168,   5277,  -1207,   3248,
	   493,  -4096,  -5444,   2381,  -4337,   -435,   1378,   1912,
	  2166,   3915,   -113,  -4919,   -160,   3149,     -3,   4437,
	  3636,   4938,   5291,   2704,  -1426,  -4654,   1663,  -1777,
	  3364,   1689,   4057,  -3271,  -2847,  -4414,   2174,   4372,
	 -5042,  -2305,   4053,   2645,   5195,  -2780,  -4895,   1484,
	 -3247,  -2686,  -3978,  -2969,  -2370,   2865,   5332,   3510,
	  1630,  -2126,   5407,   3186,  -1153,  -2884,  -2249,  -4048,
	 -2399,  -3400,  -5191,  -3136,  -3000,    671,   3016,    243,
	 -5559,    420,  -2178,   1544,   3985,   4905,   3531,    476,
	    49,   1263,   5915,   1483,  -2500,  -1489,  -1583,  -5942,
	  1512,    350,  -1815,   5383,   5369,  -2057,  -3202,   4493,
	 -2738,  -5868,  -5735,   2655,  -3009,   1693,    174,    723,
	 -1975,  -3757,    347,   2925,  -3315,   -426,   1858,   4754,
	  3030,   4115,   2361,  -1843,   2908,    218,   3434,  -3529,
	  3963,    576,   6142,  -2447,   1954,  -2051,  -2882,  -1805,
	  3991,  -3969,  -2767,    156,   2281,   5876,  -2031,   5333,
	  3772,    418,   5908,   -453,   5429,  -4774,  -4737,   1293,
	   295,   6099,   5766,    652,  -4016,   4077,  -3762,  -2919,
	   325,  -1404,  -1146,   -948,   5990,   1159,  -3728,  -4049,
	  3329,   4298,   -168,   2692,   5961,  -5106,  -1962,   1594,
	 -6122,  -2555,  -5184,  -1200,   1360,   3956,  -6119,   5297,
	 -4079,  -1058,    922,    441,   1958,   4322,   1112,   2078,
	  4046,    709,  -3150,   1319,   4240,  -3570,  -6065,   -835,
	  2459,    683,   3656,    -64,  -1566,   5782,  -2948,  -2503,
	 -3123,  -1747,  -3054,  -5486,  -4433,  -5919,   3834,  -5257,
	 -5241,  -2920,  -4169,  -3127,  -5468,   1010,  -3482,    787,
	  5057,   4698,   4780,  -3445,   -192,   1321,   4912,  -2049,
	   677,  -5874,  -6055,  -3336,   1323,  -2766,    -52,   3174,
	  1579,   -431,  -2505,   5906,   3957,  -2839,    151,  -2127,
	   -58,   -241,   3532,  -1003,   1956,  -5009,   -885,  -6008,
	  3477,  -5681,    142,  -1105,  -2844,   3438,   -975,   4212,
	 -3029,  -5594,   4782,   5886,  -4213,    504,   2302,   -605,
	  -421,  -4080,   3602,   6068,  -3600,   3263,   6077,  -4624,
	 -4467,  -4789,  -5537,   4749,   4449,  -5456,   -147,  -3789,
	  6118,  -3818,   1190,  -2683,   3860,   5445,  -4536,  -1050,
	  5079,  -3262,   2169,   -522,  -4324,   4916,  -4075,   5315,
	 -1278,  -2344,   1973,  -5574,  -3514,  -1041,   5925,  -1018,
	   654,   3565,   1702,   1987,  -5529,   5206,   3199,    -56,
	  6136,  -5862,  -5415,  -3643,   4948,  -6137,    400,  -1728,
	  5339,   5446,   3710,   6093,    468,  -3988,    316,   -382,
	 -2033,  -3998,   3879,   1922,  -1359,  -5435,    973,  -1254,
	     7,   1936,    845,   3723,   3154,   5054,   3285,  -4360,
	   216,     50,  -5526,    769,    767,  -3805,  -2213,   4153,
	  3120,  -6105,  -6086,   5646,  -3941,   3753,   3536,   5370,
	  3229,   4730,  -1706,   3929,   1282,  -3572,   2021,  -2832,
	  3944,   4099,   5604,  -5530,   2171,  -3480,  -1265,   3007,
	 -2945,   5349,   2633,   1406,  -3232,   -293,   4855,  -3769,
	 -2941,   -567,  -5662,   5289,   3837,   2595,   3221,   4273,
	  4050,  -5207,    844,   5202,   -980,   -682,   4590,  -5082,
	 -3469,   6138,  -4443,  -3418,   4693,   2338,  -2293,   -417,
	  1802,   1555,   5103,  -1891,  -4411,  -1590,   1223,  -2334,
	 -1280,    614,    -24,  -1371,   -904,  -2485,  -5547,  -5039,
	   881,   -365,   1015,  -1927,   5461,  -2946,   2637,  -4510,
	  4684,   3360,  -5135,     63,  -4987,   2373,   3670,   3808,
	   578,   5368,   -450,   1944,  -4661,   -510,  -2622,  -5386,
	  5618,  -1658,   5789,   3502,   5043,    826,   3090,   1398,
	  3065,   1506,  -5703,   4483,  -5900,    910,  -4719,   -751,
	  4518,   3094,   1160,   4820,   2730,   5411,  -2253,   1868,
	  2478,  -2840,   4194,   3019,  -1783,  -5078,  -4565,   4974,
	 -5170,   2672,   -865,   1279,    189,   3116,  -1763,   2209,
	 -1530,   1694,  -3869,  -4423,   5832,   1350,  -1734,  -3815,
	 -5275,  -1790,  -1251,  -5410,   2035,   1040,  -1882,  -6125,
	 -4770,    944,   5287,  -3669,  -5673,  -3020,  -5406,  -4665,
	  4834,   2712,  -2828,   4352,  -4113,     72,   3840,  -1842,
	  3451,  -4094,  -1241,   4378,  -5781,  -3045,  -2643,   1095,
	  2873,   2827,   -791,   2434,  -1120,  -2535,    -21,  -5808,
	   874,  -2301,    170,  -5650,   2307,   4289,   -648,   -150,
	 -1030,   -466,   3821,   1681,   4649,   5969,   2929,   6026,
	  1573,  -3846,   3793,  -6063,   -502,   5118,   2602,  -1901,
	  1849,   5776,  -3268,   3795,  -4301,  -4523,    457,     -8,
	  -879,  -2593,    982,  -2276,   4218,   4390,  -3454,  -3758,
	 -4504,    778,    530,   2626,   3578,   4697,  -3466,   1701,
	 -2046,   2940,  -2957,  -1481,   3317,  -2532,    139,   3332,
	   343,  -3448,   4538,  -1908,  -5211,   1866,   1208,  -4727,
	 -1705,   2450,   -416,    814,    716,  -2110,   2164,  -5416,
	  5412,  -4209,  -3278,  -5993,   3515,   -438,   1218,   5061,
	 -1536,  -1721,   2429,  -4103,   1373,  -2982,    717,  -3589,
	 -3368,   4227,   4238,   -612,  -4222,   1526,   -540,   -125,
	  3163,   4032,   6127,  -4840,   1389,  -2068,   4404,   -346,
	  3359,  -3205,   5209,   1092,   3678,   4265,  -1928,    464,
	  1826,   2926,   4489,  -3171,   1136,   3449,   3708,  -3238,
	  2065,   5826,   3495,   4564,  -3534,   3961,  -1756,   4145,
	  2275,   2461,   4267,   5653,   5063,  -4176,  -1518,  -3765,
	 -1275,   5508,  -1176,  -5734,   4860,   1125,  -1445,  -1131,
	 -5987,  -5596,    579,   3889,  -2769,   3114,  -5966,    212,
	 -3975,   4883,  -5835,   3087,   1417,   5676,  -4505,   2257,
	  3744,   4963,   2528,  -3056,   5102,   -412,  -5588,  -5845,
	  4924,   4781,   1014,   -448,   1327,   3607,   3942,  -5232,
	  2717,     60,   3200,  -1535,   5836,  -4566,   2260,     68,
	   180,   4138,  -4605,   2689,  -1409,  -5219,    204,   5509,
	 -1468,  -3981,  -3407,    463,  -1344,  -3042,  -2483,  -2054,
	  4739,  -4251,  -5518,   1226,  -3028,   5216,   -364,  -2360,
	 -1236,  -3017,  -5246,   4475,   3121,   4705,   1057,  -2600,
	  -406,  -1687,    146,   5268,   1403,   1804,   6094,  -5189,
	  -239,  -2900,    994,   4554,   4670,   -512,   5464,   4906,
	  3375,  -2291,  -3393,   4335,  -4913,   3528,   3825,  -4235,
	 -2947,  -3982,    636,   5609,   -622,  -1737,   5672,   4499,
	  5598,   3344,  -1892,  -3624,  -5724,  -1325,  -1029,  -1945,
	  5959,  -2148,  -3959,   5797,   2442,   1248,   5115,   4939,
	 -1314,   1744,   2894,  -3654,  -5690,  -2455,  -3947,    338,
	  3343,  -4119,   1522,  -2151,    -20,   5002,   4608,   5163,
	  4578,    377,   -375,   1620,  -1836,   -425,  -2185,   -392,
	  6085,  -4167,  -1038,   -923,  -2231,  -6092,   2800,    193,
	   506,   1255,   1392,   5784,   3276,  -3338,   2212,  -2674,
	 -1942,  -3408,   2575,   1165,   2776,  -1178,  -5478,   3511,
};
ALIGN32
const int16_t fndsa_mq_barrett3_GM_twist[1024] = {
	    -3,   3944,  13722, -10780,   3480,  -1925, -15295,  11023,
	 -9445,   9343,   6786,  -9655,   4389,  -3232,  -8519, -15625,
	 12855,  -7037,   6999,   2530,   1501,   7933,   8015,   7317,
	-15273,  12242, -13394, -15540,   8874,  15404,  13274,  -3602,
	 -6183,   3120,   2546,   2106,   8535,  -8037, -13562,   3536,
	-12922,   7325,   8359,  -9898, -12812,   9474,   2832,   6117,
	 -8242,    216,  11519,   2666,   7901,  13055,   8135,  -6309,
	  3138,  11346,   4360,   7381,    373,   4941,  12295,   1936,
	 -3360, -11700, -12351,  15345,  -6469,   -891,  -3808,  -4522,
	 -5368,   8770,  -1944,  -8642,  -7682,  -8757,  13578,   5570,
	  9850,  13810,   4690,   9885,  -9018,    947,   6794,  11282,
	 -9698,  -9223,   -387,  14777,   7282,  10484,  13039,  15761,
	  7578,  -1280,  -2725,    -24,   6581,   -904, -15441,  -1451,
	  4461, -11407,  14215,  13303,  11138,   9557,  -3682,   6733,
	  2541,   9994,  -2205, -15377,  -6602,   -315,  -5858,  13511,
	-10530,   8789, -11871,  -6389,  11610,   -347,  -7565,  14330,
	 -6402,  -1179,  13602,   2845,  -1040,  -2061,  10221, -10074,
	  -944, -12962,   7765, -15193, -13364,   6615,  -7623,   2786,
	 -2712,  13026,  -4352,  13556,    -72,   8175,  10034,   3840,
	 -4098,   -645, -12570,  11047,   7141,  -9877, -13383,   1453,
	 -2672, -13362, -13567,  11423,  13268,   4285,  10079,   2333,
	  6498,  -9722, -16057,  -7965,   6842,   5832,  16103,   6458,
	  2840,  -5714,   1077,  12386,  -3114, -14071,   3218,  -8661,
	 -1315,  10922,  14516,  -6349,  11564,   1160,  -3674,  -5098,
	 -5776, -10439,    301,  13116,    427,  -8397,      8, -11831,
	 -9695, -13167, -14108,  -7210,   3802,  12410,  -4434,   4738,
	 -8970,  -4504, -10818,   8722,   7591,  11770,  -5797, -11658,
	 13444,   6146, -10807,  -7053, -13852,   7413,  13052,  -3957,
	  8658,   7162,  10607,   7917,   6319,  -7639, -14218,  -9359,
	 -4346,   5669, -14417,  -8495,   3074,   7690,   5997,  10794,
	  6397,   9066,  13842,   8362,   7999,  -1789,  -8042,   -648,
	 14823,  -1120,   5808,  -4117, -10626, -13079,  -9415,  -1269,
	  -131,  -3368, -15772,  -3954,   6666,   3970,   4221,  15844,
	 -4032,   -933,   4840, -14353, -14316,   5485,   8538, -11980,
	  7301,  15647,  15292,  -7079,   8023,  -4514,   -464,  -1928,
	  5266,  10018,   -925,  -7799,   8839,   1136,  -4954, -12676,
	 -8079, -10972,  -6295,   4914,  -7754,   -581,  -9157,   9410,
	-10567,  -1536, -16377,   6525,  -5210,   5469,   7685,   4813,
	-10642,  10583,   7378,   -416,  -6082, -15668,   5416, -14220,
	-10058,  -1115, -15753,   1208, -14476,  12730,  12631,  -3448,
	  -787, -16263, -15375,  -1739,  10708, -10871,  10031,   7783,
	  -867,   3744,   3056,   2528, -15972,  -3090,   9941,  10796,
	 -8877, -11460,    448,  -7178, -15895,  13615,   5232,  -4250,
	 16324,   6813,  13823,   3200,  -3626, -10548,  16316, -14124,
	 10876,   2821,  -2458,  -1176,  -5221, -11524,  -2965,  -5541,
	-10788,  -1891,   8399,  -3517, -11306,   9519,  16172,   2226,
	 -6557,  -1821,  -9749,    171,   4176, -15417,   7861,   6674,
	  8327,   4658,   8143,  14628,  11820,  15783, -10223,  14018,
	 13975,   7786,  11116,   8338,  14580,  -2693,   9285,  -2098,
	-13484, -12527, -12746,   9186,    512,  -3522, -13098,   5464,
	 -1805,  15663,  16145,   8895,  -3528,   7375,    139,  -8463,
	 -4210,   1149,   6679, -15748, -10551,   7570,   -403,   5672,
	   155,    643,  -9418,   2674,  -5216,  13356,   2360,  16020,
	 -9271,  15148,   -379,   2946,   7583,  -9167,   2600, -11231,
	  8077,  14916, -12751, -15695,  11234,  -1344,  -6138,   1613,
	  1123,  10879,  -9605, -16180,   9599,  -8701, -16204,  12330,
	 11911,  12770,  14764, -12663, -11863,  14548,    392,  10103,
	-16313,  10181,  -3173,   7154, -10292, -14519,  12095,   2800,
	-13543,   8698,  -5784,   1392,  11530, -13108,  10866, -14172,
	  3408,   6250,  -5261,  14863,   9370,   2776, -15799,   2714,
	 -1744,  -9506,  -4538,  -5298,  14743, -13882,  -8530,    149,
	-16361,  15631,  14439,   9714, -13194,  16364,  -1067,   4608,
	-14236, -14521,  -9893, -16247,  -1248,  10634,   -843,   1019,
	  5421,  10660, -10343,  -5125,   3624,  14492,  -2594,   3344,
	   -19,  -5162,  -2253,  -9927,  -8410, -13476,  -8759,  11626,
	  -576,   -133,  14735,  -2050,  -2045,  10146,   5901, -11074,
	 -8319,  16279,  16228, -15055,  10508, -10007,  -9429, -14319,
	 -8610, -12612,   4549, -10476,  -3418,   9525,  -5389,   7551,
	-10516, -10930, -14943,  14745,  -5789,   9279,   3373,  -8018,
	  7853, -14263,  -7021,  -3749,   8618,    781, -12946,  10050,
	  7842,   1512,  15097, -14103, -10231,  -6919,  -8589, -11394,
	-10799,  13884,  -2250, -13871,   2613,   1819, -12239,  13551,
	  9250, -16367,  11847,   9114, -12514,  -6234,   6114,   1112,
	 -4805,  -4146, -13607,   5042,  11762,   4240,  -3261,   6223,
	  3413,  -1637,     64,   3656,   2410,   6626,  14791,  13436,
	 -2349,    973,  -2706,   5138, -14561,   7855,  -7031,  12026,
	-12490,  -8959,  13692,   -168,  13298,  -6327,  -9786, -10154,
	 -1541, -14314,   1200,  -5184,  12428,   1360,   6991,  14361,
	-14980,   4421, -15436,  -9338, -13447,  -2202,  -8239,  -3728,
	 -8173,  -4016,  15207, -11954,  15732,  -2426,  12583,   2003,
	-12047,  -8250,  -3093, -12852,  -7279, -14428,   6008,  -4981,
	 -6607,   7573, -11183,  -8050,   4754,  13540,  12172, -13263,
	 13786,  -7125,   2306,  -3410,   -504,  -8309,   4701,  -5890,
	  4080,  -4517,  10316,  11794, -15551,  -3600,   4624,  10173,
	 14066,   4773,   3336,  14425,  -5426,  -2773,   5018,  16332,
	 12719,  -2517, -14098,   9783,  15127,   8053,  14415,  12439,
	-12890,  -7231,   7541, -11604,  10967,   -192, -10239,   4912,
	 -9202,  10916,   3309, -11674,  15415,   8119,   7047,  -2920,
	 -7661,  -7538,   2109,  -6490,   2986,   6759,     56,  15487,
	 -2330,   6136,   -453,  15065,  -6151, -11436,   1728,    400,
	  2746,   1243, -10189,  -4482, -12396, -15916,  -7810, -16068,
	 -4194,  10255, -10114,  16167,   1339, -13647,  -6938,   5069,
	 -4930, -15401,   8714, -10119,  11468,  12060,  -1219,     21,
	  2344,   6914,  -2618,   6069, -11247, -11706,   9210,  10021,
	 12010,  -2074,  -1413,  -7002,  -9541, -12524,   9242,  -4536,
	  5456,  -7839,   7885,   3949,  -8845,   6751,   -371,  -8885,
	  -915,   9194, -12100,   5088,  13895,  -4976,  -3221,  12604,
	  4546,  -6533,   1109,  -2170,  -1909,   5626,  -5770,  14441,
	-14431,  11223,   8741,  15980,  -9373,   1168,  -3248, -13495,
	  4096,   4589,  -6477,  10940,  -3661,   7951,  -1912,   9570,
	  8981, -11271, -11300,   1632,  11258,  -4069,   1440,    333,
	 -8434, -10751, -16337,  12906,  -3704,   5514, -11743,    923,
	 -8957,   8546, -13890,  -2912,  -9807, -11372,   5141,  -1237,
	 -4869,  -7802, -11970,   8455,  -3029,  -9197,  -9887,   8634,
	 -5506, -15535,  -9319, -12170,   9423, -10562,   4682, -11052,
	 -6066,  -6562, -11378, -15073, -13500,  11135,   4048,  10039,
	  3400, -14687,   3136,  15289, -12959,  -3000,   3853,   3016,
	 15964,  14921,  -1544, -10370,   7383,  -8303,  15908,   -565,
	 10599, -13020,  15559,  -8231,  -3778, -15135,  12012,  -6018,
	 -9983, -13234,  -6741,   8149, -13604,   1099,  14900,  15585,
	-13130, -12748,  -2704,   1195,  -3538,  -9618, -10511,  13951,
	 -7245,   -160,  -8533,   4093, -15561,  12175,  -6026,   -181,
	  -480, -11034,  12279,  -7170,   3757,  13916,   -544, -14689,
	  3914,  10615,   9085,  -1235,   3584,   8111,   6621,   5477,
	-12636,  11335,  14713,  -3269,   8074, -13908,    971,   6293,
	  3296,   8045,  13988, -11932,  -8322, -12546,  -2818,   6933,
	  1083,   4498,   -389, -14047,  -3741,  -4810, -16249,  13836,
	   637,   7733,  -2650, -12143, -12452,   1365, -14569, -13082,
	 -8999,   6109,   9047, -11559,  13100,  -9407, -10199,  11292,
	  7858,  10618,  -1696, -14956,   1659,   4632, -15124, -11996,
	-14927,  -8917,   5045,   9663,  15263,   3533,   2744,   5186,
	-15889,   5728,  10556, -15457,  -6511,  -3328, -13639, -13170,
	  3504,  -4650,  -7717,   9743,  15172,   6546,  10524,   -901,
	 -8914,  10983,  -4058,   5736,     53, -13338, -12287, -13767,
	-12207,  -1005,   1000,  -4320,   4896,   1133,   5826,   1045,
	-16225,  11111,   2768,   2461,   5949,  16244,  -7466,   -515,
	 -1349,  -3346,  -3712, -15423,  -8735,   8901,  -5898,   7130,
	  5178,   9087,  -6866,  -3106,  -7402,   3141,  14607,  -9362,
};
ALIGN32
const int16_t fndsa_mq_barrett3_iGM[1024] = {
	 -6144,  -5405,   4123,   2573,   2067,  -2868,   -361,  -5492,
	 -2930,   4547,   -606,    823,   4334,  -4872,   1752,  -1771,
	  5469,   2489,  -3256,   1664,  -2914,   3633,  -3849,  -2864,
	  1372,   1503,  -4657,  -5863,  -5670,  -4832,   4825,  -3734,
	   363,  -3839,  -5218,     70,   1384,  -5327,  -4017,  -5556,
	 -1183,  -4619,   2448,  -4663,    500,   2160,  -6104,   4599,
	  1147,    531,  -4368,   3742,  -1856,  -4577,  -4771,  -2423,
	   663,  -2543,  -1507,  -4544,    395,  -5667,    585,   4985,
	  2687,   4726,    -65,   2177,  -1198,  -2226,   1648,   4170,
	 -3611,   5046,    -59,  -1238,   3261,   5731,   1874,  -5668,
	 -4882,   5454,   1792,  -4056,  -3650,  -3479,  -2139,  -5308,
	  -272,   3249,   5975,   1234,   6140,   -511,   -240,   1421,
	 -3189,   2445,   1966,  -4779,   2771,   6072,   4415,   4326,
	 -4029,   1274,  -5967,  -1691,  -4291,  -5265,  -3555,   1847,
	 -5100,   2546,  -1642,   4704,   4524,   5780,  -4500,   5138,
	  -848,   -714,   -167,  -1213,  -3267,  -2316,  -2194,   -630,
	  -238,   4379,   3692,   4152,   -772,   1089,   -210,  -3365,
	  6023,  -1508,   5809,   1500,   1568,  -3549,   1700,  -4945,
	  2024,  -5020,   1442,  -5568,  -1593,   3441,   1063,   -815,
	 -1755,  -2666,   4712,   1185,  -4660,   1989,   1343,  -4521,
	  -742,  -3697,   1390,   3547,   4822,   4118,  -4992,   2521,
	 -2186,  -1087,   2207,  -4721,  -4509,   4116,   5300,  -1682,
	 -5256,   5313,   2327,    713,  -1352,   3499,  -2469,  -1818,
	  3926,  -6143,   4570,     80,  -3685,  -6088,   4187,  -1083,
	  -956,   -689,  -5927,  -3976,   4954,   2722,   2048,   5898,
	 -1624,  -5541,   3506,   -584,  -3822,    202,   5073,  -5612,
	  1211,  -3125,  -5051,   1283,   4651,  -3011,  -1823,  -4926,
	 -5707,   1890,  -5341,   2488,   2142,  -2544,   3639,   -501,
	 -5872,   3635,  -1852,   1339,  -4073,  -2357,   -121,   5376,
	   720,  -4263,   1533,   6131,   2542,   -816,  -3702,   5636,
	 -5622,   4715,  -4904,  -2506,  -2849,   1456,   3714,   -177,
	 -1889,  -4228,   5758,   -195,  -5611,  -3594,   -221,   4944,
	   627,   5658,  -3427,  -5465,   -961,   4205,   1999,  -5128,
	   191,   -158,   1994,   -234,   3098,  -1855,  -2723,   3475,
	   864,   -200,  -3076,  -2474,  -4323,  -3437,   2931,  -3068,
	    28,   4545,  -2603,  -3380,   5151,   -851,   4362,   -327,
	   509,   3182,  -5624,   1757,   2787,   5158,   1172,    639,
	  3487,  -4107,  -2458,   2162,    261,   5060,   1631,   3605,
	   525,   2268,   3422,  -1930,  -4803,   -595,   1909,  -3059,
	 -4250,  -6071,   2728,   3920,   3770,  -3376,  -3750,  -3911,
	  2312,   3106,   4513,   1800,  -3034,  -1801,   2040,  -5934,
	 -5842,  -1151,   -252,  -4038,  -2943,  -2391,   2797,  -4630,
	 -2106,  -5657,  -1719,   1422,  -5592,    -71,  -3304,   4406,
	  3004,  -5702,  -3640,   -978,  -5643,  -1766,  -6024,     29,
	 -5081,   6069,  -4725,   4166,  -2953,  -4892,  -5929,   5355,
	 -1587,     26,   1383,   5483,   1668,  -3117,   2937,   5806,
	 -5120,  -2456,   5484,     96,  -4422,  -2390,  -2349,   3616,
	  5751,   1741,   -505,   2734,  -4581,  -4060,   1460,  -3524,
	 -3516,  -1917,  -3185,  -3928,   2743,   1527,  -5271,  -4583,
	 -4893,   1474,  -2891,    783,     32,  -1828,   5803,   4915,
	 -5727,  -3112,   1785,  -2120,   5485,   1575,   5790,  -2023,
	 -1039,   -556,  -2161,   -979,   5924,   -461,    529,  -4105,
	  3496,  -3085,  -1978,   -680,    600,   2592,  -4867,   3061,
	  -797,    981,   2553,   3164,  -1346,     84,  -2149,   4480,
	 -4120,   1864,   5565,  -2995,    474,    573,    702,   5982,
	 -4685,   1881,   4106,   2008,   -326,  -2883,   3095,   5997,
	  5498,  -3776,   2387,   3430,  -5918,  -2954,   -209,  -1886,
	  3478,  -5129,  -2938,   5004,    -78,  -4761,  -4160,   4149,
	 -5242,   1441,  -5119,   -977,  -4921,  -3071,   -288,   4163,
	 -4380,  -1717,   -109,  -1454,  -5223,   4964,   4087,  -1515,
	 -2377,   -929,    213,  -4487,   4682,   5971,  -4266,  -5157,
	  5783,    -87,   5298,  -4640,   4817,  -3277,   2934,   1369,
	  3898,   1601,  -5116,   3460,   3453,  -5237,   -175,   -756,
	  2971,  -5353,  -5400,   1250,   5403,   3187,   5513,   6120,
	  4389,   2739,    589,  -1388,   5562,   4857,   1704,    971,
	  1337,  -1106,   1669,  -1638,  -2892,   -696,   5517,   -253,
	  6048,  -1400,   3046,  -5029,  -5683,    519,  -4061,   3102,
	   196,  -5052,  -5932,    918,   -810,  -5957,   5956,  -2289,
	  3563,  -2304,  -2501,     10,  -5069,   -761,  -4085,   4473,
	  -169,  -4171,  -4917,   2845,   1827,  -1447,   -872,    657,
	  3675,   3587,   -624,  -1221,   3246,  -4165,   1074,   3165,
	 -5172,  -5630,  -5482,   2862,   1812,    946,  -1672,  -2799,
	  3895,  -2836,  -5276,    311,   3340,   -318,   1991,  -4671,
	 -4027,   4232,  -1764,  -3688,   3977,  -4448,  -4999,   4457,
	 -2453,  -2732,    256,  -2335,  -2277,   -497,   1450,  -6025,
	 -3550,  -3047,   -902,   5443,  -2634,    -73,  -5301,    203,
	  1300,   5616,   3792,   4584,   3907,   2623,  -4636,    618,
	  1180,    182,  -2608,   1514,   -613,   2759,  -4019,   3775,
	  1027,  -4903,   1521,    672,   5913,  -4441,  -4154,    734,
	  3390,   -102,  -3535,  -5440,   4800,  -3842,  -2069,    -90,
	   -34,  -1130,   2283,  -2918,  -5377,  -1600,    -30,   4786,
	  2616,  -1971,   4341,   5481,    224,   -507,   3754,  -2462,
	 -3222,   2794,    206,  -2551,   1528,  -1264,   3663,  -1872,
	  5016,  -3892,  -2838,   5436,   4601,  -3227,   3703,  -4157,
	  -106,   2983,  -1557,  -4760,   4200,   5855,   2798,  -3151,
	 -5579,  -5422,   5582,  -2430,   2867,    588,  -2754,  -5507,
	 -4262,    759,   2088,   3613,   3318,   4011,   4914,   5007,
	  4072,    878,   4164,   1767,  -2282,   4397,  -2913,   5112,
	  1619,  -1854,   4420,   -568,  -4559,   3900,  -1463,   -913,
	  -232,    964,   4012,  -1839,   -546,   3540,  -4542,   4465,
	   173,  -2202,   1034,   5450,   2420,   3081,  -2016,   4563,
	 -6082,    270,   -763,   2111,    306,  -2119,   4031,   1684,
	 -4350,   5786,   1491,   5458,  -4093,   4930,  -5284,    768,
	  3614,   -609,    219,   4387,  -3148,   1639,  -4040,  -2706,
	  2708,  -1082,   1055,   -358,   -407,    208,  -1225,  -5292,
	 -3781,   -604,   -933,  -3539,    954,  -2269,   1724,   5973,
	 -1666,   6075,   1266,   4486,  -5404,  -4666,  -1470,   1023,
	  5294,   1733,   3796,  -1789,  -1313,   -265,   -389,   2252,
	  1879,   1727,  -2195,  -2109,   1138,   -491,  -4848,  -5705,
	     4,   5916,  -3883,  -3994,   4247,   1634,  -2888,   5220,
	 -5194,  -1301,  -2559,    251,  -3113,   4248,   1923,   5358,
	 -3013,   4680,   3160,   3820,   5304,   4234,    233,    515,
	    75,    324,   4000,   4991,   2825,    -85,  -4994,   -437,
	  2904,  -6134,  -4877,    560,  -1217,  -5749,   4731,   4708,
	  5597,  -4823,  -4622,  -3254,  -2189,  -5524,   2047,   4419,
	   921,  -1920,    -36,  -4088,  -2176,   1414,  -1356,  -2417,
	 -3812,   2703,   1510,  -3308,  -4310,   3501,   -472,   2385,
	 -3082,    941,   -520,   5127,   2705,  -5519,    895,  -3507,
	 -4237,    867,   -675,  -2916,  -3933,  -4210,   -847,    765,
	  5040,  -5263,  -1558,   6050,   5505,  -5712,  -1336,   2585,
	 -2487,  -3862,   2539,  -5253,   4635,  -2097,   1420,  -1239,
	  -934,  -5018,   3439,  -1365,  -2410,   -580,  -1547,  -2259,
	 -5769,  -3785,   -455,   2950,   3903,  -3293,   -753,   4612,
	  -699,  -1545,   -413,   3623,  -1751,   3250,    829,  -2809,
	  2693,   1311,    255,  -3814,   -972,    225,  -2684,   -289,
	 -1904,  -1835,   4958,  -3651,   6113,  -3577,  -1680,  -2342,
	  2255,   4826,   1473,   3414,  -5181,   5637,  -5962,   5704,
	 -3625,  -3371,  -4902,    452,  -5459,     12,   -307,    640,
	  1167,   5533,    795,  -3939,  -5199,   3593,   5367,   -901,
	 -5936,  -4998,  -1169,   3798,   1709,  -3923,  -3069,  -4410,
	  2541,  -2295,    341,    490,  -2601,   -422,  -3541,  -2025,
	  4008,   4534,   4847,   4226,   3500,   2831,  -5861,  -4674,
	 -4260,   3717,  -5998,   1616,   -703,   4828,   3470,  -4672,
	  4641,  -5512,   1740,   5059,   2765,  -2802,   4095,  -1972,
	  1416,   5134,   1786,   -641,   4180,    853,  -2365,   4530,
	 -2685,  -1768,   4268,  -4174,  -2823,   3043,  -3092,  -1560,
	  4068,  -5038,  -4242,   5761,   5760,   2763,    -25,   -108,
	  2180,   4502,  -2527,  -1577,   4283,   5722,   -968,   6141,
};
ALIGN32
const int16_t fndsa_mq_barrett3_iGM_twist[1024] = {
	 16383,  14412, -10994,  -6861,  -5512,   7647,    963,  14644,
	  7813, -12124,   1616,  -2194, -11556,  12991,  -4672,   4722,
	-14583,  -6637,   8682,  -4437,   7770,  -9687,  10263,   7637,
	 -3658,  -4008,  12418,  15633,  15119,  12884, -12866,   9957,
	  -968,  10237,  13914,   -187,  -3690,  14204,  10711,  14815,
	  3154,  12316,  -6527,  12434,  -1333,  -5760,  16276, -12263,
	 -3058,  -1416,  11647,  -9978,   4949,  12204,  12722,   6461,
	 -1768,   6781,   4018,  12116,  -1053,  15111,  -1560, -13292,
	 -7165, -12602,    173,  -5805,   3194,   5936,  -4394, -11119,
	  9629, -13455,    157,   3301,  -8695, -15281,  -4997,  15113,
	 13018, -14543,  -4778,  10815,   9733,   9277,   5704,  14154,
	   725,  -8663, -15932,  -3290, -16372,   1363,    640,  -3789,
	  8503,  -6519,  -5242,  12743,  -7389, -16191, -11772, -11535,
	 10743,  -3397,  15911,   4509,  11442,  14039,   9479,  -4925,
	 13599,  -6789,   4378, -12543, -12063, -15412,  11999, -13700,
	  2261,   1904,    445,   3234,   8711,   6175,   5850,   1680,
	   635, -11676,  -9845, -11071,   2058,  -2904,    560,   8973,
	-16060,   4021, -15489,  -4000,  -4181,   9463,  -4533,  13186,
	 -5397,  13386,  -3845,  14847,   4248,  -9175,  -2834,   2173,
	  4680,   7109, -12564,  -3160,  12426,  -5304,  -3581,  12055,
	  1979,   9858,  -3706,  -9458, -12858, -10980,  13311,  -6722,
	  5829,   2898,  -5885,  12588,  12023, -10975, -14132,   4485,
	 14015, -14167,  -6205,  -1901,   3605,  -9330,   6583,   4848,
	-10468,  16380, -12186,   -213,   9826,  16233, -11164,   2888,
	  2549,   1837,  15804,  10602, -13210,  -7258,  -5461, -15727,
	  4330,  14775,  -9349,   1557,  10191,   -539, -13527,  14964,
	 -3229,   8333,  13468,  -3421, -12402,   8029,   4861,  13135,
	 15217,  -5040,  14242,  -6634,  -5712,   6783,  -9703,   1336,
	 15657,  -9693,   4938,  -3570,  10860,   6285,    323, -14335,
	 -1920,  11367,  -4088, -16348,  -6778,   2176,   9871, -15028,
	 14991, -12572,  13076,   6682,   7597,  -3882,  -9903,    472,
	  5037,  11274, -15353,    520,  14961,   9583,    589, -13183,
	 -1672, -15087,   9138,  14572,   2562, -11212,  -5330,  13674,
	  -509,    421,  -5317,    624,  -8261,   4946,   7261,  -9266,
	 -2304,    533,   8202,   6597,  11527,   9165,  -7815,   8181,
	   -75, -12119,   6941,   9013, -13735,   2269, -11631,    872,
	 -1357,  -8485,  14996,  -4685,  -7431, -13754,  -3125,  -1704,
	 -9298,  10951,   6554,  -5765,   -696, -13492,  -4349,  -9613,
	 -1400,  -6048,  -9125,   5146,  12807,   1587,  -5090,   8157,
	 11332,  16188,  -7274, -10452, -10053,   9002,   9999,  10428,
	 -6165,  -8282, -12034,  -4800,   8090,   4802,  -5440,  15823,
	 15577,   3069,    672,  10767,   7847,   6375,  -7458,  12346,
	  5616,  15084,   4584,  -3792,  14911,    189,   8810, -11748,
	 -8010,  15204,   9706,   2608,  15047,   4709,  16063,    -77,
	 13548, -16183,  12599, -11108,   7874,  13044,  15809, -14279,
	  4232,    -69,  -3688, -14620,  -4448,   8311,  -7831, -15481,
	 13652,   6549, -14623,   -256,  11791,   6373,   6263,  -9642,
	-15335,  -4642,   1347,  -7290,  12215,  10826,  -3893,   9397,
	  9375,   5112,   8493,  10474,  -7314,  -4072,  14055,  12220,
	 13047,  -3930,   7709,  -2088,    -85,   4874, -15473, -13106,
	 15271,   8298,  -4760,   5653, -14625,  -4200, -15439,   5394,
	  2770,   1483,   5762,   2610, -15796,   1229,  -1411,  10946,
	 -9322,   8226,   5274,   1813,  -1600,  -6911,  12978,  -8162,
	  2125,  -2616,  -6807,  -8437,   3589,   -224,   5730, -11946,
	 10986,  -4970, -14839,   7986,  -1264,  -1528,  -1872, -15951,
	 12492,  -5016, -10948,  -5354,    869,   7687,  -8253, -15991,
	-14660,  10069,  -6365,  -9146,  15780,   7877,    557,   5029,
	 -9274,  13676,   7834, -13343,    208,  12695,  11092, -11063,
	 13978,  -3842,  13650,   2605,  13122,   8189,    768, -11100,
	 11679,   4578,    291,   3877,  13927, -13236, -10898,   4040,
	  6338,   2477,   -568,  11964, -12484, -15921,  11375,  13751,
	-15420,    232, -14127,  12372, -12844,   8738,  -7823,  -3650,
	-10394,  -4269,  13642,  -9226,  -9207,  13964,    467,   2016,
	 -7922,  14274,  14399,  -3333, -14407,  -8498, -14700, -16319,
	-11703,  -7303,  -1571,   3701, -14831, -12951,  -4544,  -2589,
	 -3565,   2949,  -4450,   4368,   7711,   1856, -14711,    675,
	-16127,   3733,  -8122,  13410,  15153,  -1384,  10828,  -8271,
	  -523,  13471,  15817,  -2448,   2160,  15884, -15881,   6104,
	 -9501,   6144,   6669,    -27,  13516,   2029,  10892, -11927,
	   451,  11122,  13111,  -7586,  -4872,   3858,   2325,  -1752,
	 -9799,  -9565,   1664,   3256,  -8655,  11106,  -2864,  -8439,
	 13791,  15012,  14617,  -7631,  -4832,  -2522,   4458,   7463,
	-10386,   7562,  14068,   -829,  -8906,    848,  -5309,  12455,
	 10738, -11284,   4704,   9834, -10604,  11860,  13330, -11884,
	  6541,   7285,   -683,   6226,   6072,   1325,  -3866,  16065,
	  9466,   8125,   2405, -14513,   7023,    195,  14135,   -541,
	 -3466, -14975, -10111, -12223, -10418,  -6994,  12362,  -1648,
	 -3146,   -485,   6954,  -4037,   1635,  -7357,  10716, -10066,
	 -2738,  13074,  -4056,  -1792, -15767,  11842,  11076,  -1957,
	 -9039,    272,   9426,  14505, -12799,  10244,   5517,    240,
	    91,   3013,  -6088,   7781,  14337,   4266,     80, -12762,
	 -6975,   5256, -11575, -14615,   -597,   1352, -10010,   6565,
	  8591,  -7450,   -549,   6802,  -4074,   3370,  -9767,   4992,
	-13375,  10378,   7567, -14495, -12268,   8605,  -9874,  11084,
	   283,  -7954,   4152,  12692, -11199, -15612,  -7461,   8402,
	 14876,  14457, -14884,   6479,  -7645,  -1568,   7343,  14684,
	 11364,  -2024,  -5568,  -9634,  -8847, -10695, -13103, -13351,
	-10858,  -2341, -11103,  -4712,   6085, -11724,   7767, -13631,
	 -4317,   4944, -11786,   1515,  12156, -10399,   3901,   2434,
	   619,  -2570, -10698,   4904,   1456,  -9439,  12111, -11906,
	  -461,   5872,  -2757, -14532,  -6453,  -8215,   5376, -12167,
	 16217,   -720,   2035,  -5629,   -816,   5650, -10748,  -4490,
	 11599, -15428,  -3976, -14553,  10914, -13146,  14090,  -2048,
	 -9637,   1624,   -584, -11698,   8394,  -4370,  10772,   7215,
	 -7221,   2885,  -2813,    955,   1085,   -555,   3266,  14111,
	 10082,   1611,   2488,   9437,  -2544,   6050,  -4597, -15927,
	  4442, -16199,  -3376, -11962,  14409,  12442,   3920,  -2728,
	-14116,  -4621, -10122,   4770,   3501,    707,   1037,  -6005,
	 -5010,  -4605,   5853,   5624,  -3034,   1309,  12927,  15212,
	   -11, -15775,  10354,  10650, -11324,  -4357,   7701, -13919,
	 13850,   3469,   6823,   -669,   8301, -11327,  -5128, -14287,
	  8034, -12479,  -8426, -10186, -14143, -11290,   -621,  -1373,
	  -200,   -864, -10666, -13308,  -7533,    227,  13316,   1165,
	 -7743,  16356,  13004,  -1493,   3245,  15329, -12615, -12554,
	-14924,  12860,  12324,   8677,   5837,  14729,  -5458, -11783,
	 -2456,   5120,     96,  10900,   5802,  -3770,   3616,   6445,
	 10165,  -7207,  -4026,   8821,  11492,  -9335,   1259,  -6359,
	  8218,  -2509,   1387, -13671,  -7213,  14716,  -2386,   9351,
	 11298,  -2312,   1800,   7775,  10487,  11226,   2258,  -2040,
	-13439,  14034,   4154, -16132, -14679,  15231,   3562,  -6893,
	  6631,  10298,  -6770,  14007, -12359,   5592,  -3786,   3304,
	  2490,  13380,  -9170,   3640,   6426,   1547,   4125,   6024,
	 15383,  10093,   1213,  -7866, -10407,   8781,   2008, -12298,
	  1864,   4120,   1101,  -9661,   4669,  -8666,  -2210,   7490,
	 -7181,  -3496,   -680,  10170,   2592,   -600,   7157,    771,
	  5077,   4893, -13220,   9735, -16300,   9538,   4480,   6245,
	 -6013, -12868,  -3928,  -9103,  13815, -15031,  15897, -15209,
	  9666,   8989,  13071,  -1205,  14556,    -32,    819,  -1707,
	 -3112, -14753,  -2120,  10503,  13863,  -9581, -14311,   2402,
	 15828,  13327,   3117, -10127,  -4557,  10460,   8183,  11759,
	 -6775,   6120,   -909,  -1307,   6935,   1125,   9442,   5400,
	-10687, -12090, -12924, -11268,  -9333,  -7549,  15628,  12463,
	 11359,  -9911,  15993,  -4309,   1875, -12874,  -9253,  12458,
	-12375,  14697,  -4640, -13490,  -7373,   7471, -10919,   5258,
	 -3776, -13690,  -4762,   1709, -11146,  -2274,   6306, -12079,
	  7159,   4714, -11380,  11130,   7527,  -8114,   8245,   4160,
	-10847,  13434,  11311, -15361, -15359,  -7367,     67,    288,
	 -5813, -12004,   6738,   4205, -11420, -15257,   2581, -16375,
};
/* END GENERATED M55 STAGE3 TWIDDLES */
