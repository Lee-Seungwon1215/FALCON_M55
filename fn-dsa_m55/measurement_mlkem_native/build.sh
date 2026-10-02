#!/bin/bash
set -euo pipefail
MEASUREMENT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$MEASUREMENT_DIR/env/environment.sh"
unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
cmake -S "$MEASUREMENT_DIR/app" -B "$MEASUREMENT_DIR/build-dtcm" -G Ninja \
  -DBOARD=nucleo_n657x0_q \
  -DCONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/prj.conf" \
  -DEXTRA_CONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.conf;$MEASUREMENT_DIR/app/fndsa.conf" \
  -DDTC_OVERLAY_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.overlay" \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
  -DCMAKE_C_FLAGS= -DCMAKE_CXX_FLAGS= -DCMAKE_ASM_FLAGS= -DCMAKE_EXE_LINKER_FLAGS=
cmake --build "$MEASUREMENT_DIR/build-dtcm" -j 6
# The SoC forces BIN output for signing. This RAM-only image has two sparse
# address regions; discard its generated 512 MiB gap-filled flat artifact.
# Use zephyr.elf, not a single flat .bin, for GDB loading.
cmake -E rm -f "$MEASUREMENT_DIR/build-dtcm/zephyr/zephyr.bin"
