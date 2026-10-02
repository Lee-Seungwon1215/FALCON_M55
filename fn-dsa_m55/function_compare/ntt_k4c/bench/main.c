/* NTT-only comparison. No keygen/sign/verify API is linked or timed.
 * Every timed batch repeats a transform on its output; both implementations
 * start from the same seed array. Copies/checks/table generation are untimed.
 */
#include "api.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <zephyr/kernel.h>
#include <cmsis_core.h>
#include <stm32n6xx.h>
#include <stm32n6xx_ll_rcc.h>

enum { BATCHES = 10, CALLS = 100, PATTERNS = 8, MAXN = 1024 };
static uint32_t ga[MAXN+16] __attribute__((aligned(32)));
static uint32_t gb[MAXN+16] __attribute__((aligned(32)));
static uint16_t qa[MAXN+32] __attribute__((aligned(32)));
static uint16_t qb[MAXN+32] __attribute__((aligned(32)));
static uint32_t input[MAXN], spectral[MAXN], independent[MAXN];
static uint32_t gm[MAXN] __attribute__((aligned(32)));
static uint32_t igm[MAXN] __attribute__((aligned(32)));
static uint32_t igm_full[MAXN] __attribute__((aligned(32)));
static uint32_t *const a = ga+8, *const b = gb+8;
static uint16_t *const x = qa+16, *const y = qb+16;
static uint32_t rng = 0xA57B341Du;
volatile uint32_t compare_progress[4];
static unsigned checks, oracle_checks, bench_records;
extern __attribute__((noreturn)) void nucleo_test_done(int);

static void fail(const char *what, unsigned logn, unsigned pi, unsigned index)
{
    printf("COMPARE_FAIL what=%s logn=%u pi=%u index=%u\n", what, logn, pi, index);
    nucleo_test_done(1);
}
static uint32_t random32(void)
{
    rng ^= rng << 13; rng ^= rng >> 17; rng ^= rng << 5;
    return rng;
}
static uint32_t mulmod(uint32_t u, uint32_t v, uint32_t p)
{
    return (uint64_t)u*v % p;
}
static uint32_t powmod(uint32_t u, uint32_t e, uint32_t p)
{
    uint32_t r = 1;
    for (; e; e >>= 1, u = mulmod(u,u,p)) if (e&1) r = mulmod(r,u,p);
    return r;
}
static unsigned reverse(unsigned v, unsigned bits)
{
    unsigned r = 0;
    while (bits--) { r = (r<<1)|(v&1); v >>= 1; }
    return r;
}
/* Independent mathematical definition: evaluate at odd powers of a primitive
 * 2n-th root. Neither butterfly code nor root tables are used here. */
static void direct_ntt(unsigned logn, uint32_t primitive2048, uint32_t p)
{
    unsigned n = 1u << logn;
    uint32_t root = powmod(primitive2048, 1024/n, p);
    for (unsigned k=0; k<n; k++) {
        uint32_t w = powmod(root, 2*reverse(k,logn)+1, p), t=1, s=0;
        for (unsigned j=0; j<n; j++) {
            s = ((uint64_t)s + mulmod(input[j],t,p)) % p;
            t = mulmod(t,w,p);
        }
        independent[k] = s;
    }
    oracle_checks++;
}
static void pattern(unsigned logn, uint32_t p, unsigned kind)
{
    unsigned n=1u<<logn;
    for (unsigned j=0; j<n; j++) {
        switch (kind) {
        case 0: input[j]=0; break;
        case 1: input[j]=p-1; break;
        case 2: input[j]=1; break;
        case 3: input[j]=(j&1)?p-1:0; break;
        case 4: input[j]=(j==n-1); break;
        case 5: input[j]=(j==0); break;
        case 6: input[j]=(j&1)?(p>>1)+1:(p>>1); break;
        default: input[j]=random32()%p; break;
        }
    }
}
static void reset_mp(uint32_t *buf, const uint32_t *src, unsigned n)
{
    for (unsigned j=0; j<MAXN+16; j++) buf[j]=0xA59C35E7u;
    memcpy(buf+8,src,n*4);
}
static void reset_mq(uint16_t *buf, const uint32_t *src, unsigned n)
{
    for (unsigned j=0; j<MAXN+32; j++) buf[j]=0xA59Cu;
    for (unsigned j=0; j<n; j++) buf[j+16]=src[j] ? src[j] : 12289;
}
static void guard_mp(const uint32_t *buf, unsigned n, unsigned logn, unsigned pi)
{
    for (unsigned j=0; j<MAXN+16; j++)
        if ((j<8 || j>=n+8) && buf[j]!=0xA59C35E7u) fail("mp_canary",logn,pi,j);
}
static void guard_mq(const uint16_t *buf, unsigned n, unsigned logn)
{
    for (unsigned j=0; j<MAXN+32; j++)
        if ((j<16 || j>=n+16) && buf[j]!=0xA59Cu) fail("mq_canary",logn,0,j);
}
static void equal_mp(unsigned logn, unsigned pi)
{
    unsigned n=1u<<logn; uint32_t p=PRIMES[pi].p;
    guard_mp(ga,n,logn,pi); guard_mp(gb,n,logn,pi);
    for (unsigned j=0;j<n;j++) if (a[j]>=p || b[j]>=p || a[j]!=b[j]) fail("mp_exact",logn,pi,j);
}
static void equal_mq(unsigned logn)
{
    unsigned n=1u<<logn;
    guard_mq(qa,n,logn); guard_mq(qb,n,logn);
    for (unsigned j=0;j<n;j++)
        if (x[j]>12289 || y[j]>12289 || x[j]%12289 != y[j]%12289) fail("mq_modular",logn,0,j);
}
static void check_mq(void)
{
    unsigned before=checks;
    for (unsigned logn=2;logn<=10;logn++) for (unsigned k=0;k<PATTERNS;k++) {
        unsigned n=1u<<logn;
        pattern(logn,12289,k);
        reset_mq(qa,input,n); reset_mq(qb,input,n);
        orig_mqpoly_int_to_ntt(logn,x); opt_mqpoly_int_to_ntt(logn,y); equal_mq(logn);
        if (k==7 && (logn<=5 || logn>=9)) {
            uint32_t primitive=mulmod(orig_mq_GM[512],powmod(10952,12287,12289),12289);
            direct_ntt(logn,primitive,12289);
            for(unsigned j=0;j<n;j++) if(x[j]%12289!=independent[j]) fail("mq_dft",logn,0,j);
        }
        orig_mqpoly_ntt_to_int(logn,x); opt_mqpoly_ntt_to_int(logn,y); equal_mq(logn);
        for(unsigned j=0;j<n;j++) if(x[j]%12289!=input[j] || y[j]%12289!=input[j]) fail("mq_roundtrip",logn,0,j);
        /* Independent inverse input (not each implementation's own output). */
        pattern(logn,12289,(k+3)%PATTERNS);
        reset_mq(qa,input,n); reset_mq(qb,input,n);
        orig_mqpoly_ntt_to_int(logn,x); opt_mqpoly_ntt_to_int(logn,y); equal_mq(logn);
        checks++;
    }
    printf("CHECK family=mq cases=%u mismatches=0 range_errors=0 canary_errors=0\n", checks-before);
}
static void check_mp(void)
{
    unsigned before=checks;
    for(unsigned pi=0;pi<308;pi++) {
        const small_prime *sp=&PRIMES[pi];
        uint32_t p=sp->p, primitive=mulmod(sp->g,powmod((uint64_t)0x100000000ULL%p,p-2,p),p);
        for(unsigned logn=0;logn<=10;logn++) {
            unsigned n=1u<<logn;
            mp_mkgmigm(logn,gm,igm,sp->g,sp->ig,p,sp->p0i);
            mp_mkigm_full(logn,igm_full,igm,p);
            for(unsigned k=0;k<PATTERNS;k++) {
                pattern(logn,p,k); reset_mp(ga,input,n); reset_mp(gb,input,n);
                orig_mp_NTT(logn,a,gm,p,sp->p0i); opt_mp_NTT(logn,b,gm,p,sp->p0i); equal_mp(logn,pi);
                if(k==7 && (logn<=4 || (pi==0 && logn>=9))) {
                    direct_ntt(logn,primitive,p);
                    for(unsigned j=0;j<n;j++) if(a[j]!=independent[j]) fail("mp_dft",logn,pi,j);
                }
                orig_mp_iNTT(logn,a,igm,p,sp->p0i); opt_mp_iNTT(logn,b,igm_full,p,sp->p0i); equal_mp(logn,pi);
                for(unsigned j=0;j<n;j++) if(a[j]!=input[j] || b[j]!=input[j]) fail("mp_roundtrip",logn,pi,j);
                pattern(logn,p,(k+3)%PATTERNS); reset_mp(ga,input,n); reset_mp(gb,input,n);
                orig_mp_iNTT(logn,a,igm,p,sp->p0i); opt_mp_iNTT(logn,b,igm_full,p,sp->p0i); equal_mp(logn,pi);
                checks++;
            }
        }
        compare_progress[0]=1; compare_progress[1]=pi;
        if(pi%28==0) printf("PROGRESS audit_prime=%u\n",pi);
    }
    printf("CHECK family=mp cases=%u mismatches=0 range_errors=0 canary_errors=0\n",checks-before);
}
static uint32_t tick(void) { __DSB(); __ISB(); return DWT->CYCCNT; }
/* Shared noinline harness prevents per-candidate specialization/inlining. */
__attribute__((noinline)) static uint32_t time_mq(mq_fn fn,unsigned logn,uint16_t *buf)
{
    unsigned key=irq_lock(); uint32_t start=tick();
    for(unsigned j=0;j<CALLS;j++) fn(logn,buf);
    uint32_t elapsed=tick()-start; irq_unlock(key); return elapsed;
}
__attribute__((noinline)) static uint32_t time_mp(mp_fn fn,unsigned logn,uint32_t *buf,const uint32_t *roots,uint32_t p,uint32_t p0i)
{
    unsigned key=irq_lock(); uint32_t start=tick();
    for(unsigned j=0;j<CALLS;j++) fn(logn,buf,roots,p,p0i);
    uint32_t elapsed=tick()-start; irq_unlock(key); return elapsed;
}
static void row(const char *family,unsigned logn,unsigned pi,unsigned dir,uint32_t *old,uint32_t *opt)
{
    printf("BENCH family=%s logn=%u pi=%u dir=%u calls=%u old=",family,logn,pi,dir,CALLS);
    for(unsigned j=0;j<BATCHES;j++) printf("%s%u",j?",":"",old[j]);
    printf(" opt=");
    for(unsigned j=0;j<BATCHES;j++) printf("%s%u",j?",":"",opt[j]);
    printf("\n"); bench_records++;
}
static void bench_mq(void)
{
    for(unsigned logn=9;logn<=10;logn++) for(unsigned dir=0;dir<2;dir++) {
        unsigned n=1u<<logn; uint32_t old[BATCHES],opt[BATCHES];
        mq_fn f=dir?orig_mqpoly_ntt_to_int:orig_mqpoly_int_to_ntt;
        mq_fn g=dir?opt_mqpoly_ntt_to_int:opt_mqpoly_int_to_ntt;
        rng=0x14923+logn; pattern(logn,12289,7);
        reset_mq(qa,input,n);
        if(dir) { orig_mqpoly_int_to_ntt(logn,x); for(unsigned j=0;j<n;j++) input[j]=x[j]%12289; }
        reset_mq(qa,input,n); reset_mq(qb,input,n);
        for(unsigned w=0;w<10;w++) { f(logn,x); g(logn,y); }
        for(unsigned batch=0;batch<BATCHES;batch++) {
            /* Use the identical data address for both timed candidates. */
            if(batch&1) {
                reset_mq(qa,input,n); opt[batch]=time_mq(g,logn,x); memcpy(y,x,n*2);
                guard_mq(qa,n,logn); reset_mq(qa,input,n); old[batch]=time_mq(f,logn,x);
            } else {
                reset_mq(qa,input,n); old[batch]=time_mq(f,logn,x); memcpy(y,x,n*2);
                guard_mq(qa,n,logn); reset_mq(qa,input,n); opt[batch]=time_mq(g,logn,x);
            }
            equal_mq(logn);
        }
        row("mq",logn,0,dir,old,opt);
    }
}
static void bench_mp(void)
{
    for(unsigned pi=0;pi<308;pi++) {
        const small_prime *sp=&PRIMES[pi];
        for(unsigned logn=4;logn<=10;logn++) {
            unsigned n=1u<<logn;
            mp_mkgmigm(logn,gm,igm,sp->g,sp->ig,sp->p,sp->p0i);
            mp_mkigm_full(logn,igm_full,igm,sp->p);
            rng=0x52937+pi*991+logn; pattern(logn,sp->p,7);
            memcpy(spectral,input,n*4); orig_mp_NTT(logn,spectral,gm,sp->p,sp->p0i);
            for(unsigned dir=0;dir<2;dir++) {
                uint32_t old[BATCHES],opt[BATCHES];
                const uint32_t *src=dir?spectral:input;
                const uint32_t *old_roots=dir?igm:gm;
                const uint32_t *opt_roots=dir?igm_full:gm;
                mp_fn f=dir?orig_mp_iNTT:orig_mp_NTT, g=dir?opt_mp_iNTT:opt_mp_NTT;
                reset_mp(ga,src,n); reset_mp(gb,src,n);
                for(unsigned w=0;w<10;w++) { f(logn,a,old_roots,sp->p,sp->p0i); g(logn,b,opt_roots,sp->p,sp->p0i); }
                for(unsigned batch=0;batch<BATCHES;batch++) {
                    if(batch&1) {
                        reset_mp(ga,src,n); opt[batch]=time_mp(g,logn,a,opt_roots,sp->p,sp->p0i); memcpy(b,a,n*4);
                        guard_mp(ga,n,logn,pi); reset_mp(ga,src,n); old[batch]=time_mp(f,logn,a,old_roots,sp->p,sp->p0i);
                    } else {
                        reset_mp(ga,src,n); old[batch]=time_mp(f,logn,a,old_roots,sp->p,sp->p0i); memcpy(b,a,n*4);
                        guard_mp(ga,n,logn,pi); reset_mp(ga,src,n); opt[batch]=time_mp(g,logn,a,opt_roots,sp->p,sp->p0i);
                    }
                    equal_mp(logn,pi);
                }
                row("mp",logn,pi,dir,old,opt);
            }
        }
        compare_progress[0]=2; compare_progress[1]=pi;
        if(pi%28==0) printf("PROGRESS timing_prime=%u\n",pi);
    }
}
int mlk_test_main(int argc, char **argv)
{
    (void)argc; (void)argv;
    LL_RCC_ClocksTypeDef clocks; LL_RCC_GetSystemClocksFreq(&clocks);
    printf("COMPARE_BEGIN batches=10 calls=100 primes=308 patterns=8\n");
    printf("HW cpu=%u sysclk=%u hclk=%u ccr=%08x itcmcr=%08x dtcmcr=%08x\n",
      (unsigned)clocks.CPUCLK_Frequency,(unsigned)clocks.SYSCLK_Frequency,(unsigned)clocks.HCLK_Frequency,
      (unsigned)SCB->CCR,(unsigned)MEMSYSCTL->ITCMCR,(unsigned)MEMSYSCTL->DTCMCR);
    printf("ADDR orig_mq=%08x opt_mq=%08x orig_mp=%08x opt_mp=%08x data_mq=%08x data_mp=%08x gm=%08x igm=%08x igm_full=%08x\n",
      (unsigned)(uintptr_t)orig_mqpoly_int_to_ntt,(unsigned)(uintptr_t)opt_mqpoly_int_to_ntt,
      (unsigned)(uintptr_t)orig_mp_NTT,(unsigned)(uintptr_t)opt_mp_NTT,
      (unsigned)(uintptr_t)x,(unsigned)(uintptr_t)a,(unsigned)(uintptr_t)gm,(unsigned)(uintptr_t)igm,
      (unsigned)(uintptr_t)igm_full);
    if(clocks.CPUCLK_Frequency!=800000000 || clocks.SYSCLK_Frequency!=400000000 || clocks.HCLK_Frequency!=200000000 || (SCB->CCR&0x30000)) fail("hardware",0,0,0);
    CoreDebug->DEMCR |= CoreDebug_DEMCR_TRCENA_Msk;
    DWT->CTRL |= DWT_CTRL_CYCCNTENA_Msk;
    uint32_t t=tick(); k_busy_wait(1000); uint32_t delta=tick()-t;
    printf("TIMER wait_us=1000 cycles=%u\n",delta);
    if(delta<790000 || delta>820000) fail("timer",0,0,0);
    check_mq(); check_mp();
    printf("AUDIT_DONE cases=%u independent_dft=%u\n",checks,oracle_checks);
    bench_mq(); bench_mp();
    printf("COMPARE_DONE records=%u correctness=PASS timed_outputs=PASS\n",bench_records);
    return 0;
}
