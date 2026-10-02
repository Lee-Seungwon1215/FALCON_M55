# A8: direct Q32-array reciprocal division

Status: isolated and whole-program board gates complete for current A8,
including a repeated whole-keygen run. A8 is the best measured candidate
so far, but the 1.7x whole-keygen goal is NOT achieved. External production
refs are unchanged. A7 historical gates are not inherited: all required
gates were rerun against the A8 source hashes.

## Change

`A_tw_bridge/kgen_fxp.c` batches the original `vect_inv_mul2e_fft` by four
coefficients for public logn>=3. Its original negation, Q32 squared norm
and scale stay unchanged. `A_tw_bridge/kgen_fft_cm55.s` contains the directly
written `fndsa_fxr_div4`: VLD2/VST2 split/join interleaved 64-bit Q32 words,
then perform four original division recurrences simultaneously. No DS or
double conversion, new backend switch, other candidate link or SLOTHY.
The scalar helper used outside this NTRU operation is untouched.

## Isolated evidence

Run: [20260927T172407Z](results/A_tw_bridge/fixed_division/20260927T172407Z/manifest.json).
254,546 four-lane calls = 1,018,184 quotients match original raw uint64
results, including full-width random values, signs, powers/adjacent values,
zero-denominator original behavior, full aliasing, four offsets and output
guards. These inputs test the original recurrence, not a mathematical
division contract on invalid-domain values.

Repeat [20260927T173029Z](results/A_tw_bridge/fixed_division/20260927T173029Z/manifest.json)
matches the same 1,018,184 values and 320 reciprocal arrays. All 32 timing
class minima are again 134346, with occasional maxima 134347. Thus the
latest run is not claimed to have perfectly identical timings in every
sample. The two paired inverse timings below are unchanged in the repeat.

The full reciprocal function also matches all 320 arrays: logn=1..10,
32 patterns/scales (e=0..31), preserved surrounding output slots.

Four quotients x64 calls, including identical input resets/calls, IRQ off:
original scalar 445,390 cycles; A8 134,346 cycles (3.3152x). All 32 operand
classes x20 trials have 134,346 cycles for A8 in this run; scalar has occasional
one-cycle maxima. Finite timing tests plus assembly inspection are not a
whole-program constant-time or power/EM-leakage proof.

Complete inverse, 32 calls, excluding input reset but including the wrapper,
norm, scale, division and all output stores:

| n | Original cycles/call | A8 cycles/call | Ratio |
| --- | ---: | ---: | ---: |
| 512 | 886,557.03125 | 270,503 | 3.2774x |
| 1024 | 1,773,085.03125 | 540,967 | 3.2776x |

These paired same-ELF kernel ratios are NOT whole-keygen speedups. The
small logn=1/2 path is still scalar and has 6/7 extra cycles/call in this
test (public dispatch/code layout), recorded rather than hidden.

The linked keygen helper frame is 112 bytes (16 bytes for saved integer
registers +64 for saved vector registers +32 scratch); its C caller has a 136-byte frame,
including its aligned 32-byte denominator tile. This is not a complete
call-chain/worst-case stack proof. Accesses are fixed-address within four
coefficients; the isolated test uses output canaries, not MPU input guards.

Source/algorithm provenance: [division design](../research/division_design.md).

## Whole-keygen effect

Same board/clock/TCM/compiler/flags/seeds as the common baseline. 100 seeds
per degree, 3 warmups excluded; all conversions, failed candidates, retries
and encoding remain inside the timed call. Same placement policy, not all
functions pinned to identical addresses. Unit kernels are IRQ-masked;
whole keygen uses the common IRQ-enabled environment.

| Implementation | 512 mean cycles | 1024 mean cycles |
| --- | ---: | ---: |
| M55_ref, 141357Z | 62,738,244.34 | 261,716,429.63 |
| ntt_opt, 142645Z | 56,951,253.03 | 243,157,429.30 |
| A7, 165420Z | 55,394,595.48 | 238,879,145.49 |
| A8 first, 172643Z | 54,765,620.62 | 237,610,758.09 |
| A8 repeat, 172946Z | 54,765,620.59 | 237,610,757.98 |

A8 reduces time by 1.1354%/0.5310% against A7 and 3.8377%/2.2811%
against ntt_opt. M55_ref/A8 is 1.1456x/1.1015x, including the prior NTT
gain; do not credit that entire ratio to the new FFT experiment.

[First whole run](results/A_tw_bridge/keygen/20260927T172643Z/manifest.json),
[repeat](results/A_tw_bridge/keygen/20260927T172946Z/manifest.json).

## Where the saving occurs

Separate instrumented runs A7 165209Z and A8 172818Z; average cycles per
whole key, including all intermediate attempts. These are not the
uninstrumented whole-keygen denominators above.

| Interval | A7 512 | A8 512 | A7 1024 | A8 1024 |
| --- | ---: | ---: | ---: | ---: |
| I_input | 667,002.90 | 667,046.64 | 1,929,010.03 | 1,929,097.33 |
| I_fft | 1,533,350.47 | 1,533,361.40 | 4,105,746.65 | 4,105,724.95 |
| **I_recip (changed)** | **932,970.21** | **303,908.07** | **1,871,720.31** | **603,417.17** |
| I_mul | 450,912.54 | 450,923.49 | 1,168,461.16 | 1,168,341.15 |
| I_ifft | 1,632,413.89 | 1,632,381.14 | 4,413,032.47 | 4,412,956.06 |
| I_round | 201,504.66 | 201,482.86 | 529,662.16 | 529,662.23 |

The reciprocal interval falls 67.4257%/67.7614%, saving 629,062/1,268,303
instrumented cycles, consistent with the 628,975/1,268,388 whole-cycle
saving. The unchanged FFT/iFFT and surrounding intervals have only tiny
layout/timing differences. Neither claim is that the butterfly became
3.3x faster. Current target scope is 9.66895%/5.84036% of instrumented
whole keygen. Only 13,647.50/18,888.14 cycles of I_recip remain at logn=1/2;
vectorizing those small paths alone cannot give a large whole-keygen gain.

## Current-source gates

| Gate | Run UTC | Result |
| --- | --- | --- |
| Original KAT / exact NTRU equation | 172507Z | 300/300 |
| Extra frozen-baseline seeds / exact equation | 172726Z | 300/300 |
| Signature KAT, verify, tamper rejection | 172808Z | 90/90 |
| Integration profile | 172818Z | 200/200 keys, accounting errors 0 |
| FFT/iFFT finite arrays | 172903Z | 640 arrays, rounded discrepancies 0 |
| Exact input boundary | 172906Z | 220,672 cases, errors 0 |
| Direct division / reciprocal | 173029Z | 1,018,184 quotients +320 arrays, errors 0 |

FFT raw intermediate values are NOT universally bit-identical: this
unchanged bridge still has up to 257 raw Q32 units error in the tested
1024 FFT inputs. The unchanged FP64 depth0 divider's 16 classes have
minima 99979 and an occasional maximum 99980; FFT native timing spans
four cycles in its finite tests. Local exact divider success is not proof
that the entire mixed FFT is exact or universally constant-time.

[Current source/gate map](current_validation.json),
[source/ELF/log integrity check](evidence_check.json),
[scope/source check](scope_check.json), [CT limitations](ct_results.md).
