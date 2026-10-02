#include "common.h"
#include "kgen_ds.h"
#include "kgen_ds_q32.h"
static fndsa_ds_poly work __attribute__((aligned(32)));
static void pack(unsigned l,const fxr *a) {
    size_t hn=(size_t)1<<(l-1);
    for(size_t i=0;i<hn;i++) {
        q32ds r=qd_from_raw(a[i].v),s=qd_from_raw(a[i+hn].v);
        work.re[0][i]=r.h;work.re[1][i]=r.l;
        work.im[0][i]=s.h;work.im[1][i]=s.l;
    }
}
static void transform(unsigned l,unsigned inv) {
    if(inv)fndsa_ds_ifft(l,&work);else fndsa_ds_fft(l,&work);
}
static void unpack(unsigned l,fxr *a) {
    size_t hn=(size_t)1<<(l-1);
    for(size_t i=0;i<hn;i++) {
        a[i].v=qd_raw_floor((q32ds){work.re[0][i],work.re[1][i]});
        a[i+hn].v=qd_raw_floor((q32ds){work.im[0][i],work.im[1][i]});
    }
}
int mlk_test_main(int argc,char **argv) { (void)argc;(void)argv;return kernel_main(); }
