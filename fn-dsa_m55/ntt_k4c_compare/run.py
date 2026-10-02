#!/usr/bin/env python3
"""Paired API benchmark with strict source/build provenance and board checks."""
import argparse
import fcntl
import hashlib
import importlib.util
import json
from pathlib import Path
import re
import shlex
import shutil
import socket
import sys

sys.dont_write_bytecode = True
ROOT = Path(__file__).resolve().parent
M55 = ROOT.parent
COMMON = M55 / 'measurement_mlkem_native'
SOURCES = {'ref': M55/'M55_ref', 'ntt_opt': M55/'ntt_opt'}
RUNNER_PATH = ROOT/'board_runner.py'
spec = importlib.util.spec_from_file_location('paired_runner', RUNNER_PATH)
runner = importlib.util.module_from_spec(spec)
spec.loader.exec_module(runner)
runner.ROOT, runner.MEAS = ROOT, COMMON

def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()

def manifest(variant):
    source = SOURCES[variant]
    build = ROOT/'build'/variant
    commands = json.loads((build/'compile_commands.json').read_text())
    compiled = []
    for row in commands:
        p = Path(row['file']).resolve()
        if p.parent != source:
            assert ROOT/'app' in p.parents or COMMON in p.parents or build in p.parents, p
            continue
        assert p.is_file() and not p.is_symlink(), p
        args = shlex.split(row['command'])
        assert [x for x in args if x.startswith('-O')][-1] == '-O3'
        assert '-DFNDSA_ASM_CORTEXM4=1' in args
        assert '-DFNDSA_ASM_CORTEXM55=1' in args
        assert ('-DFNDSA_MVE_MP31=1' in args) == (variant == 'ntt_opt')
        compiled.append(p.name)
    asm = 'mq_cm4.s' if variant == 'ref' else 'mq_cm55.s'
    assert asm in compiled and 'kgen_mp31.c' in compiled
    assert ('kgen_mp31_cm55.s' in compiled) == (variant == 'ntt_opt')
    sources = {p.name: sha(p) for p in sorted(source.iterdir()) if p.suffix in ('.c','.h','.s')}
    if variant == 'ref':
        historical = json.loads((COMMON/'audit-dtcm/build_manifest.json').read_text())['sources']
        assert all(h == historical[n]['m55_sha256'] for n,h in sources.items())
    else:
        assert sources['kgen_mp31_cm55.s'] == 'bad74cbe6f569a948b70f887b47cc0c5fc9f7e6130605df27adb70f3d88ece88', 'Not selected K4C'
        assert sources['mq_cm55.s'] == '0d1c14bed961466f649d1d818732d82ba3d1f1cf87c2ca441b37edaecf5d13f9', 'q-NTT source changed'
        baseline = SOURCES['ref']
        for name, digest in sources.items():
            if name not in ('inner.h', 'kgen_mp31.c', 'mq.c', 'mq_cm55.s', 'kgen_mp31_cm55.s'):
                assert digest == sha(baseline/name), ('Non-NTT source changed', name)
    helpers = [ROOT/'build.sh', ROOT/'run.py', ROOT/'exec_board.py', RUNNER_PATH,
               COMMON/'exec_with_tcm_init.py', COMMON/'host/pilot.log', COMMON/'host/full.log']
    helpers += sorted(p for p in (ROOT/'app').iterdir() if p.is_file())
    return {'variant': variant, 'source': str(source), 'source_hashes': sources,
            'compiled_sources': sorted(compiled),
            'harness': {str(p): sha(p) for p in helpers},
            'artifacts': {n: sha(build/n) for n in (
                'zephyr/zephyr.elf','zephyr/zephyr.map','zephyr/.config',
                'compile_commands.json','fndsa_dtcm_linker.ld')}}

def main():
    p = argparse.ArgumentParser()
    p.add_argument('variant', choices=SOURCES)
    p.add_argument('action', choices=('record','pilot','full'))
    p.add_argument('--label', default='v1')
    a = p.parse_args()
    build = ROOT/'build'/a.variant
    current = manifest(a.variant)
    record = build/'provenance.json'
    if a.action == 'record':
        record.write_text(json.dumps(current, indent=2)+'\n')
        print('RECORDED', record)
        return 0
    assert re.fullmatch(r'[a-zA-Z0-9_-]+', a.label)
    assert json.loads(record.read_text()) == current, 'source/build/harness changed since build'
    layout = json.loads((ROOT/'results/layout_audit.json').read_text())
    assert layout['valid']
    assert layout['elf_hashes'][a.variant] == current['artifacts']['zephyr/zephyr.elf']
    name = a.variant+'-'+a.label
    approved = ROOT/'results'/name/(a.action+'_validated.json')
    assert not approved.exists(), 'Use a fresh label; do not overwrite a validated run'
    # Hold through measurement and archiving; never interrupt another debug run.
    board_lock = (ROOT/'results/board.lock').open('a')
    fcntl.flock(board_lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
    with socket.socket() as probe:
        assert probe.connect_ex(('127.0.0.1', 3349)) != 0, 'GDB port is already in use'
    original_validate = runner.validate_measurements
    def validate(raw, pilot):
        samples, errors = original_validate(raw, pilot)
        if 'CLOCK_DECODE cpu=800000000 sysclk=400000000 hclk=200000000' not in raw:
            errors.append('clock mismatch')
        ccr = re.search(r'^CORE .*?ccr=([0-9a-f]+)', raw, re.M)
        if ccr is None or int(ccr[1],16) & 0x30000:
            errors.append('cache state missing/enabled')
        if re.findall(r'^TCM_CONTROL_(START|END)=(0x[0-9a-f]+)$', raw,re.M) != [('START','0x99'),('END','0x99')]:
            errors.append('TCM configuration capture missing or mismatched')
        exact = [dict(re.findall(r'(\w+)=(\d+)', s)) for s in re.findall(r'^NTT_EXACT (.+)$',raw,re.M)]
        if [r.get('degree') for r in exact] != ['512','1024'] or any(r.get(k)!='0' for r in exact for k in ('forward_mismatches','roundtrip_mismatches','oracle_roundtrip_mismatches','max_mod_error')):
            errors.append('q-NTT exactness failed')
        if a.variant == 'ntt_opt' and re.findall(r'^NTT_MUL_TABLE kind=barrett3 pairs=2048 mismatches=(\d+) .+$',raw,re.M) != ['0','0']:
            errors.append('Barrett multiplication test failed')
        return samples, errors
    runner.validate_measurements = validate
    runner.CANDIDATES = {name:(SOURCES[a.variant], build)}
    sys.argv = [sys.argv[0],name,a.action]
    original_popen = runner.subprocess.Popen
    def board_popen(command, *args, **kwargs):
        if len(command)>1 and command[1] == str(COMMON/'exec_with_tcm_init.py'):
            command[1] = str(ROOT/'exec_board.py')
        return original_popen(command,*args,**kwargs)
    runner.subprocess.Popen = board_popen
    try:
        rc = runner.main()
    finally:
        runner.subprocess.Popen = original_popen
    if rc: return rc
    approval = json.loads(approved.read_text())
    dest = Path(approval['run_directory'])
    try:
        assert manifest(a.variant) == current
        (dest/'source').mkdir()
        for n in current['source_hashes']:
            shutil.copy2(SOURCES[a.variant]/n, dest/'source'/n)
        for n in ('zephyr.elf','zephyr.map','.config'):
            shutil.copy2(build/'zephyr'/n, dest/n)
        shutil.copy2(record,dest/'provenance.json')
        shutil.copy2(ROOT/'results/layout_audit.json',dest/'layout_audit.json')
    except Exception as exc:
        approval.update(valid=False,validation_error=str(exc))
        approved.write_text(json.dumps(approval,indent=2)+'\n')
        raise
    return 0

if __name__ == '__main__': raise SystemExit(main())
