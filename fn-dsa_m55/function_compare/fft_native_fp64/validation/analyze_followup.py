#!/usr/bin/env python3
"""Fail-closed collection of the fresh-input, hardware and static evidence.

No statistical pass is interpreted as universal equivalence or CT proof.
Known negative results are reported as negative, not filtered out.
"""
import argparse,hashlib,json,re,subprocess
from datetime import datetime,timezone
from pathlib import Path
ROOT=Path(__file__).resolve().parent.parent
p=argparse.ArgumentParser()
p.add_argument('--host',type=Path,required=True)
p.add_argument('--perf',type=Path,required=True)
p.add_argument('--trial-repro',type=Path,required=True)
p.add_argument('--reference-repro',type=Path,required=True)
p.add_argument('--repeat-perf',type=Path)
a=p.parse_args()
out=ROOT/'results/followup-analysis'/datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ')
out.mkdir(parents=True)
sha=lambda f:hashlib.sha256(f.read_bytes()).hexdigest()
host=json.loads((a.host/'summary.json').read_text())
man=json.loads((a.host/'manifest.json').read_text())
for backend,row in man.items():
    assert all(sha(ROOT/backend/name)==h for name,h in row['source'].items()),'crypto changed'
board={}
board_dirs=[('perf',a.perf),('trial',a.trial_repro),('reference',a.reference_repro)]
if a.repeat_perf:board_dirs.append(('repeat_perf',a.repeat_perf))
for label,d in board_dirs:
    row=json.loads((d/'run.json').read_text());assert row['valid_measurement'],row
    assert sha(d/'raw.log')==row['raw_sha256']
    assert all(sha(Path(f))==h for f,h in row['source'].items()),'stale evidence'
    board[label]=row
raw=(a.perf/'raw.log').read_text()
def records(tag):
    rows=[]
    for line in raw.splitlines():
        if line.startswith(tag+' '):
            r=dict(x.split('=',1) for x in line.split()[1:])
            r={k:int(v) if v.isdigit() else v for k,v in r.items()}
            if 'sum' in r:r['mean']=r['sum']/r['count']
            rows.append(r)
    return rows
kr=records('KPERF');pr=records('CT_PRIMITIVE');fr=records('CT_FFT');errors=records('PERF_K')
assert len(kr)==266 and len(pr)==96 and len(fr)==72 and len(errors)==19
assert all(r['differences']==r['fixed_fixture_errors']==0 for r in errors)
perf=[]
for l in range(1,10):
    for op in ['FFT','iFFT','pointwise','inverse','prepare','repeat','pipeline']:
        # Equal weight for the ordinary and large-k frozen real state.
        # Case18 is the extra first-divergence diagnostic, not a third weight.
        match=[r for r in kr if r['logn']==l and r['op']==op and r['case']!=18]
        q=sum(r['mean'] for r in match if r['backend']=='fixed')/2
        d=sum(r['mean'] for r in match if r['backend']=='q32_trial')/2
        perf.append(dict(logn=l,n=1<<l,op=op,fixed_cycles=q,trial_cycles=d,
                         trial_over_fixed=d/q,cycle_change_percent=100*(d/q-1)))
ct=[]
for op in sorted({r['op'] for r in pr}):
    rows=[r for r in pr if r['op']==op]
    lo=min(rows,key=lambda r:r['mean']);hi=max(rows,key=lambda r:r['mean'])
    ct.append(dict(op=op,low=lo,high=hi,difference_per_call=(hi['mean']-lo['mean'])/128,
                   disjoint=lo['max']<hi['min']))
tool=ROOT.parents[1]/'measurement_mlkem_native/env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin'
elf=ROOT/'build/q32_trial-perfct/zephyr/zephyr.elf'
assert sha(elf)==board['perf']['elf_sha256']
dis={}
for name in ['probe_floor','probe_wrap','probe_add','probe_mul','probe_half','probe_div','probe_round','probe_complex',
             'fndsa_vect_FFT_fp64','fndsa_vect_iFFT_fp64','fndsa_vect_mul_fft_fp64',
             'fndsa_vect_inv_mul2e_fft_fp64']:
    text=subprocess.check_output([str(tool/'arm-none-eabi-objdump'),'-d','--disassemble='+name,str(elf)],text=True)
    (out/(name+'.s.txt')).write_text(text);dis[name]=dict(sha256=sha(out/(name+'.s.txt')),
        conditional_branch_lines=[s for s in text.splitlines() if re.search(r'\s(?:b(?:eq|ne|hi|ls|gt|lt|ge|le|cc|cs|mi|pl|vc|vs)(?:\.[nw])?|cbn?z)\s',s)])
symbols=subprocess.check_output([str(tool/'arm-none-eabi-nm'),str(elf)],text=True)
(out/'symbols.txt').write_text(symbols)
repeat=None
if a.repeat_perf:
    raw2=(a.repeat_perf/'raw.log').read_text()
    tags=('KPERF ','CT_PRIMITIVE ','CT_FFT ','PERF_K ','COUNTEREXAMPLE_BOARD ')
    first=[s for s in raw.splitlines() if s.startswith(tags)]
    second=[s for s in raw2.splitlines() if s.startswith(tags)]
    assert len(first)==len(second)==454
    assert board['repeat_perf']['elf_sha256']==sha(elf)
    repeat=dict(lines=len(first),exact_match=first==second,
        differences=[dict(first=x,second=y) for x,y in zip(first,second) if x!=y])
data=dict(status='NOT_ACCEPTABLE_AS_DROP_IN_REPLACEMENT',universal_equivalence='disproved_for_tested_seed_set',
    constant_time='FAIL_observed_operand_dependent_branches_and_cycles',
    whole_keygen_ct_proof=False,host=host,performance=perf,primitive_timing=ct,fft_timing=fr,
    raw_performance=kr,frozen_k=errors,static_disassembly=dis,
    software_double_helpers=[s for s in symbols.splitlines() if '__aeabi_d' in s],
    evidence={k:str(v.resolve()) for k,v in vars(a).items() if v},repeat=repeat,
    elf_sha256=sha(elf),crypto_unchanged_from_host_manifest=True)
(out/'summary.json').write_text(json.dumps(data,indent=2)+'\n')
print('REPORT',out)
for r in perf:
    if r['logn']>=8:print(r)
print('CT',[(r['op'],r['difference_per_call'],r['disjoint']) for r in ct])
if repeat:print('REPEAT',repeat)
