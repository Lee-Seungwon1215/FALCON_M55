/* Public-seed diagnostic: shadow the untouched fixed-point solver with FP64.
 * Only the first different rounded k is saved, before integer state diverges. */
#include "kgen_inner.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
static double input_f[1024],input_F[1024],inverse[1024],fft_f[1024];
static fxr inverse_q[1024],fft_q[1024];
static unsigned exponent,rounds,found;
#ifndef SHADOW_FIXED_INVERSE
#define SHADOW_FIXED_INVERSE 0
#endif
void shadow_f(unsigned l,const fxr *f,unsigned e)
{
    if(found)return;
    exponent=e;size_t n=(size_t)1<<l;
    for(size_t i=0;i<n;i++)input_f[i]=(double)(int64_t)f[i].v*0x1p-32;
    memcpy(inverse,input_f,n*8);memcpy(inverse_q,f,n*8);
    vect_FFT_fp64(l,inverse);vect_FFT(l,inverse_q);
    memcpy(fft_f,inverse,n*8);memcpy(fft_q,inverse_q,n*8);
    vect_inv_mul2e_fft_fp64(l,inverse,e);vect_inv_mul2e_fft(l,inverse_q,e);
}
void shadow_F(unsigned l,const fxr *f)
{
    if(found)return;
    for(size_t i=0;i<((size_t)1<<l);i++)input_F[i]=(double)(int64_t)f[i].v*0x1p-32;
}
static void array(const char *name,const double *a,size_t n)
{
    printf(",\"%s\":[",name);
    for(size_t i=0;i<n;i++)printf("%s\"%a\"",i?",":"",a[i]);
    printf("]");
}
void shadow_round(unsigned l,unsigned depth,const fxr *reference)
{
    if(found)return;
    rounds++;size_t n=(size_t)1<<l,hn=n>>1;
    double a[1024],b[1024],qinv[1024],qout[1024],qfft[1024],zq[512],zd[512];
    memcpy(a,input_F,n*8);memcpy(b,input_F,n*8);
    for(size_t i=0;i<n;i++)qinv[i]=(double)(int64_t)inverse_q[i].v*0x1p-32;
    vect_FFT_fp64(l,a);vect_mul_fft_fp64(l,a,SHADOW_FIXED_INVERSE?qinv:inverse);vect_iFFT_fp64(l,a);
    unsigned different=0;
    for(size_t i=0;i<n;i++){
        uint32_t valid=1;int32_t k=fp64_round_i32_checked(a[i],&valid);
        different+=!valid || k!=fxr_round(reference[i]);
    }
    if(!different)return;
    found=1;
    /* Same FP64 repeated path, but with the original fixed reciprocal. */
    vect_FFT_fp64(l,b);vect_mul_fft_fp64(l,b,qinv);vect_iFFT_fp64(l,b);
    unsigned residual=0;
    for(size_t i=0;i<n;i++){
        uint32_t valid=1;int32_t k=fp64_round_i32_checked(b[i],&valid);
        residual+=!valid || k!=fxr_round(reference[i]);
        qout[i]=(double)(int64_t)reference[i].v*0x1p-32;
        qfft[i]=(double)(int64_t)fft_q[i].v*0x1p-32;
    }
    for(size_t i=0;i<hn;i++){
        zq[i]=(double)(int64_t)fxr_add(fxr_sqr(fft_q[i]),fxr_sqr(fft_q[i+hn])).v*0x1p-32;
        zd[i]=fft_f[i]*fft_f[i]+fft_f[i+hn]*fft_f[i+hn];
    }
    printf("{\"round\":%u,\"logn\":%u,\"depth\":%u,\"e\":%u,\"differences\":%u,\"fixed_inverse_residual\":%u",rounds,l,depth,exponent,different,residual);
    array("f",input_f,n);array("F",input_F,n);array("fixed_fft_f",qfft,n);array("fp64_fft_f",fft_f,n);
    array("fixed_z",zq,hn);array("fp64_z",zd,hn);array("fixed_inverse",qinv,n);array("fp64_inverse",inverse,n);
    array("fixed_x",qout,n);array("fp64_x",a,n);array("fixed_inverse_x",b,n);puts("}");
}
int main(int argc,char **argv)
{
    if(argc!=3)return 2;
    unsigned l=(unsigned)atoi(argv[1]);
    uint8_t sk[FNDSA_SIGN_KEY_SIZE(10)],pk[FNDSA_VRFY_KEY_SIZE(10)];
    fndsa_keygen_seeded(l,argv[2],strlen(argv[2]),sk,pk);
    if(!found)puts("{\"differences\":0}");
    return 0;
}
