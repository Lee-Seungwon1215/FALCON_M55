# Keccak cycle baseline (M55)

Run: `20260929T143237Z`. ELF SHA-256: `e5ba8a6f032726d54adc76215d58ad3b8a0003f9b1a356971370d3f8f1c36bc8`.

100 samples; each sample contains 64 calls; 5 warm-up batches. The empty-loop/timer cost is subtracted, retaining BL/return and the actual function body.

| Target | Raw cycles/call | Calibrated mean | Median | Min | Max | Stddev |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| fndsa_sha3_process_block() | 16383.985 | 16380.000 | 16380.000 | 16380.000 | 16380.016 | 0.002 |
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
| 0 (0=zero, 1=random) | 1000 | 16383.000000 | 16383 | 16383 |
| 1 (0=zero, 1=random) | 1000 | 16383.001000 | 16383 | 16384 |

Welch t = -1.0000035438052084 (computed). Limited two-class timing check, not a formal proof.
