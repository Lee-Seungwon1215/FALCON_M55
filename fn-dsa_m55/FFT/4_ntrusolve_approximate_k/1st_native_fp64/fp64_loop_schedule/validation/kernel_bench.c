/* Test only: same image for fixed and two-double arithmetic. Includes this
 * candidate's C so the private exact divider is independently exercised. */
#include "kgen_fxp.c"
#include "kernel_cases.h"
#include "c_oracle.h"
#include "integer_oracle.h"
#include <cmsis_core.h>
#include <stm32n6xx.h>
#include <stdio.h>
#include <string.h>
static fxr fq[512],Fq[1024];
static fp64_exact fe[512],Fe[1024],fc[512],Fc[1024];
static int32_t kq[512],ke[512],kc[512];
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
__attribute__((noipa)) static uint64_t c_mul(uint64_t a,uint64_t b)
{return fp64e_raw(oracle_fp64e_mul(fp64e_from_raw(a),fp64e_from_raw(b)));}
__attribute__((noipa)) static uint64_t asm_mul(uint64_t a,uint64_t b)
{return fp64e_raw(fp64e_mul(fp64e_from_raw(a),fp64e_from_raw(b)));}
typedef uint64_t (*mul_fn)(uint64_t,uint64_t);
__attribute__((noipa)) static uint32_t time_mul(mul_fn fn,uint64_t a,uint64_t b)
{
    __DSB();__ISB();__asm__ volatile(".rept 32\n nop\n .endr" ::: "memory");
    uint32_t t=DWT->CYCCNT;
    for(unsigned j=0;j<256;j++)sink=fn(a,b);
    return DWT->CYCCNT-t;
}
__attribute__((noipa)) static uint32_t time_op(unsigned op,uint64_t a,uint64_t b)
{
    __DSB();__ISB();__asm__ volatile(".rept 32\n nop\n .endr" ::: "memory");
    uint32_t t=DWT->CYCCNT;
    for(unsigned j=0;j<256;j++)sink=native_op(op,a,b);
    return DWT->CYCCNT-t;
}
__attribute__((noipa)) static uint32_t time_transform(unsigned l,unsigned inverse,unsigned backend)
{
    __DSB();__ISB();__asm__ volatile(".rept 32\n nop\n .endr" ::: "memory");
    uint32_t t=DWT->CYCCNT;
    if(backend==0){if(inverse)vect_iFFT(l,Fq);else vect_FFT(l,Fq);}
    else if(backend==1){if(inverse)oracle_vect_iFFT_fp64_exact(l,Fc);else oracle_vect_FFT_fp64_exact(l,Fc);}
    else {if(inverse)vect_iFFT_fp64_exact(l,Fe);else vect_FFT_fp64_exact(l,Fe);}
    return DWT->CYCCNT-t;
}
static unsigned differential(void)
{
    uint64_t checksum=UINT64_C(0xcbf29ce484222325);
    for(unsigned j=0;j<1000000;j++) {
        uint64_t a=next64(),b=next64();
        fp64_exact result=fp64e_mul(fp64e_from_raw(a),fp64e_from_raw(b));
        fp64_exact want=oracle_fp64e_mul(fp64e_from_raw(a),fp64e_from_raw(b));
        if(result.hi!=want.hi || result.lo!=want.lo)return 1;
        uint64_t z=fp64e_raw(result);
        if(z!=fxr_mul((fxr){a},(fxr){b}).v)return 2;
        checksum=(checksum^z)*UINT64_C(0x100000001b3);
        if(j<100000) {
            if(native_op(1,a,b)!=a+b)return 3;
            if(native_op(2,a,b)!=fxr_div2e((fxr){a},1).v)return 4;
            uint64_t d=(b&UINT64_C(0x7fffffffffffffff))|UINT64_C(0x1000000000);
            if(j%100==0)d=0;
            if(native_op(3,a,d)!=inner_fxr_div(a,d))return 5;
        }
    }
    if(checksum!=MUL_ORACLE_CHECKSUM)return 6;
    uint64_t edges[192];unsigned count=0;
    edges[count++]=0;edges[count++]=1;edges[count++]=UINT64_MAX;
    for(unsigned bit=1;bit<64;bit++) {
        uint64_t t=UINT64_C(1)<<bit;
        edges[count++]=t-1;edges[count++]=t;edges[count++]=t+1;
    }
    for(unsigned i=0;i<count;i++)for(unsigned j=0;j<count;j++) {
        uint64_t a=edges[i],b=edges[j];
        if(asm_mul(a,b)!=c_mul(a,b) || asm_mul(a,b)!=fixed_mul(a,b))return 7;
    }
    printf("BOARD_DIFF random_pairs=1000000 edge_pairs=%u checksum=%016llx result=0\n",count*count,(unsigned long long)checksum);return 0;
}
static unsigned timing(void)
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
    mul_fn funcs[3]={fixed_mul,c_mul,asm_mul};
    for(unsigned c=0;c<20;c++)for(unsigned order=0;order<3;order++) {
        unsigned backend=(order+c)%3;uint32_t lo=~0u,hi=0;
        for(unsigned trial=0;trial<21;trial++) {
            __set_FPSCR(__get_FPSCR()&~0x9fu);
            uint32_t elapsed=time_mul(funcs[backend],v[c],v[(c+3)%20]);
            if(trial){if(elapsed<lo)lo=elapsed;if(elapsed>hi)hi=elapsed;}
        }
        printf("MUL backend=%u case=%u repeats=256 min=%u max=%u\n",backend,c,lo,hi);
    }
    for(unsigned l=1;l<=10;l++)for(unsigned c=0;c<20;c++) {
        size_t n=(size_t)1<<l;
        for(size_t i=0;i<n;i++)inputs[i]=c<2?v[c*4]:v[(i+c)%20];
        for(unsigned inv=0;inv<2;inv++) {
          for(size_t i=0;i<n;i++){Fq[i].v=inputs[i];Fc[i]=Fe[i]=fp64e_from_raw(inputs[i]);}
          if(inv){vect_iFFT(l,Fq);oracle_vect_iFFT_fp64_exact(l,Fc);vect_iFFT_fp64_exact(l,Fe);}
          else {vect_FFT(l,Fq);oracle_vect_FFT_fp64_exact(l,Fc);vect_FFT_fp64_exact(l,Fe);}
          for(size_t i=0;i<n;i++)if(Fq[i].v!=fp64e_raw(Fc[i]) || Fq[i].v!=fp64e_raw(Fe[i])) {
              printf("FFT_DIFF_FAIL logn=%u inverse=%u case=%u index=%u\n",l,inv,c,(unsigned)i);
              return 1;
          }
          for(unsigned backend=0;backend<3;backend++) {
            uint32_t lo=~0u,hi=0;
            for(unsigned t=0;t<21;t++) {
                for(size_t i=0;i<n;i++){Fq[i].v=inputs[i];Fc[i]=Fe[i]=fp64e_from_raw(inputs[i]);}
                __set_FPSCR(__get_FPSCR()&~0x9fu);
                uint32_t e=time_transform(l,inv,backend);sink=backend==0?Fq[0].v:fp64e_raw(backend==1?Fc[0]:Fe[0]);
                if(t){if(e<lo)lo=e;if(e>hi)hi=e;}
            }
            printf("CT_FFT backend=%u logn=%u inverse=%u case=%u min=%u max=%u\n",backend,l,inv,c,lo,hi);
          }
        }
    }
    printf("FFT_DIFF coefficient_positions=81840 backends=3 result=0\n");
    return 0;
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
        if(n>512)return 11;
        uint64_t qp=0,qr=0,ep=0,er=0,cp=0,cr=0;
        for(unsigned j=0;j<110;j++) {
            for(size_t i=0;i<n;i++){fq[i].v=p->f[i];Fq[i].v=p->F[i];fc[i]=fe[i]=fp64e_from_raw(p->f[i]);Fc[i]=Fe[i]=fp64e_from_raw(p->F[i]);}
            for(unsigned turn=0;turn<3;turn++) {
                unsigned backend=(turn+j)%3;__DSB();__ISB();uint32_t a=DWT->CYCCNT,b,d;
                if(!backend) {
                    vect_FFT(p->logn,fq);vect_inv_mul2e_fft(p->logn,fq,p->e);b=DWT->CYCCNT;
                    vect_FFT(p->logn,Fq);vect_mul_fft(p->logn,Fq,fq);vect_iFFT(p->logn,Fq);
                    for(size_t i=0;i<n;i++)kq[i]=fxr_round(Fq[i]);d=DWT->CYCCNT;
                    if(j>=10){qp+=b-a;qr+=d-b;}
                } else if(backend==1) {
                    oracle_vect_FFT_fp64_exact(p->logn,fc);oracle_vect_inv_mul2e_fft_fp64_exact(p->logn,fc,p->e);b=DWT->CYCCNT;
                    oracle_vect_FFT_fp64_exact(p->logn,Fc);oracle_vect_mul_fft_fp64_exact(p->logn,Fc,fc);oracle_vect_iFFT_fp64_exact(p->logn,Fc);
                    for(size_t i=0;i<n;i++)kc[i]=fp64e_round(Fc[i]);d=DWT->CYCCNT;
                    if(j>=10){cp+=b-a;cr+=d-b;}
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
                failures+=(fq[i].v!=fp64e_raw(fc[i]))+(Fq[i].v!=fp64e_raw(Fc[i]))+(kc[i]!=p->k_fixed[i]);
            }
        }
        printf("KERNEL case=%u logn=%u fixed_prepare=%llu c_prepare=%llu asm_prepare=%llu fixed_reduce=%llu c_reduce=%llu asm_reduce=%llu bitexact=%s\n",
            c,p->logn,(unsigned long long)qp,(unsigned long long)cp,(unsigned long long)ep,(unsigned long long)qr,(unsigned long long)cr,(unsigned long long)er,failures?"FAIL":"PASS");
    }
    failures+=timing();__enable_irq();printf("KERNEL_DONE result=%u\n",failures);return failures?1:0;
}
