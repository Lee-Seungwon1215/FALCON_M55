# B13: fuse the large input boundary

## What changes

B12's logn>=3 `fndsa_ds_from_big` calls a four-coefficient selector and
encoder for each block, materializing 32 bytes of selected raw Q32 words.
B13 performs the same selection and expansion in one directly written local
assembly span. It retains all-limb reads, original shift/sign/mask rules and
every FP32 TwoSum operation in its original order. This is not an approximation
or a new precision policy. NTRU uses this DS path at public logn>=4 as before;
small fixed NTRU transforms retain B12's fixed-input improvement.

Only B's kgen_fft_mve.c and kgen_fft_cm55.s change from B12. No cross-tree
crypto linkage, backend build selector, or SLOTHY is used. The selector core
and encoder are local assembly macros also exercised through standalone
entry points. The old word tile is eliminated; selected words pass directly
from q0/q4 into q0/q1 of the encoder.

The standalone selector's 77 machine instructions and encoder's 69 machine
instructions are byte-identical between the archived B12 encoding ELF
175926Z and B13 180800Z. Macro extraction did not change those two bodies.

The vector routine's registers r4..r7 retain len/stride/scale, r8..r10 the
masked window indices, lr the current source block, and r2/r3 the two output
planes. Only public remaining-count and limb-count branches exist. The
halfway plane adjustment is 4096 minus 4*(n/2) bytes. Layout assertions in C
already fix 2048-byte component and 4096-byte imaginary offsets. n>=8 and
power-of-two ensure full four-lane accesses. No arbitrary-length API is claimed.

The unchanged scalar n=2/4 input formula moves into a private non-inlined
function. Current linked vector wrapper frame: 48 bytes (previously 456).
The new span saves 88 ABI/alignment bytes and uses 8 local bytes, for 96
total. The vector call chain therefore uses 144 bytes here instead of
456+88=544 for B12's deepest selector call. This is a local stack accounting,
not a worst-case whole-NTRU stack proof.

The linked signature firmware uses 125672 ITCM bytes (+236 vs B12) and
250920 DTCM bytes (unchanged, including the reserved 64-KiB stack). The
local stack reduction is not a reduction in the fixed reserved stack size.

## Provenance and method

The numerical reference is the original `poly_big_to_fixed` selection rule
and frozen scalar FP32 expansion in validation/encoding/oracle.h. TWfalcon
p.18, revisited for this experiment, motivates combining interfaces so
register-resident values need not cross the stack. It does not prove this
two-FP32 keygen implementation: its own context is triple-word arithmetic.
The MVE register/stack principles were assessed in the project reading log.
No claimed paper algorithm is silently substituted for the Q32 rules.

## Boundary comparisons and timing

[First B13 encoding run](results/B_continuous_ds/encoding/20260927T180800Z/manifest.json).
Existing tests pass: 1M raw encodes plus 1024 edge values, 2070 complete
conversions, 67840 raw selection cases and 272 additional full conversions.
The new tests add all 63488 scales in the documented domain for a designated
n=8,len=3 array against the original scalar oracle, plus 64 size/input-class
pairs against the former B12 tiled function. All active and inactive DS
slots match exactly. These are finite tests, not all-input equivalence.

New paired timing uses the same ELF and inputs, with B12's former tiled
interface as a noipa test-only function. Two warmups, IRQ masked, 32 calls
per trial, 20 trials per operand class, len=8. Both timings include the full
input interface, not just the encoder. No timed work is moved outside it.
The test reference retains B12's vector tiled body but delegates its small
fallback to the frozen oracle; its linked C frame is 104 bytes, not the
456-byte frame of B12's production wrapper. Thus this paired experiment
isolates the tiled-versus-fused interface with its own compiler layout. It
is not a byte-for-byte timing replay of the former production ELF. The
whole-keygen comparison below uses that actual archived B12 production run.

| n | B12 32-call minimum | B13 minimum | time decrease | B12/B13 |
| ---: | ---: | ---: | ---: | ---: |
| 8 | 36142 | 31346 | 13.2699% | 1.1530x |
| 512 | 2173102 | 1773170 | 18.4037% | 1.2255x |

All 32 class minima agree at each size. Observed B13 maxima are 31347 and
1773171; B12 maxima 36142 and 2173103. The occasional one-cycle variation
is recorded, not explained away or treated as a universal CT proof. Branches
and addresses were additionally inspected in the linked current code.

The same-ELF repeat encoding/20260927T181315Z passes all cases again.
Class minima remain unchanged; B13 n=8 maxima equal its minimum this time,
while n=512 still occasionally has +1. It is not a new arithmetic change.

## Integration and profile attribution

All current-source gates have passed: upstream KAT 300, independent-seed
comparison 300, signature/verification/one-bit-tamper checks 90, keygen 200
and instrumented keygen 200 with exact NTRU equation checks. Boundary tests
rerun the encoder/selector additions above, fixed inputs 220672, final
rounding 1273664, decoder 2228448, exact raw products 1000484, complete
point products 640, inverse arrays 320, real divisions 640 and raw quotients
1018184. All tested exact boundaries match their references. FFT's 640
array checks still have max raw error 257 Q32 units and zero rounded
differences, NOT universal bit equality of FFT intermediates.

First whole run [20260927T180928Z](results/B_continuous_ds/keygen/20260927T180928Z/manifest.json),
100 common seeds per degree plus three excluded warmups, retries included:

| Implementation | 512 mean cycles | 1024 mean cycles |
| --- | ---: | ---: |
| M55_ref frozen baseline | 62738244.34 | 261716429.63 |
| ntt_opt frozen baseline | 56951253.03 | 243157429.30 |
| A8 current best | 54765620.59 | 237610757.98 |
| B12 repeated production ELF | 57432851.94 | 243932694.45 |
| B13 first run | 57276736.26 | 243544928.93 |
| B13 same-ELF repeat | 57276736.52 | 243544929.69 |

The [same-ELF repeat](results/B_continuous_ds/keygen/20260927T181434Z/manifest.json)
changes the mean by only +0.26/+0.76 cycles per key and again validates
all 200 timed outputs outside timing.

Whole time decreases .2718%/.1590% versus B12. M55_ref/B13 is
1.0954x/1.0746x, including the pre-existing NTT gain. B13 remains
.5715%/.1594% slower than ntt_opt, and A8 remains best. The 1.7x goal is
NOT achieved. Placement policy is common but function addresses are not all
pinned across ELFs; small differences can also include layout effects.

Profile B12 175837Z versus B13 181225Z, cumulative cycles per whole key:

| Input conversion range | B12 512 | B13 512 | B12 1024 | B13 1024 |
| --- | ---: | ---: | ---: | ---: |
| small fixed logn=1..3 | 482721.88 | 482721.84 | 1561754.62 | 1561645.63 |
| DS logn>=4 | 767129.72 | 609744.29 | 1926507.31 | 1535287.37 |
| all intermediate input | 1249851.60 | 1092466.13 | 3488261.93 | 3096933.00 |

The targeted large-input interval falls 20.5161%/20.3072%; small-input
and FFT/point/iFFT/integer-update intervals stay nearly equal. All 104/114
profile row call/success counts match B12. Saved input-profile cycles
157385.47/391328.93 are consistent with the principal whole-keygen gain
156115.68/387765.52, but instrumented and uninstrumented numbers are not
substituted for one another. The allowed target scope is now
13.53604%/8.10047% of instrumented whole time.

Current-source gates, ELF/log/source hashes and the repeated whole result
are tracked in current_validation.json and ../result.md. No external
production reference directory was replaced.
