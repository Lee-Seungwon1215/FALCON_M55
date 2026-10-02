/* Full original host tests; continue KEYGEN KAT after mismatches. */
#define main unused_upstream_main
#include "test_fndsa.c"
#undef main
int main(void)
{
    unsigned count=0,mismatches=0;
    test_keygen_self();
    for(unsigned logn=8;logn<=10;logn++) {
        size_t n=(size_t)1<<logn;
        const char *const *kat=logn==8?KAT_KG256:logn==9?KAT_KG512:KAT_KG1024;
        for(unsigned i=0;kat[i];i++) {
            uint8_t sk[FNDSA_SIGN_KEY_SIZE(10)],pk[FNDSA_VRFY_KEY_SIZE(10)],tmp[22*1024+31];
            int8_t pol[4*1024]; char seed[32]; sprintf(seed,"test%u",i);
            if(!fndsa_keygen_seeded_temp(logn,seed,strlen(seed),sk,pk,tmp,22*n+31))return 3;
            check_keypair(logn,sk,pk,pol,pol+n,pol+2*n,pol+3*n);
            sha256_context c;uint8_t actual[32],expected[32];
            sha256_init(&c);sha256_update(&c,pol,4*n);sha256_close(&c,actual);
            hextobin(expected,32,kat[i]);unsigned match=memcmp(actual,expected,32)==0;
            mismatches+=!match;count++;
            printf("KEY_KAT degree=%u seed=%s match=%u actual=",1u<<logn,seed,match);
            for(unsigned j=0;j<32;j++)printf("%02x",actual[j]);printf("\n");
        }
    }
    test_verify();test_self();
    printf("KEY_KAT_SUMMARY count=%u mismatches=%u equation_and_range=PASS\n",count,mismatches);
    fflush(stdout);test_kat();return mismatches?2:0;
}
