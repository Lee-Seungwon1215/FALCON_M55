/* Both original fixed and native double paths in ONE firmware.
 * Hash all raw stage outputs; the host/board comparison is bit-for-bit.
 */
#include "kgen_inner.h"
#include <stdio.h>
#include <string.h>
#include "cases.h"
#ifdef AUDIT_BOARD
#include <cmsis_core.h>
#include <stm32n6xx.h>
#endif
static fxr fq[1024], Fq[1024], zq[512];
static double fd[1024], Fd[1024], zd[512];
static int32_t kq[1024], kd[1024];
static double as_double(uint64_t x)
{
    return (double)(int32_t)(x>>32)+(double)(uint32_t)x*0x1p-32;
}
static uint64_t bits(double x) { uint64_t u; memcpy(&u,&x,8); return u; }
static void report(const char *name,const char *stage,const fxr *q,const double *d,size_t n)
{
    uint64_t hq=UINT64_C(0xcbf29ce484222325),hd=hq;
    unsigned diffs=0, first=(unsigned)n;
    for(size_t i=0;i<n;i++) {
        hq=(hq^q[i].v)*UINT64_C(0x100000001b3);
        hd=(hd^bits(d[i]))*UINT64_C(0x100000001b3);
        if(as_double(q[i].v)!=d[i]) { diffs++; if(first==n)first=i; }
    }
    printf("AUDIT_STAGE case=%s stage=%s n=%u fixed=%016llx fp64=%016llx differences=%u first=%u\n",
           name,stage,(unsigned)n,(unsigned long long)hq,(unsigned long long)hd,diffs,first);
    if(strcmp(name,"512-test43")==0 || strncmp(name,"residual-",9)==0) {
        size_t i=first==n?0:first;
        printf("AUDIT_VALUE case=%s stage=%s index=%u fixed_raw=%016llx fp64_bits=%016llx\n",
               name,stage,(unsigned)i,(unsigned long long)q[i].v,(unsigned long long)bits(d[i]));
    }
}
static int run(void)
{
    printf("AUDIT_BEGIN scalar_double_bytes=%u complex_bytes=%u\n",(unsigned)sizeof(double),(unsigned)sizeof(fp64c));
    for(unsigned c=0;c<sizeof cases/sizeof cases[0];c++) {
        const struct fft_case *p=&cases[c]; size_t n=(size_t)1<<p->logn,hn=n>>1;
        for(size_t i=0;i<n;i++) { fq[i].v=p->f[i]; Fq[i].v=p->F[i]; fd[i]=as_double(p->f[i]); Fd[i]=as_double(p->F[i]); }
        report(p->name,"input_f",fq,fd,n); report(p->name,"input_F",Fq,Fd,n);
        vect_FFT(p->logn,fq); vect_FFT_fp64(p->logn,fd);
        report(p->name,"FFT_f",fq,fd,n);
        for(size_t i=0;i<hn;i++) {
            zq[i]=fxr_add(fxr_sqr(fq[i]),fxr_sqr(fq[i+hn]));
#ifdef FP64Q_EXPERIMENTAL_DIAGNOSTIC
            zd[i]=fp64q_add(fp64q_mul(fd[i],fd[i]),fp64q_mul(fd[i+hn],fd[i+hn]));
#else
            zd[i]=fd[i]*fd[i]+fd[i+hn]*fd[i+hn];
#endif
        }
        report(p->name,"norm",zq,zd,hn);
        vect_inv_mul2e_fft(p->logn,fq,p->e); vect_inv_mul2e_fft_fp64(p->logn,fd,p->e);
        report(p->name,"inverse_native",fq,fd,n);
        /* Diagnostic control only, never a production fallback. */
        if(p->fixed_inverse)for(size_t i=0;i<n;i++)fd[i]=as_double(fq[i].v);
        report(p->name,"inverse_used",fq,fd,n);
        vect_FFT(p->logn,Fq); vect_FFT_fp64(p->logn,Fd);
        report(p->name,"FFT_F",Fq,Fd,n);
        vect_mul_fft(p->logn,Fq,fq); vect_mul_fft_fp64(p->logn,Fd,fd);
        report(p->name,"pointwise",Fq,Fd,n);
        vect_iFFT(p->logn,Fq); vect_iFFT_fp64(p->logn,Fd);
        report(p->name,"iFFT",Fq,Fd,n);
        unsigned diffs=0;uint32_t valid=1;
        for(size_t i=0;i<n;i++) {
            kq[i]=fxr_round(Fq[i]);kd[i]=fp64_round_i32_checked(Fd[i],&valid);
            if(kq[i]!=kd[i]) {
                if(diffs<4)printf("AUDIT_K_VALUE case=%s index=%u fixed=%ld fp64=%ld\n",p->name,(unsigned)i,(long)kq[i],(long)kd[i]);
                diffs++;
            }
        }
        printf("AUDIT_K case=%s differences=%u valid=%u\n",p->name,diffs,(unsigned)valid);
    }
    printf("AUDIT_DONE result=0 cases=%u\n",(unsigned)(sizeof cases/sizeof cases[0]));
    return 0;
}
#ifdef AUDIT_BOARD
int mlk_test_main(int argc,char **argv)
{
    (void)argc;(void)argv;
    printf("AUDIT_HW cpu=%u fpscr=%08x ccr=%08x tcm=%08x\n",(unsigned)SystemCoreClock,(unsigned)__get_FPSCR(),(unsigned)SCB->CCR,*(volatile unsigned*)0x56008008);
    if(SystemCoreClock!=800000000u || (SCB->CCR&0x30000u) || *(volatile unsigned*)0x56008008!=0x99u || (__get_FPSCR()&0x1C00000u))return 10;
    __disable_irq();int r=run();__enable_irq();return r;
}
#else
int main(void) { return run(); }
#endif
