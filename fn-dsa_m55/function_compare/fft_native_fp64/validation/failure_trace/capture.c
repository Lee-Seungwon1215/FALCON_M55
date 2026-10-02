/* Public-seed diagnostics, never part of the production implementation. */
#include "kgen_inner.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "upstream_kat.h"
static unsigned attempt,iter;
static void words64(const void *p,size_t n)
{
 printf("[");for(size_t i=0;i<n;i++){uint64_t x;memcpy(&x,(const char *)p+8*i,8);printf("%s\"%016llx\"",i?",":"",(unsigned long long)x);}printf("]");
}
void tr_attempt(unsigned l,const int8_t *f,const int8_t *g)
{
 attempt++;printf("{\"type\":\"attempt\",\"attempt\":%u,\"f\":[",attempt);
 for(unsigned i=0;i<(1u<<l);i++)printf("%s%d",i?",":"",f[i]);printf("],\"g\":[");
 for(unsigned i=0;i<(1u<<l);i++)printf("%s%d",i?",":"",g[i]);printf("]}\n");
}
void tr_enter(unsigned l,unsigned d)
{ iter=0;printf("{\"type\":\"enter\",\"attempt\":%u,\"logn\":%u,\"depth\":%u}\n",attempt,l,d); }
void tr_iteration(unsigned l,unsigned d,unsigned scale)
{ iter++;printf("{\"type\":\"iteration\",\"attempt\":%u,\"logn\":%u,\"depth\":%u,\"iteration\":%u,\"scale\":%u}\n",attempt,l,d,iter,scale); }
void tr_stage(const char *stage,unsigned l,unsigned d,const void *p)
{
 printf("{\"type\":\"stage\",\"stage\":\"%s\",\"attempt\":%u,\"logn\":%u,\"depth\":%u,\"iteration\":%u,\"bits\":",stage,attempt,l,d,iter);
 words64(p,(size_t)1<<l);printf("}\n");
}
void tr_convert(const char *stage,unsigned l,unsigned d,const void *p,const uint32_t *v,size_t len,uint32_t sc,unsigned e)
{
 fxr fixed[1024];poly_big_to_fixed(l,fixed,v,len,sc);
 printf("{\"type\":\"convert\",\"stage\":\"%s\",\"attempt\":%u,\"logn\":%u,\"depth\":%u,\"iteration\":%u,\"len\":%u,\"scale\":%u,\"e\":%u,\"limbs\":[",stage,attempt,l,d,iter,(unsigned)len,sc,e);
 for(size_t i=0;i<(len<<l);i++)printf("%s%u",i?",":"",v[i]);printf("],\"fixed_bits\":");words64(fixed,(size_t)1<<l);
 printf(",\"bits\":");words64(p,(size_t)1<<l);printf("}\n");
}
void tr_k(unsigned l,unsigned d,const int32_t *k,unsigned ok)
{
 printf("{\"type\":\"k\",\"attempt\":%u,\"logn\":%u,\"depth\":%u,\"iteration\":%u,\"valid\":%u,\"k\":[",attempt,l,d,iter,ok);
 for(unsigned i=0;i<(1u<<l);i++)printf("%s%ld",i?",":"",(long)k[i]);printf("]}\n");
}
void tr_status(unsigned d,int err)
{ printf("{\"type\":\"status\",\"attempt\":%u,\"depth\":%u,\"error\":%d}\n",attempt,d,err); }
int main(int argc,char **argv)
{
 if(argc!=3)return 1;unsigned l=(unsigned)atoi(argv[1]);if(l<9||l>10)return 2;
 uint8_t sk[FNDSA_SIGN_KEY_SIZE(10)],pk[FNDSA_VRFY_KEY_SIZE(10)],tmp[22*1024+31];
 if(!fndsa_keygen_seeded_temp(l,argv[2],strlen(argv[2]),sk,pk,tmp,22*((size_t)1<<l)+31))return 3;
 sha256_context c;uint8_t d[32];sha256_init(&c);sha256_update(&c,sk,FNDSA_SIGN_KEY_SIZE(l));sha256_update(&c,pk,FNDSA_VRFY_KEY_SIZE(l));sha256_close(&c,d);
 printf("{\"type\":\"digest\",\"digest\":\"");for(unsigned i=0;i<32;i++)printf("%02x",d[i]);printf("\"}\n");return 0;
}
