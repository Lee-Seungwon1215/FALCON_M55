#!/usr/bin/env python3
"""Audit current LDL-only sources, immutable logs and same-workload timing.

Legacy FFT-only measurements remain intact; no old timings are silently
relabelled as LDL results. This program emits a separate ldl_summary.json.
"""
import hashlib
import json
from pathlib import Path
import re

HERE = Path(__file__).resolve().parent
SOURCE = HERE.parent
BASE = HERE.parents[3] / 'Final_code/Before_slothy'

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def rows(text, prefix):
    return [dict(re.findall(r'(\w+)=([^ ]+)', line))
            for line in text.splitlines() if line.startswith(prefix + ' ')]

sources = sorted(p for p in SOURCE.iterdir() if p.suffix in ('.c', '.h', '.s'))
changed = [p.name for p in sources if not (BASE/p.name).is_file() or sha(p) != sha(BASE/p.name)]
assert changed == ['sign_fpoly.c'], changed
# The copied Final_code Makefile still lacks the previously adopted FFT
# assembly. Both measurement firmwares explicitly compile that same ASM;
# the candidate standalone Makefile already listed it before the LDL edit.
expected_make = (BASE/'Makefile').read_text().replace(
    ' mq_cm55.s kgen_mp31_cm55.s kgen_fft_cm55.s\n',
    ' mq_cm55.s kgen_mp31_cm55.s kgen_fft_cm55.s sign_fft_cm55.s\n')
assert (SOURCE/'Makefile').read_text() == expected_make
original = (BASE/'sign_fpoly.c').read_text()
candidate = (SOURCE/'sign_fpoly.c').read_text()
start = original.index('/* see sign_inner.h */\nTARGET_SSE2 TARGET_NEON\nvoid\nfpoly_LDL_fft(')
end = original.index('/* see sign_inner.h */\nTARGET_SSE2 TARGET_NEON\nvoid\nfpoly_split_fft(', start)
new_start = candidate.index('/* fpr stores binary64 bits, not a Q32 value')
new_end = candidate.index('/* see sign_inner.h */\nTARGET_SSE2 TARGET_NEON\nvoid\nfpoly_split_fft(',new_start)
assert candidate[:new_start] == original[:start]
assert candidate[new_end:] == original[end:]
oracle = (HERE/'oracle_ldl.c').read_text().split('#include "sign_inner.h"\n\n',1)[1]
assert oracle.replace('\noracle_LDL_fft(', '\nfpoly_LDL_fft(').rstrip() == original[start:end].rstrip()

selected = {}
excluded = []
for p in sorted((HERE/'results').glob('*/*/manifest.json')):
    m = json.loads(p.read_text())
    key = m['variant'] + '_' + m['mode']
    if key not in ('candidate_ldl', 'candidate_sign', 'baseline_sign',
            'candidate_sigkat', 'candidate_kat', 'candidate_extra', 'candidate_api'):
        continue
    root = SOURCE if m['variant'] == 'candidate' else BASE
    root_sources = sorted(q for q in root.iterdir() if q.suffix in ('.c','.h','.s'))
    current = all(m['source_sha256'].get(str(q)) == sha(q) for q in root_sources)
    if not m['valid_measurement'] or not current:
        excluded.append(dict(run=str(p.parent.relative_to(HERE)), errors=m['errors'], current_source=current))
        continue
    assert not m['errors']
    assert sha(p.parent/'raw.log') == m['raw_sha256']
    assert sha(p.parent/'benchmark.elf') == m['elf_sha256']
    selected.setdefault(key, []).append(p.parent)
for key in ('candidate_ldl','candidate_sign','baseline_sign','candidate_sigkat',
            'candidate_kat','candidate_extra','candidate_api'):
    assert key in selected, ('missing current-source successful test', key)

kernel = []
ct = []
recip = []
for run in selected['candidate_ldl']:
    text = (run/'raw.log').read_text()
    assert 'LDL_DONE comparisons=1280 failures=0 guards=0' in text
    perf = rows(text,'LDL_PERF')
    assert len(perf)==20
    for logn in range(1,11):
        degree=1<<logn
        rr={r['implementation']:r for r in perf if int(r['degree'])==degree}
        assert set(rr)=={'emulated','native'}
        a,b=int(rr['emulated']['median_hi']),int(rr['native']['median_hi'])
        kernel.append(dict(run=str(run.relative_to(HERE)),degree=degree,
            original_cycles=a,native_cycles=b,speedup=a/b,cycle_reduction_percent=100*(1-b/a)))
        cc=[r for r in rows(text,'LDL_CT') if int(r['degree'])==degree]
        assert len(cc)==8 and all(int(r['calls'])==100 for r in cc)
        ct.append(dict(run=str(run.relative_to(HERE)),degree=degree,classes=8,
            min_cycles=min(int(r['min']) for r in cc),max_cycles=max(int(r['max']) for r in cc),
            class_mean_cycles=[int(r['total'])/100 for r in cc]))
    cc=rows(text,'RECIP_CT')
    assert len(cc)==20 and all(int(r['calls'])==100 and int(r['repetitions'])==32 for r in cc)
    recip.append(dict(run=str(run.relative_to(HERE)),classes=20,repetitions=32,calls_per_class=100,
        min_cycles=min(int(r['min']) for r in cc),max_cycles=max(int(r['max']) for r in cc),
        class_mean_cycles=[int(r['total'])/100 for r in cc]))

sign=[]
for n in (512,1024):
    means={}
    for variant in ('baseline','candidate'):
        means[variant]=[]
        for run in selected[variant+'_sign']:
            text=(run/'raw.log').read_text()
            r,=[r for r in rows(text,'SIGN_SUMMARY') if int(r['degree'])==n]
            samples=[s for s in rows(text,'SIGN_SAMPLE') if int(s['degree'])==n]
            assert int(r['calls'])==100 and len(samples)==100
            assert sum(int(s['cycles']) for s in samples)==int(r['total'])
            assert r['fingerprint']==('9895079d' if n==512 else 'a020dd02')
            means[variant].append(dict(run=str(run.relative_to(HERE)),mean=int(r['total'])/100))
    a=sum(x['mean'] for x in means['baseline'])/len(means['baseline'])
    b=sum(x['mean'] for x in means['candidate'])/len(means['candidate'])
    sign.append(dict(degree=n,baseline_mean=a,candidate_mean=b,speedup=a/b,
        cycle_reduction_percent=100*(1-b/a),runs=means))

static=[]
for key in ('candidate_ldl','candidate_sign'):
    run=selected[key][-1]
    text=(run/'disassembly.txt').read_text()
    m=re.search(r'^([0-9a-f]+) <fndsa_fpoly_LDL_fft>:\n(.*?)(?=\n[0-9a-f]+ <|\Z)',text,re.M|re.S)
    assert m
    body=m[2]
    assert 'vdiv.f64' in body and 'vmul.f64' in body and 'vsub.f64' in body
    assert not re.search(r'\b(?:vfma|vfms|vfnma|vfnms|vcvt|vcmp)\.',body)
    assert not re.search(r'\tbl(?:x|\.w)?\s',body)
    branches=[line.strip() for line in body.splitlines() if re.search(
        r'\s(?:b(?:eq|ne|cs|cc|mi|pl|vs|vc|hi|ls|ge|lt|gt|le|x)?(?:\.w)?|le|dls)\s',line)]
    static.append(dict(run=str(run.relative_to(HERE)),address=m[1],helper_calls=0,
        fused_fma=0,numeric_conversions=0,branches=branches,disassembly=m[0]))

summary=dict(changed_production_sources=changed,unchanged_outside_ldl=True,
    makefile_difference_from_baseline='Existing sign_fft_cm55.s list entry; no LDL build switch',
    total_production_sources=len(sources),
    source_sha256={p.name:sha(p) for p in sources},
    selected_runs={k:[str(r.relative_to(HERE)) for r in v] for k,v in selected.items()},
    excluded_runs=excluded,kernel=kernel,sign=sign,ct_screen=ct,reciprocal_screen=recip,
    static_audit=static,limits='Finite normal/zero tests and empirical timing only, not a formal constant-time or all-input proof.')
(HERE/'ldl_summary.json').write_text(json.dumps(summary,indent=2)+'\n')
print(json.dumps(dict(kernel_512_1024=[r for r in kernel if r['degree']>=512],
    sign=sign,reciprocal_screen=recip,selected_runs=summary['selected_runs']),indent=2))
