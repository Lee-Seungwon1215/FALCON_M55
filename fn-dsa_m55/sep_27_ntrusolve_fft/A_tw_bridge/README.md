# A17 — cleaned, pre-SLOTHY implementation

This directory contains the complete local cryptographic implementation:
the adopted NTT code, A16 NTRU FFT optimizations, and A17 native-FP64
candidate inverse norm. No other candidate supplies a cryptographic source
file or selectable backend. SLOTHY is not applied.

The 2026-09-28 cleanup removes unused experimental functions and a diagnostic
NTT entry point, consolidates C/assembly declarations and corrects comments.
It does not change the retained arithmetic, thresholds, roots or layouts.
The previous source is recoverable from
`../validation/source_snapshots/A17_fp64_invnorm.tar.gz`.
See [cleanup and fresh validation](../validation/cleanup/README.md).
Earlier results describe their recorded source hashes, not automatic passes
for a modified source tree.

## Active computation paths

| Caller | Representation and implementation |
| --- | --- |
| Candidate FFT/iFFT | Original Q32 fixed-point transforms |
| Candidate `vect_invnorm_fft(e=0)` | Per-coefficient Q32 input → native FP64 squares/reciprocal → Q32 output; other public e values retain fixed-point arithmetic |
| NTRU intermediate FFT/iFFT | `vect_FFT_ntru` / `vect_iFFT_ntru`: exact integer MVE at logn ≥ 4, original fixed-point at logn < 4 |
| NTRU intermediate surrounding work | Original Q32 rules; input conversion and batches of four fixed-point divisions use local integer-MVE assembly |
| NTRU depth-zero FFT/iFFT | Double input/output interface, local 2×FP32 MVE butterflies, double output; both conversions are inside the call |
| NTRU depth-zero division/rounding | Native FP64 with Q32-compatible division rounding and checked integer-k conversion |

`vect_FFT_fp64()` and `vect_iFFT_fp64()` retain their existing interface names.
They do **not** mean native-FP64 butterflies. By contrast the candidate
inverse-norm fast path really uses native FP64 arithmetic.

## Files and boundaries

- `kgen_ntru.c`: solver flow and calls; unchanged by cleanup.
- `kgen_fxp.c`: fixed transforms, NTRU transform dispatch, FP64 division and inverse norm.
- `kgen_poly.c`: polynomial operations and Q32 input conversion wrapper.
- `kgen_fft_bridge.c`, `kgen_ds.h`: reentrant double/2×FP32 boundary and 8 KiB stack workspace.
- `kgen_fft_mve.c`: DS FFT/iFFT orchestration and immutable preconverted roots.
- `kgen_fft_cm55.s`, `kgen_fft_cm55.h`: directly written local assembly and its private C ABI.
- `mq_cm55.s`, `kgen_mp31_cm55.s`: adopted q-NTT and RNS NTT; only an unused diagnostic tail was removed from the former.

The third float in each DS root remains intentional ABI padding. The 24 KiB
root tables and 12-byte assembly stride are unchanged; packing these tables
is a separate optimization requiring new numerical and performance checks.
Two test-visible shared-macro entry points remain in isolated assembly
sections for the current regression suite; they are absent from the keygen ELF.

## Validation scope

Speed, numerical error, KAT, signing/verification and finite constant-time
tests are the requested scope. KAT agreement does not imply bit-identical
intermediate FP values or universal constant-time behavior. Key generation
itself has variable rejection/retry counts.

See [A17 pre-cleanup results](../validation/invnorm_results.md),
[timing-test limitations](../validation/security/README.md), and
[historical implementation notes](../validation/cleanup/README_before_cleanup.md).
The cumulative M55_ref keygen target of 1.7× has not been achieved.
