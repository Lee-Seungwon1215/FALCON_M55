#!/usr/bin/env python3
"""Integrity and exact-accumulator Welch analysis, NOT security certification."""
import hashlib
import json
import math
import re
import runpy
import subprocess
import sys
from fractions import Fraction
from pathlib import Path

root=Path(__file__).resolve().parents[2]
audit=root/'validation/security'
out=root/sys.argv[3] if len(sys.argv)>3 else audit
out.mkdir(parents=True,exist_ok=True)
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
inv=root/'validation/results/A_tw_bridge/security_invnorm'/sys.argv[1]
api=root/'validation/results/A_tw_bridge/security_api'/sys.argv[2]
snapshot=json.loads((root/'validation/source_snapshots/A17_fp64_invnorm.json').read_text())['sha256']
crypto={p.name:sha(p) for p in (root/'A_tw_bridge').glob('*') if p.suffix in ('.c','.h','.s')}
cleaned = not all(snapshot.get(n)==v for n,v in crypto.items())
if cleaned:
    cleanup = runpy.run_path(str(root/'validation/cleanup/check.py'))['check']()
    assert crypto == cleanup['sha256']
else:
    assert set(crypto) == {n for n in snapshot if Path(n).suffix in ('.c','.h','.s')}
verified=[]
for p in [inv,api]:
    m=json.loads((p/'manifest.json').read_text())
    assert m['valid_measurement'] and not m['errors']
    assert sha(p/'raw.log')==m['raw_sha256'] and sha(p/'benchmark.elf')==m['elf_sha256']
    for source,h in m['source_sha256'].items():
        if Path(source).parent==root/'A_tw_bridge':assert crypto[Path(source).name]==h
    verified.append(str(p.relative_to(root)))
raw=(inv/'raw.log').read_text()
accuracy=[]; timings={}
for line in raw.splitlines():
    if not line.startswith(('SEC_TIMING ','SEC_ACCURACY ')):continue
    d={k:int(v) for k,v in re.findall(r'(\w+)=(\d+)',line)}
    if line.startswith('SEC_ACCURACY '):accuracy.append(d)
    else:timings.setdefault((d['logn'],d['phase']),{})[d['class']]=d
welch=[]
for (l,phase),groups in sorted(timings.items()):
    assert set(groups)=={0,1}
    a,b=groups[0],groups[1]
    means=[Fraction(x['sum'],x['count']) for x in (a,b)]
    # Exact integer/Fraction subtraction prevents catastrophic cancellation.
    variances=[(Fraction(x['squares'])-Fraction(x['sum']**2,x['count']))/(x['count']-1) for x in (a,b)]
    delta=float(means[0]-means[1]);se=float(variances[0]/a['count']+variances[1]/b['count'])
    t=delta/math.sqrt(se) if se else (None if delta else 0.0)
    flag=(abs(t)>=5) if t is not None else True
    welch.append(dict(logn=l,phase=phase,groups=groups,means=list(map(float,means)),
        variances=list(map(float,variances)),delta_cycles=delta,t=t,flag_abs_t_ge_5=flag))
    print('WELCH',l,phase,'delta',delta,'t',t,'flag',flag)
assert len(accuracy)==9
api_raw=(api/'raw.log').read_text()
api_done=re.search(r'^SEC_API_DONE valid=(\d+) rejected=(\d+) failures=(\d+) guards=(\d+)$',api_raw,re.M)
assert api_done
result=dict(status='INCOMPLETE_SECURITY_ASSESSMENT',crypto_verified_files=len(crypto),
    crypto_unchanged_from_original_a17=not cleaned,
    source_version='A17-cleanup' if cleaned else 'A17',
    source_claim='Verified cleanup of frozen A17' if cleaned else 'Unchanged frozen A17',
    verified_runs=verified,accuracy=accuracy,welch=welch,
    candidates=sum(x['cases'] for x in accuracy),coefficients=sum(x['coefficients'] for x in accuracy),
    differences=sum(x['differences'] for x in accuracy),decision_mismatches=sum(x['decisions'] for x in accuracy),
    api=dict(zip(('valid','rejected','failures','guards'),map(int,api_done.groups()))),
    limitations=['Not an all-input numeric/domain proof','Not full dudect (uncropped first-order Welch only)',
      'Not an instruction-level noninterference proof','Not power/EM/fault-injection testing',
      'Host ASan runtime failed before tests','Output guards do not detect all reads or prove worst-case stack'])
witness_dirs=sorted((audit/'results').glob('host_witness_*'))
if witness_dirs:
    wp=witness_dirs[-1];wm=json.loads((wp/'manifest.json').read_text())
    assert wm['pass'] and wm['raw_sha256']==sha(wp/'raw.log')
    line=next(x for x in (wp/'raw.log').read_text().splitlines() if x.startswith('SEC_WITNESS '))
    d=dict(re.findall(r'(\w+)=(\w+)',line))
    signed=lambda s:int(s,16)-(1<<64) if int(s,16)>>63 else int(s,16)
    words=[signed(d[k]) for k in ('ar','ai','br','bi')]
    exact=sum(Fraction(x*x,1<<64) for x in words)
    fixed=sum((x*x)>>32 for x in words)
    rounded=lambda x:(x+Fraction(1,2)).numerator//(x+Fraction(1,2)).denominator
    exact_recip=rounded(Fraction(1<<32,1)/exact)
    fixed_recip=rounded(Fraction(1<<64,fixed))
    assert fixed==int(d['fixed_den'],16) and exact_recip==int(d['now'],16) and fixed_recip==int(d['old'],16)
    result['witness']=dict(run=str(wp.relative_to(root)),sample=int(d['sample']),index=int(d['index']),
        input_raw={k:d[k] for k in ('ar','ai','br','bi')},exact_denominator=str(exact),
        fixed_denominator_raw=hex(fixed),exact_reciprocal_raw=hex(exact_recip),fixed_reciprocal_raw=hex(fixed_recip),
        conclusion='This witness differs due to square truncation rules, not a lost integer carry. Not an all-input result.')
(out/'summary.json').write_text(json.dumps(result,indent=2)+'\n')
tool=root.parent/'measurement_mlkem_native/env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin/arm-none-eabi-objdump'
symbols=['fndsa_vect_invnorm_fft','fndsa_vect_div_selfadj_fft_fp64','fndsa_vect_FFT_ntru',
    'fndsa_vect_iFFT_ntru','fndsa_ntru_q32_butterfly','fndsa_ntru_q32_tail',
    'fndsa_fixed_input_mve','fndsa_fxr_div4','fndsa_fft_bridge_forward','fndsa_fft_bridge_inverse',
    'ds_fft_run','ds_ifft_run']
dis=''.join(subprocess.check_output([str(tool),'-d','--disassemble='+s,str(api/'benchmark.elf')],text=True) for s in symbols)
(out/'A17_disassembly.txt').write_text(dis)
(out/'disassembly_manifest.json').write_text(json.dumps(dict(elf=str(api/'benchmark.elf'),
    elf_sha256=sha(api/'benchmark.elf'),symbols=symbols,disassembly_sha256=sha(out/'A17_disassembly.txt'),
    claim='For manual branch/address/domain review; no automatic CT proof'),indent=2)+'\n')
obj=root/'validation/build/A_tw_bridge/security_api/CMakeFiles/app.dir'/str(root/'A_tw_bridge/sysrng.c.obj').lstrip('/')
if obj.exists():
    rng_dis=subprocess.check_output([str(tool),'-d','--disassemble=fndsa_sysrng',str(obj)],text=True)
    (out/'sysrng_disassembly.txt').write_text(rng_dis)
    (out/'sysrng_manifest.json').write_text(json.dumps(dict(object=str(obj),sha256=sha(obj),
        source_sha256=crypto['sysrng.c'],claim='This benchmark build returns 0 for nonzero entropy requests; seeded tests bypass this provider'),indent=2)+'\n')
print('SUMMARY',result['status'],'candidates',result['candidates'],'coefficients',result['coefficients'])
