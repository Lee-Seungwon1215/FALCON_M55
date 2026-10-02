# B18: immutable represented-inverse cache

Implementation is local to `B_continuous_ds`. Source reasoning below is
separate from the board evidence in `validation/b18_inverse_cache_results.md`.
This is loop-invariant conversion hoisting, not a new FFT algorithm, changed
Babai policy, native-FP-only multiplication, or SLOTHY scheduling.

## Exact arithmetic contract

`ds_inverse` is built once before the intermediate reduction loop and is
not subsequently changed. B17 decodes its real/imaginary components on every
point-product call. B18 decodes those SAME represented floats once, AFTER
`fndsa_ds_inverse` has encoded its result. Caching the pre-encoding quotient
would be a different algorithm and is deliberately not used.

For each four-complex tile, 16 uint32 words hold four real-high, real-low,
imaginary-high, imaginary-low lanes. This is exactly `2*n` words, or `n`
original fxr slots. Decode is the unchanged B17 `DSD_DECODE_CORE`. The
changing working polynomial remains two-FP32 through FFT -> product -> iFFT.
Both old and cached assembly entry points expand the SAME source macro
`DSP_PRODUCT_ENCODE`, with the original three truncated Q32 products and
wrapping sums. The cache merely supplies the second operand's raw words.
No intermediate two-float rounding is inserted or removed in the arithmetic.

Public API requires `3 <= logn <= 10`; production uses `logn >= 4`. There
are no hidden candidate selectors, build flags, external crypto links, or
secret-dependent fallback. Small fixed-point paths remain unchanged.

## Buffer lifetime / alias audit

The intermediate layout before the Babai loop is, in 32-bit words:

| Region | Length | Writes during reduction |
| --- | ---: | --- |
| Ft | llen*n | Integer update and original redundant-limb checks |
| ft | slen*n, plus n when use_sub_ntt | NTT preparation before reduction |
| rt3 / immutable cache | 2*n | Preparation only, then read-only |
| rt1 / k | n of the original 2*n fxr region | to_k and depth1 update |
| t2 | original remaining scratch | NTT/CRT update temporary work |

`use_sub_ntt` reserves the extra ft limb BEFORE rt3 is defined. Its initial
NTT conversion uses gm=t2 and tn=t2+n, then memmoves exactly `(slen+1)*n`
words into ft, ending at (not past) rt3. It never uses preceding scratch.
`poly_sub_scaled_ntt` allocates gm/igm/fk/t1 forward from its tmp=t2 and
updates only Ft. `poly_sub_kf_scaled_depth1` uses three n-word planes forward
from t2, consumes k, and writes Ft. `poly_sub_scaled` has no external scratch
and writes only Ft. None receives a pointer to the cache. The original
rt1=k boundary begins AFTER all 2*n cache words. No array allocation, caller
scratch requirement, global workspace, or original reduction count grows.

Cache loads/stores require word alignment, supplied by original rt3.
Four-lane full tiles have no tail at supported public sizes. DS arrays are
separate aligned stack objects. A caller may prepare a snapshot of d itself
and then multiply d by that snapshot; cache memory must remain disjoint.
Tests check that scenario, source-word equality, guards, unused slots, and
cache immutability. This audit does not establish universal stack safety.

## Measurement and validation rules

- The complete key-generation timer includes preparation and all retries.
- The existing `I_mul` profile leaf now includes BOTH the once-per-level
  prepare call and repeated cached multiply calls. Counts therefore increase
  by one prepare call per DS inverse. Do not mistake that for more Babai
  iterations. Other operation counts must stay fixed.
- The decoder test retains the unchanged uncached point function and frozen
  scalar oracle. Cached preparation is checked against scalar `qd_raw_floor`;
  products are checked bitwise over the entire DS object, including untouched
  tails. Random/edge alias cases and finite operand timing classes are tested.
- Microtiming separates prepare-only, hot cached multiply, and preparation
  plus ONE multiply. A hot-call speedup is not the complete pipeline speedup.
- Fresh source-matched KAT, independent-seed KAT, NTRU equations, signature
  verification/tamper rejection, kernels, conversions, division, ELF/memory
  and linked control-flow checks are required before adopting B18.
- Cache loops depend only on public size. Data-dependent FP/integer lane
  predicates are unchanged B17 arithmetic, not branches or indexed loads.
  Timing classes are finite evidence, not a formal constant-time proof.

## Scope and provenance

This candidate was derived from the current source's immutable operand and
buffer lifetime, following `inverse_cache_hypothesis.md`; it does not claim
a paper supplied this exact implementation. Previously read literature and
the B16/B17 numerical proofs still apply to the unchanged codec. No candidate
norm, signing, NTT/CRT/Bezout, scale schedule, or integer-update policy changes.
