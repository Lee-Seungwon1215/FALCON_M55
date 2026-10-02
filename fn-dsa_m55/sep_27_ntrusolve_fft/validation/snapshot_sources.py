#!/usr/bin/env python3
"""One-time, non-overwriting source snapshots; no build artifacts are copied."""
import hashlib
import json
import shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
M55 = ROOT.parent


def snapshot(source, name):
    dest = ROOT/name
    dest.mkdir(exist_ok=True)
    records = {}
    for p in sorted(source.iterdir()):
        if not p.is_file() or not (p.suffix in ('.c','.h','.s') or p.name == 'LICENSE'):
            continue
        d = dest/p.name
        if d.exists():
            raise RuntimeError('refusing to overwrite '+str(d))
        shutil.copy2(p, d)
        records[p.name] = hashlib.sha256(p.read_bytes()).hexdigest()
    (dest/'origin.json').write_text(json.dumps(dict(source=str(source), files=records),indent=2)+'\n')
    print('SNAPSHOT',name,len(records))


if __name__ == '__main__':
    snapshot(M55/'M55_ref','baseline_m55')
    snapshot(M55/'ntt_opt','baseline_ntt')
    snapshot(M55/'ntt_opt','A_tw_bridge')
    snapshot(M55/'ntt_opt','B_continuous_ds')
