# process_block phase measurement

This harness targets the archived C9 mixed implementation (SHA-256
`94f441fffa66e32adecd6d6c69b46b37583bee62607c764ccd0813aa3772361a`).
Its results are historical, not a phase profile of the newer full-MVE source.
The generator deliberately refuses other versions; the phase boundaries must
be redesigned before profiling a different implementation.

This directory is an isolated measurement harness, not a production variant.
`generate.py` reads the local production `sha3_cm55.s` and adds timestamps only
to its generated copy. It retains the existing correctness/ABI/SHAKE oracles.

Run from the repository root:

```sh
bash fn-dsa_m55/keccak_shake/validation/phase_profile/build.sh plain
bash fn-dsa_m55/keccak_shake/validation/phase_profile/build.sh trace
python3 fn-dsa_m55/keccak_shake/validation/phase_profile/run.py plain
python3 fn-dsa_m55/keccak_shake/validation/phase_profile/run.py trace
```

`run.py` requires hardware access, uses shared board locks and only targets the
pinned N657. It refuses stale source/ELF inputs, archives each run, and validates
correctness, clock/cache/TCM/ECC/fault registers. Use `analyze.py` with valid
result directories as arguments to regenerate `summary.json`.

Read [result.md](result.md) for raw intervals, subtraction rules, full call
comparison, and limitations of intrusive phase profiling. No SLOTHY or new
cryptographic optimization was applied in this experiment.
