/* Test-only bound and bit-result checks for the five encoder sums.
 * No performance claim about M55 follows from this host executable. */
#include "initial_q32_rules.h"
#include <stdio.h>
#include <inttypes.h>
#include <string.h>

static uint64_t state=UINT64_C(0x5345503237465355),input,cases;
static unsigned failures;
static uint64_t zeros[5];
static uint64_t next_word(void) {
    state^=state>>12;state^=state<<25;state^=state>>27;
    return state*UINT64_C(0x2545F4914F6CDD1D);
}
static q32ds checked(float a,float b,unsigned stage) {
    q32ds old=qd_sum(a,b);
    float s=a+b,t=s-a;
    q32ds fast={s,b-t};
    zeros[stage]+=(a==0);
    if(!(a==0||fabsf(a)>=fabsf(b))||memcmp(&old,&fast,sizeof old)) {
        if(failures++<12)printf("FASTSUM_FAIL input=%016" PRIx64
            " stage=%u a=%a b=%a old=%a,%a new=%a,%a\n",
            input,stage,a,b,old.h,old.l,fast.h,fast.l);
    }
    return fast;
}
static int compare(uint64_t x) {
    input=x;cases++;
    uint32_t hi=(uint32_t)(x>>32),lo=(uint32_t)x;
    q32ds a=checked((float)((int32_t)hi>>16)*0x1p16f,(float)(hi&65535u),0);
    q32ds s=checked(a.h,(float)(lo>>16)*0x1p-16f,1);
    a=checked(s.h,(s.l+a.l)+0.0f,2);
    s=checked(a.h,(float)(lo&65535u)*0x1p-32f,3);
    a=checked(s.h,(s.l+a.l)+0.0f,4);
    q32ds old=qd_from_raw(x);
    if(memcmp(&old,&a,sizeof a)) {
        if(failures++<12)printf("ENCODE_FASTSUM_FAIL input=%016" PRIx64 "\n",x);
    }
    return failures==0;
}
int main(void) {
    const uint32_t high[]={0,1,0xffffffffu,0xffff0000u,0x0000ffffu,
        0x00ffffffu,0x01000000u,0x01000001u,0xff000001u,0xff000000u,
        0xfeffffffu,0x7fffffffu,0x80000000u,0x80000001u,0x7fff8000u,0x80007fffu};
    const uint32_t upper[]={0,1,0x7fff,0x8000,0xffff};
    for(unsigned h=0;h<sizeof high/sizeof *high;h++)
      for(unsigned m=0;m<sizeof upper/sizeof *upper;m++)
        for(uint32_t low=0;low<65536;low++)
            if(!compare(((uint64_t)high[h]<<32)|(upper[m]<<16)|low))return 1;
    for(unsigned j=0;j<10000000;j++) {
        uint64_t x=(uint64_t)((int64_t)next_word()>>(j%33));
        if(!compare(x))return 1;
    }
    printf("ENCODE_FASTSUM_HOST cases=%" PRIu64 " failures=%u\n",cases,failures);
    for(unsigned j=0;j<5;j++)printf("STAGE_ZERO stage=%u count=%" PRIu64 "\n",j,zeros[j]);
    return failures!=0;
}
