#include "kgen_inner.h"
#include <stdio.h>
#include <string.h>
#include <zephyr/kernel.h>
#include <cmsis_core.h>
#include "oracle.h"

extern void trial_fixed_input_predicate(fxr *,const uint32_t *,const uint32_t [4]);
static uint32_t input[8192+4] __attribute__((aligned(16)));
static fxr actual[1024+4],expected[1024+4],incumbent[1024+4];
static uint64_t state=UINT64_C(0x7365703237613132);
static volatile uint32_t sink;
static uint64_t random_word(void) {state^=state<<13;state^=state>>7;state^=state<<17;return state;}
static uint32_t ticks(void) {__DSB();__ISB();return DWT->CYCCNT;}
static __attribute__((noipa)) void trial(unsigned logn,fxr *d,const uint32_t *f,unsigned len,unsigned sc) {
    if(logn<2) {poly_big_to_fixed(logn,d,f,len,sc);return;}
    if(!len) {memset(d,0,(1u<<logn)*sizeof *d);return;}
    uint32_t sch,scl;DIVREM31(sch,scl,sc);
    uint32_t z=(scl-1)>>31;sch-=z;scl|=31&-z;
    const uint32_t params[4]={1u<<logn,len,sch,scl};
    trial_fixed_input_predicate(d,f,params);
}
static int compare(unsigned logn,unsigned len,unsigned sc,unsigned offset) {
    size_t bytes=((1u<<logn)+4)*sizeof *actual;
    memset(actual,0xa5,bytes);memset(expected,0xa5,bytes);memset(incumbent,0xa5,bytes);
    const uint32_t *src=len?input+offset:NULL;
    trial(logn,actual+2,src,len,sc);
    poly_big_to_fixed(logn,incumbent+2,src,len,sc);
    oracle_fixed_input(logn,expected+2,src,len,sc);
    if(memcmp(actual,expected,bytes)||memcmp(incumbent,expected,bytes)) {
        for(unsigned i=0;i<(1u<<logn)+4;i++)if(actual[i].v!=expected[i].v||incumbent[i].v!=expected[i].v) {
            printf("PRED_INPUT_FAIL logn=%u len=%u sc=%u offset=%u slot=%u got=%016llx incumbent=%016llx want=%016llx\n",
                logn,len,sc,offset,i,(unsigned long long)actual[i].v,
                (unsigned long long)incumbent[i].v,(unsigned long long)expected[i].v);break;
        }
        return 0;
    }
    return 1;
}
static __attribute__((noipa)) uint32_t measure(unsigned kind,unsigned logn,unsigned len,unsigned sc,unsigned calls) {
    unsigned irq=irq_lock();uint32_t t=ticks();
    for(unsigned j=0;j<calls;j++) {
        if(kind==0)oracle_fixed_input(logn,actual+2,input,len,sc);
        else if(kind==1)poly_big_to_fixed(logn,actual+2,input,len,sc);
        else trial(logn,actual+2,input,len,sc);
        __asm__ volatile("" ::: "memory");
    }
    t=ticks()-t;irq_unlock(irq);sink^=(uint32_t)actual[2].v;return t;
}
int mlk_test_main(int argc,char **argv) {
    (void)argc;(void)argv;
    CoreDebug->DEMCR|=CoreDebug_DEMCR_TRCENA_Msk;DWT->CTRL|=DWT_CTRL_CYCCNTENA_Msk;
    unsigned cases=0;
    for(unsigned logn=0;logn<=2;logn++) {
        for(unsigned i=0;i<(3u<<logn)+4;i++)input[i]=(uint32_t)random_word()&0x7fffffffu;
        for(unsigned sc=0;sc<=63487;sc++) {
            if(!compare(logn,3,sc,sc&3))return 1;
            cases++;
        }
    }
    static const unsigned lengths[]={0,1,2,3,4,8,16,31,63,127,255,511,1023,2047};
    for(unsigned logn=0;logn<=10;logn++)
      for(unsigned u=0;u<sizeof lengths/sizeof *lengths;u++) {
        unsigned len=lengths[u];if((len<<logn)>8192)continue;
        for(unsigned pattern=0;pattern<8;pattern++) {
            for(unsigned i=0;i<(len<<logn)+4;i++)input[i]=pattern==0?0:
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
                if(!compare(logn,len,sc,j&3))return 2;
                cases++;
            }
        }
      }
    for(unsigned group=0;group<2;group++) {
        unsigned logn=group?9:2,len=group?8:32;
        for(unsigned cls=0;cls<32;cls++) {
            unsigned sc=cls<16?cls:cls==31?63487:31*(cls-15);
            for(unsigned i=0;i<(len<<logn);i++)input[i]=cls==0?0:cls==1?0x7fffffffu:
                (uint32_t)random_word()&0x7fffffffu;
            for(unsigned kind=0;kind<3;kind++) {
                uint32_t min=UINT32_MAX,max=0;
                for(unsigned j=0;j<20;j++) {
                    uint32_t t=measure(kind,logn,len,sc,32);if(t<min)min=t;if(t>max)max=t;
                }
                printf("PRED_INPUT_CT class=%u scale=%u kind=%u calls=32 logn=%u len=%u min=%u max=%u\n",
                    cls,sc,kind,logn,len,min,max);
            }
        }
    }
    static const unsigned sizes[]={2,3,4,9,10},timed_lengths[]={1,4,8,32,128,512,2047};
    for(unsigned l=0;l<sizeof sizes/sizeof *sizes;l++)
      for(unsigned u=0;u<sizeof timed_lengths/sizeof *timed_lengths;u++) {
        unsigned logn=sizes[l],len=timed_lengths[u];if((len<<logn)>8192)continue;
        for(unsigned i=0;i<(len<<logn);i++)input[i]=(uint32_t)random_word()&0x7fffffffu;
        for(unsigned kind=0;kind<3;kind++) {
            uint32_t min=UINT32_MAX,max=0;uint64_t total=0;
            for(unsigned j=0;j<32;j++) {
                uint32_t t=measure(kind,logn,len,31*len-1,1);
                total+=t;if(t<min)min=t;if(t>max)max=t;
            }
            printf("PRED_INPUT_TIMING logn=%u len=%u kind=%u calls=32 total=%llu min=%u max=%u\n",
                logn,len,kind,(unsigned long long)total,min,max);
        }
      }
    printf("PRED_INPUT_DONE cases=%u failures=0\n",cases);return 0;
}
