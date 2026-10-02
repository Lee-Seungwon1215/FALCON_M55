#include "kgen_inner.h"
#include <stdio.h>
#include <string.h>
void ref_vect_invnorm_fft(unsigned,fxr *,const fxr *,const fxr *,unsigned);
static fxr a[1024],b[1024],x[512],y[512];
static uint32_t state=2398421;
static uint32_t rnd(void){state^=state<<13;state^=state>>17;state^=state<<5;return state;}
int main(void) {
    size_t count=0,bad=0;uint64_t max=0;
    for(unsigned logn=1;logn<=10;logn++)for(unsigned j=0;j<1000;j++) {
        size_t n=(size_t)1<<logn;
        for(size_t i=0;i<n;i++) {
            a[i]=fxr_of((int32_t)(rnd()%63)-31);b[i]=fxr_of((int32_t)(rnd()%63)-31);
            if(j&1){a[i].v+=rnd();b[i].v+=rnd();}
            if(j==0){a[i].v=0;b[i].v=0;}
        }
        ref_vect_invnorm_fft(logn,x,a,b,0);
        fndsa_vect_invnorm_fp64_q32(logn,y,a,b);
        for(size_t i=0;i<n/2;i++) {
            int64_t d=(int64_t)(y[i].v-x[i].v);
            uint64_t z=d<0?-(uint64_t)d:(uint64_t)d;
            count++;bad+=z!=0;if(z>max)max=z;
        }
    }
    printf("HOST_INVNORM count=%zu differing=%zu max_lsb=%llu\n",count,bad,(unsigned long long)max);
    return 0;
}
