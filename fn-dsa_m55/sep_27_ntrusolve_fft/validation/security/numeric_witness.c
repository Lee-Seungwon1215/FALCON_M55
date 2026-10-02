/* Reproduce a real-sampler intermediate mismatch; it is not a failed KAT. */
#include "kgen_inner.h"
#include <stdio.h>
static fxr a[512],b[512],old[256],now[256];
static int8_t f[512],g[512];
int main(void)
{
    unsigned char seed[32]="A17-security-audit-independent";
    seed[30]=9;seed[31]=0;
    shake_context sc;shake_init(&sc,256);shake_inject(&sc,seed,sizeof seed);shake_flip(&sc);
    unsigned found=0;
    for(unsigned t=0;t<4096;t++) {
        sample_f(9,&sc,f);sample_f(9,&sc,g);
        vect_set(9,a,f);vect_set(9,b,g);vect_FFT_fixed(9,a);vect_FFT_fixed(9,b);
        vect_invnorm_fft_fixed(9,old,a,b,0);vect_invnorm_fft(9,now,a,b,0);
        for(unsigned i=0;i<256;i++)if(now[i].v!=old[i].v) {
            fxr z=fxr_add(fxr_add(fxr_sqr(a[i]),fxr_sqr(a[i+256])),
                fxr_add(fxr_sqr(b[i]),fxr_sqr(b[i+256])));
            printf("SEC_WITNESS sample=%u index=%u ar=%016llx ai=%016llx br=%016llx bi=%016llx old=%016llx now=%016llx fixed_den=%016llx\n",
                t,i,(unsigned long long)a[i].v,(unsigned long long)a[i+256].v,
                (unsigned long long)b[i].v,(unsigned long long)b[i+256].v,
                (unsigned long long)old[i].v,(unsigned long long)now[i].v,(unsigned long long)z.v);
            found++;
        }
    }
    printf("SEC_WITNESS_DONE count=%u\n",found);
    return 0;
}
