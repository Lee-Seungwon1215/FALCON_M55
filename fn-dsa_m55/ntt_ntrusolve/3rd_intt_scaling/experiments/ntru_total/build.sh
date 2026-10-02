#!/bin/bash
# Diagnostic ONLY: NTRU entry/exit timing in generated C, never release sources.
set -euo pipefail
TASK_DIR="$(cd "$(dirname "$0")" && pwd)"
STAGE_DIR="$(cd "$TASK_DIR/../.." && pwd)"
WORK_DIR="$(cd "$STAGE_DIR/../.." && pwd)"
case "${1:-}" in
  h0_layout) SOURCE_DIR="$STAGE_DIR/experiments/h0_layout/source" ;;
  h1) SOURCE_DIR="$STAGE_DIR/H1_final_scaling" ;;
  *) echo "usage: bash $0 {h0_layout|h1}" >&2; exit 2 ;;
esac
COMMON_MEAS="$WORK_DIR/measurement_mlkem_native"
source "$COMMON_MEAS/env/environment.sh"
unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
BUILD_DIR="$TASK_DIR/$1/build/control"
GEN_DIR="$BUILD_DIR/generated"
python3 -B "$TASK_DIR/run.py" "$1" --prepare-build
python3 -B "$WORK_DIR/ntru_profile/instrument.py" "$SOURCE_DIR" "$GEN_DIR" control
cmake -S "$TASK_DIR" -B "$BUILD_DIR" -G Ninja \
  -DBOARD=nucleo_n657x0_q -DFNDSA_SOURCE_DIR="$SOURCE_DIR" \
  -DFNDSA_GENERATED_DIR="$GEN_DIR" -DFNDSA_COMMON_MEAS="$COMMON_MEAS" \
  -DPROFILE_CANDIDATE=control \
  -DCONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/prj.conf" \
  -DEXTRA_CONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.conf;$COMMON_MEAS/app/fndsa.conf" \
  -DDTC_OVERLAY_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.overlay" \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_C_FLAGS= -DCMAKE_CXX_FLAGS= \
  -DCMAKE_ASM_FLAGS= -DCMAKE_EXE_LINKER_FLAGS=
cmake --build "$BUILD_DIR" -j 4
cmake -E rm -f "$BUILD_DIR/zephyr/zephyr.bin"
python3 -B "$TASK_DIR/run.py" "$1" --record-build
