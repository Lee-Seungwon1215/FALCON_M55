/* Test only: same image for fixed and two-double arithmetic. Includes this
 * candidate's C so the private exact divider is independently exercised. */
#include "../kgen_fxp.c"
#include "kernel_cases.h"
#include <cmsis_core.h>
#include <stm32n6xx.h>
#include <stdio.h>
#include <string.h>
static fxr fq[1024],Fq[1024];
static fp64_exact fe[1024],Fe[1024];
static int32_t kq[1024],ke[1024];
static uint64_t inputs[1024];
static volatile uint64_t sink;
static uint64_t state=UINT64_C(0x853c49e6748fea9b);
static uint64_t next64(void){state^=state<<13;state^=state>>7;state^=state<<17;return state;}
__attribute__((noipa)) static uint64_t native_op(unsigned op,uint64_t a,uint64_t b)
{
    fp64_exact x=fp64e_from_raw(a),y=fp64e_from_raw(b);
    if(op==0)return fp64e_raw(fp64e_mul(x,y));
    if(op==1)return fp64e_raw(fp64e_add(x,y));
    if(op==2)return fp64e_raw(fp64e_half(x));
    return fxr_div_fp64_exact(a,b);
}
__attribute__((noipa)) static uint64_t fixed_mul(uint64_t a,uint64_t b)
{return fxr_mul((fxr){a},(fxr){b}).v;}
__attribute__((noipa)) static uint32_t time_op(unsigned op,uint64_t a,uint64_t b)
{
    __DSB();__ISB();__asm__ volatile(".rept 32\n nop\n .endr" ::: "memory");
    uint32_t t=DWT->CYCCNT;
    for(unsigned j=0;j<256;j++)sink=native_op(op,a,b);
    return DWT->CYCCNT-t;
}
__attribute__((noipa)) static uint32_t time_transform(unsigned l,unsigned inverse)
{
    __DSB();__ISB();__asm__ volatile(".rept 32\n nop\n .endr" ::: "memory");
    uint32_t t=DWT->CYCCNT;
    if(inverse)vect_iFFT_fp64_exact(l,Fe);else vect_FFT_fp64_exact(l,Fe);
    return DWT->CYCCNT-t;
}
static unsigned differential(void)
{
    for(unsigned j=0;j<100000;j++) {
        uint64_t a=next64(),b=next64();
        if(native_op(0,a,b)!=fxr_mul((fxr){a},(fxr){b}).v)return 1;
        if(native_op(1,a,b)!=a+b)return 2;
        if(native_op(2,a,b)!=fxr_div2e((fxr){a},1).v)return 3;
        uint64_t d=(b&UINT64_C(0x7fffffffffffffff))|UINT64_C(0x1000000000);
        if(j%100==0)d=0;
        if(native_op(3,a,d)!=inner_fxr_div(a,d))return 4;
    }
    printf("BOARD_DIFF pairs=100000 operations=400000 result=0\n");return 0;
}
static void timing(void)
{
    static const uint64_t v[]={0,1,2,3,UINT64_MAX,UINT64_MAX-1,UINT64_C(0x8000000000000000),
        UINT64_C(0x7fffffffffffffff),UINT64_C(0x100000000),UINT64_C(0xffffffff),
        UINT64_C(0xaaaaaaaaaaaaaaaa),UINT64_C(0x5555555555555555),
        UINT64_C(0x80000000),UINT64_C(0x10000),UINT64_C(0xffff),
        UINT64_C(0x123456789abcdef0),UINT64_C(0x00000000ffff0000),
        UINT64_C(0xffff000000000000),UINT64_C(0x8000000000000001),UINT64_C(0xffffffff00000000)};
    for(unsigned op=0;op<4;op++)for(unsigned c=0;c<20;c++) {
        uint64_t a=v[c],b=v[(c+3)%20];
        if(op==3)b=c==0?0:((b&UINT64_C(0x7fffffffffffffff))|UINT64_C(0x1000000000));
        uint32_t lo=~0u,hi=0;
        for(unsigned t=0;t<21;t++) {
            __set_FPSCR(__get_FPSCR()&~0x9fu);
            uint32_t e=time_op(op,a,b);
            if(t){if(e<lo)lo=e;if(e>hi)hi=e;}
        }
        printf("CT_OP op=%u case=%u repeats=256 min=%u max=%u\n",op,c,lo,hi);
    }
    uint32_t t=DWT->CYCCNT;
    for(unsigned j=0;j<256;j++)sink=fixed_mul(v[15],v[10]);
    printf("FIXED_MUL repeats=256 cycles=%u\n",(unsigned)(DWT->CYCCNT-t));
    for(unsigned l=1;l<=10;l++)for(unsigned c=0;c<20;c++) {
        size_t n=(size_t)1<<l;
        for(size_t i=0;i<n;i++)inputs[i]=c<2?v[c*4]:v[(i+c)%20];
        for(unsigned inv=0;inv<2;inv++) {
            uint32_t lo=~0u,hi=0;
            for(unsigned t=0;t<21;t++) {
                for(size_t i=0;i<n;i++)Fe[i]=fp64e_from_raw(inputs[i]);
                __set_FPSCR(__get_FPSCR()&~0x9fu);
                uint32_t e=time_transform(l,inv);sink=fp64e_raw(Fe[0]);
                if(t){if(e<lo)lo=e;if(e>hi)hi=e;}
            }
            printf("CT_FFT logn=%u inverse=%u case=%u min=%u max=%u\n",l,inv,c,lo,hi);
        }
    }
}
int mlk_test_main(int argc,char **argv)
{
    (void)argc;(void)argv;
    printf("KERNEL_BEGIN cpu=%u fpscr=%08x repeats=100\n",(unsigned)SystemCoreClock,(unsigned)__get_FPSCR());
    if(SystemCoreClock!=800000000u || (SCB->CCR&0x30000u) || *(volatile unsigned*)0x56008008!=0x99u || (__get_FPSCR()&0x1C00000u))return 10;
    CoreDebug->DEMCR|=1u<<24;*(volatile unsigned*)0xE0001FB0=0xC5ACCE55;DWT->CYCCNT=0;DWT->CTRL|=1;__disable_irq();
    unsigned failures=differential();if(failures)return failures;
    for(unsigned c=0;c<sizeof cases/sizeof cases[0];c++) {
        const struct kernel_case *p=&cases[c];size_t n=(size_t)1<<p->logn;
        uint64_t qp=0,qr=0,ep=0,er=0;
        for(unsigned j=0;j<110;j++) {
            for(size_t i=0;i<n;i++){fq[i].v=p->f[i];Fq[i].v=p->F[i];fe[i]=fp64e_from_raw(p->f[i]);Fe[i]=fp64e_from_raw(p->F[i]);}
            for(unsigned turn=0;turn<2;turn++) {
                unsigned backend=turn^(j&1);__DSB();__ISB();uint32_t a=DWT->CYCCNT,b,d;
                if(!backend) {
                    vect_FFT(p->logn,fq);vect_inv_mul2e_fft(p->logn,fq,p->e);b=DWT->CYCCNT;
                    vect_FFT(p->logn,Fq);vect_mul_fft(p->logn,Fq,fq);vect_iFFT(p->logn,Fq);
                    for(size_t i=0;i<n;i++)kq[i]=fxr_round(Fq[i]);d=DWT->CYCCNT;
                    if(j>=10){qp+=b-a;qr+=d-b;}
                } else {
                    vect_FFT_fp64_exact(p->logn,fe);vect_inv_mul2e_fft_fp64_exact(p->logn,fe,p->e);b=DWT->CYCCNT;
                    vect_FFT_fp64_exact(p->logn,Fe);vect_mul_fft_fp64_exact(p->logn,Fe,fe);vect_iFFT_fp64_exact(p->logn,Fe);
                    for(size_t i=0;i<n;i++)ke[i]=fp64e_round(Fe[i]);d=DWT->CYCCNT;
                    if(j>=10){ep+=b-a;er+=d-b;}
                }
            }
            for(size_t i=0;i<n;i++) {
                failures+=(fq[i].v!=fp64e_raw(fe[i]))+(Fq[i].v!=fp64e_raw(Fe[i]));
                failures+=(kq[i]!=p->k_fixed[i])+(ke[i]!=p->k_fixed[i]);
            }
        }
        printf("KERNEL case=%u logn=%u fixed_prepare=%llu exact_prepare=%llu fixed_reduce=%llu exact_reduce=%llu bitexact=%s\n",
            c,p->logn,(unsigned long long)qp,(unsigned long long)ep,(unsigned long long)qr,(unsigned long long)er,failures?"FAIL":"PASS");
    }
    timing();__enable_irq();printf("KERNEL_DONE result=%u\n",failures);return failures?1:0;
}
