/* Paired B pipeline tests: same input, full Q32 boundaries included. */
#include "kgen_inner.h"
#include "kgen_ds.h"
#include <stdio.h>
#include <string.h>
#include <cmsis_core.h>
#include <stm32n6xx.h>
static fxr input[1024],den[1024],a[1024],b[1024],inv[1024],scratch[1024];
static fndsa_ds_workspace wd __attribute__((aligned(16))),wn __attribute__((aligned(16)));
static uint32_t rng=0x13579321u;
static volatile uint64_t sink;
static uint32_t rnd(void){rng^=rng<<13;rng^=rng>>17;rng^=rng<<5;return rng;}
static void prepare(unsigned logn,unsigned cls) {
    size_t n=(size_t)1<<logn;
    for(size_t i=0;i<n;i++) {
        input[i]=fxr_of((int32_t)(rnd()%63)-31);
        den[i]=fxr_of(0);
        if(cls&1)input[i].v+=rnd();
        if(cls==2)input[i]=fxr_of(i?0:1);
        if(cls==3)input[i]=fxr_of((i&1)?-1:1);
        if(cls==4)input[i]=fxr_of(0);
        if(cls==5)input[i].v=(uint64_t)(int64_t)((int32_t)(rnd()%65535)-32767);
        if(cls==6)input[i]=fxr_of((int32_t)(rnd()%8191)-4095);
        if(cls==7)input[i].v=fxr_of((int32_t)(i%17)-8).v+UINT32_MAX;
    }
    /* Positive constant Fourier denominator; 128 vs129 exposes exact
     * reciprocal/residual-zero timing. The same class goes to both paths. */
    den[0]=fxr_of((cls&1)?129:128);
    memcpy(inv,den,n*sizeof *den);
    vect_FFT(logn,inv);vect_inv_mul2e_fft(logn,inv,4);
    fndsa_ds_import(logn,&wd,den);fndsa_ds_forward(logn,&wd);
    fndsa_ds_reciprocal(logn,&wd,4);
}
static void __attribute__((noinline,noclone)) call(unsigned be,unsigned op,unsigned logn,fxr *out) {
    size_t n=(size_t)1<<logn;
    if(!be) {
        if(op==0){vect_FFT(logn,out);vect_inv_mul2e_fft(logn,out,4);}
        if(op==1){vect_FFT(logn,out);vect_mul_fft(logn,out,inv);vect_iFFT(logn,out);}
        if(op==2){memcpy(scratch,den,n*sizeof *den);vect_FFT(logn,scratch);
          vect_FFT(logn,out);vect_div_selfadj_fft(logn,out,scratch);vect_iFFT(logn,out);}
    } else {
        fndsa_ds_import(logn,&wn,out);fndsa_ds_forward(logn,&wn);
        if(op==0)fndsa_ds_reciprocal(logn,&wn,4);
        if(op==1){fndsa_ds_mul(logn,&wn,&wd);fndsa_ds_inverse(logn,&wn);}
        if(op==2){fndsa_ds_import(logn,&wd,den);fndsa_ds_forward(logn,&wd);
          fndsa_ds_div_selfadj(logn,&wn,&wd);fndsa_ds_inverse(logn,&wn);}
        fndsa_ds_export(logn,out,&wn);
    }
}
static uint32_t measure(unsigned be,unsigned op,unsigned logn){
    __DSB();__ISB();uint32_t t=DWT->CYCCNT;call(be,op,logn,b);
    __DSB();__ISB();uint32_t elapsed=DWT->CYCCNT-t;sink^=b[0].v;return elapsed;
}
int mlk_test_main(int argc,char **argv){
    (void)argc;(void)argv;
    if(SystemCoreClock!=800000000u || (SCB->CCR&0x30000u) || *(volatile unsigned*)0x56008008!=0x99u || (__get_FPSCR()&0x1C00000u))return 10;
    CoreDebug->DEMCR|=CoreDebug_DEMCR_TRCENA_Msk;DWT->CTRL|=DWT_CTRL_CYCCNTENA_Msk;
    for(unsigned logn=4;logn<=10;logn++)for(unsigned op=0;op<3;op++)for(unsigned be=0;be<2;be++){
        size_t n=(size_t)1<<logn;uint64_t total=0,diff=0,kdiff=0,maxerr=0;uint32_t lo=UINT32_MAX,hi=0;
        rng=0x13579321u^(logn<<16)^(op<<24);
        for(unsigned j=0;j<110;j++){
            prepare(logn,j&1);memcpy(a,op==0?den:input,n*sizeof *a);memcpy(b,a,n*sizeof *b);
            call(0,op,logn,a);
            unsigned irq=__get_PRIMASK();__disable_irq();uint32_t t=measure(be,op,logn);if(!irq)__enable_irq();
            if(j>=10){total+=t;if(t<lo)lo=t;if(t>hi)hi=t;for(size_t u=0;u<n;u++){
                int64_t de=(int64_t)(b[u].v-a[u].v);uint64_t er=de<0?-(uint64_t)de:(uint64_t)de;
                diff+=er!=0;kdiff+=fxr_round(a[u])!=fxr_round(b[u]);if(er>maxerr)maxerr=er;
            }}
        }
        printf("PIPELINE_KERNEL logn=%u op=%u backend=%u calls=100 total=%llu min=%u max=%u diff=%llu kdiff=%llu max_lsb=%llu\n",logn,op,be,(unsigned long long)total,lo,hi,(unsigned long long)diff,(unsigned long long)kdiff,(unsigned long long)maxerr);
    }
    for(unsigned logn=4;logn<=10;logn++)for(unsigned op=0;op<3;op++)for(unsigned cls=0;cls<8;cls++){
        uint64_t total=0;uint32_t lo=UINT32_MAX,hi=0;size_t n=(size_t)1<<logn;
        for(unsigned j=0;j<110;j++){
            prepare(logn,cls);memcpy(b,op==0?den:input,n*sizeof *b);
            unsigned irq=__get_PRIMASK();__disable_irq();uint32_t t=measure(1,op,logn);if(!irq)__enable_irq();
            if(j>=10){total+=t;if(t<lo)lo=t;if(t>hi)hi=t;}
        }
        printf("PIPELINE_TIMING logn=%u op=%u class=%u calls=100 total=%llu min=%u max=%u\n",logn,op,cls,(unsigned long long)total,lo,hi);
    }
    puts("HYBRID_KERNEL_DONE");return 0;
}
