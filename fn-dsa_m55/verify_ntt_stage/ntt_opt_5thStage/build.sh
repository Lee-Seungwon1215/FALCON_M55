#!/bin/bash
# Select a complete independent source tree; never compose candidate assembly.
set -euo pipefail
STAGE5_DIR="$(cd "$(dirname "$0")" && pwd)"
MEASUREMENT_DIR="$STAGE5_DIR/../measurement_mlkem_native"
CANDIDATE="${1:?usage: bash build.sh ref|slothyA|slothyB}"
case "$CANDIDATE" in ref|slothyA|slothyB) ;; *) exit 2 ;; esac
source "$MEASUREMENT_DIR/env/environment.sh"
unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
STAGE5_BUILD="$STAGE5_DIR/build/$CANDIDATE"
cmake -S "$MEASUREMENT_DIR/app" -B "$STAGE5_BUILD" -G Ninja \
  -DBOARD=nucleo_n657x0_q \
  -DFNDSA_SOURCE_DIR="$STAGE5_DIR/$CANDIDATE" -DFNDSA_MQ_ASM=mq_cm55 \
  -DCONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/prj.conf" \
  -DEXTRA_CONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.conf;$MEASUREMENT_DIR/app/fndsa.conf" \
  -DDTC_OVERLAY_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.overlay" \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
  -DCMAKE_C_FLAGS= -DCMAKE_CXX_FLAGS= -DCMAKE_ASM_FLAGS= -DCMAKE_EXE_LINKER_FLAGS=
cmake --build "$STAGE5_BUILD" -j 4
# The flat BIN contains a 512 MiB address gap; board loading uses sparse ELF.
cmake -E rm -f "$STAGE5_BUILD/zephyr/zephyr.bin"
