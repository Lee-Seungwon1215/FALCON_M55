#include "kgen_inner.h"
#include <stdio.h>
#include <math.h>
#include "frozen_cases.inc"
static fxr f[1024],F[1024];
static long double value(fxr a){return (long double)(int64_t)a.v*0x1p-32L;}
int main(void){
    for(unsigned ci=0;ci<sizeof cases/sizeof cases[0];ci++){
        const struct fft_case *c=&cases[ci];if(c->logn<4)continue;
        size_t n=(size_t)1<<c->logn,hn=n/2;
        for(size_t j=0;j<n;j++){f[j].v=c->f[j];F[j].v=c->F[j];}
        vect_FFT(c->logn,f);long double minnorm=INFINITY;unsigned mini=0;
        for(size_t j=0;j<hn;j++){
            long double a=value(f[j]),b=value(f[j+hn]),den=a*a+b*b;
            if(den<minnorm){minnorm=den;mini=j;}
        }
        fxr den=fxr_add(fxr_sqr(f[mini]),fxr_sqr(f[mini+hn]));
        printf("HOST_Q32_DEN case=%u name=%s index=%u re_raw=%016llx im_raw=%016llx original_den_raw=%016llx exact_den=%.18Lg denominator_ratio=%.18Lg\n",ci,c->name,mini,(unsigned long long)f[mini].v,(unsigned long long)f[mini+hn].v,(unsigned long long)den.v,minnorm,value(den)/minnorm);
        vect_inv_mul2e_fft(c->logn,f,c->e);vect_FFT(c->logn,F);
        unsigned over=0;long double largest=0;unsigned largest_i=0;
        for(size_t j=0;j<hn;j++){
            long double a=value(F[j]),b=value(F[j+hn]),x=value(f[j]),y=value(f[j+hn]);
            long double re=a*x-b*y,im=a*y+b*x;
            if(fabsl(re)>largest){largest=fabsl(re);largest_i=j;}
            if(fabsl(im)>largest){largest=fabsl(im);largest_i=j+hn;}
            over+=(re < -0x1p31L || re >= 0x1p31L);
            over+=(im < -0x1p31L || im >= 0x1p31L);
        }
        vect_mul_fft(c->logn,F,f);
        printf("HOST_Q32_PRODUCT case=%u outside_signed_q32=%u max_unwrapped_abs=%.18Lg index=%u wrapped_ref_raw=%016llx\n",ci,over,largest,largest_i,(unsigned long long)F[largest_i].v);
    }
    return 0;
}
