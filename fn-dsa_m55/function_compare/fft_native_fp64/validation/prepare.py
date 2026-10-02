#!/usr/bin/env python3
"""Freeze previously captured identical NTRU inputs; never change KAT answers."""
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
M55 = ROOT.parents[1]
CAP = M55/'FFT/4_ntrusolve_approximate_k/1st_native_fp64/validation/carry_audit_20260923/results/20260923T051322Z'
OUT = ROOT/'validation/generated'
OUT.mkdir(exist_ok=True)
def write_changed(path, text):
    if not path.exists() or path.read_text()!=text:
        path.write_text(text)
records = []
for p in sorted(CAP.glob('*.json')):
    if p.name == 'summary.json':
        continue
    r = json.loads(p.read_text())
    if 'raw_f' in r:
        records.append((p, r, p.name.startswith('residual-')))
assert len(records) == 28
text = ['/* Frozen raw words, not rounded double input reconstructions. */',
        'struct fft_case { const char *name; unsigned logn,e,fixed_inverse; const uint64_t *f,*F; };']
for j,(p,r,residual) in enumerate(records):
    for field in ('f','F'):
        text.append('static const uint64_t case_%d_%s[] = {%s};' %
                    (j,field,','.join('UINT64_C(0x'+v+')' for v in r['raw_'+field])))
text.append('static const struct fft_case cases[] = {')
for j,(p,r,residual) in enumerate(records):
    text.append('{"%s",%d,%d,%d,case_%d_f,case_%d_F},' %
                (p.stem,r['logn'],r['e'],residual,j,j))
text.append('};')
write_changed(OUT/'cases.h','\n'.join(text)+'\n')
test = (ROOT/'reference/test_fndsa.c').read_text()
parts = [test[test.index('size_t\nhextobin('):test.index('static void\ninner_test_SHAKE256(')]]
for degree in (256,512,1024):
    start = test.index(f'static const char *const KAT_KG{degree}[]')
    end = test.index('\n};',start)+3
    part = test[start:end]; assert part.count('"') == 200
    parts.append(part)
start = test.index('static void\nselftest_sha256(')
parts.append(test[start:test.index('\n#if FNDSA_ASM_CORTEXM4',start)])
write_changed(OUT/'upstream_kat.h','/* Original unchanged KAT material. */\n'+'\n'.join(parts))
sign_parts=[]
for logn in range(2,11):
    start=test.index(f'static const char *const KAT_{1<<logn}[]')
    part=test[start:test.index('\n};',start)+3]
    assert part.count('"')==20
    sign_parts.append(part)
write_changed(OUT/'upstream_signkat.h','/* Original unchanged key+signature digest vectors. */\n'+'\n'.join(sign_parts))
(OUT/'manifest.json').write_text(json.dumps(dict(
    captures={str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p,_,_ in records},
    source_test_sha256=hashlib.sha256(test.encode()).hexdigest()),indent=2)+'\n')
print('Frozen',len(records),'cases; unchanged KAT256/512/1024')
