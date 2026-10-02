# D0 stage-4 baseline

D0 retains the adopted H1 cryptographic implementation without changes.
Its actual forward layout is penultimate plain store → final VLD4.
Its inverse layout is first VST4 → next plain load.

The folder name `D0_vst4_previous` predates the latest H1 code review and
does not describe its current instructions. No VST4-previous rewrite was
made in this baseline.

See [stage-4 definitions](../README.md), [D1 implementation](../D1_vld4_last/IMPLEMENTATION.md)
and [D1 results](../D1_vld4_last/result.md).

The original H1 implementation report remains at
[H1 IMPLEMENTATION.md](../../3rd_intt_scaling/H1_final_scaling/IMPLEMENTATION.md).
The measurement control under `../experiments/d0_layout/source` changes only
unreachable padding, verified against this folder by prepare_control.py and audit_array.py.
