/* Existing single APIs only. No batch4 API, no prefetched random streams. */
#include "inner.h"
#include "inputs.h"
#include "expected.h"
#include <zephyr/kernel.h>
#include <cmsis_core.h>
#include <stm32n6xx.h>
#include <stdio.h>

static uint8_t sk[FNDSA_SIGN_KEY_SIZE(10)],pk[FNDSA_VRFY_KEY_SIZE(10)];
static uint8_t sig[FNDSA_SIGNATURE_SIZE(10)];
static struct {
    uint32_t pre[8];
    uint8_t tmp[59*1024+32];
    uint32_t post[8];
} workspace __attribute__((aligned(32)));
static volatile unsigned sink;
static unsigned key_checks,sign_checks,valid_checks,reject_checks;

static uint64_t cycles(void) { __DSB();__ISB();return k_cycle_get_64(); }
static const char *decimal(char out[24],uint64_t v)
{
    char *p=out+23;*p=0;do{*--p=(char)('0'+v%10);v/=10;}while(v);return p;
}
static int digest_matches(const uint8_t *a,size_t alen,const uint8_t *b,size_t blen,const uint8_t want[32])
{
    shake_context s;uint8_t d[32];shake_init(&s,256);
    shake_inject(&s,a,alen);if(blen)shake_inject(&s,b,blen);
    shake_flip(&s);shake_extract(&s,d,32);return memcmp(d,want,32)==0;
}
static int checks(unsigned logn,unsigned index,uint8_t msg[32])
{
    size_t sl=FNDSA_SIGN_KEY_SIZE(logn),pl=FNDSA_VRFY_KEY_SIZE(logn),zl=FNDSA_SIGNATURE_SIZE(logn);
    if(!digest_matches(sk,sl,pk,pl,expected_key[logn-9][index]))return 1;
    key_checks++;
    if(!digest_matches(sig,zl,NULL,0,expected_sign[logn-9][index]))return 2;
    sign_checks++;
    if(!fndsa_verify_temp(sig,zl,pk,pl,"single",6,FNDSA_HASH_ID_RAW,msg,32,
        workspace.tmp,sizeof workspace.tmp))return 3;
    valid_checks++;
    sig[50]^=1;
    if(fndsa_verify_temp(sig,zl,pk,pl,"single",6,FNDSA_HASH_ID_RAW,msg,32,
        workspace.tmp,sizeof workspace.tmp))return 4;
    sig[50]^=1;msg[0]^=1;
    if(fndsa_verify_temp(sig,zl,pk,pl,"single",6,FNDSA_HASH_ID_RAW,msg,32,
        workspace.tmp,sizeof workspace.tmp))return 5;
    msg[0]^=1;reject_checks+=2;
    for(unsigned j=0;j<8;j++)if(workspace.pre[j]!=0xc0ffeec0||workspace.post[j]!=0xc0ffeec0)return 6;
    return 0;
}
int mlk_test_main(int argc,char **argv)
{
    (void)argc;(void)argv;
    for(unsigned j=0;j<8;j++)workspace.pre[j]=workspace.post[j]=0xc0ffeec0;
    printf("BENCH_BEGIN single_api candidate=%s inputs=%u repeats=%u verify_batch=%u\n",BENCH_NAME,INPUTS,REPEATS,VERIFY_BATCH);
    uint32_t control=*(volatile uint32_t*)0x56008008;
    printf("BENCH_HW cpu=%u ccr=%08x itcm=%08x dtcm=%08x control=%08x fpscr=%08x primask=%u\n",
        (unsigned)SystemCoreClock,SCB->CCR,MEMSYSCTL->ITCMCR,MEMSYSCTL->DTCMCR,control,__get_FPSCR(),__get_PRIMASK());
    if(SystemCoreClock!=800000000u||(SCB->CCR&0x30000u)||control!=0x99||(__get_FPSCR()&0x1c00000u)||__get_PRIMASK())return 10;
    for(unsigned logn=9;logn<=10;logn++) {
        size_t sl=FNDSA_SIGN_KEY_SIZE(logn),pl=FNDSA_VRFY_KEY_SIZE(logn),zl=FNDSA_SIGNATURE_SIZE(logn);
        for(unsigned i=0;i<INPUTS;i++) {
            uint8_t ks[32],ss[40],msg[32];make_input(logn,i,ks,ss,msg);
            for(unsigned r=0;r<=REPEATS;r++) {
                uint64_t t=cycles();
                int ok=fndsa_keygen_seeded_temp(logn,ks,32,sk,pk,workspace.tmp,sizeof workspace.tmp);
                uint64_t kg=cycles()-t;if(!ok)return 11;
                t=cycles();
                size_t z=fndsa_sign_seeded_temp(sk,sl,"single",6,FNDSA_HASH_ID_RAW,msg,32,ss,40,
                    sig,zl,workspace.tmp,sizeof workspace.tmp);
                uint64_t sg=cycles()-t;if(z!=zl)return 12;
                t=cycles();
                for(unsigned v=0;v<VERIFY_BATCH;v++)sink=fndsa_verify_temp(sig,zl,pk,pl,"single",6,
                    FNDSA_HASH_ID_RAW,msg,32,workspace.tmp,sizeof workspace.tmp);
                uint64_t vf=cycles()-t;if(sink!=1)return 13;
                int rc=checks(logn,i,msg);
                if(rc){printf("FAIL n=%u input=%u repeat=%u code=%d\n",1u<<logn,i,r,rc);return rc;}
                if(r) {
                    char a[24],b[24],c[24];
                    printf("SINGLE n=%u input=%u repeat=%u keygen=%s sign=%s verify_total=%s verify_calls=%u\n",
                        1u<<logn,i,r-1,decimal(a,kg),decimal(b,sg),decimal(c,vf),VERIFY_BATCH);
                }
            }
        }
        printf("CHECK degree=%u key=%u sign=%u valid=%u tamper=%u guards=PASS\n",
            1u<<logn,key_checks,sign_checks,valid_checks,reject_checks);
    }
    printf("BENCH_DONE result=0 key=%u sign=%u valid=%u tamper=%u\n",key_checks,sign_checks,valid_checks,reject_checks);
    return 0;
}
