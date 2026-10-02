#include "kgen_inner.h"
#include <stdio.h>
#include <string.h>
#include <zephyr/kernel.h>
#include <cmsis_core.h>
typedef void (*fft_fn)(unsigned,fxr *);
extern void trial_stack_call(unsigned,fxr *,fft_fn,unsigned);
volatile uint32_t trial_entry_sp;
_Alignas(32) static fxr input[1032],actual[1032],expected[1032];
static uint64_t state;
static volatile uint64_t sink;
static uint64_t next_word(void) {state^=state<<13;state^=state>>7;state^=state<<17;return state;}
static uint32_t ticks(void) {__DSB();__ISB();return DWT->CYCCNT;}
static const uint64_t edges[]={0,1,UINT64_MAX,UINT64_C(0x8000000000000000),
    UINT64_C(0x7fffffffffffffff),UINT64_C(0x100000000),UINT64_C(0xffffffff),
    UINT64_C(0x7fffffff),UINT64_C(0x80000000),UINT64_C(0x5555555555555555),
    UINT64_C(0xaaaaaaaaaaaaaaaa),UINT64_C(0xffffffff00000000)};
static __attribute__((noipa)) uint32_t measure(fft_fn fn,unsigned logn,unsigned off,unsigned pad) {
    memcpy(actual,input,sizeof input);
    unsigned irq=irq_lock();uint32_t t=ticks();
    trial_stack_call(logn,actual+off,fn,pad);
    t=ticks()-t;irq_unlock(irq);sink^=actual[off].v;return t;
}
int mlk_test_main(int argc,char **argv) {
    (void)argc;(void)argv;CoreDebug->DEMCR|=CoreDebug_DEMCR_TRCENA_Msk;
    DWT->CTRL|=DWT_CTRL_CYCCNTENA_Msk;
    unsigned cases=0;
    for(unsigned logn=7;logn<=10;logn++)for(unsigned inverse=0;inverse<2;inverse++)
      for(unsigned off=0;off<4;off++)for(unsigned pad=0;pad<32;pad+=8) {
        uint32_t old_min=UINT32_MAX,old_max=0,new_min=UINT32_MAX,new_max=0,entry=0;
        state=UINT64_C(0x5345503237414c49)^((uint64_t)logn<<8)^inverse;
        fft_fn old=inverse?vect_iFFT_fixed:vect_FFT_fixed;
        fft_fn current=inverse?vect_iFFT_ntru:vect_FFT_ntru;
        for(unsigned cls=0;cls<16;cls++) {
            for(unsigned i=0;i<1032;i++)input[i].v=UINT64_C(0xa55a771122334455);
            for(unsigned i=0;i<(1u<<logn);i++)input[off+i].v=cls<12?edges[(cls+i)%12]:next_word();
            memcpy(expected,input,sizeof input);old(logn,expected+off);
            for(unsigned j=0;j<20;j++) {
                uint32_t t=measure(old,logn,off,pad);
                if(t<old_min)old_min=t;if(t>old_max)old_max=t;
                t=measure(current,logn,off,pad);entry=trial_entry_sp;
                if(t<new_min)new_min=t;if(t>new_max)new_max=t;
                if(memcmp(expected,actual,sizeof actual)) {
                    printf("ALIGN_FFT_FAIL logn=%u inverse=%u offset=%u pad=%u class=%u\n",
                        logn,inverse,off,pad,cls);return 1;
                }
            }
            cases++;
        }
        printf("ALIGN_FFT logn=%u inverse=%u data_mod32=%u sp_mod32=%u pad=%u fixed_min=%u fixed_max=%u current_min=%u current_max=%u\n",
            logn,inverse,(unsigned)((uintptr_t)(actual+off)&31),entry&31,pad,
            old_min,old_max,new_min,new_max);
    }
    printf("ALIGN_FFT_DONE cases=%u failures=0\n",cases);return 0;
}
