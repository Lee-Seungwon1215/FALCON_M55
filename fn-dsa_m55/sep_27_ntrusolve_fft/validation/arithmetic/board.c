#include "kgen_ds_q32.h"
#include <cmsis_core.h>
#include <zephyr/kernel.h>
#include <stdio.h>
#include <string.h>
#include <inttypes.h>
uint64_t reference_decode(float f);
uint64_t reference_raw(float h,float l);
uint64_t reference_mul(float ah,float al,float bh,float bl);
static volatile uint64_t sink;
static uint64_t rng=UINT64_C(0x7365703237617269);
static uint64_t next(void) {
    rng^=rng>>12;rng^=rng<<25;rng^=rng>>27;
    return rng*UINT64_C(0x2545F4914F6CDD1D);
}
__attribute__((noinline)) uint64_t candidate_raw(float h,float l) {
    __asm__ volatile("" ::: "memory"); /* forbid call hoisting in timed loops */
    return qd_raw_floor((q32ds){h,l});
}
__attribute__((noinline)) uint64_t candidate_mul(float ah,float al,float bh,float bl) {
    __asm__ volatile("" ::: "memory");
    q32ds q=qd_mul((q32ds){ah,al},(q32ds){bh,bl});
    uint64_t u;memcpy(&u,&q,sizeof u);return u;
}
static uint32_t measure(unsigned op,unsigned old,q32ds a,q32ds b) {
    unsigned key=irq_lock();
    __DSB();__ISB();uint32_t start=DWT->CYCCNT;
    if(op==0) {
        if(old) for(unsigned j=0;j<128;j++) sink=reference_raw(a.h,a.l);
        else for(unsigned j=0;j<128;j++) sink=candidate_raw(a.h,a.l);
    } else {
        if(old) for(unsigned j=0;j<128;j++) sink=reference_mul(a.h,a.l,b.h,b.l);
        else for(unsigned j=0;j<128;j++) sink=candidate_mul(a.h,a.l,b.h,b.l);
    }
    __DSB();__ISB();uint32_t elapsed=DWT->CYCCNT-start;
    irq_unlock(key);return elapsed;
}
int mlk_test_main(int argc,char **argv) {
    (void)argc;(void)argv;
    __set_FPSCR(__get_FPSCR()&~0x1C00000u);
    CoreDebug->DEMCR|=CoreDebug_DEMCR_TRCENA_Msk;
    DWT->CTRL|=DWT_CTRL_CYCCNTENA_Msk;
    printf("Q32_HW cpu=%u fpscr=%08x ccr=%08x\n",SystemCoreClock,__get_FPSCR(),SCB->CCR);
    unsigned decode_count=0,raw_count=0,mul_count=0,fail=0;
    for(unsigned e=0;e<255;e++) for(unsigned j=0;j<1024;j++) {
        union {uint32_t u;float f;} f={(uint32_t)next()&0x807fffffu};
        f.u|=e<<23; f.f=__builtin_floorf(f.f);
        uint64_t a=qd_integral_bits(f.f),b=reference_decode(f.f);
        if(a!=b) {printf("Q32_FAIL decode bits=%08x\n",f.u);return 1;}
        decode_count++;
    }
    for(unsigned j=0;j<1000000;j++) {
        q32ds a=qd_from_raw((uint64_t)((int64_t)next()>>(j%33)));
        q32ds b=qd_from_raw((uint64_t)((int64_t)next()>>((j/33)%33)));
        if(candidate_raw(a.h,a.l)!=reference_raw(a.h,a.l)) {fail=1;break;}
        raw_count++;
        if(candidate_mul(a.h,a.l,b.h,b.l)!=reference_mul(a.h,a.l,b.h,b.l)) {fail=2;break;}
        mul_count++;
    }
    /* Include exact grids, signed tiny residues and boundaries. Public data
     * classes test timing; they are not a formal proof for all operands. */
    const q32ds inputs[]={{0,0},{1,0},{-1,0},{1,0x1p-32f},
        {1,-0x1p-60f},{-1,0x1p-60f},{0x1p-32f,0},
        {0x1p-60f,0},{-0x1p-60f,0},{0x1p20f,0x1p-4f},
        {0x1p30f,-0x1p-10f},{-0x1p30f,0x1p-10f},
        {3.25f,0x1p-27f},{-3.25f,-0x1p-27f}};
    for(unsigned c=0;c<sizeof inputs/sizeof *inputs;c++) {
        q32ds a=inputs[c],b={0.75f,0x1p-30f};
        if(candidate_raw(a.h,a.l)!=reference_raw(a.h,a.l)) fail=3;
        if(candidate_mul(a.h,a.l,b.h,b.l)!=reference_mul(a.h,a.l,b.h,b.l)) fail=4;
        for(unsigned op=0;op<2;op++) for(unsigned old=0;old<2;old++) {
            uint32_t min=UINT32_MAX,max=0;uint64_t total=0;
            for(unsigned r=0;r<20;r++) {
                uint32_t t=measure(op,old,a,b);
                if(t<min)min=t;if(t>max)max=t;total+=t;
            }
            printf("Q32_TIMING class=%u op=%u initial=%u calls=128 trials=20 min=%u max=%u total=%llu\n",
                c,op,old,min,max,(unsigned long long)total);
        }
    }
    printf("Q32_DONE decode=%u raw=%u mul=%u failures=%u\n",decode_count,raw_count,mul_count,fail);
    return fail!=0;
}
