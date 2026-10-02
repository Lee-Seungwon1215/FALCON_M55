# Keccak cycle baseline (M55)

Run: `20260929T101709Z`. ELF SHA-256: `a97a723e5c9d6705d2c5e7962c85238af72ac4840371632b5ca76bba0919fc90`.

100 samples; each sample contains 64 calls; 5 warm-up batches. The empty-loop/timer cost is subtracted, retaining BL/return and the actual function body.

| Target | Raw cycles/call | Calibrated mean | Median | Min | Max | Stddev |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| fndsa_sha3_process_block() | 13386.985 | 13383.000 | 13383.000 | 13383.000 | 13383.016 | 0.002 |
| bit_split_1 | 51.016 | 48.000 | 48.000 | 48.000 | 48.000 | 0.000 |
| bit_split_5 | 222.016 | 219.000 | 219.000 | 219.000 | 219.000 | 0.000 |
| bit_merge_1 | 51.016 | 48.000 | 48.000 | 48.000 | 48.000 | 0.000 |
| bit_merge_5 | 222.016 | 219.000 | 219.000 | 219.000 | 219.000 | 0.000 |
| split group: 4 x split_5 + split_1 | 927.016 | 924.000 | 924.000 | 924.000 | 924.000 | 0.000 |
| merge group: 4 x merge_5 + merge_1 | 927.016 | 924.000 | 924.000 | 924.000 | 924.000 | 0.000 |

The split/merge groups are measured as the matching private-call sequence in a separate harness. They exclude caller-side state loads/stores; they are not exact in-situ exclusive portions of the process_block time. process_block includes its own split/merge work already. Do not add the three group totals.

Correctness: helper cases 5120, full-state comparisons 1024, SHAKE256 vectors 7, guards PASS. CFSR/HFSR/AFSR = 0.
These tests and zero observed timing variance are not a proof of constant-time behavior.

Empty harness cycles per iteration: process_empty=3.984375, helper_empty=3.015625.
