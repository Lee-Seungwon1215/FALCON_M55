#!/usr/bin/env python3
"""Generate a pinned, local Zephyr linker adaptation; never edit the SDK.

Vectors/text remain in ITCM. Read-only tables and initialized data are loaded
directly into DTCM (LMA == VMA), followed by BSS/noinit/stack. The existing
startup data copy is therefore a self-copy, not an extended-ITCM data read.
"""
import hashlib
from pathlib import Path
import sys

source, destination = map(Path, sys.argv[1:])
original = source.read_text()
assert hashlib.sha256(source.read_bytes()).hexdigest() == (
    "8f2a52b63d99c2112657df508dc01ad047c5d60ffb4f0678b0afdebe73e12828")

def replace_once(text, old, new):
    assert text.count(old) == 1, old
    return text.replace(old, new)

text = replace_once(original, "\tSECTION_PROLOGUE(.ARM.exidx,,)", """
    /* Local STM32N657 TCM workaround: no global constants in ITCM. */
    __fndsa_itcm_end = .;
#undef ROMABLE_REGION
#define ROMABLE_REGION RAM
    . = RAM_ADDR;
    SECTION_PROLOGUE(.ARM.exidx,,)""")
# Same reserved object slots for original and optimized implementations.
# Match archive member names, not external candidate implementations. Do not
# KEEP unused functions: ordinary --gc-sections remains in force on both sides.
text = replace_once(text, '\t*(.text)\n\t*(".text.*")', '''
    . = ALIGN(256);
    __compare_q_start = .;
    *mq.c.obj(.text .text.*)
    *mq_cm4.s.obj(.text .text.*)
    *mq_cm55.s.obj(.text .text.*)
    __compare_q_end = .;
    . = __compare_q_start + 0x3000;
    __compare_mp_start = .;
    *kgen_mp31.c.obj(.text .text.*)
    *kgen_mp31_cm55.s.obj(.text .text.*)
    __compare_mp_end = .;
    . = __compare_q_start + 0x5000;
    __compare_common_text = .;
    *(.text)
    *(".text.*")''')
text = replace_once(text, '\t*(.rodata)\n\t*(".rodata.*")', '''
    . = ALIGN(256);
    __compare_ntt_rodata_start = .;
    *mq.c.obj(.rodata .rodata.*)
    *mq_cm4.s.obj(.rodata .rodata.*)
    *mq_cm55.s.obj(.rodata .rodata.*)
    *kgen_mp31.c.obj(.rodata .rodata.*)
    *kgen_mp31_cm55.s.obj(.rodata .rodata.*)
    __compare_ntt_rodata_end = .;
    . = __compare_ntt_rodata_start + 0x6000;
    __compare_common_rodata = .;
    *(.rodata)
    *(".rodata.*")''')
text += '''
ASSERT(__compare_q_end <= __compare_q_start + 0x3000, "q-NTT text slot overflow")
ASSERT(__compare_mp_end <= __compare_mp_start + 0x2000, "RNS text slot overflow")
ASSERT(__compare_ntt_rodata_end <= __compare_ntt_rodata_start + 0x6000, "NTT constants slot overflow")
'''
# Both sides of the upstream preprocessor conditional contain this expression.
assert text.count("MPU_ALIGN(__rodata_region_end - ADDR(rom_start));") == 2
text = text.replace("MPU_ALIGN(__rodata_region_end - ADDR(rom_start));",
                    "MPU_ALIGN(__rodata_region_end - __rodata_region_start);")
text = replace_once(text,
    "\t__rom_region_end = __rom_region_start + . - ADDR(rom_start);",
    "\t__rom_region_end = __fndsa_itcm_end;")
text = replace_once(text, "#if ROM_ADDR != RAM_ADDR\n\t. = RAM_ADDR;\n#endif",
    "/* Keep the RAM cursor after read-only tables; do not overlap them. */")
text = replace_once(text, "\t_image_ram_start = .;",
                    "\t_image_ram_start = RAM_ADDR;")
text = replace_once(text,
    "_flash_used = LOADADDR(.last_section) + SIZEOF(.last_section) - __rom_region_start;",
    "_flash_used = __fndsa_itcm_end - __rom_region_start;")
text += "\nASSERT(__fndsa_itcm_end <= 0x10020000, \"text exceeds 128 KiB\")\n"
text += "__fndsa_dtcm_loaded_end = ALIGN(ADDR(.last_section) + SIZEOF(.last_section), 8);\n"
text += "ASSERT(_image_ram_end <= 0x30040000, \"DTCM overflow\")\n"
text += "ASSERT(__data_region_load_start == __data_region_start, \"data not direct-loaded\")\n"
text += "ASSERT(__fndsa_dtcm_loaded_end <= __bss_start, \"scrub would miss BSS\")\n"
destination.write_text(text)
