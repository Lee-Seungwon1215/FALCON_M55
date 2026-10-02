#include "kgen_inner.h"
#include <stdio.h>
#include <string.h>
#include <zephyr/kernel.h>
#include <cmsis_core.h>
#include "table.h"

extern void trial_mve_q32_twiddle(const uint64_t *,uint64_t *,unsigned,const uint64_t *);
static uint64_t input[520],actual[520],expected[520],alias[520];
static uint64_t state=UINT64_C(0x5345503237545744);
static volatile uint64_t sink;
static const uint64_t guard=UINT64_C(0xa55a771122334455);
static const uint64_t edges[]={0,1,UINT64_MAX,UINT64_C(0x8000000000000000),
    UINT64_C(0x7fffffffffffffff),UINT64_C(0x100000000),UINT64_C(0xffffffff),
    UINT64_C(0x7fffffff),UINT64_C(0x80000000),UINT64_C(0x5555555555555555),
    UINT64_C(0xaaaaaaaaaaaaaaaa),UINT64_C(0xffffffff00000000)};
static uint64_t next_word(void) {
    state^=state<<13;state^=state>>7;state^=state<<17;return state;
}
static __attribute__((noipa)) void reference(const uint64_t *x,uint64_t *d,
    unsigned n,const uint64_t *tw) {
    fxr s={*tw};
    for(unsigned i=0;i<n;i++)d[i]=fxr_mul((fxr){x[i]},s).v;
}
static int compare(unsigned n,unsigned offset,uint64_t tw,unsigned index) {
    int32_t h=(int32_t)(tw>>32);
    if(h < -2 || h > 1) {printf("TWIDDLE_FAIL domain index=%u\n",index);return 0;}
    for(unsigned i=0;i<520;i++)actual[i]=expected[i]=guard;
    reference(input+offset,expected+offset,n,&tw);
    trial_mve_q32_twiddle(input+offset,actual+offset,n,&tw);
    if(memcmp(actual,expected,sizeof actual)) {
        for(unsigned i=0;i<n;i++)if(actual[offset+i]!=expected[offset+i]) {
            printf("TWIDDLE_FAIL index=%u n=%u offset=%u lane=%u x=%08x%08x tw=%08x%08x got=%08x%08x ref=%08x%08x\n",
                index,n,offset,i,(unsigned)(input[offset+i]>>32),(unsigned)input[offset+i],
                (unsigned)(tw>>32),(unsigned)tw,(unsigned)(actual[offset+i]>>32),
                (unsigned)actual[offset+i],(unsigned)(expected[offset+i]>>32),(unsigned)expected[offset+i]);
            break;
        }
        return 0;
    }
    return 1;
}
static uint32_t ticks(void) {__DSB();__ISB();return DWT->CYCCNT;}
typedef void (*multiply_fn)(const uint64_t *,uint64_t *,unsigned,const uint64_t *);
static __attribute__((noipa)) uint32_t measure(unsigned scalar,unsigned n,
    unsigned calls,const uint64_t *tw) {
    multiply_fn fn=scalar?reference:trial_mve_q32_twiddle;
    for(unsigned i=0;i<4;i++)fn(input,actual,n,tw);
    unsigned irq=irq_lock();uint32_t start=ticks();
    for(unsigned i=0;i<calls;i++) {
        fn(input,actual,n,tw);__asm__ volatile("" ::: "memory");
    }
    uint32_t elapsed=ticks()-start;irq_unlock(irq);sink^=actual[0];return elapsed;
}
int mlk_test_main(int argc,char **argv) {
    (void)argc;(void)argv;CoreDebug->DEMCR|=CoreDebug_DEMCR_TRCENA_Msk;
    DWT->CTRL|=DWT_CTRL_CYCCNTENA_Msk;
    unsigned values=0,table_cases=0,alias_cases=0;
    for(unsigned lm=1;lm<10;lm++) {
        unsigned m=1u<<lm;
        for(unsigned j=m;j<m+m/2;j++) {
            uint64_t re=original_twiddles[j][0],im=original_twiddles[j][1];
            uint64_t tws[]={re,im,re+im,re,-im,re-im};
            for(unsigned k=0;k<6;k++)for(unsigned cls=0;cls<16;cls++) {
                unsigned off=cls&3;
                for(unsigned i=0;i<8;i++)input[i]=cls<12?edges[(cls+i)%12]:next_word();
                if(!compare(4,off,tws[k],table_cases))return 1;
                values+=4;table_cases++;
            }
        }
    }
    for(unsigned j=0;j<250000;j++) {
        unsigned off=j&3;
        for(unsigned i=0;i<8;i++)input[i]=next_word();
        uint64_t tw=(uint64_t)(uint32_t)((int)(j&3)-2)<<32|(uint32_t)next_word();
        if(!compare(4,off,tw,j))return 2;
        values+=4;
    }
    for(unsigned lg=2;lg<=9;lg++)for(unsigned cls=0;cls<32;cls++) {
        unsigned n=1u<<lg,off=cls&3;
        for(unsigned i=0;i<520;i++)input[i]=cls<12?edges[(cls+i)%12]:next_word();
        uint64_t tw=(uint64_t)(uint32_t)((int)(cls&3)-2)<<32|(uint32_t)next_word();
        if(!compare(n,off,tw,32*lg+cls))return 3;
        values+=n;memcpy(alias,input,sizeof input);
        trial_mve_q32_twiddle(alias+off,alias+off,n,&tw);
        for(unsigned i=0;i<520;i++) {
            uint64_t want=i>=off&&i<off+n?expected[i]:input[i];
            if(alias[i]!=want) {printf("TWIDDLE_FAIL alias n=%u cls=%u\n",n,cls);return 4;}
        }
        alias_cases++;
    }
    for(unsigned size=0;size<2;size++)for(unsigned kind=0;kind<8;kind++) {
        unsigned n=size?512:4,calls=size?16:128;
        uint64_t tw=(uint64_t)(uint32_t)((int)(kind/2)-2)<<32
            |(kind&1?UINT64_C(0xd2345679):UINT64_C(0x34567891));
        for(unsigned cls=0;cls<16;cls++) {
            for(unsigned i=0;i<n;i++)input[i]=cls<12?edges[(cls+i)%12]:next_word();
            for(unsigned scalar=0;scalar<2;scalar++) {
                uint32_t min=UINT32_MAX,max=0;
                for(unsigned trial=0;trial<20;trial++) {
                    uint32_t t=measure(scalar,n,calls,&tw);
                    if(t<min)min=t;if(t>max)max=t;
                }
                printf("TWIDDLE_TIMING n=%u kind=%u class=%u scalar=%u calls=%u min=%u max=%u\n",
                    n,kind,cls,scalar,calls,min,max);
            }
        }
    }
    printf("TWIDDLE_DONE values=%u table_cases=%u alias=%u failures=0\n",values,table_cases,alias_cases);
    return 0;
}
