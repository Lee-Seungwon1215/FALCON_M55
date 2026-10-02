/* Host scalar arithmetic audit. Operations copied from local candidate;
 * only native scalar VFMA is represented by host fmaf. Not an M55 timing test. */
#include <stdint.h>
#include <stdio.h>
#include <math.h>
typedef struct { float h, l; } ds_scalar;
static inline float ds_fma(float a, float b, float c) {
    c=fmaf(a,b,c);
    return c;
}
static inline ds_scalar ds_normalize(float h, float l) {
    float s=h+l, z=s-h;
    return (ds_scalar){s, (h-(s-z))+(l-z)};
}
static inline ds_scalar ds_plus(ds_scalar a, ds_scalar b) {
    float s=a.h+b.h, z=s-a.h;
    float e=(a.h-(s-z))+(b.h-z);
    return ds_normalize(s, e+(a.l+b.l));
}
static inline ds_scalar ds_minus(ds_scalar a, ds_scalar b) {
    return ds_plus(a,(ds_scalar){-b.h,-b.l});
}
static inline ds_scalar ds_product(ds_scalar a, ds_scalar b) {
    float h=a.h*b.h;
    float l=ds_fma(a.h,b.h,-h);
    l=ds_fma(a.h,b.l,l);
    l=ds_fma(a.l,b.h,l);
    l=ds_fma(a.l,b.l,l);
    return ds_normalize(h,l);
}
static inline ds_scalar ds_scale(ds_scalar a, float s) {
    return (ds_scalar){a.h*s,a.l*s};
}
/* Normalize the divisor to [1,2) before scalar hardware FP32 divide.
 * Three fixed quotient terms refine the ~24-bit estimate. The reciprocal
 * is computed once per complex coefficient, not once per component.
 * Production denominators are positive and normal; zero has an explicit
 * failure status after every lane is scanned. The solver rejects the
 * reduction instead of inventing a zero quotient or a fixed-point fallback.
 * Input-domain timing tests are still required; this is not a CT proof. */
static inline ds_scalar ds_recip(ds_scalar b,unsigned *valid) {
    union {float f; uint32_t u;} v={b.h}, sc, bn;
    uint32_t e=(v.u>>23)&255u;
    union {float f;uint32_t u;} low={b.l};
    uint32_t ok=(uint32_t)((e-1u)<253u) & (1u^(v.u>>31))
        &(uint32_t)(((low.u>>23)&255u)<255u);
    /* Keep the full-scan validity mask opaque to GCC; otherwise it can
     * clone the arithmetic into secret exponent-class branches. */
    __asm__("" : "+r"(ok));
    *valid &= ok;
    uint32_t mask=-ok;
    bn.u=(v.u&mask&0x007fffff)|0x3f800000;
    sc.u=(((254u-e)<<23)&mask)|(0x3f800000&~mask);
    low.u&=mask;b.l=low.f;
    ds_scalar d={bn.f,b.l*sc.f};
    float q=1.0f/d.h;
    ds_scalar r=ds_minus((ds_scalar){1,0},ds_product(d,(ds_scalar){q,0}));
    float q2=(r.h+r.l)*q;
    ds_scalar out=ds_plus((ds_scalar){q,0},(ds_scalar){q2,0});
    r=ds_minus((ds_scalar){1,0},ds_product(d,out));
    out=ds_plus(out,(ds_scalar){(r.h+r.l)*q,0});
    out=ds_scale(out,sc.f);
    union {float f;uint32_t u;} oh={out.h},ol={out.l};
    oh.u &= mask; ol.u &= mask;
    return (ds_scalar){oh.f,ol.f};
}

static uint32_t r=0x19580927u;
static uint32_t rnd(void){r^=r<<13;r^=r>>17;r^=r<<5;return r;}
int main(void){
 unsigned count=0,bad=0,invalid_bad=0;long double maxrel=0;
 for(int exp=-30;exp<=30;exp++)for(unsigned j=0;j<1000;j++){
   float h=ldexpf(1.0f+(float)(rnd()&0x7fffff)*0x1p-23f,exp);
   float l=ldexpf((float)(int32_t)(rnd()&65535)-32768.0f,exp-40);
   ds_scalar den=ds_normalize(h,l);unsigned valid=1;
   ds_scalar q=ds_recip(den,&valid);
   long double expected=1.0L/((long double)den.h+(long double)den.l);
   long double actual=(long double)q.h+(long double)q.l;
   long double rel=fabsl((actual-expected)/expected);
   if(rel>maxrel)maxrel=rel;
   count++;bad+=!valid || !isfinite(q.h) || !isfinite(q.l) || rel>0x1p-42L;
 }
 const ds_scalar invalid[]={{0,0},{-1,0},{INFINITY,0},{NAN,0},{1,NAN},{0x1p-127f,0}};
 for(unsigned j=0;j<sizeof invalid/sizeof invalid[0];j++){
   unsigned valid=1;ds_scalar q=ds_recip(invalid[j],&valid);
   invalid_bad+=valid!=0 || !isfinite(q.h) || !isfinite(q.l);
 }
 printf("HOST_DS_RECIP count=%u excessive_error=%u invalid_accepted=%u max_relative=%.18Lg\n",count,bad,invalid_bad,maxrel);
 return bad||invalid_bad;
}
