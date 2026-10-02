# Exact arithmetic contract

## Representation

`fp64_exact { double hi, lo; }`: each field is an integer in `[0,2^32-1]`, exactly representable as binary64. Let `U=hi*2^32+lo` as a mathematical integer; real interpretation is `signed64(U)/2^32`. Code never collapses the pair into a single double.

Compiler contract: binary64, round-to-nearest, no fast-math/reassociation or fused contraction. No coefficient reaches subnormal/NaN/Inf arithmetic: nonzero component values and partial products/scalings are normal, bounded powers-of-two rationals. This does not establish a hardware-wide constant-time proof.

## Add / subtract / wrap

The low-word sum is at most `2^33-2`. Its carry is extracted using `uint32(s*2^-32)`. The low remainder and high-word sum are computed using FP64 additions/subtractions and exact powers-of-two scaling. All intermediate integers are below `2^34`; none lose a bit. Normalize the high word modulo `2^32`, preserving unsigned 64-bit wrap.

Subtraction adds a positive `2^32` bias to the low/high word before the subtract and borrow correction. This keeps each floating-to-uint32 conversion nonnegative and within range. Negation uses subtraction from zero. No secret-dependent correction loop or lookup.

## Multiply

Split raw words into four base-`B=2^16` digits, each stored as double. Compute convolution columns 0..5, propagating exact base-B carries. Four products plus carry sum to less than `2^35`, below binary64's 53-bit integer precision. Products/additions therefore are exact, not approximate estimates. Cast only each nonnegative carry (`<2^19`) to uint32. Digits 2..5 give:

```text
R = floor(Ux*Uy / 2^32) mod 2^64
```

For signed operands `X=Ux-sx*2^64`, `Y=Uy-sy*2^64`:

```text
floor(X*Y/2^32) mod 2^64
  = R - sx*Uy*2^32 - sy*Ux*2^32 mod 2^64
```

Hence subtract `sx*Uy_low + sy*Ux_low` from the result high word. Add `2^33` first so the intermediate stays nonnegative, then normalize modulo `2^32`. Low word is unchanged. These coefficient partial products and sign corrections use FP64 arithmetic; there is no integer coefficient multiply in this primitive.

Complex multiply preserves original three-product graph and quantization after **each** real multiply/add/subtract. Four-product algebra is not interchangeable under truncation/wrap.

## Half / integer rounding / scale

- `half`: first add one to the 64-bit raw word with wrap; then emulate signed right shift by one. This order matters at the signed boundary.
- `round`: first add `2^31` to raw with wrap, then return signed high word, identical to `fxr_round`.
- `mul2e`: restricted to `0<=e<=14`, the intermediate NTRU inverse-preparation range. Scaled limb and carry sums stay below `2^47` and are exactly representable.

iFFT retains half at every layer; no movement to final normalization is performed. Twiddle bits are the original GM table converted exactly into the two fields; no recalculated trigonometric constants.

## Inverse preparation

Compute `re^2+im^2`, sign and `2^e` scaling with the exact FP64 primitives. Convert the exact limb pair to raw words at the quotient boundary. Use the already audited FP64 quotient-estimate + fixed integer correction algorithm, copied directly into this candidate's `kgen_fxp.c` (not linked from another candidate).

That quotient routine assumes the existing quotient-fit/range invariant; handles zero denominator with the original deterministic bit-loop output; always feeds a positive normal divisor to VDIV. Its proof sketch/domain are preserved in source comments and in the original `hybrid_fixed_div/division_design.md`. This is the remaining integer arithmetic boundary, not a claim of an all-floating-point implementation.

## Integration and memory

The conversion to two doubles copies the existing limb scan/window exactly. No additional loss from merging into one double. Changes affect only `solve_NTRU_intermediate()`; exact integer NTRU update, scaling/reduction_bits and reject conditions are untouched.

Since `depth>=1` and `logn_top<=10`, this routine has `n<=512`. `fp_work[1024]` is a fixed-size 16-KiB private stack object holding both n-element FP vectors. Original integer arena offsets, `k`, and NTT scratch `t2` remain unchanged. It is important not to grow the original overlaid rt1/rt3 buffers in-place. No heap, shared mutable globals, recursion-dependent unbounded allocation, or changes to the public keygen tmp size.

## What verification can establish

The primitive identities give an algebraic exactness argument; Python arbitrary-precision integers and original C supply independent differential tests. Original KATs, additional seeds, raw replay and real-M55 tests test integration and compilation. Finite tests alone do not prove all NTRU range invariants, all compiler behavior, whole-program constant-time or power/EM resistance.
