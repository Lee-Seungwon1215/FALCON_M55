/* Paired kernel experiment, not a production backend selector.
 * Fixed and candidate receive identical bounded Q32 arrays. Both fixed
 * functions here are this candidate's unchanged original fixed routines.
 * Packing, actual FFT, and unpacking are separately timed; inclusive cycles
 * include all three. Finite numerical differences are reported, not hidden.
 */
#include <stdio.h>
#include <string.h>
#include <zephyr/kernel.h>
#include <cmsis_core.h>
#include "kgen_inner.h"

static fxr input[1024], fixed[1024], actual[1024];
static volatile uint64_t sink;
static uint32_t rng = 0x749feb31;
static uint32_t next_word(void) {
    rng ^= rng << 13; rng ^= rng >> 17; rng ^= rng << 5; return rng;
}
static uint32_t ticks(void) { __DSB(); __ISB(); return DWT->CYCCNT; }
static void pack(unsigned logn, const fxr *a);
static void transform(unsigned logn, unsigned inverse);
static void unpack(unsigned logn, fxr *a);

static int kernel_main(void) {
    CoreDebug->DEMCR |= CoreDebug_DEMCR_TRCENA_Msk;
    DWT->CTRL |= DWT_CTRL_CYCCNTENA_Msk;
    uint32_t probe=ticks();
    for(volatile unsigned i=0;i<128;i++) __NOP();
    if(ticks()==probe) { puts("KERNEL_TIMER_FAIL");return 1; }
    unsigned checks=0;
    for (unsigned logn=1;logn<=10;logn++) for(unsigned inv=0;inv<2;inv++) {
        size_t n=(size_t)1<<logn;
        uint64_t fixed_sum=0,pack_sum=0,run_sum=0,unpack_sum=0;
        uint64_t max_error=0,different=0,round_diff=0;
        uint32_t lo=UINT32_MAX,hi=0;
        memset(input,0,n*sizeof(fxr));
        for(unsigned warm=0;warm<2;warm++) {
            memcpy(fixed,input,n*sizeof(fxr));
            if(inv)vect_iFFT(logn,fixed);else vect_FFT(logn,fixed);
            pack(logn,input);transform(logn,inv);unpack(logn,actual);
        }
        for(unsigned trial=0;trial<32;trial++) {
            for(size_t i=0;i<n;i++) {
                int64_t v=(int32_t)(next_word()&65535)-32768;
                if(trial==0)v=0;
                if(trial==1)v=(i&1)?1:-1;
                input[i].v=(uint64_t)v<<24;
            }
            memcpy(fixed,input,n*sizeof(fxr));
            unsigned irq=__get_PRIMASK(); __disable_irq();
            uint32_t t0=ticks();
            if(inv)vect_iFFT(logn,fixed);else vect_FFT(logn,fixed);
            uint32_t t1=ticks(); pack(logn,input); uint32_t t2=ticks();
            transform(logn,inv); uint32_t t3=ticks();
            unpack(logn,actual); uint32_t t4=ticks();
            __set_PRIMASK(irq);
            fixed_sum+=(uint32_t)(t1-t0);pack_sum+=(uint32_t)(t2-t1);
            run_sum+=(uint32_t)(t3-t2);unpack_sum+=(uint32_t)(t4-t3);
            uint32_t run=t3-t2;if(run<lo)lo=run;if(run>hi)hi=run;
            for(size_t i=0;i<n;i++) {
                uint64_t d=actual[i].v-fixed[i].v;
                if(d>>63)d=0-d;
                if(d>max_error)max_error=d;
                different+=d!=0;
                round_diff+=fxr_round(actual[i])!=fxr_round(fixed[i]);
                sink^=actual[i].v;
            }
            checks++;
        }
        printf("KERNEL logn=%u inverse=%u calls=32 fixed=%llu pack=%llu run=%llu unpack=%llu native_min=%u native_max=%u max_error_raw=%llu different=%llu rounded_different=%llu\n",
            logn,inv,(unsigned long long)fixed_sum,(unsigned long long)pack_sum,
            (unsigned long long)run_sum,(unsigned long long)unpack_sum,lo,hi,
            (unsigned long long)max_error,(unsigned long long)different,
            (unsigned long long)round_diff);
    }
    printf("KERNEL_DONE checks=%u\n",checks); return checks!=640;
}
