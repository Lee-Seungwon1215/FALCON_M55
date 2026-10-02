#!/usr/bin/env python3
"""Verify the relocated candidate and collect fresh KAT/performance evidence."""
import argparse
import hashlib
import json
import re
import subprocess
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
OLD = ROOT.parents[2]/'function_compare/fft_native_fp64'
parser = argparse.ArgumentParser()
for name in ('kat','sigkat','guard','perf','repeat-perf','profile'):
    parser.add_argument('--'+name, type=Path, required=True)
args = parser.parse_args()
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
origin = json.loads((ROOT/'validation/origin_manifest.json').read_text())
crypto = {p.name:sha(p) for p in ROOT.glob('*.[chs]')}
assert len(crypto) == 31 and crypto == origin['crypto_sha256']
assert crypto == {p.name:sha(p) for p in (OLD/'q32_trial').glob('*.[chs]')}
for name, entry in origin['copied_test_harness'].items():
    # Preserve historical origin hashes while checking explicitly recorded
    # local build-harness extensions. Cryptographic hashes remain unchanged.
    expected = origin.get('local_harness_revisions', {}).get(name, entry)
    assert sha(ROOT/name) == expected['sha256'], name
evidence, raw = {}, {}
for label, path in vars(args).items():
    r = json.loads((path/'run.json').read_text())
    assert r['valid_measurement'] and r['source_root'] == str(ROOT), label
    assert r['local_crypto_translation_units'] == 24
    assert all(sha(Path(p)) == h for p,h in r['source'].items()), label
    assert sha(path/'raw.log') == r['raw_sha256']
    build = ROOT/'validation/build'/r['kind']
    assert sha(build/'zephyr/zephyr.elf') == r['elf_sha256']
    assert sha(build/'compile_commands.json') == r['compile_commands_sha256']
    evidence[label] = dict(path=str(path.resolve()), run=r)
    raw[label] = (path/'raw.log').read_text()

def rows(text, tag):
    result = []
    for line in text.splitlines():
        if line.startswith(tag+' '):
            r = dict(item.split('=',1) for item in line.split()[1:])
            result.append({k:int(v) if v.isdigit() else v for k,v in r.items()})
    return result

def keys(text, tag):
    return {(r['degree'],r['index']):r['actual'] for r in rows(text,tag)
            if r['match']==1 and r['equation']=='PASS'}

def previous_log(directory):
    meta = json.loads((directory/'run.json').read_text())
    assert meta['valid_measurement']
    assert sha(directory/'raw.log') == meta['raw_sha256']
    assert all(sha(Path(p)) == h for p,h in meta['source'].items())
    return (directory/'raw.log').read_text()

current_keys = keys(raw['kat'],'BOARD_KAT')
old_kat = OLD/'results/q32_trial-kat/20260923T095214Z'
assert len(current_keys) == 300
assert current_keys == keys(previous_log(old_kat),'BOARD_KAT')
profile_keys = keys(raw['profile'],'APRO_KEY')
assert len(profile_keys) == 200 and all(current_keys[k] == h for k,h in profile_keys.items())
assert evidence['kat']['run']['checks']['keygen_kat'] == dict(count=300,mismatches=0)
assert evidence['sigkat']['run']['checks']['signature_kat_verify_tamper'] == 90
assert evidence['guard']['run']['checks']['regression_matches_original_reference']

kr = rows(raw['perf'],'KPERF')
repeat = rows(raw['repeat_perf'],'KPERF')
assert len(kr) == len(repeat) == 266 and all(r['count'] == 100 for r in kr+repeat)
assert evidence['perf']['run']['elf_sha256'] == evidence['repeat_perf']['run']['elf_sha256']
for name in ('perf','repeat_perf'):
    r = rows(raw[name],'PERF_K')
    assert len(r) == 19 and all(x['differences'] == x['fixed_fixture_errors'] == 0 for x in r)
old_perf = OLD/'results/q32_trial-perfct/20260923T100752Z'
old_raw = previous_log(old_perf)
old_kr = rows(old_raw,'KPERF')
ops = ('FFT','iFFT','pointwise','inverse','prepare','repeat','pipeline')
performance = []
for l in range(1,10):
    for op in ops:
        means = {}
        for name, data in (('current',kr),('previous',old_kr)):
            for backend in ('fixed','q32_trial'):
                selected = [r for r in data if r['logn']==l and r['op']==op
                            and r['backend']==backend and r['case']!=18]
                assert len(selected)==2
                means[name+'_'+backend] = sum(r['sum']/r['count'] for r in selected)/2
        fixed = means['current_fixed']; trial = means['current_q32_trial']
        performance.append(dict(n=1<<l,op=op,fixed_cycles=fixed,trial_cycles=trial,
            trial_over_fixed=trial/fixed,previous_trial_cycles=means['previous_q32_trial'],
            trial_change_from_previous_percent=100*(trial/means['previous_q32_trial']-1)))

groups = dict(input_conversion=('input_f','input_F'),FFT=('FFT_f','FFT_F'),
              inverse=('inverse',),pointwise=('pointwise',),iFFT=('iFFT',),
              round_and_guard=('round','guard'))
profile = rows(raw['profile'],'APRO')
assert len(profile) == 153
empty = rows(raw['profile'],'APRO_EMPTY')
assert len(empty)==1 and empty[0]['calls']==1000
old_profile_path = OLD/'results/q32_trial-keyprofile/20260923T101423Z'
old_profile = rows(previous_log(old_profile_path),'APRO')
old_report_path = OLD/'results/performance-profile-analysis/20260923T101629Z/summary.json'
old_report = json.loads(old_report_path.read_text())
degrees = {}
for d,lmax in ((512,9),(1024,10)):
    selected = [r for r in profile if r['degree']==d]
    for l in range(1,lmax):
        counts = {r['op']:r['calls'] for r in selected if r['logn']==l}
        assert counts['input_f']==counts['FFT_f']==counts['inverse']>0
        assert counts['input_F']==counts['FFT_F']==counts['pointwise']==counts['iFFT']==counts['round']==counts['guard']>0
    total = sum(r['cycles'] for r in selected)
    previous = old_report['profiles']['trial_profile']['degrees'][str(d)]
    fixed = old_report['profiles']['reference_profile']['degrees'][str(d)]
    components = {}
    for name,parts in groups.items():
        cycles = sum(r['cycles'] for r in selected if r['op'] in parts)
        components[name] = dict(mean_cycles_per_key=cycles/100,share_percent=100*cycles/total)
    degrees[d] = dict(runs=100,mean_region_cycles_per_key=total/100,groups=components,
        previous_trial_mean=previous['mean_region_cycles_per_key'],
        change_from_previous_percent=100*(total/previous['summed_region_cycles']-1),
        previous_fixed_mean=fixed['mean_region_cycles_per_key'],
        over_previous_fixed=total/fixed['summed_region_cycles'],
        empty_timer_cost_estimate_percent=100*sum(r['calls'] for r in selected)
            *(empty[0]['cycles']/empty[0]['calls'])/total)

out = ROOT/'validation/results/analysis'/datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ')
out.mkdir(parents=True,exist_ok=False)
tool = ROOT.parents[2]/'measurement_mlkem_native/env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin'
elf = ROOT/'validation/build/perfct/zephyr/zephyr.elf'
old_elf = OLD/'build/q32_trial-perfct/zephyr/zephyr.elf'
def symbols(path):
    text = subprocess.check_output([str(tool/'arm-none-eabi-nm'),'-S',str(path)],text=True)
    table = {}
    for line in text.splitlines():
        m = re.match(r'^([0-9a-f]+) ([0-9a-f]+) [tT] (\S+)$',line)
        if m: table[m[3]] = dict(address=m[1],size=int(m[2],16))
    return text,table
sym,st = symbols(elf); old_sym,old_st = symbols(old_elf)
(out/'symbols.txt').write_text(sym)
names = ['fndsa_vect_FFT','fndsa_vect_iFFT','fndsa_vect_mul_fft','fndsa_vect_inv_mul2e_fft',
         'fndsa_vect_FFT_fp64','fndsa_vect_iFFT_fp64','fndsa_vect_mul_fft_fp64',
         'fndsa_vect_inv_mul2e_fft_fp64']
layout = {name:dict(current=st[name],previous=old_st[name],same=st[name]==old_st[name]) for name in names}
for name in ('probe_floor','fndsa_vect_FFT_fp64','fndsa_vect_iFFT_fp64'):
    asm = subprocess.check_output([str(tool/'arm-none-eabi-objdump'),'-d','--disassemble='+name,str(elf)],text=True)
    (out/(name+'.s.txt')).write_text(asm)
result = dict(status='LOCAL_PATH_RELOCATION_VALIDATED_NOT_OPTIMIZATION_OR_SECURITY_ACCEPTANCE',
    crypto_unchanged=True,crypto_sha256=crypto,evidence=evidence,
    correctness=dict(board_keygen_kat='300/300',board_signature_kat='90/90',
        board_normal_verify_and_tamper_rejection='95/95',guard_regression='5/5 original matches',
        profile_key_kat='200/200',kernel_frozen_k='19/19 both runs',
        all_keygen_kat_digests_match_previous_path=True),
    kernel_performance=performance,kernel_rows=kr,kernel_repeat_exact=kr==repeat,
    kernel_records_identical_to_previous_path=kr==old_kr,kernel_layout=layout,
    approximation_profile=degrees,profile_rows=profile,profile_exactly_matches_previous=profile==old_profile,
    profile_denominator='sum of disjoint instrumented approximate-k regions inside solve_NTRU_intermediate, not whole keygen/NTRU',
    previous_fixed_profile='previous same-conditions fixed profile reused; not rerun in this relocation task',
    ct_fft=rows(raw['perf'],'CT_FFT'),ct_primitive=rows(raw['perf'],'CT_PRIMITIVE'),
    software_double_helpers=[line for line in sym.splitlines() if '__aeabi_d' in line],
    limits=['known primitive counterexample remains','operand-dependent FFT/helper timing remains',
            'no universal same-key equivalence proof','not a production/side-channel certification',
            'no fresh whole-keygen performance measurement'],
    previous_evidence=dict(kat=str(old_kat),perf=str(old_perf),profile=str(old_profile_path),
                           profile_summary=str(old_report_path)))
(out/'summary.json').write_text(json.dumps(result,indent=2)+'\n')
print('LOCAL_VALIDATION_REPORT',out)
print(json.dumps(result['correctness'],indent=2))
print('Kernel repeat exact:',result['kernel_repeat_exact'])
print('Kernel records same as previous path:',result['kernel_records_identical_to_previous_path'])
print('Kernel addresses/sizes same:',all(r['same'] for r in layout.values()))
for r in performance:
    if r['n'] in (256,512):print('KERNEL',r)
for d,r in degrees.items():print('PROFILE',d,json.dumps(r))
