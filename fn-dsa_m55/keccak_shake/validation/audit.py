"""Reference helpers must be byte-identical; MVE body is linked directly."""
import hashlib
import json
from pathlib import Path
import shlex
import re
import subprocess
import sys

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[2]
variant=sys.argv[1]
mode=sys.argv[2] if len(sys.argv)>2 else 'kernel'
build=HERE/'build'/(variant if mode=='kernel' else variant+'_'+mode)
source=HERE.parent/('sha3_cm4.s' if variant=='ref' else 'sha3_cm55.s')
ref=HERE.parent/'sha3_cm4.s'
ref_rc=ref.read_text().split('process_block_RC:')[1].split('process_block_RC__end:')[0]
mve_rc=(HERE.parent/'sha3_cm55.s').read_text().split('.Lkeccak_mve_rc:')[1].split('.size fndsa_sha3_process_block')[0]
expected_rc=[int(x,16) for x in re.findall(r'0x[0-9A-Fa-f]+',ref_rc)]
if '@ K_STATE_FORMAT: canonical32' in (HERE.parent/'sha3_cm55.s').read_text():
    canonical=[]
    for j in range(0,len(expected_rc),2):
        z=sum(((expected_rc[j]>>k)&1)<<(2*k) | ((expected_rc[j+1]>>k)&1)<<(2*k+1) for k in range(32))
        canonical += [z&0xffffffff,z>>32]
    expected_rc=canonical
rc_rows=[[int(x.strip(),0) for x in line.split('.word')[1].split(',')]
         for line in mve_rc.splitlines() if '.word' in line]
if '@ K_IOTA: fused_chi' in (HERE.parent/'sha3_cm55.s').read_text():
    assert len(rc_rows)==24 and all(len(r)==8 for r in rc_rows)
    assert all(all(r[j]==0 for j in (1,2,3,5,6,7)) for r in rc_rows), 'RC padding not zero'
    actual_rc=[x for r in rc_rows for x in (r[0],r[4])]
else:
    actual_rc=[x for r in rc_rows for x in r]
assert expected_rc==actual_rc, 'round constants differ'
commands=json.loads((build/'compile_commands.json').read_text())
entry=next(e for e in commands if e['file'].endswith('/generated/sha3_benchmark.s')
    or (mode!='kernel' and Path(e['file'])==source))
args=shlex.split(entry['command'])
linked_object=Path(entry['directory'])/args[args.index('-o')+1]
audit_object=build/'pristine_sha3.o'
args[args.index('-o')+1]=str(audit_object)
args[args.index('-c')+1]=str(ref)
subprocess.run(args,cwd=entry['directory'],check=True)
objcopy=str(Path(args[0]).with_name('arm-none-eabi-objcopy'))
nm=str(Path(args[0]).with_name('arm-none-eabi-nm'))
symbols=subprocess.check_output([nm,'-n',str(audit_object)],text=True)
boundary=int(next(l.split()[0] for l in symbols.splitlines()
                  if l.endswith(' fndsa_sha3_process_block')),16)
for obj,name in ((audit_object,'original_text.bin'),(linked_object,'measured_text.bin')):
    subprocess.run([objcopy,'-O','binary','--only-section=.text',str(obj),str(build/name)],check=True)
a=(build/'original_text.bin').read_bytes()
b=(build/'measured_text.bin').read_bytes()
assert a[:boundary]==b[:boundary]
if variant=='ref': assert a==b
out=dict(helpers_byte_identical=True,helpers_bytes=boundary,text_bytes=len(b),
    original_text_bytes=len(a),text_sha256=hashlib.sha256(b).hexdigest(),
    source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),command=entry['command'])
(build/'audit.json').write_text(json.dumps(out,indent=2)+'\n')
print('HELPERS_BYTE_AUDIT',boundary,'bytes identical; code size',len(b))
