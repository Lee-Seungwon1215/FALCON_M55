#include "kgen_inner.h"
#include <stdio.h>
#include <string.h>
#include <zephyr/kernel.h>
#include <cmsis_core.h>
#include "oracle.h"

extern void trial_fixed_input_pair2(fxr *,const uint32_t *,const uint32_t [4]);
static uint32_t input[8192+8] __attribute__((aligned(16)));
static fxr actual[6],expected[6],incumbent[6];
static uint64_t state=UINT64_C(0x7365703237613131);
static volatile uint32_t sink;
static uint64_t random_word(void) {
    state^=state<<13;state^=state>>7;state^=state<<17;return state;
}
static uint32_t ticks(void) {__DSB();__ISB();return DWT->CYCCNT;}
static __attribute__((noipa)) void trial(fxr *d,const uint32_t *f,unsigned len,unsigned sc) {
    if(!len) {memset(d,0,2*sizeof *d);return;}
    uint32_t sch,scl;DIVREM31(sch,scl,sc);
    uint32_t z=(scl-1)>>31;sch-=z;scl|=31&-z;
    const uint32_t params[4]={2,len,sch,scl};
    trial_fixed_input_pair2(d,f,params);
}
static int compare(unsigned len,unsigned sc,unsigned offset) {
    memset(actual,0xa5,sizeof actual);memset(expected,0xa5,sizeof expected);
    memset(incumbent,0xa5,sizeof incumbent);
    const uint32_t *src=len?input+offset:NULL;
    trial(actual+2,src,len,sc);
    oracle_fixed_input(1,expected+2,src,len,sc);
    poly_big_to_fixed(1,incumbent+2,src,len,sc);
    if(memcmp(actual,expected,sizeof actual)||memcmp(incumbent,expected,sizeof actual)) {
        for(unsigned i=0;i<6;i++)if(actual[i].v!=expected[i].v||incumbent[i].v!=expected[i].v) {
            printf("PAIR_INPUT_FAIL len=%u sc=%u offset=%u slot=%u got=%016llx incumbent=%016llx want=%016llx\n",
                len,sc,offset,i,(unsigned long long)actual[i].v,
                (unsigned long long)incumbent[i].v,(unsigned long long)expected[i].v);break;
        }
        return 0;
    }
    return 1;
}
static __attribute__((noipa)) uint32_t measure(unsigned kind,unsigned len,unsigned sc,unsigned calls) {
    unsigned irq=irq_lock();uint32_t t=ticks();
    for(unsigned j=0;j<calls;j++) {
        if(kind==0)oracle_fixed_input(1,actual+2,input,len,sc);
        else if(kind==1)poly_big_to_fixed(1,actual+2,input,len,sc);
        else trial(actual+2,input,len,sc);
        __asm__ volatile("" ::: "memory");
    }
    t=ticks()-t;irq_unlock(irq);sink^=(uint32_t)actual[2].v;return t;
}
int mlk_test_main(int argc,char **argv) {
    (void)argc;(void)argv;
    CoreDebug->DEMCR|=CoreDebug_DEMCR_TRCENA_Msk;DWT->CTRL|=DWT_CTRL_CYCCNTENA_Msk;
    unsigned cases=0;
    for(unsigned i=0;i<10;i++)input[i]=(uint32_t)random_word()&0x7fffffffu;
    for(unsigned sc=0;sc<=63487;sc++) {
        if(!compare(3,sc,sc&3))return 1;
        cases++;
    }
    static const unsigned lengths[]={0,1,2,3,4,5,8,15,16,31,32,63,64,127,128,255,511,1023,2047,4095};
    for(unsigned u=0;u<sizeof lengths/sizeof *lengths;u++) {
        unsigned len=lengths[u];
        for(unsigned pattern=0;pattern<8;pattern++) {
            for(unsigned i=0;i<2*len+4;i++)input[i]=pattern==0?0:
                pattern==1?0x7fffffffu:pattern==2?0x40000000u:
                pattern==3?(i&1?0x40000000u:1u):(uint32_t)random_word()&0x7fffffffu;
            for(unsigned j=0;j<32;j++) {
                unsigned sc;
                switch(j) {
                case 0:sc=0;break;case 1:sc=1;break;case 2:sc=30;break;
                case 3:sc=31;break;case 4:sc=32;break;case 5:sc=63487;break;
                case 6:sc=len?31*len-1:0;break;case 7:sc=31*len;break;
                case 8:sc=31*len+1;break;default:sc=random_word()%63488;break;
                }
                if(sc>63487)sc=63487; /* DIVREM31's documented domain. */
                if(!compare(len,sc,j&3))return 2;
                cases++;
            }
        }
    }
    for(unsigned cls=0;cls<32;cls++) {
        unsigned sc=cls<16?cls:cls==31?63487:31*(cls-15);
        for(unsigned i=0;i<64;i++)input[i]=cls==0?0:cls==1?0x7fffffffu:
            (uint32_t)random_word()&0x7fffffffu;
        for(unsigned kind=0;kind<3;kind++) {
            uint32_t min=UINT32_MAX,max=0;
            for(unsigned j=0;j<20;j++) {
                uint32_t t=measure(kind,32,sc,128);if(t<min)min=t;if(t>max)max=t;
            }
            printf("PAIR_INPUT_CT class=%u scale=%u kind=%u calls=128 len=32 min=%u max=%u\n",cls,sc,kind,min,max);
        }
    }
    static const unsigned timed_lengths[]={1,2,3,4,8,16,32,64,128,512,2047};
    for(unsigned u=0;u<sizeof timed_lengths/sizeof *timed_lengths;u++) {
        unsigned len=timed_lengths[u];
        for(unsigned i=0;i<2*len;i++)input[i]=(uint32_t)random_word()&0x7fffffffu;
        for(unsigned kind=0;kind<3;kind++) {
            uint32_t min=UINT32_MAX,max=0;uint64_t total=0;
            for(unsigned j=0;j<32;j++) {
                uint32_t t=measure(kind,len,31*len-1,1);
                total+=t;if(t<min)min=t;if(t>max)max=t;
            }
            printf("PAIR_INPUT_TIMING len=%u kind=%u calls=32 total=%llu min=%u max=%u\n",
                len,kind,(unsigned long long)total,min,max);
        }
    }
    printf("PAIR_INPUT_DONE cases=%u failures=0\n",cases);return 0;
}
