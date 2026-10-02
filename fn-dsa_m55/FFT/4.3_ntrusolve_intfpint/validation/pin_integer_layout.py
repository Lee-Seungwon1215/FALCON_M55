#!/usr/bin/env python3
"""Diagnostic ONLY: give unchanged big-integer routines identical ITCM addresses.

Runs after the usual local linker generator. No SDK or crypto source changes.
This is a layout control, not a selected optimized implementation.
"""
from pathlib import Path
import sys

p = Path(sys.argv[1])
s = p.read_text()
old = '\t*(.text)'
assert s.count(old) == 1
new = '''
        . = ALIGN(32);
        __ip_zint_start = .;
        *(.text.zint* .text.fndsa_zint*)
        __ip_zint_end = .;
\t*(.text)'''
s = s.replace(old, new)
p.write_text(s)

