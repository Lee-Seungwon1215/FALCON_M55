#!/usr/bin/env python3
"""Check preserved parents and independent candidates against copy manifest."""
import hashlib
import json
from pathlib import Path
import re

here=Path(__file__).resolve().parent
m=json.loads((here/'copy_manifest.json').read_text())
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(Path(m['archive']))==m['archive_sha256']
for name,h in m['full_x4_parent'].items():assert sha(here.parent/name)==h,('root changed',name)
for name,h in m['prefix'].items():assert sha(here/'ref_prefix'/name)==h,('prefix changed',name)
allowed={'shake_independent4.c','shake_independent4.h','fndsa_batch4.h','sign.c','sign_core.c'}
changed={}
for name in ('A_four_only','B_three_plus','C_two_plus'):
    paths=[here/name/p for p in m['full_x4_parent']]
    assert all(p.is_file() and not p.is_symlink() for p in paths)
    diff=[p.name for p in paths if sha(p)!=m['full_x4_parent'][p.name]]
    assert set(diff)==allowed,(name,diff)
    changed[name]=diff
    assert (here/name/'build/libfndsa_m55.a').is_file()
for p in m['full_x4_parent']:
    texts=[]
    for n in ('A_four_only','B_three_plus','C_two_plus'):
        t=(here/n/p).read_text()
        if p=='shake_independent4.c':
            t=re.sub(r'if \(active < [234]\)', 'if (active < POLICY)',t)
            t=t.replace(n,'CANDIDATE')
        texts.append(t)
    assert texts[0]==texts[1]==texts[2],('unintended candidate difference',p)
report=dict(parent_unchanged=True,prefix_unchanged=True,archive_verified=True,
    standalone_libraries_built=True,candidate_sources_differ_only_in_threshold=True,changed_files=changed)
(here/'source_audit.json').write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps(report,indent=2))
