#!/usr/bin/env python3
"""Separate the observed rejection cause from remaining numerical differences.

Only an instrumented/counterfactual NTRU translation unit under results/ is
generated. q32_trial and all integrated reference directories are untouched.
"""
import ctypes as C,hashlib,json,subprocess,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[1]
OUT=Path(sys.argv[1]).resolve();source=ROOT/'q32_trial'
FLAGS=['-O3','-ffp-contract=off','-fno-fast-math','-fno-strict-aliasing','-DFNDSA_AVX2=0']
NAMES='codec mq sha3 sysrng util kgen kgen_fxp kgen_gauss kgen_mp31 kgen_ntru kgen_poly kgen_zint31 sign sign_core sign_fpoly sign_fpr sign_sampler vrfy'.split()
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
original={str(p):sha(p) for p in source.glob('*.[chs]')}
common=['clang',*FLAGS,'-I'+str(source)]
subprocess.run([*common,*[str(source/(n+'.c')) for n in NAMES],str(HERE/'probes.c'),'-dynamiclib','-lm','-o',str(OUT/'probes.dylib')],check=True)
lib=C.CDLL(str(OUT/'probes.dylib'))
for name in ('diag_old_guard','diag_l1_guard'):
    getattr(lib,name).argtypes=[C.c_uint,C.POINTER(C.c_int32)];getattr(lib,name).restype=C.c_uint
rows=[]
for r in json.loads((OUT/'summary.json').read_text()):
    q=r['first_k_difference']['reference'];d=r['first_k_difference']['candidate'];l=q['logn'];k=q['k']
    assert k==d['k'] and q['valid']==1 and d['valid']==0
    a=(C.c_int32*len(k))(*k);old=lib.diag_old_guard(l,a);new=lib.diag_l1_guard(l,a)
    S=sum(map(abs,k));B=1<<31
    # For fs_j in [0,B-1], sum |k_j| = S, |carry| <= S+1:
    # all left-associative partial sums satisfy
    # |F + carry +/- fs*k ...| <= (B-1)+(S+1)+(B-1)*S = B*(S+1).
    # Therefore |next carry| <= S+1. Induct from carry=0.
    # S <= B-1 gives |any product/partial sum| <= B^2 = 2^62 < 2^63.
    bound=B*(S+1)
    assert S<=B-1 and bound<1<<63 and old==0 and new==1
    rows.append(dict(case=r['case'],logn=l,depth=q['depth'],iteration=q['iteration'],
                     k=k,max_abs_k=max(map(abs,k)),old_limit=(B-1)>>l,sum_abs_k=S,
                     all_limb_accumulator_abs_bound=bound,signed_int64_max=(1<<63)-1,
                     old_guard=old,diagnostic_l1_guard=new))
(OUT/'guard-proof-cases.json').write_text(json.dumps(rows,indent=2)+'\n')
# A diagnostic translation-unit substitution, not a seed exception.
text=(source/'kgen_ntru.c').read_text();old='round_ok &= fp64_k_update_ok(logn, k);'
assert text.count(old)==1
text='#include "kgen_inner.h"\nextern uint32_t diag_l1_guard(unsigned,const int32_t*);\n'+text.replace(old,'round_ok &= diag_l1_guard(logn, k);')
path=OUT/'counterfactual-l1-ntru.c';path.write_text(text)
cmd=[*common,*[str(source/(n+'.c')) for n in NAMES if n!='kgen_ntru'],str(path),str(HERE/'probes.c'),str(ROOT/'validation/extended_keys.c'),'-lm','-o',str(OUT/'counterfactual-l1')]
subprocess.run(cmd,check=True)
print('COUNTERFACTUAL_START 20000 keys; diagnostic copy only',OUT,flush=True)
with (OUT/'counterfactual-l1.log').open('w') as f:r=subprocess.run([str(OUT/'counterfactual-l1'),'10000','1000'],stdout=f,stderr=subprocess.STDOUT)
assert r.returncode==0
import re
def load_keys(p):return {(int(a),int(b)):v for a,b,v in re.findall(r'EXTRA_KEY degree=(\d+) index=(\d+) digest=(\w+)',p.read_text())}
base=load_keys(ROOT/'results/followup-host/20260923T060455Z/reference.log')
trial=load_keys(OUT/'counterfactual-l1.log');assert len(base)==len(trial)==20000
diff=[dict(degree=k[0],index=k[1],reference=base[k],counterfactual=trial[k]) for k in base if base[k]!=trial[k]]
assert all(sha(Path(p))==h for p,h in original.items())
result=dict(scope='diagnostic guard substitution, not adopted',count=20000,mismatches=diff,
            guard_cases=rows,command=cmd,source=original,generated_sha256=sha(path),log_sha256=sha(OUT/'counterfactual-l1.log'))
(OUT/'counterfactual-summary.json').write_text(json.dumps(result,indent=2)+'\n')
print('COUNTERFACTUAL_DONE',len(diff),'mismatches',flush=True)
