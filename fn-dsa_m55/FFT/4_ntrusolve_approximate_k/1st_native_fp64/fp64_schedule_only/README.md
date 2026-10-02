# F3c: Slothy without layer merging

The layer-merged F3a/F3b candidates regressed in whole keygen, so this candidate
applies the corrected locked-register Slothy adapter directly to F2's original
one-layer FFT/iFFT loops. No two-layer tiles are used. The exact FMA-residual
product and all Q32.32 arithmetic boundaries are unchanged.

`kgen_fp64_cm55.s` is a standalone source file, not a build-time generated import.
The remaining C code exports the same twiddle bytes to it. The offline source,
register-lane/memory trace checks and solver logs are under `validation/`.
Changing the C/ASM boundary is part of this deployment candidate. No isolated
Slothy speed claim is made solely from comparing it with F2's C functions.

Status: board differential tests, original KAT 300/300, signature/tamper and
finite-input timing checks passed. Slightly slower than F2; not selected.
See [result.md](result.md).
