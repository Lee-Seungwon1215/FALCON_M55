#!/usr/bin/env python3
"""Copy existing audited measurement harnesses, not production backends."""
import hashlib
import json
import shutil
from pathlib import Path

ROOT=Path(__file__).resolve().parent
M55=ROOT.parent.parent
TW=M55/'function_compare/twfalcon/integration_candidate/validation'
C=M55/'FFT/4.3_ntrusolve_intfpint/validation'
sources={name:TW/name for name in ('board_keygen_perf.c','integration_profile.c',
    'integration_profile.h','generate_integration_profile.py')}
sources.update({name:C/name for name in ('board_kat.c','board_signkat.c','board_extra_kat.c')})
for p in (C/'generated').glob('*.h'): sources['generated/'+p.name]=p
for name in ('extra_kat.h',): sources['fixtures/'+name]=C/'fixtures'/name
records={}
for name,src in sources.items():
    dst=ROOT/name
    assert not dst.exists(),dst
    dst.parent.mkdir(parents=True,exist_ok=True)
    shutil.copy2(src,dst)
    records[name]=dict(source=str(src),sha256=hashlib.sha256(src.read_bytes()).hexdigest())
(ROOT/'harness_origin.json').write_text(json.dumps(records,indent=2)+'\n')
print('HARNESS_COPIES',len(records))
