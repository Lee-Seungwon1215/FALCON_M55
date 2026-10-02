#include "kgen_ds_q32.h"
#include <stdio.h>
#include <inttypes.h>
static uint64_t state=UINT64_C(0x917351ff468693af);
static uint64_t rnd(void) {
    state^=state<<13;state^=state>>7;state^=state<<17;return state;
}
int main(void) {
    unsigned codec=0,mul=0,add=0;
    for(unsigned i=0;i<1000000;i++) {
        /* Inputs +/-64, products +/-4096: result fits in DS precision. */
        int64_t x=(int64_t)(rnd()&((UINT64_C(1)<<39)-1))-(INT64_C(1)<<38);
        int64_t y=(int64_t)(rnd()&((UINT64_C(1)<<39)-1))-(INT64_C(1)<<38);
        q32ds a=qd_from_raw((uint64_t)x),b=qd_from_raw((uint64_t)y);
        codec+=qd_raw_floor(a)!=(uint64_t)x;
        add+=qd_raw_floor(qd_add(a,b))!=(uint64_t)(x+y);
        uint64_t want=(uint64_t)(((__int128)x*y)>>32);
        uint64_t got=qd_raw_floor(qd_mul(a,b));
        if(got!=want) {if(mul<3) printf("MUL x=%" PRId64 " y=%" PRId64 " want=%016" PRIx64 " got=%016" PRIx64 "\n",x,y,want,got);mul++;}
    }
    printf("Q32_RULES count=1000000 codec=%u add=%u mul=%u\n",codec,add,mul);
    return codec||mul||add;
}
