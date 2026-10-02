/* Reproduce fresh-key mismatches; never replace the upstream KAT oracle. */
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include "inner.h"
#include "upstream_kat.h"
#include <cmsis_core.h>
#include <stm32n6xx.h>
static uint8_t sk[FNDSA_SIGN_KEY_SIZE(10)],pk[FNDSA_VRFY_KEY_SIZE(10)],sig[FNDSA_SIGNATURE_SIZE(10)];
static uint8_t tmp[59*1024+31] __attribute__((aligned(32)));
static const struct {unsigned logn,index;} cases[]={ {9,1198},{9,7470},{10,1691},{10,4395},{10,10491} };
int mlk_test_main(int argc,char **argv)
{
 (void)argc;(void)argv;selftest_sha256();
 if(SystemCoreClock!=800000000u||(SCB->CCR&0x30000u)||*(volatile unsigned*)0x56008008!=0x99u||(__get_FPSCR()&0x1C00000u))return 10;
 for(unsigned c=0;c<sizeof cases/sizeof cases[0];c++) {
  unsigned l=cases[c].logn;size_t n=(size_t)1<<l,sl=FNDSA_SIGN_KEY_SIZE(l),pl=FNDSA_VRFY_KEY_SIZE(l),zl=FNDSA_SIGNATURE_SIZE(l);
  char seed[64];sprintf(seed,"fp64-audit-20260923-%u",cases[c].index);
  if(!fndsa_keygen_seeded_temp(l,seed,strlen(seed),sk,pk,tmp,22*n+31))return 1;
  sha256_context hc;uint8_t d[32];sha256_init(&hc);sha256_update(&hc,sk,sl);sha256_update(&hc,pk,pl);sha256_close(&hc,d);
  if(fndsa_sign_seeded_temp(sk,sl,"audit",5,FNDSA_HASH_ID_RAW,"message",7,seed,strlen(seed),sig,zl,tmp,59*n+31)!=zl)return 2;
  if(!fndsa_verify_temp(sig,zl,pk,pl,"audit",5,FNDSA_HASH_ID_RAW,"message",7,tmp,4*n+31))return 3;
  sig[zl-1]^=1;
  if(fndsa_verify_temp(sig,zl,pk,pl,"audit",5,FNDSA_HASH_ID_RAW,"message",7,tmp,4*n+31))return 4;
  printf("REPRO degree=%u index=%u digest=",1u<<l,cases[c].index);
  for(unsigned j=0;j<32;j++)printf("%02x",d[j]);printf(" verify=PASS tamper=PASS\n");
 }
 printf("REPRO_DONE count=5\n");return 0;
}
