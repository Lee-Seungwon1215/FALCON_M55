/* Offline test oracle: compile only against unchanged ntt_opt sources.
 * This program is never linked into either candidate firmware. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "kgen_inner.h"
#include "upstream_kat.h"
static uint8_t sk[FNDSA_SIGN_KEY_SIZE(10)],pk[FNDSA_VRFY_KEY_SIZE(10)],tmp[22*1024+31];
static int8_t poly[4096];static uint16_t h[1024],t[1024];
int main(void) {
    selftest_sha256();
    for(unsigned logn=8;logn<=10;logn++) {
        size_t n=(size_t)1<<logn;
        for(unsigned i=0;i<200;i++) {
            char seed[64];
            if(i<100)sprintf(seed,"test%u",i);
            else sprintf(seed,"q32-independent-20260927-%u",i-100);
            if(!fndsa_keygen_seeded_temp(logn,seed,strlen(seed),sk,pk,tmp,22*n+31))return 1;
            int8_t *f=poly,*g=f+n,*F=g+n,*G=F+n;size_t off=1;
            unsigned bits=logn==10?5:6;
            off+=trim_i8_decode(logn,sk+off,f,bits);
            off+=trim_i8_decode(logn,sk+off,g,bits);
            off+=trim_i8_decode(logn,sk+off,F,8);
            if(off+64!=FNDSA_SIGN_KEY_SIZE(logn))return 2;
            if(!mqpoly_decode(logn,pk+1,h))return 3;
            mqpoly_ext_to_int(logn,h);mqpoly_small_to_int(logn,F,t);
            mqpoly_int_to_ntt(logn,t);mqpoly_mul_ntt(logn,t,h);mqpoly_ntt_to_int(logn,t);
            if(!mqpoly_int_to_small(logn,t,G))return 4;
            sha256_context c;uint8_t digest[32];sha256_init(&c);
            sha256_update(&c,poly,4*n);sha256_close(&c,digest);
            if(i<100) {
                const char *s=logn==8?KAT_KG256[i]:logn==9?KAT_KG512[i]:KAT_KG1024[i];
                uint8_t expected[32];hextobin(expected,32,s);
                if(memcmp(expected,digest,32))return 5;
            } else {
                printf("EXTRA_ORACLE logn=%u index=%u hash=",logn,i-100);
                for(unsigned j=0;j<32;j++)printf("%02x",digest[j]);
                putchar('\n');
            }
        }
    }
    puts("ORACLE_DONE original300=PASS new=300");
    return 0;
}
