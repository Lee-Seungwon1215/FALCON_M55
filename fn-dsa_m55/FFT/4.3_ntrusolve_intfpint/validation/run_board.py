#!/usr/bin/env python3
"""Serialized M55 run; cryptographic code comes from exactly one local tree."""
import fcntl, hashlib, json, os, re, shlex, subprocess, sys
from pathlib import Path
from datetime import datetime, timezone
ROOT=Path(__file__).resolve().parent.parent
M55=ROOT.parents[1]
COMMON=M55/'measurement_mlkem_native'
kind,=sys.argv[1:]
mapping={'kat_invnorm':'board_kat.c','kat':'board_kat.c','sigkat':'board_signkat.c','ds':'board_ds.c','fixtures':'board_real_cases.c',
 'kernels':'board_kernels.c','breakdown':'board_breakdown.c',**{a+b:'board_keygen_perf.c' for a in ('keygen_','keylayout_') for b in ('current','ntt','ref')}}
mapping['extra']='board_extra_kat.c'
mapping['q32timing']='board_q32_timing.c'
mapping['bridge_compare']='board_bridge_compare.c'
assert kind in mapping
crypto=M55/'M55_ref' if kind.endswith('_ref') else M55/'ntt_opt' if kind.endswith('_ntt') else ROOT
locks=[]
for p in (COMMON/'n657-board.lock', M55/'function_compare/fft_native_fp64/build/board.lock'):
    f=p.open('a'); fcntl.flock(f,fcntl.LOCK_EX|fcntl.LOCK_NB); locks.append(f)
build=ROOT/'validation/build'/kind
elf=build/'zephyr/zephyr.elf'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
commands=json.loads((build/'compile_commands.json').read_text())
rows=[r for r in commands if Path(r['file']).parent==crypto]
assert len(rows)==(26 if crypto==ROOT else 24 if crypto.name=='ntt_opt' else 23),len(rows)
controls=[r for r in commands if Path(r['file']).parent==ROOT/'validation/bridge_control'] if kind=='bridge_compare' else []
if kind=='bridge_compare': assert len(controls)==4
for row in rows+controls:
    flags=shlex.split(row['command'])
    assert [f for f in flags if f.startswith('-mfpu=')][-1]=='-mfpu=fpv5-d16'
    assert [f for f in flags if re.fullmatch(r'-O[0-3sgz]',f)][-1]=='-O3'
    assert all(f in flags for f in ('-mcpu=cortex-m55','-ffp-contract=off','-fno-fast-math',
        '-DFNDSA_ASM_CORTEXM4=1','-DFNDSA_ASM_CORTEXM55=1'))
files=list(crypto.glob('*.[chs]'))+list((ROOT/'validation/generated').glob('*.h'))
files += [ROOT/'validation'/n for n in (mapping[kind],'CMakeLists.txt','build.sh','run_board.py')]
if kind in ('kernels','breakdown'): files += [ROOT/'validation/ref_fxp.c']
if kind=='fixtures': files += [ROOT/'validation/fixtures/real_cases.h']
files += [build/'fndsa_dtcm_linker.ld']
if kind=='extra': files += [ROOT/'validation/fixtures/extra_kat.h']
if kind=='bridge_compare':
    subprocess.run([sys.executable,str(ROOT/'validation/prepare_bridge_control.py'),'--check'],check=True)
    files += list((ROOT/'validation/bridge_control').iterdir())
    files += [ROOT/'validation/prepare_bridge_control.py']
    files += [ROOT/'validation/bridge_workspace.h']
for p in files:
    if p.suffix in ('.c','.h','.s'): assert p.stat().st_mtime<=elf.stat().st_mtime, 'Stale ELF: '+str(p)
before={str(p):sha(p) for p in files}
out=ROOT/'validation/results'/kind/datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ')
out.mkdir(parents=True,exist_ok=False)
tool=COMMON/'env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin'
env=os.environ.copy()
env.update(FNDSA_LOADER_MODE='upstream',
 MLKEM_NATIVE_PINNED_ROOT=str(COMMON/'env/mlkem-native-637d076aa113d8faaec2277ed4a46b657acaf35f'),
 OPENOCD=str(COMMON/'env/openocd-4e9b167/bin/openocd'),OPENOCD_SERIAL='003C00223335510735383531',
 OPENOCD_SPEED='8000',OPENOCD_TRANSPORT='swd',OPENOCD_SCRIPTS=str(COMMON/'env/openocd-4e9b167/share/openocd/scripts'),
 OPENOCD_INTERFACE='interface/stlink.cfg',OPENOCD_TARGET='target/stm32n6x.cfg',GDB_PORT='3359',
 GDB_RUN_TIMEOUT='1800',SWO_TRACECLK='100000000',SWO_PIN_FREQ='1000000',SWO_FORMATTER='0',
 GDB=str(tool/'arm-none-eabi-gdb'),NM=str(tool/'arm-none-eabi-nm'),READELF=str(tool/'arm-none-eabi-readelf'),
 PYTHONDONTWRITEBYTECODE='1')
print('BOARD_START',out,flush=True)
with (out/'raw.log').open('w') as f:
    run=subprocess.run([sys.executable,str(M55/'ntt_final_compare/exec_board.py'),'--verbose',str(elf)],env=env,stdout=f,stderr=subprocess.STDOUT)
raw=(out/'raw.log').read_text(); clean=re.sub(r'Info : [^\n]*\n','',raw)
errors=[]
if run.returncode: errors.append('runner exit '+str(run.returncode))
for r in ('CFSR','HFSR','AFSR'):
    if re.findall(r'^'+r+r'=(0x[0-9a-f]+)$',clean,re.M)!=['0x0']:errors.append(r)
for phase in ('START','END'):
    if 'TCM_CONTROL_'+phase+'=0x99' not in clean:errors.append('TCM '+phase)
    m=re.search('TCM_MSCR_'+phase+r'=(0x[0-9a-f]+)',clean)
    if not m or int(m[1],16)&0x12!=2:errors.append('ECC '+phase)
if kind in ('kat','kat_invnorm','extra'):
    if clean.count('BOARD_KAT_DONE result=0 count=300 mismatches=0')!=1:errors.append('KAT')
    if len(re.findall(r'^BOARD_KAT .*match=1 equation=PASS',clean,re.M))!=300:errors.append('KAT rows')
elif kind=='q32timing':
    if clean.count('Q32_TIMING_DONE rows=72')!=1:errors.append('Q32 timing completion')
    if len(re.findall(r'^Q32_TIMING ',clean,re.M))!=72:errors.append('Q32 timing rows')
elif kind=='bridge_compare':
    if len(re.findall(r'^BRIDGE_PERF ',clean,re.M))!=100:errors.append('bridge performance rows')
    if len(re.findall(r'^BRIDGE_ACCURACY ',clean,re.M))!=14:errors.append('bridge accuracy rows')
    if clean.count('BRIDGE_DONE batches=5 perf_rows=100 accuracy_rows=14 canary_errors=0 mismatches=0')!=1:errors.append('bridge output/canary check')
elif kind=='sigkat':
    if clean.count('BOARD_SIGNKAT_DONE count=90 mismatches=0')!=1:errors.append('signature KAT')
    if len(re.findall(r'^BOARD_SIGNKAT .*match=1 verify=PASS tamper=PASS',clean,re.M))!=90:errors.append('signature rows')
elif kind=='ds':
    if clean.count('C_DIAGNOSTIC_DONE')!=1:errors.append('DS completion')
    if len(re.findall(r'^C_SEGMENT ',clean,re.M))!=14:errors.append('DS segment rows')
    if len(re.findall(r'^C_TIMING ',clean,re.M))!=42:errors.append('DS timing rows')
    if len(re.findall(r'^C_KERNEL ',clean,re.M))!=84:errors.append('DS kernel rows')
    if clean.count('C_ROUND count=18576 differences=0')!=1:errors.append('DS round boundaries')
elif kind=='fixtures':
    if clean.count('C_FIXTURE_DONE cases=6 modes=4')!=1:errors.append('DS fixture completion')
elif kind=='kernels':
    if 'HYBRID_KERNEL_DONE' not in clean:errors.append('kernel completion')
elif kind=='breakdown':
    if clean.count('BREAKDOWN_DONE calls=400 mismatches=0')!=1:errors.append('breakdown completion')
    if len(re.findall(r'^BREAKDOWN n=.* calls=100 ',clean,re.M))!=4:errors.append('breakdown rows')
else:
    if clean.count('KEYGEN_DONE count=200 mismatches=0')!=1:errors.append('keygen KAT')
    if len(re.findall(r'^KEYGEN_PERF .*match=1 equation=PASS',clean,re.M))!=200:errors.append('keygen rows')
if before!={str(p):sha(p) for p in files}:errors.append('source modified during run')
manifest=dict(kind=kind,crypto_root=str(crypto),elf=str(elf),elf_sha256=sha(elf),
 raw_sha256=sha(out/'raw.log'),source_sha256=before,compile_commands=rows,
 measurement_control_commands=controls,errors=errors,
 valid_measurement=not errors,diagnostic_integer_layout=kind.startswith('keylayout_'))
(out/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
for line in clean.splitlines():
    if re.search(r'(DONE|SUMMARY|HYBRID_|C_KERNEL|C_SEGMENT|C_TIMING|C_ROUND|C_FIXTURE|BRIDGE_|match=0|FAULT|HFSR=|CFSR=)',line):print(line)
print('BOARD_END',out,'errors=',errors,flush=True)
sys.exit(bool(errors))
