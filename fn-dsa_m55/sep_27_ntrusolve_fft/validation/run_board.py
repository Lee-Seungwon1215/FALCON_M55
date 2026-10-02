#!/usr/bin/env python3
"""Exclusive hardware measurement with frozen ELF/source provenance."""
import fcntl
import hashlib
import json
import os
import re
import shlex
import shutil
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path

ROOT=Path(__file__).resolve().parent.parent
M55=ROOT.parent
COMMON=M55/'measurement_mlkem_native'
candidate,mode=sys.argv[1:]
assert candidate in ('baseline_m55','baseline_ntt','A_tw_bridge','B_continuous_ds')
assert mode in ('keygen','profile','kat','extra','sigkat','arithmetic','kernel','encoding','rounding','decoding','fixed_input','input_pair','input_predicate','division','fixed_division','twiddle','twiddle_fft','fixed_fft','rootmul','fft_alignment','fft_placement','fft_context','fft_replay','profile_probe','fft_fusion','invnorm','security_invnorm','security_api')
crypto=ROOT/candidate
build=ROOT/'validation/build'/candidate/mode
elf=build/'zephyr/zephyr.elf'
locks=[]
for p in (COMMON/'n657-board.lock',M55/'function_compare/fft_native_fp64/build/board.lock'):
    f=p.open('a');fcntl.flock(f,fcntl.LOCK_EX|fcntl.LOCK_NB);locks.append(f)
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
commands=json.loads((build/'compile_commands.json').read_text())
own=[r for r in commands if Path(r['file']).parent in (crypto,build/'generated')]
assert len(own)>=23
for r in own:
    flags=shlex.split(r['command'])
    assert [f for f in flags if f.startswith('-mfpu=')][-1]=='-mfpu=fpv5-d16'
    assert [f for f in flags if re.fullmatch('-O[0-3sgz]',f)][-1]=='-O3'
    assert all(f in flags for f in ('-mcpu=cortex-m55','-ffp-contract=off','-fno-fast-math'))
    # A cryptographic compilation unit from another source folder is forbidden.
for r in commands:
    p=Path(r['file'])
    if p.name in {x.name for x in crypto.glob('*.[cs]')}:
        assert p.parent in (crypto,build/'generated'),p
files=list(crypto.glob('*.[chs]'))
files+=list((ROOT/'validation').glob('*.[ch]'))
files+=list((ROOT/'validation/generated').glob('*.h'))
if mode=='extra':files+=list((ROOT/'validation/fixtures').glob('*.h'))
if mode=='arithmetic':
    files+=list((ROOT/'validation/arithmetic').glob('*.c'))
    files+=[ROOT/'validation/host/initial_q32_rules.h']
if mode=='kernel':files+=list((ROOT/'validation/kernel').glob('*.[ch]'))
if mode=='encoding':files+=list((ROOT/'validation/encoding').glob('*.[ch]'))
if mode=='rounding':files+=list((ROOT/'validation/rounding').glob('*.[ch]'))
if mode=='decoding':files+=list((ROOT/'validation/decoding').glob('*.[ch]'))
if mode=='fixed_input':files+=list((ROOT/'validation/fixed_input').glob('*.[ch]'))
if mode=='input_pair':files+=[ROOT/'validation/fixed_input'/f for f in ('pair_board.c','pair_trial.s','oracle.h')]
if mode=='input_predicate':files+=[ROOT/'validation/fixed_input'/f for f in ('predicate_board.c','predicate_trial.s','oracle.h')]
if mode=='division':files+=list((ROOT/'validation/division').glob('*.[ch]'))
if mode=='fixed_division':files+=list((ROOT/'validation/fixed_division').glob('*.[ch]'))
if mode in ('twiddle','twiddle_fft'):files+=list((ROOT/'validation/twiddle').glob('*.[chs]'))
if mode=='fixed_fft':files+=[ROOT/'validation/twiddle/integration_board.c']
if mode=='invnorm':files+=[ROOT/'validation/invnorm/board.c']
if mode=='security_invnorm':files+=[ROOT/'validation/security/invnorm_audit.c']
if mode=='security_api':files+=[ROOT/'validation/security/api_audit.c']
if mode=='rootmul':files+=list((ROOT/'validation/rootmul').glob('*.[ch]'))
if mode=='fft_alignment':files+=[ROOT/'validation/twiddle'/f for f in ('alignment.s','alignment_board.c')]
if mode=='fft_placement':files+=[ROOT/'validation/twiddle'/f for f in ('placement_helpers.s','placement_board.c','generate_placement.py')]
if mode=='fft_context':files+=[ROOT/'validation/twiddle'/f for f in ('alignment.s','context_board.c')]
if mode=='fft_replay':files+=[ROOT/'validation/twiddle'/f for f in ('replay.c','generate_replay.py')]
if mode=='profile_probe':files+=[ROOT/'validation/twiddle'/f for f in ('integration_board.c','generate_probe.py')]
if mode=='fft_fusion':files+=[ROOT/'validation/twiddle'/f for f in ('fusion_board.c','fused_trial.s','fused_fft.c','table.h','generate_fusion_cases.py')]
files+=list((build/'generated').glob('*')) if mode in ('profile','fft_replay','profile_probe') else []
files+=[ROOT/'validation'/n for n in ('CMakeLists.txt','build.sh','run_board.py','generate_integration_profile.py')]
files+=[build/'fndsa_dtcm_linker.ld']
for p in files:
    if p.suffix in ('.c','.h','.s'):assert p.stat().st_mtime<=elf.stat().st_mtime,('Stale ELF',p)
before={str(p):sha(p) for p in files}
out=ROOT/'validation/results'/candidate/mode/datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ')
out.mkdir(parents=True,exist_ok=False)
shutil.copy2(elf,out/'benchmark.elf')
shutil.copy2(build/'compile_commands.json',out/'compile_commands.json')
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
    run=subprocess.run([sys.executable,str(M55/'ntt_final_compare/exec_board.py'),'--verbose',str(elf)],
        env=env,stdout=f,stderr=subprocess.STDOUT)
raw=(out/'raw.log').read_text();clean=re.sub(r'Info : [^\n]*\n','',raw)
errors=[]
if run.returncode:errors.append('runner exit '+str(run.returncode))
for reg in ('CFSR','HFSR','AFSR'):
    if re.findall(r'^'+reg+r'=(0x[0-9a-f]+)$',clean,re.M)!=['0x0']:errors.append(reg)
for phase in ('START','END'):
    if 'TCM_CONTROL_'+phase+'=0x99' not in clean:errors.append('TCM '+phase)
    m=re.search('TCM_MSCR_'+phase+r'=(0x[0-9a-f]+)',clean)
    if not m or int(m[1],16)&0x12!=2:errors.append('ECC '+phase)
if mode in ('keygen','profile','profile_probe'):
    if clean.count('KEYGEN_DONE count=200 mismatches=0')!=1:errors.append('keygen completion')
    if len(re.findall(r'^KEYGEN_PERF .*match=1 equation=PASS',clean,re.M))!=200:errors.append('keygen rows')
    if mode in ('profile','profile_probe'):
        totals=re.findall(r'^IPRO_TOTAL .*errors=(\d+)$',clean,re.M)
        if totals!=['0','0']:errors.append('profile totals')
    if mode=='profile_probe':
        if clean.count('FIXED_FFT_DONE cases=5120 failures=0')!=1:errors.append('profile probe completion')
        if len(re.findall(r'^FIXED_FFT logn=',clean,re.M))!=20:errors.append('profile probe timing rows')
        if 'FIXED_FFT_FAIL' in clean:errors.append('profile probe mismatch')
elif mode in ('kat','extra'):
    if clean.count('BOARD_KAT_DONE result=0 count=300 mismatches=0')!=1:errors.append('KAT completion')
    if len(re.findall(r'^BOARD_KAT .*match=1 equation=PASS',clean,re.M))!=300:errors.append('KAT rows')
elif mode=='arithmetic':
    if clean.count('Q32_DONE decode=261120 raw=1000000 mul=1000000 failures=0')!=1:errors.append('arithmetic completion')
    if 'Q32_FAIL' in clean:errors.append('arithmetic failure')
elif mode=='encoding':
    if not re.search(r'^ENCODE_DONE words=1000000 from_big=\d+ failures=0$',clean,re.M):
        errors.append('encoding completion')
    if 'ENCODE_FAIL' in clean or 'FROM_BIG_FAIL' in clean:errors.append('encoding mismatch')
    if not re.search(r'^SELECT_DONE cases=\d+ full=\d+ failures=0$',clean,re.M):
        errors.append('selection completion')
    if 'SELECT_FAIL' in clean:errors.append('selection mismatch')
    if clean.count('FUSED_INPUT_DONE cases=63552 failures=0')!=1:
        errors.append('fused input completion')
    if 'FUSED_INPUT_FAIL' in clean:errors.append('fused input mismatch')
    if clean.count('FASTSUM_EDGES values=5242880 failures=0')!=1:
        errors.append('encoder fastsum edge completion')
    if 'FASTSUM_FAIL' in clean:errors.append('encoder fastsum mismatch')
elif mode=='rounding':
    if not re.search(r'^ROUND_DONE cases=\d+ values=\d+ failures=0$',clean,re.M):
        errors.append('rounding completion')
    if 'ROUND_FAIL' in clean:errors.append('rounding mismatch')
elif mode=='decoding':
    if clean.count('MUL4_DONE values=1000484 failures=0')!=1:
        errors.append('raw four-lane product completion')
    if clean.count('SPAN_DONE classes=48 failures=0')!=1:
        errors.append('fused product operand classes')
    if clean.count('CACHED_DONE products=560 classes=48 guards=1 immutable=1 failures=0')!=1:
        errors.append('immutable multiplier cache validation')
    if not re.search(r'^DECODE_DONE values=\d+ products=640 failures=0$',clean,re.M):
        errors.append('decoding completion')
    if 'DECODE_FAIL' in clean:errors.append('decoding mismatch')
    if clean.count('SURROUND_DONE inverse=320 division=640 failures=0')!=1:
        errors.append('reciprocal/division completion')
elif mode=='division':
    if not re.search(r'^DIV4_DONE cases=\d+ values=\d+ failures=0$',clean,re.M):
        errors.append('four-lane division completion')
    if 'DIV4_FAIL' in clean:errors.append('four-lane division mismatch')
elif mode=='fixed_division':
    if not re.search(r'^FXDIV_DONE cases=\d+ values=\d+ inverse=\d+ failures=0$',clean,re.M):
        errors.append('fixed-array division completion')
    if 'FXDIV_FAIL' in clean:errors.append('fixed-array division mismatch')
elif mode=='twiddle':
    if clean.count('TWIDDLE_DONE values=1228864 table_cases=49056 alias=256 failures=0')!=1:
        errors.append('twiddle completion')
    if len(re.findall(r'^TWIDDLE_TIMING ',clean,re.M))!=512:errors.append('twiddle timing rows')
    if 'TWIDDLE_FAIL' in clean:errors.append('twiddle mismatch')
elif mode=='twiddle_fft':
    if clean.count('TWFFT_DONE cases=5760 failures=0')!=1:errors.append('twiddle FFT completion')
    if len(re.findall(r'^TWFFT logn=',clean,re.M))!=360:errors.append('twiddle FFT timing rows')
    if 'TWFFT_FAIL' in clean:errors.append('twiddle FFT mismatch')
elif mode=='rootmul':
    if clean.count('ROOTMUL_DONE values=1001024 classes=32 guards=1 roots_unchanged=1 failures=0')!=1:
        errors.append('bounded root multiplication completion')
    if len(re.findall(r'^ROOTMUL_TIMING ',clean,re.M))!=32:errors.append('root multiplication timing rows')
    if 'ROOTMUL_FAIL' in clean:errors.append('root multiplication mismatch')
elif mode=='security_invnorm':
    if clean.count('SEC_DONE failures=0 timing_is_proof=0')!=1:errors.append('security invnorm correctness')
    if len(re.findall(r'^SEC_ACCURACY ',clean,re.M))!=9:errors.append('security invnorm accuracy rows')
    if len(re.findall(r'^SEC_TIMING ',clean,re.M))!=20:errors.append('security invnorm timing rows')
    # Completion is NOT a timing-pass criterion: independent statistical review required.
elif mode=='security_api':
    if not re.search(r'^SEC_API_DONE valid=64 rejected=\d+ failures=0 guards=0$',clean,re.M):errors.append('security API completion')
    if len(re.findall(r'^SEC_API degree=',clean,re.M))!=64:errors.append('security API rows')
elif mode=='invnorm':
    if clean.count('INVNORM_DONE guards=0 fallback=0 decisions=0')!=1:errors.append('invnorm completion')
    if clean.count('INVNORM_DECISIONS cases=640 failures=0')!=1:errors.append('invnorm decision checks')
    if len(re.findall(r'^INVNORM_ACCURACY ',clean,re.M))!=1:errors.append('invnorm accuracy')
    if len(re.findall(r'^INVNORM_PERF ',clean,re.M))!=2:errors.append('invnorm performance rows')
    if len(re.findall(r'^INVNORM_TIMING ',clean,re.M))!=64:errors.append('invnorm timing rows')
elif mode=='fixed_fft':
    if clean.count('FIXED_FFT_DONE cases=5120 failures=0')!=1:errors.append('production fixed FFT completion')
    if len(re.findall(r'^FIXED_FFT logn=',clean,re.M))!=20:errors.append('production fixed FFT timing rows')
    if 'FIXED_FFT_FAIL' in clean:errors.append('production fixed FFT mismatch')
elif mode=='fft_alignment':
    if clean.count('ALIGN_FFT_DONE cases=2048 failures=0')!=1:errors.append('FFT alignment completion')
    if len(re.findall(r'^ALIGN_FFT logn=',clean,re.M))!=128:errors.append('FFT alignment timing rows')
    if 'ALIGN_FFT_FAIL' in clean:errors.append('FFT alignment mismatch')
elif mode=='fft_placement':
    if clean.count('PLACEMENT_DONE cases=2304 failures=0')!=1:errors.append('FFT placement completion')
    if len(re.findall(r'^PLACEMENT n=',clean,re.M))!=144:errors.append('FFT placement timing rows')
    if 'PLACEMENT_FAIL' in clean:errors.append('FFT placement failure')
elif mode=='fft_context':
    if clean.count('CONTEXT_DONE cases=1152 failures=0')!=1:errors.append('FFT context completion')
    if len(re.findall(r'^CONTEXT logn=',clean,re.M))!=144:errors.append('FFT context timing rows')
    if 'CONTEXT_FAIL' in clean:errors.append('FFT context mismatch')
elif mode=='fft_replay':
    if clean.count('REPLAY_DONE calls=96 failures=0')!=1:errors.append('FFT replay completion')
    if len(re.findall(r'^REPLAY logn=',clean,re.M))!=18:errors.append('FFT replay timing rows')
    if clean.count('KEYGEN_DONE count=200 mismatches=0')!=1:errors.append('replay keygen completion')
    if len(re.findall(r'^KEYGEN_PERF .*match=1 equation=PASS',clean,re.M))!=200:errors.append('replay keygen rows')
elif mode=='fft_fusion':
    if clean.count('FUSION_DONE butterflies=16576 transforms=3840 failures=0')!=1:errors.append('FFT fusion completion')
    if len(re.findall(r'^FUSION logn=',clean,re.M))!=60:errors.append('FFT fusion timing rows')
    if 'FUSION_FAIL' in clean:errors.append('FFT fusion mismatch')
elif mode=='fixed_input':
    if not re.search(r'^FIXED_INPUT_DONE cases=\d+ failures=0$',clean,re.M):
        errors.append('fixed input completion')
    if 'FIXED_INPUT_FAIL' in clean:errors.append('fixed input mismatch')
elif mode=='input_pair':
    if clean.count('PAIR_INPUT_DONE cases=68608 failures=0')!=1:errors.append('paired-limb conversion completion')
    if len(re.findall(r'^PAIR_INPUT_CT ',clean,re.M))!=96:errors.append('paired-limb timing classes')
    if len(re.findall(r'^PAIR_INPUT_TIMING ',clean,re.M))!=33:errors.append('paired-limb size timings')
    if 'PAIR_INPUT_FAIL' in clean:errors.append('paired-limb conversion mismatch')
elif mode=='input_predicate':
    if clean.count('PRED_INPUT_DONE cases=220672 failures=0')!=1:errors.append('predicate conversion completion')
    if len(re.findall(r'^PRED_INPUT_CT ',clean,re.M))!=192:errors.append('predicate timing classes')
    if len(re.findall(r'^PRED_INPUT_TIMING ',clean,re.M))!=75:errors.append('predicate size timings')
    if 'PRED_INPUT_FAIL' in clean:errors.append('predicate conversion mismatch')
elif mode=='kernel':
    if clean.count('KERNEL_DONE checks=640')!=1:errors.append('kernel completion')
    if len(re.findall(r'^KERNEL logn=',clean,re.M))!=20:errors.append('kernel rows')
    if 'KERNEL_TIMER_FAIL' in clean or re.search(r'\b(fixed|pack|run|unpack)=0\b',clean):
        errors.append('kernel timer not running')
    if candidate=='A_tw_bridge' and clean.count('DIV_DONE classes=16 failures=0')!=1:
        errors.append('division checks')
else:
    if clean.count('BOARD_SIGNKAT_DONE count=90 mismatches=0')!=1:errors.append('signature completion')
    if len(re.findall(r'^BOARD_SIGNKAT .*match=1 verify=PASS tamper=PASS',clean,re.M))!=90:errors.append('signature rows')
if before!={str(p):sha(p) for p in files}:errors.append('source modified during run')
manifest=dict(candidate=candidate,mode=mode,crypto_root=str(crypto),elf_sha256=sha(out/'benchmark.elf'),
 raw_sha256=sha(out/'raw.log'),source_sha256=before,compile_commands=own,errors=errors,valid_measurement=not errors)
(out/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
for line in clean.splitlines():
    if re.search(r'(DONE|SUMMARY|IPRO_TOTAL|KEYGEN_HW|match=0|HFSR=|CFSR=)',line):print(line)
print('BOARD_END',out,'errors=',errors,flush=True)
sys.exit(bool(errors))
