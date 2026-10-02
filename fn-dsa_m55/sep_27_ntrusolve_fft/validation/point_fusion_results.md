# B11 point-product fusion

Status: full current-source gate suite and repeated whole-keygen/isolated
measurements complete. B11 improves on B10, but A8 is still faster overall.
This is an independent B experiment; A8 and external production refs are
not changed. The 1.7x whole-keygen goal is not achieved.

## What changed

`B_continuous_ds/kgen_fft_cm55.s`: `DSP_Q32_MUL` computes four exact signed
Q32 products with integer MVE; `fndsa_ds_mul_span` integrates the four input
decoders, original three-product complex rule, and two output encoders in
one public-count loop. Existing encoder/decoder instruction bodies are
shared as local assembler macros, not another candidate link or backend
build option. `kgen_fft_mve.c` directly calls this span for public logn>=3;
small paths stay scalar. DS polynomial representation stays unchanged.

[Arithmetic derivation, register/frame plan and sources](../research/point_fusion_design.md).
The changes remove the old C tile and six per-block helper calls. They do
NOT remove all stack access: the new assembly reserves 256 scratch bytes
and 80 saved-register bytes. The linked C wrapper restores its own 128-byte
frame before tail-jumping to the span; those two frames do not overlap.

## First isolated test

[decoding/20260927T173852Z](results/B_continuous_ds/decoding/20260927T173852Z/manifest.json):
1,000,484 raw products match the original fxr_mul (250,000 random four-lane
cases plus 121 edge-pair cases). Output guards are preserved. Four-lane
raw multiply, 128 calls: scalar 10,891 cycles, new 10,249 (1.0626x).
All 32 operand classes x20 trials have identical timings in this first run;
this is finite supporting evidence, not a universal CT proof.

Existing decoder comparisons: 2,228,448 values; complete point product:
640 arrays including d==b and untouched slots; inverse 320 and real division
640 all pass. The complete point timings include decoding, products,
encoding, wrappers and stores, with inputs reset outside timing:

| n | B10 cycles/call | B11 cycles/call | Time reduction vs B10 |
| --- | ---: | ---: | ---: |
| 512 | 123,472 | 106,919 | 13.41% |
| 1024 | 246,864 | 213,735 | 13.42% |

B10 run 171324Z, B11 first run 173852Z. Same input sequence and measurement
policy, not identical function/data addresses. The same-ELF frozen scalar
DS oracle takes 161,093/322,117 cycles: that is the older DS helper-based
implementation, NOT M55_ref's fixed-array point product. Do not confuse
these ratios with a comparison against fixed-point FFT kernels or whole
key generation. Later runs add direct fused-loop operand-class checks.

The final extended harness (174449Z, same-ELF repeat 174653Z) also passes
all raw products, decoder comparisons and surrounding-function checks.
Its paired point calls are 106,855 /213,607.03 cycles (512/1024), i.e.
13.4581%/13.4718% less time than B10. The small difference from the first
harness is not a new production optimization: crypto source hashes are
identical, but the extended test changes code/data layout and call context.
Raw 4-lane multiply is 9,993 cycles vs 11,019 scalar per 128 calls (1.1027x)
in both extended runs. Do not claim layout-independent 10.27% arithmetic gain
from this instead of recording the earlier 6.26% paired result too.

## Whole key generation

Same common M55 settings and 100 seeds per degree; 3 warmups excluded,
all conversions/calls/retries and key encoding included. Same ITCM/DTCM
placement policy, not identical code addresses. Final means:

| Implementation | 512 mean cycles | 1024 mean cycles |
| --- | ---: | ---: |
| M55_ref | 62,738,244.34 | 261,716,429.63 |
| ntt_opt | 56,951,253.03 | 243,157,429.30 |
| B10, 171504Z | 57,946,322.03 | 245,794,207.02 |
| B11 first, 174111Z | 57,693,564.16 | 245,165,387.58 |
| B11 repeat, 174525Z | 57,693,564.37 | 245,165,387.35 |
| Best independent A8 | 54,765,620.59 | 237,610,757.98 |

B11 time reduction vs B10 is 0.4362%/0.2558%. M55_ref/B11 is
1.0874x/1.0675x, including prior NTT improvements; B11 is still 1.3034%/
0.8258% slower than ntt_opt. Thus this change does not replace the best A8
candidate or satisfy the 1.7x objective. No external ref was overwritten.

[Whole first](results/B_continuous_ds/keygen/20260927T174111Z/manifest.json),
[whole repeat](results/B_continuous_ds/keygen/20260927T174525Z/manifest.json).

## Profile: attribution rather than just total time

Instrumented means per key, B10 171220Z vs B11 174344Z:

| Interval | B10 512 | B11 512 | B10 1024 | B11 1024 |
| --- | ---: | ---: | ---: | ---: |
| I_input | 1,509,364.67 | 1,509,408.29 | 4,717,163.46 | 4,717,108.65 |
| I_fft | 1,325,670.08 | 1,325,779.19 | 3,515,058.40 | 3,514,927.38 |
| I_recip | 484,084.73 | 484,073.78 | 960,273.95 | 960,328.49 |
| **I_mul** | **2,220,820.81** | **1,963,614.08** | **5,564,050.39** | **4,923,911.83** |
| I_ifft | 1,353,076.53 | 1,353,076.54 | 3,627,163.64 | 3,627,218.42 |
| I_round | 772,621.52 | 772,654.12 | 1,946,372.20 | 1,946,426.80 |

The changed interval saves 257,206.73 /640,138.56 instrumented cycles;
the uninstrumented whole key saves 252,757.66 /628,819.67 cycles. They
agree in location/order of magnitude, not exact equality: instrumentation
and cross-ELF layout effects are not removed. No FFT/iFFT algorithm or
integer NTRU-update work was changed. Current target-scope share is
14.1968%/8.7259% of the instrumented whole keygen.

## Gates and limits

| Gate | Run UTC | Result |
| --- | --- | --- |
| Original KAT / exact NTRU equation | 174024Z | 300/300 |
| Extra frozen-baseline KAT / equation | 174248Z | 300/300 |
| Signature KAT / verify / tamper | 174334Z | 90/90 |
| Profile | 174344Z | 200 keys, accounting errors 0 |
| FFT/iFFT finite arrays | 174431Z | 640, rounded discrepancies 0 |
| Encoder / selected input bits | 174434Z | 1M words +2070 full +67840 raw +272 extra full cases |
| Rounder | 174438Z | 1,273,664 values |
| Decoder / raw multiply / point / inverse / division | 174653Z | all finite comparisons pass |
| Exact quotient helper | 174457Z | 1,018,184 raw results |

The point's class checks cover 24 operand classes at each logn=3 and 9,
with 20 trials of 32 calls. Results match the frozen scalar DS oracle.
The final repeat's logn=3 timing range is 56,383–56,384; logn=9 is
3,421,087–3,421,089. Raw multiply is 9,993 in all its tested samples.
These finite tests and a linked-assembly review do not prove universal
CT, power/EM security, all-input FFT equality or a full call-chain stack
bound. Raw FFT errors remain as recorded in kernel_summary.md; local
integer product equivalence does not make every FFT intermediate exact.

The signature-test link uses 126224 ITCM bytes (+2920 vs B10) and unchanged
250920 DTCM bytes including 64-KiB stack reservation. All measured firmware
fits; this is not a worst-case stack proof. Source snapshots and archived
ELFs preserve B10 and B11 independently.

[Current source gates](current_validation.json), [integrity](evidence_check.json),
[CT details](ct_results.md), [source scope](scope_check.json).
