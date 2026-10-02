/* One measurement program for all candidates. Test switches do not select
 * production crypto implementations. No printing is inside timed regions. */
#include "inner.h"
#if BENCH_X4
#include "sha3x4.h"
#endif
#include <cmsis_core.h>
#include <stm32n6xx.h>
#include <stdio.h>
#include <string.h>
#include "keys.h"

enum { KSAMPLES=50, BATCH=32, SSAMPLES=32 };
extern void fndsa_sha3_process_block(uint64_t *,unsigned);
static uint64_t states[4][25] __attribute__((aligned(32)));
#if BENCH_X4
static struct { uint32_t pre[8]; fndsa_shake256x4_context c; uint32_t post[8]; } guarded __attribute__((aligned(32)));
#define ctx guarded.c
static uint64_t canonical[4][25], actual[4][25];
static uint8_t expected[2176], one[4][544];
#endif
static uint8_t sk[FNDSA_SIGN_KEY_SIZE(10)], pk[FNDSA_VRFY_KEY_SIZE(10)],sig[FNDSA_SIGNATURE_SIZE(10)];
static uint8_t tmp[59*1024+31] __attribute__((aligned(32)));
static volatile uint32_t sink;
static uint32_t rnd=0x12345678;
static uint32_t random32(void) { rnd^=rnd<<13; rnd^=rnd>>17; rnd^=rnd<<5; return rnd; }
static uint64_t rol(uint64_t x,unsigned n) { return n?(x<<n)|(x>>(64-n)):x; }
static void oracle(uint64_t a[25]) {
 static const unsigned rot[25]={0,1,62,28,27,36,44,6,55,20,3,10,43,25,39,41,45,15,21,8,18,2,61,56,14};
 static const uint64_t rc[24]={1,0x8082,0x800000000000808aULL,0x8000000080008000ULL,0x808b,
 0x80000001,0x8000000080008081ULL,0x8000000000008009ULL,0x8a,0x88,0x80008009,0x8000000a,
 0x8000808b,0x800000000000008bULL,0x8000000000008089ULL,0x8000000000008003ULL,
 0x8000000000008002ULL,0x8000000000000080ULL,0x800a,0x800000008000000aULL,
 0x8000000080008081ULL,0x8000000000008080ULL,0x80000001,0x8000000080008008ULL};
 for(unsigned r=0;r<24;r++) {
  uint64_t c[5],d[5],b[25];
  for(unsigned x=0;x<5;x++)c[x]=a[x]^a[x+5]^a[x+10]^a[x+15]^a[x+20];
  for(unsigned x=0;x<5;x++)d[x]=c[(x+4)%5]^rol(c[(x+1)%5],1);
  for(unsigned y=0;y<5;y++)for(unsigned x=0;x<5;x++)b[y+5*((2*x+3*y)%5)]=rol(a[x+5*y]^d[x],rot[x+5*y]);
  for(unsigned y=0;y<5;y++)for(unsigned x=0;x<5;x++)a[x+5*y]=b[x+5*y]^((~b[(x+1)%5+5*y])&b[(x+2)%5+5*y]);
  a[0]^=rc[r];
 }
}
static uint32_t begin(void) { __DSB();__ISB();return DWT->CYCCNT; }
static uint32_t end(uint32_t t) { __DSB();__ISB();return DWT->CYCCNT-t; }
static void hex_digest(const char *tag,shake_context *s,unsigned n) {
 uint8_t b[32]; char text[65];const char hex[]="0123456789abcdef";
 shake_flip(s);shake_extract(s,b,32);
 for(unsigned j=0;j<32;j++){text[2*j]=hex[b[j]>>4];text[2*j+1]=hex[b[j]&15];}text[64]=0;
 printf("DIGEST %s n=%u value=%s\n",tag,n,text);
}
static int tests(void) {
#if BENCH_X4
 for(unsigned i=0;i<8;i++)guarded.pre[i]=guarded.post[i]=0xbabecafe;
 for(unsigned t=0;t<64;t++) {
  for(unsigned s=0;s<4;s++)for(unsigned j=0;j<25;j++)canonical[s][j]=t==0?0:t==1?~UINT64_C(0):random32()|((uint64_t)random32()<<32);
  fndsa_keccakx4_import(ctx.a,canonical);
  for(unsigned k=0;k<2;k++) {
   fndsa_keccakx4_permute(ctx.a);fndsa_keccakx4_export(actual,ctx.a);
   for(unsigned s=0;s<4;s++)oracle(canonical[s]);
   if(memcmp(actual,canonical,sizeof actual)) {printf("FAIL permutation t=%u k=%u\n",t,k);return 1;}
  }
 }
 printf("CHECK permutation=PASS states=512\n");
 for(unsigned t=0;t<8;t++) {
  uint8_t seed[56];for(unsigned j=0;j<56;j++)seed[j]=(uint8_t)(j+37*t);
  for(unsigned s=0;s<4;s++) {
   shake_context sc;uint8_t id=s;shake_init(&sc,256);shake_inject(&sc,seed,56);shake_inject(&sc,&id,1);shake_flip(&sc);shake_extract(&sc,one[s],544);
  }
  for(unsigned k=0;k<4;k++)for(unsigned j=0;j<17;j++)for(unsigned s=0;s<4;s++)
   memcpy(expected+544*k+32*j+8*s,one[s]+136*k+8*j,8);
  fndsa_shake256x4_init(&ctx,seed);
  for(unsigned k=0;k<2176;k++)if(fndsa_shake256x4_next_u8(&ctx)!=expected[k])return 2;
  fndsa_shake256x4_init(&ctx,seed);
  unsigned pos=0;
  for(unsigned k=0;pos<2100;k++) {
   unsigned width=(k%3==0)?1:(k%3==1)?2:8;
   if((pos%544)+width>544)pos+=544-pos%544;
   uint64_t want=0,got;memcpy(&want,expected+pos,width);
   got=width==1?fndsa_shake256x4_next_u8(&ctx):width==2?fndsa_shake256x4_next_u16(&ctx):fndsa_shake256x4_next_u64(&ctx);
   if(got!=want)return 3;
   pos+=width;
  }
 }
 for(unsigned i=0;i<8;i++)if(guarded.pre[i]!=0xbabecafe||guarded.post[i]!=0xbabecafe)return 4;
 printf("CHECK shake256x4=PASS seeds=8 bytes_per_seed=2176 mixed_width_boundary=PASS guards=PASS\n");
#endif
 return 0;
}
static void kernels(void) {
 uint8_t seed[56];for(unsigned j=0;j<56;j++)seed[j]=j;
#if BENCH_X4
 fndsa_shake256x4_init(&ctx,seed);
#endif
 for(unsigned sample=0;sample<KSAMPLES+3;sample++) {
  uint32_t irq=__get_PRIMASK();__disable_irq();
  uint32_t t=begin();
  for(unsigned k=0;k<BATCH;k++) {
#if BENCH_X4
   fndsa_keccakx4_permute(ctx.a);
#else
   for(unsigned s=0;s<4;s++)fndsa_sha3_process_block(states[s],17);
#endif
  }
  uint32_t p=end(t);t=begin();
  for(unsigned k=0;k<BATCH;k++) {
#if BENCH_X4
   fndsa_shake256x4_refill(&ctx);sink^=ctx.buf[k];
#else
   for(unsigned s=0;s<4;s++)fndsa_sha3_process_block(states[s],17);
   sink^=(uint32_t)states[0][0];
#endif
  }
  uint32_t f=end(t);__set_PRIMASK(irq);
  if(sample>=3) {
#if BENCH_X4
   printf("KERNEL sample=%u batch=%u permutation4=%u refill544=%u\n",sample-3,BATCH,p,f);
#else
   printf("KERNEL sample=%u batch=%u permutation4=%u repeat_control=%u\n",sample-3,BATCH,p,f);
#endif
  }
 }
 /* End-to-end random output including seed expansion/packing and extraction. */
 for(unsigned sample=0;sample<KSAMPLES;sample++) {
  uint32_t irq=__get_PRIMASK();__disable_irq();uint32_t t=begin();
#if BENCH_X4
  fndsa_shake256x4_init(&ctx,seed);
  for(unsigned j=0;j<4096;j++)sink^=(uint32_t)fndsa_shake256x4_next_u64(&ctx);
#else
  shake_context sc;shake_init(&sc,256);shake_inject(&sc,seed,56);shake_flip(&sc);
  for(unsigned j=0;j<4096;j++)sink^=(uint32_t)shake_next_u64(&sc);
#endif
  uint32_t elapsed=end(t);__set_PRIMASK(irq);
  printf("PRNG sample=%u bytes=32768 cycles=%u\n",sample,elapsed);
 }
}
static int signatures(void) {
 for(unsigned logn=9;logn<=10;logn++) {
  size_t n=1u<<logn,sl=FNDSA_SIGN_KEY_SIZE(logn),pl=FNDSA_VRFY_KEY_SIZE(logn),zl=FNDSA_SIGNATURE_SIZE(logn);
  uint8_t seed[40],msg[32];for(unsigned j=0;j<40;j++)seed[j]=(uint8_t)(7*j+logn);memset(msg,0x5a,sizeof msg);
  memcpy(sk,logn==9?test_sk512:test_sk1024,sl);
  memcpy(pk,logn==9?test_pk512:test_pk1024,pl);
  shake_context ds,dk;shake_init(&ds,256);shake_init(&dk,256);shake_inject(&dk,sk,sl);shake_inject(&dk,pk,pl);hex_digest("key",&dk,n);
  for(unsigned k=0;k<SSAMPLES+2;k++) {
   seed[0]=(uint8_t)k;seed[1]=(uint8_t)logn;
   uint32_t irq=__get_PRIMASK();__disable_irq();uint32_t t=begin();
   size_t r=fndsa_sign_seeded_temp(sk,sl,"x4",2,FNDSA_HASH_ID_RAW,msg,sizeof msg,seed,sizeof seed,sig,zl,tmp,59*n+31);
   uint32_t elapsed=end(t);__set_PRIMASK(irq);
   if(r!=zl)return 6;
   if(!fndsa_verify_temp(sig,zl,pk,pl,"x4",2,FNDSA_HASH_ID_RAW,msg,sizeof msg,tmp,4*n+31))return 7;
   shake_inject(&ds,sig,zl);
   sig[zl-1]^=1;
   if(fndsa_verify_temp(sig,zl,pk,pl,"x4",2,FNDSA_HASH_ID_RAW,msg,sizeof msg,tmp,4*n+31))return 8;
   sig[zl-1]^=1;msg[0]^=1;
   if(fndsa_verify_temp(sig,zl,pk,pl,"x4",2,FNDSA_HASH_ID_RAW,msg,sizeof msg,tmp,4*n+31))return 9;
   msg[0]^=1;
   if(k>=2)printf("SIGN n=%u sample=%u cycles=%u verify=PASS tamper=PASS\n",(unsigned)n,k-2,elapsed);
  }
  hex_digest("signature",&ds,n);
 }
 printf("CHECK signature=PASS valid=68 rejected=136\n");return 0;
}
int mlk_test_main(int argc,char **argv) {
 (void)argc;(void)argv;
 printf("BENCH_BEGIN candidate=%s\n",BENCH_NAME);
 uint32_t control=*(volatile uint32_t*)0x56008008;
 printf("BENCH_HW cpu=%u ccr=%08x itcm=%08x dtcm=%08x control=%08x fpscr=%08x\n",(unsigned)SystemCoreClock,SCB->CCR,MEMSYSCTL->ITCMCR,MEMSYSCTL->DTCMCR,control,__get_FPSCR());
 if(SystemCoreClock!=800000000u||(SCB->CCR&0x30000u)||control!=0x99||(__get_FPSCR()&0x1c00000u))return 10;
 CoreDebug->DEMCR|=CoreDebug_DEMCR_TRCENA_Msk;*(volatile uint32_t*)0xe0001fb0=0xc5acce55;DWT->CYCCNT=0;DWT->CTRL|=1;
 int r=tests();if(!r){kernels();r=signatures();}
 printf("BENCH_DONE result=%d\n",r);return r;
}
