"""Prove the appended adapters have not changed any byte of original .text."""
import hashlib
import json
from pathlib import Path
import shlex
import subprocess

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[2]
build=HERE/'build'
source=ROOT/'Final_code/Before_slothy/sha3_cm4.s'
commands=json.loads((build/'compile_commands.json').read_text())
entry=next(e for e in commands if e['file'].endswith('/generated/sha3_benchmark.s'))
args=shlex.split(entry['command'])
linked_object=Path(entry['directory'])/args[args.index('-o')+1]
audit_object=build/'pristine_sha3.o'
args[args.index('-o')+1]=str(audit_object)
args[args.index('-c')+1]=str(source)
subprocess.run(args,cwd=entry['directory'],check=True)
objcopy=str(Path(args[0]).with_name('arm-none-eabi-objcopy'))
for obj,name in ((audit_object,'original_text.bin'),(linked_object,'measured_text.bin')):
    subprocess.run([objcopy,'-O','binary','--only-section=.text',str(obj),str(build/name)],check=True)
a=(build/'original_text.bin').read_bytes()
b=(build/'measured_text.bin').read_bytes()
assert a==b and len(a)>1000
out=dict(original_text_byte_identical=True,text_bytes=len(a),text_sha256=hashlib.sha256(a).hexdigest(),
    source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),command=entry['command'])
(build/'audit.json').write_text(json.dumps(out,indent=2)+'\n')
print('ORIGINAL_ASM_BYTE_AUDIT',len(a),'bytes identical')
