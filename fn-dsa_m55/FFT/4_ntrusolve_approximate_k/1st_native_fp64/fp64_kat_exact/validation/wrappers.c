#include "../kgen_fxp.c"
#include <assert.h>
uint64_t probe_op(unsigned op,uint64_t a,uint64_t b,unsigned e)
{
    fp64_exact x=fp64e_from_raw(a),y=fp64e_from_raw(b),z;
    switch(op) {
    case 0:z=fp64e_add(x,y);break;
    case 1:z=fp64e_sub(x,y);break;
    case 2:z=fp64e_mul(x,y);break;
    case 3:z=fp64e_neg(x);break;
    case 4:z=fp64e_half(x);break;
    case 5:return (uint32_t)fp64e_round(x);
    default:z=fp64e_mul2e(x,e);break;
    }
    assert(z.hi>=0 && z.hi<=4294967295.0 && z.hi==(double)(uint32_t)z.hi);
    assert(z.lo>=0 && z.lo<=4294967295.0 && z.lo==(double)(uint32_t)z.lo);
    return fp64e_raw(z);
}
void probe_transform(unsigned logn,unsigned op,uint64_t *a,const uint64_t *b,unsigned e)
{
    fp64_exact x[1024],y[1024];size_t n=(size_t)1<<logn;
    for(size_t i=0;i<n;i++){x[i]=fp64e_from_raw(a[i]);y[i]=fp64e_from_raw(b[i]);}
    if(op==0)vect_FFT_fp64_exact(logn,x);
    else if(op==1)vect_mul_fft_fp64_exact(logn,x,y);
    else if(op==2)vect_iFFT_fp64_exact(logn,x);
    else vect_inv_mul2e_fft_fp64_exact(logn,x,e);
    for(size_t i=0;i<n;i++)a[i]=fp64e_raw(x[i]);
}
