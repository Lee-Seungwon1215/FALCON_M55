/* Same-image Q32 public-boundary comparison. Timed range includes conversions.
 * Baseline C bodies come from unchanged ntt_opt (also equal to M55_ref here).
 */
#include "kgen_inner.h"
#include <stdio.h>
#include <string.h>
#include <cmsis_core.h>
#include <stm32n6xx.h>
void ref_vect_FFT(unsigned,fxr *);
void ref_vect_iFFT(unsigned,fxr *);
void ref_vect_invnorm_fft(unsigned,fxr *,const fxr *,const fxr *,unsigned);
static fxr input[1024], other[1024], a[1024], b[1024];
static uint32_t rng=0x8936217u;
static volatile uint64_t sink;
static uint32_t rnd(void) {rng^=rng<<13;rng^=rng>>17;rng^=rng<<5;return rng;}
static void prepare(unsigned logn,unsigned cls,unsigned op) {
    size_t n=(size_t)1<<logn;
    for(size_t i=0;i<n;i++) {
        int32_t x=(int32_t)(rnd()%63)-31, y=(int32_t)(rnd()%63)-31;
        input[i]=fxr_of(x); other[i]=fxr_of(y);
        if(cls&1) {input[i].v+=rnd();other[i].v+=rnd();}
        if(cls==2) input[i]=fxr_of(i==0?1:0);
        if(cls==3) input[i]=fxr_of((i&1)?-1:1);
        if(cls==4) {input[i].v=0;other[i].v=0;}
        if(cls==5) input[i].v=(uint64_t)(int64_t)((int32_t)(rnd()%65535)-32767);
        if(cls==6) input[i]=fxr_of((int32_t)(rnd()%8191)-4095);
        if(cls==7) input[i].v=fxr_of((int32_t)(i%17)-8).v+UINT32_MAX;
    }
    if(op==1) ref_vect_FFT(logn,input);
    if(op==2) {ref_vect_FFT(logn,input);ref_vect_FFT(logn,other);}
}
static void __attribute__((noinline,noclone)) call(unsigned backend,unsigned op,unsigned logn,fxr *f) {
    if(op==0) {
        if(backend==0)ref_vect_FFT(logn,f);
        else if(backend==1)vect_FFT(logn,f);
        else fndsa_vect_FFT_mve_q32(logn,f);
    } else if(op==1) {
        if(backend==0)ref_vect_iFFT(logn,f);
        else if(backend==1)vect_iFFT(logn,f);
        else fndsa_vect_iFFT_mve_q32(logn,f);
    } else {
        if(backend==0)ref_vect_invnorm_fft(logn,f,input,other,0);
        else fndsa_vect_invnorm_fp64_q32(logn,f,input,other);
    }
}
static uint32_t __attribute__((noinline,noclone)) measure(unsigned be,unsigned op,unsigned logn) {
    __DSB();__ISB();uint32_t t=DWT->CYCCNT;
    call(be,op,logn,b);
    __DSB();__ISB();uint32_t elapsed=DWT->CYCCNT-t;
    sink^=b[0].v;return elapsed;
}
int mlk_test_main(int argc,char **argv) {
    (void)argc;(void)argv;
    if(SystemCoreClock!=800000000u || (SCB->CCR&0x30000u) || *(volatile unsigned*)0x56008008!=0x99u || (__get_FPSCR()&0x1C00000u))return 10;
    CoreDebug->DEMCR|=CoreDebug_DEMCR_TRCENA_Msk;DWT->CTRL|=DWT_CTRL_CYCCNTENA_Msk;
    for(unsigned logn=1;logn<=10;logn++) for(unsigned op=0;op<3;op++) {
        size_t n=(size_t)1<<logn, count=op==2?n/2:n;
        unsigned backends=op==2?2:3;
        for(unsigned be=0;be<backends;be++) {
            if(be==2 && logn<4)continue;
            /* Identical input stream for each compared backend. */
            rng=0x8936217u ^ (logn<<16) ^ (op<<24);
            uint64_t total=0,diff=0,maxerr=0;
            uint32_t low=UINT32_MAX,high=0;
            for(unsigned j=0;j<110;j++) {
                prepare(logn,j&1,op);
                memcpy(a,input,n*sizeof(fxr));memcpy(b,input,n*sizeof(fxr));
                call(0,op,logn,a);
                unsigned irq=__get_PRIMASK();__disable_irq();
                uint32_t t=measure(be,op,logn);
                if(!irq)__enable_irq();
                if(j>=10) {
                    total+=t;if(t<low)low=t;if(t>high)high=t;
                    for(size_t u=0;u<count;u++) {
                        int64_t de=(int64_t)(b[u].v-a[u].v);
                        uint64_t er=de<0?-(uint64_t)de:(uint64_t)de;
                        diff+=er!=0;if(er>maxerr)maxerr=er;
                    }
                }
            }
            printf("HYBRID_KERNEL logn=%u op=%u backend=%u calls=100 total=%llu min=%u max=%u diff=%llu max_lsb=%llu\n",
                logn,op,be,(unsigned long long)total,low,high,(unsigned long long)diff,(unsigned long long)maxerr);
        }
    }
    for(unsigned logn=4;logn<=10;logn++)for(unsigned op=0;op<3;op++)for(unsigned cls=0;cls<8;cls++) {
        uint64_t total=0;uint32_t low=UINT32_MAX,high=0;
        prepare(logn,cls,op);
        for(unsigned j=0;j<110;j++) {
            memcpy(b,input,((size_t)1<<logn)*sizeof(fxr));
            unsigned irq=__get_PRIMASK();__disable_irq();
            uint32_t t=measure(op==2?1:2,op,logn);
            if(!irq)__enable_irq();
            if(j>=10){total+=t;if(t<low)low=t;if(t>high)high=t;}
        }
        printf("HYBRID_TIMING logn=%u op=%u class=%u calls=100 total=%llu min=%u max=%u\n",logn,op,cls,(unsigned long long)total,low,high);
    }
    printf("HYBRID_KERNEL_DONE\n");return 0;
}
