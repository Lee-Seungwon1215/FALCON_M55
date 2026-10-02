#!/usr/bin/env python3
"""Use the unchanged established runner with a read-only TCM-register hook."""
import importlib.util
from pathlib import Path
import re
import subprocess

ROOT = Path(__file__).resolve().parent
spec = importlib.util.spec_from_file_location(
    'layout_board_runner', ROOT.parents[1] / 'ntt_opt_3rdStage/run_stage3.py')
runner = importlib.util.module_from_spec(spec)
spec.loader.exec_module(runner)
runner.ROOT = ROOT
runner.CANDIDATES = {name: (ROOT.parent / ('slothy' + name[0]), ROOT / 'build' / name)
                     for name in ('A_low', 'B_low', 'A_high', 'B_high')}
original_popen = subprocess.Popen
original_validate = runner.validate_measurements


def validate_measurements(raw, pilot):
    samples, errors = original_validate(raw, pilot)
    controls = re.findall(r'^TCM_CONTROL_(START|END)=(0x[0-9a-f]+)$', raw, re.M)
    if controls != [('START', '0x99'), ('END', '0x99')]:
        errors.append('TCM control differs from expected unchanged 0x00000099')
    return samples, errors


runner.validate_measurements = validate_measurements


def diagnostic_popen(command, *args, **kwargs):
    if len(command) > 1 and command[1] == str(runner.MEAS / 'exec_with_tcm_init.py'):
        command[1] = str(ROOT / 'exec_layout.py')
        # Mutate the runner's list so its final run.json records the real command.
        # The pre-launch run.json is provisional and overwritten on completion.
    return original_popen(command, *args, **kwargs)


if __name__ == '__main__':
    subprocess.Popen = diagnostic_popen
    try:
        raise SystemExit(runner.main())
    finally:
        subprocess.Popen = original_popen
