# B5–B8 boundary optimization

These are **NTRU approximation boundary costs**, not another FFT kernel or
whole-keygen speed claim. The production representation remains two FP32
components per real/imaginary value. No other candidate source is linked.

## Implementation and exactness scope

- B5 `fndsa_ds_encode4`: four selected signed Q32 words directly become four
  FP32 expansions. The 16-bit component conversions are exact; every scalar
  TwoSum/add-zero operation is retained lane by lane. `from_big` still scans
  all limbs with the original secret-scale masks. Its 32-byte local word
  staging is not a full Q32 polynomial buffer.
- B6 `fndsa_ds_round4`: four expansions become four integer k values. Both
  finite/range guards, `+.5`, `+2^-33`, negative-low-component tie handling
  and the final signed 64-bit range test are retained. Vector masks replace
  conditional selection. A real 64-bit sum is needed because sequential
  signed-overflow tests would reject some cancelling cases. Private scratch
  is 64 bytes; q4–q7 are restored to meet the ABI.
- Own assembly: `B_continuous_ds/kgen_fft_cm55.s`; wrappers:
  `B_continuous_ds/kgen_fft_mve.c`. No crypto backend flags, foreign links or
  SLOTHY. The old small public-size path is retained.
- Instruction semantics were checked against the
  [Arm MVE specification](https://arm-software.github.io/acle/mve_intrinsics/mve.html),
  the assembler and linked disassembly. The lane-wise translation and Q32
  range/carry design are this experiment's implementation, not a claim that
  a paper supplied this exact function.

## Numerical tests

Frozen B4 scalar test oracles are stored in encoding/oracle.h and
rounding/oracle.h; they are not linked into production firmware.

- Encoder: 1,000,000 raw-word comparisons plus 2,070 from_big cases, including
  logn=1..10, len=0..8 and many secret scales. Both FP32 output bit patterns
  and untouched memory agree.
- Rounder: 151,344 calls / 1,273,664 values. Covers raw-derived expansions,
  arbitrary FP32 bit patterns, half-integer ties, positive/negative epsilon,
  signed zero, subnormals, infinities/NaNs, INT32 boundaries and logn=1..10.
  Output words, range-valid return value and untouched memory all agree.
  Runs: rounding/20260927T153700Z and rounding/20260927T154822Z.
- B6 upstream KAT: 300/300 exact keys and NTRU equations pass in
  kat/20260927T153739Z. Further current-source validation is listed in
  current_validation.json rather than inherited from older versions.

These finite comparisons support an exact translation on the tested M55
floating-point environment, not universal equivalence of the whole DS FFT
to the original Q32 algorithm or a formal floating-point proof.

## Isolated timing versus old B scalar boundaries

Rounder: 128 calls ×8 coefficients, same noinline timed region, IRQ masked,
16 warmups, 20 trials for each of 32 input classes. With test-only IPA,
inlining and constant propagation of the old public API prevented, the scalar
reference minimum is 150,410 cycles (occasional maximum +1); MVE is 74,762
cycles, **2.0119x**. Every tested MVE class/trial has identical timing. This final
comparison is rounding/20260927T154822Z. The earlier specialized scalar oracle
measured 145,289 cycles (1.9434x); that result remains archived, not overwritten.
Encoder fixed-region timing: 28,810 scalar /18,824 MVE cycles per 128
four-lane calls, **1.5305x**, all 20 classes ×20 trials identical for each
implementation. Details are in ct_results.md. Early encoding timing runs are explicitly
marked diagnostic/numerical-only in their review.json files.

## Whole keygen (100 same seeds per degree; all costs included)

| Version | 512 cycles | 1024 cycles |
| --- | ---: | ---: |
| B4 | 60,927,776.29 | 252,665,830.54 |
| B5 | 60,202,399.94 | 250,916,084.33 |
| B6 | 59,826,982.72 | 249,997,361.46 |

B5+B6 reduce B4 whole-keygen time by **1.8067% /1.0561%**. B6 remains
**5.0495% /2.8130% slower than ntt_opt**; it does not beat A6, and the 1.7x
objective is unmet. The 1.94x rounder result must not be advertised as a
2.01x FFT or whole-keygen improvement. These builds share placement policy,
not identical function addresses; small whole-program differences include
possible layout effects.

Instrumented B4/B6 comparison (separate builds from whole-performance runs):

| NTRU intermediate operation | B4 512 | B6 512 | B4 1024 | B6 1024 |
| --- | ---: | ---: | ---: | ---: |
| Input extraction + expansion | 2,105,312.14 | 2,063,374.15 | 6,226,253.26 | 6,147,278.68 |
| Final k rounding/checks | 1,744,343.80 | 772,654.22 | 4,358,754.52 | 1,946,426.71 |

Whole `from_big` only improves about 1.99% /1.27% here despite the 1.53x
standalone encoder, because extraction, scanning, calls and staging remain.
Round/check time drops about 55.7% /55.3%. Do not combine instrumented leaves
with uninstrumented totals to manufacture a speedup; code placement and
instrumentation affect each separately. Remaining B6 target scope is 17.812%
/10.868% of instrumented whole keygen; integer update/CRT/Bezout are excluded.

B4/B6 have identical counts in all 218 instrumented operation/size rows.
Repeat B6 whole-keygen run 20260927T154535Z gives 59,826,983.23 /249,997,361.37
cycles, within one mean cycle of the first run. Repeat A6 run
20260927T154621Z gives 56,256,308.92 /241,743,902.19, also within one cycle.
Reproducibility of an unchanged ELF does not remove cross-ELF layout effects.

Final encoder validation 20260927T154832Z additionally tests 1,024 explicit
word-boundary values and disables IPA of the scalar oracle. All pass and
the 18,824 /28,810 timing values are unchanged.

## B7/B8: decoding and surrounding tiles

B7 adds a four-lane decoder and 128-byte point-product tile. B8 applies the
same edges to inverse (64-byte tile) and real division (96-byte tile).
All original three-product, square, norm and fixed-count integer-quotient
rules are preserved. These are bounded private tiles, not full Q32 arrays.
The scalar B6 functions in decoding/oracle.h are test-only and marked noipa.

An initial decoder failed on a subnormal input: in diagnostic run
decoding/20260927T155825Z, multiplying bits 0x8059a004 by 2^32 produced
0x80000000 in the MVE instruction but 0x90334008 in the scalar instruction,
despite scalar FPSCR.FZ being clear. The smallest positive subnormal similarly
gave vector 0 vs scalar 0x05000000. This was an observed scaling-semantics
difference, not an omitted integer carry. Failed run 155546Z is kept invalid.
The corrected decoder scales normal inputs by exponent bits and subnormal
mantissas by exact uint23 conversion times 2^-117, preserving sign with masks.
It never branches on the operand and makes no input-specific fallback.

Final B8 decoder/surround test: decoding/20260927T160856Z:

- 2,228,448 finite decoder inputs match scalar output words, including
  raw-derived expansions, arbitrary bit patterns with exponent <=222,
  every finite supported exponent, subnormals and explicit edge classes.
- 640 point products, 320 inverse calls and 640 real divisions match the
  frozen B6 output bits AND untouched memory. Public logn=1..10, inverse
  scale e=0..31, alias/nonalias division and explicit raw-word edges included.
- Decoder: 24 operand classes ×20 trials, 128 four-lane calls per trial;
  all new measurements 42,763 cycles vs scalar 61,195 (1.4310x).

Same-ELF surrounding-function timings (32 trials, minimum cycles; includes
representation edges and calls; reference is B6 scalar DS, NOT M55_ref):

| Operation | n | B6 scalar oracle | B8 | Speedup |
| --- | ---: | ---: | ---: | ---: |
| Point complex multiply | 512 | 161,096 | 123,472 | 1.3047x |
| Point complex multiply | 1024 | 322,120 | 246,864 | 1.3048x |
| Conjugate / squared norm | 512 | 999,232 | 975,557 | 1.0243x |
| Conjugate / squared norm | 1024 | 1,998,400 | 1,951,045 | 1.0243x |
| Real division | 512 | 1,019,974 | 988,809 | 1.0315x |
| Real division | 1024 | 2,039,878 | 1,977,545 | 1.0315x |

B7's earlier point-only benchmark measured ~1.364x; the expanded B8 ELF
measures ~1.305x. Different linked layouts are not an identical-address
microbenchmark, so do not promote the better historical number to the
current whole-program result. All-input equivalence, universal timing and
full-stack safety are not proved by these finite checks.

Whole B8 keygen (keygen/20260927T161150Z, same 100 seeds per degree):
59,501,014.05 /249,200,552.94 cycles. B7 was 59,531,271.25 /249,261,734.57.
The incremental B8 reductions are only **0.0508% /0.0245%**, with cross-ELF
layout effects included. B6-to-B8 reductions are **0.5449% /0.3187%**.
Against M55_ref B8 is **1.0544x /1.0502x**, but compared with ntt_opt it
is still **4.4771% /2.4853% slower**. A6 was the better full candidate at
that point; current A7/B9 results are reported separately in ../result.md.
This is not a reason to claim the whole key-generation 1.7x goal is achieved.

Instrumented per-key leaves (different firmware from the headline timing):

| NTRU operation | B6 512 | B8 512 | B6 1024 | B8 1024 |
| --- | ---: | ---: | ---: | ---: |
| Intermediate point product | 2,884,491.76 | 2,220,798.74 | 7,213,834.88 | 5,564,050.69 |
| Intermediate reciprocal/norm | 1,048,761.20 | 1,013,015.92 | 2,106,762.32 | 2,034,118.18 |
| Depth0 real division | 1,063,790.48 | 1,024,361.39 | 2,127,452.28 | 2,048,539.48 |

B6/B7/B8 all have the same 218 operation/size call counts after removing
interleaved OpenOCD Info messages from the trace. B8 target scope is
16.81635% /10.23385% of instrumented keygen; the raw baseline scope remains
11.87569% /7.39278%. Changing the denominator is not evidence of speedup.

B8 current-hash final gates also pass: extra/20260927T161259Z (300 keys),
sigkat/20260927T161345Z (90 signature/verify/tamper cases),
profile/20260927T161356Z (200 keys, all accounting errors zero),
kernel/20260927T161443Z (640 finite transform inputs),
encoding/20260927T161446Z and rounding/20260927T161449Z. The original upstream
300-key run is kat/20260927T160926Z. Kernel raw-word errors are NOT zero
(maximum 257 units of 2^-32 forward, 4 inverse on these inputs); all tested
final integer roundings match. See kernel_summary.md for size-specific values.

Unchanged-ELF B8 repeat keygen/20260927T161547Z gives
59,501,014.12 /249,200,552.39 cycles (mean differences +0.07 /-0.55 cycles).
This reproduces the first B8 result; it does not eliminate cross-ELF layout
effects when comparing different versions.
