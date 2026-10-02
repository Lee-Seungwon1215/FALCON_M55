/* Domain test for A's scalar boundary conversion. Test-only bridge stubs:
 * this program does not claim to test either FFT implementation. */
#include <stdio.h>
#include "../../A_tw_bridge/kgen_fxp.c"
void fndsa_fft_bridge_forward(unsigned l,double *a) {(void)l;(void)a;}
void fndsa_fft_bridge_inverse(unsigned l,double *a) {(void)l;(void)a;}
int main(void) {
    uint64_t state=0x16b319fac826f101ull;
    for(unsigned i=0;i<1000000;i++) {
        state^=state<<13;state^=state>>7;state^=state<<17;
        int64_t raw=(int64_t)state>>12;
        double x=(double)raw*0x1p-32;
        if(fp64q_to_fixed(x).v!=(uint64_t)raw) {
            printf("A_DECODE_FAIL i=%u\n",i);return 1;
        }
    }
    puts("A_DECODE_DONE exact_representable_Q32=1000000 failures=0");
    return 0;
}
