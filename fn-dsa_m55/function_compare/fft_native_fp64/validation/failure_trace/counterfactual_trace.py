#!/usr/bin/env python3
"""Trace the residual cases after a diagnostic L1 guard substitution."""
import hashlib,json,subprocess,sys
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2];HERE=Path(__file__).resolve().parent
OUT=Path(sys.argv[1]).resolve();DEST=OUT/'l1-trace';DEST.mkdir(exist_ok=True)
source=ROOT/'q32_trial';text=(OUT/'q32_trial-instrumented.c').read_text()
old='round_ok &= fp64_k_update_ok(logn, k);';assert text.count(old)==1
text='extern unsigned diag_l1_guard(unsigned,const int *);\n'+text.replace(old,'round_ok &= diag_l1_guard(logn, k);')
path=DEST/'instrumented.c';path.write_text(text)
names='codec mq sha3 sysrng util kgen kgen_fxp kgen_gauss kgen_mp31 kgen_poly kgen_zint31 sign sign_core sign_fpoly sign_fpr sign_sampler vrfy'.split()
cmd=['clang','-O3','-ffp-contract=off','-fno-fast-math','-fno-strict-aliasing','-DFNDSA_AVX2=0',
     '-I'+str(source),'-I'+str(ROOT/'validation/generated'),*[str(source/(n+'.c')) for n in names],
     str(path),str(HERE/'probes.c'),str(HERE/'capture.c'),'-lm','-o',str(DEST/'capture')]
subprocess.run(cmd,check=True)
result=[]
for c in json.loads((OUT/'counterfactual-summary.json').read_text())['mismatches']:
    key=f"{c['degree']}-{c['index']}";log=DEST/(key+'.jsonl')
    with log.open('w') as f:subprocess.run([str(DEST/'capture'),str(c['degree'].bit_length()-1),'fp64-audit-20260923-'+str(c['index'])],stdout=f,check=True)
    ref=[json.loads(s) for s in (OUT/(key+'-reference.jsonl')).read_text().splitlines()]
    trial=[json.loads(s) for s in log.read_text().splitlines()];assert trial[-1]['digest']==c['counterfactual']
    ident=lambda r:tuple(r.get(k) for k in ('type','stage','attempt','logn','depth','iteration'))
    count=0;first=None;f_input=None;F_input=None
    for q,d in zip(ref,trial):
        assert ident(q)==ident(d),(key,ident(q),ident(d))
        if q['type'] in ('status','attempt'):assert q==d
        if q['type']=='convert':
            assert q['limbs']==d['limbs'] and q['fixed_bits']==d['fixed_bits']
            if q['stage']=='input_f':f_input=(q,d)
            else:F_input=(q,d)
        if q['type']=='k':
            if q['k']!=d['k'] or q['valid']!=d['valid']:
                first=dict(reference=q,candidate=d);break
            count+=1
    assert first
    row=dict(case=key,prior_equal_k_vectors=count,first_decision_difference=first,
             sum_abs_k=sum(map(abs,first['candidate']['k'])),k_equal=first['reference']['k']==first['candidate']['k'])
    (DEST/(key+'-first.json')).write_text(json.dumps(dict(**row,f_input=f_input,F_input=F_input),indent=2)+'\n')
    result.append(row);print('L1_FIRST',json.dumps(row),flush=True)
(DEST/'summary.json').write_text(json.dumps(result,indent=2)+'\n')
