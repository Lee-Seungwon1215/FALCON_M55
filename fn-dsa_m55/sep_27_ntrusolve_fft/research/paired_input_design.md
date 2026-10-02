# Exact n=2 FFT input boundary: two coefficients x two limbs

This is A11, a scoped follow-up to A10, first validated test-only and then
written directly into the existing assembly helper. It is NOT a new FFT
precision scheme, NTT/CRT/Bezout optimization or a Babai iteration change.
The previous profile shows 0.221M/0.769M cycles per key in the n=2 input
boundary. Even removing it entirely would not reach the whole-keygen target.

## Original rule and representation

`poly_big_to_fixed(logn=1, d, f, len, sc)` selects the three original 31-bit
limbs at `(sch-1, sch, sch+1) mod 2^24`, then performs the original sign
extension and shifts. The original documented length is less than 2^24;
DIVREM31 scaling is tested within 0..63487. Both coefficients are stored
interleaved by limb: `[f0_j,f1_j,f0_(j+1),f1_(j+1),...]`.

The incumbent MVE helper uses two active coefficient lanes and leaves two
inactive when n=2. The experiment fills all lanes instead:

| Lane | 0 | 1 | 2 | 3 |
| --- | --- | --- | --- | --- |
| coefficient | 0 | 1 | 0 | 1 |
| limb index | j | j | j+1 | j+1 |

Vector equality predicates select each of the three limb targets. Separate
q0/q1/q2 accumulators OR selected words. Once all limbs have been read, OR
lane0 with lane2 and lane1 with lane3 within each accumulator. Thus values
from different coefficients never mix. The equality predicate is equivalent
to the original 24-bit XOR/subtract/sign-mask selector for the documented
index range. Every input limb is still scanned, regardless of secret scale.

An odd public length loads exactly its last two words; the two other lanes
are explicitly zeroed. The sign word is loaded from the last actual limb
pair, not an invalid padded position. The original sign-extension/shift
sequence is retained and exactly two Q32 outputs are stored.

## ABI, access and control

The test helper saves 36 GPR +4 pad +48 FP bytes =88 bytes, equal to the
incumbent helper, without mutable global scratch. The only conditional
branches are public pair count, public odd length and the public loop count.
Coefficient/scale predicates do not control branch targets or addresses.
This source review is not a formal machine-code or physical leakage proof.

## Independent evaluation before adoption

`validation/fixed_input/pair_board.c` compares original C, incumbent A10 and
the test-only assembly on the same inputs in the same ELF. It covers every
scale for a designated three-limb array, selected lengths 0..4095, four
word offsets, signed edge patterns and pseudorandom words, plus output guards.
All scale tests stay within the DIVREM31 contract. No input-end MPU guard is
claimed. Public n=2,len=32 is timed across 32 coefficient/scale classes;
selected other lengths compare wrapper-inclusive cost too.

This layout is derived from the current code and previously identified
unused lanes, not attributed as a verbatim algorithm from a paper. Existing
M55/TW papers motivate using available lanes and avoiding ABI/temporary
traffic; exact Q32 correspondence must be established separately here.
The production candidate contains its own local assembly path and shares
the incumbent sign/shift/store tail; no test helper, cross-tree link or
backend build flag selects it. This introduces a small public dispatch cost
for other sizes and makes the integrated n=2 call slightly more expensive
than the isolated helper. Both costs are counted, not subtracted away.
