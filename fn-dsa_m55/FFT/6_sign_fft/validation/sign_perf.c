/* Same message, key preparation and 100 signing seeds as Final_code's
 * sign_control workload. No inner profiling hooks. Hashing/verify excluded. */
#include "inner.h"
#include <cmsis_core.h>
#include <stm32n6xx.h>
#include <stdio.h>
static uint8_t sk[FNDSA_SIGN_KEY_SIZE(10)],pk[FNDSA_VRFY_KEY_SIZE(10)],sig[FNDSA_SIGNATURE_SIZE(10)];
static uint8_t tmp[59*1024+31] __attribute__((aligned(32)));
static const uint8_t message[]="FN-DSA M55 NTT before-after profiling";
static uint32_t samples[100];
static void seed_for(uint8_t *dst,size_t len,unsigned logn,unsigned phase,unsigned index)
{
    for(size_t j=0;j<len;j++)dst[j]=(uint8_t)(0xA5u+29u*j+13u*phase+7u*logn);
    for(unsigned j=0;j<4;j++)dst[j]^=(uint8_t)(index>>(8*j));
}
static uint32_t hash(uint32_t h,const void *src,size_t n)
{
    const uint8_t *p=src;for(size_t i=0;i<n;i++)h=(h^p[i])*16777619u;return h;
}
static int sign_one(unsigned logn,const uint8_t seed[40])
{
    size_t z=FNDSA_SIGNATURE_SIZE(logn);
    return fndsa_sign_seeded_temp(sk,FNDSA_SIGN_KEY_SIZE(logn),NULL,0,FNDSA_HASH_ID_RAW,
        message,sizeof message-1,seed,40,sig,z,tmp,((size_t)59<<logn)+31)==z;
}
static int verify(unsigned logn)
{
    return fndsa_verify_temp(sig,FNDSA_SIGNATURE_SIZE(logn),pk,FNDSA_VRFY_KEY_SIZE(logn),
        NULL,0,FNDSA_HASH_ID_RAW,message,sizeof message-1,tmp,((size_t)59<<logn)+31);
}
int mlk_test_main(int argc,char **argv)
{
    (void)argc;(void)argv;
    printf("SIGN_HW cpu=%u fpscr=%08x ccr=%08x tcm=%08x calls=100 warmups=3\n",
        (unsigned)SystemCoreClock,(unsigned)__get_FPSCR(),(unsigned)SCB->CCR,*(volatile unsigned*)0x56008008);
    if(SystemCoreClock!=800000000u || (SCB->CCR&0x30000u)
        || *(volatile unsigned*)0x56008008!=0x99u || (__get_FPSCR()&0x1C00000u))return 10;
    CoreDebug->DEMCR|=CoreDebug_DEMCR_TRCENA_Msk;DWT->CTRL|=DWT_CTRL_CYCCNTENA_Msk;
    for(unsigned logn=9;logn<=10;logn++){
        uint8_t kg[32],sg[40];uint32_t fp=2166136261u;uint64_t total=0;
        for(unsigned i=0;i<10;i++){
            seed_for(kg,32,logn,1,i);
            if(!fndsa_keygen_seeded_temp(logn,kg,32,sk,pk,tmp,((size_t)59<<logn)+31))return 1;
            fp=hash(fp,sk,FNDSA_SIGN_KEY_SIZE(logn));fp=hash(fp,pk,FNDSA_VRFY_KEY_SIZE(logn));
        }
        for(unsigned w=0;w<3;w++){seed_for(sg,40,logn,2,w);if(!sign_one(logn,sg)||!verify(logn))return 2;}
        for(unsigned i=0;i<100;i++){
            seed_for(sg,40,logn,2,i);uint32_t mask=__get_PRIMASK();__disable_irq();
            __DSB();__ISB();uint32_t start=DWT->CYCCNT;
            int ok=sign_one(logn,sg);
            __DSB();__ISB();uint32_t d=DWT->CYCCNT-start;__set_PRIMASK(mask);
            if(!ok||!verify(logn))return 3;
            samples[i]=d;total+=d;fp=hash(fp,sig,FNDSA_SIGNATURE_SIZE(logn));
            printf("SIGN_SAMPLE degree=%u index=%u cycles=%u\n",1u<<logn,i,d);
        }
        sig[50]^=1;if(verify(logn))return 4;sig[50]^=1;
        for(unsigned i=1;i<100;i++){uint32_t v=samples[i];unsigned j=i;
            while(j&&samples[j-1]>v){samples[j]=samples[j-1];j--;}samples[j]=v;}
        printf("SIGN_SUMMARY degree=%u calls=100 total=%llu median_lo=%u median_hi=%u min=%u max=%u fingerprint=%08x\n",
            1u<<logn,(unsigned long long)total,samples[49],samples[50],samples[0],samples[99],fp);
        if(fp!=(logn==9?0x9895079du:0xa020dd02u))return 5;
    }
    printf("SIGN_DONE verify=PASS tamper=PASS fingerprints=PASS\n");return 0;
}
