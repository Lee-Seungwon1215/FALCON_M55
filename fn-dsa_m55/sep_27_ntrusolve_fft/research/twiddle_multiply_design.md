# Exact Q32 multiplication by a public FFT constant

This started as a test-only hypothesis in validation/twiddle. After the
complete-transform tests, the vector-surrounding variant was directly
implemented in A9's own C/assembly. B14 remains unchanged. A9 integration
evidence is recorded separately from the initial standalone results.
It investigates the fixed part of A's hybrid, not a claim of native FP
multiplication or a reuse of modular Montgomery/Plantard arithmetic.

## Why specialize the repeated operand?

The original complex multiplication deliberately computes three Q32
products: re*re, im*im, and (re+im)*(re+im), each with its own truncation.
A four-product real/imaginary formula would not necessarily match its bits.
In FFT butterflies one operand is a public GM_TAB root. Individual root
components are bounded by one, but their sum can exceed one. In inverse
FFT the conjugated root sum can be below minus one. Discarding the high
word of all three multipliers is therefore invalid.

The mechanically copied original table has 1024 complex entries. The
forward/inverse loops at logn=1..10 use 511 entries and 3066 product-constant
occurrences. Their signed high words are distributed as follows:

| High word | Occurrences |
| ---: | ---: |
| -2 | 255 |
| -1 | 1275 |
| 0 | 1280 |
| 1 | 256 |

The actual stored Q32 values span approximately -1.4142069066874683 to
+1.4142135623842478. These are stored, rounded constants, not an assertion
that every value is bounded by exact sqrt(2).

## Exact limb identity

Write signed x = xH*2^32+xL and t=tH*2^32+tL, with signed xH/tH and
unsigned xL/tL. The original result modulo 2^64 is

    floor(x*t / 2^32) = floor(xL*tL / 2^32) + xH*tL + x*tH.

The first term uses VMULH.u32. The middle term uses VMUL.i32 and
VMULH.s32 on xH and the signed interpretation of tL. If tL's top bit
is set, add xH to the high output word to restore unsigned tL semantics.
Adding the first term uses a lane-local carry. Finally add x, subtract x,
subtract 2*x, or do nothing according to public tH. All operations wrap
exactly modulo 2^64; no bound on the secret coefficient x is assumed.
The subtraction of 2*x uses both words, including the low-to-high carry.

The MVE routine processes four x values, with VLD2/VST2 to preserve the
original interleaved 64-bit layout. Eight loop bodies specialize the four
public high words times tL's public top bit. Dispatch depends on the
twiddle, never on coefficients, and occurs once per span. Lane predicates
only propagate carry/borrow without changing control flow or addresses.
The API requires n>=4, n divisible by four, and tH in {-2,-1,0,1}. Its
untested out-of-domain behavior is not a generic multiplication contract.

## Inspiration versus proof

For this experiment we revisited local m55_ntt-ftt_opt.pdf pp.18-19:
limited vector registers, deinterleaving and amortizing a repeated operand's
preparation guide the layout. Its Montgomery algorithms do NOT prove this
Q32 identity. TWfalcon.pdf p.18 motivates exploiting a known operand
structure, but its single/triple-word floating-point rules are not copied
as Q32 rounding rules. The limb identity above is our own exact-integer
derivation from the existing code, not a theorem claimed by either paper.
No SLOTHY invocation or generated schedule is used.

## Gates and cost accounting

The first isolated board test compares 1,228,864 exact words against the
original fxr_mul inline integer assembly, including every used table
constant, raw integer extremes and pseudorandom words. It also checks 256
in-place/guarded spans. The same-ELF timings include constant dispatch,
loads, stores and function calls. Fixed-constant input classes assess
timing variation; times across different PUBLIC constants may differ.

A short four-coefficient call can lose to the original scalar path even
when a long span wins. Thus the subsequent test-only complete FFT/iFFT
varies public batch sizes 32/64/128 and minimum vector spans 4/8/16. It
retains small original butterflies and all stagewise iFFT half roundings.
Three span products preserve the original complex formula, including
wrapping the sum before its product. Its private 3*128 Q32 temporary tile
is 3072 bytes: this overhead and all combining/call work stay inside the
timed transform. A winning isolated multiplication alone is insufficient
to adopt this implementation into a whole key generator.

Finite bit/guard/timing tests and the identity are not a formal machine
proof, universal constant-time proof, or whole-call-chain stack bound.
Whole KAT and signature gates are required for the A9 production edit.

## Complete-transform follow-up

The first staged version (vector products, scalar C combining) lost for
every nontrivial transform in the nine tested batch/cutoff combinations.
We retained it as fft_trial.c instead of claiming the isolated multiplier's
speedup for the whole transform. fft_vector_trial.c then vectorized the
surrounding Q32 sum, three-product combination, butterfly add/sub and
stagewise half, with explicit lane-local carries/borrows. These routines
still use a local tile rather than claiming everything fits in registers.

Both versions were compared with the unchanged fixed kernels in the same
ELF, 5760 class/size/configuration cases, all raw words and inactive slots
equal. The vector-surrounding version wins for n>=128, but small transforms
still lose. The selected production parameters are a fixed batch of 128,
forward vector span threshold 4, inverse threshold 8, and scalar fallback
for logn<7. These are direct source constants, not build/backend switches.
Only three calls in solve_NTRU_intermediate change; the candidate norm
check, original fixed FFT entry points and depth0 FP path are preserved.
