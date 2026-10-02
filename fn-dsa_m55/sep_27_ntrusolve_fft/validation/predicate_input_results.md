# A12 exact vector-predicate FFT input scan

Status: directly implemented in A_tw_bridge; all nine main gates plus both
paired-input and predicate-input checks pass on current sources. A11 is
archived and its passes were not inherited. B14 and external references are
unchanged. No SLOTHY, cross-tree
crypto links or production backend flags.

## Three-way same-ELF trial

[input_predicate/201720Z](results/A_tw_bridge/input_predicate/20260927T201720Z/manifest.json)
compares original C, A11 and the trial on 220672 common cases. All output and
guard bits match. The n=1/2 trial-wrapper path delegates to A11: those cases
test boundaries but do not execute the new n>=4 scan. Test scale is kept
within 0..63487. Selected lengths up to 2047, four word offsets, full sign
patterns and pseudorandom limbs are included. No input-end MPU guard proof.

All 25 timed size/length combinations improve. Representative per-call
minima include wrapper/call work and timing overhead, IRQ masked:

| n | limbs | original C | A11 | trial | A11/trial |
| ---: | ---: | ---: | ---: | ---: | ---: |
| 4 | 1 | 489 | 240 | 209 | 1.1483x |
| 4 | 32 | 5517 | 1232 | 643 | 1.9160x |
| 4 | 512 | 77757 | 16592 | 7363 | 2.2534x |
| 4 | 2047 | 308595 | 65712 | 28853 | 2.2775x |
| 512 | 1 | 42145 | 13575 | 10623 | 1.2779x |
| 512 | 8 | 223393 | 42247 | 23167 | 1.8236x |
| 1024 | 8 | 446625 | 84359 | 46207 | 1.8257x |

Input/scale timing: 32 classes x20 trials x32 calls. At n=4,len=32 the new
trial is exactly 19987 cycles in all samples (A11 38742); at n=512,len=8
new minima are 740755 with occasional +1 (A11 1351222 with occasional +1).
Public dimensions have different work; they are not pooled as timing classes.
These are finite observations, not formal CT or physical-leakage proofs.

## Direct production implementation

Only kgen_fft_cm55.s changes from the archived A11 crypto sources. The
existing helper uses its own new n>=4 loop and rejoins original sign/shift/
store code. n=1 retains its masked-load/scalar-mask loop; n=2 retains the
A11 two-limb path. No test helper is linked into key generation. The final
helper's ABI frame is unchanged (88 bytes), and no workspace/table is added.
The public-size branch overhead and all real calls remain in whole timings.

See [identity and access argument](../research/predicate_input_design.md).
The signature-test link uses 124264 ITCM bytes (+48 from A11) and unchanged
251432 DTCM bytes, including the 64-KiB reserved stack. The local input
frames are still 88 assembly +24 C bytes. Link fit is not a whole-program
worst-case stack or memory-safety proof.

The first A12 plain-keygen run
[202124Z](results/A_tw_bridge/keygen/20260927T202124Z/manifest.json) completes
200 KAT/equation checks. Mean cycles are 54,168,122.18 /235,699,617.36 for
key512/1024: -0.1850%/-0.1208% time versus A11. M55_ref ratios are
1.1582x/1.1104x including prior NTT gains; extra time reductions versus
ntt_opt are 4.8869%/3.0671%. This is not the 1.7x target. The same-ELF
repeat is tracked separately below; no hook-included profile total is used
as this plain whole-keygen measurement.

## Source-matched production gates

Run IDs are UTC on 2026-09-27. Every listed manifest is valid with zero
faults and required TCM/ECC state. KAT rows also check integer NTRU equations.

| Gate | Run | Result |
| --- | --- | --- |
| fixed_fft | [202020Z](results/A_tw_bridge/fixed_fft/20260927T202020Z/manifest.json) | 5120 raw arrays/guards match |
| fixed_input | [202025Z](results/A_tw_bridge/fixed_input/20260927T202025Z/manifest.json) | 220672 cases match |
| fixed_division | [202031Z](results/A_tw_bridge/fixed_division/20260927T202031Z/manifest.json) | 1018184 raw quotients and 320 inverse arrays match |
| kat | [202038Z](results/A_tw_bridge/kat/20260927T202038Z/manifest.json) | 300 original KAT/equations pass |
| keygen | [202124Z](results/A_tw_bridge/keygen/20260927T202124Z/manifest.json), [202433Z repeat](results/A_tw_bridge/keygen/20260927T202433Z/manifest.json) | each run: 200 keys/equations pass |
| extra | [202207Z](results/A_tw_bridge/extra/20260927T202207Z/manifest.json) | 300 independent-seed KAT/equations pass |
| sigkat | [202251Z](results/A_tw_bridge/sigkat/20260927T202251Z/manifest.json) | 90 sign/verify/tamper cases pass |
| profile | [202301Z](results/A_tw_bridge/profile/20260927T202301Z/manifest.json) | 200 keys, consistent totals |
| kernel | [202346Z](results/A_tw_bridge/kernel/20260927T202346Z/manifest.json) | retained FP bridge 640 comparisons, 16 divider timing classes pass |
| input_pair | [202349Z](results/A_tw_bridge/input_pair/20260927T202349Z/manifest.json) | 68608 original/production/trial cases match |
| input_predicate | [202352Z](results/A_tw_bridge/input_predicate/20260927T202352Z/manifest.json) | 220672 original/production/trial cases match |

In the production-source predicate test, complete 32-call timing minima
are 19382 cycles at n=4,len=32 and 740918 at n=512,len=8. Every class has the
same minimum; maxima are equal or +1. The isolated helper in that same ELF
remains 19987 and 740755--740756. These context differences are not discarded
or assigned a proven cause. Finite samples are not formal all-input CT or
physical leakage security. The retained FP bridge can still differ in raw
Q32 units while its tested final rounded outputs match, as recorded separately.

## Integration profile attribution

A11 profile/200821Z and A12 profile/202301Z use the same seeds and have
identical operation keys and call counts. Per-key cycles below include
instrumentation and must not replace the plain whole-keygen table.

| Interval | 512 A11 -> A12 | time change | 1024 A11 -> A12 | time change |
| --- | ---: | ---: | ---: | ---: |
| n>=4 input conversion | 444,171.14 -> 342,009.43 | -23.0005% | 1,152,405.28 -> 861,942.58 | -25.2049% |
| all intermediate input | 608,191.14 -> 506,029.43 | -16.7976% | 1,672,898.14 -> 1,382,413.62 | -17.3641% |
| all NTRU | 43,529,986.66 -> 43,427,943.83 | -0.2344% | 183,672,694.54 -> 183,383,199.96 | -0.1576% |

n=2 input stays 164020/520471 cycles (previous 164020/520493). Nearby
unchanged FFT costs move +0.0222%/+0.0311%; other arithmetic/update costs
are almost unchanged. The measured whole improvement is attributable
primarily to the intended boundary, not new FFT precision or iteration policy.
The differences between isolated long-limb ratios and the weighted interval
reflect actual varying lengths plus dispatch/context costs; they are not
silently promoted into whole-keygen speedups.

Same-ELF keygen repeat/202433Z gives **54,168,121.70 /235,699,616.15 cycles**.
First/repeat means differ by 0.48/1.21 cycles per key. The result remains
1.1582x/1.1104x versus M55_ref and -4.8869%/-3.0671% time versus ntt_opt.
All gates and the repeated plain measurement use the current source hashes.
