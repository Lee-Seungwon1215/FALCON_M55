/* Portable, unmodified original implementation supplies expected keys and
 * valid ORIGINAL signatures. None of these public test keys is for use. */
#include "inner.h"
#include "inputs.h"
#include <stdio.h>
static uint8_t sk[FNDSA_SIGN_KEY_SIZE(10)], pk[FNDSA_VRFY_KEY_SIZE(10)];
static uint8_t sig[FNDSA_SIGNATURE_SIZE(10)], tmp[59*1024+31];
static void emit(FILE *f,const uint8_t *b,size_t n)
{
    fprintf(f,"{");
    for(size_t i=0;i<n;i++) fprintf(f,"0x%02x,%s",b[i],i%24==23?"\n":"");
    fprintf(f,"},\n");
}
int main(int argc,char **argv)
{
    if(argc!=2)return 1;
    FILE *f=fopen(argv[1],"w");if(!f)return 2;
    fprintf(f,"/* Deterministic original portable outputs; test-only. */\n");
    for(unsigned which=0;which<2;which++) {
        fprintf(f,"static const uint8_t expected_%s[2][INPUTS][%u]={\n",
            which?"sig":"key",which?(unsigned)sizeof sig:32);
        for(unsigned logn=9;logn<=10;logn++) {
            fprintf(f,"{\n");
            for(unsigned i=0;i<INPUTS;i++) {
                uint8_t seed[32],ss[40],msg[32],digest[32];make_input(logn,i,seed,ss,msg);
                if(!fndsa_keygen_seeded_temp(logn,seed,32,sk,pk,tmp,sizeof tmp))return 3;
                if(which) {
                    size_t len=fndsa_sign_seeded_temp(sk,FNDSA_SIGN_KEY_SIZE(logn),"single",6,
                        FNDSA_HASH_ID_RAW,msg,32,ss,40,sig,FNDSA_SIGNATURE_SIZE(logn),tmp,sizeof tmp);
                    if(len!=FNDSA_SIGNATURE_SIZE(logn))return 4;
                    emit(f,sig,len);
                } else {
                    shake_context sc;shake_init(&sc,256);
                    shake_inject(&sc,sk,FNDSA_SIGN_KEY_SIZE(logn));
                    shake_inject(&sc,pk,FNDSA_VRFY_KEY_SIZE(logn));
                    shake_flip(&sc);shake_extract(&sc,digest,32);emit(f,digest,32);
                }
            }
            fprintf(f,"},\n");
        }
        fprintf(f,"};\n");
    }
    fprintf(f,"static const uint8_t expected_mixed_sig[4][%u]={\n",(unsigned)sizeof sig);
    const size_t lengths[4]={0,135,136,1024};
    for(unsigned l=0;l<4;l++) {
        uint8_t data[1056],ss[40];
        for(unsigned j=0;j<sizeof data;j++) data[j]=(uint8_t)(j*17+l*43);
        for(unsigned j=0;j<40;j++) ss[j]=(uint8_t)(j+l);
        unsigned logn=9+(l&1);
        if(!fndsa_keygen_seeded_temp(logn,data,lengths[l],sk,pk,tmp,sizeof tmp))return 5;
        const char *id=l==2?FNDSA_HASH_ID_SHA256:(l==3?FNDSA_HASH_ID_EXTMU:FNDSA_HASH_ID_RAW);
        size_t hvlen=l==2?32:(l==3?64:lengths[l]);
        size_t z=fndsa_sign_seeded_temp(sk,FNDSA_SIGN_KEY_SIZE(logn),data,l==1?255:0,id,data,hvlen,
            ss,40,sig,sizeof sig,tmp,sizeof tmp);
        if(z!=FNDSA_SIGNATURE_SIZE(logn))return 6;
        emit(f,sig,z);
    }
    fprintf(f,"};\n");
    return fclose(f)!=0;
}
