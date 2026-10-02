/* Host-only diagnostics on PUBLIC deterministic test seeds. Never timed. */
#include "kgen_inner.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
static double saved_f[11][1024], saved_F[11][1024];
static uint64_t raw_f[11][1024],raw_F[11][1024];
static unsigned saved_e[11], round_count;
static double value(const void *p, size_t i)
{
#if TRACE_FP64
	return ((const double *)p)[i];
#else
	int64_t x; memcpy(&x,&((const fxr *)p)[i].v,8);
	return (double)x * 0x1p-32;
#endif
}
void trace_f(unsigned logn, const void *p, unsigned e)
{
	saved_e[logn]=e;
	memcpy(raw_f[logn],p,((size_t)1<<logn)*8);
	for (size_t i=0;i<((size_t)1<<logn);i++) saved_f[logn][i]=value(p,i);
}
void trace_F(unsigned logn, const void *p)
{
	memcpy(raw_F[logn],p,((size_t)1<<logn)*8);
	for (size_t i=0;i<((size_t)1<<logn);i++) saved_F[logn][i]=value(p,i);
}
static void array(const double *p, size_t n)
{
	printf("[");
	for(size_t i=0;i<n;i++) printf("%s\"%a\"",i?",":"",p[i]);
	printf("]");
}
static void bits(const uint64_t *p,size_t n)
{
	printf("[");
	for(size_t i=0;i<n;i++)printf("%s\"%016llx\"",i?",":"",(unsigned long long)p[i]);
	printf("]");
}
void trace_round(unsigned logn,unsigned depth,unsigned scale,const void *p)
{
	size_t n=(size_t)1<<logn;
	double x[1024];
	for(size_t i=0;i<n;i++) {
		x[i]=value(p,i);
		if(!isfinite(x[i]) || x[i]<-2147483648.0 || x[i]>=2147483647.5) {
			fprintf(stderr,"round range violation %a\n",x[i]); exit(7);
		}
	}
	printf("{\"type\":\"round\",\"id\":%u,\"logn\":%u,\"depth\":%u,\"scale\":%u,\"e\":%u,\"f\":",
		round_count++,logn,depth,scale,saved_e[logn]);
	array(saved_f[logn],n); printf(",\"F\":"); array(saved_F[logn],n);
	printf(",\"x\":"); array(x,n);
	printf(",\"f_bits\":");bits(raw_f[logn],n);
	printf(",\"F_bits\":");bits(raw_F[logn],n);
	printf("}\n");
}
void trace_attempt(unsigned logn,const int8_t *f,const int8_t *g)
{
	uint32_t h=2166136261u;
	for(size_t i=0;i<((size_t)1<<logn);i++) {h=(h^(uint8_t)f[i])*16777619u;h=(h^(uint8_t)g[i])*16777619u;}
	printf("{\"type\":\"attempt\",\"fg\":\"%08x\"}\n",h);
}
void trace_status(unsigned depth,int err)
{
	printf("{\"type\":\"status\",\"depth\":%u,\"error\":%d}\n",depth,err);
}
int main(int argc,char **argv)
{
	if(argc!=3)return 2;
	unsigned logn=(unsigned)atoi(argv[1]);
	uint8_t sk[FNDSA_SIGN_KEY_SIZE(10)],pk[FNDSA_VRFY_KEY_SIZE(10)];
	fndsa_keygen_seeded(logn,argv[2],strlen(argv[2]),sk,pk);
	return 0;
}
