"""Append measurement adapters in a different section; never edit reference ASM."""
import hashlib
import json
from pathlib import Path
import sys

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
SOURCE = ROOT / 'Final_code/Before_slothy/sha3_cm4.s'
out = Path(sys.argv[1])
out.mkdir(parents=True, exist_ok=True)
original = SOURCE.read_bytes()
adapter = (HERE / 'adapters.s').read_bytes()
(out / 'sha3_benchmark.s').write_bytes(original + b'\n' + adapter)
vectors = []
for n in (0, 3, 135, 136, 137, 272, 1024):
    msg = bytes((29 * i + 7) & 255 for i in range(n))
    expected = hashlib.shake_256(msg).digest(256)
    vectors.append('{%d, {%s}}' % (n, ','.join(str(b) for b in expected)))
(out / 'vectors.h').write_text(
    'static const struct { unsigned len; uint8_t digest[256]; } shake_vectors[] = {\n'
    + ',\n'.join(vectors) + '\n};\n')
hashes = {str(p): hashlib.sha256(p.read_bytes()).hexdigest()
          for p in (ROOT / 'Final_code/Before_slothy').iterdir()
          if p.suffix in ('.c', '.h', '.s')}
(out / 'sources.json').write_text(json.dumps(dict(
    original_sha256=hashes,
    generated_sha256={p.name: hashlib.sha256(p.read_bytes()).hexdigest()
                      for p in out.iterdir() if p.name != 'sources.json'}), indent=2) + '\n')
