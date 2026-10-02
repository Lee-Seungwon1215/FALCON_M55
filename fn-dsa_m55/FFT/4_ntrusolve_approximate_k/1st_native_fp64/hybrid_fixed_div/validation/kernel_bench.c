/* Both dividers in one firmware. Include own source only for static access. */
#include "../kgen_fxp.c"
#include "kernel_cases.h"
#include <cmsis_core.h>
#include <stm32n6xx.h>
#include <stdio.h>
static fxr f0[1024],f1[1024],a0[1024],a1[1024];
static volatile uint64_t va,vb,sink;
__attribute__((noinline,aligned(32))) static uint64_t old_div(uint64_t a,uint64_t b){return inner_fxr_div(a,b);}
__attribute__((noinline,aligned(32))) static uint64_t new_div(uint64_t a,uint64_t b){return fxr_div_fp64_exact(a,b);}
__attribute__((noinline)) static void old_inv(unsigned logn,fxr *a,unsigned e)
{
    size_t hn=(size_t)1<<(logn-1);
    for(size_t i=0;i<hn;i++) {
        fxr re=a[i],im=fxr_neg(a[i+hn]),z=fxr_add(fxr_sqr(re),fxr_sqr(im));
        a[i]=fxr_div(fxr_mul2e(re,e),z);a[i+hn]=fxr_div(fxr_mul2e(im,e),z);
    }
}
__attribute__((noinline)) static void reduce(unsigned logn,fxr *a,const fxr *f)
{
    vect_FFT(logn,a);vect_mul_fft(logn,a,f);vect_iFFT(logn,a);
    for(size_t i=0;i<((size_t)1<<logn);i++)a[i].v=(uint32_t)fxr_round(a[i]);
}
static uint32_t rng_state=0x928337AB;
static uint32_t rng(void){uint32_t x=rng_state;x^=x<<13;x^=x>>17;x^=x<<5;return rng_state=x;}
int mlk_test_main(int argc,char **argv)
{
    (void)argc;(void)argv;
    if(SystemCoreClock!=800000000u || (SCB->CCR&0x30000u) || *(volatile unsigned*)0x56008008!=0x99u || (__get_FPSCR()&0x1C00000u))return 10;
    CoreDebug->DEMCR|=1u<<24;*(volatile unsigned*)0xE0001FB0=0xC5ACCE55;DWT->CYCCNT=0;DWT->CTRL|=1;
    __disable_irq();
    for(unsigned j=0;j<100000;j++) {
        uint64_t a=((uint64_t)(rng()&0x7FFFFFFFu)<<32)|rng();
        uint64_t b=((uint64_t)(rng()|0x40000000u)<<31)|rng();
        if(j%5==0){a=(uint32_t)a;b=1;}
        if(j%7==0)b=0;
        if(j&1)a=-a;if(j&2)b=-b;
        if(old_div(a,b)!=new_div(a,b)){printf("DIV_FAIL index=%u\n",j);return 1;}
    }
    printf("DIV_DIFFERENTIAL count=100000 mismatches=0\n");
    static const uint64_t pairs[][2]={
        {0,0},{1,0},{0x40000000,0},{0x80000000,0},{0x7FFFFFFFFFFFFFFF,0},{0x8000000000000000,0},
        {0,1},{1,1},{2,3},{1,2},{1,3},{1,0x7FFFFFFFFFFFFFFF},
        {0x7FFFFFFFFFFFFFFF,0x7FFFFFFFFFFFFFFF},{0x7FFFFFFFFFFFFFFF,0x80000000},
        {0x8000000000000000,0x8000000000000000},{0x100000000,0xFFFFFFFF},
        {0xFFFFFFFF,1},{0xFFFFFFFF,2},{0xFFFFFFFFFFFFFFFE,3},{3,0xFFFFFFFFFFFFFFFE},
        {0x100000001,0x100000003},{0x100000001,0x7FFFFFFFFFFFFFFF},
        {0x3FFFFFFFFFFFFFFF,0x4000000000000000},{0x4000000000000001,0x4000000000000000}
    };
    for(unsigned op=0;op<2;op++)for(unsigned c=0;c<sizeof pairs/sizeof pairs[0];c++) {
        va=pairs[c][0];vb=pairs[c][1];uint32_t best=~0u,worst=0;
        for(unsigned trial=0;trial<21;trial++) {
            uint32_t t=DWT->CYCCNT;
            for(unsigned j=0;j<256;j++)sink=op?new_div(va,vb):old_div(va,vb);
            uint32_t elapsed=DWT->CYCCNT-t;
            if(trial && elapsed<best)best=elapsed;if(trial && elapsed>worst)worst=elapsed;
        }
        printf("CT op=%u case=%u repeats=256 min=%u max=%u\n",op,c,best,worst);
    }
    for(unsigned c=0;c<sizeof cases/sizeof cases[0];c++) {
        const struct kernel_case *p=&cases[c];size_t n=(size_t)1<<p->logn;
        uint64_t prep[2]={0,0},rep[2]={0,0};
        for(unsigned trial=0;trial<110;trial++) {
            for(size_t i=0;i<n;i++){f0[i].v=f1[i].v=p->f[i];a0[i].v=a1[i].v=p->F[i];}
            for(unsigned turn=0;turn<2;turn++) {
                unsigned k=turn^(trial&1);fxr *f=k?f1:f0,*a=k?a1:a0;
                uint32_t t=DWT->CYCCNT;vect_FFT(p->logn,f);
                if(k)vect_inv_mul2e_fft(p->logn,f,p->e);else old_inv(p->logn,f,p->e);
                uint32_t u=DWT->CYCCNT;reduce(p->logn,a,f);uint32_t v=DWT->CYCCNT;
                if(trial>=10){prep[k]+=u-t;rep[k]+=v-u;}
            }
            if(memcmp(f0,f1,n*sizeof(fxr)) || memcmp(a0,a1,n*sizeof(fxr)))return 2;
            for(size_t i=0;i<n;i++)if((int32_t)a1[i].v!=p->k_fixed[i])return 3;
        }
        printf("KERNEL case=%u logn=%u old_prepare=%llu new_prepare=%llu old_repeat=%llu new_repeat=%llu mismatches=0\n",c,p->logn,
            (unsigned long long)prep[0],(unsigned long long)prep[1],(unsigned long long)rep[0],(unsigned long long)rep[1]);
    }
    __enable_irq();printf("KERNEL_DONE result=0\n");return 0;
}
