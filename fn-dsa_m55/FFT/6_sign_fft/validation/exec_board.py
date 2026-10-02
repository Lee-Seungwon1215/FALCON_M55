#!/usr/bin/env python3
"""Established loader, plus read-only diagnostics outside timed execution."""
import importlib.util
from pathlib import Path

workspace = Path(__file__).resolve().parents[4]
spec = importlib.util.spec_from_file_location('sign_fft_board', workspace / 'fn-dsa_m55/ntt_final_compare/exec_board.py')
board = importlib.util.module_from_spec(spec)
spec.loader.exec_module(board)
previous = board.loader.exec_wrapper.build_run_script

def build_run_script(**kwargs):
    lines = previous(**kwargs)
    at = lines.index('load') + 1
    lines[at:at] = ['compare-sections']
    at = lines.index('echo TCM_CONTROL_END=')
    lines[at:at] = [
        'if *(unsigned int*)0xe000ed28 != 0',
        'echo [[EXTENDED-FAULT-DIAGNOSTIC]]\\n',
        'echo VTOR_FPCCR_FPCAR:\\n', 'x/wx 0xe000ed08', 'x/3wx 0xe000ef34',
        'echo VECTOR_WORDS:\\n', 'x/16wx 0x10000000',
        'echo MEMSYSCTL:\\n', 'x/24wx 0xe001e000',
        'echo PSP_EXTENDED:\\n', 'x/96wx $psp',
        'echo MSP_EXTENDED:\\n', 'x/48wx $msp', 'end',
    ]
    return lines

board.loader.exec_wrapper.build_run_script = build_run_script
if __name__ == '__main__':
    raise SystemExit(board.loader.exec_wrapper.main())
