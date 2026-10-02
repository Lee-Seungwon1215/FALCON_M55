# B12: small-transform fixed input conversion

This change concerns the input boundary of NTRU intermediate transforms at
public logn=1..3. Large transforms retain B11's continuous two-FP32 arrays.
FFT precision, point products, inverse arithmetic, reduction iteration policy,
NTT/CRT/Bezout and candidate checking are unchanged.

## Implementation and provenance

The B tree now directly implements `fndsa_fixed_input_mve` in its own
`kgen_fft_cm55.s`; `kgen_poly.c:poly_big_to_fixed` calls it after the original
DIVREM31 scale preparation. This uses the locally validated A7 selection
principle, but neither A code objects nor its test evidence are linked or
inherited. The authoritative numerical rule is the original fixed-input
source, not an FP approximation from a paper. General register-aware MVE
batching is informed by the M55 NTT/FFT reading recorded in
../research/reading_log.md.

Each vector lane is one coefficient. All input limbs are read in public
order. Original 24-bit index masks, wrapped sch=-1 at sc=0, sign extension
and shifts are retained. Public n/len determine loops; secret scale affects
only masks/shifts. VCTP-predicated reads handle n=1/2 and scalar short stores
write only valid coefficients. Full blocks use paired VST2 instructions.
There is no secret fast/slow fallback, FP conversion, or additional array.

Linked inspection: helper saves 88 bytes; wrapper uses 24 bytes, total 112
at this boundary. The new signature-test ELF uses 125436 ITCM bytes versus
B11's 126224 (-788 bytes); DTCM remains 250920/262144 bytes, including the
64-KiB stack reservation. These are link-fit facts, not a complete call-chain
stack bound.

## Exact boundary and finite timing tests

[Current B log](results/B_continuous_ds/fixed_input/20260927T175449Z/raw.log),
[manifest](results/B_continuous_ds/fixed_input/20260927T175449Z/manifest.json).
220,672 function calls match the frozen original C converter exactly,
including output guards. Tests cover every scale 0..63487 for designated
3-limb n=1/2/4 arrays, selected n=1..1024/length=0..2047 combinations,
signed edge patterns, random inputs, four word alignments, and null input
when len=0. This is not exhaustive over all data/length/scale combinations.
Input ends are not MPU-guarded; over-read prevention is additionally reviewed
in the predicated loads. Invalid overlapping restrict arguments are excluded.

Paired same-ELF boundary calls, two warmups, IRQ masked, 32 measurements,
minimum cycles including wrapper/timer overhead:

| n | limbs | Original C | B12 | Original/B12 |
| ---: | ---: | ---: | ---: | ---: |
| 2 | 32 | 2841 | 1258 | 2.258x |
| 2 | 512 | 39081 | 17098 | 2.286x |
| 4 | 32 | 5511 | 1256 | 4.388x |
| 8 | 32 | 10867 | 2384 | 4.558x |
| 8 | 512 | 155347 | 34064 | 4.560x |

n=1,len=4 is slower (original 300, B12 331 cycles), as in A7. NTRU
intermediate uses logn>=1, not n=1. This boundary case is still validated,
not hidden or dispatched based on a secret.

32 input/scale classes x20 trials, n=2,len=32,128 calls per trial:
B12 minima 158738, maximum 158739; original minima 361870, maximum 361871.
Class minima agree. One-cycle occasional variation is recorded rather than
claimed absent. This and public-branch/address inspection do not prove
universal CT, constant-duration keygen, power/EM resistance or full safety.

## Integration and current-source gates

First whole-keygen run [20260927T175621Z](results/B_continuous_ds/keygen/20260927T175621Z/manifest.json),
100 common seeds per degree, three excluded warmups, retries included:

| Implementation | 512 mean cycles | 1024 mean cycles |
| --- | ---: | ---: |
| M55_ref frozen baseline | 62738244.34 | 261716429.63 |
| ntt_opt frozen baseline | 56951253.03 | 243157429.30 |
| A8 current best | 54765620.59 | 237610757.98 |
| B11 repeated run | 57693564.37 | 245165387.35 |
| B12 first run | 57432851.46 | 243932694.73 |
| B12 same-ELF repeat | 57432851.94 | 243932694.45 |

The [repeat](results/B_continuous_ds/keygen/20260927T180021Z/manifest.json)
differs by +0.48/-0.28 cycles per key. It uses the same ELF and input seeds,
not a different harness. Each run validates all 200 timed keys outside timing.

B12 decreases whole time by .4519%/.5028% versus B11. It is 1.0924x/1.0729x
M55_ref, which includes the pre-existing NTT improvements. It still takes
.8456%/.3188% MORE time than ntt_opt and 4.8703%/2.6606% more than A8.
Thus A8 remains the best tested candidate. The 1.7x target is not met.
Function addresses are not all pinned across ELFs, so these small whole
differences can include layout effects, not just the changed helper.

All B12 gates were rerun (not inherited from B11): upstream KAT 300,
independent-seed comparison 300, signatures/verify/one-bit-tamper rejection 90,
whole keygen 200 and profiled keygen 200, with exact integer NTRU checks.
Boundary checks include the new 220672 fixed-input calls, 1M encoder values,
67840 selection cases plus full conversions, 1273664 rounded values,
2228448 decoder values, 1000484 exact raw Q32 products, 640 complete point
products, 320 inverse arrays, 640 real divisions, and 1018184 raw quotients.
The 640 FFT array checks have zero rounded differences but maximum raw
error 257 Q32 units; they are NOT all bit-exact FFT intermediates.
Current run IDs and source/ELF hashes are in current_validation.json.

## Profile attribution

Instrumented B11 `20260927T174344Z` versus B12 `20260927T175837Z`, same seeds.
Each value is cumulative cycles per whole key, including profiling overhead.

| Input-conversion range | B11 512 | B12 512 | B11 1024 | B12 1024 |
| --- | ---: | ---: | ---: | ---: |
| logn=1 | 404555.27 | 278043.42 | 1545137.49 | 993504.37 |
| logn=2 | 189974.81 | 119529.84 | 875161.07 | 350058.32 |
| logn=3 | 147748.67 | 85148.62 | 370389.95 | 218191.93 |
| small subtotal | 742278.75 | 482721.88 | 2790688.51 | 1561754.62 |
| logn>=4 (unchanged DS) | 767129.54 | 767129.72 | 1926420.14 | 1926507.31 |
| all intermediate input | 1509408.29 | 1249851.60 | 4717108.65 | 3488261.93 |

Small-input time decreases 34.97%/44.04%; all-input time decreases
17.20%/26.05%. Its saved cycles (259556.69/1228846.72) are consistent with
the main whole-keygen gain (260712.91/1232692.62 in the first run), but the
instrumented and uninstrumented timings are not interchangeable.
All 104/114 profile row call counts and success counts equal B11. No
iteration/retry-policy change is used to obtain this result.

The unchanged FFT interval also shifts by -14625.79/-33920.73 cycles;
its source is unchanged and it is NOT credited as an FFT algorithm change.
Other recorded point/iFFT/integer-update intervals remain nearly equal.
The full allowed target scope is now 13.76734%/8.24569% of instrumented
whole keygen. The remaining time outside that scope still prevents a 1.7x
forecast under unchanged non-target work counts.
