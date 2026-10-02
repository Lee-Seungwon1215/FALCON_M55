/* One image, identical frozen inputs, alternating order, no copies timed.
 * Only the oracle has stagewise scaling. Production source stays independent.
 */
/* Keep both real function calls: forbid whole-TU cloning/constant folding
 * from specializing only one backend for these test buffers. */
void fndsa_vect_iFFT_fp64(unsigned,double *) __attribute__((noipa));
void baseline_iFFT(unsigned,double *) __attribute__((noipa));
#include "../kgen_fxp.c"
#include "baseline_ifft.h"
#include "kernel_cases.h"
#include <cmsis_core.h>
#include <stm32n6xx.h>
#include <stdio.h>
#include <string.h>
static fxr fq[1024], Fq[1024];
static double fd[1024], Fd[1024], oldout[1024], ifft_in[1024];
static int32_t kd[1024], kq[1024];
static volatile double sink, va, vb;
__attribute__((noinline)) static double probe_div(double a, double b)
{ return fp64_div_normal(a,b); }
static double to_double(uint64_t v)
{ return (double)(int32_t)(v>>32)+(double)(uint32_t)v*0x1p-32; }
static void ct_probe(void)
{
    for (unsigned l=1;l<=10;l++) for (unsigned c=0;c<20;c++) {
        size_t n=(size_t)1<<l;
        uint32_t best=~0u,worst=0;
        for (unsigned t=0;t<21;t++) {
            for(size_t i=0;i<n;i++) {
                double x=(double)((int)(i%19)-9)*0.125;
                if(c==0)x=0;
                if(c==1)x=-0.0;
                if(c==2)x=(i==0)?1.0:0;
                if(c==3)x=(i&1)?1.0:-1.0;
                if(c>=4){ uint64_t b=(uint64_t)(523+50*(c-4))<<52; double s; memcpy(&s,&b,8);x*=s; }
                Fd[i]=x;
            }
            __DSB();__ISB();
            uint32_t a=DWT->CYCCNT;
            vect_iFFT_fp64(l,Fd);
            uint32_t b=DWT->CYCCNT;
            sink=Fd[0];
            if(t){if(b-a<best)best=b-a;if(b-a>worst)worst=b-a;}
        }
        printf("CT_IFFT logn=%u case=%u min=%u max=%u\n",l,c,best,worst);
    }
    static const double pairs[][2]={{0,1},{1,1},{-1,1},{0.5,0.75},
        {0x1p-32,0x1p14},{0x1p14,0x1p-32},{12345.25,-8192.5},
        {-12345.25,8192.5},{0x1p-40,0x1p-30},{0x1p20,0x1p-20},
        {0.49999999999999994,1},{-0.5000000000000001,1},
        {-0.0,1},{1,0},{0,0},{__builtin_inf(),1},
        {__builtin_nan(""),1},{0x1p-1074,1},{1,0x1p-1074},{0x1p900,0x1p-900}};
    for(unsigned c=0;c<20;c++) {
        uint32_t best=~0u,worst=0;va=pairs[c][0];vb=pairs[c][1];
        for(unsigned t=0;t<21;t++) {
            __DSB();__ISB();
            uint32_t a=DWT->CYCCNT;
            for(unsigned j=0;j<256;j++)sink=probe_div(va,vb);
            uint32_t b=DWT->CYCCNT;
            if(t){if(b-a<best)best=b-a;if(b-a>worst)worst=b-a;}
        }
        printf("CT_DIV case=%u repeats=256 min=%u max=%u\n",c,best,worst);
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
    DWT->CYCCNT=0;DWT->CTRL|=1;__disable_irq();
    unsigned failures=0;
    for(unsigned c=0;c<sizeof cases/sizeof cases[0];c++) {
        const struct kernel_case *p=&cases[c];size_t n=(size_t)1<<p->logn;
        uint64_t qt=0,ot=0,nt=0,oi=0,ni=0;
        for(size_t i=0;i<n;i++)fd[i]=to_double(p->f[i]);
        vect_FFT_fp64(p->logn,fd);vect_inv_mul2e_fft_fp64(p->logn,fd,p->e);
        for(size_t i=0;i<n;i++)ifft_in[i]=to_double(p->F[i]);
        vect_FFT_fp64(p->logn,ifft_in);vect_mul_fft_fp64(p->logn,ifft_in,fd);
        for(unsigned j=0;j<110;j++) {
            for(unsigned turn=0;turn<2;turn++) {
                unsigned old=turn^(j&1);
                memcpy(Fd,ifft_in,n*8);
                __DSB();__ISB();
                uint32_t a=DWT->CYCCNT;
                if(old)baseline_iFFT(p->logn,Fd);else vect_iFFT_fp64(p->logn,Fd);
                uint32_t b=DWT->CYCCNT;
                if(j>=10){if(old)oi+=b-a;else ni+=b-a;}
                for(size_t i=0;i<n;i++)Fd[i]=to_double(p->F[i]);
                __DSB();__ISB();
                a=DWT->CYCCNT;
                vect_FFT_fp64(p->logn,Fd);vect_mul_fft_fp64(p->logn,Fd,fd);
                if(old)baseline_iFFT(p->logn,Fd);else vect_iFFT_fp64(p->logn,Fd);
                uint32_t valid=1;
                for(size_t i=0;i<n;i++)kd[i]=fp64_round_i32_checked(Fd[i],&valid);
                valid &= fp64_k_update_ok(p->logn,kd);
                b=DWT->CYCCNT;
                if(!valid)return 7;
                if(j>=10){if(old)ot+=b-a;else nt+=b-a;}
                for(size_t i=0;i<n;i++)failures+=kd[i]!=p->k_fp64[i];
                /* Save on first backend, compare on second (order alternates). */
                if(turn==0)memcpy(oldout,Fd,n*8);
                else failures+=memcmp(oldout,Fd,n*8)!=0;
            }
            for(size_t i=0;i<n;i++){fq[i].v=p->f[i];Fq[i].v=p->F[i];}
            vect_FFT(p->logn,fq);vect_inv_mul2e_fft(p->logn,fq,p->e);
            __DSB();__ISB();
            uint32_t a=DWT->CYCCNT;
            vect_FFT(p->logn,Fq);vect_mul_fft(p->logn,Fq,fq);vect_iFFT(p->logn,Fq);
            for(size_t i=0;i<n;i++)kq[i]=fxr_round(Fq[i]);
            uint32_t b=DWT->CYCCNT;
            if(j>=10)qt+=b-a;
            for(size_t i=0;i<n;i++)failures+=kq[i]!=p->k_fixed[i];
        }
        printf("KERNEL case=%u logn=%u fixed_reduce=%llu old_reduce=%llu new_reduce=%llu old_ifft=%llu new_ifft=%llu bitexact=%s\n",
            c,p->logn,(unsigned long long)qt,(unsigned long long)ot,(unsigned long long)nt,
            (unsigned long long)oi,(unsigned long long)ni,failures?"FAIL":"PASS");
    }
    ct_probe();__enable_irq();
    printf("KERNEL_DONE result=%u\n",failures);return failures?1:0;
}
