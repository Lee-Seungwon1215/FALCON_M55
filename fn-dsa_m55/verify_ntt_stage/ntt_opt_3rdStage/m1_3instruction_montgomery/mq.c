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
 * q=12289 16-bit three-instruction rounding-Montgomery constants.
 * The root and twist arrays have identical indices to mq_GM/mq_iGM.
 * Generated by generate_stage3_tables.py; do not edit by hand.
 */
ALIGN32
const int16_t fndsa_mq_mont3_GM[1024] = {
	 -4099,  -8345,  -6759,  -6685,  -8809,   2171,  -3007,  -1265,
	 -5349,  -2945,  10883,   2633,    293,   9057,   3769,   4855,
	   567,  -2941,  -5289,   6627,  -2595,   3837,  -4273,   3221,
	  5207,  -8239,   7087, -11445, -11607,  11309,  -7207,  -7699,
	  6105,  -9169,   6643,   6203,  -3753,  -3941,   6919,  -8753,
	  7559,   3229,  -3929,  10583,  -8717, -11007,  -9457,   2021,
	 12239, -12073,   -769,   6763,   3805,    767,  -4153,  -2213,
	  7235,  -9135,  -7929,   3285,  -3723,    845,      7, -10353,
	  8929,  -7605,    -63,  -5135,  -2373,  -4987,   8481,  -8619,
	  6921, -11711,  10345,  11839, -11779,  -4661,  -6903,   9667,
	-10631,  -6671,   8787,   5789,  11463,   5043,  10891,  -9199,
	 10783,   3065,  -4483,  -5703,  11379,   6389,    751,  -4719,
	 11675,  11009,   1371,  12265,   2485,  11385,   5039,  -5547,
	   365,    881,   1927,   1015,  -9343,   5461,  -7779,   2637,
	 -1555, -10487,   1891,   5103, -10699,  -4411,  -9955,   1223,
	  9951,   4693,    417,  -2293,  -8871,  -4443,  -3469,  -6151,
	-10499,  -5275,  -6879,  -1251,  11249,   2035,   6125,  10407,
	 11345,   7519,   3669,   5287,  -9269,  -5673,   4665,   6883,
	  9577,  -7455,   7937,   9461,  12217,  -4113, -10447,  -8449,
	 -8195,   3451,   7911,  -1241,   3045,  -5781,  -1095,  -2643,
	  9617,   7119,  -1279,   -865,   9173,    189,  -2209,  -1763,
	 10595,  10759,   4423,  -3869,  10939,  -6457,   3815,  10555,
	 -9449,  -9811,  -3019,  -8095,  -7211,  -1783,   7315,  -4565,
	 -5411,  -9559,  10421,  -2253,   7469, -11129,  -7771,  -9195,
	  6513,   1849,  -3795,   9021,   4523,  -4301, -12281,    457,
	  2593,   -879, -10013, -11307,   7899,  -8071,  -8531,   8835,
	 11511,   7785,   9663, -11759,  -4697,  -8711,  -1701,   8823,
	  9349,  10243,   1481,  -2957,  -9757,   3317,   8957,    139,
	-11823,  11259,  -1681,   3821,  -5969,   4649,   6263,   2929,
	 -8443,   1573,   6063,   3793,   7171,  11787,   1901,  -9687,
	  2301, -11415,  -6639, -12119,  -4289,   2307, -12139,  11641,
	  2535,  11169,  -6481,    -21,   9855,   -791,   2873,   2827,
	 -4227,   8921, -11677,  -8051,  10763,   8067,    125,  11749,
	  8257,   3163,  -7449,   6127, -10221,   1389, -11943,  -7885,
	  3205,   3359,  11197,   5209,  -4265,  -8611,  11825,  10361,
	  9363, -10463,   3171,   4489,  -3449, -11153,  -9051,  -8581,
	  4209,  -6877,   5993,   9011, -11851,   3515,  -5061, -11071,
	  1721,  10753,   4103,   2429,  -9307,   1373,   3589,    717,
	  9839,  -1705,  11475,  11873, -10179, -11573,  -6873, -10125,
	 10423,  -5211,   4727, -11081, -10381,  -7751,    343,   8841,
	 -4883,  -3975,  -3087,  -5835,   6613,   1417,  -2257,  -4505,
	 -4963,  -8545,  -9233,  -9761, -11877,  -7187,   5845,   6701,
	 -4781,  -7365, -11841, -11275,  -3607,   1327,  -7057,  -8347,
	 12229,   2717,   1535,  -9089,  -7723,  -6453,  12221, -10029,
	  6781,  -1275,  -6555,  11113,  -1125,  -7429,   1131,  -1445,
	 -6693,  -5987,  -3889,    579,   9175,  -2769,  12077,   6323,
	 -2461,   2275,  -5653,   4267,  -8113,   5063,   3765,  10771,
	 -3961,   8755,  -4145,  10533,   7725,   3495,   2065,  -6463,
	  1687,  11883,   7021, -12143,  10485,   1403,   5189,  -6195,
	 -9389,   -239,   7735, -11295, -11777,  -7619,   7383,  -6825,
	  2291,   3375,  -4335,  -3393,   8761,  -4913,   4235,   3825,
	 -8307,  -2947,  -5609, -11653,   1737,  11667,  -4499,  -6617,
	  4251,   4739,  11063,   6771,   7073,   9261,  -9929,  11925,
	  3017,  11053,  -4475,   7043,  -4705,   3121,  -9689,   1057,
	  3981,  10821,   -463,  -3407,  -9247,  10945, -10235,  -2483,
	  5219,  -1409,  -5509, -12085,  -2689,  -4605, -12109,  -8151,
	  -377,  -7711,  10669,   -375,    425,  10453, -11897,  -2185,
	  4167,   6085,    923,  11251,  -6197,  -2231,   -193,  -9489,
	 -1255, -11783,   6505, -10897,  -8951,  -9013,  -9615, -10077,
	 -8881,  10347,  -1165,   2575, -11111,  -9513,  -3511,   6811,
	 10545,  10975,  -8635,  -9395,   2455,   6599,  11951,  -3947,
	  4119,   3343,   2151, -10767,   7287,  12269,  -5163,  -7681,
	-10141,   5959,  -5797,  -3959,  11041,  -9847,  -4939,   5115,
	  1325,   6565,   1945,  -1029,  -8665,  10397,  -6691,  -8945,
	 -4115,  -9259,   1843,   2361,  12071,  -9381,   3529,  -8855,
	 11713,   3963,   2447,  -6147,   2051, -10335,   1805,   9407,
	  3969,   3991,  12133,  -2767,   6413,   2281,  -5333,  -2031,
	 11871,  -8517,    453,  -6381,  -7515,   5429,  -1293,  -4737,
	 -6421,   9551,  -2655,  -5735,  -1693,  -3009,   -723, -12115,
	  3757,  -1975,  -2925,    347, -11863,  -3315,   7535, -10431,
	 11939, -10777,  -5383,  -1815,   2057,   5369,  -4493,   9087,
	  1489,   9789,  -6347,  -1583,  -1483,   5915,     49,   1263,
	-11231,  -4079,   -441, -11367,   7967, -10331,  10211, -11177,
	  -709,  -8243,  -1319,   9139,  -8719,  -8049,    835,  -6065,
	  -683,   2459, -12225,  -8633,   6507,  10723,   2503,   9341,
	  1747,  -3123,  -6803,   9235,   5919,  -4433,   5257,  -8455,
	  7991,   3329,   9597,  12121,  -7183,   5961,  10695,  10327,
	  2555,   6167, -11089,   7105,   8333, -10929,  -5297,  -6119,
	-10885,    325, -11341,  11143,  -1159,  -6299,   4049,   8561,
	 -4077,   8273,   2919,   8527,  11637,  -6523,    295,   6099,
	   241,  12231,   1003,  -8757,   5009, -10333,  -6281,   -885,
	  5681,   3477,   1105, -12147,   8851,   9445,   8077,   -975,
	 -6695,  -3029,   6403,  -7507,  11785,  -4213,    605,  -9987,
	 -8209,   -421,   6221,  -8687,  -3263,   8689,  -7665,   6077,
	 -6415,    677,  -8953,  -6055,  -9523,   1323,   9115,  12237,
	   431,   1579,   6383,  -2505,   2839,   3957,   2127,    151,
	  7591,   5057,   3445,  -7509,  -1321,  12097,   2049,  -7377,
	 11279,   6821,   -787,   8807,   3127,  -4169,  -5241,   9369,
	 -3565, -11635,  -1987, -10587,   7083,  -5529, -12233,   3199,
	 -6427,  -6153,   3643,  -5415,   6137,  -7341, -10561, -11889,
	  6843,   5339,  -6093,  -8579,  -8301, -11821, -11907, -11973,
	 -8291,  -2033,  10367,   3879,   5435,  -1359, -11035,    973,
	 -9027,   5079, -11767,   2169,   7373,   7965,  -5315,  -4075,
	 -9945,  11011,  -6715,   1973,   1041,   8775, -11271,   5925,
	 -8471,  -6171,   2683, -11099,  -5445,  -8429, -11239,   7753,
	 -6833,   4449,   3789,   -147,  -4749,  -5537,  -4467,  -4789,
	 -5011, -11287,  -8005,  -7201,   1607,   7313,    875,   8509,
	  8643,  -2437,  -2987,  -6267,   2187,   9723,  -9867,  -6039,
	 -2143,  -1065,   4645,  11885,  -5277, -11121,   9041,  -1207,
	 -8193,    493,  -2381,   6845,    435,  -4337,  10377, -10911,
	  4885,   1017,  -7205, -10657,  -9223,     27, -10849,  -3763,
	 12047,   1537,   4143,  -7575,   8585,   9611,    545,   5019,
	 -4861, -11935,   6591,   9377,   2481,  -7277,   1045,   2859,
	  -773, -11899,   8511,  -3833,   1067,  -5101,   2401, -11847,
	 -9603,  -3247,   2969,   8311,  -2865,   9919,   8779,  -6957,
	-10163, -10659,   9103,   5407,  -9405,  -1153,  -8241,  -2249,
	 -8889,  -2399,  -9153,  -5191,   -671,   9289,   -243,  -9273,
	 11869,  -5559,  10745,  10111,  -4905,   3985,  11813,   3531,
	 -1689,  -8925,   3271,   4057,  -7875,  -2847,   7917, -10115,
	  2305,   7247,  -2645,   4053,  -9509,   5195,  10805,  -4895,
	  7351,  -8653,   9585,   5291,  -7635,  10863,   1777,   1663,
	 -3149,  12129,  -4437,     -3,   4919,   -113, -10123,   3915,
	 11809,   9447,     -9, -11267,   -339,   9821,  11745,   5791,
	  8011,  -1673,   4989,  -5331,  -8705,  -4177,   2525,   1381,
	 -8541,   -953,  -5767,    827,  12171,  -9813,   5067,   2197,
	 -8993,   3949,   9893,  -7837,  12159,   7935,  -6915,   2837,
	  5179,   8595,   3707,  -1759,    355,  -8907,   4231,   9741,
	 -3459,   3637,  -6747,    145,  -8357,  -2731,   5911,   7399,
	  3289,   2013,  -3241,    729,   9005,   2881,   2089,   7197,
	 11955,  -9863,  10593, -10861,   5755,  -7657, -11029,  -7901,
	 -2639,  -4821,    949,  -2625,   2975,   -563,  -9545,   9283,
	  4591,  -6561,   6461,   5023,   5777,   8961,  -1351,   7311,
	 -8785,  -8747,  -3621,  -2545,  11077,  10643,   6429,   3195,
	 11567,  -1305,  -8155,  -6553,  -4043,   7143,      1,  -1479,
	    81,   3091, -11289,   7969,  -7393,  -2963,   9923,  -3051,
	  4255,  -1177,  -9521,  -1635,   1853,  12149, -11563,  -4611,
	  2747,  -7443,   8577,  -3135,   3553,   4805,  -9995,  11227,
	  9275,  -3201, -10963,  -7203, -11499,   -955,   2319,  11119,
};
ALIGN32
const int16_t fndsa_mq_mont3_GM_twist[1024] = {
	-32765,  28825, -13721, -21987,  29289,   1925,  15295, -11023,
	  9445,  -9343,  25981, -23113,  -4389,   3231, -24249,  15625,
	 19913, -25731,  25769,  30237,  31267,  24835,  -8015,  -7317,
	 15273,  20527, -19375,  15541,  -8873,  17363, -13273, -29165,
	-26585,  -3119,  30221,  -2107,  24233,   8037,  13561,  -3535,
	 12921,  25443,  24409,   9897, -19955,  23295,  -2831,  -6117,
	-24527,  32553, -11519,  -2667,  24867, -13055,  24633,   6309,
	 29629,  21423,  28409,  -7381,   -373,  27827,  20473,  -1935,
	  3359,  11701,  12351,  17423,   6469,    891,   3807,   4523,
	-27401,  23999, -30825, -24127, -25085,   8757, -13577,  27197,
	 -9849,  18959,  28077,  22883,   9017,  31821,  -6795,  21487,
	-23071, -23545, -32381, -14777,  25485, -10485, -13039,  17007,
	 -7579,   1279,   2725, -32745,  -6581, -31865, -17327,   1451,
	 28307,  11407,  18553,  19465,  21631,  -9557, -29085,  26035,
	 30227,  -9993, -30563, -17391,   6603,    315, -26909,  19257,
	-22239,  -8789,  11871,   6389, -11609,    347, -25203, -14329,
	-26365,   1179,  19167,  29923,   1039, -30707,  22547,  10073,
	   943, -19807,  -7765,  15193,  13365,  26153, -25145,  29981,
	-30057,  19743,   4351, -13557, -32697,  -8175,  22735,  -3839,
	-28669,    645,  12569,  21721,  -7141,   9877, -19385,  31315,
	  2671, -19407,  13567, -11423, -13269,  28483, -10079,  30435,
	 26269,   9721,  16057, -24803,  -6843,  26937,  16665,  -6459,
	 29929, -27053,  -1077,  20383,   3115, -18697,  29549,   8661,
	-31453, -10921, -14517, -26419,  21203,  31609,   3675,   5099,
	  5775, -22329,  32467,  19651,   -427, -24371,  32761, -20937,
	  9695,  13167, -18659,   7211,  -3803, -12409, -28333,  28029,
	  8969, -28265, -21951,  24047,  25177, -11769,   5797,  11657,
	-13445,  26621, -21961, -25715, -18915,  -7413,  19715,   3957,
	 24111,  -7163, -10607,  24851,  -6319, -25129,  14217,   9359,
	  4347,  -5669, -18351,   8495,  29693,  -7691,  26771, -10793,
	 26371,  -9065,  18927,  -8361,  -7999, -30979,   8043, -32121,
	 17945,   1119,  -5807,   4117, -22143, -19689, -23353,   1269,
	-32637, -29401, -16995, -28813,  -6667,  28797,  28547, -15845,
	  4031,    933,  27929, -18415, -18451,  27283,  -8537, -20787,
	 -7301, -15647,  17475, -25689,  24745, -28253,    463, -30841,
	 27501,  22751, -31843, -24969,  23929,  -1135,   4955,  12677,
	  8079, -21795, -26473,  27853,   7755,    581,   9157,  23359,
	-22201,   1535,  16377,  26243,   5211,  27299,  -7685,  27955,
	-22127,  22185,  25389,    415, -26685,  15669,  27353, -18547,
	 10057,   1115,  15753,  31561, -18291, -12729,  20137, -29321,
	-31981, -16505,  15375,   1739, -10709, -21897, -10031,  24985,
	-31901,  -3743,  -3055,  -2527,  15973, -29677,  -9941,  21971,
	-23891,  11461,   -447,   7179, -16873, -13615,  -5231,   4251,
	-16325,  25955, -13823,  -3199,   3627,  10549,  16451, -18643,
	 21891,  -2821,   2459, -31593,   5221,  11525,   2965,   5541,
	 10789, -30877,  -8399, -29251,  11305,  -9519,  16595,  30541,
	-26211, -30947,   9749,   -171,  -4175,  15417,  -7861,  26093,
	 24441,  28109,  -8143, -14629,  20947,  16985,  10223,  18751,
	 18793,  -7787,  21651,  24431, -14581,   2693,  -9285, -30669,
	-19283,  12527,  12745,  23583,   -511, -29245,  13097,  27305,
	-30963, -15663,  16623,  -8895, -29241,  -7375,   -139,   8463,
	-28557,  31619,  26089,  15749, -22217,  25197, -32365,  27097,
	  -155,  32125,   9417,  30093,   5215,  19411,  30409, -16021,
	-23497,  17619,    379,  29821,  -7583,   9167,  30169,  11231,
	 24691, -14917,  12751,  15695,  21535,   1343,   6139,  31155,
	 31645, -10879,   9605,  16181,  -9599, -24067, -16563, -12329,
	 20857,  19999,  18003, -20105, -20905, -14549,  32377,  22665,
	 16313, -10181,   3173,  25613,  10293, -18249, -12095,  -2799,
	-19225,  -8697, -26985,  -1391, -11529,  13109,  21903, -18595,
	 -3407,  -6251, -27507, -14863,  -9369,  29993, -16969,  -2715,
	  1743, -23263,   4539, -27469,  18025,  13881, -24239,   -149,
	 16361, -15631,  18329,  23055,  13193,  16403,   1067,  -4607,
	-18531,  14521,   9893, -16521,   1247, -10633,    843,  -1019,
	 27347, -10661, -22425,   5125,  29145,  18275, -30173,  -3343,
	-32749,   5163, -30515, -22841,   8409,  13477, -24009, -11625,
	   575,    133, -14735, -30717, -30723,  22623,  26867, -21695,
	  8319,  16489, -16229,  15055,  22259, -22761,   9429,  14319,
	-24159,  12613,  -4549, -22291,   3419,  -9525, -27379,  -7551,
	 10517, -21839,  14943, -14745, -26979,  -9279,  29395, -24749,
	 24915, -18505, -25747,   3749,  -8617,  31987, -19823,  22719,
	 24925,  31257, -15097, -18665, -22537, -25849, -24179, -21375,
	 10799,  18883,   2251,  13871,  -2613,  -1819,  12239, -13551,
	 23519,  16367,  20921,  -9113, -20255,   6235,  26653,  31657,
	  4805, -28621, -19161,  27725,  21007,  -4239, -29507,  -6223,
	 -3413,   1637,    -63,  29113,  -2411,  26141,  17977,  19331,
	-30419,  31795, -30061,  27629, -18207,  -7855, -25737, -12025,
	 12489,   8959,  19075, -32601,  19471, -26441,   9785,  10153,
	  1541,  14313,  -1199,   5183,  20339,  -1359,  -6991, -14361,
	 14981,  -4421, -17331,   9337, -19321,   2203,   8239,   3727,
	-24595,   4015,  17561, -20815, -15733,   2427,  20185,  30765,
	 12047,   8249,   3093,  12853,   7279, -18339,  26761,   4981,
	  6607,  -7573,  11183, -24717,  28013, -13541,  20595,  13263,
	-13785,   7125,  30461, -29357, -32265,   8309,  28067, -26877,
	 -4079,   4517,  22451,  20975,  15551,   3599,  -4623,  22595,
	 18703,  -4773,  29433, -14425, -27341,   2773,  -5019,  16435,
	-12719,   2517, -18671,  22985,  17641,  -8053, -14415,  20329,
	 12889,   7231,  -7541,  11605,  21801,    191,  10239,  -4911,
	-23567, -10917,  29459,  11673,  17353,  24649,  25721, -29849,
	-25107, -25229,  30659,   6491,  -2987,  26009,  32713, -15487,
	  2331,  26633,    453, -15065, -26617, -21331,  -1727,   -399,
	 -2747,  -1243, -22579, -28285, -20371, -16851, -24957,  16069,
	-28573, -10255, -22655,  16601,  -1339,  13647,   6939,  27699,
	-27837,  15401,  -8713, -22649,  21299,  20707, -31549,    -21,
	 30425,  25853,   2619,  -6069,  11247,  11705,  -9209, -10021,
	-12009,   2075,   1413,   7003,   9541, -20243,  -9241, -28233,
	 -5455,   7839,  24883,  28819, -23923,  -6751, -32397,   8885,
	-31853,  -9193,  12101,  -5087,  18873,   4975,   3221,  20163,
	 28221,   6533,  -1109,   2171,   1909,  -5627,   5771, -14441,
	 14431,  21545,  -8741,  16787, -23395,  -1167,   3247, -19273,
	 -4095,  28179, -26291,  21827, -29107,  -7951, -30857,  23199,
	 -8981, -21497,  11301,  -1631, -11257,   4069,  -1439,  32435,
	-24335,  10751, -16431, -12905, -29065,  -5515,  11743,   -923,
	-23811,  24223, -18879,   2911,   9807, -21395,  -5141,   1237,
	  4869,   7803, -20799,  24313,   3029, -23571,   9887,  -8633,
	-27261,  15535, -23449,  12169,  -9423, -22207,  -4683, -21715,
	-26701, -26205, -21391, -17695, -19267, -11135,  -4047,  22729,
	 29369,  14687,  -3135, -15289,  12959, -29769,  28915,  29753,
	 16803, -14921, -31225, -22399,  25385,   8303, -15909,    565,
	 22169, -19747,  17209, -24537, -28989,  15135,  20755, -26749,
	  9983, -19535,   6741,  -8149,  13605,  -1099, -14901,  17183,
	 13129, -20019,   2703,  -1195, -29229, -23151,  10511, -13951,
	-25523,    159,   8533,  28675,  15561, -12175,   6027,    181,
	   479,  11033,  20489, -25597,  29011,  18851,    543, -18079,
	 -3915,  22153,  23683, -31533,  -3583,  -8111,  26147,  -5477,
	-20131,  21433, -14713,   3269,  -8075,  13909,   -971,  -6293,
	 -3295,  24723, -13989, -20835, -24447, -20223, -29949,  -6933,
	 -1083,  28269,    389,  14047, -29027,   4811,  16249,  18931,
	 32131,  -7733,   2651,  12143,  12453,  -1365,  14569,  13081,
	-23769,  26659,  23721, -21209,  19667,   9407, -22569,  21475,
	 24909, -10617,   1695, -17811,  -1659,  28137,  15125, -20771,
	 14927,   8917,  -5045,  -9663, -15263,  29235,  30025,  27581,
	-16879,  -5727,  22211, -17311,   6511,   3327, -19129, -19599,
	 -3503,   4651,   7717,  -9743, -15173,  26221,  22243,    901,
	-23855,  21785,   4059,  27033,    -53,  13337,  12287, -19001,
	 12207, -31763,  31769,   4319,  -4895,  31635,  26941,  -1045,
	-16543,  21657,  -2767,  30307,  26819, -16245,   7467, -32253,
	  1349, -29421,   3711,  15423,   8735,  -8901,   5899,  -7131,
	 -5179,  -9087, -25901, -29661,   7403,  -3141, -14607, -23407,
};
ALIGN32
const int16_t fndsa_mq_mont3_iGM[1024] = {
	  4095,  10317,   9487,  -2765,   6777,  -4641,   5059,  10549,
	  3717,  -8029, -10673,  -6291,  -7461,    703,   7617,   8819,
	 -2295,  -2541, -11799,   -341,  11867,   2601,  -2025,   3541,
	 -7755,   8281,  -8063,  -4847,   2831,   8789,   7615,   5861,
	 11321,   6141,  -6567,  -4283,  -7787,  10109,  -1577,   2527,
	  7251,   8221,   5761,  -8047,   2763,   6529,  12181,     25,
	 -7155,  10873,   -641,  10503,    853,   8109,  -7759,   2365,
	 10521,   2685,   8115,   8021,   3043,   2823,  10729,  -9197,
	 -3069,   7879,  -3923,  -1709,   7291,  -6353,  -8491,   1169,
	  5533,  -1167,  -3939,   -795,   3593,   5199,   -901,  -5367,
	 -7463,  -2255,  -8875,  -1473,   5637,   5181,  -6585,  -6327,
	 -3371,   3625, -11837,  -7387, -12277,   5459, -11649,    307,
	 -3785,   5769,  -9339,    455,  -3293,  -3903,  -7677,    753,
	 -1545,    699,   3623,    413,  -9039,   1751,  -2809,   -829,
	  1311,  -2693,   8475,   -255,    225, -11317,   -289,  -9605,
	 -1835, -10385,  -3651,   7331,  -3577,  -6113,   9947, -10609,
	  4731,  -7581,  -5749,   1217,   6155,   9385, -11729,   4877,
	-11965,    -75,   4991,   8289,    -85,  -2825,   -437,  -7295,
	 -1301,  -7095,    251,   2559,  -8041,   3113,  -6931,  -1923,
	 -7609,   3013,  -8469,   9129,  -8055,   6985,    515,   -233,
	  6075, -10623,  -7803,  11023,   7623,  -6885,   1023, -10819,
	  1733,   6995,  -1789,   8493,   -265,   1313, -10037,    389,
	  1727,  -1879,  -2109,   2195,   -491,  11151,  -5705,  -7441,
	 -6373,  12285,   8295,   3883, -10655,  -4247,  -7069,  -9401,
	 -1547,  -2259,  11709,  -9879,   7271, -11355,  -1365,  -3439,
	  8427,   2487,  -5253,  -2539,  -2097,  -4635,  -1239,  10869,
	   867,   4237,   9373,    675,   8079,   3933,    765,    847,
	 -5263,   7249,  -6239, -10731,   6577,  -5505,   2585, -10953,
	 -4823,  -5597,   9035,  -7667,   6765,   2189,   4419,  -2047,
	 10369,   -921,   8201, -12253, -10875, -10113,  -2417, -10933,
	  2703,  -8477,   8981,  10779,   3501,  -7979,   2385, -11817,
	   941,  -9207,   5127, -11769,  -5519,  -2705,  -3507,   -895,
	 10617,  -2799, -11343,  10477,   6659,  -7117,  -9427,  -6807,
	  3587,  -3675,  -1221, -11665,  -4165,   9043,   3165,  11215,
	  9985,  -3563, -12279,   2501,   -761,   5069,   4473,   4085,
	 -4171,    169,   2845,   4917,  -1447,  -1827,    657, -11417,
	  2739,  -4389,  10901,   -589,   4857,   6727,    971,  10585,
	 11183,  -1337,  10651,  -1669,  11593,  -9397,   -253,  -5517,
	 10889,   6241,  -5029,   9243,    519,   5683,  -9187,   4061,
	  7237,  12093, -11371,  -6357,  -5957, -11479,  -2289,   6333,
	 -2069,  12199,   8447,   7489,  12187,   8899,   6849,   3535,
	 -4903,  -1027, -11617,  -1521,  -4441,  -5913, -11555,  -8135,
	 -6673,  10989,  -7705,   8497,   2623,  -3907, -11671,  -7653,
	-12107,  11109, -10775,  -9681,   2759,    613,   3775,   4019,
	  9453,  -3895,    311,  -7013,  11971,   8949,  -4671,  -1991,
	 -8057,   4027,   8601, -10525,   7841,  -3977,   4457,   4999,
	  9557,   2453,  -2335,  12033,   -497,   2277,  -6025,  10839,
	 -3047,  -8739,   5443, -11387,    -73,  -9655,    203,   5301,
	 -2913,  -7177,   4397, -10007, -11411,   8217,   1767,   8125,
	   759,  -8027,   3613,  10201,   4011,   8971,   5007,   7375,
	  2983, -12183,   7529,   1557,   5855,   8089,  -3151,   9491,
	  6867,   5579,   9859,   6707, -11701,  -2867,  -5507,  -9535,
	 11159, -12255,   9371,  -2283,  10689,   5377,  -7503, -12259,
	 -1971,   9673,   5481,  -4341,   -507,  12065,   9827,   8535,
	 -9495,  -9067,  -2551,  12083,  11025,  10761,  10417,  -3663,
	  8397,   7273,  -6853,  -9451,  -3227,  -4601,  -4157,  -3703,
	-10565,   5973,  -2269,  11335,  11685,   3781,  -3539,    933,
	 11207,   9581,  11931,  -1055, -12081,    407,   6997,   1225,
	 -6503,  -7939,  -6831,  -1491,  -7359,   4093, -11521,  -7005,
	  -609,   8675,   4387,   -219,   1639,  -9141,   9583,  -8249,
	 10435,  -1619,  11721,   7869,  -8389,   4559,   -913,   1463,
	-11325, -12057,  -1839,   8277,  -8749, -11743,   4465,  -7747,
	 10087,   -173,  -6839,  11255,   3081,   9869,   4563, -10273,
	-12019,  -6207,   2111,    763,  -2119,  11983, -10605,  -4031,
	   585,   4985,  -5667,   -395,  -2543,   -663,   7745,   1507,
	   531,  -1147,  -8547,  -7921,  -4577, -10433,  -2423,   4771,
	 -3839,   -363, -12219,  -7071,  -5327,  10905,   6733,   4017,
	 -4619,   1183,  -4663,   9841, -10129,  11789,   4599,  -6185,
	 -5405,  -6145,   2573,  -4123,   9421,  -2067,   6797,    361,
	  4547,  -9359,    823, -11683,   7417,   7955,  -1771,  10537,
	  2489,  -5469, -10625,  -9033,   3633,  -9375,   9425,   3849,
	  1503,  10917,  -5863,   4657,   7457,  -6619,   8555,  -4825,
	 10095,  11659,   9973,   3267,  11575, -11441,  -1213,    167,
	 -9743,  -7189,  -7585, -10647,  -6509,   7765,  -7151,  -7789,
	  2445,   3189,  -4779,  10323,  -6217,  -2771,  -7963,  -4415,
	-11015,   4029,  -1691,   5967,  -5265,   4291,   1847,   3555,
	 -7563,  -2687,   2177,     65,  10063, -11091,  -8119,  10641,
	 -7243,   3611,  11051,     59,   5731,  -3261,   6621,  10415,
	 -6835,  -7407,   8233,  10497,  -3479,  -8639,   6981,   2139,
	  3249, -12017, -11055,  -5975,   -511,   6149,   1421, -12049,
	  4187,  -1083,   6201,   3685,  -6143,   8363, -12209,   7719,
	  5313,  -7033,    713,  -2327,   3499, -10937,  10471,   2469,
	 -3697, -11547,   3547,  10899,  -8171,   7467,   2521,  -7297,
	 -1087, -10103,  -4721,  -2207,  -8173,   4509,  10607,   6989,
	  4379, -12051,  -8137,   8597,   1089, -11517,  -3365, -12079,
	 10781,  -6023, -10789,  -5809,  -3549,  10721,  -4945,  10589,
	  7269,  10265,   6721,  10847,   3441,   1593,   -815,  -1063,
	  9623,   1755,   1185,   7577,   1989,  -7629,  -4521,  -1343,
	  -221,  -7345,   8695,   5611,   8061,   1889,   -195,   6531,
	  4715,  -6667,   9783,  -7385, -10833,   2849,   -177,   8575,
	  3635,  -6417,   1339, -10437,  -2357,   4073,  -6913,    121,
	 -4263,  11569,   6131,  -1533,  11473,   9747,  -6653,  -8587,
	  -689, -11333,   8313,   5927,  -9567,   7335,  -6391,  10241,
	 -5541, -10665,  11705,   8783, -12087,  -8467,   6677,  -5073,
	 -3125,  -1211,   1283,   5051,  -3011,  -4651,   7363,   1823,
	-10399,   5707,  -9801,   5341,   9745,  10147,   -501,  -3639,
	  8539,  -3911,   8913,   8519,  -6071,  -8039,  -8369,   9561,
	-10021,   -525,  10359,   8867,   -595,   4803,  -3059,  -1909,
	 -9107,   -509,   1757,  -6665,  -7131,  -2787,    639,  11117,
	 -4107,  -3487, -10127,  -9831,  -7229,   -261,   3605,  -1631,
	 -6631,   -627,  -5465,   3427,   4205,    961,   7161,  -1999,
	 12131,   -191,  12055,  10295,  -1855,   9191,   3475,   2723,
	 12089,  11425,   9815,  -9213,  -3437,   4323,   9221,  -2931,
	  4545,  12261,   8909,   2603,   -851,  -5151,   -327,   7927,
	-10829,   8765,   8229,   4581,   1741,  -5751,  -9555,    505,
	  9833,  -7169, -12193,   6805,   9899,  -7867,  -8673,   2349,
	  6069,   5081,  -8123,   4725,   7397,   2953,   5355,   5929,
	-12263,   1587,   5483,  -1383,  -3117,  10621,  -6483,  -2937,
	 -9183,   9977, -10489,  -4513,  -1801,  -9255,   6355,  10249,
	 -1151,  -6447,   8251, -12037,  -2391,   2943,   7659,  -2797,
	 -5657, -10183, -10867,   1719,    -71,  -6697,  -7883,  -8985,
	  6587,   9285,  11311,  -8649,  10523,   5643,     29,  -6265,
	  3095,   5997,  -2883, -11963,   1881,   4685, -10281,   8183,
	-10425,  -8169,  -2995,  -5565,    573,  11815,  -6307,  11587,
	 -3085,   8793,  11609, -10311,  -9697,  11689,   3061,   4867,
	   981,    797,  -9125,  -2553, -12205, -10943,  -7809,   2149,
	 -1917,  -8773,   8361,   3185,   1527,  -2743,  -4583,   5271,
	-10815,   4893,    783,   2891,  10461,  12257,   4915,  -5803,
	  9177,   5727,  10169,  -1785,   1575,  -5485,  -2023,   6499,
	 11733,   1039,   -979,   2161,   -461,   6365,  -4105,   -529,
	  5513,  -6169,   3187,  -5403,  -5353,  -2971, -11039,  -6889,
	  1601,   8391,  -8829,  -7173,  -5237,  -3453,  11533,    175,
	  -929,   2377,  -4487,   -213,   5971,   7607,  -5157,  -8023,
	   -87,  -5783,   7649,   6991,  -3277,  -4817,   1369,   9355,
	  8513,   6791,  -8859,  -2387,   9335,  -6371,  10403,    209,
	 -5129,   8811,  -7285,  -9351,  -4761, -12211,   4149,  -8129,
	  1441,  -7047,   -977,   5119,  -3071,   4921,   4163, -12001,
	 -1717,  -7909,  10835,    109,  -7325,   5223,  -1515,  -4087,
};
ALIGN32
const int16_t fndsa_mq_mont3_iGM_twist[1024] = {
	-16383,  18355, -21775, -25907, -27257,  -7647,  31805, -14645,
	 -7813, -20643,  -1615, -30573,  11557, -12991,   4671,  28045,
	-18185, -26131,  -8681,   4437,  -7771, -23081,  22505,  -7637,
	  3659, -28761,  20351,  17135, -15119, -12885, -19903,  -9957,
	-31801,  22531, -13913,    187,   3691,  18563,  22057, -14815,
	 29613,  20451,   6527,  20335,   1333,   5759, -16277, -20505,
	-29709, -31353, -11647,   9977,  -4949,  20563,  20047,  26307,
	-31001,  25987,  28749, -12117, -31715,  17657, -31209, -19475,
	-25603,  12601,  32595, -26963,  -3195,  -5935,   4395,  11119,
	 23139,  13455,  32611,  -3301, -24073, -17487,   4997, -15113,
	-13017,  14543,   4779, -10815,  -9733,  23491,  27065, -14153,
	  -725, -24105, -16835,   3291,  16373,  31405,   -639, -28979,
	 24265, -26249,   5243,  20025, -25379,  16191, -20995,  11535,
	 22025,   3397,  16857,  28259,  21327,  18729,  23289, -27843,
	-13599,   6789,  -4379,  12543,  12063,  15413, -11999,  13701,
	 -2261,  -1903,  32323,  29533,  24057,  -6175,  -5851,  -1679,
	  -635, -21091,   9845,  11071,  -2059, -29865,   -559,  23795,
	-16707,  -4021, -17279,   3999,   4181,  23305,   4533,  19583,
	  5397, -13385,   3845, -14847,  28521, -23593, -29933,  30595,
	 28089,  -7109,  12565, -29609, -12425, -27465, -29187,  20713,
	 -1979,  22911,   3707, -23311,  12857,  10981, -13311, -26045,
	 -5829,  29869, -26883,  20179,  20745,  10975,  14133,  -4485,
	-14015, -18601, -26563, -30867,  -3605, -23439,  26185,  -4847,
	 10469,  16387,  12185,    213,  22943, -16233, -21603,  29881,
	 -2549,  30931,  16963, -10601,  13209,   7259,   5461,  15727,
	 -4331,  17993,   9349,  -1557, -10191,    539, -19241, -14965,
	-29539,  24435,  19299, -29347, -20367,  24739,  27907, -13135,
	 17551,   5039,  18527,   6635,   5711,  -6783, -23065,  31433,
	-15657, -23075,  -4939, -29197,  21907,  26483,  32445,  14335,
	  1919,  21401, -28681, -16419,   6779,  -2175,  -9871,  15029,
	-14991, -20195, -13077,  -6683,  25171,   3883,   9903,  32297,
	 27731, -11273,  15353,  32249,  17807,  -9583,  32179,  13183,
	-31097,  15087,  23631,  18195,  30205, -21555, -27437, -13673,
	-32259,   -421,   5317,   -623,   8261,  27821,  25507, -23503,
	  2303,   -533,  -8201,  -6597,  21241,  23603, -24953,  -8181,
	    75, -20649,  25827,  -9013, -19033,  30499,  11631,  31897,
	-31411,   8485, -14997, -28083, -25337,  13753,   3125, -31065,
	-23471,  21817,  -6555,   5765, -32073,  13493, -28419, -23155,
	-31369,   6047,   9125,  -5147,  19961,  31181, -27677,  24611,
	-11333,  16579,   7275,  10453,  10053,  -9001,  -9999,  22339,
	  6165,   8281, -20735,   4799,  -8091,  27965,   5439, -15823,
	-15577,  29699,   -671, -10767,  24921,  26393, -25309, -12345,
	 -5615,  17683,  28185,   3791, -14911,  32579,  -8809,  11749,
	  8011, -15205,  -9705,  -2607,  17721,  -4709, -16063, -32691,
	 19219, -16585,  20169,  11109,  24893, -13045,  16959, -18489,
	 28537,     69, -29081, -18147,   4447,  24457, -24937,  15481,
	-13653,  -6549,  14623,    255, -11791,  -6373,  26505,   9641,
	-17433, -28125,  31421,   7291,  20553, -10825,   3893,  -9397,
	 -9375,  27657,  24275, -10473, -25453, -28697,  18713,  20547,
	 19721,   3931,  25059, -30681,     85,  -4875, -17295, -19663,
	 17497,  -8297, -28009,  -5653, -18143, -28569,  15439,  27373,
	 29997,  -1483,  27005,  30157,  15797,  31539, -31357,  21823,
	  9321,  24543,  -5275,  -1813,   1599,   6911,  19791, -24605,
	 30643, -30153, -25961,   8437,  -3589,    223,  27037,  11945,
	-10985,   4971, -17929,  24781,   1263, -31241,   1871,  15951,
	 20275, -27753,  10949,   5355,   -869,  25081, -24515, -16777,
	 14661, -10069, -26403,   9145, -15781,  -7877,  32211,  -5029,
	  9273,  19091,  -7835,  13343,   -207,  20073, -11093, -21705,
	-13977, -28925,  19119,  30163,  19647,  24579,   -767, -21667,
	-11679,  28189,  32477,  -3877,  18841,  13237, -21871,  28729,
	 26429,  30291, -32201,  20803,  12485, -16847, -11375,  19017,
	-17347,  32537,  14127, -12373, -19923,  24031,   7823, -29117,
	 10393, -28499, -13641,   9225, -23561,  18803,  32301,  -2015,
	-24845,  18495, -14399,   3333, -18361, -24271, -18067,  16319,
	-21065, -25465, -31197,  -3701,  14831, -19817,   4543, -30179,
	-29203,  -2949, -28317,  -4367,  -7711,  -1855, -18057,  32093,
	 16127,  -3733,   8123,  19359,  17615, -31385,  21939,   8271,
	   523, -13471, -15817,   2447,  -2159,  16883,  15881,  26665,
	-23267,  -6143,  26099,     27,  19251,  30739,  21875, -20841,
	 32317,  21647,  19657, -25181, -27897,  28909,  -2325, -31017,
	-22969, -23203,  -1663,  29513,   8655,  21663,   2863, -24329,
	-13791, -15013, -14617,   7631,   4831,   2523,  -4459,  25305,
	-22383,  -7563, -14069, -31939,   8905,   -847, -27459,  20313,
	 22031,  11285,  -4703,  -9833, -22163, -11861,  19439, -20883,
	 26227,  -7285,    683,  26541,  26697,  31443,   3867,  16703,
	 -9465,  24643,  -2405, -18255,  -7023,  32573,  18633, -32227,
	  3467,  14975,  10111,  12223, -22351, -25773, -12361,   1647,
	  3147,    485,  -6955,   4037,  31133, -25411,  22051, -22703,
	-30029,  19695, -28713,   1791, -17001,  20927, -11077,   1957,
	  9039,   -271,  23343, -14505,  12799, -10245,  27251,   -239,
	   -91,  -3013, -26681,  -7781,  18431,  -4267,    -79,  12761,
	  6975,  27513, -21193, -18153,    597,  31417,  10009,  -6565,
	 -8591,   7451,    549,  25965,   4075,  -3371, -23001,  -4991,
	 13375, -10377,  -7567,  14495, -20499,  24163, -22895,  21683,
	  -283, -24813,  28617, -12693,  11199, -17155,   7461,  24367,
	 17891, -14457,  14885,  -6479, -25123,   1567,  -7343,  18083,
	-11365, -30745,   5567, -23135,   8847, -22073,  13103, -19417,
	 10857,   2341,  11103, -28057,  -6085, -21043,  25001,  13631,
	-28451,  -4943,  11785,  -1515,  20611,  10399,  28867,  30333,
	  -619,   2571,  10697,  27865,  -1455,   9439, -12111, -20863,
	-32307,  -5871,   2757,  14533,   6453, -24553,  -5375, -20601,
	-16217,    719,  30733, -27139,    815,  27117, -22019,   4491,
	-11599,  15429, -28793,  14553,  21855,  13145, -14089,   2047,
	  9637,  31145, -32185, -21071,  -8393, -28397, -10773,  -7215,
	  7221,  -2885, -29955,   -955,  31683,    555,  29501, -14111,
	 22687,  -1611,  30281,  23331,   2543,  26717,   4597, -16841,
	 -4443, -16569,   3375,  11961, -14409, -12441,  -3919, -30041,
	 14117, -28147,  10121,  27997,  29267,  32061,  31731,   6005,
	-27757, -28163,  26915,  27145,   3035,  31459, -12927,  17555,
	    11,  15775,  22415, -10649, -21443,   4357,  -7701,  13919,
	-13849,  29299,  25945, -32099,  24467,  11327, -27641,  14287,
	 24733,  12479,   8425,  10185,  14143,  11289, -32147, -31395,
	-32569,    863,  10665, -19459, -25235,  32541, -13317,  31603,
	  7743, -16357,  19763,   1493,  29523,  17439, -20153,  12553,
	-17843,  19907, -12325,  -8677,  26931, -14729, -27309, -20985,
	-30313,  -5119,    -95, -10901,  -5803,   3771,  -3615,  26323,
	-10165, -25561,   4027,  -8821, -11493, -23433,  -1259, -26409,
	 -8217, -30259,  -1387, -19097, -25555,  18051, -30381,  23417,
	 21471, -30457,  30969,  -7775,  22281, -11225,  30509, -30729,
	 13439,  18735,  -4155,  16133, -18089, -15231,  -3563, -25875,
	 26137, -10297, -25997,  18761, -20409,  27177,   3787,  29465,
	 -2491, -13381, -23599,  29129,  -6427,  -1547,  28643,  26745,
	 17385,  22675,  31555,   7867, -22361,  23987,  30761,  12297,
	 30905,  28649,  31667, -23107,  28099,   8665, -30557,  25277,
	-25587, -29273, -32089, -10169,  -2591, -32169,  -7157,  31997,
	 -5077,  27875,  13221,  23033, -16467,  23231,  -4479,  -6245,
	-26755,  12869, -28841,   9103,  18953, -17737, -15897,  15209,
	 23103,  23779, -13071,   1205,  18211,     31,  31949,   1707,
	-29657, -18015, -30649,  22265,  18905, -23187, -18457,  30365,
	-15829, -13327,  29651,  10127, -28211,  22307,  24585, -11759,
	-25993,  26649, -31859,   1307,  25833,  -1125,  23327,  27369,
	 10687,  12089, -19843,  11269,   9333, -25219,  17139, -12463,
	-11359, -22857, -15993,   4309,  30893,  12873,   9253, -12457,
	-20393, -14697,   4639, -19279, -25395,  -7471, -21849,  -5259,
	  3775,  13689,   4763,  31059,  11145, -30493,  26461,  12079,
	 25609,  -4715,  11381, -11129,  25241, -24653,  -8245,  -4159,
	 10847, -13433, -11311, -17407,  15359, -25401,  32701,   -287,
	  5813,  12005,  26029,  28563, -21347,  15257,  -2581, -16393,
};
/* END GENERATED M55 STAGE3 TWIDDLES */
