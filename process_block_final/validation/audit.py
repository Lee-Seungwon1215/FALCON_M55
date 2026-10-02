"""Audit unchanged helper bytes and integrated single-state source boundaries."""
import hashlib
import json
from pathlib import Path
import shlex
import subprocess
import sys
from scope_check import check_scope

HERE = Path(__file__).resolve().parent
variant = sys.argv[1]
mode = sys.argv[2] if len(sys.argv) > 2 else 'kernel'
build = HERE / 'build' / (variant if mode == 'kernel' else variant + '_' + mode)
source = HERE.parent / ('sha3_cm4.s' if variant == 'ref' else 'sha3_cm55.s')
ref = HERE.parent / 'sha3_cm4.s'
scope = check_scope()
commands = json.loads((build / 'compile_commands.json').read_text())
entry = next(e for e in commands if e['file'].endswith('/generated/sha3_benchmark.s')
             or (mode != 'kernel' and Path(e['file']) == source))
args = shlex.split(entry['command'])
linked = Path(entry['directory']) / args[args.index('-o') + 1]
pristine = build / 'pristine_sha3.o'
args[args.index('-o') + 1] = str(pristine)
args[args.index('-c') + 1] = str(ref)
subprocess.run(args, cwd=entry['directory'], check=True)
tool = Path(args[0]).parent
symbols = subprocess.check_output([str(tool / 'arm-none-eabi-nm'), '-n', str(pristine)], text=True)
boundary = int(next(l.split()[0] for l in symbols.splitlines() if l.endswith(' fndsa_sha3_process_block')), 16)
for obj, name in ((pristine, 'original_text.bin'), (linked, 'measured_text.bin')):
    subprocess.run([str(tool / 'arm-none-eabi-objcopy'), '-O', 'binary', '--only-section=.text', str(obj), str(build / name)], check=True)
a, b = ((build / name).read_bytes() for name in ('original_text.bin', 'measured_text.bin'))
assert a[:boundary] == b[:boundary]
if variant == 'ref':
    assert a == b
out = dict(scope=scope, helpers_byte_identical=True, helpers_bytes=boundary,
           text_bytes=len(b), original_text_bytes=len(a),
           source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(), command=entry['command'])
(build / 'audit.json').write_text(json.dumps(out, indent=2) + '\n')
print('INTEGRATION_AUDIT', {k:v for k,v in out.items() if k!='command'})
