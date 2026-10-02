# A11 two-coefficient/two-limb FFT input scan

Status: directly implemented in A_tw_bridge; all nine main gates and the
additional paired-input comparison pass on current sources. A10 is archived
for reproducibility, not used as an unmeasured backend. B14 and external
references are untouched. No SLOTHY or cross-candidate backend selection.

## Independent same-ELF trial

[input_pair/200201Z](results/A_tw_bridge/input_pair/20260927T200201Z/manifest.json)
passes 68608 original/A10/trial raw-output and guard comparisons. It tests
all scales 0..63487 for a designated three-limb array, selected lengths
0..4095 with valid scales, sign patterns/random words and four word offsets.
The test-only helper is NOT linked into whole key generation.

| n=2 limb length | Original C | A10 | trial | A10/trial |
| ---: | ---: | ---: | ---: | ---: |
| 1 | 323 | 235 | 223 | 1.0538x |
| 2 | 365 | 268 | 223 | 1.2018x |
| 3 | 407 | 301 | 232 | 1.2974x |
| 4 | 449 | 334 | 236 | 1.4153x |
| 8 | 1029 | 466 | 262 | 1.7786x |
| 16 | 1629 | 730 | 314 | 2.3248x |
| 32 | 2829 | 1258 | 418 | 3.0096x |
| 64 | 5229 | 2314 | 626 | 3.6965x |
| 128 | 10029 | 4426 | 1042 | 4.2476x |
| 512 | 38829 | 17098 | 3538 | 4.8327x |
| 2047 | 153865 | 67753 | 13518 | 5.0121x |

Minimum cycles of 32 complete wrapper calls, IRQ masked, calls/conversions
included. The three implementations share inputs and ELF, not necessarily
the same code addresses. These are NOT whole-keygen ratios.

At n=2,len=32, 32 coefficient/scale classes x20 trials x128 calls: all trial
samples are exactly 51345 cycles; A10 is 158484--158485 and original C is
359826--359827. This finite check is not formal constant-time/power/EM proof.

## Direct implementation

Only A_tw_bridge/kgen_fft_cm55.s changes from archived A10. The existing
fndsa_fixed_input_mve function dispatches on public n==2 to its own local
pair scan, then rejoins its original sign/shift/store sequence. No separate
production helper, public API change, new C backend flag or new workspace.
The same 88-byte save frame is used. All other sizes retain their original
scan; their entry dispatch overhead must be included in whole measurements.
The original wrapper, FFT/iFFT, reciprocal, Babai policy and integer update
are unchanged. See [design](../research/paired_input_design.md).

## Production checks and costs

All IDs below are UTC on 2026-09-27. Each manifest is valid with zero faults
and correct TCM/ECC state. Original KAT includes exact integer NTRU equations.

| Gate | Run | Result |
| --- | --- | --- |
| fixed_fft | [200539Z](results/A_tw_bridge/fixed_fft/20260927T200539Z/manifest.json) | 5120 raw arrays/guards match |
| fixed_input | [200544Z](results/A_tw_bridge/fixed_input/20260927T200544Z/manifest.json) | 220672 cases match |
| fixed_division | [200551Z](results/A_tw_bridge/fixed_division/20260927T200551Z/manifest.json) | 1018184 raw quotients +320 inverse arrays match |
| kat | [200558Z](results/A_tw_bridge/kat/20260927T200558Z/manifest.json) | 300 original KAT/equation checks pass |
| extra | [200727Z](results/A_tw_bridge/extra/20260927T200727Z/manifest.json) | 300 independent-seed KAT/equation checks pass |
| sigkat | [200811Z](results/A_tw_bridge/sigkat/20260927T200811Z/manifest.json) | 90 sign/verify/tamper checks pass |
| profile | [200821Z](results/A_tw_bridge/profile/20260927T200821Z/manifest.json) | 200 keys, consistent totals |
| kernel | [200906Z](results/A_tw_bridge/kernel/20260927T200906Z/manifest.json) | retained FP bridge: 640 comparisons, 16 divider classes pass |
| input_pair | [200909Z](results/A_tw_bridge/input_pair/20260927T200909Z/manifest.json) | another 68608 original/production/trial cases match |
| keygen | [200643Z](results/A_tw_bridge/keygen/20260927T200643Z/manifest.json), [200944Z repeat](results/A_tw_bridge/keygen/20260927T200944Z/manifest.json) | each run: 200 KAT/equation checks pass |

The integrated n=2,len=32 call takes 442 cycles in fixed_input/200512Z,
versus 418 for the isolated trial. Shared-tail dispatch/code placement costs
are not subtracted. Its 128-call timing samples are all 54290 cycles for
32 classes x20 trials. The production n=2,len=1 path is 247 cycles versus
A10's archived 235: this small-length regression is explicitly retained in
the measured whole result, not reported as an across-the-board speedup.
Longer production lengths 4/8/128/512/2047 take 260/286/1066/3562/13542 cycles.

Sign-test code is 124216 ITCM bytes (+184 from A10); DTCM remains 251432
bytes including the 64-KiB reserved stack. The input helper/wrapper frame
stays 88+24 bytes. These are linked/local bounds, not a full stack proof.

## Whole effect and attribution

First plain whole run: **54,268,516.27 /235,984,647.93 cycles** for key512/1024.
Relative to A10, time falls **0.0950% /0.0995%**. The target 1.7x is NOT met.

Same-ELF repeat/200944Z: **54,268,516.48 /235,984,647.11 cycles**. The two
means differ by less than one cycle per key. Relative to M55_ref, speed is
**1.1561x /1.1090x**, including previous NTT gains. Additional time reduction
versus ntt_opt is **4.7106% /2.9499%**; this is the isolated contribution of
the whole new candidate, not all of the M55_ref ratio.

The production-source paired-input repeat/200909Z also matches all outputs.
Its 128-call production minima/maxima are 54036 for every tested class;
the test-only helper is 51345--51346, and original C is 359826--359827.
The one-cycle trial variation and differing harness contexts are preserved
as observations, not claimed as a proven cause or perfect universal CT.

The A10 profile/194731Z and A11 profile/200821Z have identical operation keys
and call counts. Below are per-key instrumented costs, NOT plain whole cycles.

| Interval | 512 A10 -> A11 | time change | 1024 A10 -> A11 | time change |
| --- | ---: | ---: | ---: | ---: |
| n=2 input conversion | 220,635.59 -> 164,020.00 | -25.6602% | 769,247.14 -> 520,492.86 | -32.3374% |
| all intermediate input | 667,002.97 -> 608,191.14 | -8.8173% | 1,929,075.53 -> 1,672,898.14 | -13.2798% |
| all NTRU | 43,587,875.87 -> 43,529,986.66 | -0.1328% | 183,925,220.19 -> 183,672,694.54 | -0.1373% |

Intermediate FFT profile cost moves +0.0700%/+0.1090% despite unchanged
arithmetic; code placement/context remains a potential factor. Other nearby
work is almost unchanged. Actual limb lengths vary and include very short
values, so the 32-limb trial's 3x ratio does not predict the entire input
interval, still less the whole key generation speedup.
