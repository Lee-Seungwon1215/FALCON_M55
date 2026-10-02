# B9: four-coefficient input limb selection

This optimizes the integer-to-two-FP32 boundary of NTRU approximation,
not an NTT, CRT, Bezout or FFT arithmetic change. Production implementation
is local to B_continuous_ds/kgen_fft_mve.c and kgen_fft_cm55.s. No backend
selection flags, foreign crypto links or SLOTHY are used.

## Why this transformation is valid in the intended domain

The selection/extension/shift equations are taken from the original
`poly_big_to_fixed()` in baseline_m55/kgen_poly.c and the retained B8
`fndsa_ds_from_big()`. The data are laid out with adjacent coefficients
contiguous inside each 31-bit limb plane. Four coefficients share the same
scale and limb-selection masks, so one vector load per limb replaces four
separate scans without omitting any input limb.

The new assembly scans public len>0 limbs with a public byte stride. Secret
sch/scl are only used in XOR/subtract/sign-mask selection and vector shifts.
They never determine a load address or a branch. The last loaded limb also
provides all four sign-extension words. Scale 0 retains the original wrapped
sch=-1 representation. scl stays in 1..31; DIVREM31's documented input
scale domain is 0..63487. Lengths are below 2^24 limbs, as in the original
conversion contract. The caller retains the original public len=0 and
small-logn cases. Only 32 bytes of selected words are staged, not a Q32 array.

This is an implementation-specific lane-wise translation of the original
algorithm, not a claim that a reference paper supplied this exact function.

## Independent finite comparison

`encoding/oracle_b8.h` is copied from the frozen B8 source snapshot and is
test-only. It calls the same encoder but retains the old per-coefficient
scan; noipa prevents specialization/inlining of this public test oracle.
The separate raw-word oracle compares selection before FP32 rounding can
hide a differing bit. The older B4 full-conversion oracle is also retained.

Final-selector run: encoding/20260927T162610Z. All passed:

- 67,840 four-coefficient raw selection cases. Includes every documented
  scale for a 3-limb polynomial; additional logn=3..10, lengths through 1023
  where the buffer fits, randomized limbs/scales, source offsets 0..3 words,
  and output guard words. This is not every scale for every length/input.
- 272 additional complete conversions versus B8; untouched DS slots match.
- Original 2,070 whole conversions versus B4, including logn=1..10 and len=0.
- Encoder's 1,000,000 random raw words plus 1,024 word-boundary values.

The first prototype saved unused q7 as well. It passed in run 162358Z and
is archived as B9_select4_initial. Final B9 only saves d8-d13, for 88 bytes
of selector ABI/alignment storage. There is no extra polynomial buffer.

## Paired timing, not a whole-keygen speedup

Same ELF/board/compiler, IRQ masked, two warmups and 32 trials for full
conversion. Includes selection, encoder, wrapper and call overhead. The
reference here is frozen **B8**, not M55_ref.

| n | limb length | B8 full conversion cycles | B9 cycles | Speedup |
| --- | ---: | ---: | ---: | ---: |
| 512 | 1 | 73,501 | 39,168 | 1.877x |
| 512 | 2 | 88,861 | 43,264 | 2.054x |
| 512 | 4 | 119,069 | 51,456 | 2.314x |
| 512 | 8 | 249,629 | 67,840 | 3.680x |
| 1024 | 1 | 146,845 | 78,208 | 1.878x |
| 1024 | 2 | 177,565 | 86,400 | 2.055x |
| 1024 | 4 | 237,981 | 102,784 | 2.315x |
| 1024 | 8 | 499,101 | 135,552 | 3.682x |

Separate raw-selector timing: 128 calls, 8 limbs, 4 lanes, 16 warmups,
32 scale/data classes ×20 trials. Minimum is 48,651 MVE vs139,403 C-oracle
cycles (2.865x). MVE observed range is 48,651–48,652; old oracle
139,403–139,404. Do not call this exactly equal timing or assert a cause for
the occasional one-cycle variation without evidence.

Linked selector has only its public-count loop branch and public-stride
load/store addresses; no secret-indexed lookup or conditional execution.
Focused disassembly is in audit/B_continuous_ds.txt. These measurements and
inspection are supporting CT evidence, not a universal timing/leakage proof.
Current-source full KAT, keygen and other gates are recorded by source hash
in current_validation.json; a previous version's success is not inherited.

## First integrated result

Original KAT: kat/20260927T162614Z, 300/300 exact keys and integer NTRU
equations pass. Uninstrumented keygen/20260927T162702Z uses the same 100
seeds per degree, all retries and all input/output costs:

| Candidate | 512 mean cycles | 1024 mean cycles |
| --- | ---: | ---: |
| B8 repeat | 59,501,014.12 | 249,200,552.39 |
| B9 | 59,032,875.16 | 247,983,506.39 |

B8-to-B9 time reductions are **0.7868% /0.4884%**. B9 vs M55_ref is
**1.0628x /1.0554x**, including prior NTT improvements. B9 still loses to
ntt_opt by **3.6551% /1.9848%**, and to A6 by **4.9356% /2.5811%**.
The 1.7x whole-keygen target is not met. The 1.88–3.68x local conversion
speedup must not be used as a whole-keygen or full-FFT speedup.

B9 sign-test link fits ITCM (122364 bytes) and DTCM (250920/262144 bytes,
including a 65536-byte reserved stack). The C from_big function's actual
linked frame is 456 bytes including saved registers, larger than the 32-byte
explicit tile because of the compiler-generated retained small-size path.
The selector adds 88 bytes while called. This observation is not a complete
worst-case call-chain stack bound; only link fit and finite fault-free runs
are claimed.

## Integrated profile and final gates

Profile run 20260927T163019Z vs B8's 20260927T161356Z:

| Leaf, per key | B8 512 | B9 512 | B8 1024 | B9 1024 |
| --- | ---: | ---: | ---: | ---: |
| Intermediate input conversion | 2,063,341.39 | 1,509,364.79 | 6,147,464.11 | 4,717,185.01 |

All 218 operation/size call counts are identical. The leaf includes both
the DS path and the retained small-size fixed path. The latter still costs
742,246.0 /2,790,655.8 cycles at logn=1..3, so the isolated 512/1024 DS
conversion benchmark must not be extrapolated to all input preparation.
Some unchanged leaves move slightly across linked builds (for example
depth0 input 93,265/186,257 to 112,098/223,836 cycles); identical placement
policy is not identical function addresses. Whole results include those
effects and all costs, without subtracting inconvenient regressions.

Current-source gates also pass: extra/20260927T162922Z (300),
sigkat/20260927T163009Z (90), kernel/20260927T163106Z (640),
encoding repeat/20260927T163109Z, rounding/20260927T163113Z and
decoding/20260927T163124Z. Profile accounts for 200 successful keys and all
retries with no accounting errors. Finite transform raw errors and rounded
differences are reported in kernel_summary.md, not relabeled as exact FFT
word equivalence. Full formal CT/stack/all-input equivalence remain unproved.

Unchanged-ELF repeat keygen/20260927T163301Z gives 59,032,874.79 /
247,983,506.14 cycles, within one mean cycle of the first B9 run. This
reproduces the integrated result without claiming cross-ELF layout effects
have been removed.
