# Isolated mlkem-native Nucleo build environment

Prepared on 2026-09-09 for the FN-DSA M55 B-stage baseline. This directory
contains build dependencies and build-only upstream verification artifacts.
No board access, reset, programming, flashing, or execution was performed while
preparing this environment. `fn-dsa_m55/ref` was not changed.

## Enter the environment

```sh
source /Users/seungwon/FALCON/fn-dsa_m55/measurement_mlkem_native/env/environment.sh
```

This sets the pinned Zephyr/module/toolchain variables and prepends only the
project-local Python tools and Arm toolchain to the current shell's PATH.
No global installation or shell-profile modification is required. The
`cmsis_6` alias is intentional: CMSIS module metadata obtains its module name
from its directory basename, so the hash-suffixed source-directory name must
not be supplied directly as the Zephyr module path.

## Source identity and verification

Source settings are taken from mlkem-native commit
`637d076aa113d8faaec2277ed4a46b657acaf35f` and its `nix/zephyr/default.nix`.
The source trees were fetched as fixed GitHub archives, not live branches.
Unpacked NAR SHA-256 hashes were recomputed using `verify_nar_hash.py` and all
three matched the source hashes in the upstream Nix definition.

| Component | Version / revision | Verified NAR SHA-256 |
|---|---|---|
| Zephyr | v4.4.1 | `sha256-8bzykJs6fFGiofCxRKh8M9jdXr5R8FM0lAbA28yanGk=` |
| CMSIS_6 | `30a859f44ef8ab4dc8f84b03ed586fd16ccf9d74` | `sha256-nTehISN0pu9gnOZMpGaBQ3DFmNxAqAZPGpvbKfEM35o=` |
| hal_stm32 | `fc11896dd39cfca37bf9b4aeaaa2df8861b81875` | `sha256-AtNq2yTZsTFMTlWn/Ns0wuEiN4Wv/OTV2vWPRu0SnOE=` |

The CMSIS archive at the ARM-software URL and the canonical Zephyr fork URL
were byte-identical (archive SHA-256
`2abdac3b892f0c9786bd15fc18728aa05463d919df726f9a837ed51457975bd3`).

Toolchain download:

<https://developer.arm.com/-/media/Files/downloads/gnu/15.2.rel1/binrel/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi.tar.xz>

The downloaded archive's SHA-256 was verified as
`1938a84b7105c192e3fb4fa5e893ba25f425f7ddab40515ae608cd40f68669a8`, matching
`pkgs/by-name/gc/gcc-arm-embedded-15/package.nix` in nixpkgs commit
`6b316287bae2ee04c9b93c8c858d930fd07d7338`.

- GCC: Arm GNU Toolchain 15.2.Rel1, build arm-15.86, **15.2.1 20251203**.
- GDB: same distribution, **16.3.90.20250906-git**.
- Local host build tools: CPython **3.12.14**, CMake **3.31.6**, Ninja wheel
  **1.13.2** (`1.13.2.git.kitware.jobserver-pipe-1`).
- Host Python dependencies match the upstream required package set. Host-tool
  package versions were installed manually, not from a Nix store closure;
  byte-for-byte Nix-environment identity is not claimed.

## Build-only upstream checks

The unchanged upstream `bench_512` target built successfully for both `OPT=0`
and `OPT=1`, with `AUTO=0`, `CYCLES=NO`,
`EXTRA_MAKEFILE=test/zephyr/platform.mk`, and
`ZEPHYR_TARGET=nucleo-n657x0-q`. The `bench_512` target only builds; it does
not invoke the board runner. `build_upstream_bench_only.sh` reproduces OPT=0.

For each mode, inspect:

```text
upstream-build-opt{0,1}/zephyr/nucleo-n657x0-q/bench_mlkem512/
  zephyr/.config
  zephyr/zephyr.elf
  zephyr/zephyr.map
  zephyr/zephyr.dts
  build.ninja
  build.log
```

ELF SHA-256 values:

- OPT=0: `616771b78c9635ffa6cb6e0d4d1639284cfd535435008177dea8fc4a25908f21`
- OPT=1: `24e7aa33056b21797af7f8875060e0cebe49472f016fb144a50b114ff9dba802`

The first failed configuration attempt is retained under `upstream-build/`.
It used a hash-suffixed CMSIS module path; this was resolved with the aliases
above and new build directories, without editing upstream sources.

## Final generated settings

Both builds have ITCM-linked text/rodata at `0x10000000` and DTCM-linked
runtime data/BSS/stacks at `0x30000000`. Each declared region is 256 KiB;
`CONFIG_MAIN_STACK_SIZE=65536`. The linker summary calls the chosen regions
`FLASH` and `RAM`, but their addresses correspond to the TCMs, not external
flash or AXISRAM. Initial data load images are located in ITCM.

Both builds generated these settings:

- `CONFIG_SYS_CLOCK_HW_CYCLES_PER_SEC=800000000`
- `CONFIG_SYS_CLOCK_TICKS_PER_SEC=10000`
- `CONFIG_CORTEX_M_SYSTICK_64BIT_CYCLE_COUNTER=y`
- `CONFIG_TICKLESS_KERNEL=y`
- `CONFIG_ARM_MPU=y`, `CONFIG_HW_STACK_PROTECTION=y`
- `CONFIG_ICACHE=y`, `CONFIG_DCACHE=y` (support enabled)
- **`CONFIG_CACHE_MANAGEMENT` not set**
- `CONFIG_INIT_ARCH_HW_AT_BOOT=y`
- `CONFIG_COMPILER_OPT="-O3"`; source-level final `-O3` follows Zephyr's `-O2`.

The cache-support flags do not prove cache activation. The configured startup
path directly disables I/D caches in `z_arm_init_arch_hw_at_boot`, and the SoC
cache-enable wrappers compile to no-ops without `CONFIG_CACHE_MANAGEMENT`.
This is the verified build/startup behavior; physical register state must still
be checked by the board owner during the actual FN-DSA measurement.

Differences between the upstream modes:

| Setting | OPT=0 | OPT=1 |
|---|---|---|
| FIPS202 MVE backend | Off | On |
| `CONFIG_FPU` | Not set | y |
| `CONFIG_FPU_SHARING` | Not active | y |
| FP ABI compiler flag | No explicit flag (soft default) | `-mfloat-abi=hard` |
| FPU compiler flag | None | `-mfpu=fpv5-sp-d16` |
| `-mcpu` | cortex-m55 | cortex-m55 |

Both configurations select MVEI/MVEF architecture support, but OPT=0 disables
FP coprocessor access in Zephyr startup. FN-DSA's M4 assembly uses FP registers
as storage, so it requires FPU access even though the arithmetic remains
integer-based FP64 emulation. Reusing the upstream OPT=1 FPU/ABI setup is a
compatible available upstream execution mode; no ML-KEM MVE routine needs to
be copied into FN-DSA. The upstream SP-only FPU compiler flag must not be
misdescribed as native-double compilation.

The builds use Zephyr minimal libc and do not enable
`CONFIG_MINIMAL_LIBC_LL_PRINTF`; FN-DSA logging must not assume `%llu` or
`%llx` is supported. Split 32-bit output or an explicitly documented logging
configuration change is needed for 64-bit cycle values.

Warnings about an absent signing tool apply to signed boot images, not this
RAM/GDB loading workflow. The absent Git metadata warning comes from using
verified source archives. No signed flash image or hardware run was attempted.

## FN-DSA B configuration cross-check

The root agent's `../build/zephyr/.config` was compared directly against the
upstream OPT=1 final `.config`. The **only difference** was the absence of
`CONFIG_FIPS202_MVE_BACKEND=y`, the ML-KEM-specific backend switch. All other
Zephyr config lines were identical. FN-DSA enables `CONFIG_FPU=y` in its own
application fragment rather than through the ML-KEM-specific Kconfig symbol.

Machine-readable source/tool/build provenance is in `manifest.json` and the
installed host Python packages are pinned in `python-requirements.lock`.

Post-build verification found generated files only in Zephyr's
`.cache/ToolchainCapabilityDatabase` and no missing archive members. Excluding
that generated `.cache` directory, the complete NAR source hash still matches
the initial upstream value. CMSIS and STM32 HAL NAR hashes remain identical
without exclusions. The cache was retained, not deleted or moved while other
builds might use it. To recheck Zephyr after building:

```sh
python "$FNDSA_M55_ENV/verify_nar_hash.py" "$ZEPHYR_BASE" \
  'sha256-8bzykJs6fFGiofCxRKh8M9jdXr5R8FM0lAbA28yanGk=' .cache
```

## OpenOCD reference cross-check and isolated pinned build

The upstream `nix/openocd/default.nix` pins **openocd-org/openocd**, not an ST
fork, to `4e9b167e1ae5ccb437eb0538440988b3f0ec53cb` (label
`unstable-2026-05-01`), including submodules. The source and pinned submodules
were fetched during follow-up preparation. Before bootstrap, the complete NAR
hash was verified as `sha256-8aYl7JzulPxH6vgSeTKTMIZVH6d55JJlXTBkfgAPTbU=`,
excluding only Git metadata. The submodules are jimtcl
`f160866171457474f7c4d6ccda70f9b77524407e` and libjaylink
`0d23921a05d5d427332a142d154c213d0c306eb1`.

The pinned `tcl/target/stm32n6x.cfg` was downloaded and compared with
`/private/tmp/falcon-openocd/share/openocd/scripts/target/stm32n6x.cfg`.
The only difference is the `dap create` argument spelling: upstream uses
`-chain-position`, while the installed copy uses `-tap`. Security helper
procedures and examine-end/halted event handlers are identical. The helper
`stm32n6x_ahb_ap_secure_access` selects AP 1 and sets its CSW to secure
privileged access with `apcsw 0x0B000000 0x4F000000`. This comparison does not
prove OpenOCD binary behavior is identical; the previous installed binary is a
different revision. That previous debugger and its scripts were not modified.

A separate original-pinned debugger was built and installed successfully:

```text
Executable: env/openocd-4e9b167/bin/openocd
Scripts:    env/openocd-4e9b167/share/openocd/scripts
Source:     env/openocd-4e9b167-src
Build:      env/openocd-4e9b167-build
Build log:  env/openocd-pinned-build.log
```

Version: `0.12.0+dev-g4e9b167 (2026-09-09-11:52)`.
Executable SHA-256:
`f6c974ee4284f138d28423fe2e68d1bc7e1953f0229c5cf0ab00cd2d0f2a4d13`.
The installed `stm32n6x.cfg` is byte-identical to the pinned downloaded file.
Tracked Git source changes after bootstrap/build: none.

`build_openocd_pinned.sh` documents the build. Existing read-only host tools
and libusb in `/private/tmp/falcon-tools` were reused. The executable depends
on `/private/tmp/falcon-tools/lib/libusb-1.0.0.dylib`, and `--version` executes
successfully. Host configure options explicitly enable ST-Link, internal
jimtcl and libjaylink; the old debugger installation is untouched. No board
access was performed for this build or version check.

The C implementations in both pinned `4e9b167` and previous `046c040` have the
same important behavior: the `arp_examine` command's `handle_target_examine`
calls the target-specific examine callback but **does not dispatch the
`examine-end` event**. The separate `target_examine_one` function does dispatch
that event. Therefore, replacing the binary alone does not guarantee that an
explicit `-defer-examine; init; cpu arp_examine` sequence invokes the target
script's secure-AP setup. Board orchestration must account for this behavior.
