/* Actual production NTRU FFT entry points versus unchanged fixed kernels. */
#include "kgen_inner.h"
#include <stdio.h>
#include <string.h>
#include <zephyr/kernel.h>
#include <cmsis_core.h>
static fxr input[1028],actual[1028],expected[1028];
static uint64_t state=UINT64_C(0x5345503237494e54);
static volatile uint64_t sink;
static uint64_t next_word(void) {
    state^=state<<13;state^=state>>7;state^=state<<17;return state;
}
static const uint64_t edges[]={0,1,UINT64_MAX,UINT64_C(0x8000000000000000),
    UINT64_C(0x7fffffffffffffff),UINT64_C(0x100000000),UINT64_C(0xffffffff),
    UINT64_C(0x7fffffff),UINT64_C(0x80000000),UINT64_C(0x5555555555555555),
    UINT64_C(0xaaaaaaaaaaaaaaaa),UINT64_C(0xffffffff00000000)};
static uint32_t ticks(void) {__DSB();__ISB();return DWT->CYCCNT;}
static __attribute__((noipa)) uint32_t measure(unsigned old,unsigned inverse,
    unsigned logn,unsigned offset) {
    memcpy(actual,input,sizeof input);
    unsigned irq=irq_lock();uint32_t start=ticks();
    if(old) {
        if(inverse)vect_iFFT_fixed(logn,actual+offset);else vect_FFT_fixed(logn,actual+offset);
    } else {
        if(inverse)vect_iFFT_ntru(logn,actual+offset);else vect_FFT_ntru(logn,actual+offset);
    }
    uint32_t elapsed=ticks()-start;irq_unlock(irq);sink^=actual[offset].v;return elapsed;
}
int mlk_test_main(int argc,char **argv) {
    (void)argc;(void)argv;CoreDebug->DEMCR|=CoreDebug_DEMCR_TRCENA_Msk;
    DWT->CTRL|=DWT_CTRL_CYCCNTENA_Msk;
    unsigned cases=0;
    for(unsigned logn=1;logn<=10;logn++)for(unsigned inverse=0;inverse<2;inverse++) {
        uint32_t old_min=UINT32_MAX,old_max=0,new_min=UINT32_MAX,new_max=0;
        for(unsigned cls=0;cls<256;cls++) {
            unsigned off=(cls>>4)&3;
            for(unsigned i=0;i<1028;i++)input[i].v=UINT64_C(0xa55a771122334455);
            for(unsigned i=off;i<off+(1u<<logn);i++)input[i].v=cls<12?edges[(cls+i)%12]:next_word();
            memcpy(expected,input,sizeof input);
            if(inverse)vect_iFFT_fixed(logn,expected+off);else vect_FFT_fixed(logn,expected+off);
            for(unsigned trial=0;trial<(cls<16?20:1);trial++) {
                uint32_t t=measure(0,inverse,logn,off);
                if(memcmp(actual,expected,sizeof actual)) {
                    printf("FIXED_FFT_FAIL logn=%u inverse=%u class=%u offset=%u\n",logn,inverse,cls,off);
                    return 1;
                }
                if(cls<16) {
                    if(t<new_min)new_min=t;if(t>new_max)new_max=t;
                    t=measure(1,inverse,logn,off);
                    if(t<old_min)old_min=t;if(t>old_max)old_max=t;
                }
            }
            cases++;
        }
        printf("FIXED_FFT logn=%u inverse=%u fixed_min=%u fixed_max=%u current_min=%u current_max=%u\n",
            logn,inverse,old_min,old_max,new_min,new_max);
    }
    printf("FIXED_FFT_DONE cases=%u failures=0\n",cases);return 0;
}
