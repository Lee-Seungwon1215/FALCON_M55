/* Isolate compatibility operations: no FFT/conversion or input generation
 * inside the timed interval. Public size/op/class only. Not a CT proof. */
#include "kgen_ds.h"
#include <stdio.h>
#include <cmsis_core.h>
#include <stm32n6xx.h>
static fndsa_ds_poly a,b;
static volatile float sink;
static const float val[8][2]={{0,0},{1,1},{-1,2},{0x1p-16f,0x1p-16f},
 {0x1p15f,0x1p14f},{0.5f,-0.5f},{123.25f,-37.5f},{0x1p30f,0x1p29f}};
static void prepare(unsigned logn,unsigned cls) {
 size_t hn=(size_t)1<<(logn-1);
 for(size_t i=0;i<hn;i++) {
  a.re[0][i]=val[cls][0];a.im[0][i]=val[cls][1];
  a.re[1][i]=a.im[1][i]=0;
  b.re[0][i]=val[cls][1];b.im[0][i]=val[cls][0];
  b.re[1][i]=b.im[1][i]=0;
 }
}
static __attribute__((noinline,noclone)) void call(unsigned op,unsigned logn) {
 if(op==0)fndsa_ds_inverse(logn,&a,0);
 else if(op==1)fndsa_ds_mul(logn,&a,&b);
 else fndsa_ds_div_real(logn,&a,&b);
}
int mlk_test_main(int argc,char **argv) {
 (void)argc;(void)argv;
 if(SystemCoreClock!=800000000u || (SCB->CCR&0x30000u) ||
 *(volatile unsigned*)0x56008008!=0x99u || (__get_FPSCR()&0x1C00000u))return 10;
 CoreDebug->DEMCR|=CoreDebug_DEMCR_TRCENA_Msk;DWT->CTRL|=DWT_CTRL_CYCCNTENA_Msk;
 const unsigned sizes[]={4,9,10};
 for(unsigned k=0;k<3;k++)for(unsigned op=0;op<3;op++)for(unsigned cls=0;cls<8;cls++){
  unsigned logn=sizes[k];uint64_t total=0;uint32_t lo=UINT32_MAX,hi=0;
  for(unsigned j=0;j<110;j++){
   prepare(logn,cls);
   unsigned irq=__get_PRIMASK();__disable_irq();__DSB();__ISB();
   uint32_t t=DWT->CYCCNT;call(op,logn);__DSB();__ISB();t=DWT->CYCCNT-t;
   if(!irq)__enable_irq();sink=a.re[0][0];
   if(j>=10){total+=t;if(t<lo)lo=t;if(t>hi)hi=t;}
  }
  printf("Q32_TIMING logn=%u op=%u class=%u calls=100 total=%llu min=%u max=%u\n",
   logn,op,cls,(unsigned long long)total,lo,hi);
 }
 puts("Q32_TIMING_DONE rows=72");return 0;
}
