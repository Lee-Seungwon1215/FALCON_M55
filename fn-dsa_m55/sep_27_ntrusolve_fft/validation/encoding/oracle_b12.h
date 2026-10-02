/* Frozen B12 tiled input boundary, test only. Public n>=8 uses exactly
 * the previous two helper calls; the unchanged small path uses B8. */
static __attribute__((noipa)) void
oracle_b12_from_big(unsigned logn,fndsa_ds_poly *d,
    const uint32_t *f,size_t len,uint32_t sc)
{
    if(logn<3||len==0) {
        oracle_b8_from_big(logn,d,f,len,sc);
        return;
    }
    size_t n=(size_t)1<<logn,hn=n>>1;
    uint32_t sch,scl;DIVREM31(sch,scl,sc);
    uint32_t z=(scl-1)>>31;sch-=z;scl|=31&-z;
    const uint32_t params[4]={(uint32_t)len,(uint32_t)(n*sizeof *f),sch,scl};
    uint32_t high[4] __attribute__((aligned(16)));
    uint32_t low[4] __attribute__((aligned(16)));
    for(size_t first=0;first<n;first+=4) {
        fndsa_ds_select4(f+first,params,high,low);
        float (*part)[512]=first<hn?d->re:d->im;
        size_t offset=first&(hn-1);
        fndsa_ds_encode4(high,low,part[0]+offset,part[1]+offset);
    }
}
