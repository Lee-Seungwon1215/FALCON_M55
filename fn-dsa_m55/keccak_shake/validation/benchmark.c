#include <cmsis_core.h>
#include <stm32n6xx.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "vectors.h"

#define SAMPLES 100
#define BATCH 64
typedef uint32_t (*bench_fn)(uint64_t *, unsigned);
extern void fndsa_sha3_process_block(uint64_t *, unsigned);
#define DECL(N) extern uint32_t bench_split##N(uint64_t *, unsigned); \
                extern uint32_t bench_merge##N(uint64_t *, unsigned);
DECL(1) DECL(2) DECL(3) DECL(4) DECL(5)
extern uint32_t bench_split_group(uint64_t *, unsigned);
extern uint32_t bench_merge_group(uint64_t *, unsigned);
extern uint32_t bench_helper_empty(uint64_t *, unsigned);
extern uint32_t bench_process(uint64_t *, unsigned);
extern uint32_t bench_process_empty(uint64_t *, unsigned);
extern unsigned bench_abi(uint64_t *);

static struct { uint64_t pre[4], a[25], post[4]; } state __attribute__((aligned(32)));
static uint32_t samples[SAMPLES][9];
static uint32_t rng = 0x6b656363;
static uint32_t random32(void) {
    rng ^= rng << 13; rng ^= rng >> 17; rng ^= rng << 5; return rng;
}
static uint64_t random64(void) { uint64_t x = random32(); return x | (uint64_t)random32() << 32; }
static uint64_t split_ref(uint64_t x) {
    uint32_t e=0,o=0;
    for (unsigned j=0;j<32;j++) { e|=((x>>(2*j))&1)<<j; o|=((x>>(2*j+1))&1)<<j; }
    return (uint64_t)o<<32 | e;
}
static uint64_t merge_ref(uint64_t x) {
    uint64_t y=0;
    for (unsigned j=0;j<32;j++) { y|=((x>>j)&1)<<(2*j); y|=((x>>(32+j))&1)<<(2*j+1); }
    return y;
}
static uint64_t rol(uint64_t x, unsigned n) { return n ? (x<<n)|(x>>(64-n)) : x; }
/* Independent, canonical 25-lane Keccak-f[1600] oracle, never timed. */
static void reference(uint64_t a[25]) {
    static const unsigned rotations[25] = {
        0,1,62,28,27,36,44,6,55,20,3,10,43,25,39,41,45,15,21,8,18,2,61,56,14};
    static const uint64_t rc[24] = {
        0x0000000000000001ULL,0x0000000000008082ULL,0x800000000000808aULL,
        0x8000000080008000ULL,0x000000000000808bULL,0x0000000080000001ULL,
        0x8000000080008081ULL,0x8000000000008009ULL,0x000000000000008aULL,
        0x0000000000000088ULL,0x0000000080008009ULL,0x000000008000000aULL,
        0x000000008000808bULL,0x800000000000008bULL,0x8000000000008089ULL,
        0x8000000000008003ULL,0x8000000000008002ULL,0x8000000000000080ULL,
        0x000000000000800aULL,0x800000008000000aULL,0x8000000080008081ULL,
        0x8000000000008080ULL,0x0000000080000001ULL,0x8000000080008008ULL};
    for (unsigned r=0;r<24;r++) {
        uint64_t c[5],d[5],b[25];
        for(unsigned x=0;x<5;x++) c[x]=a[x]^a[x+5]^a[x+10]^a[x+15]^a[x+20];
        for(unsigned x=0;x<5;x++) d[x]=c[(x+4)%5]^rol(c[(x+1)%5],1);
        for(unsigned y=0;y<5;y++) for(unsigned x=0;x<5;x++) a[x+5*y]^=d[x];
        for(unsigned y=0;y<5;y++) for(unsigned x=0;x<5;x++)
            b[y+5*((2*x+3*y)%5)]=rol(a[x+5*y],rotations[x+5*y]);
        for(unsigned y=0;y<5;y++) for(unsigned x=0;x<5;x++)
            a[x+5*y]=b[x+5*y]^((~b[(x+1)%5+5*y])&b[(x+2)%5+5*y]);
        a[0]^=rc[r];
    }
}
static int check_helpers(void) {
    bench_fn split[5]={bench_split1,bench_split2,bench_split3,bench_split4,bench_split5};
    bench_fn merge[5]={bench_merge1,bench_merge2,bench_merge3,bench_merge4,bench_merge5};
    for(unsigned n=1;n<=5;n++) for(unsigned t=0;t<1024;t++) {
        uint64_t a[5],b[5];
        for(unsigned j=0;j<5;j++) a[j]=b[j]=t==0?0:t==1?UINT64_MAX:t<66?(UINT64_C(1)<<(t-2)):random64();
        split[n-1](a,1);
        for(unsigned j=0;j<5;j++) if(a[j]!=(j<n?split_ref(b[j]):b[j])) return 1;
        merge[n-1](a,1);
        if(memcmp(a,b,sizeof a)) return 2;
        merge[n-1](a,1);
        for(unsigned j=0;j<5;j++) if(a[j]!=(j<n?merge_ref(b[j]):b[j])) return 3;
    }
    printf("CHECK helpers=PASS cases=5120 split_merge_roundtrip=PASS\n");
    return 0;
}
static int check_permutation(void) {
    uint64_t oracle[25];
    static const unsigned rates[5]={9,13,17,18,21};
    for(unsigned t=0;t<256;t++) {
        for(unsigned i=0;i<25;i++) {
            uint64_t v=t==0?0:t==1?UINT64_MAX:random64();
            oracle[i]=v;
            /* Preserve this exact reference's observed boundary representation:
             * lanes 0..20 canonical, lanes 21..24 even/odd interleaved. */
            state.a[i]=i<21?v:split_ref(v);
        }
        for(unsigned step=0;step<4;step++) {
            reference(oracle);
            fndsa_sha3_process_block(state.a,rates[t%5]);
            for(unsigned i=0;i<25;i++) {
                uint64_t v=i<21?state.a[i]:merge_ref(state.a[i]);
                if(v!=oracle[i]) {
                    printf("FAIL permutation case=%u step=%u lane=%u\n",t,step,i);
                    for(unsigned j=0;j<25;j++) {
                        uint64_t w=j<21?state.a[j]:merge_ref(state.a[j]);
                        printf("DIFF lane=%u got=%08x%08x expected=%08x%08x\n",j,
                            (uint32_t)(w>>32),(uint32_t)w,(uint32_t)(oracle[j]>>32),(uint32_t)oracle[j]);
                    }
                    return 4;
                }
            }
        }
    }
    printf("CHECK permutation=PASS cases=1024 canonical_oracle=PASS\n");
    return 0;
}
static int check_shake(void) {
    for(unsigned v=0;v<sizeof shake_vectors/sizeof shake_vectors[0];v++) {
        memset(state.a,0,sizeof state.a);
        uint8_t *a=(uint8_t *)state.a;
        unsigned off=0;
        for(unsigned j=0;j<shake_vectors[v].len;j++) {
            a[off++]^=(uint8_t)(29*j+7);
            if(off==136) { fndsa_sha3_process_block(state.a,17); off=0; }
        }
        a[off]^=0x1f; a[135]^=0x80;
        fndsa_sha3_process_block(state.a,17);
        off=0;
        for(unsigned j=0;j<256;j++) {
            if(off==136) { fndsa_sha3_process_block(state.a,17); off=0; }
            if(a[off++]!=shake_vectors[v].digest[j]) return 5;
        }
    }
    printf("CHECK shake256=PASS vectors=7 output_bytes=256 oracle=python_hashlib\n");
    return 0;
}
static int hardware_audit(void) {
    uint32_t ccr=SCB->CCR,it=MEMSYSCTL->ITCMCR,dt=MEMSYSCTL->DTCMCR;
    uint32_t control=*(volatile uint32_t *)0x56008008;
    printf("BENCH_HW cpu=%u ccr=%08x itcmcr=%08x dtcmcr=%08x control=%08x\n",
        (unsigned)SystemCoreClock,ccr,it,dt,control);
    return SystemCoreClock==800000000u && !(ccr&0x30000u)
        && (it&0x79)==0x49 && (dt&0x79)==0x49 && control==0x99;
}
static void timing_classes(void) {
    uint64_t sum[2]={0,0},sumsq[2]={0,0};
    uint32_t lo[2]={UINT32_MAX,UINT32_MAX},hi[2]={0,0};
    for(unsigned i=0;i<2000;i++) {
        unsigned c=i&1;
        for(unsigned j=0;j<25;j++) state.a[j]=c?random64():0;
        uint32_t key=__get_PRIMASK(); __disable_irq();
        uint32_t t=bench_process(state.a,1);
        __set_PRIMASK(key);
        sum[c]+=t; sumsq[c]+=(uint64_t)t*t;
        if(t<lo[c])lo[c]=t;
        if(t>hi[c])hi[c]=t;
    }
    for(unsigned c=0;c<2;c++)printf("TIMING_CLASS class=%u n=1000 sum=%llu sumsq=%llu min=%u max=%u\n",
        c,(unsigned long long)sum[c],(unsigned long long)sumsq[c],lo[c],hi[c]);
}
int mlk_test_main(int argc,char **argv) {
    (void)argc; (void)argv;
    printf("BENCH_BEGIN samples=%u batch=%u warmups=5 rate_words=17\n",SAMPLES,BATCH);
    if(!hardware_audit()) return 10;
    CoreDebug->DEMCR|=CoreDebug_DEMCR_TRCENA_Msk;
    *(volatile uint32_t *)0xe0001fb0=0xc5acce55;
    DWT->CYCCNT=0; DWT->CTRL|=DWT_CTRL_CYCCNTENA_Msk;
    for(unsigned i=0;i<4;i++) state.pre[i]=state.post[i]=UINT64_C(0x5a5ac3c3f0f09696);
    int r=check_helpers(); if(!r) r=check_permutation(); if(!r) r=check_shake();
    if(r) { printf("BENCH_FAIL result=%d\n",r); return r; }
    for(unsigned i=0;i<16;i++) {
        for(unsigned j=0;j<25;j++) state.a[j]=random64();
        uint32_t key=__get_PRIMASK(); __disable_irq();
        unsigned bad=bench_abi(state.a);
        __set_PRIMASK(key);
        if(bad)return 7;
    }
    printf("CHECK ABI=PASS cases=16 GPR=R4_R11 FP=D8_D15\n");
    const bench_fn funcs[9]={bench_process,bench_process_empty,bench_split1,bench_split5,
        bench_merge1,bench_merge5,bench_split_group,bench_merge_group,bench_helper_empty};
    for(unsigned s=0;s<SAMPLES+5;s++) {
        for(unsigned i=0;i<9;i++) {
            for(unsigned j=0;j<25;j++) state.a[j]=random64();
            uint32_t key=__get_PRIMASK(); __disable_irq();
            uint32_t cycles=funcs[i](state.a,BATCH);
            __set_PRIMASK(key);
            if(s>=5) samples[s-5][i]=cycles;
        }
    }
    for(unsigned i=0;i<4;i++) if(state.pre[i]!=UINT64_C(0x5a5ac3c3f0f09696)
        ||state.post[i]!=UINT64_C(0x5a5ac3c3f0f09696)) return 6;
    for(unsigned s=0;s<SAMPLES;s++) {
        printf("BENCH_SAMPLE i=%u process=%u process_empty=%u split1=%u split5=%u merge1=%u merge5=%u split_group=%u merge_group=%u helper_empty=%u\n",
            s,samples[s][0],samples[s][1],samples[s][2],samples[s][3],samples[s][4],
            samples[s][5],samples[s][6],samples[s][7],samples[s][8]);
    }
    timing_classes();
    printf("BENCH_DONE correctness=PASS guards=PASS result=0\n");
    return 0;
}
