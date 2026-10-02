#!/usr/bin/env python3
"""New boundary counterexample and nonoverlapping additional key inputs."""
import ctypes as C
from datetime import datetime,timezone
import hashlib,json,subprocess
from pathlib import Path
ROOT=Path(__file__).resolve().parent.parent
OUT=ROOT/'results/followup-host'/datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ')
OUT.mkdir(parents=True)
FLAGS=['-O3','-ffp-contract=off','-fno-fast-math','-fno-strict-aliasing','-DFNDSA_AVX2=0']
NAMES='codec mq sha3 sysrng util kgen kgen_fxp kgen_gauss kgen_mp31 kgen_ntru kgen_poly kgen_zint31 sign sign_core sign_fpoly sign_fpr sign_sampler vrfy'.split()
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
source=ROOT/'q32_trial'
subprocess.run(['clang',*FLAGS,'-I'+str(source),'-dynamiclib',str(ROOT/'validation/followup_probe.c'),'-o',str(OUT/'probe.dylib')],check=True)
lib=C.CDLL(str(OUT/'probe.dylib'))
lib.audit_counterexample.argtypes=[C.c_uint64,C.c_uint64,C.POINTER(C.c_uint64),C.POINTER(C.c_double),C.POINTER(C.c_int32)]
a,b=(1<<32)+1,(1<<32)-1
q=C.c_uint64();d=C.c_double();k=(C.c_int32*2)()
lib.audit_counterexample(a,b,C.byref(q),C.byref(d),k)
example=dict(a_raw=a,b_raw=b,exact_input_a='1+2^-32',exact_input_b='1-2^-32',
             exact_product='1-2^-64',fixed_product_raw=q.value,fixed_product=q.value*2**-32,
             trial_product=d.value,after_subtract_half_fixed_k=k[0],after_subtract_half_trial_k=k[1])
(OUT/'counterexample.json').write_text(json.dumps(example,indent=2)+'\n')
print('COUNTEREXAMPLE',example,flush=True)
assert q.value==(1<<32)-1 and d.value==1.0 and list(k)==[0,1]
manifest={}
for label in ('reference','q32_trial'):
    source=ROOT/label
    cmd=['clang',*FLAGS,'-I'+str(source),*[str(source/(n+'.c')) for n in NAMES],
         str(ROOT/'validation/extended_keys.c'),'-lm','-o',str(OUT/label)]
    subprocess.run(cmd,check=True)
    print('EXTENDED_START',label,'count=20000 start=1000',OUT,flush=True)
    with (OUT/(label+'.log')).open('w') as f:
        result=subprocess.run([str(OUT/label),'10000','1000'],stdout=f,stderr=subprocess.STDOUT)
    manifest[label]=dict(returncode=result.returncode,command=cmd,
                        source={p.name:sha(p) for p in source.glob('*.[chs]')})
    (OUT/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
    assert result.returncode==0
    print('EXTENDED_DONE',label,flush=True)
import re
maps=[]
for label in ('reference','q32_trial'):
    t=(OUT/(label+'.log')).read_text();assert 'EXTRA_DONE count=20000' in t
    maps.append({(int(a),int(b)):v for a,b,v in re.findall(r'EXTRA_KEY degree=(\d+) index=(\d+) digest=(\w+)',t)})
assert len(maps[0])==len(maps[1])==20000
diff=[dict(degree=k[0],index=k[1],reference=maps[0][k],candidate=maps[1][k]) for k in maps[0] if maps[0][k]!=maps[1][k]]
summary=dict(count=20000,seed_range=[1000,10999],mismatches=diff,counterexample=example)
(OUT/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
print('FOLLOWUP_HOST_DONE mismatches',len(diff),'output',OUT,flush=True)
