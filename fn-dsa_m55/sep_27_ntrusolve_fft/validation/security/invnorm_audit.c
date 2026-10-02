/* A17 security evidence: unchanged production source, not a security proof. */
#include "kgen_inner.h"
#include <stdio.h>
#include <string.h>
#if AUDIT_BOARD
#include <zephyr/kernel.h>
#include <cmsis_core.h>
#include <stm32n6xx.h>
#endif

#define GUARD UINT64_C(0xb17eca55a55a7711)
#define LIMIT UINT64_C(72107278641426)
static fxr aa[1026], bb[1026], now[514], old[514];
static fxr na[1024], nb[1024], saved_a[1024], saved_b[1024];
static int8_t f[1024], g[1024];
static shake_context sc;
static uint64_t rng=UINT64_C(0x7365634131373031);
static volatile uint64_t sink;

static uint32_t rnd(void)
{
    rng ^= rng << 13; rng ^= rng >> 7; rng ^= rng << 17;
    return (uint32_t)rng;
}
static void init_seed(unsigned tag)
{
    unsigned char seed[32]="A17-security-audit-independent";
    seed[30]=(unsigned char)tag; seed[31]=(unsigned char)(tag>>8);
    shake_init(&sc,256); shake_inject(&sc,seed,sizeof seed); shake_flip(&sc);
}
static void prepare(unsigned l)
{
    sample_f(l,&sc,f); sample_f(l,&sc,g);
    vect_set(l,aa+1,f); vect_set(l,bb+1,g);
    vect_FFT_fixed(l,aa+1); vect_FFT_fixed(l,bb+1);
}
static double real_value(fxr x)
{
    return (double)(int32_t)(x.v>>32)+(double)(uint32_t)x.v*0x1p-32;
}
static uint64_t norm(unsigned l,const fxr *iv)
{
    size_t n=(size_t)1<<l;
    memcpy(na,aa+1,n*sizeof(fxr)); memcpy(nb,bb+1,n*sizeof(fxr));
    vect_adj_fft(l,na); vect_adj_fft(l,nb);
    vect_mul_realconst(l,na,fxr_of(12289));
    vect_mul_realconst(l,nb,fxr_of(12289));
    vect_mul_selfadj_fft(l,na,iv); vect_mul_selfadj_fft(l,nb,iv);
    vect_iFFT_fixed(l,na); vect_iFFT_fixed(l,nb);
    fxr sn=fxr_zero;
    for(size_t i=0;i<n;i++) sn=fxr_add(sn,fxr_add(fxr_sqr(na[i]),fxr_sqr(nb[i])));
    return sn.v;
}
static unsigned accuracy(void)
{
    unsigned failures=0;
    for(unsigned l=2;l<=10;l++) {
        size_t n=(size_t)1<<l,hn=n>>1;
        unsigned count=l>=9?4096:l==8?256:64;
        uint64_t differences=0,max_delta=0,decision_diff=0,eligible=0;
        uint64_t max_norm_delta=0,min_margin=UINT64_MAX,accepted=0;
        unsigned guards=0,domain=0;
        init_seed(l);
        for(unsigned t=0;t<count;t++) {
            for(unsigned i=0;i<1026;i++) aa[i].v=bb[i].v=GUARD;
            for(unsigned i=0;i<514;i++) now[i].v=old[i].v=GUARD;
            prepare(l);
            memcpy(saved_a,aa+1,n*sizeof(fxr)); memcpy(saved_b,bb+1,n*sizeof(fxr));
            unsigned sn=0;
            for(size_t i=0;i<n;i++) sn+=(int)f[i]*(int)f[i]+(int)g[i]*(int)g[i];
            eligible+=sn<16823;
            for(size_t i=0;i<hn;i++) {
                double ar=real_value(aa[1+i]),ai=real_value(aa[1+hn+i]);
                double br=real_value(bb[1+i]),bi=real_value(bb[1+hn+i]);
                double z=(ar*ar+ai*ai)+(br*br+bi*bi);
                union {double d;uint64_t u;} bits={z};
                unsigned exp=(unsigned)(bits.u>>52)&2047;
                /* Signed Q32 representable reciprocal, positive normal divisor. */
                if(exp==0 || exp==2047 || !(z>0x1p-31)) domain++;
            }
            if(domain) { failures++; break; }
            vect_invnorm_fft_fixed(l,old+1,aa+1,bb+1,0);
            vect_invnorm_fft(l,now+1,aa+1,bb+1,0);
            for(size_t i=0;i<hn;i++) {
                int64_t d=(int64_t)(now[i+1].v-old[i+1].v);
                uint64_t ad=d<0?-(uint64_t)d:(uint64_t)d;
                differences+=ad!=0; if(ad>max_delta)max_delta=ad;
            }
            uint64_t ns=norm(l,now+1),os=norm(l,old+1);
            unsigned np=(int64_t)ns<(int64_t)LIMIT,op=(int64_t)os<(int64_t)LIMIT;
            accepted+=np; decision_diff+=np!=op;
            uint64_t delta=ns>os?ns-os:os-ns;
            if(delta>max_norm_delta)max_norm_delta=delta;
            uint64_t margin=os>LIMIT?os-LIMIT:LIMIT-os;
            if(margin<min_margin)min_margin=margin;
            if(now[0].v!=GUARD || old[0].v!=GUARD || aa[0].v!=GUARD || bb[0].v!=GUARD)guards++;
            for(size_t i=hn+1;i<514;i++)if(now[i].v!=GUARD || old[i].v!=GUARD)guards++;
            for(size_t i=n+1;i<1026;i++)if(aa[i].v!=GUARD || bb[i].v!=GUARD)guards++;
            if(memcmp(saved_a,aa+1,n*sizeof(fxr)) || memcmp(saved_b,bb+1,n*sizeof(fxr)))guards++;
        }
        printf("SEC_ACCURACY logn=%u cases=%u eligible=%llu accepted=%llu coefficients=%llu differences=%llu max_delta=%llu decisions=%llu max_norm_delta=%llu min_margin=%llu guards=%u domain=%u\n",
            l,count,(unsigned long long)eligible,(unsigned long long)accepted,
            (unsigned long long)(count*hn),(unsigned long long)differences,
            (unsigned long long)max_delta,(unsigned long long)decision_diff,
            (unsigned long long)max_norm_delta,(unsigned long long)min_margin,guards,domain);
        failures+=decision_diff!=0 || guards!=0 || domain!=0;
    }
    return failures;
}

#if AUDIT_BOARD
struct stats { uint64_t count,sum,squares; uint32_t min,max; };
static uint32_t measure(unsigned l)
{
    unsigned irq=irq_lock();
    __DSB();__ISB(); uint32_t t=DWT->CYCCNT;
    vect_invnorm_fft(l,now+1,aa+1,bb+1,0);
    __DSB();__ISB(); uint32_t elapsed=DWT->CYCCNT-t;
    irq_unlock(irq);sink^=now[1].v;return elapsed;
}
static void timing(void)
{
    for(unsigned l=9;l<=10;l++)for(unsigned phase=0;phase<5;phase++) {
        unsigned n=1u<<l;
        struct stats s[2]={{0,0,0,UINT32_MAX,0},{0,0,0,UINT32_MAX,0}};
        init_seed(0x100+l);prepare(l);
        memcpy(saved_a,aa+1,n*sizeof(fxr));memcpy(saved_b,bb+1,n*sizeof(fxr));
        for(unsigned t=0;t<20000;t++) {
            unsigned cls=rnd()&1;
            /* phase0: identical-input negative control; phase1: real Gaussian
             * spectra fixed vs random; phase2: constructed valid-Q32 magnitudes;
             * phase3: spectra of f=g=1 vs Gaussian (both candidate domain);
             * phase4: integer vs fractional normal, representable Q32 inputs.
             * Class selection/preparation is OUTSIDE the timed interval. */
            if(phase==1 || phase==3)prepare(l);
            if(phase<2 && (phase==0 || cls==0)) {
                memcpy(aa+1,saved_a,n*sizeof(fxr));memcpy(bb+1,saved_b,n*sizeof(fxr));
            } else if(phase==2) {
                for(unsigned i=0;i<n;i++) {
                    aa[i+1]=fxr_of(cls?128:1);bb[i+1]=fxr_of(1);
                }
            } else if(phase==3 && cls==0) {
                for(unsigned i=0;i<n;i++)aa[i+1]=bb[i+1]=fxr_of(i<n/2?1:0);
            } else if(phase==4) {
                for(unsigned i=0;i<n;i++)aa[i+1]=bb[i+1]=cls?fxr_of_scaled32(UINT64_C(1)<<23):fxr_of(1);
            }
            measure(l); /* identical warmup policy for BOTH classes */
            uint32_t x=measure(l);struct stats *p=&s[cls];
            p->count++;p->sum+=x;p->squares+=(uint64_t)x*x;
            if(x<p->min)p->min=x;
            if(x>p->max)p->max=x;
        }
        for(unsigned cls=0;cls<2;cls++)printf("SEC_TIMING logn=%u phase=%u class=%u count=%llu sum=%llu squares=%llu min=%u max=%u\n",
            l,phase,cls,(unsigned long long)s[cls].count,(unsigned long long)s[cls].sum,
            (unsigned long long)s[cls].squares,s[cls].min,s[cls].max);
    }
}
#endif
int mlk_test_main(int argc,char **argv)
{
    (void)argc;(void)argv;
#if AUDIT_BOARD
    if(SystemCoreClock!=800000000u || (SCB->CCR&0x30000u) || *(volatile unsigned*)0x56008008!=0x99u || (__get_FPSCR()&0x1C00000u))return 10;
    CoreDebug->DEMCR|=CoreDebug_DEMCR_TRCENA_Msk;DWT->CTRL|=DWT_CTRL_CYCCNTENA_Msk;
#endif
    unsigned failures=accuracy();
#if AUDIT_BOARD
    timing();
#endif
    printf("SEC_DONE failures=%u timing_is_proof=0\n",failures);
    return failures!=0;
}
#if !AUDIT_BOARD
int main(int argc,char **argv){return mlk_test_main(argc,argv);}
#endif
