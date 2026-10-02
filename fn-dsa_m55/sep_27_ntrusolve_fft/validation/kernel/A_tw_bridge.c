#include "common.h"
static double work[1024] __attribute__((aligned(32)));
static void pack(unsigned l,const fxr *a) {
    for(size_t i=0;i<((size_t)1<<l);i++)
        work[i]=(double)(int32_t)(a[i].v>>32)+(double)(uint32_t)a[i].v*0x1p-32;
}
static void transform(unsigned l,unsigned inv) {
    if(inv)vect_iFFT_fp64(l,work);else vect_FFT_fp64(l,work);
}
static void unpack(unsigned l,fxr *a) {
    for(size_t i=0;i<((size_t)1<<l);i++) {
        double h; __asm__("vrintm.f64 %P0, %P1":"=w"(h):"w"(work[i]));
        a[i].v=((uint64_t)(uint32_t)(int32_t)h<<32)
            |(uint32_t)((work[i]-h)*0x1p32);
    }
}
static int division_check(void) {
    static const double x[16]={0,1,-1,0x1p-32,-0x1p-32,3.25,-3.25,
        0x1p20,-0x1p20,1,1,0,0.5,-0.5,0x1p-20,-0x1p-20};
    static const double y[16]={1,1,1,1,1,0.75,0.75,3,3,0,2,0,
        -1,-1,0x1p-10,0x1p-10};
    unsigned fail=0;
    for(unsigned c=0;c<16;c++) {
        double a[2],b[2]={y[c],0};
        uint32_t min=UINT32_MAX,max=0;
        for(unsigned trial=0;trial<20;trial++) {
            unsigned irq=__get_PRIMASK();__disable_irq();
            uint32_t t=ticks();
            for(unsigned j=0;j<128;j++) {
                a[0]=x[c];a[1]=-x[c];
                vect_div_selfadj_fft_fp64(1,a,b);
                __asm__ volatile("" ::: "memory");
            }
            uint32_t elapsed=ticks()-t;__set_PRIMASK(irq);
            if(elapsed<min)min=elapsed;if(elapsed>max)max=elapsed;
        }
        work[0]=a[0];work[1]=a[1];unpack(1,actual);
        uint64_t xr=(uint64_t)(int64_t)(x[c]*0x1p32);
        uint64_t yr=(uint64_t)(int64_t)(y[c]*0x1p32);
        unsigned ok=actual[0].v==inner_fxr_div(xr,yr)
            &&actual[1].v==inner_fxr_div(0-xr,yr);
        fail+=!ok;sink^=actual[0].v;
        printf("DIV_TIMING class=%u calls=128 trials=20 min=%u max=%u match=%u\n",
            c,min,max,ok);
    }
    printf("DIV_DONE classes=16 failures=%u\n",fail);return fail!=0;
}
int mlk_test_main(int argc,char **argv) {
    (void)argc;(void)argv;int r=kernel_main();return r?r:division_check();
}
