#include "kgen_inner.h"
#include <stdio.h>
#include <string.h>
#include <zephyr/kernel.h>
#include <cmsis_core.h>

extern void fndsa_ds_div4(uint32_t[4],uint32_t[4],const uint32_t[4],const uint32_t[4]);
static uint32_t nh[8],nl[8],dh[8],dl[8],oh[8],ol[8];
static uint64_t x[4],y[4],state=UINT64_C(0x7365703237646976);
static volatile uint32_t sink;
static uint64_t rnd(void) {state^=state<<13;state^=state>>7;state^=state<<17;return state;}
static uint32_t ticks(void) {__DSB();__ISB();return DWT->CYCCNT;}
static void init(unsigned off) {
    for(unsigned i=0;i<8;i++)nh[i]=nl[i]=dh[i]=dl[i]=0xa5a5a5a5u;
    for(unsigned i=0;i<4;i++) {
        nh[i+off]=x[i]>>32;nl[i+off]=x[i];dh[i+off]=y[i]>>32;dl[i+off]=y[i];
    }
    memcpy(oh,nh,sizeof nh);memcpy(ol,nl,sizeof nl);
}
static int check(unsigned kind,unsigned index,unsigned alias) {
    unsigned off=index&3;init(off);
    fndsa_ds_div4(nh+off,nl+off,alias?nh+off:dh+off,alias?nl+off:dl+off);
    for(unsigned i=0;i<4;i++) {
        uint64_t want=inner_fxr_div(x[i],alias?x[i]:y[i]);
        oh[i+off]=want>>32;ol[i+off]=want;
        if(nh[i+off]!=oh[i+off]||nl[i+off]!=ol[i+off]) {
            printf("DIV4_FAIL kind=%u index=%u alias=%u lane=%u x=%016llx y=%016llx got=%08x%08x want=%016llx\n",
                kind,index,alias,i,(unsigned long long)x[i],(unsigned long long)(alias?x[i]:y[i]),
                nh[i+off],nl[i+off],(unsigned long long)want);return 0;
        }
    }
    if(memcmp(nh,oh,sizeof nh)||memcmp(nl,ol,sizeof nl)) {
        printf("DIV4_FAIL guard kind=%u index=%u\n",kind,index);return 0;
    }
    for(unsigned i=0;i<8;i++) {
        uint32_t h=0xa5a5a5a5u,l=h;
        if(i>=off&&i<off+4) {h=y[i-off]>>32;l=y[i-off];}
        if(dh[i]!=h||dl[i]!=l) {
            printf("DIV4_FAIL denominator kind=%u index=%u slot=%u\n",kind,index,i);return 0;
        }
    }
    return 1;
}
static __attribute__((noipa)) void scalar4(void) {
    for(unsigned i=0;i<4;i++) {
        uint64_t a=(uint64_t)nh[i+2]<<32|nl[i+2];
        uint64_t b=(uint64_t)dh[i+2]<<32|dl[i+2];
        uint64_t c=inner_fxr_div(a,b);nh[i+2]=c>>32;nl[i+2]=c;
    }
}
static __attribute__((noipa)) uint32_t measure(unsigned old) {
    for(unsigned j=0;j<4;j++) {
        init(2);if(old)scalar4();else fndsa_ds_div4(nh+2,nl+2,dh+2,dl+2);
    }
    init(2);unsigned irq=irq_lock();uint32_t t=ticks();
    for(unsigned j=0;j<64;j++) {
        /* Keep inputs identical between repeated calls and both paths. */
        memcpy(nh,oh,sizeof nh);memcpy(nl,ol,sizeof nl);
        if(old)scalar4();else fndsa_ds_div4(nh+2,nl+2,dh+2,dl+2);
        __asm__ volatile("" ::: "memory");
    }
    t=ticks()-t;irq_unlock(irq);sink^=nh[2];return t;
}
int mlk_test_main(int argc,char **argv) {
    (void)argc;(void)argv;CoreDebug->DEMCR|=CoreDebug_DEMCR_TRCENA_Msk;
    DWT->CTRL|=DWT_CTRL_CYCCNTENA_Msk;
    unsigned cases=0;
    static const uint64_t edges[]={0,1,2,3,UINT64_MAX,UINT64_MAX-1,
        UINT64_C(0x8000000000000000),UINT64_C(0x7fffffffffffffff),
        UINT64_C(0x100000000),UINT64_C(0xffffffff),UINT64_C(0x7fffffff),
        UINT64_C(0x80000000),UINT64_C(0xffffffff00000000),
        UINT64_C(0x5555555555555555),UINT64_C(0xaaaaaaaaaaaaaaaa)};
    for(unsigned a=0;a<sizeof edges/sizeof *edges;a++)
      for(unsigned b=0;b<sizeof edges/sizeof *edges;b++) {
        for(unsigned i=0;i<4;i++) {x[i]=edges[(a+i)%15];y[i]=edges[(b+3*i)%15];}
        if(!check(0,cases,0)||!check(1,cases,1))return 1;
        cases+=2;
      }
    for(unsigned j=0;j<250000;j++) {
        for(unsigned i=0;i<4;i++) {x[i]=rnd();y[i]=rnd();}
        if(!check(2,j,0))return 2;
        cases++;
    }
    for(unsigned bit=0;bit<64;bit++)for(unsigned j=0;j<64;j++) {
        for(unsigned i=0;i<4;i++) {
            y[i]=(UINT64_C(1)<<bit)+(j&3)-1;
            x[i]=(UINT64_C(1)<<((j+i)&63))+(j%3)-1;
            if(i&1)x[i]=-x[i];
            if(i&2)y[i]=-y[i];
        }
        if(!check(3,cases,0))return 3;
        cases++;
    }
    for(unsigned cls=0;cls<32;cls++) {
        for(unsigned i=0;i<4;i++) {
            x[i]=cls<15?edges[cls]:rnd();
            y[i]=cls<15?edges[(cls+5)%15]:rnd();
        }
        for(unsigned old=0;old<2;old++) {
            uint32_t min=UINT32_MAX,max=0;
            for(unsigned j=0;j<20;j++) {
                uint32_t t=measure(old);if(t<min)min=t;if(t>max)max=t;
            }
            printf("DIV4_TIMING class=%u scalar=%u calls=64 lanes=4 min=%u max=%u\n",cls,old,min,max);
        }
    }
    printf("DIV4_DONE cases=%u values=%u failures=0\n",cases,cases*4);return 0;
}
