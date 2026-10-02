/* Actual M55 A17 API exercise. Guards detect writes, not out-of-bounds reads. */
#include "inner.h"
#include <stdio.h>
#include <string.h>
#include <cmsis_core.h>
#include <stm32n6xx.h>

#define PAD 32
#define MARK 0xa7
static uint8_t sk_area[PAD+FNDSA_SIGN_KEY_SIZE(10)+PAD];
static uint8_t pk_area[PAD+FNDSA_VRFY_KEY_SIZE(10)+PAD];
static uint8_t sg_area[PAD+FNDSA_SIGNATURE_SIZE(10)+PAD];
static uint8_t temp_area[PAD+59*1024+31+PAD] __attribute__((aligned(32)));
static uint8_t message[96],context[256];
static unsigned guards,failures,validations,rejections;

static void temp_init(void){memset(temp_area,MARK,sizeof temp_area);}
static void guard(const uint8_t *p,size_t size,size_t len)
{
    for(size_t i=0;i<PAD;i++)guards+=p[i]!=MARK;
    for(size_t i=PAD+len;i<size;i++)guards+=p[i]!=MARK;
}
static int verify(const uint8_t *sig,size_t zl,const uint8_t *pk,size_t pl,size_t ml,size_t ctxlen,size_t tl)
{
    temp_init();
    int ok=fndsa_verify_temp(sig,zl,pk,pl,context,ctxlen,FNDSA_HASH_ID_RAW,message,ml,temp_area+PAD,tl);
    guard(temp_area,sizeof temp_area,tl);return ok;
}
int mlk_test_main(int argc,char **argv)
{
    (void)argc;(void)argv;
    if(SystemCoreClock!=800000000u || (SCB->CCR&0x30000u) || *(volatile unsigned*)0x56008008!=0x99u || (__get_FPSCR()&0x1C00000u))return 10;
    uint8_t *sk=sk_area+PAD,*pk=pk_area+PAD,*sig=sg_area+PAD;
    for(unsigned l=9;l<=10;l++)for(unsigned t=0;t<32;t++) {
        size_t n=(size_t)1<<l,sl=FNDSA_SIGN_KEY_SIZE(l),pl=FNDSA_VRFY_KEY_SIZE(l),zl=FNDSA_SIGNATURE_SIZE(l);
        size_t ml=t*3,ctxlen=t%3==0?255:t%3==1?0:13;
        uint8_t seed[32]="A17-security-key-and-sign-audit";seed[30]=(uint8_t)l;seed[31]=(uint8_t)t;
        for(size_t j=0;j<sizeof message;j++)message[j]=(uint8_t)(j+19*t);
        for(size_t j=0;j<sizeof context;j++)context[j]=(uint8_t)(j^t);
        memset(sk_area,MARK,sizeof sk_area);memset(pk_area,MARK,sizeof pk_area);memset(sg_area,MARK,sizeof sg_area);
        temp_init();
        if(!fndsa_keygen_seeded_temp(l,seed,sizeof seed,sk,pk,temp_area+PAD,22*n+31))return 1;
        guard(sk_area,sizeof sk_area,sl);guard(pk_area,sizeof pk_area,pl);guard(temp_area,sizeof temp_area,22*n+31);
        seed[0]^=0x80;temp_init();
        if(fndsa_sign_seeded_temp(sk,sl,context,ctxlen,FNDSA_HASH_ID_RAW,message,ml,seed,sizeof seed,
            sig,zl,temp_area+PAD,59*n+31)!=zl)return 2;
        guard(sg_area,sizeof sg_area,zl);guard(temp_area,sizeof temp_area,59*n+31);
        if(!verify(sig,zl,pk,pl,ml,ctxlen,4*n+31))return 3;
        validations++;
        for(unsigned k=0;k<32;k++) {
            size_t off=(k*131u+t*17u)%zl;unsigned mask=1u<<(k&7);
            sig[off]^=mask;failures+=verify(sig,zl,pk,pl,ml,ctxlen,4*n+31)!=0;sig[off]^=mask;rejections++;
        }
        for(unsigned k=0;k<16;k++) {
            size_t off=(k*149u+t*11u)%pl;unsigned mask=1u<<(k&7);
            pk[off]^=mask;failures+=verify(sig,zl,pk,pl,ml,ctxlen,4*n+31)!=0;pk[off]^=mask;rejections++;
        }
        if(ml) {message[0]^=1;failures+=verify(sig,zl,pk,pl,ml,ctxlen,4*n+31)!=0;message[0]^=1;rejections++;}
        context[0]^=1;failures+=verify(sig,zl,pk,pl,ml,ctxlen?ctxlen:1,4*n+31)!=0;context[0]^=1;rejections++;
        size_t sizes[]={0,1,40,zl/2,zl-1,zl+1};
        for(unsigned k=0;k<6;k++){failures+=verify(sig,sizes[k],pk,pl,ml,ctxlen,4*n+31)!=0;rejections++;}
        failures+=verify(sig,zl,pk,pl-1,ml,ctxlen,4*n+31)!=0;rejections++;
        failures+=verify(sig,zl,pk,pl,ml,256,4*n+31)!=0;rejections++;
        failures+=verify(sig,zl,pk,pl,ml,ctxlen,0)!=0;rejections++;
        temp_init();
        failures+=fndsa_keygen_seeded_temp(l,seed,sizeof seed,sk,pk,temp_area+PAD,0)!=0;
        guard(temp_area,sizeof temp_area,0);rejections++;
        temp_init();
        failures+=fndsa_sign_seeded_temp(sk,sl,context,ctxlen,FNDSA_HASH_ID_RAW,message,ml,seed,sizeof seed,
            sig,zl,temp_area+PAD,0)!=0;guard(temp_area,sizeof temp_area,0);rejections++;
        guard(sk_area,sizeof sk_area,sl);guard(pk_area,sizeof pk_area,pl);guard(sg_area,sizeof sg_area,zl);
        printf("SEC_API degree=%u index=%u valid=%u rejected=%u failures=%u guards=%u\n",1u<<l,t,validations,rejections,failures,guards);
    }
    printf("SEC_API_DONE valid=%u rejected=%u failures=%u guards=%u\n",validations,rejections,failures,guards);
    return failures!=0 || guards!=0;
}
