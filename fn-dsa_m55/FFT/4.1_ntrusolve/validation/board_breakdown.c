/* Diagnostic only: expose the exact current C stages within this TU.
 * Production source and arithmetic are not edited. Renaming only avoids
 * colliding with the actual functions, which remain in the same ELF.
 */
#define fndsa_vect_FFT_mve_q32 diag_duplicate_FFT
#define fndsa_vect_iFFT_mve_q32 diag_duplicate_iFFT
#include "../kgen_fft_mve.c"
#undef fndsa_vect_FFT_mve_q32
#undef fndsa_vect_iFFT_mve_q32
#include <stdio.h>
#include <cmsis_core.h>
#include <stm32n6xx.h>
void fndsa_vect_FFT_mve_q32(unsigned,fxr *);
void fndsa_vect_iFFT_mve_q32(unsigned,fxr *);
void ref_vect_FFT(unsigned,fxr *);
void ref_vect_iFFT(unsigned,fxr *);
static fxr input[1024], b[1024], expected[1024];
static uint32_t rng;
static volatile uint64_t sink;
static uint32_t rnd(void) {rng^=rng<<13;rng^=rng>>17;rng^=rng<<5;return rng;}
static inline uint32_t stamp(void) {
    __asm__ volatile("":::"memory");__DSB();__ISB();
    uint32_t v=DWT->CYCCNT;__asm__ volatile("":::"memory");return v;
}
/* Public logn/direction, same local workspace layout as production. */
static void __attribute__((noinline,noclone))
profile(unsigned lg,unsigned inverse,fxr *f,uint32_t out[4]) {
    ds_fft w __attribute__((aligned(16)));
    uint32_t t0=stamp();
    from_q32(lg,&w,f);
    uint32_t t1=stamp();
    if(inverse) ds_ifft_run(lg,&w); else ds_fft_run(lg,&w);
    uint32_t t2=stamp();
    to_q32(lg,f,&w);
    uint32_t t3=stamp();
    out[0]=t1-t0;out[1]=t2-t1;out[2]=t3-t2;out[3]=t3-t0;
}
static uint32_t __attribute__((noinline,noclone))
measure(unsigned backend,unsigned lg,unsigned inverse) {
    uint32_t t=stamp();
    if(backend==0) {
        if(inverse)ref_vect_iFFT(lg,b);else ref_vect_FFT(lg,b);
    } else if(backend==1) {
        if(inverse)fndsa_vect_iFFT_mve_q32(lg,b);else fndsa_vect_FFT_mve_q32(lg,b);
    } else {
        if(inverse)diag_duplicate_iFFT(lg,b);else diag_duplicate_FFT(lg,b);
    }
    uint32_t c=stamp()-t;sink^=b[0].v;return c;
}
int mlk_test_main(int argc,char **argv) {
    (void)argc;(void)argv;
    if(SystemCoreClock!=800000000u || (SCB->CCR&0x30000u)
        || *(volatile unsigned*)0x56008008!=0x99u || (__get_FPSCR()&0x1C00000u))return 10;
    CoreDebug->DEMCR|=CoreDebug_DEMCR_TRCENA_Msk;DWT->CTRL|=DWT_CTRL_CYCCNTENA_Msk;
    unsigned count=0,bad=0;
    for(unsigned lg=9;lg<=10;lg++)for(unsigned inv=0;inv<2;inv++) {
        size_t n=(size_t)1<<lg;
        uint64_t total[3]={0},phase[4]={0};
        uint32_t low[3]={UINT32_MAX,UINT32_MAX,UINT32_MAX},high[3]={0};
        rng=0x8936217u^(lg<<16)^(inv<<24);
        for(unsigned j=0;j<110;j++) {
            for(size_t i=0;i<n;i++) {
                input[i]=fxr_of((int32_t)(rnd()%63)-31);
                if(j&1)input[i].v+=rnd();
            }
            if(inv)ref_vect_FFT(lg,input);
            memcpy(expected,input,n*sizeof(fxr));
            if(inv)fndsa_vect_iFFT_mve_q32(lg,expected);
            else fndsa_vect_FFT_mve_q32(lg,expected);
            for(unsigned ix=0;ix<3;ix++) {
                unsigned be=(ix+(j&1))%3;
                memcpy(b,input,n*sizeof(fxr));
                unsigned irq=__get_PRIMASK();__disable_irq();
                uint32_t elapsed=measure(be,lg,inv);
                if(!irq)__enable_irq();
                if(be && memcmp(b,expected,n*sizeof(fxr)))bad++;
                if(j>=10) {
                    total[be]+=elapsed;
                    if(elapsed<low[be])low[be]=elapsed;if(elapsed>high[be])high[be]=elapsed;
                }
            }
            memcpy(b,input,n*sizeof(fxr));uint32_t p[4];
            unsigned irq=__get_PRIMASK();__disable_irq();
            profile(lg,inv,b,p);
            if(!irq)__enable_irq();
            if(memcmp(b,expected,n*sizeof(fxr)))bad++;
            if(j>=10) {for(unsigned k=0;k<4;k++)phase[k]+=p[k];count++;}
        }
        printf("BREAKDOWN n=%u inverse=%u calls=100 ref=%llu actual=%llu duplicate=%llu input=%llu core=%llu output=%llu profiled=%llu mismatches=%u\n",
            1u<<lg,inv,(unsigned long long)total[0],(unsigned long long)total[1],(unsigned long long)total[2],
            (unsigned long long)phase[0],(unsigned long long)phase[1],(unsigned long long)phase[2],(unsigned long long)phase[3],bad);
        for(unsigned be=0;be<3;be++)printf("BREAKDOWN_RANGE n=%u inverse=%u backend=%u min=%u max=%u\n",1u<<lg,inv,be,low[be],high[be]);
    }
    printf("BREAKDOWN_DONE calls=%u mismatches=%u\n",count,bad);return bad!=0;
}
