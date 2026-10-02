"""Read-only cross-image/source audit; a measurement, not a crypto selector."""
from pathlib import Path
import hashlib
import json
import subprocess

HERE=Path(__file__).resolve().parent;ROOT=HERE.parent
tool=ROOT/'fn-dsa_m55/measurement_mlkem_native/env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin'
names=('ref','batch4','single_mve')
dirs={'ref':ROOT/'Final_code/Before_slothy','batch4':ROOT/'keccak_test_batch4','single_mve':ROOT/'fn-dsa_m55/keccak_shake'}
changed={'sign.c','sign_core.c','sign_inner.h','sign_sampler.c'}
hashes={}
commands=json.loads((HERE/'build/ref/compile_commands.json').read_text())
required={Path(c['file']).name for c in commands if Path(c['file']).parent==dirs['ref']}
required.update(p.name for p in dirs['ref'].glob('*.h'))
for name,d in dirs.items():
    hashes[name]={p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in d.iterdir() if p.suffix in ('.c','.h','.s')}
    for n,h in hashes['ref'].items():
        if n not in required:continue
        if name=='batch4' and n in changed:continue
        if name=='single_mve' and n=='sha3_cm4.s':continue
        assert hashes[name].get(n)==h,(name,'source differs',n)
symbols={}
for name in names:
    elf=HERE/'build'/name/'zephyr/zephyr.elf'
    lines=subprocess.check_output([str(tool/'arm-none-eabi-nm'),'-S',str(elf)],text=True).splitlines()
    tab={}
    for line in lines:
        a=line.split()
        if len(a)==4 and a[2] in 'TtRrBbDd':tab[a[3]]=(int(a[0],16),int(a[1],16),a[2])
    symbols[name]=tab
    assert 'fndsa_keccakx4_permute' not in tab,(name,'x4 unexpectedly reachable')
    assert 'fndsa_sign_seeded_batch4_temp' not in tab,(name,'batch API unexpectedly linked')
ref=symbols['ref'];count=0
for sym,entry in ref.items():
    addr,size,kind=entry
    if not sym.startswith('fndsa_') and sym not in ('sk','pk','sig','workspace','z_main_stack'):continue
    if 0x10000400<=addr<0x10003000:continue
    for name in names[1:]:assert symbols[name].get(sym)==entry,(name,'layout differs',sym,entry,symbols[name].get(sym))
    count+=1
out={'source_hashes':hashes,'symbols':symbols,'identical_common_symbols':count,
     'batch_api_linked':False,'x4_kernel_linked':False}
(HERE/'build/layout_audit.json').write_text(json.dumps(out,indent=2)+'\n')
print('PASS sources; common symbols',count,'; existing single APIs only; x4 absent')
