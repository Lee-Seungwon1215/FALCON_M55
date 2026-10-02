/* Frozen B4 scalar input oracle: test only. */
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
/* Construct the same selected/scaled input bits as poly_big_to_fixed,
 * but write FP32 components directly, never an fxr input array.
 * The limb scan and masks deliberately preserve secret-scale access rules. */
static void oracle_from_big(unsigned logn,fndsa_ds_poly *d,
    const uint32_t *f,size_t len,uint32_t sc)
{
    size_t n=(size_t)1<<logn,hn=n>>1;
    if(len==0) {
        for(unsigned part=0;part<2;part++)
            for(unsigned limb=0;limb<2;limb++)
                memset(part?d->im[limb]:d->re[limb],0,hn*sizeof(float));
        return;
    }
    uint32_t sch,scl; DIVREM31(sch,scl,sc);
    uint32_t z=(scl-1)>>31;sch-=z;scl|=31&-z;
    uint32_t t0=(sch-1)&0xffffff,t1=sch&0xffffff,t2=(sch+1)&0xffffff;
    for(size_t i=0;i<n;i++) {
        uint32_t w0=0,w1=0,w2=0;
        for(size_t j=0;j<len;j++) {
            uint32_t w=f[i+(j<<logn)],t=(uint32_t)j&0xffffff;
            w0|=w&-(((t^t0)-1)>>31);
            w1|=w&-(((t^t1)-1)>>31);
            w2|=w&-(((t^t2)-1)>>31);
        }
        uint32_t ws=-(f[i+((len-1)<<logn)]>>30)>>1;
        w0|=ws&-(((uint32_t)len-sch)>>31);
        w1|=ws&-(((uint32_t)len-sch-1)>>31);
        w2|=ws&-(((uint32_t)len-sch-2)>>31);
        w2|=(w2&0x40000000u)<<1;
        uint32_t xl=(w0>>(scl-1))|(w1<<(32-scl));
        uint32_t xh=(w1>>scl)|(w2<<(31-scl));
        dsp a=dsum((float)((int32_t)xh>>16)*0x1p16f,(float)(xh&65535));
        a=dadd(a,(dsp){(float)(xl>>16)*0x1p-16f,0});
        a=dadd(a,(dsp){(float)(xl&65535)*0x1p-32f,0});
        putds(i<hn?d->re:d->im,i&(hn-1),a);
    }
}


