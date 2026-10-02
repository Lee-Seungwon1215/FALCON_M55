/* Follow-up timing experiment: all classes use the identical memcpy setup
 * and a shared indirect-call timer. No class-specific arithmetic occurs in
 * or immediately before the timing window. Both backends in one image.
 */
void fndsa_vect_iFFT_fp64(unsigned,double *) __attribute__((noipa));
void baseline_iFFT(unsigned,double *) __attribute__((noipa));
#include "../../kgen_fxp.c"
#include "baseline_ifft.h"
#include <cmsis_core.h>
#include <stm32n6xx.h>
#include <stdio.h>
static double input[1024],work[1024];
static volatile double sink;
typedef void (*ifft_fn)(unsigned,double*);
__attribute__((noipa)) static uint32_t timed(ifft_fn fn,unsigned logn)
{
    __DSB();__ISB();
    __asm__ volatile(".rept 32\n nop\n .endr" ::: "memory");
    uint32_t t=DWT->CYCCNT;
    fn(logn,work);
    return DWT->CYCCNT-t;
}
int mlk_test_main(int argc,char **argv)
{
    (void)argc;(void)argv;
    printf("CT_CONTROL_BEGIN cpu=%u fpscr=%08x classes=20 trials=100\n",
        (unsigned)SystemCoreClock,(unsigned)__get_FPSCR());
    if(SystemCoreClock!=800000000u || (SCB->CCR&0x30000u) ||
       *(volatile unsigned*)0x56008008!=0x99u || (__get_FPSCR()&0x1C00000u))return 10;
    CoreDebug->DEMCR|=1u<<24;*(volatile unsigned*)0xE0001FB0=0xC5ACCE55;
    DWT->CYCCNT=0;DWT->CTRL|=1;__disable_irq();
    for(unsigned l=1;l<=10;l++)for(unsigned c=0;c<20;c++) {
        size_t n=(size_t)1<<l;
        for(size_t i=0;i<n;i++) {
            double x=(double)((int)(i%19)-9)*0.125;
            if(c==0)x=0;
            if(c==1)x=-0.0;
            if(c==2)x=(i==0)?1.0:0;
            if(c==3)x=(i&1)?1.0:-1.0;
            if(c>=4){ uint64_t b=(uint64_t)(523+50*(c-4))<<52;double s;memcpy(&s,&b,8);x*=s; }
            input[i]=x;
        }
        uint32_t lo[2]={~0u,~0u},hi[2]={0,0};
        for(unsigned t=0;t<110;t++)for(unsigned k=0;k<2;k++) {
            unsigned b=k^(t&1);
            ifft_fn fn=b?fndsa_vect_iFFT_fp64:baseline_iFFT;
            memcpy(work,input,n*8);
            __set_FPSCR(__get_FPSCR() & ~0x9fu);
            uint32_t elapsed=timed(fn,l);
            sink=work[0];
            if(t>=10){if(elapsed<lo[b])lo[b]=elapsed;if(elapsed>hi[b])hi[b]=elapsed;}
        }
        for(unsigned b=0;b<2;b++)printf("CT_CONTROL logn=%u case=%u backend=%u min=%u max=%u\n",l,c,b,lo[b],hi[b]);
    }
    __enable_irq();printf("CT_CONTROL_DONE result=0\n");return 0;
}
