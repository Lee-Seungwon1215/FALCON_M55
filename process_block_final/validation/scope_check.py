"""Standalone integration scope: only the local sha3 process_block changes."""
import hashlib
from pathlib import Path
import re
HERE=Path(__file__).resolve().parent; ROOT=HERE.parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def check_scope(source=None):
    reference=ROOT/'sha3_cm4.s'
    assert sha(reference)=='b313a4da7943202e97ed6753c71ebbf20d9fb9e2f44ce7cd67007e2461b6c830'
    candidate=source or ROOT/'sha3_cm55.s'
    accepted={sha(p):p.stem for p in (HERE/'candidates').glob('*.s')}
    assert sha(candidate) in accepted,'unrecorded implementation; review and snapshot before measuring'
    a=reference.read_text();b=candidate.read_text()
    # Definitions do not emit bytes: object audit also checks the 1284 helper bytes.
    def directives(t):return re.sub(r'^\s*\.(?:cpu|file)\b.*\n','',t,flags=re.M)
    marker='\t.size\tbit_merge_5, .-bit_merge_5\n'
    aa=a[:a.index(marker)+len(marker)]
    bb=b[:b.index(marker)+len(marker)]
    assert directives(aa)==directives(bb),'helper/inject source changed'
    assert a[a.index('process_block_RC:\n'):]==b[b.index('process_block_RC:\n'):],'round constants changed'
    other={}
    for p in ROOT.iterdir():
        if p.suffix not in ('.c','.h','.s') or p.name=='sha3_cm55.s':continue
        baseline=ROOT.parent/'process_block'/p.name
        if baseline.exists():
            other[p.name]=sha(p)==sha(baseline)
    assert all(other.values()),{k:v for k,v in other.items() if not v}
    return dict(checkpoint=accepted[sha(candidate)],helpers_inject_source_unchanged=True,
                constants_unchanged=True,other_crypto_sources_equal_to_process_block=other)
if __name__=='__main__':print(check_scope())
