/* Frozen real NTRU inputs; both arithmetic backends in ONE board image.
 * Input buffer setup is outside timing. Includes inverse preparation,
 * FFT/product/iFFT/round, but excludes big-integer limb extraction.
 */
#include "kgen_inner.h"
#include <cmsis_core.h>
#include <stm32n6xx.h>
#include <stdio.h>
#include <string.h>
#include "kernel_cases.h"

static fxr fq[1024],Fq[1024];
static double fd[1024],Fd[1024];
static int32_t kq[1024],kd[1024];
static volatile double sink,va,vb;
static volatile int32_t isink;
__attribute__((noinline)) static double probe_add(double a,double b){return a+b;}
__attribute__((noinline)) static double probe_mul(double a,double b){return a*b;}
__attribute__((noinline)) static double probe_div(double a,double b){return a/b;}
__attribute__((noinline)) static double probe_div_normal(double a,double b){return fp64_div_normal(a,b);}
__attribute__((noinline)) static int32_t probe_round(double a){return fp64_round_i32(a);}

static double to_double(uint64_t v)
{
	return (double)(int32_t)(v>>32)+(double)(uint32_t)v*0x1p-32;
}
static void timing_probe(void)
{
	static const double pairs[][2]={{0,1},{1,1},{-1,1},{0.5,0.75},
		{0x1p-32,0x1p14},{0x1p14,0x1p-32},{12345.25,-8192.5},
		{-12345.25,8192.5},{0x1p-40,0x1p-30},{0x1p20,0x1p-20},
		{0.49999999999999994,1},{-0.5000000000000001,1},
		{-0.0,1},{1,0},{0,0},{__builtin_inf(),1},
		{__builtin_nan(""),1},{0x1p-1074,1},{1,0x1p-1074},
		{0x1p900,0x1p-900}};
	for(unsigned op=0;op<5;op++)for(unsigned c=0;c<sizeof pairs/sizeof pairs[0];c++) {
		/* Invalid-domain stress belongs only to the guarded divider.
		 * Do not feed NaN/Inf/out-of-range values to the raw int cast. */
		if(c>=12 && op!=4)continue;
		va=pairs[c][0];vb=pairs[c][1];uint32_t best=~0u,worst=0;
		for(unsigned trial=0;trial<21;trial++) {
			uint32_t before=DWT->CYCCNT;
			for(unsigned j=0;j<256;j++) {
				if(op==0)sink=probe_add(va,vb);
				else if(op==1)sink=probe_mul(va,vb);
				else if(op==2)sink=probe_div(va,vb);
				else if(op==3)isink=probe_round(va);
				else sink=probe_div_normal(va,vb);
			}
			uint32_t elapsed=DWT->CYCCNT-before;
			if(trial && elapsed<best)best=elapsed;
			if(trial && elapsed>worst)worst=elapsed;
		}
		printf("CT_PROBE op=%u case=%u repeats=256 min=%u max=%u\n",op,c,best,worst);
	}
}
int mlk_test_main(int argc,char **argv)
{
	(void)argc;(void)argv;
	printf("KERNEL_BEGIN cases=%u repeats=100 cpu=%u fpscr=%08x\n",
		(unsigned)(sizeof cases/sizeof cases[0]),(unsigned)SystemCoreClock,(unsigned)__get_FPSCR());
	if(SystemCoreClock!=800000000u || (SCB->CCR&0x30000u) ||
		*(volatile unsigned*)0x56008008!=0x99u || (__get_FPSCR()&0x1C00000u))return 10;
	CoreDebug->DEMCR|=1u<<24;*(volatile unsigned*)0xE0001FB0=0xC5ACCE55;
	DWT->CYCCNT=0;DWT->CTRL|=1;
	__disable_irq();
	unsigned failures=0;
	for(unsigned c=0;c<sizeof cases/sizeof cases[0];c++) {
		const struct kernel_case *p=&cases[c];size_t n=(size_t)1<<p->logn;
		uint64_t qp=0,qr=0,dp=0,dr=0;
		for(unsigned j=0;j<110;j++) {
			for(size_t i=0;i<n;i++){fq[i].v=p->f[i];Fq[i].v=p->F[i];fd[i]=to_double(p->f[i]);Fd[i]=to_double(p->F[i]);}
			/* Alternate backend order; no input generation or printing timed. */
			for(unsigned turn=0;turn<2;turn++) {
				if((turn^(j&1))==0) {
					uint32_t t=DWT->CYCCNT;
					vect_FFT(p->logn,fq);vect_inv_mul2e_fft(p->logn,fq,p->e);
					uint32_t u=DWT->CYCCNT;
					vect_FFT(p->logn,Fq);vect_mul_fft(p->logn,Fq,fq);vect_iFFT(p->logn,Fq);
					for(size_t i=0;i<n;i++)kq[i]=fxr_round(Fq[i]);
					uint32_t v=DWT->CYCCNT;
					if(j>=10){qp+=u-t;qr+=v-u;}
				} else {
					uint32_t t=DWT->CYCCNT;
					vect_FFT_fp64(p->logn,fd);vect_inv_mul2e_fft_fp64(p->logn,fd,p->e);
					uint32_t u=DWT->CYCCNT;
					vect_FFT_fp64(p->logn,Fd);vect_mul_fft_fp64(p->logn,Fd,fd);vect_iFFT_fp64(p->logn,Fd);
					uint32_t valid=1;
					for(size_t i=0;i<n;i++)kd[i]=fp64_round_i32_checked(Fd[i],&valid);
					valid &= fp64_k_update_ok(p->logn,kd);
					uint32_t v=DWT->CYCCNT;
					if(!valid)return 7;
					if(j>=10){dp+=u-t;dr+=v-u;}
				}
			}
		}
		unsigned diff=0;
		for(size_t i=0;i<n;i++){
			diff+=kq[i]!=kd[i];
			failures+=(kq[i]!=p->k_fixed[i])+(kd[i]!=p->k_fp64[i]);
		}
		printf("KERNEL case=%u logn=%u fixed_prepare=%llu fp64_prepare=%llu fixed_reduce=%llu fp64_reduce=%llu k_differences=%u\n",
			c,p->logn,(unsigned long long)qp,(unsigned long long)dp,(unsigned long long)qr,(unsigned long long)dr,diff);
	}
	timing_probe();
	__enable_irq();
	printf("KERNEL_DONE result=%u\n",failures);
	return failures?1:0;
}
