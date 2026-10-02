#!/usr/bin/env python3
"""Audit the adopted LDL/split/merge revision, not historical revisions.

Writes machine-readable artifacts only; earlier reports are never overwritten.
"""
import hashlib
import json
from pathlib import Path
import re
import subprocess
import tarfile

HERE = Path(__file__).resolve().parent
SOURCE = HERE.parent
WORKSPACE = HERE.parents[3]
ORIGINAL = WORKSPACE / 'fn-dsa_m55/M55_ref'

def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()

def rows(text, prefix):
    return [dict(re.findall(r'(\w+)=([^ ]+)', line)) for line in text.splitlines()
            if line.startswith(prefix + ' ')]

def read_run(path):
    m = json.loads((path/'manifest.json').read_text())
    assert m['valid_measurement'] and not m['errors'], path
    assert sha(path/'raw.log') == m['raw_sha256']
    assert sha(path/'benchmark.elf') == m['elf_sha256']
    return m, re.sub(r'Info : [^\n]*\n', '', (path/'raw.log').read_text())

def production(root):
    return sorted(p for p in root.iterdir() if p.suffix in ('.c','.h','.s') or p.name=='Makefile')

with tarfile.open(HERE/'pre_schedule_sources.tar.gz') as archive:
    before = {m.name:archive.extractfile(m).read() for m in archive.getmembers() if m.isfile()}
changed = [p.name for p in production(SOURCE) if before.get(p.name) != p.read_bytes()]
assert changed == ['Makefile','sign_fpoly.c','sign_ldl_cm55.s','sign_split_merge_cm55.s'], changed
assert set(before) <= {p.name for p in production(SOURCE)}
pre = before['sign_fpoly.c'].decode()
cur = (SOURCE/'sign_fpoly.c').read_text()
# Exact prefix/middle/suffix outside the three removed function bodies.
start = pre.index('/* fpr stores binary64 bits, not a Q32 value')
mid = pre.index('/* see sign_inner.h */\nTARGET_SSE2 TARGET_NEON\nvoid\nfpoly_split_selfadj_fft(')
merge = pre.index('/* see sign_inner.h */\nTARGET_SSE2 TARGET_NEON\nvoid\nfpoly_merge_fft(')
end = pre.index('/* see sign_inner.h */', merge+25)
expected = pre[:start] + '/* fpoly_LDL_fft() is implemented in sign_ldl_cm55.s. */\n\n' \
    + '/* fpoly_split_fft() is implemented in sign_split_merge_cm55.s. */\n\n' \
    + pre[mid:merge] + '/* fpoly_merge_fft() is implemented in sign_split_merge_cm55.s. */\n\n' + pre[end:]
assert cur == expected, 'Changes outside intended function bodies'

selected = {}
for p in sorted((HERE/'results').glob('*/*/manifest.json')):
    m = json.loads(p.read_text())
    if not m['valid_measurement'] or m['variant'] not in ('candidate','original'): continue
    root = SOURCE if m['variant']=='candidate' else ORIGINAL
    if not all(m['source_sha256'].get(str(q)) == sha(q) for q in production(root)): continue
    read_run(p.parent)
    selected.setdefault(m['variant']+'_'+m['mode'],[]).append(p.parent)
for key in ('candidate_ldl','candidate_poly','candidate_kernel','candidate_sign',
            'candidate_sigkat','candidate_kat','candidate_extra','candidate_api',
            'original_sign','candidate_sign_detail','candidate_sign_control'):
    assert key in selected, ('missing current-source run', key)
for key in ('candidate_ldl','candidate_poly','candidate_sign','original_sign',
            'candidate_sign_detail','candidate_sign_control'):
    assert len(selected[key])>=2, ('missing repeat',key)

catalog = json.loads((HERE/'schedule_candidates.json').read_text())
experiments = {}
for group,prefix in (('ldl','LDL_PERF'),('poly','POLY_PERF'),('whole','SIGN_SUMMARY')):
    experiments[group]=[]
    kind = 'sign' if group=='whole' else group
    for item in catalog[group]:
        path=HERE/'results'/('candidate_'+kind)/item['dir']
        m,text=read_run(path)
        experiments[group].append(dict(name=item['name'],run=str(path.relative_to(HERE)),
            perf=rows(text,prefix),source_archive_sha256=sha(path/'production_sources.tar.gz')))

kernel=[]
ct=[]
for mode,prefix in (('ldl','LDL'),('poly','POLY'),('kernel','FFT')):
    for path in selected['candidate_'+mode]:
        _,text=read_run(path)
        kernel.append(dict(run=str(path.relative_to(HERE)), mode=mode, perf=rows(text,prefix+'_PERF')))
        for tag in (prefix+'_CT', 'RECIP_CT'):
            cc=rows(text,tag)
            if cc: ct.append(dict(run=str(path.relative_to(HERE)),tag=tag,groups=cc))

stages = {item['name']:item['perf'] for item in experiments['whole']}
sign=[]
for n in (512,1024):
    by={}
    for variant in ('candidate','original'):
        by[variant]=[]
        for path in selected[variant+'_sign']:
            _,text=read_run(path)
            r,=[x for x in rows(text,'SIGN_SUMMARY') if int(x['degree'])==n]
            ss=[int(x['cycles']) for x in rows(text,'SIGN_SAMPLE') if int(x['degree'])==n]
            assert len(ss)==100 and sum(ss)==int(r['total'])
            by[variant].append(dict(run=str(path.relative_to(HERE)),mean=sum(ss)/100))
    old,=[x for x in stages['before'] if int(x['degree'])==n]
    pre_mean=int(old['total'])/100
    means={k:sum(r['mean'] for r in v)/len(v) for k,v in by.items()}
    sign.append(dict(degree=n,before_mean=pre_mean,means=means,runs=by,
        incremental_speedup=pre_mean/means['candidate'],
        incremental_reduction_percent=100*(1-means['candidate']/pre_mean),
        cumulative_speedup=means['original']/means['candidate'],
        cumulative_reduction_percent=100*(1-means['candidate']/means['original'])))

profile={}
for n in (512,1024):
    categories={};totals={}
    for mode in ('sign_detail','sign_control'):
        totals[mode]=0
        for path in selected['candidate_'+mode]:
            _,text=read_run(path)
            t,=[r for r in rows(text,'PROFILE_TOTAL') if int(r['degree'])==n and r['operation']=='sign']
            rr=[r for r in rows(text,'PROFILE_CATEGORY') if int(r['degree'])==n and r['operation']=='sign']
            assert sum(int(r['cycles']) for r in rr)==int(t['total'])
            totals[mode]+=int(t['total'])
            if mode=='sign_detail':
                nodes=n//2-1
                expect={'sg_fft':5,'sg_ifft':2,'sg_ldl':nodes,'sg_split':2*nodes,
                    'sg_merge':2*nodes,'sg_split_selfadj':2*nodes,'sg_deepest':n//2,
                    'sg_gaussian_berexp':2*n}
                for r in rr:
                    key=r['category']
                    if key in expect: assert int(r['entries'])==100*expect[key], (n,r)
                    row=categories.setdefault(key,dict(cycles=0,entries=0))
                    row['cycles']+=int(r['cycles']);row['entries']+=int(r['entries'])
    calls=100*len(selected['candidate_sign_detail'])
    for row in categories.values():
        row['mean_cycles']=row['cycles']/calls
        row['percent']=100*row['cycles']/totals['sign_detail']
    means={m:t/(100*len(selected['candidate_'+m])) for m,t in totals.items()}
    profile[n]=dict(categories=categories,means=means,
        instrumentation_delta_percent=100*(means['sign_detail']/means['sign_control']-1))

static=[]
path=selected['candidate_sign'][-1]
dis=(path/'disassembly.txt').read_text()
for name in ('fndsa_fpoly_LDL_fft','fndsa_fpoly_split_fft','fndsa_fpoly_merge_fft'):
    m=re.search(r'^([0-9a-f]+) <'+name+r'>:\n(.*?)(?=\n[0-9a-f]+ <|\Z)',dis,re.M|re.S)
    assert m
    body=m[2]
    assert not re.search(r'\b(?:vfma|vfms|vfnma|vfnms|vcvt|vcmp)\.',body)
    assert not re.search(r'\tbl(?:x|\.w)?\s',body)
    static.append(dict(function=name,address=m[1],helper_calls=0,fused_fma=0,
        numeric_conversions=0,disassembly=m[0],control='public logn/loop counters only; manual source audit'))
tool=WORKSPACE/'fn-dsa_m55/measurement_mlkem_native/env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin'
symbols=subprocess.check_output([str(tool/'arm-none-eabi-nm'),'-S','--size-sort',str(path/'benchmark.elf')],text=True)
function_sizes=[line for line in symbols.splitlines() if any(' '+r['function'] in line for r in static)]
summary=dict(changed_production_files=changed,unchanged_outside_three_functions=True,
    source_sha256={p.name:sha(p) for p in production(SOURCE)},
    selected_runs={k:[str(p.relative_to(HERE)) for p in v] for k,v in selected.items()},
    experiments=experiments,kernel=kernel,sign=sign,ct_screen=ct,final_profile=profile,
    static_audit=static,function_sizes=function_sizes,
    limitations='Finite normal/zero tests and timing screen, not a formal CT/all-input proof; no power/EM test. Same placement policy, not globally identical function addresses.')
(HERE/'schedule_summary.json').write_text(json.dumps(summary,indent=2)+'\n')
print(json.dumps(dict(sign=sign,function_sizes=function_sizes,selected_runs=summary['selected_runs']),indent=2))
