#!/usr/bin/env python3
"""Run one immutable, locally compiled comparison image on the M55 only."""
import fcntl
import hashlib
import json
import os
from pathlib import Path
import re
import shlex
import shutil
import subprocess
import sys
import tarfile
from datetime import datetime,timezone

HERE=Path(__file__).resolve().parent
M55=HERE.parents[1]
COMMON=M55/'measurement_mlkem_native'
TOOL=COMMON/'env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin'
VARIANTS=('ref','ntt_only','fft_only','ntt_fft')
def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()

def verify_sources():
    spec=json.loads((HERE/'source_manifest.json').read_text())
    for group in ('original_sha256','donor_sha256'):
        for path,h in spec[group].items():assert sha(Path(path))==h, ('external source changed',path)
    for v,info in spec['variants'].items():
        for name,h in info['sha256'].items():assert sha(HERE/'variants'/v/name)==h, (v,name)
    return spec

def main():
    variant=sys.argv[1];mode=sys.argv[2] if len(sys.argv)>2 else 'sign'
    assert variant in VARIANTS and mode in ('sign','sigkat','kat','keyverify')
    spec=verify_sources();crypto=HERE/'variants'/variant
    build=HERE/'build'/(variant+'_'+mode);elf=build/'zephyr/zephyr.elf'
    commands=json.loads((build/'compile_commands.json').read_text())
    expected=set(spec['variants'][variant]['c_sources']+spec['variants'][variant]['s_sources'])
    own=[]
    for r in commands:
        p=Path(r['file']).resolve()
        if p.name not in expected:continue
        assert p.parent==crypto,('foreign implementation',p)
        flags=shlex.split(r['command'])
        assert '-mcpu=cortex-m55' in flags and '-mfloat-abi=hard' in flags
        assert [f for f in flags if f.startswith('-mfpu=')][-1]=='-mfpu=fpv5-d16'
        assert [f for f in flags if re.fullmatch('-O[0-3sgz]',f)][-1]=='-O3'
        assert '-ffp-contract=off' in flags and '-fno-fast-math' in flags
        assert not any(f.startswith('-DFNDSA_') for f in flags)
        own.append(r)
    assert {Path(r['file']).name for r in own}==expected and len(own)==len(expected)
    if mode in ('sign','keyverify'):
        audit_name='layout_audit.json' if mode=='sign' else 'layout_audit_keyverify.json'
        audit=json.loads((HERE/audit_name).read_text())
        assert audit['valid'] and audit['elf_sha256'][variant]==sha(elf)
    files=list(crypto.iterdir())+[p for p in HERE.iterdir() if p.is_file() and p.suffix in ('.c','.py','.txt','.sh','.json')]
    files += [build/'fndsa_dtcm_linker.ld',build/'zephyr/.config',build/'compile_commands.json']
    compiled_inputs=set()
    deps=subprocess.check_output([str(COMMON/'env/build-venv/bin/ninja'),'-C',str(build),'-t','deps'],text=True)
    for line in deps.splitlines():
        if line.startswith('    '):
            p=Path(line.strip())
            if not p.is_absolute():p=build/p
            if p.is_file() and p.suffix in ('.c','.h','.s'):
                files.append(p.resolve());compiled_inputs.add(p.resolve())
    compiled_inputs.update(Path(r['file']).resolve() for r in commands)
    files += list(compiled_inputs)
    files=sorted({p.resolve() for p in files if p.is_file()})
    # A new benchmark C file for another mode must not mark this ELF stale.
    for p in compiled_inputs:
        if p.suffix in ('.c','.h','.s'):assert p.stat().st_mtime<=elf.stat().st_mtime,('stale ELF',p)
    before={str(p):sha(p) for p in files}
    locks=[]
    for p in (COMMON/'n657-board.lock',M55/'function_compare/fft_native_fp64/build/board.lock'):
        f=p.open('a');fcntl.flock(f,fcntl.LOCK_EX|fcntl.LOCK_NB);locks.append(f)
    out=HERE/'results'/(variant+'_'+mode)/datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ')
    out.mkdir(parents=True,exist_ok=False)
    for path,name in ((elf,'benchmark.elf'),(build/'zephyr/zephyr.map','benchmark.map'),
            (build/'compile_commands.json','compile_commands.json'),(build/'zephyr/.config','zephyr.config'),
            (build/'fndsa_dtcm_linker.ld','linker.ld'),(HERE/'source_manifest.json','source_manifest.json')):
        shutil.copy2(path,out/name)
    with tarfile.open(out/'production_sources.tar.gz','w:gz') as t:
        for p in sorted(crypto.iterdir()):
            if p.is_file():t.add(p,arcname=p.name)
    with (out/'disassembly.txt').open('w') as fp:
        subprocess.run([str(TOOL/'arm-none-eabi-objdump'),'-d',str(elf)],stdout=fp,check=True)
    env=os.environ.copy()
    env.update(FNDSA_LOADER_MODE='upstream',
        MLKEM_NATIVE_PINNED_ROOT=str(COMMON/'env/mlkem-native-637d076aa113d8faaec2277ed4a46b657acaf35f'),
        OPENOCD=str(COMMON/'env/openocd-4e9b167/bin/openocd'),
        OPENOCD_SERIAL='003C00223335510735383531',OPENOCD_SPEED='8000',
        OPENOCD_TRANSPORT='swd',OPENOCD_INTERFACE='interface/stlink.cfg',OPENOCD_TARGET='target/stm32n6x.cfg',
        OPENOCD_SCRIPTS=str(COMMON/'env/openocd-4e9b167/share/openocd/scripts'),
        GDB_PORT='3359',GDB_RUN_TIMEOUT='900',SWO_TRACECLK='100000000',SWO_PIN_FREQ='1000000',SWO_FORMATTER='0',
        GDB=str(TOOL/'arm-none-eabi-gdb'),NM=str(TOOL/'arm-none-eabi-nm'),READELF=str(TOOL/'arm-none-eabi-readelf'),
        PYTHONDONTWRITEBYTECODE='1')
    print('BOARD_START',out,flush=True)
    with (out/'raw.log').open('w') as fp:
        run=subprocess.run([sys.executable,str(M55/'FFT/6_sign_fft/validation/exec_board.py'),'--verbose',str(elf)],
            env=env,stdout=fp,stderr=subprocess.STDOUT)
    raw=(out/'raw.log').read_text();clean=re.sub(r'Info : [^\n]*\n','',raw);errors=[]
    if run.returncode:errors.append('runner exit '+str(run.returncode))
    if 'MIS-MATCHED' in clean or 'WARNING: One or more sections of the target image does not match' in clean:errors.append('ELF load mismatch')
    for reg in ('CFSR','HFSR','AFSR'):
        if re.findall('^'+reg+'=(0x[0-9a-f]+)$',clean,re.M)!=['0x0']:errors.append(reg)
    for phase in ('START','END'):
        if 'TCM_CONTROL_'+phase+'=0x99' not in clean:errors.append('TCM '+phase)
        m=re.search('TCM_MSCR_'+phase+'=(0x[0-9a-f]+)',clean)
        if not m or int(m[1],16)&0x12!=2:errors.append('ECC '+phase)
    marker,pattern,count={
        'sign':('SIGN_DONE verify=PASS tamper=PASS fingerprints=PASS',r'^SIGN_SAMPLE ',200),
        'sigkat':('BOARD_SIGNKAT_DONE count=90 mismatches=0',r'^BOARD_SIGNKAT .*match=1 verify=PASS tamper=PASS',90),
        'kat':('BOARD_KAT_DONE result=0 count=300 mismatches=0',r'^BOARD_KAT .*match=1 equation=PASS',300),
        'keyverify':('KEYVERIFY_DONE keypairs=PASS verify=PASS tamper=PASS timer=PASS',r'^KV_SAMPLE ',400),
    }[mode]
    if clean.count(marker)!=1:errors.append('completion')
    if len(re.findall(pattern,clean,re.M))!=count:errors.append('row count')
    if mode=='keyverify':
        if len(re.findall(r'^KV_SUMMARY ',clean,re.M))!=4:errors.append('summary count')
        if len(re.findall(r'^KV_DIGEST ',clean,re.M))!=4:errors.append('digest count')
        if 'KV_TIMER_CHECK result=PASS' not in clean:errors.append('timer cross-check')
    if before!={str(p):sha(p) for p in files}:errors.append('inputs changed during run')
    try:verify_sources()
    except AssertionError as e:errors.append(str(e))
    manifest=dict(variant=variant,mode=mode,source_sha256=before,elf_sha256=sha(out/'benchmark.elf'),
        raw_sha256=sha(out/'raw.log'),compile_commands=own,errors=errors,valid_measurement=not errors)
    (out/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
    for line in clean.splitlines():
        if re.search(r'(SIGN_HW|SIGN_SUMMARY|KV_HW|KV_TIMER_CHECK|KV_SUMMARY|KV_DIGEST|DONE.*(PASS|mismatches|result)|CFSR=|HFSR=)',line):print(line)
    print('BOARD_END',out,'errors=',errors,flush=True)
    return bool(errors)
if __name__=='__main__':sys.exit(main())
