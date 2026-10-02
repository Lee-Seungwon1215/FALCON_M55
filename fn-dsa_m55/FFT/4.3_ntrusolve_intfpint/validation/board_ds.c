
/* Candidate C local segment benchmark and arithmetic tests. */
#include "kgen_ds.h"
#include <stdio.h>
#include <math.h>
#include <cmsis_core.h>
#include <stm32n6xx.h>
static fndsa_ds_poly dw,di;
static uint32_t words[3*1024],bigF[3*1024];
static fxr fw[1024],fi[1024];
static int32_t kd[1024],kr[1024];
static uint32_t rng=0x91aac3;
static volatile int32_t sink;
static uint32_t rnd(void){rng^=rng<<13;rng^=rng>>17;rng^=rng<<5;return rng;}
static void input(unsigned logn,unsigned cls){
 size_t n=(size_t)1<<logn;
 for(size_t i=0;i<n;i++){
  int32_t f=(int32_t)(rnd()%31)-15,F=(int32_t)(rnd()%511)-255;
  if(cls==0){f=i==0?1:0;F=(i&1)?1:-1;}
  if(cls==1){f=i==0?17:0;F=0;}
  if(cls==2){f=i==0?2:0;F=(i&1)?511:-511;}
  if(cls==3){f=(i&1)?-3:7;F=(i&1)?7:-31; if(i==0)f++;}
  words[i]=(uint32_t)f&0x7fffffff;
  bigF[i]=(uint32_t)F&0x7fffffff;
 }
}
static void __attribute__((noinline,noclone)) segment(unsigned be,unsigned logn){
 if(be){
  fndsa_ds_from_big(logn,&di,words,1,0);
  fndsa_ds_fft(logn,&di);fndsa_ds_inverse(logn,&di,0);
  fndsa_ds_from_big(logn,&dw,bigF,1,0);
  fndsa_ds_fft(logn,&dw);fndsa_ds_mul(logn,&dw,&di);
  fndsa_ds_ifft(logn,&dw);
  if(!fndsa_ds_to_k(logn,kd,&dw))kd[0]=INT32_MIN;
 }else{
  poly_big_to_fixed(logn,fi,words,1,0);
  vect_FFT(logn,fi);vect_inv_mul2e_fft(logn,fi,0);
  poly_big_to_fixed(logn,fw,bigF,1,0);
  vect_FFT(logn,fw);vect_mul_fft(logn,fw,fi);vect_iFFT(logn,fw);
  for(size_t i=0;i<((size_t)1<<logn);i++)kr[i]=fxr_round(fw[i]);
 }
 sink^=be?kd[0]:kr[0];
}
static uint32_t measured(unsigned be,unsigned logn){
 __DSB();__ISB();uint32_t t=DWT->CYCCNT;segment(be,logn);
 __DSB();__ISB();return DWT->CYCCNT-t;
}
static void __attribute__((noinline,noclone)) kernel(unsigned be,unsigned op,unsigned logn){
 if(be){
  if(op==0)fndsa_ds_fft(logn,&dw);
  else if(op==1)fndsa_ds_ifft(logn,&dw);
  else if(op==2)fndsa_ds_inverse(logn,&dw,0);
  else if(op==3)fndsa_ds_mul(logn,&dw,&di);
  else if(op==4)fndsa_ds_from_big(logn,&dw,bigF,1,0);
  else fndsa_ds_to_k(logn,kd,&dw);
 }else{
  if(op==0)vect_FFT(logn,fw);
  else if(op==1)vect_iFFT(logn,fw);
  else if(op==2)vect_inv_mul2e_fft(logn,fw,0);
  else if(op==3)vect_mul_fft(logn,fw,fi);
  else if(op==4)poly_big_to_fixed(logn,fw,bigF,1,0);
  else for(size_t i=0;i<((size_t)1<<logn);i++)kr[i]=fxr_round(fw[i]);
 }
}
int mlk_test_main(int argc,char **argv){
 (void)argc;(void)argv;
 if(SystemCoreClock!=800000000u || (SCB->CCR&0x30000u) ||
  *(volatile unsigned*)0x56008008!=0x99u || (__get_FPSCR()&0x1C00000u))return 10;
 CoreDebug->DEMCR|=CoreDebug_DEMCR_TRCENA_Msk;DWT->CTRL|=DWT_CTRL_CYCCNTENA_Msk;
 for(unsigned logn=4;logn<=10;logn++)for(unsigned op=0;op<6;op++)for(unsigned be=0;be<2;be++){
  uint64_t total=0,diff=0,max_lsb=0;unsigned invalid=0;
  uint32_t low=UINT32_MAX,high=0;rng=0x928344u^(logn<<8)^op;
  for(unsigned r=0;r<110;r++){
   input(logn,4);
   poly_big_to_fixed(logn,fw,bigF,1,0);poly_big_to_fixed(logn,fi,words,1,0);
   fndsa_ds_from_big(logn,&dw,bigF,1,0);fndsa_ds_from_big(logn,&di,words,1,0);
   unsigned irq=__get_PRIMASK();__disable_irq();__DSB();__ISB();uint32_t t=DWT->CYCCNT;
   kernel(be,op,logn);__DSB();__ISB();t=DWT->CYCCNT-t;
   if(!irq)__enable_irq();
   if(r>=10){
    total+=t;if(t<low)low=t;if(t>high)high=t;
    if(be){
     kernel(0,op,logn);
     size_t n=(size_t)1<<logn,hn=n>>1;
     for(size_t i=0;i<n;i++){
      if(op==5){diff+=kd[i]!=kr[i];continue;}
      double got=i<hn?(double)dw.re[0][i]+dw.re[1][i]
       :(double)dw.im[0][i-hn]+dw.im[1][i-hn];
      double want=(double)(int32_t)(fw[i].v>>32)+(double)(uint32_t)fw[i].v*0x1p-32;
      double er=__builtin_fabs(got-want)*0x1p32;
      if(!__builtin_isfinite(er)||er>=0x1p64){invalid++;continue;}
      uint64_t lsb=(uint64_t)__builtin_ceil(er);
      diff+=er!=0;if(lsb>max_lsb)max_lsb=lsb;
     }
    }
   }
  }
  printf("C_KERNEL logn=%u op=%u backend=%u calls=100 total=%llu min=%u max=%u differences=%llu max_lsb_ceil=%llu invalid=%u\n",
    logn,op,be,(unsigned long long)total,low,high,(unsigned long long)diff,
    (unsigned long long)max_lsb,invalid);
 }
 for(unsigned logn=4;logn<=10;logn++){
  for(unsigned be=0;be<2;be++){
   uint64_t total=0,diff=0;uint32_t low=UINT32_MAX,high=0;
   rng=0x91aac3u^logn;
   for(unsigned r=0;r<110;r++){
    input(logn,4);
    unsigned irq=__get_PRIMASK();__disable_irq();
    uint32_t t=measured(be,logn);
    if(!irq)__enable_irq();
    if(r>=10){
     total+=t;if(t<low)low=t;if(t>high)high=t;
     if(be){segment(0,logn);for(size_t i=0;i<((size_t)1<<logn);i++)diff+=kd[i]!=kr[i];}
    }
   }
   printf("C_SEGMENT logn=%u backend=%u calls=100 total=%llu min=%u max=%u k_differences=%llu\n",
    logn,be,(unsigned long long)total,low,high,(unsigned long long)diff);
  }
  for(unsigned cls=0;cls<6;cls++){
   input(logn,cls);uint64_t total=0;uint32_t low=UINT32_MAX,high=0;
   for(unsigned r=0;r<110;r++){
    unsigned irq=__get_PRIMASK();__disable_irq();uint32_t t=measured(1,logn);
    if(!irq)__enable_irq();
    if(r>=10){total+=t;if(t<low)low=t;if(t>high)high=t;}
   }
   printf("C_TIMING logn=%u class=%u calls=100 total=%llu min=%u max=%u valid=%u\n",
    logn,cls,(unsigned long long)total,low,high,kd[0]!=INT32_MIN);
  }
 }
 /* End-boundary half neighborhoods; direct DS input keeps low terms. */
 unsigned rb=0,rc=0;
 for(int k=-64;k<=64;k++)for(int j=-4;j<=4;j++){
  double x=(double)k+0.5+(double)j*0x1p-34;
  float h=(float)x,l=(float)(x-(double)h);
  for(unsigned i=0;i<8;i++){dw.re[0][i]=dw.im[0][i]=h;dw.re[1][i]=dw.im[1][i]=l;}
  rb+=!fndsa_ds_to_k(4,kd,&dw);
  int32_t want=(int32_t)__builtin_floor(x+0.5+0x1p-33);
  for(unsigned i=0;i<16;i++){rb+=kd[i]!=want;rc++;}
 }
 printf("C_ROUND count=%u differences=%u\n",rc,rb);
 printf("C_DIAGNOSTIC_DONE\n");return rb!=0;
}
