#!/usr/bin/env python3
"""Serial final checks on one board; stop on any failed evidence gate."""
import subprocess,sys
from pathlib import Path
runner=Path(__file__).with_name('run_board.py')
if '--b-only' in sys.argv:
    tasks=[('B_continuous_ds',m) for m in ('encoding','fixed_input','kat','keygen','extra','sigkat','profile','kernel','rounding','decoding','division')]
else:
    tasks=[('A_tw_bridge',m) for m in ('fixed_fft','fixed_input','fixed_division','kat','keygen','extra','sigkat','profile','kernel')]
    if '--a-only' not in sys.argv:
        tasks += [('B_continuous_ds',m) for m in ('sigkat','profile')]
for candidate,mode in tasks:
    print('SUITE_TASK',candidate,mode,flush=True)
    subprocess.run([sys.executable,str(runner),candidate,mode],check=True)
print('SUITE_DONE tasks='+str(len(tasks)),flush=True)
