/* Test-only bit-exact LDL comparison and empirical timing screen.
 * The emulated oracle and the production function share the same ELF,
 * input and buffers. Preparation, checking and printing are not timed. */
#include "sign_inner.h"
#include <cmsis_core.h>
#include <stm32n6xx.h>
#include <stdio.h>
#include <limits.h>

void oracle_LDL_fft(unsigned, const fpr *, fpr *, fpr *);
void native_LDL_fft(unsigned, const fpr *, fpr *, fpr *);
typedef void (*ldl_function)(unsigned, const fpr *, fpr *, fpr *);
unsigned poly_abi_probe(ldl_function, unsigned, const fpr *, fpr *, fpr *);
static fpr input[2048], reference[2048];
static fpr arena[2050] __attribute__((aligned(32)));
static uint32_t samples[3][100];
static unsigned failures, guards, comparisons;
static uint32_t rng = 0x674EF90Bu;
static volatile double reciprocal_sink;

static uint32_t next(void)
{
    rng ^= rng << 13; rng ^= rng >> 17; rng ^= rng << 5; return rng;
}
static fpr bits(double x) { fpr u; memcpy(&u, &x, 8); return u; }
static fpr random_normal(int exponent, unsigned sign)
{
    return ((uint64_t)sign << 63) | ((uint64_t)(1023+exponent) << 52)
        | ((uint64_t)(next() & 0xFFFFFu) << 32) | next();
}
static void fill(unsigned logn, unsigned kind)
{
    size_t n=(size_t)1<<logn, hn=n>>1;
    for (size_t i=0;i<hn;i++) {
        fpr a,b,c;
        switch (kind%8) {
        case 0:
            a=FPR_ONE; b=(uint64_t)(i&1)<<63; c=(uint64_t)((i>>1)&1)<<63; break;
        case 1:
            a=(uint64_t)(1013+i%21)<<52;
            b=bits((int)(next()%1025)-512); c=bits((int)(next()%1025)-512); break;
        case 2:
            a=FPR_ONE+(next()&15); b=FPR_ONE+(next()&15);
            c=(FPR_ONE+(next()&15))|((uint64_t)(i&1)<<63); break;
        case 3:
            a=UINT64_C(0x3fffffffffffffff)-(next()&15);
            b=random_normal(0,0); c=random_normal(0,1); break;
        case 4:
            a=random_normal(-200,0); b=random_normal(-100,0); c=random_normal(-100,1); break;
        case 5:
            a=random_normal(200,0); b=random_normal(100,1); c=random_normal(100,0); break;
        case 6:
            a=random_normal((int)(next()%401)-200,0);
            b=random_normal((int)(next()%401)-200,next()&1);
            c=random_normal((int)(next()%401)-200,next()&1); break;
        default:
            a=random_normal(0,0); b=random_normal(0,next()&1); c=random_normal(0,next()&1); break;
        }
        /* Construct g11 with the emulated arithmetic, including exact and
         * near cancellation. All arithmetic stays finite/normal or zero. */
        fpr inv=fpr_inv(a);
        fpr z=fpr_add(fpr_mul(fpr_mul(b,inv),b),fpr_mul(fpr_mul(c,inv),c));
        fpr d;
        if (kind%8==7) d=z+(i&1);
        else d=fpr_add(z,FPR_ONE);
        input[i]=a; input[hn+i]=b; input[n+i]=c; input[n+hn+i]=d;
    }
}
static void prepare(unsigned logn)
{
    size_t count=(size_t)2<<logn;
    arena[0]=UINT64_C(0xCAFE0123456789AB);
    arena[count+1]=UINT64_C(0x12345678CAFEABCD);
    memcpy(arena+1,input,count*sizeof(fpr));
}
static void check_guard(unsigned logn)
{
    guards += arena[0]!=UINT64_C(0xCAFE0123456789AB)
        || arena[((size_t)2<<logn)+1]!=UINT64_C(0x12345678CAFEABCD);
}
static void call(ldl_function f,unsigned logn,fpr *buf)
{
    size_t n=(size_t)1<<logn,hn=n>>1;
    f(logn,buf,buf+hn,buf+hn+n);
}
static uint32_t measure(ldl_function f,unsigned logn)
{
    size_t n=(size_t)1<<logn,hn=n>>1;
    fpr *buf=arena+1;
    uint32_t mask=__get_PRIMASK(); __disable_irq();
    __DSB(); __ISB(); uint32_t start=DWT->CYCCNT;
    f(logn,buf,buf+hn,buf+hn+n);
    __DSB(); __ISB(); uint32_t d=DWT->CYCCNT-start;
    __set_PRIMASK(mask); return d;
}
static void sort(uint32_t *a)
{
    for(unsigned i=1;i<100;i++) {uint32_t v=a[i];unsigned j=i;
        while(j&&a[j-1]>v){a[j]=a[j-1];j--;}a[j]=v;}
}
static uint32_t measure_reciprocal(fpr raw)
{
    double a; memcpy(&a,&raw,8); double one=1.0, out=0;
    uint32_t mask=__get_PRIMASK(); __disable_irq();
    __DSB(); __ISB(); uint32_t start=DWT->CYCCNT;
    for(unsigned j=0;j<32;j++)
        __asm__ volatile("vdiv.f64 %P0, %P1, %P2" : "=w"(out) : "w"(one), "w"(a));
    __DSB(); __ISB(); uint32_t d=DWT->CYCCNT-start;
    __set_PRIMASK(mask); reciprocal_sink=out; return d;
}
int mlk_test_main(int argc,char **argv)
{
    (void)argc;(void)argv;
    printf("LDL_HW cpu=%u fpscr=%08x ccr=%08x tcm=%08x\n",
        (unsigned)SystemCoreClock,(unsigned)__get_FPSCR(),(unsigned)SCB->CCR,
        *(volatile unsigned*)0x56008008);
    if(SystemCoreClock!=800000000u || (SCB->CCR&0x30000u)
        || *(volatile unsigned*)0x56008008!=0x99u || (__get_FPSCR()&0x1C00000u))return 10;
    CoreDebug->DEMCR|=CoreDebug_DEMCR_TRCENA_Msk;DWT->CTRL|=DWT_CTRL_CYCCNTENA_Msk;
    for(unsigned logn=1;logn<=10;logn++) {
        for(unsigned trial=0;trial<128;trial++) {
            fill(logn,trial);prepare(logn);
            memcpy(reference,input,((size_t)2<<logn)*sizeof(fpr));
            call(oracle_LDL_fft,logn,reference);call(fpoly_LDL_fft,logn,arena+1);
            comparisons++;check_guard(logn);
            for(unsigned i=0;i<(2u<<logn);i++) if(reference[i]!=arena[i+1]) {
                if(failures<12)printf("LDL_DIFFERENCE logn=%u trial=%u index=%u ref=%016llx got=%016llx\n",
                    logn,trial,i,(unsigned long long)reference[i],(unsigned long long)arena[i+1]);
                failures++;
            }
        }
        printf("LDL_EXACT logn=%u trials=128 failures=%u guards=%u\n",logn,failures,guards);
        ldl_function functions[3]={oracle_LDL_fft,native_LDL_fft,fpoly_LDL_fft};
        const char *names[3]={"emulated","native_c","current"};
        fill(logn,3);
        for(unsigned w=0;w<3;w++)for(unsigned k=0;k<3;k++){prepare(logn);measure(functions[k],logn);}
        uint64_t total[3]={0,0,0};
        for(unsigned trial=0;trial<100;trial++)for(unsigned order=0;order<3;order++) {
            unsigned k=(order+trial)%3;prepare(logn);
            uint32_t t=measure(functions[k],logn);samples[k][trial]=t;total[k]+=t;check_guard(logn);
        }
        for(unsigned k=0;k<3;k++) {sort(samples[k]);
            printf("LDL_PERF degree=%u implementation=%s calls=100 total=%llu median_lo=%u median_hi=%u min=%u max=%u\n",
                1u<<logn,names[k],(unsigned long long)total[k],samples[k][49],samples[k][50],samples[k][0],samples[k][99]);}
        for(unsigned kind=0;kind<8;kind++) {
            uint32_t lo=UINT32_MAX,hi=0;uint64_t t=0;
            for(unsigned j=0;j<100;j++) {fill(logn,kind);prepare(logn);
                uint32_t d=measure(fpoly_LDL_fft,logn);t+=d;if(d<lo)lo=d;if(d>hi)hi=d;check_guard(logn);}
            printf("LDL_CT degree=%u class=%u calls=100 total=%llu min=%u max=%u\n",
                1u<<logn,kind,(unsigned long long)t,lo,hi);
        }
    }
    for(unsigned kind=0;kind<20;kind++) {
        uint32_t lo=UINT32_MAX,hi=0;uint64_t t=0;
        for(unsigned j=0;j<103;j++) {
            fpr a;
            if(kind<5) a=(uint64_t)(823+100*kind)<<52;
            else if(kind<10) a=((uint64_t)(823+100*(kind-5))<<52)+1;
            else if(kind<15) a=((uint64_t)(823+100*(kind-10))<<52)|UINT64_C(0xfffffffffffff);
            else a=random_normal(-200+100*(kind-15),0);
            uint32_t d=measure_reciprocal(a);if(j<3)continue;t+=d;if(d<lo)lo=d;if(d>hi)hi=d;
        }
        printf("RECIP_CT class=%u calls=100 repetitions=32 total=%llu min=%u max=%u\n",
            kind,(unsigned long long)t,lo,hi);
    }
    unsigned abi=0;
    for(unsigned logn=1;logn<=10;logn++) {
        fill(logn,3);prepare(logn);
        size_t n=(size_t)1<<logn; fpr *p=arena+1;
        abi += poly_abi_probe(fpoly_LDL_fft,logn,p,p+n/2,p+n+n/2)!=0;
        check_guard(logn);
    }
    failures+=abi;
    printf("LDL_ABI calls=10 failures=%u\n",abi);
    printf("LDL_DONE comparisons=%u failures=%u guards=%u\n",comparisons,failures,guards);
    return failures||guards;
}
