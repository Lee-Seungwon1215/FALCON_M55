"""Bounded static checks for the final hand-written single-state permutation.

This is not a general taint analyzer or a formal constant-time proof.
The accompanying README explains the manual address/data-flow audit.
"""
import hashlib
import json
from pathlib import Path
import re
import subprocess

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[2]
tool=ROOT/'fn-dsa_m55/measurement_mlkem_native/env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin'
elf=HERE/'build/mve/zephyr/zephyr.elf'
nm=subprocess.check_output([str(tool/'arm-none-eabi-nm'),'-S',str(elf)],text=True)
entry=next(l.split() for l in nm.splitlines() if l.endswith(' fndsa_sha3_process_block'))
start,size=int(entry[0],16),int(entry[1],16)
dump=subprocess.check_output([str(tool/'arm-none-eabi-objdump'),'-d',
    f'--start-address={start}',f'--stop-address={start+size}',str(elf)],text=True)
insns=[]
for line in dump.splitlines():
    m=re.match(r'\s*([0-9a-f]+):\s+[0-9a-f ]+\s+([a-z][a-z0-9.]+)\s+(.*)',line)
    if m: insns.append((m[1],m[2],m[3]))
branches=[i for i in insns if i[1].split('.')[0] in
    ('beq','bne','bhi','bls','bgt','blt','bge','ble','bcs','bcc','bmi','bpl','bvs','bvc','cbz','cbnz')]
calls=[i for i in insns if i[1]=='bl']
assert len(branches)==1 and branches[0][1]=='bne.w',branches
assert not calls,calls
assert not any(i[1].split('.')[0] in ('udiv','sdiv','blx','tbb','tbh') for i in insns)
assert any(i[1]=='veor' for i in insns) and any(i[1]=='vbic' for i in insns)
assert not any(i[1].startswith(('vadd.f','vsub.f','vmul.f','vdiv.f')) for i in insns)
src=HERE.parent/'sha3_cm55.s'
obj=json.loads((HERE/'build/mve/audit.json').read_text())
assert obj['source_sha256']==hashlib.sha256(src.read_bytes()).hexdigest()
# Only public address/counter/ABI operations are allowed outside vector ops.
# This checks the emitted instructions, not the source macro spelling.
scalar=[i for i in insns if not i[1].startswith('v')]
allowed={'push','pop','stmdb','ldmia','sub','subs','add','mov','movs','movw','movt','bic','str','ldr','bne'}
assert all(i[1].split('.')[0] in allowed for i in scalar),scalar
abi_memory=[i for i in scalar if i[1].split('.')[0] in ('stmdb','ldmia')]
assert len(abi_memory)==2 and all(i[2].startswith('sp!, {r4,') for i in abi_memory),abi_memory
memory=[i for i in scalar if i[1].split('.')[0] in ('ldr','str')]
assert len(memory)==2 and all('r2, [sp, #928]' in i[2] for i in memory),memory
scalar_bic=[i for i in scalar if i[1].split('.')[0]=='bic']
assert len(scalar_bic)==1 and 'r3, r3, #15' in scalar_bic[0][2],scalar_bic
# Public gather tables: verify inverse coordinates via a separately enumerated
# forward Keccak rho/pi map, plus padding scatter bounds/non-overlap.
source=src.read_text()
table=source.split('.Lkeccak_rhopi_table:')[1]
words=[int(x.strip()) for line in table.splitlines() if '.word' in line
       for x in line.split('.word')[1].split(',')]
rotations=[0,1,62,28,27,36,44,6,55,20,3,10,43,25,39,41,45,15,21,8,18,2,61,56,14]
forward={}
for y in range(5):
    for x in range(5): forward[(y,(2*x+3*y)%5)]=(x,y,rotations[x+5*y])
destinations=[[(x,y) for x in range(4)] for y in range(5)]
destinations += [[(4,y) for y in range(4)]]
cursor=0
for g,dest in enumerate(destinations):
    vectors=[words[cursor+4*i:cursor+4*i+4] for i in range(6)]
    cursor+=24
    for j,d in enumerate(dest):
        x,y,n=forward[d]; a=32*y+4*x; q=4*x
        expect=[a+(160 if n>=32 else 0),a+(0 if n>=32 else 160),
                q+(32 if n>=32 else 0),q+(0 if n>=32 else 32),n%32,n%32-32]
        assert [v[j] for v in vectors]==expect,(g,j)
    if g>=5:
        offsets=words[cursor:cursor+4]; cursor+=4
        assert offsets==[16,64,112,160]
        assert len(set(offsets))==4 and all(0<=x<=236 and x%4==0 for x in offsets)
assert cursor==len(words)==148
# The remaining destination (4,4) is one public predicated MVE lane.
assert forward[(4,4)]==(1,4,2)
tail=source.split('.macro K_RHOPI_LAST')[1].split('.endm')[0]
for fragment in ('q0,[r4,#132]','q1,[r4,#292]','q2,[r7,#4]',
                 'q3,[r7,#36]','q2,q0,#2','q3,q1,#2',
                 'q2,q1,#30','q3,q0,#30','q2,[r5,#208]','q3,[r5,#448]'):
    assert fragment in tail,fragment
assert tail.count('vstrwt.32')==2 and 'vpstt' in tail
assert 'vld20.32' in source and 'vst20.32' in source
assert '@ K_IOTA: fused_chi' in source
out=dict(source_sha256=hashlib.sha256(src.read_bytes()).hexdigest(),
    elf_sha256=hashlib.sha256(elf.read_bytes()).hexdigest(),
    function_address=hex(start),function_size_including_round_constants=size,
    original_function_size=2900,conditional_branches=branches,calls=calls,
    mve_integer_instructions_present=True,floating_point_arithmetic=False,
    helper_bytes_unchanged=obj['helpers_byte_identical'],maximum_stack_bytes=1056,
    all_state_arithmetic_mve=True,scalar_memory_operations=memory,
    public_gather_tables_verified=True,
    scope='All state arithmetic MVE, public 24-round loop and lane-0 predicates; manual address-flow review plus bounded opcode checks, not a formal proof')
(HERE/'static_audit.json').write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps(out,indent=2))
