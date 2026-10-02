/* Independent original/native comparison. All setup and comparison are
 * outside timed regions; both functions receive identical input/address. */
#include "sign_inner.h"
#include <cmsis_core.h>
#include <stm32n6xx.h>
#include <stdio.h>
#include <limits.h>

void oracle_FFT(unsigned logn, fpr *f);
void oracle_iFFT(unsigned logn, fpr *f);
void native_c_FFT(unsigned logn, fpr *f);
void native_c_iFFT(unsigned logn, fpr *f);
typedef void (*transform)(unsigned, fpr *);
unsigned fft_abi_probe(transform f, unsigned logn, fpr *data);
static fpr input[1024], reference[1024];
static fpr arena[1026] __attribute__((aligned(32)));
static uint32_t samples[3][100];
static uint32_t rng = 0x5930AB19;
static unsigned failures, comparisons, guards;

static uint32_t next(void)
{
    rng ^= rng << 13; rng ^= rng >> 17; rng ^= rng << 5; return rng;
}
static fpr bits(double x) { fpr u; memcpy(&u, &x, 8); return u; }
static double real(fpr u) { double x; memcpy(&x, &u, 8); return x; }

static void fill(unsigned logn, unsigned kind)
{
    size_t n = (size_t)1 << logn;
    for (size_t j = 0; j < n; j++) {
        switch (kind % 8) {
        case 0: input[j] = 0; break;
        case 1: input[j] = (uint64_t)(j & 1) << 63; break;
        case 2: input[j] = bits(j == 0 ? 1.0 : 0.0); break;
        case 3: input[j] = bits((j & 1) ? -1.0 : 1.0); break;
        case 4: input[j] = bits((int32_t)(next() & 1023) - 512); break;
        case 5: input[j] = ((uint64_t)(next() & 1) << 63)
            | ((uint64_t)(983 + next() % 81) << 52)
            | ((uint64_t)(next() & 0xFFFFF) << 32) | next(); break;
        case 6: input[j] = UINT64_C(0x3FF0000000000000)
            + (next() & 15); if (j & 1) input[j] |= UINT64_C(1) << 63; break;
        default: input[j] = ((uint64_t)(next() & 1) << 63)
            | ((uint64_t)(823 + next() % 401) << 52)
            | ((uint64_t)(next() & 0xFFFFF) << 32) | next(); break;
        }
    }
}
static void prepare(unsigned logn)
{
    size_t n = (size_t)1 << logn;
    arena[0] = UINT64_C(0xCAFEBABE12345678);
    arena[n+1] = UINT64_C(0x12345678CAFEBABE);
    memcpy(arena+1, input, n*8);
}
static void guard(unsigned logn)
{
    size_t n = (size_t)1 << logn;
    guards += arena[0] != UINT64_C(0xCAFEBABE12345678)
        || arena[n+1] != UINT64_C(0x12345678CAFEBABE);
}
static void compare(unsigned logn, unsigned trial, unsigned inverse)
{
    size_t n = (size_t)1 << logn;
    memcpy(reference, input, n*8); prepare(logn);
    (inverse ? oracle_iFFT : oracle_FFT)(logn, reference);
    (inverse ? fpoly_iFFT : fpoly_FFT)(logn, arena+1);
    guard(logn); comparisons++;
    for (size_t j = 0; j < n; j++) if (reference[j] != arena[j+1]) {
        if (failures < 12) printf("FFT_DIFFERENCE logn=%u trial=%u inverse=%u index=%u ref=%016llx got=%016llx\n",
            logn,trial,inverse,(unsigned)j,(unsigned long long)reference[j],(unsigned long long)arena[j+1]);
        failures++;
    }
    prepare(logn);
    (inverse ? native_c_iFFT : native_c_FFT)(logn, arena+1);
    guard(logn);
    for (size_t j = 0; j < n; j++) if (reference[j] != arena[j+1]) {
        if (failures < 12) printf("NATIVE_C_DIFFERENCE logn=%u index=%u\n",logn,(unsigned)j);
        failures++;
    }
}
static uint32_t measure(transform f, unsigned logn)
{
    uint32_t mask = __get_PRIMASK(); __disable_irq();
    __DSB(); __ISB(); uint32_t t = DWT->CYCCNT;
    f(logn, arena+1);
    __DSB(); __ISB(); uint32_t d = DWT->CYCCNT-t;
    __set_PRIMASK(mask); return d;
}
static void sort(uint32_t *a)
{
    for (unsigned i=1;i<100;i++) { uint32_t v=a[i];unsigned j=i;
        while(j && a[j-1]>v){a[j]=a[j-1];j--;}a[j]=v; }
}

int mlk_test_main(int argc,char **argv)
{
    (void)argc;(void)argv;
    printf("FFT_HW cpu=%u fpscr=%08x ccr=%08x tcm=%08x\n",
        (unsigned)SystemCoreClock,(unsigned)__get_FPSCR(),(unsigned)SCB->CCR,
        *(volatile unsigned*)0x56008008);
    if(SystemCoreClock!=800000000u || (SCB->CCR&0x30000u)
        || *(volatile unsigned*)0x56008008!=0x99u || (__get_FPSCR()&0x1C00000u))return 10;
    CoreDebug->DEMCR |= CoreDebug_DEMCR_TRCENA_Msk;
    DWT->CTRL |= DWT_CTRL_CYCCNTENA_Msk;
    double max_error = 0;
    for (unsigned logn=1;logn<=10;logn++) {
        for(unsigned trial=0;trial<128;trial++) {
            fill(logn,trial);compare(logn,trial,0);compare(logn,trial,1);
            /* iFFT tested again on forward output; not only arbitrary data. */
            oracle_FFT(logn,input);compare(logn,trial,1);
        }
        fill(logn,4);prepare(logn);
        fpoly_FFT(logn,arena+1);fpoly_iFFT(logn,arena+1);guard(logn);
        for(unsigned j=0;j<(1u<<logn);j++) {
            double e=real(arena[j+1])-real(input[j]); if(e<0)e=-e;
            if(e>max_error)max_error=e;
        }
        printf("FFT_EXACT logn=%u trials=128 transforms=384 failures=%u guards=%u\n",logn,failures,guards);
    }
    printf("FFT_ROUNDTRIP integer_range=minus512_to_511 max_abs_error_bits=%016llx\n",
        (unsigned long long)bits(max_error));
    unsigned abi_failures=0;
    for(unsigned logn=1;logn<=10;logn++)for(unsigned inv=0;inv<2;inv++) {
        fill(logn,4);prepare(logn);
        abi_failures += fft_abi_probe(inv?fpoly_iFFT:fpoly_FFT,logn,arena+1)!=0;
        guard(logn);
    }
    failures += abi_failures;
    printf("FFT_ABI calls=20 failures=%u\n",abi_failures);
    for(unsigned logn=9;logn<=10;logn++) for(unsigned inv=0;inv<2;inv++) {
        transform f[3]={inv?oracle_iFFT:oracle_FFT,
            inv?native_c_iFFT:native_c_FFT,inv?fpoly_iFFT:fpoly_FFT};
        const char *names[3]={"original","native_c","asm"};
        fill(logn,4);if(inv)oracle_FFT(logn,input);
        for(unsigned w=0;w<3;w++)for(unsigned k=0;k<3;k++){prepare(logn);measure(f[k],logn);}
        uint64_t total[3]={0,0,0};
        for(unsigned i=0;i<100;i++)for(unsigned order=0;order<3;order++){
            unsigned k=(order+i)%3;prepare(logn);uint32_t d=measure(f[k],logn);
            samples[k][i]=d;total[k]+=d;guard(logn);
        }
        for(unsigned k=0;k<3;k++){sort(samples[k]);
            printf("FFT_PERF degree=%u inverse=%u implementation=%s calls=100 total=%llu median_lo=%u median_hi=%u min=%u max=%u\n",
                1u<<logn,inv,names[k],(unsigned long long)total[k],
                samples[k][49],samples[k][50],samples[k][0],samples[k][99]);}
        /* Empirical constant-time screen, not a proof: eight input classes,
           same code and addresses; warm FP state, interrupts masked. */
        for(unsigned kind=0;kind<8;kind++){
            uint64_t total_ct=0;uint32_t lo=UINT32_MAX,hi=0;
            for(unsigned i=0;i<100;i++){
                fill(logn,kind);prepare(logn);uint32_t d=measure(f[2],logn);
                if(d<lo)lo=d;
                if(d>hi)hi=d;
                total_ct+=d;guard(logn);
            }
            printf("FFT_CT degree=%u inverse=%u class=%u calls=100 total=%llu min=%u max=%u\n",
                1u<<logn,inv,kind,(unsigned long long)total_ct,lo,hi);
        }
    }
    printf("FFT_DONE comparisons=%u failures=%u guards=%u\n",comparisons,failures,guards);
    return failures || guards;
}
