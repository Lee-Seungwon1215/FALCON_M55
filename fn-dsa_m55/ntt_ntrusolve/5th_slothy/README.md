# RNS NTT Slothy experiment (K4-C baseline)

All candidates contain independent C/H/S files copied from `../ref_slothy`.
Their q=12289 `mq_cm55.s` is the already adopted Slothy A, held fixed.
Only `kgen_mp31_cm55.s` is optimized here. `../ref_preslothy` is untouched.

* `baseline`: frozen K4-C RNS with q-NTT Slothy A. The arithmetic is unchanged;
  function sections and one duplicate stride literal support matched placement.
  The byte-identical input assembly is archived in `tooling/logs/baseline_original.s`.
* `slothyA`: within-iteration scheduling and constrained register allocation.
* `slothyB`: A plus guarded halving pipelines where safe; N=1 supported.
* `tooling`: offline solver, dependency checks, provenance. Not a firmware dependency.
* `measurement`: identical board harness and candidate-local build inputs.

No result in this directory is a historical K4-C result. Measurements and
promotion status are recorded in `result.md`. The final `../ref_slothy` remains
unchanged until correctness and measured performance justify promotion.

Sources: REFERENCE/m55_slothy.pdf sections 4.1–4.8, 4.11–4.13, 7.5;
REFERENCE/m55_ntt-ftt_opt.pdf sections 6.4.2 and 6.4.5.
Pinned Slothy: 55983e6760e98aece5359055085a7def96c688b7.

The conservative adapter serializes memory accesses and groups VPT/VADDT and
VLD4/VST4 sequences. Its cost model is an approximation, not measured cycles.
Static checks and KATs are not a formal constant-time or leakage proof.
