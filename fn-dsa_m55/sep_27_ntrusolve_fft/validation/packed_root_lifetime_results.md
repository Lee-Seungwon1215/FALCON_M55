# A14 packed root components and register lifetimes

Status: final combined A14 passes all twelve fresh source-matched gates and
a same-ELF whole-keygen repeat. A13 is archived and its passes are not
inherited. No B18 or external reference changes, SLOTHY or backend flags.
The whole-keygen 1.7x target remains unmet; A14 is an experimental candidate,
not a deployed replacement of the external reference.

## Implementation and numerical evidence

Only production `A_tw_bridge/kgen_fft_cm55.s` changes. The two root-component
products use a 17-instruction exact multiplier instead of the generic22;
the summed-root product remains generic. The second change reorders only
independent truncated products and keeps z0 in q6/q7. Private scratch drops
256 ->160 bytes; total helper frame360 ->264 bytes. Original complex formula,
inverse half, input/output representation, public thresholds and NTRU iteration
policy remain unchanged. [Derivation](../research/packed_root_lifetime_design.md).

The [host check](host/check_packed_root.py) parses actual production GM_TAB,
matches it to the frozen fixture and checks all511 used roots in two directions
and two components. High words are exactly0/-1. Its word-level model matches
arbitrary-precision signed products in1,024,528 edge/random cases; see
[log](host/packed_root.log). This is finite evidence plus a source identity,
not a formal machine-code proof.

Component-only run [rootmul/213803Z](results/A_tw_bridge/rootmul/20260927T213803Z/manifest.json)
passes1,001,024 board products versus original fxr_mul, output guards and
immutable root arrays. All32 input classes x20 trials take1888 cycles for
32 complete calls, with resets outside each timed interval. This early run
is tied to the COMPONENT-ONLY source, not inherited by the final combined one.
The final combined source independently repeats this gate in
[rootmul/214540Z](results/A_tw_bridge/rootmul/20260927T214540Z/manifest.json):
again 1,001,024 values, intact guards/roots, zero failures, and all32 classes
x20 trials exactly1888 cycles per32 calls.

## Separating the two kernel changes

All UTC2026-09-27: A13 run212406Z; component-only run213737Z; combined
run214004Z. The unchanged fixed_fft harness compares5120 raw transforms
per run, logn1..10 and both directions with offsets/guards. All pass. Each
minimum includes whole kernel call and timer overhead; IRQ masked. Same
inputs/compiler/placement policy, not all addresses pinned.

| Kernel | n | A13 | Component only | Combined | Combined time change vs A13 |
| --- | ---: | ---: | ---: | ---: | ---: |
| FFT | 512 | 69922 | 68642 | 67106 | -4.0273% |
| FFT | 1024 | 150983 | 148423 | 145351 | -3.7302% |
| iFFT | 512 | 89152 | 87872 | 86336 | -3.1587% |
| iFFT | 1024 | 194408 | 191848 | 188776 | -2.8970% |

The same combined ELF's original fixed minima are126039/280632 forward,
143332/318465 inverse. Original/combined ratios are1.8782x/1.9307x FFT and
1.6602x/1.6870x iFFT. These are KERNEL ratios, not whole-keygen performance.
Intermediate key512 actually uses degrees up to256, and key1024 up to512;
degree1024 here is coverage, not a claim that the intermediate path calls it.
Small fallback sizes stay unchanged; affected smaller transforms also improve.

In the combined isolated run, across16 classes x20 trials per public size and
direction, current min/max differ by at most one cycle. The component-only
source is archived as A14_component_trial, an isolated-tested variant, not
claimed to have completed final whole/signature gates.

## Whole key generation and independent repeat

Identical100 upstream seeds per degree, three excluded warmups, original
retries/encoding included, KAT and NTRU-equation checks outside the timed
interval. No profiling hooks; IRQ allowed. GCC15.2.1 -O3, M55 800MHz,
code ITCM/data DTCM, caches OFF and ECC ON. Same placement policy, not pinned
addresses; these small changes are measurements, not a layout-independent
instruction-only attribution. Means are cycles per completed key.

| Implementation / UTC run | 512 | 1024 |
| --- | ---: | ---: |
| M55_ref /141357Z | 62,738,244.34 | 261,716,429.63 |
| ntt_opt /142645Z | 56,951,253.03 | 243,157,429.30 |
| A13 repeat /212904Z | 53,946,545.42 | 235,115,934.24 |
| A14 first /214227Z | 53,869,413.04 | 234,922,906.40 |
| A14 same-ELF repeat /214601Z | 53,869,412.69 | 234,922,906.90 |
| Unchanged B18 repeat /211520Z | 56,396,713.53 | 241,332,393.02 |

A14 repeat differs from its first run by -0.35/+0.50 cycles per key.
Using the repeat, time falls0.1430%/0.0821% versus A13 and
5.4114%/3.3865% versus ntt_opt. M55_ref/A14 is1.1646x/1.1141x,
INCLUDING the previously adopted NTT optimizations. It is not a1.7x result
and not a claim that FFT alone generated the full reference-relative gain.

## Connected profile: why the whole benefit is smaller

A13 profile212647Z versus A14 profile214404Z: all218 operation/size keys
and their call counts match exactly. Below are instrumented cycles per key;
they are not mixed into the non-instrumented whole-keygen means above.

| Interval | 512 A13 | 512 A14 | Change | 1024 A13 | 1024 A14 | Change |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Intermediate FFT | 1,201,180.46 | 1,163,902.63 | -3.1034% | 3,116,739.75 | 3,022,809.84 | -3.0137% |
| Intermediate iFFT | 1,367,001.08 | 1,327,124.45 | -2.9171% | 3,630,896.47 | 3,531,897.11 | -2.7266% |
| Input conversion | 506,040.33 | 506,018.48 | -0.0043% | 1,382,479.10 | 1,382,533.71 | +0.0040% |
| Reciprocal | 303,929.89 | 303,908.05 | -0.0072% | 603,406.30 | 603,351.68 | -0.0091% |
| Point multiply | 450,901.65 | 450,890.69 | -0.0024% | 1,168,417.48 | 1,168,395.67 | -0.0019% |
| Round to integer k | 201,482.83 | 201,482.85 | +0.0000% | 529,640.46 | 529,651.36 | +0.0021% |
| Integer update (unchanged scope) | 14,739,448.45 | 14,739,492.37 | +0.0003% | 63,910,602.37 | 63,910,307.87 | -0.0005% |
| Entire NTRU solve | 43,226,703.79 | 43,149,494.99 | -0.1786% | 182,856,245.76 | 182,663,251.56 | -0.1055% |

The affected transforms improve with unchanged call counts; unchanged
integer work and other stages still dominate the whole denominator.
This does not authorize changing Babai iteration or integer-update policy.

## Fresh final-source gates

All runs below are UTC2026-09-27. Each manifest records its source/ELF/raw
hashes; final integrity checks are in [evidence_check.json](evidence_check.json).

| Gate | Run | Evidence |
| --- | --- | --- |
| fixed_fft | [214123Z](results/A_tw_bridge/fixed_fft/20260927T214123Z/manifest.json) | 5120 exact raw transforms, both directions, offsets/guards |
| fixed_input | [214129Z](results/A_tw_bridge/fixed_input/20260927T214129Z/manifest.json) | 220672 original input comparisons |
| fixed_division | [214135Z](results/A_tw_bridge/fixed_division/20260927T214135Z/manifest.json) | 1018184 quotients and320 inverse arrays |
| kat | [214142Z](results/A_tw_bridge/kat/20260927T214142Z/manifest.json) | 300 original KAT/NTRU equations |
| keygen | [214227Z](results/A_tw_bridge/keygen/20260927T214227Z/manifest.json) | 200 measured keys, KAT/equations |
| extra | [214311Z](results/A_tw_bridge/extra/20260927T214311Z/manifest.json) | 300 independent-seed KAT/equations |
| sigkat | [214355Z](results/A_tw_bridge/sigkat/20260927T214355Z/manifest.json) | 90 signature/verification/tamper cases |
| profile | [214404Z](results/A_tw_bridge/profile/20260927T214404Z/manifest.json) | 200 keys, consistent interval totals |
| kernel | [214449Z](results/A_tw_bridge/kernel/20260927T214449Z/manifest.json) | 640 bounded floating/bridge comparisons,16 division classes |
| rootmul | [214540Z](results/A_tw_bridge/rootmul/20260927T214540Z/manifest.json) | 1001024 products,32 timing classes, guards/immutable roots |
| input_pair | [214543Z](results/A_tw_bridge/input_pair/20260927T214543Z/manifest.json) | 68608 cases |
| input_predicate | [214547Z](results/A_tw_bridge/input_predicate/20260927T214547Z/manifest.json) | 220672 cases |
| keygen repeat | [214601Z](results/A_tw_bridge/keygen/20260927T214601Z/manifest.json) | same ELF,200 keys/KAT/equations |

All complete with zero reported failures. These finite tests and timing
classes are not universal equivalence, formal constant-time, physical
leakage or worst-case stack proofs. Original rejection-based whole-keygen
timing remains variable. Other historical source versions' gates are not
counted as current-source validation.

## Linked memory and control

Signature ELF ITCM end0x1001e90c:125196 bytes (-112 vs A13). DTCM end remains
0x3003d668:251496 bytes including64-KiB reserved stack. No new global table
or allocated workspace. New helper frame264 bytes; unchanged C wrappers
128/120 bytes yield local chains392/384 bytes (A13:488/480). The test-visible
root-multiply entry is unused and garbage-collected in the production link.

Only public ht/direction/count branches remain in the tail. Root/input
addresses and gather offsets are public. Coefficient signs/carries/borrows
affect only vector arithmetic. The summed-root path never uses the narrower
component contract. Same-ELF timing classes and manual disassembly inspection
are finite evidence, not formal CT, physical leakage or worst-case stack proof.
