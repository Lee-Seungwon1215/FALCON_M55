#ifndef FNDSA_DS_Q32_RULES_H
#define FNDSA_DS_Q32_RULES_H
/*
 * Local scalar compatibility primitives for a hi+lo FP32 workspace.
 * No Q32 polynomial array, oracle execution, or seed-specific fallback.
 * FP32/FMA computes products and sums; integer words implement the Q32
 * grid/modulo boundary. Division is the original fixed-count integer
 * quotient primitive for now, not a falsely advertised native FP divide.
 *
 * Two floats cannot encode every signed Q32 word exactly. These helpers
 * reproduce the rules on their represented inputs; full KAT and precision
 * tests remain necessary. They do not prove all-input equivalence.
 */
#include "kgen_inner.h"
#include <math.h>
typedef struct { float h, l; } q32ds;
static inline q32ds qd_sum(float a, float b) {
    float s=a+b, v=s-a;
    return (q32ds){s,(a-(s-v))+(b-v)};
}
static inline q32ds qd_add_unrounded(q32ds a,q32ds b) {
    q32ds s=qd_sum(a.h,b.h);
    return qd_sum(s.h,(s.l+a.l)+b.l);
}
static inline q32ds qd_neg(q32ds a) { return (q32ds){-a.h,-a.l}; }
/* Decode an integral finite FP32 value modulo 2^64, without C float->int UB.
 * Masks are fixed-count; no operand-dependent loop or address. */
static inline uint64_t qd_integral_bits(float f) {
    union { float f; uint32_t u; } v={f};
    int e=(int)((v.u>>23)&255u)-150;
    uint64_t m=(v.u&0x7fffffu)|0x800000u;
    uint32_t u=(uint32_t)e;
    uint32_t left=0-(((u-64u)>>31)&((u>>31)^1u));
    uint32_t right=0-((u>>31)&((uint32_t)(-64-e)>>31));
    /* GCC otherwise rewrites a masked 64-bit shift into a secret branch. */
    __asm__("" : "+r"(left), "+r"(right));
    uint64_t ml=(uint64_t)left|((uint64_t)left<<32);
    uint64_t mr=(uint64_t)right|((uint64_t)right<<32);
    uint64_t z=((m<<((unsigned)e&63u))&ml)
        |((m>>((unsigned)(-e)&63u))&mr);
    uint64_t sign=0-(uint64_t)(v.u>>31);
    return (z^sign)-sign;
}
static __attribute__((noinline)) uint64_t qd_raw_floor(q32ds a) {
    float x=a.h*0x1p32f,y=a.l*0x1p32f;
    float xf=__builtin_floorf(x),yf=__builtin_floorf(y);
    q32ds r=qd_add_unrounded(qd_sum(x,-xf),qd_sum(y,-yf));
    int32_t c=(int32_t)__builtin_floorf(r.h);
    c-=(r.h==(float)c)&(r.l<0);
    return qd_integral_bits(xf)+qd_integral_bits(yf)+(uint64_t)(int64_t)c;
}
static inline q32ds qd_from_raw(uint64_t u) {
    uint32_t hi=(uint32_t)(u>>32),lo=(uint32_t)u;
    q32ds a=qd_sum((float)((int32_t)hi>>16)*0x1p16f,(float)(hi&65535u));
    a=qd_add_unrounded(a,(q32ds){(float)(lo>>16)*0x1p-16f,0});
    return qd_add_unrounded(a,(q32ds){(float)(lo&65535u)*0x1p-32f,0});
}
static inline q32ds qd_grid(q32ds a) {
    return qd_from_raw(qd_raw_floor(a));
}
static inline q32ds qd_add(q32ds a,q32ds b) {
    return qd_grid(qd_add_unrounded(a,b));
}
static inline q32ds qd_sub(q32ds a,q32ds b) {
    return qd_add(a,qd_neg(b));
}
/* Share the sizeable compatibility body instead of duplicating it at every
 * complex-product call site (also keeps full sign/verify firmware in ITCM). */
static __attribute__((noinline)) q32ds qd_mul(q32ds a,q32ds b) {
    float p=a.h*b.h;
    float e=__builtin_fmaf(a.h,b.h,-p);
    e=__builtin_fmaf(a.h,b.l,e);
    e=__builtin_fmaf(a.l,b.h,e);
    e=__builtin_fmaf(a.l,b.l,e);
    /* FP32 expansion gives the leading product. Recover the discarded
     * Q32 low word exactly: native DS rounding can cross a floor boundary.
     * The signed correction is unique while the estimate error is less
     * than 2^31 raw units (=0.5 real units); validate the NTRU domain. */
    uint64_t x=qd_raw_floor(a),y=qd_raw_floor(b);
    uint32_t xl=(uint32_t)x,yl=(uint32_t)y;
    uint32_t low=(uint32_t)(((uint64_t)xl*yl)>>32);
    low+=xl*(uint32_t)(y>>32)+yl*(uint32_t)(x>>32);
    uint64_t estimate=qd_raw_floor(qd_sum(p,e));
    int32_t correction=(int32_t)(low-(uint32_t)estimate);
    uint64_t corrected=estimate+(uint64_t)(int64_t)correction;
    /* DS has ~48 significant bits. Above this conservative product
     * magnitude, a low-word correction alone is ambiguous. Compute the
     * full carry correction too and select with a mask (no secret branch).
     * Both paths execute. This is local integer assistance, not a second
     * polynomial/oracle run. */
    uint64_t exact=fxr_mul((fxr){x},(fxr){y}).v;
    union {float f;uint32_t u;} magnitude={p};
    uint32_t wide=(magnitude.u&0x7fffffffu)>=0x53800000u;
    __asm__("" : "+r"(wide));
    uint64_t mask=0-(uint64_t)wide;
    return qd_from_raw((corrected&~mask)|(exact&mask));
}
static inline q32ds qd_scale(q32ds a,unsigned e) {
    union {uint32_t u;float f;} s={(127u+e)<<23};
    return qd_grid((q32ds){a.h*s.f,a.l*s.f});
}
static inline q32ds qd_half(q32ds a) {
    q32ds b=qd_add(a,(q32ds){0x1p-32f,0});
    return qd_grid((q32ds){b.h*0.5f,b.l*0.5f});
}
static inline q32ds qd_div(q32ds a,q32ds b) {
    return qd_from_raw(inner_fxr_div(qd_raw_floor(a),qd_raw_floor(b)));
}
static inline void qd_cmul(q32ds ar,q32ds ai,q32ds br,q32ds bi,
    q32ds *r,q32ds *im) {
    q32ds ac=qd_mul(ar,br),bd=qd_mul(ai,bi);
    q32ds cross=qd_mul(qd_add(ar,ai),qd_add(br,bi));
    *r=qd_sub(ac,bd);
    *im=qd_sub(cross,qd_add(ac,bd));
}
#endif
