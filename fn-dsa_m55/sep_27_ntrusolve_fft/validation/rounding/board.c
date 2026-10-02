#include "kgen_ds.h"
#include "kgen_ds_q32.h"
#include <stdio.h>
#include <string.h>
#include <zephyr/kernel.h>
#include <cmsis_core.h>
#include "oracle.h"
extern int fndsa_ds_round4(const float[4],const float[4],int32_t[4]);
static fndsa_ds_poly input;
static int32_t actual[1024],reference[1024];
static uint64_t state=0x7365703237726e64ull;
static volatile uint32_t sink;
static uint64_t random_word(void) {state^=state<<13;state^=state>>7;state^=state<<17;return state;}
static float from_bits(uint32_t u) {float f;memcpy(&f,&u,4);return f;}
static uint32_t bits(float f) {uint32_t u;memcpy(&u,&f,4);return u;}
static uint32_t ticks(void) {__DSB();__ISB();return DWT->CYCCNT;}
static const uint32_t edges[]={0,0x80000000,1,0x80000001,0x007fffff,0x807fffff,
  0x00800000,0x80800000,0x3effffff,0x3f000000,0x3f000001,0xbeffffff,0xbf000000,
  0xbf000001,0x3f800000,0xbf800000,0x4effffff,0xceffffff,0x4f000000,0xcf000000,
  0x4b000000,0xcb000000,0x2f000000,0xaf000000,0x2f800000,0xaf800000,
  0x7f800000,0xff800000,0x7fc00001,0xffc00001,0x7f800001,0xff800001};
static int compare(unsigned logn,unsigned kind,unsigned index) {
    unsigned n=1u<<logn;
    memset(actual,0xa5,sizeof actual);memset(reference,0xa5,sizeof reference);
    int a=fndsa_ds_to_k(logn,actual,&input),b=oracle_to_k(logn,reference,&input);
    if(a!=b||memcmp(actual,reference,sizeof actual)) {
        for(unsigned i=0;i<n;i++)if(actual[i]!=reference[i]||a!=b) {
            const float (*part)[512]=i<n/2?input.re:input.im;
            unsigned j=i&(n/2-1);
            printf("ROUND_FAIL logn=%u kind=%u index=%u lane=%u h=%08x l=%08x got=%d ref=%d valid=%d/%d\n",
              logn,kind,index,i,bits(part[0][j]),bits(part[1][j]),actual[i],reference[i],a,b);
            break;
        }
        return 0;
    }
    return 1;
}
/* Keep the measured region at the same code address for all operand classes. */
static __attribute__((noinline)) uint32_t measure(unsigned scalar) {
    for(unsigned k=0;k<16;k++) {
        if(scalar)sink=(uint32_t)oracle_to_k(3,reference,&input);
        else sink=(uint32_t)fndsa_ds_to_k(3,actual,&input);
        __asm__ volatile("" ::: "memory");
    }
    unsigned irq=irq_lock();uint32_t t=ticks();
    for(unsigned k=0;k<128;k++) {
        if(scalar)sink=(uint32_t)oracle_to_k(3,reference,&input);
        else sink=(uint32_t)fndsa_ds_to_k(3,actual,&input);
        __asm__ volatile("" ::: "memory");
    }
    t=ticks()-t;irq_unlock(irq);return t;
}
int mlk_test_main(int argc,char **argv) {
    (void)argc;(void)argv;CoreDebug->DEMCR|=CoreDebug_DEMCR_TRCENA_Msk;
    DWT->CTRL|=DWT_CTRL_CYCCNTENA_Msk;
    unsigned cases=0,values=0;
    for(unsigned kind=0;kind<3;kind++)for(unsigned j=0;j<50000;j++) {
        for(unsigned i=0;i<8;i++) {
            float (*part)[512]=i<4?input.re:input.im;unsigned k=i&3;
            if(kind==0) {q32ds d=qd_from_raw(random_word());part[0][k]=d.h;part[1][k]=d.l;}
            else if(kind==1) {part[0][k]=from_bits((uint32_t)random_word());part[1][k]=from_bits((uint32_t)random_word());}
            else {
                int32_t z=(int32_t)(random_word()%0x1000000)-0x800000;
                part[0][k]=(float)z+0.5f;
                part[1][k]=from_bits(edges[random_word()%(sizeof edges/4)]);
            }
        }
        if(!compare(3,kind,j))return 1;cases++;values+=8;
    }
    for(unsigned a=0;a<sizeof edges/4;a++)for(unsigned b=0;b<sizeof edges/4;b++) {
        for(unsigned i=0;i<4;i++) {
            input.re[0][i]=input.im[0][i]=from_bits(edges[a]);
            input.re[1][i]=input.im[1][i]=from_bits(edges[b]);
        }
        if(!compare(3,3,32*a+b))return 2;cases++;values+=8;
    }
    for(unsigned logn=1;logn<=10;logn++)for(unsigned j=0;j<32;j++) {
        unsigned hn=1u<<(logn-1);
        for(unsigned i=0;i<hn;i++)for(unsigned p=0;p<2;p++) {
            float (*part)[512]=p?input.im:input.re;q32ds d=qd_from_raw(random_word());
            part[0][i]=d.h;part[1][i]=d.l;
        }
        if(!compare(logn,4,j))return 3;cases++;values+=hn*2;
    }
    for(unsigned c=0;c<sizeof edges/4;c++) {
        for(unsigned i=0;i<4;i++) {
            input.re[0][i]=input.im[0][i]=from_bits(edges[c]);
            input.re[1][i]=input.im[1][i]=c&1?-0x1p-40f:0;
        }
        for(unsigned old=0;old<2;old++) {
            uint32_t min=UINT32_MAX,max=0;
            for(unsigned j=0;j<20;j++) {
                uint32_t t=measure(old);if(t<min)min=t;if(t>max)max=t;
            }
            printf("ROUND_TIMING class=%u scalar=%u calls=128 lanes=8 min=%u max=%u\n",c,old,min,max);
        }
    }
    printf("ROUND_DONE cases=%u values=%u failures=0\n",cases,values);return 0;
}
