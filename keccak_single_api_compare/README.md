# Existing single FN-DSA APIs: Keccak candidates

This is a measurement-only project. It does not modify or integrate anything
into `Final_code/Before_slothy`, `keccak_test_batch4`, or `fn-dsa_m55/keccak_shake`.

Three actual source directories are built separately:

| Candidate | Sources | Keccak / signing behavior |
|---|---|---|
| `ref` | `Final_code/Before_slothy` | Original CM4 single-state SHAKE |
| `batch4` | `keccak_test_batch4` | Existing **single** APIs, not the new batch API |
| `single_mve` | `fn-dsa_m55/keccak_shake` | Existing A14 single-state MVE Keccak |

No new crypto algorithm, forwarding shim, or production backend option was
implemented here. Each existing candidate's actual local C and ASM sources are
compiled. The test-only CMake selection chooses the source directory to measure.
The three linked images contain neither `fndsa_sign_seeded_batch4_temp()` nor
`fndsa_keccakx4_permute()`: garbage collection removes these unused functions.

## APIs and inputs

- `fndsa_keygen_seeded_temp()`
- `fndsa_sign_seeded_temp()`
- `fndsa_verify_temp()`

These are existing single-operation APIs. Caller seeds and scratch memory make
the inputs reproducible; no four-request aggregation/prefetch is used. System
entropy acquisition and the stack-allocating convenience wrappers are not timed.

For each size: 8 distinct deterministic key/seed/message inputs, 1 warm-up and
3 measured repetitions per input. Verification timings are batches of 32 calls
on the same signature, divided by 32; this is a timing-loop average, **not** x4
verification. Output validation is outside timed regions.

`host_vectors.c` generates original portable `fn-dsa_ref` SHAKE256 output digests
for the exact encoded private/public keys and signatures. All runs compare with
these expectations and check valid/tampered verification and scratch guards.

## Reproduction

```sh
bash keccak_single_api_compare/build.sh ref
bash keccak_single_api_compare/build.sh batch4
bash keccak_single_api_compare/build.sh single_mve
python3 keccak_single_api_compare/audit_layout.py
source fn-dsa_m55/measurement_mlkem_native/env/environment.sh
python keccak_single_api_compare/run.py ref
python keccak_single_api_compare/run.py batch4
python keccak_single_api_compare/run.py single_mve
python keccak_single_api_compare/analyze.py
```

The runner locks and addresses only the known N657 ST-Link, loads an ELF to RAM,
and archives sources, hashes, ELF/map, config, disassembly and raw log. No Flash
write/erase or M4 board operation is involved. The generated flat BIN is removed
because its ITCM/DTCM address gap creates a 512-MiB artifact; ELF/map are retained.

See [result.md](result.md). Memory padding is measurement-only and must not be
reported as production library footprint.
