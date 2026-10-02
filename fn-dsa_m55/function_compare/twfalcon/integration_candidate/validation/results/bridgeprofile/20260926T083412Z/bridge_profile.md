# Integrated FFT/iFFT: same-function region profile

2026-09-26 KST. Measurement only; production arithmetic/assembly and root policy unchanged.

## Conditions and interpretation

- NUCLEO-N657X0-Q, Cortex-M55 800 MHz, GCC 15.2.1, `-O3`, `fpv5-d16`, no fast math/FMA contraction.
- Existing mlkem-native-based board startup: ITCM code, DTCM data/stack, each 256 KiB; caches OFF, interrupts disabled, TCM_CONTROL=0x99, default FP environment (FZ/DN OFF).
- Same ELF contains unchanged public functions, namespace-only control copies, instrumented copies, and fixed M55_ref-equivalent function bodies.
- 5 batches, each 10 warmup + 100 measured calls; deterministic input changes each call, backend order rotates. Inverse input is an FFT output prepared outside timing.
- Input copies, fixture preparation, output comparison and logging are outside timing. Public and measurement copies use the same input/output buffer address; their private workspaces and code addresses differ.
- Removing marked timer hooks and undoing symbol renaming recovers both original complete C files byte for byte (generator asserts this). The same unmodified assembly is shared.
- These are kernel diagnostic fixtures, not a whole-keygen workload-weighted profile.

## Disjoint shares of the instrumented whole function

| n | function pair | input double→2×FP32 | root preparation | compute + inner control | output 2×FP32→double | outer control/timing | total |
| ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 512 | vect_FFT / vect_FFT_fp64 | 11.407% | 1.564% | 77.211% | 9.736% | 0.082% | 100% |
| 512 | vect_iFFT / vect_iFFT_fp64 | 10.707% | 2.298% | 77.780% | 9.139% | 0.075% | 100% |
| 1024 | vect_FFT / vect_FFT_fp64 | 10.544% | 1.452% | 78.962% | 9.004% | 0.038% | 100% |
| 1024 | vect_iFFT / vect_iFFT_fp64 | 9.878% | 2.133% | 79.519% | 8.435% | 0.035% | 100% |

The compute bucket is `core_inclusive − roots`; the nested root time is **not double-counted**. It includes MVE butterfly arithmetic and coefficient load/store, loop/dispatch/call costs, inverse final scaling, and root timer/counter overhead. Outer residual is `whole − input − core_inclusive − output`. Rounded table entries can differ from 100% by 0.001 percentage point.

## Cycles per call (arithmetic mean over 500 calls)

| n | op | input | roots | compute + inner control | output | outer residual | measured total |
| ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 512 | FFT | 13,210.00 | 1,811.00 | 89,416.00 | 11,275.00 | 95.00 | 115,807.00 |
| 512 | iFFT | 13,210.00 | 2,835.00 | 95,959.00 | 11,275.00 | 93.00 | 123,372.00 |
| 1024 | FFT | 26,394.00 | 3,635.00 | 197,655.00 | 22,539.00 | 95.00 | 250,318.00 |
| 1024 | iFFT | 26,394.00 | 5,699.00 | 212,473.00 | 22,539.00 | 93.00 | 267,198.00 |

## What accounts for the cost?

| n | op | input+output conversion | conversion + root preparation |
| ---: | --- | ---: | ---: |
| 512 | FFT | 21.143% | 22.707% |
| 512 | iFFT | 19.846% | 22.144% |
| 1024 | FFT | 19.548% | 21.000% |
| 1024 | iFFT | 18.313% | 20.446% |

This run uses precomputed FP32 roots. Root preparation now measures the remaining pointer/broadcast work, not runtime Q32 conversion. Packed assembly root loads are inside the compute bucket. There are no DS-kernel int64-to-double root conversions.

Runtime share is **not** a proven causal percentage of the speed gap against M55_ref. Use the separate same-image stage10/stage11 twiddlebench comparison for the measured optimization effect.

## Instrumentation and same-image controls

| n | op | fixed reference | unchanged public | namespace control | instrumented | instrumented vs public | instrumented vs control | control vs public |
| ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 512 | FFT | 126,043.01 | 114,725.00 | 114,629.00 | 115,807.00 | +0.943% | +1.028% | -0.084% |
| 512 | iFFT | 143,336.00 | 122,446.00 | 121,642.00 | 123,372.00 | +0.756% | +1.422% | -0.657% |
| 1024 | FFT | 280,637.00 | 248,357.01 | 248,101.00 | 250,318.00 | +0.790% | +0.894% | -0.103% |
| 1024 | iFFT | 318,470.00 | 265,412.01 | 263,552.00 | 267,198.00 | +0.673% | +1.383% | -0.701% |

Shares use measured, instrumented totals. No timer cycles were arbitrarily subtracted. Back-to-back empty interval was 1 cycle; the calibration loop including counter updates took about 16 cycles/iteration, but neither is an exact correction for every instrumented loop. Differences above include instrumentation-induced code generation/register allocation and layout effects, not just timestamp instructions. Public aliases differ only by a few cycles.

## Validation and provenance

- Public aliases/control/instrumented outputs: **8,800/8,800 byte-identical** to the unchanged public function. This is profiling-equivalence validation, not a new complete KAT or formal constant-time proof.
- All 20 batch accounting checks pass; per call root-region counts are 65 (512) / 129 (1024).
- Board CFSR/HFSR/AFSR are zero; TCM configuration/ECC checks pass. Original crypto source hashes are recorded and unchanged throughout the run.
- M55_ref fixed function bodies and arithmetic helper bodies were separately audited unchanged with `tools/audit_fixed_reference.py`.
- Historical whole-image cycle values are not substituted here: the fixed/public/control paths were all remeasured together in this ELF.

[Raw board log](raw.log), [run manifest](run.json), [machine-readable summary](bridge_summary.json).

Reproduce:

```sh
sh fn-dsa_m55/function_compare/twfalcon/integration_candidate/validation/build.sh bridgeprofile
fn-dsa_m55/measurement_mlkem_native/env/build-venv/bin/python fn-dsa_m55/function_compare/twfalcon/integration_candidate/validation/run_board.py bridgeprofile
fn-dsa_m55/measurement_mlkem_native/env/build-venv/bin/python fn-dsa_m55/function_compare/twfalcon/tools/summarize_bridge.py <result-directory>
```
