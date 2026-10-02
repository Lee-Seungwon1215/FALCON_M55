#!/usr/bin/env python3
"""Causal experiment with a proved sufficient int64 bound; no production edit."""
import hashlib,json,subprocess,sys,re
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2];HERE=Path(__file__).resolve().parent
OUT=Path(sys.argv[1]).resolve();DEST=OUT/'wide-guard';DEST.mkdir(exist_ok=True)
source=ROOT/'q32_trial';sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
original={str(p):sha(p) for p in source.glob('*.[chs]')}
names='codec mq sha3 sysrng util kgen kgen_fxp kgen_gauss kgen_mp31 kgen_poly kgen_zint31 sign sign_core sign_fpoly sign_fpr sign_sampler vrfy'.split()
FLAGS=['-O3','-ffp-contract=off','-fno-fast-math','-fno-strict-aliasing','-DFNDSA_AVX2=0']
text=(source/'kgen_ntru.c').read_text();old='round_ok &= fp64_k_update_ok(logn, k);';assert text.count(old)==1
text='#include "kgen_inner.h"\nextern uint32_t diag_l1wide_guard(unsigned,const int32_t*);\n'+text.replace(old,'round_ok &= diag_l1wide_guard(logn, k);')
path=DEST/'ntru.c';path.write_text(text)
common=['clang',*FLAGS,'-I'+str(source),'-I'+str(ROOT/'validation/generated'),
        *[str(source/(n+'.c')) for n in names],str(path),str(HERE/'guard_wide.c')]
results={}
for kind,harness in [('extended','extended_keys.c'),('kat','host_kat.c')]:
    cmd=[*common,str(ROOT/'validation'/harness),'-lm','-o',str(DEST/kind)]
    subprocess.run(cmd,check=True);print('WIDE_START',kind,flush=True)
    with (DEST/(kind+'.log')).open('w') as f:
        r=subprocess.run([str(DEST/kind),*(['10000','1000'] if kind=='extended' else [])],stdout=f,stderr=subprocess.STDOUT)
    results[kind]=dict(returncode=r.returncode,command=cmd,log_sha256=sha(DEST/(kind+'.log')))
    assert r.returncode==0,kind
    if kind=='extended':
        load=lambda p:{(int(a),int(b)):v for a,b,v in re.findall(r'EXTRA_KEY degree=(\d+) index=(\d+) digest=(\w+)',p.read_text())}
        base=load(ROOT/'results/followup-host/20260923T060455Z/reference.log');trial=load(DEST/'extended.log')
        assert len(base)==len(trial)==20000
        results[kind]['mismatches']=[dict(degree=k[0],index=k[1]) for k in base if base[k]!=trial[k]]
        print('WIDE_EXTENDED_DONE',len(results[kind]['mismatches']),'mismatches',flush=True)
    else:assert 'KEY_KAT_SUMMARY count=300 mismatches=0' in (DEST/'kat.log').read_text()
    (DEST/'summary.json').write_text(json.dumps(dict(scope='diagnostic only',checks=results,source=original,generated_sha256=sha(path)),indent=2)+'\n')
assert all(sha(Path(p))==h for p,h in original.items())
print('WIDE_DONE',DEST,flush=True)
