# F3a: exact two-layer FFT tiles

2026-09-23. Independent copy of F2. Merges the final two forward layers and
the first two inverse layers into four-complex-value tiles. Original per-op
Q32.32 wrap/truncation, three-product complex multiplication and each iFFT
half are preserved. Small public logn paths stay unchanged.

The source eliminates the intermediate FFT-array traversal. It does NOT claim
all locals fit in registers: generated spills, stack, performance and KAT must
be checked on the board. This is the layer-merge ablation before Slothy.

Reference: REFERENCE/ARMv8_falcon.pdf section IV.C, adapted for two-double
Q32.32 semantics rather than NEON FP64. No other candidate supplies crypto
code at link time. Status: correctness/KAT/timing checks passed, but whole
keygen regressed versus F2; not selected. See [result.md](result.md).
