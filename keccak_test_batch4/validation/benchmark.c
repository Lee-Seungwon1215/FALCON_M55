/* Same-image reference vs independent batch, including all preprocessing.
 * Test-only reference sources are the original three signing files with
 * exported names mechanically prefixed. All other code is shared unchanged.
 */
#include "fndsa_batch4.h"
#include "shake_batch4.h"
#include <cmsis_core.h>
#include <stm32n6xx.h>
#include <stdio.h>
#include "keys.h"

size_t reference_fndsa_sign_seeded_temp(const void *, size_t, const void *, size_t,
    const char *, const void *, size_t, const void *, size_t, void *, size_t,
    void *, size_t);

enum { MAX_BLOCKS=112, SAMPLES=40 };
static struct {
    uint32_t pre[8];
    uint8_t data[sizeof(fndsa_batch4_work)+544*MAX_BLOCKS+32];
    uint32_t post[8];
} memory __attribute__((aligned(32)));
static uint8_t sig[4][FNDSA_SIGNATURE_SIZE(10)], expected[4][FNDSA_SIGNATURE_SIZE(10)];
static uint8_t seed[4][80], msg[4][80];
static fndsa_sign_batch4_job jobs[4];
static unsigned checked, rejected, batch_verified, batch_rejected;
static const uint8_t *const sks[2][4] = {
    {test_sk512_0,test_sk512_1,test_sk512_2,test_sk512_3},
    {test_sk1024_0,test_sk1024_1,test_sk1024_2,test_sk1024_3}};
static const uint8_t *const pks[2][4] = {
    {test_pk512_0,test_pk512_1,test_pk512_2,test_pk512_3},
    {test_pk1024_0,test_pk1024_1,test_pk1024_2,test_pk1024_3}};

static fndsa_batch4_work *workspace(void) { return (void *)memory.data; }
static uint32_t begin(void) { __DSB();__ISB();return DWT->CYCCNT; }
static uint32_t end(uint32_t t) { __DSB();__ISB();return DWT->CYCCNT-t; }
static int guards(void) {
    for(unsigned i=0;i<8;i++)
        if(memory.pre[i]!=0xabcddcba || memory.post[i]!=0xabcddcba) return 0;
    return 1;
}
static int streams(void) {
    static const unsigned counts[]={0,1,2,7,112};
    uint8_t seeds[4][40];
    for(unsigned s=0;s<4;s++)for(unsigned j=0;j<40;j++)seeds[s][j]=(uint8_t)(j*7+s*57);
    fndsa_batch4_work *w=workspace();
    for(unsigned k=0;k<sizeof counts/sizeof counts[0];k++) {
        unsigned b=counts[k];
        fndsa_shake_batch4_prepare(w->streams,seeds,b,(uint8_t *)(w+1));
        for(unsigned s=0;s<4;s++) {
            shake_context ref; uint8_t zero=0;
            shake_init(&ref,256);shake_inject(&ref,seeds[s],40);shake_inject(&ref,&zero,1);shake_flip(&ref);
            /* Unequal lane consumption, crossing every rate and cache boundary. */
            unsigned limit=b*136+1537+71*s, pos=0;
            while(pos<limit) {
                unsigned width=((pos+s)%3)==0?1:((pos+s)%3)==1?2:8;
                uint64_t want=0, got;
                shake_extract(&ref,&want,width);
                got=width==1?fndsa_sampler_u8(&w->streams[s]):width==2?
                    fndsa_sampler_u16(&w->streams[s]):fndsa_sampler_u64(&w->streams[s]);
                if(got!=want) {printf("FAIL stream blocks=%u lane=%u pos=%u width=%u\n",b,s,pos,width);return 1;}
                pos+=width;
            }
        }
    }
    /* Explicit 1..7-byte straddles, not just naturally occurring positions. */
    for(unsigned tail=1;tail<=7;tail++) {
        fndsa_shake_batch4_prepare(w->streams,seeds,1,(uint8_t *)(w+1));
        for(unsigned s=0;s<4;s++) {
            shake_context ref;uint8_t zero=0, discard[136];uint64_t want;
            shake_init(&ref,256);shake_inject(&ref,seeds[s],40);shake_inject(&ref,&zero,1);shake_flip(&ref);
            shake_extract(&ref,discard,136-tail);
            fndsa_sampler_extract(&w->streams[s],discard,136-tail);
            shake_extract(&ref,&want,8);
            if(fndsa_sampler_u64(&w->streams[s])!=want)return 2;
        }
    }
    for(uint8_t counter=1;counter<27;counter++)for(unsigned s=0;s<4;s++) {
        fndsa_sampler_prng p;shake_context ref;uint8_t a[300],b[300];
        fndsa_sampler_init(&p,seeds[s],40,counter);
        shake_init(&ref,256);shake_inject(&ref,seeds[s],40);shake_inject(&ref,&counter,1);shake_flip(&ref);
        fndsa_sampler_extract(&p,a,sizeof a);shake_extract(&ref,b,sizeof b);
        if(memcmp(a,b,sizeof a))return 3;
    }
    if(!guards())return 4;
    printf("CHECK streams=PASS prefix_blocks=0,1,2,7,112 tails=1..7 retry_counters=1..26\n");
    return 0;
}
static void setup(unsigned logn,unsigned sample,int mixed) {
    for(unsigned s=0;s<4;s++) {
        unsigned l=mixed?(9+(s&1)):logn;
        for(unsigned j=0;j<80;j++) {seed[s][j]=(uint8_t)(j*11+s*43+sample);msg[s][j]=(uint8_t)(j*7+s*23+sample*3);}
        seed[s][1]=(uint8_t)(sample>>8);
        jobs[s]=(fndsa_sign_batch4_job){
            .sign_key=sks[l-9][s],.sign_key_len=FNDSA_SIGN_KEY_SIZE(l),
            .ctx="batch-original",.ctx_len=14,.id=FNDSA_HASH_ID_RAW,
            .hv=msg[s],.hv_len=32+7*s,
            .seed=seed[s],.seed_len=40+s*8,
            .sig=sig[s],.max_sig_len=FNDSA_SIGNATURE_SIZE(l)};
    }
}
static int original(void) {
    for(unsigned s=0;s<4;s++) {
        fndsa_sign_batch4_job *j=&jobs[s];
        size_t z=reference_fndsa_sign_seeded_temp(j->sign_key,j->sign_key_len,
            j->ctx,j->ctx_len,j->id,j->hv,j->hv_len,j->seed,j->seed_len,
            expected[s],j->max_sig_len,workspace()->tmp,sizeof workspace()->tmp);
        if(z!=j->max_sig_len)return 5;
    }
    return 0;
}
static int verify(void) {
    for(unsigned s=0;s<4;s++) {
        fndsa_sign_batch4_job *j=&jobs[s];unsigned logn=*(const uint8_t *)j->sign_key&15;
        if(j->sig_len!=j->max_sig_len||memcmp(sig[s],expected[s],j->sig_len)) {
            printf("FAIL signature lane=%u n=%u length=%u\n",s,1u<<logn,(unsigned)j->sig_len);return 6;
        }
        if(!fndsa_verify_temp(sig[s],j->sig_len,pks[logn-9][s],FNDSA_VRFY_KEY_SIZE(logn),
            j->ctx,j->ctx_len,j->id,j->hv,j->hv_len,workspace()->tmp,sizeof workspace()->tmp))return 7;
        sig[s][j->sig_len-1]^=1;
        if(fndsa_verify_temp(sig[s],j->sig_len,pks[logn-9][s],FNDSA_VRFY_KEY_SIZE(logn),
            j->ctx,j->ctx_len,j->id,j->hv,j->hv_len,workspace()->tmp,sizeof workspace()->tmp))return 8;
        sig[s][j->sig_len-1]^=1;msg[s][0]^=1;
        if(fndsa_verify_temp(sig[s],j->sig_len,pks[logn-9][s],FNDSA_VRFY_KEY_SIZE(logn),
            j->ctx,j->ctx_len,j->id,j->hv,j->hv_len,workspace()->tmp,sizeof workspace()->tmp))return 9;
        msg[s][0]^=1;checked++;rejected+=2;
    }
    /* End-to-end integration: the newly added four-job verifier consumes
     * the four original-compatible signatures produced above. Reuse work
     * only AFTER signing completed; no live prefix stream is overwritten. */
    fndsa_verify_batch4_job v[4];
    for(unsigned s=0;s<4;s++) {
        fndsa_sign_batch4_job *j=&jobs[s];
        unsigned logn=*(const uint8_t *)j->sign_key&15;
        v[s]=(fndsa_verify_batch4_job){sig[s],j->sig_len,pks[logn-9][s],
            FNDSA_VRFY_KEY_SIZE(logn),j->ctx,j->ctx_len,j->id,j->hv,j->hv_len,0};
    }
    if(!fndsa_verify_batch4_temp(v,memory.data,sizeof memory.data))return 20;
    for(unsigned s=0;s<4;s++){if(!v[s].valid)return 21;batch_verified++;}
    sig[0][jobs[0].sig_len-1]^=1;
    if(!fndsa_verify_batch4_temp(v,memory.data,sizeof memory.data))return 22;
    if(v[0].valid||!v[1].valid||!v[2].valid||!v[3].valid)return 23;
    sig[0][jobs[0].sig_len-1]^=1;batch_rejected++;
    return guards()?0:10;
}
static int signatures(void) {
    static const unsigned policies[]={32,64,112};
    for(unsigned logn=9;logn<=10;logn++)for(unsigned policy=0;policy<3;policy++) {
        for(unsigned sample=0;sample<SAMPLES+2;sample++) {
            setup(logn,sample,0);unsigned blocks=policies[policy];
            uint32_t irq=__get_PRIMASK(),a,b,t;__disable_irq();int rc,ok;
            /* Alternate order to limit drift/order bias. */
            if(sample&1) {
                t=begin();ok=fndsa_sign_seeded_batch4_temp(jobs,blocks,memory.data,sizeof memory.data);b=end(t);
                t=begin();rc=original();a=end(t);
            } else {
                t=begin();rc=original();a=end(t);
                t=begin();ok=fndsa_sign_seeded_batch4_temp(jobs,blocks,memory.data,sizeof memory.data);b=end(t);
            }
            __set_PRIMASK(irq);if(rc)return rc;if(!ok)return 11;
            rc=verify();if(rc)return rc;
            if(sample>=2)printf("BATCH n=%u blocks=%u sample=%u original4=%u batch4=%u exact=4/4\n",1u<<logn,blocks,sample-2,a,b);
        }
    }
    printf("CHECK signatures=PASS exact=%u verified=%u rejected=%u keys=8\n",checked,checked,rejected);
    return 0;
}
static int api(void) {
    setup(9,517,1);
    /* Mixed degree/key/message/context and external-mu mode. */
    jobs[0].ctx=NULL;jobs[0].ctx_len=0;jobs[0].seed_len=0;
    jobs[1].id=FNDSA_HASH_ID_SHA256;jobs[1].hv_len=32;
    jobs[2].id=FNDSA_HASH_ID_EXTMU;jobs[2].hv_len=64;
    int rc=original();if(rc)return rc;
    for(unsigned blocks=0;blocks<=1;blocks++) {
        if(!fndsa_sign_seeded_batch4_temp(jobs,blocks,memory.data,sizeof memory.data))return 12;
        rc=verify();if(rc)return rc;
    }
    setup(10,518,0);rc=original();if(rc)return rc;
    /* Ordinary, nonbatch API remains byte-exact as well. */
    for(unsigned s=0;s<4;s++) {
        fndsa_sign_batch4_job *j=&jobs[s];
        j->sig_len=fndsa_sign_seeded_temp(j->sign_key,j->sign_key_len,j->ctx,j->ctx_len,
            j->id,j->hv,j->hv_len,j->seed,j->seed_len,j->sig,j->max_sig_len,workspace()->tmp,sizeof workspace()->tmp);
    }
    rc=verify();if(rc)return rc;
    if(fndsa_sign_batch4_temp_size(161)!=0)return 13;
    if(fndsa_sign_seeded_batch4_temp(jobs,1,memory.data,fndsa_sign_batch4_temp_size(1)-1))return 14;
    jobs[2].seed=NULL;
    if(fndsa_sign_seeded_batch4_temp(jobs,1,memory.data,sizeof memory.data))return 15;
    for(unsigned s=0;s<4;s++)if(jobs[s].sig_len)return 16;
    fndsa_sign_batch4_clear(memory.data,sizeof memory.data);
    for(size_t i=0;i<sizeof memory.data;i++)if(memory.data[i])return 17;
    if(!guards())return 18;
    printf("CHECK api=PASS mixed_degrees=PASS single=PASS short_buffer=PASS null_seed=PASS clear=PASS\n");
    return 0;
}
int mlk_test_main(int argc,char **argv) {
    (void)argc;(void)argv;
    for(unsigned i=0;i<8;i++)memory.pre[i]=memory.post[i]=0xabcddcba;
    printf("BENCH_BEGIN independent_batch4 work=%u max_need=%u\n",(unsigned)sizeof memory.data,(unsigned)fndsa_sign_batch4_temp_size(MAX_BLOCKS));
    uint32_t control=*(volatile uint32_t*)0x56008008;
    printf("BENCH_HW cpu=%u ccr=%08x itcm=%08x dtcm=%08x control=%08x fpscr=%08x\n",(unsigned)SystemCoreClock,SCB->CCR,MEMSYSCTL->ITCMCR,MEMSYSCTL->DTCMCR,control,__get_FPSCR());
    if(SystemCoreClock!=800000000u||(SCB->CCR&0x30000u)||control!=0x99||(__get_FPSCR()&0x1c00000u))return 19;
    CoreDebug->DEMCR|=CoreDebug_DEMCR_TRCENA_Msk;*(volatile uint32_t*)0xe0001fb0=0xc5acce55;DWT->CYCCNT=0;DWT->CTRL|=1;
    int rc=streams();if(!rc)rc=signatures();if(!rc)rc=api();
    if(!rc)printf("CHECK new_verify_batch4=PASS verified=%u rejected=%u\n",batch_verified,batch_rejected);
    printf("BENCH_DONE result=%d total_exact=%u total_rejected=%u\n",rc,checked,rejected);
    return rc;
}
