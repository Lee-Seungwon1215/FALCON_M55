/* Frozen real NTRU inputs; isolated stagewise comparison, not an oracle
 * fallback in production. Sources: historical fft_native_fp64 cases.h.
 * Reporting a difference does not modify input or expected original k. */
#include "kgen_inner.h"
#include "kgen_ds.h"
#include <stdio.h>
#include <string.h>
#include "frozen_cases.inc"
#include <cmsis_core.h>
#include <stm32n6xx.h>
static fxr rf[1024],rF[1024],obs[1024];
static fndsa_ds_workspace df __attribute__((aligned(16))),dF __attribute__((aligned(16)));
static unsigned total_kdiff;
static void report(unsigned ci,unsigned stage,unsigned logn,const fxr *ref,const fndsa_ds_workspace *got){
    size_t n=(size_t)1<<logn;unsigned diff=0,kdiff=0,first=1024;uint64_t mx=0;
    int export_valid=fndsa_ds_export(logn,obs,got);
    for(size_t i=0;i<n;i++){
        int64_t de=(int64_t)(obs[i].v-ref[i].v);uint64_t er=de<0?-(uint64_t)de:(uint64_t)de;
        if(er){diff++;if(first==1024)first=(unsigned)i;if(er>mx)mx=er;}
        kdiff+=fxr_round(obs[i])!=fxr_round(ref[i]);
    }
    printf("B_FIXTURE case=%u name=%s logn=%u stage=%u export_valid=%d diff=%u max_lsb=%llu kdiff=%u first=%u",ci,cases[ci].name,logn,stage,export_valid,diff,(unsigned long long)mx,kdiff,first);
    if(first<n)printf(" ref=%016llx got=%016llx ref_k=%d got_k=%d",(unsigned long long)ref[first].v,(unsigned long long)obs[first].v,fxr_round(ref[first]),fxr_round(obs[first]));
    puts("");if(stage==5)total_kdiff+=kdiff;
}
int mlk_test_main(int argc,char **argv){
    (void)argc;(void)argv;unsigned ran=0;
    if(SystemCoreClock!=800000000u || (SCB->CCR&0x30000u) || *(volatile unsigned*)0x56008008!=0x99u || (__get_FPSCR()&0x1C00000u))return 10;
    unsigned boundary_count=0,boundary_bad=0;
    const int mids[]={-1024,-2,-1,0,1,1024};
    const float eps[]={-0x1p-31f,-0x1p-32f,-0x1p-33f,-0x1p-48f,0,0x1p-48f,0x1p-33f,0x1p-32f,0x1p-31f};
    for(unsigned m=0;m<sizeof mids/sizeof mids[0];m++)for(unsigned j=0;j<sizeof eps/sizeof eps[0];j++){
        memset(&df,0,sizeof df);df.re[0][0]=(float)mids[m]+0.5f;df.re[1][0]=eps[j];
        fndsa_ds_export(4,obs,&df);
        /* floor(eps*2^32+.5) is exact in this constructed power-of-two set. */
        int32_t corr=(int32_t)__builtin_floor((double)eps[j]*0x1p32+0.5);
        uint64_t expected=((uint64_t)(int64_t)mids[m]<<32)+UINT64_C(0x80000000)+(uint64_t)(int64_t)corr;
        boundary_count++;boundary_bad+=obs[0].v!=expected;
    }
    printf("B_BOUNDARY count=%u mismatches=%u\n",boundary_count,boundary_bad);
    memset(&df,0,sizeof df);df.re[0][0]=0x1p-33f;df.re[1][0]=-0x1p-62f;
    int edge_ok=fndsa_ds_export(4,obs,&df);
    printf("B_EXPORT_REGRESSION valid=%d raw=%016llx expected=0000000000000000\n",edge_ok,(unsigned long long)obs[0].v);
    unsigned invalid_bad=0;
    const uint32_t invalid_bits[]={0x7fc00000u,0x7f800000u,0xff800000u,0x4f000000u,0xcf000001u};
    for(unsigned j=0;j<sizeof invalid_bits/sizeof invalid_bits[0];j++){
        union{uint32_t u;float f;}x={invalid_bits[j]};memset(&df,0,sizeof df);df.re[0][0]=x.f;
        invalid_bad+=fndsa_ds_export(4,obs,&df)!=0;
    }
    memset(&df,0,sizeof df);int zero_ok=fndsa_ds_reciprocal(4,&df,4);
    printf("B_DOMAIN invalid_cases=5 accepted=%u zero_norm_accepted=%d\n",invalid_bad,zero_ok);
    for(unsigned ci=0;ci<sizeof cases/sizeof cases[0];ci++){
        const struct fft_case *c=&cases[ci];unsigned logn=c->logn;if(logn<4)continue;
        size_t n=(size_t)1<<logn;
        for(size_t i=0;i<n;i++){rf[i].v=c->f[i];rF[i].v=c->F[i];}
        fndsa_ds_import(logn,&df,rf);fndsa_ds_import(logn,&dF,rF);
        report(ci,0,logn,rf,&df);
        vect_FFT(logn,rf);fndsa_ds_forward(logn,&df);report(ci,1,logn,rf,&df);
        vect_inv_mul2e_fft(logn,rf,c->e);fndsa_ds_reciprocal(logn,&df,c->e);report(ci,2,logn,rf,&df);
        if(c->fixed_inverse){fndsa_ds_import(logn,&df,rf);puts("B_FIXTURE_NOTE fixed_inverse_case_imports_original_inverse_for_residual_isolation");}
        vect_FFT(logn,rF);fndsa_ds_forward(logn,&dF);report(ci,3,logn,rF,&dF);
        vect_mul_fft(logn,rF,rf);fndsa_ds_mul(logn,&dF,&df);report(ci,4,logn,rF,&dF);
        vect_iFFT(logn,rF);fndsa_ds_inverse(logn,&dF);report(ci,5,logn,rF,&dF);
        ran++;
    }
    printf("B_FIXTURE_DONE cases=%u kdiff=%u\n",ran,total_kdiff);return 0;
}
