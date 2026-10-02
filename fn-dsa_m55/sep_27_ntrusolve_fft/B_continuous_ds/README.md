# B18 — continuous two-FP32 NTRU workspace

B18 status: immutable inverse cache; all eleven fresh board gates pass.
B17 is archived and its passes were not inherited. See
../validation/b18_inverse_cache_results.md for current evidence and
../validation/b17_decoder_words_results.md for historical results.

For logn>=4 the NTRU approximation arrays remain two FP32 components per real
or imaginary value. Small public sizes keep the original fixed path.

This is a hybrid: the FFT uses the local MVE assembly, while point products,
norms and divisions decode bounded coefficient tiles into integer words, apply
the original Q32 arithmetic rule and encode the output once. There is no complete
Q32 polynomial conversion between each changing-work operation and no secret
fallback. B18 has an explicit ONCE-per-level raw cache of the fixed inverse.
The input/output normalization is still significant. Current-source whole
measurements and validation are tracked in result.md/current_validation.json;
earlier-source results are not inherited. It is NOT a production-ref replacement.

B5 adds `fndsa_ds_encode4()` in this directory's own `kgen_fft_cm55.s`:
four-lane exact translation of the former scalar input expansion, retaining
the original limb scan/secret-scale masks in `fndsa_ds_from_big()`.
B6 adds `fndsa_ds_round4()` and calls it from `fndsa_ds_to_k()` for logn>=3:
original TwoSum ordering, finite/range masks, negative low-component tie
correction, true 64-bit sum/overflow checks. Its scratch is 64 private bytes,
not an extra polynomial buffer. Smaller public sizes retain the scalar path.
These changes do not replace the FFT arithmetic or silently change Q32 rules.

B7 adds `fndsa_ds_decode4()` and a four-complex-coefficient tile in
`fndsa_ds_mul()`. The original three-product integer Q32 multiplication is
retained, while four-lane decoding/encoding amortizes its FP32 boundaries.
The decoder preserves small/subnormal inputs when scaling by 2^32 through
integer exponent handling plus exact uint23-to-FP conversion. It must not
use an ordinary MVE multiply on a subnormal input: that lost the value in a
dedicated board test even with scalar FPSCR.FZ clear. No secret fallback is
introduced. The private point tile is 128 bytes, not a polynomial array.

B8 uses the same four-lane representation edges in `fndsa_ds_inverse()`
and `fndsa_ds_div_real()` (64/96-byte private tiles). Squares, norms and
`inner_fxr_div()` remain the original Q32 arithmetic, not native FP division.
Both division input aliasing and untouched array slots are checked separately.

B9 adds `fndsa_ds_select4()` to scan the input integer limbs for four
coefficients at once before calling the same exact encoder. Every input
limb is read in the same public order regardless of scale; original masked
selection, sign extension and Q32 shifts are retained. Only the public
length controls the assembly loop. Small public sizes still use the original
scalar path. The scale domain is the original DIVREM31 domain (0..63487).

B10 adds `fndsa_ds_div4()` directly in this directory's assembly file.
It executes four copies of the original 64-bit Q32 quotient recurrence
without changing rounding, sign or zero-denominator behavior. The high and
low quotient halves are accumulated separately; carries/borrows remain per
coefficient, not between real/imaginary values or neighboring lanes.
`fndsa_ds_inverse()` and `fndsa_ds_div_real()` call it for public logn>=3.
The inverse tile grows from 64 to 96 private bytes; the helper uses 32 scratch
bytes plus 80 saved-register bytes. Original scalar small-size paths remain.
This is an integer-MVE quotient within the continuous-FP32 design, NOT a
claim of native floating division or a secret precision fallback.

B11 replaces the B7/B10 C point-product tile with `fndsa_ds_mul_span`,
a single locally written assembly loop containing exact decoder/encoder
macros and three four-lane Q32 integer products. Upper/lower products and
lane-local carries preserve the original signed Q32 formula, including
wrapping input sums and product truncations. It is not a native-FP product
rewrite. The frame is 256 scratch bytes plus 80 saved-register bytes;
the C wrapper restores its frame before tail-calling this span. Full input
blocks precede output stores, including d==b. Small public sizes are unchanged.
The historical 128-byte C point tile above is no longer the current path.
See ../validation/point_fusion_results.md for current-source evidence.

B12 additionally replaces `poly_big_to_fixed()` with its own exact integer
MVE input converter, `fndsa_fixed_input_mve`. This is the fixed fallback used
at public logn=1..3 in the intermediate solver, not a change to the large
DS FFT or its precision threshold. The original three-word window, sign
extension, all-limb scan and scale rules are retained. Masked n=1/2 reads
and exact-size stores avoid extra coefficient accesses; full blocks use
VST2 to interleave the Q32 words. The implementation is resident in this
directory's assembly file, not linked from A. See
../validation/b12_fixed_input_results.md for this source's own measurements.

B13 fuses the large-input limb selector and exact FP32 encoder into
`fndsa_ds_from_big_span`, also in this assembly file. Selected high/low words
stay in vector registers until the encoded output is stored. One public-count
loop handles the real and imaginary planes; no 32-byte word tile or per-block
helper calls remain. The original selector/encoder instructions are shared
through local assembly macros, not other candidates. The unchanged n=2/4 C
fallback is a private non-inlined function so its large register-save frame
does not burden the vector path. See ../validation/input_fusion_results.md.

B14 shortens only the encoder's five error-free addition pairs with
FastTwoSum. Their ordered-or-zero-left operands follow from the raw Q32
split; no key-dependent magnitude test or fallback is added. Residual
additions and their rounding points are retained, and the general TwoSum
used by the decoder and rounder is unchanged. The standalone encoder drops
from 69 to 54 instructions. This also shortens its inline instances in the
input and point-product spans. See ../research/encoder_fastsum_design.md
for the application-specific bounds and references. Measured outcomes and
current-source validation are recorded separately; a shorter instruction
sequence alone is not a whole-keygen performance result.

B15 shortens only `DSS_SELECT_CORE`: the all-ones/all-zero masks for selecting
three limbs become vector equality predicates on their OR instructions.
Every limb is still loaded unconditionally, in the same public-count loop.
The identity is exact under the original len<2^24 precondition. q5 is scratch
and is overwritten for sign extension after the scan. The common macro is
expanded in `fndsa_ds_select4` and `fndsa_ds_from_big_span`; encoder, rounding,
FFT arithmetic, small fixed fallback and representation policy are unchanged.
Its own fresh raw-selection, encoded-array, KAT and performance gates are
required. The tiled test oracle uses the current selector and is not an
unchanged B14 performance baseline.

B16 shortens three decoder-only error-free sums. The two fractional
extractions use Fast2Sum(-floor(x),x); the final normalization uses the
nonnegative-fraction bound. The middle unordered sum, both residual
additions, subnormal-preserving scaling and integer carry/tie rules remain.
Zero residual signs can differ but final raw words must match. The
derivation and tests are in ../research/decoder_fastsum_design.md. No
general decoder/rounder/FFT sum is replaced without a site-specific argument.

B17 keeps that FP arithmetic unchanged. It extracts the exponent field by
two shifts, uses scalar-operand vector subtractions instead of duplicate
constants, directly materializes two encodable vector constant bit patterns,
and adds lane-local carries under the original comparison predicates. It
does not remove subnormal handling, change precision or mix lane carries.
Standalone and four inline decoder instances share this own-source macro.

B18 decodes the already ENCODED, immutable inverse once into the original
rt3 storage, then calls `fndsa_ds_mul_cached`. The changing DS working array,
FFT and iFFT are unchanged. Both general and cached point assembly expand
one own-source product/encoder macro, with identical original Q32 rules.
Only the source of the second operand's raw words changes. The cache is
exactly n fxr slots and precedes k/NTT scratch; no new global or stack array
is allocated. Preparation is charged to I_mul and whole keygen timing.
One multiply alone does not amortize it, so hot-call microtiming must not be
presented as the complete speedup. No reduce_bits/iteration/update change.

Source is independent, no cross-candidate crypto linking or backend flags.
Original orthonorm, NTT, CRT, Bezout, signing and verification are untouched.
See ../result.md, ../research/experiment_log.md and the archived manifests.
