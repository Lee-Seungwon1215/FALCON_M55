# Frozen stage-3 baseline

Saved before promoting S1B_S2B_S3A into `fn-dsa_m55/ntt_opt` on 2026-09-13.

- `source/`: all previous top-level C/H/S files and its original README.
- `build/zephyr/zephyr.elf`: the previous linked firmware, not a rebuild.
- `build/zephyr/.config`, `build/compile_commands.json`, and the MQ object:
  enough to validate the original configuration, options and MQ function bytes.
- This is an artifact snapshot, **not a self-contained CMake build directory**.
  The compile database retains the original source/build path names as provenance.

The stage-3 `ntt_opt` runner entry and the stage-4 `baseline` entries now use
this frozen source/ELF pair. Their old result files and raw logs are unchanged.
The active promoted code is built separately in
`fn-dsa_m55/measurement_mlkem_native/build-ntt-opt-stage4`.

Original assembly SHA-256:
`b4f5834ac4cb72c6d51f62bf4c9746b58350e668ebcb193bf1e51272ae9fbbc3`.

Original ELF SHA-256:
`0a6e2474a2081f0e6ff493f028124df32200ac8fcade17a5707f5bb7a1e2839a`.

The source tree and ELF hashes still match the historical stage-4 baseline
`combinations/results/baseline/full_validated.json` record.
