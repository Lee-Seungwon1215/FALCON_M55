#!/usr/bin/env python3
"""Measure the integrated Slothy-A source, with strict pilot/full validation."""
import importlib.util
import json
import os
from pathlib import Path
import re
import subprocess
import sys

sys.dont_write_bytecode = True
os.environ['PYTHONDONTWRITEBYTECODE'] = '1'
ROOT = Path(__file__).resolve().parent
SOURCE = ROOT.parent
BUILD = SOURCE / 'build/m55'
spec = importlib.util.spec_from_file_location(
    'integrated_slothy_runner', SOURCE.parent / 'ntt_opt_3rdStage/run_stage3.py')
runner = importlib.util.module_from_spec(spec)
spec.loader.exec_module(runner)
runner.ROOT = ROOT
runner.CANDIDATES = {'integrated': (SOURCE, BUILD)}
original_popen = subprocess.Popen
original_validate = runner.validate_measurements


def validate_measurements(raw, pilot):
    samples, errors = original_validate(raw, pilot)
    controls = re.findall(r'^TCM_CONTROL_(START|END)=(0x[0-9a-f]+)$', raw, re.M)
    if controls != [('START', '0x99'), ('END', '0x99')]:
        errors.append('TCM configuration differs from expected 0x00000099')
    ccr = re.search(r'^CORE .*?ccr=([0-9a-f]+)', raw, re.M)
    if ccr is None or int(ccr[1], 16) & 0x30000:
        errors.append('I/D cache state missing or enabled')
    if 'CLOCK_DECODE cpu=800000000 sysclk=400000000 hclk=200000000' not in raw:
        errors.append('clock configuration mismatch')
    records = [dict(re.findall(r'(\w+)=(\d+)', line))
               for line in re.findall(r'^NTT_EXACT (.+)$', raw, re.M)]
    if ([r.get('degree') for r in records] != ['512', '1024']
        or any(r.get(k) != '0' for r in records for k in (
            'forward_mismatches', 'roundtrip_mismatches', 'oracle_roundtrip_mismatches', 'max_mod_error'))):
        errors.append('NTT exactness/roundtrip test missing or failed')
    if re.findall(r'^NTT_MUL_TABLE kind=barrett3 pairs=2048 mismatches=(\d+) .+$', raw, re.M) != ['0', '0']:
        errors.append('Barrett table test missing or failed')
    return samples, errors


runner.validate_measurements = validate_measurements


def board_popen(command, *args, **kwargs):
    if len(command) > 1 and command[1] == str(runner.MEAS / 'exec_with_tcm_init.py'):
        command[1] = str(ROOT / 'exec_board.py')
    return original_popen(command, *args, **kwargs)


if __name__ == '__main__':
    audit = json.loads((ROOT / 'results/static_audit.json').read_text())
    assert audit['valid']
    assert audit['elf_sha256'] == runner.sha(BUILD / 'zephyr/zephyr.elf')
    assert audit['source_tree_sha256'] == runner.tree_sha(SOURCE)
    sys.argv.insert(1, 'integrated')
    subprocess.Popen = board_popen
    try:
        raise SystemExit(runner.main())
    finally:
        subprocess.Popen = original_popen
