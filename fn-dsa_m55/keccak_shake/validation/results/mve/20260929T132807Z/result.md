# Keccak cycle baseline (M55)

Run: `20260929T132807Z`. ELF SHA-256: `c37451cccf539d3859f7d5181b0f17fc434ce13f412398d19011c62e2fca213f`.

100 samples; each sample contains 64 calls; 5 warm-up batches. The empty-loop/timer cost is subtracted, retaining BL/return and the actual function body.

| Target | Raw cycles/call | Calibrated mean | Median | Min | Max | Stddev |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| fndsa_sha3_process_block() | 16123.984 | 16120.000 | 16120.000 | 16120.000 | 16120.000 | 0.000 |
| bit_split_1 | 51.016 | 48.000 | 48.000 | 48.000 | 48.000 | 0.000 |
| bit_split_5 | 222.016 | 219.000 | 219.000 | 219.000 | 219.000 | 0.000 |
| bit_merge_1 | 51.016 | 48.000 | 48.000 | 48.000 | 48.000 | 0.000 |
| bit_merge_5 | 222.016 | 219.000 | 219.000 | 219.000 | 219.000 | 0.000 |
| split group: 4 x split_5 + split_1 | 927.016 | 924.000 | 924.000 | 924.000 | 924.016 | 0.002 |
| merge group: 4 x merge_5 + merge_1 | 927.016 | 924.000 | 924.000 | 924.000 | 924.000 | 0.000 |

The split/merge groups are measured as the matching private-call sequence in a separate harness. They exclude caller-side state loads/stores; they are not exact in-situ exclusive portions of the process_block time. process_block includes its own split/merge work already. Do not add the three group totals.

Correctness: helper cases 5120, full-state comparisons 1024, SHAKE256 vectors 7, guards PASS. CFSR/HFSR/AFSR = 0.
These tests and any absence of observed timing differences are not a proof of constant-time behavior.

Empty harness cycles per iteration: process_empty=3.984375, helper_empty=3.015625.

| Timing class (raw single call) | Count | Mean | Min | Max |
| --- | ---: | ---: | ---: | ---: |
| 0 (0=zero, 1=random) | 1000 | 16123.000000 | 16123 | 16123 |
| 1 (0=zero, 1=random) | 1000 | 16123.001000 | 16123 | 16124 |

Welch t = -1.0000035438052084 (computed). Limited two-class timing check, not a formal proof.
