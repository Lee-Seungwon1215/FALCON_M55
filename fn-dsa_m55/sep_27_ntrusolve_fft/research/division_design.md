# B10 candidate: four exact Q32 quotients

## Why this experiment

B9's instrumented depth0 real division costs 1.024M /2.049M cycles per
key (512/1024); its intermediate norm/reciprocal costs 1.013M /2.034M.
Each coefficient still invokes `inner_fxr_div` twice. That routine emits
64 quotient bits plus one rounding decision using a fixed iteration count.
The surrounding polynomial representation remains two FP32 components.

The Monniaux/Pain FP-assisted division paper (sections 2–3) gives a useful
approximate quotient -> exact remainder -> bounded correction principle:
https://arxiv.org/html/2207.08420v1 . Its proved 64/64 integer routine is not
an immediate replacement for the Q32 scaled 96/64 numerator, its signed
wrapping rules or denominator-zero recurrence. No such proof is claimed or
silently assumed here. A new FP quotient would require its own bounds.

This first B10 candidate instead translates the original bit recurrence to
four independent integer MVE lanes, retaining the DS arrays before/after.
It is not a new floating division formula and does not introduce an
operand-dependent fast/slow fallback.

The frozen source already contains `avx2_fxr_div_x4` in
`baseline_ntt/kgen_fxp.c`: four parallel copies of this recurrence for AVX2.
That is an algorithmic precedent, not directly usable M55 assembly. Our MVE
version uses paired 32-bit vectors for 64-bit state, explicit lane borrows,
and a two-part quotient schedule to fit eight Q registers. It does not
link the AVX2 routine or enable an AVX2/backend build option.

## Register-level invariant

Each logical 64-bit quantity uses two Q registers: four low words and four
high words. No real/imaginary carry is shared and no carry propagates from
one coefficient to the next. We intentionally do not treat MVE's chained
multiword VADC/VSBC carry as four independent carries.

- q0/q1: low/high `num` (remainder state).
- q2/q3: low/high absolute divisor.
- q4/q5: accumulated quotient.
- q6/q7: temporary difference, borrow and shift bits.
- 32 private stack bytes: numerator input-bit stream and final XOR signs.

For every iteration, subtract low words and detect their unsigned borrow;
subtract high words with that per-lane borrow. The difference high sign bit
is exactly the original `(num-y)>>63`, including the original edge behavior.
VPSel selects the difference when the original bit b is one. Shift quotient
and append b, shift remainder and append the next numerator bit. There are
31 input-bit iterations and 33 zero-bit iterations, followed by the original
rounding and sign operations. All branches use constant loop counters.

After the initial implementation, a second variant accumulates quotient
bits 63..32 directly in the high-word vector and bits 31..0 directly in the
low-word vector. This removes three cross-word shift/or instructions per
iteration. The numerical recurrence is the same: 31 input-bit iterations,
one zero-bit step completing high, and 32 zero-bit iterations completing low.
The common rounding still propagates a low-word carry into the high word.

The scalar recurrence is unchanged even for zero denominator and the raw
edge values for which the original comments do not promise mathematical
division. This claim must be checked against that exact C routine, not a
mathematical host `/` oracle with a different domain or rounding convention.

The relevant instruction forms (32-bit subtract, scalar operand, vector
predication and comparison) are specified by Arm ACLE's MVE reference:
https://arm-software.github.io/acle/mve_intrinsics/mve.html . ACLE supplies
instruction semantics, not this algorithm or a speed/constant-time proof.

## Gates before adoption

1. Assemble the directly written local `.s` function.
2. Compare raw 64-bit outputs with unchanged inner_fxr_div for edge pairs,
   signs, zero, aliasing, output guards and randomized full-width inputs.
3. Paired M55 cycles including calls, and fixed-public-size operand classes.
4. Only if useful, call it from B's own inverse/division four-coefficient
   tiles, then rebuild all current-source KAT, signature, profile and kernel
   tests. No result from an earlier source version transfers automatically.

The 1.7x whole-keygen target is not implied by this candidate. No NTT, CRT,
Bezout, Babai iteration policy, candidate test or SLOTHY change is made.

## A8: direct Q32-array adapter, independent of B

A7's `vect_inv_mul2e_fft` consumes 0.933M/1.872M instrumented cycles per
key. Its arrays already use interleaved low/high `fxr` words. A8 implements
the same four independent recurrences directly in A's own assembly as
`fndsa_fxr_div4`, using VLD20/VLD21 and VST20/VST21 to split and rejoin
those words. It does not convert to double or DS and does not link B's
function. The original norm, negation and scale operations are retained.

Only public logn>=3 batches have four coefficients per half; logn=1/2 keeps
the original scalar path. A 32-byte denominator tile is reused for real and
imaginary numerators. This is not a 32-byte total stack claim: the current
keygen ELF has a 136-byte C frame plus the helper's 112-byte frame. The
helper saves/restores r4-r6 and d8-d15 and uses no caller memory beyond the
two 32-byte arrays. The reciprocal wrapper's branches depend on public
logn/indices; quotient branches depend only on the fixed 31/32 counters.

The global `inner_fxr_div` and candidate-check `vect_invnorm_fft` are left
unchanged. Thus this is NTRU FFT surrounding arithmetic, not a global
division change or a claim that integer-only input conversion/reciprocal
has become floating point. Dedicated `fixed_division` tests compare raw
words and the complete reciprocal wrapper before whole-program gates.
