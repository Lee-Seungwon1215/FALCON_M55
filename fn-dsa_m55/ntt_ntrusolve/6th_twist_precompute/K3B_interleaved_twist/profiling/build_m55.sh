#!/bin/bash
# Build this source tree, using the same pinned board harness as latest L2.
set -euo pipefail
PROFILE_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="$(cd "$PROFILE_DIR/.." && pwd)"
MEASUREMENT_DIR="$(cd "$PROFILE_DIR/../../../.." && pwd)/measurement_mlkem_native"
case "${1:-}" in
  perf) SELFTEST=OFF ;;
  audit) SELFTEST=ON ;;
  *) echo "usage: bash $0 {perf|audit}" >&2; exit 2 ;;
esac
source "$MEASUREMENT_DIR/env/environment.sh"
unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
BUILD_DIR="$PROFILE_DIR/build/k3b-interleaved-twist-m55-$1"
python3 "$PROFILE_DIR/m55.py" prepare "$1"
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
# Same as L2: discard only the generated sparse binary, retaining ELF/MAP.
cmake -E rm -f "$BUILD_DIR/zephyr/zephyr.bin"
python3 "$PROFILE_DIR/m55.py" record "$1"
