/* Paired original and batch4 on identical inputs. Verification is untimed.
 * IRQ enabled: the 64-bit SoC cycle counter safely spans long keygen batches.
 */
#include "inner.h"
#include "fndsa_batch4.h"
#include "shake_batch4.h"
#include "profile.h"
#include <zephyr/kernel.h>
#include <cmsis_core.h>
#include <stm32n6xx.h>
#include <stdio.h>

int baseline_keygen_seeded_temp(unsigned,const void*,size_t,void*,void*,void*,size_t);
size_t reference_fndsa_sign_seeded_temp(const void*,size_t,const void*,size_t,
 const char*,const void*,size_t,const void*,size_t,void*,size_t,void*,size_t);
enum { KEY_BATCHES=10, SIGN_BATCHES=25, KEY_BLOCKS=64, SIGN_BLOCKS=112 };
#if PROFILE_KEYGEN
#define WORK_BYTES 75008
#else
#define WORK_BYTES (sizeof(fndsa_batch4_work)+544*SIGN_BLOCKS+32)
#include "keys.h"
static const uint8_t *const sks[2][4]={
 {test_sk512_0,test_sk512_1,test_sk512_0,test_sk512_1},
 {test_sk1024_0,test_sk1024_1,test_sk1024_0,test_sk1024_1}};
static const uint8_t *const pks[2][4]={
 {test_pk512_0,test_pk512_1,test_pk512_0,test_pk512_1},
 {test_pk1024_0,test_pk1024_1,test_pk1024_0,test_pk1024_1}};
#endif
static struct {
    uint32_t pre[8];
    uint8_t data[WORK_BYTES];
    uint32_t post[8];
} work __attribute__((aligned(32)));
#if PROFILE_KEYGEN
static uint8_t sk[4][FNDSA_SIGN_KEY_SIZE(10)], pk[4][FNDSA_VRFY_KEY_SIZE(10)];
static uint8_t original_sk[4][FNDSA_SIGN_KEY_SIZE(10)], original_pk[4][FNDSA_VRFY_KEY_SIZE(10)];
#else
static uint8_t sig[4][FNDSA_SIGNATURE_SIZE(10)], original_sig[4][FNDSA_SIGNATURE_SIZE(10)];
#endif
static uint8_t seeds[4][80], messages[4][80];
static unsigned keys_checked, signatures_checked, tamper_checked;
static uint32_t fingerprint=2166136261u;
#define REQUIRE(x,c) do { if(!(x)) {printf("FAIL line=%u code=%u\n",__LINE__,c);return c;} } while(0)
static void digest(const void *p,size_t len)
{
    const uint8_t *b=p;
    while(len--) fingerprint=(fingerprint^*b++)*16777619u;
}
static int guards(void)
{
    for(unsigned i=0;i<8;i++) if(work.pre[i]!=0x57abcdef||work.post[i]!=0x57abcdef)return 0;
    return 1;
}
#if PROFILE_KEYGEN
static int keygen(unsigned logn)
{
    size_t sl=FNDSA_SIGN_KEY_SIZE(logn),pl=FNDSA_VRFY_KEY_SIZE(logn);
    for(unsigned batch=0;batch<=KEY_BATCHES;batch++) {
        fndsa_keygen_batch4_job jobs[4];
        for(unsigned lane=0;lane<4;lane++) {
            unsigned index=(batch?batch-1:0)*4+lane;
            for(unsigned j=0;j<32;j++)seeds[lane][j]=(uint8_t)(0xa5+29*j+7*logn+13);
            for(unsigned j=0;j<4;j++)seeds[lane][j]^=(uint8_t)(index>>(8*j));
            jobs[lane]=(fndsa_keygen_batch4_job){logn,seeds[lane],32,sk[lane],sl,pk[lane],pl};
        }
        uint64_t elapsed[2];
        for(unsigned pass=0;pass<2;pass++) {
            unsigned v=pass^(batch&1);int ok=1;
            if(batch)profile_begin(logn-9,0,v);
            uint64_t start=k_cycle_get_64();
            if(v)ok=fndsa_keygen_seeded_batch4_temp(jobs,KEY_BLOCKS,work.data,sizeof work.data);
            else for(unsigned lane=0;lane<4;lane++)
                ok &= baseline_keygen_seeded_temp(logn,seeds[lane],32,
                    original_sk[lane],original_pk[lane],work.data,sizeof work.data);
            elapsed[v]=batch?profile_end():k_cycle_get_64()-start;
            REQUIRE(ok,100);
        }
        for(unsigned lane=0;lane<4;lane++) {
            REQUIRE(!memcmp(sk[lane],original_sk[lane],sl)&&!memcmp(pk[lane],original_pk[lane],pl),101);
            digest(sk[lane],sl);digest(pk[lane],pl);keys_checked++;
        }
        REQUIRE(guards()&&!profile_error,102);
        if(batch)printf("PAIR n=%u op=0 batch=%u original=%llu batch4=%llu\n",1u<<logn,batch-1,
            (unsigned long long)elapsed[0],(unsigned long long)elapsed[1]);
    }
    return 0;
}
#else
static int signing(unsigned logn)
{
    size_t sl=FNDSA_SIGN_KEY_SIZE(logn),pl=FNDSA_VRFY_KEY_SIZE(logn),zl=FNDSA_SIGNATURE_SIZE(logn);
    for(unsigned batch=0;batch<=SIGN_BATCHES;batch++) {
        fndsa_sign_batch4_job jobs[4];
        unsigned sample=batch?batch-1:0;
        for(unsigned lane=0;lane<4;lane++) {
            for(unsigned j=0;j<80;j++) {
                seeds[lane][j]=(uint8_t)(j*11+lane*43+sample);
                messages[lane][j]=(uint8_t)(j*7+lane*23+sample*3);
            }
            jobs[lane]=(fndsa_sign_batch4_job){.sign_key=sks[logn-9][lane],.sign_key_len=sl,
                .ctx="batch-original",.ctx_len=14,.id=FNDSA_HASH_ID_RAW,
                .hv=messages[lane],.hv_len=32+7*lane,.seed=seeds[lane],.seed_len=40+8*lane,
                .sig=sig[lane],.max_sig_len=zl};
        }
        uint64_t elapsed[2];
        for(unsigned pass=0;pass<2;pass++) {
            unsigned v=pass^(batch&1);int ok=1;
            if(batch)profile_begin(logn-9,1,v);
            uint64_t start=k_cycle_get_64();
            if(v)ok=fndsa_sign_seeded_batch4_temp(jobs,SIGN_BLOCKS,work.data,sizeof work.data);
            else for(unsigned lane=0;lane<4;lane++) {
                fndsa_sign_batch4_job *j=&jobs[lane];
                ok &= reference_fndsa_sign_seeded_temp(j->sign_key,sl,j->ctx,j->ctx_len,
                    j->id,j->hv,j->hv_len,j->seed,j->seed_len,original_sig[lane],zl,
                    work.data,sizeof work.data)==zl;
            }
            elapsed[v]=batch?profile_end():k_cycle_get_64()-start;
            REQUIRE(ok,200);
        }
        for(unsigned lane=0;lane<4;lane++) {
            fndsa_sign_batch4_job *j=&jobs[lane];
            REQUIRE(j->sig_len==zl&&!memcmp(sig[lane],original_sig[lane],zl),201);
            REQUIRE(fndsa_verify_temp(sig[lane],zl,pks[logn-9][lane],pl,j->ctx,j->ctx_len,j->id,
                j->hv,j->hv_len,work.data,sizeof work.data),202);
            sig[lane][zl-1]^=1;
            REQUIRE(!fndsa_verify_temp(sig[lane],zl,pks[logn-9][lane],pl,j->ctx,j->ctx_len,j->id,
                j->hv,j->hv_len,work.data,sizeof work.data),203);
            sig[lane][zl-1]^=1;
            digest(sig[lane],zl);signatures_checked++;tamper_checked++;
        }
        REQUIRE(guards()&&!profile_error,204);
        if(batch)printf("PAIR n=%u op=1 batch=%u original=%llu batch4=%llu\n",1u<<logn,batch-1,
            (unsigned long long)elapsed[0],(unsigned long long)elapsed[1]);
        fndsa_verify_batch4_job vjobs[4];
        for(unsigned lane=0;lane<4;lane++) {
            fndsa_sign_batch4_job *j=&jobs[lane];
            vjobs[lane]=(fndsa_verify_batch4_job){sig[lane],zl,pks[logn-9][lane],pl,
                j->ctx,j->ctx_len,j->id,j->hv,j->hv_len,0};
        }
        uint64_t ve[2];
        for(unsigned pass=0;pass<2;pass++) {
            unsigned v=pass^(batch&1);int ok=1;
            if(v)profile_watch_begin();
            uint64_t start=k_cycle_get_64();
            if(v)ok=fndsa_verify_batch4_temp(vjobs,work.data,sizeof work.data);
            else for(unsigned l=0;l<4;l++) {
                const fndsa_verify_batch4_job *j=&vjobs[l];
                ok &= fndsa_verify_temp(j->sig,j->sig_len,j->vrfy_key,j->vrfy_key_len,
                    j->ctx,j->ctx_len,j->id,j->hv,j->hv_len,work.data,sizeof work.data);
            }
            ve[v]=k_cycle_get_64()-start;
            unsigned singles=v?profile_watch_end():0;
            REQUIRE(ok&&!singles,205);
        }
        for(unsigned l=0;l<4;l++)REQUIRE(vjobs[l].valid,206);
        if(batch)printf("VERIFY_PAIR n=%u batch=%u original=%llu batch4=%llu\n",1u<<logn,batch-1,
            (unsigned long long)ve[0],(unsigned long long)ve[1]);
    }
    return 0;
}
#endif
#include "edge_tests.inc"
int mlk_test_main(int argc,char **argv)
{
    (void)argc;(void)argv;
    for(unsigned i=0;i<8;i++)work.pre[i]=work.post[i]=0x57abcdef;
    printf("BENCH_BEGIN batch4_profile mode=%s keygen=%u\n",PROFILE_MODE,PROFILE_KEYGEN);
    uint32_t control=*(volatile uint32_t*)0x56008008;
    printf("BENCH_HW cpu=%u ccr=%08x control=%08x fpscr=%08x primask=%u\n",
        (unsigned)SystemCoreClock,SCB->CCR,control,__get_FPSCR(),__get_PRIMASK());
    REQUIRE(SystemCoreClock==800000000u&&!(SCB->CCR&0x30000u)&&control==0x99&&!__get_PRIMASK(),300);
#if PROFILE_KEYGEN
    REQUIRE(fndsa_keygen_batch4_temp_size(KEY_BLOCKS)<=sizeof work.data,301);
#else
    REQUIRE(fndsa_sign_batch4_temp_size(SIGN_BLOCKS)<=sizeof work.data,301);
#endif
    profile_calibrate();
    for(unsigned logn=9;logn<=10;logn++) {
#if PROFILE_KEYGEN
        int rc=keygen(logn);if(rc)return rc;
#else
        int rc=signing(logn);if(rc)return rc;
#endif
        printf("CHECK n=%u keys=%u signatures=%u tamper=%u guards=PASS profile_error=%u\n",
            1u<<logn,keys_checked,signatures_checked,tamper_checked,profile_error);
    }
    profile_report();
    int edge_rc=stream_edges();if(edge_rc)return edge_rc;
    edge_rc=operation_edges();if(edge_rc)return edge_rc;
    printf("BENCH_DONE result=0 keys=%u signatures=%u tamper=%u fingerprint=%08x profile_error=%u\n",
        keys_checked,signatures_checked,tamper_checked,fingerprint,profile_error);
    return 0;
}
