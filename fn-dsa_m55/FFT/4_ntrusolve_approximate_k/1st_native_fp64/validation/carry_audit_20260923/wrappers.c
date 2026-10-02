/* Diagnostic only: expose the existing, unchanged arithmetic primitives. */
#include "kgen_inner.h"

void audit_complex_mul(const double *x, const double *y, double *z)
{
	fp64c r = fp64c_mul((fp64c){x[0], x[1]}, (fp64c){y[0], y[1]});
	z[0] = r.re;
	z[1] = r.im;
}

uint64_t audit_fixed_mul(uint64_t x, uint64_t y)
{
	return fxr_mul(fxr_of_scaled32(x), fxr_of_scaled32(y)).v;
}

uint64_t audit_fixed_sqr(uint64_t x)
{
	return fxr_sqr(fxr_of_scaled32(x)).v;
}
