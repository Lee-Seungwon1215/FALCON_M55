# M55_ref vs current ntt_opt / K4C: four NTT kernels

2026-09-28 remeasurement. This project compares the four original M55_ref
transforms directly against current ntt_opt, including the adopted K4C RNS
assembly. It does not time whole key generation, signing, or verification.
No SLOTHY is applied.

The older sibling `../ntt` and all its K2 sources, firmware and results are
preserved unchanged. Its timing/checking harness, board startup and slot
placement policy are copied here without changing the measured workload.
Cryptographic sources are independent local files, extracted directly from
M55_ref and ntt_opt. There is no crypto source link to another candidate.

## Source identity

- Common q=12289: M55_ref/mq_cm4.s vs ntt_opt/mq_cm55.s.
- RNS: original C with its M4 inline assembly vs ntt_opt/kgen_mp31_cm55.s.
- Adopted K4C source SHA-256:
  `bad74cbe6f569a948b70f887b47cc0c5fc9f7e6130605df27adb70f3d88ece88`.
- Only public symbol namespaces and comparison sections are adapted in ASM;
  no arithmetic or instruction ordering is changed.
- Small-size C fallback is extracted from current ntt_opt. The optimized
  inverse uses full inverse roots; the original uses half-scaled roots.
  Both root tables are prepared outside the timed transform.
- `extraction.json` records input/output hashes; `extract.py --check` verifies
  the exact adaptation. The normal build never generates an optimization.

## Measurement

NUCLEO-N657X0-Q, fixed ST-Link `003C00223335510735383531`, CPU/SYSCLK/HCLK
800/400/200 MHz, code ITCM and data/constants/stack DTCM, 256 KiB each,
caches OFF, TCM ECC ON. Pinned GCC 15.2.1, -O3, -mcpu=cortex-m55,
-mfpu=fpv5-sp-d16, -mfloat-abi=hard, original M4 inline ASM ON.
These four transform kernels use integer arithmetic; both sides have the
same compiler options. All compile commands are archived with each build.
Only RAM loading is used; no flash write or erase.

Both candidates are in one ELF and use the same indirect-call timer and data
address. Each condition has 10 warmups and 10 batches of 100 calls; call order
alternates by batch. DWT CYCCNT is read with IRQ masked during each timed
batch. Report the middle-pair median of the 10 per-call batch averages.
Calls repeat the transform on its output; input resets occur between batches.
Input copies, external root generation, checks and logging are excluded.
Internal root/twist preparation, final scaling and call/timer overhead remain.

q kernels: sizes 512/1024, both directions. RNS: all 308 primes, logn=4..10,
both directions. Small logn<4 are correctness-only. Sizes are transform
lengths, not whole-key generation measurements or usage-frequency weights.

AB/BA swap equally sized original/optimized code slots, with unrelated
code/data fixed. This does not pin every individual function to the same
address. Both layouts are reported, not just the faster result.

## Verification and limitations

Each layout checks q 72 cases, RNS 27,104 cases, independent direct evaluation
1,548 cases, round trips, inverse on independent spectral input, ranges and
canaries. Outputs after every timed 100-call sequence are compared as well.
This is finite kernel correctness coverage, not full FN-DSA KAT, signing
performance, formal constant-time proof, or power/EM leakage testing.

## Reproduce

```sh
python3 -B fn-dsa_m55/function_compare/ntt_k4c/extract.py --check
bash fn-dsa_m55/function_compare/ntt_k4c/build.sh ab ba
python3 -B fn-dsa_m55/function_compare/ntt_k4c/audit.py layouts
python3 -B fn-dsa_m55/function_compare/ntt_k4c/tests/inspect_kernels.py
python3 -B -m unittest discover -s fn-dsa_m55/function_compare/ntt_k4c/tests -v
fn-dsa_m55/measurement_mlkem_native/env/build-venv/bin/python -B fn-dsa_m55/function_compare/ntt_k4c/run.py ab
fn-dsa_m55/measurement_mlkem_native/env/build-venv/bin/python -B fn-dsa_m55/function_compare/ntt_k4c/run.py ba
python3 -B fn-dsa_m55/function_compare/ntt_k4c/report.py
```

Board runs must be serial. The established board loader and pinned SDK are
reused, but no other project's crypto sources are linked. Successful reports
include raw logs, ELF/source hashes, all-prime CSV and AB/BA comparison.
