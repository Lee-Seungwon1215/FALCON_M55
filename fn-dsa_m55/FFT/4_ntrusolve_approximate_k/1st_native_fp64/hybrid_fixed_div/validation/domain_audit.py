"""Observe only step-IV inverse divisions; generated instrumentation is not production."""
from pathlib import Path
import subprocess
ROOT = Path(__file__).resolve().parent
SRC = ROOT.parents[2] / 'ref'
OUT = ROOT / 'build/domain'
OUT.mkdir(parents=True, exist_ok=True)
text = (SRC/'kgen_fxp.c').read_text()
prefix = r'''
#include <stdio.h>
#include <stdlib.h>
static unsigned long long div_count, invalid_count, zero_count;
static uint64_t min_den = UINT64_MAX, max_qhi;
static uint64_t audit_div(uint64_t x, uint64_t y) {
    uint64_t a=(x ^ -(x>>63))+(x>>63), b=(y ^ -(y>>63))+(y>>63);
    ++div_count;
    zero_count += a==0;
    if (b < min_den) min_den=b;
    if (!b || a>>63 || b>>63 || (__uint128_t)a >= ((__uint128_t)b<<32)) {
        ++invalid_count;
        fprintf(stderr,"DOMAIN_INVALID x=%016llx y=%016llx\n",(unsigned long long)x,(unsigned long long)y);
    } else if (a/b > max_qhi) max_qhi=a/b;
    return inner_fxr_div(x,y);
}
static void report_div(void) {
    fprintf(stderr,"DOMAIN count=%llu invalid=%llu zero=%llu min_den=%llu max_qhi=%llu\n",
      div_count,invalid_count,zero_count,(unsigned long long)min_den,(unsigned long long)max_qhi);
}
__attribute__((constructor)) static void init_div(void) { atexit(report_div); }
'''
text=text.replace('#include "kgen_inner.h"','#include "kgen_inner.h"\n'+prefix,1)
for v in ('re','im'):
    old=f'fxr_div(fxr_mul2e({v}, e), z)'
    # Only the first occurrence is the portable API called on M55.
    text=text.replace(old,f'(fxr) {{ audit_div(fxr_mul2e({v}, e).v, z.v) }}',1)
(OUT/'kgen_fxp.c').write_text(text)
names='codec mq sha3 sysrng util kgen kgen_gauss kgen_mp31 kgen_ntru kgen_poly kgen_zint31 sign sign_core sign_fpoly sign_fpr sign_sampler vrfy'.split()
cmd=['clang','-O3','-DFNDSA_AVX2=0','-ffp-contract=off','-fno-fast-math','-fno-strict-aliasing','-I'+str(SRC)]
cmd += [str(SRC/(n+'.c')) for n in names]+[str(OUT/'kgen_fxp.c'),str(ROOT/'kat_audit.c'),'-lm','-o',str(OUT/'audit')]
subprocess.run(cmd,check=True)
with (OUT/'audit.log').open('w') as out:
    subprocess.run([str(OUT/'audit')],stdout=out,stderr=subprocess.STDOUT,check=True)
print('\n'.join(l for l in (OUT/'audit.log').read_text().splitlines() if 'DOMAIN' in l or 'SUMMARY' in l))
