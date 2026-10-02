#!/bin/bash
# M1-improve is compiled directly from its own source tree.
set -euo pipefail
STAGE_DIR="$(cd "$(dirname "$0")" && pwd)"
MEASUREMENT_DIR="$STAGE_DIR/../../measurement_mlkem_native"
source "$MEASUREMENT_DIR/env/environment.sh"
unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
case "${1:-}" in
  m1_improve)
    BUILD_DIR="$MEASUREMENT_DIR/build-ntru-m1-improve"
    SELFTEST=OFF
    SIGNED_SELFTEST=OFF
    ;;
  m1_improve_audit)
    BUILD_DIR="$MEASUREMENT_DIR/build-ntru-m1-improve-audit"
    SELFTEST=ON
    SIGNED_SELFTEST=ON
    ;;
  *)
    echo "usage: $0 {m1_improve|m1_improve_audit}" >&2
    exit 2
    ;;
esac
cmake -S "$MEASUREMENT_DIR/app" -B "$BUILD_DIR" -G Ninja \
  -DBOARD=nucleo_n657x0_q \
  -DFNDSA_SOURCE_DIR="$STAGE_DIR/M1_improve" \
  -DFNDSA_MQ_ASM=mq_cm55 -DFNDSA_KGEN_MP31_ASM=kgen_mp31_cm55 \
  -DFNDSA_MP31_SELFTEST="$SELFTEST" \
  -DFNDSA_MP31_SIGNED_SELFTEST="$SIGNED_SELFTEST" \
  -DCONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/prj.conf" \
  -DEXTRA_CONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.conf;$MEASUREMENT_DIR/app/fndsa.conf" \
  -DDTC_OVERLAY_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.overlay" \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
  -DCMAKE_C_FLAGS= -DCMAKE_CXX_FLAGS= -DCMAKE_ASM_FLAGS= \
  -DCMAKE_EXE_LINKER_FLAGS=
cmake --build "$BUILD_DIR" -j 4
# Generated sparse image only; retain ELF and MAP.
cmake -E rm -f "$BUILD_DIR/zephyr/zephyr.bin"
