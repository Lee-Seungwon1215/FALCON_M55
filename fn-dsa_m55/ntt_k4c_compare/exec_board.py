#!/usr/bin/env python3
"""Untimed, read-only capture of FLEXMEM at the existing debugger stops."""
import importlib.util
from pathlib import Path

COMMON = Path(__file__).resolve().parent.parent/'measurement_mlkem_native'
spec = importlib.util.spec_from_file_location('paired_tcm_loader', COMMON/'exec_with_tcm_init.py')
loader = importlib.util.module_from_spec(spec)
spec.loader.exec_module(loader)
previous = loader.exec_wrapper.build_run_script

def build_run_script(**kwargs):
    lines = previous(**kwargs)
    for phase in ('START','END'):
        at = lines.index('echo TCM_MSCR_'+phase+'=')
        lines[at:at] = ['echo TCM_CONTROL_'+phase+'=',
                        'output/x *(unsigned int*)0x56008008', 'echo \\n']
    return lines

loader.exec_wrapper.build_run_script = build_run_script
if __name__ == '__main__': raise SystemExit(loader.exec_wrapper.main())
