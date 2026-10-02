#!/bin/bash
# Build the complete ntt_opt tree after stage-4 promotion; no candidate includes.
set -euo pipefail
STAGE4_DIR="$(cd "$(dirname "$0")" && pwd)"
MEASUREMENT_DIR="$STAGE4_DIR/../measurement_mlkem_native"
source "$MEASUREMENT_DIR/env/environment.sh"
unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
cmake -S "$MEASUREMENT_DIR/app" -B "$MEASUREMENT_DIR/build-ntt-opt-stage4" -G Ninja \
  -DBOARD=nucleo_n657x0_q \
  -DFNDSA_SOURCE_DIR="$STAGE4_DIR/../ntt_opt" \
  -DFNDSA_MQ_ASM=mq_cm55 -DFNDSA_KGEN_MP31_ASM=kgen_mp31_cm55 \
  -DCONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/prj.conf" \
  -DEXTRA_CONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.conf;$MEASUREMENT_DIR/app/fndsa.conf" \
  -DDTC_OVERLAY_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.overlay" \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
  -DCMAKE_C_FLAGS= -DCMAKE_CXX_FLAGS= -DCMAKE_ASM_FLAGS= -DCMAKE_EXE_LINKER_FLAGS=
cmake --build "$MEASUREMENT_DIR/build-ntt-opt-stage4" -j 4
# Keep the sparse ELF. The generated flat BIN contains a 512 MiB address gap.
cmake -E rm -f "$MEASUREMENT_DIR/build-ntt-opt-stage4/zephyr/zephyr.bin"
