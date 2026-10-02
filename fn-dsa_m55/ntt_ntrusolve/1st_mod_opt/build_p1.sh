#!/bin/bash
# Correctness-first l=64 Plantard experiment on NUCLEO-N657X0-Q.
set -euo pipefail

STAGE_DIR="$(cd "$(dirname "$0")" && pwd)"
MEASUREMENT_DIR="$STAGE_DIR/../../measurement_mlkem_native"
source "$MEASUREMENT_DIR/env/environment.sh"
unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS

case "${1:-}" in
  p1)
    BUILD_DIR="$MEASUREMENT_DIR/build-ntru-p1-plantard64"
    SELFTEST=OFF
    ;;
  p1_audit)
    BUILD_DIR="$MEASUREMENT_DIR/build-ntru-p1-plantard64-audit"
    SELFTEST=ON
    ;;
  *)
    echo "usage: $0 {p1|p1_audit}" >&2
    exit 2
    ;;
esac

# The first P1 implementation is the exact 32-bit-limb C baseline.  M0's
# kgen_mp31_cm55.s remains in the source tree for structural comparison but is
# deliberately not linked into this image.
cmake -S "$MEASUREMENT_DIR/app" -B "$BUILD_DIR" -G Ninja \
  -DBOARD=nucleo_n657x0_q \
  -DFNDSA_SOURCE_DIR="$STAGE_DIR/P1_improved_l64_scalar" \
  -DFNDSA_MQ_ASM=mq_cm55 -DFNDSA_KGEN_MP31_ASM= \
  -DFNDSA_MP31_SELFTEST="$SELFTEST" \
  -DFNDSA_MP31_SIGNED_SELFTEST=OFF \
  -DCONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/prj.conf" \
  -DEXTRA_CONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.conf;$MEASUREMENT_DIR/app/fndsa.conf" \
  -DDTC_OVERLAY_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.overlay" \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
  -DCMAKE_C_FLAGS= -DCMAKE_CXX_FLAGS= -DCMAKE_ASM_FLAGS= \
  -DCMAKE_EXE_LINKER_FLAGS=
cmake --build "$BUILD_DIR" -j 4
cmake -E rm -f "$BUILD_DIR/zephyr/zephyr.bin"
