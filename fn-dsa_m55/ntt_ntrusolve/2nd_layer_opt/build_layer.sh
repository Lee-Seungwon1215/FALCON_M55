#!/bin/bash
# Build one complete, independent source directory. Layer plans live in .s.
set -euo pipefail
STAGE_DIR="$(cd "$(dirname "$0")" && pwd)"
MEASUREMENT_DIR="$STAGE_DIR/../../measurement_mlkem_native"
source "$MEASUREMENT_DIR/env/environment.sh"
unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
case "${1:-}" in
  l2|l2_audit) SOURCE_DIR="$STAGE_DIR/L2_two_layer" ;;
  l3|l3_audit) SOURCE_DIR="$STAGE_DIR/L3_three_layer" ;;
  *) echo "usage: $0 {l2|l2_audit|l3|l3_audit}"; exit 2 ;;
esac
SELFTEST=OFF
if [[ "$1" == *_audit ]]; then SELFTEST=ON; fi
BUILD_DIR="$MEASUREMENT_DIR/build-ntru-stage2-$1"
cmake -S "$MEASUREMENT_DIR/app" -B "$BUILD_DIR" -G Ninja \
  -DBOARD=nucleo_n657x0_q \
  -DFNDSA_SOURCE_DIR="$SOURCE_DIR" \
  -DFNDSA_MQ_ASM=mq_cm55 -DFNDSA_KGEN_MP31_ASM=kgen_mp31_cm55 \
  -DFNDSA_MP31_SELFTEST="$SELFTEST" \
  -DFNDSA_MP31_SIGNED_SELFTEST="$SELFTEST" \
  -DCONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/prj.conf" \
  -DEXTRA_CONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.conf;$MEASUREMENT_DIR/app/fndsa.conf" \
  -DDTC_OVERLAY_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.overlay" \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
  -DCMAKE_C_FLAGS= -DCMAKE_CXX_FLAGS= -DCMAKE_ASM_FLAGS= \
  -DCMAKE_EXE_LINKER_FLAGS=
cmake --build "$BUILD_DIR" -j 4
# Remove only the generated sparse image; ELF/MAP remain available.
cmake -E rm -f "$BUILD_DIR/zephyr/zephyr.bin"
