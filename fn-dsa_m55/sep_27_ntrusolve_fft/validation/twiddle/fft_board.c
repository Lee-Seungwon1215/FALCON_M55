#include "kgen_inner.h"
#include <stdio.h>
#include <string.h>
#include <zephyr/kernel.h>
#include <cmsis_core.h>
extern void trial_fixed_forward(unsigned,fxr *,unsigned,unsigned);
extern void trial_fixed_inverse(unsigned,fxr *,unsigned,unsigned);
extern void trial_vector_forward(unsigned,fxr *,unsigned,unsigned);
extern void trial_vector_inverse(unsigned,fxr *,unsigned,unsigned);
static fxr input[1026],actual[1026],expected[1026];
static uint64_t state=UINT64_C(0x5345503237545746);
static volatile uint64_t sink;
static uint64_t next_word(void) {
    state^=state<<13;state^=state>>7;state^=state<<17;return state;
}
static const uint64_t edges[]={0,1,UINT64_MAX,UINT64_C(0x8000000000000000),
    UINT64_C(0x7fffffffffffffff),UINT64_C(0x100000000),UINT64_C(0xffffffff),
    UINT64_C(0x7fffffff),UINT64_C(0x80000000),UINT64_C(0x5555555555555555),
    UINT64_C(0xaaaaaaaaaaaaaaaa),UINT64_C(0xffffffff00000000)};
static uint32_t ticks(void) {__DSB();__ISB();return DWT->CYCCNT;}
static __attribute__((noipa)) uint32_t measure(unsigned original,unsigned inverse,
    unsigned logn,unsigned batch,unsigned cutoff) {
    memcpy(actual,input,sizeof input);
    unsigned irq=irq_lock();uint32_t start=ticks();
    if(original==1) {
        if(inverse)vect_iFFT_fixed(logn,actual+1);else vect_FFT_fixed(logn,actual+1);
    } else if(original==0) {
        if(inverse)trial_fixed_inverse(logn,actual+1,batch,cutoff);
        else trial_fixed_forward(logn,actual+1,batch,cutoff);
    } else {
        if(inverse)trial_vector_inverse(logn,actual+1,batch,cutoff);
        else trial_vector_forward(logn,actual+1,batch,cutoff);
    }
    uint32_t elapsed=ticks()-start;irq_unlock(irq);sink^=actual[1].v;return elapsed;
}
int mlk_test_main(int argc,char **argv) {
    (void)argc;(void)argv;CoreDebug->DEMCR|=CoreDebug_DEMCR_TRCENA_Msk;
    DWT->CTRL|=DWT_CTRL_CYCCNTENA_Msk;
    unsigned cases=0;
    for(unsigned backend=0;backend<2;backend++)
      for(unsigned logn=1;logn<=10;logn++)for(unsigned inverse=0;inverse<2;inverse++) {
        for(unsigned batch=32;batch<=128;batch<<=1)for(unsigned cutoff=4;cutoff<=16;cutoff<<=1) {
            uint32_t old_min=UINT32_MAX,old_max=0,new_min=UINT32_MAX,new_max=0;
            for(unsigned cls=0;cls<16;cls++) {
                for(unsigned i=0;i<1026;i++)input[i].v=UINT64_C(0xa55a771122334455);
                for(unsigned i=1;i<=(1u<<logn);i++)input[i].v=cls<12?edges[(cls+i)%12]:next_word();
                memcpy(expected,input,sizeof input);
                if(inverse)vect_iFFT_fixed(logn,expected+1);else vect_FFT_fixed(logn,expected+1);
                for(unsigned trial=0;trial<5;trial++) {
                    uint32_t t=measure(1,inverse,logn,batch,cutoff);
                    if(t<old_min)old_min=t;if(t>old_max)old_max=t;
                    t=measure(backend?2:0,inverse,logn,batch,cutoff);
                    if(t<new_min)new_min=t;if(t>new_max)new_max=t;
                    if(memcmp(actual,expected,sizeof actual)) {
                        printf("TWFFT_FAIL backend=%u logn=%u inverse=%u batch=%u cutoff=%u class=%u\n",
                            backend,logn,inverse,batch,cutoff,cls);return 1;
                    }
                }
                cases++;
            }
            printf("TWFFT logn=%u inverse=%u backend=%u batch=%u cutoff=%u fixed_min=%u fixed_max=%u trial_min=%u trial_max=%u\n",
                logn,inverse,backend,batch,cutoff,old_min,old_max,new_min,new_max);
        }
    }
    printf("TWFFT_DONE cases=%u failures=0\n",cases);return 0;
}
