#include "kgen_ds.h"
#include "kgen_ds_q32.h"
#include <stdio.h>
#include <string.h>
#include <zephyr/kernel.h>
#include <cmsis_core.h>
#include "oracle.h"
extern void fndsa_ds_encode4(const uint32_t[4],const uint32_t[4],float[4],float[4]);
extern void fndsa_ds_select4(const uint32_t *,const uint32_t[4],uint32_t[4],uint32_t[4]);
#include "oracle_b8.h"
#include "oracle_b12.h"
static uint64_t state=0x73657032376d7665ull;
static uint64_t random_word(void) { state^=state<<13;state^=state>>7;state^=state<<17;return state; }
static uint32_t high[4],low[4];
static float hi[4],lo[4],rh[4],rl[4];
static fndsa_ds_poly actual,reference;
static uint32_t big[8*1024];
static volatile uint32_t sink;
static uint32_t select_high[6],select_low[6],oracle_high[4],oracle_low[4];
/* Original scalar selection equations, before floating-point encoding. */
static __attribute__((noipa)) void oracle_select4(const uint32_t *f,const uint32_t p[4]) {
    uint32_t len=p[0],stride=p[1]/4,sch=p[2],scl=p[3];
    uint32_t t0=(sch-1)&0xffffff,t1=sch&0xffffff,t2=(sch+1)&0xffffff;
    for(unsigned i=0;i<4;i++) {
        uint32_t w0=0,w1=0,w2=0;
        for(uint32_t j=0;j<len;j++) {
            uint32_t w=f[i+j*stride],t=j&0xffffff;
            w0|=w&-(((t^t0)-1)>>31);
            w1|=w&-(((t^t1)-1)>>31);
            w2|=w&-(((t^t2)-1)>>31);
        }
        uint32_t ws=-(f[i+(len-1)*stride]>>30)>>1;
        w0|=ws&-((len-sch)>>31);
        w1|=ws&-((len-sch-1)>>31);
        w2|=ws&-((len-sch-2)>>31);
        w2|=(w2&0x40000000u)<<1;
        oracle_low[i]=(w0>>(scl-1))|(w1<<(32-scl));
        oracle_high[i]=(w1>>scl)|(w2<<(31-scl));
    }
}
static void params_init(uint32_t p[4],unsigned logn,unsigned len,unsigned sc) {
    uint32_t sch,scl;DIVREM31(sch,scl,sc);
    uint32_t z=(scl-1)>>31;sch-=z;scl|=31&-z;
    p[0]=len;p[1]=4u<<logn;p[2]=sch;p[3]=scl;
}
static int compare_selection(unsigned logn,unsigned len,unsigned sc,unsigned offset) {
    uint32_t p[4];params_init(p,logn,len,sc);
    memset(select_high,0xa5,sizeof select_high);memset(select_low,0xa5,sizeof select_low);
    fndsa_ds_select4(big+offset,p,select_high+1,select_low+1);
    oracle_select4(big+offset,p);
    if(memcmp(select_high+1,oracle_high,16)||memcmp(select_low+1,oracle_low,16)
      ||select_high[0]!=0xa5a5a5a5||select_high[5]!=0xa5a5a5a5
      ||select_low[0]!=0xa5a5a5a5||select_low[5]!=0xa5a5a5a5) {
        printf("SELECT_FAIL logn=%u len=%u sc=%u offset=%u\n",logn,len,sc,offset);return 0;
    }
    return 1;
}
static void __attribute__((noipa)) reference_encode4(void) {
    __asm__ volatile("" ::: "memory");
    for(unsigned i=0;i<4;i++) {
        q32ds a=qd_from_raw(((uint64_t)high[i]<<32)|low[i]);
        rh[i]=a.h;rl[i]=a.l;
    }
}
static uint32_t ticks(void) {__DSB();__ISB();return DWT->CYCCNT;}
static __attribute__((noinline)) uint32_t measure_select(unsigned old,const uint32_t p[4]) {
    for(unsigned j=0;j<16;j++) {
        if(old)oracle_select4(big,p);else fndsa_ds_select4(big,p,select_high+1,select_low+1);
        __asm__ volatile("" ::: "memory");
    }
    unsigned irq=irq_lock();uint32_t t=ticks();
    for(unsigned j=0;j<128;j++) {
        if(old)oracle_select4(big,p);else fndsa_ds_select4(big,p,select_high+1,select_low+1);
        __asm__ volatile("" ::: "memory");
    }
    t=ticks()-t;irq_unlock(irq);sink^=old?oracle_high[0]:select_high[1];return t;
}
static __attribute__((noinline)) uint32_t measure_full(unsigned old,unsigned logn,unsigned len,unsigned sc) {
    unsigned irq=irq_lock();uint32_t t=ticks();
    if(old)oracle_b8_from_big(logn,&actual,big,len,sc);
    else fndsa_ds_from_big(logn,&actual,big,len,sc);
    t=ticks()-t;irq_unlock(irq);
    uint32_t word;memcpy(&word,actual.re[0],4);sink^=word;return t;
}
static __attribute__((noipa)) uint32_t measure_fused(unsigned old,unsigned logn,unsigned len,unsigned sc,unsigned calls) {
    for(unsigned j=0;j<2;j++) {
        if(old)oracle_b12_from_big(logn,&actual,big,len,sc);
        else fndsa_ds_from_big(logn,&actual,big,len,sc);
    }
    unsigned irq=irq_lock();uint32_t t=ticks();
    for(unsigned j=0;j<calls;j++) {
        if(old)oracle_b12_from_big(logn,&actual,big,len,sc);
        else fndsa_ds_from_big(logn,&actual,big,len,sc);
        __asm__ volatile("" ::: "memory");
    }
    t=ticks()-t;irq_unlock(irq);
    uint32_t word;memcpy(&word,actual.re[0],4);sink^=word;return t;
}
static __attribute__((noinline)) uint32_t measure(unsigned old) {
    for(unsigned k=0;k<16;k++) {
        if(old)reference_encode4();else fndsa_ds_encode4(high,low,hi,lo);
        __asm__ volatile("" ::: "memory");
    }
    unsigned irq=irq_lock();uint32_t t=ticks();
    for(unsigned k=0;k<128;k++) {
        if(old)reference_encode4();else fndsa_ds_encode4(high,low,hi,lo);
        __asm__ volatile("" ::: "memory");
    }
    t=ticks()-t;irq_unlock(irq);return t;
}
int mlk_test_main(int argc,char **argv) {
    (void)argc;(void)argv;
    CoreDebug->DEMCR|=CoreDebug_DEMCR_TRCENA_Msk;
    DWT->CTRL|=DWT_CTRL_CYCCNTENA_Msk;
    unsigned count=0;
    for(unsigned k=0;k<250000;k++) {
        for(unsigned i=0;i<4;i++) {
            uint64_t w=random_word();high[i]=w>>32;low[i]=w;
        }
        fndsa_ds_encode4(high,low,hi,lo);reference_encode4();
        if(memcmp(hi,rh,sizeof hi)||memcmp(lo,rl,sizeof lo)) {
            printf("ENCODE_FAIL block=%u\n",k);return 1;
        }
        count+=4;
    }
    static const uint32_t edges[]={0,1,2,0x7fff,0x8000,0xffff,0x10000,
        0x7fffff,0x800000,0xffffff,0x1000000,0x7fffffff,0x80000000,
        0xffff0000,0xfffffffe,0xffffffff};
    unsigned edge_cases=0;
    for(unsigned a=0;a<sizeof edges/4;a++)for(unsigned b=0;b<sizeof edges/4;b++) {
        for(unsigned i=0;i<4;i++){high[i]=edges[(a+i)%16];low[i]=edges[b];}
        fndsa_ds_encode4(high,low,hi,lo);reference_encode4();
        if(memcmp(hi,rh,sizeof hi)||memcmp(lo,rl,sizeof lo)) {
            printf("ENCODE_FAIL edge_high=%u edge_low=%u\n",a,b);return 1;
        }
        edge_cases+=4;
    }
    unsigned cases=0;
    for(unsigned l=1;l<=10;l++) for(unsigned len=0;len<=8;len++)
      for(unsigned sc=0;sc<=len*31+33;sc+=7) {
        for(unsigned i=0;i<(len<<l);i++)big[i]=(uint32_t)random_word()&0x7fffffffu;
        memset(&actual,0xa5,sizeof actual);memset(&reference,0xa5,sizeof reference);
        fndsa_ds_from_big(l,&actual,big,len,sc);oracle_from_big(l,&reference,big,len,sc);
        if(memcmp(&actual,&reference,sizeof actual)) {
            printf("FROM_BIG_FAIL logn=%u len=%u scale=%u\n",l,len,sc);return 2;
        }
        cases++;
      }
    unsigned selected=0,full=0;
    for(unsigned i=0;i<24;i++)big[i]=(uint32_t)random_word()&0x7fffffffu;
    /* Every scale in DIVREM31's documented domain; no out-of-domain shifts. */
    for(unsigned sc=0;sc<=63487;sc++) {
        if(!compare_selection(3,3,sc,sc&3))return 3;
        selected++;
    }
    static const unsigned lengths[]={1,2,3,4,8,16,31,63,127,255,511,1023};
    for(unsigned l=3;l<=10;l++)for(unsigned u=0;u<sizeof lengths/sizeof *lengths;u++) {
        unsigned len=lengths[u];if((len<<l)>sizeof big/sizeof *big)continue;
        for(unsigned i=0;i<(len<<l);i++)big[i]=(uint32_t)random_word()&0x7fffffffu;
        for(unsigned j=0;j<64;j++) {
            unsigned sc=j<32?j:(unsigned)(random_word()%63488);
            if(!compare_selection(l,len,sc,j&3))return 3;
            selected++;
            if(j>=32&&j<36) {
                memset(&actual,0xa5,sizeof actual);memset(&reference,0xa5,sizeof reference);
                fndsa_ds_from_big(l,&actual,big,len,sc);
                oracle_b8_from_big(l,&reference,big,len,sc);
                if(memcmp(&actual,&reference,sizeof actual)) {
                    printf("SELECT_FAIL full logn=%u len=%u sc=%u\n",l,len,sc);return 4;
                }
                full++;
            }
        }
    }
    for(unsigned cls=0;cls<32;cls++) {
        unsigned sc=cls<16?cls:cls==31?63487:31*(cls-15);
        for(unsigned i=0;i<8*1024;i++)big[i]=cls==0?0:cls==1?0x7fffffffu:
            (uint32_t)random_word()&0x7fffffffu;
        uint32_t p[4];params_init(p,10,8,sc);
        for(unsigned old=0;old<2;old++) {
            uint32_t min=UINT32_MAX,max=0;
            for(unsigned j=0;j<20;j++) {
                uint32_t t=measure_select(old,p);if(t<min)min=t;if(t>max)max=t;
            }
            printf("SELECT_TIMING class=%u scale=%u old=%u calls=128 lanes=4 min=%u max=%u\n",cls,sc,old,min,max);
        }
    }
    for(unsigned l=9;l<=10;l++)for(unsigned len=1;len<=8;len*=2)
      for(unsigned old=0;old<2;old++) {
        uint32_t min=UINT32_MAX,max=0;uint64_t total=0;
        for(unsigned j=0;j<34;j++) {
            uint32_t t=measure_full(old,l,len,31*len-1);
            if(j>=2){total+=t;if(t<min)min=t;if(t>max)max=t;}
        }
        printf("FROM_BIG_TIMING logn=%u len=%u old=%u calls=32 total=%llu min=%u max=%u\n",
            l,len,old,(unsigned long long)total,min,max);
      }
    printf("SELECT_DONE cases=%u full=%u failures=0\n",selected,full);
    for(unsigned cls=0;cls<20;cls++) {
        unsigned pattern=cls>=16?cls-16:cls;
        for(unsigned i=0;i<4;i++) {
            uint64_t w=pattern==0?0:pattern==1?UINT64_MAX:random_word()>>(pattern-2);
            high[i]=w>>32;low[i]=w;
        }
        for(unsigned old=0;old<2;old++) {
            uint32_t min=UINT32_MAX,max=0;
            for(unsigned j=0;j<20;j++) {
                uint32_t t=measure(old);if(t<min)min=t;if(t>max)max=t;
            }
            uint32_t bits;memcpy(&bits,old?rh:hi,4);sink^=bits;
            printf("ENCODE_TIMING class=%u pattern=%u scalar=%u calls=128 lanes=4 min=%u max=%u fpscr=%08x\n",cls,pattern,old,min,max,(unsigned)__get_FPSCR());
        }
    }
    printf("ENCODE_EDGES values=%u failures=0\n",edge_cases);
    /* New fused boundary: exhaust scales for this designated n=8/len=3
     * input against the original scalar FP32 oracle, not shared helpers. */
    unsigned fused=0;
    for(unsigned i=0;i<24;i++)big[i]=(uint32_t)random_word()&0x7fffffffu;
    for(unsigned sc=0;sc<=63487;sc++) {
        memset(&actual,0xa5,sizeof actual);memset(&reference,0xa5,sizeof reference);
        fndsa_ds_from_big(3,&actual,big,3,sc);
        oracle_from_big(3,&reference,big,3,sc);
        if(memcmp(&actual,&reference,sizeof actual)) {
            printf("FUSED_INPUT_FAIL scale=%u\n",sc);return 5;
        }
        fused++;
    }
    for(unsigned logn=3;logn<=9;logn+=6)for(unsigned cls=0;cls<32;cls++) {
        unsigned sc=cls<16?cls:cls==31?63487:31*(cls-15);
        for(unsigned i=0;i<(8u<<logn);i++)big[i]=cls==0?0:cls==1?0x7fffffffu:
            (uint32_t)random_word()&0x7fffffffu;
        memset(&actual,0xa5,sizeof actual);memset(&reference,0xa5,sizeof reference);
        fndsa_ds_from_big(logn,&actual,big,8,sc);
        oracle_b12_from_big(logn,&reference,big,8,sc);
        if(memcmp(&actual,&reference,sizeof actual)) {
            printf("FUSED_INPUT_FAIL logn=%u class=%u\n",logn,cls);return 6;
        }
        for(unsigned old=0;old<2;old++) {
            uint32_t min=UINT32_MAX,max=0;
            for(unsigned j=0;j<20;j++) {
                uint32_t t=measure_fused(old,logn,8,sc,32);
                if(t<min)min=t;
                if(t>max)max=t;
            }
            printf("FUSED_INPUT_TIMING logn=%u class=%u scale=%u old=%u calls=32 min=%u max=%u\n",
                logn,cls,sc,old,min,max);
        }
        fused++;
    }
    printf("FUSED_INPUT_DONE cases=%u failures=0\n",fused);
    /* Sweep the complete low 16-bit field for representative high/upper
     * words, stressing cancellation, integer-rounding and half-ulp edges. */
    static const uint32_t edge_high[]={0,1,0xffffffffu,0xffff0000u,0x0000ffffu,
        0x00ffffffu,0x01000000u,0x01000001u,0xff000001u,0xff000000u,
        0xfeffffffu,0x7fffffffu,0x80000000u,0x80000001u,0x7fff8000u,0x80007fffu};
    static const uint32_t edge_upper[]={0,1,0x7fff,0x8000,0xffff};
    unsigned fastsum_edges=0;
    for(unsigned h=0;h<sizeof edge_high/sizeof *edge_high;h++)
      for(unsigned m=0;m<sizeof edge_upper/sizeof *edge_upper;m++)
        for(uint32_t x=0;x<65536;x+=4) {
            for(unsigned i=0;i<4;i++) {
                high[i]=edge_high[h];low[i]=(edge_upper[m]<<16)|(x+i);
            }
            fndsa_ds_encode4(high,low,hi,lo);reference_encode4();
            if(memcmp(hi,rh,sizeof hi)||memcmp(lo,rl,sizeof lo)) {
                printf("FASTSUM_FAIL high=%08x upper=%u low=%u\n",edge_high[h],edge_upper[m],x);
                return 7;
            }
            fastsum_edges+=4;
        }
    printf("FASTSUM_EDGES values=%u failures=0\n",fastsum_edges);
    printf("ENCODE_DONE words=%u from_big=%u failures=0\n",count,cases);return 0;
}
