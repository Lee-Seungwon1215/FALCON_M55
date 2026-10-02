/* Test-only B16 derivation. Strict FP, no performance inference for M55. */
#include "initial_q32_rules.h"
#include <inttypes.h>
#include <stdio.h>
#include <string.h>
static uint64_t state=UINT64_C(0x5345503244465355),cases,fraction_checks,zero_signs;
static unsigned failures;
static uint64_t next_word(void) {
    state^=state>>12;state^=state<<25;state^=state>>27;
    return state*UINT64_C(0x2545F4914F6CDD1D);
}
static float from_bits(uint32_t u) {float x;memcpy(&x,&u,4);return x;}
static q32ds fast(float a,float b) {
    float s=a+b,t=s-a;return (q32ds){s,b-t};
}
static q32ds fraction(float x,float f) {
    q32ds original=qd_sum(x,-f),trial=fast(-f,x);
    fraction_checks++;
    /* For positive x>=1, floor(x) has the SAME exponent as x.
     * For negative x, |floor(x)|>=|x|. Zero-left is exact directly. */
    int valid=f==0 || ilogbf(fabsf(f))>=ilogbf(fabsf(x));
    if(!valid||original.h!=trial.h||original.l!=trial.l) {
        if(failures++<8)printf("FRAC_FAIL x=%a f=%a old=%a,%a new=%a,%a\n",
            x,f,original.h,original.l,trial.h,trial.l);
    }
    /* The residual of -0 + +0 can differ in zero sign. No other bit
     * differences are accepted. The final raw-word output is exact. */
    if(memcmp(&original,&trial,sizeof trial))zero_signs++;
    return trial;
}
static int compare(q32ds a) {
    float x=a.h*0x1p32f,y=a.l*0x1p32f;
    float xf=floorf(x),yf=floorf(y);
    q32ds p=fraction(x,xf),q=fraction(y,yf);
    q32ds s=qd_sum(p.h,q.h);
    float low=(s.l+p.l)+q.l;
    q32ds r=fast(s.h,low),original=qd_sum(s.h,low);
    cases++;
    if(!(s.h==0||fabsf(s.h)>=fabsf(low))||
        original.h!=r.h||original.l!=r.l) {
        if(failures++<8)printf("NORM_FAIL h=%a l=%a\n",s.h,low);
    }
    int32_t c=(int32_t)floorf(r.h);
    c-=(r.h==(float)c)&(r.l<0);
    uint64_t result=qd_integral_bits(xf)+qd_integral_bits(yf)+(uint64_t)(int64_t)c;
    uint64_t expected=qd_raw_floor(a);
    if(result!=expected) {
        if(failures++<8)printf("DECODE_FASTSUM_FAIL h=%a l=%a got=%016" PRIx64
            " ref=%016" PRIx64 "\n",a.h,a.l,result,expected);
    }
    return failures==0;
}
int main(void) {
    const uint32_t edges[]={0,0x80000000,1,0x80000001,0x007fffff,0x807fffff,
        0x00800000,0x80800000,0x3f000000,0xbf000000,0x3f7fffff,0xbf7fffff,
        0x3f800000,0xbf800000,0x3f800001,0xbf800001,0x6f7fffff,0xef7fffff};
    for(unsigned e=0;e<223;e++)for(unsigned m=0;m<4096;m++)
      for(unsigned sign=0;sign<2;sign++) {
        uint32_t word=(sign<<31)|(e<<23)|(m==4095?0x7fffff:m*2049);
        for(unsigned side=0;side<2;side++) {
            float x=from_bits(word),y=from_bits(edges[(e+m)%18]);
            if(!compare(side?(q32ds){y,x}:(q32ds){x,y}))return 1;
        }
      }
    for(unsigned i=0;i<18;i++)for(unsigned j=0;j<18;j++)
        if(!compare((q32ds){from_bits(edges[i]),from_bits(edges[j])}))return 1;
    for(unsigned j=0;j<10000000;j++) {
        q32ds a;
        if(j&1)a=qd_from_raw(next_word());
        else {
            a.h=from_bits(((uint32_t)next_word()&0x807fffff)|((next_word()%223)<<23));
            a.l=from_bits(((uint32_t)next_word()&0x807fffff)|((next_word()%223)<<23));
        }
        if(!compare(a))return 1;
    }
    printf("DECODE_FASTSUM_HOST cases=%" PRIu64 " fraction_checks=%" PRIu64
        " zero_sign_differences=%" PRIu64 " failures=%u\n",cases,fraction_checks,zero_signs,failures);
    return failures!=0;
}
