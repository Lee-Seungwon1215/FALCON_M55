/* FP64-assisted encoding hypothesis, independent from production sources. */
#include "initial_q32_rules.h"
#include <stdio.h>
#include <string.h>
#include <inttypes.h>
static uint64_t rng=UINT64_C(0x5345503237454e43);
static uint64_t next(void) {
    rng^=rng>>12;rng^=rng<<25;rng^=rng>>27;
    return rng*UINT64_C(0x2545F4914F6CDD1D);
}
static q32ds encode(uint64_t u) {
    int32_t hi=(int32_t)(uint32_t)(u>>32);
    float h=(float)hi;
    double r=((double)hi-(double)h)+(double)(uint32_t)u*0x1p-32;
    float rh=(float)r;
    q32ds s=qd_sum(h,rh);
    return qd_sum(s.h,s.l+(float)(r-(double)rh));
}
int main(void) {
    unsigned fail=0;
    for(unsigned i=0;i<10000000;i++) {
        uint64_t x=(uint64_t)((int64_t)next()>>(i%33));
        q32ds a=qd_from_raw(x),b=encode(x);
        if(memcmp(&a,&b,sizeof a)) {
            printf("ENCODE_DIFF x=%016" PRIx64 " old=%a,%a new=%a,%a\n",x,a.h,a.l,b.h,b.l);
            if(++fail==12)break;
        }
    }
    printf("ENCODE_HYPOTHESIS failures=%u\n",fail);
    return fail!=0;
}
