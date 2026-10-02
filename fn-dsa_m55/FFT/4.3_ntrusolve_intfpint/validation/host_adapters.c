/* Generated verbatim C adapter extraction for host arithmetic test.
 * Production MVE FFT is separately tested on board. */
#include "kgen_ds.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
typedef struct { float h,l; } dsp;
static inline dsp dsum(float a,float b) {
    float s=a+b,v=s-a;
    return (dsp){s,(a-(s-v))+(b-v)};
}
static inline dsp dadd(dsp a,dsp b) {
    dsp s=dsum(a.h,b.h);
    return dsum(s.h,(s.l+a.l)+b.l);
}
static inline dsp dneg(dsp a) {return (dsp){-a.h,-a.l};}
static inline dsp dmul(dsp a,dsp b) {
    float p=a.h*b.h;
    float e=__builtin_fmaf(a.h,b.h,-p);
    e=__builtin_fmaf(a.h,b.l,e);
    e=__builtin_fmaf(a.l,b.h,e);
    e=__builtin_fmaf(a.l,b.l,e);
    return dsum(p,e);
}
static inline dsp dscale(dsp a,float s) {
    return (dsp){a.h*s,a.l*s};
}
static inline dsp getds(const float p[2][512],size_t u) {
    return (dsp){p[0][u],p[1][u]};
}
static inline void putds(float p[2][512],size_t u,dsp a) {
    p[0][u]=a.h;p[1][u]=a.l;
}
static inline float pow2i(int e) {
    union {uint32_t u;float f;} a={(uint32_t)(127+e)<<23};
    return a.f;
}
/* Normalize to a positive normal mantissa before the scalar FDIV seed.
 * Two fixed residual corrections recover approximately 48 bits.
 * Valid NTRU domain: nonzero normal divisor, result within finite FP32.
 * No all-input timing proof is asserted. */
static inline dsp ddiv(dsp a,dsp b) {
    union {float f;uint32_t u;} bits={b.h};
    uint32_t exponent=(bits.u>>23)&255u;
    uint32_t valid=(exponent!=0u)&(exponent!=255u),mask=0u-valid;
    bits.u=(bits.u&mask)|(0x3f800000u&~mask);
    b.h=bits.f;
    union {float f;uint32_t u;} low={b.l};low.u&=mask;b.l=low.f;
    int e=(int)((bits.u>>23)&255)-127;
    float sc=pow2i(-e);
    dsp bn=dscale(b,sc),an=dscale(a,sc);
    float seed=1.0f/bn.h;
    dsp q=dmul(an,(dsp){seed,0});
    for(unsigned j=0;j<2;j++) {
        dsp r=dadd(an,dneg(dmul(bn,q)));
        q=dadd(q,dmul(r,(dsp){seed,0}));
    }
    /* Propagate invalid-domain status as a canonical NaN; to_k scans and
     * rejects it without an undefined floating-to-integer conversion. */
    union {float f;uint32_t u;} out={q.h};
    out.u=(out.u&mask)|(0x7fc00000u&~mask);q.h=out.f;
    return q;
}
/* Construct the same selected/scaled input bits as poly_big_to_fixed,
 * but write FP32 components directly, never an fxr input array.
 * The limb scan and masks deliberately preserve secret-scale access rules. */
void fndsa_ds_from_big(unsigned logn,fndsa_ds_poly *d,
    const uint32_t *f,size_t len,uint32_t sc)
{
    size_t n=(size_t)1<<logn,hn=n>>1;
    if(len==0) {
        for(unsigned part=0;part<2;part++)
            for(unsigned limb=0;limb<2;limb++)
                memset(part?d->im[limb]:d->re[limb],0,hn*sizeof(float));
        return;
    }
    uint32_t sch,scl; DIVREM31(sch,scl,sc);
    uint32_t z=(scl-1)>>31;sch-=z;scl|=31&-z;
    uint32_t t0=(sch-1)&0xffffff,t1=sch&0xffffff,t2=(sch+1)&0xffffff;
    for(size_t i=0;i<n;i++) {
        uint32_t w0=0,w1=0,w2=0;
        for(size_t j=0;j<len;j++) {
            uint32_t w=f[i+(j<<logn)],t=(uint32_t)j&0xffffff;
            w0|=w&-(((t^t0)-1)>>31);
            w1|=w&-(((t^t1)-1)>>31);
            w2|=w&-(((t^t2)-1)>>31);
        }
        uint32_t ws=-(f[i+((len-1)<<logn)]>>30)>>1;
        w0|=ws&-(((uint32_t)len-sch)>>31);
        w1|=ws&-(((uint32_t)len-sch-1)>>31);
        w2|=ws&-(((uint32_t)len-sch-2)>>31);
        w2|=(w2&0x40000000u)<<1;
        uint32_t xl=(w0>>(scl-1))|(w1<<(32-scl));
        uint32_t xh=(w1>>scl)|(w2<<(31-scl));
        dsp a=dsum((float)((int32_t)xh>>16)*0x1p16f,(float)(xh&65535));
        a=dadd(a,(dsp){(float)(xl>>16)*0x1p-16f,0});
        a=dadd(a,(dsp){(float)(xl&65535)*0x1p-32f,0});
        putds(i<hn?d->re:d->im,i&(hn-1),a);
    }
}
void fndsa_ds_from_i32(unsigned logn,fndsa_ds_poly *d,
    const uint32_t *f,unsigned sc)
{
    size_t n=(size_t)1<<logn,hn=n>>1;
    float s=pow2i(-(int)sc);
    for(size_t i=0;i<n;i++) {
        int32_t x;memcpy(&x,f+i,sizeof x);
        dsp a=dsum((float)(x>>16)*0x1p16f,(float)((uint32_t)x&65535));
        putds(i<hn?d->re:d->im,i&(hn-1),dscale(a,s));
    }
}
int fndsa_ds_to_k(unsigned logn,int32_t *d,const fndsa_ds_poly *s) {
    size_t n=(size_t)1<<logn,hn=n>>1;
    uint32_t valid=1;
    for(size_t i=0;i<n;i++) {
        dsp x=getds(i<hn?s->re:s->im,i&(hn-1));
        union {float f;uint32_t u;} xh={x.h},xl={x.l};
        uint32_t ok=((xh.u&0x7fffffffu)<0x4f000000u)
            &((xl.u&0x7fffffffu)<0x4f000000u);
        uint32_t mask=0u-ok;xh.u&=mask;xl.u&=mask;
        valid&=ok;x.h=xh.f;x.l=xl.f;
        /* Match the retained original grid semantics at this boundary:
         * nearest Q32 then floor(x+.5) == floor(x+.5+2^-33).
         * No Q32 array and no int64 cast; retain low component at ties. */
        dsp a=dadd(dadd(x,(dsp){0.5f,0}),(dsp){0x1p-33f,0});
        xh.f=a.h;xl.f=a.l;
        ok=((xh.u&0x7fffffffu)<0x4f000000u)
            &((xl.u&0x7fffffffu)<0x4f000000u);
        mask=0u-ok;xh.u&=mask;xl.u&=mask;valid&=ok;
        a.h=xh.f;a.l=xl.f;
        float hi=__builtin_floorf(a.h),lo=__builtin_floorf(a.l);
        dsp fraction=dadd(dsum(a.h,-hi),dsum(a.l,-lo));
        int32_t carry=(int32_t)__builtin_floorf(fraction.h);
        carry-=(fraction.h==(float)carry) & (fraction.l<0);
        int64_t k=(int64_t)(int32_t)hi+(int64_t)(int32_t)lo+carry;
        valid&=(k>=INT32_MIN)&(k<=INT32_MAX);
        d[i]=(int32_t)(uint32_t)k;
    }
    return (int)valid;
}

void
oracle_big_to_fixed(unsigned logn, fxr *restrict d, const uint32_t *restrict f,
	size_t len, uint32_t sc)
{
	size_t n = (size_t)1 << logn;
	if (len == 0) {
		memset(d, 0, n * sizeof *d);
		return;
	}

	/*
	 * We split the bit length into sch and scl such that:
	 *   sc = 31*sch + scl
	 * We also want scl in the 1..31 range, not 0..30. It may happen
	 * that sch becomes -1, which will "wrap around" (harmlessly).
	 *
	 * For each coefficient, we need three words, each with a given
	 * left shift (negative for a right shift):
	 *    sch-1   1 - scl
	 *    sch     32 - scl
	 *    sch+1   63 - scl
	 */
	uint32_t sch, scl;
	DIVREM31(sch, scl, sc);
	uint32_t z = (scl - 1) >> 31;
	sch -= z;
	scl |= 31 & -z;

	uint32_t t0 = (uint32_t)(sch - 1) & 0xFFFFFF;
	uint32_t t1 = sch & 0xFFFFFF;
	uint32_t t2 = (uint32_t)(sch + 1) & 0xFFFFFF;

	for (size_t i = 0; i < n; i ++, f ++) {
		uint32_t w0, w1, w2, ws, xl, xh;

		w0 = 0;
		w1 = 0;
		w2 = 0;
		for (size_t j = 0; j < len; j ++) {
			uint32_t t, w;

			w = f[j << logn];
			t = (uint32_t)j & 0xFFFFFF;
			w0 |= w & -((uint32_t)((t ^ t0) - 1) >> 31);
			w1 |= w & -((uint32_t)((t ^ t1) - 1) >> 31);
			w2 |= w & -((uint32_t)((t ^ t2) - 1) >> 31);
		}

		/*
		 * If there were not enough words for the requested
		 * scaling, then we must supply copies with the proper
		 * sign.
		 */
		ws = -(f[(len - 1) << logn] >> 30) >> 1;
		w0 |= ws & -((uint32_t)((uint32_t)len - sch) >> 31);
		w1 |= ws & -((uint32_t)((uint32_t)len - sch - 1) >> 31);
		w2 |= ws & -((uint32_t)((uint32_t)len - sch - 2) >> 31);

		/*
		 * Assemble the 64-bit value with the shifts. We assume
		 * that shifts on 32-bit values are constant-time with
		 * regard to the shift count (this should be true on all
		 * modern architectures; the last notable arch on which
		 * shift timing depended on the count was the Pentium IV).
		 *
		 * Since the shift count (scl) is guaranteed to be in 1..31,
		 * we do not have special cases to handle.
		 *
		 * We must sign-extend w2 to ensure the sign bit is properly
		 * set in the fnr value.
		 */
		w2 |= (uint32_t)(w2 & 0x40000000) << 1;
		xl = (w0 >> (scl - 1)) | (w1 << (32 - scl));
		xh = (w1 >> scl) | (w2 << (31 - scl));
		d[i] = fxr_of_scaled32((uint64_t)xl | ((uint64_t)xh << 32));
	}
}

static uint32_t state=1234567;
static uint32_t rnd(void){state^=state<<13;state^=state>>17;state^=state<<5;return state;}
static fndsa_ds_poly w;
static uint32_t in[8*1024];
static fxr out[1024];
static int32_t ko[1024];
int main(void) {
    unsigned long long count=0,bad=0;
    for(unsigned logn=1;logn<=10;logn++) {
        size_t n=(size_t)1<<logn,hn=n>>1;
        for(unsigned len=0;len<=8;len++) for(unsigned rep=0;rep<100;rep++) {
            for(unsigned j=0;j<len;j++) for(size_t i=0;i<n;i++)
                in[i+((size_t)j<<logn)]=rnd()&0x7fffffffu;
            /* Limit selected value to the signed <2^15 solver domain,
             * and cover secret scaling far beyond the limb window. */
            unsigned sc=len==0?rep:31*len-15+(rep%70);
            fndsa_ds_from_big(logn,&w,in,len,sc);
            oracle_big_to_fixed(logn,out,in,len,sc);
            for(size_t i=0;i<n;i++) {
                double got=i<hn?(double)w.re[0][i]+w.re[1][i]
                    :(double)w.im[0][i-hn]+w.im[1][i-hn];
                double want=(double)(int32_t)(out[i].v>>32)
                    +(double)(uint32_t)out[i].v*0x1p-32;
                bad+=got!=want;count++;
            }
        }
    }
    /* Explicit scl wrap points, including signed extension, with a
     * bounded integer part so the selected Q32 value fits DS precision. */
    unsigned scales[]={0,31,62};
    for(unsigned z=0;z<3;z++)for(unsigned rep=0;rep<100;rep++) {
        unsigned sc=scales[z];size_t n=16,hn=8,len=4;
        for(size_t i=0;i<n;i++) {
            __int128 x=((__int128)((int32_t)(rnd()%8191)-4095))
                *(((__int128)1)<<sc);
            if(sc)x+=(__int128)rnd();
            for(unsigned j=0;j<4;j++)in[i+j*n]=(uint32_t)(x>>(31*j))&0x7fffffffu;
        }
        fndsa_ds_from_big(4,&w,in,len,sc);oracle_big_to_fixed(4,out,in,len,sc);
        for(size_t i=0;i<n;i++) {
            double got=i<hn?(double)w.re[0][i]+w.re[1][i]
                :(double)w.im[0][i-hn]+w.im[1][i-hn];
            double want=(double)(int32_t)(out[i].v>>32)+(double)(uint32_t)out[i].v*0x1p-32;
            bad+=got!=want;count++;
        }
    }
    unsigned long long rb=0,rc=0;
    for(int k=-2048;k<=2048;k++) for(int j=-4;j<=4;j++) {
        double v=(double)k+0.5+(double)j*0x1p-34;
        float hi=(float)v,lo=(float)(v-(double)hi);
        for(unsigned p=0;p<2;p++) for(unsigned i=0;i<8;i++) {
            float (*q)[512]=p?w.im:w.re;q[0][i]=hi;q[1][i]=lo;
        }
        int ok=fndsa_ds_to_k(4,ko,&w);
        int32_t want=(int32_t)floor(v+0.5+0x1p-33);
        rb+=!ok;for(unsigned i=0;i<16;i++){rb+=ko[i]!=want;rc++;}
    }
    /* Invalid values must be rejected without UB/sanitizer errors. */
    float invalid[]={INFINITY,-INFINITY,NAN,0x1p31f,-0x1p31f};
    unsigned rejected=0;
    for(unsigned j=0;j<5;j++) {
        memset(&w,0,sizeof w);w.re[0][0]=invalid[j];
        rejected+=!fndsa_ds_to_k(4,ko,&w);
    }
    printf("C_HOST_ADAPTER input_count=%llu differences=%llu round_count=%llu differences=%llu invalid_rejected=%u/5\n",
        count,bad,rc,rb,rejected);
    return bad||rb||rejected!=5;
}
