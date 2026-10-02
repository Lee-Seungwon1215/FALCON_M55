"""Read-only audit of copied reference and unchanged production arithmetic."""
from pathlib import Path
import re

HERE=Path(__file__).resolve().parent
PROD=HERE.parent
ROOT=PROD.parent
original=ROOT/'Final_code/Before_slothy'
changed={'sign.c','sign_core.c','sign_sampler.c','sign_inner.h',
         'kgen.c','kgen_gauss.c','vrfy.c'}
for p in PROD.iterdir():
    q=original/p.name
    if p.suffix in ('.c','.h','.s') and q.exists() and p.name not in changed:
        assert p.read_bytes()==q.read_bytes(),p
for p in (HERE/'reference').iterdir():
    s=p.read_text()
    s=re.sub(r'\breference_(fndsa_[A-Za-z0-9_]+)',r'\1',s)
    assert s==(original/p.name).read_text(),p
kernel=(PROD/'sha3x4_cm55.s').read_text().split('/* Each lane is stored')[0]
old=(ROOT/'keccak_test_hybrid/sha3x4_cm55.s').read_text().split('/* Four lo/high pairs')[0]
assert kernel==old,'Permutation changed'
assert 'subseed' not in (PROD/'sign_core.c').read_text()
print('PASS original reference: names only; unchanged arithmetic; identical x4 permutation')
