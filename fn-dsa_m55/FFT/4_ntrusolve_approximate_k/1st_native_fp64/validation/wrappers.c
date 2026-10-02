#include "kgen_inner.h"

double validation_div_normal(double x,double y) { return fp64_div_normal(x,y); }

int32_t validation_round(double x) { return fp64_round_i32(x); }
int32_t validation_checked_round(double x, uint32_t *valid)
{
	return fp64_round_i32_checked(x,valid);
}

uint32_t validation_update_ok(unsigned logn, const int32_t *k)
{
	return fp64_k_update_ok(logn,k);
}

void validation_fixed_round(unsigned logn, const fxr *x, int32_t *k)
{
	for (size_t i = 0; i < ((size_t)1 << logn); i ++) k[i] = fxr_round(x[i]);
}
