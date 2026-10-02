# A16: short-stage root and coefficient deinterleaving

Status: root-only and combined isolated variants, all twelve fresh A16
gates and same-ELF keygen repeat pass. A15's passes are not inherited. B18 and
external M55_ref/ntt_opt sources are unchanged. No SLOTHY or backend flags.

Only own kgen_fft_cm55.s changes. ht=1 root loads use VLD4, its inverse
coefficient preparation uses VLD4, and its forward paired output uses VST4.
ht=2 retains its original lane mapping/gathers. Four public ht/direction
loop bodies avoid an inner per-block dispatch. Arithmetic, original root
values, input/output representation, thresholds and Babai counts are unchanged.
[Memory/register contract](../research/packed_layout_design.md).

## Independent kernel variants

UTC2026-09-27, unchanged fixed_fft harness, whole-call minima with timer
overhead, IRQ masked. A15 run215818Z; root-only run220756Z; combined
run221008Z. Each independently passes5120 raw transforms across logn1..10,
both directions, four offsets and complete-object guards. Combined timing
spread is at most one cycle over16 classes x20 trials per size/direction.
Same layout policy, not all addresses pinned.

| Kernel | n | A15 | Root only | Combined | Time change vs A15 |
| --- | ---: | ---: | ---: | ---: | ---: |
| FFT | 16 | 1301 | 1293 | 1290 | -0.8455% |
| iFFT | 16 | 1493 | 1482 | 1467 | -1.7415% |
| FFT | 512 | 65570 | 65128 | 65032 | -0.8205% |
| iFFT | 512 | 84512 | 84005 | 83525 | -1.1679% |
| FFT | 1024 | 142279 | 141389 | 141197 | -0.7605% |
| iFFT | 1024 | 185127 | 184109 | 183149 | -1.0685% |

Same combined ELF original-fixed minima are126039/280632 forward and
143331/318465 inverse at n512/1024. Original/combined kernel ratios are
1.9381x/1.9875x FFT and1.7160x/1.7388x iFFT. These are NOT whole-keygen
ratios. Actual intermediate key512 uses transforms up to n256; key1024
uses up to n512. n1024 is coverage, not a claim of intermediate execution.
n<=8 and ht=2 arithmetic/access are unchanged. The root-only snapshot
A16_root_layout_trial has isolated evidence, not independent full gates.
The final-source fixed_fft gate234418Z independently passes5120 cases,
with at most one cycle of current-path timing spread per size/direction.

## Plain whole key generation and same-ELF repeat

100 identical upstream seeds per degree, three excluded warmups, failures,
retries and encoding included; checks outside the timer. IRQ allowed, no
profile hooks. M55 800MHz, code ITCM/data DTCM256KiB each, caches OFF,
ECC ON, GCC15.2.1 -O3 and unchanged FP/compiler options.

| Source/run UTC2026-09-27 | 512 mean cycles | 1024 mean cycles |
| --- | ---: | ---: |
| M55_ref /141357Z | 62,738,244.34 | 261,716,429.63 |
| ntt_opt /142645Z | 56,951,253.03 | 243,157,429.30 |
| A15 repeat /220207Z | 53,814,104.34 | 234,793,059.77 |
| A16 first /234522Z | 53,777,061.09 | 234,700,263.92 |
| A16 repeat /234807Z | 53,777,061.10 | 234,700,263.98 |

First time reductions are0.0688%/0.0395% versus A15 and
5.5735%/3.4781% versus ntt_opt. M55_ref/A16 is1.1666x/1.1151x,
INCLUDING prior NTT gains. The1.7x whole-keygen goal is still unmet;
these small reductions do not remove the measured non-target time floor.
The code-size tradeoff is reported below instead of hidden behind speed.
Repeat means differ by +0.01/+0.06 cycles per key from the first run. Both
runs use the same ELF and pass200 key KAT/equation checks. A16 is retained
as the fastest measured experimental A candidate, not installed into either
external reference. The preceding A15 remains archived for the smaller-code
alternative; this is not a claim that1540 bytes are free or universally worth
the small whole-keygen gain.

## Connected profile, with unchanged work counts

A15 profile220059Z versus A16 profile234659Z: all218 operation/size keys
and every call count match. These instrumented per-key cycles are not
substituted for the plain whole-keygen measurements above.

| Interval | 512 A15 | 512 A16 | Change | 1024 A15 | 1024 A16 | Change |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Intermediate FFT | 1,131,750.46 | 1,117,212.48 | -1.2846% | 2,949,775.12 | 2,913,661.63 | -1.2243% |
| Intermediate iFFT | 1,305,380.98 | 1,282,799.19 | -1.7299% | 3,477,913.16 | 3,421,402.35 | -1.6249% |
| Input conversion | 506,029.44 | 506,062.13 | +0.0065% | 1,382,478.96 | 1,382,446.35 | -0.0024% |
| Reciprocal | 303,886.23 | 303,875.31 | -0.0036% | 603,439.03 | 603,417.19 | -0.0036% |
| Point multiply | 450,956.15 | 450,923.40 | -0.0073% | 1,168,341.13 | 1,168,439.27 | +0.0084% |
| Round to integer k | 201,493.76 | 201,504.65 | +0.0054% | 529,662.23 | 529,629.52 | -0.0062% |
| Integer update (unchanged) | 14,739,361.07 | 14,739,503.13 | +0.0010% | 63,910,657.02 | 63,910,493.50 | -0.0003% |
| Entire NTRU solve | 43,095,566.04 | 43,058,566.35 | -0.0859% | 182,536,406.80 | 182,443,673.71 | -0.0508% |

The affected transforms improve; unchanged integer work still dominates.
Same policy is not pinned function addresses, so no claim isolates every
cycle from instruction/caller-layout effects. No reduction of Babai
iterations or integer-update work was used to claim a larger FFT gain.

## Fresh source-matched gates

Runs are UTC2026-09-27. Each manifest stores source/ELF/raw-log hashes.
All modes complete with zero reported failures, including fault/ECC checks.

| Gate | Run | Evidence |
| --- | --- | --- |
| fixed_fft | [234418Z](results/A_tw_bridge/fixed_fft/20260927T234418Z/manifest.json) | 5120 raw transforms and guards |
| fixed_input | [234423Z](results/A_tw_bridge/fixed_input/20260927T234423Z/manifest.json) | 220672 comparisons |
| fixed_division | [234429Z](results/A_tw_bridge/fixed_division/20260927T234429Z/manifest.json) | 1018184 quotients,320 inverse arrays |
| kat | [234436Z](results/A_tw_bridge/kat/20260927T234436Z/manifest.json) | 300 original KAT/equations |
| keygen | [234522Z](results/A_tw_bridge/keygen/20260927T234522Z/manifest.json) | 200 keys/KAT/equations |
| extra | [234605Z](results/A_tw_bridge/extra/20260927T234605Z/manifest.json) | 300 independent-seed KAT/equations |
| sigkat | [234649Z](results/A_tw_bridge/sigkat/20260927T234649Z/manifest.json) | 90 signature/verify/tamper cases |
| profile | [234659Z](results/A_tw_bridge/profile/20260927T234659Z/manifest.json) | 200 keys, consistent totals |
| kernel | [234743Z](results/A_tw_bridge/kernel/20260927T234743Z/manifest.json) | 640 bounded bridge comparisons,16 division classes |
| rootmul | [234746Z](results/A_tw_bridge/rootmul/20260927T234746Z/manifest.json) | 1001024 products,32 timing classes, guards/roots intact |
| input_pair | [234749Z](results/A_tw_bridge/input_pair/20260927T234749Z/manifest.json) | 68608 cases |
| input_predicate | [234753Z](results/A_tw_bridge/input_predicate/20260927T234753Z/manifest.json) | 220672 cases |
| keygen repeat | [234807Z](results/A_tw_bridge/keygen/20260927T234807Z/manifest.json) | same ELF,200 keys/KAT/equations |

The unchanged root multiplier also repeats32 timing classes x20 trials,
all1888 cycles for32 calls. Bridge error checks remain bounded-domain
evidence, not a universal raw-word-equality claim for all floating paths.
The final own-source snapshot is A16_deinterleave_ht1.

## Linked memory and public control

Signature ELF ITCM end0x1001eed4:126676 bytes,1540 more than A15. The
extra public ht-specialized loop bodies are the measured code-size tradeoff.
DTCM remains251496/262144 bytes including64-KiB reserved main stack,
leaving10648 bytes unallocated. No table, global cache or workspace is added.
Private scratch160 and total packed-helper frame264 bytes are unchanged;
local forward/inverse C+helper chains remain392/384 bytes. Link fit/local
frame counts are not a whole-program stack safety proof.

Linked inspection confirms complete VLD40..43/VST40..43 sequences and
only public direction/ht/count branches. The ht=1 coefficient block is
exactly64 bytes, wholly inside each component array at hn>=8. ht=2 does
not take the contiguous path and therefore never overreads four roots
where only two are selected. Sum/difference and inverse negation retain
lane-local carry/borrow; no data-dependent memory predicate is introduced.
The test-only rootmul entry is absent from the production signature link.

The [public layout model](host/check_packed_layout.py) reads actual offset
maps and checks load/store field/lane/address correspondence for every
block at logn4..10. It is a logical address model, not an instruction
emulator; raw board comparisons remain required. See its
[log](host/a16_packed_layout.log).

## Limitations

Register/lane/address reasoning and finite raw/KAT/timing tests are not
universal equivalence, formal CT, physical-leakage or whole-stack proofs.
Whole keygen retains its original rejection-dependent timing. The1.7x
goal is a whole-keygen requirement, not inferred from kernel improvements.
