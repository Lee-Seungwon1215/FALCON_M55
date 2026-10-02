# B15 exact predicate input selector

Status: all eleven fresh board gates pass. B14 is archived before this edit;
its passes and performance were not inherited by B15. No production
reference is replaced. No SLOTHY or cross-candidate crypto links.

## Implementation and source argument

Only `B_continuous_ds/kgen_fft_cm55.s` changes cryptographic behavior from
the B14 snapshot, specifically `DSS_SELECT_CORE`. The old 24-bit XOR,
subtract-one and arithmetic-shift mask is all ones exactly when its two
24-bit indices agree. Under the existing len<2^24 precondition, j already
fits that domain. Broadcasting j and predicating each OR on equality
preserves that identity. All four lanes share the index comparison, not
coefficient-dependent control. Every limb load remains unconditional.

The macro is expanded in standalone `fndsa_ds_select4` and the production
`fndsa_ds_from_big_span`. q5 is dead before use and overwritten by the
unchanged sign-extension tail. Original sign/shift rules, encoder, FFT,
point arithmetic, small fixed fallback, representation thresholds and Babai
iteration policy remain unchanged. This is a local application of the
[A12 mask identity](../research/predicate_input_design.md), independently
checked against B's scalar raw selector and encoded-array oracle. It is
not a new FFT-precision theorem or a verbatim algorithm from a paper.

No predicated loads/stores or scale-dependent branches are introduced.
The linked production span has the expected unconditional VLD and three
VPT/OR pairs. Loop and plane branches depend on public dimensions only.
Finite instruction/timing checks are not a formal CT or physical-leakage
proof, including for the complete keygen algorithm.

## Comparison rules

Whole means include wrappers, conversions, all surrounding operations and
retries under the shared 100-seed policy. Profile cycles include hooks and
are not substituted for plain keygen cycles. Archived B14 and current B15
share the placement policy, but not every function address is pinned.

The encoding harness's `oracle_b12_from_big` uses the CURRENT selector and
encoder. Its `old=1` tiled timings cannot be labeled unchanged-B14 timings.
The scalar raw-selector/encoded-array oracle is independent. Compare B14
using its archived log/ELF, keeping the placement limitation explicit.

## Fresh source-matched evidence

All run dates are UTC 2026-09-27.

- encoding/203114Z: 67,840 raw selection cases, 272 extra conversions,
  63,552 full-input cases, 1,000,000 encoder words, 2,070 from-big cases and
  5,242,880 FastTwoSum edge words pass, with no fault.
  Of the 63,552 fused-input cases, 63,488 scales use the independent scalar
  oracle; the remaining 64 compare fused versus tiled organization with
  shared current selector/encoder helpers. They are not 64 additional
  independent arithmetic-oracle cases.
- fixed_input/203128Z: 220,672 small/fixed input cases match.

| Gate | Run | Result |
| --- | --- | --- |
| encoding | [203114Z](results/B_continuous_ds/encoding/20260927T203114Z/manifest.json) | counts and independent/shared-oracle distinction above |
| fixed_input | [203128Z](results/B_continuous_ds/fixed_input/20260927T203128Z/manifest.json) | 220672 raw cases match |
| kat | [203135Z](results/B_continuous_ds/kat/20260927T203135Z/manifest.json) | 300 original KAT and integer NTRU equations pass |
| keygen | [203221Z](results/B_continuous_ds/keygen/20260927T203221Z/manifest.json) | 200 complete keys/KAT/equations pass |
| extra | [203307Z](results/B_continuous_ds/extra/20260927T203307Z/manifest.json) | 300 independent-seed KAT/equations pass |
| sigkat | [203352Z](results/B_continuous_ds/sigkat/20260927T203352Z/manifest.json) | 90 sign/verify/tamper cases pass |
| profile | [203402Z](results/B_continuous_ds/profile/20260927T203402Z/manifest.json) | 200 keys, consistent interval totals |
| kernel | [203448Z](results/B_continuous_ds/kernel/20260927T203448Z/manifest.json) | 640 bounded transform comparisons; zero rounded differences |
| rounding | [203451Z](results/B_continuous_ds/rounding/20260927T203451Z/manifest.json) | 151344 cases /1273664 values match |
| decoding | [203502Z](results/B_continuous_ds/decoding/20260927T203502Z/manifest.json) | 2228448 decode values, 1000484 raw products, 640 complex products, 320 inverses, 640 divisions pass |
| division | [203510Z](results/B_continuous_ds/division/20260927T203510Z/manifest.json) | 254546 cases /1018184 quotients match |

All manifests are valid, with zero faults and the expected TCM/ECC state.
These are source-matched finite gates, not universal equivalence/security.
The unchanged DS FFT still has raw Q32 differences: max 138/257 units for
512/1024 forward and 4 for inverse in the bounded test, while final rounded
values match. This is not mislabeled bit-exact FFT arithmetic. The selector
and representation boundary tested here ARE compared bit-for-bit.

The standalone raw-selector's 32 input/scale classes each have the same
30,347-cycle minimum for 128 four-coefficient calls; one sample is +1.
This is a finite timing observation, not an all-input proof.

## Linked code and memory

Against the archived B14 signature-test ELF, the production fused-input
span shrinks from 560 to 512 bytes at the same entry address 0x100149f4.
Signature-test ITCM end moves 0x1001e9f8 ->0x1001e9c8 (-48 bytes), while
the DTCM end is unchanged at 0x3003d428, including the 64-KiB stack reserve.
Only one selector macro expansion survives in that production link; the
standalone raw helper is tested in the encoding ELF, not called by keygen.
Thus two source expansions shrinking by 48 bytes is NOT a 96-byte saving
in the production firmware. Span frame remains 96 bytes, with no new
global workspace/table. This link fit is not a worst-case stack proof.

## Archived-ELF micro comparison

Same harness/input/placement policy; all code addresses are not pinned.
Both rows below include 32 complete input-conversion calls at len=8.
These are original B14 production (`old=0`) versus B15 production, NOT the
mutable tiled oracle. Units are total cycles for all 32 calls.

| n | B14 encoding/183231Z | B15 encoding/203114Z |
| ---: | ---: | ---: |
| 8 | 29,426 | 20,210 |
| 512 | 1,650,290 | 1,060,466 |

All 32 scale/input classes have those same minima; maxima are equal or +1.
Raw selector minima similarly decrease 48,779 ->30,347 for 128 calls.
No kernel ratio is substituted for a whole-keygen ratio.

## Whole keygen and profile attribution

First plain-keygen mean: 57,072,076.49 /243,021,160.02 cycles (512/1024).
Compared with B14 repeat/183346Z, time decreases 0.16234%/0.10261%.
Against original M55_ref this is 1.09928x/1.07693x, including earlier NTT
gains. Versus ntt_opt, 512 is still 0.21215% slower, while 1024 is 0.05604%
faster. This tiny latter difference is not a large FFT win. A12 remains
faster at 54,168,121.70 /235,699,616.15 cycles. The 1.7x target is unmet.

Profiles B14/183143Z and B15/203402Z have identical operation keys and call
counts. The following per-key cycles include instrumentation, unlike the
whole means above. Public logn>=4 is the continuous-DS intermediate path.

| Interval | 512 B14 ->B15 | change | 1024 B14 ->B15 | change |
| --- | ---: | ---: | ---: | ---: |
| large DS input | 557749.73 ->464904.95 | -16.6463% | 1406074.35 ->1156455.88 | -17.7529% |
| all intermediate input | 1040471.59 ->947637.67 | -8.9223% | 2967741.89 ->2718101.50 | -8.4118% |
| NTRU total | 46419081.05 ->46326225.68 | -0.2000% | 190924093.98 ->190674497.42 | -0.1307% |

Unchanged small-input, FFT/iFFT, point-product and update intervals remain
nearly stable. Point products still cost 1.912M/4.795M cycles, so shortening
the input scan does not remove B's expensive surrounding normalization.
The input savings closely account for the complete keygen savings; no
retry/iteration reduction or extra NTT optimization is credited.

Same-ELF repeat [203532Z](results/B_continuous_ds/keygen/20260927T203532Z/manifest.json)
passes another 200 KAT/equation checks, with **57,072,076.59 /243,021,160.02**
mean cycles. Differences from the first run are 0.10/0.00 cycles per key.
This confirms the observed small gain under these inputs, not a new CT
proof. All eleven current-source gates and unchanged external baseline
hashes are rechecked by `verify_evidence.py`.
