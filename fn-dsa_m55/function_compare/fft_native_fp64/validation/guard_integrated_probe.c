/* Test only: expose the actual, directly integrated production guard. */
#include "kgen_inner.h"
uint32_t integrated_guard(unsigned logn,const int32_t *k)
{
 return fp64_k_update_ok(logn,k);
}
