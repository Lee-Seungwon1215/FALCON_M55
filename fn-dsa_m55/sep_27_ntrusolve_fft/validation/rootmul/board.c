#include "kgen_inner.h"
#include <stdio.h>
#include <string.h>
#include <zephyr/kernel.h>
#include <cmsis_core.h>
extern void fndsa_ntru_q32_rootmul4(fxr *, const fxr *);
static fxr original[8], actual[8], expected[8], roots[4], roots_copy[4];
static uint64_t state=UINT64_C(0x534550413134524d);
static volatile uint64_t sink;
static uint64_t next_word(void) {state^=state<<13;state^=state>>7;state^=state<<17;return state;}
static const uint64_t edges[]={0,1,UINT64_MAX,UINT64_C(0x8000000000000000),
    UINT64_C(0x7fffffffffffffff),UINT64_C(0x100000000),UINT64_C(0xffffffff),
    UINT64_C(0x7fffffff),UINT64_C(0x80000000),UINT64_C(0x5555555555555555),
    UINT64_C(0xaaaaaaaaaaaaaaaa),UINT64_C(0xffffffff00000000)};
static uint32_t ticks(void) {__DSB();__ISB();return DWT->CYCCNT;}
static int check(unsigned index) {
    memcpy(actual,original,sizeof actual);memcpy(expected,original,sizeof expected);
    memcpy(roots_copy,roots,sizeof roots);
    for(unsigned i=0;i<4;i++)expected[2+i]=fxr_mul(expected[2+i],roots[i]);
    fndsa_ntru_q32_rootmul4(actual+2,roots);
    if(memcmp(actual,expected,sizeof actual)||memcmp(roots,roots_copy,sizeof roots)) {
        printf("ROOTMUL_FAIL index=%u\n",index);return 0;
    }
    return 1;
}
static __attribute__((noipa)) uint32_t measure(void) {
    uint32_t sum=0;unsigned irq=irq_lock();
    for(unsigned j=0;j<32;j++) {
        memcpy(actual,original,sizeof actual);
        uint32_t t=ticks();fndsa_ntru_q32_rootmul4(actual+2,roots);
        sum+=ticks()-t;__asm__ volatile("" ::: "memory");
    }
    irq_unlock(irq);sink^=actual[2].v;return sum;
}
int mlk_test_main(int argc,char **argv) {
    (void)argc;(void)argv;CoreDebug->DEMCR|=CoreDebug_DEMCR_TRCENA_Msk;
    DWT->CTRL|=DWT_CTRL_CYCCNTENA_Msk;
    unsigned values=0;
    for(unsigned j=0;j<250256;j++) {
        for(unsigned i=0;i<8;i++)original[i].v=UINT64_C(0xa55a771122334455);
        for(unsigned i=0;i<4;i++) {
            original[2+i].v=j<256?edges[(j+i)%12]:next_word();
            uint64_t lo=j<256?(uint32_t)edges[(j/12+3*i)%12]:(uint32_t)next_word();
            uint64_t hi=(j+i)&1?UINT64_C(0xffffffff00000000):0;
            roots[i].v=hi|lo;
        }
        if(!check(j))return 1;
        values+=4;
    }
    for(unsigned cls=0;cls<32;cls++) {
        for(unsigned i=0;i<4;i++) {
            original[2+i].v=cls<12?edges[cls]:next_word();
            roots[i].v=UINT64_C(0xffffffff80000000)+(UINT64_C(0x11111111)*i);
        }
        if(!check(250256+cls))return 2;
        measure();uint32_t min=UINT32_MAX,max=0;
        for(unsigned j=0;j<20;j++) {
            uint32_t t=measure();if(t<min)min=t;if(t>max)max=t;
        }
        printf("ROOTMUL_TIMING class=%u calls=32 trials=20 min=%u max=%u\n",cls,min,max);
    }
    printf("ROOTMUL_DONE values=%u classes=32 guards=1 roots_unchanged=1 failures=0\n",values);
    return 0;
}
