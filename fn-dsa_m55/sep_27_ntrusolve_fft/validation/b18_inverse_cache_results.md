# B18 immutable inverse cache

Status: isolated tests, all eleven fresh source-matched gates and a same-ELF
whole repeat pass. B17 gates were not inherited. A12 remains the best whole
candidate; the 1.7x goal is NOT achieved. External refs are unchanged.

## Implementation

Own `kgen_ntru.c`, `kgen_ds.h`, `kgen_fft_mve.c`, `kgen_fft_cm55.s` implement
one-time decoding of the represented inverse into the existing rt3 buffer,
then use the same exact product/encoder macro with a cached second operand.
[Design and buffer audit](../research/inverse_cache_design.md). No FFT
precision/rounding or Babai iteration/update rule changes. No SLOTHY, new
workspace allocation, build-selectable backend, or other candidate links.

## Isolated checks

UTC 2026-09-27 [decoding/210938Z](results/B_continuous_ds/decoding/20260927T210938Z/manifest.json):
560 cached product cases (512 random/edge/alias plus 48 operand classes)
match the frozen scalar oracle over full DS objects. The cache's source
words match scalar decoding; guards, unused tails, and immutable cache data
remain intact. Also pass: 2,228,448 raw decodes, 1,000,484 raw products,
640 uncached products, 320 inverses and 640 divisions. Faults zero; required
TCM/ECC state confirmed. Original KAT run 211111Z passes all 300 cases.

## Same-ELF complete-call microtiming

32 timed calls, input reset outside each interval, same old/new DS inputs.
Numbers below are minimum aggregate cycles for class 0, not whole-keygen
speedups. Preparation plus one multiply includes preparation EACH time.

| Operation | n=8 | n=512 |
| --- | ---: | ---: |
| Uncached multiply | 49,472 | 2,978,720 |
| Cache preparation only | 18,272 | 1,048,448 |
| Reused-cache multiply only | 32,704 | 1,976,128 |
| Preparation + one cached multiply | 50,752 | 3,024,352 |

One use is slower after preparation; repeated use is the intended case.
Across 24 operand classes x20 trials at each size, hot n=8 timing is exactly
32704; other cache interval minima/maxima have at most 2 aggregate-cycle
spread (32 calls). These finite classes do not prove constant-time security.
Linked wrappers tail-call helpers; each helper has only a public count loop,
sequential cache/DS addresses, unchanged arithmetic lane predicates and no
external calls. Reviewed disassembly is in audit/B_continuous_ds.txt.

## Memory

Signature ELF: ITCM end 0x1001e548, DTCM end 0x3003d428 including 64 KiB
stack reservation. Cache uses the already reserved n-fxr rt3 region.
Prepare/cached helpers have 144/336-byte frames including saved registers;
the original point helper had 336 bytes. No new global table or allocation.
These are link/local-frame checks, not a whole-program worst-case stack proof.
Compared with B17, ITCM is 652 bytes smaller and DTCM unchanged. The old
general multiplication entry remains available in source/tests but is unused
and garbage-collected in the production keygen/signature links. New cached
entries directly replace the production call; no backend selector is used.

## Whole key-generation comparison

Same board/compiler/inputs/placement policy as B17, 100 seeds per degree,
three excluded warmups, all retries and cache preparation included. IRQ is
allowed for these complete-key timers. Not all function addresses are pinned.

| Implementation / run | 512 mean cycles | 1024 mean cycles |
| --- | ---: | ---: |
| M55_ref / 141357Z | 62,738,244.34 | 261,716,429.63 |
| ntt_opt / 142645Z | 56,951,253.03 | 243,157,429.30 |
| A12 / 202433Z | 54,168,121.70 | 235,699,616.15 |
| B17 / 205914Z | 56,886,405.00 | 242,566,913.16 |
| B18 first / 211158Z | 56,396,713.72 | 241,332,393.04 |
| B18 repeat / 211520Z | 56,396,713.53 | 241,332,393.02 |

B18 reduces whole time by **0.86082% /0.50894%** versus B17. Against ntt_opt,
time falls **0.97371% /0.75056%**. M55_ref/B18 is **1.11245x /1.08446x**,
which includes prior NTT gains, not just new FFT work. The repeat differs
from the first by 0.19 /0.02 cycles per key. A12 still leads both sizes.

## Preparation-inclusive NTRU profile

Compare B17 profile/205716Z to B18 profile/211338Z, instrumentation included.
Do NOT substitute these totals for the plain whole-keygen values above.
`I_mul` includes the new preparation calls and the repeated cached calls.
At every logn>=4, its extra call count equals exactly the inverse call count.
All other operation keys/call counts are identical; Babai iteration and
integer-update counts remain unchanged. The additional timing-hook cost is
included, not subtracted to inflate the improvement.

| Interval | 512 B17 -> B18 cycles/key | time change | 1024 B17 -> B18 cycles/key | time change |
| --- | ---: | ---: | ---: | ---: |
| Large DS point, including preparation | 1,546,149.02 -> 1,065,223.97 | -31.1047% | 3,830,453.51 -> 2,618,118.78 | -31.6499% |
| All intermediate point (also small fixed) | 1,741,642.37 -> 1,261,506.08 | -27.5680% | 4,372,188.33 -> 3,162,089.95 | -27.6772% |
| NTRU solve total | 46,140,457.02 -> 45,654,340.68 | -1.0536% | 190,220,381.00 -> 188,994,516.88 | -0.6444% |

Other intermediate input/FFT/iFFT/reciprocal/round/update times change by
less than 0.26%, with the same code arithmetic and counts. These small
differences may include layout/instruction-context effects. This evidence
supports a local boundary-work saving, not a 31% whole-keygen improvement.

## Source-matched gates

All dates UTC 2026-09-27. Each linked manifest is valid, with zero faults,
expected TCM/ECC state and current crypto hashes. Independent seeds are
separate from original upstream KAT; repeats are not additional unique seeds.

| Gate | Run | Result |
| --- | --- | --- |
| encoding | [211050Z](results/B_continuous_ds/encoding/20260927T211050Z/manifest.json) | original selector/encoder and full-input grids pass |
| fixed_input | [211104Z](results/B_continuous_ds/fixed_input/20260927T211104Z/manifest.json) | 220672 original raw cases pass |
| kat | [211111Z](results/B_continuous_ds/kat/20260927T211111Z/manifest.json) | 300 original KAT and equations pass |
| keygen | [211158Z](results/B_continuous_ds/keygen/20260927T211158Z/manifest.json) | 200 keys/KAT/equations pass |
| extra | [211243Z](results/B_continuous_ds/extra/20260927T211243Z/manifest.json) | 300 independent KAT/equations pass |
| sigkat | [211327Z](results/B_continuous_ds/sigkat/20260927T211327Z/manifest.json) | 90 sign/verify/tamper cases pass |
| profile | [211338Z](results/B_continuous_ds/profile/20260927T211338Z/manifest.json) | 200 keys, interval totals consistent |
| kernel | [211423Z](results/B_continuous_ds/kernel/20260927T211423Z/manifest.json) | 640 bounded transforms, zero rounded differences |
| rounding | [211426Z](results/B_continuous_ds/rounding/20260927T211426Z/manifest.json) | 1273664 values pass |
| decoding/cache | [211437Z](results/B_continuous_ds/decoding/20260927T211437Z/manifest.json) | original grids plus 560 cached products/guards pass |
| division | [211450Z](results/B_continuous_ds/division/20260927T211450Z/manifest.json) | 1018184 quotients pass |
| whole repeat | [211520Z](results/B_continuous_ds/keygen/20260927T211520Z/manifest.json) | same ELF, 200 keys/KAT/equations pass |

DS FFT raw intermediate words can still differ from original fixed FFT;
bounded rounded-output tests, complete KAT/equations and signatures are
separate checks. No universal equivalence, formal CT, power/EM security or
worst-case stack proof is claimed. See validation_limits.md and ct_results.md.
