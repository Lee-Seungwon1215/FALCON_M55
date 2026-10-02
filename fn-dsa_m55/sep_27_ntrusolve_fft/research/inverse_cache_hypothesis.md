# Historical B18 hypothesis: reuse the immutable inverse's decoded words

Originally written at B17 before implementation. Subsequently implemented
and measured as B18: see [design](inverse_cache_design.md) and
[results](../validation/b18_inverse_cache_results.md). The following records
the original reasoning and pre-implementation gates, not an untested claim
of current performance.

## Evidence in current B kgen_ntru.c

The intermediate solver constructs `ds_inverse` once (from-big -> FFT ->
inverse), before the reduction loop. Within the loop `fndsa_ds_mul` takes
`&ds_inverse` as its const second operand, without any intervening write.
The current point span decodes both real/imaginary planes of that same
operand on every iteration. Only `ds_work` changes between iterations.

A possible independently implemented successor would decode the final
REPRESENTED ds_inverse once, then use those cached raw words for the second
operand while keeping the changing ds_work polynomial in two-FP32 storage
through FFT ->point multiply ->iFFT. Arithmetic still uses the original
three-product truncation/wrap rule; no iteration count or integer update
policy needs to change. This is an explicit hybrid immutable cache, not a
claim that all point arithmetic is native FP.

Crucial: caching raw quotient words BEFORE encoding is NOT equivalent.
The encoder can round the quotient into two floats. The cache must contain
the current qd_raw_floor of those represented float components, exactly as
the existing repeated decoder sees them. No numerical rule can be relaxed.

## Memory candidate to audit before use

For the continuous-DS public logn>=4 path, `rt3` reserves n fxr values in
the existing caller tmp but is not populated/used by the float pipeline.
It precedes rt1/k and t2. `ft` has its extra NTT limb reserved BEFORE rt3
is defined. The integer subtraction routines receive k and t2, not rt3.
This makes rt3 a possible cache location with no new global workspace or
stack array, but full alias/lifetime analysis of ALL integer update paths
and their size contracts must precede implementation. Do not simply assert
that unused-looking storage is safe. Small fixed transforms still use rt3
as their original reciprocal and must remain unchanged.

## Gates for a future candidate

- Verify the cache's exact layout/length/alignment and lifetime for each
  public logn/depth, including NTT/subtraction workspaces and early exits.
- Original point function versus cached point on common inputs: raw output
  arrays, untouched slots, sign/zero/rounding edges and pre-cached alias case.
- Include one-time decode preparation in connected/profile/whole timing;
  do not report only the cheap cached calls as the complete speedup.
- Fresh full KAT/independent seeds/equations/signatures/memory/CT checks.
- Preserve original public iteration counts, failures and threshold rules;
  a cache does not authorize a Babai algorithm change.

This addresses larger repeated boundary work than another instruction-only
rewrite, but the measured non-target time floor still prevents predicting
the 1.7x whole target from this local optimization alone. A separate user
question about broadening to Babai iteration policy is pending; that policy
has not been changed or treated as implicitly authorized here.
