#include "kgen_ds_q32.h"
#include <stdio.h>
#include <inttypes.h>
static uint64_t state=UINT64_C(0x498711eff619ab31);
static uint64_t rnd(void) {state^=state<<13;state^=state>>7;state^=state<<17;return state;}
int main(void) {
    unsigned failures=0;
    const unsigned ex[][2]={{6,6},{15,15},{15,31},{20,31},{31,31}};
    for(unsigned g=0;g<5;g++) {
        unsigned projected=0,input_loss=0;
        for(unsigned i=0;i<200000;i++) {
            uint64_t x=rnd(),y=rnd();
            x=(x>>(31-ex[g][0]));y=(y>>(31-ex[g][1]));
            int64_t sx=(int64_t)(x-(UINT64_C(1)<<(ex[g][0]+32)));
            int64_t sy=(int64_t)(y-(UINT64_C(1)<<(ex[g][1]+32)));
            q32ds a=qd_from_raw((uint64_t)sx),b=qd_from_raw((uint64_t)sy);
            int64_t ax=(int64_t)qd_raw_floor(a),by=(int64_t)qd_raw_floor(b);
            input_loss+=(ax!=sx)|(by!=sy);
            uint64_t want=(uint64_t)(((__int128)ax*by)>>32);
            q32ds w=qd_from_raw(want),z=qd_mul(a,b);
            uint64_t wr=qd_raw_floor(w),zr=qd_raw_floor(z);
            projected+=wr!=zr;
        }
        printf("PRECISION xexp=%u yexp=%u count=200000 input_loss=%u projected_mul_difference=%u\n",
            ex[g][0],ex[g][1],input_loss,projected);
        failures+=projected;
    }
    return failures!=0;
}
