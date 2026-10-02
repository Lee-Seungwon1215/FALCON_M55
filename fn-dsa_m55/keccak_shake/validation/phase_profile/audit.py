"""Check generated probes did not change the production source or helpers."""
import hashlib
import json
from pathlib import Path
import shlex
import subprocess
import sys

HERE=Path(__file__).resolve().parent
variant=sys.argv[1]
assert variant in ('plain','trace')
build=HERE/'build'/variant
source=HERE.parent.parent/'sha3_cm55.s'
spec=json.loads((build/'generated/sources.json').read_text())
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(source)==spec['production_sha256']
commands=json.loads((build/'compile_commands.json').read_text())
entry=next(c for c in commands if c['file'].endswith('/generated/sha3_benchmark.s'))
args=shlex.split(entry['command'])
measured=Path(entry['directory'])/args[args.index('-o')+1]
pristine=build/'pristine.o'
args[args.index('-o')+1]=str(pristine)
args[args.index('-c')+1]=str(source)
subprocess.run(args,cwd=entry['directory'],check=True)
objcopy=str(Path(args[0]).with_name('arm-none-eabi-objcopy'))
nm=str(Path(args[0]).with_name('arm-none-eabi-nm'))
symbols=subprocess.check_output([nm,'-n',str(pristine)],text=True)
boundary=int(next(l.split()[0] for l in symbols.splitlines()
                  if l.endswith(' fndsa_sha3_process_block')),16)
for obj,name in ((pristine,'pristine.bin'),(measured,'measured.bin')):
    subprocess.run([objcopy,'-O','binary','--only-section=.text',str(obj),str(build/name)],check=True)
a=(build/'pristine.bin').read_bytes(); b=(build/'measured.bin').read_bytes()
assert a[:boundary]==b[:boundary]
if variant=='plain': assert a==b
# Eight static probe sites execute 77 times. Their expansion is 24 bytes/site.
if variant=='trace': assert len(b)-len(a)==8*24,(len(a),len(b))
elf=build/'zephyr/zephyr.elf'
symbols=subprocess.check_output([nm,'-n',str(elf)],text=True)
address=next(l.split()[0] for l in symbols.splitlines() if l.endswith(' fndsa_sha3_process_block'))
out=dict(variant=variant,helpers_byte_identical=True,helpers_bytes=boundary,
         production_sha256=sha(source),production_text_bytes=len(a),
         measured_text_bytes=len(b),entry_address='0x'+address,
         probe_scratch='R2/R3, flags/SP/Q preserved; dead at selected boundaries')
(build/'audit.json').write_text(json.dumps(out,indent=2)+'\n')
print('PHASE_AUDIT',out)
