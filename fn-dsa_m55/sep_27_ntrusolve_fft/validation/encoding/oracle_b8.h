/* Frozen B8 input conversion; test only. Requires oracle.h helpers. */
static __attribute__((noipa)) void oracle_b8_from_big(unsigned logn,fndsa_ds_poly *d,
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
    const size_t step=logn>=3?4:1;
    uint32_t high[4] __attribute__((aligned(16)));
    uint32_t low[4] __attribute__((aligned(16)));
    for(size_t first=0;first<n;first+=step) {
      for(size_t lane=0;lane<step;lane++) {
        size_t i=first+lane;
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
        high[lane]=xh;low[lane]=xl;
      }
      float (*part)[512]=first<hn?d->re:d->im;
      size_t offset=first&(hn-1);
      if(step==4) {
        fndsa_ds_encode4(high,low,part[0]+offset,part[1]+offset);
      } else {
        uint32_t xh=high[0],xl=low[0];
        dsp a=dsum((float)((int32_t)xh>>16)*0x1p16f,(float)(xh&65535));
        a=dadd(a,(dsp){(float)(xl>>16)*0x1p-16f,0});
        a=dadd(a,(dsp){(float)(xl&65535)*0x1p-32f,0});
        putds(part,offset,a);
      }
    }
}
