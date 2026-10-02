# Additional primary-source search (2026-09-27)

- [Monniaux and Pain, verified FP-assisted integer division](https://arxiv.org/html/2207.08420v1),
  sections 2–3 reviewed. Approximate quotient, exact integer remainder, then a
  bounded correction is a useful pattern; reciprocal preparation can be shared.
  Their 64/64 integer-division proof does not directly cover our signed 96/64
  Q32 quotient or the original zero/overflow behavior. No claim that copying
  their C code proves our divider. Candidate experiments need separate bounds,
  safe casts, assembly inspection, and M55 operand timing measurements.
- [Perlner et al., NIST key-generation validation research](https://www.nist.gov/publications/black-box-validation-falcon-key-generation-under-numerical-instability),
  abstract reviewed, not the entire paper. It explicitly distinguishes numerical
  variation from invalid keys and proposes an alternative validation procedure.
  This does NOT relax this project's user-required exact original-KAT gate.
- [2026 fixed-point NTRU FFT hardware processor](https://doi.org/10.1016/j.micpro.2026.105282),
  indexed abstract/overview reviewed; publisher full text inaccessible (403).
  Hardware memory-bank scheduling and three-real-product complex multiplication
  are relevant hypotheses, not M55 speed guarantees. Our original `fxc_mul`
  already uses the three-product formula. No hardware result is credited here.

Search results from unaudited repositories are not used as performance evidence.

## Encoder normalization follow-up (2026-09-28 local)

- [Boldo and Muller, Exact and Approximated Error of the FMA](https://perso.ens-lyon.fr/jean-michel.muller/error_fma_TC_publie.pdf),
  sections 1.1 and 2.1-2.2 reviewed for rounding assumptions and Fast2Sum
  versus general TwoSum. No claim of reading the complete paper here.
- [Rump, Ogita and Oishi, Accurate Floating-Point Summation, Part I](https://ogilab.w.waseda.jp/ogita/math/doc/2008_RuOgOi_01.pdf),
  Algorithm 2.5, Lemma 2.6 and its proof on printed pp.197-198 reviewed.
  These support the error-free sum theorem, not the application-specific
  bounds or whole-Falcon KAT equivalence. See encoder_fastsum_design.md
  for our own bounds and finite-test limitations.

## Decoder floor/fraction follow-up (2026-09-28 local)

Rechecked Boldo/Muller section 2.1 in the primary PDF above: the sufficient
condition is ordered binary exponents, not strictly ordered magnitudes.
This matters for positive x and floor(x), which can have the same exponent
although floor(x) is smaller. B16 uses the exponent condition for
Fast2Sum(-floor(x),x), plus a separately derived nonnegative-fraction bound
for final normalization. See decoder_fastsum_design.md. The paper does not
prove our modulo-Q32 decoder, MVE semantics, constant-time behavior or KAT.

## Whole-goal feasibility follow-up (2026-09-28 local)

- [Improving FALCON's Key Generation on ARMv8-A Platforms](https://sol.sbc.org.br/index.php/sbseg/article/download/27234/27050):
  all six PDF pages read. See [the scoped review](babai_scope_review.md) for
  the paper hash, what was measured versus proposed, and the differences
  from our current F-only fixed-work solver. No M55 speed or KAT equivalence
  is inferred from that prototype.
- The [NIST full PDF](https://tsapps.nist.gov/publication/get_pdf.cfm?pub_id=961306)
  was consulted beyond the earlier abstract, notably section 4.2.2 on
  iteration limits/rejections. Selected sections were read, not all 23 pages.
  The exact original-KAT requirement is unchanged.
- [Raw-log scope analysis](../validation/scope_feasibility.md) separately
  checks 218 common count/success records and conditional zero-cost floors.
  This is our measured-work accounting, not a performance claim from either
  paper and not a new hardware run.
