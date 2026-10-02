# A15: direct packed outputs and the public n=16 forward path

Status: two isolated variants, all twelve final A15 source-matched gates
and same-ELF whole-keygen repeat pass. A14 gates are NOT
inherited. B18 and external refs are unchanged. No SLOTHY, backend flags or
cross-candidate crypto links.

Production changes are only A_tw_bridge/kgen_fft_cm55.s (direct output
register lifetimes) and kgen_fxp.c (public forward cutoff5->4). Original
Q32 three-product truncations, inverse halves, roots and Babai work counts
remain. [Register/contract analysis](../research/packed_finish_design.md).

## Isolated attribution

All UTC2026-09-27, unchanged fixed_fft harness, whole-call cycle minima
including timer overhead, IRQ masked. A14 run214123Z; direct-finish-only
run215459Z; combined run215556Z. Each independently passes5120 raw transform
cases for logn1..10, both directions, offsets and complete-object guards.
Each public size/direction has16 input timing classes x20 trials.
Combined input-class min/max spread is at most one cycle.
The independent final-suite fixed_fft run215818Z also passes5120 cases;
its maximum spread is two cycles at iFFT1024, not rounded away or concealed.

| Kernel | n | A14 | Direct finish only | Combined | Time change vs A14 |
| --- | ---: | ---: | ---: | ---: | ---: |
| FFT | 16 | 1791 | 1791 | 1301 | -27.3590% |
| iFFT | 16 | 1550 | 1493 | 1493 | -3.6774% |
| FFT | 512 | 67106 | 65570 | 65570 | -2.2889% |
| iFFT | 512 | 86336 | 84512 | 84512 | -2.1127% |
| FFT | 1024 | 145351 | 142279 | 142279 | -2.1135% |
| iFFT | 1024 | 188776 | 185128 | 185128 | -1.9324% |

The same combined ELF's original fixed minima are126039/280633 forward,
143331/318466 inverse at n512/1024. Original/combined ratios are
1.9222x/1.9724x FFT and1.6960x/1.7202x iFFT. These are kernels, NOT whole
keygen ratios. Actual intermediate512 keys use transforms up to n256;
1024 keys use up to n512. n1024 here is coverage, not an execution claim.
The forward cutoff gain applies only to public n16. n<=8 stays unchanged.

The first variant is archived as A15_direct_finish_trial with its own ELF,
not credited as a final full-suite candidate. Same layout policy, not all
function addresses pinned; isolated small differences may include layout.

## Plain whole key generation and same-ELF repeat

Identical100 upstream seeds per degree, three excluded warmups, retries
and key encoding included, KAT/equation checks outside the timer. IRQ allowed,
no profiling hooks. Common M55 800MHz, ITCM/DTCM256KiB each, caches OFF,
ECC ON, GCC15.2.1 -O3 and unchanged FP/compiler options.

| Source/run UTC2026-09-27 | 512 mean cycles | 1024 mean cycles |
| --- | ---: | ---: |
| M55_ref /141357Z | 62,738,244.34 | 261,716,429.63 |
| ntt_opt /142645Z | 56,951,253.03 | 243,157,429.30 |
| A14 repeat /214601Z | 53,869,412.69 | 234,922,906.90 |
| A15 first /215922Z | 53,814,104.58 | 234,793,060.72 |
| A15 repeat /220207Z | 53,814,104.34 | 234,793,059.77 |

First A15 time decreases0.1027%/0.0553% versus A14,5.5085%/3.4399%
versus ntt_opt. M55_ref/A15 ratios are1.1658x/1.1147x, INCLUDING the
prior NTT gains. This is not1.7x, nor evidence that FFT alone caused the
entire reference-relative gain. The current whole-keygen KAT/equations pass.
The repeat differs from the first by -0.24/-0.95 cycles per key. Repeated
ratios and percentages round to the same values above. All reported keygen
means include failed candidates/retries; no favourable seeds were selected.

## Connected profile versus A14

Profile214404Z versus220059Z: all218 operation/size keys and every call
count match exactly. Arithmetic work policy and retry inputs are unchanged.
Instrumented cycles per key below are kept separate from plain whole timing.

| Interval | 512 A14 | 512 A15 | Change | 1024 A14 | 1024 A15 | Change |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Intermediate FFT | 1,163,902.63 | 1,131,750.46 | -2.7624% | 3,022,809.84 | 2,949,775.12 | -2.4161% |
| Intermediate iFFT | 1,327,124.45 | 1,305,380.98 | -1.6384% | 3,531,897.11 | 3,477,913.16 | -1.5285% |
| Input conversion | 506,018.48 | 506,029.44 | +0.0022% | 1,382,533.71 | 1,382,478.96 | -0.0040% |
| Reciprocal | 303,908.05 | 303,886.23 | -0.0072% | 603,351.68 | 603,439.03 | +0.0145% |
| Point multiply | 450,890.69 | 450,956.15 | +0.0145% | 1,168,395.67 | 1,168,341.13 | -0.0047% |
| Round to integer k | 201,482.85 | 201,493.76 | +0.0054% | 529,651.36 | 529,662.23 | +0.0021% |
| Integer update (unchanged) | 14,739,492.37 | 14,739,361.07 | -0.0009% | 63,910,307.87 | 63,910,657.02 | +0.0005% |
| Entire NTRU solve | 43,149,494.99 | 43,095,566.04 | -0.1250% | 182,663,251.56 | 182,536,406.80 | -0.0694% |

Public n16 forward calls stay6061/12114 per100 keys. Their per-key interval
falls113643.75->97582.10 /227148.43->195046.31 cycles (about14.13%). This
connected improvement is smaller than the isolated27.36%; it must not be
replaced with the isolated ratio in a whole-keygen prediction. Profile
hooks/caller layout are different; all addresses are not pinned. Other
integer work remains the dominant denominator, with no work-count shortcut.

## Final-source gate records

Runs are UTC2026-09-27. Zero reported failures in all completed gates.
Manifests bind source, compiled ELF and raw log hashes. The same-ELF repeat
is additional to the twelve required modes.

| Gate | Run | Evidence |
| --- | --- | --- |
| fixed_fft | [215818Z](results/A_tw_bridge/fixed_fft/20260927T215818Z/manifest.json) | 5120 exact raw transforms/guards |
| fixed_input | [215823Z](results/A_tw_bridge/fixed_input/20260927T215823Z/manifest.json) | 220672 comparisons |
| fixed_division | [215830Z](results/A_tw_bridge/fixed_division/20260927T215830Z/manifest.json) | 1018184 quotients,320 inverse arrays |
| kat | [215836Z](results/A_tw_bridge/kat/20260927T215836Z/manifest.json) | 300 original KAT/equations |
| keygen | [215922Z](results/A_tw_bridge/keygen/20260927T215922Z/manifest.json) | 200 keys/KAT/equations |
| extra | [220005Z](results/A_tw_bridge/extra/20260927T220005Z/manifest.json) | 300 independent-seed KAT/equations |
| sigkat | [220049Z](results/A_tw_bridge/sigkat/20260927T220049Z/manifest.json) | 90 signature/verify/tamper cases |
| profile | [220059Z](results/A_tw_bridge/profile/20260927T220059Z/manifest.json) | 200 keys, consistent totals |
| kernel | [220143Z](results/A_tw_bridge/kernel/20260927T220143Z/manifest.json) | 640 bounded bridge comparisons,16 division classes |
| rootmul | [220146Z](results/A_tw_bridge/rootmul/20260927T220146Z/manifest.json) | 1001024 products,32 timing classes, guards/roots intact |
| input_pair | [220149Z](results/A_tw_bridge/input_pair/20260927T220149Z/manifest.json) | 68608 cases |
| input_predicate | [220153Z](results/A_tw_bridge/input_predicate/20260927T220153Z/manifest.json) | 220672 cases |
| keygen repeat | [220207Z](results/A_tw_bridge/keygen/20260927T220207Z/manifest.json) | same ELF,200 keys/KAT/equations |

Rootmul's32 classes x20 trials again take1888 cycles per32 calls. Separate
division/bridge checks pass; finite bounded floating error checks are not
promoted into all-input original-word equality for every floating path.

## Linked memory and control inspection

Current signature ELF ITCM end0x1001e8d0:125136 bytes,60 fewer than A14.
DTCM end remains0x3003d668:251496 bytes including the reserved64-KiB main
stack, leaving10648 bytes unallocated. The test-only rootmul entry is
garbage-collected. No new tables, global cache or workspace are allocated.
The packed helper frame remains264 bytes, and the C wrappers remain128/120,
so local forward/inverse chains stay392/384 bytes. These are local bounds,
not an exhaustive whole-program stack bound.

Linked inspection confirms forward's map lifetime ends before the arithmetic
overwrites q3 and the real product dies before q7 is reused as an offset.
Inverse's q2 offset survives both component scatters. There is no secret
address/branch, call or new predicated memory operation in either body.
The C cutoff compiles to a comparison of public logn against3. The selected
n16 has exactly four short-stage butterflies; no partial block is accessed.
Original sign/carry/borrow predicates change values only, never addresses.

The actual-root/word model is rerun against the modified C file:
[a15_packed_root.log](host/a15_packed_root.log),1,024,528 cases, zero failures,
exact table-fixture match. This does not substitute for board instructions.

## Validation caveat

Finite raw/KAT/timing comparisons are not universal equivalence, formal CT,
physical leakage or whole-program worst-case stack proofs. Rejection-based
keygen is still variable-time. The1.7x whole-keygen target remains unmet
by A15; kernel improvements alone cannot establish it. The tested successor
is archived as A15_live_outputs_n16, not installed into external references.
