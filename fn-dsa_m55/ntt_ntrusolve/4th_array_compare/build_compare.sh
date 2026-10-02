#!/bin/bash
# Build the complete D0 layout control, with D1's identical board settings.
set -euo pipefail
STAGE_DIR="$(cd "$(dirname "$0")" && pwd)"
MEASUREMENT_DIR="$(cd "$STAGE_DIR/../.." && pwd)/measurement_mlkem_native"
SOURCE_DIR="$STAGE_DIR/experiments/d0_layout/source"
PROFILE_DIR="$STAGE_DIR/experiments/d0_layout/profiling"
case "${1:-}" in
  perf) SELFTEST=OFF ;;
  audit) SELFTEST=ON ;;
  *) echo "usage: bash $0 {perf|audit}" >&2; exit 2 ;;
esac
source "$MEASUREMENT_DIR/env/environment.sh"
unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
BUILD_DIR="$PROFILE_DIR/build/stage4-m55-$1"
python3 "$STAGE_DIR/compare_tools.py" prepare "$1"
cmake -S "$MEASUREMENT_DIR/app" -B "$BUILD_DIR" -G Ninja \
  -DBOARD=nucleo_n657x0_q -DFNDSA_SOURCE_DIR="$SOURCE_DIR" \
  -DFNDSA_MQ_ASM=mq_cm55 -DFNDSA_KGEN_MP31_ASM=kgen_mp31_cm55 \
  -DFNDSA_MP31_SELFTEST="$SELFTEST" -DFNDSA_MP31_SIGNED_SELFTEST="$SELFTEST" \
  -DCONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/prj.conf" \
  -DEXTRA_CONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.conf;$MEASUREMENT_DIR/app/fndsa.conf" \
  -DDTC_OVERLAY_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.overlay" \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_C_FLAGS= -DCMAKE_CXX_FLAGS= \
  -DCMAKE_ASM_FLAGS= -DCMAKE_EXE_LINKER_FLAGS=
cmake --build "$BUILD_DIR" -j 4
cmake -E rm -f "$BUILD_DIR/zephyr/zephyr.bin"
python3 "$STAGE_DIR/compare_tools.py" record "$1"
