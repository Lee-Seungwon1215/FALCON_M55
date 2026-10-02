#!/usr/bin/env python3
"""Reuse the existing loader; additionally READ TCM configuration via GDB.

These reads happen at the existing start/end stops, outside timed regions.
No SYSCFG, clock, cache, ECC, or wait-state setting is written by this wrapper.
"""
import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parent
MEAS = ROOT.parents[1] / 'measurement_mlkem_native'
spec = importlib.util.spec_from_file_location('layout_tcm_loader', MEAS / 'exec_with_tcm_init.py')
loader = importlib.util.module_from_spec(spec)
spec.loader.exec_module(loader)
previous = loader.exec_wrapper.build_run_script


def build_run_script(**kwargs):
    lines = previous(**kwargs)
    for phase in ('START', 'END'):
        at = lines.index('echo TCM_MSCR_' + phase + '=')
        lines[at:at] = ['echo TCM_CONTROL_' + phase + '=',
                        'output/x *(unsigned int*)0x56008008', 'echo \\n']
    return lines


loader.exec_wrapper.build_run_script = build_run_script
if __name__ == '__main__':
    raise SystemExit(loader.exec_wrapper.main())
