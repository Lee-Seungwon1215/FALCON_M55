# A10 fused butterfly experiment

Status: directly implemented in A_tw_bridge; all nine source-matched gates
pass, including a same-ELF whole-keygen repeat. A9 gate passes were not
inherited. External references and B14 are unchanged. No SLOTHY or
cross-candidate crypto linking. The 1.7x whole-keygen goal is NOT achieved.

## Same-ELF trial versus A9 and original

[Run 194014Z](results/A_tw_bridge/fft_fusion/20260927T194014Z/manifest.json)
tests all 511 original roots and conjugates with 16 input classes at four
coefficients, plus n4..256 multi-block spans and guards: 16576 butterfly
cases, all raw words equal to the original three-product/half rules.

It also compares the original, A9 and fused full transform on 3840 common
size/direction/cutoff/input cases (three implementations per case), including
all-zero, all-minus-one, narrow signed, mixed extremes and pseudorandom
full-width inputs. Every active/inactive output word matches. Cutoffs 4/8/16
are compared; cutoff4 wins for the useful sizes in both directions.
The first 16 classes each have 20 timed repetitions, with input reset outside
and IRQ masked. All calls, dispatch, scratch and load/store work are timed.

| n | original FFT | A9 FFT | fused FFT | original iFFT | A9 iFFT | fused iFFT |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 16 | 1781 | 1791 | 1787 | 2050 | 2056 | 1913 |
| 32 | 4391 | 4401 | 3970 | 5052 | 5058 | 4376 |
| 64 | 10477 | 10487 | 8670 | 12026 | 12032 | 9792 |
| 128 | 24415 | 22743 | 18754 | 27944 | 26628 | 21621 |
| 256 | 55857 | 49124 | 40320 | 63750 | 58320 | 47298 |
| 512 | 125907 | 105401 | 86273 | 143332 | 126534 | 102716 |
| 1024 | 280373 | 225274 | 183847 | 318466 | 272979 | 221698 |

Minimum cycles; fused maxima over the tested timed classes are equal or +1.
At n128..1024, fused time is 17.54–18.39% lower forward and 18.80–18.90%
lower inverse than A9 in this ELF. This is NOT the whole-keygen improvement.
The tiny forward n16 gain is insufficient to select that path; n4/8 lose.
Production keeps forward logn<5 and inverse logn<4 on the original kernels.

Earlier separate ELFs have different addresses/timing context; their numbers
are not silently combined into this paired comparison. The older field name
`a9_min` in this archived log refers to the A9 source hashes in its manifest.
Future test logs use `incumbent_min` to avoid mislabelling a later incumbent.

## Direct implementation and source-matched validation

From the archived A9 source, executable changes are only kgen_fxp.c and
kgen_fft_cm55.s; the kgen_inner.h change is a threshold comment. A9's separate
helpers are replaced, not kept as build-selectable alternatives. GM_TAB,
original fixed entry points and candidate-norm source remain byte-equivalent
to their prior versions, checked by check_scope.py. Intermediate source is
unchanged from A9 (the original algorithm with three NTRU-local FFT calls).

See [design and register lifetimes](../research/fused_butterfly_design.md).
The following are A10 production-source runs, not the older A9 trial above.
All run IDs are UTC on 2026-09-27. Every manifest reports valid measurement,
zero hardware faults and the required TCM/ECC state.

| Gate | Run | Result |
| --- | --- | --- |
| fixed_fft | [194449Z](results/A_tw_bridge/fixed_fft/20260927T194449Z/manifest.json) | 5120 raw-array/guard comparisons pass |
| fixed_input | [194454Z](results/A_tw_bridge/fixed_input/20260927T194454Z/manifest.json) | 220672 input cases pass |
| fixed_division | [194501Z](results/A_tw_bridge/fixed_division/20260927T194501Z/manifest.json) | 1018184 raw quotients and 320 reciprocal arrays pass |
| kat | [194508Z](results/A_tw_bridge/kat/20260927T194508Z/manifest.json) | 300 original KAT and integer NTRU equations pass |
| extra | [194637Z](results/A_tw_bridge/extra/20260927T194637Z/manifest.json) | 300 independent-seed KAT/equation checks pass |
| sigkat | [194721Z](results/A_tw_bridge/sigkat/20260927T194721Z/manifest.json) | 90 sign/verify/tamper cases pass |
| profile | [194731Z](results/A_tw_bridge/profile/20260927T194731Z/manifest.json) | 200 keys, all profile totals consistent |
| kernel | [194816Z](results/A_tw_bridge/kernel/20260927T194816Z/manifest.json) | retained FP bridge: 640 comparisons, 16 division timing classes pass |
| keygen | [194553Z](results/A_tw_bridge/keygen/20260927T194553Z/manifest.json), [195159Z repeat](results/A_tw_bridge/keygen/20260927T195159Z/manifest.json) | each run: 200 KAT/equation checks pass |

### Direct kernel versus original fixed implementation

These minima come from production fixed_fft/194449Z. The original and new
functions execute on common inputs in one ELF; calls, dispatch and private
workspace are included. This is not an all-function-address-pinned comparison.

| n | original FFT | A10 FFT | ratio | original iFFT | A10 iFFT | ratio |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 16 | 1788 | 1791 | 0.9983x | 2050 | 1914 | 1.0711x |
| 32 | 4402 | 3870 | 1.1375x | 5052 | 4365 | 1.1574x |
| 64 | 10497 | 8441 | 1.2436x | 12026 | 9756 | 1.2327x |
| 128 | 24450 | 18264 | 1.3387x | 27944 | 21536 | 1.2975x |
| 256 | 55924 | 39305 | 1.4228x | 63750 | 47120 | 1.3529x |
| 512 | 126039 | 84205 | 1.4968x | 143332 | 102365 | 1.4002x |
| 1024 | 280632 | 179670 | 1.5619x | 318466 | 221030 | 1.4408x |

Small fixed fallbacks carry 0--6 cycles of dispatch overhead. Top-level
key512 intermediate transforms reach only n256; key1024 reaches n512.
The n1024 isolated ratio is therefore NOT the improvement of the adopted
intermediate path in key1024. Depth0 and candidate-norm transforms have not
been silently switched to this helper.

### Whole key generation

100 common seeds per degree, three excluded warmups, retries and all actual
boundaries included. These are non-profile builds. Numbers are mean cycles.

| Implementation / run | 512 | 1024 |
| --- | ---: | ---: |
| M55_ref / 141357Z | 62,738,244.34 | 261,716,429.63 |
| ntt_opt / 142645Z | 56,951,253.03 | 243,157,429.30 |
| A9 / 190419Z | 54,620,522.69 | 237,010,994.05 |
| A10 / 194553Z | 54,320,119.24 | 236,219,621.12 |
| A10 same-ELF repeat / 195159Z | 54,320,118.67 | 236,219,621.83 |
| M55_ref / A10 repeat | **1.1550x** | **1.1079x** |
| A10 time change versus ntt_opt | **-4.6200%** | **-2.8532%** |
| A10 time change versus A9 | **-0.5500%** | **-0.3339%** |

The first/repeated means differ by less than one cycle. Whole gains versus
M55_ref include the previously adopted NTT code; they are not all new FFT
gains. Whole runs are separate ELFs with a common placement policy, not all
function addresses pinned across versions.

### Instrumented integration attribution

A9 profile/190117Z and A10 profile/194731Z have identical operation keys and
call counts, including retries and integer updates. Per-key profile costs:

| Interval | 512 A9 -> A10 | time change | 1024 A9 -> A10 | time change |
| --- | ---: | ---: | ---: | ---: |
| intermediate FFT | 1,504,105.54 -> 1,318,838.20 | -12.3174% | 3,942,850.36 -> 3,422,738.27 | -13.1913% |
| intermediate iFFT | 1,632,493.64 -> 1,449,454.39 | -11.2122% | 4,368,754.38 -> 3,847,198.96 | -11.9383% |
| all NTRU | 43,956,095.05 -> 43,587,875.87 | -0.8377% | 184,966,985.47 -> 183,925,220.19 | -0.5632% |

Input, reciprocal, point product, rounding and integer-update intervals are
essentially unchanged. These hook-included costs are attribution evidence,
not replacements for plain whole-keygen cycles. Earlier A9 context/timing
diagnostics do not establish a cause for every kernel/profile difference.

### Memory and constant-time limits

The signature-test ELF uses 124032 ITCM bytes (+7764 versus A9) and 251432
DTCM bytes (+512), including the unchanged 64-KiB reserved stack. DTCM has
10712 bytes of link-time headroom. The additional 512 bytes are a public
dispatch table, not mutable polynomial workspace.

The fused helper's frame is 176 bytes with 64 bytes of arithmetic scratch.
Linked C forward/inverse frames are 208/240 bytes: local chains 384/416 bytes,
versus A9's 3416/3440. This is NOT a whole-program worst-case stack proof.
All 18 assembly loop branches depend on public coefficient count; the
indirect dispatch depends on public root and direction. There are no BL/BLX
calls inside the helper. Secret carries/borrows use vector predicates only.
Production fixed_fft timing maxima are equal to minima or +1 over the tested
classes. Finite timing and KAT tests are not formal CT, power/EM or universal
equivalence proofs; see ct_results.md and validation_limits.md.
