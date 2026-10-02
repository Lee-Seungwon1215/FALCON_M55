# Paper reading log

Extraction is not reading. Only the ranges below have been read in full during
this task. All 11 local PDFs have page-indexed text; the binary-field MVE PDF
required local Vision OCR. Verify OCR mathematical expressions against images
before relying on them.

| File | Total pages | Read completely so far |
| --- | ---: | --- |
| TWfalcon.pdf | 25 | 1–25 |
| m55_ntt-ftt_opt.pdf | 29 | 1–29 |
| ARMv8_falcon.pdf | 15 | 1–15; image-only tables/figures pp. 6, 11–13 inspected |
| Neon_NTT.pdf | 38 | 1–38 |
| binary-field MVE PDF (Vista do...) | 16 | 1–16 OCR; equations/tables not used as numerical evidence |
| falcon_m4.pdf | 18 | 1–18 |
| falcon_m7.pdf | 22 | 1–22 |
| fp64_accuracy.pdf | 18 | 1–18 |
| m55_slothy.pdf | 46 | 1–46; concepts read, no SLOTHY execution/code generation |
| plantard.pdf | 24 | 1–24 |
| plantard_32bit.pdf | 15 | 1–15 |

## TWFalcon findings applicable to this task

- pp. 5–8: error-free 2Sum/2Prod, normalized expansions, FMA residuals. The
  original paper studies THREE FP32 components, not our two-component path.
- pp. 9–13, 21–22: sampler error/precision evidence is about signing. It is not
  a proof of keygen Q32 KAT equivalence, and finite tests cannot prove bounds.
- pp. 14–18: operation-specific input-range analysis enables simpler rounding
  and conversions. Its sampler input bounds must not be imported into NTRU.
- p. 18: exploit known zero components and fuse add/sub/call interfaces to avoid
  stack overhead. Promising for integer -> DS input and small FFT special cases.
- pp. 18–20: fixed control flow, masking and final assembly audits are needed.
  M4 division timing assumptions cannot be used as M55 timing evidence.
- pp. 20–21: expensive integer-emulated division/sqrt benefit from FP hardware,
  while add/mul may lose due to dependencies and register pressure. This
  supports profiling per operation rather than expecting the invnorm speedup
  from every butterfly.

## Current hypotheses (not results)

- B pointwise arithmetic repeatedly decodes/grids/normalizes DS after each scalar
  operation. Fuse coefficient work and use integer-assisted Q32 arithmetic in
  registers, preserving FP storage and FFT, then validate rounding boundaries.
- Reciprocal sharing and hardware FP64 estimate + exact fixed-count correction
  may accelerate NTRU division. Need explicit operand and quotient bounds.
- Small transforms may prefer fixed-point/scalar operations. Public-size-only
  dispatch is acceptable; secret-dependent precision fallback is not.
- Layout changes affect unrelated integer timings. Separate kernel benefit,
  NTRU target benefit and whole-program layout effects before attribution.

## Additional findings

- `m55_ntt-ftt_opt.pdf` pp. 13–22: register-pressure-aware single-instance
  vectorization; deinterleaving loads, preload/late store, interleaving memory,
  multiply and add/sub; public-size cutoffs are measured, not assumed. Its
  3-instruction Montgomery result is modular integer arithmetic, not an FFT
  Q32 multiplication replacement. Appendix algorithms and references read too.
- `fp64_accuracy.pdf` pp. 6–13: rounding after normalization/zeroization must
  be tested at boundaries. Equivalence and range checks are distinct; KAT is
  not a formal range proof. Its concrete lower bound applies to signing FFT
  integer inputs, not our NTRU approximation inputs.
- `fp64_accuracy.pdf` pp. 14–15: keygen fixed-point arithmetic deliberately
  performs multiple Babai reductions instead of one high-precision reduction.
  This suggests a separate algorithm-level iteration-count hypothesis, but
  simply increasing `reduce_bits` changes assumptions/output and is NOT an
  established KAT-preserving optimization. No such change has been made.
- `falcon_m4.pdf` pp. 6–14: memory alignment, caller overhead and shared
  add/sub normalization matter. Keygen uses 64-bit FIXED-point inline integer
  assembly, while signing uses emulated binary64: distinct baselines. Its
  24 MHz M4 timings and load/store rules are not M55 cycle guarantees.
- `falcon_m7.pdf` pp. 8, 12–18: native-FP speedups compare against emulated
  floating point, not this modern fixed-point keygen. Reports FP timing and
  conversion-library leakage; inspect our generated instructions and actual
  M55 operand timings rather than assuming constant-time from the C type.
- `ARMv8_falcon.pdf` pp. 8–13: fuse complex multiplication with FMA, merge
  layers and keep final subtransforms in registers. ARMv8-A has 32 vector
  registers and native FP64 SIMD; M55 has neither advantage, so transplanting
  the same register tile is invalid. Its FP64 FMA formula is not proof of
  Q32 truncation equivalence. Table/figure images pp. 6, 11–13 checked:
  layer merging is not universally beneficial and whole-keygen gains are far
  smaller than the individual FFT gains.
- `Neon_NTT.pdf` pp. 15–20 and Appendix D–F: dependencies across layers,
  amortizing repeated multiplicand work, avoiding transpose barriers before
  instruction interleaving. Q32 carry/truncation still must be honored;
  modular-reduction tricks are not directly applicable to real FFT arithmetic.
- `plantard.pdf` pp. 9–20 and `plantard_32bit.pdf` pp. 5–13: corrected
  arithmetic bounds require positive alpha; 16-bit modular constant products
  cannot replace Q32 real products. Reuse repeated operand preparation and
  allocate temporary storage by lifetime, but preserve the different rounding
  rules. Larger tiles can lose to register pressure or code-memory spill.
  Their kernel speedups did not translate one-for-one to whole protocols.
- `m55_slothy.pdf` pp. 8–9, 21, 29–31: M55 FP additions and multiplies
  share an execution pipe (unlike integer add vs multiply), so FP instruction
  count and spill reduction take priority over assuming arithmetic overlap.
  Watch alignment-dependent store/load bank hazards and balance scalar/vector
  registers. Q1.31 DSP butterfly results are NOT our 64-bit Q32.32 semantics.
  We read the entire method and examples but do not run or apply SLOTHY.
- Binary-field MVE paper pp. 4–14: direct vs hierarchical decomposition,
  intermediate-buffer lifetime, and scalar/vector transfer overhead can decide
  the winner. Carry-less XOR products over GF(2^m) do not implement real Q32
  multiplication, so those arithmetic instructions cannot be transplanted.
  OCR has errors in equations and tables; no formula or numerical claim from
  those OCR sections is used in the implementation. Its M85 cache/main-SRAM
  setup is not the N657 ITCM/DTCM setup used in these measurements.
