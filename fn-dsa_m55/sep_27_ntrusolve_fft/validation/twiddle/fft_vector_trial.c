/* Test-only second integration: the original surrounding 64-bit additions
 * and stagewise halves now use exact integer-MVE spans as well. */
#include "kgen_inner.h"
#include "table.h"
extern void trial_mve_q32_twiddle(const uint64_t *,uint64_t *,unsigned,const uint64_t *);
extern void trial_q32_add_span(const fxr *,const fxr *,fxr *,unsigned);
extern void trial_q32_finish_forward(fxr *const *,unsigned);
extern void trial_q32_finish_inverse(fxr *const *,unsigned);
extern void trial_q32_prepare_inverse(fxr *const *,unsigned);

static void products(unsigned count,const fxr *re,const fxr *im,
    fxc s,fxr work[3][128]) {
    trial_q32_add_span(re,im,work[0],count);
    fxr sum=fxr_add(s.re,s.im);
    trial_mve_q32_twiddle((const uint64_t *)re,(uint64_t *)work[1],count,&s.re.v);
    trial_mve_q32_twiddle((const uint64_t *)im,(uint64_t *)work[2],count,&s.im.v);
    trial_mve_q32_twiddle((const uint64_t *)work[0],(uint64_t *)work[0],count,&sum.v);
}
void trial_vector_forward(unsigned logn,fxr *f,unsigned batch,unsigned cutoff) {
    size_t hn=(size_t)1<<(logn-1),t=hn;
    fxr work[3][128];
    for(unsigned lm=1;lm<logn;lm++) {
        size_t m=(size_t)1<<lm,ht=t>>1,j0=0;
        for(size_t i=0;i<m/2;i++,j0+=t) {
            fxc s={{original_twiddles[m+i][0]},{original_twiddles[m+i][1]}};
            if(ht<cutoff) {
                for(size_t j=j0;j<j0+ht;j++) {
                    fxc x={f[j],f[j+hn]},y={f[j+ht],f[j+ht+hn]};
                    y=fxc_mul(s,y);
                    fxc a=fxc_add(x,y),b=fxc_sub(x,y);
                    f[j]=a.re;f[j+hn]=a.im;f[j+ht]=b.re;f[j+ht+hn]=b.im;
                }
            } else for(size_t j=j0;j<j0+ht;) {
                unsigned count=(unsigned)(j0+ht-j);if(count>batch)count=batch;
                fxr *p[]={f+j,f+j+hn,f+j+ht,f+j+ht+hn,work[0],work[1],work[2]};
                products(count,p[2],p[3],s,work);
                trial_q32_finish_forward(p,count);
                j+=count;
            }
        }
        t=ht;
    }
}
void trial_vector_inverse(unsigned logn,fxr *f,unsigned batch,unsigned cutoff) {
    size_t hn=(size_t)1<<(logn-1),ht=1;
    fxr work[3][128];
    for(unsigned lm=logn-1;lm>0;lm--) {
        size_t m=(size_t)1<<lm,t=ht<<1,j0=0;
        for(size_t i=0;i<m/2;i++,j0+=t) {
            fxc s={{original_twiddles[m+i][0]},{-original_twiddles[m+i][1]}};
            if(ht<cutoff) {
                for(size_t j=j0;j<j0+ht;j++) {
                    fxc x={f[j],f[j+hn]},y={f[j+ht],f[j+ht+hn]};
                    fxc a=fxc_half(fxc_add(x,y));
                    fxc b=fxc_mul(s,fxc_half(fxc_sub(x,y)));
                    f[j]=a.re;f[j+hn]=a.im;f[j+ht]=b.re;f[j+ht+hn]=b.im;
                }
            } else for(size_t j=j0;j<j0+ht;) {
                unsigned count=(unsigned)(j0+ht-j);if(count>batch)count=batch;
                fxr *p[]={f+j,f+j+hn,f+j+ht,f+j+ht+hn,work[0],work[1],work[2]};
                trial_q32_prepare_inverse(p,count);
                products(count,p[2],p[3],s,work);
                trial_q32_finish_inverse(p,count);
                j+=count;
            }
        }
        ht<<=1;
    }
}
