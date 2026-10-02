/* Original upstream KAT arrays and SHA-256, no changed expected values. */
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include "inner.h"
#include "kgen_inner.h"
#include "upstream_kat.h"
#include <cmsis_core.h>
#include <stm32n6xx.h>
static uint8_t bs[FNDSA_SIGN_KEY_SIZE(10)],bp[FNDSA_VRFY_KEY_SIZE(10)];
static uint8_t bt[22*1024+31] __attribute__((aligned(32)));
static int8_t polys[4*1024];
static uint16_t mh[1024],mt[1024];
int mlk_test_main(int argc,char **argv)
{
    (void)argc;(void)argv;
    selftest_sha256();
    if(SystemCoreClock!=800000000u || (SCB->CCR&0x30000u) || *(volatile unsigned*)0x56008008!=0x99u || (__get_FPSCR()&0x1C00000u))return 10;
    unsigned count=0,mismatches=0;
    for(unsigned logn=8;logn<=10;logn++) {
        size_t n=(size_t)1<<logn;
        const char *const *kat=logn==8?KAT_KG256:logn==9?KAT_KG512:KAT_KG1024;
        for(unsigned i=0;kat[i];i++) {
            char seed[32];sprintf(seed,"test%u",i);
            if(!fndsa_keygen_seeded_temp(logn,seed,strlen(seed),bs,bp,bt,22*n+31))return 1;
            int8_t *f=polys,*g=f+n,*F=g+n,*G=F+n;
            unsigned bits=logn==10?5:6;size_t off=1;
            off+=trim_i8_decode(logn,bs+off,f,bits);
            off+=trim_i8_decode(logn,bs+off,g,bits);
            off+=trim_i8_decode(logn,bs+off,F,8);
            if(off+64!=FNDSA_SIGN_KEY_SIZE(logn))return 2;
            if(1+mqpoly_decode(logn,bp+1,mh)!=FNDSA_VRFY_KEY_SIZE(logn))return 3;
            mqpoly_ext_to_int(logn,mh);
            mqpoly_small_to_int(logn,F,mt);mqpoly_int_to_ntt(logn,mt);
            mqpoly_mul_ntt(logn,mt,mh);mqpoly_ntt_to_int(logn,mt);
            if(!mqpoly_int_to_small(logn,mt,G))return 4;
            for(size_t u=0;u<n;u++) {
                int32_t s=0;
                for(size_t j=0;j<=u;j++)s+=f[j]*G[u-j]-g[j]*F[u-j];
                for(size_t j=u+1;j<n;j++)s-=f[j]*G[n+u-j]-g[j]*F[n+u-j];
                if(s!=(u==0?12289:0))return 5;
            }
            sha256_context c;uint8_t actual[32],expected[32];
            sha256_init(&c);sha256_update(&c,polys,4*n);sha256_close(&c,actual);
            hextobin(expected,32,kat[i]);unsigned match=memcmp(actual,expected,32)==0;
            mismatches+=!match;
            count++;
            printf("BOARD_KAT degree=%u index=%u match=%u equation=PASS actual=",1u<<logn,i,match);
            for(unsigned j=0;j<32;j++)printf("%02x",actual[j]);printf("\n");
        }
    }
    printf("BOARD_KAT_DONE result=%u count=%u mismatches=%u\n",mismatches!=0,count,mismatches);return 0;
}

