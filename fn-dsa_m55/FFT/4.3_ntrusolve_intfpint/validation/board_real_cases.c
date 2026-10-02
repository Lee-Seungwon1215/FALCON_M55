/* Diagnostic-only frozen real approximation inputs. No expected changes. */
#include "kgen_ds.h"
#include <stdio.h>
#include <cmsis_core.h>
#include <stm32n6xx.h>
#include "fixtures/real_cases.h"
static fndsa_ds_poly a,b;
static fxr x[1024],inv[1024];
static uint32_t limbs[3*1024];
static int32_t kd[1024],kr[1024];
static void fromraw(unsigned logn,fndsa_ds_poly *d,const uint64_t *v){
 size_t n=(size_t)1<<logn;
 for(size_t i=0;i<n;i++){
  limbs[i]=(uint32_t)v[i]&0x7fffffff;
  limbs[i+n]=(uint32_t)(v[i]>>31)&0x7fffffff;
  limbs[i+2*n]=(uint32_t)((int64_t)v[i]>>62)&0x7fffffff;
 }
 fndsa_ds_from_big(logn,d,limbs,3,32);
}
static void comparison(const char *name,unsigned logn,unsigned mode,const char *phase,
 const fndsa_ds_poly *d,const fxr *v){
 size_t n=(size_t)1<<logn,hn=n>>1;uint64_t max=0,count=0;unsigned saturated=0;
 for(size_t i=0;i<n;i++){
  double got=i<hn?(double)d->re[0][i]+(double)d->re[1][i]
   :(double)d->im[0][i-hn]+(double)d->im[1][i-hn];
  double want=(double)(int32_t)(v[i].v>>32)+(double)(uint32_t)v[i].v*0x1p-32;
  double error=__builtin_fabs(got-want)*0x1p32;
  uint64_t e;
  if(!__builtin_isfinite(error)||error>=0x1p64){e=UINT64_MAX;saturated++;}
  else e=(uint64_t)__builtin_ceil(error);
  count+=error!=0;if(e>max)max=e;
 }
 printf("C_FIXTURE_STAGE name=%s logn=%u mode=%u phase=%s differences=%llu max_lsb_ceil=%llu saturated=%u\n",
 name,logn,mode,phase,(unsigned long long)count,(unsigned long long)max,saturated);
}
int mlk_test_main(int argc,char**argv){
 (void)argc;(void)argv;unsigned ran=0;
 if(SystemCoreClock!=800000000u || (SCB->CCR&0x30000u) ||
  *(volatile unsigned*)0x56008008!=0x99u || (__get_FPSCR()&0x1C00000u))return 10;
 for(unsigned c=0;c<sizeof(cases)/sizeof(cases[0]);c++){
  const struct fft_case *t=cases+c;if(t->logn<4)continue;
  unsigned logn=t->logn;size_t n=(size_t)1<<logn;
  for(unsigned mode=0;mode<4;mode++){
   memcpy(inv,t->f,n*8);memcpy(x,t->F,n*8);
   fromraw(logn,&b,t->f);fromraw(logn,&a,t->F);
   comparison(t->name,logn,mode,"input",&a,x);
   vect_FFT(logn,inv);fndsa_ds_fft(logn,&b);
   if(mode>=1)fromraw(logn,&b,(const uint64_t*)inv);
   comparison(t->name,logn,mode,"f_fft",&b,inv);
   vect_inv_mul2e_fft(logn,inv,t->e);fndsa_ds_inverse(logn,&b,t->e);
   if(mode>=2)fromraw(logn,&b,(const uint64_t*)inv);
   comparison(t->name,logn,mode,"inverse",&b,inv);
   vect_FFT(logn,x);fndsa_ds_fft(logn,&a);
   if(mode>=1)fromraw(logn,&a,(const uint64_t*)x);
   comparison(t->name,logn,mode,"F_fft",&a,x);
   vect_mul_fft(logn,x,inv);fndsa_ds_mul(logn,&a,&b);
   if(mode>=3)fromraw(logn,&a,(const uint64_t*)x);
   comparison(t->name,logn,mode,"pointwise",&a,x);
   vect_iFFT(logn,x);fndsa_ds_ifft(logn,&a);
   comparison(t->name,logn,mode,"ifft",&a,x);
   int ok=fndsa_ds_to_k(logn,kd,&a);unsigned diff=0;
   for(size_t i=0;i<n;i++){kr[i]=fxr_round(x[i]);diff+=kd[i]!=kr[i];}
   printf("C_FIXTURE name=%s logn=%u mode=%u valid=%u k_differences=%u\n",
    t->name,logn,mode,ok,diff);
  }
  ran++;
 }
 printf("C_FIXTURE_DONE cases=%u modes=4\n",ran);return 0;
}
