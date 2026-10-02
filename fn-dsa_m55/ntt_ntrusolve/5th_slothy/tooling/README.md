# Offline reproducibility and safety boundaries

Use the existing isolated environment:

```sh
../../../verify_ntt_stage/ntt_opt_5thStage/tooling/venv/bin/python generate.py --timeout 5
python3 check_schedule.py
```

Run from this tooling directory. The first command invokes the real Slothy
CP-SAT engine pinned at 55983e6760e98aece5359055085a7def96c688b7. It reads the
archived K4-C source, expands macros, schedules and writes complete A/B assembly.
Solver schedules can vary; `logs/manifest.json` and board run source archives
identify the exact code actually measured. Do not regenerate during measurement.

Dependencies are fail-closed and preserve post-index register writes, gather
address registers and predicate/structured-memory groups. GPRs and q0 are locked,
all physical registers are live at window boundaries, spills are disabled.
All memory instructions share one order token; no alias guesses or speculative
buffer reads are used. The approximate target costs are NOT hardware cycles.

`check_schedule.py` does not import Slothy or the adapter. It executes expanded
32-bit arithmetic and memory instructions for 32 random register states, with
N=1,2,3,7, comparing states and ordered memory traces. This complements board
testing; it is not an ISA proof, full program equivalence proof or CT proof.

Sources: m55_slothy.pdf §§4.1–4.8,4.11–4.13,7.5 and
m55_ntt-ftt_opt.pdf §§6.4.2,6.4.5 in REFERENCE.
