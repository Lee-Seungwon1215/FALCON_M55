/* Isolated regression tests of the actual first rejecting iteration and
 * earliest numerical primitive. No production function or guard is changed. */
#include "failure_trace/probes.c"
#include <stdio.h>
#include <string.h>
#include "failure_cases.h"
#ifdef AUDIT_BOARD
#include <cmsis_core.h>
#include <stm32n6xx.h>
#endif
static double as_double(uint64_t x)
{ return (double)(int32_t)(x>>32)+(double)(uint32_t)x*0x1p-32; }
static uint64_t bits(double d) { uint64_t x;memcpy(&x,&d,8);return x; }
static double from_bits(uint64_t x) { double d;memcpy(&d,&x,8);return d; }
static fxr f[16],F[16];static double df[16],dF[16];static int32_t kq[16],kd[16];
static int run(void)
{
 unsigned bad=0;
 for(unsigned c=0;c<sizeof failure_cases/sizeof failure_cases[0];c++) {
  const struct failure_case *p=&failure_cases[c];unsigned n=1u<<p->logn;
  for(unsigned i=0;i<n;i++) { f[i].v=p->f[i];F[i].v=p->F[i];df[i]=as_double(p->f[i]);dF[i]=as_double(p->F[i]); }
  vect_FFT(p->logn,f);vect_inv_mul2e_fft(p->logn,f,p->e);
  vect_FFT(p->logn,F);vect_mul_fft(p->logn,F,f);vect_iFFT(p->logn,F);
  vect_FFT_fp64(p->logn,df);vect_inv_mul2e_fft_fp64(p->logn,df,p->e);
  vect_FFT_fp64(p->logn,dF);vect_mul_fft_fp64(p->logn,dF,df);vect_iFFT_fp64(p->logn,dF);
  unsigned diffs=0,fixture=0;uint32_t valid=1;
  for(unsigned i=0;i<n;i++) { kq[i]=fxr_round(F[i]);kd[i]=fp64_round_i32_checked(dF[i],&valid);diffs+=kq[i]!=kd[i];fixture+=kq[i]!=p->k[i]; }
  unsigned old=diag_old_guard(p->logn,kd),l1=diag_l1_guard(p->logn,kd);
  bad+=diffs||fixture||!valid||old!=0||l1!=1;
  printf("FIRST_GUARD case=%s logn=%u k_differences=%u fixture_errors=%u round_valid=%u old_guard=%u diagnostic_l1=%u\n",p->name,p->logn,diffs,fixture,valid,old,l1);
 }
 for(unsigned c=0;c<sizeof primitive_cases/sizeof primitive_cases[0];c++) {
  const struct primitive_case *p=&primitive_cases[c];uint64_t q=0;double d=0;
  /* volatile prevents replacing the arithmetic by a constant answer. */
  volatile uint64_t vx=p->x,vy=p->y,vdx=p->dx,vdy=p->dy;
  uint64_t x=vx,y=vy;double dx=from_bits(vdx),dy=from_bits(vdy);
  switch(p->op) {
   case 0:q=diag_fixed_sqr(x);d=diag_trial_mul(dx,dx);break;
   case 1:q=diag_fixed_add(x,y);d=diag_trial_add(dx,dy);break;
   case 2:q=diag_fixed_scale(x,p->e);d=diag_trial_scale(dx,p->e);break;
   case 3:q=diag_fixed_div(x,y);d=diag_trial_div(dx,dy);break;
   default:bad++;break;
  }
  printf("FIRST_PRIMITIVE case=%s op=%u fixed=%016llx trial=%016llx\n",p->name,p->op,(unsigned long long)q,(unsigned long long)bits(d));
 }
 printf("FIRST_FAILURE_DONE cases=5 errors=%u\n",bad);return bad!=0;
}
#ifdef AUDIT_BOARD
int mlk_test_main(int argc,char **argv)
{
 (void)argc;(void)argv;
 if(SystemCoreClock!=800000000u||(SCB->CCR&0x30000u)||*(volatile unsigned*)0x56008008!=0x99u||(__get_FPSCR()&0x1C00000u))return 10;
 __disable_irq();int r=run();__enable_irq();return r;
}
#else
int main(void) { return run(); }
#endif
