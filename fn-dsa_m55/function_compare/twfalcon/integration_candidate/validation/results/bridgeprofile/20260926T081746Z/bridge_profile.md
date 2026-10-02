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
| 512 | vect_FFT / vect_FFT_fp64 | 7.456% | 34.946% | 51.181% | 6.364% | 0.054% | 100% |
| 512 | vect_iFFT / vect_iFFT_fp64 | 7.234% | 33.976% | 52.564% | 6.174% | 0.051% | 100% |
| 1024 | vect_FFT / vect_FFT_fp64 | 7.070% | 33.229% | 53.637% | 6.038% | 0.025% | 100% |
| 1024 | vect_iFFT / vect_iFFT_fp64 | 6.848% | 32.249% | 55.032% | 5.848% | 0.024% | 100% |

The compute bucket is `core_inclusive − roots`; the nested root time is **not double-counted**. It includes MVE butterfly arithmetic and coefficient load/store, loop/dispatch/call costs, inverse final scaling, and root timer/counter overhead. Outer residual is `whole − input − core_inclusive − output`. Rounded table entries can differ from 100% by 0.001 percentage point.

## Cycles per call (arithmetic mean over 500 calls)

| n | op | input | roots | compute + inner control | output | outer residual | measured total |
| ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 512 | FFT | 13,210.00 | 61,917.00 | 90,683.00 | 11,275.00 | 95.00 | 177,180.00 |
| 512 | iFFT | 13,210.00 | 62,043.00 | 95,986.00 | 11,275.00 | 93.00 | 182,607.00 |
| 1024 | FFT | 26,394.00 | 124,043.01 | 200,227.01 | 22,539.00 | 95.00 | 373,298.01 |
| 1024 | iFFT | 26,394.00 | 124,297.00 | 212,110.01 | 22,539.00 | 93.00 | 385,433.01 |

## What accounts for the cost?

| n | op | input+output conversion | conversion + root preparation |
| ---: | --- | ---: | ---: |
| 512 | FFT | 13.819% | 48.765% |
| 512 | iFFT | 13.409% | 47.385% |
| 1024 | FFT | 13.108% | 46.337% |
| 1024 | iFFT | 12.696% | 44.944% |

Input/output representation conversion alone is about 13–14% of this implementation, not the whole slowdown. The larger non-butterfly expense is on-demand Q32 root conversion/splat/table preparation (~32–35%). `q32_tw()` performs signed-int64→double conversion, FP32 high/residual conversion, and table/broadcast preparation; the compiled path includes calls to `__aeabi_l2d`. No sub-profile of that helper was performed, so its exact individual contribution is not claimed.

Runtime share is **not** a proven causal percentage of the speed gap against M55_ref. Eliminating a region can change dataflow/memory costs, and M55_ref already includes root loads. Preconverted roots merit a separate experiment; this turn does not implement that optimization or claim a speedup.

## Instrumentation and same-image controls

| n | op | fixed reference | unchanged public | namespace control | instrumented | instrumented vs public | instrumented vs control | control vs public |
| ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 512 | FFT | 126,043.00 | 174,728.00 | 175,016.00 | 177,180.00 | +1.403% | +1.236% | +0.165% |
| 512 | iFFT | 143,336.00 | 180,359.00 | 180,323.00 | 182,607.00 | +1.246% | +1.267% | -0.020% |
| 1024 | FFT | 280,637.00 | 368,477.00 | 369,117.00 | 373,298.01 | +1.308% | +1.133% | +0.174% |
| 1024 | iFFT | 318,470.00 | 380,984.01 | 380,916.01 | 385,433.01 | +1.168% | +1.186% | -0.018% |

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
