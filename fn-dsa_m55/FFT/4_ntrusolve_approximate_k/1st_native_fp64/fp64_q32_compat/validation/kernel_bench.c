/* Own-source inclusion exposes private arithmetic to this diagnostic only. */
#include "../kgen_fxp.c"
#include "kernel_cases.h"
#include <cmsis_core.h>
#include <stm32n6xx.h>
#include <stdio.h>
static fxr f0[1024],f1[1024],a0[1024],a1[1024];
static volatile uint64_t va,vb,sink;
__attribute__((noinline,aligned(32))) static uint64_t old_mul(uint64_t a,uint64_t b){return fxr_mul((fxr){a},(fxr){b}).v;}
__attribute__((noinline,aligned(32))) static uint64_t new_mul(uint64_t a,uint64_t b){return fp64q_mul((fxr){a},(fxr){b}).v;}
static uint32_t state=0x193227AB;
static uint32_t rng(void){uint32_t x=state;x^=x<<13;x^=x>>17;x^=x<<5;return state=x;}
static const uint64_t edges[]={0,1,2,3,0xFFFF,0x10000,0x7FFFFFFF,0x80000000,0xFFFFFFFF,
 0x100000000,0x100000001,0x1FFFFFFFF,0x7FFFFFFFFFFFFFFF,0x8000000000000000,
 0xFFFFFFFF00000000,0xFFFFFFFFFFFFFFFE,0xFFFFFFFFFFFFFFFF};
static void repeat_old(unsigned l,fxr *a,const fxr *b){vect_FFT(l,a);vect_mul_fft(l,a,b);vect_iFFT(l,a);}
static void repeat_new(unsigned l,fxr *a,const fxr *b){vect_FFT_fp64q(l,a);vect_mul_fft_fp64q(l,a,b);vect_iFFT_fp64q(l,a);}
int mlk_test_main(int argc,char **argv)
{
 (void)argc;(void)argv;
 if(SystemCoreClock!=800000000u || (SCB->CCR&0x30000u) || *(volatile unsigned*)0x56008008!=0x99u || (__get_FPSCR()&0x1C00000u))return 10;
 CoreDebug->DEMCR|=1u<<24;*(volatile unsigned*)0xE0001FB0=0xC5ACCE55;DWT->CYCCNT=0;DWT->CTRL|=1;
 __disable_irq();
 for(unsigned i=0;i<100000;i++) {
  uint64_t a=((uint64_t)rng()<<32)|rng(),b=((uint64_t)rng()<<32)|rng();
  if(i<289){a=edges[i/17];b=edges[i%17];}
  if(old_mul(a,b)!=new_mul(a,b)){printf("MUL_FAIL index=%u\n",i);return 1;}
 }
 printf("MUL_DIFFERENTIAL count=100000 mismatches=0\n");
 for(unsigned op=0;op<2;op++)for(unsigned c=0;c<34;c++) {
  va=edges[c%17];vb=c<17?edges[16-c%17]:edges[c%17];
  uint32_t best=~0u,worst=0;
  for(unsigned trial=0;trial<21;trial++) {
   uint32_t t=DWT->CYCCNT;
   for(unsigned j=0;j<256;j++)sink=op?new_mul(va,vb):old_mul(va,vb);
   uint32_t elapsed=DWT->CYCCNT-t;
   if(trial&&elapsed<best)best=elapsed;if(trial&&elapsed>worst)worst=elapsed;
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
    uint32_t t=DWT->CYCCNT;
    if(k)vect_FFT_fp64q(p->logn,f);else vect_FFT(p->logn,f);
    vect_inv_mul2e_fft(p->logn,f,p->e);uint32_t u=DWT->CYCCNT;
    if(k)repeat_new(p->logn,a,f);else repeat_old(p->logn,a,f);
    for(size_t i=0;i<n;i++)a[i].v=(uint32_t)fxr_round(a[i]);
    uint32_t v=DWT->CYCCNT;if(trial>=10){prep[k]+=u-t;rep[k]+=v-u;}
   }
   if(memcmp(f0,f1,n*8)||memcmp(a0,a1,n*8))return 2;
   for(size_t i=0;i<n;i++)if((int32_t)a1[i].v!=p->k_fixed[i])return 3;
  }
  printf("KERNEL case=%u logn=%u old_prepare=%llu new_prepare=%llu old_repeat=%llu new_repeat=%llu mismatches=0\n",c,p->logn,
    (unsigned long long)prep[0],(unsigned long long)prep[1],(unsigned long long)rep[0],(unsigned long long)rep[1]);
 }
 __enable_irq();printf("KERNEL_DONE result=0\n");return 0;
}
