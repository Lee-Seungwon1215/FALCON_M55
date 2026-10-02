#!/usr/bin/env python3
"""Disposable scope probes; leave all production directories untouched."""
import hashlib,json,re,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent
src,out=map(Path,sys.argv[1:3]);out.mkdir(parents=True,exist_ok=True)
cats=['kg_ntru_rest','kg_ortho_rest','kg_fft_fixed','kg_ifft_fixed',
 'kg_fft_ntru','kg_ifft_ntru','kg_fft_fp64','kg_ifft_fp64','kg_invnorm',
 'kg_mul','kg_recip','kg_div','kg_fft_misc','kg_input',
 'sg_fft','sg_ifft','sg_ldl','sg_split','sg_merge','sg_split_selfadj',
 'sg_mul','sg_add','sg_sub','sg_gram','sg_basis','sg_deepest','sg_sampler']
mapping={
 'kgen_ntru.c':{'solve_NTRU':'kg_ntru_rest','check_ortho_norm':'kg_ortho_rest'},
 'kgen_poly.c':{'poly_big_to_fixed':'kg_input'},
 'kgen_fxp.c':{'vect_FFT':'kg_fft_fixed','vect_iFFT':'kg_ifft_fixed',
  'vect_FFT_ntru':'kg_fft_ntru','vect_iFFT_ntru':'kg_ifft_ntru',
  'vect_FFT_fp64':'kg_fft_fp64','vect_iFFT_fp64':'kg_ifft_fp64',
  'vect_invnorm_fft':'kg_invnorm','vect_mul_fft':'kg_mul','vect_inv_mul2e_fft':'kg_recip',
  'vect_div_selfadj_fft':'kg_div','vect_div_selfadj_fft_fp64':'kg_div',
  'vect_adj_fft':'kg_fft_misc','vect_mul_selfadj_fft':'kg_fft_misc','vect_mul_realconst':'kg_fft_misc',
  'vect_set':'kg_input'},
 'sign_fpoly.c':{'fpoly_split_selfadj_fft':'sg_split_selfadj','fpoly_mul_fft':'sg_mul',
  'fpoly_add':'sg_add','fpoly_sub':'sg_sub','fpoly_gram_fft':'sg_gram','fpoly_apply_basis':'sg_basis'},
 'sign_sampler.c':{'ffsamp_fft_deepest':'sg_deepest','sampler_next':'sg_sampler'},
 'sign.c':{},'sign_core.c':{}}
asmfuncs=[('fpoly_FFT','sg_fft','unsigned logn, fpr *f','logn, f'),
 ('fpoly_iFFT','sg_ifft','unsigned logn, fpr *f','logn, f'),
 ('fpoly_LDL_fft','sg_ldl','unsigned logn, const fpr *g00, fpr *g01, fpr *g11','logn, g00, g01, g11'),
 ('fpoly_split_fft','sg_split','unsigned logn, fpr *f0, fpr *f1, const fpr *f','logn, f0, f1, f'),
 ('fpoly_merge_fft','sg_merge','unsigned logn, fpr *f, const fpr *f0, const fpr *f1','logn, f, f0, f1')]
manifest={'original':{},'generated':{},'insertions':{},'categories':cats}
def save(name,text):
 (out/name).write_text(text)
 manifest['generated'][name]=hashlib.sha256(text.encode()).hexdigest()
def add(text,name,cat):
 pattern=r'\n'+name+r'\([^;{}]*\)\n\{'
 inserted='\n/* MID_PROBE */ MC_SCOPE('+str(cats.index(cat))+'); /* MID_END */'
 changed,count=re.subn(pattern,lambda m:m[0]+inserted,text)
 assert count>=1,(name,count)
 manifest['insertions'][name]=count
 strip=lambda t:re.sub(r'\n/\* MID_PROBE \*/.*?/\* MID_END \*/','',t)
 assert strip(changed)==strip(text)
 return changed
for name,funcs in mapping.items():
 original=(src/name).read_text();text=original
 for func,cat in funcs.items():text=add(text,func,cat)
 if name.startswith('sign'):
  for func,*_ in asmfuncs:text=re.sub(r'\b'+func+r'\b','probe_'+func,text)
 text='#include "probe.h"\n'+('#include "sign_probes.h"\n' if name.startswith('sign') else '')+text
 save(name,text);manifest['original'][name]=hashlib.sha256(original.encode()).hexdigest()
text=(src/'sign_sampler_cm4.s').read_text()
for func,*_ in asmfuncs:text=re.sub(r'\bfndsa_'+func+r'\b','probe_'+func,text)
save('sign_sampler_cm4.s',text)
manifest['original']['sign_sampler_cm4.s']=hashlib.sha256((src/'sign_sampler_cm4.s').read_bytes()).hexdigest()
save('benchmark.c',(HERE/'benchmark.c').read_text())
save('sign_probes.h','#include "sign_inner.h"\n'+''.join('void probe_'+f+'('+args+');\n' for f,cat,args,call in asmfuncs))
save('sign_probes.c','#include "probe.h"\n#include "sign_probes.h"\n'+''.join(
 '__attribute__((noinline)) void probe_'+f+'('+args+') { MC_SCOPE('+str(cats.index(cat))+'); '+f+'('+call+'); }\n'
 for f,cat,args,call in asmfuncs))
save('probe.h','''#ifndef MIDCHECK_PROBE_H
#define MIDCHECK_PROBE_H
#include <stdint.h>
void probe_start(unsigned logn, unsigned op);
void probe_stop(uint64_t elapsed);
int probe_report(void);
unsigned probe_enter(unsigned cat);
void probe_leave(unsigned *active);
#define MC_SCOPE(cat) unsigned mid_scope __attribute__((cleanup(probe_leave))) = probe_enter(cat)
#endif
''')
save('probe.c','''#include "probe.h"
#include <cmsis_core.h>
#include <stdio.h>
enum { N_CAT = '''+str(len(cats))+''' };
static const char *names[N_CAT] = {'''+','.join('"'+c+'"' for c in cats)+'''};
typedef struct { uint64_t excl, incl; uint32_t calls; } stat;
static stat stats[2][3][N_CAT];
static uint64_t totals[2][3];
static uint32_t runs[2][3];
static struct { uint32_t start, child, cat; } frames[32];
static unsigned active, depth, di, operation, errors;
void probe_start(unsigned logn, unsigned op) {
    if (active || depth || logn<9 || logn>10 || op>2) errors++;
    di=logn-9; operation=op; active=1;
}
void probe_stop(uint64_t elapsed) {
    if (!active || depth || elapsed > 0xffffffffu) errors++;
    totals[di][operation]+=elapsed; runs[di][operation]++; active=0;
}
unsigned probe_enter(unsigned cat) {
    if (!active) return 0;
    if (depth>=32 || cat>=N_CAT) { errors++; return 0; }
    frames[depth].cat=cat; frames[depth].child=0;
    frames[depth].start=DWT->CYCCNT; depth++; return 1;
}
void probe_leave(unsigned *enabled) {
    uint32_t end=DWT->CYCCNT;
    if (!*enabled) return;
    if (!depth) { errors++; return; }
    depth--;
    uint32_t elapsed=end-frames[depth].start;
    if (frames[depth].child>elapsed) { errors++; return; }
    stat *s=&stats[di][operation][frames[depth].cat];
    s->excl+=elapsed-frames[depth].child; s->incl+=elapsed; s->calls++;
    if (depth) frames[depth-1].child+=elapsed;
}
int probe_report(void) {
    const char *ops[]={"keygen","sign","verify"};
    for (unsigned d=0;d<2;d++) for (unsigned o=0;o<3;o++) {
        uint64_t sum=0;
        for (unsigned c=0;c<N_CAT;c++) {
            stat *s=&stats[d][o][c];sum+=s->excl;
            if (s->calls) printf("MC_PROFILE op=%s degree=%u category=%s calls=%u exclusive=%llu inclusive=%llu\\n",
                ops[o],512u<<d,names[c],s->calls,(unsigned long long)s->excl,(unsigned long long)s->incl);
        }
        if(sum>totals[d][o] || runs[d][o]!=10) errors++;
        printf("MC_PROFILE_TOTAL op=%s degree=%u calls=%u cycles=%llu classified=%llu remainder=%llu\\n",
            ops[o],512u<<d,runs[d][o],(unsigned long long)totals[d][o],(unsigned long long)sum,
            (unsigned long long)(totals[d][o]-sum));
    }
    printf("MC_PROFILE_DONE errors=%u depth=%u\\n",errors,depth);
    return errors || depth;
}
''')
(out/'instrument_manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
