# F1: exact radix-24 VFMA candidate

2026-09-23. Derived from `../fp64_radix24_inline` (R3).
This directory contains its own crypto sources. Only the four exact-integer
partial-product accumulations in `kgen_fxp.c` change from VMLA to VFMA.
No fast-math flag, alternative crypto link, Q32.32 rounding change, or fixed FFT
fallback is used. `validation/` may link an explicitly named baseline for tests;
the candidate production image compiles only this directory's crypto sources.

References: REFERENCE/TWfalcon.pdf section 2.3 (FMA), Arm Cortex-M55 Software
Optimization Guide 102692_0101_03, section 3.9 (FP64 instruction latency).
The adaptation to exact Q32.32 column arithmetic is our design, not a result
claimed by either reference. See `design.md` and [result.md](result.md).

Build: `bash validation/build.sh kernels|kat|asm-perf|asm-profile`.
Run: `python3 validation/run_board.py <same-label>` (requires USB access).

Status: board differential tests, original KAT 300/300, signature/tamper and
finite-input timing checks passed. Faster than R3, but F2 is faster than F1.
Not promoted to the integrated performance reference.
