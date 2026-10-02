# Keccak cycle baseline (M55)

Run: `20260929T145459Z`. ELF SHA-256: `961261f33af014a872db01b6f21187f1646ffd1f0af79d098883d32876c21c60`.

100 samples; each sample contains 64 calls; 5 warm-up batches. The empty-loop/timer cost is subtracted, retaining BL/return and the actual function body.

| Target | Raw cycles/call | Calibrated mean | Median | Min | Max | Stddev |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| fndsa_sha3_process_block() | 12507.985 | 12504.000 | 12504.000 | 12504.000 | 12504.016 | 0.002 |
| bit_split_1 | 51.016 | 48.000 | 48.000 | 48.000 | 48.000 | 0.000 |
| bit_split_5 | 222.016 | 219.000 | 219.000 | 219.000 | 219.000 | 0.000 |
| bit_merge_1 | 51.016 | 48.000 | 48.000 | 48.000 | 48.000 | 0.000 |
| bit_merge_5 | 222.016 | 219.000 | 219.000 | 219.000 | 219.000 | 0.000 |
| split group: 4 x split_5 + split_1 | 927.016 | 924.000 | 924.000 | 924.000 | 924.000 | 0.000 |
| merge group: 4 x merge_5 + merge_1 | 927.016 | 924.000 | 924.000 | 924.000 | 924.000 | 0.000 |

For the full-MVE variant, bit_split/bit_merge rows measure retained legacy helpers only: process_block no longer calls them. Its actual MVE split/merge macros are included in the process_block total, not separately timed by those helper rows. Do not add the helper rows to process_block.

Correctness: helper cases 5120, full-state comparisons 1024, SHAKE256 vectors 7, guards PASS. CFSR/HFSR/AFSR = 0.
These tests and any absence of observed timing differences are not a proof of constant-time behavior.

Empty harness cycles per iteration: process_empty=3.984375, helper_empty=3.015625.

| Timing class (raw single call) | Count | Mean | Min | Max |
| --- | ---: | ---: | ---: | ---: |
| 0 (0=zero, 1=random) | 1000 | 12507.000000 | 12507 | 12507 |
| 1 (0=zero, 1=random) | 1000 | 12507.000000 | 12507 | 12507 |

Welch t = None (undefined: both observed sample variances are zero). Limited two-class timing check, not a formal proof.
