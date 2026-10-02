/*
 * Copyright 2025 NXP
 * SPDX-License-Identifier: MIT
 */

#ifndef FNDSA_SIGN_INNER_H__
#define FNDSA_SIGN_INNER_H__

/* ==================================================================== */
/*
 * This file includes declarations used by the signature generation code
 * only.
 */

#include "inner.h"
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <time.h>

/* ==================================================================== */
/*
 * Floating-point values.
 *
 * The values need to follow the exact rounding rules of IEEE-754
 * ('binary64' type, with roundTiesToEven policy). Infinites, NaNs and
 * denormals are not used in the algorithm and need not be supported
 * (or can be assumed not the happen).
 *
 * Format of a 64-bit value is the following:
 *
 *  s eee...e mmm...e
 *
 * with:
 *    s = sign bit (0 = positive, 1 = negative)
 *    e = exponent (11 bits)
 *    m = mantissa (52 bits)
 *
 * If e = 0, then m should be equal to zero, and this denotes a zero (there
 * are two zeros, +0.0 and -0.0, depending on the sign bit). Values with
 * e = 0 and m != 0 would be denormals, which are not supported here.
 *
 * If 1 <= e <= 2046, then the value is:
 *   (-1)^s * (2^52 + m) * 2^(e-1075)
 *
 * Values with e = 2047 denote an infinite (m = 0) or a NaN (m != 0); neither
 * is supported here.
 */
#if TEST_PRECISION
#include "gc.h"
static void *xmalloc(size_t len) {
    if (len == 0) {
        return NULL;
    }
    void *buf = GC_MALLOC(len);
    if (buf == NULL) {
        fprintf(stderr, "memory allocation error (size=%zu)\n", len);
        exit(EXIT_FAILURE);
    }
    return buf;
}

static void xfree(void *buf) {
    if (buf != NULL) {
        GC_FREE(buf);
    }
}
void compare_gm();

#include <mpfr.h>
#include "triple_float.h"
typedef struct {
    mpfr_t mpfr;
    mpfr_t mpfr_high;
    double d;
    uint64_t emu_d;
    tw_fpr fpr_tw;
} fpr;

#define PRECISION 53
#define PRECISION_HIGH 200

typedef union dunion {
    uint64_t i;
    double d;

} dunion_t;


static inline fpr create_fpr() {
    fpr value;
    mpfr_init2(value.mpfr, PRECISION);
    mpfr_init2(value.mpfr_high, PRECISION_HIGH);

    return value;
}
#define FPR2(i, e)                                                             \
    ((i) < 0 ? (((uint64_t)1 << 63) ^ FPR2_(-(i), e)) : FPR2_(i, e))
#define FPR2_(i, e)                                                            \
    (((uint64_t)(int64_t)(i) & (((uint64_t)1 << 63) | 0x000FFFFFFFFFFFFF)) +   \
     ((uint64_t)(((uint32_t)(e) + 1075) & 0x7FF) << 52))

#define FPR_TW(x0, x1, x2) (tw_fpr){{(x0), (x1), (x2)}}

static inline fpr FPR(int64_t i, int64_t e) {
    fpr r = create_fpr();
    mpfr_set_si_2exp(r.mpfr, i, e, MPFR_RNDN);
    mpfr_set_si_2exp(r.mpfr_high, i, e, MPFR_RNDN);
    dunion_t d;
    d.i = FPR2(i, e);
    r.emu_d = d.i;
    r.d = d.d;
    r.fpr_tw = create_from_u64(d.i);
    return r;
}

static inline int rev10(int k) {

    int reversed = (k & 0b1) << 9;
    reversed |= (k & 0b10) << 7;
    reversed |= (k & 0b100) << 5;
    reversed |= (k & 0b1000) << 3;
    reversed |= (k & 0b10000) << 1;
    reversed |= (k & 0b100000) >> 1;
    reversed |= (k & 0b1000000) >> 3;
    reversed |= (k & 0b10000000) >> 5;
    reversed |= (k & 0b100000000) >> 7;
    reversed |= (k & 0b1000000000) >> 9;
    return reversed;
}

extern const uint64_t GM2[];
extern const tw_fpr GM_TW[];

/* If rev() is the bit-reversal function over 10 bits, then,
   for k = 1 to 1023:
     GM[2*k + 0] = cos(k*pi/1024)
     GM[2*k + 1] = sin(k*pi/1024)
   All values have been computed with Sage with enough precision to get
   properly rounding values. GM[0] and GM[1] are not used. */
static inline fpr FPR_GM(int32_t i) {
    // sometimes mpfr_sinpi crashes without?
    mpfr_free_cache();

    fpr r = create_fpr();
    mpfr_t input;

    mpfr_inits2(PRECISION_HIGH, input, NULL);
    // i = 2k + 0
    if (i % 2 == 0) {
        int k = rev10(i / 2);

        mpfr_set_si(input, k, MPFR_RNDN);
        mpfr_div_si(input, input, 1024, MPFR_RNDN);
        mpfr_cospi(r.mpfr_high, input, MPFR_RNDN);
    }
    // i = 2k + 1
    else {
        int k = rev10((i - 1) / 2);

        mpfr_set_si(input, k, MPFR_RNDN);
        mpfr_div_si(input, input, 1024, MPFR_RNDN);
        mpfr_sinpi(r.mpfr_high, input, MPFR_RNDN);
    }
    mpfr_set(r.mpfr, r.mpfr_high, MPFR_RNDN);
    dunion_t d;
    d.i = GM2[i];
    r.emu_d = d.i;
    r.d = d.d;
    r.fpr_tw = GM_TW[i];

    return r;
}


#define FPR2_ZERO FPR2(0, -1075)
#define FPR2_NZERO (FPR2_ZERO ^ ((uint64_t)1 << 63))

static inline fpr FPR_NZERO_create() {
    fpr r = create_fpr();
    mpfr_set_zero(r.mpfr, -1);
    mpfr_set_zero(r.mpfr_high, -1);
    dunion_t d;
    d.i = FPR2_NZERO;
    r.emu_d = d.i;
    r.d = d.d;
    r.fpr_tw = (tw_fpr){{-0, -0, -0}};

    return r;
}

static inline fpr FPR_ZERO_create() {
    fpr r = create_fpr();
    mpfr_set_zero(r.mpfr, 1);
    mpfr_set_zero(r.mpfr_high, 1);
    dunion_t d;
    d.i = FPR2_ZERO;
    r.emu_d = d.i;
    r.d = d.d;
    r.fpr_tw = (tw_fpr){{0, 0, 0}};

    return r;
}


#define FPR_ZERO FPR_ZERO_create()

#define FPR2_ONE FPR2(4503599627370496, -52)

static inline fpr FPR_ONE_create(){
    fpr r = create_fpr();
    mpfr_set_si(r.mpfr, 1, MPFR_RNDN);
    mpfr_set_si(r.mpfr_high, 1, MPFR_RNDN);
    dunion_t d;
    d.i = FPR2_ONE;
    r.emu_d = d.i;
    r.d = d.d;
    r.fpr_tw = (tw_fpr){{1, 0, 0}};

    return r;
}

#define FPR_ONE FPR_ONE_create()

#define FPR_NZERO FPR_NZERO_create()

#else

#if FNDSA_TW
#include "triple_float.h"
typedef tw_fpr fpr;
#else
typedef uint64_t fpr;
#endif

#if FNDSA_TW

#define FPR(x0, x1, x2) (tw_fpr){{(x0), (x1), (x2)}}

#define FPR_ZERO (tw_fpr){{0, 0, 0}}
#define FPR_NZERO (tw_fpr){{-0, -0, -0}}
#define FPR_ONE (tw_fpr){{1065353216, 0, 0}}




#else

/* This macro returns a constant initializer for a FPR value. The
   two parameters are an integer i and exponent e, such that:
      i and e are constant expressions of types castable to int64_t
      either i = 0, or 2^52 <= abs(i) <= 2^53 - 1
      if i = 0, then e = -1075; otherwise, value is i*2^e
   IMPORTANT: this macro is ONLY for constants; it MUST NOT be used
   for non-constant expressions, especially with secret values. */
#define FPR(i, e) ((i) < 0 ? (((uint64_t)1 << 63) ^ FPR_(-(i), e)) : FPR_(i, e))
#define FPR_(i, e)                                                             \
    (((uint64_t)(int64_t)(i) & (((uint64_t)1 << 63) | 0x000FFFFFFFFFFFFF)) +   \
     ((uint64_t)(((uint32_t)(e) + 1075) & 0x7FF) << 52))

#define FPR_ZERO FPR(0, -1075)
#define FPR_NZERO (FPR_ZERO ^ ((uint64_t)1 << 63))
#define FPR_ONE FPR(4503599627370496, -52)
#endif

#endif
/* Right-shift a 64-bit unsigned value by a possibly secret shift count.
   The shift count is between 0 and 63 (inclusive). On some 32-bit
   architectures (especially old 32-bit PowerPC), support of 64-bit
   shifts involves conditional jumps, i.e. leaking through timing
   measurements whether the shift was 32-bit or 64-bit, which is why
   this function is defined.

   On ARM Cortex-M4, compilers apply a branchless sequence of 8 instructions
   which leverages the fact that the shift opcodes actually use an 8-bit
   count (and not 5-bit). */
static inline uint64_t fpr_ursh(uint64_t x, int n) {
#if FNDSA_64 || FNDSA_ASM_CORTEXM4
    return x >> n;
#else
    x ^= (x ^ (x >> 32)) & -(uint64_t)(n >> 5);
    return x >> (n & 31);
#endif
}

/* Same as fpr_ursh, but for a signed operand. */
static inline int64_t fpr_irsh(int64_t x, int n) {
#if FNDSA_64 || FNDSA_ASM_CORTEXM4
    return x >> n;
#else
    x ^= (x ^ (x >> 32)) & -(int64_t)(n >> 5);
    return x >> (n & 31);
#endif
}

/* Same as fpr_ursh, but for a left shift. */
static inline uint64_t fpr_ulsh(uint64_t x, int n) {
#if FNDSA_64 || FNDSA_ASM_CORTEXM4
    return x << n;
#else
    x ^= (x ^ (x << 32)) & -(uint64_t)(n >> 5);
    return x << (n & 31);
#endif
}

/* Given integer i and scale sc, return i*2^sc. Source integer MUST
   be in the [-(2^63-1),+(2^63-1)] range (i.e. value -2^63 is forbidden). */
#define fpr_scaled fndsa_fpr_scaled
fpr fpr_scaled(int64_t i, int sc);


#if TEST_PRECISION

#define fpr_of(i) fpr_scaled(i, 0)

static inline int64_t fpr_rint(fpr x) {
    int64_t xi = mpfr_get_si(x.mpfr, MPFR_RNDN);
    return xi;
}

static inline int64_t fpr2_floor(uint64_t x) {
    /* We extract the mantissa as in fpr_rint(), but then we apply the
       sign bit to it; truncation from the integer shift will then
       yield the proper result. */
    uint64_t m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
    uint64_t s = (uint64_t)(*(int64_t *)&x >> 63);
    m = (m ^ s) - s;

    /* Get the shift count. */
    int32_t e = 1085 - ((int32_t)(x >> 52) & 0x7FF);

    /* If the shift count is 64 or more, then the value should be 0
       or -1, depending on the sign bit. Note that if the source is
       "minus zero" then we round to -1. We only need to saturate the
       shift count at 63. */
    uint32_t ue = (uint32_t)e;
    ue = (ue | ((63 - ue) >> 16)) & 63;
    return fpr_irsh(*(int64_t *)&m, ue);
}

static inline int64_t fpr_floor(fpr x) {
    // int64_t r = mpfr_get_si(x.mpfr, MPFR_RNDD);
    int64_t r = tw_floor_fast(x.fpr_tw);

    // int64_t r = fpr2_floor(x.emu_d);
    // int64_t r = floor(x.d);
    return r;
}

static inline int64_t fpr2_trunc(uint64_t x) {
    /* This is like fpr_floor(), except that we apply the sign after
       the shift instead of before. */
    uint64_t m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
    int32_t e = 1085 - ((int32_t)(x >> 52) & 0x7FF);
    uint32_t ue = (uint32_t)e;
    ue = (ue | ((63 - ue) >> 16)) & 63;
    m = fpr_ursh(m, ue);

    uint64_t s = (uint64_t)(*(int64_t *)&x >> 63);
    m = (m ^ s) - s;
    return *(int64_t *)&m;
}
static inline int64_t fpr_trunc(fpr x) {

    // int64_t r = mpfr_get_si(x.mpfr, MPFR_RNDZ);
    int64_t r = tw_trunc_fast(x.fpr_tw);
    // int64_t r = fpr2_trunc(x.emu_d);

    return r;
}

uint64_t fpr2_add(uint64_t x, uint64_t y);

static inline uint64_t fpr2_sub(uint64_t x, uint64_t y) {
    return fpr2_add(x, y ^ ((uint64_t)1 << 63));
}
static inline fpr fpr_sub(fpr x, fpr y) {
    fpr z = create_fpr();
    mpfr_sub(z.mpfr, x.mpfr, y.mpfr, MPFR_RNDN);
    mpfr_sub(z.mpfr_high, x.mpfr_high, y.mpfr_high, MPFR_RNDN);
    z.d = x.d - y.d;
    z.emu_d = fpr2_sub(x.emu_d, y.emu_d);
    z.fpr_tw = tw_sub(x.fpr_tw, y.fpr_tw);

    return z;
}
static inline uint64_t fpr2_neg(uint64_t x) { return x ^ ((uint64_t)1 << 63); }

static inline fpr fpr_neg(fpr x) {
    fpr z = create_fpr();
    mpfr_neg(z.mpfr, x.mpfr, MPFR_RNDN);
    mpfr_neg(z.mpfr_high, x.mpfr_high, MPFR_RNDN);
    z.d = -x.d;
    z.emu_d = fpr2_neg(x.emu_d);
    z.fpr_tw = (tw_fpr){- x.fpr_tw.x[0], -x.fpr_tw.x[1], -x.fpr_tw.x[2]};

    return z;
}
static inline uint64_t fpr2_half(uint64_t x) {
    /* We just have to subtract 1 from the exponent field, but we
       must take care to preserve zeros. If the input is a zero,
       then the subtraction on the exponent makes a borrow that
       spills into the sign bit, which allows us to detect that
       occurrence. */
    uint64_t y = x - ((uint64_t)1 << 52);
    y += ((x ^ y) >> 11) & ((uint64_t)1 << 52);
    return y;
}

/* Floating-point doubling. */
static inline fpr fpr_half(fpr x) {
    fpr z = create_fpr();
    mpfr_div_si(z.mpfr, x.mpfr, 2, MPFR_RNDN);
    mpfr_div_si(z.mpfr_high, x.mpfr_high, 2, MPFR_RNDN);
    z.d = x.d / 2;
    z.emu_d = fpr2_half(x.emu_d);
    z.fpr_tw = tw_prod_fast((tw_fpr){{0.5f, 0, 0}}, x.fpr_tw);

    return z;
}

static inline uint64_t fpr2_double(uint64_t x) {
    /* We add 1 to the exponent field, except if that field was zero,
       because the double of zero is still zero. */
    uint64_t d = ((x & 0x7FF0000000000000) + 0x7FF0000000000000) >> 11;
    return x + (d & ((uint64_t)1 << 52));
}
static inline fpr fpr_double(fpr x) {
    fpr z = create_fpr();
    mpfr_mul_si(z.mpfr, x.mpfr, 2, MPFR_RNDN);
    mpfr_mul_si(z.mpfr_high, x.mpfr_high, 2, MPFR_RNDN);
    z.d = 2 * x.d;
    z.emu_d = fpr2_double(x.emu_d);
    z.fpr_tw = tw_prod_fast((tw_fpr){{2.0f, 0, 0}}, x.fpr_tw);

    return z;
}

static const union {
    uint64_t f;
    double v;
} DIV_1_2i[] = {{FPR2(4503599627370496, -52)}, {FPR2(4503599627370496, -53)},
                {FPR2(4503599627370496, -54)}, {FPR2(4503599627370496, -55)},
                {FPR2(4503599627370496, -56)}, {FPR2(4503599627370496, -57)},
                {FPR2(4503599627370496, -58)}, {FPR2(4503599627370496, -59)},
                {FPR2(4503599627370496, -60)}, {FPR2(4503599627370496, -61)}};

static const union {
    uint64_t f;
    double v;
} CONST2i[] = {
    {1 / FPR2(4503599627370496, -52)}, {1 / FPR2(4503599627370496, -53)},
    {1 / FPR2(4503599627370496, -54)}, {1 / FPR2(4503599627370496, -55)},
    {1 / FPR2(4503599627370496, -56)}, {1 / FPR2(4503599627370496, -57)},
    {1 / FPR2(4503599627370496, -58)}, {1 / FPR2(4503599627370496, -59)},
    {1 / FPR2(4503599627370496, -60)}, {1 / FPR2(4503599627370496, -61)}};

static inline uint64_t fpr2_div2e(uint64_t x, unsigned e) {
    uint64_t ee = (uint64_t)e << 52;
    uint64_t y = x - ee;
    uint64_t ov = x ^ y;
    return y + (ee & (uint64_t)(*(int64_t *)&ov >> 11));
}

static inline tw_fpr twfpr_div2e(tw_fpr x, unsigned e){
    uint32_t ee = e + 127;
    funion_t ef;
    ef.i = ee << 23;
    return tw_div_fast(x, (tw_fpr){ef.x, 0, 0});
}
/* Multiplication by 2^e. */
static inline fpr fpr_div2e(fpr x, unsigned e) {
    fpr z = create_fpr();
    mpfr_div_2si(z.mpfr, x.mpfr, e, MPFR_RNDN);
    mpfr_div_2si(z.mpfr_high, x.mpfr_high, e, MPFR_RNDN);
    z.d = x.d * DIV_1_2i[e].v;
    z.emu_d = fpr2_div2e(x.emu_d, e);
    z.fpr_tw = twfpr_div2e(x.fpr_tw, e);
    return z;
}
static inline uint64_t fpr2_mul2e(uint64_t x, unsigned e) {
    /* We add e to the exponent field, except if that field was zero,
       because the double of zero is still zero. */
    uint64_t d = (x & 0x7FF0000000000000) - ((uint64_t)1 << 52);
    d = (uint64_t)(*(int64_t *)&d >> 12);
    return x + (((uint64_t)e << 52) & ~d);
}
static inline tw_fpr twfpr_mul2e(tw_fpr x, unsigned e){
    uint32_t ee = e + 127;
    funion_t ef;
    ef.i = ee << 23;
    return tw_prod_fast(x, (tw_fpr){ef.x, 0, 0});
}
static inline fpr fpr_mul2e(fpr x, unsigned e) {

    fpr z = create_fpr();
    mpfr_mul_2si(z.mpfr, x.mpfr, e, MPFR_RNDN);
    mpfr_mul_2si(z.mpfr_high, x.mpfr_high, e, MPFR_RNDN);
    z.d = x.d * CONST2i[e].v;
    z.emu_d = fpr2_mul2e(x.emu_d, e);
    z.fpr_tw = twfpr_mul2e(x.fpr_tw, e);

    return z;
}
#else
// called from the following places:
// i from sampler_next()
//      z + s, where z \in [-18, 19], and s = fpr_floor(mu)
// in sampler_next:
//      i from fpr_floor(mu)
//          
//      i from 1 + gaussian0() or - gaussian0()         FINE
//          gaussian0() returns z0 \in {0,...,18}
//      i from gaussian0() * gaussian0()                FINE
//          same as above
//      berexp: 
//          i from fpr_trunc(fpr_mul(x, INV_LOG2))      FINE
//              s is only >= 64, with incredibly low 
//              probability, see comments there.
//  i from hm[i] (uint16_t)                             FINE
//  i from f[i] (int8_t)                                FINE
#if FNDSA_TW
#define fpr_of(i)   tw_from_int(i)
#else
#define fpr_of(i)   fpr_scaled(i, 0)
#endif

#if FNDSA_TW

#include <math.h>
// Only gets used where the result is seen as a 16 bit integer, so this method is fine
static inline int64_t fpr_rint(tw_fpr x)
{
    return tw_rint_fast(x);
}

// for test_fndsa, as there the outputs are bigger then 16 bit integers
static inline int64_t fpr_rint_exact(tw_fpr x)
{
typedef union d_union {
    double x;
    uint64_t i;
} dunion_t;
    uint64_t xu = convert_to_u64_round_new_limps_no_branching(x);
    dunion_t xud;
    xud.i = xu;

    return rint(xud.x);
}


/* Like fpr_rint(), but rounding toward -infinity. */
// this is fine if output stays below 24 bits, which is the case if mu is always < 2^24
static inline int64_t fpr_floor(fpr x)
{
    return tw_floor_fast(x);
}


/* Like fpr_rint(), but rounding toward zero. */
// this is fine if output stays below 24, meaning input is supposed to be in the range [2^-24, 2^24].
// 
// This is the case for the call in ber_exp
// NOT the case for first call in expm_p63: mul_2e(x, 63), as x can be as high as log(2)
// NOT? the case for second call, depends on value css, but code is written to expect a 64 bit integer back which is also really used as a 64 bit integer
// correct algorithm works if all inputs are above 0
//  berexp: both calls have, x is > 0 css is >0
//fast algorithm can be called for ber_exp,
//slow algorithm can be called for 2 call sin expm_p63, as values fall in range [0, 2^64]
static inline int64_t
fpr_trunc(fpr x)
{
    return tw_trunc_full(x);
}
static inline int64_t
fpr_trunc_fast(fpr x)
{
    return tw_trunc_fast(x);
}
#else
/* Round a floating-point value to the nearest integer (roundTiesToEven
   policy). It is assumed that the mathematical result is in
   [-(2^63-1),+(2^63-1)]. */
static inline int64_t fpr_rint(fpr x) {
    /* Extract the mantissa as a 63-bit integer. */
    uint64_t m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
    int32_t e = 1085 - ((int32_t)(x >> 52) & 0x7FF);

    /* If a shift of more than 63 bits is needed, then simply set m
       to zero. This also covers the case of an input equal to zero. */
    m &= (uint64_t)((int64_t)(e - 64) >> 16);
    e &= 63;

    /* m should be right-shifted by e bits.
       To apply proper rounding, we need to get the dropped bits and
       apply the usual "sticky bit" rule. */
    uint64_t z = fpr_ulsh(m, 63 - e);
    uint64_t y = ((z & 0x3FFFFFFFFFFFFFFF) + 0x3FFFFFFFFFFFFFFF) >> 1;
    uint64_t cc = (0xC8 >> (unsigned)((z | y) >> 61)) & 1;

    /* Do the shift + rounding. */
    m = fpr_ursh(m, e) + cc;

    /* Apply the sign to get the final output. */
    uint64_t s = (uint64_t)(*(int64_t *)&x >> 63);
    m = (m ^ s) - s;
    return *(int64_t *)&m;
}

/* Like fpr_rint(), but rounding toward -infinity. */
static inline int64_t fpr_floor(fpr x) {
    /* We extract the mantissa as in fpr_rint(), but then we apply the
       sign bit to it; truncation from the integer shift will then
       yield the proper result. */
    uint64_t m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
    uint64_t s = (uint64_t)(*(int64_t *)&x >> 63);
    m = (m ^ s) - s;

    /* Get the shift count. */
    int32_t e = 1085 - ((int32_t)(x >> 52) & 0x7FF);

    /* If the shift count is 64 or more, then the value should be 0
       or -1, depending on the sign bit. Note that if the source is
       "minus zero" then we round to -1. We only need to saturate the
       shift count at 63. */
    uint32_t ue = (uint32_t)e;
    ue = (ue | ((63 - ue) >> 16)) & 63;
    return fpr_irsh(*(int64_t *)&m, ue);
}


/* Like fpr_rint(), but rounding toward zero. */
static inline int64_t fpr_trunc(fpr x) {
    /* This is like fpr_floor(), except that we apply the sign after
       the shift instead of before. */
    uint64_t m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
    int32_t e = 1085 - ((int32_t)(x >> 52) & 0x7FF);
    uint32_t ue = (uint32_t)e;
    ue = (ue | ((63 - ue) >> 16)) & 63;
    m = fpr_ursh(m, ue);

    uint64_t s = (uint64_t)(*(int64_t *)&x >> 63);
    m = (m ^ s) - s;
    return *(int64_t *)&m;
}

#endif
#endif

/* Floating-point addition. */
#define fpr_add fndsa_fpr_add
fpr fpr_add(fpr x, fpr y);

#if !TEST_PRECISION
/* Floating-point subtraction. */
static inline fpr
fpr_sub(fpr x, fpr y)
{
#if FNDSA_TW
	return tw_sub(x, y);
#else
	return fpr_add(x, y ^ ((uint64_t)1 << 63));
#endif
}
#endif

/* Combined addition/subtraction:
    a <- x + y
    b <- x - y  */
#if FNDSA_ASM_CORTEXM4
/* On the ARM Cortex-M4, we have a dedicated function, but since it does
   not follow the AAPCS requirements (it returns two 64-bit values), it
   uses a custom convention which requires inline assembly for invocation.
   In particular, about all registers are clobbered. */
#define FPR_ADD_SUB(a, b, x, y)                                                \
    do {                                                                       \
        fpr t_add_sub_x = (x);                                                 \
        fpr t_add_sub_y = (y);                                                 \
        register uint32_t t_add_sub_x0 __asm__("r0") = (uint32_t)t_add_sub_x;  \
        register uint32_t t_add_sub_x1 __asm__("r1") =                         \
            (uint32_t)(t_add_sub_x >> 32);                                     \
        register uint32_t t_add_sub_y0 __asm__("r2") = (uint32_t)t_add_sub_y;  \
        register uint32_t t_add_sub_y1 __asm__("r3") =                         \
            (uint32_t)(t_add_sub_y >> 32);                                     \
        __asm__("bl	fndsa_fpr_add_sub"                                         \
                : "+r"(t_add_sub_x0), "+r"(t_add_sub_x1), "+r"(t_add_sub_y0),  \
                  "+r"(t_add_sub_y1)                                           \
                :                                                              \
                : "r4", "r5", "r6", "r7", "r8", "r10", "r11", "r12", "r14",    \
                  "s15", "cc");                                                \
        (a) = (uint64_t)t_add_sub_x0 | ((uint64_t)t_add_sub_x1 << 32);         \
        (b) = (uint64_t)t_add_sub_y0 | ((uint64_t)t_add_sub_y1 << 32);         \
    } while (0)
#else
#define FPR_ADD_SUB(a, b, x, y)                                                \
    do {                                                                       \
        fpr t_add_sub_x = (x);                                                 \
        fpr t_add_sub_y = (y);                                                 \
        (a) = fpr_add(t_add_sub_x, t_add_sub_y);                               \
        (b) = fpr_sub(t_add_sub_x, t_add_sub_y);                               \
    } while (0)
#endif

#if !TEST_PRECISION

static inline fpr
fpr_neg(fpr x)
{
#if FNDSA_TW
    return (tw_fpr){-x.x[0], -x.x[1], -x.x[2]};
#else
	return x ^ ((uint64_t)1 << 63);
#endif
}

/* Floating-point halving. */
static inline fpr
fpr_half(fpr x)
{
    
#if FNDSA_TW
    fpr y = tw_prod_fast((tw_fpr){0.5f, 0.0f, 0.0f}, x);
#else
	/* We just have to subtract 1 from the exponent field, but we
	   must take care to preserve zeros. If the input is a zero,
	   then the subtraction on the exponent makes a borrow that
	   spills into the sign bit, which allows us to detect that
	   occurrence. */
	uint64_t y = x - ((uint64_t)1 << 52);
	y += ((x ^ y) >> 11) & ((uint64_t)1 << 52);
#endif
	return y;
}

/* Floating-point doubling. */
static inline fpr
fpr_double(fpr x)
{
#if FNDSA_TW
    return tw_prod_fast((tw_fpr){2.0f, 0.0f, 0.0f}, x);
#else
	/* We add 1 to the exponent field, except if that field was zero,
	   because the double of zero is still zero. */
	uint64_t d = ((x & 0x7FF0000000000000) + 0x7FF0000000000000) >> 11;
	return x + (d & ((uint64_t)1 << 52));
#endif
}

#endif
/* Floating-point multiplication. */
#define fpr_mul fndsa_fpr_mul
fpr fpr_mul(fpr x, fpr y);
uint64_t fpr2_mul(uint64_t x, uint64_t y);

/* Floating-point squaring. */
static inline fpr fpr_sqr(fpr x) { return fpr_mul(x, x); }

/* Floating-point division. */
#define fpr_div fndsa_fpr_div
fpr fpr_div(fpr x, fpr y);
uint64_t fpr2_div(uint64_t x, uint64_t y);


/* Floating-point inversion. */
static inline fpr
fpr_inv(fpr x)
{
#if FNDSA_TW && !TEST_PRECISION
    return tw_reci_fast(x);
#else
	return fpr_div(FPR_ONE, x);
#endif
}

/* Floating-point square root. */
#define fpr_sqrt fndsa_fpr_sqrt
fpr fpr_sqrt(fpr x);
uint64_t fpr2_sqrt(uint64_t x);

#if !TEST_PRECISION
/* Division by 2^e. */
static inline fpr
fpr_div2e(fpr x, unsigned e)
{
#if FNDSA_TW
    uint32_t ee = e + 127;
    funion_t ef;
    ef.i = ee << 23;
    return fpr_div(x, (tw_fpr){ef.x, 0, 0});
#else
	uint64_t ee = (uint64_t)e << 52;
	uint64_t y = x - ee;
	uint64_t ov = x ^ y;
	return y + (ee & (uint64_t)(*(int64_t *)&ov >> 11));
#endif
}

/* Multiplication by 2^e. */
static inline fpr
fpr_mul2e(fpr x, unsigned e)
{
#if FNDSA_TW
    uint32_t ee = e + 127;
    funion_t ef;
    // uint32_t mask = 0xFF000000;
    // mask = ~mask;
    // ef.i = 0;
    ef.i = ee << 23;
    return fpr_mul(x, (tw_fpr){ef.x, 0, 0});

#else
	/* We add e to the exponent field, except if that field was zero,
	   because the double of zero is still zero. */
	uint64_t d = (x & 0x7FF0000000000000) - ((uint64_t)1 << 52);
	d = (uint64_t)(*(int64_t *)&d >> 12);
	return x + (((uint64_t)e << 52) & ~d);
#endif
}
#endif

/* Complex multiplication. Note that we use here the version with four
   multiplications:
     d <- (a_r*b_r - a_i*b_i) + i*(a_r*b_i + a_i*b_r)
   It is faster than trying to use three multiplications, because additions
   and subtractions have about the same cost as multiplication in practice. */
#define FPC_MUL(d_re, d_im, a_re, a_im, b_re, b_im)                            \
    do {                                                                       \
        fpr fpct_a_re = (a_re), fpct_a_im = (a_im);                            \
        fpr fpct_b_re = (b_re), fpct_b_im = (b_im);                            \
        fpr fpct_d_re = fpr_sub(fpr_mul(fpct_a_re, fpct_b_re),                 \
                                fpr_mul(fpct_a_im, fpct_b_im));                \
        fpr fpct_d_im = fpr_add(fpr_mul(fpct_a_re, fpct_b_im),                 \
                                fpr_mul(fpct_a_im, fpct_b_re));                \
        (d_re) = fpct_d_re;                                                    \
        (d_im) = fpct_d_im;                                                    \
    } while (0)

/* ==================================================================== */
/*
 * Pseudo-intrinsics for RISC-V.
 *
 * RISC-V hardware with the D extension implements 64-bit floating-point
 * natively and with the rounding rules that we need, but the only API
 * we have for it in C is with the native "double" which we do not want
 * to use because C compilers tend to take unwanted shortcuts such as
 * contracting expressions (in case a fused-multiply-add is available).
 * Instead, we define here our own pseudo-intrinsics which are really
 * inline assembly chunks, that the compiler will use without doing
 * such extra optimizations.
 */

#if FNDSA_RV64D
/* We wrap the type in a structure so that any attempt at applying
   arithmetic operators on f64 values triggers a compilation error.
   Since the wrapper is trivial and all these functions should be always
   inlined, this wrapper should have no extra runtime cost. */
typedef struct {
    double v;
} f64;

static inline f64 f64_from_raw(fpr r) {
    f64 d;
    __asm__("fmv.d.x  %0, %1" : "=f"(d.v) : "r"(r));
    return d;
}

static inline fpr f64_to_raw(f64 a) {
    fpr r;
    __asm__("fmv.x.d  %0, %1" : "=r"(r) : "f"(a.v));
    return r;
}

static inline f64 f64_add(f64 a, f64 b) {
    f64 d;
    __asm__("fadd.d  %0, %1, %2" : "=f"(d.v) : "f"(a.v), "f"(b.v));
    return d;
}

static inline f64 f64_sub(f64 a, f64 b) {
    f64 d;
    __asm__("fsub.d  %0, %1, %2" : "=f"(d.v) : "f"(a.v), "f"(b.v));
    return d;
}

static inline f64 f64_neg(f64 a) {
    f64 d;
    __asm__("fsgnjn.d  %0, %1, %1" : "=f"(d.v) : "f"(a.v));
    return d;
}

static inline f64 f64_mul(f64 a, f64 b) {
    f64 d;
    __asm__("fmul.d  %0, %1, %2" : "=f"(d.v) : "f"(a.v), "f"(b.v));
    return d;
}

static inline f64 f64_sqr(f64 a) { return f64_mul(a, a); }

#if FNDSA_DIV_EMU
static inline f64 f64_div(f64 a, f64 b) {
    return f64_from_raw(fpr_div(f64_to_raw(a), f64_to_raw(b)));
}
#else
static inline f64 f64_div(f64 a, f64 b) {
    f64 d;
    __asm__("fdiv.d  %0, %1, %2" : "=f"(d.v) : "f"(a.v), "f"(b.v));
    return d;
}
#endif

static inline f64 f64_inv(f64 a) { return f64_div((f64){1.0}, a); }

static inline f64 f64_half(f64 a) { return f64_mul((f64){0.5}, a); }

#if FNDSA_SQRT_EMU
static inline f64 f64_sqrt(f64 a) {
    return f64_from_raw(fpr_sqrt(f64_to_raw(a)));
}
#else
static inline f64 f64_sqrt(f64 a) {
    f64 d;
    __asm__("fsqrt.d  %0, %1" : "=f"(d.v) : "f"(a.v));
    return d;
}
#endif

static inline f64 f64_of(int64_t x) {
    f64 d;
    __asm__("fcvt.d.l  %0, %1" : "=f"(d.v) : "r"(x));
    return d;
}

static inline int64_t f64_rint(f64 a) {
    int64_t x;
    __asm__("fcvt.l.d  %0, %1, rne" : "=r"(x) : "f"(a.v));
    return x;
}

static inline int64_t f64_trunc(f64 a) {
    int64_t x;
    __asm__("fcvt.l.d  %0, %1, rtz" : "=r"(x) : "f"(a.v));
    return x;
}

static inline int64_t f64_floor(f64 a) {
    int64_t x;
    __asm__("fcvt.l.d  %0, %1, rdn" : "=r"(x) : "f"(a.v));
    return x;
}
#endif

/* ==================================================================== */
/*
 * Floating-point polynomials.
 *
 * Polynomials are modulo X^n+1 and have real coefficients. When converted
 * to FFT format, they have n/2 complex coefficients, with the real and
 * imaginary parts separated (real in f[i] and imaginary in f[i+n/2]).
 *
 * Unless specified explicitly, the functions below can work with
 * polynomials in both real and FFT representations (if using several
 * operands, then they must all be in the same representation).
 */

/* Convert polynomial f from real to FFT representation (in-place). */
#define fpoly_FFT fndsa_fpoly_FFT
void fpoly_FFT(unsigned logn, fpr *f);

/* Convert polynomial f from FFT to real representation (in-place). */
#define fpoly_iFFT fndsa_fpoly_iFFT
void fpoly_iFFT(unsigned logn, fpr *f);

/* Set polynomial d from small polynomial f with integer coefficients. */
#define fpoly_set_small fndsa_fpoly_set_small
void fpoly_set_small(unsigned logn, fpr *d, const int8_t *f);

/* Add polynomial b to polynomial a. */
#define fpoly_add fndsa_fpoly_add
void fpoly_add(unsigned logn, fpr *a, const fpr *b);

/* Subtract polynomial b from polynomial a. */
#define fpoly_sub fndsa_fpoly_sub
void fpoly_sub(unsigned logn, fpr *a, const fpr *b);

/* Negate polynomial a (in-place). */
#define fpoly_neg fndsa_fpoly_neg
void fpoly_neg(unsigned logn, fpr *a);

/* Multiply polynomial a with polynomial b (FFT representation only). */
#define fpoly_mul_fft fndsa_fpoly_mul_fft
void fpoly_mul_fft(unsigned logn, fpr *a, const fpr *b);

/* unused
   Multiply polynomial a with the adjoint of polynomial b (FFT
   representation only).
void fpoly_muladj_fft(unsigned logn, fpr *a, const fpr *b);
*/

/* unused
   Multiply polynomial a with its own adjoint (FFT representation only).
   Coefficients n/2 to n-1 are set to zero.
void fpoly_mulownadj_fft(unsigned logn, fpr *a);
*/

/* Multiply polynomial a with real constant x. */
#define fpoly_mulconst fndsa_fpoly_mulconst
void fpoly_mulconst(unsigned logn, fpr *a, fpr x);

/* Perform an LDL decomposition of a self-adjoint matrix G. The matrix
   is G = [[g00, g01], [adj(g01), g11]]; g00 and g11 are self-adjoint
   polynomials. The decomposition is G = L*D*adj(L), with:
      D = [[g00, 0], [0, d11]]
      L = [[1, 0], [l10, 1]]
   The output polynomials l10 and d11 are written over g01 and g11,
   respectively. g00, g11 and d11 are self-adjoint: only their first
   n/2 coefficients are accessed. g00 is unmodified. All polynomials
   are in FFT representation. */
#define fpoly_LDL_fft fndsa_fpoly_LDL_fft
void fpoly_LDL_fft(unsigned logn, const fpr *g00, fpr *g01, fpr *g11);

/* Split operation on a polynomial: for input polynomial f,
   half-size polynomials f0 and f1 (modulo X^(n/2)+1) are such that
   f = f0(x^2) + x*f1(x^2). All polynomials are in FFT representation. */
#define fpoly_split_fft fndsa_fpoly_split_fft
void fpoly_split_fft(unsigned logn, fpr *f0, fpr *f1, const fpr *f);

/* Specialized version of fpoly_split_fft() when the source polynomial
   f is self-adjoint. Only the first n/2 coefficients of f are accessed.
   On output, f0 is self-adjoint (all its n/2 coefficients are set), but
   in general f1 is not self-adjoint. */
#define fpoly_split_selfadj_fft fndsa_fpoly_split_selfadj_fft
void fpoly_split_selfadj_fft(unsigned logn, fpr *f0, fpr *f1, const fpr *f);

/* Merge operation on polynomials: for input half-size polynomials f0
   and f1 (modulo X^(n/2)+1), compute f = f0(x^2) + x*f1(x^2). All
   polynomials are in FFT representation. */
#define fpoly_merge_fft fndsa_fpoly_merge_fft
void fpoly_merge_fft(unsigned logn, fpr *f, const fpr *f0, const fpr *f1);

/* Given matrix B = [[b00, b01], [b10, b11]], compute the Gram matrix
   G = B*adj(B) = [[g00, g01], [g10, g11]], with:
      g00 = b00*adj(b00) + b01*adj(b01)
      g01 = b00*adj(b10) + b01*adj(b11)
      g10 = b10*adj(b00) + b11*adj(b01)
      g11 = b10*adj(b10) + b11*adj(b11)
   Only g00, g01 and g11 are returned, in b00, b01 and b10, respectively.
   b11 is unmodified. All polynomials are in FFT representation. */
#define fpoly_gram_fft fndsa_fpoly_gram_fft
void fpoly_gram_fft(unsigned logn, fpr *b00, fpr *b01, fpr *b10,
                    const fpr *b11);

/* Given matrix B = [[b00, b01], [b10, b11]], compute the target vector
   [t0,t1] = (1/q)*B*[0,hm], for polynomial hm with coefficients in [0,q-1].
   Only b01 and b11 are needed. hm is in normal representation; all other
   polynomials are in FFT representation. */
#define fpoly_apply_basis fndsa_fpoly_apply_basis
void fpoly_apply_basis(unsigned logn, fpr *t0, fpr *t1, const fpr *b01,
                       const fpr *b11, const uint16_t *hm);

/* ==================================================================== */
/*
 * Gaussian sampling.
 *
 * The sampler follows a Gaussian distribution whose centre and standard
 * deviations are not integral, dynamically obtained, and secret. The
 * sampler state includes a PRNG, from which random bytes are obtained
 * to sample value with a given bimodal Gaussian used as source for
 * rejection sampling of the target distribution.
 */

typedef struct {
#if FNDSA_SHAKE256X4
    shake256x4_context pc;
#else
    shake_context pc;
#endif
    unsigned logn;
} sampler_state;

/* Initialize the sampler for a given degree and seed. */
#define sampler_init fndsa_sampler_init
void sampler_init(sampler_state *ss, unsigned logn, const void *seed,
                  size_t seed_len);

/* Sample the next small integer. Parameters are:
      ss       sampler state
      mu       distribution centre
      isigma   inverse of the distribution standard deviation  */
#define sampler_next fndsa_sampler_next
int32_t sampler_next(sampler_state *ss, fpr mu, fpr isigma);

/* Apply Fast Fourier sampling:
      ss              sampler state (initialized)
      t0, t1          target vector
      g00, g01, g11   Gram matrix (G = [[g00, g01], [adj(g01), g11]])
      tmp             temporary (at least 4*n elements)
   Output is written over t0 and t1. g00, g01 and g11 are consumed. All
   polynomials are in FFT representation. */
#define ffsamp_fft fndsa_ffsamp_fft
void ffsamp_fft(sampler_state *ss, fpr *t0, fpr *t1, fpr *g00, fpr *g01,
                fpr *g11, fpr *tmp);

/* ==================================================================== */
/*
 * Internal signing function.
 */

/* Internal signing function. The complete signing key (f,g,F,G) is
   provided, as well as the hashed verifying key, data to sign (context,
   id, hash value), the random seed to work on (optional), the signature
   output buffer, and the temporary area. The signature buffer has been
   verified to be large enough. The temporary area is large enough and
   32-byte aligned.

   Returned value is the signature size (in bytes), or 0 on error. An
   error is possible if seed is NULL and the system RNG fails.

   tmp size: 74*n bytes  */
#define sign_core fndsa_sign_core
size_t sign_core(unsigned logn, const int8_t *f, const int8_t *g,
                 const int8_t *F, const int8_t *G, const uint8_t *hashed_vk,
                 const uint8_t *ctx, size_t ctx_len, const char *id,
                 const uint8_t *hv, size_t hv_len, const uint8_t *seed,
                 size_t seed_len, uint8_t *sig, void *tmp);

#endif


#if TEST_PRECISION

#ifndef SIGMA_H
#define SIGMA_H

/* Union type to get easier access to values with SIMD intrinsics. */
typedef union {
    fpr f;
    uint64_t f2;
#if FNDSA_NEON
    float64x1_t v;
#endif
#if FNDSA_RV64D
    f64 v;
#endif
} fpr_u;

static const fpr_u INV_SIGMA2[] = {
    {FPR2_ZERO},                   /* unused */
    {FPR2(7961475618707097, -60)}, /* 0.0069054793295940881528 */
    {FPR2(7851656902127320, -60)}, /* 0.0068102267767177965681 */
    {FPR2(7746260754658859, -60)}, /* 0.0067188101910722700565 */
    {FPR2(7595833604889141, -60)}, /* 0.0065883354370073655600 */
    {FPR2(7453842886538220, -60)}, /* 0.0064651781207602890978 */
    {FPR2(7319528409832599, -60)}, /* 0.0063486788828078985744 */
    {FPR2(7192222552237877, -60)}, /* 0.0062382586529084365056 */
    {FPR2(7071336252758509, -60)}, /* 0.0061334065020930252290 */
    {FPR2(6956347512113097, -60)}, /* 0.0060336696681577231923 */
    {FPR2(6846791885593314, -60)}  /* 0.0059386453095331150985 */
};
static const fpr_u SIGMA_MIN2[] = {
    {FPR2_ZERO},                   /* unused */
    {FPR2(5028307297130123, -52)}, /* 1.1165085072329102589 */
    {FPR2(5098636688852518, -52)}, /* 1.1321247692325272406 */
    {FPR2(5168009084304506, -52)}, /* 1.1475285353733668685 */
    {FPR2(5270355833453349, -52)}, /* 1.1702540788534828940 */
    {FPR2(5370752584786614, -52)}, /* 1.1925466358390344011 */
    {FPR2(5469306724145091, -52)}, /* 1.2144300507766139921 */
    {FPR2(5566116128735780, -52)}, /* 1.2359260567719808790 */
    {FPR2(5661270305715104, -52)}, /* 1.2570545284063214163 */
    {FPR2(5754851361258101, -52)}, /* 1.2778336969128335860 */
    {FPR2(5846934829975396, -52)}  /* 1.2982803343442918540 */
};


static const tw_fpr INV_SIGMA_TW[] = {
    FPR_TW(0, 0, 0), /* unused */
    FPR_TW(0x1.c48eb8p-8, -0x1.dbe966p-36,
         -0x1.db5714p-61), /* 1.1165085072329102589 */
    FPR_TW(0x1.be50a6p-8, -0x1.6e6a26p-33,
         0x1.ee9a34p-58), /* 1.1321247692325272406 */
    FPR_TW(0x1.b852eep-8, 0x1.3cec56p-37,
         -0x1.8c41ap-62), /* 1.1475285353733668685 */
    FPR_TW(0x1.afc5eep-8, -0x1.86a4bap-33,
         0x1.263b2ap-58), /* 1.1702540788534828940 */
    FPR_TW(0x1.a7b3bp-8, 0x1.2ed67ep-33,
         -0x1.04fd66p-58), /* 1.1925466358390344011 */
    FPR_TW(0x1.a01128p-8, 0x1.654e4cp-35,
         -0x1.403b94p-60), /* 1.2144300507766139921 */
    FPR_TW(0x1.98d49cp-8, 0x1.cbe4e6p-33,
         0x1.3f51dep-58), /* 1.2359260567719808790 */
    FPR_TW(0x1.91f57cp-8, 0x1.5bb67cp-34,
         -0x1.8222cp-59), /* 1.2570545284063214163 */
    FPR_TW(0x1.8b6c2ep-8, -0x1.9b3836p-36,
         -0x1.59e4bcp-61), /* 1.2778336969128335860 */
    FPR_TW(0x1.8531fp-8, -0x1.39dca4p-33,
         0x1.8b7a8p-60) /* 1.2982803343442918540 */
};

static const tw_fpr SIGMA_MIN_TW[] = {
    FPR_TW(0, 0, 0), /* unused */
    FPR_TW(0x1.1dd38p+0, 0x1.9115a2p-26,
         0x1.b0a22cp-51), /* 0.0069054793295940881528 */
    FPR_TW(0x1.21d2eep+0, -0x1.a93cecp-27,
         -0x1.8b6a6p-52), /* 0.0068102267767177965681 */
    FPR_TW(0x1.25c46ep+0, 0x1.aa7c7ap-28,
         0x1.117234p-56), /* 0.0067188101910722700565 */
    FPR_TW(0x1.2b95c6p+0, -0x1.16a09cp-25,
         0x1.26aa36p-50), /* 0.0065883354370073655600 */
    FPR_TW(0x1.314abcp+0, 0x1.ff88aep-26,
         -0x1.0a55p-51), /* 0.0064651781207602890978 */
    FPR_TW(0x1.36e4e4p+0, -0x1.714508p-25,
         0x1.a7d7ecp-51), /* 0.0063486788828078985744 */
    FPR_TW(0x1.3c65a6p+0, 0x1.a87088p-26,
         0x1.c9198ep-51), /* 0.0062382586529084365056 */
    FPR_TW(0x1.41ce54p+0, -0x1.4e698cp-25,
         -0x1.29a0acp-54), /* 0.0061334065020930252290 */
    FPR_TW(0x1.47201cp+0, -0x1.c10b16p-29,
         -0x1.592e3ep-54), /* 0.0060336696681577231923 */
    FPR_TW(0x1.4c5c1ap+0, -0x1.9bce28p-26,
         0x1.e07efep-51) /* 0.0059386453095331150985 */
};
static fpr_u INV_SIGMA[11];
static fpr_u SIGMA_MIN[11];

static fpr compute_sigma_min(int logn) {
    mpfr_free_cache();
    size_t n = (size_t)1 << logn;
    mpfr_t eps, eps2, eps3, smoothz2n, smoothz2n2, smoothz2n3, upper_div,
        upper_div2, upper_div3, upper_div4, upper_div5, upper_div6, pi;
    mpfr_inits2(1000, eps, eps2, eps3, smoothz2n, smoothz2n2, smoothz2n3,
                upper_div, upper_div2, upper_div3, upper_div4, upper_div5,
                upper_div6, pi, NULL);

    size_t bitsec = 2 > n / 4 ? 2 : n / 4;
    // eps = n / 4
    mpfr_set_si(eps, bitsec, MPFR_RNDN);
    double x = mpfr_get_d(eps, MPFR_RNDN);
    //  eps = n/4 * 2^64
    mpfr_mul_2si(eps2, eps, 64, MPFR_RNDN);
    x = mpfr_get_d(eps2, MPFR_RNDN);
    //  eps = 1 / sqrt(n/4 * 2^64)
    mpfr_rec_sqrt(eps3, eps2, MPFR_RNDN);
    x = mpfr_get_d(eps3, MPFR_RNDN);

    mpfr_const_pi(pi, MPFR_RNDN);
    x = mpfr_get_d(pi, MPFR_RNDN);
    mpfr_mul_si(smoothz2n, pi, 2, MPFR_RNDN);
    x = mpfr_get_d(smoothz2n, MPFR_RNDN);

    // smoothz2n = sqrt(2pi)
    mpfr_sqrt(smoothz2n2, smoothz2n, MPFR_RNDN);
    x = mpfr_get_d(smoothz2n2, MPFR_RNDN);

    // upper_div = 1 / eps
    mpfr_si_div(upper_div, 1, eps3, MPFR_RNDN);
    x = mpfr_get_d(upper_div, MPFR_RNDN);
    //  upper_div = 1 + 1 / eps
    mpfr_add_si(upper_div2, upper_div, 1, MPFR_RNDN);
    x = mpfr_get_d(upper_div2, MPFR_RNDN);
    //  upper_div = 4n(1 + 1 / eps)
    mpfr_mul_si(upper_div3, upper_div2, 4 * n, MPFR_RNDN);
    x = mpfr_get_d(upper_div3, MPFR_RNDN);
    //  upper_div = log(4n(1 + 1 / eps))
    mpfr_log(upper_div4, upper_div3, MPFR_RNDN);
    x = mpfr_get_d(upper_div4, MPFR_RNDN);
    //  upper_div = log(4n(1 + 1 / eps)) / pi
    mpfr_div(upper_div5, upper_div4, pi, MPFR_RNDN);
    x = mpfr_get_d(upper_div5, MPFR_RNDN);
    //  upper_div = sqrt(log(4n(1 + 1 / eps)) / pi)
    mpfr_sqrt(upper_div6, upper_div5, MPFR_RNDN);
    x = mpfr_get_d(upper_div6, MPFR_RNDN);
    //  mpfr_clears(upper_div5, NULL);

    // smoothz2n = sqrt(log(4n(1 + 1 / eps)) / pi) / sqrt(2 * pi)
    mpfr_div(smoothz2n3, upper_div6, smoothz2n2, MPFR_RNDN);
    // printf("smoothz2n %.20f\n", x);

    // sigma_min = sqrt(log(4n(1 + 1 / eps)) / pi) / sqrt(2 * pi)
    fpr r = create_fpr();
    mpfr_set(r.mpfr_high, smoothz2n3, MPFR_RNDN);
    mpfr_set(r.mpfr, r.mpfr_high, MPFR_RNDN);
    dunion_t sd;
    sd.i = SIGMA_MIN2[logn].f2;
    r.d = sd.d;
    r.emu_d = sd.i;
    r.fpr_tw = SIGMA_MIN_TW[logn];
    // r.fpr_tw = create_from_u64(r.emu_d);

    return r;
}

static fpr compute_sigma(int logn) {
    mpfr_free_cache();
    size_t n = (size_t)1 << logn;
    mpfr_t gs_norm, q, eps, smoothz2n, upper_div, pi, sigma;
    mpfr_inits2(PRECISION_HIGH, gs_norm, q, eps, smoothz2n, upper_div, sigma,
                NULL);

    mpfr_set_si(q, 12289, MPFR_RNDN);

    mpfr_set_si(gs_norm, 117, MPFR_RNDN);
    mpfr_div_si(gs_norm, gs_norm, 100, MPFR_RNDN);
    mpfr_sqrt(q, q, MPFR_RNDN);

    // gs_norm = 117 / 100
    // q = sqrt(q)

    // gs_norm = sqrt(q) * (117 / 100)
    mpfr_mul(gs_norm, gs_norm, q, MPFR_RNDN);

    size_t bitsec = 2 > n / 4 ? 2 : n / 4;
    // size_t bitsec = n / 4;
    // eps = n / 4
    mpfr_set_si(eps, bitsec, MPFR_RNDN);
    // eps = n/4 * 2^64
    mpfr_mul_2si(eps, eps, 64, MPFR_RNDN);
    // eps = 1 / sqrt(n/4 * 2^64)
    mpfr_rec_sqrt(eps, eps, MPFR_RNDN);

    mpfr_init2(pi, PRECISION_HIGH);
    mpfr_free_cache();
    mpfr_const_pi(pi, MPFR_RNDN);
    double x = mpfr_get_d(pi, MPFR_RNDN);
    mpfr_mul_si(smoothz2n, pi, 2, MPFR_RNDN);

    // smoothz2n = sqrt(2pi)
    mpfr_sqrt(smoothz2n, smoothz2n, MPFR_RNDN);

    // upper_div = 1 / eps
    mpfr_si_div(upper_div, 1, eps, MPFR_RNDN);
    // upper_div = 1 + 1 / eps
    mpfr_add_si(upper_div, upper_div, 1, MPFR_RNDN);
    // upper_div = 4n(1 + 1 / eps)
    mpfr_mul_si(upper_div, upper_div, 4 * n, MPFR_RNDN);
    // upper_div = log(4n(1 + 1 / eps))
    mpfr_log(upper_div, upper_div, MPFR_RNDN);
    // upper_div = log(4n(1 + 1 / eps)) / pi
    mpfr_div(upper_div, upper_div, pi, MPFR_RNDN);
    // upper_div = sqrt(log(4n(1 + 1 / eps)) / pi)
    mpfr_sqrt(upper_div, upper_div, MPFR_RNDN);

    // smoothz2n = sqrt(log(4n(1 + 1 / eps)) / pi) / sqrt(2 * pi)
    mpfr_div(smoothz2n, upper_div, smoothz2n, MPFR_RNDN);
    // sigma = sqrt(log(4n(1 + 1 / eps)) / pi) / sqrt(2 * pi) *
    // (117/100)*sqrt(q)
    mpfr_mul(sigma, smoothz2n, gs_norm, MPFR_RNDN);

    fpr r = create_fpr();
    mpfr_si_div(r.mpfr_high, 1, sigma, MPFR_RNDN);
    mpfr_set(r.mpfr, r.mpfr_high, MPFR_RNDN);
    dunion_t sd;
    sd.i = INV_SIGMA2[logn].f2;
    r.d = sd.d;
    r.emu_d = sd.i;
    r.fpr_tw = INV_SIGMA_TW[logn];
    // r.fpr_tw = create_from_u64(r.emu_d);

    return r;
}

static inline void init_sigma() {
    static unsigned int inv_sigma_init = 0;
    static unsigned int sigma_min_init = 0;
    if (inv_sigma_init == 0 || INV_SIGMA[1].f.mpfr[0]._mpfr_d == 0x0) {
        inv_sigma_init = 1;
        fpr_u f;
        f.f = FPR_ZERO;
        INV_SIGMA[0] = f; /* unused */
        f.f = compute_sigma(1);
        INV_SIGMA[1] = f;
        f.f = compute_sigma(2);
        INV_SIGMA[2] = f;
        f.f = compute_sigma(3);
        INV_SIGMA[3] = f;
        f.f = compute_sigma(4);
        INV_SIGMA[4] = f;
        f.f = compute_sigma(5);
        INV_SIGMA[5] = f;
        f.f = compute_sigma(6);
        INV_SIGMA[6] = f;
        f.f = compute_sigma(7);
        INV_SIGMA[7] = f;
        f.f = compute_sigma(8);
        INV_SIGMA[8] = f;
        f.f = compute_sigma(9);
        INV_SIGMA[9] = f;
        f.f = compute_sigma(10);
        INV_SIGMA[10] = f;
    }
    if (sigma_min_init == 0 || SIGMA_MIN[0].f.mpfr[0]._mpfr_d == 0x0) {
        sigma_min_init = 1;
        fpr_u f;
        f.f = FPR_ZERO;
        SIGMA_MIN[0] = f;
        f.f = compute_sigma_min(1);
        SIGMA_MIN[1] = f;
        f.f = compute_sigma_min(2);
        SIGMA_MIN[2] = f;
        f.f = compute_sigma_min(3);
        SIGMA_MIN[3] = f;
        f.f = compute_sigma_min(4);
        SIGMA_MIN[4] = f;
        f.f = compute_sigma_min(5);
        SIGMA_MIN[5] = f;
        f.f = compute_sigma_min(6);
        SIGMA_MIN[6] = f;
        f.f = compute_sigma_min(7);
        SIGMA_MIN[7] = f;
        f.f = compute_sigma_min(8);
        SIGMA_MIN[8] = f;
        f.f = compute_sigma_min(9);
        SIGMA_MIN[9] = f;
        f.f = compute_sigma_min(10);
        SIGMA_MIN[10] = f;
    }
}
#endif
#endif

/* ==================================================================== */
