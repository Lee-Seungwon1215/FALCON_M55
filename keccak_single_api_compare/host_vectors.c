/* Independent portable original FN-DSA output digests for test inputs. */
#include "inner.h"
#include "inputs.h"
#include <stdio.h>
static uint8_t sk[FNDSA_SIGN_KEY_SIZE(10)],pk[FNDSA_VRFY_KEY_SIZE(10)];
static uint8_t sig[FNDSA_SIGNATURE_SIZE(10)],tmp[59*1024+31];
static void print_digest(FILE *f,const uint8_t *a,size_t alen,const uint8_t *b,size_t blen)
{
    shake_context s;uint8_t d[32];shake_init(&s,256);
    shake_inject(&s,a,alen);if(blen)shake_inject(&s,b,blen);
    shake_flip(&s);shake_extract(&s,d,32);
    fprintf(f,"{");for(unsigned j=0;j<32;j++)fprintf(f,"0x%02x,",d[j]);fprintf(f,"},\n");
}
int main(int argc,char **argv)
{
    if(argc!=2)return 1;FILE *f=fopen(argv[1],"w");if(!f)return 2;
    fprintf(f,"/* Original portable FN-DSA, deterministic public test inputs. */\n");
    for(unsigned which=0;which<2;which++) {
        fprintf(f,"static const uint8_t expected_%s[2][INPUTS][32]={\n",which?"sign":"key");
        for(unsigned logn=9;logn<=10;logn++) {
            fprintf(f,"{\n");
            for(unsigned i=0;i<INPUTS;i++) {
                uint8_t ks[32],ss[40],msg[32];make_input(logn,i,ks,ss,msg);
                if(!fndsa_keygen_seeded_temp(logn,ks,32,sk,pk,tmp,sizeof tmp))return 3;
                if(which) {
                    size_t z=fndsa_sign_seeded_temp(sk,FNDSA_SIGN_KEY_SIZE(logn),"single",6,
                        FNDSA_HASH_ID_RAW,msg,32,ss,40,sig,FNDSA_SIGNATURE_SIZE(logn),tmp,sizeof tmp);
                    if(z!=FNDSA_SIGNATURE_SIZE(logn))return 4;
                    if(!fndsa_verify_temp(sig,z,pk,FNDSA_VRFY_KEY_SIZE(logn),"single",6,
                        FNDSA_HASH_ID_RAW,msg,32,tmp,sizeof tmp))return 5;
                    print_digest(f,sig,z,NULL,0);
                } else print_digest(f,sk,FNDSA_SIGN_KEY_SIZE(logn),pk,FNDSA_VRFY_KEY_SIZE(logn));
            }
            fprintf(f,"},\n");
        }
        fprintf(f,"};\n");
    }
    return fclose(f)!=0;
}
