# Implementation and validation plan

## Latest completed experiment — stage 11 (2026-09-26)

Same-function profiling identified on-demand root preparation (32--35% of
whole-function time). The integrated candidate now uses offline preconverted
bit-identical DS roots. No arithmetic, bridge, assembly, or invnorm change.
Same-image old/new/M55_ref comparisons, bit equivalence, 300 keygen KATs,
90 signature/verify/tamper cases, input-class timing, and memory audits passed.
Whole functions including conversions use 8.98--16.66% fewer cycles than the
fixed baseline. Normal refs have not been replaced; see the stage-11 report.
This experiment used 5 x 100 measurements per case, with 10 warmups per batch.

## Fixed scope

The experiment targets the key-generation transforms corresponding to:

- `vect_FFT()`
- `vect_iFFT()`
- `vect_FFT_fp64()`
- `vect_iFFT_fp64()`

These are two transform operations with fixed-point and FP64 entry points.
`vect_invnorm_fft_fp64()` is already faster and remains unchanged.

The first candidate fixes the FP32 representation to six structure-of-arrays
planes: `re[hi,mid,lo]` and `im[hi,mid,lo]`.  Each MVE vector contains four
distinct coefficients; components of a single number never occupy separate
lanes.  If the fully fused triple-float path remains at least three times
slower than Q32, the planned fallback is double-single `re[hi,lo]` and
`im[hi,lo]` with the same lane mapping.

## Order of work

1. Freeze identical Q32 roots and deterministic input vectors.
2. Build a scalar TWFalcon-style oracle with `two_sum`, FMA `two_prod`,
   normalization, four-product complex multiplication, FFT and iFFT.
3. Compare the scalar oracle with the upstream TWFalcon arithmetic and with
   the Q32 reference for `logn=2..10`, including first-mismatch diagnostics.
4. Replace error-free primitives by hand-written MVE FP32 assembly and process
   four butterflies per batch.  Keep scalar tails for one to three elements.
5. Measure both core-only time and conversion-inclusive time.  Inputs and
   copies remain outside core-only timed regions.
6. Try the paper-supported techniques: SoA layout, four-product complex
   multiply, fused residual extraction, twiddle preload, last-layer handling,
   instruction scheduling, and only then layer fusion.
7. A candidate is adoptable only if it beats `fn-dsa_m55/M55_ref` with
   conversions included and passes full KAT, NTRU equation, sign/verify,
   tamper rejection, memory canaries, and constant-time audits.

Steps 4--6 were completed through scalar-tail removal, fused add/sub, fused
complex multiply and complete butterfly fusion.  The three-times threshold
was exceeded, so the double-single fallback was implemented and validated.

## Measurement contract

- Board: NUCLEO-N657X0-Q, Cortex-M55
- CPU/SYSCLK/HCLK: 800/400/200 MHz
- code: ITCM; data and stack: DTCM; I/D cache off; ECC on
- GCC 15.2.1, `-O3`, no fast-math, no contraction in C
- DWT cycle counter, interrupts masked only inside timed regions
- 10 warm-ups, 10 batches of 100 calls, alternating execution order
  (not an identical-code-address placement audit)
- report n=512 and n=1024 separately

## Source-review rule

Before selecting an optimization, inspect all relevant PDFs under
`/Users/seungwon/FALCON/REFERENCE`.  Apply every relevant technique that is
compatible with Cortex-M55 and the fixed representation, retain the best
measured candidate, and record rejected candidates and their cause.  If the
local references do not resolve a blocker, inspect additional primary papers.
Implement production candidates directly and cleanly; do not obtain a result
by build-option tricks, linker substitution, or hidden dependencies.  Use
hand-written assembly where it improves the hot arithmetic and verify the
actual emitted instructions.

## Stack-traffic follow-up (2026-09-24)

Implemented stage 8 (direct coefficient access) and stage 9 (register-result
products and component-at-a-time consumption) in assembly. The change is to
storage and lifetimes, not the FP32 expansion or arithmetic rules. Preserve
stage 7/8 as test-only oracles; compare raw output bytes, not just Q32-rounded
outputs. Repeat full keygen KAT, signature/verify/tamper, canaries and timing
classes on the local integration copy. Keep adopted FP64 invnorm untouched.

## Packed small layers (2026-09-25 KST)

Completed stage 10 after measured ht=1/2 layers consumed 65--69% of core time.
Hand-written gather/scatter assembly packs four groups or two groups into
four useful lanes, retaining the DS arithmetic and final iFFT scaling.
Core time drops 54.33--56.98% versus stage 9. Raw-byte comparisons, KAT,
sign/verify/tamper and structural checks pass; empirical fixed-callsite timing
differs by at most one cycle. No all-input/whole-program CT proof is claimed.

The end-to-end kernel acceptance criterion remains OPEN: the four public
functions including conversions and on-demand roots are 19.83--38.77% slower
than the M55_ref-body fixed baseline. Keep the candidate isolated; do not
replace normal firmware on the basis of core-only results.

Scope is the full four-lane span loops. The small-layer padded tail and its
caller-side staging remain future work. Whole-keygen API performance is not
the acceptance metric for this task. Report core timing separately from the
harness's input-conversion-inclusive timing (which excludes output conversion).
