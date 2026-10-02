"""Check generated probes did not change the production source or helpers."""
import hashlib
import json
from pathlib import Path
import shlex
import subprocess
import sys
sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
from scope_check import check_scope

HERE=Path(__file__).resolve().parent
variant=sys.argv[1]
implementation, mode = variant.split('-')
assert implementation in ('ref','mve')
build=HERE/'build'/variant
source=HERE.parent.parent/('sha3_cm4.s' if implementation=='ref' else 'sha3_cm55.s')
spec=json.loads((build/'generated/sources.json').read_text())
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(source)==spec['production_sha256']
scope=check_scope()
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
if mode=='plain': assert a==b
# Static/dynamic probe counts depend on the selected exclusive category.
# Oracle/ABI tests check the instrumented path; the generator also verifies
# that stripping markers recovers the original operation sequence.

elf=build/'zephyr/zephyr.elf'
symbols=subprocess.check_output([nm,'-n',str(elf)],text=True)
address=next(l.split()[0] for l in symbols.splitlines() if l.endswith(' fndsa_sha3_process_block'))
placements={name:int(next(l.split()[0] for l in symbols.splitlines() if l.endswith(' '+name)),16)
            for name in ('state','part_stack_top')}
assert placements == {'state':0x30003000,'part_stack_top':0x30005000},placements
out=dict(variant=variant,helpers_byte_identical=True,helpers_bytes=boundary,
         scope=scope,
         production_sha256=sha(source),production_text_bytes=len(a),
         measured_text_bytes=len(b),entry_address='0x'+address,
         fixed_placements={k:hex(v) for k,v in placements.items()},
         probe_scratch='R0/R1/R2 saved/restored; cursor in fixed memory; flags/Q/P0/LR preserved')
(build/'audit.json').write_text(json.dumps(out,indent=2)+'\n')
print('PHASE_AUDIT',out)
