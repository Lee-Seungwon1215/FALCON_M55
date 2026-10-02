#!/usr/bin/env python3
"""Freeze three independent source trees and derive a ten-input driver."""
import hashlib,json
from pathlib import Path

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[2]
PREV=HERE.parent/'sign_fft_fourway'
SOURCES={'ref':PREV/'variants/ref','ntt':PREV/'variants/ntt_only',
         'full':ROOT/'Final_code/Before_slothy'}
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def write(p,data):
    if isinstance(data,str):data=data.encode()
    if p.exists():assert p.read_bytes()==data,('preserve existing file',p)
    else:p.parent.mkdir(parents=True,exist_ok=True);p.write_bytes(data)
manifest={'variants':{},'upstream_manifest_sha256':sha(PREV/'source_manifest.json')}
for variant,source in SOURCES.items():
    hashes={}
    for p in sorted(source.iterdir()):
        if p.suffix in ('.c','.h','.s') or p.name=='LICENSE':
            write(HERE/'variants'/variant/p.name,p.read_bytes())
            hashes[p.name]=sha(p)
    manifest['variants'][variant]={'source':str(source),'sha256':hashes}
write(HERE/'source_manifest.json',json.dumps(manifest,indent=2)+'\n')

s=(PREV/'keyverify_perf.c').read_text()
s=s.replace('#include "inner.h"','#include "inner.h"\n#include "probe.h"\n#include <string.h>')
s=s.replace('samples[100]','samples[10]').replace('i < 100','i < 10')
s=s.replace('calls=100','calls=10').replace('samples[49]','samples[4]').replace('samples[50]','samples[5]').replace('samples[99]','samples[9]')
s=s.replace('static uint64_t samples[10];','static uint64_t samples[10], sign_samples[10];')
s=s.replace('uint64_t start = k_cycle_get_64();','probe_start(logn, 0);\n            uint64_t start = k_cycle_get_64();')
s=s.replace('uint64_t elapsed = k_cycle_get_64() - start;','uint64_t elapsed = k_cycle_get_64() - start;\n            probe_stop(elapsed);')
s=s.replace('total = 0;\n        for (unsigned i = 0; i < 10; i ++) {',
'''total = 0;
        uint64_t sign_total = 0;
        for (unsigned i = 0; i < 10; i ++) {''')
s=s.replace('            if (!sign_one(logn, sg)) return 6;', '''            uint32_t sign_mask = __get_PRIMASK();
            __disable_irq();
            probe_start(logn, 1);
            __DSB(); __ISB();
            uint32_t sign_start = DWT->CYCCNT;
            int sign_ok = sign_one(logn, sg);
            __DSB(); __ISB();
            uint32_t sign_elapsed = DWT->CYCCNT - sign_start;
            probe_stop(sign_elapsed);
            __set_PRIMASK(sign_mask);
            if (!sign_ok) return 6;
            sign_samples[i] = sign_elapsed;
            sign_total += sign_elapsed;
            printf("KV_SAMPLE op=sign degree=%u index=%u cycles=%u\\n", 1u << logn, i, sign_elapsed);''')
s=s.replace('            uint32_t start = DWT->CYCCNT;',
    '            probe_start(logn, 2);\n            uint32_t start = DWT->CYCCNT;')
s=s.replace('            __set_PRIMASK(mask);',
    '            probe_stop(elapsed);\n            __set_PRIMASK(mask);')
s=s.replace('        print_digest("verify", logn, &hc);',
'''        print_digest("verify", logn, &hc);
        memcpy(samples, sign_samples, sizeof samples);
        summary("sign", logn, sign_total);''')
s=s.replace('    printf("KEYVERIFY_DONE', '    if (probe_report()) return 12;\n    printf("KEYVERIFY_DONE')
s=s.replace('KEYVERIFY_DONE','MIDCHECK_DONE').replace('KV_','MC_')
s=s.replace('Four unchanged crypto source trees','Three frozen crypto source trees')
write(HERE/'benchmark.c',s)
write(HERE/'probe.h','''#ifndef MIDCHECK_PROBE_H
#define MIDCHECK_PROBE_H
#define probe_start(logn,op) ((void)0)
#define probe_stop(elapsed) ((void)0)
#define probe_report() 0
#endif
''')
print('Frozen M55_ref, pre-SLOTHY NTT, and exact current Before_slothy sources.')
