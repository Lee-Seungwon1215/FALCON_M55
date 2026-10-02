/* Test-only complete fixed FFTs. The candidate's production source is not
 * changed. Runtime batch/cutoff parameters explore public layout choices,
 * not secret precision selection or production build backends. */
#include "kgen_inner.h"
#include "table.h"
extern void trial_mve_q32_twiddle(const uint64_t *,uint64_t *,unsigned,const uint64_t *);

static void products(unsigned count,const fxr *re,const fxr *im,
    fxc s,fxr work[3][128]) {
    for(unsigned k=0;k<count;k++)work[0][k]=fxr_add(re[k],im[k]);
    fxr sum=fxr_add(s.re,s.im);
    trial_mve_q32_twiddle((const uint64_t *)re,(uint64_t *)work[1],count,&s.re.v);
    trial_mve_q32_twiddle((const uint64_t *)im,(uint64_t *)work[2],count,&s.im.v);
    trial_mve_q32_twiddle((const uint64_t *)work[0],(uint64_t *)work[0],count,&sum.v);
}
void trial_fixed_forward(unsigned logn,fxr *f,unsigned batch,unsigned cutoff) {
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
                products(count,f+j+ht,f+j+ht+hn,s,work);
                for(unsigned k=0;k<count;k++) {
                    fxr yr=fxr_sub(work[1][k],work[2][k]);
                    fxr yi=fxr_sub(work[0][k],fxr_add(work[1][k],work[2][k]));
                    fxr xr=f[j+k],xi=f[j+k+hn];
                    f[j+k]=fxr_add(xr,yr);f[j+k+hn]=fxr_add(xi,yi);
                    f[j+k+ht]=fxr_sub(xr,yr);f[j+k+ht+hn]=fxr_sub(xi,yi);
                }
                j+=count;
            }
        }
        t=ht;
    }
}
void trial_fixed_inverse(unsigned logn,fxr *f,unsigned batch,unsigned cutoff) {
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
                for(unsigned k=0;k<count;k++) {
                    fxc x={f[j+k],f[j+k+hn]},y={f[j+k+ht],f[j+k+ht+hn]};
                    fxc a=fxc_half(fxc_add(x,y)),b=fxc_half(fxc_sub(x,y));
                    f[j+k]=a.re;f[j+k+hn]=a.im;f[j+k+ht]=b.re;f[j+k+ht+hn]=b.im;
                }
                products(count,f+j+ht,f+j+ht+hn,s,work);
                for(unsigned k=0;k<count;k++) {
                    f[j+k+ht]=fxr_sub(work[1][k],work[2][k]);
                    f[j+k+ht+hn]=fxr_sub(work[0][k],fxr_add(work[1][k],work[2][k]));
                }
                j+=count;
            }
        }
        ht<<=1;
    }
}
