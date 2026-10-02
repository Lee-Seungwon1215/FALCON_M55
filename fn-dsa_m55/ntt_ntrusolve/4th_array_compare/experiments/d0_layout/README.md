# D0 address-matched measurement control

`source/` is a complete 31-file C/H/S copy of `../../D0_vst4_previous`.
Only unreachable `.org` padding after NTT/iNTT/small-NTT returns differs.
`../../prepare_control.py` reproduces it and refuses conflicting existing files.
No D1 arithmetic, alternative reduction, source selector or symlink is used.

Slot spans from D1 v1: NTT 0x490, iNTT 0x6ea, small NTT 0x408 bytes.
The original D0 small-helper padding is extended to the new slot span.
Arithmetic instructions and loop structure remain D0's; the assembler resolves
relocations to the new matched addresses. The original D0 tree is untouched.

`../../audit_array.py` verifies source scope and every allocated ELF byte outside
the three kernel slots, plus all section addresses/sizes and Kconfig equality.
`provenance.json` records every original/control source hash.

Build with `bash ../../build_compare.sh audit` and `bash ../../build_compare.sh perf`.
Board execution is sequential through `../../compare_tools.py`; see the stage README.
The authoritative comparison is [D1 result.md](../../D1_vld4_last/result.md).
