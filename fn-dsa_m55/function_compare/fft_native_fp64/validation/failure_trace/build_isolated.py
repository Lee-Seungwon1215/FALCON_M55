#!/usr/bin/env python3
import json,subprocess,sys
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2];OUT=Path(sys.argv[1]).resolve();source=ROOT/'q32_trial'
names='codec mq sha3 sysrng util kgen kgen_fxp kgen_gauss kgen_mp31 kgen_ntru kgen_poly kgen_zint31 sign sign_core sign_fpoly sign_fpr sign_sampler vrfy'.split()
cmd=['clang','-O3','-ffp-contract=off','-fno-fast-math','-fno-strict-aliasing','-DFNDSA_AVX2=0',
     '-I'+str(source),'-I'+str(ROOT/'validation/generated'),*[str(source/(n+'.c')) for n in names],
     str(ROOT/'validation/first_failure.c'),'-lm','-o',str(OUT/'first-failure-host')]
subprocess.run(cmd,check=True)
raw=subprocess.check_output([str(OUT/'first-failure-host')],text=True)
assert 'FIRST_FAILURE_DONE cases=5 errors=0' in raw
for r in json.loads((OUT/'numerical-summary.json').read_text()):
    t=r['first_primitive'];op={'sqr':0,'add':1,'scale':2,'div':3}[t['operation']]
    assert f"FIRST_PRIMITIVE case={r['case']} op={op} fixed={t['fixed']} trial={t['trial']}" in raw
(ROOT/'build/host-first-failure.log').write_text(raw)
(OUT/'first-failure-host.log').write_text(raw)
print(raw)
