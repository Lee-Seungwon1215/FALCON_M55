#!/usr/bin/env python3
"""Materialize independent, minimal M55_ref-based experimental source trees.

No source directory outside this experiment is modified. An existing tree
must match the expected bytes; rerunning never silently overwrites edits.
"""
import hashlib
import json
from pathlib import Path
import re

HERE = Path(__file__).resolve().parent
M55 = HERE.parents[1]
REF = M55/'M55_ref'
DONOR = M55/'FFT/6_sign_fft'
VARIANTS = ('ref','ntt_only','fft_only','ntt_fft')
names = ('fpoly_FFT','fpoly_iFFT','fpoly_LDL_fft','fpoly_split_fft','fpoly_merge_fft')

def sha(data): return hashlib.sha256(data).hexdigest()

def stripped(text):
    for name in names:
        pattern = r'/\* see sign_inner.h \*/\nTARGET_SSE2 TARGET_NEON\nvoid\n'+name+r'\([^;{}]*\)\n\{'
        m = re.search(pattern,text)
        if m:
            depth=1;end=m.end()
            while depth:
                depth += (text[end]=='{')-(text[end]=='}');end+=1
            text=text[:m.start()]+text[end:]
    text=re.sub(r'/\* fpoly_[^\n]*implemented in sign_[^\n]*\*/','',text)
    text=re.sub(r'\bGM\b','fndsa_sign_gm',text)
    text=text.replace('static const fpr fndsa_sign_gm[] =',
        'const fpr fndsa_sign_gm[] __attribute__((aligned(8))) =')
    return re.sub(r'\s+',' ',text).strip()

def write_checked(path,data):
    if isinstance(data,str):data=data.encode()
    if path.exists():assert path.read_bytes()==data, ('existing file differs; preserve and inspect',path)
    else:
        path.parent.mkdir(parents=True,exist_ok=True)
        path.write_bytes(data)

base={p.name:p.read_bytes() for p in REF.iterdir() if p.suffix in ('.c','.h','.s') or p.name=='LICENSE'}
donor_names=('mq.c','mq_cm55.s','kgen_mp31.c','kgen_mp31_cm55.s',
    'sign_fpoly.c','sign_fft_cm55.s','sign_ldl_cm55.s','sign_split_merge_cm55.s')
donor={n:(DONOR/n).read_bytes() for n in donor_names}
assert stripped(base['sign_fpoly.c'].decode())==stripped(donor['sign_fpoly.c'].decode()), 'non-target signing changes'
inner=base['inner.h'].decode()
for name in ('FNDSA_ASM_CORTEXM4','FNDSA_ASM_CORTEXM55'):
    old='#define '+name+'   0'
    assert inner.count(old)==1
    inner=inner.replace(old,'#define '+name+'   1')
common=dict(base,**{'inner.h':inner.encode()})
manifest={'reference':str(REF),'donor':str(DONOR),
    'original_sha256':{str(REF/n):sha(data) for n,data in base.items()},
    'donor_sha256':{str(DONOR/n):sha(data) for n,data in donor.items()},
    'common_change':'M4 scalar ASM and M55 compatibility defaults set to 1 in inner.h; no algorithm change',
    'fft_change':'Only five function bodies and shared GM symbol visibility; remaining sign_fpoly text identical',
    'ntt_change':'Adopted pre-SLOTHY q NTT + K4C RNS, including full inverse-root contract',
    'variants':{}}
c_names='codec mq sha3 sysrng util kgen kgen_fxp kgen_gauss kgen_mp31 kgen_ntru kgen_poly kgen_zint31 sign sign_core sign_fpoly sign_fpr sign_sampler vrfy'.split()
for variant in VARIANTS:
    data=dict(common)
    if variant in ('ntt_only','ntt_fft'):
        del data['mq_cm4.s']
        for n in donor_names[:4]:data[n]=donor[n]
        # Fixed implementation in this file, not a downstream build option.
        data['kgen_mp31.c']=b'#define FNDSA_MVE_MP31 1\n'+data['kgen_mp31.c']
    if variant in ('fft_only','ntt_fft'):
        for n in donor_names[4:]:data[n]=donor[n]
    # No keygen FFT, sampler or other optimization may enter these trees.
    for n in ('kgen_fxp.c','kgen_ntru.c','kgen_poly.c','kgen_inner.h',
              'sign_core.c','sign_sampler.c','sign_fpr.c','sign_fpr_cm4.s'):
        assert data[n]==base[n], n
    s_names=sorted(n for n in data if n.endswith('.s'))
    make='''# Independent fixed implementation. No foreign crypto sources.
CROSS_COMPILE ?= arm-none-eabi-
CC = $(CROSS_COMPILE)gcc
AR = $(CROSS_COMPILE)ar
CFLAGS = -O3 -mcpu=cortex-m55 -mthumb -mfpu=fpv5-d16 -mfloat-abi=hard -ffp-contract=off -fno-fast-math -fno-strict-aliasing -ffunction-sections -fdata-sections
'''
    make+='C_SOURCES = '+' '.join(n+'.c' for n in c_names)+'\n'
    make+='S_SOURCES = '+' '.join(s_names)+'\n'
    make+='''OBJECTS = $(C_SOURCES:%.c=build/%.o) $(S_SOURCES:%.s=build/%.o)
all: build/libfndsa.a
build:
	mkdir -p build
build/%.o: %.c | build
	$(CC) $(CFLAGS) -MMD -MP -c $< -o $@
build/%.o: %.s | build
	$(CC) $(CFLAGS) -c $< -o $@
build/libfndsa.a: $(OBJECTS)
	$(AR) rcs $@ $(OBJECTS)
-include $(OBJECTS:.o=.d)
'''
    data['Makefile']=make.encode()
    for n,content in data.items():write_checked(HERE/'variants'/variant/n,content)
    manifest['variants'][variant]={'sha256':{n:sha(v) for n,v in data.items()},
        'changed_from_ref':[n for n in sorted(data) if base.get(n)!=data[n]],
        'c_sources':[n+'.c' for n in c_names], 's_sources':s_names}
write_checked(HERE/'source_manifest.json',json.dumps(manifest,indent=2)+'\n')
print('Prepared and verified four independent source trees; all external sources unchanged.')
