/* Measurement only: unchanged TW stage 11 vs C (4.3), double I/O on both.
 * The fixed backend retains its original Q32 ABI. Preparing test inputs,
 * copying arrays, checking outputs and emitting logs are outside the timer.
 */
#include "bridge_workspace.h"
#include <cmsis_core.h>
#include <stm32n6xx.h>
#include <math.h>
#include <stdio.h>
#include <string.h>

#define REPEATS 100
#define WARMUP 10
#define BATCHES 5
#define CANARY UINT64_C(0x93abe02915c64d87)
#define LEAF __attribute__((noinline,noclone,aligned(16)))

void control_tw32_bridge_fft(unsigned logn, double *f);
void control_tw32_bridge_ifft(unsigned logn, double *f);

static struct {
    uint64_t before[4];
    double source[1024], data[1024], expected[1024];
    fxr fixed[1024];
    uint64_t after[4];
} buffers __attribute__((aligned(32)));
struct bridge_workspace bridge_shared_workspace __attribute__((aligned(32)));
#define c_poly bridge_shared_workspace.poly.c
#define tw_core_workspace bridge_shared_workspace.poly.tw
static volatile uint64_t sink;
static uint64_t rng_state;
static uint32_t random32(void)
{
    rng_state ^= rng_state << 13;
    rng_state ^= rng_state >> 7;
    rng_state ^= rng_state << 17;
    return (uint32_t)rng_state;
}

/* Same double-single splitting/reconstruction as TW's bridge, but using
 * C's native two-component workspace rather than the legacy 3-plane type.
 * No integer Q32 export, grid correction or round-to-k is added here.
 */
static void c_from_double(unsigned logn, const double *f)
{
    size_t hn = (size_t)1 << (logn-1);
    for (size_t i=0; i<hn; i++) {
        float r=(float)f[i], im=(float)f[i+hn];
        c_poly.re[0][i]=r;
        c_poly.re[1][i]=(float)(f[i]-(double)r);
        c_poly.im[0][i]=im;
        c_poly.im[1][i]=(float)(f[i+hn]-(double)im);
    }
}
static void c_to_double(unsigned logn, double *f)
{
    size_t hn=(size_t)1 << (logn-1);
    for (size_t i=0; i<hn; i++) {
        f[i]=(double)c_poly.re[0][i]+c_poly.re[1][i];
        f[i+hn]=(double)c_poly.im[0][i]+c_poly.im[1][i];
    }
}
static void tw_core_from_double(unsigned logn,const double *f)
{
    size_t hn=(size_t)1 << (logn-1);
    for (size_t i=0; i<hn; i++) {
        float r=(float)f[i], im=(float)f[i+hn];
        tw_core_workspace.re[0][i]=r;
        tw_core_workspace.re[1][i]=(float)(f[i]-(double)r);
        tw_core_workspace.re[2][i]=0;
        tw_core_workspace.im[0][i]=im;
        tw_core_workspace.im[1][i]=(float)(f[i+hn]-(double)im);
        tw_core_workspace.im[2][i]=0;
    }
}
static void tw_core_to_double(unsigned logn,double *f)
{
    size_t hn=(size_t)1 << (logn-1);
    for (size_t i=0; i<hn; i++) {
        f[i]=(double)tw_core_workspace.re[0][i]+tw_core_workspace.re[1][i];
        f[i+hn]=(double)tw_core_workspace.im[0][i]+tw_core_workspace.im[1][i];
    }
}

static void LEAF fixed_fft(unsigned l) { vect_FFT(l,buffers.fixed); }
static void LEAF fixed_ifft(unsigned l) { vect_iFFT(l,buffers.fixed); }
static void LEAF tw_fft(unsigned l) { control_tw32_bridge_fft(l,buffers.data); }
static void LEAF tw_ifft(unsigned l) { control_tw32_bridge_ifft(l,buffers.data); }
static void LEAF c_fft(unsigned l)
{ c_from_double(l,buffers.data); fndsa_ds_fft(l,&c_poly); c_to_double(l,buffers.data); }
static void LEAF c_ifft(unsigned l)
{ c_from_double(l,buffers.data); fndsa_ds_ifft(l,&c_poly); c_to_double(l,buffers.data); }
static void LEAF tw_fft_core(unsigned l) { control_ds32_fft_mve(l,&tw_core_workspace); }
static void LEAF tw_ifft_core(unsigned l) { control_ds32_ifft_mve(l,&tw_core_workspace); }
static void LEAF c_fft_core(unsigned l) { fndsa_ds_fft(l,&c_poly); }
static void LEAF c_ifft_core(unsigned l) { fndsa_ds_ifft(l,&c_poly); }
typedef void (*kernel_fn)(unsigned);
static const kernel_fn kernels[2][5]={
    {fixed_fft,tw_fft,c_fft,tw_fft_core,c_fft_core},
    {fixed_ifft,tw_ifft,c_ifft,tw_ifft_core,c_ifft_core}
};
static const char *const names[]={"fixed_q32","tw_double","c_double","tw_core","c_core"};

static uint32_t LEAF timed(kernel_fn fn,unsigned logn)
{
    unsigned irq=__get_PRIMASK(); __disable_irq();
    __DSB(); __ISB(); uint32_t start=DWT->CYCCNT;
    fn(logn);
    __DSB(); __ISB(); uint32_t elapsed=DWT->CYCCNT-start;
    if (!irq) __enable_irq();
    return elapsed;
}
static void prepare(unsigned logn,unsigned round,unsigned inverse,unsigned fractional)
{
    unsigned n=1u << logn;
    for (unsigned i=0; i<n; i++) {
        int32_t v=(int32_t)(random32()%(2*(256+round)+1))-(int32_t)(256+round);
        buffers.source[i]=(double)v;
        if (fractional) buffers.source[i]+=(double)random32()*0x1p-32;
    }
    /* Both backends get exactly the same spectral input. Preparation is
     * not timed; TW stage-11 is byte-equivalent to the old stage-10 core. */
    if (inverse) control_tw32_bridge_fft(logn,buffers.source);
}
static void reset(unsigned logn,unsigned backend)
{
    unsigned n=1u << logn;
    memcpy(buffers.data,buffers.source,n*sizeof(double));
    for (unsigned i=0; i<n; i++)
        buffers.fixed[i].v=(uint64_t)(int64_t)(buffers.source[i]*0x1p32);
    if (backend==4) c_from_double(logn,buffers.source);
    if (backend==3) tw_core_from_double(logn,buffers.source);
}
static void finish_core(unsigned b,unsigned logn)
{
    if (b==3) tw_core_to_double(logn,buffers.data);
    if (b==4) c_to_double(logn,buffers.data);
}
static unsigned check_canaries(void)
{
    unsigned errors=0;
    for (unsigned i=0;i<4;i++) {
        errors+=buffers.before[i]!=CANARY || buffers.after[i]!=CANARY;
        errors+=bridge_shared_workspace.before[i]!=CANARY || bridge_shared_workspace.after[i]!=CANARY;
    }
    return errors;
}
static unsigned accuracy(void)
{
    unsigned errors=0;
    for (unsigned l=4;l<=10;l++) for (unsigned inv=0;inv<2;inv++) {
        unsigned n=1u<<l, mismatch=0, different=0;
        double max_lsb=0;
        for (unsigned r=0;r<100;r++) {
            prepare(l,r,inv,r&1);
            reset(l,1); kernels[inv][1](l);
            memcpy(buffers.expected,buffers.data,n*sizeof(double));
            reset(l,2); kernels[inv][2](l);
            mismatch+=memcmp(buffers.expected,buffers.data,n*sizeof(double))!=0;
            kernels[inv][0](l);
            for (unsigned i=0;i<n;i++) {
                double original=(double)(int32_t)(buffers.fixed[i].v>>32)
                    +(double)(uint32_t)buffers.fixed[i].v*0x1p-32;
                double delta=__builtin_fabs(buffers.data[i]-original)*0x1p32;
                if (!__builtin_isfinite(delta)) errors++;
                if (delta>max_lsb) max_lsb=delta;
                different+=delta!=0;
            }
        }
        printf("BRIDGE_ACCURACY degree=%u inverse=%u cases=100 tw_c_mismatches=%u fixed_different=%u max_q32_lsb_ceil=%llu\n",
            n,inv,mismatch,different,(unsigned long long)__builtin_ceil(max_lsb));
        errors+=mismatch;
    }
    return errors;
}
static unsigned benchmark(unsigned logn,unsigned inv,unsigned batch)
{
    unsigned n=1u<<logn, errors=0;
    uint64_t sum[5]={0};
    uint32_t low[5]={~0u,~0u,~0u,~0u,~0u},high[5]={0};
    for (unsigned r=0;r<REPEATS+WARMUP;r++) {
        prepare(logn,r,inv,0);
        reset(logn,1); kernels[inv][1](logn);
        memcpy(buffers.expected,buffers.data,n*sizeof(double));
        for (unsigned slot=0;slot<5;slot++) {
            unsigned b=(slot+r+batch)%5;
            reset(logn,b);
            uint32_t elapsed=timed(kernels[inv][b],logn);
            finish_core(b,logn);
            if (b) errors+=memcmp(buffers.expected,buffers.data,n*sizeof(double))!=0;
            uint64_t bits;
            if (b) memcpy(&bits,buffers.data+(r%n),sizeof bits);
            else bits=buffers.fixed[r%n].v;
            sink^=bits;
            if (r<WARMUP) continue;
            sum[b]+=elapsed;
            if (elapsed<low[b]) low[b]=elapsed;
            if (elapsed>high[b]) high[b]=elapsed;
        }
    }
    for (unsigned b=0;b<5;b++) printf(
        "BRIDGE_PERF degree=%u inverse=%u batch=%u backend=%s calls=100 cycles=%llu min=%u max=%u\n",
        n,inv,batch,names[b],(unsigned long long)sum[b],low[b],high[b]);
    printf("BRIDGE_BATCH degree=%u inverse=%u batch=%u comparisons=440 mismatches=%u\n",n,inv,batch,errors);
    return errors;
}
int mlk_test_main(int argc,char **argv)
{
    (void)argc;(void)argv;
    printf("BRIDGE_HW cpu=%u fpscr=%08x ccr=%08x tcm=%08x\n",
        (unsigned)SystemCoreClock,(unsigned)__get_FPSCR(),(unsigned)SCB->CCR,
        *(volatile unsigned*)0x56008008);
    printf("BRIDGE_LAYOUT shared_workspace=1 base=%p double_io=%p\n",
        (void*)&bridge_shared_workspace.poly,(void*)buffers.data);
    if (SystemCoreClock!=800000000u || (SCB->CCR&0x30000u)
        || *(volatile unsigned*)0x56008008!=0x99u || (__get_FPSCR()&0x1C00000u)) return 10;
    CoreDebug->DEMCR|=CoreDebug_DEMCR_TRCENA_Msk;
    DWT->CTRL|=DWT_CTRL_CYCCNTENA_Msk;
    for (unsigned i=0;i<4;i++) {
        buffers.before[i]=buffers.after[i]=CANARY;
        bridge_shared_workspace.before[i]=bridge_shared_workspace.after[i]=CANARY;
    }
    rng_state=UINT64_C(0x6a09e667f3bcc909);
    unsigned errors=accuracy();
    rng_state=UINT64_C(0x6a09e667f3bcc909);
    for (unsigned batch=0;batch<BATCHES;batch++)
        for (unsigned l=9;l<=10;l++)
            for (unsigned inv=0;inv<2;inv++) errors+=benchmark(l,inv,batch);
    unsigned canaries=check_canaries();errors+=canaries;
    printf("BRIDGE_DONE batches=5 perf_rows=100 accuracy_rows=14 canary_errors=%u mismatches=%u sink=%016llx\n",
        canaries,errors,(unsigned long long)sink);
    return errors!=0;
}
