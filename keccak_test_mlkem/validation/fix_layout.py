"""Benchmark-only fixed slots. Does not redirect any crypto symbol/source.
 * Keep common code, constants, key buffers and thread stacks in equal places
 * when candidate assembly/C sizes differ. */
"""
from pathlib import Path
import sys
p=Path(sys.argv[1]);s=p.read_text()
def replace(a,b):
 global s
 assert s.count(a)==1,a
 s=s.replace(a,b)
replace('\t*(.text)\n\t*(".text.*")','''
 . = ALIGN(256);
 __x4_text_start = .;
 *sha3x4_cm55.s.obj(.text .text.*)
 *serial_control.c.obj(.text .text.*)
 __x4_asm_end = .;
 . = __x4_text_start + 0x1000;
 *sha3x4.c.obj(.text .text.*)
 __x4_c_end = .;
 . = __x4_text_start + 0x2000;
 *sign_core.c.obj(.text .text.*)
 *sign_sampler.c.obj(.text .text.*)
 __x4_sign_end = .;
 . = __x4_text_start + 0x5000;
 *benchmark.c.obj(.text .text.*)
 __x4_bench_end = .;
 . = __x4_text_start + 0x8000;
 __x4_common_text = .;
 *(.text)
 *(".text.*")''')
replace('\t*(.rodata)\n\t*(".rodata.*")','''
 . = ALIGN(256);
 __x4_ro_start = .;
 *sha3x4_cm55.s.obj(.rodata .rodata.*)
 *sha3x4.c.obj(.rodata .rodata.*)
 *serial_control.c.obj(.rodata .rodata.*)
 __x4_rc_end = .;
 . = __x4_ro_start + 0x100;
 *benchmark.c.obj(.rodata .rodata.*)
 __x4_bench_ro_end = .;
 . = __x4_ro_start + 0x4100;
 __x4_common_ro = .;
 *(.rodata)
 *(".rodata.*")''')
replace('\t*(.bss)\n\t*(".bss.*")','''
 . = ALIGN(256);
 __x4_bss_start = .;
 *benchmark.c.obj(.bss.tmp)
 . = __x4_bss_start + 0xf000;
 *benchmark.c.obj(.bss.sk .bss.pk .bss.sig)
 . = __x4_bss_start + 0x11000;
 *benchmark.c.obj(.bss .bss.*)
 __x4_bss_end = .;
 . = __x4_bss_start + 0x15000;
 *(.bss)
 *(".bss.*")''')
s+='''
ASSERT(__x4_asm_end <= __x4_text_start+0x1000, "x4 ASM slot overflow")
ASSERT(__x4_c_end <= __x4_text_start+0x2000, "x4 C slot overflow")
ASSERT(__x4_sign_end <= __x4_text_start+0x5000, "sign slot overflow")
ASSERT(__x4_bench_end <= __x4_text_start+0x8000, "bench slot overflow")
ASSERT(__x4_rc_end <= __x4_ro_start+0x100, "RC slot overflow")
ASSERT(__x4_bench_ro_end <= __x4_ro_start+0x4100, "bench const slot overflow")
ASSERT(__x4_bss_end <= __x4_bss_start+0x15000, "bench bss slot overflow")
'''
p.write_text(s)
