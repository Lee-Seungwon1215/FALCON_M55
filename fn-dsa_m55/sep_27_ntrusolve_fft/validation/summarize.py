#!/usr/bin/env python3
"""Summarize only completed, provenance-checked new-path measurements.

Instrumented scope fractions are never used as uninstrumented speedups.
I_update is INTEGER subtraction/NTT work, not FFT approximation.
"""
import json
import re
from collections import defaultdict
from pathlib import Path

root = Path(__file__).resolve().parent
scope = {'I_input','I_fft','I_recip','I_mul','I_ifft','I_round',
         'D_input','D_fft','D_div','D_ifft','D_round'}
rows=[]
for path in sorted((root/'results').glob('*/*/*/manifest.json')):
    m=json.loads(path.read_text())
    if not m['valid_measurement']: continue
    raw=(path.parent/'raw.log').read_text()
    raw=re.sub(r'Info : [^\n]*\n','',raw)
    rec=dict(candidate=m['candidate'],mode=m['mode'],run=path.parent.name,
             manifest=str(path.relative_to(root)),elf_sha256=m['elf_sha256'])
    totals={int(d):int(t)/int(n) for d,n,t in re.findall(
        r'^KEYGEN_SUMMARY degree=(\d+) calls=(\d+) total=(\d+)',raw,re.M)}
    # The replay diagnostic deliberately does extra transforms. Its keygen
    # rows validate outputs, not production whole-keygen performance.
    if m['mode'] not in ('keygen', 'profile'):
        totals = {}
    rec['mean_cycles']=totals
    if m['mode']=='profile':
        leaves=defaultdict(lambda:defaultdict(int))
        logn_leaves=defaultdict(lambda:defaultdict(lambda:defaultdict(int)))
        for d,op,l,c in re.findall(r'^IPRO degree=(\d+) op=(\w+) logn=(\d+) calls=\d+ cycles=(\d+)',raw,re.M):
            leaves[int(d)][op]+=int(c)/100
            logn_leaves[int(d)][int(l)][op]+=int(c)/100
        rec['scope_cycles']={d:sum(v for op,v in ops.items() if op in scope) for d,ops in leaves.items()}
        rec['scope_percent']={d:100*v/totals[d] for d,v in rec['scope_cycles'].items()}
        rec['leaves']=leaves
        rec['logn_leaves']=logn_leaves
    rows.append(rec)
(root/'summary.json').write_text(json.dumps(rows,indent=2)+'\n')
lines=['# Controlled measurements (work in progress)','',
       'Only completed runs with valid provenance/fault/KAT checks are included.',
       'Means include failed candidates/retries; 100 seeds per degree, 3 warmups excluded.',
       'Profile results include instrumentation overhead and are not final speed results.','',
       '| Candidate / mode / run | 512 mean cycles | 1024 mean cycles |',
       '| --- | ---: | ---: |']
for r in rows:
    if not r['mean_cycles']: continue
    lines.append(f"| {r['candidate']} / {r['mode']} / {r['run']} | "
                 + ' | '.join(f"{r['mean_cycles'][d]:,.2f}" for d in (512,1024))+' |')
lines+=['','## Instrumented target scope','',
        'Input conversion + FFT + reciprocal/pointwise/division + iFFT + k rounding.',
        'Excludes candidate orthonorm and I_update integer polynomial updates.','',
        '| Candidate / run | 512 scope | 1024 scope |','| --- | ---: | ---: |']
for r in rows:
    if r['mode']=='profile':
        lines.append(f"| {r['candidate']} / {r['run']} | "
                     +' | '.join(f"{r['scope_percent'][d]:.5f}%" for d in (512,1024))+' |')
(root/'measurement_summary.md').write_text('\n'.join(lines)+'\n')
print('\n'.join(lines))
