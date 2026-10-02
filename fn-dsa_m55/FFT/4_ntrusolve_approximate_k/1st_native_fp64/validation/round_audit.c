/* Host diagnostic only; checked conversions on all exercised reduction calls. */
#include "kgen_inner.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
static uint64_t counts[11];
static double minima[11],maxima[11];
static uint64_t rejected;
static uint64_t div_components,div_zero;
static uint64_t update_rejects;
uint32_t audited_update(unsigned logn,const int32_t *k)
{
	uint32_t ok=fp64_k_update_ok(logn,k);
	update_rejects+=!ok;
	return ok;
}
void audit_div_operand(double re,double im)
{
	div_components+=2;
	div_zero+=(re==0.0)+(im==0.0);
}
int32_t audited_round(unsigned logn,double x,uint32_t *valid)
{
	int in_range=isfinite(x) && x >= -2147483648.0 && x < 2147483647.5;
	rejected+=!in_range;
	if(!counts[logn] || x<minima[logn])minima[logn]=x;
	if(!counts[logn] || x>maxima[logn])maxima[logn]=x;
	counts[logn]++;
	int32_t r=fp64_round_i32_checked(x,valid);
	if(!in_range && (r!=0 || *valid!=0))abort();
	return r;
}
static void report(void)
{
	printf("ROUND_REJECTED coefficients=%llu\n",(unsigned long long)rejected);
	printf("DIV_ZERO components=%llu zero=%llu\n",(unsigned long long)div_components,(unsigned long long)div_zero);
	printf("UPDATE_REJECTED vectors=%llu\n",(unsigned long long)update_rejects);
	for(unsigned i=1;i<11;i++)if(counts[i])
		printf("ROUND_RANGE logn=%u count=%llu min=%a max=%a\n",i,
			(unsigned long long)counts[i],minima[i],maxima[i]);
}
__attribute__((constructor)) static void init(void){atexit(report);}
