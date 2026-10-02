#include "kgen_ds.h"
#include <stdio.h>
#include <string.h>
#include <zephyr/kernel.h>
#include <cmsis_core.h>
#include "oracle.h"
extern void fndsa_ds_decode4(const float[4],const float[4],uint32_t[4],uint32_t[4]);
extern void fndsa_q32_mul4(const uint32_t[4][4],uint32_t[2][4]);
static uint32_t mul_input[4][4],mul_output[4][4],mul_expected[4][4];
static float hi[4],lo[4];
static uint32_t high[4],low[4],rh[4],rl[4];
static fndsa_ds_poly input,other,actual,reference;
static struct { uint32_t before[4], words[2048], after[4]; } cache, expected_cache;
static uint64_t state=0x7365703237646563ull;
static volatile uint32_t sink;
static uint64_t random_word(void) {state^=state<<13;state^=state>>7;state^=state<<17;return state;}
static float from_bits(uint32_t u) {float f;memcpy(&f,&u,4);return f;}
static uint32_t bits(float f) {uint32_t u;memcpy(&u,&f,4);return u;}
static uint32_t ticks(void) {__DSB();__ISB();return DWT->CYCCNT;}
static __attribute__((noipa)) void reference_decode4(void) {
    for(unsigned i=0;i<4;i++) {
        uint64_t w=qd_raw_floor((q32ds){hi[i],lo[i]});
        rh[i]=(uint32_t)(w>>32);rl[i]=(uint32_t)w;
    }
}
static int compare(unsigned kind,unsigned index) {
    fndsa_ds_decode4(hi,lo,high,low);reference_decode4();
    for(unsigned i=0;i<4;i++)if(high[i]!=rh[i]||low[i]!=rl[i]) {
        printf("DECODE_FAIL kind=%u index=%u lane=%u h=%08x l=%08x got=%08x%08x ref=%08x%08x\n",
          kind,index,i,bits(hi[i]),bits(lo[i]),high[i],low[i],rh[i],rl[i]);
        return 0;
    }
    return 1;
}
static __attribute__((noinline)) uint32_t measure_decode(unsigned old) {
    for(unsigned j=0;j<16;j++) {
        if(old)reference_decode4();else fndsa_ds_decode4(hi,lo,high,low);
        __asm__ volatile("" ::: "memory");
    }
    unsigned irq=irq_lock();uint32_t t=ticks();
    for(unsigned j=0;j<128;j++) {
        if(old)reference_decode4();else fndsa_ds_decode4(hi,lo,high,low);
        __asm__ volatile("" ::: "memory");
    }
    t=ticks()-t;irq_unlock(irq);sink^=old?rh[0]:high[0];return t;
}
static const q32ds classes[]={
    {0,0},{-0.0f,0},{1,0},{-1,0},{1,0x1p-32f},{1,-0x1p-60f},
    {-1,0x1p-60f},{0x1p-32f,0},{0x1p-60f,0},{-0x1p-60f,0},
    {0x1p20f,0x1p-4f},{0x1p30f,-0x1p-10f},{-0x1p30f,0x1p-10f},
    {3.25f,0x1p-27f},{-3.25f,-0x1p-27f},{0x1p31f,0},{-0x1p31f,0},
    {0x1p32f,0},{-0x1p32f,0},{0x1p63f,0},{-0x1p63f,0},
    {0x1p95f,0},{0x1p-149f,-0x1p-149f},{0.5f,-0x1p-33f}};
static __attribute__((noipa)) void reference_mul4(void) {
    for(unsigned i=0;i<4;i++) {
        fxr x={(uint64_t)mul_input[0][i]<<32|mul_input[1][i]};
        fxr y={(uint64_t)mul_input[2][i]<<32|mul_input[3][i]};
        fxr z=fxr_mul(x,y);
        mul_expected[1][i]=z.v>>32;mul_expected[2][i]=(uint32_t)z.v;
    }
}
static int check_mul4(unsigned index) {
    memset(mul_output,0xa5,sizeof mul_output);
    memset(mul_expected,0xa5,sizeof mul_expected);
    fndsa_q32_mul4(mul_input,mul_output+1);reference_mul4();
    if(memcmp(mul_output,mul_expected,sizeof mul_output)) {
        printf("DECODE_FAIL raw_product index=%u\n",index);return 0;
    }
    return 1;
}
static __attribute__((noipa)) uint32_t measure_mul4(unsigned old) {
    for(unsigned j=0;j<4;j++) {
        if(old)reference_mul4();else fndsa_q32_mul4(mul_input,mul_output+1);
    }
    unsigned irq=irq_lock();uint32_t t=ticks();
    for(unsigned j=0;j<128;j++) {
        if(old)reference_mul4();else fndsa_q32_mul4(mul_input,mul_output+1);
        __asm__ volatile("" ::: "memory");
    }
    t=ticks()-t;irq_unlock(irq);sink^=old?mul_expected[1][0]:mul_output[1][0];
    return t;
}
static __attribute__((noipa)) uint32_t measure_span(unsigned logn) {
    /* Reset outside each timed interval: arithmetic never sees a repeatedly
     * multiplied polynomial. Calls, conversions and stores remain timed. */
    uint32_t sum=0;unsigned irq=irq_lock();
    for(unsigned j=0;j<32;j++) {
        actual=input;
        uint32_t t=ticks();fndsa_ds_mul(logn,&actual,&other);
        sum+=ticks()-t;__asm__ volatile("" ::: "memory");
    }
    irq_unlock(irq);sink^=bits(actual.re[0][0]);return sum;
}
static int check_cached(unsigned logn, unsigned index, unsigned alias) {
    const fndsa_ds_poly *b=alias?&input:&other;
    memset(&cache,0xa5,sizeof cache);
    memset(&expected_cache,0xa5,sizeof expected_cache);
    unsigned hn=1u<<(logn-1);
    for(unsigned i=0;i<hn;i++) {
        unsigned tile=(i/4)*16,lane=i%4;
        uint64_t re=qd_raw_floor((q32ds){b->re[0][i],b->re[1][i]});
        uint64_t im=qd_raw_floor((q32ds){b->im[0][i],b->im[1][i]});
        expected_cache.words[tile+lane]=re>>32;
        expected_cache.words[tile+4+lane]=(uint32_t)re;
        expected_cache.words[tile+8+lane]=im>>32;
        expected_cache.words[tile+12+lane]=(uint32_t)im;
    }
    fndsa_ds_prepare_mul(logn,cache.words,b);
    if(memcmp(&cache,&expected_cache,sizeof cache)) {
        printf("DECODE_FAIL cache_prepare logn=%u index=%u alias=%u\n",logn,index,alias);return 0;
    }
    actual=input;reference=input;
    fndsa_ds_mul_cached(logn,&actual,cache.words);
    oracle_mul(logn,&reference,alias?&reference:&other);
    if(memcmp(&actual,&reference,sizeof actual)||memcmp(&cache,&expected_cache,sizeof cache)) {
        printf("DECODE_FAIL cached_product logn=%u index=%u alias=%u\n",logn,index,alias);return 0;
    }
    return 1;
}
static __attribute__((noipa)) uint32_t measure_cached(unsigned logn,unsigned op) {
    /* op=0 prepare only, op=1 reused-cache multiply, op=2 preparation plus
     * ONE multiply. Input reset is outside each interval, same as span. */
    fndsa_ds_prepare_mul(logn,cache.words,&other);
    uint32_t sum=0;unsigned irq=irq_lock();
    for(unsigned j=0;j<32;j++) {
        actual=input;uint32_t t=ticks();
        if(op!=1)fndsa_ds_prepare_mul(logn,cache.words,&other);
        if(op!=0)fndsa_ds_mul_cached(logn,&actual,cache.words);
        sum+=ticks()-t;__asm__ volatile("" ::: "memory");
    }
    irq_unlock(irq);sink^=cache.words[0]^bits(actual.re[0][0]);return sum;
}
int mlk_test_main(int argc,char **argv) {
    (void)argc;(void)argv;CoreDebug->DEMCR|=CoreDebug_DEMCR_TRCENA_Msk;
    DWT->CTRL|=DWT_CTRL_CYCCNTENA_Msk;
    unsigned raw_products=0;
    static const uint64_t raw_edges[]={0,1,UINT64_MAX,UINT64_C(0x8000000000000000),
        UINT64_C(0x7fffffffffffffff),UINT64_C(0x100000000),UINT64_C(0xffffffff),
        UINT64_C(0x7fffffff),UINT64_C(0x80000000),UINT64_C(0x5555555555555555),
        UINT64_C(0xaaaaaaaaaaaaaaaa)};
    for(unsigned j=0;j<250121;j++) {
        for(unsigned i=0;i<4;i++) {
            uint64_t x=j<121?raw_edges[(j/11+i)%11]:random_word();
            uint64_t y=j<121?raw_edges[(j%11+3*i)%11]:random_word();
            mul_input[0][i]=x>>32;mul_input[1][i]=(uint32_t)x;
            mul_input[2][i]=y>>32;mul_input[3][i]=(uint32_t)y;
        }
        if(!check_mul4(j))return 7;
        raw_products+=4;
    }
    for(unsigned cls=0;cls<32;cls++) {
        for(unsigned i=0;i<4;i++) {
            uint64_t x=cls<11?raw_edges[cls]:random_word();
            uint64_t y=cls<11?raw_edges[(cls+i)%11]:random_word();
            mul_input[0][i]=x>>32;mul_input[1][i]=(uint32_t)x;
            mul_input[2][i]=y>>32;mul_input[3][i]=(uint32_t)y;
        }
        for(unsigned old=0;old<2;old++) {
            uint32_t min=UINT32_MAX,max=0;
            for(unsigned j=0;j<20;j++) {
                uint32_t t=measure_mul4(old);if(t<min)min=t;if(t>max)max=t;
            }
            printf("MUL4_TIMING class=%u scalar=%u calls=128 lanes=4 min=%u max=%u\n",cls,old,min,max);
        }
    }
    printf("MUL4_DONE values=%u failures=0\n",raw_products);
    /* Keep the earlier decoder/surrounding input sequence reproducible. */
    state=0x7365703237646563ull;
    /* Isolate the first diagnostic mismatch, before the codec itself. */
    {
        const uint32_t inputs[4]={0x8059a004,1,0x80000001,0x00800000};
        uint32_t vector[4],scalar[4],factor=0x4f800000;
        __asm__ volatile(
            "vldrw.u32 q0,[%[in]]\n\t"
            "vdup.32 q1,%[factor]\n\t"
            "vmul.f32 q0,q0,q1\n\t"
            "vstrw.u32 q0,[%[out]]"
            :: [in] "r"(inputs), [out] "r"(vector), [factor] "r"(factor)
            : "q0","q1","memory");
        for(unsigned i=0;i<4;i++) {
            __asm__ volatile(
                "vmov s0,%[in]\n\tvmov s1,%[factor]\n\t"
                "vmul.f32 s0,s0,s1\n\tvmov %[out],s0"
                : [out] "=r"(scalar[i]) : [in] "r"(inputs[i]), [factor] "r"(factor)
                : "s0","s1");
            printf("DECODE_SCALE lane=%u input=%08x vector=%08x scalar=%08x fpscr=%08x\n",
                i,inputs[i],vector[i],scalar[i],(unsigned)__get_FPSCR());
        }
    }
    unsigned values=0,products=0,inverses=0,divisions=0,cached_products=0;
    for(unsigned kind=0;kind<2;kind++)for(unsigned j=0;j<250000;j++) {
        for(unsigned i=0;i<4;i++) {
            if(!kind) {
                q32ds d=qd_from_raw(random_word());hi[i]=d.h;lo[i]=d.l;
            } else {
                /* Exponent <=222: scaling by 2^32 stays finite. */
                hi[i]=from_bits(((uint32_t)random_word()&0x807fffff)|((random_word()%223)<<23));
                lo[i]=from_bits(((uint32_t)random_word()&0x807fffff)|((random_word()%223)<<23));
            }
        }
        if(!compare(kind,j))return 1;
        values+=4;
    }
    for(unsigned e=0;e<223;e++)for(unsigned j=0;j<256;j++) {
        for(unsigned i=0;i<4;i++) {
            hi[i]=from_bits(((uint32_t)random_word()&0x807fffff)|(e<<23));
            lo[i]=classes[(j+i)%(sizeof classes/sizeof *classes)].l;
        }
        if(!compare(2,256*e+j))return 2;
        values+=4;
    }
    for(unsigned logn=1;logn<=10;logn++)for(unsigned j=0;j<32;j++) {
        memset(&input,0xa5,sizeof input);memset(&other,0xa5,sizeof other);
        unsigned hn=1u<<(logn-1);
        for(unsigned i=0;i<hn;i++)for(unsigned p=0;p<2;p++) {
            float (*a)[512]=p?input.im:input.re;
            float (*b)[512]=p?other.im:other.re;
            static const uint64_t edge[]={0,1,UINT64_MAX,UINT64_C(0x8000000000000000),
                UINT64_C(0x7fffffffffffffff),UINT64_C(0x100000000)};
            uint64_t xr=random_word(),yr=random_word();
            if(j==0){xr=edge[(i+p)%6];yr=edge[(i+2*p)%6];}
            q32ds x=qd_from_raw(xr),y=qd_from_raw(yr);
            a[0][i]=x.h;a[1][i]=x.l;b[0][i]=y.h;b[1][i]=y.l;
        }
        for(unsigned alias=0;alias<2;alias++) {
            actual=input;reference=input;
            fndsa_ds_mul(logn,&actual,alias?&actual:&other);
            oracle_mul(logn,&reference,alias?&reference:&other);
            if(memcmp(&actual,&reference,sizeof actual)) {
                printf("DECODE_FAIL product logn=%u index=%u alias=%u\n",logn,j,alias);return 3;
            }
            products++;
            actual=input;reference=input;
            fndsa_ds_div_real(logn,&actual,alias?&actual:&other);
            oracle_div_real(logn,&reference,alias?&reference:&other);
            if(memcmp(&actual,&reference,sizeof actual)) {
                printf("DECODE_FAIL division logn=%u index=%u alias=%u\n",logn,j,alias);return 5;
            }
            divisions++;
            if(logn>=3) {
                if(!check_cached(logn,j,alias))return 9;
                cached_products++;
            }
        }
        actual=input;reference=input;
        fndsa_ds_inverse(logn,&actual,j);oracle_inverse(logn,&reference,j);
        if(memcmp(&actual,&reference,sizeof actual)) {
            printf("DECODE_FAIL inverse logn=%u index=%u\n",logn,j);return 6;
        }
        inverses++;
    }
    for(unsigned c=0;c<sizeof classes/sizeof *classes;c++) {
        for(unsigned i=0;i<4;i++){hi[i]=classes[c].h;lo[i]=classes[c].l;}
        if(!compare(3,c))return 4;
        values+=4;
        for(unsigned old=0;old<2;old++) {
            uint32_t min=UINT32_MAX,max=0;
            for(unsigned j=0;j<20;j++) {
                uint32_t t=measure_decode(old);if(t<min)min=t;if(t>max)max=t;
            }
            printf("DECODE_TIMING class=%u scalar=%u calls=128 lanes=4 min=%u max=%u\n",c,old,min,max);
        }
    }
    for(unsigned op=0;op<3;op++)for(unsigned logn=9;logn<=10;logn++)for(unsigned old=0;old<2;old++) {
        uint64_t total=0;uint32_t min=UINT32_MAX,max=0;
        for(unsigned j=0;j<34;j++) {
            actual=input;
            unsigned irq=irq_lock();uint32_t t=ticks();
            if(op==0) {
                if(old)oracle_mul(logn,&actual,&other);else fndsa_ds_mul(logn,&actual,&other);
            } else if(op==1) {
                if(old)oracle_inverse(logn,&actual,10);else fndsa_ds_inverse(logn,&actual,10);
            } else {
                if(old)oracle_div_real(logn,&actual,&other);else fndsa_ds_div_real(logn,&actual,&other);
            }
            t=ticks()-t;irq_unlock(irq);sink^=bits(actual.re[0][0]);
            if(j>=2){total+=t;if(t<min)min=t;if(t>max)max=t;}
        }
        printf("SURROUND_TIMING op=%u logn=%u scalar=%u calls=32 total=%llu min=%u max=%u\n",
          op,logn,old,(unsigned long long)total,min,max);
    }
    unsigned span_classes=0;
    for(unsigned logn=3;logn<=9;logn+=6)for(unsigned c=0;c<sizeof classes/sizeof *classes;c++) {
        memset(&input,0xa5,sizeof input);memset(&other,0xa5,sizeof other);
        for(unsigned i=0;i<(1u<<(logn-1));i++)for(unsigned p=0;p<2;p++) {
            q32ds x=classes[(c+p)%(sizeof classes/sizeof *classes)];
            q32ds y=classes[(c+5+3*p)%(sizeof classes/sizeof *classes)];
            float (*a)[512]=p?input.im:input.re;
            float (*b)[512]=p?other.im:other.re;
            a[0][i]=x.h;a[1][i]=x.l;b[0][i]=y.h;b[1][i]=y.l;
        }
        actual=input;reference=input;
        fndsa_ds_mul(logn,&actual,&other);oracle_mul(logn,&reference,&other);
        if(memcmp(&actual,&reference,sizeof actual)) {
            printf("DECODE_FAIL span_class logn=%u class=%u\n",logn,c);return 8;
        }
        measure_span(logn);
        uint32_t min=UINT32_MAX,max=0;
        for(unsigned j=0;j<20;j++) {
            uint32_t t=measure_span(logn);if(t<min)min=t;if(t>max)max=t;
        }
        printf("SPAN_TIMING logn=%u class=%u calls=32 trials=20 min=%u max=%u match=1\n",logn,c,min,max);
        if(!check_cached(logn,c,0))return 10;
        cached_products++;
        for(unsigned op=0;op<3;op++) {
            measure_cached(logn,op);min=UINT32_MAX;max=0;
            for(unsigned j=0;j<20;j++) {
                uint32_t t=measure_cached(logn,op);if(t<min)min=t;if(t>max)max=t;
            }
            printf("CACHED_TIMING logn=%u class=%u op=%u calls=32 trials=20 min=%u max=%u\n",
                logn,c,op,min,max);
        }
        span_classes++;
    }
    printf("SPAN_DONE classes=%u failures=0\n",span_classes);
    printf("CACHED_DONE products=%u classes=%u guards=1 immutable=1 failures=0\n",cached_products,span_classes);
    printf("SURROUND_DONE inverse=%u division=%u failures=0\n",inverses,divisions);
    printf("DECODE_DONE values=%u products=%u failures=0\n",values,products);return 0;
}
