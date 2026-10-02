/* Frozen B6 rules and point product; test-only oracle. */
/* Also includes unchanged B6 reciprocal and real-division rules. */
#ifndef FNDSA_DS_Q32_RULES_H
#define FNDSA_DS_Q32_RULES_H
/*
 * Local scalar compatibility primitives for a hi+lo FP32 workspace.
 * No Q32 polynomial array, oracle execution, or seed-specific fallback.
 * FP32 expansions compute sums and store the FFT workspace; integer words
 * implement exact Q32 products and grid/modulo boundaries. Division is the original fixed-count integer
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
#if defined(__arm__)
    /* ARM register shifts use the low 8 count bits and zero the result
     * for counts >=32. For finite binary32, -150<=e<=104; all unwanted
     * signed-count cases therefore have low-byte counts >=32. Compute
     * low/high words directly without C's masked uint64 variable shifts.
     * No operand-dependent branch, table, integer division or cast helper. */
    uint32_t m=(v.u&0x7fffffu)|0x800000u,lo,hi,t;
    __asm__(
        "lsl.w %[lo], %[m], %[e]\n\t"
        "rsb.w %[t], %[e], #0\n\t"
        "lsr.w %[t], %[m], %[t]\n\t"
        "orr.w %[lo], %[lo], %[t]\n\t"
        "rsb.w %[t], %[e], #32\n\t"
        "lsr.w %[hi], %[m], %[t]\n\t"
        "sub.w %[t], %[e], #32\n\t"
        "lsl.w %[t], %[m], %[t]\n\t"
        "orr.w %[hi], %[hi], %[t]"
        : [lo] "=&r" (lo), [hi] "=&r" (hi), [t] "=&r" (t)
        : [m] "r" (m), [e] "r" (e));
    uint64_t z=(uint64_t)lo|((uint64_t)hi<<32);
#else
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
#endif

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
    /* The previous implementation evaluated BOTH a floating estimate with
     * carry correction and this exact integer product. Select the exact
     * operation directly: one decode per operand, one product, one encode.
     * Polynomial storage and the FFT stay two-FP32; no fallback/oracle run. */
    fxr x={qd_raw_floor(a)}, y={qd_raw_floor(b)};
    return qd_from_raw(fxr_mul(x,y).v);
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

static __attribute__((noipa)) void oracle_inverse(unsigned logn,fndsa_ds_poly *d,unsigned e) {
    size_t hn=(size_t)1<<(logn-1);
    for(size_t i=0;i<hn;i++) {
        fxr r={qd_raw_floor((q32ds){d->re[0][i],d->re[1][i]})};
        fxr s={qd_raw_floor((q32ds){d->im[0][i],d->im[1][i]})};
        fxr norm=fxr_add(fxr_sqr(r),fxr_sqr(s));
        q32ds re=qd_from_raw(inner_fxr_div(r.v<<e,norm.v));
        q32ds im=qd_from_raw(inner_fxr_div((-s.v)<<e,norm.v));
        d->re[0][i]=re.h;d->re[1][i]=re.l;
        d->im[0][i]=im.h;d->im[1][i]=im.l;
    }
}

static __attribute__((noipa)) void oracle_div_real(unsigned logn,fndsa_ds_poly *d,const fndsa_ds_poly *b) {
    size_t hn=(size_t)1<<(logn-1);
    for(size_t i=0;i<hn;i++) {
        uint64_t den=qd_raw_floor((q32ds){b->re[0][i],b->re[1][i]});
        uint64_t r=qd_raw_floor((q32ds){d->re[0][i],d->re[1][i]});
        uint64_t s=qd_raw_floor((q32ds){d->im[0][i],d->im[1][i]});
        q32ds re=qd_from_raw(inner_fxr_div(r,den));
        q32ds im=qd_from_raw(inner_fxr_div(s,den));
        d->re[0][i]=re.h;d->re[1][i]=re.l;
        d->im[0][i]=im.h;d->im[1][i]=im.l;
    }
}

static __attribute__((noipa)) void oracle_mul(unsigned logn,fndsa_ds_poly *d,const fndsa_ds_poly *b) {
    size_t hn=(size_t)1<<(logn-1);
    for(size_t i=0;i<hn;i++) {
        /* Decode once per input coefficient, perform the original three-
         * product Q32 complex rule in integer registers, encode once per
         * output. The polynomial workspace stays FP32 expansions. This is
         * an explicit hybrid, not a native-FP multiplication claim; there
         * is no full-array Q32 conversion or value-dependent fallback.
         * Keeping intermediate Q32 words also avoids repeated rounding to
         * the narrower two-FP32 expansion after each add/product. */
        fxc a0={
            {qd_raw_floor((q32ds){d->re[0][i],d->re[1][i]})},
            {qd_raw_floor((q32ds){d->im[0][i],d->im[1][i]})}};
        fxc b0={
            {qd_raw_floor((q32ds){b->re[0][i],b->re[1][i]})},
            {qd_raw_floor((q32ds){b->im[0][i],b->im[1][i]})}};
        fxc c=fxc_mul(a0,b0);
        q32ds re=qd_from_raw(c.re.v),im=qd_from_raw(c.im.v);
        d->re[0][i]=re.h;d->re[1][i]=re.l;
        d->im[0][i]=im.h;d->im[1][i]=im.l;
    }
}
