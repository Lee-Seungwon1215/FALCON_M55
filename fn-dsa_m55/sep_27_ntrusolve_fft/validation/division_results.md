# B10 — exact four-lane Q32 division

Changes are directly in B_continuous_ds/kgen_fft_cm55.s and kgen_fft_mve.c.
The assembly helper `fndsa_ds_div4` is used by the vector tiles of
`fndsa_ds_inverse` and `fndsa_ds_div_real`. The DS polynomial representation,
original norm/square arithmetic and small public-size scalar paths remain.
This is integer MVE arithmetic inside the FP32 design, not FP64 division.

## Isolated variants

The test compares against the unchanged local `inner_fxr_div`, not host
division with a different rounding/zero convention. Same ELF/inputs/compiler,
IRQ masked, explicit warmups and noipa scalar wrapper. Each timing trial
contains 64 four-lane calls, including identical input resets/call overhead.

| Variant | Run (UTC) | Cycles /64 four-lane calls | Scalar cycles | Scalar/new |
| --- | --- | ---: | ---: | ---: |
| Initial full-width quotient shifts | [170403Z](results/B_continuous_ds/division/20260927T170403Z/manifest.json) | 161,801 | 448,589 | 2.7725× |
| Separate high/low quotient accumulation | [170513Z](results/B_continuous_ds/division/20260927T170513Z/manifest.json) | 136,969 | 448,589 | 3.2751× |

Both variants match 254,546 calls /1,018,184 quotient values: randomized
full 64-bit inputs, explicit zero/sign/extreme pairs, powers of two and
adjacent values, numerator=denominator aliasing and four alignment offsets.
Numerator output guards and the unchanged denominator buffer are checked.
The original recurrence's edge behavior is preserved; this is not a promise
that mathematical division by zero is defined.

The second variant removes three cross-word quotient shift/OR instructions
per bit, reducing its own measured time 15.35%. Its rounding still carries
from low to high. No carry is shared between coefficient lanes or between
real and imaginary values. See [design](../research/division_design.md).

## Complete surrounding functions

The B10 decoding run [170648Z](results/B_continuous_ds/decoding/20260927T170648Z/manifest.json)
passes 2,228,448 decoder-value checks, 640 point-product cases, 320 inverse
cases and 640 real-division cases, including aliasing and untouched slots.
The inverse/division oracles retain the original scalar Q32 operations.

Times below are per-call minima over 32 timed calls after two warmups.
Both functions include decoding, arithmetic, encoding and their call costs.
B9 is [163124Z](results/B_continuous_ds/decoding/20260927T163124Z/manifest.json).
Cross-version function addresses are not pinned; the old/new scalar oracle
in each ELF is also reported, avoiding a claim that all layout effects vanish.

| Function | n | Frozen scalar oracle | B9 | B10 |
| --- | ---: | ---: | ---: | ---: |
| Inverse/norm | 512 | 999,232 | 975,557 | 358,733 |
| Inverse/norm | 1024 | 1,998,400 | 1,951,045 | 717,389 |
| Real division | 512 | 1,019,974 | 988,809 | 358,666 |
| Real division | 1024 | 2,039,878 | 1,977,545 | 717,258 |

These improvements are NOT whole-keygen speedups. Point-product times remain
123,472 /246,864 cycles, as expected for its unchanged source in this step.

## Timing, ABI and limitations

32 operand classes ×20 trials exercise fixed public lane count, including
zero and extreme patterns. Timings and current-source re-runs are retained
in the raw logs. The inspected helper has only two fixed-count loop branches,
no operand-indexed load and no secret-dependent fallback. Vector predicates
select values, not instruction paths. Finite timing tests and inspection are
supporting evidence, not formal CT or power/EM guarantees.

The helper saves 80 register bytes and reserves 32 private scratch bytes.
The inverse tile grows from 64 to 96 bytes; the real-division tile stays
96 bytes. These tiles are NOT the complete C frames: current linked inverse
uses 456 bytes, and real division uses 224 bytes, before called helpers.
The linked B10 signature-test image uses 123304 ITCM bytes and
250920/262144 DTCM bytes, including the reserved 64-KiB main stack. This is
link fit, not a worst-case stack proof. No external reference was overwritten.

Full current-source KAT, signatures, whole-keygen/profile and boundary gates
are indexed in [current_validation.json](current_validation.json); status is
not inherited from the isolated pre-integration source hashes. Overall
comparison and target shortfall are in [result.md](../result.md).

Current integrated-source gates: upstream KAT 170813Z, independent inputs
171124Z, signatures/verify/tamper 171209Z, profile 171220Z, kernels 171306Z,
encoding/selection 171309Z, rounding 171313Z, decoding/surrounding 171324Z,
division 171330Z. All completion/fault checks pass. The current division
run again matches 1,018,184 outputs; all new class minima are 136969 cycles,
with an occasional maximum of 136970. This is not exact timing in every
sample and is not promoted to a formal CT proof.

FFT kernels retain nonzero intermediate raw-word differences (e.g. maximum
257 raw units for n=1024 FFT), with zero rounded differences in these finite
test arrays. The new divider itself is raw-word exact against the original;
these distinct equivalence statements must not be conflated.

Initial B10 whole-keygen run 171009Z: 57,946,321.84 /245,794,206.26 cycles,
versus B9 59,032,874.79 /247,983,506.14. These include all conversions,
surrounding work, failed candidates and retries for 100 common seeds/degree.
The benefit is much smaller than the isolated quotient speedup, and this
candidate still loses to A7. The existing NTT gains must not be relabeled
as newly achieved FFT gains; 1.7x remains unachieved.

Repeat whole run 171504Z gives 57,946,322.03 /245,794,207.02 cycles, within
one mean cycle/key of the first run. Current B10 is 1.0827x /1.0648x versus
M55_ref (including prior NTT gains), but still 1.7472% /1.0844% slower than
ntt_opt. The latest evidence_check.json rechecks 17 current-source gates and
the 63 original snapshot/external reference files. A7 remains the better
whole-keygen candidate; B10 is retained as progress in the independent B path.

## Instrumented attribution

B9 profile 163019Z versus B10 profile 171220Z, same 100 seeds/degree.
These aggregate intervals include their profiling hooks and are not a
replacement for the uninstrumented whole-keygen measurement above.

| Interval | B9 512 | B10 512 | B9 1024 | B10 1024 |
| --- | ---: | ---: | ---: | ---: |
| Intermediate reciprocal/norm | 1,012,983.00 | 484,084.73 | 2,034,085.45 | 960,273.95 |
| Depth0 real-division interval | 1,024,361.38 | 466,697.99 | 2,048,572.21 | 933,221.55 |
| Intermediate point product (unchanged) | 2,220,864.43 | 2,220,820.81 | 5,564,061.32 | 5,564,050.39 |
| Intermediate integer update (outside FFT) | 14,743,009.55 | 14,742,889.63 | 63,924,825.15 | 63,925,010.67 |

The two changed intervals account for approximately 1.087M /2.189M saved
cycles. Unchanged point products and integer updates stay nearly equal.
The complete target scope drops from 16.10320% /9.75112% to 14.56817%
/8.95985% of instrumented whole keygen. This is not a claim that the FFT
butterfly itself became 3.2751x faster, or that keygen sped up by that factor.
