#!/usr/bin/env python3
"""Collect acceptance evidence for the directly integrated guard repair."""
import argparse,hashlib,json,re
from datetime import datetime,timezone
from pathlib import Path
ROOT=Path(__file__).resolve().parent.parent
p=argparse.ArgumentParser()
for name in ('host','kat','sigkat','repro'):p.add_argument('--'+name,type=Path,required=True)
a=p.parse_args();sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
host=json.loads((a.host/'summary.json').read_text())
assert host['kat']['mismatches']==0 and host['extended']['mismatches']==[] and host['extended']['count']==20000
assert host['guard_boundary_and_diagnostic_comparison']=='PASS'
assert all(sha(Path(p))==h for p,h in host['source'].items())
runs={};raw={}
for name in ('kat','sigkat','repro'):
    d=getattr(a,name);r=json.loads((d/'run.json').read_text());assert r['valid_measurement'],r
    assert sha(d/'raw.log')==r['raw_sha256']
    assert all(sha(Path(p))==h for p,h in r['source'].items())
    assert all(r['source'][p]==h for p,h in host['source'].items())
    assert sha(ROOT/'build'/('q32_trial-'+r['kind'])/'zephyr/zephyr.elf')==r['elf_sha256']
    runs[name]=r;raw[name]=(d/'raw.log').read_text()
assert runs['kat']['kat']==dict(result=0,count=300,mismatches=0)
assert runs['sigkat']['kat']==dict(count=90,mismatches=0)
assert runs['repro']['host_board']==dict(lines=5,matches=True,oracle='reference')
host_keys={(int(d),int(i)):h for d,i,h in re.findall(r'KEY_KAT degree=(\d+) seed=test(\d+) match=1 actual=(\w+)',(a.host/'kat.log').read_text())}
board_keys={(int(d),int(i)):h for d,i,h in re.findall(r'BOARD_KAT degree=(\d+) index=(\d+) match=1 equation=PASS actual=(\w+)',raw['kat'])}
assert len(host_keys)==len(board_keys)==300 and host_keys==board_keys
assert len(re.findall(r'^BOARD_SIGNKAT degree=.* match=1 verify=PASS tamper=PASS$',raw['sigkat'],re.M))==90
assert len(re.findall(r'^REPRO degree=.* verify=PASS tamper=PASS$',raw['repro'],re.M))==5
source=ROOT/'q32_trial'
result=dict(scope='L1 guard repair applied directly to q32_trial and revalidated on N657',
    changed_crypto_sources=host['changed_sources'],
    checks=dict(board_keygen_kat='300/300 PASS',board_signature_kat='90/90 PASS',
                board_verify_and_tamper_rejection='95/95 PASS',board_previous_failing_seeds='5/5 original reference matches',
                board_host_keygen_kat_digest_agreement='300/300',host_extended_keys='20000/20000 original reference matches',
                host_guard_boundary_and_random_cases=host['guard_cases'],host_full_kat='PASS'),
    guard_header_sha256=sha(source/'kgen_inner.h'),
    original_header_archive_sha256=sha(ROOT/'build/q32_trial-before-l1-guard-20260923.tar.gz'),
    evidence={k:str(v.resolve()) for k,v in vars(a).items()},
    board_elf_sha256={k:r['elf_sha256'] for k,r in runs.items()},
    source=host['source'],
    status='GUARD_REPAIR_ACCEPTED_WITHIN_TESTED_SCOPE_NOT_OVERALL_OPTIMIZATION_ACCEPTANCE',
    remaining=dict(universal_key_equivalence='NOT PROVED',full_intermediate_bit_equivalence='NOT TRUE IN GENERAL',
                   primitive_multiply_counterexample='UNCHANGED',performance_issue='NOT ADDRESSED OR REMEASURED',
                   operand_dependent_floor_branch_issue='NOT ADDRESSED',side_channel_security='NOT CERTIFIED'))
out=ROOT/'results/guard-integration-summary'/datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ')
out.mkdir(parents=True,exist_ok=False);(out/'summary.json').write_text(json.dumps(result,indent=2)+'\n')
print('GUARD_INTEGRATION_ACCEPTANCE',out/'summary.json')
print(json.dumps(result['checks'],indent=2))
