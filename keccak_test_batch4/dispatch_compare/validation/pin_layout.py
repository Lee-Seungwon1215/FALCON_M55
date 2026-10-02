#!/usr/bin/env python3
"""Measurement-only placement: changing dispatcher size must not move math."""
from pathlib import Path
import sys

p=Path(sys.argv[1]);s=p.read_text()
for old,new in (
    ('\t*(.text)','\t*(EXCLUDE_FILE (*dispatch_candidate.c.obj) .text)'),
    ('\t*(".text.*")','\t*(EXCLUDE_FILE (*dispatch_candidate.c.obj) .text.*)'),
    ('\t*(.glue_7t) *(.glue_7) *(.vfp11_veneer) *(.v4_bx)',
     '''\t*(.glue_7t) *(.glue_7) *(.vfp11_veneer) *(.v4_bx)
    /* Same-size end slot in every candidate. Production code is unchanged. */
    . = ALIGN(64);
    __dispatch_slot_start = .;
    *dispatch_candidate.c.obj(.text .text.*)
    __dispatch_slot_used_end = .;
    . = __dispatch_slot_start + 6144;
    __dispatch_slot_end = .;''')):
    assert s.count(old)==1,old
    s=s.replace(old,new)
s+='\nASSERT(__dispatch_slot_used_end <= __dispatch_slot_end, "dispatch slot overflow")\n'
p.write_text(s)
