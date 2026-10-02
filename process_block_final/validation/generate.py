"""Append measurement adapters in a different section; never edit reference ASM."""
import hashlib
import json
from pathlib import Path
import sys

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
variant = sys.argv[2]
assert variant in ('ref', 'mve')
SOURCE = HERE.parent / ('sha3_cm4.s' if variant == 'ref' else 'sha3_cm55.s')
out = Path(sys.argv[1])
out.mkdir(parents=True, exist_ok=True)
original = SOURCE.read_bytes()
adapter = (HERE / 'adapters.s').read_bytes()
rounds = int(sys.argv[3]) if len(sys.argv)>3 and sys.argv[3] else 24
assert rounds == 24, 'integrated single-state candidate validation always uses all 24 Keccak rounds'
benchmark = (HERE / 'benchmark.c').read_text()
(out / 'benchmark.c').write_text(benchmark)
(out / 'sha3_benchmark.s').write_bytes(original + b'\n' + adapter)
vectors = []
for n in (0, 3, 135, 136, 137, 272, 1024):
    msg = bytes((29 * i + 7) & 255 for i in range(n))
    expected = hashlib.shake_256(msg).digest(256)
    vectors.append('{%d, {%s}}' % (n, ','.join(str(b) for b in expected)))
(out / 'vectors.h').write_text(
    'static const struct { unsigned len; uint8_t digest[256]; } shake_vectors[] = {\n'
    + ',\n'.join(vectors) + '\n};\n')
vectors128 = []
for n in (0, 3, 167, 168, 169, 336, 1024):
    msg = bytes((29 * i + 7) & 255 for i in range(n))
    expected = hashlib.shake_128(msg).digest(384)
    vectors128.append('{%d, {%s}}' % (n, ','.join(str(b) for b in expected)))
with (out / 'vectors.h').open('a') as f:
    f.write('static const struct { unsigned len; uint8_t digest[384]; } shake128_vectors[] = {\n'
            + ',\n'.join(vectors128) + '\n};\n')
hashes = {str(p): hashlib.sha256(p.read_bytes()).hexdigest()
          for p in HERE.parent.iterdir()
          if p.suffix in ('.c', '.h', '.s')}
(out / 'sources.json').write_text(json.dumps(dict(
    diagnostic_rounds=rounds,
    original_sha256=hashes,
    generated_sha256={p.name: hashlib.sha256(p.read_bytes()).hexdigest()
                      for p in out.iterdir() if p.name != 'sources.json'}), indent=2) + '\n')
