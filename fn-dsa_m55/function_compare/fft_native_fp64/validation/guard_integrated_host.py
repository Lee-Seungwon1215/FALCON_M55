#!/usr/bin/env python3
"""Acceptance tests of the directly patched q32_trial, without source swaps."""
import ctypes as C,hashlib,json,random,re,subprocess
from datetime import datetime,timezone
from pathlib import Path
ROOT=Path(__file__).resolve().parent.parent;SOURCE=ROOT/'q32_trial'
OUT=ROOT/'results/guard-integrated-host'/datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ')
OUT.mkdir(parents=True,exist_ok=False)
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
sources={str(p):sha(p) for p in SOURCE.glob('*.[chs]')}
before=json.loads((ROOT/'results/failure-trace/20260923T064147Z/manifest.json').read_text())
changed=[p for p,h in before['q32_trial']['source'].items() if sources[p]!=h]
assert changed==[str(SOURCE/'kgen_inner.h')],changed
assert all(sha(Path(p))==h for p,h in before['reference']['source'].items())
FLAGS=['-O3','-ffp-contract=off','-fno-fast-math','-fno-strict-aliasing','-DFNDSA_AVX2=0']
NAMES='codec mq sha3 sysrng util kgen kgen_fxp kgen_gauss kgen_mp31 kgen_ntru kgen_poly kgen_zint31 sign sign_core sign_fpoly sign_fpr sign_sampler vrfy'.split()
probe=['clang',*FLAGS,'-I'+str(SOURCE),str(ROOT/'validation/guard_integrated_probe.c'),
       str(ROOT/'validation/failure_trace/guard_wide.c'),'-dynamiclib','-o',str(OUT/'guard.dylib')]
subprocess.run(probe,check=True)
lib=C.CDLL(str(OUT/'guard.dylib'))
for name in ('integrated_guard','diag_l1wide_guard'):
    getattr(lib,name).argtypes=[C.c_uint,C.POINTER(C.c_int32)];getattr(lib,name).restype=C.c_uint32
rng=random.Random(20260923);count=0;bound=(1<<32)-2
def check(l,k):
    global count
    a=(C.c_int32*len(k))(*k);expected=int(l>3 or sum(map(abs,k))<=bound)
    assert lib.integrated_guard(l,a)==lib.diag_l1wide_guard(l,a)==expected,(l,k,expected)
    count+=1
for l in range(1,11):
    n=1<<l
    special=[[],[2147483647,2147483647],[-2147483648,2147483647],[-2147483648,-2147483648],
             [-2147483648],[2147483647],[-2147483648,2147483646],
             [268435456,-268435456],[536870912,-536870912]]
    for a in special:check(l,a+[0]*(n-len(a)))
    for x in (0,1,-1,2147483647,-2147483648):check(l,[x]*n)
    for _ in range(10000 if l<=3 else 100):check(l,[rng.randint(-(1<<31),(1<<31)-1) for _ in range(n)])
for row in json.loads((ROOT/'results/failure-trace/20260923T064147Z/guard-proof-cases.json').read_text()):
    check(row['logn'],row['k']);assert lib.integrated_guard(row['logn'],(C.c_int32*len(row['k']))(*row['k']))==1
summary=dict(scope='actual q32_trial sources, no generated crypto translation units',source=sources,changed_sources=changed,
             guard_cases=count,guard_boundary_and_diagnostic_comparison='PASS',commands=[probe])
(OUT/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
print('HOST_START',OUT,'guard_cases',count,flush=True)
common=['clang',*FLAGS,'-I'+str(SOURCE),*[str(SOURCE/(n+'.c')) for n in NAMES]]
for kind,file in [('kat','host_kat.c'),('extended','extended_keys.c')]:
    cmd=[*common,str(ROOT/'validation'/file),'-lm','-o',str(OUT/kind)]
    subprocess.run(cmd,check=True);summary['commands'].append(cmd)
    with (OUT/(kind+'.log')).open('w') as f:
        r=subprocess.run([str(OUT/kind),*(['10000','1000'] if kind=='extended' else [])],stdout=f,stderr=subprocess.STDOUT)
    assert r.returncode==0,(kind,r.returncode)
    raw=(OUT/(kind+'.log')).read_text()
    if kind=='kat':
        assert 'KEY_KAT_SUMMARY count=300 mismatches=0' in raw and 'Test KAT:' in raw and raw.rstrip().endswith('done.')
        summary['kat']=dict(count=300,mismatches=0,full_signature_kat='PASS',verify_self='PASS')
    else:
        parse=lambda t:{(int(a),int(b)):h for a,b,h in re.findall(r'EXTRA_KEY degree=(\d+) index=(\d+) digest=(\w+)',t)}
        base=parse((ROOT/'results/followup-host/20260923T060455Z/reference.log').read_text());got=parse(raw)
        assert len(base)==len(got)==20000 and 'EXTRA_DONE count=20000 equation_and_range=PASS' in raw
        diff=[list(k) for k in base if base[k]!=got[k]]
        summary['extended']=dict(count=20000,mismatches=diff,seed_index_range=[1000,10999])
        assert not diff,diff
    summary[kind+'_log_sha256']=sha(OUT/(kind+'.log'))
    (OUT/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
    print('HOST_DONE',kind,flush=True)
assert all(sha(Path(p))==h for p,h in sources.items())
print('GUARD_INTEGRATED_HOST_COMPLETE',OUT,flush=True)
