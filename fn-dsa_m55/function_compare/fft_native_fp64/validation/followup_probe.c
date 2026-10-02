#include "kgen_inner.h"
void audit_counterexample(uint64_t a,uint64_t b,uint64_t *fixed,double *trial,int32_t *k)
{
    fxr p=fxr_mul(fxr_of_scaled32(a),fxr_of_scaled32(b));
    double x=(double)(int32_t)(a>>32)+(double)(uint32_t)a*0x1p-32;
    double y=(double)(int32_t)(b>>32)+(double)(uint32_t)b*0x1p-32;
    double z=fp64q_mul(x,y);
    *fixed=p.v;*trial=z;
    k[0]=fxr_round(fxr_sub(p,fxr_of_scaled32(UINT64_C(0x80000000))));
    k[1]=fp64_round_i32(fp64q_sub(z,0.5));
}
