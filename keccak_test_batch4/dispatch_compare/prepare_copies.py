#!/usr/bin/env python3
"""One-time, byte-identical candidate copies; never rewrite existing work."""
from pathlib import Path
import hashlib
import json
import shutil
import tarfile

HERE=Path(__file__).resolve().parent
ROOT=HERE.parent
names=('ref_prefix','A_four_only','B_three_plus','C_two_plus')
assert all(not (HERE/n).exists() for n in names),'Existing candidates: refusing to overwrite'
sources=[p for p in ROOT.iterdir() if p.suffix in ('.c','.h','.s') or p.name=='Makefile']
for n in names:
    dest=HERE/n;dest.mkdir()
    for p in sources:shutil.copy2(p,dest/p.name)
archive=ROOT/'full_x4_validation/baseline/prefix_only_20261001.tar.gz'
with tarfile.open(archive) as ar:
    for m in ar:
        p=Path(m.name)
        assert len(p.parts)==1 and m.isfile(),m.name
        if p.suffix in ('.c','.h','.s') or p.name=='Makefile':
            (HERE/'ref_prefix'/p.name).write_bytes(ar.extractfile(m).read())
manifest={'archive':str(archive),'archive_sha256':hashlib.sha256(archive.read_bytes()).hexdigest(),
 'full_x4_parent':{p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in sources},
 'prefix':{p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in (HERE/'ref_prefix').iterdir()}}
(HERE/'copy_manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
print('Created independent source trees:',', '.join(names))
