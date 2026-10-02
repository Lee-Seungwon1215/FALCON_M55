# NTRU solve FFT optimization — 2026-09-27

Current cleanup: [A17 source cleanup and fresh checks](validation/cleanup/README.md).
Unused experiments and a diagnostic symbol were removed without changing the
retained arithmetic or constant tables. Pre-cleanup records below remain historical;
new gates must match the cleaned source hashes.

Status: A/B implementation and controlled board evaluation. Target 1.7x is
NOT achieved. The external M55_ref and ntt_opt trees are untouched. Current
experimental sources are A17-cleanup (A16 plus user-requested FP64 candidate
invnorm, with unused experiments removed) and B18. Current-source checks are
tracked in [cleanup results](validation/cleanup/README.md); archived passes
are not inherited. See [invnorm results](validation/invnorm_results.md) for
the pre-cleanup A17 extension, tests and same-ELF repeat.
A11 and B14 are archived before the respective input-scan edits;
see [result.md](result.md) and the source/
ELF hashes in validation/results. No production-reference replacement is made.
Current-source gates are tracked by hash in validation/current_validation.json;
historical results are not inherited after a source change.

[A17 five-check assessment](validation/security/README.md): the requested speed,
numerical-error, KAT, sign/verify and constant-time checks are complete with the
reported numerical differences and finite-test limitations. Deployment entropy,
key lifecycle and physical side-channel assurance are outside this request;
these tests are not certification or a deployment approval.

The [post-A16 scope audit](validation/scope_feasibility.md) rechecks the
frozen logs, including 218 identical call/success records. With other work
fixed, zero-cost target FFT time would give only 1.2621x/1.1668x versus
M55_ref (instrumented hypothetical, not a measured speedup).
[Additional primary-literature review](research/babai_scope_review.md)
does not justify silently changing Babai iterations or relaxing KAT.
This analysis made no production change or new board measurement.

[Requirement-by-requirement audit](validation/requirements_audit.md) remains
INCOMPLETE at the 1.7x condition. A [same-seed audit](validation/paired_keygen_audit.md)
also finds no tested seed reaching 1.7x; four implementations' 200 encoded
key hashes, hardware headers and harness inputs match. This is analysis of
existing runs, not another hardware test or an all-input equivalence proof.

## Objective

For each of degree 512 and 1024, target whole key-generation speedup >= 1.7
against `../M55_ref`, on identical inputs, compiler and board conditions.
Report the incremental benefit against `../ntt_opt` separately. The target
is not a claim that it is attainable within the allowed scope.

Scope: NTRU intermediate/depth0 FFT approximation, including conversions,
reciprocal/pointwise arithmetic, Q32 compatibility, and rounding to integer k.
The original scope excluded candidate orthogonal-norm checking. The user
explicitly extended it on 2026-09-28 to apply the earlier FP64 invnorm only.
The candidate FFT/iFFT, signing, CRT, Bezout and NTT remain unchanged.
No SLOTHY. No secret-dependent shortcuts or input-specific KAT exceptions.

## Independent directions

- `A_tw_bridge/`: started with TW's double surrounding arithmetic and a local
  4.3-derived FFT/iFFT bridge. A12 retains the original fixed intermediate
  arithmetic rules and directly vectorizes its Q32 input conversion and exact
  reciprocal division with integer MVE, without converting those arrays.
  It uses the double/DS bridge plus FP64 division ONLY at depth0, with
  fixed-count division predicates. A0–A6
  experiments are preserved in validation/source_snapshots and archived ELFs.
  A9 added exact bounded-twiddle integer-MVE FFT/iFFT in NTRU only. A10 fuses
  those span operations into one butterfly loop, reducing the private tile
  to 64 bytes. Forward logn>=5 and inverse logn>=4 use it; smaller sizes and
  the candidate-check transforms remain original. A11 adds a public n=2
  two-coefficient/two-limb input scan directly in the same assembly helper.
  A12 shortens the n>=4 input scan with exact vector equality predicates.
  All nine main gates plus both extra input tests pass on current sources.
  Repeated whole-keygen means are 54,168,121.70 /235,699,616.15 cycles
  (512/1024), 1.1582x/1.1104x versus M55_ref, including previous NTT gains.
  Additional time reductions versus ntt_opt are 4.8869%/3.0671%.
  A13 now packs the short ht=1/2 stages across four distinct butterflies
  with exact integer MVE, replacing the remaining scalar stage loops in
  these large transforms. Small-transform thresholds and depth0 stay fixed.
  All nine main and both extra input gates pass. First whole-keygen means
  are 53.947M/235.116M cycles, 0.4091%/0.2476% less than A12. M55_ref ratios
  are 1.1630x/1.1131x, not the 1.7x goal. See packed_tail_results.md under
  validation for repeats, raw comparisons and memory cost.
  A14 additionally shortens two root-component products under the verified
  high-word bound and reduces packed-stage scratch from 256 to 160 bytes.
  Independent truncated products are reordered without changing their
  mathematical combination. Repeated whole means are 53.869M/234.923M cycles,
  0.1430%/0.0821% below A13 (1.1646x/1.1141x versus M55_ref). Code drops
  112 bytes and the helper frame 96 bytes. See
  validation/packed_root_lifetime_results.md for each variant and final gates.
  The first/repeat means differ by only -0.35/+0.50 cycles per key.
  A15 keeps packed outputs in registers instead of spilling/reloading them,
  and independently checks the forward n16 public cutoff. Both directions
  now vectorize n>=16, with smaller transforms unchanged. All twelve fresh
  gates and a same-ELF repeat pass. Repeated whole means are
  53,814,104.34/234,793,059.77 cycles: .1027%/.0553% below A14,
  1.1658x/1.1147x versus M55_ref. Additional time reduction versus ntt_opt
  is5.5085%/3.4399%. Code drops60 bytes; RAM and frame peaks do not increase.
  See validation/packed_finish_results.md for isolated and connected effects.
  A16 tests public ht=1 root VLD4 separately, then combines coefficient
  inverse VLD4/forward VST4. Arithmetic and ht=2 mappings remain original.
  All twelve fresh gates and the same-ELF repeat pass. Repeated means are
  53,777,061.10/234,700,263.98 cycles: .0688%/.0395% below A15,
  1.1666x/1.1151x versus M55_ref,5.5735%/3.4781% less time than ntt_opt.
  ITCM code increases1540 bytes; DTCM/frame peaks stay unchanged. A15 is
  retained as the smaller-code alternative. See validation/packed_layout_results.md.
- `B_continuous_ds/`: retain two-FP32 representation between FFT and iFFT;
  improve surrounding arithmetic and Q32 compatibility without hiding costs.
  B11 integrates exact Q32 point products and their representation boundaries
  in one four-coefficient assembly loop; no precision or KAT rule is relaxed.
  B12 also vectorizes the exact fixed-input converter for small transforms
  in its own assembly file; the large-transform DS path remains unchanged.
  B13 fuses the large DS input selector/encoder in one local assembly loop,
  retaining arithmetic order while eliminating the intermediate word tile.
  B14 shortens five encoder-only error-free sums under derived operand
  bounds, without changing decoder/rounder sums or FFT precision policy.
  B15 replaces the large-input selector masks with exact vector equality
  predicates in its own assembly macro; all limb loads remain unconditional.
  All eleven fresh source-matched gates pass; B14 results were not inherited.
  A12 remains the faster whole-keygen candidate. B15's large-input interval
  decreases 16.65%/17.75%, but whole time only 0.162%/0.103% versus B14.
  B16 now specializes three decoder error-free sums using the floor/fraction
  operand relations. All eleven fresh board gates pass; B15 evidence was not
  inherited. Point calls decrease about 4.47%, but first whole-keygen time
  only 0.1196%/0.0687%. A12 remains the faster whole-keygen candidate.
  B17 shortens exact exponent extraction, constant setup and lane-local
  carry updates in the same decoder. All eleven fresh gates and a same-ELF
  whole repeat pass; B16 passes were not inherited. Whole mean cycles are
  56,886,405.00 /242,566,913.16 (512/1024), 0.2060%/0.1183% less than B16.
  A12 remains the faster whole-keygen candidate; the 1.7x goal is unmet.
  B18 caches the represented inverse's decoded words once in existing rt3.
  All eleven fresh gates pass. Preparation-inclusive large point intervals
  fall 31.10%/31.65%, while first whole time falls 0.8608%/0.5089% versus B17,
  to 56.397M/241.332M cycles. No new workspace or Babai policy change.
  See validation/b18_inverse_cache_results.md for repeated-run evidence.
- `baseline_m55/`, `baseline_ntt/`: immutable source snapshots, not linked by
  the candidates. Used only for controlled measurements and host oracles.
- `validation/`: common test infrastructure, generated instrumentation,
  provenance, board logs and analysis. No production dispatch by build flags.
- `research/`: page-indexed paper extraction, reading notes and hypotheses.

Every candidate has its own complete C/header/assembly sources. Ordinary
compilation of those sources is required, but other candidate implementations
are not linked or selected with compile-time backend switches.

## Gates

1. Freeze sources and validate the unmodified baseline in the new path.
2. Profile both whole key generation and the allowed NTRU approximation scope.
3. Estimate the time floor outside the scope before forecasting speedup.
4. Validate both independent starting implementations, then measure changes
   one dimension at a time. Preserve source/ELF/log hashes for comparisons.
5. Check numerical error, original and independent-seed KAT, exact integer
   NTRU equation, signatures, tamper rejection, memory bounds and constant-time
   evidence. Finite tests are not a universal equivalence or leakage proof.
6. Measure kernel calls, connected approximation, NTRU and whole key generation.
   Include conversions, wrappers, failed candidates and retries where applicable.
7. Read all REFERENCE papers when investigating blocked progress, recording page
   coverage and applicability. New methods remain hypotheses until validated.

A17's user-requested invnorm extension is measured separately from A16's
NTRU-only work. Its gain must not be attributed to NTRU solve FFT alone.
