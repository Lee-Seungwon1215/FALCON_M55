/* Additional deterministic seeds, independent of published KAT vectors. */
#define main unused_upstream_main
#include "test_fndsa.c"
#undef main
int main(int argc,char **argv)
{
    unsigned count=argc>1?(unsigned)strtoul(argv[1],NULL,10):1000;
    unsigned start=argc>2?(unsigned)strtoul(argv[2],NULL,10):0;
    if(count==0 || count>100000 || start>100000)return 4;
    for(unsigned logn=9;logn<=10;logn++)for(unsigned i=start;i<start+count;i++) {
        size_t n=(size_t)1<<logn;
        uint8_t sk[FNDSA_SIGN_KEY_SIZE(10)],pk[FNDSA_VRFY_KEY_SIZE(10)],tmp[22*1024+31];
        int8_t pol[4*1024];char seed[64];sprintf(seed,"fp64-audit-20260923-%u",i);
        if(!fndsa_keygen_seeded_temp(logn,seed,strlen(seed),sk,pk,tmp,22*n+31))return 3;
        check_keypair(logn,sk,pk,pol,pol+n,pol+2*n,pol+3*n);
        sha256_context c;uint8_t digest[32];sha256_init(&c);
        sha256_update(&c,sk,FNDSA_SIGN_KEY_SIZE(logn));sha256_update(&c,pk,FNDSA_VRFY_KEY_SIZE(logn));
        sha256_close(&c,digest);
        printf("EXTRA_KEY degree=%u index=%u digest=",1u<<logn,i);
        for(unsigned j=0;j<32;j++)printf("%02x",digest[j]);printf("\n");
        if(i%100==0)fflush(stdout);
    }
    printf("EXTRA_DONE count=%u equation_and_range=PASS\n",count*2);return 0;
}
