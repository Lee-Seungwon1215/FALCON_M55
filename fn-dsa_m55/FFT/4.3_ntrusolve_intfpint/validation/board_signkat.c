/* Same deterministic inputs and hash contract as upstream inner_test_kat.
 * Static buffers replace host malloc; original expected digests are unchanged.
 */
#include "inner.h"
#include <stdio.h>
#include <string.h>
#include <cmsis_core.h>
#include <stm32n6xx.h>
#include "upstream_signkat.h"
static uint8_t sk[FNDSA_SIGN_KEY_SIZE(10)],pk[FNDSA_VRFY_KEY_SIZE(10)],sig[FNDSA_SIGNATURE_SIZE(10)];
static uint8_t tmp[59*1024+31] __attribute__((aligned(32)));
static const char *const *tables[]={KAT_4,KAT_8,KAT_16,KAT_32,KAT_64,KAT_128,KAT_256,KAT_512,KAT_1024};
static unsigned nibble(unsigned c) { return c<='9'?c-'0':c-'a'+10; }
int mlk_test_main(int argc,char **argv)
{
    (void)argc;(void)argv;
    if(SystemCoreClock!=800000000u || (SCB->CCR&0x30000u) || *(volatile unsigned*)0x56008008!=0x99u || (__get_FPSCR()&0x1C00000u))return 10;
    unsigned count=0,bad=0;
    for(unsigned logn=2;logn<=10;logn++)for(unsigned j=0;tables[logn-2][j];j++) {
        size_t n=(size_t)1<<logn,sl=FNDSA_SIGN_KEY_SIZE(logn),pl=FNDSA_VRFY_KEY_SIZE(logn),zl=FNDSA_SIGNATURE_SIZE(logn);
        uint8_t seed[5]={(uint8_t)logn,(uint8_t)j,(uint8_t)(j>>8),(uint8_t)(j>>16),(uint8_t)(j>>24)};
        uint8_t kg[32],sg[40],work[32],digest[32],expected[32];shake_context sc;sha3_context hc;
        shake_init(&sc,256);shake_inject(&sc,seed,5);shake_flip(&sc);shake_extract(&sc,kg,32);shake_extract(&sc,sg,40);
        if(!fndsa_keygen_seeded_temp(logn,kg,32,sk,pk,tmp,22*n+31))return 1;
        const void *msg="message";size_t ml=7;const char *id=FNDSA_HASH_ID_RAW;
        if(j&1) { id=FNDSA_HASH_ID_SHA3_256;sha3_init(&hc,256);sha3_update(&hc,msg,ml);sha3_close(&hc,work);msg=work;ml=32; }
        size_t r=logn<=8?fndsa_sign_weak_seeded_temp(sk,sl,"domain",6,id,msg,ml,sg,40,sig,zl,tmp,59*n+31)
                        :fndsa_sign_seeded_temp(sk,sl,"domain",6,id,msg,ml,sg,40,sig,zl,tmp,59*n+31);
        if(r!=zl)return 2;
        int ok=logn<=8?fndsa_verify_weak_temp(sig,zl,pk,pl,"domain",6,id,msg,ml,tmp,4*n+31)
                      :fndsa_verify_temp(sig,zl,pk,pl,"domain",6,id,msg,ml,tmp,4*n+31);
        if(!ok)return 3;
        sha3_init(&hc,256);sha3_update(&hc,sk,sl);sha3_update(&hc,pk,pl);sha3_update(&hc,sig,zl);sha3_close(&hc,digest);
        const char *hex=tables[logn-2][j];for(unsigned i=0;i<32;i++)expected[i]=(nibble(hex[2*i])<<4)|nibble(hex[2*i+1]);
        unsigned match=memcmp(digest,expected,32)==0;bad+=!match;
        sig[zl-1]^=1;
        ok=logn<=8?fndsa_verify_weak_temp(sig,zl,pk,pl,"domain",6,id,msg,ml,tmp,4*n+31)
                   :fndsa_verify_temp(sig,zl,pk,pl,"domain",6,id,msg,ml,tmp,4*n+31);
        if(ok)return 4;
        count++;printf("BOARD_SIGNKAT degree=%u index=%u match=%u verify=PASS tamper=PASS\n",1u<<logn,j,match);
    }
    printf("BOARD_SIGNKAT_DONE count=%u mismatches=%u\n",count,bad);return 0;
}

