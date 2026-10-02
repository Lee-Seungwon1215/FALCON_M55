/* Frozen experiment B0 arithmetic: test oracle only, never production-linked. */
#include "../host/initial_q32_rules.h"
#include <string.h>
uint64_t reference_decode(float f) { return qd_integral_bits(f); }
uint64_t reference_raw(float h,float l) {
    __asm__ volatile("" ::: "memory");
    return qd_raw_floor((q32ds){h,l});
}
uint64_t reference_mul(float ah,float al,float bh,float bl) {
    __asm__ volatile("" ::: "memory");
    q32ds q=qd_mul((q32ds){ah,al},(q32ds){bh,bl});
    uint64_t u;memcpy(&u,&q,sizeof u);return u;
}
