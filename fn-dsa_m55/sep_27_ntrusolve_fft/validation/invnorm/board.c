/* Isolated Q32-ABI native invnorm: conversions included in timed calls. */
#include "kgen_inner.h"
#include <stdio.h>
#include <string.h>
#if AUDIT_BOARD
#include <zephyr/kernel.h>
#include <cmsis_core.h>
#include <stm32n6xx.h>
#endif

static fxr a[1024], b[1024], actual[514], expected[514];
static fxr norm_a[1024], norm_b[1024];
static uint64_t state = UINT64_C(0x413137696e766e6f);
static unsigned random32(void)
{
    state ^= state << 13; state ^= state >> 7; state ^= state << 17;
    return (unsigned)state;
}

static unsigned finish_norm(unsigned logn, const fxr *inverse)
{
    size_t n=(size_t)1<<logn;
    memcpy(norm_a,a,n*sizeof(fxr)); memcpy(norm_b,b,n*sizeof(fxr));
    vect_adj_fft(logn,norm_a); vect_adj_fft(logn,norm_b);
    vect_mul_realconst(logn,norm_a,fxr_of(12289));
    vect_mul_realconst(logn,norm_b,fxr_of(12289));
    vect_mul_selfadj_fft(logn,norm_a,inverse);
    vect_mul_selfadj_fft(logn,norm_b,inverse);
    vect_iFFT_fixed(logn,norm_a); vect_iFFT_fixed(logn,norm_b);
    fxr sn=fxr_zero;
    for(size_t i=0;i<n;i++) sn=fxr_add(sn,fxr_add(fxr_sqr(norm_a[i]),fxr_sqr(norm_b[i])));
    return fxr_lt(sn,fxr_of_scaled32(UINT64_C(72107278641426)));
}

static void prepare(unsigned logn, unsigned cls, unsigned spectral)
{
    size_t n = (size_t)1 << logn;
    for (size_t i = 0; i < n; i++) {
        int x = (int)(random32()%31)-15, y = (int)(random32()%31)-15;
        if (cls < 8) { x = (int)(1u << cls); y = (int)(1u << (7-cls)); }
        a[i] = fxr_of(x); b[i] = fxr_of(y);
        if (!spectral && cls >= 8) {
            a[i].v += random32(); b[i].v += random32();
        }
    }
    if (spectral) {
        /* Odd sums rule out the zero polynomial; retain small integer input. */
        int sa = 0, sb = 0;
        for (size_t i = 0; i < n; i++) {
            sa += (int32_t)(a[i].v >> 32); sb += (int32_t)(b[i].v >> 32);
        }
        a[0] = fxr_add(a[0], fxr_of(1-(sa & 1)));
        b[0] = fxr_add(b[0], fxr_of(1-(sb & 1)));
        vect_FFT_fixed(logn, a); vect_FFT_fixed(logn, b);
    }
}

#if AUDIT_BOARD
static volatile uint64_t sink;
static uint32_t ticks(void) { __DSB(); __ISB(); return DWT->CYCCNT; }
static uint32_t measure(unsigned logn, unsigned old)
{
    unsigned irq = irq_lock(); uint32_t t = ticks();
    if (old) vect_invnorm_fft_fixed(logn, actual+1, a, b, 0);
    else vect_invnorm_fft(logn, actual+1, a, b, 0);
    uint32_t elapsed = ticks()-t; irq_unlock(irq);
    sink ^= actual[1].v; return elapsed;
}
#endif

int mlk_test_main(int argc, char **argv)
{
    (void)argc; (void)argv;
    unsigned mismatches=0, guards=0, fallback=0, decisions=0, decision_failures=0;
    uint64_t values=0, max_error=0;
#if AUDIT_BOARD
    if (SystemCoreClock!=800000000u || (SCB->CCR&0x30000u)
        || *(volatile unsigned*)0x56008008!=0x99u || (__get_FPSCR()&0x1C00000u)) return 10;
    CoreDebug->DEMCR |= CoreDebug_DEMCR_TRCENA_Msk; DWT->CTRL |= DWT_CTRL_CYCCNTENA_Msk;
#endif
    for (unsigned logn=1; logn<=10; logn++) {
        size_t hn = (size_t)1 << (logn-1);
        for (unsigned spectral=0; spectral<2; spectral++) for (unsigned cls=0; cls<64; cls++) {
            prepare(logn,cls,spectral);
            for (unsigned i=0;i<514;i++) actual[i].v=expected[i].v=UINT64_C(0xa55a771122334455);
            vect_invnorm_fft_fixed(logn,expected+1,a,b,0);
            vect_invnorm_fft(logn,actual+1,a,b,0);
            for (size_t i=0;i<hn;i++) {
                int64_t delta=(int64_t)(actual[i+1].v-expected[i+1].v);
                uint64_t err=delta<0?-(uint64_t)delta:(uint64_t)delta;
                values++; if (err) mismatches++; if (err>max_error) max_error=err;
            }
            if (actual[0].v!=expected[0].v || memcmp(actual+hn+1,expected+hn+1,(513-hn)*sizeof(fxr))) guards++;
            if (spectral) {
                decisions++;
                if (finish_norm(logn,actual+1)!=finish_norm(logn,expected+1)) decision_failures++;
            }
            vect_invnorm_fft_fixed(logn,expected+1,a,b,1);
            vect_invnorm_fft(logn,actual+1,a,b,1);
            if (memcmp(actual,expected,sizeof actual)) fallback++;
        }
    }
    printf("INVNORM_ACCURACY values=%llu differences=%u max_q32_error=%llu guard_failures=%u fallback_failures=%u\n",
        (unsigned long long)values,mismatches,(unsigned long long)max_error,guards,fallback);
    printf("INVNORM_DECISIONS cases=%u failures=%u\n",decisions,decision_failures);
#if AUDIT_BOARD
    for (unsigned logn=9;logn<=10;logn++) {
        prepare(logn,31,1);
        uint64_t old_sum=0,new_sum=0;
        for (unsigned w=0;w<10;w++) { measure(logn,1); measure(logn,0); }
        for (unsigned t=0;t<100;t++) { old_sum+=measure(logn,1); new_sum+=measure(logn,0); }
        printf("INVNORM_PERF degree=%u calls=100 fixed_total=%llu current_total=%llu\n",1u<<logn,
            (unsigned long long)old_sum,(unsigned long long)new_sum);
        for (unsigned cls=0;cls<32;cls++) {
            prepare(logn,cls,0);
            /* Positive, normal, representable reciprocal; exercise different
             * exponents and integer/fractional parts without exceptional FP. */
            if (cls>=8 && cls<16) {
                for (unsigned i=0;i<(1u<<logn);i++)
                    a[i].v=b[i].v=UINT64_C(1)<<(18+cls-8);
            }
            if (cls>=16 && cls<24) {
                for (unsigned i=0;i<(1u<<logn);i++) {
                    a[i]=fxr_of(1<<(7+cls-16)); b[i]=fxr_of(1);
                }
            }
            uint32_t lo=UINT32_MAX,hi=0;
            for (unsigned t=0;t<20;t++) { uint32_t x=measure(logn,0); if(x<lo)lo=x;if(x>hi)hi=x; }
            printf("INVNORM_TIMING degree=%u class=%u trials=20 min=%u max=%u\n",1u<<logn,cls,lo,hi);
        }
    }
#endif
    printf("INVNORM_DONE guards=%u fallback=%u decisions=%u\n",guards,fallback,decision_failures);
    return guards || fallback || decision_failures;
}
#if !AUDIT_BOARD
int main(int argc,char **argv) { return mlk_test_main(argc,argv); }
#endif
