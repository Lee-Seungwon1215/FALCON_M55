#!/usr/bin/env python3
"""Two swapped equally sized kernel slots, below 64 KiB ITCM.
Arithmetic never changes. This checks slot placement sensitivity, not identical
individual function entry addresses. Unrelated code/data stay at fixed addresses.
"""
from pathlib import Path
import subprocess
import sys
source, destination, layout = sys.argv[1:]
assert layout in ('ab', 'ba')
subprocess.run([sys.executable, str(Path(__file__).with_name('base_linker.py')), source, destination], check=True)
p = Path(destination)
text = p.read_text()
slots = [('orig_mq', 12288), ('opt_mq', 12288), ('orig_mp', 6144), ('opt_mp', 6144)]
if layout == 'ba':
    slots = [slots[1], slots[0], slots[3], slots[2]]
lines = ['\t. = ALIGN(4096);', '\t__compare_start = .;']
for i, (name, size) in enumerate(slots):
    lines += [f'\t__slot{i}_start = .;', f'\tKEEP(*(.compare.{name}))',
              f'\tASSERT(. <= __slot{i}_start + {size}, "kernel slot overflow");',
              f'\t. = __slot{i}_start + {size};']
lines += ['\t__compare_end = .;']
needle = '\t*(.text)'
assert text.count(needle) == 1
text = text.replace(needle, '\n'.join(lines) + '\n' + needle)
p.write_text(text)
