# F3b: two-layer FFT + local Slothy scheduling

2026-09-23. Independent source copy of F3a. `kgen_fp64_cm55.s` contains the
two FFT functions and their private prepared complex-multiply helper, initially
extracted from GCC 15.2.1 output and then scheduled offline by real pinned Slothy.
`kgen_fxp.c` retains the remaining arithmetic and exports the unchanged twiddle
table to that local assembly file. No other candidate supplies runtime code.

The output assembly is ordinary checked-in source; Slothy/compiler extraction is
NOT a build dependency. All original arithmetic and stagewise half are retained.
`validation/fp64_slothy.py` uses exact D/S register-lane aliases, fixed registers,
serialized memory and windows bounded by all unknown operations/control flow.
It applies local instruction ordering only, not cross-iteration pipelining or
register renaming. Window register-version and ordered-memory traces must match.
The latency model is approximate and not a speed claim.

References: REFERENCE/m55_slothy.pdf sections 4,5,7; ARMv8_falcon.pdf IV.C.
F3a tests the layer-merge change. F3b additionally changes the C/ASM boundary.
The dedicated F3u unscheduled-assembly control matches that boundary and the
actual helper/FFT/iFFT addresses and sizes, isolating instruction reordering.

Status: corrected v2 adapter; board differential tests, original KAT 300/300,
signature/tamper and finite-input timing checks passed. Slightly slower than
F3u, and slower than F2. Not selected. See [result.md](result.md).
