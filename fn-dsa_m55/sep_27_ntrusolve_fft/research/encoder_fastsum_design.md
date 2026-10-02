# B14: bounded FastTwoSum in the raw-Q32 encoder

## Scope and source of the theorem

Only the five error-free additions in `DSE_ENCODE_CORE` are shortened.
The general `DSE_TWO_SUM` in the decoder/rounder and all FFT butterflies
remain unchanged. The production path contains no magnitude test, operand
sorting, secret-dependent branch or precision fallback. The conditions are
properties of the encoder's construction, not runtime assumptions about a key.

[Boldo and Muller, Exact and Approximated Error of the FMA, section 2.1](https://perso.ens-lyon.fr/jean-michel.muller/error_fma_TC_publie.pdf)
states the Fast2Sum error-free transformation under round-to-nearest and
ordered exponents. [Rump, Ogita and Oishi, Accurate Floating-Point Summation,
Part I, Algorithm 2.5 and Lemma 2.6](https://ogilab.w.waseda.jp/ogita/math/doc/2008_RuOgOi_01.pdf)
gives more general conditions; the sufficient magnitude condition is enough
here. The operation returns the same rounded sum and exact residual as
TwoSum using three instead of six arithmetic operations. The a=0 case is
also exact directly: s=b, t=b, residual=+0. We do not apply a theorem about
arbitrary unsorted operands or non-nearest rounding modes.

The following application-specific bounds are our derivation from the
original encoder, not results claimed by those papers. They are a real-
arithmetic/IEEE-operation argument, not a formal machine-code proof.

## Original decomposition

Let H be the signed high 32-bit integer word, and L the unsigned low word.
Define exact binary32 inputs:

    A = floor(H / 65536) * 65536
    B = H mod 65536
    U = floor(L / 65536) * 2^-16
    V = (L mod 65536) * 2^-32

A and B are exact floats, including negative A. Thus A+B=H;
0<=B<2^16, 0<=U<1, 0<=V<2^-16. The original sequence is:

1. (h0,l0) = TwoSum(A,B)
2. (s1,e1) = TwoSum(h0,U)
3. (h1,l1) = TwoSum(s1, RN(e1+l0)+0)
4. (s2,e2) = TwoSum(h1,V)
5. (h2,l2) = TwoSum(s2, RN(e2+l1)+0)

Both additions of residuals, both explicit +0 operations, casts and powers
of two remain in their original order. Only the implementation of those
five individual TwoSum pairs changes, not the sequence's rounding points.
Two floats cannot encode all 64 raw bits exactly; the aim is to reproduce
this existing expansion, not invent a differently rounded expansion.

## Why each shorter sum is valid

Use u=2^-24. An error-free pair (h,l) formed by nearest binary32 addition
has |l|<=u*|h| when h is nonzero. All operations here stay within the
2^-32 grid, with magnitude at most a small multiple of 2^31. There is no
subnormal, overflow, NaN or infinity at any of these sites.

1. If A is nonzero, |A|>=65536>B. If A=0, the zero-left identity applies.
2. If H is nonzero, |h0|>=1>U. If H=0, h0=l0=0 and the zero-left case applies.
3. If H is 0 or -1, h0+U is exactly representable on the 2^-16 grid,
   l0=e1=0, so the normalization has a zero second operand. In all other
   cases |h0+U|>=1 and |h0|<=2|h0+U|. Therefore, with t=RN(e1+l0),

       |t| <= 3u(1+u)/(1-u) * |s1| < |s1|.

   This follows from |l0|<=u|h0|, |e1|<=u|h0+U| and the nearest-rounding
   relative bound. Thus FastTwoSum is valid. Its output again satisfies
   the nonoverlap residual bound.
4. Small h1 values arise from the exact H+U grid for H=0 or -1; every
   nonzero such h1 has magnitude >=2^-16. For all other H the magnitude
   is >=1. Consequently |h1|>V unless h1=0, where l1=0 as well.
5. If h1=0, the correction is zero. The only close negative-cancellation
   case |h1|<2^-15 is h1=-2^-16, because the small values lie on the
   2^-16 grid. It has l1=0 and h1+V exactly representable on the 2^-32
   grid, so e2=0. For positive h1 or h1<=-2^-15, |h1|<=2|h1+V|;
   the same 3u(1+u)/(1-u) bound makes |RN(e2+l1)|<|s2|.

Thus each nontrivial site satisfies the sufficient magnitude condition;
the exceptional mathematical cases are exact identities, not code branches.
For zero residuals, subtraction of equal finite numbers under RN yields +0;
the original exact residual sum also yields +0. Explicit +0 operations stay
present. No negative-zero input is manufactured by the integer-to-float split.

## Implementation and evidence limits

`DSE_FAST_TWO_SUM` emits add, subtract, subtract, and a register move.
Replacing five seven-instruction TwoSum expansions removes 15 vector
instructions per four encoded coefficients, while retaining both outputs.
The shorter macro is deliberately separate from the general macro.

Host hypothesis check: validation/host/check_encode_fastsum.c, clang -O2,
-ffp-contract=off -fno-fast-math -fsanitize=undefined. It checks the sufficient
condition at every site and compares each pair's bits, plus final output,
against the original six-operation sum. 15,242,880 cases pass: 5,242,880
structured edge words and 10M random words scaled over 33 signed ranges.
This finite host check does not validate ARM emission or prove all inputs.

M55 tests must additionally check actual vector output bits, whole KAT,
signatures, numerical kernels and operand-class timing. The new board edge
sweep uses the 5,242,880 structured words against the unchanged scalar
encoder, including both signs, cancellation and binary32 integer boundaries.
Source/ELF/log hashes and measured outcomes belong in the validation report;
none of the paper speedups or host timings are claimed as M55 performance.
