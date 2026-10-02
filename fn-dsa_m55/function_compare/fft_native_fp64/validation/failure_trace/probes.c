/* Expose actual candidate/reference primitives for isolated diagnostics. */
#include "kgen_inner.h"
uint32_t diag_old_guard(unsigned l,const int32_t *k) { return fp64_k_update_ok(l,k); }
uint32_t diag_l1_guard(unsigned l,const int32_t *k)
{
 /* DIAGNOSTIC, not a production change. The finite-domain proof is in
  * guard_analysis.py. Never remove the checked float-to-int conversion. */
 if(l>3)return 1;
 uint64_t sum=0;
 for(size_t i=0;i<((size_t)1<<l);i++) {
  uint32_t u=(uint32_t)k[i],s=u>>31;
  sum+=(uint32_t)((u^(0u-s))+s);
 }
 return sum<=INT32_MAX;
}
uint64_t diag_fixed_mul(uint64_t x,uint64_t y) { return fxr_mul(fxr_of_scaled32(x),fxr_of_scaled32(y)).v; }
uint64_t diag_fixed_sqr(uint64_t x) { return fxr_sqr(fxr_of_scaled32(x)).v; }
uint64_t diag_fixed_add(uint64_t x,uint64_t y) { return fxr_add(fxr_of_scaled32(x),fxr_of_scaled32(y)).v; }
uint64_t diag_fixed_div(uint64_t x,uint64_t y) { return fxr_div(fxr_of_scaled32(x),fxr_of_scaled32(y)).v; }
uint64_t diag_fixed_scale(uint64_t x,unsigned e) { return fxr_mul2e(fxr_of_scaled32(x),e).v; }
double diag_trial_mul(double x,double y) { return fp64q_mul(x,y); }
double diag_trial_add(double x,double y) { return fp64q_add(x,y); }
double diag_trial_div(double x,double y) { return fp64q_div(x,y); }
double diag_normal_div(double x,double y) { return fp64_div_normal(x,y); }
double diag_trial_scale(double x,unsigned e) { return fp64q_wrap(x*(double)(1u<<e)); }
