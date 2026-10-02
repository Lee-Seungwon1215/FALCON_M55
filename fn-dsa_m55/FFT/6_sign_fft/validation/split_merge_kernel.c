/* Test-only original/native/current differential kernels. Setup is not timed. */
#include "sign_inner.h"
#include <cmsis_core.h>
#include <stm32n6xx.h>
#include <stdio.h>
#include <limits.h>

void oracle_split_fft(unsigned,fpr *,fpr *,const fpr *);
void oracle_merge_fft(unsigned,fpr *,const fpr *,const fpr *);
void native_split_fft(unsigned,fpr *,fpr *,const fpr *);
void native_merge_fft(unsigned,fpr *,const fpr *,const fpr *);
typedef void (*split_fn)(unsigned,fpr *,fpr *,const fpr *);
typedef void (*merge_fn)(unsigned,fpr *,const fpr *,const fpr *);
unsigned poly_abi_probe(void (*)(void),unsigned,const void *,const void *,const void *);
static split_fn splits[3]={oracle_split_fft,native_split_fft,fpoly_split_fft};
static merge_fn merges[3]={oracle_merge_fft,native_merge_fft,fpoly_merge_fft};
static fpr input[1024],reference[2052];
static fpr arena[2052] __attribute__((aligned(32)));
static uint32_t samples[3][100],rng=0x53198ac7;
static unsigned failures,comparisons,guards;
static uint32_t next(void){rng^=rng<<13;rng^=rng>>17;rng^=rng<<5;return rng;}
static fpr bits(double x){fpr u;memcpy(&u,&x,8);return u;}
static void fill(unsigned logn,unsigned kind)
{
    for(unsigned i=0;i<(1u<<logn);i++) {
        switch(kind%8) {
        case 0: input[i]=0;break;
        case 1: input[i]=(uint64_t)(i&1)<<63;break;
        case 2: input[i]=bits(i==0?1.0:0.0);break;
        case 3: input[i]=bits((i&1)?-1.0:1.0);break;
        case 4: input[i]=bits((int)(next()%1024)-512);break;
        case 5: input[i]=((uint64_t)(next()&1)<<63)|((uint64_t)(983+next()%81)<<52)
                    |((uint64_t)(next()&0xfffff)<<32)|next();break;
        case 6: input[i]=FPR_ONE+(next()&15);if(i&1)input[i]|=UINT64_C(1)<<63;break;
        default: input[i]=((uint64_t)(next()&1)<<63)|((uint64_t)(823+next()%401)<<52)
                    |((uint64_t)(next()&0xfffff)<<32)|next();break;
        }
    }
}
static void prepare(unsigned logn,unsigned inv)
{
    size_t n=(size_t)1<<logn,hn=n>>1;
    memset(arena,0,sizeof arena);
    arena[0]=arena[n+1]=arena[n+hn+2]=arena[2*n+3]=UINT64_C(0xcafe0123456789ab);
    if(inv){memcpy(arena+n+2,input,hn*8);memcpy(arena+n+hn+3,input+hn,hn*8);}
    else memcpy(arena+1,input,n*8);
}
static void check(unsigned logn,unsigned inv)
{
    size_t n=(size_t)1<<logn,hn=n>>1;
    guards+=arena[0]!=UINT64_C(0xcafe0123456789ab)||arena[n+1]!=UINT64_C(0xcafe0123456789ab)
        ||arena[n+hn+2]!=UINT64_C(0xcafe0123456789ab)||arena[2*n+3]!=UINT64_C(0xcafe0123456789ab);
    if(inv) guards+=memcmp(arena+n+2,input,hn*8)!=0||memcmp(arena+n+hn+3,input+hn,hn*8)!=0;
    else guards+=memcmp(arena+1,input,n*8)!=0;
}
static void invoke(unsigned impl,unsigned inv,unsigned logn,fpr *p)
{
    size_t n=(size_t)1<<logn,hn=n>>1;
    if(inv) merges[impl](logn,p+1,p+n+2,p+n+hn+3);
    else splits[impl](logn,p+n+2,p+n+hn+3,p+1);
}
static uint32_t measure(unsigned impl,unsigned inv,unsigned logn)
{
    uint32_t mask=__get_PRIMASK();__disable_irq();__DSB();__ISB();
    uint32_t start=DWT->CYCCNT;invoke(impl,inv,logn,arena);
    __DSB();__ISB();uint32_t d=DWT->CYCCNT-start;__set_PRIMASK(mask);return d;
}
static void sort(uint32_t *a)
{
    for(unsigned i=1;i<100;i++){uint32_t v=a[i];unsigned j=i;while(j&&a[j-1]>v){a[j]=a[j-1];j--;}a[j]=v;}
}
int mlk_test_main(int argc,char **argv)
{
    (void)argc;(void)argv;
    printf("POLY_HW cpu=%u fpscr=%08x ccr=%08x tcm=%08x\n",(unsigned)SystemCoreClock,
        (unsigned)__get_FPSCR(),(unsigned)SCB->CCR,*(volatile unsigned*)0x56008008);
    if(SystemCoreClock!=800000000u||(SCB->CCR&0x30000u)||*(volatile unsigned*)0x56008008!=0x99u
        ||(__get_FPSCR()&0x1c00000u))return 10;
    CoreDebug->DEMCR|=CoreDebug_DEMCR_TRCENA_Msk;DWT->CTRL|=DWT_CTRL_CYCCNTENA_Msk;
    unsigned abi=0;
    for(unsigned logn=1;logn<=10;logn++)for(unsigned inv=0;inv<2;inv++) {
        for(unsigned t=0;t<128;t++) {
            fill(logn,t);prepare(logn,inv);memcpy(reference,arena,sizeof arena);invoke(0,inv,logn,reference);
            for(unsigned k=1;k<3;k++){
                prepare(logn,inv);invoke(k,inv,logn,arena);check(logn,inv);comparisons++;
                for(unsigned j=0;j<2052;j++)if(reference[j]!=arena[j]){
                    if(failures<12)printf("POLY_DIFFERENCE logn=%u inverse=%u trial=%u implementation=%u index=%u ref=%016llx got=%016llx\n",
                        logn,inv,t,k,j,(unsigned long long)reference[j],(unsigned long long)arena[j]);
                    failures++;
                }
            }
        }
        printf("POLY_EXACT degree=%u inverse=%u failures=%u guards=%u\n",1u<<logn,inv,failures,guards);
        fill(logn,4);prepare(logn,inv);size_t n=(size_t)1<<logn,hn=n>>1;
        if(inv)abi+=poly_abi_probe((void(*)(void))fpoly_merge_fft,logn,arena+1,arena+n+2,arena+n+hn+3)!=0;
        else abi+=poly_abi_probe((void(*)(void))fpoly_split_fft,logn,arena+n+2,arena+n+hn+3,arena+1)!=0;
        check(logn,inv);
        for(unsigned w=0;w<3;w++)for(unsigned k=0;k<3;k++){prepare(logn,inv);measure(k,inv,logn);}
        uint64_t total[3]={0,0,0};
        for(unsigned t=0;t<100;t++)for(unsigned o=0;o<3;o++){
            unsigned k=(o+t)%3;prepare(logn,inv);uint32_t d=measure(k,inv,logn);
            samples[k][t]=d;total[k]+=d;check(logn,inv);
        }
        const char *names[3]={"emulated","native_c","current"};
        for(unsigned k=0;k<3;k++){sort(samples[k]);printf("POLY_PERF degree=%u inverse=%u implementation=%s calls=100 total=%llu median_lo=%u median_hi=%u min=%u max=%u\n",
            1u<<logn,inv,names[k],(unsigned long long)total[k],samples[k][49],samples[k][50],samples[k][0],samples[k][99]);}
        for(unsigned kind=0;kind<8;kind++){
            uint32_t lo=UINT32_MAX,hi=0;uint64_t sum=0;
            for(unsigned t=0;t<100;t++){fill(logn,kind);prepare(logn,inv);uint32_t d=measure(2,inv,logn);
                sum+=d;if(d<lo)lo=d;if(d>hi)hi=d;check(logn,inv);}
            printf("POLY_CT degree=%u inverse=%u class=%u calls=100 total=%llu min=%u max=%u\n",
                1u<<logn,inv,kind,(unsigned long long)sum,lo,hi);
        }
    }
    failures+=abi;printf("POLY_ABI calls=20 failures=%u\n",abi);
    printf("POLY_DONE comparisons=%u failures=%u guards=%u\n",comparisons,failures,guards);
    return failures||guards;
}
