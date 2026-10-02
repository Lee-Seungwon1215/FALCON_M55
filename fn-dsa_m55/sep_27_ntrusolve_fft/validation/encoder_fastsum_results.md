# B14: shorter error-free sums in the Q32-to-FP32 encoder

## Change and numerical argument

Only B's `kgen_fft_cm55.s` changes from archived B13. Five encoder-only
TwoSum expansions become FastTwoSum, whose preconditions follow from the
integer split and successive residual bounds. The general decoder/rounder
TwoSum, FFT butterfly formulas, precision cutoffs and scalar encoder remain
unchanged. There is no runtime magnitude comparison or secret fallback.
Residual additions and explicit +0 retain their original order.

See [the derivation and primary references](../research/encoder_fastsum_design.md).
This is an application-specific analytical argument plus finite testing,
not a machine-checked proof of all inputs or whole-keygen KAT equivalence.
The representation is still two FP32 components per real/imaginary value;
it does not become exact arbitrary 64-bit storage.

The linked standalone encoder drops from 69 to 54 instructions, removing
15 vector instructions per four coefficients. It keeps the same register
save frame and accesses. Its three inline instances also shrink. The linked
signature firmware is 125432 ITCM bytes (-240 vs B13), 250920 DTCM bytes
(unchanged, including the reserved 64-KiB stack). A successful link and local
frame accounting are not a complete stack/memory-safety proof.

## Direct comparison

Host checker `host/check_encode_fastsum.c` compares all five intermediate
sum/error bit pairs and the complete result, and checks the sufficient
magnitude condition or exact zero-left case. 15,242,880 cases pass with
UBSan: 5,242,880 structured words and 10M scaled pseudorandom words.
Reproduce with clang -O2 -ffp-contract=off -fno-fast-math
-fsanitize=undefined, including ../baseline_ntt, then run the executable.
This host result is not a board-timing result.

[First M55 encoding run](results/B_continuous_ds/encoding/20260927T182456Z/manifest.json):
all 5,242,880 additional edge outputs match the frozen scalar encoder,
including signs, close cancellation, integer precision boundaries and a
complete low-16-bit sweep for each selected upper-word pair. The old 1M
random raw encodes, 1024 edge values, 2070 complete input conversions,
67840 raw selections, 272 further conversions and 63552 fused-input cases
also pass. These do not exhaust all 2^64 inputs or all full-array inputs.

20 operand classes, 20 trials, 128 calls per sample, four coefficients per
call, IRQ masked, with calls/loads/stores included:

| Encoder | 128-call minimum cycles | Comparison |
| --- | ---: | --- |
| B13 archived MVE, encoding/181315Z | 18568 | prior production encoder |
| B14 MVE, encoding/182456Z | 14728 | 20.6807% less time than archived B13 |
| Frozen scalar encoder in B14 ELF | 28810 | B14 is 1.9561x faster |

All B14 MVE samples are 14728 cycles; scalar maxima occasionally reach
28811. The B13-to-B14 comparison crosses ELFs and harness layouts, so it
is not a same-address causal experiment. The instruction reduction is
independently visible in linked code. Same-ELF scalar timing does not imply
that B13 was the scalar implementation.

The fused full-input minima for 32 calls fall from B13's 31346/1773170 to
B14's 29426/1650290 at n=8/512,len=8, also across ELFs. In B14 the test-only
`oracle_b12_from_big` calls the CURRENT encoder: its 34222/2050222 totals
are an old tiled INTERFACE with the new encoder, not an archived B12
production timing. Do not use it to claim an independent B14 arithmetic
gain over unchanged B12. Current fused class minima agree; n=512 has
occasional +1-cycle maxima. No universal CT or physical-leakage proof is
claimed from these finite timings.

## Whole-keygen result

First [whole measurement](results/B_continuous_ds/keygen/20260927T182927Z/manifest.json)
uses 100 common seeds per degree plus three excluded warmups. Original KAT
300 and independent-seed comparison 300 pass; the 200 timed output checks
are outside timing, and retries remain included.

| Implementation | 512 mean cycles | 1024 mean cycles |
| --- | ---: | ---: |
| Frozen M55_ref | 62738244.34 | 261716429.63 |
| Frozen ntt_opt | 56951253.03 | 243157429.30 |
| A8 best repeated run | 54765620.59 | 237610757.98 |
| B13 repeated run | 57276736.52 | 243544929.69 |
| B14 first run | 57164877.71 | 243270787.04 |
| B14 same-ELF repeat | 57164877.46 | 243270787.75 |

B14 whole time falls .1953%/.1126% versus B13; M55_ref/B14 is
1.0975x/1.0758x including the earlier NTT gain. It still takes
.3751%/.0466% more time than ntt_opt and does not beat A8.
The 1.7x target is NOT met; no external production reference was replaced.
The [same-ELF repeat](results/B_continuous_ds/keygen/20260927T183346Z/manifest.json)
differs by only -.25/+.71 mean cycles per key and again validates all 200
timed outputs outside the timing interval.

All 19 required A/B evidence gates match their current crypto source
hashes; B was rerun after this edit, not inherited from B13. B's new-source
signature/verification/one-bit-tamper test passes 90 cases. Kernel checks
cover 640 arrays; maximum FFT raw error is still 257 Q32 units with zero
rounded differences, NOT exact equality of every FFT intermediate.
Fixed-input 220672, final-rounding 1273664, decoder 2228448, raw-product
1000484, complete point-product 640, inverse 320, real-division 640 and raw
quotient 1018184 comparisons all pass. Current run IDs and hashes are in
current_validation.json and evidence_check.json.

The second encoding run 183231Z passes all old and new boundary cases
again. The new encoder remains 14728 cycles for every sample. Scalar
samples span 28809--28810 this time; the +/-1-cycle observations across
runs are retained rather than labeled perfect constant time. Full fused
input minima remain 29426/1650290 with occasional +1 at n=512.
The point-product span's 32-call minima are 54464/3298208 at n=8/512,
with occasional +1; its arithmetic result comparisons pass all 48 classes.
Neither timing observation establishes universal constant time.

## Where the saving occurs

Instrumented profile: B13 181225Z versus B14 183143Z, cumulative cycles
per successful whole key INCLUDING failed attempts. These are not the
non-instrumented whole-cycle totals above.

| Interval | B13 512 | B14 512 | B13 1024 | B14 1024 |
| --- | ---: | ---: | ---: | ---: |
| Large DS input, logn>=4 | 609744.29 | 557749.73 | 1535287.37 | 1406074.35 |
| Small fixed input, logn=1..3 | 482721.84 | 482721.86 | 1561645.63 | 1561667.54 |
| Intermediate point product | 1963657.74 | 1911619.50 | 4924020.90 | 4794611.98 |
| Intermediate reciprocal | 484084.66 | 480272.25 | 960317.36 | 952577.46 |
| depth0 division | 466687.12 | 462802.93 | 933265.03 | 925366.15 |
| Intermediate FFT | 1311175.24 | 1311153.32 | 3481006.68 | 3481028.33 |
| Intermediate iFFT | 1353120.13 | 1353098.36 | 3627109.09 | 3627174.63 |

The large-input interval falls 8.5273%/8.4162%; point product falls
2.6501%/2.6281%. The encoder is also called after reciprocal/division,
which explains the smaller reductions there. FFT/iFFT arithmetic and
small fixed-input costs are essentially unchanged. All 104/114 profile
row call/success counts match after removing interleaved debugger messages.
The current allowed-scope fractions are 13.37099%/7.99855%.

The targeted savings sum to roughly 112k/274k cycles, consistent with the
non-instrumented whole saving 111859/274143. Their closeness is supporting
attribution, not permission to mix instrumented and plain cycle totals.
Function addresses are not pinned across versions; unrelated small layout
differences remain. This is an encoder improvement, not a new FFT kernel
speedup or a 1.7x whole-keygen result.
