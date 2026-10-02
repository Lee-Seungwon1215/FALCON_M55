#!/usr/bin/env python3
"""Archive a candidate's own sources before the next direct source edit."""
import hashlib
import json
import sys
import tarfile
from pathlib import Path

root=Path(__file__).resolve().parent.parent
candidate,label=sys.argv[1:]
assert candidate in ('A_tw_bridge','B_continuous_ds')
assert label.replace('_','').isalnum()
out=root/'validation/source_snapshots'
out.mkdir(exist_ok=True)
target=out/(label+'.tar.gz')
assert not target.exists(),target
files=sorted(p for p in (root/candidate).iterdir() if p.is_file())
with tarfile.open(target,'w:gz') as archive:
    for p in files:archive.add(p,arcname=candidate+'/'+p.name)
(out/(label+'.json')).write_text(json.dumps({
    'candidate':candidate,'label':label,
    'sha256':{p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in files}
},indent=2)+'\n')
print(target)
