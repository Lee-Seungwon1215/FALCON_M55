# Stage B: FN-DSA M4 implementation on NUCLEO-N657X0-Q

Status (2026-09-10): startup fixed by a local linker + early-scrub adaptation.
Two pilot resets passed both FN-DSA sizes; the second also records ECC checks
enabled before/after execution. The 100-call-per-operation run completed:
600 measured calls, all host digests and tamper checks PASS, zero fault flags.
See [result.md](result.md) and [workaround](diagnostics/workaround.md).
The old failing `build/` and `audit/` remain intact for diagnostic reproduction.
The new build is `build-dtcm/`, with independent `audit-dtcm/`.

- Crypto source is compiled directly from `../ref`, commit
  `a5f15894bf1a68017074650d5298cecf9bb29a79`, retaining the existing M55
  compatibility check in `inner.h`. All five M4 assembly files remain enabled.
- Environment reference: `pq-code-package/mlkem-native` commit
  `637d076aa113d8faaec2277ed4a46b657acaf35f` (2026-09-07).
- Its Nucleo configuration, overlay, startup/SWO shim and RAM-loading runner
  are reused from the pinned checkout in `env/`. A local adapter adds early
  startup fault capture and ECC register reads. Upstream source is not edited.
  The early reset hook is link-wrapped to preserve direct-loaded DTCM data.
- ITCM vectors/code: 256 KiB at `0x10000000`; DTCM global constants, initialized
  data, BSS/stack: 256 KiB at `0x30000000`; 64 KiB main stack. Inline literals
  remain with text. This differs from upstream's constants/data LMA in ITCM.
  No Flash write or erase, no ECC disable, no cryptographic source change.
- CPU/SYSCLK/HCLK: 800/400/200 MHz verified from runtime registers; CCR confirms
  I/D caches off (despite CONFIG_ICACHE/DCACHE=y capability settings).
- GNU Arm 15.2.Rel1, Zephyr 4.4.1, `-O3`; architecture/ABI and cache settings
  follow the upstream-generated configuration, with any necessary exception
  recorded explicitly, never silently claimed identical.
- Pinned OpenOCD `4e9b167` is built under `env/openocd-4e9b167`; this does not
  replace any global or pre-existing debugger installation.
- Each degree (512/1024) and operation (keygen/sign/verify): 10 batches;
  each batch uses 10 warmups then 10 measured invocations on the same input.
  The 10 input sets differ across batches. `k_cycle_get_64()` times a whole
  10-call block. Upper median of 10 block totals divided by 10 matches the
  upstream statistic. This is **not 100 independent input trials**.
- Public deterministic seeds are the same generator as the previous FN-DSA
  tests; message `blah`, raw hash mode, empty context. Internal API retries
  are included; seed preparation, SHAKE output audit, tamper checks and SWO
  logging are outside timing. Host output digests must match the board.
- `CONFIG_FPU=y` is an explicit FN-DSA application requirement for the retained
  M4 assembly's FP-register storage. Upstream default OPT=0 does not request
  it; its OPT=1 FIPS202 MVE backend does. No native-double arithmetic is added.
- Generated `.config` comparison against upstream OPT=1 shows only the
  absence of `CONFIG_FIPS202_MVE_BACKEND=y`. Compiler-generated MVE integer
  instructions are present in the C implementation; this is not a `nomve`
  baseline. See `audit-dtcm/mve_static_sites.json` (static counts, not profiling).
- M4 stage A runs separately in `../../fn-dsa_m4/measurement_stage_a`. A and B
  differ in memory, clocks, toolchain, OS/timer and statistics. A-to-B is not
  a controlled measurement of the core alone or of a new cryptographic
  optimization. Future M55 optimizations should use B as their baseline.

Build: `bash build.sh` from this directory. Hardware runs require the exact
M55 probe serial `003C00223335510735383531` and a separate GDB port (3349).
Final build, checksums, raw logs, source diff and result summary will be kept
here and linked from `../result.md`.

Run `source env/environment.sh`, `bash build.sh`, `python audit_build.py`,
then `python run.py pilot` and `python run.py full`. Full requires a valid
pilot for the exact ELF and loader adapter. The ELF directly loads both TCMs;
do not use a single flat BIN across their 512 MiB address gap.
Historical CPU-copy experiments are not compatible with the new sparse ELF.
`diagnose_startup.py` stops before main and cannot produce benchmark results.
Its optional memcpy relocation is diagnostic only, not part of the B firmware.
