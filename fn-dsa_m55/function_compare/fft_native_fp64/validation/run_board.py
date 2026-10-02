#!/usr/bin/env python3
"""Explicit N657 serial; one board run; preserve failures and host comparison."""
from datetime import datetime, timezone
import fcntl,hashlib,json,os,re,shlex,subprocess,sys
from pathlib import Path
ROOT=Path(__file__).resolve().parent.parent
M55=ROOT.parents[1];COMMON=M55/'measurement_mlkem_native'
backend,kind=sys.argv[1:];assert backend in ('reference','native','q32_trial') and kind in ('stages','kat','sigkat','perfct','keyprofile','repro','guard_repro','first_failure')
lock=(ROOT/'build/board.lock').open('a');fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB)
build=ROOT/'build'/(backend+'-'+kind);source=ROOT/backend;elf=build/'zephyr/zephyr.elf'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
files=list(source.glob('*.[chs]'))+list((ROOT/'validation/generated').glob('*.h'))
files += [ROOT/'validation'/dict(stages='stages.c',kat='board_kat.c',sigkat='board_signkat.c',perfct='perfct.c',keyprofile='keyprofile.c',repro='board_repro.c',guard_repro='board_repro.c',first_failure='first_failure.c')[kind]]
if kind=='first_failure':files.append(ROOT/'validation/failure_trace/probes.c')
if kind=='keyprofile':
    files += [ROOT/'validation'/n for n in ('approx_profile.c','approx_profile.h','generate_approx_profile.py')]
    files += [build/'generated'/n for n in ('kgen_ntru.c','profile_manifest.json')]
    manifest=json.loads((build/'generated/profile_manifest.json').read_text())
    assert manifest['original_sha256']==sha(source/'kgen_ntru.c')
    assert manifest['generated_sha256']==sha(build/'generated/kgen_ntru.c')
    assert manifest['exact_original_recovered_after_removing_hooks']
assert all(p.stat().st_mtime<=elf.stat().st_mtime for p in files),'Rebuild stale ELF'
commands=json.loads((build/'compile_commands.json').read_text())
rows=[r for r in commands if Path(r['file']).parent==source]
if kind=='keyprofile':rows += [r for r in commands if Path(r['file'])==build/'generated/kgen_ntru.c']
assert len(rows)==24,len(rows)
for row in rows:
    args=shlex.split(row['command'])
    assert [x for x in args if x.startswith('-mfpu=')][-1]=='-mfpu=fpv5-d16'
    assert all(x in args for x in ('-O3','-ffp-contract=off','-fno-fast-math','-DFNDSA_ASM_CORTEXM4=1'))
out=ROOT/'results'/(backend+'-'+kind)/datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ')
out.mkdir(parents=True,exist_ok=False)
tool=COMMON/'env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin'
env=os.environ.copy();env.update(FNDSA_LOADER_MODE='upstream',
    MLKEM_NATIVE_PINNED_ROOT=str(COMMON/'env/mlkem-native-637d076aa113d8faaec2277ed4a46b657acaf35f'),
    OPENOCD=str(COMMON/'env/openocd-4e9b167/bin/openocd'),OPENOCD_SERIAL='003C00223335510735383531',
    OPENOCD_SPEED='8000',OPENOCD_TRANSPORT='swd',OPENOCD_SCRIPTS=str(COMMON/'env/openocd-4e9b167/share/openocd/scripts'),
    OPENOCD_INTERFACE='interface/stlink.cfg',OPENOCD_TARGET='target/stm32n6x.cfg',GDB_PORT='3359',GDB_RUN_TIMEOUT='1800',
    SWO_TRACECLK='100000000',SWO_PIN_FREQ='1000000',SWO_FORMATTER='0',GDB=str(tool/'arm-none-eabi-gdb'),
    NM=str(tool/'arm-none-eabi-nm'),READELF=str(tool/'arm-none-eabi-readelf'),PYTHONDONTWRITEBYTECODE='1')
cmd=[sys.executable,str(M55/'ntt_final_compare/exec_board.py'),'--verbose',str(elf)]
print('BOARD_START',out,flush=True)
with (out/'raw.log').open('w') as f:r=subprocess.run(cmd,env=env,stdout=f,stderr=subprocess.STDOUT)
raw=(out/'raw.log').read_text();clean=re.sub(r'Info : [^\n]*\n','',raw)
errors=[]
if r.returncode:errors.append('runner exit '+str(r.returncode))
for name in ('CFSR','HFSR','AFSR'):
    if re.findall(r'^'+name+r'=(0x[0-9a-f]+)$',clean,re.M)!=['0x0']:errors.append(name)
for phase in ('START','END'):
    if 'TCM_CONTROL_'+phase+'=0x99' not in clean:errors.append('TCM '+phase)
    m=re.search('TCM_MSCR_'+phase+r'=(0x[0-9a-f]+)',clean)
    if not m or int(m[1],16)&0x12!=2:errors.append('ECC '+phase)
comparison=None;kat=None
if kind=='stages':
    if clean.count('AUDIT_DONE result=0 cases=28')!=1:errors.append('completion')
    hostlog=ROOT/'build'/('host-'+backend+'-stages')/'raw.log'
    wanted=[l for l in hostlog.read_text().splitlines() if l.startswith(('AUDIT_STAGE ','AUDIT_VALUE ','AUDIT_K ','AUDIT_K_VALUE '))]
    got=[l for l in clean.splitlines() if l.startswith(('AUDIT_STAGE ','AUDIT_VALUE ','AUDIT_K ','AUDIT_K_VALUE '))]
    comparison=dict(lines=len(got),matches=got==wanted)
    if got!=wanted:errors.append('host/board mismatch')
elif kind=='kat':
    m=re.search(r'BOARD_KAT_DONE result=(\d+) count=(\d+) mismatches=(\d+)',clean)
    if not m or int(m[2])!=300:errors.append('KAT incomplete')
    if m:kat=dict(result=int(m[1]),count=int(m[2]),mismatches=int(m[3]))
elif kind=='sigkat':
    m=re.search(r'BOARD_SIGNKAT_DONE count=(\d+) mismatches=(\d+)',clean)
    if not m or int(m[1])!=90:errors.append('signature KAT incomplete')
    if m:kat=dict(count=int(m[1]),mismatches=int(m[2]))
elif kind=='perfct':
    if clean.count('PERFCT_DONE cases=19')!=1:errors.append('perfct incomplete')
    if 'COUNTEREXAMPLE_BOARD fixed=00000000ffffffff trial=3ff0000000000000 fixed_k=0 trial_k=1' not in clean:
        errors.append('host/board counterexample mismatch')
elif kind=='keyprofile':
    if clean.count('APRO_DONE count=200 mismatches=0')!=1:errors.append('profile incomplete')
    keys=re.findall(r'^APRO_KEY degree=(\d+) index=(\d+) match=1 equation=PASS actual=(\w+)$',clean,re.M)
    if len(keys)!=200 or {(int(d),int(i)) for d,i,h in keys}!={(d,i) for d in (512,1024) for i in range(100)}:
        errors.append('profile key KAT incomplete')
    if len(re.findall(r'^APRO degree=',clean,re.M))!=153:errors.append('profile counters incomplete')
    kat=dict(count=len(keys),mismatches=clean.count('match=0'))
elif kind in ('repro','guard_repro'):
    if clean.count('REPRO_DONE count=5')!=1:errors.append('repro incomplete')
    expected=json.loads((ROOT/'results/followup-host/20260923T060455Z/summary.json').read_text())['mismatches']
    # guard_repro must reproduce the ORIGINAL fixed result, never the old
    # incorrect candidate digest. The stored reference oracle is unchanged.
    expected_backend='reference' if backend=='reference' or kind=='guard_repro' else 'candidate'
    wanted={(x['degree'],x['index']):x[expected_backend] for x in expected}
    got={(int(a),int(b)):d for a,b,d in re.findall(r'REPRO degree=(\d+) index=(\d+) digest=(\w+) verify=PASS tamper=PASS',clean)}
    comparison=dict(lines=len(got),matches=got==wanted,oracle=expected_backend)
    if got!=wanted:errors.append('repro host/board mismatch')
else:
    if clean.count('FIRST_FAILURE_DONE cases=5 errors=0')!=1:errors.append('first failure probe incomplete')
    wanted=[l for l in (ROOT/'build/host-first-failure.log').read_text().splitlines() if l.startswith('FIRST_')]
    got=[l for l in clean.splitlines() if l.startswith('FIRST_')]
    comparison=dict(lines=len(got),matches=got==wanted)
    if len(got)!=11 or got!=wanted:errors.append('first failure host/board mismatch')
data=dict(valid_measurement=not errors,errors=errors,backend=backend,kind=kind,
          kat=kat,host_board=comparison,elf_sha256=sha(elf),source={str(p):sha(p) for p in files},
          compile_commands_sha256=sha(build/'compile_commands.json'),raw_sha256=sha(out/'raw.log'),command=cmd)
(out/'run.json').write_text(json.dumps(data,indent=2)+'\n')
print(json.dumps({k:data[k] for k in ('valid_measurement','errors','kat','host_board')},indent=2),flush=True)
raise SystemExit(bool(errors))
