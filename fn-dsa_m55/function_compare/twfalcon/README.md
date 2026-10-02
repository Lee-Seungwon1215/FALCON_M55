# FN-DSA key-generation FFT: TWFalcon FP32/MVE experiment

This directory is an isolated comparison project.  It does not replace any
FN-DSA source selected by the normal firmware build.

Latest integrated experiment (2026-09-26): stage 11 preconverts the identical
Q32 roots into checked-in DS constants and removes repeated root preparation.
The public FFT/iFFT functions, including input/output conversion, now take
8.98--16.66% fewer cycles than the M55_ref-body fixed baseline in one image.
Keygen KAT 300/300 and sign/verify/tamper 90/90 pass. This change is confined
to `integration_candidate`; the standalone stage-10 core and normal refs
remain unchanged. See [stage 11](stages/11_precomputed_roots/README.md).

The experiment compares five kernels with identical inputs:

1. the original Q32.32 `vect_FFT()` / `vect_iFFT()` arithmetic;
2. the current scalar binary64 kernels;
3. a scalar triple-float (`3 x binary32`) accuracy oracle;
4. a Cortex-M55 MVE triple-float implementation.
5. a Cortex-M55 MVE double-single (`2 x binary32`) implementation.

The board harness includes test-only stage-7/8/9 double-single baselines
alongside the current stage-10 packed-tail implementation (stage-9 spans
are unchanged).

The per-layer clones in `tests/` retain a frozen stage-9 control and profile
the current stage-10 source. `tools/audit_layers.py` checks both against their
respective source bodies. `tools/audit_tail.py` checks gathered indices,
public loop control and unchanged FP arithmetic sequence. The small two
layers fell from 64.95--69.11% to 23.30--27.19% of profiled core time.
See `stages/10_packed_tail/README.md` for the result and exact boundaries.

The current complex layout uses two FP32 components (`hi + lo`) per real or
imaginary part. The earlier triple-float candidate is retained as an oracle.
Four independent complex
coefficients are processed in parallel by MVE.  The adopted FP64
`vect_invnorm_fft_fp64()` is outside this experiment and remains unchanged.

The triple-float rules are derived from the official TWFalcon implementation
at commit `6c3145baaced356d324ce883fe010596d08f5e75` (NXP, MIT).  In
particular, products retain the FMA residual and complex multiplication uses
four real products.  See `LICENSE.TWFalcon` and `reference/upstream/`.

No Makefile switch, symbol alias, linker redirection, or external-object
substitution is used to pretend that a candidate is integrated.  Candidate
kernels have explicit names and are called directly by the comparison harness.

## Status

- [x] Independent source tree and fixed/FP64 reference kernels
- [x] Scalar triple-float FFT/iFFT
- [x] Hand-written MVE FP32 error-free primitives
- [x] Four-lane FFT/iFFT prototype using those assembly primitives
- [x] Fused triple-float add/sub/multiply leaf kernels in assembly
- [x] Board numerical-error and timing measurements
- [x] Full key-generation KAT (300/300)
- [x] Signature/verify/tamper regression (90/90)
- [x] Memory-canary test
- [x] Whole complex butterfly fused into one assembly function
- [x] Scalar-tail-free MVE path, fused add/sub and fused complex multiply
- [x] Double-single (`hi + lo`) MVE candidate
- [x] Empirical input-class timing equality for the double-single candidate

The triple-float candidate remained 8.1--9.7 times slower than Q32.32 after
full-butterfly fusion, so the experiment moved to double-single as planned.
The stage-8/9 direct-array/register-result span assembly reduces vector memory
instructions per four butterflies from 84 to 36 (FFT) / 44 (iFFT), retaining
the stage-7 arithmetic. Complete core time falls 13.03--15.25% in the same
image comparison. It passes 1,408 span and 180 transform bitwise checks,
300 keygen KATs and 90 signature/verify/tamper cases. Timing probes differ
by at most one cycle in the tested classes; this is not a formal CT proof.

Stage 10 packs four different groups (ht=1) or two groups (ht=2) into four
useful MVE lanes, directly gathering/scattering arrays. Whole transform core
time falls 54.33--56.98% versus stage 9, now 22.01--31.45% below the isolated
Q32 core. However, public functions including representation conversions
and on-demand roots remain 19.83--38.77% slower than the M55_ref-body fixed
baseline. This is still an experimental candidate, not a normal replacement.
Latest checks: 224 tail + 180 transform + 880 profile raw-byte comparisons,
300 keygen KATs, 90 signature/verify/tamper cases, canaries and structural
audit pass. Fixed single-callsite timing probes vary by 0--1 cycle, not a
formal CT proof. Q32 intermediate values are not bit-identical.
