/* Diagnostic sufficient bound, not an accepted production implementation. */
#include "kgen_inner.h"
uint32_t diag_l1wide_guard(unsigned logn,const int32_t *k)
{
 if(logn>3)return 1;
 uint64_t sum=0;
 for(size_t i=0;i<((size_t)1<<logn);i++) {
  uint32_t u=(uint32_t)k[i],s=u>>31;
  sum+=(uint32_t)((u^(0u-s))+s);
 }
 /* B=2^31, S=sum|k|, |carry|<=S+1.
  * Any left-associative accumulator prefix satisfies |z|<=B*(S+1).
  * S<=2^32-2 implies |z|<=2^63-2^31, with no int64 overflow.
  * The induction also preserves |floor(z/B)|<=S+1. */
 return sum<=UINT64_C(4294967294);
}
