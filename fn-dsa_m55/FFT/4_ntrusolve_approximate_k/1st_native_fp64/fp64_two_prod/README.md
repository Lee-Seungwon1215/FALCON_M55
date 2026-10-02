# F2: exact FMA-residual multiplication

2026-09-23. Independent crypto copy of F1. Replaces radix-24 column products
with four 32x32 products recovered using a rounded quotient estimate and one
explicit FP64 FMA residual per product. This adapts the error-free-product idea
from REFERENCE/TWfalcon.pdf section 2.3; the Q32.32 design is new, not a claim
made by the paper. It is not the literal standard 2Prod sequence.

All Q32.32 wrap, signed corrections, per-product truncation, complex 3-product
arithmetic and iFFT half remain unchanged. No original fixed FFT fallback.
Actual arithmetic lives in this folder, not build flags or links to F1/R3.
`validation/` contains diagnostic baseline comparisons only.

Status: board differential tests, original KAT 300/300, signature/tamper and
finite-input timing checks passed. Fastest FP64 candidate in this experiment,
but still slower than the fixed-point reference. See [result.md](result.md).
The integrated reference has not been replaced.
