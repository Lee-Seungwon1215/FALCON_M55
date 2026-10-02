#!/usr/bin/env python3
"""Validate the final candidate's source hashes and finite test results."""
import hashlib,json,re
from pathlib import Path
ROOT=Path(__file__).resolve().parent.parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
summary=dict(interpretation='Finite validation, not full arithmetic equivalence, speed or constant-time proof')
board={}
for label in ('native-stages','reference-kat','native-kat','q32_trial-stages','q32_trial-kat','q32_trial-sigkat'):
    backend=label.split('-')[0]
    files=list((ROOT/backend).glob('*.[chs]'))
    selected=None
    for p in sorted((ROOT/'results'/label).glob('*/run.json'),reverse=True):
        row=json.loads(p.read_text())
        if row['valid_measurement'] and all(row['source'].get(str(f))==sha(f) for f in files):
            selected=(p,row);break
    assert selected,label+' has no completed current-source run'
    p,row=selected
    board[label]=dict(run=str(p.relative_to(ROOT)),kat=row['kat'],host_board=row['host_board'])
    if label.endswith('-kat'):
        raw=(p.parent/'raw.log').read_text()
        bh={(int(d),int(i)):h for d,i,h in re.findall(r'BOARD_KAT degree=(\d+) index=(\d+) match=\d equation=PASS actual=([0-9a-f]+)',raw)}
        host=(ROOT/'build'/('host-'+backend+'-kat')/'raw.log').read_text()
        hh={(int(d),int(i)):h for d,i,h in re.findall(r'KEY_KAT degree=(\d+) seed=test(\d+) match=\d actual=([0-9a-f]+)',host)}
        assert len(bh)==300 and bh==hh,label+' host/board key hash mismatch'
        board[label]['host_board_key_digests']=300
summary['board']=board
extra={}
for backend in ('reference','q32_trial'):
    p=ROOT/'build'/('host-'+backend+'-extended')
    manifest=json.loads((p/'manifest.json').read_text())
    assert manifest['returncode']==0
    assert all(manifest['source'][f.name]==sha(f) for f in (ROOT/backend).glob('*.[chs]'))
    text=(p/'raw.log').read_text();assert 'EXTRA_DONE count=2000 equation_and_range=PASS' in text
    extra[backend]={(int(d),int(i)):h for d,i,h in re.findall(r'EXTRA_KEY degree=(\d+) index=(\d+) digest=(\w+)',text)}
assert len(extra['reference'])==2000 and extra['reference']==extra['q32_trial']
summary['additional_host_keys']=dict(count=2000,mismatches=0,equation_and_range='PASS')
stages=(ROOT/'build/host-q32_trial-stages/raw.log').read_text()
rows=re.findall(r'AUDIT_K case=(\S+) differences=(\d+) valid=(\d+)',stages)
assert len(rows)==28 and all(d=='0' and v=='1' for _,d,v in rows)
summary['frozen_cases']=dict(count=28,k_mismatches=0,invalid=0)
summary['intermediate_cases_with_numeric_differences']={}
for stage,d in re.findall(r'AUDIT_STAGE case=\S+ stage=(\S+) .*differences=(\d+)',stages):
    dd=summary['intermediate_cases_with_numeric_differences'];dd[stage]=dd.get(stage,0)+(int(d)>0)
probe=json.loads((ROOT/'build/floor-probe/summary.json').read_text())
assert probe['header_sha256']==sha(ROOT/'q32_trial/kgen_inner.h')
summary['primitive_probe']=probe
summary['host_signature_kat']={}
for backend in ('reference','native','q32_trial'):
    log=(ROOT/'build'/('host-'+backend+'-kat')/'raw.log').read_text()
    tail=log[log.index('Test KAT:'):]
    summary['host_signature_kat'][backend]='PASS' if ' done.' in tail else 'FAIL'
summary['candidate_crypto_changes']=[p.name for p in (ROOT/'native').glob('*.[chs]') if sha(p)!=sha(ROOT/'q32_trial'/p.name)]
assert sorted(summary['candidate_crypto_changes'])==['kgen_fxp.c','kgen_inner.h']
summary['source_sha256']={b:{p.name:sha(p) for p in (ROOT/b).glob('*.[chs]')} for b in ('reference','native','q32_trial')}
(ROOT/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
print(json.dumps({k:v for k,v in summary.items() if k!='source_sha256'},indent=2))
