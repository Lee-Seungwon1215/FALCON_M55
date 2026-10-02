#!/usr/bin/env python3
import hashlib,json,subprocess,sys
from pathlib import Path
ROOT=Path(__file__).resolve().parent.parent
backend=sys.argv[1]; kind=sys.argv[2]
assert backend in ('reference','native','q32_trial') and kind in ('stages','kat','extended')
source=ROOT/backend;out=ROOT/'build'/('host-'+backend+'-'+kind);out.mkdir(parents=True,exist_ok=True)
names='codec mq sha3 sysrng util kgen kgen_fxp kgen_gauss kgen_mp31 kgen_ntru kgen_poly kgen_zint31 sign sign_core sign_fpoly sign_fpr sign_sampler vrfy'.split()
flags=['-O3','-ffp-contract=off','-fno-fast-math','-fno-strict-aliasing','-DFNDSA_AVX2=0']
cmd=['clang',*flags,'-I'+str(source),'-I'+str(ROOT/'validation/generated'),
     *[str(source/(n+'.c')) for n in names],str(ROOT/'validation'/dict(stages='stages.c',kat='host_kat.c',extended='extended_keys.c')[kind]),'-lm','-o',str(out/'audit')]
subprocess.run(cmd,check=True)
with (out/'raw.log').open('w') as f:r=subprocess.run([str(out/'audit')],stdout=f,stderr=subprocess.STDOUT)
data=dict(backend=backend,kind=kind,returncode=r.returncode,command=cmd,
          source={p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in source.glob('*.[chs]')})
(out/'manifest.json').write_text(json.dumps(data,indent=2)+'\n')
print('HOST_COMPLETE',backend,kind,'exit',r.returncode,'log',out/'raw.log',flush=True)
if kind in ('stages','extended'):assert r.returncode==0
else:assert 'KEY_KAT_SUMMARY count=300' in (out/'raw.log').read_text()
