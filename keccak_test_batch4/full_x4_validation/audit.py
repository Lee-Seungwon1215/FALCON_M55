"""Read-only scope/ABI audit; not a proof of constant-time execution."""
from pathlib import Path
import hashlib
import json
import tarfile

here=Path(__file__).resolve().parent
prod=here.parent
with tarfile.open(here/'baseline/prefix_only_20261001.tar.gz') as ar:
    old={m.name:ar.extractfile(m).read() for m in ar if m.isfile()}

# No arithmetic or permutation assembly changed. The revision changes only
# independent-stream scheduling, hashes and their explicit C call sites.
for name in ('sha3_cm4.s','sha3x4_cm55.s','sha3.c','sign_sampler.c','util.c','vrfy.c'):
    assert (prod/name).read_bytes()==old[name],name

a=old['kgen.c'].decode();b=(prod/'kgen.c').read_text()
marker='size_t\nfndsa_keygen_batch4_temp_size'
assert a[:a.index(marker)]==b[:b.index('typedef struct {')]
a=old['kgen_gauss.c'].decode();b=(prod/'kgen_gauss.c').read_text()
marker='void\nsample_f('
assert a[a.index(marker):]==b[b.index(marker):]
a=old['sign_core.c'].decode();b=(prod/'sign_core.c').read_text()
start='\t\t/* Compute the lattice basis'
end='\n/* Ordinary API:'
assert a[a.index(start):a.index(end)]==b[b.index(start):b.index('\nsize_t\nfndsa_sign_core_prefetched')]

# Validate original Before_slothy hashes against every successful run manifest.
results=[]
for m in sorted((here/'results').glob('*/*/manifest.json')):
    record=json.loads(m.read_text())
    if not record['valid']:continue
    sources=json.loads((m.parent/'sources.json').read_text())
    for name,digest in sources.items():
        if '/Final_code/Before_slothy/' in name:
            assert hashlib.sha256(Path(name).read_bytes()).hexdigest()==digest,name
    results.append(str(m.parent.relative_to(here)))
print('PASS: original single keygen/sampler and signing arithmetic unchanged')
print('PASS: existing scalar/x4 permutation ASM and verification source unchanged')
print('PASS: Before_slothy hashes unchanged in',len(results),'successful run archives')
