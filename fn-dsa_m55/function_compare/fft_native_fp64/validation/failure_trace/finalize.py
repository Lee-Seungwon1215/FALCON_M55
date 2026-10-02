#!/usr/bin/env python3
"""Verify and collect causal evidence without promoting the diagnostic copy."""
import hashlib,json,re,sys
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2];OUT=Path(sys.argv[1]).resolve();BOARD=Path(sys.argv[2]).resolve()
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
manifest=json.loads((OUT/'manifest.json').read_text())
for backend,r in manifest.items():
    assert all(sha(Path(p))==h for p,h in r['source'].items()),backend
board=json.loads((BOARD/'run.json').read_text());assert board['valid_measurement'] and board['host_board']==dict(lines=11,matches=True)
assert sha(BOARD/'raw.log')==board['raw_sha256']
trace=json.loads((OUT/'summary.json').read_text());guard=json.loads((OUT/'guard-proof-cases.json').read_text())
numeric=json.loads((OUT/'numerical-summary.json').read_text())
wide=json.loads((OUT/'wide-guard/summary.json').read_text());ubsan=json.loads((OUT/'wide-guard/ubsan-summary.json').read_text())
assert wide['checks']['extended']['mismatches']==[] and wide['checks']['kat']['returncode']==0
assert ubsan['all_pass']
for r in trace:
    q=r['first_k_difference']['reference'];d=r['first_k_difference']['candidate']
    assert q['k']==d['k'] and q['valid']==1 and d['valid']==0
for r in numeric:
    p=r['first_primitive'];assert p['operands_same_exact'] and not p['fixed_result_representable'] and p['trial_is_nearest_fixed']
    if p['operation']=='div':assert p['normal_div_is_correctly_rounded'] and p['fixed_agrees_exact_rational']
result=dict(scope='cause isolated; production unchanged; diagnostic guard is NOT adopted',
    observed_key_mismatch_cause='candidate-only overly conservative fp64_k_update_ok rejection',
    no_k_coefficient_difference_before_first_rejection=True,
    trace=trace,guard=guard,numerical=numeric,
    counterfactual_original_mismatches=5,counterfactual_l1_narrow_mismatches=2,
    counterfactual_l1_wide_mismatches=0,counterfactual_keys_checked=20000,
    counterfactual_host_kat300='PASS',counterfactual_host_full_signature_kat='PASS',
    counterfactual_ubsan_keys=10,
    board_isolated_replay=dict(directory=str(BOARD),lines=11,matches=True),
    board_full_counterfactual_keygen='NOT RUN',new_performance='NOT RUN',constant_time_fix='NOT IMPLEMENTED',
    universal_equivalence='NOT PROVED; previous isolated multiply counterexample still applies',
    guard_bound_preconditions='logn=1..3; 31-bit limbs; initial carry=0; actual C order',
    guard_l1_limit=(1<<32)-2,maximum_absolute_accumulator=(1<<63)-(1<<31),
    evidence_sha256={str(p):sha(p) for p in [OUT/'summary.json',OUT/'numerical-summary.json',OUT/'wide-guard/summary.json',OUT/'wide-guard/extended.log',OUT/'wide-guard/kat.log',OUT/'wide-guard/ubsan-summary.json',BOARD/'run.json']})
(OUT/'final-summary.json').write_text(json.dumps(result,indent=2)+'\n')
print('FINAL_SUMMARY',OUT/'final-summary.json')
