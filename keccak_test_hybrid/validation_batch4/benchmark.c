/* Same-image paired baseline vs independent x4. Public deterministic tests. */
#include "inner.h"
#include "fndsa_batch4.h"
#include "shake_independent4.h"
#include "inputs.h"
#include "expected.h"
#include <zephyr/kernel.h>
#include <cmsis_core.h>
#include <stm32n6xx.h>
#include <stdio.h>

int baseline_keygen_seeded_temp(unsigned,const void*,size_t,void*,void*,void*,size_t);
int baseline_verify_temp(const void*,size_t,const void*,size_t,const void*,size_t,
    const char*,const void*,size_t,void*,size_t);
static uint8_t sk[4][FNDSA_SIGN_KEY_SIZE(10)],pk[4][FNDSA_VRFY_KEY_SIZE(10)];
static uint8_t rsk[4][FNDSA_SIGN_KEY_SIZE(10)],rpk[4][FNDSA_VRFY_KEY_SIZE(10)];
static uint8_t sig[FNDSA_SIGNATURE_SIZE(10)];
static uint8_t seed[4][32],ss[4][40],msg[4][32],data[4][1056];
static struct {
    uint32_t pre[8];
    uint8_t tmp[61000];
    uint32_t post[8];
} workspace __attribute__((aligned(32)));
static unsigned stream_checks,key_checks,verify_checks,tamper_checks;
static volatile int sink;
static uint64_t cycles(void){__DSB();__ISB();return k_cycle_get_64();}
static const char *dec(char out[24],uint64_t v)
{char *p=out+23;*p=0;do{*--p=(char)('0'+v%10);v/=10;}while(v);return p;}
#define REQUIRE(x,code) do{if(!(x)){printf("FAIL line=%u code=%u\n",__LINE__,code);return code;}}while(0)
static int guards(void)
{for(unsigned i=0;i<8;i++)if(workspace.pre[i]!=0x1234abcd||workspace.post[i]!=0x1234abcd)return 0;return 1;}
static int digest_key(unsigned logn,unsigned lane,unsigned index)
{
    shake_context s;uint8_t d[32];shake_init(&s,256);
    shake_inject(&s,sk[lane],FNDSA_SIGN_KEY_SIZE(logn));
    shake_inject(&s,pk[lane],FNDSA_VRFY_KEY_SIZE(logn));
    shake_flip(&s);shake_extract(&s,d,32);
    return !memcmp(d,expected_key[logn-9][index],32);
}
static int test_streams(void)
{
    const size_t lengths[]={0,1,7,135,136,137,271,272,1024};
    const unsigned policies[]={0,1,2,7,112,128};
    for(unsigned l=0;l<4;l++)for(unsigned j=0;j<sizeof data[l];j++)data[l][j]=(uint8_t)(j*17+l*43);
    for(unsigned t=0;t<9;t++)for(unsigned policy=0;policy<6;policy++) {
        unsigned blocks=policies[policy];
        fndsa_shake4_state state;
        fndsa_shake_iov v[4][3];const fndsa_shake_iov *vp[4];size_t count[4]={3,3,3,3};
        shake_context ref[4];uint8_t out[4][136],want[211],got[211];
        for(unsigned l=0;l<4;l++) {
            size_t n=lengths[(t+l)%9],cut=n<5?n:5;
            v[l][0]=(fndsa_shake_iov){data[l],cut};
            v[l][1]=(fndsa_shake_iov){NULL,0};
            v[l][2]=(fndsa_shake_iov){data[l]+cut,n-cut};vp[l]=v[l];
            shake_init(&ref[l],256);shake_inject(&ref[l],data[l],n);shake_flip(&ref[l]);
        }
        fndsa_shake4_absorb(&state,vp,count);
        for(unsigned b=0;b<blocks;b++) {
            fndsa_shake4_block(&state,out);
            for(unsigned l=0;l<4;l++) {
                shake_extract(&ref[l],want,136);
                REQUIRE(!memcmp(want,out[l],136),101);stream_checks++;
            }
        }
        for(unsigned l=0;l<4;l++) {
            shake_context tail;fndsa_shake4_export_lane(&state,l,&tail);
            shake_extract(&tail,got,211);shake_extract(&ref[l],want,211);
            REQUIRE(!memcmp(want,got,211),102);stream_checks++;
        }
    }
    printf("CHECK streams=%u unequal_lengths=PASS continuation=PASS\n",stream_checks);
    return 0;
}
static int verify_one(const fndsa_verify_batch4_job *j)
{
    return baseline_verify_temp(j->sig,j->sig_len,j->vrfy_key,j->vrfy_key_len,
        j->ctx,j->ctx_len,j->id,j->hv,j->hv_len,workspace.tmp,sizeof workspace.tmp);
}
static int test_degree(unsigned logn)
{
    size_t sl=FNDSA_SIGN_KEY_SIZE(logn),pl=FNDSA_VRFY_KEY_SIZE(logn),zl=FNDSA_SIGNATURE_SIZE(logn);
    for(unsigned group=0;group<2;group++) {
        fndsa_keygen_batch4_job jobs[4];fndsa_verify_batch4_job v[4];
        for(unsigned l=0;l<4;l++) {
            make_input(logn,4*group+l,seed[l],ss[l],msg[l]);
            jobs[l]=(fndsa_keygen_batch4_job){logn,seed[l],32,sk[l],sl,pk[l],pl};
            v[l]=(fndsa_verify_batch4_job){expected_sig[logn-9][4*group+l],zl,pk[l],pl,
                "single",6,FNDSA_HASH_ID_RAW,msg[l],32,0};
        }
        for(unsigned r=0;r<=REPEATS;r++) {
            uint64_t start=cycles();
            for(unsigned l=0;l<4;l++) REQUIRE(baseline_keygen_seeded_temp(logn,seed[l],32,
                sk[l],pk[l],workspace.tmp,sizeof workspace.tmp),201);
            uint64_t baseline=cycles()-start;
            /* Identical output addresses during timing; save comparison data
             * only after stopping the baseline timer. */
            memcpy(rsk,sk,sizeof sk);memcpy(rpk,pk,sizeof pk);
            /* Alternate candidate order. Includes every prefix and call cost. */
            for(unsigned b=0;b<2;b++) {
                unsigned blocks=((b+r)&1)?64:32;
                start=cycles();
                int ok=fndsa_keygen_seeded_batch4_temp(jobs,blocks,workspace.tmp,sizeof workspace.tmp);
                uint64_t batch=cycles()-start;REQUIRE(ok,202);
                for(unsigned l=0;l<4;l++) {
                    REQUIRE(!memcmp(sk[l],rsk[l],sl)&&!memcmp(pk[l],rpk[l],pl),203);
                    REQUIRE(digest_key(logn,l,4*group+l),204);key_checks++;
                }
                if(r){char a[24],c[24];printf("BATCH op=keygen n=%u group=%u rep=%u blocks=%u single=%s batch=%s\n",
                    1u<<logn,group,r,blocks,dec(a,baseline),dec(c,batch));}
            }
            start=cycles();
            for(unsigned rep=0;rep<8;rep++)for(unsigned l=0;l<4;l++)sink=verify_one(&v[l]);
            uint64_t single_v=cycles()-start;REQUIRE(sink==1,205);
            start=cycles();
            for(unsigned rep=0;rep<8;rep++)sink=fndsa_verify_batch4_temp(v,workspace.tmp,sizeof workspace.tmp);
            uint64_t batch_v=cycles()-start;REQUIRE(sink==1,206);
            for(unsigned l=0;l<4;l++){REQUIRE(v[l].valid==1,207);verify_checks++;}
            if(r){char a[24],c[24];printf("BATCH op=verify n=%u group=%u rep=%u blocks=0 single=%s batch=%s calls=8\n",
                1u<<logn,group,r,dec(a,single_v),dec(c,batch_v));}
            REQUIRE(guards(),208);
        }
        /* Zero/one-block prefixes exercise exact single continuation. */
        for(unsigned blocks=0;blocks<=1;blocks++) {
            REQUIRE(fndsa_keygen_seeded_batch4_temp(jobs,blocks,workspace.tmp+1,
                fndsa_keygen_batch4_temp_size(blocks)),209);
            for(unsigned l=0;l<4;l++) {
                REQUIRE(!memcmp(sk[l],rsk[l],sl)&&!memcmp(pk[l],rpk[l],pl),210);key_checks++;
            }
        }
        for(unsigned lane=0;lane<4;lane++) {
            memcpy(sig,v[lane].sig,zl);const void *saved=v[lane].sig;
            sig[50]^=1;v[lane].sig=sig;
            REQUIRE(fndsa_verify_batch4_temp(v,workspace.tmp+1,fndsa_verify_batch4_temp_size()),211);
            for(unsigned l=0;l<4;l++)REQUIRE(v[l].valid==(l!=lane),212);
            v[lane].sig=saved;tamper_checks++;
            msg[lane][0]^=1;REQUIRE(fndsa_verify_batch4_temp(v,workspace.tmp,sizeof workspace.tmp),213);
            for(unsigned l=0;l<4;l++)REQUIRE(v[l].valid==(l!=lane),214);
            msg[lane][0]^=1;tamper_checks++;
            v[lane].sig_len=0;REQUIRE(fndsa_verify_batch4_temp(v,workspace.tmp,sizeof workspace.tmp),215);
            for(unsigned l=0;l<4;l++)REQUIRE(v[l].valid==(l!=lane),216);
            v[lane].sig_len=zl;tamper_checks++;
        }
        REQUIRE(!fndsa_keygen_seeded_batch4_temp(jobs,64,workspace.tmp,
            fndsa_keygen_batch4_temp_size(64)-1),217);
        REQUIRE(!fndsa_keygen_seeded_batch4_temp(jobs,129,workspace.tmp,sizeof workspace.tmp),218);
        REQUIRE(!fndsa_verify_batch4_temp(v,workspace.tmp,fndsa_verify_batch4_temp_size()-1),219);
        /* Existing single entry points still have the original key/verify semantics. */
        REQUIRE(fndsa_keygen_seeded_temp(logn,seed[0],32,sk[0],pk[0],workspace.tmp,sizeof workspace.tmp),220);
        REQUIRE(digest_key(logn,0,4*group),221);
        REQUIRE(fndsa_verify_temp(v[0].sig,zl,pk[0],pl,"single",6,FNDSA_HASH_ID_RAW,msg[0],32,
            workspace.tmp,sizeof workspace.tmp),222);
    }
    printf("CHECK degree=%u keys=%u verify=%u tamper=%u guards=PASS\n",1u<<logn,key_checks,verify_checks,tamper_checks);
    return 0;
}
static int test_mixed(void)
{
    fndsa_keygen_batch4_job k[4];fndsa_verify_batch4_job v[4];
    const size_t lens[4]={0,135,136,1024};
    for(unsigned l=0;l<4;l++) {
        unsigned logn=9+(l&1);
        k[l]=(fndsa_keygen_batch4_job){logn,data[l],lens[l],sk[l],sizeof sk[l],pk[l],sizeof pk[l]};
    }
    REQUIRE(fndsa_keygen_seeded_batch4_temp(k,32,workspace.tmp,sizeof workspace.tmp),301);
    for(unsigned l=0;l<4;l++) {
        unsigned logn=k[l].logn;
        REQUIRE(baseline_keygen_seeded_temp(logn,data[l],lens[l],rsk[l],rpk[l],workspace.tmp,sizeof workspace.tmp),302);
        REQUIRE(!memcmp(sk[l],rsk[l],FNDSA_SIGN_KEY_SIZE(logn))&&
            !memcmp(pk[l],rpk[l],FNDSA_VRFY_KEY_SIZE(logn)),303);key_checks++;
        const char *id=l==2?FNDSA_HASH_ID_SHA256:(l==3?FNDSA_HASH_ID_EXTMU:FNDSA_HASH_ID_RAW);
        size_t hvlen=l==2?32:(l==3?64:lens[l]);size_t ctxlen=l==1?255:0;
        size_t z=FNDSA_SIGNATURE_SIZE(logn);
        v[l]=(fndsa_verify_batch4_job){expected_mixed_sig[l],z,pk[l],FNDSA_VRFY_KEY_SIZE(logn),data[l],ctxlen,id,data[l],hvlen,0};
        REQUIRE(verify_one(&v[l]),305);
    }
    REQUIRE(fndsa_verify_batch4_temp(v,workspace.tmp,sizeof workspace.tmp),306);
    for(unsigned l=0;l<4;l++){REQUIRE(v[l].valid,307);verify_checks++;}
    /* Public key corruption cannot contaminate other lanes. */
    pk[1][4]^=1;int expected=verify_one(&v[1]);
    REQUIRE(fndsa_verify_batch4_temp(v,workspace.tmp,sizeof workspace.tmp),308);
    REQUIRE(v[0].valid&&v[2].valid&&v[3].valid&&v[1].valid==expected,309);tamper_checks++;
    pk[1][4]^=1;
    uint8_t mu[4][64];
    for(unsigned l=0;l<4;l++) {
        if(l==3)memcpy(mu[l],v[l].hv,64);
        else {
            uint8_t hpk[64];fndsa_hashed_vrfykey_from_vrfykey(hpk,v[l].vrfy_key,v[l].vrfy_key_len);
            REQUIRE(fndsa_compute_mu(mu[l],hpk,v[l].ctx,v[l].ctx_len,v[l].id,v[l].hv,v[l].hv_len),313);
        }
        v[l].id=FNDSA_HASH_ID_EXTMU;v[l].hv=mu[l];v[l].hv_len=64;
    }
    REQUIRE(fndsa_verify_batch4_temp(v,workspace.tmp,sizeof workspace.tmp),314);
    for(unsigned l=0;l<4;l++){REQUIRE(v[l].valid,315);verify_checks++;}
    v[0].hv_len=63;
    REQUIRE(fndsa_verify_batch4_temp(v,workspace.tmp,sizeof workspace.tmp),316);
    REQUIRE(!v[0].valid&&v[1].valid&&v[2].valid&&v[3].valid,317);tamper_checks++;
    k[0].seed=NULL;REQUIRE(!fndsa_keygen_seeded_batch4_temp(k,32,workspace.tmp,sizeof workspace.tmp),310);
    fndsa_batch4_clear(workspace.tmp,sizeof workspace.tmp);
    for(unsigned i=0;i<sizeof workspace.tmp;i++)REQUIRE(workspace.tmp[i]==0,311);
    REQUIRE(guards(),312);
    printf("CHECK mixed_degrees=PASS raw_prehash_extmu=PASS wipe=PASS\n");
    return 0;
}
int mlk_test_main(int argc,char **argv)
{
    (void)argc;(void)argv;
    for(unsigned i=0;i<8;i++)workspace.pre[i]=workspace.post[i]=0x1234abcd;
    printf("BENCH_BEGIN hybrid_keygen_verify_batch4\n");
    uint32_t control=*(volatile uint32_t*)0x56008008;
    printf("BENCH_HW cpu=%u ccr=%08x control=%08x fpscr=%08x primask=%u\n",
        (unsigned)SystemCoreClock,SCB->CCR,control,__get_FPSCR(),__get_PRIMASK());
    REQUIRE(SystemCoreClock==800000000u&&!(SCB->CCR&0x30000u)&&control==0x99&&!__get_PRIMASK(),401);
    int rc=test_streams();if(rc)return rc;
    rc=test_degree(9);if(rc)return rc;rc=test_degree(10);if(rc)return rc;
    rc=test_mixed();if(rc)return rc;
    printf("BENCH_DONE result=0 streams=%u keys=%u verify=%u tamper=%u\n",
        stream_checks,key_checks,verify_checks,tamper_checks);
    return 0;
}
