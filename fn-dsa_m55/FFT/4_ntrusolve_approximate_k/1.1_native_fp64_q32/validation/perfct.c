/* Diagnostic only. Crypto sources are unchanged. Fixed and trial run in
 * ONE ELF, on the SAME data addresses. Preparation and printing are untimed.
 * Fixed public loop lengths; value classes exercise the compiled helpers.
 * Neither this timing experiment nor finite key tests prove constant time. */
#include "kgen_inner.h"
#include <stdio.h>
#include <string.h>
#include <cmsis_core.h>
#include <stm32n6xx.h>
#include "perf_cases.h"

#define NOINLINE __attribute__((noinline,noclone))
#define NMAX 512
#define REPS 100
#define CT_REPS 50
#define BATCH 128
typedef union { fxr q[NMAX]; double d[NMAX]; } vector;
static vector a __attribute__((aligned(32))), b __attribute__((aligned(32)));
static fxr ia[NMAX],ib[NMAX];
static double da[NMAX],db[NMAX];
static int32_t k[NMAX],k_saved[NMAX];
static volatile uint64_t sink;
static double as_double(uint64_t x)
{ return (double)(int32_t)(x>>32)+(double)(uint32_t)x*0x1p-32; }
static uint64_t bits(double x) { uint64_t r;memcpy(&r,&x,8);return r; }
static inline uint32_t now(void)
{ __DSB();__ISB();return DWT->CYCCNT; }
/* Keep MVE LTPSIZE and FP control state. Writing FPSCR=0 invalidates the
 * low-overhead loop state used by the platform's MVE memcpy. Clear only
 * cumulative IEEE exception flags, outside the timed region. */
static inline void clear_fp_flags(void) { __set_FPSCR(__get_FPSCR() & ~0x9fu); }
struct stats { uint32_t min,max,count;uint64_t sum,sumsq; };
static void add(struct stats *s,uint32_t t)
{ if(!s->count||t<s->min)s->min=t;if(t>s->max)s->max=t;s->count++;s->sum+=t;s->sumsq+=(uint64_t)t*t; }
static void stats_print(const struct stats *s)
{ printf(" count=%u min=%u max=%u sum=%llu sumsq=%llu\n",s->count,s->min,s->max,(unsigned long long)s->sum,(unsigned long long)s->sumsq); }
static void fixed_round(unsigned l)
{ for(unsigned i=0;i<(1u<<l);i++)k[i]=fxr_round(a.q[i]); }
static void trial_round(unsigned l)
{ uint32_t valid=1;for(unsigned i=0;i<(1u<<l);i++)k[i]=fp64_round_i32_checked(a.d[i],&valid);sink=valid; }

/* Stable, unspecialized call sites. The switch/initialization is NOT timed. */
static NOINLINE void fixed_fft(unsigned l,unsigned e) { (void)e;vect_FFT(l,a.q); }
static NOINLINE void trial_fft(unsigned l,unsigned e) { (void)e;vect_FFT_fp64(l,a.d); }
static NOINLINE void fixed_ifft(unsigned l,unsigned e) { (void)e;vect_iFFT(l,a.q); }
static NOINLINE void trial_ifft(unsigned l,unsigned e) { (void)e;vect_iFFT_fp64(l,a.d); }
static NOINLINE void fixed_mul(unsigned l,unsigned e) { (void)e;vect_mul_fft(l,a.q,b.q); }
static NOINLINE void trial_mul(unsigned l,unsigned e) { (void)e;vect_mul_fft_fp64(l,a.d,b.d); }
static NOINLINE void fixed_inv(unsigned l,unsigned e) { vect_inv_mul2e_fft(l,a.q,e); }
static NOINLINE void trial_inv(unsigned l,unsigned e) { vect_inv_mul2e_fft_fp64(l,a.d,e); }
static NOINLINE void fixed_prepare(unsigned l,unsigned e) { vect_FFT(l,a.q);vect_inv_mul2e_fft(l,a.q,e); }
static NOINLINE void trial_prepare(unsigned l,unsigned e) { vect_FFT_fp64(l,a.d);vect_inv_mul2e_fft_fp64(l,a.d,e); }
static NOINLINE void fixed_repeat(unsigned l,unsigned e)
{ (void)e;vect_FFT(l,a.q);vect_mul_fft(l,a.q,b.q);vect_iFFT(l,a.q);fixed_round(l); }
static NOINLINE void trial_repeat(unsigned l,unsigned e)
{ (void)e;vect_FFT_fp64(l,a.d);vect_mul_fft_fp64(l,a.d,b.d);vect_iFFT_fp64(l,a.d);trial_round(l); }
static NOINLINE void fixed_pipeline(unsigned l,unsigned e)
{ vect_FFT(l,b.q);vect_inv_mul2e_fft(l,b.q,e);fixed_repeat(l,e); }
static NOINLINE void trial_pipeline(unsigned l,unsigned e)
{ vect_FFT_fp64(l,b.d);vect_inv_mul2e_fft_fp64(l,b.d,e);trial_repeat(l,e); }
typedef void (*kernel)(unsigned,unsigned);
static const kernel functions[2][7]={
 {fixed_fft,fixed_ifft,fixed_mul,fixed_inv,fixed_prepare,fixed_repeat,fixed_pipeline},
 {trial_fft,trial_ifft,trial_mul,trial_inv,trial_prepare,trial_repeat,trial_pipeline}};
static const char *names[]={"FFT","iFFT","pointwise","inverse","prepare","repeat","pipeline"};
static void reset(unsigned backend,unsigned n)
{
 if(backend) { memcpy(a.d,da,n*8);memcpy(b.d,db,n*8); }
 else { memcpy(a.q,ia,n*8);memcpy(b.q,ib,n*8); }
}
static void prepare(const struct kernel_case *c,unsigned op)
{
 unsigned n=1u<<c->logn;
 for(unsigned i=0;i<n;i++) { ia[i].v=(op==0||op==3||op==4)?c->f[i]:c->F[i];ib[i].v=c->f[i]; }
 if(op==1||op==2||op==3)vect_FFT(c->logn,ia);
 if(op==2||op==5) { vect_FFT(c->logn,ib);vect_inv_mul2e_fft(c->logn,ib,c->e); }
 for(unsigned i=0;i<n;i++) { da[i]=as_double(ia[i].v);db[i]=as_double(ib[i].v); }
}
static void kernels(void)
{
 for(unsigned c=0;c<sizeof cases/sizeof cases[0];c++) {
  unsigned l=cases[c].logn,n=1u<<l;
  for(unsigned op=0;op<7;op++) {
   struct stats s[2]={{0},{0}};prepare(&cases[c],op);
   for(unsigned r=0;r<REPS+10;r++)for(unsigned j=0;j<2;j++) {
    unsigned v=j^(r&1);reset(v,n);clear_fp_flags();
    uint32_t t=now();functions[v][op](l,cases[c].e);t=now()-t;
    sink=a.q[0].v;if(r>=10)add(&s[v],t);
   }
   for(unsigned v=0;v<2;v++) {
    printf("KPERF case=%u logn=%u op=%s backend=%s",c,l,names[op],v?"q32_trial":"fixed");stats_print(&s[v]);
   }
   if(op==6) {
    reset(0,n);fixed_pipeline(l,cases[c].e);memcpy(k_saved,k,n*sizeof *k);
    reset(1,n);trial_pipeline(l,cases[c].e);unsigned diff=0,fixture=0;
    for(unsigned i=0;i<n;i++){diff+=k_saved[i]!=k[i];fixture+=k_saved[i]!=cases[c].k_fixed[i];}
    printf("PERF_K case=%u logn=%u differences=%u fixed_fixture_errors=%u\n",c,l,diff,fixture);
   }
  }
 }
}

/* Public symbols permit direct disassembly and prevent compiler inlining
 * across the identical indirect-call timing harness. */
NOINLINE double probe_floor(double x,double y) { (void)y;return fp64q_floor(x); }
NOINLINE double probe_wrap(double x,double y) { (void)y;return fp64q_wrap(x); }
NOINLINE double probe_add(double x,double y) { return fp64q_add(x,y); }
NOINLINE double probe_mul(double x,double y) { return fp64q_mul(x,y); }
NOINLINE double probe_half(double x,double y) { (void)y;return fp64q_half(x); }
NOINLINE double probe_div(double x,double y) { return fp64q_div(x,y); }
NOINLINE double probe_round(double x,double y)
{ (void)y;uint32_t valid=1;return (double)fp64_round_i32_checked(x,&valid); }
NOINLINE double probe_complex(double x,double y)
{ fp64c z=fp64c_mul((fp64c){x,y},(fp64c){y,x});return z.re+z.im; }
static const struct {const char *name;double (*fn)(double,double);} probes[]={
 {"floor",probe_floor},{"wrap",probe_wrap},{"add",probe_add},{"mul",probe_mul},
 {"half",probe_half},{"div",probe_div},{"round",probe_round},{"complex",probe_complex}};
static const struct { const char *name;double x,y; } inputs[]={
 {"zero",0,1.5},{"unit",1,1.5},{"negative",-1,1.5},
 {"quarter",0.25,1.5},{"negquarter",-0.25,1.5},
 {"tiny",0x1p-32,1.5},{"negtiny",-0x1p-32,1.5},
 {"thirdish",0x1.55555554p-2,0x1.55555554p-1},
 {"nearone",0x1.00000001p0,0x1.fffffffep-1},
 {"large",0x1.0000000000001p20,1.5},
 {"negative_large",-0x1.0000000000001p20,1.5},
 {"zero_denominator",1,0}};
static volatile double px,py;
static NOINLINE uint32_t batch(double (*fn)(double,double))
{
 uint32_t t=now();
 for(unsigned j=0;j<BATCH;j++) { double z=fn(px,py);sink=bits(z); }
 return now()-t;
}
static void primitives(void)
{
 for(unsigned op=0;op<sizeof probes/sizeof probes[0];op++) {
  struct stats s[sizeof inputs/sizeof inputs[0]]={{0}};
  for(unsigned r=0;r<CT_REPS+5;r++)for(unsigned j=0;j<sizeof inputs/sizeof inputs[0];j++) {
   unsigned c=(j+r)%(sizeof inputs/sizeof inputs[0]);px=inputs[c].x;py=inputs[c].y;clear_fp_flags();
   uint32_t t=batch(probes[op].fn);if(r>=5)add(&s[c],t);
  }
  for(unsigned c=0;c<sizeof inputs/sizeof inputs[0];c++) {
   printf("CT_PRIMITIVE op=%s class=%s batch=%u",probes[op].name,inputs[c].name,BATCH);stats_print(&s[c]);
  }
 }
}
static const char *classes[]={"zero","unit","alternating","fractions","tiny","nearone"};
static void fft_timing(void)
{
 for(unsigned l=4;l<=9;l+=(l==4?4:1))for(unsigned op=0;op<2;op++) {
  unsigned n=1u<<l;struct stats s[2][6]={0};
  for(unsigned r=0;r<CT_REPS+5;r++)for(unsigned j=0;j<6;j++) {
   unsigned c=(j+r)%6;
   for(unsigned i=0;i<n;i++) {
    uint64_t x=0;
    if(c==1)x=UINT64_C(1)<<32;
    if(c==2)x=(i&1)?-(UINT64_C(1)<<32):UINT64_C(1)<<32;
    if(c==3)x=(uint64_t)(int64_t)((int32_t)((i*2654435761u)>>8)-0x800000);
    if(c==4)x=(i&1)?UINT64_MAX:1;
    if(c==5)x=(UINT64_C(1)<<32)+((i&1)?1:UINT64_MAX);
    ia[i].v=x;da[i]=as_double(x);
   }
   for(unsigned j2=0;j2<2;j2++) {
    unsigned v=j2^(r&1);reset(v,n);clear_fp_flags();
    uint32_t t=now();functions[v][op](l,0);t=now()-t;
    sink=a.q[0].v;if(r>=5)add(&s[v][c],t);
   }
  }
  for(unsigned v=0;v<2;v++)for(unsigned c=0;c<6;c++) {
   printf("CT_FFT logn=%u op=%s backend=%s class=%s",l,names[op],v?"q32_trial":"fixed",classes[c]);stats_print(&s[v][c]);
  }
 }
}
static NOINLINE void counterexample(void)
{
 volatile uint64_t va=UINT64_C(0x100000001),vb=UINT64_C(0xffffffff);
 uint64_t x=va,y=vb;fxr z=fxr_mul(fxr_of_scaled32(x),fxr_of_scaled32(y));
 double d=fp64q_mul(as_double(x),as_double(y));
 int32_t kq=fxr_round(fxr_sub(z,fxr_of_scaled32(UINT64_C(0x80000000))));
 int32_t kd=fp64_round_i32(fp64q_sub(d,0.5));
 printf("COUNTEREXAMPLE_BOARD fixed=%016llx trial=%016llx fixed_k=%ld trial_k=%ld\n",
  (unsigned long long)z.v,(unsigned long long)bits(d),(long)kq,(long)kd);
}
int mlk_test_main(int argc,char **argv)
{
 (void)argc;(void)argv;
 printf("PERFCT_HW cpu=%u fpscr=%08x ccr=%08x tcm=%08x\n",(unsigned)SystemCoreClock,(unsigned)__get_FPSCR(),(unsigned)SCB->CCR,*(volatile unsigned*)0x56008008);
 if(SystemCoreClock!=800000000u||(SCB->CCR&0x30000u)||*(volatile unsigned*)0x56008008!=0x99u||(__get_FPSCR()&0x1C00000u))return 10;
 CoreDebug->DEMCR|=CoreDebug_DEMCR_TRCENA_Msk;DWT->CTRL|=DWT_CTRL_CYCCNTENA_Msk;
 __disable_irq();counterexample();kernels();primitives();fft_timing();
 printf("PERFCT_DONE cases=%u\n",(unsigned)(sizeof cases/sizeof cases[0]));
 __enable_irq();return 0;
}
