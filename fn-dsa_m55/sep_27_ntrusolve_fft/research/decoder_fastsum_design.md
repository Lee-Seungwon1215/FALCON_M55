# B16: decoder-specific Fast2Sum, not a general replacement

Prior goal turn: progress (B15 implementation and eleven board gates).
This experiment attacks B's 1.912M/4.795M-cycle point-product interval,
specifically its four DS-to-Q32 decoders per four-complex-coefficient block.
The 1.7x whole-keygen target remains unmet; no algorithm-work/scope change.

## Derivation

Authoritative original rule: local frozen scalar qd_raw_floor. Let
x=hi*2^32, y=lo*2^32, f=floor(x), g=floor(y). The decoder separately
extracts error-free fractional pairs for x-f and y-g, combines them and
uses the pair's floor (including the negative-residual-at-integer tie) to
correct the modulo-2^64 sum of f and g. Dropping a tiny negative residual
would be wrong; B16 retains it.

[Boldo and Muller, Exact and Approximated Error of the FMA, section 2.1,
Algorithm 1](https://perso.ens-lyon.fr/jean-michel.muller/error_fma_TC_publie.pdf)
states Fast2Sum under round-to-nearest with the first operand's exponent
at least the second's. The following application to floor extraction is
our derivation, not a claim made about Falcon by that paper.

1. Use Fast2Sum(-f,x), reversing the original x,-f order. For x>=1, floor(x)
   has the same binary exponent as x. For x<0, |floor(x)|>=|x|. For
   0<=x<1, f=0 and the zero-left identity is exact directly. Thus no runtime
   magnitude test, branch, sorting or input-specific fallback is necessary.
   The same argument applies independently to y and g.
2. The middle sum of the two rounded fractions retains GENERAL TwoSum;
   those operands are not ordered. Preserve `(error+first_residual)+second_residual`
   in exactly that order.
3. Only the final normalization uses regular Fast2Sum. Both true fractions
   are nonnegative and their rounded leading values h1,h2 lie in [0,1].
   Each residual satisfies |l_i|<=u*h_i, u=2^-24. Let s=RN(h1+h2) and e
   be its error. For s>0, |e|<=u*s and h1+h2<=s/(1-u). Therefore the
   twice-rounded correction t satisfies

       |t| <= u*(1+u)^2*(1+1/(1-u))*s < 3*u*s < s.

   If s=0 then all terms are zero. This proves the sufficient magnitude
   condition without assuming arbitrary cancellation-free DS inputs.

Inputs are finite with exponent field <=222, so scaling by 2^32 remains
finite. Nonzero scaled inputs and fractional residuals lie on a 2^-117
grid; these fractional steps have neither underflow nor overflow. The
existing DSD_SCALE32 handles original subnormals without feeding them to
MVE FP arithmetic. It is unchanged. Floor/bit decoder and signed carry/tie
correction are unchanged.

Signed-zero caveat: reversing x=-0 and -floor(x)=+0 can produce -0 rather
than +0 in the residual. Numerical values agree; downstream additions,
floor, equality and residual<0 treat them identically for the raw result.
We do NOT claim all intermediate residual bits are identical. Nonzero
residual bits and the final uint64 output must agree.

## Implementation and validation

Three seven-instruction sums in DSD_DECODE_CORE become four-instruction
sums, saving nine vector instructions per decode. The unchanged macro
interfaces/scratch mean the same local source is used by standalone
decode4 and the four inline point-product decoders. Other general sums in
the rounder and FFT are untouched. No new workspace/table, SLOTHY or backend
selection. A source and linked instruction review is required.

Host test `validation/host/check_decode_fastsum.c`, clang -O2,
-ffp-contract=off -fno-fast-math -fsanitize=undefined: 13,653,956 paired
inputs and 27,307,912 fractional checks pass, including exponent/sign grids,
zero/subnormal/rounding edges and 10M pseudorandom/encoded raw inputs.
203,010 fractional checks differ only in zero sign, explicitly counted.
This finite host result does not establish ARM instruction semantics or
universal original-KAT equivalence. Fresh M55 decoding, original KAT,
independent seeds, signature, boundary, timing and whole-keygen gates are
mandatory. Any first failing case stops performance adoption.
