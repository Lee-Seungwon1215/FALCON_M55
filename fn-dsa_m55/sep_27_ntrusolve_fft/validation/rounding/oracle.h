/* Frozen B4 rounding oracle: validation only. */
typedef struct { float h,l; } dsp;
static inline dsp dsum(float a,float b) {
    float s=a+b,v=s-a;
    return (dsp){s,(a-(s-v))+(b-v)};
}
static inline dsp dadd(dsp a,dsp b) {
    dsp s=dsum(a.h,b.h);
    return dsum(s.h,(s.l+a.l)+b.l);
}
static inline dsp dscale(dsp a,float s) {
    return (dsp){a.h*s,a.l*s};
}
static inline dsp getds(const float p[2][512],size_t u) {
    return (dsp){p[0][u],p[1][u]};
}
static inline void putds(float p[2][512],size_t u,dsp a) {
    p[0][u]=a.h;p[1][u]=a.l;
}
static inline float pow2i(int e) {
    union {uint32_t u;float f;} a={(uint32_t)(127+e)<<23};
    return a.f;
}
/* Prevent test-only constant propagation/inlining of the old public API. */
static __attribute__((noipa)) int oracle_to_k(unsigned logn,int32_t *d,const fndsa_ds_poly *s) {
    size_t n=(size_t)1<<logn,hn=n>>1;
    uint32_t valid=1;
    for(size_t i=0;i<n;i++) {
        dsp x=getds(i<hn?s->re:s->im,i&(hn-1));
        union {float f;uint32_t u;} xh={x.h},xl={x.l};
        uint32_t ok=((xh.u&0x7fffffffu)<0x4f000000u)
            &((xl.u&0x7fffffffu)<0x4f000000u);
        uint32_t mask=0u-ok;xh.u&=mask;xl.u&=mask;
        valid&=ok;x.h=xh.f;x.l=xl.f;
        /* Match the retained original grid semantics at this boundary:
         * nearest Q32 then floor(x+.5) == floor(x+.5+2^-33).
         * No Q32 array and no int64 cast; retain low component at ties. */
        dsp a=dadd(dadd(x,(dsp){0.5f,0}),(dsp){0x1p-33f,0});
        xh.f=a.h;xl.f=a.l;
        ok=((xh.u&0x7fffffffu)<0x4f000000u)
            &((xl.u&0x7fffffffu)<0x4f000000u);
        mask=0u-ok;xh.u&=mask;xl.u&=mask;valid&=ok;
        a.h=xh.f;a.l=xl.f;
        float hi=__builtin_floorf(a.h),lo=__builtin_floorf(a.l);
        /* A plain a.l-lo loses a negative epsilon when lo=-1: it
         * rounds 1-epsilon to 1 and crosses the half boundary. */
        dsp fraction=dadd(dsum(a.h,-hi),dsum(a.l,-lo));
        int32_t carry=(int32_t)__builtin_floorf(fraction.h);
        carry-=(fraction.h==(float)carry) & (fraction.l<0);
        int64_t k=(int64_t)(int32_t)hi+(int64_t)(int32_t)lo+carry;
        valid&=(k>=INT32_MIN)&(k<=INT32_MAX);
        d[i]=(int32_t)(uint32_t)k;
    }
    return (int)valid;
}
