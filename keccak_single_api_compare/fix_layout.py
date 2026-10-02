"""Test-only slots: hold unchanged code/data placement fixed in three ELFs."""
from pathlib import Path
import sys
p=Path(sys.argv[1]);s=p.read_text()
def replace(a,b):
 global s
 assert s.count(a)==1,a
 s=s.replace(a,b)
replace('\t*(.text)\n\t*(".text.*")','''
 . = ALIGN(256);
 __single_crypto_slot = .;
 *sha3_cm4.s.obj(.text .text.*)
 *sha3_cm55.s.obj(.text .text.*)
 __single_keccak_end = .;
 . = __single_crypto_slot + 0x1400;
 *sign.c.obj(.text .text.*)
 *sign_core.c.obj(.text .text.*)
 *sign_sampler.c.obj(.text .text.*)
 *shake_batch4.c.obj(.text .text.*)
 __single_sign_end = .;
 . = __single_crypto_slot + 0x2c00;
 __single_common_text = .;
 *(.text)
 *(".text.*")''')
replace('\t*(.rodata)\n\t*(".rodata.*")','''
 . = ALIGN(256);
 __single_ro_slot = .;
 *sha3_cm55.s.obj(.rodata .rodata.*)
 __single_ro_end = .;
 . = __single_ro_slot + 0x400;
 *(.rodata)
 *(".rodata.*")''')
s+='''
ASSERT(__single_keccak_end <= __single_crypto_slot+0x1400, "Keccak slot overflow")
ASSERT(__single_sign_end <= __single_crypto_slot+0x2c00, "sign slot overflow")
ASSERT(__single_ro_end <= __single_ro_slot+0x400, "Keccak constants overflow")
'''
p.write_text(s)
