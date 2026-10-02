#!/usr/bin/env python3
"""Extra host UB check on the five indices (both degrees, ten keys total)."""
import hashlib,json,subprocess,sys
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2];HERE=Path(__file__).resolve().parent
OUT=Path(sys.argv[1]).resolve()/'wide-guard';source=ROOT/'q32_trial'
names='codec mq sha3 sysrng util kgen kgen_fxp kgen_gauss kgen_mp31 kgen_poly kgen_zint31 sign sign_core sign_fpoly sign_fpr sign_sampler vrfy'.split()
cmd=['clang','-O2','-g','-ffp-contract=off','-fno-fast-math','-fno-strict-aliasing','-DFNDSA_AVX2=0',
     '-fsanitize=undefined','-fno-sanitize-recover=all','-I'+str(source),
     *[str(source/(n+'.c')) for n in names],str(OUT/'ntru.c'),str(HERE/'guard_wide.c'),
     str(ROOT/'validation/extended_keys.c'),'-lm','-o',str(OUT/'ubsan')]
subprocess.run(cmd,check=True)
rows=[]
for index in (1198,7470,1691,4395,10491):
    p=OUT/f'ubsan-{index}.log'
    with p.open('w') as f:r=subprocess.run([str(OUT/'ubsan'),'1',str(index)],stdout=f,stderr=subprocess.STDOUT)
    rows.append(dict(index=index,returncode=r.returncode,log_sha256=hashlib.sha256(p.read_bytes()).hexdigest()))
    print('UBSAN',index,'exit',r.returncode,flush=True)
(OUT/'ubsan-summary.json').write_text(json.dumps(dict(command=cmd,runs=rows,all_pass=all(x['returncode']==0 for x in rows)),indent=2)+'\n')
raise SystemExit(any(x['returncode'] for x in rows))
